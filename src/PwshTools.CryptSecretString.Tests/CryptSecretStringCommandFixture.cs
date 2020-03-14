using System;
using System.Linq;
using System.Management.Automation;
using Xunit;

namespace PwshTools.CryptSecretString.Tests
{
    public class CryptSecretStringCommandFixture
    {
        private static readonly string UnitTestSecretKey = "NUIbtZq9pK4M1T6Eash57m899jD3Zttq";
        private static readonly string UnitTestSecretIV = "c6HTL7oxzFI=";

        [Fact]
        public void Invoke_KeyとIVを引数に渡して正常に暗号化されること()
        {
            var cmdlet = new CryptSecretStringCommand()
            {
                Value = "hogehoge",
                Decrypt = new SwitchParameter(isPresent: false),
                Key = UnitTestSecretKey,
                InitializationVector = UnitTestSecretIV
            };

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.Equal("6GQG8+pOFu7Fz1Qn0LPphw==", result);
        }

        [Fact]
        public void Invoke_KeyとIVを引数に渡して正常に復号化されること()
        {
            var cmdlet = new CryptSecretStringCommand()
            {
                Value = "6GQG8+pOFu7Fz1Qn0LPphw==",
                Decrypt = new SwitchParameter(isPresent: true),
                Key = UnitTestSecretKey,
                InitializationVector = UnitTestSecretIV
            };

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.Equal("hogehoge", result);
        }

        [Fact]
        public void Invoke_KeyとIVを環境変数から取得して正常に暗号化されること()
        {
            var config = new TripleDESCryptoSecretInfoRepositoryConfig(
                key: "PwshTools.CryptSecretString.Key.Tests.Cmdlet.1",
                iv: "PwshTools.CryptSecretString.IV.Repos.Cmdlet.1"
            );
            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, UnitTestSecretKey, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, UnitTestSecretIV, EnvironmentVariableTarget.User);

            var cmdlet = new CryptSecretStringCommand(
                new TripleDESCryptoSecretInfoRepository(config)
            )
            {
                Value = "hogehoge",
                Decrypt = new SwitchParameter(isPresent: false)
            };

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.Equal("6GQG8+pOFu7Fz1Qn0LPphw==", result);

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
        }

        [Fact]
        public void Invoke_KeyとIVを環境変数から取得して正常に復号化されること()
        {
            var config = new TripleDESCryptoSecretInfoRepositoryConfig(
                key: "PwshTools.CryptSecretString.Key.Tests.Cmdlet.2",
                iv: "PwshTools.CryptSecretString.IV.Repos.Cmdlet.2"
            );
            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, UnitTestSecretKey, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, UnitTestSecretIV, EnvironmentVariableTarget.User);

            var cmdlet = new CryptSecretStringCommand(
                new TripleDESCryptoSecretInfoRepository(config)
            )
            {
                Value = "6GQG8+pOFu7Fz1Qn0LPphw==",
                Decrypt = new SwitchParameter(isPresent: true)
            };

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.Equal("hogehoge", result);

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
        }

        [Fact]
        public void Invoke_KeyとIVが引数と環境変数にない場合環境変数にKeyとIVが登録されていること()
        {
            var config = new TripleDESCryptoSecretInfoRepositoryConfig(
                key: "PwshTools.CryptSecretString.Key.Tests.Cmdlet.3",
                iv: "PwshTools.CryptSecretString.IV.Repos.Cmdlet.3"
            );
            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Assert.Null(Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User));
            Assert.Null(Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User));

            var cmdlet = new CryptSecretStringCommand(
                new TripleDESCryptoSecretInfoRepository(config)
            )
            {
                Value = "hogehoge",
                Decrypt = new SwitchParameter(isPresent: false)
            };

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.NotNull(Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User));
            Assert.NotNull(Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User));
            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
        }
    }
}

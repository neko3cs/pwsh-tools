using System;
using Xunit;

namespace PwshTools.CryptSecretString.Tests
{
    public class TripleDESCryptoSecretInfoRepositoryFixuture
    {
        [Fact]
        public void CreateInfo_正常に生成出来ること()
        {
            var config = new TripleDESCryptoSecretInfoRepositoryConfig(
                key: "PwshTools.CryptSecretString.Key.Tests.Repos.1",
                iv: "PwshTools.CryptSecretString.IV.Repos.Tests.1"
            );

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Assert.Null(Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User));
            Assert.Null(Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User));

            var info = new TripleDESCryptoSecretInfoRepository(config).CreateInfo();

            Assert.Equal(
                Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User),
                info.Key
            );
            Assert.Equal(
                Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User),
                info.IV
            );

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
        }

        [Fact]
        public void GetInfo_正常に取得できること()
        {
            var config = new TripleDESCryptoSecretInfoRepositoryConfig(
                key: "PwshTools.CryptSecretString.Key.Tests.Repos.2",
                iv: "PwshTools.CryptSecretString.IV.Tests.Repos.2"
            );

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, "TestKey", EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, "TestIV", EnvironmentVariableTarget.User);

            var info = new TripleDESCryptoSecretInfoRepository(config).GetInfo();

            Assert.Equal(
                Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User),
                info.Key
            );
            Assert.Equal(
                Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User),
                info.IV
            );

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
        }
    }
}

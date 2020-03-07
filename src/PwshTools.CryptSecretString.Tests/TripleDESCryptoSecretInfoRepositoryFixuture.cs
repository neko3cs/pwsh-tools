using System;
using Xunit;

namespace PwshTools.CryptSecretString.Tests
{
    public class TripleDESCryptoSecretInfoRepositoryFixuture
    {
        private static readonly string TripleDESCryptoKeyEnviromentVariableName = "PwshTools.CryptSecretString.Key.Tests";
        private static readonly string TripleDESCryptoIVEnviromentVariableName = "PwshTools.CryptSecretString.IV.Tests";

        // FIXME: テスト通しが影響しあってるのでシーケンシャルにする（環境変数にトランザクションは張れないので）

        [Fact]
        public void CreateInfo_正常に生成出来ること()
        {
            Environment.SetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Assert.Null(Environment.GetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User));
            Assert.Null(Environment.GetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User));

            var info = new TripleDESCryptoSecretInfoRepository().CreateInfo();

            Assert.Equal(
                Environment.GetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User),
                info.Key
            );
            Assert.Equal(
                Environment.GetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User),
                info.IV
            );
        }

        [Fact]
        public void GetInfo_正常に取得できること()
        {
            Environment.SetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, "TestKey", EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, "TestIV", EnvironmentVariableTarget.User);

            var info = new TripleDESCryptoSecretInfoRepository().GetInfo();

            Assert.Equal(
                Environment.GetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User),
                info.Key
            );
            Assert.Equal(
                Environment.GetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User),
                info.IV
            );
        }
    }
}

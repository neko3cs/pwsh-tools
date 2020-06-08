using FluentAssertions;
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
            Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User)
                .Should().BeNull();
            Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User)
                .Should().BeNull();

            var info = new TripleDESCryptoSecretInfoRepository(config).CreateInfo();

            info.Key.Should().Be(
                Environment.GetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User)
            );
            info.IV.Should().Be(
                Environment.GetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User)
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
            var testKey = "TestKey";
            var testIV = "TestIV";
            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, testKey, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, testIV, EnvironmentVariableTarget.User);

            var info = new TripleDESCryptoSecretInfoRepository(config).GetInfo();

            info.Key.Should().Be(testKey);
            info.IV.Should().Be(testIV);

            Environment.SetEnvironmentVariable(config.TripleDESCryptoKeyEnviromentVariableName, null, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(config.TripleDESCryptoIVEnviromentVariableName, null, EnvironmentVariableTarget.User);
        }
    }
}

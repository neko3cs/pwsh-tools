using System;
using System.Security.Cryptography;

namespace PwshTools.CryptSecretString
{
    public class TripleDESCryptoSecretInfoRepository
    {
        private TripleDESCryptoSecretInfoRepositoryConfig _config;

        public TripleDESCryptoSecretInfoRepository(TripleDESCryptoSecretInfoRepositoryConfig config)
        {
            _config = config;
        }

        public TripleDESCryptoSecretInfo CreateInfo()
        {
            var provider = new TripleDESCryptoServiceProvider();
            provider.GenerateKey();
            provider.GenerateIV();
            var info = new TripleDESCryptoSecretInfo
            {
                Key = Convert.ToBase64String(provider.Key),
                IV = Convert.ToBase64String(provider.IV)
            };

            Environment.SetEnvironmentVariable(_config.TripleDESCryptoKeyEnviromentVariableName, info.Key, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(_config.TripleDESCryptoIVEnviromentVariableName, info.IV, EnvironmentVariableTarget.User);

            return info;
        }

        public TripleDESCryptoSecretInfo GetInfo()
        {
            var key = Environment.GetEnvironmentVariable(_config.TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User);
            if (key is null) return null;
            var iv = Environment.GetEnvironmentVariable(_config.TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User);
            if (iv is null) return null;

            return new TripleDESCryptoSecretInfo
            {
                Key = key,
                IV = iv
            };
        }
    }
}

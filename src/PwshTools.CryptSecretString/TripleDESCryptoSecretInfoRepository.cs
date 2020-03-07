using System;
using System.Security.Cryptography;

namespace PwshTools.CryptSecretString
{
    public class TripleDESCryptoSecretInfoRepository
    {
        private static readonly string TripleDESCryptoKeyEnviromentVariableName = "PwshTools.CryptSecretString.Key";
        private static readonly string TripleDESCryptoIVEnviromentVariableName = "PwshTools.CryptSecretString.IV";

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

            Environment.SetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, info.Key, EnvironmentVariableTarget.User);
            Environment.SetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, info.IV, EnvironmentVariableTarget.User);

            return info;
        }

        public TripleDESCryptoSecretInfo GetInfo()
        {
            var key = Environment.GetEnvironmentVariable(TripleDESCryptoKeyEnviromentVariableName, EnvironmentVariableTarget.User);
            if (key is null) return null;
            var iv = Environment.GetEnvironmentVariable(TripleDESCryptoIVEnviromentVariableName, EnvironmentVariableTarget.User);
            if (iv is null) return null;

            return new TripleDESCryptoSecretInfo
            {
                Key = key,
                IV = iv
            };
        }
    }
}

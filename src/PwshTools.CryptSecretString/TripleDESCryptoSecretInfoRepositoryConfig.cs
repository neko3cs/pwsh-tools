namespace PwshTools.CryptSecretString
{
    public class TripleDESCryptoSecretInfoRepositoryConfig
    {
        public string TripleDESCryptoKeyEnviromentVariableName { get; }
        public string TripleDESCryptoIVEnviromentVariableName { get; }

        public TripleDESCryptoSecretInfoRepositoryConfig()
            : this(key: "PwshTools.CryptSecretString.Key", iv: "PwshTools.CryptSecretString.IV") { }

        public TripleDESCryptoSecretInfoRepositoryConfig(string key, string iv)
        {
            TripleDESCryptoKeyEnviromentVariableName = key;
            TripleDESCryptoIVEnviromentVariableName = iv;
        }
    }
}

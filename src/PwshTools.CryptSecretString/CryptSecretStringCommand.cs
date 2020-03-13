using System;
using System.IO;
using System.Management.Automation;
using System.Security.Cryptography;
using System.Text;

namespace PwshTools.CryptSecretString
{
    [Cmdlet("Crypt", "SecretString")]
    [OutputType(typeof(string))]
    [Alias("crypt")]
    public class CryptSecretStringCommand : Cmdlet
    {
        private TripleDESCryptoSecretInfoRepository _tripleDESCryptoSecretInfoRepository;

        [Parameter(Position = 0, Mandatory = true, ValueFromPipeline = true)]
        public string Value { get; set; }
        [Parameter(Position = 1)]
        public SwitchParameter Decrypt { get; set; }
        [Parameter(Position = 2)]
        public string Key { get; set; }
        [Parameter(Position = 3)]
        public string InitializationVector { get; set; }

        public CryptSecretStringCommand()
            : this(new TripleDESCryptoSecretInfoRepository(new TripleDESCryptoSecretInfoRepositoryConfig())) { }

        public CryptSecretStringCommand(TripleDESCryptoSecretInfoRepository repository)
        {
            _tripleDESCryptoSecretInfoRepository = repository;
        }

        protected override void BeginProcessing()
        {
            if (Key != null && InitializationVector != null) return;

            var info = _tripleDESCryptoSecretInfoRepository.GetInfo();
            if (info != null)
            {
                Key = info.Key;
                InitializationVector = info.IV;
                return;
            }

            info = _tripleDESCryptoSecretInfoRepository.CreateInfo();
            Key = info.Key;
            InitializationVector = info.IV;
        }

        protected override void ProcessRecord()
        {
            if (Decrypt.IsPresent)
            {
                WriteObject(DecryptEncryptedString(Value));
            }
            else
            {
                WriteObject(EncryptPlainString(Value));
            }
        }

        private string EncryptPlainString(string plainString)
        {
            var provider = new TripleDESCryptoServiceProvider();
            var encryptor = provider.CreateEncryptor(Convert.FromBase64String(Key), Convert.FromBase64String(InitializationVector));

            using (var memoryStream = new MemoryStream())
            using (var cryptoStream = new CryptoStream(memoryStream, encryptor, CryptoStreamMode.Write))
            {
                var bytes = Encoding.UTF8.GetBytes(plainString);
                cryptoStream.Write(bytes, 0, bytes.Length);
                cryptoStream.FlushFinalBlock();

                return Convert.ToBase64String(memoryStream.ToArray());
            }
        }

        private string DecryptEncryptedString(string encryptedString)
        {
            var provider = new TripleDESCryptoServiceProvider();
            var decryptor = provider.CreateDecryptor(Convert.FromBase64String(Key), Convert.FromBase64String(InitializationVector));

            var bytes = Convert.FromBase64String(encryptedString);
            using (var memoryStream = new MemoryStream(bytes))
            using (var cryptoStream = new CryptoStream(memoryStream, decryptor, CryptoStreamMode.Read))
            using (var streamReader = new StreamReader(cryptoStream))
            {
                return streamReader.ReadLine();
            }
        }
    }
}

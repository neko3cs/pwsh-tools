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
        public void Invoke_KeyとIVを引数に渡して状態で正常に暗号化されること()
        {
            var cmdlet = new CryptSecretStringCommand();
            cmdlet.Value = "jTQKimAzZ2mdLgKmlA0PHg==";
            cmdlet.Decrypt = new SwitchParameter(isPresent: true);
            cmdlet.Key = UnitTestSecretKey;
            cmdlet.IV = UnitTestSecretIV;

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.Equal("hogehoge", result);
        }

        [Fact]
        public void Invoke_KeyとIVを引数に渡して状態で正常に復号化されること()
        {
            var cmdlet = new CryptSecretStringCommand();
            cmdlet.Value = "hogehoge";
            cmdlet.Decrypt = new SwitchParameter(isPresent: false);
            cmdlet.Key = UnitTestSecretKey;
            cmdlet.IV = UnitTestSecretIV;

            var result = cmdlet
                .Invoke<string>()
                .Single();

            Assert.Equal("jTQKimAzZ2mdLgKmlA0PHg==", result);
        }
    }
}

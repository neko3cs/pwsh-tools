using System;
using Xunit;

namespace PwshTools.SetEnvironmentVariable.Tests
{
    public class SetEnvironmentVariableCommandFixture
    {
        [Fact]
        public void Invoke_正常に値を設定できること()
        {
            // 整数、文字列、ブール値、時間
        }

        [Fact]
        public void Invoke_正常に値を削除できること()
        {
            // null を設定したら消えるはず
        }
    }
}

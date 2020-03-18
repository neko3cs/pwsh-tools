using FluentAssertions;
using System;
using Xunit;

namespace PwshTools.SetEnvironmentVariable.Tests
{
    public class SetEnvironmentVariableCommandFixture
    {
        [Fact]
        public void Invoke_正常に整数値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.1";
            var value = 1000;

            Environment.SetEnvironmentVariable(key, value.ToString(), EnvironmentVariableTarget.User);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value.ToString()
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            actual.Should().Be(value.ToString());
        }

        [Fact]
        public void Invoke_正常に半角文字列値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.2";
            var value = "hogehoge";

            Environment.SetEnvironmentVariable(key, value, EnvironmentVariableTarget.User);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            actual.Should().Be(value);
        }

        [Fact]
        public void Invoke_正常に全角文字列値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.3";
            var value = "ほげほげ";

            Environment.SetEnvironmentVariable(key, value, EnvironmentVariableTarget.User);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            actual.Should().Be(value);
        }

        [Fact]
        public void Invoke_正常に真偽値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.4";
            var value = false;

            Environment.SetEnvironmentVariable(key, value.ToString(), EnvironmentVariableTarget.User);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value.ToString()
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            actual.Should().Be(value.ToString());
        }

        [Fact]
        public void Invoke_正常に日時型値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.5";
            var value = DateTime.Now;

            Environment.SetEnvironmentVariable(key, value.ToString(), EnvironmentVariableTarget.User);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value.ToString()
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            actual.Should().Be(value.ToString());
        }

        [Fact]
        public void Invoke_正常に値を削除できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.6";
            var value = "ほげほげ";

            Environment.SetEnvironmentVariable(key, value.ToString(), EnvironmentVariableTarget.User);
            var beforeDelete = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            beforeDelete.Should().Be(value);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = null
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.User);
            actual.Should().BeNull();
        }

        [Fact]
        public void Invoke_正常にプロセス環境変数に値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.7";
            var value = "ほげほげ";

            Environment.SetEnvironmentVariable(key, value, EnvironmentVariableTarget.Process);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value,
                EnvironmentVariableTarget = EnvironmentVariableTarget.Process
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.Process);
            actual.Should().Be(value);
        }

        [Fact]
        public void Invoke_正常にシステム環境変数に値を設定できること()
        {
            var key = "PwshTools.SetEnvironmentVariable.Tests.8";
            var value = "ほげほげ";

            Environment.SetEnvironmentVariable(key, value, EnvironmentVariableTarget.Machine);

            var cmdlet = new SetEnvironmentVariableCommand()
            {
                Key = key,
                Value = value,
                EnvironmentVariableTarget = EnvironmentVariableTarget.Machine
            };
            cmdlet.Invoke();

            var actual = Environment.GetEnvironmentVariable(key, EnvironmentVariableTarget.Machine);
            actual.Should().Be(value);
        }
    }
}

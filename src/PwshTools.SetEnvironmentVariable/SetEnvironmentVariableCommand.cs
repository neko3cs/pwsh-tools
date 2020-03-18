using System;
using System.Management.Automation;

namespace PwshTools.SetEnvironmentVariable
{
    [Cmdlet(VerbsCommon.Set, "EnvironmentVariable")]
    [OutputType(typeof(void))]
    [Alias("export")]
    public class SetEnvironmentVariableCommand : Cmdlet
    {
        [Parameter(Position = 0, Mandatory = true, ValueFromPipeline = true)]
        public string Key { get; set; }
        [Parameter(Position = 1, Mandatory = true, ValueFromPipeline = true)]
        public string Value { get; set; }
        [Parameter(Position = 2)]
        public EnvironmentVariableTarget EnvironmentVariableTarget { get; set; } = EnvironmentVariableTarget.User;

        protected override void ProcessRecord()
        {
            if (string.IsNullOrEmpty(Value) || string.IsNullOrWhiteSpace(Value)) return;

            Environment.SetEnvironmentVariable(Key, Value, EnvironmentVariableTarget);
        }
    }
}

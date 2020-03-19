using System;
using System.Management.Automation;

namespace PwshTools.CompressArchive
{
    [Cmdlet(VerbsData.Compress, "ArchiveWithPassword")]
    [OutputType(typeof(string))]
    [Alias("zip")]
    public class CompressArchiveWithPasswordCommand : Cmdlet
    {
        [Parameter(
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        public string[] Path { get; set; }

        [Parameter(
            Position = 1,
            ValueFromPipeline = false,
            ValueFromPipelineByPropertyName = true
        )]
        public string DestinationPath { get; set; }

        protected override void BeginProcessing()
        {
            base.BeginProcessing();
        }

        protected override void ProcessRecord()
        {
            base.ProcessRecord();
        }

        protected override void EndProcessing()
        {
            base.EndProcessing();
        }
    }
}

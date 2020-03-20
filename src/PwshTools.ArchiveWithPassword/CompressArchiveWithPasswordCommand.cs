using System;
using System.IO;
using System.Linq;
using System.Management.Automation;
using ICSharpCode.SharpZipLib.Zip;

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
        public string DirPath { get; set; }

        [Parameter(
            Position = 1,
            ValueFromPipeline = false,
            ValueFromPipelineByPropertyName = true
        )]
        public string DestinationPath { get; set; }

        protected override void BeginProcessing()
        {
            if (!Directory.Exists(Path.GetDirectoryName(DestinationPath)))
            {
                WriteObject("ERROR: DestinationPath's parent directory is not found.");
                StopProcessing();
            }
            if (!Path.GetExtension(DestinationPath).Equals(".zip"))
            {
                WriteObject("ERROR: DestinationPath's extension is not '.zip'.");
                StopProcessing();
            }
            var pathIsDirectory = File
                .GetAttributes(DirPath)
                .HasFlag(FileAttributes.Directory);
            if (!pathIsDirectory)
            {
                WriteObject("ERROR: DirPath can be specified only directory path.");
                StopProcessing();
            }
            var fileExistsInDirectory = Directory
                .GetFiles(DirPath)
                .AsEnumerable()
                .Any();
            if (!fileExistsInDirectory)
            {
                WriteObject("ERROR: DirPath has no files.");
                StopProcessing();
            }
        }

        protected override void ProcessRecord()
        {
            var files = Directory
                .GetFiles(DirPath)
                .AsEnumerable()
                .Select(x => new FileInfo(x));
            using (var zipOutputStream = new ZipOutputStream(File.Create(DestinationPath)))
            {
                zipOutputStream.SetLevel(level: 9);
                var buffer = new byte[4096];
                var createdAt = DateTime.Now;
                foreach (var file in files)
                {
                    var entry = new ZipEntry(file.Name);
                    entry.DateTime = createdAt;
                    zipOutputStream.PutNextEntry(entry);
                    using (var fileStream = File.OpenRead(file.FullName))
                    {
                        var sourceBytes = 0;
                        do
                        {
                            sourceBytes = fileStream.Read(buffer, 0, buffer.Length);
                            zipOutputStream.Write(buffer, 0, sourceBytes);
                        } while (sourceBytes > 0);
                    }
                }
                zipOutputStream.Finish();
                zipOutputStream.Close();
            }
        }

        protected override void EndProcessing()
        {
            base.EndProcessing();
        }
    }
}

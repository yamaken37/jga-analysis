#!/usr/bin/env cwl-runner

class: CommandLineTool
id: gatk4-GenomicsDBImport-biggest-practices
label: gatk4-biggest-practices
cwlVersion: v1.2

requirements:
  ResourceRequirement:
    ramMin: 3750 # WDL："3750 MiB"
    coresMin: 1
  DockerRequirement:
    dockerPull: us.gcr.io/broad-gatk/gatk:4.5.0.0
  InitialWorkDirRequirement:
    listing:
      - entry: $(inputs.sampleDir)

baseCommand: [bash]

inputs:
  sh_file:
    type: File
    inputBinding:
      position: 0
  interval:
    type: string
    inputBinding:
      position: 1
  sample_name_map:
    type: File
    inputBinding:
      position: 2
  workspace_dir_name:
    type: string
    inputBinding:
      position: 3
  sampleDir:
    type: Directory

outputs:
  genomicsdb:
    type: File
    outputBinding:
      glob: "$(inputs.workspace_dir_name).tar"

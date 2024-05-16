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

baseCommand: [gatk]

inputs:
  workspace_dir_name:
    type: string
    inputBinding:
      position: 3
      prefix: "--genomicsdb-workspace-path"
  interval:
    type: string
    inputBinding:
      position: 5
      prefix: "-L"
  sample_name_map:
    type: File
    inputBinding:
      position: 6
      prefix: "--sample-name-map"

arguments:
  - position: 1
    prefix: --java-options
    valueFrom: "-Xms8000m -Xmx25000m"
  - position: 2
    valueFrom: GenomicsDBImport
  - position: 4
    prefix: --batch-size
    valueFrom: "50"
  - position: 7
    prefix: --reader-threads
    valueFrom: "5"
  - position: 8
    valueFrom: --merge-input-intervals
  - position: 9
    valueFrom: --consolidate && 
  - position: 10
    valueFrom: "tar -cf $(inputs.workspace_dir_name).tar $(inputs.workspace_dir_name)"

outputs:
  output_vcf:
    type: File
    outputBinding:
      glob: "$(inputs.workspace_dir_name).tar"

#!/usr/bin/env cwl-runner

class: CommandLineTool
id: GenomicsDBImport
label: gatk4-GenomicsDBImport
cwlVersion: v1.2

requirements:
  ResourceRequirement:
    ramMin: 3750 # WDL："3750 MiB"
    coresMin: 1
  DockerRequirement:
    dockerPull: us.gcr.io/broad-gatk/gatk:4.5.0.0

baseCommand: [gatk]

inputs:
  interval:
    type: String
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
  - position: 3
    prefix: --genomicsdb-workspace-path
    valueFrom: "genomicsdb"
  - position: 4
    prefix: --batch-size
    valueFrom: "50"
  - position: 7
    prefix: --reader-threads
    valueFrom: "5"
  - position: 8
    valueFrom: --merge-input-intervals
  - position: 9
    valueFrom: --consolidate
outputs:
  output_vcf:
    type: File
    outputBinding:
      glob: "$(inputs.gvcf.basename).rb.g.vcf.gz"
  output_vcf_index:
    type: File
    outputBinding:
      glob: "$(inputs.gvcf.basename).rb.g.vcf.gz.tbi"
    
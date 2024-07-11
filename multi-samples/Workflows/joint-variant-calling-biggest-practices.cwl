#!/usr/bin/env cwl-runner

class: Workflow
id: joint-variant-calling-biggest-practices
label: joint-variant-calling-biggest-practices
cwlVersion: v1.1

requirements:
  StepInputExpressionRequirement: {}

inputs:
  gatk4-GenomicsDBImport_java_options:
    type: string?
  workspace_dir_name:
    type: string
  gatk4-GenomicsDBImport_batch_size:
    type: int?
  interval:
    type: File
  sample_name_map:
    type: File
  gatk4-GenomicsDBImport_num_threads:
    type: int?
  Reblock_gVCFsDir:
    type: Directory
  # gatk4-GenomicsDBImport_xxx:
  #   type: string?

steps:
  gatk4-GenomicsDBImport-biggest-practices:
    label: gatk4-GenomicsDBImport-biggest-practices
    run: ../Tools/gatk4-GenomicsDBImport-biggest-practices.cwl
    in:
      java_options: gatk4-GenomicsDBImport_java_options
      workspace_dir_name: workspace_dir_name
      batch_size: gatk4-GenomicsDBImport_batch_size
      interval: interval
      sample_name_map: sample_name_map
      num_threads: gatk4-GenomicsDBImport_num_threads
      sampleDir: Reblock_gVCFsDir
    out:
      - genomics-db
  # xyz:
  #   label: xyz
  #   run: ../Tools/xyz.cwl
  #   in:
  #     xxx: xxx
  #   out:
  #     - yyy
outputs:
  genomics-db:
    type: Directory
    outputSource: gatk4-GenomicsDBImport-biggest-practices/genomics-db
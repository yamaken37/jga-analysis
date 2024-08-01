#!/usr/bin/env cwl-runner

class: Workflow
id: gatk4-Main-biggest-practices
label: gatk4-Main-biggest-practices
cwlVersion: v1.1

requirements:
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  gatk4-GenomicsDBImport_java_options:
    type: string?
  workspace_dir_name:
    type: string
  gatk4-GenomicsDBImport_batch_size:
    type: int?
  interval:
    type: File[]
  sample_name_map:
    type: File
  gatk4-GenomicsDBImport_num_threads:
    type: int?
  Reblock_gVCFsDir:
    type: Directory
  gatk4-GnarlyGenotyper_java_options:
    type: string?
  reference:
    type: File
    doc: FastA file for reference genome
    secondaryFiles:
      - .fai
      - ^.dict
  dbsnp_vcf:
    type: File
    doc: A dbSNP VCF file.
  idx:
    type: int[]
  gnarly_idx:
    type: int
  callset_name:
    type: string
  make_annotation_db:
    type: boolean?
  stand-call-conf:
    type: int?
  max-alternate-alleles:
    type: int?
  gatk4-VariantFiltration_java_options:
    type: string?
  targets_interval_list:
    type: File?
  filter-expression:
    type: float?
  gatk4-MakeSitesOnlyVcf_java_options:
    type: string?
  gatk4-GatherVcfs_java_options:
    type: string?

steps:
  gatk4-sub-JointCalling-biggest-practices:
    label: gatk4-sub-JointCalling-biggest-practices
    run:  ../Workflows/gatk4-sub-JointCalling-biggest-practices.cwl
    in:
      gatk4-GenomicsDBImport_java_options: gatk4-GenomicsDBImport_java_options
      workspace_dir_name: workspace_dir_name
      gatk4-GenomicsDBImport_batch_size: gatk4-GenomicsDBImport_batch_size
      interval: interval
      sample_name_map: sample_name_map
      gatk4-GenomicsDBImport_num_threads: gatk4-GenomicsDBImport_num_threads
      Reblock_gVCFsDir: Reblock_gVCFsDir
      gatk4-GnarlyGenotyper_java_options: gatk4-GnarlyGenotyper_java_options
      reference: reference
      dbsnp_vcf: dbsnp_vcf
      idx: idx
      gnarly_idx: gnarly_idx
      callset_name: callset_name
      make_annotation_db: make_annotation_db
      stand-call-conf: stand-call-conf
      max-alternate-alleles: max-alternate-alleles
      gatk4-VariantFiltration_java_options: gatk4-VariantFiltration_java_options
      targets_interval_list: targets_interval_list
      filter-expression: filter-expression
      gatk4-MakeSitesOnlyVcf_java_options: gatk4-MakeSitesOnlyVcf_java_options
    scatter: 
      - idx
      - interval
    scatterMethod: dotproduct
    out:
      - genomics-db
      - output_vcf
      - output_database
      - variant_filtered_vcf
      - sites_only_vcf
  gatk4-GatherVcfs-biggest-practices:
    label: gatk4-GatherVcfs-biggest-practices
    run:  ../Tools/gatk4-GatherVcfs-biggest-practices.cwl
    in:
      java_options: gatk4-GatherVcfs_java_options
      input_vcfs: gatk4-sub-JointCalling-biggest-practices/sites_only_vcf
      callset_name: callset_name
    out:
      - output_vcf
  gatk4-GatherVcfsIndex-biggest-practices:
    label: gatk4-GatherVcfsIndex-biggest-practices
    run:  ../Tools/gatk4-GatherVcfsIndex-biggest-practices.cwl
    in:
      input_vcf: gatk4-GatherVcfs-biggest-practices/output_vcf
    out:
      - output_vcf
  # xyz:
  #   label: xyz
  #   run:  ../Workflows/xyz.cwl
  #   in:
  #     x:y
  #   out:
  #     -
outputs:
  genomics-db:
    type: Directory
    outputSource: gatk4-sub-JointCalling-biggest-practices/genomics-db
  output_vcf:
    type: File
    outputSource: gatk4-sub-JointCalling-biggest-practices/output_vcf
    secondaryFiles:
      - .tbi
  output_database:
    type: File?
    outputSource: gatk4-sub-JointCalling-biggest-practices/output_database
    secondaryFiles:
      - .tbi
  variant_filtered_vcf:
    type: File
    outputSource: gatk4-sub-JointCalling-biggest-practices/variant_filtered_vcf
    secondaryFiles:
      - .tbi
  sites_only_vcf:
    type: File[]
    outputSource: gatk4-sub-JointCalling-biggest-practices/sites_only_vcf
    secondaryFiles:
      - .tbi
  gatk4-GatherVcfs_output_vcf:
    type: File
    outputSource: gatk4-GatherVcfs-biggest-practices/output_vcf
  gatk4-GatherVcfsIndex_output_vcf:
    type: File
    outputSource: gatk4-GatherVcfsIndex-biggest-practices/output_vcf
    secondaryFiles:
      - .tbi
  # output:
  #   type: File
  #   outputSource: xyz/output
  #   secondaryFiles:
  #     - .tbi
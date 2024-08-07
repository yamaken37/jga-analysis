#!/usr/bin/env cwl-runner

class: Workflow
id: gatk4-Main-biggest-practices
label: gatk4-Main-biggest-practices
cwlVersion: v1.1

requirements:
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}

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
  gatk4-IndelsVariantRecalibrator_java_options:
    type: string?
  indel_recalibration_tranche_values:
    type: float[]?
  indel_recalibration_annotation_values:
    type: string[]?
  allele_specific_annotations:
    type: boolean?
  IndelsVariantRecalibrator_max_gaussians:
    type: int?
  mills_resource_vcf:
    type: File
  axiomPoly_resource_vcf:
    type: File
    secondaryFiles:
      - .tbi
  dbsnp_resource_vcf:
    type: File
    secondaryFiles:
      - .idx
  gatk4-SNPsVariantRecalibratorClassic_java_options:
    type: string?
  snp_recalibration_tranche_values:
    type: float[]?
  snp_recalibration_annotation_values:
    type: string[]?
  model_report:
    type: File?
  SNPsVariantRecalibratorClassic_max_gaussians:
    type: int?
  hapmap_resource_vcf:
    type: File
    secondaryFiles:
      - .tbi
  omni_resource_vcf:
    type: File
    secondaryFiles:
      - .tbi
  one_thousand_genomes_resource_vcf:
    type: File
    secondaryFiles:
      - .tbi
  gatk4-ApplyRecalibration-INDEL_java_options:
    type: string?
  vqsr_indel_filter_level:
    type: float?
  create-output-variant-index:
    type: string?
  gatk4-ApplyRecalibration-SNP_java_options:
    type: string?
  vqsr_snp_filter_level:
    type: float?

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
  gatk4-sub-VQSR-biggest-practices:
    label: gatk4-sub-VQSR-biggest-practices
    run:  ../Workflows/gatk4-sub-VQSR-biggest-practices.cwl
    in:
      gatk4-IndelsVariantRecalibrator_java_options: gatk4-IndelsVariantRecalibrator_java_options
      sites_only_variant_filtered_vcf: gatk4-GatherVcfsIndex-biggest-practices/output_vcf
      indel_recalibration_tranche_values: indel_recalibration_tranche_values
      indel_recalibration_annotation_values: indel_recalibration_annotation_values
      allele_specific_annotations: allele_specific_annotations
      IndelsVariantRecalibrator_max_gaussians: IndelsVariantRecalibrator_max_gaussians
      mills_resource_vcf: mills_resource_vcf
      axiomPoly_resource_vcf: axiomPoly_resource_vcf
      dbsnp_resource_vcf: dbsnp_resource_vcf
      callset_name: callset_name
      gatk4-SNPsVariantRecalibratorClassic_java_options: gatk4-SNPsVariantRecalibratorClassic_java_options
      snp_recalibration_tranche_values: snp_recalibration_tranche_values
      snp_recalibration_annotation_values: snp_recalibration_annotation_values
      model_report: model_report
      SNPsVariantRecalibratorClassic_max_gaussians: SNPsVariantRecalibratorClassic_max_gaussians
      hapmap_resource_vcf: hapmap_resource_vcf
      omni_resource_vcf: omni_resource_vcf
      one_thousand_genomes_resource_vcf: one_thousand_genomes_resource_vcf
      gatk4-ApplyRecalibration-INDEL_java_options: gatk4-ApplyRecalibration-INDEL_java_options
      variant_filtered_vcf: gatk4-sub-JointCalling-biggest-practices/variant_filtered_vcf
      vqsr_indel_filter_level: vqsr_indel_filter_level
      create-output-variant-index: create-output-variant-index
      idx: idx
      gatk4-ApplyRecalibration-SNP_java_options: gatk4-ApplyRecalibration-SNP_java_options
      vqsr_snp_filter_level: vqsr_snp_filter_level


    out:
      -
  # xyz:
  #   label: xyz
  #   run:  ../Workflows/xyz.cwl
  #   in:
  #     x:y
  #   out:
  #     -
outputs:
  genomics-db:
    type: Directory[]
    outputSource: gatk4-sub-JointCalling-biggest-practices/genomics-db
  output_vcf:
    type: File[]
    outputSource: gatk4-sub-JointCalling-biggest-practices/output_vcf
    secondaryFiles:
      - .tbi
  output_database:
    type: File[]?
    outputSource: gatk4-sub-JointCalling-biggest-practices/output_database
    secondaryFiles:
      - .tbi
  variant_filtered_vcf:
    type: File[]
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
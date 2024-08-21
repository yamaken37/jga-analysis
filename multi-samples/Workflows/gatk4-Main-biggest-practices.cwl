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
    secondaryFiles:
      - .tbi
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
  gatk4-CollectMetricsSharded_java_options:
    type: string?
  ref_dict:
    type: File
  THREAD_COUNT:
    type: int? 
  eval_interval_list:
    type: File
  gatk4-GatherVariantCallingMetrics_java_options:
    type: string?
  gatk4-CrossCheckFingerprintSolo_java_options:
    type: string?
  gvcf_inputs_list:
    type: File
  vcf_inputs_list:
    type: File
  haplotype_database:
    type: File
  gatk4-CrossCheckFingerprintSolo_cpu:
    type: int?
  gatk4-CrossCheckFingerprintSolo_scattered:
    type: boolean?
  output_dir:
    type: Directory

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
      - indel_recalibration
      - indel_tranches
      - snp_recalibration
      - snp_tranches
      - tmp_indel_recalibrated_vcf_filename
      - recalibrated_vcf_filename
  gatk4-sub-Metrics-biggest-practices:
    label: gatk4-sub-Metrics-biggest-practices
    run:  ../Workflows/gatk4-sub-Metrics-biggest-practices.cwl
    in:
      gatk4-CollectMetricsSharded_java_options: gatk4-CollectMetricsSharded_java_options
      recalibrated_vcf_filename: gatk4-sub-VQSR-biggest-practices/recalibrated_vcf_filename
      dbsnp_vcf: dbsnp_resource_vcf
      ref_dict: ref_dict
      THREAD_COUNT: THREAD_COUNT
      eval_interval_list: eval_interval_list
      callset_name: callset_name
      idx: idx
      gatk4-GatherVariantCallingMetrics_java_options: gatk4-GatherVariantCallingMetrics_java_options
    out:
      - detail_metrics_files
      - detail_metrics_file
      - summary_metrics_file
  gatk4-CrossCheckFingerprintSolo-biggest-practices:
    label: gatk4-CrossCheckFingerprintSolo-biggest-practices
    run:  ../Tools/gatk4-CrossCheckFingerprintSolo-biggest-practices.cwl
    in:
      java_options: gatk4-CrossCheckFingerprintSolo_java_options
      gvcf_inputs_list: gvcf_inputs_list
      vcf_inputs_list: vcf_inputs_list
      haplotype_database: haplotype_database
      sample_name_map: sample_name_map
      cpu: gatk4-CrossCheckFingerprintSolo_cpu
      scattered: gatk4-CrossCheckFingerprintSolo_scattered
      callset_name: callset_name
      gvcf_dir: Reblock_gVCFsDir
      vcf_dir: output_dir
      summary_metrics_file: gatk4-sub-Metrics-biggest-practices/summary_metrics_file
    out:
      - crosscheck_metrics

outputs:
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
  indel_recalibration:
    type: File
    outputSource: gatk4-sub-VQSR-biggest-practices/indel_recalibration
    secondaryFiles:
      - .idx
  indel_tranches:
    type: File
    outputSource: gatk4-sub-VQSR-biggest-practices/indel_tranches
  snp_recalibration:
    type: File
    outputSource: gatk4-sub-VQSR-biggest-practices/snp_recalibration
    secondaryFiles:
      - .idx
  snp_tranches:
    type: File
    outputSource: gatk4-sub-VQSR-biggest-practices/snp_tranches
  tmp_indel_recalibrated_vcf_filename:
    type: File[]
    outputSource: gatk4-sub-VQSR-biggest-practices/tmp_indel_recalibrated_vcf_filename
    secondaryFiles:
      - .idx
  recalibrated_vcf_filename:
    type: File[]
    outputSource: gatk4-sub-VQSR-biggest-practices/recalibrated_vcf_filename
    secondaryFiles:
      - .tbi
  detail_metrics_files:
    type: File[]
    outputSource: gatk4-sub-Metrics-biggest-practices/detail_metrics_files
    secondaryFiles:
      - ^.variant_calling_summary_metrics
  detail_metrics_file:
    type: File
    outputSource: gatk4-sub-Metrics-biggest-practices/detail_metrics_file
  summary_metrics_file:
    type: File
    outputSource: gatk4-sub-Metrics-biggest-practices/summary_metrics_file
  crosscheck_metrics:
    type: File
    outputSource: gatk4-CrossCheckFingerprintSolo-biggest-practices/crosscheck_metrics

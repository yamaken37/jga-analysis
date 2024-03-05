#!/bin/bash

# SE_yaml.sh

# default
output_file="SE.yaml"
TOPDIR="TOPDIR"
prefix_rsem="SE_wf_samples"
endedness="single"
ramGB=16
ncpus=8
index="ENCFF598IDH.tar.gz"
chrom_sizes="GRCh38_EBV.chrom.sizes.tsv"
strandedness="stranded"
rsem_index="ENCFF285DRD.tar.gz"
rnd_seed=12345
read_strand="reverse"
tr_id_to_gene_type_tsv="gencodeV29pri-UCSC-tRNAs-ERCC-phiX.transcript_id_to_genes.tsv"

# fastq list
declare -a fastq_files=()

# args check
while [[ $# -gt 0 ]]; do
    case "$1" in
        --fastq)
            shift
            while [[ $# -gt 0 && ! $1 == --* ]]; do
                fastq_files+=("$1")
                shift
            done
            ;;
        --output) output_file="$2"; shift 2 ;;
        --topdir) TOPDIR="$2"; shift 2 ;;
        --prefix_rsem) prefix_rsem="$2"; shift 2 ;;
        --endedness) endedness="$2"; shift 2 ;;
        --ramGB) ramGB="$2"; shift 2 ;;
        --ncpus) ncpus="$2"; shift 2 ;;
        --index) index="$2"; shift 2 ;;
        --chrom_sizes) chrom_sizes="$2"; shift 2 ;;
        --strandedness) strandedness="$2"; shift 2 ;;
        --rsem_index) rsem_index="$2"; shift 2 ;;
        --rnd_seed) rnd_seed="$2"; shift 2 ;;
        --read_strand) read_strand="$2"; shift 2 ;;
        --tr_id_to_gene_type_tsv) tr_id_to_gene_type_tsv="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# fastq file exist check
if [ ${#fastq_files[@]} -eq 0 ]; then
    echo "Error: At least one --fastq option with a value is required."
    exit 1
fi

# create YAML
cat <<EOF > $output_file
prefix_rsem: "${prefix_rsem}"
endedness: "${endedness}"
ramGB: ${ramGB}
ncpus: ${ncpus}
index:
    class: File
    path: "${TOPDIR}/${index}"
chrom_sizes:
    class: File
    path: "${TOPDIR}/${chrom_sizes}"
strandedness: "${strandedness}"
rsem_index:
    class: File
    path: "${TOPDIR}/${rsem_index}"
rnd_seed: ${rnd_seed}
read_strand: "${read_strand}"
tr_id_to_gene_type_tsv:
    class: File
    path: "${TOPDIR}/${tr_id_to_gene_type_tsv}"
sample_list:
EOF

# fastq bamroot
for fastq in "${fastq_files[@]}"; do
    cat <<EOF >> $output_file
  - bamroot: "SE_${fastq}"
    fastqs_R1:
      - class: File
        path: "${TOPDIR}/${fastq}_1.fastq.gz"
EOF
done

echo "YAML: $output_file"

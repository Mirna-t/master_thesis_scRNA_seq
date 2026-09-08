#!/bin/bash

set -euo pipefail

START_TIME=$(date)
SECONDS=0

echo "======================================"
echo "Starting Cell Ranger for scMixology samples"
echo "Start time: ${START_TIME}"
echo "Running on host: $(hostname)"
echo "Current directory: $(pwd)"
echo "User: $(whoami)"
echo "======================================"

CELLRANGER="/CEPH/shared/software/cellranger/10.0.0/bin/cellranger"
REFERENCE="/CEPH/shared/databases/cellranger/refdata-gex-GRCh38-2024-A"
FASTQS="/CEPH/users/lmularoni/mirna_tarzi/cellranger/data"

OUTDIR="/home/mtarzi/CEPH/cellranger_results"

SAMPLES=("SCMIXOLOGY")

echo "Cell Ranger path: ${CELLRANGER}"
echo "Reference: ${REFERENCE}"
echo "FASTQ folder: ${FASTQS}"
echo "Output directory: ${OUTDIR}"
echo "Samples: ${SAMPLES[*]}"

echo "======================================"
echo "Checking paths"
echo "======================================"

if [ ! -x "${CELLRANGER}" ]; then
  echo "ERROR: Cell Ranger executable not found: ${CELLRANGER}"
  exit 1
fi

if [ ! -d "${REFERENCE}" ]; then
  echo "ERROR: Reference folder not found: ${REFERENCE}"
  exit 1
fi

if [ ! -d "${FASTQS}" ]; then
  echo "ERROR: FASTQ folder not found: ${FASTQS}"
  exit 1
fi

mkdir -p "${OUTDIR}"

echo "======================================"
echo "Cell Ranger version"
echo "======================================"
${CELLRANGER} --version

echo "======================================"
echo "Reference contents"
echo "======================================"
ls -lh "${REFERENCE}"

echo "======================================"
echo "FASTQ files available"
echo "======================================"
ls -lh "${FASTQS}"

echo "======================================"
echo "Starting sample loop"
echo "======================================"

for SAMPLE in "${SAMPLES[@]}"
do
  SAMPLE_START_TIME=$(date)
  SAMPLE_SECONDS_START=$SECONDS

  echo ""
  echo "======================================"
  echo "Starting sample: ${SAMPLE}"
  echo "Sample start time: ${SAMPLE_START_TIME}"
  echo "======================================"

  echo "Checking FASTQ files for ${SAMPLE}:"
  ls -lh "${FASTQS}/${SAMPLE}"*_R*_001.fastq.gz

  echo "R1 length:"
  python3 -c "import gzip; f=gzip.open('${FASTQS}/${SAMPLE}_S1_L001_R1_001.fastq.gz','rt'); next(f); print(len(next(f).strip()))"

  echo "R2 length:"
  python3 -c "import gzip; f=gzip.open('${FASTQS}/${SAMPLE}_S1_L001_R2_001.fastq.gz','rt'); next(f); print(len(next(f).strip()))"

  if [ -d "${OUTDIR}/${SAMPLE}" ]; then
    echo "ERROR: Output folder already exists: ${OUTDIR}/${SAMPLE}"
    echo "Please remove it first if you want to rerun:"
    echo "rm -rf ${OUTDIR}/${SAMPLE}"
    exit 1
  fi

  cd "${OUTDIR}"

  ${CELLRANGER} count \
    --id="${SAMPLE}" \
    --transcriptome="${REFERENCE}" \
    --fastqs="${FASTQS}" \
    --sample="${SAMPLE}" \
    --create-bam=false \
    --localcores=8 \
    --localmem=64

  SAMPLE_END_TIME=$(date)
  SAMPLE_DURATION=$((SECONDS - SAMPLE_SECONDS_START))

  echo "======================================"
  echo "Finished sample: ${SAMPLE}"
  echo "Sample start time: ${SAMPLE_START_TIME}"
  echo "Sample end time: ${SAMPLE_END_TIME}"
  echo "Sample duration in seconds: ${SAMPLE_DURATION}"
  echo "Sample duration in minutes: $((SAMPLE_DURATION / 60))"
  echo "Output folder: ${OUTDIR}/${SAMPLE}"
  echo "======================================"

done

END_TIME=$(date)
DURATION=$SECONDS

echo ""
echo "======================================"
echo "All Cell Ranger runs finished"
echo "Start time: ${START_TIME}"
echo "End time: ${END_TIME}"
echo "Total duration in seconds: ${DURATION}"
echo "Total duration in minutes: $((DURATION / 60))"
echo "Results folder: ${OUTDIR}"
echo "======================================"

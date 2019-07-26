#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

$namespaces:
  edam: 'http://edamontology.org/'

# 以下のコマンドラインを実行したい
# $BWA mem -M -t $CPU $REF.fa ${R1} ${R2} | $SAMTOOLS view -@ 8 -Sb - > $F.bam

hints:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/samtools:1.6--0'

baseCommand: [ samtools, view ]
arguments: [-@, $(runtime.cores), -Sb, $(inputs.sam)]

inputs:
    sam: 
        type: File
        streamable: true
        # streamable について
        # 入力ときは、パイプを受け入れるということがかける
        # 出力は、デフォルトで、パイプ出力をサポートしている
        format: edam:format_2573
outputs:
    bam: stdout
stdout: output.bam
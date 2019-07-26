#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool

$namespaces:
  edam: 'http://edamontology.org/'

hints:
  - class: DockerRequirement
    dockerPull: 'biocontainers/bwa:v0.7.12_cv3'

# 以下のコマンドラインを実行したい
# $BWA mem -M -t $CPU $REF.fa ${R1} ${R2} | $SAMTOOLS view -@ 8 -Sb - > $F.bam
# -M            mark shorter split hits as secondary
# -t $CPUでコア数 
# $REFにレファレンスを入力 (secondaryFiles: .amb .ann .bwt .pac .sa )
# ${R1} シーケンサーからでてきた fastq, Read1 # edam:format_1930
# ${R2} シーケンサーからでてきた fastq, Read2 # edam:format_1930
baseCommand: [bwa, mem]
arguments: [-M, -t, $(runtime.cores), $(inputs.reference), $(inputs.fastq_forward), $(inputs.fastq_reverse)]
# この順番で、コマンドラインが組み立てられる
# $(runtime.cores) 実行のコア数が指定されている
# $(inputs.reference-bwt.nameroot) オプション reference で、指定される
## small.chr22.fa このファイル名から、small.chr22.fa.bwt　が作成されるので、
# a
inputs:
    reference:
        doc: fasta file for reference
        label: fasta file for reference
        type: File
        # 今回は、argumentsの中に $(inputs.reference) が指定されているので、
        # inputBindingのポジションはいらない
        secondaryFiles:
            # この ^ は、ひとつ、ドットをさかのぼるので
            # sampledata/DATA/small.chr22.fa.bwt
            # であれば
            # sampledata/DATA/small.chr22.fa
            # となる
            - .amb
            - .ann
            - .bwt
            - .pac
            - .sa
    fastq_forward: 
        type: File
        format: edam:format_1930 # FastQ
    fastq_reverse: 
        type: File
        format: edam:format_1930 # FastQ

outputs:
    sam: stdout
stdout: output.sam

# from https://github.com/ddbj/human-reseq/blob/master/Tools/bwa-mem-PE.cwl
#inputs:
#  - id: reference
#    type: File
#    format: edam:format_1929
#    inputBinding:
#      position: 4
#    doc: FastA file for reference genome
#    secondaryFiles:
#      - .amb
#      - .ann
#      - .bwt
#      - .pac
#      - .sa
#  - id: RG_ID
#    type: string
#    doc: Read group identifier (ID) in RG line
#  - id: RG_PL
#    type: string
#    doc: Platform/technology used to produce the read (PL) in RG line
#  - id: RG_PU
#    type: string
#    doc: Platform Unit (PU) in RG line
#  - id: RG_LB
#    type: string
#    doc: DNA preparation library identifier (LB) in RG line
#  - id: RG_SM
#    type: string
#    doc: Sample (SM) identifier in RG line
#  - id: fq1
#    type: File
#    format: edam:format_1930
#    inputBinding:
#      position: 5
#    doc: FastQ file from next-generation sequencers
#  - id: fq2
#    type: File
#    format: edam:format_1930
#    inputBinding:
#      position: 6
#    doc: FastQ file from next-generation sequencers
#  - id: nthreads
#    type: int
#    inputBinding:
#      prefix: -t
#      position: 3
#    doc: number of cpu cores to be used
#  - id: outprefix
#    type: string
#
#outputs:
#  - id: sam
#    type: stdout
#    format: edam:format_2573
#  - id: log
#    type: stderr
#
# stdout: $(inputs.outprefix).sam
# stderr: $(inputs.outprefix).sam.log
#    
# arguments:
#  - position: 1
#    prefix: -K
#    valueFrom: "10000000"
#  - position: 2
#    prefix: -R
#    valueFrom: "@RG\tID:$(inputs.RG_ID)\tPL:$(inputs.RG_PL)\tPU:$(inputs.RG_PU)\tLB:$(inputs.RG_LB)\tSM:$(inputs.RG_SM)"

version 1.0
workflow Alignment {
	input {
		File READS_1
		File READS_2
		File REFERENCE
	}

	call alignment {
		input:
			reads1 = READS_1,
			reads2 = READS_2,
			ref = REFERENCE,
	}
	
	call samtoolStats {
		input:
			align = alignment.samfile
	}

	call bamFile {
		input:
			inputSam = alignment.samfile,
			ref = REFERENCE
	}

	output {
		File alignmentsSAM = alignment.samfile
		File statsSAM = samtoolStats.stats
		File alignmentBAM = bamFile.sortedBAM
	}
}

task alignment {
	input {
		File reads1
		File reads2
		File ref
	}
	command <<<
		bwa-mem2 index "~{ref}"
		bwa-mem2 mem "~{ref}" "~{reads1}" "~{reads2}" > sample.sam
	>>>
	runtime {
		docker : "szarate/bwa-mem2"
		memory: "4GB"
	}
	output {
		File samfile = "sample.sam"
	}
}

task samtoolStats {
	input {
		File align
	}
	command <<<
		samtools flagstat "~{align}" > flagstats.sam
	>>>
	runtime {
		docker : "mschatz/wga-essentials"
	}
	output {
		File stats = "flagstats.sam"
	}

}

task bamFile {
	input {
		File inputSam
		File ref
	}
	command <<<
		samtools view -S -b "~{inputSam}" > sample.bam
		samtools sort sample.bam > sample_sorted.bam
	>>>
	runtime {
		docker : "mschatz/wga-essentials"
	}
	output {
		File sortedBAM = "sample_sorted.bam"
	}
}

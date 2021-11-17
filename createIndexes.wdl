version 1.0

workflow createIndex {
	input {
		File ref
		File reads
	}
	
	call indexFiles {
		input:
			ref = ref,
			reads = reads,
	}
	output {
		File indexRefernce = indexFiles.refIndex
		File indexReads = indexFiles.readsIndex
	}
}

task indexFiles {
	input {
		File ref
		File reads
	}

	command <<<
		samtools faidx "~{ref}" > ref.fa.fai
		samtools index "~{reads}" > reads.bam.bai
	>>>
	runtime {
		docker : "mschatz/wga-essentials"
	}
	output {
		File refIndex = "ref.fa.fai"
		File readsIndex = "reads.bam.bai"
	}
}

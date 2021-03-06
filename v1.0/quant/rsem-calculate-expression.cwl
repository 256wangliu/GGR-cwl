 class: CommandLineTool
 cwlVersion: v1.0
 doc: |
    In its default mode, this program aligns input reads against a reference
    transcriptome with Bowtie and calculates expression values using the
    alignments. RSEM assumes the data are single-end reads with quality
    scores, unless the '--paired-end' or '--no-qualities' options are
    specified. Users may use an alternative aligner by specifying one of the
    --sam and --bam options, and providing an alignment file in the
    specified format. However, users should make sure that they align
    against the indices generated by 'rsem-prepare-reference' and the
    alignment file satisfies the requirements mentioned in ARGUMENTS
    section.
    One simple way to make the alignment file satisfying RSEM's requirements
    (assuming the aligner used put mates in a paired-end read adjacent) is
    to use 'convert-sam-for-rsem' script. This script only accept SAM format
    files as input. If a BAM format file is obtained, please use samtools to
    convert it to a SAM file first. For example, if '/ref/mouse_125' is the
    'reference_name' and the SAM file is named 'input.sam', you can run the
    following command:
      convert-sam-for-rsem /ref/mouse_125 input.sam -o input_for_rsem.sam
    For details, please refer to 'convert-sam-for-rsem's documentation page.
    The SAM/BAM format RSEM uses is v1.4. However, it is compatible with old
    SAM/BAM format. However, RSEM cannot recognize 0x100 in the FLAG field.
    In addition, RSEM requires SEQ and QUAL are not '*'.
    The user must run 'rsem-prepare-reference' with the appropriate
    reference before using this program.
    For single-end data, it is strongly recommended that the user provide
    the fragment length distribution parameters (--fragment-length-mean and
    --fragment-length-sd). For paired-end data, RSEM will automatically
    learn a fragment length distribution from the data.
    Please note that some of the default values for the Bowtie parameters
    are not the same as those defined for Bowtie itself.
    The temporary directory and all intermediate files will be removed when
    RSEM finishes unless '--keep-intermediate-files' is specified.
    With the '--calc-pme' option, posterior mean estimates will be
    calculated in addition to maximum likelihood estimates.
    With the '--calc-ci' option, 95% credibility intervals and posterior
    mean estimates will be calculated in addition to maximum likelihood
    estimates.
 requirements:
 - class: InlineJavascriptRequirement
 hints:
    DockerRequirement:
      dockerPull: reddylab/rsem:1.2.25
 inputs:
    bowtie-chunkmbs:
      type: int?
      inputBinding:
        position: 1
        prefix: --bowtie-chunkmbs
      doc: |
        <int>
        (Bowtie parameter) memory allocated for best first alignment
        calculation (Default: 0 - use Bowtie's default)
    bowtie2-mismatch-rate:
      type: float?
      inputBinding:
        position: 1
        prefix: --bowtie2-mismatch-rate
      doc: |
        <double>
        (Bowtie 2 parameter) The maximum mismatch rate allowed. (Default:
        0.1)
    sam:
      type: File?
      inputBinding:
        position: 2
        prefix: --sam
      doc: |
        SAM formatted input file. If "-" is specified for the filename,
        SAM input is instead assumed to come from standard input. RSEM
        requires all alignments of the same read group together. For
        paired-end reads, RSEM also requires the two mates of any alignment
        be adjacent. See Description section for how to make input file obey
        RSEM's requirements.
    fragment-length-mean:
      type: float?
      inputBinding:
        position: 1
        prefix: --fragment-length-mean
      doc: |
        <double>
        (single-end data only) The mean of the fragment length distribution,
        which is assumed to be a Gaussian. (Default: -1, which disables use
        of the fragment length distribution)
    upstream_read_files:
      type:
      - 'null'
      - {type: array, items: File}
      inputBinding:
        position: 2
        itemSeparator: ','
      doc: |
        Comma-separated list of files containing single-end reads or
        upstream reads for paired-end data. By default, these files are
        assumed to be in FASTQ format. If the --no-qualities option is
        specified, then FASTA format is expected.
    sampling-for-bam:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --sampling-for-bam
      doc: |
        --sampling-for-bam
        When RSEM generates a BAM file, instead of outputing all alignments
        a read has with their posterior probabilities, one alignment is
        sampled according to the posterior probabilities. The sampling
        procedure includes the alignment to the "noise" transcript, which
        does not appear in the BAM file. Only the sampled alignment has a
        weight of 1. All other alignments have weight 0. If the "noise"
        transcript is sampled, all alignments appeared in the BAM file
        should have weight 0. (Default: off)
    tag:
      type: string?
      inputBinding:
        position: 1
        prefix: --tag
      doc: |
        <string>
        The name of the optional field used in the SAM input for identifying
        a read with too many valid alignments. The field should have the
        format <tagName>:i:<value>, where a <value> bigger than 0 indicates
        a read with too many alignments. (Default: "")
    calc-ci:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --calc-ci
      doc: |
        --calc-ci
        Calculate 95% credibility intervals and posterior mean estimates.
        The credibility level can be changed by setting
        '--ci-credibility-level'. (Default: off)
    estimate-rspd:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --estimate-rspd
      doc: |
        Set this option if you want to estimate the read start position
        distribution (RSPD) from data. Otherwise, RSEM will use a uniform
        RSPD. (Default: off)
    ci-memory:
      type: int?
      inputBinding:
        position: 1
        prefix: --ci-memory
      doc: |
        <int>
        Maximum size (in memory, MB) of the auxiliary buffer used for
        computing credibility intervals (CI). Set it larger for a faster CI
        calculation. However, leaving 2 GB memory free for other usage is
        recommended. (Default: 1024)
    forward-prob:
      type: float?
      inputBinding:
        position: 1
        prefix: --forward-prob
      doc: |
        <double>
        Probability of generating a read from the forward strand of a
        transcript. Set to 1 for a strand-specific protocol where all
        (upstream) reads are derived from the forward strand, 0 for a
        strand-specific protocol where all (upstream) read are derived from
        the reverse strand, or 0.5 for a non-strand-specific protocol.
        (Default: 0.5)
    downstream_read_file:
      type:
      - 'null'
      - {type: array, items: File}
      inputBinding:
        position: 3
        itemSeparator: ','
      doc: |
        Comma-separated list of files containing downstream reads which are
        paired with the upstream reads. By default, these files are assumed
        to be in FASTQ format. If the --no-qualities option is specified,
        then FASTA format is expected.
    bowtie2-path:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --bowtie2-path
      doc: |
        <path>
        (Bowtie 2 parameter) The path to the Bowtie 2 executables. (Default:
        the path to the Bowtie 2 executables is assumed to be in the user's
        PATH environment variable)
    paired-end:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --paired-end
      doc: 'Input reads are paired-end reads. (Default: off)'
    no-bam-output:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --no-bam-output
      doc: 'Do not output any BAM file. (Default: off)'
    bowtie-n:
      type: int?
      inputBinding:
        position: 1
        prefix: --bowtie-n
      doc: |
        <int>
        (Bowtie parameter) max # of mismatches in the seed. (Range: 0-3,
        Default: 2)
    sample_name:
      type: string
      inputBinding:
        position: 5
      doc: |
        The name of the sample analyzed. All output files are prefixed by
        this name (e.g., sample_name.genes.results)
    samtools-sort-mem:
      type: string?
      inputBinding:
        position: 1
        prefix: --samtools-sort-mem
      doc: |
        <string>
        Set the maximum memory per thread that can be used by 'samtools
        sort'. <string> represents the memory and accepts suffices 'K/M/G'.
        RSEM will pass <string> to the '-m' option of 'samtools sort'.
        Please note that the default used here is different from the default
        used by samtools. (Default: 1G)
    gibbs-number-of-samples:
      type: int?
      inputBinding:
        position: 1
        prefix: --gibbs-number-of-samples
      doc: |
        <int>
        The total number of count vectors RSEM will collect from its Gibbs
        samplers. (Default: 1000)
    no-qualities:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --no-qualities
      doc: 'Input reads do not contain quality scores. (Default: off)'
    strand-specific:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --strand-specific
      doc: |
        The RNA-Seq protocol used to generate the reads is strand specific,
        i.e., all (upstream) reads are derived from the forward strand. This
        option is equivalent to --forward-prob=1.0. With this option set, if
        RSEM runs the Bowtie/Bowtie 2 aligner, the '--norc' Bowtie/Bowtie 2
        option will be used, which disables alignment to the reverse strand
        of transcripts. (Default: off)
    keep-intermediate-files:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --keep-intermediate-files
      doc: |
        Keep temporary files generated by RSEM. RSEM creates a temporary
        directory, 'sample_name.temp', into which it puts all intermediate
        output files. If this directory already exists, RSEM overwrites all
        files generated by previous RSEM runs inside of it. By default,
        after RSEM finishes, the temporary directory is deleted. Set this
        option to prevent the deletion of this directory and the
        intermediate files inside of it. (Default: off)
    ci-number-of-samples-per-count-vector:
      type: int?
      inputBinding:
        position: 1
        prefix: --ci-number-of-samples-per-count-vector
      doc: |
        <int>
        The number of read generating probability vectors sampled per
        sampled count vector. The crebility intervals are calculated by
        first sampling P(C | D) and then sampling P(Theta | C) for each
        sampled count vector. This option controls how many Theta vectors
        are sampled per sampled count vector. (Default: 50)
    reference_name:
      type: string
      inputBinding:
        position: 4
        valueFrom: $(inputs.reference_files.path + "/" + self)
      doc: |
        The name of the reference used. The user must have run
        'rsem-prepare-reference' with this reference_name before running
        this program.
    bowtie2-k:
      type: int?
      inputBinding:
        position: 1
        prefix: --bowtie2-k
      doc: |
        <int>
        (Bowtie 2 parameter) Find up to <int> alignments per read. (Default:
        200)
    fragment-length-min:
      type: int?
      inputBinding:
        position: 1
        prefix: --fragment-length-min
      doc: |
        <int>
        Minimum read/insert length allowed. This is also the value for the
        Bowtie/Bowtie2 -I option. (Default: 1)
    phred64-quals:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --phred64-quals
      doc: |
        Input quality scores are encoded as Phred+64 (default for GA
        Pipeline ver. >= 1.3). (Default: off)
    gibbs-sampling-gap:
      type: int?
      inputBinding:
        position: 1
        prefix: --gibbs-sampling-gap
      doc: |
        <int>
        The number of rounds between two succinct count vectors RSEM
        collects. If the count vector after round N is collected, the count
        vector after round N + <int> will also be collected. (Default: 1)
    bowtie2-sensitivity-level:
      type: string?
      inputBinding:
        position: 1
        prefix: --bowtie2-sensitivity-level
      doc: |
        <string>
        (Bowtie 2 parameter) Set Bowtie 2's preset options in --end-to-end
        mode. This option controls how hard Bowtie 2 tries to find
        alignments. <string> must be one of "very_fast", "fast", "sensitive"
        and "very_sensitive". The four candidates correspond to Bowtie 2's
        "--very-fast", "--fast", "--sensitive" and "--very-sensitive"
        options. (Default: "sensitive" - use Bowtie 2's default)
    solexa-quals:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --solexa-quals
      doc: |
        Input quality scores are solexa encoded (from GA Pipeline ver. <
        1.3). (Default: off)
    output-genome-bam:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --output-genome-bam
      doc: |
        --output-genome-bam
        Generate a BAM file, 'sample_name.genome.bam', with alignments
        mapped to genomic coordinates and annotated with their posterior
        probabilities. In addition, RSEM will call samtools (included in
        RSEM package) to sort and index the bam file.
        'sample_name.genome.sorted.bam' and
        'sample_name.genome.sorted.bam.bai' will be generated. (Default:
        off)
    fragment-length-sd:
      type: float?
      inputBinding:
        position: 1
        prefix: --fragment-length-sd
      doc: |
        <double>
        (single-end data only) The standard deviation of the fragment length
        distribution, which is assumed to be a Gaussian. (Default: 0, which
        assumes that all fragments are of the same length, given by the
        rounded value of --fragment-length-mean)
    bowtie2:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --bowtie2
      doc: |
        Use Bowtie 2 instead of Bowtie to align reads. Since currently RSEM
        does not handle indel, local and discordant alignments, the Bowtie2
        parameters are set in a way to avoid those alignments. In
        particular, we use options '--sensitive --dpad 0 --gbar 99999999
        --mp 1,1 --np 1 --score-min L,0,-0.1' by default. The last parameter
        of '--score-min', '-0.1', is the negative of maximum mismatch rate.
        This rate can be set by option '--bowtie2-mismatch-rate'. If reads
        are paired-end, we additionally use options '--no-mixed' and
        '--no-discordant'. (Default: off)
    num-rspd-bins:
      type: int?
      inputBinding:
        position: 1
        prefix: --num-rspd-bins
      doc: |
        <int>
        Number of bins in the RSPD. Only relevant when '--estimate-rspd' is
        specified. Use of the default setting is recommended. (Default: 20)
    fragment-length-max:
      type: int?
      inputBinding:
        position: 1
        prefix: --fragment-length-max
      doc: |
        <int>
        Maximum read/insert length allowed. This is also the value for the
        Bowtie/Bowtie 2 -X option. (Default: 1000)
    sam-header-info:
###################
# ADVANCE OPTIONS #
###################
      type: File?
      inputBinding:
        position: 1
        prefix: --sam-header-info
      doc: |
        <file>
        RSEM reads header information from input by default. If this option
        is on, header information is read from the specified file. For the
        format of the file, please see SAM official website. (Default: "")
    seed-length:
      type: int?
      inputBinding:
        position: 1
        prefix: --seed-length
      doc: |
        <int>
        Seed length used by the read aligner. Providing the correct value is
        important for RSEM. If RSEM runs Bowtie, it uses this value for
        Bowtie's seed length parameter. Any read with its or at least one of
        its mates' (for paired-end reads) length less than this value will
        be ignored. If the references are not added poly(A) tails, the
        minimum allowed value is 5, otherwise, the minimum allowed value is
        25. Note that this script will only check if the value >= 5 and give
        a warning message if the value < 25 but >= 5. (Default: 25)
    ci-credibility-level:
      type: float?
      inputBinding:
        position: 1
        prefix: --ci-credibility-level
      doc: |
        <double>
        The credibility level for credibility intervals. (Default: 0.95)
    phred33-quals:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --phred33-quals
      doc: |
        Input quality scores are encoded as Phred+33. (Default: on)
    calc-pme:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --calc-pme
      doc: |
        --calc-pme
        Run RSEM's collapsed Gibbs sampler to calculate posterior mean
        estimates. (Default: off)
    reference_files:
      type: Directory
      doc: |
        Directory containing <reference_name>.seq, <reference_name>.transcripts.fa, ...
        The user must have run 'rsem-prepare-reference' with a reference_name
        before running this program.
    quiet:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --quiet
      doc: |
        --quiet
        Suppress the output of logging information. (Default: off)
    bowtie-m:
      type: int?
      inputBinding:
        position: 1
        prefix: --bowtie-m
      doc: |
        <int>
        (Bowtie parameter) suppress all alignments for a read if > <int>
        valid alignments exist. (Default: 200)
    gibbs-burnin:
      type: int?
      inputBinding:
        position: 1
        prefix: --gibbs-burnin
      doc: |
        <int>
        The number of burn-in rounds for RSEM's Gibbs sampler. Each round
        passes over the entire data set once. If RSEM can use multiple
        threads, multiple Gibbs samplers will start at the same time and all
        samplers share the same burn-in number. (Default: 200)
    seed:
      type: int?
      inputBinding:
        position: 1
        prefix: --seed
      doc: |
        <int>
        Set the seed for the random number generators used in calculating
        posterior mean estimates and credibility intervals. The seed must be
        a non-negative 32 bit interger. (Default: off)
    time:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --time
      doc: |
        Output time consumed by each step of RSEM to 'sample_name.time'.
        (Default: off)
    bowtie-e:
      type: int?
      inputBinding:
        position: 1
        prefix: --bowtie-e
      doc: |
        <int>
        (Bowtie parameter) max sum of mismatch quality scores across the
        alignment. (Default: 99999999)
    bowtie-path:
      type: boolean?
      inputBinding:
        position: 1
        prefix: --bowtie-path
      doc: |
        <path>
        The path to the Bowtie executables. (Default: the path to the Bowtie
        executables is assumed to be in the user's PATH environment
        variable)
    temporary-folder:
      type: string?
      inputBinding:
        position: 1
        prefix: --temporary-folder
      doc: |
        <string>
        Set where to put the temporary files generated by RSEM. If the
        folder specified does not exist, RSEM will try to create it.
        (Default: sample_name.temp)
    bam:
      type: File?
      inputBinding:
        position: 2
        prefix: --bam
      doc: |
        BAM formatted input file. If "-" is specified for the filename,
        BAM input is instead assumed to come from standard input. RSEM
        requires all alignments of the same read group together. For
        paired-end reads, RSEM also requires the two mates of any alignment
        be adjacent. See Description section for how to make input file obey
        RSEM's requirements.
    num-threads:
      type: int?
      inputBinding:
        position: 1
        prefix: --num-threads
      doc: |
        --num-threads <int>
        Number of threads to use. Both Bowtie/Bowtie2, expression estimation
        and 'samtools sort' will use this many threads. (Default: 1)
 outputs:
    alleles:
      type: File?
      outputBinding:
        glob: $(inputs.sample_name + ".alleles.results")
      doc: |
        Only generated when the RSEM references are built with
        allele-specific transcripts.
        This file contains allele level expression estimates for
        allele-specific expression calculation. The first line contains
        column names separated by the tab character. The format of each line
        in the rest of this file is:
        allele_id transcript_id gene_id length effective_length
        expected_count TPM FPKM AlleleIsoPct AlleleGenePct
        [posterior_mean_count posterior_standard_deviation_of_count pme_TPM
        pme_FPKM AlleleIsoPct_from_pme_TPM AlleleGenePct_from_pme_TPM
        TPM_ci_lower_bound TPM_ci_upper_bound FPKM_ci_lower_bound
        FPKM_ci_upper_bound]
        Fields are separated by the tab character. Fields within "[]" are
        optional. They will not be presented if neither '--calc-pme' nor
        '--calc-ci' is set.
        'allele_id' is the allele-specific name of this allele-specific
        transcript.
        'AlleleIsoPct' stands for allele-specific percentage on isoform
        level. It is the percentage of this allele-specific transcript's
        abundance over its parent transcript's abundance. If its parent
        transcript has only one allele variant form, this field will be set
        to 100.
        'AlleleGenePct' stands for allele-specific percentage on gene level.
        It is the percentage of this allele-specific transcript's abundance
        over its parent gene's abundance.
        'AlleleIsoPct_from_pme_TPM' and 'AlleleGenePct_from_pme_TPM' have
        similar meanings. They are calculated based on posterior mean
        estimates.
        Please note that if this file is present, the fields 'length' and
        'effective_length' in 'sample_name.isoforms.results' should be
        interpreted similarly as the corresponding definitions in
        'sample_name.genes.results'.
    genes:
      type: File
      outputBinding:
        glob: $(inputs.sample_name + ".genes.results")
      doc: |
        File containing gene level expression estimates. The first line
        contains column names separated by the tab character. The format of
        each line in the rest of this file is:
        gene_id transcript_id(s) length effective_length expected_count TPM
        FPKM [posterior_mean_count posterior_standard_deviation_of_count
        pme_TPM pme_FPKM TPM_ci_lower_bound TPM_ci_upper_bound
        FPKM_ci_lower_bound FPKM_ci_upper_bound]
        Fields are separated by the tab character. Fields within "[]" are
        optional. They will not be presented if neither '--calc-pme' nor
        '--calc-ci' is set.
        'transcript_id(s)' is a comma-separated list of transcript_ids
        belonging to this gene. If no gene information is provided,
        'gene_id' and 'transcript_id(s)' are identical (the
        'transcript_id').
        A gene's 'length' and 'effective_length' are defined as the weighted
        average of its transcripts' lengths and effective lengths (weighted
        by 'IsoPct'). A gene's abundance estimates are just the sum of its
        transcripts' abundance estimates.
    transcript_sorted_bam:
      type: File?
      outputBinding:
        glob: $(inputs.sample_name + ".transcript.sorted.bam")
    rsem_stat:
      type:
      - 'null'
      - {type: array, items: File}
      outputBinding:
        glob: $(inputs.sample_name + ".stat/*")
      doc: |
        This is a folder instead of a file. All model related statistics are
        stored in this folder. Use 'rsem-plot-model' can generate plots
        using this folder.
        'sample_name.stat/sample_name.cnt' contains alignment statistics.
        The format and meanings of each field are described in
        'cnt_file_description.txt' under RSEM directory.
        'sample_name.stat/sample_name.model' stores RNA-Seq model parameters
        learned from the data. The format and meanings of each filed of this
        file are described in 'model_file_description.txt' under RSEM
        directory.
    rsem_time:
      type: File?
      outputBinding:
        glob: $(inputs.sample_name + ".time")
      doc: |
        Only generated when --time is specified.
        It contains time (in seconds) consumed by aligning reads, estimating
        expression levels and calculating credibility intervals.
    transcript_bam:
      type: File?
      outputBinding:
        glob: $(inputs.sample_name + ".transcript.bam")
      doc: |
        BAM-formatted file of read
        alignments in transcript coordinates. The MAPQ field of each
        alignment is set to min(100, floor(-10 * log10(1.0 - w) + 0.5)),
        where w is the posterior probability of that alignment being the
        true mapping of a read. In addition, RSEM pads a new tag ZW:f:value,
        where value is a single precision floating number representing the
        posterior probability. Because this file contains all alignment
        lines produced by bowtie or user-specified aligners, it can also be
        used as a replacement of the aligner generated BAM/SAM file. For
        paired-end reads, if one mate has alignments but the other does not,
        this file marks the alignable mate as "unmappable" (flag bit 0x4)
        and appends an optional field "Z0:A:!".
    transcript_sorted_bam_bai:
      type: File?
      outputBinding:
        glob: $(inputs.sample_name + ".transcript.sorted.bam.bai")
    isoforms:
      type: File
      outputBinding:
        glob: $(inputs.sample_name + ".isoforms.results")
      doc: |
        File containing isoform level expression estimates. The first line
        contains column names separated by the tab character. The format of
        each line in the rest of this file is:
        transcript_id gene_id length effective_length expected_count TPM
        FPKM IsoPct [posterior_mean_count
        posterior_standard_deviation_of_count pme_TPM pme_FPKM
        IsoPct_from_pme_TPM TPM_ci_lower_bound TPM_ci_upper_bound
        FPKM_ci_lower_bound FPKM_ci_upper_bound]
        Fields are separated by the tab character. Fields within "[]" are
        optional. They will not be presented if neither '--calc-pme' nor
        '--calc-ci' is set.
        'transcript_id' is the transcript name of this transcript. 'gene_id'
        is the gene name of the gene which this transcript belongs to
        (denote this gene as its parent gene). If no gene information is
        provided, 'gene_id' and 'transcript_id' are the same.
        'length' is this transcript's sequence length (poly(A) tail is not
        counted). 'effective_length' counts only the positions that can
        generate a valid fragment. If no poly(A) tail is added,
        'effective_length' is equal to transcript length - mean fragment
        length + 1. If one transcript's effective length is less than 1,
        this transcript's both effective length and abundance estimates are
        set to 0.
        'expected_count' is the sum of the posterior probability of each
        read comes from this transcript over all reads. Because 1) each read
        aligning to this transcript has a probability of being generated
        from background noise; 2) RSEM may filter some alignable low quality
        reads, the sum of expected counts for all transcript are generally
        less than the total number of reads aligned.
        'TPM' stands for Transcripts Per Million. It is a relative measure
        of transcript abundance. The sum of all transcripts' TPM is 1
        million. 'FPKM' stands for Fragments Per Kilobase of transcript per
        Million mapped reads. It is another relative measure of transcript
        abundance. If we define l_bar be the mean transcript length in a
        sample, which can be calculated as
        l_bar = \sum_i TPM_i / 10^6 * effective_length_i (i goes through
        every transcript),
        the following equation is hold:
        FPKM_i = 10^3 / l_bar * TPM_i.
        We can see that the sum of FPKM is not a constant across samples.
        'IsoPct' stands for isoform percentage. It is the percentage of this
        transcript's abandunce over its parent gene's abandunce. If its
        parent gene has only one isoform or the gene information is not
        provided, this field will be set to 100.
        'posterior_mean_count', 'pme_TPM', 'pme_FPKM' are posterior mean
        estimates calculated by RSEM's Gibbs sampler.
        'posterior_standard_deviation_of_count' is the posterior standard
        deviation of counts. 'IsoPct_from_pme_TPM' is the isoform percentage
        calculated from 'pme_TPM' values.
        'TPM_ci_lower_bound', 'TPM_ci_upper_bound', 'FPKM_ci_lower_bound'
        and 'FPKM_ci_upper_bound' are lower(l) and upper(u) bounds of 95%
        credibility intervals for TPM and FPKM values. The bounds are
        inclusive (i.e. [l, u]).
 baseCommand:
  - rsem-calculate-expression

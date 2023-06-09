args = commandArgs(trailingOnly = TRUE)

ss = read.csv(args[1],sep = ',',stringsAsFactors = F)


cmd = paste('./SnapSeq.sh -1', ss$read1, '-2', ss$read2, '-n', ss$SampleID, '-R', ss$reference, '-r', ss$region,
            '-@',ss$threads, '-p', ss$pathvcf, '-t',ss$trimmomatic,'-P',ss$picard, '-v', ss$varscan, '-a', ss$annovar)


writeLines(text = cmd, con = 'runsamples.txt')
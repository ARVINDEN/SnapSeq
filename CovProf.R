suppressMessages(library(ggplot2))
suppressMessages(library(gmoviz))
suppressMessages(library(regioneR))

args = commandArgs(trailingOnly = T)
bed = toGRanges(args[1])

cov = getCoverage(bed,args[2], window_size = 1)

cov = data.frame(cov, stringsAsFactors = F)

p = ggplot(cov,mapping = aes(start, y = log2(coverage+1))) + geom_col(fill = '#EF7C8E')
p = p + theme_bw() + xlab('Position') + ylab('log2(Coverage)') + theme(text = element_text(face = 'bold'))

ggsave(filename = paste(args[3],'_coverage.png', sep =''),plot = p, width = 16, height = 16, units = 'cm', dpi = 300)

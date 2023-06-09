# To filter the pathogenic variants from clinvar
# Load required packages

suppressMessages(library(dplyr))
suppressMessages(library(stringr))
suppressMessages(library(data.table)) 
suppressMessages(library(argparse))


parser = ArgumentParser()

parser$add_argument('-db','--database', help = 'Provide clinvar VCF file')
parser$add_argument('-f','--file', help = 'Provide the multianno file')
parser$add_argument('-w','--write',action='store_true',help = 'If given, writes output to a file')
parser$add_argument('-n','--name', default = 'clinvar_path.txt' , help = 'Output file name[default:clinvar_path.txt]')


args = parser$parse_args()

if (is.null(args$file)) {
  stop('Please provide input multianno file')
}


if (is.null(args$database)) {
  stop('Please provide clinvar VCF file')
}


db = fread(args$database,sep = '\t', stringsAsFactors = F)
colnames(db)[1] = 'chr'
db$clinsig = str_extract(db$INFO, 'CLNSIG=.*?;')
db$clinsig = gsub('CLNSIG=|;','',db$clinsig)

db = db[grep('pathogenic',x = db$clinsig, ignore.case = T),]
db = db[grep('conflicting',x = db$clinsig, ignore.case = T,invert = T),]

db$gene = str_extract(db$INFO, 'GENEINFO=.*?;')
db$gene = gsub('GENEINFO=|;','',db$gene)
db$chr = paste('chr',db$chr,sep = '')
db$cln_disease =  str_extract(db$INFO,'CLNDN=.*?;')
db$cln_disease =  gsub('CLNDN=|;','',db$cln_disease)
db = data.frame(db,stringsAsFactors = F)
db$var = paste(db$chr,db$POS,db$REF,db$ALT, sep = '-')

db = db[,c("var","cln_disease","clinsig","gene")]

df = fread(args$file, stringsAsFactors = F, na.strings = args$EmptyFeildCharacter, sep = '\t')
df = data.frame(df,stringsAsFactors = F)

df$var = paste(df$Otherinfo4,df$Otherinfo5,df$Otherinfo7,df$Otherinfo8, sep = '-')


mdf = merge(df,db,by = 'var', sort = F)

if (nrow(mdf) == 0) {
  mdf = 'No overlaping variants were identified in this sample. Please have a look on VCF file for potentially missing variant in known pathogenic set'
}


if (args$write) {
  write.table(mdf,args$name,sep = '\t', row.names = F, quote = F)
}
if (!args$write){
  mdf
}


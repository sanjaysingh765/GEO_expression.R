#This script uses accession number as command
#Uses Rscript script_name accession mnumber

##First read in the arguments listed at the command line
args=(commandArgs(TRUE))



##args is now a list of character vectors
## First check to see if arguments are passed.
## Then cycle through each element of the list and evaluate the expressions.
if(length(args)==0){
    print("Please give a valid accession number such as GSE16765")
}else{
library(GEOquery)
#options('download.file.method'='curl')
options('download.file.method.GEOquery' = 'libcurl')


##First read in the arguments listed at the command line
args=(commandArgs(TRUE))

# load series and platform data from GEO
gset <- getGEO(args, GSEMatrix =TRUE, AnnotGPL=TRUE, destdir = "./")  #change the repository accession id and directory
#R.utils::gunzip("GSE16765_series_matrix.txt.gz") #change name of file
gse <- gset[[1]]
pd <- pData(gse)
names(pd)
head(pd)
expressionTable =  exprs(gse)
expressionTable
write.table(expressionTable,sep="\t",row.names=T,file='expression.txt',quote=F)
}

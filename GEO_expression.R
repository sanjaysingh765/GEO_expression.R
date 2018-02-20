library(GEOquery)
#options('download.file.method'='curl')
options('download.file.method.GEOquery' = 'libcurl')

# load series and platform data from GEO
gset <- getGEO("GSE16765", GSEMatrix =TRUE, AnnotGPL=TRUE, destdir = "./")
R.utils::gunzip("GSE16765_series_matrix.txt.gz") #change name of file
gse <- gset[[1]]
pd <- pData(gse)
names(pd)
head(pd)
expressionTable =  exprs(gse)
expressionTable
write.table(expressionTable,sep="\t",row.names=T,file='expression.txt')

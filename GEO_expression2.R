
# modified from here https://rjbioinformatics.com/2016/08/05/creating-annotated-data-frames-from-geo-with-the-geoquery-package/

library(GEOquery)
#options('download.file.method'='curl')
options('download.file.method.GEOquery' = 'libcurl')

x <- "GSE680" #change the repository accession id and directory
getGEOdataObjects <- function(x, getGSEobject=FALSE){

GSEDATA <- getGEO(x, GSEMatrix=T, AnnotGPL=FALSE, destdir = "./") #change the repository accession id and directory

# Inspect the object by printing a summary of the expression values for the first 2 columns
print(summary(exprs(GSEDATA[[1]])[, 1:2]))
 
# Get the eset object
eset <- GSEDATA[[1]]
 
# check whether we want to return the list object we downloaded on GEO or
# just the eset object with the getGSEobject argument
if(getGSEobject) return(GSEDATA) else return(eset)
}


# Inspect the object by printing a summary of the expression values for the first 2 columns
print(summary(exprs(GSEDATA[[1]])[, 1:2]))
 
# Get the eset object
eset <- GSEDATA[[1]]


# Store the dataset ids in a vector GEO_DATASETS just in case you want to loop through several GEO ids
GEO_DATASETS <- c("GSE680")
 
# Use the function we created to return the eset object
eset <- getGEOdataObjects(GEO_DATASETS[1])
# Inspect the eset object to get the annotation GPL id
eset 

# Get the annotation GPL id (see Annotation: GPL10558)
gpl <- getGEO('GPL198', destdir=".")  #change GPL id
Meta(gpl)$title
 
# Inspect the table of the gpl annotation object
colnames(Table(gpl))
 
# Get the gene symbol and entrez ids to be used for annotations
Table(gpl)[1:17, c(1, 8, 11, 14)]  #change column number you are intrested
dim(Table(gpl))
 
# Get the gene expression data for all the probes with a gene symbol
geneProbes <- which(!is.na(Table(gpl)$AGI))
probeids <- as.character(Table(gpl)$ID[geneProbes])
 
probes <- intersect(probeids, rownames(exprs(eset)))
length(probes)
 
geneMatrix <- exprs(eset)[probes, ]
 
inds <- which(Table(gpl)$ID %in% probes)
# Check you get the same probes
head(probes)
head(as.character(Table(gpl)$ID[inds]))
 
# Create the expression matrix with gene ids
geneMatTable <- cbind(geneMatrix, Table(gpl)[inds, c(1, 6, 9, 12)])
head(geneMatTable)
 
# Save a copy of the expression matrix as a csv file
write.csv(geneMatTable, paste(GEO_DATASETS[1], "_DataMatrix.csv", sep=""), row.names=T)


library(probemapper)
library(lcdb)

PMServer <- SOAPServer("qbri.swmed.edu", "ProbeMapperWS/services/ProbeMapperSOAP", 80)
LCDBServer <- lcdb.server("qbri.swmed.edu")

#' Get the gene level data for an entire dataset.
#' Note that this will only work on the cluster (including RStudio) as it references
#' a local file to read in the data.
#' 
#' @param datasetID The ID of the dataset to read in
#' @param normalizationType The normalization type to read -- 1 for original, 2 for reprocessed
getGeneLevelData <- function(datasetID, normalizationType=2){
  #get all expression data from dataset #14 (consortium) of normalization type 2 (reprocessed)
  rd2 <- readRDS(paste("/home/data/QBRI/LCDB_Exports/",datasetID,"-n",normalizationType,".rds", sep=""))
  
  #Get in increments of 1,000 and reassemble to avoid overwhelming the web server with a single request for a whole platform
  probeToGene <- pm.getGenesByProbe(PMServer, rownames(rd2)[1])
  for (i in seq(2, nrow(rd2), by=1000)){
    print(i)
    p2g <- pm.getGenesByProbe(PMServer, rownames(rd2)[i:min(i+999, nrow(rd2))])
    probeToGene <- rbind(probeToGene, p2g)
  }
  
  #remove nested lists from data.
  for (i in 1:3){
    probeToGene[,i] <- as.numeric(unlist(probeToGene[,i]))
  }
  
  #Get average from all authorities
  summarized <- aggregate(Weight ~ ProbeID + EntrezID, probeToGene, mean)
  
  #annotate probe-level data with associated gene
  geneSumm <- merge(rd2, summarized, by.x=0, by.y="ProbeID", all=TRUE)
  #trim ProbeID and weight for now
  geneSumm <- geneSumm[,c(-1, -ncol(geneSumm))]
  
  #compute the mean expression for each gene.
  geneAgg <- aggregate(geneSumm, by=list(geneSumm$EntrezID), FUN=mean)
  
  geneAgg[,-1]
}
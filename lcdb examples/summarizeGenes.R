library(probemapper)
library(lcdb)

PMServer <- SOAPServer("qbri.swmed.edu", "ProbeMapperWS/services/ProbeMapperSOAP", 80)
LCDBServer <- lcdb.server("qbri.swmed.edu")

#get all expression data from dataset #14 (consortium) of normalization type 2 (reprocessed)
rd2 <- readRDS("/home/data/QBRI/LCDB_Exports/14-n2.rds")

#Get in increments of 1,000 and reassemble to avoid overwhelming the web server
probeToGene <- pm.getGenesByProbe(PMServer, rownames(rd2)[1])
for (i in seq(2, nrow(rd2), by=1000)){
  print(i)
  p2g <- pm.getGenesByProbe(PMServer, rownames(rd2)[i:min(i+999, nrow(rd2))])
  probeToGene <- rbind(probeToGene, p2g)
}

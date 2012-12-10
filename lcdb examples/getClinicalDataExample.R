library(lcdb)

LCDBServer <- lcdb.server("qbri.swmed.edu")

#Get all clinical information in the databse
allPatients <- lcdb.getPatients(LCDBServer)

#Get all the samples associated with the Consortium Dataset (#14)
consortiumSamples <- lcdb.getSamples(LCDBServer, DatasetID = 14)
head(consortiumSamples)

#Get all patients associated with the above samples.
consortiumPatients <- lcdb.getPatients(LCDBServer, PatientID = consortiumSamples$PatientID)
head(consortiumPatients)
# This script melt the table produced by @aparrot89
# thanks again to him
library(data.table)
DT <- fread("../extras/inputevents_drug_flat.csv")
DT <- melt(DT, id.vars = c("label","concept_id"),
                measure.vars = c("itemid_cv_1", "item_cv_2", "item_cv_3","itemid_mv_1","item_mv_2"))
DT[,variable:=NULL]
setnames(DT,c('label','value'),c("label","itemid"))
write.table(DT[!is.na(itemid)],"../extras/google/concept/inputevents_drug_to_concept.csv",sep=",",col.names=TRUE, row.names=FALSE,quote=TRUE)

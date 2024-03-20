df <- data.frame("teste"=c("oui", "non", "peut", "non", "oui"), 
                 "a"=c(2,  1, 2, 3, 8),
                 "c"=c("a", "a", "e", "a", "r"), "d"=c(45, 22, 32, 55, 77))

group_by <- function(inpt_df, id, spe_col="NA"){
  
  if (typeof(id) == "character"){ id <- match(id, colnames(inpt_df)) }
  
  rtn_df <- data.frame(matrix(nrow=1, ncol=(ncol(inpt_df)-1)))
  
  if (all(spe_col == "NA")==T){ 
    
    spe_col <- c(1:ncol(inpt_df))[-id] 
    
  }else if (typeof(spe_col) == "character") { 
    
        cl_nms <- colnames(inpt_df)
        
        for (el in 1:length(spe_col)){ spe_col[el] <- match(spe_col[el], 
                                                            cl_nms) }
        
        spe_col <- as.numeric(spe_col)
        
  }
  
  ids <- unique(inpt_df[, id])
  
  for (el in ids){
    
    pre_col <- c()
    
    for (col in spe_col) { pre_col <- c(pre_col, 
                                  sum(inpt_df[inpt_df[, id]==el, col])) }
    
    rtn_df <- rbind(rtn_df, pre_col)
    
  }
  
  return(cbind(ids, rtn_df[-1, ]))
  
}

print(group_by(inpt_df=df[, c(1, 2, 4)], id="teste", spe_col=c("a", "d")))

print(group_by(inpt_df=df[, c(1, 2, 4)], id="teste", spe_col=c(2, 3)))






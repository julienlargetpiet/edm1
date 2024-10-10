rtn_v <- c()
for (i in 1:10000){
  rtn_v <- c(rtn_v, as.character(as.numeric(Sys.time()) %% 1))
  if (nchar(rtn_v[length(rtn_v)]) < 17){
    n_missing <- 17 - nchar(rtn_v[length(rtn_v)])
    rtn_v[length(rtn_v)] <- paste(c(rtn_v[length(rtn_v)], rep(x = 0, times = n_missing)), collapse = "")
  }
}

write.table(x = rtn_v, file = "out_time.csv")


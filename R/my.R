normal_gen1 <- function(n_inpt = 100,
                        mean_inpt, 
                        sd_inpt, 
                        offset_proba = 0.01,
                        runification = TRUE,
                        random_data,
                        accuracy){
  rtn_v <- c()
  if (runification){
    random_data <- random_data[round(x = runif(n = n_inpt, min = 1, max = n_inpt), digit = 0)]
  }
  offset_val <- (log(0.01 * sd_inpt * (2 * pi) ** 0.5) * - 2) ** 0.5 * sd_inpt
  cur_step <- (2 * offset_val) / n_inpt
  ref_v <- seq(from = cur_step, to = offset_val, by = cur_step)
  already_v = rep(x = 0, times = length(ref_v))
  cnt = 1
  while (length(rtn_v) < n_inpt){
    cur_time <- random_data[cnt %% length(random_data)]
    if (cur_time <= offset_val){
      cur_max_val <- (1 / (sd_inpt * sqrt(2 * pi))) * exp(-(((cur_time / sd_inpt) ** 2) / 2))
      min_idx <- which.min(ref_v - cur_time)
      if (already_v[min_idx] < cur_max_val * 2 - accuracy){
        if (cnt %% 2 == 0){
          rtn_v <- c(rtn_v, (mean_inpt - cur_time))
        }else{
          rtn_v <- c(rtn_v, (mean_inpt + cur_time))
        }
      }
    }
    if ((cnt + 1) < length(random_data)){
      cnt = cnt + 1
    }else{
      cnt = 1
    }
  }
  return(rtn_v)
}

#time_data <- as.numeric(unlist(read.table(file = "out_time.csv")))
time_data <- runif(n = 1000, min = 0, max = 0.5)
#normal_offset_val(mean_inpt = 15, sd_inpt = 0.1, proba = 0.01)

x <- normal_gen1(n_inpt = 10000,
                  mean_inpt = 15,
                  sd_inpt = 0.1,
                  offset_proba = 0.01,
                  runification = TRUE,
                  random_data = time_data,
                  accuracy = 1 / length(time_data))




normal_gen1 <- function(n_inpt = 100,
                        mean_inpt, 
                        sd_inpt, 
                        offset_proba = 0.01,
                        low_del,
                        intervl){
  rtn_v <- c()
  offset_val <- (log(0.01 * sd_inpt * (2 * pi) ** 0.5) * - 2) ** 0.5 * sd_inpt
  random_data <- runif(n = n_inpt * 2, min = 0, max = offset_val)
  cur_step <- offset_val / n_inpt
  ref_v <- seq(from = cur_step, to = offset_val, by = cur_step)
  already_v = rep(x = 0, times = length(ref_v))
  cnt = 1
  while (length(rtn_v) < n_inpt){
    cur_time <- random_data[cnt %% length(random_data)]
    cur_max_val <- (1 / (sd_inpt * sqrt(2 * pi))) * exp(-(((cur_time / sd_inpt) ** 2) / 2))
    min_idx <- which.min(abs(ref_v - cur_time))
    if (already_v[min_idx] < cur_max_val * 2 - low_del){
      if (cnt %% 2 == 0){
        rtn_v <- c(rtn_v, (mean_inpt - cur_time))
      }else{
        rtn_v <- c(rtn_v, (mean_inpt + cur_time))
      }
      if (min_idx - intervl < 1){
        already_v[1:(min_idx + intervl)] = already_v[1:(min_idx + intervl)] + (1 / n_inpt)
      }else if (min_idx + intervl > length(already_v)){
        already_v[(min_idx - intervl):length(already_v)] = already_v[(min_idx - intervl):length(already_v)] + (1 / n_inpt)
      }else{
        already_v[(min_idx - intervl):(min_idx + intervl)] = already_v[(min_idx - intervl):(min_idx + intervl)] + (1 / n_inpt)
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

x <- normal_gen1(n_inpt = 5000,
                  mean_inpt = 15,
                  sd_inpt = 1,
                  offset_proba = 0.01,
                  low_del = 0,
                  intervl = 0.205 * 5000)

sd(x)
mean(x)

#library("ggplot2")
#pdf("cur_math.pdf")
#rtn_datf <- data.frame(matrix(nrow = 0, ncol = 3))
#for (i in seq(from = 0.25, to = 60, by = 0.1)){
#  cur_norm <- summary(rnorm(n = 5000, mean = 100, sd = i))[2]
#  rtn_datf <- rbind(rtn_datf, c(i, cur_norm, cur_norm / i))
#}
#colnames(rtn_datf) <- c("sd", "Quantile", "Quantile_divided")
#print(names(rtn_datf))
#
#ggplot(data = rtn_datf, mapping = aes(x = sd, y = Quantile)) + 
#  geom_point() + 
#  theme_minimal()
#
#ggplot(data = rtn_datf, mapping = aes(x = sd, y = Quantile_divided)) + 
#  geom_point() + 
#  theme_minimal()

#library("ggplot2")
#library("edm1")
#
#normal_offset_val <- function(mean_inpt, sd_inpt, proba = 0.01){
#  return((log(proba * sd_inpt * (2 * pi) ** 0.5) * - 2) ** 0.5 * sd_inpt + mean_inpt)
#}
#
#sd_inpt <- 2
#mean_inpt <- 15
#cur_offset_val <- normal_offset_val(mean_inpt = 0, sd_inpt = sd_inpt, proba = 0.001)
#rtn_datf <- data.frame(matrix(nrow = 0, ncol = 2))
#
#for (i in seq(from = (mean_inpt - cur_offset_val), to = (mean_inpt + cur_offset_val), by = 0.01)){
#  rtn_datf <- rbind(rtn_datf, c(i, normal_dens(target_v = i, mean = mean_inpt, sd = sd_inpt)))
#}
#
#colnames(rtn_datf) <- c("values", "freq")
#
#pdf("norm.pdf")
#ggplot(data = rtn_datf, mapping = aes(x = values, y = freq)) + 
#  geom_point() + 
#  theme_minimal()







library(stringr)
library(openxlsx)
library(stringi)

#' diff_xlsx
#'
#' Allow to see the difference between two datasets and output it into an xlsx file
#'
#' @param file_ is the file where the data is
#' @param sht is the sheet where the data is
#' @param v_old_begin is the corrdinate (row, column) where the data to be compared starts
#' @param v_old_end is the same but for its end
#' @param v_new_begin is the coordinates where the comparator data starts
#' @param v_new_end is the same but for its end
#' @param df2 is optional, if the comparator dataset is directly a dataframe
#' @param overwrite allow to overwrite differences is (set to T by default)
#' @param color_ is the color the differences will be outputed
#' @param pattern is the pattern that will be added to the differences if overwritten is set to TRUE 
#' @param output is the name of the outputed xlsx (can be set to NA if no output)
#' @param new_val if overwrite is TRUE, then the differences will be overwritten by the comparator data
#' @param pattern_only will cover differences by pattern if overwritten is set to TRUE 
#' @export

diff_xlsx <- function(file_, sht, v_old_begin, v_old_end, 
                      v_new_begin, v_new_end, df2=NA, overwrite=T, 
                      color_="red", pattern="", output="out.xlsx", new_val=T,
                      pattern_only=T){
  
  rd <- read.xlsx(file_, sheet=sht, col_names=NA)
  
  data_ <- data.frame(rd)
  
  df <- data_[v_old_begin[1]:v_old_end[1], v_old_begin[2]:v_old_end[2]]
  
  if (is.na(df2) == F){
    
    df2 <- df2[v_new_begin[1]:v_new_end[1], v_new_begin[2]:v_new_end[2]]
    
  }else{
    
    df2 <- data_[v_new_begin[1]:v_new_end[1], v_new_begin[2]:v_new_end[2]]
    
  }
  
  nb_diff = 0
  
  c_l <- c()
  
  c_c <- c()
  
  for (I in 1:ncol(df)){
    
    for (i in 1:nrow(df)){
      
      if (df[i, I] != df2[i, I]){
        
        nb_diff = nb_diff + 1
        
        c_l <- append(c_l, i)
        
        c_c <- append(c_c, I)
        
        if (overwrite == T){
          
          if (new_val == T){
            
            data_[i + v_old_begin[1] - 1, I + v_old_begin[2] - 1] <- df2[i, I]
            
          }else{
            
            if (pattern_only == F){
              
              data_[i + v_old_begin[1] - 1, I + v_old_begin[2] - 1] <- pattern
              
            }else{
              
              data_[i + v_old_begin[1] - 1, I + v_old_begin[2] - 1] <- paste0(data_[i + v_old_begin[1] - 1, I + v_old_begin[2] - 1], pattern)
              
            }
            
          }
          
        }
        
      }
      
    }
    
  }
  
  if (is.na(output) == F){
    
    f <- output
    
  }else{
    
    f <- file_
    
  }
  
  if (overwrite == T){
    
    write.xlsx(data_, output, rowNames=FALSE, colNames=FALSE)
    
  }
  
  wb <- loadWorkbook(f)
  
  diff_style <- createStyle(fontColour = "red",
                            fontSize = 11,
                            fontName="Trebuchet MS",
                            halign = "center",
                            valign = "center",
  )
  
  addStyle(wb,
           "Sheet 1",
           diff_style,
           c_l,
           c_c,
  )
  
  saveWorkbook(wb, f, overwrite=T)
  
  return(nb_diff)
  
}

#' insert_df
#'
#' Allow to insert dataframe into another dataframe according to coordinates (row, column) from the dataframe that will be inserted
#' @param df_in is the dataframe that will be inserted 
#' @param df_ins is the dataset to be inserted
#' ins_loc is a vector containg two parameters (row, column) of the begining for the insertion
#' @export

insert_df <- function(df_in, df_ins, ins_loc){

  ins_loc <- ins_loc - 1
  
  df_pre1 <- df_in[0:ins_loc[1], 1:ncol(df_in)] 
  
  if ((ins_loc[1] + nrow(df_ins)) > nrow(df_in)){
    
    df_pre2 <- df_in[(ins_loc[1]+1):nrow(df_in), 1:ncol(df_in)]
    
    df_pre3 <- df_in[0:0, 1:ncol(df_in)]
    
    row_end <- nrow(df_pre2)
    
  }else{
    
    df_pre2 <- df_in[(ins_loc[1]+1):(ins_loc[1]+nrow(df_ins)), 1:ncol(df_in)]
    
    df_pre3 <- df_in[(ins_loc[1] + nrow(df_ins) + 1):nrow(df_in), 1:ncol(df_in)]
    
    row_end <- nrow(df_ins)
    
  }
  
  t = 1
  
  for (i in 1:ncol(df_ins)){
    
    df_pre2[, (ins_loc[2]+i)] <- df_ins[1:row_end, t] 
    
    t = t + 1
    
  }
  
  rtnl <- rbind(df_pre1, df_pre2, df_pre3)
  
  return(rtnl)
  
}

#' pattern_generator
#'
#' Allow to create patterns which have a part that is varying aech time randomly
#' @param base_ is the pattern that will be kept
#' @param from_ is the vector from which the element of the varying part will be generated
#' @param hmn is how many of varying pattern from the same base will be created
#' @param after is set to 1 by default, it means that the varying part will be after the fixed part, set to 0 if you want the varying part to be before 
#' @export

pattern_generator <- function(base_, from_, lngth, hmn=1, after=1){
  
  rtnl <- c()
  
  base_ <- unlist(str_split(base_, ""))
  
  base2_ <- base_
  
  for (I in 1:hmn){
    
    for (i in 1:lngth){
      
      idx <- round(runif(1, 1, length(from_)), 0)
      
      if (after == 1){
        
        base_ <- append(base_, from_[idx])
        
      }else{
        
        base_ <- append(base_, from_[idx], after=0)
        
      }
      
    }
    
    base_ <- stri_paste(base_, collapse="")
    
    rtnl <- append(rtnl, base_)
    
    base_ <- base2_
    
  }
  
  return(rtnl)
  
}

#' pattern_tuning
#'
#' Allow to tune a pattern very precisely
#' @param pattrn is the character that will be tuned 
#' @param spe_nb is the number of new character that will be replaced
#' @param spe_l is the source vector from which the new characters will be replace old ones
#' @param exclude_type is character that won't be replaced
#' @param hmn is how many output the function will return
#' @param rg is a vector with two parameters (index of the first letter that will be replaced, index of the last letter that will be replaced) default is set to all the letters from the source pattern
#' @export

pattern_tuning <- function(pattrn, spe_nb, spe_l, exclude_type, hmn=1, rg=c(0, 0)){
  
  lngth <- nchar(pattrn)
  
  if (rg[2] == 0){
    
    rg[2] = lngth
    
  }
  
  rtnl <- c()
  
  if (spe_nb < lngth | rg[1] < 0 | rg[2] > lngth){
    
    pattrn2 <- unlist(str_split(pattrn, ""))
    
    pattrn_l <- c()
    
    for (i in 1:lngth){
      
      pattrn_l <- append(pattrn_l, pattrn2[i])
      
    }
    
    pattrn <- pattrn_l
    
    b_l <- c()
    
    for (i in rg[1]:rg[2]){
      
      if (pattrn[i] %in% spe_l){
        
        b_l <- append(b_l, T)
        
      }else{
        
        b_l <- append(b_l, F)
        
      }
      
    }
    
    spe_nb_obj = sum(b_l)
    
    spe_nb_obj2 <- spe_nb_obj
    
    if (all(b_l) == F){
      
      for (I in 1:hmn){ 
        
        while (spe_nb_obj < spe_nb){
          
          if (rg[2] == lngth & rg[1] == 0){
            
            idx <- round(runif(1, 1, lngth), 0)
            
          }else{
            
            idx <- round(runif(1, rg[1], rg[2]), 0)
            
          }
          
          if (sum(grepl(pattrn[idx], spe_l)) == 0 & sum(grepl(pattrn[idx], exclude_type)) == 0){
            
            pattrn[idx] <- spe_l[round(runif(1, 1, length(spe_l)), 0)]
            
            spe_nb_obj = spe_nb_obj + 1
            
          }
          
        }
        
        spe_nb_obj = spe_nb_obj2
        
        pattrn <- stri_paste(pattrn, collapse="")
        
        rtnl <- append(rtnl, pattrn)
        
        pattrn <- pattrn_l 
        
      }
      
    }
    
    return(rtnl)
    
  }else{
    
    print("word too short for your arguments, see the documentation")
    
  }
  
}

#' unique_pos
#'
#' Return the indexes of the first unique values from a vector
#'
#' @param vec is the input vector
#' @export

unique_pos <- function(vec){

        u_vec <- unique(vec)

        return(match(u_vec, vec))

}

#' can_be_num
#'
#' Return TRUE if a variable can be converted to a number and FALSE if not
#' @param x is the input value
#' @export

can_be_num <- function(x){

    if (typeof(x) == "double"){

            return(T)

    }else{

        vec_bool <- c()

        v_ref <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")    

        v_wrk <- unlist(str_split(x, ""), v_ref)

        for (i in 1:length(v_wrk)){ vec_bool <- append(vec_bool, sum(grepl(v_wrk[i], v_ref))) }

        if (sum(vec_bool) == length(vec_bool)){

                return(T)

        }else{

                return(F)

        }

    }

}

#' data_gen
#'
#' Allo to generate in a csv all kind of data you can imagine according to what you provide
#' @param type_ is a vector for wich argument is a column, a column can be made of numbers ("number"), string ("string") or both ("mixed")
#' @param strt_l is a vector containing for each column the row from which the data will begin to be generated
#' @param nb_r is a vector containing for each column, the number of row full from generated data  
#' @param output is the name of the output csv file
#' @param type_distri is a vector which, for each column, associate a type of distribution ("random", "poisson", "gaussian"), it meas that non only the number but also the length of the string will be randomly generated according to these distribution laws
#' @param properties is linked to type_distri because it is the parameters ("min_val-max_val") for "random type", ("u-x") for the poisson distribution, ("u-d") for gaussian distribution
#' @param str_source is the source (vector) from which the character creating random string are (defult set to the occidental alphabet)
#' @param round_l is a vector which, for each column containing number, associate a round value
#' @param sep_ is the separator used to write data in the csv
#' @return new generated data in addition to saving it in the output
#' @export

data_gen <- function(type_=c("number", "mixed", "string"), strt_l=c(0, 0, 10), nb_r=c(50, 10, 40), output="gened.csv", properties=c("1-5", "1-5", "1-5"), type_distri=c("random", "random", "random"), str_source=c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "w", "x", "y", "z"), round_l=c(0, 0, 0), sep_=","){
  
  v_get1 <- c()
  
  v_get2 <- c()
  
  delta_ <- c()
  
  for (i in 1:length(properties)){
    
    v_get1 <- append(v_get1, unlist(str_split(properties[i], "-"))[1])
    
    v_get2 <- append(v_get2, unlist(str_split(properties[i], "-"))[2])
    
    delta_ <- append(delta_, (strt_l[i] + nb_r[i]))
    
  }
  
  v_get1 <- as.numeric(v_get1)
  
  v_get2 <- as.numeric(v_get2)
  
  rtnl <- data.frame(matrix(NA, nrow=max(delta_), ncol=length(type_)))
  
  for (I in 1:length(type_)){
    
    if (type_[I] == "mixed"){
      
      for (i in strt_l[I]:(nb_r[I]+strt_l[I])){
        
        str_ <- round(runif(1, 0, 1), 0)
        
        if (str_ == 1){
          
          if (type_distri[I] == "random"){
            
            add_ <- round(runif(1, v_get1[I], v_get2[I]), 0)
            
            if (add_ > length(str_source)){
              
              add_ <- length(str_source)
              
            }
            
            rtnl[i, I] <- stri_paste(str_source[1:add_], collapse="")
            
          }
          
          if (type_distri[I] == "poisson"){
            
            add_ <- round(dpois(v_get1[I], v_get2[I]), 0)
            
            if (add_ > length(str_source)){
              
              add_ <- length(str_source)
              
            }
            
            rtnl[i, I] <- stri_paste(str_source[1:add_], collapse="")
            
          }
          
          if (type_distri[I] == "gaussian"){
            
            add_ <- round(runif(1, v_get1[I], v_get2[I]), 0)
            
            if (add_ > length(str_source)){
              
              add_ <- length(str_source)
              
            }
            
            rtnl[i, I] <- stri_paste(str_source[1:add_], collapse="")
            
          }
          
        }else{
          
          
          if (type_distri[I] == "random"){
            
            add_ <- round(runif(1, v_get1[I], v_get2[I]), round_l[I])
            
            rtnl[i, I] <- add_
            
          }
          
          if (type_distri[I] == "poisson"){
            
            add_ <- round(dpois(v_get1[I], v_get2[I]), round_l[I]) 
            
            rtnl[i, I] <- add_
            
          }
          
          if (type_distri[I] == "gaussian"){
            
            add_ <- round(dnorm(v_get1[I], v_get2[I]), round_l[I])
            
            rtnl[i, I] <- add_
            
          }
          
          
        }
        
      }
      
    }
    
    if (type_[I] == "string"){
      
      for (i in strt_l[I]:(nb_r[I]+strt_l[I])){
        
        if (type_distri[I] == "random"){
          
          add_ <- round(runif(1, v_get1[I], v_get2[I]), 0)
          
          if (add_ > length(str_source)){
            
            add_ <- length(str_source)
            
          }
          
          rtnl[i, I] <- stri_paste(str_source[1:add_], collapse="")
          
        }
        
        if (type_distri[I] == "poisson"){
          
          add_ <- round(dpois(v_get1[I], v_get2[I]), 0)
          
          if (add_ > length(str_source)){
            
            add_ <- length(str_source)
            
          }
          
          rtnl[i, I] <- stri_paste(str_source[1:add_], collapse="")
          
        }
        
        if (type_distri[I] == "gaussian"){
          
          add_ <- round(runif(1, v_get1[I], v_get2[I]), 0)
          
          if (add_ > length(str_source)){
            
            add_ <- length(str_source)
            
          }
          
          rtnl[i, I] <- stri_paste(str_source[1:add_], collapse="")
          
        }
        
      }
      
    }
    
    if (type_[I] == "number"){
      
      for (i in strt_l[I]:(nb_r[I]+strt_l[I])){
        
        if (type_distri[I] == "random"){
          
          add_ <- round(runif(1, v_get1[I], v_get2[I]), round_l[I])
          
          rtnl[i, I] <- add_
          
        }
        
        if (type_distri[I] == "poisson"){
          
          add_ <- round(dpois(v_get1[I], v_get2[I]), round_l[I]) 
          
          rtnl[i, I] <- add_
          
        }
        
        if (type_distri[I] == "gaussian"){
          
          add_ <- round(dnorm(v_get1[I], v_get2[I]), round_l[I])
          
          rtnl[i, I] <- add_
          
        }
        
      }
      
    }
    
  }
  
  if (is.na(output) == F){
    
    write.table(rtnl, output, sep=sep_, row.names=F, col.names=F)
    
  }
  
  return(rtnl)
  
}

#' data_meshup
#'
#' Allow to automatically arrange 1 dimensional data according to vector and parameters
#' @param data is the data provided (vector) each column is separated by a unic separator and each dataset from the same column is separated by another unic separator (ex: c("_", c("d", "-", "e", "-", "f"), "_", c("a", "a1", "-", "b", "-", "c", "c1")"_")
#' @param cols is the colnames of the data generated in a csv
#' @param file_ is the file to which the data will be outputed
#' @param sep_ is the separator of the csv outputed
#' @param organisation is the way variables include themselves, for instance ,resuming precedent example, if organisation=c(1, 0) so the data output will be:
#' d, a
#' d, a1
#' e, c
#' f, c
#' f, c1
#' @param unic_sep1 is the unic separator between variables (default is "_")
#' @param unic_sep2 is the unic separator between datasets (default is "-")
#' @export

data_meshup <- function(data, cols=NA, file_=NA, sep_=";", 
                        organisation=c(2, 1, 0), unic_sep1="_", 
                        unic_sep2="-"){
  
  l_l <- c()
  
  l_lngth <- c()
  
  old_max_row <- -1
  
  sep_dd <- str_detect(data, unic_sep1)
  
  jsq <- sum(sep_dd[!is.na(sep_dd)]) - 1 #numb of var
  
  sep_dd <- str_detect(data, unic_sep2)
  
  hmn <- (sum(sep_dd[!is.na(sep_dd)]) / jsq) #numb of datasets
  
  val_nb <- length(data) - (hmn * jsq + (jsq + 1))  
  
  dataset_l <- which(str_detect("-", data))
  
  df <- data.frame(matrix(nrow = val_nb, ncol = jsq))
  
  for (I in 1:hmn){
    
    idx_s = 0
    
    seq_l <- seq(I, length(dataset_l), hmn)
    
    for (i in 1:jsq){
      
      idx <- dataset_l[seq_l[i]]
      
      t = 1
      
      sep_dd <- grepl(data[idx + t], c(unic_sep2, unic_sep1))
      
      while(sum(sep_dd[!is.na(sep_dd)]) == 0 & (idx + t <= length(data)) == T){
        
        l_l <- append(l_l, data[idx + t])
        
        t = t + 1
        
        sep_dd <- grepl(data[idx + t], c("-", "_"))
        
      }
      
      l_lngth <- append(l_lngth, (t - 1))
      
      df[1:length(l_l), i] <- l_l
      
      l_l <- c()
      
    }
    
    if (old_max_row == -1){
      
      df2 <- data.frame(matrix(nrow=0, ncol=jsq))
      
    }
    
    old_max_row <- max(l_lngth, na.rm=T)
    
    l_lngth <- c()
    
    for (i in 1:jsq){
      
      v_rel <- df[, i]
      
      var_ = 1
      
      x = 1
      
      while (x <= organisation[i]){
        
        v_relb <- df[, i + x]
        
        val_ <- v_rel[var_] # val to be added
        
        for (t in 1:length(v_relb[!is.na(v_relb)])){
          
          df[t, i] <- val_ 
          
          if (t + 1 <= length(v_rel)){
            
            if (is.na(v_rel[t + 1]) == F){
              
              var_ = var_ + 1 
              
              while (is.na(v_rel[var_]) == T){
                
                var_ = var_ + 1 
                
              }
              
              val_ <- v_rel[var_]  
              
            }
            
          }
          
        }
        
        x = x + 1
        
      }
      
    }
    
    df2 <- rbind(df2, df[1:old_max_row, 1:jsq])
    
    df[1:nrow(df), 1:ncol(df)] = NA
    
  }
  
  if (all(is.na(cols)) == F){
    
    colnames(df2) <- cols
    
  }
  
  if (is.na(file_)){
    
    return(df2)
    
  }else{
    
    write.table(df2, file_, sep=sep_, row.names=F)
    
  }
  
}

#' letter_to_nb
#'
#' Allow to get the number of a spreadsheet based column by the letter ex: AAA = 703
#'
#' @param letter is the letter (name of the column)
#' @export

letter_to_nb <- function(letter){
  
  l <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
         "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
  
  nb = 0
  
  nch <- nchar(letter) - 1
  
  for (i in 0:nch){
    
    x <- str_sub(letter, nchar(letter) - i, nchar(letter) - i)
    
    x <- tolower(x)
    
    nb <- nb + match(x, l) * 26 ** i
    
  }
  
  return(nb)
  
}

#' nb_to_letter
#'
#' Allow to get the letter of a spreadsheet based column by the number ex: 703 = AAA
#'
#' @param x is the number of the column 
#' @export

nb_to_letter <- function(x){
  
  l <- c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
         "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z")
  
  rtnl  <- c()
  
  x_l <- c()
  
  r_l <- c()
  
  abc_l <- c()
  
  t = 1
  
  add_ <- 1
  
  reste <- 0
  
  while (x %/% add_ > 0){
    
    r_l <- append(r_l, reste)
    
    x_l <- append(x_l, add_)
    
    add_ <- 26 ** t
    
    reste <- x %% add_
    
    t = t + 1
    
  }
  
  for (i in 1:length(x_l)){
    
    idx <- length(x_l) - (i - 1)
    
    add_ <- x %/% x_l[idx]
    
    rtnl <- append(rtnl, l[add_])
    
    x <- r_l[idx]
    
  }
  
  rtnl <- paste(rtnl, collapse="")
  
  return(rtnl)
  
}

#' cost and taxes
#'
#' Allow to calculate basic variables related to cost and taxes from a bunch of products (elements)
#' So put every variable you know in the following order:
#'
#' @param qte is the quantity of elements
#' @param pu is the price of a single elements without taxes
#' @param prix_ht is the duty-free price of the whole set of elements
#' @param tva is the percentage of all taxes
#' @param prix_ttc is the price of all the elements with taxes
#' @param prix_tva is the cost of all the taxes
#' @param pu_ttc is the price of a single element taxes included
#' @param adjust is the discount percentage
#' @param prix_d_ht is the free-duty price of an element after discount
#' @param prix_d_ttc is the price with taxes of an element after discount
#' @param pu_d is the price of a single element after discount and without taxes
#' @param pu_d_ttc is the free-duty price of a single element after discount
#'
#' the function return a vector with the previous variables in the same order
#' those that could not be calculated will be represented with NA value
#' @export

cost_and_taxes <- function(qte=NA, pu=NA, prix_ht=NA, tva=NA, prix_ttc=NA,
                           prix_tva=NA, pu_ttc=NA, adjust=NA, prix_d_ht=NA,
                           prix_d_ttc=NA, pu_d=NA, pu_d_ttc=NA){
  
  val_l <- c(qte, pu, prix_ht, tva, prix_ttc, prix_tva, pu_ttc, adjust,
             prix_d_ht, prix_d_ttc, pu_d, pu_d_ttc)
  
  already <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  
  rtnl <- c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  
  for (i in 1:length(already)){
    
    if (is.na(val_l[i]) == F){
      
      already[i] <- 1
      
      rtnl[i] <- val_l[i]
      
    }
    
  }
  
  for (i in 1:16){
    
    if (is.na(prix_ttc) == F & is.na(prix_d_ttc) == F & already[8] == 0){
      
      adjust <- prix_ttc / prix_d_ttc - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }

    if (is.na(prix_ht) == F & is.na(prix_d_ht) == F & already[8] == 0){
      
      adjust <- prix_ht / prix_d_ht - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }
    
    if (is.na(pu_ttc) == F & is.na(pu_d_ttc) == F & already[8] == 0){
      
      adjust <- pu_ttc / pu_d_tcc - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }

    if (is.na(pu) == F & is.na(pu_d) == F & already[8] == 0){
      
      adjust <- pu / pu_d - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }

    if (is.na(qte) == F & is.na(pu_d) == 0 & already[9] == 0){
      
      prix_d_ht <- qte * pu_d
      
      already[9] <- 0
      
      rtnl[9] <- prix_d_ht
      
    }
    
    if (is.na(qte) == F & is.na(pu_d_ttc) == 0 & already[10] == 0){
      
      prix_d_ttc <- qte * pu_d_ttc
      
      already[10] <- 0
      
      rtnl[10] <- prix_d_ht
      
    }
    
    if (is.na(prix_d_ttc) == F & is.na(qte) == F & already[12] == 0){
      
      pu_d_ttc <- prix_d_ttc / qte
      
      already[12] <- 1
      
      rtnl[12] <- pu_d_ttc
      
    }
    
    if (is.na(prix_d_ht) == F & is.na(qte) == F & already[11] == 0){
      
      pu_d <- prix_d_ht / qte
      
      already[11] <- 1
      
      rtnl[11] <- pu_d
      
    }
    
    if (is.na(adjust) == F & is.na(prix_ttc) == F & already[10] == 0){
      
      prix_d_ttc <- prix_ttc * (1 - adjust)
      
      already[10] <- 1
      
      rtnl[10] <- prix_d_ttc
      
    }
    
    if (is.na(adjust) == F & is.na(prix_ht) == F & already[9] == 0){
      
      prix_d_ht <- prix_ht * (1 - adjust)
      
      already[9] <- 1
      
      rtnl[9] <- prix_d_ht
      
    }
    
    if (is.na(adjust) == F & is.na(prix_d_ht) == F & already[3] == 0){
      
      prix_ht <- prix_d_ht * (1 / (1 - adjust))
      
      already[3] <- 1
      
      rtnl[3] <- prix_ht
      
    }
    
    if (is.na(adjust) == F & is.na(prix_d_ttc) == F & already[5] == 0){
      
      prix_ttc <- prix_d_ttc * (1 / (1 - adjust))
      
      already[5] <- 1
      
      rtnl[5] <- prix_ttc
      
    }
    
    if (is.na(pu) == F & is.na(pu_ttc) == F & already[4] == 0){
      
      tva <- pu_ttc / pu - 1
      
      already[4] <- 1
      
      rtnl[4] <- tva
      
    }

    if (is.na(pu_d_ttc) == F & is.na(pu_d) == F & already[4] == 0){
      
      tva <- pu_d_ttc / pu_d - 1
      
      already[4] <- 1
      
      rtnl[4] <- tva
      
    }

    if (is.na(prix_d_ttc) == F & is.na(prix_d_ht) == F & already[4] == 0){
      
      tva <- prix_d_ttc / prix_d_ht - 1
      
      already[4] <- 1
      
      rtnl[4] <- tva
      
    }
    
    if (is.na(prix_ht) == F & is.na(pu) == F & already[1] == 0){
      
      qte <- prix_ht / pu
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_ttc) == F & is.na(pu_ttc) == F & already[1] == 0){
      
      qte <- prix_ttc / pu_ttc
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_d_ht) == F & is.na(pu_d) == F & already[1] == 0){
      
      qte <- prix_d_ht / pu_d
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_d_ttc) == F & is.na(pu_d_ttc) == F & already[1] == 0){
      
      qte <- prix_d_ttc / pu_d_ttc
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_ht) == F & is.na(qte) == F & already[2] == 0){
      
      pu <- prix_ht / qte
      
      rtnl[2] <- pu
      
      already[2] <- 1
      
    }
    
    if (is.na(prix_ttc) == F & is.na(qte) == F & already[7] == 0){
      
      pu_ttc <- prix_ttc / qte
      
      rtnl[7] <- pu
      
      already[7] <- 1
      
    }
    
    if (is.na(pu) == F & is.na(qte) == F & already[3] == 0){
      
      prix_ht <- pu * qte
      
      rtnl[3] <- pu
      
      already[3] <- 1
      
    }
    
    if (is.na(pu_ttc) == F & is.na(qte) == F & already[5] == 0){
      
      prix_ttc <- pu_ttc * qte
      
      rtnl[5] <- pu
      
      already[5] <- 1
      
    }
    
    if (is.na(pu) == F & is.na(qte) == F & already[3] == 0){
      
      prix_ht <- pu * qte
      
      rtnl[3] <- prix_ht
      
      already[3] <- 1
      
    }
    
    if (is.na(prix_ht) == F & is.na(prix_ttc) == F & already[4] == 0){
      
      tva <- prix_ttc / prix_ht - 1
      
      rtnl[4] <- tva
      
      already[4] <- 1
      
    }
    
    if (is.na(tva) == F & is.na(prix_ttc) == F & already[3] == 0){
      
      prix_ht <- prix_ttc / (1 + tva)
      
      rtnl[3] <- prix_ht
      
      already[3] <- 1
      
    }
    
    if (is.na(tva) == F & is.na(prix_ht) == F & already[5] == 0){
      
      prix_ttc <- prix_ht * (1 + tva) 
      
      rtnl[5] <- prix_ttc
      
      already[5] <- 1
      
    }  
    
    if (is.na(prix_ht) == F & is.na(prix_ttc) == F & already[6] == 0){
      
      prix_tva <- prix_ttc - prix_ht
      
      rtnl[6] <- prix_tva
      
      already[6] <- 1
      
    }
    
    if (is.na(tva) == F & is.na(prix_ttc) == F & already[6] == 0){
      
      prix_tva <- tva * prix_ht
      
      rtnl[6] <- prix_tva
      
      already[6] <- 1
      
    }
    
  }
  
  return(rtnl)
  
}

# xx-month-xxxx -> xx-xx-xxxx

#' formate_date
#'
#' Allow to convert xx-month-xxxx date type to xx-xx-xxxx
#'
#' @param f_dialect are the months from the language of which the month come
#' @param sentc is the date to convert
#' @param sep_in is the separator of the dat input (default is "-")
#' @param sep_out is the separator of the converted date (default is "-")
#' @export

format_date <- function(f_dialect, sentc, sep_in="-", sep_out="-"){
  
  traduct <- f_dialect
  
  x <- unlist(str_split(sentc, sep_in))
  
  x2 <- match(x[2], f_dialect)
  
  x2 <- as.character(x2)

  if (nchar(x2) == 1){

    x2 <- paste0("0", x2)
  
  }

  x <- paste0(x[1], sep_out, x2, sep_out, x[3]) 
  
  return(x)
  
}

#' until_stnl
#'
#' Maxes a vector to a chosen length 
#' 
#' ex: if i want my vector c(1, 2) to be 5 of length this function will return me: c(1, 2, 1, 2, 1) 
#' @param vec1 is the input vector
#' @param goal is the length to reach
#' @export

until_stnl <- function(vec1, goal){

  max_ = 0

  ld <- length(vec1)

  for (i in (length(vec1)+1):goal){

        if (max_ < ld){

                max_ = max_ + 1 

        }else{

                max_ = 1

        }

        vec1 <- append(vec1, vec1[max_])

  }

  return(vec1)

}

#' vlookup_df
#'
#' Alow to perform a vlookup on a dataframe
#'
#' @param df is the input dataframe
#' @param v_id is a vector containing the ids
#' @param col_id is the column that contains the ids (default is equal to 1)
#' @param included_col_id is if the result should return the col_id (default set to yes) 
#' @export

vlookup_df <- function(df, v_id, col_id=1, included_col_id="yes"){
  
  rtnl <- df[1, ]
  
  for (i in 1:length(v_id)){

    idx = match(v_id[i], df[, col_id])
    
    rtnl <- rbind(rtnl, df[idx,])
    
    df <- df[-idx, ]
    
  }
  
  if (included_col_id == "yes"){
  
    return(rtnl[-1, ])
  
  }else{
    
    return(rtnl[-1, -col_id])
    
  }
    
}

#' multitud
#'
#' From a list containing vectors allow to generate a vector following this rule:
#'
#' list(c("a", "b"), c("1", "2"), c("A", "Z", "E")) --> c("a1A", "a2A", "b1A", "b2A", "a1Z", ...)
#' @param l is the list
#' @param sep_ is the separator between elements (default is set to "" as you see in the example)
#' @export

multitud <- function(l, sep_=""){
  
  rtnl <- unlist(l[1])
  
  for (I in 2:length(l)){
    
    rtnl2 <- c()
    
    cur_ <- unlist(l[I])
    
    for (i in 1:length(cur_)){
      
      for (t in 1:length(rtnl)){
        
        rtnl2 <- append(rtnl2, paste(rtnl[t] , cur_[i], sep=sep_))
        
      }
      
    }
    
    rtnl <- rtnl2
    
  }
  
  return(rtnl)
  
}

#' df_tuned 
#'
#' Allow to return a list from a dataframe following these rules:
#' First situation, I want the vectors from the returned list be composed of values that are separated by special values contained in a vector 
#' ex: data.frame(c(1, 1, 2, 1), c(1, 1, 2, 1), c(1, 1, 1, 2)) will return list(c(1, 1), c(1, 1, 1), c(1, 1, 1, 1)) or 
#' list(c(1, 1, 2), c(1, 1, 1, 2), c(1, 1, 1, 1, 2)) if i have chosen to take in count the 2. As you noticed here the value to stop is 2 but it can be several contained in a vector
#' Second situation: I want to return a list for every jump of 3.
#' If i take this dataframe data.frame(c(1, 1, 2, 1, 4, 4), c(1, 1, 2, 1, 3, 3), c(1, 1, 1, 2, 3, 3)) it will return list(c(1, 1, 2), c(1, 4, 4), c(1, 1, 2), c(1, 3, 3), c(1, 1, 1), c(2, 3, 3)) 
#'
#' @param df is the input data.frame
#' @param val_to_stop is the vector containing the values to stop
#' @param index_rc is the value for the jump (default set to NA so default will be first case)
#' @param included is if the values to stop has to be also returned in the vectors (defaultn set to "yes")
#' @export

df_tuned <- function(df, val_to_stop, index_rc=NA, included="yes"){

 rtnl_l <- list()

 for (I in 1:ncol(df)){

        rtnl <- c()

        t = 1

        while (t <= nrow(df)){

                if (is.na(index_rc) == T){

                        while (!(df[t, I] %in% val_to_stop) == T & t <= nrow(df)){

                                rtnl <- append(rtnl, df[t, I])

                                t = t + 1

                        }

                        if (df[t, I] %in% val_to_stop & included == "yes"){ 

                                rtnl_l <- append(rtnl_l, data.frame(rtnl)) 

                                rtnl <- c()

                        }

                }else{

                        while (t %% index_rc != 0 & t <= nrow(df)){

                                rtnl <- append(rtnl, df[t, I])

                                t = t + 1

                        }

                        if (t %% index_rc == 0){

                                if (included == "yes"){ rtnl <- append(rtnl, df[t, I]) }

                                rtnl_l <- append(rtnl_l, data.frame(rtnl))

                                rtnl <- c()

                        }

                }

                t = t + 1

        }

 }

 return(rtnl_l)

}

#' see_df
#' 
#' Allow to return a datafame with TRUE cells where the condition entered are respected and FALSE where these are not
#'
#' @param df is the input dataframe
#' @param condition_l is the vector of the possible conditions ("==", ">", "<", "!=", "%%", "%%r") (equal, greater than, lower than, not equal to, is divisible by, divides), you can put the same condition n times. 
#' @param val_l is the list of vectors containing the values related to condition_l (so the vector of values has to be placed in the same order)
#' @param conjunction_l contains the | or & conjunctions, so if the length of condition_l is equal to 3, there will be 2 conjunctions. If the length of conjunction_l is inferior to the length of condition_l minus 1, conjunction_l will match its goal length value with its last argument as the last arguments. For example, c("&", "|", "&") with a goal length value of 5 --> c("&", "|", "&", "&", "&")
#' @examples see_df(df, c("%%", "=="), list(c(2, 11), c(3)), list("|") will return all the values that are divisible by 2 and 11 and all the values that are equal to 3 from the dataframe  
#' @export

see_df <- function(df, condition_l, val_l, conjunction_l=c(), rt_val=T, f_val=F){

        if (length(condition_l) > 1 & length(conjunction_l) < (length(condition_l) - 1)){

                for (i in (length(conjunction_l)+1):length(condiction_l)){

                        conjunction_l <- append(conjunction_l, conjunction_l[length(conjunction_l)])

                }

        }

        df_rtnl <- data.frame(matrix(f_val, ncol=ncol(df), nrow=nrow(df)))

        all_op <- c("==", ">", "<", "!=", "%%", "%%r")

        for (I in 1:ncol(df)){

                for (i in 1:nrow(df)){

                        checked_l <- c()

                        previous = 1

                        for (t in 1:length(condition_l)){

                                already <- 0

                                if (condition_l[t] == "==" & already == 0){

                                        if (df[i, I] %in% unlist(val_l[t])){

                                                checked_l <- append(checked_l, T)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        df_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                df_rtnl[i, I] <- rt_val

                                                                checked_l <- c()

                                                        }

                                                }

                                        }

                                        if (t <= length(conjunction_l)){ 

                                                if (conjunction_l[t] == "|"){

                                                        checked_l <- c()

                                                        previous = t + 1 

                                                }

                                        }

                                }

                                if (condition_l[t] == ">" & already == 0){

                                        if (all(df[i, I] > unlist(val_l[t])) == T){

                                                checked_l <- append(checked_l, T)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        df_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                df_rtnl[i, I] <- rt_val

                                                                checked_l <- c()

                                                        }

                                                }

                                        }

                                        if (t <= length(conjunction_l)){ 

                                                if (conjunction_l[t] == "|"){

                                                        checked_l <- c()

                                                        previous = t + 1 

                                                }

                                        }

                                }

                                if (condition_l[t] == "<" & already == 0){

                                        if (all(df[i, I] < unlist(val_l[t]))){

                                                checked_l <- append(checked_l, T)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        df_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                df_rtnl[i, I] <- rt_val

                                                                checked_l <- c()

                                                        }

                                                }

                                        }

                                        if (t <= length(conjunction_l)){ 

                                                if (conjunction_l[t] == "|"){

                                                        checked_l <- c()

                                                        previous = t + 1 

                                                }

                                        }

                                }

                                if (condition_l[t] == "!=" & already == 0){

                                        if (!(df[i, I] %in% unlist(val_l[t])) == T){

                                                checked_l <- append(checked_l, T)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        df_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                df_rtnl[i, I] <- rt_val

                                                                checked_l <- c()

                                                        }

                                                }

                                        }

                                        if (t <= length(conjunction_l)){ 

                                                if (conjunction_l[t] == "|"){

                                                        checked_l <- c()

                                                        previous = t + 1 

                                                }

                                        }

                                }

                                if (condition_l[t] == "%%" & already == 0){

                                        if (sum(df[i, I] %% unlist(val_l[t])) == 0){

                                                checked_l <- append(checked_l, T)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        df_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                df_rtnl[i, I] <- rt_val

                                                                checked_l <- c()

                                                        }

                                                }

                                        }

                                        if (t <= length(conjunction_l)){ 

                                                if (conjunction_l[t] == "|"){

                                                        checked_l <- c()

                                                        previous = t + 1 

                                                }

                                        }

                                }

                                if (condition_l[t] == "%%r" & already == 0){

                                        if (sum(unlist(val_l[t]) %% df[i, I]) == 0){

                                                checked_l <- append(checked_l, T)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        df_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        df_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                df_rtnl[i, I] <- rt_val

                                                                checked_l <- c()

                                                        }

                                                }

                                        }

                                        if (t <= length(conjunction_l)){ 

                                                if (conjunction_l[t] == "|"){

                                                        checked_l <- c()

                                                        previous = t + 1 

                                                }

                                        }

                                }

                        }
                        
                }

        }

  return(df_rtnl)

}

#' days_from_month
#'
#' Allow to find the number of days month from a month date, take in count leap year 
#' @param date_ is the input date
#' @param sep_ is the separator of the input date
#' @export

days_from_month <- function(date_, sep_){
  
  can.be.numeric <- function(x) {
    
    numNAs <- sum(is.na(x))
    
    numNAs_new <- suppressWarnings(sum(is.na(as.numeric(x))))
    
    return(numNAs_new == numNAs)
    
  }
  
  x <- unlist(str_split(date_, sep_))
  
  month <- x[2]

  year <- x[length(x)]
  
  year <- as.numeric(year)
  
  if (year %% 4 == 0){
    
    if (year %% 100 == 0){
      
      if (year %% 400 == 0){
        
        bsx <- T
        
      }else{
        
        bsx <- F
        
      }
      
    }else{
      
      bsx <- T
      
    }
    
  }else{
    
    bsx <- F
    
  }
  
  l_nm <- c(31, 00, 31, 30, 31, 30, 31, 31,
            30, 31, 30, 31)
  
  if (can.be.numeric(month) == T){
    
    nm <- as.numeric(month)
    
    month <- dialect[nm]
    
    indx <- match(month, dialect)
    
    rtnl <- l_nm[indx]
    
  }else{
    
    indx <- match(month, dialect)
    
    rtnl <- l_nm[indx]
    
  }
  
  if (rtnl == 00){
    
    if (bsx == T){
      
      rtnl <- 29
      
    }else{
      
      rtnl <- 28
      
    }
    
  }
  
  return(rtnl)
  
}

#' vec_in_df
#'
#' Allow to see if vectors are present in a dataframe
#'
#'ex: 1, 2, 1
#'    3, 4, 1
#'    1, 5, 8
#'
#' the vector c(4, 1) with the coefficient 1 and the start position at the second column is containded in the dataframe
#'
#' @param df_ is the input dataframe
#' @param vec_l is a list the vectors
#' @param coeff_ is the related coefficient of the vector
#' @param strt_l is a vector containing the start position for each vector
#' @export

vec_in_df <- function(df_, vec_l, coeff_, strt_l, distinct="NA"){

        rtnl_f <- c()

        rtnl_pos_f <- c()

        hmn_lf <- c()

        for (I in 1:length(vec_l)){

                vec <- unlist(vec_l[I])

                rtnl <- c()

                rtnl_pos <- c()

                hmn_l <- c()
                
                indx_l <- which(df_[1:nrow(df_), strt_l[I]] == vec[1])

                btm = indx_l[1] 

                top = indx_l[length(indx_l)]

                indx_l <- which(df_[btm:top, strt_l[I]] == vec[1])

                v_previous <- indx_l

                if (length(indx_l) > 0){

                        rtnl <- append(rtnl, vec[1])

                }else{

                        rtnl <- append(rtnl, distinct)

                }

                y = 1

                while (y <= length(indx_l)){

                        if (!(indx_l[y] %in% v_previous) == T){

                                indx_l <- indx_l[-y]

                        }

                        y = y + 1

                }

                ti = 2

                for (i in (strt_l[I]+1):(strt_l[I]+length(vec) - 1)){ 

                        if (btm + coeff_[I] > 0 & btm + coeff_[I] <= nrow(df_)){

                                btm = btm + coeff_[I]
                       
                        }else{

                                btm = 1

                        }

                        if (top + coeff_[I] > 0 & top + coeff_[I] <= nrow(df_)){

                                top = top + coeff_[I]

                        }else{ 

                                top = nrow(df_) 

                        }

                        indx_l <- which(df_[btm:top, i] == vec[ti]) 

                        if (length(indx_l) > 0){

                                rtnl <- append(rtnl, vec[ti])

                        }else{

                                rtnl <- append(rtnl, distinct)

                        }

                        y = 1

                        while (y <= length(indx_l)){

                                if (!((indx_l[y] - coeff_[I]) %in% v_previous) == T){ 

                                        indx_l <- indx_l[-y]

                                }

                                y = y + 1

                        }

                        v_previous <- indx_l

                        ti = ti + 1

                }

                if (all(rtnl == vec) == T){

                        hmn_l <- append(hmn_l, length(indx_l))

                        for (t in 1:length(indx_l)){

                                rtnl_pos <- append(rtnl_pos, (indx_l[t] - coeff_[I] * (length(vec) - 1)))

                                rtnl_pos <- append(rtnl_pos, indx_l[t])

                        }

                        hmn_lf <- append(hmn_lf, hmn_l)

                        rtnl_pos_f <- append(rtnl_pos_f, rtnl_pos)

                        rtnl_pos_f <- append(rtnl_pos_f, "|")

                        rtnl_f <- append(rtnl_f, T)

                }else{

                        rtnl_f <- append(rtnl_f, F)

                        rtnl_pos_f <- append(rtnl_pos_f, "|")

                }

        }

        return(list(rtnl_f, rtnl_pos_f, hmn_lf))
        
}

#returns the number of row that contains vectors (multiple in a list), coeff and strt_l may vary 
#distinct is the value you are sure is not contained in the matrix 

#' closest_date
#'
#' return the closest dates from a vector compared to the input date
#'
#' @param date_ is the input date
#' @param vec is a vector containing the dates to be compared to the input date
#' @param frmt is the format of the input date, (deault set to "snhdmy" (second, minute, hour, day, month, year), so all variable are taken in count),
#' if you only want to work with standard date for example change this variable to "dmy"
#' @param sep_ is the separator for the input date
#' @param sep_vec is the separator for the dates contained in vec
#' @param only is can be changed to "+" or "-" to repectively only return the higher dates and the lower dates (default set to "both")
#' @param head is the number of dates that will be returned (default set to NA so all dates in vec will be returned)
#' @export

closest_date <- function(vec, date_, frmt, sep_="/", sep_vec="/", only_="both", head=NA){

        date_ <- unlist(str_split(date_, sep_))

        lc <- c("s", "n", "h", "d", "m", "y")

        l_limit_max <- c(60, 60, 24, "check_l_nm", 12, 9999999)

        l_nm <- c(31, 28, 31, 30, 31, 30, 31, 31,
            30, 31, 30, 31)

        second_ <- NA

        min_ <- NA

        hour_ <- NA

        day_ <- NA

        month_ <- NA

        year_ <- NA

        l2 <- c()

        l <- c(second_, min_, hour_, day_, month_, year_)

        deb <- match(str_sub(frmt, 1, 1), lc)

        fin <- match(str_sub(frmt, nchar(frmt), nchar(frmt)), lc)

        df <- data.frame(matrix(NA, nrow=length(vec), ncol=(nchar(frmt) - 1)))

        df_bool <- data.frame(matrix(NA, nrow=length(vec), ncol=(nchar(frmt) - 1)))
       
        for (I in 1:(length(date_)-1)){

                cur <- as.numeric(date_[(length(date_) - (I - 1))])

                idx <- fin - (I - 1)

                val <- lc[idx]

                if (val == "m"){

                        m_ <- cur

                }

                if (l_limit_max[(idx-1)] == "check_l_nm"){

                        multiplicator <- l_nm[cur]

                }else{

                        multiplicator <- as.numeric(l_limit_max[idx-1])

                }
          
                to_diff <- cur * multiplicator + as.numeric(date_[(length(date_) - I)])
                
                for (i in 1:length(vec)){
                  
                        to_compare <- as.numeric(unlist(str_split(vec[i], sep_vec))[(length(date_) - (I-1))]) * multiplicator + as.numeric(unlist(str_split(vec[i], sep_vec))[(length(date_) - I)]) 
                        
                        df[i, I] <- abs(to_diff - to_compare)
                        
                        if ((to_compare - to_diff) < 0){
                          
                                df_bool[i, I] <- "-"

                        }else{
                          
                                df_bool[i, I] <- "+"

                        }

                }
                
        }

        if (is.na(head) == F){

                jsq <- head

        }else{

                jsq <- nrow(df)

        }

        if (only_ == "+"){ 

                df <- df[grep(TRUE, df_bool[, 1]=="+"), ]

        }

        if (only_ == "-"){ 

                df <- df[grep(TRUE, df_bool[, 1]=="-"), ]

        }

        fundamental_bool <- df_bool[, 1]
        
        rtnl <- c()
        
        for (I in 1:nrow(df)){
          
          dfb <- df
          
          df_boolb <- df_bool
          
          indx_l <- c()
          
          val_tp <- c(1:nrow(df))

          for (i in 1:ncol(df)){
          
            min_l <- which(min(dfb[, i]) == dfb[,i])
          
            val_tp <- val_tp[min_l]

            indx_l <- c()

            for (t in 1:length(min_l)){
             
              if (df_bool[min_l[t], i] != df_bool[min_l[t], 1]){
                
                indx_l <- append(indx_l, val_tp[t], after=0)
                
              }else{
                
                indx_l <- append(indx_l, val_tp[t])
                
              }
            
            }

            min_lb <- min_l

            dfb <- dfb[min_l, ]
            
          }
          
          rtnl <- append(rtnl, indx_l[1])
          
          df[indx_l[1], ] <- max(df[,1])
           
        }
        
  return(rtnl[1:jsq])
        
}

#' change_date
#'
#' Allow to add to a date second-minute-hour-day-month-year
#'
#' @param date_ is the input date
#' @param sep_ is the date separator
#' @param day_ is the day to add (can be negative)
#' @param month_ is the month to add (can be negative)
#' @param year_ is the year to add (can be negative)
#' @param hour_ is the hour to add (can be negative)
#' @param min_ is the minute to add (can be negative)
#' @param second_ is the second to add (can be negative)
#' @param frmt is the format of the input date, (deault set to "snhdmy" (second, minute, hour, day, month, year), so all variable are taken in count),
#' if you only want to work with standard date for example change this variable to "dmy"
#' @export

change_date <- function(date_, sep_, day_  = NA, month_ = NA, 
                        year_ = NA, hour_ = NA, min_ = NA, 
                        second_ = NA, frmt="snhdmy"){
  
  frmt_l <- unlist(str_split(frmt, ""))
  
  date_ <- unlist(str_split(date_, sep_))
  
  l_nm <- c(31, 28, 31, 30, 31, 30, 31, 31,
            30, 31, 30, 31)
  
  l_nmc1 <- c(31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334, 365)
  
  l_nmc2 <- c(31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335, 366)
  
  l <- c(second_, min_, hour_, day_, month_, year_)
  
  lc <- c("s", "n", "h", "d", "m", "y")
  
  deb <- match(frmt_l[1], lc)
  
  l_limit_min <- c()
  
  l_limit_max <- c()
  
  l_limit_min_pre <- c(0, 0, 0, 1, 1, -999999)
  
  l_limit_max_pre <- c(60, 60, 24, "check_l_nm", 12, 9999999)
  
  for (i in deb:(deb+nchar(frmt) - 1)){
    
    l_limit_min <- append(l_limit_min, l_limit_min_pre[i])
    
    l_limit_max <- append(l_limit_max, l_limit_max_pre[i])
    
  }
  
  rtnl <- c() 
  
  year <- NA
  
  mois <- NA
  
  t = 1
  
  for (i in deb:(deb + nchar(frmt) - 1)){
    
    rtnl <- append(rtnl, l[i])
    
    if (lc[i] == "m"){
      
      mois <- as.numeric(date_[t])
      
    }
    
    if (lc[i] == "y"){
      
      year <- as.numeric(date_[t])
      
    }
    
    t = t + 1
    
  }
  
  if (is.na(year) == F){
    
    if (year %% 4 == 0){
      
      if (year %% 100 == 0){
        
        if (year %% 400 == 0){
          
          l_nm[2] <- 29
          
          l_nmc <- l_nmc2
          
        }else{
          
          l_nm[2] <- 28
          
          l_nmc <- l_nmc1
          
        }
        
      }else{
        
        l_nm[2] <- 29
        
        l_nmc <- l_nmc2
        
      }
      
    }else{
      
      l_nm[2] <- 28
      
      l_nmc <- l_nmc1
      
    }
    
  }else{
    
    l_nm[2] <- 28
    
    l_nmc <- l_nmc1
    
  }
  
  date_ <- as.numeric(date_)
  
  rtnl <- as.numeric(rtnl)
  
  for (i in 1:length(rtnl)){
    
    add_up <- abs(rtnl[i])
    
    rtnl[i] <- date_[i] + rtnl[i]
    
    if (rtnl[i] == l_limit_max[i] & str_sub(frmt, i, i) %in% c("h", "s", "n")){
      
      rtnl[i] <- 0
      
      if (i + 1 <= length(date_)){ date_[i+1] <- date_[i+1] + 1 }
      
    }
    
    if (l_limit_max[i] == "check_l_nm"){
      
      if (rtnl[i] < l_limit_min[i]){
        
        t = mois
        
        t2 = 1
        
        t3 = 1
        
        status <- 1
        
        all_b <- 0
        
        divider = l_nmc[12] * (t2 - 1) + (l_nmc[t] - l_nmc[mois - 1] * (status))  
        
        add_up <- abs(l_nmc[mois] - (l_nmc[mois] - rtnl[i]))
        
        reste <- add_up %% l_nm[mois]
        
        while (add_up %/% divider > 0){
          
          reste <- add_up %% l_nm[mois]
          
          if (t + 1 > (length(l_nmc) * t2)){
            
            if (status == 1){
              
              status2 = 1
              
              all_b <- l_nmc[t] - l_nmc[mois - 1] * status
              
              }else{
                
                status2=0
                
                t2 = t2 + 1
                
              }
              
              status <- 0
              
              t = 1
            
          }
          
          divider = l_nmc[12] * (t2 - 1) + (l_nmc[t] - l_nmc[mois - 1] * (status))  
          
          t = t + 1
          
          t3 = t3 + 1
          
        } 
        
        rtnl[i] <- l_nm[mois] - reste
        
        if (i + 1 <= length(date_)){

          if (t3 == 1){t3 = t3 + 1}
                    
          date_[i + 1] <- date_[i + 1] - (t3 - 1)
          
        }
        
      }
      
      if (rtnl[i] > l_nm[mois]){
        
        status <- 1
        
        status2 <- 0
        
        t = mois
        
        t2 = 1
        
        t3 = 1
        
        divider = l_nmc[12] * (t2 - 1) + (l_nmc[t] - l_nmc[mois - 1] * (status))  
        
        reste <- add_up %% l_nmc[t]
        
        all_b <- 0
        
        while (rtnl[i] %/% divider > 0){
          
          reste <- rtnl[i] %% divider
          
          if (t + 1 > (length(l_nmc) * t2)){
            
            if (status == 1){
              
              status2 = 1
              
              all_b <- l_nmc[t] - l_nmc[mois - 1] * status
              
            }else{
                
              status2=0
              
              t2 = t2 + 1
              
              }
            
            status <- 0
            
            t = 1
            
          }
          
          t = t + 1
          
          t3 = t3 + 1
          
          divider = l_nmc[12] * (t2 - 1) + (l_nmc[t] - l_nmc[mois - 1] * status) + status2 * all_b
            
        }
        
        rtnl[i] <- reste
        
        if (i + 1 <= length(date_)){
          
          if (t3 == 1){t3 = t3 + 1}
          
          date_[i + 1] <- date_[i + 1] + (t3 - 1)
          
        }
        
      }
      
    }else{
      
      if (rtnl[i] < l_limit_min[i]){
        
        t = 1
        
        add_up <- as.numeric(l_limit_max[i]) - (as.numeric(l_limit_max[i]) + rtnl[i])
        
        reste <- add_up %% (as.numeric(l_limit_max[i]) * t)
        
        while (add_up %/% (as.numeric(l_limit_max[i]) * t) > 0){
          
          reste <- add_up %% (as.numeric(l_limit_max[i]) * t)
          
          t = t + 1
          
        } 
        
        if (str_sub(frmt, i, i) == "m"){
          
          rtnl[i] <- as.numeric(l_limit_max[i]) - reste
          
        }else{
          
          if (reste == 0){
          
            rtnl[i] <- 0
            
            t = t - 1
            
          }else{
            
            rtnl[i] <- as.numeric(l_limit_max[i]) - reste 
          
          }
          
        }
        
        if (i + 1 <= length(date_)){
          
          date_[i + 1] <- date_[i + 1] - t
          
        }
        
      }
      
      if (rtnl[i] > as.numeric(l_limit_max[i])){
        
        t = 1
        
        reste <- rtnl[i] %% (as.numeric(l_limit_max[i]) * t)
        
        while (rtnl[i] %/% (as.numeric(l_limit_max[i]) * t) > 0){
          
          reste <- rtnl[i] %% (as.numeric(l_limit_max[i]) * t)
          
          t = t + 1
          
        } 
        
        if (str_sub(frmt, i, i) == "m"){
          
          rtnl[i] <- reste
          
        }else{
          
          rtnl[i] <- reste
          
        }
        
        if (i + 1 <= length(date_)){
          
          date_[i + 1] <- date_[i + 1] + (t-1)
          
        }
        
      }
      
    }
    
  }
  
  for (i in 1:length(rtnl)){
    
    if (nchar(rtnl[i]) == 1){
      
      rtnl[i] <- paste0("0", rtnl[i])
      
    }
    
  }
  
  rtnl2 <- ""
  
  for (i in 1:length(rtnl)){ rtnl2 <- paste0(rtnl2, "-", rtnl[i]) }  
  
  rtnl2 <- str_sub(rtnl2, 2, nchar(rtnl2))
  
  return(rtnl2)
  
}

#' pattern_gettr 
#'
#' Search for pattern(s) contained in a vector in another vector and return a list containing matched one (first index) and their position (second index) according to these rules:
#'
#' First case: Search for patterns strictly, it means that the searched pattern(s) will be matched only if the patterns containded in the vector that is beeing explored by the function are present like this c("pattern_searched", "other", ..., "pattern_searched") and not as c("other_thing pattern_searched other_thing", "other", ..., "pattern_searched other_thing") 
#' Second case: It is the opposite to the first case, it means that if the pattern is partially present like in the first position and the last, it will be considered like a matched pattern
#' @param word_ is the vector containing the patterns
#' @param vct is the vector being searched for patterns
#' @param occ a vector containing the occurence of the pattern in word_ to be matched in the vector being searched, if the occurence is 2 for the nth pattern in word_ and only one occurence is found in vct so no pattern will be matched, put "forever" to no longer depend on the occurence for the associated pattern
#' @param strict a vector containing the "strict" condition for each nth vector in word_ ("strict" is the string to activate this option)
#' @param btwn is a vector containing the condition ("yes" to activate this option) meaning that if "yes", all elements between two matched patern in vct will be returned , so the patterns you enter in word_ have to be in the order you think it will appear in vct 
#' @param all_in_word is a value (default set to "yes", "no" to activate this option) that, if activated, won't authorized a previous matched pattern to be matched again
#' @param notatall is a string that you are sure is not present in vct
#' REGEX can also be used as pattern 
#' @export

pattern_gettr <- function(word_, vct, occ=c(1), strict, btwn, all_in_word="yes", notatall="###"){

  all_occ <- c()

  for (i in 1:length(word_)){ all_occ <- append(all_occ, 0) }

  if (length(btwn) < (length(occ) - 1)){

          to_app <- btwn[length(btwn)]

          for (i in length(btwn):(length(occ) - 2)){

                btwn <- append(btwn, to_app)

          }

  }

  if (length(strict) < length(occ)){

          to_app <- strict[length(strict)]

          for (i in length(strict):(length(occ) - 1)){

                strict <- append(strict, to_app)

          }

  }

  frst_occ <- c()

  occ_idx = 1

  get_ins = 0

  vct2 <- c()

  can_ins <- 0

  for (i in 1:length(vct)){

    to_compare = 0

    if (all_in_word == "yes"){

            if (strict[occ_idx] == "yes"){

                t = 1

                while (to_compare < 1 & t <= length(word_)){

                        if (nchar(word_[t]) == nchar(vct[i])){

                                v_bool <- str_detect(vct[i], word_[t])

                                to_compare = sum(v_bool)

                                if (to_compare > 0){indx <- t}

                        }

                        t = t + 1

                }

            }else{

                    v_bool <- str_detect(vct[i], word_)

                    to_compare =  sum(v_bool)

                    if (to_compare > 0){indx <- match(T, v_bool)}

            }

    }else{

       if (strict[occ_idx] == "yes"){

         t = 1

         while (t <= length(word_) & to_compare < 1){

           if (nchar(word_[t]) == nchar(vct[i])){

                v_bool <- str_detect(vct[i], word_[t])

                to_compare = sum(v_bool)

                if (to_compare > 0){indx <- t}

            }

            t = t + 1

         }

       }else{

        v_bool <- str_detect(vct[i], word_)

        to_compare =  sum(v_bool)

        if (to_compare > 0){indx <- match(T, v_bool)}

       }

    }

    if (to_compare > 0) {

      all_occ <- as.numeric(all_occ)

      all_occ[indx] = all_occ[indx] + 1

      all_occ <- as.character(all_occ)

      if (all_in_word == "no"){

              if (length(word_) >= 2){

                word_ <- word_[-indx]

              }else{

                word_[1] <- notatall

              }

      }

      if (all_occ[indx] == occ[indx] | occ[indx] == "forever"){

        can_ins <- 1
        
        frst_occ <- append(frst_occ, i)

        if (occ_idx <= length(btwn)){

          if (btwn[occ_idx] == "yes"){get_ins <- 1}else{get_ins <- 0}

        }else{

          get_ins <- 0

        }

        if ((occ_idx + 1) <= length(occ)){ occ_idx = occ_idx + 1 }

      }
      
    }

    if (get_ins == 1 | can_ins == 1){

        can_ins <- 0

        vct2 <- append(vct2, vct[i])

    }
    
  }
  
  return(list(frst_occ, vct2))
  
}

#' append_row
#'
#' Append the last row from dataframe to the another or same dataframe
#'
#' @param df_in is the dataframe from which the row will append to another or the same  dataframe
#' @param df is the dataframe to which the row will append
#' @param hmn is how many time the last row will be appended
#' @param na_col is a vector containing the columns that won't append and will be replaced by another value (unique_do_not_know)
#' @param unique_do_not_know is the value of the non appending column in the appending row
#' @export

append_row <- function(df_in, df, hmn=1, na_col=c(), unique_do_not_know=NA){

        appender <- df_in[nrow(df), ]

        appender[na_col] <- unique_do_not_know

        for (i in 1:hmn){

                df <- rbind(df, appender)

        }

  return(df)

}

#' see_file
#'
#' Allow to get the filename or its extension
#'
#' @param string_ is the input string
#' @param index_ext is the occurence of the dot that separates the filename and its extension
#' @param ext is a boolean that if set to TRUE, will return the file extension and if set to FALSE, will return filename
#' @export

see_file <- function(string_, index_ext=1, ext=T){

        file_as_vec <- unlist(str_split(string_, ""))

        index_point <- grep("\\.", file_as_vec)[index_ext]

        if (ext == T){

                rtnl <- paste(file_as_vec[index_point:length(file_as_vec)], collapse="")

                return(rtnl)

        }else{

                rtnl <- paste(file_as_vec[1:(index_point-1)], collapse="")

                return(rtnl)

        }

}

#' see_inside
#'
#' Return a list containing all the column of the files in the current directory with a chosen file extension and its associated file and sheet if xlsx. For example if i have 2 files "out.csv" with 2 columns and "out.xlsx" with 1 column for its first sheet and 2 for its second one, the return will look like this:
#' c(column_1, column_2, column_3, column_4, column_5, unique_separator, "1-2-out.csv", "3-3-sheet_1-out.xlsx", 4-5-sheet_2-out.xlsx)
#'
#' @param pattern is a vector containin the file extension of the spreadsheets ("xlsx", "csv"...)
#' @param path is the path where are located the files
#' @param sep_ is a vector containing the separator for each csv type file in order following the operating system file order, if the vector does not match the number of the csv files found, it will assume the separator for the rest of the files is the same as the last csv file found. It means that if you know the separator is the same for all the csv type files, you just have to put the separator once in the vector.
#' @param unique_sep is a pattern that you know will never be in your input files
#' @param rec alloaw to get files recursively 
#' 
#' If x is the return value, to see all the files name, position of the columns and possible sheet name associanted with, do the following: print(x[(grep(unique_sep, x)[1]+1):length(x)])
#' If you just want to see the columns do the following: print(x[1:(grep(unique_sep, x) - 1)])
#'
#' @export

see_inside <- function(pattern_, path_=".", sep_=c(","), unique_sep="#####", rec=F){

        x <- c()

        for (i in 1:length(pattern_)){ 

                x <- append(x, list.files(path=path_, pattern=pattern_[i], recursive=rec))

        }

        rtnl <- list()

        rtnl2 <- c()

        sep_idx = 1
        
        for (i in 1:length(x)){

                file_as_vec <- unlist(str_split(x[i], ""))

                index_point <- grep("\\.", file_as_vec)[1]

                ext <- paste(file_as_vec[index_point:length(file_as_vec)], collapse="")

                if (ext == ".xlsx"){

                        allname <- getSheetNames(x[i]) 

                        for (t in 1:length(allname)){
                          
                                df <- data.frame(read.xlsx(x[i], sheet=allname[t]))

                                rtnl <- append(rtnl, df)

                                rtnl2 <- append(rtnl2, paste((length(rtnl)+1) , (length(rtnl)+ncol(df)), x[i], allname[t], sep="-"))

                        }

                }else{
                  
                        df <- data.frame(read.table(x[i], fill=T, sep=sep_[sep_idx]))

                        rtnl <- append(rtnl, df)

                        rtnl2 <- append(rtnl2, paste((length(rtnl)+1) , (length(rtnl)+ncol(df)), x[i], sep="-"))

                        sep_idx = sep_idx + 1

                        if (sep_idx > length(sep_)){

                                sep_ <- append(sep_, sep_[length(sep_)])

                        }

                }

        }

        return(c(rtnl, unique_sep, rtnl2))

}

#' val_replacer
#' 
#' Allow to replace value from dataframe to another one.
#' 
#' @param df is the input dataframe
#' @param val_replaced is a vector of the value(s) to be replaced
#' @param val_replacor is the value that will replace val_replaced
#' @param df_rpt is the replacement matrix and has to be the same dimension as df. Only the indexes that are equal to TRUE will be authorized indexes for the values to be replaced in the input matrix
#' @export

val_replacer <- function(df, val_replaced=F, val_replacor=T, df_rpt=NA){
  
  for (i in 1:(ncol(df))){
    
      for (i2 in 1:length(val_replaced)){
        
        if (is.na(df_rpt) == F){
          
          vec_pos <- grep(val_replaced[i2], df[, i])
          
        }else{
          
          vec_pos <- grep(val_replaced[i2], df[, i])
          
          vec_pos2 <- grep(T, df_rpt[i])
          
          vec_pos <- grep(T, (vec_pos==vec_pos2))
          
        }
    
        df[vec_pos, i] <- val_replacor
    
      }
    
  }
  
  return(df)
  
}




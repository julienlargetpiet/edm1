#' insert_datf
#'
#' @description Allow to insert dataframe into another dataframe according to coordinates (row, column) from the dataframe that will be inserted
#' @param datf_in is the dataframe that will be inserted 
#' @param datf_ins is the dataset to be inserted
#' @param ins_loc is a vector containg two parameters (row, column) of the begining for the insertion
#' @examples 
#'
#'datf1 <- data.frame(c(1, 4), c(5, 3))
#'
#'datf2 <- data.frame(c(1, 3, 5, 6), c(1:4), c(5, 4, 5, "ereer"))
#'
#'print(insert_datf(datf_in=datf2, datf_ins=datf1, ins_loc=c(4, 2)))
#'
#'#   c.1..3..5..6. c.1.4. c.5..4..5...ereer..
#'# 1             1      1                   5
#'# 2             3      2                   4
#'# 3             5      3                   5
#'# 4             6      1                   5
#'
#'print(insert_datf(datf_in=datf2, datf_ins=datf1, ins_loc=c(3, 2)))
#'
#'#   c.1..3..5..6. c.1.4. c.5..4..5...ereer..
#'# 1             1      1                   5
#'# 2             3      2                   4
#'# 3             5      1                   5
#'# 4             6      4                   3
#'
#'print(insert_datf(datf_in=datf2, datf_ins=datf1, ins_loc=c(2, 2)))
#'
#'#   c.1..3..5..6. c.1.4. c.5..4..5...ereer..
#'# 1             1      1                   5
#'# 2             3      1                   5
#'# 3             5      4                   3
#'# 4             6      4               ereer
#'
#' @export

insert_datf <- function(datf_in, datf_ins, ins_loc){

  ins_loc <- ins_loc - 1
  
  datf_pre1 <- datf_in[0:ins_loc[1], 1:ncol(datf_in)] 
 
  if ((ins_loc[1] + nrow(datf_ins)) > nrow(datf_in)){
    
    datf_pre2 <- datf_in[(ins_loc[1]+1):nrow(datf_in), 1:ncol(datf_in)]
    
    datf_pre3 <- datf_in[0:0, 1:ncol(datf_in)]
    
    row_end <- nrow(datf_pre2)
    
  }else{
   
    datf_pre2 <- datf_in[(ins_loc[1]+1):(ins_loc[1]+nrow(datf_ins)), 1:ncol(datf_in)]
   
    if ((ins_loc[1]+nrow(datf_ins)) < nrow(datf_in)){

        datf_pre3 <- datf_in[(ins_loc[1] + nrow(datf_ins) + 1):nrow(datf_in), 1:ncol(datf_in)]
    
    }else {

        datf_pre3 <- datf_in[0:0, 1:ncol(datf_in)]

    }

    row_end <- nrow(datf_ins)
    
  }
  
  t = 1
  
  for (i in 1:ncol(datf_ins)){
    
    datf_pre2[, (ins_loc[2]+i)] <- datf_ins[1:row_end, t] 
    
    t = t + 1
    
  }
  
  rtnl <- rbind(datf_pre1, datf_pre2, datf_pre3)
  
  return(rtnl)
  
}

#' pattern_generator
#'
#' Allow to create patterns which have a part that is varying randomly each time.
#' @param base_ is the pattern that will be kept
#' @param from_ is the vector from which the elements of the random part will be generated
#' @param hmn is how many of varying pattern from the same base will be created
#' @param after is set to 1 by default, it means that the varying part will be after the fixed part, set to 0 if you want the varying part to be before 
#' @param nb is the number of random pattern chosen for the varying part
#' @param sep is the separator between all patterns in the returned value
#' @examples
#'
#'print(pattern_generator(base_="oui", from_=c("er", "re", "ere"), nb=1, hmn=3))
#'
#'# [1] "ouier" "ouire" "ouier"
#'
#'print(pattern_generator(base_="oui", from_=c("er", "re", "ere"), nb=2, hmn=3, after=0, sep="-"))
#'
#'# [1] "er-re-o-u-i"  "ere-re-o-u-i" "ere-er-o-u-i"
#'
#' @export

pattern_generator <- function(base_, from_, nb, hmn=1, after=1, sep=""){
  
  rtnl <- c()
  
  base_ <- unlist(str_split(base_, ""))
  
  base2_ <- base_
  
  for (I in 1:hmn){
    
    for (i in 1:nb){
      
      idx <- round(runif(1, 1, length(from_)), 0)
      
      if (after == 1){
        
        base_ <- append(base_, from_[idx])
        
      }else{
        
        base_ <- append(base_, from_[idx], after=0)
        
      }
      
    }
    
    base_ <- stri_paste(base_, collapse=sep)
    
    rtnl <- append(rtnl, base_)
    
    base_ <- base2_
    
  }
  
  return(rtnl)
  
}

#' pattern_tuning
#'
#' Allow to tune a pattern very precisely and output a vector containing its variations n times.
#' @param pattrn is the character that will be tuned 
#' @param spe_nb is the number of new character that will be replaced
#' @param spe_l is the source vector from which the new characters will replace old ones
#' @param exclude_type is character that won't be replaced
#' @param hmn is how many output the function will return
#' @param rg is a vector with two parameters (index of the first letter that will be replaced, index of the last letter that will be replaced) default is set to all the letters from the source pattern
#' @examples
#'
#' print(pattern_tuning(pattrn="oui", spe_nb=2, spe_l=c("e", "r", "T", "O"), exclude_type="o", hmn=3))
#' 
#' #[1] "orT" "oTr" "oOi"
#'
#' @export

pattern_tuning <- function(pattrn, spe_nb, spe_l, exclude_type, hmn=1, rg=c(1, nchar(pattrn))){
  
  lngth <- nchar(pattrn)
  
  rtnl <- c()
  
  if (spe_nb <= lngth & rg[1] > -1 & rg[2] < (lngth+1)){
    
    pattrn_l <- unlist(strsplit(pattrn, ""))
    
    pattrn <- pattrn_l
    
    b_l <- c()
    
    for (I in 1:hmn){ 
       
        cnt = 0

        while (cnt <= spe_nb){
          
          if (rg[2] == lngth & rg[1] == 1){
            
            idx <- round(runif(1, 1, lngth), 0)
            
          }else{
            
            idx <- round(runif(1, rg[1], rg[2]), 0)
            
          }
          
          if (sum(grepl(pattrn[idx], exclude_type)) == 0){
            
            pattrn[idx] <- spe_l[round(runif(1, 1, length(spe_l)), 0)]
            
            cnt = cnt + 1

          }
          
        }
        
        pattrn <- paste(pattrn, collapse="")
        
        rtnl <- append(rtnl, pattrn)
        
        pattrn <- pattrn_l 
        
    }
      
    return(rtnl)
    
  }else{
    
    print("word too short for your arguments, see the documentation")
    
  }
  
}

#' can_be_num
#'
#' Return TRUE if a variable can be converted to a number and FALSE if not (supports float)
#' @param x is the input value
#' @examples
#'
#' print(can_be_num("34.677"))
#'
#' #[1] TRUE
#'
#' print(can_be_num("34"))
#'
#' #[1] TRUE
#'
#' print(can_be_num("3rt4"))
#'
#' #[1] FALSE
#'
#' print(can_be_num(34))
#'
#' #[1] TRUE
#'
#' @export

can_be_num <- function(x){

    regex_spe_detect <- function(inpt){
        fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
          ptrn <- grep(ptrn_fill, inpt_v)
          while (length(ptrn) > 0){
            ptrn <- grep(ptrn_fill, inpt_v)
            idx <- ptrn[1] 
            untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
            pre_val <- inpt_v[(idx - 1)]
            inpt_v[idx] <- pre_val
            if (untl > 0){
              for (i in 1:untl){
                inpt_v <- append(inpt_v, pre_val, idx)
              }
            }
          ptrn <- grep(ptrn_fill, inpt_v)
          }
          return(inpt_v)
        }
        inpt <- unlist(strsplit(x=inpt, split=""))
        may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
        pre_idx <- unique(match(x=inpt, table=may_be_v))
        pre_idx <- pre_idx[!(is.na(pre_idx))]
        for (el in may_be_v[pre_idx]){
                cnt = 0
                for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                        inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                        cnt = cnt + 1
                }
        }
          return(paste(inpt, collapse=""))
     }

    
    if (typeof(x) == "double"){

            return(TRUE)

    }else{

        vec_bool <- c()

        v_ref <- c("1", "2", "3", "4", "5", "6", "7", "8", "9", "0", ".")    

        v_wrk <- unlist(str_split(x, ""))

        alrd <- TRUE

        for (i in 1:length(v_wrk)){ 

                if (v_wrk[i] == "." & alrd){ 

                        vec_bool <- append(vec_bool, 1) 

                        alrd <- FALSE

                }else{

                        vec_bool <- append(vec_bool, sum(grepl(pattern=regex_spe_detect(v_wrk[i]), x=v_ref))) 

                }

        }

        if (sum(vec_bool) == length(vec_bool)){

                return(TRUE)

        }else{

                return(FALSE)

        }

    }

}

#' unique_pos
#'
#' Allow to find the first index of the unique values from a vector. 
#' @param vec is the input vector
#' @examples
#'
#' print(unique_pos(vec=c(3, 4, 3, 5, 6)))
#'
#' #[1] 1 2 4 5
#'
#' @export

unique_pos <- function(vec){

        u_vec <- unique(vec)

        return(match(u_vec, vec))

}

#' data_gen
#'
#' Allo to generate in a csv all kind of data you can imagine according to what you provide
#' @param type_ is a vector. Its arguments designates a column, a column can be made of numbers ("number"), string ("string") or both ("mixed")
#' @param strt_l is a vector containing for each column the row from which the data will begin to be generated
#' @param nb_r is a vector containing for each column, the number of row full from generated data  
#' @param output is the name of the output csv file, defaults to NA so no csv will be outputed by default
#' @param type_distri is a vector which, for each column, associate a type of distribution ("random", "poisson", "gaussian"), it meas that non only the number but also the length of the string will be randomly generated according to these distribution laws
#' @param properties is linked to type_distri because it is the parameters ("min_val-max_val") for "random type", ("u-x") for the poisson distribution, ("u-d") for gaussian distribution
#' @param str_source is the source (vector) from which the character creating random string are (default set to the occidental alphabet)
#' @param round_l is a vector which, for each column containing number, associate a round value, if the type of the value is numeric
#' @param sep_ is the separator used to write data in the csv
#' @return new generated data in addition to saving it in the output
#' @examples
#' 
#' print(data_gen())
#' 
#' #  X1   X2    X3
#' #1   4    2  <NA>
#' #2   2    4  <NA>
#' #3   5    2  <NA>
#' #4   2 abcd  <NA>
#' #5   4 abcd  <NA>
#' #6   2    4  <NA>
#' #7   2  abc  <NA>
#' #8   4  abc  <NA>
#' #9   4    3  <NA>
#' #10  4  abc  abcd
#' #11  5 <NA>   abc
#' #12  4 <NA>   abc
#' #13  1 <NA>    ab
#' #14  1 <NA> abcde
#' #15  2 <NA>   abc
#' #16  4 <NA>     a
#' #17  1 <NA>  abcd
#' #18  4 <NA>    ab
#' #19  2 <NA>  abcd
#' #20  3 <NA>    ab
#' #21  3 <NA>  abcd
#' #22  2 <NA>     a
#' #23  4 <NA>   abc
#' #24  1 <NA>  abcd
#' #25  4 <NA>   abc
#' #26  4 <NA>    ab
#' #27  2 <NA>   abc
#' #28  5 <NA>    ab
#' #29  3 <NA>   abc
#' #30  5 <NA>  abcd
#' #31  2 <NA>   abc
#' #32  2 <NA>   abc
#' #33  1 <NA>    ab
#' #34  5 <NA>     a
#' #35  4 <NA>    ab
#' #36  1 <NA>    ab
#' #37  1 <NA> abcde
#' #38  5 <NA>   abc
#' #39  4 <NA>    ab
#' #40  5 <NA> abcde
#' #41  2 <NA>    ab
#' #42  3 <NA>    ab
#' #43  2 <NA>    ab
#' #44  4 <NA>  abcd
#' #45  5 <NA>  abcd
#' #46  3 <NA>  abcd
#' #47  2 <NA>  abcd
#' #48  3 <NA>  abcd
#' #49  3 <NA>  abcd
#' #50  4 <NA>     a
#'
#' print(data_gen(strt_l=c(0, 0, 0), nb_r=c(5, 5, 5)))
#' 
#' #  X1    X2   X3
#' #1  2     a  abc
#' #2  3 abcde   ab
#' #3  4 abcde    a
#' #4  1     3  abc
#' #5  3     a abcd
#' @export

data_gen <- function(type_=c("number", "mixed", "string"), strt_l=c(0, 0, 10), nb_r=c(50, 10, 40), output=NA, 
                     properties=c("1-5", "1-5", "1-5"), type_distri=c("random", "random", "random"), 
                     str_source=c("a", "b", "c", "d", "e", "f", "g", 
                                  "h", "i", "j", "k", "l", "m", 
                                  "n", "o", "p", "q", "r", "s", "t", "u", "w", "x", "y", "z"), 
                     round_l=c(0, 0, 0), sep_=","){
  
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
  
  if (is.na(output) == FALSE){
    
    write.table(rtnl, output, sep=sep_, row.names=FALSE, col.names=FALSE)
    
  }
  
  return(rtnl)
  
}

#' data_meshup
#'
#' Allow to automatically arrange 1 dimensional data according to vector and parameters
#' @param data is the data provided (vector) each column is separated by a unic separator and each dataset from the same column is separated by another unic separator (ex: c("_", c("d", "-", "e", "-", "f"), "_", c("a", "a1", "-", "b", "-", "c", "c1"), "_")
#' @param cols are the colnames of the data generated in a csv
#' @param file_ is the file to which the data will be outputed, defaults to NA which means that the functio will return the dataframe generated and won't write it to a csv file
#' @param sep_ is the separator of the csv outputed
#' @param organisation is the way variables include themselves, for instance ,resuming precedent example, if organisation=c(1, 0) so the data output will be:
#' d, a
#' d, a1
#' e, c
#' f, c
#' f, c1
#' @param unic_sep1 is the unic separator between variables (default is "_")
#' @param unic_sep2 is the unic separator between datasets (default is "-")
#' @examples
#' 
#' print(data_meshup(data=c("_", c("-", "d", "-", "e", "-", "f"), "_", 
#'      c("-", "a", "a1", "-", "B", "r", "uy", "-", "c", "c1"), "_"), organisation=c(1, 0)))
#'
#' #  X1 X2
#' #1  d  a
#' #2  d a1
#' #3  e  B
#' #4  e  r
#' #5  e uy
#' #6  f  c
#' #7  f c1
#'
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
  
  dataset_l <- which(str_detect(unic_sep2, data))
  
  datf <- data.frame(matrix(nrow = val_nb, ncol = jsq))
  
  for (I in 1:hmn){
    
    idx_s = 0
    
    seq_l <- seq(I, length(dataset_l), hmn)
   
    for (i in 1:jsq){
      
      idx <- dataset_l[seq_l[i]]
      
      t = 1
      
      sep_dd <- grepl(data[idx + 1], c(unic_sep2, unic_sep1))
     
      while(sum(sep_dd[!is.na(sep_dd)]) == 0 & (idx + t <= length(data))){
       
        l_l <- append(l_l, data[idx + t])
        
        t = t + 1
        
        sep_dd <- grepl(data[idx + t], c(unic_sep2, unic_sep1))
        
      }
      
      l_lngth <- append(l_lngth, (t - 1))
      
      datf[1:(t-1), i] <- l_l
      
      l_l <- c()
      
    }
    
    if (old_max_row == -1){
      
      datf2 <- data.frame(matrix(nrow=0, ncol=jsq))
      
    }
   
    old_max_row <- max(l_lngth, na.rm=TRUE)
    
    l_lngth <- c()
  
    for (i in 1:jsq){
      
      v_rel <- datf[, i]
      
      var_ = 1
      
      x = 1
     
      while (x <= organisation[i]){
       
        v_relb <- datf[, i + x]
        
        val_ <- v_rel[var_] 
        
        for (t in 1:length(v_relb[!is.na(v_relb)])){
          
          datf[t, i] <- val_ 
          
          if (t + 1 <= length(v_rel)){
            
            if (is.na(v_rel[t + 1]) == FALSE){
              
              var_ = var_ + 1 
              
              while (is.na(v_rel[var_]) == TRUE){
                
                var_ = var_ + 1 
                
              }
              
              val_ <- v_rel[var_]  
              
            }
            
          }
          
        }
        
        x = x + 1
        
      }
      
    }
   
    datf2 <- rbind(datf2, datf[1:old_max_row, 1:jsq])
    
    datf[1:nrow(datf), 1:ncol(datf)] <- NA
    
  }
  
  if (all(is.na(cols)) == FALSE){
    
    colnames(datf2) <- cols
    
  }
  
  if (is.na(file_)){
    
    return(datf2)
    
  }else{
    
    write.table(datf2, file_, sep=sep_, row.names=FALSE)
    
  }
  
}

#' letter_to_nb
#'
#' Allow to get the number of a spreadsheet based column by the letter ex: AAA = 703
#' @param letter is the letter (name of the column)
#' @examples
#'
#' print(letter_to_nb("rty"))
#'
#' #[1] 12713
#'
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
#' @examples
#'
#' print(nb_to_letter(5))
#'
#' [1] "e"
#'
#' print(nb_to_letter(27))
#'
#' [1] "aa"
#' 
#' print(nb_to_letter(51))
#'
#' [1] "ay"
#'
#' print(nb_to_letter(52))
#'
#' [1] "az"
#' 
#' print(nb_to_letter(53))
#'
#' [1] "ba"
#'
#' print(nb_to_letter(675))
#'
#' [1] "yy"
#'
#' print(nb_to_letter(676))
#'
#' [1] "yz"
#'
#' print(nb_to_letter(677))
#'
#' [1] "za"
#'
#' print(nb_to_letter(702))
#'
#' [1] "zz"
#'
#' print(nb_to_letter(703))
#'
#' [1] "aaa"
#'
#' print(nb_to_letter(18211))
#'
#' [1] "zxk"
#'
#' print(nb_to_letter(18277))
#'
#' [1] "zzy"
#'
#' print(nb_to_letter(18278))
#'
#' [1] "zzz"
#'
#' print(nb_to_letter(18279))
#'
#' [1] "aaaa"
#'
#' @export

nb_to_letter <- function(x){
  rtn_v <- c()
  cnt = 0
  while (26 ** cnt <= x){
    cnt = cnt + 1
    reste <- x %% (26 ** cnt)
    if (reste != 0){
      if (reste >= 26){ reste2 <- reste / (26 ** (cnt - 1)) }else{ reste2 <- reste }
      rtn_v <- c(rtn_v, letters[reste2])
    }else{
      reste <- 26 ** cnt
      rtn_v <- c(rtn_v, letters[26])
    }
    x = x - reste
  }
  return(paste(rtn_v[length(rtn_v):1], collapse = ""))
}

#' cost_and_taxes
#'
#' Allow to calculate basic variables related to cost and taxes from a bunch of products (elements). So put every variable you know in the following order:
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
#' @examples
#'
#' print(cost_and_taxes(pu=45, prix_ttc=2111, qte=23))
#' 
#' # [1]   23.000000   45.000000   45.000000    1.039614 2111.000000 1076.000000
#' #[7]   45.000000          NA          NA          NA          NA          NA
#'
#' @export

cost_and_taxes <- function(qte=NA, pu=NA, prix_ht=NA, tva=NA, prix_ttc=NA,
                           prix_tva=NA, pu_ttc=NA, adjust=NA, prix_d_ht=NA,
                           prix_d_ttc=NA, pu_d=NA, pu_d_ttc=NA){
  
  val_l <- c(qte, pu, prix_ht, tva, prix_ttc, prix_tva, pu_ttc, adjust,
             prix_d_ht, prix_d_ttc, pu_d, pu_d_ttc)
  
  already <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
  
  rtnl <- c(NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA)
  
  for (i in 1:length(already)){
    
    if (is.na(val_l[i]) == FALSE){
      
      already[i] <- 1
      
      rtnl[i] <- val_l[i]
      
    }
    
  }
  
  for (i in 1:16){
    
    if (is.na(prix_ttc) == FALSE & is.na(prix_d_ttc) == FALSE & already[8] == 0){
      
      adjust <- prix_ttc / prix_d_ttc - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }

    if (is.na(prix_ht) == FALSE & is.na(prix_d_ht) == FALSE & already[8] == 0){
      
      adjust <- prix_ht / prix_d_ht - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }
    
    if (is.na(pu_ttc) == FALSE & is.na(pu_d_ttc) == FALSE & already[8] == 0){
      
      adjust <- pu_ttc / pu_d_ttc - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }

    if (is.na(pu) == FALSE & is.na(pu_d) == FALSE & already[8] == 0){
      
      adjust <- pu / pu_d - 1
      
      already[8] <- 1
      
      rtnl[8] <- adjust
      
    }

    if (is.na(qte) == FALSE & is.na(pu_d) == 0 & already[9] == 0){
      
      prix_d_ht <- qte * pu_d
      
      already[9] <- 0
      
      rtnl[9] <- prix_d_ht
      
    }
    
    if (is.na(qte) == FALSE & is.na(pu_d_ttc) == 0 & already[10] == 0){
      
      prix_d_ttc <- qte * pu_d_ttc
      
      already[10] <- 0
      
      rtnl[10] <- prix_d_ht
      
    }
    
    if (is.na(prix_d_ttc) == FALSE & is.na(qte) == FALSE & already[12] == 0){
      
      pu_d_ttc <- prix_d_ttc / qte
      
      already[12] <- 1
      
      rtnl[12] <- pu_d_ttc
      
    }
    
    if (is.na(prix_d_ht) == FALSE & is.na(qte) == FALSE & already[11] == 0){
      
      pu_d <- prix_d_ht / qte
      
      already[11] <- 1
      
      rtnl[11] <- pu_d
      
    }
    
    if (is.na(adjust) == FALSE & is.na(prix_ttc) == FALSE & already[10] == 0){
      
      prix_d_ttc <- prix_ttc * (1 - adjust)
      
      already[10] <- 1
      
      rtnl[10] <- prix_d_ttc
      
    }
    
    if (is.na(adjust) == FALSE & is.na(prix_ht) == FALSE & already[9] == 0){
      
      prix_d_ht <- prix_ht * (1 - adjust)
      
      already[9] <- 1
      
      rtnl[9] <- prix_d_ht
      
    }
    
    if (is.na(adjust) == FALSE & is.na(prix_d_ht) == FALSE & already[3] == 0){
      
      prix_ht <- prix_d_ht * (1 / (1 - adjust))
      
      already[3] <- 1
      
      rtnl[3] <- prix_ht
      
    }
    
    if (is.na(adjust) == FALSE & is.na(prix_d_ttc) == FALSE & already[5] == 0){
      
      prix_ttc <- prix_d_ttc * (1 / (1 - adjust))
      
      already[5] <- 1
      
      rtnl[5] <- prix_ttc
      
    }
    
    if (is.na(pu) == FALSE & is.na(pu_ttc) == FALSE & already[4] == 0){
      
      tva <- pu_ttc / pu - 1
      
      already[4] <- 1
      
      rtnl[4] <- tva
      
    }

    if (is.na(pu_d_ttc) == FALSE & is.na(pu_d) == FALSE & already[4] == 0){
      
      tva <- pu_d_ttc / pu_d - 1
      
      already[4] <- 1
      
      rtnl[4] <- tva
      
    }

    if (is.na(prix_d_ttc) == FALSE & is.na(prix_d_ht) == FALSE & already[4] == 0){
      
      tva <- prix_d_ttc / prix_d_ht - 1
      
      already[4] <- 1
      
      rtnl[4] <- tva
      
    }
    
    if (is.na(prix_ht) == FALSE & is.na(pu) == FALSE & already[1] == 0){
      
      qte <- prix_ht / pu
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_ttc) == FALSE & is.na(pu_ttc) == FALSE & already[1] == 0){
      
      qte <- prix_ttc / pu_ttc
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_d_ht) == FALSE & is.na(pu_d) == FALSE & already[1] == 0){
      
      qte <- prix_d_ht / pu_d
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_d_ttc) == FALSE & is.na(pu_d_ttc) == FALSE & already[1] == 0){
      
      qte <- prix_d_ttc / pu_d_ttc
      
      rtnl[1] <- as.integer(qte)
      
      already[1] <- 1
      
    }
    
    if (is.na(prix_ht) == FALSE & is.na(qte) == FALSE & already[2] == 0){
      
      pu <- prix_ht / qte
      
      rtnl[2] <- pu
      
      already[2] <- 1
      
    }
    
    if (is.na(prix_ttc) == FALSE & is.na(qte) == FALSE & already[7] == 0){
      
      pu_ttc <- prix_ttc / qte
      
      rtnl[7] <- pu
      
      already[7] <- 1
      
    }
    
    if (is.na(pu) == FALSE & is.na(qte) == FALSE & already[3] == 0){
      
      prix_ht <- pu * qte
      
      rtnl[3] <- pu
      
      already[3] <- 1
      
    }
    
    if (is.na(pu_ttc) == FALSE & is.na(qte) == FALSE & already[5] == 0){
      
      prix_ttc <- pu_ttc * qte
      
      rtnl[5] <- pu
      
      already[5] <- 1
      
    }
    
    if (is.na(pu) == FALSE & is.na(qte) == FALSE & already[3] == 0){
      
      prix_ht <- pu * qte
      
      rtnl[3] <- prix_ht
      
      already[3] <- 1
      
    }
    
    if (is.na(prix_ht) == FALSE & is.na(prix_ttc) == FALSE & already[4] == 0){
      
      tva <- prix_ttc / prix_ht - 1
      
      rtnl[4] <- tva
      
      already[4] <- 1
      
    }
    
    if (is.na(tva) == FALSE & is.na(prix_ttc) == FALSE & already[3] == 0){
      
      prix_ht <- prix_ttc / (1 + tva)
      
      rtnl[3] <- prix_ht
      
      already[3] <- 1
      
    }
    
    if (is.na(tva) == FALSE & is.na(prix_ht) == FALSE & already[5] == 0){
      
      prix_ttc <- prix_ht * (1 + tva) 
      
      rtnl[5] <- prix_ttc
      
      already[5] <- 1
      
    }  
    
    if (is.na(prix_ht) == FALSE & is.na(prix_ttc) == FALSE & already[6] == 0){
      
      prix_tva <- prix_ttc - prix_ht
      
      rtnl[6] <- prix_tva
      
      already[6] <- 1
      
    }
    
    if (is.na(tva) == FALSE & is.na(prix_ttc) == FALSE & already[6] == 0){
      
      prix_tva <- tva * prix_ht
      
      rtnl[6] <- prix_tva
      
      already[6] <- 1
      
    }
    
  }
  
  return(rtnl)
  
}

#' format_date
#'
#' Allow to convert xx-month-xxxx date type to xx-xx-xxxx
#' @param f_dialect are the months from the language of which the month come
#' @param sentc is the date to convert
#' @param sep_in is the separator of the dat input (default is "-")
#' @param sep_out is the separator of the converted date (default is "-")
#' @examples
#'
#' print(format_date(f_dialect=c("janvier", "février", "mars", "avril", "mai", "juin",
#' "juillet", "aout", "septembre", "octobre", "novembre", "décembre"), sentc="11-septembre-2023"))
#'
#' #[1] "11-09-2023"
#'
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
#' Maxes a vector to a chosen length. ex: if i want my vector c(1, 2) to be 5 of length this function will return me: c(1, 2, 1, 2, 1) 
#' @param vec1 is the input vector
#' @param goal is the length to reach
#' @examples
#'
#' print(until_stnl(vec1=c(1, 3, 2), goal=56))
#'
#' # [1] 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3
#' #[39] 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3 2 1 3
#'
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

#' vlookup_datf
#'
#' Alow to perform a vlookup on a dataframe
#' @param datf is the input dataframe
#' @param v_id is a vector containing the ids
#' @param col_id is the column that contains the ids (default is equal to 1)
#' @param included_col_id is if the result should return the col_id (default set to yes)
#' @examples
#'
#' datf1 <- data.frame(c("az1", "az3", "az4", "az2"), c(1:4), c(4:1))
#' 
#' print(vlookup_datf(datf=datf1, v_id=c("az1", "az2", "az3", "az4")))
#'
#' #   c..az1....az3....az4....az2.. c.1.4. c.4.1.
#' #2                            az1      1      4
#' #4                            az2      4      1
#' #21                           az3      2      3
#' #3                            az4      3      2
#'
#' @export

vlookup_datf <- function(datf, v_id, col_id=1, included_col_id="yes"){
  
  rtnl <- datf[1, ]
  
  for (i in 1:length(v_id)){

    idx = match(v_id[i], datf[, col_id])
    
    rtnl <- rbind(rtnl, datf[idx,])
    
    datf <- datf[-idx, ]
    
  }
  
  if (included_col_id == "yes"){
  
    return(rtnl[-1, ])
  
  }else{
    
    return(rtnl[-1, -col_id])
    
  }
    
}

#' multitud
#'
#' From a list containing vectors allow to generate a vector following this rule: list(c("a", "b"), c("1", "2"), c("A", "Z", "E")) --> c("a1A", "b1A", "a2A", "b2A", a1Z, ...)
#' @param l is the list
#' @param sep_ is the separator between elements (default is set to "" as you see in the example)
#' @examples
#'
#' print(multitud(l=list(c("a", "b"), c("1", "2"), c("A", "Z", "E"), c("Q", "F")), sep_="/"))
#' 
#' #[1] "a/1/A/Q" "b/1/A/Q" "a/2/A/Q" "b/2/A/Q" "a/1/Z/Q" "b/1/Z/Q" "a/2/Z/Q"
#' #[8] "b/2/Z/Q" "a/1/E/Q" "b/1/E/Q" "a/2/E/Q" "b/2/E/Q" "a/1/A/F" "b/1/A/F"
#' #[15] "a/2/A/F" "b/2/A/F" "a/1/Z/F" "b/1/Z/F" "a/2/Z/F" "b/2/Z/F" "a/1/E/F"
#' #[22] "b/1/E/F" "a/2/E/F" "b/2/E/F"
#'
#' @export

multitud <- function(l, sep_=""){
  
  rtnl <- unlist(l[1])

  for (I in 2:length(l)){
    
    rtnl2 <- c()
  
    cur_ <- unlist(l[I])
    
    for (i in 1:length(cur_)){
      
      for (t in 1:length(rtnl)){
        
        rtnl2 <- append(rtnl2, paste(rtnl[t], cur_[i], sep=sep_))

      }

    }
    
    rtnl <- rtnl2
    
  }

  return(rtnl)
  
}

#' save_untl
#'
#' Get the elements in each vector from a list that are located before certain values
#'
#' @param inpt_l is the input list containing all the vectors
#' @param val_to_stop_v is a vector containing the values that marks the end of the vectors returned in the returned list, see the examples
#' 
#' @examples
#'
#' print(save_untl(inpt_l=list(c(1:4), c(1, 1, 3, 4), c(1, 2, 4, 3)), val_to_stop_v=c(3, 4)))
#'
#' #[[1]]
#' #[1] 1 2
#' #
#' #[[2]]
#' #[1] 1 1
#' #
#' #[[3]]
#' #[1] 1 2
#'
#' print(save_untl(inpt_l=list(c(1:4), c(1, 1, 3, 4), c(1, 2, 4, 3)), val_to_stop_v=c(3)))
#' 
#' #[[1]]
#' #[1] 1 2
#' #
#' #[[2]]
#' #[1] 1 1
#' #
#' #[[3]]
#' #[1] 1 2 4
#'
#' @export

save_untl <- function(inpt_l=list(), val_to_stop_v=c()){

        rtn_l <- list()

        for (vec in inpt_l){

                t = 1

                cur_v <- c()

                while (!(vec[t] %in% val_to_stop_v) & t <= length(vec)){

                        cur_v <- c(cur_v, vec[t])

                        t = t + 1

                }

                rtn_l <- append(x=rtn_l, values=list(cur_v))

        }

        return(rtn_l)

}

#' see_datf
#' 
#' Allow to return a dataframe with special value cells (ex: TRUE) where the condition entered are respected and another special value cell (ex: FALSE) where these are not
#' @param datf is the input dataframe
#' @param condition_l is the vector of the possible conditions ("==", ">", "<", "!=", "%%", "reg", "not_reg", "sup_nchar", "inf_nchar", "nchar") (equal to some elements in a vector, greater than, lower than, not equal to, is divisible by, the regex condition returns TRUE, the regex condition returns FALSE, the length of the elements is strictly superior to X, the length of the element is strictly inferior to X, the length of the element is equal to one element in a vector), you can put the same condition n times. 
#' @param val_l is the list of vectors containing the values or vector of values related to condition_l (so the vector of values has to be placed in the same order)
#' @param conjunction_l contains the and or conjunctions, so if the length of condition_l is equal to 3, there will be 2 conjunctions. If the length of conjunction_l is inferior to the length of condition_l minus 1, conjunction_l will match its goal length value with its last argument as the last arguments. For example, c("&", "|", "&") with a goal length value of 5 --> c("&", "|", "&", "&", "&")
#' @param rt_val is a special value cell returned when the conditions are respected
#' @param f_val is a special value cell returned when the conditions are not respected
#' @details This function will return an error if number only comparative conditions are given in addition to having character values in the input dataframe.
#' @examples
#' 
#' datf1 <- data.frame(c(1, 2, 4), c("a", "a", "zu"))
#' 
#' print(see_datf(datf=datf1, condition_l=c("nchar"), val_l=list(c(1))))
#' 
#' #    X1    X2
#' #1 TRUE  TRUE
#' #2 TRUE  TRUE
#' #3 TRUE FALSE
#' 
#' print(see_datf(datf=datf1, condition_l=c("=="), val_l=list(c("a", 1))))
#' 
#' #    X1    X2
#' #1  TRUE  TRUE
#' #2 FALSE  TRUE
#' #3 FALSE FALSE
#'
#' 
#' print(see_datf(datf=datf1, condition_l=c("nchar"), val_l=list(c(1, 2))))
#' 
#' #    X1   X2
#' #1 TRUE TRUE
#' #2 TRUE TRUE
#' #3 TRUE TRUE
#'
#' print(see_datf(datf=datf1, condition_l=c("not_reg"), val_l=list("[a-z]")))
#' 
#' #    X1    X2
#' #1 TRUE FALSE
#' #2 TRUE FALSE
#' #3 TRUE FALSE
#'
#' @export

see_datf <- function(datf, condition_l, val_l, conjunction_l=c(), rt_val=TRUE, f_val=FALSE){

        if (length(condition_l) > 1 & length(conjunction_l) < (length(condition_l) - 1)){

                for (i in (length(conjunction_l)+1):length(condition_l)){

                        conjunction_l <- append(conjunction_l, conjunction_l[length(conjunction_l)])

                }

        }

        datf_rtnl <- data.frame(matrix(f_val, ncol=ncol(datf), nrow=nrow(datf)))

        all_op <- c("==", ">", "<", "!=", "%%", "reg", "not_reg", "sup_nchar", "inf_nchar", "nchar")

        for (I in 1:ncol(datf)){

                for (i in 1:nrow(datf)){

                        checked_l <- c()

                        previous = 1

                        for (t in 1:length(condition_l)){

                                already <- 0

                                if (condition_l[t] == "==" & already == 0){

                                        if (datf[i, I] %in% unlist(val_l[t])){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                } else if (condition_l[t] == ">" & already == 0){

                                        if (all(datf[i, I] > unlist(val_l[t])) == TRUE){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                } else if (condition_l[t] == "<" & already == 0){

                                        if (all(datf[i, I] < unlist(val_l[t]))){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                } else if (condition_l[t] == "!=" & already == 0){

                                        if (!(datf[i, I] %in% unlist(val_l[t])) == TRUE){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                } else if (condition_l[t] == "%%" & already == 0){

                                        if (sum(datf[i, I] %% unlist(val_l[t])) == 0){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                } else if (condition_l[t] == "reg" & already == 0){

                                        if (str_detect(datf[i, I], unlist(val_l[t]))){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                }  else if (condition_l[t] == "not_reg" & already == 0){

                                        if ((str_detect(datf[i, I], unlist(val_l[t]))) == FALSE ){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                }  else if (condition_l[t] == "sup_nchar" & already == 0){

                                        if (nchar(as.character(datf[i, I])) > unlist(val_l[t])){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                }  else if (condition_l[t] == "inf_nchar" & already == 0){

                                        if (nchar(as.character(datf[i, I])) < unlist(val_l[t])){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

                                if (condition_l[t] == "nchar" & already == 0){

                                        if (nchar(as.character(datf[i, I])) %in% unlist(val_l[t])){

                                                checked_l <- append(checked_l, TRUE)

                                                if (length(condition_l) > 1 & t > 1){

                                                        bfr <- conjunction_l[previous:t]

                                                        if (t == length(condition_l)){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }else if (conjunction_l[t] == "|"){

                                                                if (length(checked_l) == length(bfr)){

                                                                        already <- 1

                                                                        datf_rtnl[i, I] <- rt_val

                                                                }

                                                        }

                                                }else if (length(condition_l) == 1){

                                                        datf_rtnl[i, I] <- rt_val

                                                }else {

                                                        if (conjunction_l[1] == "|"){

                                                                datf_rtnl[i, I] <- rt_val

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

  return(datf_rtnl)

}

#' leap_year 
#'
#' Get if the year is leap
#'
#' @param year is the input year
#' 
#' @examples
#'
#' print(leap_yr(year=2024))
#' 
#' #[1] TRUE
#'
#' @export

leap_yr <- function(year){

  if (year == 0){ return(FALSE) }

  if (year %% 4 == 0){
    
    if (year %% 100 == 0){
      
      if (year %% 400 == 0){
        
        bsx <- TRUE
        
      }else{
        
        bsx <- FALSE
        
      }
      
    }else{
      
      bsx <- TRUE
      
    }
    
  }else{
    
    bsx <- FALSE
    
  }

  return(bsx)

}

#' is_divisible
#'
#' Takes a vector as an input and returns all the elements that are divisible by all choosen numbers from another vector.
#'
#' @param inpt_v is the input vector
#' @param divisible_v is the vector containing all the numbers that will try to divide those contained in inpt_v
#' @examples
#'
#'  print(is_divisible(inpt_v=c(1:111), divisible_v=c(2, 4, 5)))
#'
#'  #[1]  20  40  60  80 100
#'
#' @export

is_divisible <- function(inpt_v=c(), divisible_v=c()){

        cnt = 1

        while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) == 0]

                cnt = cnt + 1

        }

        return(inpt_v)

}

#' isnt_divisible
#'
#' Takes a vector as an input and returns all the elements that are not divisible by all choosen numbers from another vector.
#'
#' @param inpt_v is the input vector
#' @param divisible_v is the vector containing all the numbers that will try to divide those contained in inpt_v
#' @examples
#'
#'  print(isnt_divisible(inpt_v=c(1:111), divisible_v=c(2, 4, 5)))
#'
#' # [1]   1   3   7   9  11  13  17  19  21  23  27  29  31  33  37  39  41  43  47
#' #[20]  49  51  53  57  59  61  63  67  69  71  73  77  79  81  83  87  89  91  93
#' #[39]  97  99 101 103 107 109 111
#'
#' @export

isnt_divisible <- function(inpt_v=c(), divisible_v=c()){

        cnt = 1

        while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) != 0]

                cnt = cnt + 1

        }

        return(inpt_v)

}

#' dcr_untl 
#' 
#' Allow to get the final value of a incremental or decremental loop. 
#'
#' @param strt_val is the start value
#' @param cr_val is the incremental (or decremental value)
#' @param stop_val is the value where the loop has to stop
#' @examples
#'
#' print(dcr_untl(strt_val=50, cr_val=-5, stop_val=5))
#'
#' #[1] 9
#'
#' print(dcr_untl(strt_val=50, cr_val=5, stop_val=450))
#'
#' #[1] 80
#' 
#' @export

dcr_untl <- function(strt_val, cr_val, stop_val=0){

        cnt = 1

        if (cr_val < 0){

            while ((strt_val + cr_val) > (stop_val)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }else{

            while ((strt_val + cr_val) < (stop_val)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }

        return(cnt)

}

#' dcr_val
#'
#' Allow to get the end value after an incremental (or decremental loop)
#' 
#' @param strt_val is the start value
#' @param cr_val is the incremental or decremental value
#' @param stop_val is the value the loop has to stop
#' @examples
#'
#' print(dcr_val(strt_val=50, cr_val=-5, stop_val=5))
#'
#' #[1] 5
#' 
#' print(dcr_val(strt_val=47, cr_val=-5, stop_val=5))
#' 
#' #[1] 7
#' 
#' print(dcr_val(strt_val=50, cr_val=5, stop_val=450))
#' 
#' #[1] 450
#' 
#' print(dcr_val(strt_val=53, cr_val=5, stop_val=450))
#' 
#' #[1] 448
#' 
#' @export

dcr_val <- function(strt_val, cr_val, stop_val=0){

        cnt = 1

        if (cr_val < 0){

            while ((strt_val + cr_val) > (stop_val + cr_val / 2)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }else{

            while ((strt_val + cr_val) < (stop_val + cr_val / 2)){

                strt_val = strt_val + cr_val

                cnt = cnt + 1

            }

        }

        return(strt_val)

}

#' converter_date
#' 
#' Allow to convert any date like second/minute/hour/day/month/year to either second, minute...year. The input date should not necessarily have all its time units (second, minute...) but all the time units according to a format. Example: "snhdmy" is for second, hour, minute, day, month, year. And "mdy" is for month, day, year.
#'
#' @param inpt_date is the input date
#' @param convert_to is the time unit the input date will be converted ("s", "n", "h", "d", "m", "y")
#' @param frmt is the format of the input date
#' @param sep_ is the separator of the input date. For example this input date "12-07-2012" has "-" as a separator
#' @examples 
#'
#' print(converter_date(inpt_date="14-04-11-2024", sep_="-", frmt="hdmy", convert_to="m"))
#' 
#' #[1] 24299.15
#' 
#' print(converter_date(inpt_date="14-04-11-2024", sep_="-", frmt="hdmy", convert_to="y"))
#' 
#' #[1] 2024.929
#'
#' print(converter_date(inpt_date="14-04-11-2024", sep_="-", frmt="hdmy", convert_to="s"))
#' 
#' #[1] 63900626400
#'
#' print(converter_date(inpt_date="63900626400", sep_="-", frmt="s", convert_to="y"))
#'
#' #[1] 2024.929
#'
#' print(converter_date(inpt_date="2024", sep_="-", frmt="y", convert_to="s"))
#'
#' #[1] 63873964800
#' 
#' @export

converter_date <- function(inpt_date, convert_to, frmt="snhdmy", sep_="-"){

  is_divisible <- function(inpt_v=c(), divisible_v=c()){

        cnt = 1

        while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) == 0]

                cnt = cnt + 1

        }

        return(inpt_v)

  }

  leap_yr <- function(year){

          if (year == 0){ return(FALSE) }

          if (year %% 4 == 0){
            
            if (year %% 100 == 0){
              
              if (year %% 400 == 0){
                
                bsx <- TRUE
                
              }else{
                
                bsx <- FALSE
                
              }
              
            }else{
              
              bsx <- TRUE
              
            }
            
          }else{
            
            bsx <- FALSE
            
          }

          return(bsx)

  }

  inpt_date <- unlist(strsplit(x=inpt_date, split=sep_)) 

  stay_date_v <- c("s", "n", "h", "d", "m", "y")

  stay_date_val <- c(0, 0, 0, 0, 0, 0)

  frmt <- unlist(strsplit(x=frmt, split=""))

  for (el in 1:length(frmt)){

          stay_date_val[grep(pattern=frmt[el], x=stay_date_v)] <- as.numeric(inpt_date[el]) 

  }

  l_dm1 <- c(31, 28, 31, 30, 31, 30, 31, 31,
            30, 31, 30, 31)

  l_dm2 <- c(31, 29, 31, 30, 31, 30, 31, 31,
            30, 31, 30, 31)

  if (!(leap_yr(year=stay_date_val[6]))){

        l_dm <- l_dm1

  }else if (stay_date_val[6] == 0){

        l_dm <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

  }else{

        l_dm <- l_dm2

  }

  may_bsx_v <- c(1:stay_date_val[6])

  may_bsx_v <- may_bsx_v[may_bsx_v > 0] 

  may_bsx_v <- may_bsx_v[(may_bsx_v %% 4) == 0]

  val_mult <- c((1 / 86400), (1 / 1440), (1/24), 1, 0, 365)

  day_val = 0

  for (dt in length(stay_date_val):1){

        day_val = day_val + stay_date_val[dt] * val_mult[dt] 

  }

  day_val = day_val + length(may_bsx_v[(may_bsx_v %% 100) != 0]) + length(is_divisible(inpt_v=may_bsx_v, divisible_v=c(100, 400))) 

  if (str_detect(string=stay_date_val[5], pattern="\\.")){

          all_part <- as.numeric(unlist(strsplit(x=as.character(stay_date_val[5]), split="\\.")))

          int_part <- all_part[1]

          if (int_part != 0){

                day_val = day_val + sum(l_dm[1:int_part])

          }else{ int_part <- 1 }

          day_val = day_val + l_dm1[int_part] * as.numeric(paste("0.", all_part[2], sep=""))

  }else if (stay_date_val[5] != 0){

        day_val = day_val + sum(l_dm1[1:stay_date_val[5]]) 

  }

  val_mult2 <- c(60, 60, 24, 1)

  idx_convert <- grep(pattern=convert_to, x=stay_date_v)

  if (idx_convert < 5){

        for (i in 4:idx_convert){

            day_val = day_val * val_mult2[i]

        }

        return(day_val)

  }else{

    year = 0

    l_dm <- l_dm1

    month = 0

    bsx_cnt = 0

    while ((day_val / sum(l_dm)) >= 1 ){

        l_dmb <- l_dm

        day_val2 = day_val

        day_val = day_val - sum(l_dm)

        month = month + 12

        year = year + 1

        if (!(leap_yr(year=year))){

                l_dm <- l_dm1

        }else{

                bsx_cnt = bsx_cnt + 1

                l_dm <- l_dm2

        } 

    }

    if (leap_yr(year=year)){

        day_val = day_val - 1

    }

    cnt = 1

    while ((day_val / l_dm[cnt]) >= 1){

        day_val = day_val - l_dm[cnt]

        month = month + 1

        cnt = cnt + 1 

    }

    month = month + (day_val / l_dm[cnt])

    if (convert_to == "m"){

            return(month)

    }else{

            year = year + ((month - 12 * year) / 12)

            return(year)

    }

  }

}

#' pattern_gettr 
#'
#' Search for pattern(s) contained in a vector in another vector and return a list containing matched one (first index) and their position (second index) according to these rules: First case: Search for patterns strictly, it means that the searched pattern(s) will be matched only if the patterns containded in the vector that is beeing explored by the function are present like this c("pattern_searched", "other", ..., "pattern_searched") and not as c("other_thing pattern_searched other_thing", "other", ..., "pattern_searched other_thing") 
#' Second case: It is the opposite to the first case, it means that if the pattern is partially present like in the first position and the last, it will be considered like a matched pattern. REGEX can also be used as pattern 
#'
#' @param word_ is the vector containing the patterns
#' @param vct is the vector being searched for patterns
#' @param occ a vector containing the occurence of the pattern in word_ to be matched in the vector being searched, if the occurence is 2 for the nth pattern in word_ and only one occurence is found in vct so no pattern will be matched, put "forever" to no longer depend on the occurence for the associated pattern
#' @param strict a vector containing the "strict" condition for each nth vector in word_ ("strict" is the string to activate this option)
#' @param btwn is a vector containing the condition ("yes" to activate this option) meaning that if "yes", all elements between two matched patern in vct will be returned , so the patterns you enter in word_ have to be in the order you think it will appear in vct 
#' @param all_in_word is a value (default set to "yes", "no" to activate this option) that, if activated, won't authorized a previous matched pattern to be matched again
#' @param notatall is a string that you are sure is not present in vct
#' @examples
#'
#' print(pattern_gettr(word_=c("oui", "non", "erer"), vct=c("oui", "oui", "non", "oui", 
#'  "non", "opp", "opp", "erer", "non", "ok"), occ=c(1, 2, 1), 
#'  btwn=c("no", "yes", "no"), strict=c("no", "no", "ee")))
#'
#' #[[1]]
#' #[1] 1 5 8
#' #
#' #[[2]]
#' #[1] "oui"  "non"  "opp"  "opp"  "erer"
#'
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

                    if (to_compare > 0){indx <- match(TRUE, v_bool)}

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

        if (to_compare > 0){indx <- match(TRUE, v_bool)}

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

#' see_file
#'
#' Allow to get the filename or its extension
#' 
#' @param string_ is the input string
#' @param index_ext is the occurence of the dot that separates the filename and its extension
#' @param ext is a boolean that if set to TRUE, will return the file extension and if set to FALSE, will return filename
#' @examples
#' 
#' print(see_file(string_="file.abc.xyz"))
#'
#' #[1] ".abc.xyz"
#'
#' print(see_file(string_="file.abc.xyz", ext=FALSE))
#'
#' #[1] "file"
#'
#' print(see_file(string_="file.abc.xyz", index_ext=2))
#' 
#' #[1] ".xyz"
#' 
#' @export

see_file <- function(string_, index_ext=1, ext=TRUE){

        file_as_vec <- unlist(str_split(string_, ""))

        index_point <- grep("\\.", file_as_vec)[index_ext]

        if (ext == TRUE){

                rtnl <- paste(file_as_vec[index_point:length(file_as_vec)], collapse="")

                return(rtnl)

        }else{

                rtnl <- paste(file_as_vec[1:(index_point-1)], collapse="")

                return(rtnl)

        }

}

#' see_inside
#'
#' Return a list containing all the column of the files in the current directory with a chosen file extension and its associated file and sheet if xlsx. For example if i have 2 files "out.csv" with 2 columns and "out.xlsx" with 1 column for its first sheet and 2 for its second one, the return will look like this: c(column_1, column_2, column_3, column_4, column_5, unique_separator, "1-2-out.csv", "3-3-sheet_1-out.xlsx", 4-5-sheet_2-out.xlsx)
#' @param pattern_ is a vector containin the file extension of the spreadsheets ("xlsx", "csv"...)
#' @param path_ is the path where are located the files
#' @param sep_ is a vector containing the separator for each csv type file in order following the operating system file order, if the vector does not match the number of the csv files found, it will assume the separator for the rest of the files is the same as the last csv file found. It means that if you know the separator is the same for all the csv type files, you just have to put the separator once in the vector.
#' @param unique_sep is a pattern that you know will never be in your input files
#' @param rec is a boolean allows to get files recursively if set to TRUE, defaults to TRUE 
#' If x is the return value, to see all the files name, position of the columns and possible sheet name associanted with, do the following: 
#' @export

see_inside <- function(pattern_, path_=".", sep_=c(","), unique_sep="#####", rec=FALSE){

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
                          
                                datf <- data.frame(read.xlsx(x[i], sheet=allname[t]))

                                rtnl <- append(rtnl, datf)

                                rtnl2 <- append(rtnl2, paste((length(rtnl)+1) , (length(rtnl)+ncol(datf)), x[i], allname[t], sep="-"))

                        }

                }else{
                  
                        datf <- data.frame(read.table(x[i], fill=TRUE, sep=sep_[sep_idx]))

                        rtnl <- append(rtnl, datf)

                        rtnl2 <- append(rtnl2, paste((length(rtnl)+1) , (length(rtnl)+ncol(datf)), x[i], sep="-"))

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
#' @param datf is the input dataframe
#' @param val_replaced is a vector of the value(s) to be replaced
#' @param val_replacor is the value that will replace val_replaced
#' @examples
#'
#' print(val_replacer(datf=data.frame(c(1, "oo4", TRUE, FALSE), c(TRUE, FALSE, TRUE, TRUE)), 
#'      val_replaced=c(TRUE), val_replacor="NA"))
#'
#' #  c.1...oo4...T..F. c.T..F..T..T.
#' #1                 1            NA
#' #2               oo4         FALSE
#' #3                NA            NA
#' #4             FALSE            NA
#' 
#' @export

val_replacer <- function(datf, val_replaced, val_replacor=TRUE){
  
  for (i in 1:(ncol(datf))){
    
      for (i2 in 1:length(val_replaced)){
        
        vec_pos <- grep(val_replaced[i2], datf[, i])
          
        datf[vec_pos, i] <- val_replacor
    
      }
    
  }
  
  return(datf)
  
}

#' see_idx
#'
#' Returns a boolean vector to see if a set of elements contained in v1 is also contained in another vector (v2)
#' 
#' @param v1 is the first vector
#' @param v2 is the second vector
#' @examples
#'
#' print(see_idx(v1=c("oui", "non", "peut", "oo"), v2=c("oui", "peut", "oui")))
#'
#' #[1]  TRUE FALSE  TRUE  FALSE
#'
#' @export

see_idx <- function(v1, v2){
 
  rtnl <- c()
 
  for (i in 1:length(v1)){

    if (length(grep(pattern=v1[i], x=v2)) > 0){

            r_idx <- TRUE

    }else{

            r_idx <- FALSE

    }

    rtnl <- append(x=rtnl, values=r_idx)
    
  }
 
  return(rtnl)
 
}

#' fold_rec2 
#' 
#' Allow to find the directories and the subdirectories with a specified end and start depth value from a path. This function might be more powerfull than file_rec because it uses a custom algorythm that does not nee to perform a full recursive search before tuning it to only find the directories with a good value of depth. Depth example: if i have dir/dir2/dir3, dir/dir2b/dir3b, i have a depth equal to 3
#' @param xmax is the depth value
#' @param xmin is the minimum value of depth
#' @param pathc is the reference path, from which depth value is equal to 1
#' @export

fold_rec2 <- function(xmax, xmin=1, pathc="."){

        pathc2 <- pathc

        ref <- list.dirs(pathc, recursive=FALSE)

        exclude_temp <- c()

        print(exclude_temp)

        exclude_f <- c("#")

        while (sum(exclude_f == ref) < length(ref)){

                if (length(grep("#", exclude_f)) > 0){

                        exclude_f <- c()

                }

                t = 1

                alf <- c("##")

                while (t <= xmax & length(alf) > 0){

                        alf <- list.dirs(pathc, recursive=FALSE)

                        exclude_idx <- c()

                        if (length(exclude_temp) > 0){

                                for (i in 1:length(exclude_temp)){  

                                        in_t <- match(TRUE, exclude_temp[i] == alf)

                                        if (is.na(in_t) == FALSE){

                                                exclude_idx <- append(exclude_idx, in_t)

                                        }

                                } 

                        }

                        if (length(exclude_idx) > 0){ alf <- alf[-exclude_idx] }

                        if (length(alf) > 0 & t < xmax){

                                pathc <- alf[1]

                        }

                        t = t + 1

                }

                exclude_temp <- append(exclude_temp, pathc)

                ret_pathc <- pathc

                pathc <- paste(unlist(str_split(pathc, "/"))[1:str_count(pathc, "/")], collapse="/")

                if (pathc == pathc2){ exclude_f <- append(exclude_f, ret_pathc) }
                
        }

        ret <- grep(TRUE, (str_count(exclude_temp, "/") < xmin))

        if (length(ret) > 0){

                return(exclude_temp[-ret])

        }else{

                return(exclude_temp)

        }

}

#' fold_rec
#'
#' Allow to get all the files recursively from a path according to an end and start depth value. If you want to have an other version of this function that uses a more sophisticated algorythm (which can be faster), check file_rec2. Depth example: if i have dir/dir2/dir3, dir/dir2b/dir3b, i have a depth equal to 3
#' @param xmax is the end depth value
#' @param xmin is the start depth value
#' @param pathc is the reference path 
#' @export

fold_rec <- function(xmax, xmin=1, pathc="."){

        vec <- list.dirs(pathc, recursive=TRUE)

        rtnl <- c()

        print(vec)

        for (i in 1:length(vec)){

                if (str_count(vec[i], "/") <= xmax & str_count(vec[i], "/") >= xmin){

                        rtnl <- append(rtnl, vec[i])

                }

        }

        return(rtnl)

}

#' get_rec 
#'
#' Allow to get the value of directorie depth from a path.
#'
#' @param pathc is the reference path
#' example: if i have dir/dir2/dir3, dir/dir2b/dir3b, i have a depth equal to 3
#' @export

get_rec <- function(pathc="."){

        vec <- list.dirs(pathc, recursive=TRUE)

        rtnl <- c()

        for (i in 1:length(vec)){

                rtnl <- append(rtnl, str_count(vec[i], "/"))

        }

        return(max(rtnl))

}

#' list_files
#' 
#' A list.files() based function addressing the need of listing the files with extension a or or extension b ...
#'
#' @param pathc is the path, can be a vector of multiple path because list.files() supports it.
#' @param patternc is a vector containing all the exensions you want
#' @export

list_files <- function(patternc, pathc="."){

       rtnl <- c()

       for (i in 1:length(patternc)){

               rtnl <- append(rtnl, list.files(path=pathc, pattern=patternc[i]))

       }

       return(sort(rtnl))

}

#' ptrn_twkr
#'
#' Allow to modify the pattern length of element in a vector according to arguments. What is here defined as a pattern is something like this xx-xx-xx or xx/xx/xxx... So it is defined by the separator
#' @param inpt_l is the input vector
#' @param depth is the number (numeric) of separator it will keep as a result. To keep the number of separator of the element that has the minimum amount of separator do depth="min" and depth="max" (character) for the opposite. This value defaults to "max".
#' @param sep is the separator of the pattern, defaults to "-"
#' @param default_val is the default val that will be placed between the separator, defaults to "00" 
#' @param add_sep defaults to TRUE. If set to FALSE, it will remove the separator for the patterns that are included in the interval between the depth amount of separator and the actual number of separator of the element.
#' @param end_ is if the default_val will be added at the end or at the beginning of each element that lacks length compared to depth
#'
#' @examples
#' 
#' v <- c("2012-06-22", "2012-06-23", "2022-09-12", "2022")
#'
#' ptrn_twkr(inpt_l=v, depth="max", sep="-", default_val="00", add_sep=TRUE)
#'
#' #[1] "2012-06-22" "2012-06-23" "2022-09-12" "2022-00-00"
#'
#' ptrn_twkr(inpt_l=v, depth=1, sep="-", default_val="00", add_sep=TRUE)
#'
#' #[1] "2012-06" "2012-06" "2022-09" "2022-00"
#' 
#' ptrn_twkr(inpt_l=v, depth="max", sep="-", default_val="00", add_sep=TRUE, end_=FALSE)
#'
#' #[1] "2012-06-22" "2012-06-23" "2022-09-12" "00-00-2022"
#'
#' @export

ptrn_twkr <- function(inpt_l, depth="max", sep="-", 
                      default_val="0", add_sep=TRUE, end_=TRUE){
  
  ln <- length(inpt_l)
  
  if (depth == "min"){
    
    pre_val <- str_count(inpt_l[1], sep)
    
    for (i in 2:ln){
      
      if (str_count(inpt_l[i], sep) < pre_val){
        
        pre_val <- str_count(inpt_l[i], sep)
        
      }
      
    }
    
    depth <- pre_val
    
  }

  if (depth == "max"){
    
    pre_val <- str_count(inpt_l[1], sep)
    
    for (i in 2:ln){
      
      if (str_count(inpt_l[i], sep) > pre_val){
        
        pre_val <- str_count(inpt_l[i], sep)
        
      }
      
    }
    
    depth <- pre_val
    
  }

  if (end_){

          for (I in 1:ln){
           
            hmn <- str_count(inpt_l[I], "-")
            
            if (hmn < depth){
             
              inpt_l[I] <- paste0(inpt_l[I], sep, default_val)

              diff <- depth - hmn - 1

              if (diff > 0){
              
                        if (add_sep == TRUE){
                          
                          for (i in 1:diff){
                          
                            inpt_l[I] <- paste0(inpt_l[I], sep, default_val)
                          
                          }
                        
                        }else{
                          
                          for (i in 1:diff){
                            
                            inpt_l[I] <- paste0(inpt_l[I], default_val)
                            
                          }
                          
                        }

             }
            
            }else if(depth < hmn){

                if (add_sep == TRUE){

                        inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse=sep)

                }else{

                        inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse="")
               
                }

            }

          }
  
  }else{

        for (I in 1:ln){
           
            hmn <- str_count(inpt_l[I], "-")
            
            if (hmn < depth){
             
              inpt_l[I] <- paste0(default_val, sep, inpt_l[I])

              diff <- depth - hmn - 1

              if (diff > 0){
              
                        if (add_sep == TRUE){
                          
                          for (i in 1:diff){
                          
                            inpt_l[I] <- paste0(default_val, sep, inpt_l[I])
                          
                          }
                        
                        }else{
                          
                          for (i in 1:diff){
                            
                            inpt_l[I] <- paste0(default_val, inpt_l[I])
                            
                          }
                          
                        }

             }
            
            }else if(depth < hmn){

                if (add_sep == TRUE){

                        inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse=sep)

                }else{

                        inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse="")
               
                }

            }

          }

  }

  return(inpt_l)
  
}

#' fillr
#' 
#' Allow to fill a vector by the last element n times
#' @param inpt_v is the input vector
#' @param ptrn_fill is the pattern used to detect where the function has to fill the vector by the last element n times. It defaults to "...\\d" where "\\d" is the regex for an int value. So this paramater has to have "\\d" which designates n.
#' @examples
#'
#' print(fillr(c("a", "b", "...3", "c")))
#'
#' #[1] "a" "b" "b" "b" "b" "c"
#'
#' @export

fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
  
  ptrn <- grep(ptrn_fill, inpt_v)

  while (length(ptrn) > 0){
   
    ptrn <- grep(ptrn_fill, inpt_v)

    idx <- ptrn[1] 
    
    untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1

    if (untl > -1){

    pre_val <- inpt_v[(idx - 1)]

    inpt_v[idx] <- pre_val

    if (untl > 0){
   
      for (i in 1:untl){
        
        inpt_v <- append(inpt_v, pre_val, idx)
        
      }
      
    }

    }else{

      inpt_v <- inpt_v[1]

    }

  ptrn <- grep(ptrn_fill, inpt_v)
    
  }
  
  return(inpt_v)
  
}

#' ptrn_switchr
#' 
#' Allow to switch, copy pattern for each element in a vector. Here a pattern is the values that are separated by a same separator. Example: "xx-xxx-xx" or "xx/xx/xxxx". The xx like values can be swicthed or copied from whatever index to whatever index. Here, the index is like this 1-2-3 etcetera, it is relative of the separator. 
#' @param inpt_l is the input vector
#' @param f_idx_l is a vector containing the indexes of the pattern you want to be altered.
#' @param t_idx_l is a vector containing the indexes to which the indexes in f_idx_l are related.
#' @param sep is the separator, defaults to "-"
#' @param default_val is the default value , if not set to NA, of the pattern at the indexes in f_idx_l. If it is not set to NA, you do not need to fill t_idx_l because this is the vector containing the indexes of the patterns that will be set as new values relatively to the indexes in f_idx_l. Defaults to NA.
#' @examples
#' 
#' print(ptrn_switchr(inpt_l=c("2022-01-11", "2022-01-14", "2022-01-21", 
#' "2022-01-01"), f_idx_l=c(1, 2, 3), t_idx_l=c(3, 2, 1)))
#'
#' #[1] "11-01-2022" "14-01-2022" "21-01-2022" "01-01-2022"
#'
#' print(ptrn_switchr(inpt_l=c("2022-01-11", "2022-01-14", "2022-01-21", 
#' "2022-01-01"), f_idx_l=c(1), default_val="ee"))
#' 
#' #[1] "ee-01-11" "ee-01-14" "ee-01-21" "ee-01-01"
#'
#' @export

ptrn_switchr <- function(inpt_l, f_idx_l=c(), t_idx_l=c(), sep="-", default_val=NA){

        if (is.na(default_val) == TRUE){

                for (I in 1:length(inpt_l)){

                        pre_val <- unlist(strsplit(inpt_l[I], split=sep))

                        pre_val2 <- pre_val

                        for (i in 1:length(f_idx_l)){

                               pre_val2[f_idx_l[i]] <- pre_val[t_idx_l[i]]

                        }

                        inpt_l[I] <- paste(pre_val2, collapse=sep)

                }

        }else{

                for (I in 1:length(inpt_l)){

                        pre_val <- unlist(strsplit(inpt_l[I], split=sep))

                        for (i in 1:length(f_idx_l)){

                               pre_val[f_idx_l[i]] <- default_val

                        }

                        inpt_l[I] <- paste(pre_val, collapse=sep)

                }

        }

        return(inpt_l)

}

#' globe
#'
#' Allow to calculate the distances between a set of geographical points and another established geographical point. If the altitude is not filled, so the result returned won't take in count the altitude.
#' @param lat_f is the latitude of the established geographical point
#' @param long_f is the longitude of the established geographical point
#' @param alt_f is the altitude of the established geographical point, defaults to NA
#' @param lat_n is a vector containing the latitude of the set of points
#' @param long_n is a vector containing the longitude of the set of points
#' @param alt_n is a vector containing the altitude of the set of points, defaults to NA
#' @examples
#' 
#' print(globe(lat_f=23, long_f=112, alt_f=NA, lat_n=c(2, 82), long_n=c(165, -55), alt_n=NA)) 
#'
#' #[1] 6342.844 7059.080
#'
#' print(globe(lat_f=23, long_f=112, alt_f=8, lat_n=c(2, 82), long_n=c(165, -55), alt_n=c(8, -2)))
#'
#' #[1] 6342.844 7059.087
#'
#' @export

globe <- function(lat_f, long_f, alt_f=NA, lat_n, long_n, alt_n=NA){

        rtn_l <- c()

        for (i in 1:length(lat_n)){

               sin_comp <- abs(sin(pi * ((lat_n[i] + 90) / 180)))

               if (abs(long_f - long_n[i]) != 0){

                       delta_long <- (40075 / (360 / abs(long_f - long_n[i]))) * sin_comp

               }else{

                       delat_long <- 0

               }

               if (abs(lat_f - lat_n[i]) != 0){

                        delta_lat <- 20037.5 / (180 / abs(lat_f - lat_n[i]))

               }else{

                        delta_lat <- 0

               }

               delta_f <- (delta_lat ** 2 + delta_long ** 2) ** 0.5

               if (is.na(alt_n[i]) == FALSE & is.na(alt_f) == FALSE){

                        delta_f <- ((alt_n[i] - alt_f) ** 2 + delta_f ** 2) ** 0.5

               }

               rtn_l <- append(rtn_l, delta_f, after=length(rtn_l))

        }

        return(rtn_l)

}

#' geo_min
#' 
#' Return a dataframe containing the nearest geographical points (row) according to established geographical points (column).
#' @param inpt_datf is the input dataframe of the set of geographical points to be classified, its firts column is for latitude, the second for the longitude and the third, if exists, is for the altitude. Each point is one row.
#' @param established_datf is the dataframe containing the coordiantes of the established geographical points
#' @examples
#' 
#' in_ <- data.frame(c(11, 33, 55), c(113, -143, 167))
#' 
#' in2_ <- data.frame(c(12, 55), c(115, 165))
#' 
#' print(geo_min(inpt_datf=in_, established_datf=in2_))
#'
#' #         X1       X2
#' #1   245.266       NA
#' #2 24200.143       NA
#' #3        NA 127.7004
#' 
#' in_ <- data.frame(c(51, 23, 55), c(113, -143, 167), c(6, 5, 1))
#' 
#' in2_ <- data.frame(c(12, 55), c(115, 165), c(2, 5))
#' 
#' print(geo_min(inpt_datf=in_, established_datf=in2_))
#'
#' #        X1       X2
#' #1       NA 4343.720
#' #2 26465.63       NA
#' #3       NA 5825.517
#' 
#' @export

geo_min <- function(inpt_datf, established_datf){

       globe <- function(lat_f, long_f, alt_f=NA, lat_n, long_n, alt_n=NA){

               sin_comp <- abs(sin(pi * ((lat_n + 90) / 180)))

               if (abs(long_f - long_n) != 0){

                       delta_long <- (40075 / (360 / abs(long_f - long_n))) * sin_comp

               }else{

                       delat_long <- 0

               }

               if (abs(lat_f - lat_n) != 0){

                        delta_lat <- 20037.5 / (180 / abs(lat_f - lat_n))

               }else{

                        delta_lat <- 0

               }

               delta_f <- (delta_lat ** 2 + delta_long ** 2) ** 0.5

               if (is.na(alt_n) == FALSE & is.na(alt_f) == FALSE){

                        delta_f <- ((alt_n - alt_f) ** 2 + delta_f ** 2) ** 0.5

               }

               return(delta_f)

       }

      flag_delta_l <- c()

      rtn_datf <- data.frame(matrix(nrow=nrow(inpt_datf), ncol=nrow(established_datf)))

      if (ncol(inpt_datf) == 3){

              for (i in 1:nrow(inpt_datf)){

                      flag_delta_l <- c(flag_delta_l, globe(lat_f=established_datf[1, 1], long_f=established_datf[1, 2], alt_f=established_datf[1, 3], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2], alt_n=inpt_datf[i, 3]))

              }

              rtn_datf[,1] <- flag_delta_l

              if (nrow(established_datf) > 1){

                      for (I in 2:nrow(established_datf)){

                               for (i in 1:nrow(inpt_datf)){

                                        idx <- which(is.na(rtn_datf[i,]) == FALSE)

                                        res <- globe(lat_f=established_datf[I, 1], long_f=established_datf[I, 2], alt_f=established_datf[I, 3], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2], alt_n=inpt_datf[i, 3])

                                        if (rtn_datf[i, 1:(I-1)][idx] > res){

                                               rtn_datf[i, I] <- rtn_datf[i, idx] 

                                               rtn_datf[i, idx] <- NA 

                                        }

                                }

                        }

              }

      }else{

              for (i in 1:nrow(inpt_datf)){

                      flag_delta_l <- c(flag_delta_l, globe(lat_f=established_datf[1, 1], long_f=established_datf[1, 2], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2]))

              }

              rtn_datf[,1] <- flag_delta_l

              if (nrow(established_datf) > 1){

                      for (I in 2:nrow(established_datf)){

                               for (i in 1:nrow(inpt_datf)){

                                        idx <- which(is.na(rtn_datf[i,]) == FALSE)

                                        res <- globe(lat_f=established_datf[I, 1], long_f=established_datf[I, 2], lat_n=inpt_datf[i, 1], long_n=inpt_datf[i, 2])

                                        if (rtn_datf[i, 1:(I-1)][idx] > res){

                                               rtn_datf[i, I] <- res 

                                               rtn_datf[i, idx] <- NA 

                                        }

                               }

                        }

              }

      }

      return(rtn_datf)

}

#' nestr_datf2
#'
#' Allow to write a special value (1a) in the cells of a dataframe (1b) that correspond (row and column) to whose of another dataframe (2b) that return another special value (2a). The cells whose coordinates do not match the coordinates of the dataframe (2b), another special value can be written (3a) if not set to NA. 
#' @param inptf_datf is the input dataframe (1b)
#' @param rtn_pos is the special value (1a)
#' @param rtn_neg is the special value (3a) 
#' @param nestr_datf is the dataframe (2b)
#' @param yes_val is the special value (2a) 
#' @examples
#'
#' print(nestr_datf2(inptf_datf=data.frame(c(1, 2, 1), c(1, 5, 7)), rtn_pos="yes", 
#' rtn_neg="no", nestr_datf=data.frame(c(TRUE, FALSE, TRUE), c(FALSE, FALSE, TRUE)), yes_val=TRUE)) 
#'
#' #  c.1..2..1. c.1..5..7.
#' #1        yes         no
#' #2         no         no
#' #3        yes        yes
#' 
#' @export

nestr_datf2 <- function(inptf_datf, rtn_pos, rtn_neg=NA, nestr_datf, yes_val=T){

        if (is.na(rtn_neg)){

                for (I in 1:ncol(nestr_datf)){

                        for (i in 1:nrow(nestr_datf)){

                                if (nestr_datf[i, I] == yes_val){

                                        inptf_datf[i, I] <- rtn_pos

                                }

                        }

                }

        }else{

                for (I in 1:ncol(nestr_datf)){

                        for (i in 1:nrow(nestr_datf)){

                                if (nestr_datf[i, I] == yes_val){

                                        inptf_datf[i, I] <- rtn_pos

                                }else{

                                        inptf_datf[i, I] <- rtn_neg

                                }

                        }

                }

        }

    return(inptf_datf)

}

#' nestr_datf1
#'
#' Allow to write a value (1a) to a dataframe (1b) to its cells that have the same coordinates (row and column) than the cells whose value is equal to a another special value (2a), from another another dataframe (2b). The value (1a) depends of the cell  value coordinates of the third dataframe (3b). If a cell coordinates (1c) of the first dataframe (1b) does not correspond to the coordinates of a good returning cell value (2a) from the dataframe (2b), so this cell (1c) can have its value changed to the same cell coordinates value (3a) of a third dataframe (4b), if (4b) is not set to NA.
#' @param inptf_datf is the input dataframe (1b)
#' @param inptt_pos_datf is the dataframe (2b) that corresponds to the (1a) values
#' @param inptt_neg_datf is the dataframe (4b) that has the (3a) values, defaults to NA
#' @param nestr_datf is the dataframe (2b) that has the special value (2a)
#' @param yes_val is the special value (2a)
#' @examples
#'
#' print(nestr_datf1(inptf_datf=data.frame(c(1, 2, 1), c(1, 5, 7)), 
#' inptt_pos_datf=data.frame(c(4, 4, 3), c(2, 1, 2)), 
#' inptt_neg_datf=data.frame(c(44, 44, 33), c(12, 12, 12)), 
#' nestr_datf=data.frame(c(TRUE, FALSE, TRUE), c(FALSE, FALSE, TRUE)), yes_val=TRUE)) 
#'
#' #  c.1..2..1. c.1..5..7.
#' #1          4         12
#' #2         44         12
#' #3          3          2
#'
#' print(nestr_datf1(inptf_datf=data.frame(c(1, 2, 1), c(1, 5, 7)), 
#' inptt_pos_datf=data.frame(c(4, 4, 3), c(2, 1, 2)), 
#' inptt_neg_datf=NA, 
#' nestr_datf=data.frame(c(TRUE, FALSE, TRUE), c(FALSE, FALSE, TRUE)), yes_val=TRUE))
#'
#' #   c.1..2..1. c.1..5..7.
#' #1          4          1
#' #2          2          5
#' #3          3          2
#' 
#' @export

nestr_datf1 <- function(inptf_datf, inptt_pos_datf, nestr_datf, yes_val=TRUE, inptt_neg_datf=NA){

        if (all(is.na(inptt_neg_datf)) == TRUE){

                for (I in 1:ncol(nestr_datf)){

                        for (i in 1:nrow(nestr_datf)){

                                if (nestr_datf[i, I] == yes_val){

                                        inptf_datf[i, I] <- inptt_pos_datf[i, I]

                                }

                        }

                }

        }else{

                for (I in 1:ncol(nestr_datf)){

                        for (i in 1:nrow(nestr_datf)){

                                if (nestr_datf[i, I] == yes_val){

                                        inptf_datf[i, I] <- inptt_pos_datf[i, I]

                                }else{

                                        inptf_datf[i, I] <- inptt_neg_datf[i, I]

                                }

                        }

                }

        }

    return(inptf_datf)

}

#' groupr_datf
#' 
#' Allow to create groups from a dataframe. Indeed, you can create conditions that lead to a flag value for each cell of the input dataframeaccording to the cell value. This function is based on see_datf and nestr_datf2 functions.
#' @param inpt_datf is the input dataframe
#' @param condition_lst is a list containing all the condition as a vector for each group
#' @param val_lst is a list containing all the values associated with condition_lst as a vector for each group
#' @param conjunction_lst is a list containing all the conjunctions associated with condition_lst and val_lst as a vector for each group
#' @param rtn_val_pos is a vector containing all the group flag value like this ex: c("flag1", "flag2", "flag3") 
#' @export
#' @examples interactive()
#' 
#' datf1 <- data.frame(c(1, 2, 1), c(45, 22, 88), c(44, 88, 33))
#'                                                                       
#' val_lst <- list(list(c(1), c(1)), list(c(2)), list(c(44, 88)))
#' 
#' condition_lst <- list(c(">", "<"), c("%%"), c("==", "=="))
#' 
#' conjunction_lst <- list(c("|"), c(), c("|"))
#' 
#' rtn_val_pos <- c("+", "++", "+++")
#' 
#' print(groupr_datf(inpt_datf=datf1, val_lst=val_lst, condition_lst=condition_lst, 
#' conjunction_lst=conjunction_lst, rtn_val_pos=rtn_val_pos))
#' 
#' #    X1  X2  X3
#' #1 <NA>   + +++
#' #2   ++  ++ +++
#' #3 <NA> +++   +
#' 
#' @export

groupr_datf <- function(inpt_datf, condition_lst, val_lst, conjunction_lst, rtn_val_pos=c()){
 
        nestr_datf2 <- function(inptf_datf, rtn_pos, rtn_neg=NA, nestr_datf, yes_val=TRUE){

                if (is.na(rtn_neg)){

                        for (I in 1:ncol(nestr_datf)){

                                for (i in 1:nrow(nestr_datf)){

                                        if (nestr_datf[i, I] == yes_val){

                                                inptf_datf[i, I] <- rtn_pos

                                        }

                                }

                        }

                }else{

                        for (I in 1:ncol(nestr_datf)){

                                for (i in 1:nrow(nestr_datf)){

                                        if (nestr_datf[i, I] == yes_val){

                                                inptf_datf[i, I] <- rtn_pos

                                        }else{

                                                inptf_datf[i, I] <- rtn_neg

                                        }

                                }

                        }

                }

            return(inptf_datf)

        }
 
        see_datf <- function(datf, condition_l, val_l, conjunction_l=c(), rt_val=TRUE, f_val=FALSE){

                if (length(condition_l) > 1 & length(conjunction_l) < (length(condition_l) - 1)){

                        for (i in (length(conjunction_l)+1):length(condition_l)){

                                conjunction_l <- append(conjunction_l, conjunction_l[length(conjunction_l)])

                        }

                }

                datf_rtnl <- data.frame(matrix(f_val, ncol=ncol(datf), nrow=nrow(datf)))

                all_op <- c("==", ">", "<", "!=", "%%")

                for (I in 1:ncol(datf)){

                        for (i in 1:nrow(datf)){

                                checked_l <- c()

                                previous = 1

                                for (t in 1:length(condition_l)){

                                        already <- 0

                                        if (condition_l[t] == "==" & already == 0){

                                                if (datf[i, I] %in% unlist(val_l[t])){

                                                        checked_l <- append(checked_l, TRUE)

                                                        if (length(condition_l) > 1 & t > 1){

                                                                bfr <- conjunction_l[previous:t]

                                                                if (t == length(condition_l)){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }else if (conjunction_l[t] == "|"){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }

                                                        }else if (length(condition_l) == 1){

                                                                datf_rtnl[i, I] <- rt_val

                                                        }else {

                                                                if (conjunction_l[1] == "|"){

                                                                        datf_rtnl[i, I] <- rt_val

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

                                                if (all(datf[i, I] > unlist(val_l[t])) == TRUE){

                                                        checked_l <- append(checked_l, TRUE)

                                                        if (length(condition_l) > 1 & t > 1){

                                                                bfr <- conjunction_l[previous:t]

                                                                if (t == length(condition_l)){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }else if (conjunction_l[t] == "|"){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }

                                                        }else if (length(condition_l) == 1){

                                                                datf_rtnl[i, I] <- rt_val

                                                        }else {

                                                                if (conjunction_l[1] == "|"){

                                                                        datf_rtnl[i, I] <- rt_val

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

                                                if (all(datf[i, I] < unlist(val_l[t]))){

                                                        checked_l <- append(checked_l, TRUE)

                                                        if (length(condition_l) > 1 & t > 1){

                                                                bfr <- conjunction_l[previous:t]

                                                                if (t == length(condition_l)){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }else if (conjunction_l[t] == "|"){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }

                                                        }else if (length(condition_l) == 1){

                                                                datf_rtnl[i, I] <- rt_val

                                                        }else {

                                                                if (conjunction_l[1] == "|"){

                                                                        datf_rtnl[i, I] <- rt_val

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

                                                if (!(datf[i, I] %in% unlist(val_l[t])) == TRUE){

                                                        checked_l <- append(checked_l, TRUE)

                                                        if (length(condition_l) > 1 & t > 1){

                                                                bfr <- conjunction_l[previous:t]

                                                                if (t == length(condition_l)){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }else if (conjunction_l[t] == "|"){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }

                                                        }else if (length(condition_l) == 1){

                                                                datf_rtnl[i, I] <- rt_val

                                                        }else {

                                                                if (conjunction_l[1] == "|"){

                                                                        datf_rtnl[i, I] <- rt_val

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

                                                if (sum(datf[i, I] %% unlist(val_l[t])) == 0){

                                                        checked_l <- append(checked_l, TRUE)

                                                        if (length(condition_l) > 1 & t > 1){

                                                                bfr <- conjunction_l[previous:t]

                                                                if (t == length(condition_l)){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }else if (conjunction_l[t] == "|"){

                                                                        if (length(checked_l) == length(bfr)){

                                                                                already <- 1

                                                                                datf_rtnl[i, I] <- rt_val

                                                                        }

                                                                }

                                                        }else if (length(condition_l) == 1){

                                                                datf_rtnl[i, I] <- rt_val

                                                        }else {

                                                                if (conjunction_l[1] == "|"){

                                                                        datf_rtnl[i, I] <- rt_val

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

          return(datf_rtnl)

        }
              
        rtn_datf <- data.frame(matrix(nrow=nrow(inpt_datf), ncol=ncol(inpt_datf)))

        for (I in 1:length(condition_lst)){

                pre_datf <- see_datf(datf=inpt_datf, condition_l=unlist(condition_lst[I]), val_l=unlist(val_lst[I]), conjunction_l=unlist(conjunction_lst[I])) 

                rtn_datf <- nestr_datf2(inptf_datf=rtn_datf, nestr_datf=pre_datf, rtn_pos=rtn_val_pos[I], rtn_neg=NA)  

        }

        return(rtn_datf)

}

#' occu
#'
#' Allow to see the occurence of each variable in a vector. Returns a datafame with, as the first column, the all the unique variable of the vector and , in he second column, their occurence respectively.
#' 
#' @param inpt_v the input dataframe
#' @examples
#'
#' print(occu(inpt_v=c("oui", "peut", "peut", "non", "oui")))
#'
#' #   var occurence
#' #1  oui         2
#' #2 peut         2
#' #3  non         1
#' 
#' @export

occu <- function(inpt_v){

    presence <- which(inpt_v == "")

    if (length(presence) > 0){ inpt_v <- inpt_v[-presence] }

    occu_v <- c()
    
    modal_v <- c()

    for (el in inpt_v){
      
      if (length(grep(el, modal_v)) == 1){
        
        idx <- which(modal_v == el)
        
        occu_v[idx] = occu_v[idx] + 1
        
      }else{
        
        occu_v <- append(x=occu_v, values=1, after=length(occu_v))
        
        modal_v <- append(x=modal_v, values=el, after=length(occu_v))
       
      }
    
    }

    return(data.frame("var"=modal_v, "occurence"=occu_v))
 
}

#' all_stat
#'
#' Allow to see all the main statistics indicators (mean, median, variance, standard deviation, sum, max, min, quantile) of variables in a dataframe by the modality of a variable in a column of the input datarame. In addition to that, you can get the occurence of other qualitative variables by your chosen qualitative variable, you have just to precise it in the vector "stat_var" where all the statistics indicators are given with "occu-var_you_want/".
#' 
#' @param inpt_v is the modalities of the variables 
#' @param var_add is the variables you want to get the stats from
#' @param stat_var is the stats indicators you want
#' @param inpt_datf is the input dataframe
#' @examples
#'
#' datf <- data.frame("mod"=c("first", "seco", "seco", "first", "first", "third", "first"), 
#'                 "var1"=c(11, 22, 21, 22, 22, 11, 9), 
#'                "var2"=c("d", "d", "z", "z", "z", "d", "z"), 
#'                "var3"=c(45, 44, 43, 46, 45, 45, 42),
#'               "var4"=c("A", "A", "A", "A", "B", "C", "C"))
#'
#' print(all_stat(inpt_v=c("first", "seco"), var_add = c("var1", "var2", "var3", "var4"), 
#'  stat_var=c("sum", "mean", "median", "sd", "occu-var2/", "occu-var4/", "variance", 
#' "quantile-0.75/"), 
#'  inpt_datf=datf))
#'
#' #   modal_v var_vector occu sum mean  med standard_devaition         variance
#' #1    first                                                                  
#' #2                var1       64   16 16.5   6.97614984548545 48.6666666666667
#' #3              var2-d    1                                                  
#' #4              var2-z    3                                                  
#' #5                var3      178 44.5   45   1.73205080756888                3
#' #6              var4-A    2                                                  
#' #7              var4-B    1                                                  
#' #8              var4-C    1                                                  
#' #9     seco                                                                  
#' #10               var1       43 21.5 21.5  0.707106781186548              0.5
#' #11             var2-d    1                                                  
#' #12             var2-z    1                                                  
#' #13               var3       87 43.5 43.5  0.707106781186548              0.5
#' #14             var4-A    2                                                  
#' #15             var4-B    0                                                  
#' #16             var4-C    0                                                  
#' #   quantile-0.75
#' #1               
#' #2             22
#' #3               
#' #4               
#' #5          45.25
#' #6               
#' #7               
#' #8               
#' #9               
#' #10         21.75
#' #11              
#' #12              
#' #13         43.75
#' #14              
#' #15              
#' #16              
#'
#' @export

all_stat <- function(inpt_v, var_add=c(), stat_var=c(), inpt_datf){
 
  presence <- which(inpt_v == "")
    
  if (length(presence) > 0){ inpt_v <- inpt_v[-presence] }
  
  fillr <- function(inpt_v, ptrn_fill="...\\d"){
    
    ptrn <- grep(ptrn_fill, inpt_v)
    
    while (length(ptrn) > 0){
      
      ptrn <- grep(ptrn_fill, inpt_v)
      
      idx <- ptrn[1]
      
      untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
      
      pre_val <- inpt_v[(idx - 1)]
      
      inpt_v[idx] <- pre_val
      
      if (untl > 0){
        
        for (i in 1:untl){
          
          inpt_v <- append(inpt_v, pre_val, idx)
          
        }
        
      }
      
      ptrn <- grep(ptrn_fill, inpt_v)
      
    }
    
    return(inpt_v)
    
  }
 
  pre_var <- grep("occu-", stat_var)

  col_ns <- colnames(inpt_datf)

  if (length(pre_var) > 0){ 

          u_val <- c()

          mod_idx <- c()

          idx_col <- c()

          for (idx in pre_var){

                  col_ <- unlist(strsplit(stat_var[idx], split=""))

                  end_beg <- str_locate(stat_var[idx], "-(.*?)/")

                  col_2 <- paste(col_[(end_beg[1]+1):(end_beg[2]-1)], collapse="")

                  col_ <- which(col_ns == col_2)[1] 

                  un_v <- unique(datf[, col_])

                  for (i in 1:length(un_v)){ idx_col <- c(idx_col, col_) }

                  pre_occu <- paste(col_2, un_v, sep="-")

                  u_val <- c(u_val, un_v)

                  idx_vd <- which(var_add == col_2)

                  var_add[idx_vd] <- pre_occu[1] 

                  var_add <- append(x=var_add, values=pre_occu[2:length(pre_occu)], after=idx_vd)

                  mod_idx <- c(mod_idx, c(idx_vd:(idx_vd+length(un_v)-1)))

          }

  }

  extend <- paste("...", as.character(length(var_add) - 1))

  if (length(var_add) > 0){
  
    list_stat <- list()
    
    modal_v <- c()
    
    var_vector <- c()
    
    for (el in inpt_v){
      
      modal_v <- c(modal_v, el, fillr(inpt_v=c("", extend)))
      
      var_vector <- c(var_vector, "", var_add)
      
    }

    rtn_datf <- data.frame(modal_v, var_vector)

    pre_length_var_add <- length(var_add)

    if (length(mod_idx) > 0){

        vec_cur <- c(matrix(nrow=length(var_vector), ncol=1, data=""))

        for (vr in 1:length(inpt_v)){

            for (idx in 1:length(mod_idx)){

                cur_col <- datf[, idx_col[idx]]

                vec_cur[length(var_add) * (vr - 1) + mod_idx[idx] + vr] <- sum(cur_col[datf[, 1] == inpt_v[vr]] == u_val[idx])

            }

        }

        stat_var <- stat_var[-grep("occu-", stat_var)]

        rtn_datf <- cbind(rtn_datf, "occu"=vec_cur)

        var_add <- var_add[-mod_idx]

    }

    mod_idx <- c(1:pre_length_var_add)[-mod_idx]

    for (st in stat_var){

        vec_cur <- c(matrix(nrow=length(var_vector), ncol=1, data=""))

        if (st == "max"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- max(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

            rtn_datf <- cbind(rtn_datf, "max"=vec_cur)

        }

        if (st == "min"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- min(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

            rtn_datf <- cbind(rtn_datf, "min"=vec_cur)

        }

        if (st == "variance"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- var(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

            rtn_datf <- cbind(rtn_datf, "variance"=vec_cur)

        }
        
        if (st == "sd"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- sd(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

            rtn_datf <- cbind(rtn_datf, "standard_devaition"=vec_cur)

        }
        
        if (st == "sum"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- sum(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

            rtn_datf <- cbind(rtn_datf, "sum"=vec_cur)

        }

        if (st == "median"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- median(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

            rtn_datf <- cbind(rtn_datf, "med"=vec_cur)

        }

        if (length(grep("quantile", st)) > 0){

            idx_v <- str_locate(st, "-(.*?)/")

            nb_quant <- as.numeric(paste(unlist(strsplit(x=st, split=""))[(idx_v[1]+1):(idx_v[2]-1)], collapse=""))

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- quantile(cur_col[datf[,1] == inpt_v[vr]], 
                    probs=nb_quant) 

                }

            }

        rtn_datf <- cbind(rtn_datf, "X"=vec_cur)

        colnames(rtn_datf)[length(colnames(rtn_datf))] <- paste("quantile-", as.character(nb_quant), sep="")

        }

        if (st == "mean"){

            for (vr in 1:length(inpt_v)){

                for (idx in 1:length(var_add)){

                    cur_col <- datf[, which(col_ns == var_add[idx])]

                    vec_cur[pre_length_var_add * (vr - 1) + mod_idx[idx] + vr] <- mean(cur_col[datf[,1] == inpt_v[vr]]) 

                }

            }

        rtn_datf <- cbind(rtn_datf, "mean"=vec_cur)

        }

    }
    
  }else{ datf <- data.frame(inpt_v) }

  return(rtn_datf)

}

#' inter_min
#'
#' Takes as input a list of vectors composed of ints or floats ascendly ordered (intervals) that can have a different step to one of another element ex: list(c(0, 2, 4), c(0, 4), c(1, 2, 2.3)). This function will return the list of vectors with the same steps preserving the begin and end value of each interval. The way the algorythmn searches the common step of all the sub-lists is also given by the user as a parameter, see `how_to` paramaters.
#' @param inpt_l is the input list containing all the intervals
#' @param  min_ is a value you are sure is superior to the maximum step value in all the intervals
#' @param sensi is the decimal accuracy of how the difference between each value n to n+1 in an interval is calculated
#' @param sensi2 is the decimal accuracy of how the value with the common step is calculated in all the intervals
#' @param how_to_op is a vector containing the operations to perform to the pre-common step value, defaults to only "divide". The operations can be "divide", "substract", "multiply" or "add". All type of operations can be in this parameter.
#' @param how_to_val is a vector containing the value relatives to the operations in `hot_to_op`, defaults to 3
#' output from ex:
#' @examples
#'
#' print(inter_min(inpt_l=list(c(0, 2, 4), c(0, 4), c(1, 2, 2.3))))
#'
#' # [[1]]
#' # [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8
#' #[20] 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7
#' #[39] 3.8 3.9 4.0
#' #
#' #[[2]]
#' # [1] 0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8
#' #[20] 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7
#' #[39] 3.8 3.9 4.0
#' #
#' #[[3]]
#' # [1] 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3
#' 
#' @export

inter_min <- function(inpt_l, min_=1000, sensi=3, sensi2=3, how_to_op=c("divide"),
                      how_to_val=c(3)){

        fillr <- function(inpt_v, ptrn_fill="...\\d"){
  
          ptrn <- grep(ptrn_fill, inpt_v)

          while (length(ptrn) > 0){
           
            ptrn <- grep(ptrn_fill, inpt_v)

            idx <- ptrn[1] 
            
            untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
           
            pre_val <- inpt_v[(idx - 1)]

            inpt_v[idx] <- pre_val

            if (untl > 0){
            
              for (i in 1:untl){
                
                inpt_v <- append(inpt_v, pre_val, idx)
                
              }
              
            }

          ptrn <- grep(ptrn_fill, inpt_v)
            
          }
          
          return(inpt_v)
          
        }

        diff_v2 <- c()

        diff_v <- c()

        for (lst in 1:length(inpt_l)){

            pre_v <- unlist(inpt_l[lst])

            for (idx in 1:(length(pre_v)-1)){

                diff_v <- c(diff_v, round((pre_v[idx+1] - pre_v[idx]), sensi))

            }

            diff_v2 <- c(diff_v2, diff_v)

            if (min(diff_v) < min_){ 

                min_ <- min(diff_v)

                diff_v <- c()

            }

        }

        verify <- function(diff_v2, min_){

            for (delta in diff_v2){

                pre_val <- delta / min_ %% 1

                all_eq <- 1

                if (length(grep("\\.", as.character(pre_val))) > 0){ 

                        pre_val_str <- unlist(strsplit(as.character(pre_val), split="\\."))[2]

                        pre_val_str <- unlist(strsplit(pre_val_str, split=""))[1:sensi]

                        if (length(grep(NA, pre_val_str)) > 0){

                                untl <- length(grep(NA, pre_val_str))

                                pre_val_str <- c(pre_val_str[which(is.na(pre_val_str) == FALSE)], "0")

                                pre_val_str <- fillr(inpt_v=c(pre_val_str, paste0("...", untl))) 

                        }

                        if (pre_val_str[length(pre_val_str)] != "9"){

                            all_eq <- 0

                        }else{

                                all_eq <- 1

                                for (i in 1:(length(pre_val_str)-1)){

                                    if (pre_val_str[i+1] != pre_val_str[i] | pre_val_str[i] != "9"){

                                            all_eq <- 0

                                    }

                                }

                        }

                }

                if (round(pre_val * (10 ** sensi), 0) != 0 & all_eq != 1){

                    ht <- how_to_op[1]

                    nb <- how_to_val[1]

                    if (length(how_to_op) > 1){

                        how_to_op <- how_to_op[2:length(how_to_op)]

                    }

                    if (length(how_to_val) > 1){

                        how_to_val <- how_to_val[2:length(how_to_op)]

                    }
                
                    if (ht == "divide"){

                        min_ <- round((min_ / nb), sensi)

                    }else if (ht == "add"){

                        min_ <- min_ + nb

                    }else if (ht == "multiply"){

                        min_ <- min * nb

                    }else{

                        min_ <- min_ - nb

                    }

                }

            }

            cnt <- 0

            for (lst in inpt_l){

                pre_v <- c()

                add_val <- lst[1]

                inpt_l[1] <- c()

                while (add_val <= lst[length(lst)]){

                    pre_v <- c(pre_v, add_val)

                    add_val <- round(add_val + min_, sensi2)

                }

                inpt_l <- append(x=inpt_l, values=list(pre_v))

                cnt <- cnt + 1

            }

            return(inpt_l)

        }

        rtn_l <- verify(diff_v2=diff_v2, min_=min_)

        return(rtn_l)

}

#' inter_max
#'
#' Takes as input a list of vectors composed of ints or floats ascendly ordered (intervals) that can have a different step to one of another element ex: list(c(0, 2, 4), c(0, 4), c(1, 2, 2.3)). The function will return the list of lists altered according to the maximum step found in the input list.
#' @param inpt_l is the input list
#' @param max_ is a value you are sure is the minimum step value of all the sub-lists
#' @param get_lst is the parameter that, if set to True, will keep the last values of vectors in the return value if the last step exceeds the end value of the vector.
#' @examples
#'
#' print(inter_max(inpt_l=list(c(0, 2, 4), c(0, 4), c(1, 2, 2.3)), get_lst=TRUE))
#'  
#' #[[1]]
#' #[1] 0 4
#' #
#' #[[2]]
#' #[1] 0 4
#' #
#' #[[3]]
#' #[1] 1.0 2.3
#' 
#' print(inter_max(inpt_l=list(c(0, 2, 4), c(0, 4), c(1, 2, 2.3)), get_lst=FALSE))
#'
#' # [[1]]
#' #[1] 0 4
#' #
#' #[[2]]
#' #[1] 0 4
#' #
#' #[[3]]
#' #[1] 1
#'
#' @export

inter_max <- function(inpt_l, max_=-1000, get_lst=TRUE){

    for (lst in 1:length(inpt_l)){

            diff_v <- c()

            cur_v <- unlist(inpt_l[lst])

            for (el in 1:(length(cur_v) - 1)){

                diff_v <- c(diff_v, (cur_v[el + 1] - cur_v[el]))

            }

            if (max(diff_v) > max_){

                max_ <- max(diff_v)

            }

    }

    cnt <- 0

    for (lst in inpt_l){

        cur_lst <- unlist(lst)

        add_val <- cur_lst[1]

        pre_v <- c()

        inpt_l[1] <- c()

        while (add_val <= cur_lst[length(cur_lst)]){

            pre_v <- c(pre_v, add_val)

            add_val <- add_val + max_

        }

        if (get_lst & cur_lst[length(cur_lst)] != pre_v[length(pre_v)]){

            pre_v <- c(pre_v, cur_lst[length(cur_lst)])

        }

        inpt_l <- append(x=inpt_l, values <- list(pre_v), after=length(inpt_l))

        cnt <- cnt + 1

    }

    return(inpt_l)

}

#' incr_fillr
#' 
#' Take a vector uniquely composed by double and sorted ascendingly, a step, another vector of elements whose length is equal to the length of the first vector, and a default value. If an element of the vector is not equal to its predecessor minus a user defined step, so these can be the output according to the parameters (see example):
#' @param inpt_v is the asending double only composed vector
#' @param wrk_v is the other vector (size equal to inpt_v), defaults to NA
#' @param default_val is the default value put when the difference between two following elements of inpt_v is greater than step, defaults to NA
#' @param step is the allowed difference between two elements of inpt_v
#' @examples
#'
#' print(incr_fillr(inpt_v=c(1, 2, 4, 5, 9, 10), 
#'                 wrk_v=NA, 
#'                 default_val="increasing"))
#'
#' #[1]  1  2  3  4  5  6  7  8  9 10
#'
#' print(incr_fillr(inpt_v=c(1, 1, 2, 4, 5, 9), 
#'                 wrk_v=c("ok", "ok", "ok", "ok", "ok"), 
#'                 default_val=NA))
#'
#' #[1] "ok" "ok" "ok" NA   "ok" "ok" NA   NA   NA  
#'
#' print(incr_fillr(inpt_v=c(1, 2, 4, 5, 9, 10), 
#'                 wrk_v=NA, 
#'                 default_val="NAN"))
#'
#' #[1] "1"   "2"   "NAN" "4"   "5"   "NAN" "NAN" "NAN" "9"   "10" 
#'
#' @export

incr_fillr <- function(inpt_v, wrk_v=NA, default_val=NA, step=1){

    if (all(is.na(wrk_v))){

        rtn_v <- inpt_v

    }else{

        rtn_v <- wrk_v

    }

    if (is.na(default_val)){

        i = 2

        while (i <= length(inpt_v)){

            if (is.na(inpt_v[(i-1)]) == FALSE){

                if ((inpt_v[(i-1)] + step) < inpt_v[i]){

                    rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                    inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                    bf_val = inpt_v[(i-1)] + 1

                }

            }else if ((bf_val + step) < inpt_v[i]){

                    rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                    inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                    bf_val = bf_val + 1

            }

            i = i + 1

        }

    }else if (default_val != "increasing"){

        i = 2

        while (i <= length(inpt_v)){

            if (inpt_v[(i-1)] != default_val){

                if ((as.numeric(inpt_v[(i-1)]) + step) < as.numeric(inpt_v[i])){

                    rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                    inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                    bf_val = as.numeric(inpt_v[(i-1)]) + 1

                }

            }else if ((bf_val + step) < as.numeric(inpt_v[i])){

                    inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                    rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                    bf_val = bf_val + 1

            }

            i = i + 1

        }

    }else{

        i = 2

        while (i <= length(rtn_v)){

            if ((inpt_v[(i-1)] + step) < inpt_v[i]){

                rtn_v <- append(x=rtn_v, values=(inpt_v[(i-1)]+1), after=(i-1))

                inpt_v <- append(x=inpt_v, values=(inpt_v[(i-1)]+1), after=(i-1))

            }

            i = i + 1

        }

    }

    return(rtn_v)

}

#' paste_datf
#' 
#' Return a vector composed of pasted elements from the input dataframe at the same index.
#' @param inpt_datf is the input dataframe
#' @param sep is the separator between pasted elements, defaults to ""
#' @examples
#' 
#' print(paste_datf(inpt_datf=data.frame(c(1, 2, 1), c(33, 22, 55))))
#'
#' [1] "133" "222" "155"
#'
#' @export

paste_datf <- function(inpt_datf, sep=""){
    if (ncol(as.data.frame(inpt_datf)) == 1){ 
        return(inpt_datf) 
    }else {
        rtn_datf <- inpt_datf[,1]
        for (i in 2:ncol(inpt_datf)){
            rtn_datf <- paste(rtn_datf, inpt_datf[,i], sep=sep)
        }
        return(rtn_datf)
    }
}

#' nest_v
#' 
#' Nest two vectors according to the following parameters.
#' @param f_v is the vector that will welcome the nested vector t_v
#' @param t_v is the imbriquator vector
#' @param step defines after how many elements of f_v the next element of t_v can be put in the output
#' @param after defines after how many elements of f_v, the begining of t_v can be put 
#' @examples
#' 
#' print(nest_v(f_v=c(1, 2, 3, 4, 5, 6), t_v=c("oui", "oui2", "oui3", "oui4", "oui5", "oui6"), 
#'      step=2, after=2))
#'
#' #[1] "1"    "2"    "oui"  "3"    "4"    "oui2" "5"    "6"    "oui3" "oui4"
#' 
#' @export

nest_v <- function(f_v, t_v, step=1, after=1){

    cnt = after

    for (i in 1:length(t_v)){

        f_v <- append(x=f_v, values=t_v[i], after=cnt)

        cnt = cnt + step + 1

    }

    return(f_v)

}

#' fixer_nest_v
#'
#' Retur the elements of a vector "wrk_v" (1) that corresponds to the pattern of elements in another vector "cur_v" (2) according to another vector "pttrn_v" (3) that contains the patterof elements.
#' @param cur_v is the input vector
#' @param pttrn_v is the vector containing all the patterns that may be contained in cur_v
#' @param wrk_v is a vector containing all the indexes of cur_v taken in count in the function
#' @examples
#'
#'print(fixer_nest_v(cur_v=c("oui", "non", "peut-etre", "oui", "non", "peut-etre"), 
#'              pttrn_v=c("oui", "non", "peut-etre"), 
#'                   wrk_v=c(1, 2, 3, 4, 5, 6)))
#'
#'#[1] 1 2 3 4 5 6
#'
#'print(fixer_nest_v(cur_v=c("oui", "non", "peut-etre", "oui", "non", "peut-etre"), 
#'                  pttrn_v=c("oui", "non"), 
#'                   wrk_v=c(1, 2, 3, 4, 5, 6)))
#'
#'#[1]  1  2 NA  4  5 NA
#'
#' @export

fixer_nest_v <- function(cur_v, pttrn_v, wrk_v){

    cnt = 1

    cnt2 = 0

    for (i in 1:length(cur_v)){

        if (pttrn_v[cnt] != cur_v[i]){

            if (cnt2 == 0){

                idx <- (cnt2*length(pttrn_v)-1) + match(TRUE, str_detect(pttrn_v, paste0("\\b(", cur_v[i], ")\\b"))) 

            }else{

                idx <- cnt2*length(pttrn_v) + match(TRUE, str_detect(pttrn_v, paste0("\\b(", cur_v[i], ")\\b"))) 

            }

            rtain_val <- wrk_v[idx]

            wrk_v[idx] <- wrk_v[i] 

            wrk_v[i] <- rtain_val

            rtain_val <- cur_v[idx]

            cur_v[idx] <- cur_v[i]

            cur_v[i] <- rtain_val

            if (cnt == length(pttrn_v)){ cnt = 1; cnt2 = cnt2 + 1 }else if (cnt > 1) { cnt = cnt + 1 }

        }else{

            if (cnt == length(pttrn_v)){ cnt = 1; cnt2 = cnt2 + 1 }else { cnt = cnt + 1 }

        }

    }

    return(wrk_v)

}

#' lst_flatnr
#'
#' Flatten a list to a vector
#' 
#' @param inpt_l is the input list
#'
#' @examples
#'
#'print(lst_flatnr(inpt_l=list(c(1, 2), c(5, 3), c(7, 2, 7))))
#'
#'#[1] 1 2 5 3 7 2 7
#'
#' @export

lst_flatnr <- function(inpt_l){

    rtn_v <- c()

    for (el in inpt_l){

        rtn_v <- c(rtn_v, el)

    }

    return(rtn_v)

}

#' extrt_only_v
#' 
#' Returns the elements from a vector "inpt_v" that are in another vector "pttrn_v"
#'
#' @param inpt_v is the input vector 
#' @param pttrn_v is the vector contining all the elements that can be in inpt_v 
#' @examples
#'
#'print(extrt_only_v(inpt_v=c("oui", "non", "peut", "oo", "ll", "oui", "non", "oui", "oui"), 
#'      pttrn_v=c("oui")))
#'
#'#[1] "oui" "oui" "oui" "oui"
#'
#' @export

extrt_only_v <- function(inpt_v, pttrn_v){

    rtn_v <- c()

    for (el in inpt_v){

        if (el %in% pttrn_v){ rtn_v <- c(rtn_v, el) }

    }

    return(rtn_v)

}

#' new_ordered
#'
#' Returns the indexes of elements contained in "w_v" according to "f_v"
#' 
#' @param f_v is the input vector
#' @param w_v is the vector containing the elements that can be in f_v
#' @param nvr_here is a value you are sure is not present in f_v
#' @examples
#'
#' print(new_ordered(f_v=c("non", "non", "non", "oui"), w_v=c("oui", "non", "non")))
#'
#' #[1] 4 1 2
#' 
#' @export

new_ordered <- function(f_v, w_v, nvr_here=NA){

    rtn_v <- c()

    for (el in w_v){

        idx <- match(el, f_v)

        rtn_v <- c(rtn_v, idx)

        f_v[idx] <- nvr_here

    }

    return(rtn_v)

}

#' appndr
#'
#' Append to a vector "inpt_v" a special value "val" n times "mmn". The appending begins at "strt" index.
#' @param inpt_v is the input vector
#' @param val is the special value
#' @param hmn is the number of special value element added
#' @param strt is the index from which appending begins, defaults to max which means the end of "inpt_v"
#' @examples
#'
#' print(appndr(inpt_v=c(1:3), val="oui", hmn=5))
#'
#' #[1] "1"   "2"   "3"   "oui" "oui" "oui" "oui" "oui"
#'
#' print(appndr(inpt_v=c(1:3), val="oui", hmn=5, strt=1))
#'
#' #[1] "1"   "oui" "oui" "oui" "oui" "oui" "2"   "3" 
#' 
#' @export

appndr <- function(inpt_v, val=NA, hmn, strt="max"){

    if (strt == "max"){

        strt <- length(inpt_v)

    }

    if (hmn > 0){

        for (i in 1:hmn){ inpt_v <- append(x=inpt_v, values=val, after=strt) }

    }

    return(inpt_v)

}

#' any_join_datf
#'
#' Allow to perform SQL joints with more features
#' @param inpt_datf_l is a list containing all the dataframe
#' @param join_type is the joint type. Defaults to inner but can be changed to a vector containing all the dataframes you want to take their ids to don external joints.
#' @param join_spe can be equal to a vector to do an external joints on all the dataframes. In this case, join_type should not be equal to "inner"
#' @param id_v is a vector containing all the ids name of the dataframes. The ids names can be changed to number of their columns taking in count their position in inpt_datf_l. It means that if my id is in the third column of the second dataframe and the first dataframe have 5 columns, the column number of the ids is 5 + 3 = 8
#' @param excl_col is a vector containing the column names to exclude, if this vector is filled so "rtn_col" should not be filled. You can also put the column number in the manner indicated for "id_v". Defaults to c()
#' @param rtn_col is a vector containing the column names to retain, if this vector is filled so "excl_col" should not be filled. You can also put the column number in the manner indicated for "id_v". Defaults to c()
#' @param d_val is the default val when here is no match 
#' @examples
#'
#'datf1 <- data.frame("val"=c(1, 1, 2, 4), "ids"=c("e", "a", "z", "a"), 
#'"last"=c("oui", "oui", "non", "oui"),
#'"second_ids"=c(13, 11, 12, 8), "third_col"=c(4:1))
#'
#'datf2 <- data.frame("val"=c(3, 7, 2, 4, 1, 2), "ids"=c("a", "z", "z", "a", "a", "a"), 
#'"bool"=c(TRUE, FALSE, FALSE, FALSE, TRUE, TRUE),
#'"second_ids"=c(13, 12, 8, 34, 22, 12))
#'
#'datf3 <- data.frame("val"=c(1, 9, 2, 4), "ids"=c("a", "a", "z", "a"), 
#'"last"=c("oui", "oui", "non", "oui"),
#'"second_ids"=c(13, 11, 12, 8))
#'
#'print(any_join_datf(inpt_datf_l=list(datf1, datf2, datf3), join_type="inner", 
#'id_v=c("ids", "second_ids"), 
#'                  excl_col=c(), rtn_col=c()))
#' 
#'#  ids val ids last second_ids val ids  bool second_ids val ids last second_ids
#'#3 z12   2   z  non         12   7   z FALSE         12   2   z  non         12
#'
#'print(any_join_datf(inpt_datf_l=list(datf1, datf2, datf3), join_type="inner", id_v=c("ids"),
#'excl_col=c(), rtn_col=c()))
#'
#'#  ids val ids last second_ids val ids  bool second_ids val ids last second_ids
#'#2   a   1   a  oui         11   3   a  TRUE         13   1   a  oui         13
#'#3   z   2   z  non         12   7   z FALSE         12   2   z  non         12
#'#4   a   4   a  oui          8   4   a FALSE         34   9   a  oui         11
#'
#'print(any_join_datf(inpt_datf_l=list(datf1, datf2, datf3), join_type=c(1), id_v=c("ids"), 
#'                  excl_col=c(), rtn_col=c()))
#'
#'#  ids val ids last second_ids  val  ids  bool second_ids  val  ids last
#'#1   e   1   e  oui         13 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>
#'#2   a   1   a  oui         11    3    a  TRUE         13    1    a  oui
#'#3   z   2   z  non         12    7    z FALSE         12    2    z  non
#'#4   a   4   a  oui          8    4    a FALSE         34    9    a  oui
#'#  second_ids
#'#1       <NA>
#'#2         13
#'#3         12
#'#4         11
#'
#'print(any_join_datf(inpt_datf_l=list(datf2, datf1, datf3), join_type=c(1, 3), 
#'                  id_v=c("ids", "second_ids"), 
#'                  excl_col=c(), rtn_col=c()))
#' 
#'#   ids  val  ids  bool second_ids  val  ids last second_ids  val  ids last
#'#1  a13    3    a  TRUE         13 <NA> <NA> <NA>       <NA>    1    a  oui
#'#2  z12    7    z FALSE         12    2    z  non         12    2    z  non
#'#3   z8    2    z FALSE          8 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
#'#4  a34    4    a FALSE         34 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
#'#5  a22    1    a  TRUE         22 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
#'#6  a12    2    a  TRUE         12 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
#'#7  a13 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
#'#8  a11 <NA> <NA>  <NA>       <NA>    1    a  oui         11    9    a  oui
#'#9  z12 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
#'#10  a8 <NA> <NA>  <NA>       <NA>    4    a  oui          8    4    a  oui
#'#   second_ids
#'#1          13
#'#2          12
#'#3        <NA>
#'#4        <NA>
#'#5        <NA>
#'#6        <NA>
#'#7        <NA>
#'#8          11
#'#9        <NA>
#'#10          8
#'
#'print(any_join_datf(inpt_datf_l=list(datf1, datf2, datf3), join_type=c(1), id_v=c("ids"), 
#'                  excl_col=c(), rtn_col=c()))
#'
#'#ids val ids last second_ids  val  ids  bool second_ids  val  ids last
#'#1   e   1   e  oui         13 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>
#'#2   a   1   a  oui         11    3    a  TRUE         13    1    a  oui
#'#3   z   2   z  non         12    7    z FALSE         12    2    z  non
#'#4   a   4   a  oui          8    4    a FALSE         34    9    a  oui
#'#  second_ids
#'#1       <NA>
#'#2         13
#'#3         12
#'#4         11
#' 
#' @export

any_join_datf <- function(inpt_datf_l, join_type="inner", join_spe=NA, id_v=c(),  
                    excl_col=c(), rtn_col=c(), d_val=NA){

    incr_fillr <- function(inpt_v, wrk_v=NA, default_val=NA, step=1){

            if (all(is.na(wrk_v))){

                rtn_v <- inpt_v

            }else{

                rtn_v <- wrk_v

            }

            if (is.na(default_val)){

                i = 2

                while (i <= length(inpt_v)){

                    if (is.na(inpt_v[(i-1)]) == FALSE){

                        if ((inpt_v[(i-1)] + step) < inpt_v[i]){

                            rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                            inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                            bf_val = inpt_v[(i-1)] + 1

                        }

                    }else if ((bf_val + step) < inpt_v[i]){

                            rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                            inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                            bf_val = bf_val + 1

                    }

                    i = i + 1

                }

            }else if (default_val != "increasing"){

                i = 2

                while (i <= length(inpt_v)){

                    if (inpt_v[(i-1)] != default_val){

                        if ((as.numeric(inpt_v[(i-1)]) + step) < as.numeric(inpt_v[i])){

                            rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                            inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                            bf_val = as.numeric(inpt_v[(i-1)]) + 1

                        }

                    }else if ((bf_val + step) < as.numeric(inpt_v[i])){

                            inpt_v <- append(x=inpt_v, values=default_val, after=(i-1))

                            rtn_v <- append(x=rtn_v, values=default_val, after=(i-1))

                            bf_val = bf_val + 1

                    }

                    i = i + 1

                }

            }else{

                i = 2

                while (i <= length(rtn_v)){

                    if ((inpt_v[(i-1)] + step) < inpt_v[i]){

                        rtn_v <- append(x=rtn_v, values=(inpt_v[(i-1)]+1), after=(i-1))

                        inpt_v <- append(x=inpt_v, values=(inpt_v[(i-1)]+1), after=(i-1))

                    }

                    i = i + 1

                }

            }

            return(rtn_v)

    }

    fixer_nest_v <- function(cur_v, pttrn_v, wrk_v){

            cnt = 1

            cnt2 = 0

            for (i in 1:length(cur_v)){

                if (pttrn_v[cnt] != cur_v[i]){

                    if (cnt2 == 0){

                        idx <- (cnt2*length(pttrn_v)-1) + match(TRUE, str_detect(pttrn_v, paste0("\\b(", cur_v[i], ")\\b"))) 

                    }else{

                        idx <- cnt2*length(pttrn_v) + match(TRUE, str_detect(pttrn_v, paste0("\\b(", cur_v[i], ")\\b"))) 

                    }

                    rtain_val <- wrk_v[idx]

                    wrk_v[idx] <- wrk_v[i] 

                    wrk_v[i] <- rtain_val

                    rtain_val <- cur_v[idx]

                    cur_v[idx] <- cur_v[i]

                    cur_v[i] <- rtain_val

                    if (cnt == length(pttrn_v)){ cnt = 1; cnt2 = cnt2 + 1 }else if (cnt > 1) { cnt = cnt + 1 }

                }else{

                    if (cnt == length(pttrn_v)){ cnt = 1; cnt2 = cnt2 + 1 }else { cnt = cnt + 1 }

                }

            }

            return(wrk_v)

        }

    appndr <- function(inpt_v, val=NA, hmn, strt="max"){

        if (strt == "max"){

            strt <- length(inpt_v)

        }

        if (hmn > 0){

            for (i in hmn){ inpt_v <- append(x=inpt_v, values=val, after=strt) }

        }

        return(inpt_v)

    }

    calc_occu_v <- function(f_v, w_v, nvr_here=NA){

            rtn_v <- c()

            idx_status <- c()

            f_v2 <- f_v

            for (el in 1:length(w_v)){

                cur_ids <- match(w_v[el], f_v)

                f_v[cur_ids] <- nvr_here

                idx_status <- c(idx_status, cur_ids)

            }

            for (i in sort(idx_status)){

                idx <- match(f_v2[i], w_v)

                rtn_v <- c(rtn_v, idx)

                w_v[idx] <- nvr_here

            }

            return(rtn_v)

    }

    extrt_only_v <- function(inpt_v, pttrn_v){

            rtn_v <- c()

            for (el in inpt_v){

                if (el %in% pttrn_v){ rtn_v <- c(rtn_v, el) }

            }

            return(rtn_v)

    }

    nest_v <- function(f_v, t_v, step=1, after=1){

        cnt = after

        for (i in 1:length(t_v)){

            f_v <- append(x=f_v, values=t_v[i], after=cnt)

            cnt = cnt + step + 1

        }

        return(f_v)

    }

    paste_datf <- function(inpt_datf, sep=""){

        if (ncol(as.data.frame(inpt_datf)) == 1){ 

            return(inpt_datf) 

        }else {

            rtn_datf <- inpt_datf[,1]

            for (i in 2:ncol(inpt_datf)){

                rtn_datf <- paste(rtn_datf, inpt_datf[,i], sep=sep)

            }

            return(rtn_datf)

        }

    }

    n_row <- 1

    col_intel <- c()

    for (datf_ in inpt_datf_l){ 

        if (nrow(datf_) > n_row){ n_row <- nrow(datf_) }

        col_intel <- c(col_intel, (sum(col_intel) + ncol(datf_)))

    }

    cl_nms <- colnames(as.data.frame(inpt_datf_l[1]))

    if (length(inpt_datf_l) > 1){

            for (i in 2:length(inpt_datf_l)){

                cl_nms <- c(cl_nms, colnames(as.data.frame(inpt_datf_l[i])))

            }

    }

    if (length(excl_col) > 0 & length(rtn_col) == 0){

            pre_col <- c(1:sum(mapply(function(x) return(ncol(x)), inpt_datf_l)))

            if (typeof(excl_col) == "character"){

                excl_col2 <- c() 

                for (el in excl_col){ excl_col2 <- c(excl_col2, match(el, cl_nms)) }

                pre_col <- pre_col[-excl_col2]

            }else{

                pre_col <- pre_col[-excl_col]

            }

    }else if ((length(excl_col) + length(rtn_col)) == 0){

        pre_col <- c(1:sum(mapply(function(x) return(ncol(x)), inpt_datf_l)))

    }else{

        if (typeof(rtn_col) == "character"){

            pre_col <- c()

            for (el in rtn_col){ pre_col <- c(pre_col, match(el, cl_nms)) }

        }else{

            pre_col <- rtn_col

        }

    }

    if (typeof(id_v) == "character"){

        id_v2 <- which(cl_nms == id_v[1])

        if (length(id_v) > 1){

            for (i in 2:length(id_v)){ id_v2 <- nest_v(f_v=id_v2, t_v=which(cl_nms == id_v[i]), after=(i-1)) }

        }

        id_v2 <- fixer_nest_v(cur_v=extrt_only_v(inpt_v=cl_nms, pttrn_v=id_v), pttrn_v=id_v, wrk_v=id_v2)

    }

    col_intel_cnt = 1 

    id_v_cnt = 1

    pre_col <- sort(pre_col)

    substrct <- 0

    ids_val_func <- function(x){

            lst_el <- length(which(lst_ids == x))

            if (length(which(cur_ids == x)) > lst_el){ 

                    return(which(cur_ids == x)[1:lst_el]) 

            }else {

                    return(which(cur_ids == x)[1:length(which(cur_ids == x))])

            }

    }

    if (all(join_type == "inner") & all(is.na(join_spe))){

        cur_datf <- as.data.frame(inpt_datf_l[1])

        cur_id_v <- id_v2[1:length(id_v)]

        rtn_datf <- cur_datf[, cur_id_v]

        cur_ids <- paste_datf(cur_datf[, cur_id_v])

        rtn_datf <- data.frame(cur_ids)

        cur_ids_val <- c(1:nrow(cur_datf))

        calc_ids <- c(1:nrow(rtn_datf))

        for (cur_col in pre_col){

            while (col_intel[col_intel_cnt] < cur_col){

                lst_ids <- cur_ids[cur_ids_val]

                id_v_cnt = id_v_cnt + length(id_v)

                col_intel_cnt = col_intel_cnt + 1

                cur_datf <- as.data.frame(inpt_datf_l[col_intel_cnt])

                cur_id_v <- id_v2[id_v_cnt:(id_v_cnt+length(id_v)-1)] 

                cur_ids <- paste_datf(cur_datf[, 
                    cur_id_v-(sum(mapply(function(x) return(ncol(x)), inpt_datf_l[1:(col_intel_cnt-1)])))])

                cur_ids_val2 <- sort(lst_flatnr(mapply(function(x) return(which(lst_ids == x)), unique(cur_ids))))

                rtn_datf <- rtn_datf[cur_ids_val2, ]

                cur_ids_val <- sort(lst_flatnr(mapply(function(x) return(ids_val_func(x)), unique(lst_ids[cur_ids_val2]))))

                substrct <- sum(mapply(function(x) return(ncol(x)), inpt_datf_l[1:(col_intel_cnt-1)]))

                calc_ids <- calc_occu_v(f_v=lst_ids, w_v=cur_ids[cur_ids_val])

                calc_ids <- calc_ids[is.na(calc_ids)==FALSE]

            }

            pre_rtn_datf <- cur_datf[cur_ids_val, (cur_col - substrct)]

            pre_rtn_datf <- pre_rtn_datf[calc_ids]

            rtn_datf <- cbind(rtn_datf, pre_rtn_datf)

            colnames(rtn_datf)[length(colnames(rtn_datf))] <- cl_nms[cur_col]

        }

        colnames(rtn_datf)[1] <- "ids"

        return(rtn_datf)

    }else{

        spe_match <- function(f_v, w_v, nvr_here=NA){

            rtn_v <- c()

            for (i in 1:length(w_v)){

                idx <- match(w_v[i], f_v)

                rtn_v <- c(rtn_v, idx)

                f_v[idx] <- nvr_here

            }

            return(rtn_v)

        }

        if (is.na(join_spe)){

                strt_id <- 1

                cur_datf <- as.data.frame(inpt_datf_l[join_type[1]])

                cur_id_v <- id_v2[strt_id:length(id_v)]

                cur_ids <- paste_datf(cur_datf[, cur_id_v])

                if (length(join_type) > 1){

                        join_type <- join_type[2:length(join_type)]

                        for (datf in join_type){

                                    strt_id <- length(id_v) * (datf-1) + 1

                                    cur_datf <- as.data.frame(inpt_datf_l[datf])

                                    cur_id_v <- id_v2[strt_id:(strt_id+length(id_v)-1)]

                                    cur_ids <- c(cur_ids, paste_datf(cur_datf[, 
                                cur_id_v - sum(mapply(function(x) return(ncol(x)), inpt_datf_l[1:(datf-1)]))]))

                        }

                        cur_datf <- as.data.frame(inpt_datf_l[1])

                }

                lst_ids <- cur_ids

                cur_ids_val <- sort(lst_flatnr(mapply(function(x) return(which(lst_ids == x)), unique(cur_ids))))

        }else{

                lst_ids <- cur_ids

                cur_datf <- as.data.frame(inpt_datf_l[1])

                cur_id_v <- id_v2[1:length(id_v)]

                cur_ids <- paste_datf(cur_datf[, cur_id_v])

                cur_ids_val <- sort(lst_flatnr(mapply(function(x) return((which(lst_ids == x))), unique(cur_ids))))

        }

        rtn_datf <- data.frame(cur_ids)

        cur_ids_val2 <- c(1:nrow(rtn_datf)) 

        calc_ids <- c(1:length(lst_ids))

        for (cur_col in pre_col){

            while (col_intel[col_intel_cnt] < cur_col){

                col_intel_cnt = col_intel_cnt + 1

                substrct <- sum(mapply(function(x) return(ncol(x)), inpt_datf_l[1:(col_intel_cnt-1)]))

                cur_datf <- as.data.frame(inpt_datf_l[col_intel_cnt])

                id_v_cnt = id_v_cnt + length(id_v)

                cur_id_v <- id_v2[id_v_cnt:(id_v_cnt+(length(id_v)-1))]

                cur_ids <- paste_datf(cur_datf[, (cur_id_v - substrct)])

                cur_ids_val2 <- lst_flatnr(mapply(function(x) return(ids_val_func(x)), unique(lst_ids)))

                cur_ids_val2 <- cur_ids_val2[is.na(cur_ids_val2)==FALSE]

                cur_ids_val <- sort(spe_match(f_v=lst_ids, w_v=cur_ids[cur_ids_val2]))

                cur_ids_val <- c(0, cur_ids_val)

                calc_ids <- calc_occu_v(f_v=lst_ids, w_v=cur_ids[cur_ids_val2])

                calc_ids <- calc_ids[(is.na(calc_ids)==F)]

            }

            pre_rtn_datf <- cur_datf[cur_ids_val2, 
                (cur_col - substrct)]

            pre_rtn_datf <- pre_rtn_datf[calc_ids]

            pre_rtn_datf <- incr_fillr(inpt_v=unique(c(cur_ids_val, length(lst_ids))), wrk_v=c("NA", pre_rtn_datf), 
                                     default_val=d_val)

            pre_rtn_datf <- appndr(inpt_v=pre_rtn_datf, val=d_val, hmn=(length(lst_ids) - (length(pre_rtn_datf) - 1)), strt="max")

            rtn_datf <- cbind(rtn_datf, pre_rtn_datf[2:length(pre_rtn_datf)])

            colnames(rtn_datf)[length(colnames(rtn_datf))] <- cl_nms[cur_col]

        }

        colnames(rtn_datf)[1] <- "ids"

        return(rtn_datf)
        
    }

}

#' equalizer_v
#'
#' Takes a vector of character as an input and returns a vector with the elements at the same size. The size can be chosen via depth parameter.
#'
#' @param inpt_v is the input vector containing all the characters
#' @param depth is the depth parameter, defaults to "max" which means that it is equal to the character number of the element(s) in inpt_v that has the most 
#' @param default_val is the default value that will be added to the output characters if those has an inferior length (characters) than the value of depth 
#' @examples 
#'
#'  print(equalizer_v(inpt_v=c("aa", "zzz", "q"), depth=2))
#'
#'  #[1] "aa" "zz" "q?"
#'
#'  print(equalizer_v(inpt_v=c("aa", "zzz", "q"), depth=12))
#'
#'  #[1] "aa??????????" "zzz?????????" "q???????????"
#'
#' @export

equalizer_v <- function(inpt_v, depth="max", default_val="?"){

        if (depth == "min"){ 

           depth <- nchar(inpt_v[1]) 

            if (length(inpt_v) > 1){

                    for (ptrn in inpt_v[2:length(inpt_v)]){

                        if (nchar(ptrn) < depth){ depth <- nchar(ptrn) }

                    }

            }

        }

        if (depth == "max"){ 

           depth <- nchar(inpt_v[1]) 

            if (length(inpt_v) > 1){

                    for (ptrn in inpt_v[2:length(inpt_v)]){

                        if (nchar(ptrn) > depth){ depth <- nchar(ptrn) }

                    }

            }

        }

        rtn_v <- c()

        for (ptrn in inpt_v){

                if (nchar(ptrn) < depth){ 

                        for (i in 1:(depth-nchar(ptrn))){ ptrn <- paste0(ptrn, default_val) }
                       
                        rtn_v <- c(rtn_v, ptrn)

                }else{

                        rtn_v <- c(rtn_v, paste(unlist(strsplit(x=ptrn, split=""))[1:depth], collapse=""))

                }

        }


        return(rtn_v)

}

#' rearangr_v
#'
#' Reanranges a vector "w_v" according to another vector "inpt_v". inpt_v contains a sequence of number. inpt_v and w_v have the same size and their indexes are related. The output will be a vector containing all the elements of w_v rearanges in descending or asending order according to inpt_v
#'
#' @param inpt_v is the vector that contains the sequance of number
#' @param w_v is the vector containing the elements related to inpt_v
#' @param how is the way the elements of w_v will be outputed according to if inpt_v will be sorted ascendigly or descendingly
#' @examples 
#'
#' print(rearangr_v(inpt_v=c(23, 21, 56), w_v=c("oui", "peut", "non"), how="decreasing"))
#'
#' #[1] "non"  "oui"  "peut"
#'
#' @export

rearangr_v <- function(inpt_v, w_v, how="increasing"){

    rtn_v <- c()

    pre_v <- inpt_v

    if (how == "increasing"){

        inpt_v <- sort(inpt_v)

    }else {

        inpt_v <- sort(inpt_v, decreasing=TRUE)

    }

    for (el in inpt_v){

        idx <- match(el, pre_v)

        rtn_v <- c(rtn_v, w_v[idx])

        pre_v[idx] <- NA

    }

    return(rtn_v)

}

#' clusterizer_v
#' 
#' Allow to output clusters of elements. Takes as input a vector "inpt_v" containing a sequence of number. Can also take another vector "w_v" that has the same size of inpt_v because its elements are related to it. The way the clusters are made is related to an accuracy value which is "c_val". It means that if the difference between the values associated to 2 elements is superior to c_val, these two elements are in distinct clusters. The second element of the outputed list is the begin and end value of each cluster.
#' 
#' @param inpt_v is the vector containing the sequence of number
#' @param w_v is the vector containing the elements related to inpt_v, defaults to NA
#' @param c_val is the accuracy of the clusterization
#' 
#' @examples
#'  print(clusterizer_v(inpt_v=sample.int(20, 26, replace=TRUE), w_v=NA, c_val=0.9))
#' 
#' # [[1]]
#' #[[1]][[1]]
#' #[1] 1
#' #
#' #[[1]][[2]]
#' #[1] 2
#' #
#' #[[1]][[3]]
#' #[1] 3
#' #
#' #[[1]][[4]]
#' #[1] 4
#' #
#' #[[1]][[5]]
#' #[1] 5 5
#' #
#' #[[1]][[6]]
#' #[1] 6 6 6 6
#' #
#' #[[1]][[7]]
#' #[1] 7 7 7
#' #
#' #[[1]][[8]]
#' #[1] 8 8 8
#' #
#' #[[1]][[9]]
#' #[1] 9
#' #
#' #[[1]][[10]]
#' #[1] 10
#' #
#' #[[1]][[11]]
#' #[1] 12
#' #
#' #[[1]][[12]]
#' #[1] 13 13 13
#' #
#' #[[1]][[13]]
#' #[1] 18 18 18
#' #
#' #[[1]][[14]]
#' #[1] 20
#' #
#' #
#' #[[2]]
#' # [1] "1"  "1"  "-"  "2"  "2"  "-"  "3"  "3"  "-"  "4"  "4"  "-"  "5"  "5"  "-" 
#' #[16] "6"  "6"  "-"  "7"  "7"  "-"  "8"  "8"  "-"  "9"  "9"  "-"  "10" "10" "-" 
#' #[31] "12" "12" "-"  "13" "13" "-"  "18" "18" "-"  "20" "20"
#' 
#' print(clusterizer_v(inpt_v=sample.int(40, 26, replace=TRUE), w_v=letters, c_val=0.29))
#'
#' #[[1]]
#' #[[1]][[1]]
#' #[1] "a"
#' #
#' #[[1]][[2]]
#' #[1] "b"
#' #
#' #[[1]][[3]]
#' #[1] "c" "d"
#' #
#' #[[1]][[4]]
#' #[1] "e" "f"
#' #
#' #[[1]][[5]]
#' #[1] "g" "h" "i" "j"
#' #
#' #[[1]][[6]]
#' #[1] "k"
#' #
#' #[[1]][[7]]
#' #[1] "l"
#' #
#' #[[1]][[8]]
#' #[1] "m" "n"
#' #
#' #[[1]][[9]]
#' #[1] "o"
#' #
#' #[[1]][[10]]
#' #[1] "p"
#' #
#' #[[1]][[11]]
#' #[1] "q" "r"
#' #
#' #[[1]][[12]]
#' #[1] "s" "t" "u"
#' #
#' #[[1]][[13]]
#' #[1] "v"
#' #
#' #[[1]][[14]]
#' #[1] "w"
#' #
#' #[[1]][[15]]
#' #[1] "x"
#' #
#' #[[1]][[16]]
#' #[1] "y"
#' #
#' #[[1]][[17]]
#' #[1] "z"
#' #
#' #
#' #[[2]]
#' # [1] "13" "13" "-"  "14" "14" "-"  "15" "15" "-"  "16" "16" "-"  "17" "17" "-" 
#' #[16] "19" "19" "-"  "21" "21" "-"  "22" "22" "-"  "23" "23" "-"  "25" "25" "-" 
#' #[31] "27" "27" "-"  "29" "29" "-"  "30" "30" "-"  "31" "31" "-"  "34" "34" "-" 
#' #[46] "35" "35" "-"  "37" "37"
#'
#' @export

clusterizer_v <- function(inpt_v, w_v=NA, c_val){

    rearangr_v <- function(inpt_v, w_v, how="increasing"){

            rtn_v <- c()

            pre_v <- inpt_v

            if (how == "increasing"){

                inpt_v <- sort(inpt_v)

            }else {

                inpt_v <- sort(inpt_v, decreasing=TRUE)

            }

            for (el in inpt_v){

                idx <- match(el, pre_v)

                rtn_v <- c(rtn_v, w_v[idx])

                pre_v[idx] <- NA

            }

            return(rtn_v)

    }

    inpt_v <- sort(inpt_v)

    idx_v <- c()

    rtn_l <- list() 

    if (all(is.na(w_v)) == FALSE){

            w_v <- rearangr_v(inpt_v=inpt_v, w_v=w_v)

            pre_v <- c(w_v[1])

            pre_idx <- inpt_v[1]

            if (length(inpt_v) > 1){

                    for (i in 2:length(inpt_v)){

                        if ((inpt_v[i] - inpt_v[i - 1]) > c_val){

                                rtn_l <- append(rtn_l, list(pre_v))

                                idx_v <- c(idx_v, "-", pre_idx, inpt_v[i-1])

                                pre_idx <- inpt_v[i]

                                pre_v <- c()

                        }

                        pre_v <- c(pre_v, w_v[i])

                    }

                    rtn_l <- append(rtn_l, list(pre_v))

                    idx_v <- c(idx_v, "-", pre_idx, inpt_v[length(inpt_v)])

            }else{

                rtn_l <- append(rtn_l, pre_v[1])

            }

    }else{

            pre_v <- c(inpt_v[1])

            pre_idx <- inpt_v[1]

            if (length(inpt_v) > 1){

                    for (i in 2:length(inpt_v)){

                        if ((inpt_v[i] - inpt_v[i - 1]) > c_val){

                                rtn_l <- append(rtn_l, list(pre_v))

                                idx_v <- c(idx_v, "-", pre_idx, inpt_v[i-1])

                                pre_idx <- inpt_v[i]

                                pre_v <- c()

                        }
                                
                        pre_v <- c(pre_v, inpt_v[i])

                    }

                    rtn_l <- append(rtn_l, list(pre_v))

                    idx_v <- c(idx_v, "-", pre_idx, inpt_v[length(inpt_v)])

            }else{

                rtn_l <- append(rtn_l, pre_v[1])

            }

    }

    return(list(rtn_l, idx_v[2:length(idx_v)]))

}

#' closer_ptrn_adv
#' 
#' Allow to find how patterns are far or near between each other relatively to a vector containing characters at each index ("base_v"). The function gets the sum of the indexes of each pattern letter relatively to the characters in base_v. So each pattern can be compared.
#' 
#' @param inpt_v is the input vector containing all the patterns to be analyzed
#' @param res is a parameter controling the result. If set to "raw_stat", each word in inpt_v will come with its score (indexes of its letters relatively to base_v). If set to something else, so "c_word" parameter must be filled.
#' @param c_word is a pattern from which the nearest to the farest pattern in inpt_v will be compared 
#' @param base_v is the vector from which all pattern get its result (letters indexes for each pattern relatively to base_v), defaults to c("default_val", letters). "default_val" is another parameter and letters is all the western alphabetic letters in a vector
#' @param default_val is the value that will be added to all patterns that do not equal the length of the longest pattern in inpt_v. Those get this value added to make all patterns equal in length so they can be compared, defaults to "?"
#' 
#' @examples
#'
#' print(closer_ptrn_adv(inpt_v=c("aurevoir", "bonnour", "nonnour", "fin", "mois", "bonjour"), 
#'      res="word", c_word="bonjour"))
#' 
#'#[[1]]
#'#[1]  1  5 15 17 38 65
#'#
#'#[[2]]
#'#[1] "bonjour"  "bonnour"  "aurevoir" "nonnour"  "mois"     "fin"     
#' 
#' print(closer_ptrn_adv(inpt_v=c("aurevoir", "bonnour", "nonnour", "fin", "mois")))
#' 
#'#[[1]]
#'#[1] 117 107 119  37  64
#'#
#'#[[2]]
#'#[1] "aurevoir" "bonnour"  "nonnour"  "fin"      "mois"    
#'
#' @export

closer_ptrn_adv <- function(inpt_v, res="raw_stat", default_val="?", base_v=c(default_val, letters), c_word=NA){

        chr_removr <- function(inpt_v, ptrn_v){

                rm_fun <- function(x){

                    rm_ids <- c()

                    cur_chr <- unlist(strsplit(x, split=""))

                    for (ptrn in ptrn_v){

                            rm_ids <- c(rm_ids, which(cur_chr == ptrn))

                    }

                    if (length(rm_ids) == 0){

                            return(x)

                    }else {

                            cur_chr <- cur_chr[-rm_ids]

                            return(paste(cur_chr, collapse=""))

                    }

                }
              
                rtn_v <- mapply(function(x) return(rm_fun(x)), inpt_v) 

                return(as.vector(rtn_v))

        }

        rearangr_v <- function(inpt_v, w_v, how="increasing"){

            rtn_v <- c()

            pre_v <- inpt_v

            if (how == "increasing"){

                inpt_v <- sort(inpt_v)

            }else {

                inpt_v <- sort(inpt_v, decreasing=TRUE)

            }

            for (el in inpt_v){

                idx <- match(el, pre_v)

                rtn_v <- c(rtn_v, w_v[idx])

                pre_v[idx] <- NA

            }

            return(rtn_v)

        }

        equalizer_v <- function(inpt_v, depth="max", default_val="?"){

                if (depth == "min"){ 

                   depth <- nchar(inpt_v[1]) 

                    if (length(inpt_v) > 1){

                            for (ptrn in inpt_v[2:length(inpt_v)]){

                                if (nchar(ptrn) < depth){ depth <- nchar(ptrn) }

                            }

                    }

                }

                if (depth == "max"){ 

                   depth <- nchar(inpt_v[1]) 

                    if (length(inpt_v) > 1){

                            for (ptrn in inpt_v[2:length(inpt_v)]){

                                if (nchar(ptrn) > depth){ depth <- nchar(ptrn) }

                            }

                    }

                }

                rtn_v <- c()

                for (ptrn in inpt_v){

                        if (nchar(ptrn) < depth){ 

                                for (i in 1:(depth-nchar(ptrn))){ ptrn <- paste0(ptrn, default_val) }
                               
                                rtn_v <- c(rtn_v, ptrn)

                        }else{

                                rtn_v <- c(rtn_v, paste(unlist(strsplit(x=ptrn, split=""))[1:depth], collapse=""))

                        }

                }


                return(rtn_v)

    }

    inpt_v <- equalizer_v(inpt_v=inpt_v, default_val=default_val)

    ref_v <- base_v

    res_v <- c()

    for (ptrn in inpt_v){

        cur_delta = 0

        ptrn <- unlist(strsplit(ptrn, split=""))

        for (ltr in ptrn){

            cur_delta = cur_delta + match(ltr, base_v)

        }

        res_v <- c(res_v, cur_delta)

    }

    if (res == "raw_stat"){

         return(list(res_v, chr_removr(inpt_v=inpt_v, ptrn_v=c(default_val))))

    }else if (is.na(c_word) == FALSE){

        cur_delta = 0

        for (ltr in unlist(strsplit(c_word, split=""))){

            cur_delta = cur_delta + match(ltr, base_v)

        }

        cur_delta <- abs(res_v - cur_delta)

        inpt_v <- rearangr_v(inpt_v=cur_delta, w_v=inpt_v, how="increasing")

        return(list(sort(cur_delta, decreasing=FALSE), chr_removr(inpt_v=inpt_v, ptrn_v=c(default_val))))

    }

}

#' unique_ltr_from_v 
#'
#' Returns the unique characters contained in all the elements from an input vector "inpt_v"
#'
#' @param inpt_v is the input vector containing all the elements
#' @param keep_v is the vector containing all the characters that the elements in inpt_v may contain
#'
#' @examples
#'
#' print(unique_ltr_from_v(inpt_v=c("bonjour", "lpoerc", "nonnour", "bonnour", "nonjour", "aurevoir")))
#'
#' #[1] "b" "o" "n" "j" "u" "r" "l" "p" "e" "c" "a" "v" "i" 
#'
#' @export

unique_ltr_from_v <- function(inpt_v, keep_v=c("?", "!", ":", "&", ",", ".", letters)){

    cnt = 1

    add_v <- c(1)

    rtn_v <- c()

    while (length(keep_v) > 0 & cnt <= length(inpt_v)){

            add_v <- as.vector(mapply(function(x) return(match(x, keep_v)), unlist(strsplit(inpt_v[cnt], split=""))))

            if (all(is.na(add_v)) == FALSE){

                add_v <- add_v[(is.na(add_v)==FALSE)]

                rtn_v <- c(rtn_v, keep_v[unique(add_v)])

                keep_v <- keep_v[-add_v]

            }

            cnt = cnt + 1

    }

    return(rtn_v)

}

#' closer_ptrn
#'
#' Take a vector of patterns as input and output each chosen word with their closest patterns from chosen patterns. 
#' 
#' @param inpt_v is the input vector containing all the patterns
#' @param excl_v is the vector containing all the patterns from inpt_v to exclude for comparing them to others patterns. If this parameter is filled, so "rtn_v" must be empty.
#' @param rtn_v is the vector containing all the patterns from inpt_v to keep for comparing them to others patterns. If this parameter is filled, so "rtn_v" must be empty.
#' @param sub_excl_v is the vector containing all the patterns from inpt_v to exclude for using them to compare to another pattern. If this parameter is filled, so "sub_rtn_v" must be empty.
#' @param sub_rtn_v is the vector containing all the patterns from inpt_v to retain for using them to compare to another pattern. If this parameter is filled, so "sub_excl_v" must be empty.
#' @param base_v must contain all the characters that the patterns are succeptible to contain, defaults to c("?", letters). "?" is necessary because it is internaly the default value added to each element that does not have a suffiient length compared to the longest pattern in inpt_v. If set to NA, the function will find by itself the elements to be filled with but it may takes an extra time 
#' @examples
#' 
#' print(closer_ptrn(inpt_v=c("bonjour", "lpoerc", "nonnour", "bonnour", "nonjour", "aurevoir")))
#'
#'#[[1]]
#'#[1] "bonjour"
#'#
#'#[[2]]
#'#[1] "lpoerc"   "nonnour"  "bonnour"  "nonjour"  "aurevoir"
#'#
#'#[[3]]
#'#[1] 1 1 2 7 8
#'#
#'#[[4]]
#'#[1] "lpoerc"
#'#
#'#[[5]]
#'#[1] "bonjour"  "nonnour"  "bonnour"  "nonjour"  "aurevoir"
#'#
#'#[[6]]
#'#[1] 7 7 7 7 7
#'#
#'#[[7]]
#'#[1] "nonnour"
#'#
#'#[[8]]
#'#[1] "bonjour"  "lpoerc"   "bonnour"  "nonjour"  "aurevoir"
#'#
#'#[[9]]
#'#[1] 1 1 2 7 8
#'#
#'#[[10]]
#'#[1] "bonnour"
#'#
#'#[[11]]
#'#[1] "bonjour"  "lpoerc"   "nonnour"  "nonjour"  "aurevoir"
#'#
#'#[[12]]
#'#[1] 1 1 2 7 8
#'#
#'#[[13]]
#'#[1] "nonjour"
#'#
#'#[[14]]
#'#[1] "bonjour"  "lpoerc"   "nonnour"  "bonnour"  "aurevoir"
#'#
#'#[[15]]
#'#[1] 1 1 2 7 8
#'#
#'#[[16]]
#'#[1] "aurevoir"
#'#
#'#[[17]]
#'#[1] "bonjour" "lpoerc"  "nonnour" "bonnour" "nonjour"
#'#
#'#[[18]]
#'#[1] 7 8 8 8 8
#' 
#' print(closer_ptrn(inpt_v=c("bonjour", "lpoerc", "nonnour", "bonnour", "nonjour", "aurevoir"), 
#' excl_v=c("nonnour", "nonjour"),
#'                  sub_excl_v=c("nonnour")))
#'
#'#[1] 3 5
#'#[[1]]
#'#[1] "bonjour"
#'#
#'#[[2]]
#'#[1] "lpoerc"   "bonnour"  "nonjour"  "aurevoir"
#'#
#'#[[3]]
#'#[1] 1 1 7 8
#'#
#'#[[4]]
#'#[1] "lpoerc"
#'#
#'#[[5]]
#'#[1] "bonjour"  "bonnour"  "nonjour"  "aurevoir"
#'#
#'#[[6]]
#'#[1] 7 7 7 7
#'#
#'#[[7]]
#'#[1] "bonnour"
#'#
#'#[[8]]
#'#[1] "bonjour"  "lpoerc"   "bonnour"  "nonjour"  "aurevoir"
#'#
#'#[[9]]
#'#[1] 0 1 2 7 8
#'#
#'#[[10]]
#'#[1] "aurevoir"
#'#
#'#[[11]]
#'#[1] "bonjour"  "lpoerc"   "nonjour"  "aurevoir"
#'#
#'#[[12]]
#'#[1] 0 7 8 8
#'
#' @export

closer_ptrn <- function(inpt_v, base_v=c("?", letters), excl_v=c(), rtn_v=c(), 
                        sub_excl_v=c(), sub_rtn_v=c()){

        unique_ltr_from_v <- function(inpt_v, keep_v=c("?", "!", ":", "&", ",", ".", letters)){

            cnt = 1

            add_v <- c(1)

            rtn_v <- c()

            while (length(keep_v) > 0 & cnt <= length(inpt_v)){

                    add_v <- as.vector(mapply(function(x) return(match(x, keep_v)), unlist(strsplit(inpt_v[cnt], split=""))))

                    if (all(is.na(add_v)) == FALSE){

                        add_v <- add_v[(is.na(add_v)==FALSE)]

                        rtn_v <- c(rtn_v, keep_v[unique(add_v)])

                        keep_v <- keep_v[-add_v]

                    }

                    cnt = cnt + 1

            }

            return(rtn_v)

        }

        default_val <- "?"

        if (all(is.na(base_v))){

            base_v <- unique_ltr_from_v(inpt_v=inpt_v)

        }

        if (("?" %in% base_v) == FALSE) { base_v <- c(base_v, "?") }

        rearangr_v <- function(inpt_v, w_v, how="increasing"){

            rtn_v <- c()

            pre_v <- inpt_v

            if (how == "increasing"){

                inpt_v <- sort(inpt_v)

            }else {

                inpt_v <- sort(inpt_v, decreasing=TRUE)

            }

            for (el in inpt_v){

                idx <- match(el, pre_v)

                rtn_v <- c(rtn_v, w_v[idx])

                pre_v[idx] <- NA

            }

            return(rtn_v)

        }

        chr_removr <- function(inpt_v, ptrn_v){

                rm_fun <- function(x){

                    rm_ids <- c()

                    cur_chr <- unlist(strsplit(x, split=""))

                    for (ptrn in ptrn_v){

                            rm_ids <- c(rm_ids, which(cur_chr == ptrn))

                    }

                    if (length(rm_ids) == 0){

                            return(x)

                    }else {

                            cur_chr <- cur_chr[-rm_ids]

                            return(paste(cur_chr, collapse=""))

                    }

                }
              
                rtn_v <- mapply(function(x) return(rm_fun(x)), inpt_v) 

                return(as.vector(rtn_v))

        }

        equalizer_v <- function(inpt_v, depth="max", default_val="?"){

                if (depth == "min"){ 

                   depth <- nchar(inpt_v[1]) 

                    if (length(inpt_v) > 1){

                            for (ptrn in inpt_v[2:length(inpt_v)]){

                                if (nchar(ptrn) < depth){ depth <- nchar(ptrn) }

                            }

                    }

                }

                if (depth == "max"){ 

                   depth <- nchar(inpt_v[1]) 

                    if (length(inpt_v) > 1){

                            for (ptrn in inpt_v[2:length(inpt_v)]){

                                if (nchar(ptrn) > depth){ depth <- nchar(ptrn) }

                            }

                    }

                }

                rtn_v <- c()

                for (ptrn in inpt_v){

                        if (nchar(ptrn) < depth){ 

                                for (i in 1:(depth-nchar(ptrn))){ ptrn <- paste0(ptrn, default_val) }
                               
                                rtn_v <- c(rtn_v, ptrn)

                        }else{

                                rtn_v <- c(rtn_v, paste(unlist(strsplit(x=ptrn, split=""))[1:depth], collapse=""))

                        }

                }


                return(rtn_v)

    }

    inpt_v <- equalizer_v(inpt_v=inpt_v, default_val=default_val)

    ref_v <- base_v

    res_l <- list()

    for (ptrn in inpt_v){

        cur_delta = c()

        ptrn <- unlist(strsplit(ptrn, split=""))

        for (ltr in ptrn){

            cur_delta = c(cur_delta, match(ltr, base_v))

        }

        res_l <- append(res_l, list(cur_delta))

    }

    rtn_l <- list()

    rmids <- c()

    sub_rmids <- c()

    if (length(excl_v) > 0){

        rmids <- as.vector(mapply(function(x) return(match(x, chr_removr(inpt_v=inpt_v, ptrn_v=c(default_val)))), excl_v))     

    }

    if (length(rtn_v) > 0){

        rmids <- c(1:length(inpt_v))[-as.vector(mapply(function(x) return(match(x, chr_removr(inpt_v=inpt_v, ptrn_v=c(default_val)))), rtn_v))]

    }

    if (length(sub_excl_v) > 0){

        sub_rmids <-  as.vector(mapply(function(x) return(match(x, chr_removr(inpt_v=inpt_v, ptrn_v=c(default_val)))), sub_excl_v))     

    }

    if (length(sub_rtn_v) > 0){

        sub_rmids <- c(1:length(inpt_v))[-as.vector(mapply(function(x) return(match(x, c(inpt_v=inpt_v, ptrn_v=c(default_val)))), sub_rtn_v))]

    }

    if (length(rmids) > 0){

        inpt_v2 <- inpt_v[-rmids] 

        res_l2 <- res_l[-rmids]

    }else{

        inpt_v2 <- inpt_v

        res_l2 <- res_l

    }

    for (f_ptrn in 1:length(res_l2)){

            pre_l <- list(chr_removr(inpt_v=inpt_v2[f_ptrn], ptrn_v=default_val))

            pre_v <- c()

            f_ptrn_v <- unlist(res_l2[f_ptrn])

            for (cur_ptrn in res_l[-c(sub_rmids, (match(inpt_v[f_ptrn], inpt_v)))]){

                    diff_val = 0

                    for (pos in 1:length(cur_ptrn)){

                        if (cur_ptrn[pos] != f_ptrn_v[pos]){

                            diff_val = diff_val + 1 

                        }

                    }

                    pre_v <- c(pre_v, diff_val)

            }

            pre_ptrn <- chr_removr(inpt_v=inpt_v[-c(sub_rmids, 
                                        (match(inpt_v[f_ptrn], inpt_v)))], ptrn_v=c(default_val))

            pre_l <- append(x=pre_l, values=list(pre_ptrn))

            pre_l <- append(x=pre_l, values=list(sort(pre_v)))

            rtn_l <- append(x=rtn_l, values=pre_l)

    }
  
    return(rtn_l)

}

#' cut_v
#'
#' Allow to convert a vector to a dataframe according to a separator.
#' 
#' @param inpt_v is the input vector
#' @param sep_ is the separator of the elements in inpt_v, defaults to ""
#' 
#' @examples
#'
#' print(cut_v(inpt_v=c("oui", "non", "oui", "non")))
#' 
#' #    X.o. X.u. X.i.
#' #oui "o"  "u"  "i" 
#' #non "n"  "o"  "n" 
#' #oui "o"  "u"  "i" 
#' #non "n"  "o"  "n" 
#' 
#' print(cut_v(inpt_v=c("ou-i", "n-on", "ou-i", "n-on"), sep_="-"))
#' 
#' #     X.ou. X.i.
#' #ou-i "ou"  "i" 
#' #n-on "n"   "on"
#' #ou-i "ou"  "i" 
#' #n-on "n"   "on"
#' 
#' @export

cut_v <- function(inpt_v, sep_=""){

        rtn_datf <- data.frame(matrix(data=NA, nrow=0, ncol=length(unlist(strsplit(inpt_v[1], split=sep_)))))

        for (el in inpt_v){ rtn_datf <- rbind(rtn_datf, unlist(strsplit(el, split=sep_))) }

        return(rtn_datf)

}

#' wider_datf
#'
#' Takes a dataframe as an input and the column to split according to a seprator.
#'
#' @param inpt_datf is the input dataframe
#' @param col_to_splt is a vector containing the number or the colnames of the columns to split according to a separator
#' @param sep_ is the separator of the elements to split to new columns in the input dataframe 
#' @examples
#'
#' datf1 <- data.frame(c(1:5), c("o-y", "hj-yy", "er-y", "k-ll", "ooo-mm"), c(5:1))
#' 
#' datf2 <- data.frame("col1"=c(1:5), "col2"=c("o-y", "hj-yy", "er-y", "k-ll", "ooo-mm"))
#'  
#' print(wider_datf(inpt_datf=datf1, col_to_splt=c(2), sep_="-"))
#'
#' #       pre_datf X.o.  X.y.  
#' #o-y    1      "o"   "y"  5
#' #hj-yy  2      "hj"  "yy" 4
#' #er-y   3      "er"  "y"  3
#' #k-ll   4      "k"   "ll" 2
#' #ooo-mm 5      "ooo" "mm" 1
#'
#' print(wider_datf(inpt_datf=datf2, col_to_splt=c("col2"), sep_="-"))
#' 
#' #       pre_datf X.o.  X.y.
#' #o-y    1      "o"   "y" 
#' #hj-yy  2      "hj"  "yy"
#' #er-y   3      "er"  "y" 
#' #k-ll   4      "k"   "ll"
#' #ooo-mm 5      "ooo" "mm"
#'
#' @export

wider_datf <- function(inpt_datf, col_to_splt=c(), sep_="-"){

        cut_v <- function(inpt_v, sep_=""){

                rtn_datf <- data.frame(matrix(data=NA, nrow=0, ncol=length(unlist(strsplit(inpt_v[1], split=sep_)))))

                rtn_datf <- t(mapply(function(x) return(rbind(rtn_datf, unlist(strsplit(x, split=sep_)))), inpt_v))

                return(rtn_datf)

        }

        if (typeof(col_to_splt) == "character"){

            for (i in 1:length(col_to_splt)){

               col_to_splt[i] <- match(col_to_splt[i], colnames(inpt_datf))

            }

            col_to_splt <- as.numeric(col_to_splt)

        }

        for (cl in col_to_splt){

            pre_datf <- inpt_datf[,1:(cl-1)]

            cur_datf <- cut_v(inpt_v=inpt_datf[, cl], sep_=sep_) 

            if (cl < ncol(inpt_datf)){

                    w_datf <- cbind(pre_datf, cur_datf, inpt_datf[, ((cl+1):ncol(inpt_datf))])

            }else{

                    w_datf <- cbind(pre_datf, cur_datf)

            }

        }

    return(w_datf)

}

#' colins_datf
#'
#' Allow to insert vectors into a dataframe.
#' 
#' @param inpt_datf is the dataframe where vectors will be inserted
#' @param target_col is a list containing all the vectors to be inserted
#' @param target_pos is a list containing the vectors made of the columns names or numbers where the associated vectors from target_col will be inserted after
#'
#' @examples
#'
#' datf1 <- data.frame("frst_col"=c(1:5), "scd_col"=c(5:1))
#' 
#' print(colins_datf(inpt_datf=datf1, target_col=list(c("oui", "oui", "oui", "non", "non"), 
#'              c("u", "z", "z", "z", "u")), 
#'                 target_pos=list(c("frst_col", "scd_col"), c("scd_col"))))
#' 
#' #  frst_col cur_col scd_col cur_col.1 cur_col
#' #1        1     oui       5       oui       u
#' #2        2     oui       4       oui       z
#' #3        3     oui       3       oui       z
#' #4        4     non       2       non       z
#' #5        5     non       1       non       u
#'
#' print(colins_datf(inpt_datf=datf1, target_col=list(c("oui", "oui", "oui", "non", "non"), 
#'              c("u", "z", "z", "z", "u")), 
#'                 target_pos=list(c(1, 2), c("frst_col"))))
#' 
#' #  frst_col cur_col scd_col cur_col cur_col
#' #1        1     oui       5       u     oui
#' #2        2     oui       4       z     oui
#' #3        3     oui       3       z     oui
#' #4        4     non       2       z     non
#' #5        5     non       1       u     non
#'
#' @export

colins_datf <- function(inpt_datf, target_col=list(), target_pos=list()){

    cl_nms <- colnames(inpt_datf)

    for (id_vec in 1:length(target_pos)){

            vec <- unlist(target_pos[id_vec])

            if (typeof(vec) == "character"){

                    pre_v <- c()

                    for (el in vec){

                        pre_v <- c(pre_v, match(el, cl_nms))

                    }

                    target_pos <- append(x=target_pos, values=list(pre_v), after=id_vec)

                    target_pos <- target_pos[-id_vec]

            }

    }

    for (cl in 1:length(target_col)){

        cur_col <- unlist(target_col[cl])

        cur_pos_v <- unlist(target_pos[cl])

        for (pos in 1:length(cur_pos_v)){

            idx <- cur_pos_v[pos]

            if (idx == 0){

                inpt_datf <- cbind(cur_col, inpt_datf[(idx+1):ncol(inpt_datf)])

            }else if (idx < ncol(inpt_datf)){

                inpt_datf <- cbind(inpt_datf[1:idx], cur_col, inpt_datf[(idx+1):ncol(inpt_datf)])

            }else{

                inpt_datf <- cbind(inpt_datf[1:idx], cur_col)

            }

            if (pos < length(cur_pos_v)){

                cur_pos_v[(pos+1):length(cur_pos_v)] = cur_pos_v[(pos+1):length(cur_pos_v)] + 1 
         
            }

            if (cl < length(target_pos)){

                    for (i in (cl+1):length(target_pos)){

                        target_pos <- append(x=target_pos, values=(unlist(target_pos[i])+1), after=i)

                        target_pos <- target_pos[-i]
                    
                    } 

            }

        }

    }

  return(inpt_datf)

}

#' id_keepr
#'
#' Allow to get the original indexes after multiple equality comparaison according to the original number of row
#'
#' @param inpt_datf is the input dataframe
#' @param col_v is the vector containing the column numbers or names to be compared to their respective elements in "el_v"
#' @param el_v is a vector containing the elements that may be contained in their respective column described in "col_v" 
#' @param rstr_l is a list containing the vector composed of the indexes of the elements chosen for each comparison. If the length of the list is inferior to the lenght of comparisons, so the last vector of rstr_l will be the same as the last one to fill make rstr_l equal in term of length to col_v and el_v
#' @examples
#' 
#' datf1 <- data.frame(c("oui", "oui", "oui", "non", "oui"), 
#'      c("opui", "op", "op", "zez", "zez"), c(5:1), c(1:5))
#' 
#' print(id_keepr(inpt_datf=datf1, col_v=c(1, 2), el_v=c("oui", "op")))
#'
#' #[1] 2 3
#' 
#' print(id_keepr(inpt_datf=datf1, col_v=c(1, 2), el_v=c("oui", "op"), 
#'      rstr_l=list(c(1:5), c(3, 2, 2, 2, 3))))
#'
#' #[1] 2 3
#'
#' print(id_keepr(inpt_datf=datf1, col_v=c(1, 2), el_v=c("oui", "op"), 
#'      rstr_l=list(c(1:5), c(3))))
#'
#' #[1] 3
#'
#' print(id_keepr(inpt_datf=datf1, col_v=c(1, 2), el_v=c("oui", "op"), rstr_l=list(c(1:5))))
#' 
#' #[1] 2 3
#' 
#' @export

id_keepr <- function(inpt_datf, col_v=c(), el_v=c(), rstr_l=NA){

    rtn_v <- c(1:nrow(inpt_datf))

    if (typeof(col_v) == "character"){

        cl_nms <- colnames(inpt_datf)

        for (i in 1:length(col_v)){

                col_v[i] <- match(col_v[i], cl_nms)

        }

        col_v <- as.numeric(col_v)

    }

    if (all(is.na(rstr_l))){

        for (i in 1:length(col_v)){

            rtn_v <- rtn_v[inpt_datf[rtn_v, col_v[i]] == el_v[i]]  

        }

        return(rtn_v)

    }else if (length(rstr_l) < length(col_v)){

            lst_v <- unlist(rstr_l[length(rstr_l)])

            for (i in (length(rstr_l)+1):length(col_v)){

                rstr_l <- append(x=rstr_l, values=list(lst_v))

            }

    }

    pre_vec <- c()

    fun <- function() { return(c(pre_vec, FALSE)) }

    for (i in 1:length(col_v)){

        pre_vec2 <- mapply(function(x) return(fun()), c(1:length(rtn_v)))

        interst <- intersect(unlist(rstr_l[i]), rtn_v)

        pre_vec2[interst] <- inpt_datf[interst, col_v[i]] == el_v[i]

        rtn_v <- rtn_v[pre_vec2]  

    }

    return(rtn_v)

}

#' better_unique
#'
#' Returns the element that are not unique from the input vector
#'
#' @param inpt_v  is the input vector containing the elements
#' @param occu is a parameter that specifies the occurence of the elements that must be returned, defaults to ">-1-" it means that the function will return all the elements that are present more than one time in inpt_v. The synthax is the following "comparaison_type-actual_value-". The comparaison type may be "==" or ">" or "<". Occu can also be a vector containing all the occurence that must have the elements to be returned.
#' @examples
#'
#' print(better_unique(inpt_v=c("oui", "oui", "non", "non", "peut", "peut1", "non")))
#'
#' #[1] "oui" "non"
#'
#' print(better_unique(inpt_v=c("oui", "oui", "non", "non", "peut", "peut1", "non"), occu="==-2-"))
#'
#' #[1] "oui"
#'
#' print(better_unique(inpt_v=c("oui", "oui", "non", "non", "peut", "peut1", "non"), occu=">-2-"))
#'
#' #[1] "non"
#' 
#' print(better_unique(inpt_v=c("oui", "oui", "non", "non", "peut", "peut1", "non"), occu=c(1, 3)))
#' 
#' #[1] "non"   "peut"  "peut1"
#'
#' print(better_unique(inpt_v = c("a", "b", "c", "c"), occu = "==-1-"))
#' 
#' [1] "a" "b"
#'
#' print(better_unique(inpt_v = c("a", "b", "c", "c"), occu = "<-2-"))
#'
#' [1] "a" "b"
#'
#' @export

better_unique <- function(inpt_v, occu=">-1-"){

   rtn_v <- c()

   if (typeof(occu) == "character"){

           pre_vec <- str_locate(occu, "-(.*?)-")

           occu_v <- unlist(strsplit(occu, split=""))

           max_val <- as.numeric(occu_v[(pre_vec[1]+1):(pre_vec[length(pre_vec)]-1)])

           comp_ <- paste(occu_v[1:(pre_vec[1] - 1)], collapse="")

           if (comp_ == "=="){

                for (el in unique(inpt_v)){ if (sum(inpt_v == el) == max_val) { rtn_v <- c(rtn_v, el) } }

           }

           if (comp_ == ">"){

                for (el in unique(inpt_v)){ if (sum(inpt_v == el) > max_val) { rtn_v <- c(rtn_v, el) } }

           }

           if (comp_ == "<"){

                for (el in unique(inpt_v)){ if (sum(inpt_v == el) < max_val) { rtn_v <- c(rtn_v, el) } }

           }

   }else{

          for (el in unique(inpt_v)){ if (sum(inpt_v == el) %in% occu) { rtn_v <- c(rtn_v, el) } }

   }

   return(rtn_v)

}

#' r_print
#'
#' Allow to print vector elements in one row.
#'
#' @param inpt_v is the input vector
#' @param sep_ is the separator between each elements
#' @param begn is the character put at the beginning of the print
#' @param end is the character put at the end of the print
#' @examples
#'
#' print(r_print(inpt_v=c(1:33)))
#'
#' #[1] "This is  1 and 2 and 3 and 4 and 5 and 6 and 7 and 8 and 9 and 10 and 11 and 12 and 13 
#' #and 14 and 15 and 16 and 17 and 18 and 19 and 20 and 21 and 22 and 23 and 24 and 25 and 26 
#' #and 27 and 28 and 29 and 30 and 31 and 32 and 33 and , voila!"
#'
#' @export

r_print <- function(inpt_v, sep_="and", begn="This is", end=", voila!"){

        rtn_val <- ""

       for (el in inpt_v){ rtn_val <- paste(rtn_val, el, sep_, sep=" ") } 

       return(paste(begn, rtn_val, end, sep=" "))

}

#' str_remove_untl
#'
#' Allow to remove pattern within elements from a vector precisely according to their occurence.
#'
#' @param inpt_v is the input vector
#' @param ptrn_rm_v is a vector containing the patterns to remove
#' @param untl is a list containing the occurence(s) of each pattern to remove in the elements.
#' @param nvr_following_ptrn is a sequel of characters that you are sure is not present in any of the elements in inpt_v
#'
#' @examples
#'
#' vec <- c("45/56-/98mm", "45/56-/98mm", "45/56-/98-mm//")
#' 
#' print(str_remove_untl(inpt_v=vec, ptrn_rm_v=c("-", "/"), untl=list(c("max"), c(1))))
#' 
#' #[1] "4556/98mm"   "4556/98mm"   "4556/98mm//"
#' 
#' print(str_remove_untl(inpt_v=vec, ptrn_rm_v=c("-", "/"), untl=list(c("max"), c(1:2))))
#' 
#' #[1] "455698mm"   "455698mm"   "455698mm//"
#'
#' print(str_remove_untl(inpt_v=vec[1], ptrn_rm_v=c("-", "/"), untl=c("max")))
#'
#' #[1] "455698mm" "455698mm" "455698mm"
#' 
#' @export

str_remove_untl <- function(inpt_v, ptrn_rm_v=c(), untl=list(c(1)), nvr_following_ptrn="NA"){

   rtn_v <- c()

   if (length(untl) < length(ptrn_rm_v)){

           for (i in 1:(length(ptrn_rm_v) - (length(untl)))){

                   untl <- append(x=untl, values=list(unlist(untl[length(untl)])))

           }

   }

   for (el in inpt_v){

        pre_el <- el

        cur_el <- el

        for (ptrn in 1:length(ptrn_rm_v)) {

                cur_el <- str_remove(string=cur_el, pattern=ptrn_rm_v[ptrn])

                if (unlist(untl[ptrn])[1] == "max"){

                        while (cur_el != pre_el){

                                pre_el <- cur_el

                                cur_el <- str_remove(string=cur_el, pattern=ptrn_rm_v[ptrn])

                        }

                }else {

                        cur_untl <- unlist(untl[ptrn])

                        cnt = 1

                        pre_cnt <- 1

                        rm_ids <- c()

                        cur_el_vstr <- cur_el

                        cur_untl <- cur_untl - 1

                        cur_untl <- cur_untl[cur_untl > 0]

                        cnt2 = -1

                        while (cur_el_vstr != pre_el & cnt <= length(cur_untl)){

                                for (i in pre_cnt:cur_untl[cnt]){

                                        rm_id <- str_locate(string=cur_el_vstr, pattern=ptrn_rm_v[ptrn])

                                        pre_el <- cur_el_vstr
                                        
                                        cur_el_vstr <- str_remove(string=cur_el_vstr, pattern=ptrn_rm_v[ptrn])

                                        cnt2 = cnt2 + 1

                                }

                                rm_id <- rm_id + cnt2

                                if (all(is.na(rm_id)) == FALSE){  rm_ids <- c(rm_ids, rm_id[1]:rm_id[2]) }

                                pre_cnt = cur_untl[cnt] + 1

                                cnt = cnt + 1

                        }

                        if (length(rm_ids) > 0){

                                cur_el <- unlist(strsplit(x=cur_el, split=""))[-rm_ids]

                                cur_el <- paste(cur_el, collapse="")

                        }

                }

        }

        rtn_v <- c(rtn_v, cur_el)

   }

   return(rtn_v)

}

#' regroupr
#'
#' Allow to sort data like "c(X1/Y1/Z1, X2/Y1/Z2, ...)" to what you want. For example it can be to "c(X1/Y1/21, X1/Y1/Z2, ...)"
#'
#' @param inpt_v is the input vector containing all the data you want to sort in a specific way. All the sub-elements should be separated by a unique separator such as "-" or "/"
#' @param sep_ is the unique separator separating the sub-elements in each elements of inpt_v
#' @param order is a vector describing the way the elements should be sorted. For example if you want this dataset  "c(X1/Y1/Z1, X2/Y1/Z2, ...)" to be sorted by the last element you should have order=c(3:1), for example, and it should returns something like this c(X1/Y1/Z1, X2/Y1/Z1, X1/Y2/Z1, ...) assuming you have only two values for X. 
#' @param l_order is a list containing the vectors of values you want to order first for each sub-elements
#' @examples 
#'
#' vec <- multitud(l=list(c("a", "b"), c("1", "2"), c("A", "Z", "E"), c("Q", "F")), sep_="/")
#'
#' print(vec)
#' 
#' # [1] "a/1/A/Q" "b/1/A/Q" "a/2/A/Q" "b/2/A/Q" "a/1/Z/Q" "b/1/Z/Q" "a/2/Z/Q"
#' # [8] "b/2/Z/Q" "a/1/E/Q" "b/1/E/Q" "a/2/E/Q" "b/2/E/Q" "a/1/A/F" "b/1/A/F"
#' #[15] "a/2/A/F" "b/2/A/F" "a/1/Z/F" "b/1/Z/F" "a/2/Z/F" "b/2/Z/F" "a/1/E/F"
#' #[22] "b/1/E/F" "a/2/E/F" "b/2/E/F"
#'
#' print(regroupr(inpt_v=vec, sep_="/"))
#'
#' # [1] "a/1/1/1"   "a/1/2/2"   "a/1/3/3"   "a/1/4/4"   "a/1/5/5"   "a/1/6/6"  
#' # [7] "a/2/7/7"   "a/2/8/8"   "a/2/9/9"   "a/2/10/10" "a/2/11/11" "a/2/12/12"
#' #[13] "b/1/13/13" "b/1/14/14" "b/1/15/15" "b/1/16/16" "b/1/17/17" "b/1/18/18"
#' #[19] "b/2/19/19" "b/2/20/20" "b/2/21/21" "b/2/22/22" "b/2/23/23" "b/2/24/24"
#'
#'  vec <- vec[-2]
#'
#'  print(regroupr(inpt_v=vec, sep_="/"))
#'
#' # [1] "a/1/1/1"   "a/1/2/2"   "a/1/3/3"   "a/1/4/4"   "a/1/5/5"   "a/1/6/6"  
#' # [7] "a/2/7/7"   "a/2/8/8"   "a/2/9/9"   "a/2/10/10" "a/2/11/11" "a/2/12/12"
#' #[13] "b/1/13/13" "b/1/14/14" "b/1/15/15" "b/1/16/16" "b/1/17/17" "b/2/18/18"
#' #[19] "b/2/19/19" "b/2/20/20" "b/2/21/21" "b/2/22/22" "b/2/23/23"
#'
#' print(regroupr(inpt_v=vec, sep_="/", order=c(4:1)))
#'
#' #[1] "1/1/A/Q"   "2/2/A/Q"   "3/3/A/Q"   "4/4/A/Q"   "5/5/Z/Q"   "6/6/Z/Q"  
#' # [7] "7/7/Z/Q"   "8/8/Z/Q"   "9/9/E/Q"   "10/10/E/Q" "11/11/E/Q" "12/12/E/Q"
#' #[13] "13/13/A/F" "14/14/A/F" "15/15/A/F" "16/16/A/F" "17/17/Z/F" "18/18/Z/F"
#' #[19] "19/19/Z/F" "20/20/Z/F" "21/21/E/F" "22/22/E/F" "23/23/E/F" "24/24/E/F"
#'
#' @export

regroupr <- function(inpt_v, sep_="-", order=c(1:length(unlist(strsplit(x=inpt_v[1], split=sep_)))), l_order=NA){

        id_keepr <- function(inpt_datf, col_v=c(), el_v=c(), rstr_l=NA){

            rtn_v <- c(1:nrow(inpt_datf))

            if (typeof(col_v) == "character"){

                cl_nms <- colnames(inpt_datf)

                for (i in 1:length(col_v)){

                        col_v[i] <- match(col_v[i], cl_nms)

                }

                col_v <- as.numeric(col_v)

            }

            if (all(is.na(rstr_l))){

                for (i in 1:length(col_v)){

                    rtn_v <- rtn_v[inpt_datf[rtn_v, col_v[i]] == el_v[i]]  

                }

                return(rtn_v)

            }else if (length(rstr_l) < length(col_v)){

                    lst_v <- unlist(rstr_l[length(rstr_l)])

                    for (i in (length(rstr_l)+1):length(col_v)){

                        rstr_l <- append(x=rstr_l, values=list(lst_v))

                    }

            }

            pre_vec <- c()

            fun <- function() { return(c(pre_vec, FALSE)) }

            for (i in 1:length(col_v)){

                pre_vec2 <- mapply(function(x) return(fun()), c(1:length(rtn_v)))

                interst <- intersect(unlist(rstr_l[i]), rtn_v)

                pre_vec2[interst] <- (inpt_datf[interst, col_v[i]] == el_v[i])

                rtn_v <- rtn_v[pre_vec2]  

            }

            return(rtn_v)

        }

        colins_datf <- function(inpt_datf, target_col=list(), target_pos=list()){

            cl_nms <- colnames(inpt_datf)

            for (id_vec in 1:length(target_pos)){

                    vec <- unlist(target_pos[id_vec])

                    if (typeof(vec) == "character"){

                            pre_v <- c()

                            for (el in vec){

                                pre_v <- c(pre_v, match(el, cl_nms))

                            }

                            target_pos <- append(x=target_pos, values=list(pre_v), after=id_vec)

                            target_pos <- target_pos[-id_vec]

                    }

            }

            for (cl in 1:length(target_col)){

                cur_col <- unlist(target_col[cl])

                cur_pos_v <- unlist(target_pos[cl])

                for (pos in 1:length(cur_pos_v)){

                    idx <- cur_pos_v[pos]

                    if (idx == 0){

                        inpt_datf <- cbind(cur_col, inpt_datf[(idx+1):ncol(inpt_datf)])

                    }else if (idx < ncol(inpt_datf)){

                        inpt_datf <- cbind(inpt_datf[1:idx], cur_col, inpt_datf[(idx+1):ncol(inpt_datf)])

                    }else{

                        inpt_datf <- cbind(inpt_datf[1:idx], cur_col)

                    }

                    if (pos < length(cur_pos_v)){

                        cur_pos_v[(pos+1):length(cur_pos_v)] = cur_pos_v[(pos+1):length(cur_pos_v)] + 1 
                 
                    }

                    if (cl < length(target_pos)){

                            for (i in (cl+1):length(target_pos)){

                                target_pos <- append(x=target_pos, values=(unlist(target_pos[i])+1), after=i)

                                target_pos <- target_pos[-i]
                            
                            } 

                    }

                }

            }

          return(inpt_datf)

    }
    
    cut_v <- function(inpt_v, sep_=""){

        rtn_datf <- data.frame(matrix(data=NA, nrow=0, ncol=length(unlist(strsplit(inpt_v[1], split=sep_)))))

        for (el in inpt_v){ rtn_datf <- rbind(rtn_datf, unlist(strsplit(el, split=sep_))) }

        return(rtn_datf)

    }

    paste_datf <- function(inpt_datf, sep=""){

            if (ncol(as.data.frame(inpt_datf)) == 1){ 

                return(inpt_datf) 

            }else {

                rtn_datf <- inpt_datf[,1]

                for (i in 2:ncol(inpt_datf)){

                    rtn_datf <- paste(rtn_datf, inpt_datf[,i], sep=sep)

                }

                return(rtn_datf)

            }

  }

  w_datf <- cut_v(inpt_v, sep_=sep_) 

  if (all(is.na(l_order))){

          l_order <- list()

          for (i in order){

                  l_order <- append(x=l_order, values=list(unique(w_datf[,i])))

          }

  }

  cur_el <- w_datf[, order[1]]  

  v_ids <- c(1:nrow(w_datf))

  rec_ids = 0

  for (el in unlist(l_order[1])){

    cur_ids <- which(cur_el == el)

    v_ids[(rec_ids + 1):(rec_ids + length(cur_ids))] <- el 

    rec_ids = rec_ids + length(cur_ids)

  }

  w_datf <- cbind(w_datf[, order[1]], w_datf)

  order <- order + 1

  cnt = 2

  for (I in order[2:length(order)]){

        cur_el <- w_datf[, I]

        cur_v_ids <- c(1:nrow(w_datf))

        pre_bind_v <- c(1:nrow(w_datf))

        rec_ids <- c()

        rec_ids2 <- c()

        for (el in unique(v_ids)){ 

                cur_ids_stay <- which(w_datf[, 1] == el) 

                rec_ids2 <- c(rec_ids, cur_ids_stay)

                for (el2 in unlist(l_order[cnt])){

                    cur_ids <- id_keepr(inpt_datf=w_datf, col_v=c(I), el_v=c(el2), rstr_l=list(list(cur_ids_stay))) 

                    if (length(cur_ids) > 0){

                        pre_bind_v[cur_ids] <- el2

                        cur_v_ids[(length(rec_ids)+1):(length(rec_ids)+length(cur_ids))] <- el2

                        rec_ids <- c(rec_ids, cur_ids)

                    }

                }

        }

        if (order[cnt] > order[(cnt-1)]){

                w_datf[, 1] <- paste_datf(inpt_datf=data.frame(w_datf[, 1], pre_bind_v), sep="")

                v_ids <- as.vector(mapply(function(x, y) return(paste(x, sep_, y, sep="")), v_ids, cur_v_ids))

        }else{

                w_datf[, 1] <- paste_datf(inpt_datf=data.frame(pre_bind_v, w_datf[, 1]), sep="")

                v_ids <- as.vector(mapply(function(x, y) return(paste(y, sep_, x, sep="")), v_ids, cur_v_ids))

        }

        cnt = cnt + 1

  }

  return(v_ids)

}

#' vec_in_datf
#'
#' Allow to get if a vector is in a dataframe. Returns the row and column of the vector in the dataframe if the vector is contained in the dataframe.
#'
#' @param inpt_datf is the input dataframe
#' @param inpt_vec is the vector that may be in the input dataframe
#' @param coeff is the "slope coefficient" of inpt_vec
#' @param conventional is if a positive slope coefficient means that the vector goes upward or downward 
#' @param stop_untl is the maximum number of the input vector the function returns, if in the dataframe 
#' @examples
#'
#' datf1 <- data.frame(c(1:5), c(5:1), c("a", "z", "z", "z", "a"))
#' 
#' print(datf1)
#' 
#' #  c.1.5. c.5.1. c..a....z....z....z....a..
#' #1      1      5                          a
#' #2      2      4                          z
#' #3      3      3                          z
#' #4      4      2                          z
#' #5      5      1                          a
#'
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(5, 4, "z"), coeff=1))
#'
#' #NULL
#' 
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(5, 2, "z"), coeff=1))
#' 
#' #[1] 5 1
#'
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(3, "z"), coeff=1))
#'
#' #[1] 3 2
#'
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(4, "z"), coeff=-1))
#' 
#' #[1] 2 2
#'
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(2, 3, "z"), coeff=-1))
#' 
#' #[1] 2 1
#' 
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(5, 2, "z"), coeff=-1, conventional=TRUE))
#'  
#' #[1] 5 1
#'
#' datf1[4, 2] <- 1
#' 
#' print(vec_in_datf(inpt_datf=datf1, inpt_vec=c(1, "z"), coeff=-1, conventional=TRUE, stop_untl=4))
#' 
#' #[1] 4 2 5 2
#' 
#' @export

vec_in_datf <- function(inpt_datf, inpt_vec=c(), coeff=0, stop_untl=1, conventional=FALSE){

    if (conventional){ coeff <- coeff * -1 }

    rtn_v <- c()

    encounter_cnt = 0

    if (coeff > -1){

            for (I in 1:(ncol(inpt_datf) - length(inpt_vec) + 1)){

                    strt_id = 1 + (length(inpt_vec) * coeff)

                    for (i in strt_id:nrow(inpt_datf)){

                        if (inpt_datf[i, I] == inpt_vec[1]){

                                cur_row = i

                                cur_col = I 

                                col_cnt = 1

                                while (col_cnt < (length(inpt_vec) + 1) & inpt_datf[cur_row, cur_col] == inpt_vec[col_cnt]){

                                    cur_row = cur_row - coeff

                                    if (!(col_cnt) == length(inpt_vec)){

                                        cur_col = cur_col + 1

                                    }

                                    col_cnt = col_cnt + 1

                                }

                                if (cur_col == ncol(inpt_datf)){

                                        rtn_v <- c(rtn_v, i, I)

                                        encounter_cnt = encounter_cnt + 1

                                        if (encounter_cnt == stop_untl){

                                                return(rtn_v)

                                        }

                                }

                        }

                    }

            }

    }else{

            for (I in 1:(ncol(inpt_datf) - length(inpt_vec) + 1)){

                    strt_id = nrow(inpt_datf) - (length(inpt_vec) * abs(coeff))

                    for (i in 1:strt_id){

                        if (inpt_datf[i, I] == inpt_vec[1]){

                                cur_row = i 

                                cur_col = I

                                col_cnt = 1

                                while (col_cnt < (length(inpt_vec) + 1) & inpt_datf[cur_row, cur_col] == inpt_vec[col_cnt]){

                                    cur_row = cur_row + abs(coeff)

                                    if (!(col_cnt) == length(inpt_vec)){

                                        cur_col = cur_col + 1

                                    }

                                    col_cnt = col_cnt + 1


                                }

                                if (cur_col == ncol(inpt_datf)){

                                        rtn_v <- c(rtn_v, i, I)

                                        encounter_cnt = encounter_cnt + 1

                                        if (encounter_cnt == stop_untl){

                                                return(rtn_v)

                                        }

                                }

                        }

                    }

            }

    }

    return(rtn_v)

}

#' date_converter_reverse
#'
#' Allow to convert single date value like 2025.36 year to a date like second/minutehour/day/month/year (snhdmy)
#' 
#' @param inpt_date is the input date 
#' @param convert_to is the date format the input date will be converted
#' @param frmt is the time unit of the input date
#' @param sep_ is the separator of the outputed date
#' @examples
#'
#' print(date_converter_reverse(inpt_date="2024.929", convert_to="hmy", frmt="y", sep_="-"))
#' 
#' #[1] "110-11-2024"
#' 
#' print(date_converter_reverse(inpt_date="2024.929", convert_to="dmy", frmt="y", sep_="-"))
#'
#' #[1] "4-11-2024"
#' 
#' print(date_converter_reverse(inpt_date="2024.929", convert_to="hdmy", frmt="y", sep_="-"))
#'
#' #[1] "14-4-11-2024"
#' 
#' print(date_converter_reverse(inpt_date="2024.929", convert_to="dhym", frmt="y", sep_="-"))
#' 
#' #[1] "4-14-2024-11"
#'
#' @export

date_converter_reverse <- function(inpt_date, convert_to="dmy", frmt="y", sep_="-"){
 
        converter_date <- function(inpt_date, convert_to, frmt="snhdmy", sep_="-"){

          is_divisible <- function(inpt_v=c(), divisible_v=c()){

                cnt = 1

                while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                        inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) == 0]

                        cnt = cnt + 1

                }

                return(inpt_v)

          }

          leap_yr <- function(year){

                  if (year == 0){ return(FALSE) }

                  if (year %% 4 == 0){
                    
                    if (year %% 100 == 0){
                      
                      if (year %% 400 == 0){
                        
                        bsx <- TRUE
                        
                      }else{
                        
                        bsx <- FALSE
                        
                      }
                      
                    }else{
                      
                      bsx <- TRUE
                      
                    }
                    
                  }else{
                    
                    bsx <- FALSE
                    
                  }

                  return(bsx)

          }

          inpt_date <- unlist(strsplit(x=inpt_date, split=sep_)) 

          stay_date_v <- c("s", "n", "h", "d", "m", "y")

          stay_date_val <- c(0, 0, 0, 0, 0, 0)

          frmt <- unlist(strsplit(x=frmt, split=""))

          for (el in 1:length(frmt)){

                  stay_date_val[grep(pattern=frmt[el], x=stay_date_v)] <- as.numeric(inpt_date[el]) 

          }

          l_dm1 <- c(31, 28, 31, 30, 31, 30, 31, 31,
                    30, 31, 30, 31)

          l_dm2 <- c(31, 29, 31, 30, 31, 30, 31, 31,
                    30, 31, 30, 31)

          if (!(leap_yr(year=stay_date_val[6]))){

                l_dm <- l_dm1

          }else if (stay_date_val[6] == 0){

                l_dm <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

          }else{

                l_dm <- l_dm2

          }

          may_bsx_v <- c(1:stay_date_val[6])

          may_bsx_v <- may_bsx_v[may_bsx_v > 0] 

          may_bsx_v <- may_bsx_v[(may_bsx_v %% 4) == 0]

          val_mult <- c((1 / 86400), (1 / 1440), (1/24), 1, 0, 365)

          day_val = 0

          for (dt in length(stay_date_val):1){

                day_val = day_val + stay_date_val[dt] * val_mult[dt] 

          }

          day_val = day_val + length(may_bsx_v[(may_bsx_v %% 100) != 0]) + length(is_divisible(inpt_v=may_bsx_v, divisible_v=c(100, 400))) 

          if (str_detect(string=stay_date_val[5], pattern="\\.")){

                  all_part <- as.numeric(unlist(strsplit(x=as.character(stay_date_val[5]), split="\\.")))

                  int_part <- all_part[1]

                  if (int_part != 0){

                        day_val = day_val + sum(l_dm[1:int_part])

                  }else{ int_part <- 1 }

                  day_val = day_val + l_dm1[int_part] * as.numeric(paste("0.", all_part[2], sep=""))

          }else if (stay_date_val[5] != 0){

                day_val = day_val + sum(l_dm1[1:stay_date_val[5]]) 

          }

          val_mult2 <- c(60, 60, 24, 1)

          idx_convert <- grep(pattern=convert_to, x=stay_date_v)

          if (idx_convert < 5){

                for (i in 4:idx_convert){

                    day_val = day_val * val_mult2[i]

                }

                return(day_val)

          }else{

            year = 0

            l_dm <- l_dm1

            month = 0

            bsx_cnt = 0

            while ((day_val / sum(l_dm)) >= 1 ){

                l_dmb <- l_dm

                day_val2 = day_val

                day_val = day_val - sum(l_dm)

                month = month + 12

                year = year + 1

                if (!(leap_yr(year=year))){

                        l_dm <- l_dm1

                }else{

                        bsx_cnt = bsx_cnt + 1

                        l_dm <- l_dm2

                } 

            }

            if (leap_yr(year=year)){

                day_val = day_val - 1

            }

            cnt = 1

            while ((day_val / l_dm[cnt]) >= 1){

                day_val = day_val - l_dm[cnt]

                month = month + 1

                cnt = cnt + 1 

            }

            month = month + (day_val / l_dm[cnt])

            if (convert_to == "m"){

                    return(month)

            }else{

                    year = year + ((month - 12 * year) / 12)

                    return(year)

            }

          }

        }

        date_symb <- c("s", "n", "h", "d", "m", "y")

        date_val <- c(0, 0, 0, 0, 0, 0)

        convert_to_v <- unlist(strsplit(x=convert_to, split=""))

        pre_v <- c()

        for (el in convert_to_v){

            pre_v <- c(pre_v, grep(pattern=el, x=date_symb))

        }

        pre_v2 <- sort(x=pre_v, decreasing=TRUE)

        cvrt_v <- date_symb[pre_v2]

        calcd <- as.character(converter_date(inpt_date=as.character(inpt_date), convert_to=cvrt_v[1], frmt=frmt)) 

        if (str_detect(pattern="e", string=calcd)){ calcd <- "0.0001" }

        pre_str <- as.numeric(unlist(strsplit(x=calcd, split="\\.")))

        inpt_date <- paste("0.", pre_str[2], sep="")

        date_val[pre_v2[1]] <- pre_str[1]

        if (length(convert_to_v) > 1){

            for (el in 1:(length(cvrt_v) - 1)){

                calcd <- as.character(converter_date(inpt_date=as.character(inpt_date), convert_to=cvrt_v[el+1], frmt=cvrt_v[el]))
               
                pre_str <- as.numeric(unlist(strsplit(x=calcd, split="\\.")))

                inpt_date <- paste("0.", pre_str[2], sep="")

                date_val[pre_v2[el+1]] <- pre_str[1]

            }

        }

    return(paste(date_val[pre_v], collapse=sep_))

}

#' converter_format
#'
#' Allow to convert a format to another
#'
#' @param inpt_val is the input value that is linked to the format
#' @param inpt_frmt is the format of the input value
#' @param sep_ is the separator of the value in inpt_val
#' @param frmt is the format you want to convert to
#' @param default_val is the default value given to the units that are not present in the input format
#' @examples
#'
#' print(converter_format(inpt_val="23-12-05-1567", sep_="-", 
#'                        inpt_frmt="shmy", frmt="snhdmy", default_val="00"))
#'
#' #[1] "23-00-12-00-05-1567"
#'
#' print(converter_format(inpt_val="23-12-05-1567", sep_="-", 
#'                        inpt_frmt="shmy", frmt="Pnhdmy", default_val="00"))
#' 
#' #[1] "00-00-12-00-05-1567"
#'
#' @export

converter_format <- function(inpt_val, sep_="-", inpt_frmt, 
                             frmt, default_val="00"){

        frmt <- unlist(strsplit(x=frmt, split=""))

        inpt_frmt <- unlist(strsplit(x=inpt_frmt, split=""))
        
        inpt_val <- unlist(strsplit(x=inpt_val, split=sep_))

        val_v <- c()

        for (i in 1:length(frmt)){

                val_v <- c(val_v, default_val)

        }

        for (el in 1:length(inpt_val)){

                pre_grep <- grep(x=frmt, pattern=inpt_frmt[el])

                if (!identical(pre_grep, integer(0))){

                        val_v[pre_grep] <- inpt_val[el]

                }

        }

        return(paste(val_v, collapse=sep_))

}

#' date_addr
#' 
#' Allow to add or substract two dates that have the same time unit or not
#'
#' @param date1 is the date from which the second date will be added or substracted
#' @param date2 is the date that will be added or will substract date1
#' @param add equals to FALSE if you want date1 - date2 and TRUE if you want date1 + date2
#' @param frmt1 is the format of date1 (snhdmy) (second, minute, hour, day, monthn year)
#' @param frmt2 is the format of date2 (snhdmy)
#' @param sep_ is the separator of date1 and date2
#' @param convert_to is the format of the outputed date
#' @examples
#'
#' print(date_addr(date1="25-02", date2="58-12-08", frmt1="dm", frmt2="shd", sep_="-", 
#'                 convert_to="dmy"))
#'
#' #[1] "18-2-0"
#'
#' print(date_addr(date1="25-02", date2="58-12-08", frmt1="dm", frmt2="shd", sep_="-", 
#'                 convert_to="dmy", add=TRUE))
#'
#' #[1] "3-3-0"
#'
#' print(date_addr(date1="25-02-2024", date2="1-01", frmt1="dmy", frmt2="dm", sep_="-", 
#'                 convert_to="dmy", add=TRUE))
#'
#' #[1] "27-3-2024"
#'
#' print(date_addr(date1="25-02-2024", date2="1-01", frmt1="dmy", frmt2="dm", sep_="-", 
#'                 convert_to="dmy", add=FALSE))
#' 
#' #[1] "23-1-2024" 
#'
#' print(date_addr(date1="25-02-2024", date2="1-01", frmt1="dmy", frmt2="dm", sep_="-", 
#'                  convert_to="n", add=FALSE))
#'
#' #[1] "1064596320"
#' 
#' print(date_addr(date1="25-02-2024", date2="1-01", frmt1="dmy", frmt2="dm", sep_="-", 
#'                  convert_to="s", add=FALSE))
#'
#' #[1] "63875779200"
#'
#' @export


date_addr <- function(date1, date2, add=FALSE, frmt1, frmt2=frmt1, sep_="-", convert_to="dmy"){
 
        converter_format <- function(inpt_val, sep_="-", inpt_frmt, 
                             frmt, default_val="00"){

                frmt <- unlist(strsplit(x=frmt, split=""))

                inpt_frmt <- unlist(strsplit(x=inpt_frmt, split=""))
                
                inpt_val <- unlist(strsplit(x=inpt_val, split=sep_))

                val_v <- c()

                for (i in 1:length(frmt)){

                        val_v <- c(val_v, default_val)

                }

                for (el in 1:length(inpt_val)){

                        pre_grep <- grep(x=frmt, pattern=inpt_frmt[el])

                        if (!identical(pre_grep, integer(0))){

                                val_v[pre_grep] <- inpt_val[el]

                        }

                }

                return(paste(val_v, collapse=sep_))

        }

        converter_date <- function(inpt_date, convert_to, frmt="snhdmy", sep_="-"){

          is_divisible <- function(inpt_v=c(), divisible_v=c()){

                cnt = 1

                while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                        inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) == 0]

                        cnt = cnt + 1

                }

                return(inpt_v)

          }

          leap_yr <- function(year){

                  if (year == 0){ return(FALSE) }

                  if (year %% 4 == 0){
                    
                    if (year %% 100 == 0){
                      
                      if (year %% 400 == 0){
                        
                        bsx <- TRUE
                        
                      }else{
                        
                        bsx <- FALSE
                        
                      }
                      
                    }else{
                      
                      bsx <- TRUE
                      
                    }
                    
                  }else{
                    
                    bsx <- FALSE
                    
                  }

                  return(bsx)

          }

          inpt_date <- unlist(strsplit(x=inpt_date, split=sep_)) 

          stay_date_v <- c("s", "n", "h", "d", "m", "y")

          stay_date_val <- c(0, 0, 0, 0, 0, 0)

          frmt <- unlist(strsplit(x=frmt, split=""))

          for (el in 1:length(frmt)){

                  stay_date_val[grep(pattern=frmt[el], x=stay_date_v)] <- as.numeric(inpt_date[el]) 

          }

          l_dm1 <- c(31, 28, 31, 30, 31, 30, 31, 31,
                    30, 31, 30, 31)

          l_dm2 <- c(31, 29, 31, 30, 31, 30, 31, 31,
                    30, 31, 30, 31)

          if (!(leap_yr(year=stay_date_val[6]))){

                l_dm <- l_dm1

          }else if (stay_date_val[6] == 0){

                l_dm <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

          }else{

                l_dm <- l_dm2

          }

          may_bsx_v <- c(1:stay_date_val[6])

          may_bsx_v <- may_bsx_v[may_bsx_v > 0] 

          may_bsx_v <- may_bsx_v[(may_bsx_v %% 4) == 0]

          val_mult <- c((1 / 86400), (1 / 1440), (1/24), 1, 0, 365)

          day_val = 0

          for (dt in length(stay_date_val):1){

                day_val = day_val + stay_date_val[dt] * val_mult[dt] 

          }

          day_val = day_val + length(may_bsx_v[(may_bsx_v %% 100) != 0]) + length(is_divisible(inpt_v=may_bsx_v, divisible_v=c(100, 400))) 

          if (str_detect(string=stay_date_val[5], pattern="\\.")){

                  all_part <- as.numeric(unlist(strsplit(x=as.character(stay_date_val[5]), split="\\.")))

                  int_part <- all_part[1]

                  if (int_part != 0){

                        day_val = day_val + sum(l_dm[1:int_part])

                  }else{ int_part <- 1 }

                  day_val = day_val + l_dm1[int_part] * as.numeric(paste("0.", all_part[2], sep=""))

          }else if (stay_date_val[5] != 0){

                day_val = day_val + sum(l_dm1[1:stay_date_val[5]]) 

          }

          val_mult2 <- c(60, 60, 24, 1)

          idx_convert <- grep(pattern=convert_to, x=stay_date_v)

          if (idx_convert < 5){

                for (i in 4:idx_convert){

                    day_val = day_val * val_mult2[i]

                }

                return(day_val)

          }else{

            year = 0

            l_dm <- l_dm1

            month = 0

            bsx_cnt = 0

            while ((day_val / sum(l_dm)) >= 1 ){

                l_dmb <- l_dm

                day_val2 = day_val

                day_val = day_val - sum(l_dm)

                month = month + 12

                year = year + 1

                if (!(leap_yr(year=year))){

                        l_dm <- l_dm1

                }else{

                        bsx_cnt = bsx_cnt + 1

                        l_dm <- l_dm2

                } 

            }

            if (leap_yr(year=year)){

                day_val = day_val - 1

            }

            cnt = 1

            while ((day_val / l_dm[cnt]) >= 1){

                day_val = day_val - l_dm[cnt]

                month = month + 1

                cnt = cnt + 1 

            }

            month = month + (day_val / l_dm[cnt])

            if (convert_to == "m"){

                    return(month)

            }else{

                    year = year + ((month - 12 * year) / 12)

                    return(year)

            }

          }

        }

        date_converter_reverse <- function(inpt_date, convert_to="dmy", frmt="y", sep_="-"){
 
                converter_date <- function(inpt_date, convert_to, frmt="snhdmy", sep_="-"){

                  is_divisible <- function(inpt_v=c(), divisible_v=c()){

                        cnt = 1

                        while (length(inpt_v) > 0 & cnt < (length(divisible_v) + 1)){

                                inpt_v <- inpt_v[(inpt_v %% divisible_v[cnt]) == 0]

                                cnt = cnt + 1

                        }

                        return(inpt_v)

                  }

                  leap_yr <- function(year){

                          if (year == 0){ return(FALSE) }

                          if (year %% 4 == 0){
                            
                            if (year %% 100 == 0){
                              
                              if (year %% 400 == 0){
                                
                                bsx <- TRUE
                                
                              }else{
                                
                                bsx <- FALSE
                                
                              }
                              
                            }else{
                              
                              bsx <- TRUE
                              
                            }
                            
                          }else{
                            
                            bsx <- FALSE
                            
                          }

                          return(bsx)

                  }

                  inpt_date <- unlist(strsplit(x=inpt_date, split=sep_)) 

                  stay_date_v <- c("s", "n", "h", "d", "m", "y")

                  stay_date_val <- c(0, 0, 0, 0, 0, 0)

                  frmt <- unlist(strsplit(x=frmt, split=""))

                  for (el in 1:length(frmt)){

                          stay_date_val[grep(pattern=frmt[el], x=stay_date_v)] <- as.numeric(inpt_date[el]) 

                  }

                  l_dm1 <- c(31, 28, 31, 30, 31, 30, 31, 31,
                            30, 31, 30, 31)

                  l_dm2 <- c(31, 29, 31, 30, 31, 30, 31, 31,
                            30, 31, 30, 31)

                  if (!(leap_yr(year=stay_date_val[6]))){

                        l_dm <- l_dm1

                  }else if (stay_date_val[6] == 0){

                        l_dm <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)

                  }else{

                        l_dm <- l_dm2

                  }

                  may_bsx_v <- c(1:stay_date_val[6])

                  may_bsx_v <- may_bsx_v[may_bsx_v > 0] 

                  may_bsx_v <- may_bsx_v[(may_bsx_v %% 4) == 0]

                  val_mult <- c((1 / 86400), (1 / 1440), (1/24), 1, 0, 365)

                  day_val = 0

                  for (dt in length(stay_date_val):1){

                        day_val = day_val + stay_date_val[dt] * val_mult[dt] 

                  }

                  day_val = day_val + length(may_bsx_v[(may_bsx_v %% 100) != 0]) + length(is_divisible(inpt_v=may_bsx_v, divisible_v=c(100, 400))) 

                  if (str_detect(string=stay_date_val[5], pattern="\\.")){

                          all_part <- as.numeric(unlist(strsplit(x=as.character(stay_date_val[5]), split="\\.")))

                          int_part <- all_part[1]

                          if (int_part != 0){

                                day_val = day_val + sum(l_dm[1:int_part])

                          }else{ int_part <- 1 }

                          day_val = day_val + l_dm1[int_part] * as.numeric(paste("0.", all_part[2], sep=""))

                  }else if (stay_date_val[5] != 0){

                        day_val = day_val + sum(l_dm1[1:stay_date_val[5]]) 

                  }

                  val_mult2 <- c(60, 60, 24, 1)

                  idx_convert <- grep(pattern=convert_to, x=stay_date_v)

                  if (idx_convert < 5){

                        for (i in 4:idx_convert){

                            day_val = day_val * val_mult2[i]

                        }

                        return(day_val)

                  }else{

                    year = 0

                    l_dm <- l_dm1

                    month = 0

                    bsx_cnt = 0

                    while ((day_val / sum(l_dm)) >= 1 ){

                        l_dmb <- l_dm

                        day_val2 = day_val

                        day_val = day_val - sum(l_dm)

                        month = month + 12

                        year = year + 1

                        if (!(leap_yr(year=year))){

                                l_dm <- l_dm1

                        }else{

                                bsx_cnt = bsx_cnt + 1

                                l_dm <- l_dm2

                        } 

                    }

                    if (leap_yr(year=year)){

                        day_val = day_val - 1

                    }

                    cnt = 1

                    while ((day_val / l_dm[cnt]) >= 1){

                        day_val = day_val - l_dm[cnt]

                        month = month + 1

                        cnt = cnt + 1 

                    }

                    month = month + (day_val / l_dm[cnt])

                    if (convert_to == "m"){

                            return(month)

                    }else{

                            year = year + ((month - 12 * year) / 12)

                            return(year)

                    }

                  }

                }

                date_symb <- c("s", "n", "h", "d", "m", "y")

                date_val <- c(0, 0, 0, 0, 0, 0)

                convert_to_v <- unlist(strsplit(x=convert_to, split=""))

                pre_v <- c()

                for (el in convert_to_v){

                    pre_v <- c(pre_v, grep(pattern=el, x=date_symb))

                }

                pre_v2 <- sort(x=pre_v, decreasing=TRUE)

                cvrt_v <- date_symb[pre_v2]

                calcd <- as.character(converter_date(inpt_date=as.character(inpt_date), convert_to=cvrt_v[1], frmt=frmt)) 

                if (str_detect(pattern="e", string=calcd)){ calcd <- "0.0001" }

                pre_str <- as.numeric(unlist(strsplit(x=calcd, split="\\.")))

                inpt_date <- paste("0.", pre_str[2], sep="")

                date_val[pre_v2[1]] <- pre_str[1]

                if (length(convert_to_v) > 1){

                    for (el in 1:(length(cvrt_v) - 1)){

                        calcd <- as.character(converter_date(inpt_date=as.character(inpt_date), convert_to=cvrt_v[el+1], frmt=cvrt_v[el]))
                       
                        pre_str <- as.numeric(unlist(strsplit(x=calcd, split="\\.")))

                        inpt_date <- paste("0.", pre_str[2], sep="")

                        date_val[pre_v2[el+1]] <- pre_str[1]

                    }

                }

            return(paste(date_val[pre_v], collapse=sep_))

        }

        ptrn_twkr <- function(inpt_l, depth="max", sep="-", 
                              default_val="0", add_sep=TRUE, end_=TRUE){
          
          ln <- length(inpt_l)
          
          if (depth == "min"){
            
            pre_val <- str_count(inpt_l[1], sep)
            
            for (i in 2:ln){
              
              if (str_count(inpt_l[i], sep) < pre_val){
                
                pre_val <- str_count(inpt_l[i], sep)
                
              }
              
            }
            
            depth <- pre_val
            
          }

          if (depth == "max"){
            
            pre_val <- str_count(inpt_l[1], sep)
            
            for (i in 2:ln){
              
              if (str_count(inpt_l[i], sep) > pre_val){
                
                pre_val <- str_count(inpt_l[i], sep)
                
              }
              
            }
            
            depth <- pre_val
            
          }

          if (end_){

                  for (I in 1:ln){
                   
                    hmn <- str_count(inpt_l[I], "-")
                    
                    if (hmn < depth){
                     
                      inpt_l[I] <- paste0(inpt_l[I], sep, default_val)

                      diff <- depth - hmn - 1

                      if (diff > 0){
                      
                                if (add_sep){
                                  
                                  for (i in 1:diff){
                                  
                                    inpt_l[I] <- paste0(inpt_l[I], sep, default_val)
                                  
                                  }
                                
                                }else{
                                  
                                  for (i in 1:diff){
                                    
                                    inpt_l[I] <- paste0(inpt_l[I], default_val)
                                    
                                  }
                                  
                                }

                     }
                    
                    }else if(depth < hmn){

                        if (add_sep){

                                inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse=sep)

                        }else{

                                inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse="")
                       
                        }

                    }

                  }
          
          }else{

                for (I in 1:ln){
                   
                    hmn <- str_count(inpt_l[I], "-")
                    
                    if (hmn < depth){
                     
                      inpt_l[I] <- paste0(default_val, sep, inpt_l[I])

                      diff <- depth - hmn - 1

                      if (diff > 0){
                      
                                if (add_sep){
                                  
                                  for (i in 1:diff){
                                  
                                    inpt_l[I] <- paste0(default_val, sep, inpt_l[I])
                                  
                                  }
                                
                                }else{
                                  
                                  for (i in 1:diff){
                                    
                                    inpt_l[I] <- paste0(default_val, inpt_l[I])
                                    
                                  }
                                  
                                }

                     }
                    
                    }else if(depth < hmn){

                        if (add_sep){

                                inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse=sep)

                        }else{

                                inpt_l[I] <- paste(unlist(strsplit(inpt_l[I], split=sep))[1:(depth+1)], collapse="")
                       
                        }

                    }

                  }

          }

          return(inpt_l)
          
        }

        date_symb <- c("s", "n", "h", "d", "m", "y")

        pre_v <- c()

        for (el in unlist(strsplit(x=frmt1, split=""))){

                pre_v <- c(pre_v, grep(x=date_symb, pattern=el))

        }

        min1 <- min(pre_v)

        pre_v <- c()

        for (el in unlist(strsplit(x=frmt2, split=""))){

                pre_v <- c(pre_v, grep(x=date_symb, pattern=el))

        }

        min2 <- min(pre_v)

        if (min1 >= min2){

                min_ <- min2 

        }

        if (min1 < min2){

                min_ <- min1

        }

        date1 <- converter_format(inpt_val=date1, inpt_frmt=frmt1, frmt="snhdmy", sep_=sep_) 

        date2 <- converter_format(inpt_val=date2, inpt_frmt=frmt2, frmt="snhdmy", sep_=sep_) 

        date1 <- converter_date(inpt_date=date1, frmt="snhdmy", convert_to=date_symb[min_], sep_=sep_)

        date2 <- converter_date(inpt_date=date2, frmt="snhdmy", convert_to=date_symb[min_], sep_=sep_)

        if (add){

                datef <- date1 + date2

        }else{

                datef <- date1 - date2

        }

        return(date_converter_reverse(inpt_date=datef, frmt=date_symb[min_], 
                                      convert_to=convert_to, sep_=sep_))

}

#' better_match
#' 
#' Allow to get the nth element matched in a vector
#' 
#' @param inpt_v is the input vector 
#' @param ptrn is the pattern to be matched
#' @param untl is the maximum number of matched pattern outputed
#' @param nvr_here is a value you are sure is not present in inpt_v
#' @examples
#'
#' print(better_match(inpt_v=c(1:12, 3, 4, 33, 3), ptrn=3, untl=1))
#'
#' #[1] 3
#'
#' print(better_match(inpt_v=c(1:12, 3, 4, 33, 3), ptrn=3, untl=5))
#'  
#' #[1]  3 13 16
#'
#' print(better_match(inpt_v=c(1:12, 3, 4, 33, 3), ptrn=c(3, 4), untl=5))
#'  
#' [1]  3 13 16  4 14
#' 
#' print(better_match(inpt_v=c(1:12, 3, 4, 33, 3), ptrn=c(3, 4), untl=c(1, 5)))
#'
#' [1]  3  4 14
#' 
#' @export

better_match <- function(inpt_v=c(), ptrn, untl=1, nvr_here=NA){
  Rtn_v <- c()
  if (length(untl) < length(ptrn)){
    val_add <- untl[length(untl)]
    while (length(untl) < length(ptrn)){
      untl <- c(untl, val_add)
    }
  }
  if (!(is.na(match(x = "max", table = untl)))){
    untl[untl == "max"] <- length(inpt_v)
    untl <- as.numeric(untl)
  }
  for (cur_ptrn in 1:length(ptrn)){
    rtn_v <- c()
    cnt = 1
    stop <- FALSE
    while (length(rtn_v) < untl[cur_ptrn] & cnt < (length(inpt_v) + 1) & !(stop)){
            pre_match <- match(x=ptrn[cur_ptrn], table=inpt_v)
            if (!(is.na(pre_match))){
              inpt_v[pre_match] <- nvr_here
              rtn_v <- c(rtn_v, pre_match)
            }else{
              stop <- TRUE
            }
            cnt = cnt + 1
    }
    Rtn_v <- c(Rtn_v, rtn_v)
  }
  return(Rtn_v)
}

#' vector_replacor
#'
#' Allow to replace certain values in a vector.
#'
#' @param inpt_v is the input vector
#' @param sus_val is a vector containing all the values that will be replaced
#' @param rpl_val is a vector containing the value of the elements to be replaced (sus_val), so sus_val and rpl_val should be the same size
#' @param grep_ is if the elements in sus_val should be equal to the elements to replace in inpt_v or if they just should found in the elements
#' @examples
#' 
#' print(vector_replacor(inpt_v=c(1:15), sus_val=c(3, 6, 8, 12), 
#'      rpl_val=c("oui", "non", "e", "a")))
#'
#' # [1] "1"   "2"   "oui" "4"   "5"   "non" "7"   "e"   "9"   "10"  "11"  "a"  
#' #[13] "13"  "14"  "15" 
#' 
#' print(vector_replacor(inpt_v=c("non", "zez", "pp a ftf", "fdatfd", "assistance", 
#' "ert", "repas", "repos"), 
#' sus_val=c("pp", "as", "re"), rpl_val=c("oui", "non", "zz"), grep_=TRUE))
#' 
#' #[1] "non"  "zez"  "oui"  "fdatfd" "non"  "ert"  "non"  "zz"  
#'
#' @export

vector_replacor <- function(inpt_v=c(), sus_val=c(), rpl_val=c(), grep_=FALSE){

        if (grep_){

            for (el in 1:length(inpt_v)){

                    cnt = 1

                    stop <- 0

                    while (cnt < (length(sus_val) + 1) & stop == 0){

                            if (str_detect(string=inpt_v[el], pattern=sus_val[cnt])){

                                inpt_v[el] <- rpl_val[cnt]

                                stop <- 1

                            }

                            cnt = cnt + 1

                    }

            }

        }else{

            for (el in 1:length(inpt_v)){

                pre_match <- match(x=inpt_v[el], table=sus_val)

                if (!(is.na(pre_match))){

                        inpt_v[el] <- rpl_val[pre_match]

                }

            }

        }

    return(inpt_v)

}

#' diff_datf
#'
#' Returns a vector with the coordinates of the cell that are not equal between 2 dataframes (row, column).
#'
#' @param datf1 is an an input dataframe
#' @param datf2 is an an input dataframe
#' @examples
#'
#' datf1 <- data.frame(c(1:6), c("oui", "oui", "oui", "oui", "oui", "oui"), c(6:1))
#' 
#' datf2 <- data.frame(c(1:7), c("oui", "oui", "oui", "oui", "non", "oui", "zz"))
#' 
#' print(diff_datf(datf1=datf1, datf2=datf2)) 
#'
#' #[1] 5 1 5 2
#'
#' @export

diff_datf <- function(datf1, datf2){

    rtn_v <- c()

    min_r <- min(c(nrow(datf1), nrow(datf2)))

    for (col_i in 1:min(c(ncol(datf1), ncol(datf2)))){

            for (row_i in 1:min_r){

                if (datf1[row_i, col_i] != datf2[row_i, col_i]){ rtn_v <- c(rtn_v, row_i, col_i) } 

            }

    }

    return(rtn_v)

}

#' swipr
#'
#' Returns an ordered dataframes according to the elements order given. The input datafram has two columns, one with the ids which can be bonded to multiple elements in the other column.
#'
#' @param inpt_datf is the input dataframe
#' @param how_to is a vector containing the elements in the order wanted
#' @param id_w is the column number or the column name of the elements
#' @param id_ids is the column number or the column name of the ids
#' @examples
#'
#' datf <- data.frame("col1"=c("Af", "Al", "Al", "Al", "Arg", "Arg", "Arg", "Arm", "Arm", "Al"),
#' 
#'         "col2"=c("B", "B", "G", "S", "B", "S", "G", "B", "G", "B"))
#' 
#' print(swipr(inpt_datf=datf, how_to=c("G", "S", "B")))
#' 
#'    col1 col2
#' 1    Af    B
#' 2    Al    G
#' 3    Al    S
#' 4    Al    B
#' 5   Arg    G
#' 6   Arg    S
#' 7   Arg    B
#' 8   Arm    G
#' 9   Arm    B
#' 10   Al    B
#'
#' @export

swipr <- function(inpt_datf, how_to=c(), id_w=2, id_ids=1){

       if (typeof(id_w) == "character"){

               id_w <- match(id_w, colnames(inpt_datf))

       }

       if (typeof(id_ids) == "character"){

               id_ids <- match(id_ids, colnames(inpt_datf))

       }

       for (el in unique(inpt_datf[, id_ids])){

            cur_rows <- inpt_datf[, id_ids] == el

            cur_v <- inpt_datf[cur_rows, id_w]

            inpt_datf[cur_rows, id_w] <- how_to[sort(match(x=cur_v, table=how_to), 
                                                     decreasing=FALSE)]

       }

  return(inpt_datf)

}

#' cutr_v
#'
#' Allow to reduce all the elements in a vector to a defined size of nchar
#'
#' @param inpt_v is the input vector
#' @param untl is the maximum size of nchar authorized by an element, defaults to "min", it means the shortest element in the list
#'
#' @examples
#'
#' test_v <- c("oui", "nonon", "ez", "aa", "a", "dsfsdsds")
#' 
#' print(cutr_v(inpt_v=test_v, untl="min"))
#' 
#' #[1] "o" "n" "e" "a" "a" "d"
#'
#' print(cutr_v(inpt_v=test_v, untl=3))
#'
#' #[1] "oui" "non" "ez"  "aa"  "a"   "dsf"
#'
#' @export

cutr_v <- function(inpt_v, untl="min"){

    if (untl == "min"){

        untl_ <- nchar(inpt_v[1])

        for (el in inpt_v[2:length(inpt_v)]){

                if (nchar(el) < untl){ untl <- nchar(el) }

        }

    }

    for (i in 1:length(inpt_v)){

        if (nchar(inpt_v[i]) > untl){

                inpt_v[i] <- paste(unlist(strsplit(x=inpt_v[i], split=""))[1:untl], collapse="")

        }

    }

    return(inpt_v)

}

#' intersect_mod
#'
#' Returns the mods that have elements in common
#'
#' @param datf is the input dataframe
#' @param inter_col is the column name or the column number of the values that may be commun betwee the different mods
#' @param mod_col is the column name or the column number of the mods in the dataframe
#' @param ordered_descendly, in case that the elements in commun are numeric, this option can be enabled by giving a value of TRUE or FALSE see examples
#' @param n_min is the minimum elements in common a mod should have to be taken in count
#'
#' @examples
#'
#' datf <- data.frame("col1"=c("oui", "oui", "oui", "oui", "oui", "oui", 
#'                      "non", "non", "non", "non", "ee", "ee", "ee"), "col2"=c(1:6, 2:5, 1:3))
#' 
#' print(intersect_mod(datf=datf, inter_col=2, mod_col=1, n_min=2))
#' 
#'    col1 col2
#' 2   oui    2
#' 3   oui    3
#' 7   non    2
#' 8   non    3
#' 12   ee    2
#' 13   ee    3
#'
#' print(intersect_mod(datf=datf, inter_col=2, mod_col=1, n_min=3))
#'
#'    col1 col2
#' 2   oui    2
#' 3   oui    3
#' 4   oui    4
#' 5   oui    5
#' 7   non    2
#' 8   non    3
#' 9   non    4
#' 10  non    5
#'
#' print(intersect_mod(datf=datf, inter_col=2, mod_col=1, n_min=5))
#' 
#'   col1 col2
#' 1  oui    1
#' 2  oui    2
#' 3  oui    3
#' 4  oui    4
#' 5  oui    5
#' 6  oui    6
#' 
#' datf <- data.frame("col1"=c("non", "non", "oui", "oui", "oui", "oui", 
#'                       "non", "non", "non", "non", "ee", "ee", "ee"), "col2"=c(1:6, 2:5, 1:3))
#' 
#' print(intersect_mod(datf=datf, inter_col=2, mod_col=1, n_min=3))
#' 
#'    col1 col2
#' 8   non    3
#' 9   non    4
#' 10  non    5
#' 3   oui    3
#' 4   oui    4
#' 5   oui    5
#' 
#' @export

intersect_mod <- function(datf, inter_col, mod_col, n_min, descendly_ordered=NA){

    if (typeof(inter_col) == "character"){

            inter_col <- match(inter_col, colnames(datf))

    }

    if (typeof(mod_col) == "character"){

            mod_col <- match(mod_col, colnames(datf))

    }

    mods <- unique(datf[, mod_col])  

    final_intersect <- as.numeric(datf[datf[, mod_col] == mods[1], inter_col])

    mods2 <- c(mods[1])

    if (length(mods) > 1){

            for (i in 2:length(mods)){

                    cur_val <- as.numeric(datf[datf[, mod_col] == mods[i], inter_col])

                    if (length(intersect(final_intersect, cur_val)) >= n_min){

                            final_intersect <- intersect(final_intersect, cur_val)

                            mods2 <- c(mods2, mods[i])

                    }

            }

    }

    cur_datf <- datf[datf[, mod_col] == mods2[1], ]

    if (!is.na(descendly_ordered)){

            final_intersect <- sort(x=final_intersect, decreasing=FALSE)

            rtn_datf <- cur_datf[sort(match(final_intersect, cur_datf[, inter_col]), decreasing=descendly_ordered), ]

            if (length(mods2) > 1){

                    for (i in 2:length(mods2)){

                        cur_datf <- datf[datf[, mod_col] == mods2[i], ]

                        rtn_datf <- rbind(rtn_datf, cur_datf[sort(match(final_intersect, cur_datf[, inter_col]), decreasing=descendly_ordered), ])
    

                    }

            }

    }else{

            rtn_datf <- cur_datf[match(final_intersect, cur_datf[, inter_col]), ]

            if (length(mods2) > 1){

                    for (i in 2:length(mods2)){

                        cur_datf <- datf[datf[, mod_col] == mods2[i], ]

                        rtn_datf <- rbind(rtn_datf, cur_datf[match(final_intersect, cur_datf[, inter_col]), ])
    

                    }

            }

    }

    return(rtn_datf)

}

#' regex_spe_detect
#'
#' Takes a character as input and returns its regex-friendly character for R. 
#' 
#' @param inpt the input character
#'
#' @examples 
#'
#' print(regex_spe_detect("o"))
#' 
#' [1] "o"
#'
#' print(regex_spe_detect("("))
#' 
#' [1] "\\("
#' 
#' print(regex_spe_detect("tr(o)m"))
#'
#' [1] "tr\\(o\\)m"
#'
#' print(regex_spe_detect(inpt="fggfg[fggf]fgfg(vg?fgfgf.gf)"))
#' 
#' [1] "fggfg\\[fggf\\]fgfg\\(vg\\?fgfgf\\.gf\\)"
#'
#' print(regex_spe_detect(inpt = "---"))
#'
#' [1] "\\-\\-\\-" 
#'
#' @export

regex_spe_detect <- function(inpt){
        fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
          ptrn <- grep(ptrn_fill, inpt_v)
          while (length(ptrn) > 0){
            ptrn <- grep(ptrn_fill, inpt_v)
            idx <- ptrn[1] 
            untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
            pre_val <- inpt_v[(idx - 1)]
            inpt_v[idx] <- pre_val
            if (untl > 0){
              for (i in 1:untl){
                inpt_v <- append(inpt_v, pre_val, idx)
              }
            }
          ptrn <- grep(ptrn_fill, inpt_v)
          }
          return(inpt_v)
        }
        inpt <- unlist(strsplit(x=inpt, split=""))
        may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
        pre_idx <- unique(match(x=inpt, table=may_be_v))
        pre_idx <- pre_idx[!(is.na(pre_idx))]
        for (el in may_be_v[pre_idx]){
                cnt = 0
                for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                        inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                        cnt = cnt + 1
                }
        }
  return(paste(inpt, collapse=""))
}

#' pairs_findr
#'
#' Takes a character as input and detect the pairs of pattern, like the parenthesis pais if the pattern is "(" and then ")"
#'
#' @param inpt is the input character
#' @param ptrn1 is the first pattern ecountered in the pair
#' @param ptrn2 is the second pattern in the pair
#' @examples
#' 
#' print(pairs_findr(inpt="ze+(yu*45/(jk+zz)*(o()p))-(re*(rt+qs)-fg)"))
#' 
#' [[1]]
#'  [1] 4 1 1 3 2 2 3 4 6 5 5 6
#' 
#' [[2]]
#'  [1]  4 11 17 19 21 22 24 25 27 31 37 41
#'
#' @export

pairs_findr <- function(inpt, ptrn1="(", ptrn2=")"){
        regex_spe_detect <- function(inpt){
          fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
            ptrn <- grep(ptrn_fill, inpt_v)
            while (length(ptrn) > 0){
              ptrn <- grep(ptrn_fill, inpt_v)
              idx <- ptrn[1] 
              untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
              pre_val <- inpt_v[(idx - 1)]
              inpt_v[idx] <- pre_val
              if (untl > 0){
                for (i in 1:untl){
                  inpt_v <- append(inpt_v, pre_val, idx)
                }
              }
            ptrn <- grep(ptrn_fill, inpt_v)
            }
            return(inpt_v)
          }
          inpt <- unlist(strsplit(x=inpt, split=""))
          may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
          pre_idx <- unique(match(x=inpt, table=may_be_v))
          pre_idx <- pre_idx[!(is.na(pre_idx))]
          for (el in may_be_v[pre_idx]){
                  cnt = 0
                  for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                          inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                          cnt = cnt + 1
                  }
          }
          return(paste(inpt, collapse=""))
        }
        
        lst <- unlist(strsplit(x=inpt, split=""))

        lst_par <- c()

        lst_par_calc <- c()

        lst_pos <- c()

        paires = 1

        pre_paires = 1

        pre_paires2 = 1

        if ((length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2) > 0){

                for (i in 1:(length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2)){ 

                        lst_par <- c(lst_par, 0)

                        lst_par_calc <- c(lst_par_calc, 0)

                        lst_pos <- c(lst_pos, 0)


                }

        }

        vec_ret <- c()

        par_ = 1

        lvl_par = 0

        for (el in 1:length(lst)){

           if (lst[el] == ptrn1){

                   if (!(is.null(vec_ret))){

                           lst_par_calc[pre_paires2:pre_paires][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] + 1

                   }else{

                           lst_par_calc[pre_paires2:pre_paires] <- lst_par_calc[pre_paires2:pre_paires] + 1

                   }

                   pre_paires = pre_paires + 1

                   pre_cls <- TRUE

                   lst_pos[par_] <- el

                   par_ = par_ + 1

                   lvl_par = lvl_par + 1

           }

           if (lst[el] == ptrn2){

                   lvl_par = lvl_par - 1

                   if (!(is.null(vec_ret))){

                        lst_par_calc[c(pre_paires2:pre_paires)][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] - 1

                        pre_val <- lst_par_calc[pre_paires2:pre_paires][vec_ret]

                        lst_par_calc[pre_paires2:pre_paires][vec_ret] <- (-2)
                   
                   }else{

                        lst_par_calc[c(pre_paires2:pre_paires)] <- lst_par_calc[pre_paires2:pre_paires] - 1

                   }

                   if (!(is.null(vec_ret))){ 

                           pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])

                           lst_par_calc[pre_paires2:pre_paires][vec_ret] <- pre_val 

                   }else{

                           pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires])

                   }

                   cnt_par = 1

                   cnt2 = 0

                   if (!(is.null(vec_ret))){

                           vec_ret <- sort(vec_ret)

                           if (pre_mtch[1] >= min(vec_ret)){

                                cnt2 = 2

                                while (pre_mtch[1] > cnt_par & cnt2 <= length(vec_ret)){

                                        if ((vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) > 1){

                                                cnt_par = cnt_par + (vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) - 1

                                        }

                                        cnt2 = cnt2 + 1

                                }

                                if (pre_mtch[1] > cnt_par){

                                        cnt_par = length(vec_ret) / 2 + 1

                                }

                                cnt2 = cnt2 - 1

                           }

                   }

                   lst_par[pre_mtch[1] + (pre_paires2 - 1) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1))] <- paires 

                   lst_par[pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret)] <- paires 

                   if ((pre_mtch[1] + (pre_paires2 - 1)) == 1){

                        pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1

                        vec_ret <- c()

                        cnt_par = 0

                   } else if (lst_par_calc[(pre_mtch[1] + (pre_paires2 - 1) - 1)] == -1 & ifelse(is.null(vec_ret), TRUE, 
                                is.na(match(x=-1, table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])))){

                        pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1

                        vec_ret <- c()

                        cnt_par = 0

                   } else{

                        vec_ret <- c(vec_ret, (pre_mtch[1]) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1)), 
                                     (pre_mtch[2] + length(vec_ret)))

                   }

                   paires = paires + 1

                   pre_paires = pre_paires + 1

                   pre_cls <- FALSE

                   lst_pos[par_] <- el

                   par_ = par_ + 1

           }

        }

        return(list(lst_par, lst_pos))

}

#' intersect_all
#' 
#' Allows to calculate the intersection between n vectors
#'
#' @param ... is all the vector you want to calculate the intersection from 
#' @examples
#'
#' print(intersect_all(c(1:5), c(1, 2, 3, 6), c(1:4)))
#' 
#' [1] 1 2 3
#'
#' @export

intersect_all <- function(...){
        rtn_v <- unlist(list(...)[1])

        if (length(rtn_v) > 1){
                for (el in list(...)[2:length(list(...))]){
                       rtn_v <- intersect(rtn_v, el) 
                }
        }

  return(rtn_v)
}

#' left_all
#'
#' Allow to apply left join on n dataframes, datatables, tibble
#'
#' @param ... are all the dataframes etc
#' @param keep_val is if you want to keep the id column
#' @param id_v is the common id of all the dataframes etc
#' @examples
#'
#' datf1 <- data.frame(
#'         "id1"=c(1:5),
#'         "var1"=c("oui", "oui", "oui", "non", "non")
#' )
#' 
#' datf2 <- data.frame(
#'         "id1"=c(1, 2, 3, 7, 9),
#'         "var1"=c("oui2", "oui2", "oui2", "non2", "non2")
#' )
#' 
#' print(left_all(datf1, datf2, datf2, datf2, keep_val=FALSE, id_v="id1"))
#' 
#'   id1 var1.x var1.y var1.x.x var1.y.y
#' 1   1    oui   oui2     oui2     oui2
#' 2   2    oui   oui2     oui2     oui2
#' 3   3    oui   oui2     oui2     oui2
#' 4   4    non   <NA>     <NA>     <NA>
#' 5   5    non   <NA>     <NA>     <NA>#'
#' print(left_all(datf1, datf2, datf2, keep_val=FALSE, id_v="id1"))
#' 
#'   id1 var1.x var1.y var1
#' 1   1    oui   oui2 oui2
#' 2   2    oui   oui2 oui2
#' 3   3    oui   oui2 oui2
#' 4   4    non   <NA> <NA>
#' 5   5    non   <NA> <NA>
#' 
#' @export

left_all <- function(..., keep_val=FALSE, id_v){
        cur_lst <- list(...)
        rtn_dt <- as.data.frame(cur_lst[1])
        if (length(list(...)) > 1){
                for (el in 2:length(cur_lst)){
                  rtn_dt <- left_join(
                                x = rtn_dt,
                                y = as.data.frame(cur_lst[el]),
                                by = id_v,
                                keep = keep_val
                  )
                }
        }
  return(rtn_dt)
}

#' inner_all
#'
#' Allow to apply inner join on n dataframes, datatables, tibble
#'
#' @param ... are all the dataframes etc
#' @param keep_val is if you want to keep the id column
#' @param id_v is the common id of all the dataframes etc
#' @examples
#'
#' datf1 <- data.frame(
#'         "id1"=c(1:5),
#'         "var1"=c("oui", "oui", "oui", "non", "non")
#' )
#' 
#' datf2 <- data.frame(
#'         "id1"=c(1, 2, 3, 7, 9),
#'         "var1"=c("oui2", "oui2", "oui2", "non2", "non2")
#' )
#' 
#' print(inner_all(datf1, datf2, keep_val=FALSE, id_v="id1"))
#' 
#' id1 var1.x var1.y
#' 1   1    oui   oui2
#' 2   2    oui   oui2
#' 3   3    oui   oui2
#'
#' @export

inner_all <- function(..., keep_val=FALSE, id_v){
        cur_lst <- list(...)
        rtn_dt <- as.data.frame(cur_lst[1])
        if (length(list(...)) > 1){
                for (el in 2:length(cur_lst)){
                        print(c(id_v[(el-1)], id_v[el]))
                  rtn_dt <- inner_join(
                                x = rtn_dt,
                                y = as.data.frame(cur_lst[el]),
                                by = id_v,
                                keep = keep_val
                  )
                }
        }
  return(rtn_dt)
}

#' join_n_lvl
#'
#' Allow to see the progress of the multi-level joins of the different variables modalities. Here, multi-level joins is a type of join that usually needs a concatenation of two or more variables to make a key. But here, there is no need to proceed to a concatenation. See examples. 
#'
#' @param frst_datf is the first data.frame (table)
#' @param scd_datf is the second data.frame (table)
#' @param lst_pair is a lis of vectors. The vectors refers to a multi-level join. Each vector should have a length of 1. Each vector should have a name. Its name refers to the column name of multi-level variable and its value refers to the column name of the join variable. 
#' @param join_type is a vector containing all the join type ("left", "inner", "right") for each variable
#' @examples
#' 
#' datf3 <- data.frame("vil"=c("one", "one", "one", "two", "two", "two"),
#'                      "charac"=c(1, 2, 2, 1, 2, 2),
#'                      "rev"=c(1250, 1430, 970, 1630, 2231, 1875),
#'                      "vil2" = c("one", "one", "one", "two", "two", "two"),
#'                      "idl2" = c(1:6))
#' datf4 <- data.frame("vil"=c("one", "one", "one", "two", "two", "three"),
#'                     "charac"=c(1, 2, 2, 1, 1, 2),
#'                      "rev"=c(1.250, 1430, 970, 1630, 593, 456),
#'                      "vil2" = c("one", "one", "one", "two", "two", "two"),
#'                      "idl2" = c(2, 3, 1, 5, 5, 5))
#' 
#' print(join_n_lvl(frst_datf=datf3, scd_datf=datf4, lst_pair=list(c("charac" = "vil"), c("vil2" = "idl2")), 
#'                  join_type=c("inner", "left")))
#'
#' [1] "pair: charac vil"
#' |  |   0%
#' 1 
#' |= |  50%
#' 2 
#' |==| 100%
#' [1] "pair: vil2 idl2"
#' |  |   0%
#' one 
#' |= |  50%
#' two 
#' |==| 100%
#' 
#'   main_id.x vil.x charac.x rev.x vil2.x idl2.x main_id.y vil.y charac.y rev.y
#' 1  1oneone1   one        1  1250    one      1      <NA>  <NA>       NA    NA
#' 2  2oneone2   one        2  1430    one      2      <NA>  <NA>       NA    NA
#' 3  2oneone3   one        2   970    one      3  2oneone3   one        2  1430
#' 4  1twotwo4   two        1  1630    two      4      <NA>  <NA>       NA    NA
#'   vil2.y idl2.y
#' 1   <NA>     NA
#' 2   <NA>     NA
#' 3    one      3
#' 4   <NA>     NA
#' 
#' @export

join_n_lvl <- function(frst_datf, scd_datf, join_type=c(),
                       lst_pair=list()){
  better_match <- function(inpt_v=c(), ptrn, untl=1, nvr_here=NA){
    Rtn_v <- c()
    for (cur_ptrn in ptrn){
      rtn_v <- c()
      cnt = 1
      stop <- FALSE
      while (length(rtn_v) < untl & cnt < (length(inpt_v) + 1) & !(stop)){
              pre_match <- match(x=cur_ptrn, table=inpt_v)
              if (!(is.na(pre_match))){
                inpt_v[pre_match] <- nvr_here
                rtn_v <- c(rtn_v, pre_match)
              }else{
                stop <- TRUE
              }
              cnt = cnt + 1
      }
      Rtn_v <- c(Rtn_v, rtn_v)
    }
    return(Rtn_v)
  }
  if (length(lst_pair) > 0){
    if (length(join_type) < length(lst_pair)){
      val_add <- join_type[length(join_type)]
      while (length(join_type) < (length(lst_pair) - 1)){
        join_type <- c(join_type, val_add)  
      }
    }
    frst_datf <- cbind(data.frame("main_id" = matrix(data="", 
                        nrow=nrow(frst_datf), ncol=1)), frst_datf)
    scd_datf <- cbind(data.frame("main_id" = matrix(data="", 
                        nrow=nrow(scd_datf), ncol=1)), scd_datf)
    colnames(frst_datf) <- paste0(colnames(frst_datf), ".x")
    colnames(scd_datf) <- paste0(colnames(scd_datf), ".y")
    stay_col <- colnames(frst_datf)
    cur_vec <- c()
    cur_datf <- NULL
    for (cl in 1:length(lst_pair)){
      frst_datf2 <- data.frame(matrix(data=NA, nrow=0, 
                      ncol=(ncol(scd_datf)+ncol(frst_datf))))
      cur_by <- unlist(lst_pair[cl])
      print(paste("pair:", names(cur_by), cur_by[1]))
      cur_col <- match(x=paste0(names(cur_by), ".x"), table=stay_col)
      cur_coly <- match(x=paste0(names(cur_by), ".y"), table=colnames(scd_datf))
      if (!(is.null(cur_datf))){
        scd_datf <- frst_datf[, (length(stay_col) + 1):ncol(frst_datf)]
        frst_datf <- frst_datf[, 1:length(stay_col)]
      }
      frst_datf$main_id.x <- paste0(frst_datf$main_id.x, frst_datf[, 
                        match(x=paste0(names(cur_by), ".x"), table=stay_col)])
      frst_datf$main_id.x <- paste0(frst_datf$main_id.x, frst_datf[, 
                        match(x=paste0(cur_by[1], ".x"), table=stay_col)])
      scd_datf$main_id.y <- paste0(scd_datf$main_id.y, scd_datf[, 
                                match(x=paste0(names(cur_by), ".y"), table=colnames(scd_datf))])
      scd_datf$main_id.y <- paste0(scd_datf$main_id.y, scd_datf[, 
                                match(x=paste0(cur_by[1], ".y"), table=colnames(scd_datf))])
      if (join_type[cl] == "left"){
        keep_r <- better_match(ptrn = unique(frst_datf[, cur_col]), 
                         inpt_v = scd_datf[, cur_coly], untl = nrow(scd_datf))
        scd_datf <- scd_datf[keep_r, ]
        uncf <- unique(frst_datf[, cur_col])
        pb <- txtProgressBar(min = 0,
                     max = length(uncf),
                     style = 3,
                     width = length(uncf), 
                     char = "=")
        cat("\n")
        for (rws in 1:length(uncf)){
          cur_datf <- left_join(
            x = frst_datf[frst_datf[, cur_col] == uncf[rws], ], 
            y = scd_datf[scd_datf[, cur_coly] == uncf[rws], ],
            keep = TRUE,
            by = c("main_id.x" = "main_id.y"),
            multiple = "first"
          )
          cat(uncf[rws], "\n")
          setTxtProgressBar(pb, rws)
          cat("\n")
          frst_datf2 <- rbind(frst_datf2, cur_datf)
        }
        frst_datf <- frst_datf2
      }else if (join_type[cl] == "inner"){
        keep_r <- better_match(ptrn = unique(frst_datf[, cur_col]), 
                         inpt_v = scd_datf[, cur_coly], untl = nrow(scd_datf))
        scd_datf <- scd_datf[keep_r, ]        
        uncf <- unique(frst_datf[, cur_col])
        pb <- txtProgressBar(min = 0,
                     max = length(uncf),
                     style = 3,
                     width = length(uncf), 
                     char = "=")
        cat("\n")
        for (rws in 1:length(uncf)){
          cur_datf <- inner_join(
            x = frst_datf[frst_datf[, cur_col] == uncf[rws], ], 
            y = scd_datf[scd_datf[, cur_coly] == uncf[rws], ],
            keep = TRUE,
            by = c("main_id.x" = "main_id.y"),
            multiple = "first"
          )
          cat(uncf[rws], "\n")
          setTxtProgressBar(pb, rws)
          cat("\n")
          frst_datf2 <- rbind(frst_datf2, cur_datf)
        }
        frst_datf <- frst_datf2
      }else if (join_type[cl] == "right"){
        keep_r <- better_match(ptrn = unique(scd_datf[, cur_coly]), 
                         inpt_v = frst_datf[, cur_col], untl = nrow(scd_datf))
        frst_datf <- frst_datf[keep_r, ]
        uncf <- unique(scd_datf[, cur_coly])
        pb <- txtProgressBar(min = 0,
                     max = length(uncf),
                     style = 3,
                     width = length(uncf), 
                     char = "=")
        cat("\n")
        for (rws in 1:length(uncf)){
          cur_datf <- right_join(
            x = frst_datf[frst_datf[, cur_col] == uncf[rws], ], 
            y = scd_datf[scd_datf[, cur_coly] == uncf[rws], -cur_coly],
            keep = TRUE,
            by = c("main_id.x" = "main_id.y"),
            multiple = "first"
          )
          cat(uncf[rws], "\n")
          setTxtProgressBar(pb, rws)
          cat("\n")
          frst_datf2 <- rbind(frst_datf2, cur_datf)
        }
        frst_datf <- frst_datf2
      }else {
        return(NULL)
      }
    }
    close(pb)
    return(frst_datf2)
  }else{
    return(NULL)
  }
}

#' pairs_findr_merger
#'
#' Takes two different outputs from pairs_findr and merge them. Can be usefull when the pairs consists in different patterns, for example one output from the pairs_findr function with ptrn1 = "(" and ptrn2 = ")", and a second output from the pairs_findr function with ptrn1 = "[" and ptrn2 = "]".
#'
#' @param lst1 is the first ouput from pairs findr function
#' @param lst2 is the second ouput from pairs findr function
#' @examples
#'
#' print(pairs_findr_merger(lst1=list(c(1, 2, 3, 3, 2, 1), c(3, 4, 5, 7, 8, 9)), 
#'                          lst2=list(c(1, 1), c(1, 2))))
#' 
#' [[1]]
#' [1] 1 1 2 3 4 4 3 2
#' 
#' [[2]]
#' [1] 1 2 3 4 5 7 8 9
#' 
#' print(pairs_findr_merger(lst1=list(c(1, 2, 3, 3, 2, 1), c(3, 4, 5, 7, 8, 9)), 
#'                          lst2=list(c(1, 1), c(1, 11))))
#' 
#' [[1]]
#' [1] 1 2 3 4 4 3 2 1
#' 
#' [[2]]
#' [1]  1  3  4  5  7  8  9 11
#' 
#' print(pairs_findr_merger(lst1=list(c(1, 2, 3, 3, 2, 1), c(3, 4, 5, 8, 10, 11)), 
#'                          lst2=list(c(4, 4), c(6, 7))))
#'
#' [[1]]
#' [1] 1 2 3 4 4 3 2 1
#' 
#' [[2]]
#' [1]  3  4  5  6  7  8 10 11
#' 
#' print(pairs_findr_merger(lst1=list(c(1, 2, 3, 3, 2, 1), c(3, 4, 5, 7, 10, 11)), 
#'                          lst2=list(c(4, 4), c(8, 9))))
#' 
#' [[1]]
#' [1] 1 2 3 3 4 4 2 1
#' 
#' [[2]]
#' [1]  3  4  5  7  8  9 10 11
#' 
#' print(pairs_findr_merger(lst1=list(c(1, 2, 3, 3, 2, 1), c(3, 4, 5, 7, 10, 11)), 
#'                          lst2=list(c(4, 4), c(18, 19))))
#'
#' [[1]]
#' [1] 1 2 3 3 2 1 4 4
#' 
#' [[2]]
#' [1]  3  4  5  7 10 11 18 19
#'
#' print(pairs_findr_merger(lst1 = list(c(1, 1, 2, 2, 3, 3), c(1, 25, 26, 32, 33, 38)), 
#'                         lst2 = list(c(1, 1, 2, 2, 3, 3), c(7, 11, 13, 17, 19, 24))))
#'
#' [[1]]
#'  [1] 1 2 2 3 3 4 4 1 5 5 6 6
#' 
#' [[2]]
#'  [1]  1  7 11 13 17 19 24 25 26 32 33 38
#'
#' print(pairs_findr_merger(lst1 = list(c(1, 1, 2, 2, 3, 3), c(2, 7, 9, 10, 11, 15)), 
#'                          lst2 = list(c(3, 2, 1, 1, 2, 3, 4, 4), c(1, 17, 18, 22, 23, 29, 35, 40))))
#'
#' [[1]]
#'  [1] 6 5 1 1 2 2 3 3 4 4 5 6 7 7
#' 
#' [[2]]
#'  [1]  1  2  7  9 10 11 15 17 18 22 23 29 35 40
#'
#' print(pairs_findr_merger(lst1 = list(c(1, 1), c(22, 23)), 
#'                          lst2 = list(c(1, 1, 2, 2), c(3, 21, 27, 32))))
#'
#' [[1]]
#' [1] 1 1 2 2 3 3
#' 
#' [[2]]
#' [1]  3 21 22 23 27 32
#'
#' @export

pairs_findr_merger <- function(lst1=list(), lst2=list()){
    better_match <- function(inpt_v=c(), ptrn, untl=1, nvr_here=NA){
      Rtn_v <- c()
      if (length(untl) < length(ptrn)){
        val_add <- untl[length(untl)]
        while (length(untl) < length(ptrn)){
          untl <- c(untl, val_add)
        }
      }
      for (cur_ptrn in 1:length(ptrn)){
        rtn_v <- c()
        cnt = 1
        stop <- FALSE
        while (length(rtn_v) < untl[cur_ptrn] & cnt < (length(inpt_v) + 1) & !(stop)){
                pre_match <- match(x=ptrn[cur_ptrn], table=inpt_v)
                if (!(is.na(pre_match))){
                  inpt_v[pre_match] <- nvr_here
                  rtn_v <- c(rtn_v, pre_match)
                }else{
                  stop <- TRUE
                }
                cnt = cnt + 1
        }
        Rtn_v <- c(Rtn_v, rtn_v)
      }
      return(Rtn_v)
    }
    pair1 <- unlist(lst1[1])
    pos1 <- unlist(lst1[2])
    pair2 <- unlist(lst2[1])
    pos2 <- unlist(lst2[2])
    stop <- FALSE
    cnt = 1
    while (!(stop)){
      mtch1 <- match(x = cnt, table = pair1)
      mtch2 <- match(x = cnt, table = pair2)
      if (all(!(is.na(mtch1)), !(is.na(mtch2)))){
        if (pos1[mtch1] < pos2[mtch2]){
          poses <- better_match(inpt_v = pair2, ptrn = c(cnt:max(pair2)), untl = 2)
          pair2[poses] <- pair2[poses] + 1
        }else{
          poses <- better_match(inpt_v = pair1, ptrn = c(cnt:max(pair1)), untl = 2)
          pair1[poses] <- pair1[poses] + 1
        }
      }else{
        stop <- TRUE
      }
      cnt = cnt + 1
    }
    if (length(pair1) > length(pair2)){
      rtn_pos <- pos1
      rtn_pair <- pair1
      add_pos <- pos2
      add_pair <- pair2
    }else{
      rtn_pos <- pos2
      rtn_pair <- pair2
      add_pos <- pos1
      add_pair <- pair1
    }
    cnt = 1
    stop <- FALSE
    pre_lngth <- length(rtn_pos)
    while (cnt <= (pre_lngth / 2 + length(add_pair) / 2) & !(stop)){
      if (is.na(match(x = cnt, table = rtn_pair))){
          cur_add_pos_id <- grep(x = add_pair, pattern = cnt)
          if (cnt < max(rtn_pair)){
            incr = 1
            cur_grep <- grep(x = rtn_pair, pattern = (cnt + incr))
            while (identical(integer(0), cur_grep)){
                incr = incr + 1
                cur_grep <- grep(x = rtn_pair, pattern = (cnt + incr))
            }
            if (rtn_pos[cur_grep[2]] < add_pos[cur_add_pos_id[2]] & 
                rtn_pos[cur_grep[1]] > add_pos[cur_add_pos_id[1]]){
              rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
              cur_vec <- abs(rtn_pos - add_pos[cur_add_pos_id[2]])
              cur_pos <- which.min(cur_vec)
              rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_pos + 1))
              rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
              rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_pos + 1))
            }else{
              if (!(is.na(match(x = (cnt - 1), table = rtn_pair)))){
                    cur_grep2 <- grep(x = rtn_pair, pattern = (cnt - 1))
                    if (rtn_pos[cur_grep2[2]] > add_pos[cur_add_pos_id[2]]){
                      rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep2[1])
                      rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep2[1] + 1))
                      rtn_pos <- append(x = rtn_pos, 
                                        value = add_pos[cur_add_pos_id[1]], after = cur_grep2[1])
                      rtn_pos <- append(x = rtn_pos, 
                                        value = add_pos[cur_add_pos_id[2]], after = (cur_grep2[1] + 1))
                    }else{
                      rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                      rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                      rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                      rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_grep[1] - 1))
                    }
              }else{
                rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_grep[1] - 1))
              }
            }
          }else{
            incr = 1
            cur_grep <- grep(x = rtn_pair, pattern = (cnt - incr))
            while (identical(integer(0), cur_grep)){
              incr = incr + 1
              cur_grep <- grep(x = rtn_pair, pattern = (cnt - incr))
            }
            if (rtn_pos[cur_grep[2]] < add_pos[cur_add_pos_id[1]]){
              cur_vec <- abs(rtn_pos - add_pos[cur_add_pos_id[1]])
              cur_pos <- which.min(cur_vec)
              rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_pos)
              rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_pos + 1))
              rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = cur_pos)
              rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_pos + 1))
            }else{
              rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep[1])
              rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep[1])
              rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = cur_grep[1])
              rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = cur_grep[1])
            }
          }
      }
      cnt = cnt + 1
    }
    return(list(rtn_pair, sort(rtn_pos)))
}

#' nb_follow
#'
#' Allow to get the number of certains patterns that may be after an index of a vector continuously, see examples
#'
#' @param inpt_v is the input vector
#' @param inpt_idx is the index
#' @param inpt_follow_v is a vector containing all the potential patterns that may follow the element in the vector at the index inpt_idx
#' @examples
#'
#' print(nb_follow(inpt_v = c(1:13), inpt_idx = 6, inpt_follow_v = c(5:9)))
#' 
#' [1] 3
#'
#' print(nb_follow(inpt_v = c("ou", "nn", "pp", "zz", "zz", "ee", "pp"), inpt_idx = 2, 
#'                 inpt_follow_v = c("pp", "zz")))
#'
#' [1] 3
#' 
#' @export

nb_follow <- function(inpt_v, inpt_idx, inpt_follow_v = c()){
  rtn <- 0
  pattern_v <- c()
  inpt_idx = inpt_idx + 1
  while (inpt_v[inpt_idx] %in% inpt_follow_v){
    inpt_idx = inpt_idx + 1
    rtn = rtn  + 1
  }
  return(rtn)
}

#' nb2_follow
#'
#' Allows to get the number and pattern of potential continuous pattern after an index of a vector, see examples
#' 
#' @param inpt_v is the input vector
#' @param inpt_idx is the index
#' @param inpt_follow_v is a vector containing the patterns that are potentially just after inpt_nb
#' @examples
#'
#' print(nb2_follow(inpt_v = c(1:12), inpt_idx = 4, inpt_follow_v = c(5)))
#' 
#' [1] 1 5
#' # we have 1 times the pattern 5 just after the 4nth index of inpt_v
#' 
#' print(nb2_follow(inpt_v = c(1, "non", "oui", "oui", "oui", "nop", 5), inpt_idx = 2, inpt_follow_v = c("5", "oui")))
#'
#' [1] "3"   "oui"
#'
#' # we have 3 times continuously the pattern 'oui' and 0 times the pattern 5 just after the 2nd index of inpt_v
#'
#' print(nb2_follow(inpt_v = c(1, "non", "5", "5", "5", "nop", 5), inpt_idx = 2, inpt_follow_v = c("5", "oui")))
#'
#' [1] "3" "5"
#'
#' @export

nb2_follow <- function(inpt_v, inpt_idx, inpt_follow_v = c()){
  rtn <- 0
  pattern_ = NA
  inpt_idx = inpt_idx + 1
  for (ptrn in inpt_follow_v){
     cnt = 0
     while (ptrn == inpt_v[inpt_idx]){
       inpt_idx = inpt_idx + 1
       cnt = cnt + 1
     }
     if (cnt > 0){
       rtn = rtn + cnt
       pattern_ <- ptrn
     }
  }
  return(c(rtn, pattern_))
}

#' depth_pairs_findr
#'
#' Takes the pair vector as an input and associate to each pair a level of depth, see examples
#'
#' @param inpt is the pair vector
#' @examples 
#'
#' print(depth_pairs_findr(c(1, 1, 2, 3, 3, 4, 4, 2, 5, 6, 7, 7, 6, 5)))
#'
#'  [1] 1 1 1 2 2 2 2 1 1 2 3 3 2 1
#'
#' @export

depth_pairs_findr <- function(inpt){
  rtn_v <- c(matrix(data = 0, nrow = length(inpt), ncol = 1))
  all_pair <- c(matrix(data = 0, nrow = length(unique(inpt)), ncol = 1))
  alrd_here <- c()
  cnt = 1
  cnt2 = 1
  while (cnt2 < length(rtn_v)){
    if (inpt[cnt2]  == inpt[(cnt2 + 1)]){
      rtn_v[grep(x = inpt, pattern = inpt[cnt2])] <- cnt
      cnt2 = cnt2 + 2
    }else if (!(is.na(match(x = inpt[cnt2], table = alrd_here)))){
      cnt = cnt - 1
      rtn_v[grep(x = inpt, pattern = inpt[cnt2])] <- cnt
      cnt2 = cnt2 + 1
    }else{
      cnt = cnt + 1
      alrd_here <- c(alrd_here, inpt[cnt2])
      cnt2 = cnt2 + 1
    }
  }
  if (rtn_v[length(rtn_v)] == 0){
    rtn_v[grep(x = rtn_v, pattern = 0)] <- 1
  }
  return(rtn_v)
}

#' better_split
#'
#' Allows to split a string by multiple split, returns a vector and not a list.
#' @param inpt is the input character
#' @param split_v is the vector containing the splits
#' @examples
#'
#' print(better_split(inpt = "o-u_i", split_v = c("-")))
#' 
#' [1] "o"   "u_i"
#'
#' print(better_split(inpt = "o-u_i", split_v = c("-", "_")))
#'
#' [1] "o" "u" "i"
#'
#' @export

better_split <- function(inpt, split_v = c()){
  for (split in split_v){
    pre_inpt <- inpt
    inpt <- c()
    for (el in pre_inpt){
      inpt <- c(inpt, unlist(strsplit(x = el, split = split)))
    }
  }
  return(inpt)
}

#' pre_to_post_idx
#'
#' Allow to convert indexes from a pre-vector to post-indexes based on a current vector, see examples
#'
#' @param inpt_idx is the vector containing the pre-indexes 
#' @param inpt_v is the new vector
#' @examples
#'
#' print(pre_to_post_idx(inpt_v = c("oui", "no", "eee"), inpt_idx = c(1:8)))
#' 
#' [1] 1 1 1 2 2 3 3 3
#'
#' As if the first vector was c("o", "u", "i", "n", "o", "e", "e", "e")
#'
#' @export

pre_to_post_idx <- function(inpt_v = c(), inpt_idx = c(1:length(inppt_v))){
  rtn_v <- c()
  cur_step = nchar(inpt_v[1])
  cnt = 1
  for (idx in 1:length(inpt_idx)){
    if (inpt_idx[idx] > cur_step){
      cnt = cnt + 1
      cur_step = cur_step + nchar(inpt_v[cnt])
    }
    rtn_v <- c(rtn_v, cnt)
  }
  return(rtn_v)
}

#' pairs_insertr
#'
#' Takes a character representing an arbitrary condition (like ReGeX for example) or an information (to a parser for example), vectors containing all the pair of pattern that potentially surrounds condition (flagged_pair_v and corr_v), and a vector containing all the conjuntion character, as input and returns the character with all or some of the condition surrounded by the pair characters. See examples. All the pair characters are inserted according to the closest pair they found priotizing those found next to the condition and on the same depth-level and , if not found, the pair found at the n+1 depth-level.
#'
#' @param inpt is the input character representing an arbitrary condition, like ReGex for example, or information to a parser for example
#' @param algo_used is a vector containing one or more of the 3 algorythms used. The first algorythm will simply put the pair of parenthesis at the condition surrounded and/or after a character flagged (in flagged_conj_v) as a conjunction. The second algorythm will put parenthesis at the condition that are located after other conditions that are surrounded by a pair. The third algorythm will put a pair at all the condition, it is very powerfull but takes a longer time. See examples and make experience to see which combination of algorythm(s) is the most efficient for your use case.
#' @param flagged_pair_v is a vector containing all the first character of the pairs
#' @param corr_v is a vector containing all the last character of the pairs
#' @param flagged_conj_v is a vector containing all the conjunction character
#' @examples
#'
#' print(pairs_insertr(inpt = "([one]|two|twob)three(four)", algo_used = c(1)))
#' 
#' [1] "([one]|[two]|[twob])three(four)"
#'
#' print(pairs_insertr(inpt = "(one|[two]|twob)three(four)", algo_used = c(2)))
#'
#' [1] "(one|[two]|[twob])(three)(four)"
#' 
#' print(pairs_insertr(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(1, 2)))
#'
#' [1] "(oneA|[one]|[two]|[twob])(three)(four)"
#'
#' print(pairs_insertr(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(1, 2, 3)))
#'
#' [1] "([oneA]|[one]|[two]|[twob])(three)(four)"
#'
#' print(pairs_insertr(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(3)))
#'
#' [1] "([oneA]|[one]|(two)|(twob))(three)(four)"
#' 
#' print(pairs_insertr(inpt = "(oneA|[one]|two|twob)three((four))", algo_used = c(3)))
#' 
#' [1] "([oneA]|[(one)]|(two)|(twob))(three)((four))"
#'
#' @export

pairs_insertr <- function(inpt, algo_used = c(1:3), flagged_pair_v = c(")", "]"), corr_v = c("(", "["), flagged_conj_v = c("&", "|")){
  inpt <- unlist(strsplit(x = inpt, split = ""))
  cur_vec <- c(flagged_pair_v, flagged_conj_v, corr_v)
  if (1 %in% algo_used){
    frst_val <- "("
    scd_val <- ")"
    cnt = 1
    while (cnt < length(inpt)){
      mtch_pair <- match(x = inpt[cnt], table = corr_v)
      if (!(is.na(mtch_pair))){ 
        frst_val <- corr_v[mtch_pair]
        scd_val <- flagged_pair_v[mtch_pair]
      }
      if (inpt[cnt] %in% flagged_conj_v & is.na(match(x = inpt[(cnt + 1)] , table = corr_v))){
        inpt <- append(x = inpt, value = frst_val, after = cnt)
        cnt = cnt + 2
        stop <- FALSE
        while (cnt < length(inpt) & !(stop)){
          if (is.na(match(x = inpt[cnt], table = cur_vec))){
            cnt = cnt + 1
          }else{
            stop <- TRUE
          }
        }
        inpt <- append(x = inpt, value = scd_val, after = (cnt - 1))
      }
      cnt = cnt + 1
    }
  }
  if (2 %in% algo_used){
    cnt = 1
    while (cnt < length(inpt)){
      cur_mtch <- match(table = flagged_pair_v, x = inpt[cnt])
      if (!(is.na(cur_mtch)) & is.na(match(x = inpt[(cnt + 1)], table = flagged_pair_v))){
          if (!(is.na(match(x = inpt[(cnt + 1)], table = flagged_conj_v)))){
            cnt = cnt + 1
          } 
         if (is.na(match(x = inpt[(cnt + 1)], table = corr_v))){
            inpt <- append(x = inpt, value = corr_v[cur_mtch[1]], after = cnt)
            cnt = cnt + 2
            stop <- FALSE
            while (cnt <= length(inpt) & !(stop)){
              if (is.na(match(x = inpt[cnt], table = cur_vec))){
                cnt = cnt + 1
              }else{
                stop <- TRUE
              }
            }
            inpt <- append(x = inpt, value = flagged_pair_v[cur_mtch[1]], after = (cnt - 1))
          }
      }
      cnt = cnt + 1
    }
  }
  if (3 %in% algo_used){
    depth_pairs_findr <- function(inpt){
        rtn_v <- c(matrix(data = 0, nrow = length(inpt), ncol = 1))
        all_pair <- c(matrix(data = 0, nrow = length(unique(inpt)), ncol = 1))
        alrd_here <- c()
        cnt = 1
        cnt2 = 1
        while (cnt2 < length(rtn_v)){
          if (inpt[cnt2]  == inpt[(cnt2 + 1)]){
            rtn_v[grep(x = inpt, pattern = inpt[cnt2])] <- cnt
            cnt2 = cnt2 + 2
          }else if (!(is.na(match(x = inpt[cnt2], table = alrd_here)))){
            cnt = cnt - 1
            rtn_v[grep(x = inpt, pattern = inpt[cnt2])] <- cnt
            cnt2 = cnt2 + 1
          }else{
            cnt = cnt + 1
            alrd_here <- c(alrd_here, inpt[cnt2])
            cnt2 = cnt2 + 1
          }
        }
        if (rtn_v[length(rtn_v)] == 0){
          rtn_v[grep(x = rtn_v, pattern = 0)] <- 1
        }
        return(rtn_v)
      }
    pairs_findr <- function(inpt, ptrn1="(", ptrn2=")"){
      regex_spe_detect <- function(inpt){
          fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
            ptrn <- grep(ptrn_fill, inpt_v)
            while (length(ptrn) > 0){
              ptrn <- grep(ptrn_fill, inpt_v)
              idx <- ptrn[1] 
              untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
              pre_val <- inpt_v[(idx - 1)]
              inpt_v[idx] <- pre_val
              if (untl > 0){
                for (i in 1:untl){
                  inpt_v <- append(inpt_v, pre_val, idx)
                }
              }
            ptrn <- grep(ptrn_fill, inpt_v)
            }
            return(inpt_v)
          }
          inpt <- unlist(strsplit(x=inpt, split=""))
          may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
          pre_idx <- unique(match(x=inpt, table=may_be_v))
          pre_idx <- pre_idx[!(is.na(pre_idx))]
          for (el in may_be_v[pre_idx]){
                  cnt = 0
                  for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                          inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                          cnt = cnt + 1
                  }
          }
          return(paste(inpt, collapse=""))
      }
      lst <- unlist(strsplit(x=inpt, split=""))
      lst_par <- c()
      lst_par_calc <- c()
      lst_pos <- c()
      paires = 1
      pre_paires = 1
      pre_paires2 = 1
      if ((length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2) > 0){
              for (i in 1:(length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2)){ 
                      lst_par <- c(lst_par, 0)
                      lst_par_calc <- c(lst_par_calc, 0)
                      lst_pos <- c(lst_pos, 0)
              }
      }
      vec_ret <- c()
      par_ = 1
      lvl_par = 0
      for (el in 1:length(lst)){
         if (lst[el] == ptrn1){
                 if (!(is.null(vec_ret))){
                         lst_par_calc[pre_paires2:pre_paires][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] + 1
                 }else{
                         lst_par_calc[pre_paires2:pre_paires] <- lst_par_calc[pre_paires2:pre_paires] + 1
                 }
                 pre_paires = pre_paires + 1
                 pre_cls <- TRUE
                 lst_pos[par_] <- el
                 par_ = par_ + 1
                 lvl_par = lvl_par + 1
         }
         if (lst[el] == ptrn2){
                 lvl_par = lvl_par - 1
                 if (!(is.null(vec_ret))){
                      lst_par_calc[c(pre_paires2:pre_paires)][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] - 1
                      pre_val <- lst_par_calc[pre_paires2:pre_paires][vec_ret]
                      lst_par_calc[pre_paires2:pre_paires][vec_ret] <- (-2)
                 }else{
                      lst_par_calc[c(pre_paires2:pre_paires)] <- lst_par_calc[pre_paires2:pre_paires] - 1
                 }
                 if (!(is.null(vec_ret))){ 
                         pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])
                         lst_par_calc[pre_paires2:pre_paires][vec_ret] <- pre_val 
                 }else{
                         pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires])
                 }
                 cnt_par = 1
                 cnt2 = 0
                 if (!(is.null(vec_ret))){
                         vec_ret <- sort(vec_ret)
                         if (pre_mtch[1] >= min(vec_ret)){
                              cnt2 = 2
                              while (pre_mtch[1] > cnt_par & cnt2 <= length(vec_ret)){
                                      if ((vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) > 1){
                                              cnt_par = cnt_par + (vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) - 1
                                      }
                                      cnt2 = cnt2 + 1
                              }
                              if (pre_mtch[1] > cnt_par){
                                      cnt_par = length(vec_ret) / 2 + 1
                              }
                              cnt2 = cnt2 - 1
                         }
                 }
                 lst_par[pre_mtch[1] + (pre_paires2 - 1) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1))] <- paires 
                 lst_par[pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret)] <- paires 
                 if ((pre_mtch[1] + (pre_paires2 - 1)) == 1){
                      pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
                      vec_ret <- c()
                      cnt_par = 0
                 } else if (lst_par_calc[(pre_mtch[1] + (pre_paires2 - 1) - 1)] == -1 & ifelse(is.null(vec_ret), TRUE, 
                              is.na(match(x=-1, table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])))){

                      pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
                      vec_ret <- c()
                      cnt_par = 0
                 } else{
                      vec_ret <- c(vec_ret, (pre_mtch[1]) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1)), 
                                   (pre_mtch[2] + length(vec_ret)))
                 }
                 paires = paires + 1
                 pre_paires = pre_paires + 1
                 pre_cls <- FALSE
                 lst_pos[par_] <- el
                 par_ = par_ + 1
         }
      }
      return(list(lst_par, lst_pos))
      }
      pairs_findr_merger <- function(lst1=list(), lst2=list()){
        better_match <- function(inpt_v=c(), ptrn, untl=1, nvr_here=NA){
          Rtn_v <- c()
          if (length(untl) < length(ptrn)){
            val_add <- untl[length(untl)]
            while (length(untl) < length(ptrn)){
              untl <- c(untl, val_add)
            }
          }
          for (cur_ptrn in 1:length(ptrn)){
            rtn_v <- c()
            cnt = 1
            stop <- FALSE
            while (length(rtn_v) < untl[cur_ptrn] & cnt < (length(inpt_v) + 1) & !(stop)){
                    pre_match <- match(x=ptrn[cur_ptrn], table=inpt_v)
                    if (!(is.na(pre_match))){
                      inpt_v[pre_match] <- nvr_here
                      rtn_v <- c(rtn_v, pre_match)
                    }else{
                      stop <- TRUE
                    }
                    cnt = cnt + 1
            }
            Rtn_v <- c(Rtn_v, rtn_v)
          }
          return(Rtn_v)
        }
        pair1 <- unlist(lst1[1])
        pos1 <- unlist(lst1[2])
        pair2 <- unlist(lst2[1])
        pos2 <- unlist(lst2[2])
        stop <- FALSE
        cnt = 1
        while (!(stop)){
          mtch1 <- match(x = cnt, table = pair1)
          mtch2 <- match(x = cnt, table = pair2)
          if (all(!(is.na(mtch1)), !(is.na(mtch2)))){
            if (pos1[mtch1] < pos2[mtch2]){
              poses <- better_match(inpt_v = pair2, ptrn = c(cnt:max(pair2)), untl = 2)
              pair2[poses] <- pair2[poses] + 1
            }else{
              poses <- better_match(inpt_v = pair1, ptrn = c(cnt:max(pair1)), untl = 2)
              pair1[poses] <- pair1[poses] + 1
            }
          }else{
            stop <- TRUE
          }
          cnt = cnt + 1
        }
        if (length(pair1) > length(pair2)){
          rtn_pos <- pos1
          rtn_pair <- pair1
          add_pos <- pos2
          add_pair <- pair2
        }else{
          rtn_pos <- pos2
          rtn_pair <- pair2
          add_pos <- pos1
          add_pair <- pair1
        }
        cnt = 1
        stop <- FALSE
        pre_lngth <- length(rtn_pos)
        while (cnt <= (pre_lngth / 2 + length(add_pair) / 2) & !(stop)){
          if (is.na(match(x = cnt, table = rtn_pair))){
              cur_add_pos_id <- grep(x = add_pair, pattern = cnt)
              if (cnt < max(rtn_pair)){
                incr = 1
                cur_grep <- grep(x = rtn_pair, pattern = (cnt + incr))
                while (identical(integer(0), cur_grep)){
                    incr = incr + 1
                    cur_grep <- grep(x = rtn_pair, pattern = (cnt + incr))
                }
                if (rtn_pos[cur_grep[2]] < add_pos[cur_add_pos_id[2]] & 
                    rtn_pos[cur_grep[1]] > add_pos[cur_add_pos_id[1]]){
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                  cur_vec <- abs(rtn_pos - add_pos[cur_add_pos_id[2]])
                  cur_pos <- which.min(cur_vec)
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_pos + 1))
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_pos + 1))
                }else{
                  if (!(is.na(match(x = (cnt - 1), table = rtn_pair)))){
                        cur_grep2 <- grep(x = rtn_pair, pattern = (cnt - 1))
                        if (rtn_pos[cur_grep2[2]] > add_pos[cur_add_pos_id[2]]){
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep2[1])
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep2[1] + 1))
                          rtn_pos <- append(x = rtn_pos, 
                                            value = add_pos[cur_add_pos_id[1]], after = cur_grep2[1])
                          rtn_pos <- append(x = rtn_pos, 
                                            value = add_pos[cur_add_pos_id[2]], after = (cur_grep2[1] + 1))
                        }else{
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                          rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                          rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_grep[1] - 1))
                        }
                  }else{
                    rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                    rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                    rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                    rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_grep[1] - 1))
                  }
                }
              }else{
                incr = 1
                cur_grep <- grep(x = rtn_pair, pattern = (cnt - incr))
                while (identical(integer(0), cur_grep)){
                  incr = incr + 1
                  cur_grep <- grep(x = rtn_pair, pattern = (cnt - incr))
                }
                if (rtn_pos[cur_grep[2]] < add_pos[cur_add_pos_id[1]]){
                  cur_vec <- abs(rtn_pos - add_pos[cur_add_pos_id[1]])
                  cur_pos <- which.min(cur_vec)
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_pos)
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_pos + 1))
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = cur_pos)
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_pos + 1))
                }else{
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep[1])
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep[1])
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = cur_grep[1])
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = cur_grep[1])
                }
              }
          }
          cnt = cnt + 1
        }
        return(list(rtn_pair, sort(rtn_pos)))
      }
    cur_lst <-  pairs_findr(inpt = inpt, ptrn1 = corr_v[1], ptrn2 = flagged_pair_v[1])
    if (length(corr_v) > 1){
      for (pair in 2:length(corr_v)){
        cur_fun <- pairs_findr(inpt = inpt, ptrn1 = corr_v[pair], ptrn2 = flagged_pair_v[pair]) 
        cur_lst <- pairs_findr_merger(lst1 = cur_lst, lst2 = cur_fun)
      }
    }
    lst_pair <- unlist(cur_lst[1])
    lst_pos <- unlist(cur_lst[2])
    cur_depth <- depth_pairs_findr(inpt = unlist(cur_lst[1])) 
    frst_val <- "("
    scd_val <- ")"
    par = 2
    while (par <= length(lst_pair)){
      mtch_pair <- match(x = inpt[lst_pos[par]], table = corr_v)
      if (!(is.na(mtch_pair))){
        frst_val <- corr_v[mtch_pair] 
        scd_val <- flagged_pair_v[mtch_pair]
      }
      if (lst_pair[(par - 1)] != lst_pair[par] & abs(lst_pos[(par - 1)] - lst_pos[par]) > 1){
        cnt = lst_pos[(par - 1)]
        ahd <- TRUE
        if (!(is.na(match(x = inpt[(lst_pos[(par - 1)] + 1)], table = flagged_conj_v)))){
          if (abs(lst_pos[(par - 1)] - lst_pos[par]) == 2){
            ahd <- FALSE
          }
          else{
            cnt = cnt + 1
          }
        }
        if (ahd){
          if (par < (length(cur_depth) - 1)){
            if (cur_depth[(par + 2)] == cur_depth[(par + 1)]){
              mtch_pair <- match(x = inpt[lst_pos[(par + 1)]] , table = flagged_pair_v)
              if (is.na(mtch_pair)){
                mtch_pair <- match(x = inpt[lst_pos[(par + 1)]] , table = corr_v)
              }
              frst_val <- corr_v[mtch_pair]
              scd_val <- flagged_pair_v[mtch_pair]
            }
          }
          inpt <- append(x = inpt, value = frst_val, after = cnt)
          cnt = cnt + 2
          stop <- FALSE
          while (!(stop) & cnt <= length(inpt)){
            if (is.na(match(x = inpt[cnt], table = cur_vec))){
              cnt = cnt + 1
            }else{
              stop <- TRUE
            }
          }
          inpt <- append(x = inpt, value = scd_val, after = (cnt - 1))
          cur_lst <-  pairs_findr(inpt = inpt, ptrn1 = corr_v[1], ptrn2 = flagged_pair_v[1])
          if (length(corr_v) > 1){
             for (pair in 2:length(corr_v)){
               cur_fun <- pairs_findr(inpt = inpt, ptrn1 = corr_v[pair], ptrn2 = flagged_pair_v[pair]) 
               cur_lst <- pairs_findr_merger(lst1 = cur_lst, lst2 = cur_fun)
             }
          }
          lst_pair <- unlist(cur_lst[1])
          lst_pos <- unlist(cur_lst[2])
          cur_depth <- depth_pairs_findr(inpt = unlist(cur_lst[1]))
        }
      }
      par = par + 1
    }
  }
  return(paste(inpt, collapse = ""))
}


#' pairs_insertr2
#'
#' Takes a character representing an arbitrary condition (like ReGeX for example) or an information (to a parser for example), vectors containing all the pair of pattern that potentially surrounds condition (flagged_pair_v and corr_v), and a vector containing all the conjuntion character, as input and returns the character with all or some of the condition surrounded by the pair characters. See examples. All the pair characters are inserted according to the closest pair they found priotizing those found next to the condition and on the same depth-level and , if not found, the pair found at the n+1 depth-level.
#'
#' @param inpt is the input character representing an arbitrary condition, like ReGex for example, or information to a parser for example
#' @param algo_used is a vector containing one or more of the 3 algorythms used. The first algorythm will simply put the pair of parenthesis at the condition surrounded and/or after a character flagged (in flagged_conj_v) as a conjunction. The second algorythm will put parenthesis at the condition that are located after other conditions that are surrounded by a pair. The third algorythm will put a pair at all the condition, it is very powerfull but takes a longer time. See examples and make experience to see which combination of algorythm(s) is the most efficient for your use case.
#' @param flagged_pair_v is a vector containing all the first character of the pairs
#' @param corr_v is a vector containing all the last character of the pairs
#' @param flagged_conj_v is a vector containing all the conjunction character
#' @param method is length 2 vector containing as a first index, the first character of the pair inserted, and at the last index, the second and last character of the pair 
#' @examples
#'
#' print(pairs_insertr2(inpt = "([one]|two|twob)three(four)", algo_used = c(1), method = c("(", ")")))
#'
#' [1] "([one]|(two)|(twob))three(four)"
#'
#' print(pairs_insertr2(inpt = "([one]|two|twob)three(four)", algo_used = c(1), method = c("[", "]")))
#'
#' [1] "([one]|[two]|[twob])three(four)"
#'
#' print(pairs_insertr2(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(1, 2)))
#'
#' [1] "(oneA|[one]|(two)|(twob))(three)(four)"
#'
#' print(pairs_insertr2(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(1, 2), method = c("-", "#"),
#'                      flagged_pair_v = c(")", "]", "#"), corr_v = c("(", "[", "-")))
#'
#' [1] "(oneA|[one]|-two#|-twob#)-three#(four)"
#'
#' print(pairs_insertr2(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(1, 2, 3)))
#'
#' [1] "((oneA)|[one]|(two)|(twob))(three)(four)"
#'
#' print(pairs_insertr2(inpt = "(oneA|[one]|two|twob)three(four)", algo_used = c(3), method = c("[", "]")))
#'
#' [1] "([oneA]|[one]|[two]|[twob])[three](four)"
#'
#' print(pairs_insertr2(inpt = "(oneA|[one]|two|twob)three((four))", algo_used = c(3)))
#'
#' [1] "((oneA)|[one]|(two)|(twob))(three)((four))"
#'
#' @export

pairs_insertr2 <- function(inpt, algo_used = c(1:3), flagged_pair_v = c(")", "]"), corr_v = c("(", "["), flagged_conj_v = c("&", "|"),
                                                        method = c("(", ")")){
  inpt <- unlist(strsplit(x = inpt, split = ""))
  cur_vec <- c(flagged_pair_v, flagged_conj_v, corr_v)
  if (1 %in% algo_used){
    cnt = 1
    while (cnt < length(inpt)){
      if (inpt[cnt] %in% flagged_conj_v & is.na(match(x = inpt[(cnt + 1)] , table = corr_v))){
        inpt <- append(x = inpt, value = method[1], after = cnt)
        cnt = cnt + 2
        stop <- FALSE
        while (cnt < length(inpt) & !(stop)){
          if (is.na(match(x = inpt[cnt], table = cur_vec))){
            cnt = cnt + 1
          }else{
            stop <- TRUE
          }
        }
        inpt <- append(x = inpt, value = method[2], after = (cnt - 1))
      }
      cnt = cnt + 1
    }
  }
  if (2 %in% algo_used){
    cnt = 1
    while (cnt < length(inpt)){
      cur_mtch <- match(table = flagged_pair_v, x = inpt[cnt])
      if (!(is.na(cur_mtch)) & is.na(match(x = inpt[(cnt + 1)], table = flagged_pair_v))){
        if (!(is.na(match(x = inpt[(cnt + 1)], table = flagged_conj_v)))){
          cnt = cnt + 1
        } 
        if (is.na(match(x = inpt[(cnt + 1)], table = corr_v))){
           inpt <- append(x = inpt, value = method[1], after = cnt)
           cnt = cnt + 2
           stop <- FALSE
           while (cnt <= length(inpt) & !(stop)){
             if (is.na(match(x = inpt[cnt], table = cur_vec))){
               cnt = cnt + 1
             }else{
               stop <- TRUE
             }
           }
           inpt <- append(x = inpt, value = method[2], after = (cnt - 1))
         }
      }
      cnt = cnt + 1
    }
  }
  if (3 %in% algo_used){
    depth_pairs_findr <- function(inpt){
        rtn_v <- c(matrix(data = 0, nrow = length(inpt), ncol = 1))
        all_pair <- c(matrix(data = 0, nrow = length(unique(inpt)), ncol = 1))
        alrd_here <- c()
        cnt = 1
        cnt2 = 1
        while (cnt2 < length(rtn_v)){
          if (inpt[cnt2]  == inpt[(cnt2 + 1)]){
            rtn_v[grep(x = inpt, pattern = inpt[cnt2])] <- cnt
            cnt2 = cnt2 + 2
          }else if (!(is.na(match(x = inpt[cnt2], table = alrd_here)))){
            cnt = cnt - 1
            rtn_v[grep(x = inpt, pattern = inpt[cnt2])] <- cnt
            cnt2 = cnt2 + 1
          }else{
            cnt = cnt + 1
            alrd_here <- c(alrd_here, inpt[cnt2])
            cnt2 = cnt2 + 1
          }
        }
        if (rtn_v[length(rtn_v)] == 0){
          rtn_v[grep(x = rtn_v, pattern = 0)] <- 1
        }
        return(rtn_v)
      }
    pairs_findr <- function(inpt, ptrn1="(", ptrn2=")"){
      regex_spe_detect <- function(inpt){
          fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
            ptrn <- grep(ptrn_fill, inpt_v)
            while (length(ptrn) > 0){
              ptrn <- grep(ptrn_fill, inpt_v)
              idx <- ptrn[1] 
              untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
              pre_val <- inpt_v[(idx - 1)]
              inpt_v[idx] <- pre_val
              if (untl > 0){
                for (i in 1:untl){
                  inpt_v <- append(inpt_v, pre_val, idx)
                }
              }
            ptrn <- grep(ptrn_fill, inpt_v)
            }
            return(inpt_v)
          }
          inpt <- unlist(strsplit(x=inpt, split=""))
          may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
          pre_idx <- unique(match(x=inpt, table=may_be_v))
          pre_idx <- pre_idx[!(is.na(pre_idx))]
          for (el in may_be_v[pre_idx]){
                  cnt = 0
                  for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                          inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                          cnt = cnt + 1
                  }
          }
          return(paste(inpt, collapse=""))
      }
      lst <- unlist(strsplit(x=inpt, split=""))
      lst_par <- c()
      lst_par_calc <- c()
      lst_pos <- c()
      paires = 1
      pre_paires = 1
      pre_paires2 = 1
      if ((length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2) > 0){
              for (i in 1:(length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2)){ 
                      lst_par <- c(lst_par, 0)
                      lst_par_calc <- c(lst_par_calc, 0)
                      lst_pos <- c(lst_pos, 0)
              }
      }
      vec_ret <- c()
      par_ = 1
      lvl_par = 0
      for (el in 1:length(lst)){
         if (lst[el] == ptrn1){
                 if (!(is.null(vec_ret))){
                         lst_par_calc[pre_paires2:pre_paires][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] + 1
                 }else{
                         lst_par_calc[pre_paires2:pre_paires] <- lst_par_calc[pre_paires2:pre_paires] + 1
                 }
                 pre_paires = pre_paires + 1
                 pre_cls <- TRUE
                 lst_pos[par_] <- el
                 par_ = par_ + 1
                 lvl_par = lvl_par + 1
         }
         if (lst[el] == ptrn2){
                 lvl_par = lvl_par - 1
                 if (!(is.null(vec_ret))){
                      lst_par_calc[c(pre_paires2:pre_paires)][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] - 1
                      pre_val <- lst_par_calc[pre_paires2:pre_paires][vec_ret]
                      lst_par_calc[pre_paires2:pre_paires][vec_ret] <- (-2)
                 }else{
                      lst_par_calc[c(pre_paires2:pre_paires)] <- lst_par_calc[pre_paires2:pre_paires] - 1
                 }
                 if (!(is.null(vec_ret))){ 
                         pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])
                         lst_par_calc[pre_paires2:pre_paires][vec_ret] <- pre_val 
                 }else{
                         pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires])
                 }
                 cnt_par = 1
                 cnt2 = 0
                 if (!(is.null(vec_ret))){
                         vec_ret <- sort(vec_ret)
                         if (pre_mtch[1] >= min(vec_ret)){
                              cnt2 = 2
                              while (pre_mtch[1] > cnt_par & cnt2 <= length(vec_ret)){
                                      if ((vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) > 1){
                                              cnt_par = cnt_par + (vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) - 1
                                      }
                                      cnt2 = cnt2 + 1
                              }
                              if (pre_mtch[1] > cnt_par){
                                      cnt_par = length(vec_ret) / 2 + 1
                              }
                              cnt2 = cnt2 - 1
                         }
                 }
                 lst_par[pre_mtch[1] + (pre_paires2 - 1) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1))] <- paires 
                 lst_par[pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret)] <- paires 
                 if ((pre_mtch[1] + (pre_paires2 - 1)) == 1){
                      pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
                      vec_ret <- c()
                      cnt_par = 0
                 } else if (lst_par_calc[(pre_mtch[1] + (pre_paires2 - 1) - 1)] == -1 & ifelse(is.null(vec_ret), TRUE, 
                              is.na(match(x=-1, table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])))){

                      pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
                      vec_ret <- c()
                      cnt_par = 0
                 } else{
                      vec_ret <- c(vec_ret, (pre_mtch[1]) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1)), 
                                   (pre_mtch[2] + length(vec_ret)))
                 }
                 paires = paires + 1
                 pre_paires = pre_paires + 1
                 pre_cls <- FALSE
                 lst_pos[par_] <- el
                 par_ = par_ + 1
         }
      }
      return(list(lst_par, lst_pos))
      }
      pairs_findr_merger <- function(lst1=list(), lst2=list()){
        better_match <- function(inpt_v=c(), ptrn, untl=1, nvr_here=NA){
          Rtn_v <- c()
          if (length(untl) < length(ptrn)){
            val_add <- untl[length(untl)]
            while (length(untl) < length(ptrn)){
              untl <- c(untl, val_add)
            }
          }
          for (cur_ptrn in 1:length(ptrn)){
            rtn_v <- c()
            cnt = 1
            stop <- FALSE
            while (length(rtn_v) < untl[cur_ptrn] & cnt < (length(inpt_v) + 1) & !(stop)){
                    pre_match <- match(x=ptrn[cur_ptrn], table=inpt_v)
                    if (!(is.na(pre_match))){
                      inpt_v[pre_match] <- nvr_here
                      rtn_v <- c(rtn_v, pre_match)
                    }else{
                      stop <- TRUE
                    }
                    cnt = cnt + 1
            }
            Rtn_v <- c(Rtn_v, rtn_v)
          }
          return(Rtn_v)
        }
        pair1 <- unlist(lst1[1])
        pos1 <- unlist(lst1[2])
        pair2 <- unlist(lst2[1])
        pos2 <- unlist(lst2[2])
        stop <- FALSE
        cnt = 1
        while (!(stop)){
          mtch1 <- match(x = cnt, table = pair1)
          mtch2 <- match(x = cnt, table = pair2)
          if (all(!(is.na(mtch1)), !(is.na(mtch2)))){
            if (pos1[mtch1] < pos2[mtch2]){
              poses <- better_match(inpt_v = pair2, ptrn = c(cnt:max(pair2)), untl = 2)
              pair2[poses] <- pair2[poses] + 1
            }else{
              poses <- better_match(inpt_v = pair1, ptrn = c(cnt:max(pair1)), untl = 2)
              pair1[poses] <- pair1[poses] + 1
            }
          }else{
            stop <- TRUE
          }
          cnt = cnt + 1
        }
        if (length(pair1) > length(pair2)){
          rtn_pos <- pos1
          rtn_pair <- pair1
          add_pos <- pos2
          add_pair <- pair2
        }else{
          rtn_pos <- pos2
          rtn_pair <- pair2
          add_pos <- pos1
          add_pair <- pair1
        }
        cnt = 1
        stop <- FALSE
        pre_lngth <- length(rtn_pos)
        while (cnt <= (pre_lngth / 2 + length(add_pair) / 2) & !(stop)){
          if (is.na(match(x = cnt, table = rtn_pair))){
              cur_add_pos_id <- grep(x = add_pair, pattern = cnt)
              if (cnt < max(rtn_pair)){
                incr = 1
                cur_grep <- grep(x = rtn_pair, pattern = (cnt + incr))
                while (identical(integer(0), cur_grep)){
                    incr = incr + 1
                    cur_grep <- grep(x = rtn_pair, pattern = (cnt + incr))
                }
                if (rtn_pos[cur_grep[2]] < add_pos[cur_add_pos_id[2]] & 
                    rtn_pos[cur_grep[1]] > add_pos[cur_add_pos_id[1]]){
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                  cur_vec <- abs(rtn_pos - add_pos[cur_add_pos_id[2]])
                  cur_pos <- which.min(cur_vec)
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_pos + 1))
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_pos + 1))
                }else{
                  if (!(is.na(match(x = (cnt - 1), table = rtn_pair)))){
                        cur_grep2 <- grep(x = rtn_pair, pattern = (cnt - 1))
                        if (rtn_pos[cur_grep2[2]] > add_pos[cur_add_pos_id[2]]){
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep2[1])
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep2[1] + 1))
                          rtn_pos <- append(x = rtn_pos, 
                                            value = add_pos[cur_add_pos_id[1]], after = cur_grep2[1])
                          rtn_pos <- append(x = rtn_pos, 
                                            value = add_pos[cur_add_pos_id[2]], after = (cur_grep2[1] + 1))
                        }else{
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                          rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                          rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                          rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_grep[1] - 1))
                        }
                  }else{
                    rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                    rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_grep[1] - 1))
                    rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = (cur_grep[1] - 1))
                    rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_grep[1] - 1))
                  }
                }
              }else{
                incr = 1
                cur_grep <- grep(x = rtn_pair, pattern = (cnt - incr))
                while (identical(integer(0), cur_grep)){
                  incr = incr + 1
                  cur_grep <- grep(x = rtn_pair, pattern = (cnt - incr))
                }
                if (rtn_pos[cur_grep[2]] < add_pos[cur_add_pos_id[1]]){
                  cur_vec <- abs(rtn_pos - add_pos[cur_add_pos_id[1]])
                  cur_pos <- which.min(cur_vec)
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_pos)
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = (cur_pos + 1))
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = cur_pos)
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = (cur_pos + 1))
                }else{
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep[1])
                  rtn_pair <- append(x = rtn_pair, value = cnt, after = cur_grep[1])
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[1]], after = cur_grep[1])
                  rtn_pos <- append(x = rtn_pos, value = add_pos[cur_add_pos_id[2]], after = cur_grep[1])
                }
              }
          }
          cnt = cnt + 1
        }
        return(list(rtn_pair, sort(rtn_pos)))
      }
    cur_lst <-  pairs_findr(inpt = inpt, ptrn1 = corr_v[1], ptrn2 = flagged_pair_v[1])
    if (length(corr_v) > 1){
      for (pair in 2:length(corr_v)){
        cur_fun <- pairs_findr(inpt = inpt, ptrn1 = corr_v[pair], ptrn2 = flagged_pair_v[pair]) 
        cur_lst <- pairs_findr_merger(lst1 = cur_lst, lst2 = cur_fun)
      }
    }
    lst_pair <- unlist(cur_lst[1])
    lst_pos <- unlist(cur_lst[2])
    cur_depth <- depth_pairs_findr(inpt = unlist(cur_lst[1])) 
    par = 2
    while (par <= length(lst_pair)){
      if (lst_pair[(par - 1)] != lst_pair[par] & abs(lst_pos[(par - 1)] - lst_pos[par]) > 1){
        cnt = lst_pos[(par - 1)]
        ahd <- TRUE
        if (!(is.na(match(x = inpt[(lst_pos[(par - 1)] + 1)], table = flagged_conj_v)))){
          if (abs(lst_pos[(par - 1)] - lst_pos[par]) == 2){
            ahd <- FALSE
          }
          else{
            cnt = cnt + 1
          }
        }
        if (ahd){
          inpt <- append(x = inpt, value = method[1], after = cnt)
          cnt = cnt + 2
          stop <- FALSE
          while (!(stop) & cnt <= length(inpt)){
            if (is.na(match(x = inpt[cnt], table = cur_vec))){
              cnt = cnt + 1
            }else{
              stop <- TRUE
            }
          }
          inpt <- append(x = inpt, value = method[2], after = (cnt - 1))
          cur_lst <-  pairs_findr(inpt = inpt, ptrn1 = corr_v[1], ptrn2 = flagged_pair_v[1])
          if (length(corr_v) > 1){
             for (pair in 2:length(corr_v)){
               cur_fun <- pairs_findr(inpt = inpt, ptrn1 = corr_v[pair], ptrn2 = flagged_pair_v[pair]) 
               cur_lst <- pairs_findr_merger(lst1 = cur_lst, lst2 = cur_fun)
             }
          }
          lst_pair <- unlist(cur_lst[1])
          lst_pos <- unlist(cur_lst[2])
          cur_depth <- depth_pairs_findr(inpt = unlist(cur_lst[1]))
        }
      }
      par = par + 1
    }
  }
  return(paste(inpt, collapse = ""))
}

#' power_to_char
#'
#' Convert a scientific number to a string representing normally the number.
#'
#' @param inpt_v is the input vector containing scientific number, but also other elements that won't be taken in count
#' @examples 
#'
#' print(power_to_char(inpt_v = c(22 * 10000000, 12, 9 * 0.0000002)))
#'
#' [1] "2200000000" "12"         "0.0000018" 
#'
#' @export

power_to_char <- function(inpt_v = c()){
  fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
     ptrn <- grep(ptrn_fill, inpt_v)
     while (length(ptrn) > 0){
       ptrn <- grep(ptrn_fill, inpt_v)
       idx <- ptrn[1] 
       untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
       pre_val <- inpt_v[(idx - 1)]
       inpt_v[idx] <- pre_val
       if (untl > 0){
         for (i in 1:untl){
           inpt_v <- append(inpt_v, pre_val, idx)
         }
       }
     ptrn <- grep(ptrn_fill, inpt_v)
     }
     return(inpt_v)
  }
  inpt_v <- as.character(inpt_v)
  better_split <- function(inpt, split_v = c()){
    for (split in split_v){
      pre_inpt <- inpt
      inpt <- c()
      for (el in pre_inpt){
        inpt <- c(inpt, unlist(strsplit(x = el, split = split)))
      }
    }
    return(inpt)
  }
  for (el in 1:length(inpt_v)){
    if (grepl(pattern = "^(((\\d{1,}\\.)\\d{1,})|\\d{1,})e\\+\\d{1,}$", x = inpt_v[el])){
      idx <- el
      el <- better_split(inpt = inpt_v[el], split_v = c("\\+", "e", "\\."))
      inpt_v[idx] <- paste0(paste(el[1:(length(el) - 1)], collapse = ""), 
                           paste(fillr(inpt_v = c("0", paste0("...", (as.numeric(el[length(el)]) - 1)))), collapse = "")) 
    }else if (grepl(pattern = "^(((\\d{1,}\\.)\\d{1,})|\\d{1,})e-\\d{1,}$", x = inpt_v[el])){
      idx <- el
      el <- better_split(inpt = inpt_v[el], split_v = c("\\-", "e", "\\."))
      zeros <- fillr(inpt_v = c("0", paste0("...", as.numeric(el[length(el)]))))
      zeros[2] <- "."
      inpt_v[idx] <- paste0(paste(zeros, collapse = ""),
                            paste(el[1:(length(el) - 1)], collapse = ""))
    }
  }
  return(inpt_v)  
}

#' unique_total
#'
#' Returns a vector with the total amount of occurences for each element in the input vector. The occurences of each element follow the same order as the unique function does, see examples
#'
#' @param inpt_v is the input vector containing all the elements
#' @examples
#'
#' print(unique_total(inpt_v = c(1:12, 1)))
#' 
#'  [1] 2 1 1 1 1 1 1 1 1 1 1 1
#' 
#' print(unique_total(inpt_v = c(1:12, 1, 11, 11)))
#'
#'  [1] 2 1 1 1 1 1 1 1 1 1 3 1
#'
#' vec <- c(1:12, 1, 11, 11)
#' names(vec) <- c(1:15)
#' print(unique_total(inpt_v = vec))
#'
#'  1  2  3  4  5  6  7  8  9 10 11 12 
#'  2  1  1  1  1  1  1  1  1  1  3  1 
#'
#' @export

unique_total <- function(inpt_v = c()){
  rtn_v <- c()
  for (el in unique(inpt_v)){
    rtn_v <- c(rtn_v, length(grep(pattern = paste0("^", el, "$"), x = inpt_v)))
    names(rtn_v)[length(rtn_v)] <- names(inpt_v)[match(x = el, table = inpt_v)]
  }
  return(rtn_v)
}

#' match_by
#'
#' Allow to match elements by ids, see examples.  
#'
#' @param to_match_v is the vector containing all the elements to match
#' @param inpt_v is the input vector containong all the elements that could contains the elements to match. Each elements is linked to an element from inpt_ids at any given index, see examples. So inpt_v and inpt_ids must be the same size
#' @param inpt_ids is the vector containing all the ids for the elements in inpt_v. An element is linked to the id x is both are at the same index. So inpt_v and inpt_ids must be the same size 
#' @examples
#'
#' print(match_by(to_match_v = c("a"), inpt_v = c("a", "z", "a", "p", "p", "e", "e", "a"), 
#'                inpt_ids = c(1, 1, 1, 2, 2, 3, 3, 3)))
#' 
#' [1] 1 8
#'
#' print(match_by(to_match_v = c("a"), inpt_v = c("a", "z", "a", "a", "p", "e", "e", "a"), 
#'                inpt_ids = c(1, 1, 1, 2, 2, 3, 3, 3)))
#'
#' [1] 1 4 8
#'
#' print(match_by(to_match_v = c("a", "e"), inpt_v = c("a", "z", "a", "a", "p", "e", "e", "a"), 
#'                inpt_ids = c(1, 1, 1, 2, 2, 3, 3, 3)))
#' 
#' [1] 1 4 8 6
#'
#' @export

match_by <- function(to_match_v = c(), inpt_v = c(), inpt_ids = c()){
  rtn_v <- c()
  for (el in to_match_v){
    for (id in unique(inpt_ids)){
      if (!(is.na(match(x = el, table = inpt_v[grep(pattern = id, x = inpt_ids)])))){
        rtn_v <- c(rtn_v, (match(x = id, table = inpt_ids) +
                  match(x = el, table = inpt_v[grep(pattern = id, x = inpt_ids)]) - 1))
      }
    }
  }
  return(rtn_v)
}

#' see_diff
#'
#' Output the opposite of intersect(a, b). Already seen at: https://stackoverflow.com/questions/19797954/function-to-find-symmetric-difference-opposite-of-intersection-in-r  
#'
#' @param vec1 is the first vector
#' @param vec2 is the second vector
#' @examples
#'
#' print(see_diff(c(1:7), c(4:12)))
#'
#' [1] 1 2 3 8 9 10 11 12
#'
#' @export

see_diff <- function(vec1 = c(), vec2 = c()){
  return(setdiff(union(vec1, vec2), intersect(vec1, vec2)))
}

#' see_mode
#'
#' Allow to get the mode of a vector, see examples.
#'
#' @param inpt_v is the input vector
#' @examples
#'
#' print(see_mode(inpt_v = c(1, 1, 2, 2, 2, 3, 1, 2)))
#'
#' [1] 2
#'
#' print(see_mode(inpt_v = c(1, 1, 2, 2, 2, 3, 1)))
#'
#' [1] 1
#' 
#' @export

see_mode <- function(inpt_v = c()){
  unique_total <- function(inpt_v = c()){
    rtn_v <- c()
    for (el in unique(inpt_v)){
      rtn_v <- c(rtn_v, length(grep(pattern = paste0("^", el, "$"), x = inpt_v)))
    }
    return(rtn_v)
  }
  return(unique(inpt_v)[which.max(unique_total(inpt_v))])
}

#' union_all
#'
#'  Allow to perform a union function to n vectors.
#'
#' @param ... are all the input vectors 
#' @examples
#'
#' print(union_all(c(1, 2), c(3, 4), c(1:8)))
#' 
#' [1] 1 2 3 4 5 6 7 8
#'
#' print(union_all(c(1, 2), c(3, 4), c(7:8)))
#'
#' [1] 1 2 3 4 7 8
#' 
#' @export

union_all <- function(...){
  cur_lst <- list(...)
  rtn_v <- c(unlist(cur_lst[1]))
  if (length(cur_lst) > 1){
    cur_lst <- cur_lst[2:length(cur_lst)]
    for (lst in cur_lst){
      rtn_v <- union(rtn_v, lst) 
    }
  return(rtn_v)
  }else{
    return(NULL)
  }
}

#' see_diff_all
#'
#' Allow to perform the opposite of intersect function to n vectors.
#'
#' @param ... are all the input vectors 
#' @examples
#'
#' vec1 <- c(3:6)
#' vec2 <- c(1:8)
#' vec3 <- c(12:16)
#' 
#' print(see_diff_all(vec1, vec2))
#' 
#' [1] 1 2 7 8
#'
#' print(see_diff_all(vec1, vec2, vec3))
#'
#' [1]  3  4  5  6  1  2  7  8 12 13 14 15 16
#' 
#' @export

see_diff_all <- function(...){
  cur_lst <- list(...)
  if (length(cur_lst) > 1){
    intersect_v <- intersect(unlist(cur_lst[1]), unlist(cur_lst[2]))
    union_v <- union(unlist(cur_lst[1]), unlist(cur_lst[2]))
    if (length(cur_lst) > 2){
      cur_lst <- cur_lst[3:length(cur_lst)]
      for (lst in cur_lst){
        intersect_v <- intersect(intersect_v, lst)    
        union_v <- union(union_v, lst)
      }
    }
    return(setdiff(union_v, intersect_v))
  }else{
    return(NULL)
  }
}

#' grep_all 
#'
#' Allow to perform a grep function on multiple input elements
#'
#' @param inpt_v is the input vectors to grep elements from
#' @param pattern_v is a vector contaning the patterns to grep
#' @examples
#'
#' print(grep_all(inpt_v = c(1:14, "z", 1:7, "z", "a", "z"), 
#'                pattern_v = c("z", "4")))
#'
#' [1] 15 23 25  4 14 19
#'
#' print(grep_all(inpt_v = c(1:14, "z", 1:7, "z", "a", "z"), 
#'                pattern_v = c("z", "^4$")))
#'
#' [1] 15 23 25  4 19
#'
#' print(grep_all(inpt_v = c(1:14, "z", 1:7, "z", "a", "z"), 
#'                pattern_v = c("z")))
#' 
#' [1] 15 23 25
#'
#' @export

grep_all <- function(inpt_v, pattern_v){
  rtn_v <- c(grep(pattern = pattern_v[1], x = inpt_v))
  if (length(pattern_v) > 1){
    pattern_v <- pattern_v[2:length(pattern_v)]
    for (ptrn in pattern_v){
      rtn_v <- c(rtn_v, grep(pattern = ptrn, x = inpt_v))
    }
  }
  return(rtn_v)
}

#' sub_mult
#'
#' Performs a sub operation with n patterns and replacements.
#'
#' @param inpt_v is a vector containing all the elements that contains expressions to be substituted
#' @param pattern_v is a vector containing all the patterns to be substituted in any elements of inpt_v
#' @param replacement_v is a vector containing the expression that are going to substituate those provided by pattern_v
#' @examples
#'
#' print(sub_mult(inpt_v = c("X and Y programming languages are great", "More X, more X!"), 
#'                pattern_v = c("X", "Y", "Z"), 
#'                replacement_v = c("C", "R", "GO")))
#'
#' [1] "C and R programming languages are great"
#' [2] "More C, more X!"
#'
#' @export

sub_mult <- function(inpt_v, pattern_v = c(), replacement_v = c()){
  for (i in 1:length(inpt_v)){
    cur_char <- inpt_v[i]
    for (i2 in 1:length(pattern_v)){
      cur_char <- sub(pattern = pattern_v[i2], replacement = replacement_v[i2], x = cur_char)
    }
    inpt_v[i] <- cur_char
  }
  return(inpt_v)
}

#' gsub_mult
#'
#' Performs a gsub operation with n patterns and replacements.
#'
#' @param inpt_v is a vector containing all the elements that contains expressions to be substituted
#' @param pattern_v is a vector containing all the patterns to be substituted in any elements of inpt_v
#' @param replacement_v is a vector containing the expression that are going to substituate those provided by pattern_v
#' @examples
#'
#' print(gsub_mult(inpt_v = c("X and Y programming languages are great", "More X, more X!"), 
#'                pattern_v = c("X", "Y", "Z"), 
#'                replacement_v = c("C", "R", "GO")))
#' [1] "C and R programming languages are great"
#' [2] "More C, more C!"                        
#'
#' @export

gsub_mult <- function(inpt_v, pattern_v = c(), replacement_v = c()){
  for (i in 1:length(inpt_v)){
    cur_char <- inpt_v[i]
    for (i2 in 1:length(pattern_v)){
      cur_char <- gsub(pattern = pattern_v[i2], replacement = replacement_v[i2], x = cur_char)
    }
    inpt_v[i] <- cur_char
  }
  return(inpt_v)
}

#' better_sub
#'
#' Allow to perform a sub operation to a given number of matched patterns, see examples
#'
#'
#' @param inpt_v is a vector containing all the elements that contains expressions to be substituted
#' @param pattern is the expression that will be substituted
#' @param replacement is the expression that will substituate pattern
#' @param untl_v is a vector containing, for each element of inpt_v, the number of pattern that will be substituted
#' @examples
#'
#' print(better_sub(inpt_v = c("yes NAME, i will call NAME and NAME", 
#'                             "yes NAME, i will call NAME and NAME"),
#'                  pattern = "NAME",
#'                  replacement = "Kevin",
#'                  untl = c(2)))
#' 
#' [1] "yes Kevin, i will call Kevin and NAME"
#' [2] "yes Kevin, i will call Kevin and NAME"
#'
#' print(better_sub(inpt_v = c("yes NAME, i will call NAME and NAME", 
#'                             "yes NAME, i will call NAME and NAME"),
#'                  pattern = "NAME",
#'                  replacement = "Kevin",
#'                  untl = c(2, 3)))
#' 
#' [1] "yes Kevin, i will call Kevin and NAME" 
#' [2] "yes Kevin, i will call Kevin and Kevin"
#'
#' print(better_sub(inpt_v = c("yes NAME, i will call NAME and NAME", 
#'                              "yes NAME, i will call NAME and NAME"),
#'                   pattern = "NAME",
#'                   replacement = "Kevin",
#'                   untl = c("max", 3)))
#' 
#' [1] "yes Kevin, i will call Kevin and Kevin"
#' [2] "yes Kevin, i will call Kevin and Kevin"
#'
#' @export

better_sub <- function(inpt_v = c(), pattern, replacement, untl_v = c()){
  if (length(untl_v) < length(inpt_v)){
    val_add <- untl_v[length(untl_v)]
    while (length(untl_v) < length(inpt_v)){
      untl_v <- c(untl_v, val_add)
    }
  }
  for (el in 1:length(inpt_v)){
    cur_char <- inpt_v[el]
    if (untl_v[el] == "max"){
        cur_char <- gsub(x = cur_char, pattern = pattern, replacement = replacement)
    }else{
      for (i in 1:untl_v[el]){
        cur_char <- sub(x = cur_char, pattern = pattern, replacement = replacement)
      }
    }
    inpt_v[el] <- cur_char
  }
  return(inpt_v)
}

#' better_sub_mult
#'
#' Allow to perform a sub_mult operation to a given number of matched patterns, see examples
#'
#'
#' @param inpt_v is a vector containing all the elements that contains expressions to be substituted
#' @param pattern_v is a vector containing all the patterns to be substituted in any elements of inpt_v
#' @param replacement_v is a vector containing the expression that are going to substituate those provided by pattern_v
#' @param untl_v is a vector containing, for each element of inpt_v, the number of pattern that will be substituted
#' @examples
#'
#' print(better_sub_mult(inpt_v = c("yes NAME, i will call NAME and NAME2", 
#'                              "yes NAME, i will call NAME and NAME2, especially NAME2"),
#'                   pattern_v = c("NAME", "NAME2"),
#'                   replacement_v = c("Kevin", "Paul"),
#'                   untl = c(1, 3)))
#'
#' [1] "yes Kevin, i will call NAME and Paul"                 
#' [2] "yes Kevin, i will call NAME and Paul, especially Paul"
#'
#' print(better_sub_mult(inpt_v = c("yes NAME, i will call NAME and NAME2", 
#'                               "yes NAME, i will call NAME and NAME2, especially NAME2"),
#'                    pattern_v = c("NAME", "NAME2"),
#'                    replacement_v = c("Kevin", "Paul"),
#'                    untl = c("max", 3)))
#' 
#' [1] "yes Kevin, i will call Kevin and Kevin2"                   
#' [2] "yes Kevin, i will call Kevin and Kevin2, especially Kevin2"
#'
#' @export

better_sub_mult <- function(inpt_v = c(), pattern_v = c(), 
                            replacement_v = c(), untl_v = c()){
  if (length(untl_v) < length(inpt_v)){
    val_add <- untl_v[length(untl_v)]
    while (length(untl_v) < length(inpt_v)){
      untl_v <- c(untl_v, val_add)
    }
  }
  for (el in 1:length(inpt_v)){
    cur_char <- inpt_v[el]
    for (i2 in 1:length(pattern_v)){
      if (untl_v[i2] == "max"){
          cur_char <- gsub(x = cur_char, pattern = pattern_v[i2], replacement = replacement_v[i2])
      }else{
        for (i in 1:untl_v[i2]){
          cur_char <- sub(x = cur_char, pattern = pattern_v[i2], replacement = replacement_v[i2])
        }
      }
    }
    inpt_v[el] <- cur_char
  }
  return(inpt_v)
}

#' test_order
#'
#' Allow to get if two vectors have their commun elements in the same order, see examples
#'
#' @param is the vector that gives the elements order
#' @param is the vector we want to test if its commun element with inpt_v_from are in the same order
#' @examples
#'
#' print(test_order(inpt_v_from = c(1:8), inpt_v_test = c(1, 4)))
#' 
#' [1] TRUE
#'
#' print(test_order(inpt_v_from = c(1:8), inpt_v_test = c(1, 4, 2)))
#' 
#' [1] FALSE
#'
#' @export

test_order <- function(inpt_v_from, inpt_v_test){
  lst_idx <- match(x = inpt_v_test[1], table = inpt_v_from)
  if (length(inpt_v_test) > 1){
    for (i in inpt_v_test){
      tst_idx <- match(x = i, table = inpt_v_from)
      if (tst_idx < lst_idx){
        return(FALSE)
      }
      lst_idx <- tst_idx
    }
  }
  return(TRUE)
}

#' sort_date
#'
#' Allow to sort any vector containing a date, from any kind of format (my, hdmy, ymd ...), see examples.
#'
#' @param inpt_v is the input vector containing all the dates
#' @param frmt is the format  of the dates, (any combinaison of letters "s" for second, "n", for minute, "h" for hour, "d" for day, "m" for month and "y" for year)
#' @param sep_ is the separator used for the dates
#' @param ascending is the used to sort the dates
#' @param give takes only two values "index" or "value", if give == "index", the function will output the index of sorted dates from inpt_v, if give == "value", the function will output the value, it means directly the sorted dates in inpt_v, see examples
#' @examples
#'
#' print(sort_date(inpt_v = c("01-11-2025", "08-08-1922", "12-04-1966")
#'                 , frmt = "dmy", sep_ = "-", ascending = TRUE, give = "value"))
#' 
#' [1] "08-08-1922" "12-04-1966" "01-11-2025"
#'
#' print(sort_date(inpt_v = c("01-11-2025", "08-08-1922", "12-04-1966")
#'                 , frmt = "dmy", sep_ = "-", ascending = FALSE, give = "value"))
#' 
#' [1] "01-11-2025" "12-04-1966" "08-08-1922"
#'
#' print(sort_date(inpt_v = c("01-11-2025", "08-08-1922", "12-04-1966")
#'                 , frmt = "dmy", sep_ = "-", ascending = TRUE, give = "index"))
#'
#' [1] 2 3 1
#'
#' print(sort_date(inpt_v = c("22-01-11-2025", "11-12-04-1966", "12-12-04-1966")
#'                 , frmt = "hdmy", sep_ = "-", ascending = FALSE, give = "value"))
#'
#' [1] "22-01-11-2025" "12-12-04-1966" "11-12-04-1966"
#'
#' print(sort_date(inpt_v = c("03-22-01-11-2025", "56-11-12-04-1966", "23-12-12-04-1966")
#'                 , frmt = "nhdmy", sep_ = "-", ascending = FALSE, give = "value"))
#'
#' [1] "03-22-01-11-2025" "23-12-12-04-1966" "56-11-12-04-1966"
#'
#' @export

sort_date <- function(inpt_v, frmt, sep_ = "-", ascending = FALSE, give = "value"){
  test_order <- function(inpt_v_from, inpt_v_test){
    lst_idx <- match(x = inpt_v_test[1], table = inpt_v_from)
    if (length(inpt_v_test) > 1){
      for (i in inpt_v_test){
        tst_idx <- match(x = i, table = inpt_v_from)
        if (tst_idx < lst_idx){
          return(FALSE)
        }
        lst_idx <- tst_idx
      }
    }
    return(TRUE)
  }
  converter_format <- function(inpt_val, sep_="-", inpt_frmt, 
                         frmt, default_val="00"){
    frmt <- unlist(strsplit(x=frmt, split=""))
    inpt_frmt <- unlist(strsplit(x=inpt_frmt, split=""))
    inpt_val <- unlist(strsplit(x=inpt_val, split=sep_))
    val_v <- c()
    for (i in 1:length(frmt)){
            val_v <- c(val_v, default_val)
    }
    for (el in 1:length(inpt_val)){
            pre_grep <- grep(x=frmt, pattern=inpt_frmt[el])
            if (!identical(pre_grep, integer(0))){
                    val_v[pre_grep] <- inpt_val[el]
            }
    }
    return(paste(val_v, collapse=sep_))
  }
  func <- function(){
    return(gsub(x = converter_format(inpt_val = inpt_val, sep_ = sep_, 
                inpt_frmt = inpt_frmt, frmt = frmt), 
                pattern = sep_, replacement = ""))
  }
  frmt_frm <- c("y", "m", "d", "h", "n", "s")
  if (!(test_order(inpt_v_from = frmt_frm, 
                   inpt_v_test = unlist(strsplit(x = frmt, split = ""))))){
    frmt_to <- frmt_frm[sort(match(x = unlist(strsplit(x = frmt, split = "")), table = frmt_frm))]
    new_v <- as.numeric(mapply(function(x) return(gsub(x = converter_format(inpt_val = x, 
                                                                sep_ = sep_, 
                                                                inpt_frmt = frmt, 
                                                                frmt = frmt_to), 
                                          replacement = "",
                                          pattern = sep_)), 
                   inpt_v))
  }else if (sep_ != ""){
    new_v <- as.numeric(mapply(function(x) return(gsub(x = x, pattern = sep_, replacement = "")), inpt_v))
  }else{
    new_v <- as.numeric(inpt_v)
  }
  if (give == "index"){
    return(match(x = sort(x = new_v, decreasing = !(ascending)), table = new_v))
  }else if (give == "value"){
    return(inpt_v[match(x = sort(x = new_v, decreasing = !(ascending)), table = new_v)])
  }else{
    return(NULL)
  }
}

#' grep_all2
#'
#' Performs the grep_all function with another algorythm, potentially faster
#'
#' @param inpt_v is the input vectors to grep elements from
#' @param pattern_v is a vector contaning the patterns to grep
#' @examples
#'
#' print(grep_all2(inpt_v = c(1:14, "z", 1:7, "z", "a", "z"), 
#'                pattern_v = c("z", "4")))
#'
#' [1] 15 23 25  4 14 19
#'
#' print(grep_all2(inpt_v = c(1:14, "z", 1:7, "z", "a", "z"), 
#'                pattern_v = c("z", "^4$")))
#'
#' [1] 15 23 25  4 19
#'
#' print(grep_all2(inpt_v = c(1:14, "z", 1:7, "z", "a", "z"), 
#'                pattern_v = c("z")))
#' 
#' [1] 15 23 25
#'
#' @export

grep_all2 <- function(inpt_v, pattern_v){
  rtn_v <- c(grep(pattern = pattern_v[1], x = inpt_v))
  if (length(pattern_v) > 1){
    pattern_v <- pattern_v[2:length(pattern_v)]
    for (ptrn in pattern_v){
      cur_grp <- grep(pattern = ptrn, x = inpt_v)
      rtn_v <- c(rtn_v, cur_grp)
      inpt_v <- inpt_v[-cur_grp]
    }
  }
  return(rtn_v)
}

#' old_to_new_idx
#'
#' Allow to convert index of elements in a vector `inpt_v` to index of an vector type 1:sum(nchar(inpt_v)), see examples
#'
#' @param inpt_v is the input vector 
#' @examples
#'
#' print(old_to_new_idx(inpt_v = c("oui", "no", "eeee")))
#'
#' [1] 1 1 1 2 2 3 3 3 3
#'
#' @export

old_to_new_idx <- function(inpt_v = c()){
  rtn_v <- c()
  cur_step = nchar(inpt_v[1])
  cnt = 1
  for (idx in 1:sum(nchar(inpt_v))){
    if (idx > cur_step){
      cnt = cnt + 1
      cur_step = cur_step + nchar(inpt_v[cnt])
    }
    rtn_v <- c(rtn_v, cnt)
  }
  return(rtn_v)
}

#' how_normal
#'
#' Allow to get how much a sequence of numbers fit a normal distribution with chosen parameters, see examples
#'
#' @param inpt_datf is the input dataframe containing all the values in the first column and their frequency (normalised or no), in the second column
#' @param normalised is a boolean, takes TRUE if the frequency for each value is divided by n, FALSE if not
#' @param mean is the mean of the normal distribution that the dataset tries to fit
#' @param sd is the standard deviation of the normal distribution the dataset tries to fit
#' @examples
#'
#' sample_val <- round(rnorm(n = 12000, mean = 6, sd = 1.25), 1)
#' sample_freq <- unique_total(sample_val)
#' datf_test <- data.frame(unique(sample_val), sample_freq)
#' print(datf_test)
#'
#'   unique.sample_val. sample_freq
#' 1                 6.9         306
#' 2                 8.3          63
#' 3                 7.7         148
#' 4                 5.6         363
#' 5                 6.5         349
#' 6                 4.6         202
#' 7                 6.6         324
#' 8                 6.7         335
#' 9                 6.0         406
#' 10                5.7         365
#' 11                7.9         109
#' 12                6.2         420
#' 13                5.9         386
#' 14                4.5         185
#' 15                5.1         326
#' 16                6.1         360
#' 17                5.5         346
#' 18                6.3         375
#' 19                7.4         207
#' 20                7.6         162
#' 21                4.2         129
#' 22                3.9         102
#' 23                5.2         325
#' 24                2.3           7
#' 25                5.8         387
#' 26                6.4         319
#' 27                9.1          21
#' 28                7.0         280
#' 29                8.8          27
#' 30                4.9         218
#' 31                8.1          98
#' 32                3.0          25
#' 33                8.4          66
#' 34                4.3         160
#' 35                7.2         267
#' 36                8.7          40
#' 37                5.3         313
#' 38                4.1         127
#' 39                5.0         275
#' 40                4.0         119
#' 41                9.3          13
#' 42                4.4         196
#' 43                6.8         313
#' 44                7.1         247
#' 45                3.5          57
#' 46                7.8         139
#' 47                3.6          57
#' 48                7.5         189
#' 49                7.3         215
#' 50                4.7         230
#' 51                3.2          36
#' 52                9.5           8
#' 53                3.8          79
#' 54                8.2          62
#' 55                5.4         343
#' 56                8.5          55
#' 57                4.8         207
#' 58                3.7          79
#' 59                8.6          33
#' 60                3.3          38
#' 61                3.4          43
#' 62                8.9          21
#' 63                8.0         105
#' 64                3.1          23
#' 65                9.0          27
#' 66               10.0           5
#' 67                2.5          10
#' 68                2.9          16
#' 69                9.7           7
#' 70                2.7          11
#' 71               10.5           1
#' 72                9.4          13
#' 73                9.2          16
#' 74                2.6          16
#' 75                9.9           3
#' 76                2.8          10
#' 77                2.4          10
#' 78                1.9           2
#' 79                2.0           6
#' 80               10.2           2
#' 81                9.6           3
#' 82               11.3           1
#' 83                1.8           1
#' 84                2.2           3
#' 85                2.1           2
#' 86                1.6           1
#' 87               10.6           1
#' 88                9.8           1
#' 89               10.4           1
#' 90                1.7           1
#' 
#' print(how_normal(inpt_datf = datf_test, 
#'                  normalised = FALSE,
#'                  mean = 6,
#'                  sd = 1))
#' 
#' [1] 9.003683
#' 
#' print(how_normal(inpt_datf = datf_test, 
#'                  normalised = FALSE,
#'                  mean = 5,
#'                  sd = 1))
#' 
#' [1] 9.098484
#'
#' @export

how_normal <- function(inpt_datf, normalised = TRUE, mean = 0, sd = 1){  
  diff_add = 0
  inpt_datf <- inpt_datf[match(x = sort(inpt_datf[, 1], decreasing = FALSE), table = inpt_datf[, 1]), ]
  if (normalised){
    for (i in 1:nrow(inpt_datf)){
      diff_add = diff_add + abs(inpt_datf[i, 2] - (1 / (sd * sqrt(2 * pi)) * exp(-(((inpt_datf[i, 1] - mean) / sd) ** 2) / 2)))
    }
  }else{
    n <- sum(inpt_datf[, 2])
    for (i in 1:nrow(inpt_datf)){
      diff_add = diff_add + abs((inpt_datf[i, 2] / n) - (1 / (sd * sqrt(2 * pi)) * exp(-(((inpt_datf[i, 1] - mean) / sd) ** 2) / 2)))
    }
  }
  return(diff_add)
}

#' how_unif
#'
#' Allow to see how much a sequence of numbers fit a uniform distribution, see examples
#'
#' @param inpt_datf is the input dataframe containing all the values in the first column and their frequencyu at the second column
#' @param normalised is a boolean, takes TRUE if the frequency for each value is divided by n, FALSE if not
#' @examples
#'
#' sample_val <- round(runif(n = 12000, min = 24, max = 27), 1)
#' sample_freq <- unique_total(sample_val)
#' datf_test <- data.frame(unique(sample_val), sample_freq)
#' 
#' print(datf_test)
#' 
#'   unique.sample_val. sample_freq
#' 1                24.4         400
#' 2                24.8         379
#' 3                25.5         414
#' 4                26.0         366
#' 5                26.6         400
#' 6                25.7         419
#' 7                24.3         389
#' 8                24.1         423
#' 9                26.1         404
#' 10               26.5         406
#' 11               26.2         356
#' 12               26.8         407
#' 13               24.6         388
#' 14               25.3         402
#' 15               26.3         388
#' 16               25.4         422
#' 17               25.0         436
#' 18               25.9         373
#' 19               25.2         423
#' 20               25.6         388
#' 21               27.0         202
#' 22               24.2         380
#' 23               24.9         404
#' 24               25.1         417
#' 25               26.4         401
#' 26               26.7         431
#' 27               24.5         392
#' 28               24.0         218
#' 29               26.9         407
#' 30               25.8         371
#' 31               24.7         394
#'
#' print(how_unif(inpt_datf = datf_test, normalised = FALSE))
#' 
#' [1] 0.0752957
#'
#' sample_val <- round(rnorm(n = 12000, mean = 24, sd = 7), 1)
#' sample_freq <- unique_total(sample_val)
#' datf_test <- data.frame(unique(sample_val), sample_freq)
#' 
#' print(how_unif(inpt_datf = datf_test, normalised = FALSE))
#'
#' [1] 0.7797352
#'
#' @export

how_unif <- function(inpt_v, normalised = TRUE){
  diff_add = 0
  val_base <- 1 / length(inpt_v)
  if (normalised){
    for (i in 1:length(inpt_v)){
      diff_add = diff_add + abs(val_base - inpt_v[i])
    }
  }else{
    n <- sum(inpt_v)
    for (i in 1:length(inpt_v)){
      diff_add = diff_add + abs(val_base - (inpt_v[i] / n))
    }
  }
  return(diff_add)
}

#' successive_diff 
#'
#' Allow to see the difference beteen the suxxessive elements of an numeric vector
#'
#' @param inpt_v is the input numeric vector
#' @examples
#'
#' print(successive_diff(c(1:10)))
#'
#' [1] 1 1 1 1 1
#'
#' print(successive_diff(c(1:11, 13, 19)))
#'
#' [1] 1 1 1 1 1 2 6
#' 
#' @export

successive_diff <- function(inpt_v){
  lngth <- length(inpt_v)
  if (lngth > 1){
    if (lngth %% 2 == 0){
      return(inpt_v[seq(from = 2, to = lngth, by = 2)] - inpt_v[seq(from = 1, to = (lngth - 1), by = 2)])
    }else{
      return(c(inpt_v[seq(from = 2, to = (lngth - 1), by = 2)] - inpt_v[seq(from = 1, to = (lngth - 2), by = 2)], 
               inpt_v[lngth] - inpt_v[(lngth - 1)]))
    }
  }
  return(NULL)
}

#' infinite_char_seq 
#'
#' Allow to generate an infinite sequence of unique letters
#'
#' @param n is how many sequence of numbers will be generated
#' @param base_char is the vector containing the elements from which the sequence is generated
#' @examples
#'
#' print(infinite_char_seq(28))
#'
#'  [1] "a"  "b"  "c"  "d"  "e"  "f"  "g"  "h"  "i"  "j"  "k"  "l"  "m"  "n"  "o" 
#' [16] "p"  "q"  "r"  "s"  "t"  "u"  "v"  "w"  "x"  "y"  "a"  "aa" "ab"
#'
#' @export

infinite_char_seq <- function(n, base_char = letters){
  Rtnl <- c()
  for (I in 1:n){
    n <- I
    rtn_v <- c()
    cnt = 0
    while (26 ** cnt <= n){
      cnt = cnt + 1
      reste <- n %% (26 ** cnt)
      if (reste != 0){
        if (reste >= 26){ reste2 <- reste / (26 ** (cnt - 1)) }else{ reste2 <- reste }
        rtn_v <- c(rtn_v, base_char[reste2])
      }else{
        reste <- 26 ** cnt
        rtn_v <- c(rtn_v, base_char[26])
      }
      n = n - reste
    }
    Rtnl <- c(Rtnl, paste(rtn_v[length(rtn_v):1], collapse = ""))
  }
  return(Rtnl)
}


#' sort_normal_qual
#'
#' Sort qualitative modalities that have their frequency normally distributed from an unordered dataset, see examples. This function uses an another algorythm than choose_normal_qual2 which may be faster.
#'
#' @param inpt_datf is the input dataframe, containing the values in the first column and their frequency in the second
#' @examples
#'
#' sample_val <- round(rnorm(n = 2000, mean = 12, sd = 2), 1)
#' sample_freq <- unique_total(sample_val)
#' sample_qual <- infinite_char_seq(n = length(sample_freq))
#' datf_test <- data.frame(sample_qual, sample_freq)
#' datf_test[, 2] <- datf_test[, 2] / sum(datf_test[, 2]) # optional
#' 
#' print(datf_test)
#' 
#'    sample_qual sample_freq
#' 1             a 0.208695652
#' 2             b 0.234782609
#' 3             c 0.321739130
#' 4             d 0.339130435
#' 5             e 0.330434783
#' 6             f 0.069565217
#' 7             g 0.234782609
#' 8             h 0.400000000
#' 9             i 0.347826087
#' 10            j 0.043478261
#' 11            k 0.278260870
#' 12            l 0.286956522
#' 13            m 0.243478261
#' 14            n 0.147826087
#' 15            o 0.234782609
#' 16            p 0.252173913
#' 17            q 0.417391304
#' 18            r 0.095652174
#' 19            s 0.313043478
#' 20            t 0.008695652
#' 21            u 0.130434783
#' 22            v 0.391304348
#' 23            w 0.113043478
#' 24            x 0.295652174
#' 25            y 0.243478261
#' 26            z 0.382608696
#' 27           aa 0.008695652
#' 28           ab 0.347826087
#' 29           ac 0.330434783
#' 30           ad 0.321739130
#' 31           ae 0.347826087
#' 32           af 0.321739130
#' 33           ag 0.173913043
#' 34           ah 0.278260870
#' 35           ai 0.278260870
#' 36           aj 0.347826087
#' 37           ak 0.026086957
#' 38           al 0.295652174
#' 39           am 0.226086957
#' 40           an 0.295652174
#' 41           ao 0.234782609
#' 42           ap 0.113043478
#' 43           aq 0.234782609
#' 44           ar 0.173913043
#' 45           as 0.017391304
#' 46           at 0.252173913
#' 47           au 0.078260870
#' 48           av 0.086956522
#' 49           aw 0.278260870
#' 50           ax 0.086956522
#' 51           ay 0.200000000
#' 52           az 0.295652174
#' 53           ba 0.052173913
#' 54           bb 0.165217391
#' 55           bc 0.408695652
#' 56           bd 0.269565217
#' 57           be 0.104347826
#' 58           bf 0.391304348
#' 59           bg 0.104347826
#' 60           bh 0.043478261
#' 61           bi 0.200000000
#' 62           bj 0.095652174
#' 63           bk 0.191304348
#' 64           bl 0.008695652
#' 65           bm 0.165217391
#' 66           bn 0.226086957
#' 67           bo 0.086956522
#' 68           bp 0.017391304
#' 69           bq 0.121739130
#' 70           br 0.234782609
#' 71           bs 0.121739130
#' 72           bt 0.078260870
#' 73           bu 0.173913043
#' 74           bv 0.104347826
#' 75           bw 0.208695652
#' 76           bx 0.017391304
#' 77           by 0.243478261
#' 78           bz 0.034782609
#' 79           ca 0.017391304
#' 80           cb 0.008695652
#' 81           cc 0.173913043
#' 82           cd 0.147826087
#' 83           ce 0.060869565
#' 84           cf 0.017391304
#' 85           cg 0.060869565
#' 86           ch 0.008695652
#' 87           ci 0.208695652
#' 88           cj 0.043478261
#' 89           ck 0.052173913
#' 90           cl 0.017391304
#' 91           cm 0.017391304
#' 92           cn 0.095652174
#' 93           co 0.113043478
#' 94           cp 0.017391304
#' 95           cq 0.017391304
#' 96           cr 0.026086957
#' 97           cs 0.034782609
#' 98           ct 0.017391304
#' 99           cu 0.026086957
#' 100          cv 0.026086957
#' 101          cw 0.026086957
#' 102          cx 0.017391304
#' 103          cy 0.043478261
#' 104          cz 0.008695652
#' 105          da 0.034782609
#' 106          db 0.017391304
#' 107          dc 0.060869565
#' 108          dd 0.008695652
#' 109          de 0.008695652
#' 110          df 0.017391304
#' 111          dg 0.008695652
#' 112          dh 0.008695652
#' 113          di 0.017391304
#' 114          dj 0.008695652
#' 115          dk 0.008695652
#'
#' print(sort_normal_qual(inpt_datf = datf_test))
#' 
#'0.00869565217391304 0.00869565217391304 0.00869565217391304 0.00869565217391304 
#'               "aa"                "cb"                "cz"                "de" 
#'0.00869565217391304 0.00869565217391304  0.0173913043478261  0.0173913043478261 
#'               "dh"                "dk"                "bp"                "ca" 
#' 0.0173913043478261  0.0173913043478261  0.0173913043478261  0.0173913043478261 
#'               "cl"                "cp"                "ct"                "db" 
#' 0.0173913043478261  0.0260869565217391  0.0260869565217391  0.0347826086956522 
#'               "di"                "cr"                "cv"                "bz" 
#' 0.0347826086956522  0.0434782608695652  0.0434782608695652  0.0521739130434783 
#'               "da"                "bh"                "cy"                "ck" 
#' 0.0608695652173913  0.0695652173913043  0.0782608695652174  0.0869565217391304 
#'               "cg"                 "f"                "bt"                "ax" 
#' 0.0956521739130435  0.0956521739130435   0.104347826086957    0.11304347826087 
#'                "r"                "cn"                "bg"                 "w" 
#'   0.11304347826087   0.121739130434783   0.147826086956522   0.165217391304348 
#'               "co"                "bs"                 "n"                "bb" 
#'  0.173913043478261   0.173913043478261   0.191304347826087                 0.2 
#'               "ag"                "bu"                "bk"                "bi" 
#'  0.208695652173913   0.226086956521739   0.234782608695652   0.234782608695652 
#'               "bw"                "am"                 "b"                 "o" 
#'  0.234782608695652   0.243478260869565   0.243478260869565   0.252173913043478 
#'               "aq"                 "m"                "by"                "at" 
#'  0.278260869565217   0.278260869565217    0.28695652173913   0.295652173913043 
#'                "k"                "ai"                 "l"                "al" 
#'  0.295652173913043   0.321739130434783   0.321739130434783   0.330434782608696 
#'               "az"                 "c"                "af"                "ac" 
#'  0.347826086956522   0.347826086956522   0.382608695652174   0.391304347826087 
#'                "i"                "ae"                 "z"                "bf" 
#'  0.408695652173913   0.417391304347826                 0.4   0.391304347826087 
#'               "bc"                 "q"                 "h"                 "v" 
#'  0.347826086956522   0.347826086956522   0.339130434782609   0.330434782608696 
#'               "aj"                "ab"                 "d"                 "e" 
#'  0.321739130434783    0.31304347826087   0.295652173913043   0.295652173913043 
#'               "ad"                 "s"                "an"                 "x" 
#'  0.278260869565217   0.278260869565217   0.269565217391304   0.252173913043478 
#'               "aw"                "ah"                "bd"                 "p" 
#'  0.243478260869565   0.234782608695652   0.234782608695652   0.234782608695652 
#'                "y"                "br"                "ao"                 "g" 
#'  0.226086956521739   0.208695652173913   0.208695652173913                 0.2 
#'               "bn"                "ci"                 "a"                "ay" 
#'  0.173913043478261   0.173913043478261   0.165217391304348   0.147826086956522 
#'               "cc"                "ar"                "bm"                "cd" 
#'  0.130434782608696   0.121739130434783    0.11304347826087   0.104347826086957 
#'                "u"                "bq"                "ap"                "bv" 
#'  0.104347826086957  0.0956521739130435  0.0869565217391304  0.0869565217391304 
#'               "be"                "bj"                "bo"                "av" 
#' 0.0782608695652174  0.0608695652173913  0.0608695652173913  0.0521739130434783 
#'               "au"                "dc"                "ce"                "ba" 
#' 0.0434782608695652  0.0434782608695652  0.0347826086956522  0.0260869565217391 
#'               "cj"                 "j"                "cs"                "cw" 
#' 0.0260869565217391  0.0260869565217391  0.0173913043478261  0.0173913043478261 
#'               "cu"                "ak"                "df"                "cx" 
#' 0.0173913043478261  0.0173913043478261  0.0173913043478261  0.0173913043478261 
#'               "cq"                "cm"                "cf"                "bx" 
#' 0.0173913043478261 0.00869565217391304 0.00869565217391304 0.00869565217391304 
#'               "as"                "dj"                "dg"                "dd" 
#'0.00869565217391304 0.00869565217391304 0.00869565217391304 
#'               "ch"                "bl"                 "t" 
#' 
#' @export

sort_normal_qual <- function(inpt_datf){
  rtn_v <- c()
  max_ <- max(inpt_datf[, 2]) + 1
  pre_stat_freq <- inpt_datf[, 2]
  cnt = 1
  while (cnt <= (nrow(inpt_datf) %/% 2)){
    id_min <- which.min(inpt_datf[, 2])
    rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = length(rtn_v) / 2)
    inpt_datf[id_min, 2] <- max_
    id_min <- which.min(inpt_datf[, 2])
    rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = (length(rtn_v) - 1) / 2)
    inpt_datf[id_min, 2] <- max_
    cnt = cnt + 1
  }
  if (nrow(inpt_datf) %% 2 != 0){
    rtn_v <- append(x = rtn_v, value = inpt_datf[which.min(inpt_datf[, 2]), 1], after = length(rtn_v) / 2)
  }
  names(rtn_v) <- pre_stat_freq[match(x = rtn_v, table = inpt_datf[, 1])]
  return(rtn_v)
}

#' sort_normal_qual2
#'
#' Sort qualitative modalities that have their frequency normally distributed from an unordered dataset, see examples. This function uses an another algorythm than choose_normal_qual which may be faster.
#'
#' @param inpt_datf is the input dataframe, containing the values in the first column and their frequency in the second
#' @examples
#'
#' sample_val <- round(rnorm(n = 2000, mean = 12, sd = 2), 1)
#' sample_freq <- unique_total(sample_val)
#' sample_qual <- infinite_char_seq(n = length(sample_freq))
#' datf_test <- data.frame(sample_qual, sample_freq)
#' datf_test[, 2] <- datf_test[, 2] / sum(datf_test[, 2])
#' 
#' print(datf_test)
#' 
#'    sample_qual sample_freq
#' 1             a 0.208695652
#' 2             b 0.234782609
#' 3             c 0.321739130
#' 4             d 0.339130435
#' 5             e 0.330434783
#' 6             f 0.069565217
#' 7             g 0.234782609
#' 8             h 0.400000000
#' 9             i 0.347826087
#' 10            j 0.043478261
#' 11            k 0.278260870
#' 12            l 0.286956522
#' 13            m 0.243478261
#' 14            n 0.147826087
#' 15            o 0.234782609
#' 16            p 0.252173913
#' 17            q 0.417391304
#' 18            r 0.095652174
#' 19            s 0.313043478
#' 20            t 0.008695652
#' 21            u 0.130434783
#' 22            v 0.391304348
#' 23            w 0.113043478
#' 24            x 0.295652174
#' 25            y 0.243478261
#' 26            z 0.382608696
#' 27           aa 0.008695652
#' 28           ab 0.347826087
#' 29           ac 0.330434783
#' 30           ad 0.321739130
#' 31           ae 0.347826087
#' 32           af 0.321739130
#' 33           ag 0.173913043
#' 34           ah 0.278260870
#' 35           ai 0.278260870
#' 36           aj 0.347826087
#' 37           ak 0.026086957
#' 38           al 0.295652174
#' 39           am 0.226086957
#' 40           an 0.295652174
#' 41           ao 0.234782609
#' 42           ap 0.113043478
#' 43           aq 0.234782609
#' 44           ar 0.173913043
#' 45           as 0.017391304
#' 46           at 0.252173913
#' 47           au 0.078260870
#' 48           av 0.086956522
#' 49           aw 0.278260870
#' 50           ax 0.086956522
#' 51           ay 0.200000000
#' 52           az 0.295652174
#' 53           ba 0.052173913
#' 54           bb 0.165217391
#' 55           bc 0.408695652
#' 56           bd 0.269565217
#' 57           be 0.104347826
#' 58           bf 0.391304348
#' 59           bg 0.104347826
#' 60           bh 0.043478261
#' 61           bi 0.200000000
#' 62           bj 0.095652174
#' 63           bk 0.191304348
#' 64           bl 0.008695652
#' 65           bm 0.165217391
#' 66           bn 0.226086957
#' 67           bo 0.086956522
#' 68           bp 0.017391304
#' 69           bq 0.121739130
#' 70           br 0.234782609
#' 71           bs 0.121739130
#' 72           bt 0.078260870
#' 73           bu 0.173913043
#' 74           bv 0.104347826
#' 75           bw 0.208695652
#' 76           bx 0.017391304
#' 77           by 0.243478261
#' 78           bz 0.034782609
#' 79           ca 0.017391304
#' 80           cb 0.008695652
#' 81           cc 0.173913043
#' 82           cd 0.147826087
#' 83           ce 0.060869565
#' 84           cf 0.017391304
#' 85           cg 0.060869565
#' 86           ch 0.008695652
#' 87           ci 0.208695652
#' 88           cj 0.043478261
#' 89           ck 0.052173913
#' 90           cl 0.017391304
#' 91           cm 0.017391304
#' 92           cn 0.095652174
#' 93           co 0.113043478
#' 94           cp 0.017391304
#' 95           cq 0.017391304
#' 96           cr 0.026086957
#' 97           cs 0.034782609
#' 98           ct 0.017391304
#' 99           cu 0.026086957
#' 100          cv 0.026086957
#' 101          cw 0.026086957
#' 102          cx 0.017391304
#' 103          cy 0.043478261
#' 104          cz 0.008695652
#' 105          da 0.034782609
#' 106          db 0.017391304
#' 107          dc 0.060869565
#' 108          dd 0.008695652
#' 109          de 0.008695652
#' 110          df 0.017391304
#' 111          dg 0.008695652
#' 112          dh 0.008695652
#' 113          di 0.017391304
#' 114          dj 0.008695652
#' 115          dk 0.008695652
#'
#' print(sort_normal_qual2(inpt_datf = datf_test))
#' 
#'0.00869565217391304 0.00869565217391304 0.00869565217391304 0.00869565217391304 
#'               "aa"                "cb"                "cz"                "de" 
#'0.00869565217391304 0.00869565217391304  0.0173913043478261  0.0173913043478261 
#'               "dh"                "dk"                "bp"                "ca" 
#' 0.0173913043478261  0.0173913043478261  0.0173913043478261  0.0173913043478261 
#'               "cl"                "cp"                "ct"                "db" 
#' 0.0173913043478261  0.0260869565217391  0.0260869565217391  0.0347826086956522 
#'               "di"                "cr"                "cv"                "bz" 
#' 0.0347826086956522  0.0434782608695652  0.0434782608695652  0.0521739130434783 
#'               "da"                "bh"                "cy"                "ck" 
#' 0.0608695652173913  0.0695652173913043  0.0782608695652174  0.0869565217391304 
#'               "cg"                 "f"                "bt"                "ax" 
#' 0.0956521739130435  0.0956521739130435   0.104347826086957    0.11304347826087 
#'                "r"                "cn"                "bg"                 "w" 
#'   0.11304347826087   0.121739130434783   0.147826086956522   0.165217391304348 
#'               "co"                "bs"                 "n"                "bb" 
#'  0.173913043478261   0.173913043478261   0.191304347826087                 0.2 
#'               "ag"                "bu"                "bk"                "bi" 
#'  0.208695652173913   0.226086956521739   0.234782608695652   0.234782608695652 
#'               "bw"                "am"                 "b"                 "o" 
#'  0.234782608695652   0.243478260869565   0.243478260869565   0.252173913043478 
#'               "aq"                 "m"                "by"                "at" 
#'  0.278260869565217   0.278260869565217    0.28695652173913   0.295652173913043 
#'                "k"                "ai"                 "l"                "al" 
#'  0.295652173913043   0.321739130434783   0.321739130434783   0.330434782608696 
#'               "az"                 "c"                "af"                "ac" 
#'  0.347826086956522   0.347826086956522   0.382608695652174   0.391304347826087 
#'                "i"                "ae"                 "z"                "bf" 
#'  0.408695652173913   0.417391304347826                 0.4   0.391304347826087 
#'               "bc"                 "q"                 "h"                 "v" 
#'  0.347826086956522   0.347826086956522   0.339130434782609   0.330434782608696 
#'               "aj"                "ab"                 "d"                 "e" 
#'  0.321739130434783    0.31304347826087   0.295652173913043   0.295652173913043 
#'               "ad"                 "s"                "an"                 "x" 
#'  0.278260869565217   0.278260869565217   0.269565217391304   0.252173913043478 
#'               "aw"                "ah"                "bd"                 "p" 
#'  0.243478260869565   0.234782608695652   0.234782608695652   0.234782608695652 
#'                "y"                "br"                "ao"                 "g" 
#'  0.226086956521739   0.208695652173913   0.208695652173913                 0.2 
#'               "bn"                "ci"                 "a"                "ay" 
#'  0.173913043478261   0.173913043478261   0.165217391304348   0.147826086956522 
#'               "cc"                "ar"                "bm"                "cd" 
#'  0.130434782608696   0.121739130434783    0.11304347826087   0.104347826086957 
#'                "u"                "bq"                "ap"                "bv" 
#'  0.104347826086957  0.0956521739130435  0.0869565217391304  0.0869565217391304 
#'               "be"                "bj"                "bo"                "av" 
#' 0.0782608695652174  0.0608695652173913  0.0608695652173913  0.0521739130434783 
#'               "au"                "dc"                "ce"                "ba" 
#' 0.0434782608695652  0.0434782608695652  0.0347826086956522  0.0260869565217391 
#'               "cj"                 "j"                "cs"                "cw" 
#' 0.0260869565217391  0.0260869565217391  0.0173913043478261  0.0173913043478261 
#'               "cu"                "ak"                "df"                "cx" 
#' 0.0173913043478261  0.0173913043478261  0.0173913043478261  0.0173913043478261 
#'               "cq"                "cm"                "cf"                "bx" 
#' 0.0173913043478261 0.00869565217391304 0.00869565217391304 0.00869565217391304 
#'               "as"                "dj"                "dg"                "dd" 
#'0.00869565217391304 0.00869565217391304 0.00869565217391304 
#'               "ch"                "bl"                 "t" 
#'
#' @export

sort_normal_qual2 <- function(inpt_datf){
  rtn_v <- c()
  pre_stat_freq <- inpt_datf[, 2]
  pre_stat_mod <- inpt_datf[, 1]
  cnt = 1
  while (cnt <= (nrow(inpt_datf) %/% 2)){
    id_min <- which.min(inpt_datf[, 2])
    rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = length(rtn_v) / 2)
    inpt_datf <- inpt_datf[-id_min, ]
    id_min <- which.min(inpt_datf[, 2])
    rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = (length(rtn_v) - 1) / 2)
    inpt_datf <- inpt_datf[id_min, ]
    cnt = cnt + 1
  }
  if (nrow(inpt_datf) %% 2 != 0){
    rtn_v <- append(x = rtn_v, value = inpt_datf[which.min(inpt_datf[, 2]), 1], after = length(rtn_v) / 2)
  }
  names(rtn_v) <- pre_stat_freq[match(x = rtn_v, table = pre_stat_mod)]
  return(rtn_v)
}

#' normal_dens
#'
#' Calculates the normal distribution probality, see examples
#'
#' @param target_v is the target value(s) (one or bounded), see examples
#' @param mean is the mean of the normal distribution
#' @param sd is the standard deviation of the normal distribution
#' @examples
#'
#' print(normal_dens(target_v = 13, mean = 12, sd = 2))
#'
#' [1] 0.1760327
#'
#' print(normal_dens(target_v = c(9, 11), mean = 12, sd = 1.5, step = 0.01))
#'
#' [1] 0.2288579
#'
#' print(normal_dens(target_v = c(1, 18), mean = 12, sd = 1.5, step = 0.01))
#'
#' [1] 0.9999688
#'
#' @export

normal_dens <- function(target_v = c(), mean, sd){
  if (length(target_v) == 1){
    return((1 / (sd * sqrt(2 * pi))) * exp(-(((target_v - mean) / sd) ** 2) / 2))
  }else{
      rtn_val = rtn_val + (1 / (sd * sqrt(2 * pi))) * exp(-(((target_v[1] + cnt - mean) / sd) ** 2) / 2) * 0.01
    return(rtn_val)
  }
}

#' union_keep
#'
#' Performs a union operation keeping the number of elements of all input vectors, see examples
#'
#' @param ... are all the input vectors
#' @examples
#'
#' print(union_keep(c("a", "ee", "ee"), c("p", "p", "a", "i"), c("a", "a", "z")))
#'
#' [1] "a"  "ee" "ee" "p"  "p"  "i"  "z" 
#'
#' print(union_keep(c("a", "ee", "ee"), c("p", "p", "a", "i")))
#'
#' [1] "a"  "ee" "ee" "p"  "p"  "i" 
#'
#' @export

union_keep <- function(...){
  lst <- list(...)
  rtn_v <- unlist(lst[1])
  if (length(lst) > 1){ 
    see_diff <- function(vec1 = c(), vec2 = c()){
      return(setdiff(union(vec1, vec2), intersect(vec1, vec2)))
    } 
    grep_all <- function(inpt_v, pattern_v){
      rtn_v <- c(grep(pattern = pattern_v[1], x = inpt_v))
      if (length(pattern_v) > 1){
        pattern_v <- pattern_v[2:length(pattern_v)]
        for (ptrn in pattern_v){
          rtn_v <- c(rtn_v, grep(pattern = ptrn, x = inpt_v))
        }
      }
      return(rtn_v)
    }
    lst <- lst[2:length(lst)]
    for (vec in lst){
      diff_vec <- paste0("^", see_diff(rtn_v, vec), "$")
      if (!(is.null(diff_vec))){
        rtn_v <- c(rtn_v, vec[grep_all(inpt_v = vec, pattern_v = diff_vec)])
      }
    }
    return(rtn_v)
  }else{
    return(rtn_v)
  }
}


#' extract_normal
#'
#' Allow to extract values that fits a normal distribution from any kind of dataset, see examples and parameters
#' 
#' @param inpt_datf is the input dataset as a dataframe, values/modalities are in the first column and frequency (not normalised) is in the second column 
#' @param mean is the mean of the target normal distribution
#' @param sd is the standard deviation of the target normal distribution
#' @param accuracy is how much of a difference beetween the points of the targeted normal distribution and the actual points is tolerated 
#' @param round_value is the round value for the normal distribution used under the hood to compare the dataset and extract the best points, defaults to 1 
#' @param normalised is if the input frequency is divided by n, if TRUE the parameter `n` must be filled
#' @param n is the number of points
#' @param tries is how many normal distributions are used under the hood to compare their points to the those in the input dataset, defaults to 3. The higher it is, the higher the number of different points from the input dataset will be in accordance for the normal distribution the function tries to build from the dataset. It does not increase by a lot but can be non-negligible and note that the higher the number of tries is, the higher the execution time of the function will be.
#' @examples
#'
#' sample_val <- round(rnorm(n = 72000, mean = 12, sd = 2), 1)
#' sample_freq <- unique_total(sample_val)
#' sample_qual <- infinite_char_seq(n = length(sample_freq))
#' datf_test <- data.frame(sample_qual, sample_freq)
#' n <- nrow(datf_test)
#' print(datf_test)
#'  
#'    sample_qual sample_freq
#' 1             a          72
#' 2             b        1155
#' 3             c        1255
#' 4             d         743
#' 5             e         696
#' 6             f        1028
#' 7             g        1160
#' 8             h        1219
#' 9             i        1353
#' 10            j        1336
#' 11            k        1308
#' 12            l         485
#' 13            m        1306
#' 14            n        1429
#' 15            o         623
#' 16            p        1172
#' 17            q        1054
#' 18            r         999
#' 19            s         125
#' 20            t        1461
#' 21            u        1430
#' 22            v         341
#' 23            w        1453
#' 24            x         427
#' 25            y         869
#' 26            z        1395
#' 27           aa         841
#' 28           ab         952
#' 29           ac         246
#' 30           ad         468
#' 31           ae         237
#' 32           af         555
#' 33           ag        1297
#' 34           ah         571
#' 35           ai         349
#' 36           aj         773
#' 37           ak        1086
#' 38           al        1281
#' 39           am        1471
#' 40           an        1236
#' 41           ao         394
#' 42           ap        1433
#' 43           aq        1328
#' 44           ar         976
#' 45           as         640
#' 46           at         308
#' 47           au         698
#' 48           av         864
#' 49           aw        1346
#' 50           ax        1349
#' 51           ay           6
#' 52           az        1071
#' 53           ba         248
#' 54           bb         929
#' 55           bc         925
#' 56           bd         452
#' 57           be         207
#' 58           bf         546
#' 59           bg          62
#' 60           bh         107
#' 61           bi        1184
#' 62           bj         739
#' 63           bk         624
#' 64           bl         850
#' 65           bm        1408
#' 66           bn         620
#' 67           bo         202
#' 68           bp          10
#' 69           bq         700
#' 70           br         397
#' 71           bs        1291
#' 72           bt         178
#' 73           bu         397
#' 74           bv        1089
#' 75           bw        1301
#' 76           bx         328
#' 77           by        1348
#' 78           bz          97
#' 79           ca        1452
#' 80           cb           4
#' 81           cc         100
#' 82           cd         593
#' 83           ce         503
#' 84           cf         164
#' 85           cg          32
#' 86           ch         259
#' 87           ci        1089
#' 88           cj         249
#' 89           ck         165
#' 90           cl          42
#' 91           cm         143
#' 92           cn         467
#' 93           co         347
#' 94           cp         143
#' 95           cq          69
#' 96           cr          18
#' 97           cs         290
#' 98           ct          55
#' 99           cu         141
#' 100          cv          86
#' 101          cw         303
#' 102          cx          88
#' 103          cy          16
#' 104          cz         213
#' 105          da           3
#' 106          db          75
#' 107          dc          32
#' 108          dd          66
#' 109          de         105
#' 110          df          34
#' 111          dg          56
#' 112          dh          17
#' 113          di          22
#' 114          dj         120
#' 115          dk          54
#' 116          dl           9
#' 117          dm           8
#' 118          dn          36
#' 119          do          20
#' 120          dp          26
#' 121          dq          54
#' 122          dr           8
#' 123          ds          10
#' 124          dt           4
#' 125          du          53
#' 126          dv          29
#' 127          dw           1
#' 128          dx           8
#' 129          dy          10
#' 130          dz           4
#' 131          ea          22
#' 132          eb           9
#' 133          ec          17
#' 134          ed          55
#' 135          ee          21
#' 136          ef           6
#' 137          eg           4
#' 138          eh           3
#' 139          ei           7
#' 140          ej           1
#' 141          ek           4
#' 142          el           2
#' 143          em           5
#' 144          en           4
#' 145          eo           1
#' 146          ep           2
#' 147          eq           3
#' 148          er           8
#' 149          es           4
#' 150          et           3
#' 151          eu           3
#' 152          ev           2
#' 153          ew           2
#' 154          ex           2
#' 155          ey           1
#' 156          ez           2
#' 157          fa           2
#' 158          fb           1
#' 
#' teste <- extract_normal(inpt_datf = datf_test,
#'                      mean = 10,
#'                      sd = 2,
#'                      accuracy = .1,
#'                      round_value = 1,
#'                      normalised = FALSE,
#'                      tries = 5)
#'
#' print(length(unique(teste[, 1])) / n)
#'
#' [1] 0.2848101 # so nearly 28.5 % of the different points were in 
#'  #accordance with the construction of the target normal distribution
#'
#' print(teste)
#'
#'    values    frequency
#' 1       dw 0.0001406866
#' 2       dw 0.0001406866
#' 3       dw 0.0001406866
#' 4       el 0.0002813731
#' 5       el 0.0002813731
#' 6       el 0.0002813731
#' 7       el 0.0002813731
#' 8       da 0.0004220597
#' 9       da 0.0004220597
#' 10      cb 0.0005627462
#' 11      cb 0.0005627462
#' 12      em 0.0007034328
#' 13      ay 0.0008441193
#' 14      ay 0.0008441193
#' 15      ei 0.0009848059
#' 16      ei 0.0009848059
#' 17      ei 0.0009848059
#' 18      dm 0.0011254924
#' 19      bp 0.0014068655
#' 20      cy 0.0022509848
#' 21      cy 0.0022509848
#' 22      cy 0.0022509848
#' 23      dh 0.0023916714
#' 24      dh 0.0023916714
#' 25      cr 0.0025323579
#' 26      ee 0.0029544176
#' 27      di 0.0030951041
#' 28      dp 0.0036578503
#' 29      dp 0.0036578503
#' 30      cg 0.0045019696
#' 31      cg 0.0045019696
#' 32      df 0.0047833427
#' 33      dn 0.0050647158
#' 34      cl 0.0059088351
#' 35      cl 0.0059088351
#' 36      du 0.0074563872
#' 37      du 0.0074563872
#' 38      dg 0.0078784468
#' 39      dg 0.0078784468
#' 40      bg 0.0087225661
#' 41      bg 0.0087225661
#' 42      dd 0.0092853123
#' 43      cq 0.0097073720
#' 44      cq 0.0097073720
#' 45       a 0.0101294316
#' 46      cv 0.0120990433
#' 47      cx 0.0123804164
#' 48      cx 0.0123804164
#' 49      bz 0.0136465954
#' 50      cc 0.0140686550
#' 51      bh 0.0150534609
#' 52      bh 0.0150534609
#' 53      dj 0.0168823860
#' 54       s 0.0175858188
#' 55       s 0.0175858188
#' 56      cm 0.0201181767
#' 57      cf 0.0230725943
#' 58      ck 0.0232132808
#' 59      bt 0.0250422060
#' 60      bt 0.0250422060
#' 61      be 0.0291221159
#' 62      be 0.0291221159
#' 63      cz 0.0299662352
#' 64      cz 0.0299662352
#' 65      be 0.0291221159
#' 66      bo 0.0284186832
#' 67      bt 0.0250422060
#' 68      ck 0.0232132808
#' 69      ck 0.0232132808
#' 70      cm 0.0201181767
#' 71      cu 0.0198368036
#' 72       s 0.0175858188
#' 73      dj 0.0168823860
#' 74      bh 0.0150534609
#' 75      bh 0.0150534609
#' 76      de 0.0147720878
#' 77      bz 0.0136465954
#' 78      bz 0.0136465954
#' 79      cx 0.0123804164
#' 80      cv 0.0120990433
#' 81      db 0.0105514913
#' 82       a 0.0101294316
#' 83      cq 0.0097073720
#' 84      dd 0.0092853123
#' 85      dd 0.0092853123
#' 86      bg 0.0087225661
#' 87      bg 0.0087225661
#' 88      dg 0.0078784468
#' 89      dk 0.0075970737
#' 90      du 0.0074563872
#' 91      cl 0.0059088351
#' 92      cl 0.0059088351
#' 93      dn 0.0050647158
#' 94      df 0.0047833427
#' 95      df 0.0047833427
#' 96      cg 0.0045019696
#' 97      dv 0.0040799100
#' 98      dp 0.0036578503
#' 99      di 0.0030951041
#' 100     di 0.0030951041
#' 101     ee 0.0029544176
#' 102     cr 0.0025323579
#' 103     dh 0.0023916714
#' 104     cy 0.0022509848
#' 105     cy 0.0022509848
#' 106     cy 0.0022509848
#' 107     cy 0.0022509848
#' 108     dl 0.0012661790
#' 109     dm 0.0011254924
#' 110     ei 0.0009848059
#' 111     ei 0.0009848059
#' 112     ay 0.0008441193
#' 113     ay 0.0008441193
#' 114     em 0.0007034328
#' 115     em 0.0007034328
#' 116     cb 0.0005627462
#' 117     cb 0.0005627462
#' 118     da 0.0004220597
#' 119     da 0.0004220597
#' 120     el 0.0002813731
#' 121     el 0.0002813731
#' 122     el 0.0002813731
#' 123     el 0.0002813731
#' 124     dw 0.0001406866
#' 125     dw 0.0001406866
#' 126     dw 0.0001406866
#' 
#' @export

extract_normal <- function(inpt_datf, mean, sd, accuracy, 
                           round_value = 1, normalised = FALSE, n = NA, tries = 3){
  see_diff <- function(vec1 = c(), vec2 = c()){
    return(setdiff(union(vec1, vec2), intersect(vec1, vec2)))
  }
  unique_total <- function(inpt_v = c()){
    rtn_v <- c()
    for (el in unique(inpt_v)){
      rtn_v <- c(rtn_v, length(grep(pattern = paste0("^", el, "$"), x = inpt_v)))
      names(rtn_v)[length(rtn_v)] <- names(inpt_v)[match(x = el, table = inpt_v)]
    }
    return(rtn_v)
  }
  sort_normal_qual <- function(inpt_datf){
    rtn_v <- c()
    max_ <- max(inpt_datf[, 2]) + 1
    pre_stat_freq <- inpt_datf[, 2]
    cnt = 1
    while (cnt <= (nrow(inpt_datf) %/% 2)){
      id_min <- which.min(inpt_datf[, 2])
      rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = length(rtn_v) / 2)
      inpt_datf[id_min, 2] <- max_
      id_min <- which.min(inpt_datf[, 2])
      rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = (length(rtn_v) - 1) / 2)
      inpt_datf[id_min, 2] <- max_
      cnt = cnt + 1
    }
    if (nrow(inpt_datf) %% 2 != 0){
      rtn_v <- append(x = rtn_v, value = inpt_datf[which.min(inpt_datf[, 2]), 1], after = length(rtn_v) / 2)
    }
    names(rtn_v) <- pre_stat_freq[match(x = rtn_v, table = inpt_datf[, 1])]
    return(rtn_v)
  }
  if (!(normalised)){
    n <- sum(inpt_datf[, 2])
    inpt_datf[, 2] <- inpt_datf[, 2] / n
  }else if (is.na(n)){
    return("n must be provided")
  }
  Rtn_v <- c()
  for (I in 1:tries){
    rnorm_val <- c()
    while (length(unique(rnorm_val)) != nrow(inpt_datf)){
      rnorm_val <- round(rnorm(n = n, mean = mean , sd = sd), 1)
    }
    rnorm_freq <- sort(unique_total(rnorm_val) / length(rnorm_val), decreasing = FALSE)
    rtn_v <- c()
    for (i in seq(from = 1, to = nrow(inpt_datf) %/% 2, by = 2)){
      cur_v <- abs(inpt_datf[, 2] - rnorm_freq[i])
      id_min <- which.min(cur_v)
      if (cur_v[id_min] <= accuracy){
        rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = length(rtn_v) / 2)
      }
      cur_v <- abs(inpt_datf[, 2] - rnorm_freq[(i + 1)])
      id_min <- which.min(cur_v)
      if (cur_v[id_min] <= accuracy){
        rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = (length(rtn_v) - 1) / 2)
      }
    }
    if (nrow(inpt_datf) %% 2 != 0){
      cur_v <- abs(inpt_datf[, 2] - rnorm_freq[(i + 1)])
      id_min <- which.min(cur_v)
      if (cur_v[id_min] <= accuracy){
        rtn_v <- append(x = rtn_v, value = inpt_datf[id_min, 1], after = length(rtn_v) / 2)
      }
    }
    if (!(is.null(Rtn_v))){
      diff_v <- see_diff(Rtn_v, rtn_v)
      Rtn_v <- c(Rtn_v, diff_v)
    }else{
      Rtn_v <- rtn_v
    }
  }
  freq_v <- inpt_datf[match(x = Rtn_v, table = inpt_datf[, 1]), 2]
  rtn_datf <- data.frame("values" = Rtn_v, "frequency" = freq_v)
  rtn_datf <- sort_normal_qual(rtn_datf)
  rtn_datf <- data.frame("values" = rtn_datf, "frequency" = as.numeric(names(rtn_datf)))
  rtn_datf[, 2] <- rtn_datf[, 2] / sum(rtn_datf[, 2])
  return(rtn_datf)
}

#' elements_equalifier
#'
#' Takes an input vector with elements that have different occurence, and output a vector with all these elements with the same number of occurence, see examples
#'
#' @param inpt_v is the input vector
#' @param untl is how many times each elements will be in the output vector
#' @examples
#'
#' print(elements_equalifier(letters, untl = 2))
#' 
#'  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
#' [20] "t" "u" "v" "w" "x" "y" "z" "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l"
#' [39] "m" "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
#'
#' print(elements_equalifier(c(letters, letters[-1]), untl = 2))
#' 
#'  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
#' [20] "t" "u" "v" "w" "x" "y" "z" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m"
#' [39] "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z" "a"
#' 
#' @export

elements_equalifier <- function(inpt_v, untl = 3){
  better_unique <- function(inpt_v, occu=">-1-"){
   rtn_v <- c()
   if (typeof(occu) == "character"){
           pre_vec <- str_locate(occu, "-(.*?)-")
           occu_v <- unlist(strsplit(occu, split=""))
           max_val <- as.numeric(occu_v[(pre_vec[1]+1):(pre_vec[length(pre_vec)]-1)])
           comp_ <- paste(occu_v[1:(pre_vec[1] - 1)], collapse="")
           if (comp_ == "=="){
                for (el in unique(inpt_v)){ if (sum(inpt_v == el) == max_val) { rtn_v <- c(rtn_v, el) } }
           }
           if (comp_ == ">"){
                for (el in unique(inpt_v)){ if (sum(inpt_v == el) > max_val) { rtn_v <- c(rtn_v, el) } }
           }
           if (comp_ == "<"){
                for (el in unique(inpt_v)){ if (sum(inpt_v == el) < max_val) { rtn_v <- c(rtn_v, el) } }
           }
   }else{
          for (el in unique(inpt_v)){ if (sum(inpt_v == el) %in% occu) { rtn_v <- c(rtn_v, el) } }
   }
   return(rtn_v)
  }
  occu_val <- paste0("<-", untl, "-")
  for (el in better_unique(inpt_v = inpt_v, occu = occu_val)){
    while (length(grep(x = inpt_v, pattern = el)) < untl){
      inpt_v <- c(inpt_v, el)
    }
  }
  return(inpt_v)
}

#' to_unique
#'
#' Allow to transform a vector containing elements that have more than 1 occurence to a vector with only uniques elements.
#'
#' @param inpt_v is the input vectors
#' @param distinct_type takes two values: suffix or prefix
#' @param distinct_val takes two values: number (unique sequence of number to differencfiate each value) or letter (unique sequence of letters to differenciate each value)
#' @examples
#'
#' print(to_unique(inpt_v = c("a", "a", "e", "a", "i", "i"), 
#'                 distinct_type = "suffix", 
#'                 distinct_val = "number", 
#'                 sep = "-"))
#' 
#' [1] "a-1" "a-2" "e"   "a-3" "i-1" "i-2"
#'
#' print(to_unique(inpt_v = c("a", "a", "e", "a", "i", "i"), 
#'                 distinct_type = "suffix", 
#'                 distinct_val = "letter", 
#'                 sep = "-"))
#' 
#' [1] "a-a" "a-b" "e"   "a-c" "i-a" "i-b"
#'
#' print(to_unique(inpt_v = c("a", "a", "e", "a", "i", "i"), 
#'                 distinct_type = "prefix", 
#'                 distinct_val = "number", 
#'                 sep = "/"))
#'
#' [1] "1/a" "2/a" "e"   "3/a" "1/i" "2/i"
#'
#' print(to_unique(inpt_v = c("a", "a", "e", "a", "i", "i"), 
#'                 distinct_type = "prefix", 
#'                 distinct_val = "letter", 
#'                 sep = "_"))
#' 
#' [1] "a_a" "b_a" "e"   "c_a" "a_i" "b_i" 
#'
#' @export

to_unique <- function(inpt_v, distinct_type = "suffix", distinct_val = "number", sep = "-"){
  nb_to_letter <- function(x){
    rtn_v <- c()
    cnt = 0
    while (26 ** cnt <= x){
      cnt = cnt + 1
      reste <- x %% (26 ** cnt)
      if (reste != 0){
        if (reste >= 26){ reste2 <- reste / (26 ** (cnt - 1)) }else{ reste2 <- reste }
        rtn_v <- c(rtn_v, letters[reste2])
      }else{
        reste <- 26 ** cnt
        rtn_v <- c(rtn_v, letters[26])
      }
      x = x - reste
    }
    return(paste(rtn_v[length(rtn_v):1], collapse = ""))
  }
  better_unique <- function(inpt_v, occu=">-1-"){
    rtn_v <- c()
    if (typeof(occu) == "character"){
            pre_vec <- str_locate(occu, "-(.*?)-")
            occu_v <- unlist(strsplit(occu, split=""))
            max_val <- as.numeric(occu_v[(pre_vec[1]+1):(pre_vec[length(pre_vec)]-1)])
            comp_ <- paste(occu_v[1:(pre_vec[1] - 1)], collapse="")
            if (comp_ == "=="){
                 for (el in unique(inpt_v)){ if (sum(inpt_v == el) == max_val) { rtn_v <- c(rtn_v, el) } }
            }
            if (comp_ == ">"){
                 for (el in unique(inpt_v)){ if (sum(inpt_v == el) > max_val) { rtn_v <- c(rtn_v, el) } }
            }
    }else{
           for (el in unique(inpt_v)){ if (sum(inpt_v == el) %in% occu) { rtn_v <- c(rtn_v, el) } }
    }
    return(rtn_v)
  }
  non_unique_v <- better_unique(inpt_v = inpt_v)
  if (distinct_type == "suffix"){
    if (distinct_val == "number"){
      for (el in non_unique_v){
        cnt = 1
        for (idx in grep(x = inpt_v, pattern = el)){
          inpt_v[idx] <- paste0(inpt_v[idx], sep, cnt)  
          cnt = cnt + 1
        }
      }
    }else if (distinct_val == "letter"){
      for (el in non_unique_v){
        cnt = 1
        for (idx in grep(x = inpt_v, pattern = el)){
          inpt_v[idx] <- paste0(inpt_v[idx], sep, nb_to_letter(cnt))
          cnt = cnt + 1
        }
      }
    }else{
      return("Invalid distinct_val specification")
    }
  }else if (distinct_type == "prefix"){
    if (distinct_val == "number"){
      for (el in non_unique_v){
        cnt = 1
        for (idx in grep(x = inpt_v, pattern = el)){
          inpt_v[idx] <- paste0(cnt, sep, inpt_v[idx])  
          cnt = cnt + 1
        }
      }
    }else if (distinct_val == "letter"){
      for (el in non_unique_v){
        cnt = 1
        for (idx in grep(x = inpt_v, pattern = el)){
          inpt_v[idx] <- paste0(nb_to_letter(cnt), sep, inpt_v[idx])
          cnt = cnt + 1
        }
      }
    }else{
      return("Invalid distinct_val specification")
    }
  }else{
    return("Invalid distinct_type specification")
  }
  return(inpt_v)
}

#' selected_char 
#'
#' Allow to generate a char based on a conbinaison on characters from a vector and a number
#'
#' @param n is how many sequence of numbers will be generated
#' @param base_char is the vector containing the elements from which the character is generated
#' @examples
#'
#' print(selected_char(1222))
#'
#' [1] "zta"
#'
#' @export

selected_char <- function(n, base_char = letters){
  rtn_v <- c()
  cnt = 0
  while (26 ** cnt <= n){
    cnt = cnt + 1
    reste <- n %% (26 ** cnt)
    if (reste != 0){
      if (reste >= 26){ reste2 <- reste / (26 ** (cnt - 1)) }else{ reste2 <- reste }
      rtn_v <- c(rtn_v, base_char[reste2])
    }else{
      reste <- 26 ** cnt
      rtn_v <- c(rtn_v, base_char[26])
    }
    n = n - reste
  }
  return(paste(rtn_v, collapse = ""))
}

#' cumulated_rows
#'
#' Output a vector of size that equals to the rows number of the input dataframe, with TRUE value at the indices corresponding to the row where at least a cell of any column is equal to one of the values inputed in `values_v`
#'
#' @param inpt_datf is the input data.frame
#' @param values_v is a vector containing all the values that a cell has to equal to return a TRUE value in the output vector at the index corresponding to the row of the cell
#'
#' @examples
#' 
#' datf_teste <- data.frame(c(1:10), c(10:1))
#'
#' print(datf_teste)
#'
#'    c.1.10. c.10.1.
#' 1        1      10
#' 2        2       9
#' 3        3       8
#' 4        4       7
#' 5        5       6
#' 6        6       5
#' 7        7       4
#' 8        8       3
#' 9        9       2
#' 10      10       1
#'
#' print(cumulated_rows(inpt_datf = datf_teste, values_v = c(2, 3)))
#' 
#' [1]   FALSE TRUE TRUE   FALSE   FALSE   FALSE   FALSE TRUE TRUE   FALSE
#'
#' @export

cumulated_rows <- function(inpt_datf, values_v = c()){
  rtn_v <- c(matrix(nrow = nrow(inpt_datf), ncol = 1, data = FALSE))
  cur_v <- inpt_datf[, 1]
  for (val in values_v){
    rtn_v[cur_v == val] <- TRUE
  }
  if (ncol(inpt_datf) > 1){
    for (i in c(2:ncol(inpt_datf))){
      cur_v <- inpt_datf[, i]
      for (val in values_v){
        rtn_v[cur_v == val] <- TRUE
      }
    }
  }
  return(rtn_v)
}

#' cumulated_rows_na
#'
#' Output a vector of size that equals to the rows number of the input dataframe, with TRUE value at the indices corresponding to the row where at least a cell of any column is equal to NA.
#'
#' @param inpt_datf is the input data.frame
#'
#' @examples
#'
#' datf_teste <- data.frame(c(1, 2, 3, 4, 5, NA, 7), c(10, 9, 8, NA, 7, 6, NA))
#'
#' print(datf_teste)
#' 
#'   c.1..2..3..4..5..NA..7. c.10..9..8..NA..7..6..NA.
#' 1                       1                        10
#' 2                       2                         9
#' 3                       3                         8
#' 4                       4                        NA
#' 5                       5                         7
#' 6                      NA                         6
#' 7                       7                        NA
#' 
#' print(cumulated_rows_na(inpt_datf = datf_teste))
#'
#' [1] FALSE FALSE FALSE  TRUE FALSE  TRUE  TRUE
#'
#' @export

cumulated_rows_na <- function(inpt_datf){
  rtn_v <- c(matrix(nrow = nrow(inpt_datf), ncol = 1, data = FALSE))
  cur_v <- inpt_datf[, 1]
  rtn_v[is.na(cur_v)] <- TRUE
  if (ncol(inpt_datf) > 1){
    for (i in c(2:ncol(inpt_datf))){
      cur_v <- inpt_datf[, i]
      rtn_v[is.na(cur_v)] <- TRUE
    }
  }
  return(rtn_v)
}

#' unique_datf
#' 
#' Returns the input dataframe with the unique columns or rows.
#'
#' @param inpt_datf is the input dataframe
#' @param col is a parameter that specifies if the dataframe returned should have unique columns or rows, defaults to F, so the dataframe returned by default has unique rows
#' @examples
#'
#' datf1 <- data.frame(c(1, 2, 1, 3), c("a", "z", "a", "p"))
#'
#' print(datf1)
#' 
#'   c.1..2..1..3. c..a....z....a....p.. c.1..2..1..3..1
#' 1             1                     a               1
#' 2             2                     z               2
#' 3             1                     a               1
#' 4             3                     p               3
#'
#' print(unique_datf(inpt_datf=datf1))
#' 
#' #   c.1..2..1..3. c..a....z....a....p..
#' #1             1                     a
#' #2             2                     z
#' #4             3                     p
#' 
#' datf1 <- data.frame(c(1, 2, 1, 3), c("a", "z", "a", "p"), c(1, 2, 1, 3))
#' 
#' print(datf1)
#' 
#'   c.1..2..1..3. c..a....z....a....p..
#' 1             1                     a
#' 2             2                     z
#' 3             1                     a
#' 4             3                     p
#'
#' print(unique_datf(inpt_datf=datf1, col=TRUE))
#' 
#' #  cur_v cur_v
#' #1     1     a
#' #2     2     z
#' #3     1     a
#' #4     3     p
#' 
#' @export

unique_datf <- function(inpt_datf, col = FALSE){
        comp_l <- c()
        if (col){
                rtn_datf <- data.frame(matrix(data=NA, nrow=nrow(inpt_datf), ncol=0))
                for (col in 1:ncol(inpt_datf)){
                        cur_v <- inpt_datf[, col]
                        if ((paste(cur_v, collapse = "") %in% comp_l) == FALSE){ rtn_datf <- cbind(rtn_datf, cur_v) }
                        comp_l <- append(x=comp_l, values=paste(cur_v, collapse = ""))
                }
        }else{
                rtn_datf <- data.frame(matrix(data=NA, nrow=0, ncol=ncol(inpt_datf)))
                for (row in 1:nrow(inpt_datf)){
                        cur_v <- inpt_datf[row, ]
                        if ((paste(cur_v, collapse = "") %in% comp_l) == FALSE){ rtn_datf <- rbind(rtn_datf, cur_v) }
                        comp_l <- append(x=comp_l, values=paste(cur_v, collapse = ""))
                }
        }
    return(rtn_datf)
}

#' better_split_any
#'
#' Allows to split a string by multiple split regardless of their length, returns a vector and not a list. Contrary to better_split, this functions keep the delimiters in the output.
#' @param inpt is the input character
#' @param split_v is the vector containing the splits
#' @examples
#'
#' print(better_split_any(inpt = "o-u_i", split_v = c("-")))
#' 
#' [1] "o"  "-" "u_i"
#'
#' print(better_split_any(inpt = "o-u_i", split_v = c("-", "_")))
#'
#' [1] "o" "-" "u"  "_" "i"
#'
#' print(better_split_any(inpt = "--o--_/m/m/__-opo-/m/-u_i-_--", split_v = c("--", "_", "/")))
#'
#'  [1] "--"    "o"     "--"    "_"     "/"     "m"     "/"     "m"     "/"    
#' [10] "_"     "_"     "-opo-" "/"     "m"     "/"     "-u"    "_"     "i-"   
#' [19] "_"     "--"   
#'
#'
#' print(better_split_any(inpt = "(ok(ee:56))(ok2(oui)(ee:4))", split_v = c("(", ")", ":")))
#'
#'  [1] "("   "ok"  "("   "ee"  ":"   "56"  ")"   ")"   "("   "ok2" "("   "oui"
#'  [13] ")"   "("   "ee"  ":"   "4"   ")"   ")"  
#'
#' @export

better_split_any <- function(inpt, split_v = c()){
  glue_groupr_v <- function(inpt_v, group_v = c(), untl){
    rtn_v <- c()
    cur_v <- c()
    grp_status <- FALSE
    cnt_untl = 0
    for (el in inpt_v) {
      if (el %in% group_v & cnt_untl < untl){
        grp_status <- TRUE
        cur_v <- c(cur_v, el)
        cnt_untl = cnt_untl + 1
      }else if (grp_status){
        grp_status <- FALSE
        rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
        cur_v <- c()
        if (el %in% group_v){
          cnt_untl = 1
          cur_v <- c(el)
          grp_status <- TRUE
        }else{
          cnt_untl = 0
          rtn_v <- c(rtn_v, el)
        }
      }else{
        rtn_v <- c(rtn_v, el)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }
    return(rtn_v)
  }
  regex_spe_detect <- function(inpt){
        fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
          ptrn <- grep(ptrn_fill, inpt_v)
          while (length(ptrn) > 0){
            ptrn <- grep(ptrn_fill, inpt_v)
            idx <- ptrn[1] 
            untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
            pre_val <- inpt_v[(idx - 1)]
            inpt_v[idx] <- pre_val
            if (untl > 0){
              for (i in 1:untl){
                inpt_v <- append(inpt_v, pre_val, idx)
              }
            }
          ptrn <- grep(ptrn_fill, inpt_v)
          }
          return(inpt_v)
        }
        inpt <- unlist(strsplit(x=inpt, split=""))
        may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
        pre_idx <- unique(match(x=inpt, table=may_be_v))
        pre_idx <- pre_idx[!(is.na(pre_idx))]
        for (el in may_be_v[pre_idx]){
                cnt = 0
                for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                        inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                        cnt = cnt + 1
                }
        }
          return(paste(inpt, collapse=""))
  }
  for (split in split_v){
    pre_inpt <- inpt
    inpt <- c()
    lst_splt <- FALSE
    for (el in pre_inpt){
      cur_splt <- unlist(strsplit(x = el, split = regex_spe_detect(split)))
      cur_splt[cur_splt == ""] <- split
      cnt = 1
      while (cnt < length(cur_splt)){
        if (cur_splt[cnt] %in% split_v){
          if (lst_splt & cur_splt[cnt] != split){
            cur_splt <- append(x = cur_splt, values = split, after = cnt)
            cnt = cnt + 2 
          }
          lst_splt <- TRUE
          cnt = cnt + 1
        }else{
          cur_splt <- append(x = cur_splt, values = split, after = cnt)
          lst_splt <- FALSE
          cnt = cnt + 2
        }
      }
      cur_grp <- c()
      split_decomp <- unlist(strsplit(x = split, split = ""))
      for (el2 in split_decomp){ cur_grp <- c(cur_grp, el2) }
      last_verif <- glue_groupr_v(unlist(strsplit(x = el, split = "")), group_v = cur_grp, untl = nchar(split))
      if (sum(grepl(x = last_verif, pattern = regex_spe_detect(split))) == (sum(grepl(x = cur_splt, pattern = regex_spe_detect(split))) + 1)){
        cur_splt <- c(cur_splt, split)
      }
      inpt <- c(inpt, cur_splt)
    }
  }
  return(inpt)
}

#' wide_to_narow_idx
#'
#' Allow to convert the indices of vector ('from_v_ids') which are related to each characters of a vector, to fit the newly established maximum character of the vector, see examples.
#'
#' @param from_v_val is the input vector of elements, or just the total number of characters of the elementsq in the vector
#' @param from_v_ids is the input vector of indices
#' @param val is the value - 1 from which the number of character of an element is too high, so the indices in 'from_v_ids' will be modified
#'
#' @examples
#'
#' print(wide_to_narrow_idx(from_v_val = c("oui", "no", "oui"), from_v_ids = c(4, 6, 9), val = 2))
#'
#'[1] 2 4 5 
#'
#' print(wide_to_narrow_idx(from_v_val = c("oui", "no", "oui"), from_v_ids = c(4, 6, 9), val = 3))
#'
#' [1] 2 2 3 
#'
#' print(wide_to_narrow_idx(from_v_val = c("oui", "no", "oui"), from_v_ids = c(4, 6, 9), val = 1))
#'
#' [1] 4 6 9
#'
#' @export

wide_to_narrow_idx <- function(from_v_val = c(), from_v_ids = c(), val = 1){
  cnt = 0
  lst_cnt = 0
  if (typeof(from_v_val) == "character"){
    untl <- nchar(paste(from_v_val, collapse = ""))
  }else{
    untl <- from_v_val
  }
  I = 1
  from_v_ids2 <- c(matrix(nrow = length(from_v_ids), ncol= 1, data = 0))
  last_add <- TRUE
  while (cnt <= untl){
    if (from_v_ids[I] <= cnt){
      if (last_add){
        while ((from_v_ids[I]) <= cnt){
          I = I + 1
        }
      }else{
        while ((from_v_ids[I]) <= cnt){
          from_v_ids2[I] = from_v_ids2[I] + 1
          I = I + 1
        }
      }
      from_v_ids2[I:length(from_v_ids2)] <- from_v_ids2[I:length(from_v_ids2)] + 1
      last_add <- FALSE
    }else{
      from_v_ids2[I:length(from_v_ids2)] <- from_v_ids2[I:length(from_v_ids2)] + 1
      last_add <- TRUE
    }
    cnt = cnt + val
  }
  return(from_v_ids2)
}

#' dynamic_idx_convertr 
#'
#' Allow to convert the indices of vector ('from_v_ids') which are related to the each characters of a vector (from_v_val), to fit the newly established characters of the vector from_v_val, see examples.
#' 
#' @param from_v_val is the input vector of elements, or just the total number of characters of the elementsq in the vector
#' @param from_v_ids is the input vector of indices
#' @examples
#'
#' print(dynamic_idx_convertr(from_v_ids = c(1, 5), from_v_val = c("oui", "no", "ouI")))
#'
#' [1] 1 2 
#'
#' print(dynamic_idx_convertr(from_v_ids = c(1, 6), from_v_val = c("oui", "no", "ouI")))
#'
#' [1] 1 3
#'
#' @export

dynamic_idx_convertr <- function(from_v_ids, from_v_val){
  lngth <- length(from_v_ids)
  i = 1
  no_stop <- TRUE
  I = 1
  lst_nchar = 0
  while (I <= length(from_v_val) & no_stop){
    while ((nchar(from_v_val[I]) + lst_nchar) >= from_v_ids[i] & no_stop){
      from_v_ids[i] <- I
      if (i == length(from_v_ids)){ no_stop <- FALSE }else{ i = i + 1 }
    }
    lst_nchar = lst_nchar + nchar(from_v_val[I])
    I = I + 1
  }
  return(from_v_ids)
}

#' split_by_step
#'
#' Allow to split a string or a vector of strings by a step, see examples. 
#'
#' @param inpt_v is the input character or vector of characters
#' @param by is the step
#' @examples
#'
#' print(split_by_step(inpt_v = c("o", "u", "i", "n", "o", "o", "u", "i", "o", "Z"), by = 2))
#'
#' [1] "ou" "in" "oo" "ui" "oZ"
#'
#' print(split_by_step(inpt_v = c("o", "u", "i", "n", "o", "o", "u", "i", "o", "Z"), by = 3))
#'
#' [1] "oui" "noo" "uio" "Z"  
#'
#' print(split_by_step(inpt_v = c("o", "u", "i", "n", "o", "o", "u", "i", "o", "Z"), by = 4))
#'
#' [1] "ouin" "ooui" "oZ"  
#'
#' print(split_by_step(inpt_v = 'ouinoouioz', by = 4))
#' 
#' [1] "ouin" "ooui" "oZ"   
#'
#' @export

split_by_step <- function(inpt_v, by){
  if (length(inpt_v) == 1){
    inpt_v <- unlist(strsplit(x = inpt_v, split = ""))
  }
  cnt = 1
  by = by - 1
  rtn_v <- c()
  while ((cnt + by) <= length(inpt_v)){
    rtn_v <- c(rtn_v, paste(inpt_v[cnt:(cnt + by)], collapse = ""))
    cnt = cnt + by + 1
  }
  if (((cnt + by) - length(inpt_v)) < (by + 1)){
    rtn_v <- c(rtn_v, paste(inpt_v[cnt:length(inpt_v)], collapse = ""))
  }
  return(rtn_v)
}

#' glue_groupr_v 
#'
#' Takes an input vector and returns the same vector unlike that certain elements will be glued as an unique element according to thoses designated in a special vector, see examples.
#'
#' @param inpt_v is the input vector
#' @param is a vector containing all the elements that will be glued in the output vector
#'
#' @examples
#'
#' print(glue_groupr_v(inpt_v = c("o", "-", "-", "u", "i", "-", "n", 
#'  "o", "-", "-", "-", "zz", "/", "/"), group_v = c("-", "/")))
#'
#' [1] "o"   "--"  "u"   "i"   "-"   "n"   "o"   "---" "zz"  "//" 
#' 
#' print(glue_groupr_v(inpt_v = c("o", "-", "-", "u", "i", "-", "n", 
#'  "o", "-", "-", "-", "-", "zz", "/", "/"), group_v = c("-", "/"), untl = 3))
#'
#' [1] "o"   "--"  "u"   "i"   "-"   "n"   "o"   "---" "-"   "zz"  "//"  
#'
#' print(glue_groupr_v(inpt_v = c("o", "-", "-", "u", "i", "-", "n", 
#' "o", "-", "-", "-", "-", "zz", "/", "/"), group_v = c("-", "/"), untl = 2))
#'
#' [1] "o"  "--" "u"  "i"  "-"  "n"  "o"  "--" "--" "zz" "//" 
#'
#' @export

glue_groupr_v <- function(inpt_v, group_v = c(), untl){
  rtn_v <- c()
  cur_v <- c()
  grp_status <- FALSE
  cnt_untl = 0
  for (el in inpt_v) {
    if (el %in% group_v & cnt_untl < untl){
      grp_status <- TRUE
      cur_v <- c(cur_v, el)
      cnt_untl = cnt_untl + 1
    }else if (grp_status){
      grp_status <- FALSE
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
      cur_v <- c()
      if (el %in% group_v){
        cnt_untl = 1
        cur_v <- c(el)
        grp_status <- TRUE
      }else{
        cnt_untl = 0
        rtn_v <- c(rtn_v, el)
      }
    }else{
      rtn_v <- c(rtn_v, el)
    }
  }
  if (length(cur_v) > 0){
    rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
  }
  return(rtn_v)
}

#' read_edm_parser
#'
#' Allow to read data from edm parsed dataset, see examples
#'
#' @param inpt is the input dataset
#' @param to_find_v is the vector containing the path to find the data, see examples
#'
#' @examples
#'
#' print(read_edm_parser("(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))", 
#' to_find_v = c("ok", "oui", "rr", "rr2")))
#'
#' [1] "6"
#'
#' print(read_edm_parser("(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))", to_find_v = c("ok", "ee")))
#'
#' [1] "56"
#'
#' print(read_edm_parser("(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))", to_find_v = c("ee")))
#' 
#' [1] "56"
#'
#' @export

read_edm_parser <- function(inpt, to_find_v = c()){
  dynamic_idx_convertr <- function(from_v_ids, from_v_val){
    lngth <- length(from_v_ids)
    i = 1
    no_stop <- TRUE
    I = 1
    lst_nchar = 0
    while (I <= length(from_v_val) & no_stop){
      while ((nchar(from_v_val[I]) + lst_nchar) >= from_v_ids[i] & no_stop){
        from_v_ids[i] <- I
        if (i == length(from_v_ids)){ no_stop <- FALSE }else{ i = i + 1 }
      }
      lst_nchar = lst_nchar + nchar(from_v_val[I])
      I = I + 1
    }
    return(from_v_ids)
  }
  pairs_findr <- function(inpt, ptrn1="(", ptrn2=")"){
          
        regex_spe_detect <- function(inpt){
                fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
                  ptrn <- grep(ptrn_fill, inpt_v)
                  while (length(ptrn) > 0){
                    ptrn <- grep(ptrn_fill, inpt_v)
                    idx <- ptrn[1] 
                    untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
                    pre_val <- inpt_v[(idx - 1)]
                    inpt_v[idx] <- pre_val
                    if (untl > 0){
                      for (i in 1:untl){
                        inpt_v <- append(inpt_v, pre_val, idx)
                      }
                    }
                  ptrn <- grep(ptrn_fill, inpt_v)
                  }
                  return(inpt_v)
                }
                inpt <- unlist(strsplit(x=inpt, split=""))
                may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
                pre_idx <- unique(match(x=inpt, table=may_be_v))
                pre_idx <- pre_idx[!(is.na(pre_idx))]
                for (el in may_be_v[pre_idx]){
                        cnt = 0
                        for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                                inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                                cnt = cnt + 1
                        }
                }
                  return(paste(inpt, collapse=""))
          }
  
          lst <- unlist(strsplit(x=inpt, split=""))
  
          lst_par <- c()
  
          lst_par_calc <- c()
  
          lst_pos <- c()
  
          paires = 1
  
          pre_paires = 1
  
          pre_paires2 = 1
  
          if ((length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2) > 0){
  
                  for (i in 1:(length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2)){ 
  
                          lst_par <- c(lst_par, 0)
  
                          lst_par_calc <- c(lst_par_calc, 0)
  
                          lst_pos <- c(lst_pos, 0)
  
  
                  }
  
          }
  
          vec_ret <- c()
  
          par_ = 1
  
          lvl_par = 0
  
          for (el in 1:length(lst)){
  
             if (lst[el] == ptrn1){
  
                     if (!(is.null(vec_ret))){
  
                             lst_par_calc[pre_paires2:pre_paires][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] + 1
  
                     }else{
  
                             lst_par_calc[pre_paires2:pre_paires] <- lst_par_calc[pre_paires2:pre_paires] + 1
  
                     }
  
                     pre_paires = pre_paires + 1
  
                     pre_cls <- TRUE
  
                     lst_pos[par_] <- el
  
                     par_ = par_ + 1
  
                     lvl_par = lvl_par + 1
  
             }
  
             if (lst[el] == ptrn2){
  
                     lvl_par = lvl_par - 1
  
                     if (!(is.null(vec_ret))){
  
                          lst_par_calc[c(pre_paires2:pre_paires)][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] - 1
  
                          pre_val <- lst_par_calc[pre_paires2:pre_paires][vec_ret]
  
                          lst_par_calc[pre_paires2:pre_paires][vec_ret] <- (-2)
                     
                     }else{
  
                          lst_par_calc[c(pre_paires2:pre_paires)] <- lst_par_calc[pre_paires2:pre_paires] - 1
  
                     }
  
                     if (!(is.null(vec_ret))){ 
  
                             pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])
  
                             lst_par_calc[pre_paires2:pre_paires][vec_ret] <- pre_val 
  
                     }else{
  
                             pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires])
  
                     }
  
                     cnt_par = 1
  
                     cnt2 = 0
  
                     if (!(is.null(vec_ret))){
  
                             vec_ret <- sort(vec_ret)
  
                             if (pre_mtch[1] >= min(vec_ret)){
  
                                  cnt2 = 2
  
                                  while (pre_mtch[1] > cnt_par & cnt2 <= length(vec_ret)){
  
                                          if ((vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) > 1){
  
                                                  cnt_par = cnt_par + (vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) - 1
  
                                          }
  
                                          cnt2 = cnt2 + 1
  
                                  }
  
                                  if (pre_mtch[1] > cnt_par){
  
                                          cnt_par = length(vec_ret) / 2 + 1
  
                                  }
  
                                  cnt2 = cnt2 - 1
  
                             }
  
                     }
  
                     lst_par[pre_mtch[1] + (pre_paires2 - 1) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1))] <- paires 
  
                     lst_par[pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret)] <- paires 
  
                     if ((pre_mtch[1] + (pre_paires2 - 1)) == 1){
  
                          pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
  
                          vec_ret <- c()
  
                          cnt_par = 0
  
                     } else if (lst_par_calc[(pre_mtch[1] + (pre_paires2 - 1) - 1)] == -1 & ifelse(is.null(vec_ret), TRUE, 
                                  is.na(match(x=-1, table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])))){
  
                          pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
  
                          vec_ret <- c()
  
                          cnt_par = 0
  
                     } else{
  
                          vec_ret <- c(vec_ret, (pre_mtch[1]) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1)), 
                                       (pre_mtch[2] + length(vec_ret)))
  
                     }
  
                     paires = paires + 1
  
                     pre_paires = pre_paires + 1
  
                     pre_cls <- FALSE
  
                     lst_pos[par_] <- el
  
                     par_ = par_ + 1
  
             }
  
          }
  
          return(list(lst_par, lst_pos))
  
  }
  better_split_any <- function(inpt, split_v = c()){
    glue_groupr_v <- function(inpt_v, group_v = c(), untl){
      rtn_v <- c()
      cur_v <- c()
      grp_status <- FALSE
      cnt_untl = 0
      for (el in inpt_v) {
        if (el %in% group_v & cnt_untl < untl){
          grp_status <- TRUE
          cur_v <- c(cur_v, el)
          cnt_untl = cnt_untl + 1
        }else if (grp_status){
          grp_status <- FALSE
          rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
          cur_v <- c()
          if (el %in% group_v){
            cnt_untl = 1
            cur_v <- c(el)
            grp_status <- TRUE
          }else{
            cnt_untl = 0
            rtn_v <- c(rtn_v, el)
          }
        }else{
          rtn_v <- c(rtn_v, el)
        }
      }
      if (length(cur_v) > 0){
        rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
      }
      return(rtn_v)
    }
    regex_spe_detect <- function(inpt){
          fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
            ptrn <- grep(ptrn_fill, inpt_v)
            while (length(ptrn) > 0){
              ptrn <- grep(ptrn_fill, inpt_v)
              idx <- ptrn[1] 
              untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
              pre_val <- inpt_v[(idx - 1)]
              inpt_v[idx] <- pre_val
              if (untl > 0){
                for (i in 1:untl){
                  inpt_v <- append(inpt_v, pre_val, idx)
                }
              }
            ptrn <- grep(ptrn_fill, inpt_v)
            }
            return(inpt_v)
          }
          inpt <- unlist(strsplit(x=inpt, split=""))
          may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
          pre_idx <- unique(match(x=inpt, table=may_be_v))
          pre_idx <- pre_idx[!(is.na(pre_idx))]
          for (el in may_be_v[pre_idx]){
                  cnt = 0
                  for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                          inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                          cnt = cnt + 1
                  }
          }
            return(paste(inpt, collapse=""))
    }
    for (split in split_v){
      pre_inpt <- inpt
      inpt <- c()
      lst_splt <- FALSE
      for (el in pre_inpt){
        cur_splt <- unlist(strsplit(x = el, split = regex_spe_detect(split)))
        cur_splt[cur_splt == ""] <- split
        cnt = 1
        while (cnt < length(cur_splt)){
          if (cur_splt[cnt] %in% split_v){
            if (lst_splt & cur_splt[cnt] != split){
              cur_splt <- append(x = cur_splt, values = split, after = cnt)
              cnt = cnt + 2 
            }
            lst_splt <- TRUE
            cnt = cnt + 1
          }else{
            cur_splt <- append(x = cur_splt, values = split, after = cnt)
            lst_splt <- FALSE
            cnt = cnt + 2
          }
        }
        cur_grp <- c()
        split_decomp <- unlist(strsplit(x = split, split = ""))
        for (el2 in split_decomp){ cur_grp <- c(cur_grp, el2) }
        last_verif <- glue_groupr_v(unlist(strsplit(x = el, split = "")), group_v = cur_grp, untl = nchar(split))
        if (sum(grepl(x = last_verif, pattern = regex_spe_detect(split))) == (sum(grepl(x = cur_splt, pattern = regex_spe_detect(split))) + 1)){
          cur_splt <- c(cur_splt, split)
        }
        inpt <- c(inpt, cur_splt)
      }
    }
    return(inpt)
  }
  untl <- c(matrix(nrow = (length(to_find_v) + 1), ncol = 1, data = 1))
  to_find_v <- c(to_find_v, to_find_v[length(to_find_v)])
  pairs_idx <- pairs_findr(inpt = inpt, ptrn1 = "(", ptrn2 = ")")
  pairs_pairs <- unlist(pairs_idx[1])
  inpt <- better_split_any(inpt = inpt, split = c("(", ")", ":"))
  pairs_idx <- dynamic_idx_convertr(from_v_ids = unlist(pairs_idx[2]), from_v_val = inpt)
  #inpt <- better_split_any(inpt = inpt, split = c("(", ")", ":"))
  i = 1
  cur_inpt <- inpt
  stay_inpt <- inpt
  cur_id_v <- c()
  lngth_track = 0
  lngth_track_v <- c(0)
  while (TRUE){
    if (cur_inpt[1] == to_find_v[i] & cur_inpt[2] == "("){
      cur_inpt[1] <- "?"  
    }
    cur_id <- grep(x = cur_inpt, pattern = paste0("^", to_find_v[i], "$"))
    if (length(cur_id) > 0){
      ok_status <- TRUE
      cur_id <- cur_id[untl[i]]
    }else{
      ok_status <- FALSE
    }
    if (ok_status & i <= length(to_find_v)){
      cur_mtch <- match(table = cur_inpt, x = ":")
      if(!(is.na(cur_mtch)) & i == length(to_find_v)){
        rtn_val <- cur_inpt[(cur_mtch + 1)]
        if (rtn_val == ")"){
          return("Value not found")
        }else{
          return(cur_inpt[(cur_mtch + 1)])
        }
      }
      cur_id_v <- c(cur_id_v, cur_id)
      cur_inpt <- inpt[(cur_id + lngth_track):(pairs_idx[grep(pattern = pairs_pairs[match(x = (cur_id + lngth_track_v[length(lngth_track_v)] - 1), table  = pairs_idx)], x = pairs_pairs)[2]] - 1)] 
      i = i + 1
      lngth_track = lngth_track + cur_id - 1
      lngth_track_v <- c(lngth_track_v, lngth_track)
    }else if (i > 1 & length(cur_id) == 0){
      if (i > 1){
        i = i - 1
        untl[i] = untl[i] + 1
      }
      lngth_track_v <- lngth_track_v[1:(length(lngth_track_v) - 1)]
      if (length(lngth_track_v) > 1){
        lngth_track <- lngth_track_v[length(lngth_track_v)]
      }else{
        lngth_track <- 1
      }
      if (length(cur_id_v) > 1){ 
        cur_id_v <- cur_id_v[1:(length(cur_id_v) - 1)] 
        cur_grep <- grep(pattern = pairs_pairs[match(x = (lngth_track), table  = pairs_idx)], x = pairs_pairs)
        cur_inpt <- inpt[(pairs_idx[cur_grep[1]] + 1):(pairs_idx[cur_grep[2]] - 1)] 
      }else{
        cur_inpt <- stay_inpt
      }
      lngth_track <- 0
    }else{
      return("Value not found")
    }
  }
}

#' write_edm_parser
#'
#' Allow to write data to edm parsed dataset, see examples
#'
#' @param inpt is the input dataset
#' @param to_write_v is the vector containing the path to write the data, see examples
#'
#' @examples
#'
#' print(write_edm_parser("(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))", 
#' to_write_v = c("ok", "ee"), write_data = c("ii", "olm")))
#'
#' [1] "(ok(ee:56)(ii:olm))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))"
#'
#' print(write_edm_parser("(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))", 
#' to_write_v = c("ok", "oui"), write_data = c("ii", "olm")))
#'
#' [1] "(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(ii:olm)(oui(bb(rr2:1)))(ee1:4))"
#' 
#' print(write_edm_parser("(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ee1:4))", 
#' to_write_v = c("ok", "oui", "oui"), write_data = c("ii", "olm")))
#'
#' [1] "(ok(ee:56))(ok(oui(rr((rr2:6)(rr:5))))(oui(bb(rr2:1)))(ii:olm)(ee1:4))"
#'
#' print(write_edm_parser("", 
#' to_write_v = c(), write_data = c("ii", "olm")))
#'
#' [1] "(ii:olm)"
#'
#' @export

write_edm_parser <- function(inpt, to_write_v, write_data){
  if (inpt == ""){ return(paste(c("(", write_data[1], ":", write_data[2], ")"), collapse = "")) }
  dynamic_idx_convertr <- function(from_v_ids, from_v_val){
    lngth <- length(from_v_ids)
    i = 1
    no_stop <- TRUE
    I = 1
    lst_nchar = 0
    while (I <= length(from_v_val) & no_stop){
      while ((nchar(from_v_val[I]) + lst_nchar) >= from_v_ids[i] & no_stop){
        from_v_ids[i] <- I
        if (i == length(from_v_ids)){ no_stop <- FALSE }else{ i = i + 1 }
      }
      lst_nchar = lst_nchar + nchar(from_v_val[I])
      I = I + 1
    }
    return(from_v_ids)
  }
  pairs_findr <- function(inpt, ptrn1="(", ptrn2=")"){
          
        regex_spe_detect <- function(inpt){
                fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
                  ptrn <- grep(ptrn_fill, inpt_v)
                  while (length(ptrn) > 0){
                    ptrn <- grep(ptrn_fill, inpt_v)
                    idx <- ptrn[1] 
                    untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
                    pre_val <- inpt_v[(idx - 1)]
                    inpt_v[idx] <- pre_val
                    if (untl > 0){
                      for (i in 1:untl){
                        inpt_v <- append(inpt_v, pre_val, idx)
                      }
                    }
                  ptrn <- grep(ptrn_fill, inpt_v)
                  }
                  return(inpt_v)
                }
                inpt <- unlist(strsplit(x=inpt, split=""))
                may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
                pre_idx <- unique(match(x=inpt, table=may_be_v))
                pre_idx <- pre_idx[!(is.na(pre_idx))]
                for (el in may_be_v[pre_idx]){
                        cnt = 0
                        for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                                inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                                cnt = cnt + 1
                        }
                }
                  return(paste(inpt, collapse=""))
          }
  
          lst <- unlist(strsplit(x=inpt, split=""))
  
          lst_par <- c()
  
          lst_par_calc <- c()
  
          lst_pos <- c()
  
          paires = 1
  
          pre_paires = 1
  
          pre_paires2 = 1
  
          if ((length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2) > 0){
  
                  for (i in 1:(length(grep(x=lst, pattern=regex_spe_detect(inpt=ptrn1))) * 2)){ 
  
                          lst_par <- c(lst_par, 0)
  
                          lst_par_calc <- c(lst_par_calc, 0)
  
                          lst_pos <- c(lst_pos, 0)
  
  
                  }
  
          }
  
          vec_ret <- c()
  
          par_ = 1
  
          lvl_par = 0
  
          for (el in 1:length(lst)){
  
             if (lst[el] == ptrn1){
  
                     if (!(is.null(vec_ret))){
  
                             lst_par_calc[pre_paires2:pre_paires][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] + 1
  
                     }else{
  
                             lst_par_calc[pre_paires2:pre_paires] <- lst_par_calc[pre_paires2:pre_paires] + 1
  
                     }
  
                     pre_paires = pre_paires + 1
  
                     pre_cls <- TRUE
  
                     lst_pos[par_] <- el
  
                     par_ = par_ + 1
  
                     lvl_par = lvl_par + 1
  
             }
  
             if (lst[el] == ptrn2){
  
                     lvl_par = lvl_par - 1
  
                     if (!(is.null(vec_ret))){
  
                          lst_par_calc[c(pre_paires2:pre_paires)][-vec_ret] <- lst_par_calc[pre_paires2:pre_paires][-vec_ret] - 1
  
                          pre_val <- lst_par_calc[pre_paires2:pre_paires][vec_ret]
  
                          lst_par_calc[pre_paires2:pre_paires][vec_ret] <- (-2)
                     
                     }else{
  
                          lst_par_calc[c(pre_paires2:pre_paires)] <- lst_par_calc[pre_paires2:pre_paires] - 1
  
                     }
  
                     if (!(is.null(vec_ret))){ 
  
                             pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])
  
                             lst_par_calc[pre_paires2:pre_paires][vec_ret] <- pre_val 
  
                     }else{
  
                             pre_mtch <- match(x=c(0, -1), table=lst_par_calc[pre_paires2:pre_paires])
  
                     }
  
                     cnt_par = 1
  
                     cnt2 = 0
  
                     if (!(is.null(vec_ret))){
  
                             vec_ret <- sort(vec_ret)
  
                             if (pre_mtch[1] >= min(vec_ret)){
  
                                  cnt2 = 2
  
                                  while (pre_mtch[1] > cnt_par & cnt2 <= length(vec_ret)){
  
                                          if ((vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) > 1){
  
                                                  cnt_par = cnt_par + (vec_ret[cnt2] - vec_ret[(cnt2 - 1)]) - 1
  
                                          }
  
                                          cnt2 = cnt2 + 1
  
                                  }
  
                                  if (pre_mtch[1] > cnt_par){
  
                                          cnt_par = length(vec_ret) / 2 + 1
  
                                  }
  
                                  cnt2 = cnt2 - 1
  
                             }
  
                     }
  
                     lst_par[pre_mtch[1] + (pre_paires2 - 1) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1))] <- paires 
  
                     lst_par[pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret)] <- paires 
  
                     if ((pre_mtch[1] + (pre_paires2 - 1)) == 1){
  
                          pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
  
                          vec_ret <- c()
  
                          cnt_par = 0
  
                     } else if (lst_par_calc[(pre_mtch[1] + (pre_paires2 - 1) - 1)] == -1 & ifelse(is.null(vec_ret), TRUE, 
                                  is.na(match(x=-1, table=lst_par_calc[pre_paires2:pre_paires][-vec_ret])))){
  
                          pre_paires2 = pre_mtch[2] + (pre_paires2 - 1) + length(vec_ret) + 1
  
                          vec_ret <- c()
  
                          cnt_par = 0
  
                     } else{
  
                          vec_ret <- c(vec_ret, (pre_mtch[1]) + ifelse(cnt2 %% 2 == 0, cnt2, (cnt2 - 1)), 
                                       (pre_mtch[2] + length(vec_ret)))
  
                     }
  
                     paires = paires + 1
  
                     pre_paires = pre_paires + 1
  
                     pre_cls <- FALSE
  
                     lst_pos[par_] <- el
  
                     par_ = par_ + 1
  
             }
  
          }
  
          return(list(lst_par, lst_pos))
  
  }
  better_split_any <- function(inpt, split_v = c()){
    glue_groupr_v <- function(inpt_v, group_v = c(), untl){
      rtn_v <- c()
      cur_v <- c()
      grp_status <- FALSE
      cnt_untl = 0
      for (el in inpt_v) {
        if (el %in% group_v & cnt_untl < untl){
          grp_status <- TRUE
          cur_v <- c(cur_v, el)
          cnt_untl = cnt_untl + 1
        }else if (grp_status){
          grp_status <- FALSE
          rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
          cur_v <- c()
          if (el %in% group_v){
            cnt_untl = 1
            cur_v <- c(el)
            grp_status <- TRUE
          }else{
            cnt_untl = 0
            rtn_v <- c(rtn_v, el)
          }
        }else{
          rtn_v <- c(rtn_v, el)
        }
      }
      if (length(cur_v) > 0){
        rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
      }
      return(rtn_v)
    }
    regex_spe_detect <- function(inpt){
          fillr <- function(inpt_v, ptrn_fill="\\.\\.\\.\\d"){
            ptrn <- grep(ptrn_fill, inpt_v)
            while (length(ptrn) > 0){
              ptrn <- grep(ptrn_fill, inpt_v)
              idx <- ptrn[1] 
              untl <- as.numeric(c(unlist(strsplit(inpt_v[idx], split="\\.")))[4]) - 1
              pre_val <- inpt_v[(idx - 1)]
              inpt_v[idx] <- pre_val
              if (untl > 0){
                for (i in 1:untl){
                  inpt_v <- append(inpt_v, pre_val, idx)
                }
              }
            ptrn <- grep(ptrn_fill, inpt_v)
            }
            return(inpt_v)
          }
          inpt <- unlist(strsplit(x=inpt, split=""))
          may_be_v <- c("[", "]", "{", "}", "-", "_", ".", "(", ")", "/", "%", "*", "^", "?", "$")
          pre_idx <- unique(match(x=inpt, table=may_be_v))
          pre_idx <- pre_idx[!(is.na(pre_idx))]
          for (el in may_be_v[pre_idx]){
                  cnt = 0
                  for (i in grep(pattern=paste("\\", el, sep=""), x=inpt)){
                          inpt <- append(x=inpt, values="\\", after=(i - 1 + cnt))
                          cnt = cnt + 1
                  }
          }
            return(paste(inpt, collapse=""))
    }
    for (split in split_v){
      pre_inpt <- inpt
      inpt <- c()
      lst_splt <- FALSE
      for (el in pre_inpt){
        cur_splt <- unlist(strsplit(x = el, split = regex_spe_detect(split)))
        cur_splt[cur_splt == ""] <- split
        cnt = 1
        while (cnt < length(cur_splt)){
          if (cur_splt[cnt] %in% split_v){
            if (lst_splt & cur_splt[cnt] != split){
              cur_splt <- append(x = cur_splt, values = split, after = cnt)
              cnt = cnt + 2 
            }
            lst_splt <- TRUE
            cnt = cnt + 1
          }else{
            cur_splt <- append(x = cur_splt, values = split, after = cnt)
            lst_splt <- FALSE
            cnt = cnt + 2
          }
        }
        cur_grp <- c()
        split_decomp <- unlist(strsplit(x = split, split = ""))
        for (el2 in split_decomp){ cur_grp <- c(cur_grp, el2) }
        last_verif <- glue_groupr_v(unlist(strsplit(x = el, split = "")), group_v = cur_grp, untl = nchar(split))
        if (sum(grepl(x = last_verif, pattern = regex_spe_detect(split))) == (sum(grepl(x = cur_splt, pattern = regex_spe_detect(split))) + 1)){
          cur_splt <- c(cur_splt, split)
        }
        inpt <- c(inpt, cur_splt)
      }
    }
    return(inpt)
  }
  untl <- c(matrix(nrow = length(to_write_v), ncol = 1, data = 1))
  pairs_idx <- pairs_findr(inpt = inpt, ptrn1 = "(", ptrn2 = ")")
  pairs_pairs <- unlist(pairs_idx[1])
  inpt <- better_split_any(inpt = inpt, split = c("(", ")", ":"))
  pairs_idx <- dynamic_idx_convertr(from_v_ids = unlist(pairs_idx[2]), from_v_val = inpt)
  i = 1
  cur_inpt <- inpt
  stay_inpt <- inpt
  cur_id_v <- c()
  lngth_track = 0
  lngth_track_v <- c(0)
  while (i <= length(to_write_v)){
    if (cur_inpt[1] == to_write_v[i] & cur_inpt[2] == "("){
      cur_inpt[1] <- "?"  
    }
    cur_id <- grep(x = cur_inpt, pattern = paste0("^", to_write_v[i], "$"))
    if (length(cur_id) > 0){
      ok_status <- TRUE
      cur_id <- cur_id[untl[i]]
    }else{
      ok_status <- FALSE
    }
    if (ok_status & i <= length(to_write_v)){
      cur_id_v <- c(cur_id_v, cur_id)
      cur_inpt <- inpt[(cur_id + lngth_track):(pairs_idx[grep(pattern = pairs_pairs[match(x = (cur_id + lngth_track_v[length(lngth_track_v)] - 1), table  = pairs_idx)], x = pairs_pairs)[2]] - 1)] 
      i = i + 1
      lngth_track = lngth_track + cur_id - 1
      lngth_track_v <- c(lngth_track_v, lngth_track)
    }else if (i > 1 & length(cur_id) == 0){
      if (i > 1){
        i = i - 1
        untl[i] = untl[i] + 1
      }
      lngth_track_v <- lngth_track_v[1:(length(lngth_track_v) - 1)]
      if (length(lngth_track_v) > 1){
        lngth_track <- lngth_track_v[length(lngth_track_v)]
      }else{
        lngth_track <- 1
      }
      if (length(cur_id_v) > 1){ 
        cur_id_v <- cur_id_v[1:(length(cur_id_v) - 1)] 
        cur_grep <- grep(pattern = pairs_pairs[match(x = (lngth_track), table  = pairs_idx)], x = pairs_pairs)
        cur_inpt <- inpt[(pairs_idx[cur_grep[1]] + 1):(pairs_idx[cur_grep[2]] - 1)] 
      }else{
        cur_inpt <- stay_inpt
      }
      lngth_track <- 0
    }else{
      return("Value not found")
    }
  }
  inpt <- append(x = inpt, values = paste0(c("(", write_data[1], ":", write_data[2], ")"), collapse = ""), after = pairs_idx[grep(pattern = pairs_pairs[match(x = lngth_track_v[length(lngth_track_v)], table = pairs_idx)], x = pairs_pairs)[2]])
  return(paste(inpt, collapse = ""))
}

#' just_chr
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_chr(inpt_v = c("oui222jj644", "oui122jj"), 
#'     symbol_ = "-"))
#'
#' [1] "oui-jj-" "oui-jj" 
#'
#' @export

just_chr <- function(inpt_v, symbol_ = "-"){
  rtn_v <- c()
  nb_v <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  for (el1 in inpt_v){
    cur_v <- c()
    alrd <- FALSE
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (!(el2 %in% nb_v)){
        cur_v <- c(cur_v, el2)
        alrd <- FALSE
      }else if (!(alrd)){
        cur_v <- c(cur_v, symbol_) 
        alrd <- TRUE
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_chr3
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#'
#' @examples
#'
#' print(just_chr3(inpt_v = c("oui222jj644", "oui122jj")))
#' 
#' [1] "ouijj" "ouijj"
#'
#' @export

just_chr3 <- function(inpt_v){
  rtn_v <- c()
  nb_v <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (!(el2 %in% nb_v)){
        cur_v <- c(cur_v, el2)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_chr2
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_chr2(inpt_v = c("oui222jj44", "oui122jj"), 
#'    symbol_ = "-"))
#'
#' [1] "oui---jj--" "oui---jj"  
#'
#' @export

just_chr2 <- function(inpt_v, symbol_ = "-"){
  rtn_v <- c()
  nb_v <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (!(el2 %in% nb_v)){
        cur_v <- c(cur_v, el2)
      }else{
        cur_v <- c(cur_v, symbol_)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_nb
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_nb(inpt_v = c("oui222jj644", "oui122jj"), 
#'     symbol_ = "-"))
#'
#' [1] "-222-44" "-122-"  
#'
#' @export

just_nb <- function(inpt_v, symbol_ = "-"){
  rtn_v <- c()
  nb_v <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  for (el1 in inpt_v){
    cur_v <- c()
    alrd <- FALSE
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (el2 %in% nb_v){
        cur_v <- c(cur_v, el2)
        alrd <- FALSE
      }else if (!(alrd)){
        cur_v <- c(cur_v, symbol_) 
        alrd <- TRUE
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_letters")
    }
  }
  return(rtn_v)
}

#' just_nb3
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#'
#' @examples
#'
#' print(just_nb3(inpt_v = c("oui222jj644", "oui122jj")))
#'
#' [1] 222644 122
#'
#' @export

just_nb3 <- function(inpt_v){
  rtn_v <- c()
  nb_v <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (el2 %in% nb_v){
        cur_v <- c(cur_v, el2)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, as.numeric(paste(cur_v, collapse = "")))
    }else{
      rtn_v <- c(rtn_v, "full_of_letters")
    }
  }
  return(rtn_v)
}

#' just_nb2
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_nb2(inpt_v = c("oui222jj44", "oui122jj"), 
#'    symbol_ = "-"))
#'
#' [1] "---222--44" "---122--"  
#'
#' @export

just_nb2 <- function(inpt_v, symbol_ = "-"){
  rtn_v <- c()
  nb_v <- c("0", "1", "2", "3", "4", "5", "6", "7", "8", "9")
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (el2 %in% ltrs_v){
        cur_v <- c(cur_v, el2)
      }else{
        cur_v <- c(cur_v, symbol_)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_letters")
    }
  }
  return(rtn_v)
}

#' col_to_row
#'
#' Allow to reverse a dataframe (cols become rows and rows become cols)
#'
#' @param inpt_datf is the inout dataframe
#'
#' @examples 
#'
#' datf_test <- data.frame(c(1:11), c(11:1))
#' 
#' print(col_to_row(inpt_datf = datf_test))
#'
#'   X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11
#' 1  1  2  3  4  5  6  7  8  9  10  11
#' 2 11 10  9  8  7  6  5  4  3   2   1
#'
#' @export

col_to_row <- function(inpt_datf){
  rtn_datf <- data.frame(matrix(data = NA, nrow = ncol(inpt_datf), ncol = nrow(inpt_datf)))
  for (i in 1:ncol(inpt_datf)){
    rtn_datf[i, ] <- inpt_datf[, i]
    rownames(rtn_datf)[i] <- colnames(rtn_datf)[i]
  }
  return(rtn_datf)
}

#' row_to_col
#'
#' Allow to reverse a dataframe (rows become cols and cols become rows)
#'
#' @param inpt_datf is the inout dataframe
#'
#' @examples 
#'
#' datf_test <- data.frame(c(1, 11), c(2, 10), c(3, 9), c(4, 8))
#' 
#' print(datf_test)
#' 
#'   c.1..11. c.2..10. c.3..9. c.4..8.
#' 1        1        2       3       4
#' 2       11       10       9       8
#'
#' print(row_to_col(inpt_datf = datf_test))
#'
#'   1  2
#' 1 1 11
#' 2 2 10
#' 3 3  9
#' 4 4  8
#'
#' @export

row_to_col <- function(inpt_datf){
  rtn_datf <- data.frame(matrix(data = NA, nrow = ncol(inpt_datf), ncol = 1))
  for (I in 1:nrow(inpt_datf)){
    for (i in 1:ncol(inpt_datf)){
      rtn_datf[i, I] <- inpt_datf[I, i]
    }
    colnames(rtn_datf)[I] <- rownames(rtn_datf)[I]
  }
  return(rtn_datf)
}

#' just_anything
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_anything(inpt_v = c("oui222jj644", "oui122jj"), 
#' symbol_ = "-", anything_v = letters))
#'
#' [1] "oui-jj-" "oui-jj" 
#'
#' @export

just_anything <- function(inpt_v, symbol_ = "-", anything_v = c()){
  rtn_v <- c()
  for (el1 in inpt_v){
    cur_v <- c()
    alrd <- FALSE
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (el2 %in% anything_v){
        cur_v <- c(cur_v, el2)
        alrd <- FALSE
      }else if (!(alrd)){
        cur_v <- c(cur_v, symbol_) 
        alrd <- TRUE
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}


#' just_anything2
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_anything2(inpt_v = c("oui222jj44", "oui122jj"), 
#'   symbol_ = "-", anything_v = letters))
#'
#' [1] "oui---jj--" "oui---jj"  
#'
#' @export

just_anything2 <- function(inpt_v, symbol_ = "-", anything_v = c()){
  rtn_v <- c()
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (el2 %in% anything_v){
        cur_v <- c(cur_v, el2)
      }else{
        cur_v <- c(cur_v, symbol_)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_anything3
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#'
#' @examples
#'
#' print(just_anything3(inpt_v = c("oui222jj644", "oui122jj"), 
#'  anything_v = letters))
#' 
#' [1] "ouijj" "ouijj"
#'
#' @export

just_anything3 <- function(inpt_v, anything_v = c()){
  rtn_v <- c()
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (el2 %in% anything_v){
        cur_v <- c(cur_v, el2)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_not_anything
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_not_anything(inpt_v = c("oui222jj644", "oui122jj"), 
#'      symbol_ = "-", anything_v = letters))
#'
#' [1] "-222-644" "-122-" 
#'
#' @export

just_not_anything <- function(inpt_v, symbol_ = "-", anything_v = c()){
  rtn_v <- c()
  for (el1 in inpt_v){
    cur_v <- c()
    alrd <- FALSE
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (!(el2 %in% anything_v)){
        cur_v <- c(cur_v, el2)
        alrd <- FALSE
      }else if (!(alrd)){
        cur_v <- c(cur_v, symbol_) 
        alrd <- TRUE
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_not_anything2
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#' @param symbol_ is the chosen symbol to replace numbers
#'
#' @examples
#'
#' print(just_not_anything2(inpt_v = c("oui222jj44", "oui122jj"), 
#'     symbol_ = "-", anything_v = letters))
#'
#' [1] "---222-44" "---122--"  
#'
#' @export

just_not_anything2 <- function(inpt_v, symbol_ = "-", anything_v = c()){
  rtn_v <- c()
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (!(el2 %in% anything_v)){
        cur_v <- c(cur_v, el2)
      }else{
        cur_v <- c(cur_v, symbol_)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

#' just_not_anything3
#'
#' Extract only the letters from all elements of a vector, see examples
#'
#' @param inpt_v is the input vector
#'
#' @examples
#'
#' print(just_not_anything3(inpt_v = c("oui222jj644", "oui122jj"), 
#'    anything_v = letters))
#' 
#' [1] "222644" "122"
#'
#' @export

just_not_anything3 <- function(inpt_v, anything_v = c()){
  rtn_v <- c()
  for (el1 in inpt_v){
    cur_v <- c()
    for (el2 in unlist(strsplit(x = el1, split = ""))){
      if (!(el2 %in% anything_v)){
        cur_v <- c(cur_v, el2)
      }
    }
    if (length(cur_v) > 0){
      rtn_v <- c(rtn_v, paste(cur_v, collapse = ""))
    }else{
      rtn_v <- c(rtn_v, "full_of_numbers")
    }
  }
  return(rtn_v)
}

library("stringr")

#' see_in_l
#'
#' Allow to get the patterns that are present in the elements of a vector, see examples
#'
#' @param from_v is the vector that may contains elements that contains the same patterns that those in in_v, see examples
#' @param in_v is a vector that contains the patterns to find
#'
#' @examples
#'
#' print(see_in_l(from_v = c("oui", "non", "peut"), 
#'   in_v = c("ou", "pe", "plm")))
#' 
#'    ou    pe   plm 
#'   TRUE  TRUE FALSE  
#'
#' @export

see_in_l <- function(from_v = c(), in_v = c()){
  rtn_v <- c()
  rtn_v <- mapply(
          function(x){
            rtn_v <- c(rtn_v, any(str_detect(pattern = x, 
                                  string = from_v)))
          },
    in_v
  )
  return(rtn_v)
}

#' see_in_grep
#' 
#' Allow to get the indices of the elements of a vector that contains certyain patterns.
#' The type of the output may change in function of the input vectors, see examples
#'
#' @param from_v is the vector that may contains elements that contains the same patterns that those in in_v, see examples
#' @param in_v is a vector that contains the patterns to find
#'
#' @examples
#'
#' print(see_in_grep(from_v = c("oui", "non", "peut"), 
#'                   in_v = c("ou", "eu", "plm")))
#' 
#'            ou            eu           plm 
#'            1             3            -1 
#'
#'  print(see_in_grep(from_v = c("oui", "non", "peut", "oui"), 
#'       in_v = c("ou", "eu", "plm")))
#' 
#' $ou
#' [1] 1 4
#' 
#' $eu
#' [1] 3
#' 
#' $plm
#' [1] -1
#'
#' @export

see_in_grep <- function(from_v = c(), in_v = c()){
  rtn_v <- c()
  rtn_v <- mapply(
          function(x){
            pre_val <- str_detect(pattern = x, 
                                  string = from_v) 
            if (any(pre_val)){
              rtn_v <- c(rtn_v, grep(pattern = TRUE, x = pre_val))
            }else{
              rtn_v <- c(rtn_v, -1)
            }
          },
    in_v
  )
  return(rtn_v)
}

#' datf_appendr
#' 
#' Allow to append all columns of a dataframe in a vector.
#'
#' @param inpt_datf is the input dataframe
#'
#' @examples
#'
#' datf_teste <- data.frame("col1" = c(1:5), "col2" = c(5:1))
#' 
#' print(datf_appendr(inpt_datf = datf_teste))
#' 
#' [1] 1 2 3 4 5 5 4 3 2 1
#'
#' @export

datf_appendr <- function(inpt_datf){
  rtn_v <- c()
  for (col in inpt_datf){
    rtn_v <- c(rtn_v, col)
  }
  return(rtn_v)
}

#' datf_appendr2
#'
#' Allow to append all columns of a dataframe in a vector, 
#' specifying the column types ("integer" or "character"), see examples
#'
#' @param inpt_datf is the inout dataframe
#'
#' @examples
#'
#' datf_teste <- data.frame("col1" = c(1:5), "col2" = c(5:1), 
#'   "col3" = c("oui", "oui", "oui", "non", "non"))
#' 
#' print(datf_appendr2(inpt_datf = datf_teste, chs_type = "integer"))
#'
#' [1] 1 2 3 4 5 5 4 3 2 1
#'
#' print(datf_appendr2(inpt_datf = datf_teste, chs_type = "character"))
#'
#' [1] "oui" "oui" "oui" "non" "non"
#' 
#' @export

datf_appendr2 <- function(inpt_datf, chs_type = "integer"){
  rtn_v <- c()
  for (col in inpt_datf){
    if (typeof(col) == chs_type){
      rtn_v <- c(rtn_v, col)
    }
  }
  return(rtn_v)
}

#' datf_row_appendr
#' 
#' Allow to append all rows of a dataframe in a vector.
#'
#' @param inpt_datf is the input dataframe
#'
#' @examples
#'
#' datf_teste <- data.frame("col1" = c(1:5), "col2" = c(5:1))
#' 
#' print(datf_appendr(inpt_datf = datf_teste))
#' 
#' col1 col2 col1 col2 col1 col2 col1 col2 col1 col2 
#'    1    5    2    4    3    3    4    2    5    1 
#'
#' @export

datf_row_appendr <- function(inpt_datf){
  rtn_v <- c()
  for (i in 1:nrow(inpt_datf)){
    rtn_v <- c(rtn_v, unlist(inpt_datf[i, ]))
  }
  return(rtn_v)
}

#' datf_row_appendr2
#'
#' Allow to append all rows of a dataframe in a vector, 
#' specifying the column types ("integer" or "character"), see examples
#'
#' @param inpt_datf is the inout dataframe
#'
#' @examples
#'
#' datf_teste <- data.frame("col1" = c(1:5), "col2" = c(5:1), 
#'   "col3" = c("oui", "oui", "oui", "non", "non"))
#' 
#' print(datf_row_appendr2(inpt_datf = datf_teste, chs_type = "integer"))
#'
#' NULL
#'
#' print(datf_row_appendr2(inpt_datf = datf_teste, chs_type = "character"))
#'
#'  col1  col2  col3  col1  col2  col3  col1  col2  col3  col1  col2  col3  col1 
#'   "1"   "5" "oui"   "2"   "4" "oui"   "3"   "3" "oui"   "4"   "2" "non"   "5" 
#'  col2  col3 
#'   "1" "non" 
#'
#' @export

datf_row_appendr2 <- function(inpt_datf, chs_type = "integer"){
  rtn_v <- c()
  for (i in 1:nrow(inpt_datf)){
    if (typeof(unlist(inpt_datf[i, ])) == chs_type){
      rtn_v <- c(rtn_v, unlist(inpt_datf[i, ]))
    }
  }
  return(rtn_v)
}

#' arroundr_min
#'
#' Takes an ascendly int ordered vector as input and assigns each elements that are close enough to the same value accrdng to a step value (step_value), see examples.
#'
#' @param inpt_v is the input vector
#' @param step_val is the step value
#'
#' @examples 
#'
#' print(arroundr_min(inpt_v = c(-11:25), step_val = 5))
#'
#'  [1] -11 -11 -11 -11 -11 -11  -6  -6  -6  -6  -6  -1  -1  -1  -1  -1   4   4   4
#' [20]   4   4   9   9   9   9   9  14  14  14  14  14  19  19  19  19  19  24
#'
#' @export

arroundr_min <- function(inpt_v = c(), step_val){
  cur_step = inpt_v[1] 
  for (i in 2:length(inpt_v)){
    if (abs(inpt_v[i] - inpt_v[(i - 1)]) > step_val){
      cur_step = cur_step + step_val
    }
    inpt_v[i] <- cur_step
  }
  
  return(inpt_v)
}

#' arroundr_mean
#'
#' Takes an ascendly int ordered vector as input and assigns each elements that are close enough to the same value accrdng to a step value (step_value), see examples.
#'
#' @param inpt_v is the input vector
#' @param step_val is the step_value
#'
#' @examples 
#'
#' x <- arroundr_mean(inpt_v = c(-11:25), step_val = 5)
#' print(x)
#' print(length(x))
#'
#' [1] -9.0 -9.0 -9.0 -9.0 -9.0 -4.0 -4.0 -4.0 -4.0 -4.0  1.0  1.0  1.0  1.0  1.0
#' [16]  6.0  6.0  6.0  6.0  6.0 11.0 11.0 11.0 11.0 11.0 16.0 16.0 16.0 16.0 16.0
#' [31] 21.0 21.0 21.0 21.0 21.0 23.8 23.8
#' [1] 37
#'

#' @export

arroundr_mean <- function(inpt_v = c(), step_val){
  cur_step = inpt_v[1] 
  rtn_v <- c()
  cnt = 0
  inpt_v2 <- inpt_v
  sty_val = 1
  for (i in 2:length(inpt_v)){
    if (abs(inpt_v[i] - inpt_v[(i - 1)]) > step_val){
      rtn_v <- c(rtn_v, rep(x = (sum(inpt_v2[sty_val:(sty_val + cnt - 1)]) / cnt), times = cnt))
      sty_val = sty_val + cnt
      cur_step = cur_step + step_val
      cnt = 0
    }
    inpt_v[i] <- cur_step
    cnt = cnt + 1
  }
  if (length(rtn_v) < length(inpt_v)){
    cur_diff <- (length(inpt_v) - length(rtn_v))
    cur_val <- sum(inpt_v[length(inpt_v):(length(inpt_v) - step_val)]) / step_val
    rtn_v <- c(rtn_v, rep(x = cur_val, times = cur_diff))
  }
  return(rtn_v) 
}

#' bind_rows
#'
#' Allow to find the rows of a dataframe in an other dataframe, see examples
#'
#' @param from_datf is the dataframe that contains the rows to find among other rows
#' @param in_datf is the dataframe that only contans the rows to find in from_datf
#'
#' @examples
#'
#' iris[, 5] <- as.character(iris[, 5])
#' from_datf <- iris
#' in_datf <- iris[c(4, 2, 23, 21, 11), ]
#' 
#' bind_rows(from_datf = from_datf,
#'           in_datf = in_datf)
#' 
#' [[1]]
#' [1] 4
#' 
#' [[2]]
#' [1] 2
#' 
#' [[3]]
#' [1] 23
#' 
#' [[4]]
#' [1] 21
#' 
#' [[5]]
#' [1] 11
#'
#' @export

bind_rows <- function(from_datf, in_datf){
  paste_datf <- function(inpt_datf, sep=""){
      if (ncol(as.data.frame(inpt_datf)) == 1){ 
          return(inpt_datf) 
      }else {
          rtn_datf <- inpt_datf[,1]
          for (i in 2:ncol(inpt_datf)){
              rtn_datf <- paste(rtn_datf, inpt_datf[,i], sep=sep)
          }
          return(rtn_datf)
      }
  }
  rtn_l <- list()
  from_datf <- paste_datf(from_datf) 
  for (I in 1:nrow(in_datf)){
    rtn_l <- append(x = rtn_l, 
                     values = list(grep(pattern = paste(in_datf[I, ], collapse = ""), x = from_datf)))
  }
  return(rtn_l)
}

#' bind_cols
#'
#' Allow to find the cols of a dataframe in an other dataframe, see examples
#'
#' @param from_datf is the dataframe that contains the cols to find among other cols
#' @param in_datf is the dataframe that only contans the cols to find in from_datf
#'
#' @examples
#'
#' iris[, 5] <- as.character(iris[, 5])
#' iris <- cbind(iris, iris[, 4])
#' from_datf <- iris
#' in_datf <- iris[, c(1, 2, 2, 2, 4)]
#' bind_cols(from_datf = from_datf,
#'           in_datf = in_datf)
#' 
#' [[1]]
#' [1] 1
#' 
#' [[2]]
#' [1] 2
#' 
#' [[3]]
#' [1] 2
#' 
#' [[4]]
#' [1] 2
#' 
#' [[5]]
#' [1] 4 6
#'
#' @export

bind_cols <- function(from_datf, in_datf){
  paste_datf2 <- function(inpt_datf, sep = ""){
    rtn_v <- c()
    for (i in 1:ncol(inpt_datf)){
        rtn_v <- c(rtn_v, paste(inpt_datf[, i], collapse = sep))
    }
    return(rtn_v)
  }
  rtn_l <- list()
  from_datf <- paste_datf2(from_datf) 
  for (I in 1:ncol(in_datf)){
    rtn_l <- append(x = rtn_l, 
                     values = list(grep(pattern = paste(in_datf[, I], collapse = ""), x = from_datf)))
  }
  return(rtn_l)
}

#' paste_datf2
#' 
#' Return a vector composed of pasted elements from the input dataframe at the same column.
#'
#' @param inpt_datf is the input dataframe
#' @param sep is the separator between pasted elements, defaults to ""
#' @examples
#' 
#' print(paste_datf2(inpt_datf=data.frame(c(1, 2, 1), c(33, 22, 55))))
#'
#' #[1] "121" "332255"
#'
#' @export

paste_datf2 <- function(inpt_datf, sep = ""){
  rtn_v <- c()
  for (i in 1:ncol(inpt_datf)){
      rtn_v <- c(rtn_v, paste(inpt_datf[, i], collapse = sep))
  }
  return(rtn_v)
}

#' datf_insertr
#'
#' Insert rows after certain indexes, see examples
#'
#' @param inpt_datf is the input dataframe
#' @param ids_vec is the ids where the rows has to be inserted after
#' @param val_l is a list containing all the rows (vector) to be inserted, linked to eevery index within ids_vec
#'
#' @examples
#'
#' datf <- data.frame(c(1:4), c(4:1))
#' print(datf)
#'
#'   c.1.4. c.4.1.
#' 1      1      4
#' 2      2      3
#' 3      3      2
#' 4      4      1
#'
#' print(datf_insertr(inpt_datf = datf, ids_vec = c(1, 3), val_l = list(c("non", "non"), c("oui", "oui"))))
#'
#'   c.1.4. c.4.1.
#' 1       1      4
#' 2     non    non
#' 21      2      3
#' 3       3      2
#' 5     oui    oui
#' 4       4      1
#'
#' print(datf_insertr(inpt_datf = datf, ids_vec = c(1, 3), val_l = list(c("non", "non"))))
#'
#'   c.1.4. c.4.1.
#' 1       1      4
#' 2     non    non
#' 21      2      3
#' 3       3      2
#' 5     non    non
#' 4       4      1
#'
#' @export

datf_insertr <- function(inpt_datf, ids_vec, val_l){
  if (length(ids_vec) > length(val_l)){
    cur_val <- unlist(val_l[length(val_l)])
    while (length(ids_vec) > length(val_l)){
      val_l <- append(x = val_l, values = list(cur_val)) 
    }
  }
  alrd = 0
  for (i in 1:length(ids_vec)){
    inpt_datf <- rbind(
                   inpt_datf[1:(ids_vec[i] + alrd), ], 
                   unlist(val_l[i]), 
                   inpt_datf[(ids_vec[i] + alrd + 1):nrow(inpt_datf), ]
                 )
    alrd = alrd + 1
  }
  return(inpt_datf)
}

#' historic_sequence1
#'
#' Allow to perform a pivot wider on a sequencial dataset (here the type is dataframe), each variable will be dupplicated in a column to show the value to this variable at n - 1 for each individual, see examples.
#'
#' @param inpt_datf is the input dataframe
#' @param bf_ is the number of previous value of the individual it will search for, see examples
#'
#' @examples
#'
#' set.seed(123)
#' var1 <- round(runif(n = 14, min = 100, max = 122))
#' set.seed(123)
#' var2 <- round(runif(n = 14, min = 14, max = 20))
#' 
#' datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
#'                             17, 17, 17),
#'                   "individual" = c("oui", "non", "peut1", "peut2",
#'                                    "oui", "peut1", "peut2"),
#'                   "var1" = var1,
#'                   "var2" = var2)
#' print(datf)
#'
#'    ids individual var1 var2
#' 1   20        oui  106   16
#' 2   20        non  117   19
#' 3   20      peut1  109   16
#' 4   20      peut2  119   19
#' 5   19        oui  121   20
#' 6   19      peut1  101   14
#' 7   19      peut2  112   17
#' 8   18        oui  120   19
#' 9   18        non  112   17
#' 10  18      peut1  110   17
#' 11  18      peut2  121   20
#' 12  17        oui  110   17
#' 13  17      peut1  115   18
#' 14  17      peut2  113   17
#'
#' historic_sequence1(inpt_datf = datf, bf_ = 2)
#'
#'   id_seq individual var1-1 var1-2 var2-1 var2-2
#' 1     20        oui    121    120     20     19
#' 2     20        non     NA    112     NA     17
#' 3     20      peut1    101    110     14     17
#' 4     20      peut2    112    121     17     20
#' 5     19        oui    120    110     19     17
#' 6     19      peut1    110    115     17     18
#' 7     19      peut2    121    113     20     17
#'
#' historic_sequence1(inpt_datf = datf, bf_ = 3)
#' 
#'   id_seq individual var1-1 var1-2 var1-3 var2-1 var2-2 var2-3
#' 1     20        oui    121    120    110     20     19     17
#' 2     20        non     NA    112     NA     NA     17     NA
#' 3     20      peut1    101    110    115     14     17     18
#' 4     20      peut2    112    121    113     17     20     17
#'
#' @export

historic_sequence1 <- function(inpt_datf, bf_ = 1){
  nb_vars <- ncol(inpt_datf) - 2
  cur_ids <- sort(x = unique(inpt_datf[, 1]), decreasing = TRUE)
  rtn_datf <- as.data.frame(matrix(data = NA, 
                nrow = sum(inpt_datf[, 1] %in% cur_ids[1:(length(cur_ids) - bf_)]), ncol = 2))
  colnames(rtn_datf)[c(1, 2)] <- c("id_seq", "individual")
  cur_datf <- as.data.frame(matrix(nrow = 0, ncol = bf_))
  I = 1
  individuals_v <- c()
  ids_v <- c()
  for (i in 1:(length(cur_ids) - bf_)){
    indivs <- inpt_datf[inpt_datf[, 1] == cur_ids[i], 2] 
    individuals_v <- c(individuals_v, indivs)
    ids_v <- c(ids_v, rep(x = cur_ids[i], times = length(indivs)))
    cur_datf2 <- as.data.frame(matrix(nrow = length(indivs), ncol = 0))
    for (i2 in 1:bf_){
      cur_inpt_datf <- inpt_datf[inpt_datf[, 1] == cur_ids[(i + i2)], (I + 2)]
      cur_indivs <- match(x = indivs, table = inpt_datf[inpt_datf[, 1] == cur_ids[(i + i2)], 2])   
      cur_inpt_datf <- cur_inpt_datf[cur_indivs[!(is.na(cur_indivs))]]
      for (e in grep(pattern = TRUE, x = is.na(cur_indivs))){
        cur_inpt_datf <- append(x = cur_inpt_datf, values = NA, after = (e - 1))
      }
      cur_datf2 <- cbind(cur_datf2, cur_inpt_datf)
    }
    cur_datf <- rbind(cur_datf, cur_datf2)
  }
  rtn_datf[, 2] <- individuals_v
  rtn_datf[, 1] <- ids_v
  rtn_datf <- cbind(rtn_datf, cur_datf)
  colnames(rtn_datf)[3:(2 + bf_)] <- paste(colnames(inpt_datf)[3], c(1:bf_), sep = "-") 
  if (nb_vars > 1){
    for (I in 2:nb_vars){
      cur_datf <- as.data.frame(matrix(nrow = 0, ncol = bf_))
      for (i in 1:(length(cur_ids) - bf_)){
        indivs <- inpt_datf[inpt_datf[, 1] == cur_ids[i], 2] 
        cur_datf2 <- as.data.frame(matrix(nrow = length(indivs), ncol = 0))
        for (i2 in 1:bf_){
          cur_inpt_datf <- inpt_datf[(inpt_datf[, 1] == cur_ids[(i + i2)]), (I + 2)]
          cur_indivs <- match(x = indivs, table = inpt_datf[inpt_datf[, 1] == cur_ids[(i + i2)], 2])   
          cur_inpt_datf <- cur_inpt_datf[cur_indivs[!(is.na(cur_indivs))]]
          for (e in grep(pattern = TRUE, x = is.na(cur_indivs))){
            cur_inpt_datf <- append(x = cur_inpt_datf, values = NA, after = (e - 1))
          }
          cur_datf2 <- cbind(cur_datf2, cur_inpt_datf)
        }
        cur_datf <- rbind(cur_datf, cur_datf2)
      }
      rtn_datf <- cbind(rtn_datf, cur_datf)
      colnames(rtn_datf)[((I - 1) * bf_ + 3):(I * bf_ + 2)] <- paste(colnames(inpt_datf)[(I + 2)], c(1:bf_), sep = "-")
    }
  }
  return(rtn_datf)
}

#' rm_rows
#'
#' Allow to remove certain rows that contains certains characters, see examples.
#'
#' @param inpt_datf is the input dataframe
#' @param flagged_vals is a vector containing the characters that will drop any rows that contains it
#'
#' @examples
#'
#' datf <- data.frame(c(1, 2, NA, 4), c(1:4))
#' print(datf)
#'
#'   c.1..2..NA..4. c.1.4.
#' 1              1      1
#' 2              2      2
#' 3             NA      3
#' 4              4      4
#'
#' print(rm_rows(inpt_datf = datf, flagged_vals = c(1, 4)))
#' 
#'   c.1..2..NA..4. c.1.4.
#' 2              2      2
#' 3             NA      3
#' 
#' @export

rm_rows <- function(inpt_datf, flagged_vals = c()){
  rm_ids <- c()
  for (i in 1:nrow(inpt_datf)){
    no_stop <- TRUE
    cnt = 1
    while (no_stop & cnt <= length(flagged_vals)){
      if (as.character(flagged_vals[cnt]) %chin% as.character(inpt_datf[i, ])){
        rm_ids <- c(rm_ids, i)
        no_stop <- FALSE
      }
      cnt = cnt + 1
    }
  }
  if (length(rm_ids) > 0){
    return(inpt_datf[-rm_ids, ])
  }else{
    return(inpt_datf)
  }
}

#' rm_na_rows
#'
#' Allow to remove certain rows that contains NA, see examples.
#'
#' @param inpt_datf is the input dataframe
#' @param flagged_vals is a vector containing the characters that will drop any rows that contains it
#'
#' @examples
#'
#' datf <- data.frame(c(1, 2, NA, 4), c(1:4))
#' print(datf)
#' 
#'   c.1..2..NA..4. c.1.4.
#' 1              1      1
#' 2              2      2
#' 3             NA      3
#' 4              4      4
#'
#' print(rm_na_rows(inpt_datf = datf))
#' 
#'   c.1..2..NA..4. c.1.4.
#' 1              1      1
#' 2              2      2
#' 4              4      4
#' 
#' @export

rm_na_rows <- function(inpt_datf, flagged_vals = c()){
  rm_ids <- c()
  for (i in 1:nrow(inpt_datf)){
    if (any(is.na(inpt_datf[i, ]))){
      rm_ids <- c(rm_ids, i)
    }
  }
  if (length(rm_ids) > 0){
    return(inpt_datf[-rm_ids, ])
  }else{
    return(inpt_datf)
  }
}

#' sequence_na_med1
#'
#' In a dataframe generated by the function historic_sequence1, convert all NA to the median of the values at the same variable for the individual at the id where the NA occurs, see examples (only accepts numeric variables)
#'
#' @param inpt_datf is the input dataframe
#' @param bf_ is how at how many n - -1 we look for the value of the variables for the individual at time index n
#'
#' @examples
#'
#' set.seed(123)
#' var1 <- round(runif(n = 14, min = 100, max = 122))
#' set.seed(123)
#' var2 <- round(runif(n = 14, min = 14, max = 20))
#' 
#' datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
#' 17, 17, 17),
#' "individual" = c("oui", "non", "peut1", "peut2",
#' "oui", "peut1", "peut2"),
#' "var1" = var1,
#' "var2" = var2)
#' datf <- historic_sequence1(inpt_datf = datf, bf_ = 2)
#' datf[3, 4] <- NA
#' datf[6, 4] <- NA
#' datf[1, 3] <- NA
#' print(datf)
#' 
#'   id_seq individual var1-1 var1-2 var2-1 var2-2
#' 1     20        oui     NA    120     20     19
#' 2     20        non     NA    112     NA     17
#' 3     20      peut1    101     NA     14     17
#' 4     20      peut2    112    121     17     20
#' 5     19        oui    120    110     19     17
#' 6     19      peut1    110     NA     17     18
#' 7     19      peut2    121    113     20     17
#' 
#' print(sequence_na_med1(inpt_datf = datf, bf_ = 2))
#'
#'   id_seq individual var1-1 var1-2 var2-1 var2-2
#' 1     20        oui    115  120.0     20     19
#' 2     20        non    112  112.0     17     17
#' 3     20      peut1    101  105.5     14     17
#' 4     20      peut2    112  121.0     17     20
#' 5     19        oui    120  110.0     19     17
#' 6     19      peut1    110  105.5     17     18
#' 7     19      peut2    121  113.0     20     17 
#'
#' @export

sequence_na_med1 <- function(inpt_datf, bf_){
  for (I in 1:((ncol(inpt_datf) - 2) / bf_)){
    for (i in 1:bf_){
      cur_col <- ((I - 1) * bf_ + 2 + i)
      cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      cur_cols <- c((3 + (I - 1) * bf_):(2 + I * bf_))
      while (!(is.na(cur_mtch))){
        cur_vec <- c()
        times_na <- grep(pattern = TRUE, x = is.na(inpt_datf[cur_mtch[1], cur_cols]))
        pre_rows <- grep(pattern = inpt_datf[cur_mtch[1], 2], x = inpt_datf[, 2])
        for (rw in pre_rows){
          cur_vec <- c(cur_vec, inpt_datf[rw, cur_cols[1]])
        }
        if (bf_ > 1){
          cur_vec <- c(cur_vec, inpt_datf[pre_rows[length(pre_rows)], cur_cols[2:bf_]])
        }
        cur_vec <- as.numeric(cur_vec[!(is.na(cur_vec) | cur_vec == "NA")])
        if (length(cur_vec) > 0){
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- med(cur_vec)
        }else{
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- "NA"
        }
        cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      }
    }
  }
  return(inpt_datf)
}

#' sequence_na_mean1
#'
#' In a dataframe generated by the function historic_sequence1, convert all NA to the mean of the values at the same variable for the individual at the id where the NA occurs, see examples (only accepts numeric variables)
#'
#' @param inpt_datf is the input dataframe
#'
#' @examples
#'
#' set.seed(123)
#' var1 <- round(runif(n = 14, min = 100, max = 122))
#' set.seed(123)
#' var2 <- round(runif(n = 14, min = 14, max = 20))
#' 
#' datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
#' 17, 17, 17),
#' "individual" = c("oui", "non", "peut1", "peut2",
#' "oui", "peut1", "peut2"),
#' "var1" = var1,
#' "var2" = var2)
#' datf <- historic_sequence1(inpt_datf = datf, bf_ = 2)
#' datf[3, 4] <- NA
#' datf[6, 4] <- NA
#' datf[1, 3] <- NA
#' print(datf)
#' 
#'   id_seq individual var1-1 var1-2 var2-1 var2-2
#' 1     20        oui     NA    120     20     19
#' 2     20        non     NA    112     NA     17
#' 3     20      peut1    101     NA     14     17
#' 4     20      peut2    112    121     17     20
#' 5     19        oui    120    110     19     17
#' 6     19      peut1    110     NA     17     18
#' 7     19      peut2    121    113     20     17
#' 
#' print(sequence_na_mean1(inpt_datf = datf, bf_ = 2))
#'
#'   id_seq individual var1-1 var1-2 var2-1 var2-2
#' 1     20        oui    115  120.0     20     19
#' 2     20        non    112  112.0     17     17
#' 3     20      peut1    101  105.5     14     17
#' 4     20      peut2    112  121.0     17     20
#' 5     19        oui    120  110.0     19     17
#' 6     19      peut1    110  105.5     17     18
#' 7     19      peut2    121  113.0     20     17 
#'
#' @export

sequence_na_mean1 <- function(inpt_datf, bf_){
  for (I in 1:((ncol(inpt_datf) - 2) / bf_)){
    for (i in 1:bf_){
      cur_col <- ((I - 1) * bf_ + 2 + i)
      cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      cur_cols <- c((3 + (I - 1) * bf_):(2 + I * bf_))
      while (!(is.na(cur_mtch))){
        cur_vec <- c()
        times_na <- grep(pattern = TRUE, x = is.na(inpt_datf[cur_mtch[1], cur_cols]))
        pre_rows <- grep(pattern = inpt_datf[cur_mtch[1], 2], x = inpt_datf[, 2])
        for (rw in pre_rows){
          cur_vec <- c(cur_vec, inpt_datf[rw, cur_cols[1]])
        }
        if (bf_ > 1){
          cur_vec <- c(cur_vec, inpt_datf[pre_rows[length(pre_rows)], cur_cols[2:bf_]])
        }
        cur_vec <- as.numeric(cur_vec[!(is.na(cur_vec) | cur_vec == "NA")])
        if (length(cur_vec) > 0){
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- mean(cur_vec)
        }else{
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- "NA"
        }
        cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      }
    }
  }
  return(inpt_datf)
}

#' historic_sequence2
#'
#' Allow to perform a pivot wider on a sequencial dataset (here the type is dataframe), each variable will be dupplicated in a column to show the value to this variable at n - 1 for each individual, see examples.
#'
#' @param inpt_datf is the input dataframe
#' @param bf_ is the number of previous value of the individual it will search for, see examples
#'
#' @examples
#'
#' set.seed(123)
#' var1 <- round(runif(n = 14, min = 100, max = 122))
#' set.seed(123)
#' var2 <- round(runif(n = 14, min = 14, max = 20))
#' 
#' datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
#'                             17, 17, 17),
#'                   "individual" = c("oui", "non", "peut1", "peut2",
#'                                    "oui", "peut1", "peut2"),
#'                   "var1" = var1,
#'                   "var2" = var2)
#' print(datf)
#'
#'    ids individual var1 var2
#' 1   20        oui  106   16
#' 2   20        non  117   19
#' 3   20      peut1  109   16
#' 4   20      peut2  119   19
#' 5   19        oui  121   20
#' 6   19      peut1  101   14
#' 7   19      peut2  112   17
#' 8   18        oui  120   19
#' 9   18        non  112   17
#' 10  18      peut1  110   17
#' 11  18      peut2  121   20
#' 12  17        oui  110   17
#' 13  17      peut1  115   18
#' 14  17      peut2  113   17
#'
#' print(historic_sequence2(inpt_datf = datf, bf_ = 2))
#'
#'   id_seq individual var1-0 var1-1 var1-2 var2-0 var2-1 var2-2
#' 1     20        oui    106    121    120     16     20     19
#' 2     20        non    117     NA    112     19     NA     17
#' 3     20      peut1    109    101    110     16     14     17
#' 4     20      peut2    119    112    121     19     17     20
#' 5     19        oui    121    120    110     20     19     17
#' 6     19      peut1    101    110    115     14     17     18
#' 7     19      peut2    112    121    113     17     20     17
#'
#' print(historic_sequence2(inpt_datf = datf, bf_ = 3))
#' 
#'   id_seq individual var1-0 var1-1 var1-2 var1-3 var2-0 var2-1 var2-2 var2-3
#' 1     20        oui    106    121    120    110     16     20     19     17
#' 2     20        non    117     NA    112     NA     19     NA     17     NA
#' 3     20      peut1    109    101    110    115     16     14     17     18
#' 4     20      peut2    119    112    121    113     19     17     20     17
#'
#' @export

historic_sequence2 <- function(inpt_datf, bf_ = 1){
  nb_vars <- ncol(inpt_datf) - 2
  cur_ids <- sort(x = unique(inpt_datf[, 1]), decreasing = TRUE)
  rtn_datf <- as.data.frame(matrix(data = NA, 
                nrow = sum(inpt_datf[, 1] %in% cur_ids[1:(length(cur_ids) - bf_)]), ncol = 2))
  colnames(rtn_datf)[c(1, 2)] <- c("id_seq", "individual")
  cur_datf <- as.data.frame(matrix(nrow = 0, ncol = bf_))
  I = 1
  individuals_v <- c()
  ids_v <- c()
  for (i in 1:(length(cur_ids) - bf_)){
    indivs <- inpt_datf[inpt_datf[, 1] == cur_ids[i], 2] 
    individuals_v <- c(individuals_v, indivs)
    ids_v <- c(ids_v, rep(x = cur_ids[i], times = length(indivs)))
    cur_datf2 <- as.data.frame(matrix(data = inpt_datf[(inpt_datf[, 1] == cur_ids[i]), (I + 2)], nrow = length(indivs), ncol = 1))
    for (i2 in 1:bf_){
      cur_inpt_datf <- inpt_datf[inpt_datf[, 1] == cur_ids[(i + i2)], (I + 2)]
      cur_indivs <- match(x = indivs, table = inpt_datf[inpt_datf[, 1] == cur_ids[(i + i2)], 2])   
      cur_inpt_datf <- cur_inpt_datf[cur_indivs[!(is.na(cur_indivs))]]
      for (e in grep(pattern = TRUE, x = is.na(cur_indivs))){
        cur_inpt_datf <- append(x = cur_inpt_datf, values = NA, after = (e - 1))
      }
      cur_datf2 <- cbind(cur_datf2, cur_inpt_datf)
    }
    cur_datf <- rbind(cur_datf, cur_datf2)
  }
  rtn_datf[, 2] <- individuals_v
  rtn_datf[, 1] <- ids_v
  rtn_datf <- cbind(rtn_datf, cur_datf)
  colnames(rtn_datf)[3:(3 + bf_)] <- paste(colnames(inpt_datf)[3], c(0:bf_), sep = "-") 
  if (nb_vars > 1){
    for (I in 2:nb_vars){
      cur_datf <- as.data.frame(matrix(nrow = 0, ncol = bf_))
      for (i in 1:(length(cur_ids) - bf_)){
        indivs <- inpt_datf[inpt_datf[, 1] == cur_ids[i], 2] 
        cur_datf2 <- as.data.frame(matrix(data = inpt_datf[(inpt_datf[, 1] == cur_ids[i]), (I + 2)], nrow = length(indivs), ncol = 1))
        for (i2 in 1:bf_){
          cur_inpt_datf <- inpt_datf[(inpt_datf[, 1] == cur_ids[(i + i2)]), (I + 2)]
          cur_indivs <- match(x = indivs, table = inpt_datf[inpt_datf[, 1] == cur_ids[(i + i2)], 2])   
          cur_inpt_datf <- cur_inpt_datf[cur_indivs[!(is.na(cur_indivs))]]
          for (e in grep(pattern = TRUE, x = is.na(cur_indivs))){
            cur_inpt_datf <- append(x = cur_inpt_datf, values = NA, after = (e - 1))
          }
          cur_datf2 <- cbind(cur_datf2, cur_inpt_datf)
        }
        cur_datf <- rbind(cur_datf, cur_datf2)
      }
      rtn_datf <- cbind(rtn_datf, cur_datf)
      colnames(rtn_datf)[((I - 1) * bf_ + 4):(I * bf_ + 4)] <- paste(colnames(inpt_datf)[(I + 2)], c(0:bf_), sep = "-")
    }
  }
  return(rtn_datf)
}

#' sequence_na_med2
#'
#' In a dataframe generated by the function historic_sequence2, convert all NA to the median of the values at the same variable for the individual at the id where the NA occurs, see examples (only accepts numeric variables)
#'
#' @param inpt_datf is the input dataframe
#' @param bf_ is how at how many n -1 we look for the value of the variables for the individual at time index n
#'
#' @examples
#'
#' set.seed(123)
#' var1 <- round(runif(n = 14, min = 100, max = 122))
#' set.seed(123)
#' var2 <- round(runif(n = 14, min = 14, max = 20))
#' datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
#' 17, 17, 17),
#' "individual" = c("oui", "non", "peut1", "peut2",
#' "oui", "peut1", "peut2"),
#' "var1" = var1,
#' "var2" = var2)
#' datf <- historic_sequence2(inpt_datf = datf, bf_ = 2)
#' datf[3, 4] <- NA
#' datf[6, 4] <- NA
#' datf[1, 3] <- NA
#' print(datf)
#' 
#'   id_seq individual var1-0 var1-1 var1-2 var2-0 var2-1 var2-2
#' 1     20        oui     NA    121    120     16     20     19
#' 2     20        non    117     NA    112     19     NA     17
#' 3     20      peut1    109     NA    110     16     14     17
#' 4     20      peut2    119    112    121     19     17     20
#' 5     19        oui    121    120    110     20     19     17
#' 6     19      peut1    101     NA    115     14     17     18
#' 7     19      peut2    112    121    113     17     20     17
#' 
#' print(sequence_na_med2(inpt_datf = datf, bf_ = 2))
#'
#'   id_seq individual var1-0 var1-1 var1-2 var2-0 var2-1 var2-2
#' 1     20        oui    120  121.0    120     16     20     19
#' 2     20        non    117  114.5    112     19     18     17
#' 3     20      peut1    109  109.0    110     16     14     17
#' 4     20      peut2    119  112.0    121     19     17     20
#' 5     19        oui    121  120.0    110     20     19     17
#' 6     19      peut1    101  109.0    115     14     17     18
#' 7     19      peut2    112  121.0    113     17     20     17
#'
#' @export

sequence_na_med2 <- function(inpt_datf, bf_){
  bf_ = bf_ + 1
  for (I in 1:((ncol(inpt_datf) - 2) / bf_)){
    for (i in 1:bf_){
      cur_col <- ((I - 1) * bf_ + 2 + i)
      cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      cur_cols <- c((3 + (I - 1) * bf_):(2 + I * bf_))
      while (!(is.na(cur_mtch))){
        cur_vec <- c()
        times_na <- grep(pattern = TRUE, x = is.na(inpt_datf[cur_mtch[1], cur_cols]))
        pre_rows <- grep(pattern = inpt_datf[cur_mtch[1], 2], x = inpt_datf[, 2])
        for (rw in pre_rows){
          cur_vec <- c(cur_vec, inpt_datf[rw, cur_cols[1]])
        }
        if (bf_ > 1){
          cur_vec <- c(cur_vec, inpt_datf[pre_rows[length(pre_rows)], cur_cols[2:bf_]])
        }
        cur_vec <- as.numeric(cur_vec[!(is.na(cur_vec) | cur_vec == "NA")])
        if (length(cur_vec) > 0){
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- med(cur_vec)
        }else{
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- "NA"
        }
        cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      }
    }
  }
  return(inpt_datf)
}

#' sequence_na_mean2
#'
#' In a dataframe generated by the function historic_sequence1, convert all NA to the mean of the values at the same variable for the individual at the id where the NA occurs, see examples (only accepts numeric variables)
#'
#' @param inpt_datf is the input dataframe
#' @param bf_ is how at how many n -1 we look for the value of the variables for the individual at time index n
#'
#' @examples
#'
#' set.seed(123)
#' var1 <- round(runif(n = 14, min = 100, max = 122))
#' set.seed(123)
#' var2 <- round(runif(n = 14, min = 14, max = 20))
#' 
#' datf <- data.frame("ids" = c(20, 20, 20, 20, 19, 19, 19, 18, 18, 18, 18,
#' 17, 17, 17),
#' "individual" = c("oui", "non", "peut1", "peut2",
#' "oui", "peut1", "peut2"),
#' "var1" = var1,
#' "var2" = var2)
#' datf <- historic_sequence2(inpt_datf = datf, bf_ = 2)
#' datf[3, 4] <- NA
#' datf[6, 4] <- NA
#' datf[1, 3] <- NA
#' print(datf)
#' 
#'   id_seq individual var1-0 var1-1 var1-2 var2-0 var2-1 var2-2
#' 1     20        oui     NA    121    120     16     NA     19
#' 2     20        non    117     NA    112     19     NA     17
#' 3     20      peut1    109     NA    110     16     14     17
#' 4     20      peut2    119    112    121     19     17     20
#' 5     19        oui    121    120    110     20     19     17
#' 6     19      peut1    101     NA    115     14     17     18
#' 7     19      peut2    112    121    113     17     20     17
#' 
#' print(sequence_na_mean2(inpt_datf = datf, bf_ = 2))
#'
#'   id_seq individual var1-0   var1-1 var1-2 var2-0 var2-1 var2-2
#' 1     20        oui    117 121.0000    120     16     18     19
#' 2     20        non    117 114.5000    112     19     18     17
#' 3     20      peut1    109 108.3333    110     16     14     17
#' 4     20      peut2    119 112.0000    121     19     17     20
#' 5     19        oui    121 120.0000    110     20     19     17
#' 6     19      peut1    101 108.3333    115     14     17     18
#' 7     19      peut2    112 121.0000    113     17     20     17
#'
#' @export

sequence_na_mean2 <- function(inpt_datf, bf_){
  bf_ = bf_ + 1
  for (I in 1:((ncol(inpt_datf) - 2) / bf_)){
    for (i in 1:bf_){
      cur_col <- ((I - 1) * bf_ + 2 + i)
      cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      cur_cols <- c((3 + (I - 1) * bf_):(2 + I * bf_))
      while (!(is.na(cur_mtch))){
        cur_vec <- c()
        times_na <- grep(pattern = TRUE, x = is.na(inpt_datf[cur_mtch[1], cur_cols]))
        pre_rows <- grep(pattern = inpt_datf[cur_mtch[1], 2], x = inpt_datf[, 2])
        for (rw in pre_rows){
          cur_vec <- c(cur_vec, inpt_datf[rw, cur_cols[1]])
        }
        if (bf_ > 1){
          cur_vec <- c(cur_vec, inpt_datf[pre_rows[length(pre_rows)], cur_cols[2:bf_]])
        }
        cur_vec <- as.numeric(cur_vec[!(is.na(cur_vec) | cur_vec == "NA")])
        if (length(cur_vec) > 0){
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- mean(cur_vec)
        }else{
          inpt_datf[cur_mtch[1], cur_cols[times_na]] <- "NA"
        }
        cur_mtch <- match(x = TRUE, table = is.na(inpt_datf[, cur_col]))
      }
    }
  }
  return(inpt_datf)
}

#' edm_group_by1
#'
#' Performs a group by (different algorythm than edm_group_by2), see examples
#'
#' @param inpt_datf is the input dataframe
#' @param grp_v is the vector containiong the column names or the column numbers to perform the group by, see examples
#'
#' @examples
#'
#' datf <- data.frame("col1" = c("A", "B", "B", "A", "C", "B"), 
#'                   "col2" = c("E", "R", "E", "E", "R", "R"), 
#'                   "col3" = c("P", "P", "O", "O", "P", "O"))
#'
#' print(datf)
#' 
#'   col1 col2 col3
#' 1    A    E    P
#' 2    B    R    P
#' 3    B    E    O
#' 4    A    E    O
#' 5    C    R    P
#' 6    B    R    O
#'
#' print(edm_group_by1(inpt_datf = datf, grp_v = c("col1")))
#'
#'   col1 col2 col3
#' 1    A    E    P
#' 4    A    E    O
#' 2    B    R    P
#' 3    B    E    O
#' 6    B    R    O
#' 5    C    R    P
#'
#' print(edm_group_by1(inpt_datf = datf, grp_v = c("col1", "col2")))
#'
#'   col1 col2 col3
#' 1    A    E    P
#' 4    A    E    O
#' 2    B    R    P
#' 6    B    R    O
#' 3    B    E    O
#' 5    C    R    P
#'
#' print(edm_group_by1(inpt_datf = datf, grp_v = c("col2", "col1", "col3")))
#'
#'   col2 col1 col3
#' 1    E    A    P
#' 4    E    A    O
#' 3    E    B    O
#' 2    R    B    P
#' 6    R    B    O
#' 5    R    C    P
#'
#' print(edm_group_by1(inpt_datf = datf, grp_v = c("col2", "col1", "col3")))
#' 
#'   col2 col1 col3
#' 1    E    A    P
#' 4    E    A    O
#' 3    E    B    O
#' 2    R    B    P
#' 6    R    B    O
#' 5    R    C    P
#' 
#' @export

edm_group_by1 <- function(inpt_datf, grp_v = c()){
  if (typeof(grp_v) == "character"){
    for (i in 1:length(grp_v)){
      grp_v[i] <- match(x = grp_v[i], colnames(inpt_datf))
    }
    grp_v <- as.numeric(grp_v)
  }
  id_v <- inpt_datf[, grp_v[1]]
  id_v_original <- id_v
  Id_v <- c()
  id_row <- c()
  for (el in unique(id_v)){
    id_row2 <- (id_v == el)
    Id_v <- c(Id_v, id_v[id_row2])
    id_row <- c(id_row, grep(pattern = TRUE, x = id_row2))
  }
  if (length(grp_v) > 1){
    for (i in 2:length(grp_v)){
      id_v_original <- paste0(id_v_original, inpt_datf[, grp_v[i]])
      Id_v2 <- Id_v
      Id_v <- c()
      cur_unique <- unique(Id_v2)
      for (i2 in 1:length(cur_unique)){
        cnt = match(x = cur_unique[i2], table = Id_v2)
        cnt2 = cnt
        no_stop <- TRUE
        while (Id_v2[cnt2] == cur_unique[i2] & no_stop){ 
          if (cnt2 == length(Id_v2)){
            no_stop <- FALSE 
          }else{
            cnt2 = cnt2 + 1
          }
        }
        if (!(no_stop)){
          cur_row <- id_row[cnt:cnt2]
          cnt2 = cnt2 + 1
        }else{
          cur_row <- id_row[cnt:(cnt2 - 1)]
        }
        id_v <- inpt_datf[cur_row, grp_v[i]]
        cur_row_id <- c()
        for (el in unique(id_v)){
          id_row2 <- (id_v == el)
          Id_v <- c(Id_v, rep(x = paste0(cur_unique[i2], el), times = sum(id_row2)))
          cur_row_id <- c(cur_row_id, grep(pattern = TRUE, x = id_row2))
        }
        id_row[cnt:(cnt2 - 1)] <- cur_row[cur_row_id]
      }
    }
  }
  rtn_datf <- as.data.frame(matrix(nrow = 0, ncol = ncol(inpt_datf)))
  col_v <- c(1:ncol(inpt_datf))
  col_v[sort(x = grp_v, decreasing = FALSE)] <- grp_v
  for (el in unique(Id_v)){
    rtn_datf <- rbind(rtn_datf, inpt_datf[(id_v_original == el), col_v]) 
  }
  return(rtn_datf)
}

#' edm_group_by2
#'
#' Performs a group by (different algorythm that edm_group_by1), see examples
#'
#' @param inpt_datf is the input dataframe
#' @param grp_v is the vector containiong the column names or the column numbers to perform the group by, see examples
#'
#' @examples
#'
#' datf <- data.frame("col1" = c("A", "B", "B", "A", "C", "B"), 
#'                   "col2" = c("E", "R", "E", "E", "R", "R"), 
#'                   "col3" = c("P", "P", "O", "O", "P", "O"))
#' print(datf)
#'
#'   col1 col2 col3
#' 1    A    E    P
#' 2    B    R    P
#' 3    B    E    O
#' 4    A    E    O
#' 5    C    R    P
#' 6    B    R    O
#'
#' print(edm_group_by2(inpt_datf = datf, grp_v = c("col1")))
#'
#'   col1 col2 col3
#' 1    A    E    P
#' 4    A    E    O
#' 2    B    R    P
#' 3    B    E    O
#' 6    B    R    O
#' 5    C    R    P
#'
#' print(edm_group_by2(inpt_datf = datf, grp_v = c("col1", "col2")))
#'
#'   col1 col2 col3
#' 1    A    E    P
#' 4    A    E    O
#' 3    B    E    O
#' 2    B    R    P
#' 6    B    R    O
#' 5    C    R    P
#'
#' print(edm_group_by2(inpt_datf = datf, grp_v = c("col2", "col1")))
#' 
#'   col2 col1 col3
#' 1    E    A    P
#' 4    E    A    O
#' 3    E    B    O
#' 2    R    B    P
#' 6    R    B    O
#' 5    R    C    P
#'
#' @export

edm_group_by2 <- function(inpt_datf, grp_v){
  if (typeof(grp_v) == "character"){
    for (i in 1:length(grp_v)){
      grp_v[i] <- match(x = grp_v[i], table = colnames(inpt_datf))
    }
    grp_v <- as.numeric(grp_v)
  }
  max_v <- mapply(function(x) return(length(unique(inpt_datf[, x]))), grp_v)
  track_v <- rep(x = 1, times = length(grp_v))
  lngth_val <- length(unique(inpt_datf[, grp_v[1]]))
  rtn_datf <- as.data.frame(matrix(nrow = 0, ncol = ncol(inpt_datf)))
  col_v <- c(1:ncol(inpt_datf))
  col_v[sort(x = grp_v, decreasing = FALSE)] <- grp_v
  while (track_v[1] <= lngth_val){
    cur_datf <- inpt_datf[(inpt_datf[, grp_v[1]] == unique(inpt_datf[, grp_v[1]])[track_v[1]]), ]
    if (length(grp_v) > 1){
      for (i in 2:length(grp_v)){
        cur_datf <- cur_datf[(cur_datf[, grp_v[i]] == unique(inpt_datf[, grp_v[i]])[track_v[i]]), ]
      }
      if (track_v[length(track_v)] == max_v[length(max_v)]){
        track_v[length(track_v)] <- 1
        track_v[(length(track_v) - 1)] <- track_v[(length(track_v) - 1)] + 1
        if (length(grp_v) > 2){
          for (i in (length(track_v) - 1):2){
            if (track_v[i] == max_v[i]){
              track_v[i] <- 1
              track_v[(i - 1)] <- track_v[(i - 1)] + 1
            }
          }
        }
      }else{
        track_v[length(track_v)] = track_v[length(track_v)] + 1
      }
    }else{
      track_v[1] = track_v[1] + 1
    }
    rtn_datf <- rbind(rtn_datf, cur_datf)
  }
  return(rtn_datf[, col_v])
}

#' edm_pivot_wider1
#'
#' Performs a pivot wider to a dataframe, see examples.
#' 
#' @param inpt_datf is the input dataframe
#' @param col_vars is a vector containig the column names or column numbers of the variables to pivot
#' @param col_vals is a vector containing the column numbers or column names of the values to pivot
#' @param individual_col is the column name or column number of the individuals
#'
#' @examples
#'
#' datf2 <- data.frame("individual" = c(1, 1, 1, 2, 3, 3),
#'                    "var1" = c("A", "A", "B", "B", "B", "A"),
#'                    "val1" = c(6, 7, 1, 0, 4, 2),
#'                    "val2" = c(3, 9, 11, 22, 5, 8))
#' datf <- data.frame("individual" = c(1, 1, 1, 2, 3, 3),
#'                    "var1" = c("A", "A", "B", "B", "B", "A"),
#'                    "var2" = c("R", "T", "T", "R", "T", "R"),
#'                    "val1" = c(6, 7, 1, 0, 4, 2),
#'                    "val2" = c(3, 9, 11, 22, 5, 8))
#' print(datf)
#'
#'   individual var1 var2 val1 val2
#' 1          1    A    R    6    3
#' 2          1    A    T    7    9
#' 3          1    B    T    1   11
#' 4          2    B    R    0   22
#' 5          3    B    T    4    5
#' 6          3    A    R    2    8
#'
#' print(datf2)
#'
#'   individual var1 val1 val2
#' 1          1    A    6    3
#' 2          1    A    7    9
#' 3          1    B    1   11
#' 4          2    B    0   22
#' 5          3    B    4    5
#' 6          3    A    2    8
#'
#' print(edm_pivot_wider1(
#'                        inpt_datf = datf, 
#'                        col_vars = c(2, 3), 
#'                        col_vals = c(4, 5), 
#'                        individual_col = 1)
#'     )
#'
#'   individuals val1-A.R val1-A.T val1-B.R val1-B.T val2-A.R val2-A.T val2-B.R
#' 1           1        6        7        0        1        3        9        0
#' 2           2        0        0        0        0        0        0       22
#' 3           3        2        0        0        4        8        0        0
#'   val2-B.T
#' 1       11
#' 2        0
#' 3        5
#'
#' print(edm_pivot_wider1(
#'                        inpt_datf = datf2, 
#'                        col_vars = c(2), 
#'                        col_vals = c(3, 4), 
#'                        individual_col = 1)
#'     )
#' 
#'   individuals val1-A val1-B val2-A val2-B
#' 1           1      7      1      9     11
#' 2           2      0      0      0     22
#' 3           3      2      4      8      5
#'
#' @export

edm_pivot_wider1 <- function(inpt_datf, 
                            col_vars = c(), 
                            col_vals = c(),
                            individual_col){
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vars)){
      col_vars[i] <- match(x = col_vars[i], colnames(inpt_datf))
    }
    col_vars <- as.numeric(col_vars)
  }
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vals)){
      col_vals[i] <- match(x = col_vals[i], colnames(inpt_datf))
    }
    col_vals <- as.numeric(col_vals)
  }
  if (typeof(individual_col) == "character"){
    individual_character <- match(x = individual_col, table = colnames(inpt_datf))
  }
  mod_l <- list() 
  pos_v <- c()
  hmn_mods = 0
  for (i in col_vars){
    cur_mods <- unique(inpt_datf[, i])
    hmn_mods = hmn_mods + length(cur_mods)
    mod_l <- append(x = mod_l, values = list(cur_mods))
    pos_v <- c(pos_v, 1)
  }
  hmn_col <- hmn_mods * length(col_vals) + 1 
  rtn_datf <- as.data.frame(matrix(nrow = 0, ncol = hmn_col))
  col_names <- c()
  if (length(mod_l) > 1){
    cur_lngth <- length(mod_l[[1]])
    for (cur_val in col_vals){
      while (pos_v[1] <= cur_lngth){
        cur_col_names <- c()
        for (i in 1:length(mod_l)){
          cur_col_names <- c(cur_col_names, mod_l[[i]][pos_v[i]])
        }
        col_names <- c(col_names, paste0(colnames(inpt_datf)[cur_val], "-", paste(cur_col_names, collapse = ".")))
        pos_v[length(pos_v)] <- pos_v[length(pos_v)] + 1
        cnt = 0
        if (pos_v[(length(pos_v) - cnt)] > length(mod_l[[(length(mod_l) - cnt)]])){
          no_stop <- TRUE
        }else{
          no_stop <- FALSE
        }
        while (no_stop){
          pos_v[(length(pos_v) - cnt)] <- 1 
          pos_v[(length(pos_v) - cnt - 1)] <- pos_v[(length(pos_v) - cnt - 1)] + 1
          cnt = cnt + 1
          if ((cnt + 1) == length(pos_v)){
            no_stop <- FALSE
          }else if (!(pos_v[(length(pos_v) - cnt)] > length(mod_l[[(length(mod_l) - cnt)]]))){
            no_stop <- FALSE
          }
        }
      }
      pos_v <- rep.int(x = 1, times = length(pos_v))
    }
  }else{
    cur_lngth <- length(mod_l[[1]])
    for (cur_val in col_vals){
      while (pos_v[1] <= cur_lngth){
        cur_col_names <- c()
        for (i in 1:length(mod_l)){
          cur_col_names <- c(cur_col_names, mod_l[[i]][pos_v[i]])
        }
        col_names <- c(col_names, paste0(colnames(inpt_datf)[cur_val], "-", paste(cur_col_names, collapse = ".")))
        pos_v[length(pos_v)] <- pos_v[length(pos_v)] + 1
      }
      pos_v <- c(1)
    }
  }
  prev_indv <- inpt_datf[1, individual_col]
  cur_row <- rep(x = 0, times = hmn_col) 
  cur_row[1] <- prev_indv
  for (i in 1:nrow(inpt_datf)){
    cur_col_names <- c()
    for (cl in col_vars){
      cur_col_names <- c(cur_col_names, inpt_datf[i, cl])
    }
    if (inpt_datf[i, individual_col] != prev_indv){
      rtn_datf <- rbind(rtn_datf, cur_row)
      prev_indv <- inpt_datf[i, individual_col]
      cur_row <- rep(x = 0, times = hmn_col) 
      cur_row[1] <- prev_indv
    }
    for (vl in 1:length(col_vals)){
      cur_row[1 + match(x = paste0(colnames(inpt_datf)[col_vals[vl]], "-", paste(cur_col_names, collapse = ".")), table = col_names)] <- inpt_datf[i, col_vals[vl]] 
    }
  }
  rtn_datf <- rbind(rtn_datf, cur_row)
  colnames(rtn_datf) <- c("individuals", col_names)
  return(rtn_datf)
}

#' edm_pivot_wider2
#'
#' Performs a pivot wider to a dataframe with a different algorythm than edm_pivot_wider, see examples.
#' 
#' @param inpt_datf is the input dataframe
#' @param col_vars is a vector containig the column names or column numbers of the variables to pivot
#' @param col_vals is a vector containing the column numbers or column names of the values to pivot
#' @param individual_col is the column name or column number of the individuals
#'
#' @examples
#'
#' datf2 <- data.frame("individual" = c(1, 1, 1, 2, 3, 3),
#'                    "var1" = c("A", "A", "B", "B", "B", "A"),
#'                    "val1" = c(6, 7, 1, 0, 4, 2),
#'                    "val2" = c(3, 9, 11, 22, 5, 8))
#' datf <- data.frame("individual" = c(1, 1, 1, 2, 3, 3),
#'                    "var1" = c("A", "A", "B", "B", "B", "A"),
#'                    "var2" = c("R", "T", "T", "R", "T", "R"),
#'                    "val1" = c(6, 7, 1, 0, 4, 2),
#'                    "val2" = c(3, 9, 11, 22, 5, 8))
#' print(datf)
#'
#'   individual var1 var2 val1 val2
#' 1          1    A    R    6    3
#' 2          1    A    T    7    9
#' 3          1    B    T    1   11
#' 4          2    B    R    0   22
#' 5          3    B    T    4    5
#' 6          3    A    R    2    8
#'
#' print(datf2)
#'
#'   individual var1 val1 val2
#' 1          1    A    6    3
#' 2          1    A    7    9
#' 3          1    B    1   11
#' 4          2    B    0   22
#' 5          3    B    4    5
#' 6          3    A    2    8
#'
#' print(edm_pivot_wider2(
#'                        inpt_datf = datf, 
#'                        col_vars = c(2, 3), 
#'                        col_vals = c(4, 5), 
#'                        individual_col = 1)
#'     )
#'
#'   individuals val1-A.R val1-A.T val1-B.R val1-B.T val2-A.R val2-A.T val2-B.R
#' 1           1        6        7        0        1        3        9        0
#' 2           2        0        0        0        0        0        0       22
#' 3           3        2        0        0        4        8        0        0
#'   val2-B.T
#' 1       11
#' 2        0
#' 3        5
#'
#' print(edm_pivot_wider2(
#'                        inpt_datf = datf2, 
#'                        col_vars = c(2), 
#'                        col_vals = c(3, 4), 
#'                        individual_col = 1)
#'     )
#' 
#'   individuals val1-A val1-B val2-A val2-B
#' 1           1      7      1      9     11
#' 2           2      0      0      0     22
#' 3           3      2      4      8      5
#'
#' @export

edm_pivot_wider2 <- function(inpt_datf, 
                            col_vars = c(), 
                            col_vals = c(),
                            individual_col){
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vars)){
      col_vars[i] <- match(x = col_vars[i], colnames(inpt_datf))
    }
    col_vars <- as.numeric(col_vars)
  }
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vals)){
      col_vals[i] <- match(x = col_vals[i], colnames(inpt_datf))
    }
    col_vals <- as.numeric(col_vals)
  }
  if (typeof(individual_col) == "character"){
    individual_character <- match(x = individual_col, table = colnames(inpt_datf))
  }
  pos_v <- c()
  hmn_mods = 0
  for (i in col_vars){
    cur_mods <- unique(inpt_datf[, i])
    hmn_mods = hmn_mods + length(cur_mods)
    pos_v <- c(pos_v, 1)
  }
  hmn_col <- hmn_mods * length(col_vals) + 1 
  rtn_datf <- as.data.frame(matrix(nrow = 0, ncol = hmn_col))
  col_names <- c()
  if (length(pos_v) > 1){
    cur_lngth <- length(unique(inpt_datf[, col_vars[length(col_vars)]]))
    for (cur_val in col_vals){
      while (pos_v[1] <= cur_lngth){
        cur_col_names <- c()
        for (i in 1:length(pos_v)){
          cur_col_names <- c(cur_col_names, unique(inpt_datf[, col_vars[i]])[pos_v[i]])
        }
        col_names <- c(col_names, paste0(colnames(inpt_datf)[cur_val], "-", paste(cur_col_names, collapse = ".")))
        pos_v[length(pos_v)] <- pos_v[length(pos_v)] + 1
        cnt = 0
        if (pos_v[(length(pos_v) - cnt)] > length(unique(inpt_datf[, col_vars[length(pos_v) - cnt]]))){
          no_stop <- TRUE
        }else{
          no_stop <- FALSE
        }
        while (no_stop){
          pos_v[(length(pos_v) - cnt)] <- 1 
          pos_v[(length(pos_v) - cnt - 1)] <- pos_v[(length(pos_v) - cnt - 1)] + 1
          cnt = cnt + 1
          if ((cnt + 1) == length(pos_v)){
            no_stop <- FALSE
          }else if (!(pos_v[(length(pos_v) - cnt)] > length(unique(inpt_datf[, col_vars[length(pos_v) - cnt]])))){
            no_stop <- FALSE
          }
        }
      }
      pos_v <- rep.int(x = 1, times = length(pos_v))
    }
  }else{
    cur_lngth <- length(unique(inpt_datf[, col_vars[length(col_vars)]]))
    for (cur_val in col_vals){
      while (pos_v[1] <= cur_lngth){
        cur_col_names <- c()
        for (i in 1:length(pos_v)){
          cur_col_names <- c(cur_col_names, unique(inpt_datf[, col_vars[i]])[pos_v[i]])
        }
        col_names <- c(col_names, paste0(colnames(inpt_datf)[cur_val], "-", paste(cur_col_names, collapse = ".")))
        pos_v[length(pos_v)] <- pos_v[length(pos_v)] + 1
      }
      pos_v <- c(1)
    }
  }
  prev_indv <- inpt_datf[1, individual_col]
  cur_row <- rep(x = 0, times = hmn_col) 
  cur_row[1] <- prev_indv
  for (i in 1:nrow(inpt_datf)){
    cur_col_names <- c()
    for (cl in col_vars){
      cur_col_names <- c(cur_col_names, inpt_datf[i, cl])
    }
    if (inpt_datf[i, individual_col] != prev_indv){
      rtn_datf <- rbind(rtn_datf, cur_row)
      prev_indv <- inpt_datf[i, individual_col]
      cur_row <- rep(x = 0, times = hmn_col) 
      cur_row[1] <- prev_indv
    }
    for (vl in 1:length(col_vals)){
      cur_row[1 + match(x = paste0(colnames(inpt_datf)[col_vals[vl]], "-", paste(cur_col_names, collapse = ".")), table = col_names)] <- inpt_datf[i, col_vals[vl]] 
    }
  }
  rtn_datf <- rbind(rtn_datf, cur_row)
  colnames(rtn_datf) <- c("individuals", col_names)
  return(rtn_datf)
}

#' edm_pivot_longer1
#'
#' Performs a pivot longer on dataframe, see examples. The synthax for variables must be value_id-modalitie_var1.modalitie_var2...
#'
#' @param inpt_datf is the input dataframe
#' @param col_vars is a vector containing the column names or column numbers of the variables
#' @param individual_col is the column name or the column number of the individuals
#' @param col_vars_to is a vector containing the varaiables to which will be assign the modalities, see examples
#'
#' @examples
#'
#' datf <- data.frame("individuals" = c(1, 2, 3),
#'                    c(1, 2, 3),
#'                    c(6, 0, 2),
#'                    c(7, 0, 0),
#'                    c(0, 0, 0),
#'                    c(1, 0, 4),
#'                    c(3, 0, 8),
#'                    c(9, 0 , 0),
#'                    c(11, 0, 5))
#' 
#' colnames(datf)[2:ncol(datf)] <- c("val1-A.R", 
#'                                   "val1-A.T", 
#'                                   "val1-B.R",
#'                                   "val1-B.T", 
#'                                   "val2-A.R",
#'                                   "val2-A.T",
#'                                   "val2-B.R",
#'                                   "val2-B.T")
#' 
#' datf2 <- data.frame("individuals" = c(1, 2, 3),
#'                    c(7, 0, 2),
#'                    c(1, 0, 4),
#'                    c(9, 0, 8),
#'                    c(11, 22, 5))
#' colnames(datf2)[2:ncol(datf2)] <- c(
#' 
#'                         "val1-A", 
#'                         "val1-B",
#'                         "val2-A",
#'                         "val2-B"
#'                    )
#' 
#' print(datf)
#'
#'   individuals val1-A.R val1-A.T val1-B.R val1-B.T val2-A.R val2-A.T val2-B.R
#' 1           1        1        6        7        0        1        3        9
#' 2           2        2        0        0        0        0        0        0
#' 3           3        3        2        0        0        4        8        0
#'   val2-B.T
#' 1       11
#' 2        0
#' 3        5
#'
#' print(edm_pivot_longer1(inpt_datf = datf, 
#'                           col_vars = c(2:9), 
#'                           individual_col = 1, 
#'                           col_vars_to = c("Shape", "Way"),
#'                           null_value = c(0)))
#'
#'   individuals Shape Way val1 val2
#' 1           1     A   R    1    1
#' 2           1     A   T    6    3
#' 3           1     B   R    7    9
#' 4           1     B   T    0   11
#' 5           2     A   R    2    0
#' 6           3     A   R    3    4
#' 7           3     A   T    2    8
#' 8           3     B   T    0    5
#'
#' print(datf2)
#'
#'   individuals val1-A val1-B val2-A val2-B
#' 1           1      7      1      9     11
#' 2           2      0      0      0     22
#' 3           3      2      4      8      5
#'
#' print(edm_pivot_longer1(inpt_datf = datf2, 
#'                         col_vars = c(2:5), 
#'                         individual_col = 1, 
#'                         col_vars_to = c("Shape"), 
#'                         null_value = c(0)))
#'
#'   individuals Shape val1 val2
#' 1           1     A    7    9
#' 2           1     B    1   11
#' 3           2     B    0   22
#' 4           3     A    2    8
#' 5           3     B    4    5
#'
#' @export

edm_pivot_longer1 <- function(inpt_datf, 
                             col_vars = c(), 
                             col_vars_to = c(), 
                             individual_col,
                             null_value = c(0),
                             nvr_here= "?"){
  better_split <- function(inpt, split_v = c()){
    for (split in split_v){
      pre_inpt <- inpt
      inpt <- c()
      for (el in pre_inpt){
        inpt <- c(inpt, unlist(strsplit(x = el, split = split)))
      }
    }
    return(inpt)
  }
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vars)){
      col_vars[i] <- match(x = col_vars[i], colnames(inpt_datf))
    }
    col_vars <- as.numeric(col_vars)
  }
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vals)){
      col_vals[i] <- match(x = col_vals[i], colnames(inpt_datf))
    }
    col_vals <- as.numeric(col_vals)
  }
  if (typeof(individual_col) == "character"){
    individual_character <- match(x = individual_col, table = colnames(inpt_datf))
  }
  cur_split <- better_split(inpt = colnames(inpt_datf)[col_vars[1]], split_v = c("\\.", "-"))
  hmn_col = length(cur_split)
  nb_var <- hmn_col - 1
  val_v <- c(cur_split[1])
  rtn_datf <- as.data.frame(matrix(nrow = 0, ncol = hmn_col))
  if (length(col_vars) > 1){
    cnt = 1
    while (unlist(strsplit(x = colnames(inpt_datf)[col_vars[cnt]], split = "-"))[1] == val_v[1]){
      cnt = cnt + 1
    }
    cnt = cnt - 1
    stay_cnt <- cnt
    while ((1 + cnt) < length(col_vars)){
      val_v <- c(val_v, unlist(strsplit(x = colnames(inpt_datf)[col_vars[(cnt + 1)]], split = "-"))[1])
      cnt = cnt * 2
    }
  }
  for (I in 1:nrow(inpt_datf)){
    pre_grp <- grep(pattern = TRUE, x = !(inpt_datf[I, c((2 + stay_cnt):ncol(inpt_datf))] %in% null_value)) 
    pre_grp[(pre_grp == 0)] <- stay_cnt 
    cur_null_vec <- grep(pattern = TRUE, x = (inpt_datf[I, c(2:(stay_cnt + 1))] %in% null_value)) 
    cur_intersct <- intersect(pre_grp, cur_null_vec) + 1
    null_id <- match(x = inpt_datf[I, cur_intersct], table = null_value)
    inpt_datf[I, cur_intersct] <- nvr_here
    for (i in grep(pattern = TRUE, x = !(inpt_datf[I, c(2:(1 + stay_cnt))] %in% null_value))){
      cur_row <- c(inpt_datf[I, individual_col])
      cur_split <- better_split(inpt = colnames(inpt_datf)[(i + 1)], split_v = c("-", "\\.")) 
      for (el in c(cur_split[2:length(cur_split)], 
                   inpt_datf[I, seq(from = (i + 1), to = ncol(inpt_datf), by = stay_cnt)])){
        cur_row <- c(cur_row, el)
      }
      cur_row[cur_row == nvr_here] <- null_value[null_id]
      rtn_datf <- rbind(rtn_datf, cur_row)
    }
  }
  colnames(rtn_datf) <- c("individuals", col_vars_to, val_v)
  return(rtn_datf)
}

#' edm_pivot_longer2
#'
#' Performs a pivot longer on dataframe keeping the null values, see examples. The synthax for variables must be value_id-modalitie_var1.modalitie_var2...
#'
#' @param inpt_datf is the input dataframe
#' @param col_vars is a vector containing the column names or column numbers of the variables
#' @param individual_col is the column name or the column number of the individuals
#' @param col_vars_to is a vector containing the varaiables to which will be assign the modalities, see examples
#'
#' @examples
#'
#' datf <- data.frame("individuals" = c(1, 2, 3),
#'                    c(1, 2, 3),
#'                    c(6, 0, 2),
#'                    c(7, 0, 0),
#'                    c(0, 0, 0),
#'                    c(1, 0, 4),
#'                    c(3, 0, 8),
#'                    c(9, 0 , 0),
#'                    c(11, 0, 5))
#' 
#' colnames(datf)[2:ncol(datf)] <- c("val1-A.R", 
#'                                   "val1-A.T", 
#'                                   "val1-B.R",
#'                                   "val1-B.T", 
#'                                   "val2-A.R",
#'                                   "val2-A.T",
#'                                   "val2-B.R",
#'                                   "val2-B.T")
#' 
#' datf2 <- data.frame("individuals" = c(1, 2, 3),
#'                    c(7, 0, 2),
#'                    c(1, 0, 4),
#'                    c(9, 0, 8),
#'                    c(11, 22, 5))
#' colnames(datf2)[2:ncol(datf2)] <- c(
#' 
#'                         "val1-A", 
#'                         "val1-B",
#'                         "val2-A",
#'                         "val2-B"
#'                    )
#' 
#' print(datf)
#'
#'   individuals val1-A.R val1-A.T val1-B.R val1-B.T val2-A.R val2-A.T val2-B.R
#' 1           1        1        6        7        0        1        3        9
#' 2           2        2        0        0        0        0        0        0
#' 3           3        3        2        0        0        4        8        0
#'   val2-B.T
#' 1       11
#' 2        0
#' 3        5
#'
#' print(edm_pivot_longer2(inpt_datf = datf, 
#'                           col_vars = c(2:9), 
#'                           individual_col = 1, 
#'                           col_vars_to = c("Shape", "Way")))
#'
#'    individuals Shape Way val1 val2
#' 1            1     A   R    1    1
#' 2            1     A   T    6    3
#' 3            1     B   R    7    9
#' 4            1     B   T    0   11
#' 5            2     A   R    2    0
#' 6            2     A   T    0    0
#' 7            2     B   R    0    0
#' 8            2     B   T    0    0
#' 9            3     A   R    3    4
#' 10           3     A   T    2    8
#' 11           3     B   R    0    0
#' 12           3     B   T    0    5
#'
#' print(datf2)
#'
#'   individuals val1-A val1-B val2-A val2-B
#' 1           1      7      1      9     11
#' 2           2      0      0      0     22
#' 3           3      2      4      8      5
#'
#' print(edm_pivot_longer2(inpt_datf = datf2, 
#'                         col_vars = c(2:5), 
#'                         individual_col = 1, 
#'                         col_vars_to = c("Shape")))
#'
#'   individuals Shape val1 val2
#' 1           1     A    7    9
#' 2           1     B    1   11
#' 3           2     A    0    0
#' 4           2     B    0   22
#' 5           3     A    2    8
#' 6           3     B    4    5
#'
#' @export

edm_pivot_longer2 <- function(inpt_datf, 
                             col_vars = c(), 
                             col_vars_to = c(), 
                             individual_col){
  better_split <- function(inpt, split_v = c()){
    for (split in split_v){
      pre_inpt <- inpt
      inpt <- c()
      for (el in pre_inpt){
        inpt <- c(inpt, unlist(strsplit(x = el, split = split)))
      }
    }
    return(inpt)
  }
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vars)){
      col_vars[i] <- match(x = col_vars[i], colnames(inpt_datf))
    }
    col_vars <- as.numeric(col_vars)
  }
  if (typeof(col_vars) == "character"){
    for (i in 1:length(col_vals)){
      col_vals[i] <- match(x = col_vals[i], colnames(inpt_datf))
    }
    col_vals <- as.numeric(col_vals)
  }
  if (typeof(individual_col) == "character"){
    individual_character <- match(x = individual_col, table = colnames(inpt_datf))
  }
  cur_split <- better_split(inpt = colnames(inpt_datf)[col_vars[1]], split_v = c("\\.", "-"))
  hmn_col = length(cur_split)
  nb_var <- hmn_col - 1
  val_v <- c(cur_split[1])
  rtn_datf <- as.data.frame(matrix(nrow = 0, ncol = hmn_col))
  if (length(col_vars) > 1){
    cnt = 1
    while (unlist(strsplit(x = colnames(inpt_datf)[col_vars[cnt]], split = "-"))[1] == val_v[1]){
      cnt = cnt + 1
    }
    cnt = cnt - 1
    stay_cnt <- cnt
    while ((1 + cnt) < length(col_vars)){
      val_v <- c(val_v, unlist(strsplit(x = colnames(inpt_datf)[col_vars[(cnt + 1)]], split = "-"))[1])
      cnt = cnt * 2
    }
  }
  for (I in 1:nrow(inpt_datf)){
    for (i in c(2:(1 + stay_cnt))){
      cur_row <- c(inpt_datf[I, individual_col])
      cur_split <- better_split(inpt = colnames(inpt_datf)[i], split_v = c("-", "\\."))
      for (el in c(cur_split[2:length(cur_split)], 
                   inpt_datf[I, seq(from = i, to = ncol(inpt_datf), by = stay_cnt)])){
        cur_row <- c(cur_row, el)
      }
      rtn_datf <- rbind(rtn_datf, cur_row)
    }
  }
  colnames(rtn_datf) <- c("individuals", col_vars_to, val_v)
  return(rtn_datf)
}

#' match_na_omit
#'
#' Performs a match, but remove the NA values in the output if there is one or many, see examples.
#'
#' @param x is the vector of the patterns to be matched
#' @param table is the vector that may contain the patterns to be matched
#'
#' @examples
#'
#' match_na_omit(x = c("oui", "non", "2"), table = c("1", "oui", "oui", "ee", "non"))
#'
#' [1] 2 5
#'
#' @export

match_na_omit <- function(x, table){
  rtn_v <- match(x = x, table = table)
  return(rtn_v[!(is.na(rtn_v))])
}


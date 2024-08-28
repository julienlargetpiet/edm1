intersect_all <- function(...){
  if (length(list(...)) == 1){
    if (typeof(...) == "list"){
      rtn_v <- unlist(...[1])
      if (length(...) > 1){
        for (el in ...[2:length(...)]){
          rtn_v <- intersect(rtn_v, el) 
        }
      }
      return(rtn_v)
    }else{
      return(...)
    }
  }
  rtn_v <- unlist(list(...)[1])
  if (length(list(...)) > 1){
    for (el in list(...)[2:length(list(...))]){
           rtn_v <- intersect(rtn_v, el) 
    }
  }
  return(rtn_v)
}

cur_lst <- list()
cur_lst <- append(x = cur_lst, values = list(c(1:10)))
cur_lst <- append(x = cur_lst, values = list(c(5:17)))
cur_lst <- append(x = cur_lst, values = list(c(-5:7)))

print(intersect_all(cur_lst))
print(intersect_all(c(1:10), c(5:18), c(-5:7)))

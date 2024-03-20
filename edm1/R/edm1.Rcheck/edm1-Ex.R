pkgname <- "edm1"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('edm1')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("all_stat")
### * all_stat

flush(stderr()); flush(stdout())

### Name: all_stat
### Title: all_stat
### Aliases: all_stat

### ** Examples

df <- data.frame("mod"=c("first", "seco", "seco", "first", "first", "third", "first"), 
                "var1"=c(11, 22, 21, 22, 22, 11, 9), 
               "var2"=c("d", "d", "z", "z", "z", "d", "z"), 
               "var3"=c(45, 44, 43, 46, 45, 45, 42),
              "var4"=c("A", "A", "A", "A", "B", "C", "C"))

all_stat(inpt_v=c("first", "seco"), var_add = c("var1", "var2", "var3", "var4"), 
 stat_var=c("sum", "mean", "median", "sd", "occu-var2/", "occu-var4/", "variance", "quantile-0.75/"), 
 inpt_df=df)



cleanEx()
nameEx("any_join_df")
### * any_join_df

flush(stderr()); flush(stdout())

### Name: any_join_df
### Title: any_join_df
### Aliases: any_join_df

### ** Examples


df1 <- data.frame("val"=c(1, 1, 2, 4), "ids"=c("e", "a", "z", "a"), 
"last"=c("oui", "oui", "non", "oui"),
"second_ids"=c(13, 11, 12, 8))

df2 <- data.frame("val"=c(3, 7, 2, 4, 1, 2), "ids"=c("a", "z", "z", "a", "a", "a"), 
"bool"=c(T, F, F, F, T, T),
"second_ids"=c(13, 12, 8, 34, 22, 12))

df3 <- data.frame("val"=c(1, 9, 2, 4), "ids"=c("a", "a", "z", "a"), 
"last"=c("oui", "oui", "non", "oui"),
"second_ids"=c(13, 11, 12, 8))

print(any_join_df(inpt_df_l=list(df1, df2, df3), join_type="inner", 
id_v=c("ids", "second_ids"), 
                 excl_col=c(), rtn_col=c()))
 ids val ids last second_ids val ids  bool second_ids val ids last second_ids
3 z12   2   z  non         12   7   z FALSE         12   2   z  non         12

print(any_join_df(inpt_df_l=list(df1, df2, df3), join_type="inner", id_v=c("ids"),
excl_col=c(), rtn_col=c()))

 ids val ids last second_ids val ids  bool second_ids val ids last second_ids
2   a   1   a  oui         11   3   a  TRUE         13   1   a  oui         13
3   z   2   z  non         12   7   z FALSE         12   2   z  non         12
4   a   4   a  oui          8   4   a FALSE         34   9   a  oui         11

print(any_join_df(inpt_df_l=list(df1, df2, df3), join_type=c(1), id_v=c("ids"), 
                 excl_col=c(), rtn_col=c()))

 ids val ids last second_ids  val  ids  bool second_ids  val  ids last
1   e   1   e  oui         13 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>
2   a   1   a  oui         11    3    a  TRUE         13    1    a  oui
3   z   2   z  non         12    7    z FALSE         12    2    z  non
4   a   4   a  oui          8    4    a FALSE         34    9    a  oui
 second_ids
1       <NA>
2         13
3         12
4         11

print(any_join_df(inpt_df_l=list(df2, df1, df3), join_type=c(1, 3), id_v=c("ids", "second_ids"), 
                 excl_col=c(), rtn_col=c()))
  ids  val  ids  bool second_ids  val  ids last second_ids  val  ids last
1  a13    3    a  TRUE         13 <NA> <NA> <NA>       <NA>    1    a  oui
2  z12    7    z FALSE         12    2    z  non         12    2    z  non
3   z8    2    z FALSE          8 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
4  a34    4    a FALSE         34 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
5  a22    1    a  TRUE         22 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
6  a12    2    a  TRUE         12 <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
7  a13 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
8  a11 <NA> <NA>  <NA>       <NA>    1    a  oui         11    9    a  oui
9  z12 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>       <NA> <NA> <NA> <NA>
10  a8 <NA> <NA>  <NA>       <NA>    4    a  oui          8    4    a  oui
  second_ids
1          13
2          12
3        <NA>
4        <NA>
5        <NA>
6        <NA>
7        <NA>
8          11
9        <NA>
10          8

print(any_join_df(inpt_df_l=list(df1, df2, df3), join_type=c(1), id_v=c("ids"), 
                 excl_col=c(), rtn_col=c()))

ids val ids last second_ids  val  ids  bool second_ids  val  ids last
1   e   1   e  oui         13 <NA> <NA>  <NA>       <NA> <NA> <NA> <NA>
2   a   1   a  oui         11    3    a  TRUE         13    1    a  oui
3   z   2   z  non         12    7    z FALSE         12    2    z  non
4   a   4   a  oui          8    4    a FALSE         34    9    a  oui
 second_ids
1       <NA>
2         13
3         12
4         11



cleanEx()
nameEx("calc_occu_v")
### * calc_occu_v

flush(stderr()); flush(stdout())

### Name: calc_occu_v
### Title: calc_occu_v
### Aliases: calc_occu_v

### ** Examples

print(calc_occu_v(f_v=c("e", "a", "z", NA, "a"), w_v=c("a", "a", "z")))

[1] 1 3 2



cleanEx()
nameEx("chr_removr")
### * chr_removr

flush(stderr()); flush(stdout())

### Name: chr_removr
### Title: chr_removr
### Aliases: chr_removr

### ** Examples

print(chr_removr(inpt_v=c("oui?", "!oui??", "non", "!non"), ptrn_v=c("?")))
[1] "oui"  "!oui" "non"  "!non"

print(chr_removr(inpt_v=c("oui?", "!oui??", "non", "!non"), ptrn_v=c("?", "!")))
[1] "oui" "oui" "non" "non"



cleanEx()
nameEx("closer_ptrn")
### * closer_ptrn

flush(stderr()); flush(stdout())

### Name: closer_ptrn
### Title: closer_ptrn
### Aliases: closer_ptrn

### ** Examples


print(closer_ptrn(inpt_v=c("bonjour", "lpoerc", "nonnour", "bonnour", "nonjour", "aurevoir")))

[[1]]
[1] "bonjour"

[[2]]
[1] "lpoerc"   "nonnour"  "bonnour"  "nonjour"  "aurevoir"

[[3]]
[1] 1 1 2 7 8

[[4]]
[1] "lpoerc"

[[5]]
[1] "bonjour"  "nonnour"  "bonnour"  "nonjour"  "aurevoir"

[[6]]
[1] 7 7 7 7 7

[[7]]
[1] "nonnour"

[[8]]
[1] "bonjour"  "lpoerc"   "bonnour"  "nonjour"  "aurevoir"

[[9]]
[1] 1 1 2 7 8

[[10]]
[1] "bonnour"

[[11]]
[1] "bonjour"  "lpoerc"   "nonnour"  "nonjour"  "aurevoir"

[[12]]
[1] 1 1 2 7 8

[[13]]
[1] "nonjour"

[[14]]
[1] "bonjour"  "lpoerc"   "nonnour"  "bonnour"  "aurevoir"

[[15]]
[1] 1 1 2 7 8

[[16]]
[1] "aurevoir"

[[17]]
[1] "bonjour" "lpoerc"  "nonnour" "bonnour" "nonjour"

[[18]]
[1] 7 8 8 8 8
print(closer_ptrn(inpt_v=c("bonjour", "lpoerc", "nonnour", "bonnour", "nonjour", "aurevoir"), excl_v=c("nonnour", "nonjour"),
                 sub_excl_v=c("nonnour")))

[1] 3 5
[[1]]
[1] "bonjour"

[[2]]
[1] "lpoerc"   "bonnour"  "nonjour"  "aurevoir"

[[3]]
[1] 1 1 7 8

[[4]]
[1] "lpoerc"

[[5]]
[1] "bonjour"  "bonnour"  "nonjour"  "aurevoir"

[[6]]
[1] 7 7 7 7

[[7]]
[1] "bonnour"

[[8]]
[1] "bonjour"  "lpoerc"   "bonnour"  "nonjour"  "aurevoir"

[[9]]
[1] 0 1 2 7 8

[[10]]
[1] "aurevoir"

[[11]]
[1] "bonjour"  "lpoerc"   "nonjour"  "aurevoir"

[[12]]
[1] 0 7 8 8



cleanEx()
nameEx("closer_ptrn_adv")
### * closer_ptrn_adv

flush(stderr()); flush(stdout())

### Name: closer_ptrn_adv
### Title: closer_ptrn_adv
### Aliases: closer_ptrn_adv

### ** Examples

print(closer_ptrn_adv(inpt_v=c("aurevoir", "bonnour", "nonnour", "fin", "mois", "bonjour"), res="word", c_word="bonjour"))

[[1]]
[1]  1  5 15 17 38 65

[[2]]
[1] "bonjour"  "bonnour"  "aurevoir" "nonnour"  "mois"     "fin"     

print(closer_ptrn_adv(inpt_v=c("aurevoir", "bonnour", "nonnour", "fin", "mois")))

[[1]]
[1] 117 107 119  37  64

[[2]]
[1] "aurevoir" "bonnour"  "nonnour"  "fin"      "mois"    



cleanEx()
nameEx("clusterizer_v")
### * clusterizer_v

flush(stderr()); flush(stdout())

### Name: clusterizer_v
### Title: clusterizer_v
### Aliases: clusterizer_v

### ** Examples

 print(clusterizer_v(inpt_v=sample.int(20, 26, replace=T), w_v=NA, c_val=0.9))

[[1]]
[[1]][[1]]
[1] "j" "v"

[[1]][[2]]
[1] "x"

[[1]][[3]]
[1] "e" "m" "p" "s" "t" "b" "q" "z" "f"

[[1]][[4]]
[1] "a" "i"

[[1]][[5]]
[1] "c" "n" "o" "g" "u" "y" "h" "l"

[[1]][[6]]
[1] "d" "r" "w" "k"


[[2]]
[1] "1"  "2"  "-"  "4"  "4"  "-"  "6"  "10" "-"  "12" "12" "-"  "14" "16" "-" 
[16] "18" "19"

print(clusterizer_v(inpt_v=sample.int(40, 26, replace=T), w_v=letters, c_val=0.29))


[[1]]
[[1]][[1]]
[1] "a" "b" "c" "d" "e" "f" "g" "h"

[[1]][[2]]
[1] "i" "j" "k" "l"

[[1]][[3]]
[1] "m" "n"

[[1]][[4]]
[1] "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"


[[2]]
[1] "1"  "5"  "-"  "8"  "10" "-"  "12" "13" "-"  "15" "20"



cleanEx()
nameEx("equalizer_v")
### * equalizer_v

flush(stderr()); flush(stdout())

### Name: equalizer_v
### Title: equalizer_v
### Aliases: equalizer_v

### ** Examples

 print(equalizer_v(inpt_v=c("aa", "zzz", "q"), depth=2))
 [1] "aa" "zz" "q?"

 print(equalizer_v(inpt_v=c("aa", "zzz", "q"), depth=12))
 [1] "aa??????????" "zzz?????????" "q???????????"



cleanEx()
nameEx("extrt_only_v")
### * extrt_only_v

flush(stderr()); flush(stdout())

### Name: extrt_only_v
### Title: extrt_only_v
### Aliases: extrt_only_v

### ** Examples

print(extrt_only_v(inpt_v=c("oui", "non", "peut", "oo", "ll", "oui", "non", "oui", "oui"), pttrn_v=c("oui")))

[1] "oui" "oo"  "oui" "oui" "oui"



cleanEx()
nameEx("fillr")
### * fillr

flush(stderr()); flush(stdout())

### Name: fillr
### Title: fillr
### Aliases: fillr

### ** Examples

fillr(c("a", "b", "...3", "c"))



cleanEx()
nameEx("fittr_v")
### * fittr_v

flush(stderr()); flush(stdout())

### Name: fittr_v
### Title: fittr_v
### Aliases: fittr_v

### ** Examples

print(fittr_v(f_v=c("non", "non", "non", "oui"), w_v=c("oui", "non", "non")))

[1] 4 1 2



cleanEx()
nameEx("fixer_nest_v")
### * fixer_nest_v

flush(stderr()); flush(stdout())

### Name: fixer_nest_v
### Title: fixer_nest_v
### Aliases: fixer_nest_v

### ** Examples

print(fixer_nest_v(cur_v=c("oui", "non", "peut-etre", "oui", "non", "peut-etre"), pttrn_v=c("oui", "non", "peut-etre"), 
                  wrk_v=c(1, 2, 3, 4, 5, 6)))

[1] 1 2 3 4 5 6

print(fixer_nest_v(cur_v=c("oui", "non", "peut-etre", "oui", "non", "peut-etre"), pttrn_v=c("oui", "non"), 
                  wrk_v=c(1, 2, 3, 4, 5, 6)))

[1]  1  2 NA  4  5 NA



cleanEx()
nameEx("geo_min")
### * geo_min

flush(stderr()); flush(stdout())

### Name: geo_min
### Title: geo_min
### Aliases: geo_min

### ** Examples

in_ <- data.frame(c(11, 33, 55), c(113, -143, 167))

in2_ <- data.frame(c(12, 55), c(115, 165))

print(geo_min(inpt_df=in_, established_df=in2_))

in_ <- data.frame(c(51, 23, 55), c(113, -143, 167), c(6, 5, 1))

in2_ <- data.frame(c(12, 55), c(115, 165), c(2, 5))

geo_min(inpt_df=in_, established_df=in2_)



cleanEx()
nameEx("globe")
### * globe

flush(stderr()); flush(stdout())

### Name: globe
### Title: globe
### Aliases: globe

### ** Examples

globe(lat_f=23, long_f=112, alt_f=NA, lat_n=c(2, 82), long_n=c(165, -55), alt_n=NA) 



cleanEx()
nameEx("groupr_df")
### * groupr_df

flush(stderr()); flush(stdout())

### Name: groupr_df
### Title: groupr_df
### Aliases: groupr_df

### ** Examples

interactive()
df1 <- data.frame(c(1, 2, 1), c(45, 22, 88), c(44, 88, 33))

val_lst <- list(list(c(1), c(1)), list(c(2)), list(c(44)))

condition_lst <- list(c(">", "<"), c("%%"), c("=="))

conjunction_lst <- list(c("|"), c(), c())

rtn_val_pos <- c("+", "+", "+")

groupr_df(inpt_df=df1, val_lst=val_lst, condition_lst=condition_lst, 
conjunction_lst=conjunction_lst, rtn_val_pos=rtn_val_pos)



cleanEx()
nameEx("incr_fillr")
### * incr_fillr

flush(stderr()); flush(stdout())

### Name: incr_fillr
### Title: incr_fillr
### Aliases: incr_fillr

### ** Examples

print(incr_fillr(inpt_v=c(1, 2, 4, 5, 9, 10), 
                wrk_v=NA, 
                default_val="increasing"))

[1]  1  2  3  4  5  6  7  8  9 10

print(incr_fillr(inpt_v=c(1, 1, 2, 4, 5, 9), 
                wrk_v=c("ok", "ok", "ok", "ok", "ok"), 
                default_val=NA))

[1] "ok" "ok" "ok" NA   "ok" "ok" NA   NA   NA  

print(incr_fillr(inpt_v=c(1, 2, 4, 5, 9, 10), 
                wrk_v=NA, 
                default_val="NAN"))

[1] "1"   "2"   "NAN" "4"   "5"   "NAN" "NAN" "NAN" "9"   "10" 



cleanEx()
nameEx("inter_min")
### * inter_min

flush(stderr()); flush(stdout())

### Name: inter_min
### Title: inter_min
### Aliases: inter_min

### ** Examples


[[0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2
.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0], [0, 0.1, 0.2, 0.3, 0.4, 0.
5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8
, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8, 3.9, 4.0], [1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0,
2.1, 2.2, 2.3]]



cleanEx()
nameEx("lst_flatnr")
### * lst_flatnr

flush(stderr()); flush(stdout())

### Name: lst_flatnr
### Title: lst_flatnr
### Aliases: lst_flatnr

### ** Examples

print(lst_flatnr(inpt_l=list(c(1, 2), c(5, 3), c(7, 2, 7))))

[1] 1 2 5 3 7 2 7



cleanEx()
nameEx("nest_v")
### * nest_v

flush(stderr()); flush(stdout())

### Name: nest_v
### Title: nest_v
### Aliases: nest_v

### ** Examples

print(nest_v(f_v=c(1, 2, 3, 4, 5, 6), t_v=c("oui", "oui2", "oui3", "oui4", "oui5", "oui6"), step=2, after=2))

[1] "1"    "2"    "oui"  "3"    "4"    "oui2" "5"    "6"    "oui3" "oui4"



cleanEx()
nameEx("nestr_df1")
### * nestr_df1

flush(stderr()); flush(stdout())

### Name: nestr_df1
### Title: nestr_df1
### Aliases: nestr_df1

### ** Examples

nestr_df1(inptf_df=data.frame(c(1, 2, 1), c(1, 5, 7)), 
inptt_pos_df=data.frame(c(4, 4, 3), c(2, 1, 2)), 
inptt_neg_df=data.frame(c(44, 44, 33), c(12, 12, 12)), 
nestr_df=data.frame(c(TRUE, FALSE, TRUE), c(FALSE, FALSE, TRUE)), yes_val=TRUE) 



cleanEx()
nameEx("nestr_df2")
### * nestr_df2

flush(stderr()); flush(stdout())

### Name: nestr_df2
### Title: nestr_df2
### Aliases: nestr_df2

### ** Examples

nestr_df2(inptf_df=data.frame(c(1, 2, 1), c(1, 5, 7)), rtn_pos="yes", 
rtn_neg="no", nestr_df=data.frame(c(TRUE, FALSE, TRUE), c(FALSE, FALSE, TRUE)), yes_val=TRUE) 



cleanEx()
nameEx("paste_df")
### * paste_df

flush(stderr()); flush(stdout())

### Name: paste_df
### Title: paste_df
### Aliases: paste_df

### ** Examples

print(paste_df(inpt_df=data.frame(c(1, 2, 1), c(33, 22, 55))))

[1] "133" "222" "155"



cleanEx()
nameEx("ptrn_switchr")
### * ptrn_switchr

flush(stderr()); flush(stdout())

### Name: ptrn_switchr
### Title: ptrn_switchr
### Aliases: ptrn_switchr

### ** Examples

ptrn_switchr(inpt_l=c("2022-01-11", "2022-01-14", "2022-01-21", 
"2022-01-01"), f_idx_l=c(1, 2, 3), t_idx_l=c(3, 2, 1))
ptrn_switchr(inpt_l=c("2022-01-11", "2022-01-14", "2022-01-21", 
"2022-01-01"), f_idx_l=c(1), default_val="ee")



cleanEx()
nameEx("ptrn_twkr")
### * ptrn_twkr

flush(stderr()); flush(stdout())

### Name: ptrn_twkr
### Title: ptrn_twkr
### Aliases: ptrn_twkr

### ** Examples

library("stringr")
v <- c("2012-06-22", "2012-06-23", "2022-09-12", "2022")
ptrn_twkr(inpt_l=v, depth="max", sep="-", default_val="00", add_sep=TRUE)



cleanEx()
nameEx("rearangr_v")
### * rearangr_v

flush(stderr()); flush(stdout())

### Name: rearangr_v
### Title: rearangr_v
### Aliases: rearangr_v

### ** Examples

print(rearangr_v(inpt_v=c(23, 21, 56), w_v=c("oui", "peut", "non"), how="decreasing"))
[1] "non"  "oui"  "peut"



cleanEx()
nameEx("unique_ltr_from_v")
### * unique_ltr_from_v

flush(stderr()); flush(stdout())

### Name: unique_ltr_from_v
### Title: unique_ltr_from_v
### Aliases: unique_ltr_from_v

### ** Examples

print(unique_ltr_from_v(inpt_v=c("bonjour", "lpoerc", "nonnour", "bonnour", "nonjour", "aurevoir")))
 [1] "b" "o" "n" "j" "u" "r" "l" "p" "e" "c" "a" "v" "i" 



cleanEx()
nameEx("v_to_df")
### * v_to_df

flush(stderr()); flush(stdout())

### Name: v_to_df
### Title: v_to_df
### Aliases: v_to_df

### ** Examples

library("stringr")
v <- c("aa-yy-uu", "zz-gg-hhh", "zz-gg-hhh", "zz-gg-hhh")
v_to_df(inpt_v=v, sep="-")



### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')

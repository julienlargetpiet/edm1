
# `append_row`

append_row


## Description

Append the last row from dataframe to the another or same dataframe


## Usage

```r
append_row(df_in, df, hmn = 1, na_col = c(), unique_do_not_know = NA)
```


## Arguments

Argument      |Description
------------- |----------------
`df_in`     |     is the dataframe from which the row will append to another or the same  dataframe
`df`     |     is the dataframe to which the row will append
`hmn`     |     is how many time the last row will be appended
`na_col`     |     is a vector containing the columns that won't append and will be replaced by another value (unique_do_not_know)
`unique_do_not_know`     |     is the value of the non appending column in the appending row


# `can_be_num`

can_be_num


## Description

Return TRUE if a variable can be converted to a number and FALSE if not (supports float)


## Usage

```r
can_be_num(x)
```


## Arguments

Argument      |Description
------------- |----------------
`x`     |     is the input value


# `change_date`

change_date


## Description

Allow to add to a date second-minute-hour-day-month-year


## Usage

```r
change_date(
  date_,
  sep_,
  day_ = NA,
  month_ = NA,
  year_ = NA,
  hour_ = NA,
  min_ = NA,
  second_ = NA,
  frmt = "snhdmy"
)
```


## Arguments

Argument      |Description
------------- |----------------
`date_`     |     is the input date
`sep_`     |     is the date separator
`day_`     |     is the day to add (can be negative)
`month_`     |     is the month to add (can be negative)
`year_`     |     is the year to add (can be negative)
`hour_`     |     is the hour to add (can be negative)
`min_`     |     is the minute to add (can be negative)
`second_`     |     is the second to add (can be negative)
`frmt`     |     is the format of the input date, (deault set to "snhdmy" (second, minute, hour, day, month, year), so all variable are taken in count), if you only want to work with standard date for example change this variable to "dmy"


# `closest_date`

closest_date


## Description

return the closest dates from a vector compared to the input date


## Usage

```r
closest_date(
  vec,
  date_,
  frmt,
  sep_ = "/",
  sep_vec = "/",
  only_ = "both",
  head = NA
)
```


## Arguments

Argument      |Description
------------- |----------------
`vec`     |     is a vector containing the dates to be compared to the input date
`date_`     |     is the input date
`frmt`     |     is the format of the input date, (deault set to "snhdmy" (second, minute, hour, day, month, year), so all variable are taken in count), if you only want to work with standard date for example change this variable to "dmy"
`sep_`     |     is the separator for the input date
`sep_vec`     |     is the separator for the dates contained in vec
`only_`     |     is can be changed to "+" or "-" to repectively only return the higher dates and the lower dates (default set to "both")
`head`     |     is the number of dates that will be returned (default set to NA so all dates in vec will be returned)


# `cost_and_taxes`

cost_and_taxes


## Description

Allow to calculate basic variables related to cost and taxes from a bunch of products (elements)
 So put every variable you know in the following order:


## Usage

```r
cost_and_taxes(
  qte = NA,
  pu = NA,
  prix_ht = NA,
  tva = NA,
  prix_ttc = NA,
  prix_tva = NA,
  pu_ttc = NA,
  adjust = NA,
  prix_d_ht = NA,
  prix_d_ttc = NA,
  pu_d = NA,
  pu_d_ttc = NA
)
```


## Arguments

Argument      |Description
------------- |----------------
`qte`     |     is the quantity of elements
`pu`     |     is the price of a single elements without taxes
`prix_ht`     |     is the duty-free price of the whole set of elements
`tva`     |     is the percentage of all taxes
`prix_ttc`     |     is the price of all the elements with taxes
`prix_tva`     |     is the cost of all the taxes
`pu_ttc`     |     is the price of a single element taxes included
`adjust`     |     is the discount percentage
`prix_d_ht`     |     is the free-duty price of an element after discount
`prix_d_ttc`     |     is the price with taxes of an element after discount
`pu_d`     |     is the price of a single element after discount and without taxes
`pu_d_ttc`     |     is the free-duty price of a single element after discount the function return a vector with the previous variables in the same order those that could not be calculated will be represented with NA value


# `data_gen`

data_gen


## Description

Allo to generate in a csv all kind of data you can imagine according to what you provide


## Usage

```r
data_gen(
  type_ = c("number", "mixed", "string"),
  strt_l = c(0, 0, 10),
  nb_r = c(50, 10, 40),
  output = "gened.csv",
  properties = c("1-5", "1-5", "1-5"),
  type_distri = c("random", "random", "random"),
  str_source = c("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n",
    "o", "p", "q", "r", "s", "t", "u", "w", "x", "y", "z"),
  round_l = c(0, 0, 0),
  sep_ = ","
)
```


## Arguments

Argument      |Description
------------- |----------------
`type_`     |     is a vector for wich argument is a column, a column can be made of numbers ("number"), string ("string") or both ("mixed")
`strt_l`     |     is a vector containing for each column the row from which the data will begin to be generated
`nb_r`     |     is a vector containing for each column, the number of row full from generated data
`output`     |     is the name of the output csv file
`properties`     |     is linked to type_distri because it is the parameters ("min_val-max_val") for "random type", ("u-x") for the poisson distribution, ("u-d") for gaussian distribution
`type_distri`     |     is a vector which, for each column, associate a type of distribution ("random", "poisson", "gaussian"), it meas that non only the number but also the length of the string will be randomly generated according to these distribution laws
`str_source`     |     is the source (vector) from which the character creating random string are (default set to the occidental alphabet)
`round_l`     |     is a vector which, for each column containing number, associate a round value
`sep_`     |     is the separator used to write data in the csv


## Value

new generated data in addition to saving it in the output


# `data_meshup`

data_meshup


## Description

Allow to automatically arrange 1 dimensional data according to vector and parameters


## Usage

```r
data_meshup(
  data,
  cols = NA,
  file_ = NA,
  sep_ = ";",
  organisation = c(2, 1, 0),
  unic_sep1 = "_",
  unic_sep2 = "-"
)
```


## Arguments

Argument      |Description
------------- |----------------
`data`     |     is the data provided (vector) each column is separated by a unic separator and each dataset from the same column is separated by another unic separator (ex: c(" ", c("d", "-", "e", "-", "f"), " ", c("a", "a1", "-", "b", "-", "c", "c1")"_")
`cols`     |     is the colnames of the data generated in a csv
`file_`     |     is the file to which the data will be outputed
`sep_`     |     is the separator of the csv outputed
`organisation`     |     is the way variables include themselves, for instance ,resuming precedent example, if organisation=c(1, 0) so the data output will be: d, a d, a1 e, c f, c f, c1
`unic_sep1`     |     is the unic separator between variables (default is "_")
`unic_sep2`     |     is the unic separator between datasets (default is "-")


# `date_sort`

date_sort


## Description

Allow to ascendely or desendely sort dates in a vector.


## Usage

```r
date_sort(vec, asc = F, sep = "-")
```


## Arguments

Argument      |Description
------------- |----------------
`vec`     |     is the vector containing the dates.
`asc`     |     is a boolean variable, that if set to TRUE will sort the dates ascendely and descendely if set to FALSE
`sep`     |     is the separator of the date strings ex: "11-12-1998" the separator is "-"


# `days_from_month`

days_from_month


## Description

Allow to find the number of days month from a month date, take in count leap year


## Usage

```r
days_from_month(date_, sep_)
```


## Arguments

Argument      |Description
------------- |----------------
`date_`     |     is the input date
`sep_`     |     is the separator of the input date


# `df_tuned`

df_tuned


## Description

Allow to return a list from a dataframe following these rules:
 First situation, I want the vectors from the returned list be composed of values that are separated by special values contained in a vector
 ex: data.frame(c(1, 1, 2, 1), c(1, 1, 2, 1), c(1, 1, 1, 2)) will return list(c(1, 1), c(1, 1, 1), c(1, 1, 1, 1)) or
 list(c(1, 1, 2), c(1, 1, 1, 2), c(1, 1, 1, 1, 2)) if i have chosen to take in count the 2. As you noticed here the value to stop is 2 but it can be several contained in a vector
 Second situation: I want to return a list for every jump of 3.
 If i take this dataframe data.frame(c(1, 1, 2, 1, 4, 4), c(1, 1, 2, 1, 3, 3), c(1, 1, 1, 2, 3, 3)) it will return list(c(1, 1, 2), c(1, 4, 4), c(1, 1, 2), c(1, 3, 3), c(1, 1, 1), c(2, 3, 3))


## Usage

```r
df_tuned(df, val_to_stop, index_rc = NA, included = "yes")
```


## Arguments

Argument      |Description
------------- |----------------
`df`     |     is the input data.frame
`val_to_stop`     |     is the vector containing the values to stop
`index_rc`     |     is the value for the jump (default set to NA so default will be first case)
`included`     |     is if the values to stop has to be also returned in the vectors (defaultn set to "yes")


# `diff_xlsx`

diff_xlsx


## Description

Allow to see the difference between two datasets and output it into an xlsx file. If the dimensions of the new datasets are bigger than the old one, only the matching cells will be compared, if the dimensions of the new one are lower than the old one, there will be an error.


## Usage

```r
diff_xlsx(
  file_,
  sht,
  v_old_begin,
  v_old_end,
  v_new_begin,
  v_new_end,
  df2 = NA,
  overwrite = T,
  color_ = "red",
  pattern = "",
  output = "out.xlsx",
  new_val = T,
  pattern_only = T
)
```


## Arguments

Argument      |Description
------------- |----------------
`file_`     |     is the file where the data is
`sht`     |     is the sheet where the data is
`v_old_begin`     |     is a vector containing the coordinates (row, column) where the data to be compared starts
`v_old_end`     |     is the same but for its end
`v_new_begin`     |     is the coordinates where the comparator data starts
`v_new_end`     |     is the same but for its end If the dimensions of the new datasets are bigger than the old one, only the matching cells will be compared, if the dimensions of the new one are lower than the old one, there will be an error.
`df2`     |     is optional, if the comparator dataset is directly a dataframe
`overwrite`     |     allow to overwrite differences is (set to T by default)
`color_`     |     is the color the differences will be outputed
`pattern`     |     is the pattern that will be added to the differences if overwritten is set to TRUE
`output`     |     is the name of the outputed xlsx (can be set to NA if no output)
`new_val`     |     if overwrite is TRUE, then the differences will be overwritten by the comparator data
`pattern_only`     |     will cover differences by pattern if overwritten is set to TRUE


# `extrm_dates`

extrm_dates


## Description

Allow to find the minimum or the maximum of a date in a vector. The format of dates is Year/Month/Day.


## Usage

```r
extrm_dates(inpt_l, extrm = "min", sep = "-")
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_l`     |     is the input vector
`extrm`     |     is either "min" or "max", defaults to "min"
`sep`     |     is the separator of the dates, defaults to "-"


# `file_rec`

file_rec


## Description

Allow to get all the files recursively from a path according to an end and start depth value. If you want to have an other version of this function that uses a more sophisticated algorythm (which can be faster), check file_rec2. Depth example: if i have dir/dir2/dir3, dir/dir2b/dir3b, i have a depth equal to 3


## Usage

```r
file_rec(xmax, xmin = 1, pathc = ".")
```


## Arguments

Argument      |Description
------------- |----------------
`xmax`     |     is the end depth value
`xmin`     |     is the start depth value
`pathc`     |     is the reference path


# `file_rec2`

file_rec2


## Description

Allow to find the directories and the subdirectories with a specified end and start depth value from a path. This function might be more powerfull than file_rec because it uses a custom algorythm that does not nee to perform a full recursive search before tuning it to only find the directories with a good value of depth. Depth example: if i have dir/dir2/dir3, dir/dir2b/dir3b, i have a depth equal to 3


## Usage

```r
file_rec2(xmax, xmin = 1, pathc = ".")
```


## Arguments

Argument      |Description
------------- |----------------
`xmax`     |     is the depth value
`xmin`     |     is the minimum value of depth
`pathc`     |     is the reference path, from which depth value is equal to 1


# `fillr`

fillr


## Description

Allow to fill a vector by the last element n times


## Usage

```r
fillr(inpt_v, ptrn_fill = "...\\d")
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_v`     |     is the input vector
`ptrn_fill`     |     is the pattern used to detect where the function has to fill the vector by the last element n times. It defaults to "...\d" where "\d" is the regex for an int value. So this paramater has to have "\d" which designates n.


## Examples

```r
fillr(c("a", "b", "...3", "c"))
```


# `format_date`

format_date


## Description

Allow to convert xx-month-xxxx date type to xx-xx-xxxx


## Usage

```r
format_date(f_dialect, sentc, sep_in = "-", sep_out = "-")
```


## Arguments

Argument      |Description
------------- |----------------
`f_dialect`     |     are the months from the language of which the month come
`sentc`     |     is the date to convert
`sep_in`     |     is the separator of the dat input (default is "-")
`sep_out`     |     is the separator of the converted date (default is "-")


# `geo_min`

geo_min


## Description

Return a dataframe containing the nearest geographical points (row) according to established geographical points (column).


## Usage

```r
geo_min(inpt_df, established_df)
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_df`     |     is the input dataframe of the set of geographical points to be classified, its firts column is for latitude, the second for the longitude and the third, if exists, is for the altitude. Each point is one row.
`established_df`     |     is the dataframe containing the coordiantes of the established geographical points


## Examples

```r
in_ <- data.frame(c(11, 33, 55), c(113, -143, 167))

in2_ <- data.frame(c(12, 55), c(115, 165))

print(geo_min(inpt_df=in_, established_df=in2_))

in_ <- data.frame(c(51, 23, 55), c(113, -143, 167), c(6, 5, 1))

in2_ <- data.frame(c(12, 55), c(115, 165), c(2, 5))

geo_min(inpt_df=in_, established_df=in2_)
```


# `get_rec`

get_rec


## Description

Allow to get the value of directorie depth from a path.


## Usage

```r
get_rec(pathc = ".")
```


## Arguments

Argument      |Description
------------- |----------------
`pathc`     |     is the reference path example: if i have dir/dir2/dir3, dir/dir2b/dir3b, i have a depth equal to 3


# `globe`

globe


## Description

Allow to calculate the distances between a set of geographical points and another established geographical point. If the altitude is not filled, so the result returned won't take in count the altitude.


## Usage

```r
globe(lat_f, long_f, alt_f = NA, lat_n, long_n, alt_n = NA)
```


## Arguments

Argument      |Description
------------- |----------------
`lat_f`     |     is the latitude of the established geographical point
`long_f`     |     is the longitude of the established geographical point
`alt_f`     |     is the altitude of the established geographical point, defaults to NA
`lat_n`     |     is a vector containing the latitude of the set of points
`long_n`     |     is a vector containing the longitude of the set of points
`alt_n`     |     is a vector containing the altitude of the set of points, defaults to NA


## Examples

```r
globe(lat_f=23, long_f=112, alt_f=NA, lat_n=c(2, 82), long_n=c(165, -55), alt_n=NA)
```


# `groupr_df`

groupr_df


## Description

Allow to create groups from a dataframe. Indeed, you can create conditions that lead to a flag value for each cell of the input dataframeaccording to the cell value. This function is based on see_df and nestr_df2 functions.


## Usage

```r
groupr_df(inpt_df, condition_lst, val_lst, conjunction_lst, rtn_val_pos = c())
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_df`     |     is the input dataframe
`condition_lst`     |     is a list containing all the condition as a vector for each group
`val_lst`     |     is a list containing all the values associated with condition_lst as a vector for each group
`conjunction_lst`     |     is a list containing all the conjunctions associated with condition_lst and val_lst as a vector for each group
`rtn_val_pos`     |     is a vector containing all the group flag value like this ex: c("flag1", "flag2", "flag3")


## Examples

```r
interactive()
df1 <- data.frame(c(1, 2, 1), c(45, 22, 88), c(44, 88, 33))

val_lst <- list(list(c(1), c(1)), list(c(2)), list(c(44)))

condition_lst <- list(c(">", "<"), c("%%"), c("=="))

conjunction_lst <- list(c("|"), c(), c())

rtn_val_pos <- c("+", "+", "+")

groupr_df(inpt_df=df1, val_lst=val_lst, condition_lst=condition_lst,
conjunction_lst=conjunction_lst, rtn_val_pos=rtn_val_pos)
```


# `insert_df`

insert_df


## Description

Allow to insert dataframe into another dataframe according to coordinates (row, column) from the dataframe that will be inserted


## Usage

```r
insert_df(df_in, df_ins, ins_loc)
```


## Arguments

Argument      |Description
------------- |----------------
`df_in`     |     is the dataframe that will be inserted
`df_ins`     |     is the dataset to be inserted
`ins_loc`     |     is a vector containg two parameters (row, column) of the begining for the insertion


# `letter_to_nb`

letter_to_nb


## Description

Allow to get the number of a spreadsheet based column by the letter ex: AAA = 703


## Usage

```r
letter_to_nb(letter)
```


## Arguments

Argument      |Description
------------- |----------------
`letter`     |     is the letter (name of the column)


# `list_files`

list_files


## Description

A list.files() based function addressing the need of listing the files with extension a or or extension b ...


## Usage

```r
list_files(patternc, pathc = ".")
```


## Arguments

Argument      |Description
------------- |----------------
`patternc`     |     is a vector containing all the exensions you want
`pathc`     |     is the path, can be a vector of multiple path because list.files() supports it.


# `match_n`

match_n


## Description

Allow to get the indexes for the nth occurence of a value in a vector. Example: c(1, 2, 3, 1, 2), the first occurence of 1 and 2 is at index 1 and 2 respectively, but the second occurence is respectively at the 4th and 5th index.


## Usage

```r
match_n(vec, mc, n = 1, wnb = "#####")
```


## Arguments

Argument      |Description
------------- |----------------
`vec`     |     is th input vector
`mc`     |     is a vector containing the values you want to get the index for the nth occurence in vec
`n`     |     is the value of the occurence
`wnb`     |     is a string you are sure is not in mc


# `match_n2`

match_n2


## Description

Allow to get the indexes for the nth occurence of a value in a vector. Example: c(1, 2, 3, 1, 2), the first occurence of 1 and 2 is at index 1 and 2 respectively, but the second occurence is respectively at the 4th and 5th index.


## Usage

```r
match_n2(vec, mc, n, wnb = "#####")
```


## Arguments

Argument      |Description
------------- |----------------
`vec`     |     is th einput vector
`mc`     |     is a vector containing the values you want to get the index for the nth occurence in vec
`n`     |     is a vector containing the occurences for each value in mc so if i have mc <- c(3, 27) and n <- c(1, 2), i want the first occurence for 3 and the second for 27 in vec. If the length of n is inferior of the length of mc, m will extend with its last value as new arguments. It means that if mc <- c(3, 27) but n <- c(1) so n will extend to c(1, 1), so we will get the first occurence of 3 and 27 in vec.
`wnb`     |     is a string you are sure is not in mc


# `multitud`

multitud


## Description

From a list containing vectors allow to generate a vector following this rule:
 list(c("a", "b"), c("1", "2"), c("A", "Z", "E")) --> c("a1A", "a2A", "b1A", "b2A", "a1Z", ...)


## Usage

```r
multitud(l, sep_ = "")
```


## Arguments

Argument      |Description
------------- |----------------
`l`     |     is the list
`sep_`     |     is the separator between elements (default is set to "" as you see in the example)


# `nb_to_letter`

nb_to_letter


## Description

Allow to get the letter of a spreadsheet based column by the number ex: 703 = AAA


## Usage

```r
nb_to_letter(x)
```


## Arguments

Argument      |Description
------------- |----------------
`x`     |     is the number of the column


# `nestr_df1`

nestr_df1


## Description

Allow to write a value (1a) to a dataframe (1b) to its cells that have the same coordinates (row and column) than the cells whose value is equal to a another special value (2a), from another another dataframe (2b). The value (1a) depends of the cell  value coordinates of the third dataframe (3b). If a cell coordinates (1c) of the first dataframe (1b) do not correspond to the coordinates of a good returning cell value (2a) from the dataframe (2b), so this cell (1c) can have its value changed to the same cell coordinates value (3a) of a third dataframe (4b), if (4b) is not det to NA.


## Usage

```r
nestr_df1(inptf_df, inptt_pos_df, inpt_neg_df = NA, nestr_df, yes_val = T)
```


## Arguments

Argument      |Description
------------- |----------------
`inptf_df`     |     is the input dataframe (1b)
`inptt_pos_df`     |     is the dataframe (2b) that corresponds to the (1a) values
`inpt_neg_df`     |     is the dataframe (4b) that has the (3a) values, defaults to NA
`nestr_df`     |     is the dataframe (2b) that has the special value (2a)
`yes_val`     |     is the special value (2a)


## Examples

```r
nestr_df1(inpt_df=data.fame(c(1, 2, 1), c(1, 5, 7)),
inptt_pos_df=data.frame(c(4, 4, 3), c(2, 1, 2)),
inptt_pos_df=data.frame(c(44, 44, 33), c(12, 12, 12)),
nestr_df=data.frame(c(T, F, T), c(F, F, T), yes_val=T))
```


# `nestr_df2`

nestr_df2


## Description

Allow to write a special value (1a) in the cells of a dataframe (1b) that correspond (row and column) to whose of another dataframe (2b) that return another special value (2a). The cells whose coordinates do not match the coordinates of the dataframe (2b), another special value can be written (3a) if not set to NA.


## Usage

```r
nestr_df2(inptf_df, rtn_pos, rtn_neg = NA, nestr_df, yes_val = T)
```


## Arguments

Argument      |Description
------------- |----------------
`inptf_df`     |     is the input dataframe (1b)
`rtn_pos`     |     is the special value (1a)
`rtn_neg`     |     is the special value (3a)
`nestr_df`     |     is the dataframe (2b)
`yes_val`     |     is the special value (2a)


## Examples

```r
nestr_df2(inpt_df=data.fame(c(1, 2, 1), c(1, 5, 7)), rtn_pos="yes",
rtn_neg="no", nestr_df=data.frame(c(T, F, T), c(F, F, T), yes_val=T))
```


# `pattern_generator`

pattern_generator


## Description

Allow to create patterns which have a part that is varying randomly each time.


## Usage

```r
pattern_generator(base_, from_, nb, hmn = 1, after = 1, sep = "")
```


## Arguments

Argument      |Description
------------- |----------------
`base_`     |     is the pattern that will be kept
`from_`     |     is the vector from which the elements of the random part will be generated
`nb`     |     is the number of random pattern chosen for the varying part
`hmn`     |     is how many of varying pattern from the same base will be created
`after`     |     is set to 1 by default, it means that the varying part will be after the fixed part, set to 0 if you want the varying part to be before
`sep`     |     is the separator between all patterns in the returned value


# `pattern_gettr`

pattern_gettr


## Description

Search for pattern(s) contained in a vector in another vector and return a list containing matched one (first index) and their position (second index) according to these rules:
 First case: Search for patterns strictly, it means that the searched pattern(s) will be matched only if the patterns containded in the vector that is beeing explored by the function are present like this c("pattern_searched", "other", ..., "pattern_searched") and not as c("other_thing pattern_searched other_thing", "other", ..., "pattern_searched other_thing")
 Second case: It is the opposite to the first case, it means that if the pattern is partially present like in the first position and the last, it will be considered like a matched pattern


## Usage

```r
pattern_gettr(
  word_,
  vct,
  occ = c(1),
  strict,
  btwn,
  all_in_word = "yes",
  notatall = "###"
)
```


## Arguments

Argument      |Description
------------- |----------------
`word_`     |     is the vector containing the patterns
`vct`     |     is the vector being searched for patterns
`occ`     |     a vector containing the occurence of the pattern in word_ to be matched in the vector being searched, if the occurence is 2 for the nth pattern in word_ and only one occurence is found in vct so no pattern will be matched, put "forever" to no longer depend on the occurence for the associated pattern
`strict`     |     a vector containing the "strict" condition for each nth vector in word_ ("strict" is the string to activate this option)
`btwn`     |     is a vector containing the condition ("yes" to activate this option) meaning that if "yes", all elements between two matched patern in vct will be returned , so the patterns you enter in word_ have to be in the order you think it will appear in vct
`all_in_word`     |     is a value (default set to "yes", "no" to activate this option) that, if activated, won't authorized a previous matched pattern to be matched again
`notatall`     |     is a string that you are sure is not present in vct REGEX can also be used as pattern


# `pattern_tuning`

pattern_tuning


## Description

Allow to tune a pattern very precisely and output a vector containing its variations n times.


## Usage

```r
pattern_tuning(pattrn, spe_nb, spe_l, exclude_type, hmn = 1, rg = c(0, 0))
```


## Arguments

Argument      |Description
------------- |----------------
`pattrn`     |     is the character that will be tuned
`spe_nb`     |     is the number of new character that will be replaced
`spe_l`     |     is the source vector from which the new characters will replace old ones
`exclude_type`     |     is character that won't be replaced
`hmn`     |     is how many output the function will return
`rg`     |     is a vector with two parameters (index of the first letter that will be replaced, index of the last letter that will be replaced) default is set to all the letters from the source pattern


# `ptrn_switchr`

ptrn_switchr


## Description

Allow to switch, copy pattern for each element in a vector. Here a pattern is the values that are separated by a same separator. Example: "xx-xxx-xx" or "xx/xx/xxxx". The xx like values can be swicthed or copied from whatever index to whatever index. Here, the index is like this 1-2-3 etcetera, it is relative of the separator.


## Usage

```r
ptrn_switchr(inpt_l, f_idx_l = c(), t_idx_l = c(), sep = "-", default_val = NA)
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_l`     |     is the input vector
`f_idx_l`     |     is a vector containing the indexes of the pattern you want to be altered.
`t_idx_l`     |     is a vector containing the indexes to which the indexes in f_idx_l are related.
`sep`     |     is the separator, defaults to "-"
`default_val`     |     is the default value , if not set to NA, of the pattern at the indexes in f_idx_l. If it is not set to NA, you do not need to fill t_idx_l because this is the vector containing the indexes of the patterns that will be set as new values relatively to the indexes in f_idx_l. Defaults to NA.


## Examples

```r
ptrn_switchr(inpt_l=c("2022-01-11", "2022-01-14", "2022-01-21",
"2022-01-01"), f_idx_l=c(1, 2, 3), t_idx_l=c(3, 2, 1))
ptrn_switchr(inpt_l=c("2022-01-11", "2022-01-14", "2022-01-21",
"2022-01-01"), f_idx_l=c(1), default_val="ee")
```


# `ptrn_twkr`

ptrn_twkr


## Description

Allow to modify the pattern length of element in a vector according to arguments. What is here defined as a pattern is something like this xx-xx-xx or xx/xx/xxx... So it is defined by the separator


## Usage

```r
ptrn_twkr(inpt_l, depth = "max", sep = "-", default_val = "0", add_sep = T)
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_l`     |     is the input vector
`depth`     |     is the number (numeric) of separator it will keep as a result. To keep the number of separator of the element that has the minimum amount of separator do depth="min" and depth="max" (character) for the opposite. This value defaults to "max".
`sep`     |     is the separator of the pattern, defaults to "-"
`default_val`     |     is the default val that will be placed between the separator, defaults to "00"
`add_sep`     |     defaults to TRUE. If set to FALSE, it will remove the separator for the patterns that are included in the interval between the depth amount of separator and the actual number of separator of the element.


## Examples

```r
v <- c("2012-06-22", "2012-06-23", "2022-09-12", "2022")
ptrn_twkr(inpt_l=v, depth="max", sep="-", default_val="00", add_sep=T)
```


# `see_df`

see_df


## Description

Allow to return a datafame with special value cells (ex: TRUE) where the condition entered are respected and another special value cell (ex: FALSE) where these are not


## Usage

```r
see_df(df, condition_l, val_l, conjunction_l = c(), rt_val = T, f_val = F)
```


## Arguments

Argument      |Description
------------- |----------------
`df`     |     is the input dataframe
`condition_l`     |     is the vector of the possible conditions ("==", ">", "<", "!=", "%%") (equal, greater than, lower than, not equal to, is divisible by), you can put the same condition n times.
`val_l`     |     is the list of vectors containing the values related to condition_l (so the vector of values has to be placed in the same order)
`conjunction_l`     |     contains the | or & conjunctions, so if the length of condition_l is equal to 3, there will be 2 conjunctions. If the length of conjunction_l is inferior to the length of condition_l minus 1, conjunction_l will match its goal length value with its last argument as the last arguments. For example, c("&", "|", "&") with a goal length value of 5 --> c("&", "|", "&", "&", "&")
`rt_val`     |     is a special value cell returned when the conditions are respected
`f_val`     |     is a special value cell returned when the conditions are not respected


## Details

This function will return an error if number only comparative conditions are given in addition to having character values in the input dataframe.


## Examples

```r
see_df(df, c("%%", "=="), list(c(2, 11), c(3)), list("|")
#will return all the values that are divisible by 2 and 11
#and all the values that are equal to 3 from the dataframe
```


# `see_file`

see_file


## Description

Allow to get the filename or its extension


## Usage

```r
see_file(string_, index_ext = 1, ext = T)
```


## Arguments

Argument      |Description
------------- |----------------
`string_`     |     is the input string
`index_ext`     |     is the occurence of the dot that separates the filename and its extension
`ext`     |     is a boolean that if set to TRUE, will return the file extension and if set to FALSE, will return filename


# `see_idx`

see_idx


## Description

Allow to find the indexes of the elements of the first vector in the second. If the element(s) is not found, the element returned at the same index will be "FALSE".


## Usage

```r
see_idx(v1, v2, exclude_val = "######", no_more = F)
```


## Arguments

Argument      |Description
------------- |----------------
`v1`     |     is the first vector
`v2`     |     is the second vector
`exclude_val`     |     is a value you know is not present in the 2 vectors
`no_more`     |     is a boolean that, if set to TRUE, will remove all the first found value in the second vector after those has been found. It defaults to FALSE.


# `see_inside`

see_inside


## Description

Return a list containing all the column of the files in the current directory with a chosen file extension and its associated file and sheet if xlsx. For example if i have 2 files "out.csv" with 2 columns and "out.xlsx" with 1 column for its first sheet and 2 for its second one, the return will look like this:
 c(column_1, column_2, column_3, column_4, column_5, unique_separator, "1-2-out.csv", "3-3-sheet_1-out.xlsx", 4-5-sheet_2-out.xlsx)


## Usage

```r
see_inside(pattern_, path_ = ".", sep_ = c(","), unique_sep = "#####", rec = F)
```


## Arguments

Argument      |Description
------------- |----------------
`pattern_`     |     is a vector containin the file extension of the spreadsheets ("xlsx", "csv"...)
`path_`     |     is the path where are located the files
`sep_`     |     is a vector containing the separator for each csv type file in order following the operating system file order, if the vector does not match the number of the csv files found, it will assume the separator for the rest of the files is the same as the last csv file found. It means that if you know the separator is the same for all the csv type files, you just have to put the separator once in the vector.
`unique_sep`     |     is a pattern that you know will never be in your input files
`rec`     |     alloaw to get files recursively If x is the return value, to see all the files name, position of the columns and possible sheet name associanted with, do the following:


## Examples

```r
print(x[(grep(unique_sep, x)[1]+1):length(x)]).
If you just want to see the columns do the following:
print(x[1:(grep(unique_sep, x) - 1)])
```


# `unique_pos`

unique_pos


## Description

Allow to find indexes of the unique values from a vector.


## Usage

```r
unique_pos(vec)
```


## Arguments

Argument      |Description
------------- |----------------
`vec`     |     is the input vector


# `until_stnl`

until_stnl


## Description

Maxes a vector to a chosen length
 ex: if i want my vector c(1, 2) to be 5 of length this function will return me: c(1, 2, 1, 2, 1)


## Usage

```r
until_stnl(vec1, goal)
```


## Arguments

Argument      |Description
------------- |----------------
`vec1`     |     is the input vector
`goal`     |     is the length to reach


# `v_to_df`

v_to_df


## Description

Allow to convert a vector to a dataframe according to a separator.


## Usage

```r
v_to_df(inpt_v, sep = "-")
```


## Arguments

Argument      |Description
------------- |----------------
`inpt_v`     |     is the input vector
`sep`     |     is the separator used to seprate the columns


## Examples

```r
v <- c("aa-yy-uu", "zz-gg-hhh", "zz-gg-hhh", "zz-gg-hhh")
v_to_df(inpt_v=v, sep="-")
```


# `val_replacer`

val_replacer


## Description

Allow to replace value from dataframe to another one.


## Usage

```r
val_replacer(df, val_replaced, val_replacor = T, df_rpt = NA)
```


## Arguments

Argument      |Description
------------- |----------------
`df`     |     is the input dataframe
`val_replaced`     |     is a vector of the value(s) to be replaced
`val_replacor`     |     is the value that will replace val_replaced
`df_rpt`     |     is the replacement matrix and has to be the same dimension as df. Only the indexes that are equal to TRUE will be authorized indexes for the values to be replaced in the input matrix


# `vec_in_df`

vec_in_df


## Description

Allow to see if vectors are present in a dataframe
 ex: 1, 2, 1
 3, 4, 1
 1, 5, 8
 the vector c(4, 1) with the coefficient 1 and the start position at the second column is containded in the dataframe


## Usage

```r
vec_in_df(df_, vec_l, coeff_, strt_l, distinct = "NA")
```


## Arguments

Argument      |Description
------------- |----------------
`df_`     |     is the input dataframe
`vec_l`     |     is a list the vectors
`coeff_`     |     is the related coefficient of the vector
`strt_l`     |     is a vector containing the start position for each vector
`distinct`     |     is a value you are sure is not in df_, defaults to "NA"


# `vlookup_df`

vlookup_df


## Description

Alow to perform a vlookup on a dataframe


## Usage

```r
vlookup_df(df, v_id, col_id = 1, included_col_id = "yes")
```


## Arguments

Argument      |Description
------------- |----------------
`df`     |     is the input dataframe
`v_id`     |     is a vector containing the ids
`col_id`     |     is the column that contains the ids (default is equal to 1)
`included_col_id`     |     is if the result should return the col_id (default set to yes)


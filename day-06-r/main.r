con = file("input.txt", "r")
any_yes   <- list()
any_count <- 0
all_yes   <- NULL
all_count <- 0

chars <- function(string) {
  return(strsplit(string,'')[[1]])
}

get_unique <- function(lst) {
  return(lst[!duplicated(lst)])
}

repeat {
  answers = readLines(con, n = 1, warn=FALSE)

  if (nchar(answers) == 0 || length(answers) == 0) {
    # new group / EOF
    # add old group values to the count
    any_count <- any_count + length(get_unique(any_yes))
    any_yes <- list()
    all_count <- all_count + length(all_yes)
    all_yes <- NULL

    if (length(answers) == 0) {
      # end of file reached
      break
    }
  }
  else {
    # union
    any_yes <- append(any_yes, chars(answers))

    if (is.null(all_yes)) {
      # new group: don't intersect yet or we'll get the empty list
      all_yes <- chars(answers)
      # remove potential duplicates (not sure if possible)
      all_yes <- get_unique(all_yes)
    }
    else {
      # intersection
      all_yes <- intersect(all_yes, chars(answers))
    }
  }
}

cat('PART 1', any_count, '\n')
cat('PART 2', all_count, '\n')

close(con)
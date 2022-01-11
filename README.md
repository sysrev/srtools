# srtools
A collection of tools for sysrev managed review. Install with:

```r
library(devtools)
install_github("sysrev/srtools")
```

## getting open access documents

```r
library(tidyverse)
library(purrr)
library(pbapply)

# get DOI from sysrev.com/p/39523 - Environmental Impacts Of Smart Local ...
doi = rsr::get_articles(39523) |> slice(1:10) |>           # delete slice for more files
  mutate(ern   = lapply(sr.record,srtools::en.ern)) |>     # ERN is an endnote id
  unnest(ern) |> filter(srtools::is_doi(ern)) |> pull(ern) # get DOI ERN
# get open access data from https://docs.ropensci.org/roadoi/ 
email = "you@somewhere.com"
oa.tb = roadoi::oadoi_fetch(dois=doi,email=email,.flatten = T,.progress="text")

# download some files (slowly and politely)
dir     = here::here("tmp/pdf") # change to location you want
slow.dl = partial(download.file,quiet=T) |> slowly(rate_delay(0.1)) |> safely()
results = oa.tb |> filter(!is.na(url_for_pdf)) |> 
  mutate(fname = here::here(dir,glue::glue('{gsub("/",".",doi)}.pdf')))   |>
  mutate(dl    = pblapply(1:n(),\(i){slow.dl(url_for_pdf[i],fname[i])}))  |>
  mutate(error = map_chr(dl,~as.character(pluck(.,"error",.default=NA)))) |>
  select(doi,fname,error)

# check if your files arrived
list.files(dir)
```

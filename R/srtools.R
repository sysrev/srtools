#' download pdfs
#' @param dois digital object identifiers
#' @param dir the directory to store pdfs
#' @importFrom rlang .data
#' @return
#' @export
#' @examples
#' download.pdfs(c("10.1186/s12864-016-2566-9","10.1103/physreve.88.012814"))
download_pdfs = function(dois,email,dir=tempdir()){
  chunks = split(dois, ceiling(seq_along(dois)/100))

  get.pdf.urls = purrr::slowly(\(ids){
    roadoi::oadoi_fetch(dois=ids,email=email) |> tidyr::unnest(.data$best_oa_location) |> dplyr::select(.data$doi,.data$url_for_pdf) },
    rate = purrr::rate_delay(1))

  tb    = dplyr::bind_rows(pbapply::pblapply(chunks,get.pdf.urls)) |> dplyr::mutate(file=glue::glue("{basename(url_for_pdf)}.pdf"))
  res   = download.file(tb$url_for_pdf,destfile = glue::glue("{dir}/{tb$file}"))
  files = list.files(dir)

  tb |> dplyr::mutate(downloaded = .data$file %in% files)
}


#' en_ern
#' @description
#' get `electronic-resource-num` from endnote records
#' @importFrom xml2 as_list read_xml
#' @param xmlrecord a <record>...</record> entry from xml
#' @return tibble with <ern> column
#' @export
en.ern = function(xmlrecord){
  xml2::read_xml(xmlrecord) |>
    xml2::xml_find_all("electronic-resource-num") |>
    xml2::xml_text()
}

#' check if a string is a DOI
#' @description
#' lots of work to do here
#' @param string the string to check
#' @return true or false
#' @export
is_doi = function(string){ grepl("^10.\\d{4,9}/[-._;()/:A-Z0-9]+$",string,ignore.case = T) }

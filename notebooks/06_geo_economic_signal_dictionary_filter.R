library(quanteda)
library(dplyr)

data <- read.csv("data/temp/economic_chunks.csv")

#View(data)

corp <- corpus(data)

toks <- corp |>
  tokens(
    remove_punct = TRUE, 
    remove_numbers = TRUE
  ) |>
  tokens_remove(pattern = stopwords("en")) |>
  tokens_compound(
    pattern = phrase(compound_terms)
  ) 

neoliberal_special <- tolower(c(
  "Interdependence", "mutual economic prosperity", 
  "General Agreement on Tariffs and Trade",
  "the United Nations Conference on Trade and Development",
  "GATT", "World Bank", "UNCTAD", "Economic and Social Council",
  "comparative advantage", "FTA", "neo-liberal", "neo liberal",
  "neo liberalism", "neo-liberalism", "mutual benefit",
  "level playing field", "WTO", "World Trade Organization",
  "Free Trade Agreement"
))

geo_economic_special <- tolower(c(
  "asymmetry of trade", "unjust world economic system", 
  "autarky", "economic nationalism", "protectionism",
  "protectionist", "onshoring", "re-shoring", "friend-shoring"
))

toks_lower <- tokens_tolower(toks)

neo_special_hit <- dfm(toks_lower) |>
  dfm_lookup(dictionary = dictionary(list(neoliberal_special = neoliberal_special)))|>
  convert(to = "matrix")

geo_special_hit <- dfm(toks_lower) |>
  dfm_lookup(dictionary = dictionary(list(geo_special = geo_economic_special))) |>
  convert(to = "matrix")

dfm_all <- dfm(toks_lower)

"free_trade" %in% featnames(dfm_all)

neo_geo_dfm <- dfm_lookup(dfm_all, dictionary = neo_geo_dict)

mat <- convert(neo_geo_dfm, to = "matrix")
mat[is.na(mat)] <- 0

final_label <- sapply(1:nrow(mat), function(i) {
  
  # check special keywords first
  if (neo_special_hit[i, 1] > 0) {
    return("neo-liberal")
  }
  if (geo_special_hit[i, 1] > 0) {
    return("geo-economic")
  }
  
  # fallback to original logic
  neo <- mat[i, "neoliberal"]
  geo <- mat[i, "geo_economic"]
  
  if (is.na(neo)) neo <- 0
  if (is.na(geo)) geo <- 0
  
  if (neo < 2 && geo < 2) {
    "irrelevant"
  } else if (neo > geo) {
    "neo-liberal"
  } else if (geo > neo) {
    "geo-economic"
  } else {
    "irrelevant"
  }
})

data$final_label <- final_label

data_final = data[final_label != "irrelevant", ]
nrow(data_final)
View(data_final)

nrow(data_final[final_label == "geo-economic", ])
nrow(data_final[final_label == "neo-liberal", ])

write.csv(data, "data/temp/neo_geo_irrelevant_classfied.csv")

write.csv(data_final, "data/temp/neo_geo_classfied.csv")



library(stringr)

# patterns
neo_pattern <- str_c(neoliberal_special, collapse = "|")
geo_pattern <- str_c(geo_economic_special, collapse = "|")

# create dataframe
hits_df <- data %>%
  mutate(
    neo_hit = neo_special_hit[, 1] > 0,
    geo_hit = geo_special_hit[, 1] > 0
  ) %>%
  filter(neo_hit | geo_hit) %>%
  mutate(
    label = case_when(
      neo_hit ~ "neo-liberal",
      geo_hit ~ "geo-economic"
    ),
    
    matched_word = case_when(
      neo_hit ~ str_extract(text, regex(neo_pattern, ignore_case = TRUE)),
      geo_hit ~ str_extract(text, regex(geo_pattern, ignore_case = TRUE))
    )
  ) %>%
  select(text, label, matched_word)

View(hits_df)

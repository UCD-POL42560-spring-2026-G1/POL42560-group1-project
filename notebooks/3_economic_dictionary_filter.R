library(quanteda)
library(dplyr)


data_1 <- read.csv("data/temp/data_chunks.csv")
data_2 <- read.csv("data/temp/ungdc_1946_1991_chunks_output.csv")

#View(data_1)
#View(data_2)

data_1 <- data_1 |>
  select(doc_id, iso_code, year, text)

data_full <- bind_rows(data_2, data_1)
#View(data_full)

corp <- corpus(data_full)

toks <- corp |>
  tokens(
    remove_punct = TRUE, 
    remove_numbers = TRUE
  ) |>
  tokens_remove(pattern = stopwords("en")) |>
  tokens_compound(
    pattern = phrase(compound_terms)
  ) 

dfm_all <- dfm(toks)

"free_trade" %in% featnames(dfm_all)

econ_dfm <- dfm_lookup(dfm_all, dictionary = econ_dict)

econ_docs_3 <- as.numeric(econ_dfm[, "economic"]) > 2
corp_3 <- corpus_subset(corp, econ_docs_3)
corp_3

df_3 <- convert(corp_3, to = "data.frame")

View(df_3)

write.csv(df_3, "data/temp/economic_chunks.csv", row.names = FALSE)

df_all <- convert(corp, to = "data.frame")

df_all$econ_label <- "non-econ"
df_all$econ_label[econ_docs_3] <- "economic"

write.csv(df_all, "data/temp/all_data_with_econ_labels.csv")


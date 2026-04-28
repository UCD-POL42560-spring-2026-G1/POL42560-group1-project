library(dplyr)
library(yardstick)


df<- read.csv("data/temp/final_gt_200_rows.csv")

df_predicted <- read.csv("data/temp/neo_geo_irrelevant_classfied.csv")

nrow(df)

nrow(df_predicted)

df_predicted <- df_predicted %>%
  rename(pred_label = final_label)

df <- df |>
  right_join(df_predicted, by = "doc_id") 

#View(df)

df<- df%>%
  rename(gold_label = rethoric_label)



table(predicted = df$pred_label, True = df$gold_label)

df <- df |>
  mutate(sum_label_pred = case_when(
    pred_label %in% c("geo-economic", "neo-liberal") ~ "global",
    TRUE ~ "not global"
  ))

df <- df |>
  mutate(sum_label_true = case_when(
    gold_label %in% c("geo-economic", "neo-liberal") ~ "global",
    TRUE ~ "not global"
  ))

df

table(predicted = df$sum_label_pred, True = df$sum_label_true)


df <- read.csv("data/temp/final_gt_200_rows.csv")
df_predicted <- read.csv("data/temp/neo_geo_irrelevant_classfied.csv")

df_predicted <- df_predicted %>%
  rename(pred_label = final_label)

df <- df %>%
  left_join(df_predicted, by = "doc_id") %>%
  rename(gold_label = rethoric_label)

df <- df %>%
  mutate(
    sum_label_pred = case_when(
      pred_label %in% c("geo-economic", "neo-liberal") ~ "global",
      TRUE ~ "not global"
    ),
    sum_label_true = case_when(
      gold_label %in% c("geo-economic", "neo-liberal") ~ "global",
      TRUE ~ "not global"
    )
  )

table(predicted = df$sum_label_pred, True = df$sum_label_true)

df_clean <- df %>%
  filter(!is.na(sum_label_pred), !is.na(sum_label_true))

accuracy <- mean(df_clean$sum_label_pred == df_clean$sum_label_true)

precision_global <- sum(df_clean$sum_label_pred == "global" &
                        df_clean$sum_label_true == "global") /
                    sum(df_clean$sum_label_pred == "global")

accuracy
precision_global

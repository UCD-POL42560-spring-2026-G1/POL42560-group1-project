library(dplyr)
library(yardstick)


df<- read.csv("data/temp/econ_final_annotations.csv")

df_predicted <- read.csv("data/temp/all_data_with_econ_labels.csv")

df_predicted <- df_predicted %>%
  rename(pred_label = econ_label)

#View(df_predicted)

df <- df |>
  inner_join(df_predicted, by = "doc_id") 

df<- df%>%
  rename(gold_label = econ_label)



table(predicted = df$pred_label, True = df$gold_label)

df$gold_label <- factor(df$gold_label)
df$pred_label <- factor(df$pred_label)

df %>%
  summarise(
    accuracy = accuracy_vec(gold_label, pred_label),
    precision = precision_vec(gold_label, pred_label, levels = c("economic", "non-econ")),
    recall = recall_vec(gold_label, pred_label, levels = c("economic", "non-econ")),
    f1 = f_meas_vec(gold_label, pred_label, levels = c("economic", "non-econ"))
  )


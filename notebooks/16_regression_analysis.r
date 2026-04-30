##############################################################################
# Wrangle and merge the data for regression analysis
# 1. Define the mapping and filtering dictionaries
# ==============================

# (A) Exclude: aggregate_codes
aggregate_codes <- c(
  "WB_EAP", "WB_ECA", "WB_LAC", "WB_MENAP", "WB_NA", "WB_SA", "WB_SSA",
  "OWID_WRL", "OWID_EU27", "OWID_HIC", "OWID_LIC", "OWID_LMC", "OWID_UMC"
)

# (B) Code to region(WB) mapping for the remaining countries
code_to_region <- c(
  # Middle East, North Africa, Afghanistan and Pakistan
  AFG = "Middle East, North Africa, Afghanistan and Pakistan",
  DZA = "Middle East, North Africa, Afghanistan and Pakistan",
  BHR = "Middle East, North Africa, Afghanistan and Pakistan",
  DJI = "Middle East, North Africa, Afghanistan and Pakistan",
  EGY = "Middle East, North Africa, Afghanistan and Pakistan",
  IRN = "Middle East, North Africa, Afghanistan and Pakistan",
  IRQ = "Middle East, North Africa, Afghanistan and Pakistan",
  ISR = "Middle East, North Africa, Afghanistan and Pakistan",
  JOR = "Middle East, North Africa, Afghanistan and Pakistan",
  KWT = "Middle East, North Africa, Afghanistan and Pakistan",
  LBN = "Middle East, North Africa, Afghanistan and Pakistan",
  LBY = "Middle East, North Africa, Afghanistan and Pakistan",
  MLT = "Middle East, North Africa, Afghanistan and Pakistan",
  MAR = "Middle East, North Africa, Afghanistan and Pakistan",
  OMN = "Middle East, North Africa, Afghanistan and Pakistan",
  PAK = "Middle East, North Africa, Afghanistan and Pakistan",
  QAT = "Middle East, North Africa, Afghanistan and Pakistan",
  SAU = "Middle East, North Africa, Afghanistan and Pakistan",
  SYR = "Middle East, North Africa, Afghanistan and Pakistan",
  TUN = "Middle East, North Africa, Afghanistan and Pakistan",
  ARE = "Middle East, North Africa, Afghanistan and Pakistan",
  PSE = "Middle East, North Africa, Afghanistan and Pakistan",
  YEM = "Middle East, North Africa, Afghanistan and Pakistan",
  
  # Europe and Central Asia
  ALB = "Europe and Central Asia", AND = "Europe and Central Asia", ARM = "Europe and Central Asia",
  AUT = "Europe and Central Asia", AZE = "Europe and Central Asia", BLR = "Europe and Central Asia",
  BEL = "Europe and Central Asia", BIH = "Europe and Central Asia", BGR = "Europe and Central Asia",
  HRV = "Europe and Central Asia", CYP = "Europe and Central Asia", CZE = "Europe and Central Asia",
  DNK = "Europe and Central Asia", EST = "Europe and Central Asia", FRO = "Europe and Central Asia",
  FIN = "Europe and Central Asia", FRA = "Europe and Central Asia", GEO = "Europe and Central Asia",
  DEU = "Europe and Central Asia", GIB = "Europe and Central Asia", GRC = "Europe and Central Asia",
  GRL = "Europe and Central Asia", HUN = "Europe and Central Asia", ISL = "Europe and Central Asia",
  IRL = "Europe and Central Asia", ITA = "Europe and Central Asia", KAZ = "Europe and Central Asia",
  KGZ = "Europe and Central Asia", LVA = "Europe and Central Asia", LTU = "Europe and Central Asia",
  LUX = "Europe and Central Asia", MDA = "Europe and Central Asia", MNE = "Europe and Central Asia",
  NLD = "Europe and Central Asia", MKD = "Europe and Central Asia", NOR = "Europe and Central Asia",
  POL = "Europe and Central Asia", PRT = "Europe and Central Asia", ROU = "Europe and Central Asia",
  RUS = "Europe and Central Asia", SRB = "Europe and Central Asia", SVK = "Europe and Central Asia",
  SVN = "Europe and Central Asia", ESP = "Europe and Central Asia", SWE = "Europe and Central Asia",
  CHE = "Europe and Central Asia", TJK = "Europe and Central Asia", TUR = "Europe and Central Asia",
  TKM = "Europe and Central Asia", UKR = "Europe and Central Asia", GBR = "Europe and Central Asia",
  UZB = "Europe and Central Asia", SMR = "Europe and Central Asia", OWID_KOS = "Europe and Central Asia",
  
  # East Asia and Pacific
  ASM = "East Asia and Pacific", AUS = "East Asia and Pacific", BRN = "East Asia and Pacific",
  KHM = "East Asia and Pacific", CHN = "East Asia and Pacific", FJI = "East Asia and Pacific",
  HKG = "East Asia and Pacific", IDN = "East Asia and Pacific", JPN = "East Asia and Pacific",
  KIR = "East Asia and Pacific", KOR = "East Asia and Pacific", LAO = "East Asia and Pacific",
  MAC = "East Asia and Pacific", MYS = "East Asia and Pacific", MHL = "East Asia and Pacific",
  FSM = "East Asia and Pacific", MNG = "East Asia and Pacific", NCL = "East Asia and Pacific",
  NZL = "East Asia and Pacific", MNP = "East Asia and Pacific", PLW = "East Asia and Pacific",
  PNG = "East Asia and Pacific", PHL = "East Asia and Pacific", SGP = "East Asia and Pacific",
  SLB = "East Asia and Pacific", WSM = "East Asia and Pacific", THA = "East Asia and Pacific",
  TLS = "East Asia and Pacific", TON = "East Asia and Pacific", VNM = "East Asia and Pacific",
  PYF = "East Asia and Pacific", VUT = "East Asia and Pacific", GUM = "East Asia and Pacific", NRU = "East Asia and Pacific",
  
  # Latin America and the Caribbean
  ATG = "Latin America and the Caribbean", ARG = "Latin America and the Caribbean", ABW = "Latin America and the Caribbean",
  BHS = "Latin America and the Caribbean", BLZ = "Latin America and the Caribbean", BOL = "Latin America and the Caribbean",
  BRA = "Latin America and the Caribbean", CYM = "Latin America and the Caribbean", CHL = "Latin America and the Caribbean",
  COL = "Latin America and the Caribbean", CRI = "Latin America and the Caribbean", CUB = "Latin America and the Caribbean",
  CUW = "Latin America and the Caribbean", DMA = "Latin America and the Caribbean", DOM = "Latin America and the Caribbean",
  ECU = "Latin America and the Caribbean", SLV = "Latin America and the Caribbean", GRD = "Latin America and the Caribbean",
  GTM = "Latin America and the Caribbean", GUY = "Latin America and the Caribbean", HTI = "Latin America and the Caribbean",
  HND = "Latin America and the Caribbean", JAM = "Latin America and the Caribbean", MEX = "Latin America and the Caribbean",
  NIC = "Latin America and the Caribbean", PAN = "Latin America and the Caribbean", PRY = "Latin America and the Caribbean",
  PER = "Latin America and the Caribbean", PRI = "Latin America and the Caribbean", VCT = "Latin America and the Caribbean",
  SUR = "Latin America and the Caribbean", TTO = "Latin America and the Caribbean", URY = "Latin America and the Caribbean",
  VEN = "Latin America and the Caribbean", VIR = "Latin America and the Caribbean",
  
  # North America
  BMU = "North America", CAN = "North America", USA = "North America",
  
  # South Asia
  BGD = "South Asia", BTN = "South Asia", IND = "South Asia", MDV = "South Asia", NPL = "South Asia", LKA = "South Asia",
  
  # Sub-Saharan Africa
  AGO = "Sub-Saharan Africa", BEN = "Sub-Saharan Africa", BWA = "Sub-Saharan Africa", BFA = "Sub-Saharan Africa",
  BDI = "Sub-Saharan Africa", CPV = "Sub-Saharan Africa", CMR = "Sub-Saharan Africa", CAF = "Sub-Saharan Africa",
  TCD = "Sub-Saharan Africa", COM = "Sub-Saharan Africa", COG = "Sub-Saharan Africa", CIV = "Sub-Saharan Africa",
  COD = "Sub-Saharan Africa", GNQ = "Sub-Saharan Africa", ERI = "Sub-Saharan Africa", SWZ = "Sub-Saharan Africa",
  ETH = "Sub-Saharan Africa", GAB = "Sub-Saharan Africa", GMB = "Sub-Saharan Africa", GHA = "Sub-Saharan Africa",
  GIN = "Sub-Saharan Africa", GNB = "Sub-Saharan Africa", KEN = "Sub-Saharan Africa", LSO = "Sub-Saharan Africa",
  LBR = "Sub-Saharan Africa", MDG = "Sub-Saharan Africa", MWI = "Sub-Saharan Africa", MLI = "Sub-Saharan Africa",
  MRT = "Sub-Saharan Africa", MUS = "Sub-Saharan Africa", MOZ = "Sub-Saharan Africa", NAM = "Sub-Saharan Africa",
  NER = "Sub-Saharan Africa", NGA = "Sub-Saharan Africa", RWA = "Sub-Saharan Africa", STP = "Sub-Saharan Africa",
  SEN = "Sub-Saharan Africa", SYC = "Sub-Saharan Africa", SLE = "Sub-Saharan Africa", SOM = "Sub-Saharan Africa",
  ZAF = "Sub-Saharan Africa", SSD = "Sub-Saharan Africa", SDN = "Sub-Saharan Africa", TZA = "Sub-Saharan Africa",
  TGO = "Sub-Saharan Africa", UGA = "Sub-Saharan Africa", ZMB = "Sub-Saharan Africa", ZWE = "Sub-Saharan Africa"
)


# 2. Load the data

df <- read.csv("data/raw/external-balance-on-goods-and-services-as-a-percent-of-gdp.csv", stringsAsFactors = FALSE)


# 3. Core separation: Countries vs. Aggregates
# Filter out: aggregate data (not used for regression)
df_aggregated <- df[df$Code %in% aggregate_codes, ]

# Keep for regression: country data only
df_regression <- df[!df$Code %in% aggregate_codes, ]

# Add the region column to the regression dataframe
df_regression$wb_region <- code_to_region[df_regression$Code]


write.csv(df_regression, "data/temp/data_for_regression.csv", row.names = FALSE)       
   
df_regression <- read.csv("data/temp/data_for_regression.csv")

# check the data
colnames(df_regression)
str(df_regression)
summary(df_regression)
sum(is.na(df_regression$wb_region))  


##############################################################################
# Merge the regression data with the sentiment and geo-economic classification data

df_main <- read.csv("data/temp/deepseek_ieo_sentiment_results_final_full.csv", stringsAsFactors = FALSE)
df_reg <- read.csv("data/temp/data_for_regression.csv", stringsAsFactors = FALSE)
colnames(df_main)
colnames(df_reg)
# rename the columns for regression
colnames(df_reg)[colnames(df_reg) == "External.balance.on.goods.and.services....of.GDP."] <- "trade_balance"
# merge

colnames(df_main)[colnames(df_main) == "year"] <- "Year"
df_final <- merge(
  x = df_main,                
  y = df_reg,                 
  by.x = c("iso_code", "Year"),
  by.y = c("Code", "Year"),
  all.x = TRUE                
)
write.csv(df_final, "data/temp/merged_final_data.csv", row.names = FALSE)
#check the merged data
colnames(df_final)
str(df_final)

failed <- df_final[is.na(df_final$trade_balance), c("iso_code", "Year")]
unique(failed)
nrow(failed)
##############################################################################
# REGRESSION ANALYSIS

# prepare the needed variables for regression

library(dplyr)
# Sentiment：Positive=1, Negative=0
df_final$sentiment <- ifelse(df_final$ieo_sentiment == "Positive", 1, 0)
# Lagged effect: use the trade balance from the previous year to predict the sentiment in the current year
df_final$deficit_year <- df_final$Year - 1
## Regression analysis ## the one we finally use for the paper############################

df_final$wb_region <- relevel(as.factor(df_final$wb_region), ref = "Europe and Central Asia")

df_final <- df_final %>%
  filter(
    !is.na(sentiment),   
    !is.na(trade_balance),   
    !is.na(wb_region),       
    !is.na(Year),
    !is.na(deficit_year)
  ) 
# Sentiment Regression
# model 1
# overall regression
model_sent_overall <- lm(
  sentiment ~ trade_balance + factor(Year),
  data = df_final
)
summary(model_sent_overall)
install.packages("modelsummary")

library(gt)
library(modelsummary)
tab2 <- modelsummary(
  model_sent_overall,
  statistic = "({std.error})",
  stars = TRUE,
  output = "gt",
  title = "Model 1",
  gof_omit = "IC|Log|Adj",
  coef_map = c(
    trade_balance = "Trade Balance (% of GDP)",
    Year = "Year"
  )
)
tab2 %>%
  opt_row_striping() %>%
  tab_options(
    table.font.size = px(12)
  )

gtsave(tab2, "model1_table.png")


# model 2
# refinement（we finally mainly use this one to interpret the results）: regression using lagged effect###
df_final_lag <- merge(
  x = df_final,
  y = df_reg[, c("Code", "Year", "trade_balance")],
  by.x = c("iso_code", "deficit_year"),
  by.y = c("Code", "Year"),
  all.x = TRUE
)
df_final_lag <- df_final_lag %>% rename(trade_balance_lag = trade_balance.y)
df_final_lag <- df_final_lag %>%
  filter(
    !is.na(sentiment),   
    !is.na(trade_balance_lag),   
    !is.na(wb_region),       
    !is.na(Year),
    !is.na(deficit_year)
  ) 

model_sent_lag <- lm(
  sentiment ~ trade_balance_lag + factor(Year),
  data = df_final_lag
)
summary(model_sent_lag)


tab_lag <- modelsummary(
  model_sent_lag,
  statistic = "({std.error})",
  stars = TRUE,
  output = "gt",
  title = "Model with Lagged Trade Balance (Previous Year)",
  gof_omit = "IC|Log|Adj",
  coef_map = c(
    trade_balance_lag = "Lagged Trade Balance (% of GDP)",
    Year = "Year"
  )
)

tab_lag %>%
  opt_row_striping() %>%
  tab_options(table.font.size = px(12))

gtsave(tab_lag, "model_lag_table.png")
#############################################################################################
# by regions(WB)
region_sent <- df_final %>%
  group_by(wb_region) %>%
  do(model = lm(
    sentiment ~ trade_balance + factor(Year),
    data = .
  ))
region_sent

# check the regression results for each region
cat("====== Europe and Central Asia ======\n")
summary(region_sent$model[[1]])

cat("\n====== East Asia and Pacific ======\n")
summary(region_sent$model[[2]])

cat("\n====== Latin America and the Caribbean ======\n")
summary(region_sent$model[[3]])

cat("\n====== Middle East, North Africa, Afghanistan and Pakistan ======\n")
summary(region_sent$model[[4]])

cat("\n====== North America ======\n")
summary(region_sent$model[[5]])

cat("\n====== South Asia ======\n")
summary(region_sent$model[[6]])

cat("\n====== Sub-Saharan Africa ======\n")
summary(region_sent$model[[7]])































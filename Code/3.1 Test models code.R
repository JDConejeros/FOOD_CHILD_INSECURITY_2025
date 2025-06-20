# Code 3: Logit Models ----

## Settings ----
source("Code/0.1 Settings.R")
source("Code/0.2 Functions.R")

# Only verify packages if not already loaded
if (!exists("check_packages_loaded") || !check_packages_loaded()) {
  source("Code/0.0 Setup.R")
}

# Data path 
data_inp <- "Input/"
data_out <- "Output/"

## Open data ---- 

casen22 <- rio::import(paste0(data_inp, "casen_2022_child_process", ".RData"))
glimpse(casen22)

## Models ---- 

casen22 <- casen22 |> 
  mutate(ind_overcrowding_binary=factor(ind_overcrowding_binary)) |> 
  mutate(overcrowded=factor(overcrowded)) |> 
  mutate(food_insecurity_binary=factor(food_insecurity_binary)) |> 
  mutate(food_ins1=factor(food_ins1)) 

# food_ins1*ind_overcrowding_binary
# food_ins1*overcrowded
# food_insecurity_score*overcrowding

casen22 |> 
  group_by(overcrowded, underw) |> 
  summarise(n=n(),
            m=mean(food_insecurity_score))

l1 <- glm(underw ~ 
  sex + age + qaut + multi_poverty + food_ins1*ind_overcrowding_binary,
  data = casen22, family = binomial(link = "logit"),  weights = expc)

l2 <- glm(obese ~ 
  sex + age + qaut + multi_poverty + food_ins1*ind_overcrowding_binary,
  data = casen22, family = binomial(link = "logit"),  weights = expc)

plot_model(l1, type = "int")
plot_model(l2, type = "int")

sjPlot::tab_model(l1, l2)
plot_model(l1, type = "pred", terms = c("food_insecurity_score", "overcrowding"))
plot_model(l1, type = "int")
plot_model(l2, type = "int")

library(sjPlot)

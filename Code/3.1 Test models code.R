# Code 3: Logit Models ----

## Settings ----
source("Code/0.2 Settings.R")
source("Code/0.3 Functions.R")

# Only verify packages if not already loaded
if (!exists("check_packages_loaded") || !check_packages_loaded()) {
  source("Code/1.0 Setup.R")
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
            m=mean(food_insecurity_score)) |> 
  group_by(overcrowded) |> 
  mutate(porc=n/sum(n)) |> 
  relocate(porc, .after = n)

casen22 |> 
  group_by(overcrowded, overw) |> 
  summarise(n=n(),
            m=mean(food_insecurity_score)) |> 
  group_by(overcrowded) |> 
  mutate(porc=n/sum(n)) |> 
  relocate(porc, .after = n)

casen22 |> 
  group_by(overcrowded, obese) |> 
  summarise(n=n(),
            m=mean(food_insecurity_score)) |> 
  group_by(overcrowded) |> 
  mutate(porc=n/sum(n)) |> 
  relocate(porc, .after = n)

casen22 |> 
  group_by(overcrowded, overw_obs) |> 
  summarise(n=n(),
            m=mean(food_insecurity_score)) |> 
  group_by(overcrowded) |> 
  mutate(porc=n/sum(n)) |> 
  relocate(porc, .after = n)

############################################

l1 <- glm(underw ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"),  weights = expc)

l1b <- glm(underw ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"))

l2 <- glm(overw ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"),  weights = expc)

l2b <- glm(overw ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"))

l3 <- glm(obese ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"),  weights = expc)

l3b <- glm(obese ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"))

l4 <- glm(overw_obs ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"),  weights = expc)

l4b <- glm(overw_obs ~ 
  food_ins1 + ind_overcrowding_binary + sex + age + zone + multi_poverty + qaut,
  data = casen22, family = binomial(link = "logit"))

sjPlot::tab_model(l1, l2, l3, l4)
sjPlot::tab_model(l1b, l2b, l3b, l4b)

#broom::tidy(l1, exponentiate = TRUE, conf.int = TRUE, conf.level = 0.95)

############################################

# Survey model 
casen22$overw_num <- as.numeric(as.character(casen22$overw))
casen22$underw_num <- as.numeric(as.character(casen22$underw))
casen22$obese_num <- as.numeric(as.character(casen22$obese))
casen22$overw_obs_num <- as.numeric(as.character(casen22$overw_obs))

options(survey.lonely.psu = "adjust") 
dsgn_casen <- svydesign(
  ids     = ~varunit,
  strata  = ~varstrat,
  weights = ~expc,
  data    = casen22,
  nest    = TRUE        # si hay estratos anidados
)

############################################

l1_svy <- svyglm(overw_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svy <- svyglm(underw_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svy <- svyglm(obese_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svy <- svyglm(overw_obs_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svy, l2_svy, l3_svy, l4_svy)

############################################

l1_svyi <- svyglm(overw_num ~ food_ins1 * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svyi <- svyglm(underw_num ~ food_ins1 * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svyi <- svyglm(obese_num ~ food_ins1 * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svyi <- svyglm(overw_obs_num ~ food_ins1 * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svyi, l2_svyi, l3_svyi, l4_svyi)

sjPlot::plot_model(l1_svyi, type = "int")
sjPlot::plot_model(l2_svyi, type = "int")
sjPlot::plot_model(l3_svyi, type = "int")
sjPlot::plot_model(l4_svyi, type = "int")

############################################

l1_svy <- svyglm(overw_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svy <- svyglm(underw_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svy <- svyglm(obese_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svy <- svyglm(overw_obs_num ~ food_ins1 + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svy, l2_svy, l3_svy, l4_svy)

############################################

l1_svyi <- svyglm(overw_num ~ food_ins1 * overcrowded + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svyi <- svyglm(underw_num ~ food_ins1 * overcrowded + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svyi <- svyglm(obese_num ~ food_ins1 * overcrowded + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svyi <- svyglm(overw_obs_num ~ food_ins1 * overcrowded + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svyi, l2_svyi, l3_svyi, l4_svyi)

sjPlot::plot_model(l1_svyi, type = "int")
sjPlot::plot_model(l2_svyi, type = "int")
sjPlot::plot_model(l3_svyi, type = "int")
sjPlot::plot_model(l4_svyi, type = "int")

############################################

l1_svy <- svyglm(overw_num ~ food_insecurity_binary + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svy <- svyglm(underw_num ~ food_insecurity_binary + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svy <- svyglm(obese_num ~ food_insecurity_binary + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svy <- svyglm(overw_obs_num ~ food_insecurity_binary + ind_overcrowding_binary + 
    sex + age + ethnic + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svyi, l2_svyi, l3_svyi, l4_svyi)

sjPlot::plot_model(l1_svyi, type = "int")
sjPlot::plot_model(l2_svyi, type = "int")
sjPlot::plot_model(l3_svyi, type = "int")
sjPlot::plot_model(l4_svyi, type = "int")

############################################

l1_svyi <- svyglm(overw_num ~ food_insecurity_score * ind_overcrowding+ 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svyi <- svyglm(underw_num ~ food_insecurity_score * ind_overcrowding + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svyi <- svyglm(obese_num ~ food_insecurity_score * ind_overcrowding + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svyi <- svyglm(overw_obs_num ~ food_insecurity_score * ind_overcrowding + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svyi, l2_svyi, l3_svyi, l4_svyi)

sjPlot::plot_model(l1_svyi, type = "int")
sjPlot::plot_model(l2_svyi, type = "int")
sjPlot::plot_model(l3_svyi, type = "int")
sjPlot::plot_model(l4_svyi, type = "int")

############################################

l1_svyi <- svyglm(overw_num ~ food_insecurity_score * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svyi <- svyglm(underw_num ~ food_insecurity_score * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svyi <- svyglm(obese_num ~ food_insecurity_score * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svyi <- svyglm(overw_obs_num ~ food_insecurity_score * ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svyi, l2_svyi, l3_svyi, l4_svyi)

sjPlot::plot_model(l1_svyi, type = "int")
sjPlot::plot_model(l2_svyi, type = "int")
sjPlot::plot_model(l3_svyi, type = "int")
sjPlot::plot_model(l4_svyi, type = "int")


#######################################################

l1_svyi <- svyglm(overw_num ~ food_insecurity_score + ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l2_svyi <- svyglm(underw_num ~ food_insecurity_score + ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l3_svyi <- svyglm(obese_num ~ food_insecurity_score + ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

l4_svyi <- svyglm(overw_obs_num ~ food_insecurity_score + ind_overcrowding_binary + 
    sex + age + zone + multi_poverty + qaut,
  design = dsgn_casen,
  family = quasibinomial(link="logit")
)

sjPlot::tab_model(l1_svyi, l2_svyi, l3_svyi, l4_svyi)



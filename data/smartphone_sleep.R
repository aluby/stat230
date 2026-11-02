# Smartphone dependence and sleep quality data for the Day 21b logistic regression recap
# Source: Wang, Chen, Yang, & Lin (2019). PLOS ONE 14(4): e0214769 (CC BY 4.0)
#   https://doi.org/10.1371/journal.pone.0214769
#   file: S1 Dataset (SPSS)
# Values are unchanged, including the row with age = 76 and BMI = 1.04: the activity uses it.

library(haven)
library(dplyr)

url <- "https://journals.plos.org/plosone/article/file?type=supplementary&id=10.1371/journal.pone.0214769.s001"
sav_file <- tempfile(fileext = ".sav")
download.file(url, sav_file, mode = "wb")

smartphone_sleep <- read_sav(sav_file) |>
  zap_labels() |>
  transmute(
    good_sleep = twogroup,  # 1 = PSQI of 5 or less, 0 = PSQI above 5
    psqi = sleepquality,
    phone_dependence = Smartphonedependence,
    age,
    bmi = BMI,
    smoking = Smoking,
    drinking = Drinking,
    phone_before_bed = Smartphoneusebeforesleep,
    nutrition = Nutrition,
    health_responsibility = Healthresponsibility,
    self_actualization = Selfactualization,
    interpersonal_support = Interpersonalsupport,
    exercise = Exercise,
    stress_management = Stressmanagement,
    total_hplp = TotalHPLP
  )

write.csv(smartphone_sleep, "smartphone_sleep.csv", row.names = FALSE)

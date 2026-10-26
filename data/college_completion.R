# Six-year completion at four-year colleges for the final project
# Source: College Scorecard, US Department of Education
#   https://collegescorecard.ed.gov/data/ ("Most Recent Institution-Level Data")
#   documentation: https://collegescorecard.ed.gov/data/documentation/
# Keeps currently operating, public and private nonprofit, predominantly bachelor's-degree-granting
# institutions in the 50 states and DC (not online-only) with a completion cohort of at least 50 students.
# `sat_avg` is left missing for schools that don't report it (many are test-optional)

library(dplyr)

scorecard_file <- "Most-Recent-Cohorts-Institution.csv"  # path to the downloaded (unzipped) file
scorecard_raw <- read.csv(scorecard_file, na.strings = c("NULL", "PrivacySuppressed", "NA", ""))

region_names <- c("1" = "New England", "2" = "Mid East", "3" = "Great Lakes", "4" = "Plains",
                  "5" = "Southeast", "6" = "Southwest", "7" = "Rocky Mountains", "8" = "Far West")
locale_names <- c("1" = "city", "2" = "suburb", "3" = "town", "4" = "rural")

college_completion <- scorecard_raw |>
  filter(PREDDEG == 3, CURROPER == 1, DISTANCEONLY == 0, CONTROL %in% c(1, 2),
         REGION %in% 1:8, !is.na(C150_4), D150_4 >= 50) |>
  transmute(
    name = INSTNM,
    state = STABBR,
    cohort_size = D150_4,                         # full-time, first-time students in the entering cohort
    completers = round(C150_4 * D150_4),          # completed within 150% of normal time (6 years)
    control = ifelse(CONTROL == 1, "public", "private nonprofit"),
    hbcu = HBCU,
    region = region_names[as.character(REGION)],
    locale = locale_names[substr(LOCALE, 1, 1)],
    admission_rate = ADM_RATE,
    sat_avg = SAT_AVG,
    pct_pell = round(100 * PCTPELL, 1),           # % of undergraduates receiving a Pell grant
    enrollment = UGDS,                            # undergraduate enrollment
    cost = COSTT4_A,                              # average annual cost of attendance
    faculty_salary = AVGFACSAL,                   # average monthly faculty salary
    instruction_spending = INEXPFTE,              # instructional spending per full-time-equivalent student
    pct_fulltime_faculty = round(100 * PFTFAC, 1)
  ) |>
  filter(if_all(-sat_avg, ~ !is.na(.x)))

write.csv(college_completion, here::here("data/college_completion.csv"), row.names = FALSE)

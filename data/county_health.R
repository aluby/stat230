# County health data for Case Study 2 (pollution and green space options)
# Source: County Health Rankings & Roadmaps 2025 Annual Data Release
#   https://www.countyhealthrankings.org/health-data/methodology-and-sources/data-documentation
#   files: analytic_data2025_v3.csv and chr_trends_csv_2025.csv
#   see DataDictionary_2025 for definitions and source years

library(dplyr)

chr_file <- "analytic_data2025_v3.csv"      # path to the downloaded analytic file
trends_file <- "chr_trends_csv_2025.csv"    # path to the downloaded trends file

# the first row holds long labels; the second row holds the variable codes
chr_raw <- read.csv(chr_file, skip = 1)

region_lookup <- c(setNames(as.character(state.region), state.abb), DC = "South")

county <- chr_raw |>
  filter(countycode != 0) |>  # drop state and national summary rows
  transmute(
    fips = sprintf("%05d", as.integer(fipscode)),
    state = state,
    county = county,
    region = region_lookup[state],
    population = v051_rawvalue,
    # responses
    premature_death = round(v001_rawvalue),       # years of potential life lost before 75, per 100,000
    life_expectancy = round(v147_rawvalue, 1),
    pct_obese = round(100 * v011_rawvalue, 1),
    pct_inactive = round(100 * v070_rawvalue, 1),
    # environment
    water_violation = v124_rawvalue,              # 1 = health-based drinking water violation
    pct_park_access = round(100 * v179_rawvalue, 1),      # % living within a half mile of a park
    pct_exercise_access = round(100 * v132_rawvalue, 1),  # % with adequate access to locations for physical activity
    # health behaviors
    pct_smokers = round(100 * v009_rawvalue, 1),
    pct_excess_drinking = round(100 * v049_rawvalue, 1),
    # socioeconomic and demographic
    median_income = v063_rawvalue,
    pct_child_poverty = round(100 * v024_rawvalue, 1),
    pct_some_college = round(100 * v069_rawvalue, 1),
    pct_uninsured = round(100 * v085_rawvalue, 1),
    pct_unemployed = round(100 * v023_rawvalue, 1),
    pct_housing_problems = round(100 * v136_rawvalue, 1),
    pct_65_older = round(100 * v053_rawvalue, 1),
    pct_rural = round(100 * v058_rawvalue, 1),
    pct_nonwhite = round(100 * (1 - v126_rawvalue), 1)
  )

# average PM2.5 over 2015-2019 (the 2025 release uses 2020, a heavy wildfire year)
pm25_avg <- read.csv(trends_file, colClasses = "character") |>
  filter(measureid == "125", countycode != "000", yearspan %in% as.character(2015:2019)) |>
  distinct(statecode, countycode, yearspan, .keep_all = TRUE) |>
  mutate(fips = paste0(statecode, countycode),
         pm25 = as.numeric(gsub(",", "", rawvalue))) |>
  group_by(fips) |>
  summarise(pm25 = round(mean(pm25), 2))

# Option 1: does pollution (still) kill people? counties with population >= 100,000
county_pollution <- county |>
  left_join(pm25_avg, by = "fips") |>
  select(fips, state, county, region, population, premature_death, pm25, water_violation,
         pct_smokers, pct_inactive, pct_obese, pct_excess_drinking, median_income,
         pct_child_poverty, pct_some_college, pct_uninsured, pct_65_older, pct_rural,
         pct_nonwhite) |>
  filter(population >= 100000) |>
  na.omit()

# Option 2: does green space improve health? counties with population >= 50,000
county_greenspace <- county |>
  select(fips, state, county, region, population, life_expectancy,
         pct_park_access, pct_exercise_access,
         median_income, pct_child_poverty, pct_some_college, pct_uninsured,
         pct_unemployed, pct_housing_problems, pct_65_older, pct_rural, pct_nonwhite) |>
  filter(population >= 50000) |>
  na.omit()

write.csv(county_pollution, here::here("data/county_pollution.csv"), row.names = FALSE)
write.csv(county_greenspace, here::here("data/county_greenspace.csv"), row.names = FALSE)

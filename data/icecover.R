library(lterdatasampler)

ntl_icecover_avg <- ntl_icecover %>%
  drop_na(ice_duration) %>% 
  group_by(year, lakeid) %>%
  summarise(ice_duration = mean(ice_duration)) %>%
  rename(avg_ice_duration = ice_duration)

ntl_airtemp_avg <- ntl_airtemp %>% 
  filter(year > 1884) %>%   # filter out the known biased data
  group_by(year) %>% 
  summarise(avg_air_temp_adjusted = mean(ave_air_temp_adjusted, na.rm=TRUE))

# Add a column to group the Fall and Spring season into a same year, similarly to what is done when defining hydrological year
ntl_airtemp_hydro <- ntl_airtemp %>%
  mutate(hydroyear = if_else(month(sampledate) < 10, year-1, year))

# Compute the average air temperature from Nov to April
ntl_airtemp_avg_winter <-  ntl_airtemp_hydro %>%
  filter(month(sampledate) %in% c(11:12,1:4)) %>% # filter the months from Nov to April
  group_by(hydroyear) %>%
  summarise(avg_air_temp_adjusted = mean(ave_air_temp_adjusted))

ntl_joined_avg <- ntl_icecover_avg  %>%
  left_join(by = c("year" = "hydroyear"), ntl_airtemp_avg_winter) |>
  ungroup()

ice_data <- ntl_joined_avg |>
  drop_na() |>
  mutate(lakeid = str_replace(lakeid, "Lake ", "")) |>
  rename(air_temp = avg_air_temp_adjusted, 
         ice_duration = avg_ice_duration,
         lake = lakeid) 


gf_point(ice_duration ~ air_temp, color = ~ lake, data = ice_data) |>
  gf_lm()

ice_lm <- lm(ice_duration ~ air_temp*lake, data = ice_data)
write_csv(ice_data, here("data/ice_data.csv"))

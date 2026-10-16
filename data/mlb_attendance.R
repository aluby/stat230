# MLB team-season attendance for Case Study 2
# Source: Lahman Baseball Database (CRAN package `Lahman`, data through 2023)
# Excludes 2020 (no fans) and 2021 (capacity limits)

library(Lahman)
library(dplyr)

mlb_attendance <- Teams |>
  arrange(franchID, yearID) |>
  group_by(franchID) |>
  mutate(
    prev_win_pct = lag(W / G),
    prev_playoffs = lag(DivWin == "Y" | WCWin == "Y")
  ) |>
  ungroup() |>
  filter(yearID >= 2012, !yearID %in% c(2020, 2021)) |>
  transmute(
    team = name,
    franchise = franchID,
    year = yearID,
    league = lgID,
    division = divID,
    attendance_per_game = round(attendance / Ghome),
    win_pct = round(W / G, 3),
    prev_win_pct = round(prev_win_pct, 3),
    prev_playoffs = as.integer(prev_playoffs),
    runs_per_game = round(R / G, 2),
    hr_per_game = round(HR / G, 2),
    sb_per_game = round(SB / G, 2),
    runs_allowed_per_game = round(RA / G, 2),
    strikeouts_per_game = round(SOA / G, 2),
    park_factor = BPF
  )

write.csv(mlb_attendance, here::here("data/mlb_attendance.csv"), row.names = FALSE)

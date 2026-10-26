# Premier League yellow cards and crowds for the final project
# Source: football-data.co.uk, English Premier League results and match statistics
#   https://www.football-data.co.uk/englandm.php
#   files: https://www.football-data.co.uk/mmz4281/{1718,1819,1920,2021,2122,2223}/E0.csv
# One row per team per match (two rows per match), 2017-18 through 2022-23
# Matches from the June 2020 restart through May 17, 2021 were played without fans
#   (a few December 2020 matches allowed up to 2,000 fans; they are counted as "no fans" here)

library(dplyr)
library(tidyr)

epl_dir <- "."  # folder holding the downloaded E0_{season}.csv files
seasons <- c("1718", "1819", "1920", "2021", "2122", "2223")

matches <- lapply(seasons, function(s) {
  read.csv(file.path(epl_dir, paste0("E0_", s, ".csv")), fileEncoding = "UTF-8-BOM") |>
    select(Date, HomeTeam, AwayTeam, Referee, FTHG, FTAG, HS, AS, HF, AF, HC, AC, HY, AY,
           B365H, B365D, B365A) |>
    mutate(season = paste0("20", substr(s, 1, 2), "-", substr(s, 3, 4)))
}) |>
  bind_rows() |>
  mutate(
    date = as.Date(Date, tryFormats = c("%d/%m/%Y", "%d/%m/%y")),
    match_id = row_number(),
    fans = as.integer(!(date >= as.Date("2020-06-17") & date <= as.Date("2021-05-17"))),
    # betting-market probability of each result, rescaled to remove the bookmaker's margin
    total = 1 / B365H + 1 / B365D + 1 / B365A,
    home_win_prob = round((1 / B365H) / total, 3),
    away_win_prob = round((1 / B365A) / total, 3)
  )

home_rows <- matches |>
  transmute(match_id, season, date, fans, referee = Referee, team = HomeTeam, opponent = AwayTeam,
            home = 1L, yellow_cards = HY, fouls = HF, opp_fouls = AF, shots = HS, opp_shots = AS,
            corners = HC, win_prob = home_win_prob, opp_win_prob = away_win_prob)
away_rows <- matches |>
  transmute(match_id, season, date, fans, referee = Referee, team = AwayTeam, opponent = HomeTeam,
            home = 0L, yellow_cards = AY, fouls = AF, opp_fouls = HF, shots = AS, opp_shots = HS,
            corners = AC, win_prob = away_win_prob, opp_win_prob = home_win_prob)

epl_cards <- bind_rows(home_rows, away_rows) |>
  arrange(match_id, desc(home))

write.csv(epl_cards, here::here("data/epl_cards.csv"), row.names = FALSE)

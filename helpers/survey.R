
survey = googlesheets4::read_sheet("https://docs.google.com/spreadsheets/d/17WxFpidUsTpjuXJkA-TFJnPucpEzTPLr2sq0hYk8XDg/edit?usp=sharing")

interests = survey %>%
  select(
    username = `Email Address`, name = 3, classes = 8, interests = 22
  ) %>%
  separate(interests, into = c("int1", "int2", "int3", "int4", "int5", "int6", "int7", "int8"), sep = ", ") 


interests |> select(-username)

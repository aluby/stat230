# NYC street tree health for the final project
# Source: 2015 Street Tree Census, NYC Open Data (NYC Department of Parks & Recreation)
#   https://data.cityofnewyork.us/Environment/2015-Street-Tree-Census-Tree-Data/uvpi-gqnh
# Living trees only; one randomly chosen tree per block, then a random sample of 10,000 trees
#
# Download the living trees with:
#   curl -G -o trees_alive.csv "https://data.cityofnewyork.us/resource/uvpi-gqnh.csv" \
#     --data-urlencode "$select=tree_id,block_id,tree_dbh,curb_loc,health,spc_common,steward,guards,sidewalk,user_type,root_stone,root_grate,root_other,trunk_wire,trnk_light,trnk_other,brch_light,brch_shoe,brch_other,boroname" \
#     --data-urlencode "$where=status='Alive'" --data-urlencode "$limit=700000"

library(dplyr)

trees_file <- "trees_alive.csv"  # path to the downloaded file
trees_raw <- read.csv(trees_file)

top_species <- names(sort(table(trees_raw$spc_common), decreasing = TRUE))[1:8]

set.seed(230)
nyc_trees <- trees_raw |>
  filter(health != "", guards != "", tree_dbh > 0, tree_dbh < 60) |>
  group_by(block_id) |>
  slice_sample(n = 1) |>
  ungroup() |>
  slice_sample(n = 10000) |>
  transmute(
    tree_id,
    good_health = as.integer(health == "Good"),
    diameter = tree_dbh,                                    # trunk diameter at breast height (inches)
    species = ifelse(spc_common %in% top_species, spc_common, "other"),
    on_curb = as.integer(curb_loc == "OnCurb"),
    stewardship = case_when(steward == "None" ~ "none",
                            steward == "1or2" ~ "1-2 signs",
                            TRUE ~ "3+ signs"),
    guards = tolower(guards),
    sidewalk_damage = as.integer(sidewalk == "Damage"),
    root_problem = as.integer(root_stone == "Yes" | root_grate == "Yes" | root_other == "Yes"),
    trunk_problem = as.integer(trunk_wire == "Yes" | trnk_light == "Yes" | trnk_other == "Yes"),
    branch_problem = as.integer(brch_light == "Yes" | brch_shoe == "Yes" | brch_other == "Yes"),
    borough = boroname,
    surveyor = case_when(user_type == "NYC Parks Staff" ~ "parks staff",
                         user_type == "TreesCount Staff" ~ "census staff",
                         TRUE ~ "volunteer")
  )

write.csv(nyc_trees, here::here("data/nyc_trees.csv"), row.names = FALSE)

# Install and load nhanesA
install.packages("nhanesA")
library(nhanesA)

set.seed(040726)

# Retrieve Body Measures data (Example: 2015-2016)
bmx_1516 <- nhanes('BMX_I', 2015) |>
  filter(BMDSTATS == "Complete data for age group") |>
  slice_sample(n=100)

ggplot(bmx_1516, aes(x = BMXARML, y = BMXARMC)) +
  geom_point()

cor(bmx_1516$BMXWT, bmx_1516$BMXARMC, use = "complete.obs")

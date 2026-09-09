library(tidyverse)

mondays = mdy("9/14/2026") + weeks(0:9)
wednesdays = mdy("9/16/2026") + weeks(0:9)
fridays = mdy("9/18/2026") + weeks(0:9)

# highlight this and then addins --> value to clipboard
as.character(stamp("Mar 30, 2026")(sort(c(mondays, wednesdays, fridays))))




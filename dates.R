mondays = mdy("3/30/2026") + weeks(0:9)
wednesdays = mdy("4/1/2026") + weeks(0:9)
fridays = mdy("4/3/2026") + weeks(0:9)

as.character(stamp("Mar 30, 2026")(sort(c(mondays, wednesdays, fridays))))

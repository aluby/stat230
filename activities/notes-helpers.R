# Shared helpers for Stat230 guided/reference notes (sourced from each notesXX.qmd)

fmt_p <- function(p, digits = 3) {
  cutoff <- 10^(-digits)
  ifelse(p < cutoff,
         paste0("<", formatC(cutoff, format = "f", digits = digits)),
         formatC(p, format = "f", digits = digits))
}

# Coefficient table from a fitted model, with readable term names and p-values
kable_coef <- function(model, terms = NULL, digits = 3) {
  tab <- broom::tidy(model)
  if (!is.null(terms)) tab$term <- terms
  tab$estimate <- formatC(tab$estimate, format = "f", digits = digits)
  tab$std.error <- formatC(tab$std.error, format = "f", digits = digits)
  tab$statistic <- formatC(tab$statistic, format = "f", digits = 2)
  tab$p.value <- fmt_p(tab$p.value)
  knitr::kable(tab, col.names = c("term", "estimate", "std. error", "t", "p-value"))
}

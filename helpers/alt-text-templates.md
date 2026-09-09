# Alt-text templates for STAT 230 figures

## The principle

Describe *structure*, not *findings*. Say "a fitted line is overlaid," not "the points
follow the line." Say "residuals against fitted values," not "a funnel pattern." Anything
a student is meant to judge (linearity, constant variance, normality, outliers, whether
groups differ, whether a transformation helps) stays out of the alt text.

## Core plot templates

| Figure | Code it maps to | Template |
|---|---|---|
| Scatterplot | `gf_point(Y ~ X)` | `Scatterplot with {X} on the x-axis and {Y} on the y-axis.` |
| Scatterplot + regression line | `gf_point() \|> gf_lm()` | `Scatterplot with {X} on the x-axis and {Y} on the y-axis, with a fitted straight line overlaid.` |
| Scatterplot + smoother | `gf_smooth()` | `Scatterplot with {X} on the x-axis and {Y} on the y-axis, with a smoothed curve overlaid.` |
| Scatterplot + fitted function | `gf_fun()` / `geom_function` | `Scatterplot with {X} on the x-axis and {Y} on the y-axis, with a fitted curve overlaid.` |
| Jittered scatterplot | `gf_jitter()` | `Jittered scatterplot with {X} on the x-axis and {Y} on the y-axis.` |
| Histogram | `gf_histogram(~X)` | `Histogram of {X}.` |
| Boxplot (one variable) | `gf_boxplot(~X)` | `Boxplot of {X}.` |
| Side-by-side boxplots | `gf_boxplot(Y ~ G)` | `Boxplots of {Y}, one for each level of {G}.` |
| Bar chart | `gf_bar()` / `geom_bar` | `Bar chart showing the number of observations at each level of {X}.` |
| Stacked/filled bar chart | `geom_bar(aes(fill=))` | `Bar chart of {X}, with bars divided by {G}.` |
| Line plot | `gf_line(Y ~ X)` | `Line plot with {X} on the x-axis and {Y} on the y-axis.` |

## Diagnostic plots (keep these especially bland)

| Figure | Code | Template |
|---|---|---|
| Residuals vs fitted | `gf_point(.resid ~ .fitted) \|> gf_hline(yintercept=0)` | `Scatterplot of residuals on the y-axis against fitted values on the x-axis, with a horizontal reference line at zero.` |
| Residuals vs a predictor | `gf_point(.resid ~ X)` | `Scatterplot of residuals on the y-axis against {X} on the x-axis, with a horizontal reference line at zero.` |
| Normal QQ plot of residuals | `gf_qq(~.resid) \|> gf_qqline()` | `Normal quantile-quantile plot of the model residuals, with a reference line overlaid.` |
| Histogram of residuals | `gf_histogram(~.resid)` | `Histogram of the model residuals.` |
| Base 4-panel diagnostics | `plot(model)` | `A set of four standard regression diagnostic plots for the fitted model.` |
| Scale-location | — | `Scatterplot with fitted values on the x-axis and a function of the residuals on the y-axis.` |

## Model-effect / prediction plots

| Figure | Code | Template |
|---|---|---|
| Predicted values, one group | `plot(ggpredict(...))` | `Plot of model-predicted {Y} on the y-axis against {X} on the x-axis, with a shaded confidence band.` |
| Predicted values, by group | `plot(ggpredict(..., terms=c(X, G)))` | `Plot of model-predicted {Y} against {X}, with a separate line and confidence band for each level of {G}.` |
| Fitted curves compared | multiple `gf_line()` overlays | `Scatterplot with {X} on the x-axis and {Y} on the y-axis, with {n} fitted curves overlaid.` |
| Empirical log-odds plot | `gf_point(log_odds ~ X)` | `Scatterplot with {X} on the x-axis and the empirical log-odds of {Y} on the y-axis.` (or, more neutral: `...and a transformed version of {Y} on the y-axis.`) |
| Coefficient / interval plot | `gf_pointrange(estimate + conf.low + conf.high ~ term)` | `Plot showing an estimate and its confidence interval for each model term.` |
| Theoretical distribution overlay | `gf_dist("norm")`, `gf_dhistogram` | `Plot of {X} with a theoretical density curve overlaid.` |

## Add-on phrases (append to any template above)

- Colored by group: `Points are colored by {G}.`
- Faceted: `The plot is split into separate panels by {G}.`
- Multiple stacked panels (e.g. `p1 / p2 / p3`): `Three exploratory plots of {Y} against {X1}, {X2}, and {X3}.`
- Log scale set up in the question: `The x-axis is on a log scale.` -- skip this if
  whether-to-transform is the thing being assessed; just describe the plotted variable,
  e.g. "with log of {X} on the x-axis".
- Before/after transformation pairs: give both the same skeleton and vary only the
  variable name (`{X}` vs `log of {X}`) so the alt text doesn't signal which is preferable.

## Screenshots

`A screenshot of {application} showing {panel/button being pointed to}.`

## Mechanics

- R-generated figure: add a chunk option

  ```r
  #| fig-alt: "Scatterplot with critic score on the x-axis and audience score on the y-axis."
  ```

- Markdown image: `![](img.png){fig-alt="..."}`
- Quarto sets `fig-alt` per chunk only, so multi-plot chunks share one alt string -- split
  the chunk if each plot needs its own.

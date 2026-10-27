# Logistic unit: switch to empirical logits + Pearson residuals only

Goal: use only (1) empirical logit vs. x plots and (2) Pearson residuals for diagnostics in the logistic/binomial unit. No response residuals, no binned response residuals, no deviance residuals. Deviance stays only as the number used for the LRT, AIC/BIC, and what `summary()` prints.

Checked 2026-10-27: slides 20-24, activities 20-24, HW08, HW09. (No `slides25`.)

## Tool map (what each plot is for)

| Need | Tool |
|---|---|
| Linearity of logit in x (before/while modeling) | Empirical logit vs. x (bin x if binary Y; +0.5 adjustment for empty cells; color by a categorical predictor for interactions) |
| Linearity after adjusting for others; outliers | Pearson residuals vs. linear predictor / x, with smoother |
| Independence | Pearson residual index plot |
| Goodness of fit and dispersion | X² = sum of squared Pearson residuals (see below) |

Reminders for the lecture:
- Raw Pearson plots for *binary* Y look like two bands; only read them with a smoother (or lean on empirical logits for linearity).
- Empirical logit vs. x is marginal; Pearson vs. x covers the "after adjusting for others" case.

## Slides

- [ ] **slides20** (Inference for logistic regression)
  - [ ] Remove "Residuals" (response residual definition) and the placeholder "What will the residual plot look like?" slide
  - [ ] Remove "Residual plot" (`type = "response"`)
  - [ ] Replace the 5 "binned residuals" slides (idea, plot, nonlinear trend, check against X variables, residuals vs. categorical predictor) with empirical logit vs. binned x, one predictor at a time, plus empirical logit by level for the categorical predictor
  - [ ] Fix typo: second plot of "Check binned residuals against X variables" has `xlab = "title words"` for `title_caps_percent`
  - [ ] Keep Pearson residuals (definition, smoother, lineup). Decide whether the lineup slide stays
  - [ ] Fix "Recall" slide: says "if INE fails" but the logistic conditions are L, I, R
  - [ ] Keep index plot (Pearson) for independence
- [ ] **slides21** (model comparison): no residual changes; the empirical log odds slide is already the model for the new approach. Keep as is; maybe reuse the same function/code style as slides20
- [ ] **slides22** (binomial logistic)
  - [ ] Delete both "Deviance residuals" slides
  - [ ] Keep the Pearson slides; add a sentence that Pearson residuals are approx. N(0,1) only when the $n_i$ are large enough
- [ ] **slides23** (overdispersion)
  - [ ] Goodness-of-fit slides: switch the test statistic from deviance to Pearson X² (`sum(residuals(m, type = "pearson")^2)`)
  - [ ] Dispersion: replace the "ad-hoc residual deviance / df" with X²/df. For the language data: X²/df = 2.352, which equals R's quasibinomial dispersion (2.3517). Deviance/df = 2.74. Delete the "R uses a slightly different formula" note
  - [ ] Moths check: deviance p = 0.21, Pearson p = 0.24 (same conclusion)
  - [ ] Add a line that GOF can fail for two reasons (wrong mean: nonlinearity/missing interaction, or wrong variance: overdispersion), so check empirical logit / Pearson plots first, then dispersion
  - [ ] Update the "Strategy for binomial logistic regression" slide accordingly
  - [ ] Add one slide: what "deviance" means in the output (analog of SSE, used for LRT and AIC/BIC); we don't use deviance residuals
- [ ] **slides24** (case study tips): "binned residual plots" wording in the example text should say empirical logit plots

## Activities

- [ ] **20-logistic-inference**
  - [ ] Replace the binned-residual walkthrough with binned empirical logits (reuse the `ntile()` code: bin x, compute mean of y per bin, take logit with +0.5 adjustment)
  - [ ] Fix copy-paste leftovers: comment "Creating 65 bins for age", axis label "Mean age in bin"
  - [ ] Update text that says "response residuals" and the `augment(type.residuals = "pearson")` mismatch
  - [ ] Update the function quick reference table
  - [ ] Also update the tutorial version if/when there is one (`19T` exists; no `20T`)
- [ ] **21-r-logistic**: currently an empty stub (title only). Write it (R for model comparison: LRT, `anova`, AIC/BIC, empirical logit plot with interaction) or retitle/remove
- [ ] **22-binomial-logistic**: Q5 and Q7 use deviance residuals; switch to Pearson (`resid_panel(..., type = "pearson")`); update the quick reference row
- [ ] **23-overdispersion**: replace deviance residual plots (Q2) with Pearson; use X²/df for the ad hoc dispersion test (Q1 of the next section)
- [ ] **24-case-studies**: check the "binned residual plots" sentence in the example write-up

## Homework

- [ ] **HW08**
  - [ ] (b) "binned residual plots": replace with empirical logit plots
  - [ ] Later parts (c) and (e): deviance residual plots -> Pearson
  - [ ] Check the response-residual plot chunk near line 88
  - [ ] Check Q (a)/(b) pair around line 153 ("binned residual plot")
- [ ] **HW09**: Q5 mentions deviance GOF; decide whether to switch to Pearson X² for Poisson too (slides27 and activity 27 mention deviance)
- [ ] Update solutions for any HW changed above

## Other issues found (not about residuals)

- [ ] Activity 21 is empty (see above)
- [ ] No Day 25 slides/activity: confirm this is intentional (work day?)
- [ ] Cook's distance / influence for logistic: not covered; decide whether to mention or explicitly skip

## Useful code snippets

Pearson X² and dispersion (binomial data):

```r
X2 <- sum(residuals(model, type = "pearson")^2)
X2 / model$df.residual                     # dispersion (matches quasibinomial)
1 - pchisq(X2, model$df.residual)          # GOF test p-value
```

Binned empirical logit for binary Y:

```r
news_aug |>
  mutate(bin = ntile(title_caps_percent, 13)) |>
  group_by(bin) |>
  summarize(mean_x = mean(title_caps_percent),
            successes = sum(y), n = n(),
            emp_logit = log((successes + 0.5) / (n - successes + 0.5))) |>
  gf_point(emp_logit ~ mean_x) |>
  gf_lm()
```

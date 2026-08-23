library(dplyr)
library(tidyverse)
library(gtsummary)
install.packages("janitor")
library(janitor)
library(broom)

summary(superbowl_ads)
names(superbowl_ads)
str(superbowl_ads)
colnames(superbowl_ads)
table(superbowl_ads$brand,superbowl_ads$celebrity)
sum(is.na(superbowl_ads))
mean(superbowl_ads$animals)
count(superbowl_ads, brand, danger)

#Create a table for count of ads that did not have Youtube URL
table(is.na(superbowl_ads$youtube_url))
tabyl(superbowl_ads$brand)

library(dplyr)

superbowl_ads <- superbowl_ads |>
	mutate(across(
		c(funny, show_product_quickly, patriotic, celebrity, danger, animals,use_sex),
		~ factor(., levels = c(FALSE, TRUE), labels = c("No", "Yes"))
	))


#Create a GTsummary of Superbowl Ads data by Brands
tbl_summary(
	superbowl_ads,
	by = brand,
	include = c(
		funny, show_product_quickly,
		patriotic, celebrity, danger, animals
	),
	label = list(
		funny ~ "Was it trying to be funny?",
		show_product_quickly ~ "Did it show the product right away?",
		patriotic ~ "Was it Patriotic",
		celebrity ~ "Did it feature a celebrity? ",
		danger ~ "Did it involve danger?",
		animals ~ "Did it include animals?"
	),
	missing_text = "Missing"
)|>
	# add a total column with the number of observations
	add_overall(col_label = "**Total** N = {N}") |>
	bold_labels() |>
	modify_caption("**Superbowl Ads Brand characteristics**")

#Regression Fits based on Funny Ads outcome

#Multivariable Regression based on Funny Superbowl Ads
logistic_model <- glm(funny ~ show_product_quickly + patriotic + celebrity + danger,
											data = superbowl_ads, family = binomial()
)

tbl_regression(
	logistic_model,
	exponentiate = TRUE,
	label = list(
		show_product_quickly ~ "Did it show the product right away?",
		patriotic ~ "Was it Patriotic",
		celebrity ~ "Did it feature a celebrity? ",
		danger ~ "Did it involve danger?"
	),
	missing_text = "Missing"
)|>
	bold_labels() |>
	modify_caption("**Funny Superbowl Ads Multivariable Regression Fit**")

#Univariate Regression based on Funny Superbowl Ads
tbl_uvregression(
	superbowl_ads,
	y = funny,
	include = c(
		funny, show_product_quickly,
		patriotic, celebrity, danger
	),
	method = glm,
	method.args = list(family = binomial()),
	exponentiate = TRUE,
	label = list(
		show_product_quickly ~ "Did it show the product right away?",
		patriotic ~ "Was it Patriotic",
		celebrity ~ "Did it feature a celebrity? ",
		danger ~ "Did it involve danger?"
),
missing_text = "Missing"
)|>
	bold_labels() |>
	modify_caption("**Funny Superbowl Ads Univariate Regression Fit**")

#Figures

hist(superbowl_ads$year)




library(dplyr)
library(tidyverse)
library(gtsummary)
install.packages("janitor")
library(janitor)
library(broom)
library(ggplot2)
install.packages("tidycat")
library(tidycat)

#generate a summary of dataset
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
#Forest Plot of Funny Superbowl Ads
glm(funny ~ show_product_quickly + patriotic + celebrity + danger,
		data = superbowl_ads, family = binomial()) |>
	tbl_regression(
		add_estimate_to_reference_rows = TRUE,
		exponentiate = TRUE,
		label = list(
			show_product_quickly ~ "Did it show the product right away?",
			patriotic ~ "Was it Patriotic",
			celebrity ~ "Did it feature a celebrity? ",
			danger ~ "Did it involve danger?"
	)
	) |>
	plot() +
	labs(title = "Forest Plot of Funny Superbowl Ads")


ggplot(data = {superbowl_ads},
			 aes(x = {brand}, fill = funny)) +
	geom_bar() + labs(title = "Frequency of Funny Superbowl Ads by Brand")

ggplot(data = {superbowl_ads},
			 aes(x = {brand}, fill = brand),) +
	geom_bar() + labs(title = "Frequency of Brand Advertisers")

ggplot(data = superbowl_ads,
			 aes(x = brand,
			 		fill = brand)) +
	geom_bar() +
	facet_grid(cols = vars(funny)) +
	scale_fill_brewer(palette = "Spectral",
										direction = -1) + theme_minimal() +
	labs(title = "Brand Advertisers that have funny ads",
			 y = NULL)

# Ads with animals over the years
ggplot(data = superbowl_ads, aes(x = year)) +
	geom_bar() +
	labs(x = "Year") +
	facet_grid(rows = vars(animals),
						 margins = TRUE,
						 scales = "free_y") + labs(title = "Frequency of Superbowl ads from 2000 to 2020 that include animals")

# Ads that involved celebrities over the years
ggplot(data = superbowl_ads, aes(x = year)) +
	geom_bar() +
	labs(x = "Year") +
	facet_wrap(vars(celebrity)) + labs(title = "Frequency of Superbowl ads from 2000 to 2020 that include celebrities")

#Functions

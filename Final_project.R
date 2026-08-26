library(dplyr)
library(tidyverse)
library(gtsummary)
install.packages("janitor")
library(janitor)
library(broom)
library(ggplot2)
install.packages("tidycat")
library(tidycat)

install.packages("here")
setwd("~/Library/CloudStorage/OneDrive-Emory/EPI590R/final-project")

#Load data
superbowl_ads <- read_csv(here::here("data", "superbowl-ads.csv")) |>
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
		funny ~ "Funny Ads",
		show_product_quickly ~ "Ads showed the product right away",
		patriotic ~ "Patriotic Ads",
		celebrity ~ "Celebrity-featured Ads",
		danger ~ "Ads involving danger",
		animals ~ "Animals-featured Ads"
	),
	missing_text = "Missing"
)|>
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

#Forest Plot of Superbowl Ads that used Sex
glm(use_sex ~ show_product_quickly + funny + celebrity + danger,
		data = superbowl_ads, family = binomial()) |>
	tbl_regression(
		add_estimate_to_reference_rows = TRUE,
		exponentiate = TRUE,
		label = list(
			show_product_quickly ~ "Did it show the product right away?",
			funny ~ "Was it funny?",
			celebrity ~ "Did it feature a celebrity? ",
			danger ~ "Did it involve danger?"
		)
	) |>
	plot() +
	labs(title = "Forest Plot of Superbowl Ads that used Sex")

ggplot(data = {superbowl_ads},
			 aes(x = {brand}, fill = funny)) +
	geom_bar() + labs(title = "Frequency of Funny Superbowl Ads by Brand")


#Bar graph of the Frequency of Brand Advertisers
brand_gplot <-ggplot(data = {superbowl_ads},
										 aes(x = {brand}, fill = brand),) +
	geom_bar() + labs(title = "Frequency of Brand Advertisers")
ggsave(plot =brand_gplot,
			 filename =here::here("output","brand_gplot.pdf"))

#Superbowl Brand Advertisers that had funny ads
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


#Superbowl ads from 2000 to 2020 that include celebrities
celeb_gplot <- ggplot(data = superbowl_ads, aes(x = year)) +
	geom_bar() +
	labs(x = "Year") +
	facet_wrap(vars(celebrity)) + labs(title = "Frequency of Superbowl ads from 2000 to 2020 that include celebrities")
ggsave(plot =celeb_gplot,
			 filename =here::here("output","celeb_gplot.pdf"))


#Functions

#Function to get the percent of each ad characteristic

find_pct_value <- function(data, variable) {
	counts <- count(data, {{variable }})
	total <- sum(counts$n)
	pct_value <- mutate(counts, pct = n / total * 100)
	return(pct_value)
}

find_pct_value(superbowl_ads, funny)

#Function to find if there is an association between an ad being patriotic and
#having another characteristic
fit_patriotic <- function(data, predictors) {
	glm(reformulate(predictors, response = "patriotic"), data = data, family = binomial())
}

coef(fit_patriotic(superbowl_ads,"animals"))

#Save forrest plot and

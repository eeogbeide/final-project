library(dplyr)
library(tidyverse)
library(gtsummary)
install.packages("janitor")
library(janitor)

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

#Create a GTsummary of Superbowl Ads data
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
	modify_caption("**Brand characteristics**")

hist(data$variable)


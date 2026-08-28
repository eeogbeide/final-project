# Super Bowl Ads 
**Final Project**
Author: Eghosa Ogbeide

Hello and welcome to my  Final Project! I'm excited to share my final project with you all. I'm a big sports fanatic and in another life I would have done sports marketing analyses,
so finding a dataset using America's favorite pasttime as its basis and the reason I enjoy watching the Super Bowl was kismet. In my final project I explore the 10 brands that had the most advertisements in Super Bowls from 2000 to 2020.
I examine any possible associations between these characteristics generating regression fits(both multivariable and univariate), forrest plots and other figures to help understand if there 
are associations between these characteristics. Overall, this project will not require you to do much other than run and render the codes and quarto files. Please feel free to choose different variables to explore the different
characteristics or associations between these ads.

*Run Final_project.R and then render FinalProject.qmd*

Note: I did not use AI for this final project. I did extract libraries and used the references shared in 590R and in your ID 543 course. 

Below is the official README that explains the dataset provided by the dataset's folder. Happy coding!: 

This folder contains the data behind the story [According To Super Bowl Ads, Americans Love America, Animals And Sex](http://projects.fivethirtyeight.com/super-bowl-ads).

`superbowl-ads.csv` contains a list of ads from the 10 brands that had the most advertisements in Super Bowls from 2000 to 2020, according to data from [superbowl-ads.com](https://superbowl-ads.com/), with matching videos found on [YouTube](https://youtube.com). FiveThirtyEight staffers then came up with seven defining characteristics of a Super Bowl ad, watched every video and evaluated each according to the taxonomy in the table below.

Header | Definition
---|---------
`year` | Year the spot aired, according to superbowl-ads.com
`brand` | Brand of advertiser, grouped to account for spelling and punctuation differences, and sub-brands (e.g. `Coca-Cola Mini` is grouped into `Coca-Cola`)
`superbowl_ads_dot_com_url` | Link to superbowl-ads.com entry for this ad
`youtube_url` | Link to YouTube video matched to this ad. If this field is blank, this means we weren't able to find a YouTube video for this spot — so if you find one, please let us know!
`funny` | **Was it trying to be funny?** Is the ad jokey, goofy, weird or silly? Funny commercials (or ones that are trying to be funny) are marked `True`. Anything serious or dramatic is marked `False`.
`show_product_quickly` | **Did it show the product right away?** Can you tell what is being advertised within the first 10 seconds of the commercial? If you can see the product or brand name on the screen, that counts.
`patriotic` | **Was it patriotic?** Did the commercial make a patriotic appeal, either clear or subtle, or include American imagery? Any glimpses of an American flag or the words "America" or "United States" counted, as did references to the armed forces, manufacturing and farming.
`celebrity` | **Did it feature a celebrity?** If we saw a celebrity we recognized, we checked this one off.
`danger` | **Did it involve danger?** Did we see any violence, threats of violence, injuries, fighting or guns? Any allusions to death or hokey injuries also counted here.
`animals` | **Did it include animals?** Did an animal — either real or computer-generated — show up at any point in the ad? Even one-frame appearances counted.
`use_sex` | **Did it use sex to sell its product?** We counted any subtle or overt suggestions of sex, sexuality, sex appeal or nudity.

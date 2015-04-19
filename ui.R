#########################
# LIBRARIES
library(shiny)


#########################
# THE SHINY UI

shinyUI(fluidPage(

    # title
    titlePanel('Double-Blind Taste Test: Frozen Coffee Beans'),

    sidebarLayout(

        # sidebar
        sidebarPanel(

            # description
            em('Select data to visualize, analyze and explore'),
            br(),
            br(),

            # inputs
            radioButtons("measurement", "Measurement (Y):", c("Overall Liking" = "overall", "Crema Rating" = "crema", "Taste (Flavor Strength)" = "taste")),
            radioButtons("feature", "Feature (X):", c("Summary" = "overall", "Taster" = "taster", "Machine" = "machine", "Grinder" = "grinder", "Days Frozen" = "days_frozen", "Days Aged" = "days_aged"), selected = 'taster'),
            radioButtons("taster", "Taster (subset):", c("All" = "all", "Bob" = "Bob", "Randy" = "Randy", "Ken" = "Ken")),
            br(),

            # reference
            h6(a('Original Research Source: "Coffee: To Freeze or Not to Freeze," Home-Barista.com, Ken Fox, 2007', href = 'http://www.home-barista.com/store-coffee-in-freezer-details.html'))

        ),

        # main
        mainPanel(

            tabsetPanel(type = "tabs",

                # plot tab
                tabPanel("Plot & Stats",

                        # hint
                        em(paste0('Rating score explanation: -2 = the espresso made from frozen beans was rated much worse than ',
                                  'that made from never-frozen beans, -1 = worse, 0 = same, +1 = better, +2 = much better, +3 = ',
                                  'frozen was very much better.')),

                        # the plot
                        plotOutput('plot1'),

                        # stats table
                        em('Statistical analyses, computed where applicable. Only p-Values below 0.05 indicate a result that can be considered statistically significant.'),
                        tableOutput('stats1')
                ),

                # documentation tab
                tabPanel("Documentation",

                        # intro
                        br(),
                        h4('Question: should roasted coffee beans be stored in the freezer?'),
                        br(),

                        p(paste0('In 2007, Ken Fox and two assistants, in connection with several others from Home-Barista.com, commenced a ',
                                 'carefully designed study to answer that question. They performed a series of 64 blind taste ',
                                 'tests between espresso made from frozen coffee beans versus espresso made from not-',
                                 'frozen coffee beans but otherwise prepared in precisely the same manner. They varied ',
                                 'the taster, the length of time the beans were in the freezer, the length of time ',
                                 'the beans were out of the freezer/roaster, the espresso machine type and the grinder ',
                                 'burrs. They rated each espresso three ways: overall quality, crema, and flavor strength. ')),
                        br(),

                        # observation explanation
                        p(paste0('Each observation rating is of a blind taste test between espresso made from frozen coffee beans versus ',
                                 'the same beans never frozen but otherwise roasted, aged and prepared the same way. A negative ',
                                 'score means the espresso is worse than that made from the same beans never frozen. -2 = frozen is ',
                                 'much worse, -1 = worse, 0 = same, +1 = better, +2 = much better, +3 = frozen beans were very much better.')),
                        br(),

                        # original analysis
                        p(paste0('The original study concluded that freezing coffee beans could not be shown',
                                 'to have influenced taste; in other words, they failed to disprove the null hypothesis ',
                                 'that freezing beans does not influence taste.')),
                        br(),

                        # app description
                        h4('Instructions for this app'),
                        br(),
                        p(paste0('This app allows you to explore the Fozen Beans study visually, by simply selecting which ',
                                 'taste evaluation to compare against which preparation criterion. For categorical criterion ',
                                 'a box-and-whisker* plot is drawn. For numeric criterion a jittered scatterplot with linear regression ',
                                 'trendline is shown. For both types a Student t-test p-value is computed, and for numeric data ',
                                 'the linear regression model p-value is also computed. From these p-values you will see that ',
                                 'the data do not disprove the null hypothesis, as the p-values consistently exceed 0.05. ',
                                 'Personally, I find it interesting to see if any of the three tasters showed greater skill ',
                                 'in detecting a difference, perhaps disproving the null hypothesis for at least one expert? ',
                                 'Use the subset selection to explore this question yourself.')),
                        br(),

                        # box and whisker explanation
                        h5('* Box-and-whisker plot'),
                        p(paste0('As a reminder, the bold horizontal line represents the median response. ',
                                 'The box represents the upper and lower quartile, that is the values of 25% to 75% of responses. ',
                                 'And the top/bottom lines represent the minimum and maximum response values.')),
                        br(),

                        # source data
                        h4('Raw data'),
                        br(),
                        p(paste0('The raw data is available in a separate tab. It was obtained by careful tidying of the ',
                                  'original study data from the Home-Barista.com website, here:')),
                        h6(a('Original Research Source: "Coffee: To Freeze or Not to Freeze," Home-Barista.com, Ken Fox, 2007',
                             href = 'http://www.home-barista.com/store-coffee-in-freezer-details.html'))

                ),

                # raw data tab
                tabPanel("Raw Data",

                        # description
                        h4('Raw data: 64 blind taste tests.'),
                        h6(a('Original Research Source: "Coffee: To Freeze or Not to Freeze," Home-Barista.com, Ken Fox, 2007',
                             href = 'http://www.home-barista.com/store-coffee-in-freezer-details.html')),
                        br(),

                        # the table
                        br(),
                        tableOutput("rawdata1")
                )

            )

        )

    )

))

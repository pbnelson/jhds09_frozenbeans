#########################
# LIBRARIES
library(shiny)



#########################
# DATA LOADING
# load frozen bean data, and format columns as appropriate
fbdf <- read.csv('./frozen_beans.csv')
fbdf$date <- strftime(as.Date('2007-01-31') + fbdf$date, '%Y-%m-%d')
fbdf$taster <- factor(fbdf$taster, levels = c('BO', 'RA', 'KE'), labels = c('Bob', 'Randy', 'Ken'))
fbdf$machine <- factor(fbdf$machine, levels = c('RO', 'VI'), labels = c('Rotary', 'Vibratory'))
fbdf$grinder <- factor(fbdf$grinder, levels = c('NB', 'OB'), labels = c('Old Burrs', 'New Burrs'))
fbdf$coffee <- factor(fbdf$coffee, levels = c('4W', '8W'), labels = c('Frozen 4wks', 'Frozen 8wks'))
fbdf$days_frozen <- as.integer(ifelse(fbdf$coffee == 'Frozen 4wks', 28, 56))
fbdf$days_aged <- as.integer(as.Date(fbdf$date) - as.Date('2007-02-12'))



#########################
# HELPER FUNCTIONS

# a little string helper: capitalizes first letter of words
proper <- function(x) {
    gsub("(?<=\\b)([a-z])", "\\U\\1", tolower(x), perl = TRUE)
}



# a plotting helper: a smart jitter that operates on numeric only
jitterit <- function(x) {
     if (is.numeric(x)) jitter(x, 0.25)
     else x
}



# function to subset the data for named tasters
datasubset <- function(data, taster) {
    ifelse(taster == 'all', data, data[data$taster == taster, ])
}



#########################
# PLOTTING FUNCTION

# this function plots, and also computes the p-value and t-value, when possible, returning them in a list
plot_and_computation <- function(data, yvar, xvar, taster) {
    # set title
    title <- paste0('Taster: ', proper(taster))

    # subset data for tasters requested
    #chartdata <- datasubset(data, taster)
    ifelse(taster == 'all', chartdata <- data, chartdata <- data[data$taster == taster, ])

    # pick a plot function (base R default plot selection fails for x/y = overall/overall)
    ifelse(xvar == 'overall', plotfunc <- boxplot, plotfunc <- plot)

    # set x-label & y-label
    x_label <- proper(xvar)
    y_label <- proper(yvar)

    # draw the plot
    plotfunc(x = jitterit(chartdata[, xvar]),
         y = jitter(chartdata[, yvar], 0.75),
         main = title,
         xlab = (x_label),
         ylab = (y_label),
         col = rgb(0, 0.6, 0.8, 0.75),
         pch = 1,
         cex = ifelse(is.numeric(data[, xvar]), 1.5, 1),
         ylim = c(-3, +3)
    )

    # compute linear model fit
    if (xvar != 'overall' & !(taster != 'all' & xvar == 'taster')) {
        fit <- lm(chartdata[, yvar] ~ chartdata[, xvar])
    }

    # plot the fit line if both axes are numeric.
    # also use anova to compute lm p-value
    p_value <- NA
    if (is.numeric(chartdata[, xvar]) & is.numeric(chartdata[, yvar]) & xvar != 'overall') {
        abline(fit, col = 'blue', lty = 3, lwd = 2)
        p_value <- round(anova(fit)$'Pr(>F)'[1], 2)
    }

    # compute the t-test p-value
    ttest <- t.test(chartdata[, yvar])
    t_value <- round(ttest$p.value, 2)

    # compute 'n', the number of observations
    n <- nrow(chartdata)

    # prepare stats dataframe
    sdf <- data.frame(n, t_value, p_value)
    names(sdf) <- c('Number of Trials', 'T-Test p-Value', 'Linear Model p-Value')

    # return the stats dataframe and the rawdata dataframe
    return(list(stats = sdf, rawdata = data))  # note, I am intentionally returning *all* data, every time, not the selected subet.
}

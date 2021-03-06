
#' Plot the change over time of the correlation between one set of words and another set of words in a JSTOR DfR dataset
#' 
#' @description Function to plot changes in the relative frequency of two set of words (two sets of 1-grams) over time. The relative frequency is the frequency of the set of words in a document divided by the total number of words in a document. For use with JSTOR's Data for Research datasets (http://dfr.jstor.org/).
#' @param x object returned by the function JSTOR_unpack.
#' @param word1 One word or a vector of words, each word surrounded by standard quote marks.
#' @param word2  One word or a vector of words, each word surrounded by standard quote marks.
#' @param span span of the loess line (controls the degree of smoothing). Default is 0.4
#' @return Returns a ggplot object with publication year on the horizontal axis and Pearson's correlation on the vertical axis. Each point represents all the documents of a single year, point size is inversely proportional to p-value of the correlation.
#' @examples 
#' ##JSTOR_2wordcor(dat1, word1 = "pearls", word2 = "diamonds"))
#' ##JSTOR_2wordcor(dat1, c("silver", "gold", "platinum"), c("oil", "gas"), span = 0.3)


JSTOR_2wordcor <- function(x, word1, word2, span = 0.4){
  ## investigate correlations between words over time
  wordcounts <- x$wordcounts
  bibliodata <- x$bibliodata
  cw1 <- word1
  cw2 <- word2
  cword1 <- sapply(1:length(wordcounts), function(i) sum(wordcounts[[i]] %in% cw1))
  cword2 <- sapply(1:length(wordcounts), function(i) sum(wordcounts[[i]] %in% cw2))
  leng <-   sapply(1:length(wordcounts), function(i) length(wordcounts[[i]]))
  # calculate ratios
  cword1_ratio <- cword1/leng
  cword2_ratio <- cword2/leng
  # get years for each article and make data frame
  ctwowords_by_year <- data.frame(ww1 = cword1_ratio, ww2 = cword2_ratio, year = as.numeric(as.character(bibliodata$year)))
  lim_min <- as.numeric(as.character(min(bibliodata$year)))
  lim_max <- as.numeric(as.character(max(bibliodata$year)))
  # calculate correlations of the two words per year (and p-values)
  library(plyr)
  corrp <- ddply(ctwowords_by_year, .(year), summarize, "corr" = cor.test(ww1, ww2)$estimate, "pval" = cor.test(ww1, ww2)$p.value)
  # visualise
  library(ggplot2)
  suppressWarnings(ggplot(corrp, aes(year, corr)) +
                     geom_point(aes(size = -pval)) +
                     geom_smooth(  method = "loess", span = span, se = FALSE) +
                     theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
                     geom_hline(yintercept=0, colour = "red") + 
                     ylab(paste0("correlation between '",cw1, "' and '", cw2,"'")) +
                     ylim(min(corrp$corr), 1.0) +
                     scale_x_continuous(limits=c(lim_min, lim_max), breaks = seq(lim_min-1, lim_max+1, 2)) +
                     scale_size_continuous("p-values", breaks = c(-0.75, -0.25, -0.05, -0.001), labels = c(0.75, 0.25, 0.05, 0.001)))
}

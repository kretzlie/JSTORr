\name{JSTOR_MALLET_hotncoldtopics}
\alias{JSTOR_MALLET_hotncoldtopics}
\title{Plot the top five hot and cold topics in the archive}
\usage{
  JSTOR_MALLET_hotncoldtopics(x)
}
\arguments{
  \item{x}{the object returned by the function
  JSTOR_unpack.}
}
\value{
  Returns a plot of the hot topics and plot of the cold
  topics and a list of dataframes of the topic proportions
  per year. Years as rows, topics as columns and posterior
  probabilities as cell values.
}
\description{
  Generates plots and data frames of the top five hot and
  cold topics. Hot topics are topics with a positive
  correlation to year of publication, cold topics have a
  negative correlation. For use with JSTOR's Data for
  Research datasets (http://dfr.jstor.org/).
}
\examples{
## hotncold <- JSTOR_MALLET_hotncoldtopics(x = unpacked)
}


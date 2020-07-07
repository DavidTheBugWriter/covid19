
# 7th Jul 2020: project abandoned.
THe DHSC keep changing the way they report statistics and I lack the time to rewrite the scaper to gather the data. I'm also doubtful of the reporting methodologies & untangling these is the job for a more dedictated person than I.


Due to timing changes in UK government release of death data there are inaccuracies in dates of mortality figures. I may be able to correct these at some point and the error is probably fairly marginal.

More importantly: because the government doesn't want to scare the horses it isn't doing widespread infection testing; some figures are likely to be off by an unknown order of magnitude (at least 1, probably 2 & pray god not 3). I suspect the mortality figures are reliable since death has minimal subjectivity and causes are methodically assessed and well recorded. There is some skepticism about underrecording of death so *caveat emptor*.

The data can be input by manually editing the Covid-19 csv file provided. Note that only a few columns need amending: Date, All_tests, Confirmed, Fatalities.

Alternatively run the scraper which pulls data from .gov.uk website

datasets:
1)  [Department of Health and Social Care, Covid-19](https://www.gov.uk/guidance/coronavirus-covid-19-information-for-the-public)
2)  [DHSC data (not used)](https://www.gov.uk/guidance/coronavirus-covid-19-information-for-the-public)

### Overview: Mine Twitter Data
The aim of this project was to extract tweets from Twitter related to the US Federal Special Prosecutor search term ‘Robert Mueller’. Using the Twitter authentication credentials used in Assignment 2, the Twitter stream was used to automate data collection and extract tweets referencing the ‘Robert Mueller’ search term. The extracted information was parsed for positive, negative and neutral sentiment tweets yielding summary statistics of their relative abundance, and an output of the five examples of positive and negative tweets displayed.

#### Research design and methods
The strategy used for this exercise was to develop a Python program (using the tweepy package) designed to access Twitter data related to mentions of US Special Prosecutor ‘Robert Mueller’. Specifically, the Python program (MineTwitter.py), which has 3 main sequential steps:

1. Authorize twitter API client (using tweepy package).
2. Make a GET request to Twitter API to fetch tweets for a particular query ‘Robert Mueller’.
3. Parse the tweets, and classify each tweet as positive, negative or neutral (uses textblob package)

The Twitter API gets 200 tweet results. The tweepy package uses the Twitter API to access and get the tweet data, while the textblob package is used mainly to derive the tweet sentiment. It does this using a sentiment classifier to produce a sentiment polarity on a scale from -1 to 1, so that positive, neutral and negative sentiments have scores of 1, 0 and -1, respectively, using the classifier.

#### Implementation and programming
The MineTweets.py program creates and instantiates an object of class TwitterClient, which encodes several helper methods to first access the Twitter API (passes authentication credentials), perform a search query (e.g. ‘Robert Mueller’) passed to it by the main method, then parses the resulting 200 tweets collected by cleaning them of links and special characters (using the re regular expressions package), and then categorizes the sentiment using the textblob package into positive, negative and neutral. Some summary statistics of the relative percentage of positive, negative and neutral tweets are calculated and displayed, and finally five examples of positive and negative tweets are displayed in the screen ouput.

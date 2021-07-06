### Overview: Robotic Process Automation (RPA)
The aim of this project was to utilize the UiPath Robot Process Automation (RPA) software to download historical ride share data repositories from the Chicago-based Divvy Bike Share Program website. The latter data will be used in my subsequent thesis project, to build time series and geospatial models in order to improve the bike share program. Execution of the UiPath robot successfully downloaded the data repositories (directories) for rider and bike station usage data files from the Divvy website.

The strategy used for this exercise was to install the community edition of UiPath robot process automation (RPA) software and implement an RPA software robot tool to scrape historical ride sharetextcmd data repositories from the Divvy Bikeshare web site (https://www.divvybikes.com/system- data) via the Amazon S3 Cloud. Specifically, a robot was created that navigated to the Divvy data web site using the Google Chrome browser, and sequentially downloaded 9 directories of ridership data from 2013-2017.

#### Implementation and programming
The UiPath software (Community edition) was installed and used to develop an RPA robot that was designed to record a web scraping effort directed downloading data repository files from the Divvy Bikeshare program. The RPA robot was implemented to crawl, using the Google Chrome browser, to just one website comprising the data repositories.

Main program: Resides within the ‘BikeshareData’ project folder, Main.xaml (main program that calls a UiPath robot that launches Chrome browser (with Google Chrome extensions enabled), that navigates to the system data sharing portal for Divvy Bikeshare (https://www.divvybikes.com/system-data) and proceeds to download data sources comprises rider/station information. The results of the web scraping resulted in downloading 9 zip archive files containing the ridership data for program from 2013 to 2017, shown in the screenshot below.

#### Output folders and files:
BikeshareData/
  /Main.xaml: UiPath main program name to crawl Divvy Bike data share site
  /project.json
Directory structure of submission

#### Conclusions
Ride share archive files (zip files) from the Chicago-based Divvy Bike Share Program describing rider and bike station usage data files were successfully downloaded to my PC Desktop, using a UiPath RPA robot designed to navigate using a Chrome browser to the data portal and download data directories.
 

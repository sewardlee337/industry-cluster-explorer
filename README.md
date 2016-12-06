# Shiny Dashboard for Industry Cluster Analysis

*This application is currently under active development. Changes and modifications will be added over time.*

## About

This Shiny web app provides a dashboard for economic researchers to perform industry cluster analysis and derive insights regarding regional economic productivity and competitiveness. 

For more information regarding the theory of industry clusters, see:
* [Porter, Michael E. "Clusters and the New Economics of Competition." *Harvard Business Review* 76, no. 6 (November–December 1998): 77–90.](http://www.clustermapping.us/sites/default/files/files/resource/Clusters_and_the_New_Economics_of_Competition.pdf)
* [U.S. Cluster Mapping website](http://www.clustermapping.us/content/clusters-101)
* [HBS Institute for Strategy and Competitveness website](http://www.isc.hbs.edu/competitiveness-economic-development/frameworks-and-key-concepts/Pages/clusters.aspx)

This web app is a project of the [Taiwan Institute for Strategy and Competitiveness](http://tisc.nccu.edu.tw/) at [National Chengchi University](http://www.nccu.edu.tw/?locale=en) in Taipei.

## Setup

### Software Dependencies

In order to run this web app, you need to have the [R language](https://www.r-project.org/), [RStudio IDE](https://www.rstudio.com/), and the following R packages installed:
* [dplyr](https://CRAN.R-project.org/package=dplyr)
* [ggplot2](https://CRAN.R-project.org/package=ggplot2)
* [Leaflet](https://CRAN.R-project.org/package=leaflet)
* [Shiny](https://CRAN.R-project.org/package=shiny)

Install R packages using function `install.packages()`. For example:

```r
install.packages('shiny')
```

### Folder Structure

Make sure that the file structure on your machine matches the following:

```
├── bizcluster-dashboard
|   ├── scripts
|   | ├── calculated_metrics.R
|   ├── data
|   ├── server.R
|   ├── ui.R
└──
```
**Note that the folder `data` does not exist on the Github repository.** Prior to running the application, create the folder `data` and populate it with input data to be processed and visualized by the dashboard. 

###	Data Preparation

#### Industry Cluster Data

In order for datasets to be visualized by the dashboard to be processed correctly, it must be structured in [tidy format](http://vita.had.co.nz/papers/tidy-data.pdf) and stored in CSV file format.

#### Geospatial Data

## Feedback and Collaboration

Please contact Seward Lee at sewardlee337@gmail.com for collaboration opportunities.

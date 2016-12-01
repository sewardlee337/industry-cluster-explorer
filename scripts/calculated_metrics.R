library(dplyr)

##   CAGR calculation

cagr <- function(begin_data, end_data, metric, years){
     
     ##   Keep columns needed for calculation
     
     begin_data <- begin_data[, c('cluster', 'region', metric)]
     end_data <- end_data[, c('cluster', 'region', metric)]
     
     ##   Inner-join datasets for beginning and end year
     
     combined_table <- inner_join(begin_data, end_data, by = c('cluster', 'region'))
     
     names(combined_table) <- c('cluster', 'region', 'begin_metric', 'end_metric')
     
     ##   Conditional statement to construct CAGR column
     ##   If metric for beginning year == 0, CAGR is 0
     ##   Else apply CAGR formula
     
     combined_table$cagr <- ifelse(combined_table$begin_metric == 0, 0, 
          (combined_table$end_metric/combined_table$begin_metric) ^(1/years) - 1
     )
     
     cagr_table <- combined_table[, c('cluster', 'region', 'cagr')]
     
     return(cagr_table)
}


##   Metric share calculation

share <- function(data, metric) {
     
     total_table <- filter(data, region == "Total")
     
}
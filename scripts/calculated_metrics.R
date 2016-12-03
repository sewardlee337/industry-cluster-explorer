library(dplyr)

##   CAGR Calculation

CAGR <- function(begin_data, end_data, metric, years){
     
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

##   Region Share Calculation

RegionShare <- function(data, metric) {
     
     ##   Keep relevant columns in dataset
     initial_table <- data[,c("cluster", "region", metric)]
     
     ##   Create dataframe with summed metric values by region
     sum_param <- paste0("sum(", metric,")")           ##   NOTE: This is necessary to deal with NSE in summarise_() function 
     
     total_table <- group_by_(data, "region") %>%
          summarise_(sum_metric = sum_param) %>%
          as.data.frame()
     
     ##   Join regional total column to dataset
     combined_table <- inner_join(initial_table, total_table, by = "region")
     
     ##   Calculate regional shares
     combined_table$region_share <- combined_table[,metric] / combined_table$sum_metric 
     
     share_table <- combined_table[, c("cluster", "region", "region_share")]
     
     return(share_table)
}

##   Location Quotient Calculation
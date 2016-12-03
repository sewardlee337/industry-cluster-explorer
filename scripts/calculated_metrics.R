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
     
     cagr_table <- combined_table[, c('cluster', 'region', 'cagr')] %>%
          return()
}

##   Region Share Calculation

RegionShare <- function(data, metric) {
     
     ##   Keep relevant columns in dataset
     initial_table <- data[,c("cluster", "region", metric)]
     
     ##   Create dataframe with summed metric values by region
     sum_param <- paste0("sum(", metric,")")           ##   NOTE: This is necessary to deal with NSE in summarise_() function. 
     
     total_table <- group_by_(data, "region") %>%
          summarise_(sum_metric = sum_param) %>%
          as.data.frame()
     
     ##   Join regional total column to dataset
     combined_table <- inner_join(initial_table, total_table, by = "region")
     
     ##   Calculate regional shares
     combined_table$region_share <- combined_table[,metric] / combined_table$sum_metric 
     
     share_table <- combined_table[, c("cluster", "region", "region_share")] %>%
          return()
}

##   Location Quotient Calculation

LQ <- function(data, metric){
     
     ##   Keep relevant columns in dataset
     initial_table <- data[,c("cluster", "region", metric)]
     
     ##   Create dataframe with summed metric values by region
     sum_param <- paste0("sum(", metric,")")           ##   NOTE: This is necessary to deal with NSE in summarise_() function. 
                                                       ##   This parameter will be used in construction of both
     region_table <- group_by_(data, "region") %>%     ##   tables to be inner-joined with intial table.
          summarise_(sum_by_region = sum_param) %>%
          as.data.frame()
     
     combined_table <- inner_join(initial_table, region_table, by = "region")
     
     ##   Create dataframe with summed metric values by cluster
     cluster_table <- group_by_(data, "cluster") %>%
          summarise_(sum_by_cluster = sum_param) %>%
          as.data.frame()
     
     combined_table <- inner_join(combined_table, cluster_table, by = "cluster")
     
     ##   Find grand total for given metric
     initial_table <- initial_table[which(initial_table$region != "Total"),]      ##   Remove rows with "Total" to prevent double-counting.

     grand_total <- sum(initial_table[,metric])
     
     ##   Calculate location quotient
     combined_table$location_quotient <- (combined_table[,metric] / combined_table$sum_by_region) / (combined_table$sum_by_cluster / grand_total)
     
     lq_table <- combined_table[, c("cluster", "region", "location_quotient")] %>%
          return()
     
}
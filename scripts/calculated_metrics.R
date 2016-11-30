data2006 <- read.csv('cluster2006.csv', stringsAsFactors=FALSE)

data2011 <- read.csv('cluster2011.csv', stringsAsFactors=FALSE)


##   CAGR calculation

cagr <- function(begin, end, metric, years){
     
     ##   Keep columns needed for calculation
     
     begin_data <- begin[, c('cluster', 'region', metric)]
     end_data <- end[, c('cluster', 'region', metric)]
     
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
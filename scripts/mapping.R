library(leaflet)

map <- leaflet() %>%
     setView(lng = 121, lat = 23.6, zoom = 7) %>%
     addTiles()

map

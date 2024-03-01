library(data.table)

car_cols <- c("V1", "Power", "Aero", "Lightweight", "Grip")
driver_setup_cols <- c("Driver", "Team Principal", "Power Part 1", "Power Part 2", "Aero Part 1", "Aero Part 2", "Lightweight Part 1", "Lightweight Part 2", "Grip Part 1", "Grip Part 2", "Spanner Part 1", "Spanner Part 2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")
compare_cols <- c("Team", "Driver", "Team Principal", "Power Part 1", "Power Part 2", "Aero Part 1", "Aero Part 2", "Lightweight Part 1", "Lightweight Part 2", "Grip Part 1", "Grip Part 2", "Spanner Part 1", "Spanner Part 2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")
top_setup_cols <- c("Team", "Total")

inputs <- "/repos/parallel_r/inputs/"
outputs <- "/repos/parallel_r/outputs/"

cars <- fread(paste0(inputs, "Cars.csv"), select = car_cols)

top_setups <- data.frame(matrix(nrow = 0, ncol=length(top_setup_cols)))
names(top_setups) <- top_setup_cols

for (car in 1:nrow(cars)) {
  driver_setups <- fread(paste0(outputs, as.character(cars[car, "V1"]), "-setups-drivers.csv"), select = driver_setup_cols)
  top_setups[nrow(top_setups) +1, ] <- c(as.character(cars[car, "V1"]), as.numeric(driver_setups[1, "Total"]))
}

top_setups <- top_setups[order(top_setups$Total, decreasing = TRUE),]

compare <- data.frame(matrix(nrow = 0, ncol = length(compare_cols)))
names(compare) <- compare_cols

for (team in 1:nrow(top_setups)) {
  driver_setups <- fread(paste0(outputs, as.character(top_setups[team, "Team"]), "-setups-drivers.csv"), select = driver_setup_cols)

  if (team == 1) {
    print(paste("Adding", as.character(top_setups[team, "Team"]), "to compare", sep = " "))
    compare[nrow(compare) +1, ] <- c(
      top_setups[team, "Team"],
      driver_setups[team, "Driver"],
      driver_setups[team, "Team Principal"],
      driver_setups[team, "Power Part 1"],
      driver_setups[team, "Power Part 2"],
      driver_setups[team, "Aero Part 1"],
      driver_setups[team, "Aero Part 2"],
      driver_setups[team, "Lightweight Part 1"],
      driver_setups[team, "Lightweight Part 2"],
      driver_setups[team, "Grip Part 1"],
      driver_setups[team, "Grip Part 2"],
      driver_setups[team, "Spanner Part 1"],
      driver_setups[team, "Spanner Part 2"],
      driver_setups[team, "Power"],
      driver_setups[team, "Aero"],
      driver_setups[team, "Lightweight"],
      driver_setups[team, "Grip"],
      driver_setups[team, "Total"],
      driver_setups[team, "RD Points"]
    )
    next
  } else {
    out <- paste("Comparing", as.character(top_setups[team, "Team"]), "with existing setups", sep = " ")
    print(out)
    for (row in 1:nrow(driver_setups)) {
      if (any(compare == as.character(top_setups[team, "Team"]))) {
        # print(paste(as.character(top_setups[team, "Team"]), "already in table", sep = " "))
        break
      } else if (row == nrow(driver_setups)) {
        print(paste("All rows match. Adding", as.character(top_setups[team, "Team"]), "1 to compare", sep = " "))
        compare[nrow(compare) +1, ] <- c(
          top_setups[team, "Team"],
          driver_setups[1, "Driver"],
          driver_setups[1, "Team Principal"],
          driver_setups[1, "Power Part 1"],
          driver_setups[1, "Power Part 2"],
          driver_setups[1, "Aero Part 1"],
          driver_setups[1, "Aero Part 2"],
          driver_setups[1, "Lightweight Part 1"],
          driver_setups[1, "Lightweight Part 2"],
          driver_setups[1, "Grip Part 1"],
          driver_setups[1, "Grip Part 2"],
          driver_setups[1, "Spanner Part 1"],
          driver_setups[1, "Spanner Part 2"],
          driver_setups[1, "Power"],
          driver_setups[1, "Aero"],
          driver_setups[1, "Lightweight"],
          driver_setups[1, "Grip"],
          driver_setups[1, "Total"],
          driver_setups[1, "RD Points"]
        )
      } else if (any(compare == as.character(driver_setups[row, "Driver"]))) {
        # print(paste(as.character(top_setups[team, "Team"]), row, ultimate_driver_setups[row, "Driver"], "exists in table", sep = " "))
        next
      } else if (any(compare == as.character(driver_setups[row, "Team Principal"]))) {
        # print(paste(as.character(top_setups[team, "Team"]), row, driver_setups[row, "Team Principal"], "exists in table", sep = " "))
        next
      } else {
        print(paste("Adding", as.character(top_setups[team, "Team"]), row, "to compare", sep = " "))
        compare[nrow(compare) +1, ] <- c(
          top_setups[team, "Team"],
          driver_setups[row, "Driver"],
          driver_setups[row, "Team Principal"],
          driver_setups[row, "Power Part 1"],
          driver_setups[row, "Power Part 2"],
          driver_setups[row, "Aero Part 1"],
          driver_setups[row, "Aero Part 2"],
          driver_setups[row, "Lightweight Part 1"],
          driver_setups[row, "Lightweight Part 2"],
          driver_setups[row, "Grip Part 1"],
          driver_setups[row, "Grip Part 2"],
          driver_setups[row, "Spanner Part 1"],
          driver_setups[row, "Spanner Part 2"],
          driver_setups[row, "Power"],
          driver_setups[row, "Aero"],
          driver_setups[row, "Lightweight"],
          driver_setups[row, "Grip"],
          driver_setups[row, "Total"],
          driver_setups[row, "RD Points"]
        )
        break
      }
    }
  }
}

compare <<- compare[order(compare$Total, decreasing = TRUE),]
write.csv(compare, file = paste0(outputs, "compare.csv"), row.names = FALSE)

library(data.table)

args = commandArgs(trailingOnly=TRUE)

if (length(args)==0) {
  team <- 1
} else {
  team <- as.numeric(args[1])
}

car_cols <- c("V1", "Power", "Aero", "Lightweight", "Grip", "Total")
setup_cols <- c("Power Part 1", "Power Part 2", "Aero Part 1", "Aero Part 2", "Lightweight Part 1", "Lightweight Part 2", "Grip Part 1", "Grip Part 2", "Spanner Part 1", "Spanner Part 2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")
tp_cols <- c("Principal", "Power", "Aero", "Lightweight", "Grip", "RD Points")
tp_setup_cols <- c("Team Principal", "Power Part 1", "Power Part 2", "Aero Part 1", "Aero Part 2", "Lightweight Part 1", "Lightweight Part 2", "Grip Part 1", "Grip Part 2", "Spanner Part 1", "Spanner Part 2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")
driver_setup_cols <- c("Driver", "Team Principal", "Power Part 1", "Power Part 2", "Aero Part 1", "Aero Part 2", "Lightweight Part 1", "Lightweight Part 2", "Grip Part 1", "Grip Part 2", "Spanner Part 1", "Spanner Part 2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")

inputs <- "/repos/parallel_r/inputs/"
outputs <- "/repos/parallel_r/outputs/"

setups <- fread(paste0(outputs, "setups.csv"))
cars <- fread(paste0(inputs, "Cars-Table 1.csv"), select = car_cols)
tps <- fread(paste0(inputs, "Team Principals-Table 1.csv"), select = tp_cols)
drivers <- fread(paste0(inputs, "Drivers-Table 1.csv"), select = c("Driver", "Points", "RD Points"))

car_setups <- data.frame(matrix(nrow = 0, ncol = length(setup_cols)))
names(car_setups) <- setup_cols
car_setups_tps <- data.frame(matrix(nrow = 0, ncol = length(tp_setup_cols)))
names(car_setups_tps) <- tp_setup_cols
car_setups_drivers <- data.frame(matrix(nrow=0, ncol=length(driver_setup_cols)))
names(car_setups_drivers) <- driver_setup_cols


new_car_setup <- function(row) {
  car_setups[nrow(car_setups) +1, ] <- c(
    setups[row, "Power Part 1"],
    setups[row, "Power Part 2"],
    setups[row, "Aero Part 1"],
    setups[row, "Aero Part 2"],
    setups[row, "Lightweight Part 1"],
    setups[row, "Lightweight Part 2"],
    setups[row, "Grip Part 1"],
    setups[row, "Grip Part 2"],
    setups[row, "Spanner Part 1"],
    setups[row, "Spanner Part 2"],
    setups[row, "Power"] + cars[team, "Power"],
    setups[row, "Aero"] + cars[team, "Aero"],
    setups[row, "Lightweight"] + cars[team, "Lightweight"],
    setups[row, "Grip"] + cars[team, "Grip"],
    setups[row, "Total"] + cars[team, "Total"],
    setups[row, "RD Points"]
  )
}


team_setups <- function(team) {
  for (row in 1:nrow(setups)) {
    car_setups[nrow(car_setups) +1, ] <<- new_car_setup(row)
  }
  car_setups <<- car_setups[order(car_setups$Total, decreasing = TRUE),]
  write.csv(car_setups, file = paste0(outputs, as.character(cars[team, "V1"]), "-setups.csv"), row.names = FALSE)
}


team_principals <- function(team) {
  for (tp in 1:nrow(tps)) {
    print(as.character(tps[tp, "Principal"]))
    for (row in 1:1000) {
      car_setups_tps[nrow(car_setups_tps) +1, ] <<- c(
        tps[tp, "Principal"],
        car_setups[row, "Power Part 1"],
        car_setups[row, "Power Part 2"],
        car_setups[row, "Aero Part 1"],
        car_setups[row, "Aero Part 2"],
        car_setups[row, "Lightweight Part 1"],
        car_setups[row, "Lightweight Part 2"],
        car_setups[row, "Grip Part 1"],
        car_setups[row, "Grip Part 2"],
        car_setups[row, "Spanner Part 1"],
        car_setups[row, "Spanner Part 2"],
        car_setups[row, "Power"] * tps[tp, "Power"],
        car_setups[row, "Aero"] * tps[tp, "Aero"],
        car_setups[row, "Lightweight"] * tps[tp, "Lightweight"],
        car_setups[row, "Grip"] * tps[tp, "Grip"],
        ((car_setups[row, "Power"] * tps[tp, "Power"]) + (car_setups[row, "Aero"] * tps[tp, "Aero"]) + (car_setups[row, "Lightweight"] * tps[tp, "Lightweight"]) + (car_setups[row, "Grip"] * tps[tp, "Grip"])),
        car_setups[row, "RD Points"] + tps[tp, "RD Points"]
      )
    }
  }
  car_setups_tps <<- car_setups_tps[order(car_setups_tps$Total, decreasing = TRUE),]
  write.csv(car_setups_tps, file = paste0(outputs, as.character(cars[team, "V1"]), "-setups-tps.csv"), row.names = FALSE)
}


driver_setups <- function(team) {
  for (driver in 1:nrow(drivers)) {
    driver_name <- as.character(drivers[driver, "Driver"])
    print(driver_name)
    for (row in 1:750) {
      if (as.numeric(car_setups_tps[row, "RD Points"]) + as.numeric(drivers[driver, "RD Points"]) > 100) {
        next
      }
      else {
        car_setups_drivers[nrow(car_setups_drivers) +1, ] <<- c(
          drivers[driver, "Driver"],
          car_setups_tps[row, "Team Principal"],
          car_setups_tps[row, "Power Part 1"],
          car_setups_tps[row, "Power Part 2"],
          car_setups_tps[row, "Aero Part 1"],
          car_setups_tps[row, "Aero Part 2"],
          car_setups_tps[row, "Lightweight Part 1"],
          car_setups_tps[row, "Lightweight Part 2"],
          car_setups_tps[row, "Grip Part 1"],
          car_setups_tps[row, "Grip Part 2"],
          car_setups_tps[row, "Spanner Part 1"],
          car_setups_tps[row, "Spanner Part 2"],
          car_setups_tps[row, "Power"],
          car_setups_tps[row, "Aero"],
          car_setups_tps[row, "Lightweight"],
          car_setups_tps[row, "Grip"],
          car_setups_tps[row, "Total"] + drivers[driver, "Points"],
          car_setups_tps[row, "RD Points"] + drivers[driver, "RD Points"]
        )
      }
    }
  }
  car_setups_drivers <<- car_setups_drivers[order(car_setups_drivers$Total, decreasing = TRUE),]
  write.csv(car_setups_drivers, file = paste0(outputs, as.character(cars[team, "V1"]), "-setups-drivers.csv"), row.names = FALSE)
}

print(as.character(cars[team, "V1"]))
print("Team setups:")
team_setups(team)
print("Team Principals:")
team_principals(team)
print("Drivers:")
driver_setups(team)

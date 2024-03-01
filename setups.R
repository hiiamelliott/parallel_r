library(data.table)
library(dplyr)

part_cols <- c("Part", "Category", "Power", "Aero", "Lightweight", "Grip", "RD Points")
combo_cols <- c("Part1", "Part2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")
setup_cols <- c("Power Part 1", "Power Part 2", "Aero Part 1", "Aero Part 2", "Lightweight Part 1", "Lightweight Part 2", "Grip Part 1", "Grip Part 2", "Spanner Part 1", "Spanner Part 2", "Power", "Aero", "Lightweight", "Grip", "Total", "RD Points")

inputs <- "/domino/datasets/local/parallel_r/inputs/"
outputs <- "/domino/datasets/local/parallel_r/outputs/"

parts <- fread(paste0(inputs, "Parts-Table 1.csv"), select = part_cols)

read_parts <- function(category) {
  parts[parts$Category == category] %>% mutate(Power = ifelse(is.na(Power), 0, Power),
                                               Aero = ifelse(is.na(Aero), 0, Aero),
                                               Lightweight = ifelse(is.na(Lightweight), 0, Lightweight),
                                               Grip = ifelse(is.na(Grip), 0, Grip)
                                               )
}

power_parts <- read_parts("Power")
aero_parts <- read_parts("Aero")
lw_parts <- read_parts("Lightweight")
grip_parts <- read_parts("Grip")
spanner_parts <- read_parts("Spanners")

# Create DF for combinations of Power parts

power_combos <- data.frame(matrix(nrow = 0, ncol = length(combo_cols)))
names(power_combos) <- combo_cols

# Create a row for each possible combination of parts
for (part1 in 1:nrow(power_parts)) {
  part2 <- part1 + 1
  while (part2 <= nrow(power_parts)) {
    power_combos[nrow(power_combos) + 1,] <- c(
      power_parts[part1, "Part"],
      power_parts[part2, "Part"],
      power_parts[part1, "Power"] + power_parts[part2, "Power"],
      power_parts[part1, "Aero"] + power_parts[part2, "Aero"],
      power_parts[part1, "Lightweight"] + power_parts[part2, "Lightweight"],
      power_parts[part1, "Grip"] + power_parts[part2, "Grip"],
      (power_parts[part1, "Power"] + power_parts[part2, "Power"] + power_parts[part1, "Aero"] + power_parts[part2, "Aero"] + power_parts[part1, "Lightweight"] + power_parts[part2, "Lightweight"] + power_parts[part1, "Grip"] + power_parts[part2, "Grip"]),
      power_parts[part1, "RD Points"] + power_parts[part2, "RD Points"]
    )
    part2 <- part2 + 1
  }
  power_combos <- power_combos[order(power_combos$Total, decreasing = TRUE),]
}

# Create DF for combinations of Aero parts
aero_combos <- data.frame(matrix(nrow = 0, ncol = length(combo_cols)))
names(aero_combos) <- combo_cols

#Create a row for each possible combination of parts
for (part1 in 1:nrow(aero_parts)) {
  part2 <- part1 + 1
  while (part2 <= nrow(aero_parts)) {
    aero_combos[nrow(aero_combos)+1, ] <- c(
      aero_parts[part1, "Part"],
      aero_parts[part2, "Part"],
      aero_parts[part1, "Power"] + aero_parts[part2, "Power"],
      aero_parts[part1, "Aero"] + aero_parts[part2, "Aero"],
      aero_parts[part1, "Lightweight"] + aero_parts[part2, "Lightweight"],
      aero_parts[part1, "Grip"] + aero_parts[part2, "Grip"],
      (aero_parts[part1, "Power"] + aero_parts[part2, "Power"] + aero_parts[part1, "Aero"] + aero_parts[part2, "Aero"] + aero_parts[part1, "Lightweight"] + aero_parts[part2, "Lightweight"] + aero_parts[part1, "Grip"] + aero_parts[part2, "Grip"]),
      aero_parts[part1, "RD Points"] + aero_parts[part2, "RD Points"]
    )
    part2 <- part2 + 1
  }
  aero_combos <- aero_combos[order(aero_combos$Total, decreasing = TRUE),]
}

# Create DF for combinations of Lightweight parts
lw_combos <- data.frame(matrix(nrow = 0, ncol = length(combo_cols)))
names(lw_combos) <- combo_cols

# Create a row for each possible combination of parts
for (part1 in 1:nrow(lw_parts)) {
  part2 <- part1 + 1
  while (part2 <= nrow(lw_parts)) {
    lw_combos[nrow(lw_combos)+1, ] <- c(
      lw_parts[part1, "Part"],
      lw_parts[part2, "Part"],
      lw_parts[part1, "Power"] + lw_parts[part2, "Power"],
      lw_parts[part1, "Aero"] + lw_parts[part2, "Aero"],
      lw_parts[part1, "Lightweight"] + lw_parts[part2, "Lightweight"],
      lw_parts[part1, "Grip"] + lw_parts[part2, "Grip"],
      (lw_parts[part1, "Power"] + lw_parts[part2, "Power"] + lw_parts[part1, "Aero"] + lw_parts[part2, "Aero"] + lw_parts[part1, "Lightweight"] + lw_parts[part2, "Lightweight"] + lw_parts[part1, "Grip"] + lw_parts[part2, "Grip"]),
      lw_parts[part1, "RD Points"] + lw_parts[part2, "RD Points"]
    )
    part2 <- part2 + 1
  }
  lw_combos <- lw_combos[order(lw_combos$Total, decreasing = TRUE),]
}

# Create DF for combinations of Grip parts
grip_combos <- data.frame(matrix(nrow = 0, ncol = length(combo_cols)))
names(grip_combos) <- combo_cols

# Create a row for each possible combination of parts
for (part1 in 1:nrow(grip_parts)) {
  part2 <- part1 + 1
  while (part2 <= nrow(grip_parts)) {
    grip_combos[nrow(grip_combos)+1, ] <- c(
      grip_parts[part1, "Part"],
      grip_parts[part2, "Part"],
      grip_parts[part1, "Power"] + grip_parts[part2, "Power"],
      grip_parts[part1, "Aero"] + grip_parts[part2, "Aero"],
      grip_parts[part1, "Lightweight"] + grip_parts[part2, "Lightweight"],
      grip_parts[part1, "Grip"] + grip_parts[part2, "Grip"],
      (grip_parts[part1, "Power"] + grip_parts[part2, "Power"] + grip_parts[part1, "Aero"] + grip_parts[part2, "Aero"] + grip_parts[part1, "Lightweight"] + grip_parts[part2, "Lightweight"] + grip_parts[part1, "Grip"] + grip_parts[part2, "Grip"]),
      grip_parts[part1, "RD Points"] + grip_parts[part2, "RD Points"]
    )
    part2 <- part2 + 1
  }
  grip_combos <- grip_combos[order(grip_combos$Total, decreasing = TRUE),]
}

# Create DF for combinations of Spanner parts
spanner_combos <- data.frame(matrix(nrow = 0, ncol = length(combo_cols)))
names(spanner_combos) <- combo_cols

# Create a row for each possible combination of parts
for (part1 in 1:nrow(spanner_parts)) {
  part2 <- part1 + 1
  while (part2 <= nrow(spanner_parts)) {
    spanner_combos[nrow(spanner_combos)+1, ] <- c(
      spanner_parts[part1, "Part"],
      spanner_parts[part2, "Part"],
      spanner_parts[part1, "Power"] + spanner_parts[part2, "Power"],
      spanner_parts[part1, "Aero"] + spanner_parts[part2, "Aero"],
      spanner_parts[part1, "Lightweight"] + spanner_parts[part2, "Lightweight"],
      spanner_parts[part1, "Grip"] + spanner_parts[part2, "Grip"],
      (spanner_parts[part1, "Power"] + spanner_parts[part2, "Power"] + spanner_parts[part1, "Aero"] + spanner_parts[part2, "Aero"] + spanner_parts[part1, "Lightweight"] + spanner_parts[part2, "Lightweight"] + spanner_parts[part1, "Grip"] + spanner_parts[part2, "Grip"]),
      spanner_parts[part1, "RD Points"] + spanner_parts[part2, "RD Points"]
    )
    part2 <- part2 + 1
  }
  spanner_combos <- spanner_combos[order(spanner_combos$Total, decreasing = TRUE),]
}

# Create list of possible setups
setups <- data.frame(matrix(nrow = 0, ncol = length(setup_cols)))
names(setups) <- setup_cols

print("Setups:")
new_setup <- function(power_combo, aero_combo, lw_combo, grip_combo, spanner_combo) {
  newsetup <- c(
    power_combos[power_combo, "Part1"],
    power_combos[power_combo, "Part2"],
    aero_combos[aero_combo, "Part1"],
    aero_combos[aero_combo, "Part2"],
    lw_combos[lw_combo, "Part1"],
    lw_combos[lw_combo, "Part2"],
    grip_combos[grip_combo, "Part1"],
    grip_combos[grip_combo, "Part2"],
    spanner_combos[spanner_combo, "Part1"],
    spanner_combos[spanner_combo, "Part2"],
    power_combos[power_combo, "Power"] + aero_combos[aero_combo, "Power"] + lw_combos[lw_combo, "Power"] + grip_combos[grip_combo, "Power"] + spanner_combos[spanner_combo, "Power"],
    power_combos[power_combo, "Aero"] + aero_combos[aero_combo, "Aero"] + lw_combos[lw_combo, "Aero"] + grip_combos[grip_combo, "Aero"] + spanner_combos[spanner_combo, "Aero"],
    power_combos[power_combo, "Lightweight"] + aero_combos[aero_combo, "Lightweight"] + lw_combos[lw_combo, "Lightweight"] + grip_combos[grip_combo, "Lightweight"] + spanner_combos[spanner_combo, "Lightweight"],
    power_combos[power_combo, "Grip"] + aero_combos[aero_combo, "Grip"] + lw_combos[lw_combo, "Grip"] + grip_combos[grip_combo, "Grip"] + spanner_combos[spanner_combo, "Grip"],
    power_combos[power_combo, "Total"] + aero_combos[aero_combo, "Total"] + lw_combos[lw_combo, "Total"] + grip_combos[grip_combo, "Total"] + spanner_combos[spanner_combo, "Total"],
    power_combos[power_combo, "RD Points"] + aero_combos[aero_combo, "RD Points"] + lw_combos[lw_combo, "RD Points"] + grip_combos[grip_combo, "RD Points"] + spanner_combos[spanner_combo, "RD Points"]
  )
  return(newsetup)
}

combos <- 7
system.time(
  for (power_combo in 1:combos) {
    for (aero_combo in 1:combos) {
      for (lw_combo in 1:combos) {
        for (grip_combo in 1:combos) {
          for (spanner_combo in 1:combos) {
            setups[nrow(setups)+1, ] <- new_setup(power_combo, aero_combo, lw_combo, grip_combo, spanner_combo)
          }
        }
      }
    }
  }
)

setups <- setups[order(setups$Total, decreasing = TRUE),]
write.csv(setups, file = paste0(outputs, "setups.csv"), row.names = FALSE)

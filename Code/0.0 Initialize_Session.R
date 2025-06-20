# Code 0.0: Initialize Session ----
# Run this script once at the beginning of your R session

## Load Setup and Settings ----
source("Code/0.0 Setup.R")
source("Code/0.1 Settings.R")
source("Code/0.2 Functions.R")

## Quick Status Check ----
cat("\n=== SESSION STATUS ===\n")
cat("✓ Setup loaded\n")
cat("✓ Settings applied\n")
cat("✓ Functions loaded\n")
cat("✓ Packages verified\n")
cat("✓ Directories checked\n\n")

## Available Functions ----
cat("=== AVAILABLE FUNCTIONS ===\n")
cat("• verify_packages(force_reload = FALSE) - Load missing packages\n")
cat("• check_packages_loaded() - Check if all packages are loaded\n")
cat("• descriptives(x, data) - Generate descriptive statistics\n\n")

## Session Ready ----
cat("=== SESSION READY ===\n")
cat("You can now run your analysis scripts:\n")
cat("• Code/1.0 Process_data.R\n")
cat("• Code/2.0 Descriptives.R\n")
cat("• Code/3.0 Logit Models.R\n\n")

# Clear console for cleaner output
cat("\nR session initialized successfully!\n") 
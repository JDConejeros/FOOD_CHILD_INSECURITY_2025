# Code 0.0: Setup Environment ----

## Package Management ----

# List of required packages
required_packages <- c(
  # Data manipulation and analysis
  "tidyverse",    # Data manipulation and visualization
  "rio",          # Data import/export
  "haven",        # Import SAS, SPSS, Stata files
  "survey",       # Survey analysis
  "srvyr",        # Survey analysis with tidyverse
  "writexl",       # Save excel files
  
  # Modeling
  "broom",        # Tidy model outputs
  "car",          # Companion to Applied Regression
  "pROC",         # ROC curves
  "ResourceSelection", # Hosmer-Lemeshow test
  "MASS",          # Binomial negative models 
  "pscl",          # Zero inflated models
  
  # Output
  "openxlsx",     # Excel files
  "knitr",        # Dynamic report generation
  "rmarkdown",    # R Markdown
  "kableExtra",   # Enhanced table formatting
  "tableone",     # Summary tables
  "gtsummary",     # Edit table format
  "chilemapas",     # Maps
  
  # Visualization
  "ggplot2",      # Advanced plotting
  "ggthemes",     # Additional themes
  "scales",       # Scale functions for visualization
  "ggridges",     # Special plot
  "patchwork",    # Compile plots
  "sf",           # Plot maps
  "ggrepel",      # Especial plots
  "ggpubr",        # Sort plots
  "patchwork",     # Plot save
  
  # Development
  "devtools",     # Development tools
  "roxygen2",     # Documentation
  "testthat"      # Testing
)

# Function to install and load packages efficiently
install_and_load <- function(package) {
  if (!require(package, character.only = TRUE, quietly = TRUE)) {
    install.packages(package, quiet = TRUE)
    library(package, character.only = TRUE, quietly = TRUE)
  }
}

# Function to verify and load required packages (only if not already loaded)
verify_packages <- function(force_reload = FALSE) {
  if (force_reload) {
    # Force reload all packages
    cat("Forcing reload of all packages...\n")
    sapply(required_packages, install_and_load)
  } else {
    # Only load packages that aren't already loaded
    not_loaded <- required_packages[!sapply(required_packages, require, character.only = TRUE, quietly = TRUE)]
    if (length(not_loaded) > 0) {
      cat("Loading packages:", paste(not_loaded, collapse = ", "), "\n")
      sapply(not_loaded, install_and_load)
    } else {
      cat("All required packages are already loaded.\n")
    }
  }
  
  # Return TRUE if all packages are loaded successfully
  all(sapply(required_packages, require, character.only = TRUE, quietly = TRUE))
}

# Function to check if packages are loaded (without loading them)
check_packages_loaded <- function() {
  loaded_packages <- sapply(required_packages, require, character.only = TRUE, quietly = TRUE)
  if (all(loaded_packages)) {
    cat("All required packages are loaded.\n")
    return(TRUE)
  } else {
    missing_packages <- required_packages[!loaded_packages]
    cat("Missing packages:", paste(missing_packages, collapse = ", "), "\n")
    return(FALSE)
  }
}

# Initial package loading (only if not already loaded)
if (!check_packages_loaded()) {
  verify_packages()
}

## Verify project structure ----
# Expected directory structure
expected_dirs <- c(
  "Input",
  "Output",
  "Code",
  "Paper"
  #"Figures",
  #"Tables"
)

# Check which directories exist and which need to be created
missing_dirs <- expected_dirs[!dir.exists(expected_dirs)]

if (length(missing_dirs) > 0) {
  # Create only missing directories
  sapply(missing_dirs, function(dir) {
    dir.create(dir)
    cat("Created directory:", dir, "\n")
  })
} else {
  cat("All required directories already exist.\n")
}

## Save session info ----
session_info <- sessionInfo()
saveRDS(session_info, "Output/session_info.rds")

## Print setup completion message ----
cat("\nSetup completed successfully!\n")
cat("Package environment verified.\n")
cat("Session info saved to Output/session_info.rds\n\n")

# Export the functions to the global environment
assign("verify_packages", verify_packages, envir = .GlobalEnv)
assign("check_packages_loaded", check_packages_loaded, envir = .GlobalEnv) 
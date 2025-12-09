library(dplyr)

# First export the CSV files using export_*.sh, you will need the occurrence parquet dataset and DuckDB
# TODO: filter out absences

# Read the CSV files

occurrence <- readr::read_csv("data/occurrence.csv")
dna <- readr::read_csv("data/dna.csv")
mof <- readr::read_csv("data/mof.csv")

# Why are there more dna records than occurrence records?
# (expected for mof but maybe less so for dna)
# -> some cases of multiple sequences for a single occurrence

n_distinct(dna$`_id`)
dna %>% 
  filter(dna[duplicated(dna["_id"]),])

multiple_sequences <- dna %>% 
  group_by(`_id`) %>% 
  filter(n() > 1) %>% 
  arrange(`_id`)

# Check identifier integrity
# -> OK

which(! dna$`_id` %in% occurrence$`_id`)  # 1
which(! mof$`_id` %in% occurrence$`_id`)  # 1

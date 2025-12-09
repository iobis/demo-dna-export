# demo-dna-export

This is a demo of exporting Occurrence, MeasurementOrFact, and DNADerivedData records as CSV from the OBIS Open Data occurrence dataset. 

## How to

- Optionally download the occurrence dataset from AWS following the instruction at https://github.com/iobis/obis-open-data
- Install DuckDB and export the CSV files from either the local dataset (`export_local.sh`) or the AWS S3 hosted dataset (`export_s3.sh`, this will be slower)
- See `script.R` for some data exploration in R, note that the extension records can be joined to the occurrence records using the `_id` column

# demo-dna-export

This is a demo of exporting Occurrence, MeasurementOrFact, and DNADerivedData records as CSV from the OBIS Open Data occurrence dataset. 

## How to

- Optionally download the occurrence dataset from AWS following the instruction at https://github.com/iobis/obis-open-data. Note that having the dataset locally will speed things up significantly. The size of the dataset is around 65 GB (December 2025).
- Install DuckDB and export the CSV files from either the local dataset (`export_local.sh`, this should be fast) or the AWS S3 hosted dataset (`export_s3.sh`, this will be slower). This only exports records which have DNADerivedData as well as MeasurementOrFact, adjust as needed.
- See `script.R` for some data checking in R, note that the extension records can be joined to the occurrence records using the `_id` column.

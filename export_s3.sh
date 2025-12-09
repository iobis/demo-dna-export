#!/bin/bash

# Exit on error
set -e

echo "Starting DuckDB data export..."

# Export occurrence data
echo "Exporting occurrence data..."
duckdb -c "
COPY (
  SELECT 
    _id,
    dataset_id,
    interpreted.*
  FROM read_parquet('s3://obis-open-data/occurrence/*.parquet')
  WHERE len(extensions.\"http://rs.gbif.org/terms/1.0/DNADerivedData\") > 0
  AND len(extensions.\"http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact\") > 0
) TO 'data/occurrence.csv' (HEADER, DELIMITER ',');
"

# Export DNA data
echo "Exporting DNA derived data..."
duckdb -c "
COPY (
  WITH unnested AS (
    SELECT 
      _id,
      dataset_id,
      UNNEST(extensions.\"http://rs.gbif.org/terms/1.0/DNADerivedData\") AS dna_data
    FROM read_parquet('s3://obis-open-data//occurrence/*.parquet')
    WHERE len(extensions.\"http://rs.gbif.org/terms/1.0/DNADerivedData\") > 0
    AND len(extensions.\"http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact\") > 0
  ),
  expanded AS (
    SELECT 
      _id, 
      dataset_id, 
      dna_data._event_id,
      dna_data._id AS dna_id,
      dna_data._occurrence_id,
      dna_data.id,
      dna_data.level,
      dna_data.source AS source_data
    FROM unnested
  )
  SELECT _id, dataset_id, _event_id, dna_id, _occurrence_id, id, level, source_data.* 
  FROM expanded
) TO 'data/dna.csv' (HEADER, DELIMITER ',');
"

# Export MOF data
echo "Exporting measurement or fact data..."
duckdb -c "
COPY (
  WITH unnested AS (
    SELECT 
      _id,
      dataset_id,
      UNNEST(extensions.\"http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact\") AS mof_data
    FROM read_parquet('s3://obis-open-data//occurrence/*.parquet')
    WHERE len(extensions.\"http://rs.gbif.org/terms/1.0/DNADerivedData\") > 0
    AND len(extensions.\"http://rs.iobis.org/obis/terms/ExtendedMeasurementOrFact\") > 0
  ),
  expanded AS (
    SELECT 
      _id, 
      dataset_id, 
      mof_data._event_id,
      mof_data._id AS mof_id,
      mof_data._occurrence_id,
      mof_data.id,
      mof_data.level,
      mof_data.source AS source_data
    FROM unnested
  )
  SELECT _id, dataset_id, _event_id, mof_id, _occurrence_id, id, level, source_data.*
  FROM expanded
) TO 'data/mof.csv' (HEADER, DELIMITER ',');
"

echo "Export complete!"
echo "Created files:"
echo "  - occurrence.csv"
echo "  - dna.csv"
echo "  - mof.csv"
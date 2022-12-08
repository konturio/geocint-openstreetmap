# geocint-openstreetmap

## geocint processing pipeline

Geocint is Kontur's open source geodata ETL/CI/CD pipeline designed for ease of maintenance and high single-node throughput. Writing
the code as Geocint target makes sure that it is fully recorded, can be run autonomously, can be inspected, reviewed and
tested by other team members, and will automatically produce new artifacts once new input data comes in.

geocint-openstreetmap is a part of [Geocint](https://github.com/konturio/geocint-runner) pipeline.
This repo contains chain of targets for downloading, updating and uploading to the database OpenStreetMap planet dump

For more information please see [Geocint readme](https://github.com/konturio/geocint-runner/blob/main/README.md)

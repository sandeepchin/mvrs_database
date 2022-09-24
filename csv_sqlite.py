# Code to transform a CSV file to a sqlite db

import csv_to_sqlite 

# All the usual options are supported
options = csv_to_sqlite.CsvOptions(typing_style="full", encoding="windows-1250") 
input_files = ["combined_20220915.csv"] # pass in a list of CSV files
csv_to_sqlite.write_csv(input_files, "mvrs_db.sqlite", options)
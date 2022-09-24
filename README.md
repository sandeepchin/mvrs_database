# mvrs_database

To initially create the database from an existing csv file use the csv-to-sqlite library.
The code in csv_sqlite.py will read a csv file and upload the contents to a table in sqlite db.

<b> python csv_sqlite.py </b>

Once data is stored we can insert data periodically using running:

# python insert_new_data.py -i sometextfile.txt

where sometextfile.txt is the tab separated text file.

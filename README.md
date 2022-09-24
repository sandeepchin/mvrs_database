# mvrs_database

To initially create the database from an existing csv file use the csv-to-sqlite library.
The code in csv_sqlite.py will read a csv file and upload the contents to a table in sqlite db.

<b> python csv_sqlite.py </b>

Once the initial data is stored, we can insert data periodically by running:

<b> python insert_new_data.py -i sometextfile.txt </b>

where sometextfile.txt is a tab separated input data file.

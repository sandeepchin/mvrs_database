# Python program to update mvrs database with new records for the week

import sqlite3
import sys
import os
from argparse import ArgumentParser
import set_path

# Global variables
# Set path to location where input files are located
path = set_path.path
conn: sqlite3.Connection = None

# Connect to local sqlite db
def connect():
    global conn
    conn = sqlite3.connect('mvrs_db.sqlite',isolation_level=None)


# Get current row count from table
def get_row_count():
    if not conn:
        connect()
    query = 'select max(row_id) from mvrs_data'
    try:
        results = conn.execute(query).fetchall()
    except sqlite3.DatabaseError as e:
        print(e)
    return results[0][0] #return first value in first tuple from list
  
 
#Process a row of the input file and insert into db
def process_line(columns,values,row_num):
    params=['?']
    # Prepare column values and parameters
    for i in range(len(values)):
        values[i]= values[i].strip()
        params.append('?')
    values.append(row_num)
    query = f'insert into mvrs_data ({",".join(columns)}) values ({",".join(params)})'
    try:
        conn.execute(query,values)
    except sqlite3.DatabaseError as e:
        print('%s',e)
    return 
 
# Process input file's header and call process_line() for every line
def process_file(filepath:str):
    if not conn:
        connect()
    file = open(filepath,'r')
    lines = file.readlines()
    header = lines[0].strip()
    columns = header.split('\t') # tab separated file
    columns =[c.strip() for c in columns]
    columns.append('row_id')
    # Get row count from db to know the next row num
    row_count = get_row_count()
    num_lines=0
    # Process each line
    for i in range(1,len(lines)):
        values=lines[i].split('\t')
        row_count+=1
        num_lines+=1
        process_line(columns,values,row_count)
    return num_lines
        
#If running this code as stand alone
if __name__ == '__main__':
    infile_path = os.path.join(path,'mvrs_uploads')
    infile = ''
    # Create parser object and add options
    parser = ArgumentParser()
    parser.add_argument("-i","--ifile",required=True)
    # Parse command line input
    args= parser.parse_args(sys.argv[1:])
    infile = args.ifile
    infile_path = os.path.join(infile_path,infile)
    print('Processing',infile)
    num_rows = process_file(infile_path)
    print('Inserted',num_rows,'rows')

    
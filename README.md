# Simple AppleScript wrapper for Sqlite3 #

### Warning

Personally, I would not use this file unless AppleScript was absolutely the only option I had.  
That said, hope this helps anyone in that position.  

The initial folder holding the database is created here.  

    ~/Library/Application Support/FOLDER_NAME

# Properties #

    @property SUPPORT_FOLDER : missing value
    @property FOLDER_NAME : missing value
    @property DATABASE_NAME : missing value
    @property FILE_PATH : missing value
    @property HEAD : missing value
    @property TAIL : quote

# Functions #


    createBaseFolder()
    setHead()
    create_table(table_name, column_names_array)
    insert(table_name, the_values)
    update(table_name, the_fields, the_values, search_field, search_value)
    addColumn(table_name, col_name)
    select_(column_names_array, table_name, search_field, search_value)
    select_all(table_name)
    select_all_where(table_name, search_field, search_value)
    delete_where(table_name, search_field, search_value)
    delete_every_row(table_name)
    delete_table(table_name)
    executeSQL(sql_statement)

# Example Usage:
  Change the path to location of this file
  
    set path_to_this_file to ((path to desktop as string) & "sqlite_class.scpt")
    set script_file to load script file path_to_this_file
    set SQLite to script_file's SQLite
    set SQLite's FOLDER_NAME to "base_folder"
    set SQLite's DATABASE_NAME to "data_base"
    SQLite's createBaseFolder()
    SQLite's setHead()
    SQLite's create_table("people", {"name", "age"})
    SQLite's insert("people", {"Tom", "44"})
    SQLite's insert("people", {"Annie", "34"})
    SQLite's select_({"name", "age"}, "people", "name", "Annie")

# License #

Copyright (c) 2011 Craig Williams

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

(*
Example Usage:
# Change the path to location of this file
set path_to_this_file to ((path to desktop as string) & "sqlite.scpt")
set sql_class_script to load script file path_to_this_file
set SQLite to sql_class_script's SQLite
set SQLite's FOLDER_NAME to "base_folder"
set SQLite's DATABASE_NAME to "data_base"
SQLite's createBaseFolder()
SQLite's setHead()
SQLite's create_table("people", {"name", "age"})
SQLite's insert("people", {"Tom", "44"})
SQLite's insert("people", {"Annie", "34"})
set theValues to SQLite's select_({"name", "age"}, "people", "name", "Annie")
*)

script SQLite
	
	property SUPPORT_FOLDER : missing value
	property FOLDER_NAME : missing value
	property DATABASE_NAME : missing value
	property FILE_PATH : missing value
	property HEAD : missing value
	property TAIL : quote
	
	#==============================================================
	# Setup
	#==============================================================
	on createBaseFolder()
		set SUPPORT_FOLDER to (path to application support from user domain)
		tell application "Finder"
			set folder_path to (SUPPORT_FOLDER & FOLDER_NAME) as string
			if not (exists folder folder_path) then
				make folder at SUPPORT_FOLDER with properties {name:FOLDER_NAME}
			end if
		end tell
	end createBaseFolder
	
	on setHead()
		set f_path to SUPPORT_FOLDER & FOLDER_NAME & ":" & DATABASE_NAME & ".db" as string
		set FILE_PATH to quoted form of POSIX path of f_path
		set file_location to space & FILE_PATH & space
		set HEAD to "sqlite3" & file_location & quote
	end setHead
	
	#==============================================================
	# Functions
	#==============================================================
	on create_table(table_name, column_names_array)
		set column_names_string to my commaSepQuotedString(column_names_array)
		set statement to "create table if not exists " & table_name & "(" & column_names_string & "); "
		executeSQL(statement)
	end create_table
	
	on insert(table_name, the_values)
		try
			set the_values to my commaSepQuotedString(the_values)
			set statement to "insert into " & table_name & " values(" & the_values & "); "
			executeSQL(statement)
		on error e
			display dialog "There was an error while inserting." & return & e
		end try
	end insert
	
	on update(table_name, the_fields, the_values, search_field, search_value)
		repeat with i from 1 to count of the_fields
			set this_item to item i of the_fields
			set statement to ("UPDATE " & table_name & " set " & this_item & " = '" & ¬
				item i of the_values & "' WHERE " & search_field & " = '" & search_value & "'; " as string)
			executeSQL(statement)
		end repeat
	end update
	
	on addColumn(table_name, col_name)
		set statement to ("ALTER table " & table_name & " add " & col_name & "; " as string)
		executeSQL(statement)
	end addColumn
	
	on select_(column_names_array, table_name, search_field, search_value)
		set column_names_string to my commaSepString(column_names_array)
		set statement to ("SELECT " & column_names_string & " FROM " & table_name & ¬
			" WHERE " & search_field & " = '" & search_value & "'; " as string)
		return executeSQL(statement)
	end select_
	
	on select_all(table_name)
		set statement to ("SELECT * FROM " & table_name & " ; " as string)
		set execute to (executeSQL(statement))
		return my tidStuff(return, execute)
	end select_all
	
	on select_all_where(table_name, search_field, search_value)
		set statement to ("SELECT * FROM " & table_name & " WHERE " & ¬
			search_field & " = " & search_value & " ; " as string)
		set execute to (executeSQL(statement))
		return my tidStuff(return, execute)
	end select_all_where
	
	on delete_where(table_name, search_field, search_value)
		set statement to ("DELETE FROM " & table_name & " WHERE " & ¬
			search_field & " = " & search_value & " ; " as string)
		executeSQL(statement)
	end delete_where
	
	on delete_every_row(table_name)
		set statement to ("DELETE FROM " & table_name & "; " as string)
		executeSQL(statement)
	end delete_every_row
	
	on delete_table(table_name)
		set statement to ("DELETE " & table_name & "; " as string)
		executeSQL(statement)
	end delete_table
	
	#==============================================================
	# Private
	#==============================================================
	on executeSQL(statement)
		return (do shell script HEAD & statement & TAIL)
	end executeSQL
	
	on tidStuff(paramHere, textHere)
		set OLDtid to AppleScript's text item delimiters
		set AppleScript's text item delimiters to paramHere
		set theItems to text items of textHere
		set AppleScript's text item delimiters to OLDtid
		return theItems
	end tidStuff
	
	on commaSepQuotedString(the_array)
		set return_string to ""
		if length of the_array > 1 then
			repeat with i from 1 to count of the_array
				set this_item to item i of the_array
				set return_string to return_string & "'" & this_item & "', "
			end repeat
			return text 1 thru -3 of return_string as string
		else
			return item 1 of the_array
		end if
	end commaSepQuotedString
	
	on commaSepString(the_array)
		set return_string to ""
		if length of the_array > 1 then
			repeat with i from 1 to count of the_array
				set this_item to item i of the_array
				set return_string to return_string & this_item & ", "
			end repeat
			return text 1 thru -3 of return_string as string
		else
			return item 1 of the_array
		end if
	end commaSepString
end script

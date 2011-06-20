(*
Example Usage:
# Change the path to location of this file
set path_to_this_file to ((path to desktop as string) & "sqlite_class.scpt")
set sql_class_script to load script file path_to_this_file
set sql_class to sql_class_script's SQLiteClass
set sql_class's FOLDER_NAME to "base_folder"
set sql_class's DATABASE_NAME to "data_base"
sql_class's createBaseFolder()
sql_class's setHead()
sql_class's sql_create_table("people", {"name", "age"})
sql_class's sql_insert("people", {"Tom", "44"})
sql_class's sql_insert("people", {"Annie", "34"})
sql_class's sql_select({"name", "age"}, "people", "name", "Annie")
*)

script SQLiteClass
	
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
	on sql_create_table(table_name, column_names_array)
		set column_names_string to my commaSepQuotedString(column_names_array)
		set sql_statement to "create table if not exists " & table_name & "(" & column_names_string & "); "
		executeSQL(sql_statement)
	end sql_create_table
	
	on sql_insert(table_name, the_values)
		try
			set the_values to my commaSepQuotedString(the_values)
			set sql_statement to "insert into " & table_name & " values(" & the_values & "); "
			executeSQL(sql_statement)
		on error e
			display dialog "There was an error while inserting." & return & e
		end try
	end sql_insert
	
	on sql_update(table_name, the_fields, the_values, search_field, search_value)
		repeat with i from 1 to count of the_fields
			set this_item to item i of the_fields
			set sql_statement to ("UPDATE " & table_name & " set " & this_item & " = '" & ¬
				item i of the_values & "' WHERE " & search_field & " = '" & search_value & "'; " as string)
			executeSQL(sql_statement)
		end repeat
	end sql_update
	
	on sql_addColumn(table_name, col_name)
		set sql_statement to ("ALTER table " & table_name & " add " & col_name & "; " as string)
		executeSQL(sql_statement)
	end sql_addColumn
	
	on sql_select(column_names_array, table_name, search_field, search_value)
		set column_names_string to my commaSepString(column_names_array)
		set sql_statement to ("SELECT " & column_names_string & " FROM " & table_name & ¬
			" WHERE " & search_field & " = '" & search_value & "'; " as string)
		return executeSQL(sql_statement)
	end sql_select
	
	on sql_select_all(table_name)
		set sql_statement to ("SELECT * FROM " & table_name & " ; " as string)
		set sql_execute to (executeSQL(sql_statement))
		return my tidStuff(return, sql_execute)
	end sql_select_all
	
	on sql_select_all_where(table_name, search_field, search_value)
		set sql_statement to ("SELECT * FROM " & table_name & " WHERE " & ¬
			search_field & " = " & search_value & " ; " as string)
		set sql_execute to (executeSQL(sql_statement))
		return my tidStuff(return, sql_execute)
	end sql_select_all_where
	
	on sql_delete_where(table_name, search_field, search_value)
		set sql_statement to ("DELETE FROM " & table_name & " WHERE " & ¬
			search_field & " = " & search_value & " ; " as string)
		executeSQL(sql_statement)
	end sql_delete_where
	
	on sql_delete_every_row(table_name)
		set sql_statement to ("DELETE FROM " & table_name & "; " as string)
		executeSQL(sql_statement)
	end sql_delete_every_row
	
	on sql_delete_table(table_name)
		set sql_statement to ("DELETE " & table_name & "; " as string)
		executeSQL(sql_statement)
	end sql_delete_table
	
	#==============================================================
	# Private
	#==============================================================
	on executeSQL(sql_statement)
		return (do shell script HEAD & sql_statement & TAIL)
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

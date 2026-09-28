MAIN
  CALL createsch_make_reg()
END MAIN

PRIVATE FUNCTION createsch_make_reg()
   DEFINE lc_channel    base.channel
   DEFINE lch_pipe      base.channel
   DEFINE lc_exec       base.Channel   
   DEFINE ls_str        STRING
   DEFINE ls_cmd        STRING
   DEFINE ls_batch      STRING,
          ls_buf        STRING
   DEFINE ls_filename   STRING,
          res           INTEGER

   LET lc_channel = base.Channel.create()
   LET ls_filename = FGL_GETENV("TOP"),"\\msv\\dsn.reg"
   
   DISPLAY  "File is " ,ls_filename
   CALL lc_channel.openFile( ls_filename CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")  
   CALL lc_channel.write("Windows Registry Editor Version 5.00")
   CALL lc_channel.write("[HKEY_LOCAL_MACHINE\\SOFTWARE\\ODBC\\ODBC.INI\\ODBC Data Sources]")
   LET ls_str = "\"mytest\"=\"IBM INFORMIX ODBC TEST DRIVER\""
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()
 
   LET ls_batch = FGL_GETENV("TOP"),"\\msv\\import.bat"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile( ls_batch CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")  
   #CALL lc_channel.write("reg import " || ls_filename)  
   CALL lc_channel.write("regedit " || ls_filename)
   CALL lc_channel.close()

   RUN ls_batch
END FUNCTION   
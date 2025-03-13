import os
DEFINE g_dbname     VARCHAR(20)    #新建資料庫名稱
DEFINE g_type       SMALLINT       #作業型態
DEFINE g_prefix     VARCHAR(5)     #前置字元
DEFINE g_id         VARCHAR(10)    #登入帳號
DEFINE g_passwd     VARCHAR(20)    #登入密碼
DEFINE g_serverip   VARCHAR(15)    #SQL Server識別名稱
DEFINE g_target     VARCHAR(20)    #欲複製資料庫名稱
DEFINE g_dbs        VARCHAR(20)    #TIPTOP資料庫名稱

MAIN
   DEFINE ls_cmd STRING
   
    LET g_dbname   = ARG_VAL(1) CLIPPED
    LET g_type     = ARG_VAL(2) CLIPPED
    LET g_id       = ARG_VAL(3) CLIPPED
    LET g_passwd   = ARG_VAL(4) CLIPPED
    LET g_serverip = ARG_VAL(5) CLIPPED
    LET g_target   = ARG_VAL(6) CLIPPED

    IF g_dbname IS NULL OR g_dbname = " " OR g_type IS NULL OR g_serverip IS NULL THEN
       CALL createsch_error()
       EXIT PROGRAM
    END IF

    LET g_prefix = FGL_GETENV("MSSQLAREA") 
    
    IF g_prefix IS NULL OR g_prefix = " " THEN
       DISPLAY "ERROR: Database are NOT belong to MS-SQL Server Environment."
       EXIT PROGRAM
    ELSE
       LET g_dbs    = g_dbname
       LET g_dbname = g_prefix,"_",DOWNSHIFT(g_dbname CLIPPED)       
    END IF

    CASE g_type
       WHEN "1"
          CALL createsch_1_empty_db()
       WHEN "2"
          CALL createsch_2_create_ds()          
       WHEN "3"
          LET g_target = g_prefix,"_ds"
          CALL createsch_copy_db(g_target)
       WHEN "4"
          LET g_target = g_prefix,"_",DOWNSHIFT(g_target CLIPPED)
          CALL createsch_copy_db(g_target)
          
       WHEN "5"  
          CONNECT TO g_dbs
          call createsch_prepare()
          display createsch_default('pmn_file')
          

       OTHERWISE
          CALL createsch_error()
    END CASE

END MAIN



PRIVATE FUNCTION createsch_error()

   DISPLAY "Cmd: createsch dbname [1|2|3|4] login_id login_passwd login_SQLServer [sourceDB]"
   DISPLAY "===========For ds schema has not been altered yet============"
   DISPLAY "Ex1: createsch ds1 1 sa passwd sqlserver --> create database only"
   DISPLAY "============================================================="
   DISPLAY "===============For ds schema had been altered================"
   DISPLAY "Ex2: createsch ds2 2 sa passwd sqlserver --> create table schema(from ds user)"
   DISPLAY "Ex3: createsch ds3 3 sa passwd sqlserver --> create table schema with ds demo data"
   DISPLAY "Ex4: createsch ds4 4 sa passwd sqlserver ds1 --> create table schema with data(non-ds)"
   DISPLAY "============================================================="

END FUNCTION


PRIVATE FUNCTION createsch_1_empty_db()

   DEFINE ls_cont    STRING

   LET ls_cont = ""
   LET ls_cont = ls_cont,"CREATE DATABASE [",g_dbname CLIPPED,"] ON PRIMARY \n" 
   LET ls_cont = ls_cont,"( NAME = N'",g_dbname CLIPPED,"', FILENAME = N'D:\\DATABASE\\",g_dbname CLIPPED,".mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB ) \n"
   LET ls_cont = ls_cont," LOG ON \n"
   LET ls_cont = ls_cont,"( NAME = N'",g_dbname CLIPPED,"_log', FILENAME = N'D:\\DATABASE\\",g_dbname CLIPPED,"_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%); \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET COMPATIBILITY_LEVEL = 100; \n"
   LET ls_cont = ls_cont,"IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled')) \n"
   LET ls_cont = ls_cont,"begin \n"
   LET ls_cont = ls_cont,"EXEC [",g_dbname CLIPPED,"].[dbo].[sp_fulltext_database] @action = 'enable' \n"
   LET ls_cont = ls_cont,"end \n"
   LET ls_cont = ls_cont,"GO \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET ANSI_NULL_DEFAULT OFF; \n" 
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET ANSI_NULLS OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET ANSI_PADDING OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET ANSI_WARNINGS OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET ARITHABORT OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET AUTO_CLOSE OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET AUTO_CREATE_STATISTICS ON ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET AUTO_SHRINK OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET AUTO_UPDATE_STATISTICS ON ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET CURSOR_CLOSE_ON_COMMIT OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET CURSOR_DEFAULT  GLOBAL ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET CONCAT_NULL_YIELDS_NULL OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET NUMERIC_ROUNDABORT OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET QUOTED_IDENTIFIER OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET RECURSIVE_TRIGGERS OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET DISABLE_BROKER ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET AUTO_UPDATE_STATISTICS_ASYNC OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET DATE_CORRELATION_OPTIMIZATION OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET TRUSTWORTHY OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET ALLOW_SNAPSHOT_ISOLATION OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET PARAMETERIZATION SIMPLE ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET READ_COMMITTED_SNAPSHOT OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET HONOR_BROKER_PRIORITY OFF ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET READ_WRITE ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET RECOVERY FULL ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET MULTI_USER ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET PAGE_VERIFY CHECKSUM  ; \n"
   LET ls_cont = ls_cont,"ALTER DATABASE [",g_dbname CLIPPED,"] SET DB_CHAINING OFF ; \n"

   CALL createsch_general_sql(ls_cont)
    

END FUNCTION


PRIVATE FUNCTION createsch_2_create_ds()
   DEFINE ls_create_str    STRING
   DEFINE ls_sql           STRING
   DEFINE lc_tab_name      VARCHAR(50)
   DEFINE lc_tab_id        VARCHAR(20)
   DEFINE lc_col_name      VARCHAR(50)
   DEFINE li_xtype,li_length,li_isnullable  SMALLINT
   DEFINE ls_col           STRING
   DEFINE lc_channel    base.channel   
   DEFINE ls_filename   STRING
   DEFINE ls_cmd        STRING   
   DEFINE ls_index      STRING
   DEFINE li_cnt        INTEGER
   DEFINE ls_default    STRING
     
   CONNECT TO "ds"
   LET ls_sql = "SELECT name,id FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_ds.sys.sysobjects ",
                " WHERE xtype='U' ORDER BY name "
   PREPARE catch_sch_pre FROM ls_sql
   DECLARE catch_sch_cr CURSOR FOR catch_sch_pre

   LET ls_sql = "SELECT name,xtype,length,isnullable FROM ",FGL_GETENV("MSSQLAREA") CLIPPED,"_ds.sys.syscolumns ",
                " WHERE id= ? ORDER BY colid "
   PREPARE catch_col_pre FROM ls_sql
   DECLARE catch_col_cr CURSOR FOR catch_col_pre

   # call sp_helpindex
   DECLARE curs CURSOR FROM "{ call sp_helpindex(?) }"
   LET ls_sql ="SELECT count(*) FROM sys.indexes WHERE object_id=object_id(?)", 
               " AND name is not null"
   PREPARE idx_pre FROM ls_sql
   DECLARE idx_cur CURSOR FOR idx_pre   
   # 輸出SQL
   LET lc_channel = base.Channel.create()
   RUN "rm -rf ds.sql"
   LET ls_filename = "ds.sql"
   CALL lc_channel.openFile( ls_filename CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")
   CALL lc_channel.write("USE "|| g_dbname)
   CALL lc_channel.write("GO")
   
   LET ls_create_str = ""
   CALL createsch_prepare()   
   FOREACH catch_sch_cr INTO lc_tab_name,lc_tab_id
      LET ls_create_str = "CREATE TABLE ",lc_tab_name CLIPPED," (\n"
      FOREACH catch_col_cr USING lc_tab_id INTO lc_col_name,li_xtype,li_length,li_isnullable
         CASE li_xtype
            WHEN 34  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [image]"
            WHEN 35  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [text]"
            WHEN 36  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [uniqueidentifier]"
            WHEN 40  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [date]"
            WHEN 41  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [time]"
            WHEN 41  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [datetime2]"
            WHEN 48  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [tinyint]"
            WHEN 52  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [smallint]"
            WHEN 56  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [int]"
            WHEN 58  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [smalldatetime]"
            WHEN 59  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [real]"
            WHEN 60  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [money]"
            WHEN 61  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [datetime]"
            WHEN 62  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [float]"
            WHEN 98  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [sql_variant]"
            WHEN 99  LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [ntext]"
            WHEN 104 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [bit]"
            WHEN 106 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [decimal]"
            WHEN 108 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [numeric]"
            WHEN 122 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [smallmoney]"
            WHEN 127 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [bigint]"
            WHEN 165 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [varbinary]"
            WHEN 167 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [varchar]"
            WHEN 173 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [binary]"
            WHEN 175 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [char] (",li_length USING "<<<<<",")"
            WHEN 189 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [timestamp]"
            WHEN 231 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [nvarchar] (",li_length/2 USING "<<<<<",")"
            WHEN 239 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [nchar] (",li_length/2 USING "<<<<<",")"
            WHEN 241 LET ls_col = 5 SPACES,"[",lc_col_name CLIPPED,"] [xml]"
         END CASE
         IF li_isnullable THEN
            LET ls_col = ls_col.trimRight()," NULL,"
         ELSE
            LET ls_col = ls_col.trimRight()," NOT NULL,"
         END IF
         LET ls_create_str = ls_create_str.trim(),ls_col.trimRight(),"\n"
      END FOREACH
      LET ls_create_str = ls_create_str.trim(),")"
      CALL lc_channel.write(ls_create_str)
      
      OPEN idx_cur USING lc_tab_name
      FETCH idx_cur INTO li_cnt
      IF li_cnt > 0 THEN
         LET ls_index = createsch_index(lc_tab_name)
      ELSE 
         LET ls_index = ""
      END IF
      CALL lc_channel.write(ls_index)
      #建立alter default      
      LET ls_default = createsch_default(lc_tab_name)
      IF ls_default IS NOT NULL THEN
         CALL lc_channel.write(ls_default)
      END IF
   END FOREACH
   CALL lc_channel.close()
   DISCONNECT "ds"
  
   DISPLAY "Begin to build ",g_dbname
   CALL createsch_1_empty_db()
   
   LET ls_cmd = "sqlcmd -S ",g_serverip CLIPPED," -U ",g_id CLIPPED," -P ",g_passwd CLIPPED," -i ",ls_filename CLIPPED, " -b -u > dberr.log"
   DISPLAY ls_cmd    
   RUN ls_cmd
   
   DISPLAY "Create synonym..."   
   LET ls_filename = FGL_GETENV("TEMPDIR"),"\\synonym.sql"
   RUN "del " ||ls_filename
   CALL createsch_synonym(ls_filename)   
   LET ls_cmd = "sqlcmd -S ",g_serverip CLIPPED," -U ",g_id CLIPPED," -P ",g_passwd CLIPPED," -i ",ls_filename CLIPPED, " -b -u > dberr.log"
   DISPLAY ls_cmd
   RUN ls_cmd
   DISPLAY "Finish to build database"
      
END FUNCTION


PRIVATE FUNCTION createsch_copy_db(lc_target)
   DEFINE lc_target  VARCHAR(10)
   DEFINE ls_cont    STRING

   LET ls_cont = ""
   LET ls_cont = ls_cont,"BACKUP DATABASE ",lc_target CLIPPED," TO DISK='D:\\Database\\test_back.bak' WITH INIT; \n"
   LET ls_cont = ls_cont,"RESTORE DATABASE ",g_dbname CLIPPED," FROM DISK='D:\\Database\\test_back.bak' \n"
   LET ls_cont = ls_cont,"WITH \n"
   LET ls_cont = ls_cont,"   FILE = 1, \n"
   LET ls_cont = ls_cont,"   MOVE '",lc_target CLIPPED,"' TO 'D:\\DATABASE\\",g_dbname CLIPPED,".mdf', \n"
   LET ls_cont = ls_cont,"   MOVE '",lc_target CLIPPED,"_log' TO 'D:\\DATABASE\\",g_dbname CLIPPED,"_log.ldf', \n"
   LET ls_cont = ls_cont,"   NOUNLOAD,  REPLACE,  STATS = 10; \n"
   LET ls_cont = ls_cont,"Alter database ", g_dbname ," modify file (NAME = '",lc_target,"'   , NEWNAME = '",g_dbname,"'); \n"
   LET ls_cont = ls_cont,"Alter database ", g_dbname ," modify file (NAME = '",lc_target,"_log'   , NEWNAME = '",g_dbname,"_log'); \n"
   LET ls_cont = ls_cont," \n"

   CALL createsch_general_sql(ls_cont)

   
END FUNCTION


PRIVATE FUNCTION createsch_general_sql(ls_cont)

   DEFINE lc_channel    base.channel
   DEFINE lc_exec       base.Channel
   DEFINE ls_cont       STRING
   DEFINE ls_cmd        STRING
   DEFINE ls_filename   STRING

   # 輸出SQL
   LET lc_channel = base.Channel.create()
   RUN "rm -rf aw.sql"
   LET ls_filename = "aw.sql"
   CALL lc_channel.openFile( ls_filename CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")

   CALL lc_channel.write(ls_cont)
   CALL lc_channel.close()

   LET ls_cmd = "sqlcmd -S ",g_serverip CLIPPED," -U ",g_id CLIPPED," -P ",g_passwd CLIPPED," -i ",ls_filename CLIPPED, " -b -u "
   display ls_cmd
   RUN ls_cmd
   CALL createsch_fglprofile() #add database to profile
   
END FUNCTION

PRIVATE FUNCTION createsch_make_reg()
   DEFINE lc_channel    base.channel
   DEFINE lch_pipe      base.channel
   DEFINE lc_exec       base.Channel   
   DEFINE ls_str        STRING
   DEFINE ls_cmd        STRING
   DEFINE ls_batch      STRING,
          ls_buf        STRING
   DEFINE ls_reg1       STRING,
          ls_reg2       STRING,
          res           INTEGER
          
   # Output Windows Registry
   LET lc_channel = base.Channel.create()
   LET ls_reg1 = FGL_GETENV("TEMPDIR"),"\\odbc1.reg"
   LET ls_reg2 = FGL_GETENV("TEMPDIR"),"\\odbc2.reg"
   
   DISPLAY  "Regist-> " ,ls_reg1
   CALL lc_channel.openFile( ls_reg1 CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")  
   CALL lc_channel.write("Windows Registry Editor Version 5.00")
   CALL lc_channel.write("[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\ODBC\\ODBC.INI\\ODBC Data Sources]")
   LET ls_str = createsch_make_item(g_dbname,"SQL Server Native Client 10.0")   
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()
 
   DISPLAY  "Regist-> " ,ls_reg2
   CALL lc_channel.openFile( ls_reg2 CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")  
   CALL lc_channel.write("Windows Registry Editor Version 5.00")
   CALL lc_channel.write("[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\ODBC\\ODBC.INI\\"||g_dbname || "]" )   
   LET ls_str = createsch_make_item("Description",g_dbname)   
   CALL lc_channel.write(ls_str)
   LET ls_str = createsch_make_item("Server",g_serverip)   
   CALL lc_channel.write(ls_str)
   LET ls_str = createsch_make_item("Database",g_dbname) 
   CALL lc_channel.write(ls_str)
   LET ls_str = createsch_make_item("LastUser",g_id) 
   CALL lc_channel.write(ls_str)
   LET ls_str = createsch_make_item("Driver","c:\\\\Windows\\\\SysWOW64\\\\sqlncli10.dll")   
   CALL lc_channel.write(ls_str)
   CALL lc_channel.close()
   
   #Make import.bat  
   LET ls_batch = FGL_GETENV("TEMPDIR"),"\\import.bat"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile( ls_batch CLIPPED, "w" )
   CALL lc_channel.setDelimiter("")  
   #CALL lc_channel.write("runas /profile /user:stdb30-wingp\\administrator \"reg import " || ls_reg1 || "\"")      
   #CALL lc_channel.write("runas /profile /user:stdb30-wingp\\administrator \"reg import " || ls_reg2 || "\"")
   CALL lc_channel.write("regedit " || ls_reg1 )
   CALL lc_channel.write("regedit " || ls_reg2 )
   CALL lc_channel.close()   
   
   #Install 32-bits ODBC for registry    
   #LET ls_cmd = "runas  /user:administrator \"",ls_batch,"\""
   LET ls_cmd = ls_batch
   DISPLAY  "Install Registy \n",ls_cmd
   RUN ls_cmd
   #RUN "rm -rf " || ls_reg1
   #RUN "rm -rf " || ls_reg2
   
END FUNCTION


PRIVATE FUNCTION createsch_make_item(p_name,p_value)
   DEFINE p_value     STRING
   DEFINE p_name      STRING
   DEFINE ls_result   STRING
   
   LET ls_result =  "\"" ,p_name ,"\"=\"" ,p_value ,  "\""
   RETURN ls_result
END FUNCTION

PRIVATE FUNCTION createsch_fglprofile()
   DEFINE ls_fglprofile STRING
   DEFINE ls_tempfile   STRING
   DEFINE lc_channel    base.Channel
   DEFINE lc_fglprofile base.Channel   
   DEFINE ls_temp       STRING
   DEFINE ls_user       STRING
   DEFINE l_line        STRING
   DEFINE l_key         STRING
   DEFINE li_exist      smallint
   DEFINE li_i,li_j     smallint   
   
   LET ls_fglprofile = FGL_GETENV("FGLPROFILE")
   DISPLAY "Process :" ,ls_fglprofile
   
   LET ls_user = fgl_getResource("dbi.database."||g_dbs||".username")
   IF ls_user IS NULL THEN
      LET lc_channel = base.Channel.create()
      CALL lc_channel.openFile( ls_fglprofile CLIPPED, "ar" )      
      CALL lc_channel.setDelimiter("")
      LET l_key = "dbi.database"  
      WHILE TRUE
            LET l_line = lc_channel.readLine()
         
            IF lc_channel.isEof() THEN
               CALL lc_channel.write("")
               CALL lc_channel.write("dbi.database."||g_dbs||".source = \""|| g_dbname || "\"")
               CALL lc_channel.write("dbi.database."||g_dbs||".driver = \"dbmsncA0\"")
               #CALL lc_channel.write("dbi.database."||g_dbs||".schema = \""|| g_dbs || "\"")
               CALL lc_channel.write("dbi.database."||g_dbs||".username = \""|| g_id || "\"")
               CALL lc_channel.write("dbi.database."||g_dbs||".password = \""|| g_passwd || "\"")
               
               CALL lc_channel.close()
               EXIT WHILE
            END IF
         
            LET l_line = l_line.trim()
            LET l_line = l_line.toLowerCase()

            IF l_line.getCharAt(1)<>"#" THEN
               IF l_line.getIndexOf(l_key, 1)>0 THEN
                  display l_line
               END IF
            END IF
      END WHILE
      DISPLAY g_dbs,  " is added "
      CALL createsch_make_reg()
   ELSE
      DISPLAY  g_dbs,  " has existed "
   END IF
   
END FUNCTION

PRIVATE FUNCTION createsch_synonym(ls_tempfile)
   DEFINE ls_synfile    STRING
   DEFINE ls_tempfile   STRING
   DEFINE lc_channel    base.Channel
   DEFINE lc_output     base.Channel
   DEFINE ls_temp       STRING   
   DEFINE l_line        STRING
   DEFINE l_pos,l_j     SMALLINT
   DEFINE tok           base.StringTokenizer

   LET ls_synfile = FGL_GETENV("TOP"),"\\msv\\scripts\\synonym.sql"
   LET lc_channel = base.Channel.create()
   CALL lc_channel.openFile( ls_synfile CLIPPED, "r" )      
   CALL lc_channel.setDelimiter("")   
   
   LET lc_output = base.Channel.create()
   CALL lc_output.openFile( ls_tempfile CLIPPED, "w" )      
   CALL lc_output.setDelimiter("")
   CALL lc_output.write("USE "|| g_dbname)
   CALL lc_output.write("GO")
   
   WHILE TRUE
         LET l_line = lc_channel.readLine()
         
         IF lc_channel.isEof() THEN
            CALL lc_output.write("")               
            CALL lc_output.close()
            EXIT WHILE
         END IF
         
         LET l_line = l_line.trim()
         LET l_line = l_line.toLowerCase()
         #replace $ds 
         LET l_pos = l_line.getIndexOf("$ds",1)
         IF l_pos > 0 THEN
            LET ls_temp = l_line.subString(1,l_pos-1),g_prefix,"_ds",l_line.subString(l_pos+3,l_line.getLength())
            CALL lc_output.write(ls_temp)    
         ELSE
            CALL lc_output.write(l_line)         
         END IF
         
   END WHILE         
   CALL lc_channel.close()
          
END FUNCTION

PRIVATE FUNCTION createsch_index(p_table) 
DEFINE p_table      VARCHAR(50)
DEFINE idx_name     VARCHAR(20)
DEFINE idx_type     VARCHAR(200)
DEFINE idx_key      VARCHAR(200)
DEFINE ls_temp      STRING
DEFINE ls_adj       STRING
DEFINE ls_result    STRING

   FOREACH curs USING p_table INTO idx_name ,idx_type, idx_key
      LET ls_temp = idx_type
      IF ls_temp.getIndexOf("unique",1) > 1 THEN
         LET ls_adj = "unique"
      ELSE
         LET ls_adj = ""
      END IF
      
      IF ls_adj = "unique" THEN   
         LET ls_temp = idx_name      
         IF ls_temp.getIndexOf("_pk",3) > 1 THEN
            LET ls_result=ls_result, SFMT("ALTER TABLE %1 ADD CONSTRAINT %2 PRIMARY KEY CLUSTERED (%3)\n",p_table, idx_name,idx_key)
         ELSE
            LET ls_result=ls_result,SFMT("CREATE %1 INDEX %2 ON %3 (%4)\n",ls_adj,idx_name,p_table,idx_key)            
         END IF            
      ELSE
         LET ls_result=ls_result, SFMT("CREATE INDEX %1 ON %2 (%3)",
                             idx_name,p_table,idx_key)          
      END IF      
   END FOREACH   
   RETURN ls_result
END FUNCTION

  
PRIVATE FUNCTION createsch_prepare()
DEFINE ls_sql       STRING 
   LET ls_sql = " select a.object_id,a.name,col_name(object_id(?), c.parent_column_id) ", 
                " from sys.objects a,sys.default_constraints c ",
                "  where a.parent_object_id = object_id(?) ",
                "	   and a.type in ('D') and a.object_id = c.object_id "
   PREPARE default_pre FROM ls_sql
   DECLARE default_cr CURSOR FOR default_pre
   
   LET ls_sql = "select text from syscomments where id = ? "
   PREPARE text_pre FROM ls_sql
   DECLARE text_cr CURSOR FOR text_pre
   
END FUNCTION

PRIVATE FUNCTION createsch_default(p_table)
DEFINE p_table      VARCHAR(50)
DEFINE object_id    INTEGER
DEFINE cst_name     VARCHAR(200)
DEFINE col_name     VARCHAR(20)
DEFINE ls_text      VARCHAR(200)
DEFINE ls_result    STRING

   LET ls_result = ""
   FOREACH default_cr USING p_table,p_table INTO object_id ,cst_name ,col_name     
      FOREACH text_cr USING object_id  INTO ls_text
         ##            
      END FOREACH
      IF object_id > 0 THEN
         LET ls_result=ls_result, SFMT("ALTER TABLE %1 ADD  CONSTRAINT [%2] DEFAULT %3 FOR [%4] ",
                                  p_table,cst_name,ls_text,col_name)  ,"\n"                             
      END IF                          
   END FOREACH   
 
   RETURN ls_result
   
END FUNCTION
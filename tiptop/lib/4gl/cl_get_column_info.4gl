# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Library name...: cl_get_column_info
# Descriptions...: 取得欄位型態及長度
# Input parameter: p_dbname   Database name
#                   p_tabname  Table Name
#                   p_colname  Column Name
#                   p_len    報表寬度(80/132)
# Return code....: 欄位型態 not null FOR TRUE  : 有回傳值
#                               null FOR FALSE : 否
#                  長度     not null FOR TRUE  : 有回傳值
#                               null FOR FALSE : 否
# Usage..........: CALL cl_get_column_info(p_dbname,p_tabname,p_colname) 
#                       RETURNING l_coldatatype,l_collength
# Date & Author..: 05/08/17 By qazzaq
# Modify ........: 06/04/03 By qazzaq FUN-640001 新增DBname的參數
# Modify.........: No.FUN-690005 06/09/10 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-760088 07/06/29 By alex 新增 MSV 程式段
# Modify.........: No.FUN-790017 07/09/07 By Echo 調整 MSV 程式段
# Modify.........: No.FUN-7C0067 07/12/20 By Echo 調整 LIB function 說明
# Modify.........: No.FUN-810062 08/01/23 By Echo 調整 MSV 程式段
# Modify.........: No.TQC-950048 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: NO.FUN-960132 09/07/02 By Kevin 調整成 msv 架構
# Modify.........: No.FUN-AA0017 10/10/13 By alex 新增 Sybase ASE 程式段
# Modify.........: No.FUN-AA0073 10/10/19 By kevin 加入Sybase columns type
# Modify.........: No.FUN-A90024 10/11/05 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.CHI-B20029 11/02/24 By Jay 調整欄位名稱因有單引號所造成之錯誤
# Modify.........: No:WEB-C40003 12/04/06 By tsai_yen 加入WEB區的wsch_file

DATABASE ds       #FUN-7C0067
GLOBALS "../../config/top.global"
 
#FUN-7C0067
FUNCTION cl_get_column_info(p_dbname,p_tabname,p_colname)
 
DEFINE p_dbname    LIKE type_file.chr20   #No.FUN-690005 VARCHAR(20)
DEFINE p_tabname   LIKE type_file.chr20   #No.FUN-690005 VARCHAR(20)
DEFINE p_colname   LIKE type_file.chr20   #No.FUN-690005 VARCHAR(20)
DEFINE l_db_type   LIKE type_file.chr3    #No.FUN-690005 VARCHAR(3)
DEFINE l_sql       STRING
DEFINE l_datatype  LIKE ahe_file.ahe04    #No.FUN-690005 VARCHAR(15)
DEFINE l_length1   LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE l_length2   LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE l_length    STRING
DEFINE l_tmp       STRING
DEFINE l_dbname    STRING #FUN-960132
DEFINE l_sch03     LIKE sch_file.sch03    #No.FUN-A90024 NUNBER(5)
DEFINE l_cnt       LIKE type_file.num5    #No.CHI-B20029

   LET l_db_type=cl_db_get_database_type()

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構 
   #CASE l_db_type
   #   WHEN "IFX" 
   #      LET l_sql=" SELECT coltype,collength,'' ",
   #                  " FROM ",s_dbstring(p_dbname),"systables a, ",                                                                    
   #                           s_dbstring(p_dbname),"syscolumns b ",                                                                    
   #                 " WHERE a.tabname='",p_tabname CLIPPED,"' ",
   #                   " AND a.tabid=b.tabid ",
   #                   " AND b.colname='",p_colname CLIPPED,"' "
   #
   #   WHEN "ORA" 
   #      LET l_sql=" SELECT lower(data_type),to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",
   #                       " data_scale ",
   #                  " FROM all_tab_columns ",
   #                 " WHERE lower(table_name)='",p_tabname CLIPPED,"' ",
   #                   " AND lower(column_name)='",p_colname CLIPPED,"' ",
   #                   " AND lower(owner)='",p_dbname CLIPPED,"' "
   #
   #   WHEN "MSV" 
   #      LET l_dbname = p_dbname
   #      IF l_dbname.getIndexOf("_",1)= 0 THEN
   #         LET p_dbname= FGL_GETENV("MSSQLAREA") CLIPPED,"_",p_dbname
   #      END IF
   # 
   #      LET l_sql=" SELECT c.name,(CASE WHEN b.precision = 0 THEN b.max_length ELSE b.precision END),b.scale ",
   #                "   FROM ",p_dbname CLIPPED,".sys.objects a,",
   #                "        ",p_dbname CLIPPED,".sys.columns b,",
   #                "        ",p_dbname CLIPPED,".sys.types c ",
   #                "  WHERE a.name='",p_tabname CLIPPED,"' ",
   #                "    AND b.name='",p_colname CLIPPED,"' ",
   #                "    AND a.object_id=b.object_id ",
   #                "    AND b.system_type_id=c.user_type_id"
   #
   #   WHEN "ASE"                                    #FUN-AA0017
   #      LET l_sql=" SELECT c.name,(CASE WHEN b.prec is null THEN b.length ELSE b.prec END),b.scale ",
   #                "   FROM ",p_dbname CLIPPED,".dbo.sysobjects a,",
   #                "        ",p_dbname CLIPPED,".dbo.syscolumns b,",
   #                "        ",p_dbname CLIPPED,".dbo.systypes c ",
   #                "  WHERE a.name='",p_tabname CLIPPED,"' ",
   #                "    AND b.name='",p_colname CLIPPED,"' ",
   #                "    AND a.id = b.id ",
   #                "    AND b.usertype *= c.usertype "        #FUN-AA0073
   #   OTHERWISE
   #END CASE

   #---CHI-B20029---start-----
   LET p_tabname = p_tabname CLIPPED
   LET p_colname = p_colname CLIPPED

   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區  #WEB-C40003
      LET l_sql = "SELECT COUNT(*) FROM ",s_dbstring("wds") CLIPPED,"wsch_file",   #WEB-C40003
                  " WHERE wsch01 = ? AND wsch02 = ?"                               #WEB-C40003
      PREPARE cl_get_column_info_pre1 FROM l_sql                                   #WEB-C40003
      EXECUTE cl_get_column_info_pre1 USING p_tabname,p_colname INTO l_cnt         #WEB-C40003
   ELSE                                                                            #WEB-C40003
      SELECT COUNT(*) INTO l_cnt FROM sch_file       
        WHERE sch01 = p_tabname AND sch02 = p_colname
   END IF   #WEB-C40003
   
   IF l_cnt = 0 THEN
      RETURN l_datatype,l_length
   END IF
   #---CHI-B20029---end-------
   LET l_dbname = p_dbname
   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區  #WEB-C40003
      LET l_sql= "SELECT wsch03, wsch04 ",                          #WEB-C40003
                 " FROM ",s_dbstring("wds") CLIPPED,"wsch_file ",   #WEB-C40003
                 " WHERE wsch01 = '", p_tabname CLIPPED, "'",       #WEB-C40003
                 "   AND wsch02 = '", p_colname CLIPPED, "'"        #WEB-C40003
   ELSE                                                             #WEB-C40003
      LET l_sql=" SELECT sch03, sch04 ",
                "   FROM sch_file ",
                "  WHERE sch01 = '", p_tabname CLIPPED, "'",
                "   AND sch02 = '", p_colname CLIPPED, "'"
   END IF   #WEB-C40003
   #---FUN-A90024---end-------

   PREPARE cl_get_column_info_p FROM l_sql
   #FUN-810062
   IF SQLCA.SQLCODE THEN
      CALL cl_err("prepare column_info: ", SQLCA.SQLCODE, 1)
      RETURN '',''
   END IF
   #END FUN-810062
 
   #EXECUTE cl_get_column_info_p INTO l_datatype,l_length1,l_length2   #FUN-A90024  mark(l_ength2由4gl程式直接運算)
   EXECUTE cl_get_column_info_p INTO l_sch03, l_length1                #FUN-A90024
   LET l_length2 = l_length1 MOD 256                                   #FUN-A90024

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #改用4JS所產生.sch file的邏輯來判斷資料型態與資料長度
   #(可參考genero/4gl/doc中關於Database Schema Files的規範)
   #  FUN-760088
   #CASE l_db_type
   #   WHEN "IFX" 
   #      CALL cl_ifx_datatype_parse(l_datatype,l_length1) RETURNING l_datatype,l_length
   #
   #   WHEN "ORA" 
   #      IF l_length2 is not null THEN
   #         LET l_tmp=l_length1
   #         LET l_length=l_tmp CLIPPED,','
   #         LET l_tmp=l_length2 
   #         LET l_length=l_length CLIPPED,l_tmp
   #      ELSE
   #         LET l_tmp=l_length1
   #         LET l_length=l_tmp CLIPPED
   #      END IF
   #
   #   WHEN "MSV"     #FUN-790017
   #      IF l_datatype = 'datetime' THEN
   #         LET l_length = '8'
   #      ELSE
   #         IF l_datatype = "int" THEN
   #            LET l_datatype = "integer"
   #         END IF
   #         IF l_length2 != 0 THEN
   #            LET l_tmp=l_length1
   #            LET l_length=l_tmp CLIPPED,','
   #            LET l_tmp=l_length2 
   #            LET l_length=l_length CLIPPED,l_tmp
   #         ELSE
   #            LET l_tmp=l_length1
   #            LET l_length=l_tmp CLIPPED
   #         END IF
   #      END IF
   #
   #   WHEN "ASE"     #FUN-AA0017
   #      IF l_datatype = 'datetime' THEN
   #         LET l_length = '8'
   #      ELSE
   #         IF l_datatype = "int" THEN
   #            LET l_datatype = "integer"
   #         END IF
   #         IF l_length2 != 0 THEN
   #            LET l_tmp=l_length1
   #            LET l_length=l_tmp CLIPPED,','
   #            LET l_tmp=l_length2 
   #            LET l_length=l_length CLIPPED,l_tmp
   #         ELSE
   #            LET l_tmp=l_length1
   #            LET l_length=l_tmp CLIPPED
   #         END IF
   #      END IF
   #
   #   OTHERWISE
   #END CASE
   ##  FUN-760088 end
   LET l_datatype = cl_get_column_datatype(l_sch03)
   LET l_length = l_length1
   
   #smallint
   IF l_sch03 = 1 OR l_sch03 = 257 THEN
   	  IF l_db_type = "ORA" OR l_db_type = "MSV" THEN
   	     LET l_length1 = 5
   	  END IF
   	  LET l_length2 = 0
   END IF
   
   #integer
   IF l_sch03 = 2 OR l_sch03 = 258 THEN
   	  IF l_db_type = "ORA" OR l_db_type = "MSV" THEN
   	     LET l_length1 = 10
   	  END IF
   	  LET l_length2 = 0
   END IF
   
   #decimal
   IF l_sch03 = 5 OR l_sch03 = 261 THEN
   	  LET l_length1 = l_length1 / 256 USING '&&' CLIPPED
      LET l_length2 = l_length2 CLIPPED
   END IF
   
   IF (l_sch03 = 1) OR (l_sch03 = 2) OR (l_sch03 = 5) OR 
   	  (l_sch03 = 257) OR (l_sch03 = 258) OR (l_sch03 = 261) THEN
      LET l_tmp=l_length1
      LET l_length=l_tmp CLIPPED,','
      LET l_tmp=l_length2 
      LET l_length=l_length CLIPPED,l_tmp
   END IF
   
   #date
   IF l_sch03 = 7 OR l_sch03 = 263 THEN
   	  LET l_length = 10
   END IF
   #---FUN-A90024---end-------

   RETURN l_datatype,l_length
 
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: Informix 資料庫取得欄位型態及長度
# Date & Author..:
# Input Parameter: p_datatype,p_length
# Return code....:
# Modify.........: 
##################################################
FUNCTION cl_ifx_datatype_parse(p_datatype,p_length)

   DEFINE p_datatype   LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE p_length     LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE l_datatype   STRING
   DEFINE l_length     STRING
   DEFINE l_tmp        STRING
   DEFINE l_i          LIKE type_file.num5    #No.FUN-690005 SMALLINT
 
   IF p_datatype>=256 THEN
      LET p_datatype=p_datatype-256
   END IF
   CASE WHEN p_datatype = 0
             LET l_tmp=p_length CLIPPED
             LET l_datatype = "char"
             LET l_length = l_tmp CLIPPED
        WHEN p_datatype = 1 LET l_datatype = "smallint"
        WHEN p_datatype = 2 LET l_datatype = "integer"
        WHEN p_datatype = 5
             LET l_tmp=p_length/256
             LET p_length=p_length mod 256 CLIPPED
             IF l_tmp<p_length THEN
                LET l_length=l_tmp.subString(1,l_tmp.getIndexOf('.',1)-1)
             ELSE
                LET l_datatype=l_tmp.subString(1,l_tmp.getIndexOf('.',1)-1),','
                LET l_tmp=p_length CLIPPED
                LET l_datatype = l_datatype CLIPPED,l_tmp CLIPPED
             END IF
             LET l_length = l_datatype CLIPPED
             LET l_datatype = "decimal"
        WHEN p_datatype = 7 LET l_datatype = "date"
             LET l_length = 4
        WHEN p_datatype = 10 LET l_datatype = "datetime"
             LET l_length=p_length mod 514
             CASE
                WHEN l_length=510
                     LET l_length="year to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"year"
                        WHEN p_length=2
                             LET l_length=l_length,"month"
                        WHEN p_length=3
                             LET l_length=l_length,"day"
                        WHEN p_length=4
                             LET l_length=l_length,"hour"
                        WHEN p_length=5
                             LET l_length=l_length,"minute"
                        WHEN p_length=6
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=32
                     LET l_length="month to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"month"
                        WHEN p_length=2
                             LET l_length=l_length,"day"
                        WHEN p_length=3
                             LET l_length=l_length,"hour"
                        WHEN p_length=4
                             LET l_length=l_length,"minute"
                        WHEN p_length=5
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=66
                     LET l_length="day to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"day"
                        WHEN p_length=2
                             LET l_length=l_length,"hour"
                        WHEN p_length=3
                             LET l_length=l_length,"minute"
                        WHEN p_length=4
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=100
                     LET l_length="hour to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"hour"
                        WHEN p_length=2
                             LET l_length=l_length,"minute"
                        WHEN p_length=3
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=134
                     LET l_length="minute to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"minute"
                        WHEN p_length=2
                             LET l_length=l_length,"second"
                     END CASE
                WHEN l_length=168
                     LET l_length="second to "
                     LET p_length=p_length/514
                     CASE
                        WHEN p_length=1
                             LET l_length=l_length,"second"
                     END CASE
             END CASE
        WHEN p_datatype = 11 LET l_datatype = "byte"
        OTHERWISE LET p_datatype = l_datatype
   END CASE
   RETURN l_datatype,l_length
END FUNCTION

#---FUN-A90024---start-----
##########################################################################
# Private Func...: FALSE
# Descriptions...: 取得欄位是否為Not Null
# Input parameter: p_table    資料表名稱(非必要參數,可傳入'')
# Input parameter: p_colname  欄位名稱(必要參數,一定要傳入)
# Return code....: l_result Y/N (Y:此欄位為Not null / N:此欄位不是Not null)
# Usage..........: CALL cl_get_column_notnull(sch01, sch02)
# Date & Author..: 2010/12/01 by Jay
##########################################################################
FUNCTION cl_get_column_notnull(p_tabname, p_colname)
   DEFINE p_tabname   LIKE sch_file.sch01
   DEFINE p_colname   LIKE sch_file.sch02
   DEFINE l_sch03     LIKE sch_file.sch03
   DEFINE l_result    LIKE type_file.chr1
   DEFINE l_sql       STRING

   LET l_result = 'N'
   IF cl_null(p_colname) THEN
      RETURN l_result
   END IF
      
   IF cl_null(p_tabname) THEN
      LET p_tabname = cl_get_table_name(p_colname CLIPPED)
   END IF

   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區  #WEB-C40003
      LET l_sql = "SELECT wsch03 FROM ",s_dbstring("wds") CLIPPED,"wsch_file", #WEB-C40003
                  " WHERE wsch01 = ? AND wsch02 = ?"                           #WEB-C40003
      PREPARE cl_get_column_info_pre2 FROM l_sql                               #WEB-C40003
      EXECUTE cl_get_column_info_pre2 USING p_tabname,p_colname INTO l_sch03   #WEB-C40003
   ELSE                                                                        #WEB-C40003
      SELECT sch03 INTO l_sch03 FROM sch_file
        WHERE sch01 = p_tabname AND sch02 = p_colname
   END IF   #WEB-C40003

     
   IF (SQLCA.SQLCODE) THEN
      RETURN l_result
   END IF

   IF l_sch03 > 255 THEN   #大於等於256就表該欄位為Not Null
      LET l_result = 'Y'
   END IF

   RETURN l_result
END FUNCTION

##########################################################################
# Private Func...: FALSE
# Descriptions...: 取得欄位資料型態
# Input parameter: l_sch03  欄位型態代碼
# Return code....: l_datatype 欄位型態名稱
# Usage..........: CALL cl_get_column_datatype(sch03)
# Date & Author..: 2010/12/21 by Jay
##########################################################################
FUNCTION cl_get_column_datatype(l_sch03)
   DEFINE l_sch03     LIKE sch_file.sch03
   DEFINE l_datatype  STRING
   DEFINE l_db_type   LIKE type_file.chr3    #VARCHAR(3)

   LET l_datatype = ''
   LET l_db_type=cl_db_get_database_type()
   
   IF cl_null(l_sch03) THEN
      RETURN l_datatype
   END IF
   
   CASE
      WHEN l_sch03 = 0 OR l_sch03 = 256
           LET l_datatype = 'char'
      WHEN l_sch03 = 13 OR l_sch03 = 269
           LET l_datatype = "varchar"
      WHEN l_sch03 = 201 OR l_sch03 = 457
           LET l_datatype = "varchar2"
           CASE l_db_type
                WHEN "IFX"
                     LET l_datatype = 'char'
                WHEN "MSV"
                     LET l_datatype = 'nvarchar'
                WHEN "ASE"
                     LET l_datatype = 'varchar'
           END CASE
      WHEN l_sch03 = 16 OR l_sch03 = 272
           LET l_datatype = "nvarchar"
      WHEN l_sch03 = 202 OR l_sch03 = 458
           LET l_datatype = "nvarchar2"
      WHEN l_sch03 = 1 OR l_sch03 = 257
           LET l_datatype = 'smallint'
           CASE l_db_type
                WHEN "ORA"
                     LET l_datatype = 'number'
           END CASE
      WHEN l_sch03 = 2 OR l_sch03 = 258
           LET l_datatype = 'integer'
           CASE l_db_type
                WHEN "ORA"
                     LET l_datatype = 'number'
           END CASE
      WHEN l_sch03 = 5 OR l_sch03 = 261
      	   LET l_datatype = "decimal"
           CASE l_db_type
                WHEN "ORA"
                     LET l_datatype = 'number'
           END CASE
      WHEN l_sch03 = 7 OR l_sch03 = 263
           LET l_datatype = 'date'
      WHEN l_sch03 = 11 OR l_sch03 = 267
           LET l_datatype = 'binary'
           CASE l_db_type
                WHEN "IFX"
                     LET l_datatype = 'byte'
                WHEN "MSV"
                     LET l_datatype = 'image'
                WHEN "ORA"
                     LET l_datatype = 'blob'
           END CASE
      OTHERWISE
   END CASE   
   
   RETURN l_datatype
END FUNCTION

##########################################################################
# Private Func...: FALSE
# Descriptions...: 取得欄位是否為日期型態
# Input parameter: p_table    資料表名稱(非必要參數,可傳入'')
# Input parameter: p_colname  欄位名稱(必要參數,一定要傳入)
# Return code....: l_result Y/N (Y:此欄位為日期資料型態 / N:此欄位不是日期資料型態)
# Usage..........: CALL cl_get_column_datetype(sch01, sch02)
# Date & Author..: 2010/12/22 by Jay
##########################################################################
FUNCTION cl_get_column_datetype(p_tabname, p_colname)
   DEFINE p_tabname   LIKE sch_file.sch01
   DEFINE p_colname   LIKE sch_file.sch02
   DEFINE l_sch03     LIKE sch_file.sch03
   DEFINE l_result    LIKE type_file.chr1
   DEFINE l_sql       STRING                #WEB-C40003

   LET l_result = 'N'
   IF cl_null(p_colname) THEN
      RETURN l_result
   END IF
      
   IF cl_null(p_tabname) THEN
      LET p_tabname = cl_get_table_name(p_colname CLIPPED)
   END IF

   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN   #WEB區  #WEB-C40003
      LET l_sql = "SELECT wsch03 FROM ",s_dbstring("wds") CLIPPED,"wsch_file", #WEB-C40003
                  " WHERE wsch01 = ? AND wsch02 = ?"                           #WEB-C40003
      PREPARE cl_get_column_info_pre3 FROM l_sql                               #WEB-C40003
      EXECUTE cl_get_column_info_pre3 USING p_tabname,p_colname INTO l_sch03   #WEB-C40003
   ELSE                                                                        #WEB-C40003
      SELECT sch03 INTO l_sch03 FROM sch_file
        WHERE sch01 = p_tabname AND sch02 = p_colname
   END IF   #WEB-C40003
     
   IF (SQLCA.SQLCODE) THEN
      RETURN l_result
   END IF

   IF l_sch03 = 7 OR l_sch03 = 263 THEN   #等於7或263就表該欄位為日期資料型態
      LET l_result = 'Y'
   END IF

   RETURN l_result
END FUNCTION
#---FUN-A90024---end-------
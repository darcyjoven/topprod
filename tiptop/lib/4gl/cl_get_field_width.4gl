# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: cl_get_field_width.4gl
# Descriptions...: 取得所指定檔案欄位之欄位長度
# Date & Author..: 05/08/08 By Dido 
# Usage..........: LET l_width = cl_get_field_width(p_db,p_table,p_field)
# Input PARAMETER: p_db      資料庫
#                  p_table   檔案
#                  p_field   欄位
# RETURN Code....: l_width   欄位長度
# Memo...........: 若欄位型態為 date or datetime 時,則固定長度為 10
# Modify.........: No.FUN-690005 06/09/05 By chen 類型轉換
# Modify.........: NO.FUN-640161 07/01/16 BY Yiting cl_err->cl_err3
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-960183 09/06/30 By Kevin 調整成 msv 架構
 
DATABASE ds
 
GLOBALS "../../config/top.global"     #FUN-7C0053
 
DEFINE
   g_db_type          LIKE type_file.chr3,             #No.FUN-690005  VARCHAR(3)
   g_zta              RECORD LIKE zta_file.*,
   g_ztb DYNAMIC ARRAY of RECORD
            ztb03     LIKE  ztb_file.ztb03,
            ztb04     LIKE  ztb_file.ztb04,
            ztb08     LIKE  ztb_file.ztb08
         END RECORD,
   g_err          LIKE type_file.chr1000,          #No.FUN-690005   VARCHAR(1000)
   l_dbs              STRING
 
FUNCTION cl_get_field_width(p_db,p_table,p_field)
   DEFINE p_db             LIKE zta_file.zta02,  # 資料庫
          p_table          LIKE ztb_file.ztb01,  # 檔案
          p_field          LIKE ztb_file.ztb03,  # 欄位
          l_width          LIKE ztb_file.ztb08,  # 欄位長度
          l_length         LIKE ztb_file.ztb08,   #No.FUN690005 DECIMAL(6,2)
          l_length1        LIKE ztb_file.ztb08,  # 欄位長度
          l_scale          LIKE type_file.num5,  #No.FUN-690005 SMALLINT
          l_sql            LIKE type_file.chr1000,       #No.FUN-690005 VARCHAR(1000)
          l_cnt            LIKE type_file.num5,               #檢查重複用        #No.FUN-690005 SMALLINT
          i                LIKE type_file.num5          #No.FUN-690005 SMALLINT
 
   LET g_db_type=cl_db_get_database_type()   #FUN-7C0053
 
   SELECT * INTO g_zta.*                        # 重讀DB,因TEMP有不被更新特性 
     FROM zta_file           
    WHERE zta01 = p_table AND zta02 = p_db 
   IF sqlca.sqlcode THEN
      LET g_err="select zta data error(fetch):"
      #CALL cl_err(g_err CLIPPED,sqlca.sqlcode,0)
      CALL cl_err3("sel","zta_file","","",SQLCA.sqlcode,"",g_err,0)   #No.FUN-640161
      INITIALIZE g_zta.* TO NULL
      RETURN
   END IF
 
   IF g_zta.zta07 = 'S' THEN
      CASE g_db_type
      WHEN "IFX" 
         LET l_sql="SELECT colname,coltype,collength,colno ",
                   "  FROM ",g_zta.zta17 CLIPPED,":systables a,",
                             g_zta.zta17 CLIPPED,":syscolumns b",
                   " WHERE tabname='",g_zta.zta01 CLIPPED,"'",
                   "   AND a.tabid=b.tabid",
                   "   AND colname='",p_field CLIPPED,"'", 
                   " ORDER BY colno"
      WHEN "MSV" 
            LET l_dbs= FGL_GETENV("MSSQLAREA") CLIPPED,"_ds."
            LET l_sql="SELECT a.name, b.name,a.max_length,a.scale ",
                      "  FROM ",l_dbs,"sys.all_columns a,sys.types b, ",l_dbs,"dbo.sysobjects o ",
                      " WHERE o.name='",g_zta.zta01 CLIPPED,"' AND o.id = a.object_id",
                      "   AND a.name ='",p_field CLIPPED,"'",
                      "   AND a.system_type_id = b.user_type_id ",
                      " ORDER BY column_id"
      WHEN "ORA" 
            LET l_sql="SELECT lower(column_name),lower(data_type),",
                   "       to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",
                   "       data_scale ",
                   "  FROM all_tab_columns",
                   " WHERE lower(table_name)='",g_zta.zta01,"'",
                   "   AND lower(column_name)='",p_field CLIPPED,"'",
                   "   AND lower(owner)='",g_zta.zta17 CLIPPED,"'",
                   " ORDER BY column_id"
      END CASE
   ELSE
      CASE g_db_type
      WHEN "IFX" 
         LET l_sql="SELECT b.colname,b.coltype,b.collength,b.colno ",
                   "  FROM systables a,syscolumns b",
                   " WHERE a.tabname = '",g_zta.zta01 CLIPPED,"'",
                   "   AND a.tabid = b.tabid",
                   "   AND b.colname = '",p_field CLIPPED,"'" 
      WHEN "MSV" 
            LET l_sql="SELECT a.name, b.name,a.max_length,a.scale ",
                      "  FROM sys.all_columns a,sys.types b ",
                      " WHERE a.object_id = object_id('",g_zta.zta01 CLIPPED,"')",
                      "   AND a.name ='",p_field CLIPPED,"'",
                      "   AND a.system_type_id = b.user_type_id ",
                      " ORDER BY column_id"
      WHEN "ORA" 
            LET l_sql="SELECT lower(column_name),lower(data_type),",
                   "       to_char(decode(data_precision,null,data_length,data_precision),'9999.99'),",
                   "       data_scale ",
                   "  FROM user_tab_columns",
                   " WHERE lower(table_name)='",g_zta.zta01 CLIPPED,"'",
                   "   AND lower(column_name)='",p_field CLIPPED,"'",
                   " ORDER BY column_id"
      END CASE
   END IF
 
   DECLARE p_zt_cs CURSOR FROM l_sql
   CALL g_ztb.clear()
   LET l_cnt=1
   FOREACH p_zt_cs INTO g_ztb[l_cnt].ztb03,g_ztb[l_cnt].ztb04,l_length,l_scale
     IF sqlca.sqlcode THEN
        LET g_err="foreach ztb data error"
        CALL cl_err(g_err CLIPPED,sqlca.sqlcode,1) EXIT FOREACH
     END IF
 
     #IF g_db_type="IFX" THEN #FUN-960183
     CASE                     #FUN-960183
        WHEN g_db_type="IFX"
        CASE WHEN g_ztb[l_cnt].ztb04 = 0
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb04 = "char"
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
             WHEN g_ztb[l_cnt].ztb04 = 1 
                  LET g_ztb[l_cnt].ztb04 = "smallint"
             WHEN g_ztb[l_cnt].ztb04 = 2 
                  LET g_ztb[l_cnt].ztb04 = "integer"
             WHEN g_ztb[l_cnt].ztb04 = 5
                  LET l_length1=l_length/256
                  LET l_length=l_length mod 256 CLIPPED
                  IF l_length1<l_length THEN
                     FOR i=1 TO 10
                         IF l_length1[i,i]="." THEN
                            LET g_ztb[l_cnt].ztb04=l_length1[1,i-1] CLIPPED
                            EXIT FOR
                         END IF
                     END FOR
                  ELSE
                     FOR i=1 TO 10
                         IF l_length1[i,i]="." THEN
                            LET g_ztb[l_cnt].ztb04=l_length1[1,i-1] CLIPPED,","
                            EXIT FOR
                         END IF
                     END FOR
                     LET l_length1=l_length CLIPPED
                     LET g_ztb[l_cnt].ztb04 = g_ztb[l_cnt].ztb04 CLIPPED,
                                              l_length1 CLIPPED
                  END IF
                  LET g_ztb[l_cnt].ztb08 = g_ztb[l_cnt].ztb04 CLIPPED
                  LET g_ztb[l_cnt].ztb04 = "decimal"
             WHEN g_ztb[l_cnt].ztb04 = 7 
                  LET g_ztb[l_cnt].ztb04 = "date" 
                  LET g_ztb[l_cnt].ztb08 = 10
             WHEN g_ztb[l_cnt].ztb04 = 10 
                  LET g_ztb[l_cnt].ztb04 = "datetime"
                  LET g_ztb[l_cnt].ztb08 = 10 
             WHEN g_ztb[l_cnt].ztb04 = 11 
                  LET g_ztb[l_cnt].ztb04 = "byte"
             WHEN g_ztb[l_cnt].ztb04 = 13
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
                  LET g_ztb[l_cnt].ztb04 = "varchar"
             WHEN g_ztb[l_cnt].ztb04 = 256
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
                  LET g_ztb[l_cnt].ztb04 = "char"
             WHEN g_ztb[l_cnt].ztb04 = 257 
                  LET g_ztb[l_cnt].ztb04 = "smallint"
             WHEN g_ztb[l_cnt].ztb04 = 258 
                  LET g_ztb[l_cnt].ztb04 = "integer"
             WHEN g_ztb[l_cnt].ztb04 = 261
                  LET l_length1=l_length/256
                  FOR i=1 TO 10
                      IF l_length1[i,i]="." THEN
                         LET g_ztb[l_cnt].ztb04=l_length1[1,i-1] CLIPPED,","
                         EXIT FOR
                      END IF
                  END FOR
                  LET l_length=l_length mod 256 CLIPPED
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb04 = g_ztb[l_cnt].ztb04 CLIPPED,l_length1 CLIPPED
                  LET g_ztb[l_cnt].ztb08 = g_ztb[l_cnt].ztb04 CLIPPED
                  LET g_ztb[l_cnt].ztb04 = "decimal"
             WHEN g_ztb[l_cnt].ztb04 = 262 
                  LET g_ztb[l_cnt].ztb04 = "serial"
             WHEN g_ztb[l_cnt].ztb04 = 263 
                  LET g_ztb[l_cnt].ztb04 = "date"
                  LET g_ztb[l_cnt].ztb08 = 10
             WHEN g_ztb[l_cnt].ztb04 = 266 
                  LET g_ztb[l_cnt].ztb04 = "datetime"
                  LET g_ztb[l_cnt].ztb08 = 10
             WHEN g_ztb[l_cnt].ztb04 = 267 
                  LET g_ztb[l_cnt].ztb04 = "byte"
             WHEN g_ztb[l_cnt].ztb04 = 269
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
                  LET g_ztb[l_cnt].ztb04 = "varchar"
             OTHERWISE LET g_ztb[l_cnt].ztb04 = g_ztb[l_cnt].ztb04
        END CASE
     WHEN g_db_type="ORA"
        CASE WHEN g_ztb[l_cnt].ztb04 = 'varchar2'
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
             WHEN g_ztb[l_cnt].ztb04 = 'char'
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
             WHEN g_ztb[l_cnt].ztb04 = 'number'
                  IF l_scale >  0 THEN
                     LET l_length1=l_length + 2
                  ELSE
                     LET l_length1=l_length
                  END IF
                  LET g_ztb[l_cnt].ztb08=l_length1 CLIPPED
                  LET l_length1=l_scale CLIPPED
                  IF l_length1<>'0' THEN
                     LET g_ztb[l_cnt].ztb08 = g_ztb[l_cnt].ztb08 CLIPPED,',',l_length1 CLIPPED
                  END IF
             WHEN g_ztb[l_cnt].ztb04 = 'date'
                  LET g_ztb[l_cnt].ztb08 = 10
             WHEN g_ztb[l_cnt].ztb04 = 'datetime'
                  LET g_ztb[l_cnt].ztb08 = 10
             OTHERWISE
        END CASE
    #FUN-960183 start
    WHEN g_db_type="MSV"
       CASE WHEN g_ztb[l_cnt].ztb04 = 'nvarchar'
                  LET l_length1=(l_length/2) CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
             WHEN g_ztb[l_cnt].ztb04 = 'varchar' 
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED     
             WHEN g_ztb[l_cnt].ztb04 = 'char'             
                  LET l_length1=l_length CLIPPED
                  LET g_ztb[l_cnt].ztb08 = l_length1 CLIPPED
             WHEN g_ztb[l_cnt].ztb04 = 'decimal'
                  IF l_scale >  0 THEN
                     LET l_length1=l_length + 2
                  ELSE
                     LET l_length1=l_length
                  END IF
                  LET g_ztb[l_cnt].ztb08=l_length1 CLIPPED
                  LET l_length1=l_scale CLIPPED
                  IF l_length1<>'0' THEN
                     LET g_ztb[l_cnt].ztb08 = g_ztb[l_cnt].ztb08 CLIPPED,',',l_length1 CLIPPED
                  END IF
             WHEN g_ztb[l_cnt].ztb04 = 'date'
                  LET g_ztb[l_cnt].ztb08 = 10
             WHEN g_ztb[l_cnt].ztb04 = 'datetime'
                  LET g_ztb[l_cnt].ztb08 = 10
             OTHERWISE
       END CASE            
    END CASE 
    #FUN-960183 end
  END FOREACH
 
  LET l_width = g_ztb[l_cnt].ztb08
 
  RETURN l_width
 
END FUNCTION

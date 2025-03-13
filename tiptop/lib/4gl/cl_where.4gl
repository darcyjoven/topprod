# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name   : cl_where.4gl
# Program verion : 
# Descriptions   : Create Sql where conditions...
# Memo           :
# Usage          : CALL cl_where( l_conditions,'azp_file_ob' ) 
#                     RETURNING l_sqlwhere
# Date & Author  : 2007/03/27 Ghost
# Modify.........: No.TQC-860016 08/06/06 By saki 修改ON IDLE段
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
# 組合SQL語句的Where條件
FUNCTION cl_where( l_conditions, l_objectname )
DEFINE
   l_objectname                  LIKE type_file.chr20,
   l_tablename                   LIKE type_file.chr20,
   l_conditions,l_conditions_t   LIKE type_file.chr300,
   cb_filedname                  ui.COMBOBOX,
   l_sql,l_sqlfield,l_str,l_sql1 STRING,
   l_fieldname,l_datatype        LIKE type_file.chr20,
   l_str1,l_str2,l_str3,l_str4   LIKE type_file.chr20,
   l_description1,l_description2 LIKE type_file.chr300,
   l_date_des                    LIKE type_file.chr30,
   l_int                         LIKE type_file.NUM5,
   tok                           base.StringTokenizer,
   l_valuelast,l_value           string,
   l_between1,l_between2         string
 
DEFINE   l_sqlwhere  RECORD
         fieldname     LIKE type_file.chr20,
         operator      LIKE type_file.chr20,
         values        LIKE type_file.chr300,
         description1  LIKE type_file.chr100,
         description2  LIKE type_file.chr100,
         logicope      LIKE type_file.chr5,
         conditions    STRING
         END RECORD
 
   IF cl_db_get_database_type()='IFX' THEN RETURN l_conditions END IF
      
   LET l_sqlwhere.conditions = l_conditions CLIPPED
   LET l_conditions_t = l_conditions CLIPPED  
 
   OPEN WINDOW sqlwhere_i AT 2,9 WITH FORM "lib/42f/cl_where"
        ATTRIBUTE (STYLE = "reportnew" CLIPPED) 
 
   CALL cl_ui_init()
            
   LET cb_filedname = ui.ComboBox.forName("fieldname")
   IF cb_filedname IS NULL THEN
     CALL cl_err("Form field not found in current form","",0)                   
     RETURN l_conditions_t
   END IF                                                                        
   CALL cb_filedname.clear()
   
   SELECT ze03 INTO l_description1 FROM ze_file 
      WHERE ze02=g_lang AND ze01='lib-324'
   IF SQLCA.sqlcode THEN
      LET l_description1="該欄位類型為"
   END IF 
   
   SELECT ze03 INTO l_description2 FROM ze_file 
      WHERE ze02=g_lang AND ze01='lib-325'
   IF SQLCA.sqlcode THEN
      LET l_description2="請按相應格式填寫。"
   END IF 
 
   LET l_sql1 = "SELECT hisf03 FROM hisf_file",
                " WHERE hisf01='", l_objectname CLIPPED, "'"
   DECLARE tablename_q CURSOR FROM l_sql1
   FOREACH tablename_q INTO l_tablename
   END FOREACH
   LET l_tablename=l_objectname
   LET l_sql =  "SELECT column_name FROM user_tab_columns",
                " WHERE table_name=","'",UPSHIFT(l_tablename) CLIPPED,"'",
                " ORDER BY column_name "
   DECLARE filedname_q CURSOR FROM l_sql
   FOREACH filedname_q INTO l_fieldname
     CALL cb_filedname.addItem(l_fieldname,l_fieldname)
   END FOREACH
   
   LET l_sqlfield = "SELECT DISTINCT DATA_TYPE,DATA_LENGTH,",
                    "DATA_PRECISION,DATA_SCALE",
                    " FROM user_tab_columns ",               
                    " WHERE COLUMN_NAME=?"
   DECLARE fieldtype CURSOR FROM l_sqlfield
                                                                                
   CALL cl_set_comp_entry("description1,description2",FALSE);
 
   LET l_sqlwhere.logicope="AND"
   
   INPUT BY NAME
         l_sqlwhere.fieldname, l_sqlwhere.operator, l_sqlwhere.values,
         l_sqlwhere.logicope,  l_sqlwhere.conditions
         WITHOUT DEFAULTS
         ATTRIBUTE(UNBUFFERED)
   
      BEFORE FIELD fieldname
         LET l_sqlwhere.description1=""
         DISPLAY l_sqlwhere.description1 TO description1
         LET l_sqlwhere.fieldname=""
         DISPLAY l_sqlwhere.fieldname TO fieldname
      
      BEFORE FIELD operator
         LET l_sqlwhere.description2=""
         DISPLAY l_sqlwhere.description2 TO description2
         LET l_sqlwhere.operator=""
         DISPLAY l_sqlwhere.operator TO operator
 
      ON CHANGE fieldname
         IF NOT cl_null(l_sqlwhere.fieldname) THEN
 
            OPEN fieldtype USING l_sqlwhere.fieldname
            IF SQLCA.sqlcode THEN
               RETURN l_conditions_t
            END IF
            
            FETCH fieldtype INTO l_str1,l_str2,l_str3,l_str4
            
            LET l_int = l_str2 
            LET l_str = l_int                                         
            LET l_str = l_str.trim()
            LET l_str2 = l_str
            
            LET l_int = l_str3 
            LET l_str = l_int                                         
            LET l_str = l_str.trim()
            LET l_str3 = l_str
 
            LET l_int = l_str4 
            LET l_str = l_int                                         
            LET l_str = l_str.trim()
            LET l_str4 = l_str
                                                                  
            CASE l_str1                                              
               WHEN "VARCHAR2"
                  LET l_datatype = l_str1,"(",l_str2 CLIPPED ,")"
 
               WHEN "NUMBER"
                  LET l_datatype = l_str1,"(",l_str3 CLIPPED,",",l_str4 CLIPPED,")"
                  
               OTHERWISE
                  LET l_datatype = l_str1 CLIPPED   
            END CASE
            
            IF l_str1 = "DATE" THEN
               SELECT ze03 INTO l_date_des FROM ze_file 
                  WHERE ze02=g_lang AND ze01='lib-326'
               IF SQLCA.sqlcode THEN
                  LET l_date_des="日期格式為yyyy/mm/dd."
               END IF
               
               LET l_sqlwhere.description1 = l_description1 CLIPPED,l_datatype,
                                             ".", l_date_des CLIPPED, l_description2
            ELSE 
               LET l_sqlwhere.description1 = l_description1 CLIPPED, l_datatype,
                                             ".", l_description2
            END IF
            DISPLAY l_sqlwhere.description1 TO description1
         END IF                
        
      ON CHANGE operator
         IF NOT cl_null(l_sqlwhere.operator) THEN
            CASE l_sqlwhere.operator
               WHEN "BETWEEN"
                  CALL cl_set_comp_entry("values",TRUE);
                  
                  SELECT ze03 INTO l_sqlwhere.description2 FROM ze_file 
                     WHERE ze02=g_lang AND ze01='lib-327'
                  IF SQLCA.sqlcode THEN
                     LET l_sqlwhere.description2="BETWEEN ... AND ... 要求輸入格式為 值一,值二 。",
                                                 "請按格式輸入。"
                  END IF
                  
               WHEN "IN"
                  CALL cl_set_comp_entry("values",TRUE);
                                    
                  SELECT ze03 INTO l_sqlwhere.description2 FROM ze_file 
                     WHERE ze02=g_lang AND ze01='lib-328'
                  IF SQLCA.sqlcode THEN
                     LET l_sqlwhere.description2="IN ... 要求輸入格式為 值一,值二,值三... 。",
                                                 "請按格式輸入。"
                  END IF
                  
               WHEN "LIKE"
                  CALL cl_set_comp_entry("values",TRUE);
                                    
                  SELECT ze03 INTO l_sqlwhere.description2 FROM ze_file 
                     WHERE ze02=g_lang AND ze01='lib-329'
                  IF SQLCA.sqlcode THEN
                     LET l_sqlwhere.description2="LIKE 輸入的內容可以包含通配符，具體用法請查閱相關資料."
                  END IF
                  
               WHEN "IS NULL"
                  CALL cl_set_comp_entry("values",FALSE)
                  LET l_sqlwhere.description2=""
 
               WHEN "IS NOT NULL"
                  CALL cl_set_comp_entry("values",FALSE)
                  LET l_sqlwhere.description2=""
                                    
               OTHERWISE
                  CALL cl_set_comp_entry("values",TRUE); 
                  LET l_sqlwhere.description2=""
 
            END CASE
            
            DISPLAY l_sqlwhere.description2 TO description2 
         END IF
 
      ON ACTION makecond
         IF l_sqlwhere.fieldname IS NOT NULL AND l_sqlwhere.operator IS NOT NULL THEN
       
            CASE l_sqlwhere.operator
               WHEN "BETWEEN"
                  IF l_sqlwhere.values IS NOT NULL THEN
                     LET l_str=l_sqlwhere.values
                     LET l_int=l_str.getIndexOf( ",", 1 )
                     LET l_between1=l_str.SubString(1,l_int-1)
                     LET l_between2=l_str.SubString(l_int+1,l_str.getLength())
                     
                     IF l_str1<>"NUMBER" THEN
                        LET l_between1="'", l_between1, "'"
                        LET l_between2="'", l_between2, "'"
                     END IF
                     
                     IF l_str1="DATE" THEN
                        LET l_between1="to_date(", l_between1, ",'yyyy/mm/dd')"
                        LET l_between2="to_date(", l_between2, ",'yyyy/mm/dd')"
                     END IF  
                     
                     LET l_valuelast=l_between1, " AND ",l_between2
                  END IF 
                        
               WHEN "IN"
                  IF l_sqlwhere.values IS NOT NULL THEN
                     LET tok = base.StringTokenizer.create(l_sqlwhere.values,",")
                     LET l_valuelast=""
                     WHILE tok.hasMoreTokens()
                        LET l_value=tok.nextToken()
                        IF l_str1<>"NUMBER" THEN
                           IF l_str1="DATE" THEN
                             LET l_value="to_date('", l_value, "','yyyy/mm/dd')"
                           END IF 
                           
                           IF cl_null(l_valuelast) THEN
                              LET l_valuelast="'", l_value, "'"
                           ELSE
                              LET l_valuelast=l_valuelast, ",", "'", l_value, "'"	
                           END IF 
                        ELSE
                           IF cl_null(l_valuelast) THEN
                              LET l_valuelast=l_value
                           ELSE
                              LET l_valuelast=l_valuelast, ",", l_value	
                           END IF 
                        END IF 
                     END WHILE
                     
                     LET l_valuelast="(", l_valuelast, ")"
                  END IF     
               
               WHEN "IS NULL"
                 LET l_valuelast=""
                  
               WHEN "IS NOT NULL"
                  LET l_valuelast=""
                  
               OTHERWISE
                  IF l_str1<>"NUMBER" THEN
                     IF l_str1="DATE" THEN
                        LET l_valuelast="to_date('", l_sqlwhere.values, "','yyyy/mm/dd')"
                     ELSE
                     	LET l_valuelast="'", l_sqlwhere.values, "'"
                     END IF 
                  ELSE
                     LET l_valuelast=l_sqlwhere.values
                  END IF 
       
            END CASE       
         
            IF cl_null(l_sqlwhere.conditions) then
               LET l_sqlwhere.conditions = l_sqlwhere.logicope CLIPPED, " (",
                                           l_sqlwhere.fieldname CLIPPED," ", 
                                           l_sqlwhere.operator CLIPPED, " ",
                                           l_valuelast,")"
            ELSE 
               LET l_sqlwhere.conditions = l_sqlwhere.conditions CLIPPED, " ",
                                           l_sqlwhere.logicope CLIPPED, " ",
                                           "(", l_sqlwhere.fieldname CLIPPED," ", 
                                           l_sqlwhere.operator CLIPPED, " ",
                                           l_valuelast,")"
            END IF
 
{若需要返回前面不帶AND/OR邏輯運算符的條件，換用這段代碼
            IF cl_null(l_sqlwhere.conditions) then
               LET l_sqlwhere.conditions = "(", l_sqlwhere.fieldname CLIPPED," ", 
                                           l_sqlwhere.operator CLIPPED, " ",
                                           l_valuelast,")"
            ELSE 
               LET l_sqlwhere.conditions = l_sqlwhere.conditions CLIPPED, " ",
                                           l_sqlwhere.logicope CLIPPED, " ",
                                           "(", l_sqlwhere.fieldname CLIPPED," ", 
                                           l_sqlwhere.operator CLIPPED, " ",
                                           l_valuelast,")"
            END IF
}
         END IF
      
      ON ACTION accept
         EXIT INPUT 
         
      ON ACTION cancel
         LET  l_sqlwhere.conditions=l_conditions_t
         EXIT INPUT
 
      #No.TQC-860016 --start--
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #No.TQC-860016 ---end---
         
   END INPUT
 
   FREE fieldtype
   CLOSE WINDOW sqlwhere_i
   RETURN l_sqlwhere.conditions
END FUNCTION

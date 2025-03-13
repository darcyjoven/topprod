# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#{
# Program name...: aws_del_plm_temptable_data.4gl
# Descriptions...: 刪除ERP Temp Table資料服務
# Date & Author..: 2012/04/10 by Abby
# Memo...........:
# Modify.........: 新建立 DEV-C40002
# Modify.........: No.FUN-D10092 13/01/20 By Abby  PLM GP5.3追版
#
#}
 
DATABASE ds
 
#DEV-C40002
 
GLOBALS "../../config/top.global"
 
GLOBALS "../4gl/aws_ttsrv2_global.4gl"   #TIPTOP Service Gateway 使用的全域變數檔
 
 
#[
# Description....: 刪除ERP Temp Table資料服務(入口 function)
# Date & Author..: 2012/04/10 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_del_plm_temptable_data()
 
 
    WHENEVER ERROR CONTINUE
 
    CALL aws_ttsrv_preprocess()    #呼叫服務前置處理程序
    
    #執行紀錄寫入syslog
    CALL aws_syslog("PLM","","1","aws_ttsrv2","","in FUNCTION:aws_del_plm_temptable_data","Y")

    #--------------------------------------------------------------------------#
    # 刪除ERP Temp Table資料服務                                               #
    #--------------------------------------------------------------------------#
    IF g_status.code = "0" THEN
       CALL aws_del_plm_temptable_data_process()
    END IF
 
    CALL aws_ttsrv_postprocess()   #呼叫服務後置處理程序

    #執行紀錄寫入syslog
    CALL aws_syslog("PLM","","1","aws_ttsrv2","","end FUNCTION:aws_del_plm_temptable_data","Y")
END FUNCTION
 
 
#[
# Description....: 刪除ERP Temp Table資料服務
# Date & Author..: 2012/04/10 by Abby
# Parameter......: none
# Return.........: none
# Memo...........:
# Modify.........:
#
#]
FUNCTION aws_del_plm_temptable_data_process()
    DEFINE l_wcf   RECORD LIKE wcf_file.*
    DEFINE l_wc    STRING
    DEFINE l_sql   STRING
    DEFINE l_msg   STRING
    DEFINE l_status RECORD
              code           STRING,      #訊息代碼
              sqlcode        STRING       #SQL ERROR CODE
           END RECORD
 

      LET l_wc = aws_ttsrv_getParameter("datakey")   #取由呼叫端呼叫時給予的 SQL Condition

      IF aws_datakeychk(l_wc) THEN                   #確認wcf_file有此DataKey才處理
         BEGIN WORK

         LET l_sql = "SELECT wcf01 FROM wcf_file WHERE wcf06 = ? FOR UPDATE"
         LET l_sql = cl_forupd_sql(l_sql)
         DECLARE wcf_cl CURSOR FROM l_sql
        
         #-------------------------------------------------------------------#
         # 鎖住將被更改或取消的資料                                          #
         #-------------------------------------------------------------------#
         IF aws_delchk(l_wc) THEN  
            LET l_sql = "DELETE FROM wcf_file ",
                        " WHERE wcf06 = '",l_wc,"'" 
            
            #--------------------------------------------#
            # 執行 DELETE SQL                            #
            #--------------------------------------------#
            #DISPLAY l_sql
            LET l_msg = "in FUNCION aws_del_plm_temptable_data_process()|",
                        "BEFORE EXECUTE DELETE_SQL:",l_sql
            CALL aws_syslog("PLM",l_wc,"1","aws_ttsrv2","",l_msg,"N")  #執行紀錄寫入syslog
            
            EXECUTE IMMEDIATE l_sql
            IF SQLCA.SQLCODE THEN
               LET g_status.code = SQLCA.SQLCODE
               LET g_status.sqlcode = SQLCA.SQLCODE
            END IF
         END IF
        
         LET l_status.code = g_status.code
         LET l_status.sqlcode = g_status.sqlcode

         #全部處理都成功才 COMMIT WORK
         IF g_status.code = "0" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF 
         
         LET l_msg = "in FUNCION aws_del_plm_temptable_data_process()|",
                     "AFTER EXECUTE DELETE_SQL|g_status.code=",g_status.code
         CALL aws_syslog("PLM",l_wc,"1","aws_ttsrv2","",l_msg,"N")          #執行紀錄寫入syslog       
      ELSE
         LET l_status.code = g_status.code
         LET l_status.sqlcode = g_status.sqlcode 
         CALL aws_syslog("PLM",l_wc,"1","aws_ttsrv2",g_status.code,"","N")  #執行紀錄寫入syslog
      END IF

      #還原舊值
      LET g_status.code = l_status.code
      LET g_status.sqlcode = l_status.sqlcode 
END FUNCTION


#[
# Description....: 檢查有無此DataKey存在
# Date & Author..: 2012/05/17 By Lilan
# Parameter......: none
# Return.........: l_status - INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#]
FUNCTION aws_datakeychk(p_wcf06)
  DEFINE p_wcf06 LIKE wcf_file.wcf06
  DEFINE l_wcf01 LIKE wcf_file.wcf01

     SELECT wcf01 INTO l_wcf01
       FROM wcf_file
      WHERE wcf06 = p_wcf06
     IF cl_null(l_wcf01) THEN
        LET g_status.code = 'aws-624'     #DataKey不存在     
        RETURN FALSE
     END IF

     RETURN TRUE
END FUNCTION 



#[
# Description....: 鎖住將被更改或取消的資料
# Date & Author..: 2012/04/23 By Abby
# Parameter......: none
# Return.........: l_status - INTEGER - TRUE / FALSE Luck 結果
# Memo...........:
# Modify.........:
#]
FUNCTION aws_delchk(p_wcf06)
  DEFINE p_wcf06 LIKE wcf_file.wcf06
  DEFINE l_wcf01 LIKE wcf_file.wcf01
  DEFINE l_wcf17 LIKE wcf_file.wcf17


     SELECT wcf17 INTO l_wcf17 
       FROM wcf_file 
      WHERE wcf06 = p_wcf06
     IF l_wcf17 = 'S' THEN
        LET g_status.code = 'aws-623'          #要刪除的<DataKey>狀態不為"Y(處理完成)"或"N(尚未處理)"，不可刪除!
        RETURN FALSE
     END IF

     OPEN wcf_cl USING p_wcf06
     IF STATUS THEN
        LET g_status.code = STATUS
        CLOSE wcf_cl
        RETURN FALSE
     END IF
     FETCH wcf_cl INTO l_wcf01                 #鎖住將被更改或取消的資料
     IF SQLCA.sqlcode THEN
        LET g_status.code = SQLCA.SQLCODE      #資料被他人LOCK
        LET g_status.sqlcode = SQLCA.SQLCODE
        CLOSE wcf_cl
        RETURN FALSE
     END IF
     RETURN TRUE
END FUNCTION
#FUN-D10092

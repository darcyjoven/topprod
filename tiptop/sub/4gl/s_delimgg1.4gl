# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: s_delimgg1.4gl
# Descriptions...: 多單位庫存明細庫存量為零時刪除作業
# Date & Author..: 05/08/09 By Carrier
# Usage..........: CALL s_delimgg1(p_rowid,p_item,p_ware,p_loc,p_lot,p_unit,p_dbs)
# Input Parameter: p_rowid 庫存明細檔中的ROWID
#                  p_item  料號
#                  p_ware  倉庫
#                  p_loc   儲位 
#                  p_lot   批號 
#                  p_unit  單位 
#                  p_dbs   資料庫
# Return code....: NONE
# Modify.........: No:FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No:FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-8C0084 08/12/22 By jan s_delimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID 

DATABASE ds

GLOBALS "../../config/top.global"     #FUN-7C0053

#FUNCTION s_delimgg1(p_rowid,p_item,p_ware,p_loc,p_lot,p_unit,p_dbs) #FUN-8C0084
FUNCTION s_delimgg1(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_item,p_ware,p_loc,p_lot,p_unit,p_dbs)  #FUN-8C0084
   DEFINE  p_rowid    LIKE type_file.chr18,           #No.FUN-680147 INT # saki 20070821 rowid chr18 -> num10 
           p_item     LIKE img_file.img01,
           p_ware     LIKE img_file.img02,
           p_loc      LIKE img_file.img03,
           p_lot      LIKE img_file.img04,
           p_unit     LIKE img_file.img09,
           p_imgg01   LIKE imgg_file.imgg01,  #FUN-8C0084
           p_imgg02   LIKE imgg_file.imgg02,  #FUN-8C0084
           p_imgg03   LIKE imgg_file.imgg03,  #FUN-8C0084
           p_imgg04   LIKE imgg_file.imgg04,  #FUN-8C0084
           p_imgg09   LIKE imgg_file.imgg09,  #FUN-8C0084
           p_dbs      LIKE azp_file.azp03,
            g_sql      string,  #No:FUN-580092 HCN
           l_sma      RECORD LIKE sma_file.*

  WHENEVER ERROR CALL cl_err_msg_log
  #No;FUN-8C0084--BEGIN--
# IF cl_null(p_rowid) THEN
#    LET g_sql = "SELECT ROWID FROM ",p_dbs CLIPPED,".imgg_file ",
#                " WHERE imgg01='",p_item,"'",
#                "   AND imgg02='",p_ware,"'",
#                "   AND imgg03='",p_loc ,"'",
#                "   AND imgg04='",p_lot ,"'",
#                "   AND imgg09='",p_unit,"'"
#    PREPARE delimgg1_pre1 FROM g_sql                                           
#    IF SQLCA.sqlcode THEN                                                      
#       CALL cl_err(p_rowid,SQLCA.sqlcode,0)
#       RETURN                                                                  
#    END IF                                                                     
#    EXECUTE delimgg1_pre1 INTO p_rowid                                                      
#    IF SQLCA.sqlcode THEN                                                      
#       CALL cl_err(p_rowid,SQLCA.sqlcode,0)
#       LET g_success='N'
#       RETURN                                                                  
#    END IF
# END IF
#No:FUN-8C0084--END--
  #IF cl_null(p_rowid) THEN LET g_success='N' RETURN END IF  #FUN-8C0084
  IF cl_null(p_imgg01) THEN LET g_success='N' RETURN END IF  #FUN-8C0084

  #No:FUN-8C0084--BEGIN--
  #LET g_sql = "DELETE FROM ",p_dbs,".imgg_file WHERE ROWID = '",p_rowid,"'",
  LET g_sql = "DELETE FROM ",p_dbs,".imgg_file",
              " WHERE imgg01='",p_imgg01,"' ",
              "   AND imgg02='",p_imgg02,"' ",
              "   AND imgg03='",p_imgg03,"' ",
              "   AND imgg04='",p_imgg04,"' ",
              "   AND imgg09='",p_imgg09,"' ",
    #No:FUN-8C0084--END--
              "   AND imgg10 = 0"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
  PREPARE delimgg1_pre2 FROM g_sql                                           
  IF SQLCA.sqlcode THEN                                                      
     CALL cl_err(p_imgg01,SQLCA.sqlcode,0)
     RETURN                                                                  
  END IF                                                                     
  EXECUTE delimgg1_pre2                                                      
  IF SQLCA.sqlcode THEN                                                      
     CALL cl_err(p_imgg01,SQLCA.sqlcode,0)
     RETURN                                                                  
  ELSE
      IF SQLCA.SQLERRD[3] != 0 THEN 
         CALL cl_err(p_imgg01,'mfg1023',0)
      END IF
  END IF                             
END FUNCTION

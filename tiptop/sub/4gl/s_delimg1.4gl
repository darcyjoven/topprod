# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_delimg1.4gl
# Descriptions...: 庫存明細庫存量為零時刪除作業
# Date & Author..: 92/06/04 By  Wu
# Usage..........: CALL s_delimg1(p_rowid,p_dbs)
# Input Parameter: p_rowid  庫存明細檔中的ROWID
#                  p_dbs    工廠別
# Return code....: NONE
# Revise record..: 03/12/18 By Carrier   add p_dbs
# Modify.........: No.MOD-570281 05/07/20 By Carrier ignore sma882
# Modify.........: No:FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No:FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No:FUN-8C0084 08/12/22 By jan s_delimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No:TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()    

DATABASE ds

GLOBALS "../../config/top.global"    #FUN-7C0053

#FUNCTION s_delimg1(p_rowid,p_dbs) #FUN-8C0084
FUNCTION s_delimg1(p_img01,p_img02,p_img03,p_img04,p_dbs) #FUN-8C0084
   DEFINE  p_rowid    LIKE type_file.chr18,         #No.FUN-680147 INT # saki 20070821 rowid chr18 -> num10 
           p_dbs      LIKE azp_file.azp03,
            g_sql      string,  #No:FUN-580092 HCN
           l_sma      RECORD LIKE sma_file.*
   #No:FUN-8C0084--BEGIN--
   DEFINE  p_img01   LIKE img_file.img01
   DEFINE  p_img02   LIKE img_file.img02
   DEFINE  p_img03   LIKE img_file.img03
   DEFINE  p_img04   LIKE img_file.img04
   #No:FUN-8C0084--END--

  WHENEVER ERROR CALL cl_err_msg_log
{ckp#1}  
# LET g_sql = "SELECT * FROM ",p_dbs,".sma_file WHERE sma00 = '0'"             #TQC-950050 MARK                                     
  LET g_sql = "SELECT * FROM ",s_dbstring(p_dbs),"sma_file WHERE sma00 = '0'"  #TQC-950050 ADD  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
  PREPARE delimg1_pre FROM g_sql
  IF SQLCA.sqlcode THEN
     CALL cl_err('sma_file',SQLCA.sqlcode,0)
     RETURN
  END IF
  DECLARE delimg1_cur SCROLL CURSOR FOR delimg1_pre
  IF SQLCA.sqlcode THEN
     CALL cl_err('sma_file',SQLCA.sqlcode,0)
     RETURN
  END IF
  OPEN delimg1_cur  
  FETCH delimg1_cur INTO l_sma.* 
  IF SQLCA.sqlcode THEN
     CALL cl_err('sma_file',SQLCA.sqlcode,0)
     RETURN
  END IF
 #  IF l_sma.sma882 MATCHES '[Yy]' THEN   #No.MOD-570281 
    #No:FUN-8C0084--BEGIN--
    #LET g_sql = "DELETE FROM ",p_dbs,".img_file WHERE ROWID = '",p_rowid,"'",
    #LET g_sql = "DELETE FROM ",p_dbs,".img_file",              #TQC-950050 MARK                                                    
     LET g_sql = "DELETE FROM ",s_dbstring(p_dbs),"img_file",   #TQC-950050 ADD    
                 " WHERE img01='",p_img01,"' ",                                                                          
                 "   AND img02='",p_img02,"' ",                                                                          
                 "   AND img03='",p_img03,"' ",                                                                          
                 "   AND img04='",p_img04,"' ",                                                                           
    #No:FUN-8C0084--END-- 
                 "   AND img10 = 0"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     PREPARE delimg1_pre2 FROM g_sql                                           
     IF SQLCA.sqlcode THEN                                                      
        CALL cl_err(p_img01,SQLCA.sqlcode,0)
        RETURN                                                                  
     END IF                                                                     
     EXECUTE delimg1_pre2                                                      
     IF SQLCA.sqlcode THEN                                                      
        CALL cl_err(p_img01,SQLCA.sqlcode,0)
        RETURN                                                                  
     ELSE
         IF SQLCA.SQLERRD[3] != 0 THEN 
            CALL cl_err(p_img01,'mfg1023',0)
         END IF
     END IF                             
 # END IF    #No.MOD-570281 
END FUNCTION

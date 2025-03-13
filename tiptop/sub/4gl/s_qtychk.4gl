# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_qtychk.4gl
# Descriptions...: 非負值欄位歸零作業
# Date & Author..: 93/02/19 By Keith
# Usage..........: CALL s_qtychk(p_file,p_field,p_sql)
# Input Parameter: p_file    檔案名稱
#                  p_field   欄位名稱
#                  p_sql     where condition
# Return code....: NONE
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-720003 07/02/5 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No:FUN-B70007 11/07/05 By jrg542 在EXIT PROGRAM前加上CALL cl_used(2)

DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_qtychk(p_file,p_field,p_sql)
DEFINE 
        g_success LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)
        p_file    LIKE zta_file.zta01,          #No.FUN-680147 VARCHAR(9)
        p_field   LIKE zta_file.zta02,          #No.FUN-680147 VARCHAR(7)
        l_value   LIKE oeb_file.oeb12,          #No.FUN-680147 DECIMAL(12,3)
        p_sql     LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
        l_sql     LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(1000)
 
	WHENEVER ERROR CALL cl_err_msg_log
 
     LET l_sql = "SELECT ",p_field," FROM ",p_file," WHERE ",p_sql CLIPPED
     PREPARE qty_prepare FROM l_sql
        IF SQLCA.sqlcode != 0 THEN 
#          CALL cl_err('prepare(s_qtychk):',SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','prepare(s_qtychk):',SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('prepare(s_qtychk):',SQLCA.sqlcode,1)                                                                        
      END IF                                                                                                                        
#No.FUN-720003--end                     
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B70007
         EXIT PROGRAM 
        END IF
        DECLARE qty_curs CURSOR FOR qty_prepare  
        OPEN qty_curs
        FETCH qty_curs INTO l_value
          IF SQLCA.sqlcode != 0 THEN 
#            CALL cl_err('foreach(s_qtychk):',SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','foreach(s_qtychk):',SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('foreach(s_qtychk):',SQLCA.sqlcode,1)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
          END IF
        CLOSE qty_curs
     IF l_value < 0 THEN
        LET l_sql = "UPDATE ",p_file," SET ",p_field," = 0 WHERE ",p_sql CLIPPED
        PREPARE pr_upd FROM l_sql
        IF SQLCA.sqlcode THEN
#          CALL cl_err('update_exe(s_qtychk):',SQLCA.sqlcode,0)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','update_exe(s_qtychk):',SQLCA.sqlcode,0)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('update_exe(s_qtychk):',SQLCA.sqlcode,0)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end             
        END IF
        #No.CHI-950007  --Begin
#       DECLARE update_exe CURSOR FOR pr_upd      
        EXECUTE pr_upd
        #No.CHI-950007  --End  
        IF SQLCA.sqlcode THEN
#          CALL cl_err('s_qtychk failure',SQLCA.sqlcode,1)
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','s_qtychk failure',SQLCA.sqlcode,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('s_qtychk failure',SQLCA.sqlcode,0)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
           LET g_success = 'N'
#          RETURN 1               
        END IF
     END IF
#    RETURN 0
END FUNCTION

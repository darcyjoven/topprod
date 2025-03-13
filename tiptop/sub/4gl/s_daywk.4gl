# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_daywk.4gl
# Descriptions...: test this date work?
# Date & Author..: 91/12/20 By Lee
# Usage..........: IF NOT s_daywk(p_date)
# Input Parameter: p_date   date
# Return code....: 1  YES
#                  0  NO
#                  2  無資料
# Modify.........: NO.FUN-670091 06/08/02 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/12 By jamie 程式開頭增加'database ds'
# Modify.........: No.CHI-690066 06/12/12 By rainy 傳回值改為 是/否/無資料
# Modify.........: No.FUN-720003 07/02/07 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_daywk(p_date)
DEFINE
    p_date LIKE type_file.dat           #No.FUN-680147 DATE
DEFINE l_cnt    LIKE type_file.num5     #CHI-690066
DEFINE l_sme02  LIKE sme_file.sme02     #CHI-690066
 
    WHENEVER ERROR CALL cl_err_msg_log
    LET l_cnt = 0                                  #CHI-690066 add
   #CHI-690066 add--begin
    SELECT COUNT(sme01) INTO l_cnt FROM sme_file   #CHI-690066 add
         WHERE sme01 = p_date 
    IF l_cnt = 0 THEN 
#      CALL cl_err(p_date,'mfg3153',0)  
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('sme01',p_date,p_date,'mfg3153',0)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(p_date,'mfg3153',0)                                                                             
      END IF
       RETURN 2 
    END IF
   #CHI-690066 add--end
  
   #CHI-690066 --begin
    #SELECT sme01 FROM sme_file                    
    #     WHERE sme01 = p_date 
    #         AND sme02 IN ('Y','y') 
    LET l_sme02 = ''
    SELECT sme02 INTO l_sme02 FROM sme_file                    
         WHERE sme01 = p_date 
    IF SQLCA.sqlcode THEN
        #CALL cl_err(p_date,'mfg3152',0)  #FUN-670091
#        CALL cl_err3("sel","sme_file",p_date,"",SQLCA.sqlcode,"","",0) #FUN-670091
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('sme01',p_date,p_date,'mfg3152',0)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(p_date,'mfg3152',0)                                                                             
      END IF 
#No.FUN-720003--end 
        RETURN 0
    END IF
    IF NOT (l_sme02 ='Y' OR l_sme02='y') THEN
#      CALL cl_err(p_date,'mfg3152',0)  
#No.FUN-720003--begin                                                                                                               
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','',p_date,'mfg3152',0)                                                                     
      ELSE                                                                                                                          
         CALL cl_err(p_date,'mfg3152',0)                                                                             
      END IF                                                                                                                        
#No.FUN-720003--end 
       RETURN 0
    END IF
  #CHI-690066
 
    RETURN 1
END FUNCTION

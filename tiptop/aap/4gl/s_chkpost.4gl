# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# return code ....: True /1    allow to modify
#                   False/0 disallow to modify
# Modify..........: 03/05/27 By Kammy 因有可能匯總分錄產生傳票，所以一定要
#                                     加傳單號(no.7277)
#                   p_trno->傳票號碼  p_no ->單號
# Modify..........: No.FUN-550030 05/05/18 By ice 單據編號欄位放大
# Modify..........: No.TQC-630134 06/03/30 By Smapmin 拿掉apz24的判斷
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
 
# Modify.........: No.FUN-690028 06/09/07 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-CB0054 12/12/25 By wangrr 根據參數p_type採用不同報錯方式,0:單獨報錯,1:匯總報錯
 
DATABASE ds
GLOBALS "../../config/top.global"
 
#FUNCTION s_chkpost(p_trno,p_no)       #FUN-CB0054 mark
FUNCTION s_chkpost(p_trno,p_no,p_type) #FUN-CB0054 add
#   DEFINE p_trno        VARCHAR(12)
#  DEFINE p_no          VARCHAR(10)
   #DEFINE p_trno        VARCHAR(16)     #No.FUN-550030  #FUN-660117 remark
   #DEFINE p_no          VARCHAR(16)     #No.FUN-550030  #FUN-660117 remark
   DEFINE p_trno        LIKE aba_file.aba01           #FUN-660117
   DEFINE p_no          LIKE npp_file.npp01           #FUN-660117
   DEFINE l_chr,l_post  LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
   DEFINE l_msg	        LIKE type_file.chr1000     # No.FUN-690028 VARCHAR(80)
   DEFINE l_dbs         LIKE type_file.chr20       # No.FUN-690028 VARCHAR(20)
   DEFINE l_sql         LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(600)
   DEFINE l_book        LIKE npp_file.npp07
   DEFINE l_plant       LIKE npp_file.npp06
   DEFINE p_type        LIKE type_file.chr1  #FUN-CB0054 add
 
   WHENEVER ERROR CONTINUE
   IF p_trno IS NULL OR p_trno=' ' THEN RETURN 1 END IF
   IF p_trno = 'NO' THEN RETURN 1 END IF
   #IF g_apz.apz24 = 'Y' THEN RETURN 1 END IF   #TQC-630134
   LET l_post=NULL
   SELECT npp06,npp07 INTO l_plant,l_book FROM npp_file
    WHERE npp01 = p_no AND nppglno=p_trno AND nppsys='AP'
   IF STATUS = 100 THEN 
      #FUN-CB0054--add--str--
      IF p_type='0' THEN
         CALL cl_err('','ap-275',0)
      ELSE
         CALL s_errmsg('','','','aap-275',1)
         LET g_success='N'
      END IF
      #FUN-CB0054--add--end
      RETURN 0
   END IF
   SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
  #LET l_sql = "SELECT abapost FROM ",s_dbstring(l_dbs),"aba_file ",
   LET l_sql = "SELECT abapost FROM ",cl_get_target_table(l_plant,'aba_file'),   #FUN-A50102 
               " WHERE aba01 = '",p_trno,"'",
               "   AND aba00 = '",l_book,"'"  
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql      #FUN-A50102
   PREPARE t110_pt FROM l_sql
   DECLARE t110_plant CURSOR FOR t110_pt
   OPEN t110_plant 
   FETCH t110_plant INTO l_post 
   IF SQLCA.sqlcode THEN 
      IF p_type='0' THEN #FUN-CB0054 add
      CALL cl_err('sel aba:',STATUS,0)
      #FUN-CB0054--add--str--
      ELSE
         CALL s_errmsg('','','sel aba:',STATUS,1)
         LET g_success='N'
      END IF
      #FUN-CB0054--add--end
      RETURN 0    
   END IF
   IF l_post = 'Y' THEN 
      IF p_type='0' THEN #FUN-CB0054 add
      CALL cl_err(p_trno,'aap-144',0) 
      #FUN-CB0054--add--str--
      ELSE
         CALL s_errmsg('','','sel aba:',STATUS,1)
         LET g_success='N'
      END IF
      #FUN-CB0054--add--end
      RETURN 0
   END IF
   CALL cl_getmsg('aap-146',g_lang) RETURNING l_msg
   OPEN WINDOW t110_force_w AT 19,10 WITH 1 ROWS, 60 COLUMNS 
   WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT '   ',l_msg CLIPPED FOR CHAR l_chr
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
#            CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      
      END PROMPT
      IF INT_FLAG THEN LET l_chr = 'N' LET INT_FLAG=0 END IF
      IF l_chr MATCHES "[YyNn]" THEN EXIT WHILE END IF
   END WHILE
   CLOSE WINDOW t110_force_w
   CLOSE t110_plant 
   IF l_chr MATCHES "[Yy]" THEN
      RETURN 1
   ELSE
      IF p_type='1' THEN LET g_success='N' END IF  #FUN-CB0054
      RETURN 0
   END IF
END FUNCTION

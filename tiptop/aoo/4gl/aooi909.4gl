# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: aooi909
# Descriptions...: AMAM 多工廠環境設定作業 (層次: 0 )
# Date & Author..: 92/08/26 By Roger
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-820039 08/02/21 By alex 取消BDLASCII環境變數使用
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680102 SMALLINT
 
MAIN
    DEFINE l_ans_n	LIKE type_file.num10,          #No.FUN-680102INTEGER,
           l_ans_c	LIKE type_file.chr20           #No.FUN-680102CHAR(10), 
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
   OPEN WINDOW aooi909_w WITH FORM "aoo/42f/aooi909" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   WHILE TRUE
     INPUT l_ans_c FROM a 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
 
     END INPUT
 
     IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
     IF l_ans_c IS NULL THEN CONTINUE WHILE END IF
     LET l_ans_n = l_ans_c[1,2]
 
#    LET g_chr=FGL_GETENV("BDLASCII")     #FUN-820039
 
#    IF g_i=0 AND (g_chr='' OR g_chr='N') THEN
#       CASE l_ans_n
#          WHEN 0 EXIT WHILE
#          WHEN 1 RUN 'fglgo $AOOi/aoos900'
#          WHEN 2 RUN 'fglgo $AZZi/p_zx'
#          WHEN 3 RUN 'fglgo $AOOi/aooi901'
#          WHEN 4 RUN 'fglgo $AOOi/aooi902'
#       END CASE
#    ELSE
        CASE l_ans_n
           WHEN 0 EXIT WHILE
           WHEN 1 CALL cl_cmdrun_wait("aoos900")  #RUN '$FGLRUN $AOOi/aoos900.42r'
           WHEN 2 CALL cl_cmdrun_wait("p_zx")     #RUN '$FGLRUN $AZZi/p_zx.42r'
           WHEN 3 CALL cl_cmdrun_wait("aooi901")  #RUN '$FGLRUN $AOOi/aooi901.42r'
           WHEN 4 CALL cl_cmdrun_wait("aooi902")  #RUN '$FGLRUN $AOOi/aooi902.42r'
        END CASE
#    END IF
 
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN

# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asmq999.4gl
# Descriptions...: TIPTOP/MFG 目前關閉狀況查詢
# Date & Author..: 93/09/06 By David
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.TQC-920043 09/02/16 By liuxqa 拿掉smi07,smi08,避免有errcode.
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
     DEFINE
        g_smi           RECORD LIKE smi_file.*,  
        g_smj           RECORD LIKE smj_file.*,  
        p_msg           LIKE oea_file.oea01,#No.FUN-690010 VARCHAR(16),
        g_tty           LIKE oea_file.oea01 #No.FUN-690010 VARCHAR(16)
DEFINE  g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
 
MAIN
    OPTIONS 
          INPUT NO WRAP
    DEFER INTERRUPT 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW asmq999_w WITH FORM "asm/42f/asmq999" 
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL asmq999()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CLOSE WINDOW asmq999_w
END MAIN  
 
FUNCTION asmq999()
 
   DEFINE  l_str1      LIKE smi_file.smi06,#No.FUN-690010 VARCHAR(30),
           l_str2      LIKE smi_file.smi06 #No.FUN-690010 VARCHAR(30),
 
    IF g_sma.sma01 = 'Y' THEN
       CALL cl_getmsg('mfg9996',g_lang) RETURNING l_str1
       DISPLAY l_str1 TO smi06
       CALL cl_anykey(' ')
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    SELECT COUNT(*) INTO g_cnt FROM smi_file
    IF g_cnt = 1 THEN
       CALL asmq999_show()
       LET g_action_choice=""
       CALL asmq999_menu()
    ELSE
       CALL cl_getmsg('mfg9997',g_lang) RETURNING l_str1
       DISPLAY l_str1 TO smi06
       CALL cl_anykey(' ')
    END IF
END FUNCTION
 
FUNCTION asmq999_menu()
    MENU ""
       ON ACTION help 
          CALL cl_show_help()
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION exit
          LET g_action_choice = "exit"
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
       ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
            LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
    END MENU
END FUNCTION
 
FUNCTION asmq999_show()
   #DEFINE l_zz02 LIKE zz_file.zz02 #TQC-740155
 
    SELECT * INTO g_smi.* FROM smi_file 
    IF SQLCA.sqlcode THEN
#      CALL cl_err('Select smi_file :',SQLCA.sqlcode,1)   #No.FUN-660138
       CALL cl_err3("sel","smi_file",g_smi.smi01,g_smi.smi02,SQLCA.sqlcode,"","Select smi_file :",1) #No.FUN-660138
       RETURN
    END IF
   #TQC-740155.............begin
   #SELECT zz02 INTO l_zz02 
   # FROM zz_file WHERE zz01 = g_smi.smi02
   #IF SQLCA.sqlcode THEN
   #   CALL cl_err('Select zz_file:',SQLCA.sqlcode,1)  
   #   RETURN
   #END IF
   #TQC-740155.............end
    DISPLAY BY NAME g_smi.smi01,g_smi.smi02,g_smi.smi03,g_smi.smi04,
#                    g_smi.smi05,g_smi.smi06,g_smi.smi07,g_smi.smi08   #No.TQC-920043 mark by liuxqa
                    g_smi.smi05,g_smi.smi06                            #No.TQC-920043 mod by liuxqa
   #DISPLAY l_zz02 TO FORMONLY.p_desc #TQC-740155
    DISPLAY cl_get_progdesc(g_smi.smi02,g_lang) TO FORMONLY.p_desc #TQC-740155
   
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

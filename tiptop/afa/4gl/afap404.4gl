# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afap404.4gl
# Descriptions...: 固定資產稅簽月底結轉作業                    
# Date & Author..: 96/07/03 By Sophia
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言按紐在鼠標點擊下無效，要按鍵盤上‘ENTER’鍵，才會有效
# Modify.........: No.CHI-860025 08/07/23 By Smapmin 秀出下期年度/期別
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql	string,  #No.FUN-580092 HCN
        g_yy,g_mm	LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       b_date,e_date	LIKE type_file.dat,          #No.FUN-680070 DATE
       g_dc		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2	LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(20,6)
       g_foo		RECORD LIKE foo_file.*
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_flag          LIKE type_file.chr1,                  #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
DEFINE g_bookno1     LIKE aza_file.aza81       #CHI-A60036 add
DEFINE g_bookno2     LIKE aza_file.aza82       #CHI-A60036 add

MAIN
#     DEFINE   l_time LIKE type_file.chr8  	    #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgjob = ARG_VAL(1)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 MARK-
#   OPEN WINDOW p404_w AT p_row,p_col WITH FORM "afa/42f/afap404"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK-                              
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
    WHILE TRUE
    IF g_bgjob = "N" THEN
       CALL p404()
       IF g_flag = 'N' THEN
          CONTINUE WHILE
       END IF
       IF cl_sure(18,20) THEN
          CALL p404_1()
          CALL cl_end(0,0)
          IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
             (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
             IF cl_confirm('axr-240') THEN
                #CALL cl_cmdrun('afap405')       #FUN-660216 remark
                CALL cl_cmdrun_wait('afap405')   #FUN-660216 add
             END IF
          END IF
          IF g_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p404_w
             EXIT WHILE
          END IF
 
      ELSE
       CONTINUE WHILE
      END IF
   ELSE
     CALL p404_1()
     IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
         (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
         #CALL cl_cmdrun("afap405 'Y'")      #FUN-660216 remark
         CALL cl_cmdrun_wait("afap405 'Y'")  #FUN-660216 add
     END IF
     CALL cl_batch_bg_javamail(g_success)
     EXIT WHILE
  END IF
END WHILE
#   CALL p404()
#   CLOSE WINDOW p404_w
#->No.FUN-570144 ---end---
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p404()
  DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p404_w AT p_row,p_col WITH FORM "afa/42f/afap404"
   ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  #->No.FUN-570144 ---end---
 
  CLEAR FORM
  SELECT faa11,faa12 INTO g_yy,g_mm FROM faa_file
  DISPLAY g_yy TO FORMONLY.g_yy 
  DISPLAY g_mm TO FORMONLY.g_mm 
  #-----CHI-860025--------
  IF g_mm+1 >12 THEN
     DISPLAY g_yy+1 TO FORMONLY.g_yy2
     DISPLAY 1 TO FORMONLY.g_mm2
  ELSE
     DISPLAY g_yy TO FORMONLY.g_yy2
     DISPLAY g_mm+1 TO FORMONLY.g_mm2
  END IF
  #-----END CHI-860025----
 
  WHILE TRUE
#NO.FUN-570144 MARK--
#    CALL cl_opmsg('z')
 
#    IF NOT cl_sure(0,0) THEN RETURN END IF
#    CALL cl_wait()
#    CALL p404_1()
#    ERROR ''
#    IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
#        (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
#        IF cl_confirm('axr-240') THEN CALL cl_cmdrun('afap405') END IF
#    END IF
#    EXIT WHILE
#NO.FUN-570144 MARK--
 
#NO.FUN-570144 START--
  INPUT BY NAME g_bgjob WITHOUT DEFAULTS
    ON ACTION CONTROLG
       CALL cl_cmdask()
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about         #BUG-4C0121
       CALL cl_about()      #BUG-4C0121
       CALL cl_about()      #BUG-4C0121
 
    ON ACTION help          #BUG-4C0121
       CALL cl_show_help()  #BUG-4C0121
 
    ON ACTION locale           #genero
       CALL cl_dynamic_locale()    #No.TQC-6C0009
       CALL cl_show_fld_cont()     #No.TQC-6C0009
     #->No.FUN-570144 --start--
     #LET g_action_choice = "locale"
     #CALL cl_show_fld_cont()      #No.FUN-550037 hmf
#    LET g_change_lang = TRUE      #No.TQC-6C0009 mark
     #->No.FUN-570144 ---end---
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()      #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p404_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
      RETURN
   END IF
 
   IF g_bgjob = "Y" THEN
    SELECT zz08 INTO lc_cmd FROM zz_file
     WHERE zz01 = "afap404"
    IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
       CALL cl_err('afap404','9031',1)  
    ELSE
       LET lc_cmd = lc_cmd CLIPPED,
                    " '",g_bgjob CLIPPED,"'"
       CALL cl_cmdat('afap404',g_time,lc_cmd CLIPPED)
    END IF
    CLOSE WINDOW p404_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
 END IF
 EXIT WHILE
#->No.FUN-570144 ---end---
 
  END WHILE
END FUNCTION
 
FUNCTION p404_1()
   #CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date #CHI-A60036 mark
   #CHI-A60036 add --start--
   CALL s_get_bookno(g_yy)
      RETURNING g_flag,g_bookno1,g_bookno2
#  IF g_aza.aza63 = 'Y' THEN   
   IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
      CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING g_chr,b_date,e_date
   ELSE
     CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date
   END IF
   #CHI-A60036 add --end--
   #IF g_chr='1' THEN CALL cl_err('s_azm:error','',1) RETURN END IF
    IF g_chr='1' THEN CALL cl_err('s_azm:error','agl-101',1) RETURN END IF
 
    #-----更新系統參數檔----------
##No.     modify 1998/12/07
    IF NOT ((g_aza.aza02 = '1' AND g_mm = 12) OR
        (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
       UPDATE faa_file SET faa12 = faa12 + 1  #將稅簽現行期別加1
    END IF
  # UPDATE faa_file SET faa12 = faa12 + 1  #將稅簽現行期別加1
##--------------------------------------------
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#      CALL cl_err('upd faa',SQLCA.SQLCODE,0)   #No.FUN-660136
       CALL cl_err3("upd","faa_file","","",SQLCA.SQLCODE,"","upd faa",0)   #No.FUN-660136
       RETURN
    END IF
    ERROR ''
# Prog. Version..: '5.30.06-13.03.12(0,0)  #NO.FUN-570144 MARK
END FUNCTION

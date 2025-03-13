# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: afap405.4gl
# Descriptions...: 固定資產稅簽年底結轉作業                    
# Date & Author..: 96/07/03 By Sophia
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/07 By Rayven 語言按紐在鼠標點擊下無效，要按鍵盤上‘ENTER’鍵，才會有效
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql	string,  #No.FUN-580092 HCN
        g_yy,g_mm	LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       b_date,e_date	LIKE type_file.dat,          #No.FUN-680070 DATE
       g_dc		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2	LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(20,6)
       g_foo		RECORD LIKE foo_file.*
DEFINE p_row,p_col      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
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
 
#NO.FUN-570144 MARK--
#   OPEN WINDOW p405_w AT p_row,p_col WITH FORM "afa/42f/afap405"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK                              
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
   WHILE TRUE
#NO.FUN-570144 START--
   IF g_bgjob = "N" THEN
       CALL p405()
       IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
       (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
           IF cl_confirm('axr-240') THEN
              CALL p405_1()
              CALL cl_end(0,0)
           END IF
       ELSE
           CALL cl_err(' ','afa-131',1)
           CALL cl_end(0,0)
       END IF
       CLOSE WINDOW p405_w
       EXIT WHILE
   ELSE
       IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
       (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
           CALL p405_1()
           CALL cl_end(0,0)
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
   END IF
END WHILE
#   CALL p405()
#   CLOSE WINDOW p405_w
#->No.FUN-570144 ---end---
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p405()
  DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
  OPEN WINDOW p405_w AT p_row,p_col WITH FORM "afa/42f/afap405"
  ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
  #->No.FUN-570144 ---end---
 
  CLEAR FORM
  SELECT faa11,faa12 INTO g_yy,g_mm FROM faa_file
  DISPLAY g_yy TO FORMONLY.g_yy 
 
  WHILE TRUE
 
#NO.FUN-570144 MARK--
#    CALL cl_opmsg('z')
#    IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
#        (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
#        IF NOT cl_sure(0,0) THEN RETURN END IF
#    ELSE
#        CALL cl_err(' ','afa-131',1)
#        RETURN
#    END IF
#    CALL cl_wait()
#    CALL p405_1()
#    ERROR ''
#    EXIT WHILE
#NO.FUN-570144 MARK--
 
  INPUT BY NAME g_bgjob WITHOUT DEFAULTS
     ON ACTION CONTROLG
        CALL cl_cmdask()
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about#BUG-4C0121
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help#BUG-4C0121
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION locale         #genero
       CALL cl_dynamic_locale()    #No.TQC-6C0009
       CALL cl_show_fld_cont()     #No.TQC-6C0009
        #LET g_action_choice = "locale"
        #CALL cl_show_fld_cont()      #No.FUN-550037 hmf
#       LET g_change_lang = TRUE      #No.TQC-6C0009 mark
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
     CLOSE WINDOW p405_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
     RETURN
  END IF
    IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "afap405"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap405','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('afap405',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p405_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
    END IF
    EXIT WHILE
  #->No.FUN-570144 ---end---
 
  END WHILE
END FUNCTION
 
FUNCTION p405_1()
  DEFINE l_faj RECORD LIKE faj_file.* # saki 20070821 rowid chr18 -> num10 
 
  #-----更新系統參數檔(faa_file.faa07)
  UPDATE faa_file SET faa11 = faa11 + 1,
                      faa12 = 1 
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#    CALL cl_err('upd faa',SQLCA.SQLCODE,0)   #No.FUN-660136
     CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","upd faa",0)   #No.FUN-660136
     RETURN
  END IF
 
  #-----更新系固定資產(faj_file.faj205/faj206)
  DECLARE p405_faj_c CURSOR FOR SELECT * FROM faj_file WHERE 1= 1 
  FOREACH p405_faj_c INTO l_faj.* 
     IF SQLCA.sqlcode THEN 
        CALL cl_err('p405_faj_c',SQLCA.sqlcode,0)
        EXIT FOREACH 
     END IF
     UPDATE faj_file SET faj205 = 0,faj206 = 0 WHERE faj01 = l_faj.faj01 AND faj02 = l_faj.faj02 AND faj022 = l_faj.faj022  
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#       CALL cl_err('up faj_file ',SQLCA.sqlcode,0)  #No.FUN-660136
        CALL cl_err3("upd","faj_file","","",SQLCA.sqlcode,"","up faj_file ",0)   #No.FUN-660136
        LET g_success = 'N'  
        EXIT FOREACH  
     END IF
  END FOREACH  
  ERROR ''
# Prog. Version..: '5.30.06-13.03.12(0,0)  #NO.FUN-570144 MARK4
END FUNCTION

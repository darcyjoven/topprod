# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: afap010.4gl
# Descriptions...: 固定資產關帳作業
# Date & Author..: 98/07/17 BY Raymon
# Modify.........: No.FUN-570144 06/03/02 By yiting 批次背景執行功能
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善" 追單
# Modify.........: No:MOD-D40132 13/05/18 By SunLM  關帳日期不可小於等於主帳別總賬關帳日期
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     tm        RECORD
                  faa09  LIKE faa_file.faa09,
                  faa092 LIKE faa_file.faa092,  #No:FUN-B60140
                  faa13  LIKE faa_file.faa13
               END RECORD,
     g_faa09   LIKE faa_file.faa09,                     #系統關帳日期       #No.FUN-680070 DATE
     g_faa092  LIKE faa_file.faa092,  #No:FUN-B60140
     g_faa13   LIKE faa_file.faa13                      #稅簽關帳日期       #No.FUN-680070 DATE
DEFINE   g_change_lang   LIKE type_file.chr1            #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)

MAIN
    DEFINE ls_date       STRING                         #->No.FUN-570144
    DEFINE l_flag        LIKE type_file.chr1            #NO.FUN-570144      #No.FUN-680070 VARCHAR(1)
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date  = ARG_VAL(1)
   LET tm.faa09 = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(2)
   LET tm.faa13 = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob  = ARG_VAL(3)      #背景作業
   LET ls_date  = ARG_VAL(4)  #No:FUN-B60140
   LET tm.faa092= cl_batch_bg_date_convert(ls_date)  #No:FUN-B60140
 
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
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0069 

   WHILE TRUE
     IF g_bgjob = "N" THEN
        CALL afap010_tm(0,0)
        IF cl_sure(18,20) THEN
           LET g_success = 'Y'
           BEGIN WORK
           CALL afap010_process()
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p010_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL afap010_process()
        IF g_success = "Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0069 
END MAIN
 
FUNCTION afap010_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_str         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
            l_flag        LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
   DEFINE   lc_cmd    LIKE type_file.chr1000     #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
   DEFINE   l_aaa07       LIKE aaa_file.aaa07    #MOD-D40132 add
 
   OPEN WINDOW afap010_w WITH FORM "afa/42f/afap010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
   #-----No:FUN-B60140-----
   IF g_faa.faa31 = 'Y' THEN
      CALL cl_set_comp_visible("faa092",TRUE)
   ELSE
      CALL cl_set_comp_visible("faa092",FALSE)
   END IF
   #-----No:FUN-B60140 END-----

   INITIALIZE tm.* TO NULL                   # Defaealt condition
   SELECT faa09,faa092,faa13 INTO g_faa09,g_faa092,g_faa13  #No:FUN-B60140
     FROM faa_file WHERE faa00 = '0'
   LET tm.faa09 = g_faa09
   LET tm.faa092= g_faa092  #No:FUN-B60140
   LET tm.faa13 = g_faa13
   CLEAR FORM 
   DISPLAY BY NAME tm.faa09,tm.faa092,tm.faa13  #No:FUN-B60140 
 
#->No.FUN-570144 --start--
   LET g_bgjob = "N"
   WHILE TRUE
   INPUT BY NAME tm.faa09,tm.faa092,tm.faa13,g_bgjob WITHOUT DEFAULTS #No:FUN-B60140
#NO.FUN-570144 END---
 
      AFTER FIELD faa09
         IF tm.faa09  IS NULL OR tm.faa09 = ' ' THEN
            NEXT FIELD faa09
         END IF
         #MOD-D40132 add beg-----
         SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01= g_aza.aza81
         IF tm.faa09 <=l_aaa07 THEN 
            CALL cl_err(l_aaa07,'asm-994',1)
            NEXT FIELD faa09
         END IF     
         #MOD-D40132 add end-----        
      #-----No:FUN-B60140-----
      AFTER FIELD faa092
         IF tm.faa092  IS NULL OR tm.faa092 = ' ' THEN
            NEXT FIELD faa092
         END IF
      #-----No:FUN-B60140 END-----

      AFTER FIELD faa13
         IF tm.faa13  IS NULL OR tm.faa13 = ' ' THEN
            NEXT FIELD faa13
         END IF
         #MOD-D40132 add beg-----
         SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01= g_aza.aza81
         IF tm.faa13 <=l_aaa07 THEN 
            CALL cl_err(l_aaa07,'asm-994',1)
            NEXT FIELD faa13
         END IF     
         #MOD-D40132 add end-----   
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
       ON ACTION locale
          LET g_change_lang = TRUE               #No.FUN-570144
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT INPUT
          # CALL cl_dynamic_locale()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
  #->No.FUN-570144 --start--
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p010_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "afap010"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap010','9031',1)
     ELSE
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm.faa09 CLIPPED,"'",
                     " '",tm.faa13 CLIPPED,"'",
                     " '",g_bgjob  CLIPPED,"'",
                     " '",tm.faa092 CLIPPED,"'"  #No:FUN-B60140
        CALL cl_cmdat('afap010',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p010_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
  #->No.FUN-570144 ---end---
 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 EXIT PROGRAM
#   END IF
#   IF cl_sure(21,21) THEN
#      CALL cl_wait()
#      UPDATE faa_file SET faa09=tm.faa09,faa13=tm.faa13 WHERE faa00='0'
#   END IF
#   CALL cl_end(0,0) 
#   ERROR ""
#   CLOSE WINDOW afap010_w
END FUNCTION
 
FUNCTION afap010_process()
   UPDATE faa_file SET faa09=tm.faa09,
                       faa092= tm.faa092,  #No:FUN-B60140
                       faa13=tm.faa13 
    WHERE faa00='0'
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]= 0 THEN
      LET g_success='N'
   END IF
END FUNCTION 

# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: axrp401.4gl
# Descriptions...: 應收帳務關帳作業
# Input parameter: 
# Return code....: 
# Date & Author..: 97/04/21 BY Joanne
# Modify.........: No.FUN-570247 05/07/26 BY Elva show會計年度期別
# Modify.........: No.FUN-570156 06/03/09 By saki 批次背景執行
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換 
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-D40132 13/05/18 By SunLM  關帳日期不可小於等於主帳別總賬關帳日期
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     #FUN-570247  --begin
      tm        RECORD
               aaa04  LIKE aaa_file.aaa04, 
               aaa05  LIKE aaa_file.aaa05,
               ooz09  LIKE ooz_file.ooz09
               END RECORD,
      g_aaa04   LIKE type_file.num5,      #現行會計年度  #No.FUN-680123 SMALLINT
      g_aaa05   LIKE type_file.num5,      #現行期別      #No.FUN-680123 SMALLINT
     #FUN-570247  --end
      g_ooz09   LIKE type_file.dat        #現行關帳日期  #No.FUN-680123 DATE    
DEFINE p_row,p_col       LIKE type_file.num5             #No.FUN-680123 SMALLINT
DEFINE # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570156
        g_change_lang    LIKE type_file.chr1             #No.FUN-680123 VARCHAR(01)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8             #No.FUN-6A0095
   DEFINE ls_date        STRING                          #No.FUN-570156 
   DEFINE l_flag         LIKE type_file.chr1             #No.FUN-570156 #No.FUN-680123 VARCHAR(1)
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date  = ARG_VAL(1)
   LET tm.ooz09 = cl_batch_bg_date_convert(ls_date) #現行關帳日期 
   LET g_bgjob = ARG_VAL(2)     #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   #No.FUN-570156 --start--
#  CALL axrp401_tm(0,0)
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL axrp401_tm(0,0)
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            BEGIN WORK
            CALL p401()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p401_w 
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p401()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570156 ---end---

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION axrp401_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680123 SMALLINT
            l_str         LIKE aac_file.aac02,         #No.FUN-680123 VARCHAR(30)
            l_flag        LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)  
   DEFINE  #lc_cmd        VARCHAR(500)                     #No.FUN-570156
            lc_cmd        LIKE zz_file.zz08             #No.FUN-680123 VARCHAR(500)
   DEFINE li_chk_bookno   LIKE type_file.num5           #No.FUN-670006 #No.FUN-680123 SMALLINT  
   DEFINE l_aaa07   LIKE aaa_file.aaa07                 #MOD-D40132 add
 
 
   LET p_row = 5 LET p_col = 14
 
   OPEN WINDOW axrp401_w AT p_row,p_col
        WITH FORM "axr/42f/axrp401" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
  
   WHILE TRUE
     INITIALIZE tm.* TO NULL                   # Defaealt condition
     
     #FUN-570247  --begin
     SELECT aaa04,aaa05 INTO g_aaa04,g_aaa05 FROM aaa_file 
      WHERE aaa01 = g_ooz.ooz02b
     LET tm.aaa04 = g_aaa04
     LET tm.aaa05 = g_aaa05
     #FUN-570247  --end
     SELECT ooz09 INTO g_ooz09
       FROM ooz_file WHERE ooz00 = '0'
     LET tm.ooz09 = g_ooz09
     CLEAR FORM 
     
     DISPLAY BY NAME tm.aaa04,tm.aaa05,tm.ooz09  #FUN-570247
     
     LET g_bgjob = "N"     #No.FUN-570156
     INPUT BY NAME tm.ooz09,g_bgjob WITHOUT DEFAULTS   #No.FUN-570156
     
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        AFTER FIELD ooz09
           IF tm.ooz09  IS NULL OR tm.ooz09 = ' ' THEN
              NEXT FIELD ooz09
           END IF
           #MOD-D40132 add beg-----
           SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01= g_aza.aza81
           IF tm.ooz09 <=l_aaa07 THEN 
              CALL cl_err(l_aaa07,'asm-994',1)
              NEXT FIELD ooz09
           END IF     
           #MOD-D40132 add end-----      
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
        ON ACTION CONTROLG
           CALL cl_cmdask()
     
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     
        ON ACTION exit   #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
 
        ON ACTION locale #genero
           #No.FUN-570156 --start--
#        LET g_action_choice = "locale"
           LET g_change_lang = TRUE
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           #No.FUN-570156 ---end---
         EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
     END INPUT
     #No.FUN-570156 --start--
#    IF g_action_choice = "locale" THEN  #genero
     IF g_change_lang THEN
#       LET g_action_choice = ""
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()
        CONTINUE WHILE
     END IF
     #No.FUN-570156 ---end---
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0 
        CLOSE WINDOW p401_w    #No.FUN-570156
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM  
     END IF
 
     #No.FUN-570156 --start--
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "axrp401"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axrp401','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.ooz09 CLIPPED,"'",
                        " '",g_bgjob  CLIPPED,"'"
           CALL cl_cmdat('axrp401',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p401_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
 
     #No.FUN-570156 ----將此段移至 p401()
#    IF cl_sure(21,21) THEN
#       CALL cl_wait()
#       UPDATE ooz_file SET ooz09 = tm.ooz09 WHERE ooz00='0'
#       IF SQLCA.SQLCODE THEN
#          CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#       ELSE
#          CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#       END IF
#       IF l_flag THEN
#          ERROR ""
#          CONTINUE WHILE
#       ELSE
#          EXIT WHILE
#       END IF
#    END IF
   END WHILE
#  CLOSE WINDOW axrp401_w
   #No.FUN-570156 ---end---   
END FUNCTION
 
#No.FUN-570156 --start--
FUNCTION p401()
   IF g_bgjob = "N" THEN     #No.FUN-570156
      CALL cl_wait()
   END IF                    #No.FUN-570156
   UPDATE ooz_file SET ooz09 = tm.ooz09 WHERE ooz00='0'
   IF SQLCA.SQLCODE THEN
      LET g_success = "N"        #批次作業失敗
   ELSE
      LET g_success = "Y"        #批次作業正確結束
   END IF
END FUNCTION
#No.FUN-570156 ---end---

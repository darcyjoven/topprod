# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: armp200.4gl
# Descriptions...: 轉雜收發單還原作業
# Date & Author..: 98/09/16 plum
# Modify.........: No.FUN-570149 06/03/13 By YITING 背景作業
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-660079 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm RECORD
        wc STRING,                       #QBE條件
        cfConfirm   LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01)                 #是否逐一確認
    END RECORD 
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE   g_change_lang   LIKE type_file.chr1    # Prog. Version..: '5.30.06-13.03.12(01)        #No.FUN-570149
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc        = ARG_VAL(1)
   LET tm.cfConfirm = ARG_VAL(2)
   LET g_bgjob      = ARG_VAL(3)

   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   CALL p200_cmd(0,0)          #condition input
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
 
END MAIN
 
FUNCTION p200_cmd(p_row,p_col)
DEFINE l_flag      LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    WHILE TRUE
        IF g_bgjob = 'N' THEN        #No.FUN-570149
           CALL p200_i()                      #No.FUN-570149
           IF cl_sure(0,0) THEN
              LET g_success='Y'
              BEGIN WORK                            #No.FUN-570149
              CALL p200_p()
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
                 CLOSE WINDOW p200_w
                 EXIT WHILE
              END IF
              CLOSE WINDOW p200_w
           ELSE
              CONTINUE WHILE
           END IF
        ELSE
           LET g_success='Y'
           BEGIN WORK                            #No.FUN-570149
           CALL p200_p()
           IF g_success = 'Y' THEN
              COMMIT WORK
           ELSE
              ROLLBACK WORK
           END IF
           CALL cl_batch_bg_javamail(g_success)
           EXIT WHILE
        END IF
    END WHILE
END FUNCTION
 
FUNCTION p200_i()
DEFINE lc_cmd      LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(500)
 
   OPEN WINDOW p200_w WITH FORM "arm/42f/armp200"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   LET g_action_choice = ''
 
#FUN-570149 --end---
 
   CLEAR FORM 
   INITIALIZE tm.* TO NULL
   #QBE
   WHILE TRUE   #NO.FUN-570149 
   CONSTRUCT BY NAME tm.wc ON rmd21 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
        #  LET g_action_choice='locale'  #NO.FUN-570149  
           LET g_change_lang = TRUE      #NO.FUN-570149 
         EXIT CONSTRUCT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT CONSTRUCT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#NO.FUN-570149 start--
#   IF INT_FLAG THEN RETURN END IF
#   IF g_action_choice = 'locale' THEN RETURN END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#No.FUN-570149 ---end---
 
   IF tm.wc=" 1=1" THEN CALL cl_err('','arm-001',0) 
      LET g_action_choice = 'continue'
      RETURN 
   END IF
 
   LET tm.cfConfirm='N'
   LET g_bgjob = 'N'          #No.FUN-570149
   #INPUT BY NAME tm.cfConfirm WITHOUT DEFAULTS 
   INPUT BY NAME tm.cfConfirm,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570149
 
      AFTER FIELD cfConfirm
         IF tm.cfConfirm IS NULL OR tm.cfConfirm NOT MATCHES '[YN]' THEN 
            NEXT FIELD cfConfirm
         END IF
 
      AFTER INPUT    #檢查必要欄位是否輸入
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
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
 
      ON ACTION locale
#FUN-570149--end---
         #  LET g_action_choice='locale'
            LET g_change_lang = TRUE
#FUN-570149--end---
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570149  start-
#   IF g_action_choice = 'locale' THEN
#      RETURN
#   END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = "armp200"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('armp200','9031',1)
         ELSE
             LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.wc CLIPPED,"'",
                         " '",tm.cfConfirm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('armp200',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p200_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#No.FUN-570149 ---end---
END FUNCTION
 
FUNCTION p200_p()
DEFINE
    l_pro  RECORD
         # rmd01   LIKE rmd_file.rmd01,    #RMA號
           rmd21   LIKE rmd_file.rmd21,    #RMA雜收發單號
           ina01   LIKE ina_file.ina01,    #雜收發單號
           inapost LIKE ina_file.inapost   #雜收發單過帳碼
           END RECORD,
    l_sql  LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(300)
    l_cnt  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    #組SQL
    let l_cnt=0  LET g_success='Y'
    LET l_sql="SELECT COUNT(distinct rmd21) FROM rmd_file,ina_file ",
              " WHERE rmd21=ina01 AND ", tm.wc clipped
    PREPARE p200_count1 FROM l_sql
    IF SQLCA.SQLCODE THEN
        CALL cl_err('p200_count1',SQLCA.SQLCODE,1) RETURN
    END IF
    DECLARE p200_cnt1   CURSOR FOR p200_count1 
    OPEN p200_cnt1
    FETCH P200_cnt1 INTO l_cnt
    IF l_cnt is null or l_cnt=0 THEN 
       CALL cl_err(tm.wc clipped,'aap-129',1)
       CLOSE p200_cnt1 
       LET g_success='N' RETURN 
    END IF
    LET l_sql="SELECT unique(rmd21),ina01,inapost ",
              " FROM rmd_file,ina_file ", 
             #" WHERE rmd21=ina01 AND inapost != 'Y' AND inapost !='X' ", #FUN-660079
              " WHERE rmd21=ina01 AND inaconf = 'N' ", #FUN-660079
              "   AND ",tm.wc clipped
   {IF  tm.wc!=' 1=1' THEN
        LET l_sql=l_sql CLIPPED,' AND ',tm.wc CLIPPED
    ELSE  
        LET l_sql=l_sql CLIPPED,' AND rmd21 IS NOT NULL AND ',tm.wc CLIPPED
    END IF}
    PREPARE p200_pre  FROM l_sql
    IF SQLCA.SQLCODE THEN
        CALL cl_err('p200_pre:',SQLCA.SQLCODE,1) RETURN
    END IF
    DECLARE p200_cur  CURSOR FOR p200_pre
 
    #取得資料
    LET l_cnt=0
    FOREACH p200_cur INTO l_pro.*
        IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
        IF tm.cfconfirm='Y' THEN 
           IF g_bgjob = 'N' THEN   #FUN-570149
               PROMPT ' R/I NO: ',l_pro.ina01,' inapost=',l_pro.inapost,' ->(Y/N): '
                      FOR g_chr
           ELSE
              LET g_chr = 'Y'      #FUN-570149
           END IF
           IF g_chr='N' THEN CONTINUE FOREACH END IF
        ELSE
           IF g_bgjob = 'N' THEN   #FUN-570149
               MESSAGE 'R/I NO: ',l_pro.ina01,' inapost=',l_pro.inapost sleep 1
               CALL ui.Interface.refresh()
           END IF
        END IF
        IF l_pro.inapost='Y' THEN
           CALL cl_err(l_pro.ina01,9023,1) 
           CONTINUE FOREACH 
        END IF 
       #FUN-660079 mark
       #IF l_pro.inapost='X' THEN
       #   CALL cl_err(l_pro.ina01,9024,1) 
       #   CONTINUE FOREACH 
       #END IF 
        UPDATE rmd_file set rmd21=NULL,rmd22=NULL
         WHERE rmd21=l_pro.ina01
        IF SQLCA.SQLCODE THEN
  #         CALL cl_err(l_pro.ina01,SQLCA.SQLCODE,0) # FUN-660111
          CALL cl_err3("upd","rmd_file",l_pro.ina01,"",SQLCA.sqlcode,"","",0) # FUN-660111
           LET g_success='N' RETURN
        END IF
       #UPDATE ina_file set inapost='X' WHERE ina01=l_pro.ina01 #FUN-660079
        UPDATE ina_file set inaconf='X' WHERE ina01=l_pro.ina01 #FUN-660079
        IF SQLCA.SQLCODE THEN
  #         CALL cl_err(l_pro.ina01,SQLCA.SQLCODE,0) # FUN-660111
        CALL cl_err3("upd","ina_file",l_pro.ina01,"",SQLCA.sqlcode,"","",0) # FUN-660111
           LET g_success='N' RETURN
        END IF
        LET l_cnt=l_cnt+1
    END FOREACH
  # IF l_cnt=0 THEN
  #    CALL cl_end(0,0) 
  # ELSE
  #    CALL cl_err(tm.wc clipped,'aap-129',0) 
  # END IF
 
END FUNCTION

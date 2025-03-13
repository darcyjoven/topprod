# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aoop010.4gl
# Descriptions...: 每日匯率複製作業
# Date & Author..: 91/10/15 By Lin
# Memo...........: 本作業執行時無任何畫面顯示
# Modify.........: 01/02/07 By Kammy (多幣別需按最大日複製)            
# Modify.........: No.MOD-490194 05/04/28 By pengu show來源幣別,來源匯率日期, 來源匯率 
# Modify.........: NO.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: NO.MOD-590419 
# Modify.........: NO.FUN-570250 05/12/23 By Rosayu 將日期取消寫死YY/MM/DD
# Modify.........: No.FUN-570147 06/03/09 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.TQC-6A0090 06/11/01 By baogui 表頭少了公司名稱顯示
# Modify.........: No.FUN-710030 07/01/15 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-770001 07/07/02 By sherry  維護幫助按鈕功能
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_azk       RECORD LIKE azk_file.*,
       g_day       LIKE type_file.dat,            #No.FUN-680102DATE ,  #日期
       g_sw        LIKE type_file.chr1,           #No.FUN-680102CHAR(1),
       l_buf       LIKE type_file.chr1000,       #No.FUN-680102CHAR(60),
       i           LIKE type_file.num10          #No.FUN-680102
DEFINE g_cnt       LIKE type_file.num10            #No.FUN-680102 INTEGER
DEFINE   l_flag         LIKE type_file.chr1,                  #No.FUN-570147        #No.FUN-680102 VARCHAR(1)
         g_change_lang  LIKE type_file.chr1,           # Prog. Version..: '5.30.06-13.03.12(01),        #是否有做語言切換 No.FUN-570147
         ls_date        STRING                  #->No.FUN-570147
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
#->No.FUN-570147 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgjob  = ARG_VAL(1)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570147 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CLOSE WINDOW screen
 
   IF s_shut(0) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
 
#->No.FUN-570147 ---start---
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      INITIALIZE g_azk.* TO NULL
      SELECT COUNT(*) INTO g_cnt   #每日匯率檔內,無任何資料時,無法執行複製作業
        FROM azk_file
      IF g_cnt <=0 THEN
         CALL cl_err('','aoo-053',1)
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'N' THEN
         CALL p010_tm()
         IF cl_sure(21,21) THEN
            BEGIN WORK
            CALL p010_a()
            CALL s_showmsg()                          #No.FUN-710030
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
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p010_w
      ELSE
         BEGIN WORK
         CALL p010_a()
         CALL s_showmsg()                          #No.FUN-710030
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #No.FUN-6A0081
END MAIN
 
#NO.FUN-570147 start-----
FUNCTION p010_tm()
   DEFINE   lc_cmd        LIKE type_file.chr1000        #No.FUN-680102 VARCHAR(500)    #FUN-570147
   DEFINE   l_flag        LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
            l_cmd         LIKE type_file.chr1000       #No.FUN-680102CHAR(400)
 
   OPEN WINDOW p010_w WITH FORM "aoo/42f/aoop010"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET g_bgjob = 'N'
   WHILE TRUE
      INPUT BY NAME g_bgjob WITHOUT DEFAULTS     #FUN-570147
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION help          #No.TQC-770001                                      
            CALL cl_show_help()  #No.TQC-770001 
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION locale        #FUN-570147
            LET g_change_lang = TRUE
            EXIT INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
      END INPUT
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p010_w              #FUN-570151
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM                     #FUN-570151
   END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aoop010'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aoop010','9031',1)    
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_bgjob CLIPPED, "'"
           CALL cl_cmdat('aoop010',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p010_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
END WHILE
#FUN-570147 --end--
END FUNCTION
 
FUNCTION p010_a()
    DEFINE l_n        LIKE type_file.num5          #No.FUN-680102 SMALLINT
    DEFINE l_name     LIKE type_file.chr20      #No.MOD-490194        #No.FUN-680102 VARCHAR(20)
    DEFINE l_azi01    LIKE azi_file.azi01
 
    INITIALIZE g_azk.* LIKE azk_file.*
    LET l_n = 0 
 
    DECLARE azi_cs CURSOR FOR SELECT azi01 FROM azi_file
 
#----------------------MOD-490194-----------------------------
    #CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:BUG-580088  HCN 20050818 #MOD-580222 mark  #No.FUN-6A0081
    CALL cl_outnam('aoop010') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang   #TQC-6A0090
    START REPORT p010_rep TO l_name
    LET g_pageno = 0
    #----------------------MOD-490194-----------------------------
    CALL s_showmsg_init()
    FOREACH azi_cs INTO l_azi01
#No.FUN-710030 -- begin --
       IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success="Y"
       END IF
#No.FUN-710030 -- end --
       LET l_n = l_n + 1
       SELECT * FROM azk_file WHERE azk01 = l_azi01 AND azk02 = g_today
       #此幣別本日匯率已存在
       IF SQLCA.sqlcode = 0 THEN CONTINUE FOREACH END IF
 
       SELECT MAX(azk02) INTO g_day FROM azk_file
          WHERE azk01 = l_azi01 AND azk02 != '9999/12/31'
       #若沒有可複製的資料
       IF cl_null(g_day) THEN CONTINUE FOREACH END IF
 
       # 複製 azk_file
        SELECT * INTO g_azk.* FROM azk_file 
         WHERE  azk01 = l_azi01 AND azk02 = g_day
        FOR i = g_day+1 TO g_today
            LET g_azk.azk02 = i
            IF g_bgjob = 'N' THEN  #NO.FUN-570147 
                MESSAGE l_azi01,':',g_azk.azk02
                CALL ui.Interface.refresh()
            END IF
            INSERT INTO azk_file VALUES(g_azk.*)
            IF STATUS THEN
#              CALL cl_err('ins azk:',STATUS,1)   #No.FUN-660131
#No.FUN-710030 -- begin --
#               CALL cl_err3("ins","azk_file",g_azk.azk01,g_azk.azk02,STATUS,"","ins azk:",1)    #No.FUN-660131
               IF g_bgerr THEN
                  LET g_showmsg = g_azk.azk01,"/",g_azk.azk02
                  CALL s_errmsg('azk01,azk02',g_showmsg,'ins azk',STATUS,1)
               ELSE
                  CALL cl_err3("ins","azk_file",g_azk.azk01,g_azk.azk02,STATUS,"","ins azk:",1)
               END IF
#No.FUN-710030 -- end --
            ELSE 
                OUTPUT TO REPORT p010_rep(g_azk.*)        #No.MOD-490194
            END IF
        END FOR
 
        # insert 一筆至9999/12/31
        LET g_azk.azk02 = '9999/12/31'
        INSERT INTO azk_file VALUES(g_azk.*)
     ## IF SQLCA.sqlcode = -239 THEN  ##FUN-790031
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
           UPDATE azk_file 
SET  azk03=g_azk.azk03,azk04=g_azk.azk04,
     azk041=g_azk.azk041,azk05=g_azk.azk05,
     azk051=g_azk.azk051,azk052=g_azk.azk052 
              WHERE azk01 = l_azi01 AND azk02 = '9999/12/31'
           IF STATUS THEN
#             CALL cl_err(g_azk.azk01,STATUS,1)   #No.FUN-660131
#No.FUN-710030 -- begin --
#              CALL cl_err3("upd","azk_file",g_azk.azk01,"",STATUS,"","",1)    #No.FUN-660131
              IF g_bgerr THEN
                 CALL s_errmsg('azk01',g_azk.azk01,'',STATUS,1)
              ELSE
                 CALL cl_err3("upd","azk_file",g_azk.azk01,"",STATUS,"","",1)
              END IF
#No.FUN-710030 -- end --
           END IF
        END IF
#---------------------------No.MOD-490194--------------------------------
    END FOREACH
#No.FUN-710030 -- begin --
    IF g_totsuccess='N' THEN
       LET g_success='N'
    END IF
#No.FUN-710030 -- end --
 
    FINISH REPORT p010_rep
 
    IF l_n = 0 THEN
       CALL cl_err('aoo-107',STATUS,1) 
    ELSE  
       IF cl_confirm('aoo-010') THEN
          CALL cl_prt(l_name,g_prtway,g_copies,g_len)
       END IF
    END IF 
 
END FUNCTION
 
REPORT p010_rep(sr)
   DEFINE sr    RECORD LIKE azk_file.*
   DEFINE l_last_sw    LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)
 
   OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
   ORDER BY sr.azk01
   FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED, g_x[32] CLIPPED, g_x[33] CLIPPED, g_x[34] CLIPPED,
            g_x[35] CLIPPED, g_x[36] CLIPPED, g_x[37] CLIPPED, g_x[38] CLIPPED
      PRINT g_dash1
      LET l_last_sw = 'n'
 
 
    BEFORE GROUP OF sr.azk01
        PRINT COLUMN g_c[31],sr.azk01 CLIPPED;
 
    ON EVERY ROW
      SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=sr.azk01
      #PRINT COLUMN g_c[32],sr.azk02 USING "yyyy/mm/dd"  CLIPPED, #FUN-570250 mark
      PRINT COLUMN g_c[32],sr.azk02, #FUN-570250 add
            COLUMN g_c[33], cl_numfor(sr.azk03 ,33,t_azi07) CLIPPED,
            COLUMN g_c[34], cl_numfor(sr.azk04 ,34,t_azi07) CLIPPED,
            COLUMN g_c[35], cl_numfor(sr.azk041,35,t_azi07) CLIPPED,
            COLUMN g_c[36], cl_numfor(sr.azk05 ,36,t_azi07) CLIPPED,
            COLUMN g_c[37], cl_numfor(sr.azk051,37,t_azi07) CLIPPED,
            COLUMN g_c[38], cl_numfor(sr.azk052,38,t_azi07) CLIPPED
 
    ON LAST ROW
     LET l_last_sw = 'y'
     PRINT g_dash[1,g_len]
     PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
    PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
#-------------------------------------No.MOD-490194------------------------------------
 

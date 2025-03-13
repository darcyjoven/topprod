# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: aims100.4gl
# Descriptions...: 週期盤點起始日期設定作業
# Date & Author..: 92/09/07 By yen
# Modify.........: 93/12/28 By Apple
# Modify.........: By Melody   1.Update ima_file set ima902 = g_ima.ima30
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: No.TQC-620073 06/02/21 By pengu  修改允許擷取工作日的最大筆數
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
#
 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       tm          RECORD
                   a     LIKE type_file.chr1,    #起始日期設定方式  #No.FUN-690026 VARCHAR(1)
                   b     LIKE type_file.chr1,    #料件排列方式      #No.FUN-690026 VARCHAR(1)
                   c     LIKE type_file.chr1,    #日期處理方式      #No.FUN-690026 VARCHAR(1)
                   ima30 LIKE ima_file.ima30     #盤點起始日期      #No.FUN-690026 DATE       
                   END RECORD,
       g_ima       RECORD LIKE ima_file.*,
       l_ima30     LIKE ima_file.ima30,
       ave_a       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       ave_b       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       ave_c       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       arr_a       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       arr_b       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       arr_c       LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       wk_a        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       wk_b        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       wk_c        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_date      LIKE type_file.dat      #No.FUN-690026 DATE
DEFINE p_row,p_col           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt                 LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    LET p_row = 3 LET p_col = 12
 
    OPEN WINDOW s100_w AT p_row,p_col
        WITH FORM "aim/42f/aims100"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
    CALL s100_tm()
    CLOSE WINDOW s100_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION s100_tm()
   DEFINE l_dir   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   DEFINE l_flag  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   CALL cl_opmsg('z')
 WHILE TRUE
   LET g_success = 'Y'
   INITIALIZE tm.* TO NULL         # Default condition
   LET l_dir =' '
   LET tm.a='1'
   LET tm.ima30=g_sma.sma30
 
   INPUT BY NAME tm.* WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s100_set_entry()
         CALL s100_set_no_entry()
         LET g_before_input_done = TRUE
      ON CHANGE a
         IF tm.a = '1' THEN
             CALL s100_set_no_entry()
             LET tm.b = NULL
             LET tm.c = NULL
         ELSE
             CALL s100_set_entry()
             IF cl_null(tm.b) THEN LET tm.b = '1' END IF
             IF cl_null(tm.c) THEN LET tm.c = '1' END IF
         END IF
         DISPLAY BY NAME tm.b,tm.c
      AFTER FIELD a
         IF tm.a NOT MATCHES "[12]" OR tm.a IS NULL
            THEN NEXT FIELD a
         END IF
       # IF tm.a='1' THEN
       #    LET l_dir ='D'   LET tm.b = ' '  LET tm.c = ' '
       #    DISPLAY BY NAME tm.b,tm.c
       #    NEXT FIELD ima30
       # END IF
 
      AFTER FIELD b
         IF tm.b NOT MATCHES "[12]" OR tm.b IS NULL
            THEN NEXT FIELD b
         END IF
 
      AFTER FIELD c
         IF tm.c NOT MATCHES "[12]" OR tm.c IS NULL
            THEN NEXT FIELD c
         END IF
 
       AFTER FIELD ima30
         IF tm.ima30 IS NULL THEN NEXT FIELD ima30 END IF
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
     ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
     ON ACTION locale
        LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        EXIT INPUT
 
     ON ACTION exit
        LET g_action_choice='exit'
        EXIT WHILE
 
   END INPUT
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW s100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   CASE g_lang
     WHEN '0'
 #No.MOD-580322--begin
#      ERROR ' 警告! 處理後即將改變其最後盤點日期以供後續周盤報表使用 '
       CALL cl_err('','aim-991','0')
     WHEN '2'
#      ERROR ' 警告! 處理後即將改變其最後盤點日期以供後續周盤報表使用 '
       CALL cl_err('','aim-991','0')
     OTHERWISE
       CALL cl_err('','aim-991','0')
#      ERROR ' Warning! this action will change final count date !!!! '
 #No.MOD-580322--end
 
   END CASE
   IF cl_sure(0,0) THEN
       CALL cl_wait()
       CALL s100_u()
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
          EXIT WHILE
       END IF
   END IF
   ERROR ""
END WHILE
END FUNCTION
 
FUNCTION s100_u()
 DEFINE l_sql LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(600)
        l_sw  LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    IF tm.c = '1' THEN
       #---->擷取日期含工作日
       DECLARE s_sme1 CURSOR FOR
           SELECT sme01 FROM sme_file
           WHERE sme01 >=tm.ima30
       LET g_cnt=1
       FOREACH s_sme1 INTO g_work[g_cnt]
           IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               EXIT FOREACH
           END IF
           LET g_cnt=g_cnt+1
          #IF g_cnt > 400 THEN LET g_success = 'N' EXIT FOREACH END IF  #TQC-620073 mark
       END FOREACH
       IF g_success = 'N' THEN RETURN END IF
    ELSE
       #---->擷取日期不含工作日
       DECLARE s_sme2 CURSOR FOR
           SELECT sme01 FROM sme_file
           WHERE sme02='Y'
             AND sme01 >=tm.ima30
       LET g_cnt=1
       FOREACH s_sme2 INTO g_work[g_cnt]
           IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               EXIT FOREACH
           END IF
           LET g_cnt=g_cnt+1
          #IF g_cnt > 400 THEN LET g_success = 'N' EXIT FOREACH END IF  #TQC-620073 mark
       END FOREACH
       IF g_success = 'N' THEN RETURN END IF
    END IF
    #--->依ABC分類設定，檢查相關資料
     IF tm.a='2' THEN
        CALL s100_check() RETURNING l_sw
        IF l_sw THEN LET g_success = 'N' RETURN END IF
     END IF
 
    #---->抓取料件資料
     LET l_sql = " SELECT ima01,ima07,ima32 FROM ima_file ",
                 " WHERE imaacti='Y' "
 
     IF tm.a = '2' THEN
        IF tm.b='1'
        THEN LET l_sql=l_sql clipped, " ORDER BY ima07,ima01 "
        ELSE LET l_sql=l_sql clipped, " ORDER BY ima07,ima32 desc"
        END IF
     END IF
 
     PREPARE s100_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
     DECLARE s100_cur1 CURSOR WITH HOLD FOR s100_prepare1
     LET arr_a =1
     LET arr_b =1
     LET arr_c =1
     LET wk_a =0
     LET wk_b =0
     LET wk_c =0
     FOREACH s100_cur1 INTO g_ima.ima01,g_ima.ima07
         IF SQLCA.sqlcode THEN
            CALL cl_err('foreach',status,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         BEGIN WORK
         #--->所有料件採用相同日期
         IF tm.a='1' THEN
             LET g_ima.ima30 = tm.ima30
             CALL s100_update()
         ELSE
         #--->依ABC分類設定
             CALL s100_abc()
             LET g_ima.ima30 = l_ima30
             CALL s100_update()
         END IF
         MESSAGE g_ima.ima01
         CALL ui.Interface.refresh()
     END FOREACH
END FUNCTION
 
FUNCTION s100_check()
 DEFINE cnt_a LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        cnt_b LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        cnt_c LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_sw  LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
 
     IF g_sma.sma15 IS NULL OR g_sma.sma15 = ' ' OR g_sma.sma15 = 0
     THEN CALL cl_err(g_sma.sma15,'mfg0163',1)
          RETURN 1
     END IF
     IF g_sma.sma16 IS NULL OR g_sma.sma16 = ' ' OR g_sma.sma16 = 0
     THEN CALL cl_err(g_sma.sma15,'mfg0164',1)
          RETURN 1
     END IF
     IF g_sma.sma17 IS NULL OR g_sma.sma17 = ' ' OR g_sma.sma17 = 0
     THEN CALL cl_err(g_sma.sma15,'mfg0165',1)
          RETURN 1
     END IF
     #--->A類料件編號總數
     SELECT COUNT(*) INTO cnt_a FROM ima_file
                               WHERE imaacti='Y'
                                 AND ima07 IN ('a','A')
     #--->B類料件編號總數
     SELECT COUNT(*) INTO cnt_b FROM ima_file
                               WHERE imaacti='Y'
                                 AND ima07 IN ('b','B')
     #--->C類料件編號總數
     SELECT COUNT(*) INTO cnt_c FROM ima_file
                               WHERE imaacti='Y'
                                 AND ima07 IN ('c','C')
 
     #--->無'A'類料件，請先執行 ABC分類計算
     IF cnt_a IS NULL OR cnt_a = ' ' OR cnt_a = 0 THEN
        #CALL cl_prtmsg(0,0,'mfg0166',g_lang) RETURNING l_sw
        #IF l_sw MATCHES '[Nn]' THEN RETURN 1  END IF
        IF NOT cl_confirm('mfg0166') THEN
            RETURN 1
        END IF
     END IF
     IF cnt_b IS NULL OR cnt_b = ' ' OR cnt_b = 0 THEN
        #CALL cl_prtmsg(0,0,'mfg0167',g_lang) RETURNING l_sw
        #IF l_sw MATCHES '[Nn]' THEN RETURN 1  END IF
        IF NOT cl_confirm('mfg0167') THEN
            RETURN 1
        END IF
     END IF
     IF cnt_c IS NULL OR cnt_c = ' ' OR cnt_c = 0 THEN
        #CALL cl_prtmsg(0,0,'mfg0168',g_lang) RETURNING l_sw
        #IF l_sw MATCHES '[Nn]' THEN RETURN 1  END IF
        IF NOT cl_confirm('mfg0168') THEN
            RETURN 1
        END IF
     END IF
     LET ave_a=(cnt_a/g_sma.sma15)+0.99
     LET ave_b=(cnt_b/g_sma.sma16)+0.99
     LET ave_c=(cnt_c/g_sma.sma17)+0.99
     RETURN 0
END FUNCTION
 
#依ABC分類設定
FUNCTION s100_abc()
    CASE
        WHEN g_ima.ima07 MATCHES '[aA]'
             LET wk_a = wk_a + 1
             IF wk_a > ave_a THEN
                 LET wk_a = 0
                 LET arr_a = arr_a + 1
             END IF
           # LET wk_a = wk_a + 1
             LET l_ima30 = g_work[arr_a]
        WHEN g_ima.ima07 MATCHES '[bB]'
             IF wk_b > ave_b THEN
                 LET wk_b = 0
                 LET arr_b = arr_b + 1
             END IF
             LET wk_b = wk_b + 1
             LET l_ima30 = g_work[arr_b]
        WHEN g_ima.ima07  MATCHES '[cC]'
             IF wk_c > ave_c THEN
                 LET wk_c = 0
                 LET arr_c = arr_c + 1
             END IF
             LET wk_c = wk_c + 1
             LET l_ima30 = g_work[arr_c]
        OTHERWISE LET l_ima30 = ' '
    END CASE
END FUNCTION
 
FUNCTION s100_update()
 DEFINE insert_fg  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 #--->更新料件主檔中的最近盤點日期
{ckp#1} UPDATE ima_file
           SET ima30 = g_ima.ima30,     # 96-08-14 By Melody for top3.0
               imadate = g_today     #FUN-C30315 add
         WHERE ima01 = g_ima.ima01
        IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err3("upd","ima_file",g_ima.ima01,"",sqlca.sqlcode,"",
                         "(s100_update:ckp#1)",1)   #NO.FUN-640266 #No.FUN-660156
#           CALL cl_err('(s100_update:ckp#1)',SQLCA.sqlcode,1)
        END IF
 
{ 96-08-14 By Melody  3.0 版功能建議將以下之 update 取消}
#BugNo:4706
{
#--->更新庫存資料明細中的最近盤點日期
        UPDATE img_file
            SET img14 = g_ima.ima30
            WHERE img01=g_ima.ima01
        IF SQLCA.sqlcode THEN
            LET g_success='N'
#           CALL cl_err('(s100_update:ckp#2)',SQLCA.sqlcode,1)
            CALL cl_err3("upd","img_file",g_ima.ima01,"",sqlca.sqlcode,"",
                         "(s100_update:ckp#2)",1)   #NO.FUN-640266 #No.FUN-660156
            RETURN 1
        END IF
}
END FUNCTION
FUNCTION s100_set_entry()
      CALL cl_set_comp_entry("b,c",TRUE)
END FUNCTION
 
FUNCTION s100_set_no_entry()
      CALL cl_set_comp_entry("b,c",FALSE)
END FUNCTION
#Patch....NO.TQC-610036 <001> #

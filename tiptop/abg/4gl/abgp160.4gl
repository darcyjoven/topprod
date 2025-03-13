# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abgp160.4gl
# Descriptions...: 用人費用產生作業
# Date & Author..: 02/10/07 By nicola
# Modi...........: 031117 ching No.8563 bgv00 default '1'
# Modify.........: No.MOD-530263 05/03/25 By Smapmin 修正無"離開"功能
# Modify.........: No.MOD-590317 05/09/16 By Dido 修改 g_wc 來源取得
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-760066 07/06/25 By chenl  若費用項目相同則累計。
# Modify.........: No.MOD-790002 07/09/03 By Joe 程式段INSERT時,增加欄位(PK)預設值
# Modify.........: No.TQC-860021 08/06/10 By Sarah CONSTRUCT段漏了ON IDLE控制
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
   g_bge   RECORD   LIKE bge_file.*,
   g_bgs   RECORD   LIKE bgs_file.*,
   g_bhb   RECORD   LIKE bhb_file.*,
   g_bgv   RECORD   LIKE bgv_file.*,
   g_sql            string,  #No.FUN-580092 HCN
   g_wc,g_wc1       string,  #No.FUN-580092 HCN
   g_bge02          LIKE bge_file.bge02,      # 部門代號
   g_bge01          LIKE bge_file.bge01,      # 版本
   g_bge03          LIKE bge_file.bge03,      # 年度
   g_change_lang    LIKE type_file.chr1,      # No.FUN-570113 #No.FUN-680061 VARCHAR(01)
   ls_date          STRING,                   # No.FUN-570113
   l_flag           LIKE type_file.chr1       # No.FUN-570113 #No.FUN-680061 VARCHAR(01)
#  p_row,p_col      LIKE type_file.num5       # No.FUN-570113 #No.FUN-680061 SMALLINT
DEFINE g_i          LIKE type_file.num5       #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_cnt        LIKE type_file.num5       #No.FUN-680061 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8        #No.FUN-6A0056
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   # No.FUN-570113 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bge02 = ARG_VAL(1)
   LET g_bge01 = ARG_VAL(2)
   LET g_bge03 = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   # No.FUN-570113 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690106
 
#NO.FUN-570113 START---
#      LET p_row = 5 LET p_col = 15
#   OPEN WINDOW p160_w AT p_row,p_col WITH FORM "abg/42f/abgp160"
#        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#   CALL cl_ui_init()
#   CALL p160_i()
#   CLOSE WINDOW p160_w
   WHILE TRUE
    IF g_bgjob="N" THEN
       CALL p160_i()
       IF cl_sure(0,0) THEN
          CALL cl_wait()
          LET g_success="Y"
          BEGIN WORK
          CALL p160_del()
          CALL p160_p()
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p160_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
       CLOSE WINDOW p160_w
    ELSE
       LET g_success="Y"
       BEGIN WORK
       CALL p160_del()
       CALL p160_p()
       IF g_success="Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
#NO.FUN-570113 END------
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p160_i()
# No.FUN-570113 --start--
#  DEFINE l_flag      LIKE type_file.chr1   #No.FUN-680061 VARCHAR(01)
   DEFINE lc_cmd      LIKE zz_file.zz08     #No.FUN-680061 VARCHAR(500)
   DEFINE p_row,p_col LIKE type_file.num5   #No.FUN-680061 SMALLINT
 
   LET p_row=5
   LET p_col=25
 
   OPEN WINDOW p160_w AT p_row,p_col WITH FORM "abg/42f/abgp160"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
   # No.FUN-570113 --end--
 
   CLEAR FORM
   CALL cl_opmsg('a')
   LET g_bgjob = "N"                            # No.FUN-570113
 
#MOD-590317
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON bge02 HELP 1
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION exit        #MOD-530268
           LET INT_FLAG = 1
           EXIT CONSTRUCT     #END MOD-530268
 
        ON ACTION locale                   #NO.FUN-570113
            LET g_change_lang = TRUE       #->No.FUN-570112
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         ON ACTION controlg       #TQC-860021
            CALL cl_cmdask()      #TQC-860021
 
         ON IDLE g_idle_seconds   #TQC-860021
            CALL cl_on_idle()     #TQC-860021
            CONTINUE CONSTRUCT    #TQC-860021
 
         ON ACTION about          #TQC-860021
            CALL cl_about()       #TQC-860021
 
         ON ACTION help           #TQC-860021
            CALL cl_show_help()   #TQC-860021
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
  #->No.FUN-570112 --start--
         IF g_change_lang THEN
            LET g_change_lang = FALSE
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   
            EXIT WHILE
         END IF
  #->No.FUN-570112 ---end---
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW abgp200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
            
      END IF
 
      IF g_wc=" 1=1" THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
#      ELSE            #NO.FUN-570113 
#         EXIT WHILE   #NO.FUN-570113 
      END IF
#   END WHILE          #NO.FUN-570113 
#MOD-590317 End
 
   LET g_bge03 = YEAR(g_today)
 
   #INPUT g_bge01,g_bge03 WITHOUT DEFAULTS FROM bge01,bge03 HELP 1
   INPUT g_bge01,g_bge03,g_bgjob WITHOUT DEFAULTS 
    FROM bge01,bge03,g_bgjob HELP 1  #NO.FUN-570113
 
   AFTER FIELD bge01
         IF cl_null(g_bge01) THEN LET g_bge01 = ' ' END IF
 
#MOD-590317
#   AFTER FIELD bge02
#         IF cl_null(g_bge02) THEN
#            CALL cl_err('','9046',0)
#            NEXT FIELD bge02
#         END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW abgp200_w EXIT PROGRAM
#   END IF
#MOD-590317 End
 
    ON ACTION locale                             #No.FUN-570113
       LET g_change_lang = TRUE                  #No.FUN-570113
       EXIT INPUT                                #No.FUN-570113
 
    ON ACTION exit   #MOD-530263
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
 
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
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
   #No.FUN-570113 --start--
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p160_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
 
#   IF NOT cl_sure(18,20) THEN RETURN  END IF
#   CALL cl_wait()
 
#   LET g_success ='Y'
#   BEGIN WORK
#   CALL p160_del()
#   CALL p160_p()          #新增資料
#   IF g_success = 'Y' THEN
#      COMMIT WORK
#   ELSE
#      ROLLBACK WORK
#      RETURN
#   END IF
#   ERROR ""
 
 
   #CALL cl_end(18,20)
#   CALL cl_end2(1) RETURNING l_flag
#   IF l_flag THEN
#      CALL p160_i()
#   ELSE
#      EXIT PROGRAM
#   END IF
   IF g_bgjob="Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01="abgp160"
      IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
         CALL cl_err('abgp160','9031',1) 
      ELSE
         LET lc_cmd=lc_cmd CLIPPED,
                    " '",g_bge02 CLIPPED,"'",
                    " '",g_bge01 CLIPPED,"'",
                    " '",g_bge03 CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('abgp160',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p160_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
#No.FUN-570113 --end--
END FUNCTION
 
FUNCTION p160_del()
DEFINE l_wc LIKE type_file.chr1000#No.FUN-680061 VARCHAR(500)
DEFINE i,j  LIKE type_file.num5   #No.FUN-680061 SMALLINT
   LET l_wc = g_wc
   LET i = length(l_wc)
   FOR j = 1 TO i
       IF l_wc[j,j+4]= 'bge02' THEN LET l_wc[j,j+4] = 'bgv04' END IF
   END FOR
   LET g_sql = " DELETE FROM bgv_file ",
               "  WHERE bgv01='",g_bge01,"'",
               "    AND bgv02='",g_bge03,"'",
               "    AND ",l_wc CLIPPED
   PREPARE del_pre FROM g_sql
   EXECUTE del_pre
   IF SQLCA.sqlcode THEN
      CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
   END IF
END FUNCTION
 
FUNCTION p160_p()
   DEFINE  l_bgt03   LIKE bgt_file.bgt03,
           l_bgt04   LIKE bgt_file.bgt04,
           l_bha04   LIKE bha_file.bha04,
           l_bgd04   LIKE bgd_file.bgd04,
           l_bgd05   LIKE bgd_file.bgd05,
           l_bgs03   LIKE bgs_file.bgs03,
           l_sum1    LIKE bgv_file.bgv10,
           l_sum2    LIKE bgv_file.bgv10,
           l_sum0    LIKE bgv_file.bgv10
 
   #----------------------先宣告所須資料的 Cursor----------------------
   LET g_sql= "SELECT * FROM bge_file ",                #部門預計人力檔
              " WHERE ", g_wc CLIPPED,
              " AND bge01 ='",g_bge01,"'",
              " AND bge03 =",g_bge03
   PREPARE p160_prebge FROM g_sql
   DECLARE p160_bge CURSOR FOR p160_prebge
 
   LET g_sql= "SELECT bhb_file.*, bha04  ",             #費用項目提撥單頭
              "  FROM bhb_file,bha_file ",              #OTHERWISE 會用到
              " WHERE bha01 = bhb01 AND bha02 = bhb02 ",
              "   AND bha03 = bhb03 ",
              "   AND bhb01 = '",g_bge01,"'",
              "   AND bhb02 = '",g_bge03,"'",
              "   AND bhb03 = ? "
   PREPARE p160_prebhb FROM g_sql
   DECLARE p160_bhb CURSOR FOR p160_prebhb
 
   DECLARE p160_bgs CURSOR FOR                          #費用項目檔
         SELECT * FROM bgs_file
          WHERE bgs01 != g_bgz.bgz27
            AND bgs01 != g_bgz.bgz29   #超時與未超時的費用先不處理
         ORDER BY bgs01
 
   #--------------------------------------------------------------------
   FOREACH p160_bgs INTO g_bgs.*
     FOREACH p160_bge INTO g_bge.*
 
        # INSERT bgv_file (部門用人費用項目檔)
        LET g_bgv.bgv01   = g_bge01       #版本
        LET g_bgv.bgv02   = g_bge03       #年度
        LET g_bgv.bgv03   = g_bge.bge04   #月份
        LET g_bgv.bgv04   = g_bge.bge02   #部門
        LET g_bgv.bgv05   = g_bgs.bgs01   #費用項目
        LET g_bgv.bgv07   = g_bge.bge05   #職等代號
        LET g_bgv.bgv08   = g_bge.bge06   #職級代號
        LET g_bgv.bgv09   = ' '           #職稱說明
        LET g_bgv.bgvuser = g_user        #資料所有者
        LET g_bgv.bgvgrup = g_grup        #資料所有群
        LET g_bgv.bgvmodu = ''            #資料修改者
        LET g_bgv.bgvdate = g_today       #資料修改日
 
        SELECT bgd04,bgd05 INTO l_bgd04,l_bgd05 FROM bgd_file  #取標準本薪,投保薪資
         WHERE bgd01 = g_bgv.bgv01
           AND bgd02 = g_bgv.bgv07
           AND bgd03 = g_bgv.bgv08
        IF cl_null(l_bgd04) THEN LET l_bgd04 = 0 END IF
        IF cl_null(l_bgd05) THEN LET l_bgd05 = 0 END IF
        SELECT bgt03 INTO l_bgt03 FROM bgt_file      #取勞保費
         WHERE bgt01 <= l_bgd05
           AND bgt02 >= l_bgd05
        IF cl_null(l_bgt03) THEN LET l_bgt03 = 0 END IF
        SELECT bgt04 INTO l_bgt04 FROM bgt_file        #取健保費
         WHERE bgt01 <= l_bgd05
           AND bgt02 >= l_bgd05
        IF cl_null(l_bgt04) THEN LET l_bgt04 = 0 END IF
        #計算 bgv10(平均金額)
        CASE
           WHEN g_bgs.bgs01 = g_bgz.bgz33                #**底薪費用**#
                #-------------------直接費用------------------------------
                LET g_bgv.bgv06 = '1'
                LET g_bgv.bgv10 = l_bgd04 * g_bge.bge07  #標準本薪 * 直接人力
                IF g_bgs.bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                   LET g_bgv.bgv10 = g_bgv.bgv10 * (1 + g_bgz.bgz15 / 100)
                END IF
                CALL p160_ins_bgv()
                IF g_success='N' THEN EXIT FOREACH END IF
                #-------------------間接費用-------------------------------
                LET g_bgv.bgv06 = '2'
                LET g_bgv.bgv10 = l_bgd04 * g_bge.bge09  #標準本薪 * 間接人力
                IF g_bgs.bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                   LET g_bgv.bgv10 = g_bgv.bgv10 * (1 + g_bgz.bgz15 / 100)
                END IF
                CALL p160_ins_bgv()
                IF g_success='N' THEN EXIT FOREACH END IF
 
           WHEN g_bgs.bgs01 = g_bgz.bgz34                    #**勞保費用**#
                #-------------------直接費用------------------------------
                LET g_bgv.bgv06 = '1'
                LET g_bgv.bgv10 = g_bge.bge07 * l_bgt03      #人力 * 勞保費
                IF g_bgs.bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                   LET g_bgv.bgv10 = g_bgv.bgv10 * (1 + g_bgz.bgz15/100)
                END IF
                CALL p160_ins_bgv()
                IF g_success='N' THEN EXIT FOREACH END IF
                #-------------------間接費用------------------------------
                LET g_bgv.bgv06 = '2'
                LET g_bgv.bgv10 = g_bge.bge09 * l_bgt03      #人力 * 勞保費
                IF g_bgs.bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                   LET g_bgv.bgv10 = g_bgv.bgv10 * (1 + g_bgz.bgz15/100)
                END IF
                CALL p160_ins_bgv()
                IF g_success='N' THEN EXIT FOREACH END IF
 
           WHEN g_bgs.bgs01 = g_bgz.bgz35                      #**健保費用**#
                #-------------------直接費用------------------------------
                LET g_bgv.bgv06 = '1'
                LET g_bgv.bgv10 = g_bge.bge07 * l_bgt04        #人力 * 健保費
                IF g_bgs.bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                     LET g_bgv.bgv10 = g_bgv.bgv10 * (1 + g_bgz.bgz15/100)
                END IF
                CALL p160_ins_bgv()
                IF g_success='N' THEN EXIT FOREACH END IF
                #-------------------間接費用------------------------------
                LET g_bgv.bgv06 = '2'
                LET g_bgv.bgv10 = g_bge.bge09 * l_bgt04        #人力 * 健保費
                IF g_bgs.bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                   LET g_bgv.bgv10 = g_bgv.bgv10 * (1 + g_bgz.bgz15 / 100)
                END IF
                CALL p160_ins_bgv()
                IF g_success='N' THEN EXIT FOREACH END IF
 
           OTHERWISE            #其他(費用項目提撥單頭)
               LET l_sum0 = 0 LET l_sum1 = 0 LET l_sum2 = 0
               FOREACH p160_bhb USING g_bgs.bgs01 INTO g_bhb.*,l_bha04
                  SELECT bgs03 INTO l_bgs03 FROM bgs_file
                   WHERE bgs01 = g_bhb.bhb04
                  IF g_bhb.bhb05 = '1' THEN #固定金額
                     IF l_bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                        LET g_bhb.bhb06 = g_bhb.bhb06 * (1+g_bgz.bgz15 / 100)
                     END IF
                     LET l_sum1 = l_sum1 + g_bhb.bhb06
                  END IF
                  IF g_bhb.bhb05 = '2' THEN #比率     #No.8563 以底薪*比率
                      LET l_sum0 = (l_bgd04 / 100 / l_bha04 * g_bhb.bhb06)
                      IF l_bgs03 = 'Y' AND g_bgv.bgv03 >= g_bgz.bgz16 THEN
                         LET l_sum0 = l_sum0 * (1 + g_bgz.bgz15 / 100)
                      END IF
                      LET l_sum2 = l_sum2 + l_sum0
                  END IF
               END FOREACH
               #-------------------直接費用------------------------------
               LET g_bgv.bgv06 = '1'
               LET g_bgv.bgv10 = (l_sum1 + l_sum2) * g_bge.bge07
               CALL p160_ins_bgv()
               IF g_success='N' THEN EXIT FOREACH END IF
               #-------------------間接費用------------------------------
               LET g_bgv.bgv06 = '2'
               LET g_bgv.bgv10 = (l_sum1 + l_sum2) * g_bge.bge09
               CALL p160_ins_bgv()
               IF g_success='N' THEN EXIT FOREACH END IF
           END CASE
     END FOREACH
   END FOREACH
 
   #未超時及超時加班費之費用項目處理
   FOREACH p160_bge INTO g_bge.*
      LET g_bgv.bgv01   = g_bge01       #版本
      LET g_bgv.bgv02   = g_bge03       #年度
      LET g_bgv.bgv03   = g_bge.bge04   #月份
      LET g_bgv.bgv04   = g_bge.bge02   #部門
      LET g_bgv.bgv07   = g_bge.bge05   #職等代號
      LET g_bgv.bgv08   = g_bge.bge06   #職級代號
      LET g_bgv.bgv09   = ' '           #職稱說明
      LET g_bgv.bgvuser = g_user        #資料所有者
      LET g_bgv.bgvgrup = g_grup        #資料所有群
      LET g_bgv.bgvmodu = ''            #資料修改者
      LET g_bgv.bgvdate = g_today       #資料修改日
 
      SELECT SUM(bgv10) INTO l_sum1 FROM bgv_file
         WHERE bgv01 = g_bgv.bgv01 AND bgv02 = g_bgv.bgv02
           AND bgv03 = g_bgv.bgv03 AND bgv04 = g_bgv.bgv04
           AND bgv06 = '1'         AND bgv07 = g_bgv.bgv07
           AND bgv08 = g_bgv.bgv08
           AND (bgv05 = g_bgz.bgz21 OR bgv05 = g_bgz.bgz22
            OR  bgv05 = g_bgz.bgz23 OR bgv05 = g_bgz.bgz24
            OR  bgv05 = g_bgz.bgz25 OR bgv05 = g_bgz.bgz26)
      IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
      SELECT SUM(bgv10) INTO l_sum2 FROM bgv_file
         WHERE bgv01 = g_bgv.bgv01 AND bgv02 = g_bgv.bgv02
           AND bgv03 = g_bgv.bgv03 AND bgv04 = g_bgv.bgv04
           AND bgv06 = '2'         AND bgv07 = g_bgv.bgv07
           AND bgv08 = g_bgv.bgv08
           AND (bgv05 = g_bgz.bgz21 OR bgv05 = g_bgz.bgz22
            OR  bgv05 = g_bgz.bgz23 OR bgv05 = g_bgz.bgz24
            OR  bgv05 = g_bgz.bgz25 OR bgv05 = g_bgz.bgz26)
      IF cl_null(l_sum2) THEN LET l_sum2 = 0 END IF
 
      #**未超時加班費**#
      LET g_bgv.bgv05 = g_bgz.bgz27
      #--------------------------直接費用-----------------------------------
      LET g_bgv.bgv06 = '1'
      LET g_bgv.bgv10 = l_sum1/g_bgz.bgz31/g_bgz.bgz32*g_bgz.bgz28*g_bge.bge08
      CALL p160_ins_bgv()
      IF g_success='N' THEN EXIT FOREACH END IF
      #--------------------------間接費用-----------------------------------
      LET g_bgv.bgv06 = '2'
      LET g_bgv.bgv10 = l_sum2/g_bgz.bgz31/g_bgz.bgz32*g_bgz.bgz28*g_bge.bge10
      CALL p160_ins_bgv()
      IF g_success='N' THEN EXIT FOREACH END IF
 
      #**超時加班費***#
      LET g_bgv.bgv05 = g_bgz.bgz29
      #--------------------------直接費用-----------------------------------
      LET g_bgv.bgv06 = '1'
      LET g_bgv.bgv10 = l_sum1/g_bgz.bgz31/g_bgz.bgz32*g_bgz.bgz30*g_bge.bge11
      CALL p160_ins_bgv()
      IF g_success='N' THEN EXIT FOREACH END IF
      #--------------------------間接費用-----------------------------------
      LET g_bgv.bgv06 = '2'
      LET g_bgv.bgv10 = l_sum2/g_bgz.bgz31/g_bgz.bgz32*g_bgz.bgz30*g_bge.bge12
      CALL p160_ins_bgv()
      IF g_success='N' THEN EXIT FOREACH END IF
   END FOREACH
END FUNCTION
 
FUNCTION p160_ins_bgv()
DEFINE l_n            LIKE type_file.num5   #No.TQC-760066
 
   LET l_n = 0             #No.TQC-760066
   LET g_bgv.bgv00='1'
   IF  g_bgv.bgv10 = 0 THEN RETURN END IF
   LET g_bgv.bgv10 = cl_digcut(g_bgv.bgv10,g_azi04)
  
  #增加判斷，是否相同key的資料已經存在，若已經存在，則將金額累計，否則新增一筆記錄。 
  #No.TQC-760066--begin-- add
   SELECT COUNT(*) INTO l_n FROM bgv_file 
    WHERE bgv00 = g_bgv.bgv00
      AND bgv01 = g_bgv.bgv01
      AND bgv02 = g_bgv.bgv02
      AND bgv03 = g_bgv.bgv03
      AND bgv04 = g_bgv.bgv04
      AND bgv05 = g_bgv.bgv05
      AND bgv06 = g_bgv.bgv06
      AND bgv07 = g_bgv.bgv07
      AND bgv08 = g_bgv.bgv08
   IF l_n = 0 THEN 
      #MOD-790002.................begin
      IF cl_null(g_bgv.bgv07)  THEN
         LET g_bgv.bgv07=' '
      END IF
      #MOD-790002.................end
 
      #No.TQC-760066--end-- add
      LET g_bgv.bgvoriu = g_user      #No.FUN-980030 10/01/04
      LET g_bgv.bgvorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO bgv_file VALUES(g_bgv.*)
      IF STATUS THEN
        #CALL cl_err('ins bgv:',STATUS,1) #FUN-660105
         CALL cl_err3("ins","bgv_file",g_bgv.bgv00,g_bgv.bgv01,STATUS,"","ins bgv:",1) #FUN-660105
         LET g_success = 'N'
      END IF
      #No.TQC-760066--begin-- add
   ELSE 
      UPDATE bgv_file SET bgv10 = bgv10 + g_bgv.bgv10
       WHERE bgv00 = g_bgv.bgv00
         AND bgv01 = g_bgv.bgv01
         AND bgv02 = g_bgv.bgv02
         AND bgv03 = g_bgv.bgv03
         AND bgv04 = g_bgv.bgv04
         AND bgv05 = g_bgv.bgv05
         AND bgv06 = g_bgv.bgv06
         AND bgv07 = g_bgv.bgv07
         AND bgv08 = g_bgv.bgv08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3('upd','bgv_file',g_bgv.bgv05,'',SQLCA.sqlcode,'','',1)
         LET g_success = 'N'
      END IF 
   END IF 
  #No.TQC-760066--end-- add
END FUNCTION
#Patch....NO.TQC-610035 <001> #

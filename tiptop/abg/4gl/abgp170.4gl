# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abgp170.4gl
# Descriptions...: 用人費用拋轉產生作業
# Date & Author..: 02/12/16 By qazzaq
# Modi...........: ching 031117 No.8563 bgv00='1'
# Modify.........: No.MOD-530268 05/03/25 By Smapmin 離開的功能鍵無作用
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-790108 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-840190 08/04/20 By rainy -301 insert 到 bgq_file 欄位不可null
# Modify.........: No.MOD-840509 08/04/23 By douzh bgq_file新增欄位更新,一并調整程式 
# Modify.........: No.TQC-860021 08/06/10 By Sarah CONSTRUCT段漏了ON IDLE控制
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
       g_sql            string,                  #No.FUN-580092 HCN
       g_wc,g_wc1,l_buf string,                  #No.FUN-580092 HCN
       l_wc             LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(1000)
       g_bgv01          LIKE bgg_file.bgg01,     # 版本
       g_bgv02          LIKE bgv_file.bgv02,     # 年度
       g_change_lang    LIKE type_file.chr1,     # No.FUN-570113 #No.FUN-680061 VARCHAR(01)
       ls_date          STRING,                  # No.FUN-570113
       l_flag           LIKE type_file.chr1      # No.FUN-570113 #No.FUN-680061 VARCHAR(01)
#      p_row,p_col      LIKE type_file.num5      # No.FUN-570113 #No.FUN-680061 SMALLINT
DEFINE g_i             LIKE type_file.num5       #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_cnt           LIKE type_file.num5       #No.FUN-680061 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0056
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   # No.FUN-570113 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET g_bgv01 = ARG_VAL(2)
   LET g_bgv02 = ARG_VAL(3)
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
#   LET p_row = 5 LET p_col = 10
#   OPEN WINDOW p170_w AT p_row,p_col WITH FORM "abg/42f/abgp170"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#   CALL p170()
#   CLOSE WINDOW p170_w
  WHILE TRUE
   IF g_bgjob="N" THEN
      CALL p170()
      IF cl_sure(0,0) THEN
         CALL cl_wait()
         LET g_success="Y"
         BEGIN WORK
         CALL p170_del_bhd()
         CALL p170_cur()
         CALL p170_p()
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
            CLOSE WINDOW p170_w
            EXIT WHILE
         END IF
      ELSE
         CONTINUE WHILE
      END IF
      CLOSE WINDOW p170_w
   ELSE
      LET g_success="Y"
       BEGIN WORK
      CALL p170_del_bhd()
      CALL p170_cur()
      CALL p170_p()
      IF g_success="Y" THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
END WHILE
#NO.FUN-570113 END---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p170()
  # No.FUN-570113 --start--
  DEFINE lc_cmd        LIKE zz_file.zz08      #No.FUN-680061 VARCHAR(500)
  DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680061 SMALLINT
#  DEFINE l_bgv01   LIKE bgv_file.bgv01,
#         l_bgv02   LIKE bgv_file.bgv02,
#         l_bgv03   LIKE bgv_file.bgv03,
#         l_bgv04   LIKE bgv_file.bgv04,
#         l_bgv05   LIKE bgv_file.bgv05,
#         l_bgv06   LIKE bgv_file.bgv06,
#         l_bgv10   LIKE bgv_file.bgv10
#  DEFINE l_bhd RECORD LIKE bhd_file.*
  LET p_row=5
  LET p_col=25
 
  OPEN WINDOW p170_w AT p_row,p_col WITH FORM "abg/42f/abgp170"
  ATTRIBUTE(STYLE=g_win_style)
 
  CALL cl_ui_init()
  # No.FUN-570113 --end--
 
    CLEAR FORM
    CALL cl_opmsg('a')
WHILE TRUE
    CONSTRUCT BY NAME g_wc ON bgv04 HELP 1
 
      #No.FUN-580031 --start--
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      #No.FUN-580031 ---end---
 
      ON ACTION locale                             #No.FUN-570113
         LET g_change_lang = TRUE                  #No.FUN-570113
         EXIT CONSTRUCT                            #No.FUN-570113
 
      ON ACTION exit        #MOD-530268
         LET INT_FLAG = 1
         EXIT CONSTRUCT     #END MOD-530268
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bgvuser', 'bgvgrup') #FUN-980030
    #No.FUN-570113 --start--
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   
       CONTINUE WHILE
    END IF
    #No.FUN-570113 --end--
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       CLOSE WINDOW abgp170_w 
       CLOSE WINDOW p170_w                         #No.FUN-570113
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
    IF g_wc=" 1=1" THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
#    ELSE             #NO.FUN-570113
#       EXIT WHILE    #NO.FUN-570113
    END IF
#END WHILE            #NO.FUN-570113
 
    LET g_bgv02 = YEAR(g_today)
    LET g_bgjob = "N"                              #No.FUN-570113
    #INPUT g_bgv01,g_bgv02 WITHOUT DEFAULTS FROM bgv01,bgv02 HELP 1
    INPUT g_bgv01,g_bgv02,g_bgjob WITHOUT DEFAULTS 
     FROM bgv01,bgv02,g_bgjob HELP 1  #NO.FUN-570113
 
        AFTER FIELD bgv01
          IF cl_null(g_bgv01) THEN LET g_bgv01=' ' END IF
 
        ON ACTION locale                             #No.FUN-570113
           LET g_change_lang = TRUE                  #No.FUN-570113
           EXIT INPUT                                #No.FUN-570113
 
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
 
#    IF INT_FLAG THEN RETURN END IF
     IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW p170_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
 
#    IF NOT cl_sure(18,20) THEN RETURN END IF
#    CALL cl_wait()
 
#    LET g_success='Y'
#    BEGIN WORK
 
#    CALL p170_del_bhd()
 
#    LET g_sql="SELECT bgv01,bgv02,bgv03,bgv04,bgv05,bgv06,SUM(bgv10) ",
#              "  FROM bgv_file ",
#              " WHERE ", g_wc CLIPPED,
#              " AND bgv00 ='1'          ",
#              " AND bgv01 ='",g_bgv01,"'",
#              " AND bgv02 =",g_bgv02,
#              " GROUP BY bgv01,bgv02,bgv03,bgv04,bgv05,bgv06 "
#    PREPARE p170_prebgk FROM g_sql
#    DECLARE p170_cur1 CURSOR FOR p170_prebgk
# 
#    FOREACH p170_cur1 INTO l_bgv01,l_bgv02,l_bgv03,l_bgv04,l_bgv05,
#                           l_bgv06,l_bgv10
#       IF STATUS THEN
#          CALL cl_err('p170(foreach):',STATUS,1)
#          LET g_success='N'
#          EXIT FOREACH
#       END IF
#       LET l_bhd.bhd01 = g_bgv01
#       LET l_bhd.bhd02 = g_bgv02
#       LET l_bhd.bhd03 = l_bgv03
#       LET l_bhd.bhd04 = l_bgv04
#       LET l_bhd.bhd05 = '@@@@5'
#       #項次
#       SELECT MAX(bhd06)+1 INTO l_bhd.bhd06 FROM bhd_file
#        WHERE bhd01 = l_bhd.bhd01 AND bhd02 = l_bhd.bhd02
#          AND bhd03 = l_bhd.bhd03 AND bhd04 = l_bhd.bhd04
#          AND bhd05 = l_bhd.bhd05
#       IF cl_null(l_bhd.bhd06) THEN LET l_bhd.bhd06 = 1 END IF
#       #科目
#       SELECT bgx04 INTO l_bhd.bhd07 FROM bgx_file
#        WHERE bgx01 = l_bhd.bhd04
#          AND bgx02 = l_bgv06
#          AND bgx03 = l_bgv05
#       IF STATUS THEN
#          CALL cl_err('sel bgx:','abg-019',1)
#          LET g_success='N' EXIT FOREACH
#       END IF
#       LET l_bhd.bhd08 = ' '
#       LET l_bhd.bhd09 = l_bgv10
#       INSERT INTO bhd_file VALUES(l_bhd.*)
#       IF STATUS THEN
#          CALL cl_err('ins bhd',STATUS,1)
#          LET g_success='N' EXIT FOREACH
#       END IF
#    END FOREACH
#
#    CALL p170_p()  # INSERT INTO bgq_file
# 
#    IF g_success = 'Y' THEN
#       COMMIT WORK
#    ELSE
#       ROLLBACK WORK
#       RETURN
#    END IF
#    ERROR ""
#    CALL cl_end(18,20)
    IF g_bgjob="Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01="abgp170"
       IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
          CALL cl_err('abgp170','9031',1)  
       ELSE
          LET g_wc = cl_replace_str(g_wc,"'","\"")
          LET lc_cmd=lc_cmd CLIPPED,
                     " '",g_wc CLIPPED,"'",
                     " '",g_bgv01 CLIPPED,"'",
                     " '",g_bgv02 CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('abgp170',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p170_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE
# No.FUN-570113 --end--
END FUNCTION
 
# No.FUN-570113 --start--
FUNCTION p170_cur()
  DEFINE l_bgv01   LIKE bgv_file.bgv01,
         l_bgv02   LIKE bgv_file.bgv02,
         l_bgv03   LIKE bgv_file.bgv03,
         l_bgv04   LIKE bgv_file.bgv04,
         l_bgv05   LIKE bgv_file.bgv05,
         l_bgv06   LIKE bgv_file.bgv06,
         l_bgv10   LIKE bgv_file.bgv10
  DEFINE l_bhd RECORD LIKE bhd_file.*
 
    LET g_sql="SELECT bgv01,bgv02,bgv03,bgv04,bgv05,bgv06,SUM(bgv10) ",
              "  FROM bgv_file ",
              " WHERE ", g_wc CLIPPED,
              " AND bgv00 ='1'          ",
              " AND bgv01 ='",g_bgv01,"'",
              " AND bgv02 =",g_bgv02,
              " GROUP BY bgv01,bgv02,bgv03,bgv04,bgv05,bgv06 "
    PREPARE p170_prebgk FROM g_sql
    DECLARE p170_cur1 CURSOR FOR p170_prebgk
 
    FOREACH p170_cur1 INTO l_bgv01,l_bgv02,l_bgv03,l_bgv04,l_bgv05,
                           l_bgv06,l_bgv10
       IF STATUS THEN
          CALL cl_err('p170(foreach):',STATUS,1)
          LET g_success='N'
          EXIT FOREACH
       END IF
       LET l_bhd.bhd01 = g_bgv01
       LET l_bhd.bhd02 = g_bgv02
       LET l_bhd.bhd03 = l_bgv03
       LET l_bhd.bhd04 = l_bgv04
       LET l_bhd.bhd05 = '@@@@5'
       #項次
       SELECT MAX(bhd06)+1 INTO l_bhd.bhd06 FROM bhd_file
        WHERE bhd01 = l_bhd.bhd01 AND bhd02 = l_bhd.bhd02
          AND bhd03 = l_bhd.bhd03 AND bhd04 = l_bhd.bhd04
          AND bhd05 = l_bhd.bhd05
       IF cl_null(l_bhd.bhd06) THEN LET l_bhd.bhd06 = 1 END IF
       #科目
       SELECT bgx04 INTO l_bhd.bhd07 FROM bgx_file
        WHERE bgx01 = l_bhd.bhd04
          AND bgx02 = l_bgv06
          AND bgx03 = l_bgv05
       IF STATUS THEN
#         CALL cl_err('sel bgx:','abg-019',1) #FUN-660105
          CALL cl_err3("sel","bgx_file",l_bhd.bhd04,l_bgv06,"abg-019","","sel bgx:",1) #FUN-660105
          LET g_success='N' EXIT FOREACH
       END IF
       LET l_bhd.bhd08 = ' '
       LET l_bhd.bhd09 = l_bgv10
       INSERT INTO bhd_file VALUES(l_bhd.*)
       IF STATUS THEN
#         CALL cl_err('ins bhd',STATUS,1) #FUN-660105
          CALL cl_err3("ins","bhd_file",l_bhd.bhd01,l_bhd.bhd02,STATUS,"","ins bhd",1) #FUN-660105
          LET g_success='N' EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#NO.FUN-570113 END-------
 
FUNCTION p170_del_bhd()
DEFINE i,j  LIKE type_file.num5    #No.FUN-680061 SMALLINT
   LET l_wc = g_wc
   LET i = length(l_wc)
   FOR j = 1 TO i
       IF l_wc[j,j+4]= 'bgv04' THEN LET l_wc[j,j+4] = 'bhd04' END IF
   END FOR
   LET g_sql = " DELETE FROM bhd_file ",
               "  WHERE bhd01='",g_bgv01,"'",
               "    AND bhd02='",g_bgv02,"'",
               "    AND bhd05='@@@@5'",
               "    AND ",l_wc CLIPPED
   PREPARE del_pre FROM g_sql
   EXECUTE del_pre
   IF SQLCA.sqlcode THEN
      CALL cl_err('DELETE bhd_file:',SQLCA.sqlcode,0)
   END IF
END FUNCTION
 
FUNCTION p170_p()
DEFINE sr       RECORD
                bhd01 LIKE bhd_file.bhd01,
                bhd02 LIKE bhd_file.bhd02,
                bhd03 LIKE bhd_file.bhd03,
                bhd04 LIKE bhd_file.bhd04,
                bhd05 LIKE bhd_file.bhd05,
                bhd07 LIKE bhd_file.bhd07,
                bhd09 LIKE bhd_file.bhd09
                END RECORD,
       l_bgq    RECORD LIKE bgq_file.*,
       l_bgq07  LIKE bgq_file.bgq07
 
 
       LET g_sql = "SELECT bhd01,bhd02,bhd03,bhd04,bhd05,bhd07,SUM(bhd09)",
                   "  FROM bhd_file ",
                   " WHERE bhd01 = '",g_bgv01,"'",
                   "   AND bhd02 = '",g_bgv02,"'",
                   "   AND bhd05 = '@@@@5' ",
                   "   AND ",l_wc CLIPPED,
                   " GROUP BY bhd01,bhd02,bhd03,bhd04,bhd05,bhd07 ",
                   " ORDER BY bhd01,bhd02,bhd03,bhd04,bhd05,bhd07 "
 
       PREPARE bgq_pre FROM g_sql
       DECLARE bgq_cs CURSOR FOR bgq_pre
       FOREACH bgq_cs INTO sr.*
           LET l_bgq.bgq01 = g_bgv01
           LET l_bgq.bgq02 = g_bgv02
           LET l_bgq.bgq03 = sr.bhd03
           LET l_bgq.bgq04 = sr.bhd07
           LET l_bgq.bgq05 = sr.bhd04
           LET l_bgq.bgq06 = sr.bhd09
           LET l_bgq.bgq061= 0
           LET l_bgq.bgq08 = 0
          #MOD-840190 begin
           IF cl_null(l_bgq.bgq051)  THEN LET l_bgq.bgq051 = ' ' END IF
           IF cl_null(l_bgq.bgq052)  THEN LET l_bgq.bgq052 = ' ' END IF
           IF cl_null(l_bgq.bgq053)  THEN LET l_bgq.bgq053 = ' ' END IF
          #MOD-840190 end
           SELECT SUM(bgq06+bgq061) INTO l_bgq07 FROM bgq_file
            WHERE bgq01 = l_bgq.bgq01
              AND bgq02 = l_bgq.bgq02
              AND bgq03 < l_bgq.bgq03
              AND bgq04 = l_bgq.bgq04
              AND bgq05 = l_bgq.bgq05
         #MOD-840509-begin
              AND bgq051= l_bgq.bgq051
              AND bgq052= l_bgq.bgq052
              AND bgq053= l_bgq.bgq053
         #MOD-840509-end
           IF cl_null(l_bgq07) THEN LET l_bgq07 = 0 END IF
           LET l_bgq.bgq07 = l_bgq07 + sr.bhd09
           INSERT INTO bgq_file VALUES(l_bgq.*)
          #TQC-790108
          #IF STATUS =-239 THEN
           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
              UPDATE bgq_file SET bgq06 = l_bgq.bgq06,
                                  bgq07 = l_bgq.bgq07
               WHERE bgq01 = l_bgq.bgq01
                 AND bgq02 = l_bgq.bgq02
                 AND bgq03 = l_bgq.bgq03
                 AND bgq04 = l_bgq.bgq04
                 AND bgq05 = l_bgq.bgq05
            #MOD-840509-begin
                 AND bgq051= l_bgq.bgq051
                 AND bgq052= l_bgq.bgq052
                 AND bgq053= l_bgq.bgq053
            #MOD-840509-end
              IF STATUS THEN
#                CALL cl_err('upd bgq:',STATUS,1) #FUN-660105
                 CALL cl_err3("upd","bgq_file",l_bgq.bgq01,l_bgq.bgq02,STATUS,"","upd bgq:",1) #FUN-660105
                 LET g_success='N'
                 EXIT FOREACH
              END IF
           ELSE
              IF STATUS THEN
#                CALL cl_err('ins bgq:',STATUS,1) #FUN-660105
                 CALL cl_err3("ins","bgq_file",l_bgq.bgq01,l_bgq.bgq02,STATUS,"","ins bgq:",1) #FUN-660105
                 LET g_success='N'
                 EXIT FOREACH
              END IF
           END IF
       END FOREACH
END FUNCTION
#Patch....NO.TQC-610035 <001> #

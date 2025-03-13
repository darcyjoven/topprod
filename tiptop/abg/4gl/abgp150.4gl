# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abgp150.4gl
# Descriptions...: 資產折舊科目產生作業
# Date & Author..: 03/03/19 By Kammy
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3]
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-790108 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-840509 08/04/23 By douzh bgq_file新增欄位更新,一并調整程式 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
       g_sql            string,  #No.FUN-580092 HCN
       g_wc,g_wc1,l_buf string,  #No.FUN-580092 HCN
       l_wc             LIKE type_file.chr1000,#No.FUN-680061   VARCHAR(1000)
       g_bgw01          LIKE bgw_file.bgw01,   # 版本
       g_bgw05          LIKE bgw_file.bgw05,   # 年度
       g_change_lang    LIKE type_file.chr1,   #No.FUN-570113   #No.FUN-680061 VARCHAR(01)
       ls_date          STRING,                #No.FUN-570113
       l_flag           LIKE type_file.chr1    #No.FUN-570113   #No.FUN-680061 VARCHAR(01)
#      p_row,p_col      LIKE type_file.num5    #No.FUN-570113   #No.FUN-680061 SMALLINT
 
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_cnt            LIKE type_file.num5    #NO.FUN-680061 SMALLINT
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0056
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570113 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgw01 = ARG_VAL(1)
   LET g_bgw05 = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #No.FUN-570113 --end--
 
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
#   OPEN WINDOW p150_w AT p_row,p_col WITH FORM "abg/42f/abgp150"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#   CALL p150()
#   CLOSE WINDOW p150_w
   WHILE TRUE
      IF g_bgjob="N" THEN
         CALL p150()
       IF cl_sure(0,0) THEN
          CALL cl_wait()
          LET g_success="Y"
          BEGIN WORK
          CALL p150_del_bhd()
          CALL p150_cur()
          CALL p150_p()
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
             CLOSE WINDOW p150_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
       CLOSE WINDOW p150_w
    ELSE
       LET g_success="Y"
       BEGIN WORK
       CALL p150_del_bhd()
       CALL p150_cur()
       CALL p150_p()
       IF g_success="Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
#No.FUN-570113 --end--
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p150()
  # No.FUN-570113 --start--
  DEFINE lc_cmd      LIKE zz_file.zz08      #No.FUN-680061 VARCHAR(500)
  DEFINE p_row,p_col LIKE type_file.num5    #No.FUN-680061 SMALLINT
#  DEFINE l_bgw01   LIKE bgw_file.bgw01,
#         l_bgw05   LIKE bgw_file.bgw05,
#         l_bgw06   LIKE bgw_file.bgw06,
#         l_bgw07   LIKE bgw_file.bgw07,
#         l_bgw10   LIKE bgw_file.bgw10,
#         l_bgw11   LIKE bgw_file.bgw11
#  DEFINE l_bhd RECORD LIKE bhd_file.*
 
  LET p_row=5
  LET p_col=25
 
  OPEN WINDOW p150_w AT p_row,p_col WITH FORM "abg/42f/abgp150"
  ATTRIBUTE(STYLE=g_win_style)
 
  CALL cl_ui_init()
  # No.FUN-570113 --end--
 
    CLEAR FORM
    CALL cl_opmsg('a')
 
    LET g_bgw05 = YEAR(g_today)
 
    LET g_bgw05 = YEAR(g_today)
    LET g_bgjob = "N"                                #No.FUN-570113
    WHILE TRUE                                       #No.FUN-570113
    INPUT g_bgw01,g_bgw05,g_bgjob WITHOUT DEFAULTS FROM bgw01,bgw05,g_bgjob HELP 1  #NO.FUN-570113
 
        AFTER FIELD bgw01
          IF cl_null(g_bgw01) THEN LET g_bgw01=' ' END IF
 
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
    #No.FUN-570113 --start--
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   
       CONTINUE WHILE
    END IF
    #IF INT_FLAG THEN RETURN END IF
     IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW p150_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
 
#    IF NOT cl_sure(18,20) THEN RETURN END IF
#    CALL cl_wait()
 
#    LET g_success='Y'
#    BEGIN WORK
 
#    CALL p150_del_bhd()
 
#    LET g_sql="SELECT bgw01,bgw05,bgw06,bgw07,bgw11,SUM(bgw09+bgw10) ",
#              "  FROM bgw_file ",
#              " WHERE bgw01 ='",g_bgw01,"'",
#              "   AND bgw05 =",g_bgw05,
#              "   AND bgw08 IN ('1','3') ",         #惕除多部門
#              " GROUP BY bgw01,bgw05,bgw06,bgw07,bgw11 "
#    PREPARE p150_prebgk FROM g_sql
#    DECLARE p150_cur1 CURSOR FOR p150_prebgk
# 
#    FOREACH p150_cur1 INTO l_bgw01,l_bgw05,l_bgw06,l_bgw07,l_bgw11,l_bgw10
#        IF STATUS THEN
#          CALL cl_err('p150(foreach):',STATUS,1)
#          LET g_success='N'
#          EXIT FOREACH
#       END IF
#        LET l_bhd.bhd01 = g_bgw01
#       LET l_bhd.bhd02 = g_bgw05
#       LET l_bhd.bhd03 = l_bgw06
#       LET l_bhd.bhd04 = l_bgw07
#        LET l_bhd.bhd05 = '折舊'
#       #項次
#       SELECT MAX(bhd06)+1 INTO l_bhd.bhd06 FROM bhd_file
#        WHERE bhd01 = l_bhd.bhd01 AND bhd02 = l_bhd.bhd02
#         AND bhd03 = l_bhd.bhd03 AND bhd04 = l_bhd.bhd04
#         AND bhd05 = l_bhd.bhd05
#      IF cl_null(l_bhd.bhd06) THEN LET l_bhd.bhd06 = 1 END IF
#      IF cl_null(l_bgw11) THEN
#         CALL cl_err('','abg-020',1)
#         LET g_success='N'
#         EXIT FOREACH
#       END IF
#       LET l_bhd.bhd07 = l_bgw11
#       LET l_bhd.bhd08 = ' '
#       LET l_bhd.bhd09 = l_bgw10
#       INSERT INTO bhd_file VALUES(l_bhd.*)
#       IF STATUS THEN
#          CALL cl_err('ins bhd',STATUS,1)
#           LET g_success='N' EXIT FOREACH
#       END IF
#    END FOREACH
#
#    CALL p150_p()  # INSERT INTO bgq_file
# 
#    IF g_success = 'Y' THEN
#        COMMIT WORK
#    ELSE
#       ROLLBACK WORK
#       RETURN
#    END IF
#    ERROR ""
#    CALL cl_end(18,20)
   IF g_bgjob="Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01="abgp150"
      IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('abgp150','9031',1) 
      ELSE
         LET lc_cmd=lc_cmd CLIPPED,
                    " '",g_bgw01 CLIPPED,"'",
                    " '",g_bgw05 CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('abgp150',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p150_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
      EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE
#No.FUN-570113 --end--
 
END FUNCTION
 
#No.FUN-570113 --start--
FUNCTION p150_cur()
  DEFINE l_bgw01   LIKE bgw_file.bgw01,
         l_bgw05   LIKE bgw_file.bgw05,
         l_bgw06   LIKE bgw_file.bgw06,
         l_bgw07   LIKE bgw_file.bgw07,
         l_bgw10   LIKE bgw_file.bgw10,
         l_bgw11   LIKE bgw_file.bgw11
  DEFINE l_bhd RECORD LIKE bhd_file.*
 
    LET g_sql="SELECT bgw01,bgw05,bgw06,bgw07,bgw11,SUM(bgw09+bgw10) ",
              "  FROM bgw_file ",
              " WHERE bgw01 ='",g_bgw01,"'",
              "   AND bgw05 =",g_bgw05,
              "   AND bgw08 IN ('1','3') ",         #惕除多部門
              " GROUP BY bgw01,bgw05,bgw06,bgw07,bgw11 "
    PREPARE p150_prebgk FROM g_sql
    DECLARE p150_cur1 CURSOR FOR p150_prebgk
 
    FOREACH p150_cur1 INTO l_bgw01,l_bgw05,l_bgw06,l_bgw07,l_bgw11,l_bgw10
        IF STATUS THEN
          CALL cl_err('p150(foreach):',STATUS,1)
          LET g_success='N'
          EXIT FOREACH
       END IF
        LET l_bhd.bhd01 = g_bgw01
       LET l_bhd.bhd02 = g_bgw05
       LET l_bhd.bhd03 = l_bgw06
       LET l_bhd.bhd04 = l_bgw07
        LET l_bhd.bhd05 = '折舊'
       #項次
       SELECT MAX(bhd06)+1 INTO l_bhd.bhd06 FROM bhd_file
        WHERE bhd01 = l_bhd.bhd01 AND bhd02 = l_bhd.bhd02
         AND bhd03 = l_bhd.bhd03 AND bhd04 = l_bhd.bhd04
         AND bhd05 = l_bhd.bhd05
      IF cl_null(l_bhd.bhd06) THEN LET l_bhd.bhd06 = 1 END IF
      IF cl_null(l_bgw11) THEN
         CALL cl_err('','abg-020',1)
         LET g_success='N'
         EXIT FOREACH
       END IF
       LET l_bhd.bhd07 = l_bgw11
       LET l_bhd.bhd08 = ' '
       LET l_bhd.bhd09 = l_bgw10
       INSERT INTO bhd_file VALUES(l_bhd.*)
       IF STATUS THEN
#         CALL cl_err('ins bhd',STATUS,1) #FUN-660105
          CALL cl_err3("ins","bhd_file",l_bhd.bhd01,l_bhd.bhd02,STATUS,"","ins bhd",1) #FUN-660105
          LET g_success='N' EXIT FOREACH
       END IF
    END FOREACH
END FUNCTION
#NO.FUN-570133 END-----------
 
FUNCTION p150_del_bhd()
   DELETE FROM bhd_file
    WHERE bhd01=g_bgw01
      AND bhd02=g_bgw05 AND bhd05='折舊'
END FUNCTION
 
FUNCTION p150_p()
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
                   " WHERE bhd01 = '",g_bgw01,"'",
                   "   AND bhd02 = '",g_bgw05,"'",
                   "   AND bhd05 = '折舊' ",
                   " GROUP BY bhd01,bhd02,bhd03,bhd04,bhd05,bhd07 ",
                   " ORDER BY bhd01,bhd02,bhd03,bhd04,bhd05,bhd07 "
 
       PREPARE bgq_pre FROM g_sql
       DECLARE bgq_cs CURSOR FOR bgq_pre
       FOREACH bgq_cs INTO sr.*
           LET l_bgq.bgq01 = g_bgw01
           LET l_bgq.bgq02 = g_bgw05
           LET l_bgq.bgq03 = sr.bhd03
           LET l_bgq.bgq04 = sr.bhd07
           LET l_bgq.bgq05 = sr.bhd04
           LET l_bgq.bgq06 = sr.bhd09
           LET l_bgq.bgq061= 0
           LET l_bgq.bgq08 = 0
          #MOD-840509 begin
           IF cl_null(l_bgq.bgq051) THEN LET l_bgq.bgq051 = ' ' END IF
           IF cl_null(l_bgq.bgq052) THEN LET l_bgq.bgq052 = ' ' END IF
           IF cl_null(l_bgq.bgq053) THEN LET l_bgq.bgq053 = ' ' END IF
          #MOD-840509 end
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
                 CALL cl_err3("upd","bgq_file",l_bgq.bgq01,l_bgq.bgq02,STATUS,"","upd bgq",1) #FUN-660105
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

# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: abgp200.4gl
# Descriptions...: 採購預算自動產生作業
# Date & Author..: 02/10/15 By qazzaq
# Modify.........: No:8816 03/12/03 ching 每季做尾差處理
# Modify.........: No.FUN-4C0007 04/12/01 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: No.FUN-660105 06/06/16 By hellen cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.MOD-840509 08/04/23 By douzh bgq_file欄位順序更新,一并調整程式 
# Modify.........: No.TQC-860021 08/06/10 By Sarah CONSTRUCT段漏了ON IDLE控制
# Modify.........: No.MOD-920262 09/02/20 By Sarah 計算季分攤時,不應以1-3月為第一季這種固定算法,而該串回azn_file抓取該期別實際所屬季別
# Modify.........: No.MOD-980202 09/08/22 By Sarah 產生出來的資料有尾差
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A10007 10/01/13 By Sarah 產生出來的資料計算錯誤
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
       g_sql            string,                  #No.FUN-580092 HCN
       g_wc,g_wc1,l_buf string,                  #No.FUN-580092 HCN
 
       g_bgq01          LIKE bgq_file.bgq01,     # 版本
       g_bgq02          LIKE bgq_file.bgq02,     # 年度
 
       g_start,g_end    LIKE cre_file.cre08,     #NO.FUN-680061 VARCHAR(10)
       g_change_lang    LIKE type_file.chr1,     # No.FUN-570113 #No.FUN-680061 VARCHAR(01)
       ls_date          STRING,                  # No.FUN-570113
       l_flag           LIKE type_file.chr1      # No.FUN-570113 #No.FUN-680061 VARCHAR(01)
       #p_row,p_col      LIKE type_file.num5     #NO.FUN-570113 MARK #No.FUN-680061 SMALLINT
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_cnt           LIKE type_file.num5     #No.FUN-680061 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0056
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   # No.FUN-570113 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET g_bgq01 = ARG_VAL(2)
   LET g_bgq02 = ARG_VAL(3)
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
#   LET p_row = 5 LET p_col = 15
#   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "abg/42f/abgp200"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#   CALL p200()
#   CLOSE WINDOW p200_w
 WHILE TRUE
    IF g_bgjob="N" THEN
       CALL p200()
       IF cl_sure(0,0) THEN
          CALL cl_wait()
          LET g_success="Y"
          BEGIN WORK
          CALL p200_del_bhd()
          CALL p200_cur()
          CALL p200_p()
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
             CLOSE WINDOW p200_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
       CLOSE WINDOW p200_w
    ELSE
       LET g_success="Y"
       BEGIN WORK
       CALL p200_del_bhd()
       CALL p200_cur()
       CALL p200_p()
       IF g_success="Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
 # No.FUN-570113 --end--
 CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p200()
  # No.FUN-570113 --start--
  DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-680061 VARCHAR(500)
  DEFINE p_row,p_col   LIKE type_file.num5     #No.FUN-680061 SMALLINT
#  DEFINE sr        RECORD LIKE bhc_file.*
#  DEFINE l_bhd     RECORD LIKE bhd_file.*
#  DEFINE l_Q1,l_Q2,l_Q3,l_Q4     DEC(20,6),   #No.FUN-4C0007
#         sum_Q1,sum_Q2           DEC(20,6),   #No.FUN-4C0007
#         sum_Q3,sum_Q4           DEC(20,6),   #No.FUN-4C0007
#         max_bhc03               SMALLINT,
#         sum_bhd09  LIKE bhd_file.bhd09,
#         sum_bhd09a LIKE bhd_file.bhd09,
#         l_bgk02   LIKE bgk_file.bgk02,
#         l_bgk03   LIKE bgk_file.bgk03,
#         l_bgk04   LIKE bgk_file.bgk04,
#         l_count   SMALLINT,
#         l_sum     DEC(20,6),    #分攤基礎總值
#         l_i       LIKE type_file.num5,       #期別        #No.FUN-680061
#         l_n       LIKE type_file.num5          #No.FUN-680061
 
   LET p_row=5
   LET p_col=25
 
   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "abg/42f/abgp200"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
 # No.FUN-570113 --end--
 
    CLEAR FORM
    CALL cl_opmsg('a')
WHILE TRUE
    CONSTRUCT BY NAME g_wc ON bgk02 HELP 1
 
      ON ACTION locale                             #No.FUN-570113
         LET g_change_lang = TRUE                  #No.FUN-570113
         EXIT CONSTRUCT                            #No.FUN-570113
 
      ON ACTION controlg       #TQC-860021
         CALL cl_cmdask()      #TQC-860021
 
      ON IDLE g_idle_seconds   #TQC-860021
         CALL cl_on_idle()     #TQC-860021
         CONTINUE CONSTRUCT    #TQC-860021
 
      ON ACTION about          #TQC-860021
         CALL cl_about()       #TQC-860021
 
      ON ACTION help           #TQC-860021
         CALL cl_show_help()   #TQC-860021
    END CONSTRUCT                                  #No.FUN-570113
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   #No.FUN-570113 --start--
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()
       CONTINUE WHILE
    END IF
   #No.FUN-570113 --end--
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0 CLOSE WINDOW abgp200_w 
       CLOSE WINDOW p200_w                         #No.FUN-570113
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
    IF g_wc=" 1=1" THEN
       CALL cl_err('','9046',0) CONTINUE WHILE
#    ELSE                    #NO.FUN-570113
#       EXIT WHILE           #NO.FUN-570113
    END IF 
#END WHILE                   #NO.FUN-570113
 
    LET g_bgq02 = YEAR(g_today)
    LET g_bgjob = "N"                              #No.FUN-570113
    #INPUT g_bgq01,g_bgq02 WITHOUT DEFAULTS FROM bgq01,bgq02 HELP 1
    INPUT g_bgq01,g_bgq02,g_bgjob WITHOUT DEFAULTS 
      FROM bgq01,bgq02,g_bgjob HELP 1   #NO.FUN-570113
 
       AFTER FIELD bgq01
         IF cl_null(g_bgq01) THEN LET g_bgq01 = ' ' END IF
 
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
 
#   IF INT_FLAG THEN RETURN END IF
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW p200_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
 
#    IF NOT cl_sure(18,20) THEN RETURN END IF
#    CALL cl_wait()
 
#    LET g_success='Y'
#    BEGIN WORK
 
#   CALL p200_del_bhd()
 
#    #計算各季費用分攤的權數
#    LET l_sum  = g_bgz.bgz17 + g_bgz.bgz18 + g_bgz.bgz19 + g_bgz.bgz20
#    LET l_Q1   = g_bgz.bgz17 / l_sum
#    LET l_Q2   = g_bgz.bgz18 / l_sum
#    LET l_Q3   = g_bgz.bgz19 / l_sum
#    LET l_Q4   = g_bgz.bgz20 / l_sum
 
 
#    LET g_sql = "SELECT bgk02,bgk03,bgk04 FROM bgk_file ",
#                " WHERE ", g_wc CLIPPED,
#                "   AND bgk01 ='",g_bgq01,"'"
#    PREPARE p200_prebgk FROM g_sql
#    DECLARE p200_cur1 CURSOR FOR p200_prebgk
#
#    LET g_sql = "SELECT * FROM bhc_file ",
#                " WHERE bhc01 = ? ",
#                "   AND bhc02 = ? ",
#                "  ORDER BY bhc03 "
#    PREPARE bhc_pre FROM g_sql
#    DECLARE bhc_cs  CURSOR FOR bhc_pre       #挑出abgi410有的
#
#    FOREACH p200_cur1 INTO l_bgk02,l_bgk03,l_bgk04
#        IF STATUS THEN
#           CALL cl_err('p200(foreach):',STATUS,1)
#           LET g_success='N'
#           EXIT FOREACH
#        END IF
#        LET sum_Q1 = l_bgk04 * l_Q1       #第一季    分配的金額
#        LET sum_Q2 = l_bgk04 * l_Q2       #第二季    分配的金額
#        LET sum_Q3 = l_bgk04 * l_Q3       #第三季    分配的金額
#        LET sum_Q4 = l_bgk04 * l_Q4       #第四季    分配的金額
#        CALL cl_digcut(sum_Q1,g_azi04) RETURNING sum_Q1
#        CALL cl_digcut(sum_Q2,g_azi04) RETURNING sum_Q2
#        CALL cl_digcut(sum_Q3,g_azi04) RETURNING sum_Q3
#        CALL cl_digcut(sum_Q4,g_azi04) RETURNING sum_Q4
#        LET sum_Q4=l_bgk04 - sum_Q1 - sum_Q2 - sum_Q3
# 
#        #計算分攤基礎總合
#        SELECT SUM(bhc07) INTO l_sum
#          FROM bhc_file
#         WHERE bhc01=l_bgk02
#           AND bhc02=l_bgk03
#        IF cl_null(l_sum) THEN LET l_sum = 0 END IF
#
#        #找到最後一筆項次以方便規尾差
#        SELECT MAX(bhc03) INTO max_bhc03 FROM bhc_file
#         WHERE bhc01=l_bgk02
#           AND bhc02=l_bgk03
#        IF cl_null(max_bhc03) THEN LET max_bhc03 = 1 END IF
# 
#        LET sum_bhd09 = 0
#        LET sum_bhd09a= 0
#        FOREACH bhc_cs USING l_bgk02,l_bgk03 INTO sr.*
#
#             #INSERT 費用分攤檔
#             LET l_bhd.bhd01 = g_bgq01
#             LET l_bhd.bhd02 = g_bgq02
#             LET l_bhd.bhd04 = sr.bhc01   #分攤部門
#             LET l_bhd.bhd05 = sr.bhc02   #分攤類別
#             LET l_bhd.bhd06 = sr.bhc03   #分攤項次
#             LET l_bhd.bhd07 = sr.bhc04   #會計科目
#             LET l_bhd.bhd08 = sr.bhc05   #部分攤部門
#
#             #第一季分攤金額
#             LET l_bhd.bhd09 = sum_Q1 * (sr.bhc07/l_sum) /3
#             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#             LET sum_bhd09 = 0
#             FOR l_i=1 TO 3
#                 LET l_bhd.bhd03 = l_i
#                 IF l_i=3 THEN
#                    LET l_bhd.bhd09=(sum_Q1 * (sr.bhc07/l_sum)) - sum_bhd09
#                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#                 END IF
#                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
#                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
#                 INSERT INTO bhd_file VALUES(l_bhd.*)
#                 IF STATUS THEN
#                    CALL cl_err('ins bhd1',STATUS,1)
#                    LET g_success='N'
#                    EXIT FOREACH
#                 END IF
#             END FOR
#             #第二季分攤金額
#             LET l_bhd.bhd09 = sum_Q2 * (sr.bhc07/l_sum) /3
#             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#             LET sum_bhd09 = 0
#             FOR l_i=4 TO 6
#                 LET l_bhd.bhd03 = l_i
#                 IF l_i=6 THEN
#                    LET l_bhd.bhd09=(sum_Q2 * (sr.bhc07/l_sum)) - sum_bhd09
#                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#                 END IF
#                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
#                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
#                 INSERT INTO bhd_file VALUES(l_bhd.*)
#                 IF STATUS THEN
#                    CALL cl_err('ins bhd2',STATUS,1)
#                    LET g_success='N'
#                    EXIT FOREACH
#                 END IF
#             END FOR
#             #第三季分攤金額
#             LET l_bhd.bhd09 = sum_Q3 * (sr.bhc07/l_sum) /3
#             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#             LET sum_bhd09 = 0
#             FOR l_i=7 TO 9
#                 LET l_bhd.bhd03 = l_i
#                 IF l_i=9 THEN
#                    LET l_bhd.bhd09=(sum_Q3 * (sr.bhc07/l_sum)) - sum_bhd09
#                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#                 END IF
#                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
#                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
#                 INSERT INTO bhd_file VALUES(l_bhd.*)
#                 IF STATUS THEN
#                    CALL cl_err('ins bhd3',STATUS,1)
#                    LET g_success='N'
#                    EXIT FOREACH
#                 END IF
#             END FOR
#             #第四季分攤金額
#             LET l_bhd.bhd09 = sum_Q4 * (sr.bhc07/l_sum) /3
#             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#             LET sum_bhd09 = 0
#             FOR l_i=10 TO 12
#                 LET l_bhd.bhd03 = l_i
#                 IF l_i=12 THEN
#                    LET l_bhd.bhd09=(sum_Q4 * (sr.bhc07/l_sum)) - sum_bhd09
#                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
#                 END IF
#                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
#                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
#                 INSERT INTO bhd_file VALUES(l_bhd.*)
#                 IF STATUS THEN
#                    CALL cl_err('ins bhd4',STATUS,1)
#                    LET g_success='N'
#                    EXIT FOREACH
#                 END IF
#             END FOR
#        END FOREACH
#    END FOREACH
#
#    CALL p200_p()
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
          WHERE zz01="abgp200"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('abgp200','9031',1)  
        ELSE
           LET g_wc = cl_replace_str(g_wc,"'","\"")
           LET lc_cmd=lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",g_bgq01 CLIPPED,"'",
                      " '",g_bgq02 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('abgp200',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p200_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
     EXIT WHILE
END WHILE
# No.FUN-570113 --end--
END FUNCTION
 
#No.FUN-570113 --start--
FUNCTION p200_cur()
  DEFINE sr        RECORD LIKE bhc_file.*
  DEFINE l_bhd     RECORD LIKE bhd_file.*
  DEFINE o_bhd     RECORD LIKE bhd_file.*   #TQC-A10007 add
  DEFINE l_Q1,l_Q2,l_Q3,l_Q4     LIKE oeb_file.oeb14,   #NO.FUN-680061 DEC(20,6) 
         sum_Q1,sum_Q2           LIKE oeb_file.oeb14,   #NO.FUN-680061 DEC(20,6) 
         sum_Q3,sum_Q4           LIKE oeb_file.oeb14,   #NO.FUN-680061 DEC(20,6) 
         max_bhc03               LIKE bhc_file.bhc03,   #No.FUN-680061 SMALLINT
         sum_bhd09  LIKE bhd_file.bhd09,
         sum_bhd09a LIKE bhd_file.bhd09,
         sum_bhd09b LIKE bhd_file.bhd09,   #TQC-A10007 add
         l_bhd09    LIKE bhd_file.bhd09,   #TQC-A10007 add
         l_bhd09s   LIKE bhd_file.bhd09,   #TQC-A10007 add
         l_bhd09s1  LIKE bhd_file.bhd09,   #TQC-A10007 add
         l_bgk02   LIKE bgk_file.bgk02,
         l_bgk03   LIKE bgk_file.bgk03,
         l_bgk04   LIKE bgk_file.bgk04,
         l_count   LIKE type_file.num5,   #No.FUN-680061 SMALLINT
         l_sum     LIKE oeb_file.oeb14,   #NO.FUN-680061 DEC(20,6) 
         l_i       LIKE type_file.num5,   #期別 #No.FUN-680061 SMALLINT
         l_n       LIKE type_file.num5    #No.FUN-680061 SMALLINT
  DEFINE l_month   LIKE ooy_file.ooytype  #TQC-620021 #NO.FUN-680061 VARCHAR(2)
  DEFINE l_azn03   LIKE azn_file.azn03    #MOD-920262 add
  DEFINE l_azn041  LIKE azn_file.azn04    #MOD-920262 add
  DEFINE l_azn042  LIKE azn_file.azn04    #MOD-920262 add
  DEFINE l_azn043  LIKE azn_file.azn04    #MOD-920262 add
  DEFINE l_azn044  LIKE azn_file.azn04    #MOD-920262 add
 
    #計算各季費用分攤的權數
    LET l_sum  = g_bgz.bgz17 + g_bgz.bgz18 + g_bgz.bgz19 + g_bgz.bgz20
    LET l_Q1   = g_bgz.bgz17 / l_sum
    LET l_Q2   = g_bgz.bgz18 / l_sum
    LET l_Q3   = g_bgz.bgz19 / l_sum
    LET l_Q4   = g_bgz.bgz20 / l_sum
 
    LET g_sql = "SELECT bgk02,bgk03,bgk04 FROM bgk_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND bgk01 ='",g_bgq01,"'"
    PREPARE p200_prebgk FROM g_sql
    DECLARE p200_cur1 CURSOR FOR p200_prebgk
 
    LET g_sql = "SELECT * FROM bhc_file ",
                " WHERE bhc01 = ? ",
                "   AND bhc02 = ? ",
                "  ORDER BY bhc03 "
    PREPARE bhc_pre FROM g_sql
    DECLARE bhc_cs  CURSOR FOR bhc_pre       #挑出abgi410有的
 
   #TQC-A10007 add 
    #分攤金額最大的那一筆
    LET g_sql = "SELECT * FROM bhd_file ",
                " WHERE bhd01 = '",g_bgq01,"'",
                "   AND bhd02 = ",g_bgq02,
                "   AND bhd03 = ?",   #月份 
                "   AND bhd04 = ?",   #分攤部門
                "   AND bhd05 = ?",   #分攤類別
                " ORDER BY bhd09 DESC"
    PREPARE bhd_pre1 FROM g_sql
    DECLARE bhd_cs1  CURSOR FOR bhd_pre1 

    #實際分攤總金額
    LET g_sql = "SELECT SUM(bhd09) FROM bhd_file ",
                " WHERE bhd01 = '",g_bgq01,"'",
                "   AND bhd02 = ",g_bgq02,
                "   AND bhd03 = ?",   #月份 
                "   AND bhd04 = ?",   #分攤部門
                "   AND bhd05 = ?"    #分攤類別
    PREPARE bhd_pre2 FROM g_sql
    DECLARE bhd_cs2  CURSOR FOR bhd_pre2 
   #TQC-A10007 add

   #str MOD-920262 add
    LET g_sql = "SELECT DISTINCT azn04 FROM azn_file ",
                " WHERE azn02 = ? ",
                "   AND azn03 = ? ",
                "  ORDER BY azn04 "
    PREPARE azn_pre FROM g_sql
    DECLARE azn_cs  CURSOR FOR azn_pre
   
    SELECT MAX(azn04) INTO l_azn041 FROM azn_file   #第一季最大月份
     WHERE azn02=g_bgq02 AND azn03=1
    SELECT MAX(azn04) INTO l_azn042 FROM azn_file   #第二季最大月份
     WHERE azn02=g_bgq02 AND azn03=2
    SELECT MAX(azn04) INTO l_azn043 FROM azn_file   #第三季最大月份
     WHERE azn02=g_bgq02 AND azn03=3
    SELECT MAX(azn04) INTO l_azn044 FROM azn_file   #第四季最大月份
     WHERE azn02=g_bgq02 AND azn03=4
   #end MOD-920262 add
 
    FOREACH p200_cur1 INTO l_bgk02,l_bgk03,l_bgk04
        IF STATUS THEN
           CALL cl_err('p200(foreach):',STATUS,1)
           LET g_success='N'
           EXIT FOREACH
        END IF
        LET sum_Q1 = l_bgk04 * l_Q1       #第一季    分配的金額
        LET sum_Q2 = l_bgk04 * l_Q2       #第二季    分配的金額
        LET sum_Q3 = l_bgk04 * l_Q3       #第三季    分配的金額
        LET sum_Q4 = l_bgk04 * l_Q4       #第四季    分配的金額
        CALL cl_digcut(sum_Q1,g_azi04) RETURNING sum_Q1
        CALL cl_digcut(sum_Q2,g_azi04) RETURNING sum_Q2
        CALL cl_digcut(sum_Q3,g_azi04) RETURNING sum_Q3
        CALL cl_digcut(sum_Q4,g_azi04) RETURNING sum_Q4
        LET sum_Q4=l_bgk04 - sum_Q1 - sum_Q2 - sum_Q3
 
        #計算分攤基礎總合
        SELECT SUM(bhc07) INTO l_sum
          FROM bhc_file
         WHERE bhc01=l_bgk02
           AND bhc02=l_bgk03
        IF cl_null(l_sum) THEN LET l_sum = 0 END IF
 
        #找到最後一筆項次以方便規尾差
        SELECT MAX(bhc03) INTO max_bhc03 FROM bhc_file
         WHERE bhc01=l_bgk02
           AND bhc02=l_bgk03
        IF cl_null(max_bhc03) THEN LET max_bhc03 = 1 END IF
 
        LET sum_bhd09 = 0
        LET sum_bhd09a= 0
        FOREACH bhc_cs USING l_bgk02,l_bgk03 INTO sr.*
 
             #INSERT 費用分攤檔
             LET l_bhd.bhd01 = g_bgq01    #版本
             LET l_bhd.bhd02 = g_bgq02    #年度
             LET l_bhd.bhd04 = sr.bhc01   #分攤部門
             LET l_bhd.bhd05 = sr.bhc02   #分攤類別
             LET l_bhd.bhd06 = sr.bhc03   #分攤項次
             LET l_bhd.bhd07 = sr.bhc04   #會計科目
             LET l_bhd.bhd08 = sr.bhc05   #部分攤部門
 
             #第一季分攤金額
             LET l_bhd.bhd09 = sum_Q1 * (sr.bhc07/l_sum) /3
             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
             LET sum_bhd09 = 0
            #FOR l_i=1 TO 3                                     #MOD-920262 mark
             LET l_azn03 = 1                                    #MOD-920262
             FOREACH azn_cs USING l_bhd.bhd02,l_azn03 INTO l_i  #MOD-920262
                 LET l_bhd.bhd03 = l_i
                #IF l_i=3 THEN          #MOD-920262 mark
                 IF l_i=l_azn041 THEN   #MOD-920262
                   #LET l_bhd.bhd09=(sum_Q1 * (sr.bhc07/l_sum)) - sum_bhd09                   #MOD-980202 mark
                    LET l_bhd.bhd09=cl_digcut(sum_Q1 * (sr.bhc07/l_sum),g_azi04) - sum_bhd09  #MOD-980202
                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
                 END IF
                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
                 INSERT INTO bhd_file VALUES(l_bhd.*)
                 IF STATUS THEN
#                   CALL cl_err('ins bhd1',STATUS,1) #FUN-660105
                    CALL cl_err3("ins","bhd_file",l_bhd.bhd01,l_bhd.bhd02,STATUS,"","ins bhd1",1) #FUN-660105
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
             END FOREACH   #MOD-920262
            #END FOR       #MOD-920262 mark
             #第二季分攤金額
             LET l_bhd.bhd09 = sum_Q2 * (sr.bhc07/l_sum) /3
             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
             LET sum_bhd09 = 0
            #FOR l_i=4 TO 6                                     #MOD-920262 mark
             LET l_azn03 = 2                                    #MOD-920262
             FOREACH azn_cs USING l_bhd.bhd02,l_azn03 INTO l_i  #MOD-920262
                 LET l_bhd.bhd03 = l_i
                #IF l_i=6 THEN          #MOD-920262 mark
                 IF l_i=l_azn042 THEN   #MOD-920262
                   #LET l_bhd.bhd09=(sum_Q2 * (sr.bhc07/l_sum)) - sum_bhd09                   #MOD-980202 mark
                    LET l_bhd.bhd09=cl_digcut(sum_Q2 * (sr.bhc07/l_sum),g_azi04) - sum_bhd09  #MOD-980202
                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
                 END IF
                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
                 INSERT INTO bhd_file VALUES(l_bhd.*)
                 IF STATUS THEN
#                   CALL cl_err('ins bhd2',STATUS,1) #FUN-660105
                    CALL cl_err3("ins","bhd_file",l_bhd.bhd01,l_bhd.bhd02,STATUS,"","ins bhd2",1) #FUN-660105
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
             END FOREACH   #MOD-920262
            #END FOR       #MOD-920262 mark
             #第三季分攤金額
             LET l_bhd.bhd09 = sum_Q3 * (sr.bhc07/l_sum) /3
             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
             LET sum_bhd09 = 0
            #FOR l_i=7 TO 9                                     #MOD-920262 mark
             LET l_azn03 = 3                                    #MOD-920262
             FOREACH azn_cs USING l_bhd.bhd02,l_azn03 INTO l_i  #MOD-920262
                 LET l_bhd.bhd03 = l_i
                #IF l_i=9 THEN          #MOD-920262 mark
                 IF l_i=l_azn043 THEN   #MOD-920262
                   #LET l_bhd.bhd09=(sum_Q3 * (sr.bhc07/l_sum)) - sum_bhd09                   #MOD-980202 mark
                    LET l_bhd.bhd09=cl_digcut(sum_Q3 * (sr.bhc07/l_sum),g_azi04) - sum_bhd09  #MOD-980202
                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
                 END IF
                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
                 INSERT INTO bhd_file VALUES(l_bhd.*)
                 IF STATUS THEN
#                   CALL cl_err('ins bhd3',STATUS,1) #FUN-660105
                    CALL cl_err3("ins","bhd_file",l_bhd.bhd01,l_bhd.bhd02,STATUS,"","ins bhd3",1) #FUN-660105
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
             END FOREACH   #MOD-920262
            #END FOR       #MOD-920262 mark
             #第四季分攤金額
             LET l_bhd.bhd09 = sum_Q4 * (sr.bhc07/l_sum) /3
             LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
             LET sum_bhd09 = 0
            #FOR l_i=10 TO 12                                   #MOD-920262 mark
             LET l_azn03 = 4                                    #MOD-920262
             FOREACH azn_cs USING l_bhd.bhd02,l_azn03 INTO l_i  #MOD-920262
                 LET l_bhd.bhd03 = l_i
                #IF l_i=12 THEN         #MOD-920262 mark
                 IF l_i=l_azn044 THEN   #MOD-920262  #MOD-980202 mod
                   #LET l_bhd.bhd09=(sum_Q4 * (sr.bhc07/l_sum)) - sum_bhd09                   #MOD-980202 mark
                    LET l_bhd.bhd09=cl_digcut(sum_Q4 * (sr.bhc07/l_sum),g_azi04) - sum_bhd09  #MOD-980202
                    LET l_bhd.bhd09 = cl_digcut(l_bhd.bhd09,g_azi04)
                 END IF
                 LET sum_bhd09 = sum_bhd09 + l_bhd.bhd09
                 LET sum_bhd09a= sum_bhd09a+ l_bhd.bhd09
                #str MOD-980202 add
                #調整尾差
                 IF max_bhc03=sr.bhc03 THEN   #最後一筆
                    IF l_i=l_azn044 THEN      #最後一個月
                       IF l_bgk04 != sum_bhd09a THEN  #加總金額與總分攤金額不同
                          LET l_bhd.bhd09=l_bhd.bhd09+(l_bgk04-sum_bhd09a)
                       END IF
                    END IF
                 END IF
                #end MOD-980202 add
                 INSERT INTO bhd_file VALUES(l_bhd.*)
                 IF STATUS THEN
#                   CALL cl_err('ins bhd4',STATUS,1) #FUN-660105
                    CALL cl_err3("ins","bhd_file",l_bhd.bhd01,l_bhd.bhd02,STATUS,"","ins bhd4",1) #FUN-660105
                    LET g_success='N'
                    EXIT FOREACH
                 END IF
             END FOREACH   #MOD-920262
            #END FOR       #MOD-920262 mark
        END FOREACH
       #TQC-A10007 add
        FOR l_i=1 TO 12
           OPEN bhd_cs2 USING l_i,l_bgk02,l_bgk03 
           FETCH bhd_cs2 INTO sum_bhd09b 
           IF sum_bhd09b*12 != l_bgk04 THEN
              FOREACH bhd_cs1 USING l_i,l_bgk02,l_bgk03 INTO o_bhd.* 
                 LET l_bhd09 = cl_digcut(l_bgk04/12-sum_bhd09b,g_azi04) 
                 UPDATE bhd_file SET bhd09=bhd09+l_bhd09  
                  WHERE bhd01=g_bgq01
                    AND bhd02=g_bgq02  
                    AND bhd03=l_i
                    AND bhd04=o_bhd.bhd04 
                    AND bhd05=o_bhd.bhd05 
                    AND bhd06=o_bhd.bhd06 
                    AND bhd07=o_bhd.bhd07 
                    AND bhd08=o_bhd.bhd08 
                 EXIT FOREACH
              END FOREACH
           END IF 
        END FOR
       #TQC-A10007 add
    END FOREACH
   #TQC-A10007 add
    FOREACH p200_cur1 INTO l_bgk02,l_bgk03,l_bgk04
       IF STATUS THEN
          CALL cl_err('p200(foreach):',STATUS,1)
          LET g_success='N'
          EXIT FOREACH
       END IF
       LET l_i = 12
       FOREACH bhd_cs1 USING l_i,l_bgk02,l_bgk03 INTO o_bhd.* 
          LET l_bhd09s = 0 
          SELECT SUM(bhd09) INTO l_bhd09s FROM bhd_file 
           WHERE bhd01=g_bgq01
             AND bhd02=g_bgq02  
             AND bhd04=o_bhd.bhd04 
             AND bhd05=o_bhd.bhd05 
          IF l_bhd09s != l_bgk04 THEN
             LET l_bhd09 = cl_digcut(l_bgk04-l_bhd09s,g_azi04) 
             UPDATE bhd_file SET bhd09=bhd09+l_bhd09
              WHERE bhd01=g_bgq01
                AND bhd02=g_bgq02  
                AND bhd03=l_i
                AND bhd05=o_bhd.bhd05
                AND bhd06=o_bhd.bhd06 
                AND bhd07=o_bhd.bhd07 
                AND bhd08=o_bhd.bhd08 
          END IF
          EXIT FOREACH
       END FOREACH
    END FOREACH
   #TQC-A10007 add
END FUNCTION
#NO.FUN-570113  END----
 
FUNCTION p200_del_bhd()
 DEFINE l_bgk02 LIKE bgk_file.bgk02
 DEFINE l_bgk03 LIKE bgk_file.bgk03
 
   LET g_sql= " SELECT bgk02,bgk03 FROM bgk_file ",
              "  WHERE bgk01 = '",g_bgq01,"'",
              "    AND ",g_wc CLIPPED
   PREPARE pre_del FROM g_sql
   DECLARE del_cs CURSOR FOR pre_del
   FOREACH del_cs INTO l_bgk02,l_bgk03
      DELETE FROM bhd_file
       WHERE bhd01 = g_bgq01
         AND bhd02 = g_bgq02
         AND bhd04 = l_bgk02
         AND bhd05 = l_bgk03
      IF SQLCA.sqlcode THEN
#        CALL cl_err('DELETE bhd_file:',SQLCA.sqlcode,0) #FUN-660105
         CALL cl_err3("del","bhd_file",g_bgq01,g_bgq02,SQLCA.sqlcode,"","DELETE bhd_file:",0) #FUN-660105
         LET g_success='N' EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION p200_p()
DEFINE sr       RECORD
                bhd01 LIKE bhd_file.bhd01,
                bhd02 LIKE bhd_file.bhd02,
                bhd03 LIKE bhd_file.bhd03,
                bhd04 LIKE bhd_file.bhd04,
                bhd08 LIKE bhd_file.bhd08,
                bhd07 LIKE bhd_file.bhd07,
                bhd09 LIKE bhd_file.bhd09
                END RECORD,
       l_wc     LIKE type_file.chr1000,  #No.FUN-680061 VARCHAR(400)
       l_bgq    RECORD LIKE bgq_file.*,
       l_bgq07  LIKE bgq_file.bgq07
DEFINE i,j     LIKE type_file.num5       #No.FUN-680061 SMALLINT
       LET l_wc = g_wc
       LET i = length(l_wc)
       FOR j = 1 TO i
           IF l_wc[j,j+4]= 'bgk02' THEN LET l_wc[j,j+4] = 'bhd04' END IF
       END FOR
 
       LET g_sql = "SELECT bhd01,bhd02,bhd03,bhd04,bhd08,bhd07,SUM(bhd09)",
                   "  FROM bhd_file ",
                   " WHERE bhd01 = '",g_bgq01,"'",
                   "   AND bhd02 = '",g_bgq02,"'",
                   "   AND bhd05 != '@@@@1' ",
                   "   AND bhd05 != '@@@@2' ",
                   "   AND bhd05 != '@@@@3' ",
                   "   AND bhd05 != '@@@@4' ",
                   "   AND bhd05 != '@@@@5' ",
                   "   AND bhd05 != '折舊' ",
                   "   AND ",l_wc CLIPPED,
                   " GROUP BY bhd01,bhd02,bhd03,bhd04,bhd08,bhd07 ",
                   " ORDER BY bhd01,bhd02,bhd03,bhd04,bhd08,bhd07 "
 
       PREPARE bgq_pre FROM g_sql
       DECLARE bgq_cs CURSOR FOR bgq_pre
       FOREACH bgq_cs INTO sr.*
           LET l_bgq.bgq01 = g_bgq01
           LET l_bgq.bgq02 = g_bgq02
           LET l_bgq.bgq03 = sr.bhd03
           LET l_bgq.bgq04 = sr.bhd07
           LET l_bgq.bgq05 = sr.bhd08
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
          #IF STATUS = -239 THEN #TQC-790102
           IF  cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790102
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

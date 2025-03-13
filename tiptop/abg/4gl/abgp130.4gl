# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: abgp130.4gl
# Descriptions...: 預算科目自動產生作業
# Date & Author..: 02/10/28 By qazzaq
# modi by yuening 031022
# Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4C0007 04/12/01 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: NO.FUN-640254 06/05/22 by Yiting 回復 top99 1.銷貨預算 2.採購預算 3.ALL
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Hellen 本原幣取位修改
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-730033 07/03/20 By Carrier 會計科目加帳套
# Modify.........: No.FUN-740029 07/04/10 By johnray 會計科目加帳套
# Modify.........: No.TQC-790108 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-840173 08/04/20 By rainy 執行出現錯誤訊息  ins bgq: 無法將 null 插入欄的 '欄-名稱' .
# Modify.........: No.MOD-840509 08/04/23 By douzh bgq_file新增欄位更新,一并調整程式 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B70166 11/07/19 By Polly 增加預算原因(bgq053)(可開窗挑選)必輸選項 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
       g_sql            string,  #No.FUN-580092 HCN
       g_wc,g_wc1,l_buf string,  #No.FUN-580092 HCN
       g_bgq01          LIKE bgg_file.bgg01,   # 版本
       g_bgq02          LIKE bgg_file.bgg02,   # 年度 #NO.FUN-680061 SMALLINT
       g_y              LIKE type_file.chr1,   # 所選擇的項目 #No.FUN-680061 VARCHAR(01)
       g_change_lang    LIKE type_file.chr1,   #No.FUN-570113 #No.FUN-680061 VARCHAR(01)
       ls_date          STRING,                #No.FUN-570113
       l_flag           LIKE type_file.chr1,   #No.FUN-570113 #No.FUN-680061 VARCHAR(01)
       g_start,g_end    LIKE cre_file.cre08    #NO.FUN-680061
       #p_row,p_col     LIKE type_file.num5    #NO.FUN-570113  #No.FUN-680061 SMALLINT
 
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730033
DEFINE g_flag           LIKE type_file.chr1   #No.FUN-730033
DEFINE l_sql,l_sql2     LIKE type_file.chr1000,#No.FUN-680061 VARCHAR(600)
       i                LIKE type_file.num5,   #No.FUN-680061 SMALLINT
#      l_azi04          LIKE azi_file.azi04,   #NO.CHI-6A0004
       l_rate           LIKE bga_file.bga05    #No.FUN-680061 DEC(9,4)
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_cnt            LIKE type_file.num5    #NO.FUN-680061 SMALLINT
DEFINE g_bgq053         LIKE bgq_file.bgq053   #預算項目 #No.MOD-B70166

MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0056
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570113 --start
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_bgq01 = ARG_VAL(1)
    LET g_bgq02 = ARG_VAL(2)
    LET g_y     = ARG_VAL(3)
    LET g_bgjob = ARG_VAL(4)
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
 
   SELECT * INTO g_aza.* FROM aza_file WHERE aza00='0'
 
#NO.FUN-570113 START---
#   LET p_row = 5 LET p_col = 10
#   OPEN WINDOW p130_w AT p_row,p_col WITH FORM "abg/42f/abgp130"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
 
#   CALL p130()
#   CLOSE WINDOW p130_w
   WHILE TRUE
      IF g_bgjob="N" THEN
         CALL p130()
         IF cl_sure(0,0) THEN
          CALL cl_wait()
          LET g_success="Y"
          BEGIN WORK
          CALL p130_p0()
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
             CLOSE WINDOW p130_w
             EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
       CLOSE WINDOW p130_w
    ELSE
       LET g_success="Y"
       BEGIN WORK
       CALL p130_p0()
       IF g_success="Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
#NO.FUN-570113 END-----------
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p130()
  DEFINE l_bhd  RECORD LIKE bhd_file.*,
         l_bgm03   LIKE bgm_file.bgm03,
         l_bgm015  LIKE bgm_file.bgm015,
         l_bgm016  LIKE bgm_file.bgm016,
         l_bgm04   LIKE bgm_file.bgm04,
         l_bgm05   LIKE bgm_file.bgm05,
         l_bga05   LIKE bga_file.bga05,
         l_bgn03   LIKE bgn_file.bgn03,
         l_bgn012  LIKE bgn_file.bgn012,
         l_bgn04   LIKE bgn_file.bgn04,
         l_bgn05   LIKE bgn_file.bgn05,
         l_bgn06   LIKE bgn_file.bgn06,
         l_bgn07   LIKE bgn_file.bgn07,
         l_bgn08   LIKE bgn_file.bgn08,
         l_bgp03   LIKE bgp_file.bgp03,
         l_bgp07   LIKE bgp_file.bgp07,
         l_bgq07   LIKE bgq_file.bgq07,
         l_r       LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
  DEFINE lc_cmd    LIKE zz_file.zz08       #No.FUN-680061 VARCHAR(500)
  DEFINE p_row,p_col LIKE type_file.num5   #No.FUN-570113 #No.FUN-680061 SMALLINT
  #No.FUN-570113 --start--
   LET p_row=5
   LET p_col=25
 
   OPEN WINDOW p130_w AT p_row,p_col WITH FORM "abg/42f/abgp130"
   ATTRIBUTE(STYLE=g_win_style)
 
   CALL cl_ui_init()
  # No.FUN-570113 --end--
 
    CLEAR FORM
    CALL cl_opmsg('a')
    LET g_y='1'
    LET g_bgq02 = YEAR(g_today)
    DISPLAY g_y,g_bgq02 TO y,bgq02
    LET g_bgjob = "N"                            #No.FUN-570113
    DISPLAY g_y,g_bgq02,g_bgjob TO y,bgq02,g_bgjob #No.FUN-570113
    WHILE TRUE                                   #No.FUN-570113
      #INPUT g_bgq01,g_bgq02,g_y WITHOUT DEFAULTS FROM bgq01,bgq02,y HELP 1

  #---No.MOD-B70166---------------------------------------start
      #INPUT g_bgq01,g_bgq02,g_y,g_bgjob WITHOUT DEFAULTS    #No.FUN-570113
      #  FROM bgq01,bgq02,y,g_bgjob HELP 1         #No.FUN-570113
       INPUT g_bgq01,g_bgq02,g_y,g_bgq053,g_bgjob WITHOUT DEFAULTS    #No.FUN-570113
         FROM bgq01,bgq02,y,bgq053,g_bgjob HELP 1         #No.FUN-570113
 
       AFTER FIELD bgq053
           IF NOT cl_null(g_bgq053) THEN
              CALL i130_bgq053('a',g_bgq053)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD bgq053
              END IF
           ELSE
              LET g_bgq053 = " "
           END IF
   #---No.MOD-B70166---------------------------------------end

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
 
    #No.MOD-B70166--------------------------------------add
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bgq053)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_azf01a"      #FUN-920186
                   LET g_qryparam.default1 = g_bgq053
                   LET g_qryparam.arg1  = '7'           #FUN-950077
                   CALL cl_create_qry() RETURNING g_bgq053
                   DISPLAY g_qryparam.multiret TO bgq053 
                   NEXT FIELD bgq053
           END CASE
    #No.MOD-B70166--------------------------------------end


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
       CLOSE WINDOW p130_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
 
#    #DROP TABLE abgp130_tmp
#    #CREATE TEMP TABLE abgp130_tmp
#    #       (month    SMALLINT,   #月份
# Prog. Version..: '5.30.06-13.03.12(06),   #部門
# Prog. Version..: '5.30.06-13.03.12(06),   #類別
#            accno    VARCHAR(24),   #會計科目
#            amt      DEC(20,6)); #金額   #No.FUN-4C0007
#    #-----------------
#    BEGIN WORK
#    LET g_success = 'Y'
#    #產生銷貨預算
#    IF g_y = '1' THEN
#       DELETE FROM bhd_file
#        WHERE bhd01=g_bgq01 AND bhd02=g_bgq02
#          AND (bhd05='@@@@1' OR bhd05='@@@@2')
#       CALL p130_p1() #應收帳款
#       CALL p130_p2() #銷貨收入
#       CALL p130_p3() #銷貨成本
#    END IF
#    #產生採購預算
#    IF g_y = '2' THEN
#       DELETE FROM bhd_file
#        WHERE bhd01=g_bgq01 AND bhd02=g_bgq02
#          AND bhd05='@@@@4'
#       CALL p130_p4() #應付帳款/存貨科目
#    END IF
#    CALL p130_ins_bhd()
#    CALL p130_p()
#    IF g_success = 'Y' THEN
#       COMMIT WORK
#    ELSE
#       ROLLBACK WORK
#       RETURN
#    END IF
#    MESSAGE ' '
#    CALL cl_end(18,20)
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
            WHERE zz01="abgp130"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abgp130','9031',1)  
         ELSE
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",g_bgq01 CLIPPED,"'",
                       " '",g_bgq02 CLIPPED,"'",
                       " '",g_y     CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abgp130',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p130_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
#No.FUN-570113 --end--
END FUNCTION
 
#No.FUN-570113 --start--
FUNCTION p130_p0()
    #No.FUN-730033  --Begin
    CALL s_get_bookno(g_bgq02) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_bgq02,'aoo-081',1)
       RETURN
    END IF
    #No.FUN-730033  --End  
    DROP TABLE abgp130_tmp
    CREATE TEMP TABLE abgp130_tmp(
            month    LIKE type_file.num5,   
            dep      LIKE aab_file.aab02,
            type     LIKE aab_file.aab02,
            accno    LIKE aab_file.aab01,
            amt      LIKE type_file.num20_6)
    #產生銷貨預算
    #IF g_y = '1' THEN
    IF g_y = '1' OR g_y = '3' THEN   #NO.FUN-640254
       DELETE FROM bhd_file
        WHERE bhd01=g_bgq01 AND bhd02=g_bgq02
          AND (bhd05='@@@@1' OR bhd05='@@@@2')
       CALL p130_p1() #應收帳款
       CALL p130_p2() #銷貨收入
       CALL p130_p3() #銷貨成本
    END IF
    #產生採購預算
    #IF g_y = '2' THEN
    IF g_y = '2' OR g_y = '3' THEN   #NO.FUN-640254
       DELETE FROM bhd_file
        WHERE bhd01=g_bgq01 AND bhd02=g_bgq02
          AND bhd05='@@@@4'
       CALL p130_p4() #應付帳款/存貨科目
    END IF
    CALL p130_ins_bhd()
    CALL p130_p()
END FUNCTION 
#NO.FUN-570113 END---------
 
FUNCTION p130_p()
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
 
       LET g_sql = " SELECT bhd01,bhd02,bhd03,bhd04,bhd05,bhd07,SUM(bhd09)",
                   "   FROM bhd_file ",
                   "  WHERE bhd01 = '",g_bgq01,"'",
                   "    AND bhd02 = '",g_bgq02,"'"
       IF g_y = '1'  THEN
          LET g_sql = g_sql CLIPPED," AND (bhd05 = '@@@@1' OR bhd05 = '@@@@2')"
       END IF
       IF g_y = '2' THEN
          LET g_sql = g_sql CLIPPED," AND bhd05 = '@@@@4' "
       END IF
       LET g_sql = g_sql CLIPPED,
                   " GROUP BY bhd01,bhd02,bhd03,bhd04,bhd05,bhd07 ",
                   " ORDER BY bhd01,bhd02,bhd03,bhd04,bhd05,bhd07 "
       PREPARE bgq_pre FROM g_sql
       DECLARE bgq_cs CURSOR FOR bgq_pre
       FOREACH bgq_cs INTO sr.*
           LET l_bgq.bgq01 = g_bgq01
           LET l_bgq.bgq02 = g_bgq02
           LET l_bgq.bgq053 = g_bgq053                     #No.MOD-B70166 add
           LET l_bgq.bgq03 = sr.bhd03
           LET l_bgq.bgq04 = sr.bhd07
           LET l_bgq.bgq05 = sr.bhd04
           LET l_bgq.bgq06 = sr.bhd09
           LET l_bgq.bgq061= 0
           LET l_bgq.bgq08 = 0
         #MOD-840173 begin
          IF cl_null(l_bgq.bgq051) THEN LET l_bgq.bgq051 = ' ' END IF
          IF cl_null(l_bgq.bgq052) THEN LET l_bgq.bgq052 = ' ' END IF
          IF cl_null(l_bgq.bgq053) THEN LET l_bgq.bgq053 = ' ' END IF
         #MOD-840173 end
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
              UPDATE bgq_file
                 SET bgq06 = l_bgq.bgq06,
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
                 LET g_success='N' EXIT FOREACH
              END IF
           ELSE
              IF STATUS THEN
                 CALL cl_err('ins bgq:',STATUS,1) LET g_success='N' EXIT FOREACH
              END IF
           END IF
       END FOREACH
END FUNCTION
 
FUNCTION p130_p1() #應收帳款
DEFINE l_bgm03     LIKE bgm_file.bgm03,
       l_bgm015    LIKE bgm_file.bgm015,
       l_bgm014    LIKE bgm_file.bgm014,
       l_bgm016    LIKE bgm_file.bgm016,
       l_amt       LIKE type_file.num20_6,#NO.FUN-680061 DEC(20,6) 
       l_bgm014_o  LIKE bgm_file.bgm014,
       l_aag01     LIKE aag_file.aag01, #科目
       l_aag05     LIKE aag_file.aag05  #部門管理否
 
    LET l_bgm014_o='' LET l_bgm014=''
    DECLARE p130_cur_1 CURSOR FOR
        SELECT bgm03,bgm015,bgm014,bgm016,SUM(bgm04*bgm05)
          FROM bgm_file
         WHERE bgm01=g_bgq01 AND bgm02=g_bgq02
         GROUP BY bgm03,bgm015,bgm014,bgm016
         ORDER BY bgm014
    FOREACH p130_cur_1 INTO l_bgm03,l_bgm015,l_bgm014,l_bgm016,l_amt
        #應收帳款會計科目/部門管理否
        IF cl_null(l_bgm014_o) OR (l_bgm014_o<>l_bgm014) THEN
           CALL p130_get_acc1(l_bgm014) RETURNING l_aag01
           SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_aag01
#                                      AND aag00 = g_bookno1  #No.FUN-730033
                                      AND aag00 = g_aza.aza81 #No.FUN-740029
        END IF
        IF cl_null(l_aag01) THEN LET l_bgm014_o=l_bgm014 CONTINUE FOREACH END IF
#       LET l_azi04=0    #NO.CHI-6A0004
        LET t_azi04=0    #NO.CHI-6A0004
        LET l_rate=1
        #幣別取位
#       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_bgm016   #NO.CHI-6A0004
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_bgm016   #NO.CHI-6A0004
#       IF cl_null(l_azi04) THEN LET l_azi04=0 END IF                  #NO.CHI-6A0004
        IF cl_null(t_azi04) THEN LET t_azi04=0 END IF                  #NO.CHI-6A0004
        #匯率
        CALL s_bga05(g_bgq01, g_bgq02,l_bgm03,l_bgm016)
        RETURNING l_rate
        LET l_amt=l_amt*l_rate
#       LET l_amt=cl_digcut(l_amt,l_azi04)      #NO.CHI-6A0004
        LET l_amt=cl_digcut(l_amt,t_azi04)      #NO.CHI-6A0004
        IF l_aag05='Y' THEN
           INSERT INTO abgp130_tmp VALUES
                  (l_bgm03,l_bgm015,'@@@@1',l_aag01,l_amt)
        ELSE
           INSERT INTO abgp130_tmp VALUES
                  (l_bgm03,'ALL','@@@@1',l_aag01,l_amt)
        END IF
        LET l_bgm014_o=l_bgm014
    END FOREACH
END FUNCTION
 
FUNCTION p130_get_acc1(l_occ01) #應收帳款
 
DEFINE l_aag01      LIKE aag_file.aag01,
       l_occ01      LIKE occ_file.occ01
 
    LET l_aag01=''
    SELECT bhe06 INTO l_aag01 FROM bhe_file
     WHERE bhe00='2' AND bhe01=l_occ01
    IF NOT STATUS AND NOT cl_null(l_aag01) THEN
       RETURN l_aag01
    END IF
    SELECT bhe06 INTO l_aag01 FROM bhe_file
     WHERE bhe00='2' AND bhe01='*'
    RETURN l_aag01
END FUNCTION
 
FUNCTION p130_p2() #銷貨收入
DEFINE l_bgm03     LIKE bgm_file.bgm03,
       l_bgm015    LIKE bgm_file.bgm015,
       l_bgm014    LIKE bgm_file.bgm014,
       l_bgm016    LIKE bgm_file.bgm016,
       l_amt       LIKE type_file.num20_6,#NO.FUN-680061 DEC(20,6)
       l_bgm014_o  LIKE bgm_file.bgm014,
       l_aag01     LIKE aag_file.aag01, #科目
       l_aag05     LIKE aag_file.aag05  #部門管理否
 
    LET l_bgm014_o='' LET l_bgm014=''
    DECLARE p130_cur_2 CURSOR FOR
        SELECT bgm03,bgm015,bgm014,bgm016,SUM(bgm04*bgm05)
          FROM bgm_file
         WHERE bgm01=g_bgq01
           AND bgm02=g_bgq02
         GROUP BY bgm03,bgm015,bgm014,bgm016
         ORDER BY bgm014
    FOREACH p130_cur_2 INTO l_bgm03,l_bgm015,l_bgm014,l_bgm016,l_amt
        #銷貨收入會計科目/部門管理否
        IF cl_null(l_bgm014_o) OR (l_bgm014_o<>l_bgm014) THEN
           LET l_aag01=''
           CALL p130_get_acc2(l_bgm014) RETURNING l_aag01
           IF cl_null(l_aag01) THEN LET l_aag01=g_bgz.bgz10 END IF
           SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_aag01
#                                      AND aag00 = g_bookno1  #No.FUN-730033
                                      AND aag00 = g_aza.aza81 #No.FUN-740029
        END IF
        IF cl_null(l_aag01) THEN LET l_bgm014_o=l_bgm014 CONTINUE FOREACH END IF
#       LET l_azi04=0 LET l_rate=1                                      #NO.CHI-6A0004
        LET t_azi04=0 LET l_rate=1                                      #NO.CHI-6A0004
        #幣別取位
#       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_bgm016    #NO.CHI-6A0004
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_bgm016    #NO.CHI-6A0004
#       IF cl_null(l_azi04) THEN LET l_azi04=0 END IF                   #NO.CHI-6A0004
        IF cl_null(t_azi04) THEN LET t_azi04=0 END IF                   #NO.CHI-6A0004
        #匯率
        CALL s_bga05(g_bgq01, g_bgq02,l_bgm03,l_bgm016)
        RETURNING l_rate
        LET l_amt=l_amt*l_rate
#       LET l_amt=cl_digcut(l_amt,l_azi04)                              #NO.CHI-6A0004
        LET l_amt=cl_digcut(l_amt,t_azi04)                              #NO.CHI-6A0004
        IF l_aag05='Y' THEN
           INSERT INTO abgp130_tmp VALUES
                  (l_bgm03,l_bgm015,'@@@@1',l_aag01,l_amt)
        ELSE
           INSERT INTO abgp130_tmp VALUES
                  (l_bgm03,'ALL','@@@@1',l_aag01,l_amt)
        END IF
        LET l_bgm014_o=l_bgm014
    END FOREACH
 
END FUNCTION
 
FUNCTION p130_get_acc2(l_occ01) #銷貨收入
DEFINE l_aag01      LIKE aag_file.aag01,
       l_occ01      LIKE occ_file.occ01
 
    LET l_aag01=''
    SELECT bhe02 INTO l_aag01 FROM bhe_file
     WHERE bhe00='2' AND bhe01=l_occ01
    IF NOT STATUS AND NOT cl_null(l_aag01) THEN
       RETURN l_aag01
    END IF
    SELECT bhe02 INTO l_aag01 FROM bhe_file
     WHERE bhe00='2' AND bhe01='*'
    RETURN l_aag01
END FUNCTION
 
FUNCTION p130_p3() #銷貨成本
DEFINE l_bgm03     LIKE bgm_file.bgm03,
       l_bgm015    LIKE bgm_file.bgm015,
       l_bgm017    LIKE bgm_file.bgm017,
       l_bgm016    LIKE bgm_file.bgm016,
       l_amt       LIKE type_file.num20_6,#NO.FUN-680061 DEC(20,6)
       l_bgm017_o  LIKE bgm_file.bgm017,
       l_aag01     LIKE aag_file.aag01, #科目
       l_aag05     LIKE aag_file.aag05  #部門管理否
 
    LET l_bgm017_o='' LET l_bgm017=''
    DECLARE p130_cur_3 CURSOR FOR
        SELECT bgm03,bgm015,bgm017,bgm016,SUM(bgm04*(bgn05+bgn06+bgn07+bgn08))
          FROM bgm_file,bgn_file
         WHERE bgm01=bgn01 AND bgm015=bgn012
           AND bgm017=bgn013 AND bgn014=bgm017
           AND bgm02=bgn02 AND bgm03=bgn03
           AND bgm01=g_bgq01 AND bgm02=g_bgq02
         GROUP BY bgm03,bgm015,bgm017,bgm016
         ORDER BY bgm017
    FOREACH p130_cur_3 INTO l_bgm03,l_bgm015,l_bgm017,l_bgm016,l_amt
        #銷貨成本會計科目/部門管理否
        IF cl_null(l_bgm017_o) OR (l_bgm017_o<>l_bgm017) THEN
           CALL p130_get_acc3(l_bgm017) RETURNING l_aag01
           IF cl_null(l_aag01) THEN LET l_aag01=g_bgz.bgz11 END IF
           SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_aag01
#                                      AND aag00 = g_bookno1  #No.FUN-730033
                                      AND aag00 = g_aza.aza81 #No.FUN-740029
        END IF
        IF cl_null(l_aag01) THEN LET l_bgm017_o=l_bgm017 CONTINUE FOREACH END IF
#       LET l_azi04=0 LET l_rate=1                                      #NO.CHI-6A0004
        LET t_azi04=0 LET l_rate=1                                      #NO.CHI-6A0004
        #幣別取位
#       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_bgm016    #NO.CHI-6A0004
        SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_bgm016    #NO.CHI-6A0004
#       IF cl_null(l_azi04) THEN LET l_azi04=0 END IF                   #NO.CHI-6A0004
        IF cl_null(t_azi04) THEN LET t_azi04=0 END IF                   #NO.CHI-6A0004
        #匯率
        CALL s_bga05(g_bgq01, g_bgq02,l_bgm03,l_bgm016)
        RETURNING l_rate
        LET l_amt=l_amt*l_rate
#       LET l_amt=cl_digcut(l_amt,l_azi04)                              #NO.CHI-6A0004
        LET l_amt=cl_digcut(l_amt,t_azi04)                              #NO.CHI-6A0004
        IF l_aag05='Y' THEN
           INSERT INTO abgp130_tmp VALUES
                  (l_bgm03,l_bgm015,'@@@@2',l_aag01,l_amt)
        ELSE
           INSERT INTO abgp130_tmp VALUES
                  (l_bgm03,'ALL','@@@@2',l_aag01,l_amt)
        END IF
        LET l_bgm017_o=l_bgm017
    END FOREACH
END FUNCTION
 
FUNCTION p130_get_acc3(l_bgm017) #銷貨成本
DEFINE l_aag01      LIKE aag_file.aag01,
       l_bgm017     LIKE bgm_file.bgm017
 
    LET l_aag01=''
    SELECT bhe03 INTO l_aag01 FROM bhe_file
     WHERE bhe00='1' AND bhe01=l_bgm017
    IF NOT STATUS AND NOT cl_null(l_aag01) THEN
       RETURN l_aag01
    END IF
    SELECT bhe03 INTO l_aag01 FROM bhe_file
     WHERE bhe00='1' AND bhe01='*'
    RETURN l_aag01
END FUNCTION
 
FUNCTION p130_p4() #應付帳款/存貨科目
DEFINE l_bgp03       LIKE bgp_file.bgp03,
       l_amt         LIKE type_file.num20_6, #NO.FUN-680061 DEC(20,6)   
       l_aag01_1     LIKE aag_file.aag01, #應付科目
       l_aag05_1     LIKE aag_file.aag05, #部門管理否
       l_aag01_2     LIKE aag_file.aag01, #存貨科目
       l_aag05_2     LIKE aag_file.aag05  #部門管理否
 
    #應付帳款會計科目/部門管理否
    LET l_aag01_1=g_bgz.bgz36
    SELECT aag05 INTO l_aag05_1 FROM aag_file WHERE aag01=l_aag01
#                                 AND aag00 = g_bookno1  #No.FUN-730033
                                 AND aag00 = g_aza.aza81 #No.FUN-740029
    #存貨會計科目/部門管理否
    LET l_aag01_2=g_bgz.bgz13
    SELECT aag05 INTO l_aag05_2 FROM aag_file WHERE aag01=l_aag01
#                                 AND aag00 = g_bookno1  #No.FUN-730033
                                 AND aag00 = g_aza.aza81 #No.FUN-740029
    DECLARE p130_cur_4 CURSOR FOR
        SELECT bgp03,SUM(bgp07) FROM bgp_file
         WHERE bgp01=g_bgq01 AND bgp02=g_bgq02
         GROUP BY bgp03
    FOREACH p130_cur_4 INTO l_bgp03,l_amt   #期別/金額
        IF NOT cl_null(l_aag01_1) THEN
           IF l_aag05_1='Y' THEN
              INSERT INTO abgp130_tmp VALUES
                     (l_bgp03,'ALL','@@@@4',l_aag01_1,l_amt)
           ELSE
              INSERT INTO abgp130_tmp VALUES
                     (l_bgp03,'ALL','@@@@4',l_aag01_1,l_amt)
           END IF
        END IF
        IF NOT cl_null(l_aag01_2) THEN
           IF l_aag05_2='Y' THEN
              INSERT INTO abgp130_tmp VALUES
                     (l_bgp03,'ALL','@@@@4',l_aag01_2,l_amt)
           ELSE
              INSERT INTO abgp130_tmp VALUES
                     (l_bgp03,'ALL','@@@@4',l_aag01_2,l_amt)
           END IF
        END IF
    END FOREACH
END FUNCTION

#--------------------------------------No.MOD-B70166----------------------add
FUNCTION i130_bgq053(p_cmd,p_key)
DEFINE p_cmd     LIKE type_file.chr1,
p_key     LIKE bgq_file.bgq053,
l_azf03   LIKE azf_file.azf03,
l_azf09   LIKE azf_file.azf09,#FUN-920186
l_azfacti LIKE azf_file.azfacti
LET g_errno = " "
SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti
FROM azf_file WHERE azf01 = p_key AND azf02 = '2'
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-502'
                                  LET l_azf03 = ' '
        WHEN l_azfacti='N'        LET g_errno = '9028'
        WHEN l_azf09 != '7'       LET g_errno = 'aoo-406'      
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
  IF p_cmd != 'c' THEN
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY l_azf03 TO FORMONLY.azf03
     END IF
  END IF
END FUNCTION
#--------------------------------------No.MOD-B70166----------------------end
 
FUNCTION p130_ins_bhd()
   DEFINE l_name    LIKE type_file.chr20,      #No.FUN-680061 VARCHAR(20) # External(Disk) file name
          sr        RECORD
                        month    LIKE type_file.num5,   #NO.FUN-680061 SMALLINT
                        dep      LIKE gem_file.gem01,   #NO.FUN-680061 VARCHAR(6)
                        type     LIKE aab_file.aab02,   #NO.FUN-680061 VARCHAR(6)
                        accno    LIKE abi_file.abi05,   #NO.FUN-680061 VARCHAR(24)
                        amt      LIKE type_file.num20_6 #NO.FUN-680061 DEC(20,6)
                    END RECORD
 
    LET g_sql=" SELECT month,dep,type,accno,SUM(amt) FROM abgp130_tmp ",
              " GROUP BY month,dep,type,accno ",
              " ORDER BY month,dep,type,accno "
    PREPARE p130_prepare1 FROM g_sql
    IF SQLCA.sqlcode != 0 THEN
       CALL cl_err('prepare:',SQLCA.sqlcode,1) RETURN
    END IF
    DECLARE p130_tmp CURSOR FOR p130_prepare1
    CALL cl_outnam('abgp130') RETURNING l_name
    START REPORT p130_rep TO l_name
    FOREACH p130_tmp INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('tmp cs:',SQLCA.sqlcode,1) EXIT FOREACH
        END IF
        OUTPUT TO REPORT p130_rep(sr.*)
    END FOREACH
    FINISH REPORT p130_rep
END FUNCTION
 
REPORT p130_rep(sr)
  DEFINE sr        RECORD
                       month    LIKE type_file.num5,   #NO.FUN-680061 SMALLINT
                       dep      LIKE gem_file.gem01,   #NO.FUN-680061 VARCHAR(6)                                                                           
                       type     LIKE aab_file.aab02,   #NO.FUN-680061 VARCHAR(6)                                                                            
                       accno    LIKE abi_file.abi05,   #NO.FUN-680061 VARCHAR(24)                                                                            
                       amt      LIKE type_file.num20_6 #NO.FUN-680061 DEC(20,6)
                   END RECORD
  DEFINE l_cnt     LIKE type_file.num5   #No.FUN-680061 SMALLINT
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.month,sr.dep,sr.type
  FORMAT
 
   BEFORE GROUP OF sr.type
      LET l_cnt=1
 
   ON EVERY ROW
      INSERT INTO bhd_file(bhd01,bhd02,bhd03,bhd04,bhd05,bhd06,bhd07,bhd08,bhd09)  #No:BUG47-0041
           VALUES (g_bgq01,g_bgq02,sr.month,sr.dep,sr.type,l_cnt,sr.accno,'',sr.amt)
      LET l_cnt=l_cnt+1
 
END REPORT
#Patch....NO.TQC-610035 <001> #

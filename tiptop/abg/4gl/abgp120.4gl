# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Pattern name...: abgp120.4gl
# Descriptions...: 生產成本試算作業
# Date & Author..: 02/10/17 By nicola
# Modi...........: ching  031104 No.8563
# Modify.........: No.FUN-4C0007 04/12/01 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570113 06/02/27 By yiting 加入背景作業功能
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl 欄位型態定義,改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-760066 07/06/21 By chenl  s_umfchk時，重抓ima55.  
# Modify.........: No.TQC-790108 07/09/14 By Melody 修正Primary Key後, 程式判斷錯誤訊息時必須改變做法
# Modify.........: No.MOD-970136 09/07/15 By xiaofeizhu 修改抓bgc08,bgc07處的判斷
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70078 10/07/09 By Dido 抓取製造與加工單價調整 
# Modify.........: No.FUN-910088 11/12/30 By chenjing 增加數量欄位小數取位
# Modify.........: No.MOD-D10178 13/02/05 By Polly abgi003不需每個月份都要維護，但abgi110有的月份，就一定有資料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
   g_bgm         RECORD   LIKE bgm_file.*,
   g_bgn         RECORD   LIKE bgn_file.*,
   g_bgh         RECORD
      bgh02       LIKE bgh_file.bgh02,   #主件料號
      ima55       LIKE ima_file.ima55,   #主件生產單位
      bgh04       LIKE bgh_file.bgh04,   #元件料號
      bgh11       LIKE bgh_file.bgh11,   #元件發料單位
      bgh06       LIKE bgh_file.bgh06,   #用量
      bgh07       LIKE bgh_file.bgh07,   #底數
      bgh08       LIKE bgh_file.bgh08    #損耗率
              END RECORD,
   g_sql          string,  #No.FUN-580092 HCN
   g_wc,g_wc1     string,  #No.FUN-580092 HCN
   g_bgn01        LIKE bgn_file.bgn01,   # 版本
   g_bgn01a       LIKE bgn_file.bgn01,
   g_bgn02        LIKE bgn_file.bgn02,   # 年度
   g_bgc04        LIKE bgc_file.bgc04,   # 幣別  #MOD-D10178 add
   g_change_lang  LIKE type_file.chr1,   #No.FUN-570113 #No.FUN-680061 VARCHAR(01)
   ls_date        STRING,                #No.FUN-570113
   l_flag         LIKE type_file.chr1    #No.FUN-570113 #No.FUN-680061 VARCHAR(01) 
#  p_row,p_col    LIKE type_file.num5    #No.FUN-570113 #No.FUN-680061 SMALLINT
 
DEFINE g_i        LIKE type_file.num5    #count/index for any purpose #No.FUN-680061
DEFINE g_cnt      LIKE type_file.num5    #NO.FUN-680061 SMALLINT
MAIN
#     DEFINE   l_time LIKE type_file.chr8      #No.FUN-6A0056
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570113 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgn01 = ARG_VAL(1)
   LET g_bgn02 = ARG_VAL(2)
   LET g_bgc04 = ARG_VAL(3)  #MOD-D10178 add
   LET g_bgjob = ARG_VAL(4)  #MOD-D10178 3 mod 4
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
#      LET p_row = 5 LET p_col = 15
#   OPEN WINDOW p120_w AT p_row,p_col WITH FORM "abg/42f/abgp120"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#   CALL p120_i()
#   CLOSE WINDOW p120_w
   WHILE TRUE
     IF g_bgjob="N" THEN
        CALL p120_i()
        IF cl_sure(0,0) THEN
           CALL cl_wait()
           LET g_success="Y"
           BEGIN WORK
           CALL p120_up()
           MESSAGE 'co1 ca1-->'
           CALL p120_co1()
           MESSAGE 'co1 ca1-->'
           CALL p120_co2()
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_cmmsg(0)
              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
              CALL s_showmsg()                           #NO.MOD-970136
           ELSE
              ROLLBACK WORK
              CALL cl_rbmsg(0)
              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
              CALL s_showmsg()                           #NO.MOD-970136
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p120_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p120_w
     ELSE
        LET g_success="Y"
        BEGIN WORK
        CALL p120_up()
        CALL p120_co1()
        CALL p120_co2()
        IF g_success="Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE
#NO.FUN-570113 END----
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p120_i()
   DEFINE   lc_cmd      LIKE type_file.chr1000#NO.FUN-680061 VARCHAR(500)
   DEFINE   p_row,p_col LIKE type_file.num5   #No.FUN-570113 #No.FUN-680061 SMALLINT
   #No.FUN-570113 --start--
    LET p_row=5
    LET p_col=25
 
    OPEN WINDOW p120_w AT p_row,p_col WITH FORM "abg/42f/abgp120"
    ATTRIBUTE(STYLE=g_win_style)
 
    CALL cl_ui_init()
   # No.FUN-570113 --end--
 
   CLEAR FORM
   CALL cl_opmsg('a')
   LET g_bgn02 = YEAR(g_today)
   LET g_bgjob = "N"                            #No.FUN-570113
   WHILE TRUE                                   #No.FUN-570113
 
  #INPUT g_bgn01,g_bgn02 WITHOUT DEFAULTS FROM bgn01,bgn02
  #INPUT g_bgn01,g_bgn02,g_bgjob WITHOUT DEFAULTS FROM bgn01,bgn02,g_bgjob  #NO.FUN-570113 #MOD-D10178 mark
   INPUT g_bgn01,g_bgn02,g_bgc04,g_bgjob WITHOUT DEFAULTS FROM bgn01,bgn02,bgc04,g_bgjob   #MOD-D10178 add
 
      AFTER FIELD bgn01
         IF g_bgz.bgz02 = 'Y' THEN
            IF cl_null(g_bgn01) THEN
               NEXT FIELD bgn01
            END IF
         END IF
         IF cl_null(g_bgn01) THEN LET g_bgn01 = ' ' END IF
 
      AFTER FIELD bgn02
         IF cl_null(g_bgn02) THEN NEXT FIELD bgn02 END IF
 
      AFTER FIELD bgc04                                       #MOD-D10178 add
         IF cl_null(g_bgc04) THEN NEXT FIELD bgc04 END IF     #MOD-D10178 add

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
       CLOSE WINDOW p120_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
    END IF
 
   #IF NOT cl_sure(18,20) THEN RETURN END IF
   #CALL cl_wait()
 
   #IF g_bgz.bgz02='N' THEN
   #   LET g_bgn01a=' '
   #ELSE
   #   LET g_bgn01a=g_bgn01
   #END IF
 
   #LET g_success ='Y'
   #BEGIN WORK
   #CALL p120_up()          #更新bgn金額為0
   #MESSAGE 'co1 cal-->'
   #CALL p120_co1()         #計算材料單價
   #MESSAGE 'co2 cal-->'
   #CALL p120_co2()         #計算人工/製費/加工單價
   #IF g_success = 'Y' THEN
   #   CALL cl_cmmsg(0) COMMIT WORK
   #ELSE
   #   CALL cl_rbmsg(0) ROLLBACK WORK
   #END IF
   #MESSAGE ' '
   #CALL cl_end(18,20)
    IF g_bgjob="Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01="abgp120"
       IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
          CALL cl_err('abgp120','9031',1) 
       ELSE
          LET lc_cmd=lc_cmd CLIPPED,
                     " '",g_bgn01 CLIPPED,"'",
                     " '",g_bgn02 CLIPPED,"'",
                     " '",g_bgc04 CLIPPED,"'",        #MOD-D10178 add
                     " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('abgp120',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p120_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
       EXIT PROGRAM
     END IF
     EXIT WHILE
END WHILE
#No.FUN-570113 --end--
END FUNCTION
 
FUNCTION p120_up()
#FUN-570113 --start--
   IF g_bgz.bgz02='N' THEN
      LET g_bgn01a=' '
   ELSE
      LET g_bgn01a=g_bgn01
   END IF
#FUN-570113 ---end---
 
   SELECT COUNT(*) INTO g_cnt FROM bgn_file
     WHERE bgn01=g_bgn01 AND bgn02=g_bgn02
   UPDATE bgn_file SET bgn05=0,bgn06=0,
                       bgn07=0,bgn08=0
    WHERE bgn01=g_bgn01 AND bgn02=g_bgn02
   IF STATUS OR sqlca.sqlerrd[3]<>g_cnt THEN
#     CALL cl_err('UPDATE bgn',STATUS,1) #FUN-660105
      CALL cl_err3("upd","bgn_file",g_bgn01,g_bgn02,STATUS,"","UPDATE bgn",1) #FUN-660105 
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION p120_co1()
   DEFINE l_tmp        RECORD                 #程式變數(舊值)
             bgh02       LIKE bgh_file.bgh02,   #主件料號
             ima55       LIKE ima_file.ima55,   #主件生產單位
             bgn03       LIKE bgn_file.bgn03,   #月份
             bgn05       LIKE bgn_file.bgn05    #材料單價
                    END RECORD
   DEFINE l_ima01  LIKE ima_file.ima01
   DEFINE l_bgn05  LIKE bgn_file.bgn05
   DEFINE l_bgc07  LIKE bgc_file.bgc07
   DEFINE l_bgc08  LIKE bgc_file.bgc08
   DEFINE l_bgn03  LIKE bgn_file.bgn03   #NO.FUN-680061 SMALLINT
   DEFINE l_fac    LIKE pml_file.pml09   #NO.FUN-680061 DEC(16,8)
   DEFINE l_sql    STRING                  #MOD-D10178 add
   DEFINE l_cnt    LIKE type_file.num5     #MOD-D10178 add
   DEFINE l_cnt1   LIKE type_file.num5     #MOD-D10178 add
   DEFINE l_bgn01  LIKE bgn_file.bgn01     #MOD-D10178 add
   DEFINE l_bgn02  LIKE bgn_file.bgn02     #MOD-D10178 add
   DEFINE l_bgn11  LIKE bgn_file.bgn11     #MOD-D10178 add
   DEFINE l_bgn014  LIKE bgn_file.bgn014   #MOD-D10178 add
 
   #No.FUN-680061  --Begin
   DROP TABLE p120_tmp
   CREATE TEMP TABLE p120_tmp(
         bgh02 LIKE bgh_file.bgh02,
         ima55 LIKE ima_file.ima55,
         bgh04 LIKE bgh_file.bgh04,
         bgh11 LIKE bgh_file.bgh11,
         bgn05 LIKE bgn_file.bgn05,
         bgn03 LIKE bgn_file.bgn03)
   #No.FUN-680061  --End
   DECLARE p120_co1_tmp CURSOR FOR
       SELECT bgh02,'',bgh04,bgh11,bgh06,bgh07,bgh08
         FROM bgg_file,bgh_file
        WHERE bgg01 = g_bgn01
          AND bgg01 = bgh01
          AND bgg02 = bgh02
        ORDER BY bgh02
        
   CALL s_showmsg_init()   #No.MOD-970136        
  #------------------------------------MOD-D10178------------------------------(S)
   LET l_sql = "SELECT bgn01,bgn02,bgn03,bgn014,bgn11 ",
               "  FROM bgn_file ",
               " WHERE bgn01 = '",g_bgn01a,"' ",
               "   AND bgn02 = '",g_bgn02,"' ",
               "   AND bgn014 = ? ",
               " ORDER BY bgn11 "
   PREPARE get_bgn_p1 FROM l_sql
   DECLARE get_bgn_c1 CURSOR FOR get_bgn_p1
  #------------------------------------MOD-D10178------------------------------(E)
        
   FOREACH p120_co1_tmp INTO g_bgh.*
      IF STATUS THEN
         CALL cl_err('co1_tmp',STATUS,1) LET g_success='N' EXIT FOREACH
      END IF
      LET l_ima01=''
      SELECT ima01 INTO l_ima01 FROM ima_file
       WHERE ima01=g_bgh.bgh02
      IF cl_null(l_ima01) THEN
         SELECT bgg06 INTO l_ima01 FROM bgg_file
          WHERE bgg01=g_bgn01
            AND bgg02=g_bgh.bgh02
         IF cl_null(l_ima01) THEN
            CALL cl_err('sel bgg06',STATUS,1) 
            LET g_success='N' EXIT FOREACH
         END IF
      END IF
      SELECT ima55 INTO g_bgh.ima55 FROM ima_file
       WHERE ima01=l_ima01
      IF cl_null(g_bgh.ima55) THEN
         CALL cl_err('sel ima55',STATUS,1) 
         LET g_success='N' EXIT FOREACH
      END IF
     #------------------------------------MOD-D10178------------------------------(S)
      LET l_cnt1 = 0
      FOREACH get_bgn_c1 USING g_bgh.bgh04
         INTO l_bgn01,l_bgn02,l_bgn03,l_bgn014,l_bgn11
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM bgc_file
          WHERE bgc01 = l_bgn01
            AND bgc02 = l_bgn02
            AND bgc03 = l_bgn03
            AND bgc04 = g_bgc04
            AND bgc05 = g_bgh.bgh04
            AND bgc08 = l_bgn11
         IF l_cnt = 0 THEN
            LET l_cnt1 = l_cnt1 +1
            LET g_showmsg = l_bgn01,"/",l_bgn02,"/",l_bgn03,"/",g_bgh.bgh04
            CALL s_errmsg('bgn01,bgn02,bgn03,bgh04',g_showmsg,'','abg-988',1)
         END IF
      END FOREACH
      IF l_cnt1 > 0 THEN
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
     #------------------------------------MOD-D10178------------------------------(E)
      FOR l_bgn03=1 TO 12   
         LET l_bgn05=0
         LET l_bgc08=NULL                                                            #MOD-970136
         LET l_bgc07=NULL                                                            #MOD-970136         
         DECLARE get_bgc CURSOR FOR
           SELECT bgc08,bgc07 FROM bgc_file
            WHERE bgc01=g_bgn01a
              AND bgc02=g_bgn02
              AND bgc03=l_bgn03
              AND bgc05=g_bgh.bgh04
            ORDER BY bgc08
         FOREACH get_bgc INTO l_bgc08,l_bgc07
            IF STATUS THEN
               CALL cl_err('get bgc',STATUS,1) LET g_success='N' EXIT FOREACH
            END IF
         END FOREACH
        #------------------------------MOD-D10178----------------------mark
        #IF cl_null(l_bgc08) THEN
#       #   CALL cl_err('sel bgc08',STATUS,1) LET g_success='N' EXIT FOREACH          #MOD-970136 Mark
        #   LET g_showmsg=g_bgn01a,"/",g_bgn02,"/",g_bgh.bgh04                        #MOD-970136
        #   CALL s_errmsg('bgn01,bgn02,bgh04',g_showmsg,'','abg-988',1)               #MOD-970136
        #   CONTINUE FOREACH                                                          #MOD-970136            
        #END IF
         IF cl_null(l_bgc08) THEN CONTINUE FOR END IF                  #MOD-D10178 add
        #------------------------------MOD-D10178----------------------mark
         IF cl_null(l_bgc07) THEN LET l_bgc07 = 0 END IF
         CALL s_umfchk(g_bgh.bgh04,l_bgc08,g_bgh.bgh11) RETURNING g_i,l_fac
         IF g_i = 1 THEN
           #CALL cl_err(g_bgh.bgh04,'abm-731',1)                                 #MOD-D10178 mark 
            LET g_showmsg = l_bgn01,"/",l_bgn02,"/",l_bgn03,"/",l_bgc08          #MOD-D10178 add
            CALL s_errmsg('bgn01,bgn02,bgn03,bgc08',g_showmsg,'','abm-731',1)    #MOD-D10178 add
            LET l_fac = 1
         END IF
         LET l_bgn05=l_bgc07*(g_bgh.bgh06/g_bgh.bgh07)*(1+g_bgh.bgh08/100)
                     /l_fac
         INSERT INTO p120_tmp
            VALUES(g_bgh.bgh02,g_bgh.ima55,g_bgh.bgh04,g_bgh.bgh11,
                   l_bgn05,l_bgn03)
          IF STATUS THEN
#            CALL cl_err('ins bgc',STATUS,1) #FUN-660105
             CALL cl_err3("ins","p120_tmp","","",STATUS,"","ins bgc",1) #FUN-660105
             LET g_success='N' EXIT FOREACH
          END IF
      END FOR
   END FOREACH
 
   DECLARE p120_tmp_cs CURSOR FOR
     SELECT bgh02,ima55,bgn03,SUM(bgn05) FROM p120_tmp
      GROUP BY bgh02,ima55,bgn03
      ORDER BY bgh02,ima55,bgn03
   FOREACH p120_tmp_cs INTO l_tmp.*
      IF STATUS THEN
         CALL cl_err('p120_tmp_cs:',STATUS,1) LET g_success='N' EXIT FOREACH
      END IF
      DECLARE get_bgn_cs CURSOR FOR
        SELECT bgn_file.* FROM bgn_file
         WHERE bgn01  = g_bgn01
           AND bgn02  = g_bgn02
           AND bgn014 = l_tmp.bgh02
           AND bgn03  = l_tmp.bgn03
      FOREACH get_bgn_cs INTO g_bgn.*
        IF STATUS THEN
           CALL cl_err('bgn_cs',STATUS,1) LET g_success='N' EXIT FOREACH
        END IF
       #No.TQC-760066--begin--
        IF cl_null(l_tmp.ima55) THEN
           SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=g_bgn.bgn014
           IF cl_null(l_tmp.ima55) THEN
              CALL cl_err3('sel','ima_file',g_bgn.bgn014,'','mfg1325','','',1)
              LET g_success = 'N' 
              EXIT FOREACH 
           END IF
        END IF
       #No.TQC-760066--end--
        CALL s_umfchk(g_bgn.bgn014,l_tmp.ima55,g_bgn.bgn11) RETURNING g_i,l_fac
        IF g_i = 1 THEN
           CALL cl_err(g_bgn.bgn014,'abm-731',1) LET l_fac = 1
        END IF
        LET l_tmp.bgn05 =l_tmp.bgn05 / l_fac
    UPDATE bgn_file SET(bgn05)=(l_tmp.bgn05) WHERE bgn01 = g_bgn.bgn01  
	     AND bgn012= g_bgn.bgn012 
	     AND bgn013= g_bgn.bgn013 
	     AND bgn014= g_bgn.bgn014 
	     AND bgn02 = g_bgn.bgn02  
	     AND bgn11 = g_bgn.bgn11  
	     AND bgn11_fac = g_bgn.bgn11_fac  
	     AND bgn03 = g_bgn.bgn03
        IF STATUS THEN
           LET g_success='N' 
#          CALL cl_err('upd bgn5:',STATUS,1) #FUN-660105
           CALL cl_err3("upd","bgn_file",g_bgn01,g_bgn02,STATUS,"","upd bgn5:",1) #FUN-660105
           EXIT FOREACH
        END IF
      END FOREACH
      DECLARE get_bgm_cs CURSOR FOR
        SELECT bgm_file.* FROM bgm_file
         WHERE bgm01  = g_bgn01
           AND bgm02  = g_bgn02
           AND bgm017 = l_tmp.bgh02
           AND bgm03  = l_tmp.bgn03
      FOREACH get_bgm_cs INTO g_bgm.*
        IF STATUS THEN
           CALL cl_err('bgm_cs',STATUS,1) LET g_success='N' EXIT FOREACH
        END IF
       #No.TQC-760066--begin--
        IF cl_null(l_tmp.ima55) THEN
           SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=g_bgm.bgm017
           IF cl_null(l_tmp.ima55) THEN
              CALL cl_err3('sel','ima_file',g_bgm.bgm014,'','mfg1325','','',1)
              LET g_success = 'N' 
              EXIT FOREACH 
           END IF
        END IF
       #No.TQC-760066--end--
        CALL s_umfchk(g_bgm.bgm017,l_tmp.ima55,g_bgm.bgm08) RETURNING g_i,l_fac
        IF g_i = 1 THEN
           CALL cl_err(g_bgm.bgm017,'abm-731',1) LET l_fac = 1
        END IF
        LET l_tmp.bgn05=l_tmp.bgn05 / l_fac
    UPDATE bgm_file SET(bgm091)=(l_tmp.bgn05)       
           WHERE bgm01  = g_bgm.bgm01    
	     AND bgm012 = g_bgm.bgm012   
             AND bgm013 = g_bgm.bgm013   
             AND bgm014 = g_bgm.bgm014   
             AND bgm015 = g_bgm.bgm015   
             AND bgm016 = g_bgm.bgm016   
             AND bgm017 = g_bgm.bgm017   
             AND bgm08  = g_bgm.bgm08   
             AND bgm08_fac = g_bgm.bgm08_fac   
             AND bgm02  = g_bgm.bgm02   
             AND bgm03  = g_bgm.bgm03   
        IF STATUS THEN
           LET g_success='N' 
#          CALL cl_err('upd bgm091:',STATUS,1) #FUN-660105
           CALL cl_err3("upd","bgm_file",g_bgm.bgm01,g_bgm.bgm02,STATUS,"","upd bgm091",1) #FUN-660105
           EXIT FOREACH
        END IF
      END FOREACH
   END FOREACH
END FUNCTION
 
FUNCTION p120_co2()
 
DEFINE  l_tmp        RECORD
         bgn014      LIKE bgn_file.bgn014,  #主件料號
         ima55       LIKE ima_file.ima55,   #主件生產單位
         bgn04       LIKE bgn_file.bgn04,   #數量
         bgn06t      LIKE bgn_file.bgn06,   #分攤人工 #No.FUN-4C0007 #NO.FUN-680061 DEC(20,6)
         bgn07t      LIKE bgn_file.bgn07,   #分攤製費 #No.FUN-4C0007 #NO.FUN-680061 DEC(20,6)
         bgn08t      LIKE bgn_file.bgn08,   #分攤加工 #No.FUN-4C0007 #NO.FUN-680061 DEC(20,6)
         bgn06       LIKE bgn_file.bgn06,   #人工單價
         bgn07       LIKE bgn_file.bgn07,   #製費單價
         bgn08       LIKE bgn_file.bgn08,   #加工單價
         bgn03       LIKE bgn_file.bgn03    #月份
                    END RECORD
DEFINE l_bgl05      LIKE bgl_file.bgl05
DEFINE l_bgl06      LIKE bgl_file.bgl06
DEFINE l_bgl07      LIKE bgl_file.bgl07
DEFINE tot_bgn04    LIKE bgn_file.bgn04
DEFINE l_bgn04      LIKE bgn_file.bgn04
DEFINE l_bgn014     LIKE bgn_file.bgn014
DEFINE l_bgn11      LIKE bgn_file.bgn11
DEFINE l_bgn03      LIKE bgn_file.bgn03 #NO.FUN-680061 SMALLINT
DEFINE l_ima58      LIKE ima_file.ima58
DEFINE l_ima55      LIKE ima_file.ima55
DEFINE l_ima01      LIKE ima_file.ima01
DEFINE l_fac        LIKE pml_file.pml09 #NO.FUN-680061 DEC(16,8)
 
   DROP TABLE p120_tmp2
   CREATE TEMP TABLE p120_tmp2(
         bgn03 LIKE bgn_file.bgn03,
         bgn04 LIKE bgn_file.bgn04)
   CREATE UNIQUE INDEX p120_tmp2_01 ON p120_tmp2(bgn03)
 
   DROP TABLE p120_tmp3
   CREATE TEMP TABLE p120_tmp3(
        bgn014 LIKE bgn_file.bgn014,
        ima55  LIKE ima_file.ima55,
        bgn04  LIKE bgn_file.bgn04,
        bgn06t LIKE bgn_file.bgn06,
        bgn07t LIKE bgn_file.bgn07,
        bgn08t LIKE bgn_file.bgn08,
        bgn06  LIKE bgn_file.bgn06,
        bgn07  LIKE bgn_file.bgn07,
        bgn08  LIKE bgn_file.bgn08,
        bgn03  LIKE bgn_file.bgn03)
   IF g_bgz.bgz04 = '1' THEN
      FOR l_bgn03=1 TO 12   
         DECLARE get_bgn1_cs CURSOR  FOR
            SELECT bgn014,bgn11,bgn04 FROM bgn_file
             WHERE bgn01=g_bgn01 AND bgn02=g_bgn02
               AND bgn03=l_bgn03
               AND bgn04 > 0
             ORDER BY bgn014
         FOREACH get_bgn1_cs INTO l_bgn014,l_bgn11,l_bgn04
           IF STATUS THEN
              CALL cl_err('bgn1_cs',STATUS,1) LET g_success='N' EXIT FOREACH
           END IF
           CALL p120_get_ima01(g_bgn01,l_bgn014) RETURNING l_ima01
           SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=l_ima01
           IF cl_null(l_ima55) THEN
              CALL cl_err('sel ima55',STATUS,1) LET g_success='N' EXIT FOREACH
           END IF
          #No.TQC-760066--begin--
           IF cl_null(l_tmp.ima55) THEN
              SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=l_ima01
              IF cl_null(l_tmp.ima55) THEN
                 CALL cl_err3('sel','ima_file',l_ima01,'','mfg1325','','',1)
                 LET g_success = 'N' 
                 EXIT FOREACH 
              END IF
           END IF
          #No.TQC-760066--end--
           CALL s_umfchk(l_ima01,l_bgn11,l_ima55) RETURNING g_i,l_fac
           IF g_i = 1 THEN
              CALL cl_err(g_bgh.bgh04,'abm-731',1) LET l_fac = 1
           END IF
           LET l_bgn04=l_bgn04 * l_fac
           LET l_bgn04 = s_digqty(l_bgn04,l_ima55)     #FUN-910088--add--
           INSERT INTO p120_tmp2 VALUES (l_bgn03,l_bgn04)
          #TQC-790108
          #IF STATUS =-239 THEN
           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
              UPDATE p120_tmp2 SET bgn04=bgn04+l_bgn04 WHERE bgn03=l_bgn03
              IF STATUS THEN
#                CALL cl_err('ins tmp2',STATUS,1) #FUN-660105
                 CALL cl_err3("ins","p120_tmp","","",STATUS,"","ins tmp2",1) #FUN-660105
                 LET g_success='N' EXIT FOREACH
              END IF
           END IF
         END FOREACH
      END FOR
   ELSE
      #若其人工製費分攤基礎為為料件標準工時，則抓版本、年度之SUM(ima58)
      FOR l_bgn03=1 TO 12   
        DECLARE sum_ima58_cs CURSOR FOR
         SELECT UNIQUE bgn014 FROM bgn_file
          WHERE bgn01 = g_bgn01 AND bgn02 = g_bgn02
            AND bgn03 = l_bgn03
        FOREACH sum_ima58_cs INTO l_bgn014
          SELECT bgg07 INTO l_ima58 FROM bgg_file
           WHERE bgg01 = g_bgn01
             AND bgg02 = l_bgn014
          IF cl_null(l_ima58) THEN LET l_ima58 = 0 END IF
          INSERT INTO p120_tmp2 VALUES (l_bgn03,l_ima58)
          #TQC-790108
          #IF STATUS =-239 THEN
          IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
             UPDATE p120_tmp2 SET bgn04=bgn04+l_ima58 WHERE bgn03=l_bgn03    
             IF STATUS THEN
#               CALL cl_err('ins tmp2',STATUS,1) #FUN-660105
                CALL cl_err3("ins","p120_tmp2","","",STATUS,"","ins tmp2",1) #FUN-660105
                LET g_success='N' EXIT FOREACH
             END IF
          END IF
        END FOREACH
      END FOR
   END IF
   DECLARE p120_co2_tmp CURSOR FOR
      SELECT bgn014,'',0,0,0,0,0,0,0,0 FROM bgn_file
       WHERE bgn01=g_bgn01
         AND bgn02=g_bgn02
        GROUP BY bgn014
        ORDER BY bgn014
   FOREACH p120_co2_tmp INTO l_tmp.*
      IF STATUS THEN
         CALL cl_err('co2_tmp',STATUS,1) 
         LET g_success='N' EXIT FOREACH
      END IF
      CALL p120_get_ima01(g_bgn01,l_tmp.bgn014) RETURNING l_ima01
      IF g_success='N' THEN EXIT FOREACH END IF
      SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=l_ima01
      IF cl_null(l_tmp.ima55) THEN
         CALL cl_err('sel ima55',STATUS,1) 
         LET g_success='N' EXIT FOREACH
      END IF
      FOR l_bgn03=1 TO 12   
        LET l_bgl05=0
        LET l_bgl06=0
        LET l_bgl07=0
        LET tot_bgn04=0
        LET l_ima58=0
        SELECT SUM(bgl05),SUM(bgl06),SUM(bgl07) INTO l_bgl05,l_bgl06,l_bgl07
          FROM bgl_file
         WHERE bgl01=g_bgn01
           AND bgl02=g_bgn02 AND bgl03=l_bgn03
        SELECT bgn04 INTO tot_bgn04 FROM p120_tmp2 WHERE bgn03=l_bgn03
        SELECT bgg07 INTO l_ima58 FROM bgg_file
         WHERE bgg01 = g_bgn01
           AND bgg02 = l_bgn014
        IF cl_null(l_ima58) THEN LET l_ima58 = 0 END IF
        IF cl_null(l_bgl05) THEN LET l_bgl05 = 0 END IF
        IF cl_null(l_bgl06) THEN LET l_bgl06 = 0 END IF
        IF cl_null(l_bgl07) THEN LET l_bgl07 = 0 END IF
        IF cl_null(tot_bgn04) THEN LET tot_bgn04 = 0 END IF
        DECLARE get_bgn2_cs CURSOR  FOR
              SELECT bgn014,bgn11,bgn04 FROM bgn_file
               WHERE bgn01=g_bgn01 AND bgn02=g_bgn02
                 AND bgn03=l_bgn03
                 AND bgn014=l_tmp.bgn014
                 AND bgn04 >0
            ORDER BY bgn014
        FOREACH get_bgn2_cs INTO l_bgn014,l_bgn11,l_bgn04
          IF STATUS THEN
             CALL cl_err('bgn2_cs',STATUS,1) LET g_success='N' EXIT FOREACH
          END IF
         #No.TQC-760066--begin--
          IF cl_null(l_tmp.ima55) THEN
             SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=l_ima01
             IF cl_null(l_tmp.ima55) THEN
                CALL cl_err3('sel','ima_file',l_ima01,'','mfg1325','','',1)
                LET g_success = 'N' 
                EXIT FOREACH 
             END IF
          END IF
         #No.TQC-760066--end--
          CALL s_umfchk(l_ima01,l_bgn11,l_tmp.ima55) RETURNING g_i,l_fac
          IF g_i = 1 THEN
             CALL cl_err(g_bgh.bgh04,'abm-731',1) LET l_fac = 1
          END IF
          LET l_tmp.bgn04 = l_tmp.bgn04 +l_bgn04 * l_fac
          LET l_tmp.bgn04 = s_digqty(l_tmp.bgn04,l_tmp.ima55)      #FUN-910088--add--
        END FOREACH
        IF g_bgz.bgz04="1" THEN   #人工製費分攤以生產量為基礎
             LET l_tmp.bgn06t=l_bgl05 * (l_tmp.bgn04 / tot_bgn04)
             LET l_tmp.bgn07t=l_bgl06 * (l_tmp.bgn04 / tot_bgn04)
             LET l_tmp.bgn08t=l_bgl07 * (l_tmp.bgn04 / tot_bgn04)
        ELSE                      #以料件標準工時為基礎
             LET l_tmp.bgn06t=l_bgl05 * (l_ima58      / tot_bgn04)
             LET l_tmp.bgn07t=l_bgl06 * (l_ima58      / tot_bgn04)
             LET l_tmp.bgn08t=l_bgl07 * (l_ima58      / tot_bgn04)
        END IF
        LET l_tmp.bgn06 =l_tmp.bgn06t / l_tmp.bgn04
        LET l_tmp.bgn07 =l_tmp.bgn07t / l_tmp.bgn04
        LET l_tmp.bgn08 =l_tmp.bgn08t / l_tmp.bgn04
        LET l_tmp.bgn03 =l_bgn03
        INSERT INTO p120_tmp3 VALUES (l_tmp.*)
        #TQC-790108
        #IF STATUS =-239 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
#          CALL cl_err('ins tmp3',STATUS,1) #FUN-660105
           CALL cl_err3("ins","p120_tmp3","","",STATUS,"","ins tmp3",1) #FUN-660105
           LET g_success='N' EXIT FOREACH
        END IF
      END FOR
   END FOREACH
   DECLARE get_bgn3_cs CURSOR FOR
      SELECT bgn_file.* FROM bgn_file
       WHERE bgn01=g_bgn01
         AND bgn02=g_bgn02
         AND bgn04>0
        ORDER BY bgn03,bgn014
   FOREACH get_bgn3_cs INTO g_bgn.*
      IF STATUS THEN
         CALL cl_err('bgn3_cs',STATUS,1) LET g_success='N' EXIT FOREACH
      END IF
      INITIALIZE l_tmp.* TO NULL
      SELECT * INTO l_tmp.* FROM p120_tmp3
       WHERE bgn03 =g_bgn.bgn03
         AND bgn014=g_bgn.bgn014
      CALL p120_get_ima01(g_bgn01,g_bgn.bgn014) RETURNING l_ima01
      IF g_success='N' THEN EXIT FOREACH END IF
      #No.TQC-760066--begin--
       IF cl_null(l_tmp.ima55) THEN
          SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=l_ima01
          IF cl_null(l_tmp.ima55) THEN
             CALL cl_err3('sel','ima_file',l_ima01,'','mfg1325','','',1)
             LET g_success = 'N' 
             EXIT FOREACH 
          END IF
       END IF
      #No.TQC-760066--end--
      CALL s_umfchk(l_ima01,l_tmp.ima55,g_bgn.bgn11) RETURNING g_i,l_fac
      IF g_i = 1 THEN
         CALL cl_err(l_ima01,'abm-731',1) LET l_fac = 1
      END IF
      LET g_bgn.bgn06 = l_tmp.bgn06 / l_fac
      LET g_bgn.bgn07 = l_tmp.bgn07 / l_fac
      LET g_bgn.bgn08 = l_tmp.bgn08 / l_fac
      UPDATE bgn_file
         SET bgn06  = g_bgn.bgn06,
             bgn07  = g_bgn.bgn07,
             bgn08  = g_bgn.bgn08    
         WHERE bgn01 = g_bgn.bgn01  
	     AND bgn012= g_bgn.bgn012 
	     AND bgn013= g_bgn.bgn013 
	     AND bgn014= g_bgn.bgn014 
	     AND bgn02 = g_bgn.bgn02  
	     AND bgn11 = g_bgn.bgn11  
	     AND bgn11_fac = g_bgn.bgn11_fac  
	     AND bgn03 = g_bgn.bgn03
      IF STATUS THEN
         LET g_success='N' 
#        CALL cl_err('upd bgn06:',STATUS,1) #FUN-660105
         CALL cl_err3("upd","bgn_file",g_bgn.bgn01,g_bgn.bgn02,STATUS,"","upd bgn06",1) #FUN-660105
         EXIT FOREACH
      END IF
   END FOREACH
   DECLARE get_bgm3_cs CURSOR FOR
      SELECT bgm_file.* FROM bgm_file
       WHERE bgm01=g_bgn01
         AND bgm02=g_bgn02
         AND bgm04>0
        ORDER BY bgm03,bgm017
   FOREACH get_bgm3_cs INTO g_bgm.*
      IF STATUS THEN
         CALL cl_err('bgm3_cs',STATUS,1) LET g_success='N' EXIT FOREACH
      END IF
      INITIALIZE l_tmp.* TO NULL
      SELECT * INTO l_tmp.* FROM p120_tmp3
       WHERE bgn03 =g_bgm.bgm03
         AND bgn014=g_bgm.bgm017
      CALL p120_get_ima01(g_bgn01,g_bgm.bgm017) RETURNING l_ima01
      IF g_success='N' THEN EXIT FOREACH END IF
      #No.TQC-760066--begin--
       IF cl_null(l_tmp.ima55) THEN
          SELECT ima55 INTO l_tmp.ima55 FROM ima_file WHERE ima01=l_ima01
          IF cl_null(l_tmp.ima55) THEN
             CALL cl_err3('sel','ima_file',l_ima01,'','mfg1325','','',1)
             LET g_success = 'N' 
             EXIT FOREACH 
          END IF
       END IF
      #No.TQC-760066--end--
      CALL s_umfchk(l_ima01,l_tmp.ima55,g_bgm.bgm08) RETURNING g_i,l_fac
      IF g_i = 1 THEN
         CALL cl_err(l_ima01,'abm-731',1) LET l_fac = 1
      END IF
      LET g_bgm.bgm092 = l_tmp.bgn06 / l_fac
     #LET g_bgm.bgm093 = l_tmp.bgn06 / l_fac     #MOD-A70078 mark
      LET g_bgm.bgm093 = l_tmp.bgn07 / l_fac     #MOD-A70078
     #LET g_bgm.bgm094 = l_tmp.bgn06 / l_fac     #MOD-A70078 mark
      LET g_bgm.bgm094 = l_tmp.bgn08 / l_fac     #MOD-A70078
      UPDATE bgm_file
         SET bgm092 = g_bgm.bgm092,
             bgm093 = g_bgm.bgm093,
        bgm094 = g_bgm.bgm094    
        WHERE bgm01  = g_bgm.bgm01    
          AND bgm012 = g_bgm.bgm012   
          AND bgm013 = g_bgm.bgm013   
          AND bgm014 = g_bgm.bgm014   
          AND bgm015 = g_bgm.bgm015   
          AND bgm016 = g_bgm.bgm016   
          AND bgm017 = g_bgm.bgm017   
          AND bgm08  = g_bgm.bgm08   
          AND bgm08_fac = g_bgm.bgm08_fac   
          AND bgm02  = g_bgm.bgm02   
          AND bgm03  = g_bgm.bgm03   
      IF STATUS THEN
         LET g_success='N' 
#        CALL cl_err('upd bgm092:',STATUS,1) #FUN-660105
         CALL cl_err3("upd","bgm_file",g_bgm.bgm01,g_bgm.bgm02,STATUS,"","upd bgm092",1) #FUN-660105
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION p120_get_ima01(p_bgg01,p_bgg02)
 
DEFINE p_bgg01 LIKE bgg_file.bgg01
DEFINE p_bgg02 LIKE bgg_file.bgg02
DEFINE l_ima01 LIKE ima_file.ima01
 
   LET l_ima01=''
   SELECT ima01 INTO l_ima01 FROM ima_file WHERE ima01=p_bgg02
   IF cl_null(l_ima01) THEN
      SELECT bgg06 INTO l_ima01 FROM bgg_file
       WHERE bgg01=p_bgg01
         AND bgg02=p_bgg02
      IF cl_null(l_ima01) THEN
         CALL cl_err('sel bgg06',STATUS,1) LET g_success='N'
      END IF
   END IF
   RETURN l_ima01
END FUNCTION
#Patch....NO.TQC-610035 <001> #

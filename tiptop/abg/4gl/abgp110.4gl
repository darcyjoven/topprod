# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: abgp110.4gl
# Descriptions...: 採購預算自動產生作業
# Date & Author..: 02/10/03 By qazzaq
# modi by yuening 031017
# modi ..........: ching 031120 No.8563 review
 # Modify.........: No.MOD-470041 04/07/16 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570113 06/02/24 By yiting 加入背景作業功能 
# Modify.........: No.FUN-660105 06/06/15 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-690106 06/10/13 By hellen cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.CHI-860042 08/07/17 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-970135 09/07/15 By wujie 預算BOM需要展開
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No:CHI-A70037 10/07/29 By Summer 使用到apz56的部分,先依據廠商抓取pmc29,若為null或=0則改用apz56
# Modify.........: No:CHI-B60093 11/06/29 By Pengu 當成本參數設定為"分倉成本"時，成本應取該料的平均
# Modify.........: No.MOD-BA0190 11/10/26 By Polly 將sql相關使用雙引號改為單引號
# Modify.........: No.MOD-CC0195 12/12/21 By Polly 調整數量抓取，改抓單頭bgg_file資料
# Modify.........: No.MOD-CC0195 12/12/21 By Polly 調整數量抓取，改抓單頭bgg_file資料
# Modify.........: No.FUN-910088 11/12/30 By chenjing 增加數量欄位小數取位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_sql            string,                 #No.FUN-580092 HCN
       g_wc,g_wc1,l_buf string,                 #No.FUN-580092 HCN
       g_bgg01          LIKE bgg_file.bgg01,    # BOM版本
       g_bgn01          LIKE bgn_file.bgn01,    # 生產版本
       g_bgn01_t        LIKE bgn_file.bgn01,    # 單價版本
       g_bgn02          LIKE abk_file.abk03,    # 年度
       l_c              LIKE type_file.chr1,    # 是否重新產生 #No.FUN-680061 VARCHAR(01)
       g_yy,g_mm        LIKE type_file.num5,    #期初庫存擷取年月 SMALLINT  #No.FUN-680061  SMALLINT
       g_type           LIKE ccc_file.ccc07,    #No:CHI-B60093 add 成本計算類型
       g_start,g_end    LIKE cre_file.cre08,    #No.FUN-680061 VARCHAR(10)
       g_change_lang    LIKE type_file.chr1,    #No.FUN-570113  #No.FUN-680061 VARCHAR(01)
       ls_date          STRING,                 #No.FUN-570113
       l_flag           LIKE type_file.chr1     #No.FUN-570113  #No.FUN-680061 VARCHAR(01)
#      p_row,p_col      LIKE type_file.num5     #No.FUN-570113  #No.FUN-680061 SMALLINT
 
DEFINE g_apa09          LIKE apa_file.apa09,
       g_apa02          LIKE apa_file.apa02,
       g_apa11          LIKE apa_file.apa11,
       g_apa06          LIKE apa_file.apa06
DEFINE g_apa12          LIKE apa_file.apa12,
       g_apa64          LIKE apa_file.apa64,
       g_apa24          LIKE apa_file.apa24
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE g_cnt            LIKE type_file.num5     #NO.FUN-680061 SMALLINT

MAIN 
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0056
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570113 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_bgg01 = ARG_VAL(1)
   LET g_bgn01 = ARG_VAL(2)
   LET g_bgn02 = ARG_VAL(3)
   LET g_yy    = ARG_VAL(4)
   LET g_mm    = ARG_VAL(5)
   LET l_c     = ARG_VAL(6)
   LET g_bgjob = ARG_VAL(7)
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
   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
   IF cl_null(g_apz.apz56) THEN LET g_apz.apz56=25 END IF
 
#-NO.FUN-570113 start---
#    LET p_row = 5 LET p_col = 15
#   OPEN WINDOW p110_w AT p_row,p_col WITH FORM "abg/42f/abgp110"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#   CALL p110_i()
#   CLOSE WINDOW p110_w
   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  #No:CHI-B60093 add
   LET g_type = g_ccz.ccz28      #No:CHI-B60093 add
   WHILE TRUE
      IF g_bgjob='N' THEN
         CALL p110_i()
         IF cl_sure(0,0) THEN
            CALL cl_wait()
            LET g_success="Y"
            BEGIN WORK
            CALL p110_p()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_cmmsg(1)
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_rbmsg(1)
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p110_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p110_w
      ELSE
         LET g_success="Y"
         BEGIN WORK
         CALL p110_p()
         IF g_success="Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#-NO.FUN-570113 end--
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
END MAIN
 
FUNCTION p110_i()
    DEFINE   lc_cmd        LIKE zz_file.zz08        #No.FUN-680061  VARCHAR(500)
    DEFINE   p_row,p_col   LIKE type_file.num5      #No.FUN-570113  #No.FUN-680061 SMALLINT
    #No.FUN-570113 --start--
     LET p_row=5
     LET p_col=25
 
     OPEN WINDOW p110_w AT p_row,p_col WITH FORM "abg/42f/abgp110"
     ATTRIBUTE(STYLE=g_win_style)
 
     CALL cl_ui_init()
    # No.FUN-570113 --end--
 
    CLEAR FORM
    CALL cl_opmsg('a')
    LET g_bgn02 = YEAR(g_today)
    LET l_c    = 'N'
    LET g_yy   = YEAR(g_today)-1
    LET g_mm   = 12
    LET g_mm   = 12
    LET g_bgjob = "N"                            #No.FUN-570113
    LET g_type = g_ccz.ccz28      #No:CHI-B60093 add
    WHILE TRUE                                   #No.FUN-570113
 
    INPUT g_bgg01,g_bgn01,g_bgn02,g_yy,g_mm,l_c,g_type,g_bgjob WITHOUT DEFAULTS    #No:CHI-B60093 add type
        FROM bgg01,bgn01,bgn02,yy,mm,c,type,g_bgjob HELP 1        #No.FUN-570113
 
       AFTER FIELD bgg01
         IF cl_null(g_bgg01) THEN
               LET g_bgg01=' '
         END IF
 
       AFTER FIELD bgn02
         IF g_bgn02<0 THEN
            NEXT FIELD bgn02
         END IF
         LET g_yy =g_bgn02-1
         DISPLAY g_yy TO yy
 
       AFTER FIELD yy
         IF g_yy>=g_bgn02 THEN
            NEXT FIELD yy
         END IF
 
       AFTER FIELD mm
         IF g_mm>12 OR g_mm<1 THEN
            NEXT FIELD mm
         END IF
 
        ON ACTION locale                           #No.FUN-570113
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
        CLOSE WINDOW p110_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
     END IF
   # IF NOT cl_sure(18,20) THEN RETURN END IF
   # CALL cl_wait()
 
   # IF g_bgz.bgz02 = 'Y' THEN
   #    LET g_bgn01_t=g_bgn01
   # ELSE
   #    LET g_bgn01_t=' '
   # END IF
   # BEGIN WORK
   # LET g_success = 'Y'
   # CALL p110_p()
   # IF g_success = 'Y' THEN
   #    COMMIT WORK CALL cl_cmmsg(1)
   # ELSE
   #    ROLLBACK WORK CALL cl_rbmsg(1)
   # END IF
   # ERROR ""
   # CALL cl_end(18,20)
        IF g_bgjob="Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
           WHERE zz01="abgp110"
        IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
           CALL cl_err('abgp110','9031',1) 
        ELSE
           LET lc_cmd=lc_cmd CLIPPED,
                      " '",g_bgg01 CLIPPED,"'",
                      " '",g_bgn01 CLIPPED,"'",
                      " '",g_bgn02 CLIPPED,"'",
                      " '",g_yy CLIPPED,"'",
                      " '",g_mm CLIPPED,"'",
                      " '",l_c CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('abgp110',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p110_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690106
        EXIT PROGRAM
      END IF
      EXIT WHILE
 END WHILE
 #No.FUN-570113 --end--
END FUNCTION
 
FUNCTION p110_p()
DEFINE l_bgn01     LIKE bgn_file.bgn01,
       l_bgn02     LIKE bgn_file.bgn02,
       l_bgn03     LIKE bgn_file.bgn03,
       l_bgn014    LIKE bgn_file.bgn014,
       l_bgn11     LIKE bgn_file.bgn11 ,
       l_bgn04     LIKE bgn_file.bgn04
DEFINE l_month     LIKE type_file.num5,    #NO.FUN-680061 SMALLINT
       l_ima01     LIKE ima_file.ima01,
       l_bgp05     LIKE bgp_file.bgp05,    #單價
       l_bgp07     LIKE bgp_file.bgp07,    #金額
       l_qty       LIKE bgh_file.bgh06     #NO.FUN-680061 DEC(15,3)
DEFINE l_ima01_o     LIKE ima_file.ima01,
       l_b_up        LIKE bgp_file.bgp05,
       l_b_qty       LIKE bgh_file.bgh06   #NO.FUN-680061 DEC(15,3)
DEFINE l_ima54       LIKE ima_file.ima54,
       l_ima44       LIKE ima_file.ima44,
       l_ima44_fac   LIKE ima_file.ima44_fac,
       l_bgh11       LIKE bgh_file.bgh11,
       l_bgh11_fac   LIKE bgh_file.bgh11_fac,
       l_pmc17       LIKE pmc_file.pmc17,
       l_img09       LIKE img_file.img09,
       l_imk09       LIKE imk_file.imk09,
       l_pmh03       LIKE pmh_file.pmh03
DEFINE l_bgh         RECORD LIKE bgh_file.*
DEFINE l_fac         LIKE pml_file.pml09   #NO.FUN-680061 DEC(16,8)
DEFINE l_pmc29       LIKE pmc_file.pmc29   #CHI-A70037 add
 
#FUN-570113 --start--
    IF g_bgz.bgz02 = 'Y' THEN
       LET g_bgn01_t=g_bgn01
    ELSE
       LET g_bgn01_t=' '
    END IF
#FUN-570113 ---end---
 
    DROP TABLE abgp110_tmp
    CREATE TEMP TABLE abgp110_tmp(
        month      LIKE type_file.num5,   #NO.FUN-680061 SMALLINT
        bgh04      LIKE bgh_file.bgh04,
        ima44      LIKE ima_file.ima44,
        ima44_fac  LIKE pml_file.pml09,
        qty        LIKE bnf_file.bnf12)
    #已產生預算資料者是否重新產生
    IF l_c ='Y' THEN
       DELETE FROM bgp_file WHERE bgp01=g_bgn01 AND bgp02=g_bgn02
       IF STATUS THEN
#         CALL cl_err('del bgp',STATUS,1) #FUN-660105
          CALL cl_err3("del","bgp_file",g_bgn01,g_bgn02,STATUS,"","del bgp",1) #FUN-660105 
          LET g_success='N' RETURN
       END IF
    END IF
   #----------------MOD-CC0195------------------(S)
   #--MOD-CC0195--mark
   #LET g_sql = " SELECT * FROM bgh_file ",
   #            "  WHERE bgh01='",g_bgg01,"' ",
   #            "    AND bgh02=? "
   #PREPARE p110_pre_bgh FROM g_sql
   #DECLARE p110_cur_bgh CURSOR FOR p110_pre_bgh
   #IF STATUS THEN
   #   CALL cl_err('bgh_cur',STATUS,1) LET g_success='N' RETURN
   #END IF
   #--MOD-CC0195--mark
    LET g_sql = " SELECT * FROM bgg_file ",
                "  WHERE bgg01='",g_bgg01,"' ",
                "    AND bgg02=? "
    PREPARE p110_pre_bgg FROM g_sql
    DECLARE p110_cur_bgg CURSOR FOR p110_pre_bgg
    IF STATUS THEN
       CALL cl_err('bgg_cur',STATUS,1) LET g_success='N' RETURN
    END IF
   #----------------MOD-CC0195------------------(E)
    #期初庫存年月
    LET g_sql = " SELECT img09,SUM(imk09) FROM img_file,imk_file,imd_file ",
                " WHERE img01=imk01 ",
                "   AND img02=imk02 ",
                "   AND img03=imk03 ",
                "   AND img04=imk04 ",
                "   AND imk05=",g_yy," AND imk06=",g_mm,
                "   AND imk02=imd01 AND imd11='Y' ",
                "   AND imk01=? ",
                " GROUP BY img09 "
    PREPARE p110_imk_pre  FROM g_sql
    DECLARE p110_imk CURSOR FOR p110_imk_pre
 
    DECLARE p110_cur1 CURSOR FOR
      SELECT bgn01,bgn02,bgn03,bgn014,bgn11,SUM(bgn04)
        FROM bgn_file,bgg_file
       WHERE bgn01=g_bgn01
         AND bgn02=g_bgn02
         AND bgg01=g_bgg01
         AND bgg02=bgn014
         AND bgn03>0
         AND bgn04>0
       GROUP BY bgn01,bgn02,bgn03,bgn014,bgn11
    FOREACH p110_cur1 INTO l_bgn01,l_bgn02,l_bgn03,l_bgn014,l_bgn11,l_bgn04
        IF STATUS THEN
           CALL cl_err('cur1:',STATUS,1) LET g_success='N'  RETURN
        END IF
       #FOREACH p110_cur_bgh USING l_bgn014 INTO l_bgh.*          #MOD-CC0195 mark
        FOREACH p110_cur_bgg USING l_bgn014 INTO l_bgh.*          #MOD-CC0195 add
           LET l_qty=0
           LET l_fac=1
           LET l_ima44=''
           LET l_ima44_fac=''
#No.MOD-970135 --begin
           CALL p100_cralc_bom(0,l_bgh.bgh02,l_bgn03,l_bgn04)
#           SELECT ima44,ima44_fac INTO l_ima44,l_ima44_fac FROM ima_file
#            WHERE ima01=l_bgh.bgh04
#           IF cl_null(l_ima44) THEN
##             CALL cl_err('sel ima44',100,1) #FUN-660105
#              CALL cl_err3("sel","ima_file",l_bgh.bgh04,"",100,"","sel ima44",1) #FUN-660105 
#              LET g_success='N' RETURN
#           END IF
#           CALL s_umfchk(l_bgh.bgh04,l_bgh.bgh11,l_ima44) RETURNING g_i,l_fac
#           IF g_i = 1 THEN
#              CALL cl_err(l_bgh.bgh04,'abm-731',0) LET l_fac = 1
#           END IF
#           LET l_qty=l_bgn04*l_bgh.bgh06/l_bgh.bgh07*((100+l_bgh.bgh08)/100)
#                     *l_fac
#           IF cl_null(l_qty) THEN LET l_qty=0 CONTINUE FOREACH END IF
#           INSERT INTO abgp110_tmp VALUES
#                  (l_bgn03,l_bgh.bgh04,l_ima44,l_ima44_fac,l_qty)
#           IF STATUS THEN
##             CALL cl_err('ins tmp:',STATUS,1) #FUN-660105
#              CALL cl_err3("ins","abgp110_tmp","","",STATUS,"","ins tmp:",1) #FUN-660105 
#              LET g_success='N'  RETURN
#           END IF
#No.MOD-970135 --end
        END FOREACH
    END FOREACH
    LET g_sql=" SELECT month,bgh04,ima44,ima44_fac,SUM(qty) ",
              "   FROM abgp110_tmp  ",
              "  GROUP BY month,bgh04,ima44,ima44_fac ",
              "  ORDER BY bgh04,month "
    PREPARE p110_pre_tmp FROM g_sql
    DECLARE p110_cur_tmp CURSOR FOR p110_pre_tmp
 
    LET l_ima01_o=''
    FOREACH p110_cur_tmp INTO l_month,l_ima01,l_ima44,l_ima44_fac,l_qty
        LET g_apa12=NULL
        LET g_apa64=NULL
        LET g_apa24=NULL
        #抓期初庫存數
        IF cl_null(l_ima01_o) OR l_ima01<>l_ima01_o THEN
           #主供應廠商/付款條件
           LET l_ima54=''
           LET l_pmc17=''
           LET l_pmh03=''
           SELECT ima54,pmc17 INTO l_ima54,l_pmc17
             FROM ima_file,pmc_file
            WHERE ima01 = l_ima01 AND ima54=pmc01
           IF STATUS OR cl_null(l_ima54) THEN
               DECLARE p110_pmc_c CURSOR FOR
                   SELECT pmh02,pmh03,pmc17 FROM pmh_file,pmc_file
                    WHERE pmh01 = l_ima01
                      AND pmh05 = '0'
                      AND pmc01=pmh02
                     #AND pmh21 = " "                                             #CHI-860042    #MOD-BA0190 mark
                      AND pmh21 = ' '                                             #MOD-BA0190 add
                      AND pmh22 = '1'                                             #CHI-860042
                      AND pmh23 = ' '                                             #No.CHI-960033
                      AND pmhacti = 'Y'                                           #CHI-910021
                    ORDER BY pmh03 desc
               FOREACH p110_pmc_c INTO l_ima54,l_pmh03,l_pmc17
                  EXIT FOREACH
               END FOREACH
           END IF
           #CHI-A70037 add --start--
           SELECT pmc29 INTO l_pmc29 FROM pmc_file WHERE pmc01 = l_ima54 
           IF NOT (cl_null(l_pmc29) OR l_pmc29=0) THEN 
              LET g_apz.apz56 = l_pmc29
           END IF
           #CHI-A70037 add --end--
           LET g_apa02=MDY(12,g_apz.apz56,g_bgn02-1)
           CALL s_paydate('a','',g_apa02,g_apa02,l_pmc17,l_ima54)
           RETURNING g_apa12,g_apa64,g_apa24
           LET l_b_qty=0
           FOREACH p110_imk  USING l_ima01
              INTO l_img09,l_imk09
              call s_umfchk(l_ima01,l_img09,l_ima44)
              RETURNING g_i,l_fac
              IF g_i THEN LET l_fac=1 END IF
              LET l_b_qty=l_b_qty + l_imk09*l_fac
              LET l_b_qty = s_digqty(l_b_qty,l_ima44)     #FUN-910088--add--
           END FOREACH
           IF cl_null(l_b_qty) THEN LET l_b_qty=0 END IF
           LET l_b_up=''
           SELECT bgc07 INTO l_b_up FROM bgc_file
            WHERE bgc01=g_bgn01_t
              AND bgc02=g_bgn02
              AND bgc03=1
              AND bgc05=l_ima01
           IF STATUS THEN LET l_b_up='' END IF
           IF l_b_up IS NULL THEN    #取期初單價
              CALL p110_bgp05(1,l_ima01) RETURNING l_b_up
           END IF
           LET l_bgp07=l_b_up*l_b_qty
           LET l_bgp07=cl_digcut(l_bgp07,g_azi04)
            INSERT INTO bgp_file (bgp01,bgp02,bgp03,bgp04,bgp05,bgp06,  #No.MOD-470041
                                 bgp07,bgp08,bgp09,bgp10,bgp11,bgp11_fac)
                VALUES (g_bgn01,g_bgn02,0,l_ima01,l_b_up,l_b_qty,l_bgp07,
                        g_apa12,g_apa64,'',l_ima44,l_ima44_fac)
        END IF
        #抓取單價
        LET l_bgp05=''
        SELECT bgc07 INTO l_bgp05 FROM bgc_file
         WHERE bgc01=g_bgn01_t
#No.MOD-970135 --begin
           AND bgc02=g_bgn02
#          AND bgc03=1
           AND bgc03=l_month
#No.MOD-970135 --end
           AND bgc05=l_ima01
        IF STATUS THEN LET l_bgp05=''   END IF
        IF l_bgp05  IS NULL THEN    #取期初單價
           CALL p110_bgp05(l_month,l_ima01) #月/料件編號
           RETURNING l_bgp05
        END IF
        #CHI-A70037 add --start--
        SELECT pmc29 INTO l_pmc29 FROM pmc_file WHERE pmc01 = l_ima54 
        IF NOT (cl_null(l_pmc29) OR l_pmc29=0) THEN 
           LET g_apz.apz56 = l_pmc29
        END IF
        #CHI-A70037 add --end--
        #取pay date
        LET g_apa02=MDY(l_month,g_apz.apz56,g_bgn02)
        CALL s_paydate('a','',g_apa02,g_apa02,l_pmc17,l_ima54)
        RETURNING g_apa12,g_apa64,g_apa24
        IF l_b_qty>0 THEN
           IF l_qty>l_b_qty THEN
              LET l_qty=l_qty-l_b_qty
              LET l_b_qty=0
              LET l_bgp07=l_bgp05*l_qty
           ELSE
              LET l_b_qty=l_b_qty-l_qty
           END IF
        END IF
        LET l_qty = s_digqty(l_qty,l_ima44)    #FUN-910088--add--
        LET l_bgp07=l_bgp05*l_qty
        LET l_bgp07=cl_digcut(l_bgp07,g_azi04)
         INSERT INTO bgp_file (bgp01,bgp02,bgp03,bgp04,bgp05,bgp06,  #No.MOD-470041
                              bgp07,bgp08,bgp09,bgp10,bgp11,bgp11_fac)
             VALUES (g_bgn01,g_bgn02,l_month,l_ima01,l_bgp05,l_qty,l_bgp07,
                     g_apa12,g_apa64,'',l_ima44,l_ima44_fac)
        IF STATUS THEN
#          CALL cl_err('ins bgp',STATUS,1) #FUN-660105
           CALL cl_err3("ins","bgp_file",g_bgn01,g_bgn02,STATUS,"","ins bgp",1) #FUN-660105 
           LET g_success='N' RETURN
        END IF
        LET l_ima01_o=l_ima01
    END FOREACH
END FUNCTION
 
#依參數取得單價預設值
FUNCTION p110_bgp05(p_bgp03,p_bgp04) #月/料件編號
  DEFINE p_bgp03    LIKE bgp_file.bgp03
  DEFINE p_bgp04    LIKE bgp_file.bgp04
  DEFINE l_ima53    LIKE ima_file.ima53
  DEFINE l_ima54    LIKE ima_file.ima54
  DEFINE l_ima109   LIKE ima_file.ima109
  DEFINE l_ccc23a   LIKE ccc_file.ccc23a
  DEFINE l_pmh12    LIKE pmh_file.pmh12
  DEFINE l_pmh13    LIKE pmh_file.pmh13
  DEFINE l_pmh14    LIKE pmh_file.pmh14
  DEFINE l_bgb05    LIKE bgb_file.bgb05
  DEFINE l_bgp05    LIKE bgp_file.bgp05
  DEFINE l_azi04    LIKE azi_file.azi04
  DEFINE l_bga05    LIKE bga_file.bga05
 
  LET l_bgp05 = 0
  CASE WHEN g_bgz.bgz03 = '1'
            SELECT ima53 INTO l_ima53 FROM ima_file
             WHERE ima01 = p_bgp04
            IF cl_null(l_ima53) THEN LET l_ima53 = 0 END IF
            LET l_bgp05 = l_ima53
       WHEN g_bgz.bgz03 = '2'
           #------------No:CHI-B60093 modify
           #SELECT ccc23a INTO l_ccc23a FROM ccc_file
           # WHERE ccc01 = p_bgp04
           #   AND ccc07 = '1'       #No.FUN-840041
           #   AND ccc02*12+ccc03=(SELECT MAX(ccc02*12+ccc03) FROM ccc_file
           #                        WHERE ccc01 = p_bgp04
           #                          AND ccc07 = '1'      #No.FUN-840041
           #                          AND ccc02*12+ccc03<=g_bgn02*12+p_bgp03)

            CALL p110_get_ccc23('1',p_bgp04) RETURNING l_ccc23a
           #------------No:CHI-B60093 end
            IF cl_null(l_ccc23a) THEN
              #------------No:CHI-B60093 modify
              #DECLARE cca_ym CURSOR FOR
              #   SELECT cca12a FROM cca_file
              #    WHERE cca01 = p_bgp04
              #    ORDER BY cca02 DESC, cca03 DESC
              #FOREACH cca_ym INTO l_ccc23a
              #  EXIT FOREACH
              #END FOREACH
               CALL p110_get_ccc23('2',p_bgp04) RETURNING l_ccc23a
              #------------No:CHI-B60093 end
            END IF
            IF cl_null(l_ccc23a) THEN LET l_ccc23a = 0 END IF
            LET l_bgp05 = l_ccc23a
       WHEN g_bgz.bgz03 = '3'
            SELECT ima54 INTO l_ima54 FROM ima_file WHERE ima01 = p_bgp04
            SELECT pmh12,pmh13,pmh14 INTO l_pmh12,l_pmh13,l_pmh14 FROM pmh_file
             WHERE pmh01 = p_bgp04 AND pmh02 = l_ima54 AND pmh05 = '0'
              #AND pmh21 = " "                                                   #CHI-860042 #MOD-BA0190 mark
               AND pmh21 = ' '                                                   #MOD-BA0190 add                                 
               AND pmh22 = '1'                                                   #CHI-860042
               AND pmh23 = ' '                                                   #No.CHI-960033
               AND pmhacti = 'Y'                                                 #CHI-910021
            IF SQLCA.SQLCODE THEN        #無主供應商資料, 則取出第一筆
               DECLARE p110_c3_c CURSOR FOR
                  SELECT pmh12,pmh13,pmh14 FROM pmh_file
                   WHERE pmh01 = p_bgp04 AND pmh05 = '0'
                    #AND pmh21 = " "                                             #CHI-860042 #MOD-BA0190 mark
                     AND pmh21 = ' '                                             #MOD-BA0190 add
                     AND pmh22 = '1'                                             #CHI-860042
                     AND pmh23 = ' '                                             #No
                     AND pmhacti = 'Y'                                           #CHI-910021
               OPEN p110_c3_c
               FETCH FIRST p110_c3_c INTO l_pmh12,l_pmh14
               CLOSE p110_c3_c
               IF cl_null(l_pmh13) THEN LET l_pmh13=1 END IF
            END IF
            IF cl_null(l_pmh12) THEN LET l_pmh12 = 0 END IF
            #取預估匯率
            CALL s_bga05(g_bgn01, g_bgn02,p_bgp03,l_pmh13)
            RETURNING l_bga05
            IF cl_null(l_bga05) THEN LET l_bga05=l_pmh14 END IF
            LET l_bgp05 = l_pmh12*l_bga05
            LET l_bgp05 = cl_digcut(l_bgp05,g_azi04)
  END CASE
  IF cl_null(l_bgp05) THEN LET l_bgp05 = 0 END IF
  SELECT ima109 INTO l_ima109 FROM ima_file WHERE ima01 = p_bgp04
  SELECT bgb05 INTO l_bgb05 FROM bgb_file
   WHERE bgb01 = g_bgn01 AND bgb02 = g_bgn01_t
     AND bgb03 = p_bgp03 AND bgb04 = l_ima109
  IF cl_null(l_bgb05) THEN LET l_bgb05 = 0 END IF
  LET l_bgp05 = l_bgp05 * ( 1 + l_bgb05/100)
  LET l_bgp05 = cl_digcut(l_bgp05,g_azi04)
  RETURN l_bgp05
END FUNCTION

#-----------------------No:CHI-B60093 add----------------------
FUNCTION p110_get_ccc23(p_flag,p_ccc01)
   DEFINE p_ccc01      LIKE ccc_file.ccc01
   DEFINE p_flag       LIKE type_file.chr1
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_ccc23a     LIKE ccc_file.ccc23a
   DEFINE l_ccc23a_sum LIKE ccc_file.ccc23a
   DEFINE l_ccc02      LIKE ccc_file.ccc02
   DEFINE l_ccc03      LIKE ccc_file.ccc03
   DEFINE l_ccc02_t    LIKE ccc_file.ccc02
   DEFINE l_ccc03_t    LIKE ccc_file.ccc03
   DEFINE l_cnt        LIKE type_file.num5

   LET l_ccc23a = 0 
   LET l_ccc23a_sum = 0 
   LET l_cnt = 0     
   LET l_ccc02_t = NULL 
   LET l_ccc03_t = NULL 
   LET l_chr = 'N'
   IF p_flag = '1' THEN 
      DECLARE ccc_ym CURSOR FOR
         SELECT ccc02,ccc03,ccc23a  FROM ccc_file
          WHERE ccc01 = p_ccc01
            AND ccc07 = g_type
            AND ccc02*12+ccc03<=g_bgn02*12+p_bgp03
            ORDER BY ccc02 DESC, ccc03 DESC

      IF g_type MATCHES "[12]"  THEN
      #成本參數設定月加權平均
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23a
            LET l_ccc23a_sum = l_ccc23a
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23a
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t) 
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23a_sum = l_ccc23a_sum + l_ccc23a
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02 
               LET l_ccc03_t = l_ccc03 
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF 
   ELSE
      DECLARE cca_ym CURSOR FOR
         SELECT cca02,cca03,cca12a FROM cca_file
          WHERE cca01 = p_ccc01
           AND cca06 = g_type
          ORDER BY cca02 DESC, cca03 DESC
      IF g_type MATCHES "[12]"  THEN
      #成本參數設定月加權平均
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23a
            LET l_ccc23a_sum = l_ccc23a
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23a
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t) 
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23a_sum = l_ccc23a_sum + l_ccc23a
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02 
               LET l_ccc03_t = l_ccc03 
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF
   END IF
   IF l_cnt = 0 THEN LET l_cnt = 1 END IF
   LET l_ccc23a_sum = l_ccc23a_sum / l_cnt
   IF l_chr = 'N' THEN
      RETURN NULL
   ELSE
      RETURN l_ccc23a_sum
   END IF

END FUNCTION
#-----------------------No:CHI-B60093 add----------------------

#Patch....NO.TQC-610035 <001,002,003> #
#No.MOD-970135 --begin
FUNCTION p100_cralc_bom(p_level,p_key,p_bgn03,p_total)
DEFINE     p_level   LIKE type_file.num5,           
           p_total   LIKE bgh_file.bgh06,         
           p_bgn03   LIKE bgn_file.bgn03,         
           l_total   LIKE bgh_file.bgh06, 
           l_qty     LIKE bgh_file.bgh06,            
           p_key     LIKE bgh_file.bgh02,                
           l_ac,l_i,l_n  LIKE type_file.num5
DEFINE     sr    DYNAMIC ARRAY OF RECORD 
                 bgh01 LIKE bgh_file.bgh01,
                 bgh02 LIKE bgh_file.bgh02,
                 bgh03 LIKE bgh_file.bgh03,
                 bgh04 LIKE bgh_file.bgh04,
                 bgh05 LIKE bgh_file.bgh05,
                 bgh06 LIKE bgh_file.bgh06,
                 bgh07 LIKE bgh_file.bgh07,
                 bgh08 LIKE bgh_file.bgh08,
                 bgh09 LIKE bgh_file.bgh09,
                 bgh10 LIKE bgh_file.bgh10,
                 bgh11 LIKE bgh_file.bgh11,
                 bgh11_fac LIKE bgh_file.bgh11_fac,
                 ima44 LIKE ima_file.ima44,
                 ima44_fac LIKE ima_file.ima44_fac
               END RECORD
DEFINE l_fac         LIKE pml_file.pml09
 
 
    LET p_level = p_level + 1                                                                                                              
    IF p_level > 20 THEN                                                        
        CALL cl_err(p_level,'mfg2644',1)                                        
        RETURN                                                                  
    END IF 
    
    LET g_sql ="SELECT bgh_file.*,ima44,ima44_fac",
               "  FROM bgh_file,ima_file",
               " WHERE bgh01 ='",g_bgg01,"'",
               "   AND bgh02 ='",p_key,"'",
               "   AND ima01 =bgh04"
 
 
    PREPARE cralc_ppp FROM g_sql                                            
    IF SQLCA.sqlcode THEN CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN  END IF
    DECLARE cralc_cur CURSOR FOR cralc_ppp 
    
    LET l_ac =1
    FOREACH cralc_cur INTO sr[l_ac].*
       LET l_ac=l_ac+1
       IF l_ac >500 THEN EXIT FOREACH END IF 
    END FOREACH 
    
    FOR l_i=1 TO l_ac-1
        CALL s_umfchk(sr[l_i].bgh04,sr[l_i].bgh11,sr[l_i].ima44) RETURNING g_i,l_fac
        IF g_i = 1 THEN
           CALL cl_err(sr[l_i].bgh04,'abm-731',0) LET l_fac = 1
        END IF
        LET l_total =sr[l_i].bgh06*p_total*(100+sr[l_i].bgh08)/100*l_fac
        IF cl_null(sr[l_i].bgh11_fac) THEN LET sr[l_i].bgh11_fac =1 END IF 
        LET l_qty =l_total*sr[l_i].bgh11_fac
        IF cl_null(l_qty) THEN LET l_qty=0 CONTINUE FOR END IF
        LET l_n=0
        SELECT COUNT(*) INTO l_n FROM bgg_file WHERE bgg02 =sr[l_i].bgh04
        IF l_n >=1 THEN 
           CALL p100_cralc_bom(p_level,sr[l_i].bgh04,p_bgn03,l_qty) 
        ELSE
           INSERT INTO abgp110_tmp VALUES
                  (p_bgn03,sr[l_i].bgh04,sr[l_i].ima44,sr[l_i].ima44_fac,l_qty)
           IF STATUS THEN
              CALL cl_err3("ins","abgp110_tmp","","",STATUS,"","ins tmp:",1) 
              LET g_success='N'  RETURN
           END IF 
        END IF       
    END FOR 
END FUNCTION 
#No.MOD-970135 --end

# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp001.4gl
# Descriptions...: 採購 u/p calcaul
# Input parameter: 
# Return code....: 
# Date & Author..: 92/02/25 By Carol
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.MOD-570111 05/08/04 By Nicola 1.程式沒有考慮系統的匯率參數是取每月或每日,直接使用每日統計檔資料.
#                                                   2.程式沒有考慮本幣別匯率為1的狀況. 所以所有的資料全部運算不出來
# Modify.........: No.FUN-570138 06/03/09 By yiting 批次背景執行
# Modify.........: No.MOD-630108 06/04/18 By pengu 最近採購單價(ima53)及平均採購單價(ima91)沒有轉換為庫存單位,
                          #                        因為單價與數量都乘以轉換率所以互相抵銷
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-610085 06/07/20 By Pengu 1.畫面條件選項增加外幣單價換算本幣之匯率採用
                                  #                2.畫面下方的注意移除第二項
# Modify.........: No.FUN-680136 06/09/18 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/16 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-6B0009 07/02/09 By rainy 新增勾選是否更新採購單價
# Modify.........: No.MOD-850282 08/05/28 By Smapmin 更新ima53最近採購單價時,未考慮採購量=0的情況,仍以金額/數量,使得最近採購單價update錯誤!
# Modify.........: No.MOD-880160 08/08/21 By Smapmin 延續MOD-630108
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0108 09/12/14 By Smapmin 最近/平均單價的計算應同apmp554的計算方式
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          wc	LIKE type_file.chr1000,   #No.FUN-680136 VARCHAR(200)
          bdate	LIKE type_file.dat,       #No.FUN-680136 DATE
          edate	LIKE type_file.dat,       #No.FUN-680136 DATE
          a     LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)  #No.FUN-610085 add
          b     LIKE type_file.chr1       #FUN-6B0009
          END RECORD,
       g_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
DEFINE l_flag          LIKE type_file.chr1,    #No.FUN-570138  #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,    # Prog. Version..: '5.30.06-13.03.12(01)   #是否有做語言切換 No.FUN-570138
       ls_date         STRING                  #->No.FUN-570138
   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570138 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.wc    = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(3)
   LET tm.edate = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570138 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p001_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL apmp001()
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
               CLOSE WINDOW p001_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p001_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL apmp001()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION p001_tm()
   DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)  #No.FUN-570138
 
   IF s_shut(0) THEN RETURN END IF
 
   OPEN WINDOW p001_w WITH FORM "apm/42f/apmp001" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.a = '1'                            #No.FUN-610085 add
      CONSTRUCT BY NAME tm.wc ON ima01,ima08 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       
        ON ACTION locale                    #genero
#NO.FUN-570138 mark--
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570138 mark--
           LET g_change_lang = TRUE
           EXIT CONSTRUCT
       
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
#NO.FUN-570138 start--  
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE 
#     END IF
 
#     IF INT_FLAG THEN 
#        LET INT_FLAG = 0
#        EXIT WHILE
#     END IF
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#NO.FUN-570138 end--------
     LET g_bgjob = 'N' #NO.FUN-570138 
     #INPUT BY NAME tm.bdate,tm.edate WITHOUT DEFAULTS 
     INPUT BY NAME tm.bdate,tm.edate,tm.a,tm.b,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570138  #No.FUN-610085 add tm.a  #FUN-6B0009 add tm.b
       #FUN-6B0009--begin
         BEFORE INPUT
           LET tm.b = 'N'
           DISPLAY BY NAME tm.b
       #FUN-6B0009--end
         AFTER FIELD bdate
            IF tm.bdate IS NULL THEN NEXT FIELD bdate END IF
         AFTER FIELD edate
            IF tm.edate IS NULL THEN NEXT FIELD edate END IF
        #------------No.FUN-610085 add
         AFTER FIELD a
            IF tm.a IS NULL THEN NEXT FIELD a END IF
        #------------No.FUN-610085 end
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
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT INPUT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
        #->No.FUN-570138 --start--
           #LET g_action_choice='locale'
            LET g_change_lang = TRUE
        #->No.FUN-570138 ---end---
            EXIT INPUT
 
      END INPUT
 
#NO.FUN-570138 mark+---
#      IF INT_FLAG THEN 
#         LET INT_FLAG = 0  
#         EXIT WHILE 
#      END IF
#
#      IF cl_sure(10,10) THEN
#
#         BEGIN WORK
#
#         LET g_success = 'Y' 
#         CALL apmp001()
#
#         IF g_success = 'Y' THEN 
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#         END IF 
#         IF g_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#     END IF 
#NO.FUN-570138 mark--
 
#NO.FUN-570138 start--
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp001"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp001','9031',1)
        ELSE
           LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.wc CLIPPED ,"'",
                        " '",tm.bdate CLIPPED ,"'",
                        " '",tm.edate CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp001',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p001_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
    EXIT WHILE
    #->No.FUN-570138 ---end---
   END WHILE
END FUNCTION
 
FUNCTION apmp001()
   DEFINE l_sql		LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(500)
          l_msg  	LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
          l_cnt         LIKE type_file.num5,    #No.FUN-680136 SMALLINT
          l_ima01       LIKE ima_file.ima01,    #No.MOD-490217	
          l_ima44       LIKE ima_file.ima44,    #MOD-9C0108
          l_ima908      LIKE ima_file.ima908,   #MOD-9C0108
          l_maxdate     LIKE type_file.dat,     #No.FUN-680136 DATE
         #l_price1,l_price2	DECIMAL(12,3)
          l_price1      LIKE ima_file.ima91, #FUN-4C0011
          l_price2      LIKE ima_file.ima53  #FUN-4C0011
    DEFINE l_pmm04       LIKE pmm_file.pmm04   #No.MOD-570111
    DEFINE l_pmm22       LIKE pmm_file.pmm22   #No.MOD-570111
    DEFINE l_pmm42       LIKE pmm_file.pmm42   #No.FUN-610085 add
    DEFINE l_pmn31       LIKE pmn_file.pmn31   #No.MOD-570111
    DEFINE l_pmn20       LIKE pmn_file.pmn20   #No.MOD-570111
    DEFINE l_pmn09       LIKE pmn_file.pmn09   #No.MOD-570111
    DEFINE l_pmn86       LIKE pmn_file.pmn86   #MOD-9C0108
    DEFINE l_pmn87       LIKE pmn_file.pmn87   #MOD-9C0108
    DEFINE l_rate        LIKE azk_file.azk03   #No.MOD-570111
    DEFINE l_azj02       LIKE azj_file.azj02   #No.MOD-570111
    DEFINE l_sum01       LIKE pmn_file.pmn31   #No.MOD-570111
    DEFINE l_sum02       LIKE pmn_file.pmn31   #No.MOD-570111
    DEFINE l_unitrate    LIKE pmn_file.pmn121  #MOD-9C0108
    DEFINE l_sw          LIKE type_file.num10  #MOD-9C0108
    DEFINE l_azj03       LIKE azj_file.azj03   #MOD-9C0108
 
 
     #LET l_sql = "SELECT ima01,ima53 FROM ima_file",   #MOD-9C0108
     LET l_sql = "SELECT ima01,ima53,ima44,ima908 FROM ima_file",   #MOD-9C0108
                 "  WHERE ",tm.wc CLIPPED,
                 "  ORDER BY ima01 "
     PREPARE p001_prepare FROM l_sql
     IF SQLCA.sqlcode THEN 
        CALL cl_err('prepare p001_prepare',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF  
 
     DECLARE p001_cur CURSOR FOR p001_prepare
     IF SQLCA.sqlcode THEN 
        CALL cl_err('declare p001_cur',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF  
 
      #-----No.MOD-570111-----
     #LET l_sql = "SELECT pmm04,pmm22,pmm42,pmn31,pmn20,pmn09",    #No:FUN-610085 add pmm42   #MOD-9C0108
     LET l_sql = "SELECT pmm04,pmm22,pmm42,pmn31,pmn20,pmn09,pmn86,pmn87",    #MOD-9C0108
                 "  FROM pmn_file,pmm_file",
                 " WHERE pmn04=? ",
                 "   AND pmn01=pmm01",
                 "   AND pmm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
                 "   AND pmn31 > 0",
                 "   AND pmm18='Y' AND pmmacti='Y'"
     PREPARE p001_spre FROM l_sql
     DECLARE p001_scur CURSOR FOR p001_spre
      #-----No.MOD-570111 END-----
 
     LET l_cnt = 0
     CALL s_showmsg_init()   #No.FUN-710030
     #FOREACH p001_cur INTO l_ima01,l_price2   #MOD-9C0108
     FOREACH p001_cur INTO l_ima01,l_price2,l_ima44,l_ima908   #MOD-9C0108
       IF SQLCA.sqlcode THEN 
#No.FUN-710030 -- begin --
#          CALL cl_err('foreach p001_cur',SQLCA.sqlcode,1)
          IF g_bgerr THEN
             CALL s_errmsg('','','foreach p001_cur',SQLCA.sqlcode,1)
          ELSE
             CALL cl_err('foreach p001_cur',SQLCA.sqlcode,1)
          END IF
#No.FUN-710030 -- end --
          LET g_success = 'N'
          EXIT FOREACH 
       END IF  
#No.FUN-710030 -- begin --
       IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success='Y'
       END IF
#No.FUN-710030 -- end --

        #-----MOD-9C0108---------
        IF cl_null(l_ima908) THEN LET l_ima908 = l_ima44 END IF
        IF g_sma.sma116 MATCHES '[13]' THEN
           LET l_ima44 = l_ima908
        END IF
        #-----END MOD-9C0108-----
 
        #-----No.MOD-570111-----
        LET l_sum01 = 0
        LET l_sum02 = 0
        #FOREACH p001_scur USING l_ima01 INTO l_pmm04,l_pmm22,l_pmm42,l_pmn31,l_pmn20,l_pmn09    #No:FUN-610085 modify   #MOD-9C0108
        FOREACH p001_scur USING l_ima01 INTO l_pmm04,l_pmm22,l_pmm42,l_pmn31,l_pmn20,l_pmn09,l_pmn86,l_pmn87   #MOD-9C0108
           #-----MOD-9C0108---------
           IF NOT cl_null(l_pmn86) AND l_pmn86 <> l_ima44 THEN 
              LET l_unitrate = 1
              CALL s_umfchk(l_ima01,l_pmn86,l_ima44)
              RETURNING l_sw,l_unitrate
              IF l_sw THEN
                 LET l_unitrate = 1
              END IF
              LET l_pmn31 = l_pmn31/l_unitrate   
           END IF
           #-----END MOD-9C0108-----
           LET l_rate = 0
           IF tm.a = '1'  THEN         #No.FUN-610085 add
              IF g_aza.aza19 = "1" THEN
                 LET l_azj02 = YEAR(l_pmm04) USING "&&&&" CLIPPED,MONTH(l_pmm04) USING "&&" CLIPPED
                 SELECT azj03 INTO l_rate FROM azj_file
                  WHERE azj01 = l_pmm22
                    AND azj02 = l_azj02
              ELSE
                 SELECT azk03 INTO l_rate FROM azk_file
                  WHERE azk01 = l_pmm22
                    AND azk02='9999/12/31'
              END IF
         #----------No.FUN-610085 add
          ELSE
             LET l_rate = l_pmm42
          END IF
         #----------No.FUN-610085 end
 
           IF l_rate = 0 OR cl_null(l_rate) THEN
              LET l_rate = 1
           END IF
          #LET l_sum01 = l_sum01 + (l_pmn31 * l_pmn20 * l_rate * l_pmn09)  #No.MOD-630108 mark
           #-----MOD-9C0108---------
           #LET l_sum01 = l_sum01 + (l_pmn31 * l_pmn20 * l_rate)            #No:MOD-630108 add  
           #LET l_sum02 = l_sum02 + (l_pmn20 * l_pmn09)
           LET l_sum01 = l_sum01 + (l_pmn31 * l_pmn87 * l_rate)            #No:MOD-630108 add  
           LET l_sum02 = l_sum02 + l_pmn87 
           #-----END MOD-9C0108-----
        END FOREACH
 
        LET l_price1 = l_sum01 / l_sum02
 
       #No.019 010402 by plum 加上換算率
       #SELECT SUM(pmn31*pmn20*azk03)/SUM(pmn20) INTO l_price1
       #SELECT SUM(pmn31*pmn20*azk03*pmn09)/SUM(pmn20*pmn09) INTO l_price1
       #  FROM pmn_file, pmm_file, azk_file
       #    WHERE pmn04=l_ima01
       #      AND pmn01=pmm01
       #      AND pmm22=azk01 AND azk02='9999/12/31'
       #      AND pmm04 BETWEEN tm.bdate AND tm.edate
       #      AND pmn31 > 0
       #      AND pmm18='Y' AND pmmacti='Y'      #No.+019 add
 
        SELECT MAX(pmm04) INTO l_maxdate FROM pmm_file,pmn_file
            WHERE pmn04=l_ima01 AND pmn01=pmm01
              AND pmm04 BETWEEN tm.bdate AND tm.edate
              AND pmm18='Y' AND pmmacti='Y'      #No.+019 add
              AND pmn20 > 0   #MOD-850282
 
        #-----MOD-9C0108--------- 
        #IF tm.a = '1' THEN          #No.FUN-610085 add
        #   IF g_aza.aza19 = "1" THEN
        #      LET l_azj02 = YEAR(l_maxdate) USING "&&&&" CLIPPED,MONTH(l_maxdate) USING "&&" CLIPPED
        #      #SELECT MAX((pmn31*pmn20*azj03*pmn09)/(pmn20*pmn09))  #MOD-880160
        #      SELECT MAX((pmn31*pmn20*azj03)/(pmn20*pmn09))  #MOD-880160
        #        INTO l_price2
        #        FROM pmn_file,pmm_file,azj_file
        #       WHERE pmn04=l_ima01
        #         AND pmn01=pmm01
        #         AND pmm22=azj01 AND azj02= l_azj02
        #         AND pmm04 = l_maxdate
        #         AND pmn31 > 0
        #         AND pmm18 = 'Y'
        #         AND pmmacti = 'Y'
        #         AND pmn20 > 0   #MOD-850282
        #   ELSE
        #     #SELECT MAX((pmn31*pmn20*azk03*pmn09)/(pmn20*pmn09))   #No.MOD-630108 mark
        #      SELECT MAX((pmn31*pmn20*azk03)/(pmn20*pmn09))         #No.MOD-630108 add
        #        INTO l_price2
        #        FROM pmn_file,pmm_file,azk_file
        #          WHERE pmn04=l_ima01
        #            AND pmn01=pmm01
        #            AND pmm22=azk01 AND azk02='9999/12/31'
        #            AND pmm04 = l_maxdate
        #            AND pmn31 > 0
        #            AND pmm18='Y' AND pmmacti='Y'
        #            AND pmn20 > 0   #MOD-850282
        #   END IF
        ##-------------No.FUN-610085 add
        #ELSE 
        #   SELECT MAX((pmn31*pmn20*pmm42)/(pmn20*pmn09))         
        #     INTO l_price2
        #     FROM pmn_file,pmm_file
        #       WHERE pmn04=l_ima01 
        #         AND pmn01=pmm01
        #         AND pmm04 = l_maxdate
        #         AND pmn31 > 0
        #         AND pmm18='Y' AND pmmacti='Y'
        #         AND pmn20 > 0   #MOD-850282
        #END IF
        #-------------No.FUN-610085 end

        IF tm.a = '1' THEN       
           IF g_aza.aza19 = "1" THEN
              LET l_azj02 = YEAR(l_maxdate) USING "&&&&" CLIPPED,MONTH(l_maxdate) USING "&&" CLIPPED
              LET l_sql = "SELECT pmn31,pmn86,azj03", 
                          " FROM pmn_file,pmm_file,azj_file",
                          "  WHERE pmn04='",l_ima01,"'",
                          "    AND pmn01=pmm01",
                          "    AND pmm22=azj01 AND azj02='",l_azj02,"'",
                          "    AND pmm04 = '",l_maxdate,"'",
                          "    AND pmn31 > 0",
                          "    AND pmm18 = 'Y'",
                          "    AND pmmacti = 'Y'",
                          "    AND pmn20 > 0"  
           ELSE
              LET l_sql = "SELECT pmn31,pmn86,azk03",     
                          " FROM pmn_file,pmm_file,azk_file",
                          "  WHERE pmn04='",l_ima01,"'",
                          "    AND pmn01=pmm01",
                          "    AND pmm22=azk01 AND azk02='9999/12/31'",
                          "    AND pmm04 = '",l_maxdate,"'",
                          "    AND pmn31 > 0",
                          "    AND pmm18='Y' AND pmmacti='Y'",
                          "    AND pmn20 > 0"
           END IF
        ELSE 
           LET l_sql = "SELECT pmn31,pmn86,pmm42",         
                       " FROM pmn_file,pmm_file",
                       "  WHERE pmn04='",l_ima01,"'", 
                       "    AND pmn01=pmm01",
                       "    AND pmm04 = '",l_maxdate,"'",
                       "    AND pmn31 > 0",
                       "    AND pmm18='Y' AND pmmacti='Y'",
                       "    AND pmn20 > 0" 
        END IF
        PREPARE p001_p FROM l_sql
        DECLARE p001_c CURSOR FOR p001_p
        LET l_price2 = 0 
        FOREACH p001_c INTO l_pmn31,l_pmn86,l_azj03
           IF NOT cl_null(l_pmn86) AND l_pmn86 <> l_ima44 THEN 
              LET l_unitrate = 1
              CALL s_umfchk(l_ima01,l_pmn86,l_ima44)
              RETURNING l_sw,l_unitrate
              IF l_sw THEN
                 LET l_unitrate = 1
              END IF
              LET l_pmn31 = l_pmn31/l_unitrate   
           END IF
           LET l_pmn31 = l_pmn31 * l_azj03
           IF l_pmn31 > l_price2 THEN 
              LET l_price2 = l_pmn31
           END IF
        END FOREACH
       #-----END MOD-9C0108-----
 
       ##BugNO:3750
       #SELECT MAX((pmn31*pmn20*azk03*pmn09)/(pmn20*pmn09))
       #  INTO l_price2
       #  FROM pmn_file, pmm_file, azk_file
       #    WHERE pmn04=l_ima01
       #      AND pmn01=pmm01
       #      AND pmm22=azk01 AND azk02='9999/12/31'
       #      AND pmm04 = l_maxdate
       #      AND pmn31 > 0
       #      AND pmm18='Y' AND pmmacti='Y'      #No.+019 add
       #No.+019...end
        #-----No.MOD-570111 END-----
        IF g_bgjob = 'N' THEN   #NO.FUN-570138
            MESSAGE l_ima01,l_price1,l_price2
            CALL ui.Interface.refresh()
        END IF
        IF l_price1 IS NULL THEN LET l_price1=0 END IF
        IF l_price2 IS NULL THEN LET l_price2=0 END IF
 
      #FUN-6B0009 begin
        #UPDATE ima_file SET ima91=l_price1,
        #                    ima53=l_price2,
        #                    ima881=l_maxdate
        # WHERE ima01=l_ima01
       IF tm.b = 'Y' THEN
         UPDATE ima_file SET ima91=l_price1,
                             ima53=l_price2,
                             ima881=l_maxdate,
                             imadate = g_today     #FUN-C30315 add
          WHERE ima01=l_ima01
       ELSE
         UPDATE ima_file SET ima91=l_price1,
                             imadate = g_today     #FUN-C30315 add
         WHERE ima01=l_ima01
       END IF
      #FUN-6B0009 end
         LET l_msg = 'update ',l_ima01 CLIPPED
         IF SQLCA.sqlcode THEN 
#           CALL cl_err(l_msg CLIPPED,SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#            CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            IF g_bgerr THEN
               CALL s_errmsg('ima01',l_ima01,l_msg CLIPPED,SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","",1)
            END IF
#No.FUN-710030 -- end --
            LET g_success = 'N'
#No.FUN-710030 -- begin --
#            EXIT FOREACH                   #No.FUN-710030
            IF g_bgerr  THEN
               CONTINUE FOREACH
            ELSE
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF  
         LET l_cnt = l_cnt + 1
     END FOREACH
#No.FUN-710030 -- begin --
     IF g_totsuccess='N' THEN
        LET g_success='N'
     END IF
#No.FUN-710030 -- end --
 
     IF l_cnt = 0  THEN 
        CALL cl_err('','aap-129',1)
        LET g_success = 'N'
     END IF 
 
END FUNCTION

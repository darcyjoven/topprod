# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp500.4gl
# Descriptions...: ＡＢＣ分群碼計算作業
# Date & Author..: 91/10/28 By Carol
# Modify         : 92/05/01 By David
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4C0021 04/12/02 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-560011 05/06/06 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570122 06/02/16 By Yiting 批次背景執行
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.TQC-610072 06/03/08 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: NO.TQC-640192 06/04/27 BY claire 語法錯誤
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: NO.TQC-680072 06/08/18 BY kim 修正TQC-610072的錯誤
# Modify.........: No.FUN-690026 06/09/18 By Carrier 欄位型態用LIKE定義 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710025 07/01/17 By bnlent  錯誤訊息匯整
# Modify.........: No.TQC-730117 07/03/30 By Judy 執行程序時,系統提示錯誤:加入imj_file表失敗
# Modify.........: No.MOD-830094 08/03/18 By Pengu 若aoos010程式執行記錄設定若選擇'無'時程式會無法使用
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0132 09/12/25 By Pengu 勾選「立即列印結果」錯誤訊息-9646
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-BC0024 11/12/06 By suncx 修正ABC計算方式為'3'和'4'計算邏輯,原邏輯有BUG
# Modify.........: No:MOD-C40184 12/04/24 By ck2yuan 修正sql錯誤
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   b_date          LIKE type_file.dat,     #No.FUN-690026 DATE
         g_wc            string,                 #No.FUN-580092 HCN
         g_sql           string,                 #No.FUN-580092 HCN
        #l_cmd           VARCHAR(30),               #TQC-680072
         l_cmd           STRING,                 #TQC-680072
         g_choi          LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         m_err           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         g_print         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_time          LIKE type_file.chr8,    #No.FUN-6A0074  #No.MOD-830094 add
         p_row,p_col     LIKE type_file.num5     #No.FUN-690026 SMALLINT
DEFINE   g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE   l_flag  LIKE type_file.chr1    #No.FUN-570122  #No.FUN-690026 VARCHAR(1)
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    #No.FUN-570122 --start--
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_wc    = ARG_VAL(1)
    LET g_print = ARG_VAL(2)
    LET g_choi  = ARG_VAL(3)
    LET g_bgjob = ARG_VAL(4)
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
    END IF
    #No.FUN-570122 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
   INITIALIZE b_date  TO NULL
   
    #NO.FUN-570122 MARK-------
    #LET p_row = 1 LET p_col = 12
 
    #OPEN WINDOW p500_w AT p_row,p_col
    #    WITH FORM "aim/42f/aimp500"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    #CALL cl_ui_init()
    #NO.FUN-570122 MARK---
 
   #-------No.MOD-830094 add
    IF NOT cl_null(g_time) THEN
       LET l_time = g_time
    ELSE 
       LET l_time = TIME
    END IF 
   #-------No.MOD-830094 end
 
    WHILE TRUE
       LET g_success = 'Y'
       LET l_time = TIME    #MOD-9C0132 add
       IF g_bgjob = "N" THEN
          CALL p500_a()
          CALL p500_i()
          IF INT_FLAG THEN
             LET INT_FLAG = 0
             CALL cl_err('',9001,0)
             EXIT WHILE
          END IF
          IF cl_sure(21,21) THEN
             CALL cl_wait()
             BEGIN WORK
             CASE
                WHEN g_sma.sma47 = '1'
                   #--->依過去期間使用金額(過去期間使用量*標準成本)
                   CALL p500_p1()
                WHEN g_sma.sma47 = '3'
                   #--->依標準成本
                   CALL p500_p3()
                WHEN g_sma.sma47 = '4'
                   #--->依現時成本
                   CALL p500_p4()
             END CASE
             CALL s_showmsg()       #No.FUN-710025
             IF g_success = 'Y' THEN
                COMMIT WORK
                CALL p500_imj()
                IF g_print = 'Y' THEN
                #TQC-610072-begin
                #LET l_cmd = "aimr500"," ' '  ' '  ' '", " 'N' ",
                #        " ' '  ' ' ", " '",g_wc CLIPPED,"'" 
                #LET g_wc = ' ima06="',g_wc,'" '   #TQC-640192 #TQC-680072 mark
                 LET g_wc = cl_replace_str(g_wc, "'", "\"")                     #MOD-C40184 add
                 LET l_cmd = "aimr500 '",g_today,"' '",g_user,"' '",g_lang,"'", #TQC-680072
                                       " 'N' ' ' '1'",   #TQC-680072
                                      #--------------No:MOD-9C0132 modify
                                      #" '",g_wc,"' '0'"  #TQC-680072
                                       " '0' '",g_wc,"'"  
                                      #--------------No:MOD-9C0132 end
                #TQC-610072-end
                   CALL cl_cmdrun(l_cmd)
                END IF
                CALL cl_end2(1) RETURNING l_flag#批次作業正確結束
             ELSE
                ROLLBACK WORK
                CALL cl_end2(2) RETURNING l_flag#批次作業失敗
             END IF
             IF l_flag THEN
                CONTINUE WHILE
             ELSE
                 CLOSE WINDOW p500_w
                 EXIT WHILE
             END IF
          ELSE
             CONTINUE WHILE
          END IF
       ELSE
          BEGIN WORK
          CASE
             WHEN g_sma.sma47 = '1'
                #--->依過去期間使用金額(過去期間使用量*標準成本)
                CALL p500_p1()
             WHEN g_sma.sma47 = '3'
                #--->依標準成本
                CALL p500_p3()
             WHEN g_sma.sma47 = '4'
                #--->依現時成本
                CALL p500_p4()
          END CASE
          CALL s_showmsg()       #No.FUN-710025
          IF g_success = "Y" THEN
             COMMIT WORK
             CALL p500_imj()
          ELSE
             ROLLBACK WORK
          END IF
          CALL cl_batch_bg_javamail(g_success)
          EXIT WHILE
       END IF
    END WHILE
  #No.FUN-570122 ---end---
 
    #CLOSE WINDOW p500_w  #NO.FUN-570122
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION p500_a()
DEFINE l_flag  LIKE type_file.chr1       #No.FUN-690026 VARCHAR(1)
#DEFINE l_flag  LIKE type_file.chr1      #No.FUN-570122  #No.FUN-690026 VARCHAR(1)
 
    #No.FUN-570122 --Start--
    LET p_row = 1 LET p_col = 12
 
    OPEN WINDOW p500_w AT p_row,p_col
        WITH FORM "aim/42f/aimp500" ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
    #No.FUN-570122 --End--
 
    MESSAGE ""
    CALL ui.Interface.refresh()
    CALL cl_opmsg('a')
    DISPLAY BY NAME g_sma.sma47, g_sma.sma48, g_sma.sma51, g_sma.sma52,
                    g_sma.sma49, g_sma.sma13, g_sma.sma14
    WHILE TRUE
       IF s_shut(0) THEN RETURN END IF
       IF g_sma.sma47 = '1' THEN
          CALL p500_i1()
          IF INT_FLAG THEN
             LET INT_FLAG=0
             EXIT WHILE
          END IF
       END IF
       IF g_sma.sma49 = '1' THEN
          CONSTRUCT g_wc ON ima06 FROM d    
 
             ON ACTION locale
                CALL cl_dynamic_locale()
                CALL cl_show_fld_cont()   #FUN-550037(smin)
            
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
          
          END CONSTRUCT
          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
        #No.FUN-570122 --Start--
        #IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
         IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW p500_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
            EXIT PROGRAM
         END IF
        #No.FUN-570122 --End--
      ELSE 
	 LET g_wc = ' 1=1'
      END IF
 
      #No.FUN-570122 --Start--  Mark  
#      CALL p500_i()
#      IF INT_FLAG THEN
#          LET INT_FLAG = 0
#          CALL cl_err('',9001,0)
#          EXIT WHILE 
#      END IF
#      IF cl_sure(0,0) THEN 
#         CALL cl_wait()
#          LET g_success = 'Y'
#         BEGIN WORK
#         CASE
#            WHEN g_sma.sma47 = '1' 
#               #--->依過去期間使用金額(過去期間使用量*標準成本) 
#               CALL p500_p1()
#            WHEN g_sma.sma47 = '3'
#               #--->依標準成本 
#               CALL p500_p3()
#           WHEN g_sma.sma47 = '4'
#              #--->依現時成本 
#              CALL p500_p4() 
#        END CASE
# 
#        IF g_success='Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#       
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#         END IF
        # IF g_success = 'Y'
        #      THEN CALL cl_cmmsg(1) COMMIT WORK
        #      ELSE CALL cl_rbmsg(1) ROLLBACK WORK
        # END IF
#         ERROR ""
#         CALL p500_imj()
#         IF g_print = 'Y' THEN 
#                LET l_cmd = "aimr500"," ' '  ' '  ' '", " 'N' ",
#                        " ' '  ' ' ", " '",g_wc CLIPPED,"'" 
#            CALL cl_cmdrun(l_cmd) 
#         END IF
#      END IF
#--NO.FUN-570122 MARK-------
       EXIT WHILE
    END WHILE
END FUNCTION
   
FUNCTION p500_i()
DEFINE lc_cmd  LIKE type_file.chr1000  #No.FUN-570122  #No.FUN-690026 VARCHAR(500)
 
#No.FUN-570122 ----Start----
 WHILE TRUE
    LET g_bgjob = 'N'
    LET g_print = 'N'
#No.FUN-570122 ----End----
    #INPUT  g_print WITHOUT DEFAULTS FROM e 
    INPUT  g_print,g_bgjob WITHOUT DEFAULTS FROM e,g_bgjob  #NO.FUN-570122
 
        AFTER FIELD e
            IF g_print IS NULL OR g_print NOT MATCHES "[yYnN]" THEN
                NEXT FIELD e
            END IF
 
        #No.FUN-570122 ----Start----
        AFTER FIELD g_bgjob
            IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
                NEXT FIELD g_bgjob
            END IF
        #No.FUN-570122 ----End----
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
         #No.FUN-570122 ----Start----
         #CALL cl_dynamic_locale()
         LET g_action_choice = "locale"
         #No.FUN-570122 ----End----
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT INPUT    #FUN-570122
 
       ON ACTION exit                            #加離開功能
           LET INT_FLAG = 1
           EXIT INPUT
    
    END INPUT
   #No.FUN-570122 ----Start----
    IF g_action_choice = "locale" THEN
       LET g_action_choice = ""
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
 
    IF INT_FLAG THEN EXIT WHILE END IF
 
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "aimp500"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aimp500','9031',1)
       ELSE
          LET g_wc=cl_replace_str(g_wc, "'", "\"")
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",g_wc CLIPPED,"'",
                       " '",g_print CLIPPED,"'",
                       " '",g_choi  CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('aimp500',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p500_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    EXIT WHILE
 END WHILE
#No.FUN-570122 ----End----
END FUNCTION
   
FUNCTION p500_i1()
    INPUT g_choi   WITHOUT DEFAULTS FROM f 
       AFTER FIELD f
           IF g_choi  IS NULL OR g_choi  NOT MATCHES "[12]" THEN
              NEXT FIELD f
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
       ON ACTION exit                            #加離開功能
           LET INT_FLAG = 1
           EXIT INPUT
    
    END INPUT
END FUNCTION
   
FUNCTION p500_imj()
DEFINE l_wc  LIKE type_file.chr1000 #NO.FUN-570122  #No.FUN-690026 VARCHAR(500)
 
   LET l_wc = g_wc         #NO.FUN-570122
   
   INSERT INTO imj_file(imj01,imj02,imj03,imj04,imj05,imj06,imj07,   #No.MOD-470041
                        imj08,imj09,imj10,imj11,imjplant,imjlegal) #No.FUN-980004
        VALUES(g_today,l_time,g_user,g_sma.sma47,g_sma.sma51,g_sma.sma52,  #TQC-730117 l_time->g_time  #No.MOD-830094 g_time -> l_time
               g_sma.sma49,l_wc,g_sma.sma48,g_sma.sma13,g_sma.sma14,
               g_plant,g_legal)  #No.FUN-980004
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('insert imj_file',SQLCA.sqlcode,1)
      CALL cl_err3("ins","imj_file",g_today,"",SQLCA.sqlcode,"","insert imj_file",1)   #NO.FUN-640266
   END IF
END FUNCTION
 
#--->依過去期間使用金額(過去期間使用量*標準成本) 
FUNCTION p500_p1()
    DEFINE l_rate     LIKE ima_file.ima20    #MOD-530179
    DEFINE g1,g2      LIKE type_file.num10   #No.FUN-690026 INTEGER
    DEFINE l_ima01    LIKE ima_file.ima01,   #料件編號
	   l_ima53    LIKE ima_file.ima53,   #標準成本
	   l_imk05    LIKE imk_file.imk05,   #年
	   l_imk06    LIKE imk_file.imk06,   #期別
	   l_imk083   LIKE imk_file.imk083,  #出庫量
	   l_imk081   LIKE imk_file.imk081,  #入庫量
	   l_imk082   LIKE imk_file.imk082,  #銷售量
           l_ima01_t  LIKE ima_file.ima01,
	   l_sum      ,                      #ABC百分比累計
	   l_amt      LIKE ima_file.ima53,   #過去期間使用量 #No.FUN-690026 DECIMAL(12,2)
	   l_ttl      LIKE ima_file.ima53,   #總數 #No.FUN-690026 DECIMAL(14,2)
	   i	      LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    #------------------ CREATE TEMP TABLE ------------------------------ 
    DROP TABLE temp_x 
    #CREATE TABLE temp_x 
    #( ima01  VARCHAR(20)      ,    #料件編號     #FUN-560011
    #  ima53  DECIMAL(20,6),    #標準成本 #FUN-4C0021
    #  l_amt  INTEGER      #過去期間使用量
    #) ; 
    #No.FUN-690026   --Begin
    CREATE TEMP TABLE temp_x(
      ima01  LIKE ima_file.ima01,
      ima53  LIKE ima_file.ima53,
      l_amt  LIKE type_file.num10); 
    #No.FUN-690026   --End  
 
    #------------------ 計算出合乎範圍總數 ----------------------------- 
    LET g1=g_sma.sma51*12+g_sma.sma52
    LET g2=g1-g_sma.sma48
    LET g_sql = 'SELECT ima01, ima53,',
                '       SUM(imk081), SUM(imk082), SUM(imk083)',
               #MOD-C40184 str add-----
               #'  FROM ima_file, OUTER imk_file', 
               #' WHERE ima_file.ima01 = imk_file.imk01',
               #'   AND imaacti = "Y"',
                '  FROM ima_file LEFT OUTER JOIN imk_file ON ima01=imk01 ',
                ' WHERE imaacti = "Y"',
               #MOD-C40184 end add-----
                '   AND ', g_wc CLIPPED,
                '   AND (imk05*12+imk06) BETWEEN ',g2,' AND ',g1,
                'GROUP BY ima01, ima53'
    PREPARE p500_pb FROM g_sql
    DECLARE p500_cs CURSOR WITH HOLD FOR p500_pb
    LET l_ttl = 0
    LET l_amt = 0
    LET l_ima01_t = null
    CALL s_showmsg_init()     #No.FUN-710025
    FOREACH p500_cs INTO l_ima01, l_ima53, l_imk081, l_imk082, l_imk083
#No.FUN-710025--Begin--
#	IF STATUS THEN CALL cl_err('foreach:',STATUS,0) EXIT FOREACH END IF
	IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,0)
            LET g_success = 'N'   #FUN-8A0086
            EXIT FOREACH
        END IF
#No.FUN-710025--End--
        #--->使用量=入庫量 + 出庫量 + 銷售量
         IF l_ima53   IS NULL THEN LET l_ima53 = 0 END IF
         IF l_imk081  IS NULL THEN LET l_imk081 = 0 END IF
         IF l_imk082  IS NULL THEN LET l_imk082 = 0 END IF
         IF l_imk083  IS NULL THEN LET l_imk083 = 0 END IF
         IF g_choi ='1' THEN
            LET l_amt = l_ima53 * (l_imk081 - l_imk082 - l_imk083)
         ELSE
            LET l_amt = l_ima53 * (l_imk082 +  l_imk083)
         END IF
	 LET l_ttl = l_ttl + l_amt
         INSERT INTO temp_x VALUES(l_ima01, l_ima53, l_amt)
	#MESSAGE l_ima01,l_ima53,l_imk083,l_amt,STATUS
    END FOREACH 
 
    #---> 歸類 ABC, ORDER BY 成本, 使用量 DESC
    DECLARE p500_cs1 CURSOR WITH HOLD FOR
           SELECT temp_x.ima01, temp_x.ima53, temp_x.l_amt 
             FROM temp_x
            ORDER BY temp_x.l_amt DESC
 
    IF l_ttl = 0 THEN LET l_ttl=1 END IF
    LET l_sum  = 0
    FOREACH p500_cs1 INTO l_ima01,l_ima53, l_amt
       #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       #No.FUN-710025--End-- 
	    IF SQLCA.sqlcode THEN
       #No.FUN-710025--Begin--
       #    CALL cl_err('foreach:',SQLCA.sqlcode,0)
            CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
       #No.FUN-710025--End--
	    END IF
        LET l_sum  = l_sum  + l_amt
	    #--->計算 A 料的分群資料
	    IF (l_sum  / l_ttl) * 100 <= g_sma.sma13 THEN
              LET l_rate =l_amt/l_ttl*100
#DISPLAY l_ima01,l_amt,l_rate,' A'   #CHI-A70049 mark
{ckp#1}       #UPDATE ima_file SET (ima07,ima20) = ('A',l_rate)                     #FUN-C30315 mark
               UPDATE ima_file SET ima07 = 'A',iam20 = l_rate,imadate = g_today     #FUN-C30315 add imadate
	            WHERE ima01 = l_ima01
     	        IF SQLCA.sqlcode THEN
                   LET g_success='N' 
#                  CALL cl_err('(p400_t:ckp#1)',SQLCA.sqlcode,1)   #No.FUN-660156
                #No.FUN-710025--Begin--
                #  CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#1)",1)  #No.FUN-660156
                #  RETURN
                   CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#1)',SQLCA.sqlcode,1) 
                   CONTINUE FOREACH
                #No.FUN-710025--End--
	            END IF
	    ELSE 
     	     #--->計算 B 料的分群資料
             IF  (l_sum  / l_ttl) * 100 <= g_sma.sma14 THEN
                  LET l_rate =l_amt/l_ttl*100
#DISPLAY l_ima01,l_amt,l_rate,' B'   #CHI-A70049 mark
{ckp#2}          #UPDATE ima_file SET (ima07,ima20) = ('B',l_rate)        #FUN-C30315 mark
                  UPDATE ima_file SET ima07 = 'B' ,ima20 = l_rate ,imadate = g_today     #FUN-C30315 add imadate
                   WHERE ima01 = l_ima01
	               IF SQLCA.sqlcode THEN
                      LET g_success='N' 
#                     CALL cl_err('(p400_t:ckp#2)',SQLCA.sqlcode,1)   #No.FUN-660156 MARK
                  #No.FUN-710025--Begin--
                  #   CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#2)",1)  #No.FUN-660156
                  #   RETURN
                      CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#2)',SQLCA.sqlcode,1)
                      CONTINUE FOREACH
                  #No.FUN-710025--End--
	               END IF
             ELSE
     	         #--->計算 C 料的分群資料
                  LET l_rate =l_amt/l_ttl*100
#DISPLAY l_ima01,l_amt,l_rate,' C'   #CHI-A70049 mark
     {ckp#3}     #UPDATE ima_file SET (ima07,ima20) = ('C',l_rate)       #FUN-C30315 mark
                  UPDATE ima_file SET ima07 = 'C' ,ima20 = l_rate ,imadate = g_today     #FUN-C30315 add imadate
                   WHERE ima01 = l_ima01
	               IF SQLCA.sqlcode THEN
                      LET g_success='N' 
#                     CALL cl_err('(p400_t:ckp#3)',SQLCA.sqlcode,1) #No.FUN-660156 MARK
                  #No.FUN-710025--Begin--
                  #   CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#3)",1)  #No.FUN-660156
                  #   RETURN
                      CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#3)',SQLCA.sqlcode,1)
                      CONTINUE FOREACH
                  #No.FUN-710025--End--
	               END IF
             END IF
	    END IF
    END FOREACH  
    #No.FUN-710025--Begin--                                                                                                             
    IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
    END IF                                                                                                                           
   #No.FUN-710025--End--  
    DROP TABLE temp_x
END FUNCTION
   
 
#--->依標準成本 
FUNCTION p500_p3()
DEFINE
   l_ima01    LIKE ima_file.ima01,
   l_ima53    LIKE ima_file.ima53,
   l_err      LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
   l_sum      LIKE ima_file.ima53,   #FUN-4C0021  #No.FUN-690026 DECIMAL(20,6)
   l_ttl      LIKE ima_file.ima53,   #FUn-4C0021  #No.FUN-690026 DECIMAL(20,6)
   l_amt      LIKE ima_file.ima53,   #FUN-BC0024 add
   l_rate     LIKE ima_file.ima20    #FUN-BC0024 add

    CALL p500_create_temp_table()    #FUN-BC0024 add
    
    LET g_sql = "SELECT ima01, ima53 ",
                "  FROM ima_file",
                " WHERE imaacti = 'Y' ",
                "   AND ", g_wc CLIPPED,
                " ORDER BY ima01"
 
    PREPARE p500_pb3 FROM g_sql
    DECLARE p500_cur3 CURSOR WITH HOLD FOR p500_pb3
    LET l_ttl = 0
    CALL s_showmsg_init()     #No.FUN-710025
    FOREACH p500_cur3 INTO l_ima01, l_ima53 
       #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       #No.FUN-710025--End-- 
	    IF SQLCA.sqlcode THEN
       #No.FUN-710025--Begin--
       #    CALL cl_err('foreach:',SQLCA.sqlcode,0)
            CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)
            EXIT FOREACH
       #No.FUN-710025--End--
	    END IF
		LET l_sum =0
		CALL s_untcst('1',l_ima01,'') RETURNING l_err,l_sum
		CASE l_err
		    WHEN '0'      
	            LET l_ttl = l_ttl + l_sum 
                #FUN-BC0024 add begin------------
                INSERT INTO temp_x VALUES(l_ima01,l_ima53,l_sum)
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('','','INSERT INTO temp_x',SQLCA.sqlcode,0)
                END IF
                #FUN-BC0024 add end--------------
            WHEN '1'
            #No.FUN-710025--Begin--
            #   CALL cl_err(l_ima01,'mfg6062',0)
	    #   EXIT PROGRAM
                CALL s_errmsg('','',l_ima01,'mfg6062',0)
                CONTINUE FOREACH
            #No.FUN-710025--End--
            WHEN '2'
            #No.FUN-710025--Begin--
            #   CALL cl_err(l_ima01,'mfg6063',0)
	    #   EXIT PROGRAM
                CALL s_errmsg('','',l_ima01,'mfg6063',0)
            #No.FUN-710025--End--
        END CASE
    END FOREACH 
        #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
        #No.FUN-710025--End--
 
 
    #---> 歸類 ABC, ORDER BY 成本
   #FUN-BC0024 mod strat-------------
   #DECLARE p500_cs3 CURSOR WITH HOLD FOR
   #       SELECT ima01,ima53
   #         FROM ima_file
   #        WHERE imaacti = 'Y'
   #        ORDER BY ima53 DESC
    DECLARE p500_cs3 CURSOR WITH HOLD FOR
           SELECT temp_x.ima01,temp_x.ima53,temp_x.l_amt
             FROM temp_x
            ORDER BY temp_x.l_amt DESC
   #FUN-BC0024 mod end----------------
    LET l_sum  = 0
    LET l_amt  = 0  #FUN-BC0024 add
   #FOREACH p500_cs3 INTO l_ima01,l_ima53     # ABC分群
    FOREACH p500_cs3 INTO l_ima01,l_ima53,l_amt  #FUN-BC0024 add l_amt
       #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
       #No.FUN-710025--End-
 
	    IF SQLCA.sqlcode THEN
            #No.FUN-710025--Begin--
            #   CALL cl_err('foreach:',SQLCA.sqlcode,0)
                CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)
                EXIT FOREACH
            #No.FUN-710025--End--
	    END IF
		#CALL s_untcst('1',l_ima01,0) returning l_err,l_sum  #FUN-BC0024 mark
        LET l_sum  = l_sum  + l_amt  #FUN-BC0024 add
	    #------------------ A -------------------------------------
	    IF (l_sum  / l_ttl) * 100 <= g_sma.sma13 THEN
           LET l_rate =l_amt/l_ttl*100  #FUN-BC0024 add
{ckp#4}     UPDATE ima_file
	           SET ima07 = 'A', imamodu = g_user, imadate = g_today,
                   ima20 = l_rate     #FUN-BC0024 add
	         WHERE ima01 = l_ima01
	       IF SQLCA.sqlcode THEN
                  LET g_success='N' 
#                 CALL cl_err('(p400_t:ckp#4)',SQLCA.sqlcode,1)  #No.FUN-660156 MARK
            #No.FUN-710025--Begin--
            #     CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#4)",1)  #No.FUN-660156
            #     RETURN
                  CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#4)',SQLCA.sqlcode,1)
                  CONTINUE FOREACH
            #No.FUN-710025--End--
	       END IF
	    ELSE 
	    #------------------ B -------------------------------------
           IF (l_sum  / l_ttl) * 100 <= g_sma.sma14 THEN
              LET l_rate =l_amt/l_ttl*100  #FUN-BC0024 add
{ckp#5}       UPDATE ima_file
                 SET ima07 = 'B', imamodu = g_user, imadate = g_today,
                     ima20 = l_rate     #FUN-BC0024 add    
               WHERE ima01 = l_ima01
              IF SQLCA.sqlcode THEN
                 LET g_success='N' 
#                CALL cl_err('(p400_t:ckp#5)',SQLCA.sqlcode,1)  #No.FUN-660156 MARK
                 #No.FUN-710025--Begin--
                 #  CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#5)",1)  #No.FUN-660156
                 #  RETURN
                 CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#5)',SQLCA.sqlcode,1)
                 CONTINUE FOREACH
                 #No.FUN-710025--End--
              END IF
           ELSE
	    #------------------ C -------------------------------------
              LET l_rate =l_amt/l_ttl*100  #FUN-BC0024 add
{ckp#6}       UPDATE ima_file
                 SET ima07 = 'C', imamodu = g_user, imadate = g_today,
                     ima20 = l_rate     #FUN-BC0024 add  
               WHERE ima01 = l_ima01
              IF SQLCA.sqlcode THEN
                 #     CALL cl_err(l_ima01,SQLCA.sqlcode,0)
                 LET g_success='N' 
#                CALL cl_err('(p400_t:ckp#6)',SQLCA.sqlcode,1)   #No.FUN-660156 MARK
                 #No.FUN-710025--Begin--
                 #  CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#6)",1)  #No.FUN-660156
                 #  RETURN
                 CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#6)',SQLCA.sqlcode,1)
                 CONTINUE FOREACH
                 #No.FUN-710025--End--
              END IF
	 	   END IF
	    END IF
    END FOREACH 
    #No.FUN-710025--Begin--                                                                                                             
    IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
    END IF                                                                                                                           
    #No.FUN-710025--End--
    DROP TABLE temp_x   #FUN-BC0024 add
END FUNCTION
# 4:依現時成本 
FUNCTION p500_p4()
    DEFINE
           l_ima01    LIKE ima_file.ima01,
	   l_ima53    LIKE ima_file.ima53,
	   l_sum      LIKE ima_file.ima53,   #FUN-4C0021  #No.FUN-690026 DECIMAL(20,6)
	   l_err      LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
	   l_ttl      LIKE ima_file.ima53,   #FUN-4C0021  #No.FUN-690026 DECIMAL(20,6)
       l_amt      LIKE ima_file.ima53,   #FUN-BC0024 add
       l_rate     LIKE ima_file.ima20    #FUN-BC0024 add

    CALL p500_create_temp_table()    #FUN-BC0024 add
 
    #------------------ 計算出合乎範圍總數 ----------------------------- 
    LET g_sql = 'SELECT ima01, ima53',
                '  FROM ima_file',
                ' WHERE imaacti = "Y"',
                '   AND ', g_wc CLIPPED,
                ' ORDER BY ima01'
    PREPARE p500_pb4 FROM g_sql
    DECLARE p500_cur4 CURSOR WITH HOLD FOR p500_pb4
    LET l_ttl = 0
    CALL s_showmsg_init()     #No.FUN-710025
    FOREACH p500_cur4 INTO l_ima01, l_ima53 #計算總數
    #No.FUN-710025--Begin--                                                                                                      
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
    #No.FUN-710025--End-
 
	    IF SQLCA.sqlcode THEN
            #No.FUN-710025--Begin--
            #   CALL cl_err('foreach:',SQLCA.sqlcode,0)
                CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)
                EXIT FOREACH
            #No.FUN-710025--End--
	    END IF
		LET l_sum =0
		CALL s_untcst('2',l_ima01,'') returning l_err,l_sum
		CASE l_err
		    WHEN '0'      
	            LET l_ttl = l_ttl + l_sum 
                #FUN-BC0024 add begin------------
                INSERT INTO temp_x VALUES(l_ima01, l_ima53, l_sum)
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('','','INSERT INTO temp_x',SQLCA.sqlcode,0)
                END IF
                #FUN-BC0024 add end--------------
            WHEN '1'
            #No.FUN-710025--Begin--
            #   CALL cl_err(l_ima01,'mfg6062',0)
            #   EXIT PROGRAM
                CALL s_errmsg('','',l_ima01,'mfg6062',0)
                CONTINUE FOREACH
            #No.FUN-710025--End--
            WHEN '2'
            #No.FUN-710025--Begin--
	    #   CALL cl_err(l_ima01,'mfg6063',0)
                CALL s_errmsg('','',l_ima01,'mfg6063',0)
            #No.FUN-710025--End--
        END CASE
    END FOREACH 
    #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
   #No.FUN-710025--End--
 
 
   #------------------ 歸類 ABC, ORDER BY 成本 ------------------------------- 
   #FUN-BC0024 mod strat------------- 
   #DECLARE p500_cs4 CURSOR WITH HOLD FOR
   #       SELECT ima01,ima53
   #         FROM ima_file
   #        WHERE imaacti = 'Y'
   #        ORDER BY ima53 DESC
    DECLARE p500_cs4 CURSOR WITH HOLD FOR
           SELECT temp_x.ima01,temp_x.ima53,temp_x.l_amt
             FROM temp_x
            ORDER BY temp_x.l_amt DESC
   #FUN-BC0024 mod end---------------
    LET l_sum  = 0
   #FOREACH p500_cs4 INTO l_ima01,l_ima53     # ABC分群
    FOREACH p500_cs4 INTO l_ima01,l_ima53,l_amt  #FUN-BC0024 add l_amt
           #No.FUN-710025--Begin--                                                                                                      
            IF g_success='N' THEN                                                                                                        
               LET g_totsuccess='N'                                                                                                      
               LET g_success="Y"                                                                                                         
            END IF                                                                                                                       
           #No.FUN-710025--End-
 
	    IF SQLCA.sqlcode THEN
           #No.FUN-710025--Begin--
           #    CALL cl_err('foreach:',SQLCA.sqlcode,0)
                CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)
                EXIT FOREACH
           #No.FUN-710025--End--
	    END IF
		#CALL s_untcst('2',l_ima01,0) returning l_err,l_sum  #FUN-BC0024 mark
        LET l_sum  = l_sum  + l_amt  #FUN-BC0024 add
	    #------------------ A -------------------------------------
	    IF (l_sum  / l_ttl) * 100 <= g_sma.sma13 THEN
           LET l_rate =l_amt/l_ttl*100  #FUN-BC0024 add
{ckp#7}    UPDATE ima_file
              SET ima07 = 'A', imamodu = g_user, imadate = g_today,
                  ima20 = l_rate     #FUN-BC0024 add  
            WHERE ima01 = l_ima01
	       IF SQLCA.sqlcode THEN
                  LET g_success='N' 
#                 CALL cl_err('(p400_t:ckp#7)',SQLCA.sqlcode,1)  #No.FUN-660156 MARK
           #No.FUN-710025--Begin--
           #      CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#7)",1)  #No.FUN-660156
           #      RETURN
                  CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#7)',SQLCA.sqlcode,1)
                  CONTINUE FOREACH
           #No.FUN-710025--End--
	       END IF
	    ELSE 
	    #------------------ B -------------------------------------
                IF  (l_sum  / l_ttl) * 100 <= g_sma.sma14 THEN
                   LET l_rate =l_amt/l_ttl*100  #FUN-BC0024 add
      {ckp#8}       UPDATE ima_file
	               SET ima07 = 'B', imamodu = g_user, imadate = g_today,
                       ima20 = l_rate     #FUN-BC0024 add
	             WHERE ima01 = l_ima01
	            IF SQLCA.sqlcode THEN
                       LET g_success='N' 
#                      CALL cl_err('(p400_t:ckp#8)',SQLCA.sqlcode,1) #No.FUN-660156 MARK
                   #No.FUN-710025--Begin--
                   #   CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#8)",1)  #No.FUN-660156
                   #   RETURN
                       CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#8)',SQLCA.sqlcode,1)
                       CONTINUE FOREACH
                   #No.FUN-710025--End--
	            END IF
                ELSE
	    #------------------ C -------------------------------------
                  LET l_rate =l_amt/l_ttl*100  #FUN-BC0024 add
     {ckp#9}        UPDATE ima_file
	               SET ima07 = 'C', imamodu = g_user, imadate = g_today,
                       ima20 = l_rate     #FUN-BC0024 add
	             WHERE ima01 = l_ima01
	            IF SQLCA.sqlcode THEN
                       LET g_success='N' 
#                      CALL cl_err('(p400_t:ckp#9)',SQLCA.sqlcode,1)  #No.FUN-660156 MARK
                   #No.FUN-710025--Begin--
                   #   CALL cl_err3("upd","ima_file",l_ima01,"",SQLCA.sqlcode,"","(p400_t:ckp#9)",1)  #No.FUN-660156
                   #   RETURN
                       CALL s_errmsg('ima01',l_ima01,'(p400_t:ckp#9)',SQLCA.sqlcode,1)
                       CONTINUE FOREACH
                   #No.FUN-710025--End--
	            END IF
	 	END IF
	    END IF
    END FOREACH 
    #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
    #No.FUN-710025--End--
    DROP TABLE temp_x   #FUN-BC0024 add 
    
END FUNCTION

#FUN-BC0024 add begin-----
FUNCTION p500_create_temp_table()
   DROP TABLE temp_x 

   CREATE TEMP TABLE temp_x(
      ima01  LIKE ima_file.ima01,
      ima53  LIKE ima_file.ima53,
      l_amt  LIKE type_file.num20_6); 
END FUNCTION 
#FUN-BC0024 add end-------

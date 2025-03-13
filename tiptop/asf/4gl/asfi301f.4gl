# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfi301f.4gl
# Descriptions...: 工單SET替代作業
# Date & Author..: 03/05/06 By Carol
# Modify.........: No:8765 03/11/25 By Melody 加上失效日的判斷
# Modify.........: No.FUN-550067 05/05/30 By Trisy 單據編號加大
# Modify.........: No.MOD-570013 05/08/30 By Pengu arrow 的欄位不使用了
# Modify.........: No.MOD-5A0030 05/10/05 By Sarah 1.備料料號部份欄位位置show錯
#                                                  2.替代完成後,按確認當機
# Modify.........: No.TQC-5A0017 05/10/11 By pengu 1.顯示set備料及取替代的資料時，會有資料顯示位置錯誤的問題
                                          #        2.在做set替代時若有兩筆以上替代料號，卻都只能產生兩筆替代料號。
                                          #        3.在做完set替代後，開啟視窗詢問是否繼續或離開
                                          #        4.set替代中的產生替代單身視窗的資料來源欄位改讀p_ze的資料
                                          #        5.開啟"產生替代單身"視窗時，若按放棄整個程式會當掉
# Modify.........: No.TQC-5A0084 05/11/21 By Pengu 1.set 取替代時,選擇進入[產生備料]-->再選擇 [群組明細]
                                          #          --> ring menu 沒有放棄or 確認鍵顯示
                                          #        2.進入 set取替代作業時,選擇進入[產生備料] -->
                                          #          再選擇 [群組明細] -->程式會被關掉
                                          #        3.進入 set取替代作業時,選擇進入[產生備料]
                                          #           --> 再選擇 [確認] -->程式會被關掉
# Modify.........: No.MOD-5B0096 05/12/20 By Pengu 工單產生set取替代時沒有計算替代料的單位換算率
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-7B0018 08/02/20 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830003 08/03/20 By Pengu 須依據ima70來default sfa11的值
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.TQC-860006 08/07/03 By wujie 做set替代時，沒有考慮半成品的qpa
# Modify.........: No.CHI-7B0034 08/07/08 By sherry 增加被替代料為Key值
# Modify.........: No.FUN-940008 09/05/06 By hongmei GP5.2發料改善
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990059 09/11/02 By jan 取替代時撈資料有效日期改為當前日期
# Modify.........: No:MOD-990119 09/11/10 By Pengu 1.INSERT sfai_file時sfai27未給值
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-A50066 10/06/09 By jan  s_del_sfai()加傳參數
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝
# Modify.........: No:MOD-AA0008 10/10/05 By sabrina SET替代時應考慮最小發料數量，若小於最小發料數量，則要變更數量為最小發料量
# Modify.........: No:MOD-AB0187 10/11/23 By sabrina 改寫發料批量的計算公式
# Modify.........: No:FUN-AC0074 11/04/11 By lixh1 檢查應發數量不可小於工單備置量
# Modify.........: No:TQC-B40050 11/04/26 By destiny 不允许set替代时提示有错误
# Modify.........: No:MOD-C90213 12/09/25 By suncx CALL cl_getmsg('asf-965',g_lang) RETURNING g_msg1的接收返回值的變量錯誤，應該將g_msg1改為g_msg2
# Modify.........: No:MOD-D50262 13/05/29 By suncx 替代回原來料件時,通過cralc_rate()函數取sfa16和sfa161
# Modify.........: No:MOD-D70093 13/07/16 By suncx 将check備料是否存在的SQL中的有效失效日期的條件提到外層循環SQL中
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_sfb           RECORD LIKE sfb_file.*,
    g_bob07 DYNAMIC ARRAY OF LIKE bob_file.bob07,          #No.FUN-680121 DEC(12,3) 
    g_boa02 DYNAMIC ARRAY OF LIKE type_file.num5,          #No.FUN-680121 SMALLINT	
    g_bob03 DYNAMIC ARRAY OF LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_boa           DYNAMIC ARRAY OF RECORD    #程式變數
                    sfa29     LIKE sfa_file.sfa29,
                    sfa03     LIKE sfa_file.sfa03,
                    tot       LIKE type_file.num5,         #No.FUN-680121 SMALLINT
                    sfa26     LIKE sfa_file.sfa26,
                    boa08     LIKE boa_file.boa08
                    END RECORD,
    g_boa1          DYNAMIC ARRAY OF RECORD    #程式變數
                    boa02     LIKE boa_file.boa02,
                    boa03     LIKE boa_file.boa03,
                    boa08     LIKE boa_file.boa08,
                    b         LIKE aab_file.aab02         #No.FUN-680121 VARCHAR(06)
                    END RECORD,
    g_boa2          DYNAMIC ARRAY OF RECORD    #程式變數
                    boa02     LIKE boa_file.boa02,
                    boa03     LIKE boa_file.boa03,
                    boa08     LIKE boa_file.boa08
                    END RECORD,
 
    g_bob           DYNAMIC ARRAY OF RECORD    #程式變數
                    bob04     LIKE bob_file.bob04,
                    ima02     LIKE ima_file.ima02,
                    bob05     LIKE bob_file.bob05,
                    bob06     LIKE bob_file.bob06,
                    bob08     LIKE bob_file.bob08,
                    bob09     LIKE bob_file.bob09
                    END RECORD,
    g_sfa           DYNAMIC ARRAY OF RECORD    #程式變數
                    sfa03     LIKE sfa_file.sfa03,
                    ima02     LIKE ima_file.ima02,
                    sfa08     LIKE sfa_file.sfa08,
                    sfa12     LIKE sfa_file.sfa12,
                    sfa26     LIKE sfa_file.sfa26
                    END RECORD,
    g_sfa1          DYNAMIC ARRAY OF RECORD    #程式變數
                    sfa03     LIKE sfa_file.sfa03,
                    ima02     LIKE ima_file.ima02,
                    sfa08     LIKE sfa_file.sfa08,
                    sfa12     LIKE sfa_file.sfa12,
                    sfa26     LIKE sfa_file.sfa26
                    END RECORD,
    g_sfa1_t        RECORD
                    sfa03     LIKE sfa_file.sfa03,
                    ima02     LIKE ima_file.ima02,
                    sfa08     LIKE sfa_file.sfa08,
                    sfa12     LIKE sfa_file.sfa12,
                    sfa26     LIKE sfa_file.sfa26
                    END RECORD,
    g_sfa2          DYNAMIC ARRAY OF RECORD    #程式變數
                    sfa03b    LIKE sfa_file.sfa03,
                    ima02b    LIKE ima_file.ima02,
                    sfa08b    LIKE sfa_file.sfa08,
                    sfa12b    LIKE sfa_file.sfa12,
                    d         LIKE aab_file.aab02         #No.FUN-680121 VARCHAR(06)
                    END RECORD,
    g_sfa2_s        DYNAMIC ARRAY OF RECORD    #程式變數
                    bob01     LIKE bob_file.bob01,
                    bob02     LIKE bob_file.bob02,
                    bob03     LIKE bob_file.bob03,
                    bob07     LIKE bob_file.bob07,
                    bob08     LIKE bob_file.bob08,
                    bob09     LIKE bob_file.bob09
                    END RECORD,
    g_sfa2_t        RECORD
                    sfa03b    LIKE sfa_file.sfa03,
                    ima02b    LIKE ima_file.ima02,
                    sfa08b    LIKE sfa_file.sfa08,
                    sfa12b    LIKE sfa_file.sfa12,
		    d         LIKE aab_file.aab02         #No.FUN-680121 VARCHAR(06)
                    END RECORD,
    g_base          RECORD
      sfa29         LIKE sfa_file.sfa29, 
      sfa26         LIKE sfa_file.sfa26, 
      boa02         LIKE boa_file.boa02,
      bob03         LIKE bob_file.bob03
                    END RECORD,
    g_check         RECORD
      base1         LIKE boa_file.boa01,
      base2         LIKE boa_file.boa02,
      set1          LIKE bob_file.bob01,
      set2          LIKE bob_file.bob02 
                    END RECORD,
    g_set_ok            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_set1_ok           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_set2_ok           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac                LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_sl                LIKE type_file.num5,         #No.FUN-680121 #目前處理的SCREEN LINE    SMALLINT
    p_row,p_col         LIKE type_file.num5          #No.FUN-680121 SMALLINT
  DEFINE g_argv1        LIKE oea_file.oea01          #No.FUN-680121 #No.FUN-550067   VARCHAR(16)     
 
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_flag           LIKE type_file.chr1          # No.TQC-5A0017 add        #No.FUN-680121 VARCHAR(1)
DEFINE g_msg1,g_msg2    LIKE type_file.chr1000       #No.FUN-680121 #No.TQC-5A0017 add      VARCHAR(20)
DEFINE    g_sfa2_s1       DYNAMIC ARRAY OF RECORD  
                    bob01     LIKE bob_file.bob01,
                    bob02     LIKE bob_file.bob02,
                    bob03     LIKE bob_file.bob03,
                    bob07     LIKE bob_file.bob07,
                    bob08     LIKE bob_file.bob08,
                    bob09     LIKE bob_file.bob09
                    END RECORD
#No.TQC-860006 --end
#FUN-AC0074--begin--add--
DEFINE g_sfa1_a     DYNAMIC ARRAY OF RECORD    #程式變數
                    sfa012     LIKE sfa_file.sfa012,
                    sfa013     LIKE sfa_file.sfa013
                    END RECORD,
       g_sfa1_a1    RECORD
                    sfa012     LIKE sfa_file.sfa012,
                    sfa013     LIKE sfa_file.sfa013
                    END RECORD
#FUN-AC0074--end--add---
 
FUNCTION i301f(p_argv1)
  DEFINE p_argv1       LIKE sfb_file.sfb01,#發料單號
         l_za05        LIKE za_file.za05,
         i             LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
    LET g_argv1 =p_argv1
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00 = '0'
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_argv1
 
 
    LET p_row = 2 LET p_col = 5
 
 
    OPEN WINDOW i301f_w AT p_row,p_col WITH FORM "asf/42f/asfi301f" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("asfi301f") 
 
    LET g_set_ok  = 'N'
    LET g_set1_ok = 'N'
    LET g_set2_ok = 'N'
 
    INITIALIZE  g_check.* TO NULL
    CALL g_sfa.clear()
    CALL g_sfa1.clear() 
    CALL g_sfa2.clear()
    CALL g_sfa2_s.clear()
    CALL g_boa02.clear() 
    CALL g_bob03.clear()
    CALL g_boa.clear() 
    CALL g_boa1.clear()
    CALL g_boa2.clear()
    CALL g_bob.clear() 
    CALL cl_getmsg('asf-964',g_lang) RETURNING g_msg1
   #CALL cl_getmsg('asf-965',g_lang) RETURNING g_msg1   #MOD-C90213 mark
    CALL cl_getmsg('asf-965',g_lang) RETURNING g_msg2   #MOD-C90213 add
 
    CALL i301f_menu()
 
    CLOSE WINDOW i301f_w 
 
END FUNCTION
 
FUNCTION i301f_menu()
 
   WHILE TRUE
      CALL i301f_bp("G")
      CASE g_action_choice
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"       
            IF g_set_ok = 'N' AND
               g_set1_ok = 'Y' AND
               g_set2_ok = 'Y' THEN 
               IF cl_confirm('asf-066') THEN 
                  EXIT WHILE
               END IF 
            ELSE 
               EXIT WHILE
            END IF 
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "generator_allotment_detail"
            CALL i301f_set_1()
         WHEN "generator_set_detail"
            CALL i301f_set_2()
         WHEN "set_sub"
            CALL i301f_set_s()
            IF g_success='Y' THEN
              CALL cl_end2(1) RETURNING g_flag
            ELSE
               CALL cl_end2(2) RETURNING g_flag
            END IF
 
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i301f_set_1()
  DEFINE l_sql      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
         l_exit_sw  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
         i          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_ac       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_sl       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         sr1        RECORD
           sfa29    LIKE sfa_file.sfa29,
           sfa03    LIKE sfa_file.sfa03,
           tot      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           sfa26    LIKE sfa_file.sfa26,
           boa08    LIKE boa_file.boa08,
           boa02    LIKE boa_file.boa02,
           bob03    LIKE bob_file.bob03
                    END RECORD,
         sr2        RECORD
           boa03    LIKE boa_file.boa03,
           boa04    LIKE boa_file.boa04,
           boa05    LIKE boa_file.boa05
                    END RECORD,
         l_sfa29    LIKE sfa_file.sfa29,
         l_cnt      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
         l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
  LET g_action_choice=" "
  LET p_row  = 2 
  LET p_col = 5
 
  OPEN WINDOW i301f_set1 AT p_row,p_col WITH FORM "asf/42f/asfi3011" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_locale("asfi3011")
 
  
  CALL g_boa.clear()
  CALL g_sfa1.clear()
  CALL g_boa02.clear()
  CALL g_bob03.clear()
 
  LET l_sql = "SELECT UNIQUE sfa29,'',COUNT(*),sfa26,boa08,boa02,0 ",
              " FROM sfa_file,boa_file",
              " WHERE sfa01 = '",g_argv1 CLIPPED,"' ",
              "   AND ( sfa26 = '5' ) ", # OR sfa26 = 'T' ) ",
              "   AND sfa06 = 0 ",
              "   AND sfa29 = boa01 ",
              "   AND sfa03 = boa03 ",
              "   AND sfa08 = boa04 ",
              "   AND sfa12 = boa05 ", 
              "   AND boa06 <= '",g_today,"' ",       #FUN-990059
              "   AND ( boa07 IS NULL OR  boa07 > '",g_sfb.sfb071,"' )",
              " GROUP BY sfa29,boa02,sfa26,boa08 ", 
              " ORDER BY sfa29,boa02,sfa26"
  PREPARE i301f_set_11p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_11p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_11c CURSOR FOR i301f_set_11p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_11c',SQLCA.sqlcode,0)
  END IF 
 
  LET l_sql = "SELECT boa03,boa04,boa05 FROM boa_file ",
              " WHERE boa01 = ? ",
              "   AND boa02 = ? ",
             #MOD-D70093 add begin-----------------------------------------
              "   AND boa06 <= '",g_today,"' ",
              "   AND ( boa07 IS NULL OR  boa07 > '",g_sfb.sfb071,"' )",
             #MOD-D70093 add end-------------------------------------------
              " ORDER BY boa03,boa04,boa05 "
  PREPARE i301f_set_12p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_12p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_12c CURSOR FOR i301f_set_12p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_12c',SQLCA.sqlcode,0)
  END IF 
 
  LET l_sql = "SELECT UNIQUE sfa29,'',COUNT(*),sfa26,bob14,bob02,bob03 ",
              " FROM sfa_file,bob_file",
              " WHERE sfa01 = '",g_argv1 CLIPPED,"' ",
              "   AND ( sfa26 = 'T' ) ",
              "   AND sfa06 = 0 ",
              "   AND sfa29 = bob01 ",
              "   AND sfa03 = bob04 ",
              "   AND sfa08 = bob05 ",
              "   AND sfa12 = bob06 ", 
              "   AND bob10 <= '",g_today,"' ", #FUN-990059
              "   AND ( bob11 IS NULL OR  bob11 > '",g_sfb.sfb071,"' )", #No:8765
              " GROUP BY sfa29,bob02,sfa26,bob14,bob03 ", 
              " ORDER BY sfa29,bob02,sfa26"
  PREPARE i301f_set_14p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_14p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_14c CURSOR FOR i301f_set_14p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_14c',SQLCA.sqlcode,0)
  END IF 
 
  LET l_sql = "SELECT bob04,bob05,bob06 FROM bob_file ",
              " WHERE bob01 = ? ",
              "   AND bob02 = ? ",
              "   AND bob03 = ? ",
              "   AND bob10 <= '",g_today,"' ",   #MOD-D70093 add
              "   AND ( bob11 IS NULL OR  bob11 > '",g_sfb.sfb071,"' )", #No:8765
              " ORDER BY bob04,bob05,bob06 "
  PREPARE i301f_set_15p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_15p',SQLCA.sqlcode,0)
  END IF 
  DECLARE i301f_set_15c CURSOR FOR i301f_set_15p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_15c',SQLCA.sqlcode,0)
  END IF 
 
  LET l_cnt=0
  LET g_cnt=0
  #讀取相關群組
  FOREACH i301f_set_11c INTO sr1.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err('FOREACH i301f_set_11c',SQLCA.sqlcode,0)
       EXIT FOREACH 
    END IF 
 
   #讀取群組所有元件料號..............................................
    LET g_success = 'Y' 
    FOREACH i301f_set_12c USING sr1.sfa29,sr1.boa02 INTO sr2.*
       IF SQLCA.sqlcode THEN 
          CALL cl_err('FOREACH i301f_set_12c',SQLCA.sqlcode,0)
          LET g_success = 'N' 
          EXIT FOREACH 
       END IF 
       IF cl_null(sr1.sfa03) THEN LET sr1.sfa03 = sr2.boa03 END IF 
 
      #CHECK工單備料是否存在..........................................
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM sfa_file,boa_file
        WHERE sfa01 = g_argv1
          AND sfa03 = sr2.boa03
          AND sfa08 = sr2.boa04
          AND sfa12 = sr2.boa05
          AND sfa26 = '5'
          AND sfa06 = 0
          AND sfa29 = boa01 
          AND sfa03 = boa03 
          AND sfa08 = boa04 
          AND sfa12 = boa05 
         #AND boa06 <= g_today       #FUN-990059       #MOD-D70093 mark
         #AND ( boa07 IS NULL OR boa07 > g_sfb.sfb071) #MOD-D70093 mark
       IF l_cnt=0  THEN 
          LET g_success = 'N' 
          EXIT FOREACH 
       END IF 
    END FOREACH 
 
   #資料check ok-->放入buffer中
    IF g_success = 'Y' THEN
       LET g_cnt = g_cnt + 1
       LET g_boa[g_cnt].sfa29 = sr1.sfa29
       LET g_boa[g_cnt].sfa03 = sr1.sfa03
       LET g_boa[g_cnt].tot   = sr1.tot
       LET g_boa[g_cnt].sfa26 = sr1.sfa26
       LET g_boa[g_cnt].boa08 = sr1.boa08
       LET g_boa02[g_cnt]     = sr1.boa02
       LET g_bob03[g_cnt]     = sr1.bob03
    END IF
 
  END FOREACH
 
  FOREACH i301f_set_14c INTO sr1.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err('FOREACH i301f_set_14c',SQLCA.sqlcode,0)
       EXIT FOREACH 
    END IF 
 
   #讀取群組所有替代元件料號..............................................
    LET g_success = 'Y' 
    FOREACH i301f_set_15c USING sr1.sfa29,sr1.boa02,sr1.bob03 INTO sr2.*
       IF SQLCA.sqlcode THEN 
          CALL cl_err('FOREACH i301f_set_15c',SQLCA.sqlcode,0)
          LET g_success = 'N' 
          EXIT FOREACH 
       END IF 
       IF cl_null(sr1.sfa03) THEN LET sr1.sfa03 = sr2.boa03 END IF 
 
      #CHECK工單備料是否存在..........................................
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM sfa_file,bob_file
        WHERE sfa01 = g_argv1
          AND sfa03 = sr2.boa03
          AND sfa08 = sr2.boa04
          AND sfa12 = sr2.boa05
          AND sfa26 = 'T'
          AND sfa06 = 0
          AND sfa29 = bob01 
          AND sfa03 = bob04 
          AND sfa08 = bob05 
          AND sfa12 = bob06 
          AND bob02 = sr1.boa02 
          AND bob03 = sr1.bob03 
         #AND bob10 <= g_today       #FUN-990059                 #MOD-D70093 mark
         #AND ( bob11 IS NULL OR bob11 > g_sfb.sfb071)  #No:8765 #MOD-D70093 mark
       IF l_cnt=0  THEN 
          LET g_success = 'N' 
          EXIT FOREACH 
       END IF 
    END FOREACH 
 
 
   #資料check ok-->放入buffer中
    IF g_success = 'Y' THEN 
       LET g_cnt = g_cnt + 1 
       LET g_boa[g_cnt].sfa29 = sr1.sfa29
       LET g_boa[g_cnt].sfa03 = sr1.sfa03
       LET g_boa[g_cnt].tot   = sr1.tot
       LET g_boa[g_cnt].sfa26 = sr1.sfa26
       LET g_boa[g_cnt].boa08 = sr1.boa08 
       LET g_boa02[g_cnt]     = sr1.boa02
       LET g_bob03[g_cnt]     = sr1.bob03
    END IF 
  END FOREACH
 
    DISPLAY ARRAY g_boa TO s_boa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-570013
    
     ON ACTION  GROUP_Detail
        LET l_cnt = ARR_CURR()
        LET l_ac = ARR_CURR()
        IF l_cnt > 0 THEN   #--No.TQC-5A0084  判斷筆數是否大於0
           IF NOT cl_null(g_boa[l_ac].sfa29) THEN
              CALL i301f_q_sfa(g_boa[l_ac].sfa29,g_boa02[l_ac],l_cnt,g_cnt)
           END IF
        ELSE
           CALL cl_err(' ','asf-966',1)    ##--No.TQC-5A0084 add
        END IF
 
 
     ON ACTION accept
        LET l_cnt = ARR_CURR()
     #----No.TQC-5A0084  判斷筆數是否大於0
        IF l_cnt > 0 THEN
           LET g_base.sfa29=g_boa[l_cnt].sfa29
           LET g_base.sfa26=g_boa[l_cnt].sfa26
           LET g_base.boa02=g_boa02[l_cnt]
           LET g_base.bob03=g_bob03[l_cnt]
           EXIT DISPLAY
        ELSE
           EXIT DISPLAY
        END IF
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
 
  DISPLAY g_cnt TO FORMONLY.cn2
 
  IF INT_FLAG THEN 
     LET INT_FLAG = 0
     CLOSE WINDOW i301f_set1 
     RETURN 
  END IF
 
  IF cl_null(g_base.sfa29) THEN 
     LET INT_FLAG = 0
     CLOSE WINDOW i301f_set1 
     RETURN 
  END IF
 
 CLOSE WINDOW i301f_set1 
 
#將工單set替代群組所有元件資料放入備料buffer中
  IF g_base.sfa26 = '5' THEN 
   LET l_sql = "SELECT sfa03,ima02,sfa08,sfa12,sfa26,sfa012,sfa013 ",   #MOD-5A0030 #FUN-AC0074
               " FROM boa_file LEFT OUTER JOIN ima_file ON boa03 = ima01,sfa_file",
               " WHERE boa01 = '",g_base.sfa29 CLIPPED,"' ",
               "   AND boa02 = ",g_base.boa02,
               "   AND sfa01 = '",g_argv1 CLIPPED,"' ",
               "   AND boa03 = sfa03 ",
               "   AND boa04 = sfa08 ",
               "   AND boa05 = sfa12 ",
              #MOD-D70093 add begin-----------------------------------------
               "   AND boa06 <= '",g_today,"' ",
               "   AND ( boa07 IS NULL OR  boa07 > '",g_sfb.sfb071,"' )"
              #MOD-D70093 add end-------------------------------------------
  ELSE 
   LET l_sql = "SELECT sfa03,ima02,sfa08,sfa12,sfa26,sfa012,sfa013 ",   #MOD-5A0030 #FUN-AC0074
               " FROM bob_file LEFT OUTER JOIN ima_file ON bob04 = ima01,sfa_file",
               " WHERE bob01 = '",g_base.sfa29 CLIPPED,"' ",
               "   AND bob02 = ",g_base.boa02,
               "   AND bob03 = ",g_base.bob03,
               "   AND sfa01 = '",g_argv1 CLIPPED,"' ",
               "   AND bob04 = sfa03 ",
               "   AND bob05 = sfa08 ",
               "   AND bob06 = sfa12 ",
               "   AND bob10 <= '",g_today,"' ",   #MOD-D70093 add
               "   AND ( bob11 IS NULL OR  bob11 > '",g_sfb.sfb071,"' )"  #No:8765
  END IF  
  PREPARE i301f_set_13p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_13p',SQLCA.sqlcode,0)
  END IF 
  DECLARE i301f_set_13c CURSOR FOR i301f_set_13p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_13c',SQLCA.sqlcode,0)
  END IF 
 
  CALL g_sfa1.clear()
  CALL g_sfa1_a.clear()  #FUN-AC0074
 
  LET g_set_ok  = 'N' 
  LET g_set1_ok = 'N' 
  LET g_cnt = 0 
  FOREACH i301f_set_13c INTO g_sfa1_t.*,g_sfa1_a1.* #FUN-AC0074
    IF SQLCA.sqlcode THEN 
       CALL cl_err('FOREACH i301f_set_13c',SQLCA.sqlcode,0)
       EXIT FOREACH
    END IF 
    LET g_cnt = g_cnt + 1
    LET g_sfa1[g_cnt].* = g_sfa1_t.*
    LET g_sfa1_a[g_cnt].* = g_sfa1_a1.* #FUN-AC0074
 
    IF g_cnt > 0 THEN
       LET g_set1_ok = 'Y'
    END IF 
 
  END FOREACH
 
#用來check備料跟替代料是否同群組............................
  LET g_check.base1=g_base.sfa29      
  LET g_check.base2=g_base.boa02
#...........................................................
 
  DISPLAY g_cnt TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i301f_set_2()
 
  DEFINE l_sql      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
         l_exit_sw  LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
         i          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_ac       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_sl       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         sr1        RECORD
           boa02    LIKE boa_file.boa02,
           boa03    LIKE boa_file.boa03,
           boa08    LIKE boa_file.boa08,
           b        LIKE aab_file.aab02,        #No.FUN-680121 VARCHAR(06)
           bob07    LIKE boa_file.boa07
                    END RECORD,
        l_sfa29     LIKE sfa_file.sfa29,
        l_cnt            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_allow_insert   LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
        l_allow_delete   LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
  LET g_action_choice=" "
  IF g_set1_ok = 'N' THEN 
     CALL cl_err('','asf-067',1)
     RETURN 
  END IF 
 
  LET p_row = 2 LET p_col = 18
 
  OPEN WINDOW i301f_set2 AT p_row,p_col
       WITH FORM "asf/42f/asfi3013" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_locale("asfi3013")
 
  CALL g_boa1.clear()  
  CALL g_sfa2.clear()  
  CALL g_sfa2_s.clear()
  CALL g_bob07.clear()
 
  #表示未曾被替代過
   LET l_sql = "SELECT UNIQUE boa02,'',boa08,'',0 FROM boa_file ",  #MOD-570013
              " WHERE boa01 = '",g_base.sfa29 CLIPPED,"' ",
              "   AND boa02 = ",g_base.boa02 CLIPPED,
              " ORDER BY boa02"
 
  PREPARE i301f_set_21p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_21p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_21c CURSOR FOR i301f_set_21p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_21c',SQLCA.sqlcode,0)
  END IF 
 
  #表示曾被替代過
    LET l_sql = "SELECT UNIQUE bob03,'',bob14,'',bob07 FROM bob_file ",  #MOD-570013
              " WHERE bob01 = '",g_base.sfa29 CLIPPED,"' ",
              "   AND bob02 = ",g_base.boa02,
              "   AND bob03 != ",g_base.bob03,
              "   AND bob10 <= '",g_today,"' ",      #FUN-990059
              "   AND ( bob11 IS NULL OR bob11 > '",g_sfb.sfb071,"' )", #No:8765
              " ORDER BY bob03"
  PREPARE i301f_set_22p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_22p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_22c CURSOR FOR i301f_set_22p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_22c',SQLCA.sqlcode,0)
  END IF 
 
  LET l_sql = "SELECT boa03 FROM boa_file ",
              " WHERE boa01 = '",g_base.sfa29 CLIPPED,"' ",
              "   AND boa02 =  ? "
  PREPARE i301f_set_23p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_23p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_23c CURSOR FOR i301f_set_23p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_23c',SQLCA.sqlcode,0)
  END IF 
 
  LET l_sql = "SELECT bob04 FROM bob_file ",
              " WHERE bob01 = '",g_base.sfa29 CLIPPED,"' ",
              "   AND bob02 = ",g_base.boa02,
              "   AND bob03 = ? ",
              "   AND ( bob11 IS NULL OR bob11 > '",g_sfb.sfb071,"' )"  #No:8765
  PREPARE i301f_set_24p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_24p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_set_24c CURSOR FOR i301f_set_24p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_24c',SQLCA.sqlcode,0)
  END IF 
 
  LET g_cnt = 0 
 #當備料資料來源為'T' 時,須再取出替代群組bob_file資料
  IF g_base.sfa26 = 'T' THEN 
    #讀取相關替代群組--- boa_file..................................
     FOREACH i301f_set_21c INTO sr1.*
       IF SQLCA.sqlcode THEN 
          CALL cl_err('FOREACH i301f_set_21c',SQLCA.sqlcode,0)
          EXIT FOREACH 
       END IF 
   
      #讀取群組元件料號顯示..........................................
       OPEN i301f_set_23c USING sr1.boa02
       IF SQLCA.sqlcode THEN 
          CALL cl_err('OPEN i301f_set_23c',SQLCA.sqlcode,1)
          LET g_success = 'N' 
       END IF 
 
       FETCH i301f_set_23c INTO sr1.boa03
       IF SQLCA.sqlcode THEN 
          CALL cl_err('OPEN i301f_set_23c',SQLCA.sqlcode,1)
          LET g_success = 'N' 
       END IF 
   
      #資料放入buffer中
       LET g_cnt = g_cnt + 1 
       LET g_boa1[g_cnt].boa02 = sr1.boa02 
       LET g_boa1[g_cnt].boa03 = sr1.boa03
       LET g_boa1[g_cnt].boa08 = sr1.boa08
       LET g_boa1[g_cnt].b = g_msg2       #元件群    #No.TQC-5A0017 add
       LET g_bob07[g_cnt]=0
     END FOREACH
   END IF 
 
  #讀取相關替代群組--- bob_file..................................
   FOREACH i301f_set_22c INTO sr1.*
     IF SQLCA.sqlcode THEN 
        CALL cl_err('FOREACH i301f_set_21c',SQLCA.sqlcode,0)
        EXIT FOREACH 
     END IF 
   
    #讀取群組料號顯示..........................................
     OPEN i301f_set_24c USING sr1.boa02 
     IF SQLCA.sqlcode THEN 
        CALL cl_err('OPEN i301f_set_24c',SQLCA.sqlcode,1)
        LET g_success = 'N' 
     END IF 
 
     FETCH i301f_set_24c INTO sr1.boa03
     IF SQLCA.sqlcode THEN 
        CALL cl_err('OPEN i301f_set_24c',SQLCA.sqlcode,1)
        LET g_success = 'N' 
     END IF 
   
    #資料放入buffer中
     LET g_cnt = g_cnt + 1 
     LET g_boa1[g_cnt].boa02 = sr1.boa02 
     LET g_boa1[g_cnt].boa03 = sr1.boa03
     LET g_boa1[g_cnt].boa08 = sr1.boa08
     LET g_boa1[g_cnt].b = g_msg1       #元件群    #No.TQC-5A0017 add
     LET g_bob07[g_cnt]=sr1.bob07
   END FOREACH
 
    DISPLAY ARRAY g_boa1 TO s_boa1.* ATTRIBUTE(COUNT=g_cnt,UNBUFFERED) #MOD-570013
 
       ON ACTION accept
          LET l_cnt = ARR_CURR()
          EXIT DISPLAY
 
       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   DISPLAY g_cnt TO FORMONLY.cn2
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       CLOSE WINDOW i301f_set2 
       RETURN 
    END IF
  
    CLOSE WINDOW i301f_set2 
  
 #將工單set替代群組所有元件資料放入備料buffer中
  IF g_boa1[l_cnt].b = g_msg2 THEN    #No.TQC-5A0017 add
     LET l_sql = "SELECT boa03,ima02,boa04,boa05,'',boa01,boa02,0,0,0,0,0 ",   #MOD-5A0030
                 " FROM boa_file LEFT OUTER JOIN ima_file ON boa03 = ima01",
                 " WHERE boa01 = '",g_base.sfa29 CLIPPED,"' ",
                 "   AND boa02 = ",g_boa1[l_cnt].boa02
  ELSE 
     LET l_sql = "SELECT bob04,ima02,bob05,bob06,'',bob01,bob02,bob03,bob07,bob08,bob09 ",   #MOD-5A0030
                 " FROM bob_file LEFT OUTER JOIN ima_file ON bob04 = ima01",
                 " WHERE bob01 = '",g_base.sfa29 CLIPPED,"' ",
                 "   AND bob02 = '",g_base.boa02 CLIPPED,"' ",
                 "   AND bob03 = ",g_boa1[l_cnt].boa02,
                 "   AND ( bob11 IS NULL OR bob11 > '",g_sfb.sfb071,"' )"  #No:8765
  END IF 
  PREPARE i301f_set_25p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_set_25p',SQLCA.sqlcode,0)
  END IF 
  DECLARE i301f_set_25c CURSOR FOR i301f_set_25p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_set_25c',SQLCA.sqlcode,0)
  END IF 
 
  CALL g_sfa2.clear()
  CALL g_sfa2_s.clear()
  CALL g_sfa2_s1.clear()         #No.TQC-860006
 
  LET g_set_ok  = 'N' 
  LET g_set2_ok = 'N' 
  LET g_cnt = 1 
  FOREACH i301f_set_25c INTO g_sfa2[g_cnt].*,g_sfa2_s[g_cnt].*
    IF SQLCA.sqlcode THEN 
       CALL cl_err('FOREACH i301f_set_25c',SQLCA.sqlcode,0)
       EXIT FOREACH
    END IF 
    LET g_sfa2[g_cnt].d = g_boa1[l_cnt].b
    LET g_cnt = g_cnt + 1
    IF g_cnt > 1 THEN
       LET g_set2_ok = 'Y'
    END IF 
  END FOREACH
  LET g_cnt = g_cnt - 1
  FOR i=1 TO g_sfa2_s.getLength()
      LET g_sfa2_s1[i].*=g_sfa2_s[i].*
  END FOR
#用來check備料跟替代料是否同群組............................
  LET g_check.set1=g_base.sfa29
  LET g_check.set2=g_base.boa02
#...........................................................
 
 
 
END FUNCTION
 
FUNCTION i301f_set_s()
 DEFINE l_sfa   RECORD LIKE sfa_file.*,
        i       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_n     LIKE type_file.num5,          #No.MOD-5B0096 add #No.FUN-680121 SMALLINT
        l_ima25 LIKE ima_file.ima25           #No.MOD-5B0096 add
 DEFINE l_sfai  RECORD LIKE sfai_file.*       #No.FUN-7B0018
 DEFINE l_ima70 LIKE ima_file.ima70     #No.MOD-830003 add
 DEFINE l_QPA   LIKE bmb_file.bmb06     #No.TQC-860006
#MOD-D50262 add begin-----------------------
 DEFINE l_ActualQPA  LIKE bmb_file.bmb06, 
        l_total      LIKE sfa_file.sfa05
 DEFINE l_bmb081 LIKE bmb_file.bmb081,
        l_bmb08  LIKE bmb_file.bmb08,
        l_bmb082 LIKE bmb_file.bmb082,
        l_bmb06  LIKE bmb_file.bmb06
#MOD-D50262 add end-------------------------
 
  #備料單身與替代單身不為空白時,才可執行此功能
   IF g_set1_ok = 'N' OR g_set2_ok = 'N' THEN 
      CALL cl_err('','asf-064',1)
      RETURN 
   END IF 
 
  #替代料不可為備料所替代
  #--->當備料/替代料選取後,再修改備料為另一組備料時,check替代料是否可為
  #    備料所替代
   IF g_check.base1 !=g_check.set1 OR g_check.base2 !=g_check.set2 THEN
      CALL cl_err('','asf-065',1)
      RETURN 
   END IF 
   IF cl_sure(0,0) THEN 
 
      BEGIN WORK
 
      LET g_success = 'Y' 
 
     #備料單身處理
      FOR i = 1 TO g_sfa1.getLength()
          IF cl_null(g_sfa1[i].sfa03) THEN EXIT FOR END IF   
          SELECT * INTO l_sfa.* FROM sfa_file
           WHERE sfa01 = g_argv1 
             AND sfa03 = g_sfa1[i].sfa03
             AND sfa08 = g_sfa1[i].sfa08
             AND sfa12 = g_sfa1[i].sfa12
             AND sfa26 = g_sfa1[i].sfa26
             AND sfa012= g_sfa1_a[i].sfa012  #FUN-AC0074
             AND sfa013= g_sfa1_a[i].sfa013  #FUN-AC0074
             AND sfaacti = 'Y' 
          IF SQLCA.sqlcode THEN 
             CALL cl_err3("sel","sfa_file",g_argv1,g_sfa1[i].sfa03,SQLCA.sqlcode,"","sel_sfa",1)  #No.FUN-660128
             LET g_success = 'N'
          END IF 
          IF g_success = 'N' THEN EXIT FOR END IF  
#備料單身 替代碼='5'.............................................
          IF l_sfa.sfa26 = '5' THEN
             LET l_sfa.sfa26 = '6' 
             LET l_sfa.sfa161= 0 
             LET l_sfa.sfa05 = 0 
             UPDATE sfa_file SET * = l_sfa.* 
              WHERE sfa01 = g_argv1 
                AND sfa03 = g_sfa1[i].sfa03
                AND sfa08 = g_sfa1[i].sfa08
                AND sfa12 = g_sfa1[i].sfa12
                AND sfa012= g_sfa1_a[i].sfa012  #FUN-AC0074
                AND sfa013= g_sfa1_a[i].sfa013  #FUN-AC0074
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                CALL cl_err3("upd","sfa_file",g_argv1,g_sfa1[i].sfa03,SQLCA.sqlcode,"","upd_sfa_5",1)  #No.FUN-660128
                LET g_success = 'N' 
             END IF 
          ELSE 
#備料單身 替代碼='T',替代料單身....................
             DELETE FROM sfa_file      #備料為替代料
              WHERE sfa01 = g_argv1 
                AND sfa03 = g_sfa1[i].sfa03
                AND sfa08 = g_sfa1[i].sfa08
                AND sfa12 = g_sfa1[i].sfa12
                AND sfa012= g_sfa1_a[i].sfa012  #FUN-AC0074
                AND sfa013= g_sfa1_a[i].sfa013  #FUN-AC0074
             IF SQLCA.sqlcode THEN 
                CALL cl_err3("del","sfa_file",g_argv1,g_sfa1[i].sfa03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                LET g_success = 'N' 
             ELSE    #No.FUN-830132
                IF NOT s_industry('std') THEN
                   IF NOT s_del_sfai(g_argv1,g_sfa1[i].sfa03,
                                     g_sfa1[i].sfa08,g_sfa1[i].sfa12,'','','','') THEN #CHI-7B0034 #FUN-A50066
                      LET g_success = 'N' 
                   END IF
                END IF
             END IF 
          END IF 
          IF g_success = 'N' THEN EXIT FOR END IF  
      END FOR
 
      FOR i = 1 TO g_sfa2.getLength()      #No.TQC-5A0017 add
          IF cl_null(g_sfa2[i].sfa03b) THEN EXIT FOR END IF
#當備料為'5'未set替代 or 備料為'T'set替代料且預替代的料為SET替代群組料時
             IF g_sfa1[1].sfa26 = '5' OR 
                ( g_sfa1[1].sfa26 = 'T' AND g_sfa2[i].d = g_msg1 )   #No.TQC-5A0017 add
             THEN 
#INSERT替代料  ............................................................
                INITIALIZE l_sfa.* TO NULL
                LET l_sfa.sfa01 = g_sfb.sfb01 
                LET l_sfa.sfa02 = g_sfb.sfb02
                LET l_sfa.sfa03 = g_sfa2[i].sfa03b 
                LET l_sfa.sfa04 = g_sfb.sfb08
                LET l_sfa.sfa06 =0
                LET l_sfa.sfa061=0
                LET l_sfa.sfa062=0
                LET l_sfa.sfa063=0
                LET l_sfa.sfa064=0
                LET l_sfa.sfa065=0
                LET l_sfa.sfa066=0
                LET l_sfa.sfa08 = g_sfa2[i].sfa08b
                IF cl_null(l_sfa.sfa08) THEN LET l_sfa.sfa08=' ' END IF
                SELECT bmb18 INTO l_sfa.sfa09 FROM bmb_file
                 WHERE bmb01 = g_sfa2_s[i].bob01 
                   AND bmb03 = g_sfa2[i].sfa03b
                   AND bmb04 <= g_today       #FUN-990059
                   AND ( bmb05 IS NULL OR bmb05 > g_sfb.sfb071 )
                IF cl_null(l_sfa.sfa09) THEN LET l_sfa.sfa09 = 0 END IF 
                LET l_sfa.sfa12 = g_sfa2[i].sfa12b
                SELECT ima55_fac,ima86,ima86_fac,ima70
                  INTO l_sfa.sfa13,l_sfa.sfa14,l_sfa.sfa15,l_ima70
                  FROM ima_file
                 WHERE ima01 = g_sfa2[i].sfa03b
                
                IF l_ima70 = 'Y' THEN
                   LET l_sfa.sfa11 = 'E'
                ELSE
                   LET l_sfa.sfa11 = 'N'
                END IF
               #組成用量(sfa161)=替代料替代量*替代料QPA
               #CALL cralc_bom_qpa(g_sfb.sfb05,'1') RETURNING l_QPA      #No.TQC-860006  #MOD-D50262 mark
                CALL cralc_bom_qpa(g_sfb.sfb05,'1') RETURNING l_total,l_QPA,l_ActualQPA  #MOD-D50262 add 
                LET l_sfa.sfa16 = g_sfa2_s[i].bob07 *l_QPA*              #No.TQC-860006
                                  ( g_sfa2_s[i].bob08 / g_sfa2_s[i].bob09 ) 
               #LET l_sfa.sfa161= l_sfa.sfa16                               #MOD-D50262 mark
                LET l_sfa.sfa161 = g_sfa2_s[i].bob07 *l_ActualQPA *         #MOD-D50262 add
                                  ( g_sfa2_s[i].bob08 / g_sfa2_s[i].bob09 ) #MOD-D50262 add
                LET l_sfa.sfa05 = g_sfb.sfb08 * l_sfa.sfa161          #sfa05的小數位取位在下面的i301f_sfa05()後面
                LET l_sfa.sfa25 = 0
                LET l_sfa.sfa26 = 'T'
                LET l_sfa.sfa27 = g_sfa2[i].sfa03b
                LET l_sfa.sfa28 = g_sfa2_s[i].bob07
                LET l_sfa.sfa29 = g_sfa2_s[i].bob01 
                LET l_sfa.sfaacti ='Y'
               LET l_ima25 = NULL
               SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_sfa.sfa03
               CALL s_umfchk(l_sfa.sfa03,l_sfa.sfa12,l_ima25)
                             RETURNING l_n,l_sfa.sfa13
               IF l_n = 1 THEN
                  CALL cl_err('','mfg3075',0)
                  LET l_sfa.sfa13=1
               END IF
 
                IF cl_null(l_sfa.sfa100) THEN
                   LET l_sfa.sfa100 = 0 
                END IF
               #check最少發料數量/單位取位的問題
#FUN-A70125 --BEGIN--
               IF cl_null(l_sfa.sfa012) THEN
                  LET l_sfa.sfa012 = ' '
               END IF 
               IF cl_null(l_sfa.sfa013) THEN
                  LET l_sfa.sfa013 = 0 
               END IF 
#FUN-A70125 --end--
               #CALL i301f_sfa05(l_sfa.sfa27,l_sfa.sfa05,l_sfa.sfa12)                         #FUN-AC0074
                CALL i301f_sfa05(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,l_sfa.sfa12,l_sfa.sfa27, #FUN-AC0074
                                 l_sfa.sfa012,l_sfa.sfa013,l_sfa.sfa05)                       #FUN-AC0074
                      RETURNING l_sfa.sfa05
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('check_sfa05_inssfa',g_errno,1)
                   LET g_success = 'N'
                END IF
               #因應發數量check上述問題有可能異動,so-->重計實際單位用量 (Actual QPA)
                LET l_sfa.sfa161 = l_sfa.sfa05 / g_sfb.sfb08 
 
               LET l_sfa.sfaplant = g_plant #FUN-980008 add
               LET l_sfa.sfalegal = g_legal #FUN-980008 add
 
                INSERT INTO sfa_file VALUES(l_sfa.*)
                IF SQLCA.sqlcode THEN 
                   CALL cl_err3("ins","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","ins sfa:",1)  #No.FUN-660128
                   LET g_success = 'N' 
                ELSE    #No.FUN-830132 add
                   IF NOT s_industry('std') THEN
                      INITIALIZE l_sfai.* TO NULL
                      LET l_sfai.sfai01 = l_sfa.sfa01
                      LET l_sfai.sfai03 = l_sfa.sfa03
                      LET l_sfai.sfai08 = l_sfa.sfa08
                      LET l_sfai.sfai12 = l_sfa.sfa12
                      LET l_sfai.sfai27 = l_sfa.sfa27      #No:MOD-990119 add
                      IF NOT s_ins_sfai(l_sfai.*,'') THEN
                         LET g_success = 'N' 
                      END IF
                   END IF
                END IF
             ELSE 
#備料單身 替代碼='T',替代料單身 來源為 元件群組......................
                IF g_sfa2[i].d = g_msg2 THEN     #No.TQC-5A0017 add
                   SELECT * INTO l_sfa.* FROM sfa_file
                    WHERE sfa01 = g_argv1 
                      AND sfa03 = g_sfa2[i].sfa03b
                      AND sfa08 = g_sfa2[i].sfa08b
                      AND sfa12 = g_sfa2[i].sfa12b
                      AND sfaacti = 'Y' 
                   IF SQLCA.sqlcode THEN 
                      CALL cl_err3("sel","sfa_file",g_argv1,g_sfa2[i].sfa03b,SQLCA.sqlcode,"","sel_sfa_T",1)  #No.FUN-660128
                      LET g_success = 'N'
                   END IF 
                   IF g_success = 'N' THEN EXIT FOR END IF  
 
                   LET l_sfa.sfa26 = '5' 
 
                   #MOD-D50262 mark begin----------------------
                   #SELECT (bmb06/bmb07)*(1+bmb08/100) 
                   #  INTO l_sfa.sfa16 FROM bmb_file
                   # WHERE bmb01 = l_sfa.sfa29
                   #   AND bmb03 = l_sfa.sfa27 
                   #  AND (bmb04<=g_today OR bmb04 IS NULL)     #FUN-990059
                   #  AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)
 
                   #LET l_sfa.sfa161= l_sfa.sfa16
                   #MOD-D50262 mark end------------------------
                   #MOD-D50262 add begin-------------------------------------------
                   SELECT bmb081,bmb08,bmb082,bmb06/bmb07
                     INTO l_bmb081,l_bmb08,l_bmb082,l_bmb06
                     FROM bmb_file
                    WHERE bmb01 = l_sfa.sfa29
                      AND bmb03 = l_sfa.sfa27
                      AND (bmb04<=g_today OR bmb04 IS NULL)
                      AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)
                   CALL cralc_rate(g_sfb.sfb05,l_sfa.sfa03,g_sfb.sfb08,l_bmb081,l_bmb08,l_bmb082,l_bmb06,1)
                       RETURNING l_sfa.sfa05,l_sfa.sfa16,l_sfa.sfa161
                   #MOD-D50262 add end---------------------------------------------
                   LET l_sfa.sfa05 = g_sfb.sfb08 * l_sfa.sfa161 
                  #check最少發料數量/單位取位的問題 
                  #CALL i301f_sfa05(l_sfa.sfa27,l_sfa.sfa05,l_sfa.sfa12)   #FUN-AC0074
                   CALL i301f_sfa05(l_sfa.sfa01,l_sfa.sfa03,l_sfa.sfa08,l_sfa.sfa12,l_sfa.sfa27, #FUN-AC0074
                                    l_sfa.sfa012,l_sfa.sfa013,l_sfa.sfa05)    #FUN-AC0074
                        RETURNING l_sfa.sfa05
                   IF NOT cl_null(g_errno) THEN 
                      CALL cl_err('check_sfa05',g_errno,1)
                      LET g_success = 'N'
                   END IF
                
                  #因應發數量check上述問題有可能異動,so-->重計實際單位用量 (Actual QPA)
                   LET l_sfa.sfa161=l_sfa.sfa05/g_sfb.sfb08
      
                   UPDATE sfa_file SET * = l_sfa.* 
                    WHERE sfa01 = g_argv1 
                      AND sfa03 = g_sfa2[i].sfa03b
                      AND sfa08 = g_sfa2[i].sfa08b
                      AND sfa12 = g_sfa2[i].sfa12b
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN 
                      CALL cl_err3("upd","sfa_file",g_argv1,g_sfa2[i].sfa03b,SQLCA.sqlcode,"","upd_sfa_T",1)  #No.FUN-660128
                      LET g_success = 'N' 
                   END IF 
                END IF  
             END IF 
      END FOR
 
      IF g_success = 'N' THEN 
         ROLLBACK WORK
         CALL cl_rbmsg(1)
      ELSE
         COMMIT WORK
         LET g_set_ok = 'Y' 
         LET g_set_ok  = 'N'
         LET g_set1_ok = 'N'
         LET g_set2_ok = 'N'
         INITIALIZE  g_check.* TO NULL
         CLEAR FORM 
         CALL g_sfa.clear()
         CALL g_sfa1.clear()
         CALL g_sfa2.clear()
         CALL g_sfa2_s.clear()
         CALL g_boa02.clear()
         CALL g_bob03.clear()
         CALL g_boa.clear()
         CALL g_boa1.clear()
	 CALL g_boa2.clear()
         CALL g_bob.clear()
         CALL cl_cmmsg(1)
      END IF
   ELSE                  #TQC-B40050 
      LET g_success='N'  #TQC-B40050 
   END IF 
  
END FUNCTION
 
#FUNCTION i301f_sfa05(p_sfa27,p_sfa05,p_sfa12)  #FUN-AC0074
FUNCTION i301f_sfa05(p_sfa01,p_sfa03,p_sfa08,p_sfa12,p_sfa27,p_sfa012,p_sfa013,p_sfa05) #FUN-AC0074
   DEFINE p_sfa27       LIKE sfa_file.sfa27, 
          p_sfa05       LIKE sfa_file.sfa05,
          p_sfa12       LIKE sfa_file.sfa12,
         #FUN-AC0074 --------Begin-----------
          p_sfa01       LIKE sfa_file.sfa01,
          p_sfa03       LIKE sfa_file.sfa03,
          p_sfa08       LIKE sfa_file.sfa08,
          p_sfa012      LIKE sfa_file.sfa012,
          p_sfa013      LIKE sfa_file.sfa013,
         #FUN-AC0074 --------End-------------   
          l_ima64       LIKE ima_file.ima64,
          l_ima641      LIKE ima_file.ima641,
          l_gfe03       LIKE gfe_file.gfe03,
          l_double      LIKE type_file.num10,   #No:MOD-AB0187 add
          l_count       LIKE type_file.num5     #MOD-AA0008 add
   DEFINE l_sic06       LIKE sic_file.sic06     #FUN-AC0074 
   LET g_errno = ' '
 
   SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
    WHERE ima01=p_sfa27
   IF SQLCA.sqlcode THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
 
  #MOD-AA0008---modify---start---
  #若發料數量小於最少發料數量，則發料數量變更為最少發料數量
  ##check最少發料數量
  #IF l_ima641 <>  0 AND p_sfa05 < l_ima641 THEN
  #   LET g_errno = 'asf-100'
  #END IF
  # 
  #IF l_ima64 <> 0 AND (p_sfa05 MOD l_ima64) > 0 THEN
  #   LET g_errno = 'asf-101'
  #END IF
  #Check最小發料數量
   IF p_sfa05 < l_ima641 THEN
      LET p_sfa05 = l_ima641
   END IF
  #Check發料批量
  #MOD-AB0187---modify---start---
  #IF (p_sfa05 MOD l_ima64) > 0 THEN
  #   LET l_count = p_sfa05 / l_ima64
  #   LET p_sfa05 = (l_count + 1) * l_ima64
  #END IF 
   IF l_ima64!=0 THEN
       LET l_double=(p_sfa05/l_ima64)+ 0.999999
       LET p_sfa05=l_double*l_ima64
   END IF
  #MOD-AB0187---modify---end---

  #MOD-AA0008---modify---end---
#FUN-AC0074 -------------------Begin--------------------
   #計算工單在sic_file的備置量(sic06)總合(排除已作廢單據)
   SELECT SUM(sic06) INTO l_sic06 FROM sic_file,sia_file
    WHERE sic03=p_sfa01
      AND sic05=p_sfa03
      AND sic11=p_sfa08 
      AND sic07=p_sfa12
      AND sic04=p_sfa27
      AND sic012=p_sfa012
      AND sic013=p_sfa013 
      AND sia01=sic01
      AND siaconf='Y'
   IF p_sfa05 < l_sic06 THEN
      LET g_errno = 'asf-173'
   END IF

#FUN-AC0074 -------------------End----------------------
 
   #-->考慮單位小數取位
   SELECT gfe03 INTO l_gfe03 FROM gfe_file 
    WHERE gfe01 = p_sfa12
   IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
 
   CALL cl_digcut(p_sfa05,l_gfe03) RETURNING p_sfa05
 
   RETURN p_sfa05 
 
END FUNCTION
 
FUNCTION i301f_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
    DISPLAY ARRAY g_sfa1 TO s_sfa1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-570013
 
      BEFORE DISPLAY
          EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
      AFTER DISPLAY
         CONTINUE DISPLAY
   
   END DISPLAY
 
    DISPLAY ARRAY g_sfa2 TO s_sfa2.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #MOD-570013
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 產生備料單身
      ON ACTION generator_allotment_detail
         LET g_action_choice="generator_allotment_detail"
         EXIT DISPLAY
#@    ON ACTION 產生替代單身
      ON ACTION generator_set_detail
         LET g_action_choice="generator_set_detail"
         EXIT DISPLAY
#@    ON ACTION SET替代
      ON ACTION set_sub
         LET g_action_choice="set_sub"
         EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i301f_q_sfa(p_sfa29,p_boa02,p_cn1,p_cn2)
  DEFINE  l_n        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          i          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_cn1      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_cn2      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sql      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
          l_ima02    LIKE ima_file.ima02,
          p_sfa29    LIKE sfa_file.sfa29,
          p_boa02    LIKE boa_file.boa02
 
 
  LET p_row = 2 LET p_col = 5
 
  OPEN WINDOW i301f_q_sfa_w AT p_row,p_col
       WITH FORM "asf/42f/asfi3012" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_locale("asfi3012")
 
 
  SELECT ima02 INTO l_ima02 FROM ima_file
   WHERE ima01 = p_sfa29
     AND imaacti = 'Y'
  DISPLAY p_cn1,p_cn2 TO FORMONLY.cn1,FORMONLY.cn2
  DISPLAY p_sfa29,l_ima02 TO sfa29,FORMONLY.ima02a 
 
  LET l_sql = "SELECT sfa03,sfa08,sfa12,sfa26,ima02,sfa012,sfa013", #FUN-AC0074
              " FROM boa_file LEFT OUTER JOIN ima_file ON boa03 = ima01,sfa_file",
              " WHERE boa01 = '",p_sfa29 CLIPPED,"' ",
              "   AND boa02 = ",p_boa02 CLIPPED,
              "   AND sfa01 = '",g_argv1 CLIPPED,"' ",
              "   AND boa03 = sfa03 ",
              "   AND boa04 = sfa08 ",
              "   AND boa05 = sfa12 "
  PREPARE i301f_q_sfa11p FROM l_sql
  IF SQLCA.sqlcode THEN 
   CALL cl_err('PREPARE i301f_q_sfa11p',SQLCA.sqlcode,0)   
  END IF 
  DECLARE i301f_q_sfa11c CURSOR FOR i301f_q_sfa11p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_q_sfa11c',SQLCA.sqlcode,0)
  END IF 
 
  CALL g_sfa.clear()
 
  LET l_n = 0 
  FOREACH i301f_q_sfa11c INTO g_sfa1_t.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err('FOREACH i301f_set_13c',SQLCA.sqlcode,0)
       EXIT FOREACH
    END IF 
    LET l_n = l_n + 1
    LET g_sfa[l_n].* = g_sfa1_t.*
 
  END FOREACH
 
  WHILE TRUE 
     CALL cl_set_act_visible("accept,cancel",TRUE)       #No.TQC-5A0084 add
      DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=l_n,UNBUFFERED)  #MOD-570013
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DISPLAY
 
        ON ACTION exit
           EXIT DISPLAY
 
        ON KEY(esc)
           EXIT DISPLAY
     
     END DISPLAY
     EXIT WHILE 
  END WHILE 
  CLOSE WINDOW i301f_q_sfa_w
 
END FUNCTION
 
FUNCTION i301f_q_boab(p_boa02,p_b,p_bob07,p_cn1,p_cn2)
  DEFINE  l_n        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          i          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_cn1      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          p_cn2      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sql      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(1000)
          l_code     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(01)
          l_ima02    LIKE ima_file.ima02,
          p_b        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(10)
          p_boa02    LIKE boa_file.boa02,
          p_bob07    LIKE bob_file.bob07
 
 
  LET p_row = 4 LET p_col = 10
  IF p_b = g_msg1 THEN   #No.TQC-5A0017 add
     OPEN WINDOW i301f_q_boab AT p_row,p_col
          WITH FORM "asf/42f/asfi3015" 
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     CALL cl_ui_locale("asfi3015")
 
     DISPLAY p_cn1,p_cn2 TO FORMONLY.cn1,FORMONLY.cn2
     DISPLAY p_boa02,p_bob07 TO bob03,bob07
 
  ELSE 
     OPEN WINDOW i301f_q_boab AT p_row,p_col
          WITH FORM "asf/42f/asfi3014" 
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
     CALL cl_ui_locale("asfi3014")
 
     DISPLAY p_cn1,p_cn2 TO FORMONLY.cn1,FORMONLY.cn2
     DISPLAY p_boa02 TO boa02
  END IF 
 
  #IF p_b = g_x[17] THEN     #No.TQC-5A0017 mark
  IF p_b = g_msg1 THEN       #No.TQC-5A0017 add
     LET l_sql = "SELECT bob04,bob05,bob06,bob08,bob09,ima02,'' ",
                 "  FROM bob_file,ima_file ",
                 " WHERE bob01 = '",g_base.sfa29 CLIPPED,"' ",
                 "   AND bob02 = ",g_base.boa02,
                 "   AND bob03 = ",p_boa02, "   AND bob04 = ima_file.ima01 ",
                 "   AND ( bob11 IS NULL OR bob11 > '",g_sfb.sfb071,"' )"  #No:8765
  ELSE 
     LET l_sql = "SELECT boa03,boa04,boa05,ima02,'' ",
                 " FROM boa_file,ima_file ",
                 " WHERE boa01 = '",g_base.sfa29 CLIPPED,"' ",
                 "   AND boa02 = ",p_boa02,"   AND boa03 = ima_file.ima01 "
  END IF 
 
  PREPARE i301f_q_boab21p FROM l_sql
  IF SQLCA.sqlcode THEN 
     CALL cl_err('PREPARE i301f_q_sfa21p',SQLCA.sqlcode,0)
  END IF 
 
  DECLARE i301f_q_boab21c CURSOR FOR i301f_q_boab21p
  IF SQLCA.sqlcode THEN 
     CALL cl_err('DECLARE i301f_q_boab21c',SQLCA.sqlcode,0)
  END IF 
 
  CALL g_bob.clear()
  CALL g_boa2.clear()
 
  LET l_n = 1
  LET l_code = ''
  IF p_b = g_msg1 THEN       #No.TQC-5A0017 add
     LET l_code = '2' 
     FOREACH i301f_q_boab21c INTO g_bob[l_n].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH i301f_set_21c_bob',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       LET l_n = l_n + 1
     END FOREACH
  ELSE
     LET l_code = '1' 
     FOREACH i301f_q_boab21c INTO g_boa2[l_n].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH i301f_set_21c_boa',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF 
       LET l_n = l_n + 1
     END FOREACH
  END IF 
 
  LET l_n = l_n - 1 
 
  WHILE TRUE 
     CALL cl_set_act_visible("accept,cancel", FALSE)
     IF l_code = '1' THEN     #display boa_file
         DISPLAY ARRAY g_boa2 TO s_boa2.* ATTRIBUTE(COUNT=l_n,UNBUFFERED) #MOD-570013
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DISPLAY
 
            ON ACTION Exit
                     EXIT DISPLAY
 
            ON KEY(esc)
                    EXIT DISPLAY
        
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)
     ELSE 
         DISPLAY ARRAY g_bob TO s_bob.* ATTRIBUTE(COUNT=l_n,UNBUFFERED) #MOD-570013
           BEFORE DISPLAY
                EXIT DISPLAY
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE DISPLAY
 
           ON ACTION Exit
              EXIT DISPLAY
 
           ON KEY(esc)
               EXIT DISPLAY
        END DISPLAY
        CALL cl_set_act_visible("accept,cancel", TRUE)
     END IF 
     EXIT WHILE 
  END WHILE 
  CLOSE WINDOW i301f_q_boab_w
 
END FUNCTION
FUNCTION cralc_bom_qpa(p_key,p_QPA)  
DEFINE
    p_QPA          LIKE bmb_file.bmb06,  
    l_QPA          LIKE bmb_file.bmb06,  
    p_key          LIKE bma_file.bma01,  #assembly part number
    p_key2	   LIKE ima_file.ima910,   
    l_ac,l_i,l_x,l_s,i LIKE type_file.num5,
    arrno          LIKE type_file.num5,
    b_seq          LIKE type_file.num5,
    sr ARRAY[500] OF RECORD  #array for storage
       bmb01       LIKE bmb_file.bmb01,
       bmb02       LIKE bmb_file.bmb02,
       bmb03       LIKE bmb_file.bmb03, #component part number
       bmb04       LIKE bmb_file.bmb04,
       bmb06       LIKE bmb_file.bmb06, #QPA
       bmb07       LIKE bmb_file.bmb07, 
       bmb19       LIKE bmb_file.bmb19,
      #MOD-D50262 add begin-----------------
       bmb08       LIKE bmb_file.bmb08,
       bmb081      LIKE bmb_file.bmb081,
       bmb082      LIKE bmb_file.bmb082
      #MOD-D50262 add end-------------------
                      END RECORD,
    l_bmb06        LIKE bmb_file.bmb06,  
    l_cnt,l_c      LIKE type_file.num5,
    l_cmd          VARCHAR(1000)
DEFINE l_ActualQPA  LIKE bmb_file.bmb06,  #MOD-D50262 add 
       l_total      LIKE sfa_file.sfa05   #MOD-D50262 add 
 
        LET l_cmd=
           #"SELECT bmb01,bmb02,bmb03,bmb04,bmb06,bmb07,bmb19",                     #MOD-D50262 mark
            "SELECT bmb01,bmb02,bmb03,bmb04,bmb06,bmb07,bmb19,bmb08,bmb081,bmb082", #MOD-D50262 add bmb08,bmb081,bmb082
            " FROM bmb_file",
            " WHERE bmb01='", p_key,"' AND bmb02>?",
            " AND (bmb04 <='",g_today,      #FUN-990059
            "' OR bmb04 IS NULL) AND (bmb05 >'",g_sfb.sfb071,
            "' OR bmb05 IS NULL)",
            " ORDER BY bmb02"
        PREPARE cralc_ppp1 FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur1 CURSOR FOR cralc_ppp1
 
 
    LET b_seq=0
    WHILE TRUE
        LET l_ac = 1
        FOREACH cralc_cur1 USING b_seq INTO sr[l_ac].*
            IF sr[l_ac].bmb19<>'3'  THEN
               CONTINUE FOREACH 
            END IF
            LET l_ac = l_ac + 1  
            IF l_ac > 500 THEN EXIT FOREACH END IF
        END FOREACH
        LET l_x=l_ac-1
        
        FOR l_i = 1 TO l_x
            LET l_bmb06 = sr[l_i].bmb06 / sr[l_i].bmb07 
           #LET l_QPA=l_bmb06 * p_QPA    #MOD-D50262 mark
            CALL cralc_rate(g_sfb.sfb05,sr[l_i].bmb03,g_sfb.sfb08,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,l_bmb06,p_QPA) #MOD-D50262 add
            RETURNING l_total,l_QPA,l_ActualQPA #MOD-D50262 add
            IF cl_null(l_QPA) THEN
               LET l_QPA =1 
               LET l_ActualQPA = l_QPA                  #MOD-D50262 add
               LET l_total = l_ActualQPA * g_sfb.sfb08  #MOD-D50262 add
            END IF
            FOR i=1 TO g_sfa2_s1.getlength()
                IF sr[l_i].bmb03 =g_sfa2_s1[i].bob01 THEN
                   CALL g_sfa2_s1.deleteELEMENT(i)
                  #RETURN l_QPA                       #MOD-D50262 mark
                   RETURN l_total,l_QPA,l_ActualQPA   #MOD-D50262 add
                ELSE 
                   CALL cralc_bom_qpa(sr[l_i].bmb03, 
                            #l_QPA) RETURNING l_QPA                       #MOD-D50262 mark
                             l_QPA) RETURNING l_total,l_QPA,l_ActualQPA   #MOD-D50262 add
                END IF 
            END FOR
        END FOR
        IF l_x < arrno OR l_ac=1 THEN 
            EXIT WHILE
        ELSE
            LET b_seq = sr[l_x].bmb02
        END IF
    END WHILE
    IF cl_null(l_QPA) THEN
       LET l_QPA = 1 
       LET l_ActualQPA = l_QPA                     #2013070063
       LET l_total = l_ActualQPA * g_sfb.sfb08     #2013070063
    END IF
   #RETURN l_QPA                       #MOD-D50262 mark
    RETURN l_total,l_QPA,l_ActualQPA   #MOD-D50262 add
END FUNCTION
#No.FUN-9C0072 精簡程式碼  --end

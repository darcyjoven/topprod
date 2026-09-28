# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmp910.4gl
# Descriptions...: 資金模擬作業
# Date & Author..: No.FUN-620036 06/03/28 By Nicola
# Modify.........: MOD-640123 06/04/09 By Melody
# Modify.........: NO.FUN-650177 06/06/16 BY yiting 
# 1.追索天數設定~ 當模擬計算時 , 須參考所在工廠之各項類別之追索天數
# 2.增加外匯及投資納入資金模擬中
# 3.資金模擬增加銀行別~ 預計資金維護作業 , 資金模擬明細表 , 明細表列印增加銀行選項
# Modify.........: No.FUN-660148 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: NO.FUN-640132 06/06/28 BY Yiting  金額欄位需依本國幣別取位
# Modify.........: NO.FUN-670015 06/07/11 BY yiting 1.自定義類別搬出FOR迴圈，不在各工廠作業處理中
#                                                    2.所有類別的資料需考慮參考天數(anmi940)
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/25 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改.
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.CHI-6A0065 07/01/10 By NIcola 取期初時，若為1月應抓取去年12月的資料
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.TQC-740024 07/04/05 By Judy 語言功能失效
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-940083 09/05/15 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/16 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B70112 11/07/13 By Dido 入庫單應改用 rvu03  
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:MOD-C80232 12/09/11 By fengmy 應收票據取數據的SQL用幣別（nmh03）去和日期比較，導致抓不到數據，應該將nmh03改為nmh04.
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nqf          RECORD LIKE nqf_file.* 
DEFINE g_nqg          RECORD LIKE nqg_file.* 
DEFINE g_wc,g_sql     STRING 
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680107 SMALLINT
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680107 INTEGER
DEFINE g_db_type      LIKE type_file.chr3          #No.FUN-680107 VARCHAR(3) #NO.FUN-650177
#     DEFINEl_time LIKE type_file.chr8             #No.FUN-6A0082
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0082
 
   CALL p910_p1()
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-6A0082
 
END MAIN
 
FUNCTION p910_p1()
   DEFINE l_flag      LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01          #No.FUN-580031
   DEFINE l_upd       LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1)
   DEFINE l_date      LIKE type_file.chr20         #No.FUN-680107 VARCHAR(10)
   DEFINE l_dbname    LIKE type_file.chr1          #No.FUN-680107 VARCHAR(1) #NO.FUN-650177
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p910_w AT p_row,p_col WITH FORM "anm/42f/anmp910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   IF s_shut(0) THEN RETURN END IF
   LET g_db_type=cl_db_get_database_type()     #NO.FUN-640196
   CLEAR FORM
 
   WHILE TRUE
      INPUT BY NAME g_nqf.nqf00,g_nqf.nqf01_1,g_nqf.nqf01_2,g_nqf.nqf01_3,
                    g_nqf.nqf01_4,g_nqf.nqf01_5,g_nqf.nqf01_6,g_nqf.nqf01_7,
                    g_nqf.nqf01_8,g_nqf.nqf01_9,g_nqf.nqf01_10,g_nqf.nqf01_11,
                    g_nqf.nqf01_12,g_nqf.nqf01_13,g_nqf.nqf01_14,g_nqf.nqf01_15,
                    g_nqf.nqf01_16,g_nqf.nqf02,g_nqf.nqf03,g_nqf.nqf04,
                    g_nqf.nqf05,g_nqf.nqf06,g_nqf.nqf07,g_nqf.nqf08,
                    g_nqf.nqf09,g_nqf.nqf10,g_nqf.nqf11,g_nqf.nqf12,
                    g_nqf.nqf13,g_nqf.nqf14,
                    g_nqf.nqf15,g_nqf.nqf16  WITHOUT DEFAULTS  #NO.FUN-650177
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD nqf00
            IF cl_null(g_nqf.nqf00) THEN
               CALL cl_err("","aap-099",0)
               NEXT FIELD nqf00
            ELSE
               SELECT COUNT(*) INTO g_cnt FROM nqf_file
                WHERE nqf00 = g_nqf.nqf00
               IF g_cnt <> 0 THEN
                  SELECT * INTO g_nqf.* FROM nqf_file
                   WHERE nqf00 = g_nqf.nqf00
                  LET l_upd = "Y"
               ELSE
                  LET g_nqf.nqf01_1 = g_plant
                  LET g_nqf.nqf01_2 = ""
                  LET g_nqf.nqf01_3 = ""
                  LET g_nqf.nqf01_4 = ""
                  LET g_nqf.nqf01_5 = ""
                  LET g_nqf.nqf01_6 = ""
                  LET g_nqf.nqf01_7 = ""
                  LET g_nqf.nqf01_8 = ""
                  LET g_nqf.nqf01_9 = ""
                  LET g_nqf.nqf01_10 = ""
                  LET g_nqf.nqf01_11 = ""
                  LET g_nqf.nqf01_12 = ""
                  LET g_nqf.nqf01_13 = ""
                  LET g_nqf.nqf01_14 = ""
                  LET g_nqf.nqf01_15 = ""
                  LET g_nqf.nqf01_16 = ""
                  LET l_date[1,4] = YEAR(g_today) USING '&&&&'
                  LET l_date[5,5] ='/'
                  LET l_date[6,7] = (MONTH(g_today)+1) USING '&&'
                  LET l_date[8,8] ='/'
                  LET l_date[9,10] ='01'
                  LET g_nqf.nqf02 = DATE(l_date)-1
                  LET g_nqf.nqf03 = "N"
                  LET g_nqf.nqf04 = "N"
                  LET g_nqf.nqf05 = "N"
                  LET g_nqf.nqf06 = "N"
                  LET g_nqf.nqf07 = "N"
                  LET g_nqf.nqf08 = "N"
                  LET g_nqf.nqf09 = "N"
                  LET g_nqf.nqf10 = "N"
                  LET g_nqf.nqf11 = "N"
                  LET g_nqf.nqf12 = "N"
                  LET g_nqf.nqf13 = "N"
                  LET g_nqf.nqf14 = "N"
                  LET g_nqf.nqf15 = "N"   #NO.FUN-650177
                  LET g_nqf.nqf16 = "N"   #NO.FUN-650177
                  LET l_upd = "N"
               END IF
               DISPLAY BY NAME g_nqf.nqf01_1,g_nqf.nqf01_2,g_nqf.nqf01_3,
                               g_nqf.nqf01_4,g_nqf.nqf01_5,g_nqf.nqf01_6,
                               g_nqf.nqf01_7,g_nqf.nqf01_8,g_nqf.nqf01_9,
                               g_nqf.nqf01_10,g_nqf.nqf01_11,g_nqf.nqf01_12,
                               g_nqf.nqf01_13,g_nqf.nqf01_14,g_nqf.nqf01_15,
                               g_nqf.nqf01_16,g_nqf.nqf02,g_nqf.nqf03,
                               g_nqf.nqf04,g_nqf.nqf05,g_nqf.nqf06,
                               g_nqf.nqf07,g_nqf.nqf08,g_nqf.nqf09,
                               g_nqf.nqf10,g_nqf.nqf11,g_nqf.nqf12,
                               g_nqf.nqf13,g_nqf.nqf14,
                               g_nqf.nqf15,g_nqf.nqf16   #NO.FUN-650177
            END IF
 
         AFTER FIELD nqf01_1
            IF NOT cl_null(g_nqf.nqf01_1) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_1
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_1,"aap-025",0)
                  NEXT FIELD nqf01_1
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_1) THEN
                   NEXT FIELD nqf01_1
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_2
            IF NOT cl_null(g_nqf.nqf01_2) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_2
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_2,"aap-025",0)
                  NEXT FIELD nqf01_2
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_2) THEN
                   NEXT FIELD nqf01_2
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_3
            IF NOT cl_null(g_nqf.nqf01_3) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_3
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_3,"aap-025",0)
                  NEXT FIELD nqf01_3
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_3) THEN
                   NEXT FIELD nqf01_3
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_4
            IF NOT cl_null(g_nqf.nqf01_4) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_4
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_4,"aap-025",0)
                  NEXT FIELD nqf01_4
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_4) THEN
                   NEXT FIELD nqf01_4
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_5
            IF NOT cl_null(g_nqf.nqf01_5) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_5
               IF g_cnt > 0 THEN
                  CALL cl_err(g_nqf.nqf01_5,"aap-025",0)
                  NEXT FIELD nqf01_5
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_5) THEN
                   NEXT FIELD nqf01_5
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_6
            IF NOT cl_null(g_nqf.nqf01_6) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_6
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_6,"aap-025",0)
                  NEXT FIELD nqf01_6
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_6) THEN
                   NEXT FIELD nqf01_6
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_7
            IF NOT cl_null(g_nqf.nqf01_7) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_7
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_7,"aap-025",0)
                  NEXT FIELD nqf01_7
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_7) THEN
                   NEXT FIELD nqf01_7
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_8
            IF NOT cl_null(g_nqf.nqf01_8) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_8
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_8,"aap-025",0)
                  NEXT FIELD nqf01_8
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_8) THEN
                   NEXT FIELD nqf01_8
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_9
            IF NOT cl_null(g_nqf.nqf01_9) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_9
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_9,"aap-025",0)
                  NEXT FIELD nqf01_9
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_9) THEN
                   NEXT FIELD nqf01_9
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_10
            IF NOT cl_null(g_nqf.nqf01_10) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_10
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_10,"aap-025",0)
                  NEXT FIELD nqf01_10
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_10) THEN
                   NEXT FIELD nqf01_10
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_11
            IF NOT cl_null(g_nqf.nqf01_11) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_11
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_11,"aap-025",0)
                  NEXT FIELD nqf01_11
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_11) THEN
                   NEXT FIELD nqf01_11
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_12
            IF NOT cl_null(g_nqf.nqf01_12) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_12
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_12,"aap-025",0)
                  NEXT FIELD nqf01_12
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_12) THEN
                   NEXT FIELD nqf01_12
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_13
            IF NOT cl_null(g_nqf.nqf01_13) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_13
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_13,"aap-025",0)
                  NEXT FIELD nqf01_13
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_13) THEN
                   NEXT FIELD nqf01_13
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_14
            IF NOT cl_null(g_nqf.nqf01_14) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_14
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_14,"aap-025",0)
                  NEXT FIELD nqf01_14
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_14) THEN
                   NEXT FIELD nqf01_14
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_15
            IF NOT cl_null(g_nqf.nqf01_15) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_15
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_15,"aap-025",0)
                  NEXT FIELD nqf01_15
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_15) THEN
                   NEXT FIELD nqf01_15
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER FIELD nqf01_16
            IF NOT cl_null(g_nqf.nqf01_16) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM azp_file
                WHERE azp01 = g_nqf.nqf01_16
               IF g_cnt = 0 THEN
                  CALL cl_err(g_nqf.nqf01_16,"aap-025",0)
                  NEXT FIELD nqf01_16
               END IF
               #--(1)begin FUN-980092 GP5.2 add---check User是否有此plant的權限
                IF NOT s_chk_plant(g_nqf.nqf01_16) THEN
                   NEXT FIELD nqf01_16
                END IF
               #--end FUN-980092 add ---------------------------------
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF l_upd = "Y" THEN
               UPDATE nqf_file SET nqf01_1  = g_nqf.nqf01_1,
                                   nqf01_2  = g_nqf.nqf01_2,
                                   nqf01_3  = g_nqf.nqf01_3,
                                   nqf01_4  = g_nqf.nqf01_4,
                                   nqf01_5  = g_nqf.nqf01_5,
                                   nqf01_6  = g_nqf.nqf01_6,
                                   nqf01_7  = g_nqf.nqf01_7,
                                   nqf01_8  = g_nqf.nqf01_8,
                                   nqf01_9  = g_nqf.nqf01_9,
                                   nqf01_10 = g_nqf.nqf01_10,
                                   nqf01_11 = g_nqf.nqf01_11,
                                   nqf01_12 = g_nqf.nqf01_12,
                                   nqf01_13 = g_nqf.nqf01_13,
                                   nqf01_14 = g_nqf.nqf01_14,
                                   nqf01_15 = g_nqf.nqf01_15,
                                   nqf01_16 = g_nqf.nqf01_16,
                                   nqf02    = g_nqf.nqf02,
                                   nqf03    = g_nqf.nqf03,
                                   nqf04    = g_nqf.nqf04,
                                   nqf05    = g_nqf.nqf05,
                                   nqf06    = g_nqf.nqf06,
                                   nqf07    = g_nqf.nqf07,
                                   nqf08    = g_nqf.nqf08,
                                   nqf09    = g_nqf.nqf09,
                                   nqf10    = g_nqf.nqf10,
                                   nqf11    = g_nqf.nqf11,
                                   nqf12    = g_nqf.nqf12,
                                   nqf13    = g_nqf.nqf13,
                                   nqf14    = g_nqf.nqf14,
                                   nqf15    = g_nqf.nqf15,   #NO.FUN-650177
                                   nqf16    = g_nqf.nqf16    #NO.FUN-650177
                WHERE nqf00 = g_nqf.nqf00
               IF SQLCA.sqlcode THEN
#                 CALL cl_err("upd_nqf",SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("upd","nqf_file",g_nqf.nqf00,"",SQLCA.sqlcode,"","upd_nqf",0)  #No.FUN-660148
                  CONTINUE WHILE
               END IF
            ELSE
               LET g_nqf.nqforiu = g_user      #No.FUN-980030 10/01/04
               LET g_nqf.nqforig = g_grup      #No.FUN-980030 10/01/04
               INSERT INTO nqf_file VALUES(g_nqf.*)
               IF SQLCA.sqlcode THEN
#                 CALL cl_err("ins_nqf",SQLCA.sqlcode,0)   #No.FUN-660148
                  CALL cl_err3("ins","nqf_file",g_nqf.nqf00,"",SQLCA.sqlcode,"","ins_nqf",0)  #No.FUN-660148
                  CONTINUE WHILE
               END IF
            END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nqf01_1)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_1
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_1
                  DISPLAY BY NAME g_nqf.nqf01_1
                  NEXT FIELD nqf01_1 
               WHEN INFIELD(nqf01_2)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_2
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_2
                  DISPLAY BY NAME g_nqf.nqf01_2
                  NEXT FIELD nqf01_2
               WHEN INFIELD(nqf01_3)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_3
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_3
                  DISPLAY BY NAME g_nqf.nqf01_3
                  NEXT FIELD nqf01_3 
               WHEN INFIELD(nqf01_4)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_4
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_4
                  DISPLAY BY NAME g_nqf.nqf01_4
                  NEXT FIELD nqf01_4 
               WHEN INFIELD(nqf01_5)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_5
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_5
                  DISPLAY BY NAME g_nqf.nqf01_5
                  NEXT FIELD nqf01_5 
               WHEN INFIELD(nqf01_6)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_6
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_6
                  DISPLAY BY NAME g_nqf.nqf01_6
                  NEXT FIELD nqf01_6 
               WHEN INFIELD(nqf01_7)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_7
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_7
                  DISPLAY BY NAME g_nqf.nqf01_7
                  NEXT FIELD nqf01_7 
               WHEN INFIELD(nqf01_8)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_8
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_8
                  DISPLAY BY NAME g_nqf.nqf01_8
                  NEXT FIELD nqf01_8 
               WHEN INFIELD(nqf01_9)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_9
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_9
                  DISPLAY BY NAME g_nqf.nqf01_9
                  NEXT FIELD nqf01_9 
               WHEN INFIELD(nqf01_10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_10
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_10
                  DISPLAY BY NAME g_nqf.nqf01_10
                  NEXT FIELD nqf01_10 
               WHEN INFIELD(nqf01_11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_11
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_11
                  DISPLAY BY NAME g_nqf.nqf01_11
                  NEXT FIELD nqf01_11 
               WHEN INFIELD(nqf01_12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_12
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_12
                  DISPLAY BY NAME g_nqf.nqf01_12
                  NEXT FIELD nqf01_12 
               WHEN INFIELD(nqf01_13)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_13
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_13
                  DISPLAY BY NAME g_nqf.nqf01_13
                  NEXT FIELD nqf01_13 
               WHEN INFIELD(nqf01_14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_14
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_14
                  DISPLAY BY NAME g_nqf.nqf01_14
                  NEXT FIELD nqf01_14 
               WHEN INFIELD(nqf01_15)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_15
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_15
                  DISPLAY BY NAME g_nqf.nqf01_15
                  NEXT FIELD nqf01_15 
               WHEN INFIELD(nqf01_16)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nqf.nqf01_16
                  CALL cl_create_qry() RETURNING g_nqf.nqf01_16
                  DISPLAY BY NAME g_nqf.nqf01_16
                  NEXT FIELD nqf01_16
               OTHERWISE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
#TQC-740024.....begin                                                           
         ON ACTION locale                                                       
            CALL cl_dynamic_locale()                                            
#TQC-740024.....end
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      IF cl_sure(0,0) THEN
         LET g_success = "Y"
         BEGIN WORK
         CALL cl_wait()
         CALL p910_p2()
         CALL s_showmsg()          #No.FUN-710024
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
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p910_w
 
END FUNCTION
 
FUNCTION p910_p2()
   DEFINE l_plant   ARRAY[16] OF LIKE azp_file.azp01  #No.FUN-680107 ARRAY[16] OF VARCHAR(10)
   DEFINE l_nqa01   LIKE nqa_file.nqa01
   DEFINE l_year    LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_month   LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_nqc05   LIKE nqc_file.nqc05
   DEFINE l_azp03   LIKE azp_file.azp03
   DEFINE l_azp03_tra   LIKE azp_file.azp03      #FUN-980092
   DEFINE l_date    LIKE type_file.chr20         #No.FUN-680107 VARCHAR(10)
   DEFINE d_date    LIKE type_file.dat           #No.FUN-680107 DATE
   DEFINE l_i,l_j   LIKE type_file.num5          #No.FUN-680107 SMALLINT
   DEFINE l_nmp02   LIKE nmp_file.nmp02
   DEFINE l_nmp03   LIKE nmp_file.nmp03
   DEFINE l_nmc03   LIKE nmc_file.nmc03
   DEFINE l_oeb15   LIKE oeb_file.oeb15
   DEFINE l_oea32   LIKE oea_file.oea32
   DEFINE l_oag     RECORD LIKE oag_file.*
   DEFINE l_oga32   LIKE oga_file.oga32
   DEFINE l_oga02   LIKE oga_file.oga02
   DEFINE l_oma00   LIKE oma_file.oma00
   DEFINE l_pmm20   LIKE pmm_file.pmm20
   DEFINE l_pmn37   LIKE pmn_file.pmn37
   DEFINE l_pma     RECORD LIKE pma_file.*
   DEFINE l_apa00   LIKE apa_file.apa00
   DEFINE l_rvv36   LIKE rvv_file.rvv36
   DEFINE l_rvu03   LIKE rvu_file.rvu03       #MOD-B70112 mod rvu02 -> rvu03
   DEFINE l_nqe09   LIKE nqe_file.nqe09
   DEFINE l_gxf03   LIKE gxf_file.gxf03
   DEFINE l_gxf04   LIKE gxf_file.gxf04
   DEFINE l_gxf05   LIKE gxf_file.gxf05
   DEFINE l_gxf06   LIKE gxf_file.gxf06
   DEFINE l_gxf021  LIKE gxf_file.gxf021
   DEFINE l_nne08   LIKE nne_file.nne08
   DEFINE l_nne21   LIKE nne_file.nne21
   DEFINE l_nne12   LIKE nne_file.nne12
   DEFINE l_nne27   LIKE nne_file.nne27
   DEFINE l_nne14   LIKE nne_file.nne04
   DEFINE l_nne112  LIKE nne_file.nne112
   DEFINE l_nne111  LIKE nne_file.nne111
   DEFINE l_nng16   LIKE nng_file.nng16 
   DEFINE l_nng102  LIKE nng_file.nng102
   DEFINE l_nng20   LIKE nng_file.nng20 
   DEFINE l_nng21   LIKE nng_file.nng21 
   DEFINE l_nng09   LIKE nng_file.nng09 
   DEFINE l_nng101  LIKE nng_file.nng101
   DEFINE l_str     LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_end     LIKE type_file.num10  #No.FUN-680107 INTEGER
   DEFINE l_ngi03_1 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_2 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_3 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_4 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_5 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_6 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_7 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_8 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_9 LIKE ngi_file.ngi03   #NO.FUN-650177 add
   DEFINE l_ngi03_10 LIKE ngi_file.ngi03  #NO.FUN-650177 add
   DEFINE l_ngi03_11 LIKE ngi_file.ngi03  #NO.FUN-650177 add
   DEFINE l_ngi03_12 LIKE ngi_file.ngi03  #NO.FUN-650177 add
   DEFINE l_ngi03_13 LIKE ngi_file.ngi03  #NO.FUN-650177 add
   DEFINE l_ngi03_14 LIKE ngi_file.ngi03  #NO.FUN-650177 add
   DEFINE l_bdate   LIKE type_file.dat    #No.FUN-680107 DATE #NO.FUN-650177 ADD
   DEFINE l_edate   LIKE type_file.dat    #No.FUN-680107 DATE #NO.FUN-650177 ADD
   DEFINE l_dbname  LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1) #NO.FUN-650177 add
   DEFINE l_gxc06   LIKE gxc_file.gxc06   #NO.FUN-650177 
   DEFINE l_gxc08   LIKE gxc_file.gxc08   #NO.FUN-650177 
   DEFINE l_gxc10   LIKE gxc_file.gxc10   #NO.FUN-650177 
   DEFINE l_cnt     LIKE type_file.num5   #NO.FUN-650177 #No.FUN-680107 SMALLINT
   DEFINE t_azi04   LIKE azi_file.azi04   #NO.FUN-640132 #NO.CHI-6A0004
 
   LET l_plant[1] = g_nqf.nqf01_1
   LET l_plant[2] = g_nqf.nqf01_2
   LET l_plant[3] = g_nqf.nqf01_3
   LET l_plant[4] = g_nqf.nqf01_4
   LET l_plant[5] = g_nqf.nqf01_5
   LET l_plant[6] = g_nqf.nqf01_6
   LET l_plant[7] = g_nqf.nqf01_7
   LET l_plant[8] = g_nqf.nqf01_8
   LET l_plant[9] = g_nqf.nqf01_9
   LET l_plant[10] = g_nqf.nqf01_10
   LET l_plant[11] = g_nqf.nqf01_11
   LET l_plant[12] = g_nqf.nqf01_12
   LET l_plant[13] = g_nqf.nqf01_13
   LET l_plant[14] = g_nqf.nqf01_14
   LET l_plant[15] = g_nqf.nqf01_15
   LET l_plant[16] = g_nqf.nqf01_16
 
   DELETE FROM nqg_file WHERE nqg01 = g_nqf.nqf00
   IF STATUS THEN
#     CALL cl_err("del nqg error",STATUS,1)   #No.FUN-660148
      CALL cl_err3("del","nqg_file",g_nqf.nqf00,"",STATUS,"","del nqg error",1)  #No.FUN-660148
      LET g_success = "N"
      RETURN
   END IF
 
   SELECT nqa01 INTO l_nqa01 FROM nqa_file
 
   FOR l_i = 1 TO 16
      IF cl_null(l_plant[l_i]) THEN
         CONTINUE FOR
      END IF
 
      SELECT azp03 INTO l_azp03 FROM azp_file
       WHERE azp01 = l_plant[l_i]
 
      #--Begin FUN-980092 add--------
      LET g_plant_new = l_plant[l_i]
      CALL s_gettrandbs()       ##FUN-980092 GP5.2 Modify #改抓Transaction DB
      LET l_azp03_tra = g_dbs_tra
      #--End   FUN-980092 add--------
 
      LET g_nqg.nqg01 = g_nqf.nqf00
      LET g_nqg.nqg02 = l_plant[l_i]
 
      LET g_sql = "SELECT aza17 ",
                 #"  FROM ",l_azp03,".dbo.aza_file" #TQC-940177 
                  #"  FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file" #TQC-940177 
                 "  FROM ",cl_get_target_table(g_plant_new,'aza_file') #FUN-A50102
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102           
      PREPARE p910_paza FROM g_sql
      DECLARE p910_baza CURSOR FOR p910_paza
 
      OPEN p910_baza
      FETCH p910_baza INTO g_nqg.nqg03
 
      #-----No.FUN-640132 start-----
      SELECT azi04 INTO t_azi04 FROM azi_file   # NO.CHI-6A0004
       WHERE azi01 = g_nqg.nqg03
      #-----No.FUN-640132 END-----
 
      #-----No.CHI-6A0065-----
      LET l_month = MONTH(g_today)
      IF l_month = 1 THEN
         LET l_month = 12
         LET l_year = YEAR(g_today)-1
      ELSE
         LET l_month = MONTH(g_today)-1
         LET l_year = YEAR(g_today)
      END IF
      #-----No.CHI-6A0065 END-----
 
      #期初現金-銀行月結
      LET g_sql = "SELECT nmp01,nmp02,nmp03,nmp16,nma10",
#TQC-940177   ---start     
                 #"  FROM ",l_azp03,".dbo.nmp_file,",
                 #          l_azp03,".dbo.nma_file",
                 # "  FROM ",s_dbstring(l_azp03 CLIPPED),"nmp_file,", 
                 #           s_dbstring(l_azp03 CLIPPED),"nma_file",  
                 "  FROM ",cl_get_target_table(g_plant_new,'nmp_file'),",", #FUN-A50102
                           cl_get_target_table(g_plant_new,'nma_file'),     #FUN-A50102
#TQC-940177   ---end                   
                  " WHERE nmp01 = nma01",
                  "   AND nmp02 = ",l_year,   #No.CHI-6A0065
                  "   AND nmp03 = ",l_month   #No.CHI-6A0065
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
      PREPARE p910_pnmp FROM g_sql
      DECLARE p910_bnmp CURSOR FOR p910_pnmp
 
#No.FUN-710024--begin
      CALL s_showmsg_init()   
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF             
#No.FUN-710024--end 
      FOREACH p910_bnmp INTO g_nqg.nqg07,l_nmp02,l_nmp03,
                             g_nqg.nqg12,g_nqg.nqg10
         IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err("fetch nmp error",STATUS,1)   
            LET g_showmsg=l_year,"/",l_month
            CALL s_errmsg('nmp02,nmp03',g_showmsg,"fetch nmp error",STATUS,1) 
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
 
 
         LET l_date[1,4] = l_nmp02 USING '&&&&'
         LET l_date[5,5] ='/'
         LET l_date[6,7] = (l_nmp03+1) USING '&&'
         LET l_date[8,8] ='/'
         LET l_date[9,10] ='01'
         LET g_nqg.nqg04 = DATE(l_date)-1
 
         IF g_nqg.nqg04 > g_nqf.nqf02 THEN
            CONTINUE FOREACH
         END IF
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT nmt02 FROM ",l_azp03,".dbo.nmt_file", #TQC-940177  
            #LET g_sql = "SELECT nmt02 FROM ",s_dbstring(l_azp03 CLIPPED),"nmt_file",  #TQC-940177 
            LET g_sql = "SELECT nmt02 FROM ",cl_get_target_table(g_plant_new,'nmt_file'), #FUN-A50102
                        " WHERE nmt01 = '",g_nqg.nqg07,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
            PREPARE p910_pnmt1 FROM g_sql
            DECLARE p910_bnmt1 CURSOR FOR p910_pnmt1
 
            OPEN p910_bnmt1
            FETCH p910_bnmt1 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
 
         LET g_nqg.nqg05 = "1"
         LET g_nqg.nqg06 = "000"
         LET g_nqg.nqg08 = ""
         LET g_nqg.nqg09 = ""
#        CALL s_currm(g_nqg.nqg10,g_nqg.nqg04,"S",l_azp03)         #FUN-980020 mark
         CALL s_currm(g_nqg.nqg10,g_nqg.nqg04,"S",l_plant[l_i])    #FUN-980020 
              RETURNING g_nqg.nqg11
         IF cl_null(g_nqg.nqg11) THEN
            LET g_nqg.nqg11 = 1
         END IF
         IF cl_null(g_nqg.nqg12) THEN
            LET g_nqg.nqg12 = 0
         ELSE
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132  #NO.CHI-6A0004
         END IF
         LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
         CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004
 
         LET l_year = YEAR(g_nqg.nqg04)
         LET l_month = MONTH(g_nqg.nqg04)
         LET l_nqc05 = 0
         SELECT nqc05 INTO l_nqc05 FROM nqc_file
          WHERE nqc01 = l_nqa01
            AND nqc02 = g_nqg.nqg03
            AND nqc03 = l_year
            AND nqc04 = l_month
         IF l_nqc05 = 0 THEN 
            LET l_nqc05 = 1
         END IF
         LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
         CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004
         LET g_nqg.nqg16 = ' '        #NO.#NO.FUN-650177 ADD
 
         INSERT INTO nqg_file VALUES(g_nqg.*)
         IF STATUS THEN
#           CALL cl_err("ins nqg_nmp error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nmp error",1)  #No.FUN-660148
             LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
             CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,"ins nqg_nmp error",STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
 
         INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                     g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                     g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                     g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                     g_nqg.nqg14,g_nqg.nqg15,
                                     g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
         IF STATUS THEN
#           CALL cl_err("ins all_nmp error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nmp error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,"ins all_nmp error",STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
      END FOREACH
 
 
      #期初現金-銀行異動
      LET l_date[1,4] = YEAR(g_today) USING '&&&&'
      LET l_date[5,5] ='/'
      LET l_date[6,7] = MONTH(g_today) USING '&&'
      LET l_date[8,8] ='/'
      LET l_date[9,10] ='01'
      LET d_date = DATE(l_date)
 
      LET g_sql = "SELECT nme02,nme13,nme12,nma10,nme07,nme04,nmc03",
#TQC-940177  ---start 
                 #"  FROM ",l_azp03,".dbo.nme_file,",
                 #          l_azp03,".dbo.nma_file,",
                 #          l_azp03,".dbo.nmc_file",
                 # "  FROM ",s_dbstring(l_azp03 CLIPPED),"nme_file,",   
                 #           s_dbstring(l_azp03 CLIPPED),"nma_file,",  
                 #           s_dbstring(l_azp03 CLIPPED),"nmc_file", 
                  "  FROM ",cl_get_target_table(g_plant_new,'nme_file'),",", #FUN-A50102 
                            cl_get_target_table(g_plant_new,'nma_file'),",", #FUN-A50102  
                            cl_get_target_table(g_plant_new,'nmc_file'),     #FUN-A50102
#TQC-940177  ---end                  
                  " WHERE nme01 = nma01",
                  "   AND nme03 = nmc01",
                  "   AND (nme02 BETWEEN '",d_date,"' AND '",g_nqf.nqf02,"')"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
      PREPARE p910_pnme FROM g_sql
      DECLARE p910_bnme CURSOR FOR p910_pnme
 
      FOREACH p910_bnme INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                             g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                             l_nmc03 
         IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err("fetch nme error",STATUS,1)
            CALL s_errmsg('','',"fetch nme error",STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
 
         IF g_nqg.nqg04 > g_nqf.nqf02 THEN
            CONTINUE FOREACH
         END IF
 
         LET g_nqg.nqg05 = "1"
         LET g_nqg.nqg06 = "000"
         LET g_nqg.nqg09 = ""
         IF l_nmc03 = "2" THEN
            LET g_nqg.nqg12 = g_nqg.nqg12 * -1
         END IF
         IF cl_null(g_nqg.nqg11) THEN
            LET g_nqg.nqg11 = 1
         END IF
         IF cl_null(g_nqg.nqg12) THEN
            LET g_nqg.nqg12 = 0
         ELSE
             CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004
         END IF
         LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
         CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132  #NO.CHI-6A0004
         LET l_year = YEAR(g_nqg.nqg04)
         LET l_month = MONTH(g_nqg.nqg04)
         LET l_nqc05 = 0
         SELECT nqc05 INTO l_nqc05 FROM nqc_file
          WHERE nqc01 = l_nqa01
            AND nqc02 = g_nqg.nqg03
            AND nqc03 = l_year
            AND nqc04 = l_month
         IF l_nqc05 = 0 THEN 
            LET l_nqc05 = 1
         END IF
         LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
         CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132   #NO.CHI-6A0004
         LET g_nqg.nqg16 = ''                        #NO.NO.FUN-650177
         LET g_nqg.nqg17 = g_nqg.nqg07               #NO.FUN-640177
 
         INSERT INTO nqg_file VALUES(g_nqg.*)
         IF STATUS THEN
#           CALL cl_err("ins nqg_nme error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nme error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,"ins nqg_nme error",STATUS,1) 
            LET g_success = "N"
#            RETURN
            EXIT FOREACH 
#No.FUN-710024--end
         END IF
 
         INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                     g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                     g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                     g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                     g_nqg.nqg14,g_nqg.nqg15,
                                     g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
         IF STATUS THEN
#           CALL cl_err("ins all_nme error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nme error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,"ins all_nmp error",STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
      END FOREACH
 
      #期初現金-定存
      LET g_sql = "SELECT gxf05,gxf32,gxf01,gxf35,gxf36,gxf33f",
                 #"  FROM ",l_azp03,".dbo.gxf_file", #TQC-940177 
                  #"  FROM ",s_dbstring(l_azp03 CLIPPED),"gxf_file", #TQC-940177 
                 "  FROM ",cl_get_target_table(g_plant_new,'gxf_file'), #FUN-A50102
                  "  WHERE gxfconf = 'Y'"  #NO.FUN-650177
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
      PREPARE p910_pgxf FROM g_sql
      DECLARE p910_bgxf CURSOR FOR p910_pgxf
 
      FOREACH p910_bgxf INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                             g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12
         IF STATUS THEN
            CALL cl_err("fetch gxf error",STATUS,1)
            LET g_success = "N"
            RETURN
         END IF
 
         IF g_nqg.nqg04 > g_nqf.nqf02 THEN
            CONTINUE FOREACH
         END IF
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT nma02 FROM ",l_azp03,".dbo.nma_file",  #TQC-940177 
            #LET g_sql = "SELECT nma02 FROM ",s_dbstring(l_azp03 CLIPPED),"nma_file", #TQC-940177
          LET g_sql = "SELECT nma02 FROM ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102 
                        " WHERE nma01 = '",g_nqg.nqg07,"'" 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
            PREPARE p910_pnma1 FROM g_sql
            DECLARE p910_bnma1 CURSOR FOR p910_pnma1
 
            OPEN p910_bnma1
            FETCH p910_bnma1 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
 
         LET g_nqg.nqg05 = "1"
         LET g_nqg.nqg06 = "000"
         LET g_nqg.nqg09 = ""
         IF cl_null(g_nqg.nqg11) THEN
            LET g_nqg.nqg11 = 1
         END IF
         IF cl_null(g_nqg.nqg12) THEN
            LET g_nqg.nqg12 = 0
         ELSE
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132  #NO.CHI-6A0004
         END IF
         LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
         CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
         LET l_year = YEAR(g_nqg.nqg04)
         LET l_month = MONTH(g_nqg.nqg04)
         LET l_nqc05 = 0
         SELECT nqc05 INTO l_nqc05 FROM nqc_file
          WHERE nqc01 = l_nqa01
            AND nqc02 = g_nqg.nqg03
            AND nqc03 = l_year
            AND nqc04 = l_month
         IF l_nqc05 = 0 THEN 
            LET l_nqc05 = 1
         END IF
         LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
         CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
         LET g_nqg.nqg16 = ''  #NO.FUN-650177
 
         INSERT INTO nqg_file VALUES(g_nqg.*)
         IF STATUS THEN
#           CALL cl_err("ins nqg_gxf error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_gxf error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_gxf error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH  
#No.FUN-710024--end
         END IF
 
         INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                     g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                     g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                     g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                     g_nqg.nqg14,g_nqg.nqg15,
                                     g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
         IF STATUS THEN
#           CALL cl_err("ins all_gxf error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_gxf error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_gxf error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH  
#No.FUN-710024--end
         END IF
      END FOREACH
 
      #訂單
      IF g_nqf.nqf03 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_1 FROM ngi_file
          WHERE ngi01 = '1' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_1) OR l_ngi03_1 = 0 THEN 
              SELECT ngh01 INTO l_ngi03_1 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_1) THEN LET l_ngi03_1 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today-  l_ngi03_1
#NO.FUN-650177 end----
         LET g_sql = "SELECT oea03,oea01,oeb03,oea23,oea24,",
                     "       oeb13*(oeb12-oeb24+oeb25-oeb26),oea32,oeb15,",
                     "       oea032",                 #NO.FUN-650177 add
#TQC-940177  --start  
                    #"  FROM ",l_azp03,".dbo.oea_file,",
                    #          l_azp03,".dbo.oeb_file",
                    #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file,",
                    #          s_dbstring(l_azp03 CLIPPED),"oeb_file",  
                    # "  FROM ",s_dbstring(l_azp03_tra CLIPPED),"oea_file,", #FUN-980092
                    #           s_dbstring(l_azp03_tra CLIPPED),"oeb_file",  #FUN-980092
                    "  FROM ",cl_get_target_table(g_plant_new,'oea_file'),",", #FUN-A50102
                              cl_get_target_table(g_plant_new,'oeb_file'),     #FUN-A50102
#TQC-940177  --end 
                     " WHERE oea01 = oeb01",
                     "   AND oeb70 = 'N'",
                     "   AND (oeb12-oeb24+oeb25-oeb26)>0",
                     "   AND (oea02 BETWEEN '",l_bdate,"' AND '",l_edate,"')",  #NO.FUN-650177 add
                     "   AND oeaconf = 'Y'"                   #NO.FUN-650177 ADD
 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
         PREPARE p910_poea FROM g_sql
         DECLARE p910_boea CURSOR FOR p910_poea
         
         FOREACH p910_boea INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg09,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                l_oea32,l_oeb15,
                                g_nqg.nqg17     #NO.FUN-650177 ADD
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch oea error",STATUS,1)
               CALL s_errmsg('','','fetch oea error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
           #LET g_sql = "SELECT * FROM ",l_azp03,".dbo.oag_file",  #TQC-940177 
           #LET g_sql = "SELECT * FROM ",s_dbstring(l_azp03 CLIPPED),"oag_file", #TQC-940177 
            #LET g_sql = "SELECT * FROM ",s_dbstring(l_azp03_tra CLIPPED),"oag_file", #TQC-940177  #FUN-980092
            LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oag_file'), #FUN-A50102
                        " WHERE oag01 = '",l_oea32,"'"
 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
            PREPARE p910_poag1 FROM g_sql
            DECLARE p910_boag1 CURSOR FOR p910_poag1
 
            OPEN p910_boag1
            FETCH p910_boag1 INTO l_oag.*
        
            IF cl_null(l_oag.oag071) THEN
               LET l_oag.oag071 = 0
            END IF
 
            IF cl_null(l_oag.oag07) THEN
               LET l_oag.oag07 = 0
            END IF
 
            IF cl_null(l_oag.oag041) THEN
               LET l_oag.oag041 = 0
            END IF
 
            IF cl_null(l_oag.oag04) THEN
               LET l_oag.oag04 = 0
            END IF
 
            CASE l_oag.oag06
               WHEN "1" OR "2"
                  CALL cl_cal(l_oeb15,l_oag.oag071,l_oag.oag07)
                       RETURNING g_nqg.nqg04
               WHEN "3"
                  IF l_oag.oag03 = "1" OR l_oag.oag03 = "2" THEN
                     CALL cl_cal(l_oeb15,(l_oag.oag041+l_oag.oag071),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_oeb15,(l_oag.oag041+l_oag.oag071+1),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  END IF
               WHEN "4" OR "5"
                  CALL cl_cal(l_oeb15,(l_oag.oag071)+1,l_oag.oag07)
                       RETURNING g_nqg.nqg04
               WHEN "6"
                  IF l_oag.oag03 = "1" OR l_oag.oag03 = "2" THEN
                     CALL cl_cal(l_oeb15,(l_oag.oag041+l_oag.oag071+1),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_oeb15,(l_oag.oag041+l_oag.oag071+2),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  END IF
               OTHERWISE
                  LET g_nqg.nqg04 = l_oeb15
            END CASE
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "100"
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132  #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132  #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ''     #NO.FUN-650177
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_oea error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_oea error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_oea error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_oea error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_oea error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_oea error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #銷貨單
      IF g_nqf.nqf04 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_2 FROM ngi_file
          WHERE ngi01 = '2' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_2) OR l_ngi03_2 = 0 THEN 
              SELECT ngh02 INTO l_ngi03_2 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_2) THEN LET l_ngi03_2 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_2
#NO.FUN-650177 end----
         LET g_sql = "SELECT oga03,oga01,ogb03,oga23,oga24,",
                     #"       ogb13*(ogb12-ogb60),oga32,oga02,",  #NO.FUN-650177
                     "       ogb13*(ogb917-ogb60),oga32,oga02,",
                     "       oga032",                             #NO.FUN-650177 ADD
#TQC-940177  --start    
                    #"  FROM ",l_azp03,".dbo.oga_file,",
                    #          l_azp03,".dbo.ogb_file",
                    #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oga_file,", 
                    #          s_dbstring(l_azp03 CLIPPED),"ogb_file",  
#TQC-940177  --end                    
                    # "  FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file,",   #FUN-980092
                    #           s_dbstring(l_azp03_tra CLIPPED),"ogb_file",    #FUN-980092
                    "  FROM ",cl_get_target_table(g_plant_new,'oga_file'),",", #FUN-A50102
                              cl_get_target_table(g_plant_new,'ogb_file'),     #FUN-A50102
                     " WHERE oga01 = ogb01",
                     #"   AND (ogb12-ogb60)>0",
                     "   AND (ogb917-ogb60)>0",                   #NO.FUN-650177
                     "   AND (oga02 BETWEEN '",l_bdate,"' AND '",l_edate,"')",  #NO.FUN-650177
                     "   AND ogaconf = 'Y' "                      #NO.FUN-650177
 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
         PREPARE p910_poga FROM g_sql
         DECLARE p910_boga CURSOR FOR p910_poga
         
         FOREACH p910_boga INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg09,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                l_oga32,l_oga02,
                                g_nqg.nqg17   #NO.FUN-650177 ADD
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch oga error",STATUS,1)
               CALL s_errmsg('','','fetch oga error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
           #LET g_sql = "SELECT * FROM ",l_azp03,".dbo.oag_file",  #TQC-940177  
           #LET g_sql = "SELECT * FROM ",s_dbstring(l_azp03 CLIPPED),"oag_file",  #TQC-940177
            #LET g_sql = "SELECT * FROM ",s_dbstring(l_azp03_tra CLIPPED),"oag_file",  #FUN-980092
            LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'oag_file'), #FUN-A50102
                        " WHERE oag01 = '",l_oga32,"'"
 
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
            PREPARE p910_poag2 FROM g_sql
            DECLARE p910_boag2 CURSOR FOR p910_poag2
 
            OPEN p910_boag2
            FETCH p910_boag2 INTO l_oag.*
         
            IF cl_null(l_oag.oag071) THEN
               LET l_oag.oag071 = 0
            END IF
 
            IF cl_null(l_oag.oag07) THEN
               LET l_oag.oag07 = 0
            END IF
 
            IF cl_null(l_oag.oag041) THEN
               LET l_oag.oag041 = 0
            END IF
 
            IF cl_null(l_oag.oag04) THEN
               LET l_oag.oag04 = 0
            END IF
 
            CASE l_oag.oag06
               WHEN "1" OR "2"
                  CALL cl_cal(l_oga02,l_oag.oag071,l_oag.oag07)
                       RETURNING g_nqg.nqg04
               WHEN "3"
                  IF l_oag.oag03 = "1" OR l_oag.oag03 = "2" THEN
                     CALL cl_cal(l_oga02,(l_oag.oag041+l_oag.oag071),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_oga02,(l_oag.oag041+l_oag.oag071+1),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  END IF
               WHEN "4" OR "5"
                  CALL cl_cal(l_oga02,(l_oag.oag071)+1,l_oag.oag07)
                       RETURNING g_nqg.nqg04
               WHEN "6"
                  IF l_oag.oag03 = "1" OR l_oag.oag03 = "2" THEN
                     CALL cl_cal(l_oga02,(l_oag.oag041+l_oag.oag071+1),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_oga02,(l_oag.oag041+l_oag.oag071+2),
                                 (l_oag.oag04+l_oag.oag07))
                          RETURNING g_nqg.nqg04
                  END IF
               OTHERWISE
                  LET g_nqg.nqg04 = l_oga02
            END CASE
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "101"
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132  #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132  #NO.CHI-6A0004 
         
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_oga error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_oga error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_oga error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_oga error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_oga error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_oga error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #應收帳款
      IF g_nqf.nqf05 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_3 FROM ngi_file
          WHERE ngi01 = '3' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_3) OR l_ngi03_3 = 0 THEN 
              SELECT ngh03 INTO l_ngi03_3 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_3) THEN LET l_ngi03_3 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_3
#NO.FUN-650177 end----
         LET g_sql = "SELECT oma12,oma03,oma01,oma23,oma24,(oma54-oma55),oma00,",
                     "       oma032 ",  #NO.FUN-650177 add
                    #"  FROM ",l_azp03,".dbo.oma_file", #TQC-940177  
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file", #TQC-940177
                  "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102  
                     " WHERE (oma54-oma55)>0",
                     "   AND (oma02 BETWEEN '",l_bdate,"' AND '",l_edate,"')",  #NO.FUN-650177
                     "   AND omaconf = 'Y' AND omavoid = 'N' "                  #NO.FUN-650177
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
         PREPARE p910_poma FROM g_sql
         DECLARE p910_boma CURSOR FOR p910_poma
         
         FOREACH p910_boma INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                l_oma00,
                                g_nqg.nqg17   #NO.FUN-650177 add
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch oma error",STATUS,1)
               CALL s_errmsg('','','fetch oma error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "102"
            LET g_nqg.nqg09 = ""
            IF l_oma00 = "2*" THEN
               LET g_nqg.nqg12 = g_nqg.nqg12 * -1
            END IF
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132  #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004  
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132  #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ''   #NO.FUN-650177
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_oma error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_oma error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_oma error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_oma error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_oma error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_oma error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #應收票據
      IF g_nqf.nqf06 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_4 FROM ngi_file
          WHERE ngi01 = '4' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_4) OR l_ngi03_4 = 0 THEN 
              SELECT ngh04 INTO l_ngi03_4 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_4) THEN LET l_ngi03_4 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today-  l_ngi03_4
#NO.FUN-650177 end----
         LET g_sql = "SELECT nmh05,nmh11,nmh01,nmh03,nmh28,(nmh02-nmh17),",
                     "       nmh06,nmh30 ",  #NO.FUN-650177 add
                    #"  FROM ",l_azp03,".dbo.nmh_file", #TQC-940177  
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file", #TQC-940177 
                     "  FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102
                     " WHERE (nmh02-nmh17)>0",
                     "   AND (nmh24 = '1' OR nmh24 = '2' OR nmh24 = '3')",
                    # "   AND (nmh03 BETWEEN '",l_bdate,"' AND '",l_edate,"')",  #NO.FUN-650177
                     "   AND (nmh04 BETWEEN '",l_bdate,"' AND '",l_edate,"')",  #NO.MOD-C80232 mod
                     "   AND nmh38 = 'Y' "                                      #NO.FUN-650177
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
         PREPARE p910_pnmh FROM g_sql
         DECLARE p910_bnmh CURSOR FOR p910_pnmh
         
         FOREACH p910_bnmh INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                g_nqg.nqg16,g_nqg.nqg17  #NO.FUN-650177 ADD
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch nmh error",STATUS,1)
               CALL s_errmsg('','','fetch nmh error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "103"
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132  #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
         
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_nmh error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nmh error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nmh error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_nmh error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nmh error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nmh error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #採購(委外採購)單
      IF g_nqf.nqf07 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_5 FROM ngi_file
          WHERE ngi01 = '5' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_5) OR l_ngi03_5 = 0 THEN 
              SELECT ngh05 INTO l_ngi03_5 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_5) THEN LET l_ngi03_5 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_5
#NO.FUN-650177 end----
             LET g_sql = "SELECT pmm09,pmm01,pmn02,pmm22,pmm42,",
                         #"       pmn31*(pmn20-pmn50+pmn55),pmm20,pmn37",
                         #"       pmn31*(pmn87-pmn50+pmn55),pmm20,pmn37",     #NO.FUN-650177  #No.FUN-940083
                         "       pmn31*(pmn87-pmn50+pmn55+pmn58),pmm20,pmn37",#No.FUN-940083
#TQC-940177   ---start  
                        #"  FROM ",l_azp03,".dbo.pmm_file,",
                        #          l_azp03,".dbo.pmn_file",
                        #"  FROM ",s_dbstring(l_azp03 CLIPPED),"pmm_file,",   
                        #          s_dbstring(l_azp03 CLIPPED),"pmn_file",  
#TQC-940177   ---end                              
                         #"  FROM ",s_dbstring(l_azp03_tra CLIPPED),"pmm_file,",  #FUN-980092 
                         #          s_dbstring(l_azp03_tra CLIPPED),"pmn_file",   #FUN-980092
                         "  FROM ",cl_get_target_table(g_plant_new,'pmm_file'),",",  #FUN-A50102
                                   cl_get_target_table(g_plant_new,'pmn_file'),      #FUN-A50102
                         " WHERE pmm01 = pmn01",
                         "   AND pmn16 = '2'",
                         #"   AND (pmn20-pmn50+pmn55)>0",
                         #"   AND (pmn87-pmn50+pmn55)>0",   #NO.FUN-650177 #No.FUN-940083
                         "   AND (pmn87-pmn50+pmn55+pmn58)>0",             #No.FUN-940083
                         "   AND (pmm04 BETWEEN '",l_bdate,"' AND '",l_edate,"')", #NO.FUN-650177 add
                         "   AND pmm18 = 'Y' "              #NO.FUN-650177
 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
         PREPARE p910_ppmm FROM g_sql
         DECLARE p910_bpmm CURSOR FOR p910_ppmm
         
         FOREACH p910_bpmm INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg09,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                l_pmm20,l_pmn37
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch pmm error",STATUS,1)
               CALL s_errmsg('','','fetch pmm error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH 
#No.FUN-710024--end
            END IF
            
           #LET g_sql = "SELECT * FROM ",l_azp03,".dbo.pma_file",  #TQC-940177   
            #LET g_sql = "SELECT * FROM ",s_dbstring(l_azp03 CLIPPED),"pma_file",  #TQC-940177 
            LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'pma_file'), #FUN-A50102 
                        " WHERE pma01 = '",l_pmm20,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
            PREPARE p910_ppma1 FROM g_sql
            DECLARE p910_bpma1 CURSOR FOR p910_ppma1
 
            OPEN p910_bpma1
            FETCH p910_bpma1 INTO l_pma.*
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT pmc03 FROM ",l_azp03,".dbo.pmc_file", #TQC-940177 
            #LET g_sql = "SELECT pmc03 FROM ",s_dbstring(l_azp03 CLIPPED),"pmc_file",  #TQC-940177
           LET g_sql = "SELECT pmc03 FROM ",cl_get_target_table(g_plant_new,'pmc_file'), #FUN-A50102   
                        " WHERE pmc01 = '",g_nqg.nqg07,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
            PREPARE p910_ppmc FROM g_sql
            DECLARE p910_bpmc CURSOR FOR p910_ppmc
 
            OPEN p910_bpmc
            FETCH p910_bpmc INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
            IF cl_null(l_pma.pma08) THEN
               LET l_pma.pma08 = 0
            END IF
 
            IF cl_null(l_pma.pma09) THEN
               LET l_pma.pma09 = 0
            END IF
 
            IF cl_null(l_pma.pma10) THEN
               LET l_pma.pma10 = 0
            END IF
 
            IF cl_null(l_pma.pma13) THEN
               LET l_pma.pma13 = 0
            END IF
 
            CASE l_pma.pma12
               WHEN "2" OR "7"
                  CALL cl_cal(l_pmn37,l_pma.pma13,l_pma.pma10)
                       RETURNING g_nqg.nqg04
               WHEN "3"
                  IF l_pma.pma03 = "2" OR l_pma.pma03 = "3" THEN
                     CALL cl_cal(l_pmn37,(l_pma.pma08+l_pma.pma13),
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_pmn37,(l_pma.pma08+l_pma.pma13+1),
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  END IF
               WHEN "5" OR "8"
                  CALL cl_cal(l_pmn37,(l_pma.pma13+1),l_pma.pma10)
                       RETURNING g_nqg.nqg04
               WHEN "6"
                  IF l_pma.pma03 = "2" OR l_pma.pma03 = "3" THEN
                     CALL cl_cal(l_pmn37,(l_pma.pma08+l_pma.pma13+1),
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_pmn37,(l_pma.pma08+l_pma.pma13+2),
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  END IF
               OTHERWISE
                  LET g_nqg.nqg04 = l_pmn37
            END CASE
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "104"
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004  
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ' '   #NO.NO.FUN-650177
        
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_pmm error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_pmm error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_pmm error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_pmm error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_pmm error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_pmm error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #入庫單
      IF g_nqf.nqf08 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_6 FROM ngi_file
          WHERE ngi01 = '6' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_6) OR l_ngi03_6 = 0 THEN 
              SELECT ngh06 INTO l_ngi03_6 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_6) THEN LET l_ngi03_6 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_6
#NO.FUN-650177 end----
#        LET g_sql = "SELECT rvu04,rvu01,rvv02,(rvv17-rvv23)*rvv38,",   #CHI-B70039 mark
         LET g_sql = "SELECT rvu04,rvu01,rvv02,(rvv87-rvv23)*rvv38,",   #CHI-B70039
                     "       pmm22,pmm42,pmm20,rvu03,",          #MOD-B70112 mod rvu02 -> rvu03
                     "       rvu05 ",                                       #NO.FUN-650177 ADD
#TQC-940177   ---start   
                    #"  FROM ",l_azp03,".dbo.rvu_file,",
                    #          l_azp03,".dbo.rvv_file,", 
                    #          l_azp03,".dbo.pmm_file",
                    #"  FROM ",s_dbstring(l_azp03 CLIPPED),"rvu_file,",    
                    #          s_dbstring(l_azp03 CLIPPED),"rvv_file,",   
                    #          s_dbstring(l_azp03 CLIPPED),"pmm_file",  
#TQC-940177   ---end   
                     #"  FROM ",s_dbstring(l_azp03_tra CLIPPED),"rvu_file,",   #FUN-980092
                     #          s_dbstring(l_azp03_tra CLIPPED),"rvv_file,",   #FUN-980092
                     #          s_dbstring(l_azp03_tra CLIPPED),"pmm_file",    #FUN-980092
                      "  FROM ",cl_get_target_table(g_plant_new,'rvu_file'),",", #FUN-A50102
                                cl_get_target_table(g_plant_new,'rvv_file'),",", #FUN-A50102
                                cl_get_target_table(g_plant_new,'pmm_file'),     #FUN-A50102
                     " WHERE rvu01 = rvv01",
                     "   AND rvv36 = pmm01",
                     "   AND (rvv17-rvv23)>0",
                     "   AND rvu03 BETWEEN '",l_bdate,"' AND '",l_edate,"'", #NO.FUN-650177 ADD
                     "   AND rvuconf = 'Y' "                                 #NO.FUN-650177
 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
         PREPARE p910_prvu FROM g_sql
         DECLARE p910_brvu CURSOR FOR p910_prvu
         
         FOREACH p910_brvu INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg09,
                                g_nqg.nqg12,g_nqg.nqg10,g_nqg.nqg11,
                                l_pmm20,l_rvu03,                  #MOD-B70112 mod rvu02 -> rvu03
                                g_nqg.nqg17                                 #NO.FUN-650177 ADD 
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch rvv error",STATUS,1)
               CALL s_errmsg('','','fetch rvv error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
           #LET g_sql = "SELECT * FROM ",l_azp03,".dbo.pma_file", #TQC-940177  
            #LET g_sql = "SELECT * FROM ",s_dbstring(l_azp03 CLIPPED),"pma_file", #TQC-940177
            LET g_sql = "SELECT * FROM ",cl_get_target_table(g_plant_new,'pma_file'), #FUN-A50102
                        " WHERE pma01 = '",l_pmm20,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
            PREPARE p910_ppma2 FROM g_sql
            DECLARE p910_bpma2 CURSOR FOR p910_ppma2
 
            OPEN p910_bpma2
            FETCH p910_bpma2 INTO l_pma.*
         
            IF cl_null(l_pma.pma08) THEN
               LET l_pma.pma08 = 0
            END IF
 
            IF cl_null(l_pma.pma09) THEN
               LET l_pma.pma09 = 0
            END IF
 
            IF cl_null(l_pma.pma10) THEN
               LET l_pma.pma10 = 0
            END IF
 
            IF cl_null(l_pma.pma13) THEN
               LET l_pma.pma13 = 0
            END IF
 
            CASE l_pma.pma12
               WHEN "2" OR "7"
                  CALL cl_cal(l_rvu03,l_pma.pma13,l_pma.pma10)    #MOD-B70112 mod rvu02 -> rvu03
                       RETURNING g_nqg.nqg04
               WHEN "3"
                  IF l_pma.pma03 = "2" OR l_pma.pma03 = "3" THEN
                     CALL cl_cal(l_rvu03,(l_pma.pma08+l_pma.pma13), #MOD-B70112 mod rvu02 -> rvu03
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_rvu03,(l_pma.pma08+l_pma.pma13+1), #MOD-B70112 mod rvu02 -> rvu03
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  END IF
               WHEN "5" OR "8"
                  CALL cl_cal(l_rvu03,(l_pma.pma13+1),l_pma.pma10) #MOD-B70112 mod rvu02 -> rvu03
                       RETURNING g_nqg.nqg04
               WHEN "6"
                  IF l_pma.pma03 = "2" OR l_pma.pma03 = "3" THEN
                     CALL cl_cal(l_rvu03,(l_pma.pma08+l_pma.pma13+1), #MOD-B70112 mod rvu02 -> rvu03
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  ELSE
                     CALL cl_cal(l_rvu03,(l_pma.pma08+l_pma.pma13+2), #MOD-B70112 mod rvu02 -> rvu03
                                 (l_pma.pma09+l_pma.pma10))
                          RETURNING g_nqg.nqg04
                  END IF
               OTHERWISE
                  LET g_nqg.nqg04 = l_rvu03                       #MOD-B70112 mod rvu02 -> rvu03
            END CASE
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "105"
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132  #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132  #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ''       #NO.FUN-650177        
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_rvu error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_rvu error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_rvu error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
 
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_rvu error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_rvu error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_rvu error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #應付帳款
      IF g_nqf.nqf09 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_7 FROM ngi_file
          WHERE ngi01 = '7' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_7) OR l_ngi03_7 = 0 THEN 
              SELECT ngh07 INTO l_ngi03_7 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_7) THEN LET l_ngi03_7 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_7
#NO.FUN-650177 end----
         LET g_sql = "SELECT apa64,apa06,apa01,apa13,apa14,(apa34-apa35),apa00,",
                     "       apa07 ",    #NO.FUN-650177 ADD
                    #"  FROM ",l_azp03,".dbo.apa_file", #TQC-940177  
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"apa_file", #TQC-940177  
                     "  FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102
                     " WHERE (apa34-apa35)>0",
                     "   AND apa41 ='Y' AND apa42 = 'N'",     #NO.FUN-650177
                     "   AND apa02 BETWEEN '",l_bdate,"' AND '",l_edate,"'"  #NO.FUN-650177 ADD
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
         PREPARE p910_papa FROM g_sql
         DECLARE p910_bapa CURSOR FOR p910_papa
         
         FOREACH p910_bapa INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                l_apa00,
                                g_nqg.nqg17    #NO.FUN-650177 ADD
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch apa error",STATUS,1)
               CALL s_errmsg('','','fetch apa error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "106"
            LET g_nqg.nqg09 = ""
            IF l_apa00 = "2*" THEN
               LET g_nqg.nqg12 = g_nqg.nqg12 *-1
            END IF
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ' '   #NO.FUN-650177
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_apa error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_apa error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_apa error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_apa error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_apa error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_apa error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #應付票據
      IF g_nqf.nqf10 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_8 FROM ngi_file
          WHERE ngi01 = '8' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_8) OR l_ngi03_8 = 0 THEN 
              SELECT ngh08 INTO l_ngi03_8 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_8) THEN LET l_ngi03_8 = 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_8
#NO.FUN-650177 end----
         LET g_sql = "SELECT nmd05,nmd08,nmd01,nmd21,nmd19,nmd04,",
                     "       nmd03,nmd09 ",  #NO.FUN-650177 ADD
                    #"  FROM ",l_azp03,".dbo.nmd_file", #TQC-940177 
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"nmd_file",  #TQC-940177  
                     "  FROM ",cl_get_target_table(g_plant_new,'nmd_file'), #FUN-A50102  
                     " WHERE (nmd12 = '1' OR nmd12 = 'X')",
                     "   AND nmd30 = 'Y' ",                                  #NO.FUN-650177 ADD
                     "   AND nmd07 BETWEEN '",l_bdate,"' AND '",l_edate,"'"  #NO.FUN-650177 ADD
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         PREPARE p910_pnmd FROM g_sql
         DECLARE p910_bnmd CURSOR FOR p910_pnmd
         
         FOREACH p910_bnmd INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                g_nqg.nqg16,g_nqg.nqg17    #NO.FUN-650177 ADD
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch nmd error",STATUS,1)
               CALL s_errmsg('','','fetch nmd error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
            LET g_nqg.nqg05 = "1"
            LET g_nqg.nqg06 = "107"
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            ELSE
               CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132  #NO.CHI-6A0004 
         
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_nmd error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nmd error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nmd error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_nmd error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nmd error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nmd error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #應收利息
      IF g_nqf.nqf11 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_9 FROM ngi_file
          WHERE ngi01 = '9' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_9) OR l_ngi03_9 = 0 THEN 
              SELECT ngh09 INTO l_ngi03_9 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_9) THEN LET l_ngi03_9 = 0 END IF
         LET l_edate = g_today 
         LET l_bdate = g_today -  l_ngi03_9
#NO.FUN-650177 end----
#NO.FUN-650177 start--
         LET g_sql = "SELECT gxf02,gxf01,gxf24,gxf25,gxf03,gxf04,gxf05,",
                     "       gxf06,gxf021",
                    #"  FROM ",l_azp03,".dbo.gxf_file ", #TQC-940177   
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"gxf_file ", #TQC-940177  
                     "  FROM ",cl_get_target_table(g_plant_new,'gxf_file'), #FUN-A50102
                     " WHERE gxf05 > '",g_today,"'",
                     "   AND gxfconf = 'Y' ",                 #NO.FUN-650177
                     "   AND (gxf03 BETWEEN '",l_bdate,"' AND '",l_edate,"')"           #NO.FUN-650177 add
#NO.FUN-650177 end----
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102  
         PREPARE p910_pgxf1 FROM g_sql
         DECLARE p910_bgxf1 CURSOR FOR p910_pgxf1
         
         FOREACH p910_bgxf1 INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg10,
                                g_nqg.nqg11,l_gxf03,l_gxf04,l_gxf05,
                                l_gxf06,l_gxf021
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch gxf1 error",STATUS,1)
               CALL s_errmsg('','','fetch gxf1 error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT nma02 FROM ",l_azp03,".dbo.nma_file", #TQC-940177   
            #LET g_sql = "SELECT nma02 FROM ",s_dbstring(l_azp03 CLIPPED),"nma_file", #TQC-940177 
            LET g_sql = "SELECT nma02 FROM ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102
                        " WHERE nma01 = '",g_nqg.nqg07,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
            PREPARE p910_pnma FROM g_sql
            DECLARE p910_bnma CURSOR FOR p910_pnma
 
            OPEN p910_bnma
            FETCH p910_bnma INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
 
            LET g_nqg.nqg05 = "3"
            #LET g_nqg.nqg06 = "302"
            LET g_nqg.nqg06 = "300"    #NO.FUN-650177 
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
 
            IF l_gxf04 = "1" THEN
               LET g_nqg.nqg12 = l_gxf021 * (l_gxf06/12)
            ELSE
               LET g_nqg.nqg12 = l_gxf021 * (l_gxf06/365) * (l_gxf05 - l_gxf03)
            END IF
 
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            IF l_gxf04 = "1" THEN
               LET l_str = (YEAR(g_today)*12)+MONTH(g_today)
               LET l_end = (YEAR(l_gxf05)*12)+MONTH(l_gxf05)
               FOR l_j = l_str TO l_end
                  LET l_month = l_str MOD 12
                  IF l_month = 0 THEN
                     LET l_month = 12
                  END IF
                  LET l_year = (l_str - l_month) / 12 
                  LET l_date[1,4] = l_year USING '&&&&'
                  LET l_date[5,5] ='/'
                  LET l_date[6,7] = (l_month+1) USING '&&'
                  LET l_date[8,8] ='/'
                  LET l_date[9,10] ='01'
                  LET g_nqg.nqg04 = DATE(l_date)-1
 
                  IF g_nqg.nqg04 > g_nqf.nqf02 THEN
                     CONTINUE FOREACH
                  END IF
                  
                  LET l_year = YEAR(g_nqg.nqg04)
                  LET l_month = MONTH(g_nqg.nqg04)
                  LET l_nqc05 = 0
                  SELECT nqc05 INTO l_nqc05 FROM nqc_file
                   WHERE nqc01 = l_nqa01
                     AND nqc02 = g_nqg.nqg03
                     AND nqc03 = l_year
                     AND nqc04 = l_month
                  IF l_nqc05 = 0 THEN 
                     LET l_nqc05 = 1
                  END IF
                  LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
                  CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
                  LET g_nqg.nqg16 = ' '       #NO.FUN-650177
 
                  INSERT INTO nqg_file VALUES(g_nqg.*)
                  IF STATUS THEN
#                    CALL cl_err("ins nqg_gxf1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                     CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_gxf1 error",1)  #No.FUN-660148
                     LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                     CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_gxf1 error',STATUS,1)
                     LET g_success = "N"
#                     RETURN
                     EXIT FOR
#No.FUN-710024--end
                  END IF
                  
                  INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                              g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                              g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                              g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                              g_nqg.nqg14,g_nqg.nqg15,
                                              g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
                  IF STATUS THEN
#                    CALL cl_err("ins all_gxf1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                     CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_gxf1 error",1)  #No.FUN-660148
                     LET g_showmsg=g_nqg.nqg01,"/","ALL","/","","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                     CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_gxf1 error',STATUS,1)
                     LET g_success = "N"
#                     RETURN
                     EXIT FOR
#No.FUN-710024--end
                  END IF
               END FOR 
            ELSE
               LET g_nqg.nqg04 = l_gxf05
 
               IF g_nqg.nqg04 > g_nqf.nqf02 THEN
                  CONTINUE FOREACH
               END IF
               
               LET l_year = YEAR(g_nqg.nqg04)
               LET l_month = MONTH(g_nqg.nqg04)
               LET l_nqc05 = 0
               SELECT nqc05 INTO l_nqc05 FROM nqc_file
                WHERE nqc01 = l_nqa01
                  AND nqc02 = g_nqg.nqg03
                  AND nqc03 = l_year
                  AND nqc04 = l_month
               IF l_nqc05 = 0 THEN 
                  LET l_nqc05 = 1
               END IF
               LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
               CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
               LET g_nqg.nqg16 = ' '   #NO.FUN-650177
 
               INSERT INTO nqg_file VALUES(g_nqg.*)
               IF STATUS THEN
#                 CALL cl_err("ins nqg_gxf2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                  CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_gxf2 error",1)  #No.FUN-660148
                  LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                  CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_gxf2 error',STATUS,1)
                  LET g_success = "N"
#                   RETURN
                  EXIT FOREACH
#No.FUN-710024--end
               END IF
               
               INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                           g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                           g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                           g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                           g_nqg.nqg14,g_nqg.nqg15,
                                           g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
               IF STATUS THEN
#                 CALL cl_err("ins all_gxf2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                  CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_gxf2 error",1)  #No.FUN-660148
                  LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                  CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_gxf2 error',STATUS,1)
                  LET g_success = "N"
#                   RETURN
                  EXIT FOREACH
#No.FUN-710024--end
               END IF
            END IF
         END FOREACH
      END IF
 
      #短期融資到期
      IF g_nqf.nqf12 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_11 FROM ngi_file
          WHERE ngi01 = '11' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_11) OR l_ngi03_11 = 0 THEN 
              SELECT ngh11 INTO l_ngi03_11 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_11) THEN LET l_ngi03_11= 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_11
#NO.FUN-650177 end----
#NO.FUN-650177 start----
         LET g_sql = "SELECT nne21,nne04,nne01,nne16,nne17,(nne12-nne27)",
                    #"  FROM ",l_azp03,".dbo.nne_file", #TQC-940177   
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"nne_file", #TQC-940177 
                     "  FROM ",cl_get_target_table(g_plant_new,'nne_file'), #FUN-A50102
                     " WHERE (nne12-nne27) > 0", 
                     "   AND nneconf = 'Y' ",       #NO.FUN-650177
                     "   AND (nne02 BETWEEN '",l_bdate,"' AND '",l_edate,"')"    #FUN-650177 add
#NO.FUN-650177 end----
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
         PREPARE p910_pnne FROM g_sql
         DECLARE p910_bnne CURSOR FOR p910_pnne
         
         FOREACH p910_bnne INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12,
                                g_nqg.nqg17   #NO.FUN-650177 
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch nne error",STATUS,1)
               CALL s_errmsg('','','fetch nne error',STATUS,1) 
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT alg02 FROM ",l_azp03,".dbo.alg_file",  #TQC-940177  
            #LET g_sql = "SELECT alg02 FROM ",s_dbstring(l_azp03 CLIPPED),"alg_file", #TQC-940177 
            LET g_sql = "SELECT alg02 FROM ",cl_get_target_table(g_plant_new,'alg_file'), #FUN-A50102
                        " WHERE alg01 = '",g_nqg.nqg07,"'"   
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
            PREPARE p910_palg1 FROM g_sql
            DECLARE p910_balg1 CURSOR FOR p910_palg1
 
            OPEN p910_balg1
            FETCH p910_balg1 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
            LET g_nqg.nqg05 = "3"
            #LET g_nqg.nqg06 = "303"
            LET g_nqg.nqg06 = "301"    #NO.FUN-650177 
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ' '  #NO.FUN-650177
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_nne error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nne error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nne error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_nne error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nne error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nne error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #長期融資到期
      IF g_nqf.nqf13 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_12 FROM ngi_file
          WHERE ngi01 = '12' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_12) OR l_ngi03_12 = 0THEN 
              SELECT ngh12 INTO l_ngi03_12 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_12) THEN LET l_ngi03_12= 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_12
#NO.FUN-650177 end----
         LET g_sql = "SELECT nnh03,nng04,nng01,nng18,nng19,nnh04",   #MOD-640123
#TQC-940177   ---start   
                    #"  FROM ",l_azp03,".dbo.nng_file,",
                    #          l_azp03,".dbo.nnh_file",
                    # "  FROM ",s_dbstring(l_azp03 CLIPPED),"nng_file,", 
                    #           s_dbstring(l_azp03 CLIPPED),"nnh_file",  
                    "  FROM ",cl_get_target_table(g_plant_new,'nng_file'),",", #FUN-A50102
                              cl_get_target_table(g_plant_new,'nnh_file'),     #FUN-A50102
#TQC-940177   ---end    
                     " WHERE nng01 = nnh01",
                     "   AND nng15 = '2'",
                     "   AND nngconf= 'Y'",     #NO.FUN-650177
                     "   AND (nnh03 BETWEEN '",g_today,"' AND '",g_nqf.nqf02,"')" ,
                     "   AND (nng02 BETWEEN '",l_bdate,"' AND '",l_edate,"')"    #FUN-650177 add
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         PREPARE p910_pnng FROM g_sql
         DECLARE p910_bnng CURSOR FOR p910_pnng
         
         FOREACH p910_bnng INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg11,g_nqg.nqg12
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch nng1 error",STATUS,1)
               CALL s_errmsg('','','fetch nngl error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            IF g_nqg.nqg04 > g_nqf.nqf02 THEN
               CONTINUE FOREACH
            END IF
 
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT alg02 FROM ",l_azp03,".dbo.alg_file", #TQC-940177  
            #LET g_sql = "SELECT alg02 FROM ",s_dbstring(l_azp03 CLIPPED),"alg_file", #TQC-940177 
            LET g_sql = "SELECT alg02 FROM ",cl_get_target_table(g_plant_new,'alg_file'), #FUN-A50102
                        " WHERE alg01 = '",g_nqg.nqg07,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
            PREPARE p910_palg2 FROM g_sql
            DECLARE p910_balg2 CURSOR FOR p910_palg2
 
            OPEN p910_balg2
            FETCH p910_balg2 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
            LET g_nqg.nqg05 = "3"
            #LET g_nqg.nqg06 = "304"
            LET g_nqg.nqg06 = "302"      #NO.FUN-650177 
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = ''                        #NO.FUN-650177
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_nng error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nng error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nng error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_nng error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nng error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nng error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF
 
      #應付利息
      IF g_nqf.nqf14 = "Y" THEN
#NO.FUN-650177 start--
         SELECT ngi03 INTO l_ngi03_10 FROM ngi_file
          WHERE ngi01 = '10' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_10) OR l_ngi03_10 = 0 THEN 
              SELECT ngh10 INTO l_ngi03_10 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_10) THEN LET l_ngi03_10= 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today  -  l_ngi03_10
#NO.FUN-650177 end----
         #短期融資檔
#NO.FUN-650177 start-------
         LET g_sql = "SELECT nne04,nne01,nne16,nne17,nne08,nne21,nne12,",
                     "       nne27,nne14,nne112,nne111",
                    #"  FROM ",l_azp03,".dbo.nne_file", #TQC-940177  
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"nne_file",  #TQC-940177
                     "  FROM ",cl_get_target_table(g_plant_new,'nne_file'), #FUN-A50102 
                     " WHERE nne21 > '",g_today,"'",
                     "   AND nneconf ='Y'",    #NO.FUN-650177
                     "   AND (nne02 BETWEEN '",l_bdate,"' AND '",l_edate,"')"    #FUN-650177 add
#NO.FUN-650177 end-------
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
         PREPARE p910_pnne1 FROM g_sql
         DECLARE p910_bnne1 CURSOR FOR p910_pnne1
         
         FOREACH p910_bnne1 INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg10,
                                 g_nqg.nqg11,l_nne08,l_nne21,l_nne12,
                                 l_nne27,l_nne14,l_nne112,l_nne111
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch nne1 error",STATUS,1)
               CALL s_errmsg('','','fetch nnel error',STATUS,1) 
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT alg02 FROM ",l_azp03,".dbo.alg_file", #TQC-940177  
            #LET g_sql = "SELECT alg02 FROM ",s_dbstring(l_azp03 CLIPPED),"alg_file", #TQC-940177 
            LET g_sql = "SELECT alg02 FROM ",cl_get_target_table(g_plant_new,'alg_file'), #FUN-A50102 
                        " WHERE alg01 = '",g_nqg.nqg07,"'"   
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
            PREPARE p910_palg3 FROM g_sql
            DECLARE p910_balg3 CURSOR FOR p910_palg3
 
            OPEN p910_balg3
            FETCH p910_balg3 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
 
            LET g_nqg.nqg05 = "3"
            #LET g_nqg.nqg06 = "305"
            LET g_nqg.nqg06 = "303"   #NO.FUN-650177
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
 
            IF l_nne08 = "1" THEN
               LET g_nqg.nqg12 = (l_nne12-l_nne27) * (l_nne14/12)
            ELSE
               LET g_nqg.nqg12 = (l_nne12-l_nne27) * (l_nne14/365)
                               * (l_nne112 - l_nne111)
            END IF
 
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
         
            IF l_nne08 = "1" THEN
               LET l_str = (YEAR(g_today)*12)+MONTH(g_today)
               LET l_end = (YEAR(l_nne21)*12)+MONTH(l_nne21)
               FOR l_j = l_str TO l_end
                  LET l_month = l_str MOD 12
                  IF l_month = 0 THEN
                     LET l_month = 12
                  END IF
                  LET l_year = (l_str - l_month) / 12 
                  LET l_date[1,4] = l_year USING '&&&&'
                  LET l_date[5,5] ='/'
                  LET l_date[6,7] = (l_month+1) USING '&&'
                  LET l_date[8,8] ='/'
                  LET l_date[9,10] ='01'
                  LET g_nqg.nqg04 = DATE(l_date)-1
 
                  IF g_nqg.nqg04 > g_nqf.nqf02 THEN
                     CONTINUE FOREACH
                  END IF
                  
                  LET l_year = YEAR(g_nqg.nqg04)
                  LET l_month = MONTH(g_nqg.nqg04)
                  LET l_nqc05 = 0
                  SELECT nqc05 INTO l_nqc05 FROM nqc_file
                   WHERE nqc01 = l_nqa01
                     AND nqc02 = g_nqg.nqg03
                     AND nqc03 = l_year
                     AND nqc04 = l_month
                  IF l_nqc05 = 0 THEN 
                     LET l_nqc05 = 1
                  END IF
                  LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
                  CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
                  LET g_nqg.nqg16 = ' ' #NO.FUN-650177
 
                  INSERT INTO nqg_file VALUES(g_nqg.*)
                  IF STATUS THEN
#                    CALL cl_err("ins nqg_nne1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                     CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nne1 error",1)  #No.FUN-660148
                     LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                     CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nnel error',STATUS,1)
                     LET g_success = "N"
#                     RETURN
                     EXIT FOR
#No.FUN-710024--end
                  END IF
                  
                  INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                              g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                              g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                              g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                              g_nqg.nqg14,g_nqg.nqg15,
                                              g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
                  IF STATUS THEN
#                    CALL cl_err("ins all_nne1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                     CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nne1 error",1)  #No.FUN-660148
                     LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                     CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nnel error',STATUS,1)
                     LET g_success = "N"
#                     RETURN
                     EXIT FOR
#No.FUN-710024--end
                  END IF
               END FOR 
            ELSE
               LET g_nqg.nqg04 = l_nne21
 
               IF g_nqg.nqg04 > g_nqf.nqf02 THEN
                  CONTINUE FOREACH
               END IF
               
               LET l_year = YEAR(g_nqg.nqg04)
               LET l_month = MONTH(g_nqg.nqg04)
               LET l_nqc05 = 0
               SELECT nqc05 INTO l_nqc05 FROM nqc_file
                WHERE nqc01 = l_nqa01
                  AND nqc02 = g_nqg.nqg03
                  AND nqc03 = l_year
                  AND nqc04 = l_month
               IF l_nqc05 = 0 THEN 
                  LET l_nqc05 = 1
               END IF
               LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
               CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14    #NO.FUN-640132 #NO.CHI-6A0004 
               LET g_nqg.nqg16 = ' ' #NO.FUN-650177
 
               INSERT INTO nqg_file VALUES(g_nqg.*)
               IF STATUS THEN
#                 CALL cl_err("ins nqg_nne2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                  CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nne2 error",1)  #No.FUN-660148
                  LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                  CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nne2 error',STATUS,1)
                  LET g_success = "N"
#                  RETURN
                  EXIT FOREACH
#No.FUN-710024--end
               END IF
               
               INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                           g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                           g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                           g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                           g_nqg.nqg14,g_nqg.nqg15,
                                           g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
               IF STATUS THEN
#                 CALL cl_err("ins all_nne2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                  CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nne2 error",1)  #No.FUN-660148
                  LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                  CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nne2 error',STATUS,1)
                  LET g_success = "N"
#                  RETURN
                  EXIT FOREACH
#No.FUN-710024--end
               END IF
            END IF
         END FOREACH
      #END IF   #NO.FUN-670015
 
         #短期融資檔
         LET g_sql = "SELECT nng04,nng01,nng18,nng19,nng16,nng102,nng20,",
                     "       nng21,nng09,nng101",
                    #"  FROM ",l_azp03,".dbo.nng_file", #TQC-940177  
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"nng_file", #TQC-940177 
                     "  FROM ",cl_get_target_table(g_plant_new,'nng_file'), #FUN-A50102
                     " WHERE nng102 > '",g_today,"'",
                     "   AND nngconf = 'Y'"            #NO.FUN-650177
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
         PREPARE p910_pnng1 FROM g_sql
         DECLARE p910_bnng1 CURSOR FOR p910_pnng1
         
         FOREACH p910_bnng1 INTO g_nqg.nqg07,g_nqg.nqg08,g_nqg.nqg10,
                                 g_nqg.nqg11,l_nng16,l_nng102,l_nng20,
                                 l_nng21,l_nng09,l_nng101
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch nng2 error",STATUS,1)
               CALL s_errmsg('','','fetch nng2 error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
 
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT nmt02 FROM ",l_azp03,".dbo.nmt_file", #TQC-940177  
           # LET g_sql = "SELECT nmt02 FROM ",s_dbstring(l_azp03 CLIPPED),"nmt_file", #TQC-940177
         LET g_sql = "SELECT nmt02 FROM ",cl_get_target_table(g_plant_new,'nmt_file'), #FUN-A50102  
                        " WHERE nmt01 = '",g_nqg.nqg07,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
            PREPARE p910_pnmt3 FROM g_sql
            DECLARE p910_bnmt3 CURSOR FOR p910_pnmt3
 
            OPEN p910_bnmt3
            FETCH p910_bnmt3 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
 
            LET g_nqg.nqg05 = "3"
            LET g_nqg.nqg06 = "305"
            LET g_nqg.nqg09 = ""
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
 
            IF l_nng16 = "1" THEN
               LET g_nqg.nqg12 = (l_nng20-l_nng21) * (l_nng09/12)
            ELSE
               LET g_nqg.nqg12 = (l_nng20-l_nng21) * (l_nng09/365)
                               * (l_nng102 - l_nng101)
            END IF
 
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12    #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13    #NO.FUN-640132 #NO.CHI-6A0004 
              
            IF l_nng16 = "1" THEN
               LET l_str = (YEAR(g_today)*12)+MONTH(g_today)
               LET l_end = (YEAR(l_nng102)*12)+MONTH(l_nng102)
               FOR l_j = l_str TO l_end
                  LET l_month = l_str MOD 12
                  IF l_month = 0 THEN
                     LET l_month = 12
                  END IF
                  LET l_year = (l_str - l_month) / 12 
                  LET l_date[1,4] = l_year USING '&&&&'
                  LET l_date[5,5] ='/'
                  LET l_date[6,7] = (l_month+1) USING '&&'
                  LET l_date[8,8] ='/'
                  LET l_date[9,10] ='01'
                  LET g_nqg.nqg04 = DATE(l_date)-1
 
                  IF g_nqg.nqg04 > g_nqf.nqf02 THEN
                     CONTINUE FOREACH
                  END IF
                  
                  LET l_year = YEAR(g_nqg.nqg04)
                  LET l_month = MONTH(g_nqg.nqg04)
                  LET l_nqc05 = 0
                  SELECT nqc05 INTO l_nqc05 FROM nqc_file
                   WHERE nqc01 = l_nqa01
                     AND nqc02 = g_nqg.nqg03
                     AND nqc03 = l_year
                     AND nqc04 = l_month
                  IF l_nqc05 = 0 THEN 
                     LET l_nqc05 = 1
                  END IF
                  LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
                  CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
                  LET g_nqg.nqg16 = ' '  #NO.FUN-650177
 
                  INSERT INTO nqg_file VALUES(g_nqg.*)
                  IF STATUS THEN
#                     CALL cl_err("ins nqg_nng1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                     CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nng1 error",1)  #No.FUN-660148
                     LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                     CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nng1 error',STATUS,1)
                     LET g_success = "N"
#                     RETURN
                     EXIT FOR
#No.FUN-710024--end
                  END IF
                  
                  INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                              g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                              g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                              g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                              g_nqg.nqg14,g_nqg.nqg15,
                                              g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
                  IF STATUS THEN
#                    CALL cl_err("ins all_nng1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                     CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nng1 error",1)  #No.FUN-660148
                     LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                     CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nng1 error',STATUS,1)
                     LET g_success = "N"
#                     RETURN
                     EXIT FOR
#No.FUN-710024--end
                  END IF
               END FOR 
            ELSE
               LET g_nqg.nqg04 = l_nng102
 
               IF g_nqg.nqg04 > g_nqf.nqf02 THEN
                  CONTINUE FOREACH
               END IF
               
               LET l_year = YEAR(g_nqg.nqg04)
               LET l_month = MONTH(g_nqg.nqg04)
               LET l_nqc05 = 0
               SELECT nqc05 INTO l_nqc05 FROM nqc_file
                WHERE nqc01 = l_nqa01
                  AND nqc02 = g_nqg.nqg03
                  AND nqc03 = l_year
                  AND nqc04 = l_month
               IF l_nqc05 = 0 THEN 
                  LET l_nqc05 = 1
               END IF
               LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
               CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
               LET g_nqg.nqg16 = ' '  #NO.FUN-650177
 
               INSERT INTO nqg_file VALUES(g_nqg.*)
               IF STATUS THEN
#                 CALL cl_err("ins nqg_nng2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                  CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nng2 error",1)  #No.FUN-660148
                  LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                  CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nng2 error',STATUS,1)
                  LET g_success = "N"
#                  RETURN
                  EXIT FOREACH
#No.FUN-710024--end
               END IF
               
               INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                           g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                           g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                           g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                           g_nqg.nqg14,g_nqg.nqg15,
                                           g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
               IF STATUS THEN
#                 CALL cl_err("ins all_nng2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#                  CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nng2 error",1)  #No.FUN-660148
                  LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
                  CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nng2 error',STATUS,1)
                  LET g_success = "N"
#                  RETURN
                  EXIT FOREACH
#No.FUN-710024--end
               END IF
            END IF
         END FOREACH
      END IF   #NO.FUN-670015
 
      #預計資金-固定類別
      LET g_sql = "SELECT nqe03,nqe07,nqe08,nqe10,nqe04,nqe05,nqe09",
#TQC-940177   ---start      
                 #"  FROM ",l_azp03,".dbo.nqe_file,",
                 #          l_azp03,".dbo.nqd_file",
                  #"  FROM ",s_dbstring(l_azp03 CLIPPED),"nqe_file,",   
                  #          s_dbstring(l_azp03 CLIPPED),"nqd_file",  
                  "  FROM ",cl_get_target_table(g_plant_new,'nqe_file'),",", #FUN-A50102   
                            cl_get_target_table(g_plant_new,'nqd_file'),     #FUN-A50102    
#TQC-940177   ---end      
                  " WHERE nqe05 = nqd01",
                  "   AND nqe12 = 'N'",
                  "   AND nqd04 = '1'" 
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                   
      PREPARE p910_pnqe1 FROM g_sql
      DECLARE p910_bnqe1 CURSOR FOR p910_pnqe1
      
      FOREACH p910_bnqe1 INTO g_nqg.nqg04,g_nqg.nqg10,g_nqg.nqg11,
                              g_nqg.nqg12,g_nqg.nqg05,g_nqg.nqg06,
                              l_nqe09
         IF STATUS THEN
#No.FUN-710024--begin 
#            CALL cl_err("fetch nqe1 error",STATUS,1)
            CALL s_errmsg('','','fetch nqe1 error',STATUS,1)   
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end 
         END IF
     
         IF g_nqg.nqg04 > g_nqf.nqf02 THEN
            CONTINUE FOREACH
         END IF
 
         IF g_nqg.nqg05 = "1" THEN
            IF g_nqg.nqg06 < "108" OR g_nqg.nqg06 > "113" THEN
               CONTINUE FOREACH
            END IF
         END IF
 
         IF g_nqg.nqg05 = "2" THEN
            IF g_nqg.nqg06 < "200" OR g_nqg.nqg06 > "202" THEN
               CONTINUE FOREACH
            END IF
         END IF
 
         IF g_nqg.nqg05 = "3" THEN
            CONTINUE FOREACH
         END IF
 
         LET g_nqg.nqg07 = ""
         LET g_nqg.nqg08 = ""
         LET g_nqg.nqg09 = ""
         IF l_nqe09 = "2" THEN
            LET g_nqg.nqg12 = g_nqg.nqg12 * -1
         END IF
         IF cl_null(g_nqg.nqg11) THEN
            LET g_nqg.nqg11 = 1
         END IF
         IF cl_null(g_nqg.nqg12) THEN
            LET g_nqg.nqg12 = 0
         END IF
         LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
         CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12   #NO.FUN-640132 #NO.CHI-6A0004
         CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13   #NO.FUN-640132 #NO.CHI-6A0004 
         LET l_year = YEAR(g_nqg.nqg04)
         LET l_month = MONTH(g_nqg.nqg04)
         LET l_nqc05 = 0
         SELECT nqc05 INTO l_nqc05 FROM nqc_file
          WHERE nqc01 = l_nqa01
            AND nqc02 = g_nqg.nqg03
            AND nqc03 = l_year
            AND nqc04 = l_month
         IF l_nqc05 = 0 THEN 
            LET l_nqc05 = 1
         END IF
         LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
         CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
         LET g_nqg.nqg16 = ' '  #NO.FUN-650177
         LET g_nqg.nqg17 = ' '  #NO.FUN-650177
 
         INSERT INTO nqg_file VALUES(g_nqg.*)
         IF STATUS THEN
#           CALL cl_err("ins nqg_nqe1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nqe1 error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nne1 error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
      
         INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                     g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                     g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                     g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                     g_nqg.nqg14,g_nqg.nqg15,
                                     g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
         IF STATUS THEN
#           CALL cl_err("ins all_nqe1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nqe1 error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nne1 error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
      END FOREACH
 
#NO.FUN-670015 mark--
#      #預計資金-自定義類別
#      LET g_sql = "SELECT nqe03,nqe07,nqe08,nqe10,nqe04,nqe09",
#                  "  FROM ",l_azp03,".dbo.nqe_file,",
#                            l_azp03,".dbo.nqd_file",
#                  " WHERE nqe05 = nqd01",
#                  "   AND nqe12 = 'N'",
#                  "   AND nqd04 = '2'"                  
#      PREPARE p910_pnqe2 FROM g_sql
#      DECLARE p910_bnqe2 CURSOR FOR p910_pnqe2
#      
#      FOREACH p910_bnqe2 INTO g_nqg.nqg04,g_nqg.nqg10,g_nqg.nqg11,
#                              g_nqg.nqg12,g_nqg.nqg05,l_nqe09
#         IF STATUS THEN
#            CALL cl_err("fetch nqe2 error",STATUS,1)
#            LET g_success = "N"
#            RETURN
#         END IF
#     
#         IF g_nqg.nqg04 > g_nqf.nqf02 THEN
#            CONTINUE FOREACH
#         END IF
#
#         IF g_nqg.nqg05 = "1" THEN
#            LET g_nqg.nqg06 = "114"
#         END IF
# 
#         IF g_nqg.nqg05 = "2" THEN
#            #LET g_nqg.nqg06 = "203"
#            LET g_nqg.nqg06 = "205"    #NO.FUN-650177
#         END IF
# 
#         IF g_nqg.nqg05 = "3" THEN
#            LET g_nqg.nqg06 = "304"
#         END IF
# 
##         LET g_nqg.nqg07 = ""
#         LET g_nqg.nqg08 = ""
#         LET g_nqg.nqg09 = ""
#         IF l_nqe09 = "2" THEN
#            LET g_nqg.nqg12 = g_nqg.nqg12 * -1
#         END IF
#         IF cl_null(g_nqg.nqg11) THEN
#            LET g_nqg.nqg11 = 1
#         END IF
#         IF cl_null(g_nqg.nqg12) THEN
#            LET g_nqg.nqg12 = 0
#         END IF
#         LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
#         LET l_year = YEAR(g_nqg.nqg04)
#         LET l_month = MONTH(g_nqg.nqg04)
#         LET l_nqc05 = 0
#         SELECT nqc05 INTO l_nqc05 FROM nqc_file
#          WHERE nqc01 = l_nqa01
#            AND nqc02 = g_nqg.nqg03
#            AND nqc03 = l_year
#            AND nqc04 = l_month
#         IF l_nqc05 = 0 THEN 
#            LET l_nqc05 = 1
#         END IF
#         LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
#         CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12   #NO.FUN-640132 #NO.CHI-6A0004 
#         CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13   #NO.FUN-640132 #NO.CHI-6A0004 
#         CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
#         LET g_nqg.nqg16 = ' ' #NO.FUN-650177
#         LET g_nqg.nqg17 = ' ' #NO.FUN-650177
#
#         INSERT INTO nqg_file VALUES(g_nqg.*)
#         IF STATUS THEN
##           CALL cl_err("ins nqg_nqe2 error",STATUS,1)   #No.FUN-660148
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nqe2 error",1)  #No.FUN-660148
#            LET g_success = "N"
#            RETURN
#         END IF
#      
#         INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
#                                     g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
#                                     g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
#                                     g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
#                                     g_nqg.nqg14,g_nqg.nqg15,
#                                     g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
#                                    
#         IF STATUS THEN
##           CALL cl_err("ins all_nqe2 error",STATUS,1)   #No.FUN-660148
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nqe2 error",1)  #No.FUN-660148
#            LET g_success = "N"
#            RETURN
#         END IF
#      END FOREACH
##NO.FUN-670015 mark--
 
#NO.FUN-650177 start--
      #外匯
      IF g_nqf.nqf15 = "Y" THEN
         SELECT ngi03 INTO l_ngi03_13 FROM ngi_file
          WHERE ngi01 = '13' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_13) OR l_ngi03_13 = 0 THEN 
              SELECT ngh13 INTO l_ngi03_13 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_13) THEN LET l_ngi03_13= 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today -  l_ngi03_13
         LET g_sql = "SELECT gxc041,gxc07,gxc01,gxc05,gxc06,gxc09,gxc10,gxc08",
                    #"  FROM ",l_azp03,".dbo.gxc_file", #TQC-940177 
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"gxc_file", #TQC-940177  
                     "  FROM ",cl_get_target_table(g_plant_new,'gxc_file'), #FUN-A50102
                     " WHERE (gxc03 BETWEEN '",l_bdate,"' AND '",l_edate,"')" 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102               
         PREPARE p910_pgxc FROM g_sql
         DECLARE p910_bgxc CURSOR FOR p910_pgxc
         
         FOREACH p910_bgxc INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,l_gxc06,g_nqg.nqg11,l_gxc10,
                                l_gxc08,g_nqg.nqg17
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch gxc error",STATUS,1)
               CALL s_errmsg('','','fetch gxc error',STATUS,1)  
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
            SELECT COUNT(*) INTO l_cnt 
              FROM gxe_file
             WHERE gxe01 = g_nqg.nqg08
            IF l_cnt > 0 THEN
               CONTINUE FOREACH
            END IF
            LET g_nqg.nqg05 = "2"
#NO.FUN-650177 start--         
           #LET g_sql = "SELECT alg02 FROM ",l_azp03,".dbo.alg_file", #TQC-940177  
            #LET g_sql = "SELECT alg02 FROM ",s_dbstring(l_azp03 CLIPPED),"alg_file", #TQC-940177
          LET g_sql = "SELECT alg02 FROM ",cl_get_target_table(g_plant_new,'alg_file'), #FUN-A50102 
                        " WHERE alg01 = '",g_nqg.nqg07,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102            
            PREPARE p910_palg4 FROM g_sql
            DECLARE p910_balg4 CURSOR FOR p910_palg4
 
            OPEN p910_balg4
            FETCH p910_balg4 INTO g_nqg.nqg17
#NO.FUN-650177 end-- 
 
            LET g_nqg.nqg06 = "203"    
            LET g_nqg.nqg09 = ""
            LET g_nqg.nqg12 = l_gxc08 * -1
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12   #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13   #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = g_nqg.nqg07  
            #買入
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_gxc1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_gxc1 error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_gxc1 error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_gxc1 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_gxc1 error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_gxc1 error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
            #賣出
            LET g_nqg.nqg10 = l_gxc06
            LET g_nqg.nqg11 = l_gxc10
            LET g_nqg.nqg13 = l_gxc08 * g_nqg.nqg11 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_gxc2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_gxc2 error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_gxc2 error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)
            IF STATUS THEN
#              CALL cl_err("ins all_gxc2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_gxc2 error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_gxc2 error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF     #NO.FUN-650177
 
      #投資 
      IF g_nqf.nqf16 = 'Y' THEN
         SELECT ngi03 INTO l_ngi03_14 FROM ngi_file
          WHERE ngi01 = '14' 
            AND ngi02 = l_plant[l_i]
         IF cl_null(l_ngi03_14) OR l_ngi03_14 = 0 THEN 
              SELECT ngh13 INTO l_ngi03_14 
                FROM ngh_file
               WHERE ngh00 = '0'
         END IF       
         IF cl_null(l_ngi03_14) THEN LET l_ngi03_14= 0 END IF
         LET l_edate = g_today
         LET l_bdate = g_today-  l_ngi03_14
         LET g_sql = "SELECT gsb04,nma01,gsb01,nma10,gsb121,nma02",
                    #"  FROM ",l_azp03,".dbo.gsb_file,",l_azp03,":nma_file", #TQC-940177 
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"gsb_file,",s_dbstring(l_azp03 CLIPPED),"nma_file", #TQC-940177 
                     "  FROM ",cl_get_target_table(g_plant_new,'gsb_file'),",", #FUN-A50102
                               cl_get_target_table(g_plant_new,'nma_file'),     #FUN-A50102
                     " WHERE gsb13 = nma04 ",
                     "   AND (gsb03 BETWEEN '",l_bdate,"' AND '",l_edate,"')"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102             
         PREPARE p910_pgsb FROM g_sql
         DECLARE p910_bgsb CURSOR FOR p910_pgsb
         
         FOREACH p910_bgsb INTO g_nqg.nqg04,g_nqg.nqg07,g_nqg.nqg08,
                                g_nqg.nqg10,g_nqg.nqg12,g_nqg.nqg17
            IF STATUS THEN
#No.FUN-710024--begin
#               CALL cl_err("fetch gsb error",STATUS,1)
               CALL s_errmsg('','','fetch gsb error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
            LET g_nqg.nqg05 = "2"
            LET g_nqg.nqg06 = "204"    
            LET g_nqg.nqg09 = ""
#           CALL s_currm(g_nqg.nqg10,g_nqg.nqg04,"S",l_azp03)           #FUN-980020 mark
            CALL s_currm(g_nqg.nqg10,g_nqg.nqg04,"S",l_plant[l_i])      #FUN-980020
                 RETURNING g_nqg.nqg11
            IF cl_null(g_nqg.nqg11) THEN
               LET g_nqg.nqg11 = 1
            END IF
            IF cl_null(g_nqg.nqg12) THEN
               LET g_nqg.nqg12 = 0
            END IF
            LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
            LET l_year = YEAR(g_nqg.nqg04)
            LET l_month = MONTH(g_nqg.nqg04)
            LET l_nqc05 = 0
            SELECT nqc05 INTO l_nqc05 FROM nqc_file
             WHERE nqc01 = l_nqa01
               AND nqc02 = g_nqg.nqg03
               AND nqc03 = l_year
               AND nqc04 = l_month
            IF l_nqc05 = 0 THEN 
               LET l_nqc05 = 1
            END IF
            LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
            CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12   #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13   #NO.FUN-640132 #NO.CHI-6A0004 
            CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
            LET g_nqg.nqg16 = g_nqg.nqg07  
 
            INSERT INTO nqg_file VALUES(g_nqg.*)
            IF STATUS THEN
#              CALL cl_err("ins nqg_gsb error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_gsb error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_gsb error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         
            INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                        g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                        g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                        g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                        g_nqg.nqg14,g_nqg.nqg15,
                                        g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
            IF STATUS THEN
#              CALL cl_err("ins all_gsb error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#               CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_gsb error",1)  #No.FUN-660148
               LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
               CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_gsb error',STATUS,1)
               LET g_success = "N"
#               RETURN
               EXIT FOREACH
#No.FUN-710024--end
            END IF
         END FOREACH
      END IF   #NO.FUN-650177
   END FOR
#No.FUN-710024--begin
      IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
      END IF 
#No.FUN-710024--end  
 
#NO.FUN-670015 start--
      #預計資金-自定義類別
      LET g_sql = "SELECT nqe03,nqe07,nqe08,nqe10,nqe04,nqe09",
#TQC-940177   ---start   
                 #"  FROM ",l_azp03,".dbo.nqe_file,",
                 #          l_azp03,".dbo.nqd_file",
                 # "  FROM ",s_dbstring(l_azp03 CLIPPED),"nqe_file,",    
                 #           s_dbstring(l_azp03 CLIPPED),"nqd_file",
            "  FROM ",cl_get_target_table(g_plant_new,'nqe_file'),",", #FUN-A50102   
                      cl_get_target_table(g_plant_new,'nqd_file'),     #FUN-A50102       
#TQC-940177   ---end      
                  " WHERE nqe05 = nqd01",
                  "   AND nqe12 = 'N'",
                  "   AND nqd04 = '2'"  
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102                 
      PREPARE p910_pnqe2 FROM g_sql
      DECLARE p910_bnqe2 CURSOR FOR p910_pnqe2
      
      FOREACH p910_bnqe2 INTO g_nqg.nqg04,g_nqg.nqg10,g_nqg.nqg11,
                              g_nqg.nqg12,g_nqg.nqg05,l_nqe09
         IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err("fetch nqe2 error",STATUS,1)
            CALL s_errmsg('','','fetch nqe2 error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
     
         IF g_nqg.nqg04 > g_nqf.nqf02 THEN
            CONTINUE FOREACH
         END IF
 
         IF g_nqg.nqg05 = "1" THEN
            LET g_nqg.nqg06 = "114"
         END IF
 
         IF g_nqg.nqg05 = "2" THEN
            #LET g_nqg.nqg06 = "203"
            LET g_nqg.nqg06 = "205"    #NO.FUN-650177
         END IF
 
         IF g_nqg.nqg05 = "3" THEN
            LET g_nqg.nqg06 = "304"
         END IF
 
         LET g_nqg.nqg07 = ""
         LET g_nqg.nqg08 = ""
         LET g_nqg.nqg09 = ""
         IF l_nqe09 = "2" THEN
            LET g_nqg.nqg12 = g_nqg.nqg12 * -1
         END IF
         IF cl_null(g_nqg.nqg11) THEN
            LET g_nqg.nqg11 = 1
         END IF
         IF cl_null(g_nqg.nqg12) THEN
            LET g_nqg.nqg12 = 0
         END IF
         LET g_nqg.nqg13 = g_nqg.nqg11 * g_nqg.nqg12
         LET l_year = YEAR(g_nqg.nqg04)
         LET l_month = MONTH(g_nqg.nqg04)
         LET l_nqc05 = 0
         SELECT nqc05 INTO l_nqc05 FROM nqc_file
          WHERE nqc01 = l_nqa01
            AND nqc02 = g_nqg.nqg03
            AND nqc03 = l_year
            AND nqc04 = l_month
         IF l_nqc05 = 0 THEN 
            LET l_nqc05 = 1
         END IF
         LET g_nqg.nqg14 = g_nqg.nqg13 * l_nqc05 
         CALL cl_digcut(g_nqg.nqg12,t_azi04) RETURNING g_nqg.nqg12   #NO.FUN-640132 #NO.CHI-6A0004 
         CALL cl_digcut(g_nqg.nqg13,t_azi04) RETURNING g_nqg.nqg13   #NO.FUN-640132 #NO.CHI-6A0004 
         CALL cl_digcut(g_nqg.nqg14,t_azi04) RETURNING g_nqg.nqg14   #NO.FUN-640132 #NO.CHI-6A0004 
         LET g_nqg.nqg16 = ' ' #NO.FUN-650177
         LET g_nqg.nqg17 = ' ' #NO.FUN-650177
 
         INSERT INTO nqg_file VALUES(g_nqg.*)
         IF STATUS THEN
#           CALL cl_err("ins nqg_nqe2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,g_nqg.nqg02,STATUS,"","ins nqg_nqe2 error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/",g_nqg.nqg02,"/",g_nqg.nqg03,"/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins nqg_nqe2 error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
      
         INSERT INTO nqg_file VALUES(g_nqg.nqg01,"ALL"," ",g_nqg.nqg04,
                                     g_nqg.nqg05,g_nqg.nqg06,g_nqg.nqg07,
                                     g_nqg.nqg08,g_nqg.nqg09,g_nqg.nqg10,
                                     g_nqg.nqg11,g_nqg.nqg12,g_nqg.nqg13,
                                     g_nqg.nqg14,g_nqg.nqg15,
                                     g_nqg.nqg16,g_nqg.nqg17)  #NO.FUN-650177 ADD
                                    
         IF STATUS THEN
#           CALL cl_err("ins all_nqe2 error",STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#            CALL cl_err3("ins","nqg_file",g_nqg.nqg01,"",STATUS,"","ins all_nqe2 error",1)  #No.FUN-660148
            LET g_showmsg=g_nqg.nqg01,"/","ALL","/"," ","/",g_nqg.nqg04,"/",g_nqg.nqg05,"/",g_nqg.nqg06
            CALL s_errmsg('nqg01,nqg02,nqg03,nqg04,nqg05,nqg06',g_showmsg,'ins all_nqe2 error',STATUS,1)
            LET g_success = "N"
#            RETURN
            EXIT FOREACH
#No.FUN-710024--end
         END IF
      END FOREACH
#NO.FUN-670015 end--
 
END FUNCTION
 
 

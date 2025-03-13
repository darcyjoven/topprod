# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp850.4gl
# Descriptions...: 盤點資料刪除作業
# Date & Author..: 03/03/07 By Mandy
# Modify.........: No.FUN-570082 05/07/19 By Carrier 多單位盤點資料刪除
# Modify.........: No.MOD-580369 05/09/02 By Claire 修正語法
# Modify.........: No.FUN-570122 06/02/17 by yiting 背景作業
# Modify.........: No.FUN-660208 06/08/11 By Claire 輸作QBE時,排除給單號是範圍的
# Modify.........: No.FUN-690026 06/09/18 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6C0153 06/12/26 By Ray 語言功能無效
# Modify.........: No.FUN-710025 07/01/19 By bnlent  錯誤訊息匯整
# Modify.........: No.TQC-750260 07/05/31 By pengu 不使用多單位時，標題"多單位現有庫存盤點標簽明細檔"未隱藏
# Modify.........: No.MOD-760114 07/07/28 By pengu 勾選"盤點資料刪除會彈出錯誤delete pia_file error
# Modify.........: No.MOD-7C0046 07/12/05 By Pengu 當使用多單位時會出現delete piaa_file錯誤訊息
# Modify.........: No.MOD-7C0193 07/12/25 By Pengu 調整盤點單流水號調整為10碼
# Modify.........: No.FUN-8A0086 08/10/20 By zhaijie完善錯誤匯總
# Modify.........: No.FUN-8A0147 08/12/16 By douzh 批序號-盤點調整新增下載pias_file檔
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A60013 10/06/02 By Sarah 只勾現有庫存,UPDATE pib_file時不應連在製的也一起更新
# Modify.........: No:MOD-A30090 10/07/23 By Pengu 多單位會有問題
# Modify.........: No:TQC-A80020 10/08/04 By Carrier p850_scr_unload5前若gs_wc2为空,则赋初值
# Modify.........: No:MOD-B30015 11/03/02 By sabrina 盤點標籤別改抓asmi300
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.TQC-B60282 11/06/22 By jan 修改在製工單判斷標籤開窗
# Modify.........: No.FUN-B70032 11/08/04 By jason ICD刻號/BIN-盤點調整新增下載piad_file檔
# Modify.........: No.TQC-C20451 12/03/01 By bart 分頁長度太小
# Modify.........: No:MOD-C50222 12/05/29 By ck2yuan 當備份標籤範圍的料都不作批序號管理時,則不提示pias_file無法下載的訊息
# Modify.........: No:CHI-B60070 12/05/29 By ck2yuan 修改MOD-B30015的錯誤
# Modify.........: No:MOD-C60210 12/06/28 By ck2yuan aim-106訊息前面多顯示table名稱與代號

DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm1  RECORD			    	# Print condition RECORD
                 stkyn  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 wc     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
                 a      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 b      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
               END RECORD,
          tm3  RECORD			    	# Print condition RECORD
                 wipyn  LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 wc     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
                 c      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
                 d      LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
               END RECORD,
   g_before_input_done  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   g_sql       string,                          #No.FUN-580092 HCN
   g_download  LIKE type_file.chr1,             #No.FUN-690026 VARCHAR(1)
   g_wc1       string,                          #tm1.wc的備份  #No.FUN-580092 HCN
   g_wc2       string,                          #tm3.wc的備份  #No.FUN-580092 HCN
   g_name1     LIKE type_file.chr1000,          #No.FUN-690026 VARCHAR(30)
   g_name2     LIKE type_file.chr1000,          #No.FUN-690026 VARCHAR(30)
   g_name3     LIKE type_file.chr1000,          #No.FUN-690026 VARCHAR(30)
   g_name4     LIKE type_file.chr1000,          #No.FUN-570082 #No.FUN-690026 VARCHAR(40)
   g_name5     LIKE type_file.chr1000,          #No.FUN-8A0147
   g_name6     LIKE type_file.chr1000,          #No.FUN-B70032
   gsb_wc      base.StringBuffer,
   gs_wc       STRING,
   gs_wc2      STRING,                          #No.FUN-8A0147
   gs_wc3      STRING,                          #No.FUN-B70032 
   l_n         LIKE type_file.num5,    #FUN-660208   #No.FUN-690026 SMALLINT
   p_row,p_col LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   m_tempdir   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(240)
   m_file      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(256)
   g_del_data  LIKE type_file.num20,   #刪除的資料有幾筆 #No.FUN-690026 DEC(16,0)
   g_pia01     LIKE pia_file.pia01,    #No.FUN-690026 VARCHAR(20)
   g_pib01     LIKE pib_file.pib01,    #FUN-660208 #No.FUN-690026 VARCHAR(5)
   g_pid01     LIKE type_file.chr20    #No.FUN-690026 VARCHAR(20)
DEFINE g_change_lang   LIKE type_file.chr1    #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_t1    LIKE oay_file.oayslip         #MOD-B30015 add
DEFINE g_t2    LIKE oay_file.oayslip         #MOD-B30015 add

MAIN
DEFINE l_flag LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   #No.FUN-570122 ----Start----
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm1.stkyn = ARG_VAL(1)
   LET tm1.wc = ARG_VAL(2)
   LET tm1.a = ARG_VAL(3)
   LET tm1.b = ARG_VAL(4)
   LET tm3.wipyn = ARG_VAL(5)
   LET tm3.wc = ARG_VAL(6)
   LET tm3.c = ARG_VAL(7)
   LET tm3.d = ARG_VAL(8)
   LET g_bgjob = ARG_VAL(9)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF g_bgjob = 'Y' THEN
      IF tm1.stkyn = 'Y' AND tm1.b = 'Y' THEN
         LET g_name1='pia_file.',g_today USING 'yymmdd'
         LET g_name4='piaa_file.',g_today USING 'yymmdd'
         LET g_name5='pias_file.',g_today USING 'yymmdd'     #No.FUN-8A0147
         IF s_industry('icd') THEN LET g_name6='piad_file.',g_today USING 'yymmdd' END IF #No.FUN-B70032
      END IF
      IF tm3.wipyn = 'Y' AND tm3.d = 'Y' THEN
         LET g_name2='pid_file.',g_today USING 'yymmdd'
         LET g_name3='pie_file.',g_today USING 'yymmdd'
      END IF
   END IF
   #No.FUN-570122 ---end---
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM 
   END IF
#--NO.FUN-570122 MARK--------------
#   LET p_row = 4 LET p_col = 15
 
#   OPEN WINDOW p850_w AT p_row,p_col WITH FORM "aim/42f/aimp850"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#   #No.FUN-570082  --begin
#   IF g_sma.sma115 IS NULL OR g_sma.sma115='N' THEN
#      CALL cl_set_comp_lab_text("dummy11",' ')
#      CALL cl_set_comp_visible("name4",FALSE)
#   END IF
#   #No.FUN-570082  --end
 
#   CALL cl_opmsg('p')
#--NO.FUN-570122 MARK----------------
   WHILE TRUE
 
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN      #FUN-570122
          CALL p850_tm(0,0)		        # Input print condition
          IF cl_null(tm1.wc) THEN
              LET tm1.wc = ' 1=1 '
              LET g_wc1 = tm1.wc
          END IF
          IF cl_null(tm3.wc) THEN
              LET tm3.wc = ' 1=1 '
              LET g_wc2 = tm3.wc
          END IF
          IF NOT (tm1.stkyn = 'N' AND tm3.wipyn = 'N') AND
            NOT (tm1.a = 'N' AND tm1.b = 'N' AND tm3.c = 'N' AND tm3.d = 'N') THEN
            IF cl_sure(5,15) THEN
                CALL cl_wait()
                IF tm1.b = 'Y' THEN
                #--->下載pia_file
                    MESSAGE ' UNLOAD pia_file *****'
                    CALL ui.Interface.refresh()
                    CALL p850_t1() #產生檔案
                    MESSAGE ' Unload pia_file End***** '
                    #No.FUN-570082  --begin
                    IF g_sma.sma115='Y' THEN
                    #--->下載piaa_file
                        MESSAGE ' UNLOAD piaa_file *****'
                        CALL ui.Interface.refresh()
                        CALL p850_t4() #產生檔案
                        MESSAGE ' Unload piaa_file End***** '
                    END IF
                    #No.FUN-570082  --end
#No.FUN-8A0147--begin
                #--->下載pias_file
                    MESSAGE ' UNLOAD pias_file *****'
                    CALL ui.Interface.refresh()
                    CALL p850_t5() #產生檔案
                    MESSAGE ' Unload pias_file End***** '
#No.FUN-8A0147--end
                #No.FUN-B70032 --START--
                IF s_industry('icd') THEN
                   #--->下載piad_file
                   MESSAGE ' UNLOAD piad_file *****'
                    CALL ui.Interface.refresh()
                   CALL p850_t6() #產生檔案
                   MESSAGE ' Unload piad_file End***** '
                END IF    
                #No.FUN-B70032 --END-- 
                    CALL ui.Interface.refresh()
                END IF
                IF tm3.d = 'Y' THEN
                #--->下載pid_file
                   MESSAGE ' UNLOAD pid_file *****'
                   CALL ui.Interface.refresh()
                   CALL p850_t2() #產生檔案
                   MESSAGE ' Unload pia_file End***** '
                   CALL ui.Interface.refresh()
                #--->下載pie_file
                   MESSAGE ' UNLOAD pie_file *****'
                   CALL ui.Interface.refresh()
                   CALL p850_t3() #產生檔案
                   MESSAGE ' Unload pie_file End***** '
                   CALL ui.Interface.refresh()
                END IF
                CALL p850() #盤點資料刪除
      #         CALL cl_end(19,20)
                CALL s_showmsg()      #No.FUN-710025
                IF g_success='Y' THEN
                    COMMIT WORK
                    CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
                ELSE
                    ROLLBACK WORK
                    CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
                END IF
 
                IF l_flag THEN
                    CONTINUE WHILE
                ELSE
                    EXIT WHILE
                END IF
                ERROR ""
            ELSE
               CONTINUE WHILE
            END IF
          ELSE
              CALL cl_err('','aim-850',1)
              CONTINUE WHILE
          END IF
    #FUN-570122  ----Start----
      ELSE
         IF cl_null(tm1.wc) THEN
            LET tm1.wc = ' 1=1 '
         END IF
         IF cl_null(tm3.wc) THEN
            LET tm3.wc = ' 1=1 '
         END IF
         LET g_wc1 = tm1.wc
         LET g_wc2 = tm3.wc
         IF NOT (tm1.stkyn = 'N' AND tm3.wipyn = 'N') AND NOT
            (tm1.a = 'N' AND tm1.b = 'N' AND tm3.c = 'N' AND tm3.d = 'N') THEN
            IF tm1.b = 'Y' THEN
               #--->下載pia_file
               CALL ui.Interface.refresh()
               #CALL p850_t1() #產生檔案
               #No.FUN-570082  --begin
               IF g_sma.sma115='Y' THEN
                  #--->下載piaa_file
                  CALL ui.Interface.refresh()
                  #CALL p850_t4() #產生檔案
               END IF
               #No.FUN-570082  --end
               CALL ui.Interface.refresh()
            END IF
            IF tm3.d = 'Y' THEN
               #--->下載pid_file
               CALL ui.Interface.refresh()
               #CALL p850_t2() #產生檔案
               CALL ui.Interface.refresh()
               #--->下載pie_file
               CALL ui.Interface.refresh()
               #CALL p850_t3() #產生檔案
               CALL ui.Interface.refresh()
            END IF
            CALL p850() #盤點資料刪除
            CALL s_showmsg()       #No.FUN-710025
            IF g_success = "Y" THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
            CALL cl_batch_bg_javamail(g_success)
            EXIT WHILE
         END IF
      END IF
#No.FUN-560249 ---end---
   END WHILE
   #CLOSE WINDOW p850_w  #NO.FUN-570122
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION p850_stk_qbe()
 
    OPEN WINDOW p850_stk_qbe AT 2,2 WITH FORM "aim/42f/aimp8501"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimp8501")
 
   INITIALIZE tm1.wc TO NULL			# Default condition
  #FUN-660208-begin
  #CONSTRUCT tm1.wc ON pia01 FROM stk01         
  #    BEFORE CONSTRUCT
  #       DISPLAY g_pia01 TO stk01
  WHILE TRUE
   CONSTRUCT BY NAME tm1.wc ON pib01   
       BEFORE CONSTRUCT
          DISPLAY g_pia01 TO pib01
  #FUN-660208-end
 
     #FUN-660208-begin
     #AFTER FIELD stk01
     #    LET g_pia01 = GET_FLDBUF(stk01)
     AFTER FIELD pib01
         LET g_pia01 = GET_FLDBUF(pib01)
         LET g_t1 = g_pia01       #MOD-B30015 add
     #FUN-660208-end
 
      ON ACTION CONTROLP
         CASE
           #FUN-660208-begin
           #WHEN INFIELD(stk01)
            WHEN INFIELD(pib01)
           #FUN-660208-end
              #MOD-B30015---modify---start---
              #CALL q_pib(10,3,tm1.wc) RETURNING tm1.wc
              #CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_pib'
              #LET g_qryparam.default1 = tm1.wc
              #CALL cl_create_qry() RETURNING tm1.wc
               LET g_t1 = NULL
               LET g_t1 = s_get_doc_no(tm1.wc)
               CALL q_smy(FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
               LET tm1.wc = g_t1
              #MOD-B30015---modify---end---
              #FUN-660208-begin
              #DISPLAY tm1.wc TO stk01
              #NEXT FIELD stk01
               DISPLAY tm1.wc TO pib01
               NEXT FIELD pib01
              #FUN-660208-end
 
            OTHERWISE
               EXIT CASE
 
            END CASE
 
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
   LET tm1.wc = tm1.wc CLIPPED,cl_get_extra_cond('pibuser', 'pibgrup') #FUN-980030
   IF INT_FLAG THEN
       LET INT_FLAG=0
       EXIT WHILE           #FUN-660208 add
   END IF
  #LET g_wc1 = tm1.wc                                       #CHI-B60070 mark
   LET g_wc1 = cl_replace_str(tm1.wc,"pib01","smyslip")     #CHI-B60070 add
 #FUN-660208-begin-- ##檢查輸入的單別是否存在單別檔
  LET l_n = 0
 #MOD-B30015---modify---start---
 #LET g_sql = "SELECT COUNT(*) FROM pib_file",
 #            " WHERE pibacti = 'Y'",
 #            "   AND ",tm1.wc CLIPPED
  LET g_sql = "SELECT COUNT(*) FROM smy_file",
              " WHERE smyacti = 'Y' AND UPPER(smysys) = 'AIM' ",
             #"   AND smykind = '5' AND smyslip = '",g_t1,"'"     #CHI-B60070 mark
              "   AND smykind = '5' AND ",g_wc1 CLIPPED           #CHI-B60070 add
 #MOD-B30015---modify---end---
  PREPARE p850_count_check FROM g_sql
  DECLARE p850_cnt_check CURSOR FOR p850_count_check
  OPEN p850_cnt_check
  FETCH p850_cnt_check INTO l_n
  IF l_n = 0 THEN
     CALL cl_err(g_pia01,'mfg0107',1)
     CONTINUE WHILE
  END IF
   EXIT WHILE
  END WHILE  
 #FUN-660208-end
 
   CLOSE WINDOW p850_stk_qbe
END FUNCTION
 
FUNCTION p850_wip_qbe()
 
    OPEN WINDOW p850_wip_qbe AT 2,2 WITH FORM "aim/42f/aimp8502"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimp8502")
 
   INITIALIZE tm3.wc TO NULL			# Default condition
  WHILE TRUE        #FUN-660208 add
   CONSTRUCT tm3.wc ON pid01 FROM wip01
       BEFORE CONSTRUCT
          DISPLAY g_pid01 TO wip01
 
       AFTER FIELD wip01
          LET g_pid01 = GET_FLDBUF(wip01)
          LET g_t2 = g_pid01              #MOD-B30015 add
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(wip01)
              #MOD-B30015---modify---start---
              #CALL q_pib(10,3,tm3.wc) RETURNING tm3.wc
              #CALL cl_init_qry_var()
              #LET g_qryparam.form = 'q_pib'
              #LET g_qryparam.default1 = tm3.wc
              #CALL cl_create_qry() RETURNING tm3.wc
               LET g_t2 = NULL
               LET g_t2 = s_get_doc_no(tm3.wc)
              #CALL q_smy(FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t2  #TQC-B60282
               CALL q_smy(FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t2  #TQC-B60282
               LET tm3.wc = g_t2
              #MOD-B30015---modify---end---
               DISPLAY tm3.wc TO wip01
               NEXT FIELD wip01
 
            OTHERWISE
               EXIT CASE
 
            END CASE
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
   IF INT_FLAG THEN
       LET INT_FLAG=0
       EXIT WHILE           #FUN-660208 add
   END IF
  #LET g_wc2 = tm3.wc                                       #CHI-B60070 mark
   LET g_wc2 = cl_replace_str(tm3.wc,"pid01","smyslip")     #CHI-B60070 add
 #FUN-660208-begin-- ##檢查輸入的單別是否存在單別檔
 #CALL p850_chen_wc(g_wc2,'pib01') RETURNING tm3.wc    #TQC-B60282
  LET tm3.wc = cl_replace_str(g_wc2,'pid01','smyslip')  #TQC-B60282
  LET l_n = 0
 #MOD-B30015---modify---start---
 #LET g_sql = "SELECT COUNT(*) FROM pib_file",
 #            " WHERE pibacti = 'Y'",
 #            "   AND ",tm3.wc CLIPPED
  LET g_sql = "SELECT COUNT(*) FROM smy_file",
              " WHERE smyacti = 'Y' AND UPPER(smysys) = 'AIM' ",
             #"   AND smykind = '5' AND smyslip = '",g_t2,"'"    #TQC-B60282 
              "   AND smykind = 'I' AND ",tm3.wc  #TQC-B60282
 #MOD-B30015---modify---end---
  PREPARE p850_count_checkd FROM g_sql
  DECLARE p850_cnt_checkd CURSOR FOR p850_count_checkd
  OPEN p850_cnt_checkd
  FETCH p850_cnt_checkd INTO l_n
  IF l_n = 0 THEN
     CALL cl_err(g_pid01,'mfg0107',1)
     CONTINUE WHILE
  END IF
   EXIT WHILE
  END WHILE  
 #FUN-660208-end
 
   CLOSE WINDOW p850_wip_qbe
END FUNCTION
 
FUNCTION p850_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_str         LIKE ze_file.ze03,      #No.FUN-690026 VARCHAR(70)
          l_cnt         LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_cmd	 	LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
   DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500)
   DEFINE l_i           LIKE type_file.num5     #No.MOD-7C0046 add
 
   #FUN-570122 ----Start----
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW p850_w AT p_row,p_col WITH FORM "aim/42f/aimp850"
      ATTRIBUTE (STYLE = g_win_style)
 
    CALL cl_ui_init()
 
   IF g_sma.sma115 IS NULL OR g_sma.sma115='N' THEN
      CALL cl_set_comp_lab_text("dummy11",' ')
      CALL cl_set_comp_visible("dummy11",FALSE)     #No.TQC-750260 add
      CALL cl_set_comp_visible("name4",FALSE)
   END IF
 
   #No.FUN-B70032 --START--
   IF NOT s_industry('icd') THEN
      CALL cl_set_comp_visible("name6,dummy13", FALSE)
   END IF       
   #No.FUN-B70032 --END--
 
   CALL cl_opmsg('p')
   #FUN-570122 ----End----
 
WHILE TRUE
   CALL cl_ui_init()
   CLEAR FORM
   LET tm1.stkyn = 'Y'
   LET tm1.a = 'N'
   LET tm1.b = 'Y'
   LET tm3.wipyn = 'Y'
   LET tm3.c = 'N'
   LET tm3.d = 'Y'
   LET g_pia01 = ""
   LET g_pid01 = ""
   LET g_bgjob = 'N'     #FUN-570122
 
  #FUN-570122 ----Start----
  #INPUT BY NAME tm1.stkyn,tm1.a,tm1.b,tm3.wipyn,tm3.c,tm3.d WITHOUT DEFAULTS
   INPUT BY NAME tm1.stkyn,tm1.a,tm1.b,tm3.wipyn,tm3.c,tm3.d,g_bgjob
   WITHOUT DEFAULTS
  #FUN-570122 ----End----
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL p850_set_entry()
          CALL p850_set_no_entry()
          LET g_before_input_done = TRUE
 
         IF tm1.stkyn = 'Y' AND tm1.b = 'Y' THEN
             LET g_name1='pia_file.',g_today USING 'yymmdd'
             #No.FUN-570082  --begin
             LET g_name4='piaa_file.',g_today USING 'yymmdd'
             LET g_name5='pias_file.',g_today USING 'yymmdd'      #No.FUN-8A0147
             DISPLAY g_name1 TO FORMONLY.name1
             DISPLAY g_name4 TO FORMONLY.name4
             DISPLAY g_name5 TO FORMONLY.name5                    #No.FUN-8A0147
             #No.FUN-570082  --end
             #No.FUN-B70032 --START--
             IF s_industry('icd') THEN   
                LET g_name6='piad_file.',g_today USING 'yymmdd'
                DISPLAY g_name6 TO FORMONLY.name6
             END IF
             #No.FUN-B70032 --END--
         END IF
         IF tm3.wipyn = 'Y' AND tm3.d = 'Y' THEN
             LET g_name2='pid_file.',g_today USING 'yymmdd'
             DISPLAY g_name2 TO FORMONLY.name2
             LET g_name3='pie_file.',g_today USING 'yymmdd'
             DISPLAY g_name3 TO FORMONLY.name3
         END IF
 
      AFTER FIELD stkyn
         IF tm1.stkyn = 'N' THEN
             LET g_name1= NULL
             LET g_name4= NULL  #No.FUN-570082
             LET g_name5= NULL  #No.FUN-8A0147
             LET tm1.a = 'N'
             LET tm1.b = 'N'
             DISPLAY tm1.a TO FORMONLY.a
             DISPLAY tm1.b TO FORMONLY.b
             DISPLAY g_name1 TO FORMONLY.name1
             DISPLAY g_name4 TO FORMONLY.name4   #No.FUN-570082
             DISPLAY g_name5 TO FORMONLY.name5   #No.FUN-8A0147
             #No.FUN-B70032 --START--
             IF s_industry('icd') THEN
                LET g_name6 = NULL
                DISPLAY g_name6 TO FORMONLY.name6
             END IF
             #No.FUN-B70032 --END--
         END IF
 
      AFTER FIELD a
         IF tm1.a NOT MATCHES "[YN]" OR tm1.a IS NULL
            THEN NEXT FIELD a
         END IF
         IF tm1.a = 'Y' THEN
             LET g_sql = "SELECT COUNT(*) FROM pia_file",
                         " WHERE (pia19 IS NULL OR pia19 = 'N')",
                         "   AND (pia02 IS NOT NULL)",
                        #"   AND ",tm1.wc CLIPPED               #CHI-B60070 mark
                         "   AND pia01 LIKE '",g_t1,"%'"        #CHI-B60070 add
             PREPARE p850_count1 FROM g_sql
             DECLARE p850_cnt1 CURSOR FOR p850_count1
             OPEN p850_cnt1
             FETCH p850_cnt1 INTO g_cnt
             IF g_cnt > 0 THEN
                 CALL cl_getmsg('mfg0123',g_lang) RETURNING l_str
                 IF NOT cl_prompt(0,0,l_str) THEN
                     LET tm1.a='N'
                     DISPLAY tm1.a TO FORMONLY.a
                     NEXT FIELD a
                 END IF
             #No.FUN-570082  --begin
             ELSE
#No.FUN-8A0147--begin
                LET gs_wc2=tm1.wc CLIPPED
                IF cl_null(gs_wc2) THEN 
                   LET gs_wc2 ="1=1"
                ELSE 
                   LET l_i = 0 
                   LET l_i = gs_wc2.getIndexOf('pib',1)
                   IF l_i > 0 THEN
                      LET gs_wc2 = "pias",gs_wc2.subString(l_i+3,gs_wc2.getLength())
                   END IF
                END IF
#No.FUN-8A0147--begin
                #No.FUN-B70032 --START--
                IF s_industry('icd') THEN
                   LET gs_wc3=tm1.wc CLIPPED
                   IF cl_null(gs_wc3) THEN 
                      LET gs_wc3 ="1=1"
                   ELSE 
                      LET l_i = 0 
                      LET l_i = gs_wc3.getIndexOf('pib',1)
                      IF l_i > 0 THEN
                         LET gs_wc3 = "piad",gs_wc3.subString(l_i+3,gs_wc3.getLength())
                      END IF
                   END IF
                END IF    
                #No.FUN-B70032 --END-- 
                IF g_sma.sma115='Y' THEN
                   LET gs_wc=tm1.wc CLIPPED
                  #-----------No.MOD-7C0046 modify
                  #LET gsb_wc=base.StringBuffer.create()
                  #CALL gsb_wc.append(gs_wc.trim())
                  #CALL gsb_wc.replace("pia","piaa",0)
                  #LET gs_wc=gsb_wc.toString()
                   IF cl_null(gs_wc) THEN 
                      LET gs_wc ="1=1"
                   ELSE 
                      LET l_i = 0 
                      LET l_i = gs_wc.getIndexOf('pib',1)
                      IF l_i > 0 THEN
                         LET gs_wc = "piaa",gs_wc.subString(l_i+3,gs_wc.getLength())
                      END IF
                   END IF
                  #-----------No.MOD-7C0046 end 
                   LET g_sql = "SELECT COUNT(*) FROM piaa_file",
                               " WHERE (piaa19 IS NULL OR piaa19 = 'N')",
                               "   AND (piaa02 IS NOT NULL)",
                              #"   AND ",gs_wc.trim()             #CHI-B60070 mark
                               "   AND piaa01 LIKE '",g_t1,"%'"   #CHI-B60070 add
                   PREPARE p850_count4 FROM g_sql
                   DECLARE p850_cnt4 CURSOR FOR p850_count4
                   OPEN p850_cnt4
                   FETCH p850_cnt4 INTO g_cnt
                   IF g_cnt > 0 THEN
                       CALL cl_getmsg('mfg0123',g_lang) RETURNING l_str
                       IF NOT cl_prompt(0,0,l_str) THEN
                           LET tm1.a='N'
                           DISPLAY tm1.a TO FORMONLY.a
                           NEXT FIELD a
                       END IF
                   END IF
                END IF
             #No.FUN-570082  --end
             END IF
         END IF
 
      ON CHANGE b
         IF tm1.b NOT MATCHES "[YN]" OR tm1.b IS NULL
            THEN NEXT FIELD b
         END IF
         #No.FUN-570082  --begin
         IF tm1.b = 'Y' THEN
             LET g_name1='pia_file.',g_today USING 'yymmdd'
             LET g_name4='piaa_file.',g_today USING 'yymmdd'
             LET g_name5='pias_file.',g_today USING 'yymmdd'    #No.FUN-8A0147
             IF s_industry('icd') THEN LET g_name6='pias_file.',g_today USING 'yymmdd' END IF #No.FUN-B70032 
         ELSE
             LET g_name1= NULL
             LET g_name4= NULL
             LET g_name5= NULL                                  #No.FUN-8A0147
             IF s_industry('icd') THEN LET g_name6= NULL END IF #No.FUN-B70032 
         END IF
         DISPLAY g_name1 TO FORMONLY.name1
         DISPLAY g_name4 TO FORMONLY.name4
         DISPLAY g_name5 TO FORMONLY.name5                      #No.FUN-8A0147
         IF s_industry('icd') THEN DISPLAY g_name6 TO FORMONLY.name6 END IF #No.FUN-B70032 
         #No.FUN-570082  --end
 
 
      AFTER FIELD wipyn
         IF tm3.wipyn = 'N' THEN
             LET tm3.c = 'N'
             LET tm3.d = 'N'
             LET g_name2= NULL
             LET g_name3= NULL
             DISPLAY tm3.c TO FORMONLY.c
             DISPLAY tm3.d TO FORMONLY.d
             DISPLAY g_name2 TO FORMONLY.name2
             DISPLAY g_name3 TO FORMONLY.name3
         END IF
 
      AFTER FIELD c
         IF tm3.c NOT MATCHES "[YN]" OR tm3.c IS NULL
            THEN NEXT FIELD c
         END IF
         IF tm3.c = 'Y' THEN
             CALL p850_chen_wc(g_wc2,'pie01') RETURNING tm3.wc
             LET g_sql = "SELECT COUNT(*) FROM pie_file",
                         " WHERE (pie16 IS NULL OR pie16 = 'N')",
                         "   AND (pie02 IS NOT NULL)",
                        #"   AND ",tm3.wc CLIPPED            #CHI-B60070 mark
                         "   AND pie01 LIKE '",g_t2,"%'"     #CHI-B60070 add
             PREPARE p850_count2 FROM g_sql
             DECLARE p850_cnt2 CURSOR FOR p850_count2
             OPEN p850_cnt2
             FETCH p850_cnt2 INTO g_cnt
             IF g_cnt > 0 THEN
                #CALL cl_getmsg('mfg0123',g_lang) RETURNING l_str    #CHI-B60070 mark
                 CALL cl_getmsg('mfg0124',g_lang) RETURNING l_str    #CHI-B60070 add
                 IF NOT cl_prompt(0,0,l_str) THEN
                     LET tm3.c='N'
                     DISPLAY tm3.c TO FORMONLY.c
                     NEXT FIELD c
                 END IF
             END IF
         END IF
      ON CHANGE d
         IF tm3.d NOT MATCHES "[YN]" OR tm3.d IS NULL
            THEN NEXT FIELD d
         END IF
         IF tm3.d = 'Y' THEN
             LET g_name2='pid_file.',g_today USING 'yymmdd'
             LET g_name3='pie_file.',g_today USING 'yymmdd'
         ELSE
             LET g_name2= NULL
             LET g_name3= NULL
         END IF
         DISPLAY g_name2 TO FORMONLY.name2
         DISPLAY g_name3 TO FORMONLY.name3
 
      ON CHANGE stkyn
         IF tm1.stkyn = 'Y' THEN
            CALL cl_set_action_active("stk_qbe", TRUE)  #設定action 可執行
            CALL p850_set_entry()
         ELSE
            CALL cl_set_action_active("stk_qbe", FALSE) #設定action 不可執行
            CALL p850_set_no_entry()
            LET tm1.wc = NULL
            LET g_wc1 = NULL
            LET g_pia01 = NULL
            LET g_name1= NULL
            LET g_name4= NULL  #No.FUN-570082
            LET g_name5= NULL  #No.FUN-8A0147
            LET tm1.a = 'N'
            LET tm1.b = 'N'
            DISPLAY tm1.a TO FORMONLY.a
            DISPLAY tm1.b TO FORMONLY.b
            DISPLAY g_name1 TO FORMONLY.name1
            DISPLAY g_name4 TO FORMONLY.name4   #No.FUN-570082
            DISPLAY g_name5 TO FORMONLY.name5   #No.FUN-8A0147
            #No.FUN-B70032 --START--
            IF s_industry('icd') THEN
               LET g_name5= NULL
               DISPLAY g_name6 TO FORMONLY.name6
            END IF
            #No.FUN-B70032 --END--
         END IF
 
      ON ACTION stk_qbe
         CALL p850_stk_qbe()
         LET gs_wc=tm1.wc CLIPPED
         LET gs_wc2=tm1.wc CLIPPED              #No.FUN-8A0147
         IF s_industry('icd') THEN LET gs_wc3=tm1.wc CLIPPED END IF #No.FUN-B70032
        #-----------No.MOD-7C0046 modify
        ##No.FUN-570082  --begin
        #LET gsb_wc=base.StringBuffer.create()
        #CALL gsb_wc.append(gs_wc.trim())
        #CALL gsb_wc.replace("pia","piaa",0)
        #LET gs_wc=gsb_wc.toString()
        ##No.FUN-570082  --end
         IF cl_null(gs_wc) THEN 
            LET gs_wc ="1=1"
         ELSE 
            LET l_i = 0 
            LET l_i = gs_wc.getIndexOf('pib',1)
            IF l_i > 0 THEN
               LET gs_wc  = "piaa",gs_wc.subString(l_i+3,gs_wc.getLength())
            END IF
         END IF
 
#No.FUN-8A0147--begin
         IF cl_null(gs_wc2) THEN 
            LET gs_wc2 ="1=1"
         ELSE 
            LET l_i = 0 
            LET l_i = gs_wc2.getIndexOf('pib',1)
            IF l_i > 0 THEN
               LET gs_wc2 = "pias",gs_wc2.subString(l_i+3,gs_wc2.getLength())
            END IF
         END IF
#No.FUN-8A0147--end
        #No.FUN-B70032 --START--
        IF s_industry('icd') THEN
           IF cl_null(gs_wc3) THEN 
              LET gs_wc3 ="1=1"
           ELSE 
              LET l_i = 0 
              LET l_i = gs_wc3.getIndexOf('pib',1)
              IF l_i > 0 THEN
                 LET gs_wc3 = "piad",gs_wc3.subString(l_i+3,gs_wc3.getLength())
              END IF
           END IF
        END IF    
        #No.FUN-B70032 --END--
        #-----------No.MOD-7C0046 end 
 
 
      ON CHANGE wipyn
         IF tm3.wipyn = 'Y' THEN
            CALL cl_set_action_active("wip_qbe", TRUE)  #設定action 可執行
            CALL p850_set_entry()
         ELSE
            CALL cl_set_action_active("wip_qbe", FALSE) #設定action 不可執行
            CALL p850_set_no_entry()
            LET tm3.wc = NULL
            LET g_wc2 = NULL
            LET g_pid01 = NULL
            LET tm3.c = 'N'
            LET tm3.d = 'N'
            LET g_name2= NULL
            LET g_name3= NULL
            DISPLAY tm3.c TO FORMONLY.c
            DISPLAY tm3.d TO FORMONLY.d
            DISPLAY g_name2 TO FORMONLY.name2
            DISPLAY g_name3 TO FORMONLY.name3
         END IF
 
      #No.FUN-570122 ----Start----
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD bgjob
          END IF
      #No.FUN-570122 ----End----
 
      ON ACTION wip_qbe
         CALL p850_wip_qbe()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION locale
           #->No.FUN-570122--end---
           LET g_action_choice='locale'     #No.TQC-6C0153
        #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE
           #->No.FUN-570122--end---
         EXIT INPUT
 
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
 
     AFTER INPUT
        IF INT_FLAG THEN EXIT INPUT END IF
 
   END INPUT
 
   IF g_action_choice = "locale" THEN
      LET g_action_choice = ""
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
  #No.FUN-570122 ----Start----
  IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aimp850"
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('aimp850','9031',1)
     ELSE
        LET tm1.wc=cl_replace_str(tm1.wc, "'", "\"")
        LET tm3.wc=cl_replace_str(tm3.wc, "'", "\"")
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",tm1.stkyn CLIPPED,"'",
                     " '",tm1.wc CLIPPED,"'",
                     " '",tm1.a CLIPPED,"'",
                     " '",tm1.b CLIPPED,"'",
                     " '",tm3.wipyn CLIPPED,"'",
                     " '",tm3.wc CLIPPED,"'",
                     " '",tm3.c CLIPPED,"'",
                     " '",tm3.d CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('aimp850',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p850_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
     EXIT PROGRAM
  END IF
  #No.FUN-570122 ----End----
   EXIT WHILE
END WHILE
END FUNCTION
 
 
FUNCTION p850()
   DEFINE l_name	LIKE type_file.chr20,    # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#         l_time        LIKE type_file.chr8	 #No.FUN-6A0074
          l_sql         LIKE type_file.chr1000,  #No.FUN-690026 VARCHAR(2000)
          l_pia01       LIKE pib_file.pib01      #MOD-A60013 add
  #str MOD-A60013 add
   #DELETE pia_file/pid_file前,先記錄裡面有幾種單別
   DROP TABLE p850_tmp
   CREATE TEMP TABLE p850_tmp(
     type   LIKE type_file.chr3,
     pia01  LIKE pib_file.pib01);
   LET g_sql = "INSERT INTO p850_tmp ",
              #"SELECT DISTINCT 'stk',substr(pia01,1,",g_doc_len,") pia01",
               "SELECT DISTINCT 'stk',pia01[1,",g_doc_len,"] pia01",   #FUN-B40029
               "  FROM pia_file",
              #" WHERE ",tm1.wc CLIPPED              #CHI-B60070 mark
               " WHERE pia01 LIKE '",g_t1,"%'"       #CHI-B60070 add
   PREPARE p850_pre_tmp1 FROM g_sql
   EXECUTE p850_pre_tmp1
   LET g_sql = "INSERT INTO p850_tmp ",
              #"SELECT DISTINCT 'wip',substr(pid01,1,",g_doc_len,") pia01",
               "SELECT DISTINCT 'wip',pia01[1,",g_doc_len,"] pia01",   #FUN-B40029
               "  FROM pid_file",
              #" WHERE ",g_wc2 CLIPPED              #CHI-B60070 mark
               " WHERE pid01 LIKE '",g_t2,"%'"      #CHI-B60070 add
   PREPARE p850_pre_tmp2 FROM g_sql
   EXECUTE p850_pre_tmp2
   DECLARE p850_cs1 CURSOR WITH HOLD FOR
      SELECT pia01 FROM p850_tmp WHERE type='stk' ORDER BY pia01
   DECLARE p850_cs2 CURSOR WITH HOLD FOR
      SELECT pia01 FROM p850_tmp WHERE type='wip' ORDER BY pia01
  #end MOD-A60013 add

   LET g_success = 'Y'
   BEGIN WORK
   #鎖住標籤別檔
   IF SQLCA.sqlcode THEN
      CALL cl_err(SQLCA.sqlcode,'mfg0111',0)
      CALL cl_batch_bg_javamail("N")  #FUN-570122
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
 
#{現有庫存-----------------------------------------------------------現有庫存
   IF tm1.a ='Y' THEN
      LET g_del_data = 0
      #--->刪除[現有庫存]標籤明細檔
      message 'delete pia_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc1,'pia01') RETURNING tm1.wc   #No.MOD-760114 add
      LET g_sql = "DELETE FROM pia_file",
                 #" WHERE ",g_wc1 CLIPPED                 #No.MOD-760114 mark
                 #" WHERE ",tm1.wc CLIPPED                #No.MOD-760114 add #FUN-B70032 mark
                 " WHERE pia01 LIKE '",g_t1 CLIPPED,"%'"  #FUN-B70032 
      PREPARE p850_pre1 FROM g_sql
      EXECUTE p850_pre1
      IF SQLCA.sqlcode THEN
          CALL cl_err('delete pia_file error',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
      #---->盤點標籤產生參數檔
      message 'delete pic_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc1,'pic06') RETURNING tm1.wc
      LET g_sql = "DELETE FROM pic_file",
                 #" WHERE ",tm1.wc CLIPPED                  #CHI-B60070 mark
                  " WHERE pic06 LIKE '",g_t1 CLIPPED,"%'"   #CHI-B60070 add
      PREPARE p850_pre2 FROM g_sql
      EXECUTE p850_pre2
      IF SQLCA.sqlcode THEN
          CALL cl_err('delete pic_file error',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
      #--->盤點過帳錯誤訊息檔
      message 'delete pif_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc1,'pif01') RETURNING tm1.wc
      LET g_sql = "DELETE FROM pif_file",
                 #" WHERE ",tm1.wc CLIPPED                   #CHI-B60070 mark
                  " WHERE pif01 LIKE '",g_t1 CLIPPED,"%'"    #CHI-B60070 add
      PREPARE p850_pre3 FROM g_sql
      EXECUTE p850_pre3
      IF SQLCA.sqlcode THEN
          CALL cl_err('delete pif_file error',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
      
      #FUN-B70032 mark --START--
      #IF g_del_data != 0 THEN
         ##->更新標籤號碼檔
         #message 'upate pib_file (stk)'
         #CALL ui.Interface.refresh()
         #CALL p850_chen_wc(g_wc1,'pib01') RETURNING tm1.wc
         #FOREACH p850_cs1 INTO l_pia01   #MOD-A60013 add
            #LET g_sql = "UPDATE pib_file",
                       #######No.MOD-7C0193 modify
                       #"   SET pib03  ='000000',",
                        #"   SET pib03  ='0000000000',",
                       #######No.MOD-7C0193 end
                        #"       pibmodu='",g_user,"',",
                        #"       pibdate='",g_today,"'",
                        #" WHERE ",tm1.wc CLIPPED,
                        #"   AND pib01='",l_pia01,"'"   #MOD-A60013 add
            #PREPARE p850_pre4 FROM g_sql
            #EXECUTE p850_pre4
            #IF SQLCA.sqlcode THEN
               #CALL cl_err('update pib_file error)',SQLCA.sqlcode,1)
               #LET g_success='N'
            #END IF
         #END FOREACH   #MOD-A60013 add
      #END IF
      #FUN-B70032 mark --END--
      
      IF g_success = 'Y' THEN
         IF g_del_data = 0 THEN
            CALL cl_err('','aim-109',1)
         ELSE
            CALL cl_err('','aim-101',1)
         END IF
      END IF
   END IF
#現有庫存-----------------------------------------------------------現有庫存}
 
#No.FUN-570082  --begin
#{現有庫存-----------------------------------------------------------多單位現有庫存
   IF tm1.a ='Y' THEN
      IF g_sma.sma115='Y' THEN
         LET g_del_data = 0
         #--->刪除[多單位現有庫存]標籤明細檔
         message 'delete piaa_file'
         CALL ui.Interface.refresh()
         LET g_sql = "DELETE FROM piaa_file",
                     #" WHERE ",gs_wc.trim()                  #FUN-B70032 mark    
                     " WHERE piaa01 LIKE '",g_t1 CLIPPED,"%'" #FUN-B70032 
         PREPARE p850_mpre1 FROM g_sql
         EXECUTE p850_mpre1
         IF SQLCA.sqlcode THEN
            CALL cl_err('delete piaa_file error',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
         LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
         #FUN-B70032 mark --START-- 
         #IF g_del_data != 0 THEN
            ##->更新標籤號碼檔
            #message 'upate pib_file (stk)'
            #CALL ui.Interface.refresh()
            #CALL p850_chen_wc(g_wc1,'pib01') RETURNING tm1.wc
            #FOREACH p850_cs1 INTO l_pia01   #MOD-A60013 add
               #LET g_sql = "UPDATE pib_file",
                          #######No.MOD-7C0193 modify
                          #"   SET pib03  ='000000',",
                           #"   SET pib03  ='0000000000',",
                          #######No.MOD-7C0193 end
                           #"       pibmodu='",g_user,"',",
                           #"       pibdate='",g_today,"'",
                           #" WHERE ",tm1.wc CLIPPED,
                           #"   AND pib01='",l_pia01,"'"   #MOD-A60013 add
               #PREPARE p850_mpre4 FROM g_sql
               #EXECUTE p850_mpre4
               #IF SQLCA.sqlcode THEN
                  #CALL cl_err('update pib_file error)',SQLCA.sqlcode,1)
                  #LET g_success='N'
               #END IF
            #END FOREACH   #MOD-A60013 add
         #END IF
         #FUN-B70032 mark --END--
         
         IF g_success = 'Y' THEN
            IF g_del_data = 0 THEN
               CALL cl_err('','aim-862',1)
            ELSE
               CALL cl_err('','aim-861',1)
            END IF
         END IF
      END IF
   END IF
#現有庫存-----------------------------------------------------------多單位現有庫存}
#No.FUN-570082  --end
 
#No.FUN-8A0147--begin
#{現有庫存-----------------------------------------------------------現有庫存批/序號資料}
   IF tm1.a ='Y' THEN
      LET g_del_data = 0
      #--->刪除[現有庫存批/序號資料]標籤明細檔
      message 'delete pias_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc1,'pias01') RETURNING tm1.wc
      LET g_sql = "DELETE FROM pias_file",
                  #" WHERE ",gs_wc2.trim() CLIPPED         #FUN-B70032 mark
                  " WHERE pias01 LIKE '",g_t1 CLIPPED,"%'" #FUN-B70032        
      PREPARE p850_spre1 FROM g_sql
      EXECUTE p850_spre1
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete pias_file error',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
      #FUN-B70032 mark --START--      
      #IF g_del_data != 0 THEN
         ##->更新標籤號碼檔
         #message 'upate pib_file (stk)'
         #CALL ui.Interface.refresh()
         #CALL p850_chen_wc(g_wc1,'pib01') RETURNING tm1.wc
         #FOREACH p850_cs1 INTO l_pia01   #MOD-A60013 add
            #LET g_sql = "UPDATE pib_file",
                        #"   SET pib03  ='0000000000',",
                        #"       pibmodu='",g_user,"',",
                        #"       pibdate='",g_today,"'",
                        #" WHERE ",tm1.wc CLIPPED,
                        #"   AND pib01='",l_pia01,"'"   #MOD-A60013 add
            #PREPARE p850_spre5 FROM g_sql
            #EXECUTE p850_spre5
            #IF SQLCA.sqlcode THEN
               #CALL cl_err('update pib_file error)',SQLCA.sqlcode,1)
               #LET g_success='N'
            #END IF
         #END FOREACH   #MOD-A60013 add
      #END IF
      #FUN-B70032 mark --END--
      
      IF g_success = 'Y' THEN
         IF g_del_data = 0 THEN
            CALL cl_err('','aim-862',1)
         ELSE
            CALL cl_err('','aim-861',1)
         END IF
      END IF
   END IF
#現有庫存-----------------------------------------------------------現有庫存批/序號資料}
#No.FUN-8A0147--end
 
#No.FUN-B70032 --START--
#{現有庫存-----------------------------------------------------------現有庫存刻號/BIN資料}
   IF s_industry('icd') THEN
      IF tm1.a ='Y' THEN
         LET g_del_data = 0
         #--->刪除[現有庫存刻號/BIN資料]標籤明細檔
         message 'delete piad_file'
         CALL ui.Interface.refresh()
         LET g_sql = "DELETE FROM piad_file",
                     " WHERE piad01 LIKE '",g_t1 CLIPPED,"%'"         
         PREPARE p850_spre2 FROM g_sql
         EXECUTE p850_spre2
         IF SQLCA.sqlcode THEN
            CALL cl_err('delete piad_file error',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF         
         LET g_del_data = g_del_data + SQLCA.sqlerrd[3]         
         IF g_success = 'Y' THEN
            IF g_del_data = 0 THEN
               CALL cl_err('','aim-862',1)
            ELSE
               CALL cl_err('','aim-861',1)
            END IF
         END IF
      END IF
   END IF 
#現有庫存-----------------------------------------------------------現有庫存刻號/BIN資料}
#No.FUN-B70032 --END--
 
#{在製工單-----------------------------------------------------------在製工單
   IF tm3.c ='Y' THEN
      LET g_del_data = 0
      #--->刪除[在製工單]標籤明細檔
      message 'delete pid_file'
      CALL ui.Interface.refresh()
      LET g_sql = "DELETE FROM pid_file",
                 #" WHERE ",g_wc2 CLIPPED                     #CHI-B60070 mark
                  " WHERE pid01 LIKE '",g_t2 CLIPPED,"%'"     #CHI-B60070 add
      PREPARE p850_pre5 FROM g_sql
      EXECUTE p850_pre5
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete pid_file error',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
      #--->刪除[在製工單]下階用料資料檔
      message 'delete pie_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc2,'pie01') RETURNING tm3.wc
      LET g_sql = "DELETE FROM pie_file",
                 #" WHERE ",tm3.wc CLIPPED                   #CHI-B60070 mark
                  " WHERE pie01 LIKE '",g_t2 CLIPPED,"%'"    #CHI-B60070 add
      PREPARE p850_pre6 FROM g_sql
      EXECUTE p850_pre6
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete pie_file error',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
      #---->盤點標籤產生參數檔
      message 'delete pic_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc2,'pic06') RETURNING tm3.wc
      LET g_sql = "DELETE FROM pic_file",
                 #" WHERE ",tm3.wc CLIPPED                  #CHI-B60070 mark
                  " WHERE pic06 LIKE '",g_t2 CLIPPED,"%'"   #CHI-B60070 add
      PREPARE p850_pre7 FROM g_sql
      EXECUTE p850_pre7
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete pic_file error',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
 
      #--->盤點過帳錯誤訊息檔
      message 'delete pif_file'
      CALL ui.Interface.refresh()
      CALL p850_chen_wc(g_wc2,'pif01') RETURNING tm3.wc
      LET g_sql = "DELETE FROM pif_file",
                 #" WHERE ",tm3.wc CLIPPED                   #CHI-B60070 mark
                  " WHERE pif01 LIKE '",g_t2 CLIPPED,"%'"    #CHI-B60070 add
      PREPARE p850_pre8 FROM g_sql
      EXECUTE p850_pre8
      IF SQLCA.sqlcode THEN
         CALL cl_err('delete pif_file error',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET g_del_data = g_del_data + SQLCA.sqlerrd[3]
      IF g_del_data != 0 THEN
         #--->更新標籤號碼檔
         message 'upate pib_file (wip)'
         CALL ui.Interface.refresh()
         CALL p850_chen_wc(g_wc2,'pib01') RETURNING tm3.wc
         FOREACH p850_cs2 INTO l_pia01   #MOD-A60013 add
            LET g_sql = "UPDATE pib_file",
                       #------------No.MOD-7C0193 modify
                       #"   SET pib03  ='000000',",
                        "   SET pib03  ='0000000000',",
                       #------------No.MOD-7C0193 end
                        "       pibmodu='",g_user,"',",
                        "       pibdate='",g_today,"'",
                       #" WHERE ",tm3.wc CLIPPED,                 #CHI-B60070 mark
                        " WHERE pib01 LIKE '",g_t2 CLIPPED,"%'",  #CHI-B60070 add
                        "   AND pib01='",l_pia01,"'"   #MOD-A60013 add
            PREPARE p850_pre9 FROM g_sql
            EXECUTE p850_pre9
            IF SQLCA.sqlcode THEN
               CALL cl_err('update pib_file error)',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END FOREACH   #MOD-A60013 add
      END IF
      IF g_success = 'Y' THEN
         IF g_del_data = 0 THEN
            CALL cl_err('','aim-110',1)
         ELSE
            CALL cl_err('','aim-102',1)
         END IF
      END IF
   END IF
#在製工單-----------------------------------------------------------在製工單}
 
#  IF g_success = 'Y' THEN
#     CALL cl_cmmsg(1) COMMIT WORK
#  ELSE
#     CALL cl_rbmsg(1) ROLLBACK WORK
#  END IF
 
   UNLOCK TABLE pib_file
   UNLOCK TABLE pia_file
   UNLOCK TABLE piaa_file   #No.FUN-570082
   UNLOCK TABLE pid_file
   UNLOCK TABLE pie_file
END FUNCTION
 
FUNCTION p850_chen_wc(p_sql,p_str)
   DEFINE p_sql       LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          p_str       LIKE type_file.chr5,    #No.FUN-690026 VARCHAR(5)
          l_buf       LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(500)
          l_i,l_j     LIKE type_file.num10    #No.FUN-690026 INTEGER
 
   LET l_buf=p_sql
   LET l_j=length(l_buf)
   FOR l_i=1 TO l_j
     #IF l_buf[l_i,l_i+4]='pia01' THEN LET l_buf[l_i,l_i+4]=p_str END IF   #No.MOD-760114 mark
      IF l_buf[l_i,l_i+4]='pib01' THEN LET l_buf[l_i,l_i+4]=p_str END IF   #No.MOD-760114 add
      IF l_buf[l_i,l_i+4]='pid01' THEN LET l_buf[l_i,l_i+4]=p_str END IF
   END FOR
   RETURN l_buf
END FUNCTION
 
FUNCTION p850_t1()
DEFINE sr       RECORD LIKE pia_file.*,
       l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_name   LIKE type_file.chr20    #No.FUN-690026 VARCHAR(20)
 
   CALL p850_chen_wc(g_wc1,'pia01') RETURNING tm1.wc   #No.MOD-760114 add
   LET g_sql = "SELECT * FROM pia_file",
              #"  WHERE ",g_wc1 CLIPPED                #No.MOD-760114 mark
              #"  WHERE ",tm1.wc CLIPPED               #No.MOD-760114 add   #CHI-B60070 mark
               "  WHERE pia01 LIKE '",g_t1,"%'"        #CHI-B60070 add
   PREPARE p850_pre_unload1 FROM g_sql
   DECLARE p850_scr_unload1 CURSOR FOR p850_pre_unload1
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare:p850_scr_unload1',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N")  #FUN-570122
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   START REPORT p850_rep TO g_name1
   #LET g_page_line = 1
   LET g_download='N'
   CALL s_showmsg_init()   #No.FUN-710025
   FOREACH p850_scr_unload1 INTO sr.*
      #No.FUN-710025--Begin--                                                                                                      
      IF g_success='N' THEN                                                                                                        
      LET g_totsuccess='N'                                                                                                      
      LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
      #No.FUN-710025--End-
 
      IF SQLCA.sqlcode THEN
     #No.FUN-710025--Begin--
     #   CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
     #No.FUN-710025--End--
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET g_download = 'Y'
      OUTPUT TO REPORT p850_rep(sr.*)
   END FOREACH
   #No.FUN-710025--Begin--                                                                                                             
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
   #No.FUN-710025--End--
 
   FINISH REPORT p850_rep
   IF g_download='Y' THEN #代表有資料可下載
      CALL p850_download(g_name1,'aim-103')
   ELSE
     #CALL cl_err('','aim-106',1)         #MOD-C60210 mark
      CALL cl_err(g_name1,'aim-106',1)    #MOD-C60210 add
   END IF
END FUNCTION
 
FUNCTION p850_download(p_name,p_msg)
 DEFINE p_name   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(30)
        l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        l_status LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        p_msg    LIKE ze_file.ze01       #No.FUN-690026 VARCHAR(7)
 
   LET m_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(m_tempdir)
   IF l_n>0 THEN
      IF m_tempdir[l_n,l_n]='/' THEN
         LET m_tempdir[l_n,l_n]=' '
      END IF
   END IF
 
   IF cl_null(m_tempdir) THEN
      LET m_file=p_name
   ELSE
      LET m_file=m_tempdir CLIPPED,'/',p_name
   END IF
  #MOD-580369 mark download.sh 寫法
  #LET g_sql="download.sh '",m_file CLIPPED,"' 'c:\\tiptop\\",p_name CLIPPED,"'
  #MOD-580369-begin
   #NO.FUN-570122 START---
   IF g_bgjob = 'N' THEN
      IF NOT cl_download_file(m_file CLIPPED,"c:/tiptop/"|| p_name CLIPPED) THEN
         CALL cl_err('download err!','',1)
         RETURN
      END IF
   END IF
   #NO.FUN-570122 END---
   #MOD-580369-end
  #MOD-580369-begin mark
  #RUN g_sql RETURNING l_status
  #IF l_status THEN
  #   CALL cl_err('download err!',l_status,1)
  #   RETURN
  #ELSE
  #   CALL cl_err(p_name,p_msg,1)
  #END IF
  #MOD-580369-end mark
 
END FUNCTION
 
REPORT p850_rep(sr)
DEFINE sr RECORD LIKE pia_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         #PAGE LENGTH g_page_line   #TQC-C20451
FORMAT	
ON EVERY ROW
       PRINT sr.pia01,'^A',
             sr.pia02,'^A',
             sr.pia03,'^A',
             sr.pia04,'^A',
             sr.pia05,'^A',
             sr.pia06,'^A',
             sr.pia07,'^A',
             sr.pia08,'^A',
             sr.pia09,'^A',
             sr.pia10,'^A',
             sr.pia11,'^A',
             sr.pia12,'^A',
             sr.pia13,'^A',
             sr.pia14,'^A',
             sr.pia15,'^A',
             sr.pia16,'^A',
             sr.pia17,'^A',
             sr.pia18,'^A',
             sr.pia19,'^A',
             sr.pia30,'^A',
             sr.pia31,'^A',
             sr.pia32,'^A',
             sr.pia33,'^A',
             sr.pia34,'^A',
             sr.pia35,'^A',
             sr.pia40,'^A',
             sr.pia41,'^A',
             sr.pia42,'^A',
             sr.pia43,'^A',
             sr.pia44,'^A',
             sr.pia45,'^A',
             sr.pia50,'^A',
             sr.pia51,'^A',
             sr.pia52,'^A',
             sr.pia53,'^A',
             sr.pia54,'^A',
             sr.pia55,'^A',
             sr.pia60,'^A',
             sr.pia61,'^A',
             sr.pia62,'^A',
             sr.pia63,'^A',
             sr.pia64,'^A',
             sr.pia65,'^A',
             sr.pia66,'^A',
             sr.pia67,'^A',
             sr.pia68,'^A',
             sr.pia900,'^A',
             sr.pia901,'^A',
             sr.pia902,'^A',
             sr.pia903,'^A'
END REPORT

FUNCTION p850_t2()
DEFINE sr       RECORD LIKE pid_file.*,
       l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_name   LIKE type_file.chr20    #No.FUN-690026 VARCHAR(20)
 
   LET g_sql = "SELECT * FROM pid_file",
              #"  WHERE ",g_wc2 CLIPPED           #CHI-B60070 mark
               "  WHERE pid01 LIKE '",g_t2,"%'"   #CHI-B60070 add
   PREPARE p850_pre_unload2 FROM g_sql
   DECLARE p850_scr_unload2 CURSOR FOR p850_pre_unload2
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare:p850_scr_unload2',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N")  #FUN-570122
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   START REPORT p850_rep2 TO g_name2
   LET g_download = 'N'
   FOREACH p850_scr_unload2 INTO sr.*
      #No.FUN-710025--Begin--                                                                                                      
      IF g_success='N' THEN                                                                                                        
         LET g_totsuccess='N'                                                                                                      
         LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
      #No.FUN-710025--End-
 
      IF SQLCA.sqlcode THEN
      #No.FUN-710025--Begin--
      #   CALL cl_err('foreach:',SQLCA.sqlcode,1)
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
      #No.FUN-710025--End--
          LET g_success='N'               #FUN-8A0086  提前
          EXIT FOREACH
          #LET g_success='N'               #FUN-8A0086 mark
          CALL cl_batch_bg_javamail("N")  #FUN-570122
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
          EXIT PROGRAM
      END IF
      LET g_download = 'Y'
      OUTPUT TO REPORT p850_rep2(sr.*)
   END FOREACH
   #No.FUN-710025--Begin--                                                                                                             
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
   #No.FUN-710025--End--
 
   FINISH REPORT p850_rep2
   IF g_download = 'Y' THEN #代表有資料可下載
      CALL p850_download(g_name2,'aim-104')
   ELSE
      CALL cl_err('','aim-107',1)
   END IF
END FUNCTION
 
REPORT p850_rep2(sr)
DEFINE sr RECORD LIKE pid_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         #PAGE LENGTH g_page_line  #TQC-C20451
FORMAT	
ON EVERY ROW
       PRINT sr.pid01,'^A',
             sr.pid02,'^A',
             sr.pid021,'^A',
             sr.pid022,'^A',
             sr.pid023,'^A',
             sr.pid03,'^A',
             sr.pid04,'^A',
             sr.pid041,'^A',
             sr.pid042,'^A',
             sr.pid043,'^A',
             sr.pid044,'^A',
             sr.pid05,'^A',
             sr.pid06,'^A',
             sr.pid07,'^A',
             sr.pid08,'^A',
             sr.pid09,'^A',
             sr.pid10,'^A',
             sr.pid11,'^A',
             sr.pid12,'^A',
             sr.pid13,'^A',
             sr.pid14,'^A',
             sr.pid15,'^A',
             sr.pid16,'^A',
             sr.pid17,'^A',
             sr.pid18,'^A',
             sr.pid900,'^A',
             sr.pid901,'^A'
END REPORT
FUNCTION p850_t3()
DEFINE sr       RECORD LIKE pie_file.*,
       l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_name   LIKE type_file.chr20    #No.FUN-690026 VARCHAR(20)
 
       CALL p850_chen_wc(g_wc2,'pie01') RETURNING tm3.wc
       LET g_sql = "SELECT * FROM pie_file",
                  #"  WHERE ",tm3.wc CLIPPED          #CHI-B60070 mark
                   "  WHERE pie01 LIKE '",g_t2,"%'"   #CHI-B60070 add
       PREPARE p850_pre_unload3 FROM g_sql
       DECLARE p850_scr_unload3 CURSOR FOR p850_pre_unload3
       IF SQLCA.sqlcode THEN
       #No.FUN-710025--Begin--                                                                                                      
       #   CALL cl_err('declare:p850_scr_unload3',SQLCA.sqlcode,1)
           CALL s_errmsg('','','declare:p850_scr_unload3',SQLCA.sqlcode,1)    
       #No.FUN-710025--End-
           LET g_success = 'N'
           CALL cl_batch_bg_javamail("N")  #FUN-570122
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
           EXIT PROGRAM
       END IF
       START REPORT p850_rep3 TO g_name3
       LET g_download='N'
       FOREACH p850_scr_unload3 INTO sr.*
           #No.FUN-710025--Begin--                                                                                                      
            IF g_success='N' THEN                                                                                                        
               LET g_totsuccess='N'                                                                                                      
               LET g_success="Y"                                                                                                         
            END IF                                                                                                                       
           #No.FUN-710025--End-
 
           IF SQLCA.sqlcode THEN
           #No.FUN-710025--Begin--
           #   CALL cl_err('foreach:',SQLCA.sqlcode,1)
               CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
           #No.FUN-710025--End--
               LET g_success='N'
               EXIT FOREACH
           END IF
           LET g_download='Y'
           OUTPUT TO REPORT p850_rep3(sr.*)
       END FOREACH
           #No.FUN-710025--Begin--                                                                                                             
           IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
           END IF                                                                                                                           
          #No.FUN-710025--End--
 
       FINISH REPORT p850_rep3
       IF g_download='Y' THEN #代表有資料可下載
           CALL p850_download(g_name3,'aim-105')
       ELSE
       #No.FUN-710025--Begin--
       #   CALL cl_err('','aim-108',1)
           CALL s_errmsg('','','','aim-108',1)
       #No.FUN-710025--End--
       END IF
END FUNCTION
 
REPORT p850_rep3(sr)
DEFINE sr RECORD LIKE pie_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         #PAGE LENGTH g_page_line  #TQC-C20451
FORMAT	
ON EVERY ROW
       PRINT sr.pie01,'^A',
             sr.pie02,'^A',
             sr.pie03,'^A',
             sr.pie04,'^A',
             sr.pie05,'^A',
             sr.pie06,'^A',
             sr.pie07,'^A',
             sr.pie08,'^A',
             sr.pie09,'^A',
             sr.pie11,'^A',
             sr.pie12,'^A',
             sr.pie13,'^A',
             sr.pie14,'^A',
             sr.pie15,'^A',
             sr.pie151,'^A',
             sr.pie152,'^A',
             sr.pie153,'^A',
             sr.pie16,'^A',
             sr.pie30,'^A',
             sr.pie31,'^A',
             sr.pie32,'^A',
             sr.pie33,'^A',
             sr.pie34,'^A',
             sr.pie35,'^A',
             sr.pie40,'^A',
             sr.pie41,'^A',
             sr.pie42,'^A',
             sr.pie43,'^A',
             sr.pie44,'^A',
             sr.pie45,'^A',
             sr.pie50,'^A',
             sr.pie51,'^A',
             sr.pie52,'^A',
             sr.pie53,'^A',
             sr.pie54,'^A',
             sr.pie55,'^A',
             sr.pie60,'^A',
             sr.pie61,'^A',
             sr.pie62,'^A',
             sr.pie63,'^A',
             sr.pie64,'^A',
             sr.pie65,'^A',
             sr.pie66,'^A',
             sr.pie67,'^A',
             sr.pie68,'^A',
             sr.pie900,'^A',
             sr.pie901,'^A',
             sr.pie902,'^A',
             sr.pie903,'^A'
END REPORT
FUNCTION p850_set_entry()
 
   IF INFIELD(stkyn) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("a,b",TRUE)
   END IF
 
   IF INFIELD(wipyn) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("c,d",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION p850_set_no_entry()
 
   IF INFIELD(stkyn) OR (NOT g_before_input_done) THEN
      IF tm1.stkyn = 'N' THEN
         CALL cl_set_comp_entry("a,b",FALSE)
      END IF
   END IF
   IF INFIELD(wipyn) OR (NOT g_before_input_done) THEN
      IF tm3.wipyn = 'N' THEN
         CALL cl_set_comp_entry("c,d",FALSE)
      END IF
   END IF
 
END FUNCTION
 
#No.FUN-570082  --begin
FUNCTION p850_t4()
DEFINE sr       RECORD LIKE piaa_file.*,
       l_n      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_name   LIKE type_file.chr20    #No.FUN-690026 VARCHAR(20)
 
   LET g_sql = "SELECT * FROM piaa_file",
              #" WHERE ",gs_wc CLIPPED      #No:MOD-A30090 modify #CHI-B60070 mark
               " WHERE piaa01 LIKE '",g_t1,"%'"                   #CHI-B60070 add
   PREPARE p850_pre_unload4 FROM g_sql
   DECLARE p850_scr_unload4 CURSOR FOR p850_pre_unload4
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare:p850_scr_unload4',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N")  #FUN-570122
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
   END IF
   START REPORT p850_rep4 TO g_name4
   LET g_page_line = 1
   LET g_download='N'
   FOREACH p850_scr_unload4 INTO sr.*
      #No.FUN-710025--Begin--                                                                                                      
      IF g_success='N' THEN                                                                                                        
         LET g_totsuccess='N'                                                                                                      
         LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
      #No.FUN-710025--End-
 
      IF SQLCA.sqlcode THEN
     #No.FUN-710025--Begin--
     #   CALL cl_err('foreach:',SQLCA.sqlcode,1)
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
     #No.FUN-710025--End--
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET g_download = 'Y'
      OUTPUT TO REPORT p850_rep4(sr.*)
   END FOREACH
   #No.FUN-710025--Begin--                                                                                                             
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
   #No.FUN-710025--End--
 
   FINISH REPORT p850_rep4
   IF g_download='Y' THEN #代表有資料可下載
      CALL p850_download(g_name4,'aim-863')
   ELSE
  #No.FUN-710025--Begin--
  #   CALL cl_err('','aim-106',1)
      CALL s_errmsg('','','','aim-106',1)
  #No.FUN-710025--End--
   END IF
END FUNCTION
 
REPORT p850_rep4(sr)
DEFINE sr RECORD LIKE piaa_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         #PAGE LENGTH g_page_line   #TQC-C20451
FORMAT	
ON EVERY ROW
       PRINT sr.piaa00,'^A',
             sr.piaa01,'^A',
             sr.piaa02,'^A',
             sr.piaa03,'^A',
             sr.piaa04,'^A',
             sr.piaa05,'^A',
             sr.piaa06,'^A',
             sr.piaa07,'^A',
             sr.piaa08,'^A',
             sr.piaa09,'^A',
             sr.piaa10,'^A',
             sr.piaa11,'^A',
             sr.piaa12,'^A',
             sr.piaa13,'^A',
             sr.piaa14,'^A',
             sr.piaa15,'^A',
             sr.piaa16,'^A',
             sr.piaa17,'^A',
             sr.piaa18,'^A',
             sr.piaa19,'^A',
             sr.piaa30,'^A',
             sr.piaa31,'^A',
             sr.piaa32,'^A',
             sr.piaa33,'^A',
             sr.piaa34,'^A',
             sr.piaa35,'^A',
             sr.piaa40,'^A',
             sr.piaa41,'^A',
             sr.piaa42,'^A',
             sr.piaa43,'^A',
             sr.piaa44,'^A',
             sr.piaa45,'^A',
             sr.piaa50,'^A',
             sr.piaa51,'^A',
             sr.piaa52,'^A',
             sr.piaa53,'^A',
             sr.piaa54,'^A',
             sr.piaa55,'^A',
             sr.piaa60,'^A',
             sr.piaa61,'^A',
             sr.piaa62,'^A',
             sr.piaa63,'^A',
             sr.piaa64,'^A',
             sr.piaa65,'^A',
             sr.piaa66,'^A',
             sr.piaa67,'^A',
             sr.piaa68,'^A',
             sr.piaa900,'^A',
             sr.piaa901,'^A',
             sr.piaa902,'^A',
             sr.piaa903,'^A'
END REPORT
#No.FUN-570082  --end
 
#No.FUN-8A0147--begin
FUNCTION p850_t5()
DEFINE sr       RECORD LIKE pias_file.*,
       l_n      LIKE type_file.num5,   
       l_name   LIKE type_file.chr20    
DEFINE l_n2     LIKE type_file.num5       #MOD-C50222 add
DEFINE l_t1     LIKE oay_file.oayslip     #MOD-C50222 add
 
   #No.TQC-A80020  --Begin                                                  
   IF cl_null(gs_wc2) THEN LET gs_wc2 = ' 1=1' END IF                       
   #No.TQC-A80020  --End

   LET g_sql = "SELECT * FROM pias_file",
              #"  WHERE ",gs_wc2.trim()             #CHI-B60070 mark
               "  WHERE pias01 LIKE '",g_t1,"%'"    #CHI-B60070 add
   PREPARE p850_pre_unload5 FROM g_sql
   DECLARE p850_scr_unload5 CURSOR FOR p850_pre_unload5
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare:p850_scr_unload5',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N") 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   START REPORT p850_rep5 TO g_name5
   LET g_page_line = 1
   LET g_download='N'
   CALL s_showmsg_init()   #No.FUN-710025
   FOREACH p850_scr_unload5 INTO sr.*
      IF g_success='N' THEN                                                                                                        
      LET g_totsuccess='N'                                                                                                      
      LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET g_download = 'Y'
      OUTPUT TO REPORT p850_rep5(sr.*)
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
 
   FINISH REPORT p850_rep5
   IF g_download='Y' THEN #代表有資料可下載
      CALL p850_download(g_name5,'aim-103')
   ELSE
     #MOD-C50222 str add-----
      LET l_n2 = 0
      LET l_t1 = g_t1,"%"
      SELECT COUNT(*) INTO l_n2 FROM pia_file,ima_file
       WHERE pia01 LIKE l_t1 AND pia02=ima01
         AND (ima918 = 'Y' OR ima921 = 'Y')
      IF l_n2 > 0 THEN
     #MOD-C50222 end add-----
        #CALL cl_err('','aim-106',1)        #MOD-C60210 mark
         CALL cl_err(g_name5,'aim-106',1)   #MOD-C60210 add
      END IF                           #MOD-C50222 add
   END IF
END FUNCTION
 
REPORT p850_rep5(sr)
DEFINE sr RECORD LIKE pias_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         #PAGE LENGTH g_page_line   #TQC-C20451
FORMAT	
ON EVERY ROW
       PRINT sr.pias01,'^A',
             sr.pias02,'^A',
             sr.pias03,'^A',
             sr.pias04,'^A',
             sr.pias05,'^A',
             sr.pias06,'^A',
             sr.pias07,'^A',
             sr.pias08,'^A',
             sr.pias09,'^A',
             sr.pias10,'^A',
             sr.pias11,'^A',
             sr.pias12,'^A',
             sr.pias13,'^A',
             sr.pias19,'^A',
             sr.pias30,'^A',
             sr.pias31,'^A',
             sr.pias32,'^A',
             sr.pias33,'^A',
             sr.pias34,'^A',
             sr.pias35,'^A',
             sr.pias40,'^A',
             sr.pias41,'^A',
             sr.pias42,'^A',
             sr.pias43,'^A',
             sr.pias44,'^A',
             sr.pias45,'^A',
             sr.pias50,'^A',
             sr.pias51,'^A',
             sr.pias52,'^A',
             sr.pias53,'^A',
             sr.pias54,'^A',
             sr.pias55,'^A',
             sr.pias60,'^A',
             sr.pias61,'^A',
             sr.pias62,'^A',
             sr.pias63,'^A',
             sr.pias64,'^A',
             sr.pias65,'^A' 
END REPORT
#No.FUN-8A0147--end

#No.FUN-B70032 --START--
FUNCTION p850_t6()
DEFINE sr       RECORD LIKE piad_file.*,
       l_n      LIKE type_file.num5,   
       l_name   LIKE type_file.chr20    
 
   IF cl_null(gs_wc3) THEN LET gs_wc3 = ' 1=1' END IF

   LET g_sql = "SELECT * FROM piad_file",
               " WHERE piad01 LIKE '",g_t1 CLIPPED,"%'"
   PREPARE p850_pre_unload6 FROM g_sql
   DECLARE p850_scr_unload6 CURSOR FOR p850_pre_unload6 
   IF SQLCA.sqlcode THEN
      CALL cl_err('declare:p850_scr_unload6',SQLCA.sqlcode,1)
      LET g_success = 'N'
      CALL cl_batch_bg_javamail("N") 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   START REPORT p850_rep6 TO g_name6
   LET g_page_line = 1
   LET g_download='N'
   CALL s_showmsg_init()  
   FOREACH p850_scr_unload6 INTO sr.* 
      IF g_success='N' THEN                                                                                                        
      LET g_totsuccess='N'                                                                                                      
      LET g_success="Y"                                                                                                         
      END IF                                                                                                                       
 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET g_download = 'Y'
      OUTPUT TO REPORT p850_rep6(sr.*)
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF                                                                                                                           
 
   FINISH REPORT p850_rep6
   IF g_download='Y' THEN #代表有資料可下載
      CALL p850_download(g_name6,'aim-103')
   ELSE
     #CALL cl_err('','aim-106',1)         #MOD-C60210 mark
      CALL cl_err(g_name6,'aim-106',1)    #MOD-C60210 add
   END IF
END FUNCTION

REPORT p850_rep6(sr)
DEFINE sr RECORD LIKE piad_file.*
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         #PAGE LENGTH g_page_line   #TQC-C20451
FORMAT	
ON EVERY ROW
       PRINT sr.piad01,'^A',
             sr.piad02,'^A',
             sr.piad03,'^A',
             sr.piad04,'^A',
             sr.piad05,'^A',
             sr.piad06,'^A',
             sr.piad07,'^A',
             sr.piad08,'^A',
             sr.piad09,'^A',
             sr.piad10,'^A',
             sr.piad11,'^A',
             sr.piad12,'^A',
             sr.piad13,'^A',
             sr.piad19,'^A',
             sr.piad30,'^A',
             sr.piad31,'^A',
             sr.piad32,'^A',
             sr.piad33,'^A',
             sr.piad34,'^A',
             sr.piad35,'^A',
             sr.piad40,'^A',
             sr.piad41,'^A',
             sr.piad42,'^A',
             sr.piad43,'^A',
             sr.piad44,'^A',
             sr.piad45,'^A',
             sr.piad50,'^A',
             sr.piad51,'^A',
             sr.piad52,'^A',
             sr.piad53,'^A',
             sr.piad54,'^A',
             sr.piad55,'^A',
             sr.piad60,'^A',
             sr.piad61,'^A',
             sr.piad62,'^A',
             sr.piad63,'^A',
             sr.piad64,'^A',
             sr.piad65,'^A' 
END REPORT
#No.FUN-B70032 --END--
#Patch....NO.TQC-610036 <001,003,004,005,006,007,008,009,010,011,012,013,014,015,016,017,018,019,020> #

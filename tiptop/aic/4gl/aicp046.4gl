# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aicp046.4gl
# Descriptions...: ICD委外採購單批次處理作業
# Date & Author..: 08/02/19 by kim (#FUN-810038)
# Note1..........: 
#                  1.單身二(刻號維護)增加一欄位"產品型號(sfbiicd08_b)"
#                  2.該欄位的維護時機與單身二的"生產料號(ima01)"相同
#                    (料件狀態為2且為刻號性質為D/G時)
#                  3.在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
#                    抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
#                    當生產料號與產品型號的預設值
#                    (生產料號/產品型號為空白時,才需做此預設動作)
#                  5.修改單身二生產料號後,檢查若有與該值不同的其他D/G項次
#                    生產料號,詢問是否將此生產料號更新至其他D/G項次的生產料號
#                  5.修改單身二產品型號後,檢查若有與該值不同的其他D/G項次
#                    產品型號,詢問是否將此產品型號更新至其他D/G項次的產品型號
# Note2..........: 
#                  1.除生產群組= 6.TKY允許單價為零外,若不存在有有效單價,
#                    則不允許按勾選(show err)
#                  2.若生產群組= 2.CP , 用入庫料號之母體檢查 Gross Die,
#                    若Gross die 不>0, 則出現錯誤訊息,不允許按勾選
#                  3.展下階備料: 若開立新工單生產備料為新舊料號, 則需檢查入庫
#                    料號是否存在取替代檔, 若存在, 則允許開立工單,
#                    如果不存在,則出現錯誤訊息, 不允許開立工單
#                  4.若執行過程中該張工單確認失敗,則作廢該工單,及刪除委外採購單
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業別表拆分 INSERT/DELETE
# Modify.........: No.CHI-830032 08/03/31 By kim GP5.1整合測試修改
# Modify.........: No.FUN-840194 08/06/23 By sherry 增加變動前置時間批量（ima061)
# Modify.........: No.FUN-870117 08/08/01 i301sub_firm1增加兩個參數
# Modify.........: No.MOD-880016
# Modify.........: No.MOD-910155 09/01/14 By chenyu 開窗回傳值數量不對
# Modify.........: No.FUN-910077 09/02/05 By kim 多項問題修改
# Modify.........: No.FUN-8C0081 09/03/09 By sabrina 原i301sub_firm1拆為i301sub_firm1_chk和i301sub_firm1_upd，所以在這些也要做調整
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.CHI-940028 09/04/13 By kim 修正FUN-8C0081造成的BUG
# Modify.........: No.TQC-940015 09/04/14 By kim sfai_file資料異動後未更新
# Modify.........: No.TQC-950055 09/05/12 By ve007 SQL ERROR
# Modify.........: No.CHI-940039 09/05/18 BY ve007 判斷是否存在于icg_file 時，加上sma841='8'的條件
# Modify.........: No.FUN-950021 09/05/26 By Carrier 呼叫i301sub時，加傳一個是否在transaction的參數
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-980033 09/11/11 By jan 采購單取價方式選"7.核價檔"時,不應卡aici006要有資料 
# Modify.........: No:TQC-9B0199 09/11/24 By sherry 開單自動審核時，不需要再開窗詢問
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:MOD-980110 09/11/25 By sabrina Assembly工單應檢查ICD料件AS維護作(icj_file)是否有建立資料
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-A30027 10/05/05 By jan 拆分出'執行'功能
# Modify.........: No.FUN-A10138 10/10/21 By jan 隱藏sfbiicd08/sfbiicd08_b 欄位
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B30192 11/05/05 By shenyang  修改字段icb05
# Modify.........: No.FUN-BA0008 11/10/07 By jason 刻號數量與生產發料數量相關修改
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.FUN-C30305 12/03/29 By bart 1.料號(sfb05)開窗要可以開所有上階料
#                                                 2.刻號挑選增加全選反全選
# Modify.........: No.FUN-C50107 12/05/24 By bart 1.更改生產數量大於庫存數時的錯誤訊息mfg9243
#                                                 2.wafer料的idc16為Null造成抓取l_qty2的SQL取不到值
#                                                 3.當pnz08='N'時,才做aic-139或aic-140的檢核
# Modify.........: No.TQC-C60188 12/06/26 By bart 計算PCS數與DIE數,應該要以庫存實際數來算
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/aicp046.global"

#FUN-C30305---begin
DEFINE g_icm  DYNAMIC ARRAY OF RECORD 
       icm02 LIKE icm_file.icm02  
END RECORD 
DEFINE l_i      LIKE type_file.num5 
#FUN-C30305---end

#主程式開始
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW p046_w WITH FORM "aic/42f/aicp046"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_set_comp_visible("sfbiicd13,memo",FALSE)   #先mark不秀出
   CALL cl_set_comp_visible("sfbiicd08,sfbiicd08_b",FALSE)   #先mark不秀出 #FUN-A10138
 
   CALL p046sub_create_bin_temp()  RETURNING l_table #FUN-A30027
   CALL p046sub_create_icout_temp()                  #FUN-A30027
   CALL p046_tm()
  #DROP TABLE bin_temp
   DROP TABLE icout_temp
 
   CLOSE WINDOW p046_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#-----------------------------------------------------------------------------#
#--------------------------取得符合條件資料且維護資料-------------------------#
#-----------------------------------------------------------------------------#
#QBE查詢資料 & INPUT條件
FUNCTION p046_tm()
DEFINE  lc_qbe_sn       LIKE gbm_file.gbm01
DEFINE  li_result       LIKE type_file.num5
DEFINE  l_gen02         LIKE gen_file.gen02,
        l_gen03         LIKE gen_file.gen03,
        l_gem02         LIKE gem_file.gem02,
        l_acti          LIKE type_file.chr1
 
   WHILE TRUE
 
      CLEAR FORM                             #清除畫面
      CALL g_data.clear()
      CALL g_idc.clear()
      CALL g_process.clear()
      CALL g_process_msg.clear()
      LET g_rec_b = 0
      LET g_rec_b2 = 0
      LET g_wc = NULL
     #DELETE FROM bin_temp         #FUN-A30027
      CALL cl_del_data(l_table)    #FUN-A30027
      DELETE FROM icout_temp       #FUN-A30027
 
      CONSTRUCT BY NAME g_wc ON rvu01,rvu03,rvu04,rvviicd03,rvv31
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(rvu01) #入庫單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_rvu1"
                  LET g_qryparam.arg1 = "1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu01
                  NEXT FIELD rvu01
 
               WHEN INFIELD(rvu04) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_pmc2"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvu04
                  NEXT FIELD rvu04
 
               WHEN INFIELD(rvviicd03) #母體料號
#FUN-AA0059 --Begin--
                #  CALL cl_init_qry_var()
                #  LET g_qryparam.state = "c"
                #  LET g_qryparam.form = "q_imaicd"
                #  LET g_qryparam.where= " imaicd04='1'"
                #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_imaicd","imaicd04='1'","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO rvviicd03
                  NEXT FIELD rvviicd03
 
               WHEN INFIELD(rvv31) #入庫料號
#FUN-AA0059 --Begin--
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.state = "c"
               #   LET g_qryparam.form = "q_ima"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                  DISPLAY g_qryparam.multiret TO rvv31
                  NEXT FIELD rvv31
 
               OTHERWISE EXIT CASE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rvuuser', 'rvugrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      IF g_wc = ' 1=1' THEN CALL cl_err('','9046',0) CONTINUE WHILE END IF
 
      #default值
      LET g_pmm04 = g_today
      LET g_pmm12 = g_user
      #FUN-A10138--begin--add-------
      LET g_pmm22 = g_aza.aza17
      LET g_pmm42 = 1
      SELECT ica042,ica41 INTO g_t1,g_t2 FROM ica_file
       WHERE ica00 = '0'
      #FUN-A10138--end--add---------
 
      LET l_gen02 = NULL
      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_pmm12
      DISPLAY l_gen02 TO gen02
 
      SELECT gen03 INTO g_pmm13 FROM gen_file WHERE gen01 = g_user
      LET g_sfp03 = g_today
 
      INPUT g_t1,g_pmm04,g_pmm12,g_pmm13,g_t2,g_sfp03,g_pmm22,g_pmm42
            WITHOUT DEFAULTS
       FROM g_t1,pmm04,pmm12,pmm13,g_t2,sfp03,pmm22,pmm42
 
         BEFORE INPUT
           CALL p046sub_set_entry()       #FUN-A30027
           CALL p046sub_set_no_entry()    #FUN-A30027
           CALL p046sub_set_no_required() #FUN-A30027
           CALL p046sub_set_required()    #FUN-A30027
 
         AFTER FIELD g_t1 #委外單別
            IF NOT cl_null(g_t1) THEN
               LET g_cnt = 0
               LET g_t1=s_get_doc_no(g_t1)
               SELECT COUNT(*) INTO g_cnt FROM smy_file
                WHERE smyslip = g_t1
                  AND smy57[6,6] = '1'  #No.TQC-9B0021 
               IF g_cnt = 0 THEN
                  CALL cl_err('','aic-141',0)
                  NEXT FIELD g_t1
               END IF
 
               CALL s_check_no("asf",g_t1,"","1","sfb_file","sfb01","")
                    RETURNING li_result,g_t1
               DISPLAY BY NAME g_t1
               IF (NOT li_result) THEN
                  NEXT FIELD g_t1
               END IF
               LET g_t1 = s_get_doc_no(g_t1)
            END IF
 
         AFTER FIELD g_t2 #發料單別
            IF NOT cl_null(g_t2) THEN
               CALL s_check_no("asf",g_t2,"","3","sfp_file", "sfp01","")
                    RETURNING li_result,g_t2
               DISPLAY BY NAME g_t2
               IF (NOT li_result) THEN
                  NEXT FIELD g_t2
               END IF
               LET g_t2 = s_get_doc_no(g_t2)
            END IF
 
         AFTER FIELD pmm12 #採購人員
           IF NOT cl_null(g_pmm12) THEN
              LET l_gen02 = NULL LET l_gen03 = NULL
              SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_acti
                FROM gen_file
               WHERE gen01 = g_pmm12
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm12
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm12
              END IF
              LET g_pmm13 = l_gen03
              DISPLAY g_pmm13 TO pmm13
              DISPLAY l_gen02 TO gen02
           ELSE
              DISPLAY '' TO gen02
           END IF
 
         AFTER FIELD pmm13 #採購部門
           IF NOT cl_null(g_pmm13) THEN
              SELECT gem02,gemacti INTO l_gem02,l_acti FROM gem_file
               WHERE gem01 = g_pmm13
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm13
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm13
              END IF
           END IF
 
         BEFORE FIELD pmm22
           CALL p046sub_set_entry()        #FUN-A30027
           CALL p046sub_set_no_required()  #FUN-A30027
 
         AFTER FIELD pmm22 #幣別
           IF NOT cl_null(g_pmm22) THEN
              SELECT aziacti INTO l_acti FROM azi_file
               WHERE azi01 = g_pmm22
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm22
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm22
              END IF
              CALL s_curr3(g_pmm22,g_pmm04,'S') RETURNING g_pmm42
              DISPLAY g_pmm42 TO pmm42
           END IF
           CALL p046sub_set_no_entry()  #FUN-A30027
           CALL p046sub_set_required()  #FUN-A30027
 
         AFTER FIELD pmm42 #匯率
           IF NOT cl_null(g_pmm22) THEN
              IF NOT cl_null(g_pmm42) THEN
                 IF g_pmm42 <= 0 THEN
                    CALL cl_err('','mfg9243',0)
                    NEXT FIELD pmm42
                 END IF
              END IF
           END IF
 
         AFTER FIELD sfp03 #扣帳日期
           IF NOT cl_null(g_sfp03) THEN
              IF g_sma.sma53 IS NOT NULL AND g_sfp03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
              END IF
              CALL s_yp(g_sfp03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
              END IF
           END IF
 
         AFTER INPUT  #總檢
           IF INT_FLAG THEN EXIT INPUT END IF
 
           #採購人員
           IF NOT cl_null(g_pmm12) THEN
              SELECT genacti INTO l_acti FROM gen_file WHERE gen01 = g_pmm12
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm12
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm12
              END IF
           END IF
 
           #採購部門
           IF NOT cl_null(g_pmm13) THEN
              SELECT gemacti INTO l_acti FROM gem_file WHERE gem01 = g_pmm13
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm13
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm13
              END IF
           END IF
 
           #幣別
           IF NOT cl_null(g_pmm22) THEN
              SELECT aziacti INTO l_acti FROM azi_file WHERE azi01 = g_pmm22
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',SQLCA.sqlcode,0)
                 NEXT FIELD pmm22
              END IF
              IF l_acti = 'N' THEN
                 CALL cl_err('','9028',0)
                 NEXT FIELD pmm22
              END IF
           END IF
 
           #匯率
           IF NOT cl_null(g_pmm22) THEN
              IF NOT cl_null(g_pmm42) THEN
                 IF g_pmm42 <= 0 THEN
                    CALL cl_err('','mfg9243',0)
                    NEXT FIELD pmm42
                 END IF
              END IF
           END IF
 
           #扣帳日期
           IF NOT cl_null(g_sfp03) THEN
              IF g_sma.sma53 IS NOT NULL AND g_sfp03 <= g_sma.sma53 THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD sfp03
              END IF
              CALL s_yp(g_sfp03) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD sfp03
              END IF
           END IF
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(g_t1) #委外單別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.where = "smykind= '1' AND smysys = 'asf' ",
                                        #"AND substring(smy57,6,6) = '1' "  #No.TQC-9B0021
                                         "AND smy57[6,6] = '1' "  #No.TQC-9B0021
                  CALL cl_create_qry() RETURNING g_t1
                  DISPLAY BY NAME g_t1
                  NEXT FIELD g_t1
 
               WHEN INFIELD(g_t2) #發料單別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_smy1"
                  LET g_qryparam.where = "smykind= '3' AND smysys = 'asf' "
                  CALL cl_create_qry() RETURNING g_t2
                  DISPLAY BY NAME g_t2
                  NEXT FIELD g_t2
 
               WHEN INFIELD(pmm12) #採購人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_pmm12
                  DISPLAY g_pmm12 TO pmm12
                  NEXT FIELD pmm12
 
               WHEN INFIELD(pmm13) #採購部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  CALL cl_create_qry() RETURNING g_pmm13
                  DISPLAY g_pmm13 TO pmm13
                  NEXT FIELD pmm13
 
               WHEN INFIELD(pmm22) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  CALL cl_create_qry() RETURNING g_pmm22
                  DISPLAY g_pmm22 TO pmm22
                  NEXT FIELD pmm22
 
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CALL p046_b_fill()
 
      IF g_rec_b > 0 THEN
         CALL p046_menu()
      ELSE
         CALL cl_err('','aco-058',1)
      END IF
   END WHILE
END FUNCTION
 
 
FUNCTION p046_menu()
   WHILE TRUE
      CALL p046_bp("G")
      CASE g_action_choice
           WHEN "Wo_set"   #工單維護
                IF cl_chk_act_auth() THEN
                   CALL p046_b()
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "Bin_set"   #BIN維護
                IF cl_chk_act_auth() THEN
                   CALL p046_b2(l_ac)
                ELSE
                   LET g_action_choice = NULL
                END IF
           WHEN "Execute"   #執行
                IF cl_chk_act_auth() THEN
                   IF cl_confirm('abx-080') THEN
                      CALL p046sub_process()  #FUN-A30027
                      CALL p046sub_out()   #FUN-A30027
                      EXIT WHILE
                   END IF
                END IF
           WHEN "help"
                CALL cl_show_help()
           WHEN "exit"
                LET INT_FLAG = 0
                EXIT WHILE
           WHEN "controlg"
                CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION p046_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept", FALSE)
 
   DISPLAY ARRAY g_data TO s_data.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL p046_refresh_b2(l_ac)
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION Wo_set
         LET g_action_choice = "Wo_set"
         EXIT DISPLAY
 
      ON ACTION Bin_set
         LET g_action_choice = "Bin_set"
         EXIT DISPLAY
 
      ON ACTION Execute
         LET g_action_choice = "Execute"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
    CALL cl_set_act_visible("accept",TRUE)
 
 
END FUNCTION
 
FUNCTION p046_b_fill()              #BODY FILL UP
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_cnt       LIKE type_file.num10
 
   LET g_sql = "SELECT 'N',rvv01,rvv02,rvv31,rvv031,imaicd04,rvv32,rvv33,",
               "       rvv34,pmn63,pmniicd08,pmniicd12,rvbiicd08,rvv17,",
             # "       rvv85,icb05,rvviicd03,'','','','','','','','',",  #FUN-B30192
               "       rvv85,imaicd14,rvviicd03,'','','','','','','','',",  #FUN-B30192
               "       pmniicd17,pmniicd12,'','','','',''",
               "  FROM rvu_file,rvv_file,pmn_file,ima_file,imaicd_file, ",
           #   "       icb_file,rvb_file,pmni_file,rvbi_file,rvvi_file",     #FUN-B30192
               "       rvb_file,pmni_file,rvbi_file,rvvi_file",              #FUN-B30192
               " WHERE rvu01 = rvv01 AND rvuconf = 'Y' ",     #已確認
               "   AND rvv36 = pmn01 AND rvv37 = pmn02 ",
               "   AND rvv04 = rvb01 AND rvv05 = rvb02 ",
               "   AND rvv17 > 0 ",                           #入庫量>0
               "   AND pmni01 = pmn01 ",
               "   AND pmni02 = pmn02 ",
               "   AND rvbi01 = rvb01 ",
               "   AND rvbi02 = rvb02 ",
               "   AND rvvi01 = rvv01 ",
               "   AND rvvi02 = rvv02 ",
               "   AND rvv31  = ima01 ",
               "   AND ima01  = imaicd00",                #CHI-830032
               "   AND imaicd04 <> '9'",  #FUN-980033
            #  "   AND rvviicd03 = icb01 ",  #FUN-B30192
            #  "   AND icb06 <> '2' ",                    #母體狀態未hold   #FUN-B30192
               "   AND (rvviicd07 = 'N' OR rvviicd07 = ' ' ", #排除委外最終站
               "        OR rvviicd07 IS NULL)",
               "   AND ",g_wc CLIPPED,
               " ORDER BY rvv01,rvv02"
 
   PREPARE p046_data_pre FROM g_sql
   DECLARE p046_data_cs CURSOR FOR p046_data_pre
 
   CALL g_data.clear()
   LET l_cnt = 1
   LET g_rec_b = 0
 
   FOREACH p046_data_cs INTO g_data[l_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
     #判斷是否有庫存量
      IF cl_null(g_data[l_cnt].rvv33) THEN LET g_data[l_cnt].rvv33 = " " END IF
      IF cl_null(g_data[l_cnt].rvv34) THEN LET g_data[l_cnt].rvv34 = " "
      END IF
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM img_file
       WHERE img01 = g_data[l_cnt].rvv31 AND img02 = g_data[l_cnt].rvv32
         AND img03 = g_data[l_cnt].rvv33 AND img04 = g_data[l_cnt].rvv34
         AND img10 IS NOT NULL AND img10 > 0
      IF g_cnt = 0 THEN CONTINUE FOREACH END IF
 
     #判斷是否有庫存量(idc_file)
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM idc_file
       WHERE idc01 = g_data[l_cnt].rvv31
         AND idc02 = g_data[l_cnt].rvv32
         AND idc03 = g_data[l_cnt].rvv33
         AND idc04 = g_data[l_cnt].rvv34
         AND (idc08 - idc21) > 0          #idc數量>0
         AND idc17 <> 'Y'                 #料件狀態未hold
 
      IF g_cnt = 0 THEN CONTINUE FOREACH END IF
 
     #判斷是否有下階段料(須開WO)
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM icm_file
       WHERE icm01 = g_data[l_cnt].rvv31
         AND icm02 IS NOT NULL #AND icmacti = 'Y'
      IF g_cnt = 0 THEN CONTINUE FOREACH END IF
 
    #設default值---------------------------------------------------------------
     #若wafer廠商無資料,用母體料號串icd檔(icb_file),帶出wafer廠商(icb08)
     IF cl_null(g_data[l_cnt].sfbiicd02) THEN
        SELECT icb08 INTO g_data[l_cnt].sfbiicd02 FROM icb_file
         WHERE icb01 = g_data[l_cnt].sfbiicd14
     END IF
 
     #若wafer site無資料,用母體料號串icd檔(icb_file),帶出wafer site(icb27)
     IF cl_null(g_data[l_cnt].sfbiicd03) THEN
        SELECT icb27 INTO g_data[l_cnt].sfbiicd03 FROM icb_file
         WHERE icb01 = g_data[l_cnt].sfbiicd14
     END IF
 
     LET l_cnt = l_cnt + 1
     IF l_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
 
   END FOREACH
   CALL g_data.deleteElement(l_cnt)
   LET g_rec_b = l_cnt - 1
   LET l_cnt = 0
END FUNCTION
 
FUNCTION p046_fill2(p_ac)
   DEFINE p_ac        LIKE type_file.num10
   DEFINE l_cnt       LIKE type_file.num10
   DEFINE l_sql       STRING   #FUN-A30027

  #FUN-A30027--begin--modify----------
  #DECLARE bin_temp_cs CURSOR FOR
  # SELECT * FROM bin_temp WHERE item1 = p_ac
  #  ORDER BY item2
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               " ORDER BY item2 "
   PREPARE r406_bin_temp01 FROM l_sql
   DECLARE bin_temp_cs CURSOR FOR r406_bin_temp01
  #FUN-A30027--end--modify-----------
   CALL g_idc.clear()
   LET l_cnt = 1
   LET g_rec_b2 = 0
 
   FOREACH bin_temp_cs INTO p_ac,g_idc[l_cnt].*
     LET l_cnt = l_cnt + 1
     IF l_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
        EXIT FOREACH
     END IF
   END FOREACH
   CALL g_idc.deleteElement(l_cnt)
   LET g_rec_b2 = l_cnt - 1
   LET l_cnt = 0
END FUNCTION
 
 
#單身
FUNCTION p046_b()
DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,              #檢查重複用
       l_cnt           LIKE type_file.num5,              #檢查重複用
       l_sql           STRING,
       l_ecdicd01      LIKE ecd_file.ecdicd01,
       l_icg01         LIKE icg_file.icg01,
       l_ima571        LIKE ima_file.ima571,
       l_sfbiicd09_o   LIKE sfbi_file.sfbiicd09
 
   INPUT ARRAY g_data WITHOUT DEFAULTS FROM s_data.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET g_data_t.* = g_data[l_ac].*
         CALL p046_refresh_b2(l_ac)
         LET l_sfbiicd09_o = g_data[l_ac].sfbiicd09
         NEXT FIELD sel
 
      BEFORE FIELD sel
         CALL p046_set_entry_b()
         CALL p046_set_no_required_b()
 
      ON CHANGE sel
         IF g_data[l_ac].sel = 'Y' THEN
            CALL p046_sfbiicd10()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_data[l_ac].sel = 'N'
               DISPLAY BY NAME g_data[l_ac].sel
               NEXT FIELD sel
            END IF
         END IF
 
      AFTER FIELD sel #挑選
         IF NOT cl_null(g_data[l_ac].sel) THEN
            IF g_data[l_ac].sel NOT MATCHES '[YN]' THEN
               NEXT FIELD sel
            END IF
         END IF
         CALL p046_set_no_entry_b()
         CALL p046_set_required_b()
 
      BEFORE FIELD sfbiicd09 #作業編號
         CALL p046_set_entry_b()
         CALL p046_set_no_required_b()
 
      AFTER FIELD sfbiicd09 #作業編號
         IF NOT cl_null(g_data[l_ac].sfbiicd09) THEN
            CALL p046_sfbiicd09()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfbiicd09,g_errno,0)
               NEXT FIELD sfbiicd09
            END IF
            IF cl_null(l_sfbiicd09_o) OR
               l_sfbiicd09_o <> g_data[l_ac].sfbiicd09 THEN
               CALL p046_def_sfb08() RETURNING g_data[l_ac].sfb08
               CALL p046_def_sfbiicd06()
            END IF
         END IF
 
         LET l_sfbiicd09_o = g_data[l_ac].sfbiicd09
         CALL p046_set_no_entry_b()
         CALL p046_set_required_b()
 
      BEFORE FIELD sfb05    #完成料號
         CALL p046_set_entry_b()
         CALL p046_set_no_required_b()
 
      AFTER FIELD sfb05     #完成料號
         IF NOT cl_null(g_data[l_ac].sfb05) THEN
            CALL p046_sfb05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfb05,g_errno,0)
               NEXT FIELD sfb05
            END IF
            IF g_data[l_ac].sfb05 <> g_data_t.sfb05 AND
               NOT cl_null(g_data[l_ac].sfb06) THEN
               CALL p046_sfb06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfb05,g_errno,0)
                  NEXT FIELD sfb05
               END IF
            END IF
         ELSE
            LET g_data[l_ac].sfb06 = NULL
            DISPLAY BY NAME g_data[l_ac].sfb06
         END IF
         LET g_data[l_ac].sfbiicd08 = g_data[l_ac].sfb05 #FUN-A10138
         CALL p046_set_no_entry_b()
         CALL p046_set_required_b()
 
      #070108 boblee 當TK/FT時預設產品型等於完成料號
#FUN-A10138--begin--mark-----
#     BEFORE FIELD sfbiicd08
#        CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01	#FUN-A30027
#        IF l_ecdicd01 MATCHES '[56]' THEN
#     LET g_data[l_ac].sfbiicd08 = g_data[l_ac].sfb05
#     DISPLAY BY NAME g_data[l_ac].sfbiicd08
#  END IF
#
#     AFTER FIELD sfbiicd08 #產品型號
#        IF NOT cl_null(g_data[l_ac].sfbiicd08) THEN  #FUN-910077 解除下面幾行的mark
#             CALL p046_sfbiicd08()
#            IF NOT cl_null(g_errno) THEN
#               CALL cl_err(g_data[l_ac].sfbiicd08,g_errno,0)
#               NEXT FIELD sfbiicd08
#            END IF
#        END IF
#FUN-A10138--end--mark--------
 
      BEFORE FIELD sfb82     #廠商編號
         IF cl_null(g_data[l_ac].sfb82) AND
            NOT cl_null(g_data[l_ac].sfbiicd09) THEN
            CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01 #FUN-A30027
            IF l_ecdicd01 MATCHES '[23456]' THEN
               IF g_sma.sma841 = '8' THEN  #FUN-980033
               IF l_ecdicd01 MATCHES '[23]' THEN
                  LET l_sql =
                      "SELECT icg03 FROM icg_file ",
                      " WHERE icg01 = ",
                      "       (SELECT rvviicd03 FROM rvvi_file",
                      "         WHERE rvvi01 = '",g_data[l_ac].rvv01,"'",
                      "           AND rvvi02 =  ",g_data[l_ac].rvv02,")",
                      "   AND icg02 = '",g_data[l_ac].sfbiicd09,"'",
                      "   AND icg16 = 'Y'"
               ELSE
                  LET l_sql =
                      "SELECT icg03 FROM icg_file ",
                      " WHERE icg01 = ",
                      "       (SELECT pmniicd15 FROM pmni_file ",
                      "         WHERE (pmni01 || pmni02) IN ",
                      "               (SELECT rvv36||rvv37 FROM rvv_file ",
                      "                WHERE rvv01 = '",g_data[l_ac].rvv01,"'",
                      "                  AND rvv02 =  ",g_data[l_ac].rvv02,"))",
                      "   AND icg02 = '",g_data[l_ac].sfbiicd09,"'",
                      "   AND icg16 = 'Y'"
               END IF
               DECLARE p046_sfb82_def CURSOR FROM l_sql
               OPEN p046_sfb82_def
               FETCH p046_sfb82_def INTO g_data[l_ac].sfb82
               END IF  #FUN-980033
            END IF
         END IF
 
      AFTER FIELD sfb82     #廠商編號
         IF NOT cl_null(g_data[l_ac].sfb82) THEN
            CALL p046_sfb82()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfb82,g_errno,0)
               NEXT FIELD sfb82
            END IF
         END IF
 
      AFTER FIELD sfbiicd02 #wafer廠商
         IF NOT cl_null(g_data[l_ac].sfbiicd02) THEN
            CALL p046_sfbiicd02()
         END IF
 
      AFTER FIELD sfbiicd03 #wafer site
         IF NOT cl_null(g_data[l_ac].sfbiicd03) THEN
            CALL p046_sfbiicd03()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfbiicd03,g_errno,0)
               NEXT FIELD sfbiicd03
            END IF
         END IF
 
      AFTER FIELD sfb08     #生產數量
         IF NOT cl_null(g_data[l_ac].sfb08) THEN
            CALL p046_sfb08()
            CALL p046_sfbiicd06()   #FUN-C50107 add
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfb08,g_errno,0)
               NEXT FIELD sfb08
            END IF
         END IF
 
      BEFORE FIELD sfb15    #預定交貨日
         IF cl_null(g_data[l_ac].sfb15) THEN
            CALL p046_def_sfb15()
         END IF
 
      AFTER FIELD sfb15     #預定交貨日
         IF NOT cl_null(g_data[l_ac].sfb15) THEN
            IF g_data[l_ac].sfb15 < g_pmm04 THEN
               CALL cl_err(g_data[l_ac].sfb15,'asf-310',0)
               NEXT FIELD sfb15
            END IF
         END IF
 
      AFTER FIELD sfb06     #製程編號
         IF NOT cl_null(g_data[l_ac].sfb06) THEN
            CALL p046_sfb06()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfb06,g_errno,0)
               NEXT FIELD sfb06
            END IF
         END IF
 
      AFTER FIELD sfbiicd01 #下階段廠商
         IF NOT cl_null(g_data[l_ac].sfbiicd01) THEN
            CALL p046_sfbiicd01()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_data[l_ac].sfbiicd01,g_errno,0)
               NEXT FIELD sfbiicd01
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_data[l_ac].* = g_data_t.*
            EXIT INPUT
         END IF
 
         #總檢
 
         #M檢查金額
         IF g_data[l_ac].sel = 'Y' THEN
            IF NOT p046_chk_price() THEN LET g_data[l_ac].sel = 'N' END IF
         END IF
 
         IF g_data[l_ac].sel = 'N' THEN
            #清空資料值
            LET g_data[l_ac].sfbiicd09 = NULL
            LET g_data[l_ac].sfb05 = NULL
            LET g_data[l_ac].sfbiicd08 = NULL
            LET g_data[l_ac].sfb82 = NULL
            LET g_data[l_ac].sfb08 = NULL
            LET g_data[l_ac].sfbiicd06 = NULL
            LET g_data[l_ac].sfb15 = NULL
            LET g_data[l_ac].sfbiicd02 = NULL
            LET g_data[l_ac].sfbiicd03 = NULL
            LET g_data[l_ac].sfb06 = NULL
            LET g_data[l_ac].sfbiicd01 = NULL
            LET g_data[l_ac].sfbiicd13 = NULL
            LET g_data[l_ac].pmc03_1 = NULL
            LET g_data[l_ac].pmc03_2 = NULL
         ELSE
            #最後資料總檢
            IF NOT cl_null(g_data[l_ac].sfbiicd09) THEN
               CALL p046_sfbiicd09()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfbiicd09,g_errno,0)
                  NEXT FIELD sfbiicd09
               END IF
            END IF
            IF NOT cl_null(g_data[l_ac].sfb05) THEN
               CALL p046_sfb05()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfb05,g_errno,0)
                  NEXT FIELD sfb05
               END IF
            END IF
            IF NOT cl_null(g_data[l_ac].sfb82) THEN
               CALL p046_sfb82()
            END IF
            IF NOT cl_null(g_data[l_ac].sfb08) THEN
               CALL p046_sfb08()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfb08,g_errno,0)
                  NEXT FIELD sfb08
               END IF
            END IF
            IF NOT cl_null(g_data[l_ac].sfbiicd02) THEN
               CALL p046_sfbiicd02()
            END IF
            IF NOT cl_null(g_data[l_ac].sfbiicd03) THEN
               CALL p046_sfbiicd03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfbiicd03,g_errno,0)
                  NEXT FIELD sfbiicd03
               END IF
            END IF
            IF NOT cl_null(g_data[l_ac].sfb06) THEN
               CALL p046_sfb06()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfb06,g_errno,0)
                  NEXT FIELD sfb06
               END IF
            END IF
            IF NOT cl_null(g_data[l_ac].sfbiicd01) THEN
               CALL p046_sfbiicd01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_data[l_ac].sfbiicd01,g_errno,0)
                  NEXT FIELD sfbiicd01
               END IF
            END IF
         END IF
         CALL p046_ins_bin_temp(l_ac)
         CALL p046_refresh_b2(l_ac)
 
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET g_data[l_ac].* = g_data_t.*
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(sfbiicd09) #作業編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ecd02_icd"
               LET g_qryparam.default1 = g_data[l_ac].sfbiicd09
               CALL cl_create_qry() RETURNING g_data[l_ac].sfbiicd09
               DISPLAY BY NAME g_data[l_ac].sfbiicd09
               NEXT FIELD sfbiicd09
 
            WHEN INFIELD(sfb05)     #完成料號
               #FUN-C30305---begin
               #CALL cl_init_qry_var()
               #LET g_qryparam.form ="q_icm02_icd"
               #LET g_qryparam.default1 = g_data[l_ac].sfb05
               #LET g_qryparam.arg1 = g_data[l_ac].rvv31
               #CALL cl_create_qry() RETURNING g_data[l_ac].sfb05
               CALL q_icm(FALSE,FALSE,g_data[l_ac].sfb05,g_data[l_ac].rvv31) RETURNING g_data[l_ac].sfb05
               #FUN-C30305---end
               DISPLAY BY NAME g_data[l_ac].sfb05
               NEXT FIELD sfb05
               
           #FUN-A10138--begin--mark--------
           #WHEN INFIELD(sfbiicd08) #產品型號
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form ="q_ick01_icd"
           #   LET g_qryparam.default1 = g_data[l_ac].sfbiicd08
           #   LET g_qryparam.arg1 = g_data[l_ac].sfbiicd14
           #   CALL cl_create_qry() RETURNING g_data[l_ac].sfbiicd08
           #   DISPLAY BY NAME g_data[l_ac].sfbiicd08
           #   NEXT FIELD sfbiicd08
           #FUN-A10138--end--mark-----------
 
            WHEN INFIELD(sfb82)     #廠商編號
               IF g_sma.sma841 = '8' THEN     #FUN-980033
               IF NOT cl_null(g_data[l_ac].sfbiicd09) THEN
                     CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) #FUN-A30027
                       RETURNING l_ecdicd01
                  LET l_icg01 = NULL
                  IF l_ecdicd01 MATCHES '[23]' THEN
                     SELECT rvviicd03 INTO l_icg01 FROM rvvi_file
                      WHERE rvvi01 = g_data[l_ac].rvv01
                        AND rvvi02 = g_data[l_ac].rvv02
                  END IF
                  IF l_ecdicd01 MATCHES '[456]' THEN
                      LET l_icg01 = g_data[l_ac].sfbiicd08
                  END IF
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_icg02_icd"
                  LET g_qryparam.default1 = g_data[l_ac].sfb82
                  LET g_qryparam.arg1 = l_icg01
                  LET g_qryparam.arg2 = g_today
                  LET g_qryparam.where= "icg02 = '",
                                         g_data[l_ac].sfbiicd09,"'"
                  CALL cl_create_qry() RETURNING g_data[l_ac].sfb82
                  DISPLAY BY NAME g_data[l_ac].sfb82
                  NEXT FIELD sfb82
               END IF
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pmc1"
                  LET g_qryparam.default1 = g_data[l_ac].sfb82
                  CALL cl_create_qry() RETURNING g_data[l_ac].sfb82
                  DISPLAY BY NAME g_data[l_ac].sfb82
                  NEXT FIELD sfb82
               END IF
 
            WHEN INFIELD(sfbiicd02) #wafer廠商
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_icg03_icd"
               LET g_qryparam.default1 = g_data[l_ac].sfbiicd02
               LET g_qryparam.arg1 = g_data[l_ac].sfbiicd14
               LET g_qryparam.arg2 = g_today
               CALL cl_create_qry() RETURNING g_data[l_ac].sfbiicd02
               DISPLAY BY NAME g_data[l_ac].sfbiicd02
               NEXT FIELD sfbiicd02
 
            WHEN INFIELD(sfbiicd03) #wafer site
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_icq02_icd_1"  #No.MOD-910155 add
               LET g_qryparam.default1 = g_data[l_ac].sfbiicd03
               LET g_qryparam.arg1 = g_data[l_ac].sfbiicd02
               CALL cl_create_qry() RETURNING g_data[l_ac].sfbiicd03
               DISPLAY BY NAME g_data[l_ac].sfbiicd03
               NEXT FIELD sfbiicd03
 
            WHEN INFIELD(sfb06)     #製程編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_ecu"
               LET g_qryparam.default1 = g_data[l_ac].sfb06
               LET g_qryparam.arg1 = g_data[l_ac].sfb05
              #FUN-A30027--begin--modify------
              #CALL cl_create_qry() RETURNING g_data[l_ac].sfbiicd08
              #DISPLAY BY NAME g_data[l_ac].sfbiicd08
              #NEXT FIELD sfbiicd08
               CALL cl_create_qry() RETURNING g_data[l_ac].sfb06
               DISPLAY BY NAME g_data[l_ac].sfb06
               NEXT FIELD sfb06
              #FUN-A30027--end--modify------
 
            WHEN INFIELD(sfbiicd01) #下階廠商
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_icg02_icd"
               LET g_qryparam.default1 = g_data[l_ac].sfbiicd01
               CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09)  #FUN-A30027
                       RETURNING l_ecdicd01
               IF l_ecdicd01 MATCHES '[23]' THEN
                  LET g_qryparam.arg1 = g_data[l_ac].sfbiicd14
               ELSE
                  LET g_qryparam.arg1 = g_data[l_ac].sfbiicd08
               END IF
               LET g_qryparam.arg2 = g_today
               LET g_qryparam.where = "icg02 = '",g_data[l_ac].sfbiicd09,"'"
               CALL cl_create_qry() RETURNING g_data[l_ac].sfbiicd01
               DISPLAY BY NAME g_data[l_ac].sfbiicd01
               NEXT FIELD sfbiicd01
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
   END INPUT
 
END FUNCTION
 
#FUN-A30027--begin--mark--
#FUNCTION p046_set_entry()
#    CALL cl_set_comp_entry("pmm42",TRUE)
#END FUNCTION

#FUNCTION p046_set_no_entry()
#   IF cl_null(g_pmm22) THEN
#      CALL cl_set_comp_entry("pmm42",FALSE)
#      LET g_pmm42=NULL
#   END IF
#END FUNCTION

#FUNCTION p046_set_no_required()
#   CALL cl_set_comp_required("pmm42",FALSE)
#END FUNCTION

#FUNCTION p046_set_required()
#   IF NOT cl_null(g_pmm22) THEN
#      CALL cl_set_comp_required("pmm42",TRUE)
#   END IF
#END FUNCTION
#FUN-A30027--end--msrk------
 
FUNCTION p046_set_entry_b()
    DEFINE l_field STRING
 
    IF INFIELD(sel) THEN
      #LET l_field = "sfbiicd09,sfb05,sfbiicd08,sfb82,sfb08,sfb15,", #FUN-A10138
       LET l_field = "sfbiicd09,sfb05,sfb82,sfb08,sfb15,",           #FUN-A10138
                     "sfbiicd02,sfbiicd03,sfb06,sfbiicd01,sfbiicd13,memo"
       CALL cl_set_comp_entry(l_field,TRUE)
    END IF
    IF INFIELD(sfbiicd09) OR INFIELD(sfb05) THEN
       CALL cl_set_comp_entry('sfb06',TRUE)
    END IF
END FUNCTION
 
FUNCTION p046_set_no_entry_b()
  DEFINE p_cmd   LIKE type_file.chr1,
         l_field STRING
 
    IF INFIELD(sel) AND g_data[l_ac].sel = 'N' THEN
      #LET l_field = "sfbiicd09,sfb05,sfbiicd08,sfb82,sfb08,sfb15,", #FUN-A10138
       LET l_field = "sfbiicd09,sfb05,sfb82,sfb08,sfb15,",           #FUN-A10138
                     "sfbiicd02,sfbiicd03,sfb06,sfbiicd01,sfbiicd13,memo"
       CALL cl_set_comp_entry(l_field,FALSE)
    END IF
 
    IF NOT cl_null(g_data[l_ac].sfbiicd09) AND
       NOT cl_null(g_data[l_ac].sfb05) THEN
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt FROM ecd_file
        WHERE ecd01 = g_data[l_ac].sfbiicd09 AND ecdicd01 = '6'
       IF g_cnt = 0 THEN
          CALL cl_set_comp_entry('sfb06',FALSE)
          LET g_data[l_ac].sfb06 = NULL
          DISPLAY BY NAME g_data[l_ac].sfb06
       END IF
    ELSE
       CALL cl_set_comp_entry('sfb06',FALSE)
       LET g_data[l_ac].sfb06 = NULL
       DISPLAY BY NAME g_data[l_ac].sfb06
    END IF
END FUNCTION
 
FUNCTION p046_set_required_b()
    DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
 
    IF INFIELD(sel) THEN
       IF NOT cl_null(g_data[l_ac].sel) AND g_data[l_ac].sel = 'Y' THEN
          CALL cl_set_comp_required('sfbiicd09,sfbiicd05',TRUE)
       END IF
    END IF
 
    IF INFIELD(sfbiicd09) THEN
       IF NOT cl_null(g_data[l_ac].sfbiicd09) THEN
          CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09)  #FUN-A30027
               RETURNING l_ecdicd01
         #IF l_ecdicd01 MATCHES '[456]' THEN             #FUN-A10138
         #   CALL cl_set_comp_required('sfbiicd08',TRUE) #FUN-A10138
         #END IF                                         #FUN-A10138
          IF l_ecdicd01 = '6' THEN
             CALL cl_set_comp_required('sfb06',TRUE)
          END IF
       END IF
    END IF
 
END FUNCTION
 
FUNCTION p046_set_no_required_b()
 
    IF INFIELD(sel) THEN
       CALL cl_set_comp_required('sfbiicd09,sfbiicd05',FALSE)
    END IF
 
    IF INFIELD(sfbiicd09) THEN
      #CALL cl_set_comp_required('sfbiicd08,sfbiicd06',FALSE)   #FUN-980033 #FUN-A10138
       CALL cl_set_comp_required('sfbiicd06',FALSE)   #FUN-A10138
    END IF
END FUNCTION
 
FUNCTION p046_set_entry_b2()
    CALL cl_set_comp_entry("ima01",TRUE)
   #CALL cl_set_comp_entry("sfbiicd08_b",TRUE)  #FUN-A10138
END FUNCTION
 
FUNCTION p046_set_no_entry_b2(p_ac)
    DEFINE p_ac LIKE type_file.num10
 
    IF g_idc[l_ac2].sel2 = 'N' THEN
       CALL cl_set_comp_entry("ima01",FALSE)
      #CALL cl_set_comp_entry("sfbiicd08_b",FALSE) #FUN-A10138
    ELSE
       #料件狀態為2,且為DG才可維護 ima01
       IF NOT (g_data[p_ac].imaicd04 = '2'
          AND g_idc[l_ac2].icf05 = '1') THEN
          CALL cl_set_comp_entry("ima01",FALSE)
         #CALL cl_set_comp_entry("sfbiicd08_b",FALSE)  #FUN-A10138
       END IF
    END IF
END FUNCTION
 
FUNCTION p046_set_required_b2(p_ac)
   DEFINE p_ac LIKE type_file.num10
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
 
   #料件狀態為2且為DG必填 ima01
   IF g_idc[l_ac2].sel2 = 'Y' AND
      g_data[p_ac].imaicd04 = '2' AND
      g_idc[l_ac2].icf05 = '1' THEN
      CALL cl_set_comp_required("ima01",TRUE)
 
      LET l_ecdicd01 = ''
      #若要產生的工單作業群組為456,則產品型號必填
      CALL p046sub_ecdicd01(g_data[p_ac].sfbiicd09)  #FUN-A30027
           RETURNING l_ecdicd01
      IF l_ecdicd01 MATCHES '[456]' THEN
        #CALL cl_set_comp_required("sfbiicd08_b",TRUE)  #FUN-A10138
         LET g_idc[l_ac2].sfbiicd08_b = g_data[p_ac].sfb05   #FUN-A10138
      END IF
   END IF
END FUNCTION
 
FUNCTION p046_set_no_required_b2()
    CALL cl_set_comp_required("ima01",FALSE)
   #CALL cl_set_comp_required("sfbiicd08_b",FALSE)  #FUN-A10138
END FUNCTION
 
#檢查作業編號(sfbiicd09)
FUNCTION p046_sfbiicd09()
  DEFINE l_ecdicd01      LIKE ecd_file.ecdicd01,
         l_ecd07         LIKE ecd_file.ecd07,
         l_ecdacti       LIKE ecd_file.ecdacti,
         l_ecdicd01_pre  LIKE ecd_file.ecdicd01
# DEFINE l_icb05         LIKE icb_file.icb05  #FUN-B30192
  DEFINE l_imaicd14      LIKE imaicd_file.imaicd14  #FUN-B30192
 
  LET g_errno = ' '
 
  SELECT ecd07,ecdicd01,ecdacti INTO l_ecd07,l_ecdicd01,l_ecdacti
    FROM ecd_file
   WHERE ecd01 = g_data[l_ac].sfbiicd09
 
  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aec-015'
       WHEN l_ecdacti <> 'Y'       LET g_errno = '9028'
       WHEN l_ecdicd01 = '1'       LET g_errno = 'aic-127'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF
  SELECT ecdicd01 INTO l_ecdicd01_pre FROM ecd_file
    WHERE ecd01 = (SELECT rvviicd01 FROM rvvi_file
                    WHERE rvvi01 = g_data[l_ac].rvv01
                      AND rvvi02 = g_data[l_ac].rvv02)
  IF NOT cl_null(l_ecdicd01_pre) AND l_ecdicd01 < l_ecdicd01_pre THEN
     LET g_errno = 'aic-128'
  END IF
  IF NOT cl_null(g_errno) THEN RETURN END IF
 
  #檢查若生產作業編號群組為2,則母體料號的gross die要 > 0
  IF l_ecdicd01 = '2' THEN
  #FUN-B30192--mark
  #  SELECT icb05 INTO l_icb05 FROM icb_file
  #   WHERE icb01 = g_data[l_ac].sfbiicd14
  #  IF cl_null(l_icb05) OR l_icb05 <= 0 THEN
  #FUN-B30192--mark
     CALL s_icdfun_imaicd14(g_data[l_ac].rvv31)   RETURNING l_imaicd14  #FUN-B30192
     IF cl_null(l_imaicd14) OR l_imaicd14<= 0 THEN                      #FUN-B30192
        LET g_errno = 'aic-024'
     END IF
  END IF
END FUNCTION
 
#完成料號
FUNCTION p046_sfb05()
  DEFINE l_icmacti    LIKE icm_file.icmacti,
         l_bmaacti    LIKE bma_file.bmaacti,
         l_bma05      LIKE bma_file.bma05
  DEFINE l_j          LIKE type_file.num5  #FUN-C30305
  DEFINE l_flag       LIKE type_file.chr1  #FUN-C30305
  
  LET g_errno = ' '
  #FUN-C30305---begin
  #SELECT icmacti INTO l_icmacti FROM icm_file
  # WHERE icm01 = g_data[l_ac].rvv31
  #   AND icm02 = g_data[l_ac].sfb05
 
  #CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = '100'
  #     WHEN l_icmacti <> 'Y'    LET g_errno = '9028'
  #     OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  #END CASE
  CALL g_icm.clear()
  LET l_i = 1
  CALL p046_get_icm02(g_data[l_ac].rvv31)
  LET l_j = 1
  WHILE (l_j < l_i)
     CALL p046_get_icm02(g_icm[l_j].icm02)
     LET l_j = l_j + 1
  END WHILE 
  LET l_j = 1
  LET l_flag = 'N'
  WHILE (l_j <= g_icm.getLength())
     IF g_data[l_ac].sfb05 = g_icm[l_j].icm02 THEN 
        LET l_flag = 'Y'
        EXIT WHILE 
     END IF 
     LET l_j = l_j + 1
  END WHILE 
  IF l_flag = 'N' THEN 
     LET g_errno = '100'
  END IF 
  #FUN-C30305---end
  
  IF NOT cl_null(g_errno) THEN RETURN END IF
 
  #要存在bom
  SELECT bma05,bmaacti INTO l_bma05,l_bmaacti FROM bma_file
   WHERE bma01 = g_data[l_ac].sfb05
  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'abm-742'
       WHEN l_bmaacti <> 'Y'       LET g_errno = '9028'
       WHEN l_bma05 IS NULL OR l_bma05 > g_pmm04
                                   LET g_errno = 'abm-005'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION

#FUN-C30305---begin
FUNCTION p046_get_icm02(p_icm01)
DEFINE p_icm01 LIKE icm_file.icm01
DEFINE l_icm02 LIKE icm_file.icm02
DEFINE  l_sql  STRING

   LET l_sql=" SELECT icm02 ",
             " FROM icm_file ",
             " WHERE icm01 = '",p_icm01,"'"
             
   DECLARE icm_cs CURSOR FROM l_sql 
   
   FOREACH icm_cs INTO l_icm02
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(l_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      LET g_icm[l_i].icm02 = l_icm02
      LET l_i = l_i + 1
   END FOREACH
   CLOSE icm_cs
END FUNCTION 
#FUN-C30305---end
#FUN-A10138--begin--mark--------
#產品型號
#FUNCTION p046_sfbiicd08()
# DEFINE l_ickacti    LIKE ick_file.ickacti
# DEFINE l_ecdicd01   LIKE ecd_file.ecdicd01        #No:MOD-980110 add

# LET g_errno = ' '
# LET l_ecdicd01= '1'          
# IF NOT cl_null(g_data[l_ac].sfbiicd09) THEN
#    SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file 
#              WHERE ecd01 = g_data[l_ac].sfbiicd09

#    IF cl_null(l_ecdicd01) THEN LET l_ecdicd01='1' END IF
# END IF 
# IF l_ecdicd01 = '4' THEN
#    SELECT icjacti INTO l_ickacti FROM icj_file
#      WHERE icj01 = g_data[l_ac].sfbiicd14
#        AND icj02 = g_data[l_ac].sfbiicd08

#    CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = '100'
#         WHEN l_ickacti <> 'Y'       LET g_errno = '9028'
#         OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
# ELSE
#    SELECT ickacti INTO l_ickacti FROM ick_file
#     WHERE ick01 = g_data[l_ac].sfbiicd14
#       AND ick02 = g_data[l_ac].sfbiicd08
#
#    IF l_ecdicd01 = '6' AND SQLCA.SQLCODE = 100 THEN
#       SELECT icjacti INTO l_ickacti FROM icj_file
#         WHERE icj01 = g_data[l_ac].sfbiicd14
#           AND icj02 = g_data[l_ac].sfbiicd08
#    END IF
#    CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = '100'
#         WHEN l_ickacti <> 'Y'       LET g_errno = '9028'
#         OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
# END IF              #No:MOD-980110 add
#
#END FUNCTION
 
#產品型號(單身二)
#FUNCTION p046_sfbiicd08_b(p_ac)
# DEFINE l_ickacti    LIKE ick_file.ickacti
# DEFINE p_ac            LIKE type_file.num5
# DEFINE i,l_n           LIKE type_file.num5

# LET g_errno = ' '

# SELECT ickacti INTO l_ickacti FROM ick_file
#  WHERE ick01 = g_data[p_ac].sfbiicd14   #母體料號
#    AND ick02 = g_idc[l_ac2].sfbiicd08_b

# CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = '100'
#      WHEN l_ickacti <> 'Y'    LET g_errno = '9028'
#      OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
# END CASE
# IF NOT cl_null(g_errno) THEN RETURN END IF

# #Down grade產品型號不可與主產品型號相同!
# IF g_data[p_ac].sfbiicd08 = g_idc[l_ac2].sfbiicd08_b THEN
#    LET g_errno = 'DSC0005'
# END IF
# IF NOT cl_null(g_errno) THEN RETURN END IF

# #因為後續會拿此欄位做group,所以不可存入NULL
# IF cl_null(g_idc[l_ac2].sfbiicd08_b) THEN
#    LET g_idc[l_ac2].sfbiicd08_b = ' '
# END IF
#END FUNCTION
#FUN-A10138--end--modify------
 
#廠商編號
FUNCTION p046_sfb82()
  DEFINE l_pmc03       LIKE pmc_file.pmc03,       #供應商簡稱
         l_pmcacti     LIKE pmc_file.pmcacti,     #有效否
         l_ecdicd01   LIKE ecd_file.ecdicd01,     #作業群組
         l_icg01   LIKE icg_file.icg01,           #料件編號
         l_icg02   LIKE icg_file.icg02,           #作業編號
         l_icg17   LIKE icg_file.icg17,           #失效日期
         l_icgacti  LIKE icg_file.icgacti         #有效否
 
  LET g_errno=' '
 
  #1.檢查存在供應商檔(pmc_file)否
  SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
   WHERE pmc01 = g_data[l_ac].sfb82
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
       WHEN l_pmcacti <> 'Y'     LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) OR cl_null(g_data[l_ac].sfbiicd09) THEN RETURN END IF
 
  #檢查存在icg_file否
  CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09)  #FUN-A30027
       RETURNING l_ecdicd01
  IF l_ecdicd01 MATCHES '[23456]' THEN
     IF l_ecdicd01 MATCHES '[23]' THEN
        SELECT rvviicd03 INTO l_icg01 FROM rvvi_file
         WHERE rvvi01 = g_data[l_ac].rvv01
           AND rvvi02 = g_data[l_ac].rvv02
     END IF
     IF l_ecdicd01 MATCHES '[456]' THEN
       LET l_icg01 = g_data[l_ac].sfb05
     END IF
     IF g_sma.sma841<>'8' THEN RETURN END IF        #NO.CHI-940039
     
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM icg_file
      WHERE icg01 = l_icg01
        AND icg02 = g_data[l_ac].sfbiicd09
        AND icg03 = g_data[l_ac].sfb82
     IF g_cnt = 0 THEN LET g_errno = 'aic-129' RETURN END IF
 
     #檢查資料有效否
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM icg_file
      WHERE icg01 = l_icg01
        AND icg02 = g_data[l_ac].sfbiicd09
        AND icg03 = g_data[l_ac].sfb82
        AND icgacti = 'Y'
     IF g_cnt = 0 THEN LET g_errno = '9028' RETURN END IF
 
     #檢查資料失效日期
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM icg_file
      WHERE icg01 = l_icg01
        AND icg02 = g_data[l_ac].sfbiicd09
        AND icg03 = g_data[l_ac].sfb82
        AND icgacti = 'Y'
        AND (icg17 IS NULL OR icg17 > g_today)
     IF g_cnt = 0 THEN LET g_errno = 'aic-130' RETURN END IF
  END IF
  LET g_data[l_ac].pmc03_1 = l_pmc03
  DISPLAY BY NAME g_data[l_ac].pmc03_1
END FUNCTION
 
#wafer廠商
FUNCTION p046_sfbiicd02()
  DEFINE l_pmc03       LIKE pmc_file.pmc03,         #供應商簡稱
         l_pmcacti     LIKE pmc_file.pmcacti,       #有效否
         l_icg01       LIKE icg_file.icg01,         #料件編號
         l_icg02       LIKE icg_file.icg02,         #作業編號
         l_icg17       LIKE icg_file.icg17,         #失效日期
         l_icgacti     LIKE icg_file.icgacti        #有效否
 
  LET g_errno=' '
 
  #1.檢查存在供應商檔(pmc_file)否
  SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
   WHERE pmc01 = g_data[l_ac].sfbiicd02
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
       WHEN l_pmcacti <> 'Y'     LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF
  
  IF g_sma.sma841<>'8' THEN RETURN END IF        #NO.CHI-940039
  
  #檢查存在icg_file否
  SELECT COUNT(*) INTO g_cnt FROM icg_file
   WHERE icg01 = g_data[l_ac].sfbiicd14
     AND icg02 IN (SELECT ecd01 FROM ecd_file WHERE ecdicd01 = '1')
     AND icg03 = g_data[l_ac].sfbiicd02
     IF g_cnt = 0 THEN LET g_errno = 'aic-129' RETURN END IF
 
  #檢查資料有效否
  LET g_cnt = 0
  SELECT COUNT(*) INTO g_cnt FROM icg_file
   WHERE icg01 = g_data[l_ac].sfbiicd14
     AND icg02 IN (SELECT ecd01 FROM ecd_file WHERE ecdicd01 = '1')
     AND icg03 = g_data[l_ac].sfbiicd02
     AND icgacti = 'Y'
  IF g_cnt = 0 THEN LET g_errno = '9028' RETURN END IF
 
  #檢查資料失效日期
  LET g_cnt = 0
  SELECT COUNT(*) INTO g_cnt FROM icg_file
   WHERE icg01 = g_data[l_ac].sfbiicd14
     AND icg02 IN (SELECT ecd01 FROM ecd_file WHERE ecdicd01 = '1')
     AND icg03 = g_data[l_ac].sfbiicd02
     AND icgacti = 'Y'
     AND (icg17 IS NULL OR icg17 > g_today)
  IF g_cnt = 0 THEN LET g_errno = 'aic-130' RETURN END IF
END FUNCTION
 
#檢查Wafer廠別(sfbiicd03)
FUNCTION p046_sfbiicd03()
  LET g_errno=' '
 
  #1.檢查存在icq_file否
  LET g_cnt = 0
  SELECT COUNT(*) INTO g_cnt FROM icq_file
   WHERE icq02 = g_data[l_ac].sfbiicd03
  IF g_cnt = 0 THEN LET g_errno = 100 RETURN END IF
 
  #2.檢查wafer廠商
  IF NOT cl_null(g_data[l_ac].sfbiicd02) THEN
     LET g_cnt = 0
     SELECT COUNT(*) INTO g_cnt FROM icq_file
      WHERE icq01 = g_data[l_ac].sfbiicd02
        AND icq02 = g_data[l_ac].sfbiicd03
     IF g_cnt = 0 THEN LET g_errno = 'aic-131' RETURN END IF
  END IF
END FUNCTION
 
#檢查multi die(sfbiicd10)
FUNCTION p046_sfbiicd10()
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01,
          l_oeb04     LIKE oeb_file.oeb04
   DEFINE l_pmn01     LIKE pmn_file.pmn01 
   DEFINE l_pmn02     LIKE pmn_file.pmn02
   DEFINE l_oeb01     LIKE oeb_file.oeb01
   DEFINE l_oeb03     LIKE oeb_file.oeb03
 
   LET g_errno = ' '
 
   SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file
    WHERE ecd01 = (SELECT rvviicd01 FROM rvvi_file
                    WHERE rvvi01 = g_data[l_ac].rvv01
                      AND rvvi02 = g_data[l_ac].rvv02)
 
   #若入庫料號所屬之作業群組(ecdicd01) = '2.CP',則回串採購單生產資訊ico_file
   IF l_ecdicd01 = '2' AND g_data[l_ac].sfbiicd10 = 'Y' THEN
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM ico_file
       WHERE ico02 = 0 AND ico01 IN
             (SELECT rvv36 FROM rvv_file
               WHERE rvv01 = g_data[l_ac].rvv01
                 AND rvv02 = g_data[l_ac].rvv02)
         AND ico03 = '8'
 
      IF g_cnt > 0 THEN
         #如果查到,檢查料號(ico07)及比率(ico04)是否有資料存在,如果不存在
         #出現錯誤訊息, 請user至採購單補比率(ico04)及料號(ico07)
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM ico_file
          WHERE ico02 = 0 AND ico01 IN
                (SELECT rvv36 FROM rvv_file
                  WHERE rvv01 = g_data[l_ac].rvv01
                    AND rvv02 = g_data[l_ac].rvv02)
            AND (ico07 IS NOT NULL AND
                 ico04 IS NOT NULL AND ico04 > 0)
            AND ico03 = '8'
         IF g_cnt = 0 THEN LET g_errno = 'aic-125' END IF
      ELSE
         #如果查不到資料,則回串採購單之訂單(pmniicd01)及項次(pmniicd02),
         #帶出訂單料號(oeb04);再由訂單料號(oeb04)串New Code檔(icw_file)
         #(icw05)之有效單號(icw10='Y'), 如果查詢不到,系統出現錯誤訊息
         CALL s_get_so(l_pmn01,l_pmn02) RETURNING l_oeb01,l_oeb03
         SELECT oeb04 INTO l_oeb04 FROM oeb_file
          WHERE oeb01=l_oeb01
            AND oeb03=l_oeb03
         IF cl_null(l_oeb04) THEN LET g_errno = 'aic-126' RETURN END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM icw_file
          WHERE icw05 = l_oeb04 AND icw10 = 'Y'
         IF g_cnt = 0 THEN LET g_errno = 'aic-126' RETURN END IF
      END IF
    END IF
END FUNCTION
 
#計算預定交貨日
FUNCTION p046_def_sfb15()
  DEFINE l_sfb15 LIKE sfb_file.sfb15,
         l_ima59 LIKE ima_file.ima59,
         l_ima60 LIKE ima_file.ima60,
         l_ima61 LIKE ima_file.ima61,
         l_ima601 LIKE ima_file.ima601,   #FUN-840194
         l_time  LIKE type_file.num5
 
  IF cl_null(g_data[l_ac].sfb05) OR cl_null(g_data[l_ac].sfb08) THEN
     RETURN
  END IF
 
  SELECT ima59,ima60,ima61,ima601 INTO l_ima59,l_ima60,l_ima61,l_ima601 FROM ima_file #FUN-840194
   WHERE ima01 = g_data[l_ac].sfb05
  IF l_ima59 IS NULL THEN LET l_ima59 = 0 END IF
  IF l_ima60 IS NULL THEN LET l_ima60 = 0 END IF
  IF l_ima61 IS NULL THEN LET l_ima61 = 0 END IF
 
  LET l_sfb15 = g_pmm04 + (l_ima59 + l_ima60/l_ima601 * g_data[l_ac].sfb08 + l_ima61)  #FUN-840194
  SELECT COUNT(*) INTO l_time FROM sme_file
   WHERE sme01 BETWEEN g_pmm04 AND l_sfb15 AND sme02 = 'N'
  IF cl_null(l_time) THEN LET l_time = 0 END IF
  LET l_sfb15 = l_sfb15 + l_time
 
  IF cl_null(l_sfb15) OR l_sfb15 = '99/12/13' THEN
     LET l_sfb15 = g_today
  END IF
  LET g_data[l_ac].sfb15 = l_sfb15
  DISPLAY BY NAME g_data[l_ac].sfb15
END FUNCTION
 
#生產製程(sfb06)
FUNCTION p046_sfb06()
  DEFINE l_ima571 LIKE ima_file.ima571
 
  LET g_errno = ' '
  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01 = g_data[l_ac].sfb05
  IF l_ima571 IS NULL THEN LET l_ima571 = ' ' END IF
 
  SELECT * FROM ecu_file
   WHERE ecu01 = l_ima571
     AND ecu02 = g_data[l_ac].sfb06
     AND ecuacti = 'Y'  #CHI-C90006
 
  IF SQLCA.sqlcode = 100 THEN
     SELECT * FROM ecu_file
      WHERE ecu01 = g_data[l_ac].sfb05
        AND ecu02 = g_data[l_ac].sfb06
        AND ecuacti = 'Y'  #CHI-C90006
     IF SQLCA.sqlcode = 100 THEN
        LET g_errno = 100
     END IF
  END IF
END FUNCTION
 
#下階廠商(sfbiicd01)
FUNCTION p046_sfbiicd01()
  DEFINE l_pmc03   LIKE pmc_file.pmc03,
         l_pmcacti LIKE pmc_file.pmcacti
  LET g_errno = ' '
 
  #1.檢查存在供應商檔(pmc_file)否
  SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
   WHERE pmc01 = g_data[l_ac].sfbiicd01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
       WHEN l_pmcacti <> 'Y'     LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF
 
  LET g_data[l_ac].pmc03_2 = l_pmc03
  DISPLAY BY NAME g_data[l_ac].pmc03_2
END FUNCTION
 
#預設生產數量sfb08
FUNCTION p046_def_sfb08()
   DEFINE l_ecdicd01     LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_pre LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_1   LIKE ecd_file.ecdicd01                        #FUN-C50107 add
   DEFINE l_qty1         LIKE rvv_file.rvv85        #入庫數量
   DEFINE l_sfb08        LIKE sfb_file.sfb08        #其它工單生產數量
   DEFINE l_sfb08_1      LIKE sfb_file.sfb08        #其它工單生產數量  #FUN-C50107 add
   DEFINE l_qty2         LIKE idc_file.idc08        #庫存數量
   DEFINE l_qty2_1       LIKE idc_file.idc08        #庫存數量   #TQC-C60188 add
   DEFINE l_die          LIKE rvv_file.rvv85        #TQC-940015
 
   CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01  #FUN-A30027
   SELECT ecdicd01 INTO l_ecdicd01_pre FROM ecd_file
     WHERE ecd01 = (SELECT rvviicd01 FROM rvvi_file
                     WHERE rvvi01 = g_data[l_ac].rvv01
                       AND rvvi02 = g_data[l_ac].rvv02)
 
   #生產CP       => 生產數量要以PCS數來計算比較
   #生產DS/AS/FT => 生產數量要以DIE數來計算比較

   #看之前有沒有生產過同一種作業編號的工單,加總其生產數量
   SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file,sfbi_file
    WHERE sfbiicd16 = g_data[l_ac].rvv01
      AND sfbiicd17 = g_data[l_ac].rvv02
      AND sfbiicd09 = g_data[l_ac].sfbiicd09   #FUN-C50107 add
      AND sfbi01=sfb01
      AND sfb87 <> 'X'
      AND sfb08 IS NOT NULL
  #str FUN-C50107 add
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   #看之前有沒有生產過不同作業編號的工單,需將生產數量換算成同一單位的數量,再加總起來比較
   DECLARE def_sfb08_cs CURSOR FOR
      SELECT ecdicd01,SUM(sfb08) FROM ecd_file,sfb_file,sfbi_file
       WHERE sfbiicd16 = g_data[l_ac].rvv01
         AND sfbiicd17 = g_data[l_ac].rvv02
         AND sfbiicd09!= g_data[l_ac].sfbiicd09
         AND sfbi01=sfb01
         AND sfbiicd09=ecd01
         AND sfb87 <> 'X'
         AND sfb08 IS NOT NULL
       GROUP BY ecdicd01
   FOREACH def_sfb08_cs INTO l_ecdicd01_1,l_sfb08_1
      CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die  #FUN-B30192
     #IF cl_null(l_die) THEN LET l_die=1 END IF   #FUN-C50107 mark
      IF l_die=0 THEN LET l_die=1 END IF          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
      IF l_ecdicd01 = '2' THEN   #這次要生產CP,生產數量要換算成PCS數
         LET l_sfb08_1 = l_sfb08_1 / l_die   
      END IF
      LET l_sfb08 = l_sfb08 +  l_sfb08_1
   END FOREACH
  #end FUN-C50107 add
 
   #要判斷入庫料件的料件狀態為何,才能決定生產數量需不需要先經過換算
   #入Wafer -> 生產CP        =>兩者基準都都是片數,不用換算
   #入Wafer -> 生產DS/AS/FT  =>要將Wafer片數換算成Die數(片數*GROSS DIE)
   #入CP    -> 生產DS/AS/FT  =>要預設Die數
   #入DS    -> 生產AS/FT     =>兩者基準都是Die數,不用換算
   #入AS    -> 生產FT        =>兩者基準都是Die數,不用換算

   CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die  #FUN-C50107 add
   IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 add 沒抓到值是應預設為1而不是0
   #取得入庫數量/庫存數量
   IF l_ecdicd01 MATCHES '[346]' THEN
      #入庫數量
      #IF g_sma.sma115='Y' THEN  #TQC-940015 若不使用多單位的處理方式  #
      IF g_sma.sma115='Y' AND g_data[l_ac].imaicd04 = '2' THEN   #FUN-C50107
         SELECT rvv85 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = g_data[l_ac].rvv01
            AND rvv02 = g_data[l_ac].rvv02
      ELSE
         SELECT rvv17 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = g_data[l_ac].rvv01 
            AND rvv02 = g_data[l_ac].rvv02
            
       #FUN-B30192--mark     
       # SELECT icb05 INTO l_die FROM icb_file,rvvi_file
       #                        WHERE rvvi01=g_data[l_ac].rvv01
       #                          AND rvvi02=g_data[l_ac].rvv02
       #                          AND icb01=rvviicd03
       #FUN-B30192--mark
        #CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die  #FUN-B30192  #FUN-C50107 mark
        #IF cl_null(l_die) THEN LET l_die=1 END IF                                #FUN-C50107 mark
         LET l_qty1=l_qty1*l_die      
      END IF
 
      #庫存數量
      IF l_ecdicd01 = '6' AND
         (cl_null(l_ecdicd01_pre) OR l_ecdicd01_pre <> '2') THEN
        #str TQC-C60188 mark
        #SELECT SUM(idc12 * ((idc08 - idc21)/idc08)) INTO l_qty2
        #  FROM idc_file
        # WHERE idc01 = g_data[l_ac].rvv31
        #   AND idc02 = g_data[l_ac].rvv32
        #   AND idc03 = g_data[l_ac].rvv33
        #   AND idc04 = g_data[l_ac].rvv34
        #   AND idc17 = 'N'
        #   AND idc08 > 0   #要加,不然會錯
        #end TQC-C60188 mark
        #str TQC-C60188 add
         SELECT SUM(idc12) INTO l_qty2
           FROM idc_file
          WHERE idc01 = g_data[l_ac].rvv31
            AND idc02 = g_data[l_ac].rvv32
            AND idc03 = g_data[l_ac].rvv33
            AND idc04 = g_data[l_ac].rvv34
            AND idc17 = 'N'
            AND idc08 > 0   #要加,不然會錯
            AND idc21 = 0   #沒有被Booking
         IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
         SELECT ROUND((idc08-idc21)*(idc12/idc08),0) INTO l_qty2_1
           FROM idc_file
          WHERE idc01 = g_data[l_ac].rvv31
            AND idc02 = g_data[l_ac].rvv32
            AND idc03 = g_data[l_ac].rvv33
            AND idc04 = g_data[l_ac].rvv34
            AND idc17 = 'N'
            AND idc08 > 0   #要加,不然會錯
            AND idc21 > 0   #有被Booking
         IF l_qty2_1 IS NULL THEN LET l_qty2_1=0 END IF
         LET l_qty2 = l_qty2 + l_qty2_1 
        #end TQC-C60188 add
      ELSE
        #FUN-C50107---begin
        #SELECT SUM(idc12 * ((idc08 - idc21)/idc08)) INTO l_qty2
        #  FROM idc_file
        # WHERE idc01 = g_data[l_ac].rvv31
        #   AND idc02 = g_data[l_ac].rvv32
        #   AND idc03 = g_data[l_ac].rvv33
        #   AND idc04 = g_data[l_ac].rvv34
        #   AND idc16 = 'Y'
        #   AND idc17 = 'N'
        #   AND idc08 > 0   #要加,不然會錯
         CASE
            WHEN g_data[l_ac].imaicd04 = '1'   #Wafer
               SELECT SUM(idc08-idc21)*l_die INTO l_qty2 
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
            WHEN g_data[l_ac].imaicd04 = '2'   #CP
              #str TQC-C60188 mark
              #SELECT SUM(idc12 * (idc08 - idc21)) INTO l_qty2
              #  FROM idc_file
              # WHERE idc01 = g_data[l_ac].rvv31
              #   AND idc02 = g_data[l_ac].rvv32
              #   AND idc03 = g_data[l_ac].rvv33
              #   AND idc04 = g_data[l_ac].rvv34
              #   AND idc16 = 'Y'
              #   AND idc17 = 'N'
              #   AND idc08 > 0   #要加,不然會錯
              #end TQC-C60188 mark
              #str TQC-C60188 add
               SELECT SUM(idc12) INTO l_qty2
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc16 = 'Y'
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
                  AND idc21 = 0   #沒有被Booking
               IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
               SELECT ROUND((idc08-idc21)*(idc12/idc08),0) INTO l_qty2_1
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc16 = 'Y'
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
                  AND idc21 > 0   #有被Booking
               IF l_qty2_1 IS NULL THEN LET l_qty2_1=0 END IF
               LET l_qty2 = l_qty2 + l_qty2_1 
              #end TQC-C60188 add
            OTHERWISE
               SELECT SUM(idc08 - idc21) INTO l_qty2
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc16 = 'Y'
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
         END CASE
        #FUN-C50107---end
      END IF 
   ELSE
      IF l_ecdicd01 = '2' THEN   #CP   #FUN-C50107 add
         #入庫數量
         SELECT rvv17 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = g_data[l_ac].rvv01
            AND rvv02 = g_data[l_ac].rvv02
 
         #庫存數量
         SELECT SUM(idc08 - idc21) INTO l_qty2 FROM idc_file
          WHERE idc01 = g_data[l_ac].rvv31
            AND idc02 = g_data[l_ac].rvv32
            AND idc03 = g_data[l_ac].rvv33
            AND idc04 = g_data[l_ac].rvv34
            AND idc17 = 'N'
     #str FUN-C50107 add
      END IF
      IF l_ecdicd01 = '5' THEN   #FT
         #入庫數量
         IF g_data[l_ac].imaicd04 = '1' THEN  #TQC-C60188
            SELECT rvv17*l_die INTO l_qty1 FROM rvv_file 
             WHERE rvv01 = g_data[l_ac].rvv01
               AND rvv02 = g_data[l_ac].rvv02
            #庫存數量   
            SELECT SUM(idc08 - idc21)*l_die INTO l_qty2 FROM idc_file
             WHERE idc01 = g_data[l_ac].rvv31
               AND idc02 = g_data[l_ac].rvv32
               AND idc03 = g_data[l_ac].rvv33
               AND idc04 = g_data[l_ac].rvv34
               AND idc17 = 'N'
         #TQC-C60188---begin
         ELSE
            SELECT rvv85 INTO l_qty1 FROM rvv_file 
             WHERE rvv01 = g_data[l_ac].rvv01
               AND rvv02 = g_data[l_ac].rvv02

           #str TQC-C60188 mark
           #SELECT SUM(idc12 * (idc08 - idc21)) INTO l_qty2 FROM idc_file  #TQC-C60188
           # WHERE idc01 = g_data[l_ac].rvv31
           #   AND idc02 = g_data[l_ac].rvv32
           #   AND idc03 = g_data[l_ac].rvv33
           #   AND idc04 = g_data[l_ac].rvv34
           #   AND idc17 = 'N'
           #end TQC-C60188 mark
           #str TQC-C60188 add
            SELECT SUM(idc12) INTO l_qty2
              FROM idc_file
             WHERE idc01 = g_data[l_ac].rvv31
               AND idc02 = g_data[l_ac].rvv32
               AND idc03 = g_data[l_ac].rvv33
               AND idc04 = g_data[l_ac].rvv34
               AND idc17 = 'N'
               AND idc21 = 0   #沒有被Booking
            IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
            SELECT ROUND((idc08-idc21)*(idc12/idc08),0) INTO l_qty2_1
              FROM idc_file
             WHERE idc01 = g_data[l_ac].rvv31
               AND idc02 = g_data[l_ac].rvv32
               AND idc03 = g_data[l_ac].rvv33
               AND idc04 = g_data[l_ac].rvv34
               AND idc17 = 'N'
               AND idc21 > 0   #有被Booking
            IF l_qty2_1 IS NULL THEN LET l_qty2_1=0 END IF
            LET l_qty2 = l_qty2 + l_qty2_1 
           #end TQC-C60188 add
         END IF  
         #TQC-C60188---end

      END IF
     #end FUN-C50107 add
   END IF
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   IF l_qty1 IS NULL THEN LET l_qty1 = 0 END IF
   IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
   LET l_qty1 = l_qty1 - l_sfb08
 
   IF l_qty1 <= l_qty2 THEN
      RETURN l_qty1
   ELSE
      RETURN l_qty2
   END IF
END FUNCTION
 
#預設生產參考數量sfbiicd06
FUNCTION p046_def_sfbiicd06()
   DEFINE l_ecdicd01     LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_pre LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_1   LIKE ecd_file.ecdicd01                        #FUN-C50107 add
#  DEFINE l_icb05        LIKE icb_file.icb05
   DEFINE l_imaicd14     LIKE imaicd_file.imaicd14  #FUN-B30192
   DEFINE l_qty1         LIKE rvv_file.rvv85        #入庫數量
   DEFINE l_sfbiicd06    LIKE sfbi_file.sfbiicd06   #其它工單生產數量
   DEFINE l_sfbiicd06_1  LIKE sfbi_file.sfbiicd06   #其它工單生產數量  #FUN-C50107 add
   DEFINE l_sfb08        LIKE sfb_file.sfb08        #其它工單生產數量
   DEFINE l_sfb08_1      LIKE sfb_file.sfb08        #其它工單生產數量  #FUN-C50107 add
   DEFINE l_qty2         LIKE idc_file.idc08        #庫存數量
   DEFINE l_die          LIKE rvv_file.rvv85        #FUN-C50107 add
 
   CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01 #FUN-A30027

   SELECT ecdicd01 INTO l_ecdicd01_pre FROM ecd_file
    WHERE ecd01 = (SELECT rvviicd01 FROM rvvi_file
                    WHERE rvvi01 = g_data[l_ac].rvv01
                      AND rvvi02 = g_data[l_ac].rvv02)
 
   SELECT SUM(sfbiicd06) INTO l_sfbiicd06 FROM sfbi_file,sfb_file
    WHERE sfbiicd16 = g_data[l_ac].rvv01
      AND sfbiicd17 = g_data[l_ac].rvv02
      AND sfbiicd09 = g_data[l_ac].sfbiicd09   #FUN-C50107 add
      AND sfbi01 = sfb01
      AND sfb87 <> 'X' AND sfbiicd06 IS NOT NULL
  #str FUN-C50107 add
   IF l_sfbiicd06 IS NULL THEN LET l_sfbiicd06 = 0 END IF
   DECLARE def_sfbiicd06_cs1 CURSOR FOR
      SELECT ecdicd01,SUM(sfbiicd06) FROM ecd_file,sfb_file,sfbi_file
       WHERE sfbiicd16 = g_data[l_ac].rvv01
         AND sfbiicd17 = g_data[l_ac].rvv02
         AND sfbiicd09!= g_data[l_ac].sfbiicd09
         AND sfbi01=sfb01
         AND sfbiicd09=ecd01
         AND sfb87 <> 'X'
         AND sfb08 IS NOT NULL
       GROUP BY ecdicd01
   FOREACH def_sfbiicd06_cs1 INTO l_ecdicd01_1,l_sfbiicd06_1
      CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die  #FUN-B30192
     #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
      IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
      IF l_ecdicd01 = '2' THEN   #這次要生產CP,生產參考數量要換算成DIE數
         LET l_sfbiicd06_1 = l_sfbiicd06_1 * l_die   
      END IF
      LET l_sfbiicd06 = l_sfbiicd06 +  l_sfbiicd06_1
   END FOREACH
  #end FUN-C50107 add

   SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file,sfbi_file
    WHERE sfbiicd16 = g_data[l_ac].rvv01
      AND sfbiicd17 = g_data[l_ac].rvv02
      AND sfbiicd09 = g_data[l_ac].sfbiicd09   #FUN-C50107 add
      AND sfbi01 = sfb01
      AND sfb87 <> 'X' AND sfb08 IS NOT NULL
  #str FUN-C50107 add
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   DECLARE def_sfbiicd06_cs2 CURSOR FOR
      SELECT ecdicd01,SUM(sfb08) FROM ecd_file,sfb_file,sfbi_file
       WHERE sfbiicd16 = g_data[l_ac].rvv01
         AND sfbiicd17 = g_data[l_ac].rvv02
         AND sfbiicd09!= g_data[l_ac].sfbiicd09
         AND sfbi01=sfb01
         AND sfbiicd09=ecd01
         AND sfb87 <> 'X'
         AND sfb08 IS NOT NULL
       GROUP BY ecdicd01
   FOREACH def_sfbiicd06_cs2 INTO l_ecdicd01_1,l_sfb08_1
      CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die  #FUN-B30192
     #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
      IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
      IF l_ecdicd01 = '2' THEN   #這次要生產CP,生產數量要換算成PCS數
         LET l_sfb08_1 = l_sfb08_1 / l_die   
      END IF
      LET l_sfb08 = l_sfb08 +  l_sfb08_1
   END FOREACH
  #end FUN-C50107 add

#FUN-B30192--mark 
#  SELECT icb05 INTO l_icb05 FROM icb_file,ima_file,imaicd_file
#   WHERE icb01 = imaicd01
#     AND ima01 = imaicd00
#     AND ima01 = g_data[l_ac].rvv31
#  IF l_icb05 IS NULL THEN LET l_icb05 = 0 END IF
#FUN-B30192--mark
   CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_imaicd14 #FUN-B30192
  #IF l_imaicd14 IS NULL THEN LET l_imaicd14= 1 END IF             #FUN-B30192  #FUN-C50107 mark
   IF l_imaicd14=0 THEN LET l_imaicd14=1 END IF                                 #FUN-C50107 mod 沒抓到值是應預設為1而不是0

   #取得入庫數量/庫存數量
   CASE
      WHEN l_ecdicd01 = '2'
           #入庫數量
          #SELECT rvv85 INTO l_qty1 FROM rvv_file                #FUN-C50107 mark
           SELECT rvv17 * l_imaicd14 INTO l_qty1 FROM rvv_file   #FUN-C50107
            WHERE rvv01 = g_data[l_ac].rvv01 
              AND rvv02 = g_data[l_ac].rvv02
 
           #庫存數量
       #   SELECT SUM(idc08 - idc21) * l_icb05 INTO l_qty2       #FUN-B30192
           SELECT SUM(idc08 - idc21) * l_imaicd14 INTO l_qty2    #FUN-B30192
             FROM idc_file
            WHERE idc01 = g_data[l_ac].rvv31
              AND idc02 = g_data[l_ac].rvv32
              AND idc03 = g_data[l_ac].rvv33
              AND idc04 = g_data[l_ac].rvv34
              AND idc17 = 'N'
 
      WHEN l_ecdicd01 MATCHES '[346]'
           #入庫數量
           SELECT rvv17 INTO l_qty1 FROM rvv_file
            WHERE rvv01 = g_data[l_ac].rvv01 
              AND rvv02 = g_data[l_ac].rvv02
 
           #庫存數量
           IF l_ecdicd01 = '6' AND
              (cl_null(l_ecdicd01_pre) OR l_ecdicd01_pre <> '2') THEN
              SELECT SUM(idc08 - idc21) INTO l_qty2 FROM idc_file
               WHERE idc01 = g_data[l_ac].rvv31
                 AND idc02 = g_data[l_ac].rvv32
                 AND idc03 = g_data[l_ac].rvv33
                 AND idc04 = g_data[l_ac].rvv34
                 AND idc17 = 'N'
           ELSE
              SELECT SUM(idc08 - idc21) INTO l_qty2 FROM idc_file
               WHERE idc01 = g_data[l_ac].rvv31
                 AND idc02 = g_data[l_ac].rvv32
                 AND idc03 = g_data[l_ac].rvv33
                 AND idc04 = g_data[l_ac].rvv34
                #AND idc16 = 'Y'   #FUN-C50107 mark
                 AND idc16!= 'N'   #FUN-C50107
                 AND idc17 = 'N'
           END IF
 
      OTHERWISE
           #入庫數量
           SELECT rvv17 INTO l_qty1 FROM rvv_file
            WHERE rvv01 = g_data[l_ac].rvv01 
              AND rvv02 = g_data[l_ac].rvv02
 
           #庫存數量
           SELECT SUM(idc08 - idc21) INTO l_qty2 FROM idc_file
            WHERE idc01 = g_data[l_ac].rvv31
              AND idc02 = g_data[l_ac].rvv32
              AND idc03 = g_data[l_ac].rvv33
              AND idc04 = g_data[l_ac].rvv34
             #AND idc16 = 'Y'   #FUN-C50107 mark
              AND idc16!= 'N'   #FUN-C50107
   END CASE
 
   IF l_qty1 IS NULL THEN LET l_qty1 = 0 END IF
   IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   IF l_sfbiicd06 IS NULL THEN LET l_sfbiicd06 = 0 END IF
 
  #IF l_ecdicd01 MATCHES '[234]' THEN   #FUN-C50107 mark
   IF l_ecdicd01 MATCHES '[345]' THEN   #FUN-C50107
      LET l_qty1 = l_qty1 - l_sfbiicd06
   ELSE
      LET l_qty1 = l_qty1 - l_sfb08
   END IF
 
   IF l_qty1 <= l_qty2 THEN
      LET g_data[l_ac].sfbiicd06 = l_qty1
   ELSE
      LET g_data[l_ac].sfbiicd06 = l_qty2
   END IF
END FUNCTION
 
#生產數量(sfb08)
FUNCTION p046_sfb08()
   DEFINE l_ecdicd01     LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_pre LIKE ecd_file.ecdicd01
   DEFINE l_ecdicd01_1   LIKE ecd_file.ecdicd01                        #FUN-C50107 add
   DEFINE l_qty          LIKE rvv_file.rvv85         #最大可輸入數量
   DEFINE l_qty1         LIKE rvv_file.rvv85         #入庫數量
   DEFINE l_sfb08        LIKE sfb_file.sfb08         #其它工單生產數量
   DEFINE l_sfb08_1      LIKE sfb_file.sfb08         #其它工單生產數量 #UN-C50107 add
   DEFINE l_qty2         LIKE idc_file.idc08         #庫存數量
   DEFINE l_qty2_1       LIKE idc_file.idc08         #庫存數量   #TQC-C60188 add
   DEFINE l_die          LIKE rvv_file.rvv85         #FUN-910077
 
   LET g_errno = ' '
   IF g_data[l_ac].sfb08 <= 0 THEN
      LET g_errno = 'mfg9243' RETURN
   END IF
 
   CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09)  #FUN-A30027
        RETURNING l_ecdicd01

   SELECT ecdicd01 INTO l_ecdicd01_pre FROM ecd_file
    WHERE ecd01 = (SELECT rvviicd01 FROM rvvi_file
                    WHERE rvvi01 = g_data[l_ac].rvv01
                      AND rvvi02 = g_data[l_ac].rvv02)
 
   #生產CP       => 生產數量要以PCS數來計算比較
   #生產DS/AS/FT => 生產數量要以DIE數來計算比較

   #看之前有沒有生產過同一種作業編號的工單,加總其生產數量
   SELECT SUM(sfb08) INTO l_sfb08 FROM sfb_file,sfbi_file
    WHERE sfbiicd16 = g_data[l_ac].rvv01
      AND sfbiicd17 = g_data[l_ac].rvv02
      AND sfbiicd09 = g_data[l_ac].sfbiicd09   #FUN-C50107 add
      AND sfbi01=sfb01
      AND sfb87 <> 'X' AND sfb08 IS NOT NULL
  #str FUN-C50107 add
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   #看之前有沒有生產過不同作業編號的工單,需將生產數量換算成同一單位的數量,再加總起來比較
   DECLARE sfb08_cs CURSOR FOR
      SELECT ecdicd01,SUM(sfb08) FROM ecd_file,sfb_file,sfbi_file
       WHERE sfbiicd16 = g_data[l_ac].rvv01
         AND sfbiicd17 = g_data[l_ac].rvv02
         AND sfbiicd09!= g_data[l_ac].sfbiicd09
         AND sfbi01=sfb01
         AND sfbiicd09=ecd01
         AND sfb87 <> 'X' AND sfb08 IS NOT NULL
       GROUP BY ecdicd01
   FOREACH sfb08_cs INTO l_ecdicd01_1,l_sfb08_1
      CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die  #FUN-B30192
     #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
      IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
      IF l_ecdicd01 = '2' THEN   #這次要生產CP,生產數量要換算成PCS數
         LET l_sfb08_1 = l_sfb08_1 / l_die   
      END IF
      LET l_sfb08 = l_sfb08 +  l_sfb08_1
   END FOREACH
  #end FUN-C50107 add
 
   #要判斷入庫料件的料件狀態為何,才能決定生產數量需不需要先經過換算才能比較
   #入Wafer -> 生產CP        =>兩者基準都都是片數,不用換算
   #入Wafer -> 生產DS/AS/FT  =>要將Wafer片數換算成Die數(片數*GROSS DIE)
   #入CP    -> 生產DS/AS/FT  =>要用Die數來比較
   #入DS    -> 生產AS/FT     =>兩者基準都是Die數,不用換算
   #入AS    -> 生產FT        =>兩者基準都是Die數,不用換算

   #取得入庫數量/庫存數量
  #IF l_ecdicd01 MATCHES '[346]' THEN    #FUN-C50107 mark
   IF l_ecdicd01 MATCHES '[3456]' THEN   #FUN-C50107
      
      #入庫數量      
      #IF g_sma.sma115='Y' THEN  #FUN-910077 若不使用多單位的處理方式  #FUN-C50107
      IF g_sma.sma115='Y' AND g_data[l_ac].imaicd04 = '2' THEN  #FUN-C50107
         SELECT rvv85 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = g_data[l_ac].rvv01 
            AND rvv02 = g_data[l_ac].rvv02
      ELSE
         SELECT rvv17 INTO l_qty1 FROM rvv_file
          WHERE rvv01 = g_data[l_ac].rvv01 
            AND rvv02 = g_data[l_ac].rvv02
      #FUN-B20192--mark      
      #  SELECT icb05 INTO l_die FROM icb_file,rvvi_file
      #                         WHERE rvvi01=g_data[l_ac].rvv01
      #                           AND rvvi02=g_data[l_ac].rvv02
      #                           AND icb01=rvviicd03
      #FUN-B20192--mark
         CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die      #FUN-B30192
        #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
         IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
         LET l_qty1=l_qty1*l_die      
      END IF
      #庫存數量
      IF l_ecdicd01 = '6' AND
         (cl_null(l_ecdicd01_pre) OR l_ecdicd01_pre <> '2') THEN
        #str TQC-C60188 mark
        #SELECT SUM(idc12 * ((idc08 - idc21)/idc08)) INTO l_qty2
        #  FROM idc_file
        # WHERE idc01 = g_data[l_ac].rvv31
        #   AND idc02 = g_data[l_ac].rvv32
        #   AND idc03 = g_data[l_ac].rvv33
        #   AND idc04 = g_data[l_ac].rvv34
        #   AND idc17 = 'N'
        #   AND idc08 > 0   #要加,不然會錯
        #end TQC-C60188 mark
        #str TQC-C60188 add
         SELECT SUM(idc12) INTO l_qty2
           FROM idc_file
          WHERE idc01 = g_data[l_ac].rvv31
            AND idc02 = g_data[l_ac].rvv32
            AND idc03 = g_data[l_ac].rvv33
            AND idc04 = g_data[l_ac].rvv34
            AND idc17 = 'N'
            AND idc08 > 0   #要加,不然會錯
            AND idc21 = 0   #沒有被Booking
         IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
         SELECT ROUND((idc08-idc21)*(idc12/idc08),0) INTO l_qty2_1
           FROM idc_file
          WHERE idc01 = g_data[l_ac].rvv31
            AND idc02 = g_data[l_ac].rvv32
            AND idc03 = g_data[l_ac].rvv33
            AND idc04 = g_data[l_ac].rvv34
            AND idc17 = 'N'
            AND idc08 > 0   #要加,不然會錯
            AND idc21 > 0   #有被Booking
         IF l_qty2_1 IS NULL THEN LET l_qty2_1=0 END IF
         LET l_qty2 = l_qty2 + l_qty2_1 
        #end TQC-C60188 add
      ELSE
        #FUN-C50107---begin
        #SELECT SUM(idc12 * ((idc08 - idc21)/idc08)) INTO l_qty2
        #  FROM idc_file
        # WHERE idc01 = g_data[l_ac].rvv31
        #   AND idc02 = g_data[l_ac].rvv32
        #   AND idc03 = g_data[l_ac].rvv33
        #   AND idc04 = g_data[l_ac].rvv34
        #   AND idc16 = 'Y'
        #   AND idc17 = 'N'
        #   AND idc08 > 0   #要加,不然會錯
         CASE 
            WHEN g_data[l_ac].imaicd04 = '1'   #Wafer
               CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die
              #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
               IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
               SELECT SUM(idc08-idc21)*l_die INTO l_qty2
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
            WHEN g_data[l_ac].imaicd04 = '2'   #CP
              #str TQC-C60188 mark
              #SELECT SUM(idc12 * (idc08 - idc21)) INTO l_qty2
              #  FROM idc_file
              # WHERE idc01 = g_data[l_ac].rvv31
              #   AND idc02 = g_data[l_ac].rvv32
              #   AND idc03 = g_data[l_ac].rvv33
              #   AND idc04 = g_data[l_ac].rvv34
              #   AND idc16 = 'Y'
              #   AND idc17 = 'N'
              #   AND idc08 > 0   #要加,不然會錯
              #end TQC-C60188 mark
              #str TQC-C60188 add
               SELECT SUM(idc12) INTO l_qty2
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc16 = 'Y'
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
                  AND idc21 = 0   #沒有被Booking
               IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
               SELECT ROUND((idc08-idc21)*(idc12/idc08),0) INTO l_qty2_1
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc16 = 'Y'
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
                  AND idc21 > 0   #有被Booking
               IF l_qty2_1 IS NULL THEN LET l_qty2_1=0 END IF
               LET l_qty2 = l_qty2 + l_qty2_1 
              #end TQC-C60188 add
            OTHERWISE
               SELECT SUM(idc08 - idc21) INTO l_qty2
                 FROM idc_file
                WHERE idc01 = g_data[l_ac].rvv31
                  AND idc02 = g_data[l_ac].rvv32
                  AND idc03 = g_data[l_ac].rvv33
                  AND idc04 = g_data[l_ac].rvv34
                  AND idc16 = 'Y'
                  AND idc17 = 'N'
                  AND idc08 > 0   #要加,不然會錯
         END CASE
        #FUN-C50107---end
      END IF
   ELSE
      #入庫數量
      SELECT rvv17 INTO l_qty1 FROM rvv_file
       WHERE rvv01 = g_data[l_ac].rvv01 
         AND rvv02 = g_data[l_ac].rvv02
 
      #庫存數量
      SELECT SUM(idc08 - idc21) INTO l_qty2 FROM idc_file
       WHERE idc01 = g_data[l_ac].rvv31
         AND idc02 = g_data[l_ac].rvv32
         AND idc03 = g_data[l_ac].rvv33
         AND idc04 = g_data[l_ac].rvv34
         AND idc17 = 'N'
   END IF
   IF l_sfb08 IS NULL THEN LET l_sfb08 = 0 END IF
   IF l_qty1 IS NULL THEN LET l_qty1 = 0 END IF
   IF l_qty2 IS NULL THEN LET l_qty2 = 0 END IF
   LET l_qty1 = l_qty1 - l_sfb08
 
   IF l_qty1 <= l_qty2 THEN
      LET l_qty = l_qty1
   ELSE
      LET l_qty = l_qty2
   END IF
 
   IF g_data[l_ac].sfb08 > l_qty THEN
      #LET g_errno = 'mfg9243' RETURN   #FUN-C50107
      LET g_errno = 'aic-329' RETURN    #FUN-C50107
   END IF
END FUNCTION
 
#str FUN-C50107 add
FUNCTION p046_sfbiicd06()
  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
  DEFINE l_die       LIKE sfbi_file.sfbiicd06
  DEFINE l_ima907    LIKE ima_file.ima907
         
  CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) 
       RETURNING l_ecdicd01
   
  CASE
      WHEN l_ecdicd01 = '2'
           CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die
          #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
           IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
           #須再乘生產數量(sfb08)
           IF NOT cl_null(g_data[l_ac].sfb08) THEN
              LET g_data[l_ac].sfbiicd06 = l_die * g_data[l_ac].sfb08
           END IF
      WHEN l_ecdicd01 = '3' OR l_ecdicd01 = '4' OR l_ecdicd01 = '5'
           IF g_data[l_ac].imaicd04 = '1' OR g_data[l_ac].imaicd04 = '2' THEN
              CALL s_icdfun_imaicd14(g_data[l_ac].rvv31) RETURNING l_die
             #IF cl_null(l_die) THEN LET l_die=1 END IF                   #FUN-C50107 mark
              IF l_die=0 THEN LET l_die=1 END IF                          #FUN-C50107 mod 沒抓到值是應預設為1而不是0
              IF NOT cl_null(g_data[l_ac].sfb08) THEN
                 LET g_data[l_ac].sfbiicd06 = g_data[l_ac].sfb08 / l_die
                 SELECT ima907 INTO l_ima907 FROM ima_file WHERE ima01=g_data[l_ac].rvv31
                 LET g_data[l_ac].sfbiicd06 = s_digqty(g_data[l_ac].sfbiicd06,l_ima907)
              END IF
           ELSE   
              IF NOT cl_null(g_data[l_ac].sfb08) THEN
                 LET g_data[l_ac].sfbiicd06 = g_data[l_ac].sfb08
              END IF
           END IF
      OTHERWISE
           LET g_data[l_ac].sfbiicd06 = g_data[l_ac].sfb08
  END CASE
  DISPLAY BY NAME g_data[l_ac].sfbiicd06

END FUNCTION
#end FUN-C50107 add

FUNCTION p046_ins_bin_temp(p_ac)
  DEFINE p_ac        LIKE type_file.num5
  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
  DEFINE l_qty       LIKE idc_file.idc08
  DEFINE l_icf01     LIKE icf_file.icf01 #bin item
  DEFINE l_sql       STRING
  DEFINE l_cnt       LIKE type_file.num10
  #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
 
  #FUN-BA0051 --START mark--
  #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
  # WHERE imaicd00 = g_data[p_ac].rvv31
  ##入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
  #IF cl_null(g_data[p_ac].imaicd04) OR
  #   g_data[p_ac].imaicd04 NOT MATCHES '[012]' OR    #入庫料號狀態為[0-2]
  #   cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN  #須做刻號管理
  #FUN-BA0051 --END mark--
  IF NOT s_icdbin(g_data[p_ac].rvv31) THEN   #FUN-BA0051  
    #FUN-A30027--begin--modify------------
    #DELETE FROM bin_temp WHERE item1 = p_ac
     CALL p046sub_del_data(l_table,p_ac)
    #FUN-A30027--end--modify--------------
     RETURN
  END IF
 
  IF g_data[p_ac].sel = 'N' THEN
     #若g_data[p_ac].sel = 'N' =>刪除bin維護記錄
    #FUN-A30027--begin--modify------------
    #DELETE FROM bin_temp WHERE item1 = p_ac
     CALL p046sub_del_data(l_table,p_ac)
    #FUN-A30027--end--modify--------------
     RETURN
  END IF
 
  #若生產料號(sfb05),作業編號(sfbiicd09),數量(sfb08)有變,先刪除維護記錄
  IF (cl_null(g_data_t.sfb05) OR (g_data_t.sfb05 <> g_data[p_ac].sfb05)) OR
     (cl_null(g_data_t.sfb08) OR (g_data_t.sfb08 <> g_data[p_ac].sfb08)) OR
     (cl_null(g_data_t.sfbiicd09) OR
      (g_data_t.sfbiicd09 <> g_data[p_ac].sfbiicd09)) THEN
    #FUN-A30027--begin--modify-------------
    #DELETE FROM bin_temp WHERE item1 = p_ac
     CALL p046sub_del_data(l_table,p_ac)
    #FUN-A30027--end--modify--------------
  END IF
 
  #取得庫存數量
 #FUN-A30027--begin--modify-------
 #CALL p046_qty(p_ac) RETURNING l_qty
  CALL p046sub_qty(g_data[p_ac].sfbiicd09,g_data[p_ac].imaicd04,g_data[p_ac].rvv31,
       g_data[p_ac].rvv32,g_data[p_ac].rvv33,g_data[p_ac].rvv34,g_data[p_ac].sfbiicd10,
       g_data[p_ac].sfbiicd14)
  RETURNING l_qty
 #FUN-A30027--end--modify---------
 
  #若g_data[p_ac].sel = 'Y'且無bin維護記錄 =>新增bin維護記錄
  LET g_cnt = 0
 #FUN-A30027--begin---modify------------
 #SELECT COUNT(*) INTO g_cnt FROM bin_temp WHERE item1 = p_ac
  LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac
   PREPARE r406_bin_temp02 FROM l_sql
   DECLARE bin_count_cs1 CURSOR FOR r406_bin_temp02
   OPEN bin_count_cs1
   FETCH bin_count_cs1 INTO g_cnt
  #FUN-A30027--end--modify---------------
  #bin_temp沒資料就自動新增
  IF g_cnt = 0 THEN
     IF g_data[p_ac].imaicd04 = '2' THEN
       #FUN-A30027--begin--modify----- 
       #CALL p046_icf01(p_ac) RETURNING l_icf01 #--決定串icf_file的料號
        CALL p046sub_icf01(g_data[p_ac].rvv31,g_data[p_ac].rvv32,g_data[p_ac].rvv33,
                           g_data[p_ac].rvv34,g_data[p_ac].sfbiicd14)
        RETURNING l_icf01
       #FUN-A30027--end--modify-------
        IF cl_null(l_icf01) THEN CALL cl_err('','aic-132',0) RETURN END IF
        LET l_sql =
            "SELECT 'N',0,idc05,idc06,icf03,icf05,",
            "       (idc08-idc21), ",
            "       idc12 *((idc08-idc21)/idc08),",
            "       '',''",
            "  FROM idc_file,icf_file ",
            " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
            "   AND idc02 = '",g_data[p_ac].rvv32,"'",
            "   AND idc03 = '",g_data[p_ac].rvv33,"'",
            "   AND idc04 = '",g_data[p_ac].rvv34,"'",
            "   AND (idc08 - idc21) > 0 ",
            "   AND idc16 = 'Y'",
            "   AND idc17 = 'N'",
            "   AND icf01 = '",l_icf01,"'",
            "   AND icf02 = idc06 ",
            "  ORDER BY idc05,idc06 "
 
        CALL p046sub_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01  #FUN-A30027
        IF l_ecdicd01 MATCHES '[34]' AND g_data[p_ac].sfbiicd10 = 'Y' THEN
           LET l_sql = l_sql CLIPPED, " AND icf05 <> '1' "
        END IF
     ELSE
        LET l_sql =
            "SELECT 'N',0,idc05,idc06,'','',",
            "       (idc08-idc21), ",
            "       idc12 *((idc08-idc21)/idc08), ",
            "       '',''",
            "  FROM idc_file ",
            " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
            "   AND idc02 = '",g_data[p_ac].rvv32,"'",
            "   AND idc03 = '",g_data[p_ac].rvv33,"'",
            "   AND idc04 = '",g_data[p_ac].rvv34,"'",
            "   AND idc17 = 'N'",
            "   AND (idc08 - idc21) > 0 ",
            " ORDER BY idc05,idc06 "
     END IF
 
     DECLARE bin_gen_cs CURSOR FROM l_sql
     CALL g_idc.clear()
     LET l_cnt = 1
     LET g_rec_b2 = 0
 
     FOREACH bin_gen_cs INTO g_idc[l_cnt].*
        LET g_idc[l_cnt].item = l_cnt
        IF l_qty = g_data[p_ac].sfb08 THEN #數量若相等就全勾選
           LET g_idc[l_cnt].sel2 = 'Y'
        END IF
 
        #在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
        #抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
        #當生產料號與產品型號的預設值
        #(生產料號/產品型號為空白時,才需做此預設動作)
       #FUN-A30027--begin--modify------
       #CALL p046_def_idc(p_ac,l_cnt)
        CALL p046sub_def_idc(g_idc[l_cnt].sel2,g_data[p_ac].imaicd04,g_idc[l_cnt].icf05,
                          g_idc[l_cnt].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
                          g_idc[l_cnt].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
       #FUN-A30027--end--modify-------
             RETURNING g_idc[l_cnt].ima01,
                       g_idc[l_cnt].sfbiicd08_b
 
        #因為後續要用該欄位做group,所以不可存null
        IF cl_null(g_idc[l_cnt].sfbiicd08_b) THEN
           LET g_idc[l_cnt].sfbiicd08_b = ' '
        END IF
 
        #FUN-A30027--begin--add----------
         LET g_sql = "INSERT INTO ",g_cr_db_str,l_table CLIPPED,"(item1,sel2,item2, ",
                     " idc05,idc06,icf03,icf05,qty1,qty2,ima01,ima02,sfbiicd08_b) ", 
                     " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?)"
         PREPARE insert_prep FROM g_sql
         IF STATUS THEN
           CALL cl_err('insert_prep:',status,1) 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
           EXIT PROGRAM
         END IF   
       #FUN-A30027--end--add------------
       #INSERT INTO bin_temp VALUES(p_ac,g_idc[l_cnt].*)  #FUN-A30027
        EXECUTE insert_prep USING p_ac,g_idc[l_cnt].*     #FUN-A30027
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err('gen data error:',SQLCA.sqlcode,1)
           RETURN
        END IF
        LET l_cnt = l_cnt + 1
        IF l_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
      END FOREACH
      CALL g_idc.deleteElement(l_cnt)
      LET g_rec_b2 = l_cnt - 1
      LET l_cnt = 0
  END IF
END FUNCTION
 
#決定串icf_file的料號
#FUN-A30027--begin--mark--
#FUNCTION p046_icf01(p_ac)
# DEFINE p_ac        LIKE type_file.num5
# DEFINE l_imaicd06  LIKE imaicd_file.imaicd06
#
# #1. 用入庫料號+idc06串bin檔
# LET g_cnt = 0
# SELECT COUNT(*) INTO g_cnt FROM idc_file,icf_file
#  WHERE idc01 = g_data[p_ac].rvv31
#    AND idc02 = g_data[p_ac].rvv32
#    AND idc03 = g_data[p_ac].rvv33
#    AND idc04 = g_data[p_ac].rvv34
#    AND (idc08 - idc21) > 0
#    AND idc16 = 'Y'
#    AND icf01 = g_data[p_ac].rvv31
#    AND icf02 = idc06
# IF g_cnt > 0 THEN       #串的到回傳
#    RETURN g_data[p_ac].rvv31
# END IF                  #串不到
#
# #2. 串不到改用wafer料號+idc06串bin檔
# #取得wafer料號(imaicd06)
# SELECT imaicd06 INTO l_imaicd06 FROM imaicd_file
#  WHERE imaicd01 = g_data[p_ac].rvv31
# IF NOT cl_null(l_imaicd06) THEN
#    #用wafer料號串
#    LET g_cnt = 0
#    SELECT COUNT(*) INTO g_cnt FROM idc_file,icf_file
#     WHERE idc01 = g_data[p_ac].rvv31
#       AND idc02 = g_data[p_ac].rvv32
#       AND idc03 = g_data[p_ac].rvv33
#       AND idc04 = g_data[p_ac].rvv34
#       AND (idc08 - idc21) > 0
#       AND idc16 = 'Y'
#       AND icf01 = l_imaicd06
#       AND icf02 = idc06
#    IF g_cnt > 0 THEN       #串的到回傳
#       RETURN l_imaicd06
#    END IF                  #串不到
# END IF
#
# #3. 再串不到改用母體料號+idc06串bin檔
# LET g_cnt = 0
# SELECT COUNT(*) INTO g_cnt FROM idc_file,icf_file
#  WHERE idc01 = g_data[p_ac].rvv31
#    AND idc02 = g_data[p_ac].rvv32
#    AND idc03 = g_data[p_ac].rvv33
#    AND idc04 = g_data[p_ac].rvv34
#    AND (idc08 - idc21) > 0
#    AND idc16 = 'Y'
#    AND icf01 = g_data[p_ac].sfbiicd14
#    AND icf02 = idc06
# IF g_cnt > 0 THEN
#    RETURN g_data[p_ac].sfbiicd14
# ELSE
#    RETURN NULL
# END IF
#END FUNCTION

##庫存數量
#FUNCTION p046_qty(p_ac)
#  DEFINE p_ac        LIKE type_file.num5
#  DEFINE l_sql       STRING
#  DEFINE l_pcs       LIKE idc_file.idc08 #庫存數量(pcs)
#  DEFINE l_dies      LIKE idc_file.idc08 #庫存數量(dies)
#  DEFINE l_icf01     LIKE icf_file.icf01 #bin item
#  DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01    #作業群組
#
#  CALL p046_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01
#
#  #取得庫存數量
#  IF g_data[p_ac].imaicd04 = '2' THEN
#     CALL p046_icf01(p_ac) RETURNING l_icf01 #--決定串icf_file的料號
#     IF cl_null(l_icf01) THEN
#       CALL cl_err('','aic-132',1)
#       RETURN 0
#     END IF
#     LET l_sql =
#         "SELECT SUM(idc08-idc21), ",
#         "       SUM(idc12 *((idc08-idc21)/idc08)) ",
#         "  FROM idc_file,icf_file ",
#         " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
#         "   AND idc02 = '",g_data[p_ac].rvv32,"'",
#         "   AND idc03 = '",g_data[p_ac].rvv33,"'",
#         "   AND idc04 = '",g_data[p_ac].rvv34,"'",
#         "   AND (idc08 - idc21) > 0 ",
#         "   AND idc16 = 'Y'",
#         "   AND idc17 = 'N'",
#         "   AND icf01 = '",l_icf01,"'",
#         "   AND icf02 = idc06 "
#
#     IF l_ecdicd01 MATCHES '[34]' AND g_data[p_ac].sfbiicd10 = 'Y' THEN
#        LET l_sql = l_sql CLIPPED, " AND icf05 <> '1' "
#     END IF
#  ELSE
#     LET l_sql =
#      "SELECT SUM(idc08-idc21), ",
#         "    SUM(idc12 *((idc08-idc21)/idc08)) ",
#         "  FROM idc_file ",
#         " WHERE idc01 = '",g_data[p_ac].rvv31,"'",
#         "   AND idc02 = '",g_data[p_ac].rvv32,"'",
#         "   AND idc03 = '",g_data[p_ac].rvv33,"'",
#         "   AND idc04 = '",g_data[p_ac].rvv34,"'",
#         "   AND idc17 = 'N'",
#         "   AND (idc08 - idc21) > 0 "
#  END IF
#  DECLARE qty_cs CURSOR FROM l_sql
#  OPEN qty_cs
#  FETCH qty_cs INTO l_pcs,l_dies
#
#  IF l_ecdicd01 = '2' THEN
#     RETURN l_pcs         #--回傳片數
#  ELSE
#     RETURN l_dies        #--回die數
#  END IF
#END FUNCTION
#FUN-A30027--end--mark---
 
FUNCTION p046_refresh_b2(p_ac)
   DEFINE p_ac LIKE type_file.num5
 
   CALL p046_fill2(p_ac)
   DISPLAY ARRAY g_idc TO s_idc.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
     BEFORE DISPLAY
     EXIT DISPLAY
   END DISPLAY
END FUNCTION
 
#判斷是否可進入單身2
FUNCTION p046_chk_b2(p_ac)
   DEFINE p_ac        LIKE type_file.num5
   DEFINE l_flag      LIKE type_file.num5
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01
   DEFINE l_qty       LIKE idc_file.idc08
   #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
   DEFINE l_sql       STRING   #FUN-A30027
 
   LET l_flag = 1
   
   #FUN-BA0051 --START mark--
   #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
   # WHERE imaicd00 = g_data[p_ac].rvv31    
   ##只有入庫料件狀態為012,且須做刻號管理才可進入
   ##FUN-BA0008 --START--
   #IF cl_null(l_imaicd08) OR l_imaicd08 = 'N' THEN
   #FUN-BA0051 --END mark--
   IF NOT s_icdbin(g_data[p_ac].rvv31) THEN   #FUN-BA0051
      LET l_flag = 0     
   END IF    
   #FUN-BA0008 --END--
#FUN-BA0008 --START mark --   
#   IF cl_null(g_data[p_ac].imaicd04) OR
#      g_data[p_ac].imaicd04 NOT MATCHES '[012]' OR
#      cl_null(l_imaicd08) OR l_imaicd08 = 'N' THEN
#      LET l_flag = 0
#   END IF   
#   
#   #取得庫存數量
#  #FUN-A30027--begin--modify--------
#  #CALL p046_qty(p_ac) RETURNING l_qty
#   CALL p046sub_qty(g_data[p_ac].sfbiicd09,g_data[p_ac].imaicd04,g_data[p_ac].rvv31,
#        g_data[p_ac].rvv32,g_data[p_ac].rvv33,g_data[p_ac].rvv34,g_data[p_ac].sfbiicd10,
#        g_data[p_ac].sfbiicd14)
#   RETURNING l_qty
#  #FUN-A30027--end--modify---------
# 
#   #數量相同
#   IF l_qty = g_data[p_ac].sfb08 THEN
#      #若入庫料號狀態為2且有資料為DG仍可進入
#      IF g_data[p_ac].imaicd04 = '2' AND
#         (cl_null(g_data[p_ac].sfbiicd10) OR g_data[p_ac].sfbiicd10 = 'N') THEN
#         LET g_cnt = 0
#        #FUN-A30027---begin--modify---------
#        # SELECT COUNT(*) INTO g_cnt FROM bin_temp
#        #  WHERE item1 = p_ac AND icf05 = '1'
#         LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                     " WHERE item1 = ",p_ac,
#                     "   AND icf05 = '1' "
#         PREPARE r406_bin_temp03 FROM l_sql
#         DECLARE bin_count_cs3 CURSOR FOR r406_bin_temp03
#         OPEN bin_count_cs3
#         FETCH bin_count_cs3 INTO g_cnt
#        #FUN-A30027--end--modify---------------
#         IF g_cnt = 0 THEN
#            LET l_flag = 0
#         END IF
#      ELSE
#         LET l_flag = 0
#      END IF
#   END IF
#FUN-BA0008 --END mark -- 
   RETURN l_flag
END FUNCTION
 
#單身2
FUNCTION p046_b2(p_ac)
DEFINE p_ac            LIKE type_file.num5
DEFINE l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
       l_cnt           LIKE type_file.num5,              #檢查重複用
       l_sql           STRING,
       l_ecdicd01     LIKE ecd_file.ecdicd01,
       #l_qty           LIKE idc_file.idc08   #FUN-BA0008 mark
       l_qty1,l_qty2   LIKE idc_file.idc08,   #FUN-BA0008  
       l_ima906        LIKE ima_file.ima906,   #FUN-BA0008
       l_i             LIKE type_file.num5        #FUN-C30305
 
   IF NOT p046_chk_b2(p_ac) THEN RETURN END IF
   IF g_rec_b2 = 0 THEN RETURN END IF
   CALL p046sub_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01  #FUN-A30027
 
   INPUT ARRAY g_idc WITHOUT DEFAULTS FROM s_idc.*
      ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      BEFORE INPUT
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         LET g_idc_t.* = g_idc[l_ac2].*
         NEXT FIELD sel2
 
      BEFORE FIELD sel2
         CALL p046_set_entry_b2()
         CALL p046_set_no_required_b2()
#FUN-BA0008 --START mark--  
#      ON CHANGE sel2
#         IF g_idc[l_ac2].sel2 = 'Y' THEN
#            LET l_qty = 0
# 
#            IF l_ecdicd01 = '2' THEN
#              #FUN-A30027--begin--modify------------
#              #SELECT SUM(qty1) INTO l_qty FROM bin_temp
#              # WHERE item1 = p_ac AND sel2 = 'Y'
#              #   AND item2 <> g_idc_t.item
#                LET l_sql = "SELECT SUM(qty1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                            " WHERE item1 = ",p_ac,
#                            "   AND sel2 = 'Y' ",
#                            "   AND item2 <> '",g_idc_t.item,"' "
#                PREPARE r406_bin_temp04 FROM l_sql
#                DECLARE bin_sum_cs CURSOR FOR r406_bin_temp04
#                OPEN bin_sum_cs
#                FETCH bin_sum_cs INTO l_qty
#               #FUN-A30027--end--modify-------------
#               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
#               LET l_qty = l_qty + g_idc[l_ac2].qty1
#            ELSE
#              #FUN-A30027---begin----modify-------------
#              #SELECT SUM(qty2) INTO l_qty FROM bin_temp
#              # WHERE item1 = p_ac AND sel2 = 'Y'
#              #   AND item2 <> g_idc_t.item
#               LET l_sql = "SELECT SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
#                            " WHERE item1 = ",p_ac,
#                            "   AND sel2 = 'Y' ",
#                            "   AND item2 <> '",g_idc_t.item,"' "
#                PREPARE r406_bin_temp05 FROM l_sql
#                DECLARE bin_sum_cs1 CURSOR FOR r406_bin_temp05
#                OPEN bin_sum_cs1
#                FETCH bin_sum_cs1 INTO l_qty
#               #FUN-A30027--end--modify-------------
#               IF cl_null(l_qty) THEN LET l_qty = 0 END IF
#               LET l_qty = l_qty + g_idc[l_ac2].qty2
#            END IF
# 
#            #數量超過生產發料數量
#            IF l_qty > g_data[p_ac].sfb08 THEN
#               CALL cl_err('','aic-133',0)
#               LET g_idc[l_ac2].sel2 = 'N'
#            END IF
#         END IF
#         #避免數量相同但能改ima01的資料被取消勾選
#         IF g_idc[l_ac2].sel2 = 'N' THEN
#            #FUN-A30027--begin--modify--------
#            #CALL p046_qty(p_ac) RETURNING l_qty
#             CALL p046sub_qty(g_data[p_ac].sfbiicd09,g_data[p_ac].imaicd04,g_data[p_ac].rvv31,
#             g_data[p_ac].rvv32,g_data[p_ac].rvv33,g_data[p_ac].rvv34,g_data[p_ac].sfbiicd10,
#             g_data[p_ac].sfbiicd14)
#             RETURNING l_qty
#            #FUN-A30027--end--modify---------
#            IF (cl_null(g_data[p_ac].sfbiicd10) OR
#                g_data[p_ac].sfbiicd10 = 'N') AND
#               g_data[p_ac].imaicd04 = '2' AND l_qty = g_data[p_ac].sfb08 THEN
#               LET g_idc[l_ac2].sel2 = 'Y'
#            END IF
#         END IF
# 
#       #在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
#       #抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
#       #當生產料號與產品型號的預設值
#       #(生產料號/產品型號為空白時,才需做此預設動作)
#       #FUN-A30027--begin--modify-----
#       #CALL p046_def_idc(p_ac,l_ac2)
#        CALL p046sub_def_idc(g_idc[l_ac2].sel2,g_data[p_ac].imaicd04,g_idc[l_ac2].icf05,
#                          g_idc[l_ac2].ima01,g_data[p_ac].rvv31,g_data[p_ac].sfb05,
#                          g_idc[l_ac2].sfbiicd08_b,g_data[p_ac].sfbiicd14,g_data[p_ac].sfbiicd08)
#       #FUN-A30027--end--modify-------
#             RETURNING g_idc[l_ac2].ima01,
#                       g_idc[l_ac2].sfbiicd08_b
#        DISPLAY BY NAME g_idc[l_ac2].ima01,
#                        g_idc[l_ac2].sfbiicd08_b
#FUN-BA0008 --END mark--  
      AFTER FIELD sel2 #挑選
         IF NOT cl_null(g_idc[l_ac2].sel2) THEN
            IF g_idc[l_ac2].sel2 NOT MATCHES '[YN]' THEN
               NEXT FIELD sel2
            END IF
         END IF
         CALL p046_set_no_entry_b2(p_ac)
         CALL p046_set_required_b2(p_ac)
 
      AFTER FIELD ima01 #料號
         IF NOT cl_null(g_idc[l_ac2].ima01) THEN
            CALL p046_ima01(p_ac)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_idc[l_ac2].ima01,g_errno,0)
               NEXT FIELD ima01
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_idc[l_ac2].* = g_idc_t.*
            EXIT INPUT
         END IF
 
         #料件狀態為2且為DG必填 ima01
         IF g_idc[l_ac2].sel2 = 'Y' AND
            g_data[p_ac].imaicd04 = '2' AND
            g_idc[l_ac2].icf05 = '1' THEN
            IF cl_null(g_idc[l_ac2].ima01) THEN
               NEXT FIELD ima01
            END IF
         
            LET l_ecdicd01 = ''
            #若要產生的工單作業群組為456,則產品型號必填
            CALL p046sub_ecdicd01(g_data[p_ac].sfbiicd09)  #FUN-A30027
                 RETURNING l_ecdicd01
            IF l_ecdicd01 MATCHES '[456]' THEN
               IF cl_null(g_idc[l_ac2].sfbiicd08_b) THEN
                  NEXT FIELD sfbiicd08_b
               END IF
            END IF
         END IF
 
         #因為後續要用該欄位做group,所以不可存null
         IF cl_null(g_idc[l_ac2].sfbiicd08_b) THEN
            LET g_idc[l_ac2].sfbiicd08_b = ' '
         END IF
        #FUN-A30027--begin--modify-------
        # UPDATE bin_temp SET sel2  = g_idc[l_ac2].sel2,
        #                     ima01 = g_data[l_ac].sfb05,      #FUN-910077
        #                     ima02 = g_data[l_ac].sfbiicd08,  #FUN-910077                          
        #                     sfbiicd08_b = g_idc[l_ac2].sfbiicd08_b
        #  WHERE item1 = p_ac
        #    AND item2 = g_idc[l_ac2].item
         LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET sel2 = '",g_idc[l_ac2].sel2,"',",
                     "       ima01 = '",g_data[l_ac].sfb05,"',",
                     "       ima02 = '",g_data[l_ac].sfbiicd08,"',",
                     "       sfbiicd08_b = '",g_idc[l_ac2].sfbiicd08_b,"' ",
                     " WHERE item1 = ",p_ac,
                     "   AND item2 = '",g_idc[l_ac2].item,"' "
         PREPARE p406_upd_1 FROM l_sql
         EXECUTE p406_upd_1
        #FUN-A30027--end--modify-----------
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('upd bin_temp','9050',1)
         END IF
      AFTER ROW
         LET l_ac2 = ARR_CURR()
         LET l_ac_t = l_ac2
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET g_idc[l_ac2].* = g_idc_t.*
            LET INT_FLAG = 0
            EXIT INPUT
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(ima01)     #料號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_icm02_icd"
               LET g_qryparam.default1 = g_idc[l_ac2].ima01
               LET g_qryparam.arg1 = g_data[p_ac].rvv31
               LET g_qryparam.where = " icm02 <> '",g_data[p_ac].sfb05,"'"
               CALL cl_create_qry() RETURNING g_idc[l_ac2].ima01
               DISPLAY BY NAME g_idc[l_ac2].ima01
               NEXT FIELD ima01

#FUN-A10138--begin--mark---------- 
#            WHEN INFIELD(sfbiicd08_b) #產品型號
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_ick01_icd"
#               LET g_qryparam.default1 = g_idc[l_ac2].sfbiicd08_b
#               LET g_qryparam.arg1 = g_data[p_ac].sfbiicd14
#               LET g_qryparam.where = " ick02 <> '",
#                                        g_data[p_ac].sfbiicd08,"'"
#               CALL cl_create_qry() RETURNING g_idc[l_ac2].sfbiicd08_b
#               DISPLAY BY NAME g_idc[l_ac2].sfbiicd08_b
#               NEXT FIELD sfbiicd08_b
#FUN-A10138--end--mark-------------
 
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode())
            RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
      #FUN-C30305---begin
      ON ACTION all
         FOR l_i = 1 TO g_idc.getLength()
             LET g_idc[l_i].sel2 = 'Y'
             DISPLAY BY NAME g_idc[l_i].sel2
             CALL p046_set_no_entry_b2(p_ac)
             CALL p046_set_required_b2(p_ac)
         END FOR
         LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET sel2 = 'Y' ",
                     " WHERE item1 = ",p_ac
         PREPARE p406_upd_3 FROM l_sql
         EXECUTE p406_upd_3
        #FUN-A30027--end--modify-----------
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('upd bin_temp','9050',1)
         END IF
      ON ACTION no_all
         FOR l_i = 1 TO g_idc.getLength()
             LET g_idc[l_i].sel2 = 'N'
             DISPLAY BY NAME g_idc[l_i].sel2
             CALL p046_set_no_entry_b2(p_ac)
             CALL p046_set_required_b2(p_ac)
         END FOR
         LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET sel2 = 'N' ",
                     " WHERE item1 = ",p_ac
         PREPARE p406_upd_4 FROM l_sql
         EXECUTE p406_upd_4
        #FUN-A30027--end--modify-----------
         IF SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err('upd bin_temp','9050',1)
         END IF
      #FUN-C30305---end
   END INPUT
 
   #IF l_ecdicd01 = '2' THEN   #FUN-BA0008 mark
     #FUN-A30027--begin--modify------
     # SELECT SUM(qty1) INTO l_qty FROM bin_temp
     #  WHERE item1 = p_ac AND sel2 = 'Y'
      LET l_sql = "SELECT SUM(qty1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " WHERE item1 = ",p_ac,
                  "   AND sel2 = 'Y' "
      PREPARE r406_bin_temp07 FROM l_sql
      DECLARE bin_sum_cs2 CURSOR FOR r406_bin_temp07
      OPEN bin_sum_cs2
      #FETCH bin_sum_cs2 INTO l_qty   #FUN-BA0008 mark
      FETCH bin_sum_cs2 INTO l_qty1   #FUN-BA0008
     #FUN-A30027--end--modify-------------
   #ELSE   #FUN-BA0008 mark
     #FUN-A30027--begin--modify-----------
     # SELECT SUM(qty2) INTO l_qty FROM bin_temp
     #  WHERE item1 = p_ac AND sel2 = 'Y'
      LET l_sql = "SELECT SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " WHERE item1 = ",p_ac,
                  "   AND sel2 = 'Y' "
      PREPARE r406_bin_temp08 FROM l_sql
      DECLARE bin_sum_cs3 CURSOR FOR r406_bin_temp08
      OPEN bin_sum_cs3
      #FETCH bin_sum_cs3 INTO l_qty   #FUN-BA0008 mark
      FETCH bin_sum_cs3 INTO l_qty2   #FUN-BA0008 
     #FUN-A30027--end--modify-------------
   #END IF   #FUN-BA0008 mark
 
   #IF cl_null(l_qty) THEN LET l_qty = 0 END IF    #FUN-BA0008 mark
   IF cl_null(l_qty1) THEN LET l_qty1 = 0 END IF  #FUN-BA0008 
   IF cl_null(l_qty2) THEN LET l_qty2 = 0 END IF  #FUN-BA0008 
   #刻號數量與生產發料數量不同
   #IF l_qty <> g_data[p_ac].sfb08 THEN   #FUN-BA0008 mark
   #   CALL cl_err('','aic-142',1)        #FUN-BA0008 mark
   #END IF                                #FUN-BA0008 mark

   #FUN-BA0008 --START--
   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=g_data[l_ac].rvv31
   IF g_data[l_ac].imaicd04 ='2' AND g_sma.sma115='Y' AND l_ima906='3' THEN
      IF l_qty2 <> g_data[p_ac].sfb08 THEN  
         IF cl_confirm('aic-219') THEN
            LET g_data[l_ac].sfb08=l_qty2
            LET g_data[l_ac].sfbiicd06=l_qty2
            DISPLAY BY NAME g_data[l_ac].sfb08,g_data[l_ac].sfbiicd06
         END IF
      END IF
   ELSE
      IF l_qty1 <> g_data[p_ac].sfb08 THEN
         IF cl_confirm('aic-219') THEN
            LET g_data[l_ac].sfb08=l_qty1
            LET g_data[l_ac].sfbiicd06=l_qty2
            DISPLAY BY NAME g_data[l_ac].sfb08,g_data[l_ac].sfbiicd06
         END IF
      END IF
   END IF   
   #FUN-BA0008 --END--
END FUNCTION
 
#生產料號
FUNCTION p046_ima01(p_ac)
  DEFINE p_ac            LIKE type_file.num5
  DEFINE l_icmacti       LIKE icm_file.icmacti,
         l_bmaacti       LIKE bma_file.bmaacti,
         l_bma05         LIKE bma_file.bma05
  DEFINE i,l_n           LIKE type_file.num5
  DEFINE l_sql           STRING    #FUN-A30027
 
  SELECT icmacti INTO l_icmacti FROM icm_file
   WHERE icm01 = g_data[p_ac].rvv31
     AND icm02 = g_idc[l_ac2].ima01
 
  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = '100'
       WHEN l_icmacti <> 'Y'       LET g_errno = '9028'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF NOT cl_null(g_errno) THEN RETURN END IF
 
  #不可與生產料號相同吆
  IF g_data[p_ac].sfb05 = g_idc[l_ac2].ima01 THEN
     LET g_errno = 'aic-134'
  END IF
  IF NOT cl_null(g_errno) THEN RETURN END IF
 
  #要存在bom吆
  SELECT bma05,bmaacti INTO l_bma05,l_bmaacti FROM bma_file
   WHERE bma01 = g_idc[l_ac2].ima01
  CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'abm-742'
       WHEN l_bmaacti <> 'Y'       LET g_errno = '9028'
       WHEN l_bma05 IS NULL OR l_bma05 > g_pmm04
                                   LET g_errno = 'abm-005'
       OTHERWISE                   LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) THEN
     SELECT ima02 INTO g_idc[l_ac2].ima02 FROM ima_file
      WHERE ima01 = g_idc[l_ac2].ima01
  END IF
 
  IF NOT cl_null(g_errno) THEN RETURN END IF
 
  IF g_idc[l_ac2].ima01 != g_idc_t.ima01 OR
     cl_null(g_idc_t.ima01) THEN
 
     #判斷是此生產料號是否與其他down grade項次的生產料號不同
     LET l_n = 0
    #FUN-A30027--begin--modify-------
    # SELECT COUNT(*) INTO l_n
    #    FROM bin_temp
    #   WHERE item1 = p_ac
    #     AND item2 != g_idc[l_ac2].item
    #     AND sel2 = 'Y'
    #     AND (ima01 != g_idc[l_ac2].ima01
    #          OR ima01 IS NULL)
     LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",p_ac,
               "   AND item2 != '",g_idc[l_ac2].item,"'",
               "   AND sel2 = 'Y' ",
               "   AND (ima01 != '",g_idc[l_ac2].ima01,"' OR ima01 is null)"
     PREPARE r406_bin_temp09 FROM l_sql
     DECLARE bin_count_cs9 CURSOR FOR r406_bin_temp09
     OPEN bin_count_cs9
     FETCH bin_count_cs9 INTO l_n
  #FUN-A30027--end--modify---------------
     IF l_n > 0 THEN
        #是否將此生產料號更新至其他down grade項次的生產料號?(Y/N)
        IF cl_confirm('aic-135')THEN
           FOR i = 1 TO g_rec_b2
               IF g_idc[i].sel2 != 'Y' THEN
                  CONTINUE FOR
               END IF
               IF g_idc[i].ima01 != g_idc[l_ac2].ima01 THEN
                  LET g_idc[i].ima01 = g_idc[l_ac2].ima01
                  DISPLAY BY NAME g_idc[i].ima01
               END IF
           END FOR
           #更新
          #FUN-A30027--begin--modify-----------
          # UPDATE bin_temp SET ima01 = g_idc[l_ac2].ima01
          #    WHERE item1 = p_ac
          #      AND sel2 = 'Y'
           LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       "   SET ima01 = '",g_idc[l_ac2].ima01,"' ",
                       " WHERE item1 = ",p_ac,
                       "   AND sel2 = 'Y' "
           PREPARE p406_upd_2 FROM l_sql
           EXECUTE p406_upd_2
          #FUN-A30027--end--modify-----------
           IF SQLCA.SQLCODE THEN
              LET g_errno = SQLCA.SQLCODE
           END IF
        END IF
     END IF
  END IF
END FUNCTION
 
#FUN-A30027--begin--mark---
#FUNCTION p046_ecdicd01(p_ecd01)
#    DEFINE p_ecd01     LIKE ecd_file.ecd01
#    DEFINE l_ecdicd01 LIKE ecd_file.ecd01
#    SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01 = p_ecd01
#    RETURN l_ecdicd01
#END FUNCTION
#FUN-A30027--end--mark----
 
#-----------------------------------------------------------------------------#
#--------------------------產生工單/採購/發料單-------------------------------#
#-----------------------------------------------------------------------------#
#FUN-A30027--begin--mark---
#FUNCTION p046_process()
#   DEFINE l_i  LIKE type_file.num5
#   DEFINE l_dg LIKE type_file.num5
#   DEFINE l_ecdicd01   LIKE ecd_file.ecdicd01
#
#   FOR l_ac = 1 TO g_rec_b
#       #只取有打勾勾的資料
#       IF g_data[l_ac].sel = 'N' THEN CONTINUE FOR END IF
#
#       CALL g_process_msg[l_ac].sfb01.clear()
#       CALL g_process_msg[l_ac].pmm01.clear()
#       CALL g_process_msg[l_ac].sfp01.clear()
#
#       LET g_process_msg[l_ac].rvv01 = g_data[l_ac].rvv01
#       LET g_process_msg[l_ac].rvv02 = g_data[l_ac].rvv02
#
#       #idc資料挑選不齊全的資料跳過
#       IF NOT p046_chk_idc(l_ac) THEN CONTINUE FOR END IF
#
#       #處理委外工單資料 / 委外採購單資料 / 發料單資料--------------------#
#       CALL p046_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01
#
#       LET l_dg = 0
#       IF g_data[l_ac].imaicd04 = '2' THEN
#       SELECT COUNT(*) INTO l_dg FROM bin_temp
#        WHERE item1 = l_ac AND sel2 = 'Y'
#          AND icf05 = '1' AND ima01 IS NOT NULL
#       END IF
#
#       CALL g_fac.clear()
#       LET g_rec_b3 = 0
#       LET g_fac_tot= 0
#       LET l_ac3 = 0
#       CALL g_process.clear()
#       CASE
#          WHEN l_ecdicd01 MATCHES '[34]' AND             #Multi Die
#               g_data[l_ac].sfbiicd10 = 'Y'
#               DELETE FROM icout_temp
#               CALL p046_process1()
#          WHEN g_data[l_ac].imaicd04 = '2' AND l_dg > 0  #down grade
#               CALL p046_process2()
#          OTHERWISE                                       #一般
#               CALL p046_process3()
#       END CASE
#    END FOR
#END FUNCTION
#
## Multi-Die委外工單
#FUNCTION p046_process1()
#  DEFINE l_oeb04     LIKE oeb_file.oeb04,
#         l_imaicd08 LIKE imaicd_file.imaicd08,
#         l_pcs       LIKE sfb_file.sfb08,
#         l_dies      LIKE sfb_file.sfb08,
#         l_i         LIKE type_file.num10
#  DEFINE l_pmn01     LIKE pmn_file.pmn01
#  DEFINE l_pmn02     LIKE pmn_file.pmn02
#  DEFINE l_oeb01     LIKE oeb_file.oeb01
#  DEFINE l_oeb03     LIKE oeb_file.oeb03
#  DEFINE l_sfp   RECORD LIKE sfp_file.*  #FUN-910077
#  DEFINE l_o_prog STRING  #FUN-910077
#
#  #串採購單生產資訊ico_file
#  LET g_cnt = 0
#  SELECT COUNT(*) INTO g_cnt FROM ico_file
#   WHERE ico02 = 0 AND ico01 IN
#         (SELECT rvv36 FROM rvv_file
#           WHERE rvv01 = g_data[l_ac].rvv01 
#             AND rvv02 = g_data[l_ac].rvv02)
#     AND ico03 = '8'
#
#  IF g_cnt > 0 THEN
#     #如果查到,檢查料號(ico07)及比率(ico04)是否有資料存在,如果不存在
#     #出現錯誤訊息, 請user至採購單補比率(ico04)及料號(ico07)
#     DECLARE ico_cs CURSOR FOR
#      SELECT ico07,ico04 FROM ico_file
#       WHERE ico02 = 0 AND ico01 IN
#             (SELECT rvv36 FROM rvv_file
#               WHERE rvv01 = g_data[l_ac].rvv01
#                 AND rvv02 = g_data[l_ac].rvv02)
#         AND ico07 IS NOT NULL
#         AND ico04 IS NOT NULL AND ico04 > 0
#         AND ico03 = '8'
#     LET l_ac3 = 1
#     FOREACH ico_cs INTO g_fac[l_ac3].*
#         LET g_fac_tot = g_fac_tot + g_fac[l_ac3].fac
#         LET l_ac3 = l_ac3 + 1
#     END FOREACH
#     CALL g_fac.deleteElement(l_ac3)
#     LET g_rec_b3 = l_ac3 - 1
#
#     IF g_rec_b3 = 0 THEN
#        #沒維護比率
#        CALL cl_getmsg('aic-125',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#        RETURN
#     END IF
#  ELSE #--------------------------------------------------------------------#
#     #如果查不到資料,則回串採購單之訂單(pmniicd01)及項次(pmniicd02),
#     #帶出訂單料號(oeb04);再由訂單料號(oeb04)串New Code檔(icw_file)
#     #(icw05)之有效單號(icw10='Y'), 如果查詢不到,系統出現錯誤訊息
#     CALL s_get_so(l_pmn01,l_pmn02) RETURNING l_oeb01,l_oeb03
#     SELECT oeb04 INTO l_oeb04 FROM oeb_file
#      WHERE oeb01=l_oeb01
#        AND oeb03=l_oeb03
#     IF cl_null(l_oeb04) THEN
#        #無法串new code
#        CALL cl_getmsg('aic-126',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#        RETURN
#     END IF
#
#     DECLARE icw_cs CURSOR FOR
#      SELECT icw03,icw19 FROM icw_file,icx_file
#       WHERE icw01 = icx01 AND icw05 = l_oeb04 AND icw10 = 'Y'
#         AND icw03 IS NOT NULL AND icw19 IS NOT NULL AND icw19 > 0
#     LET l_ac3 = 1
#     FOREACH ico_cs INTO g_fac[l_ac3].*
#         LET g_fac_tot = g_fac_tot + g_fac[l_ac3].fac
#         LET l_ac3 = l_ac3 + 1
#     END FOREACH
#     CALL g_fac.deleteElement(l_ac3)
#     LET g_rec_b3 = l_ac3 - 1
#
#     IF g_rec_b3 = 0 THEN
#        #無法串new code
#        CALL cl_getmsg('aic-126',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#        RETURN
#     END IF
#  END IF
#  SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
#   WHERE imaicd00 = g_data[l_ac].rvv31
#
#  SELECT SUM(qty1),SUM(qty2) INTO l_pcs,l_dies FROM bin_temp
#   WHERE item1 = l_ac AND sel2 = 'Y'
#
#  #先預設最後一筆
#  LET g_process[g_rec_b3].* = g_data[l_ac].*
#  LET g_process[g_rec_b3].sfb05 = g_fac[g_rec_b3].ima01
#  LET g_process[g_rec_b3].sfb08 = l_dies
#
#  FOR l_ac3 = 1 TO g_rec_b3 - 1
#      LET g_process[l_ac3].* = g_data[l_ac].*
#      LET g_process[l_ac3].sfb05 = g_fac[l_ac3].ima01
#      LET g_process[l_ac3].sfb08 = l_dies * g_fac[l_ac3].fac / g_fac_tot
#      LET l_i = g_process[l_ac3].sfb08 / 1
#      IF g_process[l_ac3].sfb08  - l_i > 0 THEN  #強迫取整數位
#         LET g_process[l_ac3].sfb08 = l_i + 1
#      END IF
#
#      #扣最後一筆(使最後差額全到最後一筆)
#      LET g_process[g_rec_b3].sfb08 = g_process[g_rec_b3].sfb08 -
#                                      g_process[l_ac3].sfb08
#  END FOR
#
#  LET g_success = 'Y'
#  DELETE FROM icout_temp
#  FOR l_ac3 = 1 TO g_rec_b3
#      CALL p046_icout_temp_gen()
#      IF g_success = 'N' THEN RETURN END IF
#  END FOR
#
#  #產生委外工單資料
#  BEGIN WORK
#  FOR l_ac3 = 1 TO g_rec_b3
#      CALL p046_ins_sfb()       # 1.產生委外工單單頭(sfb_file)
#      IF g_success = 'N' THEN EXIT FOR END IF
#
#      CALL p046_ins_sfa()       # 2.產生委外工單單身(sfa_file)
#      IF g_success = 'N' THEN EXIT FOR END IF
#      LET g_process_msg[l_ac].sfb01[l_ac3] = g_sfb.sfb01
#  END FOR
#  IF g_success = 'Y' THEN
#     COMMIT WORK
#  ELSE
#     FOR l_ac3 = 1 TO g_process_msg[l_ac].sfb01.getLength()
#         CALL g_process_msg[l_ac].sfb01.clear()
#     END FOR
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  FOR l_ac3 = 1 TO g_rec_b3
#      LET g_sfb.sfb01 = g_process_msg[l_ac].sfb01[l_ac3]
#      CALL p046_sfb_confirm()   # 3.處理委外工單確認(含產生委外採購單資料)
#      CALL p046_sfp_gen()       # 4.產生發料單
#
#      IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN #有發料單才往下執行
#         SELECT * INTO g_sfp.*,g_sfq.*,g_sfs.* FROM sfp_file,sfq_file,sfs_file
#          WHERE sfp01 = g_process_msg[l_ac].sfp01[l_ac3]
#            AND sfp01 = sfq01 AND sfq01 = sfs01
#         IF SQLCA.sqlcode = 100 THEN CONTINUE FOR END IF
#
#         LET g_success = 'Y'
#         BEGIN WORK
#         CALL p046_icaout('1')  # 5.處理icaout
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#         ELSE
#            ROLLBACK WORK CONTINUE FOR
#         END IF
#
#        #檢查有發料單存在否,若存在則自動過帳
#
#        IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN
#           BEGIN WORK
#           CALL i501sub_y_chk(g_process_msg[l_ac].sfp01[l_ac3])
#           IF g_success = "Y" THEN
#              CALL i501sub_y_upd(g_process_msg[l_ac].sfp01[l_ac3],NULL,TRUE)
#                RETURNING l_sfp.*
#           END IF
#           
#           LET l_o_prog = g_prog
#           CASE l_sfp.sfp06
#              WHEN "1" LET g_prog='asfi511'
#              WHEN "2" LET g_prog='asfi512'
#              WHEN "3" LET g_prog='asfi513'
#              WHEN "4" LET g_prog='asfi514'
#              WHEN "6" LET g_prog='asfi526'
#              WHEN "7" LET g_prog='asfi527'
#              WHEN "8" LET g_prog='asfi528'
#              WHEN "9" LET g_prog='asfi529'
#           END CASE
#           
#           IF g_success = "Y" THEN
#              CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
#           END IF
#           LET g_prog = l_o_prog
#           
#           IF g_success='Y' THEN
#              COMMIT WORK
#           ELSE
#              ROLLBACK WORK
#           END IF
#        END IF
#      END IF
#  END FOR
#END FUNCTION
#
## DG委外工單
#FUNCTION p046_process2()
#  DEFINE l_pcs          LIKE sfb_file.sfb08,
#         l_dies         LIKE sfb_file.sfb08,
#         l_ima01        LIKE ima_file.ima01,
#         l_ecdicd01     LIKE ecd_file.ecdicd01
#  DEFINE l_sfbiicd08_b  LIKE sfbi_file.sfbiicd08
#  DEFINE l_sfp   RECORD LIKE sfp_file.*  #FUN-910077
#  DEFINE l_o_prog STRING  #FUN-910077
#
#  CALL p046_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01
#
#  LET g_cnt = 0
#  SELECT COUNT(*) INTO g_cnt FROM bin_temp
#    WHERE item1 = l_ac AND sel2 = 'Y' AND icf05 <> '1'
#  IF g_cnt <> 0 THEN
#     LET l_ac3 = 1
#     LET g_process[l_ac3].* = g_data[l_ac].*
#     IF l_ecdicd01 = '2' THEN
#        SELECT SUM(qty1),SUM(qty2)
#          INTO g_process[l_ac3].sfb08,g_process[l_ac3].sfbiicd06
#          FROM bin_temp
#         WHERE item1 = l_ac AND sel2 = 'Y' AND icf05 <> '1'
#     ELSE
#        SELECT SUM(qty1),SUM(qty2)
#          INTO g_process[l_ac3].sfbiicd06,g_process[l_ac3].sfb08
#          FROM bin_temp
#         WHERE item1 = l_ac AND sel2 = 'Y' AND icf05 <> '1'
#     END IF
#  ELSE
#     LET l_ac3 = 0
#  END IF
#
#  DECLARE dg_cs CURSOR FOR
#   SELECT ima01,sfbiicd08_b,SUM(qty1),SUM(qty2) FROM bin_temp
#    WHERE item1 = l_ac AND sel2 = 'Y' AND icf05 = '1' AND ima01 IS NOT NULL
#    GROUP BY ima01,sfbiicd08_b
#
#  LET l_ac3 = l_ac3 + 1
#  FOREACH dg_cs INTO l_ima01,l_sfbiicd08_b,l_pcs,l_dies
#     LET g_process[l_ac3].* = g_data[l_ac].*
#
#     LET g_process[l_ac3].sfb05 = l_ima01
#     LET g_process[l_ac3].sfbiicd08 = l_sfbiicd08_b
#     IF l_ecdicd01 = '2' THEN
#        LET g_process[l_ac3].sfb08 = l_pcs
#        LET g_process[l_ac3].sfbiicd06 = l_dies
#     ELSE
#        LET g_process[l_ac3].sfb08 = l_dies
#        LET g_process[l_ac3].sfbiicd06 = l_pcs
#     END IF
#     LET l_ac3 = l_ac3 + 1
#  END FOREACH
#  CALL g_process.deleteElement(l_ac3)
#  LET g_rec_b3 = l_ac3 - 1
#  IF g_rec_b3 = 0 THEN RETURN END IF
#
#  #產生委外工單資料
#  LET g_success = 'Y'
#  BEGIN WORK
#  FOR l_ac3 = 1 TO g_rec_b3
#      CALL p046_ins_sfb()       # 1.產生委外工單單頭(sfb_file)
#      IF g_success = 'N' THEN EXIT FOR END IF
#      CALL p046_ins_sfa()       # 2.產生委外工單單身(sfa_file)
#      IF g_success = 'N' THEN EXIT FOR END IF
#      LET g_process_msg[l_ac].sfb01[l_ac3] = g_sfb.sfb01
#  END FOR
#  IF g_success = 'Y' THEN
#     COMMIT WORK
#  ELSE
#     FOR l_ac3 = 1 TO g_process_msg[l_ac].sfb01.getLength()
#         CALL g_process_msg[l_ac].sfb01.clear()
#     END FOR
#     ROLLBACK WORK
#     RETURN
#  END IF
#
#  FOR l_ac3 = 1 TO g_rec_b3
#      CALL p046_sfb_confirm()   # 3.處理委外工單確認(含產生委外採購單資料)
#      CALL p046_sfp_gen()       # 4.產生發料單
#
#      IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN #有發料單才往下執行
#         SELECT * INTO g_sfp.*,g_sfq.*,g_sfs.* FROM sfp_file,sfq_file,sfs_file
#          WHERE sfp01 = g_process_msg[l_ac].sfp01[l_ac3]
#            AND sfp01 = sfq01
#            AND sfq01 = sfs01
#         IF SQLCA.sqlcode = 100 THEN CONTINUE FOR END IF
#
#         LET g_success = 'Y'
#         BEGIN WORK
#         CALL p046_icaout('2')  # 5.處理icaout
#         IF g_success = 'Y' THEN
#            COMMIT WORK
#         ELSE
#            ROLLBACK WORK CONTINUE FOR
#         END IF
#        #檢查有發料單存在否,若存在則自動過帳
#        IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN
#           BEGIN WORK
#           CALL i501sub_y_chk(g_process_msg[l_ac].sfp01[l_ac3])
#           IF g_success = "Y" THEN
#              CALL i501sub_y_upd(g_process_msg[l_ac].sfp01[l_ac3],NULL,TRUE)
#                RETURNING l_sfp.*
#           END IF
#           
#           LET l_o_prog = g_prog
#           CASE l_sfp.sfp06
#              WHEN "1" LET g_prog='asfi511'
#              WHEN "2" LET g_prog='asfi512'
#              WHEN "3" LET g_prog='asfi513'
#              WHEN "4" LET g_prog='asfi514'
#              WHEN "6" LET g_prog='asfi526'
#              WHEN "7" LET g_prog='asfi527'
#              WHEN "8" LET g_prog='asfi528'
#              WHEN "9" LET g_prog='asfi529'
#           END CASE
#           
#           IF g_success = "Y" THEN
#              CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
#           END IF
#           LET g_prog = l_o_prog
#           
#           IF g_success='Y' THEN
#              COMMIT WORK
#           ELSE
#              ROLLBACK WORK
#           END IF
#        END IF
#      END IF
#  END FOR
#END FUNCTION
#
## 一般委外工單
#FUNCTION p046_process3()
#  DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
#  DEFINE l_sfp   RECORD LIKE sfp_file.*  #FUN-910077
#  DEFINE l_o_prog STRING  #FUN-910077
#
#  LET g_rec_b3 = 1
#  LET l_ac3 = 1
#  LET g_process[l_ac3].* = g_data[l_ac].*
#  CALL p046_ecdicd01(g_process[l_ac3].sfbiicd09) RETURNING l_ecdicd01
#
#  #重新計算生產參考數量sfbiicd06
#  CASE WHEN l_ecdicd01 = '2'
#            SELECT SUM(qty2) INTO g_process[l_ac3].sfbiicd06 FROM bin_temp
#             WHERE item1 = l_ac AND sel2 = 'Y'
#       WHEN l_ecdicd01 MATCHES '[346]'
#            SELECT SUM(qty1) INTO g_process[l_ac3].sfbiicd06 FROM bin_temp
#             WHERE item1 = l_ac AND sel2 = 'Y'
#       OTHERWISE
#            LET g_process[l_ac3].sfbiicd06 = g_process[l_ac3].sfb08
#  END CASE
#
#  LET g_success = 'Y'
#  BEGIN WORK
#  CALL p046_ins_sfb()       # 1.產生委外工單單頭(sfb_file)
#  IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
#  CALL p046_ins_sfa()       # 2.產生委外工單單身(sfa_file)
#  IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
#  LET g_process_msg[l_ac].sfb01[l_ac3] = g_sfb.sfb01
#
#  CALL p046_sfb_confirm()   # 3.處理委外工單確認(含產生委外採購單資料)
#  CALL p046_sfp_gen()       # 4.產生發料單
#
#  IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN #有發料單才往下執行
#     SELECT * INTO g_sfp.*,g_sfq.*,g_sfs.* FROM sfp_file,sfq_file,sfs_file
#      WHERE sfp01 = g_process_msg[l_ac].sfp01[l_ac3]
#        AND sfp01 = sfq01 AND sfq01 = sfs01
#     IF NOT cl_null(SQLCA.sqlcode) THEN
#        LET g_success = 'Y'
#        BEGIN WORK
#        CALL p046_icaout('3')  # 5.處理icaout
#        IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
#
#        #檢查有發料單存在否,若存在則自動過帳
#        IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN
#           BEGIN WORK
#           CALL i501sub_y_chk(g_process_msg[l_ac].sfp01[l_ac3])
#           IF g_success = "Y" THEN
#              CALL i501sub_y_upd(g_process_msg[l_ac].sfp01[l_ac3],NULL,TRUE)
#                RETURNING l_sfp.*
#           END IF
#           
#           LET l_o_prog = g_prog
#           CASE l_sfp.sfp06
#              WHEN "1" LET g_prog='asfi511'
#              WHEN "2" LET g_prog='asfi512'
#              WHEN "3" LET g_prog='asfi513'
#              WHEN "4" LET g_prog='asfi514'
#              WHEN "6" LET g_prog='asfi526'
#              WHEN "7" LET g_prog='asfi527'
#              WHEN "8" LET g_prog='asfi528'
#              WHEN "9" LET g_prog='asfi529'
#           END CASE
#           
#           IF g_success = "Y" THEN
#              CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
#           END IF
#           LET g_prog = l_o_prog
#           
#           IF g_success='Y' THEN
#              COMMIT WORK
#           ELSE
#              ROLLBACK WORK
#           END IF
#        END IF
#  
#     END IF
#  END IF
#END FUNCTION
#
## 產生委外工單單頭(sfb_file)
#FUNCTION p046_ins_sfb()
#   DEFINE li_result   LIKE type_file.num5,
#          l_ecdicd01 LIKE ecd_file.ecdicd01
#
#   CALL p046_ecdicd01(g_process[l_ac3].sfbiicd09) RETURNING l_ecdicd01
#
#   INITIALIZE g_sfb.* TO NULL
#   LET g_sfb.sfb01 = g_t1
#   LET g_sfb.sfb02 = '7'
#   LET g_sfb.sfb04  =1
#   LET g_sfb.sfb05  =g_process[l_ac3].sfb05
#   LET g_sfb.sfb06  =g_process[l_ac3].sfb06
#   LET g_sfb.sfb071 =g_pmm04
#   LET g_sfb.sfb081 =0
#   LET g_sfb.sfb09  =0
#   LET g_sfb.sfb10  =0
#   LET g_sfb.sfb11  =0
#   LET g_sfb.sfb111 =0
#   LET g_sfb.sfb12  =0
#   LET g_sfb.sfb121 =0
#   LET g_sfb.sfb13  =g_pmm04
#   LET g_sfb.sfb15  =g_process[l_ac3].sfb15
#   LET g_sfb.sfb23  ='N'
#   LET g_sfb.sfb24  ='N'
#   LET g_sfb.sfb29  ='Y'
#   LET g_sfb.sfb39  ='1'
#   LET g_sfb.sfb41  ='N'
#   LET g_sfb.sfb81  =g_pmm04
#   LET g_sfb.sfb87  ='N'
#   LET g_sfb.sfb98  =' '
#   LET g_sfb.sfb99  ='N'
#   LET g_sfb.sfb100 ='1'
#   LET g_sfb.sfbacti='Y'
#   LET g_sfb.sfbuser=g_user
#   LET g_sfb.sfbgrup=g_grup
#   LET g_sfb.sfbdate=g_pmm04
#   LET g_sfb.sfbplant = g_plant #FUN-980004 add
#   LET g_sfb.sfblegal = g_legal #FUN-980004 add
#
#   SELECT ima910 INTO g_sfb.sfb95 FROM ima_file
#    WHERE ima01 = g_process[l_ac3].sfb05
#   IF cl_null(g_sfb.sfb95) THEN LET g_sfb.sfb95 = ' ' END IF
#
#   CALL s_auto_assign_no("asf",g_sfb.sfb01,g_sfb.sfb81,"1","sfb_file",
#                         "sfb01","","","")
#        RETURNING li_result,g_sfb.sfb01
#   IF (NOT li_result) THEN #產生工單號失敗
#     CALL cl_getmsg('asf-377',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#      LET g_success = 'N' RETURN
#   END IF
#   SELECT SUBSTR(smy57,1,1),SUBSTR(smy57,2,2),SUBSTR(smy57,6,6)
#     INTO g_sfb.sfb93, g_sfb.sfb94, g_sfb.sfb100
#     FROM smy_file WHERE smyslip = g_t1
#   LET g_sfb.sfb93  ='N'--->確定不走製
#   #------------------------------------------------------------以下為客製
#   LET g_sfb.sfb82 = g_process[l_ac3].sfb82           #部門廠商
#
#   SELECT pmn01,pmn02,pmniicd01,pmniicd02
#     INTO g_sfb.sfb86,g_sfbi.sfbiicd15,                #母工單號/項次
#          g_sfb.sfb22,g_sfb.sfb221                    #訂單單號/項次
#     FROM pmn_file,pmni_file                          #No.TQC-950055  add pmni_file
#    WHERE (pmn01 || pmn02) IN
#          (SELECT rvv36 || rvv37 FROM rvv_file
#            WHERE rvv01 = g_process[l_ac3].rvv01
#              AND rvv02 = g_process[l_ac3].rvv02)
#              AND pmn01 = pmni01 AND pmn02 = pmni02        #NO.TQC-950055
#
#   LET g_sfbi.sfbiicd01 = g_process[l_ac3].sfbiicd01   #下階廠商
#   LET g_sfbi.sfbiicd02 = g_process[l_ac3].sfbiicd02   #wafer廠商
#   LET g_sfbi.sfbiicd03 = g_process[l_ac3].sfbiicd03   #wafer site
#   LET g_sfbi.sfbiicd04 = 0                            #預計生產數量
#   LET g_sfbi.sfbiicd05 = 0                            #預計生產參考數量
#   LET g_sfb.sfb08 = g_process[l_ac3].sfb08           #生產數量
#   LET g_sfbi.sfbiicd06 = g_process[l_ac3].sfbiicd06   #生產參考數量
#   LET g_sfbi.sfbiicd08 = g_process[l_ac3].sfbiicd08   #產品型號
#   LET g_sfbi.sfbiicd09 = g_process[l_ac3].sfbiicd09   #作業編號
#   LET g_sfbi.sfbiicd10 = g_process[l_ac3].sfbiicd10   #multi die
#   LET g_sfbi.sfbiplant = g_plant #FUN-980004 add
#   LET g_sfbi.sfbilegal = g_legal #FUN-980004 add
#
#   IF l_ecdicd01 MATCHES '[46]' THEN
#      SELECT icj06,icj04
#        INTO g_sfbi.sfbiicd11,                         #打線圖
#             g_sfbi.sfbiicd12                          #PKG
#        FROM icj_file
#       WHERE icj01 = g_process[l_ac3].sfbiicd14
#         AND icj02 = g_process[l_ac3].sfbiicd08
#         AND icj03 = g_process[l_ac3].sfb82
#   END IF
#   LET g_sfbi.sfbiicd13 = NULL                         #回貨批號
#   LET g_sfbi.sfbiicd14 = g_process[l_ac3].sfbiicd14   #母體料號
#   LET g_sfbi.sfbiicd16 = g_process[l_ac3].rvv01       #入庫單號
#   LET g_sfbi.sfbiicd17 = g_process[l_ac3].rvv02       #入庫項次
#      #批次工單時若為FT則帶ASS回貨時datecode到工單單頭
#   IF l_ecdicd01 = 5 THEN
#      SELECT rvviicd02 INTO g_sfbi.sfbiicd07
#        FROM rvvi_file
#       WHERE rvvi01 = g_sfbi.sfbiicd16
#         AND rvvi02 = g_sfbi.sfbiicd17
#   ELSE
#      LET g_sfbi.sfbiicd07 = NULL                         #Date Code
#   END IF
#   IF l_ecdicd01 MATCHES '[46]' THEN
#     SELECT icj05 INTO g_sfbi.sfbiicd18 FROM icj_file
#      WHERE icj01 = g_sfbi.sfbiicd14
#        AND icj02 = g_sfbi.sfbiicd08
#        AND icj03 = g_sfb.sfb82
#  END IF
#   LET g_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
#   LET g_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
#   INSERT INTO sfb_file VALUES(g_sfb.*)
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
#      LET g_process_msg[l_ac].rvv_msg = 'ins sfb_file err:',g_msg
#      LET g_success = 'N'
#      RETURN
#   END IF
#   
#   LET g_sfbi.sfbi01=g_sfb.sfb01
#   INSERT INTO sfbi_file VALUES(g_sfbi.*)
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
#      LET g_process_msg[l_ac].rvv_msg = 'ins sfbi_file err:',g_msg
#      LET g_success = 'N'
#      RETURN
#   END IF
#
#   #若為6.TKY且有押上製程編號,則產生製程追蹤檔
#   IF l_ecdicd01 = '6' AND NOT cl_null(g_sfb.sfb06) THEN
#      CALL p046_ins_ecm()
#   END IF
#END FUNCTION
#
## 產生委外工單單身(sfa_file)
#FUNCTION p046_ins_sfa()
#   DEFINE l_minopseq  LIKE type_file.num5,
#          l_ecdicd01 LIKE ecd_file.ecdicd01,
#          l_imaicd04 LIKE imaicd_file.imaicd04
#
#   CALL s_minopseq(g_sfb.sfb05,g_sfb.sfb06,g_sfb.sfb071) RETURNING l_minopseq
#
#   CALL s_cralc(g_sfb.sfb01,g_sfb.sfb02,g_sfb.sfb05,g_sma.sma29,
#                g_sfb.sfb08,g_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,
#                g_sfb.sfb95)
#        RETURNING g_cnt
#
#   #產生出來的備料只能有一筆
#   IF g_cnt <> 1 THEN
#      CALL cl_getmsg('aic-136',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#      LET g_success = 'N' RETURN
#   END IF
#
#   #產生出來的備料要等於入庫料號
#   SELECT COUNT(*) INTO g_cnt FROM sfa_file
#    WHERE sfa01 = g_sfb.sfb01 AND sfa03 = g_process[l_ac3].rvv31
#   IF g_cnt <> 1 THEN
#      #產生出來的備料要等於入庫料號
#      CALL cl_getmsg('aic-137',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#      LET g_success = 'N' RETURN
#   END IF
#   CALL p046_ecdicd01(g_sfbi.sfbiicd09) RETURNING l_ecdicd01
#
#   #---------------------------更新ICD欄位------------------------------#
#   SELECT sfb_file.*,sfbi_file.*,sfa_file.*,sfai_file.*  #TQC-940015
#     INTO g_sfb.*,g_sfbi.*,g_sfa.*,g_sfai.*  #TQC-940015
#     FROM sfb_file,sfbi_file,sfa_file,sfai_file  #TQC-940015
#    WHERE sfa01 = g_sfb.sfb01 AND sfa01 = sfb01
#      AND sfai01=sfa01 AND sfbi01=sfb01  #TQC-940015
#      AND sfai03 = sfa03 AND sfai08 = sfa08 AND sfai12 = sfa12  AND sfai27 = sfa27           #NO.TQC-950055
#   SELECT ima907 INTO g_sfai.sfaiicd02 FROM ima_file WHERE ima01 = g_sfa.sfa03
#   LET g_sfa.sfa30      = g_data[l_ac].rvv32
#   LET g_sfa.sfa31      = g_data[l_ac].rvv33
#   LET g_sfai.sfaiicd03 = g_data[l_ac].rvv34
#   LET g_sfai.sfaiicd04 = 0
#   LET g_sfai.sfaiicd05 = 0
#   CALL p046_set_sfa_qty(l_ecdicd01) #更新應發數量/應發參考數量
#
#   UPDATE sfa_file SET * = g_sfa.* WHERE sfa01 = g_sfa.sfa01
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
#      LET g_process_msg[l_ac].rvv_msg = 'upd sfa_file err:',g_msg
#      LET g_success = 'N' RETURN
#   END IF
#   IF l_ecdicd01 MATCHES '[34]' THEN
#      LET g_sfbi.sfbiicd05 = g_sfa.sfa05
#      UPDATE sfbi_file SET * = g_sfbi.* WHERE sfbi01 = g_sfb.sfb01
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
#         LET g_process_msg[l_ac].rvv_msg = 'upd sfbi_file err:',g_msg  
#         LET g_success = 'N' RETURN
#      END IF
#   END IF
#   UPDATE sfai_file SET * = g_sfai.* WHERE sfai01 = g_sfb.sfb01
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
#      LET g_process_msg[l_ac].rvv_msg = 'upd sfai_file err:',g_msg  
#      LET g_success = 'N' RETURN
#   END IF
#END FUNCTION
#
##更新應發數量/應發參考數量
#FUNCTION p046_set_sfa_qty(p_ecdicd01)
#   DEFINE p_ecdicd01  LIKE ecd_file.ecdicd01,
#          l_cnt       LIKE type_file.num5
#
#   #更新sfa05
#   IF p_ecdicd01 MATCHES '[346]' THEN
#      LET g_sfa.sfa05 = g_sfbi.sfbiicd06
#      #重新計算實際QPA
#      LET g_sfa.sfa161=g_sfa.sfa05/g_sfb.sfb08
#   END IF
#
#   #更新sfaiicd01
#   CASE
#      WHEN p_ecdicd01 = '2'
#           LET g_sfai.sfaiicd01 = g_process[l_ac3].sfbiicd06
#      WHEN p_ecdicd01 MATCHES '[346]'
#           LET g_sfai.sfaiicd01 = g_process[l_ac3].sfb08
#      WHEN p_ecdicd01 = '5'
#           LET g_sfai.sfaiicd01 = g_sfa.sfa05
#   END CASE
#END FUNCTION
#
##產生製程追蹤檔
#FUNCTION p046_ins_ecm()
# DEFINE l_ima55  LIKE ima_file.ima55,
#        l_ima571 LIKE ima_file.ima571,
#        l_ecu01  LIKE ecu_file.ecu01,
#        l_ecb    RECORD LIKE ecb_file.*, #routing detail file
#        l_ecm    RECORD LIKE ecm_file.*, #routing detail file
#        l_sgc    RECORD LIKE sgc_file.*, #routing detail file
#        l_sgd    RECORD LIKE sgd_file.*, #routing detail file
#        l_woq    LIKE   sfb_file.sfb08   #工單未生產數量
# DEFINE l_bdate,l_day LIKE type_file.dat,
#        l_flag        LIKE type_file.chr1
#
# #決定製程料號
# SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=g_sfb.sfb05
#
# SELECT ecu01 FROM ecu_file WHERE ecu01=l_ima571 AND ecu02=g_sfb.sfb06
# IF SQLCA.sqlcode THEN
#    SELECT ecu01 FROM ecu_file WHERE ecu01=g_sfb.sfb05 AND ecu02=g_sfb.sfb06
#    IF SQLCA.sqlcode = 100 THEN
#       CALL cl_getmsg('aec-014',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#       LET g_success = 'N' RETURN
#    ELSE
#       LET l_ecu01=g_sfb.sfb05
#    END IF
# ELSE
#    LET l_ecu01=l_ima571
# END IF
#
# #取製程資料
# DECLARE c_put CURSOR FOR
#  SELECT * FROM ecb_file
#   WHERE ecb01=l_ecu01
#     AND ecb02=g_sfb.sfb06
#     AND ecbacti='Y'
#   ORDER BY ecb03 #製程序號
#
# FOREACH c_put INTO l_ecb.*
#   IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#   INITIALIZE l_ecm.* TO NULL
#   LET l_ecm.ecm01      =  g_sfb.sfb01
#   LET l_ecm.ecm02      =  g_sfb.sfb02
#   LET l_ecm.ecm03_par  =  g_sfb.sfb05
#   LET l_ecm.ecm03      =  l_ecb.ecb03
#   LET l_ecm.ecm04      =  l_ecb.ecb06
#   LET l_ecm.ecm05      =  l_ecb.ecb07
#   LET l_ecm.ecm06      =  l_ecb.ecb08
#   LET l_ecm.ecm07      =  0
#   LET l_ecm.ecm08      =  0
#   LET l_ecm.ecm09      =  0
#   LET l_ecm.ecm10      =  0
#   LET l_ecm.ecm11      =  l_ecb.ecb02          #製程編號
#   LET l_ecm.ecm13      =  l_ecb.ecb18          #固定工時(秒)
#   LET l_ecm.ecm14      =  l_ecb.ecb19*l_woq    #標準工時(秒)
#   LET l_ecm.ecm15      =  l_ecb.ecb20          #固定機時(秒)
#   LET l_ecm.ecm16      =  l_ecb.ecb21*l_woq    #標準機時(秒)
#   LET l_ecm.ecm49      =  l_ecb.ecb38*l_woq    #製程人力
#   LET l_ecm.ecm45      =  l_ecb.ecb17          #作業名稱
#   LET l_ecm.ecm52      =  l_ecb.ecb39          #SUB 否
#   LET l_ecm.ecm53      =  l_ecb.ecb40          #PQC 否
#   LET l_ecm.ecm54      =  l_ecb.ecb41          #Check in 否
#   LET l_ecm.ecm55      =  l_ecb.ecb42          #Check in Hold 否
#   LET l_ecm.ecm56      =  l_ecb.ecb43          #Check Out Hold 否
#   LET l_ecm.ecm291     =  0
#   LET l_ecm.ecm292     =  0
#   LET l_ecm.ecm301     =  0
#   LET l_ecm.ecm302     =  0
#   LET l_ecm.ecm303     =  0
#   LET l_ecm.ecm311     =  0
#   LET l_ecm.ecm312     =  0
#   LET l_ecm.ecm313     =  0
#   LET l_ecm.ecm314     =  0
#   LET l_ecm.ecm315     =  0           #bonus
#   LET l_ecm.ecm316     =  0           #bonus
#   LET l_ecm.ecm321     =  0
#   LET l_ecm.ecm322     =  0
#   LET l_ecm.ecm57      = l_ecb.ecb44
#   LET l_ecm.ecm58      = l_ecb.ecb45
#   LET l_ecm.ecm59      = l_ecb.ecb46
#   LET l_ecm.ecmacti    =  'Y'
#   LET l_ecm.ecmuser    =  g_user
#   LET l_ecm.ecmgrup    =  g_grup
#   LET l_ecm.ecmmodu    =  ''
#   LET l_ecm.ecmdate    =  g_pmm04
#   LET l_ecm.ecmplant = g_plant #FUN-980004 add
#   LET l_ecm.ecmlegal = g_legal #FUN-980004 add
#   LET l_ecm.ecm51 = g_sfb.sfb15
#   LET l_day = ((l_ecm.ecm14 + l_ecm.ecm13) / 86400 +0.99 ) * -1
#   CALL s_wknxt(l_ecm.ecm51,l_day) RETURNING l_flag,l_bdate
#   CALL s_wknxt(l_bdate,1) RETURNING l_flag,l_ecm.ecm50
#   LET l_ecm.ecmoriu = g_user      #No.FUN-980030 10/01/04
#   LET l_ecm.ecmorig = g_grup      #No.FUN-980030 10/01/04
#   INSERT INTO ecm_file VALUES(l_ecm.*)
#   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#      CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
#      LET g_process_msg[l_ac].rvv_msg = 'ins ecm_file err:',g_msg
#      LET g_success = 'N' RETURN
#   END IF
# END FOREACH
# LET g_cnt = 0
# SELECT COUNT(*) INTO g_cnt FROM ecm_file WHERE ecm01 = g_sfb.sfb01
# IF g_cnt = 0 THEN
#    CALL cl_err('','asf-386',1)
#    CALL cl_getmsg('asf-386',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
#    LET g_success = 'N' RETURN
# END IF
#END FUNCTION
#
##工單確認(含產生委外採購單)
#FUNCTION p046_sfb_confirm()
#   DEFINE l_flag LIKE type_file.chr1 #No.FUN-830132
#   SELECT sfb_file.*,sfa_file.* INTO g_sfb.*,g_sfa.* FROM sfb_file,sfa_file
#    WHERE sfb01 = sfa01 AND sfb01 = g_process_msg[l_ac].sfb01[l_ac3]
#
#   CALL i301sub_ind_icd_set_pmm(g_pmm22,g_pmm42)
#   CALL i301sub_firm1_chk(g_sfb.sfb01,FALSE)    #CALL原確認的check段  #No.FUN-950021
#   IF g_success = 'Y' THEN
#      CALL i301sub_firm1_upd(g_sfb.sfb01,' ',FALSE) #TQC-9B0199 add #CALL原確認的update段 #CHI-940028  #No.FUN-950021
#   END IF
#   LET g_cnt = 0
#   SELECT COUNT(*) INTO g_cnt FROM pmm_file WHERE pmm01 = g_sfb.sfb01
#   IF g_cnt = 1 THEN
#      LET g_process_msg[l_ac].pmm01[l_ac3] = g_sfb.sfb01
#   END IF
#   #重取工單資料
#   SELECT sfb_file.*,sfa_file.* INTO g_sfb.*,g_sfa.* FROM sfb_file,sfa_file
#    WHERE sfb01 = g_sfb.sfb01 AND sfb01 = sfa01
#
#   #若工單確認失敗->作廢工單,刪除委外採購單
#   IF g_sfb.sfb87 <> 'Y' THEN
#      DELETE FROM pmm_file WHERE pmm01 = g_sfb.sfb01
#      DELETE FROM pmn_file WHERE pmn01 = g_sfb.sfb01
#      IF NOT s_industry('std') THEN
#         LET l_flag = s_del_pmni(g_sfb.sfb01,'','')
#      END IF
#      UPDATE sfb_file SET sfb87 = 'X',
#                          sfbmodu = g_user,
#                          sfbdate = g_pmm04
#       WHERE sfb01 = g_sfb.sfb01
#   END IF
#END FUNCTION
#
##產生發料單
#FUNCTION p046_sfp_gen()
#   DEFINE l_sfp01 LIKE sfp_file.sfp01
#
#   SELECT sfb_file.*,sfa_file.* INTO g_sfb.*,g_sfa.* FROM sfb_file,sfa_file
#    WHERE sfb01 = sfa01 AND sfb01 = g_process_msg[l_ac].sfb01[l_ac3]
#
#   IF g_sfb.sfb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#  #先做基本檢查
#   IF g_sfb.sfb87 = 'N' THEN RETURN END IF #不可未確認
#   IF g_sfb.sfb04 = '1' THEN RETURN END IF #不可未發放
#
#   CALL i301sub_ind_icd_material_collect(g_sfb.sfb01,g_t2,g_sfp03,'')
#        RETURNING l_sfp01
#   IF NOT cl_null(l_sfp01) THEN
#      LET g_cnt = 0
#      SELECT COUNT(*) INTO g_cnt FROM sfp_file WHERE sfp01 = l_sfp01
#      IF g_cnt > 0 THEN
#         LET g_process_msg[l_ac].sfp01[l_ac3] = l_sfp01
#      END IF
#   END IF
#END FUNCTION
#
##處理icaout
#FUNCTION p046_icaout(p_type)
#   DEFINE p_type      LIKE type_file.chr1      #1.multi die    2.down grade   3.一般
#   DEFINE l_sql       STRING
#   DEFINE l_cnt       LIKE type_file.num10
#   DEFINE l_imaicd08 LIKE imaicd_file.imaicd08,
#          l_ima906    LIKE ima_file.ima906
#   DEFINE l_idc    RECORD LIKE idc_file.*
#   DEFINE l_idb  RECORD LIKE idb_file.*
#   DEFINE l_qty           LIKE sfa_file.sfa05,
#          l_qty1          LIKE sfa_file.sfa05,
#          l_qty2          LIKE sfa_file.sfa05,
#          l_bin_temp_qty1 LIKE sfa_file.sfa05,
#          l_bin_temp_qty2 LIKE sfa_file.sfa05
#
#   SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
#    WHERE imaicd00 = g_data[l_ac].rvv31
#
#   #入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
#   IF cl_null(g_data[l_ac].imaicd04) OR
#      g_process[l_ac3].imaicd04 NOT MATCHES '[012]' OR  #入庫料號狀態不為[0-2]
#      cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN    #不須做刻號管理
#      RETURN
#   END IF
#
#   CASE WHEN p_type = '1'  #1.multi die
#             LET l_sql = "SELECT ",l_ac,",'Y',item1,idc05,idc06, ",
#                         "       icf03,icf05,qty1,qty2,'','' ",
#                         "  FROM icout_temp ",
#                         " WHERE item1 = ",l_ac3
#        WHEN p_type = '2'  #2.down grade
#             IF g_process[l_ac3].sfb05 = g_data[l_ac].sfb05 THEN
#                LET l_sql = "SELECT * FROM bin_temp ",
#                            " WHERE item1 = ",l_ac,
#                            "   AND icf05 <> '1' AND ima01 IS NULL",
#                            "   AND sel2 = 'Y' AND qty1 > 0 AND qty2 > 0 "
#             ELSE
#                LET l_sql = "SELECT * FROM bin_temp ",
#                            " WHERE item1 = ",l_ac,
#                            "   AND icf05 = '1' ",
#                            "   AND ima01 ='",g_process[l_ac3].sfb05,"'",
#                            "   AND sel2 = 'Y' AND qty1 > 0 AND qty2 > 0 "
#             END IF
#        WHEN p_type = '3'  #3.一般
#             LET l_sql = "SELECT * FROM bin_temp ",
#                         " WHERE item1 = ",l_ac,
#                         "   AND sel2 = 'Y' AND qty1 > 0 AND qty2 > 0 "
#   END CASE
#   DECLARE bin_temp_cs2 CURSOR FROM l_sql
#   CALL g_idc.clear()
#   LET l_cnt = 1
#   LET g_rec_b2 = 0
#   FOREACH bin_temp_cs2 INTO l_ac,g_idc[l_cnt].*
#     LET l_cnt = l_cnt + 1
#   END FOREACH
#   CALL g_idc.deleteElement(l_cnt)
#   LET g_rec_b2 = l_cnt - 1
#   IF g_rec_b2 = 0 THEN LET g_success = 'N' RETURN END IF
#
#   SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = g_sfs.sfs04
#   LET l_qty1 = 0  LET l_qty2 = 0
#
#   IF p_type = '1' THEN
#      LET l_qty = g_sfb.sfb08
#      FOR l_ac2 = 1 TO g_rec_b2
#          #multi特別處理
#           LET l_bin_temp_qty1 = g_idc[l_ac2].qty1
#           LET l_bin_temp_qty2 = g_idc[l_ac2].qty2
#
#           LET l_qty1 = l_qty1 + g_idc[l_ac2].qty1   #PCS
#           LET l_qty2 = l_qty2 + g_idc[l_ac2].qty2   #die
#
#          #1.產生idb
#           SELECT * INTO l_idc.* FROM idc_file
#            WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
#              AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
#              AND idc05 = g_idc[l_ac2].idc05
#              AND idc06 = g_idc[l_ac2].idc06
#           IF SQLCA.sqlcode = 100 THEN LET g_success = 'N' RETURN END IF
#
#           LET l_idb.idb01 = g_sfs.sfs04          #料件編號
#           LET l_idb.idb02 = g_sfs.sfs07          #倉庫
#           LET l_idb.idb03 = g_sfs.sfs08          #儲位
#           LET l_idb.idb04 = g_sfs.sfs09          #批號
#           LET l_idb.idb05 = l_idc.idc05          #刻號
#           LET l_idb.idb06 = l_idc.idc06          #BIN
#           LET l_idb.idb07 = g_sfp.sfp01          #單據編號
#           LET l_idb.idb08 = g_sfs.sfs02          #單據項次
#           LET l_idb.idb09 = g_sfp.sfp03          #異動日期
#           LET l_idb.idb10 = l_idc.idc08          #庫存數量
#           LET l_idb.idb11 = l_bin_temp_qty1      #出貨數量
#           LET l_idb.idb12 = l_idc.idc07          #單位
#           LET l_idb.idb13 = l_idc.idc09          #母體料號
#           LET l_idb.idb14 = l_idc.idc10          #母批
#           LET l_idb.idb15 = l_idc.idc11          #DATECODE
#           LET l_idb.idb16 = l_bin_temp_qty2      #出貨die數
#           LET l_idb.idb17 = l_idc.idc13          #YIELD
#           LET l_idb.idb18 = l_idc.idc14          #TEST #
#           LET l_idb.idb19 = l_idc.idc15          #DEDUCT
#           LET l_idb.idb20 = l_idc.idc16          #PASSBIN
#           LET l_idb.idb21 = l_idc.idc19          #接單料號
#           LET l_idb.idb25 = l_idc.idc20          #備註
#           LET l_idb.idbplant = g_plant #FUN-980004 add
#           LET l_idb.idblegal = g_legal #FUN-980004 add
#           INSERT INTO idb_file VALUES(l_idb.*)
#           IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
#          #2.押備置idc_file
#           UPDATE idc_file SET idc21 = idc21 + l_bin_temp_qty1
#            WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
#              AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
#              AND idc05 = g_idc[l_ac2].idc05
#              AND idc06 = g_idc[l_ac2].idc06
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              LET g_success = 'N' RETURN
#           END IF
#      END FOR
#
#      #3.回寫參考單位sfs_file
#      IF l_ima906 MATCHES '[13]' THEN
#         #料號為wafer,imaicd04=0-1,用dice數量加總給原將單據的第二單位數量。
#         #料號為wafer,imaicd04=2,同上,但用pass bin
#         IF g_process[l_ac3].imaicd04 MATCHES '[012]' THEN
#            LET g_sfs.sfs35 = l_qty2
#            LET g_sfs.sfs34 = g_sfs.sfs32/g_sfs.sfs35
#         END IF
#         UPDATE sfs_file SET sfs34 = g_sfs.sfs34,
#                             sfs35 = g_sfs.sfs35
#          WHERE sfs01 = g_sfs.sfs01
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <> 1 THEN
#            LET g_success = 'N' RETURN
#         END IF
#      END IF
#   ELSE
#      FOR l_ac2 = 1 TO g_rec_b2
#          #發料參考數量
#           LET l_qty1 = l_qty1 + g_idc[l_ac2].qty1   #PCS
#           LET l_qty2 = l_qty2 + g_idc[l_ac2].qty2   #die
#
#          #1.產生idb
#           SELECT * INTO l_idc.* FROM idc_file
#            WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
#              AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
#              AND idc05 = g_idc[l_ac2].idc05
#              AND idc06 = g_idc[l_ac2].idc06
#           IF SQLCA.sqlcode = 100 THEN LET g_success = 'N' RETURN END IF
#
#           LET l_idb.idb01 = g_sfs.sfs04          #料件編號
#           LET l_idb.idb02 = g_sfs.sfs07          #倉庫
#           LET l_idb.idb03 = g_sfs.sfs08          #儲位
#           LET l_idb.idb04 = g_sfs.sfs09          #批號
#           LET l_idb.idb05 = l_idc.idc05          #刻號
#           LET l_idb.idb06 = l_idc.idc06          #BIN
#           LET l_idb.idb07 = g_sfp.sfp01          #單據編號
#           LET l_idb.idb08 = g_sfs.sfs02          #單據項次
#           LET l_idb.idb09 = g_sfp.sfp03          #異動日期
#           LET l_idb.idb10 = l_idc.idc08          #庫存數量
#           LET l_idb.idb11 = g_idc[l_ac2].qty1    #出貨數量
#           LET l_idb.idb12 = l_idc.idc07          #單位
#           LET l_idb.idb13 = l_idc.idc09          #母體料號
#           LET l_idb.idb14 = l_idc.idc10          #母批
#           LET l_idb.idb15 = l_idc.idc11          #DATECODE
#           LET l_idb.idb16 = g_idc[l_ac2].qty2    #出貨die數
#           LET l_idb.idb17 = l_idc.idc13          #YIELD
#           LET l_idb.idb18 = l_idc.idc14          #TEST #
#           LET l_idb.idb19 = l_idc.idc15          #DEDUCT
#           LET l_idb.idb20 = l_idc.idc16          #PASSBIN
#           LET l_idb.idb21 = l_idc.idc19          #接單料號
#           LET l_idb.idb25 = l_idc.idc20          #備註
#           LET l_idb.idbplant = g_plant #FUN-980004 add
#           LET l_idb.idblegal = g_legal #FUN-980004 add
#           INSERT INTO idb_file VALUES(l_idb.*)
#           IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
#          #2.押備置idc_file
#           UPDATE idc_file SET idc21 = idc21+g_idc[l_ac2].qty1
#            WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
#              AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
#              AND idc05 = g_idc[l_ac2].idc05
#              AND idc06 = g_idc[l_ac2].idc06
#           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#              LET g_success = 'N' RETURN
#           END IF
#      END FOR
#
#      #3.回寫參考單位sfs_file
#      IF l_ima906 MATCHES '[13]' THEN
#         #料號為wafer,imaicd04=0-1,用dice數量加總給原將單據的第二單位數量。
#         #料號為wafer,imaicd04=2,同上,但用pass bin
#         IF g_process[l_ac3].imaicd04 MATCHES '[012]' THEN
#            LET g_sfs.sfs35 = l_qty2
#            LET g_sfs.sfs34 = g_sfs.sfs32/g_sfs.sfs35
#         END IF
#         UPDATE sfs_file SET sfs34 = g_sfs.sfs34,
#                             sfs35 = g_sfs.sfs35
#          WHERE sfs01 = g_sfs.sfs01
#         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <> 1 THEN
#            LET g_success = 'N' RETURN
#         END IF
#      END IF
#   END IF
#
#END FUNCTION
#
##multi特別處理
#FUNCTION p046_icout_temp_gen()
#   DEFINE l_cnt LIKE type_file.num5
#   DEFINE l_qty           LIKE sfa_file.sfa05,
#          l_qty1          LIKE sfa_file.sfa05,
#          l_qty2          LIKE sfa_file.sfa05,
#          l_bin_temp_qty1 LIKE sfa_file.sfa05,
#          l_bin_temp_qty2 LIKE sfa_file.sfa05
#
#   DECLARE icout_temp_cs CURSOR FOR
#    SELECT * FROM bin_temp
#     WHERE item1 = l_ac AND sel2 = 'Y' AND qty1 > 0 AND qty2 > 0
#     ORDER BY item2
#
#   CALL g_idc.clear()
#   LET l_cnt = 1
#   LET g_rec_b2 = 0
#   FOREACH icout_temp_cs INTO l_ac,g_idc[l_cnt].*
#     LET l_cnt = l_cnt + 1
#   END FOREACH
#   CALL g_idc.deleteElement(l_cnt)
#   LET g_rec_b2 = l_cnt - 1
#   IF g_rec_b2 = 0 THEN LET g_success = 'N' RETURN END IF
#
#   LET l_qty1 = 0  LET l_qty2 = 0
#
#   LET l_qty = g_process[l_ac3].sfb08
#   FOR l_ac2 = 1 TO g_rec_b2
#       #multi特別處理
#       IF l_qty <= 0 THEN EXIT FOR END IF
#       IF g_idc[l_ac2].qty2 = 0 THEN CONTINUE FOR END IF
#
#       IF g_idc[l_ac2].qty2 <= l_qty THEN
#          LET l_bin_temp_qty1 = g_idc[l_ac2].qty1
#          LET l_bin_temp_qty2 = g_idc[l_ac2].qty2
#
#          LET l_qty  = l_qty - l_bin_temp_qty2
#          LET l_qty1 = l_qty1 + l_bin_temp_qty1        #PCS
#          LET l_qty2 = l_qty2 + l_bin_temp_qty2        #die
#       ELSE
#          LET l_bin_temp_qty2 = l_qty
#          LET l_bin_temp_qty1 = (l_bin_temp_qty2 * g_idc[l_ac2].qty1)/
#                                 g_idc[l_ac2].qty2
#          LET l_qty = 0
#          LET l_qty1 = l_qty1 + l_bin_temp_qty1        #PCS
#          LET l_qty2 = l_qty2 + l_bin_temp_qty2        #die
#       END IF
#
#       UPDATE bin_temp SET qty1 = qty1 - l_bin_temp_qty1,
#                           qty2 = qty2 - l_bin_temp_qty2
#        WHERE item1= l_ac AND item2 = g_idc[l_ac2].item
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          LET g_success = 'N' RETURN
#       END IF
#
#       INSERT INTO icout_temp
#            VALUES(l_ac3,g_idc[l_ac2].idc05,g_idc[l_ac2].idc06,
#                   '','',l_bin_temp_qty1,l_bin_temp_qty2)
#       IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
#   END FOR
#   SELECT SUM(qty1) INTO g_process[l_ac3].sfbiicd06 FROM icout_temp
#    WHERE item1 = l_ac3
#END FUNCTION
#
#FUNCTION  p046_chk_idc(p_ac)
#  DEFINE p_ac   LIKE type_file.num5
#  DEFINE l_flag LIKE type_file.num5
#  DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
#  DEFINE l_qty       LIKE idc_file.idc08
#  DEFINE l_imaicd08 LIKE imaicd_file.imaicd08
#
#  LET l_flag = 1
#
#  CALL p046_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01
#
#  SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
#   WHERE imaicd00 = g_data[p_ac].rvv31
#
#  #入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
#  IF cl_null(g_data[p_ac].imaicd04) OR
#     g_data[p_ac].imaicd04 NOT MATCHES '[012]' OR   #入庫料號狀態不為[0-2]
#     cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN  #不須做刻號管理
#     DELETE FROM bin_temp WHERE item1 = p_ac
#     RETURN l_flag
#  END IF
#
#  #bin_temp有勾選的數量加總要等於生產應發數量
#  CASE WHEN l_ecdicd01 MATCHES '[346]'
#            SELECT SUM(qty2) INTO l_qty FROM bin_temp
#             WHERE item1 = p_ac AND sel2 = 'Y'
#       OTHERWISE
#            SELECT SUM(qty1) INTO l_qty FROM bin_temp
#             WHERE item1 = p_ac AND sel2 = 'Y'
#  END CASE
#  IF cl_null(l_qty) THEN LET l_qty = 0 END IF
#
#  #刻號數量與生產發料數量不同
#  IF l_qty <> g_data[p_ac].sfb08 THEN
#     CALL cl_getmsg('aic-142',g_lang) RETURNING g_process_msg[p_ac].rvv_msg
#     LET l_flag = 0 RETURN l_flag
#  END IF
#
#  #若料件狀態為2 且資料有任一筆為DG但未維護料號
#  IF g_data[p_ac].imaicd04 = '2' THEN
#     LET g_cnt = 0
#     SELECT COUNT(*) INTO g_cnt FROM bin_temp
#      WHERE item1 = p_ac AND sel2 = 'Y'
#        AND icf05 = '1'
#        AND (ima01 IS NULL OR ima01 = ' ')
#     IF g_cnt > 0 THEN
#        CALL cl_getmsg('aic-138',g_lang) RETURNING g_process_msg[p_ac].rvv_msg
#        LET l_flag = 0 RETURN l_flag
#     END IF
#
#     IF l_ecdicd01 MATCHES '[456]' THEN
#        LET g_cnt = 0
#        SELECT COUNT(*) INTO g_cnt FROM bin_temp
#           WHERE item1 = p_ac AND sel2 = 'Y'
#             AND icf05 = '1'
#             AND (sfbiicd08_b IS NULL OR sfbiicd08_b = ' ')
#        IF g_cnt > 0 THEN
#           #尚有資料為Down grade,須維護產品型號但尚未維護!
#           CALL cl_getmsg('aic-138',g_lang)
#                RETURNING g_process_msg[p_ac].rvv_msg
#           LET l_flag = 0 RETURN l_flag
#        END IF
#      END IF
#  END IF
#
#  RETURN l_flag
#END FUNCTION
#
#
##-----------------------------------------------------------------------------#
##--------------------------------列印執行後結果-------------------------------#
##-----------------------------------------------------------------------------#
#FUNCTION p046_out()
#DEFINE
#   l_i        LIKE type_file.num5,
#   sr         RECORD
#               rvv01    LIKE rvv_file.rvv01,           #入庫單號
#               rvv02    LIKE rvv_file.rvv02,           #入庫項次
#               rvv_msg  LIKE occ_file.occ1012,         #入庫資訊
#
#               sfb01    LIKE sfb_file.sfb01,           #工單單號
#               sfb04    LIKE sfb_file.sfb04,           #工單狀態
#               sfb87    LIKE sfb_file.sfb87,           #工單確認否
#
#               pmm01    LIKE sfb_file.sfb01,           #採購單號
#               pmm18    LIKE pmm_file.pmm18,           #採購資訊
#
#               sfp01    LIKE sfs_file.sfs01,           #發料單號
#               sfp04    LIKE sfp_file.sfp04            #扣帳否
#              END RECORD,
#   l_name     LIKE type_file.chr20,
#   l_za05     LIKE za_file.za05
#
#   CALL cl_outnam('aicp046') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#
#   START REPORT p046_rep TO l_name
#
#   FOR l_ac = 1 to g_process_msg.getLength()
#      INITIALIZE sr.* TO NULL
#      IF g_data[l_ac].sel = 'N' THEN CONTINUE FOR END IF
#      LET sr.rvv01   = g_process_msg[l_ac].rvv01
#      LET sr.rvv02   = g_process_msg[l_ac].rvv02
#      LET sr.rvv_msg = g_process_msg[l_ac].rvv_msg
#      FOR l_ac3 = 1 TO g_process_msg[l_ac].sfb01.getLength()
#          LET sr.sfb01   = g_process_msg[l_ac].sfb01[l_ac3]
#          IF NOT cl_null(sr.sfb01) THEN
#             SELECT sfb04,sfb87 INTO sr.sfb04,sr.sfb87 FROM sfb_file
#              WHERE sfb01 = sr.sfb01
#          END IF
#
#          LET sr.pmm01   = g_process_msg[l_ac].pmm01[l_ac3]
#          IF NOT cl_null(sr.pmm01) THEN
#             SELECT pmm18 INTO sr.pmm18 FROM pmm_file
#              WHERE pmm01 = sr.pmm01
#          END IF
#
#          LET sr.sfp01   = g_process_msg[l_ac].sfp01[l_ac3]
#          IF NOT cl_null(sr.sfp01) THEN
#             SELECT sfp04 INTO sr.sfp04 FROM sfp_file
#              WHERE sfp01 = sr.sfp01
#          END IF
#          OUTPUT TO REPORT p046_rep(sr.*)
#      END FOR
#      IF g_process_msg[l_ac].sfb01.getLength() = 0 THEN
#         OUTPUT TO REPORT p046_rep(sr.*)
#      END IF
#   END FOR
#
#   FINISH REPORT p046_rep
#
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT p046_rep(sr)
#DEFINE
#   sr         RECORD
#               rvv01    LIKE rvv_file.rvv01,           #入庫單號
#               rvv02    LIKE rvv_file.rvv02,           #入庫項次
#               rvv_msg  LIKE occ_file.occ1012,         #入庫資訊
#
#               sfb01    LIKE sfb_file.sfb01,           #工單單號
#               sfb04    LIKE sfb_file.sfb04,           #工單狀態
#               sfb87    LIKE sfb_file.sfb87,           #工單確認否
#
#               pmm01    LIKE sfb_file.sfb01,           #採購單號
#               pmm18    LIKE pmm_file.pmm18,           #採購單確認否
#
#               sfp01    LIKE sfs_file.sfs01,           #發料單號
#               sfp04    LIKE sfp_file.sfp04            #扣帳否
#              END RECORD,
#   l_trailer_sw    LIKE type_file.chr1,
#   l_i             LIKE type_file.num5
#
#  OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN 0
#      BOTTOM MARGIN 6
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.rvv01,sr.rvv02
#   FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,
#                   g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED,pageno_total
#      PRINT g_dash[1,g_len]
#      LET l_trailer_sw = 'y'
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#            g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#      PRINT g_dash1
#   ON EVERY ROW
#      PRINT COLUMN g_c[31],sr.rvv01 CLIPPED,
#            COLUMN g_c[32],cl_numfor(sr.rvv02 CLIPPED,4,0),  #TQC-940015
#
#            COLUMN g_c[33],sr.sfb01 CLIPPED,
#            COLUMN g_c[34],sr.sfb04 CLIPPED,
#            COLUMN g_c[35],sr.sfb87 CLIPPED,
#
#            COLUMN g_c[36],sr.pmm01 CLIPPED,
#            COLUMN g_c[37],sr.pmm18 CLIPPED,
#
#            COLUMN g_c[38],sr.sfp01 CLIPPED,
#            COLUMN g_c[39],sr.sfp04 CLIPPED,
#
#            COLUMN g_c[40],sr.rvv_msg CLIPPED
#
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_trailer_sw = 'n'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#   PAGE TRAILER
#       IF l_trailer_sw = 'y' THEN
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#       ELSE
#           SKIP 2 LINE
#       END IF
#END REPORT
#
##-----------------------------------------------------------------------------#
##-----------------------------------建立table---------------------------------#
##-----------------------------------------------------------------------------#
#FUNCTION p046_create_bin_temp()
#  DROP TABLE bin_temp
#  CREATE TEMP TABLE bin_temp (
#    item1         LIKE type_file.num5,
#    sel2          LIKE type_file.chr1,
#    item2         LIKE type_file.num5,
#    idc05         LIKE idc_file.idc05,
#    idc06         LIKE idc_file.idc06,
#    icf03         LIKE icf_file.icf03,
#    icf05         LIKE icf_file.icf05,
#    qty1          LIKE idc_file.idc08,
#    qty2          LIKE idc_file.idc08,
#    ima01         LIKE ima_file.ima01,
#    ima02         LIKE ima_file.ima02,
#    sfbiicd08_b   LIKE ima_file.ima021);
#  IF SQLCA.SQLCODE THEN
#    CALL cl_err('cretmp',SQLCA.SQLCODE,1) 
#    EXIT PROGRAM
#  END IF
#END FUNCTION
#
#FUNCTION p046_create_icout_temp()
#  DROP TABLE icout_temp
#  CREATE TEMP TABLE icout_temp (
#    item1         LIKE type_file.num5,
#    idc05         LIKE idc_file.idc05,
#    idc06         LIKE idc_file.idc06,
#    icf03         LIKE icf_file.icf03,
#    icf05         LIKE type_file.chr1,
#    qty1          LIKE idc_file.idc08,
#    qty2          LIKE idc_file.idc08);
#  IF SQLCA.SQLCODE THEN
#    CALL cl_err('cretmp',SQLCA.SQLCODE,1) 
#    EXIT PROGRAM
#  END IF
#END FUNCTION
#
#FUNCTION p046_def_idc(p_ac,p_ac2)
#  DEFINE p_ac,p_ac2  LIKE type_file.num5
#
#  #在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
#  #抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
#  #當生產料號與產品型號的預設值
#  #(生產料號/產品型號為空白時,才需做此預設動作)
#  IF g_idc[p_ac2].sel2 = 'Y' AND
#     g_data[p_ac].imaicd04 = '2' AND
#     g_idc[p_ac2].icf05 = '1' THEN
#
#     IF cl_null(g_idc[p_ac2].ima01) THEN
#        #預設down grade工單之生產料號
#        DECLARE sel_icm02 CURSOR FOR
#           SELECT icm02
#             FROM icm_file,ima_file
#            WHERE ima01 = icm01
#              AND icm01 = g_data[p_ac].rvv31  #入庫料號
#              AND icm02 <> g_data[p_ac].sfb05 #下階料
#              AND icmacti = 'Y'
#        FOREACH sel_icm02 INTO g_idc[p_ac2].ima01
#           EXIT FOREACH
#        END FOREACH
#     END IF
#     IF cl_null(g_idc[p_ac2].sfbiicd08_b) THEN
#        #預設down grade工單之產品型號
#        DECLARE sel_ick02 CURSOR FOR
#           SELECT ick02
#             FROM ick_file,ima_file
#            WHERE ima01 = ick02
#              AND ick01 = g_data[p_ac].sfbiicd14     #母體料號
#              AND ick02 <> g_data[p_ac].sfbiicd08    #產品型號
#              AND ickacti = 'Y'
#        FOREACH sel_ick02 INTO g_idc[p_ac2].sfbiicd08_b
#           EXIT FOREACH
#        END FOREACH
#     END IF
#  END IF
#  RETURN g_idc[p_ac2].ima01,g_idc[p_ac2].sfbiicd08_b
#END FUNCTION
#FUN-A30027--end--mark-----
 
#檢查單價,除6.TKY外,其它單價不可為0
FUNCTION p046_chk_price()
    DEFINE l_flag      LIKE type_file.num5,
           l_ecdicd01 LIKE ecd_file.ecdicd01,
           l_pmn31     LIKE pmn_file.pmn31,
           l_pmn31t    LIKE pmn_file.pmn31t,
           l_pmm21     LIKE pmm_file.pmm21,
           l_pmm22     LIKE pmm_file.pmm22,
           l_pmm43     LIKE pmm_file.pmm43,
           l_ecb06     LIKE ecb_file.ecb06,
           l_imaicd01  LIKE imaicd_file.imaicd01,
           l_ima908    LIKE ima_file.ima908,
           l_pmn86     LIKE pmn_file.pmn86,
           l_ima44     LIKE ima_file.ima44,  #FUN-910077
           l_ima31     LIKE ima_file.ima31,  #FUN-910077
           l_price_unit  LIKE ima_file.ima908,   #FUN-910077
           l_pmc17     LIKE pmc_file.pmc17,    #No.FUN-930148 
           l_pmc49     LIKE pmc_file.pmc49,    #No.FUN-930148  
           l_pmn73     LIKE pmn_file.pmn73,    #TQC-AC0257
           l_pmn74     LIKE pmn_file.pmn74,    #TQC-AC0257     
           l_pnz08     LIKE pnz_file.pnz08     #FUN-C50107
 
    LET l_flag = 1
 
    CALL p046sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01 #FUN-A30027
    IF NOT cl_null(g_pmm22) THEN
       LET l_pmm22 = g_pmm22
    ELSE
       SELECT pmc22 INTO l_pmm22 FROM pmc_file
        WHERE pmc01 = g_data[l_ac].sfb82
    END IF
     SELECT pmc47,pmc17,pmc49 INTO l_pmm21,l_pmc17,l_pmc49 FROM pmc_file   #No.FUN-930148
     WHERE pmc01 = g_data[l_ac].sfb82
 
    IF SQLCA.SQLCODE THEN
       LET l_pmm43 = 0
    ELSE
       IF cl_null(l_pmm43) THEN LET l_pmm43 = 0 END IF
    END IF
    
    SELECT rvv86 INTO l_pmn86
      FROM rvv_file
     WHERE rvv01=g_data[l_ac].rvv01
       AND rvv02=g_data[l_ac].rvv02
    CASE WHEN l_ecdicd01 = '2' OR l_ecdicd01 = '3'
              #1 若料號之作業群組 = '2.CP' or '3.DS' ,
              #  則採購單價以母體料號取價,
              #FUN-C30305---begin mark
              #IF g_sma.sma841 = '8' THEN #依Body取價  #FUN-980033
              #SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file
              # WHERE imaicd00 = g_data[l_ac].sfb05
              #ELSE                                    #FUN-980033
              #FUN-C30305---end
              LET l_imaicd01 = g_data[l_ac].sfb05  #FUN-980033
              #END IF                                  #FUN-980033  #FUN-C30305 mark
              SELECT ima908,ima44,ima31 INTO l_ima908,l_ima44,l_ima31 
                                        FROM ima_file
                                       WHERE ima01=l_imaicd01
              CASE g_sma.sma116
                 WHEN "0"
                    LET l_price_unit =  l_ima44
                 WHEN "1"
                    LET l_price_unit =  l_ima44
                 WHEN "2"
                    LET l_price_unit =  l_ima31
                 WHEN "3"
                    LET l_price_unit =  l_ima908
              END CASE
 
              CALL s_defprice_new(l_imaicd01,g_data[l_ac].sfb82,l_pmm22,  #TQC-9B0214
                              g_pmm04,g_data[l_ac].sfb08,
                              g_data[l_ac].sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_price_unit,'',l_pmc49,l_pmc17,g_plant)  #TQC-9B0214
                  #RETURNING l_pmn31,l_pmn31t                  #TQC-AC0257 mark
                  RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74   #TQC-AC0257 add
              IF NOT cl_null(l_pmn31) AND NOT cl_null(l_pmn31t) AND
                 l_pmn31 > 0 AND l_pmn31t > 0 THEN
                 LET l_flag = 1
              ELSE
                 LET l_flag = 0
              END IF

              #FUN-C30305---begin
              IF l_flag = 0 THEN 
                 SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file
                  WHERE imaicd00 = g_data[l_ac].sfb05

                 SELECT ima908,ima44,ima31 INTO l_ima908,l_ima44,l_ima31 
                                           FROM ima_file
                                          WHERE ima01=l_imaicd01
 
                 CALL s_defprice_new(l_imaicd01,g_data[l_ac].sfb82,l_pmm22,  #TQC-9B0214
                                 g_pmm04,g_data[l_ac].sfb08,
                                 g_data[l_ac].sfbiicd09,l_pmm21,
                                 l_pmm43,'2',l_price_unit,'',l_pmc49,l_pmc17,g_plant)  
                     RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74   
                 IF NOT cl_null(l_pmn31) AND NOT cl_null(l_pmn31t) AND
                    l_pmn31 > 0 AND l_pmn31t > 0 THEN
                    LET l_flag = 1
                 ELSE
                    LET l_flag = 0
                 END IF
              END IF 
              #FUN-C30305---end
 
         WHEN l_ecdicd01 = '4' OR l_ecdicd01 = '5'
              #2 若料號之作業群組 = '4.ASS' or '5.FT' ,
              CALL s_defprice_new(g_data[l_ac].sfbiicd08,g_data[l_ac].sfb82,   #TQC-9B0214
                              l_pmm22,g_pmm04,g_data[l_ac].sfb08,
                              g_data[l_ac].sfbiicd09,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmc49,l_pmc17,g_plant) #TQC-9B0214 
                  #RETURNING l_pmn31,l_pmn31t                  #TQC-AC0257 mark
                  RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74   #TQC-AC0257 add
              IF NOT cl_null(l_pmn31) AND NOT cl_null(l_pmn31t) AND
                 l_pmn31 > 0 AND l_pmn31t > 0 THEN
                 LET l_flag = 1
              ELSE
                 LET l_flag = 0
              END IF
         WHEN l_ecdicd01 = '6'
              LET l_flag = 1
              DECLARE ecb_dec CURSOR FOR
               SELECT ecb06 FROM ecb_file
                WHERE ecb01 = g_data[l_ac].sfb05 
                  AND ecb02 = g_data[l_ac].sfb06
              FOREACH ecb_dec INTO l_ecb06
              CALL s_defprice_new(g_data[l_ac].sfbiicd08,g_data[l_ac].sfb82, #TQC-9B0214
                              l_pmm22,g_pmm04,g_data[l_ac].sfb08,l_ecb06,l_pmm21,
                              l_pmm43,'2',l_pmn86,'',l_pmc49,l_pmc17,g_plant)  #TQC-9B0214  
                  #RETURNING l_pmn31,l_pmn31t                   #TQC-AC0257 mark
                  RETURNING l_pmn31,l_pmn31t,l_pmn73,l_pmn74   #TQC-AC0257 add
                IF cl_null(l_pmn31) OR cl_null(l_pmn31t) OR
                   l_pmn31 <= 0 OR l_pmn31t <= 0 THEN
                   LET l_flag = 0 EXIT FOREACH
                END IF
              END FOREACH
         OTHERWISE
              LET l_flag = 1
    END CASE
    #FUN-C50107---begin
    SELECT pnz08 INTO l_pnz08
      FROM pnz_file
     WHERE pnz01 = l_pmc49
    IF cl_null(l_pnz08) THEN LET l_pnz08 = 'Y' END IF 
    IF l_pnz08 = 'Y' THEN 
       LET l_flag = 1
    ELSE 
    #FUN-C50107---end
       IF l_flag = 0 THEN
          IF l_ecdicd01 = '6' THEN
             CALL cl_err('','aic-140',1)
          ELSE
             CALL cl_err('','aic-139',1)  #委外要到apmi264維護,非委外-apmi254
          END IF
       END IF
    END IF  #FUN-C50107
    RETURN l_flag
END FUNCTION
 
#No.FUN-9C0072 精簡程式碼

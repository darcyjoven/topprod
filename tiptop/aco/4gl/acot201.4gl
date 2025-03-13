# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acot201.4gl
# Descriptions...: 模擬合同進口材料資料維護作業
# Date & Author..: 03/04/14 By Carrier
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0248 04/10/19 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/27 By Carrier
# Modify.........: No.FUN-550100 05/05/25 By ching 特性BOM功能修改
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# Modify.........: No.TQC-660113 06/06/26 By Rayven s_ins_cnj()抓取cob資料時，分開查找，避免多選數據 
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/14 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/05/08 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-8B0035 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: NO.FUN-AA0059 10/10/59 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0084 11/12/16 By lixh1 增加數量欄位單位取位
# Modify.........: NO.TQC-C20183 12/02/15 By fengrui 數量欄位小數取位處理
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_cng           RECORD LIKE cng_file.*,       #單頭
    g_cng_t         RECORD LIKE cng_file.*,       #單頭(舊值)
    g_cng_o         RECORD LIKE cng_file.*,       #單頭(舊值)
    g_cng01_t       LIKE cng_file.cng01,          #單頭 (舊值)
    g_t1            LIKE cob_file.cob04,          #No.FUN-680069  VARCHAR(03)
    g_cnj           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        cnj02       LIKE cnj_file.cnj02,   #項次
        cnj03       LIKE cnj_file.cnj03,   #商品編號
        ima02       LIKE ima_file.ima02,   #
        cnj05       LIKE cnj_file.cnj05,   #
        cnj06       LIKE cnj_file.cnj06,   #
        #FUN-840202 --start---
        cnjud01     LIKE cnj_file.cnjud01,
        cnjud02     LIKE cnj_file.cnjud02,
        cnjud03     LIKE cnj_file.cnjud03,
        cnjud04     LIKE cnj_file.cnjud04,
        cnjud05     LIKE cnj_file.cnjud05,
        cnjud06     LIKE cnj_file.cnjud06,
        cnjud07     LIKE cnj_file.cnjud07,
        cnjud08     LIKE cnj_file.cnjud08,
        cnjud09     LIKE cnj_file.cnjud09,
        cnjud10     LIKE cnj_file.cnjud10,
        cnjud11     LIKE cnj_file.cnjud11,
        cnjud12     LIKE cnj_file.cnjud12,
        cnjud13     LIKE cnj_file.cnjud13,
        cnjud14     LIKE cnj_file.cnjud14,
        cnjud15     LIKE cnj_file.cnjud15
        #FUN-840202 --end--
                    END RECORD,
    g_cnj_t         RECORD                 #程式變數 (舊值)
        cnj02       LIKE cnj_file.cnj02,   #項次
        cnj03       LIKE cnj_file.cnj03,   #商品編號
        ima02       LIKE ima_file.ima02,   #
        cnj05       LIKE cnj_file.cnj05,   #
        cnj06       LIKE cnj_file.cnj06,   #
        #FUN-840202 --start---
        cnjud01     LIKE cnj_file.cnjud01,
        cnjud02     LIKE cnj_file.cnjud02,
        cnjud03     LIKE cnj_file.cnjud03,
        cnjud04     LIKE cnj_file.cnjud04,
        cnjud05     LIKE cnj_file.cnjud05,
        cnjud06     LIKE cnj_file.cnjud06,
        cnjud07     LIKE cnj_file.cnjud07,
        cnjud08     LIKE cnj_file.cnjud08,
        cnjud09     LIKE cnj_file.cnjud09,
        cnjud10     LIKE cnj_file.cnjud10,
        cnjud11     LIKE cnj_file.cnjud11,
        cnjud12     LIKE cnj_file.cnjud12,
        cnjud13     LIKE cnj_file.cnjud13,
        cnjud14     LIKE cnj_file.cnjud14,
        cnjud15     LIKE cnj_file.cnjud15
        #FUN-840202 --end--
                    END RECORD,
    g_cnj_o         RECORD                 #程式變數 (舊值)
        cnj02       LIKE cnj_file.cnj02,   #項次
        cnj03       LIKE cnj_file.cnj03,   #商品編號
        ima02       LIKE ima_file.ima02,   #
        cnj05       LIKE cnj_file.cnj05,   #
        cnj06       LIKE cnj_file.cnj06,   #
        #FUN-840202 --start---
        cnjud01     LIKE cnj_file.cnjud01,
        cnjud02     LIKE cnj_file.cnjud02,
        cnjud03     LIKE cnj_file.cnjud03,
        cnjud04     LIKE cnj_file.cnjud04,
        cnjud05     LIKE cnj_file.cnjud05,
        cnjud06     LIKE cnj_file.cnjud06,
        cnjud07     LIKE cnj_file.cnjud07,
        cnjud08     LIKE cnj_file.cnjud08,
        cnjud09     LIKE cnj_file.cnjud09,
        cnjud10     LIKE cnj_file.cnjud10,
        cnjud11     LIKE cnj_file.cnjud11,
        cnjud12     LIKE cnj_file.cnjud12,
        cnjud13     LIKE cnj_file.cnjud13,
        cnjud14     LIKE cnj_file.cnjud14,
        cnjud15     LIKE cnj_file.cnjud15
        #FUN-840202 --end--
                    END RECORD,
    g_argv1         LIKE cnj_file.cnj01,        # 詢價單號
     g_wc,g_wc2,g_sql    STRING,  #No.FUN-580092 HCN        #No.FUN-680069
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680069 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_sl            LIKE type_file.num5         #No.FUN-680069  SMALLINT       #目前處理的SCREEN LINE
  DEFINE g_vdate    LIKE type_file.dat          #No.FUN-680069  DATE 
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE   g_before_input_done LIKE type_file.num5               #No.FUN-680069 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10          #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10          #No.FUN-680069 INTEGER
 
DEFINE   g_jump         LIKE type_file.num10          #No.FUN-680069 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680069 SMALLINT
MAIN
DEFINE
    p_row,p_col     LIKE type_file.num5              #No.FUN-680069 SMALLINT
#       l_time    LIKE type_file.chr8            #No.FUN-6A0063
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
    LET g_argv1 = ARG_VAL(1)               #參數-1(詢價單號)
 
    LET g_forupd_sql = " SELECT * FROM cng_file WHERE cng01 =? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t201_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW t201_w AT p_row,p_col
        WITH FORM "aco/42f/acot201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
    IF g_argv1 IS NOT NULL AND g_argv1 != ' '
    THEN CALL t201_q()
    END IF
    CALL t201_menu()
    CLOSE WINDOW t201_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
#QBE 查詢資料
FUNCTION t201_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_cnj.clear()
 
  IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
     LET g_wc = " cng01 = '",g_argv1,"'"
     LET g_wc2=" 1=1"
  ELSE
     CALL cl_set_head_visible("","YES")    #No.FUN-6B0033
   INITIALIZE g_cng.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
          cng01,cng12,cng03,cng04,cng10,cng05,cng06,cng07, #No.MOD-490398
          cngconf,cnguser,cnggrup,cngmodu,cngdate,cngacti,
          #FUN-840202   ---start---
          cngud01,cngud02,cngud03,cngud04,cngud05,
          cngud06,cngud07,cngud08,cngud09,cngud10,
          cngud11,cngud12,cngud13,cngud14,cngud15
          #FUN-840202    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
     ON ACTION controlp
            CASE
                #No.MOD-490398
               #WHEN INFIELD(cng02) #幣別
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.state ="c"
               #     LET g_qryparam.form ="q_azi"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
               #     DISPLAY g_qryparam.multiret TO cng02
               #     NEXT FIELD cng02
               WHEN INFIELD(cng12)  #customer
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_cna"
                 LET g_qryparam.default1 = g_cng.cng12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cng12
                 NEXT FIELD cng12
                #No.MOD-490398 end
                #--No.MOD-4A0248
               WHEN INFIELD(cng01) #模擬編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_cng"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cng01
                    NEXT FIELD cng01
              #-----END--------
              OTHERWISE EXIT CASE
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
     CONSTRUCT g_wc2 ON cnj02,cnj03,cnj05,cnj06 #螢幕上取單身條件
               #No.FUN-840202 --start--
               ,cnjud01,cnjud02,cnjud03,cnjud04,cnjud05
               ,cnjud06,cnjud07,cnjud08,cnjud09,cnjud10
               ,cnjud11,cnjud12,cnjud13,cnjud14,cnjud15
               #No.FUN-840202 ---end---
             FROM s_cnj[1].cnj02,s_cnj[1].cnj03,s_cnj[1].cnj05,s_cnj[1].cnj06
                  #No.FUN-840202 --start--
                  ,s_cnj[1].cnjud01,s_cnj[1].cnjud02,s_cnj[1].cnjud03
                  ,s_cnj[1].cnjud04,s_cnj[1].cnjud05,s_cnj[1].cnjud06
                  ,s_cnj[1].cnjud07,s_cnj[1].cnjud08,s_cnj[1].cnjud09
                  ,s_cnj[1].cnjud10,s_cnj[1].cnjud11,s_cnj[1].cnjud12
                  ,s_cnj[1].cnjud13,s_cnj[1].cnjud14,s_cnj[1].cnjud15
                  #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
               WHEN INFIELD(cnj03) #料件編號
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.state ="c"
                 #   LET g_qryparam.form ="q_ima"
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO cnj03
                    NEXT FIELD cnj03
               WHEN INFIELD(cnj06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnj06
                    NEXT FIELD cnj06
               OTHERWISE EXIT CASE
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
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
 
     IF INT_FLAG THEN RETURN END IF
  END IF
  #資料權限的檢查
  #Begin:FUN-980030
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #     LET g_wc = g_wc clipped," AND cnguser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #     LET g_wc = g_wc clipped," AND cnggrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #     LET g_wc = g_wc clipped," AND cnggrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cnguser', 'cnggrup')
  #End:FUN-980030
 
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT cng01 FROM cng_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY cng01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE cng01 ",
                   "  FROM cng_file, cnj_file ",
                   " WHERE cng01 = cnj01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY cng01"
    END IF
 
    PREPARE t201_prepare FROM g_sql
    DECLARE t201_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t201_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM cng_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM cng_file,cnj_file WHERE ",
                  "cnj01=cng01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t201_precount FROM g_sql
    DECLARE t201_count CURSOR FOR t201_precount
END FUNCTION
 
FUNCTION t201_menu()
   DEFINE   l_cmd   LIKE gbc_file.gbc05        #No.FUN-680069 VARCHAR(100)
 
 
 
   WHILE TRUE
      CALL t201_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t201_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t201_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t201_u()
            END IF
          WHEN "invalid" #No.MOD-490398
            IF cl_chk_act_auth() THEN
               CALL t201_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cnj),'','')
             END IF
         #--
 
         WHEN "gen_imports"
            IF cl_chk_act_auth() AND
               g_cng.cng01 IS NOT NULL AND g_cng.cngacti = 'Y' THEN
               CALL s_ins_cnj()
               CALL t201_show()
            END IF
         WHEN "query_exports"
            IF cl_chk_act_auth() THEN
               LET l_cmd="acot200 '",g_cng.cng01,"'"
               #CALL cl_cmdrun(l_cmd)      #FUN-660216 remark
               CALL cl_cmdrun_wait(l_cmd)  #FUN-660216 add
            END IF
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cng.cng01 IS NOT NULL THEN
                 LET g_doc.column1 = "cng01"
                 LET g_doc.value1 = g_cng.cng01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t201_i(p_cmd)
DEFINE
    l_pmc05   LIKE pmc_file.pmc05,
    l_pmc30   LIKE pmc_file.pmc30,
    l_n       LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    p_cmd     LIKE type_file.chr1           #a:輸入 u:更改        #No.FUN-680069 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033
    INPUT BY NAME
        g_cng.cng01,g_cng.cng10,g_cng.cng12,g_cng.cng03,g_cng.cng04,   #No.MOD-490398
        g_cng.cng05,g_cng.cng06,g_cng.cng07,g_cng.cngconf,g_cng.cnguser,
        g_cng.cnggrup,g_cng.cngmodu,g_cng.cngdate,g_cng.cngacti,
        #FUN-840202     ---start---
        g_cng.cngud01,g_cng.cngud02,g_cng.cngud03,g_cng.cngud04,
        g_cng.cngud05,g_cng.cngud06,g_cng.cngud07,g_cng.cngud08,
        g_cng.cngud09,g_cng.cngud10,g_cng.cngud11,g_cng.cngud12,
        g_cng.cngud13,g_cng.cngud14,g_cng.cngud15 
        #FUN-840202     ----end----
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t201_set_entry(p_cmd)
            CALL t201_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD cng01
            IF NOT cl_null(g_cng.cng01) THEN
               IF g_cng.cng01 != g_cng01_t OR g_cng01_t IS NULL THEN
                   SELECT count(*) INTO l_n FROM cng_file
                       WHERE cng01 = g_cng.cng01
                   IF l_n > 0 THEN   #單據編號重複
                       CALL cl_err(g_cng.cng01,-239,0)
                       LET g_cng.cng01 = g_cng01_t
                       DISPLAY BY NAME g_cng.cng01
                       NEXT FIELD cng01
                   END IF
	       END IF
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD cngud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cngud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 #MOD-490398  --begin
#        ON ACTION controlp #ok
#            CASE
#               WHEN INFIELD(cng02) #幣別
#                    CALL cl_init_qry_var()
#                    LET g_qryparam.form ="q_azi"
#                    LET g_qryparam.default1 = g_cng.cng02
#                    CALL cl_create_qry() RETURNING g_cng.cng02
#                    CALL FGL_DIALOG_SETBUFFER( g_cng.cng02 )
 #                    DISPLAY BY NAME g_cng.cng02          #No.MOD-490371
#                    NEXT FIELD cng02
#              OTHERWISE EXIT CASE
#            END CASE
 #MOD-490398  --end
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t201_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1           #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("cng01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t201_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cng01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t201_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cng.* TO NULL               #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_cnj.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t201_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_cng.* TO NULL
        RETURN
    END IF
    OPEN t201_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_cng.* TO NULL
    ELSE
        OPEN t201_count
        FETCH t201_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t201_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t201_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680069 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680069 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t201_cs INTO g_cng.cng01
        WHEN 'P' FETCH PREVIOUS t201_cs INTO g_cng.cng01
        WHEN 'F' FETCH FIRST    t201_cs INTO g_cng.cng01
        WHEN 'L' FETCH LAST     t201_cs INTO g_cng.cng01
        WHEN '/'
 
         IF (NOT mi_no_ask) THEN
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
             PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
             END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
 
         END IF
         FETCH ABSOLUTE g_jump t201_cs INTO g_cng.cng01
         LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)
        INITIALIZE g_cng.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01 = g_cng.cng01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cng_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1) #TQC-660045
        INITIALIZE g_cng.* TO NULL
        RETURN
    END IF
    CALL t201_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t201_show()
    LET g_cng_t.* = g_cng.*                #保存單頭舊值
    LET g_cng_o.* = g_cng.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
 
        g_cng.cng01,g_cng.cng12,g_cng.cng03,g_cng.cng04,g_cng.cng05, #No.MOD-490398
        g_cng.cng06,g_cng.cng07,g_cng.cng10,g_cng.cngconf,g_cng.cnguser,
        g_cng.cnggrup,g_cng.cngmodu,g_cng.cngdate,g_cng.cngacti,
        #FUN-840202     ---start---
        g_cng.cngud01,g_cng.cngud02,g_cng.cngud03,g_cng.cngud04,
        g_cng.cngud05,g_cng.cngud06,g_cng.cngud07,g_cng.cngud08,
        g_cng.cngud09,g_cng.cngud10,g_cng.cngud11,g_cng.cngud12,
        g_cng.cngud13,g_cng.cngud14,g_cng.cngud15 
        #FUN-840202     ----end----
    CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)
 
    CALL t201_b_fill(g_wc2)                   #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#撤銷整筆 (所有合乎單頭的資料)
FUNCTION t201_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0)
        RETURN
    END IF
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'9021',0)
        RETURN
    END IF
    IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
       g_cng.cng05 < g_today THEN
       CALL cl_err(g_cng.cng04,'aco-060',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t201_cl USING g_cng.cng01
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_cng.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t201_cl
        RETURN
    END IF
    CALL t201_show()
    IF cl_delh(0,0) THEN                   #審核一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cng01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cng.cng01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM cnj_file WHERE cnj01 = g_cng.cng01
         CLEAR FORM
         CALL g_cnj.clear()
 
         OPEN t201_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t201_cs
            CLOSE t201_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t201_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t201_cs
            CLOSE t201_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t201_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t201_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t201_fetch('/')
         END IF
    END IF
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t201_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT      #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用             #No.FUN-680069 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用             #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否             #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態               #No.FUN-680069 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否               #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否               #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01=g_cng.cng01
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0)
        RETURN
    END IF
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'9023',0)
        RETURN
    END IF
    IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
       g_cng.cng05 < g_today THEN
       CALL cl_err(g_cng.cng01,'aco-060',0) RETURN
    END IF
 
    LET g_success='Y'
    CALL cl_opmsg('b')
    LET g_forupd_sql = "SELECT cnj02,cnj03,'',cnj05,cnj06, ",
                       #No.FUN-840202 --start--
                       "       cnjud01,cnjud02,cnjud03,cnjud04,cnjud05,",
                       "       cnjud06,cnjud07,cnjud08,cnjud09,cnjud10,",
                       "       cnjud11,cnjud12,cnjud13,cnjud14,cnjud15 ", 
                       #No.FUN-840202 ---end---
                       "  FROM cnj_file ",
                       " WHERE cnj01=? AND cnj02=? ",
                       "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
 
        IF g_rec_b=0 THEN CALL g_cnj.clear() END IF
 
        INPUT ARRAY g_cnj WITHOUT DEFAULTS FROM s_cnj.*
 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t201_cl USING g_cng.cng01
            IF STATUS THEN
               CALL cl_err("OPEN t201_cl:", STATUS, 1)
               CLOSE t201_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t201_cl INTO g_cng.*            # 鎖住將被更改或撤銷的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t201_cl
               RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cnj_t.* = g_cnj[l_ac].*           #No.MOD-490398
                LET g_cnj_o.cnj06 = g_cnj[l_ac].cnj06   #FUN-BB0084
                OPEN t201_bcl USING g_cng.cng01,g_cnj_t.cnj02
                IF STATUS THEN
                   CALL cl_err("OPEN t201_bcl:", STATUS, 1)
                   CLOSE t201_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t201_bcl INTO g_cnj[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cnj_t.cnj02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                    CALL t201_cnj03('a')  #No.MOD-490398
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #NEXT FIELD cnj02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO cnj_file(cnj01,cnj02,cnj03,cnj05,cnj06,
                                 #FUN-840202 --start--
                                 cnjud01,cnjud02,cnjud03,cnjud04,cnjud05,
                                 cnjud06,cnjud07,cnjud08,cnjud09,cnjud10,
                                 #cnjud11,cnjud12,cnjud13,cnjud14,cnjud15) #FUN-980002
                                 #FUN-840202 --end--
                                 cnjud11,cnjud12,cnjud13,cnjud14,cnjud15,  #FUN-980002
                                 cnjplant,cnjlegal) #FUN-980002
            VALUES(g_cng.cng01,g_cnj[l_ac].cnj02,g_cnj[l_ac].cnj03,
                   g_cnj[l_ac].cnj05,g_cnj[l_ac].cnj06,
                   #FUN-840202 --start--
                   g_cnj[l_ac].cnjud01,g_cnj[l_ac].cnjud02,g_cnj[l_ac].cnjud03,
                   g_cnj[l_ac].cnjud04,g_cnj[l_ac].cnjud05,g_cnj[l_ac].cnjud06,
                   g_cnj[l_ac].cnjud07,g_cnj[l_ac].cnjud08,g_cnj[l_ac].cnjud09,
                   g_cnj[l_ac].cnjud10,g_cnj[l_ac].cnjud11,g_cnj[l_ac].cnjud12,
                   #g_cnj[l_ac].cnjud13,g_cnj[l_ac].cnjud14,g_cnj[l_ac].cnjud15) #FUN-980002
                   #FUN-840202 --end--
                   g_cnj[l_ac].cnjud13,g_cnj[l_ac].cnjud14,g_cnj[l_ac].cnjud15,  #FUN-980002
                   g_plant,g_legal)  #FUN-980002
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cnj[l_ac].cnj02,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","cnj_file",g_cng.cng01,g_cnj[l_ac].cnj02,SQLCA.sqlcode,"","",1) #TQC-660045
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   CALL cl_rbmsg(1) ROLLBACK WORK
                END IF
                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_cnj[l_ac].* TO NULL
            LET g_cnj[l_ac].cnj05 = 0        #Body default
            LET g_cnj_t.* = g_cnj[l_ac].*         #新輸入資料
            LET g_cnj_o.* = g_cnj[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cnj02
 
        BEFORE FIELD cnj02                        #default 序號
            IF g_cnj[l_ac].cnj02 IS NULL OR g_cnj[l_ac].cnj02 = 0 THEN
                SELECT max(cnj02)+1
                   INTO g_cnj[l_ac].cnj02
                   FROM cnj_file
                   WHERE cnj01 = g_cng.cng01
                IF g_cnj[l_ac].cnj02 IS NULL THEN
                    LET g_cnj[l_ac].cnj02 = 1
                END IF
#               DISPLAY g_cnj[l_ac].cnj02 TO s_cnj[l_sl].cnj02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD cnj02                        #check 序號是否重複
            IF NOT cl_null(g_cnj[l_ac].cnj02) THEN
               IF g_cnj[l_ac].cnj02 != g_cnj_t.cnj02 OR
                  g_cnj_t.cnj02 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM cnj_file
                       WHERE cnj01 = g_cng.cng01 AND
                             cnj02 = g_cnj[l_ac].cnj02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_cnj[l_ac].cnj02 = g_cnj_t.cnj02
                       NEXT FIELD cnj02
                   END IF
               END IF
            END IF
 
        AFTER FIELD cnj03
            LET l_n = 0
            IF NOT cl_null(g_cnj[l_ac].cnj03) THEN
               #FUN-AA0059 -----------------------add start---------------------------
               IF NOT s_chk_item_no(g_cnj[l_ac].cnj03,'') THEN
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD cnj03
               END IF 
               #FUN-AA0059 -----------------------add end---------------------
               IF g_cnj_t.cnj03 IS NULL OR g_cnj_t.cnj03 <> g_cnj[l_ac].cnj03
               THEN
                  SELECT COUNT(*) INTO l_n FROM cnj_file #不能重復
                   WHERE cnj01 = g_cng.cng01
                     AND cnj03 = g_cnj[l_ac].cnj03
                  IF l_n > 0 THEN
                     CALL cl_err(g_cnj[l_ac].cnj03,-239,0)
                     NEXT FIELD cnj03
                  END IF
               END IF
            END IF
             #No.MOD-490398  --begin
            IF NOT cl_null(g_cnj[l_ac].cnj03) THEN
              #-->check 是否存在海關商品檔
              IF p_cmd = 'a' OR (p_cmd ='u' AND
                 g_cnj[l_ac].cnj03 != g_cnj_o.cnj03) THEN
                   SELECT COUNT(*) INTO l_n FROM coa_file,cob_file #海關料號
                    WHERE coa01 = g_cnj[l_ac].cnj03
                      AND coa03 = cob01
                   IF l_n <= 0 THEN
                        CALL cl_err(g_cnj[l_ac].cnj03,'aco-001',0)
                        LET g_cnj[l_ac].cnj03 = g_cnj_t.cnj03
                        NEXT FIELD cnj03
                   ELSE
                      LET l_n = 0
                      SELECT COUNT(*) INTO l_n FROM bmb_file  #原料
                       WHERE bmb03 = g_cnj[l_ac].cnj03
                      IF l_n = 0 THEN
                         CALL cl_err(g_cnj[l_ac].cnj03,'mfg2602',2)
                         LET g_cnj[l_ac].cnj03 = g_cnj_t.cnj03
                         NEXT FIELD cnj03
                      END IF
                   END IF
                   CALL t201_cnj03('a')
              END IF
            END IF
            LET g_cnj_o.cnj03 = g_cnj[l_ac].cnj03
             #No.MOD-490398  end
 
         AFTER FIELD cnj05      #No.MOD-490398
         #FUN-BB0084 ------Begin--------
            IF NOT t201_cnj05_chk() THEN
               NEXT FIELD cnj05
            END IF
         #FUN-BB0084 ------End----------
         #FUN-BB0084 -------------Begin--------------
         #  IF cl_null(g_cnj[l_ac].cnj05) OR g_cnj[l_ac].cnj05 <=0 THEN
         #     LET g_cnj[l_ac].cnj05 = g_cnj_t.cnj05
         #     DISPLAY g_cnj[l_ac].cnj05 TO cnj05
         #     NEXT FIELD cnj05
         #  END IF
         #FUN-BB0084 -------------End----------------
 
        AFTER FIELD cnj06
            IF NOT cl_null(g_cnj[l_ac].cnj06) THEN
               CALL t201_cnj06('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_cnj[l_ac].cnj06 = g_cnj_t.cnj06
                   DISPLAY g_cnj[l_ac].cnj06 TO cnj06           #No.MOD-490398
                  CALL cl_err(g_cnj[l_ac].cnj06,g_errno,0)
                  NEXT FIELD cnj06
               END IF
            #FUN-BB0084 ----------Begin-------------
               IF NOT cl_null(g_cnj[l_ac].cnj05) AND g_cnj[l_ac].cnj05<>0 THEN  #TQC-C20183
                  IF NOT t201_cnj05_chk() THEN 
                     LET g_cnj_o.cnj06 = g_cnj[l_ac].cnj06
                     NEXT FIELD cnj05
                  END IF
               END IF                                                           #TQC-C20183
               LET g_cnj_o.cnj06 = g_cnj[l_ac].cnj06   
            #FUN-BB0084 ----------End--------------- 
            END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD cnjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cnjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
        BEFORE DELETE                            #是否撤銷單身
            IF g_cnj_t.cnj02 > 0 AND
               g_cnj_t.cnj02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cnj_file
                    WHERE cnj01 = g_cng.cng01 AND
                          cnj02 = g_cnj_t.cnj02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cnj_t.cnj02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","cnj_file",g_cng.cng01,g_cnj_t.cnj02,SQLCA.sqlcode,"","",1) #TQC-660045
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cnj[l_ac].* = g_cnj_t.*
               CLOSE t201_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cnj[l_ac].cnj02,-263,1)
               LET g_cnj[l_ac].* = g_cnj_t.*
            ELSE
               IF g_cnj[l_ac].cnj03 IS NULL OR
                  g_cnj[l_ac].cnj03 = 0 THEN  #重要欄位空白,無效
                  INITIALIZE g_cnj[l_ac].* TO NULL
                  DISPLAY BY NAME g_cnj[l_ac].*
               END IF
               UPDATE cnj_file SET cnj02= g_cnj[l_ac].cnj02,
                                   cnj03= g_cnj[l_ac].cnj03,
                                   cnj05= g_cnj[l_ac].cnj05,
                                   cnj06= g_cnj[l_ac].cnj06,
                                   #FUN-840202 --start--
                                   cnjud01 = g_cnj[l_ac].cnjud01,
                                   cnjud02 = g_cnj[l_ac].cnjud02,
                                   cnjud03 = g_cnj[l_ac].cnjud03,
                                   cnjud04 = g_cnj[l_ac].cnjud04,
                                   cnjud05 = g_cnj[l_ac].cnjud05,
                                   cnjud06 = g_cnj[l_ac].cnjud06,
                                   cnjud07 = g_cnj[l_ac].cnjud07,
                                   cnjud08 = g_cnj[l_ac].cnjud08,
                                   cnjud09 = g_cnj[l_ac].cnjud09,
                                   cnjud10 = g_cnj[l_ac].cnjud10,
                                   cnjud11 = g_cnj[l_ac].cnjud11,
                                   cnjud12 = g_cnj[l_ac].cnjud12,
                                   cnjud13 = g_cnj[l_ac].cnjud13,
                                   cnjud14 = g_cnj[l_ac].cnjud14,
                                   cnjud15 = g_cnj[l_ac].cnjud15
                                   #FUN-840202 --end-- 
               WHERE cnj01=g_cng.cng01 AND cnj02=g_cnj_t.cnj02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cnj[l_ac].cnj02,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","cnj_file",g_cng.cng01,g_cnj[l_ac].cnj02,SQLCA.sqlcode,"","",1) #TQC-660045
                   LET g_cnj[l_ac].* = g_cnj_t.*
                   DISPLAY BY NAME g_cnj[l_ac].*
               ELSE
                   IF g_success='Y' THEN
                      COMMIT WORK
                   ELSE
                      CALL cl_rbmsg(1) ROLLBACK WORK
                   END IF
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               IF p_cmd='u' THEN
                  LET g_cnj[l_ac].* = g_cnj_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cnj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE t201_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add 
          #LET g_cnj_t.* = g_cnj[l_ac].*          # 900423
            CLOSE t201_bcl
            COMMIT WORK
 
           #CALL g_cnj.deleteElement(g_rec_b+1)    #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cnj02) AND l_ac > 1 THEN
                LET g_cnj[l_ac].* = g_cnj[l_ac-1].*
                DISPLAY BY NAME g_cnj[l_ac].*
                NEXT FIELD cnj02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp #ok2
            CASE
               WHEN INFIELD(cnj03) #料件編號
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form ="q_ima"
                 #   LET g_qryparam.default1 = g_cnj[l_ac].cnj03
                 #   CALL cl_create_qry() RETURNING g_cnj[l_ac].cnj03
                     CALL q_sel_ima(FALSE, "q_ima", "", g_cnj[l_ac].cnj03, "", "", "", "" ,"",'' )  RETURNING g_cnj[l_ac].cnj03
#FUN-AA0059 --End--
#                    CALL FGL_DIALOG_SETBUFFER( g_cnj[l_ac].cnj03 )
                     DISPLAY g_cnj[l_ac].cnj03 TO cnj03           #No.MOD-490371
                    NEXT FIELD cnj03
               WHEN INFIELD(cnj06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_cnj[l_ac].cnj06
                    CALL cl_create_qry() RETURNING g_cnj[l_ac].cnj06
#                    CALL FGL_DIALOG_SETBUFFER( g_cnj[l_ac].cnj06 )
                    DISPLAY BY NAME g_cnj[l_ac].cnj06
                    NEXT FIELD cnj06
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
    CLOSE t201_bcl
    COMMIT WORK
END FUNCTION
 
#FUN-BB0084 -------------Begin--------------
FUNCTION t201_cnj05_chk() 
   IF cl_null(g_cnj[l_ac].cnj05) OR g_cnj[l_ac].cnj05 <=0 THEN
      LET g_cnj[l_ac].cnj05 = g_cnj_t.cnj05
      DISPLAY g_cnj[l_ac].cnj05 TO cnj05
      RETURN FALSE 
   END IF
   IF NOT cl_null(g_cnj[l_ac].cnj05) AND NOT cl_null(g_cnj[l_ac].cnj06) THEN
      IF cl_null(g_cnj_o.cnj06) OR cl_null(g_cnj_t.cnj05) OR g_cnj_o.cnj06 ! = g_cnj[l_ac].cnj06
         OR g_cnj_t.cnj05 ! = g_cnj[l_ac].cnj05 THEN
         LET g_cnj[l_ac].cnj05 = s_digqty(g_cnj[l_ac].cnj05,g_cnj[l_ac].cnj06)
         DISPLAY BY NAME g_cnj[l_ac].cnj06
      END IF 
   END IF 
   RETURN TRUE
END FUNCTION
#FUN-BB0084 -------------End----------------

 #No.MOD-490398  --begin
FUNCTION t201_cnj03(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_cnj06   LIKE cnj_file.cnj06,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima25,imaacti
      INTO g_cnj[l_ac].ima02,l_cnj06,l_imaacti
      FROM ima_file WHERE ima01 = g_cnj[l_ac].cnj03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aco-001'
                                   LET g_cnj[l_ac].ima02 = ' '
                                   LET l_cnj06 = ' '
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
 #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 #FUN-690022------mod-------
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_cnj[l_ac].cnj06) THEN LET g_cnj[l_ac].cnj06=l_cnj06 END IF
#FUN-BB0084 -------------Begin--------------
    IF NOT cl_null(g_cnj[l_ac].cnj05) THEN
       LET g_cnj[l_ac].cnj05 = s_digqty(g_cnj[l_ac].cnj05,g_cnj[l_ac].cnj06)
       DISPLAY BY NAME g_cnj[l_ac].cnj05
       DISPLAY BY NAME g_cnj[l_ac].cnj06   
    END IF  
#FUN-BB0084 -------------End----------------
END FUNCTION
 #No.MOD-490398  --end
 
FUNCTION t201_cnj06(p_cmd)  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
          p_cmd      LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_cnj[l_ac].cnj06
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t201_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(200) 
 
    CONSTRUCT l_wc2 ON cnj02,cnj03,cnj05,cnj06
                       #No.FUN-840202 --start--
                       ,cnjud01,cnjud02,cnjud03,cnjud04,cnjud05
                       ,cnjud06,cnjud07,cnjud08,cnjud09,cnjud10
                       ,cnjud11,cnjud12,cnjud13,cnjud14,cnjud15
                       #No.FUN-840202 ---end---
         FROM s_cnj[1].cnj02,s_cnj[1].cnj03,s_cnj[1].cnj05,s_cnj[1].cnj06
              #No.FUN-840202 --start--
              ,s_cnj[1].cnjud01,s_cnj[1].cnjud02,s_cnj[1].cnjud03
              ,s_cnj[1].cnjud04,s_cnj[1].cnjud05,s_cnj[1].cnjud06
              ,s_cnj[1].cnjud07,s_cnj[1].cnjud08,s_cnj[1].cnjud09
              ,s_cnj[1].cnjud10,s_cnj[1].cnjud11,s_cnj[1].cnjud12
              ,s_cnj[1].cnjud13,s_cnj[1].cnjud14,s_cnj[1].cnjud15
              #No.FUN-840202 ---end---
         #No.MOD-490398  --begin
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
               WHEN INFIELD(cnj03) #料件編號
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.state ="c"
                  #  LET g_qryparam.form ="q_ima"
                  #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret 
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO cnj03
                    NEXT FIELD cnj03
               WHEN INFIELD(cnj06) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.state ="c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO cnj06
                    NEXT FIELD cnj06
               OTHERWISE EXIT CASE
            END CASE
         #No.MOD-490398  --end
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t201_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t201_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(200)
 
    LET g_sql =
        "SELECT cnj02,cnj03,ima02,cnj05,cnj06, ",
        #No.FUN-840202 --start--
        "       cnjud01,cnjud02,cnjud03,cnjud04,cnjud05,",
        "       cnjud06,cnjud07,cnjud08,cnjud09,cnjud10,",
        "       cnjud11,cnjud12,cnjud13,cnjud14,cnjud15 ", 
        #No.FUN-840202 ---end---
        "  FROM cnj_file LEFT OUTER JOIN ima_file ON cnj_file.cnj03 = ima_file.ima01",
        " WHERE cnj01 ='",g_cng.cng01,"'",  #單頭
    #No.FUN-8B0123---Begin
        "   AND cnj03=ima01 "               #AND ", p_wc2 CLIPPED, #單身
    #   " ORDER BY 1,2"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE t201_pb FROM g_sql
    DECLARE cnj_cs                       #SCROLL CURSOR
        CURSOR FOR t201_pb
    CALL g_cnj.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    FOREACH cnj_cs INTO g_cnj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_cnj.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cnj TO s_cnj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t201_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t201_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t201_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t201_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t201_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION invalid             #No.MOD-490398
          LET g_action_choice="invalid" #No.MOD-490398
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 產生進口材料
      ON ACTION gen_imports
         LET g_action_choice="gen_imports"
         EXIT DISPLAY
      #@ON ACTION 出口成品資料查詢
      ON ACTION query_exports
         LET g_action_choice="query_exports"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
      LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t201_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'9021',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t201_cl USING g_cng.cng01
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_cng.*               # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)          #資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
    CALL t201_show()
    IF cl_exp(0,0,g_cng.cngacti) THEN                   #審核一下
        LET g_chr=g_cng.cngacti
        IF g_cng.cngacti='Y' THEN
            LET g_cng.cngacti='N'
        ELSE
            LET g_cng.cngacti='Y'
        END IF
        UPDATE cng_file                    #更改有效碼
            SET cngacti=g_cng.cngacti
            WHERE cng01=g_cng.cng01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0) #No.TQC-660045
           CALL cl_err3("upd","cng_file",g_cng.cng01,"",SQLCA.sqlcode,"","",1) #TQC-660045
           LET g_cng.cngacti=g_chr
        END IF
        DISPLAY BY NAME g_cng.cngacti
    END IF
    CLOSE t201_cl
    COMMIT WORK
 
 
    CALL cl_set_field_pic(g_cng.cngconf,"","","","",g_cng.cngacti)
 
END FUNCTION
 
FUNCTION t201_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cng.cng01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cng.* FROM cng_file WHERE cng01=g_cng.cng01
    IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'mfg1000',0)
        RETURN
    END IF
    IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_cng.cng01,'9022',0)
        RETURN
    END IF
    IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
       g_cng.cng05 < g_today THEN
       CALL cl_err(g_cng.cng01,'aco-060',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cng01_t = g_cng.cng01
    BEGIN WORK
 
    OPEN t201_cl USING g_cng.cng01
    IF STATUS THEN
       CALL cl_err("OPEN t201_cl:", STATUS, 1)
       CLOSE t201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t201_cl INTO g_cng.*            # 鎖住將被更改或撤銷的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t201_cl
        RETURN
    END IF
    CALL t201_show()
    WHILE TRUE
        LET g_cng01_t = g_cng.cng01
        LET g_cng_o.* = g_cng.*
        LET g_cng.cngmodu=g_user
        LET g_cng.cngdate=g_today
        CALL t201_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cng.*=g_cng_t.*
            CALL t201_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_cng.cng01 != g_cng01_t THEN            # 更改單號
            UPDATE cnh_file SET cnh01 = g_cng.cng01
                WHERE cnh01 = g_cng01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('cnh',SQLCA.sqlcode,0)  #No.TQC-660045
                CALL cl_err3("upd","cnh_file",g_cng01_t,"",SQLCA.sqlcode,"","cnh",1) #TQC-660045
                CONTINUE WHILE
            END IF
        END IF
        UPDATE cng_file SET cng_file.* = g_cng.*
            WHERE cng01 = g_cng01_t
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_cng.cng01,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cng_file",g_cng01_t,"",SQLCA.sqlcode,"","",1) #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t201_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION s_ins_cnj()
  DEFINE l_cnh03 LIKE cnh_file.cnh03
  DEFINE l_cnh05 LIKE cnh_file.cnh05
  DEFINE l_bmb06 LIKE bmb_file.bmb06
  DEFINE l_bmb03 LIKE bmb_file.bmb03
  DEFINE l_cnh06 LIKE cnh_file.cnh06       #No.MOD-493098
  DEFINE l_ima55 LIKE ima_file.ima55       #No.MOD-493098
  DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550100
  DEFINE l_fac   LIKE bmb_file.bmb10_fac   #No.MOD-490398
  DEFINE l_sw    LIKE type_file.chr1       #No.FUN-680069 VARCHAR(1)       #No.MOD-490398
  DEFINE l_i     LIKE type_file.num5       #No.FUN-680069 SMALLINT
  DEFINE l_ima25 LIKE ima_file.ima25
  DEFINE l_n     LIKE type_file.num5       #No.TQC-660113               #No.FUN-680069 SMALLINT
 
  IF s_shut(0) THEN RETURN END IF
  IF g_cng.cng01 IS NULL THEN
      CALL cl_err("",-400,0) RETURN
  END IF
  IF g_cng.cngacti ='N' THEN    #檢查資料是否為無效
     CALL cl_err(g_cng.cng01,'mfg1000',0) RETURN
  END IF
  IF g_cng.cngconf ='Y' THEN    #檢查資料是否為無效
     CALL cl_err(g_cng.cng01,'9023',0) RETURN
  END IF
  IF (NOT cl_null(g_cng.cng07) AND g_cng.cng07 < g_today) OR
     g_cng.cng05 < g_today THEN
     CALL cl_err(g_cng.cng04,'aco-060',0) RETURN
  END IF
  SELECT COUNT(*) INTO l_i FROM cnj_file WHERE cnj01 = g_cng.cng01
  IF l_i > 0 THEN
     IF NOT cl_confirm('aco-003') THEN RETURN END IF
  END IF
  LET g_vdate      = g_today
  DROP TABLE t201_temp
#No.FUN-680069-begin
  CREATE TEMP TABLE t201_temp (
         level1 LIKE bmb_file.bmb02,
         bmb02  LIKE bmb_file.bmb02,
         bmb03  LIKE bmb_file.bmb03,
         bmb06  LIKE bmb_file.bmb06,
         bmb08  LIKE bmb_file.bmb08,
         bmb10  LIKE bmb_file.bmb10,
         bma01  LIKE bma_file.bma01)
#No.FUN-680069-end
  IF SQLCA.sqlcode THEN
     CALL cl_err('create tmp',STATUS,0) RETURN
  END IF
   #No.MOD-490398
  DECLARE t201_cnh_cur CURSOR FOR
          SELECT cnh03,cnh05,cnh06 FROM cnh_file  #,coa_file,cob_file #No.TQC-660113 MARK
           WHERE cnh01 = g_cng.cng01
#            AND cnh03 = coa01  #No.TQC-660113 MARK
#            AND cob01 = coa03  #No.TQC-660113 MAKR
   #No.MOD-490398 END
   #No.MOD-490398  --begin
  FOREACH t201_cnh_cur INTO l_cnh03,l_cnh05,l_cnh06
      IF SQLCA.sqlcode THEN
         CALL cl_err(l_cnh03,SQLCA.sqlcode,0) EXIT FOREACH
      END IF
      #No.TQC-660113 --start--
      SELECT COUNT(*) INTO l_n
        FROM coa_file,cob_file
       WHERE coa01 = l_cnh03
         AND cob01 = coa03
      IF l_n = 0 THEN
         CONTINUE FOREACH
      END IF
      #No.TQC-660113 --end--
      SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=l_cnh03
      IF cl_null(l_ima55) THEN
         CALL cl_err('ima55',SQLCA.sqlcode,0)
         LET l_ima55=l_cnh06
      END IF
      LET l_fac = 1
      IF l_ima55 !=l_cnh06 THEN
         CALL s_umfchk(l_cnh03,l_cnh06,l_ima55)
              RETURNING l_sw, l_fac    #單位換算
         IF l_sw  = '1'  THEN #有問題
            CALL cl_err(l_cnh03,'abm-731',1)
            LET l_fac = 1
         END IF
      END IF
      LET l_cnh05=l_cnh05*l_fac
       #No.MOD-490398  --end
      #FUN-550100
      LET l_ima910=''
      SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=l_cnh03
      IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
      #--
      CALL t201_bom(0,l_cnh03,l_ima910,l_cnh05)   #FUN-550100
  END FOREACH
 
  DECLARE t201_temp_cur CURSOR FOR
          SELECT bmb03,SUM(bmb06) FROM t201_temp
           GROUP BY bmb03
           ORDER BY bmb03
  IF SQLCA.sqlcode THEN
     CALL cl_err('t201_temp_cur',STATUS,0) RETURN
  END IF
 
  BEGIN WORK
  LET g_success = 'Y'
  DELETE FROM cnj_file WHERE cnj01 = g_cng.cng01
  LET l_i = 1
  FOREACH t201_temp_cur INTO l_bmb03,l_bmb06
      IF SQLCA.sqlcode THEN
         CALL cl_err(l_cnh03,SQLCA.sqlcode,0)
         LET g_success = 'N' EXIT FOREACH
      END IF
   #No.MOD-490398  --begin
      SELECT ima25,ima55 INTO l_ima25,l_ima55 FROM ima_file
       WHERE ima01 = l_bmb03
      LET l_fac = 1
      IF l_ima55 !=l_ima25 THEN
         CALL s_umfchk(l_bmb03,l_ima55,l_ima25)
              RETURNING l_sw, l_fac    #單位換算
         IF l_sw  = '1'  THEN #有問題
            CALL cl_err(l_bmb03,'abm-731',1)
            LET l_fac = 1
         END IF
      END IF
      LET l_bmb06=l_bmb06*l_fac
      LET l_bmb06=s_digqty(l_bmb06,l_ima25)   #FUN-BB0084
   #No.MOD-490398  --end
      INSERT INTO cnj_file(cnj01,cnj02,cnj03,cnj05,cnj06,cnjplant,cnjlegal) #FUN-980002 add cnjplant,cnjlegal
                    VALUES(g_cng.cng01,l_i,l_bmb03,l_bmb06,l_ima25,g_plant,g_legal) #FUN-980002 add g_plant,g_legal
      IF SQLCA.sqlcode THEN
#        CALL cl_err('ins cnj',STATUS,0) #No.TQC-660045
         CALL cl_err3("ins","cnj_file",g_cng.cng01,l_i,STATUS,"","ins",1) #TQC-660045
         LET g_success = 'N' EXIT FOREACH
      END IF
      LET l_i = l_i + 1
  END FOREACH
  IF g_success='Y' THEN
     COMMIT WORK CALL cl_cmmsg(1)
  ELSE
     ROLLBACK WORK CALL cl_rbmsg(1)
  END IF
  CALL t201_show()
END FUNCTION
 
FUNCTION t201_bom(p_level,p_key,p_key2,p_total)    #FUN-550100
   DEFINE p_level       LIKE type_file.num5,       #No.FUN-680069  SMALLINT
          p_key         LIKE bma_file.bma01,       #主件料件編號
          p_key2	LIKE ima_file.ima910,      #FUN-550100
         #p_total       DECIMAL(13,5),
          p_total       LIKE bmb_file.bmb06,       #FUN-560227
          l_ac,i,l_n    LIKE type_file.num5,       #No.FUN-680069 SMALLINT
          arrno         LIKE type_file.num5,       #No.FUN-680069 SMALLINT      #BUFFER SIZE (可存筆數)
          l_chr         LIKE type_file.chr1,       #No.FUN-680069 VARCHAR(1)
   #No.MOD-490398  --begin
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              level1 LIKE type_file.num5,         #No.FUN-680069 SMALLINT
              bmb02  LIKE bmb_file.bmb02,    #項次
              bmb03  LIKE bmb_file.bmb03,    #元件料號
              bmb06  LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08  LIKE bmb_file.bmb08,    #損耗率
              bmb10  LIKE bmb_file.bmb10,    #發料單位
              bma01  LIKE bma_file.bma01
          END RECORD,
          l_cmd   LIKE type_file.chr1000       #No.FUN-680069  VARCHAR(1000)
   DEFINE l_ima55 LIKE ima_file.ima55
   DEFINE l_fac   LIKE bmb_file.bmb10_fac
   DEFINE l_sw    LIKE type_file.chr1          #No.FUN-680069  VARCHAR(1) 
   #No.MOD-490398  --end
   DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0035 
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
    END IF
    LET p_level = p_level + 1
    LET arrno = 600                     #95/12/21 Modify By Lynn
     #No.MOD-490398  --begin
    LET l_cmd= "SELECT 0, bmb02, bmb03, (bmb06/bmb07),bmb08,bmb10, bma01",
               "  FROM bmb_file LEFT OUTER JOIN bma_file ON bmb_file.bmb03 = bma_file.bma01",
               " WHERE bmb01='", p_key,"' " ,
               "   AND bmb29 ='",p_key2,"' "  #FUN-550100
    #---->生效日及失效日的判斷
     LET l_cmd=l_cmd CLIPPED,
               " AND (bmb04 <='",g_today,"' OR bmb04 IS NULL)",
               " AND (bmb05 > '",g_today,"' OR bmb05 IS NULL)"
    LET l_cmd = l_cmd CLIPPED, ' ORDER BY bmb02'
     #No.MOD-490398  --end
    PREPARE t201_precur FROM l_cmd
    IF SQLCA.sqlcode THEN
       CALL cl_err('P1:',STATUS,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
    END IF
    DECLARE t201_cur CURSOR FOR t201_precur
    LET l_ac = 1
    FOREACH t201_cur INTO sr[l_ac].*    # 先將BOM單身存入BUFFER
       IF SQLCA.sqlcode THEN
          CALL cl_err('',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       #FUN-8B0035--BEGIN--                                                                                                    
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
       #FUN-8B0035--END--
       LET l_ac = l_ac + 1
       IF l_ac > arrno THEN LET g_success = 'N' EXIT FOREACH END IF
    END FOREACH
    FOR i = 1 TO l_ac-1                         # 讀BUFFER傳給REPORT
        LET sr[i].level1= p_level
         #No.MOD-490398  by carrier
        LET l_fac = 1
        SELECT ima55 INTO l_ima55 FROM ima_file WHERE ima01=sr[i].bmb03
        IF l_ima55 !=sr[i].bmb10 THEN
           CALL s_umfchk(sr[i].bmb03,sr[i].bmb10,l_ima55)
                 RETURNING l_sw, l_fac    #單位換算
           IF l_sw  = '1'  THEN #有問題
              CALL cl_err(sr[i].bmb03,'abm-731',1)
              LET l_fac = 1
           END IF
        END IF
        LET sr[i].bmb06=p_total*sr[i].bmb06*l_fac
         #No.MOD-490398  end
        IF sr[i].bma01 IS NOT NULL THEN                 #若為主件
          #CALL t201_bom(p_level,sr[i].bmb03,' ',sr[i].bmb06)    #FUN-550100#FUN-8B0035
           CALL t201_bom(p_level,sr[i].bmb03,l_ima910[i],sr[i].bmb06)    #FUN-8B0035
        ELSE
             #No.MOD-490398  begin
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM coa_file,cob_file
             WHERE coa01 = sr[i].bmb03 AND cob01=coa03
             #No.MOD-490398  end
           IF l_n > 0 THEN
              INSERT INTO t201_temp VALUES (sr[i].*)
              IF SQLCA.sqlcode THEN
#                CALL cl_err('ins tmp',STATUS,0)  #No.TQC-660045
                 CALL cl_err3("ins","t201_temp","","",STATUS,"","ins tmp",1) #TQC-660045
                 RETURN
              END IF
           END IF
        END IF
    END FOR
END FUNCTION
#Patch....NO.TQC-610035 <001> #

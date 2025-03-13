# Prog. Version..: '5.30.06-13.04.01(00010)'     #
#
# Pattern name...: abmi602.4gl
# Descriptions...: BOM 變異性資料維護作業
# Date & Author..: 97/12/31 By Kitty
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0054 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-550093 05/05/30 By kim 配方BOM
# Modify.........: No.FUN-560021 05/06/07 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.TQC-660046 06/06/14 By Jackho cl_err-->cl_err3
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能						
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760129 07/06/14 By xufeng 主件編號新增開窗按鈕                                                                               
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.MOD-830198 08/07/04 By Pengu 若單身欄位有打上查詢條件Q出資料後，只顯示單頭資料單身資料無顯示
# Modify.........: No.FUN-880033 08/08/07 By chenyu 在單身中加一個欄位bmb15
# Modify.........: No.TQC-920039 09/02/16 By chenyu curs()中的問題
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:MOD-AB0023 10/11/02 By sabrina CONSTRUCT欄位打錯
# Modify.........: No.MOD-AC0379 10/12/29 By vealxu 增加bmb18的維護(欄位加在單身最後)
# Modify.........: No.MOD-CB0021 12/11/06 By Elise 修正查詢時單頭筆數會誤算
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bma           RECORD LIKE bma_file.*,       #主件料件(假單頭)
    g_bma_t         RECORD LIKE bma_file.*,       #主件料件(舊值)
    g_bma_o         RECORD LIKE bma_file.*,       #主件料件(舊值)
    g_bma01_t       LIKE bma_file.bma01,          #(舊值)
    g_bmb10_fac_t   LIKE bmb_file.bmb10_fac,      #(舊值)
    g_ima08_h       LIKE ima_file.ima08,   #來源碼
    g_ima37_h       LIKE ima_file.ima37,   #補貨政策
    g_ima08_b       LIKE ima_file.ima08,   #來源碼
    g_ima37_b       LIKE ima_file.ima37,   #補貨政策
    g_ima25_b       LIKE ima_file.ima25,   #庫存單位
    g_ima63_b       LIKE ima_file.ima63,   #發料單位
    g_ima70_b       LIKE ima_file.ima63,   #消秏料件
    g_ima86_b       LIKE ima_file.ima86,   #成本單位
    g_ima107_b      LIKE ima_file.ima107,  #LOCATION
    g_bmb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    bmb02 LIKE bmb_file.bmb02,       #元件項次
                    bmb03 LIKE bmb_file.bmb03,       #元件料件
                    ima02_b LIKE ima_file.ima02,     #品名
                    ima021_b LIKE ima_file.ima021,   #規格
                    ima08_b LIKE ima_file.ima08,     #來源
                    bmb10 LIKE bmb_file.bmb10,       #生效日
                    bmb04 LIKE bmb_file.bmb04,       #生效日
                    bmb05 LIKE bmb_file.bmb05,       #失效日
                    bmb06 LIKE bmb_file.bmb06,       #組成用量
                    bmb07 LIKE bmb_file.bmb07,       #底數
                    bmb09 LIKE bmb_file.bmb09,       #作業編號
                    bmb19 LIKE bmb_file.bmb19,       #展開       #bugno:6845 add
                    bmb15 LIKE bmb_file.bmb15,       #消耗料件   #FUN-880033
                    bmb27 LIKE bmb_file.bmb27,       #軟體       #bugno:6845 add
                    bmb18 LIKE bmb_file.bmb18                    #MOD-AC0379 
                    END RECORD,
    g_bmb_t         RECORD                 #程式變數 (舊值)
                    bmb02 LIKE bmb_file.bmb02,       #元件項次
                    bmb03 LIKE bmb_file.bmb03,       #元件料件
                    ima02_b LIKE ima_file.ima02,     #品名
                    ima021_b LIKE ima_file.ima021,   #規格
                    ima08_b LIKE ima_file.ima08,     #來源
                    bmb10 LIKE bmb_file.bmb10,       #生效日
                    bmb04 LIKE bmb_file.bmb04,       #生效日
                    bmb05 LIKE bmb_file.bmb05,       #失效日
                    bmb06 LIKE bmb_file.bmb06,       #組成用量
                    bmb07 LIKE bmb_file.bmb07,       #底數
                    bmb09 LIKE bmb_file.bmb09,       #作業編號
                    bmb19 LIKE bmb_file.bmb19,       #展開       #bugno:6845 add
                    bmb15 LIKE bmb_file.bmb15,       #消耗料件   #FUN-880033
                    bmb27 LIKE bmb_file.bmb27,       #軟體       #bugno:6845 add
                    bmb18 LIKE bmb_file.bmb18                    #MOD-AC0379
                    END RECORD,
    g_bmb_o         RECORD                 #程式變數 (舊值)
                    bmb02 LIKE bmb_file.bmb02,       #元件項次
                    bmb03 LIKE bmb_file.bmb03,       #元件料件
                    ima02_b LIKE ima_file.ima02,     #品名
                    ima021_b LIKE ima_file.ima021,   #規格
                    ima08_b LIKE ima_file.ima08,     #來源
                    bmb10 LIKE bmb_file.bmb10,       #生效日
                    bmb04 LIKE bmb_file.bmb04,       #生效日
                    bmb05 LIKE bmb_file.bmb05,       #失效日
                    bmb06 LIKE bmb_file.bmb06,       #組成用量
                    bmb07 LIKE bmb_file.bmb07,       #底數
                    bmb09 LIKE bmb_file.bmb09,       #作業編號
                    bmb19 LIKE bmb_file.bmb19,       #展開       #bugno:6845 add
                    bmb15 LIKE bmb_file.bmb15,       #消耗料件   #FUN-880033
                    bmb27 LIKE bmb_file.bmb27,       #軟體       #bugno:6845 add
                    bmb18 LIKE bmb_file.bmb18                    #MOD-AC0379
                    END RECORD,
    g_bmb11         LIKE  bmb_file.bmb11,
    g_bmb13         LIKE  bmb_file.bmb13,
    g_bmb23         LIKE  bmb_file.bmb23,
    g_bmb10_fac     LIKE  bmb_file.bmb10_fac,
    g_bmb10_fac2    LIKE  bmb_file.bmb10_fac2,
    g_bmb15         LIKE  bmb_file.bmb15,
    g_bmb18         LIKE  bmb_file.bmb18,
    g_bmb17         LIKE  bmb_file.bmb17,
    g_bmb27         LIKE  bmb_file.bmb27,
    g_bmb20         LIKE  bmb_file.bmb20,
    g_bmb19         LIKE  bmb_file.bmb19,
    g_bmb21         LIKE  bmb_file.bmb21,
    g_bmb22         LIKE  bmb_file.bmb22,
    g_bmb25         LIKE  bmb_file.bmb25,
    g_bmb26         LIKE  bmb_file.bmb26,
    g_bmb11_o       LIKE  bmb_file.bmb11,
    g_bmb13_o       LIKE  bmb_file.bmb13,
    g_bmb23_o       LIKE  bmb_file.bmb23,
    g_bmb25_o       LIKE  bmb_file.bmb23,
    g_bmb26_o       LIKE  bmb_file.bmb23,
    g_bmb10_fac_o   LIKE  bmb_file.bmb10_fac,
    g_bmb10_fac2_o  LIKE  bmb_file.bmb10_fac2,
    g_bmb15_o       LIKE  bmb_file.bmb15,
    g_bmb18_o       LIKE  bmb_file.bmb18,
    g_bmb17_o       LIKE  bmb_file.bmb17,
    g_bmb27_o       LIKE  bmb_file.bmb27,
    g_bmb20_o       LIKE  bmb_file.bmb20,
    g_bmb19_o       LIKE  bmb_file.bmb19,
    g_bmb21_o       LIKE  bmb_file.bmb21,
    g_bmb22_o       LIKE  bmb_file.bmb22,
     g_sql               string,  #No.FUN-580092 HCN
     g_wc,g_wc2          string,  #No.FUN-580092 HCN
    g_vdate         LIKE type_file.dat,    #No.FUN-680096 DATE
    g_sw            LIKE type_file.num5,   #單位是否可轉換 #No.FUN-680096 SMALLINT
    g_factor        LIKE type_file.num20_6,#單位換算率     #No.FUN-680096 DEC(20,6)
    g_cmd           STRING,                #No.FUN-680096
    g_ecd03         LIKE ecd_file.ecd03,
    g_aflag         LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,   #單身筆數     #No.FUN-680096 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_msg        LIKE ze_file.ze03            #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10         #No.FUN-680096 INTEGER
DEFINE   g_no_ask    LIKE type_file.num5          #No.FUN-680096 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql =
       " SELECT * FROM bma_file WHERE bma01 = ? AND bma06 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i602_cl CURSOR FROM g_forupd_sql
 
    CALL s_decl_bmb()
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0060
 
    OPEN WINDOW i602_w WITH FORM "abm/42f/abmi602"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bma06",g_sma.sma118='Y')
 
    CALL i602_menu()
    CLOSE WINDOW i602_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0060
END MAIN
 
 
FUNCTION i602_curs()
DEFINE l_flag      LIKE type_file.chr1     #判斷單身是否給條件    #No.FUN-680096 VARCHAR(1)
DEFINE lc_qbe_sn   LIKE    gbm_file.gbm01  #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_bmb.clear()
    LET l_flag = 'N'
    LET g_vdate = g_today
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033					
 
   INITIALIZE g_bma.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON              # 螢幕上取單頭條件
        bma01,bma06   #FUN-550093
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #No.TQC-760129   --begin
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bma01)
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.form = "q_ima"
              #   LET g_qryparam.state = 'c'
              #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                 DISPLAY g_qryparam.multiret TO bma01
                 NEXT FIELD bma01
          END CASE
       #No.TQC-760129   --end  
 
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
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND bmauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND bmagrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND bmagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('bmauser', 'bmagrup')
    #End:FUN-980030
 
 
    DISPLAY g_vdate TO FORMONLY.vdate             #輸入有效日期
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033					
 
    INPUT g_vdate WITHOUT DEFAULTS FROM vdate
       ON ACTION controlg       #TQC-860021
          CALL cl_cmdask()      #TQC-860021
 
       ON IDLE g_idle_seconds   #TQC-860021
          CALL cl_on_idle()     #TQC-860021
          CONTINUE INPUT        #TQC-860021
 
       ON ACTION about          #TQC-860021
          CALL cl_about()       #TQC-860021
 
       ON ACTION help           #TQC-860021
          CALL cl_show_help()   #TQC-860021
    END INPUT                   #TQC-860021
 
    IF g_vdate IS NULL OR g_vdate = ' ' THEN
       CONSTRUCT g_wc2 ON bmb02,bmb03,bmb10,bmb04,bmb05,
                               bmb06,bmb07,bmb09,bmb19,bmb15,bmb27,bmb18    #bugno:6845 add  #FUN-880033 add bmb15   #MOD-AB0023 bbmb15,mb27 modify bmb15,bmb27  #MOD-AC0379 add bmb18 
            FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb10,s_bmb[1].bmb04,
                 s_bmb[1].bmb05,s_bmb[1].bmb06,s_bmb[1].bmb07,
                 s_bmb[1].bmb09,s_bmb[1].bmb19,s_bmb[1].bmb15,s_bmb[1].bmb27,s_bmb[1].bmb18 #bugno:6845 add  #FUN-880033 add bmb15    #MOD-AC0379 addbmb18
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmb09) #作業主檔
                   CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb09
                     NEXT FIELD bmb09
              OTHERWISE EXIT CASE
           END  CASE
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
			IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
            IF INT_FLAG THEN RETURN END IF
    ELSE
       CONSTRUCT g_wc2 ON bmb02,bmb03,bmb10,bmb04,bmb05, # 螢幕上取單身條件
                               bmb06,bmb07,bmb09,bmb19,bmb15,bmb27,bmb18  #FUN-880033 add bmb15    #MOD-AC0379 add bmb18
            FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb10,s_bmb[1].bmb04,
                 s_bmb[1].bmb05,s_bmb[1].bmb06,s_bmb[1].bmb07,
                 s_bmb[1].bmb09,s_bmb[1].bmb19,s_bmb[1].bmb15,s_bmb[1].bmb27,s_bmb[1].bmb18 #bugno:6845 add  #FUN-880033 add bmb15  #MOD-AC0379 add bmb18
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmb09) #作業主檔
                   CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb09
                     NEXT FIELD bmb09
              OTHERWISE EXIT CASE
           END  CASE
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
            IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
            LET g_wc2 = g_wc2  clipped,
                " AND (bmb04 <='", g_vdate,"'"," OR bmb04 IS NULL )",
                " AND (bmb05 > '",g_vdate,"'"," OR bmb05 IS NULL )"
    END IF
    IF l_flag = 'N' THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  bma01, bma06 FROM bma_file ", #FUN-550093
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY bma01,bma06" #FUN-550093
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE bma_file. bma01, bma06 ", #FUN-550093
                   "  FROM bma_file, bmb_file ",
                   " WHERE bma01 = bmb01",
                   "   AND bma06 = bmb29",     #No.TQC-920039 add
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY bma01,bma06" #FUN-550093
    END IF
 
    PREPARE i602_prepare FROM g_sql
	DECLARE i602_curs
        SCROLL CURSOR WITH HOLD FOR i602_prepare
 
    IF l_flag = 'N' THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM bma_file WHERE ",g_wc CLIPPED
    ELSE
       #LET g_sql="SELECT COUNT(*) FROM bma_file,bmb_file WHERE ",                       #MOD-CB0021 mark 
        LET g_sql="SELECT COUNT(DISTINCT(bma01||bma06)) FROM bma_file,bmb_file WHERE ",  #MOD-CB0021
                 #"bmb01=bma01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED                  #No.TQC-920039 mark
                  "bmb01=bma01 AND bma06=bmb29 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED  #No.TQC-920039 add
    END IF
    PREPARE i602_precount FROM g_sql
    DECLARE i602_count CURSOR FOR i602_precount
END FUNCTION
 
 
FUNCTION i602_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(100)
 
 
   WHILE TRUE
      CALL i602_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i602_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i602_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                   #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bma.bma01 IS NOT NULL THEN
                  LET g_doc.column1 = "bma01"
                  LET g_doc.value1  = g_bma.bma01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmb),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i602_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bma.* TO NULL           #No.FUN-6A0002
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_bmb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i602_curs()
    IF INT_FLAG THEN
        INITIALIZE g_bma.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i602_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL
    ELSE
        OPEN i602_count
        FETCH i602_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i602_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i602_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式    #No.FUN-680096 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i602_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'P' FETCH PREVIOUS i602_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'F' FETCH FIRST    i602_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN 'L' FETCH LAST     i602_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i602_curs INTO g_bma.bma01,g_bma.bma06 #FUN-550093
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)
        INITIALIZE g_bma.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_bma.* FROM bma_file WHERE bma01 = g_bma.bma01 AND bma06 = g_bma.bma06
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0) # TQC-660046
        CALL cl_err3("sel","bma_file",g_bma.bma01,g_bma.bma06,SQLCA.sqlcode,"","",1) # TQC-660046
        INITIALIZE g_bma.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_bma.bmauser      #FUN-4C0054
        LET g_data_group = g_bma.bmagrup      #FUN-4C0054
    END IF
    CALL i602_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i602_show()
    LET g_bma_t.* = g_bma.*                #保存單頭舊值
    DISPLAY BY NAME g_bma.bma01,g_bma.bma06 #FUN-550093
    CALL i602_bma01('d')
    CALL i602_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION i602_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用   #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否   #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態     #No.FUN-680096 VARCHAR(1)
    l_buf           LIKE type_file.chr50,   #No.FUN-680096 VARCHAR(40)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680096 VARCHAR(200)
    l_uflag,l_chr   LIKE type_file.chr1,    #No.FUN-680096 VARCHAR(1)
    l_ima08         LIKE ima_file.ima08,
    l_bmb01         LIKE ima_file.ima01,
    l_qpa           LIKE bmb_file.bmb06,
    l_allow_insert  LIKE type_file.num5,    #可新增否        #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否        #No.FUN-680096 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_bma.bma01) THEN
        RETURN
    END IF
    #IF g_bma.bmaacti ='N' THEN    #資料若為無效,仍可更改.
    #    CALL cl_err(g_bma.bma01,'mfg1000',0) RETURN
    #END IF
    LET l_uflag ='N'
    LET g_aflag ='N'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT bmb02,bmb03,' ',' ',' ',bmb10,bmb04,bmb05,bmb06, ",
      "        bmb07,bmb09,bmb19,bmb15,bmb27,bmb18 ",   #FUN-880033 add bmb15   #MOD-AC0379 add bmb18
      " FROM bmb_file ",      #bugno:6845 add
      "   WHERE bmb01 = ? ",
      "   AND bmb02 = ? ",
      "   AND bmb03 = ? ",
      "   AND bmb04 = ? ",
      "   AND bmb29 = ? ", #FUN-550093
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i602_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_ac_t = 0
    #   LET l_allow_insert = cl_detail_input_auth("insert")
    #   LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmb
              WITHOUT DEFAULTS
              FROM s_bmb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
            OPEN i602_cl USING g_bma.bma01,g_bma.bma06
            IF STATUS THEN
               CALL cl_err("OPEN i602_cl:", STATUS, 1)
               CLOSE i602_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i602_cl INTO g_bma.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_bma.bma01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i602_cl
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_bmb_t.* = g_bmb[l_ac].*  #BACKUP
               LET g_bmb_o.* = g_bmb[l_ac].*
                LET p_cmd='u'
 
                OPEN i602_bcl USING g_bma.bma01,g_bmb_t.bmb02,g_bmb_t.bmb03,g_bmb_t.bmb04,g_bma.bma06 #FUN-550093
                IF STATUS THEN
                    CALL cl_err("OPEN i602_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i602_bcl INTO g_bmb[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmb_t.bmb02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    CALL i602_bmb03('d')
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
            NEXT FIELD bmb02
 
        BEFORE FIELD bmb02                        #default 項次
            IF g_bmb[l_ac].bmb02 IS NULL OR
               g_bmb[l_ac].bmb02 = 0 THEN
                SELECT max(bmb02)
                   INTO g_bmb[l_ac].bmb02
                   FROM bmb_file
                   WHERE bmb01 = g_bma.bma01
                IF g_bmb[l_ac].bmb02 IS NULL
                   THEN LET g_bmb[l_ac].bmb02 = 0
                END IF
                LET g_bmb[l_ac].bmb02 = g_bmb[l_ac].bmb02 + g_sma.sma19
            END IF
            IF p_cmd = 'a'
              THEN LET g_bmb20 = g_bmb[l_ac].bmb02
            END IF
 
        AFTER FIELD bmb09                         #(作業編號)
            IF NOT cl_null(g_bmb[l_ac].bmb09) THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_bmb[l_ac].bmb09
               IF g_cnt=0 THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD bmb09
               END IF
            END IF
        AFTER FIELD bmb19
            IF NOT cl_null(g_bmb[l_ac].bmb19) THEN
                IF g_bmb[l_ac].bmb19 NOT MATCHES '[1234]' THEN
                    NEXT FIELD bmb19
                END IF
            END IF
 
        #FUN-880033--add--begin
        AFTER FIELD bmb15
            IF NOT cl_null(g_bmb[l_ac].bmb15) THEN
                IF g_bmb[l_ac].bmb15 NOT MATCHES '[YN]' THEN
                    NEXT FIELD bmb15
                END IF
            END IF
        #FUN-880033--add--end
 
        AFTER FIELD bmb27
            IF NOT cl_null(g_bmb[l_ac].bmb27) THEN
                IF g_bmb[l_ac].bmb27 NOT MATCHES '[YN]' THEN
                    NEXT FIELD bmb27
                END IF
            END IF
   
        BEFORE DELETE                            #是否取消單身
            IF g_bmb_t.bmb02 > 0 AND
               g_bmb_t.bmb02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF g_sma.sma845='Y' THEN   #低階碼可否部份重計
                    LET g_success='Y'
                    #CALL s_uima146(g_bmb_t.bmb03)  #CHI-D10044
                    CALL s_uima146(g_bmb_t.bmb03,0)  #CHI-D10044
                    MESSAGE ""
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM bmb_file
                    WHERE bmb01 = g_bma.bma01
                      AND bmb02 = g_bmb_t.bmb02
                      AND bmb03 = g_bmb_t.bmb03
                      AND bmb04 = g_bmb_t.bmb04
                      AND bmb29 = g_bma.bma06 #FUN-550093
                IF SQLCA.sqlcode THEN
                    LET l_buf = g_bmb_t.bmb02 clipped,'+',
                                g_bmb_t.bmb03 clipped,'+',
                                g_bmb_t.bmb04
#                   CALL cl_err(l_buf,SQLCA.sqlcode,0) # TQC-660046
                    CALL cl_err3("del","bmb_file",l_buf,"",SQLCA.sqlcode,"","",1) # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                    DELETE FROM bmt_file
                     WHERE bmt01 = g_bma.bma01
                       AND bmt02 = g_bmb_t.bmb02
                       AND bmt03 = g_bmb_t.bmb03
                       AND bmt04 = g_bmb_t.bmb04
                       AND bmt08 = g_bma.bma06 #FUN-550093
                    IF SQLCA.sqlcode THEN
#                       CALL cl_err('',SQLCA.sqlcode,0) # TQC-660046
                        CALL cl_err3("del","bmt_file",g_bma.bma01,g_bmb_t.bmb02,SQLCA.sqlcode,"","",1) # TQC-660046
                        ROLLBACK WORK
                        CANCEL DELETE
                    END IF
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmb[l_ac].* = g_bmb_t.*
               CLOSE i602_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmb[l_ac].bmb02,-263,1)
                LET g_bmb[l_ac].* = g_bmb_t.*
            ELSE
                UPDATE bmb_file SET
                       bmb09  = g_bmb[l_ac].bmb09,
                       bmb19  = g_bmb[l_ac].bmb19,
                       bmb15  = g_bmb[l_ac].bmb15,    #FUN-880033 add
                       bmb27  = g_bmb[l_ac].bmb27,
                       bmb18  = g_bmb[l_ac].bmb18,    #MOD-AC0379 add
                       bmbmodu= g_user,
                       bmbdate= g_today,
                       bmbcomm='abmi602'
                 WHERE bmb01 = g_bma.bma01
                   AND bmb02 = g_bmb_t.bmb02
                   AND bmb03 = g_bmb_t.bmb03
                   AND bmb04 = g_bmb_t.bmb04
                   AND bmb29 = g_bma.bma06 #FUN-550093
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_bmb[l_ac].bmb02,SQLCA.sqlcode,0) # TQC-660046
                    CALL cl_err3("upd","bmb_file",g_bma.bma01,g_bma_t.bma02,SQLCA.sqlcode,"","",1) # TQC-660046
                    LET g_bmb[l_ac].* = g_bmb_t.*
                    DISPLAY g_bmb[l_ac].* TO s_bmb[l_sl].*
                ELSE
                    UPDATE bma_file
                       SET bmadate = g_today
                     WHERE bma01 = g_bma.bma01 AND bma06 = g_bma.bma06
                    MESSAGE 'UPDATE O.K'
                    IF g_aflag = 'N' THEN LET g_aflag = 'Y' END IF
    		    COMMIT WORK
                END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_bmb[l_ac].* = g_bmb_t.*
               END IF
               CLOSE i602_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           #CKP
           #LET g_bmb_t.* = g_bmb[l_ac].*          # 900423
            CLOSE i602_bcl
            COMMIT WORK
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmb09) #作業主檔
                   CALL q_ecd(FALSE,TRUE,g_bmb[l_ac].bmb09) RETURNING g_bmb[l_ac].bmb09
#                   CALL FGL_DIALOG_SETBUFFER( g_bmb[l_ac].bmb09 )
                   DISPLAY g_bmb[l_ac].bmb09 TO bmb09
                   NEXT FIELD bmb09
               OTHERWISE EXIT CASE
           END  CASE
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
        UPDATE bma_file
           SET bmamodu = g_user,
               bmadate = g_today
         WHERE bma01 = g_bma.bma01 AND bma06 = g_bma.bma06
 
    CLOSE i602_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i602_b_askkey()
DEFINE
    l_wc2     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(200)
 
    CLEAR ima02_b,ima021_b,ima08_b
    CONSTRUCT l_wc2 ON bmb02,bmb03,bmb10,bmb04,bmb05,# 螢幕上取單身條件
                       bmb06,bmb07,bmb09,bmb19,bmb15,bmb27   #FUN-880033 add bmb15
         FROM s_bmb[1].bmb02,s_bmb[1].bmb03,s_bmb[1].bmb10,
              s_bmb[1].bmb04,s_bmb[1].bmb05,
              s_bmb[1].bmb06,s_bmb[1].bmb07,s_bmb[1].bmb09,
              s_bmb[1].bmb19,s_bmb[1].bmb15,s_bmb[1].bmb27   #bugno:6845 add  #FUN-880033 add bmb15
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
     ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bmb09) #作業主檔
                   CALL q_ecd(TRUE,TRUE,g_bmb[1].bmb09)
                          RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO bmb09
                     NEXT FIELD bmb09
              OTHERWISE EXIT CASE
           END  CASE
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i602_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i602_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2     LIKE type_file.chr1000    #No.FUN-680096 VARCHAR(300)
 
    LET g_sql =
        "SELECT bmb02,bmb03,ima02,ima021,ima08,bmb10,bmb04,bmb05,bmb06,bmb07,",
        "      bmb09,bmb19,bmb15,bmb27,bmb18 ", #FUN-550093  #FUN-880033 add bmb15   #MOD-AC0379 add bmb18
        " FROM bmb_file, OUTER ima_file",
        " WHERE bmb01 ='",g_bma.bma01,"' AND",  #單頭
        " bmb_file.bmb03 = ima_file.ima01 AND ",             #OUTER
       #--------------No.MOD-830198 modify
       #" bmb29 = '",g_bma.bma06,"' AND",      #FUN-550093
        " bmb29 = '",g_bma.bma06,"' AND ",      
       #--------------No.MOD-830198 end
        p_wc2 CLIPPED                      #單身
 
    CASE g_sma.sma65
      WHEN '1'  LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
      WHEN '2'  LET g_sql = g_sql CLIPPED, " ORDER BY 2,1,3"
      WHEN '3'  LET g_sql = g_sql CLIPPED, " ORDER BY 6,1,3"
      OTHERWISE LET g_sql = g_sql CLIPPED, " ORDER BY 1,2,3"
    END CASE
 
    PREPARE i602_pb FROM g_sql
    DECLARE bmb_curs                       #SCROLL CURSOR
        CURSOR FOR i602_pb
 
    CALL g_bmb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH bmb_curs INTO g_bmb[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
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
    #CKP
    CALL g_bmb.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i602_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmb TO s_bmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        LET l_sl = SCR_LINE()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i602_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i602_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i602_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i602_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i602_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
 
     #@ON ACTION 相關文件                         #MOD-470051
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       						
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033						
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i602_bma01(p_cmd)  #主件料件
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima55   LIKE ima_file.ima55,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT  ima02,ima021,ima55, ima08,imaacti
       INTO l_ima02,l_ima021,l_ima55, g_ima08_h,l_imaacti
       FROM ima_file
      WHERE ima01 = g_bma.bma01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2602'
                            LET l_ima02 = NULL LET l_ima021 = NULL
                            LET l_ima55 = NULL LET g_ima08_h = NULL
                            LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
  #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
  #FUN-690022------mod-------
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #--->來源碼為'Z':雜項料件
    IF g_ima08_h ='Z'
    THEN LET g_errno = 'mfg2752'
         RETURN
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02   TO FORMONLY.ima02_h
           DISPLAY l_ima021  TO FORMONLY.ima021_h
           DISPLAY g_ima08_h TO FORMONLY.ima08_h
           DISPLAY l_ima55   TO FORMONLY.ima55
    END IF
END FUNCTION
 
FUNCTION i602_bmb03(p_cmd)  #
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima08   LIKE ima_file.ima08
 
    SELECT  ima02,ima021,ima08
       INTO g_bmb[l_ac].ima02_b,g_bmb[l_ac].ima021_b,g_bmb[l_ac].ima08_b
       FROM ima_file
      WHERE ima01 = g_bmb[l_ac].bmb03
END FUNCTION
#Patch....NO.TQC-610035 <001> #

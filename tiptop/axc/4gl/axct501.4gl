# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axct501.4gl
# Descriptions...: 調撥異動單價維護作業
# Date & Author..: 97/08/12 by Kitty
# Modify.........: 00/04/09 By Kammy (add t501_g 單價產生)
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0298 04/11/30 By Carol 表頭無中文說明
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效
# Modify.........: No.FUN-660029 06/06/13 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0079 06/10/31 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.TQC-740032 07/04/09 By chenl   增加修改按鈕，僅修改單頭備注欄位，其他欄位不予回應。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770023 07/07/09 By rainy 單價產生改抓轉撥單價檔(cxk_file)
# Modify.........: No.TQC-970229 09/07/23 By destiny 單價更新及時顯示
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0011 09/11/03 By liuxqa s_dbstring的修改。
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50102 10/06/11 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-B90214 11/09/27 By yinhy 點擊“單價生成”按鈕，錄入單號後，沒有生成成功
# Modify.........: No.MOD-C20045 12/02/08 By Elise 修正查詢未查出任何資料，即使用"單價整批產生"功能，條件下*程式就當掉的問題
# Modify.........: No:MOD-C60091 12/06/12 By ck2yuan 修正sql條件
# Modify.........: No:MOD-C70249 12/07/25 By ck2yuan 兩階段調撥也納入維護
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-DB0027 13/11/15 By wangrr "調撥單號"欄位增加開窗,單身imn091該說明為"材料單價"
#                                                   點擊[單價產生]彈出窗口中"料件""來源碼"欄位增加開窗
#                                                   點擊[撷取转拨单价]彈出窗口中"調撥單號""料號"欄位增加開窗
# Modify.........: No:TQC-DB0034 13/11/18 By wangrr 報錯信息錯誤修改

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
    g_imm   RECORD LIKE imm_file.*,
    g_imm_t RECORD LIKE imm_file.*,
    g_imm_o RECORD LIKE imm_file.*,
    g_imm01_t      LIKE imm_file.imm01,    #No.TQC-740032
    b_imn   RECORD LIKE imn_file.*,
    g_yy,g_mm       LIKE type_file.num5,                 #No.FUN-680122SMALLINT                     #
    g_imn03_t       LIKE imn_file.imn03,
    t_imn04         LIKE imn_file.imn04,
    t_imn05         LIKE imn_file.imn05,
    t_imn15         LIKE imn_file.imn15,
    t_imn16         LIKE imn_file.imn16,
    t_imf04         LIKE imf_file.imf04,
    t_imf05         LIKE imf_file.imf05,
    g_imn           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn10     LIKE imn_file.imn10,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn091    LIKE imn_file.imn091,
                    imn092    LIKE imn_file.imn092,
                    imn22     LIKE imn_file.imn22
                    END RECORD,
    g_imn_t   RECORD
                    imn02     LIKE imn_file.imn02,
                    imn03     LIKE imn_file.imn03,
                    imn04     LIKE imn_file.imn04,
                    imn05     LIKE imn_file.imn05,
                    imn06     LIKE imn_file.imn06,
                    imn09     LIKE imn_file.imn09,
                    imn10     LIKE imn_file.imn10,
                    imn15     LIKE imn_file.imn15,
                    imn16     LIKE imn_file.imn16,
                    imn17     LIKE imn_file.imn17,
                    imn20     LIKE imn_file.imn20,
                    imn091    LIKE imn_file.imn091,
                    imn092    LIKE imn_file.imn092,
                    imn22     LIKE imn_file.imn22
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    h_qty               LIKE ima_file.ima271,
    g_t1                LIKE oay_file.oayslip,               #No.FUN-550025        #No.FUN-680122CHAR(5)
    g_buf               LIKE type_file.chr20,         #No.FUN-680122CHAR(20)
    sn1,sn2             LIKE type_file.num5,          #No.FUN-680122SMALLINT
    l_code              LIKE type_file.chr8,          #No.FUN-680122CHAR(07)  #No.TQC-6A0079
    g_rec_b             LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac                LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
    g_debit,g_credit    LIKE img_file.img26,
    g_ima25,g_ima25_2   LIKE ima_file.ima25,
    g_ima86,g_ima86_2   LIKE ima_file.ima86,
    g_img10,g_img10_2   LIKE img_file.img10
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680122CHAR(72)
 
 
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE   g_confirm      LIKE type_file.chr1          #No.FUN-680122CHAR(1)
DEFINE   g_approve      LIKE type_file.chr1          #No.FUN-680122CHAR(1)
DEFINE   g_post         LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_close        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_void         LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_valid        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0146
    p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXC")) THEN
       EXIT PROGRAM
    END IF
 
 
    LET g_wc2=' 1=1'
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
 
    INITIALIZE g_imm.* TO NULL
    INITIALIZE g_imm_t.* TO NULL
    INITIALIZE g_imm_o.* TO NULL
 
    LET p_row = 3 LET p_col = 20
    OPEN WINDOW t501_w AT p_row,p_col
         WITH FORM "axc/42f/axct501"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #No.TQC-740032--begin-- 
    LET g_forupd_sql = " SELECT * FROM imm_file WHERE imm01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t501_cl CURSOR FROM g_forupd_sql 
    #No.TQC-740032--end--
 
    CALL t501_menu()
 
    CLOSE WINDOW t501_w                    #結束畫面
 
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
         RETURNING g_time    #No.FUN-6A0146
 
END MAIN
 
FUNCTION t501_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_imn.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   INITIALIZE g_imm.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        imm01,imm02,immconf,imm03,immuser,immgrup,immmodu,immdate #FUN-660029 add immconf
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #TQC-DB0027--add--str--
       ON ACTION controlp
          CASE
             WHEN INFIELD(imm01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_imm01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imm01
                NEXT FIELD imm01
          END CASE
       #TQC-DB0027--add--end
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
    #        LET g_wc = g_wc clipped," AND immuser = '",g_user,"'"
    #    END IF
 
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND immgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND immgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('immuser', 'immgrup')
    #End:FUN-980030
 
 
    CONSTRUCT g_wc2 ON imn02,imn03,imn04,imn05,imn09,imn10,
                       imn15,imn16,imn17,imn20,imn22,imn091,imn092
                  FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn04,
                       s_imn[1].imn05,s_imn[1].imn09,s_imn[1].imn10,
                       s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,
                       s_imn[1].imn20,s_imn[1].imn22,s_imn[1].imn091,
                       s_imn[1].imn092
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
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
				
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT imm01 FROM imm_file",
                  #" WHERE imm10 = '1' AND ", g_wc CLIPPED,                      #MOD-C70249 mark
                   " WHERE (imm10 = '1' OR imm10 = '2') AND ", g_wc CLIPPED,     #MOD-C70249 add
                   #"   AND imm03 != 'X' ", #mandy
                   "   AND imm03 = 'Y' ",   #MOD-C60091 add      
                   "   AND immconf <> 'X' ", #FUN-660029
                   " ORDER BY imm01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imm01 ",
                   "  FROM imm_file, imn_file",
                   " WHERE imm01 = imn01",
                  #"   AND imm10 = '1'  ",                            #MOD-C70249 mark
                   "   AND (imm10 = '1' OR imm10 = '2')  ",           #MOD-C70249 add
                   #"   AND imm03 != 'X' ", #mandy
                   "   AND imm03 = 'Y' ",   #MOD-C60091 add
                   "   AND immconf <> 'X' ", #FUN-660029
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY imm01"
    END IF
 
    PREPARE t501_prepare FROM g_sql
    DECLARE t501_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t501_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imm_file ",
                 #"WHERE imm10 = '1' AND ",g_wc CLIPPED,                        #MOD-C70249 mark
                  " WHERE (imm10 = '1' OR imm10 = '2') AND ", g_wc CLIPPED,     #MOD-C70249 add
                  #"   AND imm03 != 'X' " #mandy
                 #"   AND imm03 <> 'X' " #FUN-660029  #MOD-C60091 mark
                  "   AND imm03 = 'Y' ",              #MOD-C60091 add
                  "   AND immconf <> 'X' "            #MOD-C60091 add
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imm01) FROM imm_file,imn_file ",
                 #" WHERE imm10 = '1' AND ",                                      #MOD-C70249 mark
                  " WHERE (imm10 = '1' OR imm10 = '2') AND ",                     #MOD-C70249 add
                  "imm01=imn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  #"   AND imm03 != 'X' " #mandy
                 #"   AND imm03 <> 'X' " #FUN-660029  #MOD-C60091 mark
                  "   AND imm03 = 'Y' ",              #MOD-C60091 add
                  "   AND immconf <> 'X' "            #MOD-C60091 add
    END IF
    PREPARE t501_precount FROM g_sql
    DECLARE t501_count CURSOR FOR t501_precount
 
END FUNCTION
 
FUNCTION t501_menu()
 
   WHILE TRUE
      CALL t501_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t501_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t501_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.TQC-740032--begin--
         WHEN "modify"
            IF cl_chk_act_auth() THEN 
               CALL t501_u()
            END IF 
         #No.TQC-740032--end--
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_u_p"
            IF cl_chk_act_auth() THEN
               #CALL t501_g()  #FUN-770023
               CALL t501_g2()  #FUN-770023
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imn),'','')
         #No.FUN-6A0019-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imm.imm01 IS NOT NULL THEN
                 LET g_doc.column1 = "imm01"
                 LET g_doc.value1 = g_imm.imm01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0019-------add--------end----
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION t501_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL t501_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_imm.* TO NULL
       RETURN
    END IF
 
    MESSAGE " SEARCHING ! "
 
    OPEN t501_cs               # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_imm.* TO NULL
    ELSE
       OPEN t501_count
       FETCH t501_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL t501_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
    MESSAGE ""
 
END FUNCTION
 
FUNCTION t501_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680122 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t501_cs INTO g_imm.imm01
        WHEN 'P' FETCH PREVIOUS t501_cs INTO g_imm.imm01
        WHEN 'F' FETCH FIRST    t501_cs INTO g_imm.imm01
        WHEN 'L' FETCH LAST     t501_cs INTO g_imm.imm01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump t501_cs INTO g_imm.imm01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
        INITIALIZE g_imm.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_imm.* FROM imm_file
     WHERE imm01 = g_imm.imm01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)   #No.FUN-660127
       CALL cl_err3("sel","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
       INITIALIZE g_imm.* TO NULL
       RETURN
    ELSE
       LET g_data_owner=g_imm.immuser           #FUN-4C0061權限控管
       LET g_data_group=g_imm.immgrup
       LET g_data_plant = g_imm.immplant #FUN-980030
    END IF
 
    CALL t501_show()
 
END FUNCTION
 
FUNCTION t501_show()
 
    LET g_imm_t.* = g_imm.*                #保存單頭舊值
    DISPLAY BY NAME g_imm.imm01,g_imm.imm02,g_imm.imm09,g_imm.immconf, #FUN-660029 add g_imm.immconf
                    g_imm.imm03,g_imm.immuser,g_imm.immgrup,g_imm.immmodu,
                    g_imm.immdate
   #No.FUN-550025 --start--
#    LET g_buf = g_imm.imm01[1,3]
    CALL s_get_doc_no(g_imm.imm01) RETURNING g_buf
   #No.FUN-550025 --end--
 
    #FUN-660029...............begin
    #CASE g_imm.imm04
    #     WHEN 'Y'   LET g_confirm = 'Y'
    #                LET g_void = ''
    #     WHEN 'N'   LET g_confirm = 'N'
    #                LET g_void = ''
    #     WHEN 'X'   LET g_confirm = ''
    #                LET g_void = 'Y'
    #  OTHERWISE     LET g_confirm = ''
    #                LET g_void = ''
    #END CASE
    #IF g_imm.imm03 = 'Y' THEN
    #   LET g_post = 'Y'
    #ELSE
    #   LET g_post = 'N'
    #END IF
    ##圖形顯示
    #CALL cl_set_field_pic(g_confirm,"",g_post,"",g_void,g_imm.immacti)
    IF g_imm.immconf='X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"")
    #FUN-660029...............end
    CALL t501_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t501_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT      #No.FUN-680122 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680122SMALLINT  #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用             #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否             #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態               #No.FUN-680122 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否               #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否               #No.FUN-680122 SMALLINT
 
    LET g_action_choice = ""
 
    IF g_imm.imm01 IS NULL THEN RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM imn_file ",
                       " WHERE imn01= ? AND imn02= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t501_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_imn WITHOUT DEFAULTS FROM s_imn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               BEGIN WORK
               LET g_imn_t.* = g_imn[l_ac].*  #BACKUP
               LET p_cmd='u'
 
               OPEN t501_bcl USING g_imm.imm01, g_imn_t.imn02
               IF STATUS THEN
                  CALL cl_err("OPEN t501_bcl:",STATUS,1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t501_bcl INTO b_imn.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock imn',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t501_b_move_to()
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imn[l_ac].* TO NULL      #900423
            INITIALIZE g_imn_t.* TO NULL
            LET b_imn.imn01=g_imm.imm01
            LET g_imn[l_ac].imn10=0
            LET g_imn[l_ac].imn22=0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imn02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
        AFTER FIELD imn091
            IF NOT cl_null(g_imn[l_ac].imn091) THEN
               IF g_imn[l_ac].imn091=0 THEN
                  NEXT FIELD imn091
               END IF
 
               LET g_imn[l_ac].imn092=g_imn[l_ac].imn091*g_imn[l_ac].imn22
 
            END IF
 
        AFTER FIELD imn092
            IF NOT cl_null(g_imn[l_ac].imn092) THEN
               IF g_imn[l_ac].imn092=0 THEN
                  NEXT FIELD imn092
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_imn_t.imn02 > 0 AND NOT cl_null(g_imn_t.imn02) THEN
               CALL cl_err(g_imn_t.imn02,'axc-001',0)
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imn[l_ac].* = g_imn_t.*
               CLOSE t501_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imn[l_ac].imn02,-263,1)
               LET g_imn[l_ac].* = g_imn_t.*
            ELSE
 
               CALL t501_b_move_back()
 
               UPDATE imn_file SET imn091=b_imn.imn091,
                                   imn092=b_imn.imn092
                WHERE imn01=g_imm.imm01
                  AND imn02=g_imn_t.imn02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err('upd imn',SQLCA.sqlcode,0)   #No.FUN-660127
                  CALL cl_err3("upd","imn_file",g_imm.imm01,g_imn_t.imn02,SQLCA.sqlcode,"","upd imn",1)  #No.FUN-660127
                  LET g_imn[l_ac].* = g_imn_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
	          COMMIT WORK
               END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_imn[l_ac].* = g_imn_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_imn.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--

               END IF
               CLOSE t501_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE t501_bcl
            COMMIT WORK
 
#       ON ACTION CONTROLN
#           CALL t501_b_askkey()
#           EXIT INPUT
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        AFTER INPUT
           UPDATE imm_file SET immmodu=g_usesr,immdate=g_today
            WHERE imm01=g_imm.imm01
 
           SELECT COUNT(*) INTO g_cnt FROM imn_file WHERE imn01=g_imm.imm01
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
 
    CLOSE t501_bcl
    COMMIT WORK
 
END FUNCTION
 
#No.TQC-970229--begin                                                                                                               
FUNCTION t501_bp_refresh()                                                                                                          
DEFINE   l_imn091      LIKE imn_file.imn091                                                                                         
DEFINE   l_imn092      LIKE imn_file.imn092                                                                                         
                                                                                                                                    
  SELECT imn091,imn092 INTO l_imn091,l_imn092 FROM imn_file                                                                         
   WHERE imn01=g_imm.imm01 AND imn02=g_imn[l_ac].imn02                                                                              
  LET g_imn[l_ac].imn091=l_imn091                                                                                                   
  LET g_imn[l_ac].imn092=l_imn092                                                                                                   
  DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)                                                                
     BEFORE DISPLAY                                                                                                                 
        EXIT DISPLAY                                                                                                                
     ON IDLE g_idle_seconds                                                                                                         
        CALL cl_on_idle()                                                                                                           
        CONTINUE DISPLAY                                                                                                            
  END DISPLAY                                                                                                                       
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.TQC-970229--begin 
 
FUNCTION t501_b_move_to()
	LET g_imn[l_ac].imn02=b_imn.imn02
	LET g_imn[l_ac].imn03=b_imn.imn03
	LET g_imn[l_ac].imn04=b_imn.imn04
	LET g_imn[l_ac].imn05=b_imn.imn05
	LET g_imn[l_ac].imn06=b_imn.imn06
	LET g_imn[l_ac].imn09=b_imn.imn09
	LET g_imn[l_ac].imn10=b_imn.imn10
	LET g_imn[l_ac].imn15=b_imn.imn15
	LET g_imn[l_ac].imn16=b_imn.imn16
	LET g_imn[l_ac].imn17=b_imn.imn17
	LET g_imn[l_ac].imn20=b_imn.imn20
	LET g_imn[l_ac].imn091=b_imn.imn091
	LET g_imn[l_ac].imn092=b_imn.imn092
	LET g_imn[l_ac].imn22=b_imn.imn22
END FUNCTION
 
FUNCTION t501_b_move_back()
	LET b_imn.imn02=g_imn[l_ac].imn02
	LET b_imn.imn03=g_imn[l_ac].imn03
	LET b_imn.imn04=g_imn[l_ac].imn04
	LET b_imn.imn05=g_imn[l_ac].imn05
	LET b_imn.imn06=g_imn[l_ac].imn06
	LET b_imn.imn09=g_imn[l_ac].imn09
	LET b_imn.imn10=g_imn[l_ac].imn10
	LET b_imn.imn15=g_imn[l_ac].imn15
	LET b_imn.imn16=g_imn[l_ac].imn16
	LET b_imn.imn17=g_imn[l_ac].imn17
	LET b_imn.imn20=g_imn[l_ac].imn20
	LET b_imn.imn091=g_imn[l_ac].imn091
	LET b_imn.imn092=g_imn[l_ac].imn092
	LET b_imn.imn22=g_imn[l_ac].imn22
END FUNCTION
 
FUNCTION t501_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    CONSTRUCT l_wc2 ON imn03,imn04,imn05,imn17,imn09,imn10,
                       imn15,imn16,imn17,imn20,imn22,imn091,imn092
            FROM s_imn[1].imn02,s_imn[1].imn03,s_imn[1].imn04,
				 s_imn[1].imn05,s_imn[1].imn09,s_imn[1].imn10,
                 s_imn[1].imn15,s_imn[1].imn16,s_imn[1].imn17,
                 s_imn[1].imn20,s_imn[1].imn22,s_imn[1].imn091,s_imn[1].imn092
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    CALL t501_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t501_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    LET g_sql =
        "SELECT imn02,imn03,imn04,imn05,imn06,imn09,imn10,",
        "       imn15,imn16,imn17,imn20,imn091,imn092,imn22",
        " FROM imn_file LEFT OUTER JOIN ima_file ON imn03 = ima_file.ima01 ",
        " WHERE imn01 ='",g_imm.imm01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY 1"
 
    PREPARE t501_pb FROM g_sql
    DECLARE imn_curs CURSOR FOR t501_pb
 
    CALL g_imn.clear()
    LET g_cnt = 1
 
    FOREACH imn_curs INTO g_imn[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
 
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_imn.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t501_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imn TO s_imn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      #No.TQC-740032--begin--
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY 
      #No.TQC-740032--end--
      ON ACTION first
         CALL t501_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t501_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t501_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t501_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t501_fetch('L')
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
        #FUN-660029...............begin
        #CASE g_imm.imm04
        #     WHEN 'Y'   LET g_confirm = 'Y'
        #                LET g_void = ''
        #     WHEN 'N'   LET g_confirm = 'N'
        #                LET g_void = ''
        #     WHEN 'X'   LET g_confirm = ''
        #                LET g_void = 'Y'
        #  OTHERWISE     LET g_confirm = ''
        #                LET g_void = ''
        #END CASE
        #IF g_imm.imm03 = 'Y' THEN
        #   LET g_post = 'Y'
        #ELSE
        #   LET g_post = 'N'
        #END IF
        ##圖形顯示
        #CALL cl_set_field_pic(g_confirm,"",g_post,"",g_void,g_imm.immacti)
         IF g_imm.immconf='X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imm.immconf,"",g_imm.imm03,"",g_void,"")         
        #FUN-660029...............end
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
#@    ON ACTION 單價產生
      ON ACTION gen_u_p
         LET g_action_choice="gen_u_p"
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
 
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY #TQC-5B0076
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
#---單價產生
FUNCTION t501_g()
  DEFINE  l_cmd           LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_cmd2          LIKE type_file.chr1000,       #No.FUN-680122CHAR(600)
          l_cnt           LIKE type_file.num5,          #No.FUN-680122 SMALLINT
          l_bdate,l_edate LIKE type_file.dat,           #No.FUN-680122 DATE
          l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
          l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(40)
          l_fromplant     LIKE azp_file.azp03,
          l_flag          LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          tm RECORD
             x          LIKE type_file.chr1,           #No.FUN-680122CHAR(01) 
             yy         LIKE type_file.num5,           #No.FUN-680122 SMALLINT 
             mm         LIKE type_file.num5,           #No.FUN-680122 SMALLINT 
             plant      LIKE azp_file.azp01
          END RECORD,
          l_cost        LIKE imn_file.imn091,
          l_uprice      LIKE imn_file.imn091,
          l_amount      LIKE imn_file.imn092,
          l_plus        LIKE ima_file.ima129,
          l_kind        LIKE oba_file.oba01
  DEFINE l_plant  LIKE type_file.chr20    #FUN-A50102        
 
DEFINE   sr RECORD
             imn01      LIKE imn_file.imn01,
             imn02      LIKE imn_file.imn02,
             imn03      LIKE imn_file.imn03,
             imn22      LIKE imn_file.imn22
          END RECORD
 
 
  OPEN WINDOW t501_g AT 5,24 WITH FORM "axc/42f/axct501_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axct501_g")
 
 
  DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02
  WHILE TRUE
     CONSTRUCT BY NAME g_wc ON imn01,imn03,ima08
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       #TQC-DB0027--add--str--
       ON ACTION controlp
          CASE
             WHEN INFIELD(imn03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_imn03"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn03
                NEXT FIELD imn03
              WHEN INFIELD(ima08)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_ima08_1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ima08
                NEXT FIELD ima08
          END CASE
       #TQC-DB0027--add--end
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
     IF INT_FLAG THEN EXIT WHILE END IF
     IF g_wc = ' 1=1' THEN
        CALL cl_err('','9046',1)
        CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW t501_g
     RETURN
  END IF
  IF cl_null(g_wc) THEN LET g_wc = ' 1=1' END IF
 
  LET tm.plant = g_plant
  # return 上期年月
  CALL s_lsperiod(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.yy,tm.mm
 
  LET tm.x = '1'
  INPUT BY NAME tm.x,tm.plant,tm.yy,tm.mm WITHOUT DEFAULTS
        AFTER FIELD x
          IF cl_null(tm.x) THEN NEXT FIELD x END IF
          IF tm.x NOT MATCHES '[1234]' THEN NEXT FIELD x END IF
 
        AFTER FIELD plant
          IF tm.x = 'N' THEN
             IF cl_null(tm.plant) THEN NEXT FIELD plant END IF
             SELECT COUNT(*) INTO l_cnt
               FROM azp_file
              WHERE azp01=tm.plant
             IF l_cnt=0 THEN
                NEXT FIELD plant
             END IF
          END IF
 
        AFTER FIELD yy
          IF tm.x = '1' THEN
             IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
          END IF
 
        AFTER FIELD mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(tm.mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.mm > 12 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            ELSE
               IF tm.mm > 13 OR tm.mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
          IF tm.x = '1' THEN
             IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
          END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        AFTER INPUT
           IF int_flag THEN EXIT INPUT END IF
           CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
                RETURNING l_flag, l_bdate, l_edate #得出起始日與截止日
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
   END INPUT
 
   IF INT_FLAG THEN
      CLOSE WINDOW t501_g
      RETURN
   END IF
 
   SELECT azp03 INTO l_fromplant FROM azp_file
    WHERE azp01=tm.plant
   LET l_plant = tm.plant   #FUN-A50102
   IF cl_null(l_fromplant) THEN
      SELECT azp03 into l_fromplant from azp_file
       WHERE azp01 = g_plant
      LET l_plant = g_plant   #FUN-A50102 
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   CALL cl_outnam('axct501') RETURNING l_name
   START REPORT axct501_rep TO l_name
 
   LET l_cmd2 ="SELECT imn01,imn02,imn03,imn22 ",
               " FROM imn_file,ima_file ,imm_file,smy_file ",
               " WHERE imn03 = ima01 AND imm01 = imn01 ",
               " AND imm02 BETWEEN '",l_bdate,"' AND '",l_edate ,"' ",
              #" AND imm10 ='1' ",                              #MOD-C70249 mark
               " AND (imm10 = '1' OR imm10 = '2')  ",           #MOD-C70249 add
               " AND imm03 !='X' ",
   #No.FUN-550025 --start--
   #            " AND smyslip = imm01[1,3] ",
                " AND imm01 like ltrim(rtrim(smyslip)) || '-%' ",
   #No.FUN-550025 --end--
               " AND ",g_wc clipped
   PREPARE t501_pregen FROM l_cmd2
   DECLARE t501_cugen SCROLL CURSOR WITH HOLD FOR t501_pregen
 
   LET l_fromplant = s_dbstring(l_fromplant CLIPPED) 
   LET l_cmd ="SELECT ccc23 ",
              #"FROM ",l_fromplant clipped,"ccc_file ",   #TQC-9B0011 mod
              "FROM ",cl_get_target_table(l_plant,'ccc_file'),  #FUN-A50102
              " WHERE ccc01 = ?  ",
              " AND ccc02 = ",tm.yy ,
              " AND ccc03 = ",tm.mm clipped
   CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
   CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102	             
   PREPARE t501_preccc FROM l_cmd
   DECLARE t501_cuccc SCROLL CURSOR WITH HOLD FOR t501_preccc
 
   LET l_cmd ="SELECT ima531 ",
              #"FROM ",l_fromplant clipped,"ima_file ",
              "FROM ",cl_get_target_table(l_plant,'ima_file'),  #FUN-A50102
              " WHERE ima01 = ?  "
   CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
   CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102           
   PREPARE t501_prima531 FROM l_cmd
   DECLARE t501_ima531 SCROLL CURSOR WITH HOLD FOR t501_prima531
 
   LET l_cmd ="SELECT ima129 ",
              #"FROM ",l_fromplant clipped,"ima_file ",
              "FROM ",cl_get_target_table(l_plant,'ima_file'),  #FUN-A50102
              " WHERE ima01 = ?  "
   CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
   CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102           
   PREPARE t501_prima129 FROM l_cmd
   DECLARE t501_ima129 SCROLL CURSOR WITH HOLD FOR t501_prima129
 
   LET l_cmd ="SELECT ima131 ",
              #"FROM ",l_fromplant clipped,"ima_file ",
              "FROM ",cl_get_target_table(l_plant,'ima_file'),  #FUN-A50102
              " WHERE ima01 = ?  "
   CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
   CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102           
   PREPARE t501_prima131 FROM l_cmd
   DECLARE t501_ima131 SCROLL CURSOR WITH HOLD FOR t501_prima131
 
   LET l_cmd ="SELECT oba07  ",
              #" FROM ",l_fromplant clipped,"oba_file ",
              " FROM ",cl_get_target_table(l_plant,'oba_file'),  #FUN-A50102
              " WHERE oba01 = ?  "
   CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
   CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102           
   PREPARE t501_proba07  FROM l_cmd
   DECLARE t501_oba07  SCROLL CURSOR WITH HOLD FOR t501_proba07
 
   IF NOT  cl_sure(10,20) THEN
      CLOSE window t501_g
      RETURN
   END IF
 
   #------------------------------
   #掃單據的單身,並更改單價及金額
   #------------------------------
   FOREACH t501_cugen into sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach :t501_cugen',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      MESSAGE sr.imn01,'-',sr.imn02
      OPEN t501_cuccc USING sr.imn03
      FETCH t501_cuccc INTO l_cost
      IF SQLCA.sqlcode AND tm.x MATCHES '[134]' THEN
         OUTPUT TO REPORT axct501_rep(sr.*,'1')
         LET l_flag = 'Y'
         LET l_cost = 0
      END IF
 
      CASE tm.x
        WHEN '1'
                LET l_uprice = l_cost
        WHEN '2'
                OPEN t501_ima531 USING sr.imn03
                FETCH t501_ima531 INTO l_uprice
                IF SQLCA.sqlcode then
                   OUTPUT TO REPORT axct501_rep(sr.*,'2')
                   LET l_flag = 'Y'
                   LET l_uprice = 0
                END IF
                IF cl_null(l_uprice) THEN LET l_uprice = 0 END IF
                CLOSE t501_ima531
        WHEN '3'
                OPEN t501_ima129 USING sr.imn03
                FETCH t501_ima129 INTO l_plus
                IF SQLCA.sqlcode then
                   OUTPUT TO REPORT axct501_rep(sr.*,'3')
                   LET l_flag = 'Y'
                   LET l_plus = 0
                END IF
                IF cl_null(l_plus) THEN LET l_plus = 0 END IF
                LET l_uprice = l_cost * (1 + l_plus/100)
                CLOSE t501_ima129
        WHEN '4'
                OPEN t501_ima131 USING sr.imn03
                FETCH t501_ima131 INTO l_kind
                OPEN t501_oba07 USING l_kind
                FETCH t501_oba07 INTO l_plus
                IF SQLCA.sqlcode then
                   OUTPUT TO REPORT axct501_rep(sr.*,'4')
                   LET l_flag = 'Y'
                   LET l_plus = 0
                END IF
                IF cl_null(l_plus) THEN LET l_plus = 0 END IF
                LET l_uprice = l_cost * (1 + l_plus/100)
                CLOSE t501_ima131
                CLOSE t501_oba07
        OTHERWISE LET l_uprice = 0
      END CASE
      LET l_amount  = l_uprice * sr.imn22
      UPDATE imn_file SET imn091 = l_uprice,
                          imn092 = l_amount
       WHERE imn01 = sr.imn01 AND imn02 = sr.imn02
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE ERROR!"
         EXIT FOREACH
      END IF
 
      UPDATE tlf_file SET tlf21 = l_amount
       WHERE tlf905 = sr.imn01 AND tlf906 = sr.imn02
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE tlf ERROR!"
         EXIT FOREACH
      END IF
 
      CLOSE t501_cuccc
 
   END FOREACH
 
   FINISH REPORT axct501_rep
   IF l_flag = 'Y' THEN
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   ELSE
     #No.+366 010705 plum
#    LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#    RUN l_cmd                                          #No.FUN-9C0009 
     IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
     #No.+366..end
   END IF
 
   CLOSE WINDOW t501_g
 
   CALL cl_err('','axc-001',0)
 
END FUNCTION
 
REPORT axct501_rep(sr,p_cmd)
   DEFINE l_last_sw        LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(01) 
        #  l_row3,l_row6    LIKE ima_file.ima26,           #No.FUN-680122 DEC(15,3) #FUN-A20044
          l_row3,l_row6    LIKE type_file.num15_3,           #No.FUN-680122 DEC(15,3) #FUN-A20044
          l_str            LIKE type_file.chr1000,        #No.FUN-680122 VARCHAR(40)
          p_cmd            LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1)
          l_ima02 LIKE ima_file.ima02,
          l_ima021 LIKE ima_file.ima021,
          sr RECORD
               imn01 LIKE imn_file.imn01,
               imn02 LIKE imn_file.imn02,
               imn03 LIKE imn_file.imn03,
               imn22 LIKE imn_file.imn22
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.imn01,sr.imn02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      CASE p_cmd
           WHEN '1' LET l_str = g_x[9]
           WHEN '2' LET l_str = g_x[10]
           WHEN '3' LET l_str = g_x[11]
      END CASE
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
          WHERE ima01=sr.imn03
      IF SQLCA.sqlcode THEN
          LET l_ima02 = NULL
          LET l_ima021 = NULL
      END IF
      PRINT COLUMN g_c[31],sr.imn01,' - ',
            COLUMN g_c[32],sr.imn02 USING '###&',
            COLUMN g_c[33],sr.imn03,l_str,
            COLUMN g_c[34],l_ima02,
            COLUMN g_c[35],l_ima021
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[7] CLIPPED
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[35], g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
END REPORT
 
#No.TQC-740032--begin--
FUNCTION t501_u()
 
    IF s_shut(0) THEN 
       RETURN 
    END IF 
    
    IF cl_null(g_imm.imm01) THEN 
       CALL cl_err('',-400,0)
       RETURN 
    END IF
     
    SELECT * INTO g_imm.* FROM imm_file
     WHERE imm01=g_imm.imm01
     
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imm01_t = g_imm.imm01
    
    BEGIN WORK 
    
    OPEN t501_cl USING g_imm.imm01 
    IF STATUS THEN 
       CALL cl_err('open t501_cl:',STATUS,1)
       CLOSE t501_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
 
    FETCH t501_cl INTO g_imm.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
       CLOSE t501_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    
    CALL t501_show()
    
    WHILE TRUE 
      LET g_imm01_t = g_imm.imm01
      LET g_imm_o.* = g_imm.*
      LET g_imm.immmodu = g_user
      LET g_imm.immdate = g_today
    
      CALL t501_i("u")
    
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         LET g_imm.* = g_imm_o.*
         CALL t501_show()
         CALL cl_err('','9001',0)
         EXIT WHILE 
      END IF 
      
      UPDATE imm_file SET imm_file.* = g_imm.*
       WHERE imm01 = g_imm_t.imm01 
       
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err(g_imm.imm01,SQLCA.sqlcode,0)
         CONTINUE WHILE 
      END IF   
      EXIT WHILE 
    END WHILE 
    
    CLOSE t501_cl
    COMMIT WORK 
  
END FUNCTION 
 
FUNCTION t501_i(p_cmd)
DEFINE  p_cmd         VARCHAR(01)
 
 
    IF s_shut(0) THEN 
       RETURN 
    END IF 
 
    DISPLAY BY NAME g_imm.imm09,g_imm.immuser,g_imm.immgrup,g_imm.immmodu
    
    INPUT BY NAME g_imm.imm09 WITHOUT DEFAULTS 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON ACTION CONTROLF
         CALL cl_fldhlp('imm09')
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
    END INPUT   
 
END FUNCTION 
#No.TQC-740032--end--
 
 
#FUN-770023 begin
#---單價產生(改抓轉撥單價檔: cxk_file)
FUNCTION t501_g2()
  DEFINE  l_cmd           LIKE type_file.chr1000,       
          l_cmd2          LIKE type_file.chr1000,       
          l_cnt           LIKE type_file.num5,          
          l_bdate,l_edate LIKE type_file.dat,           
          l_za05          LIKE type_file.chr1000,       
          l_name          LIKE type_file.chr20,         
          l_fromplant     LIKE azp_file.azp03,
          l_flag          LIKE type_file.chr1,         
          l_cost        LIKE imn_file.imn091,
          l_uprice      LIKE imn_file.imn091,
          l_amount      LIKE imn_file.imn092,
          l_plus        LIKE ima_file.ima129,
          l_kind        LIKE oba_file.oba01
 
DEFINE   sr RECORD
             imn01      LIKE imn_file.imn01,
             imn02      LIKE imn_file.imn02,
             imn03      LIKE imn_file.imn03,
             imn10      LIKE imn_file.imn10,
             imn22      LIKE imn_file.imn22
          END RECORD
 
 
  OPEN WINDOW t501_g2 AT 5,24 WITH FORM "axc/42f/axct501_g2"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_locale("axct501_g2")
 
 
  DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02
  WHILE TRUE
     CONSTRUCT BY NAME g_wc ON imn01,imn03
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
       #TQC-DB0027--add--str--
       ON ACTION controlp
          CASE
             WHEN INFIELD(imn01)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_imm01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn01
                NEXT FIELD imn01
             WHEN INFIELD(imn03)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_imn03"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO imn03
                NEXT FIELD imn03
          END CASE
        #TQC-DB0027--add--end
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
        ON ACTION about         
           CALL cl_about()      
        ON ACTION help          
           CALL cl_show_help()  
        ON ACTION controlg      
           CALL cl_cmdask()     
        ON ACTION qbe_select
          CALL cl_qbe_select()
        ON ACTION qbe_save
	  CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN EXIT WHILE END IF
     IF g_wc = ' 1=1' THEN
        CALL cl_err('','9046',1)
        CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW t501_g2
     RETURN
  END IF
  IF cl_null(g_wc) THEN LET g_wc = ' 1=1' END IF
 
 
  SELECT azp03 into l_fromplant from azp_file
   WHERE azp01 = g_plant
 
  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
       RETURNING l_flag, l_bdate, l_edate #得出起始日與截止日
 
 
  LET l_cmd2 ="SELECT imn01,imn02,imn03,imn10,imn22 ",
              " FROM imn_file,ima_file ,imm_file,smy_file ",
              " WHERE imn03 = ima01 AND imm01 = imn01 ",
              " AND imm02 BETWEEN '",l_bdate,"' AND '",l_edate ,"' ",
             #" AND imm10 ='1' ",                              #MOD-C70249 mark
              " AND (imm10 = '1' OR imm10 = '2')  ",           #MOD-C70249 add
              " AND imm03 !='X' ",
              " AND imm01 like ltrim(rtrim(smyslip)) || '-%' ",
               " AND ",g_wc clipped
   PREPARE t501_pregen2 FROM l_cmd2
   DECLARE t501_cugen2 SCROLL CURSOR WITH HOLD FOR t501_pregen2
 
   IF NOT  cl_sure(10,20) THEN
      CLOSE window t501_g2
      RETURN
   END IF
   #LET g_success = 'N' #TQC-B90214 add #TQC-DB0034 mark
   LET g_success = 'Y'  #TQC-DB0034
   #------------------------------
   #掃單據的單身,並更改單價及金額
   #------------------------------
   FOREACH t501_cugen2 into sr.*
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'   #TQC-B90214 add
         CALL cl_err('foreach :t501_cugen',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      MESSAGE sr.imn01,'-',sr.imn02
      
      SELECT cxk04 INTO l_uprice FROM cxk_file
       WHERE cxk01 = sr.imn03
      IF STATUS OR SQLCA.sqlcode THEN
        LET l_uprice = 0
      END IF
      
      LET l_amount  = l_uprice * sr.imn10
      UPDATE imn_file SET imn091 = l_uprice,
                          imn092 = l_amount
       WHERE imn01 = sr.imn01 AND imn02 = sr.imn02
      #IF SQLCA.sqlcode  THEN
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN  #TQC-B90214 mod
         MESSAGE "UPDATE ERROR!"
         EXIT FOREACH
      END IF
 
      UPDATE tlf_file SET tlf21 = l_amount
       WHERE tlf905 = sr.imn01 AND tlf906 = sr.imn02
      #IF SQLCA.sqlcode  THEN
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN  #TQC-B90214 mod
         MESSAGE "UPDATE tlf ERROR!"
         EXIT FOREACH
      END IF
   END FOREACH
   CLOSE WINDOW t501_g2
   #CALL cl_err('','axc-001',0)
   #No.TQC-B90214  --Begin
    IF g_success = 'Y'   THEN
       CALL cl_err('','axc-001',0)
    ELSE
       CALL cl_err('','axc-529',0)
    END IF
   #No.TQC-B90214  --End
   #CALL t501_bp_refresh()              #No.TQC-970229   #MOD-C20045 mark
   #MOD-C20045 ---add---str----
   LET l_ac = g_imn.getLength()
   IF l_ac != 0 THEN
      CALL t501_bp_refresh()
   END IF
   #MOD-C20045 ---add---end---
END FUNCTION
#FUN-770023 END

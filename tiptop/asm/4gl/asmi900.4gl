# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asmi900.4gl
# Descriptions...: 異動記錄報表格式維護
# Date & Author..: 91/09/07 By Lee
# Modify.........: No.MOD-480025 04/09/29 改寫法
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0048 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0033 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510031 05/02/14 By pengu 報表轉XML
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-650051 06/05/12 By kim "欄位來源" 開窗後挑選沒反應
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0150 06/10/26 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/14 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6C0041 06/12/08 By Ray 單身長度欄位輸入值小于0沒報錯
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-850091 08/-5/29 By lutingting報表轉為使用CR
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-960132 09/06/18 By kevin 新增MS SQL語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0082 09/11/18 By liuxqa standard sql
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70145 10/07/30 By alex 調整ASE SQL 
# Modify.........: No.TQC-960119 10/11/05 By sabrina (1)單身before row段的begin work應在if前斷之前
#                                                    (2)_copy段中，return前少了rollback work 
# Modify.........: No.FUN-A90024 10/11/23 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_smw           RECORD LIKE smw_file.*,       #異動報表內容單頭
    g_smw_t         RECORD LIKE smw_file.*,       #簽核等級 (舊值)
    g_smw_o         RECORD LIKE smw_file.*,       #簽核等級 (舊值)
    g_smw01_t       LIKE smw_file.smw01,   #簽核等級 (舊值)
      g_smx07 LIKE smx_file.smx07,
    g_smx           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        smx02       LIKE smx_file.smx02,   #簽核順序
        smx03       LIKE smx_file.smx03,   #人員代號
        smx04       LIKE smx_file.smx04,   #備註
        smx05       LIKE smx_file.smx05,   #備註
        descr       LIKE abh_file.abh11,#No.FUN-690010 VARCHAR(30),
        smx06       LIKE smx_file.smx06    #備註
                    END RECORD,
    g_smx_t         RECORD                 #程式變數 (舊值)
        smx02       LIKE smx_file.smx02,   #簽核順序
        smx03       LIKE smx_file.smx03,   #人員代號
        smx04       LIKE smx_file.smx04,   #備註
        smx05       LIKE smx_file.smx05,   #備註
        descr       LIKE abh_file.abh11,#No.FUN-690010 VARCHAR(30),
        smx06       LIKE smx_file.smx06    #備註
                    END RECORD,
    g_wc,g_wc2,g_sql     STRING,#TQC-630166
    g_rec_b              LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    g_Len1,g_Len2,g_Len3,g_max  LIKE type_file.num5,  #No.FUN-690010SMALLINT,
    g_uh                    LIKE type_file.num5,      #No.FUN-690010    SMALLINT,
    l_ac                    LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   gg_sql         STRING                 #No.FUN-850091
DEFINE   g_str          STRING                 #No,FUN-850091
DEFINE   l_table        STRING                 #No.FUN-850091
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0089
 
   #No.FUN-850091----start--
   LET gg_sql = "smw01.smw_file.smw01,",
                "smw02.smw_file.smw02,",
                "smw06.smw_file.smw06,",
                "smx05.smx_file.smx05,",
                "smx02.smx_file.smx02,",
                "smx03.smx_file.smx03,",
                "smx04.smx_file.smx04,",
                "smx06.smx_file.smx06"
   LET l_table = cl_prt_temptable('asmi900',gg_sql) CLIPPED
   IF l_table =-1 THEN EXIT PROGRAM END IF
   
   LET gg_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM gg_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',STATUS,1) EXIT PROGRAM
   END IF             
   #No.FUN-850091--end
   
   OPEN WINDOW i900_w WITH FORM "asm/42f/asmi900"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET g_forupd_sql = " SELECT * FROM smw_file WHERE smw01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i900_cl CURSOR FROM g_forupd_sql
 
   CALL i900_gx()

   CALL cl_query_prt_temptable()     #No.FUN-A90024
   CALL i900_menu()
 
   CLOSE WINDOW i900_w                 #結束畫面

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0089
END MAIN
 
#QBE 查詢資料
FUNCTION i900_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_smx.clear()
   CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_smw.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME g_wc ON smw01,smw02
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND smwuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND smwgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #      LET g_wc = g_wc clipped," AND smwgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('smwuser', 'smwgrup')
   #End:FUN-980030
 
 
   CONSTRUCT g_wc2 ON smx02,smx03,smx04,smx05,smx06    # 螢幕上取單身條件
        FROM s_smx[1].smx02,s_smx[1].smx03,s_smx[1].smx04,
             s_smx[1].smx05,s_smx[1].smx06
 
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
 
   MESSAGE " WAIT "
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  smw01 FROM smw_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY smw01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE smw_file. smw01 ",
                  "  FROM smw_file, smx_file ",
                  " WHERE smw01 = smx01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY smw01"
   END IF
 
   PREPARE i900_prepare FROM g_sql
   DECLARE i900_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i900_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM smw_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT smw01) FROM smw_file,smx_file WHERE ",
                "smx01=smw01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i900_precount FROM g_sql
   DECLARE i900_count CURSOR FOR i900_precount
 
END FUNCTION
 
 
FUNCTION i900_menu()
 
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i900_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i900_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i900_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i900_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i900_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i900_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_smw.smw01 IS NOT NULL THEN
                  LET g_doc.column1 = "smw01"
                  LET g_doc.value1 = g_smw.smw01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"     #FUN-4B0048
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_smx),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i900_a()
   IF s_shut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_smx.clear()
   INITIALIZE g_smw.* LIKE smw_file.*             #DEFAULT 設定
   LET g_smw01_t = NULL
   #預設值及將數值類變數清成零
   LET g_smw.smw06=0 #不需查看便可簽核
   LET g_smw_o.* = g_smw.*
   CALL cl_opmsg('a')
   WHILE TRUE
       LET g_smw.smwuser=g_user
       LET g_smw.smworiu = g_user #FUN-980030
       LET g_smw.smworig = g_grup #FUN-980030
       LET g_smw.smwgrup=g_grup
       LET g_smw.smwdate=g_today
       LET g_smw.smwacti='Y'              #資料有效
       CALL i900_i("a")                #輸入單頭
       IF INT_FLAG THEN                   #使用者不玩了
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           EXIT WHILE
       END IF
       IF g_smw.smw01 IS NULL THEN                # KEY 不可空白
           CONTINUE WHILE
       END IF
       INSERT INTO smw_file VALUES (g_smw.*)
       IF SQLCA.sqlcode THEN                     #置入資料庫不成功
#          CALL cl_err(g_smw.smw01,SQLCA.sqlcode,1)   #No.FUN-660138
           CALL cl_err3("ins","smw_file",g_smw.smw01,g_smw.smw02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
           CONTINUE WHILE
       END IF
       LET g_smw_t.* = g_smw.*
       CALL g_smx.clear()
       LET g_rec_b = 0
       CALL i900_b()                   #輸入單身
       SELECT smw01 INTO g_smw.smw01 FROM smw_file
           WHERE smw01 = g_smw.smw01
       LET g_smw01_t = g_smw.smw01        #保留舊值
       EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i900_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_smw.smw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_smw.* FROM smw_file WHERE smw01=g_smw.smw01
    IF g_smw.smwacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_smw.smw01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_smw01_t = g_smw.smw01
    LET g_smw_o.* = g_smw.*
    BEGIN WORK
 
    OPEN i900_cl USING g_smw.smw01
    IF STATUS THEN
       CALL cl_err("OPEN i900_cl:", STATUS, 1)
       CLOSE i900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i900_cl INTO g_smw.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i900_cl
        RETURN
    END IF
    CALL i900_show()
    WHILE TRUE
        LET g_smw01_t = g_smw.smw01
        LET g_smw.smwmodu=g_user
        LET g_smw.smwdate=g_today
        CALL i900_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_smw.*=g_smw_t.*
            CALL i900_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_smw.smw01 != g_smw01_t THEN            # 更改單號
            UPDATE smx_file SET smx01 = g_smw.smw01
                WHERE smx01 = g_smw01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('smx',SQLCA.sqlcode,0)  #No.FUN-660138
                CALL cl_err3("upd","smx_file",g_smw01_t,g_smw.smw02,SQLCA.sqlcode,"","smx",1)  #No.FUN-660138
                CONTINUE WHILE  
            END IF
        END IF
        UPDATE smw_file SET smw_file.* = g_smw.*
            WHERE smw01 = g_smw.smw01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","smw_file",g_smw.smw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i900_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i900_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_smw.smworiu,g_smw.smworig,
        g_smw.smw01,g_smw.smw02,g_smw.smw06,
        g_smw.smwuser,g_smw.smwgrup,g_smw.smwmodu,
            g_smw.smwdate,g_smw.smwacti
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i900_set_entry(p_cmd)
            CALL i900_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD smw01                  #報表代號
            IF NOT cl_null(g_smw.smw01) THEN
                IF g_smw.smw01 != g_smw01_t OR g_smw01_t IS NULL THEN
                    SELECT count(*) INTO g_cnt FROM smw_file
                        WHERE smw01 = g_smw.smw01
                    IF g_cnt > 0 THEN   #資料重複
                        CALL cl_err(g_smw.smw01,-239,0)
                        LET g_smw.smw01 = g_smw01_t
                        DISPLAY BY NAME g_smw.smw01
                        NEXT FIELD smw01
                    END IF
                END IF
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_smw.smwuser = s_get_data_owner("smw_file") #FUN-C10039
           LET g_smw.smwgrup = s_get_data_group("smw_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_smw.smw01 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_smw.smw01
            END IF
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD smw01
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(smw01) THEN
       #         LET g_smw.* = g_smw_t.*
       #         DISPLAY BY NAME g_smw.*
       #         NEXT FIELD smw01
       #     END IF
       #MOD-650015 --end
 
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
 
 
    END INPUT
END FUNCTION
 
FUNCTION i900_hd()
DEFINE
      l_l1  LIKE smw_file.smw03,     #No.FUN-690010 VARCHAR(68),
      l_l2  LIKE smw_file.smw03,     #No.FUN-690010 VARCHAR(68),
      l_l3  LIKE smw_file.smw04,     #No.FUN-690010 VARCHAR(68),
      l_l4  LIKE smw_file.smw04,     #No.FUN-690010 VARCHAR(68),
      l_l5  LIKE smw_file.smw05,     #No.FUN-690010 VARCHAR(68),
      l_l6  LIKE smw_file.smw05,     #No.FUN-690010 VARCHAR(68),
        p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
        LET p_row = 8 LET p_col = 2
        OPEN WINDOW i900_wh AT p_row,p_col
             WITH FORM "asm/42f/asmi9001"
              ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
        CALL cl_ui_locale("asmi9001")
 
      LET l_l1=g_smw.smw03[1,68]
      LET l_l2=g_smw.smw03[69,136]
      LET l_l3=g_smw.smw04[1,68]
      LET l_l4=g_smw.smw04[69,136]
      LET l_l5=g_smw.smw05[1,68]
      LET l_l6=g_smw.smw05[69,136]
      DISPLAY l_l1 TO l1
      DISPLAY l_l2 TO l2
      DISPLAY l_l3 TO l3
      DISPLAY l_l4 TO l4
      DISPLAY l_l5 TO l5
      DISPLAY l_l6 TO l6
      INPUT l_l1,l_l2,l_l3,l_l4,l_l5,l_l6
            WITHOUT DEFAULTS
            FROM l1,l2,l3,l4,l5,l6
     #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
 
      END INPUT
     #MOD-860081------add-----end---
 
      LET g_smw.smw03[1,68]=l_l1
      LET g_smw.smw03[69,136]=l_l2
      LET g_smw.smw04[1,68]=l_l3
      LET g_smw.smw04[69,136]=l_l4
      LET g_smw.smw05[1,68]=l_l5
      LET g_smw.smw05[69,136]=l_l6
      CLOSE WINDOW i900_wh
END FUNCTION
 
#Query 查詢
FUNCTION i900_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_smw.* TO NULL              #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_smx.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i900_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i900_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_smw.* TO NULL
    ELSE
        OPEN i900_count
        FETCH i900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i900_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
      MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690010 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i900_cs INTO g_smw.smw01
        WHEN 'P' FETCH PREVIOUS i900_cs INTO g_smw.smw01
        WHEN 'F' FETCH FIRST    i900_cs INTO g_smw.smw01
        WHEN 'L' FETCH LAST     i900_cs INTO g_smw.smw01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i900_cs INTO g_smw.smw01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)
        INITIALIZE g_smw.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_smw.* FROM smw_file WHERE smw01 = g_smw.smw01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("sel","smw_file",g_smw.smw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
        INITIALIZE g_smw.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0033權限控管
           LET g_data_owner=g_smw.smwuser
           LET g_data_group=g_smw.smwgrup
           CALL  i900_show()
 
    END IF
    CALL i900_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i900_show()
    LET g_smw_t.* = g_smw.*                #保存單頭舊值
    DISPLAY BY NAME g_smw.smworiu,g_smw.smworig,                              # 顯示單頭值
        g_smw.smw01,g_smw.smw02,
        g_smw.smw06,
        g_smw.smwuser,g_smw.smwgrup,g_smw.smwmodu,
        g_smw.smwdate,g_smw.smwacti
    CALL i900_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i900_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_smw.smw01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i900_cl USING g_smw.smw01
    IF STATUS THEN
       CALL cl_err("OPEN i900_cl:", STATUS, 1)
       CLOSE i900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i900_cl INTO g_smw.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i900_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "smw01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_smw.smw01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM smw_file WHERE smw01 = g_smw.smw01
       DELETE FROM smx_file WHERE smx01 = g_smw.smw01
       CLEAR FORM
       CALL g_smx.clear()
       OPEN i900_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE i900_cs
          CLOSE i900_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH i900_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i900_cs
          CLOSE i900_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i900_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i900_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i900_fetch('/')
       END IF
    END IF
    CLOSE i900_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i900_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_smw.smw01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i900_cl USING g_smw.smw01
    IF STATUS THEN
       CALL cl_err("OPEN i900_cl:", STATUS, 1)
       CLOSE i900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i900_cl INTO g_smw.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i900_show()
    IF cl_exp(0,0,g_smw.smwacti) THEN                   #確認一下
        LET g_chr=g_smw.smwacti
        IF g_smw.smwacti='Y' THEN
            LET g_smw.smwacti='N'
        ELSE
            LET g_smw.smwacti='Y'
        END IF
        UPDATE smw_file                    #更改有效碼
            SET smwacti=g_smw.smwacti
            WHERE smw01=g_smw.smw01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)   #No.FUN-660138
            CALL cl_err3("upd","smw_file",g_smw.smw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-66013
            LET g_smw.smwacti=g_chr
        END IF
        DISPLAY BY NAME g_smw.smwacti
    END IF
    CLOSE i900_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    l_possible      LIKE type_file.num5,  #用來設定判斷重複的可能性 #No.FUN-690010 SMALLINT
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_smx06_t       LIKE smx_file.smx06,   #欄位長度
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690010 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_smw.smw01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_smw.* FROM smw_file WHERE smw01=g_smw.smw01
    IF g_smw.smwacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_smw.smw01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT smx02,smx03,smx04,smx05,'',smx06,'',smx07 ",
      "   FROM smx_file ",
      "    WHERE smx01= ? ",
      "    AND smx02= ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
      LET g_uh=0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_smx WITHOUT DEFAULTS FROM s_smx.*
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
           #TQC-960119---add---start---
            BEGIN WORK
            OPEN i900_cl USING g_smw.smw01
            IF STATUS THEN
               CALL cl_err("OPEN i900_cl:", STATUS, 1)
               CLOSE i900_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i900_cl INTO g_smw.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                CLOSE i900_cl
                ROLLBACK WORK
                RETURN
            END IF
           #TQC-960119---add---end---
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_smx_t.* = g_smx[l_ac].*  #BACKUP
              #BEGIN WORK          #TQC-960119 mark
 
               OPEN i900_bcl USING g_smw.smw01,g_smx_t.smx02
               IF STATUS THEN
                  CALL cl_err("OPEN i900_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i900_bcl INTO g_smx[l_ac].*,g_smx07
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_smx_t.smx02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  LET l_smx06_t=g_smx[l_ac].smx06
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
          CALL i900_smx05d('d')
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO smx_file(smx01,smx02,smx03,smx04,
                                  smx05,smx06,smx07)
            VALUES(g_smw.smw01,g_smx[l_ac].smx02,g_smx[l_ac].smx03,
                     g_smx[l_ac].smx04,g_smx[l_ac].smx05,
                                        g_smx[l_ac].smx06,g_smx07)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_smx[l_ac].smx02,SQLCA.sqlcode,0)   #No.FUN-660138
               CALL cl_err3("ins","smx_file",g_smw.smw01,g_smx[l_ac].smx02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_smx[l_ac].* TO NULL      #900423
#           LET g_smx[l_ac].xxxxx = 'Y'       #Body default
          LET g_smx[l_ac].smx06=0
            LET l_smx06_t=0.0
            LET g_smx_t.* = g_smx[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD smx02
 
        BEFORE FIELD smx02                        #default 序號
            IF g_smx[l_ac].smx02 IS NULL OR
               g_smx[l_ac].smx02 = 0 THEN
                SELECT max(smx02)+1
                   INTO g_smx[l_ac].smx02
                   FROM smx_file
                   WHERE smx01 = g_smw.smw01
                IF g_smx[l_ac].smx02 IS NULL THEN
                    LET g_smx[l_ac].smx02 = 1
                END IF
            END IF
 
        AFTER FIELD smx02                        #check 序號是否重複
            IF g_smx[l_ac].smx02 IS NULL THEN
               LET g_smx[l_ac].smx02 = g_smx_t.smx02
            END IF
            IF NOT cl_null(g_smx[l_ac].smx02) THEN
                IF g_smx[l_ac].smx02 != g_smx_t.smx02 OR
                   g_smx_t.smx02 IS NULL THEN
                    SELECT count(*)
                        INTO l_n
                        FROM smx_file
                        WHERE smx01 = g_smw.smw01 AND
                              smx02 = g_smx[l_ac].smx02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_smx[l_ac].smx02 = g_smx_t.smx02
                        NEXT FIELD smx02
                    END IF
                END IF
            END IF
 
        AFTER FIELD smx03 #<=1行序<=3
            IF NOT cl_null(g_smx[l_ac].smx03) THEN
            IF g_smx[l_ac].smx03 <1 OR
                  g_smx[l_ac].smx03 >3 THEN
                  CALL cl_err('','mfg9004',0)
                  LET g_smx[l_ac].smx03=g_smx_t.smx03
                  NEXT FIELD smx03
            END IF
          END IF
 
 
        BEFORE FIELD smx05
            IF NOT cl_null(g_smx[l_ac].smx03) AND NOT cl_null(g_smx[l_ac].smx04) THEN
                SELECT COUNT(*) INTO g_cnt            #行序加上欄序不可重複
                    FROM smx_file
                    WHERE smx03=g_smx[l_ac].smx03
                      AND smx04=g_smx[l_ac].smx04
                      AND smx01=g_smw.smw01
                IF SQLCA.sqlcode OR g_cnt IS NULL THEN
                    LET g_cnt=0
                END IF
              #檢查是否重複
                #這裡要檢查的可能性有三: 1.新增時 2.更改時改不同 3.更改時改相同
                IF p_cmd='a' THEN
                   LET l_possible=0
                ELSE
                   IF g_smx_t.smx03 != g_smx[l_ac].smx03
                                    OR g_smx_t.smx04!=g_smx[l_ac].smx04 THEN
                       LET l_possible=0
                   ELSE
                       LET l_possible=1
                   END IF
                END IF
                IF g_cnt > l_possible THEN
                    CALL cl_err('','mfg9000',0)
                    LET g_smx[l_ac].smx03=g_smx_t.smx03
                    NEXT FIELD smx03
                END IF
            END IF
 
        AFTER FIELD smx05
           IF g_smx[l_ac].smx05 IS NOT NULL THEN
              IF g_smx_t.smx05 IS NULL OR g_smx_t.smx05!=g_smx[l_ac].smx05 THEN
                 CALL i900_smx05()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_smx[l_ac].smx05=g_smx_t.smx05
                    NEXT FIELD smx05
                 END IF
                 CALL i900_smx05d('a')
              END IF
           END IF
 
        AFTER FIELD smx06
            IF NOT cl_null(g_smx[l_ac].smx06) THEN
              IF g_smx[l_ac].smx06<=0 THEN   # 重要欄位不可空白
                    CALL cl_err(g_smx[l_ac].smx06,'mfg9243',0)     #No.TQC-6C0041
                    NEXT FIELD smx06
                END IF
            IF g_smx[l_ac].smx05='space' AND
                g_smx[l_ac].smx06>35 THEN
                     NEXT FIELD smx06
            END IF
                CALL i900_uh(l_smx06_t,g_smx[l_ac].smx06)
              LET l_smx06_t=g_smx[l_ac].smx06
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_smx_t.smx02 > 0 AND
               g_smx_t.smx02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM smx_file
                    WHERE smx01 = g_smw.smw01
                      AND smx02 = g_smx_t.smx02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_smx_t.smx02,SQLCA.sqlcode,0)#FUN-660138
                     CALL cl_err3("del","smx_file",g_smw.smw01,g_smx_t.smx02,SQLCA.sqlcode,"","",1)#FUN-660138
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                CALL i900_uh(g_smx[l_ac].smx06,0)
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_smx[l_ac].* = g_smx_t.*
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_smx[l_ac].smx02,-263,1)
                LET g_smx[l_ac].* = g_smx_t.*
            ELSE
                UPDATE smx_file SET
                         smx02 = g_smx[l_ac].smx02,
                         smx03 = g_smx[l_ac].smx03,
                         smx04 = g_smx[l_ac].smx04,
                         smx05 = g_smx[l_ac].smx05,
                   smx06 = g_smx[l_ac].smx06,
                         smx07 = g_smx07
                 WHERE smx01=g_smw.smw01
                   AND smx02=g_smx_t.smx02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_smx[l_ac].smx02,SQLCA.sqlcode,0)   #No.FUN-660138
                    CALL cl_err3("upd","smx_file",g_smw.smw01,g_smx_t.smx02,SQLCA.sqlcode,"","",1)  #No.FUN-660138
                    LET g_smx[l_ac].* = g_smx_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac           #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_smx[l_ac].* = g_smx_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_smx.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac          #FUN-D40030 add
            CLOSE i900_bcl
            COMMIT WORK
 
        ON ACTION CONTROLP #genero
        
#            CALL q_field(10,3,g_smw.smw01) RETURNING g_cnt
                CALL q_field(FALSE,TRUE,g_smw.smw01) RETURNING g_cnt
#                CALL FGL_DIALOG_SETBUFFER( g_cnt )
                #DISPLAY BY NAME g_cnt           #No.MOD-490344 #TQC-650051 mark
              IF g_cnt>0 THEN      #若有看上的, 則要重建單身
                  CALL i900_b_fill(' 1=1')
                    LET g_smx_t.* = g_smx[l_ac].*
                  LET l_ac_t = l_ac
              END IF
                DISPLAY "AFTER q_field"
 
      # ON ACTION CONTROLN
      #     CALL i900_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(smx02) AND l_ac > 1 THEN
                LET g_smx[l_ac].* = g_smx[l_ac-1].*
                NEXT FIELD smx02
            END IF
 
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
 
        END INPUT
 
      IF g_uh THEN
            UPDATE smw_file
                  SET smw06=g_smw.smw06
                  WHERE smw01=g_smw.smw01
      END IF
 
    #FUN-5B0113-begin
     LET g_smw.smwmodu = g_user
     LET g_smw.smwdate = g_today
     UPDATE smw_file SET smwmodu = g_smw.smwmodu,smwdate = g_smw.smwdate
      WHERE smw01 = g_smw.smw01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('upd smw',SQLCA.SQLCODE,1)   #No.FUN-660138
        CALL cl_err3("upd","smw_file",g_smw.smw01,"",SQLCA.sqlcode,"","upd smw",1)  #No.FUN-66013
     END IF
     DISPLAY BY NAME g_smw.smwmodu,g_smw.smwdate
    #FUN-5B0113-end
 
    CLOSE i900_bcl
    COMMIT WORK
    CALL i900_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i900_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM smw_file WHERE smw01 = g_smw.smw01
         INITIALIZE g_smw.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#更新單頭的報表長度欄位
FUNCTION i900_uh(l_smx06,p_smx06)
DEFINE
      l_len LIKE type_file.num5,   #No.FUN-690010 SMALLINT,
      l_smx06      LIKE smx_file.smx06,  #舊的值
      p_smx06      LIKE smx_file.smx06   #新的值
 
    IF l_smx06 IS NULL THEN LET l_smx06 = 0 END IF
    IF p_smx06 IS NULL THEN LET p_smx06 = 0 END IF
    IF g_Len1 IS NULL THEN LET g_Len1 = 0 END IF
    IF g_Len2 IS NULL THEN LET g_Len2 = 0 END IF
    IF g_Len3 IS NULL THEN LET g_Len3 = 0 END IF
      #因為報表可容納三行, 需所輸入的行是依隨機的方式輸入
      #故需比較三行個別的長度, 其中最長的為報表長度
    IF g_smx[l_ac].smx03=1 THEN LET g_Len1 = g_Len1 + p_smx06 - l_smx06 END IF
    IF g_smx[l_ac].smx03=2 THEN LET g_Len2 = g_Len2 + p_smx06 - l_smx06 END IF
    IF g_smx[l_ac].smx03=3 THEN LET g_Len3 = g_Len3 + p_smx06 - l_smx06 END IF
      #取得當中最大的一個顯示
      LET l_len=g_Len1
      IF g_Len2>g_Len1 THEN LET l_len=g_Len2 END IF
      IF g_Len3>l_len THEN LET l_len=g_Len3 END IF
      LET g_smw.smw06=l_len
    DISPLAY BY NAME g_smw.smw06
      LET g_uh=1      #表示資料有更動過, 在結束輸入後, 需更新單頭資料
END FUNCTION
 
#檢查欄位來源
FUNCTION  i900_smx05()
DEFINE
#       l_coltype SMALLINT,
        l_coltype LIKE col_file.col01,   #No.FUN-690010 VARCHAR(15),
        l_collength  LIKE col_file.col02,#No.FUN-690010 SMALLINT,
        l_tabid LIKE col_file.col02,#No.FUN-690010SMALLINT,
        l_prec   LIKE col_file.col02,#No.FUN-690010 SMALLINT,            # Decimal的精確度
        l_scale  LIKE col_file.col02,#No.FUN-690010 SMALLINT,            # Decimal的大小
        l_DecLen  LIKE smx_file.smx05,#No.FUN-690010 VARCHAR(10),
        l_db_type LIKE  ahe_file.ahe01#No.FUN-690010 VARCHAR(3)
DEFINE  l_table_name     LIKE sch_file.sch01    #FUN-A90024
 
   LET g_errno = ' '
   IF g_smx[l_ac].smx05='space' THEN
      IF g_smx[l_ac].smx06=0 OR g_smx[l_ac].smx06 IS NULL THEN
         LET g_smx[l_ac].smx06=1
      END IF
      LET g_smx07=0
      RETURN
   END IF
 
   #欄位來源不可為tlf_file或ima_file等以外的檔案
   LET l_DecLen=g_smx[l_ac].smx05[1,3]
   IF l_DecLen!='ima' AND l_DecLen!='tlf' THEN
      LET g_errno='mfg9001'
      RETURN
   END IF
 
    #-----No.MOD-480025-----
   LET l_db_type=cl_db_get_database_type()
   #發現到光以colname去讀資料時, 會產生select出一筆以上資料的
   #錯誤, 故在此加上tabid以避重複, 效果不錯
   ### qazzaq:一個資料庫內colname應該不會有重覆的情形發生
   ###        故先移除tabid

   LET l_DecLen=l_DecLen CLIPPED,'_file'

   #---FUN-A90024---start-----
   #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
   #目前統一用sch_file紀錄TIPTOP資料結構
   #CASE l_db_type
   #   WHEN "IFX" 
   #      SELECT coltype,collength INTO l_coltype,l_collength
   #        FROM syscolumns
   #       WHERE colname=g_smx[l_ac].smx05
   # 
   #      CASE
   #         WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9180'
   #         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   #      END CASE
   #      IF NOT cl_null(g_errno) THEN
   #         RETURN
   #      END IF
   #      CASE
   #         WHEN l_coltype=0 LET g_smx[l_ac].smx06=l_collength+1      #Char
   #         WHEN l_coltype=1 LET g_smx[l_ac].smx06=6                        #Smallint
   #         WHEN l_coltype=2 LET g_smx[l_ac].smx06=11                        #Integer
   #         WHEN l_coltype=6 LET g_smx[l_ac].smx06=11                        #Serial
   #         WHEN l_coltype=7 LET g_smx[l_ac].smx06=9                        #Date
   #         OTHERWISE                                                                        #Decimal
   #            #Decimal的位數及其小數, 其內部表示是以smallint
   #            #存檔, 故需以下列公式推算出其位數. 設其值為x 則
   #            #Precision=x>>8 & 0xff      (小數)
   #            #Scale=x & 0xff                  (位數)
   #            #但因4GL無法做>> 及&的運算, 故改以下列方式運算之
   #            #Precision=x/256
   #            #Scale=x MOD 16
   #            LET l_scale=l_collength MOD 16
   #            LET l_prec=(l_collength/256)+1
   #            LET g_smx[l_ac].smx06=l_prec+(l_scale/10)
   #      END CASE
   #      LET g_smx07=l_coltype
   #
   #   WHEN "ASE"     #FUN-A70145
   #      LET g_sql = "SELECT b.name,a.length,a.scale " ,
   #                  "  FROM  sys.syscolumns a,sys.types b ",
   #                  " WHERE a.name = ? AND a.xtype = b.user_type_id"
   #        
   #      PREPARE ase_pre FROM g_sql
   #      DECLARE ase_curs CURSOR FOR ase_pre
   #      OPEN ase_curs USING g_smx[l_ac].smx05 
   #      FETCH ase_curs  INTO l_coltype,l_collength,l_scale         
   #      CLOSE ase_curs
   #      
   #      CASE
   #         WHEN l_coltype='nvarchar'
   #            LET g_smx[l_ac].smx06=(l_collength/2)+1      #Char
   #            LET l_coltype=0
   #         WHEN l_coltype='varchar'
   #            LET g_smx[l_ac].smx06=(l_collength)+1      #Char
   #            LET l_coltype=0   
   #         WHEN l_coltype='smallint' 
   #            LET g_smx[l_ac].smx06=6
   #            LET l_coltype=1
   #         WHEN l_coltype='date'
   #            LET g_smx[l_ac].smx06=9
   #            LET l_coltype=7 
   #         OTHERWISE               
   #            LET g_smx[l_ac].smx06=l_collength + 2
   #            LET l_coltype=5  #decimal
   #     END CASE         
   #     LET g_smx07=l_coltype
   #
   #   WHEN "MSV"     #FUN-960132 add SQL Server
   #      LET g_sql = "SELECT b.name,a.length,a.scale " ,
   #                  "  FROM  sys.syscolumns a,sys.types b ",
   #                  " WHERE a.name = ? AND a.xtype = b.user_type_id"
   #        
   #      PREPARE msv_pre FROM g_sql
   #      DECLARE msv_curs CURSOR FOR msv_pre
   #      OPEN msv_curs USING g_smx[l_ac].smx05 
   #      FETCH msv_curs  INTO l_coltype,l_collength,l_scale         
   #      CLOSE msv_curs
   #      
   #      CASE
   #         WHEN l_coltype='nvarchar'
   #            LET g_smx[l_ac].smx06=(l_collength/2)+1      #Char
   #            LET l_coltype=0
   #         WHEN l_coltype='varchar'
   #            LET g_smx[l_ac].smx06=(l_collength)+1      #Char
   #            LET l_coltype=0   
   #         WHEN l_coltype='smallint' 
   #            LET g_smx[l_ac].smx06=6
   #            LET l_coltype=1
   #         WHEN l_coltype='date'
   #            LET g_smx[l_ac].smx06=9
   #            LET l_coltype=7 
   #         OTHERWISE               
   #            LET g_smx[l_ac].smx06=l_collength + 2
   #            LET l_coltype=5  #decimal
   #     END CASE         
   #     LET g_smx07=l_coltype
   #
   #  WHEN "ORA"
   #     #FUN-9B0082 mod--begin
   #     #SELECT lower(data_type),to_char(decode(data_precision,null,
   #     #       data_length,data_precision),'9999.99'),data_scale
   #
   #     SELECT lower(data_type),data_scale,
   #       INTO l_coltype,l_scale
   #       FROM user_tab_columns
   #      WHERE lower(column_name)=g_smx[l_ac].smx05
   #      CALL cl_get_field_width(g_dbs,l_DecLen,g_smx[l_ac].smx05) RETURNING l_collength
   #     #FUN-9B0082 mod --end 
   #     
   #     CASE
   #        WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9180'
   #       #WHEN l_genacti='N' LET g_errno = '9028'
   #        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   #     END CASE
   #     IF NOT cl_null(g_errno) THEN
   #        RETURN
   #     END IF
   #     CASE
   #         WHEN l_coltype='varchar2'
   #              LET g_smx[l_ac].smx06=l_collength+1      #Char
   #              LET l_coltype=0
   #         WHEN l_coltype='date'
   #              LET g_smx[l_ac].smx06=9
   #              LET l_coltype=7
   #         OTHERWISE
   #            #Decimal的位數及其小數, 其內部表示是以smallint
   #            #存檔, 故需以下列公式推算出其位數. 設其值為x 則
   #            #Precision=x>>8 & 0xff      (小數)
   #            #Scale=x & 0xff                  (位數)
   #            #但因4GL無法做>> 及&的運算, 故改以下列方式運算之
   #            #Precision=x/256
   #            #Scale=x MOD 16
   #            IF l_collength=5 AND l_scale=0 THEN
   #               LET g_smx[l_ac].smx06=6
   #               LET l_coltype=1
   #            ELSE
   #               IF l_collength=10 AND l_scale=0 THEN
   #                  LET g_smx[l_ac].smx06=11
   #                  LET l_coltype=2
   #               ELSE
   #                  LET g_smx[l_ac].smx06=l_collength+2
   #                  LET l_coltype=5
   #               END IF
   #           END IF
   #     END CASE
   #     LET g_smx07=l_coltype
   #     #-----No.MOD-480025-----
   #END CASE

   LET l_table_name = cl_get_table_name(g_smx[l_ac].smx05 CLIPPED)
   
   IF cl_null(l_table_name) THEN
      LET g_errno = 'mfg9180'
   ELSE
      LET g_errno = SQLCA.SQLCODE USING '-------'
   END IF

   IF NOT cl_null(g_errno) THEN
      RETURN
   END IF

   CALL cl_query_prt_getlength(g_smx[l_ac].smx05, 'N', 's', 0)
   SELECT xabc06, xabc04, xabc05 INTO l_coltype, l_collength, l_scale 
     FROM xabc WHERE xabc02 = g_smx[l_ac].smx05
   IF l_scale = -1 THEN
      LET l_scale = NULL
   END IF

   CASE
       WHEN l_coltype = 'char'
            LET g_smx[l_ac].smx06 = l_collength + 1 
            LET l_coltype = 0
       WHEN l_coltype = 'varchar'
            LET g_smx[l_ac].smx06 = (l_collength) + 1  
            LET l_coltype = 0   
       WHEN l_coltype = 'varchar2'
            LET g_smx[l_ac].smx06 = l_collength + 1 
            LET l_coltype = 0
       WHEN l_coltype = 'nvarchar'
            LET g_smx[l_ac].smx06 = (l_collength / 2) + 1 
            LET l_coltype = 0
       WHEN l_coltype='nvarchar2'
            LET g_smx[l_ac].smx06 = (l_collength / 2) + 1
            LET l_coltype = 0
       WHEN l_coltype = 'smallint' 
            LET g_smx[l_ac].smx06 = 6
            LET l_coltype = 1 
       WHEN l_coltype = 'integer' 
            LET g_smx[l_ac].smx06 = 11
            LET l_coltype = 2
       WHEN l_coltype = 'date'
            LET g_smx[l_ac].smx06 = 9
            LET l_coltype = 7
       OTHERWISE
            #Decimal的位數及其小數, 其內部表示是以smallint
            #存檔, 故需以下列公式推算出其位數. 設其值為x 則
            #Precision=x>>8 & 0xff      (小數)
            #Scale=x & 0xff                  (位數)
            #但因4GL無法做>> 及&的運算, 故改以下列方式運算之
            #Precision=x/256
            #Scale=x MOD 16
            IF l_collength = 5 AND l_scale = 0 THEN
               LET g_smx[l_ac].smx06 = 6
               LET l_coltype = 1
            ELSE
               IF l_collength = 10 AND l_scale = 0 THEN
                  LET g_smx[l_ac].smx06 = 11
                  LET l_coltype = 2
               ELSE
                  LET g_smx[l_ac].smx06 = l_collength + 2
                  LET l_coltype = 5
               END IF
           END IF
   END CASE
   LET g_smx07 = l_coltype
   #---FUN-A90024---end-------  
END FUNCTION
 
FUNCTION i900_smx05d(p_cmd)
DEFINE
      p_cmd LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
      l_descr LIKE type_file.chr1000#No.FUN-690010CHAR(50)            # 欄位說明
 
  #No.FUN-850091----start--
  DEFINE  l_i   LIKE  type_file.num5          
      LET l_i = 0     
      #FOR g_i=20 TO g_max      
      #      LET l_descr=g_x[g_i].subString(1,10)
      #      IF l_descr=g_smx[l_ac].smx05 THEN
      #            LET l_descr=g_x[g_i].subString(11,(length(g_x[g_i])))
      #            LET g_smx[l_ac].descr=l_descr
      #            IF p_cmd='a' THEN
      #            END IF
      #            EXIT FOR
      #      END IF
      #END FOR
      
      FOR  g_i=20 TO g_max
           LET l_i = g_i+680
           CALL cl_getmsg('asm-l_i',g_lang) RETURNING l_descr
           LET l_descr = l_descr[1,10]
           IF l_descr=g_smx[l_ac].smx05 THEN
              LET l_descr = l_descr[11,(length(l_descr))]
              LET g_smx[l_ac].descr=l_descr
              IF p_cmd='a' THEN            
              END IF                       
              EXIT FOR                     
           END IF
      END FOR 
      #No.FUN-850091--end       
END FUNCTION
 
FUNCTION i900_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CLEAR gen02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON smx02,smx03,smx04,smx05,smx05
            FROM s_smx[1].smx02,s_smx[1].smx03,s_smx[1].smx04,
                        s_smx[1].smx05,s_smx[1].smx06
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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i900_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i900_b_fill(p_wc2)              #BODY FILL UP
DEFINE
      l_len   LIKE type_file.num5,  #No.FUN-690010 SMALLINT,
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT smx02,smx03,smx04,smx05,'',smx06",
        " FROM smx_file",
        " WHERE smx01 ='",g_smw.smw01,"'"  # AND ",  #單頭
    #No.FUN-8B0123 mark---Begin
    #   p_wc2 CLIPPED,                     #單身
    #   " ORDER BY 1"
    #No.FUN-8B0123--------End
    #No.FUN-8B0123---Begin
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i900_pb FROM g_sql
    DECLARE smx_curs                       #SCROLL CURSOR
        CURSOR FOR i900_pb
 
    CALL g_smx.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
      LET g_Len1=0 LET g_Len2=0 LET g_Len3=0
    FOREACH smx_curs INTO g_smx[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
 
            LET l_ac=g_cnt
            #若是NULL, 表示該資料尚未有長度等資料, 則重建之
            IF g_smx[g_cnt].smx06 IS NULL THEN
                  CALL i900_smx05()                              #計算長度
                  UPDATE smx_file                                    #更新資料庫
                        SET smx06=g_smx[g_cnt].smx06,
                              smx07=g_smx07
                        WHERE smx01=g_smw.smw01 AND
                              smx02=g_smx[g_cnt].smx02
            END IF
 
            CALL i900_smx05d('d')
 
          IF g_smx[g_cnt].smx03=1 THEN LET g_Len1=g_Len1+g_smx[g_cnt].smx06 END IF
          IF g_smx[g_cnt].smx03=2 THEN LET g_Len2=g_Len2+g_smx[g_cnt].smx06 END IF
          IF g_smx[g_cnt].smx03=3 THEN LET g_Len3=g_Len3+g_smx[g_cnt].smx06 END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    CALL g_smx.deleteElement(g_cnt)
    IF SQLCA.sqlcode THEN CALL cl_err('foreach:',SQLCA.sqlcode,1) END IF
    LET g_rec_b = g_cnt - 1
    LET l_len=g_Len1
    IF g_Len2>g_Len1 THEN LET l_len=g_Len2 END IF
    IF g_Len3>l_len THEN LET l_len=g_Len3 END IF
    LET g_smw.smw06=l_len
    DISPLAY BY NAME g_smw.smw06
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_smx TO s_smx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
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
         CALL i900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
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
     #-----No.MOD-480025 Mark-----
    #@ON ACTION 單頭修改
    # ON ACTION modify_header
    #    LET g_action_choice="modify_header"
    #    EXIT DISPLAY
    #-----END--------------------
 
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
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
      ON ACTION exporttoexcel       #FUN-4B0048
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i900_copy()
DEFINE
    l_smw            RECORD LIKE smw_file.*,
    l_oldno,l_newno      LIKE smw_file.smw01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_smw.smw01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i900_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT l_newno FROM smw01
        AFTER FIELD smw01
            IF NOT cl_null(l_newno) THEN
                SELECT count(*) INTO g_cnt FROM smw_file
                    WHERE smw01 = l_newno
                IF g_cnt > 0 THEN
                    CALL cl_err(l_newno,-239,0)
                    NEXT FIELD smw0e
                END IF
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_smw.smw01
        RETURN
    END IF
    LET l_smw.* = g_smw.*
    LET l_smw.smw01  =l_newno   #新的鍵值
    LET l_smw.smwuser=g_user    #資料所有者
    LET l_smw.smwgrup=g_grup    #資料所有者所屬群
    LET l_smw.smwmodu=NULL      #資料修改日期
    LET l_smw.smwdate=g_today   #資料建立日期
    LET l_smw.smwacti='Y'       #有效資料
    BEGIN WORK
    LET l_smw.smworiu = g_user      #No.FUN-980030 10/01/04
    LET l_smw.smworig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO smw_file VALUES (l_smw.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('smw:',SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("ins","smw_file",l_smw.smw01,"",SQLCA.sqlcode,"","smw:",1)  #No.FUN-660138
        ROLLBACK WORK        #TQC-960119 add
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM smx_file         #單身複製
        WHERE smx01=g_smw.smw01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_smw.smw01,SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("ins","x",g_smw.smw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660138
        ROLLBACK WORK        #TQC-960119 add
        RETURN
    END IF
    UPDATE x
        SET smx01=l_newno
    INSERT INTO smx_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('smx:',SQLCA.sqlcode,0)   #No.FUN-660138
        CALL cl_err3("ins","smx_file",g_smw.smw01,g_smw.smw02,SQLCA.sqlcode,"","smx:",1)  #No.FUN-660138
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_smw.smw01
     SELECT smw_file.* INTO g_smw.* FROM smw_file WHERE smw01 = l_newno
     CALL i900_u()
     CALL i900_b()
     #SELECT smw_file.* INTO g_smw.* FROM smw_file WHERE smw01 = l_oldno  #FUN-C80046
     #CALL i900_show()  #FUN-C80046
END FUNCTION
 
FUNCTION i900_head()
DEFINE
      l_FileName    LIKE type_file.chr1000,#No.FUN-690010 VARCHAR(50),
        ls_msg      LIKE type_file.chr1000#No.FUN-690010CHAR(100)
 
      IF g_smw.smw01 IS NULL THEN RETURN END IF
#       IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
            CALL cl_prtmsg(8,20,'mfg9003',g_lang) RETURNING l_FileName
#       ELSE
#           CALL cl_prtmsg(0,0,'mfg9003',g_lang) RETURNING l_FileName
#       END IF
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
      LET g_dash='load-hd ',g_smw.smw01,' ',l_filename
      RUN g_dash
END FUNCTION
 
FUNCTION i900_gx()
DEFINE
      l_za05 LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(40)
 
      LET g_max=g_i
END FUNCTION
 
FUNCTION i900_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    sr              RECORD
        smw01       LIKE smw_file.smw01,   #報表代號
        smw02       LIKE smw_file.smw02,   #報表名稱
        smw06       LIKE smw_file.smw06,   #報表長度
        smx02       LIKE smx_file.smx02,   #項次
        smx03       LIKE smx_file.smx03,   #行序
        smx04       LIKE smx_file.smx04,   #欄序
        smx05       LIKE smx_file.smx05,   #欄位來源
        smx06       LIKE smx_file.smx06,   #長度
        smwacti     LIKE smw_file.smwacti
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #  #No.FUN-690010 VARCHAR(40)
 
    CALL cl_del_data(l_table)  #No.FUN-850091
    
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asmi900'  #No.FUN-850091
    
    IF cl_null(g_wc) THEN
       LET g_wc=" smw01='",g_smw.smw01,"'"
    END IF
    IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF 
    #CALL cl_wait()                             #No.FUN-850091
    #CALL cl_outnam('asmi900') RETURNING l_name #No.FUN-850091
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT smw01,smw02,smw06,",
          "smx02,smx03,smx04,smx05,smx06,smwacti",
          " FROM smw_file,smx_file",
          " WHERE smw01 = smx01 AND ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i900_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i900_co                         # SCROLL CURSOR
         CURSOR FOR i900_p1
 
    #START REPORT i900_rep TO l_name   #No.FUN-850091
 
    FOREACH i900_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)                 
           EXIT FOREACH
        END IF
       #No.FUN-850091---start--
        #OUTPUT TO REPORT i900_rep(sr.*)
        EXECUTE insert_Prep USING
             sr.smw01,sr.smw02,sr.smw06,sr.smx05,sr.smx02,sr.smx03,
             sr.smx04,sr.smx06
        #No.FUN-850091--end
    END FOREACH
 
    #No.FUN-850091---start--
    LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'smw01,smw02,smx02,smx03,smx04,smx05,smx06')
       RETURNING g_wc
    END IF
    LET g_str = g_wc
    CALL cl_prt_cs3('asmi900','asmi900',gg_sql,g_str)
    #FINISH REPORT i900_rep
 
    CLOSE i900_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    #No.FUN-850091--end
END FUNCTION    
 
#No.FUN-850091---start--
#REPORT i900_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
#    l_sw            LIKE type_file.chr1,   #No.FUN-690010 VARCHAR(1),
#    l_i             LIKE type_file.num5,   #No.FUN-690010 SMALLINT
#    l_descr         LIKE type_file.chr1000,#No.FUN-690010CHAR(50),
#    sr              RECORD
#        smw01       LIKE smw_file.smw01,   #報表代號
#        smw02       LIKE smw_file.smw02,   #報表名稱
#        smw06       LIKE smw_file.smw06,   #報表長度
#        smx02       LIKE smx_file.smx02,   #項次
#        smx03       LIKE smx_file.smx03,   #行序
#        smx04       LIKE smx_file.smx04,   #欄序
#        smx05       LIKE smx_file.smx05,   #欄位來源
#        smx06       LIKE smx_file.smx06,   #長度
#        smwacti     LIKE smw_file.smwacti
#                    END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line   #No.MOD-580242
#
#    ORDER BY sr.smw01,sr.smx03,sr.smx04
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINTX name=H1 g_x[201],g_x[202],g_x[203],g_x[204],g_x[205],g_x[206]
#            PRINTX name=H2 g_x[207],g_x[208],g_x[209],g_x[210],g_x[211],g_x[212]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.smw01  # 報表代號
#            #IF sr.smwacti = 'N' THEN PRINT '*' ; END IF
#            PRINTX name=D1  COLUMN g_c[201],sr.smw01,  #報表代號
#                   COLUMN g_c[205],sr.smw02,
#                   COLUMN g_c[206], sr.smw06 USING '##&'
#
#        ON EVERY ROW
#               LET l_descr=' '
#             FOR g_i=20 TO g_max
#                   IF sr.smx05 = g_x[g_i].subString(1,10)  THEN #[1,10] THEN
#                      LET l_descr= g_x[g_i].subString(11,(length(g_x[g_i])))
#                      EXIT FOR
#                   END IF
#             END FOR
#           LET l_descr=sr.smx05[1,8] CLIPPED,' ',l_descr
#           PRINTX name=D2
#                 COLUMN g_c[208],sr.smx02 USING '###&',
#                 COLUMN g_c[209],sr.smx03 USING '###&',
#                 COLUMN g_c[210],sr.smx04 USING '###&',
#                 COLUMN g_c[211],l_descr CLIPPED,
#                 COLUMN g_c[212],sr.smx06 USING '#&.&'
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240
#               CALL cl_wcchp(g_wc,'smw01,smw02,smx02,smx05,smx06')
#                    RETURNING g_sql
#            #TQC-630166
#            {
#               IF g_sql[001,080] > ' ' THEN
#                   PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
#               IF g_sql[071,140] > ' ' THEN
#                   PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
#               IF g_sql[141,210] > ' ' THEN
#                   PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
#            }
#              CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#
#               PRINT g_dash[1,g_len]
#            END IF
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-850091---end
#單頭
FUNCTION i900_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("smw01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i900_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("smw01",FALSE)
       END IF
   END IF
 
END FUNCTION


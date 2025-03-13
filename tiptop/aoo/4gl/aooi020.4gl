# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aooi020.4gl
# Descriptions...: 簽核等級
# Date & Author..: 91/06/10 By LEE
# Modify.........: 92/05/05 By David Wang
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0020 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0044 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0098 05/02/02 By pengu 報表轉XML
# Modify.........: No.MOD-540144 05/04/28 By Carol 單身"順序"欄位Default最大一筆加一的功能
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660131 06/06/19 By Cheunl cl_err --> cl_err3
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0081 06/11/01 By atsea l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/13 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740021 07/04/05 By chenl   單身資料不顯示。
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-760083 07/07/03 By mike 報表格式改為crystal report
# Modify.........: No.MOD-8A0032 08/10/07 By claire 新增後直接按無效單身無法顯示
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_aze           RECORD LIKE aze_file.*,       #簽核等級 (假單頭)
    g_aze_t         RECORD LIKE aze_file.*,       #簽核等級 (舊值)
    g_aze_o         RECORD LIKE aze_file.*,       #簽核等級 (舊值)
    g_aze01_t       LIKE aze_file.aze01,   #簽核等級 (舊值)
    g_azc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        azc02       LIKE azc_file.azc02,   #簽核順序
        azc03       LIKE azc_file.azc03,   #人員代號
        gen02       LIKE gen_file.gen02,   #人員姓名
        gen03       LIKE gen_file.gen03,   #Department 
        gem02       LIKE gem_file.gem02,   #Job Description
        azc04       LIKE azc_file.azc04    #備註
                    END RECORD,
    g_azc_t         RECORD                 #程式變數 (舊值)
        azc02       LIKE azc_file.azc02,   #簽核順序
        azc03       LIKE azc_file.azc03,   #人員代號
        gen02       LIKE gen_file.gen02,   #人員姓名
        gen03       LIKE gen_file.gen03,   #Department 
        gem02       LIKE gem_file.gem02,   #Job Description
        azc04       LIKE azc_file.azc04    #備註
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,        #No.TQC-740021
    l_za05          LIKE za_file.za05,
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680102 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680102 SMALLINT
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680102 SMALLINT
DEFINE g_str          STRING                              #No.FUN-760083 
DEFINE l_table        STRING                              #No.FUN-760083 
DEFINE g_forupd_sql   STRING                       #SELECT ... FOR UPDATE SQL     
DEFINE g_chr          LIKE aze_file.azeacti        #No.FUN-680102 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680102 SMALLINT
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680102CHAR(72)
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680102 SMALLINT
 
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0081 #FUN-BB0047 mark
 
#No.FUN-760083 --BEGIN--                                                                                                            
    LET g_sql="aze01.aze_file.aze01,",                                                                                              
              "aze02.aze_file.aze02,",                                                                                              
              "aze03.aze_file.aze03,",                                                                                              
              "aze04.aze_file.aze04,",                                                                                              
              "aze05.aze_file.aze05,",                                                                                              
              "aze06.aze_file.aze06,",                                                                                              
              "aze07.aze_file.aze07,",                                                                                              
              "aze09.aze_file.aze09,",                                                                                              
              "aze10.aze_file.aze10,",                                                                                              
              "aze11.aze_file.aze11,",                                                                                              
              "azc02.azc_file.azc02,",                                                                                              
              "azc03.azc_file.azc03,",                                                                                              
              "gen02.gen_file.gen02,",                                                                                              
              "azeacti.aze_file.azeacti"                                                                                            
    LET l_table=cl_prt_temptable("aooi020",g_sql) CLIPPED                                                                           
    IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                          
    LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                             
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"                                                                                
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep: ',status,1)  EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#No.FUN-760083  --END--                  
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
    OPEN WINDOW i020_w WITH FORM "aoo/42f/aooi020"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
        
    CALL g_x.clear()
 
    LET g_forupd_sql = "SELECT * FROM aze_file WHERE aze01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_cl CURSOR FROM g_forupd_sql
 
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN
 
 
#QBE 查詢資料
FUNCTION i020_cs()
 
   DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
   CLEAR FORM                             #清除畫面
   CALL g_azc.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_aze.* TO NULL    #No.FUN-750051
 
   CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
      aze01,aze02,aze03,aze04,aze10,aze11,aze09,aze07 ,
      azeuser,azegrup,azemodu,azedate,azeacti
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(azc03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_azc[1].azc03
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azc03
               CALL i020_azc03('a')
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
   #       LET g_wc = g_wc clipped," AND azeuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND azegrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND azegrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('azeuser', 'azegrup')
   #End:FUN-980030
 
   CONSTRUCT g_wc2 ON azc02,azc03,azc04                # 螢幕上取單身條件
        FROM s_azc[1].azc02,s_azc[1].azc03,s_azc[1].azc04
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(azc03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO azc03
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
      LET g_sql = "SELECT  aze01 FROM aze_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY aze01"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE  aze01 ",
                  "  FROM aze_file LEFT OUTER JOIN azc_file ON aze01=azc01",
                  "   WHERE ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY aze01"
   END IF
 
   PREPARE i020_prepare FROM g_sql
   DECLARE i020_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i020_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM aze_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT aze01) FROM aze_file,azc_file WHERE ",
                 "azc01=aze01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i020_precount FROM g_sql
   DECLARE i020_count CURSOR FOR i020_precount
   OPEN i020_count
   FETCH i020_count INTO g_row_count
   CLOSE i020_count
 
END FUNCTION
 
 
 
FUNCTION i020_menu()
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i020_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i020_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i020_u()
            END IF
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL i020_x()
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i020_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth()
               THEN CALL i020_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_aze.aze01 IS NOT NULL THEN
                  LET g_doc.column1 = "aze01"
                  LET g_doc.value1 = g_aze.aze01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i020_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_azc.clear()
    INITIALIZE g_aze.* LIKE aze_file.*             #DEFAULT 設定
    LET g_aze01_t = NULL
    #預設值及將數值類變數清成零
    LET g_aze.aze07='N' #不需查看便可簽核
    LET g_aze_o.* = g_aze.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aze.azeuser=g_user
        LET g_aze.azeoriu = g_user #FUN-980030
        LET g_aze.azeorig = g_grup #FUN-980030
        LET g_aze.azegrup=g_grup
        LET g_aze.azedate=g_today
        LET g_aze.azeacti='Y'              #資料有效
        CALL i020_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_aze.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_aze.aze01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO aze_file VALUES (g_aze.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_aze.aze01,SQLCA.sqlcode,1)   #No.FUN-660131
            CALL cl_err3("ins","aze_file",g_aze.aze01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        SELECT aze01 INTO g_aze.aze01 FROM aze_file
            WHERE aze01 = g_aze.aze01
        LET g_aze01_t = g_aze.aze01        #保留舊值
        LET g_aze_t.* = g_aze.*
 
        CALL g_azc.clear()
        LET g_rec_b = 0 
        CALL i020_b()                   #輸入單身
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i020_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_aze.aze01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_aze.* FROM aze_file WHERE aze01=g_aze.aze01
    IF g_aze.azeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_aze.aze01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aze01_t = g_aze.aze01
    LET g_aze_o.* = g_aze.*
    BEGIN WORK
 
    OPEN i020_cl USING g_aze.aze01
    IF STATUS THEN
       CALL cl_err("OPEN i020_cl:", STATUS, 1)
       CLOSE i020_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i020_cl INTO g_aze.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aze.aze01,SQLCA.sqlcode,1)      # 資料被他人LOCK
        CLOSE i020_cl ROLLBACK WORK RETURN
    END IF
    CALL i020_show()
    WHILE TRUE
        LET g_aze01_t = g_aze.aze01
        LET g_aze.azemodu=g_user
        LET g_aze.azedate=g_today
        CALL i020_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aze.*=g_aze_t.*
            CALL i020_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_aze.aze01 != g_aze01_t THEN            # 更改單號
            UPDATE azc_file SET azc01 = g_aze.aze01
                WHERE azc01 = g_aze01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('azc',SQLCA.sqlcode,0)    #No.FUN-660131
                CALL cl_err3("upd","azc_file",g_aze01_t,"",SQLCA.sqlcode,"","azc",1)  #No.FUN-660131
                CONTINUE WHILE
            END IF
        END IF
        UPDATE aze_file SET aze_file.* = g_aze.*
            WHERE aze01 = g_aze.aze01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","aze_file",g_aze.aze01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i020_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i020_i(p_cmd)
   DEFINE   l_flag   LIKE type_file.chr1,                 #判斷必要欄位是否有輸入        #No.FUN-680102 VARCHAR(1)
            p_cmd    LIKE type_file.chr1,                 #a:輸入 u:更改        #No.FUN-680102 VARCHAR(1)
            l_cnt    LIKE type_file.num5                         #No.FUN-680102 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
   INPUT BY NAME g_aze.azeoriu,g_aze.azeorig,
      g_aze.aze01,g_aze.aze02,g_aze.aze03,g_aze.aze04,
      g_aze.aze10,g_aze.aze11,g_aze.aze09,g_aze.aze07 ,
      g_aze.azeuser,g_aze.azegrup,g_aze.azemodu,g_aze.azedate,g_aze.azeacti 
      WITHOUT DEFAULTS  
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i020_set_entry(p_cmd)
         CALL i020_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD aze01                  #簽核等級
         IF NOT cl_null(g_aze.aze01) THEN
            IF g_aze.aze01 != g_aze01_t OR g_aze01_t IS NULL THEN
               SELECT count(*) INTO g_cnt FROM aze_file WHERE aze01 = g_aze.aze01
               IF g_cnt > 0 THEN   #資料重複
                  CALL cl_err(g_aze.aze01,-239,0)
                  LET g_aze.aze01 = g_aze01_t
                  DISPLAY BY NAME g_aze.aze01 
                  NEXT FIELD aze01
               END IF
            END IF
         END IF
 
      AFTER FIELD aze07 #是否需看過
         IF NOT cl_null(g_aze.aze07) THEN
            IF g_aze.aze07 NOT MATCHES '[YN]' THEN
               LET g_aze.aze07 = g_aze_o.aze07
               DISPLAY BY NAME g_aze.aze07
               NEXT FIELD aze07
            END IF
         END IF
         LET g_aze_o.aze07 = g_aze.aze07
 
      AFTER FIELD aze09 #單據性質
         IF NOT cl_null(g_aze.aze09) THEN 
            IF g_aze.aze09 < 0 OR g_aze.aze09 > 26 THEN
               LET g_aze.aze09 = g_aze_o.aze09
               DISPLAY BY NAME g_aze.aze09
               NEXT FIELD aze09
            END IF
            LET g_aze_o.aze09 = g_aze.aze09
         END IF
 
      AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
         LET g_aze.azeuser = s_get_data_owner("aze_file") #FUN-C10039
         LET g_aze.azegrup = s_get_data_group("aze_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT  
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
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
 
FUNCTION i020_set_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("aze01",TRUE)
      END IF
END FUNCTION
 
FUNCTION i020_set_no_entry(p_cmd)
   DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
      IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("aze01",FALSE)
      END IF
 
END FUNCTION
 
#Query 查詢     
FUNCTION i020_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
 
    INITIALIZE g_aze.* TO NULL                #FUN-6A0015
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_azc.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i020_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
 
    OPEN i020_count
    FETCH i020_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
 
    OPEN i020_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aze.* TO NULL
    ELSE
        CALL i020_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION i020_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680102 VARCHAR(1)
    ls_jump         LIKE ze_file.ze03
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i020_cs INTO g_aze.aze01
        WHEN 'P' FETCH PREVIOUS i020_cs INTO g_aze.aze01
        WHEN 'F' FETCH FIRST    i020_cs INTO g_aze.aze01
        WHEN 'L' FETCH LAST     i020_cs INTO g_aze.aze01
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump 
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
            FETCH ABSOLUTE g_jump i020_cs INTO g_aze.aze01 --改g_jump
            LET g_no_ask = FALSE
 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)
        INITIALIZE g_aze.* TO NULL  #TQC-6B0105
        LET g_aze.aze01 = NULL      #TQC-6B0105
        RETURN
    ELSE
         CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
--#
    SELECT * INTO g_aze.* FROM aze_file WHERE aze01 = g_aze.aze01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("sel","aze_file",g_aze.aze01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        INITIALIZE g_aze.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0044權限控管
       LET g_data_owner=g_aze.azeuser       
       LET g_data_group=g_aze.azegrup
    END IF
 
    CALL i020_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i020_show()
    DEFINE l_cnt      LIKE type_file.num5           #No.FUN-680102 SMALLINT
    LET g_aze_t.* = g_aze.*                      #保存單頭舊值
    DISPLAY BY NAME g_aze.azeoriu,g_aze.azeorig,                              # 顯示單頭值
        g_aze.aze01,g_aze.aze02,g_aze.aze03,g_aze.aze04,
        g_aze.aze07,
        g_aze.aze09,g_aze.aze10,g_aze.aze11,
        g_aze.azeuser,g_aze.azegrup,g_aze.azemodu,
        g_aze.azedate,g_aze.azeacti
    CALL i020_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i020_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_aze.aze01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i020_cl USING g_aze.aze01
    IF STATUS THEN
       CALL cl_err("OPEN i020_cl:", STATUS, 1)
       CLOSE i020_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i020_cl INTO g_aze.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i020_cl ROLLBACK WORK RETURN
    END IF
    CALL i020_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aze01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aze.aze01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM aze_file WHERE aze01 = g_aze.aze01
         DELETE FROM azc_file WHERE azc01 = g_aze.aze01
         INITIALIZE g_aze.* TO NULL
         CLEAR FORM
         CALL g_azc.clear()
 
         OPEN i020_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i020_cs
            CLOSE i020_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i020_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i020_cs
            CLOSE i020_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i020_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i020_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i020_fetch('/')
         END IF
 
    END IF
    CLOSE i020_cl
    COMMIT WORK
END FUNCTION
 
 
#   Change to nonactivity     
FUNCTION i020_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_aze.aze01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i020_cl USING g_aze.aze01
    IF STATUS THEN
       CALL cl_err("OPEN i020_cl:", STATUS, 1)
       CLOSE i020_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i020_cl INTO g_aze.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE i020_cl ROLLBACK WORK RETURN
    END IF
    CALL i020_show()
    IF cl_exp(0,0,g_aze.azeacti) THEN                   #確認一下
        LET g_chr=g_aze.azeacti
        IF g_aze.azeacti='Y' THEN
            LET g_aze.azeacti='N'
        ELSE
            LET g_aze.azeacti='Y'
        END IF
        UPDATE aze_file                    #更改有效碼
            SET azeacti=g_aze.azeacti
            WHERE aze01=g_aze.aze01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)   #No.FUN-660131
            CALL cl_err3("upd","aze_file",g_aze.aze01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            LET g_aze.azeacti=g_chr
        END IF
        DISPLAY BY NAME g_aze.azeacti 
    END IF
    CLOSE i020_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1)             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102 VARCHAR(1)              #可刪除否
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_aze.aze01 IS NULL THEN
       RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    SELECT * INTO g_aze.* FROM aze_file WHERE aze01=g_aze.aze01
    IF g_aze.azeacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_aze.aze01,'aom-000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT azc02,azc03,'','','',azc04 FROM azc_file ",
                       "WHERE azc01=? AND azc02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_azc WITHOUT DEFAULTS FROM s_azc.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
#           LET g_azc_t.* = g_azc[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'            #DEFAULT
 
            BEGIN WORK
            OPEN i020_cl USING g_aze.aze01
            IF STATUS THEN
               CALL cl_err("OPEN i020_cl:", STATUS, 1)
               CLOSE i020_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i020_cl INTO g_aze.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i020_cl 
               ROLLBACK WORK 
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_azc_t.* = g_azc[l_ac].*  #BACKUP
                OPEN i020_bcl USING g_aze.aze01,g_azc_t.azc02
                IF STATUS THEN
                   CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i020_bcl INTO g_azc[l_ac].* 
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_azc_t.azc02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   CALL i020_azc03(' ')           #for referenced field
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_azc[l_ac].* TO NULL      #900423
            LET g_azc_t.* = g_azc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD azc02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO azc_file(azc01,azc02,azc03,azc04)
                         VALUES(g_aze.aze01,g_azc[l_ac].azc02,g_azc[l_ac].azc03,
                                g_azc[l_ac].azc04)
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","azc_file",g_azc[l_ac].azc02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        BEFORE FIELD azc02                        #default 序號
            IF g_azc[l_ac].azc02 IS NULL OR
               g_azc[l_ac].azc02 = 0 THEN
                 SELECT max(azc02)+1               #MOD-540144
                   INTO g_azc[l_ac].azc02
                   FROM azc_file
                   WHERE azc01 = g_aze.aze01
                IF g_azc[l_ac].azc02 IS NULL THEN
                    LET g_azc[l_ac].azc02 = 1
                END IF
            END IF
 
        AFTER FIELD azc02                        #check 序號是否重複
            IF NOT cl_null(g_azc[l_ac].azc02) THEN
               IF g_azc[l_ac].azc02 != g_azc_t.azc02 OR
                  g_azc_t.azc02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM azc_file
                    WHERE azc01 = g_aze.aze01 AND
                          azc02 = g_azc[l_ac].azc02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_azc[l_ac].azc02 = g_azc_t.azc02
                      NEXT FIELD azc02
                   END IF
               END IF
            END IF
 
        AFTER FIELD azc03
            IF NOT cl_null(g_azc[l_ac].azc03) THEN
               SELECT COUNT(*) INTO g_cnt FROM azc_file
                WHERE azc03=g_azc[l_ac].azc03 AND
                      azc01=g_aze.aze01
               IF SQLCA.sqlcode OR g_cnt IS NULL THEN
                  LET g_cnt=0
               END IF
               CALL i020_azc03('a')
               IF NOT cl_null(g_errno)  THEN
                   CALL cl_err('',g_errno,0)
                   LET g_azc[l_ac].azc03=g_azc_t.azc03
                   NEXT FIELD azc03
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_azc_t.azc02 > 0 AND
               g_azc_t.azc02 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
               DELETE FROM azc_file
                WHERE azc01 = g_aze.aze01 AND
                      azc02 = g_azc_t.azc02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","azc_file",g_azc_t.azc02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete Ok"
               CLOSE i020_bcl
               COMMIT WORK
            END IF
 
     ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_azc[l_ac].* = g_azc_t.*
               CLOSE i020_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
           
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_azc[l_ac].azc02,-263,1)
               LET g_azc[l_ac].* = g_azc_t.*
            ELSE
               UPDATE azc_file SET azc02=g_azc[l_ac].azc02,
                                   azc03=g_azc[l_ac].azc03,
                                   azc04=g_azc[l_ac].azc04 
                WHERE azc01=g_aze.aze01 
                  AND azc02=g_azc_t.azc02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_azc[l_ac].azc02,SQLCA.sqlcode,1)   #No.FUN-660131
                  CALL cl_err3("upd","azc_file",g_azc[l_ac].azc02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  LET g_azc[l_ac].* = g_azc_t.*
                  CLOSE i020_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i020_bcl
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac                #FUN-D40030 Mark
 
           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_azc[l_ac].* = g_azc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_azc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i020_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           LET l_ac_t = l_ac                #FUN-D40030 Add
           CLOSE i020_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(azc03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_azc[l_ac].azc03
                     CALL cl_create_qry() RETURNING g_azc[l_ac].azc03
                     CALL i020_azc03('a')
                     DISPLAY BY NAME g_azc[l_ac].azc03
                     NEXT FIELD azc03
                OTHERWISE
                    EXIT CASE
            END CASE
 
        ON ACTION CONTROLN
            CALL i020_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(azc02) AND l_ac > 1 THEN
               LET g_azc[l_ac].* = g_azc[l_ac-1].*
 #MOD-540144
               SELECT max(azc02)+1 INTO g_azc[l_ac].azc02 FROM azc_file
                WHERE azc01 = g_aze.aze01
               DISPLAY BY NAME g_azc[l_ac].azc02, g_azc[l_ac].azc03
               NEXT FIELD azc02
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
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
    END INPUT
 
    LET g_aze.azemodu = g_user
    LET g_aze.azedate = g_today
    UPDATE aze_file SET azemodu = g_aze.azemodu,azedate = g_aze.azedate
     WHERE aze01 = g_aze.aze01
    DISPLAY BY NAME g_aze.azemodu,g_aze.azedate
 
    CLOSE i020_bcl
    CLOSE i020_cl
    COMMIT WORK
   #CALL i020_delall()
   CALL i020_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i020_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  aze_file WHERE aze01 = g_aze.aze01
         INITIALIZE g_aze.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i020_delall()
    SELECT COUNT(*) INTO g_cnt FROM azc_file
        WHERE azc01 = g_aze.aze01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM aze_file WHERE aze01 = g_aze.aze01
    END IF
END FUNCTION
   
#檢查人員代號
FUNCTION  i020_azc03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680102 VARCHAR(1)
    l_genacti       LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,gem02,genacti
        INTO g_azc[l_ac].gen02,
             g_azc[l_ac].gen03,         
             g_azc[l_ac].gem02,l_genacti
        FROM gen_file,OUTER gem_file
        WHERE gen01 = g_azc[l_ac].azc03
              AND gem_file.gem01 = gen_file.gen03
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-070'
                            LET g_azc[l_ac].gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i020_b_askkey()
 
    DEFINE l_wc2           STRING       #No.FUN-680102CHAR(200)
 
    CLEAR gen02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON azc02,azc03,azc04
            FROM s_azc[1].azc02,s_azc[1].azc03,s_azc[1].azc04
 
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
    CALL i020_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2          STRING       #No.FUN-680102CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 =" 1=1"  END IF #MOD-8A0032
    LET g_sql =
        "SELECT azc02,azc03,gen02,gen03,gem02,azc04 ",
        " FROM azc_file LEFT OUTER JOIN gen_file LEFT OUTER JOIN gem_file ON gem_file.gem01 = gen_file.gen03 ON azc03 = gen_file.gen01",
        " WHERE azc01 ='",g_aze.aze01,"' AND ",  #單頭
        p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i020_pb FROM g_sql
    DECLARE azc_curs                       #SCROLL CURSOR
        CURSOR FOR i020_pb
 
    CALL g_azc.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH azc_curs INTO g_azc[g_cnt].*   #單身 ARRAY 填充
      LET g_rec_b = g_rec_b + 1
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_azc.deleteElement(g_cnt)
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680102 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azc TO s_azc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
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
         CALL i020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION previous
         CALL i020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump 
         CALL i020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL i020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last 
         CALL i020_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
--#                              
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i020_copy()
DEFINE
    l_aze		RECORD LIKE aze_file.*,
    l_oldno,l_newno	LIKE aze_file.aze01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aze.aze01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i020_set_entry('a')
    CALL i020_set_no_entry('a')
    LET g_before_input_done = TRUE
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM aze01
 
        AFTER FIELD aze01
           IF NOT cl_null(l_newno) THEN
              SELECT count(*) INTO g_cnt FROM aze_file
               WHERE aze01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                 NEXT FIELD aze01
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
       DISPLAY BY NAME g_aze.aze01 
       RETURN
    END IF
 
    LET l_aze.* = g_aze.*
    LET l_aze.aze01  =l_newno   #新的鍵值
    LET l_aze.azeuser=g_user    #資料所有者
    LET l_aze.azegrup=g_grup    #資料所有者所屬群
    LET l_aze.azemodu=NULL      #資料修改日期
    LET l_aze.azedate=g_today   #資料建立日期
    LET l_aze.azeacti='Y'       #有效資料
    BEGIN WORK
    LET l_aze.azeoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aze.azeorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aze_file VALUES (l_aze.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err('aze:',SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","aze_file",l_aze.aze01,"",SQLCA.sqlcode,"","aze:",1)  #No.FUN-660131
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM azc_file         #單身複製
        WHERE azc01=g_aze.aze01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_aze.aze01,SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","x",g_aze.aze01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
        RETURN
    END IF
    UPDATE x
        SET   azc01=l_newno
    INSERT INTO azc_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err('azc:',SQLCA.sqlcode,0)   #No.FUN-660131
        CALL cl_err3("ins","azc_file","","",SQLCA.sqlcode,"","azc:",1)  #No.FUN-660131
        ROLLBACK WORK
        RETURN
    END IF
    COMMIT WORK
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        
     LET l_oldno = g_aze.aze01
     SELECT aze_file.* INTO g_aze.* FROM aze_file WHERE aze01 = l_newno
     CALL i020_u()
     CALL i020_b()
     #SELECT aze_file.* INTO g_aze.* FROM aze_file WHERE aze01 = l_oldno  #FUN-C80046
     #CALL i020_show()  #FUN-C80046
END FUNCTION
 
FUNCTION i020_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680102 SMALLINT
    sr              RECORD
        aze01       LIKE aze_file.aze01,   #簽核等級
        aze02       LIKE aze_file.aze02,   #說明
        aze03       LIKE aze_file.aze03,   #說明
        aze04       LIKE aze_file.aze04,   #說明
        aze05       LIKE aze_file.aze05,   #說明
        aze06       LIKE aze_file.aze06,   #說明
        aze07       LIKE aze_file.aze07,   #需查看否
        aze09       LIKE aze_file.aze09,   #單據別
        aze10       LIKE aze_file.aze10,   #條件
        aze11       LIKE aze_file.aze11,   #條件
        azc02       LIKE azc_file.azc02,   #簽核順序
        azc03       LIKE azc_file.azc03,   #人員代號
        gen02       LIKE gen_file.gen02,   #人員姓名
        azeacti     LIKE aze_file.azeacti
                    END RECORD,
        l_name      LIKE type_file.chr20                #External(Disk) file name        #No.FUN-680102 VARCHAR(20)
    DEFINE l_sql    STRING                    #No.FUN-760083
    IF cl_null(g_wc) THEN 
       	LET g_wc=" aze01='",g_aze.aze01,"'"
    END IF
#No.FUN-760083  --BEGIN--
    LET g_str=''
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
#No.FUN-760083   --end--
	
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT aze01,aze02,aze03,aze04,aze05,aze06,aze07,",
          "aze09,aze10,aze11,azc02,azc03,gen02,azeacti",
          " FROM aze_file LEFT OUTER JOIN azc_file ON aze01=azc01 LEFT OUTER JOIN gen_file ON azc03=gen01 ",
          " WHERE ",g_wc CLIPPED,
          " AND ",g_wc2 CLIPPED
    PREPARE i020_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i020_co                         # SCROLL CURSOR
         CURSOR FOR i020_p1
 
    #CALL cl_outnam('aooi020') RETURNING l_name         #No.FUN-760083
    #START REPORT i020_rep TO l_name                    #No.FUN-760083
 
    FOREACH i020_co INTO sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
           EXIT FOREACH
        END IF
        IF sr.aze09 IS NULL THEN LET sr.aze09 = ' ' END IF
 
        #OUTPUT TO REPORT i020_rep(sr.*)                #No.FUN-760083
        EXECUTE insert_prep USING sr.aze01,sr.aze02,sr.aze03,sr.aze04,sr.aze05,         #No.FUN-760083
                                  sr.aze06,sr.aze07,sr.aze09,sr.aze10,sr.aze11,          #No.FUN-760083
                                  sr.azc02,sr.azc03,sr.gen02,sr.azeacti                  #No.FUN-760083
 
    END FOREACH
 
    #FINISH REPORT i020_rep                             #No.FUN-760083
 
    #CLOSE i020_co                                       #No.FUN-760083 
    #ERROR ""                                           #No.FUN-760083 
    #CALL cl_prt(l_name,' ','1',g_len)                  #No.FUN-760083
    LET l_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED          #No.FUN-760083
    IF g_zz05='Y' THEN 
       CALL cl_wcchp(g_wc,'aze01,aze02,aze03,aze04,aze10,aze11,aze09,aze07,azeuser,azegrup,azemodu,
                     azedate,azeazti')       
       RETURNING g_wc
    END IF
    LET g_str=g_wc                                            
    CALL cl_prt_cs3("aooi020","aooi020",l_sql,g_str)                        #No.FUN-760083
END FUNCTION
 
#No.FUN-760083  --BEGIN--
#REPORT i020_rep(sr)                                                                                                                 
#DEFINE                                                                                                                              
#    l_trailer_sw    LIKE type_file.chr1,           #No.FUN-680102CHAR(1),                                                           
#    l_sw            LIKE type_file.chr1,           #No.FUN-680102CHAR(1),                                                           
#    l_i             LIKE type_file.num5,           #No.FUN-680102 SMALLINT                                                          
#    l_desc1         LIKE type_file.chr1000,        #No.FUN-680102 VARCHAR(60),                                                         
#    l_desc2         LIKE type_file.chr1000,        #No.FUN-680102CHAR(60),                                                          
#    sr              RECORD                                                                                                          
#        aze01       LIKE aze_file.aze01,   #簽核等級                                                                                
#        aze02       LIKE aze_file.aze02,   #說明                                                                                    
#        aze03       LIKE aze_file.aze03,   #說明                                                                                    
#        aze04       LIKE aze_file.aze04,   #說明                                                                                    
#        aze05       LIKE aze_file.aze05,   #說明                                                                                    
#        aze06       LIKE aze_file.aze06,   #說明                                                                                    
#        aze07       LIKE aze_file.aze07,   #需查看否                                                                                
#        aze09       LIKE aze_file.aze09,   #單據別                                                                                  
#        aze10       LIKE aze_file.aze10,   #條件                                                                                    
#        aze11       LIKE aze_file.aze11,   #條件                                                                                    
#        azc02       LIKE azc_file.azc02,   #簽核順序                                                                                
#        azc03       LIKE azc_file.azc03,   #人員代號                                                                                
#        gen02       LIKE gen_file.gen02,   #人員姓名  
#        azeacti     LIKE aze_file.azeacti                                                                                           
#                    END RECORD                                                                                                      
#   OUTPUT                                                                                                                           
#       TOP MARGIN g_top_margin                                                                                                      
#       LEFT MARGIN g_left_margin                                                                                                    
#       BOTTOM MARGIN g_bottom_margin                                                                                                
#       PAGE LENGTH g_page_line   #No.MOD-580242                                                                                     
#                                                                                                                                    
#    ORDER BY sr.aze09,sr.aze01                                                                                                      
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
#            PRINTX name=H1 g_x[51],g_x[52],g_x[53],g_x[54]                                                                          
#            PRINTX name=H2 g_x[55],g_x[56],g_x[57],g_x[58]                                                                          
#            PRINT g_dash1                                                                                                           
#            LET l_trailer_sw = 'y'                                                                                                  
#                                                                                                                                    
#        BEFORE GROUP OF sr.aze09  #單據別                                                                                           
#            LET l_sw = 'Y'                                                                                                          
#                                                                                                                                    
#        BEFORE GROUP OF sr.aze01  #等級                                                                                             
#            IF sr.azeacti = 'N' THEN PRINT '*' ; END IF                                                                             
#            IF l_sw = 'Y' THEN                                                                                                      
#               CASE sr.aze09                                                                                                        
#                    WHEN '1'  PRINTX name=D1 COLUMN g_c[51],g_x[21] CLIPPED;                                                        
#                    WHEN '2'  PRINTX name=D1 COLUMN g_c[51],g_x[22] CLIPPED;                                                        
#                    WHEN '3'  PRINTX name=D1 COLUMN g_c[51],g_x[23] CLIPPED;                                                        
#                    WHEN '4'  PRINTX name=D1 COLUMN g_c[51],g_x[24] CLIPPED;                                                        
#                    WHEN '5'  PRINTX name=D1 COLUMN g_c[51],g_x[25] CLIPPED;                                                        
#                    WHEN '6'  PRINTX name=D1 COLUMN g_c[51],g_x[26] CLIPPED;                                                        
#                    WHEN '7'  PRINTX name=D1 COLUMN g_c[51],g_x[27] CLIPPED; 
#                 #  WHEN '8'  PRINTX name=D1 COLUMN g_c[51],g_x[28] CLIPPED;                                                        
#                    WHEN '9'  PRINTX name=D1 COLUMN g_c[51],g_x[29] CLIPPED;                                                        
#                    WHEN '10' PRINTX name=D1 COLUMN g_c[51],g_x[30] CLIPPED;                                                        
#                    WHEN '11' PRINTX name=D1 COLUMN g_c[51],g_x[31] CLIPPED;                                                        
#                    WHEN '12' PRINTX name=D1 COLUMN g_c[51],g_x[32] CLIPPED;                                                        
#                    WHEN '13' PRINTX name=D1 COLUMN g_c[51],g_x[33] CLIPPED;                                                        
#                    WHEN '14' PRINTX name=D1 COLUMN g_c[51],g_x[34] CLIPPED;                                                        
#                    WHEN '15' PRINTX name=D1 COLUMN g_c[51],g_x[35] CLIPPED;                                                        
#                    WHEN '16' PRINTX name=D1 COLUMN g_c[51],g_x[36] CLIPPED;                                                        
#                    WHEN '17' PRINTX name=D1 COLUMN g_c[51],g_x[37] CLIPPED;                                                        
#                    WHEN '18' PRINTX name=D1 COLUMN g_c[51],g_x[38] CLIPPED;                                                        
#                    WHEN '19' PRINTX name=D1 COLUMN g_c[51],g_x[39] CLIPPED;                                                        
#                    WHEN '20' PRINTX name=D1 COLUMN g_c[51],g_x[40] CLIPPED;                                                        
#                    WHEN '21' PRINTX name=D1 COLUMN g_c[51],g_x[41] CLIPPED;                                                        
#                    WHEN '22' PRINTX name=D1 COLUMN g_c[51],g_x[42] CLIPPED;                                                        
#                    WHEN '23' PRINTX name=D1 COLUMN g_c[51],g_x[43] CLIPPED;                                                        
#                    WHEN '24' PRINTX name=D1 COLUMN g_c[51],g_x[44] CLIPPED;                                                        
#                    WHEN '25' PRINTX name=D1 COLUMN g_c[51],g_x[45] CLIPPED;                                                        
#                    WHEN '26' PRINTX name=D1 COLUMN g_c[51],g_x[46] CLIPPED;
#                    OTHERWISE EXIT CASE                                                                                             
#               END CASE                                                                                                             
#               LET l_sw = 'N'                                                                                                       
#            END IF                                                                                                                  
#            PRINTX name=D1 COLUMN g_c[52],sr.aze01 USING '###&',  #等級#FUN-590118                                                  
#                           COLUMN g_c[53],sr.aze02,                                                                                 
#                           COLUMN g_c[54],sr.aze07                                                                                  
#            IF sr.aze03 IS NOT NULL THEN  #COMMENT                                                                                  
#               LET l_desc1=sr.aze03,' ',sr.aze04                                                                                    
#               PRINTX name=D1 COLUMN g_c[53],l_desc1                                                                                
#            END IF                                                                                                                  
#            IF sr.aze05 IS NOT NULL THEN  #COMMENT                                                                                  
#               LET l_desc2=sr.aze05,' ',sr.aze06                                                                                    
#               PRINTX name=D1 COLUMN g_c[53],l_desc2                                                                                
#            END IF                                                                                                                  
#            IF sr.aze10 IS NOT NULL THEN  #                                                                                         
#               PRINTX name=D1 COLUMN g_c[53],sr.aze10                                                                               
#            END IF                                                                                                                  
#            IF sr.aze11 IS NOT NULL THEN                                                                                            
#               PRINTX name=D1 COLUMN g_c[53],sr.aze11  
#            END IF                                                                                                                  
#                                                                                                                                    
#        ON EVERY ROW                                                                                                                
#           PRINTX name=D2 COLUMN g_c[56],sr.azc02 USING '###&',                                                                     
#                 COLUMN g_c[57],sr.azc03,                                                                                           
#                 COLUMN g_c[58],sr.gen02                                                                                            
#                                                                                                                                    
#        AFTER GROUP OF sr.aze09  #單據別                                                                                            
#            SKIP 1 LINE                                                                                                             
#                                                                                                                                    
#        ON LAST ROW                                                                                                                 
#            PRINT g_dash[1,g_len]                                                                                                   
#            IF g_zz05 = 'Y' THEN         # 80:70,140,210      132:120,240                                                           
#               CALL cl_wcchp(g_wc,'aze01,aze02,aze03,aze04,aze07,aze09')                                                            
#                    RETURNING g_sql                                                                                                 
#            #TQC-630166                                                                                                             
#            {                                                                                                                       
#               IF g_sql[001,080] > ' ' THEN                                                                                         
#                       PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF                                                           
#               IF g_sql[071,140] > ' ' THEN                                                                                         
#                       PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF       
#               IF g_sql[141,210] > ' ' THEN                                                                                         
#                       PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF                                                           
#            }                                                                                                                       
#              CALL cl_prt_pos_wc(g_sql)                                                                                             
#            #END TQC-630166                                                                                                         
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
#No.FUN-760083  --END--                              


# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimi310.4gl
# Descriptions...: 特性碼資料維護作業
# Date & Author..: 04/09/16 By Lifeng
# Modify.........: No.FUN-660078 06/06/13 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0061 23/10/16 By xumin g_no_ask 改為 mi_no_ask
# Modify.........: No.FUN-6A0074 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-720065 07/03/01 By Judy 應在單身項次欄位作預設上一筆資料
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-780040 07/07/27 By zhoufeng 報表打印產出改為p_query
# Modify.........: No.TQC-7A0033 07/10/12 By Mandy informix區r.c2不過
# Modify.........: No.FUN-810014 07/07/19 By arman 增加以下欄位 agbslk01影響縮放比例,agbslk02度量屬性,agbslk03洗水色屬性
# Modify.........: No.FUN-840001 08/03/24 By ve007 810014規格修改
# Modify.........: No.FUN-850079 08/05/22 by ve007 解決無法在單身下查詢條件的問題
# Modify.........: No.FUN-870117 08/07/22 by ve007 單身項次自動賦值
# Modify.........: No.MOD-940304 09/04/23 By Smapmin 單身控管不可大於3筆資料,只限於鞋服業
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-980032 09/08/05 By lilingyu 1.無效資料不可刪除 2.查詢時,資料有效碼欄位無法下查詢條件
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-930085 09/08/12 By arman 群組屬性代碼改為開窗查詢功能
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9B0128 09/11/24 By sabrina 於屬性群組代碼開窗選擇後,未帶回選擇的屬性群組代碼
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50012 10/05/13 By shaoyong 在服飾業中控管顏色、尺碼屬性順序 
# Modify.........: No.TQC-B20117 11/02/21 By destiny 新增時orig,oriu無資料
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90102 11/09/20 By qiaozy  在服飾業中控管顏色、尺碼屬性順序
# Modify.........: No.FUN-B90102 11/11/23 By qiaozy  當g_azw.azw04='1'時,可錄入大於等於三筆的資料
# Modify.........: No.TQC-C30167 12/03/09 By huangrh 服饰制造，不控管单身的笔数以及顏色、尺碼屬性順序
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    new_ver         LIKE aga_file.aga01,          #FUN-660078
    g_aga           RECORD LIKE aga_file.*,       #主件料件(假單頭)
    g_aga_t         RECORD LIKE aga_file.*,       #主件料件(舊值)
    g_aga_o         RECORD LIKE aga_file.*,       #主件料件(舊值)
    g_aga01_t       LIKE aga_file.aga01,          #(舊值)
    g_agb           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                    agb02    LIKE agb_file.agb02, #順序
                    agb03    LIKE agb_file.agb03, #屬性類別
                    agc02    LIKE agc_file.agc02, #類別描述
                    agc03    LIKE agc_file.agc03, #使用長度
                    agbslk01 LIKE agb_file.agbslk01,   #影響縮放比例 #No.FUN-810014
                    agbslk02 LIKE agb_file.agbslk02,   #度量屬性     #No.FUN-810014
                    agbslk03 LIKE agb_file.agbslk03,   #洗水色屬性   #No.FUN-810014
                    agb04     LIKE agb_file.agb04        #屬性維度     #No.FUN-810014
                    END RECORD,
    g_agb_t         RECORD    #程式變數(舊值)
                    agb02    LIKE agb_file.agb02, #順序
                    agb03    LIKE agb_file.agb03, #屬性類別
                    agc02    LIKE agc_file.agc02, #類別描述
                    agc03    LIKE agc_file.agc03, #使用長度
                    agbslk01 LIKE agb_file.agbslk01,   #影響縮放比例 #No.FUN-810014                                               
                    agbslk02 LIKE agb_file.agbslk02,   #度量屬性     #No.FUN-810014                                               
                    agbslk03 LIKE agb_file.agbslk03,   #洗水色屬性   #No.FUN-810014
                    agb04     LIKE agb_file.agb04        #屬性維度     #No.FUN-810014
                    END RECORD,
    g_agb_o         RECORD    #程式變數(舊值)
                    agb02    LIKE agb_file.agb02, #順序
                    agb03    LIKE agb_file.agb03, #屬性類別
                    agc02    LIKE agc_file.agc02, #類別描述
                    agc03    LIKE agc_file.agc03, #使用長度
                    agbslk01 LIKE agb_file.agbslk01,   #影響縮放比例 #No.FUN-810014                                               
                    agbslk02 LIKE agb_file.agbslk02,   #度量屬性     #No.FUN-810014                                               
                    agbslk03 LIKE agb_file.agbslk03,   #洗水色屬性   #No.FUN-810014
                    agb04     LIKE agb_file.agb04        #屬性維度     #No.FUN-810014       
                    END RECORD,
    g_sql           string,  #No.FUN-580092 HCN
    g_wc,g_wc2      string,  #No.FUN-580092 HCN
    g_vdate         LIKE type_file.dat,           #No.FUN-690026 DATE
    g_sw            LIKE type_file.num5,          #單位是否可轉換       #No.FUN-690026 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-690026 VARCHAR(60)
    g_rec_b         LIKE type_file.num5,          #單身筆數             #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5,          #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    vdate           LIKE type_file.dat            #No.FUN-690026 DATE
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE  SQL
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT   #No.FUN-6A0061
DEFINE g_j                 LIKE type_file.num5    #No.FUN-810014
DEFINE g_k                 LIKE type_file.num5    #No.FUN-810014    
 
#主程式開始
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql =
        "SELECT * FROM aga_file WHERE aga01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_curl CURSOR FROM g_forupd_sql
      CALL cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 3 LET p_col = 20
 
    OPEN WINDOW i310_w AT p_row,p_col         #顯示畫面
         WITH FORM "aim/42f/aimi310"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    
    CALL cl_set_comp_visible("agbslk02,agbslk03,agb04",FALSE)   #No.FUN-840001
    CALL cl_set_comp_entry("agb02",FALSE)                      #No.FUN-840001
     
    CALL i310_menu()
    CLOSE WINDOW i310_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i310_curs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_agb.clear()
    LET g_vdate = g_today
    INITIALIZE g_aga.* TO NULL   #FUN-640213 add
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                                 # 螢幕上取單頭條件
     aga01,aga02,agauser,agagrup,agamodu,agadate,agaacti    #TQC-980032
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
      ON ACTION CONTROLP
         CASE WHEN INFIELD(aga01) 
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_aga"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO aga01        #MOD-9B0128 modify
             OTHERWISE EXIT CASE
         END  CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('agauser', 'agagrup')
 
 
    CONSTRUCT g_wc2 ON agb02,agb03,
              agbslk01,agbslk02,agbslk03, # No.FUN-850079 
              agb04                                         # No.FUN-850079 
         FROM s_agb[1].agb02,s_agb[1].agb03,
              s_agb[1].agbslk01,s_agb[1].agbslk02,s_agb[1].agbslk03, # No.FUN-810014
              s_agb[1].agb04                            # No.FUN-810014
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
     ON ACTION CONTROLP
           CASE WHEN INFIELD(agb03) #屬性類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_agc"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO s_agb[1].agb03
               OTHERWISE EXIT CASE
           END  CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT aga01 FROM aga_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY aga01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE aga_file. aga01 ",
                   "  FROM aga_file, agb_file ",
                   " WHERE aga01 = agb01",
                   "   AND ",g_wc CLIPPED,
                   "   AND ",g_wc2 CLIPPED,
                   " ORDER BY aga01"
    END IF
 
    PREPARE i310_prepare FROM g_sql
	  DECLARE i310_curs
        SCROLL CURSOR WITH HOLD FOR i310_prepare
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
        LET g_sql="SELECT COUNT(*) FROM aga_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM aga_file,agb_file WHERE ",
                  "agb01=aga01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i310_precount FROM g_sql
    DECLARE i310_count CURSOR FOR i310_precount
END FUNCTION
 
FUNCTION i310_menu()
DEFINE l_cmd  LIKE type_file.chr1000      #No.FUN-780040
   WHILE TRUE
      CALL i310_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i310_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i310_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i310_r()
           END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i310_copy()
            END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i310_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i310_b()
           ELSE
              LET g_action_choice = NULL
           END IF
        WHEN "invalid"
           IF cl_chk_act_auth() THEN
              CALL i310_x()
           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
               IF cl_null(g_wc) THEN LET g_wc=" 1=1" END IF
               IF cl_null(g_wc2) THEN LET g_wc2=" 1=1" END IF   
               LET l_cmd = 'p_query "aimi310" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'
               CALL cl_cmdrun(l_cmd)
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
  
        WHEN "related_document"  #相關文件
           IF cl_chk_act_auth() THEN
              IF g_aga.aga01 IS NOT NULL THEN
                LET g_doc.column1 = "aga01"
                LET g_doc.value1 = g_aga.aga01
                CALL cl_doc()
              END IF
           END IF
      
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i310_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_agb.clear()
    INITIALIZE g_aga.* LIKE aga_file.*             #DEFAULT 設定
    LET g_aga01_t = NULL
    #預設值及將數值類變數清成零
    LET g_aga_t.* = g_aga.*
    LET g_aga_o.* = g_aga.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aga.agauser=g_user
        LET g_aga.agagrup=g_grup
        LET g_aga.agadate=g_today
        LET g_aga.agaacti='Y'              #資料有效
        LET g_aga.agaoriu = g_user      #No.TQC-B20117 
        LET g_aga.agaorig = g_grup      #No.TQC-B20117
        CALL i310_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_aga.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF cl_null(g_aga.aga01) THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_aga.agaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_aga.agaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO aga_file VALUES (g_aga.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
           CALL cl_err3("ins","aga_file",g_aga.aga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        SELECT aga01 INTO g_aga.aga01 FROM aga_file
         WHERE aga01 = g_aga.aga01
        LET g_aga01_t = g_aga.aga01        #保留舊值
        LET g_aga_t.* = g_aga.*
        CALL g_agb.clear()
        LET g_rec_b=0
        CALL i310_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i310_u()
DEFINE
    l_cnt LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    #判斷如果當前屬性群組已經被某個料件用到了的話，則不允許進行修改操作
    SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE imaag = g_aga.aga01 OR
      imaag1 = g_aga.aga01
    IF l_cnt > 0  THEN
       CALL cl_err("Forbidden:","aim-917",1)
       RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
    IF g_aga.aga01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_aga.agaacti ='N' THEN    #資料若為無效,仍可更改.
       CALL cl_err(g_aga.aga01,'mfg1000',0) RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_aga01_t = g_aga.aga01
    BEGIN WORK
    OPEN i310_curl USING g_aga.aga01
    IF STATUS THEN
       CALL cl_err("OPEN i310_curl:", STATUS, 1)
       CLOSE i310_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_curl INTO g_aga.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aga.aga01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i310_curl
        RETURN
    END IF
    CALL i310_show()
    WHILE TRUE
        LET g_aga_t.* = g_aga.*
        LET g_aga_o.* = g_aga.*
        LET g_aga01_t = g_aga.aga01
        LET g_aga.agamodu=g_user
        LET g_aga.agadate=g_today
        CALL i310_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aga.*=g_aga_t.*
            CALL i310_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_aga.aga01 != g_aga01_t THEN # 更改KEY
           UPDATE agb_file SET agb01 = g_aga.aga01
                WHERE agb01 = g_aga01_t
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","agb_file",g_aga01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
              CONTINUE WHILE 
           END IF
        END IF
UPDATE aga_file SET aga_file.* = g_aga.*
WHERE aga01 = g_aga01_t
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","aga_file",g_aga.aga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i310_curl
    COMMIT WORK
END FUNCTION
 
#處理INPUT(單頭)
FUNCTION i310_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
    l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    DISPLAY BY NAME g_aga.agauser,g_aga.agamodu,
                    g_aga.agagrup,g_aga.agadate,
                    g_aga.agaoriu,g_aga.agaorig #TQC-B20117
 
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 
    INPUT BY NAME g_aga.aga01,g_aga.aga02
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i310_set_entry(p_cmd)
           CALL i310_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
       
        AFTER FIELD aga01
           IF NOT cl_null(g_aga.aga01) THEN
              IF cl_null(g_aga_t.aga01) OR         # 若輸入或更改且改KEY
                (p_cmd = "u" AND g_aga.aga01 != g_aga_t.aga01) THEN
                  SELECT COUNT(*) INTO l_n FROM aga_file
                   WHERE aga01 = g_aga.aga01
                  IF l_n > 0 THEN                  # Duplicated
                     CALL cl_err(g_aga.aga01,-239,0)
                     LET g_aga.aga01 = g_aga_t.aga01
                     DISPLAY BY NAME g_aga.aga01
                     NEXT FIELD aga01
                 END IF
              END IF
           END IF
 
        AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    END INPUT
END FUNCTION
 
 
#Query 查詢
FUNCTION i310_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_agb.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i310_curs()
    IF INT_FLAG THEN
        INITIALIZE g_aga.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN i310_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_aga.* TO NULL
    ELSE
        OPEN i310_count
        FETCH i310_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i310_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION
 
FUNCTION i310_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
      WHEN 'N' FETCH NEXT     i310_curs INTO g_aga.aga01
      WHEN 'P' FETCH PREVIOUS i310_curs INTO g_aga.aga01
      WHEN 'F' FETCH FIRST    i310_curs INTO g_aga.aga01
      WHEN 'L' FETCH LAST     i310_curs INTO g_aga.aga01
      WHEN '/'
         IF (NOT mi_no_ask) THEN     #No.FUN-6A0061
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
             END PROMPT
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump i310_curs INTO g_aga.aga01
         LET mi_no_ask = FALSE    #No.FUN-6A0061
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aga.aga01,SQLCA.sqlcode,0)
        INITIALIZE g_aga.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_aga.* FROM aga_file WHERE aga01 = g_aga.aga01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","aga_file",g_aga.aga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
        INITIALIZE g_aga.* TO NULL
        RETURN
    END IF
    CALL i310_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i310_show()
    LET g_aga_t.* = g_aga.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
     g_aga.aga01,  g_aga.aga02,g_aga.agauser,g_aga.agagrup,
        g_aga.agamodu,g_aga.agadate,g_aga.agaacti
 
    CALL i310_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i310_x()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_aga.aga02) THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF
    BEGIN WORK
    OPEN i310_curl USING g_aga.aga01
    IF STATUS THEN
       CALL cl_err("OPEN i310_curl:", STATUS, 1)
       CLOSE i310_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_curl INTO g_aga.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aga.aga01,SQLCA.sqlcode,0)          #資料被他人LOCK
        RETURN
    END IF
    CALL i310_show()
    IF cl_exp(0,0,g_aga.agaacti) THEN
        LET g_chr=g_aga.agaacti
        IF g_aga.agaacti='Y' THEN
           LET g_aga.agaacti='N'
        ELSE
           LET g_aga.agaacti='Y'
        END IF
        UPDATE aga_file                    #更改有效碼
           SET agaacti=g_aga.agaacti
         WHERE aga01=g_aga.aga01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","aga_file",g_aga.aga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           LET g_aga.agaacti=g_chr
        END IF
        DISPLAY BY NAME g_aga.agaacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE i310_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION i310_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
    DEFINE l_n LIKE  type_file.num5 
 
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aga.aga01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_aga.agaacti = 'N' THEN
       CALL cl_err('','abm-033',0)
       RETURN 
    END IF 
    
    BEGIN WORK
    OPEN i310_curl USING g_aga.aga01
    IF STATUS THEN
       CALL cl_err("OPEN i310_curl:", STATUS, 1)
       CLOSE i310_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i310_curl INTO g_aga.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_aga.aga01,SQLCA.sqlcode,0) RETURN
    END IF
    CALL i310_show()
    #判斷如果當前屬性群組已經被某個料件用到了的話，則不允許進行刪除操作
    SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE imaag = g_aga.aga01 OR
      imaag1 = g_aga.aga01
    IF l_cnt > 0  THEN
       CALL cl_err("Forbidden:","aim-917",1)
       RETURN
    END IF
 
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aga01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aga.aga01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM agb_file WHERE agb01 = g_aga.aga01    #No.FUN-810014
        DELETE FROM aga_file WHERE aga01=g_aga.aga01
        
         IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","aga_file",g_aga.aga01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
       ELSE
          CLEAR FORM
          CALL g_agb.clear()
          OPEN i310_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i310_curs
             CLOSE i310_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i310_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i310_curs
             CLOSE i310_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i310_curs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i310_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE    #No.FUN-6A0061
             CALL i310_fetch('/')
          END IF
       END IF
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
            VALUES ('aimi310',g_user,g_today,g_msg,g_aga.aga01,'delete',g_plant,g_legal) #No.FUN-980004
    END IF
    CLOSE i310_curl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i310_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用         #No.FUN-690026 SMALLINT
    l_n1            LIKE type_file.num5,    #No.FUN-870117
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否         #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態           #No.FUN-690026 VARCHAR(1)
    l_buf           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
    l_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(200)
    l_allow_insert  LIKE type_file.num5,    #可新增否           #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5,    #可刪除否           #No.FUN-690026 SMALLINT
    l_i,l_i1        LIKE type_file.num5                         #No.FUN-810016

#FUN-A50012 --begin--
    DEFINE    l_m             LIKE type_file.num5   
    DEFINE    l_agc07         LIKE agc_file.agc07
#FUN-A50012 --end--
#FUN-B90102 --BEGIN--
    DEFINE    l_count            LIKE type_file.num5
#FUN-B90102 --END----
    LET g_action_choice = ""
    
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_aga.aga02) THEN
        RETURN
    END IF
    IF g_aga.agaacti ='N' THEN    #資料若為無效,仍可更改.
       CALL cl_err(g_aga.aga01,'mfg1000',0) RETURN
    END IF
#FUN-B90102 --BEGIN--# 單身不符合要求的不可進入
   IF g_azw.azw04 = '2' THEN    #TQC-C30167 modify azw04='2'
      LET l_count=0
      SELECT COUNT(*) INTO l_count FROM agb_file WHERE agb01=g_aga.aga01
      IF l_count<> 0 AND l_count>2 THEN  #TQC-C30167 modify l_count>2
         CALL cl_err("","aim1107",1)
         RETURN
      END IF
   END IF
#FUN-B90102 --END----
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
       "SELECT agb02,agb03 FROM agb_file ",
       " WHERE agb01=? and agb02=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i310_b_curl CURSOR FROM g_forupd_sql
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
#FUN-B90102---QZY--
    IF g_azw.azw04 = '2' THEN     #TQC-C30167add
       LET l_allow_delete= FALSE
    END IF                        #TQC-C30167add
#FUN-B90102---QZY--
    INPUT ARRAY g_agb WITHOUT DEFAULTS FROM s_agb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert
         ,DELETE ROW=l_allow_delete
                   )
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
              CALL cl_set_comp_entry('agbslk01',TRUE)   #No.FUN-810014
           END IF
 
 
        BEFORE ROW
            LET p_cmd=''
            CALL cl_set_comp_entry('agb02',TRUE)     #No.FUN-840001
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN i310_curl USING g_aga.aga01
            IF STATUS THEN
               CALL cl_err("OPEN i310_curl:", STATUS, 1)
               CLOSE i310_curl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i310_curl INTO g_aga.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_aga.aga01,SQLCA.sqlcode,0)  # 資料被他人LOCK
               CLOSE i310_curl
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_agb_t.* = g_agb[l_ac].*  #BACKUP
               LET g_agb_o.* = g_agb[l_ac].*
               OPEN i310_b_curl USING g_aga.aga01,g_agb[l_ac].agb02
               IF STATUS THEN
                  CALL cl_err("OPEN i310_b_curl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                  FETCH i310_b_curl INTO g_agb[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_agb_t.agb02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL i310_agb03('d')
                  END IF
               END IF
               CALL cl_set_comp_entry('agb02',FALSE)     #No.FUN-840001
               CALL cl_show_fld_cont()     #FUN-550037(smin)
         
#FUN-A50012 --begin--
            ELSE
                IF g_azw.azw04 ='2' THEN    #add--FUN-B90102-- #TQC-C30167modify azw04='2'
                   LET l_m = 0 
                   SELECT COUNT(*) INTO l_m FROM agb_file 
                          WHERE  agb01 = g_aga.aga01
                   IF l_m >= 2 THEN
                      CALL i310_b_fill(" 1=1 ")   #add ---#No.FUN-B90102---qiaozy
                      EXIT INPUT
                   END IF                  
               END IF                         #add--FUN-B90102--  
#FUN-A50012 --end--
            END IF       
            
#若此料件屬性屬于成品材料屬性縮放比例維護作業的料件中,則是否影響縮放比率的欄位不可更改
        BEFORE FIELD agbslk01 
         SELECT COUNT(boe01) INTO l_n FROM boe_file,ima_file 
           WHERE boe_file.boe01 = ima01 AND imaag = g_aga.aga01 
         IF l_n >0 THEN
            CALL cl_set_comp_entry('agbslk01',FALSE )
         ELSE 
            CALL cl_set_comp_entry('agbslk01',TRUE )    
         END IF 
         
        AFTER FIELD agbslk02 
        IF (p_cmd='a' OR (p_cmd='u' AND g_agb[l_ac].agbslk02!=g_agb_t.agbslk02)) THEN
         IF (g_agb[l_ac].agbslk02='Y') THEN                                                                                                     
          SELECT COUNT(*) INTO g_j FROM agb_file 
                          WHERE agb01=g_aga.aga01 
                          AND agbslk02='Y'                                                                                                        
          IF(g_j>=1) THEN                                                                                                           
             CALL cl_err('','aim-933',0)
             LET g_agb[l_ac].agbslk02=g_agb_t.agbslk02
             NEXT FIELD agbslk02                                                                                            
          END IF 
         END IF
        END IF                                                                                                                    
                                                                                                                                    
       AFTER FIELD agbslk03
       IF (p_cmd='a' OR (p_cmd='u' AND g_agb[l_ac].agbslk03!=g_agb_t.agbslk03)) THEN 
        IF (g_agb[l_ac].agbslk03='Y') THEN                                                                                                      
         SELECT COUNT(*) INTO g_k FROM agb_file
                         WHERE agb01=g_aga.aga01 
                         AND agbslk03='Y'                                                                                                         
         IF(g_k>=1) THEN                                                                                                            
           CALL cl_err('','aim-934',0)
           LET g_agb[l_ac].agbslk03=g_agb_t.agbslk03  
           NEXT FIELD agbslk03                                                                                            
         END IF 
        END IF
       END IF  
       
      AFTER FIELD agb04
      IF g_agb[l_ac].agb04!=g_agb_t.agb04 OR g_agb_t.agb04 IS NULL THEN 
       SELECT COUNT(*) INTO l_n FROM agb_file 
         WHERE agb01=g_aga.aga01
         AND   agb04=g_agb[l_ac].agb04
         IF l_n>0 THEN
           CALL cl_err('','aim-099',0)
           NEXT FIELD agb04
         END IF 
      END IF                                                                                                                          
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            IF g_azw.azw04 ='2' THEN    #No.FUN-B90102--add-- #TQC-C30167modify azw04='2'
              IF l_n >= 3 THEN  #No.FUN-B90102--MODIFY----
#No.FUN-B90102--ADD-BEGIN--
                 CALL cl_err('','aim1111',0)
                 CANCEL INSERT
              END IF  
            END IF     #No.FUN-B90102--add--
#No.FUN-B90102--ADD-END---
   #No.FUN-B90102---ADD----

            LET p_cmd='a'
            INITIALIZE g_agb[l_ac].* TO NULL      #900423
            LET g_agb[l_ac].agbslk01='N'
            LET g_agb[l_ac].agbslk02='N'
            LET g_agb[l_ac].agbslk03='N'
            LET g_agb_t.* = g_agb[l_ac].*         #新輸入資料
            LET g_agb_o.* = g_agb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin) 
            NEXT FIELD agb02            #FUN-870117
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO agb_file(agb01,agb02,agb03,agbslk01,agbslk02,agbslk03,agb04)
                 VALUES(g_aga.aga01,g_agb[l_ac].agb02,g_agb[l_ac].agb03,
                        g_agb[l_ac].agbslk01,g_agb[l_ac].agbslk02,
                        g_agb[l_ac].agbslk03,g_agb[l_ac].agb04)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","agb_file",g_aga.aga01,g_agb[l_ac].agb02,
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CANCEL INSERT
            ELSE
               UPDATE aga_file SET agadate = g_today
                WHERE aga01 = g_aga.aga01
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
    	       COMMIT WORK
            END IF
 
        BEFORE FIELD agb02                        #default 項次
            IF cl_null(g_agb[l_ac].agb02) OR g_agb[l_ac].agb02 = 0 THEN
             IF p_cmd='a' OR(p_cmd='u' AND g_agb[l_ac].agb02!= g_agb_t.agb02) THEN      #No.FUN-810014
               SELECT MAX(agb02)
                 INTO g_agb[l_ac].agb02
                 FROM agb_file
                WHERE agb01 = g_aga.aga01
                IF cl_null(g_agb[l_ac].agb02) THEN
                   LET g_agb[l_ac].agb02 = 0
                END IF
                LET g_agb[l_ac].agb02 = g_agb[l_ac].agb02 + 1

#FUN-A50012 --begin--
                IF l_ac = 1  THEN
                   LET g_agb[l_ac].agb02 = 1
                END IF
                IF l_ac = 2  THEN
                   LET g_agb[l_ac].agb02 = 2
                END IF
#FUN-A50012 --end--



#&ifdef SLK
#               IF  g_agb[l_ac].agb02 = 3 THEN
#                   LET l_m = 0 
#                   SELECT COUNT(*) INTO l_m FROM agb_file 
#                          WHERE  agb01 = g_aga.aga01
#                   IF l_m >= 2 THEN
#                      LET g_agb[l_ac].agb02 = '' 
#                       EXIT INPUT
#                   END IF                  
#               END IF
#&endif          
             END IF                                                #No.FUN-810014
            END IF
 
        AFTER FIELD agb02                        #default 項次
            IF NOT cl_null(g_agb[l_ac].agb02) AND
               g_agb[l_ac].agb02 <> 0 AND p_cmd='a' THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM agb_file
                WHERE agb01=g_aga.aga01 AND agb02 = g_agb[l_ac].agb02
               IF l_n>0 THEN
                  LET g_agb[l_ac].agb02 = g_agb_t.agb02
                  CALL cl_err('',-239,0) NEXT FIELD agb02
               END IF
               SELECT MAX(agb02) + 1 INTO l_n  FROM agb_file
                 WHERE agb01 = g_aga.aga01 
               IF l_n != g_agb[l_ac].agb02 THEN
                  LET g_agb[l_ac].agb02= l_n
                  NEXT FIELD agb02 
               END IF   
#FUN-A50012 --begin--
               IF g_azw.azw04 ='2' THEN      #TQC-C30167 add
                  IF l_ac = 1 AND g_agb[l_ac].agb02 != 1 THEN
                     LET g_agb[l_ac].agb02 = 1
                     NEXT FIELD agb02
                  END IF
                  IF l_ac = 2 AND g_agb[l_ac].agb02 != 2 THEN
                     LET g_agb[l_ac].agb02 = 2
                     NEXT FIELD agb02
                  END IF
               END IF #TQC-C30167 add
#FUN-A50012 --end--
            END IF

        AFTER FIELD agb03                         #(屬性類型)
            IF NOT cl_null(g_agb[l_ac].agb03) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_agb[l_ac].agb03 != g_agb_t.agb03) THEN
#FUN-B90102 --begin--
                  IF g_azw.azw04 ='2' THEN        #TQC-C30167 add
                     SELECT agc07 INTO l_agc07 FROM agc_file
                            WHERE agc01 = g_agb[l_ac].agb03
                     IF l_ac ='1' THEN
                        IF l_agc07 != '1' OR cl_null(l_agc07) THEN
#                            CALL cl_err("required agb03 is color(1)",-1301,1)   #
                            CALL cl_err("","aim1108",1)                  #
                            NEXT FIELD agb03
                        END IF
                     END IF
                     IF l_ac ='2' THEN
                        IF l_agc07 != '2' OR cl_null(l_agc07) THEN
#                            CALL cl_err("required agb03 is color(1)",-1301,1)  #
                            CALL cl_err("","aim1109",1)                 #
                            NEXT FIELD agb03
                        END IF
                     END IF
                  END IF #TQC-C30167 add
#FUN-B90102 --end--
                  SELECT COUNT(*) INTO l_n FROM agb_file
                   WHERE agb01=g_aga.aga01
                     AND agb03=g_agb[l_ac].agb03
                  IF l_n>0 THEN
                     LET g_agb[l_ac].agb03 = g_agb_t.agb03
                     CALL cl_err('',-239,0) NEXT FIELD agb03
                  END IF
                  CALL i310_agb03('a')      #帶出agc_file中的對應信息
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_agb[l_ac].agb03=g_agb_t.agb03
                     NEXT FIELD agb03
                  END IF
                  #所有欄位的總的使用長度不能超過40
                  IF i310_sum_use_length() > 40 THEN
                     CALL cl_err('','aim-921',0)
                     NEXT FIELD agb03
                  END IF
#FUN-B90102---MARK--BEGIN----
#&ifdef SLK
##FUN-A50012 --begin--
#                  SELECT agc07 INTO l_agc07 FROM agc_file
#                         WHERE agc01 = g_agb[l_ac].agb03
#                  IF l_ac ='1' THEN
#                     IF l_agc07 != '1' OR cl_null(l_agc07) THEN
##                         CALL cl_err("required agb03 is color(1)",-1301,1)   #
#                         CALL cl_err("","aim1108",1)                  #
#                         NEXT FIELD agb03
#                     END IF
#                  END IF           
#                  IF l_ac ='2' THEN
#                     IF l_agc07 != '2' OR cl_null(l_agc07) THEN
##                         CALL cl_err("required agb03 is color(1)",-1301,1)  #
#                         CALL cl_err("","aim1109",1)                 #
#                         NEXT FIELD agb03
#                     END IF
#                  END IF           
##FUN-A50012 --end--
#&endif
#FUN-B90102---MARK--END-------
               END IF
            END IF
       
        BEFORE DELETE      #是否取消單身
           IF g_agb_t.agb02 > 0 AND (NOT cl_null(g_agb_t.agb02)) THEN
              SELECT COUNT(boe01) INTO l_n1 FROM boe_file,ima_file 
               WHERE boe_file.boe01 = ima01 AND imaag = g_aga.aga01 
              IF l_n1 >0 THEN
                 CALL cl_err('','aim-007',1)
                 CANCEL DELETE
              END IF
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               SELECT MAX(agb02) INTO l_n FROM agb_file 
                  WHERE agb01 = g_aga.aga01
               DELETE FROM agb_file
                WHERE agb01 = g_aga.aga01 AND agb02 = g_agb_t.agb02
               IF SQLCA.sqlcode OR g_success='N' THEN
                  LET l_buf = g_agb_t.agb02 clipped
                  CALL cl_err(l_buf,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               FOR l_i = g_agb[l_ac].agb02 TO l_n 
                 LET l_i = l_i + 1   
                 UPDATE agb_file SET agb02 = l_i - 1
                   WHERE agb02 = l_i AND agb01 = g_aga.aga01
                   LET l_i = l_i -1      #No.FUN-870117 
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('',SQLCA.sqlcode,0)
                    ROLLBACK WORK 
                    EXIT FOR
                 END IF   
               END FOR
               LET l_i1 = 0
               FOR l_i=1 TO l_n
                 IF l_i = l_ac THEN
                    CONTINUE FOR
                 ELSE 
                 	  LET l_i1 =l_i1 + 1    
                    LET g_agb[l_i].agb02 = l_i1
                 END IF    
               END FOR          
               LET g_rec_b=g_rec_b-1
            END IF
            MESSAGE "DELETE O.K"
	          COMMIT WORK 
	          
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_agb[l_ac].* = g_agb_t.*
               CLOSE i310_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_agb[l_ac].agb03,-263,1)
               LET g_agb[l_ac].* = g_agb_t.*
            ELSE
               UPDATE agb_file
                  SET agb02=g_agb[l_ac].agb02,
                      agb03=g_agb[l_ac].agb03,
                      agbslk01=g_agb[l_ac].agbslk01,
                      agbslk02=g_agb[l_ac].agbslk02,
                      agbslk03=g_agb[l_ac].agbslk03,
                      agb04    =g_agb[l_ac].agb04
                WHERE agb01=g_aga.aga01
                  AND agb02=g_agb_t.agb02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","agb_file",g_aga.aga01,g_agb_t.agb02,
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                   LET g_agb[l_ac].* = g_agb_t.*
                ELSE
                   UPDATE aga_file SET agadate = g_today
                    WHERE aga01 = g_aga.aga01
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
                  LET g_agb[l_ac].* = g_agb_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_agb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i310_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE i310_b_curl
            COMMIT WORK
 
     ON ACTION CONTROLP
           CASE WHEN INFIELD(agb03) #料件主檔
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_agc"
                  LET g_qryparam.default1=g_agb[l_ac].agb03
                  IF g_azw.azw04='2'  THEN   #TQC-C30167 ADD
                     LET g_qryparam.where=" agc07='1' OR agc07='2' "   #add--No.FUN-B90102--
                  END IF                     #TQC-C30167 ADD
                  CALL cl_create_qry() RETURNING g_agb[l_ac].agb03
                  DISPLAY g_agb[l_ac].agb03 TO agb03	
                  NEXT FIELD agb03
               OTHERWISE EXIT CASE
           END  CASE
 
     ON ACTION CONTROLN
            CALL i310_b_askkey()
            EXIT INPUT
 
     ON ACTION CONTROLO                       #沿用所有欄位
           IF INFIELD(agb02) AND l_ac > 1 THEN   #TQC-720065
              LET g_agb[l_ac].* = g_agb[l_ac-1].*
              LET g_agb[l_ac].agb02 = NULL
              NEXT FIELD agb02
           END IF
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
            CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
    END INPUT
    UPDATE aga_file SET agamodu = g_user,agadate = g_today
     WHERE aga01 = g_aga.aga01
 
    CLOSE i310_b_curl
    COMMIT WORK
#FUN-B90102 ---ADD-BEGIN----
    IF g_azw.azw04='2' THEN  #TQC-C30167 add
    CALL t310_delall()
    END IF                   #TQC-C30167 add
#FUN-B90102 ---ADD-END------
END FUNCTION
#FUN-B90102 ---ADD-BEGIN----
FUNCTION t310_delall()
DEFINE    l_count   LIKE type_file.num5

   SELECT COUNT(*) INTO l_count FROM agb_file
    WHERE agb01 = g_aga.aga01 

   IF l_count = 0 OR l_count = 1 THEN                  
      CALL cl_err("","aim1110",1)

      IF cl_confirm("9042") THEN       #CHI-C30002 add
         DELETE FROM aga_file WHERE aga01 = g_aga.aga01 
         DELETE FROM agb_file WHERE agb01 = g_aga.aga01
         CLEAR FORM
         CALL g_agb.clear()
         OPEN i310_count
         
         IF STATUS THEN
            CLOSE i310_count
            RETURN
         END IF
          
         FETCH i310_count INTO g_row_count
            
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i310_count
            RETURN
         END IF
          
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i310_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i310_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE    
            CALL i310_fetch('/')
         END IF
      END IF          #CHI-C30002 add
   END IF

END FUNCTION
#FUN-B90102 ---ADD-END------
 
FUNCTION i310_agb03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ima110        LIKE ima_file.ima110,
    l_imaacti       LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT agc02,agc03
      INTO g_agb[l_ac].agc02,g_agb[l_ac].agc03
      FROM agc_file
     WHERE agc01 = g_agb[l_ac].agb03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aim-912'
                                   LET g_agb[l_ac].agc02 = NULL
                                   LET g_agb[l_ac].agc03 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
 
#單身重查
FUNCTION i310_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CLEAR agc02,agc03
    CONSTRUCT l_wc2 ON agb02,agb03,# 螢幕上取單身條件
                       agbslk01,agbslk02,agbslk03,      #FUN-810014   
                       agb04     #FUN-810014
         FROM s_agb[1].agb02,s_agb[1].agb03,
              s_agb[1].agbslk01,s_agb[1].agbslk02,s_agb[1].agbslk03,     #FUN-810014 
              s_agb[1].agb04     #FUN-810014
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCt
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL i310_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i310_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(300)
 
    LET g_sql =
        "SELECT agb02,agb03,agc02,agc03,agbslk01,agbslk02,agbslk03,agb04",    #FUN-810014
        "  FROM agb_file, OUTER agc_file",
        " WHERE agb01 ='",g_aga.aga01,"' ",
        "   AND agb_file.agb03 = agc_file.agc01 ",
        "   AND ",p_wc2 CLIPPED
 
    PREPARE i310_pb FROM g_sql
    DECLARE agb_curs                       #SCROLL CURSOR
        CURSOR FOR i310_pb
 
    CALL g_agb.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH agb_curs INTO g_agb[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('',9035,0)
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_agb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i310_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_agb TO s_agb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED) #add unbuffered
 
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
         CALL i310_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION previous
         CALL i310_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION jump
         CALL i310_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION next
         CALL i310_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
      ON ACTION last
         CALL i310_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
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
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
            CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i310_copy()
DEFINE
    new_ver     LIKE aga_file.aga01,
    old_ver     LIKE aga_file.aga01,
    l_n         LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_aga.aga01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   LET g_before_input_done = FALSE        #No.FUN-810014
   CALL i310_set_entry('a')               #No.FUN-810014
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
 WHILE TRUE
   INPUT new_ver FROM aga01
       AFTER FIELD aga01
           IF NOT cl_null(new_ver) THEN
              SELECT COUNT(*) INTO l_n FROM aga_file
               WHERE aga01 = new_ver
              IF l_n > 0 THEN                  # Duplicated
                 CALL cl_err(new_ver,-239,0)
                 NEXT FIELD aga01
              END IF
           END IF
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      DISPLAY BY NAME g_aga.aga01
      RETURN
   END IF
   IF new_ver IS NULL THEN
      CONTINUE WHILE
   END IF
   EXIT WHILE
 END WHILE
 
   DROP TABLE y
   SELECT * FROM aga_file
    WHERE aga01=g_aga.aga01
     INTO TEMP y
   UPDATE y
      SET aga01 = new_ver,
          agauser=g_user,
          agagrup=g_grup,
          agamodu=NULL,
          agadate=g_today,
          agaacti='Y'
   INSERT INTO aga_file
      SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","aga_file",new_ver,"",
                    SQLCA.sqlcode,"","",1)  #No.FUN-660156
   END IF
 
   DROP TABLE x
   SELECT * FROM agb_file
       WHERE agb01=g_aga.aga01
        INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_aga.aga01,"",
                    SQLCA.sqlcode,"","",1)  #No.FUN-660156
      RETURN
   END IF
   UPDATE x
      SET agb01=new_ver
   INSERT INTO agb_file
      SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","agb_file",g_aga.aga01,"",
                    SQLCA.sqlcode,"","",1)  #No.FUN-660156
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE 'ROW(',new_ver,') O.K'
   LET old_ver = g_aga.aga01
   SELECT aga_file.* INTO g_aga.* FROM aga_file
    WHERE aga01=new_ver
   CALL i310_u()
   CALL i310_b()
   #SELECT aga_file.* INTO g_aga.* FROM aga_file #FUN-C30027
   # WHERE aga01 = old_ver                       #FUN-C30027
   CALL i310_show()
END FUNCTION
 
FUNCTION i310_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aga01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i310_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aga01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i310_sum_use_length()
DEFINE
  li_i,li_sum    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
  LET li_sum = 0
  FOR li_i = 1 TO g_agb.getLength()
      LET li_sum = li_sum + g_agb[li_i].agc03
  END FOR
 
  RETURN li_sum
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

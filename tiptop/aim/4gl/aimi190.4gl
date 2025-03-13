# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimi190.4gl
# Descriptions...: 細部品名資料維護作業
# Date & Author..: 92/02/11 By Lin
# Modify.........: 92/10/08 By Stone
#                  Extend array from 30 to 100
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0043 07/12/25 By Cockroach 報表改為p_query實現
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-930082 09/08/12 By arman   細部品名碼欄位查詢功能開窗
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90177 11/09/29 By destiny oriu,orig不能查询 
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_imv            RECORD LIKE imv_file.*,  #細部品名碼 (假單頭)
    g_imv_t          RECORD LIKE imv_file.*,  #細部品名碼 (舊值)
    g_imv_o          RECORD LIKE imv_file.*,  #細部品名碼 (舊值)
    g_imv01_t        LIKE imv_file.imv01,     #細部品名碼 (舊值)
    g_imw            DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        imw02        LIKE imw_file.imw02,     #項次
        imw03        LIKE imw_file.imw03      #細部品名
                     END RECORD,
    g_imw_t          RECORD                   #程式變數 (舊值)
        imw02        LIKE imw_file.imw02,     #項次
        imw03        LIKE imw_file.imw03      #細部品名
                     END RECORD,
    g_wc,g_wc2,g_sql STRING,                  #TQC-630166
    g_rec_b          LIKE type_file.num5,     #單身筆數  #No.FUN-690026 SMALLINT
    l_ac             LIKE type_file.num5      #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col   LIKE type_file.num5      #No.FUN-690026 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
MAIN
#DEFINE                                          #No.FUN-6A0074
#       l_time    LIKE type_file.chr8            #No.FUN-6A0074
 
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
 
 
    IF g_sma.sma64='N' THEN
       CALL cl_err(g_sma.sma64,'mfg0061',3)
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET g_forupd_sql =
        "SELECT * FROM imv_file WHERE imv01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i190_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW i190_w AT p_row,p_col          #顯示畫面
         WITH FORM "aim/42f/aimi190"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL i190_menu()
    CLOSE WINDOW i190_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION i190_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_imw.clear()
 
    INITIALIZE g_imv.* TO NULL      #FUN-640213 add
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        imv01,imv02,imv03,
        imvuser,imvgrup,imvmodu,imvdate,imvacti
        ,imvoriu,imvorig  #TQC-B90177
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       #NO.FUN-930082 ---begin--
       ON ACTION CONTROLP                                                       
         CASE WHEN INFIELD(imv01) #細部品名碼                                     
                CALL cl_init_qry_var()                                          
                LET g_qryparam.state= "c"                                       
                LET g_qryparam.form = "q_imv"                                   
                CALL cl_create_qry() RETURNING g_qryparam.multiret              
                DISPLAY g_qryparam.multiret TO imv01                            
                NEXT FIELD imv01                                                
          OTHERWISE EXIT CASE                                                   
          END CASE  
       #NO.FUN-930082 ---end--
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
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imvuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imvgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imvgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imvuser', 'imvgrup')
    #End:FUN-980030
 
 
    CALL g_imw.clear()
    CONSTRUCT g_wc2 ON imw02,imw03                # 螢幕上取單身條件
            FROM s_imw[1].imw02,s_imw[1].imw03
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
       LET g_sql = "SELECT  imv01 FROM imv_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY imv01"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imv_file. imv01 ",
                   "  FROM imv_file, imw_file ",
                   " WHERE imv01 = imw01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY imv01"
    END IF
 
    PREPARE i190_prepare FROM g_sql
    DECLARE i190_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i190_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imv_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imv01) FROM imv_file,imw_file WHERE ",
                  "imw01=imv01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i190_precount FROM g_sql
    DECLARE i190_count CURSOR FOR i190_precount
END FUNCTION
 
FUNCTION i190_menu()
   WHILE TRUE
      CALL i190_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i190_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i190_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i190_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i190_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i190_x()
               CALL cl_set_field_pic("","","","","",g_imv.imvacti)
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i190_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i190_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i190_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imw),'','')
            END IF
 
         WHEN "related_document"                #No.FUN-680046  相關文件
            IF cl_chk_act_auth() THEN                     
                IF g_imv.imv01 IS NOT NULL THEN           
                   LET g_doc.column1 = "imv01"             
                   LET g_doc.value1 = g_imv.imv01         
                   CALL cl_doc()                          
                END IF                                   
            END IF                                       
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i190_a()
    LET g_wc = NULL
    LET g_wc2 = NULL
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_imw.clear()
    CALL g_imw.clear()
    INITIALIZE g_imv.* LIKE imv_file.*             #DEFAULT 設定
    LET g_imv01_t = NULL
    #預設值及將數值類變數清成零
    LET g_imv_o.* = g_imv.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imv.imvuser=g_user
        LET g_imv.imvoriu = g_user #FUN-980030
        LET g_imv.imvorig = g_grup #FUN-980030
        LET g_imv.imvgrup=g_grup
        LET g_imv.imvdate=g_today
        LET g_imv.imvacti='Y'              #資料有效
        CALL i190_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_imv.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_imv.imv01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO imv_file VALUES (g_imv.*)
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
#           CALL cl_err(g_imv.imv01,SQLCA.sqlcode,1) #No.FUN-660156
            CALL cl_err3("ins","imv_file",g_imv.imv01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        SELECT imv01 INTO g_imv.imv01 FROM imv_file
            WHERE imv01 = g_imv.imv01
        LET g_imv01_t = g_imv.imv01        #保留舊值
        LET g_imv_t.* = g_imv.*
        CALL g_imw.clear()
        LET g_rec_b=0
        CALL i190_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i190_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_imv.imv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_imv.* FROM imv_file WHERE imv01=g_imv.imv01
    IF g_imv.imvacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_imv.imv01,9027,0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imv01_t = g_imv.imv01
    LET g_imv_o.* = g_imv.*
    BEGIN WORK
 
    OPEN i190_cl USING g_imv.imv01
    IF STATUS THEN
       CALL cl_err("OPEN i190_cl:", STATUS, 1)
       CLOSE i190_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i190_cl INTO g_imv.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i190_cl ROLLBACK WORK RETURN
    END IF
    CALL i190_show()
    WHILE TRUE
        LET g_imv01_t = g_imv.imv01
        LET g_imv.imvmodu=g_user
        LET g_imv.imvdate=g_today
        CALL i190_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imv.*=g_imv_t.*
            CALL i190_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_imv.imv01 != g_imv01_t THEN      #更改細部品名碼
            UPDATE imw_file SET imw01 = g_imv.imv01
                WHERE imw01 = g_imv01_t
            IF SQLCA.sqlcode THEN
#              CALL cl_err('imw',SQLCA.sqlcode,0)  #No.FUN-660156
               CALL cl_err3("upd","imw_file",g_imv01_t,"",SQLCA.sqlcode,"",
                            "imw",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
        END IF
            UPDATE imv_file SET imv.* = g_imv.*  
             WHERE imv01 = g_imv01_t                 
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imv_file",g_imv_t.imv01,"",SQLCA.sqlcode,"",
                        "",1)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i190_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION i190_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-690026 VARCHAR(1)
 
    DISPLAY BY NAME g_imv.imvuser,g_imv.imvmodu,
        g_imv.imvgrup,g_imv.imvdate,g_imv.imvacti
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0030
    INPUT BY NAME g_imv.imvoriu,g_imv.imvorig,
        g_imv.imv01,g_imv.imv02,g_imv.imv03  WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i190_set_entry(p_cmd)
            CALL i190_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD imv01                  #細部品名碼
            IF g_imv.imv01 != g_imv01_t OR g_imv01_t IS NULL THEN
                SELECT count(*) INTO g_cnt FROM imv_file
                    WHERE imv01 = g_imv.imv01
                IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_imv.imv01,-239,0)
                    LET g_imv.imv01 = g_imv01_t
                    DISPLAY BY NAME g_imv.imv01
                    NEXT FIELD imv01
                END IF
            END IF
 
        AFTER FIELD imv03                  #細部品名之位數
            IF g_imv.imv03 <=0 OR g_imv.imv03 > 30 THEN
               CALL cl_err(g_imv.imv03,'mfg6032',0)
               LET g_imv.imv03=g_imv_o.imv03
               DISPLAY BY NAME g_imv.imv03
               NEXT FIELD imv03
            END IF
            LET g_imv_o.imv03=g_imv.imv03
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imv.imvuser = s_get_data_owner("imv_file") #FUN-C10039
           LET g_imv.imvgrup = s_get_data_group("imv_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_imv.imv03 IS NULL OR g_imv.imv03 <=0 OR g_imv.imv03 > 30 THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imv.imv03
            END IF
            IF l_flag='Y' THEN
                CALL cl_err('','9033',0)
                NEXT FIELD imv01
            END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start  
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(imv01) THEN
        #        LET g_imv.* = g_imv_t.*
        #        DISPLAY BY NAME g_imv.*
        #        NEXT FIELD imv01
        #    END IF
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
 
#Query 查詢
FUNCTION i190_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_imw.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i190_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i190_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imv.* TO NULL
    ELSE
        OPEN i190_count
        FETCH i190_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i190_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i190_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式    #No.FUN-690026 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i190_cs INTO g_imv.imv01
        WHEN 'P' FETCH PREVIOUS i190_cs INTO g_imv.imv01
        WHEN 'F' FETCH FIRST    i190_cs INTO g_imv.imv01
        WHEN 'L' FETCH LAST     i190_cs INTO g_imv.imv01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
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
            FETCH ABSOLUTE g_jump i190_cs INTO g_imv.imv01 --改g_jump
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0)
        INITIALIZE g_imv.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_imv.* FROM imv_file WHERE imv01 = g_imv.imv01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0) #No.FUN-660156
        CALL cl_err3("sel","imv_file",g_imv.imv01,"",SQLCA.sqlcode,"",
                     "",1)  #No.FUN-660156
        INITIALIZE g_imv.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_imv.imvuser      #FUN-4C0053
        LET g_data_group = g_imv.imvgrup      #FUN-4C0053
    END IF
 
#       LET g_data_owner = g_imv.imvuser
#       LET g_data_group = g_imv.imvgrup
    CALL i190_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i190_show()
    LET g_imv_t.* = g_imv.*                #保存單頭舊值
    DISPLAY BY NAME g_imv.imvoriu,g_imv.imvorig,                              # 顯示單頭值
        g_imv.imv01,g_imv.imv02,g_imv.imv03,
        g_imv.imvuser,g_imv.imvgrup,g_imv.imvmodu,
        g_imv.imvdate,g_imv.imvacti
    CALL cl_set_field_pic("","","","","",g_imv.imvacti)
 
    CALL i190_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i190_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_imv.imv01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i190_cl USING g_imv.imv01
    IF STATUS THEN
       CALL cl_err("OPEN i190_cl:", STATUS, 1)
       CLOSE i190_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i190_cl INTO g_imv.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i190_cl ROLLBACK WORK RETURN
    END IF
    CALL i190_show()
    IF cl_exp(0,0,g_imv.imvacti) THEN
        LET g_chr=g_imv.imvacti
        IF g_imv.imvacti='Y' THEN
            LET g_imv.imvacti='N'
        ELSE
            LET g_imv.imvacti='Y'
        END IF
        UPDATE imv_file                    #更改有效碼
            SET imvacti=g_imv.imvacti
            WHERE imv01=g_imv.imv01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imv_file",g_imv.imv01,"",SQLCA.sqlcode,"",
                        "",1)  #No.FUN-660156
           LET g_imv.imvacti=g_chr
        END IF
        DISPLAY BY NAME g_imv.imvacti
    END IF
    CLOSE i190_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i190_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imv.imv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i190_cl USING g_imv.imv01
    IF STATUS THEN
       CALL cl_err("OPEN i190_cl:", STATUS, 1)
       CLOSE i190_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i190_cl INTO g_imv.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE i190_cl ROLLBACK WORK RETURN
    END IF
    CALL i190_show()
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imv01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imv.imv01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM imv_file WHERE imv01 = g_imv.imv01
        DELETE FROM imw_file WHERE imw01=g_imv.imv01
        IF SQLCA.SQLERRD[3]=0
           THEN # CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0)  #No.FUN-660156
           CALL cl_err3("del","imv_file,imw_file",g_imv.imv01,"",SQLCA.sqlcode,"",
                        "",1)  #No.FUN-660156
           ELSE
           CLEAR FORM
           CALL g_imw.clear()
         OPEN i190_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i190_cs
            CLOSE i190_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i190_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i190_cs
            CLOSE i190_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i190_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i190_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i190_fetch('/')
         END IF
        END IF
    END IF
    CLOSE i190_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i190_b()
DEFINE
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,      #處理狀態    #No.FUN-690026 VARCHAR(1)
    l_length        LIKE type_file.num5,      #長度        #No.FUN-690026 SMALLINT
    l_allow_insert  LIKE type_file.num5,      #可新增否    #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5       #可刪除否    #No.FUN-690026 SMALLINT
 
    LET g_action_choice = ""
    IF g_imv.imv01 IS NULL THEN RETURN END IF
    SELECT * INTO g_imv.* FROM imv_file WHERE imv01=g_imv.imv01
    IF g_imv.imvacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imv.imv01,'aom-000',0)
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT imw02,imw03 ",
      "   FROM imw_file ",
      "   WHERE imw01= ? ",
      "    AND imw02= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i190_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_imw WITHOUT DEFAULTS FROM s_imw.*
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
           OPEN i190_cl USING g_imv.imv01
           IF STATUS THEN
              CALL cl_err("OPEN i190_cl:", STATUS, 1)
              CLOSE i190_cl
              ROLLBACK WORK
              RETURN
           ELSE
              FETCH i190_cl INTO g_imv.*            # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                 CLOSE i190_cl
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_imw_t.* = g_imw[l_ac].*  #BACKUP
 
              OPEN i190_bcl USING g_imv.imv01,g_imw_t.imw02
              DISPLAY "imv01,imw02",g_imv.imv01,g_imw_t.imw02
              IF STATUS THEN
                 CALL cl_err("OPEN i190_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i190_bcl INTO g_imw[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err('FETCH i190_bcl',SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO imw_file(imw01,imw02,imw03)
                VALUES(g_imv.imv01,g_imw[l_ac].imw02,g_imw[l_ac].imw03)
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_imw[l_ac].imw02,SQLCA.sqlcode,0)  #No.FUN-660156
              CALL cl_err3("ins","imw_file",g_imv.imv01,g_imw[l_ac].imw02,SQLCA.sqlcode,"",
                           "",1)  #No.FUN-660156
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_imw[l_ac].* TO NULL      #900423
           LET g_imw_t.* = g_imw[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD imw02
 
        BEFORE FIELD imw02                        #default 序號
            IF g_imw[l_ac].imw02 IS NULL OR
               g_imw[l_ac].imw02 = 0 THEN
                SELECT max(imw02)+1
                   INTO g_imw[l_ac].imw02
                   FROM imw_file
                   WHERE imw01 = g_imv.imv01
                IF g_imw[l_ac].imw02 IS NULL THEN
                    LET g_imw[l_ac].imw02 = 1
                END IF
            END IF
 
        AFTER FIELD imw02                        #check 序號是否重複
            IF g_imw[l_ac].imw02 != g_imw_t.imw02 OR
               g_imw_t.imw02 IS NULL THEN
                SELECT count(*)
                    INTO l_n
                    FROM imw_file
                    WHERE imw01 = g_imv.imv01 AND
                          imw02 = g_imw[l_ac].imw02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_imw[l_ac].imw02 = g_imw_t.imw02
                    NEXT FIELD imw02
                END IF
            END IF
 
        AFTER FIELD imw03
            LET l_length=LENGTH(g_imw[l_ac].imw03)
            IF l_length > g_imv.imv03 THEN
               CALL cl_err(g_imw[l_ac].imw03,'mfg6034',0)
               LET g_imw[l_ac].imw03 = g_imw_t.imw03
               #------MOD-5A0095 START----------
               DISPLAY BY NAME g_imw[l_ac].imw03
               #------MOD-5A0095 END------------
               NEXT FIELD imw03
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_imw_t.imw02 > 0 AND
               g_imw_t.imw02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM imw_file
                    WHERE imw01 = g_imv.imv01 AND
                          imw02 = g_imw_t.imw02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_imw_t.imw02,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("del","imw_file",g_imv.imv01,g_imw_t.imw02,SQLCA.sqlcode,"",
                                "",1)  #No.FUN-660156
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imw[l_ac].* = g_imw_t.*
               CLOSE i190_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imw[l_ac].imw02,-263,1)
               LET g_imw[l_ac].* = g_imw_t.*
            ELSE
               UPDATE imw_file SET
                  imw02 = g_imw[l_ac].imw02,
                  imw03 = g_imw[l_ac].imw03
                WHERE imw01=g_imv.imv01
                  AND imw02=g_imw_t.imw02
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_imw[l_ac].imw02,SQLCA.sqlcode,0)
                  CALL cl_err3("upd","imw_file",g_imv.imv01,g_imw_t.imw02,SQLCA.sqlcode,"",
                               "",1)  #No.FUN-660156
                   LET g_imw[l_ac].* = g_imw_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_imw[l_ac].* = g_imw_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_imw.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i190_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE i190_bcl
            COMMIT WORK
 
     #  ON ACTION CONTROLN
     #      CALL i190_b_askkey()
     #      LET l_exit_sw = "n"
     #      EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(imw02) AND l_ac > 1 THEN
                LET g_imw[l_ac].* = g_imw[l_ac-1].*
                NEXT FIELD imw02
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
#No.FUN-6B0030------Begin-------------- 
     ON ACTION controls
         CALL cl_set_head_visible("","AUTO")
#No.FUN-6B0030-----End------------------     
 
        END INPUT
 
        UPDATE imv_file SET imvmodu=g_user,imvdate=g_today
            WHERE imv01=g_imv.imv01
 
    CLOSE i190_bcl
    COMMIT WORK
#   CALL i190_delall()        #CHI-C30002 mark
    CALL i190_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i190_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM imv_file WHERE imv01 = g_imv.imv01
         INITIALIZE g_imv.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i190_delall()
#   SELECT COUNT(*) INTO g_cnt FROM imw_file
#       WHERE imw01 = g_imv.imv01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM imv_file WHERE imv01 = g_imv.imv01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i190_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
#   CLEAR imw03
    CONSTRUCT l_wc2 ON imw02,imw03
            FROM s_imw[1].imw02,s_imw[1].imw03
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
    CALL i190_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i190_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    LET g_sql =
        "SELECT imw02,imw03,'' ",
        " FROM imw_file",
    #No.FUN-8B0123---Begin
        " WHERE imw01 ='",g_imv.imv01,"'"  #AND ",  #單頭
    #   p_wc2 CLIPPED,                     #單身
    #   " ORDER BY imw02"
    IF NOT cl_null(p_wc2) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY imw02 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
    
    PREPARE i190_pb FROM g_sql
    DECLARE imw_curs                       #CURSOR
        CURSOR FOR i190_pb
 
    CALL g_imw.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH imw_curs INTO g_imw[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_rec_b = g_rec_b + 1
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
 
    CALL g_imw.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i190_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imw TO s_imw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL i190_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i190_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i190_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i190_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i190_fetch('L')
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
         CALL cl_set_field_pic("","","","","",g_imv.imvacti)
 
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
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document             #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY    
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------           
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i190_copy()
DEFINE
    l_imv		RECORD LIKE imv_file.*,
    l_oldno,l_newno	LIKE imv_file.imv01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imv.imv01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-580026
    CALL i190_set_entry('a')          #FUN-580026
    LET g_before_input_done = TRUE    #FUN-580026
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM imv01
        AFTER FIELD imv01
            IF l_newno IS NULL THEN
                NEXT FIELD imv01
            END IF
            SELECT count(*) INTO g_cnt FROM imv_file
                WHERE imv01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD imv01
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
        DISPLAY BY NAME g_imv.imv01
        RETURN
    END IF
    LET l_imv.* = g_imv.*
    LET l_imv.imv01  =l_newno   #新的鍵值
    LET l_imv.imvuser=g_user    #資料所有者
    LET l_imv.imvgrup=g_grup    #資料所有者所屬群
    LET l_imv.imvmodu=NULL      #資料修改日期
    LET l_imv.imvdate=g_today   #資料建立日期
    LET l_imv.imvacti='Y'       #有效資料
    LET l_imv.imvoriu = g_user      #No.FUN-980030 10/01/04
    LET l_imv.imvorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO imv_file VALUES (l_imv.*)
    IF SQLCA.sqlcode THEN
#      CALL cl_err('imv:',SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","imv_file",l_imv.imv01,"",SQLCA.sqlcode,"",
                    "imv:",1)  #No.FUN-660156
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM imw_file         #單身複製
        WHERE imw01=g_imv.imv01
        INTO TEMP x
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imv.imv01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","x",g_imv.imv01,"",SQLCA.sqlcode,"",
                    "",1)  #No.FUN-660156
        RETURN
    END IF
    UPDATE x
        SET imw01=l_newno
    INSERT INTO imw_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
#      CALL cl_err('imw:',SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("ins","imw_file",g_imv.imv01,"",SQLCA.sqlcode,"",
                    "imw:",1)  #No.FUN-660156
       RETURN
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
     LET l_oldno = g_imv.imv01
     SELECT imv_file.* INTO g_imv.* FROM imv_file WHERE imv01 = l_newno
     CALL i190_u()
     CALL i190_b()
     #SELECT imv_file.* INTO g_imv.* FROM imv_file WHERE imv01 = l_oldno  #FUN-C30027
     CALL i190_show()
END FUNCTION
#No.FUN-7C0043 --BEGIN--
FUNCTION i190_out()
#DEFINE
#   l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#   sr              RECORD
#       imv01       LIKE imv_file.imv01,   #細部品名碼
#       imv02       LIKE imv_file.imv02,   #說明
#       imv03       LIKE imv_file.imv03,   #位數
#       imw02       LIKE imw_file.imw02,   #項次
#       imw03       LIKE imw_file.imw03,   #細部品名
#       imvacti     LIKE imv_file.imvacti
#                   END RECORD,
#   l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#   l_za05          LIKE type_file.chr1000              #  #No.FUN-690026 VARCHAR(40)
DEFINE l_cmd     LIKE  type_file.chr1000   #NO.FUN-7C0043  
    IF cl_null(g_wc) AND NOT cl_null(g_imv.imv01) THEN                                                                              
        LET g_wc=" imv01='",g_imv.imv01,"'"                                                                                         
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    IF cl_null(g_wc2) THEN                                                                                                          
       LET g_wc2 = ' 1=1'                                                                                                           
    END IF                                                                                                                          
    #報表轉為使用 p_query                                                                                                           
    LET l_cmd = ' p_query "aimi190" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                         
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN                                                
#   IF cl_null(g_wc) THEN
#       LET g_wc=" imv01='",g_imv.imv01,"'"
#       LET g_wc2 = ' 1=1'
#   END IF
#   CALL cl_wait()
#   CALL cl_outnam('aimi190') RETURNING l_name
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT imv01,imv02,imv03,imw02,imw03,imvacti ",
#         " FROM imv_file,OUTER imw_file ",
#         " WHERE imv_file.imv01 = imw_file.imw01 AND ",g_wc CLIPPED,
#         " AND ",g_wc2 CLIPPED
#   PREPARE i190_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i190_co                         # CURSOR
#       CURSOR FOR i190_p1
 
#   START REPORT i190_rep TO l_name
 
#   FOREACH i190_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#          CALL cl_err('foreach:',SQLCA.sqlcode,1)
#          EXIT FOREACH
#       END IF
 
#       OUTPUT TO REPORT i190_rep(sr.*)
 
#   END FOREACH
 
#   FINISH REPORT i190_rep
 
#   CLOSE i190_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i190_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#   l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#   sr              RECORD
#       imv01       LIKE imv_file.imv01,   #細部品名碼
#       imv02       LIKE imv_file.imv02,   #說明
#       imv03       LIKE imv_file.imv03,   #位數
#       imw02       LIKE imw_file.imw02,   #項次
#       imw03       LIKE imw_file.imw03,   #細部品名
#       imvacti     LIKE imv_file.imvacti
#                   END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.imv01,sr.imw02
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED,pageno_total
#           PRINT
#           PRINT g_dash
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       BEFORE GROUP OF sr.imv01  #細部品名
#           LET l_sw='Y'
 
#       ON EVERY ROW
#           IF l_sw='Y' THEN
#              IF sr.imvacti = 'N' THEN
#                  PRINT COLUMN g_c[31],'*' ;
#              ELSE
#                  PRINT COLUMN g_c[31],' ' ;
#              END IF
#              PRINT COLUMN g_c[32],sr.imv01,
#                    COLUMN g_c[33],sr.imv02,
#                    COLUMN g_c[34],sr.imv03  USING "#& " ;
#              LET l_sw='N'
#           END IF
#           PRINT COLUMN g_c[35],sr.imw02 USING '###&',
#                 COLUMN g_c[36],sr.imw03
 
#       AFTER GROUP OF sr.imv01
#           SKIP 1 LINE
 
#       ON LAST ROW
#           PRINT g_dash
#           IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#              THEN 
#                   #TQC-630166
#                   #IF g_wc[001,080] > ' ' THEN
#       	    #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
#                   #IF g_wc[071,140] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
#                   #IF g_wc[141,210] > ' ' THEN
#       	    #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
#                   CALL cl_prt_pos_wc(g_wc)
#                   #END TQC-630166
#           END IF
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
# No.FUN-7C0043 --END--
 
FUNCTION i190_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("imv01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i190_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("imv01",FALSE)
       END IF
   END IF
 
END FUNCTION
#Patch....NO.MOD-5A0095 <001> #


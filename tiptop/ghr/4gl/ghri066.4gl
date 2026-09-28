# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghri066.4gl
# Descriptions...: 群组维护作业
# Date & Author..: 13/05/23


DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_hrck         RECORD LIKE hrck_file.*,       #簽核等級 (單頭)
       g_hrck_t       RECORD LIKE hrck_file.*,       #簽核等級 (舊值)
       g_hrck_o       RECORD LIKE hrck_file.*,       #簽核等級 (舊值)
       g_hrck01_t     LIKE hrck_file.hrck01,          #簽核等級 (舊值)
       g_hrcka         DYNAMIC ARRAY OF RECORD 
         hrcka01    LIKE   hrcka_file.hrcka01,
         hrcka02    LIKE   hrcka_file.hrcka02,
         hrcka03    LIKE   hrcka_file.hrcka03,
         hrcka04    LIKE   hrcka_file.hrcka04,
         hrcka05    LIKE   hrcka_file.hrcka05,
         hrcka06    LIKE   hrcka_file.hrcka06,
         hrcka07    LIKE   hrcka_file.hrcka07,
         hrcka08    LIKE   hrcka_file.hrcka08,
         hrcka09    LIKE   hrcka_file.hrcka09,
         hrcka10    LIKE   hrcka_file.hrcka10,
         hrcka11    LIKE   hrcka_file.hrcka11,
         hrcka12    LIKE   hrcka_file.hrcka12,
         hrcka13    LIKE   hrcka_file.hrcka13,
         hrcka14    LIKE   hrcka_file.hrcka14,
         hrcka15    LIKE   hrcka_file.hrcka15
               END RECORD,
       g_hrcka_o       RECORD  
         hrcka01    LIKE   hrcka_file.hrcka01,
         hrcka02    LIKE   hrcka_file.hrcka02,
         hrcka03    LIKE   hrcka_file.hrcka03,
         hrcka04    LIKE   hrcka_file.hrcka04,
         hrcka05    LIKE   hrcka_file.hrcka05,
         hrcka06    LIKE   hrcka_file.hrcka06,
         hrcka07    LIKE   hrcka_file.hrcka07,
         hrcka08    LIKE   hrcka_file.hrcka08,
         hrcka09    LIKE   hrcka_file.hrcka09,
         hrcka10    LIKE   hrcka_file.hrcka10,
         hrcka11    LIKE   hrcka_file.hrcka11,
         hrcka12    LIKE   hrcka_file.hrcka12,
         hrcka13    LIKE   hrcka_file.hrcka13,
         hrcka14    LIKE   hrcka_file.hrcka14,
         hrcka15    LIKE   hrcka_file.hrcka15
               END RECORD,
       g_hrcka_t       RECORD  
         hrcka01    LIKE   hrcka_file.hrcka01,
         hrcka02    LIKE   hrcka_file.hrcka02,
         hrcka03    LIKE   hrcka_file.hrcka03,
         hrcka04    LIKE   hrcka_file.hrcka04,
         hrcka05    LIKE   hrcka_file.hrcka05,
         hrcka06    LIKE   hrcka_file.hrcka06,
         hrcka07    LIKE   hrcka_file.hrcka07,
         hrcka08    LIKE   hrcka_file.hrcka08,
         hrcka09    LIKE   hrcka_file.hrcka09,
         hrcka10    LIKE   hrcka_file.hrcka10,
         hrcka11    LIKE   hrcka_file.hrcka11,
         hrcka12    LIKE   hrcka_file.hrcka12,
         hrcka13    LIKE   hrcka_file.hrcka13,
         hrcka14    LIKE   hrcka_file.hrcka14,
         hrcka15    LIKE   hrcka_file.hrcka15
               END RECORD,
       g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose  
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10    #總筆數 
DEFINE g_jump              LIKE type_file.num10    #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5     #是否開啟指定筆視窗  
DEFINE g_argv1             LIKE hrck_file.hrck01     #單號 
DEFINE g_argv2             STRING                  #指定執行的功能 #TQC-630074
DEFINE g_argv3             LIKE hrcka_file.hrcka11  
DEFINE l_table             STRING
DEFINE g_str               STRING
DEFINE g_buf               STRING
 
MAIN

#  IF FGL_GETENV("FGLGUI") <> "0" THEN      #若為整合EF自動簽核功能: 需抑制此段落 此處不適用
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
#  END IF
 
   IF (NOT cl_user()) THEN                #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                        #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
 
   IF (NOT cl_setup("GHR")) THEN          #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                        #判斷使用者執行程式權限
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)
 
   LET g_forupd_sql = "SELECT * FROM hrck_file WHERE hrck01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i066_cl CURSOR FROM g_forupd_sql                 #單頭Lock Cursor
 
      OPEN WINDOW i066_w WITH FORM "ghr/42f/ghri066"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
         CALL cl_set_locale_frm_name("ghri066")          #共用程式在 cl_ui_init前須做指定畫面名稱處理
         CALL cl_ui_init()                               #轉換介面語言別、匯入ToolBar、Action...等資訊
         CALL cl_set_label_justify("i066_w","right")      #画面栏位右对齐
 
   CALL i066_menu()                                   #進入主視窗選單
   CLOSE WINDOW i066_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
#QBE 查詢資料
FUNCTION i066_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_hrcka.clear()
  
      CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
      INITIALIZE g_hrck.* TO NULL    
      CONSTRUCT BY NAME g_wc ON hrck01,hrck02,hrck12,hrckacti,hrckuser,
                                hrckgrup,hrckmodu,hrckdate,hrckorig,hrckoriu
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON IDLE g_idle_seconds                         #每個交談指令必備以下四個功能
            CALL cl_on_idle()                           #idle、about、help、controlg
            CONTINUE CONSTRUCT
      
         ON ACTION about       
            CALL cl_about()   
      
         ON ACTION help         
            CALL cl_show_help() 
      
         ON ACTION controlg    
            CALL cl_cmdask()
      
         ON ACTION qbe_select                           #查詢提供條件選擇，選擇後直接帶入畫面
            CALL cl_qbe_list() RETURNING lc_qbe_sn      #提供列表選擇
            CALL cl_qbe_display_condition(lc_qbe_sn)    #顯示條件
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrckuser', 'hrckgrup')
      IF INT_FLAG THEN
         RETURN
      END IF
 
      CONSTRUCT g_wc2 ON hrcka01,hrcka02,hrcka03,hrcka04,hrcka05,hrcka06,
                         hrcka07,hrcka08,hrcka09,hrcka10,hrcka11,hrcka12,
                         hrcka13,hrcka14,hrcka15
              FROM s_hrcka[1].hrcka01,s_hrcka[1].hrcka02,s_hrcka[1].hrcka03,s_hrcka[1].hrcka04,
                   s_hrcka[1].hrcka05,s_hrcka[1].hrcka06,s_hrcka[1].hrcka07,s_hrcka[1].hrcka08,
                   s_hrcka[1].hrcka09,s_hrcka[1].hrcka10,s_hrcka[1].hrcka11,s_hrcka[1].hrcka12,
                   s_hrcka[1].hrcka13,s_hrcka[1].hrcka14,s_hrcka[1].hrcka15
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)    #再次顯示查詢條件，因為進入單身後會將原顯示值清空
   
         ON ACTION CONTROLP
            CASE
            WHEN INFIELD(hrcka03)     
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form =""   
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrcka03
              NEXT FIELD hrcka03

            WHEN INFIELD(hrcka06)     
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form =""   
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrcka06
              NEXT FIELD hrcka03
 
            WHEN INFIELD(hrcka09)     
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form =""  
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrcka09
              NEXT FIELD hrcka09
              
            WHEN INFIELD(hrcka11) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form =""
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrcka11
              NEXT FIELD hrcka11
              
            WHEN INFIELD(hrcka12) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form =""
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrcka12
              NEXT FIELD hrcka12
            
            WHEN INFIELD(hrcka14) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form =""
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrcka14
              NEXT FIELD hrcka14
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
    
         ON ACTION qbe_save                       #條件儲存
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
 
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  hrck01 FROM hrck_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY hrck01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE hrck01,hrcka02 ",
                  "  FROM hrck_file, hrcka_file ",
                  " WHERE hrck01 = hrcka01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY hrck01,hrcka02"
   END IF
 
   PREPARE i066_prepare FROM g_sql
   DECLARE i066_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i066_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM hrck_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT hrck01) FROM hrck_file,hrcka_file WHERE ",
                "hrcka01=hrck01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i066_precount FROM g_sql
   DECLARE i066_count CURSOR FOR i066_precount
 
END FUNCTION
 
FUNCTION i066_menu()
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i066_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i066_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i066_q()
            END IF
 
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i066_u()
            END IF
 
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i066_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i066_copy()
            END IF
            	
         WHEN "void2"
            IF cl_chk_act_auth() THEN
               CALL i066_x()
            END IF
 
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcka),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i066_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcka TO s_hrcka.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i066_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i066_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION jump
         CALL i066_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL i066_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION last
         CALL i066_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
       
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
         
      ON ACTION void2
         LET g_action_choice="void2"
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                         #利用單身驅動menu時，cancel代表右上角的"X"
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION exporttoexcel                       #匯出Excel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i066_bp_refresh()
  DISPLAY ARRAY g_hrcka TO s_hrcka.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i066_a()
   DEFINE li_result   LIKE type_file.num5  
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_hrcka.clear()
   LET g_wc = NULL #MOD-530329
   LET g_wc2= NULL #MOD-530329
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrck.* LIKE hrck_file.*             #DEFAULT 設定
   LET g_hrck01_t = NULL
 
 
   #預設值及將數值類變數清成零
   LET g_hrck_t.* = g_hrck.*
   LET g_hrck_o.* = g_hrck.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrck.hrckuser=g_user
      LET g_hrck.hrckoriu = g_user #FUN-980030
      LET g_hrck.hrckorig = g_grup #FUN-980030
      LET g_hrck.hrckgrup=g_grup
      LET g_hrck.hrckdate=g_today
      LET g_hrck.hrckacti='Y'              #資料有效
 
      CALL i066_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrck.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_hrck.hrck01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
 
      INSERT INTO hrck_file VALUES (g_hrck.*)
 
      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","hrck_file",g_hrck.hrck01,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                    #新增成功後，若有設定流程通知
      END IF                                            #此功能適用單據程式
 
      SELECT hrck01 INTO g_hrck.hrck01 FROM hrck_file WHERE hrck01 = g_hrck.hrck01

      LET g_hrck01_t = g_hrck.hrck01                       #保留舊值
      LET g_hrck_t.* = g_hrck.*
      LET g_hrck_o.* = g_hrck.*
      CALL g_hrcka.clear()
 
      LET g_rec_b = 0  
      CALL i066_b()                                     #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i066_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrck.hrck01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_hrck.* FROM hrck_file
    WHERE hrck01=g_hrck.hrck01
 
   IF g_hrck.hrckacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrck.hrck01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrck01_t = g_hrck.hrck01
   BEGIN WORK
 
   OPEN i066_cl USING g_hrck.hrck01
   IF STATUS THEN
      CALL cl_err("OPEN i066_cl:", STATUS, 1)
      CLOSE i066_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i066_cl INTO g_hrck.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrck.hrck01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i066_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i066_show()
 
   WHILE TRUE
      LET g_hrck01_t = g_hrck.hrck01
      LET g_hrck_o.* = g_hrck.*
      LET g_hrck.hrckmodu=g_user
      LET g_hrck.hrckdate=g_today
 
      CALL i066_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrck.*=g_hrck_t.*
         CALL i066_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      UPDATE hrck_file SET hrck_file.* = g_hrck.*
       WHERE hrck01 = g_hrck.hrck01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrck_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i066_cl
   COMMIT WORK
 
   CALL i066_b_fill("1=1")
   CALL i066_bp_refresh()
 
END FUNCTION
 

FUNCTION i066_i(p_cmd)

   DEFINE l_pmc05     LIKE pmc_file.pmc05
   DEFINE l_pmc30     LIKE pmc_file.pmc30
   DEFINE l_n         LIKE type_file.num5    
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改  
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_hrck.hrckuser,g_hrck.hrckmodu,g_hrck.hrckgrup,g_hrck.hrckdate,g_hrck.hrckacti
 
   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_hrck.hrck01,g_hrck.hrck02,g_hrck.hrck12
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i066_set_entry(p_cmd)
         CALL i066_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("hrck01")
 
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
 
FUNCTION i066_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrcka.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i066_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrck.* TO NULL
      RETURN
   END IF
 
   OPEN i066_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrck.* TO NULL
   ELSE
      OPEN i066_count
      FETCH i066_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i066_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i066_fetch(p_flag)

   DEFINE p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i066_cs INTO g_hrck.hrck01
      WHEN 'P' FETCH PREVIOUS i066_cs INTO g_hrck.hrck01
      WHEN 'F' FETCH FIRST    i066_cs INTO g_hrck.hrck01
      WHEN 'L' FETCH LAST     i066_cs INTO g_hrck.hrck01
      WHEN '/'
            IF (NOT g_no_ask) THEN      #No.FUN-6A0067
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0
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
            FETCH ABSOLUTE g_jump i066_cs INTO g_hrck.hrck01
            LET g_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrck.hrck01,SQLCA.sqlcode,0)
      INITIALIZE g_hrck.* TO NULL               #No.FUN-6A0162
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
      DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
 
   SELECT * INTO g_hrck.* FROM hrck_file WHERE hrck01 = g_hrck.hrck01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrck_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_hrck.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_hrck.hrckuser      #FUN-4C0056 add
   LET g_data_group = g_hrck.hrckgrup      #FUN-4C0056 add
 
   CALL i066_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i066_show()
 
   LET g_hrck_t.* = g_hrck.*                #保存單頭舊值
   LET g_hrck_o.* = g_hrck.*                #保存單頭舊值
   DISPLAY BY NAME g_hrck.hrckoriu,g_hrck.hrckorig, g_hrck.hrck01,g_hrck.hrck02,g_hrck.hrck12,                #FUN-650191
                   g_hrck.hrckuser,g_hrck.hrckgrup,g_hrck.hrckmodu,
                   g_hrck.hrckdate,g_hrck.hrckacti
 
   CALL i066_b_fill(g_wc2)                 #單身
 
END FUNCTION
 
#單身
FUNCTION i066_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_n1            LIKE type_file.num5,        
    l_n2            LIKE type_file.num5,        
    l_n3            LIKE type_file.num5,         
    l_cnt           LIKE type_file.num5,                #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_misc          LIKE gef_file.gef01,               
    l_allow_insert  LIKE type_file.num5,                #可新增否  
    l_allow_delete  LIKE type_file.num5  
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
DEFINE l_case    STRING                  #FUN-C20068 add
DEFINE l_case1   STRING                  #FUN-C20068 add
DEFINE l_hrau05  LIKE hrau_file.hrau05
DEFINE l_hrau07  LIKE hrau_file.hrau07
DEFINE ls_str    LIKE type_file.chr1000
DEFINE li_inx    LIKE type_file.chr1000

    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_hrck.hrck01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_hrck.* FROM hrck_file
     WHERE hrck01=g_hrck.hrck01
 
    IF g_hrck.hrckacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_hrck.hrck01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT hrcka01,hrcka02,hrcka03,hrcka04,hrcka05,hrcka06,",
                       "       hrcka07,hrcka08,hrcka09,hrcka10,hrcka11,hrcka12,",
                       "       hrcka13,hrcka14,hrcka15 ",         
                       "  FROM hrcka_file",
                       "  WHERE hrcka01=? AND hrcka02=?  ORDER BY hrcka02 FOR UPDATE "  #No.FUN-670099         #TQC-760046
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i066_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_hrcka WITHOUT DEFAULTS FROM s_hrcka.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=FALSE,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i066_cl USING g_hrck.hrck01
           IF STATUS THEN
              CALL cl_err("OPEN i066_cl:", STATUS, 1)
              CLOSE i066_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i066_cl INTO g_hrck.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrck.hrck01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i066_cl
              ROLLBACK WORK
              RETURN
           END IF

           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_hrcka_t.* = g_hrcka[l_ac].*  #BACKUP
              LET g_hrcka_o.* = g_hrcka[l_ac].*  #BACKUP
              OPEN i066_bcl USING g_hrck.hrck01,g_hrcka_t.hrcka02
              IF STATUS THEN
                 CALL cl_err("OPEN i066_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i066_bcl INTO g_hrcka[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_hrcka_t.hrcka02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
           END IF  
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrcka[l_ac].* TO NULL      #900423
           LET g_hrcka[l_ac].hrcka01 = g_hrck.hrck01
           DISPLAY BY NAME g_hrcka[l_ac].hrcka01
           LET g_hrcka_t.* = g_hrcka[l_ac].*         #新輸入資料
           LET g_hrcka_o.* = g_hrcka[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()         #FUN-550037(smin)
           NEXT FIELD hrcka02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
            #130624
           IF cl_null(g_hrcka[l_ac].hrcka03) AND cl_null(g_hrcka[l_ac].hrcka06) AND(g_hrcka[l_ac].hrcka09)
              AND cl_null(g_hrcka[l_ac].hrcka12)  THEN
              CALL cl_err('主要栏位不可为空','!',0)
              NEXT FIELD hrcka03
           END IF
           INSERT INTO hrcka_file(hrcka01,hrcka02,hrcka03,hrcka04,hrcka05,hrcka06,
                                  hrcka07,hrcka08,hrcka09,hrcka10,hrcka11,hrcka12,
                                  hrcka13,hrcka14,hrcka15)
           VALUES(g_hrck.hrck01,g_hrcka[l_ac].hrcka02,
                  g_hrcka[l_ac].hrcka03,g_hrcka[l_ac].hrcka04,
                  g_hrcka[l_ac].hrcka05,g_hrcka[l_ac].hrcka06,
                  g_hrcka[l_ac].hrcka07,g_hrcka[l_ac].hrcka08,
                  g_hrcka[l_ac].hrcka09,g_hrcka[l_ac].hrcka10,
                  g_hrcka[l_ac].hrcka11,g_hrcka[l_ac].hrcka12,
                  g_hrcka[l_ac].hrcka13,g_hrcka[l_ac].hrcka14,
                  g_hrcka[l_ac].hrcka15)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","hrcka_file",g_hrck.hrck01,g_hrcka[l_ac].hrcka02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD hrcka02                        #default 序號
           IF g_hrcka[l_ac].hrcka02 IS NULL OR g_hrcka[l_ac].hrcka02 = 0 THEN
              LET g_hrcka[l_ac].hrcka01 = g_hrck.hrck01
              DISPLAY BY NAME g_hrcka[l_ac].hrcka01
              SELECT max(hrcka02)+1
                INTO g_hrcka[l_ac].hrcka02
                FROM hrcka_file
               WHERE hrcka01 = g_hrck.hrck01
              IF g_hrcka[l_ac].hrcka02 IS NULL THEN
                 LET g_hrcka[l_ac].hrcka02 = 1
              END IF
           END IF
 
        AFTER FIELD hrcka02                        #check 序號是否重複
           IF NOT cl_null(g_hrcka[l_ac].hrcka02) THEN
              IF g_hrcka[l_ac].hrcka02 != g_hrcka_t.hrcka02
                 OR g_hrcka_t.hrcka02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM hrcka_file
                  WHERE hrcka01 = g_hrck.hrck01
                    AND hrcka02 = g_hrcka[l_ac].hrcka02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_hrcka[l_ac].hrcka02 = g_hrcka_t.hrcka02
                    NEXT FIELD hrcka02
                 END IF
              END IF
           END IF
 
       AFTER FIELD hrcka04
         IF NOT cl_null(g_hrcka[l_ac].hrcka04) AND
                  g_hrcka[l_ac].hrcka04 != '<=' AND
                  g_hrcka[l_ac].hrcka04 != '>=' AND  
         	  g_hrcka[l_ac].hrcka04 NOT MATCHES '[<>=]' THEN
         	  CALL cl_err('输入过滤字符不能识别，请重新输入','!',0)
         	  LET g_hrcka[l_ac].hrcka04 = NULL
         	  DISPLAY BY NAME g_hrcka[l_ac].hrcka04
         	  NEXT FIELD hrcka04
          END IF
          	
        AFTER FIELD hrcka07
         IF NOT cl_null(g_hrcka[l_ac].hrcka07) AND
                  g_hrcka[l_ac].hrcka07 != '<=' AND
                  g_hrcka[l_ac].hrcka07 != '>=' AND  
         	        g_hrcka[l_ac].hrcka07 NOT MATCHES '[<>=]' THEN
         	  CALL cl_err('输入过滤字符不能识别，请重新输入','!',0)
         	  LET g_hrcka[l_ac].hrcka07 = NULL
         	  DISPLAY BY NAME g_hrcka[l_ac].hrcka07
         	  NEXT FIELD hrcka07
          END IF
         	  
         AFTER FIELD hrcka10
         IF NOT cl_null(g_hrcka[l_ac].hrcka10) AND
                  g_hrcka[l_ac].hrcka10 != '<=' AND
                  g_hrcka[l_ac].hrcka10 != '>=' AND  
         	        g_hrcka[l_ac].hrcka10 NOT MATCHES '[<>=]' THEN
         	  CALL cl_err('输入过滤字符不能识别，请重新输入','!',0)
         	  LET g_hrcka[l_ac].hrcka10 = NULL
         	  DISPLAY BY NAME g_hrcka[l_ac].hrcka10
         	  NEXT FIELD hrcka10
          END IF
          	
         AFTER FIELD hrcka13
         IF NOT cl_null(g_hrcka[l_ac].hrcka13) AND
                  g_hrcka[l_ac].hrcka13 != '<=' AND
                  g_hrcka[l_ac].hrcka13 != '>=' AND  
         	  g_hrcka[l_ac].hrcka13 NOT MATCHES '[<>=]' THEN
         	  CALL cl_err('输入过滤字符不能识别，请重新输入','!',0)
         	  LET g_hrcka[l_ac].hrcka13 = NULL
         	  DISPLAY BY NAME g_hrcka[l_ac].hrcka13
         	  NEXT FIELD hrcka13
          END IF
      #   BEFORE DELETE                      #是否取消單身
      #     DISPLAY "BEFORE DELETE"
      #     IF g_hrcka_t.hrcka02 > 0 AND g_hrcka_t.hrcka02 IS NOT NULL THEN
      #        IF NOT cl_delb(0,0) THEN
      #           CANCEL DELETE
      #        END IF
      #        IF l_lock_sw = "Y" THEN
      #           CALL cl_err("", -263, 1)
      #           CANCEL DELETE
      #        END IF
      #        DELETE FROM hrcka_file
      #         WHERE hrcka01 = g_hrck.hrck01
      #           AND hrcka02 = g_hrcka_t.hrcka02
      #        IF SQLCA.sqlcode THEN
      #           CALL cl_err3("del","hrcka_file",g_hrck.hrck01,g_hrcka_t.hrcka02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
      #           ROLLBACK WORK
      #           CANCEL DELETE
      #        END IF
      #        LET g_rec_b=g_rec_b-1
      #        DISPLAY g_rec_b TO FORMONLY.cn2
      #     END IF
      #     COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrcka[l_ac].* = g_hrcka_t.*
              CLOSE i066_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           #130624
           #IF cl_null(g_hrcka[l_ac].hrcka03) AND cl_null(g_hrcka[l_ac].hrcka06) AND(g_hrcka[l_ac].hrcka09)
           #   AND cl_null(g_hrcka[l_ac].hrcka12)  THEN
           IF g_hrcka[l_ac].hrcka03 is null AND g_hrcka[l_ac].hrcka06 is null AND g_hrcka[l_ac].hrcka09 is null AND g_hrcka[l_ac].hrcka12 is null THEN
              CALL cl_err('主要栏位不可为空','!',0)
              NEXT FIELD hrcka03
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrcka[l_ac].hrcka02,-263,1)
              LET g_hrcka[l_ac].* = g_hrcka_t.*
           ELSE
              UPDATE hrcka_file SET hrcka02=g_hrcka[l_ac].hrcka02,
                                  hrcka03=g_hrcka[l_ac].hrcka03,
                                  hrcka04=g_hrcka[l_ac].hrcka04,
                                  hrcka05=g_hrcka[l_ac].hrcka05,
                                  hrcka06=g_hrcka[l_ac].hrcka06,
                                  hrcka07=g_hrcka[l_ac].hrcka07,
                                  hrcka08=g_hrcka[l_ac].hrcka08,
                                  hrcka09=g_hrcka[l_ac].hrcka09,
                                  hrcka10=g_hrcka[l_ac].hrcka10,  #No.FUN-670099
                                  hrcka11=g_hrcka[l_ac].hrcka11,
                                  hrcka12=g_hrcka[l_ac].hrcka12,
                                  hrcka13=g_hrcka[l_ac].hrcka13,
                                  hrcka14=g_hrcka[l_ac].hrcka14,
                                  hrcka15=g_hrcka[l_ac].hrcka15
               WHERE hrcka01=g_hrck.hrck01
                 AND hrcka02=g_hrcka_t.hrcka02
                 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","hrcka_file",g_hrck.hrck01,g_hrcka_t.hrcka02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_hrcka[l_ac].* = g_hrcka_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_hrcka[l_ac].* = g_hrcka_t.*
              END IF
              CLOSE i066_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i066_bcl
           COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
            WHEN INFIELD(hrcka03) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrau02"
               #LET g_qryparam.default1 = 'hrat_file' 
               LET g_qryparam.where  = "hrau01 = 'hrat_file' and gaq02 = '",g_lang,"'" 
               CALL cl_create_qry() RETURNING g_hrcka[l_ac].hrcka03
               DISPLAY BY NAME g_hrcka[l_ac].hrcka03
               NEXT FIELD hrcka03
 
            WHEN INFIELD(hrcka06) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrau02"
               LET g_qryparam.where  = "hrau01 = 'hrat_file' and gaq02 = '",g_lang,"'"
               CALL cl_create_qry() RETURNING g_hrcka[l_ac].hrcka06
               DISPLAY BY NAME g_hrcka[l_ac].hrcka06
               NEXT FIELD hrcka06
 
            WHEN INFIELD(hrcka09)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrau02"
               LET g_qryparam.where  = "hrau01 = 'hrat_file' and gaq02 = '",g_lang,"'"
               CALL cl_create_qry() RETURNING g_hrcka[l_ac].hrcka09
               DISPLAY BY NAME g_hrcka[l_ac].hrcka09
               NEXT FIELD hrcka09
               
             WHEN INFIELD(hrcka12) 
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gaq"
               LET g_qryparam.form ="q_hrau02"
               LET g_qryparam.where  = "hrau01 = 'hrat_file' and gaq02 = '",g_lang,"'"
               CALL cl_create_qry() RETURNING g_hrcka[l_ac].hrcka12
               DISPLAY BY NAME g_hrcka[l_ac].hrcka12
               NEXT FIELD hrcka12
             WHEN INFIELD(hrcka11)  
               LET l_hrau05 = ''
               LET l_hrau07 = ''
               SELECT hrau05,hrau07 INTO l_hrau05,l_hrau07 FROM hrau_file
                WHERE hrau01 = 'hrat_file'
                  AND hrau02 = g_hrcka[l_ac].hrcka09
               CALL cl_init_qry_var()
               LET g_qryparam.form =l_hrau05
               IF l_hrau07 IS NOT NULL THEN
                 LET g_qryparam.arg1 = l_hrau07
               END IF
               LET g_qryparam.default1 = g_hrcka[l_ac].hrcka11
               CALL cl_create_qry() RETURNING g_hrcka[l_ac].hrcka11
               DISPLAY BY NAME g_hrcka[l_ac].hrcka11
               NEXT FIELD hrcka11
             WHEN INFIELD(hrcka14)  
               LET l_hrau05 = ''
               LET l_hrau07 = ''
               SELECT hrau05,hrau07 INTO l_hrau05,l_hrau07 FROM hrau_file
                WHERE hrau01 = 'hrat_file'
                  AND hrau02 = g_hrcka[l_ac].hrcka12
               CALL cl_init_qry_var()
               LET g_qryparam.form =l_hrau05
               IF l_hrau07 IS NOT NULL THEN
                 LET g_qryparam.arg1 = l_hrau07
               END IF
               LET g_qryparam.default1 = g_hrcka[l_ac].hrcka14
               CALL cl_create_qry() RETURNING g_hrcka[l_ac].hrcka14
               DISPLAY g_hrcka[l_ac].hrcka14
               NEXT FIELD hrcka14   
                 
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_hrck.hrckmodu = g_user
    LET g_hrck.hrckdate = g_today
    UPDATE hrck_file SET hrckmodu = g_hrck.hrckmodu,hrckdate = g_hrck.hrckdate
     WHERE hrck01 = g_hrck.hrck01
    DISPLAY BY NAME g_hrck.hrckmodu,g_hrck.hrckdate
 
    CLOSE i066_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i066_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT hrcka01,hrcka02,hrcka03,hrcka04,hrcka05,hrcka06,hrcka07,hrcka08,hrcka09,",
               "       hrcka10,hrcka11,hrcka12,hrcka13,hrcka14,hrcka15 ",
               " FROM  hrcka_file ",
               " WHERE hrcka01 ='",g_hrck.hrck01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY hrcka01,hrcka02 "
   DISPLAY g_sql
 
   PREPARE i066_pb FROM g_sql
   DECLARE hrcka_cs CURSOR FOR i066_pb
 
   CALL g_hrcka.clear()
   LET g_cnt = 1
 
   FOREACH hrcka_cs INTO g_hrcka[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_hrcka.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i066_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("hrck01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i066_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("hrck01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i066_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF INFIELD(hrcka08) THEN
       CALL cl_set_comp_entry("hrcka081,hrcka082,hrcka06,hrcka06t",TRUE)    #No.FUN-550019
    END IF
    CALL cl_set_comp_entry("hrcka06,hrcka06t",TRUE)    #No.FUN-610018
 
END FUNCTION
 
FUNCTION i066_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
    IF INFIELD(hrcka08) THEN
       IF g_hrcka[l_ac].hrcka08[1,4] <> 'MISC' THEN
          CALL cl_set_comp_entry("hrcka081,hrcka082",FALSE)
       END IF
    END IF
 
 
END FUNCTION
	
FUNCTION i066_copy()
DEFINE
    l_newno         LIKE hrck_file.hrck01,
    l_newdate       LIKE hrck_file.hrck02,
    l_newde         LIKE hrck_file.hrck12,
    l_oldno         LIKE hrck_file.hrck01,
    li_result       LIKE type_file.num5   #No.FUN-550060  #No.FUN-680136 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_hrck.hrck01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    BEGIN WORK
     LET l_newno   = NULL              
     LET l_newde   = NULL
     LET l_newdate = NULL              
     LET g_before_input_done = FALSE   
     LET g_before_input_done = TRUE    
 
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT l_newno FROM hrck01
 
        BEFORE INPUT
            CALL cl_set_docno_format("hrck01")      #No.FUN-550060
 
        AFTER FIELD hrck01
 
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
       ROLLBACK WORK         #No.FUN-550060
       DISPLAY BY NAME g_hrck.hrck01
       RETURN
    END IF
 
    #單頭
    DROP TABLE y
    SELECT * FROM hrck_file
        WHERE hrck01=g_hrck.hrck01
        INTO TEMP y
 
    #單身
    DROP TABLE x
    SELECT * FROM hrcka_file
     WHERE hrcka01=g_hrck.hrck01
      INTO TEMP x
 
    LET g_success = 'Y'
 
    #==>單頭複製
    UPDATE y SET hrck01=l_newno,    #新的鍵值
                 hrck02=l_newdate,  #新的鍵值
                 hrckuser=g_user,   #資料所有者
                 hrckgrup=g_grup,   #資料所有者所屬群
                 hrckmodu=NULL,     #資料修改日期
                 hrckdate=g_today,  #資料建立日期
                 hrckacti='Y'       #有效資料
    INSERT INTO hrck_file SELECT * FROM y
 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","hrck_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
        LET g_success = 'N'
        ROLLBACK WORK
        RETURN
     END IF
 
    IF g_success = 'Y' THEN
        #==>單身複製
        UPDATE x SET hrcka01=l_newno
        INSERT INTO hrcka_file SELECT * FROM x
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","hrcka_file","","",SQLCA.sqlcode,"","INSERT INTO hrcka_file",1)  #No.FUN-660129
            LET g_success = 'N'
        ELSE
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
        END IF
    END IF
 
    IF g_success = 'Y' THEN
        COMMIT WORK
        LET l_oldno = g_hrck.hrck01
        SELECT hrck_file.* INTO g_hrck.* FROM hrck_file WHERE hrck01 = l_newno
        CALL i066_u()
        CALL i066_b()
    ELSE
        ROLLBACK WORK
    END IF
 
    SELECT hrck_file.* INTO g_hrck.* FROM hrck_file WHERE hrck01 = l_oldno
 
    CALL i066_show()
 
END FUNCTION
	
FUNCTION i066_x()
   DEFINE  l_flag       LIKE type_file.num5      #FUN-810038
   DEFINE  l_cnt        LIKE type_file.num5      #MOD-8B0059
   DEFINE l_ebocode     VARCHAR(1)               #FUN-880085
 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_hrck.* FROM hrck_file WHERE hrck01 = g_hrck.hrck01
   IF g_hrck.hrck01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   BEGIN WORK

   LET g_success='Y'
   OPEN i066_cl USING g_hrck.hrck01
   IF STATUS THEN
      CALL cl_err("OPEN i066_cl:", STATUS, 1)
      CLOSE i066_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i066_cl INTO g_hrck.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrck.hrck01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE i066_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_hrck.hrckacti = 'N' THEN
   	  LET g_hrck.hrckacti = 'Y' 
   	 ELSE
   	 	LET g_hrck.hrckacti = 'N'
   END IF
      UPDATE hrck_file SET hrckacti = g_hrck.hrckacti,
                           hrckmodu = g_user,
                           hrckdate = g_today
       WHERE hrck01 = g_hrck.hrck01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrck_file",g_hrck.hrck01,"",STATUS,"","upd hrckconf:",1) #No.FUN-660129
         LET g_success='N'
      END IF
   CLOSE i066_cl
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_hrck.hrck01,'V')
   ELSE
      ROLLBACK WORK
   END IF
   CALL i066_show()    #MOD-A60162
END FUNCTION

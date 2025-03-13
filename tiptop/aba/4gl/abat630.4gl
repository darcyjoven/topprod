# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: abat630.4gl
# Descriptions...: 交接單維護作業
# Date & Author..: No:DEV-CB0015 12/10/15 By TSD.sophy 
# Modify.........: No:DEV-CC0001 12/12/07 By Mandy "條碼產生"控卡:在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
# Modify.........: No.DEV-D30025 13/03/12 By Nina---GP5.3 追版:以上為GP5.25 的單號---
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/barcode.global"
 
#模組變數(Module Variables)
DEFINE g_ibf               RECORD LIKE ibf_file.*,     
       g_ibf_t             RECORD LIKE ibf_file.*,    
       g_ibf_o             RECORD LIKE ibf_file.*,   
       g_t1                LIKE oay_file.oayslip,    
       g_ibg               DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
          ibg02            LIKE ibg_file.ibg02,          #項次
          ibg04            LIKE ibg_file.ibg04,          #條碼編號
          ibg05            LIKE ibg_file.ibg05,          #數量
          ibgud01          LIKE ibg_file.ibgud01,        #自訂欄位
          ibgud02          LIKE ibg_file.ibgud02,        #自訂欄位
          ibgud03          LIKE ibg_file.ibgud03,        #自訂欄位
          ibgud04          LIKE ibg_file.ibgud04,        #自訂欄位
          ibgud05          LIKE ibg_file.ibgud05,        #自訂欄位
          ibgud06          LIKE ibg_file.ibgud06,        #自訂欄位
          ibgud07          LIKE ibg_file.ibgud07,        #自訂欄位
          ibgud08          LIKE ibg_file.ibgud08,        #自訂欄位
          ibgud09          LIKE ibg_file.ibgud09,        #自訂欄位
          ibgud10          LIKE ibg_file.ibgud10,        #自訂欄位
          ibgud11          LIKE ibg_file.ibgud11,        #自訂欄位
          ibgud12          LIKE ibg_file.ibgud12,        #自訂欄位
          ibgud13          LIKE ibg_file.ibgud13,        #自訂欄位
          ibgud14          LIKE ibg_file.ibgud14,        #自訂欄位
          ibgud15          LIKE ibg_file.ibgud15         #自訂欄位
                           END RECORD,
       g_ibg_t             RECORD                        #程式變數 (舊值)
          ibg02            LIKE ibg_file.ibg02,          #項次
          ibg04            LIKE ibg_file.ibg04,          #條碼編號
          ibg05            LIKE ibg_file.ibg05,          #數量
          ibgud01          LIKE ibg_file.ibgud01,        #自訂欄位
          ibgud02          LIKE ibg_file.ibgud02,        #自訂欄位
          ibgud03          LIKE ibg_file.ibgud03,        #自訂欄位
          ibgud04          LIKE ibg_file.ibgud04,        #自訂欄位
          ibgud05          LIKE ibg_file.ibgud05,        #自訂欄位
          ibgud06          LIKE ibg_file.ibgud06,        #自訂欄位
          ibgud07          LIKE ibg_file.ibgud07,        #自訂欄位
          ibgud08          LIKE ibg_file.ibgud08,        #自訂欄位
          ibgud09          LIKE ibg_file.ibgud09,        #自訂欄位
          ibgud10          LIKE ibg_file.ibgud10,        #自訂欄位
          ibgud11          LIKE ibg_file.ibgud11,        #自訂欄位
          ibgud12          LIKE ibg_file.ibgud12,        #自訂欄位
          ibgud13          LIKE ibg_file.ibgud13,        #自訂欄位
          ibgud14          LIKE ibg_file.ibgud14,        #自訂欄位
          ibgud15          LIKE ibg_file.ibgud15         #自訂欄位
                           END RECORD,
       g_ibg_o             RECORD                        #程式變數 (舊值)
          ibg02            LIKE ibg_file.ibg02,          #項次
          ibg04            LIKE ibg_file.ibg04,          #條碼編號
          ibg05            LIKE ibg_file.ibg05,          #數量
          ibgud01          LIKE ibg_file.ibgud01,        #自訂欄位
          ibgud02          LIKE ibg_file.ibgud02,        #自訂欄位
          ibgud03          LIKE ibg_file.ibgud03,        #自訂欄位
          ibgud04          LIKE ibg_file.ibgud04,        #自訂欄位
          ibgud05          LIKE ibg_file.ibgud05,        #自訂欄位
          ibgud06          LIKE ibg_file.ibgud06,        #自訂欄位
          ibgud07          LIKE ibg_file.ibgud07,        #自訂欄位
          ibgud08          LIKE ibg_file.ibgud08,        #自訂欄位
          ibgud09          LIKE ibg_file.ibgud09,        #自訂欄位
          ibgud10          LIKE ibg_file.ibgud10,        #自訂欄位
          ibgud11          LIKE ibg_file.ibgud11,        #自訂欄位
          ibgud12          LIKE ibg_file.ibgud12,        #自訂欄位
          ibgud13          LIKE ibg_file.ibgud13,        #自訂欄位
          ibgud14          LIKE ibg_file.ibgud14,        #自訂欄位
          ibgud15          LIKE ibg_file.ibgud15         #自訂欄位
                           END RECORD  
DEFINE g_sql               STRING,                       #CURSOR暫存 TQC-5B0183
       g_wc                STRING,                       #單頭CONSTRUCT結果
       g_wc2               STRING,                       #單身CONSTRUCT結果
       g_rec_b             LIKE type_file.num5,          #單身筆數  #No.FUN-680136 
       l_ac                LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 
DEFINE g_gec07             LIKE gec_file.gec07    
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
DEFINE g_buf               STRING
DEFINE g_ibh               RECORD LIKE ibh_file.*
DEFINE g_ibi               RECORD LIKE ibi_file.*

MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN               #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                       #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log    #遇錯則記錄log檔
 
   IF (NOT cl_setup("ABA")) THEN         #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                       #判斷使用者執行程式權限
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)
 
   LET g_forupd_sql = "SELECT * FROM ibf_file WHERE ibf01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE t630_cl CURSOR FROM g_forupd_sql                 #單頭Lock Cursor
 
   OPEN WINDOW t630_w WITH FORM "aba/42f/abat630"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()          
 
   CALL t630_menu()                                   #進入主視窗選單
   CLOSE WINDOW t630_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
#QBE 查詢資料
FUNCTION t630_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_ibg.clear()
  
   CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
   INITIALIZE g_ibf.* TO NULL    
   CONSTRUCT BY NAME g_wc ON ibf01,ibf04,ibf02,ibf03,
                             ibf05,ibf06,ibf07,ibf08,
                             ibfuser,ibfgrup,ibforiu,ibforig,
                             ibfmodu,ibfdate,ibfacti,
                             ibfud01,ibfud02,ibfud03,ibfud04,ibfud05,
                             ibfud06,ibfud07,ibfud08,ibfud09,ibfud10,
                             ibfud11,ibfud12,ibfud13,ibfud14,ibfud15 
                                
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ibf01) #交接單號   
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_ibf"  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibf01
               NEXT FIELD ibf01
            WHEN INFIELD(ibf07) #料號  
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_ima"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibf07
               NEXT FIELD ibf07
            WHEN INFIELD(ibf05) #工單號 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibf05
               NEXT FIELD ibf05
            WHEN INFIELD(ibf06) #訂單號   
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_oea03"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibf06
               NEXT FIELD ibf06   
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
   
      ON ACTION qbe_select        
         CALL cl_qbe_list() RETURNING lc_qbe_sn   
         CALL cl_qbe_display_condition(lc_qbe_sn)  
 
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN
   END IF
   
   CONSTRUCT g_wc2 ON ibg02,ibg04,ibg05,
                      ibgud01,ibgud02,ibgud03,ibgud04,ibgud05,
                      ibgud06,ibgud07,ibgud08,ibgud09,ibgud10,
                      ibgud11,ibgud12,ibgud13,ibgud14,ibgud15 
                 FROM s_ibg[1].ibg02,s_ibg[1].ibg04,s_ibg[1].ibg05,
                      s_ibg[1].ibgud01,s_ibg[1].ibgud02,s_ibg[1].ibgud03,
                      s_ibg[1].ibgud04,s_ibg[1].ibgud05,s_ibg[1].ibgud06,
                      s_ibg[1].ibgud07,s_ibg[1].ibgud08,s_ibg[1].ibgud09,
                      s_ibg[1].ibgud10,s_ibg[1].ibgud11,s_ibg[1].ibgud12,
                      s_ibg[1].ibgud13,s_ibg[1].ibgud14,s_ibg[1].ibgud15
                      
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)   

      ON ACTION CONTROLP
         CASE 
            WHEN INFIELD(ibg04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form = "q_ibb02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ibg04
               NEXT FIELD ibg04
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
   
      ON ACTION qbe_save  
         CALL cl_qbe_save()
 
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN
   END IF
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT ibf01 FROM ibf_file ",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY ibf01"
   ELSE                                    # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE ibf01 ",
                  "  FROM ibf_file,ibg_file ",
                  " WHERE ibf01 = ibg01",
                  "   AND ",g_wc CLIPPED, 
                  "   AND ",g_wc2 CLIPPED,
                  " ORDER BY ibf01"
   END IF
 
   PREPARE t630_prepare FROM g_sql
   DECLARE t630_cs SCROLL CURSOR WITH HOLD FOR t630_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql = "SELECT COUNT(*) FROM ibf_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql = "SELECT COUNT(DISTINCT ibf01) ",
                  "  FROM ibf_file,ibg_file ",
                  " WHERE ibg01 = ibf01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE t630_precount FROM g_sql
   DECLARE t630_count CURSOR FOR t630_precount
END FUNCTION
 
FUNCTION t630_menu()
   WHILE TRUE
      CALL t630_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t630_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t630_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t630_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t630_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t630_x()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t630_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "gen_barcode"   #條碼產生
            IF cl_chk_act_auth() THEN
               CALL t630_gen_barcode()
            END IF

         WHEN "qry_barcode"   #條碼查詢
            IF cl_chk_act_auth() THEN
               CALL t630_qry_barcode()
            END IF
          
         WHEN "out_barcode"   #條碼列印
            IF cl_chk_act_auth() THEN
               CALL t630_out_barcode()
            END IF
           
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"       
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_ibg),'','')
            END IF

         WHEN "related_document"                    #相關文件
            IF cl_chk_act_auth() THEN
               IF g_ibf.ibf01 IS NOT NULL THEN
               LET g_doc.column1 = "ibf01"
               LET g_doc.value1 = g_ibf.ibf01
               CALL cl_doc()
            END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t630_bp(p_ud)
DEFINE p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ibg TO s_ibg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
 
      ON ACTION insert
         LET g_action_choice = "insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice = "query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice = "delete"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice = "modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t630_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   
 
      ON ACTION previous
         CALL t630_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t630_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION next
         CALL t630_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION last
         CALL t630_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION invalid
         LET g_action_choice = "invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice = "reproduce"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice = "detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION gen_barcode   #條碼產生
         LET g_action_choice = "gen_barcode"
         EXIT DISPLAY

      ON ACTION qry_barcode   #條碼查詢
         LET g_action_choice = "qry_barcode"
         EXIT DISPLAY
          
      ON ACTION out_barcode   #條碼列印
         LET g_action_choice = "out_barcode"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice = "help"
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice = "controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice = "detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG = FALSE           
         LET g_action_choice = "exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel    
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
 
      ON ACTION related_document    
         LET g_action_choice = "related_document"          
         EXIT DISPLAY
        
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()      
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION controls     
         CALL cl_set_head_visible("","AUTO")      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t630_bp_refresh()
   
   DISPLAY ARRAY g_ibg TO s_ibg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
       
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   END DISPLAY
 
END FUNCTION
 
FUNCTION t630_a()
DEFINE li_result    LIKE type_file.num5
 
   CALL cl_msg("")
   CLEAR FORM
   CALL g_ibg.clear()
   LET g_wc = NULL 
   LET g_wc2 = NULL 
 
   IF s_shut(0) THEN RETURN END IF
 
   INITIALIZE g_ibf.* LIKE ibf_file.*             #DEFAULT 設定
   INITIALIZE g_ibh.* TO NULL 
   
   #預設值及將數值類變數清成零
   LET g_ibf_t.* = g_ibf.*
   LET g_ibf_o.* = g_ibf.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_ibf.ibfuser = g_user
      LET g_ibf.ibfgrup = g_grup
      LET g_ibf.ibfdate = g_today
      LET g_ibf.ibforiu = g_user 
      LET g_ibf.ibforig = g_grup 
      LET g_ibf.ibfplant = g_plant
      LET g_ibf.ibflegal = g_legal
      LET g_ibf.ibfacti = 'Y' 
      LET g_ibf.ibf02 = 'Y'
      LET g_ibf.ibf01 = g_ibd.ibd06
      LET g_ibf.ibf04 = g_today   
      LET g_ibf.ibf08 = 0   
      
      CALL t630_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_ibf.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_ibf.ibf01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
       
      CALL s_auto_assign_no("aba",g_ibf.ibf01,g_ibf.ibf04,"2","ibf_file","ibf01","","","")
         RETURNING li_result,g_ibf.ibf01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_ibf.ibf01
 
      INSERT INTO ibf_file VALUES (g_ibf.*)
 
      IF SQLCA.sqlcode THEN     
         CALL cl_err3("ins","ibf_file",g_ibf.ibf01,"",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK           
         CALL cl_flow_notify(g_ibf.ibf01,'I') 
      END IF                                  
 
      LET g_ibh.ibh01 = g_ibf.ibf01
      LET g_ibh.ibh02 = g_ibf.ibf02
      INSERT INTO ibh_file VALUES (g_ibh.*)
      
      LET g_ibf_t.* = g_ibf.*
      LET g_ibf_o.* = g_ibf.*
      CALL g_ibg.clear()
 
      LET g_rec_b = 0  
      CALL t630_b()                                     #輸入單身
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t630_u()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ibf.ibf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   INITIALIZE g_ibh.* TO NULL 
   
   SELECT * INTO g_ibf.* FROM ibf_file
    WHERE ibf01 = g_ibf.ibf01
 
   IF g_ibf.ibfacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_ibf.ibf01,'mfg1000',0)
      RETURN
   END IF
 
   CALL cl_msg("")
   CALL cl_opmsg('u')

   BEGIN WORK
 
   OPEN t630_cl USING g_ibf.ibf01
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_ibf.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ibf.ibf01,SQLCA.sqlcode,0)    # 資料被他人LOCK
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t630_show()
 
   WHILE TRUE
      LET g_ibf_o.* = g_ibf.*
      LET g_ibf.ibfmodu = g_user
      LET g_ibf.ibfdate = g_today
 
      CALL t630_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ibf.* = g_ibf_t.*
         CALL t630_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
  
      UPDATE ibf_file SET ibf_file.* = g_ibf.*
       WHERE ibf01 = g_ibf.ibf01
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","ibf_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      
      LET g_ibh.ibh01 = g_ibf.ibf01
      LET g_ibh.ibh02 = g_ibf.ibf02
      UPDATE ibh_file SET ibh_file.* = g_ibh.*
       WHERE ibh01 = g_ibf.ibf01
         
      EXIT WHILE
   END WHILE
 
   CLOSE t630_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ibf.ibf01,'U')
 
   CALL t630_b_fill("1=1")
   CALL t630_bp_refresh()
END FUNCTION
 

FUNCTION t630_i(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改  
DEFINE l_cnt       LIKE type_file.num5    
DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN RETURN END IF
 
   DISPLAY BY NAME g_ibf.ibf01,g_ibf.ibf02,g_ibf.ibf03,g_ibf.ibf04, 
                   g_ibf.ibf05,g_ibf.ibf06,g_ibf.ibf07,g_ibf.ibf08,
                   g_ibf.ibfuser,g_ibf.ibfgrup,g_ibf.ibforiu,g_ibf.ibforig,
                   g_ibf.ibfmodu,g_ibf.ibfdate,g_ibf.ibfacti,
                   g_ibf.ibfud01,g_ibf.ibfud02,g_ibf.ibfud03,g_ibf.ibfud04,g_ibf.ibfud05,
                   g_ibf.ibfud06,g_ibf.ibfud07,g_ibf.ibfud08,g_ibf.ibfud09,g_ibf.ibfud10,
                   g_ibf.ibfud11,g_ibf.ibfud12,g_ibf.ibfud13,g_ibf.ibfud14,g_ibf.ibfud15 

   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_ibf.ibf01,g_ibf.ibf04,g_ibf.ibf02,g_ibf.ibf03,  
                 g_ibf.ibf05,g_ibf.ibf06,g_ibf.ibf07,g_ibf.ibf08,
                 g_ibf.ibfud01,g_ibf.ibfud02,g_ibf.ibfud03,g_ibf.ibfud04,g_ibf.ibfud05,
                 g_ibf.ibfud06,g_ibf.ibfud07,g_ibf.ibfud08,g_ibf.ibfud09,g_ibf.ibfud10,
                 g_ibf.ibfud11,g_ibf.ibfud12,g_ibf.ibfud13,g_ibf.ibfud14,g_ibf.ibfud15 
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t630_set_entry(p_cmd)
         CALL t630_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ibf01")
 
      AFTER FIELD ibf01
         IF NOT cl_null(g_ibf.ibf01) THEN
            IF cl_null(g_ibf_t.ibf01) OR g_ibf_t.ibf01 <> g_ibf.ibf01 THEN 
               #暫時mark ===(S)
               #IF g_ibf.ibf01 != g_ibd.ibd06 OR g_ibd.ibd06 IS NULL THEN 
               #   CALL cl_err(g_ibf.ibf01,'csf-041',0)
               #   NEXT FIELD ibf01
               #END IF 
               #暫時mark ===(E)
               LET g_t1 = s_get_doc_no(g_ibf.ibf01)
               CALL s_check_no("aba",g_ibf.ibf01,g_ibf_t.ibf01,"2","ibf_file","ibf01","")
                 RETURNING li_result,g_ibf.ibf01
               DISPLAY BY NAME g_ibf.ibf01
               IF (NOT li_result) THEN
                  NEXT FIELD ibf01
               END IF
             
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM ibf_file
                WHERE ibf01 = g_ibf.ibf01
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  CALL cl_err('','-239',0)
                  NEXT FIELD ibf01
               END IF
            END IF 
         END IF
         
      AFTER FIELD ibf07
         IF NOT cl_null(g_ibf.ibf07) THEN
            CALL t630_ibf07_chk(g_ibf.ibf07,p_cmd) 
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0) 
               NEXT FIELD ibf07
            END IF 
         END IF        
         
      BEFORE FIELD ibf05
         CALL t630_set_entry(p_cmd)
        
      AFTER FIELD ibf05 
         IF NOT cl_null(g_ibf.ibf05) THEN
            CALL t630_ibf05_chk(g_ibf.ibf05,p_cmd) 
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0) 
               NEXT FIELD ibf05
            END IF 
         END IF        
         CALL t630_set_no_entry(p_cmd)
         
      AFTER FIELD ibf06 
         IF NOT cl_null(g_ibf.ibf06) THEN
            CALL t630_ibf06_chk(g_ibf.ibf06,p_cmd) 
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0) 
               NEXT FIELD ibf06
            END IF 
         END IF 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(ibf01) #單據編號                
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ibe"
                 LET g_qryparam.arg1 = "2"
                 LET g_qryparam.default1 = g_ibf.ibf01
                 CALL cl_create_qry() RETURNING g_ibf.ibf01
                 DISPLAY BY NAME g_ibf.ibf01
                 NEXT FIELD ibf01
            WHEN INFIELD(ibf07) #參考料號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_ima"
                 LET g_qryparam.default1 = g_ibf.ibf07
                 CALL cl_create_qry() RETURNING g_ibf.ibf07
                 DISPLAY BY NAME g_ibf.ibf07
                 NEXT FIELD ibf07
            WHEN INFIELD(ibf05) #工單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfb"
                 LET g_qryparam.default1 = g_ibf.ibf05
                 CALL cl_create_qry() RETURNING g_ibf.ibf05
                 DISPLAY BY NAME g_ibf.ibf05
                 NEXT FIELD ibf05
            WHEN INFIELD(ibf06) #訂單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_oea03"
                 LET g_qryparam.default1 = g_ibf.ibf06
                 CALL cl_create_qry() RETURNING g_ibf.ibf06
                 DISPLAY BY NAME g_ibf.ibf06
                 NEXT FIELD ibf06
            OTHERWISE EXIT CASE
          END CASE
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
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
 
 
FUNCTION t630_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   
   CALL cl_msg("")
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_ibg.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL t630_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_ibf.* TO NULL
      RETURN
   END IF
 
   OPEN t630_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_ibf.* TO NULL
   ELSE
      OPEN t630_count
      FETCH t630_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL t630_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION t630_fetch(p_flag)
DEFINE p_flag LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t630_cs INTO g_ibf.ibf01
      WHEN 'P' FETCH PREVIOUS t630_cs INTO g_ibf.ibf01
      WHEN 'F' FETCH FIRST    t630_cs INTO g_ibf.ibf01
      WHEN 'L' FETCH LAST     t630_cs INTO g_ibf.ibf01
      WHEN '/'
         IF (NOT g_no_ask) THEN     
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about     
                  CALL cl_about()  
            
               ON ACTION help     
                  CALL cl_show_help() 
            
               ON ACTION controlg    
                  CALL cl_cmdask()  
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t630_cs INTO g_ibf.ibf01
         LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ibf.ibf01,SQLCA.sqlcode,0)
      INITIALIZE g_ibf.* TO NULL   
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
      DISPLAY g_curs_index TO FORMONLY.idx    
   END IF
 
   SELECT * INTO g_ibf.* FROM ibf_file WHERE ibf01 = g_ibf.ibf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ibf_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_ibf.* TO NULL
      RETURN
   END IF
 
   CALL t630_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t630_show()
 
   LET g_ibf_t.* = g_ibf.*                #保存單頭舊值
   LET g_ibf_o.* = g_ibf.*                #保存單頭舊值
   DISPLAY BY NAME g_ibf.ibf01,g_ibf.ibf02,g_ibf.ibf03,g_ibf.ibf04, 
                   g_ibf.ibf05,g_ibf.ibf06,g_ibf.ibf07,g_ibf.ibf08,
                   g_ibf.ibfuser,g_ibf.ibfgrup,g_ibf.ibforiu,g_ibf.ibforig,
                   g_ibf.ibfmodu,g_ibf.ibfdate,g_ibf.ibfacti,
                   g_ibf.ibfud01,g_ibf.ibfud02,g_ibf.ibfud03,g_ibf.ibfud04,g_ibf.ibfud05,
                   g_ibf.ibfud06,g_ibf.ibfud07,g_ibf.ibfud08,g_ibf.ibfud09,g_ibf.ibfud10,
                   g_ibf.ibfud11,g_ibf.ibfud12,g_ibf.ibfud13,g_ibf.ibfud14,g_ibf.ibfud15 
   
   CALL t630_ibf07_chk(g_ibf.ibf07,'d')                  
   CALL t630_b_fill(g_wc2)                 #單身
 
   CALL cl_show_fld_cont()    
END FUNCTION
 
FUNCTION t630_x()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ibf.ibf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t630_cl USING g_ibf.ibf01
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_ibf.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ibf.ibf01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t630_show()
 
   IF cl_exp(0,0,g_ibf.ibfacti) THEN                   #確認一下
      LET g_chr = g_ibf.ibfacti
      IF g_ibf.ibfacti = 'Y' THEN
         LET g_ibf.ibfacti = 'N'
      ELSE
         LET g_ibf.ibfacti = 'Y'
      END IF
 
      UPDATE ibf_file SET ibfacti = g_ibf.ibfacti,
                          ibfmodu = g_user,
                          ibfdate = g_today
       WHERE ibf01 = g_ibf.ibf01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ibf_file",g_ibf.ibf01,"",SQLCA.sqlcode,"","",1) 
         LET g_ibf.ibfacti = g_chr
      END IF
   END IF
 
   CLOSE t630_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_ibf.ibf01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT ibfacti,ibfmodu,ibfdate
     INTO g_ibf.ibfacti,g_ibf.ibfmodu,g_ibf.ibfdate 
     FROM ibf_file
    WHERE ibf01=g_ibf.ibf01
      
   DISPLAY BY NAME g_ibf.ibfacti,g_ibf.ibfmodu,g_ibf.ibfdate
END FUNCTION
 
FUNCTION t630_r()
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ibf.ibf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_ibf.* FROM ibf_file
    WHERE ibf01 = g_ibf.ibf01
      
   BEGIN WORK
 
   OPEN t630_cl USING g_ibf.ibf01
   IF STATUS THEN
      CALL cl_err("OPEN t630_cl:", STATUS, 1)
      CLOSE t630_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t630_cl INTO g_ibf.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ibf.ibf01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t630_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL      
      LET g_doc.column1 = "ibf01"    
      LET g_doc.value1 = g_ibf.ibf01
      CALL cl_del_doc()            
      
      DELETE FROM ibf_file WHERE ibf01 = g_ibf.ibf01
      DELETE FROM ibh_file WHERE ibh01 = g_ibf.ibf01
      DELETE FROM ibg_file WHERE ibg01 = g_ibf.ibf01
      DELETE FROM ibi_file WHERE ibi01 = g_ibf.ibf01
      DELETE FROM iba_file WHERE iba01 = 'E'||g_ibf.ibf01
      DELETE FROM ibb_file WHERE ibb01 = 'E'||g_ibf.ibf01
        
      CLEAR FORM
      CALL g_ibg.clear()
      OPEN t630_count
      IF STATUS THEN
         CLOSE t630_cs
         CLOSE t630_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t630_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t630_cs
         CLOSE t630_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t630_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t630_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE   
         CALL t630_fetch('/')
      END IF
   END IF
 
   CLOSE t630_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ibf.ibf01,'D')
END FUNCTION
 
#單身
FUNCTION t630_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
       l_n             LIKE type_file.num5,                #檢查重複用  
       l_cnt           LIKE type_file.num5,                #檢查重複用 
       l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
       p_cmd           LIKE type_file.chr1,                #處理狀態  
       l_allow_insert  LIKE type_file.num5,                #可新增否  
       l_allow_delete  LIKE type_file.num5                 #可刪除否  
DEFINE l_ibb           RECORD LIKE ibb_file.*
DEFINE l_sfb08         LIKE sfb_file.sfb08
DEFINE l_sum           LIKE sfb_file.sfb08
DEFINE l_sql           STRING 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    IF g_ibf.ibf01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_ibf.* FROM ibf_file
     WHERE ibf01 = g_ibf.ibf01
 
    IF g_ibf.ibfacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_ibf.ibf01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ibg02,ibg04,ibg05,",
                       "       ibgud01,ibgud02,ibgud03,ibgud04,ibgud05,",
                       "       ibgud06,ibgud07,ibgud08,ibgud09,ibgud10,",
                       "       ibgud11,ibgud12,ibgud13,ibgud14,ibgud15 ",
                       "  FROM ibg_file",
                       "  WHERE ibg01=? AND ibg02=? ",
                       "    FOR UPDATE "  
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t630_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_ibg WITHOUT DEFAULTS FROM s_ibg.*
       ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                 INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                 APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
       BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          BEGIN WORK
 
          OPEN t630_cl USING g_ibf.ibf01
          IF STATUS THEN
             CALL cl_err("OPEN t630_cl:", STATUS, 1)
             CLOSE t630_cl
             ROLLBACK WORK
             RETURN
          END IF
 
          FETCH t630_cl INTO g_ibf.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_ibf.ibf01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE t630_cl
             ROLLBACK WORK
             RETURN
          END IF
 
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_ibg_t.* = g_ibg[l_ac].*  
             LET g_ibg_o.* = g_ibg[l_ac].*  
             OPEN t630_bcl USING g_ibf.ibf01,g_ibg_t.ibg02
             IF STATUS THEN
                CALL cl_err("OPEN t630_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH t630_bcl INTO g_ibg[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ibg_t.ibg02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             CALL cl_show_fld_cont() 
             CALL t630_set_entry_b(p_cmd)  
             CALL t630_set_no_entry_b(p_cmd) 
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd = 'a'
          INITIALIZE g_ibg[l_ac].* TO NULL      #900423
          LET g_ibg[l_ac].ibg05 =  1            #Body default
          LET g_ibg_t.* = g_ibg[l_ac].*         #新輸入資料
          LET g_ibg_o.* = g_ibg[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     
          CALL t630_set_entry_b(p_cmd) 
          CALL t630_set_no_entry_b(p_cmd)
          NEXT FIELD ibg02
 
       BEFORE FIELD ibg02                        #default 序號
          IF g_ibg[l_ac].ibg02 IS NULL OR g_ibg[l_ac].ibg02 = 0 THEN
             SELECT MAX(ibg02)+1 INTO g_ibg[l_ac].ibg02
               FROM ibg_file
              WHERE ibg01 = g_ibf.ibf01
             IF g_ibg[l_ac].ibg02 IS NULL THEN
                LET g_ibg[l_ac].ibg02 = 1
             END IF
          END IF
 
       AFTER FIELD ibg02                        #check 序號是否重複
          IF NOT cl_null(g_ibg[l_ac].ibg02) THEN
             IF g_ibg[l_ac].ibg02 != g_ibg_t.ibg02
                OR g_ibg_t.ibg02 IS NULL THEN
                LET l_cnt = 0 
                SELECT COUNT(*) INTO l_cnt FROM ibg_file
                 WHERE ibg01 = g_ibf.ibf01
                   AND ibg02 = g_ibg[l_ac].ibg02
                IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF   
                IF l_cnt > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_ibg[l_ac].ibg02 = g_ibg_t.ibg02
                   NEXT FIELD ibg02
                END IF
             END IF
          END IF
          
       AFTER FIELD ibg04 
          IF NOT cl_null(g_ibg[l_ac].ibg04) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM ibb_file
              WHERE ibb01 = g_ibg[l_ac].ibg04
             IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
             IF l_cnt = 0 THEN 
                CALL cl_err(g_ibg[l_ac].ibg04,'aba-007',0)
                NEXT FIELD ibg04 
             END IF 
             
             INITIALIZE l_ibb.* TO NULL
             LET l_sql = "SELECT * FROM ibb_file WHERE ibb01 = ?"
             DECLARE t630_ibb_cs CURSOR FROM l_sql
             FOREACH t630_ibb_cs USING g_ibg[l_ac].ibg04 INTO l_ibb.*
                CASE l_ibb.ibb02
                   WHEN 'A'  #工單
                      IF l_ibb.ibb03 <> g_ibf.ibf05 AND NOT cl_null(g_ibf.ibf05) THEN 
                         CALL cl_err('','aba-116',0)
                         NEXT FIELD ibg04 
                      END IF 
                   WHEN 'H'  #訂單包裝
                      IF l_ibb.ibb03 <> g_ibf.ibf06 AND NOT cl_null(g_ibf.ibf06) THEN 
                         CALL cl_err('','aba-117',0)
                         NEXT FIELD ibg04 
                      END IF 
                   OTHERWISE 
                      CALL cl_err('','aba-120',0)
                      NEXT FIELD ibg04
                END CASE 
             END FOREACH     
          END IF 

       AFTER FIELD ibg05
          IF NOT cl_null(g_ibg[l_ac].ibg05) THEN 
             IF g_ibd.ibd05 = 'Y' THEN 
                INITIALIZE l_ibb.* TO NULL
                LET l_sql = "SELECT * FROM ibb_file WHERE ibb01 = ?"
                DECLARE t630_ibb_cs2 CURSOR FROM l_sql
                FOREACH t630_ibb_cs2 USING g_ibg[l_ac].ibg04 INTO l_ibb.*
                   IF l_ibb.ibb02 = 'A' THEN   #工單
                      #獲得所有該工單條碼的已掃描數量
                      LET l_sum = 0 
                      SELECT SUM(tlfb06*tlfb05) INTO l_sum FROM tlfb_file
                       WHERE tlfb07 = l_ibb.ibb03
                         AND tlfb01 = g_ibg[l_ac].ibg04
                         AND tlfb11 = 'abat022'
                      IF cl_null(l_sum) THEN LET l_sum = 0 END IF
                      #獲得該工單的生產數量
                      LET l_sfb08 = 0 
                      SELECT sfb08 INTO l_sfb08 FROM sfb_file
                       WHERE sfb01 = l_ibb.ibb03
                      IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF 
                      IF l_sum + g_ibg[l_ac].ibg05 > l_sfb08 THEN
                         CALL cl_err('','aba-030',0)
                         NEXT FIELD ibg05 
                      END IF
                   END IF 
                   #暫時mark ===(S)
                   #IF l_ibb.ibb02 = 'H' THEN   #訂單包裝
                   #   #獲得所有該訂單包裝條碼的已掃描數量
                   #   LET l_cnt = 0     
                   #   SELECT SUM(tlfb06*tlfb05) INTO l_sum FROM tlfb_file
                   #    WHERE tlfb07 = l_ibb.ibb03
                   #      AND tlfb01 = g_ibg[l_ac].ibg04
                   #      AND tlfb11 = 'abat022'
                   #   IF cl_null(l_sum) THEN LET l_sum = 0 END IF
                   #   IF l_sum + g_ibg[l_ac].ibg05 > 1 THEN
                   #      CALL cl_err('','aba-050',0)
                   #      NEXT FIELD ibg05 
                   #   END IF                                
                   #END IF 
                   #暫時mark ===(E)
                END FOREACH     
             END IF   
          END IF
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO ibg_file(ibg01,ibg02,ibg04,ibg05,
                               ibgud01,ibgud02,ibgud03,ibgud04,ibgud05,
                               ibgud06,ibgud07,ibgud08,ibgud09,ibgud10,
                               ibgud11,ibgud12,ibgud13,ibgud14,ibgud15,
                               ibgplant,ibglegal)
               VALUES(g_ibf.ibf01,g_ibg[l_ac].ibg02,g_ibg[l_ac].ibg04,g_ibg[l_ac].ibg05,
                      g_ibg[l_ac].ibgud01,g_ibg[l_ac].ibgud02,g_ibg[l_ac].ibgud03,
                      g_ibg[l_ac].ibgud04,g_ibg[l_ac].ibgud05,g_ibg[l_ac].ibgud06,
                      g_ibg[l_ac].ibgud07,g_ibg[l_ac].ibgud08,g_ibg[l_ac].ibgud09,
                      g_ibg[l_ac].ibgud10,g_ibg[l_ac].ibgud11,g_ibg[l_ac].ibgud12,
                      g_ibg[l_ac].ibgud13,g_ibg[l_ac].ibgud14,g_ibg[l_ac].ibgud15,
                      g_plant,g_legal)  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ibg_file",g_ibf.ibf01,g_ibg[l_ac].ibg02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
             CANCEL INSERT
          ELSE
             CALL cl_msg("INSERT OK")
             COMMIT WORK
             LET g_rec_b = g_rec_b + 1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
          CALL t630_upd_ibf()
          LET g_ibi.ibi01 = g_ibf.ibf01
          LET g_ibi.ibi02 = g_ibg[l_ac].ibg02
          LET g_ibi.ibi04 = g_ibg[l_ac].ibg04
          LET g_ibi.ibi05 = g_ibg[l_ac].ibg05
          LET g_ibi.ibi06 = 'N'
          INSERT INTO ibi_file VALUES (g_ibi.*)
 
       BEFORE DELETE                      #是否取消單身
          IF g_ibg_t.ibg02 > 0 AND g_ibg_t.ibg02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM ibg_file
              WHERE ibg01 = g_ibf.ibf01
                AND ibg02 = g_ibg_t.ibg02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","ibg_file",g_ibf.ibf01,g_ibg_t.ibg02,SQLCA.sqlcode,"","",1) 
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             
             DELETE FROM ibi_file
              WHERE ibi01 = g_ibf.ibf01
                AND ibi02 = g_ibg_t.ibg02
                
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
          COMMIT WORK
          CALL t630_upd_ibf()
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_ibg[l_ac].* = g_ibg_t.*
             CLOSE t630_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_ibg[l_ac].ibg02,-263,1)
             LET g_ibg[l_ac].* = g_ibg_t.*
          ELSE
             UPDATE ibg_file SET ibg02 = g_ibg[l_ac].ibg02,
                                 ibg04 = g_ibg[l_ac].ibg04,
                                 ibg05 = g_ibg[l_ac].ibg05,
                                 ibgud01 = g_ibg[l_ac].ibgud01,
                                 ibgud02 = g_ibg[l_ac].ibgud02,
                                 ibgud03 = g_ibg[l_ac].ibgud03,
                                 ibgud04 = g_ibg[l_ac].ibgud04,
                                 ibgud05 = g_ibg[l_ac].ibgud05, 
                                 ibgud06 = g_ibg[l_ac].ibgud06,
                                 ibgud07 = g_ibg[l_ac].ibgud07,
                                 ibgud08 = g_ibg[l_ac].ibgud08,  
                                 ibgud09 = g_ibg[l_ac].ibgud09, 
                                 ibgud10 = g_ibg[l_ac].ibgud10,
                                 ibgud11 = g_ibg[l_ac].ibgud11,
                                 ibgud12 = g_ibg[l_ac].ibgud12,
                                 ibgud13 = g_ibg[l_ac].ibgud13,
                                 ibgud14 = g_ibg[l_ac].ibgud14,
                                 ibgud15 = g_ibg[l_ac].ibgud15
              WHERE ibg01 = g_ibf.ibf01
                AND ibg02 = g_ibg_t.ibg02
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err3("upd","ibg_file",g_ibf.ibf01,g_ibg_t.ibg02,SQLCA.sqlcode,"","",1)
                LET g_ibg[l_ac].* = g_ibg_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
             CALL t630_upd_ibf()
             
             LET g_ibi.ibi01 = g_ibf.ibf01
             LET g_ibi.ibi02 = g_ibg[l_ac].ibg02
             LET g_ibi.ibi04 = g_ibg[l_ac].ibg04
             LET g_ibi.ibi05 = g_ibg[l_ac].ibg05
             LET g_ibi.ibi06 = 'N'
             UPDATE ibi_file SET ibi.* = g_ibi.*
              WHERE ibi01 = g_ibf.ibf01
                AND ibi02 = g_ibg_t.ibg02
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_ibg[l_ac].* = g_ibg_t.*
             END IF
             CLOSE t630_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          CLOSE t630_bcl
          COMMIT WORK
 
       ON ACTION CONTROLP
          CASE 
             WHEN INFIELD(ibg04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ibb02"
                LET g_qryparam.default1 = g_ibg[l_ac].ibg04
                CALL cl_create_qry() RETURNING g_ibg[l_ac].ibg04
                DISPLAY BY NAME g_ibg[l_ac].ibg04
                NEXT FIELD ibg04
          END CASE 
        
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(ibg02) AND l_ac > 1 THEN
             LET g_ibg[l_ac].* = g_ibg[l_ac-1].*
             LET g_ibg[l_ac].ibg02 = g_rec_b + 1
             NEXT FIELD ibg02
          END IF
 
       ON ACTION CONTROLZ
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
 
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
 
      ON ACTION controls    
         CALL cl_set_head_visible("","AUTO")  
   END INPUT
 
   LET g_ibf.ibfmodu = g_user
   LET g_ibf.ibfdate = g_today
   UPDATE ibf_file SET ibfmodu = g_ibf.ibfmodu,
                       ibfdate = g_ibf.ibfdate
    WHERE ibf01 = g_ibf.ibf01
      
   DISPLAY BY NAME g_ibf.ibfmodu,g_ibf.ibfdate
 
   CLOSE t630_bcl
   COMMIT WORK
   CALL t630_delall()
END FUNCTION
 
FUNCTION t630_delall()
 
   LET g_cnt = 0 
   SELECT COUNT(*) INTO g_cnt FROM ibg_file
    WHERE ibg01 = g_ibf.ibf01
   IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF  
   
   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM ibf_file WHERE ibf01 = g_ibf.ibf01
      DELETE FROM ibh_file WHERE ibh01 = g_ibh.ibh01      
   END IF
END FUNCTION
 
FUNCTION t630_b_fill(p_wc2)
DEFINE p_wc2   STRING
 
   IF cl_null(p_wc2) THEN LET p_wc2 = " 1=1" END IF 
   LET g_sql = "SELECT ibg02,ibg04,ibg05,",
               "       ibgud01,ibgud02,ibgud03,ibgud04,ibgud05,",
               "       ibgud06,ibgud07,ibgud08,ibgud09,ibgud10,",
               "       ibgud11,ibgud12,ibgud13,ibgud14,ibgud15 ",
               "  FROM ibg_file",  
               " WHERE ibg01 ='",g_ibf.ibf01,"' ",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY ibg02 "
 
   PREPARE t630_pb FROM g_sql
   DECLARE ibg_cs CURSOR FOR t630_pb
 
   CALL g_ibg.clear()
   LET g_cnt = 1
 
   FOREACH ibg_cs INTO g_ibg[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_ibg.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION

FUNCTION t630_set_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1  
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("ibf01",TRUE)
   END IF
    
   CALL cl_set_comp_entry("ibf06,ibf07",TRUE)
 
END FUNCTION
 
FUNCTION t630_set_no_entry(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1    
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ibf01",FALSE)
   END IF
 
   IF NOT cl_null(g_ibf.ibf05) THEN 
      CALL cl_set_comp_entry("ibf06,ibf07",FALSE)
   END IF 
END FUNCTION
 
FUNCTION t630_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   

 
END FUNCTION
 
FUNCTION t630_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
  CALL cl_set_comp_entry("ibg02",FALSE)
 
END FUNCTION

FUNCTION t630_ibf07_chk(p_ima01,p_cmd)
DEFINE p_ima01    LIKE ima_file.ima01
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti

   LET g_errno = ' '
   
   SELECT ima02,ima021,imaacti INTO l_ima02,l_ima021,l_imaacti
     FROM ima_file WHERE ima01 = p_ima01

   CASE 
      WHEN SQLCA.SQLCODE=100         LET g_errno = 'mfg3006'
      WHEN l_imaacti='N'             LET g_errno = '9028'
      WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      DISPLAY l_ima02 TO ima02
      DISPLAY l_ima021 TO ima021
   ELSE 
      DISPLAY ' ' TO ima02
      DISPLAY ' ' TO ima021
   END IF
END FUNCTION 


FUNCTION t630_ibf05_chk(p_sfb01,p_cmd)
DEFINE p_sfb01   LIKE sfb_file.sfb01
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_sfb01   LIKE sfb_file.sfb01,
       l_sfb87   LIKE sfb_file.sfb87,
       l_sfb22   LIKE sfb_file.sfb22,
       l_ima02   LIKE ima_file.ima02,
       l_ima021  LIKE ima_file.ima021,
       l_sfb05   LIKE sfb_file.sfb05

   LET g_errno = ' '
   
   SELECT sfb01,sfb87,sfb22,sfb05
     INTO l_sfb01,l_sfb87,l_sfb22,l_sfb05
     FROM sfb_file  
    WHERE sfb01 = p_sfb01

   CASE 
      WHEN SQLCA.SQLCODE=100  LET g_errno = '100'
                              LET l_sfb01 = NULL   LET l_sfb87 = NULL
                              LET l_sfb22 = NULL   LET l_sfb05 = NULL 
      WHEN l_sfb87='X'        LET g_errno = '9004'
      OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN 
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = l_sfb05
      LET g_ibf.ibf06 = l_sfb22
      LET g_ibf.ibf07 = l_sfb05
      DISPLAY BY NAME g_ibf.ibf06
      DISPLAY BY NAME g_ibf.ibf07
      DISPLAY l_ima02 TO ima02
      DISPLAY l_ima021 TO ima021
   END IF
END FUNCTION

FUNCTION t630_ibf06_chk(p_oea01,p_cmd)
DEFINE p_oea01   LIKE oea_file.oea01
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_oeaconf LIKE oea_file.oeaconf
    
   LET g_errno = ' '
   
   SELECT oeaconf INTO l_oeaconf
     FROM oea_file 
    WHERE oea01 = p_oea01

   CASE 
      WHEN SQLCA.SQLCODE=100  LET g_errno = '100'
      WHEN l_oeaconf='N'      LET g_errno = 'axm-445'
      OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION  

FUNCTION t630_gen_barcode()
DEFINE l_cnt         LIKE type_file.num5
DEFINE l_ibg05       LIKE ibg_file.ibg05
DEFINE l_iba         RECORD LIKE iba_file.*
DEFINE l_ibb         RECORD LIKE ibb_file.*
   
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ibf.ibf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   IF g_ibf.ibfacti = 'N' THEN    #檢查資料是否為無效
      CALL cl_err(g_ibf.ibf01,'mfg1000',0)
      RETURN
   END IF

   #DEV-CC0001 add----str---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM tlfb_file 
    WHERE tlfb01 IN (SELECT UNIQUE ibb01 FROM ibb_file 
                      WHERE ibb03 = g_ibf.ibf01)
   IF l_cnt >=1 THEN
      #在條碼掃瞄異動記錄檔(tlfb_file)已有異動的記錄,不可再重新產生條碼!
      CALL cl_err(g_ibf.ibf01,'aba-127',1)
      RETURN
   END IF
   #DEV-CC0001 add----end---

   LET l_ibg05 = 0 
   SELECT SUM(ibg05) INTO l_ibg05 FROM ibg_file
    WHERE ibg01 = g_ibf.ibf01
   IF cl_null(l_ibg05) THEN LET l_ibg05 = 0 END IF 
   IF l_ibg05 = 0 THEN 
      CALL cl_err('','aba-119',0) 
      RETURN 
   END IF 
   
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ibb_file
    WHERE ibb02 = 'J' 
      AND ibb03 = g_ibf.ibf01
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF 
   IF l_cnt > 0 THEN 
      IF NOT cl_confirm('sfb-995') THEN RETURN END IF
      DELETE FROM iba_file 
       WHERE EXISTS (SELECT ibb01 FROM ibb_file
                      WHERE ibb01 = iba01 
                        AND ibb02 = 'J'  
                        AND ibb03 = g_ibf.ibf01)       
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","iba_file",g_ibf.ibf01,'',SQLCA.sqlcode,"","",1)
         RETURN
      END IF
      DELETE FROM ibb_file WHERE ibb02 = 'J' AND ibb03 = g_ibf.ibf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","ibb_file",g_ibf.ibf01,'',SQLCA.sqlcode,"","",1)
         RETURN
      END IF
   END IF 
   
   INITIALIZE l_iba.* TO NULL 
   LET l_iba.iba01 = 'E',g_ibf.ibf01
   LET l_iba.iba02 = 'E' 
   LET l_iba.iba03 = g_ibf.ibf01
   INSERT INTO iba_file VALUES (l_iba.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","iba_file","","",SQLCA.sqlcode,"","",1)
      RETURN 
   END IF

   INITIALIZE l_ibb.* TO NULL
   LET l_ibb.ibb01 = l_iba.iba01
   LET l_ibb.ibb02 = 'J'
   LET l_ibb.ibb03 = g_ibf.ibf01
   LET l_ibb.ibb04 = 0 
   LET l_ibb.ibb05 = 0 
   LET l_ibb.ibb06 = g_ibf.ibf07
   LET l_ibb.ibb07 = g_ibf.ibf08
   LET l_ibb.ibb11 = 'Y'
   LET l_ibb.ibb12 = 0  
   LET l_ibb.ibbacti = 'Y'
   INSERT INTO ibb_file VALUES (l_ibb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("ins","ibb_file","","",SQLCA.sqlcode,"","",1)
      RETURN 
   END IF
END FUNCTION 

FUNCTION t630_qry_barcode()
DEFINE l_cmd        LIKE type_file.chr1000

   IF s_shut(0) THEN RETURN END IF
 
   IF g_ibf.ibf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   LET l_cmd = "abaq100 '",g_ibf.ibf01,"' "
   CALL cl_cmdrun_wait(l_cmd)   
END FUNCTION 
   
FUNCTION t630_out_barcode()
DEFINE l_cmd        LIKE type_file.chr1000
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ibf.ibf01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF

   CALL cl_wait()
   LET l_cmd = "abar300 '",g_ibf.ibf01,"'" 
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION t630_upd_ibf()
DEFINE l_ibg05      LIKE ibg_file.ibg05

   LET l_ibg05 = 0 
   SELECT SUM(ibg05) INTO l_ibg05 FROM ibg_file
    WHERE ibg01 = g_ibf.ibf01
   IF cl_null(l_ibg05) THEN LET l_ibg05 = 0 END IF 
   
   LET g_ibf.ibf08 = l_ibg05
   
   UPDATE ibf_file SET ibf08 = g_ibf.ibf08
    WHERE ibf01 = g_ibf.ibf01
  
   DISPLAY BY NAME g_ibf.ibf08 
END FUNCTION 
  
#DEV-CB0015--add
#DEV-D30025--add


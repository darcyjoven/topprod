# Prog. Version..: '5.25.04-11.09.15(00010)'     #
#
# Pattern name...: ghri053.4gl
# Descriptions...: 加班计划维护作业
# Date & Author..: 13/06/05 By mengyye
# Date & Author..: 140815 By cqz 修改单身查询Bug

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_hrcm          RECORD LIKE hrcm_file.*,
       g_hrcm_o        RECORD LIKE hrcm_file.*, 
       g_hrcm_t        RECORD LIKE hrcm_file.*,
       g_hrcm02_t      LIKE hrcm_file.hrcm02,
       g_hrcma         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
          hrcma01      LIKE hrcma_file.hrcma01,
          hrcma03      LIKE hrcma_file.hrcma03,     
          hrat02       LIKE hrat_file.hrat02,       
          hrat04       LIKE type_file.chr50,       
          hrat20       LIKE type_file.chr50,
          hrat25       LIKE hrat_file.hrat25, 
          hrcma04      LIKE hrcma_file.hrcma04,
          hrcma05      LIKE hrcma_file.hrcma05,
          hrcma06      LIKE hrcma_file.hrcma06,
          hrcma07      LIKE hrcma_file.hrcma07,
          hrcma08      LIKE hrcma_file.hrcma08,
          hrcma09      LIKE hrcma_file.hrcma09,
          hrbm04       LIKE hrbm_file.hrbm04,     #add by lijun130905
          hrcma10      LIKE hrcma_file.hrcma10,
          hrcma11      LIKE hrcma_file.hrcma11,
          hrcma12      LIKE hrcma_file.hrcma12,
          hrcma13      LIKE hrcma_file.hrcma13,
          hrcma14      LIKE hrcma_file.hrcma14,
          hrcma15      LIKE hrcma_file.hrcma15,
          hrcma16      LIKE hrcma_file.hrcma16
                      END RECORD,
       g_hrcma_t       RECORD                        #程式變數 (舊值)
          hrcma01      LIKE hrcma_file.hrcma01,
          hrcma03      LIKE hrcma_file.hrcma03,
          hrat02       LIKE hrat_file.hrat02,       
          hrat04       LIKE type_file.chr50,       
          hrat20       LIKE type_file.chr50,
          hrat25       LIKE hrat_file.hrat25, 
          hrcma04      LIKE hrcma_file.hrcma04,
          hrcma05      LIKE hrcma_file.hrcma05,
          hrcma06      LIKE hrcma_file.hrcma06,
          hrcma07      LIKE hrcma_file.hrcma07,
          hrcma08      LIKE hrcma_file.hrcma08,
          hrcma09      LIKE hrcma_file.hrcma09,
          hrbm04       LIKE hrbm_file.hrbm04,     #add by lijun130905
          hrcma10      LIKE hrcma_file.hrcma10,
          hrcma11      LIKE hrcma_file.hrcma11,
          hrcma12      LIKE hrcma_file.hrcma12,
          hrcma13      LIKE hrcma_file.hrcma13,
          hrcma14      LIKE hrcma_file.hrcma14,
          hrcma15      LIKE hrcma_file.hrcma15,
          hrcma16      LIKE hrcma_file.hrcma16
                     END RECORD,
       g_hrcma_o       RECORD                        #程式變數 (舊值)
          hrcma01      LIKE hrcma_file.hrcma01,
          hrcma03      LIKE hrcma_file.hrcma03,
          hrat02       LIKE hrat_file.hrat02,       
          hrat04       LIKE type_file.chr50,       
          hrat20       LIKE type_file.chr50,
          hrat25       LIKE hrat_file.hrat25, 
          hrcma04      LIKE hrcma_file.hrcma04,
          hrcma05      LIKE hrcma_file.hrcma05,
          hrcma06      LIKE hrcma_file.hrcma06,
          hrcma07      LIKE hrcma_file.hrcma07,
          hrcma08      LIKE hrcma_file.hrcma08,
          hrcma09      LIKE hrcma_file.hrcma09,
          hrbm04       LIKE hrbm_file.hrbm04,     #add by lijun130905
          hrcma10      LIKE hrcma_file.hrcma10,
          hrcma11      LIKE hrcma_file.hrcma11,
          hrcma12      LIKE hrcma_file.hrcma12,
          hrcma13      LIKE hrcma_file.hrcma13,
          hrcma14      LIKE hrcma_file.hrcma14,
          hrcma15      LIKE hrcma_file.hrcma15,
          hrcma16      LIKE hrcma_file.hrcma16
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       g_flag        LIKE type_file.chr1,
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 
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
DEFINE g_argv1             LIKE hrcm_file.hrcm01     #單號 
DEFINE g_argv2             STRING                  #指定執行的功能 #TQC-630074
DEFINE g_argv3             LIKE hrcma_file.hrcma11   
DEFINE l_table             STRING
DEFINE g_str               STRING  
DEFINE g_buf               STRING
 
MAIN
   DEFINE l_hratid LIKE hrat_file.hratid
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN                #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                        #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
 
   IF (NOT cl_setup("GHR")) THEN          #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                        #判斷使用者執行程式權限
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)
 
   LET g_forupd_sql = "SELECT * FROM hrcm_file WHERE hrcm02 = ? FOR UPDATE"
   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i053_cl CURSOR FROM g_forupd_sql                 #單頭Lock Cursor
 
      OPEN WINDOW i053_w WITH FORM "ghr/42f/ghri053"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_set_locale_frm_name("ghri053")          #共用程式在 cl_ui_init前須做指定畫面名稱處理
      CALL cl_ui_init()                               #轉換介面語言別、匯入ToolBar、Action...等資訊
 
   CALL i053_menu()                                   #進入主視窗選單
   CLOSE WINDOW i053_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
#QBE 查詢資料
FUNCTION i053_cs() 
 DEFINE l_wc            STRING
  
   CLEAR FORM 
   CALL g_hrcma.clear()
     CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
   INITIALIZE g_hrcm.* TO NULL    
   CONSTRUCT BY NAME g_wc ON hrcm01,hrcm02,hrcm03,hrcm04,hrcm05,hrcm06,hrcmconf,
                             hrcmuser,hrcmgrup,hrcmmodu,hrcmdate,hrcmacti,
                             hrcmoriu,hrcmorig    #TQC-B80232  add
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(hrcm02) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hrcm02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrcm02
               NEXT FIELD hrcm02
            WHEN INFIELD(hrcm01) 
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_hraa01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrcm01
               NEXT FIELD hrcm01
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
   
 
   END CONSTRUCT
   
   IF INT_FLAG THEN
      RETURN
   END IF
   LET g_wc = g_wc CLIPPED
 
   CONSTRUCT g_wc2 ON hrcma03,hrcma04,hrcma05,hrcma06,hrcma07,
                      hrcma08,hrcma09,hrcma10,hrcma11,hrcma12   
           FROM s_hrcma[1].hrcma03,s_hrcma[1].hrcma04,s_hrcma[1].hrcma05,s_hrcma[1].hrcma06,s_hrcma[1].hrcma07,
           s_hrcma[1].hrcma08,s_hrcma[1].hrcma09,s_hrcma[1].hrcma10,s_hrcma[1].hrcma11,s_hrcma[1].hrcma12
 
     
  BEFORE CONSTRUCT        
   
         ON ACTION CONTROLP
            CASE
             WHEN INFIELD(hrcma03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_hrat01"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO hrcma03
            WHEN INFIELD(hrcma09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrbm03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '008'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcma09
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
 #######################################
#    CALL cl_get_hrzxa(g_user) RETURNING l_wc #160818 add by zhangtn
#    LET g_wc2 = g_wc2 CLIPPED," AND ",l_wc CLIPPED #160818 add by zhangtn 
     
  IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT hrcm02 FROM hrcm_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY hrcm02"
   ELSE                              # 若單身有輸入條件
    	LET g_wc2 = cl_replace_str(g_wc2,"hrcma03","hrat01")
      LET g_sql = "SELECT UNIQUE hrcm_file. hrcm02 ", # modify by cqz 140815 hrcm01->hrcm02
                  "  FROM hrcm_file, hrcma_file,hrat_file ",
                  " WHERE hrcm02 = hrcma02 AND hratid=hrcma03",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY hrcm02"

   END IF
 
   PREPARE i053_prepare FROM g_sql
   DECLARE i053_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i053_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM hrcm_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT hrcm02) FROM hrcm_file,hrcma_file,hrat_file WHERE ",
                "hrcma02=hrcm02 AND hratid=hrcma03 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i053_precount FROM g_sql
   DECLARE i053_count CURSOR FOR i053_precount
 
END FUNCTION
 
FUNCTION i053_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
   DEFINE l_cmd  LIKE  type_file.chr1000
 
   WHILE TRUE
      CALL i053_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i053_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i053_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i053_r()
            END IF
         WHEN "import"
            IF cl_chk_act_auth() THEN
                 CALL i053_import()
            END IF
         WHEN "ghr_confirm"
            IF cl_chk_act_auth() THEN
               CALL i053_confirm('Y')
            END IF

         WHEN "ghr_undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i053_confirm('N')
            END IF 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i053_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i053_x()
            END IF
         
         WHEN "ghri053_3"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "ghri053_3" 
               CALL cl_cmdrun(l_cmd)
            END IF
         
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i053_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "ks"
#            IF cl_chk_act_auth() THEN
#               LET l_cmd = "ghri053_3" 
#               CALL cl_cmdrun(l_cmd)
#            END IF
         
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcma),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i053_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_hrcma TO s_hrcma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION ghr_confirm
         LET g_action_choice='ghr_confirm'
         EXIT DISPLAY 
      ON ACTION ghr_undo_confirm
         LET g_action_choice='ghr_undo_confirm'
         EXIT DISPLAY 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION ghri053_3
         LET g_action_choice="ghri053_3"
         EXIT DISPLAY
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
         
#      ON ACTION ks
#         LET g_action_choice="ks"
#         EXIT DISPLAY
         
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY  
          
      ON ACTION first
         CALL i053_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i053_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION jump
         CALL i053_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL i053_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION last
         CALL i053_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY

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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i053_bp_refresh()
  DISPLAY ARRAY g_hrcma TO s_hrcma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i053_a()
   DEFINE li_result   LIKE type_file.num5  
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
   DEFINE l_hratid    LIKE hrat_file.hratid 
   MESSAGE ""
   CLEAR FORM
   CALL g_hrcma.clear()
   LET g_wc = NULL #MOD-530329
   LET g_wc2= NULL #MOD-530329
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_hrcm.* LIKE hrcm_file.*             #DEFAULT 設定
   LET g_hrcm02_t = NULL
 
   #預設值及將數值類變數清成零
   LET g_hrcm_t.* = g_hrcm.*
   LET g_hrcm_o.* = g_hrcm.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_hrcm.hrcmuser=g_user
      LET g_hrcm.hrcmoriu = g_user #FUN-980030
      LET g_hrcm.hrcmorig = g_grup #FUN-980030
      LET g_hrcm.hrcmgrup=g_grup
      LET g_hrcm.hrcmdate=g_today
      LET g_hrcm.hrcmacti='Y'              #資料有效
      LET g_hrcm.hrcmconf='N'
      #LET g_hrcm.hrcm05='N'
      LET g_hrcm.hrcm05 = 'Y'   #modify by lijun130905 
      LET g_flag = 'Y'
#      CALL hr_gen_no('hrcm_file','hrcm02','019',g_hrcm.hrcm02,'') RETURNING g_hrcm.hrcm02,g_flag
#      IF g_flag='Y' THEN
#         CALL cl_set_comp_entry("hrcm02",TRUE)
#      ELSE
#         CALL cl_set_comp_entry("hrcm02",FALSE)
#      END IF
#      DISPLAY BY NAME g_hrcm.hrcm02 
      LET g_hrcm.hrcm01 = '1000'    
  CALL i053_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_hrcm.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_hrcm.hrcm02) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK

      INSERT INTO hrcm_file VALUES (g_hrcm.*)
 
      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         ROLLBACK WORK     
         CALL cl_err3("ins","hrcm_file",g_hrcm.hrcm02,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                    #新增成功後，若有設定流程通知
         CALL cl_flow_notify(g_hrcm.hrcm02,'I')           #則增加訊息到udm7主畫面上或使用者信箱
      END IF                                            #此功能適用單據程式
 
      SELECT hrcm02 INTO g_hrcm.hrcm02 FROM hrcm_file WHERE hrcm02 = g_hrcm.hrcm02

      LET g_hrcm02_t = g_hrcm.hrcm02                       #保留舊值
      LET g_hrcm_t.* = g_hrcm.*
      LET g_hrcm_o.* = g_hrcm.*
      CALL g_hrcma.clear()
 
      LET g_rec_b = 0  
      CALL i053_b()                                     #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i053_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrcm.hrcm02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_hrcm.hrcmconf = 'Y' THEN
      CALL cl_err('',1208,0)
      RETURN
   END IF 
   SELECT * INTO g_hrcm.* FROM hrcm_file
    WHERE hrcm02=g_hrcm.hrcm02
 
   IF g_hrcm.hrcmacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_hrcm.hrcm02,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_hrcm02_t = g_hrcm.hrcm02
   BEGIN WORK
 
   OPEN i053_cl USING g_hrcm.hrcm02
   IF STATUS THEN
      CALL cl_err("OPEN i053_cl:", STATUS, 1)
      CLOSE i053_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i053_cl INTO g_hrcm.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_hrcm.hrcm02,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i053_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i053_show()
 
   WHILE TRUE
      LET g_hrcm02_t = g_hrcm.hrcm02
      LET g_hrcm_o.* = g_hrcm.*
      LET g_hrcm.hrcmmodu=g_user
      LET g_hrcm.hrcmdate=g_today
 
      CALL i053_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_hrcm.*=g_hrcm_t.*
         CALL i053_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_hrcm.hrcm02 != g_hrcm02_t THEN            # 更改單號
         UPDATE hrcma_file SET hrcma02 = g_hrcm.hrcm02
          WHERE hrcma02 = g_hrcm02_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","hrcma_file",g_hrcm02_t,"",SQLCA.sqlcode,"","hrcma",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE hrcm_file SET hrcm_file.* = g_hrcm.*
       WHERE hrcm02 = g_hrcm.hrcm02
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","hrcm_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i053_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrcm.hrcm02,'U')
 
   CALL i053_b_fill("1=1")
   CALL i053_bp_refresh()
 
END FUNCTION
 

FUNCTION i053_i(p_cmd)

   DEFINE l_count         LIKE type_file.num5    
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改  
   DEFINE li_result   LIKE type_file.num5,    
          l_hrcm01_desc  LIKE hraa_file.hraa02
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_hrcm.hrcm01,g_hrcm.hrcmuser,g_hrcm.hrcmmodu,g_hrcm.hrcmgrup,g_hrcm.hrcmdate,g_hrcm.hrcmacti,g_hrcm.hrcmconf
  select hraa02 into l_hrcm01_desc from hraa_file where hraa01 = g_hrcm.hrcm01
  display l_hrcm01_desc to hrcm01_desc 
   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_hrcm.hrcm01,g_hrcm.hrcm02,g_hrcm.hrcm03,
                 g_hrcm.hrcm04,g_hrcm.hrcm05,g_hrcm.hrcm06
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i053_set_entry(p_cmd)
         CALL i053_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE

      AFTER FIELD hrcm01
         IF NOT cl_null(g_hrcm.hrcm01) THEN 
            SELECT COUNT(*) INTO l_count FROM hraa_file WHERE hraa01=g_hrcm.hrcm01 AND hraaacti = 'Y'
            IF cl_null(l_count) OR l_count = 0 THEN 
               CALL cl_err(g_hrcm.hrcm01,'ghr-001',0) 
               NEXT FIELD hrcm01 
            END IF
            #add by lijun130905------begin-----add hr_gen_no()
          #  IF p_cmd='a' THEN 
          #   CALL hr_gen_no('hrcm_file','hrcm02','019',g_hrcm.hrcm01,'') RETURNING g_hrcm.hrcm02,g_flag
          #   IF g_flag='Y' THEN
          #     CALL cl_set_comp_entry("hrcm02",TRUE)
          #   ELSE
           #     CALL cl_set_comp_entry("hrcm02",FALSE)
           #  END IF
           # END IF 
            DISPLAY BY NAME g_hrcm.hrcm02
            #add by lijun130905------end-----add hr_gen_no()
            SELECT hraa02 INTO l_hrcm01_desc FROM hraa_file WHERE hraa01 = g_hrcm.hrcm01 AND hraaacti = 'Y'
            DISPLAY l_hrcm01_desc TO hrcm01_desc
          END IF

#add by lijun130905-----begin------          
      BEFORE FIELD hrcm02
        # IF cl_null(g_hrcm.hrcm02) AND NOT cl_null(g_hrcm.hrcm01)THEN
        #    CALL hr_gen_no('hrcm_file','hrcm02','019',g_hrcm.hrcm01,'') RETURNING g_hrcm.hrcm02,g_flag
        #    IF g_flag='Y' THEN
               CALL cl_set_comp_entry("hrcm02",TRUE)
        #    ELSE
        #       CALL cl_set_comp_entry("hrcm02",FALSE)
        #    END IF
        #    DISPLAY BY NAME g_hrcm.hrcm02     
        # END IF
#add by lijun130905-----end------
         
      AFTER FIELD hrcm02
         IF NOT cl_null(g_hrcm.hrcm02) THEN
            SELECT count(*) INTO l_count FROM hrcm_file WHERE hrcm02 = g_hrcm.hrcm02
            IF cl_null(l_count) THEN LET l_count = 0  END IF
            IF l_count >0 THEN
               CALL cl_err(g_hrcm.hrcm02,'-1100',0)
               NEXT FIELD hrcm02
            END IF
         END IF
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION controlp
         CASE
           WHEN INFIELD(hrcm01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hraa01"
              LET g_qryparam.default1 = g_hrcm.hrcm01
              CALL cl_create_qry() RETURNING g_hrcm.hrcm01
              DISPLAY BY NAME g_hrcm.hrcm01
              NEXT FIELD hrcm01
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
 FUNCTION i053_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_hrcma.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i053_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_hrcm.* TO NULL
      RETURN
   END IF
 
   OPEN i053_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_hrcm.* TO NULL
   ELSE
      OPEN i053_count
      FETCH i053_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i053_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i053_fetch(p_flag)

   DEFINE p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i053_cs INTO g_hrcm.hrcm02
      WHEN 'P' FETCH PREVIOUS i053_cs INTO g_hrcm.hrcm02
      WHEN 'F' FETCH FIRST    i053_cs INTO g_hrcm.hrcm02
      WHEN 'L' FETCH LAST     i053_cs INTO g_hrcm.hrcm02
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
            FETCH ABSOLUTE g_jump i053_cs INTO g_hrcm.hrcm02
            LET g_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcm.hrcm01,SQLCA.sqlcode,0)
      INITIALIZE g_hrcm.* TO NULL               #No.FUN-6A0162
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
 
   SELECT * INTO g_hrcm.* FROM hrcm_file WHERE hrcm02 = g_hrcm.hrcm02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","hrcm_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_hrcm.* TO NULL
      RETURN
   END IF
 
   CALL i053_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i053_show()
   DEFINE l_hraa02  LIKE hraa_file.hraa02
   LET g_hrcm_t.* = g_hrcm.*                #保存單頭舊值
   LET g_hrcm_o.* = g_hrcm.*                #保存單頭舊值
  DISPLAY BY NAME g_hrcm.hrcm01,g_hrcm.hrcm02,g_hrcm.hrcm03,
                   g_hrcm.hrcm04,g_hrcm.hrcm05,g_hrcm.hrcm06,
                   g_hrcm.hrcmoriu,g_hrcm.hrcmorig,
                   g_hrcm.hrcmuser,g_hrcm.hrcmgrup,g_hrcm.hrcmmodu,
                   g_hrcm.hrcmdate,g_hrcm.hrcmacti,g_hrcm.hrcmconf
   SELECT hraa02 INTO l_hraa02 FROM hraa_file WHERE hraa01 = g_hrcm.hrcm01  AND hraaacti ='Y' 
   DISPLAY l_hraa02 TO hrcm01_desc
   CALL i053_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 ########################################   
 
FUNCTION i053_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrcm.hrcm02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i053_cl USING g_hrcm.hrcm02
   IF STATUS THEN
      CALL cl_err("OPEN i053_cl:", STATUS, 1)
      CLOSE i053_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i053_cl INTO g_hrcm.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcm.hrcm02,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i053_show()
 
   IF cl_exp(0,0,g_hrcm.hrcmacti) THEN                   #確認一下
      LET g_chr=g_hrcm.hrcmacti
      IF g_hrcm.hrcmacti='Y' THEN
         LET g_hrcm.hrcmacti='N'
      ELSE
         LET g_hrcm.hrcmacti='Y'
      END IF
 
      UPDATE hrcm_file SET hrcmacti=g_hrcm.hrcmacti,
                          hrcmmodu=g_user,
                          hrcmdate=g_today
       WHERE hrcm01=g_hrcm.hrcm02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","hrcm_file",g_hrcm.hrcm02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_hrcm.hrcmacti=g_chr
         UPDATE hrcma_file SET hrcma14 = g_hrcm.hrcmacti WHERE hrcma02=g_hrcm.hrcm02
      END IF
   END IF
 
   CLOSE i053_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_hrcm.hrcm02,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT hrcmacti,hrcmmodu,hrcmdate
     INTO g_hrcm.hrcmacti,g_hrcm.hrcmmodu,g_hrcm.hrcmdate FROM hrcm_file
    WHERE hrcm02=g_hrcm.hrcm02
   DISPLAY BY NAME g_hrcm.hrcmacti,g_hrcm.hrcmmodu,g_hrcm.hrcmdate
 
END FUNCTION
 
FUNCTION i053_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_hrcm.hrcm02 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
    IF g_hrcm.hrcmconf = 'Y' THEN
      CALL cl_err('',1208,0)
      RETURN
   END IF 
   SELECT * INTO g_hrcm.* FROM hrcm_file
    WHERE hrcm02=g_hrcm.hrcm02
   BEGIN WORK
 
   OPEN i053_cl USING g_hrcm.hrcm02
   IF STATUS THEN
      CALL cl_err("OPEN i053_cl:", STATUS, 1)
      CLOSE i053_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i053_cl INTO g_hrcm.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_hrcm.hrcm02,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i053_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM hrcm_file WHERE hrcm02 = g_hrcm.hrcm02
      DELETE FROM hrcma_file WHERE hrcma02 = g_hrcm.hrcm02
      CLEAR FORM
      CALL g_hrcma.clear()
      OPEN i053_count
      #FUN-B50065-add-start--
      IF STATUS THEN
         CLOSE i053_cs
         CLOSE i053_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      FETCH i053_count INTO g_row_count
      #FUN-B50065-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i053_cs
         CLOSE i053_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i053_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i053_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL i053_fetch('/')
      END IF
   END IF
 
   CLOSE i053_cl
   COMMIT WORK
   CALL cl_flow_notify(g_hrcm.hrcm02,'D')
END FUNCTION
 
#單身
FUNCTION i053_b()
DEFINE
    l_hratid_tt     LIKE hrat_file.hratid,
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
    l_allow_delete  LIKE type_file.num5,                #可刪除否  
    l_count         LIKE type_file.num5 
DEFINE l_hratid  LIKE hrat_file.hratid 
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  g_h,g_m   LIKE  type_file.num5 
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5,
        g_x      STRING,
        l_hrcma01_t  LIKE hrcma_file.hrcma01,
        l_hrcma09_desc  LIKE type_file.chr50
DEFINE  l_hrcma04_05   LIKE type_file.chr50
DEFINE  l_hrcma06_07   LIKE type_file.chr50
DEFINE  l_hrcma08      LIKE hrcp_file.hrcp11
DEFINE l_string   STRING   
DEFINE l_hh      LIKE  type_file.num5 #校验     
        
       
    LET g_action_choice = ""
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_hrcm.hrcm02 IS NULL THEN
       RETURN
    END IF
    IF g_hrcm.hrcmconf = 'Y' THEN
      CALL cl_err('',1208,0)
      RETURN
   END IF 
    SELECT * INTO g_hrcm.* FROM hrcm_file
     WHERE hrcm02=g_hrcm.hrcm02
 
    IF g_hrcm.hrcmacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_hrcm.hrcm02,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT hrcma01,hrcma03,'','','','',hrcma04,hrcma05,hrcma06,hrcma07,hrcma08,hrcma09,'',hrcma10,hrcma11,hrcma12,hrcma13,hrcma14,hrcma15,hrcma16",
                       "  FROM hrcma_file",
                       "  WHERE hrcma02=? AND hrcma01 = ? FOR UPDATE "  #130704

    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i053_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_hrcma WITHOUT DEFAULTS FROM s_hrcma.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
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
 
           OPEN i053_cl USING g_hrcm.hrcm02
           IF STATUS THEN
              CALL cl_err("OPEN i053_cl:", STATUS, 1)
              CLOSE i053_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i053_cl INTO g_hrcm.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_hrcm.hrcm02,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i053_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_hrcma_t.* = g_hrcma[l_ac].*  #BACKUP
              LET g_hrcma_o.* = g_hrcma[l_ac].*  #BACKUP
              OPEN i053_bcl USING g_hrcm.hrcm02,g_hrcma_t.hrcma01
              IF STATUS THEN
                 CALL cl_err("OPEN i053_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i053_bcl INTO g_hrcma[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_hrcma_t.hrcma01,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT hratid INTO g_hrcma[l_ac].hrcma03 FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
                 CALL i053_hrat_fill(g_hrcma[l_ac].hrcma03) 
                 RETURNING  g_hrcma[l_ac].hrat02,g_hrcma[l_ac].hrat04,g_hrcma[l_ac].hrat20,g_hrcma[l_ac].hrat25
                 SELECT hrag07 INTO g_hrcma[l_ac].hrat20 FROM hrag_file WHERE hrag01='313' AND hrag06=g_hrcma[l_ac].hrat20 AND hragacti='Y'

                 #add by lijun130905------begin-------
                 SELECT hrbm04 INTO g_hrcma[l_ac].hrbm04 FROM hrbm_file
                   WHERE hrbm02='008'
                     AND hrbm03=g_hrcma[l_ac].hrcma09
                     AND hrbm07 ='Y'
                 #add by lijun130905------end-------
                 LET g_hrcma[l_ac].hrcma03 = g_hrcma_t.hrcma03  #130704
                 LET g_errno = ' ' 
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
#              CALL i053_set_entry_b(p_cmd)    #No.FUN-610018
#              CALL i053_set_no_entry_b(p_cmd) #No.FUN-610018
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_hrcma[l_ac].* TO NULL      
           LET g_hrcma[l_ac].hrcma04 =  g_today          
           LET g_hrcma[l_ac].hrcma05 =  '00:00'         
           LET g_hrcma[l_ac].hrcma06 =  g_today    
           LET g_hrcma[l_ac].hrcma07 =  '00:00'       
           LET g_hrcma[l_ac].hrcma11 = 'N'  
           LET g_hrcma[l_ac].hrcma12 = 'N'
           LET g_hrcma[l_ac].hrcma14 = 'N'
           LET g_hrcma[l_ac].hrcma15 = 'N'  
           LET g_hrcma_t.* = g_hrcma[l_ac].*         #新輸入資料
           LET g_hrcma_o.* = g_hrcma[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()         #FUN-550037(smin)
#           CALL i053_set_entry_b(p_cmd)    #No.FUN-610018
#           CALL i053_set_no_entry_b(p_cmd) #No.FUN-610018
           NEXT FIELD hrcma03
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
           CALL i053_auto_hrcma01() RETURNING g_hrcma[l_ac].hrcma01
           
           LET l_hh=0
           CALL i053_jy(g_hrcma[l_ac].*) RETURNING l_hh #校验是否与班次冲突
           IF l_hh>0 THEN  
              CALL cl_err('加班时间与班次时间冲突','!',1)
              cancel INSERT 
           ELSE 
           INSERT INTO hrcma_file(hrcma01,hrcma02,hrcma03,hrcma04,hrcma05,hrcma06,
                                hrcma07,hrcma08,hrcma09,hrcma10,hrcma11,hrcma12,hrcma13,hrcma14,hrcma15,ta_hrcma01,hrcma16) 
           VALUES(g_hrcma[l_ac].hrcma01,g_hrcm.hrcm02,
                  l_hratid,g_hrcma[l_ac].hrcma04,
                  g_hrcma[l_ac].hrcma05,g_hrcma[l_ac].hrcma06,
                  g_hrcma[l_ac].hrcma07,g_hrcma[l_ac].hrcma08,
                  g_hrcma[l_ac].hrcma09,g_hrcma[l_ac].hrcma10,g_hrcma[l_ac].hrcma11,
                  g_hrcma[l_ac].hrcma12,g_hrcma[l_ac].hrcma13,'Y','N','N',g_hrcma[l_ac].hrcma16)  #FUN-650191 add hrcma12 #FUN-980006 add g_plant,g_legal
           END IF 
           
           IF SQLCA.sqlcode AND l_hh=0 THEN
              CALL cl_err3("ins","hrcma_file",g_hrcm.hrcm02,l_hrcma01_t,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
     AFTER FIELD hrcma03
            IF NOT cl_null(g_hrcma[l_ac].hrcma03) THEN
               IF  cl_null(g_hrcma[l_ac].hrcma03) THEN
	                 NEXT FIELD hrcma03
               END IF
               SELECT COUNT(*) INTO l_count FROM hrat_file
                WHERE hratconf ='Y' AND hrat01 = g_hrcma[l_ac].hrcma03
               IF cl_null(l_count) THEN LET l_count = 0  END IF
               IF l_count <=0 THEN
                  CALL cl_err('','mfg1312',1)
                  NEXT FIELD hrcma03
               END IF
               SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
               CALL i053_hrat_fill(l_hratid) 
                 RETURNING  g_hrcma[l_ac].hrat02,g_hrcma[l_ac].hrat04,g_hrcma[l_ac].hrat20,g_hrcma[l_ac].hrat25
                 IF g_hrcma[l_ac].hrat20='001' OR g_hrcma[l_ac].hrat20='002' THEN LET g_hrcma[l_ac].hrcma12='Y' END IF 
                 SELECT hrag07 INTO g_hrcma[l_ac].hrat20 FROM hrag_file WHERE hrag01='313' AND hrag06=g_hrcma[l_ac].hrat20 AND hragacti='Y'
       
               DISPLAY BY NAME g_hrcma[l_ac].hrat02,g_hrcma[l_ac].hrat04,g_hrcma[l_ac].hrat20,g_hrcma[l_ac].hrat25,g_hrcma[l_ac].hrcma12
               LET l_hratid_tt = l_hratid
            END IF
        AFTER FIELD hrcma05
            IF NOT cl_null(g_hrcma[l_ac].hrcma05) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcma[l_ac].hrcma05[1,2]
               LET g_m=g_hrcma[l_ac].hrcma05[4,5]
               LET g_x = g_hrcma[l_ac].hrcma05
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma05
               END IF
              IF g_hrcma[l_ac].hrcma05[1] =' ' OR g_hrcma[l_ac].hrcma05[2] =' '  OR      
               g_hrcma[l_ac].hrcma05[4] =' ' OR g_hrcma[l_ac].hrcma05[5] =' ' OR g_x.getLength() <> 5  THEN 
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma05
               END IF
 ############# 130702################
              LET l_count = 0
              SELECT l_hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
              IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                    (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                   ) 
                   IF l_count > 0 THEN 
                       CALL cl_err('','ghr-128',0)
                       LET g_hrcma[l_ac].hrcma04 =''
                       LET g_hrcma[l_ac].hrcma06 =''
                       NEXT FIELD hrcma04
                    END IF
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                  (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)   
                   ) 
                  IF l_count > 0 THEN 
                     CALL cl_err('','ghr-128',0)
                     LET g_hrcma[l_ac].hrcma05 =''
                     LET g_hrcma[l_ac].hrcma07 =''
                     NEXT FIELD hrcma05
                  END IF
               END IF
               IF p_cmd = 'u' THEN
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                   (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma04 =''
                      LET g_hrcma[l_ac].hrcma06 =''
                      NEXT FIELD hrcma04
                   END IF
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid  AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)  
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma05 =''
                      LET g_hrcma[l_ac].hrcma07 =''
                      NEXT FIELD hrcma05
                   END IF
                END IF
 ############# 130702################
            END IF
 ############# 130702################
 AFTER FIELD hrcma08
           IF NOT cl_null(g_hrcma[l_ac].hrcma08) THEN 
              IF g_hrcma[l_ac].hrcma08 <=0 THEN
                 CALL cl_err('','ghr-124',0)
                 NEXT FIELD hrcma08
              END IF
              LET l_count = 0
              SELECT l_hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
              IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                    (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                   ) 
                   IF l_count > 0 THEN 
                       CALL cl_err('','ghr-128',0)
                       LET g_hrcma[l_ac].hrcma04 =''
                       LET g_hrcma[l_ac].hrcma06 =''
                       NEXT FIELD hrcma04
                    END IF
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                  (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)   
                   ) 
                  IF l_count > 0 THEN 
                     CALL cl_err('','ghr-128',0)
                     LET g_hrcma[l_ac].hrcma05 =''
                     LET g_hrcma[l_ac].hrcma07 =''
                     NEXT FIELD hrcma05
                  END IF
               END IF
               IF p_cmd = 'u' THEN
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                   (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma04 =''
                      LET g_hrcma[l_ac].hrcma06 =''
                      NEXT FIELD hrcma04
                   END IF
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid  AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)  
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma05 =''
                      LET g_hrcma[l_ac].hrcma07 =''
                      NEXT FIELD hrcma05
                   END IF
                END IF
       END IF
 ############# 130702################
        AFTER FIELD hrcma06
           IF NOT cl_null(g_hrcma[l_ac].hrcma06) THEN 
              IF g_hrcma[l_ac].hrcma04 > g_hrcma[l_ac].hrcma06  THEN
                 CALL cl_err('','ghr-120',0)
                 NEXT FIELD hrcma06
              END IF
 ############# 130702################
              LET l_count = 0
              SELECT l_hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
              IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                    (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                   ) 
                   IF l_count > 0 THEN 
                       CALL cl_err('','ghr-128',0)
                       LET g_hrcma[l_ac].hrcma04 =''
                       LET g_hrcma[l_ac].hrcma06 =''
                       NEXT FIELD hrcma04
                    END IF
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                  (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)   
                   ) 
                  IF l_count > 0 THEN 
                     CALL cl_err('','ghr-128',0)
                     LET g_hrcma[l_ac].hrcma05 =''
                     LET g_hrcma[l_ac].hrcma07 =''
                     NEXT FIELD hrcma05
                  END IF
               END IF
               IF p_cmd = 'u' THEN
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                   (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma04 =''
                      LET g_hrcma[l_ac].hrcma06 =''
                      NEXT FIELD hrcma04
                   END IF
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid  AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)  
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma05 =''
                      LET g_hrcma[l_ac].hrcma07 =''
                      NEXT FIELD hrcma05
                   END IF
                END IF
 ############# 130702################
           END IF
        AFTER FIELD hrcma04
           IF NOT cl_null(g_hrcma[l_ac].hrcma04) THEN
              IF g_hrcma[l_ac].hrcma04 > g_hrcma[l_ac].hrcma06  THEN
                 CALL cl_err('','ghr-120',0)
                 NEXT FIELD hrcma04
              END IF
############## 130702################
              LET l_count = 0
              SELECT l_hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
              IF p_cmd = 'a' THEN
                 SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                 (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
               OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
               OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
               OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                ) 
                IF l_count > 0 THEN 
                    CALL cl_err('','ghr-128',0)
                    LET g_hrcma[l_ac].hrcma04 =''
                    LET g_hrcma[l_ac].hrcma06 =''
                    NEXT FIELD hrcma04
                 END IF
                 SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
               (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
               OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
               OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
               OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)   
                ) 
               IF l_count > 0 THEN 
                  CALL cl_err('','ghr-128',0)
                  LET g_hrcma[l_ac].hrcma05 =''
                  LET g_hrcma[l_ac].hrcma07 =''
                  NEXT FIELD hrcma05
               END IF
               END IF
               IF p_cmd = 'u' THEN
                 SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                 (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
               OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
               OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
               OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                ) 
                 IF l_count > 0 THEN 
                    CALL cl_err('','ghr-128',0)
                    LET g_hrcma[l_ac].hrcma04 =''
                    LET g_hrcma[l_ac].hrcma06 =''
                    NEXT FIELD hrcma04
                 END IF
                 SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid  AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
               (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
               OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
               OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
               OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)  
                ) 
                 IF l_count > 0 THEN 
                    CALL cl_err('','ghr-128',0)
                    LET g_hrcma[l_ac].hrcma05 =''
                    LET g_hrcma[l_ac].hrcma07 =''
                    NEXT FIELD hrcma05
                 END IF
                END IF
############## 130702################
           END IF
         AFTER FIELD hrcma07
            IF NOT cl_null(g_hrcma[l_ac].hrcma07) THEN
               LET g_h=''
               LET g_m=''
               LET g_h=g_hrcma[l_ac].hrcma07[1,2]
               LET g_m=g_hrcma[l_ac].hrcma07[4,5]
               LET g_x = g_hrcma[l_ac].hrcma07
               IF cl_null(g_h) OR cl_null(g_m) OR g_h>23 OR g_m>59 THEN
                  CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma07
               END IF
              IF g_hrcma[l_ac].hrcma07[1] =' ' OR g_hrcma[l_ac].hrcma07[2] =' '  OR 
               g_hrcma[l_ac].hrcma07[4] =' ' OR g_hrcma[l_ac].hrcma07[5] =' ' OR g_x.getLength() <>5 THEN
                   CALL cl_err('时间录入错误','!',0)
                  NEXT FIELD hrcma07
               END IF
              IF g_hrcma[l_ac].hrcma06  = g_hrcma[l_ac].hrcma04 AND g_hrcma[l_ac].hrcma05 > g_hrcma[l_ac].hrcma07 THEN
                  CALL cl_err('','ghr-120',0)
                  NEXT FIELD hrcma07
              END IF
 ############# 130702################
              LET l_count = 0
              SELECT l_hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcma[l_ac].hrcma03
              IF p_cmd = 'a' THEN
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                    (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                  OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                   ) 
                   IF l_count > 0 THEN 
                       CALL cl_err('','ghr-128',0)
                       LET g_hrcma[l_ac].hrcma04 =''
                       LET g_hrcma[l_ac].hrcma06 =''
                       NEXT FIELD hrcma04
                    END IF
                    SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND (
                  (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                  OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)   
                   ) 
                  IF l_count > 0 THEN 
                     CALL cl_err('','ghr-128',0)
                     LET g_hrcma[l_ac].hrcma05 =''
                     LET g_hrcma[l_ac].hrcma07 =''
                     NEXT FIELD hrcma05
                  END IF
               END IF
               IF p_cmd = 'u' THEN
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                   (hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma04)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma06  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 < g_hrcma[l_ac].hrcma04  AND hrcma06 > g_hrcma[l_ac].hrcma06)
                 OR(hrcma04 > g_hrcma[l_ac].hrcma04  AND hrcma06 < g_hrcma[l_ac].hrcma06)
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma04 =''
                      LET g_hrcma[l_ac].hrcma06 =''
                      NEXT FIELD hrcma04
                   END IF
                   SELECT COUNT(*) INTO l_count FROM hrcma_file WHERE hrcma03 = l_hratid  AND hrcma01 <> g_hrcma[l_ac].hrcma01 AND(
                (hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma05)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma07  AND hrcma07 > g_hrcma[l_ac].hrcma07) 
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 < g_hrcma[l_ac].hrcma05  AND hrcma07 > g_hrcma[l_ac].hrcma07)
                 OR(hrcma04 = g_hrcma[l_ac].hrcma04  AND hrcma06 = g_hrcma[l_ac].hrcma06 AND hrcma05 > g_hrcma[l_ac].hrcma05  AND hrcma07 < g_hrcma[l_ac].hrcma07)  
                  ) 
                   IF l_count > 0 THEN 
                      CALL cl_err('','ghr-128',0)
                      LET g_hrcma[l_ac].hrcma05 =''
                      LET g_hrcma[l_ac].hrcma07 =''
                      NEXT FIELD hrcma05
                   END IF
                END IF
 ############# 130702################
              #add by lijun130905------begin-------
              IF NOT cl_null(g_hrcma[l_ac].hrcma04) AND NOT cl_null(g_hrcma[l_ac].hrcma05)
                 AND NOT cl_null(g_hrcma[l_ac].hrcma06) THEN
                 LET l_hrcma04_05 = g_hrcma[l_ac].hrcma04 CLIPPED,' ',g_hrcma[l_ac].hrcma05 CLIPPED
                 LET l_hrcma06_07 = g_hrcma[l_ac].hrcma06 CLIPPED,' ',g_hrcma[l_ac].hrcma07 CLIPPED
                 LET l_hrcma08 = ''
                 SELECT TO_NUMBER(to_date(l_hrcma06_07,'YYYY/MM/DD HH24:MI') - to_date(l_hrcma04_05,'YYYY/MM/DD HH24:MI')) * 24 INTO l_hrcma08 from dual;   	
               	 LET l_string = " SELECT TO_NUMBER(to_date('",l_hrcma06_07,"','YYYY/MM/DD HH24:MI') - ",
               	                " to_date('",l_hrcma04_05,"','YYYY/MM/DD HH24:MI')) * 24 FROM dual"
               	 PREPARE l_string_cs FROM l_string
               	 EXECUTE l_string_cs INTO l_hrcma08
               	 IF l_hrcma08 > 0 THEN
               	     LET g_hrcma[l_ac].hrcma08 = l_hrcma08
               	     DISPLAY g_hrcma[l_ac].hrcma08 TO hrcma08
               	 ELSE
               	     CALL cl_err('经计算加班时长小于等于0','!',1)
               	     NEXT FIELD hrcma07
               	 END IF
              END IF
              #add by lijun130905------end-------          
            END IF     
        AFTER FIELD hrcma09
             IF NOT cl_null(g_hrcma[l_ac].hrcma09) THEN
#               SELECT COUNT(*) INTO l_count FROM hrbm_file 
#                WHERE hrbm07 ='Y' AND hrbm02  ='008' AND hrbm01=g_hrcm.hrcm01 AND hrbm03 = g_hrcma[l_ac].hrcma09
#               IF cl_null(l_count) THEN LET l_count = 0  END IF
#               IF l_count <=0 THEN  
#                  CALL cl_err('','mfg1306',1)
#                  NEXT FIELD hrcma09 
#               END IF
               SELECT hrbm04,hrbm23 INTO g_hrcma[l_ac].hrbm04,g_hrcma[l_ac].hrcma12 FROM hrbm_file
                WHERE hrbm07 ='Y' AND hrbm02  ='008'  AND hrbm03 = g_hrcma[l_ac].hrcma09
                DISPLAY g_hrcma[l_ac].hrbm04 TO hrbm04
                DISPLAY g_hrcma[l_ac].hrcma12 TO hrcma12
             END IF
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_hrcma_t.hrcma01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM hrcma_file
               WHERE hrcma02 = g_hrcm.hrcm02
                 AND hrcma01 = g_hrcma_t.hrcma01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrcma_file",g_hrcm.hrcm02,g_hrcma_t.hrcma01,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
              LET g_hrcma[l_ac].* = g_hrcma_t.*
              CLOSE i053_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_hrcma[l_ac].hrcma01,-263,1)
              LET g_hrcma[l_ac].* = g_hrcma_t.*
           ELSE
           #add by nihuan 20160901
              IF NOT cl_null(g_hrcma[l_ac].hrcma03) THEN 
                 SELECT hratid INTO l_hratid_tt FROM hrat_file WHERE hrat01=g_hrcma[l_ac].hrcma03
              END IF 
           #add by nihuan 20160901  

              LET l_hh=0
              CALL i053_jy(g_hrcma[l_ac].*) RETURNING l_hh #校验是否与班次冲突
              IF l_hh>0 THEN  
                CALL cl_err('加班时间与班次时间冲突','!',1)
              ELSE 
              UPDATE hrcma_file SET hrcma03=l_hratid_tt,
                                  hrcma04=g_hrcma[l_ac].hrcma04,
                                  hrcma05=g_hrcma[l_ac].hrcma05,
                                  hrcma06=g_hrcma[l_ac].hrcma06,
                                  hrcma07=g_hrcma[l_ac].hrcma07,
                                  hrcma08=g_hrcma[l_ac].hrcma08,
                                  hrcma09=g_hrcma[l_ac].hrcma09,
                                  hrcma10=g_hrcma[l_ac].hrcma10, 
                                  hrcma11=g_hrcma[l_ac].hrcma11, 
                                  hrcma12=g_hrcma[l_ac].hrcma12,
                                  hrcma13=g_hrcma[l_ac].hrcma13,
                                  hrcma16=g_hrcma[l_ac].hrcma16
               WHERE hrcma02=g_hrcm.hrcm02
                 AND hrcma01=g_hrcma_t.hrcma01
              END IF 
                 
              IF (SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0) AND l_hh=0 THEN
                 CALL cl_err3("upd","hrcma_file",g_hrcm.hrcm02,g_hrcma_t.hrcma01,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_hrcma[l_ac].* = g_hrcma_t.*
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
                 LET g_hrcma[l_ac].* = g_hrcma_t.*
              END IF
              CLOSE i053_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i053_bcl
           COMMIT WORK
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION ins_user
            IF g_hrcm.hrcm02 IS NOT NULL THEN
               CALL i0531_main(g_hrcm.hrcm02)
               CALL i053_b_fill(" 1=1")
               CALL i053_show()
              #CALL i053_b()
               EXIT INPUT
            END IF
        ON ACTION ins_group
            IF g_hrcm.hrcm02 IS NOT NULL THEN
               CALL i0532_main(g_hrcm.hrcm02) 
               CALL i053_b_fill(" 1=1")
               CALL i053_show()
              #CALL i053_b()
               EXIT INPUT
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(hrcma03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrat01" 
                 LET g_qryparam.default1 = g_hrcma[l_ac].hrcma03
                 CALL cl_create_qry() RETURNING g_hrcma[l_ac].hrcma03
                 DISPLAY BY NAME g_hrcma[l_ac].hrcma03
                 NEXT FIELD hrcma03 
              WHEN INFIELD(hrcma09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrbm03"
                 LET g_qryparam.arg1 = '008'
                 LET g_qryparam.default1 = g_hrcma[l_ac].hrcma09
                 CALL cl_create_qry() RETURNING g_hrcma[l_ac].hrcma09
                 DISPLAY BY NAME  g_hrcma[l_ac].hrcma09  
               OTHERWISE EXIT CASE
            END CASE
 
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
 
    LET g_hrcm.hrcmmodu = g_user
    LET g_hrcm.hrcmdate = g_today
    UPDATE hrcm_file SET hrcmmodu = g_hrcm.hrcmmodu,hrcmdate = g_hrcm.hrcmdate
     WHERE hrcm02 = g_hrcm.hrcm02
    DISPLAY BY NAME g_hrcm.hrcmmodu,g_hrcm.hrcmdate
 
    CLOSE i053_bcl
    COMMIT WORK
    CALL i053_delall()
 
END FUNCTION

FUNCTION i053_jy(p_hrcma)
DEFINE   p_hrcma       RECORD                        
          hrcma01      LIKE hrcma_file.hrcma01,
          hrcma03      LIKE hrcma_file.hrcma03,
          hrat02       LIKE hrat_file.hrat02,       
          hrat04       LIKE type_file.chr50,       
          hrat20       LIKE type_file.chr50,
          hrat25       LIKE hrat_file.hrat25, 
          hrcma04      LIKE hrcma_file.hrcma04,
          hrcma05      LIKE hrcma_file.hrcma05,
          hrcma06      LIKE hrcma_file.hrcma06,
          hrcma07      LIKE hrcma_file.hrcma07,
          hrcma08      LIKE hrcma_file.hrcma08,
          hrcma09      LIKE hrcma_file.hrcma09,
          hrbm04       LIKE hrbm_file.hrbm04,     
          hrcma10      LIKE hrcma_file.hrcma10,
          hrcma11      LIKE hrcma_file.hrcma11,
          hrcma12      LIKE hrcma_file.hrcma12,
          hrcma13      LIKE hrcma_file.hrcma13,
          hrcma14      LIKE hrcma_file.hrcma14,
          hrcma15      LIKE hrcma_file.hrcma15,
          hrcma16      LIKE hrcma_file.hrcma16
                     END RECORD
DEFINE    l_hrbo02     LIKE hrbo_file.hrbo02,
          l_n          LIKE type_file.num5     
         ,l_hrboa02    LIKE hrboa_file.hrboa02 #add by nixiang 170620
         ,l_hrboa05    LIKE hrboa_file.hrboa05 #add by nixiang 170620
         
          SELECT CASE WHEN hrcp07 = 'Y' THEN hrcp04 ELSE
               NVL(D.HRDQ06, NVL(E.HRDQ06, NVL(F.HRDQ06, NVL(G.HRDQ06,NVL(H.HRDQ06,NVL(I.HRDQ06,J.HRDQ06)))))) END   
          INTO l_hrbo02                     
          FROM HRAT_FILE A
          LEFT JOIN HRCP_FILE B ON B.HRCP02 = A.HRATID AND B.HRCP03 = p_hrcma.hrcma04
          LEFT JOIN HRCB_FILE C ON C.HRCB05 = A.HRATID AND p_hrcma.hrcma04 BETWEEN C.HRCB06 AND C.HRCB07
          LEFT JOIN HRDQ_FILE D ON D.HRDQ03 = A.HRATID AND D.HRDQ05 = p_hrcma.hrcma04 AND D.HRDQ02 = 1        #/*个人排班*/
          LEFT JOIN HRDQ_FILE E ON E.HRDQ03 = C.HRCB01 AND E.HRDQ05 = p_hrcma.hrcma04 AND E.HRDQ02 = 4        #/*群组排班*/
          LEFT JOIN HRDQ_FILE F ON F.HRDQ03 = A.HRAT88 AND F.HRDQ05 = p_hrcma.hrcma04 AND F.HRDQ02 = 7        #/*组别排班*/
          LEFT JOIN HRDQ_FILE G ON G.HRDQ03 = A.HRAT87 AND G.HRDQ05 = p_hrcma.hrcma04 AND G.HRDQ02 = 6        #/*科别排班*/
          LEFT JOIN HRDQ_FILE H ON H.HRDQ03 = A.HRAT04 AND H.HRDQ05 = p_hrcma.hrcma04 AND H.HRDQ02 = 2         #/*部门排班*/
          LEFT JOIN HRDQ_FILE I ON I.HRDQ03 = A.HRAT94 AND I.HRDQ05 = p_hrcma.hrcma04 AND I.HRDQ02 = 5        #/*中心排班*/
          LEFT JOIN HRDQ_FILE J ON J.HRDQ03 = A.HRAT03 AND J.HRDQ05 = p_hrcma.hrcma04 AND J.HRDQ02 = 3       #/*公司排班*/
         WHERE A.HRAT01 =p_hrcma.hrcma03
          
          LET l_n=0
          IF l_hrbo02 !='REST' THEN
           SELECT hrboa02 INTO l_hrboa02 FROM hrboa_file LEFT JOIN hrbo_file ON hrboa15=hrbo2 WHERE hrbo02=l_hrbo02 AND hrboa03='Y' #add by nixiang 170620
           SELECT hrboa05 INTO l_hrboa05 FROM hrboa_file LEFT JOIN hrbo_file ON hrboa15=hrbo2 WHERE hrbo02=l_hrbo02 AND hrboa06='Y' #add by nixiang 170620
           SELECT COUNT(*) INTO l_n FROM hrbo_file 
           WHERE hrbo02=l_hrbo02 AND 
           #modify by nixiang 170620---s---
           --((p_hrcma.hrcma05 > hrbo04 AND hrbo05>p_hrcma.hrcma05) OR 
           --(p_hrcma.hrcma07 > hrbo04 AND hrbo05>p_hrcma.hrcma07) OR 
           --(p_hrcma.hrcma05<=hrbo04 AND p_hrcma.hrcma07>=hrbo05)
           --)
           ((p_hrcma.hrcma05 > l_hrboa02 AND l_hrboa05>p_hrcma.hrcma05) OR 
           (p_hrcma.hrcma07 > l_hrboa02 AND l_hrboa05>p_hrcma.hrcma07) OR 
           (p_hrcma.hrcma05<=l_hrboa02 AND p_hrcma.hrcma07>=l_hrboa05)
           ) 
           #modify by nixiang 170620---e---
          END IF 
          RETURN l_n
                     
END FUNCTION 
 
FUNCTION i053_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM hrcma_file
    WHERE hrcma02 = g_hrcm.hrcm02
 
   IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM hrcm_file WHERE hrcm02 = g_hrcm.hrcm02
   END IF
 
END FUNCTION
 
FUNCTION i053_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = " SELECT hrcma01,hrcma03,'','','','',hrcma04,hrcma05,hrcma06,hrcma07,hrcma08,hrcma09,'',hrcma10,hrcma11,hrcma12,hrcma13,hrcma14,hrcma15,hrcma16  FROM hrcma_file,hrat_file",
               " WHERE hratid=hrcma03 AND hrcma02 ='",g_hrcm.hrcm02,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY hrcma03 "
   DISPLAY g_sql
 
   PREPARE i053_pb FROM g_sql
   DECLARE hrcma_cs CURSOR FOR i053_pb
 
   CALL g_hrcma.clear()
   LET g_cnt = 1
 
   FOREACH hrcma_cs INTO g_hrcma[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       	SELECT hratid INTO g_hrcma[g_cnt].hrcma03 FROM hrat_file WHERE hrat01 = g_hrcma[g_cnt].hrcma03
       CALL i053_hrat_fill(g_hrcma[g_cnt].hrcma03) 
                 RETURNING  g_hrcma[g_cnt].hrat02,g_hrcma[g_cnt].hrat04,g_hrcma[g_cnt].hrat20,g_hrcma[g_cnt].hrat25
       SELECT hrat01 INTO g_hrcma[g_cnt].hrcma03 FROM hrat_file WHERE hratid =g_hrcma[g_cnt].hrcma03
       
       SELECT hrag07 INTO g_hrcma[g_cnt].hrat20 FROM hrag_file WHERE hrag01='313' AND hrag06=g_hrcma[g_cnt].hrat20 AND hragacti='Y'
       
       SELECT hrbm04 INTO g_hrcma[g_cnt].hrbm04 FROM hrbm_file
        WHERE hrbm07 ='Y' AND hrbm02  ='008'  AND hrbm03 = g_hrcma[g_cnt].hrcma09
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_hrcma.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i053_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("hrcm02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i053_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("hrcm02",FALSE)
    END IF
 
END FUNCTION
 
#FUNCTION i053_set_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1   
#  CALL cl_set_comp_entry("hrcm02",TRUE) 
#END FUNCTION
# 
#FUNCTION i053_set_no_entry_b(p_cmd)
#  DEFINE p_cmd   LIKE type_file.chr1   
# 
# 
#END FUNCTION

FUNCTION i053_hrat_fill(p_hrcma03)
  DEFINE p_hrcma03    LIKE hrcma_file.hrcma03
  DEFINE l_key       LIKE type_file.chr1
  DEFINE l_hrad03  LIKE type_file.chr50
  DEFINE l_hrat05 LIKE type_file.chr50 
  DEFINE l_hrat04 LIKE type_file.chr50 
  DEFINE l_hrat04_name  LIKE type_file.chr50 
  DEFINE l_hrat20_name  LIKE type_file.chr50
  DEFINE l_hrat RECORD LIKE hrat_file.* 
  
  SELECT hrat02,hrat03,hrat04,hrat20,hrat25,hrat19 
    INTO l_hrat.hrat02,l_hrat.hrat03,l_hrat.hrat04,l_hrat.hrat20,l_hrat.hrat25,l_hrat.hrat19
    FROM hrat_file
   WHERE hratid = p_hrcma03 AND hratconf ='Y'
  

  SELECT hrao02 INTO l_hrat04_name FROM hrao_file WHERE hrao01 = l_hrat.hrat04 AND hrao00 = l_hrat.hrat03 AND hraoacti = 'Y' 
#  SELECT hrap02 INTO l_hrat05_name FROM hrap_file WHERE hrap01 = l_hrat.hrat04 AND hrap05 = l_hrat.hrat05 AND hrapacti = 'Y'
  SELECT hrat02 INTO l_hrat.hrat02 FROM hrat_file WHERE hratconf ='Y' AND hrat01 = p_hrcma03
  SELECT hrad03 INTO l_hrad03 FROM hrad_file WHERE hrad02 = l_hrat.hrat19
  RETURN l_hrat.hrat02,
         l_hrat04_name,l_hrat.hrat20,
         l_hrat.hrat25
    
END FUNCTION

FUNCTION i053_auto_hrcma01()
   DEFINE l_yy                 SMALLINT
   DEFINE l_mm                 SMALLINT
   DEFINE l_dd,i                 SMALLINT
   DEFINE ls_date              STRING
   DEFINE l_max_no             LIKE hrcma_file.hrcma01 
   DEFINE ls_max_no            STRING
   DEFINE ls_format            STRING
   DEFINE ls_max_pre           STRING
   DEFINE li_max_num           LIKE type_file.num20
   DEFINE li_max_comp          LIKE type_file.num20
   DEFINE l_hrcma01             LIKE hrcma_file.hrcma01
   DEFINE l_sql             STRING
   
   LET ls_max_pre = '9999999999'
   LET li_max_num=0
   LET li_max_comp= 0
   LET l_yy   = YEAR(g_today)
   LET l_mm   = MONTH(g_today)
   LET l_dd   = DAY(g_today)
   LET ls_date = l_yy USING "&&&&",l_mm USING "&&",l_dd USING "&&" 
   LET ls_date = ls_date.substring(3,8)

   LET l_sql ="SELECT MAX(hrcma01) FROM hrcma_file ",
              " WHERE hrcma01 LIKE '",ls_date CLIPPED,"%'"
   PREPARE auto_no_pre FROM l_sql
   EXECUTE auto_no_pre INTO l_max_no
   
   IF l_max_no IS NULL THEN
      LET l_hrcma01 = ls_date CLIPPED,'000001'
   ELSE
      LET ls_max_no = l_max_no[7,12]
      LET li_max_num = ls_max_pre.subString(1,6)  #最大編號值
      FOR i=1 TO 6
          LET ls_format = ls_format,"&"
      END FOR
      LET li_max_comp = ls_max_no + 1
      IF li_max_comp > li_max_num THEN
         CALL cl_err("","sub-518",1)
      ELSE
         LET l_hrcma01 = ls_date CLIPPED,li_max_comp USING ls_format
      END IF
    END IF    
    RETURN l_hrcma01
END FUNCTION

FUNCTION i053_confirm(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_str     LIKE ze_file.ze01
    IF g_hrcm.hrcm02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF

    IF p_cmd = 'Y' THEN
       IF g_hrcm.hrcmconf = 'Y' THEN
          CALL cl_err(g_hrcm.hrcm02,'axm1163',0)
          RETURN
       END IF
       LET l_str = 'aim-301'
    ELSE
       IF g_hrcm.hrcmconf = 'N' THEN
          CALL cl_err(g_hrcm.hrcm02,'9025',0)
          RETURN
       END IF
         LET l_str = 'aim-302'
    END IF

    BEGIN WORK

    CALL i053_show()
    IF  cl_confirm(l_str) THEN
        UPDATE hrcm_file SET hrcmconf=p_cmd
            WHERE hrcm02=g_hrcm.hrcm02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_hrcm.hrcm02,SQLCA.sqlcode,0)
            ROLLBACK WORK
        END IF
    END IF
    COMMIT WORK
    SELECT DISTINCT hrcmconf INTO g_hrcm.hrcmconf FROM hrcm_file
     WHERE hrcm02 = g_hrcm.hrcm02
    DISPLAY BY NAME g_hrcm.hrcmconf
END FUNCTION 

FUNCTION i053_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       l_hrcma10 LIKE hrcma_file.hrcma10,
       p_argv1  LIKE type_file.num5
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD   
         hrcm01   LIKE hrcm_file.hrcm01,
         hrcm02   LIKE hrcm_file.hrcm02, 
         hrcm03   LIKE hrcm_file.hrcm03, 
         hrcm04   LIKE hrcm_file.hrcm04, 
         hrcma01  LIKE hrcma_file.hrcma01,
         hrcma02  LIKE hrcma_file.hrcma02,
         hrcma03  LIKE hrcma_file.hrcma03,
         hrcma04  LIKE hrcma_file.hrcma04,
         hrcma05  LIKE hrcma_file.hrcma05,
         hrcma06  LIKE hrcma_file.hrcma06,
         hrcma07  LIKE hrcma_file.hrcma07,
         hrcma08  LIKE hrcma_file.hrcma08,
         hrcma09  LIKE hrcma_file.hrcma09,
         hrcma10  LIKE hrcma_file.hrcma10,
         hrcma11  LIKE hrcma_file.hrcma11,
         hrcma12  LIKE hrcma_file.hrcma12,
         hrcma13  LIKE hrcma_file.hrcma13
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 
DEFINE   l_hrcma  RECORD  LIKE hrcma_file.*
DEFINE   l_hrat02    LIKE hrat_file.hrat02
DEFINE   l_mh       LIKE hrat_file.hratconf


   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow                                                                   
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrcm01])     #公司编号
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrcm04])     #加班原因
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrcm02])     #加班计划单号
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrcm03])     #加班计划名称
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrcma03])    #工号
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrcma04])    #开始日期
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrcma05])    #开始时间
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrcma06])    #结束日期
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrcma07])   #结束时间
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrcma08])   #时长
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrcma09])   #加班类型
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[sr.hrcma10])   #就餐时长
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',14).Value'],[sr.hrcma11])   #固定扣除
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',15).Value'],[sr.hrcma12])   #自动调休
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',16).Value'],[sr.hrcma13])   #备注
                 
                IF NOT cl_null(sr.hrcm01) AND NOT cl_null(sr.hrcma03) AND NOT cl_null(sr.hrcm02) AND NOT cl_null(sr.hrcma04) AND NOT cl_null(sr.hrcma05) AND NOT cl_null(sr.hrcma06)  
                   AND NOT cl_null(sr.hrcma07) AND NOT cl_null(sr.hrcma08) AND NOT cl_null(sr.hrcma09) THEN
                   SELECT hratid,hrat02 INTO sr.hrcma03,l_hrat02 FROM hrat_file WHERE hrat01=sr.hrcma03
                   CALL i053_auto_hrcma01() RETURNING sr.hrcma01
                   IF i > 1 THEN
                   	LET l_mh=''
                   	SELECT substr(sr.hrcma05,3,1) INTO l_mh FROM dual 
                   	IF l_mh!=':' THEN
                   	   CALL cl_err('开始时间格式不对 ',l_hrat02,1)
                   		 LET g_success  = 'N'
                       CONTINUE FOR 
                   	END IF  
                   	
                   	LET l_mh=''
                   	SELECT substr(sr.hrcma07,3,1) INTO l_mh FROM dual 
                   	IF l_mh!=':' THEN
                   	   CALL cl_err('结束时间格式不对 ',l_hrat02,1)
                   		 LET g_success  = 'N'
                       CONTINUE FOR 
                   	END IF 
                   	
                   	IF sr.hrcma04=sr.hrcma06 AND sr.hrcma05>sr.hrcma07 THEN 
                   		 CALL cl_err('结束时间小于开始时间 ',l_hrat02,1)
                   		 LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF    
                   	
                   	SELECT COUNT(*) INTO l_n FROM hrcm_file WHERE hrcm02=sr.hrcm02
                   	IF l_n=0 THEN 
                   	INSERT INTO hrcm_file(hrcm01,hrcm02,hrcm03,hrcm04,hrcm05,hrcmuser,hrcmgrup,hrcmdate,hrcmorig,hrcmoriu)
                   	              VALUES (sr.hrcm01,sr.hrcm02,sr.hrcm03,sr.hrcm04,'Y',g_user,g_grup,g_today,g_grup,g_user)
                    END IF 
                    INSERT INTO hrcma_file(hrcma01,hrcma02,hrcma03,hrcma04,hrcma05,hrcma06,hrcma07,hrcma08,hrcma09,hrcma10,hrcma11,hrcma12,hrcma13,hrcma14,hrcma15,ta_hrcma01)
                      VALUES (sr.hrcma01,sr.hrcm02,sr.hrcma03,sr.hrcma04,sr.hrcma05,sr.hrcma06,sr.hrcma07,sr.hrcma08,sr.hrcma09,sr.hrcma10,sr.hrcma11,sr.hrcma12,sr.hrcma13,'Y','N','N')                              
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrcma_file",sr.hrcma01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 

                   END IF
                ELSE 
#                   IF i>1 THEN  
#                   LET g_success='N'
#                   ROLLBACK WORK
#                   CALL cl_err('导入数据有误，请检查','!',1) 
#                   END IF 
                END IF 
                   #LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
              CALL cl_err( '打开工作簿失败','!', 1 )
          END IF
       ELSE
           DISPLAY 'NO EXCEL'
           CALL cl_err( '打开文件失败','!', 1 )
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
#       SELECT * INTO g_hrcma.* FROM hrcma_file
#       WHERE hrcmaid=l_hrcmaid
#       
#       CALL i053_show()
   END IF 

END FUNCTION

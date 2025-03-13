# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: aski004.4gl
# Descriptions...: 群組報工工單維護作業珛
# Date & Author..: No.FUN-810016 No.FUN-840178 FUN-870117 FUN-8B0023 07/08/01 By hongmei                                                                                                
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-980008 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-940168 09/08/25 By alex 調整cl_used位置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80030 11/08/03 By minpp 模组程序撰写规范修改
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-D40030 13/04/07 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_skn           RECORD LIKE skn_file.*,        
    g_skn_t         RECORD LIKE skn_file.*,       
    g_skn_o         RECORD LIKE skn_file.*,
    g_skn01         LIKE skn_file.skn01,      
    g_skn01_t       LIKE skn_file.skn01,            
    g_skn02_t       LIKE skn_file.skn02,       
    g_ydate         DATE,                                
    g_sko           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
        sko02       LIKE sko_file.sko02,          #群組編號
        skl02       LIKE skl_file.skl02,          #群組名稱   
        sko03       LIKE sko_file.sko03,          #預計生產數量 
        sko04       LIKE sko_file.sko04,          #預計開工日期
        sko05       LIKE sko_file.sko05           #預計完工日期
                    END RECORD,
    g_sko_t         RECORD                        #程式變數 (舊值)
        sko02       LIKE sko_file.sko02,          
        skl02       LIKE skl_file.skl02,          
        sko03       LIKE sko_file.sko03,            
        sko04       LIKE sko_file.sko04,
        sko05       LIKE sko_file.sko05
                    END RECORD, 
    g_sko_o         RECORD                        #程式變數 (舊值)
        sko02       LIKE sko_file.sko02,          
        skl02       LIKE skl_file.skl02,          
        sko03       LIKE sko_file.sko03,             
        sko04       LIKE sko_file.sko04,
        sko05       LIKE sko_file.sko05 
                    END RECORD,
    g_sql           STRING,                       #CURSOR暫存 
    g_wc            STRING,                       #單頭CONSTRUCT結果
    g_wc2           STRING,                       #單身CONSTRUCT結果
    g_rec_b         LIKE type_file.num5,                     #單身筆數
    l_ac            LIKE type_file.num5                      #目前處理的ARRAY CNT
                                                   
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_chr               LIKE type_file.chr1
DEFINE g_cnt               LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num5               #count/index for any purpose
DEFINE g_msg               LIKE type_file.chr1000
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_row_count         LIKE type_file.num10                #總筆數
DEFINE g_jump              LIKE type_file.num10                #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5    #是否開啟指定筆視窗
DEFINE g_argv1             LIKE skn_file.skn01    #單號
DEFINE g_argv2             STRING                 #指定執行的功能
 
MAIN
    OPTIONS                                #改變一些系統預設值扢硉
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASK")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('slk') THEN
      CALL cl_err("","-1000",1)
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #TQC-940168
 
   LET g_forupd_sql = "SELECT * FROM skn_file WHERE skn01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i004_cl CURSOR FROM g_forupd_sql
 
   OPEN WINDOW i004_w WITH FORM "ask/42f/aski004"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   CALL i004_menu()
   CLOSE WINDOW i004_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i004_cs()
 
 CLEAR FORM                             #清除單頭畫面
 CALL g_sko.clear()                     #清除單身畫面
 
 
 
   CONSTRUCT BY NAME g_wc ON skn01,skn02,
                             sknuser,skngrup,sknmodu,skndate,sknacti
      ON ACTION controlp
         CASE
            WHEN INFIELD(skn01)    #工單單號
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_sfb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO skn01
               NEXT FIELD skn01
             
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sknuser', 'skngrup') #FUN-980030
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #      LET g_wc = g_wc clipped," AND sknuser = '",g_user,"'"
   #   END IF
 
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #      LET g_wc = g_wc clipped," AND skngrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
 
      CONSTRUCT g_wc2 ON sko02,sko03,sko04,sko05 #螢幕上取單身條件 
           FROM s_sko[1].sko02,s_sko[1].sko03,
                s_sko[1].sko04,s_sko[1].sko05   
      ON ACTION CONTROLP 
         CASE 
          
           WHEN INFIELD(sko02)  #群組編號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form ="q_skl"
              CALL cl_create_qry() RETURNING g_sko[l_ac].sko02
              DISPLAY BY NAME g_sko[l_ac].sko02
              NEXT FIELD sko02
            OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION about
            CALL cl_about() 
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
    
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
 
   IF g_wc2 = " 1=1" THEN                  #若單身未輸入條件
      LET g_sql = "SELECT  skn01 FROM skn_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY skn01"
   ELSE                                    #若單身有輸入條件
      LET g_sql = "SELECT  skn01 ",
                  "  FROM skn_file, sko_file ",
                  " WHERE skn01 = sko01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY skn01"
   END IF
 
   PREPARE i004_prepare FROM g_sql
   DECLARE i004_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i004_prepare
 
   IF g_wc2 = " 1=1" THEN                  #取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM skn_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT skn01) FROM skn_file,sko_file WHERE ",
                "sko01=skn01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i004_precount FROM g_sql
   DECLARE i004_count CURSOR FOR i004_precount
 
END FUNCTION
 
FUNCTION i004_menu()
   DEFINE l_str  LIKE type_file.chr1000
 
   WHILE TRUE
      CALL i004_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i004_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i004_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i004_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i004_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i004_x()
            END IF
 
#        WHEN "reproduce"
#           IF cl_chk_act_auth() THEN
#              CALL i004_copy()
#           END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i004_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "output"                                                        
            IF cl_chk_act_auth() THEN
               CALL i004_out()
            END IF
            
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exporttoexcel"                                                   
            IF cl_chk_act_auth() THEN                                           
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_skn),'','')
            END IF
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i004_y()
               CALL i004_field_pic()
            END IF
         
         WHEN "unconfirm"
           IF cl_chk_act_auth() THEN
              CALL i004_z()
              CALL i004_field_pic()   
           END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i004_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sko TO s_sko.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
         
      ON ACTION output                                                          
           LET g_action_choice="output"                                           
           EXIT DISPLAY
           
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i004_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION previous
         CALL i004_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION jump
         CALL i004_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION next
         CALL i004_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION last
         CALL i004_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
#     ON ACTION reproduce
#        LET g_action_choice="reproduce"
#        EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
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
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION confirm 
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL i004_y()
            CALL i004_field_pic()
         END IF 
      
      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL i004_z()
            CALL i004_field_pic()
         END IF
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
FUNCTION i004_a()
   DEFINE   li_result   LIKE type_file.num5
   DEFINE   ls_doc      STRING
   DEFINE   li_inx      LIKE type_file.num10
 
   MESSAGE ""
   CLEAR FORM
   CALL g_sko.clear()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_skn.* LIKE skn_file.*             #DEFAULT 設定
   LET g_skn01_t = NULL
 
   LET g_skn.skn02 = 'N' 
   #預設值及將數值類變數清成零
   LET g_skn_t.* = g_skn.*
   LET g_skn_o.* = g_skn.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_skn.sknuser=g_user
      LET g_skn.skngrup=g_grup
      LET g_skn.skndate=g_today
      LET g_skn.sknacti='Y'              #資料有效虴
      LET g_skn.sknplant=g_plant  #FUN-980008 add
      LET g_skn.sknlegal=g_legal  #FUN-980008 add
 
      CALL i004_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_skn.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_skn.skn01) THEN       # KEY不可空白
         CONTINUE WHILE
      END IF
 
      LET g_skn.sknoriu = g_user      #No.FUN-980030 10/01/04
      LET g_skn.sknorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO skn_file VALUES (g_skn.*)
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
          CALL cl_err(g_skn.skn01,SQLCA.sqlcode,1)  #FUN-B80030 ADD
         ROLLBACK WORK      
      # CALL cl_err(g_skn.skn01,SQLCA.sqlcode,1)   #FUN-B80030 MARK
 
         CONTINUE WHILE
      ELSE
         COMMIT WORK         
         CALL cl_flow_notify(g_skn.skn01,'I')
      END IF
 
      SELECT skn01 into g_skn.skn01 FROM skn_file
       WHERE skn01 = g_skn.skn01
      LET g_skn01_t = g_skn.skn01        #保留舊值
      LET g_skn_t.* = g_skn.*
      LET g_skn_o.* = g_skn.*
      CALL g_sko.clear()
 
      LET g_rec_b = 0  
      CALL i004_b()                      #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i004_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_skn.skn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_skn.* FROM skn_file
    WHERE skn01=g_skn.skn01
 
   IF g_skn.sknacti ='N' THEN    #檢查資料是否為無效虴
      CALL cl_err(g_skn.skn01,'mfg1000',0)
      RETURN
   END IF
    IF g_skn.skn02 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_skn01_t = g_skn.skn01
   BEGIN WORK
 
   OPEN i004_cl USING g_skn.skn01
   IF STATUS THEN
      CALL cl_err("OPEN i004_cl:", STATUS, 1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i004_cl INTO g_skn.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_skn.skn01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i004_show()
 
   WHILE TRUE
      LET g_skn01_t = g_skn.skn01
      LET g_skn_o.* = g_skn.*
      LET g_skn.sknmodu=g_user
      LET g_skn.skndate=g_today
 
      CALL i004_i("u")                           #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_skn.*=g_skn_t.*
         CALL i004_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_skn.skn01 != g_skn01_t THEN            #更改單號 
         UPDATE sko_file SET sko01 = g_skn.skn01
          WHERE sko01 = g_skn01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","sko_file",g_skn01_t,"",SQLCA.sqlcode,"","sko",1) 
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE skn_file SET skn_file.* = g_skn.*
       WHERE skn01 = g_skn01_t
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","skn_file","","",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i004_cl
   COMMIT WORK
   CALL cl_flow_notify(g_skn.skn01,'U')
 
END FUNCTION
 
FUNCTION i004_i(p_cmd)
 
DEFINE
   l_n             LIKE type_file.num5,
   p_cmd           LIKE type_file.chr8                #a:輸入 u:更改
   DEFINE   li_result   LIKE type_file.num5
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_skn.skn01,g_skn.skn02,g_skn.sknuser,g_skn.sknmodu,
                   g_skn.skngrup,g_skn.skndate,g_skn.sknacti
 
   INPUT BY NAME g_skn.skn01,g_skn.skn02,g_skn.sknuser,g_skn.sknmodu,
                 g_skn.skngrup,g_skn.skndate,g_skn.sknacti
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i004_set_entry(p_cmd)
         CALL i004_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("skn01") 
 
      AFTER FIELD skn01
          IF cl_null(g_skn.skn01) THEN
             CALL cl_err('skn01','ask-014',0)
             NEXT FIELD skn01
          END IF
          IF g_skn.skn01 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_skn.skn01 !=g_skn01_t) THEN
                SELECT COUNT(*) INTO l_n FROM skn_file
                 WHERE skn01 = g_skn.skn01
                IF l_n>0 THEN
                   CALL cl_err(g_skn.skn01,'ask-118',0)
                   NEXT FIELD skn01
                END IF
             END IF
          END IF                                                                 
     
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
 
      ON ACTION controlp
         CASE                                                              
            WHEN INFIELD(skn01) #工單單號                                
               CALL cl_init_qry_var()                                     
               LET g_qryparam.form ="q_sfb"                             
               LET g_qryparam.default1 = g_skn.skn01                      
               CALL cl_create_qry() RETURNING g_skn.skn01                 
               DISPLAY g_skn.skn01 TO skn01                                
               NEXT FIELD skn01
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
   END INPUT
 
END FUNCTION
 
FUNCTION i004_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_sko.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i004_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_skn.* TO NULL
      RETURN
   END IF
 
   OPEN i004_cs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_skn.* TO NULL
   ELSE
      OPEN i004_count
      FETCH i004_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i004_fetch('F')                 #讀出TEMP第一筆并顯示珆尨
   END IF
 
END FUNCTION
 
FUNCTION i004_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1            #處理方式宒
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i004_cs INTO g_skn.skn01
      WHEN 'P' FETCH PREVIOUS i004_cs INTO g_skn.skn01
      WHEN 'F' FETCH FIRST    i004_cs INTO g_skn.skn01
      WHEN 'L' FETCH LAST     i004_cs INTO g_skn.skn01
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
            FETCH ABSOLUTE g_jump i004_cs INTO g_skn.skn01
            LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_skn.skn01,SQLCA.sqlcode,0)
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
 
   SELECT * INTO g_skn.* FROM skn_file WHERE skn01 = g_skn.skn01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","skn_file","","",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_skn.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_skn.sknuser       
   LET g_data_group = g_skn.skngrup       
 
   CALL i004_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i004_show()
   LET g_skn_t.* = g_skn.*                #保存單頭舊值硉
   LET g_skn_o.* = g_skn.*                #保存單頭舊值
   DISPLAY BY NAME g_skn.skn01,g_skn.skn02,
                   g_skn.sknuser,g_skn.skngrup,g_skn.sknmodu,
                   g_skn.skndate,g_skn.sknacti
 
   CALL i004_b_fill(g_wc2)                #單身
   CALL i004_field_pic()
 
END FUNCTION
 
FUNCTION i004_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_skn.skn01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   IF g_skn.skn02 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   BEGIN WORK
 
   OPEN i004_cl USING g_skn.skn01
   IF STATUS THEN
      CALL cl_err("OPEN i004_cl:", STATUS, 1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i004_cl INTO g_skn.*               #鎖住將被更改或取消的資料 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_skn.skn01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i004_show()
 
   IF cl_exp(0,0,g_skn.sknacti) THEN        #確認一下
      LET g_chr=g_skn.sknacti
      IF g_skn.sknacti='Y' THEN
         LET g_skn.sknacti='N'
      ELSE
         LET g_skn.sknacti='Y'
      END IF
 
      UPDATE skn_file SET sknacti=g_skn.sknacti,
                          sknmodu=g_user,
                          skndate=g_today
       WHERE skn01=g_skn.skn01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","skn_file",g_skn.skn01,"",SQLCA.sqlcode,"","",1)  
         LET g_skn.sknacti=g_chr
      END IF
   END IF
 
   CLOSE i004_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_skn.skn01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT sknacti,sknmodu,skndate
     INTO g_skn.sknacti,g_skn.sknmodu,g_skn.skndate FROM skn_file
    WHERE skn01=g_skn.skn01
   DISPLAY BY NAME g_skn.sknacti,g_skn.sknmodu,g_skn.skndate
 
END FUNCTION
 
FUNCTION i004_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_skn.skn01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_skn.* FROM skn_file
    WHERE skn01=g_skn.skn01
   IF g_skn.sknacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_skn.skn01,'mfg1000',0)
      RETURN
   END IF
   IF g_skn.skn02 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   BEGIN WORK
 
   OPEN i004_cl USING g_skn.skn01
   IF STATUS THEN
      CALL cl_err("OPEN i004_cl:", STATUS, 1)
      CLOSE i004_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i004_cl INTO g_skn.*               #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_skn.skn01,SQLCA.sqlcode,0)          #資料被他人 LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i004_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM skn_file WHERE skn01 = g_skn.skn01
      DELETE FROM sko_file WHERE sko01 = g_skn.skn01
      CLEAR FORM
      CALL g_sko.clear()
      OPEN i004_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i004_cs
         CLOSE i004_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i004_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i004_cs
         CLOSE i004_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i004_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i004_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL i004_fetch('/')
      END IF
   END IF
 
   CLOSE i004_cl
   COMMIT WORK
   CALL cl_flow_notify(g_skn.skn01,'D')
 
END FUNCTION
 
#單身
FUNCTION i004_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,     #檢查重復用
    l_cnt           LIKE type_file.num5,     #檢查重復用
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
    p_cmd           LIKE type_file.chr1,     #處理狀態怓
    l_allow_insert  LIKE type_file.num5,     #可新增否
    l_allow_delete  LIKE type_file.num5,     #可刪除否
    l_sfb08         LIKE sfb_file.sfb08
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_skn.skn01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_skn.* FROM skn_file
     WHERE skn01=g_skn.skn01
 
    IF g_skn.sknacti ='N' THEN    #檢查資料是否為無效虴
       CALL cl_err(g_skn.skn01,'mfg1000',0)
       RETURN
    END IF
    IF g_skn.skn02 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT sko02,'',sko03,sko04,sko05 ",
                       "  FROM sko_file",
                       " WHERE sko01=? AND sko02=? AND sko03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i004_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
   
 
    INPUT ARRAY g_sko WITHOUT DEFAULTS FROM s_sko.*
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
           LET g_sko[l_ac].sko04=g_today
 
           BEGIN WORK
 
           OPEN i004_cl USING g_skn.skn01
           IF STATUS THEN
              CALL cl_err("OPEN i004_cl:", STATUS, 1)
              CLOSE i004_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i004_cl INTO g_skn.*            #鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_skn.skn01,SQLCA.sqlcode,0)      #資料被他人�LOCK
              CLOSE i004_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_sko_t.* = g_sko[l_ac].*  #BACKUP
              LET g_sko_o.* = g_sko[l_ac].*  #BACKUP
              OPEN i004_bcl USING g_skn.skn01,g_sko[l_ac].sko02,g_sko[l_ac].sko03
              IF STATUS THEN
                 CALL cl_err("OPEN i004_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i004_bcl INTO g_sko[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_skn.skn02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 SELECT skl02 INTO g_sko[l_ac].skl02
                    FROM skl_file WHERE skl01=g_sko[l_ac].sko02
              END IF
              CALL i004_set_entry_b(p_cmd)     
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET p_cmd='a'
           LET l_n = ARR_COUNT()
           INITIALIZE g_sko[l_ac].* TO NULL      
           LET g_sko_t.* = g_sko[l_ac].*         #新輸入資料
           LET g_sko_o.* = g_sko[l_ac].*         #新輸入資料
           LET g_sko[l_ac].sko04 = g_today
           CALL i004_set_entry_b(p_cmd)    
           NEXT FIELD sko02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO sko_file(sko01,sko02,sko03,sko04,sko05,skoplant,skolegal) #FUN-980008 add
           VALUES(g_skn.skn01,g_sko[l_ac].sko02,g_sko[l_ac].sko03,
                  g_sko[l_ac].sko04,g_sko[l_ac].sko05,g_plant,g_legal) #FUN-980008 add
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","sko_file",g_skn.skn01,g_sko[l_ac].sko02,SQLCA.sqlcode,"","",1)  
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
{
       AFTER FIELD sko02                        #check 序號是否重復
           IF NOT cl_null(g_sko[l_ac].sko02) THEN
              IF g_sko[l_ac].sko02 != g_sko_t.sko02
                 OR g_sko_t.sko02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM sko_file
                  WHERE sko01 = g_skn.skn01
                    AND sko02 = g_sko[l_ac].sko02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_sko[l_ac].sko02 = g_sko_t.sko02
                    NEXT FIELD sko02
                 END IF
              END IF
           END IF
}
       AFTER FIELD sko02
#         IF cl_null(g_sko[l_ac].sko02) THEN
#            CALL cl_err('sko02','ask-014',0)
#            NEXT FIELD sko02
#         END IF
          IF g_sko[l_ac].sko02 IS NOT NULL THEN
             IF p_cmd="a" OR (p_cmd="u" AND g_sko[l_ac].sko02 !=g_sko_t.sko02) THEN
                SELECT COUNT(*) INTO l_n FROM skl_file
                 WHERE skl01 = g_sko[l_ac].sko02
                IF l_n=0 THEN
                   CALL cl_err(g_sko[l_ac].sko02,'ask-015',0)
                   NEXT FIELD sko02
                END IF
                CALL i004_sko02('d')
             END IF
          END IF
      
       BEFORE FIELD sko03
         IF p_cmd ='a' OR (p_cmd = 'u' AND g_sko[l_ac].sko03 != g_sko_t.sko03) THEN 
          SELECT sfb08 INTO l_sfb08 FROM sfb_file 
           WHERE sfb01 = g_skn.skn01
           LET g_sko[l_ac].sko03 = l_sfb08
         END IF   
           
       AFTER FIELD sko03
         IF g_sko[l_ac].sko03 > l_sfb08 THEN 
            CALL cl_err(g_sko[l_ac].sko03,'ask-056',0)
            NEXT FIELD sko03
         END IF     
          
       AFTER FIELD sko05
          IF NOT cl_null(g_sko[l_ac].sko04)
             AND NOT cl_null(g_sko[l_ac].sko05) 
             AND g_sko[l_ac].sko05 < g_sko[l_ac].sko04 THEN 
             CALL cl_err(g_sko[l_ac].sko05,'mfg2604',0)
             NEXT FIELD sko05
          END IF   
  
        BEFORE DELETE                      #是否取消單身
           IF NOT cl_null(g_sko_t.sko02) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
#          DISPLAY "BEFORE DELETE"
#          IF g_sko_t.sko02 IS NOT NULL THEN
#              IF NOT cl_delb(0,0) THEN
#                 CANCEL DELETE
#              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM sko_file
               WHERE sko01 = g_skn.skn01
                 AND sko02 = g_sko_t.sko02
                 AND sko03 = g_sko_t.sko03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","sko_file",g_sko_t.sko02,g_sko_t.sko03,SQLCA.sqlcode,"","",1)   
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
              LET g_sko[l_ac].* = g_sko_t.*
              CLOSE i004_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_sko[l_ac].sko02,-263,1)
              LET g_sko[l_ac].* = g_sko_t.*
           ELSE
              UPDATE sko_file SET sko02=g_sko[l_ac].sko02,
                                  sko03=g_sko[l_ac].sko03,
                                  sko04=g_sko[l_ac].sko04,
                                  sko05=g_sko[l_ac].sko05
               WHERE sko01=g_skn.skn01
                 AND sko02=g_sko_t.sko02
                 AND sko03=g_sko_t.sko03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","sko_file",g_skn.skn01,g_sko_t.sko02,SQLCA.sqlcode,"","",1)  
                 LET g_sko[l_ac].* = g_sko_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac      #FUN-D40030 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_sko[l_ac].* = g_sko_t.*
              #FUN-D40030---add---str---
              ELSE
                 CALL g_sko.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030---add---end---
              END IF
              CLOSE i004_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D40030 add
           CLOSE i004_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(sko02) AND l_ac > 1 THEN
              LET g_sko[l_ac].* = g_sko[l_ac-1].*
              LET g_sko[l_ac].sko02 = g_rec_b + 1
              NEXT FIELD sko02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(sko02) #群組編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_skl"
                 LET g_qryparam.default1 = g_sko[l_ac].sko02
                 CALL cl_create_qry() RETURNING g_sko[l_ac].sko02
                 DISPLAY BY NAME g_sko[l_ac].sko02
                 CALL i004_sko02('d')
                 NEXT FIELD sko02
 
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name  
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)  
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about          
         CALL cl_about()       
 
      ON ACTION help           
         CALL cl_show_help()   
 
    END INPUT
 
   #記錄單身修改人和時間
    LET g_skn.sknmodu = g_user
    LET g_skn.skndate = g_today
    UPDATE skn_file SET sknmodu = g_skn.sknmodu,skndate = g_skn.skndate
     WHERE skn01 = g_skn.skn01
    DISPLAY BY NAME g_skn.sknmodu,g_skn.skndate
    
 
    CLOSE i004_bcl
    COMMIT WORK
#   CALL i004_delall()  #CHI-C30002 mark
    CALL i004_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i004_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM  skn_file WHERE skn01 = g_skn.skn01
         INITIALIZE g_skn.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i004_delall()
#
#   SELECT COUNT(*) INTO g_cnt FROM sko_file
#    WHERE sko01 = g_skn.skn01
#
#   IF g_cnt = 0 THEN                   #未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM skn_file WHERE skn01 = g_skn.skn01
#   END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i004_sko02(p_cmd)  
    DEFINE p_cmd       LIKE type_file.chr1,
           p_code      LIKE type_file.chr1,
           l_skl01     LIKE skl_file.skl01,
           l_skl02     LIKE skl_file.skl02
         
 
    LET g_errno = ' '
        SELECT skl02
          INTO g_sko[l_ac].skl02
          FROM skl_file WHERE skl01 = g_sko[l_ac].sko02
 
        IF SQLCA.sqlcode THEN
            LET g_errno = 'agl-005'
        END IF
 
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
          DISPLAY g_sko[l_ac].skl02 TO skl02 
    END IF
END FUNCTION 
 
FUNCTION i004_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON sko02,skl02,sko03,sko04,sko05
            FROM s_sko[1].sko02,s_sko[1].skl02,s_sko[1].sko03,
                 s_sko[1].sko04,s_sko[1].sko05
 
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
       LET INT_FLAG = 0
       RETURN
    END IF
 
    CALL i004_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i004_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2       STRING
 
    LET g_sql = "SELECT sko02,skl02,sko03,sko04,sko05",
                " FROM sko_file,skl_file",   
                " WHERE sko01 ='",g_skn.skn01,"' ",
                "  AND skl01= sko02 "    #and ",p_wc2 CLIPPED,
 #              " ORDER BY 1,2 "
    IF NOT cl_null(p_wc2) THEN                                                   
       LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED                             
    END IF                                                                       
    LET g_sql=g_sql CLIPPED," ORDER BY 1,2 "            
    DISPLAY g_sql
 
    PREPARE i004_pb FROM g_sql
    DECLARE sko_cs                       #CURSOR
        CURSOR FOR i004_pb
 
    CALL g_sko.clear()
    LET g_cnt = 1
 
    FOREACH sko_cs INTO g_sko[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
#     SELECT skl02 INTO g_sko[g_cnt].skl02
#       FROM skl_file 
#      WHERE skl01=g_sko[g_cnt].sko02  
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
	      EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sko.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
 
#FUNCTION i004_copy()
#DEFINE
#    l_newno         LIKE skn_file.skn01,
#    l_newdate       LIKE skn_file.skn02,
#    l_n             LIKE type_file.num5,
#    l_oldno         LIKE skn_file.skn01
#DEFINE   li_result   LIKE type_file.num5
#
#    IF s_shut(0) THEN RETURN END IF
#    IF g_skn.skn01 IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#    END IF
#    IF g_skn.skn02 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
#    LET g_before_input_done = FALSE
#    CALL i004_set_entry('a')
#    LET g_before_input_done = TRUE
#    LET l_newdate= NULL                                                                                                             
#                                                                                                                                    
#    INPUT l_newno,l_newdate FROM skn01,skn02                                                                                        
#        BEFORE INPUT                                                                                                                
#           CALL cl_set_docno_format("skn01")  
#
#
#        AFTER FIELD skn01
#           IF NOT cl_null(l_newno) THEN
#              SELECT COUNT(*) INTO l_n FROM skn_file
#               WHERE skn01 = l_newno
#                  IF l_n > 0 THEN
#                     CALL cl_err(l_newno,'-239',1)
#                     NEXT FIELD skn01
#                  END IF
#           END IF
#
#        AFTER FIELD skn01                                                
#          IF l_newno[1,g_doc_len] IS NULL THEN                             
#              NEXT FIELD skn01                                           
#          END IF                                                          
#          CALL s_check_no("aim",l_newno,"","H","skn_file","skn01","")    
#              RETURNING li_result,l_newno                             
#           DISPLAY l_newno TO skn01                                       
#           IF (NOT li_result) THEN                                       
#               NEXT FIELD skn01                                           
#           END IF                                                                                                                   
#       ON ACTION CONTROLP                                                 
#          CASE                                                           
#            WHEN INFIELD(skn01) #工單單號                                 
#                 LET g_t1 = s_get_doc_no(l_newno)                       
#                 CALL q_smy(FALSE,FALSE,g_t1,'AIM','H') RETURNING g_t1   
#                 LET l_newno=g_t1                                       
#                 DISPLAY l_newno TO skn01  
#                 NEXT FIELD skn01                                        
#         END CASE            
# 
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE INPUT
# 
#      ON ACTION about          
#         CALL cl_about()       
# 
#      ON ACTION help           
#         CALL cl_show_help()   
# 
#      ON ACTION controlg       
#         CALL cl_cmdask()      
# 
# 
#    END INPUT
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       DISPLAY BY NAME g_skn.skn01
#       ROLLBACK WORK
#       RETURN
#    END IF
#
#    DROP TABLE y
#
#    SELECT * FROM skn_file         #單頭復制秶
#        WHERE skn01=g_skn.skn01
#        INTO TEMP y
#
#    UPDATE y
#        SET skn01=l_newno,    #新的鍵值
#            sknuser=g_user,   #資料所有者
#            skngrup=g_grup,   #資料所有者所屬群垀扽�
#            sknmodu=NULL,     #資料修改日期
#            skndate=g_today,  #資料建立日期
#            sknacti='Y'       #有效資料
#
#    INSERT INTO skn_file
#        SELECT * FROM y
#    IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","skn_file","","",SQLCA.sqlcode,"","",1)  
#        ROLLBACK WORK
#        RETURN
#    ELSE
#        COMMIT WORK
#    END IF
#
#    DROP TABLE x
#
#    SELECT * FROM sko_file         #單身復制秶
#        WHERE sko01=g_skn.skn01
#        INTO TEMP x
#    IF SQLCA.sqlcode THEN
##        CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  
#        CALL cl_err("",SQLCA.sqlcode,1)  
#        RETURN
#    END IF
#
#    UPDATE x
#        SET sko01=l_newno
#
#    INSERT INTO sko_file
#        SELECT * FROM x
#    IF SQLCA.sqlcode THEN
#        ROLLBACK WORK 
##        CALL cl_err3("ins","sko_file","","",SQLCA.sqlcode,"","",1)  
#        CALL cl_err('',SQLCA.sqlcode,1)  
#        RETURN
#    ELSE
#        COMMIT WORK 
#    END IF
#    LET g_cnt=SQLCA.SQLERRD[3]
#    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
# 
#     LET l_oldno = g_skn.skn01
#     SELECT skn_file.* INTO g_skn.* FROM skn_file WHERE skn01 = l_newno
#     CALL i004_u()
#     CALL i004_b()
#     SELECT skn_file.* INTO g_skn.* FROM skn_file WHERE skn01 = l_oldno
#     CALL i004_show()
#
#END FUNCTION
 
 
FUNCTION i004_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("skn01,",TRUE)
  END IF
 
END FUNCTION
FUNCTION i004_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
 
 
  CALL cl_set_comp_entry("skn02",FALSE)
 
  IF p_cmd='u' AND g_chkey='N' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("skn01",FALSE)
  END IF
   
END FUNCTION
 
FUNCTION i004_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd='a' AND ( NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("",TRUE)
  END IF
END FUNCTION
 
 
FUNCTION i004_y()
   IF g_skn.skn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_skn.skn02 !='N' THEN
      CALL cl_err('','9023',0)      
      RETURN
   END IF
   IF g_skn.sknacti = 'N' THEN
      CALL cl_err('','9028',0)      
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ----------------- add ------------------ begin
   SELECT * INTO g_skn.* FROM skn_file WHERE skn01 = g_skn.skn01
   IF g_skn.skn02 !='N' THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_skn.sknacti = 'N' THEN
      CALL cl_err('','9028',0)
      RETURN
   END IF
#CHI-C30107 ------------- add ---------------- end
   BEGIN WORK
 
   OPEN i004_cl USING g_skn.skn01
   IF STATUS THEN
       CALL cl_err("OPEN i004_cl:", STATUS, 1)
       CLOSE i004_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i004_cl INTO g_skn.*               #對DB鎖定
    LET g_skn.skn02 = 'Y'
    UPDATE skn_file SET skn02 = g_skn.skn02
                     WHERE skn01 = g_skn.skn01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","skn_file",g_skn.skn01,"",SQLCA.sqlcode,"","",0)
       ROLLBACK WORK
       RETURN
    END IF
    CLOSE i004_cl
    COMMIT WORK
    DISPLAY BY NAME g_skn.skn02
END FUNCTION 
 
FUNCTION i004_z()
   IF g_skn.skn01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_skn.skn02="N" OR g_skn.sknacti="N" THEN
      CALL cl_err("",'atm-365',1)
   ELSE
      IF cl_confirm('aap-224') THEN
         BEGIN WORK
         UPDATE skn_file SET skn02="N"
                         WHERE skn01=g_skn.skn01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","skn_file",g_skn.skn01,"",SQLCA.sqlcode,"","skn02",1)
         ROLLBACK WORK
      ELSE
         COMMIT WORK
         LET g_skn.skn02="N"
         DISPLAY BY NAME g_skn.skn02
      END IF
      END IF
   END IF
END FUNCTION 
 
FUNCTION i004_field_pic()
   DEFINE l_flag   LIKE type_file.chr1
 
   CASE
     #無效
     WHEN g_skn.sknacti = 'N' 
        CALL cl_set_field_pic("","","","","","N")
     #審核
     WHEN g_skn.skn02 = 'Y' 
        CALL cl_set_field_pic("Y","","","","","")
     OTHERWISE
        CALL cl_set_field_pic("","","","","","")
   END CASE
END FUNCTION
 
FUNCTION i004_out()
  DEFINE l_cmd  LIKE type_file.chr1000   
 
     IF cl_null(g_wc) AND NOT cl_null(g_skn01) THEN                         
        LET g_wc = " skn01 = '",g_skn01,"'"                                 
     END IF                                                                     
     IF g_wc IS NULL THEN                                                       
        CALL cl_err('','9057',0)                                                
        RETURN                                                                  
     END IF                                                                     
     LET l_cmd = 'p_query "aski004" "',g_wc CLIPPED,'"'                         
     CALL cl_cmdrun(l_cmd)      
END FUNCTION
#No.FUN-830121
#No.FUN-840178 No.FUN-870117 FUN-8B0023 

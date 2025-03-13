# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: p_gr_history.4gl
# Descriptions...: GR歷史報表留存設定作業
# Date & Author..: 12/02/07 By downheal      #No.FUN-C10009 
# Modify.........: No.FUN-C10009 12/02/07 By downheal 新增歷史報表留存設定作業功能,可維護gdy_file資料
# Modify.........: No.FUN-C40049 12/04/19 By downheal 新增單身欄位留存份數(gdy05),欄位名稱多語言改由p_ze維護
# Modify.........: No.FUN-C70026 12/07/06 By downheal 修正新增無反映問題
# Modify.........: No:FUN-D30034 13/04/17 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_gdy          RECORD      #No.FUN-C10009 單頭資料
            gdy01          LIKE gdy_file.gdy01,   #程式代碼
            gaz03          LIKE gaz_file.gaz03,   #程式名稱
            gdy02          LIKE gdy_file.gdy02    #留存類別
                           END RECORD,
                        
         g_gdy_t        RECORD                    #儲存舊值
            gdy01          LIKE gdy_file.gdy01,   #程式代碼
            gaz03          LIKE gaz_file.gaz03,   #程式名稱
            gdy02          LIKE gdy_file.gdy02    #留存類別
                           END RECORD,
                        
         g_gdy_lock       RECORD LIKE gdy_file.*
       
DEFINE   g_gdy1            DYNAMIC ARRAY of RECORD   #儲存單身資料         
            gdy03          LIKE gdy_file.gdy03,      #全部/權限類別/使用者 
             zw02          LIKE  zw_file.zw02,       #說明
            gdy05          LIKE gdy_file.gdy05,      #留存份數  #FUN-40049 add          
            gdy04          LIKE gdy_file.gdy04       #有效與否
            END RECORD
            
DEFINE   g_gdy1_t          RECORD                    #單身舊值
            gdy03          LIKE gdy_file.gdy03,
             zw02          LIKE  zw_file.zw02,
            gdy05          LIKE gdy_file.gdy05,      #留存份數  #FUN-40049 add
            gdy04          LIKE gdy_file.gdy04
            END RECORD

DEFINE   g_gdy_tmp         DYNAMIC ARRAY of RECORD   #儲存整批產生回傳之資料         
            gdy03          LIKE gdy_file.gdy03,      #權限類別/使用者
             zw02          LIKE  zw_file.zw02        #說明
            END RECORD
            
DEFINE g_cnt            LIKE type_file.num10,
       g_cnt2           LIKE type_file.num10,
       g_wc             STRING,
       g_sql            STRING,
       g_ss             LIKE type_file.chr1,     #決定後續步驟
       g_rec_b          LIKE type_file.num5,     #單身筆數
       l_ac             LIKE type_file.num5,     #目前處理的ARRAY CNT
       l_q_gdy03_cover  STRING,                  #從q_gdy03傳回之是否整批覆蓋參數  
       l_cover          STRING                   #是否覆蓋：(Y/N)
DEFINE l_title          STRING                   #欄位名稱改抓p_ze FUN-C40049         
DEFINE g_msg               STRING
DEFINE g_forupd_sql        STRING
DEFINE g_before_input_done LIKE type_file.num5
DEFINE g_row_count         LIKE type_file.num10
DEFINE g_curs_index        LIKE type_file.num10
DEFINE g_jump              LIKE type_file.num10
DEFINE g_no_ask            LIKE type_file.num5
DEFINE g_n                 LIKE type_file.num10
DEFINE g_gdy01_zz          LIKE type_file.chr1
DEFINE g_count             LIKE type_file.num10
DEFINE g_i                 LIKE type_file.num10
DEFINE g_zz01              LIKE zz_file.zz01      #程式代號
DEFINE g_cmd               STRING
DEFINE g_re                LIKE type_file.num5    #檢查資料重複用
 
MAIN
   OPTIONS                                        #改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET g_gdy_t.gdy01 = NULL
 
   OPEN WINDOW p_gr_history_w WITH FORM "azz/42f/p_gr_history"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init() 
   LET g_forupd_sql = " SELECT * from gdy_file ",
                      " WHERE gdy01 = ? AND gdy02 = ? ",
                      " FOR UPDATE "
   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gr_history_cl CURSOR FROM g_forupd_sql
   CALL p_gr_history_menu()
   CLOSE WINDOW p_gr_history_w                  # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p_gr_history_curs(l_flag)              # QBE 查詢資料
   DEFINE  l_flag   LIKE type_file.chr1
   DEFINE  l_si     STRING
   DEFINE  l_j      LIKE type_file.num10
   
   CLEAR FORM                             # 清除畫面
   CALL g_gdy1.clear()
   CALL cl_set_head_visible("","YES")

   IF l_flag = "1" THEN
      CONSTRUCT g_wc ON gdy01,gdy02
                   FROM gdy01,gdy02
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION controlp
         CASE
             WHEN INFIELD(gdy01)
               CALL cl_init_qry_var()            
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang               
               LET g_qryparam.default1 = g_gdy.gdy01
               CALL cl_create_qry() RETURNING g_gdy.gdy01
               DISPLAY g_gdy.gdy01 TO gdy01
               CALL p_gr_history_gaz03()
               NEXT FIELD gdy02
            OTHERWISE
               EXIT CASE
         END CASE  
      END CONSTRUCT

      IF INT_FLAG THEN
         RETURN
      END IF
   END IF

   LET g_sql= " SELECT gdy01, '', gdy02 ",
              " FROM gdy_file ",
              " WHERE ", g_wc CLIPPED,
              #" ORDER BY gdy01, gdy02 ",
              " GROUP BY gdy01, gdy02 "

   PREPARE p_gr_history_prepare FROM g_sql
   DECLARE p_gr_history_b_curs
      SCROLL CURSOR WITH HOLD FOR p_gr_history_prepare
 
END FUNCTION
 
FUNCTION p_gr_history_count()
 
   LET g_sql= " SELECT gdy01, '', gdy02 ",
              " FROM gdy_file ",
              " WHERE ", g_wc CLIPPED,
              #" ORDER BY gdy01, gdy02 ",
              " GROUP BY gdy01, gdy02 "
 
   PREPARE p_gr_history_precount FROM g_sql
   DECLARE p_gr_history_count CURSOR FOR p_gr_history_precount
   
   LET g_cnt=1
   LET g_rec_b=0
   FOREACH p_gr_history_count
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET g_rec_b = g_rec_b - 1
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   LET g_row_count=g_rec_b
END FUNCTION
 
FUNCTION p_gr_history_menu()

   WHILE TRUE
      CALL p_gr_history_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL p_gr_history_a()
            END IF
 
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL p_gr_history_copy()
            END IF
 
         WHEN "delete"                          # R.取消
            IF cl_chk_act_auth() THEN
               CALL p_gr_history_r()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL p_gr_history_q()
            ELSE
               LET g_curs_index = 0
            END IF
 
         WHEN "detail"                          # B.單身
            IF cl_chk_act_auth() THEN
               CALL p_gr_history_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "gr_history_create"
            IF cl_chk_act_auth() THEN
               CALL p_gr_history_create_all()     
            END IF

         WHEN "help"                            # H.求助
            CALL cl_show_help()
 
         WHEN "about"
            CALL cl_about()
 
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
 
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
        
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION p_gr_history_a()                       # Add  輸入
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_gdy.* TO NULL                   # 清空放棄時殘留的資料
   INITIALIZE g_gdy_t.* TO NULL   
   CALL g_gdy1.clear()
   #CALL g_gdy2.clear()
   #CALL g_gdy3.clear()
   CALL cl_opmsg('a')
   
   WHILE TRUE
      CALL p_gr_history_i("a")                  # 輸入單頭, 新增資料

      IF INT_FLAG THEN                          # 使用者不玩了
        CLEAR FORM                              # 清單頭
        LET g_gdy.gdy01 = NULL
        LET g_gdy.gaz03 = NULL
        LET g_gdy.gdy02 = NULL
        DISPLAY g_gdy.gdy01, g_gdy.gaz03, g_gdy.gdy02 TO gdy01, gaz03, gdy02
        LET INT_FLAG = 0
        CALL cl_err('',9001,0)
        EXIT WHILE
      END IF
      
      LET g_rec_b = 0   
 
      CALL p_gr_history_b_fill('1=1')          # 單身
      CALL p_gr_history_b()                    # 輸入單身    
      LET g_gdy_t.* = g_gdy.*
      
      #後四行程式碼解決先查詢後新增，所衍生的上下筆切換問題
      LET g_row_count = 1
      LET g_curs_index = 1
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_row_count TO FORMONLY.cnt
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION p_gr_history_i(p_cmd)                  # 處理INPUT
   DEFINE   p_cmd      LIKE type_file.chr1      # a:輸入 u:更改
   
   LET g_ss = 'Y'
   CALL cl_set_head_visible("","YES")

   INPUT g_gdy.gdy01,g_gdy.gdy02 WITHOUT DEFAULTS 
    FROM gdy01, gdy02
    
      #ON CHANGE gdy01
      AFTER FIELD gdy01
         SELECT count(*) zz01 INTO g_re FROM zz_file WHERE zz01 = g_gdy.gdy01
         IF (g_re == 0) THEN
            CALL cl_err('','azz1162',0)
            LET g_gdy.gdy01 = NULL
            LET g_gdy.gaz03 = NULL            
            DISPLAY g_gdy.gdy01, g_gdy.gaz03 TO gdy01, gaz03            
            NEXT FIELD gdy01
         ELSE
            CALL p_gr_history_gaz03()         #抓取程式名稱並顯示
            DISPLAY g_gdy.gdy01 TO gdy01         
         END IF            
         
      ON CHANGE gdy02
         #根據下拉選單(gdy02)的選項，決定單身欄位名稱
         CASE g_gdy.gdy02    #單身只有一個卻有三個Table可能會顯示,無法透過系統參數設定多語
         WHEN "1"            #1:全部
         #FUN-C40049 --START--
            LET l_title = cl_getmsg('azz1220',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("gdy03",l_title)  #gdy03欄位名稱
            LET l_title = cl_getmsg('azz1224',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("zw02", l_title)  #zw02欄位名稱   
         #FUN-C40049 ---END--- 
         #FUN-C40049 mark --START--                 
            #CASE g_lang      
               #WHEN "0"      #繁體中文
               #WHEN "1"      #英文
               #LET l_title = cl_getmsg('azz1220',g_lang)
               #CALL cl_set_comp_att_text("gdy03",l_title)
               #LET l_title = cl_getmsg('azz1224',g_lang)
               #CALL cl_set_comp_att_text("zw02", l_title)
               #WHEN "2"      #簡體中文
               #LET l_title = cl_getmsg('azz1220',g_lang)
               #CALL cl_set_comp_att_text("gdy03",l_title)
               #LET l_title = cl_getmsg('azz1224',g_lang)
               #CALL cl_set_comp_att_text("zw02", l_title)
               #OTHERWISE
               #LET l_title = cl_getmsg('azz1220',g_lang)
               #CALL cl_set_comp_att_text("gdy03",l_title)
               #LET l_title = cl_getmsg('azz1224',g_lang)
               #CALL cl_set_comp_att_text("zw02", l_title)
               #END CASE
         #FUN-C40049 mark ---END---
         
         WHEN "2"            #權限類別
         #FUN-C40049 --START--         
            LET l_title = cl_getmsg('azz1222',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("gdy03",l_title)  #gdy03欄位名稱
            LET l_title = cl_getmsg('azz1225',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("zw02", l_title)  #zw02欄位名稱
         #FUN-C40049 ---END--- 
         #FUN-C40049 mark --START--               
            #CASE g_lang
               #WHEN "0"         
               #CALL cl_set_comp_att_text("gdy03","權限類別代號")
               #CALL cl_set_comp_att_text("zw02", "權限類別說明")
               #WHEN "1"
               #CALL cl_set_comp_att_text("gdy03","Permission Category")
               #CALL cl_set_comp_att_text("zw02", "Description")
               #WHEN "2"
               #CALL cl_set_comp_att_text("gdy03","权限类别代号")
               #CALL cl_set_comp_att_text("zw02", "权限类别说明")
               #OTHERWISE
               #CALL cl_set_comp_att_text("gdy03","Permission Category")
               #CALL cl_set_comp_att_text("zw02", "Description")           
            #END CASE
         #FUN-C40049 mark ---END---            
               
         WHEN "3"            #使用者
         #FUN-C40049 --START--         
            LET l_title = cl_getmsg('azz1223',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("gdy03",l_title)  #gdy03欄位名稱
            LET l_title = cl_getmsg('azz1221',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("zw02", l_title)  #zw02欄位名稱       
         #FUN-C40049 ---END--- 
         #FUN-C40049 mark --START--               
            #CASE g_lang
               #WHEN "0"        
               #CALL cl_set_comp_att_text("gdy03","使用者編號")
               #CALL cl_set_comp_att_text("zw02", "使用者名稱")
               #WHEN "1"
               #CALL cl_set_comp_att_text("gdy03","User")
               #CALL cl_set_comp_att_text("zw02", "User Name")
               #WHEN "2"
               #CALL cl_set_comp_att_text("gdy03","使用者编号")
               #CALL cl_set_comp_att_text("zw02", "使用者名称")
               #OTHERWISE
               #CALL cl_set_comp_att_text("gdy03","User")
               #CALL cl_set_comp_att_text("zw02", "User Name")            
            #END CASE 
         #FUN-C40049 mark ---END---     
         END CASE    
         
     #AFTER FIELD gdy01
     #IF NOT cl_null(g_gdy.gdy01) THEN
        #IF g_gdy.gdy01 <> g_gdy_t.gdy01 OR cl_null(g_gdy_t.gdy01) THEN
           #LET g_cnt = 0
           #SELECT COUNT(*) INTO g_cnt FROM gdy_file
            #WHERE gdy01 = g_gdy.gdy01 
              #AND gdy02 = g_gdy.gdy02
           #IF g_cnt >  0 THEN
              #IF p_cmd = 'a' THEN
                 #LET g_ss = 'Y'
              #ELSE
                 #LET g_gdy.gdy01 = g_gdy_t.gdy01
                 #CALL cl_err('',-239,0)               
                 #NEXT FIELD gdy01
              #END IF
           #END IF
        #END IF
     #END IF
    
     AFTER FIELD gdy02
        IF NOT cl_null(g_gdy.gdy02) THEN
          #LET g_count = 0
          #SELECT COUNT(*) INTO g_count FROM gdy_file
          #WHERE gdy01 = g_gdy.gdy01 AND gdy02 = g_gdy.gdy02
          #IF g_count > 0 THEN
          #   CALL cl_err(" ",-239,1)   #已有重複資料
          #   NEXT FIELD gdy02
          #END IF
           IF g_gdy.gdy02 NOT MATCHES '[123]' THEN NEXT FIELD CURRENT END IF
        END IF   
 
      AFTER INPUT
         IF (g_gdy.gdy01 != g_gdy_t.gdy01) OR cl_null(g_gdy_t.gdy01) THEN
            SELECT COUNT(*) INTO g_cnt FROM gdy_file
            WHERE gdy01 = g_gdy.gdy01 AND gdy02 = g_gdy.gdy02
            IF g_cnt <= 0 THEN
               IF p_cmd = 'a' THEN
                  LET g_ss = 'Y'
               END IF
            ELSE
               IF p_cmd = 'u' THEN
                  LET g_gdy.gdy01 = g_gdy_t.gdy01
                  LET g_gdy.gdy02 = g_gdy_t.gdy02
                  DISPLAY g_gdy.gdy01 TO gdy01
               END IF
            END IF
         END IF

     ON ACTION controlp
         CASE
            WHEN INFIELD(gdy01)
               CALL cl_init_qry_var()            
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang               
               LET g_qryparam.default1 = g_gdy.gdy01
               CALL cl_create_qry() RETURNING g_gdy.gdy01
               DISPLAY g_gdy.gdy01 TO gdy01
               CALL p_gr_history_gaz03()
               NEXT FIELD gdy02
            OTHERWISE
               EXIT CASE
         END CASE
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION controlf
          CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
          CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
            
   END INPUT
END FUNCTION

FUNCTION p_gr_history_q()                       # Query 查詢
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   
   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_gdy.*,g_gdy_t.* TO NULL
   CALL g_gdy1.clear()
   #CALL g_gdy3.clear()
   #CALL g_gdy4.clear()
   DISPLAY '    ' TO FORMONLY.cnt
   CALL p_gr_history_curs("1")                   #取得單頭查詢條件

   IF INT_FLAG THEN                              #使用者不玩了
      CLEAR FORM
      INITIALIZE g_gdy.*, g_gdy_t.* TO NULL
      LET INT_FLAG = 0     
      RETURN
   END IF

   OPEN p_gr_history_b_curs                      #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gdy.gdy01,g_gdy.gaz03,g_gdy.gdy02 TO NULL
   ELSE
      CALL p_gr_history_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_gr_history_fetch('F')               #讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION p_gr_history_fetch(p_flag)             # 處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1         #處理方式
 
   MESSAGE ""

   CASE p_flag
      WHEN 'N' FETCH NEXT     p_gr_history_b_curs INTO g_gdy.*
      WHEN 'P' FETCH PREVIOUS p_gr_history_b_curs INTO g_gdy.*
      WHEN 'F' FETCH FIRST    p_gr_history_b_curs INTO g_gdy.*
      WHEN 'L' FETCH LAST     p_gr_history_b_curs INTO g_gdy.*
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
               LET INT_FLAG = FALSE
               RETURN
            END IF
         END IF
         FETCH ABSOLUTE g_jump p_gr_history_b_curs INTO g_gdy.*
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gdy.gdy01,SQLCA.sqlcode,0)
      INITIALIZE g_gdy.* TO NULL
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      CALL p_gr_history_show()
   END IF
END FUNCTION
 
FUNCTION p_gr_history_show()                    # 將資料顯示在畫面上
   CALL p_gr_history_gaz03()                    # 顯示程式名稱在gaz03
   LET g_gdy_t.* = g_gdy.*
   DISPLAY BY NAME g_gdy.*
   CALL p_gr_history_b_fill(g_wc)               # 單身資料顯示
END FUNCTION
 
FUNCTION p_gr_history_r()                       # 取消整筆 (刪除所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5,
            l_gdx   RECORD LIKE gdx_file.*

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gdy.gdy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   BEGIN WORK
   IF cl_delh(0,0) THEN
      DELETE FROM gdy_file
         WHERE gdy01 = g_gdy.gdy01 AND gdy02 = g_gdy.gdy02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gdy_file",g_gdy.gdy01,g_gdy.gdy02,SQLCA.sqlcode,"","BODY DELETE",0)
      ELSE
         CLEAR FORM      
         CALL g_gdy1.clear()
         #CALL g_gdy2.clear()
         #CALL g_gdy3.clear()         
         CALL p_gr_history_count()
         DISPLAY g_row_count TO FORMONLY.cnt

         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            COMMIT WORK
            RETURN
         END IF

         OPEN p_gr_history_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL p_gr_history_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL p_gr_history_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION p_gr_history_b()                       # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,         # 未取消的ARRAY CNT
            l_n             LIKE type_file.num5,         # 檢查重複用
            l_lock_sw       LIKE type_file.chr1,         # 單身鎖住否
            p_cmd           LIKE type_file.chr1,         # 處理狀態
            l_allow_insert  LIKE type_file.num5,
            l_allow_delete  LIKE type_file.num5
   DEFINE   k,i             LIKE type_file.num10
   DEFINE   l_gdy03         LIKE gdy_file.gdy03
   DEFINE   l_sql           STRING

   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
   
   IF cl_null(g_gdy.gdy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   LET g_forupd_sql= "SELECT gdy03, gdy04, gdy05",   #FUN-C40049 add
                    " FROM gdy_file",
                    " WHERE gdy01 = ? AND gdy02 = ? AND gdy03 = ?",   #01,02,03Key值
                    " FOR UPDATE"
                      
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_gr_history_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0

   IF (g_gdy.gdy02 = 1) OR (g_gdy.gdy02 = 2) OR (g_gdy.gdy02 = 3) THEN
   INPUT ARRAY g_gdy1 WITHOUT DEFAULTS FROM s_gdy.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE         
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_gdy1_t.* = g_gdy1[l_ac].*    #BACKUP
            OPEN p_gr_history_bcl USING g_gdy.gdy01,g_gdy.gdy02,g_gdy1_t.gdy03
            IF SQLCA.sqlcode THEN
               CALL cl_err("OPEN p_gr_history_bcl:", STATUS, 1)
               LET l_lock_sw = 'Y'
            ELSE
               FETCH p_gr_history_bcl INTO g_gdy1[l_ac].gdy03, g_gdy1[l_ac].gdy04,
                                           g_gdy1[l_ac].gdy05   #FUN-C40049 add
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gdy1_t.gdy03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gdy1[l_ac].* TO NULL
         LET g_gdy1_t.* = g_gdy1[l_ac].*
         CALL cl_show_fld_cont()
         CALL cl_set_comp_entry("gdy03",TRUE)
         LET g_gdy1[l_ac].gdy04 = 'Y'                 #將有效碼預設為勾選
         LET g_gdy1[l_ac].gdy05 = '0'                 #FUN-C40049
         DISPLAY g_gdy1[l_ac].gdy04 TO s_gdy.gdy04    #FUN-C70026 故意觸發after insert
         IF (g_gdy.gdy02 = 1) THEN                    #留存類別為全部(1)時
            LET g_gdy1[l_ac].gdy03 = 'ALL'            #將gdy03設定為ALL
            LET g_gdy1[l_ac].zw02  = ''            
            CALL cl_set_comp_entry("gdy03",FALSE)     #不允許gdy03欄位輸入
         ELSE
            CALL cl_set_comp_entry("gdy03",TRUE)   
         END IF
         NEXT FIELD gdy03
 
      AFTER INSERT
         IF INT_FLAG THEN                           # 使用者放棄輸入          
            CALL g_gdy1.clear()                     # 清單身資料
            CALL g_gdy_tmp.clear()
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CANCEL INSERT
         END IF

         INSERT INTO gdy_file(gdy01,gdy02,gdy03,gdy04,gdy05)   #FUN-C40049 add
         VALUES (g_gdy.gdy01,g_gdy.gdy02,g_gdy1[l_ac].gdy03,
                 g_gdy1[l_ac].gdy04,     g_gdy1[l_ac].gdy05)   #FUN-C40049 add
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_gdy.gdy01,SQLCA.sqlcode,0)
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         
      AFTER FIELD gdy03                        #check 序號是否重複
         IF NOT cl_null(g_gdy1[l_ac].gdy03) THEN
            IF (g_gdy1[l_ac].gdy03 <> g_gdy1_t.gdy03) OR g_gdy1_t.gdy03 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM gdy_file
                WHERE gdy01 = g_gdy.gdy01
                  AND gdy02 = g_gdy.gdy02
                  AND gdy03 = g_gdy1[l_ac].gdy03
               IF l_n > 0 THEN
                  CALL cl_err(g_gdy1[l_ac].gdy03,'-239',1)
                  LET g_gdy1[l_ac].gdy03 = g_gdy1_t.gdy03
                  NEXT FIELD CURRENT
               END IF
               CASE g_gdy.gdy02
                  WHEN '2'       #權限類別
                     LET l_gdy03 = NULL               
                     SELECT zw01 INTO l_gdy03 FROM zw_file WHERE g_gdy1[l_ac].gdy03 = zw01
                     IF cl_null(l_gdy03) THEN
                        #MESSAGE "查無此權限代號"
                        CALL cl_err(g_gdy1[l_ac].gdy03,'azz1226',1)
                        NEXT FIELD gdy03
                     ELSE
                        SELECT zw02 INTO g_gdy1[l_ac].zw02 FROM zw_file WHERE g_gdy1[l_ac].gdy03 = zw01
                        #DISPLAY g_gdy1[l_ac].zw02 TO zw02
                     END IF
                  WHEN '3'       #使用者代號                    
                     LET l_gdy03 = NULL
                     SELECT zx01 INTO l_gdy03 FROM zx_file WHERE g_gdy1[l_ac].gdy03 = zx01
                     IF cl_null(l_gdy03) THEN
                        #MESSAGE "查無此使用者代號"
                        CALL cl_err(g_gdy1[l_ac].gdy03,'aoo-001',1)
                        NEXT FIELD gdy03
                     ELSE
                        SELECT zx02 INTO g_gdy1[l_ac].zw02 FROM zx_file WHERE g_gdy1[l_ac].gdy03 = zx01
                        #DISPLAY g_gdy1[l_ac].zw02 TO zw02
                     END IF 
               END CASE
            END IF
         END IF

      BEFORE DELETE     #是否取消單身
         IF (NOT cl_null(g_gdy1_t.gdy03)) AND (NOT cl_null(g_gdy1_t.gdy04)) 
         AND(NOT cl_null(g_gdy1_t.gdy05)) THEN   #FUN-C40049 add
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM gdy_file WHERE gdy01 = g_gdy.gdy01 
                                   AND gdy02 = g_gdy.gdy02
                                   AND gdy03 = g_gdy1[l_ac].gdy03

            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","gdy_file",g_gdy1[l_ac].gdy03,g_gdy1[l_ac].gdy04,SQLCA.sqlcode,"","",0)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b = g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_gdy1[l_ac].* = g_gdy1_t.*
            CLOSE p_gr_history_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_gdy1[l_ac].gdy03,-263,1)
            LET g_gdy1[l_ac].* = g_gdy1_t.*
         ELSE
            UPDATE gdy_file
               SET gdy03 = g_gdy1[l_ac].gdy03,
                   gdy04 = g_gdy1[l_ac].gdy04,
                   gdy05 = g_gdy1[l_ac].gdy05   #FUN-C40049 add
             WHERE gdy01 = g_gdy.gdy01 AND gdy02 = g_gdy.gdy02
               AND gdy03 = g_gdy1_t.gdy03
               
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_gdy1[l_ac].gdy03,SQLCA.sqlcode,0)
               LET g_gdy1[l_ac].* = g_gdy1_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac             #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)             
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_gdy1[l_ac].* = g_gdy1_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_gdy1.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE p_gr_history_bcl
            ROLLBACK WORK
         END IF
         LET l_ac_t = l_ac             #FUN-D30034 add
         CLOSE p_gr_history_bcl
         COMMIT WORK

      ON ACTION CONTROLP
         CASE 
         WHEN INFIELD(gdy03)        
            CALL cl_init_qry_var()
            CASE g_gdy.gdy02
               WHEN '2'
               LET g_qryparam.form = "q_zw"      
               LET g_qryparam.default1 = g_gdy1[l_ac].gdy03
               CALL cl_create_qry() RETURNING g_gdy1[l_ac].gdy03
               DISPLAY g_gdy1[l_ac].gdy03 TO gdy03
               SELECT zw02 INTO g_gdy1[l_ac].zw02 FROM zw_file WHERE zw01=g_gdy1[l_ac].gdy03
               DISPLAY g_gdy1[l_ac].gdy03 TO gdy03
               WHEN '3'
               LET g_qryparam.form = "q_zx"      
               LET g_qryparam.default1 = g_gdy1[l_ac].gdy03
               CALL cl_create_qry() RETURNING g_gdy1[l_ac].gdy03
               DISPLAY g_gdy1[l_ac].gdy03 TO gdy03
               SELECT zx02 INTO g_gdy1[l_ac].zw02 FROM zx_file WHERE zx01=g_gdy1[l_ac].gdy03
               DISPLAY g_gdy1[l_ac].gdy03 TO gdy03                  
            END CASE         
         END CASE

    # ON ACTION gr_history_create   #整批產生按鈕
    #    LET g_action_choice="gr_history_create"
    #    CALL p_gr_history_create_all()     
    #    EXIT INPUT
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION controlf
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
   END INPUT
   END IF

   CLOSE p_gr_history_bcl
   COMMIT WORK
   
END FUNCTION
 
FUNCTION p_gr_history_b_fill(p_wc)                
   DEFINE   p_wc     STRING

   LET g_sql = "SELECT gdy03,'',gdy04, gdy05",  #FUN-C40049 add
              "   FROM gdy_file ",
              " WHERE gdy01 = '",g_gdy.gdy01 CLIPPED,"' ",
              "   AND gdy02 = '",g_gdy.gdy02 CLIPPED,"' ",
              "   AND ",p_wc CLIPPED
 
   PREPARE p_gr_history_prepare3 FROM g_sql
   DECLARE gdy_curs3 CURSOR FOR p_gr_history_prepare3
 
   LET g_rec_b = 0

   CASE g_gdy.gdy02     #根據下拉式選單選中的值改變單身欄位名稱敘述 
       WHEN "1"          #選擇1:全部 
         #FUN-C40049 --START--       
         LET l_title = cl_getmsg('azz1220',g_lang)   #改由p_ze維護欄位多語言名稱
         CALL cl_set_comp_att_text("gdy03",l_title)  #gdy03欄位名稱 
         LET l_title = cl_getmsg('azz1224',g_lang)   #改由p_ze內容維護
         CALL cl_set_comp_att_text("zw02", l_title)  #zw02欄位名稱       
         #FUN-C40049 ---END--- 
         #FUN-C40049 mark --START-- 
         #CASE g_lang    #單身只有一個,卻有需顯示三種不同Table內容,無法透過系統參數設定多語系,故由程式自行維護
            #WHEN "0"    #報表程式語系為繁體中文
            #CALL cl_set_comp_att_text("gdy03","全部類別")
            #CALL cl_set_comp_att_text("zw02", "說明")
            #WHEN "1"    #報表程式語系為英文
            #CALL cl_set_comp_att_text("gdy03","ALL")
            #CALL cl_set_comp_att_text("zw02", "Discription")
            #WHEN "2"    #報表程式語系為簡體中文
            #CALL cl_set_comp_att_text("gdy03","全部类别")
            #CALL cl_set_comp_att_text("zw02", "说明")
            #OTHERWISE
            #CALL cl_set_comp_att_text("gdy03","ALL")
            #CALL cl_set_comp_att_text("zw02", "Discription")
            #END CASE
         #FUN-C40049 mark ---END---
         
      WHEN "2"          #選擇2:權限
         #FUN-C40049 --START--       
         LET l_title = cl_getmsg('azz1222',g_lang)   #改由p_ze內容維護欄位多語言名稱
         CALL cl_set_comp_att_text("gdy03",l_title)  #gdy03欄位名稱 
         LET l_title = cl_getmsg('azz1225',g_lang)   #改由p_ze內容維護
         CALL cl_set_comp_att_text("zw02", l_title)  #zw02欄位名稱     
         #FUN-C40049 ---END--- 
         #FUN-C40049 mark --START--          
         #CASE g_lang   
            #WHEN "0"         
            #CALL cl_set_comp_att_text("gdy03","權限類別代號")
            #CALL cl_set_comp_att_text("zw02", "權限類別說明")
            #WHEN "1"
            #CALL cl_set_comp_att_text("gdy03","Permission Category")
            #CALL cl_set_comp_att_text("zw02", "Description")
            #WHEN "2"
            #CALL cl_set_comp_att_text("gdy03","权限类别代号")
            #CALL cl_set_comp_att_text("zw02", "权限类别说明")
            #OTHERWISE
            #CALL cl_set_comp_att_text("gdy03","Permission Category")
            #CALL cl_set_comp_att_text("zw02", "Description")           
         #END CASE
      #FUN-C40049 mark ---END---
      
      WHEN "3"          #選擇3:使用者
         #FUN-C40049 --START--       
            LET l_title = cl_getmsg('azz1223',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("gdy03",l_title)  #gdy03欄位名稱
            LET l_title = cl_getmsg('azz1221',g_lang)   #改由p_ze內容維護
            CALL cl_set_comp_att_text("zw02", l_title)  #zw02欄位名稱   
         #FUN-C40049 ---END--- 
         #FUN-C40049 mark --START--     
         #CASE g_lang
            #WHEN "0"           
            #CALL cl_set_comp_att_text("gdy03","使用者編號")
            #CALL cl_set_comp_att_text("zw02", "使用者名稱")
            #WHEN "1"
            #CALL cl_set_comp_att_text("gdy03","User")
            #CALL cl_set_comp_att_text("zw02", "User Name")
            #WHEN "2"
            #CALL cl_set_comp_att_text("gdy03","使用者编号")
            #CALL cl_set_comp_att_text("zw02", "使用者名称")
            #OTHERWISE
            #CALL cl_set_comp_att_text("gdy03","User")
            #CALL cl_set_comp_att_text("zw02", "User Name")            
         #END CASE
      #FUN-C40049 mark ---END---
      END CASE
    
    IF (g_gdy.gdy02 = '1') THEN
    CALL g_gdy1.clear()    
    LET g_cnt = 1    
       LET g_rec_b = g_rec_b + 1
       FOREACH gdy_curs3 INTO g_gdy1[g_cnt].gdy03, g_gdy1[g_cnt].zw02, 
                              g_gdy1[g_cnt].gdy04, g_gdy1[g_cnt].gdy05  #FUN-C40049
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          ELSE
             #SELECT gem02 INTO g_gdy1[g_cnt].zw02 FROM gem_file WHERE gem01=g_gdy1[g_cnt].gdy03
          END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
       END FOREACH 
       CALL g_gdy1.deleteElement(g_cnt)
    END IF

    IF (g_gdy.gdy02 = '2') THEN
    CALL g_gdy1.clear()    
    LET g_cnt = 1
    LET g_rec_b = g_rec_b + 1        
    FOREACH gdy_curs3 INTO g_gdy1[g_cnt].gdy03, g_gdy1[g_cnt].zw02,
                           g_gdy1[g_cnt].gdy04, g_gdy1[g_cnt].gdy05  #FUN-C40049
    IF SQLCA.sqlcode THEN
       CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
       EXIT FOREACH
    ELSE
       SELECT zw02 INTO g_gdy1[g_cnt].zw02 FROM zw_file WHERE zw01=g_gdy1[g_cnt].gdy03
    END IF
    LET g_cnt = g_cnt + 1
    IF g_cnt > g_max_rec THEN
       CALL cl_err('',9035,0)
       EXIT FOREACH
    END IF
    END FOREACH
    CALL g_gdy1.deleteElement(g_cnt)      
    END IF  

    IF (g_gdy.gdy02 = '3') THEN
    CALL g_gdy1.clear()      
    LET g_cnt = 1      
       LET g_rec_b = g_rec_b + 1       
       FOREACH gdy_curs3 INTO g_gdy1[g_cnt].gdy03, g_gdy1[g_cnt].zw02,
                              g_gdy1[g_cnt].gdy04, g_gdy1[g_cnt].gdy05
       LET g_rec_b = g_rec_b + 1
          IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
          ELSE
             SELECT zx02 INTO g_gdy1[g_cnt].zw02 FROM zx_file WHERE zx01=g_gdy1[g_cnt].gdy03
          END IF
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
       END FOREACH
       CALL g_gdy1.deleteElement(g_cnt)      
    END IF      
 
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

END FUNCTION
 
FUNCTION p_gr_history_bp(p_ud)
   DEFINE   p_ud     LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "  
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_comp_entry("gdy02",TRUE)
   CALL cl_navigator_setting(g_curs_index, g_row_count) 

      DISPLAY ARRAY g_gdy1 TO s_gdy.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL p_gr_history_gaz03()               #顯示程式名稱在gaz03
         IF (g_gdy.gdy02 = '1') THEN
            CALL cl_set_comp_entry("gdy03",FALSE)
         ELSE
            CALL cl_set_comp_entry("gdy03",TRUE)
         END IF
      
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL p_gr_history_b_fill(g_wc)
         EXIT DISPLAY      
    
      ON ACTION insert                           # A.輸入
            LET g_action_choice="insert"
         EXIT DISPLAY
    
      ON ACTION query                            # Q.查詢
            LET g_action_choice="query"
         EXIT DISPLAY
    
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
      ON ACTION delete                           # R.取消
         LET g_action_choice="delete"
         EXIT DISPLAY
    
      ON ACTION detail                           # B.單身
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY

      ON ACTION gr_history_create   #整批產生按鈕
         LET g_action_choice="gr_history_create"
         #EXIT INPUT
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
    
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL p_gr_history_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION previous                         # P.上筆
         CALL p_gr_history_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION jump                             # 指定筆
         CALL p_gr_history_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION next                             # N.下筆
         CALL p_gr_history_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION last                             # 最終筆
         CALL p_gr_history_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)
         END IF
         EXIT DISPLAY
 
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION about
         LET g_action_choice="about"
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
         
      END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   
END FUNCTION

FUNCTION p_gr_history_gaz03()     #根據gdy01的值去抓gaz03的資料，並顯示在gaz03欄位
   DEFINE l_ac   LIKE type_file.num5

   SELECT gaz03 INTO g_gdy.gaz03
      FROM gaz_file
      WHERE gaz01 = g_gdy.gdy01 AND gaz02 = g_lang
      
   DISPLAY g_gdy.gaz03 TO gaz03
   CASE WHEN SQLCA.SQLCODE = 100
      LET g_gdy.gdy01 = NULL
   END CASE
   
END FUNCTION

FUNCTION p_gr_history_copy()
   DEFINE   l_n        LIKE type_file.num5,
            l_newfe    LIKE gdy_file.gdy01,
            l_oldfe    LIKE gdy_file.gdy01,
            l_newfe2   LIKE gdy_file.gdy02,
            l_oldfe2   LIKE gdy_file.gdy02

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_gdy.gdy01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_gdy_t.gdy01 = g_gdy.gdy01
   
   INPUT l_newfe WITHOUT DEFAULTS
    FROM gdy01

      BEFORE INPUT
         DISPLAY BY NAME g_gdy.gdy01
         DISPLAY ' ' TO gaz03
         LET l_newfe = g_gdy.gdy01

      AFTER FIELD gdy01
         IF cl_null(l_newfe) THEN
            NEXT FIELD gdy01
         END IF
         LET g_cnt = 0
         SELECT COUNT(*) INTO g_cnt FROM zz_file WHERE zz01 = l_newfe 
         IF g_cnt = 0  THEN
             CALL cl_err(l_newfe,'azz-052',1)
             NEXT FIELD gdy01
         END IF
         
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF

         SELECT COUNT(*) INTO g_cnt FROM gdy_file
         WHERE gdy01 = l_newfe AND gdy02 = g_gdy.gdy02
         IF g_cnt > 0  THEN
            CALL cl_err(l_newfe,-239,1)
            NEXT FIELD gdy01
         END IF
 
     ON ACTION controlp
         CASE
            WHEN INFIELD(gdy01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_zz"
               LET g_qryparam.arg1 =  g_lang
               LET g_qryparam.default1= l_newfe
               CALL cl_create_qry() RETURNING l_newfe
               DISPLAY l_newfe TO gdy01
               NEXT FIELD gdy01

            OTHERWISE
               EXIT CASE
         END CASE
 
      ON ACTION controlg
         CALL cl_cmdask() 
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_gdy_t.gdy01 TO gdy01
      RETURN
   END IF
 
   DROP TABLE x
   
   SELECT * FROM gdy_file WHERE gdy01 = g_gdy_t.gdy01 AND gdy02 = g_gdy.gdy02
      INTO TEMP x

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gdy.gdy01,SQLCA.sqlcode,0)
      RETURN
   END IF

   UPDATE x SET gdy01 = l_newfe WHERE gdy02 = g_gdy.gdy02
   INSERT INTO gdy_file SELECT * FROM x
 
   IF SQLCA.SQLCODE THEN
      CALL cl_err('gdy:',SQLCA.SQLCODE,0)
      RETURN
   END IF
   LET g_cnt = SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
   
   LET l_oldfe = g_gdy.gdy01
   LET g_gdy.gdy01 = l_newfe
   CALL p_gr_history_b()
   
   LET g_wc = " gdy01 = '",l_newfe,"' AND gdy02 = '",g_gdy.gdy02,"' "
   CALL p_gr_history_curs("2")
   OPEN p_gr_history_b_curs
   IF SQLCA.SQLCODE THEN
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_gdy.gdy01,g_gdy.gaz03 TO NULL
   ELSE
      CALL p_gr_history_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p_gr_history_fetch('F')                 #讀出TEMP第一筆並顯示
   END IF
END FUNCTION

FUNCTION p_gr_history_create_all()
   DEFINE   l_delete   SMALLINT      #欲直接刪除已存在資料
   DEFINE   l_count    INTEGER
   DEFINE   l_i        INTEGER       #FOR迴圈變數用
   DEFINE   l_j        INTEGER       #FOR迴圈變數用
   DEFINE   l_same     SMALLINT      #標記資料庫與q_gdy03()回傳值是否有相同資料
   DEFINE   l_tmp_length   INTEGER   #計算整批產生回傳的資料筆數
   DEFINE   l_gdy_length   INTEGER   #計算原本單身(資料庫)有幾筆資料
   DEFINE   l_same_record  DYNAMIC ARRAY OF INTEGER   #儲存那幾筆資料與資料庫有重複
   DEFINE   l_gdy05        LIKE gdy_file.gdy05        #FUN-C40049 add

   IF cl_null(g_gdy.gdy01) THEN CALL cl_err('','arm-019',1) RETURN END IF #TEST
   IF cl_null(g_gdy.gdy02) THEN CALL cl_err('','arm-019',1) RETURN END IF #TEST

   SELECT count(*) INTO l_count FROM gdy_file    #查詢該單頭條件於資料庫是否已有資料      
      WHERE gdy01 = g_gdy.gdy01 AND gdy02 = g_gdy.gdy02
   IF l_count > 0 THEN    #該單頭條件於資料庫有資料                                  
      LET l_delete = 1    #顯示「刪除原有資料選項」，該選項於q_gdy03.4gl:整批產生程式
   ELSE    
      LET l_delete = 0    #隱藏「刪除原有資料選項」 
   END IF

   #初始化變數
   LET l_same = 0
   LET l_cover = ''
   LET l_tmp_length = 0
   LET l_gdy_length = 0   
   LET l_gdy05 = '0'      #預設初始值為'0', FUN-C40049 add
   CALL g_gdy_tmp.clear()
   
   IF (g_gdy.gdy02 = 2) OR (g_gdy.gdy02 = 3) THEN   #留存類別為權限或使用者
      #呼叫整批產生程式，回傳「資料」以及「是否刪除舊有資料選項」設定
      CALL q_gdy03(TRUE,TRUE,l_delete,g_gdy.gdy02) RETURNING g_gdy_tmp, l_cover

      IF NOT cl_null(g_gdy_tmp[1].gdy03) THEN 
         LET l_tmp_length = g_gdy_tmp.getLength()
         LET l_gdy_length = g_gdy1.getLength()
      
         #檢查陣列中是否存在空白資料
         IF cl_null(g_gdy1[1].gdy03) OR cl_null(g_gdy1[l_gdy_length].gdy03) THEN
            LET l_gdy_length = g_gdy1.getLength() - 1
         ELSE
            LET l_gdy_length = g_gdy1.getLength()
         END IF
         
         #將整批產生資料儲存至單身陣列,分三種情形：
         #1:選擇整批覆蓋, l_cover == 'Y'
         #2:不覆蓋且資料庫與整批產生勾選資料不重複, l_same == 0
         #3:不覆蓋但資料庫與整批產生勾選資料有重複, l_same == 1      
         IF l_cover = 'Y' OR l_cover = '' THEN
            CALL g_gdy1.clear()                  #刪除原有資料
            FOR l_i=1 TO g_gdy_tmp.getLength()   #整批覆蓋
               LET g_gdy1[l_i].gdy03 = g_gdy_tmp[l_i].gdy03
               LET g_gdy1[l_i].zw02 = g_gdy_tmp[l_i].zw02
               LET g_gdy1[l_i].gdy04 = 'Y'
               LET g_gdy1[l_i].gdy05 = '0'                       #FUN-C40049 add
            END FOR
         ELSE
            LET l_count = 0
            FOR l_j = 1 TO l_gdy_length
               FOR l_i=1 TO l_tmp_length
                  IF (g_gdy1[l_j].gdy03 == g_gdy_tmp[l_i].gdy03) THEN
                     LET l_same = 1
                     LET l_count = l_count + 1
                     LET l_same_record[l_count] = l_i
                  END IF
               END FOR
            END FOR
            
            #資料庫與回傳值完全無相同資料
            IF l_same = 0 THEN
               FOR l_i=1 TO l_tmp_length
                  LET g_gdy1[l_i+l_gdy_length].gdy03 = g_gdy_tmp[l_i].gdy03
                  LET g_gdy1[l_i+l_gdy_length].zw02 = g_gdy_tmp[l_i].zw02
                  LET g_gdy1[l_i+l_gdy_length].gdy04 = 'Y'
                  LET g_gdy1[l_i+l_gdy_length].gdy05 = '0'       #FUN-C40049 add
               END FOR
            END IF
            
            #資料庫與回傳值有相同資料
            IF l_same = 1 OR l_count != l_tmp_length THEN
               LET l_count = 0
               LET l_i = 0
               FOR l_count=1 TO l_tmp_length
                  IF l_count = l_same_record[l_count] OR cl_null(g_gdy_tmp[l_count].gdy03) THEN
                     
                  ELSE
                     LET l_i = l_i + 1
                     LET g_gdy1[l_gdy_length+l_i].gdy03 = g_gdy_tmp[l_count].gdy03
                     LET g_gdy1[l_gdy_length+l_i].zw02 = g_gdy_tmp[l_count].zw02
                     LET g_gdy1[l_gdy_length+l_i].gdy04 = 'Y'   
                     LET g_gdy1[l_gdy_length+l_i].gdy05 = '0'    #FUN-C40049 add
                  END IF   
               END FOR
            END IF   
         END IF

         LET g_rec_b = 0
         DELETE FROM gdy_file WHERE gdy01 = g_gdy.gdy01 AND gdy02 = g_gdy.gdy02
         IF SQLCA.SQLCODE THEN
            CALL cl_err("Delete gdy_file: ", SQLCA.SQLCODE, 0)
         END IF

         #將資料寫回資料庫，因為計算總筆數的方式不同，所以共分三種情形：
         #1:選擇整批覆蓋, l_cover = 'Y'
         #2:不覆蓋且資料庫與整批產生勾選資料不重複, l_same = 0
         #3:不覆蓋但資料庫與整批產生勾選資料有重複, l_same = 1
         IF l_cover = 'Y' THEN
            FOR l_j = 1 TO l_tmp_length
               IF NOT cl_null(g_gdy1[l_j].gdy03) THEN 
                  INSERT INTO gdy_file(gdy01,gdy02,gdy03,gdy04,gdy05)#gdy05 FUN-C40049 add
                  VALUES (g_gdy.gdy01,g_gdy.gdy02,g_gdy1[l_j].gdy03,
                                g_gdy1[l_j].gdy04,g_gdy1[l_j].gdy05) #gdy05 FUN-C40049 add
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_gdy.gdy01,SQLCA.sqlcode,0)
                     RETURN
                  ELSE
                     MESSAGE 'INSERT O.K'
                     LET g_rec_b = l_tmp_length
                     DISPLAY g_rec_b TO FORMONLY.cn2
                  END IF
               END IF   
            END FOR
         ELSE
            IF l_same = 0 THEN
               FOR l_j = 1 TO l_gdy_length + l_tmp_length
                  IF NOT cl_null(g_gdy1[l_j].gdy03) THEN 
                     INSERT INTO gdy_file(gdy01,gdy02,gdy03,gdy04,gdy05) #gdy05 FUN-C40049 add
                     VALUES (g_gdy.gdy01,g_gdy.gdy02,g_gdy1[l_j].gdy03,
                             g_gdy1[l_j].gdy04,g_gdy1[l_j].gdy05)        #gdy05 FUN-C40049 add
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_gdy.gdy01,SQLCA.sqlcode,0)
                        RETURN
                     ELSE
                        MESSAGE 'INSERT O.K'
                        LET g_rec_b = l_gdy_length + l_tmp_length
                        DISPLAY g_rec_b TO FORMONLY.cn2
                     END IF
                  END IF   
               END FOR
            END IF

            IF l_same = 1 THEN
               FOR l_j = 1 TO l_gdy_length+l_i
                  IF NOT cl_null(g_gdy1[l_j].gdy03) THEN 
                     INSERT INTO gdy_file(gdy01,gdy02,gdy03,gdy04,gdy05) #gdy05 FUN-C40049 add
                     VALUES (g_gdy.gdy01,g_gdy.gdy02,g_gdy1[l_j].gdy03,
                             g_gdy1[l_j].gdy04,g_gdy1[l_j].gdy05)        #gdy05 FUN-C40049 add
                     IF SQLCA.sqlcode THEN
                        CALL cl_err(g_gdy.gdy01,SQLCA.sqlcode,0)
                        RETURN
                     ELSE
                        MESSAGE 'INSERT O.K'
                        LET g_rec_b = l_gdy_length+l_i
                        DISPLAY g_rec_b TO FORMONLY.cn2
                     END IF
                  END IF   
               END FOR         
            END IF         
         END IF
      ELSE
         CALL cl_err('',9001,0)
      END IF
   END IF
END FUNCTION

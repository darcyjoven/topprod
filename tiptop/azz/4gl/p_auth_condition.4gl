# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: p_auth_condition.4gl
# Descriptions...: 權限過濾器條件設定
# Input parameter: 程式代碼, 對應主Table
# Return code....: 
# Date & Author..: 09/06/04 By tsai_yen
# Modify.........: No.FUN-960015 09/07/29 By tsai_yen
# Modify.........: No.TQC-990140 09/09/25 By tsai_yen 1.單身刪除後,p_auth_filter的條件代碼也要刪除 2.規格異動:增加欄位 gfh06(AND/OR)
# Modify.........: No.FUN-B50065 11/05/13 BY huangrh BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-960015
 
DEFINE 
    g_gfh           RECORD                        # (單頭)
        gfh01       LIKE gfh_file.gfh01,          #程式代碼                       
        gfh02       LIKE gfh_file.gfh02,          #過濾條件代碼                                     
        gfh03       LIKE gfh_file.gfh03,          #說明
        gfh04       LIKE gfh_file.gfh04,          #其他特殊條件
        gfh05       LIKE gfh_file.gfh05,          #最終過濾條件
        gfh06       LIKE gfh_file.gfh06           #AND/OR     #TQC-990140 add gfh06
                    END RECORD
 
DEFINE
    g_gfh_t         RECORD                        # (舊值)
        gfh01       LIKE gfh_file.gfh01,          #程式代碼                       
        gfh02       LIKE gfh_file.gfh02,          #過濾條件代碼                                     
        gfh03       LIKE gfh_file.gfh03,          #說明
        gfh04       LIKE gfh_file.gfh04,          #其他特殊條件
        gfh05       LIKE gfh_file.gfh05,          #最終過濾條件
        gfh06       LIKE gfh_file.gfh06           #AND/OR     #TQC-990140 add gfh06
                    END RECORD,
    g_gfh_o         RECORD                        # (舊值)
        gfh01       LIKE gfh_file.gfh01,          #程式代碼                       
        gfh02       LIKE gfh_file.gfh02,          #過濾條件代碼                                     
        gfh03       LIKE gfh_file.gfh03,          #說明
        gfh04       LIKE gfh_file.gfh04,          #其他特殊條件
        gfh05       LIKE gfh_file.gfh05,          #最終過濾條件
        gfh06       LIKE gfh_file.gfh06           #AND/OR     #TQC-990140 add gfh06
                    END RECORD,
 
    g_gfi           DYNAMIC ARRAY OF RECORD       # (單身)
        gfi03       LIKE gfi_file.gfi03,          #序號
        gfi04       LIKE gfi_file.gfi04,          #AND/OR條件連接
        gfi05       LIKE gfi_file.gfi05,          #欄位
        gaq03       LIKE gaq_file.gaq03,          #欄位名稱
        gfi06       LIKE gfi_file.gfi06,          #SQL比較運算子
        gfi07       LIKE gfi_file.gfi07           #比較值
                    END RECORD,
    g_gfi_t         RECORD                        # (舊值)
        gfi03       LIKE gfi_file.gfi03,          #序號
        gfi04       LIKE gfi_file.gfi04,          #AND/OR條件連接
        gfi05       LIKE gfi_file.gfi05,          #欄位
        gaq03       LIKE gaq_file.gaq03,          #欄位名稱
        gfi06       LIKE gfi_file.gfi06,          #SQL比較運算子
        gfi07       LIKE gfi_file.gfi07           #比較值
                    END RECORD,
    g_wc,g_wc2,g_sql    STRING,                  
    g_rec_b             LIKE type_file.num5,     #單身筆數            
    l_ac                LIKE type_file.num5      #目前處理的ARRAY CNT 
    
DEFINE g_argv1          LIKE gfg_file.gfg01      #外來參數，程式代碼
DEFINE g_argv2          STRING                   #外來參數，對應主Table
 
DEFINE g_gfh01          LIKE gfh_file.gfh01      #key值 程式代碼
DEFINE g_gfh01_t        LIKE gfh_file.gfh01      #key值(舊值)
DEFINE g_gfh02          LIKE gfh_file.gfh02      #key值 過濾條件代碼
DEFINE g_gfh02_t        LIKE gfh_file.gfh02      #key值(舊值)
DEFINE g_gfg02          STRING                   #對應主Table
DEFINE g_gfg02_t        STRING                   #對應主Table(舊值)
DEFINE g_memo           STRING                   #備註說明:過濾條件設定注意事項，記錄在p_ze
 
DEFINE p_row,p_col      LIKE type_file.num5       
DEFINE g_forupd_sql     STRING                   #SELECT ... FOR UPDATE SQL
DEFINE g_sql_tmp        STRING                   
DEFINE g_cnt            LIKE type_file.num10     
DEFINE g_cnt2           LIKE type_file.num5      
DEFINE g_msg            LIKE type_file.chr1000   #CHAR(72)
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_curs_index     LIKE type_file.num10     
DEFINE g_row_count      LIKE type_file.num10     
DEFINE g_jump           LIKE type_file.num10     
DEFINE mi_no_ask        LIKE type_file.num5      
DEFINE g_chk_default    INTEGER            #是否為第一次開窗，判斷是否帶出預設資料   1:預設  2.不是預設
DEFINE g_memo_ze        STRING             #說明
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   
   LET g_argv1 = ARG_VAL(1)                  #外來參數，程式代碼
   LET g_argv2 = ARG_VAL(2)                  #外來參數，對應主Table
 
   LET p_row = 3 LET p_col = 14
   OPEN WINDOW p_auth_condition_w AT p_row,p_col WITH FORM "azz/42f/p_auth_condition"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT gfh01,gfh02,gfh03,gfh04,gfh05,gfh06 ",   #TQC-990140 add gfh06
                       " FROM gfh_file WHERE gfh01 = ? AND gfh02 = ? ",
                        " FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_auth_condition_cl CURSOR FROM g_forupd_sql
 
   LET g_memo_ze = cl_getmsg('azz1008',g_lang)   #備註說明:過濾條件設定注意事項，記錄在p_ze
   DISPLAY g_memo_ze TO　memo_ze       #顯示備註說明
 
   #有外部參數
   LET g_chk_default = 0    #是否為第一次開窗，判斷是否帶出預設資料   1:預設  2.不是預設
   LET g_gfh01 = g_argv1    #程式代碼
   #LET g_gfh02 = g_argv3    #過濾條件代碼
   LET g_gfg02 = g_argv2    #對應主Table 
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN 
      LET g_chk_default = 1
      CALL p_auth_condition_q() 
   ELSE
      EXIT PROGRAM
   END IF
   
   CALL p_auth_condition_menu()
   CLOSE WINDOW p_auth_condition_w           #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time  
END MAIN
 
 
 
FUNCTION p_auth_condition_cs()
   CLEAR FORM                             #清除畫面
   CALL g_gfi.clear()
 
   DISPLAY g_memo_ze TO　memo_ze          #顯示備註說明
   
   IF g_chk_default THEN    #帶出外部參數的預設值
        MESSAGE g_argv1,",",g_argv2
        LET g_wc = "gfh01='",g_argv1,"'"
        LET g_wc2 = " 1=1"
        LET g_chk_default = 0    #預設值下次不再使用，避免無法查詢別的資料
   ELSE
        # 螢幕上取單頭條件
        CONSTRUCT g_wc ON gfh02,gfh03,gfh04,gfh06   #TQC-990140 add gfh06
        FROM gfh02,gfh03,gfh04,gfh06                #TQC-990140 add gfh06
 
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
        ON ACTION about         
         CALL cl_about()      
 
        ON ACTION controlg      
         CALL cl_cmdask()     
 
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
        LET g_wc = g_wc," AND gfh01='",g_argv1,"'"       #只能查屬於此程式代碼的
 
        IF INT_FLAG THEN RETURN END IF
 
        CALL g_gfi.clear()
 
        # 螢幕上取單身條件
        CONSTRUCT g_wc2 ON gfi04,gfi05,gaq03,gfi06,gfi07  
         FROM s_gfi[1].gfi04,s_gfi[1].gfi05,s_gfi[1].gaq03,s_gfi[1].gfi06,s_gfi[1].gfi07
 
        ON ACTION CONTROLP
 
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
    END IF
 
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT DISTINCT gfh01,gfh02 FROM gfh_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY gfh02"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT DISTINCT gfh01,gfh02 ",  
                   "  FROM gfh_file, gfi_file ",
                   "  WHERE gfh01 = gfi01",
                   "   AND gfh02 = gfi02",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY gfh02"
    END IF
 
    PREPARE p_auth_condition_prepare FROM g_sql
    DECLARE p_auth_condition_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR p_auth_condition_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(DISTINCT gfh02) FROM gfh_file WHERE ",g_wc CLIPPED   
    ELSE    
        LET g_sql="SELECT COUNT(DISTINCT gfh02) ",  
                   "  FROM gfh_file, gfi_file ",
                   "  WHERE gfh01 = gfi01",
                   "   AND gfh02 = gfi02",
                   "   AND ", g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE p_auth_condition_precount FROM g_sql
    DECLARE p_auth_condition_count CURSOR FOR p_auth_condition_precount
END FUNCTION
 
FUNCTION p_auth_condition_menu()
 
   WHILE TRUE
      CALL p_auth_condition_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL p_auth_condition_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL p_auth_condition_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL p_auth_condition_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL p_auth_condition_u()
            END IF
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL p_auth_condition_x()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL p_auth_condition_b()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION p_auth_condition_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_gfi.clear()
    
    DISPLAY g_memo_ze TO　memo_ze                  #顯示備註說明
    
    # 預設值及將數值類變數清成零
    INITIALIZE g_gfh.* LIKE gfh_file.*             #DEFAULT 設定
    LET g_gfh_o.* = g_gfh.*
    
    CALL cl_opmsg('a')
 
    WHILE TRUE
        CALL p_auth_condition_i("a")               #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            INITIALIZE g_gfh.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
        IF g_gfh.gfh02 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
 
        #新增單頭
        INSERT INTO gfh_file(gfh01,gfh02,gfh03,gfh04,gfh05,gfh06)                          #TQC-990140 add gfh06
            VALUES (g_argv1,g_gfh.gfh02,g_gfh.gfh03,g_gfh.gfh04,g_gfh.gfh05,g_gfh.gfh06)   #TQC-990140 add gfh06
        IF SQLCA.sqlcode THEN   			#置入資料庫不成功
            CALL cl_err3("ins","gfh_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",1)    
            CONTINUE WHILE
        END IF
 
        SELECT gfh02 INTO g_gfh02 
           FROM gfh_file
           WHERE gfh01 = g_gfh.gfh01 AND gfh02 = g_gfh.gfh02
 
        LET g_gfh02_t = g_gfh.gfh02        #保留舊值
        LET g_gfh_t.* = g_gfh.*
        CALL g_gfi.clear()
        LET g_rec_b=0
        CALL p_auth_condition_b()          #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION p_auth_condition_u()      #修改單頭
    IF s_shut(0) THEN RETURN END IF
    
    IF g_gfh.gfh02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    CALL cl_opmsg('u')
    LET g_gfh02_t = g_gfh.gfh02
    LET g_gfh_o.* = g_gfh.*
 
    BEGIN WORK
 
    OPEN p_auth_condition_cl USING g_argv1,g_gfh.gfh02
    IF STATUS THEN
       CALL cl_err("OPEN p_auth_condition_cl:", STATUS, 1)
       CLOSE p_auth_condition_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_auth_condition_cl INTO g_gfh.*            # 鎖住將被更改或取消的資料
    IF STATUS THEN
        CALL cl_err("FETCH p_auth_condition_cl:", STATUS, 1)      # 資料被他人LOCK
        CLOSE p_auth_condition_cl
        ROLLBACK WORK
        RETURN
    END IF
    CALL p_auth_condition_show()
    WHILE TRUE
        LET g_gfh02_t = g_gfh.gfh02
        CALL p_auth_condition_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_gfh.*=g_gfh_t.*
            CALL p_auth_condition_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        
        #單頭key值若改變，單身必須連動跟著改
        IF (g_gfh.gfh02 != g_gfh02_t)THEN      
            UPDATE gfi_file SET gfi02 = g_gfh.gfh02
                WHERE gfi01 = g_argv1 AND gfi02 = g_gfh02_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","gfi_file",g_argv1,g_gfh02_t,SQLCA.sqlcode,"","gfi",0)    
               CONTINUE WHILE  
            END IF
        END IF
        
        #改單頭
        UPDATE gfh_file
           SET gfh01 = g_gfh.gfh01,
               gfh02 = g_gfh.gfh02,
               gfh03 = g_gfh.gfh03,
               gfh04 = g_gfh.gfh04,
               gfh05 = g_gfh.gfh05,
               gfh06 = g_gfh.gfh06   #TQC-990140 add gfh06
            WHERE gfh01 = g_argv1 AND gfh02 = g_gfh02_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","gfh_file",g_argv1,g_gfh02_t,SQLCA.sqlcode,"","Update gfh",0)   
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    
    CLOSE p_auth_condition_cl
    COMMIT WORK
    
    IF cl_null(g_gfh.gfh04) THEN
       CALL p_auth_condition_b()          #輸入單身
    END IF
END FUNCTION
 
 
#處理INPUT
FUNCTION p_auth_condition_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,     #判斷必要欄位是否有輸入 
    p_cmd           LIKE type_file.chr1      #a:輸入 u:更改      
 
    INPUT g_gfh.gfh02,g_gfh.gfh03,g_gfh.gfh04,g_gfh.gfh06   #TQC-990140 add gfh06
          WITHOUT DEFAULTS
          FROM gfh02,gfh03,gfh04,gfh06                      #TQC-990140 add gfh06
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL p_auth_condition_set_entry(p_cmd)
            CALL p_auth_condition_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            ###TQC-990140 START ###  
            IF cl_null(g_gfh.gfh06) THEN   #其他特殊條件的ADN/OR
               LET g_gfh.gfh06 = "1"            
            END IF 
            DISPLAY BY NAME g_gfh.gfh06
            ###TQC-990140 END ###
 
        ON CHANGE gfh02                  # 過濾條件代碼
            IF NOT cl_null(g_gfh.gfh02) THEN
                  SELECT count(*) INTO g_cnt FROM gfh_file
                     WHERE gfh01 = g_argv1
                         AND gfh02 = g_gfh.gfh02
                   IF g_cnt > 0 THEN   #資料重複
                      CALL cl_err(g_argv1,-239,0)
                      LET g_gfh.gfh02 = g_gfh02_t
                      DISPLAY BY NAME g_gfh.gfh02 
                      NEXT FIELD gfh02
                   END IF
            END IF
 
        ON CHANGE gfh04
            CALL p_auth_condition_gfh05() RETURNING g_gfh.gfh05    #最終過濾條件 = 其他特殊條件+全部的條件設定
            
        
        ###TQC-990140 START ###
        ON CHANGE gfh06
            CALL p_auth_condition_gfh05() RETURNING g_gfh.gfh05    #最終過濾條件 = 其他特殊條件+全部的條件設定
        ###TQC-990140 END ###
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON ACTION CONTROLP
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION about
           CALL cl_about()
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION p_auth_condition_q()
 
    MESSAGE ""
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
 
    CLEAR FORM
    CALL g_gfi.clear()
 
    DISPLAY g_memo_ze TO　memo_ze       #顯示備註說明
    DISPLAY ' ' TO FORMONLY.cnt  
 
    CALL p_auth_condition_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN p_auth_condition_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_gfh.* TO NULL
    ELSE
        OPEN p_auth_condition_count
        FETCH p_auth_condition_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt  
        CALL p_auth_condition_fetch('F')                  # 讀出TEMP第一筆並顯示
        #沒資料就自動新增
        IF g_row_count = 0 THEN
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN 
              CALL p_auth_condition_a()
           END IF
        END IF
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION p_auth_condition_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,       #處理方式
    l_abso          LIKE type_file.num10       #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_auth_condition_cs INTO g_gfh.gfh01,g_gfh.gfh02 
        WHEN 'P' FETCH PREVIOUS p_auth_condition_cs INTO g_gfh.gfh01,g_gfh.gfh02
        WHEN 'F' FETCH FIRST    p_auth_condition_cs INTO g_gfh.gfh01,g_gfh.gfh02
        WHEN 'L' FETCH LAST     p_auth_condition_cs INTO g_gfh.gfh01,g_gfh.gfh02
        WHEN '/'
         IF (NOT mi_no_ask) THEN  
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
         FETCH ABSOLUTE g_jump p_auth_condition_cs INTO g_gfh.gfh01,g_gfh.gfh02
         LET mi_no_ask = FALSE     
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gfh.gfh01,SQLCA.sqlcode,0)
        INITIALIZE g_gfh.* TO NULL        
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
 
    SELECT gfh01,gfh02,gfh03,gfh04,gfh05,gfh06 INTO g_gfh.*    #TQC-990140 add gfh06
      FROM gfh_file
      WHERE gfh01 = g_argv1
          AND gfh02 = g_gfh.gfh02
          
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","gfh_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",1)   
        INITIALIZE g_gfh.* TO NULL
        RETURN
    END IF
    CALL p_auth_condition_show()
 
END FUNCTION
 
 
FUNCTION p_auth_condition_show()
    LET g_gfh_t.* = g_gfh.*                      #保存單頭舊值
    DISPLAY g_gfh.gfh02,g_gfh.gfh03,g_gfh.gfh04,g_gfh.gfh05,g_gfh.gfh06   #TQC-990140 add gfh06
       TO gfh02,gfh03,gfh04,gfh05,gfh06                                   #TQC-990140 add gfh06
    DISPLAY g_memo_ze TO　memo_ze                #顯示備註說明
    CALL p_auth_condition_b_fill(g_wc2)          #單身
    CALL cl_show_fld_cont()                  
END FUNCTION
 
 
FUNCTION p_auth_condition_x()  #切換有效無效碼
END FUNCTION
 
FUNCTION p_auth_condition_r()  #刪除一筆資料
    DEFINE l_cnt LIKE type_file.num5   #資料筆數
    DEFINE l_del LIKE type_file.chr1   #是否要刪除 Y/N 
    
    LET l_del = "N"
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gfh.gfh02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN p_auth_condition_cl USING g_gfh.gfh01,g_gfh.gfh02
    IF STATUS THEN
       CALL cl_err("OPEN p_auth_condition_cl:", STATUS, 1)
       CLOSE p_auth_condition_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH p_auth_condition_cl INTO g_gfh.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_gfh.gfh02,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE p_auth_condition_cl ROLLBACK WORK RETURN
    END IF
 
    CALL p_auth_condition_show()
 
    #檢查權限過濾器是否已經有使用此過濾條件代碼
    SELECT COUNT(gfj01) INTO l_cnt FROM gfj_file
       WHERE gfj01=g_gfh.gfh01 AND gfj05=g_gfh.gfh02       
    
    #確認視窗
    IF l_cnt > 0 THEN
       IF cl_confirm("azz1009") THEN
          LET l_del = "Y"
       END IF
    ELSE
       IF cl_delh(0,0) THEN
          LET l_del = "Y"
       END IF
    END IF
    
    #刪除
    IF l_del = "Y" THEN   
       DELETE FROM gfh_file WHERE gfh01=g_gfh.gfh01 AND gfh02=g_gfh.gfh02   #刪除單頭
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfi_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
          ROLLBACK WORK
          RETURN
       END IF
       
       DELETE FROM gfi_file WHERE gfi01=g_gfh.gfh01 AND gfi02=g_gfh.gfh02   #刪除單身
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfi_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
          ROLLBACK WORK
          RETURN
       END IF
       
       DELETE FROM gfj_file WHERE gfj01=g_gfh.gfh01 AND gfj05=g_gfh.gfh02   #刪除相關設定p_auth_filter單身
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfj_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
          ROLLBACK WORK
          RETURN
       END IF
       
       CLEAR FORM
       CALL g_gfi.clear()
       
       DISPLAY g_memo_ze TO　memo_ze       #顯示備註說明
       
       OPEN p_auth_condition_count
#FUN-B50065------begin---
       IF STATUS THEN
          CLOSE p_auth_condition_count
          CLOSE p_auth_condition_cl
          COMMIT WORK
          RETURN
       END IF
#FUN-B50065------end------
       FETCH p_auth_condition_count INTO g_row_count    #重新計算總筆數
#FUN-B50065------begin---
       IF STATUS OR cl_null(g_row_count) OR  g_row_count = 0 THEN
          CLOSE p_auth_condition_count
          CLOSE p_auth_condition_cl
          COMMIT WORK
          RETURN
       END IF
#FUN-B50065------end------

       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN p_auth_condition_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL p_auth_condition_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE    
          CALL p_auth_condition_fetch('/')
       END IF
    END IF
 
    
    CLOSE p_auth_condition_cl
    COMMIT WORK
END FUNCTION
 
#維護單身資料
FUNCTION p_auth_condition_b()
    DEFINE
            l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,    #檢查重複用        
            l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        
            p_cmd           LIKE type_file.chr1,    #處理狀態          
            l_length        LIKE type_file.num5,    #長度             
            l_allow_insert  LIKE type_file.num5,    #可新增否          
            l_allow_delete  LIKE type_file.num5     #可刪除否       
 
    DEFINE  li_count   LIKE type_file.num5    
    DEFINE  li_inx     LIKE type_file.num5    
    DEFINE  ls_str     STRING                 
    DEFINE  ls_sql     STRING                 
    DEFINE  li_cnt     LIKE type_file.num5  
    DEFINE  l_gfi      RECORD                       # (單身),用於改順序
               gfi03       LIKE gfi_file.gfi03,         #序號
               gfi04       LIKE gfi_file.gfi04,         #AND/OR條件連接
               gfi05       LIKE gfi_file.gfi05,         #欄位
               gaq03       LIKE gaq_file.gaq03,         #欄位名稱
               gfi06       LIKE gfi_file.gfi06,         #SQL比較運算子
               gfi07       LIKE gfi_file.gfi07          #比較值
               END RECORD
    DEFINE l_sort       LIKE type_file.chr1         #是否重新排序 N:否 Y:是
    DEFINE l_i          LIKE type_file.num5
 
    LET g_action_choice = ""
    IF g_gfh.gfh02 IS NULL THEN RETURN END IF
    SELECT * INTO g_gfh.* FROM gfh_file WHERE gfh01=g_argv1 AND gfh02=g_gfh.gfh02
 
    CALL cl_opmsg('b')
    
    LET g_forupd_sql = " SELECT gfi03,gfi04,gfi05,gaq03,gfi06,gfi07 ",
                         " FROM gfi_file ",
                         " LEFT JOIN gaq_file ",
                         "  ON gfi05 = gaq01 AND gaq02 = ?",
                         " WHERE gfi01= ? AND gfi02 = ? AND gfi03 = ? ",
                         " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_auth_condition_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gfi WITHOUT DEFAULTS FROM s_gfi.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
           LET g_before_input_done = TRUE
 
        BEFORE ROW
            LET p_cmd=""
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            
            #CALL cl_set_action_active("up,down", TRUE)
            #IF l_ac = 1 THEN
            #   CALL cl_set_action_active("up", FALSE)
            #END IF
            #IF l_ac >= g_rec_b THEN
            #   CALL cl_set_action_active("down", FALSE)
            #END IF
            
            BEGIN WORK
            OPEN p_auth_condition_cl USING g_argv1,g_gfh.gfh02
            IF STATUS THEN
               CALL cl_err("OPEN p_auth_condition_cl:", STATUS, 1)
               CLOSE p_auth_condition_cl
               ROLLBACK WORK
               RETURN
            ELSE 
               FETCH p_auth_condition_cl INTO g_gfh.*            # 鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gfh.gfh01,SQLCA.sqlcode,1)      # 資料被他人LOCK
                  CLOSE p_auth_condition_cl 
                  ROLLBACK WORK 
                  RETURN
               END IF
            END IF
 
             IF g_rec_b >= l_ac THEN 
               LET p_cmd='u'
               LET g_gfi_t.* = g_gfi[l_ac].*  #BACKUP
 
               OPEN p_auth_condition_bcl USING g_lang,g_argv1,g_gfh.gfh02,g_gfi_t.gfi03
               IF STATUS THEN
                  CALL cl_err("OPEN p_auth_condition_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH p_auth_condition_bcl INTO g_gfi[l_ac].*
                  IF STATUS THEN
                     CALL cl_err("FETCH p_auth_condition_bcl",SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
            END IF
            LET g_before_input_done = FALSE
            CALL cl_show_fld_cont()
            LET g_before_input_done = TRUE
 
          
        #ON ACTION up     #往上移動資料
        #   IF l_ac>1 THEN
        #      IF l_lock_sw = 'Y' THEN
        #         CALL cl_err(g_gfi[l_ac].gfi03,-263,1)
        #      ELSE
        #         LET l_gfi.* = g_gfi[l_ac-1].*
        #         LET g_gfi[l_ac-1].* = g_gfi[l_ac].*
        #         LET g_gfi[l_ac].* = l_gfi.*
        #         LET l_ac = l_ac - 1
        #         CALL fgl_set_arr_curr(l_ac)
        #         LET l_sort = "Y"   #是否重新排序
        #      END IF
        #   END IF
        #   IF l_ac = 1 THEN
        #      CALL cl_set_action_active("up", FALSE)
        #   END IF
        
        #ON ACTION down   #往下移動資料
        #   IF l_ac < g_rec_b THEN   
        #      IF NOt cl_null(g_gfi[l_ac+1].gfi03) THEN
        #         IF l_lock_sw = 'Y' THEN
        #            CALL cl_err(g_gfi[l_ac].gfi03,-263,1)
        #         ELSE
        #            LET l_gfi.* = g_gfi[l_ac+1].*
        #            LET g_gfi[l_ac+1].* = g_gfi[l_ac].*
        #            LET g_gfi[l_ac].* = l_gfi.*
        #            LET l_ac = l_ac + 1
        #            CALL fgl_set_arr_curr(l_ac)
        #            LET l_sort = "Y"   #是否重新排序
        #         END IF
        #      END IF
        #   END IF
        #   IF l_ac = g_rec_b THEN
        #      CALL cl_set_action_active("down", FALSE)
        #   END IF
         
            
        BEFORE FIELD gfi03                      #default 序號
           IF cl_null(g_gfi[l_ac].gfi03) THEN
              SELECT max(gfi03)+1
                 INTO g_gfi[l_ac].gfi03
                 FROM gfi_file
                 WHERE gfi01 = g_gfh.gfh01
                   AND gfi02 = g_gfh.gfh02                   
              IF cl_null(g_gfi[l_ac].gfi03) THEN
                 LET g_gfi[l_ac].gfi03 = 1
              END IF
           END IF
 
        AFTER FIELD gfi03                       #check 序號是否重複
           IF NOT cl_null(g_gfi[l_ac].gfi03) THEN
              IF cl_null(g_gfi_t.gfi03) THEN
                 LET g_gfi_t.gfi03 = 0
              END IF 
              IF g_gfi[l_ac].gfi03 != g_gfi_t.gfi03
                 OR g_gfi_t.gfi03 = 0 THEN
                 SELECT count(*)
                    INTO l_n
                    FROM gfi_file
                    WHERE gfi01 = g_gfh.gfh01
                      AND gfi02 = g_gfh.gfh02
                      AND gfi03 = g_gfi[l_ac].gfi03
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_gfi[l_ac].gfi03 = g_gfi_t.gfi03
                    NEXT FIELD gfi03
                 END IF
              END IF
           END IF
            
            
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gfi[l_ac].* TO NULL     
            LET g_gfi_t.* = g_gfi[l_ac].*         
            CALL cl_show_fld_cont()     
            NEXT FIELD gfi03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF 
            INSERT INTO gfi_file(gfi01,gfi02,gfi03,gfi04,gfi05,gfi06,gfi07)  
               VALUES(g_argv1,g_gfh.gfh02,g_gfi[l_ac].gfi03,g_gfi[l_ac].gfi04,g_gfi[l_ac].gfi05,g_gfi[l_ac].gfi06,g_gfi[l_ac].gfi07)           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","gfi_file",g_argv1,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               CALL p_auth_condition_gfh05() RETURNING g_gfh.gfh05    #最終過濾條件 = 其他特殊條件+全部的條件設定
               UPDATE gfh_file
                    SET gfh05=g_gfh.gfh05
                    WHERE gfh01=g_argv1
                        AND gfh02=g_gfh.gfh02
            END IF
    
    
        ON CHANGE gfi05
            IF NOT cl_null(g_gfi[l_ac].gfi05) THEN
                #檢查資料是否重複
                SELECT count(*) INTO l_n FROM gfi_file
                    WHERE gfi01 = g_argv1
                       AND gfi02 = g_gfh_t.gfh02
                       AND gfi03 = g_gfi[l_ac].gfi03
                IF l_n > 0 THEN
                        CALL cl_err('Field Repeat',-239,0)
                        LET g_gfi[l_ac].gfi05 = g_gfi_t.gfi05
                        NEXT FIELD gfi05
                END IF                
            END IF
                
        AFTER FIELD gfi05
            IF NOT cl_null(g_gfi[l_ac].gfi05) THEN
                LET li_count=0
                SELECT count(*) INTO li_count FROM gaq_file
                   WHERE gaq01=g_gfi[l_ac].gfi05 
 
                IF li_count=0 THEN    
                  CALL cl_err(g_gfi[l_ac].gfi05,"azz-116",1) 
                  NEXT FIELD gfi05
                ELSE
                  #查欄位名稱
                  SELECT gaq03 INTO g_gfi[l_ac].gaq03 FROM gaq_file
                      WHERE gaq01=g_gfi[l_ac].gfi05 AND gaq02=g_lang
                  DISPLAY g_gfi[l_ac].gaq03 TO gaq03
                END IF               
            END IF
 
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_gfi_t.gfi05) THEN
               IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                  CALL cl_err("", -263, 1) 
                  CANCEL DELETE 
               END IF 
               DELETE FROM gfi_file
                   WHERE gfi01 = g_argv1
                       AND gfi02 = g_gfh_t.gfh02 
                       AND gfi03 = g_gfi_t.gfi03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","gfi_file",g_argv1,g_gfh_t.gfh02,SQLCA.sqlcode,"","",0)    
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               CALL p_auth_condition_gfh05() RETURNING g_gfh.gfh05    #最終過濾條件 = 其他特殊條件+全部的條件設定
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gfi[l_ac].* = g_gfi_t.*
               CLOSE p_auth_condition_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gfh02,-263,1)
               LET g_gfi[l_ac].* = g_gfi_t.*
            ELSE
               #更新單身
               UPDATE gfi_file 
                  SET gfi03 = g_gfi[l_ac].gfi03
                     ,gfi04 = g_gfi[l_ac].gfi04
                     ,gfi05 = g_gfi[l_ac].gfi05
                     ,gfi06 = g_gfi[l_ac].gfi06
                     ,gfi07 = g_gfi[l_ac].gfi07
                WHERE gfi01=g_argv1 
                  AND gfi02=g_gfh_t.gfh02 
                  AND gfi03=g_gfi_t.gfi03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","gfi_file",g_gfh.gfh01,g_gfh_t.gfh02,SQLCA.sqlcode,"","",0)   
                   LET g_gfi[l_ac].* = g_gfi_t.*
               ELSE
                   CALL p_auth_condition_gfh05() RETURNING g_gfh.gfh05    #最終過濾條件 = 其他特殊條件+全部的條件設定
                   MESSAGE 'UPDATE O.K'
               END IF
               #更新最終過濾條件
               UPDATE gfh_file 
                  SET gfh05 = g_gfh.gfh05
                WHERE gfh01=g_argv1 
                  AND gfh02=g_gfh_t.gfh02 
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","gfh_file",g_argv1,g_gfh_t.gfh02,SQLCA.sqlcode,"","",0)   
               ELSE
                   MESSAGE 'UPDATE O.K'
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac    #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_gfi[l_ac].* = g_gfi_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_gfi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE p_auth_condition_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034 add
            CLOSE p_auth_condition_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(gfi05)  #欄位
                  CALL cl_replace_str(g_argv2, "_file", "") RETURNING ls_str   #對應主Table，去掉_file
                  LET ls_str = ls_str.trim()
                  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gaq"
                  LET g_qryparam.arg1 = g_lang
                  LET g_qryparam.arg2 = ls_str    #對應主Table，去掉_file
                  LET g_qryparam.default1 = g_gfi[l_ac].gfi05
                  CALL cl_create_qry() RETURNING g_gfi[l_ac].gfi05
                  DISPLAY g_gfi[l_ac].gfi05 TO gfi05
                  NEXT FIELD gfi05
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
 
    #改順序
    #IF l_sort = "Y" THEN
    #   DELETE FROM gfi_file 
    #      WHERE gfi01=g_gfh.gfh01 AND gfi02=g_gfh.gfh02 
    #   IF SQLCA.sqlcode THEN
    #      CALL cl_err3("del","gfi_file",g_gfh.gfh01,g_gfh_t.gfh02,SQLCA.sqlcode,"","BODY DELETE",0)
    #      ROLLBACK WORK
    #   ELSE
    #      FOR l_i = 1 TO g_rec_b 
    #         INSERT INTO gfi_file (gfi01,gfi02,gfi03,gfi04,gfi05,gfi06,gfi07) 
    #            VALUES (g_gfh.gfh01,g_gfh.gfh02,l_i,g_gfi[l_i].gfi04,g_gfi[l_i].gfi05,g_gfi[l_i].gfi06,g_gfi[l_i].gfi07)
    #         IF SQLCA.sqlcode THEN
    #            CALL cl_err3("ins","gfi_file",g_gfh.gfh02,l_i,SQLCA.sqlcode,"","",0)
    #            EXIT FOR
    #         END IF
    #      END FOR
    #   END IF
    #END IF
    
    CALL p_auth_condition_gfh05() RETURNING g_gfh.gfh05    #最終過濾條件 = 其他特殊條件+全部的條件設定
    #更新最終過濾條件
    UPDATE gfh_file 
       SET gfh05 = g_gfh.gfh05
     WHERE gfh01=g_argv1 
       AND gfh02=g_gfh_t.gfh02 
    IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","gfh_file",g_argv1,g_gfh_t.gfh02,SQLCA.sqlcode,"","",0)   
    ELSE
        MESSAGE 'UPDATE O.K'
    END IF
    
    CLOSE p_auth_condition_bcl
    COMMIT WORK
    
    CALL p_auth_condition_delall()
END FUNCTION
 
 
 
FUNCTION p_auth_condition_delall()
    DEFINE l_gfh05       LIKE    gfh_file.gfh05
    
    #單頭的最終過濾條件若是空的，則取消單頭資料
    UPDATE gfh_file
         SET gfh05 = g_gfh.gfh05
         WHERE gfh01 = g_argv1
            AND gfh02 = g_gfh.gfh02
    IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","gfh_file",g_argv1,g_gfh.gfh02,SQLCA.sqlcode,"","",0)   
    END IF
    SELECT gfh05 INTO　l_gfh05 FROM gfh_file
         WHERE gfh01 = g_argv1
            AND gfh02 = g_gfh.gfh02
    LET l_gfh05 = l_gfh05 CLIPPED
    IF cl_null(l_gfh05) THEN   #是否取消單頭資料
       #CALL cl_getmsg('9044',g_lang) RETURNING g_msg   #TQC-990140 mark
       #ERROR g_msg CLIPPED                             #TQC-990140 mark
       CALL cl_err( '', 9044, 1 )                       #TQC-990140
     
       DELETE FROM gfh_file WHERE gfh01=g_gfh.gfh01 AND gfh02=g_gfh.gfh02   #刪除單頭
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfi_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
          ROLLBACK WORK
          RETURN
       END IF
       
       DELETE FROM gfi_file WHERE gfi01=g_gfh.gfh01 AND gfi02=g_gfh.gfh02   #刪除單身
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfi_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
          ROLLBACK WORK
          RETURN
       END IF
       
       DELETE FROM gfj_file WHERE gfj01=g_gfh.gfh01 AND gfj05=g_gfh.gfh02   #刪除相關設定p_auth_filter單身
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfj_file",g_gfh.gfh01,g_gfh.gfh02,SQLCA.sqlcode,"","",0)    
          ROLLBACK WORK
          RETURN
       END IF
    END IF           
 
END FUNCTION
   
 
FUNCTION p_auth_condition_b_fill(p_wc2)            
 
    DEFINE p_wc2           STRING       
 
    LET g_sql = "SELECT gfi03,gfi04,gfi05,gaq03,gfi06,gfi07 ",   
                 " FROM gfi_file ",
                 " LEFT JOIN gaq_file ",
                 "  ON gfi05 = gaq01 AND gaq02 = '",g_lang,"'",
                 " WHERE gfi01 ='",g_argv1,"'",
                 "   AND gfi02 ='",g_gfh.gfh02,"'",
                 "   AND ", p_wc2 CLIPPED,                     #單身
                 " ORDER BY gfi03"
    PREPARE p_auth_condition_pb FROM g_sql
    DECLARE gfi_curs                       #CURSOR
        CURSOR FOR p_auth_condition_pb
 
    CALL g_gfi.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH gfi_curs INTO g_gfi[g_cnt].*   #單身 ARRAY 填充
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
    CALL g_gfi.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  #單身總筆數
    LET  g_cnt = 0
END FUNCTION
 
FUNCTION p_auth_condition_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gfi TO s_gfi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
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
         CALL p_auth_condition_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL p_auth_condition_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                 
        
      ON ACTION jump
         CALL p_auth_condition_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                 
 
      ON ACTION next
         CALL p_auth_condition_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL p_auth_condition_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	ACCEPT DISPLAY                  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
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
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_auth_condition_copy()
    DEFINE
        l_gfh		RECORD 
            gfh01       LIKE gfh_file.gfh01,                                              
            gfh02       LIKE gfh_file.gfh02,                               
            gfh03       LIKE gfh_file.gfh03,
            gfh04       LIKE gfh_file.gfh04,
            gfh05       LIKE gfh_file.gfh05,
            gfh06       LIKE gfh_file.gfh06   #TQC-990140 add gfh06
                        END RECORD
    DEFINE  l_old_gfh02,l_new_gfh02 LIKE gfh_file.gfh02
 
    IF s_shut(0) THEN RETURN END IF
    IF g_gfh.gfh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL p_auth_condition_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_new_gfh02 WITHOUT DEFAULTS FROM gfh02
        AFTER FIELD gfh02
            IF cl_null(l_new_gfh02) THEN
                NEXT FIELD gfh02
            ELSE
                SELECT COUNT(*) INTO g_cnt FROM gfh_file
                    WHERE gfh01 = g_argv1 AND gfh02 = l_new_gfh02
                IF g_cnt > 0 THEN
                    CALL cl_err(l_new_gfh02,-239,0)
                    NEXT FIELD gfh02
                END IF
            END IF
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
         ON ACTION about         
            CALL cl_about()      
    
         ON ACTION help          
            CALL cl_show_help()  
    
         ON ACTION controlg      
            CALL cl_cmdask()    
    END INPUT
    
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_gfh.gfh02,g_gfh.gfh03,g_gfh.gfh04,g_gfh.gfh05,g_gfh.gfh06   #TQC-990140 add gfh06
        RETURN
    END IF
    LET l_gfh.* = g_gfh.*
    LET l_gfh.gfh02 = l_new_gfh02   #新的鍵值
    INSERT INTO gfh_file(gfh01,gfh02,gfh03,gfh04,gfh05,gfh06)                         #TQC-990140 add gfh06
       VALUES (g_argv1,l_gfh.gfh02,l_gfh.gfh03,l_gfh.gfh04,l_gfh.gfh05,l_gfh.gfh06)   #TQC-990140 add gfh06
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gfh_file",l_gfh.gfh01,l_gfh.gfh02,SQLCA.sqlcode,"","gfh",0)    
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM gfi_file         #單身複製
        WHERE gfi01=g_gfh.gfh01
          AND gfi02=g_gfh.gfh02
        INTO TEMP x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","x",g_argv1,g_gfh.gfh02,SQLCA.sqlcode,"","",0)   
        RETURN
    END IF
    UPDATE x
        SET gfi02=l_new_gfh02
    INSERT INTO gfi_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","gfi_file",g_argv1,l_new_gfh02,SQLCA.sqlcode,"","gfi",0)    
        RETURN
    ELSE
        LET g_gfh.gfh02 = l_new_gfh02
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
    MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new_gfh02,') O.K'
        
END FUNCTION
 
#最終過濾條件 = 其他特殊條件+全部的條件設定
FUNCTION p_auth_condition_gfh05()
        DEFINE  l_str, l_s_gfi04, l_s_gfi06, l_s_gfi07     LIKE   gfh_file.gfh05
        DEFINE  l_i,l_max    INTEGER
        
        ###TQC-990140 START ###
        IF NOT cl_null(g_gfh.gfh04) THEN
           IF g_gfh.gfh06 = "1" THEN
              LET l_str = "AND "
           END IF
           IF g_gfh.gfh06 = "2" THEN
              LET l_str = "OR "
           END IF        
        END IF
        ###TQC-990140 END ###                
        LET l_str = l_str,g_gfh.gfh04   
        
        CALL ARR_COUNT( ) RETURNING l_max
        FOR l_i=1 TO l_max
               LET l_s_gfi04 = NULL
               LET l_s_gfi06 = NULL
               CASE g_gfi[l_i].gfi04
                   WHEN 1   LET l_s_gfi04 = "AND"
                   WHEN 2   LET l_s_gfi04 = "OR"
               END CASE
               CASE g_gfi[l_i].gfi06
                   WHEN 1   LET l_s_gfi06 = "="
                   WHEN 2   LET l_s_gfi06 = "<>"
                   WHEN 3   LET l_s_gfi06 = "<"
                   WHEN 4   LET l_s_gfi06 = "<="
                   WHEN 5   LET l_s_gfi06 = ">"
                   WHEN 6   LET l_s_gfi06 = ">="
                   WHEN 7   LET l_s_gfi06 = "BETWEEN"
                   WHEN 8   LET l_s_gfi06 = "IN"
                   WHEN 9   LET l_s_gfi06 = "NOT IN"
                   #WHEN 10   LET l_s_gfi06 = "LIKE"
                   #WHEN 11   LET l_s_gfi06 = "NOT LIKE"
               END CASE
               IF g_gfi[l_i].gfi06 <= 6  THEN   #值自動加上單引號 => '值'
                     LET l_s_gfi07 = "'",g_gfi[l_i].gfi07,"'"
               ELSE 
                     LET l_s_gfi07 = g_gfi[l_i].gfi07
               END IF
               LET l_str = l_str," ",l_s_gfi04," (",g_gfi[l_i].gfi05," ",l_s_gfi06," ",l_s_gfi07," )"
        END FOR
        
        DISPLAY l_str TO gfh05
        RETURN l_str
END FUNCTION
 
 
FUNCTION p_auth_condition_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1     
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("gfh02,gfh03,gfh04,gfh06",TRUE)
   END IF
END FUNCTION
 
FUNCTION p_auth_condition_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1    
 
   IF p_cmd = 'u' AND (NOT g_before_input_done) AND g_chkey = 'N' THEN
        CALL cl_set_comp_entry("gfh02",FALSE)
   END IF
END FUNCTION
 

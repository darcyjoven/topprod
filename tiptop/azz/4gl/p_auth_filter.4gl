# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#
# Pattern name...: p_auth_filter.4gl
# Descriptions...: 權限過濾器
# Date & Author..: 09/06/04 By tsai_yen
# Modify.........: No.FUN-960015 09/07/29 By tsai_yen
# Modify.........: No.TQC-990140 09/09/25 By tsai_yen 1.單身只有一筆資料,刪除單身會出現ERROR  2.規格異動:增加欄位 gfg07(AND/OR)
# Modify.........: No.FUN-9B0135 09/11/24 By tsai_yen 單頭增加說明欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A70082 10/07/15 by jay 調整使用gat_file來判斷table是否存在，需要改成用zta_file來判斷
# Modify.........: No.FUN-B50065 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70082 11/07/21 By tsai_yen 不限制一定要有程式名稱
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-960015
 
#模組變數(Module Variables)
DEFINE g_gfg         RECORD   LIKE gfg_file.*  #權限過濾器單頭檔
DEFINE g_gfg_t       RECORD   LIKE gfg_file.*  #權限過濾器單頭檔 (舊值)   
DEFINE g_gfg_o       RECORD   LIKE gfg_file.*  #權限過濾器單頭檔 (舊值)
 
DEFINE g_gfg01_t     LIKE gfg_file.gfg01       #程式代碼 (key舊值)
    
DEFINE g_gfj         DYNAMIC ARRAY OF RECORD   #權限過濾器單身檔
          gfj02        LIKE gfj_file.gfj02,        #序號
          gfj03        LIKE gfj_file.gfj03,        #過濾方式 1:依使用者, 2:依權限類別, 3.依部門, 4.預設(Default)
          gfj04        LIKE gfj_file.gfj04,        #代碼
          gfj05        LIKE gfj_file.gfj05,        #過濾條件代碼
          gfh03        LIKE gfh_file.gfh03,        #過濾條件說明
          gfh05        LIKE gfh_file.gfh05         #過濾條件
                     END RECORD
DEFINE g_gfj_t       RECORD                    #權限過濾器單身檔 (舊值)
          gfj02        LIKE gfj_file.gfj02,        #序號
          gfj03        LIKE gfj_file.gfj03,        #過濾方式
          gfj04        LIKE gfj_file.gfj04,        #代碼
          gfj05        LIKE gfj_file.gfj05,        #過濾條件代碼
          gfh03        LIKE gfh_file.gfh03,        #過濾條件說明
          gfh05        LIKE gfh_file.gfh05         #過濾條件
                     END RECORD
DEFINE g_gfj_o       RECORD                    #權限過濾器單身檔 (舊值)
          gfj02        LIKE gfj_file.gfj02,        #序號
          gfj03        LIKE gfj_file.gfj03,        #過濾方式
          gfj04        LIKE gfj_file.gfj04,        #代碼
          gfj05        LIKE gfj_file.gfj05,        #過濾條件代碼
          gfh03        LIKE gfh_file.gfh03,        #過濾條件說明
          gfh05        LIKE gfh_file.gfh05         #過濾條件
                     END RECORD
                     
DEFINE g_wc,g_wc2    STRING 
DEFINE g_sql         STRING 
DEFINE g_ss          LIKE type_file.chr1       #Y/N 填充單身       
DEFINE l_ac          LIKE type_file.num5           
DEFINE l_w_ac        LIKE type_file.num5       # 目前處理的ARRAY CNT
DEFINE g_rec_b       LIKE type_file.num5       #單身筆數        
DEFINE g_cn2         LIKE type_file.num5            
DEFINE g_forupd_sql  STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5      
DEFINE g_cnt         LIKE type_file.num10         
DEFINE g_msg         LIKE ze_file.ze03         
DEFINE g_row_count   LIKE type_file.num10    
DEFINE g_jump        LIKE type_file.num10      #查詢指定的筆數   
DEFINE mi_no_ask     LIKE type_file.num5       #是否開啟指定筆視窗  
DEFINE g_curs_index  LIKE type_file.num10  
DEFINE g_memo_ze     STRING                    #說明   #FUN-9B0135

 
MAIN
 
DEFINE p_row,p_col   LIKE type_file.num5          
   OPTIONS                                    #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)             #計算使用時間 (進入時間) 
       RETURNING g_time    
 
   LET g_gfg01_t = NULL                       #清除鍵值
   
   LET g_forupd_sql = "SELECT * FROM gfg_file WHERE gfg01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_auth_filter_cl CURSOR FROM g_forupd_sql   #單頭LOCK CURSOR
   
   LET p_row = 4 LET p_col = 20
 
   OPEN WINDOW p_auth_filter_w AT p_row,p_col WITH FORM "azz/42f/p_auth_filter"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
   
   LET g_memo_ze = cl_getmsg('azz1020',g_lang)   #備註說明:過濾條件設定注意事項，記錄在p_ze   #FUN-9B0135
   DISPLAY g_memo_ze TO　memo_ze                 #顯示備註說明   #FUN-9B0135
   
   CALL p_auth_filter_menu()
 
   CLOSE WINDOW p_auth_filter_w               #結束畫面
     CALL  cl_used(g_prog,g_time,2)           #計算使用時間 (退出時間) 
        RETURNING g_time    
END MAIN
 
 
FUNCTION p_auth_filter_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000       
 
   WHILE TRUE
      CALL p_auth_filter_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL p_auth_filter_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p_auth_filter_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p_auth_filter_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL p_auth_filter_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p_auth_filter_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_gfg.gfg01) THEN
                  LET g_doc.column1 = "gfg01"
                  LET g_doc.value1 = g_gfg.gfg01
                  CALL cl_doc()
               END IF
            END IF
            
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gfg),'','')
            END IF
         
         WHEN "auth_condition"     #執行：權限過濾器條件設定
            IF (NOT cl_null(g_gfg.gfg01)) AND (NOT cl_null(g_gfg.gfg02)) THEN
                CALL auth_condition()
            ELSE
                MESSAGE "'Programe Code' or 'Maintain Table' is null"
            END IF
      END CASE
   END WHILE
   
END FUNCTION
 
 
FUNCTION p_auth_filter_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     

   IF p_ud <> 'G' OR g_action_choice = "detail" THEN  #FUN-D30034 add
      RETURN                     #FUN-D30034 add 
   END IF                        #FUN-D30034 add
 
   LET g_action_choice = " "
 
   LET g_forupd_sql = "SELECT gfj02,gfj03,gfj04,gfj05,gfh03,gfh05 ",
                          " FROM gfj_file,gfh_file ",
                          " WHERE gfj01 = gfh01 AND gfj05 = gfh02",
                          "    AND gfj01=? AND gfj02=? FOR UPDATE "    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_auth_filter_bcl2 CURSOR FROM g_forupd_sql      #單身LOCK CURSOR
   
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gfj TO s_gfj.*  ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                     
         DISPLAY g_gfj[l_ac].gfh05 TO l_gfh05   #顯示最終過濾條件      
                           
         
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      #修改
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL p_auth_filter_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY                
 
      ON ACTION previous
         CALL p_auth_filter_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION jump
         CALL p_auth_filter_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL p_auth_filter_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	     ACCEPT DISPLAY                  
 
      ON ACTION last
         CALL p_auth_filter_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	     ACCEPT DISPLAY    
 
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()               
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
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
 
      #ON ACTION 相關文件
      ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION auth_condition   #權限過濾器條件設定
         LET g_action_choice = "auth_condition"
         EXIT DISPLAY
         
      AFTER DISPLAY
         CONTINUE DISPLAY
                                                                                           
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                           
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION p_auth_filter_cs()                 # QBE 查詢資料
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   
   DEFINE l_gat03     LIKE gat_file.gat03   #對應主Table名稱
   
   CLEAR FORM                               # 清除畫面
   CALL g_gfj.clear()
   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_gfg.* TO NULL
   
   DISPLAY g_memo_ze TO　memo_ze            #顯示備註說明   #FUN-9B0135
   
   # 螢幕上取條件 (單頭)
   CONSTRUCT g_wc ON gfg_file.gfg10,gfg_file.gfg01,gfg_file.gfg02,gfg_file.gfg07,   #TQC-990140 add gfg07
                     gfg_file.gfg08   
                FROM gfg10,gfg01,gfg02,gfg07,   #TQC-990140 add gfg07
                     gfg08  
      
      BEFORE CONSTRUCT
         CALL cl_qbe_init()                  
           
      ON ACTION CONTROLP
         CASE
            #開窗查詢 - 對應主Table                     
            WHEN INFIELD(gfg02)   
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gat"
               LET g_qryparam.default1= l_gat03 CLIPPED
               LET g_qryparam.arg1= g_lang CLIPPED        #語言別
               CALL cl_create_qry() RETURNING g_gfg.gfg02
               DISPLAY g_gfg.gfg02 TO gfg02
               CALL p_auth_filter_gfg02()    #顯示主Table
            OTHERWISE
               EXIT CASE
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
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   
   # 螢幕上取條件 (單身)
   CONSTRUCT g_wc2 ON gfj_file.gfj03,gfj_file.gfj04,gfj_file.gfj05,gfj_file.gfh03
                 FROM s_gfj[1].gfj03,s_gfj[1].gfj04,s_gfj[1].gfj05,s_gfj[1].gfh03
        
        BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
                      
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
           CALL cl_qbe_select()
 
        ON ACTION qbe_save
           CALL cl_qbe_save()           
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF   
   
   IF g_wc2 = " 1=1" THEN   #單身未輸入條件
      LET g_sql = "SELECT gfg01",
                  " FROM gfg_file",
                  " WHERE ",g_wc CLIPPED,
                  " ORDER BY gfg01"
   ELSE                     #單身有輸入條件
      LET g_sql = "SELECT gfg01",
                  " FROM gfg_file,gfj_file",
                  " WHERE gfg_file.gfg01=gfj_file.gfj01",
                  "  AND ",g_wc CLIPPED,
                  "  AND ",g_wc2 CLIPPED,
                  " ORDER BY gfg01"
   END IF
 
   PREPARE p_auth_filter_prepare FROM g_sql      #預備一下
   DECLARE p_auth_filter_cs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR p_auth_filter_prepare
       
   IF g_wc2 = " 1=1" THEN   #單身未輸入條件
      LET g_sql = "SELECT COUNT(DISTINCT gfg01)",
                  " FROM gfg_file",
                  " WHERE ",g_wc CLIPPED
   ELSE                     #單身有輸入條件
      LET g_sql = "SELECT COUNT(DISTINCT gfg01)",
                  " FROM gfg_file,gfj_file",
                  " WHERE gfg_file.gfg01=gfj_file.gfj01",
                  "  AND ",g_wc CLIPPED,
                  "  AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE p_auth_filter_precount FROM g_sql
   DECLARE p_auth_filter_count CURSOR FOR p_auth_filter_precount
END FUNCTION
 
 
#Query 查詢
FUNCTION p_auth_filter_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    
    MESSAGE ""
    CALL cl_opmsg('q')                    #顯示操作方法於狀態列
    CLEAR FORM
    CALL g_gfj.clear()
    DISPLAY ' ' TO FORMONLY.cnt
    CALL p_auth_filter_cs()                 #取得查詢條件
    IF INT_FLAG THEN                        #輸入中斷鍵
       LET INT_FLAG = 0
       INITIALIZE g_gfg.* TO NULL
       RETURN
    END IF
    
    OPEN p_auth_filter_cs               #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                   #有問題
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gfg.* TO NULL
    ELSE       
       OPEN p_auth_filter_count
       FETCH p_auth_filter_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       
       CALL p_auth_filter_fetch('F')        #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
 
#處理資料的讀取
FUNCTION p_auth_filter_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1     #處理方式           
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     p_auth_filter_cs INTO g_gfg.gfg01
      WHEN 'P' FETCH PREVIOUS p_auth_filter_cs INTO g_gfg.gfg01
      WHEN 'F' FETCH FIRST    p_auth_filter_cs INTO g_gfg.gfg01
      WHEN 'L' FETCH LAST     p_auth_filter_cs INTO g_gfg.gfg01
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
          FETCH ABSOLUTE g_jump p_auth_filter_cs INTO g_gfg.gfg01
          LET mi_no_ask = FALSE 
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_gfg.gfg01,SQLCA.sqlcode,0)
       INITIALIZE g_gfg.* TO NULL                #單頭清空
   ELSE
       CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
       END CASE      
              
       CALL cl_navigator_setting( g_curs_index, g_row_count ) #重新設w上下筆五個功能鍵的開關
       DISPLAY g_curs_index TO FORMONLY.idx
   END IF
   
   SELECT * INTO g_gfg.* FROM gfg_file WHERE gfg01 = g_gfg.gfg01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","gfg_file","","",SQLCA.sqlcode,"","",1)
      INITIALIZE g_gfg.* TO NULL
      RETURN
   END IF
   
   CALL p_auth_filter_show()
END FUNCTION
 
 
#將資料顯示在畫面上
FUNCTION p_auth_filter_show()
   LET g_gfg_t.* = g_gfg.*                #保存單頭舊值
   LET g_gfg_o.* = g_gfg.*                #保存單頭舊值
   
   #單頭顯示
   DISPLAY g_gfg.gfg10,g_gfg.gfg01,g_gfg.gfg02,g_gfg.gfg07,g_gfg.gfg08   #TQC-990140 add gfg07
        TO gfg10,gfg01,gfg02,gfg07,gfg08   #TQC-990140 add gfg07
   DISPLAY g_memo_ze TO　memo_ze           #顯示備註說明   #FUN-9B0135
   
   CALL p_auth_filter_gfg01()             #顯示程式名稱
   CALL p_auth_filter_gfg02()             #顯示主Table名稱
   
   CALL p_auth_filter_b_fill(g_wc2)       #單身填充
   CALL cl_show_fld_cont()                #設定p_per內有特殊指定的欄位
    
END FUNCTION
 
 
FUNCTION p_auth_filter_b_fill(p_wc2)      #單身填充
   DEFINE p_wc2   STRING
   
   LET g_sql = "SELECT * FROM gfj_file",
               " WHERE gfj01 = '",g_gfg.gfg01,"'"   
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   
   LET g_sql = "SELECT gfj.gfj02,gfj.gfj03,gfj.gfj04,gfj.gfj05,",
                     " gfh.gfh03,gfh.gfh05",
               " FROM",
                 " ( ",g_sql,
                 " ) gfj",
               " LEFT JOIN",
                 " ( select * from gfh_file WHERE gfh01 = '",g_gfg.gfg01,"'",
                 " ) gfh",
               " ON gfj.gfj05 = gfh.gfh02" 
   LET g_sql=g_sql CLIPPED," ORDER BY gfj.gfj02 "
      
   PREPARE p_auth_filter_pb FROM g_sql
   DECLARE gfj_cs CURSOR FOR p_auth_filter_pb
   
   CALL g_gfj.clear()                     #清空單身資料
   LET g_cnt = 1
   
   FOREACH gfj_cs INTO g_gfj[g_cnt].*     #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)    
           EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
 
       IF g_cnt > g_max_rec THEN          #最大單身筆數限制(aoos010設定)
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   
   CALL g_gfj.deleteElement(g_cnt)        #刪除最後新增的空白列
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
   IF g_rec_b > 0 THEN
      DISPLAY g_gfj[g_rec_b].gfh05 TO l_gfh05   #顯示最終過濾條件
   ELSE
      DISPLAY "" TO l_gfh05
   END IF
END FUNCTION
 
 
#Add  輸入
FUNCTION p_auth_filter_a()
   MESSAGE ""
   CLEAR FORM
   CALL g_gfj.clear()
   INITIALIZE g_gfg.* LIKE gfg_file.*
   LET g_gfg01_t = NULL
   LET g_wc = NULL
   LET g_wc2= NULL
 
   IF s_shut(0) THEN                     #判斷目前系統是否可使用
      RETURN
   END IF
      
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')                    #顯示操作方法於狀態列
   LET g_gfg_t.* = g_gfg.*
   LET g_gfg_o.* = g_gfg.*
   
   WHILE TRUE
      CALL p_auth_filter_i("a")          #輸入單頭
            
      IF INT_FLAG THEN                   #輸入中斷鍵
          INITIALIZE g_gfg.* TO NULL
          LET INT_FLAG = 0
          CALL cl_err('',9001,0)
          EXIT WHILE
      END IF
      
      IF cl_null(g_gfg.gfg01) THEN       # KEY 不可空白
        CONTINUE WHILE
      END IF
      
      
      #新增單頭
      BEGIN WORK
      INSERT INTO gfg_file VALUES (g_gfg.*)
      IF SQLCA.sqlcode THEN              #置入資料庫不成功
         ROLLBACK WORK    
         CALL cl_err3("ins","gfg_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
         COMMIT WORK     
         CALL cl_flow_notify(g_gfg.gfg01,'I')   #流程通知(p_flow設定)
      END IF
      
      LET g_gfg01_t = g_gfg.gfg01        #保留舊值 (單頭)
      LET g_gfg_t.* = g_gfg.*
      LET g_gfg_o.* = g_gfg.*
      CALL g_gfj.clear()                 #清空資料 (單身)
      
      LET g_rec_b = 0       
      
      CALL p_auth_filter_b()             #輸入單身
         
      EXIT WHILE
   END WHILE
END FUNCTION
 
 
#處理INPUT
FUNCTION p_auth_filter_i(p_cmd)
   DEFINE   p_cmd        LIKE type_file.chr1       #a:新增 u:更改 
   DEFINE   l_row_count  LIKE type_file.num5       #資料筆數，用來檢查資料是否存在
   DEFINE   l_gat03      LIKE gat_file.gat03       #對應主Table名稱
   DEFINE   l_str        STRING
 
   IF s_shut(0) THEN                               #判斷目前系統是否可使用
      RETURN
   END IF
   
   LET g_ss='Y'
   CALL cl_set_head_visible("","YES")              #預設單頭區塊開啟
   
   DISPLAY g_memo_ze TO　memo_ze                   #顯示備註說明   #FUN-9B0135
   
   INPUT BY NAME g_gfg.gfg10,g_gfg.gfg01,g_gfg.gfg02,g_gfg.gfg07,g_gfg.gfg08   #TQC-990140 add gfg07
         WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL p_auth_filter_set_entry(p_cmd)
         CALL p_auth_filter_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_comp_required("gfg01,gfg02,gfg10", TRUE) #動態設定欄位是否必須輸入值
         
         IF cl_null(g_gfg.gfg10) THEN   #程式型態預設值
            LET g_gfg.gfg10 = "1"
         END IF
         
         ###TQC-990140 START ###  
         IF cl_null(g_gfg.gfg07) THEN   #合併條件的ADN/OR
            LET g_gfg.gfg07 = "1"            
         END IF 
         DISPLAY BY NAME g_gfg.gfg07
         ###TQC-990140 END ###
         
 
      ON CHANGE gfg10
         LET g_gfg.gfg01 = NULL
         LET g_gfg.gfg02 = NULL
         DISPLAY g_gfg.gfg01,"",g_gfg.gfg02,"" TO gfg01,gaz03,gfg02,gat03
         NEXT FIELD gag01
    
      #程式代碼
      ON CHANGE gfg01
         LET g_gfg.gfg02 = NULL
         DISPLAY g_gfg.gfg02,"" TO gfg02,gat03
         
      AFTER FIELD gfg01                      
         IF (NOT cl_null(g_gfg.gfg01)) AND (NOT cl_null(g_gfg.gfg10)) THEN           
            IF g_gfg.gfg01 != g_gfg_t.gfg01 OR     #輸入後更改不同時值
                    cl_null(g_gfg_t.gfg01) THEN               
               LET l_row_count = 0
               CASE g_gfg.gfg10
                  WHEN "1"   #程式資料建立作業(p_zz)
                     #檢查程式代碼是否存在gaz_file程式名稱多語言記錄檔
                     SELECT COUNT(DISTINCT gaz01) INTO l_row_count  
                        FROM gaz_file,zz_file
                        WHERE gaz01=g_gfg.gfg01
                           AND zz11<>'MENU' 
                           AND gaz02= g_lang
                  WHEN "2"   #自定義查詢報表維護作業(p_query)
                     SELECT COUNT(DISTINCT zai01) INTO l_row_count
                        FROM zai_file
                        WHERE zai01 = g_gfg.gfg01
                  WHEN "3"   #動態查詢函式維護作業(p_qry)
                     SELECT COUNT(DISTINCT gab01) INTO l_row_count
                        FROM gab_file
                        WHERE gab01 = g_gfg.gfg01 
               END CASE                   
                   
               IF l_row_count = 0 THEN
                  CALL cl_err(g_gfg.gfg01,'aoo-997',1)   #查無此程式代碼, 請重新輸入!
                  NEXT FIELD gfg01
               #ELSE
               #   IF g_gfg.gfg10 = "1" THEN   #程式資料建立作業(p_zz)
               #      #不可使用參數程式，例如aaps100
               #      LET l_str = g_gfg.gfg01 CLIPPED
               #      IF l_str.getcharat(4) = "s" THEN
               #         CALL cl_err(g_gfg.gfg01,'azz1007',1)
               #         NEXT FIELD gfg01
               #      END IF
               #   END IF
               END IF
            END IF 
            
            #檢查Key值是否重複
            SELECT COUNT(DISTINCT gfg01) INTO l_row_count   
               FROM gfg_file
               WHERE gfg01=g_gfg.gfg01
            IF l_row_count <= 0 THEN      #不存在, 新的
               IF p_cmd='a' THEN        #新增
                 LET g_ss='N'
               END IF
            ELSE
               CALL cl_err(g_gfg.gfg01,-239,0)
               LET g_gfg.gfg01 = g_gfg01_t
               NEXT FIELD gfg01
            END IF
    
            CALL p_auth_filter_gfg01()             #顯示程式名稱
            IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_gfg.gfg01,g_errno,0)
                #NEXT FIELD gfg01   #FUN-B70082 mark
            END IF
         END IF
          
          
      #對應主Table  
      ON CHANGE gfg02
         IF cl_null(g_gfg.gfg01) THEN   #必須先有程式代碼才能輸入對應主Table
            CALL cl_err(g_gfg.gfg01,'aoo-997',1)
            NEXT FIELD gfg01
         END IF
 
            
      AFTER FIELD gfg02 
         IF NOT cl_null(g_gfg.gfg02) THEN
            IF g_gfg.gfg02 != g_gfg_t.gfg02 OR     #輸入後更改不同時值
               cl_null(g_gfg_t.gfg02) THEN    
                  #FUN-A70082-----start----  
                  #SELECT COUNT(DISTINCT gat01) INTO l_row_count  #檢查程式代碼是否存在gaz_file程式名稱多語言記錄檔
                  #   FROM gat_file
                  #   WHERE gat01 = g_gfg.gfg02
                  #      AND gat02= g_lang
                  SELECT COUNT(DISTINCT zta01) INTO l_row_count  #檢查程式代碼是否存在zta_file
                     FROM zta_file
                     WHERE zta01 = g_gfg.gfg02 AND zta02 = 'ds'
                  #FUN-A70082-----end-----
                  IF l_row_count =0 THEN
                     CALL cl_err(g_gfg.gfg02,"azz-053",1)
                     CALL p_auth_filter_gfg02()    #顯示主Table
                     LET g_errno = " "     #FUN-A70082  修正舊有Bug,會因上次發生之錯誤原因一直記錄著,導致下次重新輸入正確時,還是出現錯誤訊息提示
                     NEXT FIELD gfg02
                  END IF
            END IF
    
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_gfg.gfg02,g_errno,0)
               CALL p_auth_filter_gfg02()          #顯示主Table
               NEXT FIELD gfg02
            END IF            
         END IF
         CALL p_auth_filter_gfg02()          #顯示主Table                 
 
  
      ON ACTION CONTROLP
         CASE
            #開窗查詢 - 程式代碼
            WHEN INFIELD(gfg01)     
               CASE g_gfg.gfg10
                  WHEN "1"   #程式資料建立作業(p_zz)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gaz"
                     LET g_qryparam.default1= g_gfg.gfg01
                     LET g_qryparam.arg1= g_lang
                     CALL cl_create_qry() RETURNING g_gfg.gfg01
                     DISPLAY g_gfg.gfg01 TO gfg01
                     NEXT FIELD gfg01
                  WHEN "2"   #自定義查詢報表維護作業(p_query)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_zai"
                     LET g_qryparam.default1= g_gfg.gfg01
                     CALL cl_create_qry() RETURNING g_gfg.gfg01
                     DISPLAY g_gfg.gfg01 TO gfg01
                     NEXT FIELD gfg01
                  WHEN "3"   #動態查詢函式維護作業(p_qry)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gab"
                     LET g_qryparam.default1= g_gfg.gfg01
                     LET g_qryparam.arg1= g_lang
                     CALL cl_create_qry() RETURNING g_gfg.gfg01
                     DISPLAY g_gfg.gfg01 TO gfg01
                     NEXT FIELD gfg01
               END CASE
              
            #開窗查詢 - 對應主Table                     
            WHEN INFIELD(gfg02)   
               IF cl_null(g_gfg.gfg01) THEN
                  CALL cl_err(g_gfg.gfg01,'aoo-997',1)
                  NEXT FIELD gfg01
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gat"
                  LET g_qryparam.default1= l_gat03 CLIPPED
                  LET g_qryparam.arg1= g_lang CLIPPED        #語言別
                  CALL cl_create_qry() RETURNING g_gfg.gfg02
                  DISPLAY g_gfg.gfg02 TO gfg02
                  CALL p_auth_filter_gfg02()    #顯示主Table
               END IF            
               
            OTHERWISE
               EXIT CASE
         END CASE
    
      ON ACTION auth_condition     #執行：權限過濾器條件設定
         IF (NOT cl_null(g_gfg.gfg01)) AND (NOT cl_null(g_gfg.gfg02)) THEN
             CALL auth_condition()
         ELSE
             MESSAGE "'Programe Code' or 'Maintain Table' is null"
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
    
      ON ACTION CONTROLG
         CALL cl_cmdask()
    
      ON ACTION CONTROLF            #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
                   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT       
   END INPUT
END FUNCTION
 
 
#單身
FUNCTION p_auth_filter_b()
   DEFINE l_ac            LIKE type_file.num5    #cn2
   DEFINE l_ac_t          LIKE type_file.num5    #未取消態RRAY CNT        
   DEFINE l_n             LIKE type_file.num5    #檢查重複用       
   DEFINE l_lock_sw       LIKE type_file.chr1    #單身鎖住否       
   DEFINE p_cmd           LIKE type_file.chr1    #處理狀態        
   DEFINE l_tot           LIKE type_file.num5
   DEFINE l_allow_insert  LIKE type_file.num5    #可新增否       
   DEFINE l_allow_delete  LIKE type_file.num5    #可刪除否 
   DEFINE l_gfh03         LIKE gfh_file.gfh03
   DEFINE l_gfj           RECORD                 #權限過濾器單身檔,用於改順序
             gfj02           LIKE gfj_file.gfj02,    #序號
             gfj03           LIKE gfj_file.gfj03,    #過濾方式
             gfj04           LIKE gfj_file.gfj04,    #代碼
             gfj05           LIKE gfj_file.gfj05,    #過濾條件代碼
             gfh03           LIKE gfh_file.gfh03,    #過濾條件說明
             gfh05           LIKE gfh_file.gfh05     #過濾條件
             END RECORD
   #DEFINE l_sort          LIKE type_file.chr1    #是否重新排序 N:否 Y:是
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5    #資料筆數
 
   LET g_action_choice = ""
   #LET l_sort = "N"
   
   IF cl_null(g_gfg.gfg01) THEN
       RETURN
   END IF
   
      #若條件設定維護p_auth_condition沒有資料，則自動進入p_auth_condition新增
      SELECT COUNT(gfh01) INTO l_cnt
         FROM gfh_file
         WHERE gfh01= g_gfg.gfg01
      
      IF l_cnt = 0 THEN
        IF (NOT cl_null(g_gfg.gfg01)) AND (NOT cl_null(g_gfg.gfg02)) THEN
             CALL auth_condition()
         ELSE
             MESSAGE "'Programe Code' or 'Maintain Table' is null"
         END IF
      END IF   
   
   SELECT * INTO g_gfg.* FROM gfg_file
      WHERE gfg01=g_gfg.gfg01
   
   CALL cl_opmsg('b')                    #顯示操作方法於狀態列
 
   LET g_forupd_sql = "SELECT gfj02,gfj03,gfj04,gfj05,gfh03,gfh05 ",
                          " FROM gfj_file,gfh_file ",
                          " WHERE gfj01 = gfh01 AND gfj05 = gfh02",
                          "    AND gfj01=? AND gfj02=? FOR UPDATE "    
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p_auth_filter_bcl CURSOR FROM g_forupd_sql      #單身LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_gfj WITHOUT DEFAULTS FROM s_gfj.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            LET l_ac = ARR_CURR()
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
         
      BEFORE ROW
         CALL cl_set_comp_required("gfj04", TRUE) #動態設定欄位是否必須輸入值
         
         LET p_cmd=''
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
 
         IF cl_null(g_gfj[l_ac].gfj03) THEN
            LET g_gfj[l_ac].gfj03 = "4"
         END IF
         IF g_gfj[l_ac].gfj03 = "4" THEN                #過濾方式：Default
               CALL cl_set_comp_entry("gfj04", FALSE)   #關閉欄位-代碼
         ELSE
               CALL cl_set_comp_entry("gfj04", TRUE)    #開痁璁?代碼
         END IF       
        
         BEGIN WORK
         
         #準備鎖單頭
         OPEN p_auth_filter_cl USING g_gfg.gfg01
         IF STATUS THEN
            CALL cl_err("OPEN p_auth_filter_cl:", STATUS, 1)
            CLOSE p_auth_filter_cl
            ROLLBACK WORK
            RETURN
         END IF
         
         FETCH p_auth_filter_cl INTO g_gfg.*              # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_gfg.gfg01,SQLCA.sqlcode,0)      # 資料被他人LOCK
            CLOSE p_auth_filter_cl
            ROLLBACK WORK
            RETURN
         END IF
           
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_gfj_t.* = g_gfj[l_ac].*  #BACKUP
            LET g_gfj_o.* = g_gfj[l_ac].*  #BACKUP
            
            OPEN p_auth_filter_bcl USING g_gfg.gfg01,g_gfj_t.gfj02
            IF STATUS THEN
               CALL cl_err("OPEN p_auth_filter_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p_auth_filter_bcl INTO g_gfj[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_gfj_t.gfj02,SQLCA.sqlcode,1)  #錯誤訊息的附加說明, err_code 錯誤訊息代碼,顯示錯誤訊息後的停留秒數或是等使用者按下確定
                   LET l_lock_sw = "Y"
               END IF
            END IF
            
            CALL cl_show_fld_cont()
            DISPLAY l_ac  TO FORMONLY.cn2      #目前在單身的哪一列
            DISPLAY g_gfj[l_ac].gfh05 TO l_gfh05   #顯示最終過濾條件
         END IF
 
   
      #ON ACTION up     #往上移動資料
      #   IF l_ac>1 THEN
      #      IF l_lock_sw = 'Y' THEN
      #         CALL cl_err(g_gfj[l_ac].gfj02,-263,1)
      #      ELSE
      #         LET l_gfj.* = g_gfj[l_ac-1].*
      #         LET g_gfj[l_ac-1].* = g_gfj[l_ac].*
      #         LET g_gfj[l_ac].* = l_gfj.*
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
      #      IF NOT cl_null(g_gfj[l_ac+1].gfj02) THEN
      #         IF l_lock_sw = 'Y' THEN
      #            CALL cl_err(g_gfj[l_ac].gfj02,-263,1)
      #         ELSE
      #            LET l_gfj.* = g_gfj[l_ac+1].*
      #            LET g_gfj[l_ac+1].* = g_gfj[l_ac].*
      #            LET g_gfj[l_ac].* = l_gfj.*
      #            LET l_ac = l_ac + 1
      #            CALL fgl_set_arr_curr(l_ac)
      #            LET l_sort = "Y"   #是否重新排序
      #         END IF
      #      END IF
      #   END IF
      #   IF l_ac = g_rec_b THEN
      #      CALL cl_set_action_active("down", FALSE)
      #   END IF
 
       BEFORE FIELD gfj02                      #default 序號
          IF cl_null(g_gfj[l_ac].gfj02) THEN
             SELECT max(gfj02)+1
                INTO g_gfj[l_ac].gfj02
                FROM gfj_file
                WHERE gfj01 = g_gfg.gfg01
             IF cl_null(g_gfj[l_ac].gfj02) THEN
                LET g_gfj[l_ac].gfj02 = 1
             END IF
          END IF
 
       AFTER FIELD gfj02                       #check 序號是否重複
          IF NOT cl_null(g_gfj[l_ac].gfj02) THEN
             IF cl_null(g_gfj_t.gfj02) THEN
                LET g_gfj_t.gfj02 = 0
             END IF 
             IF g_gfj[l_ac].gfj02 != g_gfj_t.gfj02
                OR g_gfj_t.gfj02 = 0 THEN
                SELECT count(*)
                   INTO l_n
                   FROM gfj_file
                   WHERE gfj01 = g_gfg.gfg01
                     AND gfj02 = g_gfj[l_ac].gfj02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_gfj[l_ac].gfj02 = g_gfj_t.gfj02
                   NEXT FIELD gfj02
                END IF
             END IF
          END IF
         
      BEFORE FIELD gfj03
         IF g_gfj[l_ac].gfj03 = "4" THEN
            LET g_gfj[l_ac].gfj04 = "default"
         END IF
         DISPLAY g_gfj[l_ac].gfj04 TO gfj04
      
      ON CHANGE gfj03        #過濾方式
         LET g_gfj[l_ac].gfj04 = NULL
         LET g_gfj[l_ac].gfj05 = NULL
         IF g_gfj[l_ac].gfj03 = "4" THEN
            LET g_gfj[l_ac].gfj04 = "default"
            CALL cl_set_comp_required("gfj04", FALSE) #動態設定欄位是否必須輸入值
            CALL cl_set_comp_entry("gfj04", FALSE)    #關閉欄位-代碼
         ELSE
            CALL cl_set_comp_required("gfj04", TRUE)  #動態設定欄位是否必須輸入值
            CALL cl_set_comp_entry("gfj04", TRUE)     #開啟欄位-代碼
         END IF
         DISPLAY g_gfj[l_ac].gfj04,g_gfj[l_ac].gfj05 TO gfj04,gfj05      
      
      AFTER FIELD gfj03
         IF NOT cl_null(g_gfj[l_ac].gfj03) THEN
            #只能有一筆default存在
            IF g_gfj[l_ac].gfj03 = "4" THEN         
               SELECT count(*)
                  INTO l_n
                  FROM gfj_file
                  WHERE gfj01 = g_gfg.gfg01
                     AND gfj03 = g_gfj[l_ac].gfj03
                     AND gfj02 <> g_gfj[l_ac].gfj02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_gfj[l_ac].gfj03 = g_gfj_t.gfj03
                  NEXT FIELD gfj03
               END IF
            END IF 
         END IF
         
      ON ACTION CONTROLP
         CASE
             #開窗查詢 - 代碼(分3種過濾方式)
             WHEN INFIELD(gfj04)   
                CALL cl_init_qry_var()     #清空g_qryparam變數
                LET g_qryparam.state = "c"
                CASE g_gfj[l_ac].gfj03   #過濾方式
                   WHEN 1    #使用者
                      LET g_qryparam.form = "q_zx"                               
                      LET g_qryparam.default1= g_gfj[l_ac].gfj04
                      CALL cl_create_qry() RETURNING g_gfj[l_ac].gfj04
                      DISPLAY g_gfj[l_ac].gfj04 TO gfj04
                   WHEN 2    #權限類別
                      LET g_qryparam.form = "q_zw"
                      LET g_qryparam.default1= g_gfj[l_ac].gfj04
                      CALL cl_create_qry() RETURNING g_gfj[l_ac].gfj04
                      DISPLAY g_gfj[l_ac].gfj04 TO gfj04
                   WHEN  3    #部門
                      LET g_qryparam.form = "q_gem3"
                      LET g_qryparam.default1= g_gfj[l_ac].gfj04
                      CALL cl_create_qry() RETURNING g_gfj[l_ac].gfj04
                      DISPLAY g_gfj[l_ac].gfj04 TO gfj04
                END CASE
                NEXT FIELD gfj04
             #開窗查詢 - 過濾條件代碼
             WHEN INFIELD(gfj05)   
                CALL cl_init_qry_var()     #清空g_qryparam變數
                LET g_qryparam.form = "q_gfh"
                LET g_qryparam.default1= g_gfj[l_ac].gfj05 #當取消查詢時，將原本的值復原，若沒此行會變成空值
                LET g_qryparam.arg1 = g_gfg.gfg01 CLIPPED      #輸入：程式代碼
                CALL cl_create_qry() RETURNING g_gfj[l_ac].gfj05,g_gfj[l_ac].gfh03,g_gfj[l_ac].gfh05
                DISPLAY g_gfj[l_ac].gfj05,g_gfj[l_ac].gfh03,g_gfj[l_ac].gfh05 TO gfj05,gfh03,l_gfh05
                NEXT FIELD gfj05
         END CASE
                  
         
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_gfj[l_ac].* TO NULL      
         LET g_gfj_t.* = g_gfj[l_ac].*         #新輸入資料
         LET g_gfj_o.* = g_gfj[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         CALL p_auth_filter_set_entry_b(p_cmd)
         CALL p_auth_filter_set_no_entry_b(p_cmd)    
         NEXT FIELD gfj02
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         INSERT INTO gfj_file(gfj01,gfj02,gfj03,gfj04,gfj05)
              VALUES(g_gfg.gfg01,g_gfj[l_ac].gfj02,g_gfj[l_ac].gfj03,g_gfj[l_ac].gfj04,g_gfj[l_ac].gfj05)                               
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","gfj_file",g_gfj[l_ac].gfj02,"",SQLCA.sqlcode,"","",1)  
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            COMMIT WORK
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      
      BEFORE FIELD gfj05           #過濾條件代碼
         #要先填過濾方式
         IF cl_null(g_gfj[l_ac].gfj03) THEN
            NEXT FIELD gfj03
         END IF
      
         
      AFTER FIELD gfj05            #過濾條件代碼
         IF NOT cl_null(g_gfj[l_ac].gfj05) THEN
            #檢查資料是否存在
            SELECT COUNT(gfh02) INTO l_n
                FROM gfh_file
                WHERE gfh01 = g_gfg.gfg01
                    AND gfh02 = g_gfj[l_ac].gfj05
            IF l_n = 0 THEN
                CALL cl_err(g_gfj[l_ac].gfj05,"azz1004",1) #輸入資料不存在！請重新輸入
                LET g_gfj[l_ac].gfj05 = g_gfj_t.gfj05
                DISPLAY g_gfj[l_ac].gfj05 TO gfj05
                NEXT FIELD gfj05
            ELSE
                SELECT DISTINCT gfh03,gfh05 INTO g_gfj[l_ac].gfh03,g_gfj[l_ac].gfh05
                   FROM gfh_file
                   WHERE gfh01 = g_gfg.gfg01
                      AND gfh02 = g_gfj[l_ac].gfj05
            END IF             
            DISPLAY g_gfj[l_ac].gfh05,g_gfj[l_ac].gfh03 TO l_gfh05,gfh03
         END IF
         
      ON CHANGE gfj05
         IF l_ac > 0 THEN
            #DISPLAY g_gfj[l_ac].gfh05 TO l_gfh05   #顯示最終過濾條件
         END IF
                  
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_gfj_t.gfj02) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            DELETE FROM gfj_file
                WHERE gfj01 = g_gfg.gfg01
                   AND gfj02 = g_gfj_t.gfj02
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","gfj_file",g_gfj_t.gfj02,"",SQLCA.sqlcode,"","",1)  
                LET l_ac_t = l_ac
                EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
            ###TQC-990140 START ###
            IF g_rec_b > 0 THEN
               DISPLAY g_gfj[g_rec_b].gfh05 TO l_gfh05   #顯示最終過濾條件
            ELSE
               DISPLAY "" TO l_gfh05
            END IF
            ###TQC-990140 END ###
            MESSAGE "Delete OK"
            CLOSE p_auth_filter_bcl             
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_gfj[l_ac].* = g_gfj_t.*
             CLOSE p_auth_filter_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_gfj[l_ac].gfj02,-263,1)
             LET g_gfj[l_ac].* = g_gfj_t.*
          ELSE
             UPDATE gfj_file SET gfj02 = g_gfj[l_ac].gfj02,
                                 gfj03 = g_gfj[l_ac].gfj03,
                                 gfj04 = g_gfj[l_ac].gfj04,
                                 gfj05 = g_gfj[l_ac].gfj05
                WHERE gfj01=g_gfg.gfg01
                  AND gfj02=g_gfj_t.gfj02
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","gfj_file",g_gfg.gfg01,g_gfj_t.gfj02,SQLCA.sqlcode,"","",1)  
                 LET g_gfj[l_ac].* = g_gfj_t.*
                 ROLLBACK WORK
             ELSE
                 MESSAGE 'UPDATE O.K'
             END IF
          END IF
 
      AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac   #FUN-D30034 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_gfj[l_ac].* = g_gfj_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_gfj.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE p_auth_filter_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30034 add
          CLOSE p_auth_filter_bcl
          COMMIT WORK
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
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
                                                                                           
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")    
         
      ON ACTION auth_condition   #權限過濾器條件設定
         CALL auth_condition()                    
   END INPUT
 
   #改順序
   #IF l_sort = "Y" THEN
   #   DELETE FROM gfj_file 
   #      WHERE gfj01=g_gfg.gfg01
   #   IF SQLCA.sqlcode THEN
   #      CALL cl_err3("del","gfj_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","BODY DELETE",0)
   #      ROLLBACK WORK
   #   ELSE
   #      FOR l_i = 1 TO g_rec_b 
   #         INSERT INTO gfj_file (gfj01,gfj02,gfj03,gfj04,gfj05) 
   #            VALUES (g_gfg.gfg01,l_i,g_gfj[l_i].gfj03,g_gfj[l_i].gfj04,g_gfj[l_i].gfj05)
   #         IF SQLCA.sqlcode THEN
   #            CALL cl_err3("ins","gfj_file",g_gfg.gfg01,l_i,SQLCA.sqlcode,"","",0)
   #            EXIT FOR
   #         END IF
   #      END FOR
   #   END IF
   #END IF
   
   CLOSE p_auth_filter_bcl
   COMMIT WORK
   
   IF cl_null(g_gfg.gfg08) THEN
      CALL p_auth_filter_delall()   #若單身無資料，則刪除單頭資料
   END IF
END FUNCTION
 
 
FUNCTION p_auth_filter_delall()
   SELECT COUNT(*) INTO g_cnt FROM gfj_file
    WHERE gfj01 = g_gfg.gfg01
 
   IF g_cnt = 0 THEN             # 未輸入單身資料, 是否取消單頭資料
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
 
      DELETE FROM gfg_file WHERE gfg01 = g_gfg.gfg01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gfg_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","DELETE:",1) 
      END IF
      
      DELETE FROM gfj_file WHERE gfj01 = g_gfg.gfg01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gfj_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","BODY DELETE:",1) 
      END IF
      
      DELETE FROM gfh_file WHERE gfh01 = g_gfg.gfg01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gfh_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","DELETE:",1) 
      END IF
      
      DELETE FROM gfi_file WHERE gfi01 = g_gfg.gfg01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","gfi_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","BODY DELETE:",1) 
      END IF
   END IF
END FUNCTION
 
 
FUNCTION p_auth_filter_u()   #單頭修改
   DEFINE l_change  LIKE type_file.num5  #0:不修改 1:修改
   
   LET l_change = 0
 
   IF s_shut(0) THEN
      RETURN
   END IF
   
   IF g_gfg.gfg01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF   
   
   MESSAGE ""
   CALL cl_opmsg('u')                    #顯示操作方法於狀態列
   LET g_gfg01_t = g_gfg.gfg01           #程式代碼 (key舊值)
   
   BEGIN WORK
 
   OPEN p_auth_filter_cl USING g_gfg.gfg01
   IF STATUS THEN
      CALL cl_err("OPEN p_auth_filter_cl:", STATUS, 1)
      CLOSE p_auth_filter_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   FETCH p_auth_filter_cl INTO g_gfg.*             # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_gfg.gfg01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE p_auth_filter_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL p_auth_filter_show()
   
   WHILE TRUE
      LET g_gfg01_t = g_gfg.gfg01
      LET g_gfg_o.* = g_gfg.*
      
      CALL p_auth_filter_i("u")          #欄位更改    
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_gfg.*=g_gfg_t.*
         CALL p_auth_filter_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
                       
      UPDATE gfg_file                    #更新DB
         SET gfg02 = g_gfg.gfg02,
             gfg07 = g_gfg.gfg07,        #TQC-990140
             gfg08 = g_gfg.gfg08,
             gfg10 = g_gfg.gfg10
         WHERE gfg01 = g_gfg_t.gfg01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","gfg_file",g_gfg_t.gfg01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
      
      EXIT WHILE
   END WHILE
   
   CLOSE p_auth_filter_cl
   COMMIT WORK
   CALL cl_flow_notify(g_gfg.gfg01,'U')  #流程訊息通知
  
   CALL p_auth_filter_b_fill("1=1")      #重新抓取單身
   
   IF cl_null(g_gfg.gfg08) THEN
      CALL p_auth_filter_b()             #輸入單身
   END IF
   #CALL p_auth_filter_bp_refresh()
END FUNCTION
 
 
#刪除整筆 (所有合乎單頭的資料)
FUNCTION p_auth_filter_r()
   IF cl_null(g_gfg.gfg01) THEN
      CALL cl_err("",-400,0)              
      RETURN
   END IF
   
   BEGIN WORK
    
   OPEN p_auth_filter_cl USING g_gfg.gfg01
   IF STATUS THEN
      CALL cl_err("OPEN p_auth_filter_cl:", STATUS, 1)
      CLOSE p_auth_filter_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH p_auth_filter_cl INTO g_gfg.*               #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gfg.gfg01,SQLCA.sqlcode,0)       #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL p_auth_filter_show()
    
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "gfg01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_gfg.gfg01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       DELETE FROM gfg_file WHERE gfg01 = g_gfg.gfg01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfg_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","DELETE:",1) 
       END IF
       
       DELETE FROM gfj_file WHERE gfj01 = g_gfg.gfg01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfj_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","BODY DELETE:",1) 
       END IF
       
       DELETE FROM gfh_file WHERE gfh01 = g_gfg.gfg01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfh_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","DELETE:",1) 
       END IF
       
       DELETE FROM gfi_file WHERE gfi01 = g_gfg.gfg01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","gfi_file",g_gfg.gfg01,"",SQLCA.sqlcode,"","BODY DELETE:",1) 
       END IF
       
       CLEAR FORM
       CALL g_gfj.clear()
       
       OPEN p_auth_filter_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE p_auth_filter_cl
          CLOSE p_auth_filter_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       FETCH p_auth_filter_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE p_auth_filter_cl
          CLOSE p_auth_filter_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       
       OPEN p_auth_filter_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL p_auth_filter_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE     
          CALL p_auth_filter_fetch('/')
       END IF
   END IF
   
   CLOSE p_auth_filter_cl
   COMMIT WORK
   CALL cl_flow_notify(g_gfg.gfg01,'D')   #流程通知(p_flow設定)
END FUNCTION
 
 
FUNCTION p_auth_filter_b_askkey()   #單身重查
   DEFINE    l_begin_key     LIKE type_file.num5
 
   CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
           LET INT_FLAG = 0  
           
   PROMPT g_msg CLIPPED,': ' FOR l_begin_key
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
      RETURN
   END IF
   
   IF cl_null(l_begin_key) THEN
      LET l_begin_key = 0
   END IF
   
   CALL p_auth_filter_b_fill("1=1")      #重新抓取單身
END FUNCTION
 
 
#依"程式代碼"，顯示"程式名稱"
FUNCTION p_auth_filter_gfg01()
    DEFINE l_gaz03     LIKE gaz_file.gaz03   #p_zz 程式名稱
    DEFINE l_zai02     LIKE zai_file.zai02   #p_query 查詢單名稱
    DEFINE l_gae04     LIKE gae_file.gae04   #p_qry 名稱
 
    LET g_errno = " "
     
    CASE g_gfg.gfg10
       WHEN "1"   #程式資料建立作業(p_zz)
          SELECT gaz03 INTO l_gaz03 FROM gaz_file
             WHERE gaz01 = g_gfg.gfg01 AND gaz02 = g_lang AND gaz05='Y'    #�s
          IF STATUS THEN 
             SELECT gaz03 INTO l_gaz03 FROM gaz_file          
                WHERE gaz01 = g_gfg.gfg01 AND gaz02 = g_lang AND gaz05='N' #標準
             IF SQLCA.sqlcode THEN
                IF SQLCA.SQLCODE = 100 THEN 
                   #LET g_errno = "aoo-997"   #FUN-B70082 mark
                   LET g_errno = "azz-093"    #FUN-B70082
                ELSE 
                   LET g_errno = SQLCA.sqlcode USING "-------"
                   LET l_gaz03 = NULL
                END IF
             END IF
          END IF
          DISPLAY l_gaz03 TO gaz03
       WHEN "2"   #自定義查詢報表維護作業(p_query)
          SELECT zai02 INTO l_zai02 FROM zai_file
             WHERE zai01 = g_gfg.gfg01 AND zai05='Y'    #客製
          IF STATUS THEN 
             SELECT zai02 INTO l_zai02 FROM zai_file
                WHERE zai01 = g_gfg.gfg01 AND zai05='N' #標準
             IF SQLCA.sqlcode THEN
                IF SQLCA.SQLCODE = 100 THEN 
                   #LET g_errno = "aoo-997"   #FUN-B70082 mark
                   LET g_errno = "azz-093"    #FUN-B70082
                ELSE 
                   LET g_errno = SQLCA.sqlcode USING "-------"
                   LET l_zai02 = NULL
                END IF
             END IF
          END IF
          DISPLAY l_zai02 TO gaz03
       WHEN "3"   #動態查詢函式維護作業(p_qry)
          SELECT DISTINCT(gae04) INTO l_gae04 
             FROM gab_file,gae_file
             WHERE gab_file.gab01 = gae_file.gae01
                AND gae02 ='wintitle'
                AND gab01 = g_gfg.gfg01
                AND gae_file.gae03 = g_lang
                AND gab11='Y' AND gae11='Y'   #客製
          IF STATUS THEN 
             SELECT DISTINCT(gae04) INTO l_gae04 
             FROM gab_file,gae_file
                WHERE gab_file.gab01 = gae_file.gae01
                   AND gae02 ='wintitle'
                   AND gab01 = g_gfg.gfg01
                   AND gae_file.gae03 = g_lang
                   AND gab11='N' AND gae11='N'   #標準
             IF SQLCA.sqlcode THEN
                IF SQLCA.SQLCODE = 100 THEN 
                   #LET g_errno = "aoo-997"   #FUN-B70082 mark
                   LET g_errno = "azz-093"    #FUN-B70082
                ELSE 
                   LET g_errno = SQLCA.sqlcode USING "-------"
                   LET l_gae04 = NULL
                END IF
             END IF
          END IF
          DISPLAY l_gae04 TO gaz03
    END CASE
END FUNCTION
 
 
#依"對應主Table"，顯示"對應主Table名稱"
FUNCTION p_auth_filter_gfg02()
   DEFINE l_gat03     LIKE gat_file.gat03 
   
   LET g_errno = " "
   
   SELECT gat03 INTO l_gat03 FROM gat_file
      WHERE gat01 = g_gfg.gfg02 AND gat02 = g_lang 
      
   IF SQLCA.sqlcode THEN
      IF SQLCA.SQLCODE = 100 THEN 
         #LET g_errno = "aoo-997"  #FUN-B70082 mark
         LET g_errno = "azz-710"   #Table名稱不存在p_tabname中 #FUN-B70082
      ELSE 
         LET g_errno = SQLCA.sqlcode USING "-------"
         LET l_gat03 = NULL
      END IF
   END IF
 
   DISPLAY l_gat03 TO gat03
END FUNCTION
 
 
#開窗 - 權限過濾器條件設定
FUNCTION auth_condition()
   DEFINE ps_cmd       STRING        #UNIX指令
   
   LET ps_cmd = "p_auth_condition '",g_gfg.gfg01,"' '",g_gfg.gfg02,"'"
   
   CALL cl_cmdrun_wait(ps_cmd)
   CALL p_auth_filter_show()
END FUNCTION
 
 
FUNCTION p_auth_filter_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
     CALL cl_set_comp_entry("gfg01,gfg02,gfg07,gfg08,gfg10",TRUE)   #TQC-990140 add gfg07
   END IF  
END FUNCTION
 
 
FUNCTION p_auth_filter_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1         
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("gfg01,gfg02,gfg10",FALSE)
   END IF
END FUNCTION
 
 
FUNCTION p_auth_filter_set_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    
 
   IF INFIELD(gfj03) THEN
      IF g_gfj[l_ac].gfj03 <> '4' THEN   #非default過濾方式
         CALL cl_set_comp_entry("gfj04,gfj05",TRUE)
      END IF  
   END IF
END FUNCTION
 
FUNCTION p_auth_filter_set_no_entry_b(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1 
 
   IF INFIELD(gfj03) THEN
      IF g_gfj[l_ac].gfj03 = "4" THEN   #default過濾方式
         CALL cl_set_comp_entry("gfj04,gfj05",FALSE)
      END IF
   END IF
END FUNCTION
 

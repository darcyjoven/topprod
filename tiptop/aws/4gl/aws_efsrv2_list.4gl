# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aws_efsrv2_list
# Descriptions...: EasyFlow整合服務維護作業
# Date & Author..: No.FUN-B30003 11/03/23 Jay  
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正

DATABASE ds
 
#FUN-B30003
 
GLOBALS "../../config/top.global"
 
DEFINE   g_wao1                DYNAMIC ARRAY of RECORD  #單身:TIPTOP服務清單  
            wao02                 LIKE wao_file.wao02,
            wao03                 LIKE wao_file.wao03
                               END RECORD
DEFINE   g_wao1_t              RECORD                   # 變數舊值
            wao02                 LIKE wao_file.wao02,
            wao03                 LIKE wao_file.wao03
                               END RECORD
DEFINE   g_wao2                DYNAMIC ARRAY of RECORD  #單身:EasyFlow服務清單    
            wao02                 LIKE wao_file.wao02,
            wao03                 LIKE wao_file.wao03 
                               END RECORD
DEFINE   g_wao2_t              RECORD                   # 變數舊值    
            wao02                 LIKE wao_file.wao02,
            wao03                 LIKE wao_file.wao03 
                               END RECORD 
DEFINE   g_cnt                 LIKE type_file.num10,  
         g_wc                  STRING,
         g_wc1                 STRING,
         g_sql                 STRING,
         g_rec_b               LIKE type_file.num5,              # TIPTOP單身筆數
         g_rec_b1              LIKE type_file.num5,              # EasyFlow單身筆數
         l_ac                  LIKE type_file.num5               # 目前處理的ARRAY CNT
DEFINE   g_msg                 STRING
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5
DEFINE   g_b_cmd               LIKE type_file.chr1          
DEFINE   g_page_choice         LIKE type_file.chr20              # 目前所在page
DEFINE   g_win_curr            ui.Window
DEFINE   g_frm_curr            ui.Form
DEFINE   g_node_item           om.DomNode
 
MAIN
   DEFINE   p_row,p_col           LIKE type_file.num5
   DEFINE   l_time                LIKE type_file.chr8  # 計算被使用時間
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
      DEFER INTERRUPT                             # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AWS")) THEN
      EXIT PROGRAM
   END IF
 
  # CALL cl_used(g_prog,l_time,1)             # 計算使用時間 (進入時間)     #FUN-B80064    MARK
  # RETURNING l_time            #FUN-B80064  MARK
    CALL cl_used(g_prog,g_time,1)             # 計算使用時間 (進入時間)     #FUN-B80064    ADD
    RETURNING g_time            #FUN-B80064  ADD
 
   OPEN WINDOW aws_efsrv2_list_w AT p_row,p_col WITH FORM "aws/42f/aws_efsrv2_list"
      ATTRIBUTE(STYLE=g_win_style CLIPPED)
 
   CALL cl_ui_init()

   LET g_page_choice = "tp_list"
   LET g_wc = " 1=1 "
   LET g_wc1 = " 1=1 "
   CALL efsrv2_list_tp_b_fill(g_wc)                    # TIPTOP服務單身
   CALL efsrv2_list_ef_b_fill(g_wc1)                   # EasyFlow服務單身
   CALL efsrv2_list_menu() 
 
   CLOSE WINDOW aws_efsrv2_list_w                       # 結束畫面
  # CALL cl_used(g_prog,l_time,2)             # 計算使用時間 (退出時間)     #FUN-B80064    MARK

  # RETURNING l_time            #FUN-B80064  MARK
    CALL cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間)     #FUN-B80064    ADD
    RETURNING g_time            #FUN-B80064  ADD
END MAIN
 
FUNCTION efsrv2_list_menu()
   DEFINE l_wao01   LIKE wao_file.wao01
   DEFINE l_wao02   LIKE wao_file.wao02
 
   WHILE TRUE
      CASE g_page_choice
         WHEN "tp_list"                          # TIPTOP接口服務清單
            CALL efsrv2_list_tp_bp("G")

         WHEN "ef_list"                          # EasyFlow接口服務清單
            CALL efsrv2_list_ef_bp("G")
      END CASE
      
      CASE g_action_choice
         WHEN "tp_detail"
            LET g_action_choice = "detail"
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL efsrv2_list_tp_b()
            END IF
            
         WHEN "ef_detail"
            LET g_action_choice = "detail" 
            IF cl_chk_act_auth() THEN
               LET g_b_cmd = 'u'
               CALL efsrv2_list_ef_b()
            END IF
 
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL efsrv2_list_q()
            END IF
            
         WHEN "help"                             # H.求助
            CALL cl_show_help()
            
         WHEN "exit"                             # Esc.結束
            EXIT WHILE
            
         WHEN "controlg"                         # KEY(CONTROL-G)
            CALL cl_cmdask()

         WHEN "exporttoexcel"                    # 匯出excel
            IF cl_chk_act_auth() THEN
               LET g_win_curr = ui.Window.getCurrent()
               LET g_frm_curr = g_win_curr.getForm()
               CASE g_page_choice
                 WHEN "tp_list"
                      LET g_node_item = g_frm_curr.findNode("Page", "page_tp")
                      CALL cl_export_to_excel(g_node_item, base.TypeInfo.create(g_wao1),'','')
                 WHEN "ef_list"
                      LET g_node_item = g_frm_curr.findNode("Page", "page_ef")
                      CALL cl_export_to_excel(g_node_item, base.TypeInfo.create(g_wao2),'','')
               END CASE
            END IF

         WHEN "related_document"
            IF cl_chk_act_auth() THEN 
               LET l_wao02 = ""
               CASE g_page_choice
                 WHEN "tp_list"
                      IF g_wao1[l_ac].wao02 IS NOT NULL THEN
                         LET l_wao01 = "T"
                         LET l_wao02 = g_wao1[l_ac].wao02
                      END IF
                 WHEN "ef_list"
                      IF g_wao2[l_ac].wao02 IS NOT NULL THEN
                         LET l_wao01 = "E"
                         LET l_wao02 = g_wao2[l_ac].wao02
                      END IF
               END CASE
               
               IF l_wao02 IS NOT NULL THEN
                  LET g_doc.column1 = "wao01"
                  LET g_doc.value1 = l_wao01
                  LET g_doc.column2 = "wao02"
                  LET g_doc.value2 = l_wao02
                  CALL cl_doc()
               END IF
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION efsrv2_list_tp_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc   STRING 

   #select sql在取出TIPTOP服務
   LET g_sql = "SELECT wao02, wan06 as wao03 FROM wao_file ",
               "  LEFT OUTER JOIN wan_file ",
               "    ON wan01 = 'wao_file' AND wan02 = 'wao02' AND ",
               "       wan04 = wao02 AND wan05 = ", g_lang ,
               "  WHERE wao01 = 'T' ",
               "  ORDER BY wao02"

    PREPARE efsrv2_list_tp_prepare FROM g_sql           #預備一下
    DECLARE wao_tp_curs CURSOR FOR efsrv2_list_tp_prepare
 
    CALL g_wao1.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0

    FOREACH wao_tp_curs INTO g_wao1[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wao1.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
END FUNCTION

FUNCTION efsrv2_list_ef_b_fill(p_wc)              #BODY FILL UP
   DEFINE p_wc   STRING 

   #select sql在取出EasyFlow服務
   LET g_sql = "SELECT wao02, wan06 as wao03 FROM wao_file ",
               "  LEFT OUTER JOIN wan_file ",
               "    ON wan01 = 'wao_file' AND wan02 = 'wao02' AND ",
               "       wan04 = wao02 AND wan05 = ", g_lang ,
               "  WHERE wao01 = 'E' ",
               "  ORDER BY wao02"

    PREPARE efsrv2_list_ef_prepare FROM g_sql           #預備一下
    DECLARE wao_ef_curs CURSOR FOR efsrv2_list_ef_prepare
 
    CALL g_wao2.clear()
 
    LET g_cnt = 1
    LET g_rec_b1 = 0

    FOREACH wao_ef_curs INTO g_wao2[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b1 = g_rec_b1 + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_wao2.deleteElement(g_cnt)
 
    LET g_rec_b1 = g_cnt - 1
    LET g_cnt = 0
END FUNCTION

FUNCTION efsrv2_list_tp_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DISPLAY ARRAY g_wao2 TO s_wao2.*
      BEFORE DISPLAY
         EXIT DISPLAY  
   END DISPLAY

   DISPLAY ARRAY g_wao1 TO s_wao1.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         CALL cl_set_act_visible("page_tp", TRUE)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY 

      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="tp_detail"
         LET l_ac = 1
         EXIT DISPLAY
            
      ON ACTION accept
         LET g_action_choice="tp_detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY 
            
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY 

      ON ACTION ef_list                          # EasyFlow服務清單
         LET g_page_choice = "ef_list"
         EXIT DISPLAY  
            
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY 
       
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                 # 相關文件
         LET g_action_choice="related_document"
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

FUNCTION efsrv2_list_ef_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_wao1 TO s_wao1.*
      BEFORE DISPLAY
         EXIT DISPLAY  
   END DISPLAY

   DISPLAY ARRAY g_wao2 TO s_wao2.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
         CALL cl_set_act_visible("page_ef", TRUE)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         EXIT DISPLAY 

      ON ACTION query                            # Q.查詢
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice="ef_detail"
         LET l_ac = 1
         EXIT DISPLAY
            
      ON ACTION accept
         LET g_action_choice="ef_detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY 
            
      ON ACTION cancel
          LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DISPLAY 

      ON ACTION tp_list                          # TIPTOP服務清單
         LET g_page_choice = "tp_list"
         EXIT DISPLAY  
                              
      ON ACTION help                             # H.說明
         LET g_action_choice="help"
         EXIT DISPLAY 
            
      ON ACTION exit                             # Esc.結束
         LET g_action_choice="exit"
         EXIT DISPLAY 
       
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      ON ACTION related_document                 # 相關文件
         LET g_action_choice="related_document"
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
 
FUNCTION efsrv2_list_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1

   IF g_page_choice = "tp_list" AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("tp_wao02", TRUE)
   END IF

   IF g_page_choice = "ef_list" AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("ef_wao02", TRUE)
   END IF
 
END FUNCTION
 
FUNCTION efsrv2_list_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
 
    IF (NOT g_before_input_done) THEN       
       IF p_cmd = 'u' AND g_page_choice = "tp_list" THEN
           CALL cl_set_comp_entry("tp_wao02",FALSE)
       END IF

       IF p_cmd = 'u' AND g_page_choice = "ef_list" THEN
           CALL cl_set_comp_entry("ef_wao02",FALSE)
       END IF
   END IF
END FUNCTION

FUNCTION efsrv2_list_q()                            #Query 查詢

   MESSAGE "" 
   CLEAR FORM  
   CALL g_wao1.clear()
   CALL g_wao2.clear()

   LET g_wc = " 1=1 "
   LET g_wc1 = " 1=1 "
 
   CALL efsrv2_list_curs()                     #取得查詢條件
   IF INT_FLAG THEN                            #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   
END FUNCTION

FUNCTION efsrv2_list_curs()                      # QBE 查詢資料
 
   CLEAR FORM  
   CALL g_wao1.clear()
   CALL g_wao2.clear()

   LET g_wc = " 1=1 "
   LET g_wc1 = " 1=1 "

   #輸入TIPTOP服務的查詢條件
   CONSTRUCT g_wc ON wao02, wao03
        FROM s_wao1[1].tp_wao02, s_wao1[1].tp_wao03

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
   
      ON ACTION about 
         CALL cl_about() 

      ON ACTION HELP  
         CALL cl_show_help()

      ON ACTION controlg 
         CALL cl_cmdask() 
   END CONSTRUCT

   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_wc1 = NULL
      RETURN 
   END IF
   
   #輸入EasyFlow服務的查詢條件
   CONSTRUCT g_wc1 ON wao02, wao03
        FROM s_wao2[1].ef_wao02, s_wao2[1].ef_wao03

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
  
      ON ACTION about 
         CALL cl_about() 

      ON ACTION HELP  
         CALL cl_show_help()

      ON ACTION controlg 
         CALL cl_cmdask() 
   END CONSTRUCT
        
   IF INT_FLAG THEN 
      LET INT_FLAG = 0
      LET g_wc = NULL
      LET g_wc1 = NULL
      RETURN 
   END IF
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED, cl_get_extra_cond('waouser', 'waogrup')
   LET g_wc1 = g_wc1 CLIPPED, cl_get_extra_cond('waouser', 'waogrup')

   CALL efsrv2_list_tp_b_fill(g_wc)                    # TIPTOP服務單身
   CALL efsrv2_list_ef_b_fill(g_wc1)                   # EasyFlow服務單身
END FUNCTION

FUNCTION efsrv2_list_tp_b()
   DEFINE l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT  SMALLINT
          l_n             LIKE type_file.num5,                 #檢查重複用         SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否         
          p_cmd           LIKE type_file.chr1,                 #處理狀態           
          l_allow_insert  LIKE type_file.chr1,                 #可新增否
          l_allow_delete  LIKE type_file.chr1,                 #可刪除否
          l_on_change     LIKE type_file.chr1,                 #是否變更wao03欄位
          l_wao03_new     LIKE wao_file.wao03,
          l_cnt           LIKE type_file.num5,
          l_str           STRING
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT wao02, wan06 as wao03 FROM wao_file ",
                      "  LEFT OUTER JOIN wan_file ",
                      "    ON wan01 = 'wao_file' AND wan02 = 'wao02' AND ",
                      "       wan04 = wao02 AND wan05 = ", g_lang ,
                      "  WHERE wao01 = 'T' AND wao02 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE efsrv2_list_tp_bc CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_wao1 WITHOUT DEFAULTS FROM s_wao1.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         LET l_on_change = TRUE
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'                                                    
            LET g_before_input_done = FALSE                                      
            CALL efsrv2_list_set_entry(p_cmd)                                           
            CALL efsrv2_list_set_no_entry(p_cmd)                                        
            LET g_before_input_done = TRUE                                                
            LET g_wao1_t.* = g_wao1[l_ac].*          #BACKUP
            OPEN efsrv2_list_tp_bc USING g_wao1_t.wao02
            IF STATUS THEN
               CALL cl_err("OPEN efsrv2_list_tp_bc:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH efsrv2_list_tp_bc INTO g_wao1[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wao1_t.wao02, SQLCA.sqlcode, 1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'                                                        
         LET g_before_input_done = FALSE                                        
         CALL efsrv2_list_set_entry(p_cmd)                                             
         CALL efsrv2_list_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE       
         
         INITIALIZE g_wao1[l_ac].* TO NULL    
         
         LET g_wao1_t.* = g_wao1[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         NEXT FIELD tp_wao02
 
      AFTER INSERT
         DISPLAY "AFTER INSERT" 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE efsrv2_list_tp_bc
            CANCEL INSERT
         END IF
 
         BEGIN WORK 
         INSERT INTO wao_file(wao01, wao02, wao03, 
                              waodate, waouser, waogrup, waooriu, waoorig) 
                VALUES('T', g_wao1[l_ac].wao02, g_wao1[l_ac].wao03, 
                       g_today, g_user, g_grup, g_user, g_grup) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wao_file",g_wao1[l_ac].wao02,"",SQLCA.sqlcode,"","",1) 
            ROLLBACK WORK 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b = g_rec_b + 1
            COMMIT WORK  
         END IF
 
      AFTER FIELD tp_wao02                     #check 服務代碼是否重複
         IF NOT cl_null(g_wao1[l_ac].wao02) THEN
            IF g_wao1[l_ac].wao02 != g_wao1_t.wao02 OR
               g_wao1_t.wao02 IS NULL THEN
               SELECT count(*) INTO l_n FROM wao_file
                 WHERE wao01 = 'T' AND wao02 = g_wao1[l_ac].wao02
               IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_wao1[l_ac].wao02 = g_wao1_t.wao02
                   NEXT FIELD tp_wao02
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_wao1_t.wao02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK  
               CANCEL DELETE
            END IF

            INITIALIZE g_doc.* TO NULL   
            LET g_doc.column1 = "wao01"         
            LET g_doc.value1 = "T"
            LET g_doc.column1 = "wao02"     
            LET g_doc.value1 = g_wao1[l_ac].wao02
            CALL cl_del_doc() 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF 

            DELETE FROM wao_file WHERE wao01 = "T" AND wao02 = g_wao1_t.wao02
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","wao_file",g_wao1_t.wao02,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b = g_rec_b - 1  
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_wao1[l_ac].* = g_wao1_t.*
           CLOSE efsrv2_list_tp_bc
           ROLLBACK WORK
           EXIT INPUT
         END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err(g_wao1[l_ac].wao02, -263, 0)
            LET g_wao1[l_ac].* = g_wao1_t.*
         ELSE
            UPDATE wao_file SET wao02 = g_wao1[l_ac].wao02,
                                wao03 = g_wao1[l_ac].wao03,
                                waomodu = g_user,
                                waodate = g_today,
                                waogrup = g_grup
            WHERE wao01 = "T" AND wao02 = g_wao1_t.wao02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","wao_file",g_wao1_t.wao02,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK 
               LET g_wao1[l_ac].* = g_wao1_t.*
            ELSE
               CALL cl_msg('Update O.K')
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()            # 新增
         LET l_ac_t = l_ac                # 新增
 
         IF INT_FLAG THEN         
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_wao1[l_ac].* = g_wao1_t.*
            END IF
            CLOSE efsrv2_list_tp_bc             # 新增
            ROLLBACK WORK                       # 新增
            EXIT INPUT
         END IF
         CLOSE efsrv2_list_tp_bc                # 新增
         COMMIT WORK

      BEFORE FIELD tp_wao03
         LET l_on_change = TRUE
         LET l_wao03_new = ""
         DISPLAY BY NAME g_wao1[l_ac].wao03
 
      ON CHANGE tp_wao03
         DISPLAY BY NAME g_wao1[l_ac].wao03
         CALL cl_show_fld_cont()
 
      AFTER FIELD tp_wao03
         #資料如果沒有做過變更,不需從DB update此欄位
         IF g_wao1[l_ac].wao03 = g_wao1_t.wao03 THEN
            LET l_on_change = FALSE
         END IF
         
         IF NOT cl_null(g_wao1[l_ac].wao02) AND l_on_change THEN
            LET l_wao03_new = g_wao1[l_ac].wao03
            #如果沒有開窗輸入說明資料,則直接在這裡INSERT/UPDATE
            SELECT COUNT(*)INTO l_cnt FROM wan_file
              WHERE wan01 = 'wao_file' AND wan02 = 'wao02' AND 
                    wan03 = 'T' AND wan04 = g_wao1[l_ac].wao02 AND 
                    wan05 = g_lang
            IF l_cnt = 0 THEN
               INSERT INTO wan_file(wan01,wan02,wan03,wan04,wan05,wan06)
                      VALUES ('wao_file', 'wao02', 'T', g_wao1[l_ac].wao02, g_lang, l_wao03_new)
               IF SQLCA.sqlcode THEN
                  LET l_str = "Insert ",g_lang,":",l_wao03_new, " into wan_file failed"
                  CALL cl_err(l_str, "!" , 1)
                  LET l_wao03_new = ""
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_on_change = FALSE
                  LET l_wao03_new = g_wao1[l_ac].wao03
               END IF
            ELSE
               UPDATE wan_file
                  SET wan06 = l_wao03_new
               WHERE wan01 = 'wao_file'
                  AND wan02 = 'wao02'
                  AND wan03 = 'T'
                  AND wan04 = g_wao1[l_ac].wao02
                  AND wan05 = g_lang
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_wao03_new, SQLCA.sqlcode, 1)
                  LET l_wao03_new = ""
                  LET l_on_change = FALSE
                  LET l_wao03_new = g_wao1[l_ac].wao03
               ELSE
                  MESSAGE 'UPDATE O.K'
               END IF
            END IF
         END IF
         
         IF NOT cl_null(g_wao1[l_ac].wao02) AND l_wao03_new <> g_wao1[l_ac].wao03 THEN
            DISPLAY BY NAME g_wao1[l_ac].wao03
            CALL cl_show_fld_cont()
         END IF
           
      ON ACTION update_name_tp
         IF NOT cl_null(g_wao1[l_ac].wao02) THEN
            CALL aws_name_update("wao_file", "wao02", "T", g_wao1[l_ac].wao02, g_wao1[l_ac].wao03)
                 RETURNING g_wao1[l_ac].wao03
            LET l_on_change = FALSE
            LET l_wao03_new = g_wao1[l_ac].wao03
         ELSE
            #顯示錯誤訊息
            CALL cl_err_msg("", "aws-369", "wao02", 1)
            NEXT FIELD tp_wao02
         END IF
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(tp_wao02) AND l_ac > 1 THEN
            LET g_wao1[l_ac].* = g_wao1[l_ac-1].*
            NEXT FIELD tp_wao02
         END IF
 
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
   END INPUT
 
   CLOSE efsrv2_list_tp_bc
   COMMIT WORK
END FUNCTION

FUNCTION efsrv2_list_ef_b()
   DEFINE l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT  SMALLINT
          l_n             LIKE type_file.num5,                 #檢查重複用         SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        
          p_cmd           LIKE type_file.chr1,                 #處理狀態        
          l_allow_insert  LIKE type_file.chr1,                 #可新增否
          l_allow_delete  LIKE type_file.chr1,                 #可刪除否
          l_on_change     LIKE type_file.chr1,                 #是否變更wao03欄位
          l_wao03_new     LIKE wao_file.wao03,
          l_cnt           LIKE type_file.num5,
          l_str           STRING
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')

   LET g_forupd_sql = "SELECT wao02, wan06 as wao03 FROM wao_file ",
                      "  LEFT OUTER JOIN wan_file ",
                      "    ON wan01 = 'wao_file' AND wan02 = 'wao02' AND ",
                      "       wan04 = wao02 AND wan05 = ", g_lang ,
                      "  WHERE wao01 = 'E' AND wao02 =? FOR UPDATE"

   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE efsrv2_list_ef_bc CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_wao2 WITHOUT DEFAULTS FROM s_wao2.*
         ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b1 >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'                                                    
            LET g_before_input_done = FALSE                                      
            CALL efsrv2_list_set_entry(p_cmd)                                           
            CALL efsrv2_list_set_no_entry(p_cmd)                                        
            LET g_before_input_done = TRUE                                                
            LET g_wao2_t.* = g_wao2[l_ac].*          #BACKUP
            OPEN efsrv2_list_ef_bc USING g_wao2_t.wao02
            IF STATUS THEN
               CALL cl_err("OPEN efsrv2_list_ef_bc:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH efsrv2_list_ef_bc INTO g_wao2[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wao2_t.wao02, SQLCA.sqlcode, 1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'                                                        
         LET g_before_input_done = FALSE                                        
         CALL efsrv2_list_set_entry(p_cmd)                                             
         CALL efsrv2_list_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE       
         
         INITIALIZE g_wao2[l_ac].* TO NULL    
         
         LET g_wao2_t.* = g_wao2[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont() 
         NEXT FIELD ef_wao02
 
      AFTER INSERT
         DISPLAY "AFTER INSERT" 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE efsrv2_list_ef_bc
            CANCEL INSERT
         END IF
 
         BEGIN WORK 
         INSERT INTO wao_file(wao01, wao02, wao03, 
                              waodate, waouser, waogrup, waooriu, waoorig) 
                VALUES('E', g_wao2[l_ac].wao02, g_wao2[l_ac].wao03, 
                       g_today, g_user, g_grup, g_user, g_grup) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wao_file",g_wao2[l_ac].wao02,"",SQLCA.sqlcode,"","",1) 
            ROLLBACK WORK 
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b1 = g_rec_b1 + 1
            COMMIT WORK  
         END IF
 
      AFTER FIELD ef_wao02                     #check 服務代碼是否重複
         IF NOT cl_null(g_wao2[l_ac].wao02) THEN
            IF g_wao2[l_ac].wao02 != g_wao2_t.wao02 OR
               g_wao2_t.wao02 IS NULL THEN
               SELECT count(*) INTO l_n FROM wao_file
                 WHERE wao01 = 'E' AND wao02 = g_wao2[l_ac].wao02
               IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_wao2[l_ac].wao02 = g_wao2_t.wao02
                   NEXT FIELD ef_wao02
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_wao2_t.wao02 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK  
               CANCEL DELETE
            END IF

            INITIALIZE g_doc.* TO NULL   
            LET g_doc.column1 = "wao01"         
            LET g_doc.value1 = "E"
            LET g_doc.column1 = "wao02"     
            LET g_doc.value1 = g_wao2[l_ac].wao02
            CALL cl_del_doc() 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               ROLLBACK WORK 
               CANCEL DELETE 
            END IF 

            DELETE FROM wao_file WHERE wao01 = "E" AND wao02 = g_wao2_t.wao02
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","wao_file",g_wao2_t.wao02,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b1 = g_rec_b1 - 1  
            COMMIT WORK 
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_wao2[l_ac].* = g_wao2_t.*
           CLOSE efsrv2_list_ef_bc
           ROLLBACK WORK
           EXIT INPUT
         END IF

         IF l_lock_sw = "Y" THEN
            CALL cl_err(g_wao2[l_ac].wao02, -263, 0)
            LET g_wao2[l_ac].* = g_wao2_t.*
         ELSE
            UPDATE wao_file SET wao02 = g_wao2[l_ac].wao02,
                                wao03 = g_wao2[l_ac].wao03,
                                waomodu = g_user,
                                waodate = g_today,
                                waogrup = g_grup
            WHERE wao01 = "E" AND wao02 = g_wao2_t.wao02
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","wao_file",g_wao2_t.wao02,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK 
               LET g_wao2[l_ac].* = g_wao2_t.*
            ELSE
               CALL cl_msg('Update O.K')
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()            # 新增
         LET l_ac_t = l_ac                # 新增
 
         IF INT_FLAG THEN         
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_wao2[l_ac].* = g_wao2_t.*
            END IF
            CLOSE efsrv2_list_ef_bc             # 新增
            ROLLBACK WORK                       # 新增
            EXIT INPUT
         END IF
         CLOSE efsrv2_list_ef_bc                # 新增
         COMMIT WORK
      
      BEFORE FIELD ef_wao03
         LET l_on_change = TRUE
         LET l_wao03_new = ""
 
      ON CHANGE ef_wao03
         DISPLAY BY NAME g_wao2[l_ac].wao03
         CALL cl_show_fld_cont()
 
      AFTER FIELD ef_wao03
         #資料如果沒有做過變更,不需從DB update此欄位
         IF g_wao2[l_ac].wao03 = g_wao2_t.wao03 THEN
            LET l_on_change = FALSE
         END IF
         
         IF NOT cl_null(g_wao2[l_ac].wao02) AND l_on_change THEN
            LET l_wao03_new = g_wao2[l_ac].wao03
            #如果沒有開窗輸入說明資料,則直接在這裡INSERT/UPDATE
            SELECT COUNT(*)INTO l_cnt FROM wan_file
              WHERE wan01 = 'wao_file' AND wan02 = 'wao02' AND 
                    wan03 = 'E' AND wan04 = g_wao2[l_ac].wao02 AND 
                    wan05 = g_lang
            IF l_cnt = 0 THEN
               INSERT INTO wan_file(wan01,wan02,wan03,wan04,wan05,wan06)
                      VALUES ('wao_file', 'wao02', 'E', g_wao2[l_ac].wao02, g_lang, l_wao03_new)
               IF SQLCA.sqlcode THEN
                  LET l_str = "Insert ",g_lang,":",l_wao03_new, " into wan_file failed"
                  CALL cl_err(l_str, "!" , 1)
                  LET l_wao03_new = ""
               ELSE
                  MESSAGE 'INSERT O.K'
                  LET l_on_change = FALSE
                  LET l_wao03_new = g_wao2[l_ac].wao03
               END IF
            ELSE
               UPDATE wan_file
                  SET wan06 = l_wao03_new
               WHERE wan01 = 'wao_file'
                  AND wan02 = 'wao02'
                  AND wan03 = 'E'
                  AND wan04 = g_wao2[l_ac].wao02
                  AND wan05 = g_lang
               IF SQLCA.sqlcode THEN
                  CALL cl_err(l_wao03_new, SQLCA.sqlcode, 1)
                  LET l_wao03_new = ""
                  LET l_on_change = FALSE
                  LET l_wao03_new = g_wao2[l_ac].wao03
               ELSE
                  MESSAGE 'UPDATE O.K'
               END IF
            END IF
         END IF
         
         IF NOT cl_null(g_wao2[l_ac].wao02) AND l_wao03_new <> g_wao2[l_ac].wao03 THEN
            DISPLAY BY NAME g_wao2[l_ac].wao03
            CALL cl_show_fld_cont()
         END IF
           
      ON ACTION update_name_ef
         IF NOT cl_null(g_wao2[l_ac].wao02) THEN
            CALL aws_name_update("wao_file", "wao02", "E", g_wao2[l_ac].wao02, g_wao2[l_ac].wao03)
                 RETURNING g_wao2[l_ac].wao03
            LET l_on_change = FALSE
            LET l_wao03_new = g_wao2[l_ac].wao03
         ELSE
            #顯示錯誤訊息
            CALL cl_err_msg("", "aws-369", "wao02", 1)
            NEXT FIELD ef_wao03
         END IF
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(ef_wao02) AND l_ac > 1 THEN
            LET g_wao2[l_ac].* = g_wao2[l_ac-1].*
            NEXT FIELD ef_wao02
         END IF
 
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
   END INPUT
 
   CLOSE efsrv2_list_ef_bc
   COMMIT WORK
END FUNCTION

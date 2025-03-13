# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: anmi003.4gl
# Descriptions...: 網絡銀行編碼維護作業
# Date & Author..: FUN-B30213 11/05/17 By lixia 
# Modify.........: No:FUN-D30032 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_noc          DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        noc01       LIKE noc_file.noc01,     #接口銀行編碼
        noc02       LIKE noc_file.noc02,     #編碼說明
        nocacti     LIKE noc_file.nocacti    #有效否
                    END RECORD,
    g_noc_t         RECORD                   #程式變數 (舊值)
        noc01       LIKE noc_file.noc01,     #接口銀行編碼
        noc02       LIKE noc_file.noc02,     #編碼說明
        nocacti     LIKE noc_file.nocacti    #有效否
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,    
    l_ac            LIKE type_file.num5     
 
DEFINE g_forupd_sql          STRING          #SELECT ... FOR UPDATE SQL
DEFINE g_cnt                 LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5     
DEFINE g_row_count           LIKE type_file.num5       
DEFINE g_curs_index          LIKE type_file.num5  

MAIN
   DEFINE p_row,p_col   LIKE type_file.num5    
 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理 
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
   
   LET p_row = 4 LET p_col = 3
   OPEN WINDOW i003_w AT p_row,p_col WITH FORM "anm/42f/anmi003"
   ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
   CALL cl_ui_init()

   LET g_wc2 = '1=1'
   CALL i003_b_fill(g_wc2)
   CALL i003_menu()
   CLOSE WINDOW i003_w                 
   CALL  cl_used(g_prog,g_time,2)  RETURNING g_time  
   
END MAIN
 
FUNCTION i003_menu()
 
   WHILE TRUE
      CALL i003_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i003_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i003_b()
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
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_noc[l_ac].noc01 IS NOT NULL THEN
                  LET g_doc.column1 = "noc01"
                  LET g_doc.value1 = g_noc[l_ac].noc01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_noc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i003_q()
   CLEAR FORM
   CALL g_noc.clear()
   
   CONSTRUCT g_wc2 ON noc01,noc02,nocacti 
        FROM s_noc[1].noc01,s_noc[1].noc02,s_noc[1].nocacti           
      
      BEFORE CONSTRUCT
         CALL cl_qbe_init() 

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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('nocuser', 'nocgrup') 

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   
   CALL i003_b_fill(g_wc2) 
END FUNCTION
 
FUNCTION i003_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                 #未取消的ARRAY CNT   
   l_n             LIKE type_file.num5,                 #檢查重複用             
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否           
   p_cmd           LIKE type_file.chr1,                 #處理狀態               
   l_allow_insert  LIKE type_file.chr1,                 #可新增否
   l_allow_delete  LIKE type_file.chr1                  #可刪除否
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""

   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT noc01,noc02,nocacti", 
                       "  FROM noc_file WHERE noc01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i003_bcl CURSOR FROM g_forupd_sql     
 
   INPUT ARRAY g_noc WITHOUT DEFAULTS FROM s_noc.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd='' 
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'         
         LET l_n = ARR_COUNT()       
  
         IF g_rec_b>=l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_noc_t.* = g_noc[l_ac].* 
            OPEN i003_bcl USING g_noc_t.noc01
            IF STATUS THEN
               CALL cl_err("OPEN i003_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i003_bcl INTO g_noc[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_noc_t.noc01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF           
            CALL cl_show_fld_cont()     
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_noc[l_ac].* TO NULL  
         LET g_noc[l_ac].nocacti = 'Y'   
         LET g_noc_t.* = g_noc[l_ac].*      
         CALL cl_show_fld_cont()    
         NEXT FIELD noc01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i003_bcl
            CANCEL INSERT
         END IF
         INSERT INTO noc_file(noc01,noc02,nocacti,nocuser,nocgrup,nocdate,nocoriu,nocorig)              
         VALUES(g_noc[l_ac].noc01,g_noc[l_ac].noc02,g_noc[l_ac].nocacti,g_user,g_grup,g_today,g_user,g_grup) 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","noc_file",g_noc[l_ac].noc01,"",SQLCA.sqlcode,"","",1) 
            ROLLBACK WORK          
            CANCEL INSERT        
         ELSE
            LET g_rec_b = g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
         COMMIT WORK
 
      AFTER FIELD noc01     #check 編號是否重複
         IF NOT cl_null(g_noc[l_ac].noc01) THEN
            IF g_noc[l_ac].noc01 != g_noc_t.noc01 OR g_noc_t.noc01 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM noc_file
                WHERE noc01 = g_noc[l_ac].noc01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_noc[l_ac].noc01 = g_noc_t.noc01
                  NEXT FIELD noc01
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_noc_t.noc01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               ROLLBACK WORK      
               CANCEL DELETE
            END IF
            DELETE FROM noc_file WHERE noc01 = g_noc_t.noc01
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","noc_file",g_noc_t.noc01,"",SQLCA.sqlcode,"","",1)
                ROLLBACK WORK     
                CANCEL DELETE
                EXIT INPUT
            END IF
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_noc[l_ac].* = g_noc_t.*
            CLOSE i003_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw="Y" THEN
            CALL cl_err(g_noc[l_ac].noc01,-263,0)
            LET g_noc[l_ac].* = g_noc_t.*
         ELSE          
            UPDATE noc_file SET noc01 = g_noc[l_ac].noc01,
                                noc02 = g_noc[l_ac].noc02,
                                nocacti = g_noc[l_ac].nocacti,
                                nocmodu = g_user,
                                nocdate = g_today
             WHERE noc01 = g_noc_t.noc01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","noc_file",g_noc_t.noc01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK   
               LET g_noc[l_ac].* = g_noc_t.* 
            END IF
            COMMIT WORK
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()        
      #  LET l_ac_t = l_ac   #FUN-D30032 mark           
 
         IF INT_FLAG THEN               
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_noc[l_ac].* = g_noc_t.*
            #FUN-D30032--add--str--
              ELSE
                 CALL g_noc.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i003_bcl              
            ROLLBACK WORK                 
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D30032 add
         CLOSE i003_bcl               
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(noc01) AND l_ac > 1 THEN
            LET g_noc[l_ac].* = g_noc[l_ac-1].*
            NEXT FIELD noc01
         END IF 
     
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
 
      ON ACTION HELP         
         CALL cl_show_help()  
   END INPUT
   CLOSE i003_bcl
   COMMIT WORK
END FUNCTION 
 
FUNCTION i003_b_fill(p_wc2)    
   DEFINE p_wc2           STRING
   
   LET g_sql = "SELECT noc01,noc02,nocacti ",
               "  FROM noc_file ",
               " WHERE ", p_wc2 CLIPPED,
               " ORDER BY noc01"   
   PREPARE i003_pb FROM g_sql
   DECLARE noc_curs CURSOR FOR i003_pb 
   CALL g_noc.clear()
   LET g_cnt = 1
   FOREACH noc_curs INTO g_noc[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_noc.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0 
END FUNCTION
 
FUNCTION i003_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0              
   LET g_curs_index = 0              
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_noc TO s_noc.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
     
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
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
         
      ON ACTION related_document  
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
     
      AFTER DISPLAY
         CONTINUE DISPLAY
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-B30213--end--

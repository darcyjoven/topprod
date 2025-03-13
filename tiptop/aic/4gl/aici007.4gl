# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#                                                                                                                                   
# Pattern name...:aici007.4gl                                                                                                       
# Descriptions...:ICD單價公式計算維護作業                                                                                                     
# Date & Author..:07/11/20 By destiny  No.FUN-7B0074
# Modify.........: No.FUN-830065 08/03/24 By destiny 增加“相關文件”action
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-D40030 13/04/07 By xuxz 單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-7B0074--begin--
DEFINE
     g_data         RECORD
        operator1   LIKE type_file.chr1,
        operator2   LIKE type_file.chr1,
        des1        LIKE type_file.chr50,
        des2        LIKE type_file.chr50,
        formular1   LIKE ich_file.ich01,
        formular2   LIKE ich_file.ich01,
        operand     LIKE type_file.chr1
                    END RECORD,
     g_ich       DYNAMIC ARRAY OF RECORD    #程序變量(Program Variables)
        ich01    LIKE ich_file.ich01,       #公式代碼
        ich02    LIKE ich_file.ich02        #公式
                    END RECORD,
     g_ich_t     RECORD                     #程序變量 (舊值)
        ich01    LIKE ich_file.ich01,       #公式代碼
        ich02    LIKE ich_file.ich02        #公式
                    END RECORD,
     g_wc2,g_sql    string, 
     g_rec_b        LIKE type_file.num5,    #單身筆數
     l_ac           LIKE type_file.num5     #目前處理的ARRAY CNT
 
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10   
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose
MAIN
DEFINE p_row,p_col   LIKE type_file.num5
    OPTIONS                                #改變一些系統默認值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程序處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIC")) THEN
      EXIT PROGRAM
   END IF
 
   IF NOT s_industry('icd') THEN                                                                                                    
      CALL cl_err('','aic-999',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF
 
   CALL cl_used(g_prog,g_time,1)        #計算使用時間 (進入時間)
        RETURNING g_time
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW i007_w AT p_row,p_col WITH FORM "aic/42f/aici007"  
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' CALL i007_b_fill(g_wc2)
   CALL i007_menu()
   CLOSE WINDOW i007_w                  #結束畫面
   CALL cl_used(g_prog,g_time,2)
        RETURNING g_time
END MAIN
 
FUNCTION i007_menu()
 
   WHILE TRUE
      CALL i007_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i007_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i007_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "output"                                                                                                              
            IF cl_chk_act_auth() THEN                                                                                               
              CALL i007_out()                                                                                                       
            END IF 
 
         WHEN "exporttoexcel"  
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),
                                      base.TypeInfo.create(g_ich),'','')
            END IF
#No.FUN-830065--begin--
         WHEN "related_document"  #相關文件                                                                                         
              IF cl_chk_act_auth() THEN                                                                                             
                 IF g_ich[l_ac].ich01 IS NOT NULL AND l_ac != 0 THEN                                                                                        
                    LET g_doc.column1 = "ich01"                                                                                        
                    LET g_doc.value1 = g_ich[l_ac].ich01                                                                                         
                    CALL cl_doc()                                                                                                      
                 END IF
               END IF  
#No.FUN-830065--end--                                                                                                             
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i007_q()
   CALL i007_b_askkey()
END FUNCTION
 
FUNCTION i007_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,              #檢查重復用
    l_lock_sw       LIKE type_file.chr1,              #單身鎖住否
    p_cmd           LIKE type_file.chr1,              #處理狀態
    l_allow_insert  LIKE type_file.chr1,              #可新增否
    l_allow_delete  LIKE type_file.chr1,              #可刪除否
    l_des1          LIKE type_file.chr50,
    l_des2          LIKE type_file.chr50,
    l_operand       LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ich01,ich02",
                       "  FROM ich_file WHERE ich01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i007_bcl CURSOR FROM g_forupd_sql        # LOCK CURSOR
 
    INPUT ARRAY g_ich WITHOUT DEFAULTS FROM s_ich.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,
                     DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'               #DEFAULT
        LET l_n  = ARR_COUNT()
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_ich_t.* = g_ich[l_ac].*  #BACKUP
 
           LET g_before_input_done = FALSE                                      
           LET g_before_input_done = TRUE 
           OPEN i007_bcl USING g_ich_t.ich01
           IF STATUS THEN
              CALL cl_err("OPEN i007_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i007_bcl INTO g_ich[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ich_t.ich01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_ich[l_ac].* TO NULL
         LET g_ich_t.* = g_ich[l_ac].*         #新輸入數據
         CALL cl_show_fld_cont()
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i007_bcl
           CALL g_ich.deleteElement(l_ac)
           CANCEL INSERT
        END IF
        INSERT INTO ich_file(ich01,ich02,
                             ichacti,ichgrup,ichuser,ichdate,ichoriu,ichorig)
        VALUES(g_ich[l_ac].ich01,g_ich[l_ac].ich02,
               'Y',g_grup,g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN 
           CALL cl_err(g_ich[l_ac].ich01,SQLCA.sqlcode,0)
           CLOSE i007_bcl
           CALL g_ich.deleteElement(l_ac)
           CANCEL INSERT
        ELSE
           MESSAGE 'INSERT O.K'
           LET g_rec_b=g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cnt
        END IF
 
    AFTER FIELD ich01                                   #check 編號是否重復                
        IF NOT cl_null(g_ich[l_ac].ich01) THEN
           IF cl_null(g_ich_t.ich01) OR
              g_ich[l_ac].ich01 != g_ich_t.ich01 THEN
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM ich_file
               WHERE ich01 = g_ich[l_ac].ich01
              IF g_cnt > 0 THEN 
                 CALL cl_err('','-239',1) 
                 LET g_ich[l_ac].ich01 = g_ich_t.ich01
                 NEXT FIELD ich01 
              END IF 
           END IF
           CALL i007_cs_parse(g_ich[l_ac].ich02)
                RETURNING l_des1,l_operand,l_des2
           IF l_des1 = g_ich[l_ac].ich01 OR             #不可等于目前公式代碼                  
              l_des2 = g_ich[l_ac].ich01 THEN
              CALL cl_err('','aic-007',0)
              NEXT FIELD ich01
           END IF
           IF p_cmd = 'u' THEN                          #舊的公式將消失,也不能相同
              IF l_des1 = g_ich_t.ich01 OR
                 l_des2 = g_ich_t.ich01 THEN
                 CALL cl_err('','aic-008',0)
                 NEXT FIELD ich01
              END IF
           END IF
           #檢查運算子,操作數若為公式,公式解開后該層不可有目前公式代碼
           CALL i007_chk_formular(l_des1,l_des2)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD ich01
           END IF
        END IF
 
    BEFORE DELETE                                       #是否取消單身
        IF NOT cl_null(g_ich_t.ich01) THEN
           #檢查是否有其它公式正在使用
           IF NOT i007_chk_usingl(g_ich_t.ich01) THEN CANCEL DELETE END IF
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
           LET g_doc.column1 = "ich01"               #No.FUN-9B0098 10/02/24
           LET g_doc.value1 = g_ich[l_ac].ich01      #No.FUN-9B0098 10/02/24
           CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
           IF l_lock_sw = "Y" THEN 
              CALL cl_err("", -263, 1) 
              CANCEL DELETE 
           END IF 
           DELETE FROM ich_file WHERE ich01 = g_ich_t.ich01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","ich_file",g_ich_t.ich01,"",SQLCA.sqlcode,"","",1)
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
           LET g_ich[l_ac].* = g_ich_t.*                                                                                      
           CLOSE i007_bcl                                                                                                           
           ROLLBACK WORK                                                                                                            
           EXIT INPUT                                                                                                               
        END IF                                                                                                                      
        IF l_lock_sw="Y" THEN                                                                                                       
           CALL cl_err(g_ich[l_ac].ich01,-263,0)                                                                             
           LET g_ich[l_ac].* = g_ich_t.*                                                                                      
        ELSE                                                                                                                        
           IF NOT i007_chk_using() THEN NEXT FIELD ich010 END IF                                                                 
           UPDATE ich_file                                                                                                       
               SET ich01=g_ich[l_ac].ich01,                                                                              
                   ich02=g_ich[l_ac].ich02,                                                                              
                   ichmodu=g_user,ichdate=g_today                                                                             
            WHERE ich01 = g_ich_t.ich01                                                                                  
           IF SQLCA.sqlcode THEN                                                                                                    
              CALL cl_err(g_ich[l_ac].ich01,SQLCA.sqlcode,0)                                                                 
              LET g_ich[l_ac].* = g_ich_t.*                                                                                   
           ELSE                 
              MESSAGE 'UPDATE O.K'                                                                                                  
              COMMIT WORK                                                                                                           
           END IF                                                                                                                   
        END IF 
                                                                                                         
                                                                                                                                    
     AFTER ROW                                                                                                                      
        LET l_ac = ARR_CURR()                                                                                                       
       #LET l_ac_t = l_ac #FUN-D40030 mark
                                                                                                                                    
        IF INT_FLAG THEN                                                                                                            
           CALL cl_err('',9001,0)                                                                                                   
           LET INT_FLAG = 0                                                                                                         
           IF p_cmd='u' THEN                                                                                                        
              LET g_ich[l_ac].* = g_ich_t.*                                                                                   
          #FUN-D40030--add--str
           ELSE
              CALL g_ich.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
          #FUN-D40030--add--end
           END IF                                                                                                                   
           CLOSE i007_bcl                                                                                                           
           ROLLBACK WORK                                                                                                            
           EXIT INPUT                                                                                                               
        END IF                                                                                                                      
        LET l_ac_t = l_ac #FUN-D40030 add
        CLOSE i007_bcl                                                                                                              
        COMMIT WORK 
     ON ACTION set_form                                                                                                             
        CALL i007_more(p_cmd)                                                                                                       
        DISPLAY BY NAME g_ich[l_ac].ich02                                                                                    
                                                                                                                                    
     ON ACTION CONTROLO                                                                                      
         IF INFIELD(ich01) AND l_ac > 1 THEN                                                                                    
             LET g_ich[l_ac].* = g_ich[l_ac-1].*                                                                              
             NEXT FIELD ich01                                                                                                   
         END IF                                                                                                                     
                                                                                                                                    
     ON ACTION CONTROLR                                                                                                             
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
                                                                                                                                    
     END INPUT                                                                                                                      
                                                                                                                                    
    CLOSE i007_bcl                                                                                                                  
    COMMIT WORK                                                                                                                     
END FUNCTION 
 
FUNCTION i007_more(p_cmd)
    DEFINE p_row,p_col   LIKE type_file.num5,
           p_cmd         LIKE type_file.chr1
 
    LET p_row = 2   LET p_col = 30
 
    OPEN WINDOW i007_m_w AT p_row,p_col WITH FORM "aic/42f/aici007_more"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_locale("aici007_more")
    INITIALIZE g_data.* TO NULL
    INPUT BY NAME g_data.operator1,g_data.formular1,g_data.operand,
                  g_data.operator2,g_data.formular2
 
       BEFORE INPUT
          CALL i007_set_data()   #置放資料                                                                                             
          CALL i007_set_entry(p_cmd)                                                                                                   
          CALL i007_set_no_entry(p_cmd)                                                                                                
          CALL i007_set_no_required(p_cmd)                                                                                             
          CALL i007_set_required(p_cmd)     
 
       BEFORE FIELD operator1
          CALL i007_set_entry(p_cmd)
          CALL i007_set_no_required(p_cmd)
 
       AFTER FIELD operator1
          IF NOT cl_null(g_data.operator1) THEN         
             IF g_data.operator1 NOT MATCHES '[0123456789]' THEN
                NEXT FIELD operator1
             END IF
             IF g_data.operator1 MATCHES '[01234589]' THEN
                LET g_data.formular1 = NULL
                LET g_data.des1 = NULL
             END IF
             IF g_data.operator1 = '7' THEN
                LET g_data.des1 = NULL
             END IF
          ELSE
             LET g_data.formular1 = NULL
             LET g_data.des1 = NULL
          END IF
          DISPLAY BY NAME g_data.formular1,g_data.des1
          CALL i007_set_no_entry(p_cmd)
          CALL i007_set_required(p_cmd)
 
       AFTER FIELD formular1
          IF NOT cl_null(g_data.formular1) THEN
             CASE g_data.operator1
                  WHEN '6'   #檢查公式代碼
                      CALL i007_formular1()
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)
                         NEXT FIELD formular1
                      END IF
                  WHEN '7'   #檢查數字
                      IF NOT i007_numchk(g_data.formular1) THEN
                         NEXT FIELD formular1
                      END IF
             END CASE
          ELSE
             LET g_data.des1 = NULL
          END IF
          DISPLAY BY NAME g_data.des1
 
       BEFORE FIELD operator2
          CALL i007_set_entry(p_cmd)
          CALL i007_set_no_required(p_cmd)
 
       AFTER FIELD operator2
          IF NOT cl_null(g_data.operator2) THEN
             IF g_data.operator2 NOT MATCHES '[0123456789]' THEN
                NEXT FIELD operator2
             END IF
             IF g_data.operator2 MATCHES '[01234589]' THEN
                LET g_data.formular2 = NULL
                LET g_data.des2 = NULL
             END IF
             IF g_data.operator2 = '7' THEN
                LET g_data.des2 = NULL
             END IF
          ELSE
             LET g_data.formular2 = NULL
             LET g_data.des2 = NULL
          END IF
          DISPLAY BY NAME g_data.formular2,g_data.des2
          CALL i007_set_no_entry(p_cmd)
          CALL i007_set_required(p_cmd)
 
       AFTER FIELD formular2
          IF NOT cl_null(g_data.formular2) THEN
             CASE g_data.operator2
                  WHEN '6'    #檢查公式
                      CALL i007_formular2()
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,0)
                         NEXT FIELD formular2
                      END IF
                  WHEN '7'    #檢查數字
                      IF NOT i007_numchk(g_data.formular2) THEN
                         NEXT FIELD formular2
                      END IF
             END CASE
          ELSE
             LET g_data.des2 = NULL
          END IF
          DISPLAY BY NAME g_data.des2
 
 
       AFTER FIELD operand
          IF NOT cl_null(g_data.operand) AND 
             NOT (g_data.operand = '+' OR g_data.operand = '-' OR
                  g_data.operand = '*' OR g_data.operand = '\/') THEN
             NEXT FIELD operand
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
          #公式和數字總檢
          IF g_data.operator1 = '6' THEN
             CALL i007_formular1()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD formular1
             END IF
          END IF
          IF g_data.operator1 = '7' THEN
             IF NOT i007_numchk(g_data.formular1) THEN
                NEXT FIELD formular1
             END IF
          END IF
 
          IF g_data.operator2 = '6' THEN
             CALL i007_formular2()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                NEXT FIELD formular2
             END IF
          END IF
          IF g_data.operator2 = '7' THEN
             IF NOT i007_numchk(g_data.formular2) THEN
                NEXT FIELD formular2
             END IF
          END IF
       ON ACTION CONTROLP
          CASE
              WHEN INFIELD(formular1)
                   IF g_data.operator1 = '6' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ich01"
                      LET g_qryparam.default1 = g_data.formular1
                      CALL cl_create_qry() RETURNING g_data.formular1
                      DISPLAY BY NAME g_data.formular1
                      NEXT FIELD formular1
                   END IF
              WHEN INFIELD(formular2)
                   IF g_data.operator2 = '6' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_ich01"
                      LET g_qryparam.default1 = g_data.formular2
                      CALL cl_create_qry() RETURNING g_data.formular2
                      DISPLAY BY NAME g_data.formular2
                      NEXT FIELD formular2
                   END IF
          END CASE
       ON ACTION CONTROLR
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
     
    END INPUT
    IF INT_FLAG THEN  #放棄
       LET INT_FLAG = 0
       CLOSE WINDOW i007_m_w
       RETURN
    END IF
    CALL i007_set_ich02() RETURNING g_ich[l_ac].ich02
    CLOSE WINDOW i007_m_w
END FUNCTION
 
FUNCTION i007_b_askkey()
 
   CLEAR FORM
   CALL g_ich.clear()
 
    CONSTRUCT g_wc2 ON ich01,ich02
         FROM s_ich[1].ich01,s_ich[1].ich02
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ichuser', 'ichgrup') #FUN-980030
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL i007_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i007_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING
 
    LET g_sql =
        "SELECT ich01,ich02 ",
        " FROM ich_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY ich01"
    PREPARE i007_pb FROM g_sql
    DECLARE ich_curs CURSOR FOR i007_pb
 
    CALL g_ich.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ich_curs INTO g_ich[g_cnt].*              #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ich.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i007_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ich TO s_ich.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                 
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice='output'
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
#No.FUN-830065--begin--
      ON ACTION related_document                                                                              
         LET g_action_choice="related_document"                                                                                     
         EXIT DISPLAY 
#No.FUN-830065--end--
      ON ACTION about
         CALL cl_about()   
 
   
#     ON ACTION export
#        CALL cl_export_to_excel(ui.Interface.getRootNode(),
#                                base.TypeInfo.create(g_ich),'','') 
#        EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
 
  END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i007_out()
   DEFINE l_cmd  LIKE type_file.chr1000
 
     IF g_wc2 IS NULL THEN                                                                                                          
        CALL cl_err('','9057',0) RETURN END IF                                                                                      
     LET l_cmd = 'p_query "aici007" "',g_wc2 CLIPPED,'"'                                                                            
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN
END FUNCTION
 
FUNCTION i007_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
   CALL cl_set_comp_entry("formular1,formular2",TRUE)  
END FUNCTION                                                                    
                                                                                
FUNCTION i007_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   IF cl_null(g_data.operator1) OR g_data.operator1 NOT MATCHES '[67]' THEN
      CALL cl_set_comp_entry("formular1",FALSE)  
   END IF
   IF cl_null(g_data.operator2) OR g_data.operator2 NOT MATCHES '[67]' THEN
      CALL cl_set_comp_entry("formular2",FALSE)  
   END IF
END FUNCTION                                                                    
 
FUNCTION i007_set_required(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
   IF NOT cl_null(g_data.operator1) AND 
      g_data.operator1 MATCHES '[67]' THEN
      CALL cl_set_comp_required("formular1",TRUE)  
   END IF
   IF NOT cl_null(g_data.operator2) AND 
      g_data.operator2 MATCHES '[67]' THEN
      CALL cl_set_comp_required("formular2",TRUE)  
   END IF
END FUNCTION      
                                                                                
FUNCTION i007_set_no_required(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
   CALL cl_set_comp_required("formular1,formular2",FALSE)  
END FUNCTION
 
#檢查數值否
FUNCTION i007_numchk(p_str)
    DEFINE p_str  LIKE ich_file.ich01,
           p_str1 LIKE ich_file.ich01,
           l_i    LIKE type_file.num5,
           l_dot  LIKE type_file.num5   #計算小數點數
 
    LET l_dot = 0
    IF NOT cl_null(p_str) THEN
       IF p_str[1,1] = '.' THEN RETURN 0 END IF                   #小數點在第一個字[錯]
       IF p_str[LENGTH(p_str),LENGTH(p_str)] = '.' THEN           #小數點在最后一個字[錯]
          RETURN 0 
       END IF
       FOR l_i = 1 TO LENGTH(p_str)
           IF p_str[l_i,l_i] = '.' THEN LET l_dot = l_dot + 1 END IF
           IF l_dot > 1 THEN RETURN 0 END IF                      #小數點出現1次以上[錯]
 
           IF p_str[l_i,l_i] = '-' AND l_i > 1 THEN
              RETURN 0                                            #負號出現在第一位以外[錯]
           END IF 
           IF p_str[l_i,l_i] NOT MATCHES '[-.0123456789]' THEN
              RETURN 0                                            #不等于-.0123456789任一[錯]
           END IF
       END FOR
       IF p_str[1,1] = '0' AND l_dot = 0 THEN 
          RETURN 0
 
       END IF
    END IF
    RETURN 1
END FUNCTION
 
#串回公式字符串
FUNCTION i007_set_ich02() 
    DEFINE l_ich02 LIKE ich_file.ich02
    CASE g_data.operator1
         WHEN '6'
             LET l_ich02 = g_data.formular1 CLIPPED
         WHEN '7'
             LET l_ich02 = g_data.formular1 CLIPPED
         OTHERWISE
             CALL i007_des(g_data.operator1) RETURNING l_ich02
    END CASE
    LET l_ich02 = l_ich02 CLIPPED,g_data.operand CLIPPED
    CASE g_data.operator2
         WHEN '6'
             LET l_ich02 = l_ich02 CLIPPED, g_data.formular2 CLIPPED
         WHEN '7'
             LET l_ich02 = l_ich02 CLIPPED, g_data.formular2 CLIPPED
         OTHERWISE
             LET l_ich02 = l_ich02 CLIPPED, i007_des(g_data.operator2)
    END CASE
    LET l_ich02 = '(',l_ich02 CLIPPED,')'
    RETURN l_ich02
END FUNCTION
 
#找出combobox對應的值
FUNCTION i007_des(p_str)
    DEFINE p_str LIKE type_file.chr1
    CASE p_str
         WHEN '0'
             RETURN 'TEST TIME FOR WAFER'
         WHEN '1'
             RETURN 'INDEX TIME FOR WAFER'
         WHEN '2'
             RETURN 'TEST TIME FOR DIE'
         WHEN '3'
             RETURN 'INDEX TIME FOR DIE'
         WHEN '4'
             RETURN 'Hour Rate'
         WHEN '5'
             RETURN 'Dut'
         WHEN '8'
             RETURN 'GROSS DIE'
         WHEN '9'
             RETURN 'FACTOR'
         OTHERWISE
             RETURN ''
    END CASE
END FUNCTION
 
#開窗input前先將值解析并display
FUNCTION i007_set_data()
    CALL i007_cs_parse(g_ich[l_ac].ich02)
         RETURNING g_data.des1,g_data.operand,g_data.des2
    #操作數1
    CALL i007_option(g_data.des1) 
         RETURNING g_data.operator1,g_data.formular1,g_data.des1
    #操作數2
    CALL i007_option(g_data.des2) 
         RETURNING g_data.operator2,g_data.formular2,g_data.des2
    DISPLAY BY NAME g_data.operator1,g_data.formular1,g_data.des1,
                    g_data.operand,
                    g_data.operator2,g_data.formular2,g_data.des2
END FUNCTION
 
 
#由字符串對應回combobox的option
FUNCTION i007_option(p_des)
    DEFINE p_des LIKE ich_file.ich02
    DEFINE l_ich02 LIKE ich_file.ich02
    DEFINE l_operator LIKE ich_file.ich02,
           l_formular LIKE ich_file.ich01,
           l_des      LIKE ich_file.ich02
 
    LET l_operator = NULL    LET l_formular = NULL    LET l_des = NULL
    CASE p_des
         WHEN 'TEST TIME FOR WAFER'
               LET l_operator = '0'
         WHEN 'INDEX TIME FOR WAFER'
               LET l_operator = '1'
         WHEN 'TEST TIME FOR DIE'
               LET l_operator = '2'
         WHEN 'INDEX TIME FOR DIE'
               LET l_operator = '3'
         WHEN 'Hour Rate'
               LET l_operator = '4'
         WHEN 'Dut'
               LET l_operator = '5'
         WHEN 'GROSS DIE'
               LET l_operator = '8'
         WHEN 'FACTOR'
               LET l_operator = '9'
         OTHERWISE
               SELECT ich02 INTO l_ich02 FROM ich_file
               WHERE ich01 = p_des
               IF NOT cl_null(l_ich02) THEN
                  LET l_operator = '6'
                  LET l_formular = p_des
                  LET l_des = l_ich02
               ELSE
                  LET l_operator = '7'
                  LET l_formular = p_des
                  LET l_des = NULL
               END IF
    END CASE
    RETURN l_operator,l_formular,l_des
END FUNCTION
 
#公式1檢查
FUNCTION i007_formular1()
  DEFINE l_ich02  LIKE ich_file.ich02
  DEFINE l_ichacti LIKE ich_file.ichacti
 
  LET g_errno = ' '
  IF g_data.formular1 = g_ich[l_ac].ich01 THEN
     LET g_errno = 'aic-007'  RETURN
  END IF
 
  SELECT ich02,ichacti INTO l_ich02,l_ichacti FROM ich_file
   WHERE ich01 = g_data.formular1
 
  CASE
      WHEN SQLCA.sqlcode = 100   LET g_errno = SQLCA.sqlcode
      WHEN l_ichacti = 'N'    LET g_errno = '9028'
      WHEN cl_null(l_ich02)  LET g_errno = 'aic-009'
  END CASE
  LET g_data.des1 = l_ich02
  DISPLAY BY NAME g_data.des1
END FUNCTION
 
#公式2檢查
FUNCTION i007_formular2()
  DEFINE l_ich02  LIKE ich_file.ich02
  DEFINE l_ichacti LIKE ich_file.ichacti
 
  LET g_errno = ' '
  IF g_data.formular2 = g_ich[l_ac].ich01 THEN
     LET g_errno = 'aic-007'  RETURN
  END IF
 
  SELECT ich02,ichacti INTO l_ich02,l_ichacti FROM ich_file
   WHERE ich01 = g_data.formular2
 
  CASE
      WHEN SQLCA.sqlcode = 100   LET g_errno = SQLCA.sqlcode
      WHEN l_ichacti = 'N'    LET g_errno = '9028'
      WHEN cl_null(l_ich02)  LET g_errno = 'aic-009'
  END CASE
  LET g_data.des2 = l_ich02
  DISPLAY BY NAME g_data.des2
END FUNCTION
 
#檢查運算子,操作數若為公式,公式解開后該層不可有目前公式代碼
FUNCTION i007_chk_formular(p_des1,p_des2)
  DEFINE p_des1          LIKE type_file.chr50,
         p_des2          LIKE type_file.chr50
  DEFINE l_des1          LIKE type_file.chr50,
         l_des2          LIKE type_file.chr50,
         l_operand       LIKE type_file.chr1,
         l_ich02     LIKE ich_file.ich02
 
  LET g_errno = ' '
  IF NOT cl_null(p_des1) THEN
     CASE p_des1
       WHEN 'TEST TIME FOR WAFER'
       WHEN 'INDEX TIME FOR WAFER'
       WHEN 'TEST TIME FOR DIE'
       WHEN 'INDEX TIME FOR DIE'
       WHEN 'Hour Rate'
       WHEN 'Dut'
       WHEN 'GROSS DIE'
       WHEN 'FACTOR'         
       OTHERWISE
         SELECT ich02 INTO l_ich02 FROM ich_file
          WHERE ich01 = p_des1
         IF NOT cl_null(l_ich02) THEN
            CALL i007_cs_parse(l_ich02)
                 RETURNING l_des1,l_operand,l_des2
            IF l_des1 = g_ich[l_ac].ich01 OR
               l_des2 = g_ich[l_ac].ich01 OR
               (NOT cl_null(g_ich_t.ich01) AND 
                    l_des1=g_ich_t.ich01) OR
               (NOT cl_null(g_ich_t.ich01) AND 
                    l_des2=g_ich_t.ich01) THEN
               LET g_errno = 'aic-010' RETURN
            END IF
          END IF
    END CASE
  END IF
  IF NOT cl_null(p_des2) THEN
     CASE p_des2
       WHEN 'TEST TIME FOR WAFER'   RETURN
       WHEN 'INDEX TIME FOR WAFER'  RETURN
       WHEN 'TEST TIME FOR DIE'     RETURN
       WHEN 'INDEX TIME FOR DIE'    RETURN
       WHEN 'Hour Rate'             RETURN
       WHEN 'Dut'                   RETURN
       WHEN 'GROSS DIE'             RETURN
       WHEN 'FACTOR'                RETURN
       OTHERWISE
         LET l_ich02 = NULL
         SELECT ich02 INTO l_ich02 FROM ich_file
         WHERE ich01 = p_des2
         IF NOT cl_null(l_ich02) THEN
            CALL i007_cs_parse(l_ich02)
                 RETURNING l_des1,l_operand,l_des2
            IF l_des1 = g_ich[l_ac].ich01 OR
               l_des2 = g_ich[l_ac].ich01 OR
               (NOT cl_null(g_ich_t.ich01) AND
                    l_des1=g_ich_t.ich01) OR
               (NOT cl_null(g_ich_t.ich01) AND 
                    l_des2=g_ich_t.ich01) THEN
               LET g_errno = 'aic-010' RETURN
            END IF
          END IF
    END CASE
  END IF
END FUNCTION
#檢查是否有其它公式正在使用
FUNCTION i007_chk_using()
   DEFINE l_flag LIKE type_file.num10,
          l_str  STRING,
          l_sql  STRING
 
   LET l_flag = 1
   LET l_sql = "SELECT COUNT(*) FROM ich_file "
 
   LET l_str = "(",g_ich_t.ich01,'+'
   LET l_sql = l_sql ," WHERE ich02 LIKE '",l_str,"%'"
 
   LET l_str = "(",g_ich_t.ich01,'-'
   LET l_sql = l_sql ," OR ich02 LIKE '",l_str,"%'"
 
   LET l_str = "(",g_ich_t.ich01,'*'
   LET l_sql = l_sql ," OR ich02 LIKE '",l_str,"%'"
 
   LET l_str = "(",g_ich_t.ich01,'/'
   LET l_sql = l_sql ," OR ich02 LIKE '",l_str,"%'"
 
   LET l_str = "+",g_ich_t.ich01,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET l_str = "-",g_ich_t.ich01,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET l_str = "*",g_ich_t.ich01,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET l_str = "/",g_ich_t.ich01,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET g_cnt = 0
   PREPARE i007_chk_using_pre FROM l_sql
   DECLARE i007_chk_using_cs CURSOR FOR i007_chk_using_pre
   OPEN i007_chk_using_cs 
   FETCH i007_chk_using_cs
 
   IF g_cnt > 0 THEN
      CALL cl_err('','aic-011',1)
      LET l_flag = 0
   END IF
   RETURN l_flag
END FUNCTION
 
FUNCTION i007_cs_parse(p_formular)
DEFINE p_formular   LIKE ich_file.ich02,
       l_operator1  LIKE ich_file.ich02,
       l_operator2  LIKE ich_file.ich02,
       l_operand    LIKE type_file.chr1,
       l_i          LIKE type_file.num5
 
    LET l_operator1 = NULL 
    LET l_operator2 = NULL 
    LET l_operand   = NULL 
 
    IF NOT cl_null(p_formular) THEN   #要非NULL
       IF p_formular[1,1] = '(' AND   #要有()包住
          p_formular[LENGTH(p_formular),LENGTH(p_formular)] = ')' THEN
          FOR l_i = 2 TO LENGTH(p_formular) - 1
              IF p_formular[l_i,l_i] = '+' OR p_formular[l_i,l_i] = '-' OR
                 p_formular[l_i,l_i] = '*' OR p_formular[l_i,l_i] = '\/' THEN
                 LET l_operand = p_formular[l_i,l_i]
                 IF l_i > 2 THEN LET l_operator1 = p_formular[2,l_i - 1] END IF
                 IF l_i < LENGTH(p_formular) THEN
                    LET l_operator2 = p_formular[l_i + 1,LENGTH(p_formular)-1]
                 END IF
                 EXIT FOR
              END IF
          END FOR
       END IF
    END IF
 RETURN l_operator1,l_operand,l_operator2
END FUNCTION
 
#檢查是否有其它公式正在使用
FUNCTION i007_chk_usingl(l_cmd)
   DEFINE l_flag LIKE type_file.num10,
          l_str  STRING,
          l_sql  STRING,
          l_cmd  LIKE ich_file.ich01
 
   LET l_flag = 1
   LET l_sql = "SELECT COUNT(*) FROM ich_file "
 
   LET l_str = "(",l_cmd,'+'
   LET l_sql = l_sql ," WHERE ich02 LIKE '",l_str,"%'"
 
   LET l_str = "(",l_cmd,'-'
   LET l_sql = l_sql ," OR ich02 LIKE '",l_str,"%'"
 
   LET l_str = "(",l_cmd,'*'
   LET l_sql = l_sql ," OR ich02 LIKE '",l_str,"%'"
 
   LET l_str = "(",l_cmd,'/'
   LET l_sql = l_sql ," OR ich02 LIKE '",l_str,"%'"
 
   LET l_str = "+",l_cmd,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET l_str = "-",l_cmd,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET l_str = "*",l_cmd,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET l_str = "/",l_cmd,')'
   LET l_sql = l_sql ," OR ich02 LIKE '%",l_str,"'"
 
   LET g_cnt = 0
   PREPARE i007_chk_usingl_pre FROM l_sql
   DECLARE i007_chk_usingl_cs CURSOR FOR i007_chk_usingl_pre
   OPEN i007_chk_usingl_cs 
   FETCH i007_chk_usingl_cs INTO g_cnt
   IF g_cnt > 0 THEN
      CALL cl_err('','aic-011',1)
      LET l_flag = 0
   END IF
   RETURN l_flag
END FUNCTION
#No.FUN-7B0074--end--

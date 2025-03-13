# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri047.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/05/07 yougs 
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hrcg         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrcg01       LIKE hrcg_file.hrcg01,
        hraa12       LIKE hraa_file.hraa12,
        hrcg02       LIKE hrcg_file.hrcg02, 
        hrcg03       LIKE hrcg_file.hrcg03,    
        hrcg04       LIKE hrcg_file.hrcg04,
        hrcg05       LIKE hrcg_file.hrcg05 
           
                    END RECORD,
    g_hrcg_t        RECORD                 #程式變數 (舊值)
        hrcg01       LIKE hrcg_file.hrcg01,
        hraa12       LIKE hraa_file.hraa12,
        hrcg02       LIKE hrcg_file.hrcg02, 
        hrcg03       LIKE hrcg_file.hrcg03,    
        hrcg04       LIKE hrcg_file.hrcg04,
        hrcg05       LIKE hrcg_file.hrcg05 
                    END RECORD,
    g_wc2,g_sql      LIKE type_file.chr1000,       
    g_rec_b         LIKE type_file.num5,                #單身筆數        
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt           LIKE type_file.num10   
                    
MAIN

   DEFINE p_row,p_col   LIKE type_file.num5

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
    

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   

   LET p_row = 4 LET p_col = 3
   OPEN WINDOW i047_w AT p_row,p_col WITH FORM "ghr/42f/ghri047"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   LET g_wc2 = '1=1'
   CALL i047_b_fill(g_wc2)
   CALL i047_menu()
   CLOSE WINDOW i047_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
                                              
 
FUNCTION i047_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i047_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i047_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i047_b()
            ELSE
               LET g_action_choice = NULL
            END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcg),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i047_q()
   CALL i047_b_askkey()
END FUNCTION
  
FUNCTION i047_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否 
   l_count         LIKE type_file.num5 
   
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = "" 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT hrcg01,'',hrcg02,hrcg03,hrcg04,hrcg05",   
                      "  FROM hrcg_file WHERE hrcg01 = ? AND hrcg02= ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i047_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_hrcg WITHOUT DEFAULTS FROM s_hrcg.*
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

          IF g_rec_b>=l_ac THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hrcg_t.* = g_hrcg[l_ac].*  #BACKUP
             OPEN i047_bcl USING g_hrcg_t.hrcg01,g_hrcg_t.hrcg02
             IF STATUS THEN
                CALL cl_err("OPEN i047_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i047_bcl INTO g_hrcg[l_ac].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrcg_t.hrcg02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             SELECT hraa12 INTO g_hrcg[l_ac].hraa12 FROM hraa_file WHERE hraa01 = g_hrcg[l_ac].hrcg01 
             CALL cl_show_fld_cont()    
          END IF  
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hrcg[l_ac].* TO NULL     
          LET g_hrcg_t.* = g_hrcg[l_ac].*         #新輸入資料  
          SELECT hraa12 INTO g_hrcg[l_ac].hraa12 FROM hraa_file WHERE hraa01 = g_hrcg[l_ac].hrcg01 
          CALL cl_show_fld_cont()    
           
     AFTER FIELD hrcg01
          IF NOT cl_null(g_hrcg[l_ac].hrcg01) THEN 
            LET l_count = 0
             SELECT count(*) INTO l_count FROM hraa_file WHERE hraa01 = g_hrcg[l_ac].hrcg01 AND hraaacti = 'Y'
             IF l_count = 0 OR cl_null(l_count) THEN
                CALL cl_err(g_hrcg[l_ac].hrcg01,'ghr-001',0)  
                LET g_hrcg[l_ac].hraa12= ''
                NEXT FIELD hrcg03
             END IF
             SELECT hraa12 INTO g_hrcg[l_ac].hraa12 FROM hraa_file WHERE hraa01 = g_hrcg[l_ac].hrcg01 
             DISPLAY BY NAME g_hrcg[l_ac].hraa12
          END IF                        
       AFTER FIELD hrcg02
          IF g_hrcg[l_ac].hrcg02 < 0 THEN
             CALL cl_err('工龄不能小于0','!',0)
             NEXT FIELD hrcg02
          END IF
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i047_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hrcg_file(hrcg01,hrcg02,hrcg03,hrcg04,hrcg05,hrcgoriu,hrcgorig,hrcguser,hrcggrup,hrcgdate)  
          VALUES(g_hrcg[l_ac].hrcg01,g_hrcg[l_ac].hrcg02,g_hrcg[l_ac].hrcg03,g_hrcg[l_ac].hrcg04,
                 g_hrcg[l_ac].hrcg05,g_user,g_grup,g_user,g_grup,g_today)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hrcg_file",g_hrcg[l_ac].hrcg01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hrcg_t.hrcg01 IS NOT NULL AND g_hrcg_t.hrcg02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hrcg01"               
             LET g_doc.value1 = g_hrcg[l_ac].hrcg01  
             LET g_doc.column2 = "hrcg02"               
             LET g_doc.value2 = g_hrcg[l_ac].hrcg02      
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hrcg_file WHERE hrcg01 = g_hrcg_t.hrcg01 AND hrcg02 = g_hrcg_t.hrcg02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hrcg_file",g_hrcg_t.hrcg01,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hrcg[l_ac].* = g_hrcg_t.*
             CLOSE i047_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hrcg[l_ac].hrcg02,-263,0)
             LET g_hrcg[l_ac].* = g_hrcg_t.*
          ELSE
             UPDATE hrcg_file SET hrcg01=g_hrcg[l_ac].hrcg01,
                                 hrcg02=g_hrcg[l_ac].hrcg02,
                                 hrcg03=g_hrcg[l_ac].hrcg03,
                                 hrcg04=g_hrcg[l_ac].hrcg04, 
                                 hrcg05=g_hrcg[l_ac].hrcg05,
                                 hrcgmodu=g_user,
                                 hrcgdate=g_today
                           WHERE hrcg01 = g_hrcg_t.hrcg01  
                             AND hrcg02 = g_hrcg_t.hrcg02 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrcg_file",g_hrcg_t.hrcg01,"",SQLCA.sqlcode,"","",1)  
                LET g_hrcg[l_ac].* = g_hrcg_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()            
          LET l_ac_t = l_ac             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hrcg[l_ac].* = g_hrcg_t.*
             END IF
             CLOSE i047_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i047_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrcg01)   
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_hraa01"
                  LET g_qryparam.default1 = g_hrcg[l_ac].hrcg01
                  CALL cl_create_qry() RETURNING g_hrcg[l_ac].hrcg01
                  DISPLAY BY NAME g_hrcg[l_ac].hrcg01
                  NEXT FIELD hrcg01 
          END CASE                                                
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hrcg02) AND l_ac > 1 THEN
             LET g_hrcg[l_ac].* = g_hrcg[l_ac-1].*
             NEXT FIELD hrcg02
          END IF 
 
       ON ACTION CONTROLZ
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
 
       
   END INPUT
 
   CLOSE i047_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i047_b_askkey()
 
   CLEAR FORM
   CALL g_hrcg.clear()
   CONSTRUCT g_wc2 ON hrcg01,hrcg02,hrcg03,hrcg04,hrcg05
        FROM s_hrcg[1].hrcg01,s_hrcg[1].hrcg02,s_hrcg[1].hrcg03,s_hrcg[1].hrcg04,s_hrcg[1].hrcg05
 
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

      ON ACTION controlp
         CASE
             WHEN INFIELD(hrcg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hraa01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrcg01
                  NEXT FIELD hrcg01                
         END CASE            
   END CONSTRUCT 
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrcguser', 'hrcggrup')
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   CALL i047_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i047_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT hrcg01,'',hrcg02,hrcg03,hrcg04,hrcg05",   
        " FROM hrcg_file", 
        " WHERE ", p_wc2 CLIPPED,
        " ORDER BY hrcg01,hrcg02,hrcg03,hrcg04"
    PREPARE i047_pb FROM g_sql
    DECLARE hrcg_curs CURSOR FOR i047_pb
  
    CALL g_hrcg.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcg_curs INTO g_hrcg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hraa12 INTO g_hrcg[g_cnt].hraa12 FROM hraa_file WHERE hraa01 = g_hrcg[g_cnt].hrcg01 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcg.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i047_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcg TO s_hrcg.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
      LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
  
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 

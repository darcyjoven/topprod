# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_e.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
  # 30150318:开启删除功能 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hrate         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrate01       LIKE hrate_file.hrate01,
        hrat02        LIKE hrat_file.hrat02,
        hrate02       LIKE hrate_file.hrate02,
        hrate02_name  LIKE hrag_file.hrag07,   
        hrate03       LIKE hrate_file.hrate03,   
        hrate04       LIKE hrate_file.hrate04,
        hrate05       LIKE hrate_file.hrate05,  
        hrate06       LIKE hrate_file.hrate06, 
        hrate07       LIKE hrate_file.hrate07,   
        hrate08       LIKE hrate_file.hrate08
           
                    END RECORD,
    g_hrate_t        RECORD                 #程式變數 (舊值)
        hrate01       LIKE hrate_file.hrate01,
        hrat02        LIKE hrat_file.hrat02,
        hrate02       LIKE hrate_file.hrate02, 
        hrate02_name  LIKE hrag_file.hrag07,   
        hrate03       LIKE hrate_file.hrate03,   
        hrate04       LIKE hrate_file.hrate04,
        hrate05       LIKE hrate_file.hrate05,  
        hrate06       LIKE hrate_file.hrate06, 
        hrate07       LIKE hrate_file.hrate07,   
        hrate08       LIKE hrate_file.hrate08
                    END RECORD,
    g_wc2_e,g_sql_e    LIKE type_file.chr1000,       
    g_rec_b_e         LIKE type_file.num5,                #單身筆數        
    l_ac_e            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_e STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_e           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_e(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_e_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_e"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hrate01,hrat02",FALSE)
   LET g_wc2_e = '1=1'
   CALL i006_e_b_fill(g_wc2_e)
   CALL i006_e_menu()
   CLOSE WINDOW i006_e_w                   
END FUNCTION
 
FUNCTION i006_e_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_e_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_e_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_e_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrate),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_e_q()
   CALL i006_e_b_askkey()
END FUNCTION
  
FUNCTION i006_e_b()
DEFINE
   l_ac_e_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複用       
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        
   p_cmd           LIKE type_file.chr1,                #處理狀態        
   l_allow_insert  LIKE type_file.chr1,                #可新增否
   l_allow_delete  LIKE type_file.chr1,                #可刪除否
   l_aaaacti       LIKE aaa_file.aaaacti
   
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
   IF g_hrat.hratconf = 'Y' THEN
   	  CALL cl_err('','abm-879',0)
   	  RETURN
   END IF	  
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql_e = "SELECT hrate01,'',hrate02,'',hrate03,hrate04,hrate05,hrate06,hrate07,hrate08",   
                      "  FROM hrate_file WHERE hrate01 = ? AND hrate02= ? FOR UPDATE"
   LET g_forupd_sql_e = cl_forupd_sql(g_forupd_sql_e)
   DECLARE i006_e_bcl CURSOR FROM g_forupd_sql_e      # LOCK CURSOR
 
   INPUT ARRAY g_hrate WITHOUT DEFAULTS FROM s_hrate.*
     ATTRIBUTE (COUNT=g_rec_b_e,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)  # 30150318:开启删除功能 
 
       BEFORE INPUT
          IF g_rec_b_e != 0 THEN
             CALL fgl_set_arr_curr(l_ac_e)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_e = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_e>=l_ac_e THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hrate_t.* = g_hrate[l_ac_e].*  #BACKUP
             OPEN i006_e_bcl USING g_hrat.hratid,g_hrate_t.hrate02
             IF STATUS THEN
                CALL cl_err("OPEN i006_e_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_e_bcl INTO g_hrate[l_ac_e].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrate_t.hrate02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()    
             CALL i006_e_hrag('318',g_hrate[l_ac_e].hrate02) RETURNING g_hrate[l_ac_e].hrate02_name 
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hrate[l_ac_e].* TO NULL     
          LET g_hrate_t.* = g_hrate[l_ac_e].*         #新輸入資料 
          LET g_hrate[l_ac_e].hrate01 = g_hrat.hratid
          SELECT hrat02 INTO g_hrate[l_ac_e].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          CALL cl_show_fld_cont()   
          NEXT FIELD hrate02
           
     AFTER FIELD hrate02
          IF NOT cl_null(g_hrate[l_ac_e].hrate02) THEN 
             CALL i006_e_hrag('318',g_hrate[l_ac_e].hrate02) RETURNING g_hrate[l_ac_e].hrate02_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hrate[l_ac_e].hrate02,g_errno,0)  
                LET g_hrate[l_ac_e].hrate02_name = ''
                NEXT FIELD hrate02
             END IF
             DISPLAY BY NAME g_hrate[l_ac_e].hrate02_name
          END IF    	          	        
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_e_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hrate_file(hrate01,hrate02,hrate03,hrate04,hrate05,hrate06,hrate07,hrate08)  
          VALUES(g_hrate[l_ac_e].hrate01,g_hrate[l_ac_e].hrate02,g_hrate[l_ac_e].hrate03,g_hrate[l_ac_e].hrate04,
                 g_hrate[l_ac_e].hrate05,g_hrate[l_ac_e].hrate06,g_hrate[l_ac_e].hrate07,g_hrate[l_ac_e].hrate08)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hrate_file",g_hrate[l_ac_e].hrate02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_e=g_rec_b_e+1
             DISPLAY g_rec_b_e TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hrate_t.hrate02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hrate02"               
             LET g_doc.value1 = g_hrate[l_ac_e].hrate02      
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hrate_file WHERE hrate01 = g_hrat.hratid AND hrate02 = g_hrate_t.hrate02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hrate_file",g_hrate_t.hrate02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_e=g_rec_b_e-1
             DISPLAY g_rec_b_e TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hrate[l_ac_e].* = g_hrate_t.*
             CLOSE i006_e_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hrate[l_ac_e].hrate02,-263,0)
             LET g_hrate[l_ac_e].* = g_hrate_t.*
          ELSE
             UPDATE hrate_file SET hrate02=g_hrate[l_ac_e].hrate02,
                                 hrate03=g_hrate[l_ac_e].hrate03,
                                 hrate04=g_hrate[l_ac_e].hrate04, 
                                 hrate05=g_hrate[l_ac_e].hrate05,
                                 hrate06=g_hrate[l_ac_e].hrate06,
                                 hrate07=g_hrate[l_ac_e].hrate07,
                                 hrate08=g_hrate[l_ac_e].hrate08  
                           WHERE hrate01 = g_hrat.hratid 
                             AND hrate02 = g_hrate_t.hrate02   
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrate_file",g_hrate_t.hrate02,"",SQLCA.sqlcode,"","",1)  
                LET g_hrate[l_ac_e].* = g_hrate_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_e = ARR_CURR()            
          LET l_ac_e_t = l_ac_e             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hrate[l_ac_e].* = g_hrate_t.*
             END IF
             CLOSE i006_e_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_e_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrate02)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '318'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hrate[l_ac_e].hrate02
                  CALL cl_create_qry() RETURNING g_hrate[l_ac_e].hrate02
                  DISPLAY BY NAME g_hrate[l_ac_e].hrate02
                  NEXT FIELD hrate02 
          END CASE                                             	  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hrate02) AND l_ac_e > 1 THEN
             LET g_hrate[l_ac_e].* = g_hrate[l_ac_e-1].*
             NEXT FIELD hrate02
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
 
   CLOSE i006_e_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_e_b_askkey()
 
   CLEAR FORM
   CALL g_hrate.clear()
   CONSTRUCT g_wc2_e ON hrate01,hrate02,hrate03,hrate04,hrate05,hrate06,hrate07,hrate08  
        FROM s_hrate[1].hrate01,s_hrate[1].hrate02,s_hrate[1].hrate03,s_hrate[1].hrate04,
             s_hrate[1].hrate05,s_hrate[1].hrate06,s_hrate[1].hrate07,s_hrate[1].hrate08
 
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
             WHEN INFIELD(hrate01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrat01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrate01
                  NEXT FIELD hrate01  
             WHEN INFIELD(hrate02)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '318'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrate02
                  NEXT FIELD hrate02                      
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_e = NULL
      RETURN
   END IF
   CALL i006_e_b_fill(g_wc2_e)
END FUNCTION
 
FUNCTION i006_e_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql_e =
        "SELECT hrate01,'',hrate02,'',hrate03,hrate04,hrate05,hrate06,hrate07,hrate08",   
        " FROM hrate_file", 
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hrate01 = '",g_hrat.hratid,"'",
        " ORDER BY hrate01,hrate02,hrate03,hrate04"
    PREPARE i006_e_pb FROM g_sql_e
    DECLARE hrate_curs CURSOR FOR i006_e_pb
 
    CALL g_hrate.clear()
    LET g_cnt_e = 1
    MESSAGE "Searching!" 
    FOREACH hrate_curs INTO g_hrate[g_cnt_e].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hrate[g_cnt_e].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
        CALL i006_e_hrag('318',g_hrate[g_cnt_e].hrate02) RETURNING g_hrate[g_cnt_e].hrate02_name 
        LET g_cnt_e = g_cnt_e + 1
        IF g_cnt_e > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrate.deleteElement(g_cnt_e)
    MESSAGE ""
    LET g_rec_b_e = g_cnt_e-1
    DISPLAY g_rec_b_e TO FORMONLY.cn2  
    LET g_cnt_e = 0
 
END FUNCTION
 
FUNCTION i006_e_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrate TO s_hrate.* ATTRIBUTE(COUNT=g_rec_b_e)
 
      BEFORE ROW
      LET l_ac_e = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_e = 1
         LET l_ac_e = 1
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
         LET l_ac_e = ARR_CURR()
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
 
FUNCTION i006_e_hrag(p_hrag01,p_hrag06) 
	 DEFINE p_hrag01   LIKE hrag_file.hrag01
	 DEFINE p_hrag06   LIKE hrag_file.hrag06
   DEFINE l_hrag07   LIKE hrag_file.hrag07  
   DEFINE l_hragacti LIKE hrag_file.hragacti
 
   LET g_errno=''
   SELECT hrag07,hragacti INTO l_hrag07,l_hragacti FROM hrag_file
    WHERE hrag06=p_hrag06
      AND hrag01=p_hrag01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-032'
                                LET l_hrag07=NULL 
       WHEN l_hragacti = 'N'    LET g_errno='9028'                          
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   RETURN l_hrag07
END FUNCTION

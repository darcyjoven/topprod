# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_a.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
 # 30150318:开启删除功能 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hrata         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrata01       LIKE hrata_file.hrata01,
        hrat02        LIKE hrat_file.hrat02,
        hrata02       LIKE hrata_file.hrata02,   
        hrata03       LIKE hrata_file.hrata03,   
        hrata04       LIKE hrata_file.hrata04,
        hrata05       LIKE hrata_file.hrata05, 
        hrata05_name  LIKE hrag_file.hrag07,
        hrata06       LIKE hrata_file.hrata06,
        hrata06_name  LIKE hrag_file.hrag07,
        hrata07       LIKE hrata_file.hrata07,   
        hrata08       LIKE hrata_file.hrata08,
        hrata08_name  LIKE hrag_file.hrag07 
           
                    END RECORD,
    g_hrata_t        RECORD                 #程式變數 (舊值)
        hrata01       LIKE hrata_file.hrata01,
        hrat02        LIKE hrat_file.hrat02,
        hrata02       LIKE hrata_file.hrata02,   
        hrata03       LIKE hrata_file.hrata03,   
        hrata04       LIKE hrata_file.hrata04,
        hrata05       LIKE hrata_file.hrata05, 
        hrata05_name  LIKE hrag_file.hrag07,
        hrata06       LIKE hrata_file.hrata06,
        hrata06_name  LIKE hrag_file.hrag07,
        hrata07       LIKE hrata_file.hrata07,   
        hrata08       LIKE hrata_file.hrata08,
        hrata08_name  LIKE hrag_file.hrag07 
                    END RECORD,
    g_wc2_a,g_sql_a    LIKE type_file.chr1000,       
    g_rec_b_a         LIKE type_file.num5,                #單身筆數        
    l_ac_a            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_a STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_a           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_a(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_a_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_a"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hrata01,hrat02",FALSE)
   LET g_wc2_a = '1=1'
   CALL i006_a_b_fill(g_wc2_a)
   CALL i006_a_menu()
   CLOSE WINDOW i006_a_w                   
END FUNCTION
 
FUNCTION i006_a_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_a_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_a_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_a_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrata),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_a_q()
   CALL i006_a_b_askkey()
END FUNCTION
  
FUNCTION i006_a_b()
DEFINE
   l_ac_a_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
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
 
   LET g_forupd_sql_a = "SELECT hrata01,'',hrata02,hrata03,hrata04,hrata05,'',hrata06,'',hrata07,hrata08,''",   
                      "  FROM hrata_file WHERE hrata01 = ? AND hrata02= ? AND hrata03 = ? FOR UPDATE"
   LET g_forupd_sql_a = cl_forupd_sql(g_forupd_sql_a)
   DECLARE i006_a_bcl CURSOR FROM g_forupd_sql_a      # LOCK CURSOR
 
   INPUT ARRAY g_hrata WITHOUT DEFAULTS FROM s_hrata.*
     ATTRIBUTE (COUNT=g_rec_b_a,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) # 30150318:开启删除功能 
 
       BEFORE INPUT
          IF g_rec_b_a != 0 THEN
             CALL fgl_set_arr_curr(l_ac_a)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_a = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_a>=l_ac_a THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hrata_t.* = g_hrata[l_ac_a].*  #BACKUP
             OPEN i006_a_bcl USING g_hrat.hratid,g_hrata_t.hrata02,g_hrata_t.hrata03
             IF STATUS THEN
                CALL cl_err("OPEN i006_a_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_a_bcl INTO g_hrata[l_ac_a].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrata_t.hrata02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()    
             CALL i006_a_hrag('308',g_hrata[l_ac_a].hrata05) RETURNING g_hrata[l_ac_a].hrata05_name
             CALL i006_a_hrag('203',g_hrata[l_ac_a].hrata06) RETURNING g_hrata[l_ac_a].hrata06_name
             CALL i006_a_hrag('309',g_hrata[l_ac_a].hrata08) RETURNING g_hrata[l_ac_a].hrata08_name 
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hrata[l_ac_a].* TO NULL     
          LET g_hrata_t.* = g_hrata[l_ac_a].*         #新輸入資料 
          LET g_hrata[l_ac_a].hrata01 = g_hrat.hratid
          SELECT hrat02 INTO g_hrata[l_ac_a].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          CALL cl_show_fld_cont()   
          NEXT FIELD hrata02
          
       AFTER FIELD hrata02
          IF NOT cl_null(g_hrata[l_ac_a].hrata03) THEN
          	 IF g_hrata[l_ac_a].hrata02 > g_hrata[l_ac_a].hrata03 THEN
          	 	  CALL cl_err('','alm1038',0)
          	 	  NEXT FIELD hrata02
          	 END IF
          END IF 	 		  
          IF g_hrata[l_ac_a].hrata02 > g_today THEN
          	 CALL cl_err('','ghr-036',0)
          	 NEXT FIELD hrata02
          END IF	 
       AFTER FIELD hrata03
          IF NOT cl_null(g_hrata[l_ac_a].hrata02) THEN
          	 IF g_hrata[l_ac_a].hrata02 > g_hrata[l_ac_a].hrata03 THEN
          	 	  CALL cl_err('','ams-820',0)
          	 	  NEXT FIELD hrata03
          	 END IF
          END IF 	 		  
          IF g_hrata[l_ac_a].hrata03 > g_today THEN
          	 CALL cl_err('','ghr-037',0)
          	 NEXT FIELD hrata03
          END IF	 
     AFTER FIELD hrata05
          IF NOT cl_null(g_hrata[l_ac_a].hrata05) THEN 
             CALL i006_a_hrag('308',g_hrata[l_ac_a].hrata05) RETURNING g_hrata[l_ac_a].hrata05_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hrata[l_ac_a].hrata05,g_errno,0)  
                LET g_hrata[l_ac_a].hrata05_name = ''
                NEXT FIELD hrata05
             END IF
             DISPLAY BY NAME g_hrata[l_ac_a].hrata05_name
          END IF 
     AFTER FIELD hrata06
          IF NOT cl_null(g_hrata[l_ac_a].hrata06) THEN 
             CALL i006_a_hrag('203',g_hrata[l_ac_a].hrata06) RETURNING g_hrata[l_ac_a].hrata06_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hrata[l_ac_a].hrata06,g_errno,0)  
                LET g_hrata[l_ac_a].hrata06_name = ''
                NEXT FIELD hrata06
             END IF
             DISPLAY BY NAME g_hrata[l_ac_a].hrata06_name
          END IF 
     AFTER FIELD hrata08
          IF NOT cl_null(g_hrata[l_ac_a].hrata08) THEN 
             CALL i006_a_hrag('309',g_hrata[l_ac_a].hrata08) RETURNING g_hrata[l_ac_a].hrata08_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hrata[l_ac_a].hrata08,g_errno,0)  
                LET g_hrata[l_ac_a].hrata08_name = ''
                NEXT FIELD hrata08
             END IF
             DISPLAY BY NAME g_hrata[l_ac_a].hrata08_name
          END IF           	          	          	        
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_a_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hrata_file(hrata01,hrata02,hrata03,hrata04,hrata05,hrata06,hrata07,hrata08)  
          VALUES(g_hrata[l_ac_a].hrata01,g_hrata[l_ac_a].hrata02,g_hrata[l_ac_a].hrata03,g_hrata[l_ac_a].hrata04,
                 g_hrata[l_ac_a].hrata05,g_hrata[l_ac_a].hrata06,g_hrata[l_ac_a].hrata07,g_hrata[l_ac_a].hrata08)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hrata_file",g_hrata[l_ac_a].hrata02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_a=g_rec_b_a+1
             DISPLAY g_rec_b_a TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hrata_t.hrata02 IS NOT NULL AND g_hrata_t.hrata03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hrata02"               
             LET g_doc.value1 = g_hrata[l_ac_a].hrata02      
             LET g_doc.column2 = "hrata03"
             LET g_doc.value2 = g_hrata[l_ac_a].hrata03 
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hrata_file WHERE hrata01 = g_hrat.hratid AND hrata02 = g_hrata_t.hrata02 AND  hrata03 = g_hrata_t.hrata03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hrata_file",g_hrata_t.hrata02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_a=g_rec_b_a-1
             DISPLAY g_rec_b_a TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hrata[l_ac_a].* = g_hrata_t.*
             CLOSE i006_a_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hrata[l_ac_a].hrata02,-263,0)
             LET g_hrata[l_ac_a].* = g_hrata_t.*
          ELSE
             UPDATE hrata_file SET hrata02=g_hrata[l_ac_a].hrata02,
                                 hrata03=g_hrata[l_ac_a].hrata03,
                                 hrata04=g_hrata[l_ac_a].hrata04, 
                                 hrata05=g_hrata[l_ac_a].hrata05,
                                 hrata06=g_hrata[l_ac_a].hrata06,
                                 hrata07=g_hrata[l_ac_a].hrata07,
                                 hrata08=g_hrata[l_ac_a].hrata08  
                           WHERE hrata01 = g_hrat.hratid 
                             AND hrata02 = g_hrata_t.hrata02 
                             AND  hrata03 = g_hrata_t.hrata03  
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrata_file",g_hrata_t.hrata02,"",SQLCA.sqlcode,"","",1)  
                LET g_hrata[l_ac_a].* = g_hrata_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_a = ARR_CURR()            
          LET l_ac_a_t = l_ac_a             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hrata[l_ac_a].* = g_hrata_t.*
             END IF
             CLOSE i006_a_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_a_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrata05)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '308'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hrata[l_ac_a].hrata05
                  CALL cl_create_qry() RETURNING g_hrata[l_ac_a].hrata05
                  DISPLAY BY NAME g_hrata[l_ac_a].hrata05
                  NEXT FIELD hrata05     
             WHEN INFIELD(hrata06)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '203'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hrata[l_ac_a].hrata06
                  CALL cl_create_qry() RETURNING g_hrata[l_ac_a].hrata06
                  DISPLAY BY NAME g_hrata[l_ac_a].hrata06
                  NEXT FIELD hrata06 
             WHEN INFIELD(hrata08)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '309'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hrata[l_ac_a].hrata08
                  CALL cl_create_qry() RETURNING g_hrata[l_ac_a].hrata08
                  DISPLAY BY NAME g_hrata[l_ac_a].hrata08
                  NEXT FIELD hrata08     
          END CASE                                             	  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hrata02) AND l_ac_a > 1 THEN
             LET g_hrata[l_ac_a].* = g_hrata[l_ac_a-1].*
             NEXT FIELD hrata02
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
 
   CLOSE i006_a_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_a_b_askkey()
 
   CLEAR FORM
   CALL g_hrata.clear()
   CONSTRUCT g_wc2_a ON hrata01,hrata02,hrata03,hrata04,hrata05,hrata06,hrata07,hrata08  
        FROM s_hrata[1].hrata01,s_hrata[1].hrata02,s_hrata[1].hrata03,s_hrata[1].hrata04,
             s_hrata[1].hrata05,s_hrata[1].hrata06,s_hrata[1].hrata07,s_hrata[1].hrata08
 
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
             WHEN INFIELD(hrata01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrat01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrata01
                  NEXT FIELD hrata01  
             WHEN INFIELD(hrata05)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '308'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrata05
                  NEXT FIELD hrata05     
             WHEN INFIELD(hrata06)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '203'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrata06
                  NEXT FIELD hrata06 
             WHEN INFIELD(hrata08)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '309'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrata08
                  NEXT FIELD hrata08                      
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_a = NULL
      RETURN
   END IF
   CALL i006_a_b_fill(g_wc2_a)
END FUNCTION
 
FUNCTION i006_a_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql_a =
        "SELECT hrata01,'',hrata02,hrata03,hrata04,hrata05,'',hrata06,'',hrata07,hrata08,''",   
        " FROM hrata_file", 
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hrata01 = '",g_hrat.hratid,"'",
        " ORDER BY hrata01,hrata02,hrata03,hrata04"
    PREPARE i006_a_pb FROM g_sql_a
    DECLARE hrata_curs CURSOR FOR i006_a_pb
 
    CALL g_hrata.clear()
    LET g_cnt_a = 1
    MESSAGE "Searching!" 
    FOREACH hrata_curs INTO g_hrata[g_cnt_a].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hrata[g_cnt_a].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
        CALL i006_a_hrag('308',g_hrata[g_cnt_a].hrata05) RETURNING g_hrata[g_cnt_a].hrata05_name
        CALL i006_a_hrag('203',g_hrata[g_cnt_a].hrata06) RETURNING g_hrata[g_cnt_a].hrata06_name
        CALL i006_a_hrag('309',g_hrata[g_cnt_a].hrata08) RETURNING g_hrata[g_cnt_a].hrata08_name 
        LET g_cnt_a = g_cnt_a + 1
        IF g_cnt_a > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrata.deleteElement(g_cnt_a)
    MESSAGE ""
    LET g_rec_b_a = g_cnt_a-1
    DISPLAY g_rec_b_a TO FORMONLY.cn2  
    LET g_cnt_a = 0
 
END FUNCTION
 
FUNCTION i006_a_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrata TO s_hrata.* ATTRIBUTE(COUNT=g_rec_b_a)
 
      BEFORE ROW
      LET l_ac_a = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_a = 1
         LET l_ac_a = 1
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
         LET l_ac_a = ARR_CURR()
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
 
FUNCTION i006_a_hrag(p_hrag01,p_hrag06) 
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

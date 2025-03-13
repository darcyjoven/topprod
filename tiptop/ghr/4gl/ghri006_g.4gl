# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_g.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
  # 30150318:开启删除功能 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hratg         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hratg01       LIKE hratg_file.hratg01,
        hrat02        LIKE hrat_file.hrat02,
        hratg02       LIKE hratg_file.hratg02,   
        hratg03       LIKE hratg_file.hratg03,  
        hratg04       LIKE hratg_file.hratg04,
        hratg04_name  LIKE hraa_file.hraa02,
        hratg05       LIKE hratg_file.hratg05,  
        hratg06       LIKE hratg_file.hratg06 
        
           
                    END RECORD,
    g_hratg_t        RECORD                 #程式變數 (舊值)
        hratg01       LIKE hratg_file.hratg01,
        hrat02        LIKE hrat_file.hrat02,
        hratg02       LIKE hratg_file.hratg02,   
        hratg03       LIKE hratg_file.hratg03, 
        hratg04       LIKE hratg_file.hratg04,
        hratg04_name  LIKE hraa_file.hraa02,
        hratg05       LIKE hratg_file.hratg05,  
        hratg06       LIKE hratg_file.hratg06
                    END RECORD,
    g_wc2_g,g_sql_g    LIKE type_file.chr1000,       
    g_rec_b_g         LIKE type_file.num5,                #單身筆數        
    l_ac_g            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_g STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_g           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_g(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_g_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_g"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hratg01,hrat02",FALSE)
   LET g_wc2_g = '1=1'
   CALL i006_g_b_fill(g_wc2_g)
   CALL i006_g_menu()
   CLOSE WINDOW i006_g_w                   
END FUNCTION
 
FUNCTION i006_g_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_g_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_g_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_g_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hratg),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_g_q()
   CALL i006_g_b_askkey()
END FUNCTION
  
FUNCTION i006_g_b()
DEFINE
   l_ac_g_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
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
 
   LET g_forupd_sql_g = "SELECT hratg01,'',hratg02,hratg03,hratg04,'',hratg05,hratg06",   
                      "  FROM hratg_file WHERE hratg01 = ? AND hratg02= ? FOR UPDATE"
   LET g_forupd_sql_g = cl_forupd_sql(g_forupd_sql_g)
   DECLARE i006_g_bcl CURSOR FROM g_forupd_sql_g      # LOCK CURSOR
 
   INPUT ARRAY g_hratg WITHOUT DEFAULTS FROM s_hratg.*
     ATTRIBUTE (COUNT=g_rec_b_g,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)  # 30150318:开启删除功能 
 
       BEFORE INPUT
          IF g_rec_b_g != 0 THEN
             CALL fgl_set_arr_curr(l_ac_g)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_g = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_g>=l_ac_g THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hratg_t.* = g_hratg[l_ac_g].*  #BACKUP
             OPEN i006_g_bcl USING g_hrat.hratid,g_hratg_t.hratg02
             IF STATUS THEN
                CALL cl_err("OPEN i006_g_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_g_bcl INTO g_hratg[l_ac_g].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hratg_t.hratg02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()     
             CALL i006_g_hratg04(g_hratg[l_ac_g].hratg04) RETURNING g_hratg[l_ac_g].hratg04_name   
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hratg[l_ac_g].* TO NULL     
          LET g_hratg_t.* = g_hratg[l_ac_g].*         #新輸入資料 
          LET g_hratg[l_ac_g].hratg01 = g_hrat.hratid
          SELECT hrat02 INTO g_hratg[l_ac_g].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          CALL cl_show_fld_cont()   
          NEXT FIELD hratg02
          
       AFTER FIELD hratg02
          IF NOT cl_null(g_hratg[l_ac_g].hratg02) THEN
             CALL i006_g_hratg02(g_hratg[l_ac_g].hratg02)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratg[l_ac_g].hratg02,g_errno,0)   
                NEXT FIELD hratg02
             END IF  
             SELECT hraq02 INTO g_hratg[l_ac_g].hratg05 FROM hraq_file
              WHERE hraq01 = g_hratg[l_ac_g].hratg02
             DISPLAY BY NAME g_hratg[l_ac_g].hratg05	
          END IF 	 		      
      AFTER FIELD hratg04
          IF NOT cl_null(g_hratg[l_ac_g].hratg04) THEN 
             CALL i006_g_hratg04(g_hratg[l_ac_g].hratg04) RETURNING g_hratg[l_ac_g].hratg04_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratg[l_ac_g].hratg04,g_errno,0)  
                LET g_hratg[l_ac_g].hratg04_name = ''
                NEXT FIELD hratg04
             END IF 
             DISPLAY BY NAME g_hratg[l_ac_g].hratg04_name
          END IF       	           	          	          	        
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_g_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hratg_file(hratg01,hratg02,hratg03,hratg04,hratg05,hratg06)  
          VALUES(g_hratg[l_ac_g].hratg01,g_hratg[l_ac_g].hratg02,g_hratg[l_ac_g].hratg03,g_hratg[l_ac_g].hratg04,
                 g_hratg[l_ac_g].hratg05,g_hratg[l_ac_g].hratg06)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hratg_file",g_hratg[l_ac_g].hratg02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_g=g_rec_b_g+1
             DISPLAY g_rec_b_g TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hratg_t.hratg02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hratg02"               
             LET g_doc.value1 = g_hratg[l_ac_g].hratg02    
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hratg_file WHERE hratg01 = g_hrat.hratid AND hratg02 = g_hratg_t.hratg02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hratg_file",g_hratg_t.hratg02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_g=g_rec_b_g-1
             DISPLAY g_rec_b_g TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hratg[l_ac_g].* = g_hratg_t.*
             CLOSE i006_g_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hratg[l_ac_g].hratg02,-263,0)
             LET g_hratg[l_ac_g].* = g_hratg_t.*
          ELSE
             UPDATE hratg_file SET hratg02=g_hratg[l_ac_g].hratg02,
                                 hratg03=g_hratg[l_ac_g].hratg03,
                                 hratg04=g_hratg[l_ac_g].hratg04, 
                                 hratg05=g_hratg[l_ac_g].hratg05,
                                 hratg06=g_hratg[l_ac_g].hratg06
                           WHERE hratg01 = g_hrat.hratid 
                             AND hratg02 = g_hratg_t.hratg02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hratg_file",g_hratg_t.hratg02,"",SQLCA.sqlcode,"","",1)  
                LET g_hratg[l_ac_g].* = g_hratg_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_g = ARR_CURR()            
          LET l_ac_g_t = l_ac_g             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hratg[l_ac_g].* = g_hratg_t.*
             END IF
             CLOSE i006_g_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_g_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(hratg02)   
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_hraq02"
                  LET g_qryparam.default1 = g_hratg[l_ac_g].hratg02
                  CALL cl_create_qry() RETURNING g_hratg[l_ac_g].hratg02
                  DISPLAY BY NAME g_hratg[l_ac_g].hratg02
                  NEXT FIELD hratg02     
             WHEN INFIELD(hratg04)   
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_hraa01"
                  LET g_qryparam.default1 = g_hratg[l_ac_g].hratg04
                  CALL cl_create_qry() RETURNING g_hratg[l_ac_g].hratg04
                  DISPLAY BY NAME g_hratg[l_ac_g].hratg04
                  NEXT FIELD hratg04 
          END CASE                                             	  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hratg02) AND l_ac_g > 1 THEN
             LET g_hratg[l_ac_g].* = g_hratg[l_ac_g-1].*
             NEXT FIELD hratg02
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
 
   CLOSE i006_g_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_g_b_askkey()
 
   CLEAR FORM
   CALL g_hratg.clear()
   CONSTRUCT g_wc2_g ON hratg01,hratg02,hratg03,hratg04,hratg05,hratg06
        FROM s_hratg[1].hratg01,s_hratg[1].hratg02,s_hratg[1].hratg03,s_hratg[1].hratg04,
             s_hratg[1].hratg05,s_hratg[1].hratg06
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
             WHEN INFIELD(hratg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrat01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratg01
                  NEXT FIELD hratg01  
             WHEN INFIELD(hratg02)   
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_hraq02"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratg02
                  NEXT FIELD hratg02    
             WHEN INFIELD(hratg04)   
                  CALL cl_init_qry_var() 
                  LET g_qryparam.form = "q_hraa01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratg04
                  NEXT FIELD hratg04             
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_g = NULL
      RETURN
   END IF
   CALL i006_g_b_fill(g_wc2_g)
END FUNCTION
 
FUNCTION i006_g_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
    
    LET g_sql_g =
        "SELECT hratg01,'',hratg02,hratg03,hratg04,'',hratg05,hratg06",   
        " FROM hratg_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hratg01 = '",g_hrat.hratid,"'",
        " ORDER BY hratg01,hratg02,hratg03,hratg04"
    PREPARE i006_g_pb FROM g_sql_g
    DECLARE hratg_curs CURSOR FOR i006_g_pb
 
    CALL g_hratg.clear()
    LET g_cnt_g = 1
    MESSAGE "Searching!" 
    FOREACH hratg_curs INTO g_hratg[g_cnt_g].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hratg[g_cnt_g].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid 
        CALL i006_g_hratg04(g_hratg[g_cnt_g].hratg04) RETURNING g_hratg[g_cnt_g].hratg04_name  
        LET g_cnt_g = g_cnt_g + 1
        IF g_cnt_g > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hratg.deleteElement(g_cnt_g)
    MESSAGE ""
    LET g_rec_b_g = g_cnt_g-1
    DISPLAY g_rec_b_g TO FORMONLY.cn2  
    LET g_cnt_g = 0
 
END FUNCTION
 
FUNCTION i006_g_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hratg TO s_hratg.* ATTRIBUTE(COUNT=g_rec_b_g)
 
      BEFORE ROW
      LET l_ac_g = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_g = 1 
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
         LET l_ac_g = ARR_CURR()
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

FUNCTION i006_g_hratg02(p_hraq02)  
   DEFINE p_hraq02   LIKE hraq_file.hraq02   
   DEFINE l_hraqacti LIKE hraq_file.hraqacti
 
   LET g_errno=''
   SELECT hraqacti INTO l_hraqacti FROM hraq_file
    WHERE hraq01=p_hraq02 AND rownum = 1
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='ghr-038' 
       WHEN l_hraqacti = 'N'    LET g_errno='9028'                          
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE 
END FUNCTION	
	
FUNCTION i006_g_hratg04(p_hraa01)  
	 DEFINE p_hraa01   LIKE hraa_file.hraa01  
   DEFINE l_hraa02   LIKE hraa_file.hraa02  
   DEFINE l_hraaacti LIKE hraa_file.hraaacti
 
   LET g_errno=''
   SELECT hraa02,hraaacti INTO l_hraa02,l_hraaacti FROM hraa_file
    WHERE hraa01=p_hraa01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-446'
                                LET l_hraa02=NULL 
       WHEN l_hraaacti = 'N'    LET g_errno='9028'                          
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   RETURN l_hraa02
END FUNCTION
	

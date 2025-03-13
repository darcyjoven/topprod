# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_h.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
# 30150318:开启删除功能 
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hrath         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hrath01       LIKE hrath_file.hrath01,
        hrat02        LIKE hrat_file.hrat02,
        hrath02       LIKE hrath_file.hrath02, 
        hrath03       LIKE hrath_file.hrath03,
        hrath03_name  LIKE hrag_file.hrag07,   
        hrath04       LIKE hrath_file.hrath04,
        hrath05       LIKE hrath_file.hrath05,  
        hrath06       LIKE hrath_file.hrath06, 
        hrath07       LIKE hrath_file.hrath07,   
        hrath08       LIKE hrath_file.hrath08,
        hrath09       LIKE hrath_file.hrath09
           
                    END RECORD,
    g_hrath_t        RECORD                 #程式變數 (舊值)
        hrath01       LIKE hrath_file.hrath01,
        hrat02        LIKE hrat_file.hrat02,
        hrath02       LIKE hrath_file.hrath02,    
        hrath03       LIKE hrath_file.hrath03,
        hrath03_name  LIKE hrag_file.hrag07,   
        hrath04       LIKE hrath_file.hrath04,
        hrath05       LIKE hrath_file.hrath05,  
        hrath06       LIKE hrath_file.hrath06, 
        hrath07       LIKE hrath_file.hrath07,   
        hrath08       LIKE hrath_file.hrath08,
        hrath09       LIKE hrath_file.hrath09
                    END RECORD,
    g_wc2_h,g_sql_h    LIKE type_file.chr1000,       
    g_rec_b_h         LIKE type_file.num5,                #單身筆數        
    l_ac_h            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_h STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_h           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_h(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_h_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_h"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hrath01,hrat02",FALSE)
   LET g_wc2_h = '1=1'
   CALL i006_h_b_fill(g_wc2_h)
   CALL i006_h_menu()
   CLOSE WINDOW i006_h_w                   
END FUNCTION
 
FUNCTION i006_h_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_h_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_h_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_h_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrath),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_h_q()
   CALL i006_h_b_askkey()
END FUNCTION
  
FUNCTION i006_h_b()
DEFINE
   l_ac_h_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
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
 
   LET g_forupd_sql_h = "SELECT hrath01,'',hrath02,hrath03,'',hrath04,hrath05,hrath06,hrath07,hrath08,hrath09",   
                      "  FROM hrath_file WHERE hrath01 = ? AND hrath02= ? AND hrath03= ? FOR UPDATE"
   LET g_forupd_sql_h = cl_forupd_sql(g_forupd_sql_h)
   DECLARE i006_h_bcl CURSOR FROM g_forupd_sql_h      # LOCK CURSOR
 
   INPUT ARRAY g_hrath WITHOUT DEFAULTS FROM s_hrath.*
     ATTRIBUTE (COUNT=g_rec_b_h,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) # 30150318:开启删除功能 
 
       BEFORE INPUT
          IF g_rec_b_h != 0 THEN
             CALL fgl_set_arr_curr(l_ac_h)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_h = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_h>=l_ac_h THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hrath_t.* = g_hrath[l_ac_h].*  #BACKUP
             OPEN i006_h_bcl USING g_hrat.hratid,g_hrath_t.hrath02,g_hrath_t.hrath03
             IF STATUS THEN
                CALL cl_err("OPEN i006_h_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_h_bcl INTO g_hrath[l_ac_h].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrath_t.hrath02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()    
             CALL i006_h_hrag('323',g_hrath[l_ac_h].hrath03) RETURNING g_hrath[l_ac_h].hrath03_name 
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hrath[l_ac_h].* TO NULL     
          LET g_hrath_t.* = g_hrath[l_ac_h].*         #新輸入資料 
          LET g_hrath[l_ac_h].hrath01 = g_hrat.hratid
          SELECT hrat02 INTO g_hrath[l_ac_h].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          CALL cl_show_fld_cont()   
          NEXT FIELD hrath02
           
     AFTER FIELD hrath03
          IF NOT cl_null(g_hrath[l_ac_h].hrath03) THEN 
             CALL i006_h_hrag('323',g_hrath[l_ac_h].hrath03) RETURNING g_hrath[l_ac_h].hrath03_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hrath[l_ac_h].hrath03,g_errno,0)  
                LET g_hrath[l_ac_h].hrath03_name = ''
                NEXT FIELD hrath03
             END IF
             DISPLAY BY NAME g_hrath[l_ac_h].hrath03_name
          END IF    	          	        
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_h_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hrath_file(hrath01,hrath02,hrath03,hrath04,hrath05,hrath06,hrath07,hrath08,hrath09)  
          VALUES(g_hrath[l_ac_h].hrath01,g_hrath[l_ac_h].hrath02,g_hrath[l_ac_h].hrath03,g_hrath[l_ac_h].hrath04,
                 g_hrath[l_ac_h].hrath05,g_hrath[l_ac_h].hrath06,g_hrath[l_ac_h].hrath07,g_hrath[l_ac_h].hrath08,g_hrath[l_ac_h].hrath09)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hrath_file",g_hrath[l_ac_h].hrath02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_h=g_rec_b_h+1
             DISPLAY g_rec_b_h TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hrath_t.hrath02 IS NOT NULL AND g_hrath_t.hrath03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hrath02"               
             LET g_doc.value1 = g_hrath[l_ac_h].hrath02  
             LET g_doc.column2 = "hrath03"               
             LET g_doc.value2 = g_hrath[l_ac_h].hrath03      
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hrath_file WHERE hrath01 = g_hrat.hratid AND hrath02 = g_hrath_t.hrath02 AND hrath03 = g_hrath_t.hrath03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hrath_file",g_hrath_t.hrath02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_h=g_rec_b_h-1
             DISPLAY g_rec_b_h TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hrath[l_ac_h].* = g_hrath_t.*
             CLOSE i006_h_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hrath[l_ac_h].hrath02,-263,0)
             LET g_hrath[l_ac_h].* = g_hrath_t.*
          ELSE
             UPDATE hrath_file SET hrath02=g_hrath[l_ac_h].hrath02,
                                 hrath03=g_hrath[l_ac_h].hrath03,
                                 hrath04=g_hrath[l_ac_h].hrath04, 
                                 hrath05=g_hrath[l_ac_h].hrath05,
                                 hrath06=g_hrath[l_ac_h].hrath06,
                                 hrath07=g_hrath[l_ac_h].hrath07,
                                 hrath08=g_hrath[l_ac_h].hrath08,
                                 hrath09=g_hrath[l_ac_h].hrath09  
                           WHERE hrath01 = g_hrat.hratid 
                             AND hrath02 = g_hrath_t.hrath02  
                             AND hrath03 = g_hrath_t.hrath03  
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrath_file",g_hrath_t.hrath02,"",SQLCA.sqlcode,"","",1)  
                LET g_hrath[l_ac_h].* = g_hrath_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_h = ARR_CURR()            
          LET l_ac_h_t = l_ac_h             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hrath[l_ac_h].* = g_hrath_t.*
             END IF
             CLOSE i006_h_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_h_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrath03)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '323'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hrath[l_ac_h].hrath03
                  CALL cl_create_qry() RETURNING g_hrath[l_ac_h].hrath03
                  DISPLAY BY NAME g_hrath[l_ac_h].hrath03
                  NEXT FIELD hrath03 
          END CASE                                             	  
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hrath02) AND l_ac_h > 1 THEN
             LET g_hrath[l_ac_h].* = g_hrath[l_ac_h-1].*
             NEXT FIELD hrath02
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
 
   CLOSE i006_h_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_h_b_askkey()
 
   CLEAR FORM
   CALL g_hrath.clear()
   CONSTRUCT g_wc2_h ON hrath01,hrath02,hrath03,hrath04,hrath05,hrath06,hrath07,hrath08,hrath09
        FROM s_hrath[1].hrath01,s_hrath[1].hrath02,s_hrath[1].hrath03,s_hrath[1].hrath04,
             s_hrath[1].hrath05,s_hrath[1].hrath06,s_hrath[1].hrath07,s_hrath[1].hrath08,s_hrath[1].hrath09
 
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
             WHEN INFIELD(hrath01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrat01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrath01
                  NEXT FIELD hrath01  
             WHEN INFIELD(hrath03)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '323'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hrath03
                  NEXT FIELD hrath03                      
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_h = NULL
      RETURN
   END IF
   CALL i006_h_b_fill(g_wc2_h)
END FUNCTION
 
FUNCTION i006_h_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql_h =
        "SELECT hrath01,'',hrath02,hrath03,'',hrath04,hrath05,hrath06,hrath07,hrath08,hrath09",   
        " FROM hrath_file", 
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hrath01 = '",g_hrat.hratid,"'",
        " ORDER BY hrath01,hrath02,hrath03,hrath04"
    PREPARE i006_h_pb FROM g_sql_h
    DECLARE hrath_curs CURSOR FOR i006_h_pb
 
    CALL g_hrath.clear()
    LET g_cnt_h = 1
    MESSAGE "Searching!" 
    FOREACH hrath_curs INTO g_hrath[g_cnt_h].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hrath[g_cnt_h].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
        CALL i006_h_hrag('323',g_hrath[g_cnt_h].hrath03) RETURNING g_hrath[g_cnt_h].hrath03_name 
        LET g_cnt_h = g_cnt_h + 1
        IF g_cnt_h > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrath.deleteElement(g_cnt_h)
    MESSAGE ""
    LET g_rec_b_h = g_cnt_h-1
    DISPLAY g_rec_b_h TO FORMONLY.cn2  
    LET g_cnt_h = 0
 
END FUNCTION
 
FUNCTION i006_h_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrath TO s_hrath.* ATTRIBUTE(COUNT=g_rec_b_h)
 
      BEFORE ROW
      LET l_ac_h = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_h = 1
         LET l_ac_h = 1
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
         LET l_ac_h = ARR_CURR()
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
 
FUNCTION i006_h_hrag(p_hrag01,p_hrag06) 
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

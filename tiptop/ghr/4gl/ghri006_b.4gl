# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_b.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
  # 30150318:开启删除功能 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hratb         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hratb01       LIKE hratb_file.hratb01,
        hrat02        LIKE hrat_file.hrat02,
        hratb02       LIKE hratb_file.hratb02,   
        hratb03       LIKE hratb_file.hratb03,   
        hratb04       LIKE hratb_file.hratb04,
        hratb05       LIKE hratb_file.hratb05, 
        hratb06       LIKE hratb_file.hratb06,
        hratb07       LIKE hratb_file.hratb07,   
        hratb08       LIKE hratb_file.hratb08  
           
                    END RECORD,
    g_hratb_t        RECORD                 #程式變數 (舊值)
        hratb01       LIKE hratb_file.hratb01,
        hrat02        LIKE hrat_file.hrat02,
        hratb02       LIKE hratb_file.hratb02,   
        hratb03       LIKE hratb_file.hratb03,   
        hratb04       LIKE hratb_file.hratb04,
        hratb05       LIKE hratb_file.hratb05, 
        hratb06       LIKE hratb_file.hratb06,
        hratb07       LIKE hratb_file.hratb07,   
        hratb08       LIKE hratb_file.hratb08
                    END RECORD,
    g_wc2_b,g_sql_b    LIKE type_file.chr1000,       
    g_rec_b_b         LIKE type_file.num5,                #單身筆數        
    l_ac_b            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_b STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_b           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_b(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_b_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_b"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hratb01,hrat02",FALSE)
   LET g_wc2_b = '1=1'
   CALL i006_b_b_fill(g_wc2_b)
   CALL i006_b_menu()
   CLOSE WINDOW i006_b_w                   
END FUNCTION
 
FUNCTION i006_b_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_b_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_b_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_b_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hratb),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_b_q()
   CALL i006_b_b_askkey()
END FUNCTION
  
FUNCTION i006_b_b()
DEFINE
   l_ac_b_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
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
 
   LET g_forupd_sql_b = "SELECT hratb01,'',hratb02,hratb03,hratb04,hratb05,hratb06,hratb07,hratb08",   
                      "  FROM hratb_file WHERE hratb01 = ? AND hratb02= ? AND hratb03 = ? AND hratb04 = ? FOR UPDATE"
   LET g_forupd_sql_b = cl_forupd_sql(g_forupd_sql_b)
   DECLARE i006_b_bcl CURSOR FROM g_forupd_sql_b      # LOCK CURSOR
 
   INPUT ARRAY g_hratb WITHOUT DEFAULTS FROM s_hratb.*
     ATTRIBUTE (COUNT=g_rec_b_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)  # 30150318:开启删除功能 
 
       BEFORE INPUT
          IF g_rec_b_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac_b)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_b = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_b>=l_ac_b THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hratb_t.* = g_hratb[l_ac_b].*  #BACKUP
             OPEN i006_b_bcl USING g_hrat.hratid,g_hratb_t.hratb02,g_hratb_t.hratb03,g_hratb_t.hratb04
             IF STATUS THEN
                CALL cl_err("OPEN i006_b_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_b_bcl INTO g_hratb[l_ac_b].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hratb_t.hratb02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()    
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hratb[l_ac_b].* TO NULL     
          LET g_hratb_t.* = g_hratb[l_ac_b].*         #新輸入資料 
          LET g_hratb[l_ac_b].hratb01 = g_hrat.hratid
          SELECT hrat02 INTO g_hratb[l_ac_b].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          CALL cl_show_fld_cont()   
          NEXT FIELD hratb02
          
       AFTER FIELD hratb02
          IF NOT cl_null(g_hratb[l_ac_b].hratb03) THEN
          	 IF g_hratb[l_ac_b].hratb02 > g_hratb[l_ac_b].hratb03 THEN
          	 	  CALL cl_err('','alm1038',0)
          	 	  NEXT FIELD hratb02
          	 END IF
          END IF 	 		  
          IF g_hratb[l_ac_b].hratb02 > g_today THEN
          	 CALL cl_err('','ghr-036',0)
          	 NEXT FIELD hratb02
          END IF	 
       AFTER FIELD hratb03
          IF NOT cl_null(g_hratb[l_ac_b].hratb02) THEN
          	 IF g_hratb[l_ac_b].hratb02 > g_hratb[l_ac_b].hratb03 THEN
          	 	  CALL cl_err('','ams-820',0)
          	 	  NEXT FIELD hratb03
          	 END IF
          END IF 	 		  
          IF g_hratb[l_ac_b].hratb03 > g_today THEN
          	 CALL cl_err('','ghr-037',0)
          	 NEXT FIELD hratb03
          END IF	         
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_b_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hratb_file(hratb01,hratb02,hratb03,hratb04,hratb05,hratb06,hratb07,hratb08)  
          VALUES(g_hratb[l_ac_b].hratb01,g_hratb[l_ac_b].hratb02,g_hratb[l_ac_b].hratb03,g_hratb[l_ac_b].hratb04,
                 g_hratb[l_ac_b].hratb05,g_hratb[l_ac_b].hratb06,g_hratb[l_ac_b].hratb07,g_hratb[l_ac_b].hratb08)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hratb_file",g_hratb[l_ac_b].hratb02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_b=g_rec_b_b+1
             DISPLAY g_rec_b_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hratb_t.hratb02 IS NOT NULL AND g_hratb_t.hratb03 IS NOT NULL AND g_hratb_t.hratb04 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hratb02"               
             LET g_doc.value1 = g_hratb[l_ac_b].hratb02      
             LET g_doc.column2 = "hratb03"
             LET g_doc.value2 = g_hratb[l_ac_b].hratb03
             LET g_doc.column3 = "hratb04"
             LET g_doc.value3 = g_hratb[l_ac_b].hratb04
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hratb_file WHERE hratb01 = g_hrat.hratid AND hratb02 = g_hratb_t.hratb02 AND  hratb03 = g_hratb_t.hratb03 AND  hratb04 = g_hratb_t.hratb04 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hratb_file",g_hratb_t.hratb02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_b=g_rec_b_b-1
             DISPLAY g_rec_b_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hratb[l_ac_b].* = g_hratb_t.*
             CLOSE i006_b_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hratb[l_ac_b].hratb02,-263,0)
             LET g_hratb[l_ac_b].* = g_hratb_t.*
          ELSE
             UPDATE hratb_file SET hratb02=g_hratb[l_ac_b].hratb02,
                                 hratb03=g_hratb[l_ac_b].hratb03,
                                 hratb04=g_hratb[l_ac_b].hratb04, 
                                 hratb05=g_hratb[l_ac_b].hratb05,
                                 hratb06=g_hratb[l_ac_b].hratb06,
                                 hratb07=g_hratb[l_ac_b].hratb07,
                                 hratb08=g_hratb[l_ac_b].hratb08  
                           WHERE hratb01 = g_hrat.hratid 
                             AND hratb02 = g_hratb_t.hratb02 
                             AND  hratb03 = g_hratb_t.hratb03 
                             AND  hratb04 = g_hratb_t.hratb04 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hratb_file",g_hratb_t.hratb02,"",SQLCA.sqlcode,"","",1)  
                LET g_hratb[l_ac_b].* = g_hratb_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_b = ARR_CURR()            
          LET l_ac_b_t = l_ac_b             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hratb[l_ac_b].* = g_hratb_t.*
             END IF
             CLOSE i006_b_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_b_bcl           
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hratb02) AND l_ac_b > 1 THEN
             LET g_hratb[l_ac_b].* = g_hratb[l_ac_b-1].*
             NEXT FIELD hratb02
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
 
   CLOSE i006_b_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_b_b_askkey()
 
   CLEAR FORM
   CALL g_hratb.clear()
   CONSTRUCT g_wc2_b ON hratb01,hratb02,hratb03,hratb04,hratb05,hratb06,hratb07,hratb08  
        FROM s_hratb[1].hratb01,s_hratb[1].hratb02,s_hratb[1].hratb03,s_hratb[1].hratb04,
             s_hratb[1].hratb05,s_hratb[1].hratb06,s_hratb[1].hratb07,s_hratb[1].hratb08
 
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
            WHEN INFIELD(hratb01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrat01"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hratb01
                 NEXT FIELD hratb01  
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_b = NULL
      RETURN
   END IF
   CALL i006_b_b_fill(g_wc2_b)
END FUNCTION
 
FUNCTION i006_b_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql_b =
        "SELECT hratb01,'',hratb02,hratb03,hratb04,hratb05,hratb06,hratb07,hratb08",   
        " FROM hratb_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hratb01 = '",g_hrat.hratid,"'",
        " ORDER BY hratb01,hratb02,hratb03,hratb04"
    PREPARE i006_b_pb FROM g_sql_b
    DECLARE hratb_curs CURSOR FOR i006_b_pb
 
    CALL g_hratb.clear()
    LET g_cnt_b = 1
    MESSAGE "Searching!" 
    FOREACH hratb_curs INTO g_hratb[g_cnt_b].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hratb[g_cnt_b].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
        LET g_cnt_b = g_cnt_b + 1
        IF g_cnt_b > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hratb.deleteElement(g_cnt_b)
    MESSAGE ""
    LET g_rec_b_b = g_cnt_b-1
    DISPLAY g_rec_b_b TO FORMONLY.cn2  
    LET g_cnt_b = 0
 
END FUNCTION
 
FUNCTION i006_b_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hratb TO s_hratb.* ATTRIBUTE(COUNT=g_rec_b_b)
 
      BEFORE ROW
      LET l_ac_b = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_b = 1
         LET l_ac_b = 1
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
         LET l_ac_b = ARR_CURR()
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
 

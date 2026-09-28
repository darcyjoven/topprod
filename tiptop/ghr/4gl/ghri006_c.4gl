# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_c.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
# 30150318:增加删除功能
# 20150325:取消学历’结束日期‘不能大于今天 的管控(XieYL)
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hratc         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hratc01       LIKE hratc_file.hratc01,
        hrat02        LIKE hrat_file.hrat02,
        hratc02       LIKE hratc_file.hratc02,   
        hratc03       LIKE hratc_file.hratc03,   
        hratc04       LIKE hratc_file.hratc04,
        hratc05       LIKE hratc_file.hratc05, 
        hratc05_name  LIKE hrag_file.hrag07,
        hratc06       LIKE hratc_file.hratc06,
        hratc07       LIKE hratc_file.hratc07,
        hratc07_name  LIKE hrag_file.hrag07,   
        hratc08       LIKE hratc_file.hratc08,
        hratc08_name  LIKE hrag_file.hrag07,
        hratc09       LIKE hratc_file.hratc09,
        hratc09_name  LIKE hrag_file.hrag07, 
        hratc10       LIKE hratc_file.hratc10,
        hratc11       LIKE hratc_file.hratc11,
        hratc11_name  LIKE hrag_file.hrag07,
        hratc12       LIKE hratc_file.hratc12,
        hratc13       LIKE hratc_file.hratc13 
        
           
                    END RECORD,
    g_hratc_t        RECORD                 #程式變數 (舊��?
        hratc01       LIKE hratc_file.hratc01,
        hrat02        LIKE hrat_file.hrat02,
        hratc02       LIKE hratc_file.hratc02,   
        hratc03       LIKE hratc_file.hratc03,   
        hratc04       LIKE hratc_file.hratc04,
        hratc05       LIKE hratc_file.hratc05, 
        hratc05_name  LIKE hrag_file.hrag07,
        hratc06       LIKE hratc_file.hratc06,
        hratc07       LIKE hratc_file.hratc07,
        hratc07_name  LIKE hrag_file.hrag07,   
        hratc08       LIKE hratc_file.hratc08,
        hratc08_name  LIKE hrag_file.hrag07,
        hratc09       LIKE hratc_file.hratc09,
        hratc09_name  LIKE hrag_file.hrag07, 
        hratc10       LIKE hratc_file.hratc10,
        hratc11       LIKE hratc_file.hratc11,
        hratc11_name  LIKE hrag_file.hrag07,
        hratc12       LIKE hratc_file.hratc12,
        hratc13       LIKE hratc_file.hratc13 
                    END RECORD,
    g_wc2_c,g_sql_c    LIKE type_file.chr1000,       
    g_rec_b_c         LIKE type_file.num5,                #單身筆數        
    l_ac_c            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_c STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_c           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_c(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_c_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_c"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hratc01,hrat02",FALSE)
   LET g_wc2_c = '1=1'
   CALL i006_c_b_fill(g_wc2_c)
   CALL i006_c_menu()
   CLOSE WINDOW i006_c_w                   
END FUNCTION
 
FUNCTION i006_c_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_c_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_c_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_c_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hratc),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_c_q()
   CALL i006_c_b_askkey()
END FUNCTION
  
FUNCTION i006_c_b()
DEFINE
   l_ac_c_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
   l_n             LIKE type_file.num5,                #檢查重複��?      
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住��?       
   p_cmd           LIKE type_file.chr1,                #處理狀��?       
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
 
   LET g_forupd_sql_c = "SELECT hratc01,'',hratc02,hratc03,hratc04,hratc05,'',hratc06,hratc07,'',hratc08,'',hratc09,'',hratc10,hratc11,'',hratc12,hratc13",   
                      "  FROM hratc_file WHERE hratc01 = ? AND hratc02= ? AND hratc03 = ? FOR UPDATE"
   LET g_forupd_sql_c = cl_forupd_sql(g_forupd_sql_c)
   DECLARE i006_c_bcl CURSOR FROM g_forupd_sql_c      # LOCK CURSOR
 
   INPUT ARRAY g_hratc WITHOUT DEFAULTS FROM s_hratc.*
     ATTRIBUTE (COUNT=g_rec_b_c,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) --20150318增加单身删除功能
 
       BEFORE INPUT
          IF g_rec_b_c != 0 THEN
             CALL fgl_set_arr_curr(l_ac_c)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_c = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_c>=l_ac_c THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hratc_t.* = g_hratc[l_ac_c].*  #BACKUP
             OPEN i006_c_bcl USING g_hrat.hratid,g_hratc_t.hratc02,g_hratc_t.hratc03
             IF STATUS THEN
                CALL cl_err("OPEN i006_c_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_c_bcl INTO g_hratc[l_ac_c].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hratc_t.hratc02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()    
             CALL i006_c_hrag('307',g_hratc[l_ac_c].hratc05) RETURNING g_hratc[l_ac_c].hratc05_name
             CALL i006_c_hrag('315',g_hratc[l_ac_c].hratc07) RETURNING g_hratc[l_ac_c].hratc07_name
             CALL i006_c_hrag('317',g_hratc[l_ac_c].hratc08) RETURNING g_hratc[l_ac_c].hratc08_name 
             CALL i006_c_hrag('316',g_hratc[l_ac_c].hratc09) RETURNING g_hratc[l_ac_c].hratc09_name
             CALL i006_c_hrag('203',g_hratc[l_ac_c].hratc11) RETURNING g_hratc[l_ac_c].hratc11_name
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hratc[l_ac_c].* TO NULL     
          LET g_hratc_t.* = g_hratc[l_ac_c].*         #新輸入資��?
          LET g_hratc[l_ac_c].hratc01 = g_hrat.hratid
          SELECT hrat02 INTO g_hratc[l_ac_c].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          CALL cl_show_fld_cont()   
          NEXT FIELD hratc02
          
       AFTER FIELD hratc02
          IF NOT cl_null(g_hratc[l_ac_c].hratc03) THEN
          	 IF g_hratc[l_ac_c].hratc02 > g_hratc[l_ac_c].hratc03 THEN
          	 	  CALL cl_err('','alm1038',0)
          	 	  NEXT FIELD hratc02
          	 END IF
          END IF 	 		  
          IF g_hratc[l_ac_c].hratc02 > g_today THEN
          	 CALL cl_err('','ghr-036',0)
          	 NEXT FIELD hratc02
          END IF	 
       AFTER FIELD hratc03
          IF NOT cl_null(g_hratc[l_ac_c].hratc02) THEN
          	 IF g_hratc[l_ac_c].hratc02 > g_hratc[l_ac_c].hratc03 THEN
          	 	  CALL cl_err('','ams-820',0)
          	 	  NEXT FIELD hratc03
          	 END IF
          END IF 	 
		  
#          IF g_hratc[l_ac_c].hratc03 > g_today THEN
 #         	 CALL cl_err('','ghr-037',0)
 #         	 NEXT FIELD hratc03
 #         END IF

     AFTER FIELD hratc05
          IF NOT cl_null(g_hratc[l_ac_c].hratc05) THEN 
             CALL i006_c_hrag('307',g_hratc[l_ac_c].hratc05) RETURNING g_hratc[l_ac_c].hratc05_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratc[l_ac_c].hratc05,g_errno,0)  
                LET g_hratc[l_ac_c].hratc05_name = ''
                NEXT FIELD hratc05
             END IF
             DISPLAY BY NAME g_hratc[l_ac_c].hratc05_name
          END IF 
     AFTER FIELD hratc07
          IF NOT cl_null(g_hratc[l_ac_c].hratc07) THEN 
             CALL i006_c_hrag('315',g_hratc[l_ac_c].hratc07) RETURNING g_hratc[l_ac_c].hratc07_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratc[l_ac_c].hratc07,g_errno,0)  
                LET g_hratc[l_ac_c].hratc07_name = ''
                NEXT FIELD hratc07
             END IF
             DISPLAY BY NAME g_hratc[l_ac_c].hratc07_name
          END IF 
     AFTER FIELD hratc08
          IF NOT cl_null(g_hratc[l_ac_c].hratc08) THEN 
             CALL i006_c_hrag('317',g_hratc[l_ac_c].hratc08) RETURNING g_hratc[l_ac_c].hratc08_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratc[l_ac_c].hratc08,g_errno,0)  
                LET g_hratc[l_ac_c].hratc08_name = ''
                NEXT FIELD hratc08
             END IF
             DISPLAY BY NAME g_hratc[l_ac_c].hratc08_name
          END IF
     AFTER FIELD hratc09
          IF NOT cl_null(g_hratc[l_ac_c].hratc09) THEN 
             CALL i006_c_hrag('316',g_hratc[l_ac_c].hratc09) RETURNING g_hratc[l_ac_c].hratc09_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratc[l_ac_c].hratc09,g_errno,0)  
                LET g_hratc[l_ac_c].hratc09_name = ''
                NEXT FIELD hratc09
             END IF
             DISPLAY BY NAME g_hratc[l_ac_c].hratc09_name
          END IF      
     AFTER FIELD hratc11
          IF NOT cl_null(g_hratc[l_ac_c].hratc11) THEN 
             CALL i006_c_hrag('203',g_hratc[l_ac_c].hratc11) RETURNING g_hratc[l_ac_c].hratc11_name
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_hratc[l_ac_c].hratc11,g_errno,0)  
                LET g_hratc[l_ac_c].hratc11_name = ''
                NEXT FIELD hratc11
             END IF
             DISPLAY BY NAME g_hratc[l_ac_c].hratc11_name
          END IF                	          	           	          	          	        
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_c_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hratc_file(hratc01,hratc02,hratc03,hratc04,hratc05,hratc06,hratc07,hratc08,hratc09,hratc10,hratc11,hratc12,hratc13)  
          VALUES(g_hratc[l_ac_c].hratc01,g_hratc[l_ac_c].hratc02,g_hratc[l_ac_c].hratc03,g_hratc[l_ac_c].hratc04,
                 g_hratc[l_ac_c].hratc05,g_hratc[l_ac_c].hratc06,g_hratc[l_ac_c].hratc07,g_hratc[l_ac_c].hratc08,
                 g_hratc[l_ac_c].hratc09,g_hratc[l_ac_c].hratc10,g_hratc[l_ac_c].hratc11,g_hratc[l_ac_c].hratc12,g_hratc[l_ac_c].hratc13)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hratc_file",g_hratc[l_ac_c].hratc02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_c=g_rec_b_c+1
             DISPLAY g_rec_b_c TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hratc_t.hratc02 IS NOT NULL AND g_hratc_t.hratc03 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hratc02"               
             LET g_doc.value1 = g_hratc[l_ac_c].hratc02      
             LET g_doc.column2 = "hratc03"
             LET g_doc.value2 = g_hratc[l_ac_c].hratc03 
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hratc_file WHERE hratc01 = g_hrat.hratid AND hratc02 = g_hratc_t.hratc02 AND  hratc03 = g_hratc_t.hratc03
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hratc_file",g_hratc_t.hratc02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_c=g_rec_b_c-1
             DISPLAY g_rec_b_c TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式��?
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hratc[l_ac_c].* = g_hratc_t.*
             CLOSE i006_c_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hratc[l_ac_c].hratc02,-263,0)
             LET g_hratc[l_ac_c].* = g_hratc_t.*
          ELSE
             UPDATE hratc_file SET hratc02=g_hratc[l_ac_c].hratc02,
                                 hratc03=g_hratc[l_ac_c].hratc03,
                                 hratc04=g_hratc[l_ac_c].hratc04, 
                                 hratc05=g_hratc[l_ac_c].hratc05,
                                 hratc06=g_hratc[l_ac_c].hratc06,
                                 hratc07=g_hratc[l_ac_c].hratc07,
                                 hratc08=g_hratc[l_ac_c].hratc08,
                                 hratc09=g_hratc[l_ac_c].hratc09, 
                                 hratc10=g_hratc[l_ac_c].hratc10,
                                 hratc11=g_hratc[l_ac_c].hratc11,
                                 hratc12=g_hratc[l_ac_c].hratc12,
                                 hratc13=g_hratc[l_ac_c].hratc13 
                           WHERE hratc01 = g_hrat.hratid 
                             AND hratc02 = g_hratc_t.hratc02 
                             AND  hratc03 = g_hratc_t.hratc03  
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hratc_file",g_hratc_t.hratc02,"",SQLCA.sqlcode,"","",1)  
                LET g_hratc[l_ac_c].* = g_hratc_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_c = ARR_CURR()            
          LET l_ac_c_t = l_ac_c             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hratc[l_ac_c].* = g_hratc_t.*
             END IF
             CLOSE i006_c_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_c_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
             WHEN INFIELD(hratc05)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '307'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hratc[l_ac_c].hratc05
                  CALL cl_create_qry() RETURNING g_hratc[l_ac_c].hratc05
                  DISPLAY BY NAME g_hratc[l_ac_c].hratc05
                  NEXT FIELD hratc05     
             WHEN INFIELD(hratc07)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '315'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hratc[l_ac_c].hratc07
                  CALL cl_create_qry() RETURNING g_hratc[l_ac_c].hratc07
                  DISPLAY BY NAME g_hratc[l_ac_c].hratc07
                  NEXT FIELD hratc07 
             WHEN INFIELD(hratc08)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '317'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hratc[l_ac_c].hratc08
                  CALL cl_create_qry() RETURNING g_hratc[l_ac_c].hratc08
                  DISPLAY BY NAME g_hratc[l_ac_c].hratc08
                  NEXT FIELD hratc08     
             WHEN INFIELD(hratc09)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '316'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hratc[l_ac_c].hratc09
                  CALL cl_create_qry() RETURNING g_hratc[l_ac_c].hratc09
                  DISPLAY BY NAME g_hratc[l_ac_c].hratc09
                  NEXT FIELD hratc09     
             WHEN INFIELD(hratc11)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '203'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.default1 = g_hratc[l_ac_c].hratc11
                  CALL cl_create_qry() RETURNING g_hratc[l_ac_c].hratc11
                  DISPLAY BY NAME g_hratc[l_ac_c].hratc11
                  NEXT FIELD hratc11                  
          END CASE                                             	  
       ON ACTION CONTROLO                        #沿用所有欄��?
          IF INFIELD(hratc02) AND l_ac_c > 1 THEN
             LET g_hratc[l_ac_c].* = g_hratc[l_ac_c-1].*
             NEXT FIELD hratc02
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
 
   CLOSE i006_c_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_c_b_askkey()
 
   CLEAR FORM
   CALL g_hratc.clear()
   CONSTRUCT g_wc2_c ON hratc01,hratc02,hratc03,hratc04,hratc05,hratc06,hratc07,hratc08,hratc09,hratc10,hratc11,hratc12,hratc13  
        FROM s_hratc[1].hratc01,s_hratc[1].hratc02,s_hratc[1].hratc03,s_hratc[1].hratc04,
             s_hratc[1].hratc05,s_hratc[1].hratc06,s_hratc[1].hratc07,s_hratc[1].hratc08,
             s_hratc[1].hratc09,s_hratc[1].hratc10,s_hratc[1].hratc11,s_hratc[1].hratc12,s_hratc[1].hratc13
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
             WHEN INFIELD(hratc01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrat01"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratc01
                  NEXT FIELD hratc01  
             WHEN INFIELD(hratc05)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '307'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratc05
                  NEXT FIELD hratc05     
             WHEN INFIELD(hratc07)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '315'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratc07
                  NEXT FIELD hratc07 
             WHEN INFIELD(hratc08)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '317'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratc08
                  NEXT FIELD hratc08   
             WHEN INFIELD(hratc09)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '316'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratc09
                  NEXT FIELD hratc09 
             WHEN INFIELD(hratc11)   
                  CALL cl_init_qry_var()
                  LET g_qryparam.arg1 = '203'
                  LET g_qryparam.form = "q_hrag06"
                  LET g_qryparam.state='c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO hratc11
                  NEXT FIELD hratc11                                       
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_c = NULL
      RETURN
   END IF
   CALL i006_c_b_fill(g_wc2_c)
END FUNCTION
 
FUNCTION i006_c_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
    
    LET g_sql_c =
        "SELECT hratc01,'',hratc02,hratc03,hratc04,hratc05,'',hratc06,hratc07,'',hratc08,'',hratc09,'',hratc10,hratc11,'',hratc12,hratc13",   
        " FROM hratc_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hratc01 = '",g_hrat.hratid,"'",
        " ORDER BY hratc01,hratc02,hratc03,hratc04"
    PREPARE i006_c_pb FROM g_sql_c
    DECLARE hratc_curs CURSOR FOR i006_c_pb
 
    CALL g_hratc.clear()
    LET g_cnt_c = 1
    MESSAGE "Searching!" 
    FOREACH hratc_curs INTO g_hratc[g_cnt_c].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hratc[g_cnt_c].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
        CALL i006_c_hrag('307',g_hratc[g_cnt_c].hratc05) RETURNING g_hratc[g_cnt_c].hratc05_name
        CALL i006_c_hrag('315',g_hratc[g_cnt_c].hratc07) RETURNING g_hratc[g_cnt_c].hratc07_name
        CALL i006_c_hrag('317',g_hratc[g_cnt_c].hratc08) RETURNING g_hratc[g_cnt_c].hratc08_name 
        CALL i006_c_hrag('316',g_hratc[g_cnt_c].hratc09) RETURNING g_hratc[g_cnt_c].hratc09_name
        CALL i006_c_hrag('203',g_hratc[g_cnt_c].hratc11) RETURNING g_hratc[g_cnt_c].hratc11_name 
        LET g_cnt_c = g_cnt_c + 1
        IF g_cnt_c > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hratc.deleteElement(g_cnt_c)
    MESSAGE ""
    LET g_rec_b_c = g_cnt_c-1
    DISPLAY g_rec_b_c TO FORMONLY.cn2  
    LET g_cnt_c = 0
 
END FUNCTION
 
FUNCTION i006_c_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hratc TO s_hratc.* ATTRIBUTE(COUNT=g_rec_b_c)
 
      BEFORE ROW
      LET l_ac_c = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_c = 1
         LET l_ac_c = 1
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
         LET l_ac_c = ARR_CURR()
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
 
FUNCTION i006_c_hrag(p_hrag01,p_hrag06) 
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

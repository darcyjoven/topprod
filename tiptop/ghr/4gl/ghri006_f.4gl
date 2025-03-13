# Prog. Version..: '5.20.01-10.05.01(00000)'     #
#
# Pattern name...: ghri006_f.4gl
# Descriptions...: 核算项帐套科目对照档 
# Date & Author..: 13/01/16 yougs 
  # 30150318:开启删除功能 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
     g_hratf         DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        hratf01       LIKE hratf_file.hratf01,
        hrat02        LIKE hrat_file.hrat02,
        hratf02       LIKE hratf_file.hratf02,   
        hratf03       LIKE hratf_file.hratf03,   
        hratf04       LIKE hratf_file.hratf04,
        hratf05       LIKE hratf_file.hratf05, 
        hratf06       LIKE hratf_file.hratf06,
        hratf07       LIKE hratf_file.hratf07   
           
                    END RECORD,
    g_hratf_t        RECORD                 #程式變數 (舊值)
        hratf01       LIKE hratf_file.hratf01,
        hrat02        LIKE hrat_file.hrat02,
        hratf02       LIKE hratf_file.hratf02,   
        hratf03       LIKE hratf_file.hratf03,   
        hratf04       LIKE hratf_file.hratf04,
        hratf05       LIKE hratf_file.hratf05, 
        hratf06       LIKE hratf_file.hratf06,
        hratf07       LIKE hratf_file.hratf07   
                    END RECORD,
    g_wc2_f,g_sql_f    LIKE type_file.chr1000,       
    g_rec_b_f         LIKE type_file.num5,                #單身筆數        
    l_ac_f            LIKE type_file.num5                 #目前處理的ARRAY CNT        
 
DEFINE g_forupd_sql_f STRING   #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt_f           LIKE type_file.num10     
DEFINE g_hrat     RECORD LIKE hrat_file.*
                    
FUNCTION ghri006_f(p_hratid)
DEFINE p_row,p_col   LIKE type_file.num5           
DEFINE p_hratid      LIKE hrat_file.hratid
   IF cl_null(p_hratid) THEN
   	  RETURN
   END IF	 
   SELECT * INTO g_hrat.* FROM hrat_file WHERE hratid = p_hratid	  
   LET p_row = 4 LET p_col = 15
   OPEN WINDOW i006_f_w AT p_row,p_col WITH FORM "ghr/42f/ghri006_f"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
   WHENEVER ERROR CALL cl_err_msg_log 
   CALL cl_set_comp_visible("hratf01,hrat02",FALSE)
   LET g_wc2_f = '1=1'
   CALL i006_f_b_fill(g_wc2_f)
   CALL i006_f_menu()
   CLOSE WINDOW i006_f_w                   
END FUNCTION
 
FUNCTION i006_f_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i006_f_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i006_f_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i006_f_b()
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hratf),'','')
            END IF 
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i006_f_q()
   CALL i006_f_b_askkey()
END FUNCTION
  
FUNCTION i006_f_b()
DEFINE
   l_ac_f_t          LIKE type_file.num5,                #未取消的ARRAY CNT        
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
 
   LET g_forupd_sql_f = "SELECT hratf01,'',hratf02,hratf03,hratf04,hratf05,hratf06,hratf07",   
                      "  FROM hratf_file WHERE hratf01 = ? AND hratf02= ? FOR UPDATE"
   LET g_forupd_sql_f = cl_forupd_sql(g_forupd_sql_f)
   DECLARE i006_f_bcl CURSOR FROM g_forupd_sql_f      # LOCK CURSOR
 
   INPUT ARRAY g_hratf WITHOUT DEFAULTS FROM s_hratf.*
     ATTRIBUTE (COUNT=g_rec_b_f,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)  # 30150318:开启删除功能 
 
       BEFORE INPUT
          IF g_rec_b_f != 0 THEN
             CALL fgl_set_arr_curr(l_ac_f)
          END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac_f = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()

          IF g_rec_b_f>=l_ac_f THEN 
             BEGIN WORK
             LET p_cmd='u'                                                                 
             LET g_hratf_t.* = g_hratf[l_ac_f].*  #BACKUP
             OPEN i006_f_bcl USING g_hrat.hratid,g_hratf_t.hratf02
             IF STATUS THEN
                CALL cl_err("OPEN i006_f_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i006_f_bcl INTO g_hratf[l_ac_f].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hratf_t.hratf02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             CALL cl_show_fld_cont()    
          END IF 	
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                                              
          INITIALIZE g_hratf[l_ac_f].* TO NULL     
          LET g_hratf_t.* = g_hratf[l_ac_f].*         #新輸入資料 
          LET g_hratf[l_ac_f].hratf01 = g_hrat.hratid
          SELECT hrat02 INTO g_hratf[l_ac_f].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
          LET g_hratf[l_ac_f].hratf03 = '1' 
          CALL cl_show_fld_cont()   
          NEXT FIELD hratf02
          
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i006_f_bcl
             CANCEL INSERT
          END IF
          INSERT INTO hratf_file(hratf01,hratf02,hratf03,hratf04,hratf05,hratf06,hratf07)  
          VALUES(g_hratf[l_ac_f].hratf01,g_hratf[l_ac_f].hratf02,g_hratf[l_ac_f].hratf03,g_hratf[l_ac_f].hratf04,
                 g_hratf[l_ac_f].hratf05,g_hratf[l_ac_f].hratf06,g_hratf[l_ac_f].hratf07)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hratf_file",g_hratf[l_ac_f].hratf02,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b_f=g_rec_b_f+1
             DISPLAY g_rec_b_f TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hratf_t.hratf02 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hratf02"               
             LET g_doc.value1 = g_hratf[l_ac_f].hratf02      
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hratf_file WHERE hratf01 = g_hrat.hratid AND hratf02 = g_hratf_t.hratf02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hratf_file",g_hratf_t.hratf02,"",SQLCA.sqlcode,"","",1)
                EXIT INPUT
             END IF
             LET g_rec_b_f=g_rec_b_f-1
             DISPLAY g_rec_b_f TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN                 #新增程式段
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_hratf[l_ac_f].* = g_hratf_t.*
             CLOSE i006_f_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hratf[l_ac_f].hratf02,-263,0)
             LET g_hratf[l_ac_f].* = g_hratf_t.*
          ELSE
             UPDATE hratf_file SET hratf02=g_hratf[l_ac_f].hratf02,
                                 hratf03=g_hratf[l_ac_f].hratf03,
                                 hratf04=g_hratf[l_ac_f].hratf04, 
                                 hratf05=g_hratf[l_ac_f].hratf05,
                                 hratf06=g_hratf[l_ac_f].hratf06,
                                 hratf07=g_hratf[l_ac_f].hratf07
                           WHERE hratf01 = g_hrat.hratid 
                             AND hratf02 = g_hratf_t.hratf02 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hratf_file",g_hratf_t.hratf02,"",SQLCA.sqlcode,"","",1)  
                LET g_hratf[l_ac_f].* = g_hratf_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac_f = ARR_CURR()            
          LET l_ac_f_t = l_ac_f             
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_hratf[l_ac_f].* = g_hratf_t.*
             END IF
             CLOSE i006_f_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i006_f_bcl           
          COMMIT WORK
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hratf02) AND l_ac_f > 1 THEN
             LET g_hratf[l_ac_f].* = g_hratf[l_ac_f-1].*
             NEXT FIELD hratf02
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
 
   CLOSE i006_f_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i006_f_b_askkey()
 
   CLEAR FORM
   CALL g_hratf.clear()
   CONSTRUCT g_wc2_f ON hratf01,hratf02,hratf03,hratf04,hratf05,hratf06,hratf07
        FROM s_hratf[1].hratf01,s_hratf[1].hratf02,s_hratf[1].hratf03,s_hratf[1].hratf04,
             s_hratf[1].hratf05,s_hratf[1].hratf06,s_hratf[1].hratf07
 
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
            WHEN INFIELD(hratf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_hrat01"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hratf01
                 NEXT FIELD hratf01  
         END CASE            
   END CONSTRUCT 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2_f = NULL
      RETURN
   END IF
   CALL i006_f_b_fill(g_wc2_f)
END FUNCTION
 
FUNCTION i006_f_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql_f =
        "SELECT hratf01,'',hratf02,hratf03,hratf04,hratf05,hratf06,hratf07",   
        " FROM hratf_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND hratf01 = '",g_hrat.hratid,"'",
        " ORDER BY hratf01,hratf02,hratf03,hratf04"
    PREPARE i006_f_pb FROM g_sql_f
    DECLARE hratf_curs CURSOR FOR i006_f_pb
 
    CALL g_hratf.clear()
    LET g_cnt_f = 1
    MESSAGE "Searching!" 
    FOREACH hratf_curs INTO g_hratf[g_cnt_f].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT hrat02 INTO g_hratf[g_cnt_f].hrat02 FROM hrat_file WHERE hratid = g_hrat.hratid
        LET g_cnt_f = g_cnt_f + 1
        IF g_cnt_f > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hratf.deleteElement(g_cnt_f)
    MESSAGE ""
    LET g_rec_b_f = g_cnt_f-1
    DISPLAY g_rec_b_f TO FORMONLY.cn2  
    LET g_cnt_f = 0
 
END FUNCTION
 
FUNCTION i006_f_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hratf TO s_hratf.* ATTRIBUTE(COUNT=g_rec_b_f)
 
      BEFORE ROW
      LET l_ac_f = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_f = 1
         LET l_ac_f = 1
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
         LET l_ac_f = ARR_CURR()
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
 

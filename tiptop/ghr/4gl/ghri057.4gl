# on..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri057.4gl
# Descriptions...: 待审核计件信息
# Date & Author..: 13/05/24 By lifang
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrcq    DYNAMIC ARRAY OF RECORD
                 check      LIKE type_file.chr1,
                 hrcq01     LIKE hrcq_file.hrcq01,   
                 hrat01     LIKE hrat_file.hrat01,   
                 hrat02     LIKE hrat_file.hrat02,   
                 hrat04     LIKE hrat_file.hrat04,   
                 hrao02     LIKE hrao_file.hrao02,   
                 hrat05     LIKE hrat_file.hrat05,   
                 hras04     LIKE hras_file.hras04,   
                 hrcq03     LIKE hrcq_file.hrcq03,   
                 hrcq04     LIKE hrcq_file.hrcq04,   
                 hrcq08     LIKE hrcq_file.hrcq08,   
                 hrcq05     LIKE hrcq_file.hrcq05,   
                 hrbm04     LIKE hrbm_file.hrbm04,   
                 hrcq06     LIKE hrcq_file.hrcq06,   
                 hrcq07     LIKE hrcq_file.hrcq07,   
                 hrcqconf   LIKE hrcq_file.hrcqconf              
               END RECORD,
       g_hrcq_t RECORD
                 check      LIKE type_file.chr1,
                 hrcq01     LIKE hrcq_file.hrcq01,   
                 hrat01     LIKE hrat_file.hrat01,   
                 hrat02     LIKE hrat_file.hrat02,   
                 hrat04     LIKE hrat_file.hrat04,   
                 hrao02     LIKE hrao_file.hrao02,   
                 hrat05     LIKE hrat_file.hrat05,   
                 hras04     LIKE hras_file.hras04,   
                 hrcq03     LIKE hrcq_file.hrcq03,   
                 hrcq04     LIKE hrcq_file.hrcq04,   
                 hrcq08     LIKE hrcq_file.hrcq08,   
                 hrcq05     LIKE hrcq_file.hrcq05,   
                 hrbm04     LIKE hrbm_file.hrbm04,   
                 hrcq06     LIKE hrcq_file.hrcq06,   
                 hrcq07     LIKE hrcq_file.hrcq07,   
                 hrcqconf   LIKE hrcq_file.hrcqconf   
               END RECORD 
DEFINE g_success       LIKE type_file.chr1
DEFINE g_wc            STRING
DEFINE g_sql           STRING
DEFINE g_cmd           LIKE type_file.chr1000
DEFINE g_rec_b         LIKE type_file.num5              
DEFINE l_ac            LIKE type_file.num5
DEFINE g_forupd_sql    STRING   
DEFINE g_cnt           LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i             LIKE type_file.num5     
DEFINE g_on_change     LIKE type_file.num5      
DEFINE g_row_count     LIKE type_file.num5       
DEFINE g_curs_index    LIKE type_file.num5       
DEFINE g_str           STRING 
DEFINE p_row,p_col     LIKE type_file.num5  
MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
  
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
   OPEN WINDOW i057_w AT p_row,p_col WITH FORM "ghr/42f/ghri057"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init() 
   CALL cl_set_comp_visible("hrcq01,check",FALSE) 
   CALL i057_menu()
   CLOSE WINDOW i057_w 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION i057_menu()
 
   WHILE TRUE
      CALL i057_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i057_q()
            END IF

         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i057_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()

         WHEN "exit"
            EXIT WHILE

         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "confirm"
             IF cl_chk_act_auth() THEN
                CALL i057_confirm('Y')
             END IF

         WHEN "unconfirm"
             IF cl_chk_act_auth() THEN
                CALL i057_confirm('N')
             END IF 
              
         WHEN "auto_generate"
             IF cl_chk_act_auth() THEN
                CALL i057_auto_generate()
                CALL i057_b_fill()       #add by wangyuz  171013    重新展示画面
             END IF    
      END CASE
   END WHILE
END FUNCTION 
 
FUNCTION i057_q()
   CALL i057_b_askkey()
END FUNCTION 
 
FUNCTION i057_b()
DEFINE l_max       LIKE hrcq_file.hrcq01
DEFINE l_hratid    LIKE hrat_file.hratid
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
 
   LET g_forupd_sql="SELECT 'N',hrcq01,hrat01,hrat02,hrat04,'',hrat05,'',hrcq03,hrcq04,hrcq08,hrcq05,'',hrcq06,hrcq07,hrcqconf",
                     "  FROM hrcq_file LEFT OUTER JOIN hrat_file ON hratid=hrcq02 WHERE hrcq01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i057_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_hrcq WITHOUT DEFAULTS FROM s_hrcq.*
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
             LET g_hrcq_t.* = g_hrcq[l_ac].*  #BACKUP
             OPEN i057_bcl USING g_hrcq_t.hrcq01
             IF STATUS THEN
                CALL cl_err("OPEN i057_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i057_bcl INTO g_hrcq[l_ac].*  
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrcq_t.hrat01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF 
             SELECT hrao02 INTO g_hrcq[l_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrcq[l_ac].hrat04        
             SELECT hrap06 INTO g_hrcq[l_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrcq[l_ac].hrat05 AND hrap01 = g_hrcq[l_ac].hrat04
             SELECT hrbm04 INTO g_hrcq[l_ac].hrbm04 FROM hrbm_file WHERE hrbm03 = g_hrcq[l_ac].hrcq05 
             CALL cl_show_fld_cont()    
          END IF  
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'       
          CALL cl_show_fld_cont()     
          INITIALIZE g_hrcq[l_ac].* TO NULL     
          LET g_hrcq_t.* = g_hrcq[l_ac].*         #新輸入資料   
          LET g_hrcq[l_ac].hrcqconf = 'N'
          LET g_hrcq[l_ac].hrcq08 = 'Y'
          DISPLAY BY NAME g_hrcq[l_ac].hrcqconf,g_hrcq[l_ac].hrcq08

       AFTER FIELD hrat01
          IF NOT cl_null(g_hrcq[l_ac].hrat01) AND ((p_cmd = 'a') OR (p_cmd = 'u' AND g_hrcq[l_ac].hrat01 <> g_hrcq_t.hrat01)) THEN 
             SELECT hrat02,hrat04,hrat05
               INTO g_hrcq[l_ac].hrat02,g_hrcq[l_ac].hrat04,g_hrcq[l_ac].hrat05
               FROM hrat_file
              WHERE hrat01 = g_hrcq[l_ac].hrat01
                AND hratconf = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_hrcq[l_ac].hrat01,SQLCA.sqlcode,0)
                NEXT FIELD hrat01
             END IF 
             SELECT hrao02 INTO g_hrcq[l_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrcq[l_ac].hrat04        
             SELECT hrap06 INTO g_hrcq[l_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrcq[l_ac].hrat05 AND hrap01 = g_hrcq[l_ac].hrat04
             IF NOT cl_null(g_hrcq[l_ac].hrcq03) AND NOT cl_null(g_hrcq[l_ac].hrcq05) THEN
                LET l_hratid = ''
                SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcq[l_ac].hrat01
                LET l_count = 0
                SELECT COUNT(*) INTO l_count FROM hrcq_file
                 WHERE hrcq02 = l_hratid
                   AND hrcq03 = g_hrcq[l_ac].hrcq03
                   AND hrcq05 = g_hrcq[l_ac].hrcq05
                IF l_count > 0 THEN
                  CALL cl_err("该员工在该日期已经有该类津贴资料",'!',0)
                  NEXT FIELD hrat01
                END IF
             END IF          
             DISPLAY BY NAME g_hrcq[l_ac].hrat02,g_hrcq[l_ac].hrat04,g_hrcq[l_ac].hrat05,g_hrcq[l_ac].hrao02,g_hrcq[l_ac].hras04
          END IF     
                      
       AFTER FIELD hrcq03
          IF NOT cl_null(g_hrcq[l_ac].hrcq03) AND ((p_cmd = 'a') OR (p_cmd = 'u' AND g_hrcq[l_ac].hrcq03 <> g_hrcq_t.hrcq03)) THEN
             LET l_hratid = ''
             SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcq[l_ac].hrat01
             SELECT hrcp04 INTO g_hrcq[l_ac].hrcq04 FROM hrcp_file
              WHERE hrcp02=l_hratid AND hrcp03=g_hrcq[l_ac].hrcq03 AND hrcp35='Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err("不存在员工当天考勤资料",'!',0)
                NEXT FIELD hrcq03
             END IF
             DISPLAY BY NAME g_hrcq[l_ac].hrcq04
             IF NOT cl_null(g_hrcq[l_ac].hrat01) AND NOT cl_null(g_hrcq[l_ac].hrcq05) THEN 
                LET l_count = 0
                SELECT COUNT(*) INTO l_count FROM hrcq_file
                 WHERE hrcq02 = l_hratid
                   AND hrcq03 = g_hrcq[l_ac].hrcq03
                   AND hrcq05 = g_hrcq[l_ac].hrcq05
                IF l_count > 0 THEN
                   CALL cl_err("该员工在该日期已经有该类津贴资料",'!',0)
                   NEXT FIELD hrcq03
                END IF
             END IF 
          END IF 
          
       AFTER FIELD hrcq05
          IF NOT cl_null(g_hrcq[l_ac].hrcq05)  AND ((p_cmd = 'a') OR (p_cmd = 'u' AND g_hrcq[l_ac].hrcq05 <> g_hrcq_t.hrcq05)) THEN 
             LET g_hrcq[l_ac].hrbm04 = ''
             SELECT hrbm04 INTO g_hrcq[l_ac].hrbm04
               FROM hrbm_file
              WHERE hrbm03 = g_hrcq[l_ac].hrcq05
                AND hrbm02 = '007'
                AND hrbm07 = 'Y'
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_hrcq[l_ac].hrcq05,SQLCA.sqlcode,0)
                NEXT FIELD hrcq05
             END IF 
             DISPLAY BY NAME g_hrcq[l_ac].hrbm04     
             IF NOT cl_null(g_hrcq[l_ac].hrat01) AND NOT cl_null(g_hrcq[l_ac].hrcq03) THEN 
                LET l_hratid = ''
                SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcq[l_ac].hrat01
                LET l_count = 0
                SELECT COUNT(*) INTO l_count FROM hrcq_file
                 WHERE hrcq02 = l_hratid
                   AND hrcq03 = g_hrcq[l_ac].hrcq03
                   AND hrcq05 = g_hrcq[l_ac].hrcq05
                IF l_count > 0 THEN
                   CALL cl_err("该员工在该日期已经有该类津贴资料",'!',0)
                   NEXT FIELD hrcq05
                END IF
             END IF
          END IF 
                                                            
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i057_bcl
             CANCEL INSERT
          END IF
          LET l_hratid = ''
          SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcq[l_ac].hrat01 AND rownum = 1
          LET l_max = ''
          SELECT MAX(hrcq01)+1 INTO l_max FROM hrcq_file
          IF cl_null(l_max) THEN
            LET l_max = '1'
          END IF
          LET g_hrcq[l_ac].hrcq01 = l_max    
          INSERT INTO hrcq_file(hrcq01,hrcq02,hrcq03,hrcq04,hrcq05,hrcq06,hrcq07,hrcq08,hrcqconf,hrcqacti,hrcqoriu,hrcqorig,hrcquser,hrcqgrup,hrcqdate)  
          VALUES(g_hrcq[l_ac].hrcq01,l_hratid,g_hrcq[l_ac].hrcq03,g_hrcq[l_ac].hrcq04,g_hrcq[l_ac].hrcq05,
                 g_hrcq[l_ac].hrcq06,g_hrcq[l_ac].hrcq07,g_hrcq[l_ac].hrcq08,g_hrcq[l_ac].hrcqconf,'Y',g_user,g_grup,g_user,g_grup,g_today)   
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","hrcq_file",g_hrcq[l_ac].hrcq01,"",SQLCA.sqlcode,"","",1) 
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
          

       BEFORE DELETE                            #是否取消單身
          IF g_hrcq_t.hrcq01 IS NOT NULL THEN
             IF g_hrcq_t.hrcqconf='Y' THEN 
                CALL cl_err("已审核资料不允许删除",'!',0)
                CANCEL DELETE
             END IF 
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                
             LET g_doc.column1 = "hrcq01"               
             LET g_doc.value1 = g_hrcq[l_ac].hrcq01   
             CALL cl_del_doc()                                           
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM hrcq_file WHERE hrcq01 = g_hrcq_t.hrcq01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","hrcq_file",g_hrcq_t.hrcq01,"",SQLCA.sqlcode,"","",1)
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
             LET g_hrcq[l_ac].* = g_hrcq_t.*
             CLOSE i057_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF g_hrcq[l_ac].hrcqconf = 'Y' THEN
             CALL cl_err("已审核资料不允许更改",'!',0)
             LET g_hrcq[l_ac].* = g_hrcq_t.*
          END IF 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_hrcq[l_ac].hrat01,-263,0)
             LET g_hrcq[l_ac].* = g_hrcq_t.*
          ELSE
             LET l_hratid = ''
             SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01 = g_hrcq[l_ac].hrat01 AND rownum = 1
             UPDATE hrcq_file SET hrcq02=l_hratid,
                                  hrcq03=g_hrcq[l_ac].hrcq03,
                                  hrcq04=g_hrcq[l_ac].hrcq04, 
                                  hrcq05=g_hrcq[l_ac].hrcq05,
                                  hrcq06=g_hrcq[l_ac].hrcq06,
                                  hrcq07=g_hrcq[l_ac].hrcq07, 
                                  hrcq08='Y',
                                  hrcqmodu=g_user,
                                  hrcqdate=g_today
                            WHERE hrcq01 = g_hrcq_t.hrcq01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrcq_file",g_hrcq_t.hrcq01,"",SQLCA.sqlcode,"","",1)  
                LET g_hrcq[l_ac].* = g_hrcq_t.*
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
                LET g_hrcq[l_ac].* = g_hrcq_t.*
             END IF
             CLOSE i057_bcl            
             ROLLBACK WORK         
             EXIT INPUT
          END IF
 
          CLOSE i057_bcl           
          COMMIT WORK

       ON ACTION controlp
          CASE
              WHEN INFIELD(hrat01)   
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form = "q_hrat01"
                 LET g_qryparam.default1 = g_hrcq[l_ac].hrat01
                 CALL cl_create_qry() RETURNING g_hrcq[l_ac].hrat01
                 DISPLAY BY NAME g_hrcq[l_ac].hrat01
                 NEXT FIELD hrat01 
              WHEN INFIELD(hrcq05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03" 
                 LET g_qryparam.arg1 = '007'
                 LET g_qryparam.default1 = g_hrcq[l_ac].hrcq05
                 CALL cl_create_qry() RETURNING g_hrcq[l_ac].hrcq05
                 DISPLAY BY NAME g_hrcq[l_ac].hrcq05
                 NEXT FIELD hrcq05                  
          END CASE                                                
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(hrat01) AND l_ac > 1 THEN
             LET g_hrcq[l_ac].* = g_hrcq[l_ac-1].*
             NEXT FIELD hrat01
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
 
   CLOSE i057_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i057_b_askkey()
    CLEAR FORM
    CALL g_hrcq.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc ON hrcq01,hrat01,hrat02,hrat04,hrat05,hrcq03,hrcq04,hrcq08,hrcq05,hrcq06,hrcq07,hrcqconf 
         FROM s_hrcq[1].hrcq01,s_hrcq[1].hrat01,s_hrcq[1].hrat02,s_hrcq[1].hrat04,s_hrcq[1].hrat05,s_hrcq[1].hrcq03,s_hrcq[1].hrcq04,s_hrcq[1].hrcq08,s_hrcq[1].hrcq05,s_hrcq[1].hrcq06,s_hrcq[1].hrcq07,s_hrcq[1].hrcqconf 
         
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 

              WHEN INFIELD(hrat01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form  = "q_hrat01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat01
                 NEXT FIELD hrat01
              WHEN INFIELD(hrat04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrao01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat04
                 NEXT FIELD hrat04
              WHEN INFIELD(hrat05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrap01"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrat05
                 NEXT FIELD hrat05            
              WHEN INFIELD(hrcq05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrbm03"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.where = "hrbm02 = '007'"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO hrcq05
                 NEXT FIELD hrcq05
         OTHERWISE
              EXIT CASE
         END CASE
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('hrcquser', 'hrcqgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF 
 
    CALL i057_b_fill()
 
END FUNCTION 
 
FUNCTION i057_b_fill()      
#add by wangyuz 171013 str 
    IF g_wc IS NULL THEN 
     LET g_wc ="1=1"
    END IF 
#add by wangyuz 171013 end 
    LET g_sql = "SELECT 'N',hrcq01,hrat01,hrat02,hrat04,'',hrat05,'',hrcq03,hrcq04,hrcq08,hrcq05,'',hrcq06,hrcq07,hrcqconf ",
                " FROM hrcq_file,hrat_file ",
                " WHERE hrcq02 = hratid AND ", g_wc CLIPPED, 
                " ORDER BY hrat01,hrcq03" 
 
    PREPARE i057_pb FROM g_sql
    DECLARE hrcq_curs CURSOR FOR i057_pb
 
    CALL g_hrcq.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcq_curs INTO g_hrcq[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF 
        SELECT hrao02 INTO g_hrcq[g_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrcq[g_cnt].hrat04        
        SELECT hrap06 INTO g_hrcq[g_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrcq[g_cnt].hrat05 AND hrap01 = g_hrcq[g_cnt].hrat04 
        SELECT hrbm04 INTO g_hrcq[g_cnt].hrbm04 FROM hrbm_file WHERE hrbm03 = g_hrcq[g_cnt].hrcq05 AND hrbm02 = '007'      
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
 
END FUNCTION 
 
FUNCTION i057_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcq TO s_hrcq.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
          
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         EXIT DISPLAY      
         
      ON ACTION auto_generate 
         LET g_action_choice="auto_generate"
         EXIT DISPLAY 
          
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION  
 
FUNCTION i057_confirm(p_cmd) 
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE l_i             LIKE type_file.num5

  CALL cl_set_comp_visible('check',TRUE)
  CALL cl_set_comp_entry('hrat01,hrcq03,hrcq05,hrcq06,hrcq07',FALSE)
  INPUT ARRAY g_hrcq WITHOUT DEFAULTS FROM s_hrcq.*
     ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

      ON ACTION sel_all
         LET g_action_choice="sel_all"
         FOR l_i = 1 TO g_rec_b
             LET g_hrcq[l_i].check = 'Y'
             DISPLAY BY NAME g_hrcq[l_i].check
         END FOR
         
      ON ACTION sel_none
         LET g_action_choice="sel_none"
         FOR l_i = 1 TO g_rec_b
             LET g_hrcq[l_i].check = 'N'
             DISPLAY BY NAME g_hrcq[l_i].check
         END FOR
         
      ON ACTION accept
         FOR l_i = 1 TO g_rec_b
             IF g_hrcq[l_i].check = 'Y' THEN
                UPDATE hrcq_file SET hrcqconf = p_cmd WHERE hrcq01 = g_hrcq[l_i].hrcq01
             END IF
         END FOR
         EXIT INPUT

     ON ACTION CANCEL
        LET INT_FLAG=0
        EXIT INPUT 
        
  END INPUT
  CALL cl_set_comp_visible('check',FALSE)
  CALL cl_set_comp_entry('hrat01,hrcq03,hrcq05,hrcq06,hrcq07',TRUE)
  CALL i057_b_fill()
END FUNCTION 
 

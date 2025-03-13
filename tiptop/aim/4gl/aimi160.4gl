# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aimi160.4gl
# Descriptions...: 特性代碼維護作業
# Date & Author..: TQC-B90236 11/10/11 By Zhuhao
# Modify.........: No.MOD-C30273 2012/03/10 By zhuhao 拿掉ini02控卡，在4fd上加上not null，requierd屬性
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ini          DYNAMIC ARRAY OF RECORD 
        ini01       LIKE ini_file.ini01,   
        ini02       LIKE ini_file.ini02,   
        ini03       LIKE ini_file.ini03
                    END RECORD,
    g_ini_t         RECORD      
        ini01       LIKE ini_file.ini01,
        ini02       LIKE ini_file.ini02,
        ini03       LIKE ini_file.ini03
                    END RECORD,
    
    g_wc2,g_sql     STRING,                          
    g_rec_b         LIKE type_file.num5,        
    l_ac            LIKE type_file.num5,       
    g_account       LIKE type_file.num5            
DEFINE g_forupd_sql         STRING                  
DEFINE g_cnt                LIKE type_file.num10  
DEFINE g_before_input_done  LIKE type_file.num5  
DEFINE g_row_count          LIKE type_file.num5     
DEFINE g_curs_index         LIKE type_file.num5     
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5    
   DEFINE l_ini         LIKE type_file.num5
   OPTIONS                            
      INPUT NO WRAP
   DEFER INTERRUPT 
                    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF                 
                     
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN       
      EXIT PROGRAM
   END IF           
                      
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i160_w AT p_row,p_col WITH FORM "aim/42f/aimi160"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
    SELECT COUNT(*) INTO l_ini FROM ini_file WHERE ini01 = "purity"
    IF l_ini = 0 THEN
       INSERT INTO ini_file(ini01,ini02,ini03,iniuser,inigrup,iniorig,inioriu)
            VALUES("purity","Purity","2",g_user,g_grup,g_grup,g_user)
    END IF
    LET g_wc2 =" 1=1"
    CALL i160_b_fill(g_wc2)
    CALL i160_menu()
    CLOSE WINDOW i160_w                 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN
 
FUNCTION i160_menu()
 
   WHILE TRUE
      CALL i160_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i160_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_account=FALSE 
               CALL i160_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ini),'','')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i160_q()
   CLEAR FORM
   CALL g_ini.clear()

   CONSTRUCT g_wc2 ON ini01,ini02,ini03
         FROM s_ini[1].ini01,s_ini[1].ini02,s_ini[1].ini03

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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('iniuser', 'inigrup') #FUN-980030

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   CALL i160_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i160_b()
  DEFINE
    l_ac_t          LIKE type_file.num5,           
    l_n             LIKE type_file.num5,             
    l_lock_sw       LIKE type_file.chr1,            
    p_cmd           LIKE type_file.chr1,           
    l_allow_insert  LIKE type_file.chr1,               
    l_allow_delete  LIKE type_file.chr1,
    l_count         LIKE type_file.num5
    IF s_shut(0) THEN 
       RETURN
    END IF

    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ini01,ini02,ini03",
                       "  FROM ini_file WHERE ini01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)         
                                                             
    DECLARE i160_bcl CURSOR FROM g_forupd_sql                                                                        
    INPUT ARRAY g_ini WITHOUT DEFAULTS FROM s_ini.*         
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'           
        LET l_n  = ARR_COUNT()
        BEGIN WORK
        IF g_rec_b>=l_ac THEN
           LET p_cmd='u'                   
           LET g_before_input_done = FALSE                                      
           CALL i160_set_entry(p_cmd)                                           
           CALL i160_set_no_entry(p_cmd)                                        
           LET g_before_input_done = TRUE
   
           LET g_ini_t.* = g_ini[l_ac].*                                    
           OPEN i160_bcl USING g_ini_t.ini01
           IF STATUS THEN
              CALL cl_err("OPEN i160_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i160_bcl INTO g_ini[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_ini_t.ini01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                        
         CALL i160_set_entry(p_cmd)                                             
         CALL i160_set_no_entry(p_cmd)                                          
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_ini[l_ac].* TO NULL    
         LET g_ini[l_ac].ini03 = "1" 
         LET g_ini_t.* = g_ini[l_ac].*         
         CALL cl_show_fld_cont()    
         NEXT FIELD ini01
     AFTER FIELD ini01                       
        IF NOT cl_null(g_ini[l_ac].ini01) THEN
           IF g_ini[l_ac].ini01 != g_ini_t.ini01 OR
              g_ini_t.ini01 IS NULL THEN
              SELECT count(*) INTO l_n FROM ini_file
               WHERE ini01 = g_ini[l_ac].ini01
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_ini[l_ac].ini01 = g_ini_t.ini01
                  NEXT FIELD ini01
              END IF
           END IF
        END IF
    #ON CHANGE ini01
    #   SELECT COUNT(*) INTO l_count FROM imac_file
    #    WHERE imac04=g_ini_t.ini01
    #   IF (l_count>0) AND (g_ini_t.ini01<>g_ini[l_ac].ini01) THEN
    #      CALL cl_err('','ini0002',0)
    #      LET g_ini[l_ac].ini01=g_ini_t.ini01
    #   END IF
   #MOD-C30273--mark--begin       
   #AFTER FIELD ini02
   #    IF g_ini[l_ac].ini02 IS NULL THEN
   #       CALL cl_err('',1205,0)
   #       NEXT FIELD ini02
   #    END IF
   #MOD-C30273--mark--end
    AFTER FIELD ini03
        IF g_ini[l_ac].ini03 IS NULL THEN
           CALL cl_err('',1205,0)
           NEXT FIELD ini03
        END IF 
 
    ON ROW CHANGE
        IF INT_FLAG THEN                
           LET INT_FLAG = 0
           LET g_ini[l_ac].* = g_ini_t.*
           CLOSE i160_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        SELECT COUNT(*) INTO l_count FROM imac_file
         WHERE imac04=g_ini_t.ini01
        IF l_count>0 THEN
           CALL cl_err('','ini0002',0)
           LET g_ini[l_ac].ini01=g_ini_t.ini01
           LET g_ini[l_ac].ini02=g_ini_t.ini02
           LET g_ini[l_ac].ini03=g_ini_t.ini03
        END IF
        IF l_lock_sw="Y" THEN
           CALL cl_err(g_ini[l_ac].ini01,-263,0)
           LET g_ini[l_ac].* = g_ini_t.*
        ELSE
           UPDATE ini_file 
               SET ini01=g_ini[l_ac].ini01,ini02=g_ini[l_ac].ini02,ini03=g_ini[l_ac].ini03,inimodu=g_user,inidate=g_today
             WHERE ini01 = g_ini_t.ini01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","ini_file",g_ini[l_ac].ini01,"",SQLCA.sqlcode,"","",1) 
              LET g_ini[l_ac].* = g_ini_t.*
           END IF
        END IF

     AFTER INSERT
        IF INT_FLAG THEN
           CALL g_ini.deleteElement(l_ac)
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i160_bcl
           CANCEL INSERT
        END IF

        BEGIN WORK

        INSERT INTO ini_file(ini01,ini02,ini03,iniuser,inigrup,iniorig,inioriu)
        VALUES(g_ini[l_ac].ini01,g_ini[l_ac].ini02,g_ini[l_ac].ini03,g_user,g_grup,g_grup,g_user)
        IF INT_FLAG THEN
           CALL g_ini.deleteElement(l_ac)
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i160_bcl
           CANCEL INSERT
        END IF

        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","ini_file",g_ini[l_ac].ini01,"",SQLCA.sqlcode,"","",1)
           ROLLBACK WORK
           CANCEL INSERT
        ELSE    
           LET g_rec_b=g_rec_b+1     
           COMMIT WORK   
        END IF
        DISPLAY g_rec_b TO FORMONLY.cnt

    BEFORE DELETE
       IF g_ini_t.ini01 IS NOT NULL THEN
          IF g_ini[l_ac].ini01="purity" THEN
             CALL cl_err('','ini0001',0)
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          IF NOT cl_delete() THEN
              ROLLBACK WORK     
              CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL
          LET g_doc.column1 = "ini01"
          LET g_doc.value1 = g_ini[l_ac].ini01
          CALL cl_del_doc()
          IF l_lock_sw = "Y" THEN
             CALL cl_err("", -263, 1)
             CANCEL DELETE
          END IF
          DELETE FROM ini_file WHERE ini01 = g_ini_t.ini01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","ini_file",g_ini_t.ini01,"",SQLCA.sqlcode,"","",1)
             EXIT INPUT
          END IF
          LET g_rec_b=g_rec_b-1
          DISPLAY g_rec_b TO FORMONLY.cnt
       ELSE
          ROLLBACK WORK
          EXIT INPUT
       END IF
     AFTER ROW
        LET l_ac = ARR_CURR()         
       #LET l_ac_t = l_ac-1        #FUN-D40030 Mark     
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd='u' THEN
              LET g_ini[l_ac].* = g_ini_t.*
           #FUN-D40030--add--str--
           ELSE
              CALL g_ini.deleteElement(l_ac)
              IF g_rec_b != 0 THEN
                 LET g_action_choice = "detail"
                 LET l_ac = l_ac_t
              END IF
           #FUN-D40030--add--end--
           END IF
           CLOSE i160_bcl          
           ROLLBACK WORK         
           EXIT INPUT
        END IF
        LET l_ac_t = l_ac-1        #FUN-D40030 Add
        CLOSE i160_bcl                   
        COMMIT WORK
 
     ON ACTION CONTROLR
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
    CLOSE i160_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i160_b_fill(p_wc2)         
DEFINE
    p_wc2           LIKE type_file.chr1000 
 
    LET g_sql =
        "SELECT ini01,ini02,ini03",
        " FROM ini_file",
        " WHERE ", p_wc2 CLIPPED,                  
        " ORDER BY ini01"
    PREPARE i160_pb FROM g_sql
    DECLARE ini_curs CURSOR FOR i160_pb
 
    CALL g_ini.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ini_curs INTO g_ini[g_cnt].*  
        IF STATUS THEN 
            CALL cl_err('foreach:',STATUS,1) 
            EXIT FOREACH 
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ini.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i160_bp(p_ud)
  DEFINE   p_ud   LIKE type_file.chr1    
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0      
   LET g_curs_index = 0            
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ini TO s_ini.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
                                                 
FUNCTION i160_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1       
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN  
     CALL cl_set_comp_entry("ini01",TRUE)     
     IF g_ini[l_ac].ini01 = "purity" THEN
        CALL cl_set_comp_entry('ini01,ini03',FALSE)
     ELSE
        CALL cl_set_comp_entry('ini03',TRUE)
     END IF
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i160_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1         
  DEFINE l_cnt   LIKE type_file.num5                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      IF g_ini[l_ac].ini01 = "purity" THEN
         CALL cl_set_comp_entry('ini01,ini03',FALSE)
      ELSE
         CALL cl_set_comp_entry('ini03',TRUE)
      END IF
   END IF                                                                       
                                                                                
END FUNCTION       
#TQC-B90236----------------end---------                                                             

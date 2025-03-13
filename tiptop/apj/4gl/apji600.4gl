# Prog. Version..: '5.30.06-13.04.22(00002)'     #
#
# Pattern name...: apji600.4gl
# Descriptions...: POC取得方式基本檔 
# Date & Author..: No.FUN-790025 07/10/19 By Chenmoyan
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980005 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_pjw           DYNAMIC ARRAY OF RECORD    #(Program Variables)      
           pjw01 LIKE pjw_file.pjw01,
           pjw02 LIKE pjw_file.pjw02,
           pjw03 LIKE pjw_file.pjw03,
           pjw04 LIKE pjw_file.pjw04,
           pjw05 LIKE pjw_file.pjw05,
           pjwacti LIKE pjw_file.pjwacti
           END RECORD,
    g_pjw_t         RECORD                    
           pjw01 LIKE pjw_file.pjw01,
           pjw02 LIKE pjw_file.pjw02,
           pjw03 LIKE pjw_file.pjw03,
           pjw04 LIKE pjw_file.pjw04,
           pjw05 LIKE pjw_file.pjw05,
           pjwacti LIKE pjw_file.pjwacti
           END RECORD,
    g_wc2,g_sql    string, 
    g_rec_b         LIKE type_file.num5,       
    l_ac            LIKE type_file.num5        #ARRAY CNT  
    DEFINE g_msg                LIKE type_file.chr1000   
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5   
    OPTIONS                                
        INPUT NO WRAP
    DEFER INTERRUPT                        
    
#     IF  g_aza.aza08 <> 'Y' THEN 
#        EXIT PROGRAM 
#     END IF
 
     IF (NOT cl_user()) THEN
        EXIT PROGRAM
     END IF
  
     WHENEVER ERROR CALL cl_err_msg_log
  
     IF (NOT cl_setup("APJ")) THEN
        EXIT PROGRAM
     END IF
 
 
     CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
         LET p_row = 4 LET p_col = 20
     OPEN WINDOW i600_w AT p_row,p_col WITH FORM "apj/42f/apji600"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
     CALL cl_ui_init()
 
     LET g_wc2 = '1=1' CALL i600_b_fill(g_wc2)
     CALL i600_menu()
     CLOSE WINDOW i600_w                 
     CALL  cl_used(g_prog,g_time,2)     
         RETURNING g_time   
END MAIN
 
FUNCTION i600_menu()
 
   WHILE TRUE
      CALL i600_bp("G")
      
      CASE g_action_choice
      
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i600_q()
            END IF
            
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i600_b()
            ELSE
               LET g_action_choice = NULL
            END IF
            
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF                                                                     
               LET g_msg = 'p_query "apji600" "',g_wc2 CLIPPED,'"'                                                                  
               CALL cl_cmdrun(g_msg) 
            END IF
    
         WHEN "help"
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjw),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i600_q()
   CALL i600_b_askkey()
END FUNCTION
 
FUNCTION i600_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #ARRAY CNT  
    l_n             LIKE type_file.num5,                
    l_lock_sw       LIKE type_file.chr1,                
    p_cmd           LIKE type_file.chr1,                
    l_allow_insert  LIKE type_file.chr1,                
    l_allow_delete  LIKE type_file.chr1,                
    l_cnt           LIKE type_file.num10 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')                                  
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT pjw01,pjw02,pjw03,pjw04,pjw05,pjwacti", 
                       "  FROM pjw_file WHERE pjw01=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i600_bcl CURSOR FROM g_forupd_sql           # LOCK CURSOR
 
    INPUT ARRAY g_pjw WITHOUT DEFAULTS FROM s_pjw.*     
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
        LET g_pjw_t.* = g_pjw[l_ac].*         
        IF l_n>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET g_pjw_t.* = g_pjw[l_ac].*  #BACKUP
           LET g_before_input_done = FALSE                                      
           LET g_before_input_done = TRUE                                       
      
           OPEN i600_bcl USING g_pjw_t.pjw01
           IF STATUS THEN
              CALL cl_err("OPEN i600_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i600_bcl INTO g_pjw[l_ac].* 
              IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pjw_t.pjw01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF 
           END IF
        END IF
 
     BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pjw[l_ac].* TO NULL                                             
         LET g_before_input_done = FALSE                                        
         LET g_before_input_done = TRUE                                         
         INITIALIZE g_pjw[l_ac].* TO NULL     
         LET g_pjw[l_ac].pjwacti = 'Y'           
         NEXT FIELD pjw01
 
     AFTER INSERT
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i600_bcl
           CANCEL INSERT
        END IF
  
        BEGIN WORK                    
 
        INSERT INTO pjw_file(pjw01,pjw02,pjw03,pjw04,pjw05,
                             pjwacti,pjwdate,pjwgrup,pjwmodu,pjwuser,
                             pjwplant,pjwlegal,pjworiu,pjworig) #FUN-980005
        VALUES(g_pjw[l_ac].pjw01,g_pjw[l_ac].pjw02,
               g_pjw[l_ac].pjw03,g_pjw[l_ac].pjw04,g_pjw[l_ac].pjw05,
               g_pjw[l_ac].pjwacti,g_today,g_grup,g_user,
               g_user,
               g_plant,g_legal, g_user, g_grup) #FUN-980005      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN 
 
           CALL cl_err3("ins","pjw_file",g_pjw[l_ac].pjw01,"",SQLCA.sqlcode,"","",1)  
           CANCEL INSERT
        ELSE
           LET g_rec_b = g_rec_b+1
           DISPLAY g_rec_b TO FORMONLY.cnt
 
           COMMIT WORK
         
        END IF
 
    AFTER FIELD pjw01                        #check 
        IF NOT cl_null(g_pjw[l_ac].pjw01) THEN
           IF g_pjw[l_ac].pjw01 != g_pjw_t.pjw01 OR g_pjw_t.pjw01 IS NULL THEN
              SELECT count(*) INTO g_cnt FROM pjw_file
               WHERE pjw01 = g_pjw[l_ac].pjw01
              IF g_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 LET g_pjw[l_ac].pjw01 = g_pjw_t.pjw01
                 NEXT FIELD pjw01
              END IF
              DISPLAY 'SELECT COUNT OK'
           END IF
        END IF
  
   AFTER FIELD pjw05
       IF g_pjw[l_ac].pjw05<1 OR g_pjw[l_ac].pjw05>100 THEN
          CALL cl_err("1-100",-1152,0)
          NEXT FIELD pjw05
       END IF
       IF g_pjw[l_ac].pjw05<g_pjw[l_ac].pjw04 THEN
          CALL cl_err("",'apj-600',0)
          NEXT FIELD pjw05
       END IF
 
   AFTER FIELD pjw04
       IF g_pjw[l_ac].pjw04 < 1 OR g_pjw[l_ac].pjw04 > 100 THEN
          CALL cl_err("1-100",-1152,0)
          NEXT FIELD pjw04
       END IF
   BEFORE DELETE                            
       IF NOT cl_delh(0,0) THEN
          CANCEL DELETE
          END IF
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             CANCEL DELETE 
          END IF 
          DELETE FROM pjw_file WHERE pjw01 = g_pjw_t.pjw01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","pjw_file",g_pjw_t.pjw01,"",SQLCA.sqlcode,"","",1)  
             ROLLBACK WORK
             CANCEL DELETE
          END IF
          LET g_rec_b = g_rec_b-1
          DISPLAY g_rec_b TO FORMONLY.cnt
 
     ON ROW CHANGE
        IF INT_FLAG THEN                 
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          LET g_pjw[l_ac].* = g_pjw_t.*
          CLOSE i600_bcl
          ROLLBACK WORK
          EXIT INPUT
        END IF
        IF l_lock_sw="Y" THEN
          CALL cl_err(g_pjw[l_ac].pjw01,-263,0)
          LET g_pjw[l_ac].* = g_pjw_t.*
        ELSE
          UPDATE pjw_file 
           SET pjw01=g_pjw[l_ac].pjw01,pjw02=g_pjw[l_ac].pjw02,
                   pjw03=g_pjw[l_ac].pjw03,pjw04=g_pjw[l_ac].pjw04,pjw05=g_pjw[l_ac].pjw05,
                   pjwacti=g_pjw[l_ac].pjwacti,
                   pjwgrup=g_grup,pjwmodu=g_user,pjwdate=g_today
            WHERE pjw01 = g_pjw_t.pjw01
          IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pjw_file",g_pjw[l_ac].pjw01,"",SQLCA.sqlcode,"","",1)  
            LET g_pjw[l_ac].* = g_pjw_t.*
          END IF
        END IF
 
     AFTER ROW
        LET l_ac = ARR_CURR()            
       #LET l_ac_t = l_ac    #FUN-D30034 mark            
 
        IF INT_FLAG THEN
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_pjw[l_ac].* = g_pjw_t.*
          #FUN-D30034--add--begin--
          ELSE
             CALL g_pjw.deleteElement(l_ac)
             IF g_rec_b != 0 THEN
                LET g_action_choice = "detail"
                LET l_ac = l_ac_t
             END IF
          #FUN-D30034--add--end----
          END IF
          CLOSE i600_bcl               
          ROLLBACK WORK                
          EXIT INPUT
        END IF
        LET l_ac_t = l_ac   #FUN-D30034 add
        CLOSE i600_bcl                  
 
     ON ACTION CONTROLO                        
        IF INFIELD(pjw01) AND l_ac > 1 THEN
          LET g_pjw[l_ac].* = g_pjw[l_ac-1].*
          NEXT FIELD pjw01
        END IF
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         
        CALL cl_about()      
 
     ON ACTION help          
        CALL cl_show_help()  
     
  END INPUT
 
 
  CLOSE i600_bcl
  COMMIT WORK
END FUNCTION
 
FUNCTION i600_b_askkey()
 
    CLEAR FORM
    CALL g_pjw.clear()
 
    CONSTRUCT g_wc2 ON pjw01,pjw02,pjw03,pjw04,pjw05,pjwacti
         FROM s_pjw[1].pjw01,s_pjw[1].pjw02,s_pjw[1].pjw03,s_pjw[1].pjw04,
              s_pjw[1].pjw05,s_pjw[1].pjwacti
 
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
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjwuser', 'pjwgrup') #FUN-980030
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i600_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i600_b_fill(p_wc2)              #BODY FILL UP
#DEFINE    p_wc2           LIKE type_file.chr1000 
DEFINE     p_wc2  STRING     #NO.FUN-910082
 
    LET g_sql =
        "SELECT pjw01,pjw02,pjw03,pjw04,pjw05,pjwacti", 
        " FROM pjw_file",
        " WHERE ", p_wc2 CLIPPED                   
    PREPARE i600_pb FROM g_sql
    DECLARE pjw_curs CURSOR FOR i600_pb
 
    CALL g_pjw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pjw_curs INTO g_pjw[g_cnt].*           
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
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    CALL g_pjw.deleteElement(g_cnt)
    MESSAGE ""
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjw TO s_pjw.* ATTRIBUTE(COUNT=g_rec_b)
   
 
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
      ON ACTION output
         LET g_action_choice="output"
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
 
      ON ACTION cancel
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
#No.FUN-790025

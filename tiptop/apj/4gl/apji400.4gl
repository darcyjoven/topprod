# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# Pattern name...: apji400.4gl
# Descriptions...: WBS分類維護
# Date & Author..: FUN-790025 07/10/18 By Shiwuying
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pjr           DYNAMIC ARRAY OF RECORD
           pjr01       LIKE pjr_file.pjr01,       
           pjr02       LIKE pjr_file.pjr02, 
           pjracti     LIKE pjr_file.pjracti 
                       END RECORD,
       g_pjr_t         RECORD             
           pjr01       LIKE pjr_file.pjr01,     
           pjr02       LIKE pjr_file.pjr02,      
           pjracti     LIKE pjr_file.pjracti     
                       END RECORD,
       g_wc2,g_sql     STRING, 
       g_rec_b         LIKE type_file.num5,               
       l_ac            LIKE type_file.num5                
 
DEFINE g_forupd_sql         STRING                  
DEFINE g_cnt                LIKE type_file.num10    
DEFINE g_msg                LIKE type_file.chr1000 
DEFINE g_before_input_done  LIKE type_file.num5     
DEFINE g_i                  LIKE type_file.num5     
 
MAIN
      
 DEFINE  p_row,p_col	 LIKE type_file.num5        
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                    
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("APJ")) THEN
      EXIT PROGRAM
    END IF
      
    CALL cl_used(g_prog,g_time,1)    
         RETURNING g_time  
    
#    IF  g_aza.aza08 <> 'Y' THEN 
#       EXIT PROGRAM 
#    END IF 
 
    LET p_row = 4 LET p_col = 10 
    OPEN WINDOW i400_w AT p_row,p_col WITH FORM "apj/42f/apji400"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    LET g_wc2 = '1=1' CALL i400_b_fill(g_wc2)
    CALL i400_menu()
    CLOSE WINDOW i400_w               
    CALL  cl_used(g_prog,g_time,2)  
         RETURNING g_time   
END MAIN
 
FUNCTION i400_menu()
 
   WHILE TRUE
      CALL i400_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i400_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i400_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               #CALL i400_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               LET g_msg = 'p_query "apji400" "',g_wc2 CLIPPED,'"'
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
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pjr),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i400_q()
   CALL i400_b_askkey()
END FUNCTION
 
FUNCTION i400_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    
    l_n             LIKE type_file.num5,     
    l_lock_sw       LIKE type_file.chr1,  
    p_cmd           LIKE type_file.chr1,   
    l_allow_insert  LIKE type_file.chr1,   
    l_allow_delete  LIKE type_file.chr1    
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pjr01,pjr02,pjracti FROM pjr_file WHERE pjr00='0' AND pjr01=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_pjr WITHOUT DEFAULTS FROM s_pjr.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac) 
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               LET p_cmd='u'
               LET  g_before_input_done = FALSE 
               CALL i400_set_entry(p_cmd)
               CALL i400_set_no_entry(p_cmd) 
               LET  g_before_input_done = TRUE 
 
               BEGIN WORK
               LET g_pjr_t.* = g_pjr[l_ac].*  #BACKUP
               OPEN i400_bcl USING g_pjr_t.pjr01
               IF STATUS THEN
                  CALL cl_err("OPEN i400_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i400_bcl INTO g_pjr[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_pjr_t.pjr01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_pjr[l_ac].* TO NULL
            LET g_pjr[l_ac].pjracti = 'Y'       #Body default
            LET g_pjr_t.* = g_pjr[l_ac].*
            LET  g_before_input_done = FALSE
            CALL i400_set_entry(p_cmd)
            CALL i400_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            CALL cl_show_fld_cont()    
            NEXT FIELD pjr01
 
      AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO pjr_file(pjr00,pjr01,pjr02,pjracti,pjruser,pjrgrup,pjrdate,pjroriu,pjrorig)
                          VALUES('0',g_pjr[l_ac].pjr01,g_pjr[l_ac].pjr02,
                                 g_pjr[l_ac].pjracti, g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pjr_file",g_pjr[l_ac].pjr01,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD pjr01
            IF NOT cl_null(g_pjr[l_ac].pjr01) THEN 
               IF g_pjr[l_ac].pjr01 != g_pjr_t.pjr01 OR
                  (g_pjr[l_ac].pjr01 IS NOT NULL AND g_pjr_t.pjr01 IS NULL) THEN
                  SELECT count(*) INTO l_n FROM pjr_file
                    WHERE pjr01 = g_pjr[l_ac].pjr01 AND pjr00=0
                  IF l_n > 0 THEN     
                    CALL cl_err('',-239,0)
                    LET g_pjr[l_ac].pjr01 = g_pjr_t.pjr01
                    NEXT FIELD pjr01
                  END IF
               END IF
            END IF
 
        AFTER FIELD pjracti
            IF cl_null(g_pjr[l_ac].pjracti) THEN
               LET g_pjr[l_ac].pjracti = 'N'
            END IF
        
        BEFORE DELETE 
            IF g_pjr_t.pjr01 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
               END IF 
               DELETE FROM pjr_file WHERE pjr01 = g_pjr_t.pjr01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","pjr_file",g_pjr_t.pjr01,"",SQLCA.sqlcode,"","",1) 
                   ROLLBACK WORK
                   CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK" 
               CLOSE i400_bcl     
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pjr[l_ac].* = g_pjr_t.*
              CLOSE i400_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pjr[l_ac].pjr01,-263,1)
              LET g_pjr[l_ac].* = g_pjr_t.*
           ELSE
              UPDATE pjr_file SET pjr01=g_pjr[l_ac].pjr01,
                                  pjr02=g_pjr[l_ac].pjr02,
                                  pjracti=g_pjr[l_ac].pjracti,
                                  pjrmodu=g_user,
                                  pjrdate=g_today
                              WHERE pjr01=g_pjr_t.pjr01 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","pjr_file",g_pjr_t.pjr01,"",SQLCA.sqlcode,"","",1) 
                 LET g_pjr[l_ac].* = g_pjr_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i400_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                   LET g_pjr[l_ac].* = g_pjr_t.* 
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_pjr.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i400_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac 
            CLOSE i400_bcl
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i400_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(pjr01) AND l_ac > 1 THEN
               LET g_pjr[l_ac].* = g_pjr[l_ac-1].*
               LET g_pjr[l_ac].pjr01 = NULL
               NEXT FIELD pjr01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
            CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                 RETURNING g_fld_name,g_frm_name 
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about       
            CALL cl_about()     
 
        ON ACTION help         
            CALL cl_show_help()
         
    END INPUT
    CLOSE i400_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i400_b_askkey()
    CLEAR FORM
    CALL g_pjr.clear()
    CONSTRUCT g_wc2 ON pjr01,pjr02,pjracti
            FROM s_pjr[1].pjr01,s_pjr[1].pjr02,s_pjr[1].pjracti
 
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pjruser', 'pjrgrup') #FUN-980030
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
    END IF
    CALL i400_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i400_b_fill(p_wc2)
#    DEFINE p_wc2     LIKE type_file.chr1000 
    DEFINE p_wc2  STRING     #NO.FUN-910082 
    LET g_sql = "SELECT pjr01,pjr02,pjracti",
                " FROM pjr_file",
                " WHERE ", p_wc2 CLIPPED,
                " AND pjr00='0'",
                " ORDER BY pjr01 "
    PREPARE i400_pb FROM g_sql
    DECLARE pjr_curs CURSOR FOR i400_pb
 
    CALL g_pjr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH pjr_curs INTO g_pjr[g_cnt].*  
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
    CALL g_pjr.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i400_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pjr TO s_pjr.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
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
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
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
 
FUNCTION i400_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("pjr01",TRUE)
  END IF
END FUNCTION 
 
FUNCTION i400_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
     CALL cl_set_comp_entry("pjr01",FALSE)
  END IF
END FUNCTION
#NO.FUN-790025
 

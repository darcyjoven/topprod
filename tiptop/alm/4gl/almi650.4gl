# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: almi650.4gl
# Descriptions...: 券單位金額維護
# Date & Author..: FUN-870015 08/08/20 By shiwuying
# Modify.........: No.FUN-960134 09/07/15 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
# Modify.........: No.CHI-C80041 13/01/31 By bart 排除作廢
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lrz           DYNAMIC ARRAY OF RECORD
           lrz01       LIKE lrz_file.lrz01,
           lrz02       LIKE lrz_file.lrz02,
           lrz03       LIKE lrz_file.lrz03
                       END RECORD,
       g_lrz_t         RECORD             
           lrz01       LIKE lrz_file.lrz01,
           lrz02       LIKE lrz_file.lrz02,
           lrz03       LIKE lrz_file.lrz03
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
    OPTIONS                              
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                    
 
    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
    END IF
      
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
         
    OPEN WINDOW i650_w WITH FORM "alm/42f/almi650"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
    CALL cl_ui_init()
    LET g_wc2 = '1=1' CALL i650_b_fill(g_wc2)
    CALL i650_menu()
    CLOSE WINDOW i650_w               
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   
END MAIN
 
FUNCTION i650_menu()
 
   WHILE TRUE
      CALL i650_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i650_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i650_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               Call i650_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lrz),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i650_q()
   CALL i650_b_askkey()
END FUNCTION
 
FUNCTION i650_b()
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
 
    LET g_forupd_sql = "SELECT lrz01,lrz02,lrz03 ",
                       " FROM lrz_file WHERE lrz01=? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i650_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_lrz WITHOUT DEFAULTS FROM s_lrz.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW = l_allow_insert,
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
               BEGIN WORK
               LET p_cmd='u'
               LET  g_before_input_done = FALSE 
               CALL i650_set_entry(p_cmd)
               CALL i650_set_no_entry(p_cmd) 
               LET  g_before_input_done = TRUE 
 
               LET g_lrz_t.* = g_lrz[l_ac].*  #BACKUP
               OPEN i650_bcl USING g_lrz_t.lrz01
               IF STATUS THEN
                  CALL cl_err("OPEN i650_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i650_bcl INTO g_lrz[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_lrz_t.lrz01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            LET  g_before_input_done = FALSE
            CALL i650_set_entry(p_cmd)
            CALL i650_set_no_entry(p_cmd)
            LET  g_before_input_done = TRUE
            INITIALIZE g_lrz[l_ac].* TO NULL
            LET g_lrz[l_ac].lrz03 = 'Y'       #Body default
            LET g_lrz_t.* = g_lrz[l_ac].*
            CALL cl_show_fld_cont()    
            NEXT FIELD lrz01
 
      AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO lrz_file(lrz01,lrz02,lrz03)
                          VALUES(g_lrz[l_ac].lrz01,g_lrz[l_ac].lrz02,
                                 g_lrz[l_ac].lrz03)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","lrz_file",g_lrz[l_ac].lrz01,"",SQLCA.sqlcode,"","",1) 
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2  
            END IF
 
        AFTER FIELD lrz01
           IF NOT cl_null(g_lrz[l_ac].lrz01) THEN
              IF g_lrz[l_ac].lrz01 != g_lrz_t.lrz01 
                 OR g_lrz_t.lrz01 IS NULL THEN
                 SELECT count(*) INTO l_n FROM lrz_file
                  WHERE lrz01 = g_lrz[l_ac].lrz01
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_lrz[l_ac].lrz01 = g_lrz_t.lrz01
                    NEXT FIELD lrz01
                 END IF
              END IF
           END IF
 
        AFTER FIELD lrz02
           IF NOT cl_null(g_lrz[l_ac].lrz02) THEN
              IF g_lrz[l_ac].lrz02 < 0 THEN
                 CALL cl_err('','alm-061',0)
                 LET g_lrz[l_ac].lrz02 = g_lrz_t.lrz02
                 NEXT FIELD lrz02
              END IF
           END IF
 
        AFTER FIELD lrz03
           IF g_lrz[l_ac].lrz03 != g_lrz_t.lrz03 AND g_lrz_t.lrz03 = 'Y' THEN
              CALL i650_lrz03()
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lrz[l_ac].lrz03 = 'Y' 
                  DISPLAY BY NAME g_lrz[l_ac].lrz03
                  NEXT FIELD lrz03
               END IF
            END IF
 
        BEFORE DELETE 
            IF g_lrz_t.lrz01 IS NOT NULL THEN
               IF g_lrz_t.lrz03 = 'Y' THEN
                  CALL i650_lrz03()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     CANCEL DELETE
                  END IF
               END IF
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
               END IF
 
               DELETE FROM lrz_file WHERE lrz01 = g_lrz_t.lrz01
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","lrz_file",g_lrz_t.lrz01,"",SQLCA.sqlcode,"","",1) 
                   EXIT INPUT
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2  
               MESSAGE "Delete OK"
               CLOSE i650_bcl 
               COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_lrz[l_ac].* = g_lrz_t.*
              CLOSE i650_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_lrz[l_ac].lrz01,-263,1)
              LET g_lrz[l_ac].* = g_lrz_t.*
           ELSE
              UPDATE lrz_file SET lrz01 = g_lrz[l_ac].lrz01,
                                  lrz02 = g_lrz[l_ac].lrz02,
                                  lrz03 = g_lrz[l_ac].lrz03
                            WHERE lrz01 = g_lrz_t.lrz01 
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","lrz_file",g_lrz_t.lrz01,"",SQLCA.sqlcode,"","",1) 
                 LET g_lrz[l_ac].* = g_lrz_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 CLOSE i650_bcl
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30033 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_lrz[l_ac].* = g_lrz_t.* 
               #FUN-D30033--add--str--
               ELSE
                  CALL g_lrz.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30033--add--end--
               END IF
               CLOSE i650_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30033 Add
            CLOSE i650_bcl
            COMMIT WORK 
 
        ON ACTION CONTROLN
            CALL i650_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO
            IF INFIELD(lrz01) AND l_ac > 1 THEN
               LET g_lrz[l_ac].* = g_lrz[l_ac-1].*
               LET g_lrz[l_ac].lrz01 = NULL
               NEXT FIELD lrz01
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
    CLOSE i650_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i650_lrz03()
 DEFINE l_cnt    LIKE type_file.num5
 
   LET g_errno = ''
   SELECT COUNT(*) INTO l_cnt
     FROM lpy_file
    WHERE lpy05 = g_lrz[l_ac].lrz01
      AND lpy13 <> 'X'  #CHI-C80041
   IF l_cnt > 0 THEN
      LET g_errno = 'alm-538'
   END IF
 
   IF cl_null(g_errno) THEN
      SELECT COUNT(*) INTO l_cnt
        FROM lqg_file
       WHERE lqg15 = g_lrz[l_ac].lrz01
      IF l_cnt > 0 THEN
         LET g_errno = 'alm-539'
      END IF
   END IF
END FUNCTION 
 
FUNCTION i650_b_askkey()
    CLEAR FORM
    CALL g_lrz.clear()
    CONSTRUCT g_wc2 ON lrz01,lrz02,lrz03
            FROM s_lrz[1].lrz01,s_lrz[1].lrz02,s_lrz[1].lrz03
 
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
         
      ON ACTION controlp
         CASE
            WHEN INFIELD(lrz01)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_lrz01"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lrz01
               NEXT FIELD lrz01
            OTHERWISE EXIT CASE
         END CASE
      
      ON ACTION qbe_select
         CALL cl_qbe_select() 
         
      ON ACTION qbe_save
	 CALL cl_qbe_save()
 
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN
    END IF
    CALL i650_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i650_b_fill(p_wc2)
    DEFINE p_wc2     LIKE type_file.chr1000  
    LET g_sql = "SELECT lrz01,lrz02,lrz03",
                " FROM lrz_file",
                " WHERE ", p_wc2 CLIPPED,
                " ORDER BY lrz01 "
    PREPARE i650_pb FROM g_sql
    DECLARE lrz_curs CURSOR FOR i650_pb
 
    CALL g_lrz.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lrz_curs INTO g_lrz[g_cnt].*  
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
    CALL g_lrz.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
END FUNCTION
 
FUNCTION i650_bp(p_ud)
 
   DEFINE   p_ud   LIKE type_file.chr1    
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lrz TO s_lrz.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i650_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN 
     CALL cl_set_comp_entry("lrz01",TRUE)
  END IF
END FUNCTION 
 
FUNCTION i650_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1 
  IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN 
     CALL cl_set_comp_entry("lrz01",FALSE)
  END IF
END FUNCTION
 
FUNCTION i650_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
#    LET l_cmd = 'p_query "almi650" "',g_wc2 CLIPPED,'"'                                                                               
#    CALL cl_cmdrun(l_cmd) 
#    RETURN
END FUNCTION
#No.FUN-960134

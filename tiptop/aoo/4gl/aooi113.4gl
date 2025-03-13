# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi113.4gl
# Descriptions...: 城區資料維護作業
# Date & Author..: NO.FUN-870006 08/09/24 By Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0157 09/12/08 By bnlent insert oriu,orig
# Modify.........: No.FUN-9B0025 09/12/10 By cockroach pass no.
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ryf          DYNAMIC ARRAY OF RECORD 
        ryf01       LIKE ryf_file.ryf01,
        ryf02       LIKE ryf_file.ryf02,
        ryf03       LIKE ryf_file.ryf03,
        ryf03_desc  LIKE rya_file.rya02,
        ryfacti     LIKE ryf_file.ryfacti
                    END RECORD,
    g_ryf_t         RECORD
        ryf01       LIKE ryf_file.ryf01,
        ryf02       LIKE ryf_file.ryf02,
        ryf03       LIKE ryf_file.ryf03,
        ryf03_desc  LIKE rya_file.rya02,
        ryfacti     LIKE ryf_file.ryfacti
                    END RECORD,
     g_wc2,g_sql    STRING, 
     g_rec_b         LIKE type_file.num5,
     l_ac            LIKE type_file.num5
 
DEFINE g_forupd_sql    STRING 
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_i             LIKE type_file.num5
DEFINE g_before_input_done   LIKE type_file.num5 
 
MAIN
 
DEFINE p_row,p_col   LIKE type_file.num5
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = 5 LET p_col = 22
   OPEN WINDOW i113_w AT p_row,p_col WITH FORM "aoo/42f/aooi113"  ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' 
   CALL i113_b_fill(g_wc2)
   CALL i113_menu()
   CLOSE WINDOW i113_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i113_menu()
 
   WHILE TRUE
      CALL i113_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i113_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i113_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i113_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_ryf[l_ac].ryf01 IS NOT NULL THEN
                  LET g_doc.column1 = "ryf01"
                  LET g_doc.value1 = g_ryf[l_ac].ryf01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ryf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i113_q()
   CALL i113_b_askkey()
END FUNCTION
 
FUNCTION i113_b()
DEFINE
    l_ac_t          LIKE type_file.num5,
    l_n             LIKE type_file.num5,
    l_lock_sw       LIKE type_file.chr1,
    p_cmd           LIKE type_file.chr1,
    l_allow_insert  LIKE type_file.chr1,
    l_allow_delete  LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT ryf01,ryf02,ryf03,'',ryfacti FROM ryf_file",
                       " WHERE ryf01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i113_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ryf WITHOUT DEFAULTS FROM s_ryf.*
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
               LET g_ryf_t.* = g_ryf[l_ac].*  #BACKUP
               #FUN-870100---begin
               LET g_before_input_done = FALSE                                                                                      
               CALL aooi113_set_entry(p_cmd)                                                                                           
               CALL aooi113_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE
               #FUN-870100---end
               OPEN i113_bcl USING g_ryf_t.ryf01 
               IF STATUS THEN
                  CALL cl_err("OPEN i113_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i113_bcl INTO g_ryf[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ryf_t.ryf01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               SELECT ryb02  INTO g_ryf[l_ac].ryf03_desc FROM ryb_file
                 WHERE ryb01=g_ryf[l_ac].ryf03  
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           #FUN-870100---begin
           LET g_before_input_done = FALSE                                                                                      
           CALL aooi113_set_entry(p_cmd)                                                                                           
           CALL aooi113_set_no_entry(p_cmd)                                                                                        
           LET g_before_input_done = TRUE
           #FUN-870100---end
           INITIALIZE g_ryf[l_ac].* TO NULL
           LET g_ryf[l_ac].ryfacti = 'Y'
           LET g_ryf_t.* = g_ryf[l_ac].* 
           CALL cl_show_fld_cont()
           NEXT FIELD ryf01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i113_bcl
              CANCEL INSERT
           END IF
           INSERT INTO ryf_file(ryf01,ryf02,ryf03,ryfacti,ryfuser,ryfgrup,
                                ryfcrat,ryfdate,ryforiu,ryforig) #No.FUN-9B0157
                         VALUES(g_ryf[l_ac].ryf01,g_ryf[l_ac].ryf02,
                                g_ryf[l_ac].ryf03,g_ryf[l_ac].ryfacti,g_user,
                                g_grup,g_today,g_today,g_user,g_grup)#No.FUN-9B0157
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","ryf_file",g_ryf[l_ac].ryf01,"",SQLCA.sqlcode,"","",1)
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD ryf01
            IF NOT cl_null(g_ryf[l_ac].ryf01) THEN
               IF g_ryf[l_ac].ryf01 != g_ryf_t.ryf01 OR
                  g_ryf_t.ryf01 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM ryf_file
                       WHERE ryf01 = g_ryf[l_ac].ryf01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ryf[l_ac].ryf01 = g_ryf_t.ryf01
                       NEXT FIELD ryf01
                   END IF
               END IF
            END IF
 
 
       AFTER FIELD ryf03
           IF NOT cl_null(g_ryf[l_ac].ryf03) THEN
              CALL i113_ryf03('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err('',g_errno,0) 
                 NEXT FIELD ryf03
              END IF
          END IF
                                                  	
       AFTER FIELD ryfacti
          IF NOT cl_null(g_ryf[l_ac].ryfacti) THEN
             IF g_ryf[l_ac].ryfacti NOT MATCHES '[YN]' THEN
                LET g_ryf[l_ac].ryfacti = g_ryf_t.ryfacti
                NEXT FIELD ryfacti
             END IF
          END IF
      
        BEFORE DELETE
            IF g_ryf_t.ryf01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "ryf01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_ryf[l_ac].ryf01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ryf_file WHERE ryf01 = g_ryf_t.ryf01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ryf_file",g_ryf_t.ryf01,"",SQLCA.sqlcode,"","",1)
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ryf[l_ac].* = g_ryf_t.*
              CLOSE i113_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_ryf[l_ac].ryf01,-263,0)
               LET g_ryf[l_ac].* = g_ryf_t.*
           ELSE
               UPDATE ryf_file SET ryf01=g_ryf[l_ac].ryf01,
                                   ryf02=g_ryf[l_ac].ryf02,
                                   ryf03=g_ryf[l_ac].ryf03,
                                   ryfacti=g_ryf[l_ac].ryfacti,
                                   ryfmodu=g_user,
                                   ryfdate=g_today
                WHERE ryf01 = g_ryf_t.ryf01 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","ryf_file",g_ryf_t.ryf01,"",SQLCA.sqlcode,"","",1)
                  LET g_ryf[l_ac].* = g_ryf_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D40030 Mark
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_ryf[l_ac].* = g_ryf_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_ryf.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i113_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D40030 Add
           CLOSE i113_bcl
           COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(ryf03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ryb01"
                   LET g_qryparam.default1 = g_ryf[l_ac].ryf03
                   CALL cl_create_qry() RETURNING g_ryf[l_ac].ryf03
                   DISPLAY g_ryf[l_ac].ryf03 TO ryf03
                   CALL i113_ryf03('a')
                OTHERWISE
                   EXIT CASE
            END CASE
 
        ON ACTION CONTROLO
            IF INFIELD(ryf01) AND l_ac > 1 THEN
                LET g_ryf[l_ac].* = g_ryf[l_ac-1].*
                NEXT FIELD ryf01
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
 
  CLOSE i113_bcl
  COMMIT WORK
END FUNCTION
 
FUNCTION i113_ryf03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_rybacti       LIKE ryb_file.rybacti
 
    LET g_errno = ' '
    SELECT ryb02,rybacti INTO g_ryf[l_ac].ryf03_desc,l_rybacti
        FROM ryb_file
      WHERE ryb01 = g_ryf[l_ac].ryf03
    CASE WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-343'
         WHEN l_rybacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i113_b_askkey()
 
    CLEAR FORM
   CALL g_ryf.clear()
 
    CONSTRUCT g_wc2 ON ryf01,ryf02,ryf03,ryfacti
         FROM s_ryf[1].ryf01,s_ryf[1].ryf02,s_ryf[1].ryf03,s_ryf[1].ryfacti
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         ON ACTION controlp
            CASE WHEN INFIELD(ryf03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ryf03"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_ryf[1].ryf03            
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
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ryfuser', 'ryfgrup') #FUN-980030
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      LET g_rec_b = 0
      RETURN
   END IF
 
   CALL i113_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i113_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000
 
    #LET g_sql =
    #    "SELECT ryf01,ryf02,ryf03,rya02,ryfacti",
    #    " FROM ryf_file,OUTER rya_file",
    #    " WHERE ryf03 = rya01 AND ", p_wc2 CLIPPED,                     #單身
    #    " ORDER BY ryf01"
    LET g_sql =                                                                                                                     
        "SELECT ryf01,ryf02,ryf03,ryb02,ryfacti",                                                                                   
        #" FROM ryf_file,ryb_file",                                                                                            
        " FROM ryf_file LEFT OUTER JOIN ryb_file ON (ryf03=ryb01)",                                                                                            
        #" WHERE ryf03 = ryb01(+) AND ", p_wc2 CLIPPED,                     #單身                                                       
        " WHERE ", p_wc2 CLIPPED,                     #單身                                                       
        " ORDER BY ryf01"
 
    PREPARE i113_pb FROM g_sql
    DECLARE ryf_curs CURSOR FOR i113_pb
 
    CALL g_ryf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ryf_curs INTO g_ryf[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ryf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i113_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ryf TO s_ryf.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
     ON ACTION related_document 
        LET g_action_choice="related_document"
        EXIT DISPLAY
 
     ON ACTION exporttoexcel
        LET g_action_choice = 'exporttoexcel'
        EXIT DISPLAY
 
     AFTER DISPLAY
        CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i113_out()
    DEFINE l_cmd   LIKE type_file.chr1000
        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    RETURN END IF
    
    LET l_cmd='p_query "aooi113" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd)  
END FUNCTION
#NO.FUN-870006----end----
#FUN-870100---begin
FUNCTION aooi113_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("ryf01",TRUE)
        END IF
END FUNCTION
 
FUNCTION aooi113_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ryf01",FALSE)
        END IF
END FUNCTION
#FUN-870100--end
#FUN-9B0025 PASS NO.

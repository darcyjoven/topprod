# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aooi111.4gl
# Descriptions...: 省別資料維護 
# Date & Author..: 08/06/30 By Sunyanchun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0019 09/11/04 By lilingyu Sql改成標準寫法
# Modify.........: No.FUN-9B0157 09/12/08 By bnlent insert oriu,orig
# Modify.........: No.FUN-9B0025 09/12/10 By cockroach pass no.
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_rya          DYNAMIC ARRAY OF RECORD
        rya01       LIKE rya_file.rya01,
        rya02       LIKE rya_file.rya02,
        rya03       LIKE rya_file.rya03,
        rya03_desc  LIKE geo_file.geo02,
        ryaacti     LIKE rya_file.ryaacti 
                    END RECORD,
    g_rya_t         RECORD
        rya01       LIKE rya_file.rya01,
        rya02       LIKE rya_file.rya02,
        rya03       LIKE rya_file.rya03,
        rya03_desc  LIKE geo_file.geo02,
        ryaacti     LIKE rya_file.ryaacti
                    END RECORD,
    g_wc2,g_sql    STRING,    
    g_rec_b         LIKE type_file.num5,
    l_ac            LIKE type_file.num5
 
DEFINE   g_forupd_sql    STRING   
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_before_input_done   LIKE type_file.num5 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
   LET p_row = 5 LET p_col = 22
   OPEN WINDOW i111_w AT p_row,p_col WITH FORM "aoo/42f/aooi111"  
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   LET g_wc2 = '1=1' 
   CALL i111_b_fill(g_wc2)
   CALL i111_menu()
   CLOSE WINDOW i111_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i111_menu()
 
   WHILE TRUE
      CALL i111_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i111_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i111_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i111_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_rya[l_ac].rya01 IS NOT NULL THEN
                  LET g_doc.column1 = "rya01"
                  LET g_doc.value1 = g_rya[l_ac].rya01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rya),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i111_q()
   CALL i111_b_askkey()
END FUNCTION
 
FUNCTION i111_b()
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
 
    LET g_forupd_sql = "SELECT rya01,rya02,rya03,'',ryaacti FROM rya_file",
                       " WHERE rya01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i111_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_rya WITHOUT DEFAULTS FROM s_rya.*
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
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_rya_t.* = g_rya[l_ac].*
               
               LET g_before_input_done = FALSE                                                                                      
               CALL aooi111_set_entry(p_cmd)                                                                                           
               CALL aooi111_set_no_entry(p_cmd)                                                                                        
               LET g_before_input_done = TRUE
 
               OPEN i111_bcl USING g_rya_t.rya01 
               IF STATUS THEN
                  CALL cl_err("OPEN i111_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i111_bcl INTO g_rya[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_rya_t.rya01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               SELECT geo02  INTO g_rya[l_ac].rya03_desc FROM geo_file
                  WHERE geo01=g_rya[l_ac].rya03  
               CALL cl_show_fld_cont()
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           LET g_before_input_done = FALSE                                                                                      
           CALL aooi111_set_entry(p_cmd)                                                                                           
           CALL aooi111_set_no_entry(p_cmd)                                                                                        
           LET g_before_input_done = TRUE
           INITIALIZE g_rya[l_ac].* TO NULL
           LET g_rya[l_ac].ryaacti = 'Y'
           LET g_rya_t.* = g_rya[l_ac].*
           CALL cl_show_fld_cont()
           NEXT FIELD rya01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i111_bcl
              CANCEL INSERT
           END IF
           INSERT INTO rya_file(rya01,rya02,rya03,ryaacti,ryauser,ryagrup,ryacrat,ryadate
                                ,ryaoriu,ryaorig)   #No.FUN-9B0157
                         VALUES(g_rya[l_ac].rya01,g_rya[l_ac].rya02,g_rya[l_ac].rya03,
                                g_rya[l_ac].ryaacti,g_user,g_grup,g_today,g_today
                                ,g_user,g_grup)     #No.FUN-9B0157
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("ins","rya_file",g_rya[l_ac].rya01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD rya01
            IF NOT cl_null(g_rya[l_ac].rya01) THEN
               IF g_rya[l_ac].rya01 != g_rya_t.rya01 OR
                  g_rya_t.rya01 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM rya_file
                       WHERE rya01 = g_rya[l_ac].rya01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_rya[l_ac].rya01 = g_rya_t.rya01
                       NEXT FIELD rya01
                   END IF
               END IF
            END IF
 
 
       AFTER FIELD rya03
           IF NOT cl_null(g_rya[l_ac].rya03) THEN
              CALL i111_rya03('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err('',g_errno,0) 
                 NEXT FIELD rya03
              END IF
          END IF
                                                  	
       AFTER FIELD ryaacti
          IF NOT cl_null(g_rya[l_ac].ryaacti) THEN
             IF g_rya[l_ac].ryaacti NOT MATCHES '[YN]' THEN
                LET g_rya[l_ac].ryaacti = g_rya_t.ryaacti
                NEXT FIELD ryaacti
             END IF
          END IF
      
        BEFORE DELETE
            IF g_rya_t.rya01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "rya01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_rya[l_ac].rya01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM rya_file WHERE rya01 = g_rya_t.rya01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rya_file",g_rya_t.rya01,"",SQLCA.sqlcode,"","",1)
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
              LET g_rya[l_ac].* = g_rya_t.*
              CLOSE i111_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_rya[l_ac].rya01,-263,0)
               LET g_rya[l_ac].* = g_rya_t.*
           ELSE
               UPDATE rya_file SET rya01=g_rya[l_ac].rya01,
                                   rya02=g_rya[l_ac].rya02,
                                   rya03=g_rya[l_ac].rya03,
                                   ryaacti=g_rya[l_ac].ryaacti,
                                   ryamodu=g_user,
                                   ryadate=g_today
                WHERE rya01 = g_rya_t.rya01 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rya_file",g_rya_t.rya01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
                  LET g_rya[l_ac].* = g_rya_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac    #FUN-D40030 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_rya[l_ac].* = g_rya_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_rya.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE i111_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac    #FUN-D40030 Add
           CLOSE i111_bcl
           COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(rya03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_geo"
                   LET g_qryparam.default1 = g_rya[l_ac].rya03
                   CALL cl_create_qry() RETURNING g_rya[l_ac].rya03
                   DISPLAY g_rya[l_ac].rya03 TO rya03
                   CALL i111_rya03('a')
                OTHERWISE
                   EXIT CASE
            END CASE
 
        ON ACTION CONTROLO
            IF INFIELD(rya01) AND l_ac > 1 THEN
                LET g_rya[l_ac].* = g_rya[l_ac-1].*
                NEXT FIELD rya01
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
    CLOSE i111_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i111_rya03(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_geoacti       LIKE geo_file.geoacti
 
    LET g_errno = ' '
    SELECT geo02,geoacti INTO g_rya[l_ac].rya03_desc,l_geoacti
        FROM geo_file
      WHERE geo01 = g_rya[l_ac].rya03
    CASE 
        WHEN SQLCA.SQLCODE = 100  
                            LET g_errno = 'art-003'
         WHEN l_geoacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i111_b_askkey()
 
   CLEAR FORM
   CALL g_rya.clear()
   CONSTRUCT g_wc2 ON rya01,rya02,rya03,ryaacti
         FROM s_rya[1].rya01,s_rya[1].rya02,s_rya[1].rya03,s_rya[1].ryaacti
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         ON ACTION controlp
             CASE WHEN INFIELD(rya03)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rya"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_rya[1].rya03            
                     CALL i111_rya03('a')
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ryauser', 'ryagrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
   CALL i111_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i111_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000
 
    #LET g_sql =
    #    "SELECT rya01,rya02,rya03,geo02,ryaacti",
    #    " FROM rya_file,OUTER geo_file",
    #    " WHERE rya03 = geo01 AND ", p_wc2 CLIPPED,
    #    " ORDER BY rya01"
    LET g_sql =                                                                                                                     
        "SELECT rya01,rya02,rya03,geo02,ryaacti",                                                                                   
#       " FROM rya_file, geo_file",  #FUN-9B0019
        " FROM rya_file LEFT OUTER JOIN geo_file ON rya03 = geo01 ",  #FUN-9B0019                                                                                          
#       " WHERE rya03 = geo01(+) AND ", p_wc2 CLIPPED,   #FUN-9B0019                                                                              
        " WHERE ", p_wc2 CLIPPED,   #FUN-9B0019                                                                              
        " ORDER BY rya01" 
    PREPARE i111_pb FROM g_sql
    DECLARE rya_curs CURSOR FOR i111_pb
 
    CALL g_rya.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rya_curs INTO g_rya[g_cnt].*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rya.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i111_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1
   
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rya TO s_rya.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i111_out()
    DEFINE l_cmd   LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN 
    END IF
    LET l_cmd='p_query "aooi111" "',g_wc2 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
END FUNCTION
#NO.FUN-870006---END---
 
#FUN-870100---begin
FUNCTION aooi111_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("rya01",TRUE)
        END IF
END FUNCTION
 
FUNCTION aooi111_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("rya01",FALSE)
        END IF
END FUNCTION
#FUN-870100--end
#FUN-9B0025--PASS NO.

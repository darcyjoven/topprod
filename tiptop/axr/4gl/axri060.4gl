# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: arti060.4gl
# Descriptions...: 款別對應銀行維護作業
# Date & Author..: No.FUN-9C0168 09/12/28 By lutingting   
# Modify.........: No:TQC-B20094 11/02/17 By yinhy 銀行編號欄位未給值，保存後重新查詢則新增的一筆資料無法顯示出
# Modify.........: No:FUN-D30032 13/04/02 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
     g_ooe          DYNAMIC ARRAY OF RECORD 
        ooe01       LIKE ooe_file.ooe01,  
        ooe02       LIKE ooe_file.ooe02,  
        ooe02_desc  LIKE nma_file.nma02   
                    END RECORD,
    g_ooe_t         RECORD                
        ooe01       LIKE ooe_file.ooe01,  
        ooe02       LIKE ooe_file.ooe02,  
        ooe02_desc  LIKE nma_file.nma02   
                    END RECORD,
     g_wc2,g_sql    STRING,  
    g_rec_b         LIKE type_file.num5,        
    l_ac            LIKE type_file.num5         
 
DEFINE g_forupd_sql STRING   
DEFINE   g_cnt           LIKE type_file.num10   
DEFINE   g_i             LIKE type_file.num5   
MAIN  
DEFINE p_row,p_col   LIKE type_file.num5  
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT    
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)   
         RETURNING g_time   
    LET p_row = 5 LET p_col = 22
    OPEN WINDOW i060_w AT p_row,p_col WITH FORM "axr/42f/axri060"  ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i060_b_fill(g_wc2)
    CALL i060_menu()
    CLOSE WINDOW i060_w              
      CALL  cl_used(g_prog,g_time,2) 
         RETURNING g_time  
END MAIN
 
FUNCTION i060_menu()
 
   WHILE TRUE
      CALL i060_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i060_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i060_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() THEN
               IF g_ooe[l_ac].ooe01 IS NOT NULL THEN
                  LET g_doc.column1 = "ooe01"
                  LET g_doc.value1 = g_ooe[l_ac].ooe01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ooe),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i060_q()
   CALL i060_b_askkey()
END FUNCTION
 
FUNCTION i060_b()
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
 
    LET g_forupd_sql = "SELECT ooe01,ooe02,'' FROM ooe_file",
                       " WHERE ooe01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i060_bcl CURSOR FROM g_forupd_sql    
 
    INPUT ARRAY g_ooe WITHOUT DEFAULTS FROM s_ooe.*
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
               CALL cl_set_comp_entry("ooe01",FALSE)
               LET g_ooe_t.* = g_ooe[l_ac].* 
 
               OPEN i060_bcl USING g_ooe_t.ooe01 
               IF STATUS THEN
                  CALL cl_err("OPEN i060_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE 
                  FETCH i060_bcl INTO g_ooe[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ooe_t.ooe01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               SELECT nma02  INTO g_ooe[l_ac].ooe02_desc FROM nma_file
                WHERE nma01 = g_ooe[l_ac].ooe02 
               CALL cl_show_fld_cont()  
            END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           CALL cl_set_comp_entry("ooe01",TRUE)
           INITIALIZE g_ooe[l_ac].* TO NULL  
           LET g_ooe_t.* = g_ooe[l_ac].* 
           CALL cl_show_fld_cont() 
           NEXT FIELD ooe01
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i060_bcl
              CANCEL INSERT
           END IF
           INSERT INTO ooe_file(ooe01,ooe02)
                         VALUES(g_ooe[l_ac].ooe01,g_ooe[l_ac].ooe02)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ooe_file",g_ooe[l_ac].ooe01,"",SQLCA.sqlcode,"","",1) 
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  
           END IF
 
        AFTER FIELD ooe01   
            IF NOT cl_null(g_ooe[l_ac].ooe01) THEN
               IF g_ooe[l_ac].ooe01 != g_ooe_t.ooe01 OR
                  g_ooe_t.ooe01 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM ooe_file
                       WHERE ooe01 = g_ooe[l_ac].ooe01
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ooe[l_ac].ooe01 = g_ooe_t.ooe01
                       NEXT FIELD ooe01
                   END IF
               END IF
            END IF
 
 
       AFTER FIELD ooe02
           IF NOT cl_null(g_ooe[l_ac].ooe02) THEN
              CALL i060_ooe02('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err('',g_errno,0) 
                 LET g_ooe[l_ac].ooe02 = g_ooe_t.ooe02
                 NEXT FIELD ooe02
              END IF
          END IF
                                                  	
      
        BEFORE DELETE  
            IF g_ooe_t.ooe01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                     CANCEL DELETE
                END IF
                INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
                LET g_doc.column1 = "ooe01"               #No.FUN-9B0098 10/02/24
                LET g_doc.value1 = g_ooe[l_ac].ooe01      #No.FUN-9B0098 10/02/24
                CALL cl_del_doc()                                              #No.FUN-9B0098 10/02/24
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM ooe_file WHERE ooe01 = g_ooe_t.ooe01
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ooe_file",g_ooe_t.ooe01,"",SQLCA.sqlcode,"","",1) 
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
              LET g_ooe[l_ac].* = g_ooe_t.*
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_ooe[l_ac].ooe01,-263,0)
               LET g_ooe[l_ac].* = g_ooe_t.*
           ELSE
               UPDATE ooe_file SET ooe01=g_ooe[l_ac].ooe01,
                                   ooe02=g_ooe[l_ac].ooe02
                WHERE ooe01 = g_ooe_t.ooe01 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","ooe_file",g_ooe_t.ooe01,"",SQLCA.sqlcode,"","",1)
                  LET g_ooe[l_ac].* = g_ooe_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30032 
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_ooe[l_ac].* = g_ooe_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_ooe.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--
              END IF
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30032 
           CLOSE i060_bcl
           COMMIT WORK
 
       ON ACTION controlp
           CASE WHEN INFIELD(ooe02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nma"
                   LET g_qryparam.default1 = g_ooe[l_ac].ooe02
                   CALL cl_create_qry() RETURNING g_ooe[l_ac].ooe02
                   DISPLAY g_ooe[l_ac].ooe02 TO ooe02
                   CALL i060_ooe02('a')
                OTHERWISE
                   EXIT CASE
            END CASE
 
        ON ACTION CONTROLO  
            IF INFIELD(ooe01) AND l_ac > 1 THEN
                LET g_ooe[l_ac].* = g_ooe[l_ac-1].*
                NEXT FIELD ooe01
            END IF
 
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
 
 
    CLOSE i060_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i060_ooe02(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1, 
    l_nmaacti       LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02 INTO g_ooe[l_ac].ooe02_desc,l_nmaacti
        FROM nma_file
        WHERE nma01 = g_ooe[l_ac].ooe02
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'art-589'
                            LET g_ooe[l_ac].ooe02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i060_b_askkey()
 
    CLEAR FORM
   CALL g_ooe.clear()
 
    CONSTRUCT g_wc2 ON ooe01,ooe02
         FROM s_ooe[1].ooe01,s_ooe[1].ooe02
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION controlp
             CASE WHEN INFIELD(ooe02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ooe02"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO s_ooe[1].ooe02            
                     CALL i060_ooe02('a')
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
 
    CALL i060_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i060_b_fill(p_wc2)            
DEFINE
    p_wc2           LIKE type_file.chr1000    
 
    LET g_sql =
        "SELECT ooe01,ooe02,nma02 ",
        #" FROM ooe_file,OUTER nma_file",                                #TQC-B20094 mark
        #" WHERE ooe02 = nma01 AND ", p_wc2 CLIPPED,                     #TQC-B20094 mark
        " FROM ooe_file LEFT OUTER  JOIN nma_file ON ooe02 = nma01 ",    #TQC-B20094
        " WHERE  ",p_wc2 CLIPPED,                                        #TQC-B20094
        " ORDER BY 1"
    PREPARE i060_pb FROM g_sql
    DECLARE ooe_curs CURSOR FOR i060_pb
 
    CALL g_ooe.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ooe_curs INTO g_ooe[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ooe.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i060_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ooe TO s_ooe.* ATTRIBUTE(COUNT=g_rec_b)
 
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
#FUN-9C0168

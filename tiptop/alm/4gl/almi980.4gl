# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: almi980.4gl
# Descriptions...: 扣減項目維護作業
# Date & Author..: No.FUN-960058 09/06/12 By destiny 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/27 By shiwuying
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960058--begin
DEFINE 
    g_argv1         LIKE azf_file.azf02,
    g_azf02         LIKE azf_file.azf02,
    g_azf02_t       LIKE azf_file.azf02,
    g_azf           DYNAMIC ARRAY OF RECORD    
        azf01       LIKE azf_file.azf01,   
        azf03       LIKE azf_file.azf03,
        azfacti     LIKE azf_file.azfacti  
                    END RECORD,
    g_azf_t         RECORD                
        azf01       LIKE azf_file.azf01,   
        azf03       LIKE azf_file.azf03, 
        azfacti     LIKE azf_file.azfacti
                    END RECORD,
     g_wc2,g_sql     string, 
    g_tit           LIKE type_file.chr20,    
    g_tit1          LIKE type_file.chr20,    
    g_rec_b         LIKE type_file.num5,    
    l_ac            LIKE type_file.num5      
DEFINE g_forupd_sql STRING   
DEFINE   g_cnt           LIKE type_file.num10    
DEFINE   g_i             LIKE type_file.num5    
DEFINE g_before_input_done   LIKE type_file.num5
 
MAIN
    OPTIONS                               
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
    DEFER INTERRUPT                        
 
   LET g_argv1   = ARG_VAL(1) 
   LET g_azf02   = '5'
   LET g_azf02_t = g_azf02
 
   LET g_tit = g_prog
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
 
   OPEN WINDOW i980_w WITH FORM "alm/42f/almi980"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_set_locale_frm_name("almi980")
   CALL cl_ui_init()
 
   DISPLAY g_azf02 TO azf02
   LET g_wc2 = " azf02 ='",g_azf02 CLIPPED,"' " 
 
   CALL i980_b_fill(g_wc2)
 
   CALL i980_menu()
 
   CLOSE WINDOW i980_w                
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i980_menu()
 
   WHILE TRUE
      CALL i980_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i980_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i980_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_azf02 IS NOT NULL THEN
                  LET g_doc.column1 = "azf02"
                  LET g_doc.value1 = g_azf02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_azf),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i980_q()
 
   CALL i980_b_askkey()
 
END FUNCTION
 
FUNCTION i980_b()
   DEFINE l_ac_t          LIKE type_file.num5,    
          l_n             LIKE type_file.num5,     
          l_lock_sw       LIKE type_file.chr1,    
          p_cmd           LIKE type_file.chr1,    
          l_allow_insert  LIKE type_file.num5,    
          l_allow_delete  LIKE type_file.num5    
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
   LET g_action_choice = ""
 
 
   LET g_forupd_sql = " SELECT azf01,azf03,azfacti",    
                      " FROM azf_file ",   
                      " WHERE azf02= ? AND azf01= ? FOR UPDATE  "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i980_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_azf WITHOUT DEFAULTS FROM s_azf.*
         ATTRIBUTE(COUNT=g_rec_b, MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac      = ARR_CURR()
         LET l_n       = ARR_COUNT()
         LET l_lock_sw = 'N'          
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_before_input_done = FALSE                                    
            CALL i980_set_entry(p_cmd)                                         
            CALL i980_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE            
            LET g_azf_t.* = g_azf[l_ac].* 
            OPEN i980_bcl USING g_azf02,g_azf_t.azf01
            IF STATUS THEN
               CALL cl_err("OPEN i980_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE 
               FETCH i980_bcl INTO g_azf[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_azf_t.azf01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL cl_show_fld_cont()    
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         LET g_before_input_done = FALSE                                    
         CALL i980_set_entry(p_cmd)                                         
         CALL i980_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         INITIALIZE g_azf[l_ac].* TO NULL     
         LET g_azf[l_ac].azfacti='Y'
         LET g_azf_t.* = g_azf[l_ac].*      
         CALL cl_show_fld_cont()   
         NEXT FIELD azf01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO azf_file(azf01,azf02,azf03,azfacti,azforiu,azforig)   
                       VALUES(g_azf[l_ac].azf01,g_azf02,g_azf[l_ac].azf03,g_azf[l_ac].azfacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","azf_file",g_azf[l_ac].azf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD azf01                       
         IF NOT cl_null(g_azf[l_ac].azf01) THEN
            IF g_azf[l_ac].azf01 != g_azf_t.azf01 
               OR g_azf_t.azf01 IS NULL THEN
               SELECT count(*) INTO l_n FROM azf_file
                WHERE azf01 = g_azf[l_ac].azf01
                  AND azf02 = g_azf02
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_azf[l_ac].azf01 = g_azf_t.azf01
                  NEXT FIELD azf01
               END IF
            END IF
         END IF
         
      AFTER FIELD azfacti
          IF NOT cl_null(g_azf[l_ac].azfacti) THEN
             IF g_azf[l_ac].azfacti NOT MATCHES '[YN]' THEN 
                LET g_azf[l_ac].azfacti = g_azf_t.azfacti
                NEXT FIELD azfacti
             END IF
          END IF
 
      BEFORE DELETE                           
         IF g_azf_t.azf01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM azf_file WHERE azf01 = g_azf_t.azf01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","azf_file",g_azf_t.azf01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_azf[l_ac].* = g_azf_t.*
            CLOSE i980_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_azf[l_ac].azf01,-263,1)
            LET g_azf[l_ac].* = g_azf_t.*
         ELSE
            UPDATE azf_file SET 
                                azf03=g_azf[l_ac].azf03, 
                                azfacti=g_azf[l_ac].azfacti
             WHERE azf02 = g_azf02
               AND azf01 = g_azf_t.azf01 
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","azf_file",g_azf02,g_azf_t.azf01,SQLCA.sqlcode,"","",1)  #No.FUN-660131
               LET g_azf[l_ac].* = g_azf_t.*
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
               LET g_azf[l_ac].* = g_azf_t.*
            END IF
            CLOSE i980_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i980_bcl
         COMMIT WORK
 
 
      ON ACTION CONTROLO                       
         IF INFIELD(azf01) AND l_ac > 1 THEN
            LET g_azf[l_ac].* = g_azf[l_ac-1].*
            NEXT FIELD azf01
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
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      #No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
      #No.FUN-6B0030-----End------------------     
 
   END INPUT
 
   CLOSE i980_bcl
 
   COMMIT WORK
 
END FUNCTION
 
 
FUNCTION i980_b_askkey()
 
    CLEAR FORM
    CALL g_azf.clear()
    DISPLAY g_azf02 TO azf02
 
    CONSTRUCT g_wc2 ON azf01,azf03,azfacti
         FROM s_azf[1].azf01,s_azf[1].azf03,s_azf[1].azfacti
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        #FUN-510041 add 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(azf01)      
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form ="q_azf01e" 
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO azf01
                NEXT FIELD azf01
              OTHERWISE
           END CASE
 
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
       
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
       
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
    
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select() 
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('azfuser', 'azfgrup') #FUN-980030
 
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       RETURN 
       LET g_wc2 = NULL
       LET g_rec_b =0 
    END IF
 
    LET g_wc2 =g_wc2 CLIPPED, "  AND azf02 ='",g_azf02 CLIPPED,"' " 
 
    CALL i980_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i980_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2   LIKE type_file.chr1000  #No.FUN-680102 VARCHAR(200)
 
   LET g_sql = "SELECT azf01,azf03,azfacti",
               "  FROM azf_file ",
               " WHERE ", p_wc2 CLIPPED,                    
               " ORDER BY azf01"
   PREPARE i980_pb FROM g_sql
   DECLARE azf_curs CURSOR FOR i980_pb
 
   CALL g_azf.clear()
 
   LET g_cnt = 1
   MESSAGE "Searching!" 
   FOREACH azf_curs INTO g_azf[g_cnt].*  
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
 
   CALL g_azf.deleteElement(g_cnt)
   MESSAGE ""
 
   LET g_rec_b = g_cnt-1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
 
FUNCTION i980_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_azf TO s_azf.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                  
 
#No.FUN-6B0030------Begin--------------                                                                                             
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------     
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
#     ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
  
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   #No.FUN-4B0020
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-598067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-598067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i980_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("azf01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i980_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1
                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("azf01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION 

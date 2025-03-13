# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: almi890.4gl
# Descriptions...: 競爭對手維護
# Date & Author..: FUN-960081 08/07/01 By dxfwo 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30118 10/03/17 By Smapmin 輸入狀況時,競爭對手編碼的欄位不要顯示開窗
# Modify.........: No:FUN-A60010 10/07/14 By huangtao  移除lmi 相關的欄位
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960081 
DEFINE 
     g_lse           DYNAMIC ARRAY OF RECORD    
        lse01       LIKE lse_file.lse01,   
        lse02       LIKE lse_file.lse02,   
        lse03       LIKE lse_file.lse03,
        lse04       LIKE lse_file.lse04    
                    END RECORD,
     g_lse_t         RECORD              
        lse01       LIKE lse_file.lse01,   
        lse02       LIKE lse_file.lse02,   
        lse03       LIKE lse_file.lse03,   
        lse04       LIKE lse_file.lse04
                    END RECORD,
    g_wc2,g_sql     LIKE type_file.chr1000,         
    g_rec_b         LIKE type_file.num5,       
    l_ac            LIKE type_file.num5         
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL       
DEFINE g_cnt        LIKE type_file.num10    
DEFINE g_i          LIKE type_file.num5     #count/index for any purpose        
DEFINE g_before_input_done   LIKE type_file.num5        
 
 
MAIN
    OPTIONS                                
        INPUT NO WRAP
    DEFER INTERRUPT                        
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
 
    OPEN WINDOW i890_w WITH FORM "alm/42f/almi890"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i890_b_fill(g_wc2)
    CALL i890_menu()
    CLOSE WINDOW i890_w 
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i890_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i890_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i890_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i890_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i890_out()                                        
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lse[l_ac].lse01 IS NOT NULL THEN
                  LET g_doc.column1 = "lse01"
                  LET g_doc.value1 = g_lse[l_ac].lse01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lse),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i890_q()
   CALL i890_b_askkey()
END FUNCTION
 
FUNCTION i890_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     
   l_n             LIKE type_file.num5,     
   l_n1            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,       
   p_cmd           LIKE type_file.chr1,       
   l_allow_insert  LIKE type_file.chr1,
   l_allow_delete  LIKE type_file.chr1 
  #l_lmi03         LIKE lmi_file.lmi03 #No.FUN-A60010 Mark
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lse01,lse02,lse03,lse04",  
                      "  FROM lse_file WHERE lse01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i890_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lse WITHOUT DEFAULTS FROM s_lse.*
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
             LET g_before_input_done = FALSE                                    
             CALL i890_set_entry(p_cmd)                                         
             CALL i890_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_lse_t.* = g_lse[l_ac].*  #BACKUP
             OPEN i890_bcl USING g_lse_t.lse01
             IF STATUS THEN
                CALL cl_err("OPEN i890_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i890_bcl INTO g_lse[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lse_t.lse01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i890_set_entry(p_cmd)                                            
          CALL i890_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lse[l_ac].* TO NULL   
          LET g_lse[l_ac].lse04 = 'Y'       
          LET g_lse_t.* = g_lse[l_ac].* 
          CALL cl_show_fld_cont()    
          NEXT FIELD lse01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i890_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lse_file(lse01,lse02,lse03,lse04)   
          VALUES(g_lse[l_ac].lse01,g_lse[l_ac].lse02,g_lse[l_ac].lse03,g_lse[l_ac].lse04)  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lse_file",g_lse[l_ac].lse01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD lse01   
          IF NOT cl_null(g_lse[l_ac].lse01) THEN
             IF g_lse[l_ac].lse01 != g_lse_t.lse01 OR
                g_lse_t.lse01 IS NULL THEN
                SELECT count(*) INTO l_n FROM lse_file
                 WHERE lse01 = g_lse[l_ac].lse01
#                  AND plant_code=g_plant_code 
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_lse[l_ac].lse01 = g_lse_t.lse01
                   NEXT FIELD lse01
                END IF
             END IF
          END IF            
          
       AFTER FIELD lse04
          IF NOT cl_null(g_lse[l_ac].lse04) THEN
             IF g_lse[l_ac].lse04 NOT MATCHES '[YN]' THEN 
                LET g_lse[l_ac].lse04 = g_lse_t.lse04
                NEXT FIELD lse04
             END IF
          END IF
          IF NOT cl_null(g_lse[l_ac].lse04) THEN                                                                                    
             IF g_lse[l_ac].lse04 != g_lse_t.lse04 THEN                                                                             
                SELECT count(*) INTO l_n1 FROM lsf_file                                                                             
                  WHERE lsf01= g_lse[l_ac].lse01                                                                                    
#                   AND lsf_file.plant_code=g_plant_code                                                                                    
                IF l_n1 > 0 THEN                                                                                                    
                   CALL cl_err('','alm-920',1)                                                                                      
                   LET g_lse[l_ac].lse04 = g_lse_t.lse04                                                                            
                   NEXT FIELD lse04                                                                                                 
                END IF                                                                                                              
              END IF                                                                                                                
          END IF 
       		
       BEFORE DELETE   
          IF g_lse_t.lse01 IS NOT NULL THEN
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             SELECT COUNT(*) INTO l_n FROM lsf_file 
               WHERE lsf01=g_lse[l_ac].lse01
             IF l_n >0 THEN 
                CALL cl_err('','alm-920',1)
                CANCEL DELETE
             END IF 
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF             
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lse01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lse[l_ac].lse01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                                        #No.FUN-9B0098 10/02/24
             DELETE FROM lse_file WHERE lse01 = g_lse_t.lse01 
#            AND plant_code=g_plant_code
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lse_file",g_lse_t.lse01,"",SQLCA.sqlcode,"","",1) 
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
             LET g_lse[l_ac].* = g_lse_t.*
             CLOSE i890_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lse[l_ac].lse01,-263,0)
             LET g_lse[l_ac].* = g_lse_t.*
          ELSE
             UPDATE lse_file SET lse01=g_lse[l_ac].lse01,
                                 lse02=g_lse[l_ac].lse02,
                                 lse03=g_lse[l_ac].lse03,
                                 lse04=g_lse[l_ac].lse04
              WHERE lse01 = g_lse_t.lse01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lse_file",g_lse_t.lse01,"",SQLCA.sqlcode,"","",1) 
                LET g_lse[l_ac].* = g_lse_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()  
         #LET l_ac_t = l_ac      #FUN-D30033 Mark
 
          IF INT_FLAG THEN 
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_lse[l_ac].* = g_lse_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lse.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE i890_bcl
             ROLLBACK WORK  
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac      #FUN-D30033 Add
          CLOSE i890_bcl  
          COMMIT WORK
          
       #ON ACTION CONTROLP   #MOD-A30118
           
       ON ACTION CONTROLO     
          IF INFIELD(lse01) AND l_ac > 1 THEN
             LET g_lse[l_ac].* = g_lse[l_ac-1].*
             NEXT FIELD lse01
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
 
   CLOSE i890_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i890_b_askkey()
 
   CLEAR FORM
   CALL g_lse.clear()
   CONSTRUCT g_wc2 ON lse01,lse02,lse03,lse04
        FROM s_lse[1].lse01,s_lse[1].lse02,s_lse[1].lse03,s_lse[1].lse04
 
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
         
      ON ACTION CONTROLP
          CASE
            WHEN INFIELD(lse01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lse01"
                 LET g_qryparam.state='c'
#                LET g_qryparam.arg1 = g_plant_code
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lse01
                 NEXT FIELD lse01
 
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
      LET g_rec_b =0 
      RETURN
   END IF
 
   CALL i890_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i890_b_fill(p_wc2)              
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lse01,lse02,lse03,lse04",   
        " FROM lse_file ",
        " WHERE ", g_wc2 CLIPPED,    
        " ORDER BY lse01"
    PREPARE i890_pb FROM g_sql
    DECLARE lse_curs CURSOR FOR i890_pb
 
    CALL g_lse.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lse_curs INTO g_lse[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lse.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i890_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lse TO s_lse.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
 
FUNCTION i890_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "almi890" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd) 
    RETURN
END FUNCTION   
                                                 
FUNCTION i890_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                             
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lse01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i890_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lse01",FALSE)                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                            

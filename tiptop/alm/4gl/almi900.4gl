# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: almi900.4gl
# Descriptions...: 競爭對手媒體追蹤
# Date & Author..: FUN-960081 08/08/06 By dxfwo 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A60019 10/06/07 by houlia 輸入重負資料時，清空名稱欄位
# Modify.........: No:FUN-A60010 10/07/14 By huangtao  移除lmi 相關的欄位
# Modify.........: No:FUN-D30033 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#No.FUN-960081 
DEFINE 
     g_lsf           DYNAMIC ARRAY OF RECORD    
        lsf01       LIKE lsf_file.lsf01,
        lse02       LIKE lse_file.lse02,  
        lsf02       LIKE lsf_file.lsf02,
        toa02       LIKE toa_file.toa02,    
        lsf03       LIKE lsf_file.lsf03,
        lsf04       LIKE lsf_file.lsf04,
        lsf05       LIKE lsf_file.lsf05,
        lsf06       LIKE lsf_file.lsf06,
        lsf07       LIKE lsf_file.lsf07,
        lsf08       LIKE lsf_file.lsf08,
        lsf09       LIKE lsf_file.lsf09
                    END RECORD,
     g_lsf_t         RECORD              
        lsf01       LIKE lsf_file.lsf01,
        lse02       LIKE lse_file.lse02,  
        lsf02       LIKE lsf_file.lsf02,
        toa02       LIKE toa_file.toa02,    
        lsf03       LIKE lsf_file.lsf03,
        lsf04       LIKE lsf_file.lsf04,
        lsf05       LIKE lsf_file.lsf05,
        lsf06       LIKE lsf_file.lsf06,
        lsf07       LIKE lsf_file.lsf07,
        lsf08       LIKE lsf_file.lsf08,
        lsf09       LIKE lsf_file.lsf09
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
 
    OPEN WINDOW i900_w WITH FORM "alm/42f/almi900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
 
    LET g_wc2 = '1=1' CALL i900_b_fill(g_wc2)
    CALL i900_menu()
    CLOSE WINDOW i900_w  
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i900_menu()
 DEFINE l_cmd   LIKE type_file.chr1000                                   
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i900_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i900_b()
            ELSE 
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i900_out()                                        
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_lsf[l_ac].lsf01 IS NOT NULL THEN
                  LET g_doc.column1 = "lsf01"
                  LET g_doc.value1 = g_lsf[l_ac].lsf01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_lsf),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i900_q()
   CALL i900_b_askkey()
END FUNCTION
 
FUNCTION i900_b()
DEFINE
   l_ac_t          LIKE type_file.num5,     
   l_n             LIKE type_file.num5,     
   l_n1            LIKE type_file.num5,
   l_lock_sw       LIKE type_file.chr1,       
   p_cmd           LIKE type_file.chr1,       
   l_allow_insert  LIKE type_file.chr1,
   l_allow_delete  LIKE type_file.chr1
#   l_lmi03         LIKE lmi_file.lmi03                 #FUN-A60010
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
   LET g_action_choice = ""
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   LET g_forupd_sql = "SELECT lsf01,'',lsf02,'',lsf03,lsf04,lsf05,lsf06,lsf07,lsf08,lsf09",  
                      "  FROM lsf_file WHERE  lsf01= ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_lsf WITHOUT DEFAULTS FROM s_lsf.*
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
             CALL i900_set_entry(p_cmd)                                         
             CALL i900_set_no_entry(p_cmd)                                      
             LET g_before_input_done = TRUE                                             
             LET g_lsf_t.* = g_lsf[l_ac].*  #BACKUP
             OPEN i900_bcl USING g_lsf_t.lsf01
             IF STATUS THEN
                CALL cl_err("OPEN i900_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH i900_bcl INTO g_lsf[l_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_lsf_t.lsf01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE 
                   CALL i900_lsf01('d')
                   CALL i900_lsf02('d')	
                END IF
             END IF
             CALL cl_show_fld_cont()     
          END IF
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'                                              
          LET g_before_input_done = FALSE                                       
          CALL i900_set_entry(p_cmd)                                            
          CALL i900_set_no_entry(p_cmd)                                         
          LET g_before_input_done = TRUE                                        
          INITIALIZE g_lsf[l_ac].* TO NULL 
          LET g_lsf[l_ac].lsf06 = '0'  
          LET g_lsf[l_ac].lsf07 = '0'       
          LET g_lsf_t.* = g_lsf[l_ac].* 
          CALL cl_show_fld_cont()    
          NEXT FIELD lsf01
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CLOSE i900_bcl
             CANCEL INSERT
          END IF
          INSERT INTO lsf_file(lsf01,lsf02,lsf03,lsf04,lsf05,lsf06,lsf07,lsf08,lsf09)   
          VALUES(g_lsf[l_ac].lsf01,g_lsf[l_ac].lsf02,g_lsf[l_ac].lsf03,g_lsf[l_ac].lsf04,
                 g_lsf[l_ac].lsf05,g_lsf[l_ac].lsf06,g_lsf[l_ac].lsf07,g_lsf[l_ac].lsf08,
                 g_lsf[l_ac].lsf09)  
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","lsf_file",g_lsf[l_ac].lsf01,"",SQLCA.sqlcode,"","",1)  
             CANCEL INSERT
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
          END IF
 
       AFTER FIELD lsf01   
          IF NOT cl_null(g_lsf[l_ac].lsf01) THEN
             IF g_lsf[l_ac].lsf01 != g_lsf_t.lsf01 OR
                g_lsf_t.lsf01 IS NULL THEN
                CALL i900_lsf01('a')
                SELECT count(*) INTO l_n FROM lsf_file
                 WHERE lsf01 = g_lsf[l_ac].lsf01
#                  AND plant_code=g_plant_code 
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_lsf[l_ac].lsf01 = g_lsf_t.lsf01
#TQC-A60019  --add
                  DISPLAY '' TO FORMONLY.lse02
#TQC-A60019  --end
                   NEXT FIELD lsf01
                END IF
                SELECT count(*) INTO l_n FROM lse_file
                 WHERE lse01 = g_lsf[l_ac].lsf01
#                  AND plant_code=g_plant_code
                   AND lse04 = 'Y'
                IF l_n = 0 THEN
                   CALL cl_err(g_lsf[l_ac].lsf01,'alm-009',0)
                   LET g_lsf[l_ac].lsf01 = g_lsf_t.lsf01
                   NEXT FIELD lsf01 
                END IF                  
             END IF
          END IF            
          
       AFTER FIELD lsf02
          IF cl_null(g_lsf[l_ac].lsf02) THEN
             CALL cl_err(g_lsf[l_ac].lsf02,'alm-917',0)
             NEXT FIELD lsf02 
          END IF   
          IF NOT cl_null(g_lsf[l_ac].lsf02) THEN                                                                                    
             IF g_lsf[l_ac].lsf02 != g_lsf_t.lsf02 OR
                g_lsf_t.lsf02 IS NULL THEN 
                CALL i900_lsf02('a')                                                                           
                SELECT count(*) INTO l_n FROM toa_file
                 WHERE toa01 = g_lsf[l_ac].lsf02
                IF l_n = 0 THEN
                   CALL cl_err(g_lsf[l_ac].lsf02,'alm-009',0)
                   LET g_lsf[l_ac].lsf02 = g_lsf_t.lsf02
                   NEXT FIELD lsf02 
                END IF                                                                                                               
              END IF                                                                                                                  
          END IF 
 
      AFTER FIELD lsf06
        IF NOT cl_null(g_lsf[l_ac].lsf06) THEN
           IF g_lsf[l_ac].lsf06<0 THEN
             CALL cl_err('','alm-061',0)
             NEXT FIELD lsf06
           END IF
        END IF
        DISPLAY BY NAME g_lsf[l_ac].lsf06
 
      AFTER FIELD lsf03
        IF cl_null(g_lsf[l_ac].lsf03) THEN
             CALL cl_err('','alm-917',0)
             NEXT FIELD lsf03
        END IF
 
      AFTER FIELD lsf07
        IF NOT cl_null(g_lsf[l_ac].lsf07) THEN
           IF g_lsf[l_ac].lsf07<0 THEN
             CALL cl_err('','alm-061',0)
             NEXT FIELD lsf07
           END IF
        END IF
        DISPLAY BY NAME g_lsf[l_ac].lsf07
       		
       BEFORE DELETE   
          IF g_lsf_t.lsf01 IS NOT NULL THEN
             IF NOT cl_delete() THEN
                CANCEL DELETE
             END IF
             INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
             LET g_doc.column1 = "lsf01"               #No.FUN-9B0098 10/02/24
             LET g_doc.value1 = g_lsf[l_ac].lsf01      #No.FUN-9B0098 10/02/24
             CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM lsf_file WHERE lsf01 = g_lsf_t.lsf01 
#             AND plant_code=g_plant_code
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","lsf_file",g_lsf_t.lsf01,"",SQLCA.sqlcode,"","",1) 
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
             LET g_lsf[l_ac].* = g_lsf_t.*
             CLOSE i900_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
 
          IF l_lock_sw="Y" THEN
             CALL cl_err(g_lsf[l_ac].lsf01,-263,0)
             LET g_lsf[l_ac].* = g_lsf_t.*
          ELSE 
             UPDATE lsf_file SET lsf01=g_lsf[l_ac].lsf01,
                                 lsf02=g_lsf[l_ac].lsf02,
                                 lsf03=g_lsf[l_ac].lsf03,
                                 lsf04=g_lsf[l_ac].lsf04,
                                 lsf05=g_lsf[l_ac].lsf05,
                                 lsf06=g_lsf[l_ac].lsf06,
                                 lsf07=g_lsf[l_ac].lsf07,
                                 lsf08=g_lsf[l_ac].lsf08,
                                 lsf09=g_lsf[l_ac].lsf09
              WHERE lsf01 = g_lsf_t.lsf01 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","lsf_file",g_lsf_t.lsf01,"",SQLCA.sqlcode,"","",1) 
                LET g_lsf[l_ac].* = g_lsf_t.*
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
                LET g_lsf[l_ac].* = g_lsf_t.*
             #FUN-D30033--add--str--
             ELSE
                CALL g_lsf.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30033--add--end--
             END IF
             CLOSE i900_bcl
             ROLLBACK WORK  
             EXIT INPUT
          END IF
 
          LET l_ac_t = l_ac      #FUN-D30033 Add
          CLOSE i900_bcl  
          COMMIT WORK
          
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(lsf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lse01"
                 LET g_qryparam.default1 = g_lsf[l_ac].lsf01
                 CALL cl_create_qry() RETURNING g_lsf[l_ac].lsf01
                 DISPLAY BY NAME g_lsf[l_ac].lsf01
                 CALL i900_lsf01('d')
                 NEXT FIELD lsf01      
                 
              WHEN INFIELD(lsf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_toa_1"
                 LET g_qryparam.default1 = g_lsf[l_ac].lsf02
                 CALL cl_create_qry() RETURNING g_lsf[l_ac].lsf02
                 DISPLAY BY NAME g_lsf[l_ac].lsf02
                 CALL i900_lsf02('d')
                 NEXT FIELD lsf02     
                                  
           END CASE       
       
           
       ON ACTION CONTROLO     
          IF INFIELD(lsf01) AND l_ac > 1 THEN
             LET g_lsf[l_ac].* = g_lsf[l_ac-1].*
             NEXT FIELD lsf01
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
 
   CLOSE i900_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i900_b_askkey()
 
   CLEAR FORM
   CALL g_lsf.clear()
   CONSTRUCT g_wc2 ON lsf01,lsf02,lsf03,lsf04,lsf05,lsf06,lsf07,lsf08,lsf09
        FROM s_lsf[1].lsf01,s_lsf[1].lsf02,s_lsf[1].lsf03,s_lsf[1].lsf04,
             s_lsf[1].lsf05,s_lsf[1].lsf06,s_lsf[1].lsf07,s_lsf[1].lsf08,
             s_lsf[1].lsf09
 
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
            WHEN INFIELD(lsf01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lsf01"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsf01
                 NEXT FIELD lsf01
 
            WHEN INFIELD(lsf02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_lsf02"
                 LET g_qryparam.state='c'
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO lsf02
                 NEXT FIELD lsf02
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
 
   CALL i900_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i900_b_fill(p_wc2)              
DEFINE
    p_wc2           LIKE type_file.chr1000      
 
    LET g_sql =
        "SELECT lsf01,'',lsf02,'',lsf03,lsf04,lsf05,lsf06,lsf07,lsf08,lsf09",   
        " FROM lsf_file ",
        " WHERE ", p_wc2 CLIPPED, 
#       " AND plant_code = '",g_plant_code,"'",   
        " ORDER BY lsf01"
    PREPARE i900_pb FROM g_sql
    DECLARE lsf_curs CURSOR FOR i900_pb
 
    CALL g_lsf.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH lsf_curs INTO g_lsf[g_cnt].* 
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF  
       SELECT lse02 INTO g_lsf[g_cnt].lse02 FROM lse_file
       WHERE lse01 = g_lsf[g_cnt].lsf01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("sel","lse_file",g_lsf[g_cnt].lse02,"",SQLCA.sqlcode,"","",1)
          LET g_lsf[g_cnt].lse02 = NULL
       END IF        
       SELECT toa02 INTO g_lsf[g_cnt].toa02 FROM toa_file
       WHERE  toa01 = g_lsf[g_cnt].lsf02                           
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_lsf.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_lsf TO s_lsf.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
FUNCTION i900_out()
DEFINE l_cmd LIKE type_file.chr1000
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
       RETURN
    END IF
    LET l_cmd = 'p_query "almi900" "',g_wc2 CLIPPED,'"'                                                                               
    CALL cl_cmdrun(l_cmd) 
    RETURN
END FUNCTION   
                                                 
FUNCTION i900_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1              
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("lsf01",TRUE)                                       
   END IF                                                                       
                                                                                
END FUNCTION                                                                    
                                                                                
FUNCTION i900_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("lsf01",FALSE )                                      
   END IF                                                                       
                                                                                
END FUNCTION                                                                            
 
FUNCTION i900_lsf01(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_lse02      LIKE lse_file.lse02,
   l_lse04      LIKE lse_file.lse04 
 
   LET g_errno=''
   SELECT lse02,lse04
     INTO l_lse02,l_lse04
     FROM lse_file
    WHERE lse01=g_lsf[l_ac].lsf01 
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_lse02=NULL
       WHEN l_lse04='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      LET g_lsf[l_ac].lse02 = l_lse02
      DISPLAY BY NAME g_lsf[l_ac].lse02
   END IF
END FUNCTION
 
FUNCTION i900_lsf02(p_cmd)
DEFINE
   p_cmd        VARCHAR(01),
   l_toa02      LIKE toa_file.toa02,
   l_toaacti    LIKE toa_file.toaacti
 
   LET g_errno=''
   SELECT toa02,toaacti
     INTO l_toa02,l_toaacti
     FROM toa_file
    WHERE toa01=g_lsf[l_ac].lsf02
      AND toaacti = 'Y'    
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_toa02=NULL
       WHEN l_toaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      LET g_lsf[l_ac].toa02 = l_toa02
      DISPLAY BY NAME g_lsf[l_ac].toa02
   END IF
END FUNCTION

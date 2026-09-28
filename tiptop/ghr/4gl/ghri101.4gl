# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri101.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hrad           DYNAMIC ARRAY OF RECORD    
        hrad01       LIKE hrad_file.hrad01,
        hrad01_1     LIKE hrag_file.hrag07,     
        hrad02       LIKE hrad_file.hrad02,   
        hrad03       LIKE hrad_file.hrad03,  
        hrad04       LIKE hrad_file.hrad04, 
        hrad05       LIKE hrad_file.hrad05,  
        hradacti     LIKE hrad_file.hradacti   
                    END RECORD,
    g_hrad_t         RECORD                 
        hrad01       LIKE hrad_file.hrad01,
        hrad01_1     LIKE hrag_file.hrag07,     
        hrad02       LIKE hrad_file.hrad02,   
        hrad03       LIKE hrad_file.hrad03,  
        hrad04       LIKE hrad_file.hrad04, 
        hrad05       LIKE hrad_file.hrad05,  
        hradacti     LIKE hrad_file.hradacti 
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5                 
 
DEFINE g_forupd_sql STRING     
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING

MAIN

    DEFINE p_row,p_col   LIKE type_file.num5    
 
    OPTIONS                              
        INPUT NO WRAP
    DEFER INTERRUPT                      
 
  
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       
         RETURNING g_time    
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i101_w AT p_row,p_col WITH FORM "ghr/42f/ghri101"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i101_b_fill(g_wc2)
    CALL i101_menu()
    CLOSE WINDOW i101_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i101_b()
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
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrad[l_ac].hrad01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrad01"
                  LET g_doc.value1 = g_hrad[l_ac].hrad01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrad),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i101_q()
   CALL i101_b_askkey()
END FUNCTION
	
FUNCTION i101_b()
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
 
    LET g_forupd_sql = "SELECT hrad01,'',hrad02,hrad03,hrad04,hrad05,hradacti",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hrad_file WHERE hrad01=? AND hrad02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrad WITHOUT DEFAULTS FROM s_hrad.*
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
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end              
           LET g_hrad_t.* = g_hrad[l_ac].*  #BACKUP
           OPEN i101_bcl USING g_hrad_t.hrad01,g_hrad_t.hrad02
           IF STATUS THEN
              CALL cl_err("OPEN i101_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i101_bcl INTO g_hrad[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrad_t.hrad01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              SELECT hrag07 INTO g_hrad[l_ac].hrad01_1 FROM hrag_file WHERE hrag01='312'
                                                                        AND hrag06=g_hrad[l_ac].hrad01
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           CALL cl_set_comp_entry("hrad04",FALSE)
           IF g_hrad[l_ac].hrad04='Y' THEN
              CALL cl_set_comp_entry("hrad01,hrad02,hrad05,hradacti",FALSE)
           ELSE
              CALL cl_set_comp_entry("hrad01,hrad02,hrad05,hradacti",TRUE)
           END IF
        ELSE
           CALL cl_set_comp_entry("hrad04",TRUE)
           CALL cl_set_comp_entry("hrad01,hrad02,hrad05,hradacti",TRUE)   
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hrad[l_ac].* TO NULL      #900423  
         LET g_hrad[l_ac].hradacti = 'Y'       #Body default
         LET g_hrad[l_ac].hrad04 = 'N'
         LET g_hrad_t.* = g_hrad[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         CALL cl_set_comp_entry("hrad04",TRUE)
         CALL cl_set_comp_entry("hrad01,hrad02,hrad05,hradacti",TRUE)
         NEXT FIELD hrad01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i101_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hrad_file(hrad01,hrad02,hrad03,hrad04,hrad05,                          #FUN-A30097
                              hradacti,hraduser,hraddate,hradgrup,hradoriu,hradorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrad[l_ac].hrad01,g_hrad[l_ac].hrad02,
               g_hrad[l_ac].hrad03,g_hrad[l_ac].hrad04,                      #FUN-A30097                                        #FUN-A80148--mark--
               g_hrad[l_ac].hrad05,                      #FUN-A80148--mod-- 
               g_hrad[l_ac].hradacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrad_file",g_hrad[l_ac].hrad01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hrad01                        
       IF NOT cl_null(g_hrad[l_ac].hrad01) THEN 
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='312'
                                                    AND hrag06=g_hrad[l_ac].hrad01 
          IF l_n=0 THEN
             CALL cl_err('无此员工状态类型编码,请检查!','',0)
             NEXT FIELD hrad01
          END IF

     	  IF g_hrad[l_ac].hrad01 != g_hrad_t.hrad01 OR
             g_hrad_t.hrad01 IS NULL THEN
             IF NOT cl_null(g_hrad[l_ac].hrad02) THEN
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrad_file
                 WHERE hrad01 = g_hrad[l_ac].hrad01
                   AND hrad02 = g_hrad[l_ac].hrad02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_hrad[l_ac].hrad01 = g_hrad_t.hrad01
                   NEXT FIELD hrad01
                END IF
             END IF
          END IF 
          SELECT hrag07 INTO g_hrad[l_ac].hrad01_1 FROM hrag_file WHERE hrag01='312'
                                                                    AND hrag06=g_hrad[l_ac].hrad01
          DISPLAY BY NAME g_hrad[l_ac].hrad01_1                                            	
       END IF
       	
    AFTER FIELD hrad02
       IF NOT cl_null(g_hrad[l_ac].hrad02) THEN
          IF g_hrad[l_ac].hrad02 != g_hrad_t.hrad02 OR
             g_hrad_t.hrad02 IS NULL THEN
             IF NOT cl_null(g_hrad[l_ac].hrad01) THEN
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrad_file
                 WHERE hrad01 = g_hrad[l_ac].hrad01
                   AND hrad02 = g_hrad[l_ac].hrad02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_hrad[l_ac].hrad02 = g_hrad_t.hrad02
                   NEXT FIELD hrad02
                END IF
             END IF
          END IF     
       END IF
       	
    AFTER FIELD hrad04                        
       IF NOT cl_null(g_hrad[l_ac].hrad04) THEN
          IF g_hrad[l_ac].hrad04 NOT MATCHES '[YN]' THEN 
             LET g_hrad[l_ac].hrad04 = g_hrad_t.hrad04
             NEXT FIELD hrad04
          END IF
       END IF
   
    AFTER FIELD hradacti
       IF NOT cl_null(g_hrad[l_ac].hradacti) THEN
          IF g_hrad[l_ac].hradacti NOT MATCHES '[YN]' THEN 
             LET g_hrad[l_ac].hradacti = g_hrad_t.hradacti
             NEXT FIELD hradacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hrad_t.hrad01 IS NOT NULL AND g_hrad_t.hrad02 IS NOT NULL THEN
        IF g_hrad_t.hrad04='N' THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrad01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrad[l_ac].hrad01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrad_file WHERE hrad01 = g_hrad_t.hrad01
                                  AND hrad02 = g_hrad_t.hrad02
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrad_file",g_hrad_t.hrad01,g_hrad_t.hrad02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
             LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
        ELSE
           CALL cl_err('hrad04为Y,不可删除','!',0)
           CANCEL DELETE
        END IF 
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrad[l_ac].* = g_hrad_t.*
         CLOSE i101_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrad[l_ac].hrad01,-263,0)
          LET g_hrad[l_ac].* = g_hrad_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrad_file SET hrad01=g_hrad[l_ac].hrad01,
                               hrad02=g_hrad[l_ac].hrad02,
                               hrad03=g_hrad[l_ac].hrad03,
                               hrad04=g_hrad[l_ac].hrad04,
                               hrad05=g_hrad[l_ac].hrad05,    
                               hradacti=g_hrad[l_ac].hradacti,
                               hradmodu=g_user,
                               hraddate=g_today
          WHERE hrad01 = g_hrad_t.hrad01
            AND hrad02 = g_hrad_t.hrad02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrad_file",g_hrad_t.hrad01,g_hrad_t.hrad02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrad[l_ac].* = g_hrad_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrad[l_ac].* = g_hrad_t.*
          END IF
          CLOSE i101_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i101_bcl                
        COMMIT WORK  
 
     
     ON ACTION controlp
        CASE 
           WHEN INFIELD(hrad01)
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_hrag06"
           LET g_qryparam.default1 = g_hrad[l_ac].hrad01
           LET g_qryparam.arg1 = '312'
           CALL cl_create_qry() RETURNING g_hrad[l_ac].hrad01
           DISPLAY BY NAME g_hrad[l_ac].hrad01 
           NEXT FIELD hrad01
        END CASE
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLF
        CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
        CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
 
    CLOSE i101_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i101_b_askkey()
    CLEAR FORM
    CALL g_hrad.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrad01,hrad02,hrad03,hrad04,hrad05,hradacti                       
         FROM s_hrad[1].hrad01,s_hrad[1].hrad02,s_hrad[1].hrad03,                                  
              s_hrad[1].hrad04,s_hrad[1].hrad05,s_hrad[1].hradacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
               WHEN INFIELD(hrad01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c"
               LET g_qryparam.arg1 = '312'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrad[1].hrad01
               NEXT FIELD hrad01
               
               WHEN INFIELD(hrad02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrad02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrad[1].hrad02
               NEXT FIELD hrad02
         OTHERWISE
              EXIT CASE
         END CASE
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
      #No.FUN-580031 --start--
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraduser', 'hradgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i101_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i101_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hrad01_1     LIKE    hrag_file.hrag07
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrad01,'',hrad02,hrad03,hrad04,hrad05,hradacti",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hrad_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i101_pb FROM g_sql
    DECLARE hrad_curs CURSOR FOR i101_pb
 
    CALL g_hrad.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrad_curs INTO g_hrad[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF

        SELECT hrag07 INTO g_hrad[g_cnt].hrad01_1 FROM hrag_file WHERE hrag01='312'
                                                                   AND hrag06=g_hrad[g_cnt].hrad01
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrad.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrad TO s_hrad.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION		   	     		

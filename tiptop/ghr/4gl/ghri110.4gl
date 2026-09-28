# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri110.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hral           DYNAMIC ARRAY OF RECORD    
        hral01       LIKE hral_file.hral01,     
        hral02       LIKE hral_file.hral02,   
        hral03       LIKE hral_file.hral03,  
        hral04       LIKE hral_file.hral04,   
        hralacti     LIKE hral_file.hralacti   
                    END RECORD,
    g_hral_t         RECORD                 
        hral01       LIKE hral_file.hral01,     
        hral02       LIKE hral_file.hral02,   
        hral03       LIKE hral_file.hral03,  
        hral04       LIKE hral_file.hral04,   
        hralacti     LIKE hral_file.hralacti 
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
    OPEN WINDOW i110_w AT p_row,p_col WITH FORM "ghr/42f/ghri110"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i110_b_fill(g_wc2)
    CALL i110_menu()
    CLOSE WINDOW i110_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i110_menu()
 
   WHILE TRUE
      CALL i110_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i110_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i110_b()
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
               IF g_hral[l_ac].hral01 IS NOT NULL THEN
                  LET g_doc.column1 = "hral01"
                  LET g_doc.value1 = g_hral[l_ac].hral01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hral),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i110_q()
   CALL i110_b_askkey()
END FUNCTION
	
FUNCTION i110_b()
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
 
    LET g_forupd_sql = "SELECT hral01,hral02,hral03,hral04,hralacti",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hral_file WHERE hral01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i110_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hral WITHOUT DEFAULTS FROM s_hral.*
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
           LET g_hral_t.* = g_hral[l_ac].*  #BACKUP
           OPEN i110_bcl USING g_hral_t.hral01
           IF STATUS THEN
              CALL cl_err("OPEN i110_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i110_bcl INTO g_hral[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hral_t.hral01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end 
         INITIALIZE g_hral[l_ac].* TO NULL      #900423  
         LET g_hral[l_ac].hralacti = 'Y'       #Body default
         LET g_hral_t.* = g_hral[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hral01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i110_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hral_file(hral01,hral02,hral03,hral04,                          #FUN-A30097
                              hralacti,hraluser,hraldate,hralgrup,hraloriu,hralorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hral[l_ac].hral01,g_hral[l_ac].hral02,
               g_hral[l_ac].hral03,g_hral[l_ac].hral04,
               g_hral[l_ac].hralacti,g_user,g_today,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hral_file",g_hral[l_ac].hral01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hral01                        
       IF NOT cl_null(g_hral[l_ac].hral01) THEN       	 	  	                                            
          IF g_hral[l_ac].hral01 != g_hral_t.hral01 OR
             g_hral_t.hral01 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hral_file
              WHERE hral01 = g_hral[l_ac].hral01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hral[l_ac].hral01 = g_hral_t.hral01
                NEXT FIELD hral01
             END IF
          END IF                                             	
       END IF
       	
    AFTER FIELD hral02
       IF NOT cl_null(g_hral[l_ac].hral02) THEN
          IF g_hral[l_ac].hral02 != g_hral_t.hral02 OR
             g_hral_t.hral02 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hral_file
              WHERE hral02 = g_hral[l_ac].hral02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hral[l_ac].hral02 = g_hral_t.hral02
                NEXT FIELD hral02
             END IF
          END IF     
       END IF
       	
   
    AFTER FIELD hralacti
       IF NOT cl_null(g_hral[l_ac].hralacti) THEN
          IF g_hral[l_ac].hralacti NOT MATCHES '[YN]' THEN 
             LET g_hral[l_ac].hralacti = g_hral_t.hralacti
             NEXT FIELD hralacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hral_t.hral01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hral01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hral[l_ac].hral01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hral_file WHERE hral01 = g_hral_t.hral01
                    
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hral_file",g_hral_t.hral01,g_hral_t.hral02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
             LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hral[l_ac].* = g_hral_t.*
         CLOSE i110_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hral[l_ac].hral01,-263,0)
          LET g_hral[l_ac].* = g_hral_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hral_file SET hral01=g_hral[l_ac].hral01,
                               hral02=g_hral[l_ac].hral02,
                               hral03=g_hral[l_ac].hral03,
                               hral04=g_hral[l_ac].hral04,    
                               hralacti=g_hral[l_ac].hralacti,
                               hralmodu=g_user,
                               hraldate=g_today
          WHERE hral01 = g_hral_t.hral01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hral_file",g_hral_t.hral01,g_hral_t.hral02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hral[l_ac].* = g_hral_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hral[l_ac].* = g_hral_t.*
          END IF
          CLOSE i110_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i110_bcl                
        COMMIT WORK  
 
 
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
 
    CLOSE i110_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i110_b_askkey()
    CLEAR FORM
    CALL g_hral.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hral01,hral02,hral03,hral04,hralacti                       
         FROM s_hral[1].hral01,s_hral[1].hral02,s_hral[1].hral03,                                  
              s_hral[1].hral04,s_hral[1].hralacti
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hral01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hral01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hral[1].hral01
               NEXT FIELD hral01
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraluser', 'hralgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i110_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i110_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hral01,hral02,hral03,hral04,hralacti",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hral_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i110_pb FROM g_sql
    DECLARE hral_curs CURSOR FOR i110_pb
 
    CALL g_hral.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hral_curs INTO g_hral[g_cnt].*  
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
    CALL g_hral.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i110_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hral TO s_hral.* ATTRIBUTE(COUNT=g_rec_b)
 
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

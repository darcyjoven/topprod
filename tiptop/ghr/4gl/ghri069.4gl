# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri069.4gl
# Descriptions...: 
# Date & Author..: 03/15/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"


DEFINE 
     g_hrcz           DYNAMIC ARRAY OF RECORD    
        hrcz03       LIKE hrcz_file.hrcz03,
        hraa12       LIKE hraa_file.hraa12,     
        hrcz01       LIKE hrcz_file.hrcz01,   
        hrcz02       LIKE hrcz_file.hrcz02,     
        hrczacti     LIKE hrcz_file.hrczacti,
        hrcz04       LIKE hrcz_file.hrcz04,
        hrczdate     LIKE hrcz_file.hrczdate,
        hrcz05       LIKE hrcz_file.hrcz05   
                    END RECORD,
    g_hrcz_t         RECORD                 
        hrcz03       LIKE hrcz_file.hrcz03,
        hraa12       LIKE hraa_file.hraa12,     
        hrcz01       LIKE hrcz_file.hrcz01,   
        hrcz02       LIKE hrcz_file.hrcz02,     
        hrczacti     LIKE hrcz_file.hrczacti,
        hrcz04       LIKE hrcz_file.hrcz04,
        hrczdate     LIKE hrcz_file.hrczdate,
        hrcz05       LIKE hrcz_file.hrcz05 
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
    OPEN WINDOW i069_w AT p_row,p_col WITH FORM "ghr/42f/ghri069"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i069_b_fill(g_wc2)
    CALL i069_menu()
    CLOSE WINDOW i069_w                 
      CALL  cl_used(g_prog,g_time,2)
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i069_menu()
 
   WHILE TRUE
      CALL i069_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i069_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i069_b()
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
               IF g_hrcz[l_ac].hrcz01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrcz01"
                  LET g_doc.value1 = g_hrcz[l_ac].hrcz01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrcz),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i069_q()
   CALL i069_b_askkey()
END FUNCTION
	
FUNCTION i069_b()
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
 
    LET g_forupd_sql = "SELECT hrcz03,'',hrcz01,hrcz02,hrczacti,hrcz04,hrczdate,hrcz05",  #FUN-A30030 ADD POS#FUN-A30097 #FUN-A80148--mod--
                       "  FROM hrcz_file WHERE hrcz01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i069_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrcz WITHOUT DEFAULTS FROM s_hrcz.*
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
           CALL cl_set_comp_entry("hrcz01",FALSE)
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end   
                      
           LET g_hrcz_t.* = g_hrcz[l_ac].*  #BACKUP
           OPEN i069_bcl USING g_hrcz_t.hrcz01
           IF STATUS THEN
              CALL cl_err("OPEN i069_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i069_bcl INTO g_hrcz[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrcz_t.hrcz01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              
              SELECT hraa12 INTO g_hrcz[l_ac].hraa12 FROM hraa_file 
               WHERE hraa01=g_hrcz[l_ac].hrcz03	
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
         INITIALIZE g_hrcz[l_ac].* TO NULL      #900423  
         LET g_hrcz[l_ac].hrcz04=g_today
         LET g_hrcz[l_ac].hrczacti='Y'
         LET g_hrcz_t.* = g_hrcz[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrcz03
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i069_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hrcz_file(hrcz01,hrcz02,hrcz03,hrcz04,hrcz05,                          #FUN-A30097
                              hrczacti,hrczdate,hrczuser,hrczgrup,hrczoriu,hrczorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrcz[l_ac].hrcz01,g_hrcz[l_ac].hrcz02,
                      g_hrcz[l_ac].hrcz03,g_hrcz[l_ac].hrcz04,g_hrcz[l_ac].hrcz05,
                      g_hrcz[l_ac].hrczacti,g_hrcz[l_ac].hrczdate,g_user,g_grup,g_user,g_grup) #FUN-A30030 ADD POS   #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrcz_file",g_hrcz[l_ac].hrcz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b=g_rec_b+1    
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
           CALL i069_ins_hrbh(g_hrcz[l_ac].hrcz01)    #add by shenran 20130905
        END IF        	  	
        	
    AFTER FIELD hrcz03                        
       IF NOT cl_null(g_hrcz[l_ac].hrcz03) THEN 
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hraa_file
           WHERE hraa01 = g_hrcz[l_ac].hrcz03
             AND hraaacti= 'Y'
          IF l_n = 0 THEN
             CALL cl_err('无此公司编号','!',0)
             LET g_hrcz[l_ac].hrcz03 = g_hrcz_t.hrcz03
             NEXT FIELD hrcz03
          END IF
          
          SELECT hraa12	INTO g_hrcz[l_ac].hraa12 FROM hraa_file 
           WHERE hraa01=g_hrcz[l_ac].hrcz03                                        	
       END IF
       	
    AFTER FIELD hrcz01
       IF NOT cl_null(g_hrcz[l_ac].hrcz01) THEN
          IF g_hrcz[l_ac].hrcz01 != g_hrcz_t.hrcz01 OR
             g_hrcz_t.hrcz01 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrcz_file
              WHERE hrcz01 = g_hrcz[l_ac].hrcz01
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrcz[l_ac].hrcz01 = g_hrcz_t.hrcz01
                NEXT FIELD hrcz01
             END IF
          END IF     
       END IF
       	
    AFTER FIELD hrcz02
       IF NOT cl_null(g_hrcz[l_ac].hrcz02) THEN
          IF g_hrcz[l_ac].hrcz02 != g_hrcz_t.hrcz02 OR
             g_hrcz_t.hrcz02 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrcz_file
              WHERE hrcz02 = g_hrcz[l_ac].hrcz02
             IF l_n > 0 THEN
                CALL cl_err('',-239,0)
                LET g_hrcz[l_ac].hrcz02 = g_hrcz_t.hrcz02
                NEXT FIELD hrcz02
             END IF
          END IF     
       END IF   	
       	
   
    AFTER FIELD hrczacti
       IF NOT cl_null(g_hrcz[l_ac].hrczacti) THEN
          IF g_hrcz[l_ac].hrczacti NOT MATCHES '[YN]' THEN 
             LET g_hrcz[l_ac].hrczacti = g_hrcz_t.hrczacti
             NEXT FIELD hrczacti
          END IF
       END IF 
       	
    BEFORE DELETE                           
       IF g_hrcz_t.hrcz01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrcz01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrcz[l_ac].hrcz01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrcz_file WHERE hrcz01 = g_hrcz_t.hrcz01
                    
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrcz_file",g_hrcz_t.hrcz01,g_hrcz_t.hrcz02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
          	 LET g_rec_b=g_rec_b-1
          	 DISPLAY g_rec_b TO cn2    
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrcz[l_ac].* = g_hrcz_t.*
         CLOSE i069_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrcz[l_ac].hrcz01,-263,0)
          LET g_hrcz[l_ac].* = g_hrcz_t.*
       ELSE
          
         #FUN-A30030 END--------------------
          UPDATE hrcz_file SET hrcz01=g_hrcz[l_ac].hrcz01,
                               hrcz02=g_hrcz[l_ac].hrcz02,
                               hrcz03=g_hrcz[l_ac].hrcz03,
                               hrcz04=g_hrcz[l_ac].hrcz04,
                               hrcz05=g_hrcz[l_ac].hrcz05, 
                               hrczacti=g_hrcz[l_ac].hrczacti,
                               hrczmodu=g_user,
                               hrczdate=g_today
          WHERE hrcz01 = g_hrcz_t.hrcz01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrcz_file",g_hrcz_t.hrcz01,g_hrcz_t.hrcz02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrcz[l_ac].* = g_hrcz_t.*
          ELSE
          	 LET g_hrcz[l_ac].hrczdate=g_today
          	 DISPLAY BY NAME g_hrcz[l_ac].hrczdate   
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrcz[l_ac].* = g_hrcz_t.*
          END IF
          CLOSE i069_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i069_bcl                
        COMMIT WORK  
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(hrcz03)
           CALL cl_init_qry_var()
           LET g_qryparam.form ="q_hraa01"
           LET g_qryparam.default1 = g_hrcz[l_ac].hrcz03
           CALL cl_create_qry() RETURNING g_hrcz[l_ac].hrcz03
           DISPLAY BY NAME g_hrcz[l_ac].hrcz03
           NEXT FIELD hrcz03
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
 
    CLOSE i069_bcl
    COMMIT WORK
END FUNCTION   
	
FUNCTION i069_b_askkey()
    CLEAR FORM
    CALL g_hrcz.clear()
 
    CONSTRUCT g_wc2 ON hrcz03,hrcz01,hrcz02,hrczacti,hrcz04,hrczdate,hrcz05                       
         FROM s_hrcz[1].hrcz03,s_hrcz[1].hrcz01,s_hrcz[1].hrcz02,s_hrcz[1].hrczacti,                                  
              s_hrcz[1].hrcz04,s_hrcz[1].hrczdate,s_hrcz[1].hrcz05
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrcz03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrcz[1].hrcz03
               NEXT FIELD hrcz03
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrczuser', 'hrczgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i069_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i069_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrcz03,'',hrcz01,hrcz02,hrczacti,hrcz04,hrczdate,hrcz05",   #FUN-A30030 ADD POS #FUN-A30097
                   " FROM hrcz_file",
                   " WHERE ", p_wc2 CLIPPED, 
                   " ORDER BY 1" 
 
    PREPARE i069_pb FROM g_sql
    DECLARE hrcz_curs CURSOR FOR i069_pb
 
    CALL g_hrcz.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrcz_curs INTO g_hrcz[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrcz[g_cnt].hraa12 FROM hraa_file 
         WHERE hraa01=g_hrcz[g_cnt].hrcz03	
         
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrcz.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i069_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrcz TO s_hrcz.* ATTRIBUTE(COUNT=g_rec_b)
 
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
FUNCTION i069_ins_hrbh(p_hrcz01)
DEFINE  p_hrcz01   LIKE  hrcz_file.hrcz01
DEFINE  l_hrcz     RECORD LIKE hrcz_file.*
DEFINE  l_hrdh     RECORD LIKE hrdh_file.*

        SELECT * INTO l_hrcz.* FROM hrcz_file WHERE hrcz01=p_hrcz01
        
        LET l_hrdh.hrdh02='002'
        LET l_hrdh.hrdh10='N'
        LET l_hrdh.hrdh03='001'
        LET l_hrdh.hrdh07=l_hrcz.hrcz03
        LET l_hrdh.hrdhacti='Y'
        LET l_hrdh.hrdhuser=g_user
        LET l_hrdh.hrdhgrup=g_grup
        LET l_hrdh.hrdhoriu=g_user
        LET l_hrdh.hrdhorig=g_grup
        LET l_hrdh.hrdhdate=g_today
        LET l_hrdh.hrdh06=l_hrcz.hrcz02
        LET l_hrdh.hrdh12="hrcz",l_hrcz.hrcz01                         #add by zhangbo130624
        SELECT MAX(hrdh01) INTO l_hrdh.hrdh01 FROM hrdh_file
        IF l_hrdh.hrdh01 IS NULL THEN
       	   LET l_hrdh.hrdh01=1
        ELSE
       	   LET l_hrdh.hrdh01=l_hrdh.hrdh01+1
        END IF

        SELECT F_TRANS_PINYIN_CAPITAL(l_hrdh.hrdh06) INTO l_hrdh.hrdh13 FROM DUAL    #add by zhangbo130821
 	
        INSERT INTO hrdh_file VALUES (l_hrdh.*)
        
END FUNCTION    	
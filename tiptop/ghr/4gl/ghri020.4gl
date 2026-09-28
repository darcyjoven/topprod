# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri020.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrbd             DYNAMIC ARRAY OF RECORD    
        hrbd01          LIKE hrbd_file.hrbd01,    
        hrbd02          LIKE hrbd_file.hrbd02,  
        hrbd03          LIKE hrbd_file.hrbd03,
        hrat02          LIKE hrat_file.hrat02,  
        hrao02          LIKE hrao_file.hrao02,   
        hras04          LIKE hras_file.hras04,
        hrbd04          LIKE hrbd_file.hrbd04,
        hrbd05          LIKE hrbd_file.hrbd05,
        hrbd06          LIKE hrbd_file.hrbd06, 
        hrbd07          LIKE hrbd_file.hrbd07,
        hrbd12          LIKE hrbd_file.hrbd12
                    END RECORD,
     g_hrbd_t         RECORD                
        hrbd01          LIKE hrbd_file.hrbd01,    
        hrbd02          LIKE hrbd_file.hrbd02,  
        hrbd03          LIKE hrbd_file.hrbd03,
        hrat02          LIKE hrat_file.hrat02,  
        hrao02          LIKE hrao_file.hrao02,   
        hras04          LIKE hras_file.hras04,
        hrbd04          LIKE hrbd_file.hrbd04,
        hrbd05          LIKE hrbd_file.hrbd05,
        hrbd06          LIKE hrbd_file.hrbd06, 
        hrbd07          LIKE hrbd_file.hrbd07,
        hrbd12          LIKE hrbd_file.hrbd12
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
DEFINE g_msg        LIKE type_file.chr1000


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
    OPEN WINDOW i020_w AT p_row,p_col WITH FORM "ghr/42f/ghri020"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i020_b_fill(g_wc2)
    CALL i020_menu()
    CLOSE WINDOW i020_w                 
      CALL cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i020_menu()
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "ghri020_a"
            IF cl_chk_act_auth() THEN
               LET g_msg="ghri020_1 '",g_hrbd[l_ac].hrbd01,"'"
               CALL cl_cmdrun_wait(g_msg)
            END IF
            	
         WHEN "ghri020_b"
            IF cl_chk_act_auth() THEN
               LET g_msg="ghri020_2 '",g_hrbd[l_ac].hrbd01,"'"
               CALL cl_cmdrun_wait(g_msg)
               CALL i020_b_fill(g_wc2)
            END IF    	   		     
            
         WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrbd[l_ac].hrbd01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbd01"
                  LET g_doc.value1 = g_hrbd[l_ac].hrbd01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbd),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i020_q()
   CALL i020_b_askkey()
END FUNCTION
	
FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid
DEFINE l_sql        STRING 
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING
DEFINE l_no         LIKE type_file.chr10        
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbd01,hrbd02,hrbd03,'','','',hrbd04,hrbd05,",
                       "       hrbd06,hrbd07,hrbd12",
                       "  FROM hrbd_file WHERE hrbd01=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrbd WITHOUT DEFAULTS FROM s_hrbd.*
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
           LET g_hrbd_t.* = g_hrbd[l_ac].*  #BACKUP
           OPEN i020_bcl USING g_hrbd_t.hrbd01
           IF STATUS THEN
              CALL cl_err("OPEN i020_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i020_bcl INTO g_hrbd[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrbd_t.hrbd01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           	
           #hrbd03存的是hratid,需要将其显示为hrat01	
           SELECT hrat01 INTO g_hrbd[l_ac].hrbd03 FROM hrat_file
            WHERE hratid = g_hrbd[l_ac].hrbd03
              AND hratacti='Y'
              AND hratconf='Y'
           #姓名  
           SELECT hrat02 
             INTO g_hrbd[l_ac].hrat02 
             FROM hrat_file
            WHERE hrat01 = g_hrbd[l_ac].hrbd03 
              AND hratacti = 'Y'
              AND hratconf = 'Y'
                 
           #部门名称   
           SELECT hrao02 INTO g_hrbd[l_ac].hrao02 
             FROM hrao_file,hrat_file  
            WHERE hrao01=hrat04
              AND hrat01=g_hrbd[l_ac].hrbd03
              AND hraoacti='Y'
              
           #职位名称
           SELECT hras04 INTO g_hrbd[l_ac].hras04
             FROM hras_file,hrat_file 
            WHERE hras01=hrat05        
              AND hrat01=g_hrbd[l_ac].hrbd03
              AND hrasacti='Y'  
           CALL cl_set_comp_entry("hrbd01",FALSE)       
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        ELSE
        	 CALL cl_set_comp_entry("hrbd01",TRUE)   
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end  
         INITIALIZE g_hrbd[l_ac].* TO NULL      #900423
         LET g_hrbd[l_ac].hrbd02=g_today
         LET g_hrbd[l_ac].hrbd06=0
         LET g_hrbd[l_ac].hrbd07=0
         	  	                          
         LET g_hrbd_t.* = g_hrbd[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbd01                   
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i020_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        #hrbd03存hratid
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbd[l_ac].hrbd03
        
        INSERT INTO hrbd_file(hrbd01,hrbd02,hrbd03,hrbd04,hrbd05,                          #FUN-A30097
                    hrbd06,hrbd07,hrbd12,hrbdacti,
                    hrbduser,hrbdgrup,hrbdoriu,hrbdorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrbd[l_ac].hrbd01,g_hrbd[l_ac].hrbd02,
                      l_hratid,g_hrbd[l_ac].hrbd04,
                      g_hrbd[l_ac].hrbd05,g_hrbd[l_ac].hrbd06,
                      g_hrbd[l_ac].hrbd07,g_hrbd[l_ac].hrbd12,
                      'Y',g_user,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrbd_file",g_hrbd[l_ac].hrbd01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
    
    AFTER FIELD hrbd01
       IF NOT cl_null(g_hrbd[l_ac].hrbd01) THEN
       	  IF g_hrbd_t.hrbd01 != g_hrbd[l_ac].hrbd01 
       	  	 OR g_hrbd_t.hrbd01 IS NULL THEN
       	  	 LET l_n=0
       	  	 SELECT COUNT(*) INTO l_n FROM hrbd_file 
       	  	  WHERE hrbd01=g_hrbd[l_ac].hrbd01
       	  	 IF l_n>0 THEN
       	  	 	  CALL cl_err(g_hrbd[l_ac].hrbd01,-239,0)
       	  	 	  NEXT FIELD hrbd01
       	  	 END IF
       	   END IF
       END IF	   		 		   
       	  	  	
    AFTER FIELD hrbd03
       IF NOT cl_null(g_hrbd[l_ac].hrbd03) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file 
       	   WHERE hrat01=g_hrbd[l_ac].hrbd03
       	     AND hratacti='Y'
       	     AND hratconf='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此员工编号','!',0)
       	  	  NEXT FIELD hrbd03
       	  END IF
       	  	
       	  SELECT hrat02
       	    INTO g_hrbd[l_ac].hrat02 
            FROM hrat_file
           WHERE hrat01 = g_hrbd[l_ac].hrbd03  
             AND hratacti = 'Y' 
             AND hratconf = 'Y'  
         
          SELECT hrao02 INTO g_hrbd[l_ac].hrao02 FROM hrao_file,hrat_file
           WHERE hrao01=hrat04
             AND hrat01=g_hrbd[l_ac].hrbd03
             AND hraoacti='Y'
            
          SELECT hras04 INTO g_hrbd[l_ac].hras04 FROM hras_file,hrat_file
           WHERE hras01=hrat05
             AND hrat01=g_hrbd[l_ac].hrbd03
             AND hrasacti='Y'                     	
       	  
       	 DISPLAY BY NAME g_hrbd[l_ac].hrat02,g_hrbd[l_ac].hrao02,
       	                 g_hrbd[l_ac].hras04
       END IF 
       	
        	
       	       	
    BEFORE DELETE                            
       IF g_hrbd_T.hrbd01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrbd01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrbd_t.hrbd01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrbd_file WHERE hrbd01 = g_hrbd_t.hrbd01
          DELETE FROM hrbda_file WHERE hrbda01 = g_hrbd_t.hrbd01
          DELETE FROM hrbdb_file WHERE hrbdb01 = g_hrbd_t.hrbd01
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrbd_file",g_hrbd_t.hrbd01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrbd[l_ac].* = g_hrbd_t.*
         CLOSE i020_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrbd[l_ac].hrbd01,-263,0)
          LET g_hrbd[l_ac].* = g_hrbd_t.*
       ELSE
         SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbd[l_ac].hrbd03 
         #FUN-A30030 END--------------------
          UPDATE hrbd_file SET hrbd02=g_hrbd[l_ac].hrbd02,
                               hrbd03=l_hratid,
                               hrbd04=g_hrbd[l_ac].hrbd04,
                               hrbd05=g_hrbd[l_ac].hrbd05,
                               hrbd06=g_hrbd[l_ac].hrbd06,
                               hrbd07=g_hrbd[l_ac].hrbd07,
                               hrbd12=g_hrbd[l_ac].hrbd12,    
                               hrbdmodu=g_user,
                               hrbddate=g_today
                WHERE hrbd01 = g_hrbd_t.hrbd01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrbd_file",g_hrbd_t.hrbd01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrbd[l_ac].* = g_hrbd_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrbd[l_ac].* = g_hrbd_t.*
          END IF
          CLOSE i020_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i020_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrbd03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrat01"
             LET g_qryparam.default1 = g_hrbd[l_ac].hrbd03
             CALL cl_create_qry() RETURNING g_hrbd[l_ac].hrbd03
             DISPLAY BY NAME g_hrbd[l_ac].hrbd03
             NEXT FIELD hrbd03
             
         OTHERWISE
           EXIT CASE
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
 
    CLOSE i020_bcl
    COMMIT WORK
END FUNCTION    
	
FUNCTION i020_b_askkey()
    CLEAR FORM
    CALL g_hrbd.clear()
 
    CONSTRUCT g_wc2 ON hrbd01,hrbd02,hrbd03,hrbd04,
                       hrbd05,hrbd06,hrbd07,hrbd12                       
         FROM s_hrbd[1].hrbd01,s_hrbd[1].hrbd02,s_hrbd[1].hrbd03,                                  
              s_hrbd[1].hrbd04,s_hrbd[1].hrbd05,s_hrbd[1].hrbd06,
              s_hrbd[1].hrbd07,s_hrbd[1].hrbd12
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbd03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbd[1].hrbd03
               NEXT FIELD hrbd03
               
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbduser', 'hrbdgrup') #FUN-980030
   CALL cl_replace_str(g_wc2,'hrbd03','hrat01') RETURNING g_wc2  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i020_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrbd01,hrbd02,hrbd03,'','','',hrbd04,hrbd05,",
                   "       hrbd06,hrbd07,hrbd12 ",
                   " FROM hrbd_file,hrat_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid=hrbd03 ",
                   " ORDER BY 1" 
 
    PREPARE i020_pb FROM g_sql
    DECLARE hrbd_curs CURSOR FOR i020_pb
 
    CALL g_hrbd.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbd_curs INTO g_hrbd[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        #显示工号
        SELECT hrat01 INTO g_hrbd[g_cnt].hrbd03 FROM hrat_file 
         WHERE hratid=g_hrbd[g_cnt].hrbd03
           AND hratacti='Y'
           AND hratconf='Y'
        #姓名   
        SELECT hrat02 INTO g_hrbd[g_cnt].hrat02
          FROM hrat_file
         WHERE hrat01=g_hrbd[g_cnt].hrbd03
           AND hratacti='Y'
           AND hratconf='Y'
           
        #部门名称
        SELECT hrao02 INTO g_hrbd[g_cnt].hrao02 FROM hrao_file,hrat_file
         WHERE hrao01=hrat04
           AND hrat01=g_hrbd[g_cnt].hrbd03
           AND hraoacti='Y'
           
        #职位名称
        SELECT hras04 INTO g_hrbd[g_cnt].hras04 FROM hras_file,hrat_file
         WHERE hras01=hrat05
           AND hrat01=g_hrbd[g_cnt].hrbd03
           AND hrasacti='Y'    
              
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbd.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbd TO s_hrbd.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         
      ON ACTION ghri020_a
         LET g_action_choice="ghri020_a"
         EXIT DISPLAY 
         
      ON ACTION ghri020_b
         LET g_action_choice="ghri020_b"
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

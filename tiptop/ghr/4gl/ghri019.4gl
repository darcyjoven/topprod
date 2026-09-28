# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri019.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrbc             DYNAMIC ARRAY OF RECORD    
        hrbc01          LIKE hrbc_file.hrbc01,   
        hrat02          LIKE hrat_file.hrat02,
        hraa12          LIKE hraa_file.hraa12,  
        hrao02          LIKE hrao_file.hrao02,   
        hras04          LIKE hras_file.hras04, 
        hrbc02          LIKE hrbc_file.hrbc02,  
        hrbc02_desc     LIKE hrag_file.hrag07,
        hrbc03          LIKE hrbc_file.hrbc03,
        hrbc04          LIKE hrbc_file.hrbc04,
        hrbc05          LIKE hrbc_file.hrbc05,
        hrbc06          LIKE hrbc_file.hrbc06, 
        hrbc07          LIKE hrbc_file.hrbc07,
        hrbc08          LIKE hrbc_file.hrbc08,
        hrbc09          LIKE hrbc_file.hrbc09, 
        hrbc10          LIKE hrbc_file.hrbc10,
        hrbc11          LIKE hrbc_file.hrbc11,
        hrbc12          LIKE hrbc_file.hrbc12
                    END RECORD,
     g_hrbc_t         RECORD                
        hrbc01          LIKE hrbc_file.hrbc01,   
        hrat02          LIKE hrat_file.hrat02,
        hraa12          LIKE hraa_file.hraa12,  
        hrao02          LIKE hrao_file.hrao02,   
        hras04          LIKE hras_file.hras04, 
        hrbc02          LIKE hrbc_file.hrbc02,  
        hrbc02_desc     LIKE hrag_file.hrag07,
        hrbc03          LIKE hrbc_file.hrbc03,
        hrbc04          LIKE hrbc_file.hrbc04,
        hrbc05          LIKE hrbc_file.hrbc05,
        hrbc06          LIKE hrbc_file.hrbc06, 
        hrbc07          LIKE hrbc_file.hrbc07,
        hrbc08          LIKE hrbc_file.hrbc08,
        hrbc09          LIKE hrbc_file.hrbc09, 
        hrbc10          LIKE hrbc_file.hrbc10,
        hrbc11          LIKE hrbc_file.hrbc11,
        hrbc12          LIKE hrbc_file.hrbc12
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5
    
DEFINE g_hrbc00   DYNAMIC ARRAY OF RECORD
         hrbc00         LIKE hrbc_file.hrbc00
                  END RECORD                     
 
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
    OPEN WINDOW i019_w AT p_row,p_col WITH FORM "ghr/42f/ghri019"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i019_b_fill(g_wc2)
    CALL i019_menu()
    CLOSE WINDOW i019_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i019_menu()
 
   WHILE TRUE
      CALL i019_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i019_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i019_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "ghri019_a"
            IF cl_chk_act_auth() THEN
               LET g_msg="ghri019_1 '",g_hrbc00[l_ac].hrbc00,"'"
               CALL cl_cmdrun_wait(g_msg)
            END IF   		     
            
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrbc[l_ac].hrbc01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbc01"
                  LET g_doc.value1 = g_hrbc[l_ac].hrbc01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbc),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i019_q()
   CALL i019_b_askkey()
END FUNCTION
	
FUNCTION i019_b()
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
DEFINE l_hrbc00     LIKE hrbc_file.hrbc00      
   
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbc01,'','','','',hrbc02,'',hrbc03,hrbc04,hrbc05,",
                       "       hrbc06,hrbc07,hrbc08,hrbc09,hrbc10,hrbc11,hrbc12",
                       "  FROM hrbc_file WHERE hrbc00=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i019_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrbc WITHOUT DEFAULTS FROM s_hrbc.*
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
           LET g_hrbc_t.* = g_hrbc[l_ac].*  #BACKUP
           OPEN i019_bcl USING g_hrbc00[l_ac].hrbc00
           IF STATUS THEN
              CALL cl_err("OPEN i019_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i019_bcl INTO g_hrbc[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrbc_t.hrbc01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           #hrag02存的是hratid,需要将其显示为hrat01	
           SELECT hrat01 INTO g_hrbc[l_ac].hrbc01 FROM hrat_file
            WHERE hratid = g_hrbc[l_ac].hrbc01
              AND hratacti='Y'
              AND hratconf='Y'
           #姓名  
           SELECT hrat02 
             INTO g_hrbc[l_ac].hrat02 
             FROM hrat_file
            WHERE hrat01 = g_hrbc[l_ac].hrbc01 
              AND hratacti = 'Y'
              AND hratconf = 'Y'
              
           #公司名称
           SELECT hraa12 INTO g_hrbc[l_ac].hraa12
             FROM hraa_file,hrat_file
            WHERE hrat01=g_hrbc[l_ac].hrbc01
              AND hrat03=hraa01
              AND hraaacti='Y'
                 
           #部门名称   
           SELECT hrao02 INTO g_hrbc[l_ac].hrao02 
             FROM hrao_file,hrat_file  
            WHERE hrao01=hrat04
              AND hrat01=g_hrbc[l_ac].hrbc01
              AND hraoacti='Y'
           #职位名称
           SELECT hras04 INTO g_hrbc[l_ac].hras04
             FROM hras_file,hrat_file 
            WHERE hras01=hrat05        
              AND hrat01=g_hrbc[l_ac].hrbc01
              AND hrasacti='Y'
              
           #证照类型---代码组
           SELECT hrag07 INTO g_hrbc[l_ac].hrbc02_desc
             FROM hrag_file 
            WHERE hrag01='338'                        
              AND hrag06=g_hrbc[l_ac].hrbc02
          
            
           IF g_hrbc[l_ac].hrbc10='Y' THEN
           	  CALL cl_set_comp_entry("hrbc11",TRUE)
           	  CALL cl_set_comp_required("hrbc11",TRUE)
           ELSE
           	  SELECT to_date('9999/12/31','yyyy/mm/dd') 
           	    INTO g_hrbc[l_ac].hrbc11
           	    FROM DUAL 
           	  CALL cl_set_comp_entry("hrbc11",FALSE)
           	  CALL cl_set_comp_required("hrbc11",FALSE)
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
         INITIALIZE g_hrbc[l_ac].* TO NULL      #900423
         LET g_hrbc[l_ac].hrbc10='N'
         SELECT to_date('9999/12/31','yyyy/mm/dd') 
           INTO g_hrbc[l_ac].hrbc11
           FROM DUAL
         IF g_hrbc[l_ac].hrbc07='Y' THEN
           	CALL cl_set_comp_entry("hrbc11",TRUE)
           	CALL cl_set_comp_required("hrbc11",TRUE)
         ELSE
           	CALL cl_set_comp_entry("hrbc11",FALSE)
           	CALL cl_set_comp_required("hrbc11",FALSE)
         END IF
         LET l_year=YEAR(g_today) USING "&&&&"
         LET l_month=MONTH(g_today) USING "&&"
         LET l_day=DAY(g_today) USING "&&"
         LET l_year=l_year.trim()
         LET l_month=l_month.trim()
         LET l_day=l_day.trim()
         LET l_hrbc00=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,"%" 
         LET l_sql="SELECT MAX(hrbc00) FROM hrbc_file",
                   "  WHERE hrbc00 LIKE '",l_hrbc00,"'"
         PREPARE i019_hrbc00 FROM l_sql
         EXECUTE i019_hrbc00 INTO g_hrbc00[l_ac].hrbc00
         IF cl_null(g_hrbc00[l_ac].hrbc00) THEN 
         	  LET g_hrbc00[l_ac].hrbc00=l_hrbc00[1,8],'0001'
         ELSE
         	  LET l_no=g_hrbc00[l_ac].hrbc00[9,12]
         	  LET l_no=l_no+1 USING "&&&&"
         	  LET g_hrbc00[l_ac].hrbc00=l_hrbc00[1,8],l_no
         END IF	  
         	  	                          
         LET g_hrbc_t.* = g_hrbc[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbc01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i019_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        #hrbc02存hratid
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbc[l_ac].hrbc01
        
        INSERT INTO hrbc_file(hrbc00,hrbc01,hrbc02,hrbc03,hrbc04,hrbc05,                          #FUN-A30097
                    hrbc06,hrbc07,hrbc08,hrbc09,hrbc10,hrbc11,hrbc12,hrbcacti,
                    hrbcuser,hrbcdate,hrbcgrup,hrbcoriu,hrbcorig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrbc00[l_ac].hrbc00,l_hratid,
                      g_hrbc[l_ac].hrbc02,g_hrbc[l_ac].hrbc03,                                                              #FUN-A80148--mark--
                      g_hrbc[l_ac].hrbc04,g_hrbc[l_ac].hrbc05,
                      g_hrbc[l_ac].hrbc06,g_hrbc[l_ac].hrbc07,
                      g_hrbc[l_ac].hrbc08,g_hrbc[l_ac].hrbc09,
                      g_hrbc[l_ac].hrbc10,g_hrbc[l_ac].hrbc11,
                      g_hrbc[l_ac].hrbc12,
                      'Y',g_user,g_today,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrbc_file",g_hrbc[l_ac].hrbc01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
       	
    AFTER FIELD hrbc01
       IF NOT cl_null(g_hrbc[l_ac].hrbc01) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrbc[l_ac].hrbc01
       	                                            AND hratacti='Y'
       	                                            AND hratconf='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此员工编号','!',0)
       	  	  NEXT FIELD hrbc01
       	  END IF
       	  	
       	  SELECT hrat02
       	    INTO g_hrbc[l_ac].hrat02 
            FROM hrat_file
           WHERE hrat01 = g_hrbc[l_ac].hrbc01  
             AND hratacti = 'Y' 
             AND hratconf = 'Y'
             
          SELECT hraa12 INTO g_hrbc[l_ac].hraa12
            FROM hraa_file,hrat_file
           WHERE hraa01=hrat03
             AND hrat01=g_hrbc[l_ac].hrbc01
             AND hraaacti='Y'   
         
          SELECT hrao02 INTO g_hrbc[l_ac].hrao02 FROM hrao_file,hrat_file
           WHERE hrao01=hrat04
             AND hrat01=g_hrbc[l_ac].hrbc01
             AND hraoacti='Y'
            
          SELECT hras04 INTO g_hrbc[l_ac].hras04 FROM hras_file,hrat_file
           WHERE hras01=hrat05
             AND hrat01=g_hrbc[l_ac].hrbc01
             AND hrasacti='Y'                     	
       	  
       	 DISPLAY BY NAME g_hrbc[l_ac].hrat02,g_hrbc[l_ac].hraa12,
       	                 g_hrbc[l_ac].hrao02,g_hrbc[l_ac].hras04
       END IF 
       	
    
    AFTER FIELD hrbc02
       IF NOT cl_null(g_hrbc[l_ac].hrbc02) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='338'
       	                                            AND hrag06=g_hrbc[l_ac].hrbc02
       	  IF l_n=0 THEN
       	  	 CALL cl_err("无此证照类型","!",0)
       	  	 NEXT FIELD hrbc02
       	  END IF
       	  	
       	  SELECT hrag07 INTO g_hrbc[l_ac].hrbc02_desc FROM hrag_file
       	   WHERE hrag01='338'
       	     AND hrag06=g_hrbc[l_ac].hrbc02
       	  DISPLAY BY NAME g_hrbc[l_ac].hrbc02_desc   
       	  		                                           
       END IF
       	
    
    ON CHANGE hrbc10
       IF g_hrbc[l_ac].hrbc10='Y' THEN
          CALL cl_set_comp_entry("hrbc11",TRUE)
          CALL cl_set_comp_required("hrbc11",TRUE)
       ELSE
          SELECT to_date('9999/12/31','yyyy/mm/dd') 
           INTO g_hrbc[l_ac].hrbc11
           FROM DUAL
          CALL cl_set_comp_entry("hrbc11",FALSE)
          CALL cl_set_comp_required("hrbc11",FALSE)
       END IF       	
       	       	
    BEFORE DELETE                            
       IF g_hrbc00[l_ac].hrbc00 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrbc00"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrbc00[l_ac].hrbc00      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrbc_file WHERE hrbc00 = g_hrbc00[l_ac].hrbc00
          DELETE FROM hrbca_file WHERE hrbca00 = g_hrbc00[l_ac].hrbc00
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrbc_file",g_hrbc_t.hrbc01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrbc[l_ac].* = g_hrbc_t.*
         CLOSE i019_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrbc[l_ac].hrbc01,-263,0)
          LET g_hrbc[l_ac].* = g_hrbc_t.*
       ELSE
         SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbc[l_ac].hrbc01 
         #FUN-A30030 END--------------------
          UPDATE hrbc_file SET hrbc01=l_hratid,
                               hrbc02=g_hrbc[l_ac].hrbc02,
                               hrbc03=g_hrbc[l_ac].hrbc03,
                               hrbc04=g_hrbc[l_ac].hrbc04,
                               hrbc05=g_hrbc[l_ac].hrbc05,
                               hrbc06=g_hrbc[l_ac].hrbc06,
                               hrbc07=g_hrbc[l_ac].hrbc07,
                               hrbc08=g_hrbc[l_ac].hrbc08,
                               hrbc09=g_hrbc[l_ac].hrbc09,
                               hrbc10=g_hrbc[l_ac].hrbc10,
                               hrbc11=g_hrbc[l_ac].hrbc11,
                               hrbc12=g_hrbc[l_ac].hrbc12,    
                               hrbcmodu=g_user,
                               hrbcdate=g_today
                WHERE hrbc00 = g_hrbc00[l_ac].hrbc00
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrbc_file",g_hrbc_t.hrbc01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrbc[l_ac].* = g_hrbc_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrbc[l_ac].* = g_hrbc_t.*
          END IF
          CLOSE i019_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i019_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrbc01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrat01"
             LET g_qryparam.default1 = g_hrbc[l_ac].hrbc01
             CALL cl_create_qry() RETURNING g_hrbc[l_ac].hrbc01
             DISPLAY BY NAME g_hrbc[l_ac].hrbc01
             NEXT FIELD hrbc01
             
           WHEN INFIELD(hrbc02)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrbc[l_ac].hrbc02
             LET g_qryparam.arg1='338'
             CALL cl_create_qry() RETURNING g_hrbc[l_ac].hrbc02
             DISPLAY BY NAME g_hrbc[l_ac].hrbc02
             NEXT FIELD hrbc02            
             
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
 
    CLOSE i019_bcl
    COMMIT WORK
END FUNCTION    
	
FUNCTION i019_b_askkey()
    CLEAR FORM
    CALL g_hrbc.clear()
    CALL g_hrbc00.clear()
 
    CONSTRUCT g_wc2 ON hrbc01,hrbc02,hrbc03,hrbc04,hrbc05,hrbc06,hrbc07,
                       hrbc08,hrbc09,hrbc10,hrbc11,hrbc12                       
         FROM s_hrbc[1].hrbc01,s_hrbc[1].hrbc02,s_hrbc[1].hrbc03,                                  
              s_hrbc[1].hrbc04,s_hrbc[1].hrbc05,s_hrbc[1].hrbc06,
              s_hrbc[1].hrbc07,s_hrbc[1].hrbc08,s_hrbc[1].hrbc09,
              s_hrbc[1].hrbc10,s_hrbc[1].hrbc11,s_hrbc[1].hrbc12
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbc01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbc[1].hrbc01
               NEXT FIELD hrbc01
               
            WHEN INFIELD(hrbc02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c" 
               LET g_qryparam.arg1='338'  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbc02
               NEXT FIELD hrbc02
               
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbcuser', 'hrbcgrup') #FUN-980030
   CALL cl_replace_str(g_wc2,'hrbc01','hrat01') RETURNING g_wc2  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i019_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i019_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrbc00,hrbc01,'','','','',hrbc02,'',hrbc03,hrbc04,hrbc05,",
                   "       hrbc06,hrbc07,hrbc08,hrbc09,hrbc10,hrbc11,hrbc12 ",
                   " FROM hrbc_file,hrat_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid=hrbc01 ",
                   " ORDER BY 1" 
 
    PREPARE i019_pb FROM g_sql
    DECLARE hrbc_curs CURSOR FOR i019_pb
 
    CALL g_hrbc.clear()
    CALL g_hrbc00.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbc_curs INTO g_hrbc00[g_cnt].*,g_hrbc[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        #显示工号
        SELECT hrat01 INTO g_hrbc[g_cnt].hrbc01 FROM hrat_file 
         WHERE hratid=g_hrbc[g_cnt].hrbc01
           AND hratacti='Y'
           AND hratconf='Y'
        #姓名   
        SELECT hrat02 INTO g_hrbc[g_cnt].hrat02
          FROM hrat_file
         WHERE hrat01=g_hrbc[g_cnt].hrbc01
           AND hratacti='Y'
           AND hratconf='Y'
           
        #公司名称
        SELECT hraa12 INTO g_hrbc[g_cnt].hraa12
          FROM hraa_file,hrat_file
         WHERE hraa01=hrat03
           AND hrat01=g_hrbc[g_cnt].hrbc01
           AND hraaacti='Y'
           
        #部门名称
        SELECT hrao02 INTO g_hrbc[g_cnt].hrao02 FROM hrao_file,hrat_file
         WHERE hrao01=hrat04
           AND hrat01=g_hrbc[g_cnt].hrbc01
           AND hraoacti='Y'
           
        #职位名称
        SELECT hras04 INTO g_hrbc[g_cnt].hras04 FROM hras_file,hrat_file
         WHERE hras01=hrat05
           AND hrat01=g_hrbc[g_cnt].hrbc01
           AND hrasacti='Y'
           
        #证照类型名称
        SELECT hrag07 INTO g_hrbc[g_cnt].hrbc02_desc FROM hrag_file
         WHERE hrag01='338'
           AND hrag06=g_hrbc[g_cnt].hrbc02
           AND hragacti='Y'      
              
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbc.deleteElement(g_cnt)
    CALL g_hrbc00.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i019_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbc TO s_hrbc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         
      ON ACTION ghri019_a
         LET g_action_choice="ghri019_a"
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

# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri018.4gl
# Descriptions...: 
# Date & Author..: 03/12/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
     g_hrbb             DYNAMIC ARRAY OF RECORD    
        hrbb01          LIKE hrbb_file.hrbb01,   
        hrat02          LIKE hrat_file.hrat02,  
        hraa12          LIKE hraa_file.hraa12,      #add by zhangbo130904
        hrao02          LIKE hrao_file.hrao02,   
        hras04          LIKE hras_file.hras04, 
        hrbb02          LIKE hrbb_file.hrbb02,  
        hrbb02_desc     LIKE hrag_file.hrag07,
        hrbb03          LIKE hrbb_file.hrbb03,
        hrbb03_desc     LIKE hrba_file.hrba02,
        hrbb04          LIKE hrbb_file.hrbb04,
        hrbb12          LIKE hrbb_file.hrbb12,       #add by zhangbo130606
        hrbb05          LIKE hrbb_file.hrbb05,
        hrbb06          LIKE hrbb_file.hrbb06, 
        hrbb07          LIKE hrbb_file.hrbb07,
        hrbb08          LIKE hrbb_file.hrbb08,
        hrbb09          LIKE hrbb_file.hrbb09, 
        hrbb10          LIKE hrbb_file.hrbb10,
        hrbb11          LIKE hrbb_file.hrbb11,
        hrbb13          LIKE hrbb_file.hrbb13,
        hrbb14          LIKE hrbb_file.hrbb14,
        hrbb15          LIKE hrbb_file.hrbb15
                    END RECORD,
    g_hrbb_t         RECORD                
        hrbb01          LIKE hrbb_file.hrbb01,   
        hrat02          LIKE hrat_file.hrat02,  
        hraa12          LIKE hraa_file.hraa12,      #add by zhangbo130904
        hrao02          LIKE hrao_file.hrao02,   
        hras04          LIKE hras_file.hras04, 
        hrbb02          LIKE hrbb_file.hrbb02,  
        hrbb02_desc     LIKE hrag_file.hrag07,
        hrbb03          LIKE hrbb_file.hrbb03,
        hrbb03_desc     LIKE hrba_file.hrba02,
        hrbb04          LIKE hrbb_file.hrbb04,
        hrbb12          LIKE hrbb_file.hrbb12,       #add by zhangbo130606
        hrbb05          LIKE hrbb_file.hrbb05,
        hrbb06          LIKE hrbb_file.hrbb06, 
        hrbb07          LIKE hrbb_file.hrbb07,
        hrbb08          LIKE hrbb_file.hrbb08,
        hrbb09          LIKE hrbb_file.hrbb09, 
        hrbb10          LIKE hrbb_file.hrbb10,
        hrbb11          LIKE hrbb_file.hrbb11,
        hrbb13          LIKE hrbb_file.hrbb13,
        hrbb14          LIKE hrbb_file.hrbb14,
        hrbb15          LIKE hrbb_file.hrbb15
                    END RECORD,
    g_wc2           STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5
    
DEFINE g_hrbb00   DYNAMIC ARRAY OF RECORD
         hrbb00         LIKE hrbb_file.hrbb00
                  END RECORD                     
 
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
    OPEN WINDOW i018_w AT p_row,p_col WITH FORM "ghr/42f/ghri018"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()

    LET g_wc2 = '1=1'
    CALL i018_b_fill(g_wc2)
    CALL i018_menu()
    CLOSE WINDOW i018_w                 
      CALL  cl_used(g_prog,g_time,2)       
         RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i018_menu()
 
   WHILE TRUE
      CALL i018_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i018_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i018_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "import"
            CALL i018_import()
               
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() AND l_ac != 0 THEN #NO.FUN-570199
               IF g_hrbb[l_ac].hrbb01 IS NOT NULL THEN
                  LET g_doc.column1 = "hrbb01"
                  LET g_doc.value1 = g_hrbb[l_ac].hrbb01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrbb),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i018_q()
   CALL i018_b_askkey()
END FUNCTION	
	
FUNCTION i018_b()
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
DEFINE l_hrbb00     LIKE hrbb_file.hrbb00      
DEFINE l_hrat03     LIKE hrat_file.hrat03      #add by zhangbo130719   
DEFINE l_hrbb14     LIKE hrbb_file.hrbb14      #add by nixiang170706 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrbb01,'','','','',hrbb02,'',hrbb03,'',hrbb04,hrbb12,",    #mod by zhangbo130904---add ''
                       "       hrbb05,hrbb06,hrbb07,hrbb08,hrbb09,hrbb10,hrbb11,hrbb13,hrbb14,hrbb15",
                       "  FROM hrbb_file WHERE hrbb00=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i018_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrbb WITHOUT DEFAULTS FROM s_hrbb.*
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
           LET g_hrbb_t.* = g_hrbb[l_ac].*  #BACKUP
           OPEN i018_bcl USING g_hrbb00[l_ac].hrbb00
           IF STATUS THEN
              CALL cl_err("OPEN i018_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i018_bcl INTO g_hrbb[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrbb_t.hrbb01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF

           #hrag02存的是hratid,需要将其显示为hrat01	
           SELECT hrat01 INTO g_hrbb[l_ac].hrbb01 FROM hrat_file
            WHERE hratid = g_hrbb[l_ac].hrbb01
              AND hratacti='Y'
              AND hratconf='Y'
           #姓名  
           SELECT hrat02 INTO g_hrbb[l_ac].hrat02 
             FROM hrat_file
            WHERE hrat01 = g_hrbb[l_ac].hrbb01 
              AND hratacti = 'Y'
              AND hratconf = 'Y'

           #add by zhangbo130904---begin
           #所属公司
           SELECT hraa12 INTO g_hrbb[l_ac].hraa12
             FROM hraa_file,hrat_file
            WHERE hrat01 = g_hrbb[l_ac].hrbb01
              AND hraa01 = hrat03
           #add by zhangbo130904---end

           #部门名称   
           SELECT hrao02 INTO g_hrbb[l_ac].hrao02 
             FROM hrao_file,hrat_file  
            WHERE hrao01=hrat04
              AND hrat01=g_hrbb[l_ac].hrbb01
              AND hraoacti='Y'
           #职位名称
           SELECT hras04 INTO g_hrbb[l_ac].hras04
             FROM hras_file,hrat_file 
            WHERE hras01=hrat05        
              AND hrat01=g_hrbb[l_ac].hrbb01
              AND hrasacti='Y'
           #奖惩类型---代码组
           SELECT hrag07 INTO g_hrbb[l_ac].hrbb02_desc
             FROM hrag_file 
            WHERE hrag01='329'                           #奖惩类型代码组编号为329
              AND hrag06=g_hrbb[l_ac].hrbb02
              
           #奖惩名称
           SELECT hrba02 INTO g_hrbb[l_ac].hrbb03_desc 
             FROM hrba_file 
            WHERE hrba01=g_hrbb[l_ac].hrbb03
            
           IF g_hrbb[l_ac].hrbb07='Y' THEN
                  #mod by zhangbo130719
           	  #CALL cl_set_comp_entry("hrbb08,hrbb09,hrbb10,hrbb11",TRUE)
           	  #CALL cl_set_comp_required("hrbb08,hrbb09,hrbb10,hrbb11",TRUE)
                  CALL cl_set_comp_entry("hrbb08",TRUE)
                  CALL cl_set_comp_required("hrbb08",TRUE)
           ELSE
                  #mod by zhangbo130719
           	  #CALL cl_set_comp_entry("hrbb08,hrbb09,hrbb10,hrbb11",FALSE)
           	  #CALL cl_set_comp_required("hrbb08,hrbb09,hrbb10,hrbb11",FALSE)
                  CALL cl_set_comp_entry("hrbb08",FALSE)
                  CALL cl_set_comp_required("hrbb08",FALSE)
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
         INITIALIZE g_hrbb[l_ac].* TO NULL      #900423
         LET g_hrbb[l_ac].hrbb07='N'
         IF g_hrbb[l_ac].hrbb07='Y' THEN
                #mod by zhangbo130719
           	#CALL cl_set_comp_entry("hrbb08,hrbb09,hrbb10,hrbb11",TRUE)
           	#CALL cl_set_comp_required("hrbb08,hrbb09,hrbb10,hrbb11",TRUE)
                CALL cl_set_comp_entry("hrbb08",TRUE)
                CALL cl_set_comp_required("hrbb08",TRUE)
         ELSE
                #mod by zhangbo130719 
           	#CALL cl_set_comp_entry("hrbb08,hrbb09,hrbb10,hrbb11",FALSE)
           	#CALL cl_set_comp_required("hrbb08,hrbb09,hrbb10,hrbb11",FALSE)
                CALL cl_set_comp_entry("hrbb08",FALSE)
                CALL cl_set_comp_required("hrbb08",FALSE)
         END IF
         LET l_year=YEAR(g_today) USING "&&&&"
         LET l_month=MONTH(g_today) USING "&&"
         LET l_day=DAY(g_today) USING "&&"
         LET l_year=l_year.trim()
         LET l_month=l_month.trim()
         LET l_day=l_day.trim()
         LET l_hrbb00=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,"%" 
         LET l_sql="SELECT MAX(hrbb00) FROM hrbb_file",
                   "  WHERE hrbb00 LIKE '",l_hrbb00,"'"
         PREPARE i018_hrbb00 FROM l_sql
         EXECUTE i018_hrbb00 INTO g_hrbb00[l_ac].hrbb00
         IF cl_null(g_hrbb00[l_ac].hrbb00) THEN 
         	  LET g_hrbb00[l_ac].hrbb00=l_hrbb00[1,8],'0001'
         ELSE
         	  LET l_no=g_hrbb00[l_ac].hrbb00[9,12]
         	  LET l_no=l_no+1 USING "&&&&"
         	  LET g_hrbb00[l_ac].hrbb00=l_hrbb00[1,8],l_no
         END IF	  
         	  	                          
         LET g_hrbb_t.* = g_hrbb[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD hrbb01 
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i018_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        #hrbb02存hratid
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
        
        INSERT INTO hrbb_file(hrbb00,hrbb01,hrbb02,hrbb03,hrbb04,hrbb05,                          #FUN-A30097
                    hrbb06,hrbb07,hrbb08,hrbb09,hrbb10,hrbb11,hrbb12,hrbb13,hrbb14,hrbb15,hrbbacti,
                    hrbbuser,hrbbdate,hrbbgrup,hrbboriu,hrbborig)           #FUN-A30030 ADD POS  #FUN-A80148--mod--    
               VALUES(g_hrbb00[l_ac].hrbb00,l_hratid,
                      g_hrbb[l_ac].hrbb02,g_hrbb[l_ac].hrbb03,              #FUN-A80148--mark--
                      g_hrbb[l_ac].hrbb04,g_hrbb[l_ac].hrbb05,
                      g_hrbb[l_ac].hrbb06,g_hrbb[l_ac].hrbb07,
                      g_hrbb[l_ac].hrbb08,g_hrbb[l_ac].hrbb09,
                      g_hrbb[l_ac].hrbb10,g_hrbb[l_ac].hrbb11,g_hrbb[l_ac].hrbb12,g_hrbb[l_ac].hrbb13,
                      g_hrbb[l_ac].hrbb14,g_hrbb[l_ac].hrbb15,
                      'Y',g_user,g_today,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrbb_file",g_hrbb[l_ac].hrbb01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
       	
    AFTER FIELD hrbb01
       IF NOT cl_null(g_hrbb[l_ac].hrbb01) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
       	                                            AND hratacti='Y'
       	                                            AND hratconf='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此员工编号','!',0)
       	  	  NEXT FIELD hrbb01
       	  END IF

          #add by zhangbo130719---begin
          IF g_hrbb[l_ac].hrbb01 != g_hrbb_t.hrbb01 OR g_hrbb_t.hrbb01 IS NULL THEN
             IF NOT cl_null(g_hrbb[l_ac].hrbb03) AND NOT cl_null(g_hrbb[l_ac].hrbb08) THEN
                SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrbb_file WHERE hrbb01=l_hratid
                                                          AND hrbb03=g_hrbb[l_ac].hrbb03
                                                          AND hrbb08=g_hrbb[l_ac].hrbb08
                IF l_n>0 THEN
                   CALL cl_err('该员工此奖惩编码本薪资月已维护','!',0)
                   NEXT FIELD hrbb01
                END IF
             END IF
          END IF 
          #add by zhangbo130719---end
          
       	  SELECT hrat02 INTO g_hrbb[l_ac].hrat02 
            FROM hrat_file
           WHERE hrat01 = g_hrbb[l_ac].hrbb01  
             AND hratacti = 'Y' 
             AND hratconf = 'Y'

          #add by zhangbo130904---begin
          SELECT hraa12 INTO g_hrbb[l_ac].hraa12 FROM hraa_file,hrat_file
           WHERE hraa01=hrat03
             AND hrat01=g_hrbb[l_ac].hrbb01
          #add by zhangbo130904---end
         
          SELECT hrao02 INTO g_hrbb[l_ac].hrao02 FROM hrao_file,hrat_file
           WHERE hrao01=hrat04
             AND hrat01=g_hrbb[l_ac].hrbb01
             AND hraoacti='Y'
            
          SELECT hras04 INTO g_hrbb[l_ac].hras04 FROM hras_file,hrat_file
           WHERE hras01=hrat05
             AND hrat01=g_hrbb[l_ac].hrbb01
             AND hrasacti='Y'                     	
       	  
       	 DISPLAY BY NAME g_hrbb[l_ac].hrat02,g_hrbb[l_ac].hrao02,g_hrbb[l_ac].hras04
       END IF 
       	
    AFTER FIELD hrbb14
       IF NOT cl_null(g_hrbb[l_ac].hrbb14) THEN 
       	--LET g_hrbb[l_ac].hrbb15=12-g_hrbb[l_ac].hrbb14
          --LET l_year=''
          --SELECT to_number(to_char(g_today,'yyyy')) INTO l_year FROM dual
          SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
         #SELECT SUM(hrbb14) INTO l_hrbb14 FROM hrbb_file WHERE hrbb01=l_hratid
         #modify by nixiang 170725----s---- 
          IF p_cmd='a' THEN 
             SELECT SUM(NVL(hrbb14,0)) INTO l_hrbb14 FROM hrbb_file WHERE hrbb01=l_hratid  
              AND substr(hrbb00,0,4)=substr(g_hrbb00[l_ac].hrbb00,0,4)
          ELSE 
             SELECT SUM(NVL(hrbb14,0)) INTO l_hrbb14 FROM hrbb_file WHERE hrbb01=l_hratid  
              AND substr(hrbb00,0,4)=substr(g_hrbb00[l_ac].hrbb00,0,4) AND hrbb00<>g_hrbb00[l_ac].hrbb00
          END IF
          
          IF cl_null(l_hrbb14) THEN LET l_hrbb14=0 END IF 
         #modify by nixiang 170725----e---- 
        LET g_hrbb[l_ac].hrbb15=12-l_hrbb14-g_hrbb[l_ac].hrbb14 #modify by nixiang 170706 
       	IF g_hrbb[l_ac].hrbb15<0 THEN 
       		LET g_hrbb[l_ac].hrbb15=0
       	END IF 
       	DISPLAY BY NAME g_hrbb[l_ac].hrbb15
       END IF 
    
    AFTER FIELD hrbb02
       IF NOT cl_null(g_hrbb[l_ac].hrbb02) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrag_file WHERE hrag01='329'
       	                                            AND hrag06=g_hrbb[l_ac].hrbb02
       	  IF l_n=0 THEN
       	  	 CALL cl_err("无此奖惩类型","!",0)
       	  	 NEXT FIELD hrbb02
       	  END IF
       	  	
       	  SELECT hrag07 INTO g_hrbb[l_ac].hrbb02_desc FROM hrag_file
       	   WHERE hrag01='329'
       	     AND hrag06=g_hrbb[l_ac].hrbb02
       	  DISPLAY BY NAME g_hrbb[l_ac].hrbb02_desc   
       	  		                                           
       END IF
       #add by nixiang170706---s 对应员工剩余积分为0的情况下不可再继续录入
       IF g_hrbb[l_ac].hrbb02='002' THEN 
          --LET l_year=''
          --SELECT to_number(to_char(g_today,'yyyy')) INTO l_year FROM dual
          SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
          SELECT SUM(hrbb14) INTO l_hrbb14 FROM hrbb_file WHERE hrbb01=l_hratid 
          AND substr(hrbb00,0,4)=substr(g_hrbb00[l_ac].hrbb00,0,4)
          IF l_hrbb14>=12 THEN 
             CALL cl_err("此员工的已扣积分已大于等于12分","!",0)
             NEXT FIELD hrbb02
          END IF 
       END IF           
       #add by nixiang170706---e 对应员工剩余积分为0的情况下不可再继续录入
       	
    AFTER FIELD hrbb03
       IF NOT cl_null(g_hrbb[l_ac].hrbb03) THEN
          IF cl_null(g_hrbb[l_ac].hrbb02) THEN
          	 LET g_hrbb[l_ac].hrbb03=''
       	     CALL cl_err("录入奖惩编码前必须先录入奖惩类型","!",0)
       	     NEXT FIELD hrbb02
          END IF
          
          LET l_n=0 
          SELECT COUNT(*) INTO l_n FROM hrba_file
           WHERE hrba03=g_hrbb[l_ac].hrbb02
             AND hrba01=g_hrbb[l_ac].hrbb03
             AND hrbaacti='Y'
          IF l_n=0 THEN
          	 CALL cl_err('无此奖惩编码','!',0)
          	 NEXT FIELD hrbb03
          END IF

          #add by zhangbo130719---begin
          IF g_hrbb[l_ac].hrbb03 != g_hrbb_t.hrbb03 OR g_hrbb_t.hrbb03 IS NULL THEN
             IF NOT cl_null(g_hrbb[l_ac].hrbb01) AND NOT cl_null(g_hrbb[l_ac].hrbb08) THEN
                SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrbb_file WHERE hrbb01=l_hratid
                                                          AND hrbb03=g_hrbb[l_ac].hrbb03
                                                          AND hrbb08=g_hrbb[l_ac].hrbb08
                IF l_n>0 THEN
                   CALL cl_err('该员工此奖惩编码本薪资月已维护','!',0)
                   NEXT FIELD hrbb03
                END IF
             END IF
          END IF
          #add by zhangbo130719---end
          	
          SELECT hrba02 INTO g_hrbb[l_ac].hrbb03_desc FROM hrba_file
           WHERE hrba01=g_hrbb[l_ac].hrbb03
             AND hrbaacti='Y'
          DISPLAY BY NAME g_hrbb[l_ac].hrbb03_desc    	
          	
       END IF 
    
    ON CHANGE hrbb07
       IF g_hrbb[l_ac].hrbb07='Y' THEN
          #mod by zhangbo130719
          #CALL cl_set_comp_entry("hrbb08,hrbb09,hrbb10,hrbb11",TRUE)
          #CALL cl_set_comp_required("hrbb08,hrbb09,hrbb10,hrbb11",TRUE)
          CALL cl_set_comp_entry("hrbb08",TRUE)
          CALL cl_set_comp_required("hrbb08",TRUE)
       ELSE
          #mod by zhangbo130719
          LET g_hrbb[l_ac].hrbb08=''
          #LET g_hrbb[l_ac].hrbb09=''
          #LET g_hrbb[l_ac].hrbb10=''
          #LET g_hrbb[l_ac].hrbb11=''
          #CALL cl_set_comp_entry("hrbb08,hrbb09,hrbb10,hrbb11",FALSE)
          #CALL cl_set_comp_required("hrbb08,hrbb09,hrbb10,hrbb11",FALSE)
          CALL cl_set_comp_entry("hrbb08",FALSE)
          CALL cl_set_comp_required("hrbb08",FALSE)
       END IF
       	
    AFTER FIELD hrbb08
       IF NOT cl_null(g_hrbb[l_ac].hrbb08) THEN
          IF NOT cl_null(g_hrbb[l_ac].hrbb01) THEN       #add by zhangbo130719
             SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01   #add by zhangbo130719
       	     LET l_n=0
       	     #SELECT COUNT(*) INTO l_n FROM hrac_file WHERE hrac01=g_hrbb[l_ac].hrbb08     #mark by zhangbo130719
             SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrbb[l_ac].hrbb08      #add by zhangbo130719
                                                       AND hrct03=l_hrat03
       	     IF l_n=0 THEN
       	  	 CALL cl_err('无此薪资月','!',0)
       	  	 NEXT FIELD hrbb08
       	     END IF             
          END IF
          
          #add by zhangbo130719---begin
          IF g_hrbb[l_ac].hrbb08 != g_hrbb_t.hrbb08 OR g_hrbb_t.hrbb08 IS NULL THEN
             IF NOT cl_null(g_hrbb[l_ac].hrbb01) AND NOT cl_null(g_hrbb[l_ac].hrbb03) THEN
                SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01
                LET l_n=0
                SELECT COUNT(*) INTO l_n FROM hrbb_file WHERE hrbb01=l_hratid
                                                          AND hrbb03=g_hrbb[l_ac].hrbb03
                                                          AND hrbb08=g_hrbb[l_ac].hrbb08
                IF l_n>0 THEN
                   CALL cl_err('该员工此奖惩编码本薪资月已维护','!',0)
                   NEXT FIELD hrbb08
                END IF
             END IF
          END IF
          #add by zhangbo130719---end
          
       END IF	  

    #mark by zhangbo130719---begin
    {   	
    AFTER FIELD hrbb09
       IF NOT cl_null(g_hrbb[l_ac].hrbb09) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrac_file WHERE hrac02=g_hrbb[l_ac].hrbb09
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此财年月','!',0)
       	  	 NEXT FIELD hrbb09
       	  END IF
       END IF    			 	  		
       	
    AFTER FIELD hrbb10
       IF NOT cl_null(g_hrbb[l_ac].hrbb10) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrac_file WHERE hrac01=g_hrbb[l_ac].hrbb10
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此财年','!',0)
       	  	 NEXT FIELD hrbb10
       	  END IF
       END IF    	    
       	
    AFTER FIELD hrbb11
       IF NOT cl_null(g_hrbb[l_ac].hrbb11) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrac_file WHERE hrac02=g_hrbb[l_ac].hrbb11
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此财年月','!',0)
       	  	 NEXT FIELD hrbb11
       	  END IF
       END IF    	
    }
    #mark by zhangbo130719---end
   	       	
    BEFORE DELETE                            
       IF g_hrbb00[l_ac].hrbb00 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrbb01"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrbb[l_ac].hrbb01      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrbb_file WHERE hrbb00 = g_hrbb00[l_ac].hrbb00
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrbb_file",g_hrbb_t.hrbb01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrbb[l_ac].* = g_hrbb_t.*
         CLOSE i018_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrbb[l_ac].hrbb01,-263,0)
          LET g_hrbb[l_ac].* = g_hrbb_t.*
       ELSE
         SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrbb[l_ac].hrbb01 
         #FUN-A30030 END--------------------
          UPDATE hrbb_file SET hrbb01=l_hratid,
                               hrbb02=g_hrbb[l_ac].hrbb02,
                               hrbb03=g_hrbb[l_ac].hrbb03,
                               hrbb04=g_hrbb[l_ac].hrbb04,
                               hrbb05=g_hrbb[l_ac].hrbb05,
                               hrbb06=g_hrbb[l_ac].hrbb06,
                               hrbb07=g_hrbb[l_ac].hrbb07,
                               hrbb08=g_hrbb[l_ac].hrbb08,
                               hrbb09=g_hrbb[l_ac].hrbb09,
                               hrbb10=g_hrbb[l_ac].hrbb10,
                               hrbb11=g_hrbb[l_ac].hrbb11,   
                               hrbb12=g_hrbb[l_ac].hrbb12,   
                               hrbb13=g_hrbb[l_ac].hrbb13,   
                               hrbb14=g_hrbb[l_ac].hrbb14,   
                               hrbb15=g_hrbb[l_ac].hrbb15, 
                               hrbbmodu=g_user,
                               hrbbdate=g_today
                WHERE hrbb00 = g_hrbb00[l_ac].hrbb00
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrbb_file",g_hrbb_t.hrbb01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrbb[l_ac].* = g_hrbb_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrbb[l_ac].* = g_hrbb_t.*
          END IF
          CLOSE i018_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i018_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrbb01)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrat01"
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb01
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb01
             DISPLAY BY NAME g_hrbb[l_ac].hrbb01
             NEXT FIELD hrbb01
             
           WHEN INFIELD(hrbb02)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb02
             LET g_qryparam.arg1='329'
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb02
             DISPLAY BY NAME g_hrbb[l_ac].hrbb02
             NEXT FIELD hrbb02
           
           WHEN INFIELD(hrbb03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrba01"
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb03
             LET g_qryparam.where = " hrba03='",g_hrbb[l_ac].hrbb02,"'"
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb03
             DISPLAY BY NAME g_hrbb[l_ac].hrbb03
             NEXT FIELD hrbb03
          
           WHEN INFIELD(hrbb08)
             CALL cl_init_qry_var()
             #LET g_qryparam.form = "q_hrac01"    #mark by zhangbo130719
             LET g_qryparam.form = "q_hrct11"     #add by zhangbo130719
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb08
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb08
             DISPLAY BY NAME g_hrbb[l_ac].hrbb08
             NEXT FIELD hrbb08
           
           #mark by zhangbo130719---begin
           {
           WHEN INFIELD(hrbb09)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrac02"
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb09
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb09
             DISPLAY BY NAME g_hrbb[l_ac].hrbb09
             NEXT FIELD hrbb09
          
           WHEN INFIELD(hrbb10)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrac01"
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb10
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb10
             DISPLAY BY NAME g_hrbb[l_ac].hrbb10
             NEXT FIELD hrbb10
             
           WHEN INFIELD(hrbb11)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_hrac02"
             LET g_qryparam.default1 = g_hrbb[l_ac].hrbb11
             CALL cl_create_qry() RETURNING g_hrbb[l_ac].hrbb11
             DISPLAY BY NAME g_hrbb[l_ac].hrbb11
             NEXT FIELD hrbb11             
           }
           #mark by zhangbo130719---end
   
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
 
    CLOSE i018_bcl
    COMMIT WORK
END FUNCTION      	     		
	
FUNCTION i018_b_askkey()
    CLEAR FORM
    CALL g_hrbb.clear()
 
    CONSTRUCT g_wc2 ON hrbb01,hrbb02,hrbb03,hrbb04,hrbb12,hrbb05,hrbb06,hrbb07,
                       hrbb08,hrbb09,hrbb10,hrbb11,hrbb13,hrbb14,hrbb15                       
         FROM s_hrbb[1].hrbb01,s_hrbb[1].hrbb02,s_hrbb[1].hrbb03,                                  
              s_hrbb[1].hrbb04,s_hrbb[1].hrbb12,s_hrbb[1].hrbb05,s_hrbb[1].hrbb06,
              s_hrbb[1].hrbb07,s_hrbb[1].hrbb08,s_hrbb[1].hrbb09,
              s_hrbb[1].hrbb10,s_hrbb[1].hrbb11,s_hrbb[1].hrbb13,s_hrbb[1].hrbb14,s_hrbb[1].hrbb15
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrbb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrbb[1].hrbb01
               NEXT FIELD hrbb01
               
            WHEN INFIELD(hrbb02)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrag06"
               LET g_qryparam.state = "c" 
               LET g_qryparam.arg1='329'  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbb02
               NEXT FIELD hrbb02
            
            WHEN INFIELD(hrbb03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrba01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbb03
               NEXT FIELD hrbb03
            
            WHEN INFIELD(hrbb08)
               CALL cl_init_qry_var()
               #LET g_qryparam.form = "q_hrac01"    #mark by zhangbo130719
               LET g_qryparam.form = "q_hrct11"     #add by zhangbo130719
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbb08
               NEXT FIELD hrbb08

            #mark by zhangbo130719---begin
            {   
            WHEN INFIELD(hrbb09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrac02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbb09
               NEXT FIELD hrbb09
               
            WHEN INFIELD(hrbb10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrac01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbb10
               NEXT FIELD hrbb10
               
            WHEN INFIELD(hrbb11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrac02"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrbb11
               NEXT FIELD hrbb11
            }
            #mark by zhangbo130719---end
   
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hrbbuser', 'hrbbgrup') #FUN-980030
   CALL cl_replace_str(g_wc2,'hrbb01','hrat01') RETURNING g_wc2  
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i018_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i018_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrbb00,hrbb01,'','','','',hrbb02,'',hrbb03,'',hrbb04,hrbb12,hrbb05,",   #mod by zhangbo130904--add ''
                   "       hrbb06,hrbb07,hrbb08,hrbb09,hrbb10,hrbb11,hrbb13,hrbb14,hrbb15 ",
                   " FROM hrbb_file,hrat_file",
                   " WHERE ", p_wc2 CLIPPED,
                   "   AND hratid=hrbb01 ",
                   " ORDER BY 1" 
 
    PREPARE i018_pb FROM g_sql
    DECLARE hrbb_curs CURSOR FOR i018_pb
 
    CALL g_hrbb.clear()
    CALL g_hrbb00.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrbb_curs INTO g_hrbb00[g_cnt].*,g_hrbb[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        #显示工号
        SELECT hrat01 INTO g_hrbb[g_cnt].hrbb01 FROM hrat_file 
         WHERE hratid=g_hrbb[g_cnt].hrbb01
           AND hratacti='Y'
           AND hratconf='Y'
        #姓名   
        SELECT hrat02 
          INTO g_hrbb[g_cnt].hrat02
          FROM hrat_file
         WHERE hrat01=g_hrbb[g_cnt].hrbb01
           AND hratacti='Y'
           AND hratconf='Y'

        #add by zhangbo130904---begin
        #公司名称
        SELECT hraa12 INTO g_hrbb[g_cnt].hraa12 FROM hraa_file,hrat_file
         WHERE hraa01=hrat03
           AND hrat01=g_hrbb[g_cnt].hrbb01
        #add by zhangbo130904---end

        #部门名称
        SELECT hrao02 INTO g_hrbb[g_cnt].hrao02 FROM hrao_file,hrat_file
         WHERE hrao01=hrat04
           AND hrat01=g_hrbb[g_cnt].hrbb01
           AND hraoacti='Y'
        #职位名称
        SELECT hras04 INTO g_hrbb[g_cnt].hras04 FROM hras_file,hrat_file
         WHERE hras01=hrat05
           AND hrat01=g_hrbb[g_cnt].hrbb01
           AND hrasacti='Y'
        #奖惩类型名称
        SELECT hrag07 INTO g_hrbb[g_cnt].hrbb02_desc FROM hrag_file
         WHERE hrag01='329'
           AND hrag06=g_hrbb[g_cnt].hrbb02
           AND hragacti='Y'      
        #奖惩名称
        SELECT hrba02 INTO g_hrbb[g_cnt].hrbb03_desc FROM hrba_file
         WHERE hrba01=g_hrbb[g_cnt].hrbb03
           AND hrbaacti='Y'    
                                  
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrbb.deleteElement(g_cnt)
    CALL g_hrbb00.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i018_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrbb TO s_hrbb.* ATTRIBUTE(COUNT=g_rec_b)
 
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
      
      ON ACTION import  
         LET g_action_choice="import"
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

FUNCTION i018_import()
DEFINE l_file   LIKE  type_file.chr200,
       l_filename LIKE type_file.chr200,
       l_sql    STRING,
       l_data   VARCHAR(300),
       l_hrbb10 LIKE hrbb_file.hrbb10,
       p_argv1  LIKE type_file.num5
DEFINE l_year       STRING
DEFINE l_month      STRING 
DEFINE l_day        STRING
DEFINE l_no         LIKE type_file.chr10 
DEFINE l_hrbb00     LIKE hrbb_file.hrbb00   
DEFINE l_count  LIKE type_file.num5,
       m_tempdir  VARCHAR(240) ,
       m_file     VARCHAR(256) ,
       sr     RECORD    
         hrbb00  LIKE hrbb_file.hrbb00,
         hrbb01  LIKE hrbb_file.hrbb01,
         hrbb02  LIKE hrbb_file.hrbb02,
         hrbb03  LIKE hrbb_file.hrbb03,
         hrbb04  LIKE hrbb_file.hrbb04,
         hrbb05  LIKE hrbb_file.hrbb05,
         hrbb06  LIKE hrbb_file.hrbb06,
         hrbb07  LIKE hrbb_file.hrbb07,
         hrbb08  LIKE hrbb_file.hrbb08,
         hrbb09  LIKE hrbb_file.hrbb09,
         hrbb10  LIKE hrbb_file.hrbb10,
         hrbb11  LIKE hrbb_file.hrbb11,
         hrbb12  LIKE hrbb_file.hrbb12,
         hrbb13  LIKE hrbb_file.hrbb13,
         hrbb14  LIKE hrbb_file.hrbb14,
         hrbb15  LIKE hrbb_file.hrbb15
         
              END RECORD      
DEFINE    l_tok       base.stringTokenizer 
DEFINE xlapp,iRes,iRow,i,j     INTEGER
DEFINE li_k ,li_i_r   LIKE  type_file.num5
DEFINE l_n     LIKE type_file.num5
DEFINE l_racacti     LIKE rac_file.racacti
DEFINE    l_imaacti  LIKE ima_file.imaacti, 
          l_ima02    LIKE ima_file.ima02,
          l_ima25    LIKE ima_file.ima25

DEFINE    l_obaacti  LIKE oba_file.obaacti,
          l_oba02    LIKE oba_file.oba02

DEFINE    l_tqaacti  LIKE tqa_file.tqaacti,
          l_tqa02    LIKE tqa_file.tqa02,
          l_tqa05    LIKE tqa_file.tqa05,
          l_tqa06    LIKE tqa_file.tqa06
DEFINE l_gfe02     LIKE gfe_file.gfe02
DEFINE l_gfeacti   LIKE gfe_file.gfeacti
DEFINE    l_flag    LIKE type_file.num5,
          l_fac     LIKE ima_file.ima31_fac 
DEFINE   l_hrbb  RECORD  LIKE hrbb_file.*


   LET g_errno = ' '
   LET l_n=0
   CALL s_showmsg_init() #初始化
   
   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   MESSAGE l_file
   IF NOT cl_null(l_file) THEN 
       LET l_count =  LENGTH(l_file)
          IF l_count = 0 THEN  
             LET g_success = 'N'
             RETURN 
          END IF 
       INITIALIZE sr.* TO NULL
       LET li_k = 1
       LET li_i_r = 1
       LET g_cnt = 1 
       LET l_sql = l_file
     
       CALL ui.interface.frontCall('WinCOM','CreateInstance',
                                   ['Excel.Application'],[xlApp])
       IF xlApp <> -1 THEN
          LET l_file = "C:\\Users\\dcms1\\Desktop\\import.xls"
          CALL ui.interface.frontCall('WinCOM','CallMethod',
                                      [xlApp,'WorkBooks.Open',l_sql],[iRes])
                                    # [xlApp,'WorkBooks.Open',"C:/Users/dcms1/Desktop/import.xls"],[iRes]) 

          IF iRes <> -1 THEN
             CALL ui.interface.frontCall('WinCOM','GetProperty',
                  [xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
             IF iRow > 0 THEN  
                LET g_success = 'Y'
                BEGIN WORK  
              # CALL s_errmsg_init()
                CALL s_showmsg_init()
                FOR i = 1 TO iRow                                                                   
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[sr.hrbb01])   #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[sr.hrbb02])   #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[sr.hrbb03])   #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[sr.hrbb04])   #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[sr.hrbb12])   #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[sr.hrbb05])   #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[sr.hrbb06])  #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[sr.hrbb07])  #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[sr.hrbb08])  #
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[sr.hrbb13])  #备注
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[sr.hrbb14])
                    CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[sr.hrbb15])
                 
                IF NOT cl_null(sr.hrbb01) AND NOT cl_null(sr.hrbb12) AND NOT cl_null(sr.hrbb02) AND NOT cl_null(sr.hrbb03) AND NOT cl_null(sr.hrbb08) THEN
                	 LET l_year=YEAR(g_today) USING "&&&&"
                   LET l_month=MONTH(g_today) USING "&&"
                   LET l_day=DAY(g_today) USING "&&"
                   LET l_year=l_year.trim()
                   LET l_month=l_month.trim()
                   LET l_day=l_day.trim()
                   LET l_hrbb00=l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,"%" 
                   LET l_sql="SELECT MAX(hrbb00) FROM hrbb_file",
                             "  WHERE hrbb00 LIKE '",l_hrbb00,"'"
                   PREPARE i018_hrbb00_1 FROM l_sql
                   EXECUTE i018_hrbb00_1 INTO sr.hrbb00
                   IF cl_null(sr.hrbb00) THEN 
                   	  LET sr.hrbb00=l_hrbb00[1,8],'0001'
                   ELSE
                   	  LET l_no=sr.hrbb00[9,12]
                   	  LET l_no=l_no+1 USING "&&&&"
                   	  LET sr.hrbb00=l_hrbb00[1,8],l_no
                   END IF	
                	                	
                   SELECT hratid INTO sr.hrbb01 FROM hrat_file WHERE hrat01=sr.hrbb01

                   IF i > 1 THEN
                    INSERT INTO hrbb_file(hrbb00,hrbb01,hrbb02,hrbb03,hrbb04,hrbb05,hrbb06,hrbb07,hrbb08,hrbb09,hrbb12,hrbb13,hrbb14,hrbb15,hrbbacti,hrbbuser,hrbbgrup,hrbbdate,hrbborig,hrbboriu)
                      VALUES (sr.hrbb00,sr.hrbb01,sr.hrbb02,sr.hrbb03,sr.hrbb04,sr.hrbb05,sr.hrbb06,sr.hrbb07,sr.hrbb08,sr.hrbb09,sr.hrbb12,sr.hrbb13,sr.hrbb14,sr.hrbb15,'Y',g_user,g_grup,g_today,g_grup,g_user)
 
                    IF SQLCA.sqlcode THEN 
                       CALL cl_err3("ins","hrbb_file",sr.hrbb01,'',SQLCA.sqlcode,"","",1)   
                       LET g_success  = 'N'
                       CONTINUE FOR 
                    END IF 
                   END IF 
                END IF 
                   #LET i = i + 1
                  # LET l_ac = g_cnt 
                                
                END FOR 
                IF g_success = 'N' THEN 
                   ROLLBACK WORK 
                   CALL s_showmsg() 
                ELSE IF g_success = 'Y' THEN 
                        COMMIT WORK 
                        CALL cl_err( '导入成功','!', 1 )
                     END IF 
                END IF 
            END IF
          ELSE 
              DISPLAY 'NO FILE'
              CALL cl_err( '打开工作簿失败','!', 1 )
          END IF
       ELSE
           DISPLAY 'NO EXCEL'
           CALL cl_err( '打开文件失败','!', 1 )
       END IF     
       CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
       CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes]) 
       
#       SELECT * INTO g_hrbb.* FROM hrbb_file
#       WHERE hrbbid=l_hrbbid
#       
#       CALL i044_show()
   END IF 

END FUNCTION 

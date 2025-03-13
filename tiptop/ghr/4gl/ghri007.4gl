# on..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri007.4gl

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrax    DYNAMIC ARRAY OF RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrax01    LIKE hrax_file.hrax01,    
                  hrax02    LIKE hrax_file.hrax02,  
                  hrax03    LIKE hrax_file.hrax03,
                  hraa12    LIKE hraa_file.hraa12,
                  hrax04    LIKE hrax_file.hrax04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrax05    LIKE hrax_file.hrax05,
                  hras04    LIKE hras_file.hras04,
                  hrax11    LIKE hrax_file.hrax11,
                  hrax06    LIKE hrax_file.hrax06,
                  hrax07    LIKE hrax_file.hrax07,
                  hrat02    LIKE hrat_file.hrat02, 
                  hrax09    LIKE hrax_file.hrax09,
                  hrax08    LIKE hrax_file.hrax08, 
                  hrax14    LIKE hrax_file.hrax14,
                  hrag07    LIKE hrag_file.hrag07,
                  hraxud01  LIKE hrax_file.hraxud01,
                  hrax16    LIKE hrax_file.hrax16,
                  hrax17    LIKE hrax_file.hrax17,
                  hrax18    LIKE hrax_file.hrax18,
                  hrax19    LIKE hrax_file.hrax19,
                  hrag07a   LIKE hrag_file.hrag07,
                  hrax20    LIKE hrax_file.hrax20,
                  hrag07b   LIKE hrag_file.hrag07
               END RECORD,
 
       g_hrax_t RECORD
                  sure      LIKE type_file.chr1,   #選擇
                  hrax01    LIKE hrax_file.hrax01,    
                  hrax02    LIKE hrax_file.hrax02,  
                  hrax03    LIKE hrax_file.hrax03,
                  hraa12    LIKE hraa_file.hraa12,
                  hrax04    LIKE hrax_file.hrax04,
                  hrao02    LIKE hrao_file.hrao02,
                  hrax05    LIKE hrax_file.hrax05,
                  hras04    LIKE hras_file.hras04,
                  hrax11    LIKE hrax_file.hrax11,
                  hrax06    LIKE hrax_file.hrax06,
                  hrax07    LIKE hrax_file.hrax07,
                  hrat02    LIKE hrat_file.hrat02, 
                  hrax09    LIKE hrax_file.hrax09,
                  hrax08    LIKE hrax_file.hrax08, 
                  hrax14    LIKE hrax_file.hrax14,
                  hrag07    LIKE hrag_file.hrag07,
                  hraxud01  LIKE hrax_file.hraxud01,
                  hrax16    LIKE hrax_file.hrax16,
                  hrax17    LIKE hrax_file.hrax17,
                  hrax18    LIKE hrax_file.hrax18,
                  hrax19    LIKE hrax_file.hrax19,
                  hrag07a   LIKE hrag_file.hrag07,
                  hrax20    LIKE hrax_file.hrax20,
                  hrag07b   LIKE hrag_file.hrag07
               END RECORD,
    g_hrax_ins     RECORD LIKE hrax_file.*,
    g_success      LIKE type_file.chr1,
    g_hraa02       LIKE hraa_file.hraa02,
    g_wc2           STRING,
    g_wc            STRING,
    g_sql           STRING,
    g_cmd           LIKE type_file.chr1000, 
    g_rec_b         LIKE type_file.num5,                
    l_ac            LIKE type_file.num5,
    g_flag          LIKE type_file.chr1,
    g_hrax21        LIKE hrax_file.hrax21,
    g_hrat         RECORD LIKE hrat_file.*
 
DEFINE g_forupd_sql STRING   
DEFINE g_cnt        LIKE type_file.num10  
DEFINE g_cnt2        LIKE type_file.num10     
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_i          LIKE type_file.num5     
DEFINE g_on_change  LIKE type_file.num5      
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5       
DEFINE g_str        STRING 
DEFINE p_row,p_col   LIKE type_file.num5 

MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW i007_w AT p_row,p_col WITH FORM "ghr/42f/ghri007"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_init()
    LET g_success = 'Y'
    LET g_wc = '1=1'
    CALL i007_b_fill(g_wc)
    CALL i007_menu()
    CLOSE WINDOW i007_w 
 
   
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN


FUNCTION i007_menu()
	
 
   WHILE TRUE
   	  
      CALL i007_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i007_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i007_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         
         WHEN "normal"
             IF cl_chk_act_auth() THEN
#                  CALL i007_normal()
             END IF
         
         WHEN "deferred"
             IF cl_chk_act_auth() THEN
             	  CALL i007_deferred()
             END IF
          
         WHEN "dimission"
             IF cl_chk_act_auth() THEN
             	  CALL i007_dimission()
             END IF 
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrax),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION 
	
FUNCTION i007_q()
   CALL i007_b_askkey()
END FUNCTION	
	
FUNCTION i007_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1,
    l_hrad03        LIKE hrad_file.hrad03  
 DEFINE l_count   LIKE  type_file.num5
 DEFINE l_year    LIKE  type_file.num5
 DEFINE l_month   LIKE  type_file.num5 
 DEFINE l_day     LIKE  type_file.num5
 DEFINE l_mod     LIKE  type_file.num5   
 DEFINE l_length      LIKE type_file.num5
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
     LET g_sql="SELECT '',hrax01,hrax02,hrax03,'',hrax04,'',hrax05,'',hrax11,",
               "hrax06,hrax07,'',hrax09,hrax08,hrax14,'',hraxud01,hrax16,hrax17,hrax18,hrax19,'',hrax20,'',''",
               "  FROM hrax_file WHERE hrax01=?  FOR UPDATE"
    #LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    PREPARE g_forupd_sql FROM g_sql
    DECLARE i007_bcl CURSOR FOR g_forupd_sql      
 
    INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
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
           LET g_hrax_t.* = g_hrax[l_ac].*  #BACKUP
           OPEN i007_bcl USING g_hrax_t.hrax01
           IF STATUS THEN
              CALL cl_err("OPEN i007_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i007_bcl INTO g_hrax[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrax_t.hrax01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_hrax[l_ac].sure = 'Y'
              DISPLAY g_hrax[l_ac].sure TO sure
              SELECT hraa12 INTO g_hrax[l_ac].hraa12 FROM hraa_file 
               WHERE hraa01=g_hrax[l_ac].hrax03
                 AND hraaacti='Y'
               DISPLAY BY NAME g_hrax[l_ac].hraa12 
             SELECT hrao02 INTO g_hrax[l_ac].hrao02 FROM hrao_file
              WHERE hrao01 = g_hrax[l_ac].hrax04	
               DISPLAY BY NAME g_hrax[l_ac].hrao02
             SELECT hras04 INTO g_hrax[l_ac].hras04 FROM hras_file
              WHERE hras01 = g_hrax[l_ac].hrax05
              DISPLAY BY NAME g_hrax[l_ac].hras04
       	     SELECT hrat02 INTO g_hrax[l_ac].hrat02 FROM hrat_file
              WHERE hrat01 = g_hrax[l_ac].hrax07
           	  DISPLAY BY NAME g_hrax[l_ac].hrat02
       	     SELECT hrad03 INTO g_hrax[l_ac].hrax11 FROM hrad_file
              WHERE hrad02 = '4001'
              DISPLAY g_hrax[l_ac].hrax11 TO hrax11
             SELECT hrag07 INTO g_hrax[l_ac].hrag07 FROM hrag_file
              WHERE hrag06 = g_hrax[l_ac].hrax14 AND hrag01 = '314'
              DISPLAY BY NAME g_hrax[l_ac].hrag07
             SELECT hrag07 INTO g_hrax[l_ac].hrag07a FROM hrag_file
              WHERE hrag06 = g_hrax[l_ac].hrax19 AND hrag01 = '317'
              DISPLAY BY NAME g_hrax[l_ac].hrag07a
             SELECT hrag07 INTO g_hrax[l_ac].hrag07b FROM hrag_file
              WHERE hrag06 = g_hrax[l_ac].hrax20 AND hrag01 = '337'
              DISPLAY BY NAME g_hrax[l_ac].hrag07b
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
         INITIALIZE g_hrax[l_ac].* TO NULL      #900423             
         LET g_hrax_t.* = g_hrax[l_ac].*         
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         LET g_hrax[l_ac].sure = 'Y'
         DISPLAY g_hrax[l_ac].sure TO sure
         SELECT hrad03 INTO g_hrax[l_ac].hrax11 FROM hrad_file
          WHERE hrad02 = '4001'
         DISPLAY g_hrax[l_ac].hrax11 TO hrax11
         NEXT FIELD hrax01
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i007_bcl
           CANCEL INSERT
        END IF
        
        CALL i007_inshrax()
        
      #  IF cl_null(g_hrax_ins.hrax01) OR cl_null(g_hrax_ins.hrax02) OR cl_null(g_hrax_ins.hrax06) OR
      #  	 cl_null(g_hrax_ins.hrax09) OR cl_null(g_hrax_ins.hrax08) OR cl_null(g_hrax_ins.hrax16) OR
      #  	 cl_null(g_hrax_ins.hrax17) OR cl_null(g_hrax_ins.hrax18) OR cl_null(g_hrax_ins.hraxud01)  THEN
      #     CALL cl_err('必输栏位不可为空','!',0)
      #     LET g_rec_b = g_rec_b+1
      #     NEXT FIELD  hrax01
      #  END IF
        BEGIN WORK                    #FUN-680010
        
        INSERT INTO hrax_file VALUES (g_hrax_ins.*)
        
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrax_file",g_hrax[l_ac].hrax01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cnt  
           COMMIT WORK  
        END IF        	  	
        	
       	
    AFTER FIELD hrax03
       IF NOT cl_null(g_hrax[l_ac].hrax03) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hraa_file 
       	   WHERE hraa01=g_hrax[l_ac].hrax03 AND hraaacti='Y'
       	  IF l_n=0 THEN
       	  	  CALL cl_err('无此公司编号','!',0)
       	  	  NEXT FIELD hrax03
       	  END IF
          SELECT hraa12 INTO g_hrax[l_ac].hraa12 FROM hraa_file 
           WHERE hraa01=g_hrax[l_ac].hrax03
             AND hraaacti='Y'
          DISPLAY BY NAME g_hrax[l_ac].hraa12                                             	
       END IF 
       	   	           	
    AFTER FIELD hrax04                        
       IF NOT cl_null(g_hrax[l_ac].hrax04) THEN
       	 LET l_n = 0
       	 SELECT COUNT(*) INTO l_n FROM hrao_file WHERE hrao01 = g_hrax[l_ac].hrax04
       	  IF l_n = 0 THEN
       	  	 CALL cl_err('无此部门编号','!',0)
       	  	  NEXT FIELD hrax04
       	  END IF
        IF NOT cl_null(g_hrax[l_ac].hrax05) THEN
          SELECT COUNT(*) INTO l_n FROM hrap_file WHERE hrap01 = g_hrax[l_ac].hrax04 AND hrap05 = g_hrax[l_ac].hrax05
          IF l_n = 0 THEN
             CALL cl_err('职位与部门不匹配','!',0)
             LET g_hrax[l_ac].hrax04 = ''
             DISPLAY BY NAME g_hrax[l_ac].hrax04
             NEXT FIELD hrax04
          END IF
        END IF
          SELECT hrao02 INTO g_hrax[l_ac].hrao02 FROM hrao_file
           WHERE hrao01 = g_hrax[l_ac].hrax04	
          DISPLAY BY NAME g_hrax[l_ac].hrao02
       END IF
   
    AFTER FIELD hrax05
       IF NOT cl_null(g_hrax[l_ac].hrax05) THEN
          LET l_n = 0 
          SELECT COUNT(*) INTO l_n FROM hras_file WHERE hras01 = g_hrax[l_ac].hrax05 
          IF l_n = 0 THEN
       	  	 CALL cl_err('无此职位编号','!',0)
       	  	  NEXT FIELD hrax05
       	  END IF
          SELECT COUNT(*) INTO l_n FROM hrap_file WHERE hrap01 = g_hrax[l_ac].hrax04 AND hrap05 = g_hrax[l_ac].hrax05
          IF l_n = 0 THEN
             CALL cl_err('职位与部门不匹配','!',0)
             LET g_hrax[l_ac].hrax05 = ''
             DISPLAY BY NAME g_hrax[l_ac].hrax05
             NEXT FIELD hrax04
          END IF
       	  SELECT hras04 INTO g_hrax[l_ac].hras04 FROM hras_file
           WHERE hras01 = g_hrax[l_ac].hrax05
          DISPLAY BY NAME g_hrax[l_ac].hras04
       END IF
       	     	
       	
    AFTER FIELD hrax07
       IF NOT cl_null(g_hrax[l_ac].hrax07) THEN
          LET l_n = 0
          SELECT COUNT(*) INTO l_n FROM hrat_file
           WHERE hrat01 = g_hrax[l_ac].hrax07
          IF l_n = 0 THEN
       	  	 CALL cl_err('无此主管编号','!',0)
       	  	  NEXT FIELD hrax07
       	  END IF  
       	  SELECT hrat02 INTO g_hrax[l_ac].hrat02 FROM hrat_file
           WHERE hrat01 = g_hrax[l_ac].hrax07
       	  DISPLAY BY NAME g_hrax[l_ac].hrat02
       END IF
       	
     AFTER FIELD hrax08
       IF g_hrax[l_ac].hrax08 < g_hrax[l_ac].hrax09 THEN
       	  CALL cl_err('预计转正日期不可大于试用开始日期','!',0)
       	  NEXT FIELD hrax08
       END IF
     AFTER FIELD hraxud01
       IF g_hrax[l_ac].hrax14='001' AND NOT cl_null(g_hrax[l_ac].hraxud01) THEN 
       	  SELECT LENGTH(g_hrax[l_ac].hraxud01) INTO l_length FROM DUAL    #长度18位
   	 	  	 IF l_length <> 18 OR cl_null(l_length) THEN
   	 	  	 	 CALL cl_err('身份证长度有误','!',1)
   	 	  	 	  LET g_hrax[l_ac].hraxud01=' ' 
   	 	  	 	 NEXT FIELD hrax14
   	 	  	 END IF
   	 	  	 LET l_count = 0 
   	 	  	 SELECT COUNT(*) INTO l_count FROM hraj_file
   	 	  	  WHERE hraj01 = substr(g_hrax[l_ac].hraxud01,1,6)
   	 	  	 IF l_count = 0 OR cl_null(l_count) THEN
   	 	  	 	  CALL cl_err('身份证不存在','!',1)
   	 	  	 	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	  NEXT FIELD hrax14
   	 	  	 END IF	  
   	 	  	 LET l_year = ''
   	 	  	 LET l_year = g_hrax[l_ac].hraxud01[7,10]
   	 	  	 IF l_year > YEAR(g_today) OR l_year <1 OR cl_null(l_year) THEN
   	 	  	 	  CALL cl_err('年份有误','!',1)
   	 	  	 	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	  NEXT FIELD hrax14
   	 	  	 END IF
   	 	  	 LET l_month = ''
   	 	  	 LET l_month = g_hrax[l_ac].hraxud01[11,12]
   	 	  	 IF l_month > 12 OR l_month < 1 OR cl_null(l_month) THEN
   	 	  	 	  CALL cl_err('月份有误','!',1)
   	 	  	 	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	  NEXT FIELD hrax14
   	 	  	 END IF
   	 	  	 LET l_day = ''
   	 	  	 LET l_day = g_hrax[l_ac].hraxud01[13,14]
   	 	  	 IF l_month = '01' OR l_month = '03' OR l_month = '05' OR l_month = '07' OR l_month = '08' OR l_month = '10' OR l_month = '12' THEN
   	 	  	    IF l_day > 31 OR l_day < 1 THEN
   	 	  	       CALL cl_err('日期有误','!',1)
   	 	  	        LET g_hrax[l_ac].hraxud01=' '
   	 	  	       NEXT FIELD hrax14
   	 	  	    END IF
   	 	  	 END IF                                                   #小月
   	 	  	 IF l_month = '04' OR l_month = '05' OR l_month = '09' OR l_month = '11' THEN
   	 	  	    IF l_day > 30 OR l_day < 1 THEN
   	 	  	    	  CALL cl_err('日期有误','!',1)      #mod by zhangbo130924
   	 	  	    	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	    	  NEXT FIELD hrax14
   	 	  	    END IF
   	 	  	 END IF  
   	 	  	 IF l_month = '02' THEN                                   #2月
   	 	  	    IF l_year mod 4 <> 0 OR (l_year mod 4 = 0 AND l_year mod 100 <> 0) THEN    #2月非闰年
   	 	  	    	 IF l_day > 28 OR l_day < 1 THEN
   	 	  	    	   CALL cl_err('日期有误','!',1)
   	 	  	    	    LET g_hrax[l_ac].hraxud01=' '
   	 	  	    	   NEXT FIELD hrax14
   	 	  	       END IF
   	 	  	    ELSE
   	 	  	    	 IF l_day > 29 OR l_day < 1 THEN                                         #2月闰年
   	 	  	    	   CALL cl_err('日期有误','!',1)
   	 	  	    	    LET g_hrax[l_ac].hraxud01=' '
   	 	  	    	   NEXT FIELD hrax14
   	 	  	       END IF
   	 	  	    END IF   	   	
   	 	  	 END IF  		  
       END IF 
     BEFORE FIELD hrax11
       SELECT hrad03 INTO g_hrax[l_ac].hrax11 FROM hrad_file
        WHERE hrad02 = '4001'
       DISPLAY g_hrax[l_ac].hrax11 TO hrax11
       	
    AFTER FIELD hrax14
    IF NOT cl_null(g_hrax[l_ac].hrax14) THEN
       #证件类型名称
        LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM hrag_file
        WHERE hrag01 = '314' AND hrag06 = g_hrax[l_ac].hrax14 AND hragacti = 'Y'
       IF l_n = 0 THEN
       	  CALL cl_err('无此证件类型','!',0)
       	  NEXT FIELD hrax14
       END IF 
        SELECT hrag07 INTO g_hrax[l_ac].hrag07 FROM hrag_file
         WHERE hrag06 = g_hrax[l_ac].hrax14 AND hrag01 = '314'
       DISPLAY BY NAME g_hrax[l_ac].hrax14,g_hrax[l_ac].hrag07
    IF g_hrax[l_ac].hrax14='001' AND NOT cl_null(g_hrax[l_ac].hraxud01) THEN 
    	    LET l_length='0'
       	  SELECT LENGTH(g_hrax[l_ac].hraxud01) INTO l_length FROM DUAL    #长度18位
   	 	  	 IF l_length <> 18 OR cl_null(l_length) THEN
   	 	  	 	 CALL cl_err('身份证长度有误','!',1)
   	 	  	 	  LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	 NEXT FIELD hrax14
   	 	  	 END IF
   	 	  	 LET l_count = 0 
   	 	  	 SELECT COUNT(*) INTO l_count FROM hraj_file
   	 	  	  WHERE hraj01 = substr(g_hrax[l_ac].hraxud01,1,6)
   	 	  	 IF l_count = 0 OR cl_null(l_count) THEN
   	 	  	 	  CALL cl_err('身份证不存在','!',1)
   	 	  	 	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	  NEXT FIELD hrax14
   	 	  	 END IF	  
   	 	  	 LET l_year =''
   	 	  	 LET l_year = g_hrax[l_ac].hraxud01[7,10]
   	 	  	 IF l_year > YEAR(g_today) OR l_year <1 OR cl_null(l_year) THEN
   	 	  	 	  CALL cl_err('年份有误','!',1)
   	 	  	 	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	  NEXT FIELD hrax14
   	 	  	 END IF
   	 	  	 LET l_month = ''
   	 	  	 LET l_month = g_hrax[l_ac].hraxud01[11,12]
   	 	  	 IF l_month > 12 OR l_month < 1 OR cl_null(l_month) THEN
   	 	  	 	  CALL cl_err('月份有误','!',1)
   	 	  	 	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	 	  NEXT FIELD hrax14
   	 	  	 END IF
   	 	  	 LET l_day = ''
   	 	  	 LET l_day = g_hrax[l_ac].hraxud01[13,14]
   	 	  	 IF l_month = '01' OR l_month = '03' OR l_month = '05' OR l_month = '07' OR l_month = '08' OR l_month = '10' OR l_month = '12' THEN
   	 	  	    IF l_day > 31 OR l_day < 1 THEN
   	 	  	       CALL cl_err('日期有误','!',1)
   	 	  	       LET g_hrax[l_ac].hraxud01=' '
   	 	  	       NEXT FIELD hrax14
   	 	  	    END IF
   	 	  	 END IF                                                   #小月
   	 	  	 IF l_month = '04' OR l_month = '05' OR l_month = '09' OR l_month = '11' THEN
   	 	  	    IF l_day > 30 OR l_day < 1 THEN
   	 	  	    	  CALL cl_err('日期有误','!',1)      #mod by zhangbo130924
   	 	  	    	  LET g_hrax[l_ac].hraxud01=' '
   	 	  	    	  NEXT FIELD hrax14
   	 	  	    END IF
   	 	  	 END IF  
   	 	  	 IF l_month = '02' THEN                                   #2月
   	 	  	    IF l_year mod 4 <> 0 OR (l_year mod 4 = 0 AND l_year mod 100 <> 0) THEN    #2月非闰年
   	 	  	    	 IF l_day > 28 OR l_day < 1 THEN
   	 	  	    	   CALL cl_err('日期有误','!',1)
   	 	  	    	    LET g_hrax[l_ac].hraxud01=' '
   	 	  	    	   NEXT FIELD hrax14
   	 	  	       END IF
   	 	  	    ELSE
   	 	  	    	 IF l_day > 29 OR l_day < 1 THEN                                         #2月闰年
   	 	  	    	   CALL cl_err('日期有误','!',1)
   	 	  	    	   LET g_hrax[l_ac].hraxud01=' '
   	 	  	    	   NEXT FIELD hrax14
   	 	  	       END IF
   	 	  	    END IF   	   	
   	 	  	 END IF  		  
       END IF    
    END IF
       	
    AFTER FIELD hrax19
     IF NOT cl_null(g_hrax[l_ac].hrax19) THEN
       #最高学历名称
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM hrag_file
        WHERE hrag01 = '317' AND hrag06 = g_hrax[l_ac].hrax19 AND hragacti = 'Y'
       IF l_n = 0 THEN
       	  CALL cl_err('无此学历编号','!',0)
       	  NEXT FIELD hrax19
       END IF 
        SELECT hrag07 INTO g_hrax[l_ac].hrag07a FROM hrag_file
         WHERE hrag06 = g_hrax[l_ac].hrax19 AND hrag01 = '317'
       DISPLAY BY NAME g_hrax[l_ac].hrax19,g_hrax[l_ac].hrag07a
     END IF
    
    AFTER FIELD hrax20
      IF NOT cl_null(g_hrax[l_ac].hrax20) THEN
       LET l_n = 0
       SELECT COUNT(*) INTO l_n FROM hrag_file
        WHERE hrag01 = '337' AND hrag06 = g_hrax[l_ac].hrax20
       IF l_n = 0 THEN
       	  CALL cl_err('无此学历编号','!',0)
       	  NEXT FIELD hrax20
       END IF 
       #直接/简介名称
        SELECT hrag07 INTO g_hrax[l_ac].hrag07b FROM hrag_file
         WHERE hrag06 = g_hrax[l_ac].hrax20 AND hrag01 = '337'
        DISPLAY BY NAME g_hrax[l_ac].hrax20,g_hrax[l_ac].hrag07b
      END IF
    
       	
    BEFORE DELETE                            
       IF g_hrax_t.hrax01 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
         # IF l_lock_sw = "Y" THEN 
         #   CALL cl_err("", -263, 1) 
         #    ROLLBACK WORK      #FUN-680010
         #    CANCEL DELETE 
         # END IF 
         
          DELETE FROM hrax_file WHERE hrax01 = g_hrax_t.hrax01
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrax_file",g_hrax_t.hrax01,'',SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cnt
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN                 
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrax[l_ac].* = g_hrax_t.*
         CLOSE i007_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrax[l_ac].hrax01,-263,0)
          LET g_hrax[l_ac].* = g_hrax_t.*
       ELSE
       IF cl_null(g_hrax[l_ac].hrax01) OR cl_null(g_hrax[l_ac].hrax02) OR
       	  cl_null(g_hrax[l_ac].hrax06) OR cl_null(g_hrax[l_ac].hrax09) OR
       	  cl_null(g_hrax[l_ac].hrax08) OR cl_null(g_hrax[l_ac].hrax16) OR
       	  cl_null(g_hrax[l_ac].hrax17) OR cl_null(g_hrax[l_ac].hrax18) OR cl_null(g_hrax[l_ac].hraxud01) THEN
       	  CALL cl_err('必输栏位不可为空','!',0)
           NEXT FIELD hrax01
       END IF
          
         #FUN-A30030 END--------------------
          UPDATE hrax_file SET hrax01=g_hrax[l_ac].hrax01,
                               hrax02=g_hrax[l_ac].hrax02,
                               hrax03=g_hrax[l_ac].hrax03,
                               hrax04=g_hrax[l_ac].hrax04,
                               hrax05=g_hrax[l_ac].hrax05,
                               hrax06=g_hrax[l_ac].hrax06,
                               hrax07=g_hrax[l_ac].hrax07,
                               hrax08=g_hrax[l_ac].hrax08,
                               hrax09=g_hrax[l_ac].hrax09,
                               hrax11='4001',
                               hrax14=g_hrax[l_ac].hrax14,
                               hraxud01 = g_hrax[l_ac].hraxud01,
                               hrax16=g_hrax[l_ac].hrax16,
                               hrax17=g_hrax[l_ac].hrax17,
                               hrax18=g_hrax[l_ac].hrax18,
                               hrax19=g_hrax[l_ac].hrax19,
                               hrax20=g_hrax[l_ac].hrax20,
                               hraxmodu=g_user,
                               hraxdate=g_today
                WHERE hrax01 = g_hrax_t.hrax01
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrax_file",g_hrax_t.hrax01,g_hrax_t.hrax02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrax[l_ac].* = g_hrax_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_n  = ARR_COUNT()
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrax[l_ac].* = g_hrax_t.*
          END IF
          CLOSE i007_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i007_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
        
           WHEN INFIELD(hrax03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hraa10"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax03
             #LET g_qryparam.arg1='101'
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax03
             DISPLAY BY NAME g_hrax[l_ac].hrax03
             NEXT FIELD hrax03
           WHEN INFIELD(hrax04)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrao01"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax04
             LET g_qryparam.arg1=g_hrax[l_ac].hrax03
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax04
             DISPLAY BY NAME g_hrax[l_ac].hrax04
             NEXT FIELD hrax04
           WHEN INFIELD(hrax05)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hras01_1"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax05
             LET g_qryparam.arg1=g_hrax[l_ac].hrax04
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax05
             DISPLAY BY NAME g_hrax[l_ac].hrax05
             NEXT FIELD hrax05
           WHEN INFIELD(hrax07)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrat01"
             LET g_qryparam.where = "hrat07 = 'Y' "
             LET g_qryparam.default1 = g_hrax[l_ac].hrax07
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax07
             DISPLAY BY NAME g_hrax[l_ac].hrax07
             NEXT FIELD hrax07
           WHEN INFIELD(hrax14)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax14
             LET g_qryparam.arg1='314'
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax14
             DISPLAY BY NAME g_hrax[l_ac].hrax14
             NEXT FIELD hrax14
          WHEN INFIELD(hrax19)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax19
             LET g_qryparam.arg1='317'
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax19
             DISPLAY BY NAME g_hrax[l_ac].hrax19
             NEXT FIELD hrax19
          WHEN INFIELD(hrax20)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax20
             LET g_qryparam.arg1='337'
             CALL cl_create_qry() RETURNING g_hrax[l_ac].hrax20
             DISPLAY BY NAME g_hrax[l_ac].hrax20
             NEXT FIELD hrax20
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
 
    CLOSE i007_bcl
    COMMIT WORK
    IF cl_null(g_wc2) THEN
    	 LET g_wc2 = '1=1'
    END IF
    CALL i007_b_fill(g_wc2)
END FUNCTION      	     		
	
FUNCTION i007_b_askkey()
    CLEAR FORM
    CALL g_hrax.clear()
    LET g_rec_b=0
 
    CONSTRUCT g_wc2 ON hrax01,hrax02,hrax03,hrax04,hrax05,hrax06,hrax07,
                       hrax08,hrax09,hrax11,hrax14,hraxud01,hrax16,hrax17,hrax18,hrax19,hrax20                      
         FROM s_hrax[1].hrax01,s_hrax[1].hrax02,s_hrax[1].hrax03,                                  
              s_hrax[1].hrax04,s_hrax[1].hrax05,s_hrax[1].hrax06,
              s_hrax[1].hrax07,s_hrax[1].hrax08,s_hrax[1].hrax09,
              s_hrax[1].hrax11,s_hrax[1].hrax14,s_hrax[1].hraxud01,s_hrax[1].hrax16,
              s_hrax[1].hrax17,s_hrax[1].hrax18,s_hrax[1].hrax19,
              s_hrax[1].hrax20
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrax03)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa10"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrax[1].hrax03
               NEXT FIELD hrax03
           WHEN INFIELD(hrax04)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrao01"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax04
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax04
             NEXT FIELD hrax04
           WHEN INFIELD(hrax05)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hras01"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax05
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax05
             NEXT FIELD hrax05
           WHEN INFIELD(hrax07)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrat01"
             LET g_qryparam.state = "c"
             LET g_qryparam.where = "hrat07 = 'Y' "
             LET g_qryparam.default1 = g_hrax[l_ac].hrax07
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax07
             NEXT FIELD hrax07
           WHEN INFIELD(hrax19)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax19
             LET g_qryparam.arg1='314'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax19
             NEXT FIELD hrax19
          WHEN INFIELD(hrax19)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.state = "c"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax19
             LET g_qryparam.arg1='317'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax19
             NEXT FIELD hrax19
          WHEN INFIELD(hrax20)
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_hrag06"
             LET g_qryparam.default1 = g_hrax[l_ac].hrax20
             LET g_qryparam.arg1='337'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO g_hrax[l_ac].hrax20
             NEXT FIELD hrax20

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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('hraxuser', 'hraxgrup') #FUN-980030
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
    CALL i007_b_fill(g_wc2)
 
END FUNCTION	
	
FUNCTION i007_b_fill(p_wc2)              #BODY FILL UP
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT '',hrax01,hrax02,hrax03,'',hrax04,'',hrax05,'',hrax11,",
                   "hrax06,hrax07,'',hrax09,hrax08,hrax14,'',hraxud01,hrax16,hrax17,hrax18,hrax19,'',hrax20,'',''",
                   " FROM hrax_file ",
                   " WHERE ", p_wc2 CLIPPED, 
                   "   AND hrax11 in ('4001') ",
                   " ORDER BY hrax01" 
 
    PREPARE i007_pb FROM g_sql
    DECLARE hrax_curs CURSOR FOR i007_pb
 
    CALL g_hrax.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrax_curs INTO g_hrax[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
      #公司名称
      SELECT hraa12 INTO g_hrax[g_cnt].hraa12 FROM hraa_file 
       WHERE hraa01 = g_hrax[g_cnt].hrax03
     #部门名称
      SELECT hrao02 INTO g_hrax[g_cnt].hrao02 FROM hrao_file
       WHERE hrao01 = g_hrax[g_cnt].hrax04
     #职位名称
      SELECT hras04 INTO g_hrax[g_cnt].hras04 FROM hras_file
       WHERE hras01 = g_hrax[g_cnt].hrax05   
     #直接主管
      SELECT hrat02 INTO g_hrax[g_cnt].hrat02 FROM hrat_file
       WHERE hrat01 = g_hrax[g_cnt].hrax07
     #员工状态
     SELECT hrad03 INTO g_hrax[g_cnt].hrax11 FROM hrad_file
      WHERE hrad02 = '4001'
     #证件类型
     SELECT hrag07 INTO g_hrax[g_cnt].hrag07 FROM hrag_file
      WHERE hrag06 = g_hrax[g_cnt].hrax14 AND hrag01 = '314'
     #最高学历名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07a FROM hrag_file
       WHERE hrag06 = g_hrax[g_cnt].hrax19 AND hrag01 = '317'
     #直接/简介名称
      SELECT hrag07 INTO g_hrax[g_cnt].hrag07b FROM hrag_file
       WHERE hrag06 = g_hrax[g_cnt].hrax20 AND hrag01 = '337'
      
     LET g_hrax[g_cnt].sure = 'Y'
     
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrax.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt 
    LET g_cnt2 = g_cnt-1
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i007_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
   DEFINE   l_idx  LIKE type_file.num5
   DEFINE   l_hrax09   LIKE hrax_file.hrax09
   DEFINE   l_hrax08   LIKE hrax_file.hrax08
   DEFINE   l_a1       LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrax TO s_hrax.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #设置明细单身可以多选
         CALL DIALOG.setSelectionMode("s_hrax",1)

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
       
      ON ACTION ghri007_a
#         LET g_action_choice="normal"
         IF g_rec_b > 0 THEN
         	CALL i007_normal() RETURNING l_a1,l_hrax08,l_hrax09,g_success
         	IF g_success = 'N' THEN 
         		 CLOSE WINDOW i007a_w
         	END IF 
         	BEGIN WORK 
          FOR l_idx=1 TO g_rec_b
           #抓取被选择的资料
           IF DIALOG.isRowSelected( "s_hrax", l_idx ) THEN
              LET g_hrax21 = ''
      	         IF l_a1 = 'Y' THEN
                   	 CALL hr_gen_no('hrat_file','hrat01','009',g_hrax[l_idx].hrax03,'') 
                          RETURNING g_hrax21,g_flag
                     IF cl_null(g_hrax21) THEN 
                     	  CALL cl_err('编码规则中未设置对应公司的编码规则','!',1)
                     	  LET g_success='N'
                     	  EXIT FOR  
                     END IF 
                 END IF
                   UPDATE hrax_file SET hrax21 = g_hrax21,
                   	                    hrax11 = '2001'     #正式员工
                   WHERE hrax01 = g_hrax[l_idx].hrax01
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
                       LET g_success = 'N'
                    END IF 
                    SELECT max(hratid)+1 INTO g_hrat.hratid FROM hrat_file 
                    IF cl_null(g_hrat.hratid) THEN
                    	  LET g_hrat.hratid = 1 
                    END IF
                    SELECT max(hrat08)+1 INTO g_hrat.hrat08 FROM hrat_file
#                    IF cl_null(g_hrat.hrat08) THEN
#                       LET g_hrat.hratid = 1
#                    END IF
                    IF l_a1 = 'Y' THEN
                    	  LET g_hrat.hrat01 = g_hrax21
                    	 ELSE
                    	 	LET g_hrat.hrat01 = g_hrax[l_idx].hrax01
                    END IF
                    LET g_hrat.hrat02 = g_hrax[l_idx].hrax02
                    LET g_hrat.hrat03 = g_hrax[l_idx].hrax03
                    LET g_hrat.hrat04 = g_hrax[l_idx].hrax04
                    LET g_hrat.hrat05 = g_hrax[l_idx].hrax05
                    LET g_hrat.hrat06 = g_hrax[l_idx].hrax07
                    LET g_hrat.hrat12 = g_hrax[l_idx].hrax14
                    LET g_hrat.hrat15 = g_hrax[l_idx].hrax16
                    LET g_hrat.hrat13 = g_hrax[l_idx].hraxud01
                    IF g_hrax[l_idx].hrax17 = '1' THEN
                       LET g_hrat.hrat17 = '001'
                     ELSE
                       LET g_hrat.hrat17 = '002' 
                    END IF
                    LET g_hrat.hrat19 = '1001'
                    IF g_hrax[l_idx].hrax18 = '0' THEN
                       LET g_hrat.hrat20 = '001'
                     ELSE 
                       LET g_hrat.hrat20 = '002'
                    END IF
                    LET g_hrat.hrat21 = g_hrax[l_idx].hrax20
                    LET g_hrat.hrat22 = g_hrax[l_idx].hrax19
                    LET g_hrat.hrat25 = g_hrax[l_idx].hrax06
                    LET g_hrat.hrat26 = l_hrax08
#                    LET g_hrat.hrat66 = l_hrax09
                    LET g_hrat.hratacti = 'Y'
                    LET g_hrat.hratgrup = g_grup
                    LET g_hrat.hratoriu = g_user
                    INSERT INTO hrat_file VALUES (g_hrat.*)
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL s_errmsg('','',"insert hrax_file",SQLCA.sqlcode,1)   
                       LET g_success = 'N'
                    END IF
                   END IF
                  END FOR
                
                  IF g_success = 'Y' THEN
                        COMMIT WORK
                        CALL cl_err("运行成功","!",2)
                  	 ELSE
                  	   ROLLBACK WORK 
                  	   CALL cl_err("运行失败","!",2) 
                  END IF
                   CLOSE WINDOW i007a_w
                   IF cl_null(g_wc2) THEN
  	                  LET g_wc2 = '1=1'
                    END IF
                   CALL i007_b_fill(g_wc2)
          
         END IF 
        EXIT DISPLAY
      
      ON ACTION ghri007_b
         LET g_action_choice="deferred"
         EXIT DISPLAY
      
      ON ACTION ghri007_c
         LET g_action_choice="dimission"
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
	
FUNCTION i007_normal()
  DEFINE tm1 RECORD
            hrax09   LIKE hrax_file.hrax09,
            hrax08   LIKE hrax_file.hrax08,
            hrax13   LIKE hrax_file.hrax13,
            a1       LIKE type_file.chr1 
          END RECORD
  DEFINE    l_i      LIKE type_file.num5,
            l_n      LIKE type_file.num5      
  DEFINE    l_chk    LIKE type_file.num5
     
  
  LET INT_FLAG = 0
        
  
  
         
#  INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
#          #ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
#           ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_rec_b,UNBUFFERED, 
#                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
#  BEFORE INPUT
#       IF g_rec_b != 0 THEN
#          CALL fgl_set_arr_curr(l_ac)
#       END IF
#  
#  BEFORE ROW
#     LET l_ac = ARR_CURR()
#     LET l_n  = ARR_COUNT()
#      DISPLAY BY NAME g_hrax[l_ac].sure
#      
#  ON ACTION CONTROLG
#        CALL cl_cmdask()
#  
#  ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#        
#  {ON ACTION select_on
#     CALL i007_sel_all('N') }
#  
#  END INPUT             

  IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      RETURN
  END IF  
  #mod by cjy 20130705
  IF g_rec_b = 0 THEN
     LET g_success = 'N'
     RETURN
  END IF

#  LET l_chk = 0
#  FOR l_i=1 TO g_rec_b
#   IF g_hrax[l_i].sure ='Y' THEN
#      LET l_chk = l_chk + 1
#   END IF
#  END FOR

#  IF l_chk = 0 THEN
#     LET g_success = 'N'
#     RETURN
#  END IF
   
  LET p_row = 2 LET p_col = 3
 
  OPEN WINDOW i007a_w AT p_row,p_col WITH FORM "ghr/42f/ghri007a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
     
      CALL cl_ui_init()
     
      INPUT BY NAME tm1.hrax09,tm1.hrax08,tm1.hrax13,tm1.a1 WITHOUT DEFAULTS
      
      BEFORE INPUT
        LET tm1.hrax08 = g_today
        LET tm1.hrax09 = g_today
        DISPLAY tm1.hrax08 TO htax08
        DISPLAY tm1.hrax09 TO hrax09
        LET tm1.a1 = 'Y'
        DISPLAY tm1.a1 TO a1
        
      AFTER FIELD hrax08
        IF tm1.hrax08 < tm1.hrax09 THEN
        	 CALL cl_err('预计转正日期不可大于试用开始日期','!',0)
        	 NEXT FIELD hrax08
        END IF
    
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about         
           CALL cl_about()      
  
        ON ACTION help          
           CALL cl_show_help()  
  
        ON ACTION controlg      
           CALL cl_cmdask()    
     END INPUT
      
    IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      CLOSE WINDOW i007a_w
       RETURN tm1.a1,tm1.hrax08,tm1.hrax09,g_success
         ELSE 
      LET g_success = 'Y'
      CLOSE WINDOW i007a_w
      RETURN tm1.a1,tm1.hrax08,tm1.hrax09,g_success
    END IF
#    BEGIN WORK 
#   IF NOT INT_FLAG THEN
#   	LET g_success = 'Y'
##    FOR l_i =1 TO g_rec_b
##      IF g_hrax[l_i].sure = 'Y' THEN
#      	  LET g_hrax21 = ''
#      	  IF tm1.a1 = 'Y' THEN
#      	  	 CALL hr_gen_no('hrat_file','hrat01','009',p_hrax.hrax03,'') 
#                  RETURNING g_hrax21,g_flag
#          END IF
#      	 UPDATE hrax_file SET hrax21 = g_hrax21,
#      	                      hrax11 = '2001'     #正式员工
#      	  WHERE hrax01 = p_hrax.hrax01
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
#          LET g_success = 'N'
#       END IF 
#       SELECT max(hratid)+1 INTO g_hrat.hratid FROM hrat_file 
#       IF cl_null(g_hrat.hratid) THEN
#       	  LET g_hrat.hratid = 1 
#       END IF
#       SELECT max(hrat08)+1 INTO g_hrat.hrat08 FROM hrat_file
##       IF cl_null(g_hrat.hrat08) THEN
##          LET g_hrat.hratid = 1
##       END IF
#       IF tm1.a1 = 'Y' THEN
#       	  LET g_hrat.hrat01 = g_hrax21
#       	 ELSE
#       	 	LET g_hrat.hrat01 = p_hrax.hrax01
#       END IF
#       LET g_hrat.hrat02 = p_hrax.hrax02
#       LET g_hrat.hrat03 = p_hrax.hrax03
#       LET g_hrat.hrat04 = p_hrax.hrax04
#       LET g_hrat.hrat05 = p_hrax.hrax05
#       LET g_hrat.hrat06 = p_hrax.hrax07
#       LET g_hrat.hrat12 = p_hrax.hrax14
#       LET g_hrat.hrat15 = p_hrax.hrax16
#       IF p_hrax.hrax17 = '1' THEN
#          LET g_hrat.hrat17 = '001'
#        ELSE
#          LET g_hrat.hrat17 = '002' 
#       END IF
#       LET g_hrat.hrat19 = '1001'
#       IF p_hrax.hrax18 = '0' THEN
#          LET g_hrat.hrat20 = '001'
#        ELSE 
#          LET g_hrat.hrat20 = '002'
#       END IF
#       LET g_hrat.hrat21 = p_hrax.hrax20
#       LET g_hrat.hrat22 = p_hrax.hrax19
#       LET g_hrat.hrat25 = p_hrax.hrax06
#       LET g_hrat.hrat26 = tm1.hrax08
#       LET g_hrat.hrat66 = tm1.hrax09
#       LET g_hrat.hratacti = 'Y'
#       LET g_hrat.hratgrup = g_grup
#       LET g_hrat.hratoriu = g_user
#       INSERT INTO hrat_file VALUES (g_hrat.*)
#       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#          CALL s_errmsg('','',"insert hrax_file",SQLCA.sqlcode,1)   
#          LET g_success = 'N'
#       END IF
##      END IF
##     END FOR
#    END IF
#     IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_err("运行成功","!",2)
#     	 ELSE
#     	   ROLLBACK WORK 
#     	   CALL cl_err("运行失败","!",2) 
#     END IF
#  CLOSE WINDOW i007a_w
#  IF cl_null(g_wc2) THEN
#  	 LET g_wc2 = '1=1'
#  END IF
#  CALL i007_b_fill(g_wc2)
END FUNCTION
	
FUNCTION i007_deferred()
 DEFINE tm2 RECORD
            hrax10   LIKE hrax_file.hrax10,
            hrax08   LIKE hrax_file.hrax08,
            hrax13   LIKE hrax_file.hrax13
          END RECORD
  DEFINE    l_i      LIKE type_file.num5
  DEFINE    l_chk    LIKE type_file.num5
  
  LET INT_FLAG = 0
  
  INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
  BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
  
  BEFORE ROW
     LET l_ac = ARR_CURR()
  
  ON ACTION CONTROLG
        CALL cl_cmdask()
  
  ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
  
  END INPUT  
 
 IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      RETURN
  END IF          

  #mod by cjy 20130705
  IF g_rec_b = 0 THEN
     LET g_success = 'N'
     RETURN
  END IF
  
  LET l_chk = 0
  FOR l_i=1 TO g_rec_b
   IF g_hrax[l_i].sure ='Y' THEN
      LET l_chk = l_chk + 1
   END IF
  END FOR

  IF l_chk = 0 THEN
     LET g_success = 'N'
     RETURN
  END IF
  
  LET p_row = 2 LET p_col = 3
 
  OPEN WINDOW i007b_w AT p_row,p_col WITH FORM "ghr/42f/ghri007b"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
   CALL cl_ui_init()
     
      INPUT BY NAME tm2.hrax10,tm2.hrax08,tm2.hrax13 WITHOUT DEFAULTS
      
       BEFORE INPUT
         LET tm2.hrax10 = g_today
         LET tm2.hrax08 = g_today
         DISPLAY  tm2.hrax10 TO hrax10
         DISPLAY  tm2.hrax08 TO hrax08
      
      	
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about         
           CALL cl_about()      
  
        ON ACTION help          
           CALL cl_show_help()  
  
        ON ACTION controlg      
           CALL cl_cmdask()    
     END INPUT
  IF NOT INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'Y'
    BEGIN WORK 
    FOR l_i =1 TO g_rec_b
      IF g_hrax[l_i].sure = 'Y' THEN
      	 UPDATE hrax_file SET hrax10 = tm2.hrax10,
      	                      hrax08 = tm2.hrax08,
      	                      hrax13 = tm2.hrax13,
      	                      hrax11 = '4002'      #实习期延长员工
      	  WHERE hrax01 = g_hrax[l_i].hrax01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
       END IF 
     END IF
     END FOR
   END IF
     IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_err("运行成功","!",2)
     	 ELSE
     	   ROLLBACK WORK 
     	   CALL cl_err("运行失败","!",2) 
     END IF
  CLOSE WINDOW i007b_w
  IF cl_null(g_wc2) THEN
  	 LET g_wc2 = '1=1'
  END IF
  CALL i007_b_fill(g_wc2)
 
END FUNCTION
	
FUNCTION i007_dimission()
 DEFINE tm3 RECORD
            hrax12   LIKE hrax_file.hrax12,
            hrax13   LIKE hrax_file.hrax13
          END RECORD
  DEFINE    l_i      LIKE type_file.num5
  DEFINE  l_chk      LIKE type_file.num5
  
  LET INT_FLAG = 0
	
	INPUT ARRAY g_hrax WITHOUT DEFAULTS FROM s_hrax.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE) 
  BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
  
  BEFORE ROW
     LET l_ac = ARR_CURR()
  
  ON ACTION CONTROLG
        CALL cl_cmdask()
  
  ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
  
  END INPUT
  
  IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_success = 'N'
      RETURN
  END IF 

  #mod by cjy 20130705
  IF g_rec_b = 0 THEN
     LET g_success = 'N'
     RETURN
  END IF

  LET l_chk = 0
  FOR l_i=1 TO g_rec_b
   IF g_hrax[l_i].sure ='Y' THEN
      LET l_chk = l_chk + 1
   END IF
  END FOR

  IF l_chk = 0 THEN
     LET g_success = 'N'
     RETURN
  END IF
  
  LET p_row = 2 LET p_col = 3
 
  OPEN WINDOW i007c_w AT p_row,p_col WITH FORM "ghr/42f/ghri007c"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
    CALL cl_ui_init()
     
      INPUT BY NAME tm3.hrax12,tm3.hrax13 WITHOUT DEFAULTS
   
      BEFORE INPUT
        LET tm3.hrax12 = g_today
        DISPLAY tm3.hrax12 TO hrax12
        
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
  
        ON ACTION about         
           CALL cl_about()      
  
        ON ACTION help          
           CALL cl_show_help()  
  
        ON ACTION controlg      
           CALL cl_cmdask()    
     END INPUT
  IF NOT INT_FLAG THEN
    LET INT_FLAG = 0
    LET g_success = 'Y'
    BEGIN WORK 
    FOR l_i =1 TO g_rec_b
      IF g_hrax[l_i].sure = 'Y' THEN
      	 UPDATE hrax_file SET hrax12 = tm3.hrax12,
      	                      hrax13 = tm3.hrax13,
      	                      hrax11 = '3001'       #离职员工
      	  WHERE hrax01 = g_hrax[l_i].hrax01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('','',"update hrax_file",SQLCA.sqlcode,1)   
          LET g_success = 'N'
       END IF 
     END IF
     END FOR
  END IF
     IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_err("运行成功","!",2)
     	 ELSE
     	   ROLLBACK WORK 
     	   CALL cl_err("运行失败","!",2) 
     END IF
  CLOSE WINDOW i007c_w
  IF cl_null(g_wc2) THEN
  	 LET g_wc2 = '1=1'
  END IF
  CALL i007_b_fill(g_wc2)

END FUNCTION    
	
FUNCTION i007_inshrax()
	
	LET g_hrax_ins.hrax01 = g_hrax[l_ac].hrax01
	LET g_hrax_ins.hrax02 = g_hrax[l_ac].hrax02
	LET g_hrax_ins.hrax03 = g_hrax[l_ac].hrax03
	LET g_hrax_ins.hrax04 = g_hrax[l_ac].hrax04
	LET g_hrax_ins.hrax05 = g_hrax[l_ac].hrax05
	LET g_hrax_ins.hrax06 = g_hrax[l_ac].hrax06
	LET g_hrax_ins.hrax07 = g_hrax[l_ac].hrax07
	LET g_hrax_ins.hrax08 = g_hrax[l_ac].hrax08
	LET g_hrax_ins.hrax09 = g_hrax[l_ac].hrax09
	LET g_hrax_ins.hrax11 = '4001'
	LET g_hrax_ins.hrax14 = g_hrax[l_ac].hrax14
	LET g_hrax_ins.hrax16 = g_hrax[l_ac].hrax16
	LET g_hrax_ins.hrax17 = g_hrax[l_ac].hrax17
	LET g_hrax_ins.hrax18 = g_hrax[l_ac].hrax18
	LET g_hrax_ins.hrax19 = g_hrax[l_ac].hrax19
	LET g_hrax_ins.hrax20 = g_hrax[l_ac].hrax20
        LET g_hrax_ins.hraxud01 = g_hrax[l_ac].hraxud01
	LET g_hrax_ins.hraxoriu = g_user
	LET g_hrax_ins.hraxorig = g_grup
	
END FUNCTION

{	
FUNCTION i007_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i2      LIKE type_file.num5

  FOR l_i2 = 1 TO g_cnt2 
    LET g_hrax[l_i2].sure = p_flag
    DISPLAY BY NAME g_hrax[l_i2].sure
  END FOR
 
  CALL g_hrax.deleteElement(l_i2)
  
  LET l_i2 = l_i2-1
  
  CALL ui.Interface.refresh()

END FUNCTION			
}

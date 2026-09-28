# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghri081_1.4gl
# Descriptions...: 
# Date & Author..: 04/20/13 by zhangbo

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_hrdna DYNAMIC ARRAY OF RECORD
         hrdna02   LIKE   hrdna_file.hrdna02,
         hrdn02    LIKE   hrdn_file.hrdn02,
         hrat02_1  LIKE   hrat_file.hrat02,
         hrat04_1  LIKE   hrao_file.hrao02,
         hrat05_1  LIKE   hras_file.hras04,
         hrat19    LIKE   hrad_file.hrad03,
         hrdna03   LIKE   hrdna_file.hrdna03,
         hrat02    LIKE   hrat_file.hrat02,
         hrat04    LIKE   hrao_file.hrao02,
         hrat05    LIKE   hras_file.hras04,
         hrat25    LIKE   hrat_file.hrat25,
         hrdna04   LIKE   hrdna_file.hrdna04,
         hrdna05   LIKE   hrdna_file.hrdna05,
         hrdna06   LIKE   hrdna_file.hrdna06,
         hrdna08   LIKE   hrdna_file.hrdna08,
         hrdna07   LIKE   hrdna_file.hrdna07
               END RECORD
DEFINE g_hrdna_t RECORD
        hrdna02   LIKE   hrdna_file.hrdna02,
         hrdn02    LIKE   hrdn_file.hrdn02,
         hrat02_1  LIKE   hrat_file.hrat02,
         hrat04_1  LIKE   hrao_file.hrao02,
         hrat05_1  LIKE   hras_file.hras04,
         hrat19    LIKE   hrad_file.hrad03,
         hrdna03   LIKE   hrdna_file.hrdna03,
         hrat02    LIKE   hrat_file.hrat02,
         hrat04    LIKE   hrao_file.hrao02,
         hrat05    LIKE   hras_file.hras04,
         hrat25    LIKE   hrat_file.hrat25,
         hrdna04   LIKE   hrdna_file.hrdna04,
         hrdna05   LIKE   hrdna_file.hrdna05,
         hrdna06   LIKE   hrdna_file.hrdna06,
         hrdna08   LIKE   hrdna_file.hrdna08,
         hrdna07   LIKE   hrdna_file.hrdna07
               END RECORD 
DEFINE g_argv1     LIKE   hrdna_file.hrdna01
DEFINE g_wc2           STRING,
       g_sql           STRING,
       g_cmd           LIKE type_file.chr1000, 
       g_rec_b         LIKE type_file.num5,                
       l_ac            LIKE type_file.num5 
DEFINE g_cnt           LIKE type_file.num5 
DEFINE g_forupd_sql STRING     
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
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  
   
    LET g_argv1=ARG_VAL(1)
    
    SELECT COUNT(*) INTO g_i FROM hrdn_file WHERE hrdn01=g_argv1	
    IF g_i=0 THEN
    	 CALL  cl_used(g_prog,g_time,2) RETURNING g_time
    	 RETURN
    END IF	
    	 
 
    LET p_row = 4 LET p_col = 3
    OPEN WINDOW i081_1_w AT p_row,p_col WITH FORM "ghr/42f/ghri081_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      
    CALL cl_ui_init()
    
    LET g_wc2=" hrdna01='",g_argv1,"'"
    CALL i081_1_b_fill(g_wc2)

    CALL i081_1_menu()
    CLOSE WINDOW i081_1_w                 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0081
END MAIN

FUNCTION i081_1_menu()
 
   WHILE TRUE
      CALL i081_1_bp("G")
      CASE g_action_choice

         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i081_1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdna),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
	
FUNCTION i081_1_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                 
    l_n             LIKE type_file.num5,                 
    l_lock_sw       LIKE type_file.chr1,                 
    p_cmd           LIKE type_file.chr1,                 
    l_allow_insert  LIKE type_file.chr1,                 
    l_allow_delete  LIKE type_file.chr1
DEFINE l_hratid     LIKE hrat_file.hratid  
DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
DEFINE l_hrct08_b,l_hrct08_e    LIKE hrct_file.hrct08
DEFINE l_hrat03     LIKE  hrat_file.hrat03
  
      
   
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = "SELECT hrdna02,'','','','','',hrdna03,'','','','',hrdna04,hrdna05,hrdna06,hrdna08,hrdna07",
                       "  FROM hrdna_file WHERE hrdna01=? AND hrdna02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i081_1_bcl CURSOR FROM g_forupd_sql      
 
    INPUT ARRAY g_hrdna WITHOUT DEFAULTS FROM s_hrdna.*
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
           LET g_hrdna_t.* = g_hrdna[l_ac].*  #BACKUP
           OPEN i081_1_bcl USING g_argv1,g_hrdna_t.hrdna02
           IF STATUS THEN
              CALL cl_err("OPEN i081_1_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i081_1_bcl INTO g_hrdna[l_ac].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_argv1,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
           END IF
           SELECT hrdn02 INTO g_hrdna[l_ac].hrdn02 FROM hrdn_file WHERE hrdn01=g_argv1      
           
           SELECT hrat01 INTO g_hrdna[l_ac].hrdn02 FROM hrat_file 
            WHERE hratid=g_hrdna[l_ac].hrdn02
            
            SELECT hrat02 INTO g_hrdna[l_ac].hrat02_1 
             FROM hrat_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
            
           SELECT hrao02 INTO g_hrdna[l_ac].hrat04_1 FROM hrat_file,hrao_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
              AND hrat04=hrao01
           
           SELECT hras04 INTO g_hrdna[l_ac].hrat05_1 FROM hrat_file,hras_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
              AND hras01=hrat05 
              
           SELECT hrad03 INTO g_hrdna[l_ac].hrat19 FROM hrat_file,hrad_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
              AND hrad02=hrat19
            
           SELECT hrat01 INTO g_hrdna[l_ac].hrdna03 FROM hrat_file 
            WHERE hratid=g_hrdna[l_ac].hrdna03
            
           SELECT hrat02 INTO g_hrdna[l_ac].hrat02 
             FROM hrat_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
            
           SELECT hrao02 INTO g_hrdna[l_ac].hrat04 FROM hrat_file,hrao_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
              AND hrat04=hrao01
           
           SELECT hras04 INTO g_hrdna[l_ac].hrat05 FROM hrat_file,hras_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
              AND hras01=hrat05
           
           SELECT hrat25 INTO g_hrdna[l_ac].hrat25 FROM hrat_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03       
                  
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF 
        	
    BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570110 --start                                                          
         LET g_before_input_done = FALSE                                                                                  
         LET g_before_input_done = TRUE                                         
#No.FUN-570110 --end  
         INITIALIZE g_hrdna[l_ac].* TO NULL      #900423
         
         LET g_hrdna[l_ac].hrdna04=g_today
         LET g_hrdna[l_ac].hrdna07='Y'
         SELECT MAX(hrdna02)+1 INTO g_hrdna[l_ac].hrdna02 FROM hrdna_file
          WHERE hrdna01=g_argv1
         IF cl_null(g_hrdna[l_ac].hrdna02) THEN 
         	  LET g_hrdna[l_ac].hrdna02=1
         END IF
         	
          SELECT hrdn02 INTO g_hrdna[l_ac].hrdn02 FROM hrdn_file WHERE hrdn01=g_argv1      
           SELECT hrat01 INTO g_hrdna[l_ac].hrdn02 FROM hrat_file 
            WHERE hratid=g_hrdna[l_ac].hrdn02
            SELECT hrat02 INTO g_hrdna[l_ac].hrat02_1 
             FROM hrat_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
           SELECT hrao02 INTO g_hrdna[l_ac].hrat04_1 FROM hrat_file,hrao_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
              AND hrat04=hrao01
           SELECT hras04 INTO g_hrdna[l_ac].hrat05_1 FROM hrat_file,hras_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
              AND hras01=hrat05 
           SELECT hrad03 INTO g_hrdna[l_ac].hrat19 FROM hrat_file,hrad_file
            WHERE hrat01=g_hrdna[l_ac].hrdn02
             AND hrad02=hrat19
             LET g_hrdna_t.* = g_hrdna[l_ac].*         
             CALL cl_show_fld_cont()     #FUN-550037(smin)
             NEXT FIELD hrdna03 
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i081_1_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
        
        #hrdna03存hratid
        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
        
        INSERT INTO hrdna_file(hrdna01,hrdna02,hrdna03,hrdna04,hrdna05,                          #FUN-A30097
                               hrdna06,hrdna07)  
               VALUES(g_argv1,g_hrdna[l_ac].hrdna02,l_hratid,
                      g_hrdna[l_ac].hrdna04,g_hrdna[l_ac].hrdna05,
                      g_hrdna[l_ac].hrdna06,g_hrdna[l_ac].hrdna07) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrdna_file",g_argv1,g_hrdna[l_ac].hrdna03,SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE 
           LET g_rec_b=g_rec_b+1     
           DISPLAY g_rec_b TO FORMONLY.cn2     
           COMMIT WORK  
        END IF
 
       	
    AFTER FIELD hrdna03
       IF NOT cl_null(g_hrdna[l_ac].hrdna03) THEN
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrdn_file,hrat_file 
       	   WHERE hrdn02=hratid
       	     AND hrdn01=g_argv1
       	     AND hrat01=g_hrdna[l_ac].hrdna03
       	     AND hratconf='Y'
       	  IF l_n>0 THEN
       	  	 CALL cl_err('不能同本人合用','!',0)
       	  	 NEXT FIELD hrdna03
       	  END IF
       	  	
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
       	                                            AND hratconf='Y'
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此员工编号','!',0)
       	  	 NEXT FIELD hrdna03
       	  END IF 
       	  	
          IF g_hrdna[l_ac].hrdna03 != g_hrdna_t.hrdna03
       	    OR g_hrdna_t.hrdna03 IS NULL THEN
       	    IF g_hrdna[l_ac].hrdna07='Y' THEN
       	    	 SELECT COUNT(*) INTO l_n FROM hrat_file,hrdna_file
       	    	  WHERE hrat01=g_hrdna[l_ac].hrdna03
       	    	    AND hrdna02=hratid
       	    	    AND hrdna07='Y'
       	    	 IF l_n>0 THEN
       	    	 	  CALL cl_err('一个员工只能有一笔有效的合用信息','!',0)
       	    	 	  NEXT FIELD hrdna03
       	    	 END IF
       	    END IF
       	    	
       	    IF NOT cl_null(g_hrdna[l_ac].hrdna05) AND
       	    	 NOT cl_null(g_hrdna[l_ac].hrdna06) THEN
       	    	 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
               SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03    
               SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna05
                                                              AND hrct03=l_hrat03       
               SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna06
                                                              AND hrct03=l_hrat03
               LET l_n=0                                                
               SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
                WHERE hrdn02=l_hratid
                  AND A.hrct11=hrdn09
                  AND B.hrct11=hrdn10
                  AND A.hrct03=l_hrat03       
                  AND B.hrct03=l_hrat03       
                  AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                      OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                      OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
               IF l_n>0 THEN
               	  CALL cl_err('该员工与银行主档维护薪资月有交叉,请修改主档薪资月','!',0)
               	  NEXT FIELD hrdna03
               END IF
            END IF
          END IF       	    	       	    		 		     
       	  
          SELECT hrat02 INTO g_hrdna[l_ac].hrat02 
             FROM hrat_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
            
           SELECT hrao02 INTO g_hrdna[l_ac].hrat04 FROM hrat_file,hrao_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
              AND hrat04=hrao01
           
           SELECT hras04 INTO g_hrdna[l_ac].hrat05 FROM hrat_file,hras_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
              AND hras01=hrat05
           
           SELECT hrat25 INTO g_hrdna[l_ac].hrat25 FROM hrat_file
            WHERE hrat01=g_hrdna[l_ac].hrdna03
     
       END IF
       	
    AFTER FIELD hrdna05
       IF NOT cl_null(g_hrdna[l_ac].hrdna05) THEN
       	  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna05
       	                                            AND hrct03=l_hrat03
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此薪资月','!',0)
       	  	 NEXT FIELD hrdna05
       	  END IF
       	  	
       	  IF NOT cl_null(g_hrdna[l_ac].hrdna06) THEN
       	  	 SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna05        
                                                            AND hrct03=l_hrat03             
             SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna06
                                                            AND hrct03=l_hrat03             
             IF l_hrct07_b>l_hrct07_e THEN        
                CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                NEXT FIELD hrdna05
             END IF
          END IF
       	  
       	  IF NOT cl_null(g_hrdna[l_ac].hrdna03) AND 
       	  	 NOT cl_null(g_hrdna[l_ac].hrdna06) THEN
       	  	 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
             SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03    
             SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna05
                                                              AND hrct03=l_hrat03       
             SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna06
                                                              AND hrct03=l_hrat03
             LET l_n=0                                                
             SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
              WHERE hrdn02=l_hratid
                AND A.hrct11=hrdn09
                AND B.hrct11=hrdn10
                AND A.hrct03=l_hrat03       
                AND B.hrct03=l_hrat03       
                AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
             IF l_n>0 THEN
               	CALL cl_err('该员工与银行主档维护薪资月有交叉,请修改主档薪资月','!',0)
               	NEXT FIELD hrdna05
             END IF
          END IF
          	
       END IF
       	
    AFTER FIELD hrdna06
       IF NOT cl_null(g_hrdna[l_ac].hrdna06) THEN
       	  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
       	  LET l_n=0
       	  SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna06
       	                                            AND hrct03=l_hrat03
       	  IF l_n=0 THEN
       	  	 CALL cl_err('无此薪资月','!',0)
       	  	 NEXT FIELD hrdna06
       	  END IF
       	  	
       	  IF NOT cl_null(g_hrdna[l_ac].hrdna05) THEN
       	  	 SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna05        
                                                            AND hrct03=l_hrat03             
             SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna06
                                                            AND hrct03=l_hrat03             
             IF l_hrct07_b>l_hrct07_e THEN        
                CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                NEXT FIELD hrdna06
             END IF
          END IF
       	  
       	  IF NOT cl_null(g_hrdna[l_ac].hrdna03) AND 
       	  	 NOT cl_null(g_hrdna[l_ac].hrdna05) THEN
       	  	 SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03
             SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03    
             SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna05
                                                              AND hrct03=l_hrat03       
             SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdna[l_ac].hrdna06
                                                              AND hrct03=l_hrat03
             LET l_n=0                                                
             SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdn_file
              WHERE hrdn02=l_hratid
                AND A.hrct11=hrdn09
                AND B.hrct11=hrdn10
                AND A.hrct03=l_hrat03       
                AND B.hrct03=l_hrat03       
                AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                    OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                    OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
             IF l_n>0 THEN
               	CALL cl_err('该员工与银行主档维护薪资月有交叉,请修改主档薪资月','!',0)
               	NEXT FIELD hrdna06
             END IF
          END IF
          	
       END IF 
       	
    AFTER FIELD hrdna07
       IF NOT cl_null(g_hrdna[l_ac].hrdna07) THEN
       	  IF g_hrdna[l_ac].hrdna07 != g_hrdna_t.hrdna07
       	  	 OR g_hrdna_t.hrdna07 IS NULL THEN
       	  	 IF g_hrdna[l_ac].hrdna07='Y' AND NOT cl_null(g_hrdna[l_ac].hrdna03) THEN
       	  	 	  LET l_n=0
       	  	 	  SELECT COUNT(*) INTO l_n FROM hrat_file,hrdna_file
       	    	  WHERE hrat01=g_hrdna[l_ac].hrdna03
       	    	    AND hrdna02=hratid
       	    	    AND hrdna07='Y'
       	    	  IF l_n>0 THEN
       	    	 	   CALL cl_err('一个员工只能有一笔有效的合用信息','!',0)
       	    	 	   LET g_hrdna[l_ac].hrdna07=g_hrdna_t.hrdna07
       	    	 	   NEXT FIELD hrdna07
       	    	 	END IF
       	     END IF
       	  END IF
       END IF	  	   		 		     	  	   	 		                                              	 	   	

       	       	
    BEFORE DELETE                            
       IF g_hrdna_t.hrdna02 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF 
         
          DELETE FROM hrdna_file WHERE hrdna01 = g_argv1
                                   AND hrdna02 = g_hrdna_t.hrdna02
          
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdna_file",g_argv1,g_hrdna_t.hrdna02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
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
         LET g_hrdna[l_ac].* = g_hrdna_t.*
         CLOSE i081_1_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_argv1,-263,0)
          LET g_hrdna[l_ac].* = g_hrdna_t.*
       ELSE
          SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdna[l_ac].hrdna03  
          #FUN-A30030 END--------------------
          UPDATE hrdna_file SET hrdna03=l_hratid,
                                hrdna04=g_hrdna[l_ac].hrdna04,
                                hrdna05=g_hrdna[l_ac].hrdna05,
                                hrdna06=g_hrdna[l_ac].hrdna06,
                                hrdna07=g_hrdna[l_ac].hrdna07
                WHERE hrdna01 = g_argv1
                  AND hrdna02 = g_hrdna_t.hrdna02
          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","hrdna_file",g_argv1,g_hrdna_t.hrdna02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
             ROLLBACK WORK    #FUN-680010
             LET g_hrdna[l_ac].* = g_hrdna_t.*
          END IF
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac = ARR_CURR()            
       LET l_ac_t = l_ac                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdna[l_ac].* = g_hrdna_t.*
          END IF
          CLOSE i081_1_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i081_1_bcl                
        COMMIT WORK  
 
       ON ACTION controlp
         CASE 
           WHEN INFIELD(hrdna03)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrat01"
             LET g_qryparam.default1 = g_hrdna[l_ac].hrdna03
             CALL cl_create_qry() RETURNING g_hrdna[l_ac].hrdna03
             DISPLAY BY NAME g_hrdna[l_ac].hrdna03
             NEXT FIELD hrdna03
             
           WHEN INFIELD(hrdna05)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrct11"
             LET g_qryparam.default1 = g_hrdna[l_ac].hrdna05
             CALL cl_create_qry() RETURNING g_hrdna[l_ac].hrdna05
             DISPLAY BY NAME g_hrdna[l_ac].hrdna05
             NEXT FIELD hrdna05
           
           WHEN INFIELD(hrdna06)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_hrct11"
             LET g_qryparam.default1 = g_hrdna[l_ac].hrdna06
             CALL cl_create_qry() RETURNING g_hrdna[l_ac].hrdna06
             DISPLAY BY NAME g_hrdna[l_ac].hrdna06
             NEXT FIELD hrdna06      
             
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
 
    CLOSE i081_1_bcl
    COMMIT WORK
END FUNCTION	
	
FUNCTION i081_1_b_fill(p_wc2)              #BODY FILL UP
DEFINE l_hratid     LIKE   hrat_file.hratid	
	
 
    DEFINE p_wc2           STRING
       
       LET g_sql = "SELECT hrdna02,'','','','','',hrdna03,'','','','',hrdna04,hrdna05,hrdna06,hrdna08,hrdna07",
                   " FROM hrdna_file",
                   " WHERE ",p_wc2 CLIPPED,
                   " ORDER BY 1" 
 
    PREPARE i081_1_pb FROM g_sql
    DECLARE hrdna_curs CURSOR FOR i081_1_pb
 
    CALL g_hrdna.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdna_curs INTO g_hrdna[g_cnt].*   
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
           SELECT hrdn02 INTO g_hrdna[g_cnt].hrdn02 FROM hrdn_file 
           WHERE hrdn01=g_argv1      
           SELECT hrat01 INTO g_hrdna[g_cnt].hrdn02 FROM hrat_file 
           WHERE hratid=g_hrdna[g_cnt].hrdn02
           SELECT hrat02 INTO g_hrdna[g_cnt].hrat02_1 
           FROM hrat_file
           WHERE hrat01=g_hrdna[g_cnt].hrdn02
           SELECT hrao02 INTO g_hrdna[g_cnt].hrat04_1 
           FROM hrat_file,hrao_file
           WHERE hrat01=g_hrdna[g_cnt].hrdn02
           AND hrat04=hrao01
           SELECT hras04 INTO g_hrdna[g_cnt].hrat05_1 
           FROM hrat_file,hras_file
           WHERE hrat01=g_hrdna[g_cnt].hrdn02
           AND hras01=hrat05 
           SELECT hrad03 INTO g_hrdna[g_cnt].hrat19 
           FROM hrat_file,hrad_file
           WHERE hrat01=g_hrdna[g_cnt].hrdn02
           AND hrad02=hrat19
        SELECT hrat01 INTO g_hrdna[g_cnt].hrdna03 FROM hrat_file
         WHERE hratid=g_hrdna[g_cnt].hrdna03
        SELECT hrat02 INTO g_hrdna[g_cnt].hrat02 FROM hrat_file
         WHERE hrat01=g_hrdna[g_cnt].hrdna03
        SELECT hrao02 INTO g_hrdna[g_cnt].hrat04 FROM hrat_file,hrao_file
         WHERE hrat01=g_hrdna[g_cnt].hrdna03
           AND hrat04=hrao01
        SELECT hras04 INTO g_hrdna[g_cnt].hrat05 FROM hrat_file,hras_file
         WHERE hrat01=g_hrdna[g_cnt].hrdna03
           AND hrat05=hras01
        SELECT hrat25 INTO g_hrdna[g_cnt].hrat25 FROM hrat_file
         WHERE hrat01=g_hrdna[g_cnt].hrdna03         
                              
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdna.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION	
	
FUNCTION i081_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdna TO s_hrdna.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE DISPLAY 
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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

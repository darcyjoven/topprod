# Prog. Version..: '5.30.04-08.10.22(00000)'     #
#
# Pattern name...: sghri057.4gl
# Descriptions...: 
# Date & Author..: 13/06/08 by yougs

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_abc     LIKE type_file.chr1
DEFINE g_hrck    DYNAMIC ARRAY OF RECORD     
         hrck01          LIKE hrck_file.hrck01,
         hrck02          LIKE hrck_file.hrck02
               END RECORD,
       g_hrck_t         RECORD 
         hrck01          LIKE hrck_file.hrck01,
         hrck02          LIKE hrck_file.hrck02
                    END RECORD,
       g_hrat    DYNAMIC ARRAY OF RECORD   
         hrat01          LIKE hrat_file.hrat01,
         hrat02          LIKE hrat_file.hrat02
#         hrat04          LIKE hrat_file.hrat04,
#         hrao02          LIKE hrao_file.hrao02,
#         hrat05          LIKE hrat_file.hrat05,
#         hras04          LIKE hras_file.hras04,
#         hrat25          LIKE hrat_file.hrat25,
#         hrat19          LIKE hrat_file.hrat19,
#         hrat19_name     LIKE hrad_file.hrad03
               END RECORD,
    g_hrat_t         RECORD                       
         hrat01          LIKE hrat_file.hrat01,
         hrat02          LIKE hrat_file.hrat02
#         hrat04          LIKE hrat_file.hrat04,
#         hrao02          LIKE hrao_file.hrao02,
#         hrat05          LIKE hrat_file.hrat05,
#         hras04          LIKE hras_file.hras04,
#         hrat25          LIKE hrat_file.hrat25,
#         hrat19          LIKE hrat_file.hrat19,
#         hrat19_name     LIKE hrad_file.hrad03 
                    END RECORD,
    gs_wc2           STRING,
    gs_sql           STRING,
    gs_rec_b         LIKE type_file.num5,
    ls_ac            LIKE type_file.num5,
    gs_rec_b1        LIKE type_file.num5,
    ls_ac1          LIKE type_file.num5
                 
DEFINE tm           RECORD 
         b_date      LIKE type_file.dat,
         e_date      LIKE type_file.dat
                    END RECORD
        
DEFINE gs_forupd_sql STRING     
DEFINE gs_cnt        LIKE type_file.num10
DEFINE g_flag        LIKE type_file.chr4


FUNCTION i056_auto_generate()
DEFINE l_count   LIKE type_file.num5
DEFINE l_hrcp01  LIKE hrcp_file.hrcp01
DEFINE l_hrcp    RECORD LIKE hrcp_file.hrcp01	
  
   WHENEVER ERROR CALL cl_err_msg_log 
   OPEN WINDOW i056_2_w AT 4,3 WITH FORM "ghr/42f/ghri056_2"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_init()
   DROP TABLE hrat_temp 
   SELECT hrck01 FROM hrck_file WHERE 1=0 INTO TEMP hrck_temp
   SELECT hrat01 FROM hrat_file WHERE 1=0 INTO TEMP hrat_temp
   SELECT hrat01 FROM hrat_file WHERE 1=0 INTO TEMP hrat_ttt
   LET g_action_choice="" 
   LET g_abc = 'Y' 
   CALL i056_2_a()

   CALL i056_2_menu()
   IF g_abc = 'Y' THEN 
      CALL i056_hrck_set()	
      CALL i056_hrat_set()
      SELECT COUNT(*) INTO l_count FROM hrat_ttt
      IF l_count = 0 OR cl_null(l_count) THEN
      	 INSERT INTO hrat_ttt SELECT hrat01 FROM hrat_file WHERE hratconf = 'Y'
      END IF	 
      DELETE FROM hrat_temp
      INSERT INTO hrat_temp SELECT DISTINCT hrat01 FROM hrat_ttt
      FOR l_date = tm.b_date TO tm.e_bate
          LET l_sql = "SELECT hrat01 FROM hrat_temp WHERE hrat01 NOT IN(SELECT hrcp_file WHERE hrcp02 = to_date('",l_date,"','yyyy/mm/dd') AND hrcp35 = 'N')"
          DECLARE hrat_cs4 CURSOR FROM l_sql
          FOREACH hrat_cs4 INTO l_hrat01
             LET l_hrcp01 = ''
             SELECT MAX(hrcp01)+1 INTO l_hrcp01 FROM hrcp_file
             IF cl_null(l_hrcp01) THEN
      	        LET l_hrcp01=1
             END IF
             LET l_hrcp.hrcp01 = l_hrcp01
             SELECT hratid INTO l_hrcp.hrcp02 FROM hrat_file
              WHERE hrat01 = l_hrat01
             LET l_hrcp.hrcp03 = l_date
             
             #员工的公司，部门等信息
             LET l_hrat03 = ''
             LET l_hrat04 = ''
             LET l_hrat05 = ''
             SELECT hrat03,hrat04,hrat05 INTO l_hrat03,l_hrat04,l_hrat05 FROM hrat_file
              WHERE hrat01 = l_hrat01
              
             #考勤方式
             LET l_hrbn02 = ''
             SELECT hrbn02 INTO l_hrbn02 FROM hrbn_file
              WHERE hrbn01 = l_hrcp.hrcp02
                AND hrbn04 <= l_hrcp.hrcp03
                AND hrbn05 >= l_hrcp.hrcp03
                AND rownum = 1   
             CASE l_hrbn02 
             	  WHEN '001' 
             	      CALL i056_paiban(l_hrcp.hrcp02,l_date) RETURNING l_hrcp.hrcp04
             	  WHEN '002'
             	      CALL i056_paiban(l_hrcp.hrcp02,l_date) RETURNING l_hrcp.hrcp04
             	  WHEN '003'
                OTHERWISE 
                    #
                    SELECT hrbm03 INTO l_hrcp.hrcp10 FROM hrbm_file
                     WHERE hrbm04 = '没有考勤方式'
                       AND hrbm05 = 'Y'
                       AND hrbm01 = l_hrat03
                       
                    #班次   
                    CALL i056_paiban(l_hrcp.hrcp02,l_date) RETURNING l_hrcp.hrcp04
                    #如果员工排的不是班次，而是班组，此时取序号为“1”的班次即可，并在字段“hrcp36”中标记为智能配班。	如何判断是否是班组？？？
                     	 	
             END CASE	  
          END FOREACH   
      END FOR
   END IF
   CLOSE WINDOW i056_2_w                 
END FUNCTION 
	
FUNCTION i056_paiban(p_hrcp02,p_date)
DEFINE p_hrcp02 LIKE hrcp_file.hrcp02
DEFINE p_date   LIKE hrcp_file.hrcp03
DEFINE l_hrca03 LIKE hrca_file.hrca03
DEFINE l_hrcp04 LIKE hrcp_file.hrcp04	
DEFINE l_hrat03 LIKE hrat_file.hrat03
DEFINE l_hrat04 LIKE hrat_file.hrat04
    LET l_hrat03 = ''
    LET l_hrat04 = ''
    SELECT hrat03,hrat04 INTO l_hrat03,l_hrat04 FROM hrat_file
     WHERE hratid = p_hrcp02
	    #班次   
    LET l_hrca03 = ''
    SELECT hrca03 INTO l_hrca03 FROM hrca_file WHERE hrca02 = '1' AND hrca14 = p_hrcp02 AND hrca11 <= l_date AND hrca12 >= l_date
    IF l_hrca03 = '1' THEN 
    	 SELECT hrca04 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '1' AND hrca14 = p_hrcp02 AND hrca03 = l_hrca03 AND hrca11 <= l_date AND hrca12 >= l_date
    END IF
    IF l_hrca03 = '2' THEN	
    	 SELECT hrca06 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '1' AND hrca14 = p_hrcp02 AND hrca03 = l_hrca03 AND hrca11 <= l_date AND hrca12 >= l_date
    END IF	 	 
    IF cl_null(l_hrcp04) THEN
    	 LET l_hrca03 = ''
       SELECT hrca03 INTO l_hrca03 FROM hrca_file WHERE hrca02 = '2' AND hrca14 = l_hrat04 AND hrca11 <= l_date AND hrca12 >= l_date
       IF l_hrca03 = '1' THEN 
    	    SELECT hrca04 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '2' AND hrca14 = l_hrat04 AND hrca03 = l_hrca03 AND hrca11 <= l_date AND hrca12 >= l_date
       END IF
       IF l_hrca03 = '2' THEN	
    	    SELECT hrca06 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '2' AND hrca14 = l_hrat04 AND hrca03 = l_hrca03 AND hrca11 <= l_date AND hrca12 >= l_date
       END IF
    END IF
    IF cl_null(l_hrcp04) THEN
    	 LET l_hrca03 = ''
       SELECT hrca03 INTO l_hrca03 FROM hrca_file WHERE hrca02 = '3' AND hrca14 = l_hrat03 AND hrca11 <= l_date AND hrca12 >= l_date
       IF l_hrca03 = '1' THEN 
    	    SELECT hrca04 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '3' AND hrca14 = l_hrat03 AND hrca03 = l_hrca03 AND hrca11 <= l_date AND hrca12 >= l_date
       END IF
       IF l_hrca03 = '2' THEN	
    	    SELECT hrca06 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '3' AND hrca14 = l_hrat03 AND hrca03 = l_hrca03 AND hrca11 <= l_date AND hrca12 >= l_date
       END IF
    END IF
    IF cl_null(l_hrcp04) THEN
    	 LET l_hrca03 = ''
       SELECT hrca03 INTO l_hrca03 FROM hrca_file WHERE hrca02 = '4' AND hrca14 IN (SELECT hrcb01 FROM hrcb_file WHERE hrcb05 = p_hrcp02) AND hrca11 <= l_date AND hrca12 >= l_date AND rownum =1
       IF l_hrca03 = '1' THEN 
    	    SELECT hrca04 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '4' AND hrca14 IN (SELECT hrcb01 FROM hrcb_file WHERE hrcb05 = p_hrcp02) AND hrca11 <= l_date AND hrca12 >= l_date AND rownum =1
       END IF
       IF l_hrca03 = '2' THEN	
    	    SELECT hrca06 INTO l_hrcp04 FROM hrca_file WHERE hrca02 = '4' AND hrca14 IN (SELECT hrcb01 FROM hrcb_file WHERE hrcb05 = p_hrcp02) AND hrca11 <= l_date AND hrca12 >= l_date AND rownum =1
       END IF
    END IF		  
    RETURN l_hrcp04	
END FUNCTION		
	
FUNCTION i056_hrck_set()
DEFINE l_str    STRING
DEFINE l_hrcka    RECORD LIKE hrcka_file.*
   DECLARE hrck_cs1 CURSOR FROM SELECT * FROM hrck_temp ORDER BY hrck01
   FOREACH hrck_cs1 INTO l_hrcka.hrcka01
      LET l_str = ''
	    DECLARE hrcka_cs1 CURSOR FROM SELECT hrcka_file.* FROM hrcka_file,hrck_temp
	                                   WHERE hrcka01 = hrck01
	                                   ORDER BY hrcka01,hrcka02
	    FOREACH hrcka_cs1 INTO l_hrcka.*   
	       IF NOT cl_null(l_hrcka.hrcka03) THEN
	       	  IF cl_null(l_str) THEN
	       	     LET l_str = l_hrcka.hrcka03,l_hrcka.hrcka04,"'",l_hrcka.hrcka05,"'"
	       	  ELSE
	       	  	 LET l_str = l_str," AND ",l_hrcka.hrcka03,l_hrcka.hrcka04,"'",l_hrcka.hrcka05,"'"
	       	  END IF
	       	  IF NOT cl_null(l_hrcka.hrcka06) THEN	
	             LET l_str = l_str," AND ",l_hrcka.hrcka06,l_hrcka.hrcka07,"'",l_hrcka.hrcka08,"'" 
	          END IF 
	          IF NOT cl_null(l_hrcka.hrcka09) THEN	
	             LET l_str = l_str," AND ",l_hrcka.hrcka09,l_hrcka.hrcka10,"'",l_hrcka.hrcka11,"'" 
	          END IF
	          IF NOT cl_null(l_hrcka.hrcka12) THEN	
	             LET l_str = l_str," AND ",l_hrcka.hrcka12,l_hrcka.hrcka13,"'",l_hrcka.hrcka14,"'" 
	          END IF		                      
	       END IF
	    END FOREACH
	    LET l_sql = "INSERT INTO hrat_ttt SELECT hrat01 FROM hrat_file WHERE ",l_str," AND hratconf = 'Y' ORDER BY hrat01"
	    PREPARE hrat_pre1 FROM l_sql
	    EXECUTE hrat_pre1 
	    
	 END FOREACH       	
	 
END FUNCTION		
	
FUNCTION i056_hrat_set()
DEFINE l_str    STRING
DEFINE l_hrcka    RECORD LIKE hrcka_file.*
   INSERT INTO hrat_ttt SELECT * FROM hrat_temp      	
	 
END FUNCTION			
FUNCTION i056_2_menu()
 
   WHILE TRUE
      IF g_abc = 'N' THEN
        EXIT WHILE
      END IF    
      IF g_flag = 'hrck' THEN	
         CALL i056_2_bp1("G")
      ELSE
      	 CALL i056_2_bp2("G")
      END IF	   
      CASE g_action_choice  
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            	 IF g_flag ='hrck' THEN
            	 	  CALL i056_2_b1()
               ELSE
               	  CALL i056_2_b2()
               END IF 
            ELSE
               LET g_action_choice = NULL
            END IF
             
         WHEN "delete"
            IF cl_chk_act_auth() THEN
            	 IF g_flag ='hrck' THEN
            	 	  CALL i056_2_r1()
               ELSE
               	  CALL i056_2_r2()
               END IF 
            ELSE
               LET g_action_choice = NULL
            END IF    
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i056_2_i("u")
               IF INT_FLAG THEN
                  INITIALIZE tm.* TO NULL
                  LET INT_FLAG = 0
                  LET g_abc = 'N'
                  CALL cl_err('',9001,0)
               END IF
            END IF
                     
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
 
      END CASE
   END WHILE
END FUNCTION
  
FUNCTION i056_2_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   CALL cl_set_act_visible("insert",FALSE)
   DISPLAY ARRAY g_hrck TO s_hrck.* ATTRIBUTE(COUNT=gs_rec_b1,UNBUFFERED)
  
      BEFORE ROW
         LET ls_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()              
   
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY    
         
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DISPLAY   
      
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY   

      ON ACTION modify
         LET g_action_choice="modify"
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
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
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
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION    

FUNCTION i056_2_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680102 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
   CALL cl_set_act_visible("insert",FALSE)
   DISPLAY ARRAY g_hrat TO s_hrat.* ATTRIBUTE(COUNT=gs_rec_b,UNBUFFERED)
  
      BEFORE ROW
         LET ls_ac = ARR_CURR()
         CALL cl_show_fld_cont()              
   
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY    
         
      ON ACTION accept
         LET g_action_choice="detail"
         EXIT DISPLAY   
      
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY   

      ON ACTION modify
         LET g_action_choice="modify"
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
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
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
      AFTER DISPLAY
         CONTINUE DISPLAY 
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION    
	
FUNCTION i056_2_a()
DEFINE l_n    LIKE   type_file.num5                            
   MESSAGE ""
   CLEAR FORM
   CALL g_hrat.clear()
   INITIALIZE tm.* TO NULL

   CALL cl_opmsg('a')

   WHILE TRUE                     
      LET tm.b_date = g_today
      LET tm.e_date = g_today
      CALL i056_2_i("a")                       

      IF INT_FLAG THEN                            
         INITIALIZE tm.* TO NULL
         LET INT_FLAG = 0
         LET g_abc = 'N'
         CALL cl_err('',9001,0)
         EXIT WHILE
      ELSE 
         LET gs_rec_b=0 
         CALL g_hrat.clear() 
         CALL i056_2_b1()    
      END IF 
      EXIT WHILE
   END WHILE
           
END FUNCTION 
 
FUNCTION i056_2_i(p_cmd)                       
   DEFINE   p_cmd        LIKE type_file.chr1    
   DEFINE   l_count      LIKE type_file.num5  
   DEFINE   l_str        STRING 
   DEFINE   l_n,l_i      LIKE type_file.num5
   DEFINE   l_check      STRING
   DEFINE   l_date       LIKE type_file.chr10 

   CALL cl_set_head_visible("","YES")   
   DISPLAY tm.b_date TO b_date
   DISPLAY tm.e_date TO e_date
   INPUT tm.b_date,tm.e_date  WITHOUT DEFAULTS FROM b_date,e_date
      AFTER FIELD b_date 
          IF NOT cl_null(tm.b_date) AND NOT cl_null(tm.e_date) THEN
            IF tm.b_date>tm.e_date THEN
               CALL cl_err("开始日期不能大于结束日期",'!',0)
               NEXT FIELD b_date
            END IF
          END IF       
      AFTER FIELD e_date 
          IF NOT cl_null(tm.b_date) AND NOT cl_null(tm.e_date) THEN
            IF tm.b_date>tm.e_date THEN
               CALL cl_err("结束日期不能小于开始日期",'!',0)
               NEXT FIELD e_date
            END IF
          END IF    
                     
      AFTER INPUT 
         IF INT_FLAG THEN
            RETURN
         END IF 
                 
      ON ACTION controlf                  
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
      
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
END FUNCTION   
 
FUNCTION i056_2_r1()        

   IF s_shut(0) THEN RETURN END IF 
      
   BEGIN WORK
   IF cl_delh(0,0) THEN   
      DELETE FROM hrck_temp 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hrck_temp",'','',SQLCA.sqlcode,"","hrck_temp DELETE",0)  
         ROLLBACK WORK
      END IF   	        
   END IF
   COMMIT WORK
END FUNCTION 

FUNCTION i056_2_r2()        

   IF s_shut(0) THEN RETURN END IF 
      
   BEGIN WORK
   IF cl_delh(0,0) THEN 	                
      DELETE FROM hrat_temp 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","hrat_temp",'','',SQLCA.sqlcode,"","hrat_temp DELETE",0)  
         ROLLBACK WORK
      END IF 
   END IF
   COMMIT WORK
END FUNCTION 

FUNCTION i056_2_b1()
DEFINE l_sql        STRING
DEFINE l_wc1        STRING
DEFINE l_wc2        STRING
DEFINE l_wc3        STRING
DEFINE l_wc4        STRING

DEFINE
    ls_ac1_t          LIKE type_file.num5,
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
  
    LET gs_forupd_sql = "SELECT hrck01,'' ",
                       "  FROM hrck_temp WHERE hrck01=? FOR UPDATE "
    LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
    DECLARE i056_2_bcl CURSOR FROM gs_forupd_sql      # LOCK CURSOR
    
    INPUT ARRAY g_hrck WITHOUT DEFAULTS FROM s_hrck.*
          ATTRIBUTE (COUNT=gs_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF gs_rec_b1 != 0 THEN
             CALL fgl_set_arr_curr(ls_ac1)
          END IF  
        
       BEFORE ROW
          LET p_cmd='' 
          LET ls_ac1 = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF gs_rec_b1>=ls_ac1 THEN
             BEGIN WORK
             LET p_cmd='u'    
             LET g_hrck_t.* = g_hrck[ls_ac1].*  #BACKUP
             OPEN i056_2_bcl USING g_hrck_t.hrck01
             IF STATUS THEN
                CALL cl_err("OPEN i056_2_bcl:",STATUS,1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH i056_2_bcl INTO g_hrck[ls_ac1].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrck_t.hrck01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
             SELECT hrck02 INTO g_hrck[ls_ac1].hrck02
               FROM hrck_file
              WHERE hrck01 = g_hrck[ls_ac1].hrck01
              CALL cl_show_fld_cont()
          END IF 
         
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a' 
           INITIALIZE g_hrck[ls_ac1].* TO NULL                      
           CALL cl_show_fld_cont()     
           NEXT FIELD hrck01 
         
       AFTER INSERT
           DISPLAY "AFTER INSERT" 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_abc = 'N'
              CLOSE i056_2_bcl
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_hrck[ls_ac1].hrck01) THEN
  
              INSERT INTO hrck_temp(hrck01)
                    VALUES(g_hrck[ls_ac1].hrck01)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","hrck_temp",g_hrck[ls_ac1].hrck01,"",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL INSERT
              ELSE  
                 LET gs_rec_b1=gs_rec_b1+1    
                 DISPLAY gs_rec_b1 TO FORMONLY.hrck_cn2     
                 COMMIT WORK  
              END IF            
           END IF
         
        AFTER FIELD hrck01                       
           IF NOT cl_null(g_hrck[ls_ac1].hrck01) AND ((p_cmd = 'a') OR (p_cmd='u' AND g_hrck[ls_ac1].hrck01 <> g_hrck_t.hrck01)) THEN  
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM hrck_temp
               WHERE hrck01 = g_hrck[ls_ac1].hrck01
              IF l_n > 0 THEN 
                CALL cl_err('群组资料已经有了','!',0)
                NEXT FIELD hrck01                                
              END IF  
              SELECT hrck02 INTO g_hrck[ls_ac1].hrck02
                FROM hrck_file
               WHERE hrck01 = g_hrck[ls_ac1].hrck01
                 AND hrckacti = 'Y'
              IF STATUS THEN
                 CALL cl_err("无此群组编号",'!',0)
                 NEXT FIELD hrck01
              END IF
           END IF
             
          
        BEFORE DELETE                           
           IF g_hrck_t.hrck01 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 ROLLBACK WORK      
                 CANCEL DELETE
              END IF
              INITIALIZE g_doc.* TO NULL                                                                
              LET g_doc.column1 = "hrck01"                                                              
              LET g_doc.value1 = g_hrck[ls_ac1].hrck01                                                               
              CALL cl_del_doc()                                                                         
              IF l_lock_sw = "Y" THEN                                                                   
                 CALL cl_err("",-263,1) 
                 ROLLBACK WORK       
                 CANCEL DELETE 
              END IF 
           
              DELETE FROM hrck_temp WHERE hrck01 = g_hrck_t.hrck01
            
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrck_temp",g_hrck[ls_ac1].hrck01,g_hrck_t.hrck02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE
                 EXIT INPUT
              ELSE
                 LET gs_rec_b1=gs_rec_b1-1
                 DISPLAY gs_rec_b1 TO FORMONLY.hrck_cn2 
              END IF 
           END IF
          
        ON ROW CHANGE
           IF INT_FLAG THEN             
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_abc = 'N'
              LET g_hrck[ls_ac1].* = g_hrck_t.*
              CLOSE i056_2_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_hrck[ls_ac1].hrck01,-263,0)
              LET g_hrck[ls_ac1].* = g_hrck_t.*
           ELSE 
              UPDATE hrck_temp SET hrck01=g_hrck[ls_ac1].hrck01
                             WHERE hrck01 = g_hrck_t.hrck01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","hrck_temp",g_hrck[ls_ac1].hrck01,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK     
                 LET g_hrck[ls_ac1].* = g_hrck_t.*
              END IF
           END IF   
         
                     
         AFTER ROW
            LET ls_ac1 = ARR_CURR()            
            LET ls_ac1_t = ls_ac1                
         
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrck[ls_ac1].* = g_hrck_t.*
               END IF
               CLOSE i056_2_bcl                
               ROLLBACK WORK                 
               EXIT INPUT
            END IF
            CLOSE i056_2_bcl                
            COMMIT WORK      
         
         
         ON ACTION controlp
            CASE
                 WHEN INFIELD(hrck01)
                    IF p_cmd = 'a' THEN 
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_hrck01"
                       LET g_qryparam.construct = 'N'
                       LET g_qryparam.where = "hrckacti = 'Y' "
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING l_wc1
                       IF l_wc1 = " 1=1" THEN
                          LET l_wc1 = " 1=0"
                       ELSE
                          LET l_wc1 = cl_replace_str(l_wc1,"|","','")
                          LET l_wc1 = "('",l_wc1,"')"
                          LET l_wc1 = "hrck01 IN ",l_wc1
                          LET l_sql = "INSERT INTO hrck_temp SELECT 'Y',hrck01 FROM hrck_file WHERE hrck01 NOT IN(SELECT hrck01 FROM hrck_temp) AND hrckacti = 'Y' AND ",l_wc1
                          PREPARE hrck01_pre  FROM l_sql
                          EXECUTE hrck01_pre
                          CALL i056_2_b_fill()
                          CALL i056_2_b2()
                          EXIT INPUT
                       END IF
                    ELSE   
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_hrck01"
                       LET g_qryparam.default1 = g_hrck[ls_ac1].hrck01
                       CALL cl_create_qry() RETURNING g_hrck[ls_ac1].hrck01
                       DISPLAY BY NAME g_hrck[ls_ac1].hrck01
                       NEXT FIELD hrck01
                    END IF 
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
      
         ON ACTION about                      
            CALL cl_about()                   
                                              
         ON ACTION help                       
            CALL cl_show_help()               
      
    END INPUT   
    CLOSE i056_2_bcl
    COMMIT WORK 
END FUNCTION 
		 
FUNCTION i056_2_b2()
DEFINE l_sql        STRING
DEFINE l_wc1        STRING
DEFINE l_wc2        STRING
DEFINE l_wc3        STRING
DEFINE l_wc4        STRING

DEFINE
    ls_ac_t          LIKE type_file.num5,
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
 
 #   LET gs_forupd_sql = "SELECT hrat01,'','','','','','','','' ",
    LET gs_forupd_sql = "SELECT hrat01,'' ",
                       "  FROM hrat_temp WHERE hrat01=?  AND hratconf = 'Y' FOR UPDATE "
    LET gs_forupd_sql = cl_forupd_sql(gs_forupd_sql)
    DECLARE i056_2_bc2 CURSOR FROM gs_forupd_sql      # LOCK CURSOR
    
    INPUT ARRAY g_hrat WITHOUT DEFAULTS FROM s_hrat.*
          ATTRIBUTE (COUNT=gs_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
       BEFORE INPUT
          IF gs_rec_b != 0 THEN
             CALL fgl_set_arr_curr(ls_ac)
          END IF  
        
       BEFORE ROW
          LET p_cmd='' 
          LET ls_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
 
          IF gs_rec_b>=ls_ac THEN
             BEGIN WORK
             LET p_cmd='u'    
             LET g_hrat_t.* = g_hrat[ls_ac].*  #BACKUP
             OPEN i056_2_bc2 USING g_hrat_t.hrat01
             IF STATUS THEN
                CALL cl_err("OPEN i056_2_bc2:",STATUS,1)
                LET l_lock_sw = "Y"
             ELSE 
                FETCH i056_2_bc2 INTO g_hrat[ls_ac].* 
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_hrat_t.hrat01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
             END IF
#             SELECT hrat02,hrat04,hrat05,hrat25,hrat19 INTO g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19
              SELECT hrat02 INTO g_hrat[ls_ac].hrat02
               FROM hrat_file
              WHERE hrat01 = g_hrat[ls_ac].hrat01
                AND hratconf = 'Y'
#             SELECT hrao02 INTO g_hrat[ls_ac].hrao02 FROM hrao_file WHERE hrao01 = g_hrat[ls_ac].hrat04        
#             SELECT hrap06 INTO g_hrat[ls_ac].hras04 FROM hrap_file WHERE hrap05 = g_hrat[ls_ac].hrat05 AND hrap01 = g_hrat[ls_ac].hrat04 
#             SELECT hrad03 INTO g_hrat[ls_ac].hrat19_name FROM hrad_file WHERE hrad02 = g_hrat[ls_ac].hrat19 AND rownum = 1
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF 
         
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a' 
           INITIALIZE g_hrat[ls_ac].* TO NULL                            
           CALL cl_show_fld_cont()     
           NEXT FIELD hrat01 
         
       AFTER INSERT
           DISPLAY "AFTER INSERT" 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_abc = 'N'
              CLOSE i056_2_bc2
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_hrat[ls_ac].hrat01) THEN
  
              INSERT INTO hrat_temp(hrat01)
                    VALUES(g_hrat[ls_ac].hrat01)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","hrat_temp",g_hrat[ls_ac].hrat01,"",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL INSERT
              ELSE  
                 LET gs_rec_b=gs_rec_b+1    
                 DISPLAY gs_rec_b TO FORMONLY.hrat_cn2     
                 COMMIT WORK  
              END IF            
           END IF
         
        AFTER FIELD hrat01                       
           IF NOT cl_null(g_hrat[ls_ac].hrat01) AND ((p_cmd = 'a') OR (p_cmd='u' AND g_hrat[ls_ac].hrat01 <> g_hrat_t.hrat01)) THEN  
              LET l_n=0
              SELECT COUNT(*) INTO l_n FROM hrat_temp
               WHERE hrat01 = g_hrat[ls_ac].hrat01
              IF l_n > 0 THEN 
                CALL cl_err('员工资料已经有了','!',0)
                NEXT FIELD hrat01                                
              END IF  
#              SELECT hrat02,hrat04,hrat05,hrat25,hrat19 INTO g_hrat[ls_ac].hrat02,g_hrat[ls_ac].hrat04,g_hrat[ls_ac].hrat05,g_hrat[ls_ac].hrat25,g_hrat[ls_ac].hrat19
               SELECT hrat02 INTO g_hrat[ls_ac].hrat02
                FROM hrat_file
               WHERE hrat01 = g_hrat[ls_ac].hrat01
                 AND hratconf = 'Y'
              IF STATUS THEN
                 CALL cl_err("无此员工编号",'!',0)
                 NEXT FIELD hrat01
              END IF
           END IF
             
          
        BEFORE DELETE                           
           IF g_hrat_t.hrat01 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 ROLLBACK WORK      
                 CANCEL DELETE
              END IF
              INITIALIZE g_doc.* TO NULL                                                                
              LET g_doc.column1 = "hrat01"                                                              
              LET g_doc.value1 = g_hrat[ls_ac].hrat01                                                               
              CALL cl_del_doc()                                                                         
              IF l_lock_sw = "Y" THEN                                                                   
                 CALL cl_err("",-263,1) 
                 ROLLBACK WORK       
                 CANCEL DELETE 
              END IF 
           
              DELETE FROM hrat_temp WHERE hrat01 = g_hrat_t.hrat01
            
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","hrat_temp",g_hrat[ls_ac].hrat01,g_hrat_t.hrat02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                 ROLLBACK WORK      #FUN-680010
                 CANCEL DELETE
                 EXIT INPUT
              ELSE
                 LET gs_rec_b=gs_rec_b-1
                 DISPLAY gs_rec_b TO FORMONLY.hrat_cn2 
              END IF 
           END IF
          
        ON ROW CHANGE
           IF INT_FLAG THEN             
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_abc = 'N'
              LET g_hrat[ls_ac].* = g_hrat_t.*
              CLOSE i056_2_bc2
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_hrat[ls_ac].hrat01,-263,0)
              LET g_hrat[ls_ac].* = g_hrat_t.*
           ELSE 
              UPDATE hrat_temp SET hrat01=g_hrat[ls_ac].hrat01
                             WHERE hrat01 = g_hrat_t.hrat01
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","hrat_temp",g_hrat[ls_ac].hrat01,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK     
                 LET g_hrat[ls_ac].* = g_hrat_t.*
              END IF
           END IF   
         
                     
         AFTER ROW
            LET ls_ac = ARR_CURR()            
            LET ls_ac_t = ls_ac                
         
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_hrat[ls_ac].* = g_hrat_t.*
               END IF
               CLOSE i056_2_bc2                
               ROLLBACK WORK                 
               EXIT INPUT
            END IF
            CLOSE i056_2_bc2                
            COMMIT WORK      
         
         
         ON ACTION controlp
            CASE
                 WHEN INFIELD(hrat01)
                    IF p_cmd = 'a' THEN 
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_hrat01"
                       LET g_qryparam.construct = 'N'
                       LET g_qryparam.where = "hratconf = 'Y' "
                       LET g_qryparam.state = "c"
                       CALL cl_create_qry() RETURNING l_wc1
                       IF l_wc1 = " 1=1" THEN
                          LET l_wc1 = " 1=0"
                       ELSE
                          LET l_wc1 = cl_replace_str(l_wc1,"|","','")
                          LET l_wc1 = "('",l_wc1,"')"
                          LET l_wc1 = "hrat01 IN ",l_wc1
                          LET l_sql = "INSERT INTO hrat_temp SELECT 'Y',hrat01 FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM hrat_temp) AND hratconf = 'Y' AND ",l_wc1
                          PREPARE hrat01_pre  FROM l_sql
                          EXECUTE hrat01_pre
                          CALL i056_2_b_fill()
                          CALL i056_2_b2()
                          EXIT INPUT
                       END IF
                    ELSE   
                       CALL cl_init_qry_var()
                       LET g_qryparam.form ="q_hrat01"
                       LET g_qryparam.default1 = g_hrat[ls_ac].hrat01
                       CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat01
                       DISPLAY BY NAME g_hrat[ls_ac].hrat01
                       NEXT FIELD hrat01
                    END IF
#                 WHEN INFIELD(hrat04)
#                    IF p_cmd = 'a' THEN
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_hrao01"
#                       LET g_qryparam.construct = 'N' 
#                       LET g_qryparam.state = "c"
#                       CALL cl_create_qry() RETURNING l_wc2
#                       IF l_wc2 = " 1=1" THEN
#                          LET l_wc2 = " 1=0"
#                       ELSE
#                          LET l_wc2 = cl_replace_str(l_wc2,"|","','")
#                          LET l_wc2 = "('",l_wc2,"')"
#                          LET l_wc2 = "hrat04 IN ",l_wc2
#                          LET l_sql = "INSERT INTO hrat_temp SELECT 'Y',hrat01 FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM hrat_temp) AND hratconf = 'Y' AND ",l_wc2
#                          PREPARE hrat04_pre  FROM l_sql
#                          EXECUTE hrat04_pre
#                          CALL i056_2_b_fill()
#                          CALL i056_2_b1()
#                          EXIT INPUT
#                       END IF
#                    ELSE    
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form ="q_hrao01"
#                       LET g_qryparam.default1 = g_hrat[ls_ac].hrat04
#                       CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat04
#                       DISPLAY BY NAME g_hrat[ls_ac].hrat04
#                       NEXT FIELD hrat04
#                    END IF
#                 WHEN INFIELD(hrat05)
#                    IF p_cmd = 'a' THEN
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_hrap01"
#                       LET g_qryparam.construct = 'N' 
#                       LET g_qryparam.state = "c"
#                       CALL cl_create_qry() RETURNING l_wc3
#                       IF l_wc3 = " 1=1" THEN
#                          LET l_wc3 = " 1=0"
#                       ELSE
#                          LET l_wc3 = cl_replace_str(l_wc3,"|","','")
#                          LET l_wc3 = "('",l_wc3,"')"
#                          LET l_wc3 = "hrat05 IN ",l_wc3
#                          LET l_sql = "INSERT INTO hrat_temp SELECT 'Y',hrat01 FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM hrat_temp) AND hratconf = 'Y' AND ",l_wc3
#                          PREPARE hrat05_pre  FROM l_sql
#                          EXECUTE hrat05_pre
#                          CALL i056_2_b_fill()
#                          CALL i056_2_b1()
#                          EXIT INPUT
#                       END IF
#                    ELSE    
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form ="q_hrap01"
#                       LET g_qryparam.default1 = g_hrat[ls_ac].hrat05
#                       CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat05
#                       DISPLAY BY NAME g_hrat[ls_ac].hrat05
#                       NEXT FIELD hrat05
#                    END IF
#                 WHEN INFIELD(hrat19)
#                    IF p_cmd = 'a' THEN
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form = "q_hrad02"
#                       LET g_qryparam.construct = 'N' 
#                       LET g_qryparam.state = "c"
#                       CALL cl_create_qry() RETURNING l_wc4
#                       IF l_wc4 = " 1=1" THEN
#                          LET l_wc4 = " 1=0"
#                       ELSE
#                          LET l_wc4 = cl_replace_str(l_wc4,"|","','")
#                          LET l_wc4 = "('",l_wc4,"')"
#                          LET l_wc4 = "hrat19 IN ",l_wc4
#                          LET l_sql = "INSERT INTO hrat_temp SELECT 'Y',hrat01 FROM hrat_file WHERE hrat01 NOT IN(SELECT hrat01 FROM hrat_temp) AND hratconf = 'Y' AND ",l_wc4
#                          PREPARE hrat19_pre  FROM l_sql
#                          EXECUTE hrat19_pre
#                          CALL i056_2_b_fill()
#                          CALL i056_2_b1()
#                          EXIT INPUT
#                       END IF
#                    ELSE    
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form ="q_hrad02"
#                       LET g_qryparam.default1 = g_hrat[ls_ac].hrat19
#                       CALL cl_create_qry() RETURNING g_hrat[ls_ac].hrat19
#                       DISPLAY BY NAME g_hrat[ls_ac].hrat19
#                       NEXT FIELD hrat19
#                    END IF
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
      
         ON ACTION about                      
            CALL cl_about()                   
                                              
         ON ACTION help                       
            CALL cl_show_help()               
      
    END INPUT   
    CLOSE i056_2_bc2
    COMMIT WORK 
END FUNCTION 
  
FUNCTION i056_2_b_fill()
    DEFINE l_sql     STRING 
     LET l_sql = "SELECT hrck01,'' ",
                " FROM hrck_temp ",
                " ORDER BY hrck01"

    PREPARE i056_2_pb1 FROM l_sql
    DECLARE hrck_1_curs CURSOR FOR i056_2_pb1

    CALL g_hrck.clear()
    LET gs_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrck_1_curs INTO g_hrck[gs_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        SELECT hrck02 INTO g_hrck[gs_cnt].hrck02
          FROM hrck_file
         WHERE hrck01 = g_hrck[gs_cnt].hrck01 
        LET gs_cnt = gs_cnt + 1 
    END FOREACH
    CALL g_hrck.deleteElement(gs_cnt)
    MESSAGE ""
    LET gs_rec_b1 = gs_cnt-1
    DISPLAY gs_rec_b1 TO FORMONLY.hrck_cn2 
        
#    LET l_sql = "SELECT hratacti,hrat01,'','','','','','','','' ",
     LET l_sql = "SELECT hrat01,'' ",
                " FROM hrat_temp ",
                " ORDER BY hrat01"

    PREPARE i056_2_pb FROM l_sql
    DECLARE hrat_1_curs CURSOR FOR i056_2_pb

    CALL g_hrat.clear()
    LET gs_cnt = 1
    MESSAGE "Searching!"
    FOREACH hrat_1_curs INTO g_hrat[gs_cnt].*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
#        SELECT hrat02,hrat04,hrat05,hrat25,hrat19 INTO g_hrat[gs_cnt].hrat02,g_hrat[gs_cnt].hrat04,g_hrat[gs_cnt].hrat05,g_hrat[gs_cnt].hrat25,g_hrat[gs_cnt].hrat19 
        SELECT hrat02 INTO g_hrat[gs_cnt].hrat02
          FROM hrat_file
         WHERE hrat01 = g_hrat[gs_cnt].hrat01
           AND hratconf = 'Y'
#        SELECT hrao02 INTO g_hrat[gs_cnt].hrao02 FROM hrao_file WHERE hrao01 = g_hrat[gs_cnt].hrat04
#        SELECT hrap06 INTO g_hrat[gs_cnt].hras04 FROM hrap_file WHERE hrap05 = g_hrat[gs_cnt].hrat05 AND hrap01 = g_hrat[gs_cnt].hrat04
#        SELECT hrad03 INTO g_hrat[gs_cnt].hrat19_name FROM hrad_file WHERE hrad02 = g_hrat[gs_cnt].hrat19 AND rownum = 1       
        LET gs_cnt = gs_cnt + 1 
    END FOREACH
    CALL g_hrat.deleteElement(gs_cnt)
    MESSAGE ""
    LET gs_rec_b = gs_cnt-1
    DISPLAY gs_rec_b TO FORMONLY.hrat_cn2 

END FUNCTION

# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri090
# Descriptions...: 社会统筹补缴管理
# Date & Author..: 13/07/10 zhangbo
#MODIFY..........: add by zhuzw 20140922 增加删除功能 

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql         STRING,
       g_wc1         STRING,                                           
       g_wc2         STRING
DEFINE g_hrdv1      DYNAMIC ARRAY OF RECORD
         hrdv01      LIKE   hrdv_file.hrdv01,
         hrat02      LIKE   hrat_file.hrat02,
         hrat04      LIKE   hrao_file.hrao02,
         hrdv02      LIKE   type_file.chr50,
         hrdt03      LIKE   hrdt_file.hrdt03,
         hrdv07      LIKE   hrdv_file.hrdv07,
         hrdv03      LIKE   hrdv_file.hrdv03,
         hrdv05      LIKE   hrdv_file.hrdv05,
         hrdv06      LIKE   hrdv_file.hrdv06,
         hrdv04      LIKE   hrdv_file.hrdv04,
         hrdv09      LIKE   hrdv_file.hrdv09,
         hrdv10      LIKE   hrdv_file.hrdv10,
         hrdv11      LIKE   hrdv_file.hrdv11,
         hrdv12      LIKE   hrdv_file.hrdv12,
         hrdv13      LIKE   hrdv_file.hrdv13,
         hrdv00      LIKE   hrdv_file.hrdv00
                     END RECORD,
       g_rec_b1      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5
DEFINE g_hrdv1_t     RECORD
         hrdv01      LIKE   hrdv_file.hrdv01,
         hrat02      LIKE   hrat_file.hrat02,
         hrat04      LIKE   hrao_file.hrao02,
         hrdv02      LIKE   type_file.chr50,
         hrdt03      LIKE   hrdt_file.hrdt03,
         hrdv07      LIKE   hrdv_file.hrdv07,
         hrdv03      LIKE   hrdv_file.hrdv03,
         hrdv05      LIKE   hrdv_file.hrdv05,
         hrdv06      LIKE   hrdv_file.hrdv06,
         hrdv04      LIKE   hrdv_file.hrdv04,
         hrdv09      LIKE   hrdv_file.hrdv09,
         hrdv10      LIKE   hrdv_file.hrdv10,
         hrdv11      LIKE   hrdv_file.hrdv11,
         hrdv12      LIKE   hrdv_file.hrdv12,
         hrdv13      LIKE   hrdv_file.hrdv13,
         hrdv00      LIKE   hrdv_file.hrdv00
                     END RECORD
DEFINE g_hrdv2      DYNAMIC ARRAY OF RECORD
         hrdv01      LIKE   hrdv_file.hrdv01,
         hrat02      LIKE   hrat_file.hrat02,
         hrat04      LIKE   hrao_file.hrao02,
         hrdv02      LIKE   type_file.chr50,
         hrdt03      LIKE   hrdt_file.hrdt03,
         hrdv07      LIKE   hrdv_file.hrdv07,
         hrdv03      LIKE   hrdv_file.hrdv03,
         hrdv05      LIKE   hrdv_file.hrdv05,
         hrdv06      LIKE   hrdv_file.hrdv06,
         hrdv04      LIKE   hrdv_file.hrdv04,
         hrdv09      LIKE   hrdv_file.hrdv09,
         hrdv10      LIKE   hrdv_file.hrdv10,
         hrdv11      LIKE   hrdv_file.hrdv11,
         hrdv12      LIKE   hrdv_file.hrdv12,
         hrdv13      LIKE   hrdv_file.hrdv13,
         hrdv00      LIKE   hrdv_file.hrdv00
                     END RECORD,
       g_rec_b2      LIKE type_file.num5,
       l_ac2         LIKE type_file.num5
DEFINE g_hrdv      DYNAMIC ARRAY OF RECORD
         hrdv00      LIKE   hrdv_file.hrdv00,
         hrdv07      LIKE   hrdv_file.hrdv07,
         hrdv08      LIKE   hrdv_file.hrdv08,
         hrdv09      LIKE   hrdv_file.hrdv09,
         hrdv10      LIKE   hrdv_file.hrdv10,
         hrdv11      LIKE   hrdv_file.hrdv11,
         hrdv12      LIKE   hrdv_file.hrdv12
                     END RECORD,
       g_rec_b3      LIKE type_file.num5,
       l_ac3         LIKE type_file.num5
DEFINE g_hrdv_t     RECORD
         hrdv00      LIKE   hrdv_file.hrdv00,
         hrdv07      LIKE   hrdv_file.hrdv07,
         hrdv08      LIKE   hrdv_file.hrdv08,
         hrdv09      LIKE   hrdv_file.hrdv09,
         hrdv10      LIKE   hrdv_file.hrdv10,
         hrdv11      LIKE   hrdv_file.hrdv11,
         hrdv12      LIKE   hrdv_file.hrdv12
                     END RECORD         
DEFINE g_flag               LIKE type_file.chr10
DEFINE g_forupd_sql         STRING                       
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_row_count          LIKE type_file.num5       
DEFINE g_curs_index         LIKE type_file.num5      
DEFINE g_cnt                LIKE type_file.num10         
DEFINE l_items              STRING
DEFINE l_name               STRING 
DEFINE l_start,l_end            LIKE hrdv_file.hrdv00


MAIN
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
 
   OPEN WINDOW i090_w WITH FORM "ghr/42f/ghri090"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
          
   CALL cl_ui_init()
   
   #CALL cl_set_combo_items("hrdv02_1",NULL,NULL)
   #CALL cl_set_combo_items("hrdv02_2",NULL,NULL)
   CALL cl_set_combo_items("hrdv07_1",NULL,NULL)
   CALL cl_set_combo_items("hrdv07_2",NULL,NULL)
   CALL cl_set_combo_items("hrdv03_1",NULL,NULL)
   CALL cl_set_combo_items("hrdv03_2",NULL,NULL)
   
   #社会统筹体系
   #CALL i090_get_hrdv02() RETURNING l_name,l_items
   #CALL cl_set_combo_items("hrdv02_1",l_name,l_items)
   #CALL cl_set_combo_items("hrdv02_2",l_name,l_items)
   
   #参数分类
   CALL i090_get_hrdv07() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdv07_1",l_name,l_items)
   CALL cl_set_combo_items("hrdv07_2",l_name,l_items)
   
   #补缴标志
   CALL i090_get_items('642') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdv03_1",l_name,l_items)
   CALL cl_set_combo_items("hrdv03_2",l_name,l_items)
   
   LET g_wc1=" 1=1"
   LET g_wc2=" 1=1"
   
   CALL i090_b_fill()
      
   LET g_flag = 'pg1'
   CALL i090_menu()
   CLOSE WINDOW i090_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i090_get_hrdv02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrdt01 LIKE hrdt_file.hrdt01
DEFINE l_hrdt02 LIKE hrdt_file.hrdt02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrdt01,hrdt02 FROM hrdt_file ",
                 "  ORDER BY hrdt01"
       PREPARE i090_get_hrdv02_pre FROM l_sql
       DECLARE i090_get_hrdv02 CURSOR FOR i090_get_hrdv02_pre
       FOREACH i090_get_hrdv02 INTO l_hrdt01,l_hrdt02
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrdt01
            LET p_items=l_hrdt02
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrdt01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrdt02 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION	

FUNCTION i090_get_hrdv07()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrds01 LIKE hrds_file.hrds01
DEFINE l_hrds02 LIKE hrds_file.hrds02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrds01,hrds02 FROM hrds_file ",
                 "  ORDER BY hrds01"
       PREPARE i090_get_hrdv07_pre FROM l_sql
       DECLARE i090_get_hrdv07 CURSOR FOR i090_get_hrdv07_pre
       FOREACH i090_get_hrdv07 INTO l_hrds01,l_hrds02
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrds01
            LET p_items=l_hrds02
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrds01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrds02 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION
	
FUNCTION i090_get_items(p_hrag01)
DEFINE p_hrag01 LIKE  hrag_file.hrag01
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE p_hrag06 LIKE  hrag_file.hrag06
DEFINE p_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE i090_get_items_pre FROM l_sql
       DECLARE i090_get_items CURSOR FOR i090_get_items_pre
       FOREACH i090_get_items INTO p_hrag06,p_hrag07
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=p_hrag06
            LET p_items=p_hrag07
          ELSE
            LET p_name=p_name CLIPPED,",",p_hrag06 CLIPPED
            LET p_items=p_items CLIPPED,",",p_hrag07 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION
	
FUNCTION i090_menu()
DEFINE l_n   LIKE  type_file.num5
DEFINE l_msg  STRING
DEFINE l_hratid LIKE hrat_file.hratid
 
   WHILE TRUE
   	  CASE g_flag
   	     WHEN 'pg1'	
            CALL i090_bp1("G")    #包含第一页签DISPLAY
         WHEN 'pg2'
            CALL i090_bp2("G")    #包含第二页签DISPLAY
         OTHERWISE
            CALL i090_bp("G")    #包含所有页签DISPLAY
      END CASE
      	                          
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
            	 CASE g_flag
            	 	  WHEN 'pg1'  	CALL i090_q1()
            	 	  WHEN 'pg2'  	CALL i090_q2()
            	 END CASE	    
            END IF
            	
         WHEN "ghri090_a"
            IF cl_chk_act_auth() THEN
            	 CALL i090_xinzeng()
            	 CALL i090_b_fill()
            END IF
          #add by zhuzw 20140922 start
         WHEN "delt"    #批量删除功能
            IF cl_chk_act_auth() THEN 
               IF g_flag ='pg1' OR cl_null(g_flag) THEN
                    IF  cl_confirm('cghr002') THEN
                        SELECT hratid INTO l_hratid FROM hrat_file
                         WHERE hrat01 = g_hrdv1[l_ac1].hrdv01
                        DELETE FROM hrdv_file WHERE hrdv01 =  l_hratid   AND hrdv05 =  g_hrdv1[l_ac1].hrdv05                
                        LET l_msg = g_hrdv1[l_ac1].hrdv01,'-',g_hrdv1[l_ac1].hrat02,'/',g_hrdv1[l_ac1].hrdv05                        
                        CALL cl_err(l_msg,'cghr001',1)  
                        CALL i090_b_fill()
                    END IF
               END IF  
            END IF     
         #add by zhuzw 20140922 end           	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            	 CALL i090_b()
            END IF   		    	   	
            	                                                                                                                                                                                                                          
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
               CASE g_flag
               	  WHEN 'pg1'  
                     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdv1),'','')
                  WHEN 'pg2'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdv2),'','')
               END CASE	                     
            END IF
      END CASE
   END WHILE

END FUNCTION
	
FUNCTION i090_q1()
   CALL i090_b1_askkey()
END FUNCTION
	
FUNCTION i090_b1_askkey()
    CLEAR FORM
    CALL g_hrdv1.clear()
 
    CONSTRUCT g_wc1 ON hrdv01,hrdv02,hrdv07,hrdv03,hrdv05,hrdv06,hrdv04,
                       hrdv09,hrdv10,hrdv11,hrdv12,hrdv13                       
         FROM s_hrdv1[1].hrdv01_1,s_hrdv1[1].hrdv02_1,s_hrdv1[1].hrdv07_1,                                  
              s_hrdv1[1].hrdv03_1,s_hrdv1[1].hrdv05_1,s_hrdv1[1].hrdv06_1,
              s_hrdv1[1].hrdv04_1,s_hrdv1[1].hrdv09_1,s_hrdv1[1].hrdv10_1,
              s_hrdv1[1].hrdv11_1,s_hrdv1[1].hrdv12_1,s_hrdv1[1].hrdv13_1
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrdv01_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv1[1].hrdv01_1
               NEXT FIELD hrdv01_1
            WHEN INFIELD(hrdv05_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv1[1].hrdv05_1
               NEXT FIELD hrdv05_1
            WHEN INFIELD(hrdv06_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv1[1].hrdv06_1
               NEXT FIELD hrdv06_1
            WHEN INFIELD(hrdv04_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv1[1].hrdv04_1
               NEXT FIELD hrdv04_1         
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
    
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc1 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
    
    CALL cl_replace_str(g_wc1,'hrdv01','hrat01') RETURNING g_wc1
 
    CALL i090_b_fill()	
END FUNCTION		
	
FUNCTION i090_q2()
   CALL i090_b2_askkey()
END FUNCTION
	
FUNCTION i090_b2_askkey()
    CLEAR FORM
    CALL g_hrdv2.clear()
 
    CONSTRUCT g_wc2 ON hrdv01,hrdv02,hrdv07,hrdv03,hrdv05,hrdv06,hrdv04,
                       hrdv09,hrdv10,hrdv11,hrdv12,hrdv13                       
         FROM s_hrdv2[1].hrdv01_2,s_hrdv2[1].hrdv02_2,s_hrdv2[1].hrdv07_2,                                  
              s_hrdv2[1].hrdv03_2,s_hrdv2[1].hrdv05_2,s_hrdv2[1].hrdv06_2,
              s_hrdv2[1].hrdv04_2,s_hrdv2[1].hrdv09_2,s_hrdv2[1].hrdv10_2,
              s_hrdv2[1].hrdv11_2,s_hrdv2[1].hrdv12_2,s_hrdv2[1].hrdv13_2
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrdv01_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv2[1].hrdv01_2
               NEXT FIELD hrdv01_2
            WHEN INFIELD(hrdv05_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv2[1].hrdv05_2
               NEXT FIELD hrdv05_2
            WHEN INFIELD(hrdv06_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv2[1].hrdv06_2
               NEXT FIELD hrdv06_2
            WHEN INFIELD(hrdv04_2)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdv2[1].hrdv04_2
               NEXT FIELD hrdv04_2         
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
    
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc2 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
    
    CALL cl_replace_str(g_wc2,'hrdv01','hrat01') RETURNING g_wc2
 
    CALL i090_b_fill()	
END FUNCTION	
	
FUNCTION i090_b_fill()
	  #未关帐
	  LET g_sql=" SELECT hrdv01,'','',hrdt02,'',hrdv07,hrdv03,hrdv05,hrdv06,",
	            "        hrdv04,hrdv09,hrdv10,hrdv11,hrdv12,hrdv13,hrdv00",
	            "   FROM hrdv_file,hrat_file,hrct_file,hrdt_file ",
	            "  WHERE hrdv01=hratid ",
	            "    AND hrdv04=hrct11 AND hrdv02=hrdt01 ",
	            "    AND hrct06='N' AND ",g_wc1,
	            "  ORDER BY hrdv00,hrdv01"
	  PREPARE i090_pb1 FROM g_sql
    DECLARE hrdv1_curs CURSOR FOR i090_pb1
    
    CALL g_hrdv1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdv1_curs INTO g_hrdv1[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hrat01 INTO g_hrdv1[g_cnt].hrdv01 FROM hrat_file
         WHERE hratid=g_hrdv1[g_cnt].hrdv01
         
        SELECT hrat02 INTO g_hrdv1[g_cnt].hrat02 FROM hrat_file
         WHERE hrat01=g_hrdv1[g_cnt].hrdv01  
        
        SELECT hrao02 INTO g_hrdv1[g_cnt].hrat04
          FROM hrao_file,hrat_file
         WHERE hrat01=g_hrdv1[g_cnt].hrdv01
           AND hrat04=hrao01
        
        SELECT hrag07 INTO g_hrdv1[g_cnt].hrdt03
          FROM hrdt_file,hrag_file
         WHERE hrdt01=g_hrdv1[g_cnt].hrdv02
           AND hrdt03=hrag06
           AND hrag01='652'         	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdv1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1 
    LET g_cnt = 0
    
    #已关帐
	  LET g_sql=" SELECT hrdv01,'','',hrdv02,'',hrdv07,hrdv03,hrdv05,hrdv06,",
	            "        hrdv04,hrdv09,hrdv10,hrdv11,hrdv12,hrdv13,hrdv00",
	            "   FROM hrdv_file,hrat_file,hrct_file ",
	            "  WHERE hrdv01=hratid ",
	            "    AND hrdv04=hrct11 ",
	            "    AND hrct06='Y' AND ",g_wc2,
	            "  ORDER BY hrdv00,hrdv01"
	  PREPARE i090_pb2 FROM g_sql
    DECLARE hrdv2_curs CURSOR FOR i090_pb2
    
    CALL g_hrdv2.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdv2_curs INTO g_hrdv2[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hrat01 INTO g_hrdv2[g_cnt].hrdv01 FROM hrat_file
         WHERE hratid=g_hrdv2[g_cnt].hrdv01
         
        SELECT hrat02 INTO g_hrdv2[g_cnt].hrat02 FROM hrat_file
         WHERE hrat01=g_hrdv2[g_cnt].hrdv01  
        
        SELECT hrao02 INTO g_hrdv2[g_cnt].hrat04
          FROM hrao_file,hrat_file
         WHERE hrat01=g_hrdv2[g_cnt].hrdv01
           AND hrat04=hrao01
        
        SELECT hrag07 INTO g_hrdv2[g_cnt].hrdt03
          FROM hrdt_file,hrag_file
         WHERE hrdt01=g_hrdv2[g_cnt].hrdv02
           AND hrdt03=hrag06
           AND hrag01='652'         	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdv2.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1 
    LET g_cnt = 0
    	                 	
END FUNCTION	

FUNCTION i090_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      DISPLAY ARRAY g_hrdv1 TO s_hrdv1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b1 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
         
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail"
         EXIT DIALOG          
      
      ON ACTION accept
         LET l_ac1 = ARR_CURR()
         LET g_action_choice="detail"
         EXIT DIALOG 
      
      ON ACTION ghri090_a
         LET g_action_choice="ghri090_a"
         EXIT DIALOG
      #add by zhuzw 20140922 start   
      ON ACTION delt
         LET l_ac1=ARR_CURR()
         LET g_action_choice="delt" 
         EXIT DIALOG  
      #add by zhuzw 20140922 end                                  
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdv2 TO s_hrdv2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b2 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
           
      END DISPLAY 
           
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                                               
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i090_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdv1 TO s_hrdv1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b1 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 
      
      ON ACTION ghri090_a
         LET g_action_choice="ghri090_a"
         EXIT DIALOG 
      
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail" 
         EXIT DIALOG
      #add by zhuzw 20140922 start   
      ON ACTION delt
         LET l_ac1=ARR_CURR()
         LET g_action_choice="delt" 
         EXIT DIALOG  
      #add by zhuzw 20140922 end         
      ON ACTION accept
         LET l_ac1=ARR_CURR()
         LET g_action_choice="detail" 
         EXIT DIALOG                                                   
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
	
FUNCTION i090_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdv2 TO s_hrdv2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b2 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG                                             
 
      ON ACTION help
         LET g_action_choice="help"
         CALL cl_show_help()               
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()          
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG   
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
                                                                                      
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION	
	
FUNCTION i090_b()
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE l_n             LIKE type_file.num5
DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
DEFINE l_hrct08_b,l_hrct08_e    LIKE hrct_file.hrct08 
DEFINE l_hrat03                 LIKE hrat_file.hrat03
DEFINE l_hratid                 LIKE hrat_file.hratid
   
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = " SELECT hrdv01,'','',hrdv02,'',hrdv07,hrdv03,hrdv05,hrdv06,",
	                     "        hrdv04,hrdv09,hrdv10,hrdv11,hrdv12,hrdv13,hrdv00",
	                     "   FROM hrdv_file",
                       "  WHERE hrdv00 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i090_cl CURSOR FROM g_forupd_sql
   
    INPUT ARRAY g_hrdv1 WITHOUT DEFAULTS FROM s_hrdv1.*
      ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_rec_b1,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

        BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac1)
           END IF

        BEFORE ROW
            LET l_lock_sw = 'N' 
            LET l_ac1 = ARR_CURR()            
            IF g_rec_b1 >= l_ac1 THEN    
               BEGIN WORK
               LET g_hrdv1_t.* = g_hrdv1[l_ac1].*  #BACKUP
               OPEN i090_cl USING g_hrdv1_t.hrdv00
               IF STATUS THEN
                  CALL cl_err("OPEN i090_cl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i090_cl INTO g_hrdv1[l_ac1].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrdv1_t.hrdv00,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF 
               	
               SELECT hrat01 INTO g_hrdv1[l_ac1].hrdv01 FROM hrat_file
                WHERE hratid=g_hrdv1[l_ac1].hrdv01
         
               SELECT hrat02 INTO g_hrdv1[l_ac1].hrat02 FROM hrat_file
                WHERE hrat01=g_hrdv1[l_ac1].hrdv01  
        
               SELECT hrao02 INTO g_hrdv1[l_ac1].hrat04
                 FROM hrao_file,hrat_file
                WHERE hrat01=g_hrdv1[l_ac1].hrdv01
                  AND hrat04=hrao01
        
               SELECT hrag07 INTO g_hrdv1[l_ac1].hrdt03
                 FROM hrdt_file,hrag_file
                WHERE hrdt01=g_hrdv1[l_ac1].hrdv02
                  AND hrdt03=hrag06
                  AND hrag01='652'
                  
               CALL cl_show_fld_cont()
            END IF
            
        ON ACTION controlp
           CASE 
           	  WHEN INFIELD(hrdv05_1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 CALL cl_create_qry() RETURNING g_hrdv1[l_ac1].hrdv05
                 DISPLAY BY NAME g_hrdv1[l_ac1].hrdv05
                 NEXT FIELD hrdv05_1
              WHEN INFIELD(hrdv06_1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 CALL cl_create_qry() RETURNING g_hrdv1[l_ac1].hrdv06
                 DISPLAY BY NAME g_hrdv1[l_ac1].hrdv06
                 NEXT FIELD hrdv06_1
              WHEN INFIELD(hrdv04_1)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrct11"
                 CALL cl_create_qry() RETURNING g_hrdv1[l_ac1].hrdv04
                 DISPLAY BY NAME g_hrdv1[l_ac1].hrdv04
                 NEXT FIELD hrdv04_1      
           END CASE
           	
        AFTER FIELD hrdv05_1
           IF NOT cl_null(g_hrdv1[l_ac1].hrdv05) THEN
           	  LET l_n=0
           	  SELECT hrat03 INTO l_hrat03 FROM hrat_file 
           	   WHERE hrat01=g_hrdv1[l_ac1].hrdv01
           	  SELECT COUNT(*) INTO l_n FROM hrct_file
           	   WHERE hrct11=g_hrdv1[l_ac1].hrdv05
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#           	     AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
           	  IF l_n=0 THEN
         	  	   CALL cl_err('无此薪资月','!',0)
         	  	   NEXT FIELD hrdv05_1
         	    END IF
         	    	
         	    IF g_hrdv1[l_ac1].hrdv05 != g_hrdv1_t.hrdv05 THEN
         	    	 SELECT hrct07 INTO l_hrct07_b FROM hrct_file 
         	    	  WHERE hrct11=g_hrdv1[l_ac1].hrdv05 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制       
#                    AND hrct03=l_hrat03    
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制         
                 SELECT hrct07 INTO l_hrct07_e FROM hrct_file 
                  WHERE hrct11=g_hrdv1[l_ac1].hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                    AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
                 IF l_hrct07_b>l_hrct07_e THEN        
                    CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                    NEXT FIELD hrdv05_1
                 END IF 
                 
                 IF NOT cl_null(g_hrdv1[l_ac1].hrdv06) THEN
                 	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdv1[l_ac1].hrdv01
         	  	      SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdv1[l_ac1].hrdv05
         	  	      SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdv1[l_ac1].hrdv06	
                 	  SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdv_file
                     WHERE hrdv01=l_hratid
                       AND hrdv00<>g_hrdv1[l_ac1].hrdv00
                       AND A.hrct11=hrdv05
                       AND B.hrct11=hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                       AND A.hrct03=l_hrat03       
#                       AND B.hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制      
                       AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                           OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                           OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))	
                    IF l_n>0 THEN
                       CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                       NEXT FIELD hrdv05_1
                    END IF            
           	     END IF
           	  END IF   		
           END IF
           	
        AFTER FIELD hrdv06_1
           IF NOT cl_null(g_hrdv1[l_ac1].hrdv06) THEN
           	  LET l_n=0
           	  SELECT hrat03 INTO l_hrat03 FROM hrat_file 
           	   WHERE hrat01=g_hrdv1[l_ac1].hrdv01
           	  SELECT COUNT(*) INTO l_n FROM hrct_file
           	   WHERE hrct11=g_hrdv1[l_ac1].hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#           	     AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
           	  IF l_n=0 THEN
         	  	   CALL cl_err('无此薪资月','!',0)
         	  	   NEXT FIELD hrdv06_1
         	    END IF
         	    	
         	    IF g_hrdv1[l_ac1].hrdv06 != g_hrdv1_t.hrdv06 THEN
         	    	 SELECT hrct07 INTO l_hrct07_b FROM hrct_file 
         	    	  WHERE hrct11=g_hrdv1[l_ac1].hrdv05 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制       
#                    AND hrct03=l_hrat03  
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制           
                 SELECT hrct07 INTO l_hrct07_e FROM hrct_file 
                  WHERE hrct11=g_hrdv1[l_ac1].hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                    AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
                 IF l_hrct07_b>l_hrct07_e THEN        
                    CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                    NEXT FIELD hrdv06_1
                 END IF 
                 
                 IF NOT cl_null(g_hrdv1[l_ac1].hrdv05) THEN
                 	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdv1[l_ac1].hrdv01
         	  	      SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=g_hrdv1[l_ac1].hrdv05
         	  	      SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=g_hrdv1[l_ac1].hrdv06	
                 	  SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdv_file
                     WHERE hrdv01=l_hratid
                       AND hrdv00<>g_hrdv1[l_ac1].hrdv00
                       AND A.hrct11=hrdv05
                       AND B.hrct11=hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                       AND A.hrct03=l_hrat03       
#                       AND B.hrct03=l_hrat03  
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制     
                       AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                           OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                           OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))	
                    IF l_n>0 THEN
                       CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                       NEXT FIELD hrdv06_1
                    END IF            
           	     END IF
           	  END IF   		
           END IF
           	
        AFTER FIELD hrdv04_1
           IF NOT cl_null(g_hrdv1[l_ac1].hrdv04) THEN
           	  LET l_n=0
           	  SELECT hrat03 INTO l_hrat03 FROM hrat_file 
           	   WHERE hrat01=g_hrdv1[l_ac1].hrdv01
           	  SELECT COUNT(*) INTO l_n FROM hrct_file
           	   WHERE hrct11=g_hrdv1[l_ac1].hrdv04
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#           	     AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
           	  IF l_n=0 THEN
         	  	   CALL cl_err('无此薪资月','!',0)
         	  	   NEXT FIELD hrdv04_1
         	    END IF                                		
           END IF   	
           	
        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           	
           DELETE FROM hrdv_file WHERE hrdv00 = g_hrdv1_t.hrdv00
                                   
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdv_file",g_hrdv1[l_ac1].hrdv00,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b1=g_rec_b1-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN  
                             #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdv1[l_ac1].* = g_hrdv1_t.*
              CLOSE i090_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrdv1[l_ac1].hrdv01,-263,0)
               LET g_hrdv1[l_ac1].* = g_hrdv1_t.*
           ELSE
               UPDATE hrdv_file SET hrdv03=g_hrdv1[l_ac1].hrdv03,
                                    hrdv05=g_hrdv1[l_ac1].hrdv05,
                                    hrdv06=g_hrdv1[l_ac1].hrdv06,
                                    hrdv04=g_hrdv1[l_ac1].hrdv04,
                                    hrdv09=g_hrdv1[l_ac1].hrdv09,
                                    hrdv10=g_hrdv1[l_ac1].hrdv10,
                                    hrdv11=g_hrdv1[l_ac1].hrdv11,
                                    hrdv12=g_hrdv1[l_ac1].hrdv12,
                                    hrdv13=g_hrdv1[l_ac1].hrdv13
                               WHERE hrdv00 = g_hrdv1_t.hrdv00
                                 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrdv_file",g_hrdv1_t.hrdv00,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdv1[l_ac1].* = g_hrdv1_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac1 = ARR_CURR()
           IF INT_FLAG THEN

              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdv1[l_ac1].* = g_hrdv1_t.*
              CLOSE i090_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i090_cl
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
    
    CLOSE i090_cl

    COMMIT WORK
END FUNCTION
	
FUNCTION i090_xinzeng()
    
   OPEN WINDOW i090_w1 WITH FORM "ghr/42f/ghri0901"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #CALL cl_set_combo_items("hrdv02",NULL,NULL)
   CALL cl_set_combo_items("hrdv03",NULL,NULL)
   CALL cl_set_combo_items("hrdv07",NULL,NULL)
   CALL cl_set_combo_items("hrdv08",NULL,NULL)

#   #社会统筹体系
#   CALL i090_get_hrdv02() RETURNING l_name,l_items
#   CALL cl_set_combo_items("hrdv02",l_name,l_items)
   #补缴标志
   CALL i090_get_items('642') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdv03",l_name,l_items)
   #参数分类
   CALL i090_get_hrdv07() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdv07",l_name,l_items)
   #统筹类型
   CALL i090_get_items('612') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdv08",l_name,l_items)
   
   CALL i090_menu_a()
   CLOSE WINDOW i090_w1
END FUNCTION
	
FUNCTION i090_a()
DEFINE l_hrdv    RECORD LIKE hrdv_file.*
DEFINE li_hrdv   RECORD LIKE hrdv_file.*
DEFINE l_tyjnjs  LIKE hrdv_file.hrdv09
DEFINE l_hrat02  LIKE hrat_file.hrat02
DEFINE l_hrat17  LIKE hrag_file.hrag07
DEFINE l_hrat04  LIKE hrao_file.hrao02
DEFINE l_hrat05  LIKE hras_file.hras04
DEFINE l_hrat22  LIKE hrag_file.hrag07
DEFINE l_hrat42  LIKE hrai_file.hrai04
DEFINE l_hrat06  LIKE hrat_file.hrat02
DEFINE l_hrat25  LIKE hrat_file.hrat25
DEFINE l_sql     STRING 
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_n       LIKE type_file.num5
DEFINE l_hratid  LIKE hrat_file.hratid
DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
DEFINE l_hrct08_b,l_hrct08_e    LIKE hrct_file.hrct08 
DEFINE l_hrat03                 LIKE hrat_file.hrat03 
#DEFINE l_start,l_end            LIKE hrdv_file.hrdv00
DEFINE l_wc    STRING
DEFINE l_hrdt02  LIKE hrdt_file.hrdt02

    CLEAR FORM 
    INITIALIZE l_hrdv.* TO NULL
    
    INPUT l_hrdv.hrdv01,l_hrdv.hrdv02,l_hrdv.hrdv04,
          l_hrdv.hrdv05,l_hrdv.hrdv06,l_tyjnjs,l_hrdv.hrdv03,l_hrdv.hrdv13
        WITHOUT DEFAULTS FROM hrdv01,hrdv02,hrdv04,
                              hrdv05,hrdv06,tyjnjs,hrdv03,hrdv13
         BEFORE INPUT
            LET l_hrdv.hrdvuser = g_user
            LET l_hrdv.hrdvoriu = g_user
            LET l_hrdv.hrdvorig = g_grup
            LET l_hrdv.hrdvgrup = g_grup               #
            LET l_hrdv.hrdvdate = g_today
            LET l_hrdv.hrdvacti = 'Y'                      
                              
         ON ACTION controlp
            CASE 
            	 WHEN INFIELD (hrdv01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv01
               DISPLAY l_hrdv.hrdv01 TO hrdv01
               NEXT FIELD hrdv01
               WHEN INFIELD (hrdv02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrdt01"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv02
               DISPLAY l_hrdv.hrdv02 TO hrdv02
               NEXT FIELD hrdv02              
               WHEN INFIELD (hrdv04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv04
               DISPLAY l_hrdv.hrdv04 TO hrdv04
               NEXT FIELD hrdv04
               
               WHEN INFIELD (hrdv05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv05
               DISPLAY l_hrdv.hrdv05 TO hrdv05
               NEXT FIELD hrdv05
               
               WHEN INFIELD (hrdv06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv06
               DISPLAY l_hrdv.hrdv06 TO hrdv06
               NEXT FIELD hrdv06
            END CASE

         AFTER FIELD hrdv01
            IF NOT cl_null(l_hrdv.hrdv01) THEN
            	 LET l_n=0 
            	 SELECT COUNT(*) INTO l_n FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
         	                                               AND hratconf='Y'
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此员工','!',0)
         	  	    NEXT FIELD hrdv01
         	     END IF
         	     
         	     IF NOT cl_null(l_hrdv.hrdv05) AND
         	     	NOT cl_null(l_hrdv.hrdv06) THEN	
         	        SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
                        SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01    
         	  	SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                                 AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制      
         	        SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                                 AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制  
            	     SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdv_file
                      WHERE hrdv01=l_hratid
                        AND A.hrct11=hrdv05
                        AND B.hrct11=hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                        AND A.hrct03=l_hrat03       
#                        AND B.hrct03=l_hrat03  
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制    
                        AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                            OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                            OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
            	    IF l_n>0 THEN
                       CALL cl_err('该员工设置的薪资月有交叉','!',0)
                       NEXT FIELD hrdv01
                    END IF 
               END IF
               SELECT hrat02 INTO l_hrat02 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01	
               SELECT hrag07 INTO l_hrat17 FROM hrat_file,hrag_file
                WHERE hrat01=l_hrdv.hrdv01 AND hrat17=hrag06
                  AND hrag01='333'
               SELECT hrao02 INTO l_hrat04 FROM hrat_file,hrao_file
                WHERE hrat01=l_hrdv.hrdv01 AND hrat04=hrao01
               SELECT hras04 INTO l_hrat05 FROM hrat_file,hras_file
                WHERE hrat01=l_hrdv.hrdv01 AND hras01=hrat05
               SELECT hrag07 INTO l_hrat22 FROM hrat_file,hrag_file
                WHERE hrat01=l_hrdv.hrdv01 AND hrat22=hrag06
                  AND hrag01='317'
               SELECT hrai04 INTO l_hrat42 FROM hrat_file,hrai_file
                WHERE hrat01=l_hrdv.hrdv01 AND hrat42=hrai03
               SELECT B.hrat02 INTO l_hrat06 FROM hrat_file A,hrat_file B
                WHERE A.hrat01=l_hrdv.hrdv01 AND A.hrat06=B.hrat01
               SELECT hrat25 INTO l_hrat25 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
               
               DISPLAY l_hrat02 TO hrat02
               DISPLAY l_hrat17 TO hrat17
               DISPLAY l_hrat04 TO hrat04
               DISPLAY l_hrat05 TO hrat05
               DISPLAY l_hrat22 TO hrat22
               DISPLAY l_hrat42 TO hrat42
               DISPLAY l_hrat06 TO hrat06
               DISPLAY l_hrat25 TO hrat25          
            END IF 
            	
         AFTER FIELD hrdv04
            IF NOT cl_null(l_hrdv.hrdv04) THEN
            	 LET l_n=0
            	 SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
            	 SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv04
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                           AND hrct03=l_hrat03  
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制   
         	 IF l_n=0 THEN
         	    CALL cl_err('无此薪资月','!',0)
         	    NEXT FIELD hrdv04
         	 END IF
                 
                 IF NOT cl_null(l_hrdv.hrdv01) THEN                
                    SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
                    LET l_n=0
                    SELECT COUNT(*) INTO l_n FROM hrdv_file WHERE hrdv01=l_hratid
                                                              AND hrdv04=l_hrdv.hrdv04
                    IF l_n>0 THEN
                       CALL cl_err('此员工已维护该薪资月的福利补缴','!',0)
                       NEXT FIELD hrdv04
                    END IF
                 END IF     	  
            END IF
         AFTER FIELD hrdv02
         IF NOT cl_null(l_hrdv.hrdv02) THEN 
          
            SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file 
             WHERE hrdt01 = l_hrdv.hrdv02
            IF cl_null(l_hrdt02) THEN 
               CALL cl_err('统筹体系不存在，请检查','!',1)
               NEXT FIELD hrdv02 
            END IF 
            DISPLAY l_hrdt02 TO hrdv02_n 
         END IF         	  	
         AFTER FIELD hrdv05
            IF NOT cl_null(l_hrdv.hrdv05) THEN
            	 LET l_n=0
            	 SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
            	 SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                         AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制              
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdv05
         	     END IF
         	     
         	     IF NOT cl_null(l_hrdv.hrdv06) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制       
#                                                                 AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制           
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                                 AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制           
                  IF l_hrct07_b>l_hrct07_e THEN        
                     CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                     NEXT FIELD hrdv05
                  END IF
                  
                  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
         	  	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
         	  	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
         	  	    LET l_n=0
         	  	    SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdv_file
                   WHERE hrdv01=l_hratid
                     AND A.hrct11=hrdv05
                     AND B.hrct11=hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                     AND A.hrct03=l_hrat03       
#                     AND B.hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制     
                     AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                         OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                         OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))	
                  IF l_n>0 THEN
                     CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                     NEXT FIELD hrdv05
                  END IF       
               END IF
               	
         	  END IF
         
         AFTER FIELD hrdv06
            IF NOT cl_null(l_hrdv.hrdv06) THEN
            	 LET l_n=0
            	 SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
            	 SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                         AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制              
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdv06
         	     END IF
         	     
         	     IF NOT cl_null(l_hrdv.hrdv05) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制       
#                                                                 AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制           
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                                 AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制           
                  IF l_hrct07_b>l_hrct07_e THEN        
                     CALL cl_err('开始薪资月不可比结束薪资月大','!',0)
                     NEXT FIELD hrdv06
                  END IF
                  
                  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
         	  	    SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
         	  	    SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
         	  	    LET l_n=0
         	  	    SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdv_file
                   WHERE hrdv01=l_hratid
                     AND A.hrct11=hrdv05
                     AND B.hrct11=hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                     AND A.hrct03=l_hrat03       
#                     AND B.hrct03=l_hrat03  
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制    
                     AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                         OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                         OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))	
                  IF l_n>0 THEN
                     CALL cl_err('该员工的此周期薪资日期有交叉','!',0)
                     NEXT FIELD hrdv06
                  END IF       
               END IF
               	
         	  END IF	  	
            	  	   	   	  	
         ON ACTION CONTROLZ
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

        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT

         ON ACTION HELP        
            CALL cl_show_help()  
     END INPUT 
     
     IF INT_FLAG THEN
     	  LET INT_FLAG=0 
        RETURN 
     END IF 

     BEGIN WORK 
        LET l_start=''
        LET l_end=''
        LET l_sql=" SELECT hrdta02,hrdta03,hrdta04,hrdta08,hrdta04,hrdta09",
                  "   FROM hrdta_file",
                  "  WHERE hrdta01='",l_hrdv.hrdv02,"'"
        PREPARE ins_p FROM l_sql
        DECLARE ins_c CURSOR FOR ins_p
        FOREACH ins_c INTO l_hrdv.hrdv07,l_hrdv.hrdv08,l_hrdv.hrdv09,
                           l_hrdv.hrdv10,l_hrdv.hrdv11,l_hrdv.hrdv12
          IF NOT cl_null(l_tyjnjs) THEN
          	 LET l_hrdv.hrdv09=l_tyjnjs
          	 LET l_hrdv.hrdv11=l_tyjnjs
          END IF
          	
          SELECT MAX(hrdv00) INTO l_hrdv.hrdv00 FROM hrdv_file
        
          IF cl_null(l_hrdv.hrdv00) THEN
        	   LET l_hrdv.hrdv00='0000000001'
          ELSE
        	   LET l_hrdv.hrdv00=l_hrdv.hrdv00+1 USING "&&&&&&&&&&"	 	
          END IF	
          		                  
          LET li_hrdv.*=l_hrdv.*
          SELECT hratid INTO li_hrdv.hrdv01 FROM hrat_file WHERE hrat01=l_hrdv.hrdv01
          	
          INSERT INTO hrdv_file VALUES (li_hrdv.*)
          IF sqlca.sqlcode THEN 
             CALL cl_err3("ins","hrdv_file",l_hrdv.hrdv00,"",SQLCA.sqlcode,"","",0)
             ROLLBACK WORK
             EXIT FOREACH 
          END IF
          
          IF cl_null(l_start) THEN
          	 LET l_start=li_hrdv.hrdv00
          END IF
          
          LET l_end=li_hrdv.hrdv00		 	 
        END FOREACH 
     COMMIT WORK
     LET l_wc=" hrdv00 BETWEEN '",l_start,"' AND '",l_end,"'" 
     CALL i090_b_fill_a(l_wc)
     CALL i090_b_a()
END FUNCTION
	
FUNCTION i090_b_fill_a(p_wc)
DEFINE l_sql    STRING
DEFINE p_wc     STRING

    LET g_cnt=1
    CALL g_hrdv.clear()
    LET l_sql=" SELECT hrdv00,hrdv07,hrdv08,hrdv09,hrdv10,hrdv11,hrdv12",
              "   FROM hrdv_file",
              "  WHERE ",p_wc CLIPPED
              
    PREPARE hrdv_fill_p FROM l_sql
    DECLARE hrdv_fill_c CURSOR FOR hrdv_fill_p
    FOREACH hrdv_fill_c INTO g_hrdv[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
   END FOREACH
   
   CALL g_hrdv.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
   
   #CALL i090_b_a(p_hrdu01,p_hrdu03)
END FUNCTION
	
FUNCTION i090_b_a()
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE l_hrdv00        LIKE hrdv_file.hrdv00
#add by zhuzw 20150122 start
DEFINE l_g             LIKE type_file.chr1 
DEFINE l_i             LIKE type_file.num5
    LET l_g = 'N'
    LET l_i = 1
#add by zhuzw 20150122 end  

    LET g_forupd_sql = "SELECT hrdv00,hrdv07,hrdv08,hrdv09,hrdv10,hrdv11,hrdv12",
                       "  FROM hrdv_file",
                       " WHERE  hrdv00 = ?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i090_cl_a CURSOR FROM g_forupd_sql
    
    INPUT ARRAY g_hrdv WITHOUT DEFAULTS FROM s_hrdv.*
      ATTRIBUTE (COUNT=g_rec_b3,MAXCOUNT=g_rec_b3,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)

        BEFORE INPUT
            IF g_rec_b3 !=0 THEN 
               LET l_ac3=1
            END IF
            
        BEFORE ROW
            LET l_lock_sw = 'N' 
            LET l_ac3 = ARR_CURR()                
            IF g_rec_b3 >= l_ac3 THEN    
               BEGIN WORK
               LET g_hrdv_t.* = g_hrdv[l_ac3].*  #BACKUP
               OPEN i090_cl_a USING g_hrdv_t.hrdv00
               IF STATUS THEN
                  CALL cl_err("OPEN i090_cl_a:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i090_cl_a INTO g_hrdv[l_ac3].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_hrdv00,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF 
               CALL cl_show_fld_cont()
            END IF
            
        ON ROW CHANGE
           IF INT_FLAG THEN     
              LET l_g = 'Y'  #add by zhuzw 20150122           #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdv[l_ac3].* = g_hrdv_t.*
              CLOSE i090_cl_a
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(l_hrdv00,-263,0)
               LET g_hrdv[l_ac3].* = g_hrdv_t.*
           ELSE
               UPDATE hrdv_file SET hrdv09=g_hrdv[l_ac3].hrdv09,
                                    hrdv10=g_hrdv[l_ac3].hrdv10,
                                    hrdv11=g_hrdv[l_ac3].hrdv11,
                                    hrdv12=g_hrdv[l_ac3].hrdv12
                               WHERE hrdv00 = g_hrdv_t.hrdv00
                                 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrdv_file",l_hrdv00,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdv[l_ac3].* = g_hrdv_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac3 = ARR_CURR()
           IF INT_FLAG THEN
              LET l_g = 'Y' #add by zhuzw 20150122
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdv[l_ac3].* = g_hrdv_t.*
              CLOSE i090_cl_a
              ROLLBACK WORK
              DELETE FROM hrdv_file WHERE hrdv00 BETWEEN l_start AND l_end
              #EXIT INPUT
           END IF
           CLOSE i090_cl_a
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

         ON ACTION exit
            EXIT INPUT

         ON ACTION close
            EXIT INPUT

        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121

    END INPUT
    
    CLOSE i090_cl_a
    #add by zhuzw 20150122 start
    IF l_g = 'Y' THEN 
       FOR l_i= 1 TO g_rec_b3
           DELETE FROM hrdv_file WHERE hrdv00 = g_hrdv[l_i].hrdv00      
       END FOR 
    END IF 
    #add by zhuzw 20150122 end 
    COMMIT WORK
END FUNCTION 		

FUNCTION i090_menu_a()

   MENU ""
         ON ACTION INSERT 
            CALL i090_a()
         ON ACTION piliang
            CALL i090_aa()
         ON ACTION help
            CALL cl_show_help() 
         ON ACTION exit
            EXIT MENU 
         ON ACTION close
            EXIT MENU   
         ON ACTION controlg
            CALL cl_cmdask()
   END MENU 
END FUNCTION
				
FUNCTION i090_aa()
DEFINE l_hrdv    RECORD LIKE hrdv_file.*
DEFINE l_tyjnjs  LIKE type_file.num20_6
DEFINE l_sql     STRING 
DEFINE l_cnt     LIKE type_file.num5
DEFINE tok       base.StringTokenizer
DEFINE l_str     STRING
DEFINE l_value   LIKE   hrat_file.hrat01
DEFINE l_hrct07_b,l_hrct07_e    LIKE hrct_file.hrct07
DEFINE l_hrct08_e,l_hrct08_b    LIKE hrct_file.hrct08
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err    DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
                   END RECORD 
DEFINE l_n,l_n1,l_n2   LIKE  type_file.num5 
DEFINE l_hrat03    LIKE  hrat_file.hrat03                  
DEFINE l_hrdt02  LIKE hrdt_file.hrdt02

     CLEAR FORM 
     INITIALIZE l_hrdv.* TO NULL
         
     WHILE TRUE
     INPUT l_hrdv.hrdv02,l_hrdv.hrdv04,
           l_hrdv.hrdv05,l_hrdv.hrdv06,l_tyjnjs,l_hrdv.hrdv03,l_hrdv.hrdv13 
     WITHOUT DEFAULTS 
     FROM hrdv02,hrdv04,hrdv05,hrdv06,tyjnjs,hrdv03,hrdv13 

         BEFORE INPUT
            LET l_hrdv.hrdvuser = g_user
            LET l_hrdv.hrdvoriu = g_user
            LET l_hrdv.hrdvorig = g_grup
            LET l_hrdv.hrdvgrup = g_grup               #
            LET l_hrdv.hrdvdate = g_today
            LET l_hrdv.hrdvacti = 'Y'
            
         AFTER FIELD hrdv04
            IF NOT cl_null(l_hrdv.hrdv04) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv04
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdv04
         	     END IF
                
            END IF
         AFTER FIELD hrdv02
         IF NOT cl_null(l_hrdv.hrdv02) THEN 
          
            SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file 
             WHERE hrdt01 = l_hrdv.hrdv02
            IF cl_null(l_hrdt02) THEN 
               CALL cl_err('统筹体系不存在，请检查','!',1)
               NEXT FIELD hrdv02 
            END IF 
            DISPLAY l_hrdt02 TO hrdv02_n 
         END IF           
         AFTER FIELD hrdv05
            IF NOT cl_null(l_hrdv.hrdv05) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdv05
         	     END IF
         	  	
         	     IF NOT cl_null(l_hrdv.hrdv06) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
                  IF l_hrct07_b>l_hrct07_e THEN
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdv05
                  END IF
               END IF	
                
            END IF   	   
            	
         AFTER FIELD hrdv06
            IF NOT cl_null(l_hrdv.hrdv06) THEN
               LET l_n=0
               SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
         	     IF l_n=0 THEN
         	  	    CALL cl_err('无此薪资月','!',0)
         	  	    NEXT FIELD hrdv06
         	     END IF
         	  	
         	     IF NOT cl_null(l_hrdv.hrdv05) THEN
                  SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
                  SELECT hrct07 INTO l_hrct07_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
                  IF l_hrct07_b>l_hrct07_e THEN
                     CALL cl_err('开始期间不可比结束期间大','!',0)
                     NEXT FIELD hrdv06
                  END IF
               END IF	
                
            END IF
            	
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF   	   	
            
         ON ACTION controlp
            CASE 
            	 WHEN INFIELD(hrdv04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv04
               DISPLAY l_hrdv.hrdv04 TO hrdv04
               NEXT FIELD hrdv04
               WHEN INFIELD (hrdv02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrdt01"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv02
               DISPLAY l_hrdv.hrdv02 TO hrdv02
               NEXT FIELD hrdv02                
               WHEN INFIELD(hrdv05)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv05
               DISPLAY l_hrdv.hrdv05 TO hrdv05
               NEXT FIELD hrdv05
               
               WHEN INFIELD(hrdv06)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING l_hrdv.hrdv06
               DISPLAY l_hrdv.hrdv06 TO hrdv06
               NEXT FIELD hrdv06
            END CASE
            
         ON ACTION CONTROLZ
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

         ON ACTION HELP        
            CALL cl_show_help() 
         
         ON ACTION exit      
            LET INT_FLAG = 1
            EXIT INPUT   
     END INPUT
      
     IF INT_FLAG THEN 
     	  LET INT_FLAG=0
        RETURN 
     END IF 

     LET l_str=''
     CALL cl_init_qry_var()
     LET g_qryparam.form  = "q_hrat01"
     LET g_qryparam.state = "c"
     CALL cl_create_qry() RETURNING l_str
     
     IF cl_null(l_str) THEN
        LET INT_FLAG=0
        CONTINUE WHILE
     ELSE
        EXIT WHILE
     END IF      
       
     END WHILE
     	
     LET g_success='Y'
     LET li_k=1	

     BEGIN WORK
     LET tok = base.StringTokenizer.create(l_str,"|")
       IF NOT cl_null(l_str) THEN
          WHILE tok.hasMoreTokens()
             LET l_value=tok.nextToken()
             SELECT hratid INTO l_hrdv.hrdv01 FROM hrat_file WHERE hrat01=l_value
             SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hrat01=l_value 

             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrdv_file WHERE hrdv01=l_hrdv.hrdv01
                                                       AND hrdv04=l_hrdv.hrdv04
             IF l_n>0 THEN
                LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err="该员工该此薪资月已维护"
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF
                                                           
             LET l_n=0      
             LET l_n1=0
             LET l_n2=0
             SELECT COUNT(*) INTO l_n FROM hrct_file WHERE hrct11=l_hrdv.hrdv04
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                       AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
             SELECT COUNT(*) INTO l_n1 FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                        AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
             SELECT COUNT(*) INTO l_n2 FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                        AND hrct03=l_hrat03
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
             IF l_n=0 OR l_n1=0 OR l_n2=0 THEN
                LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err="薪资月不属于该员工所属公司"
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF
             	
             SELECT hrct07 INTO l_hrct07_b FROM hrct_file WHERE hrct11=l_hrdv.hrdv05
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                            AND hrct03=l_hrat03  
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制      
             SELECT hrct08 INTO l_hrct08_e FROM hrct_file WHERE hrct11=l_hrdv.hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                                                            AND hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制       
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrct_file A,hrct_file B,hrdv_file
              WHERE hrdv01=l_hrdv.hrdv01
                AND A.hrct11=hrdv05
                AND B.hrct11=hrdv06
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制
#                AND A.hrct03=l_hrat03        
#                AND B.hrct03=l_hrat03 
#add by yinbq 20141122 for 暂时取消薪资月必须是员工所在公司的限制       
                AND ((l_hrct07_b>=A.hrct07 AND l_hrct08_e<=B.hrct08)
                      OR (A.hrct07 BETWEEN l_hrct07_b AND l_hrct08_e)
                      OR (B.hrct08 BETWEEN l_hrct07_b AND l_hrct08_e))
             IF l_n>0 THEN
                LET g_success='N'
                LET lr_err[li_k].line=li_k
                LET lr_err[li_k].key1=l_value
                LET lr_err[li_k].err="此员工薪资月有交叉"
                LET li_k=li_k+1
                CONTINUE WHILE
             END IF
             	
             LET l_sql=" SELECT hrdta02,hrdta03,hrdta04,hrdta08,hrdta04,hrdta09",
                       "   FROM hrdta_file",
                       "  WHERE hrdta01='",l_hrdv.hrdv02,"'"
             PREPARE ins_pp FROM l_sql
             DECLARE ins_cc CURSOR FOR ins_pp
             FOREACH ins_cc INTO l_hrdv.hrdv07,l_hrdv.hrdv08,l_hrdv.hrdv09,
                                 l_hrdv.hrdv10,l_hrdv.hrdv11,l_hrdv.hrdv12
               
               IF NOT cl_null(l_tyjnjs) THEN
               	  LET l_hrdv.hrdv09=l_tyjnjs
               	  LET l_hrdv.hrdv11=l_tyjnjs
               END IF
               		                    
               SELECT MAX(hrdv00) INTO l_hrdv.hrdv00 FROM hrdv_file
        
               IF cl_null(l_hrdv.hrdv00) THEN
        	        LET l_hrdv.hrdv00='0000000001'
               ELSE
        	        LET l_hrdv.hrdv00=l_hrdv.hrdv00+1 USING "&&&&&&&&&&"	 	
               END IF
               	
               INSERT INTO hrdv_file VALUES (l_hrdv.*)
               IF SQLCA.sqlcode THEN  
                  LET g_success='N'
                  LET lr_err[li_k].line=li_k
                  LET lr_err[li_k].key1=l_value
                  LET lr_err[li_k].err=SQLCA.sqlcode
                  LET li_k=li_k+1
                  CONTINUE WHILE
               END IF
             END FOREACH
	           
          END WHILE
       END IF	
       	
       IF lr_err.getLength() > 0 AND g_success='N' THEN
          ROLLBACK WORK
          CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|工号|错误描述")
       ELSE
          COMMIT WORK
          CALL cl_err('生成成功','!',1)
       END IF  
END FUNCTION
		
		
	
	
		

						
                                         

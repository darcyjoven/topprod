# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri092
# Descriptions...: 员工薪酬计算
# Date & Author..: 13/07/25 zhangbo

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql         STRING,
       g_wc1         STRING,                                           
       g_wc2         STRING,
       g_wc3         STRING,
       g_wc4         STRING
DEFINE g_hrdx1      DYNAMIC ARRAY OF RECORD
         hrdx04      LIKE   hrdx_file.hrdx04,
         hrdx02      LIKE   hrdx_file.hrdx02,
         hraa12      LIKE   hraa_file.hraa12,
         hrdx03      LIKE   hrdx_file.hrdx03,
         hrdx01      LIKE   hrdx_file.hrdx01,
         hrct07      LIKE   hrct_file.hrct07,
         hrct08      LIKE   hrct_file.hrct08,
         hrdx05      LIKE   hrdx_file.hrdx05,
         hrdx15      LIKE   hrdx_file.hrdx15,
         hrdx06      LIKE   hrdx_file.hrdx06,
         hrdx07      LIKE   hrdx_file.hrdx07
                     END RECORD,
       g_rec_b1      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5
DEFINE g_hrdx1_t     RECORD
         hrdx04      LIKE   hrdx_file.hrdx04,
         hrdx02      LIKE   hrdx_file.hrdx02,
         hraa12      LIKE   hraa_file.hraa12,
         hrdx03      LIKE   hrdx_file.hrdx03,
         hrdx01      LIKE   hrdx_file.hrdx01,
         hrct07      LIKE   hrct_file.hrct07,
         hrct08      LIKE   hrct_file.hrct08,
         hrdx05      LIKE   hrdx_file.hrdx05,
         hrdx15      LIKE   hrdx_file.hrdx15,
         hrdx06      LIKE   hrdx_file.hrdx06,
         hrdx07      LIKE   hrdx_file.hrdx07
                     END RECORD
DEFINE g_hrdx2      DYNAMIC ARRAY OF RECORD
         hrdx04      LIKE   hrdx_file.hrdx04,
         hrdx02      LIKE   hrdx_file.hrdx02,
         hraa12      LIKE   hraa_file.hraa12,
         hrdx03      LIKE   hrdx_file.hrdx03,
         hrdx01      LIKE   hrdx_file.hrdx01,
         hrct07      LIKE   hrct_file.hrct07,
         hrct08      LIKE   hrct_file.hrct08,
         hrdx05      LIKE   hrdx_file.hrdx05,
         hrdx15      LIKE   hrdx_file.hrdx15,
         hrdx06      LIKE   hrdx_file.hrdx06,
         hrdx07      LIKE   hrdx_file.hrdx07,
         hrdx08      LIKE   hrdx_file.hrdx08,
         hrdx09      LIKE   hrdx_file.hrdx09
                     END RECORD,
       g_rec_b2      LIKE type_file.num5,
       l_ac2         LIKE type_file.num5                                   
DEFINE g_hrdx3      DYNAMIC ARRAY OF RECORD
         hrdx04      LIKE   hrdx_file.hrdx04,
         hrdx02      LIKE   hrdx_file.hrdx02,
         hraa12      LIKE   hraa_file.hraa12,
         hrdx03      LIKE   hrdx_file.hrdx03,
         hrdx01      LIKE   hrdx_file.hrdx01,
         hrct07      LIKE   hrct_file.hrct07,
         hrct08      LIKE   hrct_file.hrct08,
         hrdx05      LIKE   hrdx_file.hrdx05,
         hrdx15      LIKE   hrdx_file.hrdx15,
         hrdx06      LIKE   hrdx_file.hrdx06,
         hrdx07      LIKE   hrdx_file.hrdx07,
         hrdx08      LIKE   hrdx_file.hrdx08,
         hrdx09      LIKE   hrdx_file.hrdx09,
         hrdx10      LIKE   hrdx_file.hrdx10,
         hrdx11      LIKE   hrdx_file.hrdx11
                     END RECORD,
       g_rec_b3      LIKE type_file.num5,
       l_ac3         LIKE type_file.num5
DEFINE g_hrdx4      DYNAMIC ARRAY OF RECORD
         hrdx04      LIKE   hrdx_file.hrdx04,
         hrdx02      LIKE   hrdx_file.hrdx02,
         hraa12      LIKE   hraa_file.hraa12,
         hrdx03      LIKE   hrdx_file.hrdx03,
         hrdx01      LIKE   hrdx_file.hrdx01,
         hrct07      LIKE   hrct_file.hrct07,
         hrct08      LIKE   hrct_file.hrct08,
         hrdx05      LIKE   hrdx_file.hrdx05,
         hrdx15      LIKE   hrdx_file.hrdx15,
         hrdx06      LIKE   hrdx_file.hrdx06,
         hrdx07      LIKE   hrdx_file.hrdx07,
         hrdx08      LIKE   hrdx_file.hrdx08,
         hrdx09      LIKE   hrdx_file.hrdx09,
         hrdx10      LIKE   hrdx_file.hrdx10,
         hrdx11      LIKE   hrdx_file.hrdx11,
         hrdx12      LIKE   hrdx_file.hrdx12,
         hrdx13      LIKE   hrdx_file.hrdx13
                     END RECORD,
       g_rec_b4      LIKE type_file.num5,
       l_ac4         LIKE type_file.num5
DEFINE g_hrdxa      DYNAMIC ARRAY OF RECORD
         hrdxa02     LIKE   hrdxa_file.hrdxa02,
         hrdxa03     LIKE   hrdxa_file.hrdxa03,
         hrdxa04     LIKE   hrdxa_file.hrdxa04,
         hrdxa05     LIKE   hrdxa_file.hrdxa05,
         hrdxa06     LIKE   hrdxa_file.hrdxa06,
         hrdxa07     LIKE   hrdxa_file.hrdxa07,
         hrdxa08     LIKE   hrdxa_file.hrdxa08,
         hrdxa09     LIKE   hrdxa_file.hrdxa09,
         hrdxa10     LIKE   hrdxa_file.hrdxa10,
         hrdxa11     LIKE   hrdxa_file.hrdxa11,
         hrdxa12     LIKE   hrdxa_file.hrdxa12,
         hrdxa13     LIKE   hrdxa_file.hrdxa13,
         hrdxa14     LIKE   hrdxa_file.hrdxa14,
         hrdxa15     LIKE   hrdxa_file.hrdxa15,
         hrdxa16     LIKE   hrdxa_file.hrdxa16,
         hrdxa17     LIKE   hrdxa_file.hrdxa17,
         hrdxa18     LIKE   hrdxa_file.hrdxa18,
         hrdxa19     LIKE   hrdxa_file.hrdxa19,
         hrdxa20     LIKE   hrdxa_file.hrdxa20,
         hrdxa21     LIKE   hrdxa_file.hrdxa21,
         hrdxa23     LIKE   hrdxa_file.hrdxa23,        #add by zhangbo130911
         hrdxa24     LIKE   hrdxa_file.hrdxa24,        #add by zhangbo130911
         hrdxa25     LIKE   hrdxa_file.hrdxa25,        #add by zhangbo130911
         hrdxa26     LIKE   hrdxa_file.hrdxa26,        #add by zhangbo130911
         hrdxa27     LIKE   hrdxa_file.hrdxa27         #add by zhangbo130911
                    END RECORD,
       g_rec_b5      LIKE type_file.num5,
       l_ac5         LIKE type_file.num5              
DEFINE g_flag               LIKE type_file.chr10
DEFINE g_forupd_sql         STRING                       
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_row_count          LIKE type_file.num5       
DEFINE g_curs_index         LIKE type_file.num5      
DEFINE g_cnt                LIKE type_file.num10         
DEFINE l_items              STRING
DEFINE l_name               STRING
DEFINE g_hrdl01             LIKE hrdl_file.hrdl01
DEFINE g_emp        DYNAMIC ARRAY OF RECORD
         chk         LIKE   type_file.chr1,
         hrat03      LIKE   hraa_file.hraa12,
         hrat01      LIKE   hrat_file.hrat01,
         hrat02      LIKE   hrat_file.hrat02,
         hrat04      LIKE   hrao_file.hrao02,
         hrat05      LIKE   hras_file.hras04,
         hrat25      LIKE   hrat_file.hrat25,
         hrdm03      LIKE   hrdm_file.hrdm03
                    END RECORD,
       g_rec_b6      LIKE type_file.num5               
DEFINE g_hrdx       RECORD LIKE  hrdx_file.*                    
DEFINE g_count      LIKE   type_file.num5       #add by zhangbo130910
                       

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
   	
   LET g_forupd_sql = "SELECT * FROM hrdx_file WHERE hrdx01 = ? AND hrdx04 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)        
   DECLARE i092_cl CURSOR FROM g_forupd_sql	
 
   OPEN WINDOW i092_w WITH FORM "ghr/42f/ghri092"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
          
   CALL cl_ui_init()
   
   CALL cl_set_combo_items("hrdx03_1",NULL,NULL)
   CALL cl_set_combo_items("hrdx15_1",NULL,NULL)
   CALL cl_set_combo_items("hrdx15_2",NULL,NULL)
   CALL cl_set_combo_items("hrdx15_3",NULL,NULL)
   CALL cl_set_combo_items("hrdx15_4",NULL,NULL)
   
   #财年
   CALL i092_get_hrdx03() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdx03_1",l_name,l_items)
   
   #计税类型
   CALL i092_get_items('653') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdx15_1",l_name,l_items)
   CALL cl_set_combo_items("hrdx15_2",l_name,l_items)
   CALL cl_set_combo_items("hrdx15_3",l_name,l_items)
   CALL cl_set_combo_items("hrdx15_4",l_name,l_items)
   
   LET g_wc1=" 1=1"
   LET g_wc2=" 1=1"
   LET g_wc3=" 1=1"
   LET g_wc4=" 1=1"
   LET g_wc1 = g_wc1 CLIPPED,get_data_filter('hrdxuser', 'hrdxgrup') #add by zhuzw 20150424 
   LET g_wc2 = g_wc2 CLIPPED,get_data_filter('hrdxuser', 'hrdxgrup') #add by zhuzw 20150424
   LET g_wc3 = g_wc3 CLIPPED,get_data_filter('hrdxuser', 'hrdxgrup') #add by zhuzw 20150424
   LET g_wc4 = g_wc4 CLIPPED,get_data_filter('hrdxuser', 'hrdxgrup') #add by zhuzw 20150424
     
   CALL i092_b_fill()
      
   CALL i092_menu()
   CLOSE WINDOW i092_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i092_get_hrdx03()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrac01 LIKE hrdt_file.hrdt01

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT DISTINCT hrac01 FROM hrac_file ",
                 "  ORDER BY hrac01"
       PREPARE i092_get_hrdx03_pre FROM l_sql
       DECLARE i092_get_hrdx03 CURSOR FOR i092_get_hrdx03_pre
       FOREACH i092_get_hrdx03 INTO l_hrac01
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrac01
            LET p_items=l_hrac01
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrac01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrac01 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION
	
FUNCTION i092_get_hrdl01()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrdl01 LIKE hrdl_file.hrdl01
DEFINE l_hrdl02 LIKE hrdl_file.hrdl02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrdl01,hrdl02 FROM hrdl_file ",
                 "  ORDER BY hrdl01"
       PREPARE i092_get_hrdl01_pre FROM l_sql
       DECLARE i092_get_hrdl01 CURSOR FOR i092_get_hrdl01_pre
       FOREACH i092_get_hrdl01 INTO l_hrdl01,l_hrdl02
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrdl01
            LET p_items=l_hrdl02
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrdl01 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrdl02 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items	
END FUNCTION		
	
FUNCTION i092_get_items(p_hrag01)
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
       PREPARE i092_get_items_pre FROM l_sql
       DECLARE i092_get_items CURSOR FOR i092_get_items_pre
       FOREACH i092_get_items INTO p_hrag06,p_hrag07
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
	
FUNCTION i092_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
   	  CASE g_flag
   	     WHEN 'pg1'	
            CALL i092_bp1("G")    #包含第一页签DISPLAY
         WHEN 'pg2'
            CALL i092_bp2("G")    #包含第二页签DISPLAY
         WHEN 'pg3'
            CALL i092_bp3("G")    #包含第三页签DISPLAY
         WHEN 'pg4'
            CALL i092_bp4("G")    #包含第四页签DISPLAY      
         OTHERWISE
            CALL i092_bp1("G")    #显示第一页签DISPLAY
      END CASE
      	                          
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
            	 #CASE g_flag
            	 	  #WHEN 'pg1'  	CALL i092_q1()
            	 	  #WHEN 'pg2'  	CALL i092_q2()
            	 	  #WHEN 'pg3'    CALL i092_q3()
            	 	  #WHEN 'pg4'    CALL i092_q4()
            	 	  CALL i092_q()
            	 #END CASE	    
            END IF
            	
         WHEN "jisuan"
            IF cl_chk_act_auth() THEN
            	 CALL i092_jisuan()
            END IF
         
         WHEN "tijiao"
            IF cl_chk_act_auth() THEN
            	 CALL i092_tijiao()
            	 CALL i092_b_fill()
            END IF
         
         WHEN "cxkqgz"
            IF cl_chk_act_auth() THEN
            	 CALL i092_cxkqgz()
            END IF
            	
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
            	 CALL i092_confirm()
            	 CALL i092_b_fill()
            END IF
         
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
            	 CALL i092_undo_confirm()
            	 CALL i092_b_fill()
            END IF
         
         WHEN "guidang"
            IF cl_chk_act_auth() THEN
            	 CALL i092_guidang()
            	 CALL i092_b_fill()
            END IF
         
         WHEN "undo_guidang"
            IF cl_chk_act_auth() THEN
            	 CALL i092_undo_guidang()
            	 CALL i092_b_fill()
            END IF   	    	   	   	   	    	
            	
         WHEN "detail"
            IF cl_chk_act_auth() THEN
            	 CALL i092_b()
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
                     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdx1),'','')
                  WHEN 'pg2'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdx2),'','')
              	  WHEN 'pg3'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdx3),'','')
              	  WHEN 'pg4'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdx4),'','')
              	           
               END CASE	                     
            END IF
      END CASE
   END WHILE

END FUNCTION
	
FUNCTION i092_tijiao()	
DEFINE l_n     LIKE  type_file.num5
	
	 IF cl_null(g_hrdx1[l_ac1].hrdx04) OR cl_null(g_hrdx1[l_ac1].hrdx01) THEN
	 	  CALL cl_err('',-400,0)
	 	  RETURN
	 END IF
	 	
	 SELECT * INTO g_hrdx.* FROM hrdx_file WHERE hrdx01=g_hrdx1[l_ac1].hrdx01
	                                         AND hrdx04=g_hrdx1[l_ac1].hrdx04
	 IF g_hrdx.hrdx14 != '001' THEN
	 	  CALL cl_err('计算组不是待计算状态,不可提交','!',0)
	 	  RETURN
	 END IF
	 	
	 LET l_n=0	
	 	
	 SELECT COUNT(*) INTO l_n FROM hrdxa_file WHERE hrdxa01=g_hrdx.hrdx01
	                                            AND hrdxa22=g_hrdx.hrdx04
	 IF l_n=0 THEN
	 	  CALL cl_err('还未进行计算,不可提交','!',0)
	 	  RETURN
	 END IF	 
	 	
	 BEGIN WORK
    
   OPEN i092_cl USING g_hrdx.hrdx01,g_hrdx.hrdx04
   IF STATUS THEN
      CALL cl_err("open i092_cl:",STATUS,1)
      CLOSE i092_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i092_cl INTO g_hrdx.*
   IF SQLCA.sqlcode  THEN
     CALL cl_err(g_hrdx.hrdx04,SQLCA.sqlcode,0)
     CLOSE i092_cl
     ROLLBACK WORK
     RETURN
   END IF

   IF NOT cl_confirm("是否确定提交?") THEN
   ELSE
      UPDATE hrdx_file
         SET hrdx14 = '002',
             hrdx08 = g_user,
             hrdx09 = g_today,
             hrdxmodu = g_user,
             hrdxdate = g_today
       WHERE hrdx01 = g_hrdx.hrdx01
         AND hrdx04 = g_hrdx.hrdx04
      
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrdx:',SQLCA.SQLCODE,0)
       END IF
   END IF
   CLOSE i092_cl
   COMMIT WORK	                                            		                                          	
	 	
END FUNCTION
	
FUNCTION i092_cxkqgz()
	
	
END FUNCTION	

FUNCTION i092_confirm()


	 IF cl_null(g_hrdx2[l_ac2].hrdx04) OR cl_null(g_hrdx2[l_ac2].hrdx01) THEN
	 	  CALL cl_err('',-400,0)
	 	  RETURN
	 END IF
	 	
	 SELECT * INTO g_hrdx.* FROM hrdx_file WHERE hrdx01=g_hrdx2[l_ac2].hrdx01
	                                         AND hrdx04=g_hrdx2[l_ac2].hrdx04
	 IF g_hrdx.hrdx14 != '002' THEN
	 	  CALL cl_err('计算组不是待审核状态,不可审核','!',0)
	 	  RETURN
	 END IF 
	 	
	 BEGIN WORK
    
   OPEN i092_cl USING g_hrdx.hrdx01,g_hrdx.hrdx04
   IF STATUS THEN
      CALL cl_err("open i092_cl:",STATUS,1)
      CLOSE i092_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i092_cl INTO g_hrdx.*
   IF SQLCA.sqlcode  THEN
     CALL cl_err(g_hrdx.hrdx04,SQLCA.sqlcode,0)
     CLOSE i092_cl
     ROLLBACK WORK
     RETURN
   END IF

   IF NOT cl_confirm("是否确定审核?") THEN
   ELSE
      UPDATE hrdx_file
         SET hrdx14 = '003',
             hrdx08 = g_user,
             hrdx09 = g_today,
             hrdxmodu = g_user,
             hrdxdate = g_today
       WHERE hrdx01 = g_hrdx.hrdx01
         AND hrdx04 = g_hrdx.hrdx04
      
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrdx:',SQLCA.SQLCODE,0)
       END IF
   END IF
   CLOSE i092_cl
   COMMIT WORK

END FUNCTION 

FUNCTION i092_undo_confirm()

	 IF cl_null(g_hrdx2[l_ac2].hrdx04) OR cl_null(g_hrdx2[l_ac2].hrdx01) THEN
	 	  CALL cl_err('',-400,0)
	 	  RETURN
	 END IF
	 	
	 SELECT * INTO g_hrdx.* FROM hrdx_file WHERE hrdx01=g_hrdx2[l_ac2].hrdx01
	                                         AND hrdx04=g_hrdx2[l_ac2].hrdx04
	 IF g_hrdx.hrdx14 != '002' THEN
	 	  CALL cl_err('计算组不是待审核状态,不可撤销','!',0)
	 	  RETURN
	 END IF
	 	
	 	
	 BEGIN WORK
    
   OPEN i092_cl USING g_hrdx.hrdx01,g_hrdx.hrdx04
   IF STATUS THEN
      CALL cl_err("open i092_cl:",STATUS,1)
      CLOSE i092_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i092_cl INTO g_hrdx.*
   IF SQLCA.sqlcode  THEN
     CALL cl_err(g_hrdx.hrdx04,SQLCA.sqlcode,0)
     CLOSE i092_cl
     ROLLBACK WORK
     RETURN
   END IF

   IF NOT cl_confirm("是否确定撤销?") THEN
   ELSE
      UPDATE hrdx_file
         SET hrdx14 = '001',
             hrdx08 = g_user,
             hrdx09 = g_today,
             hrdxmodu = g_user,
             hrdxdate = g_today
       WHERE hrdx01 = g_hrdx.hrdx01
         AND hrdx04 = g_hrdx.hrdx04
      
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrdx:',SQLCA.SQLCODE,0)
       END IF
   END IF
   CLOSE i092_cl
   COMMIT WORK
   
END FUNCTION 
	
FUNCTION i092_guidang()

	 IF cl_null(g_hrdx3[l_ac3].hrdx04) OR cl_null(g_hrdx3[l_ac3].hrdx01) THEN
	 	  CALL cl_err('',-400,0)
	 	  RETURN
	 END IF
	 	
	 SELECT * INTO g_hrdx.* FROM hrdx_file WHERE hrdx01=g_hrdx3[l_ac3].hrdx01
	                                         AND hrdx04=g_hrdx3[l_ac3].hrdx04
	 IF g_hrdx.hrdx14 != '003' THEN
	 	  CALL cl_err('计算组不是已审核状态,不可归档','!',0)
	 	  RETURN
	 END IF
	 	
	 	
	 BEGIN WORK
    
   OPEN i092_cl USING g_hrdx.hrdx01,g_hrdx.hrdx04
   IF STATUS THEN
      CALL cl_err("open i092_cl:",STATUS,1)
      CLOSE i092_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i092_cl INTO g_hrdx.*
   IF SQLCA.sqlcode  THEN
     CALL cl_err(g_hrdx.hrdx04,SQLCA.sqlcode,0)
     CLOSE i092_cl
     ROLLBACK WORK
     RETURN
   END IF

   IF NOT cl_confirm("是否确定归档?") THEN
   ELSE
      UPDATE hrdx_file
         SET hrdx14 = '004',
             hrdx08 = g_user,
             hrdx09 = g_today,
             hrdxmodu = g_user,
             hrdxdate = g_today
       WHERE hrdx01 = g_hrdx.hrdx01
         AND hrdx04 = g_hrdx.hrdx04
      
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrdx:',SQLCA.SQLCODE,0)
       END IF
   END IF
   CLOSE i092_cl
   COMMIT WORK	
	
END FUNCTION 
	
FUNCTION i092_undo_guidang()
	
	 IF cl_null(g_hrdx3[l_ac3].hrdx04) OR cl_null(g_hrdx3[l_ac3].hrdx01) THEN
	 	  CALL cl_err('',-400,0)
	 	  RETURN
	 END IF
	 	
	 SELECT * INTO g_hrdx.* FROM hrdx_file WHERE hrdx01=g_hrdx3[l_ac3].hrdx01
	                                         AND hrdx04=g_hrdx3[l_ac3].hrdx04
	 IF g_hrdx.hrdx14 != '003' THEN
	 	  CALL cl_err('计算组不是已审核状态,不可撤销','!',0)
	 	  RETURN
	 END IF
	 	
	 	
	 BEGIN WORK
    
   OPEN i092_cl USING g_hrdx.hrdx01,g_hrdx.hrdx04
   IF STATUS THEN
      CALL cl_err("open i092_cl:",STATUS,1)
      CLOSE i092_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH i092_cl INTO g_hrdx.*
   IF SQLCA.sqlcode  THEN
     CALL cl_err(g_hrdx.hrdx04,SQLCA.sqlcode,0)
     CLOSE i092_cl
     ROLLBACK WORK
     RETURN
   END IF

   IF NOT cl_confirm("是否确定撤销?") THEN
   ELSE
      UPDATE hrdx_file
         SET hrdx14 = '002',
             hrdx08 = g_user,
             hrdx09 = g_today,
             hrdxmodu = g_user,
             hrdxdate = g_today
       WHERE hrdx01 = g_hrdx.hrdx01
         AND hrdx04 = g_hrdx.hrdx04
      
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('upd hrdx:',SQLCA.SQLCODE,0)
       END IF
   END IF
   CLOSE i092_cl
   COMMIT WORK	
END FUNCTION							
	
FUNCTION i092_q()
   CALL i092_b_askkey()
END FUNCTION
	
FUNCTION i092_b_askkey()
	
    CLEAR FORM
    CALL g_hrdx1.clear()
 
    CONSTRUCT g_wc1 ON hrdx04,hrdx02,hrdx03,hrdx01,hrdx05,hrdx15,
                       hrdx06,hrdx07                       
         FROM s_hrdx1[1].hrdx04_1,s_hrdx1[1].hrdx02_1,s_hrdx1[1].hrdx03_1,                                  
              s_hrdx1[1].hrdx01_1,s_hrdx1[1].hrdx05_1,s_hrdx1[1].hrdx15_1,
              s_hrdx1[1].hrdx06_1,s_hrdx1[1].hrdx07_1
 
    BEFORE CONSTRUCT
      CALL cl_qbe_init()
         
      ON ACTION CONTROLP
         CASE 
         	  WHEN INFIELD(hrdx02_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdx1[1].hrdx02_1
               NEXT FIELD hrdx02_1
            WHEN INFIELD(hrdx01_1)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_hrct11"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_hrdx1[1].hrdx01_1
               NEXT FIELD hrdx01_1        
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
    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hrdxuser', 'hrdxgrup')
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc1 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
    LET g_wc1 = g_wc1 CLIPPED,get_data_filter('hrdxuser', 'hrdxgrup') #add by zhuzw 20150424
    CALL i092_b_fill()
    	
END FUNCTION
	
FUNCTION i092_b_fill()
DEFINE l_test1,l_test2         LIKE    type_file.chr100    #zhangbo131115test
	
	  #待计算组
	  LET g_sql=" SELECT hrdx04,hrdx02,'',hrdx03,hrdx01,'','',hrdx05,",
	            "        hrdx15,hrdx06,hrdx07",
	            "   FROM hrdx_file",
	            "  WHERE ",g_wc1 CLIPPED,
	            "    AND hrdx14='001' ",
	            "  ORDER BY hrdx04"
	  PREPARE i092_pb1 FROM g_sql
    DECLARE hrdx1_curs CURSOR FOR i092_pb1
    
    CALL g_hrdx1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdx1_curs INTO g_hrdx1[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hrdx1[g_cnt].hraa12 FROM hraa_file
         WHERE hraa01=g_hrdx1[g_cnt].hrdx02
         
        SELECT hrct07,hrct08 INTO g_hrdx1[g_cnt].hrct07,g_hrdx1[g_cnt].hrct08 
          FROM hrct_file
         WHERE hrct11=g_hrdx1[g_cnt].hrdx01           	

        #zhangbo131115test
        SELECT to_char(hrct07,'yyyy/mm/dd'),to_char(hrct08,'yyyy/mm/dd') INTO l_test1,l_test2
          FROM hrct_file
         WHERE hrct11=g_hrdx1[g_cnt].hrdx01
        #zhangbo131115test
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdx1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1 
    LET g_cnt = 0
    
    #待审已计算组
	  LET g_sql=" SELECT hrdx04,hrdx02,'',hrdx03,hrdx01,'','',hrdx05,",
	            "        hrdx15,hrdx06,hrdx07,hrdx08,hrdx09 ",
	            "   FROM hrdx_file",
	            "  WHERE ",g_wc2 CLIPPED,
	            "    AND hrdx14='002' ",
	            "  ORDER BY hrdx04"
	  PREPARE i092_pb2 FROM g_sql
    DECLARE hrdx2_curs CURSOR FOR i092_pb2
    
    CALL g_hrdx2.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdx2_curs INTO g_hrdx2[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hrdx2[g_cnt].hraa12 FROM hraa_file
         WHERE hraa01=g_hrdx2[g_cnt].hrdx02
         
        SELECT hrct07,hrct08 INTO g_hrdx2[g_cnt].hrct07,g_hrdx2[g_cnt].hrct08 
          FROM hrct_file
         WHERE hrct11=g_hrdx2[g_cnt].hrdx01          	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdx2.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1 
    LET g_cnt = 0
    
    #已审核已计算组
    LET g_sql=" SELECT hrdx04,hrdx02,'',hrdx03,hrdx01,'','',hrdx05,",
	            "        hrdx15,hrdx06,hrdx07,hrdx08,hrdx09,hrdx10,hrdx11 ",
	            "   FROM hrdx_file",
	            "  WHERE ",g_wc3 CLIPPED,
	            "    AND hrdx14='003' ",
	            "  ORDER BY hrdx04"
	  PREPARE i092_pb3 FROM g_sql
    DECLARE hrdx3_curs CURSOR FOR i092_pb3
    
    CALL g_hrdx3.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdx3_curs INTO g_hrdx3[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hrdx3[g_cnt].hraa12 FROM hraa_file
         WHERE hraa01=g_hrdx3[g_cnt].hrdx02
         
        SELECT hrct07,hrct08 INTO g_hrdx3[g_cnt].hrct07,g_hrdx3[g_cnt].hrct08 
          FROM hrct_file
         WHERE hrct11=g_hrdx3[g_cnt].hrdx01          	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdx3.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1 
    LET g_cnt = 0
    
    #已归档计算组
    LET g_sql=" SELECT hrdx04,hrdx02,'',hrdx03,hrdx01,'','',hrdx05,",
	            "        hrdx15,hrdx06,hrdx07,hrdx08,hrdx09,hrdx10,hrdx11,hrdx12,hrdx13 ",
	            "   FROM hrdx_file",
	            "  WHERE ",g_wc4 CLIPPED,
	            "    AND hrdx14='004' ",
	            "  ORDER BY hrdx04"
	  PREPARE i092_pb4 FROM g_sql
    DECLARE hrdx4_curs CURSOR FOR i092_pb4
    
    CALL g_hrdx4.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdx4_curs INTO g_hrdx4[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hraa12 INTO g_hrdx4[g_cnt].hraa12 FROM hraa_file
         WHERE hraa01=g_hrdx4[g_cnt].hrdx02
         
        SELECT hrct07,hrct08 INTO g_hrdx4[g_cnt].hrct07,g_hrdx4[g_cnt].hrct08 
          FROM hrct_file
         WHERE hrct11=g_hrdx4[g_cnt].hrdx01          	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdx4.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b4 = g_cnt-1 
    LET g_cnt = 0
    	                 	
END FUNCTION
	
FUNCTION i092_b2_fill(p_hrdxa22)
DEFINE p_hrdxa22   LIKE    hrdxa_file.hrdxa22 

    
    LET g_sql=" SELECT hrdxa02,hrdxa03,hrdxa04,hrdxa05,hrdxa06,",
              "        hrdxa07,hrdxa08,hrdxa09,hrdxa10,hrdxa11,",
              "        hrdxa12,hrdxa13,hrdxa14,hrdxa15,hrdxa16,",
              "        hrdxa17,hrdxa18,hrdxa19,hrdxa20,hrdxa21,",
              "        hrdxa23,hrdxa24,hrdxa25,hrdxa26,hrdxa27 ",
              "   FROM hrdxa_file ",
              "  WHERE hrdxa22='",p_hrdxa22,"' ",
              "  ORDER BY hrdxa02 "
    PREPARE i092_pb5 FROM g_sql
    DECLARE hrdxa_curs CURSOR FOR i092_pb5
    
    CALL g_hrdxa.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdxa_curs INTO g_hrdxa[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        
        SELECT hrat01 INTO g_hrdxa[g_cnt].hrdxa02 FROM hrat_file WHERE hratid=g_hrdxa[g_cnt].hrdxa02
        SELECT hrao02 INTO g_hrdxa[g_cnt].hrdxa04 FROM hrao_file WHERE hrao01=g_hrdxa[g_cnt].hrdxa04
        SELECT hras04 INTO g_hrdxa[g_cnt].hrdxa05 FROM hras_file WHERE hras01=g_hrdxa[g_cnt].hrdxa05
        SELECT hraa12 INTO g_hrdxa[g_cnt].hrdxa06 FROM hraa_file WHERE hraa01=g_hrdxa[g_cnt].hrdxa06
        
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdxa.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b5 = g_cnt-1 
    LET g_cnt = 0           
    DISPLAY g_rec_b5 TO FORMONLY.cn2    	
END FUNCTION
	
FUNCTION i092_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_msg  LIKE type_file.chr1000
   DEFINE   l_hratid   LIKE  hrat_file.hratid
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdx1 TO s_hrdx1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b1 TO FORMONLY.cnt
         CALL g_hrdxa.clear()
         LET g_rec_b5=0
         #add by zhangbo130922--begin
         IF l_ac1>0 THEN
            CALL FGL_SET_ARR_CURR(l_ac1)
         END IF
         #add by zhangbo130922--end

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         #CALL i092_b2_fill(g_hrdx1[l_ac1].hrdx04)
         CALL g_hrdxa.clear()
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG 
      
      ON ACTION jisuan
         LET g_action_choice="jisuan"
         EXIT DIALOG
      
      ON ACTION tijiao
         LET g_action_choice="tijiao"
         EXIT DIALOG
      
      ON ACTION cxkqgz
         LET g_action_choice="cxkqgz"
         EXIT DIALOG 
         
      ON ACTION ghri092_d  #显示所有人员薪资
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i092_b2_fill(g_hrdx1[l_ac1].hrdx04)
      
      ON ACTION detail
         LET l_ac1=1
         LET g_action_choice="detail" 
         EXIT DIALOG
      
      ON ACTION accept
         LET l_ac1=ARR_CURR()
         LET g_action_choice="detail" 
         EXIT DIALOG     
                                        
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdxa TO s_hrdxa.*  ATTRIBUTE(COUNT=g_rec_b5)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #DISPLAY g_rec_b5 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         CALL cl_show_fld_cont()
         
      ON ACTION accept
         IF NOT cl_null(g_hrdxa[l_ac5].hrdxa02) THEN
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdxa[l_ac5].hrdxa02
            LET l_msg="ghri0921 '",l_hratid,"' '",g_hrdx1[l_ac1].hrdx01,"' '",g_hrdx1[l_ac1].hrdx04,"'"
            CALL cl_cmdrun_wait(l_msg)
         END IF       
                                        
      END DISPLAY 
      
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG 
         
      ON ACTION pg4                                                       
         LET g_flag = "pg4"
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
	
FUNCTION i092_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_msg  LIKE type_file.chr1000
   DEFINE   l_hratid   LIKE  hrat_file.hratid   

   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdx2 TO s_hrdx2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b2 TO FORMONLY.cnt
         CALL g_hrdxa.clear()
         LET g_rec_b5=0
         #add by zhangbo130922--begin
         IF l_ac2>0 THEN
            CALL FGL_SET_ARR_CURR(l_ac2)
         END IF
         #add by zhangbo130922--end

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()
         #CALL i092_b2_fill(g_hrdx2[l_ac2].hrdx04)
         CALL g_hrdxa.clear()
      
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
      
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG  
         
      ON ACTION ghri092_d  #显示所有人员薪资
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i092_b2_fill(g_hrdx2[l_ac2].hrdx04)         
                                        
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdxa TO s_hrdxa.*  ATTRIBUTE(COUNT=g_rec_b5)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b5 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         CALL cl_show_fld_cont()
         
      ON ACTION accept     
         IF NOT cl_null(g_hrdxa[l_ac5].hrdxa02) THEN
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdxa[l_ac5].hrdxa02
            LET l_msg="ghri0921 '",l_hratid,"' '",g_hrdx2[l_ac2].hrdx01,"' '",g_hrdx2[l_ac2].hrdx04,"'"
            CALL cl_cmdrun_wait(l_msg)
         END IF
                                 
      END DISPLAY 
      
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG 
         
      ON ACTION pg4                                                       
         LET g_flag = "pg4"
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
	
FUNCTION i092_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_msg  LIKE type_file.chr1000
   DEFINE   l_hratid  LIKE  hrat_file.hratid 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdx3 TO s_hrdx3.*  ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b3 TO FORMONLY.cnt
         CALL g_hrdxa.clear()
         LET g_rec_b5=0
         #add by zhangbo130922--begin
         IF l_ac3>0 THEN
            CALL FGL_SET_ARR_CURR(l_ac3)
         END IF
         #add by zhangbo130922--end

      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()
         #CALL i092_b2_fill(g_hrdx3[l_ac3].hrdx04)
         CALL g_hrdxa.clear()
      
      ON ACTION guidang
         LET g_action_choice="guidang"
         EXIT DIALOG
      
      ON ACTION undo_guidang
         LET g_action_choice="undo_guidang"
         EXIT DIALOG   
         
      ON ACTION ghri092_d  #显示所有人员薪资
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i092_b2_fill(g_hrdx3[l_ac3].hrdx04)        
                                        
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdxa TO s_hrdxa.*  ATTRIBUTE(COUNT=g_rec_b5)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b5 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         CALL cl_show_fld_cont()
         
      ON ACTION accept
         IF NOT cl_null(g_hrdxa[l_ac5].hrdxa02) THEN
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdxa[l_ac5].hrdxa02
            LET l_msg="ghri0921 '",l_hratid,"' '",g_hrdx3[l_ac3].hrdx01,"' '",g_hrdx3[l_ac3].hrdx04,"'"
            CALL cl_cmdrun_wait(l_msg)
         END IF     
                                        
      END DISPLAY 
      
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG 
         
      ON ACTION pg4                                                       
         LET g_flag = "pg4"
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
	
FUNCTION i092_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
   DEFINE   l_msg  LIKE type_file.chr1000
   DEFINE   l_hratid    LIKE   hrat_file.hratid
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdx4 TO s_hrdx4.*  ATTRIBUTE(COUNT=g_rec_b4)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b4 TO FORMONLY.cnt
         CALL g_hrdxa.clear()
         LET g_rec_b5=0
         #add by zhangbo130922--begin
         IF l_ac4>0 THEN
            CALL FGL_SET_ARR_CURR(l_ac4)
         END IF
         #add by zhangbo130922--end

      BEFORE ROW
         LET l_ac4 = ARR_CURR()
         CALL cl_show_fld_cont()
         #CALL i092_b2_fill(g_hrdx4[l_ac4].hrdx04) 
         CALL g_hrdxa.clear() 
         
      ON ACTION ghri092_d  #显示所有人员薪资
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()
         CALL i092_b2_fill(g_hrdx4[l_ac4].hrdx04)        
                                        
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdxa TO s_hrdxa.*  ATTRIBUTE(COUNT=g_rec_b5)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         DISPLAY g_rec_b5 TO FORMONLY.cn2

      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         CALL cl_show_fld_cont()
         
      ON ACTION accept  
         IF NOT cl_null(g_hrdxa[l_ac5].hrdxa02) THEN
            SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_hrdxa[l_ac5].hrdxa02
            LET l_msg="ghri0921 '",l_hratid,"' '",g_hrdx4[l_ac4].hrdx01,"' '",g_hrdx4[l_ac4].hrdx04,"'"
            CALL cl_cmdrun_wait(l_msg)
         END IF   
                                        
      END DISPLAY 
      
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG 
         
      ON ACTION pg2                                                       
         LET g_flag = "pg2"
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
	
FUNCTION i092_b()
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
 
    LET g_forupd_sql = "SELECT hrdx04,hrdx02,'',hrdx03,hrdx01,'','',",
                       "       hrdx05,hrdx15,hrdx06,hrdx07 ",
                       "  FROM hrdx_file WHERE hrdx01=? AND hrdx04=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i092_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_hrdx1 WITHOUT DEFAULTS FROM s_hrdx1.*
          ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert) 
 
    BEFORE INPUT
       IF g_rec_b1 != 0 THEN
          CALL fgl_set_arr_curr(l_ac1)
       END IF		
       	
    BEFORE ROW
        LET p_cmd='' 
        LET l_ac1 = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b1>=l_ac1 THEN
           BEGIN WORK
           LET p_cmd='u'
#No.FUN-570110 --start                                                          
           LET g_before_input_done = FALSE                                                                              
           LET g_before_input_done = TRUE                                       
#No.FUN-570110 --end   
                      
           LET g_hrdx1_t.* = g_hrdx1[l_ac1].*  #BACKUP
           OPEN i092_bcl USING g_hrdx1_t.hrdx01,g_hrdx1_t.hrdx04
           IF STATUS THEN
              CALL cl_err("OPEN i092_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE 
              FETCH i092_bcl INTO g_hrdx1[l_ac1].* 
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_hrdx1_t.hrdx01,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              
              SELECT hraa12 INTO g_hrdx1[l_ac1].hraa12 FROM hraa_file 
               WHERE hraa01=g_hrdx1[l_ac1].hrdx02
               
              SELECT hrct07,hrct08 INTO g_hrdx1[l_ac1].hrct07,g_hrdx1[l_ac1].hrct08
                FROM hrct_file
               WHERE hrct11=g_hrdx1[l_ac1].hrdx01
                
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
         INITIALIZE g_hrdx1[l_ac1].* TO NULL  
         LET g_hrdx1[l_ac1].hrdx05=1
         LET g_hrdx1[l_ac1].hrdx06=g_today
         #LET g_hrdx1[l_ac1].hrdx14='001'
         LET g_hrdx1_t.* = g_hrdx1[l_ac1].*         
         CALL cl_show_fld_cont()     
         NEXT FIELD hrdx04_1
         
    AFTER INSERT
        DISPLAY "AFTER INSERT" 
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           CLOSE i092_bcl
           CANCEL INSERT
        END IF
 
        BEGIN WORK                    #FUN-680010
 
        INSERT INTO hrdx_file(hrdx01,hrdx02,hrdx03,hrdx04,hrdx05,hrdx15,hrdx06,hrdx07,hrdx14,                          #FUN-A30097
                              hrdxacti,hrdxdate,hrdxuser,hrdxgrup,hrdxoriu,hrdxorig) 
               VALUES(g_hrdx1[l_ac1].hrdx01,g_hrdx1[l_ac1].hrdx02,
                      g_hrdx1[l_ac1].hrdx03,g_hrdx1[l_ac1].hrdx04,
                      g_hrdx1[l_ac1].hrdx05,g_hrdx1[l_ac1].hrdx15,g_hrdx1[l_ac1].hrdx06,
                      g_hrdx1[l_ac1].hrdx07,'001','Y',g_today,g_user,g_grup,g_user,g_grup) 
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","hrdx_file",g_hrdx1[l_ac1].hrdx04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660131
           ROLLBACK WORK              #FUN-680010
           CANCEL INSERT
        ELSE  
           LET g_rec_b1=g_rec_b1+1    
           DISPLAY g_rec_b1 TO FORMONLY.cnt     
           COMMIT WORK  
        END IF        	  	
        	
    AFTER FIELD hrdx04_1                        
       IF NOT cl_null(g_hrdx1[l_ac1].hrdx04) THEN
       	  IF g_hrdx1_t.hrdx04 != g_hrdx1[l_ac1].hrdx04 
       	  	 OR g_hrdx1_t.hrdx04 IS NULL THEN
             LET l_n=0
             SELECT COUNT(*) INTO l_n FROM hrdx_file
              WHERE hrdx04 = g_hrdx1[l_ac1].hrdx04
             IF l_n > 0 THEN
                CALL cl_err('计算组不可重复','!',0)
                LET g_hrdx1[l_ac1].hrdx04 = g_hrdx1_t.hrdx04
                NEXT FIELD hrdx04_1
             END IF
          END IF                                       	
       END IF
       	
    AFTER FIELD hrdx02_1
       IF NOT cl_null(g_hrdx1[l_ac1].hrdx02) THEN
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hraa_file
           WHERE hraa01=g_hrdx1[l_ac1].hrdx02
          IF l_n=0 THEN
          	 CALL cl_err('无此公司编号','!',0)
          	 NEXT FIELD hrdx02_1
          END IF
          SELECT hraa12 INTO g_hrdx1[l_ac1].hraa12
            FROM hraa_file
           WHERE hraa01=g_hrdx1[l_ac1].hrdx02		  
       END IF
       	
    AFTER FIELD hrdx01_1
       IF NOT cl_null(g_hrdx1[l_ac1].hrdx01) THEN
       	  IF NOT cl_null(g_hrdx1[l_ac1].hrdx02) THEN
       	     LET l_n=0	
       	     SELECT COUNT(*) INTO l_n FROM hrct_file
       	      WHERE hrct03=g_hrdx1[l_ac1].hrdx02
       	        AND hrct11=g_hrdx1[l_ac1].hrdx01
       	        AND hrct06='N'
       	     IF l_n=0 THEN
       	  	    CALL cl_err('无此薪资月或者薪资月错误','!',0)
       	  	    NEXT FIELD hrdx01_1
       	     END IF
       	  ELSE
       	  	 LET g_hrdx1[l_ac1].hrdx01=''
       	  	 CALL cl_err('维护薪资月前必须先维护公司','!',0)
       	  	 NEXT FIELD hrdx02_1
       	  END IF
       	  	
       	  SELECT hrct07,hrct08 INTO g_hrdx1[l_ac1].hrct07,g_hrdx1[l_ac1].hrct08
       	    FROM hrct_file
       	   WHERE hrct11=g_hrdx1[l_ac1].hrdx01	
       
       END IF
   
       	
    BEFORE DELETE                           
       IF g_hrdx1_t.hrdx04 IS NOT NULL THEN
          IF NOT cl_delete() THEN
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE
          END IF
          INITIALIZE g_doc.* TO NULL                #No.FUN-9B0098 10/02/24
          LET g_doc.column1 = "hrdx04"               #No.FUN-9B0098 10/02/24
          LET g_doc.value1 = g_hrdx1[l_ac1].hrdx04      #No.FUN-9B0098 10/02/24
          CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
          IF l_lock_sw = "Y" THEN 
             CALL cl_err("", -263, 1) 
             ROLLBACK WORK      #FUN-680010
             CANCEL DELETE 
          END IF
          
          DELETE FROM hrdxc_file WHERE hrdxc01=g_hrdx1_t.hrdx01
                                   AND hrdxc09=g_hrdx1_t.hrdx04
          DELETE FROM hrdxb_file WHERE hrdxb01=g_hrdx1_t.hrdx01
                                   AND hrdxb11=g_hrdx1_t.hrdx04
          DELETE FROM hrdxa_file WHERE hrdxa01=g_hrdx1_t.hrdx01
                                   AND hrdxa22=g_hrdx1_t.hrdx04 
          DELETE FROM hrdx_file WHERE hrdx01 = g_hrdx1_t.hrdx01
                                  AND hrdx04 = g_hrdx1_t.hrdx04
    
                    
          IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdx_file",g_hrdx1_t.hrdx01,g_hrdx1_t.hrdx02,SQLCA.sqlcode,"","",1)  #No.FUN-660131
              ROLLBACK WORK      #FUN-680010
              CANCEL DELETE
              EXIT INPUT
          ELSE
          	 LET g_rec_b1=g_rec_b1-1
          	 DISPLAY g_rec_b1 TO cnt    
          END IF
 
       END IF
       	
    ON ROW CHANGE
       IF INT_FLAG THEN             
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         LET g_hrdx1[l_ac1].* = g_hrdx1_t.*
         CLOSE i092_bcl
         ROLLBACK WORK
         EXIT INPUT
       END IF
       	
       IF l_lock_sw="Y" THEN
          CALL cl_err(g_hrdx1[l_ac1].hrdx01,-263,0)
          LET g_hrdx1[l_ac1].* = g_hrdx1_t.*
       ELSE
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hrdxa_file 
           WHERE hrdxa01=g_hrdx1_t.hrdx01
             AND hrdxa22=g_hrdx1_t.hrdx04
          IF l_n=0 THEN    
             #FUN-A30030 END--------------------
             UPDATE hrdx_file SET hrdx01=g_hrdx1[l_ac1].hrdx01,
                                  hrdx02=g_hrdx1[l_ac1].hrdx02,
                                  hrdx03=g_hrdx1[l_ac1].hrdx03,
                                  hrdx04=g_hrdx1[l_ac1].hrdx04,
                                  hrdx05=g_hrdx1[l_ac1].hrdx05, 
                                  hrdx06=g_hrdx1[l_ac1].hrdx06,
                                  hrdx07=g_hrdx1[l_ac1].hrdx07,
                                  hrdx15=g_hrdx1[l_ac1].hrdx15,
                                  hrdxmodu=g_user,
                                  hrdxdate=g_today
                            WHERE hrdx01 = g_hrdx1_t.hrdx01
                              AND hrdx04 = g_hrdx1_t.hrdx04
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","hrdx_file",g_hrdx1_t.hrdx01,g_hrdx1_t.hrdx04,SQLCA.sqlcode,"","",1)  #No.FUN-660131
                ROLLBACK WORK    #FUN-680010
                LET g_hrdx1[l_ac1].* = g_hrdx1_t.*
             END IF
          ELSE
          	 CALL cl_err('已有计算明细资料,不可更改','!',0)
          	 LET g_hrdx1[l_ac1].* = g_hrdx1_t.*
          END IF	    	
       END IF   
       
        		   	    	
    AFTER ROW
       LET l_ac1 = ARR_CURR()            
       LET l_ac_t = l_ac1                
       
       IF INT_FLAG THEN                 #900423
          CALL cl_err('',9001,0)
          LET INT_FLAG = 0
          IF p_cmd='u' THEN
             LET g_hrdx1[l_ac1].* = g_hrdx1_t.*
          END IF
          CLOSE i092_bcl                
          ROLLBACK WORK                 
          EXIT INPUT
        END IF
        CLOSE i092_bcl                
        COMMIT WORK  

     ON ACTION controlp
        CASE
           WHEN INFIELD(hrdx02_1)
           CALL cl_init_qry_var()
           LET g_qryparam.default1 = g_hrdx1[l_ac1].hrdx02
           LET g_qryparam.form = "q_hraa01"
           CALL cl_create_qry() RETURNING g_hrdx1[l_ac1].hrdx02
           DISPLAY g_hrdx1[l_ac1].hrdx02 TO hrdx02_1
           NEXT FIELD hrdx02_1
           
           WHEN INFIELD(hrdx01_1)
           CALL cl_init_qry_var()
           LET g_qryparam.default1 = g_hrdx1[l_ac1].hrdx01
           LET g_qryparam.form = "q_hrct11_1"             #mod by zhangbo131111---q_hrct11---->q_hrct11_1
           LET g_qryparam.arg1 = g_hrdx1[l_ac1].hrdx02    #add by zhangbo131111 
           CALL cl_create_qry() RETURNING g_hrdx1[l_ac1].hrdx01
           DISPLAY g_hrdx1[l_ac1].hrdx01 TO hrdx01_1
           NEXT FIELD hrdx01_1
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
 
    CLOSE i092_bcl
    COMMIT WORK
END FUNCTION 
	
FUNCTION i092_jisuan()
DEFINE l_hrdx   RECORD LIKE   hrdx_file.*	
DEFINE l_hrct07        LIKE   hrct_file.hrct07
DEFINE l_hrct08        LIKE   hrct_file.hrct08
DEFINE l_n             LIKE   type_file.num5
DEFINE l_i             LIKE   type_file.num5
DEFINE l_hratid        LIKE   hrat_file.hratid
DEFINE l_hrat03        LIKE   hrat_file.hrat03
DEFINE l_hrat04        LIKE   hrat_file.hrat04
DEFINE l_hrat05        LIKE   hrat_file.hrat05
DEFINE li_i,li_j       LIKE   type_file.num5        #add by zhangbo130910
DEFINE l_sql,l_empids           STRING                       #add by zhangbo130910
DEFINE l_hraz05        LIKE hraz_file.hraz05 #add by zhuzw 20150126    
    #记录选择的员工 
    DROP TABLE emp_tmp
    CREATE TEMP TABLE emp_tmp
    (hrat03  LIKE    hrat_file.hrat03,
     hrat01  LIKE    hrat_file.hrat01,
     hrat02  LIKE    hrat_file.hrat02,
     hrat04  LIKE    hrat_file.hrat04,
     hrat05  LIKE    hrat_file.hrat05,
     hrat25  LIKE    hrat_file.hrat25,
     hrdm03  VARCHAR(20)
     )
    CALL g_emp.clear()
    LET g_rec_b6=0
    LET g_count=0
    INITIALIZE g_hrdl01 TO NULL
     
    SELECT * INTO l_hrdx.* FROM hrdx_file 
     WHERE hrdx01=g_hrdx1[l_ac1].hrdx01
       AND hrdx04=g_hrdx1[l_ac1].hrdx04
    IF cl_null(l_hrdx.hrdx01) OR cl_null(l_hrdx.hrdx04) THEN
    	 CALL cl_err('未设置计算组','!',1)
    	 RETURN
    END IF
    
    IF l_hrdx.hrdx14 != '001' THEN
    	 CALL cl_err('该计算组不是待计算状态','!',1)
    	 RETURN
    END IF
    	
    LET l_n=0
    SELECT COUNT(*) INTO l_n FROM hrdxa_file 
     WHERE hrdxa01=l_hrdx.hrdx01
       AND hrdxa22=l_hrdx.hrdx04
    IF l_n>0 THEN
    	 IF NOT cl_confirm('该计算组已有计算数据,是否重新计算?') THEN
    	 	  RETURN
    	 END IF	
    END IF	 	    
   	
    OPEN WINDOW i092_w1 WITH FORM "ghr/42f/ghri092_js"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

    CALL cl_ui_init()
    
    CALL cl_set_combo_items("hrdl01",NULL,NULL)
    CALL cl_set_combo_items("hrdm03",NULL,NULL)
    
    #薪资类别
    CALL i092_get_hrdl01() RETURNING l_name,l_items
    CALL cl_set_combo_items("hrdl01",l_name,l_items)
    CALL cl_set_combo_items("hrdm03",l_name,l_items)
    
    DISPLAY g_hrdl01 TO hrdl01
    DISPLAY l_hrdx.hrdx04 TO hrdx04
    DISPLAY l_hrdx.hrdx03 TO hrdx03
    DISPLAY l_hrdx.hrdx01 TO hrdx01
    DISPLAY l_hrdx.hrdx05 TO hrdx05
    SELECT hrct07,hrct08 INTO l_hrct07,l_hrct08
      FROM hrct_file
     WHERE hrct11=l_hrdx.hrdx01
    DISPLAY l_hrct07 TO hrct07
    DISPLAY l_hrct08 TO hrct08
    
    #add by zhangbo130910---begin
    LET l_sql="SELECT hrdxa02 FROM hrdxa_file WHERE hrdxa22='",l_hrdx.hrdx04,"'"
    PREPARE i092_yg_pre FROM l_sql
    DECLARE i092_yg_cs CURSOR FOR i092_yg_pre

    LET g_cnt=g_rec_b6+1

    FOREACH i092_yg_cs INTO g_emp[g_cnt].hrat01
       SELECT DISTINCT hrdm03 INTO g_emp[g_cnt].hrdm03 FROM hrdm_file,hrct_file A,hrct_file B 
        WHERE hrdm02=g_emp[g_cnt].hrat01
          AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
          AND hrdm04=A.hrct11                          
          AND ((hrdm05=B.hrct11 AND hrdm13='N'                 #mod by zhangbo130912
                AND l_hrct07 BETWEEN A.hrct07 AND B.hrct07)    #mod by zhangbo130912
               OR (hrdm13='Y' AND l_hrct07>=A.hrct07))         #add by zhangbo130912 
           
       IF cl_null(g_emp[g_cnt].hrdm03) THEN
          CONTINUE FOREACH
       END IF

       SELECT hrat01 INTO g_emp[g_cnt].hrat01 FROM hrat_file
        WHERE hratid=g_emp[g_cnt].hrat01
       
       LET g_emp[g_cnt].chk='Y'
       SELECT hraa12 INTO g_emp[g_cnt].hrat03 FROM hrat_file,hraa_file
        WHERE hrat01=g_emp[g_cnt].hrat01 AND hrat03=hraa01
       SELECT hrat02 INTO g_emp[g_cnt].hrat02 FROM hrat_file
        WHERE hrat01=g_emp[g_cnt].hrat01
       SELECT hrao02 INTO g_emp[g_cnt].hrat04 FROM hrat_file,hrao_file
        WHERE hrat01=g_emp[g_cnt].hrat01 AND hrao01=hrat04
       SELECT hras04 INTO g_emp[g_cnt].hrat05 FROM hrat_file,hras_file
        WHERE hrat01=g_emp[g_cnt].hrat01 AND hras01=hrat05 
#       #add by zhuzw 20150126 start 
#       SELECT  COUNT(*) INTO l_n FROM  hraz_file WHERE  hraz01 = g_emp[g_cnt].hrat01
#       IF l_n = 0 THEN 
#          SELECT hrao02 INTO g_emp[g_cnt].hrat04 FROM hrat_file,hrao_file
#           WHERE hrat01=g_emp[g_cnt].hrat01 AND hrao01=hrat04
#          SELECT hras04 INTO g_emp[g_cnt].hrat05 FROM hrat_file,hras_file
#           WHERE hrat01=g_emp[g_cnt].hrat01 AND hras01=hrat05 
#       ELSE 
#       	  SELECT  MAX(hraz05) INTO l_hraz05 FROM  hraz_file WHERE  hraz01 = g_emp[g_cnt].hrat01 
#       	     IF l_hraz05 < l_hrct08 THEN 
#       	         SELECT  hraz08,hraz10 INTO g_emp[g_cnt].hrat04,g_emp[g_cnt].hrat05  FROM  hraz_file WHERE  hraz01 = g_emp[g_cnt].hrat01 AND hraz05 = l_hraz05 
#       	     END IF
#       	     IF l_hraz05 >= l_hrct08 THEN 
#       	         SELECT  hraz07,hraz09  INTO g_emp[g_cnt].hrat04,g_emp[g_cnt].hrat05  FROM  hraz_file WHERE  hraz01 = g_emp[g_cnt].hrat01 AND hraz05 = l_hraz05 
#       	     END IF       	      
#             SELECT hras04 INTO g_emp[g_cnt].hrat05 FROM hras_file 
#              WHERE hras01 = g_emp[g_cnt].hrat05
#             SELECT hrao02 INTO g_emp[g_cnt].hrat04 FROM hrao_file 
#              WHERE hrao01 = g_emp[g_cnt].hrat04  
#       END IF 	    
#      #add by zhuzw 20150126 end   
       SELECT hrat25 INTO g_emp[g_cnt].hrat25 FROM hrat_file
        WHERE hrat01=g_emp[g_cnt].hrat01
              
       LET g_cnt = g_cnt + 1
       LET g_count = g_count+1

    END FOREACH
    CALL g_emp.deleteElement(g_cnt)
    LET g_rec_b6 = g_cnt-1 
    LET g_cnt = 0        
    DISPLAY g_count TO cn2
    #add by zhangbo130910---end   
    
    WHILE TRUE
   	
   	  DIALOG ATTRIBUTES(UNBUFFERED)
   	     INPUT g_hrdl01 FROM hrdl01 ATTRIBUTE(WITHOUT DEFAULTS)
   	     
   	 ON ACTION sel
                 CALL cl_init_qry_var()
                 lET g_qryparam.form = "q_hrdm03"
                 #LET g_qryparam.construct = 'N'
                 LET g_qryparam.arg1 = l_hrct08
                 LET g_qryparam.arg2 = g_hrdl01
                 LET g_qryparam.arg3 = l_hrct07
                 LET g_qryparam.state = "c"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 LET l_empids = g_qryparam.multiret
   	    #IF NOT cl_null(g_hrdl01) THEN
               CALL i092_emp_fill(g_hrdl01,l_hrdx.hrdx01,l_hrdx.hrdx04,l_empids)
               DISPLAY g_count TO cn2                     #add by zhangb130910
            #ELSE
            #   CALL cl_err('请先选择薪资类别','!',1)
            #END IF
            	
         ON ACTION lzwjq
            CALL i092_lz_fill(l_hrdx.hrdx01,l_hrdx.hrdx04)    
            DISPLAY g_count TO cn2                     #add by zhangb130910

   	     
   	 ON ACTION close
            LET INT_FLAG=1
            EXIT DIALOG

         ON ACTION exit
            LET INT_FLAG=1
            EXIT DIALOG
           	
         ON ACTION CONTROLZ
            CALL cl_show_req_fields()

         ON ACTION CONTROLF                        # 欄位說明
            CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
            CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
            
         END INPUT 
    
         INPUT ARRAY g_emp FROM s_emp.* 
            ATTRIBUTE(COUNT=g_rec_b6,MAXCOUNT=g_rec_b6,
               WITHOUT DEFAULTS=TRUE,
               INSERT ROW=FALSE,DELETE ROW=TRUE,APPEND ROW=TRUE)
               
         #AFTER INPUT
         #   IF INT_FLAG THEN
         #      EXIT INPUT
         #   END IF

         #add by zhangbo130910
         ON CHANGE chk
            LET g_count=0
            FOR g_cnt=1 TO g_rec_b6
               IF g_emp[g_cnt].chk='Y' THEN
                  LET g_count=g_count+1
               END IF
            END FOR
            DISPLAY g_count TO cn2


         BEFORE DELETE
            LET l_n=arr_curr()
            IF l_n>0 THEN
            #   CALL g_emp.deleteElement(l_n)
               LET g_rec_b6=g_rec_b6-1
            END IF
            LET g_count=0
            FOR li_i=1 TO g_rec_b6
               LET li_j=li_i
               IF g_emp[li_j].chk='Y' THEN
                  LET g_count=g_count+1
               END IF
            END FOR
            DISPLAY g_count TO cn2  
         #add by zhangbo130910
            	           	
         ON ACTION close
            LET INT_FLAG=1
            EXIT DIALOG      

         ON ACTION exit
            LET INT_FLAG=1
            EXIT DIALOG

         END INPUT

         ON ACTION ghri092_a        #全选
            FOR g_cnt=1 TO g_rec_b6
               LET g_emp[g_cnt].chk='Y'
            END FOR
            
         ON ACTION ghri092_b        #反选
            FOR g_cnt=1 TO g_rec_b6
               IF g_emp[g_cnt].chk='Y' THEN
                  LET g_emp[g_cnt].chk='N'
               ELSE
                  LET g_emp[g_cnt].chk='Y'
               END IF
            END FOR
            
         ON ACTION ghri092_c        #全弃
            FOR g_cnt=1 TO g_rec_b6
               LET g_emp[g_cnt].chk='N'
            END FOR
            
         ON ACTION count
            LET l_i=0
            SELECT COUNT(*) INTO l_n FROM emp_tmp
            DELETE FROM emp_tmp 
            SELECT COUNT(*) INTO l_n FROM emp_tmp
            FOR g_cnt=1 TO g_rec_b6
               IF g_emp[g_cnt].chk='Y' THEN
               	  LET l_i=l_i+1
               	  SELECT hratid INTO l_hratid FROM hrat_file WHERE hrat01=g_emp[g_cnt].hrat01
#               	  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hratid=l_hratid
#               	  SELECT hrat04 INTO l_hrat04 FROM hrat_file WHERE hratid=l_hratid
#               	  SELECT hrat05 INTO l_hrat05 FROM hrat_file WHERE hratid=l_hratid
               #add by zhuzw 20150126 start 
                SELECT  COUNT(*) INTO l_n FROM  hraz_file WHERE  hraz01 = l_hratid
                IF l_n = 0 THEN 
                  SELECT hrat03 INTO l_hrat03 FROM hrat_file WHERE hratid=l_hratid
               	  SELECT hrat04 INTO l_hrat04 FROM hrat_file WHERE hratid=l_hratid
               	  SELECT hrat05 INTO l_hrat05 FROM hrat_file WHERE hratid=l_hratid
                ELSE 
                 	  SELECT  MAX(hraz05) INTO l_hraz05 FROM  hraz_file WHERE  hraz01 = l_hratid
                 	     IF l_hraz05 < l_hrct08 THEN 
                	         SELECT  hraz31,hraz08,hraz10 INTO l_hrat03,l_hrat04,l_hrat05  FROM  hraz_file WHERE  hraz01 = l_hratid AND hraz05 = l_hraz05 
                	     END IF
               	     IF l_hraz05 >= l_hrct08 THEN 
               	         SELECT  hraz30,hraz07,hraz09  INTO l_hrat03,l_hrat04,l_hrat05  FROM  hraz_file WHERE  hraz01 = l_hratid  AND hraz05 = l_hraz05 
              	     END IF       	      
                END IF 	    
             #add by zhuzw 20150126 end  
                   	  INSERT INTO emp_tmp VALUES (l_hrat03,l_hratid,g_emp[g_cnt].hrat02,l_hrat04,
                   	                              l_hrat05,g_emp[g_cnt].hrat25,g_emp[g_cnt].hrdm03)
                END IF
             END FOR 
            SELECT COUNT(*) INTO l_n FROM emp_tmp
            IF l_i>0 THEN
            	 IF cl_confirm('是否进行计算?') THEN
            	    CALL i092_js(l_hrdx.hrdx01,l_hrdx.hrdx04)
            	    LET INT_FLAG=1
            	    EXIT DIALOG
            	 END IF   
            ELSE
            	 CALL cl_err('请先选择员工再进行计算','!',1)
            END IF
                		 	 
         
         ON ACTION CONTROLG
            CALL cl_cmdask()
         
         ON ACTION about 
            CALL cl_about()
      
         ON ACTION help  
            CALL cl_show_help()
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
    
    END DIALOG
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       EXIT WHILE
    END IF      		 		    
   	
    END WHILE
   
    CLOSE WINDOW i092_w1        
                      
END FUNCTION
	
FUNCTION i092_emp_fill(p_hrdl01,p_hrdx01,p_hrdx04,p_empIds)
DEFINE  l_sql,p_empIds        STRING
DEFINE  p_hrdl01     LIKE   hrdl_file.hrdl01
DEFINE  p_hrdx01     LIKE   hrdx_file.hrdx01
DEFINE  p_hrdx04     LIKE   hrdx_file.hrdx04
DEFINE  l_hrct07   LIKE   hrct_file.hrct07
DEFINE  l_hrct08   LIKE   hrct_file.hrct08
#DEFINE  l_hrct07_2   LIKE   hrct_file.hrct07
#DEFINE  l_hrct07_3   LIKE   hrct_file.hrct07
DEFINE  l_hrct03     LIKE   hrct_file.hrct03
DEFINE  l_i          LIKE   type_file.num5
DEFINE  l_check      LIKE   type_file.chr1
        
        SELECT hrct07 INTO l_hrct07 FROM hrct_file WHERE hrct11=p_hrdx01
        SELECT hrct03 INTO l_hrct03 FROM hrct_file WHERE hrct11=p_hrdx01
        SELECT hrct08 INTO l_hrct08 FROM hrct_file WHERE hrct11=p_hrdx01
        
#         LET l_sql=" select DISTINCT hrdm02,hrdm03 from ",
#                  " hrdm_file",
#                  " left join hrat_file on hratid=hrdm02",
#                  " LEFT JOIN hrad_file ON hrad02=hrat19",
#                  " LEFT JOIN hrdo_file ON hrdo02=hratid",
#                  " LEFT JOIN hrct_file a ON a.hrct11=hrdm04",
#                  " LEFT JOIN hrct_file b ON b.hrct11=hrdm05",
#                  " LEFT JOIN hrct_file c ON c.hrct11=hrdo04",
#                  " LEFT JOIN hrct_file d ON d.hrct11=hrdo05",
#                  #add by yinbq 20141118 for 取消对员工必须是当前计算组薪资月对应公司的限制
#                  #" WHERE hrad01 <> '003' AND HRATCONF='Y' AND hrat03='",l_hrct03,"' ",
#                  " WHERE HRATCONF='Y' ",
#                  #add by yinbq 20141118 for 取消对员工必须是当前计算组薪资月对应公司的限制
#                  " AND hrat25 <= '",l_hrct08,"'",
#                  " AND nvl(hrat77,to_date('20991231','yyyymmdd'))>='",l_hrct07,"' ",
#                  " AND a.hrct07<='",l_hrct07,"' ",
#                  " AND nvl(b.hrct07,to_date('20991231','yyyymmdd'))>='",l_hrct07,"' ",
#                  " AND (c.hrct07 > '",l_hrct07,"' OR d.hrct07<'",l_hrct07,"' OR hrdo02 is null)"
         LET l_sql=" select DISTINCT hrdm02,hrdm03 from ",
                  " hrdm_file",
                  " left join hrat_file on hratid=hrdm02",
                  " LEFT JOIN hrct_file a ON a.hrct11=hrdm04",
                  " LEFT JOIN hrct_file b ON b.hrct11=hrdm05",
                  " WHERE HRATCONF='Y' ",    #AND hrat03='",l_hrct03,"' ",
                  " AND hrat25 <= '",l_hrct08,"'",
                  " AND nvl(hrat77,to_date('20991231','yyyymmdd'))>='",l_hrct07,"' ",
                  " AND a.hrct07<='",l_hrct07,"' ",
                  " AND nvl(b.hrct07,to_date('20991231','yyyymmdd'))>='",l_hrct07,"' ",
                  " AND NOT EXISTS(SELECT 1 FROM HRDO_FILE",
                  "                  LEFT JOIN HRCT_FILE C ON C.HRCT11 = HRDO04",
                  "                  LEFT JOIN HRCT_FILE D ON D.HRCT11 = HRDO05",
                  "                 WHERE HRDO02 = HRATID",
                  "                  AND C.HRCT07 <='",l_hrct07,"' ",
                  "                  AND NVL(D.HRCT07, TO_DATE('20991231', 'yyyymmdd')) > '",l_hrct07,"' )"

#20141229 add by yinbq for 选择计算员工时，不做已经计算的限制
#" AND NOT EXISTS(SELECT 1 FROM hrdxb_file WHERE hrdxb01 = '",p_hrdx01,"' AND hrdxb02=hrdm02)"
#20141229 add by yinbq for 选择计算员工时，不做已经计算的限制

         IF NOT cl_null(p_hrdl01) THEN LET l_sql = l_sql," AND hrdm03 = '",p_hrdl01,"'" END IF
         #IF NOT cl_null(p_empIds) THEN 
            LET p_empIds = cl_replace_str(p_empIds,"|","','")
#add by yinbq 20141124 for 开窗传值为员工工号，调整查询脚本
#            LET l_sql = l_sql," AND hrdm02 IN('",p_empIds,"')"
            LET l_sql = l_sql," AND hrat01 IN('",p_empIds,"')"
#add by yinbq 20141124 for 开窗传值为员工工号，调整查询脚本
         #END IF
#        LET l_sql=" SELECT DISTINCT hrdm02,hrdm03 FROM hrdm_file,hrat_file,hrad_file,hrct_file A,hrct_file B ",
#                  "  WHERE hrdm02=hratid ",
#                  "    AND hrat19=hrad02 ",
#                  "    AND hrat03='",l_hrct03,"' ",
#                  "    AND hrdm12='0' ",                 #add by zhangbo130911---已设置状态
#                  "    AND hrdm03='",p_hrdl01,"' ",
#                  "    AND hrad01<>'003' ",    #员工状态类型不是离职
#                  "    AND hrdm13='N' ",                 #add by zhangbo130912  
#                  "    AND hrdm04=A.hrct11 ",
#                  "    AND hrdm05=B.hrct11 ",
#                  "    AND A.hrct03='",l_hrct03,"' ",
#                  "    AND B.hrct03='",l_hrct03,"' ",
#                  "    AND A.hrct07<='",l_hrct07,"' ",
#                  "    AND B.hrct07>='",l_hrct07,"' ",
#                  #相同的薪资月,一个员工除了在本计算组,不可以再在其他计算组统计计算
#                  "    AND hrdm02 NOT IN (SELECT hrdxc02 FROM hrdxc_file ",     
#                  "                        WHERE hrdxc01='",p_hrdx01,"' AND hrdxc09<>'",p_hrdx04,"') ",   #mod by zhangbo130912
#                  #"  ORDER BY hrdm01 "
#                  #add by zhangbo130912---begin
#                  " UNION ALL ",
#                  " SELECT DISTINCT hrdm02,hrdm03 FROM hrdm_file,hrat_file,hrad_file,hrct_file ",
#                  "  WHERE hrdm02=hratid ",
#                  "    AND hrat19=hrad02 ",
#                  "    AND hrat03='",l_hrct03,"' ",
#                  "    AND hrdm12='0' ",                 #add by zhangbo130911---已设置状态
#                  "    AND hrdm03='",p_hrdl01,"' ",
#                  "    AND hrad01<>'003' ",    #员工状态类型不是离职
#                  "    AND hrdm13='Y' ",                 #add by zhangbo130912
#                  "    AND hrdm04=hrct11 ",
#                  "    AND hrct03='",l_hrct03,"' ",
#                  "    AND hrct07<='",l_hrct07,"' ",
#                  #相同的薪资月,一个员工除了在本计算组,不可以再在其他计算组统计计算
#                  "    AND hrdm02 NOT IN (SELECT hrdxc02 FROM hrdxc_file ",
#                  "                        WHERE hrdxc01='",p_hrdx01,"' AND hrdxc09<>'",p_hrdx04,"') "
#                  #add by zhangbo130912---end
                  
                  
        PREPARE i092_emp_pre FROM l_sql
        DECLARE i092_emp CURSOR FOR i092_emp_pre
        
        LET g_cnt=g_rec_b6+1
        IF cl_null(g_cnt) THEN LET g_cnt=1 END IF
        
        FOREACH i092_emp INTO g_emp[g_cnt].hrat01,g_emp[g_cnt].hrdm03
           let L_CHECK='N'
           SELECT hrat01 INTO g_emp[g_cnt].hrat01 FROM hrat_file
            WHERE hratid=g_emp[g_cnt].hrat01
           FOR l_i=1 TO g_rec_b6
              IF g_emp[l_i].hrat01=g_emp[g_cnt].hrat01 THEN
                 LET l_check='Y'
                 EXIT FOR
              END IF
           END FOR   	   	           
           IF l_check='N' THEN
              LET g_emp[g_cnt].chk='Y'
              SELECT hraa12 INTO g_emp[g_cnt].hrat03 FROM hrat_file,hraa_file
               WHERE hrat01=g_emp[g_cnt].hrat01 AND hrat03=hraa01
              SELECT hrat02 INTO g_emp[g_cnt].hrat02 FROM hrat_file
               WHERE hrat01=g_emp[g_cnt].hrat01
              SELECT hrao02 INTO g_emp[g_cnt].hrat04 FROM hrat_file,hrao_file
               WHERE hrat01=g_emp[g_cnt].hrat01 AND hrao01=hrat04
              SELECT hras04 INTO g_emp[g_cnt].hrat05 FROM hrat_file,hras_file
               WHERE hrat01=g_emp[g_cnt].hrat01 AND hras01=hrat05
              SELECT hrat25 INTO g_emp[g_cnt].hrat25 FROM hrat_file
               WHERE hrat01=g_emp[g_cnt].hrat01              
              LET g_cnt = g_cnt + 1
              LET g_count=g_count+1      #add by zhangbo130910
           ELSE
        #   	  CONTINUE FOREACH
           END IF	     

        END FOREACH
        CALL g_emp.deleteElement(g_cnt)
        MESSAGE ""
        LET g_rec_b6 = g_cnt-1 
        LET g_cnt = 0         
           
END FUNCTION
	
FUNCTION i092_lz_fill(p_hrdx01,p_hrdx04)
DEFINE l_sql     STRING
DEFINE p_hrdx01  LIKE   hrdx_file.hrdx01
DEFINE p_hrdx04  LIKE   hrdx_file.hrdx04
DEFINE l_lz      DYNAMIC ARRAY OF RECORD
         chk     LIKE   type_file.chr1,
         hrat01  LIKE   hrat_file.hrat01,
         hrat02  LIKE   hrat_file.hrat02,
         hrat03  LIKE   hraa_file.hraa12,
         hrat04  LIKE   hrao_file.hrao02,
         hrdm03  LIKE   hrdm_file.hrdm03,
         hrat19  LIKE   hrad_file.hrad03
                 END RECORD
DEFINE l_hrct03  LIKE   hrct_file.hrct03
DEFINE i,l_i,l_j LIKE   type_file.num5
DEFINE l_hrct07  LIKE   hrct_file.hrct07
DEFINE l_check   LIKE   type_file.chr1
#add by zhuzw 20150121 start
DEFINE l_wc STRING
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_hrdm02"
                 LET g_qryparam.state = "c"  
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 LET l_wc = g_qryparam.multiret
                 
                 
                 
                 
                 LET l_wc = cl_replace_str(l_wc,"|","','")    
#add by zhuzw 20150121 end                     
       #OPEN WINDOW i092_w2 WITH FORM "ghr/42f/ghri092_lz"
       #   ATTRIBUTE (STYLE = g_win_style CLIPPED)
       #
       #CALL cl_ui_init()
       #
       #CALL cl_set_combo_items("hrdm03",NULL,NULL)
       #
       ##薪资类别
       #CALL i092_get_hrdl01() RETURNING l_name,l_items
       #CALL cl_set_combo_items("hrdm03",l_name,l_items)          
#         #add by zhuzw 20150120 start
#       OPEN WINDOW i092_w2 WITH FORM "ghr/42f/ghri092_lz"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED)
#       
#        CALL cl_ui_init()                 
#         #add by zhuzw 20150120 end        
       SELECT hrct03 INTO l_hrct03 FROM hrct_file WHERE hrct11=p_hrdx01

       LET l_sql=" SELECT DISTINCT hrdm02 FROM hrdm_file,hrbh_file,hrat_file ",
                 "  WHERE hrdm02=hrbh01 ",
                 "    AND hrdm02=hratid ",
                 "    AND hrdm12='0' ",                            #add by zhangbo130911---已设置状态
#                 "    AND hrat03='",l_hrct03,"' ",
                 "    AND (hrbh09='N' OR hrbh09 IS NULL )",        #add by zhangbo130909
                 "    AND (hrbhconf='2' OR hrbhconf='3' )",        #add by zhangbo130909
                 "    AND  hrat01 IN('",l_wc,"')" #add by zhuzw 20150121
#20141230 add by yinbq for 取消已经计算员工不能再选择的控件，计算时，已经考虑重复选择员工的情况
#                 #相同的薪资月,一个员工除了在本计算组,不可以再在其他计算组统计计算
#                 "    AND hrdm02 NOT IN (SELECT hrdxc02 FROM hrdxc_file ",     
#                 "                        WHERE hrdxc01='",p_hrdx01,"' AND hrdxc09<>'",p_hrdx04,"') "
#20141230 add by yinbq for 取消已经计算员工不能再选择的控件，计算时，已经考虑重复选择员工的情况
                 #"  ORDER BY hrdm01 "
	     PREPARE i092_lz_pre FROM l_sql
	     DECLARE i092_lz CURSOR FOR i092_lz_pre
	     
	     LET i=1
	     CALL l_lz.clear()
	     
	     FOREACH i092_lz INTO l_lz[i].hrat01
	        LET l_lz[i].chk='N'
	        SELECT MAX(hrct07) INTO l_hrct07 FROM hrct_file,hrdm_file
	         WHERE hrct11=hrdm04
	           AND hrdm02=l_lz[i].hrat01
                   AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
	        SELECT hrdm03 INTO l_lz[i].hrdm03 FROM hrdm_file,hrct_file
	         WHERE hrdm02=l_lz[i].hrat01
                   AND hrdm12='0'                                   #add by zhangbo130911---已设置状态
	           AND hrdm04=hrct11
	           AND hrct07=l_hrct07
	        SELECT hrat01 INTO l_lz[i].hrat01 FROM hrat_file WHERE hratid=l_lz[i].hrat01
	        SELECT hrat02 INTO l_lz[i].hrat02 FROM hrat_file WHERE hrat01=l_lz[i].hrat01
	        SELECT hraa12 INTO l_lz[i].hrat03 FROM hrat_file,hraa_file
	         WHERE hrat01=l_lz[i].hrat01 AND hrat03=hraa01
	        SELECT hrao02 INTO l_lz[i].hrat04 FROM hrat_file,hrao_file
	         WHERE hrat01=l_lz[i].hrat01 AND hrat04=hrao01
	        SELECT hrad03 INTO l_lz[i].hrat19 FROM hrat_file,hrad_file
	         WHERE hrat01=l_lz[i].hrat01 AND hrat19=hrad02
	         
	        LET i=i+1
	        
	     END FOREACH
       CALL l_lz.deleteElement(i)
       MESSAGE ""
       LET i = i-1  
            
       IF i>0 THEN	   
          OPEN WINDOW i092_w2 WITH FORM "ghr/42f/ghri092_lz"
             ATTRIBUTE (STYLE = g_win_style CLIPPED)

          CALL cl_ui_init()

          CALL cl_set_combo_items("hrdm03",NULL,NULL)

          #薪资类别
          CALL i092_get_hrdl01() RETURNING l_name,l_items
          CALL cl_set_combo_items("hrdm03",l_name,l_items)
         
          INPUT ARRAY l_lz WITHOUT DEFAULTS FROM s_lz.*
             ATTRIBUTE(COUNT=i,MAXCOUNT=i,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=TRUE)
         ON ACTION ghri092_a        #全选
            FOR l_i=1 TO i
               LET l_lz[l_i].chk='Y'
            END FOR
            
         ON ACTION ghri092_c        #全弃
             FOR l_i=1 TO i
               LET l_lz[l_i].chk='N'
            END FOR	     
	     AFTER INPUT
                IF INT_FLAG THEN
                   EXIT INPUT
                END IF 
          	
          END INPUT
       
          IF INT_FLAG THEN
       	     LET INT_FLAG=0
             CLOSE WINDOW i092_w2
       	     RETURN
          END IF
       
          LET g_cnt=g_rec_b6+1
          IF cl_null(g_cnt) THEN LET g_cnt=1 END IF
       	
          FOR l_i=1 TO i
             IF l_lz[l_i].chk='Y' THEN
          	 LET l_check='N'
          	 FOR l_j=1 TO g_rec_b6
          	    IF g_emp[l_j].hrat01=l_lz[l_i].hrat01 THEN
          	    	 LET g_emp[l_j].chk='Y'
          	    	 LET l_check='Y'
          	    	 EXIT FOR
          	    END IF	 
          	 END FOR
          	 
          	 IF l_check='N' THEN
          	    LET g_emp[g_cnt].chk='Y'
          	    LET g_emp[g_cnt].hrat03=l_lz[l_i].hrat03
          	    LET g_emp[g_cnt].hrat01=l_lz[l_i].hrat01
          	    LET g_emp[g_cnt].hrat02=l_lz[l_i].hrat02
          	    LET g_emp[g_cnt].hrat04=l_lz[l_i].hrat04
          	    LET g_emp[g_cnt].hrdm03=l_lz[l_i].hrdm03
          	    SELECT hras04 INTO g_emp[g_cnt].hrat05 FROM hrat_file,hras_file
          	     WHERE hrat01=g_emp[g_cnt].hrat01 AND hrat05=hras01
          	    SELECT hrat25 INTO g_emp[g_cnt].hrat25 FROM hrat_file
                     WHERE hrat01=g_emp[g_cnt].hrat01
              
                    LET g_cnt = g_cnt + 1
                    LET g_count=g_count+1     #add by zhangbo130910
                 
          	 ELSE
          	     CONTINUE FOR
          	 END IF	  	       
             END IF     
          END FOR
       
          CALL g_emp.deleteElement(g_cnt)
          MESSAGE ""
          LET g_rec_b6 = g_cnt-1 
          LET g_cnt = 0
       ELSE
          CALL cl_err('无符合条件的离职未结清人员','!',1)
       END IF

       CLOSE WINDOW i092_w2
           		  	
END FUNCTION

FUNCTION i092_js(p_hrdx01,p_hrdx04)
DEFINE p_hrdx01  LIKE hrdx_file.hrdx01
DEFINE p_hrdx04  LIKE hrdx_file.hrdx04	
DEFINE l_sql     STRING
DEFINE l_sql1    STRING
DEFINE l_sql2    STRING 
DEFINE l_js_str  STRING   
DEFINE l_hrdl01	 LIKE  hrdl_file.hrdl01
DEFINE l_hrdl22  LIKE  hrdl_file.hrdl22
DEFINE tok       base.StringTokenizer
DEFINE i,l_i     LIKE  type_file.num5
DEFINE l_value   LIKE type_file.chr100
DEFINE l_str     STRING
DEFINE l_para    DYNAMIC ARRAY OF RECORD
         para    LIKE  hrdh_file.hrdh12
                 END RECORD
DEFINE l_hrat01  LIKE  hrat_file.hratid 
DEFINE l_hrdl11  LIKE  hrdl_file.hrdl11
DEFINE l_hrdl12  LIKE  hrdl_file.hrdl12
DEFINE l_hrdl13  LIKE  hrdl_file.hrdl13
DEFINE l_hrdl14  LIKE  hrdl_file.hrdl14
DEFINE l_hrdl15  LIKE  hrdl_file.hrdl15                
DEFINE l_hrdl16  LIKE  hrdl_file.hrdl16
DEFINE l_hrdl17  LIKE  hrdl_file.hrdl17
DEFINE l_hrdl18  LIKE  hrdl_file.hrdl18
DEFINE l_hrdl19  LIKE  hrdl_file.hrdl19
DEFINE l_hrdl20  LIKE  hrdl_file.hrdl20
DEFINE li_res    LIKE  hrdl_file.hrdl11
DEFINE l_hrdxb   RECORD LIKE hrdxb_file.*
DEFINE l_hrdxa   RECORD LIKE hrdxa_file.*
DEFINE l_hrdla02 LIKE  hrdla_file.hrdla02
DEFINE l_n       LIKE  type_file.num5
DEFINE l_hrdx15  LIKE  hrdx_file.hrdx15
DEFINE l_sum1    LIKE  hrdxa_file.hrdxa08
DEFINE l_sum2    LIKE  hrdxa_file.hrdxa08
DEFINE l_sum3    LIKE  hrdxa_file.hrdxa08
DEFINE l_hrdl07  LIKE  hrdl_file.hrdl07
DEFINE l_hrdl03  LIKE  hrdl_file.hrdl03
DEFINE l_dif     LIKE  hrdxa_file.hrdxa08
#add by zhangbo130910---begin
DEFINE l_jsx     DYNAMIC ARRAY OF RECORD
          hrdla03  LIKE  hrdla_file.hrdla03
                 END RECORD
#add by zhangbo130910---end 
DEFINE l_num     LIKE    type_file.num10     #add by zhangbo130913
DEFINE l_empno   LIKE    hrat_file.hrat01   #add by zhangbo130913
DEFINE l_empname LIKE    hrat_file.hrat02   #add by zhangbo130913
DEFINE l_msg     LIKE    type_file.chr1000  #add by zhangbo130913
DEFINE l_paraname   LIKE  hrdh_file.hrdh06  #add by zhangbo130913
#add by zhangbo130913---begin
DEFINE   li_k                    LIKE type_file.num5
DEFINE   li_i_r                  LIKE type_file.num5
DEFINE   lr_err    DYNAMIC ARRAY OF RECORD
            line    STRING,
            key1    STRING,
            err     STRING
                   END RECORD
#add by zhangbo130913---end

#add by zhangbo131111---begin
DEFINE l_sum1_Y,l_sum1_N      LIKE   hrdxa_file.hrdxa23
DEFINE l_sum2_Y,l_sum2_N      LIKE   hrdxa_file.hrdxa23
DEFINE l_sum3_Y,l_sum3_N      LIKE   hrdxa_file.hrdxa23
DEFINE l_hrdxa23              LIKE   hrdxa_file.hrdxa23
DEFINE l_hrdxa24              LIKE   hrdxa_file.hrdxa24
DEFINE l_hrdxa25              LIKE   hrdxa_file.hrdxa25
DEFINE l_hrdxa26              LIKE   hrdxa_file.hrdxa26
DEFINE l_hrdxa27              LIKE   hrdxa_file.hrdxa27
#add by zhangbo131111---end
DEFINE l_ta_hrdl01            LIKE hrdl_file.ta_hrdl01 #add by zhuzw 20150120
#add by zhuzw 20150122 start
DEFINE l_hrct01  LIKE hrct_file.hrct01
DEFINE l_hrct02  LIKE hrct_file.hrct02
DEFINE l_hrct11  LIKE hrct_file.hrct11
DEFINE l_hrdl06  LIKE hrdl_file.hrdl06
#add by zhuzw 20150122 end 
DEFINE l_ta_hrdl02            LIKE hrdl_file.ta_hrdl02 #add by zhuzw 20150425
#20150427 add by yinnq for 调整参数统计方法
DEFINE l_hrdh01 LIKE hrdh_file.hrdh01
DEFINE l_hrdh02 LIKE hrdh_file.hrdh02
DEFINE l_hrdh03 LIKE hrdh_file.hrdh03
#20150427 add by yinnq for 调整参数统计方法
       
 #      DELETE FROM hrdxc_file WHERE hrdxc01=p_hrdx01 AND hrdxc09=p_hrdx04
 #      DELETE FROM hrdxb_file WHERE hrdxb01=p_hrdx01 AND hrdxb11=p_hrdx04
 #      DELETE FROM hrdxa_file WHERE hrdxa01=p_hrdx01 AND hrdxa22=p_hrdx04

#DELETE FROM hrdxc_file WHERE NOT EXISTS (SELECT 1 FROM hrdx_file WHERE hrdxc09 = hrdx04)
#DELETE FROM hrdxb_file WHERE NOT EXISTS (SELECT 1 FROM hrdx_file WHERE hrdxb11 = hrdx04)
#DELETE FROM hrdxa_file WHERE NOT EXISTS (SELECT 1 FROM hrdx_file WHERE hrdxa22 = hrdx04)
       
       #add by zhangbo130913---begin       
       #SELECT COUNT(*) INTO l_num FROM emp_tmp WHERE 1=1
       #IF cl_null(l_num) THEN
       #   LET l_num=0
       #END IF
       #add by zhangbo130913---end       
 
       #首先找出共有几个薪资类别
       LET l_sql=" SELECT DISTINCT hrdm03 FROM emp_tmp WHERE 1=1 ORDER BY hrdm03"
       
       PREPARE i092_hrdl01_pre FROM l_sql
       DECLARE i092_hrdl01 CURSOR FOR i092_hrdl01_pre

#20141229 add by yinbq for 统计前先将员工上次计算的统计数据清空 
   DELETE FROM hrdxa_file WHERE EXISTS(SELECT 1 FROM emp_tmp WHERE hrat01 = hrdxa02) AND hrdxa01 = p_hrdx01
   DELETE FROM hrdxb_file WHERE EXISTS(SELECT 1 FROM emp_tmp WHERE hrat01 = hrdxb02) AND hrdxb01 = p_hrdx01
   DELETE FROM hrdxc_file WHERE EXISTS(SELECT 1 FROM emp_tmp WHERE hrat01 = hrdxc02) AND hrdxc01 = p_hrdx01
#20141229 add by yinbq for 统计前先将员工上次计算的统计数据清空 
       #CALL cl_progress_bar(l_num)     #add by zhangbo130913
    #20150427 add by yinnq for 创建临时表存储须要统计的参数
    DROP TABLE para_tmp
    CREATE TEMP TABLE para_tmp
    (hrdm03  VARCHAR(20),
    t_hrdh12 VARCHAR(20),
    t_hrdh01 VARCHAR(20),
    t_hrdh02 VARCHAR(20),
    t_hrdh03 VARCHAR(20)
     )
    #20150427 add by yinnq for 创建临时表存储须要统计的参数
       
       FOREACH i092_hrdl01 INTO l_hrdl01
          SELECT hrdl22 INTO l_hrdl22 FROM hrdl_file WHERE hrdl01=l_hrdl01
          LET l_str=l_hrdl22
          LET l_str=l_str.trim()
          LET tok = base.StringTokenizer.create(l_str,"|")
          LET i=0
          CALL l_para.clear()
          IF NOT cl_null(l_str) THEN
             WHILE tok.hasMoreTokens()
             	LET l_value=tok.nextToken()
             	LET i=i+1
                LET l_para[i].para=l_value
    #20150427 add by yinnq for 插入统计的参数临时表数据
             	LET l_sql="SELECT HRDH01, HRDH02, CASE WHEN LENGTH(HRDH12) = 11 AND HRDH02 = '002' THEN '000' ELSE HRDH03 END ",
                          " FROM HRDH_FILE WHERE hrdh12='",l_value,"'"
                PREPARE i092_para_pre FROM l_sql
                DECLARE i092_para_cs CURSOR FOR i092_para_pre
                FOREACH i092_para_cs INTO l_hrdh01,l_hrdh02,l_hrdh03
                END FOREACH
             	INSERT INTO para_tmp VALUES (l_hrdl01,l_value,l_hrdh01,l_hrdh02,l_hrdh03)
    #20150427 add by yinnq for 插入统计的参数临时表数据
             END WHILE   
          END IF
          	
          IF i>0 THEN
          	 #此类别需要的参数循环
                 SELECT COUNT(*) INTO l_num FROM emp_tmp WHERE hrdm03=l_hrdl01   #add by zhangbo130913
                 LET l_num=l_num*i                                               #add by zhangbo130913 
                 CALL cl_progress_bar(l_num)                                     #add by zhangbo130913 
          	 FOR l_i=1 TO i
          	    LET l_sql1=" SELECT hrat01 FROM emp_tmp WHERE hrdm03='",l_hrdl01,"' ",
          	               "  ORDER BY hrat01 "
          	    PREPARE i092_hrat01_pre FROM l_sql1
          	    DECLARE i092_hrat01 CURSOR FOR i092_hrat01_pre

          	    
          	    #此类别下的员工循环           
          	    FOREACH i092_hrat01 INTO l_hrat01
          	       #统计参数    
          	       CALL i092_get_para_val(l_para[l_i].para,l_hrat01,p_hrdx01,p_hrdx04)
                       #add by zhangbo130913---begin
                       SELECT hrdh06 INTO l_paraname FROM hrdh_file WHERE hrdh12=l_para[l_i].para
                       SELECT hrat01,hrat02 INTO l_empno,l_empname FROM hrat_file WHERE hratid=l_hrat01
                       LET l_msg="统计参数 ",l_empno," ",l_empname," ",l_paraname
                       CALL cl_progressing(l_msg)
                       #add by zhangbo130913---end
          	    END FOREACH 
                    
          	 END FOR
          END IF		   	
       END FOREACH

       #CALL cl_close_progress_bar()     #add by zhangbo130913
	     
             LET li_k=0      #add by zhangbo130913

	     #开始计算
	     LET l_sql=" SELECT hrat01,hrdm03 FROM emp_tmp WHERE 1=1 "
	     PREPARE i092_js_pre FROM l_sql
	     DECLARE i092_js CURSOR FOR i092_js_pre

             #add by zhangbo130913---begin
             SELECT COUNT(*) INTO l_num FROM emp_tmp WHERE 1=1
             IF cl_null(l_num) THEN
                LET l_num=0
             END IF
             #add by zhangbo130913---end  

             CALL cl_progress_bar(l_num)     #add by zhangbo130913
	     
	     FOREACH i092_js INTO l_hrat01,l_hrdl01

                #add by zhangbo130913---begin
                SELECT hrat01,hrat02 INTO l_empno,l_empname FROM hrat_file WHERE hratid=l_hrat01
                LET l_msg="计算薪资 ",l_empno," ",l_empname
                CALL cl_progressing(l_msg)
                #add by zhangbo130913---end
	        
	        #组出存储过程语句
	        SELECT hrdl11,hrdl12,hrdl13,hrdl14,hrdl15,hrdl16,hrdl17,hrdl18,hrdl19,hrdl20,ta_hrdl01,ta_hrdl02
	          INTO l_hrdl11,l_hrdl12,l_hrdl13,l_hrdl14,l_hrdl15,
	               l_hrdl16,l_hrdl17,l_hrdl18,l_hrdl19,l_hrdl20,l_ta_hrdl01,l_ta_hrdl02
	          FROM hrdl_file
	         WHERE hrdl01=l_hrdl01
	        LET l_js_str=l_hrdl11,l_hrdl12,l_hrdl13,l_hrdl14,l_hrdl15,l_hrdl16,l_hrdl17,l_hrdl18,l_hrdl19,l_hrdl20,l_ta_hrdl01,l_ta_hrdl02 
	        IF NOT cl_null(l_js_str) THEN 
	        	 #调用执行存储过程语句
             LET l_js_str=cl_replace_str(l_js_str,"@","")
             PREPARE js_salary from l_js_str
             EXECUTE js_salary
          
             PREPARE count_s FROM "call salary(?,?,?)"
             EXECUTE count_s USING l_hrat01 IN,p_hrdx01 IN,li_res OUT
          END IF

          #add by zhangbo130913---begin
          IF SQLCA.sqlcode THEN
             LET li_k=li_k+1
             LET lr_err[li_k].line=li_k
             LET lr_err[li_k].key1=l_empno
             LET lr_err[li_k].err=SQLCA.sqlerrd[2]
             CONTINUE FOREACH
          END IF          
          #add by zhangbo130913---end
          	
          LET l_str=li_res
          LET l_str=l_str.trim()
          LET l_str = cl_replace_str(l_str,",,",",0,")
          LET l_str = cl_replace_str(l_str,",,",",0,")
          LET tok = base.StringTokenizer.create(l_str,",") 
          LET i=1
          #add by zhangbo130910---begin
          LET l_sql="SELECT hrdla03 FROM hrdla_file WHERE hrdla01='",l_hrdl01,"' ORDER BY hrdla03"
          PREPARE i092_jsx_pre FROM l_sql
          DECLARE i092_jsx_cs CURSOR FOR i092_jsx_pre

          FOREACH i092_jsx_cs INTO l_jsx[i].hrdla03
             LET i=i+1
          END FOREACH
          
          CALL l_jsx.deleteElement(i) 
          LET i=0
          #add by zhangbo130910---end
          
          IF NOT cl_null(l_str) THEN
             WHILE tok.hasMoreTokens()
             	  INITIALIZE l_hrdxb.* TO NULL
             	  LET l_hrdxb.hrdxb01=p_hrdx01
             	  LET l_hrdxb.hrdxb02=l_hrat01
             	  LET l_hrdxb.hrdxb11=p_hrdx04
             	  LET l_hrdxb.hrdxb05=tok.nextToken()
             	  IF cl_null(l_hrdxb.hrdxb05) THEN
             	  	 LET l_hrdxb.hrdxb05=0
             	  END IF	 
             	  LET i=i+1
             	  LET l_hrdla02=''
                #mark by zhangbo130910---begin
                #SELECT hrdla02 INTO l_hrdla02 
                #  FROM (SELECT rownum xuhao,hrdla02 FROM hrdla_file WHERE hrdla01=l_hrdl01 ORDER BY hrdla03) 
                # WHERE xuhao=i
                #mark by zhangbo130910---end

                SELECT hrdla02 INTO l_hrdla02 FROM hrdla_file WHERE hrdla01=l_hrdl01           #add by zhangbo130910
                                                                AND hrdla03=l_jsx[i].hrdla03   #add by zhangbo130910
                IF NOT cl_null(l_hrdla02) THEN
                	 LET l_hrdxb.hrdxb03=l_hrdla02
                	 SELECT hrdk03,hrdk08,hrdk07,hrdk09,hrdk04,hrdk15
                	   INTO l_hrdxb.hrdxb04,l_hrdxb.hrdxb06,l_hrdxb.hrdxb07,
                	        l_hrdxb.hrdxb08,l_hrdxb.hrdxb09,l_hrdxb.hrdxb10
                	   FROM hrdk_file
                	  WHERE hrdk01=l_hrdxb.hrdxb03
                	  
                	 INSERT INTO hrdxb_file VALUES (l_hrdxb.*)
                	   
                END IF	    
             END WHILE

          END IF
          
          #判断是否有计算项计算结果
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hrdxb_file WHERE hrdxb01=p_hrdx01
                                                     AND hrdxb02=l_hrat01
                                                     AND hrdxb11=p_hrdx04
          IF l_n>0 THEN                                           
             LET l_hrdx15=''
             LET l_hrdl07=0	
             SELECT hrdx15 INTO l_hrdx15 FROM hrdx_file WHERE hrdx01=p_hrdx01 AND hrdx04=p_hrdx04
             SELECT hrdl07,hrdl03 INTO l_hrdl07,l_hrdl03 FROM hrdl_file WHERE hrdl01=l_hrdl01
             IF cl_null(l_hrdl07) THEN LET l_hrdl07=0 END IF 
             LET l_hrdxa.hrdxa01=p_hrdx01
             LET l_hrdxa.hrdxa02=l_hrat01
             SELECT hrat02,hrat04,hrat05,hrat03 
               INTO l_hrdxa.hrdxa03,l_hrdxa.hrdxa04,
                    l_hrdxa.hrdxa05,l_hrdxa.hrdxa06
               FROM hrat_file
              WHERE hratid=l_hrat01
             LET l_hrdxa.hrdxa07=1
             SELECT SUM(hrdxb05) INTO l_sum1_N FROM hrdxb_file
              WHERE hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04 AND hrdxb09='001'    #计税薪资项SUM
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项
             SELECT SUM(hrdxb05) INTO l_sum2_N FROM hrdxb_file
              WHERE hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04 AND hrdxb09='002'    #去税薪资项SUM
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项
             SELECT SUM(hrdxb05) INTO l_sum3_N FROM hrdxb_file
              WHERE hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04 AND hrdxb09='003'    #实付薪资项SUM     
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项

             #add by zhangbo131111----begin
             SELECT SUM(hrdxb05) INTO l_sum1_Y FROM hrdxb_file
              WHERE hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04 AND hrdxb09='001'    #计税薪资项SUM
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             SELECT SUM(hrdxb05) INTO l_sum2_Y FROM hrdxb_file
              WHERE hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04 AND hrdxb09='002'    #去税薪资项SUM
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             SELECT SUM(hrdxb05) INTO l_sum3_Y FROM hrdxb_file
              WHERE hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04 AND hrdxb09='003'    #实付薪资项SUM
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             #add by zhangbo131111----end

             #add by zhangbo130911---begin
             SELECT SUM(hrdxb05) INTO l_hrdxa.hrdxa23 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='001'       #固定收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa.hrdxa24 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='002'       #浮动收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa.hrdxa25 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='003'       #奖金收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa.hrdxa26 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='004'       #福利收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa.hrdxa27 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='005'       #其他收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='N'           #add by zhangbo131111---计入薪资,非扣减项

             #add by zhangbo131111---begin
             SELECT SUM(hrdxb05) INTO l_hrdxa23 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='001'       #固定收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa24 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='002'       #浮动收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa25 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='003'       #奖金收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa26 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='004'       #福利收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             SELECT SUM(hrdxb05) INTO l_hrdxa27 FROM hrdxb_file,hrdk_file
              WHERE hrdk01=hrdxb03 AND hrdk21='005'       #其他收入
                AND hrdxb01=p_hrdx01 AND hrdxb02=l_hrat01
                AND hrdxb11=p_hrdx04
                AND hrdxb06='Y' AND hrdxb07='Y'           #add by zhangbo131111---计入薪资,扣减项
             #add by zhangbo131111---end

             IF cl_null(l_hrdxa.hrdxa23) THEN LET l_hrdxa.hrdxa23=0 END IF
             IF cl_null(l_hrdxa.hrdxa24) THEN LET l_hrdxa.hrdxa24=0 END IF
             IF cl_null(l_hrdxa.hrdxa25) THEN LET l_hrdxa.hrdxa25=0 END IF
             IF cl_null(l_hrdxa.hrdxa26) THEN LET l_hrdxa.hrdxa26=0 END IF
             IF cl_null(l_hrdxa.hrdxa27) THEN LET l_hrdxa.hrdxa27=0 END IF 

             #add by zhangbo131111----begin
             IF cl_null(l_hrdxa23) THEN LET l_hrdxa23=0 END IF
             IF cl_null(l_hrdxa24) THEN LET l_hrdxa24=0 END IF
             IF cl_null(l_hrdxa25) THEN LET l_hrdxa25=0 END IF
             IF cl_null(l_hrdxa26) THEN LET l_hrdxa26=0 END IF
             IF cl_null(l_hrdxa27) THEN LET l_hrdxa27=0 END IF
             LET l_hrdxa.hrdxa23=l_hrdxa.hrdxa23-l_hrdxa23
             LET l_hrdxa.hrdxa24=l_hrdxa.hrdxa24-l_hrdxa24
             LET l_hrdxa.hrdxa25=l_hrdxa.hrdxa25-l_hrdxa25
             LET l_hrdxa.hrdxa26=l_hrdxa.hrdxa26-l_hrdxa26
             LET l_hrdxa.hrdxa27=l_hrdxa.hrdxa27-l_hrdxa27 
             #add by zhangbo131111----end 

             #add by zhangbo130911---end

 
             IF cl_null(l_sum1_Y) THEN LET l_sum1_Y=0 END IF     #mod by zhangbo131111
             IF cl_null(l_sum2_Y) THEN LET l_sum2_Y=0 END IF     #mod by zhangbo131111
             IF cl_null(l_sum3_Y) THEN LET l_sum3_Y=0 END IF	 #mod by zhangbo131111

             #add by zhangbo131111---begin
             IF cl_null(l_sum1_N) THEN LET l_sum1_N=0 END IF
             IF cl_null(l_sum2_N) THEN LET l_sum2_N=0 END IF
             IF cl_null(l_sum3_N) THEN LET l_sum3_N=0 END IF
#add by zhuzw 20150122 start
             SELECT hrct01,hrct02 INTO l_hrct01,l_hrct02 FROM hrct_file 
              WHERE hrct11= l_hrdxa.hrdxa01
              IF l_hrct02 = 1 THEN 
                 LET l_hrct01 = l_hrct01 -1 
                 LET l_hrct02 = 12
              ELSE 
              	  LET l_hrct02 = l_hrct02 -1    
              END IF 
             SELECT hrct11 INTO l_hrct11 FROM hrct_file 
              WHERE hrct01 = l_hrct01
                AND hrct02 = l_hrct02
             SELECT hrdxa19 INTO l_hrdxa.hrdxa18 FROM hrdxa_file 
              WHERE hrdxa02 =  l_hrdxa.hrdxa02
                AND hrdxa01 =  l_hrct11
             IF cl_null(l_hrdxa.hrdxa18) THEN 
                LET l_hrdxa.hrdxa18  = 0
             END IF 
#add by zhuzw 20150122 end  
             LET l_sum1=l_sum1_N-l_sum1_Y + l_hrdxa.hrdxa18
             LET l_sum2=l_sum2_N-l_sum2_Y
             LET l_sum3=l_sum3_N-l_sum3_Y
             #add by zhangbo131111---end
 
             LET l_hrdxa.hrdxa08 =l_sum1
             LET l_hrdxa.hrdxa09=l_sum1-l_sum2
             LET l_hrdxa.hrdxa10=0
             LET l_hrdxa.hrdxa11=0
             LET l_hrdxa.hrdxa12=0
             IF l_hrdx15='002' THEN
             	  IF l_hrdxa.hrdxa09>l_hrdl07 THEN
             	     LET l_dif=l_hrdxa.hrdxa09-l_hrdl07
             	     SELECT hrcu11,hrcu10 INTO l_hrdxa.hrdxa10,l_hrdxa.hrdxa11
             	       FROM hrcu_file
             	      WHERE hrcu01=l_hrdl03
             	        AND hrcu06<l_dif 
             	        AND hrcu07>=l_dif
             	     IF cl_null(l_hrdxa.hrdxa10) THEN LET l_hrdxa.hrdxa10=0 END IF
             	     IF cl_null(l_hrdxa.hrdxa11) THEN LET l_hrdxa.hrdxa11=0 END IF 
             	     LET l_hrdxa.hrdxa12=(l_dif*l_hrdxa.hrdxa11/100)-l_hrdxa.hrdxa10             	        	
                     IF l_hrdxa.hrdxa12 < 1 THEN LET l_hrdxa.hrdxa12=0 END IF
             	  END IF	  
             END IF
             
             LET l_hrdxa.hrdxa13=l_hrdxa.hrdxa09-l_hrdxa.hrdxa12
             LET l_hrdxa.hrdxa14=l_hrdxa.hrdxa13+l_sum3
             LET l_hrdxa.hrdxa15=0
             LET l_hrdxa.hrdxa16=0
             LET l_hrdxa.hrdxa17=0
             LET l_hrdxa.hrdxa18=0
             LET l_hrdxa.hrdxa19=0
             LET l_hrdxa.hrdxa20=0
             LET l_hrdxa.hrdxa21=0
             LET l_hrdxa.hrdxa22=p_hrdx04
             #add by zhuzw 20150121 start
             IF l_hrdxa.hrdxa14 < 0 THEN 
                LET l_hrdxa.hrdxa19 = l_hrdxa.hrdxa14
             ELSE 
             	  SELECT hrdl06 INTO l_hrdl06 FROM hrdl_file,hrdm_file 
             	   WHERE hrdl01 = hrdm03 
             	     AND hrdm02 = l_hrdxa.hrdxa02  
             	  IF l_hrdl06 = '001' THEN  #不扣零
                   LET l_hrdxa.hrdxa19=0  
             	  END IF    
             	  IF l_hrdl06 = '002' THEN  #扣元至十元
             	      SELECT mod(l_hrdxa.hrdxa14,10) INTO l_hrdxa.hrdxa19 FROM  dual 
             	      LET l_hrdxa.hrdxa14 = l_hrdxa.hrdxa14 - l_hrdxa.hrdxa19 
             	  END IF  
             	  IF l_hrdl06 = '003' THEN  #扣角至元
             	      SELECT mod(l_hrdxa.hrdxa14,1) INTO l_hrdxa.hrdxa19 FROM  dual 
             	      LET l_hrdxa.hrdxa14 = l_hrdxa.hrdxa14 - l_hrdxa.hrdxa19 
             	  END IF  
             	  IF l_hrdl06 = '004' THEN  #扣分至角
             	      SELECT mod(l_hrdxa.hrdxa14,0.1) INTO l_hrdxa.hrdxa19 FROM  dual 
             	      LET l_hrdxa.hrdxa14 = l_hrdxa.hrdxa14 - l_hrdxa.hrdxa19 
             	  END IF  
             	  IF l_hrdl06 = '005' THEN  #舍弃角分
             	      SELECT l_hrdxa.hrdxa14 - mod(l_hrdxa.hrdxa14,1) INTO l_hrdxa.hrdxa14 FROM  dual 
                    LET l_hrdxa.hrdxa19=0 
             	  END IF  
             END IF 

             IF cl_null(l_hrdxa.hrdxa19) THEN 
                LET l_hrdxa.hrdxa19  = 0
             END IF 
             #add by zhuzw 20150121 end 

             INSERT INTO hrdxa_file VALUES (l_hrdxa.*)		 
             		               
          END IF
          	   	   	  	      
	     END FOREACH

             #add by zhangbo130913---begin
             IF lr_err.getLength() > 0 THEN
                 CALL cl_show_array(base.TypeInfo.create(lr_err),cl_getmsg("lib-314",g_lang),"序号|工号|错误描述")
             END IF
             #add by zhangbo130913---end 
	     
	     LET l_n=0
	     SELECT COUNT(*) INTO l_n FROM hrdxa_file WHERE hrdxa01=p_hrdx01 AND hrdxa22=p_hrdx04
	     IF l_n>0 THEN
	     	  CALL cl_err('计算完成','!',1)
	     ELSE
	     	  CALL cl_err('无计算数据','!',1)
	     END IF	  	  
	     	     	     
END FUNCTION
	
FUNCTION i092_get_para_val(p_para,p_hrat01,p_hrdx01,p_hrdx04)
DEFINE p_para    LIKE   hrdh_file.hrdh12
DEFINE p_hrat01  LIKE   hrat_file.hratid
DEFINE p_hrdx01  LIKE   hrdx_file.hrdx01
DEFINE p_hrdx04  LIKE   hrdx_file.hrdx04
DEFINE l_hrdh01  LIKE   hrdh_file.hrdh01
DEFINE l_hrdh02  LIKE   hrdh_file.hrdh02
DEFINE l_hrdh03  LIKE   hrdh_file.hrdh03
DEFINE l_hrdh06  LIKE   hrdh_file.hrdh06
DEFINE l_hrdxc   RECORD LIKE hrdxc_file.*

       SELECT hrdh01,hrdh02,hrdh03,hrdh06 
         INTO l_hrdh01,l_hrdh02,l_hrdh03,l_hrdh06 
         FROM hrdh_file
        WHERE hrdh12=p_para
        
       LET l_hrdxc.hrdxc01=p_hrdx01
       LET l_hrdxc.hrdxc02=p_hrat01
       LET l_hrdxc.hrdxc03=l_hrdh01
       LET l_hrdxc.hrdxc04=l_hrdh06
       LET l_hrdxc.hrdxc08=p_para
       LET l_hrdxc.hrdxc09=p_hrdx04 
       
       CASE l_hrdh02
       	  #人事类
       	  WHEN '001' CALL i092_get_val_001(p_para,p_hrat01) 
       	                     RETURNING l_hrdxc.hrdxc05
       	  #薪资福利类                   
       	  WHEN '002' CALL i092_get_val_002(p_para,p_hrat01,p_hrdx01,l_hrdh01,l_hrdh03)
       	                     RETURNING l_hrdxc.hrdxc05
       	  #奖惩类
       	  WHEN '005' CALL i092_get_val_005(p_para,p_hrat01,p_hrdx01)
       	                     RETURNING l_hrdxc.hrdxc05
       	  #考勤类
       	  WHEN '003' CALL i092_get_val_003(p_para,p_hrat01,p_hrdx01)
       	                     RETURNING l_hrdxc.hrdxc05                                       
      
       END CASE
       	
       IF cl_null(l_hrdxc.hrdxc05) THEN LET l_hrdxc.hrdxc05=0 END IF	
       	
       INSERT INTO hrdxc_file VALUES (l_hrdxc.*)
      
END FUNCTION 
	
FUNCTION i092_get_val_001(p_para,p_hrat01)
#DEFINE p_para      LIKE   hrdh_file.hrdh12          #mark by zhangbo131115
DEFINE p_para       LIKE   type_file.chr100        #add by zhangbo131115 
DEFINE p_hrat01 	 LIKE   hrat_file.hratid
DEFINE l_sql       STRING
DEFINE l_hrdxc05   LIKE   hrdxc_file.hrdxc05
DEFINE l_flag      LIKE   type_file.chr10         #add by zhangbo131115

       #add by zhangbo131115---begin
       SELECT data_type INTO l_flag FROM user_tab_columns WHERE table_name = 'HRAT_FILE' 
                                                            AND LOWER(column_name)=p_para
       IF l_flag='DATE' THEN
          LET p_para="TO_CHAR(",p_para,",'yyyymmdd')"
       END IF    
       #add by zhangbo131115---end

       LET l_sql=" SELECT ",p_para," FROM hrat_file WHERE hratid='",p_hrat01,"'"
       PREPARE i092_get_val_001 FROM l_sql
       EXECUTE i092_get_val_001 INTO l_hrdxc05
       
       
       RETURN l_hrdxc05
       
END FUNCTION
	
FUNCTION i092_get_val_002(p_para,p_hrat01,p_hrdx01,p_hrdh01,p_hrdh03)	
DEFINE p_para      LIKE  hrdh_file.hrdh12
DEFINE p_hrat01 	 LIKE  hrat_file.hratid
DEFINE p_hrdx01    LIKE  hrdx_file.hrdx01
DEFINE p_hrdh01    LIKE  hrdh_file.hrdh01
DEFINE p_hrdh03    LIKE  hrdh_file.hrdh03
DEFINE l_hrct04    LIKE  hrct_file.hrct04
DEFINE l_hrct05    LIKE  hrct_file.hrct05
DEFINE l_hrdxc05   LIKE  hrdxc_file.hrdxc05
#add by zhangbo130905---begin
DEFINE l_flag      LIKE   type_file.chr10
DEFINE l_length    LIKE   type_file.num5
DEFINE l_hrdpa02   LIKE   hrdpa_file.hrdpa02
DEFINE l_hrdpc02   LIKE   hrdpc_file.hrdpc02
DEFINE l_hrda02    LIKE   hrda_file.hrda02
DEFINE l_hrct07_b  LIKE   hrct_file.hrct07
DEFINE l_hrct08_b  LIKE   hrct_file.hrct08
DEFINE l_hrct07_e  LIKE   hrct_file.hrct07
DEFINE l_hrct08_e  LIKE   hrct_file.hrct08
#add by zhangbo130905---end
DEFINE l_flag1     LIKE   type_file.chr10        #add by zhangbo131112
DEFINE l_hrdw02    LIKE   hrdw_file.hrdw02       #add by zhangbo131112

       CASE p_hrdh03
          #add by zhangbo130905---begin
          WHEN '001'
       	     LET l_length=LENGTH(p_para)
             LET l_flag=p_para[1,4]
             CASE l_flag
                WHEN 'hrcy' 
                   LET l_hrdpa02=p_para[5,l_length]
                   SELECT hrct07,hrct08 INTO l_hrct07_b,l_hrct08_b
                     FROM hrct_file
                    WHERE hrct11=p_hrdx01
                   SELECT hrdpa05 INTO l_hrdxc05 FROM hrdpa_file,hrdp_file 
             	    WHERE hrdp01=hrdpa01
       	              AND hrdp04=p_hrat01
       	              AND hrdpa02=l_hrdpa02
                      AND hrdp09='003' 
                      #AND hrdpa06 BETWEEN l_hrct07_b AND l_hrct08_b     #mark by zhangbo130909
                      #AND hrdpa07 BETWEEN l_hrct07_b AND l_hrct08_b     #mark by zhangbo130909
                      #AND l_hrct07_b BETWEEN hrdpa06 AND hrdpa07         #add by zhangbo130909
                      #AND l_hrct08_b BETWEEN hrdpa06 AND hrdpa07         #add by zhangbo130909
                      AND hrdpa07>=l_hrct07_b         #add by yinbq20140409
                      AND hrdpa06<=l_hrct08_b         #add by yinbq20140409
                      order by hrdpa07 desc
                WHEN 'hrde'        
                   LET l_hrdpc02=p_para[5,l_length]
                   SELECT hrct07,hrct08 INTO l_hrct07_b,l_hrct08_b
                     FROM hrct_file
                    WHERE hrct11=p_hrdx01
#add by yinbq 20141126 for 调整取值，从原来的取hrdpc05到取hrde06
                   SELECT hrde06 INTO l_hrdxc05 FROM hrdpc_file,hrdp_file,hrde_file
                    WHERE hrdp01=hrdpc01 AND hrde01=hrdpc02 AND hrde03=hrdpc03 AND hrde05=hrdpc04
#add by yinbq 20141126 for 调整取值，从原来的取hrdpc05到取hrde06
                      AND hrdp04=p_hrat01
                      AND hrdpc02=l_hrdpc02  
                      AND hrdp09='003'     
                      #AND hrdpc06 BETWEEN l_hrct07_b AND l_hrct08_b     #mark by zhangbo130909
                      #AND hrdpc07 BETWEEN l_hrct07_b AND l_hrct08_b     #mark by zhangbo130909
                      #AND hrdpc07>=l_hrct07_b BETWEEN hrdpc06 AND hrdpc07         #add by zhangbo130909
                      #AND hrdpc06<=l_hrct08_b BETWEEN hrdpc06 AND hrdpc07         #add by zhangbo130909
                      AND hrdpc07>=l_hrct07_b         #add by yinbq20140409
                      AND hrdpc06<=l_hrct08_b         #add by yinbq20140409
                      order by hrdpc07 desc
                WHEN 'hrcz'
                   LET l_hrda02=p_para[5,l_length]
                   SELECT hrct07 INTO l_hrct07_b 
                     FROM hrct_file
                    WHERE hrct11=p_hrdx01
                    
                   SELECT hrda05 INTO l_hrdxc05 FROM hrda_file,hrct_file A,hrct_file B
                    WHERE hrda01=p_hrat01
                      AND hrda02=l_hrda02 
                      AND hrda03=A.hrct11
                      AND hrda04=B.hrct11
                      AND l_hrct07_b BETWEEN A.hrct07 AND B.hrct07

                 #add by zhangbo131112---begin
                 WHEN 'hrds'
                    LET l_flag1=p_para[5,8]
                    LET l_hrdw02=p_para[9,l_length]
                    CASE l_flag1
                       WHEN 'GRJK'
                          SELECT hrdw04 INTO l_hrdxc05 FROM hrdw_file
                           WHERE hrdw01=p_hrat01
                             AND hrdw02=l_hrdw02
                             AND hrdw03=p_hrdx01
                       WHEN 'GSJK'
                          SELECT hrdw05 INTO l_hrdxc05 FROM hrdw_file
                           WHERE hrdw01=p_hrat01
                             AND hrdw02=l_hrdw02
                             AND hrdw03=p_hrdx01
                       WHEN 'GRBJ'
                          SELECT hrdw06 INTO l_hrdxc05 FROM hrdw_file
                           WHERE hrdw01=p_hrat01
                             AND hrdw02=l_hrdw02
                             AND hrdw03=p_hrdx01
                       WHEN 'GSBJ'
                          SELECT hrdw07 INTO l_hrdxc05 FROM hrdw_file
                           WHERE hrdw01=p_hrat01
                             AND hrdw02=l_hrdw02
                             AND hrdw03=p_hrdx01
                    END CASE
                     
                 #add by zhangbo131112---end 

             END CASE  
          #add by zhangbo130905---end

       	  WHEN '002' 
       	     SELECT hrct04,hrct05 INTO l_hrct04,l_hrct05
       	       FROM hrct_file 
       	      WHERE hrct11=p_hrdx01
       	     SELECT hrdr07 INTO l_hrdxc05 FROM hrdr_file
       	      WHERE hrdr02=p_hrat01
       	        AND hrdr06=p_hrdh01
       	        AND hrdr03=l_hrct04
       	        AND hrdr04=l_hrct05
       	  WHEN '003'
       	     SELECT hrdh08 INTO l_hrdxc05 FROM hrdh_file
       	      WHERE hrdh01=p_hrdh01       	  
       	  WHEN '004'
                   SELECT hrct07,hrct08 INTO l_hrct07_b,l_hrct08_b
                     FROM hrct_file
                    WHERE hrct11=p_hrdx01
       	     SELECT hrdpb03 INTO l_hrdxc05 FROM hrdp_file,hrdpb_file       #mod by zhangbo131111---hrbpb--->hrdpb
       	      WHERE hrdp01=hrdpb01
       	        AND hrdp04=p_hrat01
       	        AND hrdpb02=p_hrdh01
       	        AND hrdpb05 >= l_hrct07_b
       	        #AND rownum=1      #markby yinbq 20140409
       	        order by hrdpb05 desc #addby yinbq 20140409
       END CASE
     	
       RETURN  l_hrdxc05
     
END FUNCTION     	  	                                    	  	                     
       	   				
FUNCTION i092_get_val_005(p_para,p_hrat01,p_hrdx01)
DEFINE p_para      LIKE   hrdh_file.hrdh12
DEFINE p_hrat01    LIKE   hrat_file.hratid
DEFINE p_hrdx01    LIKE   hrdx_file.hrdx01
DEFINE l_flag      LIKE   type_file.chr10
DEFINE l_length    LIKE   type_file.num5
DEFINE l_hrdxc05   LIKE   hrdxc_file.hrdxc05
DEFINE l_hrbb03    LIKE   hrbb_file.hrbb03
       
       LET l_length=LENGTH(p_para)
       LET l_flag=p_para[1,6]
       LET l_hrbb03=p_para[7,l_length]       
       CASE l_flag
       	  WHEN 'hrbbLJ'
       	     SELECT hrbb12 INTO l_hrdxc05 FROM hrbb_file 
       	      WHERE hrbb01=p_hrat01
       	        AND hrbb08=p_hrdx01
       	        AND hrbb03=l_hrbb03
       	  WHEN 'hrbbLC'
       	     SELECT hrbb04 INTO l_hrdxc05 FROM hrbb_file 
       	      WHERE hrbb01=p_hrat01
       	        AND hrbb08=p_hrdx01
       	        AND hrbb03=l_hrbb03
       END CASE
       	
       RETURN l_hrdxc05		              
       							 
END FUNCTION
	
FUNCTION i092_get_val_003(p_para,p_hrat01,p_hrdx01)
DEFINE p_para      LIKE   hrdh_file.hrdh12
DEFINE p_hrat01    LIKE   hrat_file.hratid
DEFINE p_hrdx01    LIKE   hrdx_file.hrdx01
DEFINE l_flag      LIKE   type_file.chr10
DEFINE l_length    LIKE   type_file.num5
DEFINE l_hrdxc05   LIKE   hrdxc_file.hrdxc05
DEFINE l_hrcja04   LIKE   hrcja_file.hrcja04
DEFINE l_hrct04    LIKE   hrct_file.hrct05
DEFINE l_hrct05    LIKE   hrct_file.hrct05

       SELECT hrct04,hrct05 INTO l_hrct04,l_hrct05 
         FROM hrct_file
        WHERE hrct11=p_hrdx01
       LET l_length=LENGTH(p_para)
       LET l_flag=p_para[1,7]
       LET l_hrcja04=p_para[8,l_length]
       
       CASE l_flag
       	  WHEN 'hrcjaLC'
       	     SELECT hrcja05 INTO l_hrdxc05 FROM hrcj_file,hrcja_file,hrbl_file
       	      WHERE hrcja01=hrcj01
       	        AND hrcj03=hrbl02
       	        AND hrcja03=p_hrat01
       	        AND hrcja04=l_hrcja04
       	        AND hrbl04=l_hrct04
       	        AND hrbl05=l_hrct05
       	  WHEN 'hrcjaLF'
       	     SELECT hrcja08 INTO l_hrdxc05 FROM hrcj_file,hrcja_file,hrbl_file
       	      WHERE hrcja01=hrcj01
       	        AND hrcj03=hrbl02
       	        AND hrcja03=p_hrat01
       	        AND hrcja04=l_hrcja04
       	        AND hrbl04=l_hrct04
       	        AND hrbl05=l_hrct05
       	  WHEN 'hrcjaLS'
       	     SELECT hrcja07 INTO l_hrdxc05 FROM hrcj_file,hrcja_file,hrbl_file
       	      WHERE hrcja01=hrcj01
       	        AND hrcj03=hrbl02
       	        AND hrcja03=p_hrat01
       	        AND hrcja04=l_hrcja04
       	        AND hrbl04=l_hrct04
       	        AND hrbl05=l_hrct05 
       	  WHEN 'hrcjaLT'
       	     SELECT hrcja06 INTO l_hrdxc05 FROM hrcj_file,hrcja_file,hrbl_file
       	      WHERE hrcja01=hrcj01
       	        AND hrcj03=hrbl02
       	        AND hrcja03=p_hrat01
       	        AND hrcja04=l_hrcja04
       	        AND hrbl04=l_hrct04
       	        AND hrbl05=l_hrct05                    
            
       END CASE
       	
       RETURN l_hrdxc05	
	
END FUNCTION				  	
   		    		          

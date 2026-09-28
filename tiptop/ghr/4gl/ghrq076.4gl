# Prog. Version..: '5.10.04-08.10.22(00000)'     #
#
# Pattern name...: ghrq076.4gl
# Descriptions...: 
# Date & Author..: 05/07/13 by zhangbo

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sql         STRING,                      
       g_wc1         STRING,                     
       g_wc2         STRING,
       g_wc3         STRING,
       g_wc4         STRING,
       g_wc5         STRING,
       g_wc6         STRING
DEFINE g_hrdh_1      DYNAMIC ARRAY OF RECORD
         hrdh02      LIKE   hrdh_file.hrdh02,
         hrdh01      LIKE   hrdh_file.hrdh01,
         hrdh06      LIKE   hrdh_file.hrdh06,
         hrdh03      LIKE   hrdh_file.hrdh03,
         hrdh08      LIKE   hrdh_file.hrdh08,
         hrdh07      LIKE   hraa_file.hraa12,
         hrdh11      LIKE   hrdh_file.hrdh11
                     END RECORD,
       g_rec_b1      LIKE type_file.num5,
       l_ac1         LIKE type_file.num5
DEFINE g_hrdh_2      DYNAMIC ARRAY OF RECORD
         hrdh02      LIKE   hrdh_file.hrdh02,
         hrdh01      LIKE   hrdh_file.hrdh01,
         hrdh06      LIKE   hrdh_file.hrdh06,
         hrdh03      LIKE   hrdh_file.hrdh03,
         hrdh07      LIKE   hraa_file.hraa12,
         hrdh11      LIKE   hrdh_file.hrdh11
                     END RECORD,
       g_rec_b2      LIKE type_file.num5,
       l_ac2         LIKE type_file.num5
DEFINE g_hrdh_3      DYNAMIC ARRAY OF RECORD
         hrdh02      LIKE   hrdh_file.hrdh02,
         hrdh01      LIKE   hrdh_file.hrdh01,
         hrdh06      LIKE   hrdh_file.hrdh06,
         hrdh07      LIKE   hraa_file.hraa12,
         hrdh11      LIKE   hrdh_file.hrdh11
                     END RECORD,
       g_rec_b3      LIKE type_file.num5,
       l_ac3         LIKE type_file.num5       
DEFINE g_hrdh_4      DYNAMIC ARRAY OF RECORD
         hrdh02      LIKE   hrdh_file.hrdh02,
         hrdh01      LIKE   hrdh_file.hrdh01,
         hrdh06      LIKE   hrdh_file.hrdh06,
         hrdh07      LIKE   hraa_file.hraa12,
         hrdh11      LIKE   hrdh_file.hrdh11
                     END RECORD,
       g_rec_b4      LIKE type_file.num5,
       l_ac4         LIKE type_file.num5
DEFINE g_hrdh_5      DYNAMIC ARRAY OF RECORD
         hrdh02      LIKE   hrdh_file.hrdh02,
         hrdh01      LIKE   hrdh_file.hrdh01,
         hrdh06      LIKE   hrdh_file.hrdh06,
         hrdh07      LIKE   hraa_file.hraa12,
         hrdh11      LIKE   hrdh_file.hrdh11
                     END RECORD,
       g_rec_b5      LIKE type_file.num5,
       l_ac5         LIKE type_file.num5
DEFINE g_hrdh_6      DYNAMIC ARRAY OF RECORD
         hrdh02      LIKE   hrdh_file.hrdh02,
         hrdh01      LIKE   hrdh_file.hrdh01,
         hrdh06      LIKE   hrdh_file.hrdh06,
         hrdh07      LIKE   hraa_file.hraa12,
         hrdh11      LIKE   hrdh_file.hrdh11
                     END RECORD,
       g_rec_b6      LIKE type_file.num5,
       l_ac6         LIKE type_file.num5                                          
DEFINE g_flag        LIKE type_file.chr10
DEFINE g_cnt         LIKE type_file.num10      
DEFINE g_i           LIKE type_file.num5 
DEFINE g_row_count  LIKE type_file.num5       
DEFINE g_curs_index LIKE type_file.num5 

MAIN
DEFINE l_name   STRING
DEFINE l_items  STRING
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
 
   OPEN WINDOW q076_w WITH FORM "ghr/42f/ghrq076"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_set_combo_items("hrdh02_1",NULL,NULL)
   CALL cl_set_combo_items("hrdh02_2",NULL,NULL)
   CALL cl_set_combo_items("hrdh02_3",NULL,NULL)
   CALL cl_set_combo_items("hrdh02_4",NULL,NULL)
   CALL cl_set_combo_items("hrdh02_5",NULL,NULL)
   CALL cl_set_combo_items("hrdh02_6",NULL,NULL)
   CALL cl_set_combo_items("hrdh03_1",NULL,NULL)
   CALL cl_set_combo_items("hrdh03_2",NULL,NULL)
   #参数类别
   CALL q076_get_items('605') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdh02_1",l_name,l_items)
   CALL cl_set_combo_items("hrdh02_2",l_name,l_items)
   CALL cl_set_combo_items("hrdh02_3",l_name,l_items)
   CALL cl_set_combo_items("hrdh02_4",l_name,l_items)
   CALL cl_set_combo_items("hrdh02_5",l_name,l_items)
   CALL cl_set_combo_items("hrdh02_6",l_name,l_items)
   
   #薪资参数类型
   CALL q076_get_items('606') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdh03_1",l_name,l_items)
   
   #考勤参数类型
   CALL q076_get_items('609') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdh03_2",l_name,l_items)
          
   CALL cl_ui_init()
   
   LET g_wc1=" 1=1"
   LET g_wc2=" 1=1"
   LET g_wc3=" 1=1"
   LET g_wc4=" 1=1"
   LET g_wc5=" 1=1" 
   LET g_wc6=" 1=1"
   
   CALL q076_b_fill()
      
   CALL q076_menu()
   CLOSE WINDOW q076_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q076_get_items(p_hrag01)
DEFINE p_hrag01   LIKE  hrag_file.hrag01
DEFINE l_name   STRING
DEFINE l_items  STRING
DEFINE l_hrag06 LIKE  hrag_file.hrag06
DEFINE l_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"'",
                 "  ORDER BY hrag06"
       PREPARE q076_get_items_pre FROM l_sql
       DECLARE q076_get_items CURSOR FOR q076_get_items_pre
       
       LET l_name=''
       LET l_items=''
       
       FOREACH q076_get_items INTO l_hrag06,l_hrag07
             		       		 
          IF cl_null(l_name) AND cl_null(l_items) THEN
            LET l_name=l_hrag06
            LET l_items=l_hrag07
          ELSE
            LET l_name=l_name CLIPPED,",",l_hrag06 CLIPPED
            LET l_items=l_items CLIPPED,",",l_hrag07 CLIPPED
          END IF
       END FOREACH
       
       RETURN l_name,l_items

END FUNCTION
	
FUNCTION q076_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
   	  CASE g_flag
   	     WHEN 'pg1'	
            CALL q076_bp1("G")    #包含第一页签DISPLAY
         WHEN 'pg2'
            CALL q076_bp2("G")    #包含第二页签DISPLAY
         WHEN 'pg3'
            CALL q076_bp3("G")    #包含第三页签DISPLAY
         WHEN 'pg4'
            CALL q076_bp4("G")    #包含第四页签DISPLAY
         WHEN 'pg5'
            CALL q076_bp5("G")    #包含第五页签DISPLAY
         WHEN 'pg6'
            CALL q076_bp6("G")    #包含第六页签DISPLAY 
         OTHERWISE
            CALL q076_bp("G")    #包含所有页签DISPLAY
      END CASE
      	                          
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
            	 CASE g_flag
            	 	  WHEN 'pg1'  	CALL q076_q1()
            	 	  WHEN 'pg2'  	CALL q076_q2()
            	 	  WHEN 'pg3'  	CALL q076_q3()
            	 	  WHEN 'pg4'  	CALL q076_q4()
            	 	  WHEN 'pg5'  	CALL q076_q5()
            	 	  WHEN 'pg6'  	CALL q076_q6()
            	 END CASE	    
            END IF

         WHEN "xinzeng"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri076")
               CALL q076_b_fill()
            END IF

         WHEN "xzkq"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri077")
               CALL q076_b_fill()
            END IF

        #add by zhangbo130906---begin
        WHEN "xzrs"
            IF cl_chk_act_auth() THEN
               CALL cl_cmdrun_wait("ghri115")
               CALL q076_b_fill()
            END IF
        #add by zhangbo130906---end 
            	                                                                                                                                                                                                                          
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
                     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdh_1),'','')
                  WHEN 'pg2'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdh_2),'','')	
              	  WHEN 'pg3'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdh_3),'','')
              	  WHEN 'pg4'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdh_4),'','')
              	  WHEN 'pg5'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdh_5),'','')
              	  WHEN 'pg6'   
              	     CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdh_6),'','')
               END CASE	                     
            END IF
      END CASE
   END WHILE
 
END FUNCTION
	
FUNCTION q076_q1()
   CALL q076_b1_askkey()
END FUNCTION

FUNCTION q076_b1_askkey()
    CLEAR FORM
    CALL g_hrdh_1.clear()
 
    CONSTRUCT g_wc1 ON hrdh02,hrdh01,hrdh06,hrdh03,hrdh08,hrdh07,hrdh11                       
         FROM s_hrdh_1[1].hrdh02_1,s_hrdh_1[1].hrdh01_1,s_hrdh_1[1].hrdh06_1,                                  
              s_hrdh_1[1].hrdh03_1,s_hrdh_1[1].hrdh08_1,s_hrdh_1[1].hrdh07_1,
              s_hrdh_1[1].hrdh11_1
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hrdhuser', 'hrdhgrup')
 
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_wc1 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
 
    CALL q076_b_fill()
 
END FUNCTION
	
FUNCTION q076_q2()
   CALL q076_b2_askkey()
END FUNCTION

FUNCTION q076_b2_askkey()
    CLEAR FORM
    CALL g_hrdh_2.clear()
 
    CONSTRUCT g_wc2 ON hrdh02,hrdh01,hrdh06,hrdh03,hrdh07,hrdh11                       
         FROM s_hrdh_2[1].hrdh02_2,s_hrdh_2[1].hrdh01_2,s_hrdh_2[1].hrdh06_2,                                  
              s_hrdh_2[1].hrdh03_2,s_hrdh_2[1].hrdh07_2,s_hrdh_2[1].hrdh11_2
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
 
    CALL q076_b_fill()
 
END FUNCTION	
	
FUNCTION q076_q3()
   CALL q076_b3_askkey()
END FUNCTION

FUNCTION q076_b3_askkey()
    CLEAR FORM
    CALL g_hrdh_3.clear()
 
    CONSTRUCT g_wc3 ON hrdh02,hrdh01,hrdh06,hrdh07,hrdh11                       
         FROM s_hrdh_3[1].hrdh02_3,s_hrdh_3[1].hrdh01_3,s_hrdh_3[1].hrdh06_3,                                  
              s_hrdh_3[1].hrdh07_3,s_hrdh_3[1].hrdh11_3
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
       LET g_wc3 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
 
    CALL q076_b_fill()
 
END FUNCTION	
	
FUNCTION q076_q4()
   CALL q076_b4_askkey()
END FUNCTION

FUNCTION q076_b4_askkey()
    CLEAR FORM
    CALL g_hrdh_4.clear()
 
    CONSTRUCT g_wc4 ON hrdh02,hrdh01,hrdh06,hrdh07,hrdh11                       
         FROM s_hrdh_4[1].hrdh02_4,s_hrdh_4[1].hrdh01_4,s_hrdh_4[1].hrdh06_4,                                  
              s_hrdh_4[1].hrdh07_4,s_hrdh_4[1].hrdh11_4
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
       LET g_wc4 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
 
    CALL q076_b_fill()
 
END FUNCTION	
	
FUNCTION q076_q5()
   CALL q076_b5_askkey()
END FUNCTION

FUNCTION q076_b5_askkey()
    CLEAR FORM
    CALL g_hrdh_5.clear()
 
    CONSTRUCT g_wc5 ON hrdh02,hrdh01,hrdh06,hrdh07,hrdh11                       
         FROM s_hrdh_5[1].hrdh02_5,s_hrdh_5[1].hrdh01_5,s_hrdh_5[1].hrdh06_5,                                  
              s_hrdh_5[1].hrdh07_5,s_hrdh_5[1].hrdh11_5
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
       LET g_wc5 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
 
    CALL q076_b_fill()
 
END FUNCTION
	
FUNCTION q076_q6()
   CALL q076_b6_askkey()
END FUNCTION

FUNCTION q076_b6_askkey()
    CLEAR FORM
    CALL g_hrdh_6.clear()
 
    CONSTRUCT g_wc6 ON hrdh02,hrdh01,hrdh06,hrdh07,hrdh11                       
         FROM s_hrdh_6[1].hrdh02_6,s_hrdh_6[1].hrdh01_6,s_hrdh_6[1].hrdh06_6,                                  
              s_hrdh_6[1].hrdh07_6,s_hrdh_6[1].hrdh11_6
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
 
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
       LET g_wc6 = NULL
       RETURN
    END IF
#No.TQC-710076 -- end --
 
    CALL q076_b_fill()
 
END FUNCTION
	
FUNCTION q076_b_fill()
	  
	  #薪资福利类
	  LET g_sql=" SELECT hrdh02,hrdh01,hrdh06,hrdh03,hrdh08,hrdh07,hrdh11 ",
	            "   FROM hrdh_file ",
	            "  WHERE hrdh02='002' ",
	            "    AND ",g_wc1 CLIPPED,
	            "  ORDER BY hrdh02,hrdh01,hrdh03"
	  PREPARE q076_pb1 FROM g_sql
    DECLARE hrdh1_curs CURSOR FOR q076_pb1
 
    CALL g_hrdh_1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdh1_curs INTO g_hrdh_1[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdh_1[g_cnt].hrdh07 
          FROM hraa_file 
         WHERE hraa01=g_hrdh_1[g_cnt].hrdh07	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdh_1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2_1  
    LET g_cnt = 0          
    
    #考勤时间类
	  LET g_sql=" SELECT hrdh02,hrdh01,hrdh06,hrdh03,hrdh07,hrdh11 ",
	            "   FROM hrdh_file ",
	            "  WHERE hrdh02='003' ",
	            "    AND ",g_wc2 CLIPPED,
	            "  ORDER BY hrdh02,hrdh01,hrdh03"
	  PREPARE q076_pb2 FROM g_sql
    DECLARE hrdh2_curs CURSOR FOR q076_pb2
 
    CALL g_hrdh_2.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdh2_curs INTO g_hrdh_2[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdh_2[g_cnt].hrdh07
          FROM hraa_file 
         WHERE hraa01=g_hrdh_2[g_cnt].hrdh07	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdh_2.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2_2  
    LET g_cnt = 0 
    
    #绩效考核类
	  LET g_sql=" SELECT hrdh02,hrdh01,hrdh06,hrdh07,hrdh11 ",
	            "   FROM hrdh_file ",
	            "  WHERE hrdh02='004' ",
	            "    AND ",g_wc3 CLIPPED,
	            "  ORDER BY hrdh02,hrdh01"
	  PREPARE q076_pb3 FROM g_sql
    DECLARE hrdh3_curs CURSOR FOR q076_pb3
 
    CALL g_hrdh_3.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdh3_curs INTO g_hrdh_3[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdh_3[g_cnt].hrdh07 
          FROM hraa_file 
         WHERE hraa01=g_hrdh_3[g_cnt].hrdh07	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdh_3.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2_3  
    LET g_cnt = 0 
    
    #奖惩类
	  LET g_sql=" SELECT hrdh02,hrdh01,hrdh06,hrdh07,hrdh11 ",
	            "   FROM hrdh_file ",
	            "  WHERE hrdh02='005' ",
	            "    AND ",g_wc4 CLIPPED,
	            "  ORDER BY hrdh02,hrdh01"
	  PREPARE q076_pb4 FROM g_sql
    DECLARE hrdh4_curs CURSOR FOR q076_pb4
 
    CALL g_hrdh_4.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdh4_curs INTO g_hrdh_4[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdh_4[g_cnt].hrdh07 
          FROM hraa_file 
         WHERE hraa01=g_hrdh_4[g_cnt].hrdh07
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdh_4.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b4 = g_cnt-1
    DISPLAY g_rec_b4 TO FORMONLY.cn2_4  
    LET g_cnt = 0 
    
    #人事信息类
	  LET g_sql=" SELECT hrdh02,hrdh01,hrdh06,hrdh07,hrdh11 ",
	            "   FROM hrdh_file ",
	            "  WHERE hrdh02='001' ",
	            "    AND ",g_wc5 CLIPPED,
	            "  ORDER BY hrdh02,hrdh01"
	  PREPARE q076_pb5 FROM g_sql
    DECLARE hrdh5_curs CURSOR FOR q076_pb5
 
    CALL g_hrdh_5.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdh5_curs INTO g_hrdh_5[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdh_5[g_cnt].hrdh07 
          FROM hraa_file 
         WHERE hraa01=g_hrdh_5[g_cnt].hrdh07	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdh_5.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b5 = g_cnt-1
    DISPLAY g_rec_b5 TO FORMONLY.cn2_5  
    LET g_cnt = 0 
    
    #其他信息类
	  LET g_sql=" SELECT hrdh02,hrdh01,hrdh06,hrdh07,hrdh11 ",
	            "   FROM hrdh_file ",
	            "  WHERE hrdh02='006' ",
	            "    AND ",g_wc6 CLIPPED,
	            "  ORDER BY hrdh02,hrdh01"
	  PREPARE q076_pb6 FROM g_sql
    DECLARE hrdh6_curs CURSOR FOR q076_pb6
 
    CALL g_hrdh_6.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdh6_curs INTO g_hrdh_6[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
        SELECT hraa12 INTO g_hrdh_6[g_cnt].hrdh07 
          FROM hraa_file 
         WHERE hraa01=g_hrdh_6[g_cnt].hrdh07	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdh_6.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b6 = g_cnt-1
    DISPLAY g_rec_b6 TO FORMONLY.cn2_6  
    LET g_cnt = 0
	                 	
END FUNCTION
	
FUNCTION q076_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      DISPLAY ARRAY g_hrdh_1 TO s_hrdh_1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()  
         LET g_flag='pg1'
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdh_2 TO s_hrdh_2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()  
         LET g_flag='pg2'
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdh_3 TO s_hrdh_3.*  ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()  
         LET g_flag='pg3'
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdh_4 TO s_hrdh_4.*  ATTRIBUTE(COUNT=g_rec_b4)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac4 = ARR_CURR()
         CALL cl_show_fld_cont()  
         LET g_flag='pg4'
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
         
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdh_5 TO s_hrdh_5.*  ATTRIBUTE(COUNT=g_rec_b5)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         CALL cl_show_fld_cont()  
         LET g_flag='pg5'
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
         
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      DISPLAY ARRAY g_hrdh_6 TO s_hrdh_6.*  ATTRIBUTE(COUNT=g_rec_b6)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac6 = ARR_CURR()
         CALL cl_show_fld_cont()  
         LET g_flag='pg6'
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG     

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG     

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG 

      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end                                    
 
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
	
FUNCTION q076_bp1(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdh_1 TO s_hrdh_1.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG  

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG  

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG

      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end                                           
 
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
	
FUNCTION q076_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdh_2 TO s_hrdh_2.*  ATTRIBUTE(COUNT=g_rec_b2)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG             
      
      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end                                  
 
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
		
FUNCTION q076_bp3(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdh_3 TO s_hrdh_3.*  ATTRIBUTE(COUNT=g_rec_b3)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac3 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG             
      
      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end                                  
 
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
	
FUNCTION q076_bp4(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdh_4 TO s_hrdh_4.*  ATTRIBUTE(COUNT=g_rec_b4)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac4 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG
                                                    
      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end      

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
	
FUNCTION q076_bp5(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdh_5 TO s_hrdh_5.*  ATTRIBUTE(COUNT=g_rec_b5)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac5 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG
         
      ON ACTION pg6
         LET g_flag = "pg6"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG             
      
      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end                                  
 
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
	
FUNCTION q076_bp6(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdh_6 TO s_hrdh_6.*  ATTRIBUTE(COUNT=g_rec_b6)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac6 = ARR_CURR()
         CALL cl_show_fld_cont()  
                                        
      ON ACTION pg2
         LET g_flag = "pg2"
         EXIT DIALOG
      
      ON ACTION pg3
         LET g_flag = "pg3"
         EXIT DIALOG
         
      ON ACTION pg4
         LET g_flag = "pg4"
         EXIT DIALOG
         
      ON ACTION pg5
         LET g_flag = "pg5"
         EXIT DIALOG
         
      ON ACTION pg1
         LET g_flag = "pg1"
         EXIT DIALOG         
         
           
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG

      ON ACTION xinzeng
         LET g_action_choice="xinzeng"
         EXIT DIALOG

      ON ACTION xzkq
         LET g_action_choice="xzkq"
         EXIT DIALOG             

      #add by zhangbo130906---begin
      ON ACTION xzrs
         LET g_action_choice="xzrs"
         EXIT DIALOG
      #add by zhangbo130906---end                                  
 
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
	
		   			

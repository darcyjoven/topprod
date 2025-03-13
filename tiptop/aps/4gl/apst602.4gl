# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: apst602.4gl
# Descriptions...: 啟動APS 報表
# Date & Author..: 08/04/28 By Kevin #FUN-840179
# Modify.........: No.MOD-870105 08/07/09 By kevin 修改select的方式
# Modify.........: NO.TQC-940098 09/05/07 BY destiny DISPLAY BY NAME g_vzu01會報錯將其改為DISPLAY TO的形式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-B70088 11/07/21 By Mandy 若啟動規畫中儲存版本打勾,則送給APS的發送命令-V後的參數改傳0
 
DATABASE ds
#FUN-840179
GLOBALS "../../config/top.global"
DEFINE   p_row         LIKE type_file.num5    
DEFINE   p_col         LIKE type_file.num5 
DEFINE   g_argv1        LIKE vzx_file.vzx00,
         g_argv2        LIKE vzx_file.vzx01,
         g_argv3        LIKE vzx_file.vzx02,
         g_argv4        String,
         g_argv5        String
 
DEFINE   g_vzu01       LIKE vzu_file.vzu01,     
         g_vzu02       LIKE vzu_file.vzu02,  
         g_ch1         LIKE type_file.chr1      
              
DEFINE   g_version     LIKE type_file.chr1  
         
MAIN
   DEFINE l_cnt    LIKE type_file.num5
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   
   LET g_argv1 = ARG_VAL(1) CLIPPED     
   LET g_argv2 = ARG_VAL(2) CLIPPED     
   LET g_argv3 = ARG_VAL(3) CLIPPED     
   LET g_argv4 = ARG_VAL(4) CLIPPED     
   LET g_argv5 = ARG_VAL(5) CLIPPED     
   
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW apst602_w AT p_row,p_col WITH FORM "aps/42f/apst601"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()   
    IF NOT cl_null(g_argv1) THEN
    	  LET g_plant = g_argv1 CLIPPED        
        LET g_vzu01 = g_argv2 CLIPPED        
        LET g_vzu02 = g_argv3 CLIPPED
        LET g_ch1   = 'Y'
           
        SELECT COUNT(*) INTO l_cnt
        FROM vzy_file
        WHERE vzy00=g_plant
   	      AND vzy01=g_vzu01
   	      AND vzy02=g_vzu02
   	     
        IF l_cnt=0 THEN
        	 CALL cl_err('','aps-522',1)
        	 RETURN 
        END IF            
        CALL q100()
    ELSE
    	  LET g_ch1="N"
        CALL q100()
    END IF
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
    ELSE
       IF g_argv3='0' OR g_version="0" THEN
    	    CALL aws_open_browser(g_plant,g_vzu01,'0','0') #      
    	 ELSE    	 	
           #FUN-B70088---mod---str---
           #CALL aws_open_browser(g_plant,g_vzu01,g_vzu02,'0')        
            IF g_ch1 = 'Y' THEN
                CALL aws_open_browser(g_plant,g_vzu01,'0','0')        
            ELSE
                CALL aws_open_browser(g_plant,g_vzu01,g_vzu02,'0')        
            END IF
           #FUN-B70088---mod---end---
       END IF        
    END IF
    
    CLOSE WINDOW apst602_w
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time
   
END MAIN
 
FUNCTION q100()
   DEFINE l_cnt    LIKE type_file.num5
         
   INPUT g_vzu01,g_vzu02,g_ch1 WITHOUT DEFAULTS  FROM vzu01,vzu02,ch1 
       ATTRIBUTE(UNBUFFERED)
        BEFORE INPUT
        	   IF NOT cl_null(g_argv1) THEN
                CALL cl_set_comp_entry("vzu01",FALSE)
                CALL cl_set_comp_entry("vzu02",FALSE)             
             END IF            
        
     
        ON ACTION CONTROLP
           IF INFIELD(vzu01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_vzy01"
               CALL cl_create_qry() RETURNING g_vzu01
              #DISPLAY BY NAME g_vzu01                   #No.TQC-940098
               DISPLAY g_vzu01 TO vzu01                  #No.TQC-940098
               NEXT FIELD vzu01         
               
           END IF
           
           IF INFIELD(vzu02) THEN
              IF NOT cl_null(g_vzu01) THEN          	
                 CALL cl_init_qry_var()
                 IF g_version="0" THEN                 	  
                 	  #LET g_qryparam.form = "q_vzy03"                 
                 ELSE
                 		LET g_qryparam.form = "q_vzy04"                                 
                 END IF
                 LET g_qryparam.arg1 = g_vzu01 CLIPPED                 
                 CALL cl_create_qry() RETURNING g_vzu02
                #DISPLAY BY NAME g_vzu02                 #No.TQC-940098
                 DISPLAY g_vzu01 TO vzu02                #No.TQC-940098
                 NEXT FIELD vzu02              
               ELSE
                 CALL cl_err('','aps-521',1)
               END IF
           END IF
           
       AFTER FIELD vzu01
         IF NOT cl_null(g_vzu01) THEN
            SELECT count(*) INTO l_cnt FROM vzy_file #MOD-870105
             WHERE vzy01 = g_vzu01
               AND vzy10 = 'Y'
               
            IF l_cnt = 0 THEN #MOD-870105
               CALL cl_err('sel vzy:',STATUS,1)
               NEXT FIELD vzu01
            END IF
            
            
            IF cl_null(g_argv1) THEN
            	 CALL cl_set_comp_entry("vzu02",TRUE)
               IF cl_confirm("aps-520") THEN               	               	
                  SELECT vzy11 INTO g_vzu02
                    FROM vzy_file
                   WHERE vzy00=g_plant
   	                 AND vzy01=g_vzu01
   	                 AND vzy02='0'   	              
   	              
   	              IF cl_null(g_vzu02) THEN
   	              	 LET g_vzu02="0"   #取不到預設給0      	 	   	              	 
   	              END IF
   	              LET g_ch1="Y"
   	              DISPLAY BY NAME g_ch1
   	              DISPLAY g_vzu02 TO vzu02
   	              CALL cl_set_comp_entry("vzu02",FALSE) 
   	                	                 
               ELSE
               	  LET g_ch1="N"   
   	              DISPLAY BY NAME g_ch1
               END IF
            ELSE
            	 SELECT vzy11 INTO g_vzu02
                    FROM vzy_file
                   WHERE vzy00=g_plant
   	                 AND vzy01=g_vzu01
   	                 AND vzy02='0'
   	                 
   	           DISPLAY g_vzu02 TO vzu02        
            END IF               
         END IF
         
       AFTER FIELD vzu02
         IF NOT cl_null(g_vzu01) AND NOT cl_null(g_vzu02) THEN
            SELECT COUNT(*) INTO l_cnt
              FROM vlz_file where vlz01 = g_vzu01
               
            IF l_cnt = 0  THEN
               CALL cl_err('sel vzy:',STATUS,1)
               NEXT FIELD vzu02
            END IF
         END IF  
         
        AFTER INPUT        	 
          IF INT_FLAG THEN
              EXIT INPUT            	
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
        
        ON ACTION locale
           CALL cl_dynamic_locale()
        
        ON ACTION qbe_select
           CALL cl_qbe_select()
           
        ON ACTION qbe_save
           CALL cl_qbe_save()
           
           
   END INPUT  
   
END FUNCTION

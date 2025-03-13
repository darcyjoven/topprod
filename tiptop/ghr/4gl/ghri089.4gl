# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri089
# Descriptions...: 员工参保退保管理
# Date & Author..: 13/07/02 jiangxt
#MODIFY..........: add by zhuzw 20140922 增加删除功能 
#xie150418
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_hrdu1          DYNAMIC ARRAY OF RECORD    
            chk              LIKE type_file.chr1,       #选择              
            hraa12           LIKE hraa_file.hraa12,
            hrao02           LIKE hrao_file.hrao02,
            hratid           LIKE hrat_file.hratid,
            hrat01           LIKE hrat_file.hrat01,
            hrat02           LIKE hrat_file.hrat02,
            hrat25           LIKE hrat_file.hrat25,
            hrad03           LIKE hrad_file.hrad03,
            hrap06           LIKE hrap_file.hrap06,
            hrat28           LIKE hrat_file.hrat28,
            hrat30           LIKE hrat_file.hrat51
                        END RECORD, 
       g_hrdu1_t        DYNAMIC ARRAY OF RECORD    
            chk              LIKE type_file.chr1,       #选择              
            hraa12           LIKE hraa_file.hraa12,
            hrao02           LIKE hrao_file.hrao02,
            hratid           LIKE hrat_file.hratid,
            hrat01           LIKE hrat_file.hrat01,
            hrat02           LIKE hrat_file.hrat02,
            hrat25           LIKE hrat_file.hrat25,
            hrad03           LIKE hrad_file.hrad03,
            hrap06           LIKE hrap_file.hrap06,
            hrat28           LIKE hrat_file.hrat28,
            hrat30           LIKE hrat_file.hrat51
                        END RECORD, 
       g_hrdu2          DYNAMIC ARRAY OF RECORD                  
            hraa12a          LIKE hraa_file.hraa12, 
            hrao02a          LIKE hrao_file.hrao02,
            hrat01a          LIKE hrat_file.hrat01,
            hratida          LIKE hrat_file.hratid,
            hrat02a          LIKE hrat_file.hrat02,
            hrat25a          LIKE hrat_file.hrat25,
            hrad03a          LIKE hrad_file.hrad03,
            hrap06a          LIKE hrap_file.hrap06,
            hrat28a          LIKE hrat_file.hrat28,
            hrat30a          LIKE hrat_file.hrat30,
            hrdt02a          LIKE hrdt_file.hrdt02,
            hrdt03a          LIKE hrdt_file.hrdt03,
            hrdu05a          LIKE hrdu_file.hrdu05,
            hrdu04a          LIKE hrdu_file.hrdu04,
            hrdu03a          LIKE hrdu_file.hrdu03,
            hrdu07a          LIKE hrdu_file.hrdu07,
            hrdu08a          LIKE hrdu_file.hrdu08,
            hrdu09a          LIKE hrdu_file.hrdu09,
            hrdu10a          LIKE hrdu_file.hrdu10,
            hrdu11a          LIKE hrdu_file.hrduud02 #xie150418
                        END RECORD,   
       g_hrdu2_t        RECORD                  
            hraa12a          LIKE hraa_file.hraa12,
            hrao02a          LIKE hrao_file.hrao02,
            hrat01a          LIKE hrat_file.hrat01,
            hratida          LIKE hrat_file.hratid,
            hrat02a          LIKE hrat_file.hrat02,
            hrat25a          LIKE hrat_file.hrat25,
            hrad03a          LIKE hrad_file.hrad03,
            hrap06a          LIKE hrap_file.hrap06,
            hrat28a          LIKE hrat_file.hrat28,
            hrat30a          LIKE hrat_file.hrat30,
            hrdt02a          LIKE hrdt_file.hrdt02,
            hrdt03a          LIKE hrdt_file.hrdt03,
            hrdu05a          LIKE hrdu_file.hrdu05,
            hrdu04a          LIKE hrdu_file.hrdu04,
            hrdu03a          LIKE hrdu_file.hrdu03,
            hrdu07a          LIKE hrdu_file.hrdu07,
            hrdu08a          LIKE hrdu_file.hrdu08,
            hrdu09a          LIKE hrdu_file.hrdu09,
            hrdu10a          LIKE hrdu_file.hrdu10,
            hrdu11a          LIKE hrdu_file.hrduud02  #xie150418   
                        END RECORD, 
       g_hrdu3          DYNAMIC ARRAY OF RECORD                  
            hraa12b          LIKE hraa_file.hraa12,
            hrao02b          LIKE hrao_file.hrao02,
            hrat01b          LIKE hrat_file.hrat01,
            hrat02b          LIKE hrat_file.hrat02,
            hrat25b          LIKE hrat_file.hrat25,
            hrad03b          LIKE hrad_file.hrad03,
            hrap06b          LIKE hrap_file.hrap06,
            hrat28b          LIKE hrat_file.hrat28,
            hrat30b          LIKE hrat_file.hrat30,
            hrdt02b          LIKE hrdt_file.hrdt02,
            hrdt03b          LIKE hrdt_file.hrdt03,
            hrds02b          LIKE hrds_file.hrds02,
            hrdu04b          LIKE hrdu_file.hrdu04,
            hrdu03b          LIKE hrdu_file.hrdu03,
            hrduud01         LIKE hrdu_file.hrduud01,
            hrdu07b          LIKE hrdu_file.hrdu07,
            hrdu08b          LIKE hrdu_file.hrdu08,
            hrdu09b          LIKE hrdu_file.hrdu09,
            hrdu10b          LIKE hrdu_file.hrdu10,
            hratidb          LIKE hrat_file.hratid 
                        END RECORD,
       g_hrdu           DYNAMIC ARRAY OF RECORD                  
            hrdu05          LIKE hrdu_file.hrdu05,
            hrdu06          LIKE hrdu_file.hrdu06,
            hrdu07          LIKE hrdu_file.hrdu07,
            hrdu08          LIKE hrdu_file.hrdu08,
            hrdu09          LIKE hrdu_file.hrdu09,
            hrdu10          LIKE hrdu_file.hrdu10
                        END RECORD,
        g_hrdu_t        RECORD                  
            hrdu05          LIKE hrdu_file.hrdu05,
            hrdu06          LIKE hrdu_file.hrdu06,
            hrdu07          LIKE hrdu_file.hrdu07,
            hrdu08          LIKE hrdu_file.hrdu08,
            hrdu09          LIKE hrdu_file.hrdu09,
            hrdu10          LIKE hrdu_file.hrdu10
                        END RECORD                 
DEFINE g_rec_b1             LIKE type_file.num5,  
       g_rec_b2             LIKE type_file.num5,
       g_rec_b3             LIKE type_file.num5,
       g_rec_b4             LIKE type_file.num5,
       g_wc1                STRING,
       g_wc2                STRING,
       g_wc3                STRING,
       l_ac                 LIKE type_file.num5,
       l_ac_a               LIKE type_file.num5
DEFINE g_flag               LIKE type_file.chr1
DEFINE g_i                  LIKE type_file.num5  
DEFINE g_hrdu4              RECORD LIKE hrdu_file.*
DEFINE g_hrdu4_t            RECORD LIKE hrdu_file.*
DEFINE g_sql                STRING
DEFINE g_forupd_sql         STRING                       #SELECT ... FOR UPDATE  SQL  
DEFINE g_before_input_done  LIKE type_file.num5          #判斷是否已執行 Before Input指令  
DEFINE g_cnt                LIKE type_file.num10         #No.FUN-680102 INTEGER
DEFINE l_items              STRING
DEFINE l_name               STRING 
DEFINE g_hrat01             LIKE hrat_file.hrat01
# add by shenran start
DEFINE   g_sum           LIKE type_file.num10
DEFINE   g_jump1         LIKE type_file.num10
DEFINE   g_jump2         LIKE type_file.num10
DEFINE   g_turn          LIKE type_file.num10
DEFINE   g_turn_t        LIKE type_file.num10
DEFINE   g_record        LIKE type_file.num10
DEFINE   g_j    LIKE type_file.num5 
DEFINE   g_hrdu_adjust RECORD 
         hrdu01 LIKE hrdu_file.hrdu01,
         hrdu02 LIKE hrdu_file.hrdu02,
         hrdu03 LIKE hrdu_file.hrdu03,
         hrdu04 LIKE hrdu_file.hrdu04 
                 END RECORD,
         l_renewal LIKE type_file.chr1  #续保否
DEFINE g_hrai RECORD LIKE hrai_file.*    #xie150418     
                 
# add by shenran end 


MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                      #擷取中斷鍵

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GHR")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW i089_w WITH FORM "ghr/42f/ghri089"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""
   CALL cl_set_combo_items("hrat28",NULL,NULL)
   CALL cl_set_combo_items("hrat28a",NULL,NULL)
   CALL cl_set_combo_items("hrat28b",NULL,NULL)
   CALL cl_set_combo_items("hrdu03a",NULL,NULL)
   CALL cl_set_combo_items("hrdu03b",NULL,NULL)
   CALL cl_set_combo_items("hrdu05a",NULL,NULL)
   CALL cl_set_combo_items("hrdu05b",NULL,NULL)
   
   CALL i089_get_items('302') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrat28",l_name,l_items)
   CALL cl_set_combo_items("hrat28a",l_name,l_items)
   CALL cl_set_combo_items("hrat28b",l_name,l_items)
   
   CALL i089_get_items('621') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu03a",l_name,l_items)
   CALL cl_set_combo_items("hrdu03b",l_name,l_items)
   
   CALL i089_get_hrdu05() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu05a",l_name,l_items)
   CALL cl_set_combo_items("hrdu05b",l_name,l_items)
    CALL cl_set_comp_visible("hratid",FALSE)
   LET g_wc1='1=1'
   CALL i089_b_fill1(g_wc1,'')
   CALL i089_menu()
   
   CLOSE WINDOW i089_w

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN

FUNCTION i089_get_items(p_hrag01)
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
       PREPARE i089_get_p1 FROM l_sql
       DECLARE i089_get_c1 CURSOR FOR i089_get_p1
       FOREACH i089_get_c1 INTO p_hrag06,p_hrag07
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

FUNCTION i089_get_hrdu05()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrds01 LIKE hrds_file.hrds01
DEFINE l_hrds02 LIKE hrds_file.hrds02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrds01,hrds02 FROM hrds_file ",
                 "  ORDER BY hrds01"
       PREPARE i089_get_p2 FROM l_sql
       DECLARE i089_get_c2 CURSOR FOR i089_get_p2
       FOREACH i089_get_c2 INTO l_hrds01,l_hrds02
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

FUNCTION i089_menu()
DEFINE l_msg  STRING
DEFINE l_hratid LIKE hrat_file.hratid
   WHILE TRUE
      CASE g_flag
         WHEN '2'
           CALL i089_bp2("G")
         WHEN '3'
           CALL i089_bp3("G")
         OTHERWISE
           CALL i089_bp1("G")
      END CASE 
      CASE g_action_choice
        
        WHEN "detail"
             CASE g_flag
              WHEN '2'
              IF cl_chk_act_auth() THEN
               CALL i089_b()
                ELSE 
              END IF
              WHEN '3'
              OTHERWISE
                IF cl_chk_act_auth() THEN
                 CALL i089_b1()
                 ELSE
               END IF                   
              END CASE 
           
         WHEN "assign1"
            IF cl_chk_act_auth() THEN 
            	 LET l_renewal='N'
            	 CALL i089_assign1()
            END IF  
             
         WHEN "import"  #调整
            IF cl_chk_act_auth() THEN 
            	  CALL i089_import()
            END IF
             
         WHEN "adjust"  #调整
            IF cl_chk_act_auth() THEN 
            	  CALL i089_assign1_adjust()
            END IF
         
         WHEN "stop"  #停保
            IF cl_chk_act_auth() THEN 
            	 CALL i089_stop()
            END IF
            
         WHEN "renewal" #续保
            IF cl_chk_act_auth() THEN 
            	 LET l_renewal='Y'
            	 CALL i089_assign1_renewal()
            END IF
         #add by zhuzw 20140922 start
         WHEN "delt"    #批量删除功能
            IF cl_chk_act_auth() THEN 
               IF g_flag ='2' THEN
                    IF  cl_confirm('cghr268') THEN
                        SELECT hratid INTO l_hratid FROM hrat_file
                         WHERE hrat01 = g_hrdu2[l_ac].hrat01a
                        DELETE FROM hrdu_file WHERE hrdu01 =  l_hratid                    
                        LET l_msg = g_hrdu2[l_ac].hrat01a,'-',g_hrdu2[l_ac].hrat02a                        
                        CALL cl_err(l_msg,'cghr000',1)
                        CALL g_hrdu2.clear()   
                        CALL i089_b_fill2()
                    END IF
               END IF  
            END IF     
         #add by zhuzw 20140922 end                   
         WHEN "query"
            CASE g_flag
              WHEN '2'
                CALL i089_cs2()
              WHEN '3'
                CALL i089_cs3()
              OTHERWISE
                CALL i089_cs1()
              END CASE 
         # add by shenran start
         WHEN "fi"
            IF cl_chk_act_auth() THEN
            	LET g_jump1 = 1 
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	LET g_cnt = 0           	
             CALL i089_b_fill1(g_wc1,g_cnt)
            END IF            	 
         WHEN "pr"
            IF cl_chk_act_auth() THEN
            	IF g_jump1 > 1 THEN 
            	   LET g_jump1 = g_jump1 - 1
            	ELSE 
            	 	 LET g_jump1 = 1
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn           	          	
              CALL i089_b_fill1(g_wc1,g_cnt)
            END IF 
         WHEN "ne"
            IF cl_chk_act_auth() THEN
            	IF g_jump1 < g_jump2 THEN 
            	   LET g_jump1 = g_jump1 + 1
            	ELSE
            		 LET g_jump1 = g_jump2
            	END IF  
            	DISPLAY g_jump1 TO FORMONLY.jump1
            	    LET g_cnt = (g_jump1-1) * g_turn            	
              CALL i089_b_fill1(g_wc1,g_cnt)
            END IF 
         WHEN "la"
            IF cl_chk_act_auth() THEN
                  DISPLAY g_jump2 TO FORMONLY.jump1
                      LET g_jump1 = g_jump2
                      LET g_cnt = g_turn * (g_jump2-1)             	
              CALL i089_b_fill1(g_wc1,g_cnt)
            END IF  
         WHEN "shaixuan"
            IF cl_chk_act_auth() THEN
            	CALL i089_tz1()
            END IF 
# add by shenran end 
         WHEN "help"
            CALL cl_show_help() 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          
      END CASE
   END WHILE
END FUNCTION

FUNCTION i089_bp1(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdu1 TO s_hrdu1.* ATTRIBUTE(COUNT=g_rec_b1)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         
      ON ACTION assign1
         LET l_renewal='N'
         LET g_action_choice="assign1"
         EXIT DISPLAY 
           # add by shenran start
      ON ACTION fi         #130703
         LET g_action_choice="fi"
         EXIT DISPLAY   

      ON ACTION pr
         LET g_action_choice="pr"
         EXIT DISPLAY   

      ON ACTION ne
         LET g_action_choice="ne"
         EXIT DISPLAY   

      ON ACTION la
         LET g_action_choice="la"
         EXIT DISPLAY   

      ON ACTION shaixuan   #modified  NO.130709 yeap
         IF g_j = 1 THEN 
            CALL cl_err('',"ghr-126",0)
            LET g_j = 0
         ELSE 
         	  LET g_action_choice="shaixuan"
         END IF 
         EXIT DISPLAY
      # add by shenran end 
       ON ACTION detail
         LET l_ac=1
         LET g_action_choice="detail"
         EXIT DISPLAY
                    
      ON ACTION query
         LET g_action_choice="query"
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
         
      ON ACTION import
         LET g_action_choice="import"
         EXIT DISPLAY
  
      ON ACTION cancel
         LET INT_FLAG=FALSE     
         LET g_action_choice="exit"
         EXIT DISPLAY
       ON ACTION ACCEPT
         LET l_ac=1
         LET g_action_choice="detail"
         EXIT DISPLAY
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about       
         CALL cl_about() 

      ON ACTION p2
         IF cl_null(g_wc2) THEN
            LET g_wc2='1=1'
         END IF 
         CALL i089_b_fill2()
         LET g_flag ='2'
         EXIT DISPLAY

      ON ACTION p3
         IF cl_null(g_wc3) THEN
            LET g_wc3='1=1'
         END IF 
         CALL i089_b_fill3()
         LET g_flag ='3'
         EXIT DISPLAY 
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")   
         
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i089_bp2(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdu2 TO s_hrdu2.* ATTRIBUTE(COUNT=g_rec_b2)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY 
      ON ACTION detail
         LET l_ac=1
         LET g_action_choice="detail"
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
      
      ON ACTION ACCEPT
         LET l_ac=1
         LET g_action_choice="detail"
         EXIT DISPLAY
#add by zhuzw 20140922 start         
      ON ACTION delt
         LET l_ac = ARR_CURR()    #删除
         LET g_action_choice="delt"
         EXIT DISPLAY 
#add by zhuzw 20140922 end                  
      ON ACTION adjust      
         LET l_ac=1    #调整
         LET g_action_choice="adjust"
         EXIT DISPLAY
       
      ON ACTION stop
         LET l_ac=1   #停保
         LET g_action_choice="stop"
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

      ON ACTION p1
         IF cl_null(g_wc1) THEN
            LET g_wc1='1=1'
         END IF 
         CALL i089_b_fill1(g_wc1,'')
         LET g_flag = '1'
         EXIT DISPLAY

      ON ACTION p3
         IF cl_null(g_wc3) THEN
            LET g_wc3='1=1'
         END IF 
         CALL i089_b_fill3()
         LET g_flag = '3'
         EXIT DISPLAY 
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    
      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i089_bp3(p_ud)
DEFINE   p_ud   LIKE type_file.chr1

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
            
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_hrdu3 TO s_hrdu3.* ATTRIBUTE(COUNT=g_rec_b3)
                 
      BEFORE DISPLAY 
         CALL cl_navigator_setting(1,1)
                 
      BEFORE ROW
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              
      ON ACTION query
         LET g_action_choice="query"
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
         
      ON ACTION renewal  #续保
         LET l_renewal='Y' 
         LET g_action_choice="renewal"
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

      ON ACTION p1
         IF cl_null(g_wc1) THEN
            LET g_wc1='1=1'
         END IF 
         CALL i089_b_fill1(g_wc1,'')
         LET g_flag = '1'
         EXIT DISPLAY

      ON ACTION p2
         IF cl_null(g_wc2) THEN
            LET g_wc2='1=1'
         END IF 
         CALL i089_b_fill2()
         LET g_flag = '2'
         EXIT DISPLAY 
         
      AFTER DISPLAY
         CONTINUE DISPLAY
         
      ON ACTION controls                       
         CALL cl_set_head_visible("","AUTO")    
      
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i089_cs1()

    CALL g_hrdu1.clear()
    CONSTRUCT g_wc1 ON hrat03,hrat04,hrat01,hrat02,hrat25,hrad03
         FROM s_hrdu1[1].hraa12,s_hrdu1[1].hrao02,s_hrdu1[1].hrat01,s_hrdu1[1].hrat02,s_hrdu1[1].hrat25,s_hrdu1[1].hrad03
         
       BEFORE CONSTRUCT
         CALL cl_qbe_init()

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrat01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat01
               NEXT FIELD hrat01
            WHEN INFIELD(hraa12)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraa12
               NEXT FIELD hraa12
            WHEN INFIELD(hrao02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrao02
               NEXT FIELD hrao02
          END CASE
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
      
       ON ACTION about    
          CALL cl_about()  
      
       ON ACTION HELP       
          CALL cl_show_help()
      
       ON ACTION controlg    
          CALL cl_cmdask()    

       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('hratuser', 'hratgrup')
    IF INT_FLAG THEN 
       DISPLAY '' to cnt1
       RETURN 
    END IF 
    CALL i089_b_fill1(g_wc1,'')
END FUNCTION

FUNCTION i089_b_fill1(p_wc2,p_start)
	DEFINE
    p_wc2           LIKE type_file.chr1000,       #No.FUN-680102 VARCHAR(200)
    l_hrag          RECORD LIKE hrag_file.*,
    l_hrat          RECORD LIKE hrat_file.*,
    p_start         LIKE type_file.num5 ,
    l_jump2         LIKE type_file.num10     
 
  IF cl_null(p_start) THEN 
   LET g_sql = "SELECT 'N',hraa12,hrao02,hratid,hrat01,hrat02,hrat25,hrat19,hrap06,hrat28,hrat30",
               "  FROM hrat_file,hraa_file,hrao_file,hrap_file,hrad_file",
               " WHERE hrat03=hraa01(+) AND hrat04=hrao01(+) ",
               "   AND hrat04=hrap01(+) AND hrat05=hrap05(+) AND hrat19=hrad02(+)",
               "   AND hrad01 <> '003' AND hratid NOT IN (SELECT hrdu01 FROM hrdu_file WHERE hrdu01 IS NOT NULL)",
               "   AND ",g_wc1,
               " ORDER BY hrat01"
   LET g_sql = "SELECT 'N',hraa12,hrao02,hratid,hrat01,hrat02,hrat25,hrat19,hras04,hrat28,hrat30",
   " FROM hrat_file ",
   " LEFT JOIN hraa_file ON hraa01=hrat03",
   " LEFT JOIN hrao_file ON hrao01=hrat04",
   " LEFT JOIN hras_file ON hras01=hrat05",
   " LEFT JOIN hrbh_file ON hrbh01=hratid",
   " LEFT JOIN hrad_file ON hrad02=hrat19",
   " WHERE ((hrbh09 !='Y' AND hrad01='003')OR hrad01<>'003') AND hratid NOT IN (SELECT hrdu01 FROM hrdu_file WHERE hrdu01 IS NOT NULL)",
               "   AND ",g_wc1,
               " ORDER BY hrat01 DESC"
   PREPARE i089_pb1 FROM g_sql
   DECLARE i089_hrdu1 CURSOR FOR i089_pb1
   LET g_cnt = 1
   CALL g_hrdu1_t.clear()
   FOREACH i089_hrdu1 INTO g_hrdu1_t[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_hrdu1_t.deleteElement(g_cnt)
   # add by shenran 	start      
      IF g_cnt > 100 THEN
       	LET g_turn = 100
      ELSE
        LET g_turn = g_cnt-1
      END IF
        LET g_jump1 = 1  
        DISPLAY g_jump1 TO FORMONLY.jump1
        LET g_sum = g_cnt-1
        DISPLAY g_sum TO FORMONLY.cnt
        LET g_jump2 = g_sum/g_turn
        LET l_jump2 = g_jump2 * g_turn 
        IF l_jump2 < g_sum THEN 
        	LET g_jump2 = g_jump2 + 1 
        END IF 
       DISPLAY g_jump2 TO FORMONLY.jump2
       CALL i089_set_data1(0,g_turn)
       DISPLAY g_turn TO cnt1 
      ELSE 
        CALL i089_set_data1(p_start,g_turn)
        DISPLAY g_turn TO cnt1 
      LET g_rec_b1=g_cnt-1
   END IF
      LET g_cnt = 0
END FUNCTION

FUNCTION i089_cs2()

    CALL g_hrdu2.clear()
    CONSTRUCT g_wc2 ON hrat03,hrat04,hrat01,hrat02,hrat25,hrad03
         FROM s_hrdu2[1].hraa12a,s_hrdu2[1].hrao02a,s_hrdu2[1].hrat01a,s_hrdu2[1].hrat02a,s_hrdu2[1].hrat25a,s_hrdu2[1].hrad03a
         
       BEFORE CONSTRUCT
         CALL cl_qbe_init()

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrat01a)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat01a
               NEXT FIELD hrat01a
            WHEN INFIELD(hraa12a)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraa12a
               NEXT FIELD hraa12a
            WHEN INFIELD(hrao02a)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrao02a
               NEXT FIELD hrao02a
          END CASE
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
      
       ON ACTION about    
          CALL cl_about()  
      
       ON ACTION HELP       
          CALL cl_show_help()
      
       ON ACTION controlg    
          CALL cl_cmdask()    

       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN 
       DISPLAY '' to cnt2
       RETURN 
    END IF
    CALL i089_b_fill2() 
END FUNCTION

FUNCTION i089_b_fill2()

   LET g_sql = "SELECT distinct hraa12,hrao02,hrat01,hratid,hrat02,hrat25,hrad03,hrap06,hrat28,hrat30,",
               "       hrdt02,hrdt03,hrdu05,hrdu04,hrdu03,hrdu07,hrdu08,hrdu09,hrdu10,(select distinct hrai02 from hrai_file where hrai01 = hrduud02 ) ",
               #"  FROM hrat_file,hraa_file,hrao_file,hrap_file,hrdt_file,hrdu_file,hrad_file,hrai_file",
               "  FROM hrat_file,hraa_file,hrao_file,hrap_file,hrdt_file,hrdu_file,hrad_file",
               "  WHERE hrat03=hraa01(+) AND hrat04=hrao01(+) ",
               "   AND hrat04=hrap01(+) AND hrat05=hrap05(+) ",
               "   AND hrat19=hrad02(+) AND hrdu02=hrdt01(+)",
            #   "  and hrduud02=hrai01(+) ", #  and hrat04=hrai03(+) ",
               "   AND hrdu01=hratid AND hrdu03='001'",
               "   AND ",g_wc2,
               " ORDER BY hrat01"
   PREPARE i089_pb2 FROM g_sql
   DECLARE i089_hrdu2 CURSOR FOR i089_pb2
   LET g_cnt = 1

   CALL g_hrdu2.clear()   
   FOREACH i089_hrdu2 INTO g_hrdu2[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

#       SELECT hrad03 INTO g_hrdu2[g_cnt].hrad03a FROM hrad_file 
#        WHERE hrad02=g_hrdu2[g_cnt].hrad03a AND rownum=1
        
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_hrdu2.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   DISPLAY g_rec_b2 TO cnt2
END FUNCTION

FUNCTION i089_cs3()

    CALL g_hrdu3.clear()
    CONSTRUCT g_wc3 ON hrat03,hrat04,hrat01,hrat02,hrat25,hrad03
         FROM s_hrdu3[1].hraa12b,s_hrdu3[1].hrao02b,s_hrdu3[1].hrat01b,s_hrdu3[1].hrat02b,s_hrdu3[1].hrat25b,s_hrdu3[1].hrad03b
         
       BEFORE CONSTRUCT
         CALL cl_qbe_init()

       ON ACTION controlp
          CASE
             WHEN INFIELD(hrat01b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrat01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrat01b
               NEXT FIELD hrat01b
            WHEN INFIELD(hraa12b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hraa01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hraa12b
               NEXT FIELD hraa12b
            WHEN INFIELD(hrao02b)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrao01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO hrao02b
               NEXT FIELD hrao02b
          END CASE
       
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
      
       ON ACTION about    
          CALL cl_about()  
      
       ON ACTION HELP       
          CALL cl_show_help()
      
       ON ACTION controlg    
          CALL cl_cmdask()    

       ON ACTION qbe_select
          CALL cl_qbe_select()
          
       ON ACTION qbe_save
          CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN 
       DISPLAY '' TO cnt3
       RETURN 
    END IF
    CALL i089_b_fill3() 
END FUNCTION

FUNCTION i089_b_fill3()

   LET g_sql = "SELECT hraa12,hrao02,hrat01,hrat02,hrat25,hrad03,hrap06,hrat28,hrat30,",
               "       hrdt02,hrdt03,hrdu05,hrdu04,hrdu03,hrduud01,hrdu07,hrdu08,hrdu09,hrdu10,hratid",
               "  FROM hrat_file,hraa_file,hrao_file,hrap_file,hrdt_file,hrdu_file,hrad_file",
               " WHERE hrat03=hraa01(+) AND hrat04=hrao01(+) ",
               "   AND hrat04=hrap01(+) AND hrat05=hrap05(+) ",
               "   AND hrat19=hrad02(+) AND hrdu02=hrdt01(+)",
               "   AND hrdu01=hratid AND hrdu03='002'",
               "   AND ",g_wc3,
               " ORDER BY hrat01"
   PREPARE i089_pb3 FROM g_sql
   DECLARE i089_hrdu3 CURSOR FOR i089_pb3
   LET g_cnt = 1

   FOREACH i089_hrdu3 INTO g_hrdu3[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

#       SELECT hrad03 INTO g_hrdu3[g_cnt].hrad03b FROM hrad_file 
#        WHERE hrad02=g_hrdu3[g_cnt].hrad03b AND rownum=1
        
       LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_hrdu3.deleteElement(g_cnt)
   LET g_rec_b3=g_cnt-1
   DISPLAY g_rec_b3 TO cnt3
END FUNCTION

FUNCTION i089_b()
DEFINE l_lock_sw       LIKE type_file.chr1
    
    LET g_action_choice = "" 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT hraa12,hrao02,hrat01,hratid,hrat02,hrat25,hrat19,hrap06,hrat28,hrat30,",
                       "       hrdt02,hrdt03,hrdu05,hrdu04,hrdu03,hrdu07,hrdu08,hrdu09,hrdu10",
                       "  FROM hrat_file,hraa_file,hrao_file,hrap_file,hrdt_file,hrdu_file",
                       " WHERE hrat03=hraa01(+) AND hrat04=hrao01(+) ",
                       "   AND hrat04=hrap01(+) AND hrat05=hrap05(+) ",
                       "   AND hrdu02=hrdt01(+)",
                       "   AND hrdu01=hratid ",
                       "   AND hrdu01 = ? AND hrdu03=? AND hrdu05= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i089_cl CURSOR FROM g_forupd_sql
   
    INPUT ARRAY g_hrdu2 WITHOUT DEFAULTS FROM s_hrdu2.*
      ATTRIBUTE (COUNT=g_rec_b2,MAXCOUNT=100000,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=TRUE,APPEND ROW=FALSE)

        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF

        BEFORE ROW
            LET l_lock_sw = 'N' 
            LET l_ac = ARR_CURR()            
            IF g_rec_b2 >= l_ac THEN    
               BEGIN WORK
               LET g_hrdu2_t.* = g_hrdu2[l_ac].*  #BACKUP
               OPEN i089_cl USING g_hrdu2[l_ac].hratida,g_hrdu2[l_ac].hrdu03a,g_hrdu2[l_ac].hrdu05a
               IF STATUS THEN
                  CALL cl_err("OPEN i089_cl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i089_cl INTO g_hrdu2[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_hrdu2_t.hrat01a,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF 
               CALL cl_show_fld_cont()
            END IF
            
        ON ACTION controlp
           CASE WHEN INFIELD(hrdu04a)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrct11"
              CALL cl_create_qry() RETURNING g_hrdu2[l_ac].hrdu04a
              DISPLAY BY NAME g_hrdu2[l_ac].hrdu04a
              NEXT FIELD hrdu04a
           END CASE

        BEFORE DELETE
           IF NOT cl_delete() THEN
              CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1)
              CANCEL DELETE
           END IF
           DELETE FROM hrdu_file WHERE hrdu01 = g_hrdu2_t.hratida
                                   AND hrdu03 = g_hrdu2_t.hrdu03a
                                   AND hrdu05 = g_hrdu2_t.hrdu05a
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","hrdu_file",g_hrdu2[l_ac].hrat01a,"",SQLCA.sqlcode,"","",1)   #No.FUN-660131
              EXIT INPUT
           END IF
           LET g_rec_b2=g_rec_b2-1
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdu2[l_ac].* = g_hrdu2_t.*
              CLOSE i089_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(g_hrdu2[l_ac].hrat01a,-263,0)
               LET g_hrdu2[l_ac].* = g_hrdu2_t.*
           ELSE
               UPDATE hrdu_file SET hrdu04=g_hrdu2[l_ac].hrdu04a,
                                    hrdu03=g_hrdu2[l_ac].hrdu03a,
                                    hrdu07=g_hrdu2[l_ac].hrdu07a,
                                    hrdu08=g_hrdu2[l_ac].hrdu08a,
                                    hrdu09=g_hrdu2[l_ac].hrdu09a,
                                    hrdu10=g_hrdu2[l_ac].hrdu10a
                               WHERE hrdu01 = g_hrdu2_t.hratida
                                 AND hrdu03 = g_hrdu2_t.hrdu03a
                                 AND hrdu05 = g_hrdu2_t.hrdu05a
                                 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrdu_file",g_hrdu2_t.hrat01a,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdu2[l_ac].* = g_hrdu2_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdu2[l_ac].* = g_hrdu2_t.*
              CLOSE i089_cl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i089_cl
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
    
    CLOSE i089_cl
    COMMIT WORK
END FUNCTION

FUNCTION i089_get_hrat42()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrai03 LIKE hrai_file.hrai03
DEFINE l_hrai04 LIKE hrai_file.hrai04

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrai03,hrai04 FROM hrai_file ",
                 "  ORDER BY hrai03"
       PREPARE i089_get_p3 FROM l_sql
       DECLARE i089_get_c3 CURSOR FOR i089_get_p3
       FOREACH i089_get_c3 INTO l_hrai03,l_hrai04
          IF cl_null(p_name) AND cl_null(p_items) THEN
            LET p_name=l_hrai03
            LET p_items=l_hrai04
          ELSE
            LET p_name=p_name CLIPPED,",",l_hrai03 CLIPPED
            LET p_items=p_items CLIPPED,",",l_hrai04 CLIPPED
          END IF
       END FOREACH

       RETURN p_name,p_items
END FUNCTION

FUNCTION i089_get_hrdu02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrdt01 LIKE hrdt_file.hrdt01
DEFINE l_hrdt02 LIKE hrdt_file.hrdt02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrdt01,hrdt02 FROM hrdt_file ",
                 "  ORDER BY hrdt01"
       PREPARE i089_get_p4 FROM l_sql
       DECLARE i089_get_c4 CURSOR FOR i089_get_p4
       FOREACH i089_get_c4 INTO l_hrdt01,l_hrdt02
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

FUNCTION i089_b_fill_a(p_hrdu01,p_hrdu03)
DEFINE l_sql    STRING
DEFINE p_hrdu01 LIKE hrdu_file.hrdu01
DEFINE p_hrdu03 LIKE hrdu_file.hrdu03

    LET g_cnt=1
    CALL g_hrdu.clear()
    LET l_sql=" SELECT hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10",
              "   FROM hrdu_file",
              "  WHERE hrdu01='",p_hrdu01,"'",
              "    AND hrdu03='001'"
    PREPARE hrdu_fill_p FROM l_sql
    DECLARE hrdu_fill_c CURSOR FOR hrdu_fill_p
    FOREACH hrdu_fill_c INTO g_hrdu[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF

       LET g_cnt = g_cnt + 1
   END FOREACH
   
   CALL g_hrdu.deleteElement(g_cnt)
   LET g_rec_b4=g_cnt-1
   
   DISPLAY ARRAY g_hrdu TO s_hrdu.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE DISPLAY
         EXIT DISPLAY 
   END DISPLAY 
   
   CALL i089_b_a(p_hrdu01,p_hrdu03)
END FUNCTION 

FUNCTION i089_b_a(l_hrdu01,l_hrdu03)
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE l_hrdu01        LIKE hrdu_file.hrdu01
DEFINE l_hrdu03        LIKE hrdu_file.hrdu03

     LET g_forupd_sql = "SELECT hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10",
                        "  FROM hrdu_file",
                        " WHERE  hrdu01 = ? AND hrdu03=? AND hrdu05= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i089_cl_a CURSOR FROM g_forupd_sql
    
    INPUT ARRAY g_hrdu WITHOUT DEFAULTS FROM s_hrdu.*
      ATTRIBUTE (COUNT=g_rec_b4,MAXCOUNT=100000,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

        BEFORE INPUT
            IF g_rec_b4!=0 THEN 
               LET l_ac_a=1
            END IF
            
        BEFORE ROW
            LET l_lock_sw = 'N' 
            LET l_ac_a = ARR_CURR()                
            IF g_rec_b4 >= l_ac_a THEN    
               BEGIN WORK
               LET g_hrdu_t.* = g_hrdu[l_ac_a].*  #BACKUP
               OPEN i089_cl_a USING l_hrdu01,l_hrdu03,g_hrdu[l_ac_a].hrdu05
               IF STATUS THEN
                  CALL cl_err("OPEN i089_cl_a:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i089_cl_a INTO g_hrdu[l_ac_a].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_hrdu01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF 
               CALL cl_show_fld_cont()
            END IF
            
        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdu[l_ac_a].* = g_hrdu_t.*
              CLOSE i089_cl_a
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(l_hrdu01,-263,0)
               LET g_hrdu[l_ac_a].* = g_hrdu_t.*
           ELSE 
               UPDATE hrdu_file SET hrdu05=g_hrdu[l_ac_a].hrdu05, 
                                    hrdu06=g_hrdu[l_ac_a].hrdu06,
                                    hrdu07=g_hrdu[l_ac_a].hrdu07,
                                    hrdu08=g_hrdu[l_ac_a].hrdu08,
                                    hrdu09=g_hrdu[l_ac_a].hrdu09,
                                    hrdu10=g_hrdu[l_ac_a].hrdu10
                               WHERE hrdu01 = l_hrdu01
                                 AND hrdu03 = l_hrdu03
                                 AND hrdu05 = g_hrdu_t.hrdu05
                                 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrdu_file",l_hrdu01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdu[l_ac_a].* = g_hrdu_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac_a = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdu[l_ac_a].* = g_hrdu_t.*
              CLOSE i089_cl_a
# #add by zhuzw 20141125 start
#              FOR l_n=1 TO g_turn 
#                 IF g_hrdu1[l_n].chk = 'Y' THEN 
#                 END IF 
#              END FOR    
# #add by zhuzw 20141125 end  
              DELETE FROM hrdu_file WHERE hrdu01 = l_hrdu01 AND hrdu03 = l_hrdu03  #add by zhuzw 20141125
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i089_cl_a
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
    
    CLOSE i089_cl_a
    COMMIT WORK
END FUNCTION 
      
FUNCTION i089_b1()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680102 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680102 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680102 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680102 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,           #No.FUN-680102             #可新增否
    l_allow_delete  LIKE type_file.chr1           #No.FUN-680102               #可刪除否
   
DEFINE l_flag       LIKE type_file.chr1           #No.FUN-810016    
DEFINE l_hrag       RECORD LIKE hrag_file.*
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
 
    INPUT ARRAY g_hrdu1 WITHOUT DEFAULTS FROM s_hrdu1.*
      ATTRIBUTE (COUNT=g_rec_b1,MAXCOUNT=100000,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE) 
 
        BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            CALL cl_show_fld_cont() 
                
        AFTER ROW
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac             # 新增
 
           IF INT_FLAG THEN 
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              EXIT INPUT
           END IF

        ON ACTION sel_all
           FOR l_n = 1 TO g_rec_b1
              LET g_hrdu1[l_n].chk = 'Y'
           END FOR
           
        ON ACTION sel_no
           FOR l_n = 1 TO g_rec_b1
              LET g_hrdu1[l_n].chk = 'N'
           END FOR           
 
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
 
END FUNCTION
  
FUNCTION i089_assign1()
 DEFINE l_go    LIKE  type_file.chr1
 DEFINE l_n     LIKE  type_file.num5
 DEFINE l_des   LIKE  type_file.chr100
 DEFINE l_hrag  RECORD LIKE hrag_file.*
 DEFINE l_infor STRING
 DEFINE l_sql     STRING 
 DEFINE l_cnt     LIKE type_file.num5
 DEFINE tyjs    LIKE hrdu_file.hrdu07
 DEFINE l_ta_hrdta01 LIKE hrdta_file.ta_hrdta01
 DEFINE l_hrdt02  LIKE hrdt_file.hrdt02
 DEFINE l_hrai02 LIKE hrai_file.hrai02 #xie150418

   IF g_rec_b1 = 0 THEN RETURN END IF 

   LET l_go = 'N'
   FOR l_n = 1 TO g_turn 
      IF g_hrdu1[l_n].chk = 'Y' THEN 
      	 LET l_go = 'Y'
      	 EXIT FOR
      ELSE 
         CONTINUE FOR
      END IF 
   END FOR 
   
   IF l_go = 'N' THEN 
   	 CALL cl_err( '请勾选人员','!', 1 )
   	RETURN END IF 
   INITIALIZE g_hrdu4.* TO NULL 
   
   IF NOT cl_confirm('abx-080') THEN RETURN END IF 
#   OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri891"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
#   CALL cl_ui_init()  
   
   LET g_hrdu4.hrdu03 = '001'
    OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri0891"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

 #  CALL cl_set_combo_items("hrdu02",NULL,NULL)
   CALL cl_set_combo_items("hrdu03",NULL,NULL)
   CALL cl_set_combo_items("hrdu05",NULL,NULL)
   CALL cl_set_combo_items("hrdu06",NULL,NULL)
   
   
#   CALL i089_get_hrdu02( ) RETURNING l_name,l_items
 #  CALL cl_set_combo_items("hrdu02",l_name,l_items)
   CALL i089_get_items('621') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu03",l_name,l_items)
   CALL i089_get_hrdu05() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu05",l_name,l_items)
   CALL i089_get_items('612') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu06",l_name,l_items)
   
   WHILE TRUE
      DISPLAY BY NAME g_hrdu4.hrdu02,g_hrdu4.hrdu03,g_hrdu4.hrdu04,g_hrai.hrai01 
      INPUT BY NAME g_hrdu4.hrdu02,g_hrdu4.hrdu03,g_hrdu4.hrdu04,tyjs,g_hrai.hrai01
                    WITHOUT DEFAULTS 
        BEFORE INPUT                                    #預設查詢條件
      AFTER FIELD hrdu02
      IF NOT cl_null(g_hrdu4.hrdu02) THEN 
         SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file 
          WHERE hrdt01 = g_hrdu4.hrdu02
         DISPLAY l_hrdt02 TO hrdu02_n 
      END IF 
            AFTER FIELD hrai01  #xie150418
      IF NOT cl_null(g_hrai.hrai01) THEN 
         SELECT hrai02 INTO l_hrai02 FROM hrai_file 
          WHERE hrai01 = g_hrai.hrai01 GROUP BY hrai02
         DISPLAY l_hrai02 TO hrai01_n 
         LET g_hrdu4.hrduud02=g_hrai.hrai01
      END IF 
      
      ON ACTION controlp
            CASE WHEN INFIELD(hrdu04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING g_hrdu4.hrdu04
               DISPLAY BY NAME g_hrdu4.hrdu04
               NEXT FIELD hrdu04
               WHEN INFIELD(hrdu02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrdt01"
               CALL cl_create_qry() RETURNING g_hrdu4.hrdu02
               DISPLAY BY NAME g_hrdu4.hrdu02
               NEXT FIELD hrdu02
                WHEN INFIELD(hrai01)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrai032"
               CALL cl_create_qry() RETURNING g_hrai.hrai01
               DISPLAY BY NAME g_hrai.hrai01
               NEXT FIELD hrai01
                
            END CASE
            
        ON ACTION locale
              #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
       
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
      END INPUT  
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i089_w1 
         RETURN
      END IF  
      EXIT WHILE  
   END WHILE
   
   FOR l_n=1 TO g_turn 
      IF g_hrdu1[l_n].chk = 'Y' THEN 
      	 LET g_hrdu4.hrdu01 = g_hrdu1[l_n].hratid
      	  BEGIN WORK 
        
        LET l_sql=" SELECT hrdta02,hrdta03,hrdta04,hrdta08,hrdta04,hrdta09,ta_hrdta01",
                  "   FROM hrdta_file",
                  "  WHERE hrdta01='",g_hrdu4.hrdu02,"'"
        PREPARE ins_p FROM l_sql
        DECLARE ins_c CURSOR FOR ins_p
        FOREACH ins_c INTO g_hrdu4.hrdu05,g_hrdu4.hrdu06,g_hrdu4.hrdu07,g_hrdu4.hrdu08,g_hrdu4.hrdu09,g_hrdu4.hrdu10,l_ta_hrdta01
         #add by zhuzw 20140924 start
          IF NOT cl_null(tyjs) AND l_ta_hrdta01 != 'Y' THEN             
             LET g_hrdu4.hrdu07 = tyjs
             LET g_hrdu4.hrdu09 = tyjs
          END IF 
          #add by zhuzw 20140924 end 
          INSERT INTO hrdu_file VALUES (g_hrdu4.*)
          IF sqlca.sqlcode THEN 
             CALL cl_err3("ins","hrdu_file",g_hrdu4.hrdu01,"",SQLCA.sqlcode,"","",0)
             ROLLBACK WORK
             EXIT FOREACH 
          END IF 
        END FOREACH 
         COMMIT WORK 
        CALL i089_b_fill_a(g_hrdu4.hrdu01,g_hrdu4.hrdu03)
      	 CALL ui.Interface.refresh()
      	 IF SQLCA.sqlcode THEN
            CONTINUE FOR
         ELSE 
            CONTINUE FOR
         END IF
      END IF 
   END FOR   
   CLOSE WINDOW i089_w1
   CALL i089_b_fill1(g_wc1,'')
END FUNCTION

FUNCTION i089_assign1_renewal() #续保
 DEFINE l_go    LIKE  type_file.chr1
 DEFINE l_n     LIKE  type_file.num5
 DEFINE l_des   LIKE  type_file.chr100
 DEFINE l_hrag  RECORD LIKE hrag_file.*
 DEFINE l_infor STRING
 DEFINE l_sql     STRING 
 DEFINE l_cnt     LIKE type_file.num5
 DEFINE l_hrdt02  LIKE hrdt_file.hrdt02
   IF g_rec_b1 = 0 THEN RETURN END IF 

   LET l_go = 'N'
   LET l_ac = ARR_CURR()

   INITIALIZE g_hrdu4.* TO NULL 
   
   IF NOT cl_confirm('abx-080') THEN RETURN END IF 
#   OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri891"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
#   CALL cl_ui_init()  
   
   LET g_hrdu4.hrdu03 = '001'
    OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri0891"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

 #  CALL cl_set_combo_items("hrdu02",NULL,NULL)
   CALL cl_set_combo_items("hrdu03",NULL,NULL)
   CALL cl_set_combo_items("hrdu05",NULL,NULL)
   CALL cl_set_combo_items("hrdu06",NULL,NULL)
   
  # CALL i089_get_hrdu02( ) RETURNING l_name,l_items
   #CALL cl_set_combo_items("hrdu02",l_name,l_items)
   CALL i089_get_items('621') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu03",l_name,l_items)
   CALL i089_get_hrdu05() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu05",l_name,l_items)
   CALL i089_get_items('612') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu06",l_name,l_items)
   
   WHILE TRUE
      DISPLAY BY NAME g_hrdu4.hrdu02,g_hrdu4.hrdu03,g_hrdu4.hrdu04 
      INPUT BY NAME g_hrdu4.hrdu02,g_hrdu4.hrdu03,g_hrdu4.hrdu04 
                    WITHOUT DEFAULTS 
        BEFORE INPUT                                    #預設查詢條件
      AFTER FIELD hrdu02
      IF NOT cl_null(g_hrdu4.hrdu02) THEN 
         SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file 
          WHERE hrdt01 = g_hrdu4.hrdu02
         DISPLAY l_hrdt02 TO hrdu02_n 
      END IF
      ON ACTION controlp
            CASE WHEN INFIELD(hrdu04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING g_hrdu4.hrdu04
               DISPLAY BY NAME g_hrdu4.hrdu04
               NEXT FIELD hrdu04
               WHEN INFIELD(hrdu02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrdt01"
               CALL cl_create_qry() RETURNING g_hrdu4.hrdu02
               DISPLAY BY NAME g_hrdu4.hrdu02
               NEXT FIELD hrdu02
            END CASE
            
        ON ACTION locale
              #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
       
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
      END INPUT  
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i089_w1 
         RETURN
      END IF  
      EXIT WHILE  
   END WHILE
   
   IF l_renewal='Y' THEN  #如果是续保
   	  DELETE FROM hrdu_file WHERE hrdu01=g_hrdu3[l_ac].hratidb
   	  COMMIT WORK
   END IF
   
  
   LET g_hrdu4.hrdu01 = g_hrdu3[l_ac].hratidb
   BEGIN WORK 
   
   LET l_sql=" SELECT hrdta02,hrdta03,hrdta04,hrdta08,hrdta04,hrdta09",
             "   FROM hrdta_file",
             "  WHERE hrdta01='",g_hrdu4.hrdu02,"'"
   PREPARE ins_p_renewal FROM l_sql
   DECLARE ins_c_renewal CURSOR FOR ins_p_renewal
   FOREACH ins_c_renewal INTO g_hrdu4.hrdu05,g_hrdu4.hrdu06,g_hrdu4.hrdu07,g_hrdu4.hrdu08,g_hrdu4.hrdu09,g_hrdu4.hrdu10
     INSERT INTO hrdu_file VALUES (g_hrdu4.*)
     IF sqlca.sqlcode THEN 
        CALL cl_err3("ins","hrdu_file",g_hrdu4.hrdu01,"",SQLCA.sqlcode,"","",0)
        ROLLBACK WORK
        EXIT FOREACH 
     END IF 
   END FOREACH 
    COMMIT WORK 
   CALL i089_b_fill_a(g_hrdu4.hrdu01,g_hrdu4.hrdu03)
   CALL ui.Interface.refresh() 
      
   CLOSE WINDOW i089_w1
   CALL i089_b_fill1(g_wc1,'')
END FUNCTION

FUNCTION i089_assign1_adjust() #调整
 DEFINE l_go    LIKE  type_file.chr1
 DEFINE l_n     LIKE  type_file.num5
 DEFINE l_des   LIKE  type_file.chr100
 DEFINE l_hrag  RECORD LIKE hrag_file.*
 DEFINE l_infor STRING
 DEFINE l_sql     STRING 
 DEFINE l_cnt     LIKE type_file.num5 
 DEFINE l_hrdt02  LIKE hrdt_file.hrdt02
   IF g_rec_b1 = 0 THEN RETURN END IF 

   LET l_go = 'N'
 
   INITIALIZE g_hrdu4.* TO NULL
   
   IF NOT cl_confirm('abx-080') THEN RETURN END IF 
#   OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri891"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
#   CALL cl_ui_init()  
   
   LET g_hrdu4.hrdu03 = '001'
    OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri0891"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
   LET l_ac = ARR_CURR()
    
   INITIALIZE g_hrdu_adjust.* TO NULL
   
   SELECT hrdu01,hrdu02,hrdu03,hrdu04
   INTO g_hrdu_adjust.hrdu01,g_hrdu_adjust.hrdu02,g_hrdu_adjust.hrdu03,g_hrdu_adjust.hrdu04  
   FROM hrdu_file 
   WHERE hrdu01=g_hrdu2[l_ac].hratida
   GROUP BY hrdu01,hrdu02,hrdu03,hrdu04
   
   #CALL cl_set_combo_items("hrdu02",NULL,NULL)
   #CALL cl_set_combo_items("hrdu03",NULL,NULL)
   #CALL cl_set_combo_items("hrdu05",NULL,NULL)
   #CALL cl_set_combo_items("hrdu06",NULL,NULL) 
   
   #CALL i089_get_hrdu02() RETURNING l_name,l_items
  # CALL cl_set_combo_items("hrdu02",l_name,l_items)
   LET g_hrdu4.hrdu02=g_hrdu_adjust.hrdu02  
   
   CALL i089_get_items('621') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu03",l_name,l_items)
   LET g_hrdu4.hrdu03=g_hrdu_adjust.hrdu03 
   
   CALL i089_get_hrdu05() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu05",l_name,l_items)
   CALL i089_get_items('612') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu06",l_name,l_items)
   
   LET g_hrdu4.hrdu04=g_hrdu_adjust.hrdu04 
    
   WHILE TRUE
      DISPLAY BY NAME g_hrdu4.hrdu02,g_hrdu4.hrdu03,g_hrdu4.hrdu04
                    
      INPUT BY NAME g_hrdu4.hrdu02,g_hrdu4.hrdu04
                    WITHOUT DEFAULTS
                    
        BEFORE INPUT                               #預設查詢條件
        
      AFTER FIELD hrdu02
      IF NOT cl_null(g_hrdu4.hrdu02) THEN 
         SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file 
          WHERE hrdt01 = g_hrdu4.hrdu02
         DISPLAY l_hrdt02 TO hrdu02_n 
      END IF
      
      ON ACTION controlp
         CASE 
            WHEN INFIELD(hrdu04)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrct11"
               CALL cl_create_qry() RETURNING g_hrdu4.hrdu04
               DISPLAY BY NAME g_hrdu4.hrdu04
               NEXT FIELD hrdu04
            WHEN INFIELD(hrdu02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_hrdt01"
               CALL cl_create_qry() RETURNING g_hrdu4.hrdu02
               DISPLAY BY NAME g_hrdu4.hrdu02
               NEXT FIELD hrdu02
         END CASE
            
        ON ACTION locale
              #CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
       
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
      END INPUT  
       
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i089_w1 
         RETURN
      END IF  
      EXIT WHILE  
   END WHILE  
    
   LET g_hrdu4.hrdu01 = g_hrdu2[l_ac].hratida
   CALL i089_b_fill_a_adjust(g_hrdu4.hrdu01,g_hrdu4.hrdu03)
   CALL ui.Interface.refresh() 
   
   CLOSE WINDOW i089_w1
   CALL i089_b_fill2( )
END FUNCTION

FUNCTION i089_b_fill_a_adjust(p_hrdu01,p_hrdu03)
DEFINE l_sql    STRING
DEFINE p_hrdu01 LIKE hrdu_file.hrdu01
DEFINE p_hrdu03 LIKE hrdu_file.hrdu03


   LET g_cnt=1
   CALL g_hrdu.clear()
   IF g_hrdu_adjust.hrdu02 = g_hrdu4.hrdu02 THEN 
      LET l_sql=" SELECT hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10",
                  "   FROM hrdu_file",
                  "  WHERE hrdu01='",p_hrdu01,"'",
                  " AND hrdu03='",p_hrdu03,"'"
   ELSE 
      LET l_sql = "INSERT INTO hrdu_file 
                     (HRDU01,HRDU02,HRDU03,HRDU04,HRDU05,HRDU06,HRDU07,HRDU08,HRDU09,HRDU10)
                    SELECT '$",p_hrdu01,"',hrdta01,'",p_hrdu03,"','",g_hrdu4.hrdu04,"',hrdta02,hrdta03,hrdta04,hrdta08,hrdta04,hrdta09 
                    FROM hrdta_file 
                    WHERE hrdta01='",g_hrdu4.hrdu02,"'"
      PREPARE i089_in FROM l_sql
      EXECUTE i089_in
      
      LET l_sql=" SELECT hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10",
                  "   FROM hrdu_file",
                  "  WHERE hrdu01='$",p_hrdu01,"'"
   END IF 
               
   PREPARE hrdu_fill_p_adjust FROM l_sql
   DECLARE hrdu_fill_c_adjust CURSOR FOR hrdu_fill_p_adjust
   FOREACH hrdu_fill_c_adjust INTO g_hrdu[g_cnt].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   
      LET g_cnt = g_cnt + 1
   END FOREACH
   
   CALL g_hrdu.deleteElement(g_cnt)
   LET g_rec_b4=g_cnt-1
   
   DISPLAY ARRAY g_hrdu TO s_hrdu.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE DISPLAY
   EXIT DISPLAY 
   END DISPLAY 
   
   CALL i089_b_a_adjust(p_hrdu01,p_hrdu03)
   IF g_hrdu_adjust.hrdu02 != g_hrdu4.hrdu02 THEN 
      LET l_sql = "DELETE FROM hrdu_file 
                    WHERE hrdu01='",p_hrdu01,"' AND hrdu03='",p_hrdu03,"'"
      PREPARE i089_de FROM l_sql
      EXECUTE i089_de
      
      LET l_sql = "UPDATE hrdu_file SET hrdu01='",p_hrdu01,"'
                    WHERE hrdu01='$",p_hrdu01,"'"
      PREPARE i089_up FROM l_sql
      EXECUTE i089_up
   END IF 
END FUNCTION 

FUNCTION i089_b_a_adjust(l_hrdu01,l_hrdu03)
DEFINE l_lock_sw       LIKE type_file.chr1
DEFINE l_hrdu01        LIKE hrdu_file.hrdu01
DEFINE l_hrdu03        LIKE hrdu_file.hrdu03

     LET g_forupd_sql = "SELECT hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10",
                        "  FROM hrdu_file",
                        " WHERE  hrdu01 = ? AND hrdu03=? AND hrdu05= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i089_cl_a_adjust CURSOR FROM g_forupd_sql
    
    INPUT ARRAY g_hrdu WITHOUT DEFAULTS FROM s_hrdu.*
      ATTRIBUTE (COUNT=g_rec_b4,MAXCOUNT=100000,UNBUFFERED,
                 INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)

        BEFORE INPUT
            IF g_rec_b4!=0 THEN 
               LET l_ac_a=1
            END IF
            
        BEFORE ROW
            LET l_lock_sw = 'N' 
            LET l_ac_a = ARR_CURR()                
            IF g_rec_b4 >= l_ac_a THEN    
               BEGIN WORK
               LET g_hrdu_t.* = g_hrdu[l_ac_a].*  #BACKUP
               IF g_hrdu_adjust.hrdu02 != g_hrdu4.hrdu02 THEN 
                  LET l_hrdu01='$',l_hrdu01
               END IF 
               OPEN i089_cl_a_adjust USING l_hrdu01,l_hrdu03,g_hrdu[l_ac_a].hrdu05
               IF STATUS THEN
                  CALL cl_err("OPEN i089_cl_a_adjust:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i089_cl_a_adjust INTO g_hrdu[l_ac_a].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(l_hrdu01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF 
               CALL cl_show_fld_cont()
            END IF
            
        ON ROW CHANGE
           IF INT_FLAG THEN                 #?板?绋.?娈
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdu[l_ac_a].* = g_hrdu_t.*
              CLOSE i089_cl_a_adjust
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(l_hrdu01,-263,0)
               LET g_hrdu[l_ac_a].* = g_hrdu_t.*
           ELSE
               UPDATE hrdu_file SET 
                                    hrdu05=g_hrdu[l_ac_a].hrdu05,
                                    hrdu06=g_hrdu[l_ac_a].hrdu06,
                                    hrdu07=g_hrdu[l_ac_a].hrdu07,
                                    hrdu08=g_hrdu[l_ac_a].hrdu08,
                                    hrdu09=g_hrdu[l_ac_a].hrdu09,
                                    hrdu10=g_hrdu[l_ac_a].hrdu10
                               WHERE hrdu01 = l_hrdu01
                                 AND hrdu03 = l_hrdu03
                                 AND hrdu05 = g_hrdu_t.hrdu05
                                 
               UPDATE hrdu_file SET hrdu02=g_hrdu_adjust.hrdu02,
                                    hrdu04=g_hrdu4.hrdu04
                               WHERE hrdu01 = l_hrdu01
                                 AND hrdu03 = l_hrdu03
                                 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","hrdu_file",l_hrdu01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-660131
                  LET g_hrdu[l_ac_a].* = g_hrdu_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
           END IF

        AFTER ROW
           LET l_ac_a = ARR_CURR()
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_hrdu[l_ac_a].* = g_hrdu_t.*
              CLOSE i089_cl_a_adjust
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i089_cl_a_adjust
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
    
    CLOSE i089_cl_a_adjust
    COMMIT WORK
END FUNCTION 

FUNCTION i089_stop() #停保
DEFINE l_ac like type_file.num5,
       l_msg like type_file.chr1000,
       l_hrat02 LIKE hrat_file.hrat02,
       l_hratid LIKE hrat_file.hratid,
       l_hrdt02 LIKE hrdt_file.hrdt02

   LET l_ac = ARR_CURR() 
   
   INITIALIZE g_hrdu_adjust.* TO NULL
   SELECT hrdu01,hrdu02,hrdu03,hrdu04
   INTO g_hrdu_adjust.hrdu01,g_hrdu_adjust.hrdu02,g_hrdu_adjust.hrdu03,g_hrdu_adjust.hrdu04  
   FROM hrdu_file 
   WHERE hrdu01=g_hrdu2[l_ac].hratida
   GROUP BY hrdu01,hrdu02,hrdu03,hrdu04
   SELECT hrat02,hratid INTO l_hrat02,l_hratid FROM hrat_file WHERE hrat01=g_hrdu_adjust.hrdu01
   LET g_hrdu_adjust.hrdu03 = '002'
   
   OPEN WINDOW i089_w1 WITH FORM "ghr/42f/ghri0891"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)              #介面風格透過p_zz設定
   CALL cl_ui_init()  
   
   CALL i089_get_items('621') RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdu03",l_name,l_items)
   
   WHILE TRUE
#      DISPLAY BY NAME g_hrdu_adjust.hrdu01,g_hrdu_adjust.hrdu02,g_hrdu_adjust.hrdu03,g_hrdu_adjust.hrdu04  
      INPUT BY NAME g_hrdu_adjust.hrdu04 
                    WITHOUT DEFAULTS 
      BEFORE INPUT
         DISPLAY BY NAME g_hrdu_adjust.hrdu02
         SELECT hrdt02 INTO l_hrdt02 FROM hrdt_file WHERE hrdt01 = g_hrdu_adjust.hrdu02
         DISPLAY l_hrdt02 TO hrdu02_n
         DISPLAY BY NAME g_hrdu_adjust.hrdu03
         
         ON ACTION controlp
            CASE 
               WHEN INFIELD(hrdu04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_hrct11"
                  CALL cl_create_qry() RETURNING g_hrdu_adjust.hrdu04
                  DISPLAY BY NAME g_hrdu_adjust.hrdu04
                  NEXT FIELD hrdu04
            END CASE
            
        ON ACTION locale
           #CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_action_choice = "locale"
           EXIT INPUT
       
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
       
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
       
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
       
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
       
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
      END INPUT 
      IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW i089_w1 
         RETURN
      END IF  
      EXIT WHILE  
   END WHILE    
   CLOSE WINDOW i089_w1 
   LET l_msg=g_hrdu2[l_ac].hratida,l_hrat02
   
   IF NOT cl_confirm2('ghr-255',l_msg)  THEN RETURN END IF 
    
    DELETE FROM HRDW_FILE
     WHERE HRDW01 = l_hratid
       AND EXISTS
     (SELECT 1
              FROM HRCT_FILE
             WHERE HRCT11 = HRDW03
               AND HRCT08 >= (SELECT HRCT08
                                FROM HRCT_FILE
                               WHERE HRCT11 = g_hrdu_adjust.hrdu04))
                            
   UPDATE hrdu_file SET hrdu03='002' ,hrduud01=g_hrdu_adjust.hrdu04
   WHERE hrdu01=g_hrdu_adjust.hrdu01 AND hrdu02=g_hrdu_adjust.hrdu02 
   COMMIT WORK 
   
   CALL i089_b_fill2( )
   
END FUNCTION 
 

FUNCTION i089_get_items_adjust(p_hrag01,p_hrag06)  #缴纳标志
DEFINE p_hrag01 LIKE  hrag_file.hrag01
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE p_hrag06 LIKE  hrag_file.hrag06
DEFINE p_hrag07 LIKE  hrag_file.hrag07
DEFINE l_sql    STRING

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrag06,hrag07 FROM hrag_file WHERE hrag01='",p_hrag01,"' and hrag06='",p_hrag06,"'",
                 "  ORDER BY hrag06"
       PREPARE i089_get_p_adjust FROM l_sql
       DECLARE i089_get_c_adjust CURSOR FOR i089_get_p_adjust
       FOREACH i089_get_c_adjust INTO p_hrag06,p_hrag07
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

FUNCTION i089_get_hrdu02_adjust(p_hrdt01)  #社会统筹
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE p_hrdt01 LIKE hrdt_file.hrdt01
DEFINE l_hrdt01 LIKE hrdt_file.hrdt01
DEFINE l_hrdt02 LIKE hrdt_file.hrdt02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrdt01,hrdt02 FROM hrdt_file ",
                 "  where hrdt01='",p_hrdt01,"'",
                 "  ORDER BY hrdt01"
       PREPARE i089_get_p2_adjust FROM l_sql
       DECLARE i089_get_c2_adjust CURSOR FOR i089_get_p2_adjust
       FOREACH i089_get_c2_adjust INTO l_hrdt01,l_hrdt02
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


FUNCTION i089_set_data1(l_cnt,l_turn)
	
  DEFINE l_cnt, l_turn LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE li_i,li_j LIKE type_file.num10          #No.FUN-690005 INTEGER
  DEFINE l_hrat    RECORD LIKE hrat_file.*
  DEFINE l_hrag    RECORD LIKE hrag_file.*
  CALL g_hrdu1.clear()
   LET li_j= 1
  LET g_rec_b1 = l_cnt + l_turn  
  
  FOR li_i = l_cnt+1 TO g_rec_b1 
      
      LET g_hrdu1[li_j].* = g_hrdu1_t[li_i].*
      
        SELECT hrad03 INTO g_hrdu1[li_j].hrad03 FROM hrad_file 
        WHERE hrad02=g_hrdu1[li_j].hrad03 AND rownum=1
        SELECT hrag07 INTO g_hrdu1[li_j].hrat30 FROM hrag_file
        WHERE hrag01='321'
         AND  hrag06=g_hrdu1[li_j].hrat30
      LET li_j = li_j + 1
  END FOR
 
END FUNCTION
	
FUNCTION i089_import()
DEFINE l_file     LIKE type_file.chr200
DEFINE l_count    LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE xlApp      INTEGER
DEFINE iRes       INTEGER
DEFINE iRow       INTEGER
DEFINE l_dept     LIKE hrao_file.hrao02
DEFINE l_empid    LIKE hrat_file.hratid
DEFINE l_code     LIKE hrat_file.hrat01
DEFINE l_name     LIKE hrat_file.hrat02
DEFINE l_year     LIKE hrct_file.hrct01
DEFINE l_month    LIKE hrct_file.hrct02
DEFINE l_type     LIKE hrdu_file.hrdu03
DEFINE l_kind     LIKE hrdu_file.hrdu02
DEFINE l_money1   LIKE hrdu_file.hrdu07
DEFINE l_money2   LIKE hrdu_file.hrdu09
DEFINE l_remark   LIKE hrdu_file.hrduud01
DEFINE l_hrct01   LIKE hrct_file.hrct01
DEFINE l_hrct02   LIKE hrct_file.hrct02
DEFINE l_hrct11   LIKE hrct_file.hrct11
DEFINE l_flag     LIKE type_file.num5
DEFINE l_msg  STRING
DEFINE i          LIKE type_file.num5

   LET l_file = cl_browse_file() 
   LET l_file = l_file CLIPPED
   IF NOT cl_null(l_file) THEN
      LET l_count=length(l_file)
      IF l_count=0 THEN 
         RETURN
      END IF 
      LET l_sql=l_file
      CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
      IF xlApp <> -1 THEN
         CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_sql],[iRes])
         IF iRes<>-1 THEN
            CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
            CALL cl_progress_bar(iROW-1)
            BEGIN WORK 
            FOR i=2 TO iRow
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_dept])  #读取员工部门
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_code])  #读取员工工号
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_name])  #读取员工姓名
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[l_type]) #读取缴交类型
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[l_kind]) #读取统筹体系
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[l_year]) #读取生效年度
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[l_month]) #读取生效月份
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[l_money1]) #读取保险基数
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[l_money2]) #读取公积金基数
               CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[l_remark]) #读取补刷卡备注
               IF cl_null(l_code) THEN 
                  CALL cl_progressing('')
                  CONTINUE FOR
               END IF
               SELECT hratid INTO l_empid FROM hrat_file WHERE hrat01=l_code
               SELECT COUNT(*) INTO l_flag FROM hrdta_file WHERE hrdta01=l_kind
               IF l_flag < 1 AND l_type != '002' THEN
                  CALL cl_progressing('统筹体系不存在')
                  LET l_msg="统筹体系编号:",l_kind,"不存在"
                  CALL cl_err(l_msg,'!',1)
                  CONTINUE FOR
               END IF
               IF l_hrct01 = l_year AND l_hrct02 = l_month THEN 
               ELSE 
                 SELECT hrct01,hrct02,hrct11 INTO l_hrct01,l_hrct02,l_hrct11 FROM hrct_file WHERE hrct03='0000' AND hrct01=l_year AND hrct02 = l_month
               END IF 
               IF l_type = '002' THEN 
                  UPDATE hrdu_file SET hrdu03='002',hrduud01=l_hrct11,HRDUMODU=g_user,HRDUDATE=g_today WHERE hrdu01=l_empid
               ELSE 
                  DELETE FROM hrdu_file WHERE hrdu01=l_empid
                  LET l_sql = "INSERT INTO hrdu_file (hrdu01,hrdu02,hrdu03,hrdu04,hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10,HRDUUSER,HRDUDATE) SELECT '",l_empid,"',hrdta01,'001','",l_hrct11,"',hrdta02,hrdta03, CASE"
                  IF cl_null(l_money1) OR l_money1 = 0 THEN #保险基数没有重新设定值
                     LET l_sql = l_sql," WHEN hrdta02<>'007' THEN hrdta04 "
                  ELSE 
                     LET l_sql = l_sql," WHEN hrdta02<>'007' AND ta_hrdta01='N' THEN ",l_money1
                  END IF 
                  IF cl_null(l_money2) OR l_money2 = 0 THEN #公积金基数没有重新设定值
                     LET l_sql = l_sql," WHEN hrdta02='007' THEN hrdta04 "
                  ELSE 
                     LET l_sql = l_sql," WHEN hrdta02='007' AND ta_hrdta01='N' THEN ",l_money2
                  END IF
                  LET l_sql = l_sql," ELSE hrdta04 END ,hrdta08, CASE"
                  
                  IF cl_null(l_money1) OR l_money1 = 0 THEN #保险基数没有重新设定值
                     LET l_sql = l_sql," WHEN hrdta02<>'007' THEN hrdta04 "
                  ELSE 
                     LET l_sql = l_sql," WHEN hrdta02<>'007' AND ta_hrdta01='N' THEN ",l_money1
                  END IF 
                  IF cl_null(l_money2) OR l_money2 = 0 THEN #公积金基数没有重新设定值
                     LET l_sql = l_sql," WHEN hrdta02='007' THEN hrdta04 "
                  ELSE 
                     LET l_sql = l_sql," WHEN hrdta02='007' AND ta_hrdta01='N' THEN ",l_money2
                  END IF
                  LET l_sql = l_sql," ELSE hrdta04 END ,hrdta09,'",g_user,"','",g_today,"' FROM hrdta_file WHERE hrdta01='",l_kind,"'"
                  PREPARE i089_01 FROM l_sql
                  EXECUTE i089_01
               END IF 
               CALL cl_progressing(l_name)
            END FOR 
            COMMIT WORK
         END IF 
      END IF 
   END IF 
      
END FUNCTION 
FUNCTION i089_tz1()  #add by shenran NO.130707
	DEFINE l_jump1    LIKE type_file.num10
	DEFINE l_jump2    LIKE type_file.num10
	DEFINE l_turn   LIKE type_file.num10
	DEFINE l_cnt      LIKE type_file.num10
	DEFINE l_input    LIKE type_file.chr1
	DEFINE l_j        LIKE type_file.num10
	                                  
	                                  
	  INPUT g_jump1 WITHOUT DEFAULTS FROM jump1
	                                  
	  BEFORE INPUT                    
          LET l_input='N'                 
          LET g_before_input_done = FALSE 
              CALL cl_set_comp_entry("jump1",TRUE)
          LET g_before_input_done = TRUE  
          #LET g_turn_t = g_turn                                      
	  CALL cl_set_comp_visible("accept,cancel",FALSE)
                                          
     AFTER FIELD jump1
        IF NOT cl_null(g_jump1) THEN
        	IF NOT (g_jump1 > g_jump2) THEN 
        	   LET l_cnt = (g_jump1 - 1) * g_turn
      	  ELSE                          
      	     CALL cl_err( '所录页数大于最大页数，请重新录入', '!', 1 )
      	     NEXT FIELD jump1
      	  END IF                        
        ELSE                                
      	  NEXT FIELD jump1 
      	END IF 
 
      ON ACTION HELP
         CALL cl_show_help()    
         CONTINUE INPUT
         
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()    
         CONTINUE INPUT
 
      ON ACTION close
         LET g_i = 1
         EXIT INPUT   

      ON ACTION EXIT
         LET g_i = 1
         EXIT INPUT   
     
      ON ACTION controlg 
         CALL cl_cmdask()
         CONTINUE INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
        ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")  
                                                                                                 
   END INPUT
    
   	CALL cl_set_comp_visible("accept,cancel",TRUE)
    CALL i089_b_fill1(g_wc2,l_cnt)
END FUNCTION

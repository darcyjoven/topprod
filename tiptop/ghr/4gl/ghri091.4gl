# Prog. Version..: '5.10.03-08.08.20(009)''     #
#
# Pattern name...: ghri091
# Descriptions...: 员工社会统筹计算
# Date & Author..: 13/07/12 zhangbo
#150407插入统筹区域 
DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_sql         STRING,
       g_wc1         STRING,
       g_wc2         STRING                                           
DEFINE g_hrdw  DYNAMIC ARRAY OF RECORD
         hrdw01      LIKE   hrdw_file.hrdw01,
         hrat02      LIKE   hrat_file.hrat02,
         hrat04      LIKE   hrao_file.hrao02,
         hrat05      LIKE   hras_file.hras04,
         hrdw04      LIKE   hrdw_file.hrdw04,
         hrdw05      LIKE   hrdw_file.hrdw05,
         hrdw03      LIKE   hrdw_file.hrdw03,
         hrdw06      LIKE   hrdw_file.hrdw06,
         hrdw07      LIKE   hrdw_file.hrdw07,
         hrdw08      LIKE   hrdw_file.hrdw08,
         hrdw02      LIKE   hrdw_file.hrdw02,
         hrad03      LIKE   hrad_file.hrad03
               END RECORD,
         g_rec_b1      LIKE type_file.num5,
         l_ac1         LIKE type_file.num5
DEFINE g_hrdw03        LIKE hrdw_file.hrdw03 
DEFINE g_hrdw03_t      LIKE hrdw_file.hrdw03             
DEFINE g_hrdu  DYNAMIC ARRAY OF RECORD
         hrdu01      LIKE   hrdu_file.hrdu01,
         hrat02      LIKE   hrat_file.hrat02,
         hrat04      LIKE   hrao_file.hrao02,
         hrat05      LIKE   hras_file.hras04,
         hrat25      LIKE   hrat_file.hrat25,
         hrat03      LIKE   hraa_file.hraa12,
         hrat19      LIKE   hrad_file.hrad03
               END RECORD,
         g_rec_b2      LIKE type_file.num5,
         l_ac2         LIKE type_file.num5
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
 
   OPEN WINDOW i091_w WITH FORM "ghr/42f/ghri091"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_set_combo_items("hrdw02",NULL,NULL)

   #统筹参数
   CALL i091_get_hrdw02() RETURNING l_name,l_items
   CALL cl_set_combo_items("hrdw02",l_name,l_items)
          
   CALL cl_ui_init()
   
   LET g_wc1=" 1=1"
   
#   CALL i091_b_fill()
      
   CALL i091_menu()
   CLOSE WINDOW i091_w        
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION i091_get_hrdw02()
DEFINE p_name   STRING
DEFINE p_items  STRING
DEFINE l_sql    STRING
DEFINE l_hrds01 LIKE hrds_file.hrds01
DEFINE l_hrds02 LIKE hrds_file.hrds02

       LET p_name=''
       LET p_items=''
       
       LET l_sql=" SELECT hrds01,hrds02 FROM hrds_file ",
                 "  ORDER BY hrds01"
       PREPARE i091_get_hrdw02_pre FROM l_sql
       DECLARE i091_get_hrdw02 CURSOR FOR i091_get_hrdw02_pre
       FOREACH i091_get_hrdw02 INTO l_hrds01,l_hrds02
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
	
FUNCTION i091_menu()
DEFINE l_n   LIKE  type_file.num5
 
   WHILE TRUE
      CALL i091_bp("G")    
                         
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i091_q()   
            END IF
         
         WHEN "fulijs"
            IF cl_chk_act_auth() THEN
               CALL i091_js()   
              # CALL i091_b_fill()
            END IF   	
            	                                                                                                                                                                                                                          
         WHEN "help" 
            CALL cl_show_help()
            
         WHEN "exit"
            EXIT WHILE
            	
         WHEN "controlg"
            CALL cl_cmdask()
            
         WHEN "exporttoexcel"   #No.FUN-4B0020
            IF cl_chk_act_auth() THEN
               CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_hrdw),'','')
            END IF
      END CASE
   END WHILE
 
END FUNCTION	

FUNCTION i091_q()
   CALL i091_b_askkey()
END FUNCTION

FUNCTION i091_b_askkey()
    CLEAR FORM
    CALL g_hrdw.clear()
 
    CONSTRUCT g_wc1 ON hrat01,hrat02,hrao02,hras04,hrdw04,hrdw05,hrdw03,hrdw06,hrdw07,hrdw08,hrdw02,hrad03                       
         FROM s_hrdw[1].hrdw01,s_hrdw[1].hrat02,s_hrdw[1].hrat04,s_hrdw[1].hrat05,s_hrdw[1].hrdw04,s_hrdw[1].hrdw05,
              s_hrdw[1].hrdw03,s_hrdw[1].hrdw06,s_hrdw[1].hrdw07,
              s_hrdw[1].hrdw08,s_hrdw[1].hrdw02,s_hrdw[1].hrad03
 
     BEFORE CONSTRUCT
        CALL cl_qbe_init()
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(hrdw01)
           CALL cl_init_qry_var()
           LET g_qryparam.form  = "q_hrat01"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO s_hrdw[1].hrdw01
           NEXT FIELD hrdw01
           
           WHEN INFIELD(hrdw03)
           CALL cl_init_qry_var()
           LET g_qryparam.form  = "q_hrct11"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO s_hrdw[1].hrdw03
           NEXT FIELD hrdw03
        	 
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
 
    CALL i091_b_fill()
 
END FUNCTION 
	
FUNCTION i091_b_fill()
	  
	  LET g_sql=" SELECT hrat01,hrat02,hrao02,hras04,hrdw04,hrdw05,hrdw03,",
	            "        hrdw06,hrdw07,hrdw08,hrdw02,hrad03 ",
	            "   FROM hrdw_file ",
	            "   LEFT JOIN hrat_file ON hratId=hrdw01",
	            "   LEFT JOIN hrao_file ON hrao01=hrat04",
	            "   LEFT JOIN hras_file ON hras01=hrat05",
	            "   LEFT JOIN hrad_file ON hrad02=hrat19",
	            "  WHERE ",g_wc1 CLIPPED,
	            "  ORDER BY hrdw01,hrdw02,hrdw03"
	  PREPARE i091_pb1 FROM g_sql
          DECLARE hrdw_curs CURSOR FOR i091_pb1
 
    CALL g_hrdw.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH hrdw_curs INTO g_hrdw[g_cnt].*  
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           EXIT FOREACH
        END IF
        	
#        SELECT hrat01 INTO g_hrdw[g_cnt].hrdw01 
#          FROM hrat_file 
#         WHERE hratid=g_hrdw[g_cnt].hrdw01
#        SELECT hrat02 INTO g_hrdw[g_cnt].hrat02 
#          FROM hrat_file 
#         WHERE hrat01=g_hrdw[g_cnt].hrdw01
#        SELECT hrao02 INTO g_hrdw[g_cnt].hrat04
#          FROM hrat_file,hrao_file
#         WHERE hrat01=g_hrdw[g_cnt].hrdw01
#           AND hrat04=hrao01
#        SELECT hras04 INTO g_hrdw[g_cnt].hrat05
#          FROM hrat_file,hras_file
#         WHERE hrat01=g_hrdw[g_cnt].hrdw01
#           AND hras01=hrat05        	
         
        LET g_cnt = g_cnt + 1
        
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_hrdw.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    DISPLAY g_rec_b1 TO FORMONLY.cn2  
    LET g_cnt = 0          
    	                 	
END FUNCTION
	
FUNCTION i091_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_row_count = 0               #No.TQC-680158 add
   LET g_curs_index = 0              #No.TQC-680158 add
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
  
   DIALOG ATTRIBUTES(UNBUFFERED)
                 
      
      DISPLAY ARRAY g_hrdw TO s_hrdw.*  ATTRIBUTE(COUNT=g_rec_b1)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac1 = ARR_CURR()
         CALL cl_show_fld_cont()          
     
      END DISPLAY 
      
      
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      
      ON ACTION fulijs
         LET g_action_choice="fulijs"
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
	
FUNCTION i091_js()
DEFINE l_n   LIKE   type_file.num5

	
   OPEN WINDOW i091_w1 WITH FORM "ghr/42f/ghri0911"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
   WHILE TRUE
   	
   	  DIALOG ATTRIBUTES(UNBUFFERED)
   	     INPUT g_hrdw03 FROM hrdw03 ATTRIBUTES(WITHOUT DEFAULTS)
   	     
   	     AFTER FIELD hrdw03
   	        IF NOT cl_null(g_hrdw03) THEN
   	           LET l_n=0
   	           SELECT COUNT(*) INTO l_n FROM hrct_file 
   	            WHERE hrct11=g_hrdw03
   	           IF l_n=0 THEN
   	              CALL cl_err('无此薪资月','!',0)
   	              NEXT FIELD hrdw03
   	           END IF  
   	        END IF
                IF g_hrdw03_t IS NULL OR g_hrdw03 != g_hrdw03_t THEN
   	           CALL g_hrdu.clear()	
   	           LET g_rec_b2=0
                   DISPLAY g_rec_b2 TO FORMONLY.cn2 
   	        END IF
                
                LET g_hrdw03_t=g_hrdw03
	
   	     ON ACTION controlp
             CASE
               WHEN INFIELD(hrdw03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_hrct11"
               LET g_qryparam.default1 = g_hrdw03
               CALL cl_create_qry() RETURNING g_hrdw03
               DISPLAY g_hrdw03 TO hrdw03
               NEXT FIELD hrdw03
             END CASE

      #ON ACTION accept
      #   LET INT_FLAG=0
      #   EXIT DIALOG

      #ON ACTION cancel
      #   LET INT_FLAG=1
      #   EXIT DIALOG

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
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913

   END INPUT
   #add by zhuzw 20141126 start
    CONSTRUCT BY NAME g_wc2 ON hrat01
       BEFORE CONSTRUCT
         CALL cl_qbe_init()

       ON ACTION controlp
          CASE
            WHEN INFIELD(hrat01)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_hrat01_91"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO hrat01
              NEXT FIELD hrat01
            OTHERWISE
              EXIT CASE
          END CASE
      
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
       AFTER CONSTRUCT 
         CALL i091_b2_fill() #add by zhuzw 20141126   
    END CONSTRUCT   
   # CALL i091_b2_fill() #add by zhuzw 20141126
   #add by zhuzw 20141126 end    
   DISPLAY ARRAY g_hrdu TO s_hrdu.*  ATTRIBUTE(COUNT=g_rec_b2)
            
      BEFORE DISPLAY
         IF g_rec_b2 != 0 THEN
            CALL fgl_set_arr_curr(l_ac2)
         END IF
         #DISPLAY g_rec_b2 TO FORMONLY.cn2
        
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()
      
      ON ACTION close
         LET INT_FLAG=1
         EXIT DIALOG      

      ON ACTION exit
         LET INT_FLAG=1
         EXIT DIALOG   
#mark by zhuzw 20141126 strat
#      ON ACTION sel
#         IF NOT cl_null(g_hrdw03) THEN
#            
#            CALL i091_b2_fill()
#         ELSE
#            CALL cl_err('请先选择薪资月','!',1)
#         END IF
#mark by zhuzw 20141126 end 
      ON ACTION count
         IF g_hrdu.getLength()>0 THEN
            CALL i091_jisuan()
         ELSE
            CALL cl_err('请先选择员工','!',1)
         END IF   
                       
      END DISPLAY 
      
      #mark by zhangbo130717
      {
      ON ACTION sel
         IF NOT cl_null(g_hrdw03) THEN
            CALL i091_b2_fill()
         ELSE
            CALL cl_err('请先选择薪资月','!',1)
         END IF	     
      
      ON ACTION count
         IF g_hrdu.getLength()>0 THEN
            CALL i091_jisuan()
         ELSE
            CALL cl_err('请先选择员工','!',1)
         END IF
       }	     
      #mark by zhangbo130717      
   
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
      #CLOSE WINDOW i091_w1
      EXIT WHILE
   END IF      		 		    
   	
   END WHILE
   
   CLOSE WINDOW i091_w1 		
	
END FUNCTION	
	
FUNCTION i091_b2_fill()
DEFINE l_sql       STRING
DEFINE l_hrat03    LIKE hrat_file.hrat03
DEFINE l_hrct08    LIKE hrct_file.hrct08 
DEFINE l_cnt       LIKE type_file.num5 
     
      SELECT hrct03,hrct08 INTO l_hrat03,l_hrct08 FROM hrct_file 
       WHERE hrct11=g_hrdw03
      
      CALL g_hrdu.clear()
      
# 20150319 ADD BY yinbq 将停保人员查询出来，方便计算时进行删除
      LET l_sql=" SELECT DISTINCT HRDU01, '', '', '', '', '', '' ",
                "  FROM HRDU_FILE ",
                "  LEFT JOIN HRAT_FILE q ON HRDU01 = HRATID ",
                "  LEFT JOIN HRCT_FILE b ON HRDU04 = b.HRCT11 ",
                "  LEFT JOIN HRCT_FILE c ON HRDUud01 = c.HRCT11 ",
                " WHERE  ",
                "   b.HRCT08 <= '",l_hrct08,"'",
                "   AND nvl(c.HRCT08,to_date('2099-12-31','yyyy-mm-dd')) >= '",l_hrct08,"'",
                "   AND ",g_wc2,
                " ORDER BY HRDU01 "

   #   LET l_sql=" SELECT DISTINCT hrdu01,'','','','','','' ",
   #             "   FROM hrdu_file,hrat_file,hrct_file ",
   #             "  WHERE hrdu01=hratid AND hrdu04=hrct11 ",
         #       "    AND hrat03='",l_hrat03,"' ",
  #              "    AND hrct08<='",l_hrct08,"' ",
  #              "    AND hrdu03='001' ",
  #              "    AND ",g_wc2, #add by zhuzw 20141126
  #              "  ORDER BY hrdu01 "
# 20150319 ADD BY yinbq 将停保人员查询出来，方便计算时进行删除
      PREPARE i091_hrdu_pre FROM l_sql
      DECLARE i091_hrdu CURSOR FOR i091_hrdu_pre
      
      LET l_cnt=1
      
      FOREACH i091_hrdu INTO g_hrdu[l_cnt].*
         
         SELECT hrat01 INTO g_hrdu[l_cnt].hrdu01 
           FROM hrat_file
          WHERE hratid=g_hrdu[l_cnt].hrdu01 
          
         SELECT hrat02 INTO g_hrdu[l_cnt].hrat02
           FROM hrat_file
          WHERE hrat01=g_hrdu[l_cnt].hrdu01
        
         SELECT hrao02 INTO g_hrdu[l_cnt].hrat04 
           FROM hrao_file,hrat_file
          WHERE hrat01=g_hrdu[l_cnt].hrdu01
            AND hrat04=hrao01
         
         SELECT hras04 INTO g_hrdu[l_cnt].hrat05 
           FROM hras_file,hrat_file
          WHERE hrat01=g_hrdu[l_cnt].hrdu01
            AND hrat05=hras01
         
         SELECT hrat25 INTO g_hrdu[l_cnt].hrat25
           FROM hrat_file
          WHERE hrat01=g_hrdu[l_cnt].hrdu01
         
         SELECT hraa12 INTO g_hrdu[l_cnt].hrat03
           FROM hraa_file,hrat_file
          WHERE hrat01=g_hrdu[l_cnt].hrdu01
            AND hrat03=hraa01
         
         SELECT hrad03 INTO g_hrdu[l_cnt].hrat19
           FROM hrad_file,hrat_file
          WHERE hrat01=g_hrdu[l_cnt].hrdu01
            AND hrat19=hrad02       
         
         LET l_cnt=l_cnt+1
           
      END FOREACH
        
      CALL g_hrdu.deleteElement(l_cnt)   
      LET l_cnt=l_cnt-1
      LET g_rec_b2=l_cnt 
      DISPLAY g_rec_b2 TO FORMONLY.cn2
             
      
END FUNCTION 
	
FUNCTION i091_jisuan()
DEFINE l_n,l_i       LIKE   type_file.num5
DEFINE l_hratid      LIKE   hrat_file.hratid
DEFINE l_hrdw        RECORD LIKE  hrdw_file.*
DEFINE l_hrdu02      LIKE   hrdu_file.hrdu02
DEFINE l_hrdu05      LIKE   hrdu_file.hrdu05
DEFINE l_hrdu06      LIKE   hrdu_file.hrdu06
DEFINE l_hrdu07      LIKE   hrdu_file.hrdu07
DEFINE l_hrdu08      LIKE   hrdu_file.hrdu08
DEFINE l_hrdu09      LIKE   hrdu_file.hrdu09
DEFINE l_hrdu10      LIKE   hrdu_file.hrdu10
DEFINE l_max,l_min   LIKE   hrdw_file.hrdw04
DEFINE l_hrdv02      LIKE   hrdv_file.hrdv02
DEFINE l_hrdv07      LIKE   hrdv_file.hrdv07
DEFINE l_hrdv08      LIKE   hrdv_file.hrdv08
DEFINE l_hrdv09      LIKE   hrdv_file.hrdv09
DEFINE l_hrdv10      LIKE   hrdv_file.hrdv10
DEFINE l_hrdv11      LIKE   hrdv_file.hrdv11
DEFINE l_hrdta06      LIKE   hrdta_file.hrdta06
DEFINE l_hrdta07      LIKE   hrdta_file.hrdta07
DEFINE l_hrdv12      LIKE   hrdv_file.hrdv12
DEFINE l_hrdvud10      LIKE   hrdv_file.hrdvud10
DEFINE l_x,l_y       LIKE   hrdw_file.hrdw04
DEFINE l_sql         STRING
DEFINE l_hrct08      LIKE hrct_file.hrct08

       	
       LET g_success='Y'
       BEGIN WORK
#       IF SQLCA.sqlcode THEN
#       	  #LET g_success='N'
#       	  CALL cl_err('清空本月福利记录不成功','!','1')
#       	  ROLLBACK WORK       	  
#       	  RETURN
#       END IF       	
       FOR l_i=1 TO g_rec_b2
       
          LET l_hrdw.hrdw03=g_hrdw03
          LET l_hrdw.hrdw04=0
          LET l_hrdw.hrdw05=0
          LET l_hrdw.hrdw06=0
          LET l_hrdw.hrdw07=0
          LET l_hrdw.hrdwuser=g_user
          LET l_hrdw.hrdwgrup=g_grup
          LET l_hrdw.hrdworiu=g_user
          LET l_hrdw.hrdworig=g_grup
          LET l_hrdw.hrdwdate=g_today
          LET l_hrdw.hrdwacti='Y'
          #LET l_hrdw.hrdwud02=l_hrdu02 #150407插入统筹区域 
       
          SELECT hrct08 INTO l_hrct08 FROM hrct_file WHERE hrct11=g_hrdw03
          SELECT hratid INTO l_hrdw.hrdw01 FROM hrat_file 
           WHERE hrat01=g_hrdu[l_i].hrdu01  
          SELECT hrdt03 INTO l_hrdw.hrdwud02 FROM hrdt_file inner join hrdu_file on hrdt01=hrdu02 WHERE hrdu01=l_hrdw.hrdw01 GROUP BY hrdt03 #150407插入统筹区域       
       #add by zhuzw 20141126 start
          LET l_n=0
          SELECT COUNT(*) INTO l_n FROM hrdw_file WHERE hrdw03=g_hrdw03 AND hrdw01 = l_hrdw.hrdw01
          IF l_n>0 THEN
             DELETE FROM hrdw_file WHERE hrdw03=g_hrdw03 AND hrdw01 = l_hrdw.hrdw01
          END IF 
       #add by zhuzw 20141126 end 
          #本月应缴
          LET l_sql=" SELECT hrdu02,hrdu05,hrdu06,hrdu07,hrdu08,hrdu09,hrdu10,hrdta06,hrdta07 ",
                    "   FROM hrdu_file ",
                    "   left join hrdta_file on hrdta01=hrdu02 and hrdta02=hrdu05 ",
                    "   LEFT JOIN HRCT_FILE B ON B.HRCT11 = HRDU04",
                    "   LEFT JOIN HRCT_FILE E ON E.HRCT11 = HRDUUD01",
                    "  WHERE hrdu01='",l_hrdw.hrdw01,"' ",
#                    "    AND hrdu03='001'",
                    "    AND TO_DATE('",l_hrct08,"', 'yyyy-mm-dd') >= B.HRCT08",
                    "    AND TO_DATE('",l_hrct08,"', 'yyyy-mm-dd') < NVL(E.HRCT08, TO_DATE('20991231', 'yyyymmdd'))",
                    "  ORDER BY hrdu01,hrdu02,hrdu05 "
          PREPARE i091_js_pre1 FROM l_sql
          DECLARE i091_js_cs1 CURSOR FOR i091_js_pre1
          
          FOREACH i091_js_cs1 INTO l_hrdu02,l_hrdu05,l_hrdu06,
                                   l_hrdu07,l_hrdu08,l_hrdu09,l_hrdu10,l_hrdta06,l_hrdta07
                                   
             LET l_hrdw.hrdw02=l_hrdu05
            
             IF l_hrdu06='001' THEN
             	  #LET l_hrdw.hrdw04=l_hrdu09*l_hrdu10
#             	  select 
             	  CASE 
             	      WHEN l_hrdta06='002' 
             	         SELECT ROUND(l_hrdu09*l_hrdu10,l_hrdta07) INTO l_hrdw.hrdw04 FROM dual
             	      WHEN l_hrdta06='003' 
             	         SELECT TRUNC(l_hrdu09*l_hrdu10,l_hrdta07)  INTO l_hrdw.hrdw04 FROM dual
             	      WHEN l_hrdta06='004' 
             	         SELECT CEIL(l_hrdu09*l_hrdu10*POWER(10,l_hrdta07))/POWER(10,l_hrdta07)  INTO l_hrdw.hrdw04 FROM dual
             	      WHEN l_hrdta06='001' 
             	         SELECT l_hrdu09*l_hrdu10 INTO l_hrdw.hrdw04 FROM dual
             	  END CASE 
             	  CASE 
             	      WHEN l_hrdta06='002' 
             	         SELECT ROUND(l_hrdu07*l_hrdu08,l_hrdta07) INTO l_hrdw.hrdw05 FROM dual
             	      WHEN l_hrdta06='003' 
             	         SELECT TRUNC(l_hrdu07*l_hrdu08,l_hrdta07) INTO l_hrdw.hrdw05 FROM dual
             	      WHEN l_hrdta06='004' 
             	         SELECT CEIL(l_hrdu07*l_hrdu08*POWER(10,l_hrdta07))/POWER(10,l_hrdta07)  INTO l_hrdw.hrdw05 FROM dual
             	      WHEN l_hrdta06='001' 
             	         SELECT l_hrdu07*l_hrdu08 INTO l_hrdw.hrdw05 FROM dual
             	  END CASE 
#             	  select ROUND(l_hrdu09*l_hrdu10,2) into l_hrdw.hrdw04 from dual
             	  #LET l_hrdw.hrdw05=l_hrdu07*l_hrdu08
             	  #select ROUND(l_hrdu07*l_hrdu08,2) into l_hrdw.hrdw05 from dual
             ELSE
             	  CALL i091_pro(l_hrdw.hrdw01,l_hrdw.hrdw03,l_hrdu02,l_hrdu05)	                         
                   RETURNING l_x
                #LET l_hrdw.hrdw04=l_x*l_hrdu10
             	  CASE 
             	      WHEN l_hrdta06='002'  SELECT ROUND(l_x*l_hrdu10,l_hrdta07) INTO l_hrdw.hrdw04 FROM dual
             	      WHEN l_hrdta06='003'  SELECT TRUNC(l_x*l_hrdu10,l_hrdta07) INTO l_hrdw.hrdw04 FROM dual
             	      WHEN l_hrdta06='004'  SELECT CEIL(l_x*l_hrdu10*POWER(10,l_hrdta07))/POWER(10,l_hrdta07) INTO l_hrdw.hrdw04 FROM dual
             	      WHEN l_hrdta06='001'  SELECT l_x*l_hrdu10 INTO l_hrdw.hrdw04 FROM dual
             	  END CASE 
             	  #select ROUND(l_x*l_hrdu10,2) into l_hrdw.hrdw04 from dual
                #LET l_hrdw.hrdw05=l_x*l_hrdu08  
             	  CASE 
             	      WHEN l_hrdta06='002'  SELECT ROUND(l_x*l_hrdu08,l_hrdta07) INTO l_hrdw.hrdw05 FROM dual
             	      WHEN l_hrdta06='003'  SELECT TRUNC(l_x*l_hrdu08,l_hrdta07) INTO l_hrdw.hrdw05 FROM dual
             	      WHEN l_hrdta06='004'  SELECT CEIL(l_x*l_hrdu08*POWER(10,l_hrdta07))/POWER(10,l_hrdta07) INTO l_hrdw.hrdw05 FROM dual
             	      WHEN l_hrdta06='001'  SELECT l_x*l_hrdu08 INTO l_hrdw.hrdw05 FROM dual
             	  END CASE 
             	  #select ROUND(l_x*l_hrdu08,2) into l_hrdw.hrdw05 from dual
             END IF

             IF cl_null(l_hrdw.hrdw04) THEN 
             	  LET l_hrdw.hrdw04=0
             END IF
             	
             IF cl_null(l_hrdw.hrdw05) THEN 
             	  LET l_hrdw.hrdw05=0
             END IF	
             		  	
             LET l_min=0
             LET l_max=0
             SELECT hrdta12,hrdta13 INTO l_min,l_max FROM hrdta_file
              WHERE hrdta01=l_hrdu02
                AND hrdta02=l_hrdu05
             IF cl_null(l_min) THEN LET l_min=0 END IF
             IF cl_null(l_max) THEN LET l_max=0 END IF
             IF l_hrdw.hrdw04<l_min THEN
             	  LET l_hrdw.hrdw04=l_min
             ELSE
             	  IF l_hrdw.hrdw04>l_max and l_max!=0 THEN
             	  	 LET l_hrdw.hrdw04=l_max
             	  END IF	 	  
             END IF
             #个别地区社保按比例缴交的基础之上还会额外追加一定金额的费用，公司和个人的这部门费用暂时记录在HRDTAUD07（公司）与HRDTAUD08（个人）两个字段上
             #SELECT nvl(HRDTAUD07,0),nvl(HRDTAUD08,0) INTO l_min,l_max FROM hrdta_file
             # WHERE hrdta01=l_hrdu02
             #   AND hrdta02=l_hrdu05
             #LET l_hrdw.hrdw04=l_hrdw.hrdw04+l_max
             #LET l_hrdw.hrdw05=l_hrdw.hrdw05+l_min
             #结束
             
             INSERT INTO hrdw_file VALUES (l_hrdw.*)
             
             IF SQLCA.sqlcode THEN
             	  LET g_success='N'
             	  CALL cl_err('计算结果保存出错','!',1)
             	  EXIT FOREACH
             END IF	     	
             	
          END FOREACH
          
          IF g_success='N' THEN EXIT FOR END IF
          
          #本月补缴	
          LET l_sql=" SELECT hrdv02,hrdv07,hrdv08,hrdv09,hrdv10,hrdv11,hrdv12,(b.hrct04*12+b.hrct05)-(a.hrct04*12+a.hrct05)+1 hrdvud10,hrdta06,hrdta07 ",
                    "   FROM hrdv_file ",
                    "  left join hrct_file a on a.hrct11=hrdv05",
                    "  left join hrct_file b on b.hrct11=hrdv06",
                    "  left join hrdta_file on hrdta01=hrdv02 and hrdta02=hrdv07",
                    "  WHERE hrdv01='",l_hrdw.hrdw01,"' ",
                    "    AND hrdv04='",l_hrdw.hrdw03,"' ",
                    "  ORDER BY hrdv01,hrdv02,hrdv07 "     
          PREPARE i091_js_pre2 FROM l_sql
          DECLARE i091_js_cs2 CURSOR FOR i091_js_pre2
          
          FOREACH i091_js_cs2 INTO l_hrdv02,l_hrdv07,l_hrdv08,
                                   l_hrdv09,l_hrdv10,l_hrdv11,l_hrdv12,l_hrdvud10,l_hrdta06,l_hrdta07
                                   
             LET l_hrdw.hrdw02=l_hrdv07
             
             IF l_hrdv08='001' THEN
             	  #LET l_hrdw.hrdw06=l_hrdv11*l_hrdv12
            CASE 
               WHEN l_hrdta06='002'  SELECT ROUND(l_hrdv11*l_hrdv12,l_hrdta07)*l_hrdvud10 INTO l_hrdw.hrdw06 FROM dual
               WHEN l_hrdta06='003'  SELECT TRUNC(l_hrdv11*l_hrdv12,l_hrdta07)*l_hrdvud10 INTO l_hrdw.hrdw06 FROM dual
               WHEN l_hrdta06='004'  SELECT CEIL(l_hrdv11*l_hrdv12*POWER(10,l_hrdta07))*l_hrdvud10/POWER(10,l_hrdta07)  INTO l_hrdw.hrdw06 FROM dual
               WHEN l_hrdta06='001'  SELECT l_hrdv11*l_hrdv12*l_hrdvud10 INTO l_hrdw.hrdw06 FROM dual
            END CASE 
             	  #select ROUND(l_hrdv11*l_hrdv12,2)*l_hrdvud10 into l_hrdw.hrdw06 from dual
             	  #LET l_hrdw.hrdw07=l_hrdv09*l_hrdv10
            CASE 
               WHEN l_hrdta06='002'  SELECT ROUND(l_hrdv09*l_hrdv10,l_hrdta07)*l_hrdvud10 INTO l_hrdw.hrdw07 FROM dual
               WHEN l_hrdta06='003'  SELECT TRUNC(l_hrdv09*l_hrdv10,l_hrdta07)*l_hrdvud10 INTO l_hrdw.hrdw07 FROM dual
               WHEN l_hrdta06='004'  SELECT CEIL(l_hrdv09*l_hrdv10*POWER(10,l_hrdta07))*l_hrdvud10/POWER(10,l_hrdta07) INTO l_hrdw.hrdw07 FROM dual
               WHEN l_hrdta06='001'  SELECT l_hrdv09*l_hrdv10*l_hrdvud10 INTO l_hrdw.hrdw07 FROM dual
            END CASE 
             	  #select ROUND(l_hrdv09*l_hrdv10,2)*l_hrdvud10 into l_hrdw.hrdw07 from dual
             ELSE
             	  CALL i091_pro(l_hrdw.hrdw01,l_hrdw.hrdw03,l_hrdv02,l_hrdv07)	                         
                   RETURNING l_y
                #LET l_hrdw.hrdw06=l_y*l_hrdv12
            CASE 
               WHEN l_hrdta06='002' SELECT ROUND(l_y*l_hrdv12,l_hrdta07) INTO l_hrdw.hrdw06 FROM dual
               WHEN l_hrdta06='003' SELECT TRUNC(l_y*l_hrdv12,l_hrdta07)  INTO l_hrdw.hrdw06 FROM dual
               WHEN l_hrdta06='004' SELECT CEIL(l_y*l_hrdv12*POWER(10,l_hrdta07))/POWER(10,l_hrdta07)  INTO l_hrdw.hrdw06 FROM dual
               WHEN l_hrdta06='001' SELECT l_y*l_hrdv12  INTO l_hrdw.hrdw06 FROM dual
            END CASE 
             	  #select ROUND(l_y*l_hrdv12,2)*l_hrdvud10 into l_hrdw.hrdw06 from dual
                #LET l_hrdw.hrdw07=l_y*l_hrdv10 
            CASE 
               WHEN l_hrdta06='002' SELECT ROUND(l_y*l_hrdv10,l_hrdta07) INTO l_hrdw.hrdw07 FROM dual
               WHEN l_hrdta06='003' SELECT TRUNC(l_y*l_hrdv10,l_hrdta07) INTO l_hrdw.hrdw07 FROM dual
               WHEN l_hrdta06='004' SELECT CEIL(l_y*l_hrdv10*POWER(10,l_hrdta07))/POWER(10,l_hrdta07) INTO l_hrdw.hrdw07 FROM dual
               WHEN l_hrdta06='001' SELECT l_y*l_hrdv10 INTO l_hrdw.hrdw07 FROM dual
            END CASE 
             	  #select ROUND(l_y*l_hrdv10,2)*l_hrdvud10 into l_hrdw.hrdw07 from dual 
             END IF
             	
             IF cl_null(l_hrdw.hrdw06) THEN 
             	  LET l_hrdw.hrdw06=0
             END IF
             	
             IF cl_null(l_hrdw.hrdw07) THEN 
             	  LET l_hrdw.hrdw07=0
             END IF
             	
             LET l_n=0 
             SELECT COUNT(*) INTO l_n FROM hrdw_file
              WHERE hrdw01=l_hrdw.hrdw01
                AND hrdw02=l_hrdw.hrdw02
                AND hrdw03=l_hrdw.hrdw03
             IF l_n>0 THEN
             	  UPDATE hrdw_file SET hrdw06=l_hrdw.hrdw06,
             	                       hrdw07=l_hrdw.hrdw07
             	                 WHERE hrdw01=l_hrdw.hrdw01
                                 AND hrdw02=l_hrdw.hrdw02
                                 AND hrdw03=l_hrdw.hrdw03
             ELSE
             	  INSERT INTO hrdw_file VALUES (l_hrdw.*)
             END IF
             	
             IF SQLCA.sqlcode THEN
             	  LET g_success='N'
             	  CALL cl_err('保存补缴信息出错','!',1)
             	  EXIT FOREACH
             END IF
          
          END FOREACH   		  		                         		
                                                  	
          IF g_success='N' THEN EXIT FOR END IF
      
       END FOR
       
       IF g_success='Y' THEN
       	  COMMIT WORK
       	  CALL cl_err('计算完成','!',1)
       ELSE
       	  ROLLBACK WORK
       	  CALL cl_err('计算发生错误','!',1)
       END IF
       	
END FUNCTION       		  	      		      	
             		  		
FUNCTION i091_pro(p_hratid,p_hrct11,p_hrdta01,p_hrdta02)
DEFINE p_hratid   LIKE   hrat_file.hratid
DEFINE p_hrct11   LIKE   hrct_file.hrct11
DEFINE p_hrdta01  LIKE   hrdta_file.hrdta01
DEFINE p_hrdta02  LIKE   hrdta_file.hrdta02
DEFINE l_hrdta05  LIKE   hrdta_file.hrdta05
DEFINE l_sql          STRING
DEFINE l_hrdk14       LIKE  hrdk_file.hrdk14
DEFINE l_hrdk16       LIKE  hrdk_file.hrdk16
DEFINE l_hrdk17       LIKE  hrdk_file.hrdk17
DEFINE tok            base.StringTokenizer
DEFINE l_str          STRING
DEFINE l_value        LIKE type_file.chr100
DEFINE l_str_head     STRING
DEFINE l_str_value    STRING   
DEFINE l_str_body     STRING
DEFINE l_str_res      STRING
DEFINE l_str_tail     STRING
DEFINE l_str_pro      STRING
DEFINE i,l_i          LIKE  type_file.num5
DEFINE j,k            LIKE  type_file.num5
DEFINE l_para         DYNAMIC ARRAY OF RECORD
         para         LIKE  hrdh_file.hrdh12
                      END RECORD
DEFINE l_res          DYNAMIC ARRAY OF RECORD
         res          LIKE  hrdk_file.hrdk16
                      END RECORD 
DEFINE l_formula      DYNAMIC ARRAY OF RECORD
         fml          LIKE  hrdk_file.hrdk17
                      END RECORD 
DEFINE l_flag         LIKE  type_file.chr1
DEFINE l_result            LIKE  hrdw_file.hrdw04
DEFINE l_arg          LIKE  type_file.chr1000
DEFINE li_res         LIKE  hrdl_file.hrdl11

       SELECT hrdta05 INTO l_hrdta05 FROM hrdta_file
        WHERE hrdta01=p_hrdta01
          AND hrdta02=p_hrdta02
       IF cl_null(l_hrdta05) THEN
       	  LET l_result=0
       	  RETURN l_result
       END IF	     

       LET l_str_head="create or replace procedure salary",
                      "(p_hrat01 in varchar2,p_hrct11 in varvhar2,res out varchar2) is \n"
       LET l_str_body="begin \n"
       LET l_str_tail="end;"
       LET l_str_value=''
       LET l_str_res="res:=" 
       
       LET i=0
       LET j=0
       LET k=0
       
       LET l_str=''
       SELECT hrdk14 INTO l_hrdk14 FROM hrdk_file WHERE hrdk01=l_hrdta05
       LET l_str=l_hrdk14
       LET l_str=l_str.trim()
       LET tok = base.StringTokenizer.create(l_str,"|")
       IF NOT cl_null(l_str) THEN
          WHILE tok.hasMoreTokens()
             LET l_value=tok.nextToken()
             IF i=0 THEN
                LET i=i+1
                LET l_para[i].para=l_value
             ELSE
                LET l_flag='N'
                FOR l_i=1 TO i
                   IF l_para[l_i].para=l_value THEN
                      LET l_flag='Y'
                      EXIT FOR
                   END IF
                END FOR
                IF l_flag='N' THEN
                   LET i=i+1
                   LET l_para[i].para=l_value
                END IF
             END IF
          END WHILE
       END IF
       	
       SELECT hrdk16,hrdk17 INTO l_hrdk16,l_hrdk17 FROM hrdk_file
        WHERE hrdk01=l_hrdta05
       IF NOT cl_null(l_hrdk16) THEN
          LET j=j+1
          LET l_res[j].res=l_hrdk16
       END IF
       IF NOT cl_null(l_hrdk17) THEN
          LET k=k+1
          LET l_formula[k].fml=l_hrdk17
       END IF
       	
       #定义参数以及参数取值
       FOR l_i=1 TO i
           LET l_str_head=l_str_head,l_para[l_i].para," varchar2(100); \n"
           LET l_str_value=l_str_value,"SELECT hrdxc05 INTO ",l_para[l_i].para,
                           " FROM hrdxc_file WHERE hrdxc02=p_hrat01 AND hrdxc01=p_hrct11 AND hrdxc08='",l_para[l_i].para,"'; \n"
           CALL i091_get_para_val(l_para[l_i].para,p_hratid,p_hrct11)
       END FOR

       LET l_str_body=l_str_body,l_str_value

       #组合主逻辑块
       FOR l_i=1 TO k
          LET l_str_body=l_str_body,l_formula[l_i].fml," \n"
       END FOR

       #定义输出结果的参数
       FOR l_i=1 TO j
          IF l_i=1 THEN
                 LET l_str_res=l_str_res,l_res[l_i].res
          ELSE
                 LET l_str_res=l_str_res,"||','||",l_res[l_i].res
          END IF

          LET l_str_head=l_str_head,l_res[l_i].res," varchar2(100); \n"

       END FOR

       LET l_str_pro=l_str_head,l_str_body,l_str_res,"; \n",l_str_tail		 
       
       LET l_sql=l_str_pro
       IF NOT cl_null(l_sql) THEN
          LET l_sql=cl_replace_str(l_sql,"@","")
          PREPARE fuli from l_sql
          EXECUTE fuli
          
          #LET l_arg=p_hratid   #先mark用tiptop测试
          #LET l_arg='tiptop'

          PREPARE fuli_js FROM "call salary(?,?,?)"
          EXECUTE fuli_js USING p_hratid IN,p_hrct11 IN,li_res OUT
       END IF
       	
       LET l_result=li_res
       IF cl_null(l_result) THEN LET l_result=0 END IF
       	
       RETURN l_result

END FUNCTION

FUNCTION i091_get_para_val(p_para,p_hrat01,p_hrdx01)
DEFINE p_para    LIKE   hrdh_file.hrdh12
DEFINE p_hrat01  LIKE   hrat_file.hratid
DEFINE p_hrdx01  LIKE   hrdx_file.hrdx01
DEFINE p_hrdx04  LIKE   hrdx_file.hrdx04
DEFINE l_hrdh01  LIKE   hrdh_file.hrdh01
DEFINE l_hrdh02  LIKE   hrdh_file.hrdh02
DEFINE l_hrdh03  LIKE   hrdh_file.hrdh03
DEFINE l_hrdh06  LIKE   hrdh_file.hrdh06
DEFINE l_hrdxc   RECORD LIKE hrdxc_file.*
DEFINE l_n       LIKE   type_file.num5

       SELECT hrdh01,hrdh02,hrdh03,hrdh06 
         INTO l_hrdh01,l_hrdh02,l_hrdh03,l_hrdh06 
         FROM hrdh_file
        WHERE hrdh12=p_para
        
       LET l_hrdxc.hrdxc01=p_hrdx01
       LET l_hrdxc.hrdxc02=p_hrat01
       LET l_hrdxc.hrdxc03=l_hrdh01
       LET l_hrdxc.hrdxc04=l_hrdh06
       LET l_hrdxc.hrdxc08=p_para
       #LET l_hrdxc.hrdxc09=p_hrdx04 
       LET l_n=0
       SELECT COUNT(*) INTO l_n FROM hrdxc_file WHERE hrdxc01=l_hrdxc.hrdxc01
                                                  AND hrdxc02=l_hrdxc.hrdxc02
                                                  AND hrdxc03=l_hrdxc.hrdxc03
                                                  AND hrdxc08=l_hrdxc.hrdxc08
       IF l_n>0 THEN
       	  RETURN
       END IF	                                              	
       
       CASE l_hrdh02
       	  #人事类
       	  WHEN '001' CALL i091_get_val_001(p_para,p_hrat01) 
       	                     RETURNING l_hrdxc.hrdxc05
       	  #薪资福利类                   
       	  WHEN '002' CALL i091_get_val_002(p_para,p_hrat01,p_hrdx01,l_hrdh01,l_hrdh03)
       	                     RETURNING l_hrdxc.hrdxc05
       	  #奖惩类
       	  WHEN '005' CALL i091_get_val_005(p_para,p_hrat01,p_hrdx01)
       	                     RETURNING l_hrdxc.hrdxc05
       	  #考勤类
       	  WHEN '003' CALL i091_get_val_003(p_para,p_hrat01,p_hrdx01)
       	                     RETURNING l_hrdxc.hrdxc05                                       
      
       END CASE
       	
       IF cl_null(l_hrdxc.hrdxc05) THEN LET l_hrdxc.hrdxc05=0 END IF	
       	
       INSERT INTO hrdxc_file VALUES (l_hrdxc.*)
      
END FUNCTION 
	
FUNCTION i091_get_val_001(p_para,p_hrat01)
DEFINE p_para      LIKE   hrdh_file.hrdh12
DEFINE p_hrat01 	 LIKE   hrat_file.hratid
DEFINE l_sql       STRING
DEFINE l_hrdxc05   LIKE   hrdxc_file.hrdxc05

       LET l_sql=" SELECT ",p_para," FROM hrat_file WHERE hratid='",p_hrat01,"'"
       PREPARE i092_get_val_001 FROM l_sql
       EXECUTE i092_get_val_001 INTO l_hrdxc05
       
       
       RETURN l_hrdxc05
       
END FUNCTION
	
FUNCTION i091_get_val_002(p_para,p_hrat01,p_hrdx01,p_hrdh01,p_hrdh03)	
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
                      #AND hrdpa06 BETWEEN l_hrct07_b AND l_hrct08_b
                      #AND hrdpa07 BETWEEN l_hrct07_b AND l_hrct08_b
                      AND l_hrct07_b BETWEEN hrdpa06 AND hrdpa07         #add by zhangbo130909
                      AND l_hrct08_b BETWEEN hrdpa06 AND hrdpa07         #add by zhangbo130909
                WHEN 'hrde'
                   LET l_hrdpc02=p_para[5,l_length]
                   SELECT hrct07,hrct08 INTO l_hrct07_b,l_hrct08_b
                     FROM hrct_file
                    WHERE hrct11=p_hrdx01
                   SELECT hrdpc05 INTO l_hrdxc05 FROM hrdpc_file,hrdp_file
                    WHERE hrdp01=hrdpc01
                      AND hrdp04=p_hrat01
                      AND hrdpc02=l_hrdpc02
                      AND hrdp09='003'
                      #AND hrdpc06 BETWEEN l_hrct07_b AND l_hrct08_b
                      #AND hrdpc07 BETWEEN l_hrct07_b AND l_hrct08_b
                      AND l_hrct07_b BETWEEN hrdpc06 AND hrdpc07         #add by zhangbo130909
                      AND l_hrct08_b BETWEEN hrdpc06 AND hrdpc07         #add by zhangbo130909
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
       	     SELECT hrdpb03 INTO l_hrdxc05 FROM hrdp_file,hrbpb_file
       	      WHERE hrdp01=hrdpb01
       	        AND hrdp04=p_hrat01
       	        AND hrdpb02=p_hrdh01
       	        AND rownum=1
       END CASE
     	
       RETURN  l_hrdxc05
     
END FUNCTION     	  	                                    	  	                     
       	   				
FUNCTION i091_get_val_005(p_para,p_hrat01,p_hrdx01)
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
	
FUNCTION i091_get_val_003(p_para,p_hrat01,p_hrdx01)
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

	

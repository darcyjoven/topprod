# Prog. Version..: '5.30.03-12.09.18(00010)'     #
#
# Pattern name...: ghrp000.4gl
# Descriptions...: 
# Date & Author..: 13/04/15 By Yougs 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_choice	 LIKE type_file.chr3
DEFINE g_sdate   LIKE type_file.dat                                                            
DEFINE g_wc    	 STRING                                                                          
DEFINE g_flag          LIKE type_file.chr1,                                                                         
       g_change_lang   LIKE type_file.chr1                                                                          
                                                                                                                    
MAIN                                                                                                                
   DEFINE   ls_date  STRING                                                                              
   DEFINE li_result     LIKE type_file.num5                                                                         
 
   OPTIONS                                                   
     INPUT NO WRAP ,                                         
      FIELD ORDER FORM                                       
   DEFER INTERRUPT                                           
  
  LET g_choice   = ARG_VAL(1)    
  LET g_wc = ARG_VAL(2) 
  LET g_sdate   = ARG_VAL(3)    
  LET g_sdate  = cl_batch_bg_date_convert(g_sdate)
  LET g_bgjob = ARG_VAL(4)    
  IF cl_null(g_bgjob) THEN
     LET g_bgjob = "N"
  END IF 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ghr")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   WHILE TRUE
      IF g_bgjob = "N" THEN 
         CALL p000_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL p000_p()
            CALL s_showmsg()                  
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING g_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING g_flag
            END IF
            IF g_flag THEN 
               CONTINUE WHILE 
            ELSE 
               CLOSE WINDOW p000_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL p000_p()
         CALL s_showmsg()                  #No.FUN-710046
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
END MAIN
 
FUNCTION p000_tm()
   DEFINE l_flag        LIKE type_file.num5                                                         
   DEFINE li_result     LIKE type_file.num5                                                         
   DEFINE lc_cmd        LIKE type_file.chr1000                                                      
   DEFINE l_count       LIKE type_file.num5
  
   OPEN WINDOW p000_w WITH FORM "ghr/42f/ghrp000"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
   CALL cl_opmsg('z')  
   
   WHILE TRUE
       CLEAR FORM
       LET g_action_choice = ''
       LET g_wc = ''
       LET g_choice='all' 
       LET g_sdate=g_today
       LET g_bgjob = 'N'   

       DIALOG ATTRIBUTES(UNBUFFERED) 
          INPUT g_choice,g_sdate,g_bgjob
          FROM choice,sdate,g_bgjob 
             BEFORE INPUT
                 CALL cl_qbe_init()           
                 IF cl_null(g_choice) THEN
                 	  LET g_choice='all'
                 	  CALL cl_set_comp_visible("hrav01",FALSE)
                 END IF	  
                 IF cl_null(g_sdate) THEN
                 	  LET g_sdate=g_today
                 END IF	  
                 IF cl_null(g_bgjob) THEN
                 	  LET g_bgjob = 'N'
                 END IF	  
             ON CHANGE choice
                IF g_choice = '1' THEN
                	 CALL cl_set_comp_visible("hrav01",TRUE)
                ELSE
                	 CALL cl_set_comp_visible("hrav01",FALSE)
                END IF		                              
                   	
          END INPUT                    
          CONSTRUCT BY NAME g_wc ON hrav01 
             BEFORE CONSTRUCT
                CALL cl_qbe_init()  
                                          
          END CONSTRUCT       
          ON ACTION locale
             CALL cl_dynamic_locale()
             CALL cl_show_fld_cont() 
          
          ON ACTION exit
             LET INT_FLAG = 1
             EXIT DIALOG
          ON ACTION close
             LET INT_FLAG = 1
             EXIT DIALOG 
          ON ACTION accept 
             EXIT DIALOG             
          ON ACTION cancel
             LET INT_FLAG = 1
             EXIT DIALOG                      
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
          
          ON ACTION CONTROLG 
             CALL cl_cmdask()
          
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE DIALOG
          
          ON ACTION about                       
             CALL cl_about()                    
                                                
          ON ACTION help                        
             CALL cl_show_help()      

          ON ACTION CONTROLP                  
             CASE
                WHEN INFIELD(hrav01) 
                       CALL cl_init_qry_var()
                       LET g_qryparam.state ="c"
                       LET g_qryparam.form ="q_hrav01"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO hrav01
                       NEXT FIELD hrav01 
             END CASE   
          ON ACTION qbe_select
             CALL cl_qbe_select() 
          
          ON ACTION qbe_save
             CALL cl_qbe_save()              	                           
          AFTER DIALOG
             CONTINUE DIALOG 
       END DIALOG
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p000_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
       IF g_bgjob = 'Y' THEN
          SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'ghrp000'
          IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
              CALL cl_err('ghrp000','9031',1)   
          ELSE
             LET lc_cmd = lc_cmd CLIPPED,
                          " '",g_choice CLIPPED,"'",
                          " '",g_wc CLIPPED,"'",
                          " '",g_sdate CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'"
             CALL cl_cmdat('ghrp000',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p000_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       EXIT WHILE
   END WHILE 
 
END FUNCTION
 
  
FUNCTION p000_p() 
   DEFINE l_hrav01     LIKE hrav_file.hrav01                                                                                 
   DEFINE l_hrav02     LIKE hrav_file.hrav02
   DEFINE l_hrav03     LIKE hrav_file.hrav03                                                                                 
   DEFINE l_hrav04     LIKE hrav_file.hrav04
   DEFINE l_hrav05     LIKE hrav_file.hrav05
   DEFINE l_hrav07     LIKE hrav_file.hrav07
   DEFINE l_sql        STRING 
   DEFINE l_sql2       STRING                                                                                                        
   DEFINE l_count      LIKE type_file.num5     
   DEFINE l_hrau04     LIKE hrau_file.hrau04   
   DEFINE l_hrat       RECORD LIKE hrat_file.* 
   DEFINE l_hrag07     LIKE hrag_file.hrag07
   DEFINE l_hrat13_17  LIKE type_file.num5
   DEFINE l_year       LIKE type_file.num5
   DEFINE l_hrat16     LIKE type_file.num5                                                                              
                                                                                                       
                           
   IF g_choice = 'all' THEN
   	  LET g_wc = "1=1"
   ELSE
   	  IF cl_null(g_wc) THEN
   	  	 LET g_wc = " 1=1 "
   	  END IF 	 
   END IF		  
   IF g_bgjob = 'N' THEN	
      LET l_sql = " SELECT hrav01,hrav02,hrav03,hrav04,hrav05,hrav07 FROM hrav_file", 
                  "  WHERE ",g_wc,
                  "    AND hrav10 = 'N' ",
                  "    AND hrav08 = to_date('",g_sdate,"','yyyy-mm-dd') ",
                  "    ORDER BY hrav08 "
   ELSE
   	  LET l_sql = " SELECT hrav01,hrav02,hrav03,hrav04,hrav05,hrav07 FROM hrav_file", 
                  "  WHERE ",g_wc,
                  "    AND hrav10 = 'N' ", 
                  "    AND hrav08 <= to_date('",g_sdate,"','yyyy-mm-dd') ",
                  "    ORDER BY hrav08 "
   END IF	              
   DECLARE p000_foreach CURSOR FROM l_sql 
    
   FOREACH p000_foreach INTO l_hrav01,l_hrav02,l_hrav03,l_hrav04,l_hrav05,l_hrav07
      IF SQLCA.SQLCODE THEN
         CALL cl_err(l_hrav03,SQLCA.SQLCODE,1) 
         LET g_success = 'N'  
         EXIT FOREACH 
      END IF  
      #获取变更字段的值类型文本输入、日期选择或者开窗选择
      LET l_hrau04 = ''
      SELECT hrau04 INTO l_hrau04	 FROM hrau_file
       WHERE hrau01 = l_hrav04
         AND hrau02 = l_hrav05    
      #暂时只处理员工信息的异动，其他表的异动不支持
      IF l_hrav04 = "hrat_file" OR l_hrav04 = "hrat_File" OR l_hrav04 = "HRAT_FILE" THEN
         IF l_hrav05 = 'hrat13' THEN
         	INITIALIZE l_hrat.* TO NULL  
            SELECT * INTO l_hrat.* FROM hrat_file WHERE hratid = l_hrav03 
            LET l_hrag07 = ''
            SELECT hrag07 INTO l_hrag07 FROM hrag_file WHERE hrag01 = '314' AND hragacti = 'Y' AND hrag06 = l_hrat.hrat12
            IF l_hrag07 = '大陆身份证' OR l_hrag07 = '大陸身份證' THEN 
               LET l_year = ''   #出生自然年
               LET l_year = l_hrat.hrat13[7,10]  
               LET l_hrat13_17 = l_hrat.hrat13[17,17]  #性别 
               SELECT to_date(substr(l_hrat.hrat13,9,2)||'/'||substr(l_hrat.hrat13,11,2)||'/'||substr(l_hrat.hrat13,13,2),'yy/mm/dd') INTO l_hrat.hrat15 FROM DUAL
               LET l_hrat16 = ''    #年龄
               SELECT YEAR(g_today)-l_year+1 INTO l_hrat16 FROM DUAL
               LET l_hrat.hrat16 = l_hrat16 
               LET l_hrag07 = ''
               IF l_hrat13_17 MOD 2 =1 THEN
                 LET l_hrag07 = '男'
               ELSE
                 LET l_hrag07 = '女'
               END IF
               SELECT hrag06 INTO l_hrat.hrat17 FROM hrag_file WHERE hragacti = 'Y' AND hrag07 = l_hrag07 AND hrag01 = '333'  #设置性别
               SELECT hraj02 INTO l_hrat.hrat18 FROM hraj_file WHERE hraj01 = substr(l_hrat.hrat13,1,6) AND hrajacti = 'Y'    #设置籍贯
               LET l_sql2 = " UPDATE hrat_file SET hrat13 = '",l_hrat.hrat13,"',",
                                               " hrat15 = to_date(SUBSTR('",l_hrat.hrat13,"',7,8),'yyyymmdd'),",
                                               " hrat16 = ",l_hrat.hrat16,",",
                                               " hrat17 = '",l_hrat.hrat17,"',",
                                               " hrat18 = '",l_hrat.hrat18,"'",
                          " WHERE hratid = '",l_hrav03,"'" 
            END IF
         ELSE  
            IF l_hrau04 = '3' THEN     #日期值
               LET l_sql2 = "UPDATE ",l_hrav04," SET ",l_hrav05," = to_date('",l_hrav07,"','yyyy-mm-dd') ",
                    " WHERE hratid = '",l_hrav03,"'"
            ELSE     #输入文本值或者开窗选择值
               LET l_sql2 = "UPDATE ",l_hrav04," SET ",l_hrav05," = '",l_hrav07,"'",
                    " WHERE hratid = '",l_hrav03,"'"  
            END IF 
         END IF
      ELSE
         IF l_hrau04 = '3' THEN
            LET l_sql2 = "UPDATE ",l_hrav04," SET ",l_hrav05," = to_date('",l_hrav07,"','yyyy-mm-dd') ",
                       " WHERE RTRIM('",l_hrav04,"','_File')||'01' = '",l_hrav03,"'" 
         ELSE
            LET l_sql2 = "UPDATE ",l_hrav04," SET ",l_hrav05," = '",l_hrav07,"'",
                       " WHERE RTRIM('",l_hrav04,"','_File')||'01' = '",l_hrav03,"'"                  
         END IF
      END IF	
      PREPARE hrau04_pre2 FROM l_sql2
      EXECUTE hrau04_pre2
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd:',SQLCA.SQLCODE,1) 
         LET g_success = 'N'  
         EXIT FOREACH 
      END IF 	 	 	      
      IF l_hrav07 IS NULL THEN	         
         LET l_sql2 = "UPDATE hrav_file SET hrav10 = 'Y' ",
                      " WHERE hrav01 = '",l_hrav01,"'",
                      "   AND hrav02 = '",l_hrav02,"'"
      ELSE
         LET l_sql2 = "UPDATE hrav_file SET hrav10 = 'Y' ",
                      " WHERE hrav01 = '",l_hrav01,"'",
                      "   AND hrav02 = '",l_hrav02,"'"    	
      END IF	             
      PREPARE hrav_pre3 FROM l_sql2
      EXECUTE hrav_pre3
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd hrav_file:',SQLCA.SQLCODE,1) 
         LET g_success = 'N'  
         EXIT FOREACH 
      END IF          
      LET l_hrav03 = ''
      LET l_hrav04 = ''
      LET l_hrav05 = ''
      LET l_hrav07 = ''	     
   END FOREACH    
END FUNCTION
 
 

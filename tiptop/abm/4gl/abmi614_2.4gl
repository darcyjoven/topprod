# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: abmi614_1.4gl
# Descriptions...: 
# Date & Author..: 08/06/21 By  ve007 
# Modify.........: No.FUN-870127 08/07/24 By arman 服飾版
# Modify.........: No.FUN-8A0145 08/10/31 By arman
# Modify.........: No.CHI-8C0040 08/10/31 By jan 語法修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting 離開MAIN沒有cl_used(1)
# Modify.........: No.FUN-B30219 11/04/06 By chenmoyan 去年DUAL
# Modify.........: No.FUN-B80100 11/08/10 By fengrui  程式撰寫規範修正
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE          
       g_boi01       LIKE boi_file.boi01,        
       g_t1          LIKE oay_file.oayslip,       
       g_sheet       LIKE oay_file.oayslip,        
       g_ydate       LIKE type_file.dat,         
       g_boe         DYNAMIC ARRAY OF RECORD      
          a2         LIKE type_file.num10,                     
       boe78a        LIKE boe_file.boe08,        
          a3         LIKE boe_file.boe08                      
                     END RECORD,
       g_boe_t       RECORD                        
          a2         LIKE type_file.num10,                      
       boe78a        LIKE boe_file.boe08,         
          a3         LIKE boe_file.boe08                
                     END RECORD,
       g_boe_o       RECORD                        
          a2         LIKE type_file.num10,                     
       boe78a        LIKE boe_file.boe08,          
          a3         LIKE boe_file.boe08              
                     END RECORD,
       g_sql         STRING,                      
       g_wc          STRING,                       
       g_wc2         STRING,                      
       g_rec_b       LIKE type_file.num5,          
       l_ac          LIKE type_file.num5,         
       l_ac2         LIKE type_file.num5          
 
DEFINE g_gec07             LIKE gec_file.gec07   
DEFINE g_forupd_sql        STRING                
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE boe_file.boe08   
DEFINE g_cnt               LIKE type_file.num10  
DEFINE g_i                 LIKE type_file.num5      
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10   
DEFINE g_jump              LIKE type_file.num10   
DEFINE mi_no_ask           LIKE type_file.num5    
DEFINE g_argv1             LIKE boc_file.boc01    
DEFINE g_argv2             STRING               
DEFINE g_boe01             LIKE boe_file.boe01
DEFINE g_boe02             LIKE boe_file.boe02
DEFINE g_boe03             LIKE boe_file.boe03
DEFINE g_boe04             LIKE boe_file.boe04
DEFINE g_boe05             LIKE boe_file.boe05
DEFINE g_boe06             LIKE boe_file.boe06
DEFINE g_flag              LIKE type_file.num5
DEFINE g_boe08             LIKE boe_file.boe08
DEFINE g_result            LIKE type_file.chr1000 
DEFINE l_a1                LIKE type_file.chr1000
DEFINE l_adis              LIKE type_file.chr1000 
DEFINE l_p                 LIKE type_file.chr1
 
FUNCTION i614_shlsfbl(p_boe08,p_boe01,p_boe02,p_lang,p_boe03,p_boe04,p_boe05,p_boe06)
DEFINE p_boe08             LIKE boe_file.boe08
DEFINE p_boe01             LIKE boe_file.boe01
DEFINE p_boe02             LIKE boe_file.boe02
DEFINE p_boe03             LIKE boe_file.boe03
DEFINE p_boe04             LIKE boe_file.boe04
DEFINE p_boe05             LIKE boe_file.boe05
DEFINE p_boe06             LIKE boe_file.boe06
DEFINE p_lang              LIKE type_file.chr1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      #CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80100--add-  #FUN-BB0047 mark
      EXIT PROGRAM
   END IF
 
   LET g_lang = p_lang

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
   OPEN WINDOW i614_2_w WITH FORM "abm/42f/abmi614_1"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   CALL cl_set_locale_frm_name("abmi614_1")
   LET g_boe01 = p_boe01
   LET g_boe02 = p_boe02
   LET g_boe03 = p_boe03
   LET g_boe04 = p_boe04
   LET g_boe05 = p_boe05
   LET g_boe06 = p_boe06
   LET g_boe08 = p_boe08    
   LET g_boi01 = ''
   IF cl_null(p_boe08) THEN
      CALL i614_2_a()
      CALL i614_2_menu()
   ELSE
     CALL i614_2_show()
     CALL i614_2_menu()
   END IF
   CLOSE WINDOW i614_2_w                 
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-BB0047 add
    RETURN g_result
 
END FUNCTION 
 
FUNCTION i614_2_menu() 
 
   WHILE TRUE
 
      IF g_flag = 1  THEN
        LET g_flag = 0 
         RETURN
      ELSE
         CALL i614_2_bp("G")
      END IF
 
   CASE g_action_choice
 
          WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i614_2_u()
            END IF 
              
         WHEN "qc_formula"
           IF cl_chk_act_auth() THEN
             IF NOT cl_null(l_a1) THEN 
               IF NOT cl_null(g_boe08) THEN
                IF  l_a1[1,LENGTH(l_a1)-1]!= g_boe08 THEN 
                  CALL i614_2_qc_formula()
                END IF 
               ELSE
               	  CALL i614_2_qc_formula()
               END IF
             ELSE 
               CALL i614_2_qc_formula()    
             END IF  
           END IF 
           
         WHEN "fin_formula"
           IF cl_chk_act_auth() THEN
           IF NOT cl_null(l_a1) THEN 
            IF l_p = 'Y' OR l_a1[1,LENGTH(l_a1)-1] = g_boe08 THEN 
              CALL i614_2_fin_formula()
            ELSE
            	CALL cl_err('','abm_620',1)
            END IF 
           ELSE 
           	 CALL i614_2_fin_formula()
           END IF 	 	  
           END IF 
           
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"  
              IF cl_chk_act_auth() THEN
                 CALL cl_doc()
               END IF
      END CASE 
      
   END WHILE
END FUNCTION
 
FUNCTION i614_2_show()
    LET l_a1 = g_boe08 ,'_'
#   SELECT replace(l_a1,'_') INTO l_adis  FROM dual #FUN-B30219
    LET l_adis = cl_replace_str(l_a1,'_','')        #FUN-B30219
    DISPLAY l_adis TO FORMONLY.a1
    CALL i614_2_b_fill()
    CALL cl_show_fld_cont()                  
END FUNCTION
 
FUNCTION i614_2_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_boe.clear()
   IF s_shut(0) THEN
      RETURN
   END IF
 
   
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET l_a1 = ''
      CALL i614_2_i("a")                
 
      IF INT_FLAG THEN                  
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i614_2_i(p_cmd)
DEFINE l_a61      ui.ComboBox
DEFINE
   g_sql      STRING,         #NO.FUN-910082
   p_cmd      LIKE type_file.chr1 
DEFINE l_a6       LIKE type_file.chr1000                                                                                          
DEFINE i          LIKE type_file.num10              #No.FUN-8A0145   
DEFINE l_a4       LIKE type_file.chr1
DEFINE l_a5       LIKE type_file.chr1
DEFINE l_pos,l_len,l_n,l_len1  LIKE type_file.num5
DEFINE l_fun,l_fun1     LIKE type_file.chr20 
DEFINE l_atest    LIKE type_file.chr1000
DEFINE l_n1,l_n2  LIKE type_file.num5
DEFINE l_str      LIKE type_file.chr1000
DEFINE 
       sr         DYNAMIC ARRAY OF RECORD       
         boi01        LIKE type_file.chr50,         #No.FUN-8A0145
         boi02        LIKE type_file.chr50          #No.FUN-8A0145
       END RECORD
       
                                                                                                    
   IF s_shut(0) THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")          
 
   INPUT l_a5,l_a4,l_a6 WITHOUT DEFAULTS FROM 
                                  FORMONLY.a5,FORMONLY.a4,FORMONLY.a6
                                 
    
      BEFORE INPUT
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE 
         CALL cl_set_comp_entry('a6',TRUE)
          
      BEFORE FIELD a4
         LET l_a4 = ''
         CALL cl_set_comp_entry('a6',TRUE)
         
      BEFORE FIELD a6
        IF  cl_null(l_a4) THEN 
         CALL cl_set_comp_entry('a6',FALSE)
        ELSE 
         CALL cl_set_comp_entry('a6',TRUE) 
        END IF  
             
      AFTER FIELD a4
       LET l_a61 = ui.ComboBox.forName("a6")
       CALL l_a61.clear()
       LET g_cnt = 1   
        IF l_a4 ='1' THEN
           CALL cl_ui_locale("abmi614_1")
           LET g_sql =                                                                                                                     
                     "SELECT boi01,boi02 ",
                     "  FROM boi_file ",
                     " WHERE boiacti='Y'" 
           PREPARE i614_boi01 FROM g_sql                                                                                                    
           DECLARE i614_curs CURSOR FOR i614_boi01 
           OPEN i614_curs
           FOREACH i614_curs INTO sr[g_cnt].*    
              IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF                                                         
              IF g_cnt > g_max_rec THEN                                                                                                   
                     CALL cl_err( '', 9035, 0 )                                                                                               
                     EXIT FOREACH                                                                                                             
              END IF           
           LET l_str = sr[g_cnt].boi01 CLIPPED,":",
                       sr[g_cnt].boi02 CLIPPED 
           CALL l_a61.AddItem(sr[g_cnt].boi01,l_str)
              LET g_cnt = g_cnt + 1 
           END FOREACH
        END IF
        IF l_a4 ='2' THEN 
           CALL cl_ui_locale("abmi614_1")
           LET g_sql =                                                                                                                     
                     " SELECT agb03,agc02 ",
                    #" FROM agb_file,ima_file,agc_file,aga_file ",      #CHI-8C0040
                     " FROM agb_file,ima_file,OUTER agc_file,aga_file ",#CHI-8C0040
                     " WHERE agb01=aga01 ",
                     " AND aga01=imaag ", 
                     " AND ima01='",g_boe01,"' ",
                    #" AND agb03=agc01(+) "   #CHI-8C0040
                     " AND agb03=agc_file.agc01 "      #CHI-8C0040
           PREPARE i614_boi01_2 FROM g_sql                                                                                                    
           DECLARE i614_curs_2 CURSOR FOR i614_boi01_2 
           OPEN i614_curs_2
           FOREACH i614_curs_2 INTO sr[g_cnt].*    
              IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF                                                         
              IF g_cnt > g_max_rec THEN                                                                                                   
                     CALL cl_err( '', 9035, 0 )                                                                                               
                     EXIT FOREACH                                                                                                             
              END IF           
           LET l_str = sr[g_cnt].boi01 CLIPPED,":",
                       sr[g_cnt].boi02 CLIPPED 
           CALL l_a61.AddItem(sr[g_cnt].boi01,l_str)
              LET g_cnt = g_cnt + 1                                                                                                       
           END FOREACH
        END IF
        IF l_a4 ='3' THEN
           CALL cl_ui_locale("abmi614_1")
           LET g_sql =                                                                                                                     
                    "SELECT  agb03,agc02 ",
                   #"  FROM  agb_file,ima_file,agc_file,aga_file ",        #CHI-8C0040
                    "  FROM  agb_file,ima_file,OUTER agc_file,aga_file ",  #CHI-8C0040
                    " WHERE  agb01=aga01 and aga01=imaag",
                    "   AND  ima01='",g_boe02,"' ",
                   #"   AND  agb03=agc01(+) "    #CHI-8C0040
                    "   AND  agb03=agc_file.agc01 "       #CHI-8C0040
           PREPARE i614_boi01_3 FROM g_sql                                                                                                    
           DECLARE i614_curs_3 CURSOR FOR i614_boi01_3 
           OPEN i614_curs_3
           FOREACH i614_curs_3 INTO sr[g_cnt].*    
              IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF                                                         
              IF g_cnt > g_max_rec THEN                                                                                                   
                     CALL cl_err( '', 9035, 0 )                                                                                               
                     EXIT FOREACH                                                                                                             
              END IF           
           LET l_str = sr[g_cnt].boi01 CLIPPED,":",
                       sr[g_cnt].boi02 CLIPPED 
           CALL l_a61.AddItem(sr[g_cnt].boi01,l_str)
              LET g_cnt = g_cnt + 1                                                                                                       
           END FOREACH
        END IF
        NEXT FIELD a6
 
      AFTER FIELD  a6
          IF NOT cl_null(l_a6) THEN
            IF l_a4 ='2' THEN 
             LET l_a6 = '$',l_a6 CLIPPED ,'_'
            ELSE 
            	IF l_a4 = '3' THEN 
            	   LET l_a6 = '$$',l_a6 CLIPPED ,'_'
            	ELSE 
            		 LET l_a6 = l_a6 CLIPPED ,'_'
            	END IF 	
            END IF
          END IF    
          IF cl_null(l_a1) THEN  
             CALL cl_err('','abm_615',1)
             LET l_a6 = ''
             NEXT FIELD a5 
          ELSE    
            SELECT  substr(l_a1,
               INSTR(l_a1,'_',-1,2)+1,
              (INSTR(l_a1,'_',-1,1)-INSTR(l_a1,'_',-1,2))-1)
               INTO l_atest   from dual
              LET l_n= LENGTH(l_atest)  
              IF l_atest NOT MATCHES '[+*/()-]'  ESCAPE "*" THEN 
                 CALL cl_err('','abm-322',1)
                 LET l_a6 = ''
                 NEXT FIELD a5
              ELSE    
                 LET l_a1 =l_a1 CLIPPED,l_a6 CLIPPED 
                 LET l_a6 = ''
#                SELECT replace(l_a1,'_') INTO l_adis  FROM dual #FUN-B30219 mark
                 LET l_adis = cl_replace_str(l_a1,'_','')        #FUN-B30219
                 DISPLAY l_adis TO FORMONLY.a1
                 NEXT FIELD a5
              END IF 
            END IF   
                
           
         ON change a5      
            CASE l_a5
            WHEN '1' 
               LET l_fun1= '+' 
             WHEN '2' 
               LET l_fun1= '-'
             WHEN '3' 
               LET l_fun1= '*'
             WHEN '4' 
               LET l_fun1= '/' 
             WHEN '5' 
               LET l_fun1= '('
             WHEN '6' 
               LET l_fun1= ')'
             END CASE                
             IF NOT cl_null(l_fun1) THEN                         
                LET l_fun1 = l_fun1 CLIPPED ,'_'
             END IF
             
               SELECT  substr(l_a1,
               INSTR(l_a1,'_',-1,2)+1,
               (INSTR(l_a1,'_',-1,1)-INSTR(l_a1,'_',-1,2))-1)
                INTO l_atest   from dual
              IF l_fun1 != '(_' THEN   
               IF l_atest MATCHES '[+*/(-]'  ESCAPE "*" THEN 
                 CALL cl_err('','abm-323',1)
               ELSE 
               	 LET l_a1 =l_a1 CLIPPED ,l_fun1 CLIPPED   
               END IF
              ELSE 
              	IF l_atest NOT MATCHES '[+*\(-]'  ESCAPE "*" THEN 
              	    CALL cl_err('','abm_323',1)
              	ELSE     
             	     LET l_a1 =l_a1 CLIPPED ,l_fun1 CLIPPED 
             	  END IF        
             END IF 
               LET l_a5= ''      
#              SELECT replace(l_a1,'_') INTO l_adis  FROM dual #FUN-B30219 mark
               LET l_adis = cl_replace_str(l_a1,'_','')        #FUN-B30219
               DISPLAY l_adis TO FORMONLY.a1
               NEXT FIELD a4 
      
         
      ON ACTION act03                      
          IF cl_null(l_a1) THEN 
              NEXT FIELD a5
          END IF    
#         SELECT instr(l_a1,'_',-1,2) INTO l_n FROM dual #FUN-B30219
          LET l_n = cl_str_position(l_a1,'_',-1,2)       #FUN-B30219
          IF l_n =0 THEN 
             LET l_a1 = ''
          ELSE 
          	  LET l_a1 = l_a1[1,l_n]
          END  IF 
#         SELECT replace(l_a1,'_') INTO l_adis  FROM dual #FUN-B30219 mark
          LET l_adis = cl_replace_str(l_a1,'_','')        #FUN-B30219
          DISPLAY l_adis TO FORMONLY.a1
 
      
      AFTER INPUT  
         select (length(l_a1) - length(replace(l_a1,'(')))/length('(') 
          INTO l_n1 FROM dual
         SELECT (length(l_a1) - length(replace(l_a1,')')))/length(')') 
         INTO l_n2 FROM dual
         IF l_n1!= l_n2 THEN 
            CALL cl_err('','abm_322',1)
            NEXT FIELD a5
         END IF            
      
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                 
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION
 
FUNCTION i614_2_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_boe TO s_boe.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac2 = ARR_CURR()
         CALL cl_show_fld_cont()                   
                    
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION qc_formula 
         LET g_action_choice="qc_formula"
         EXIT DISPLAY
 
      ON ACTION fin_formula 
 
            LET g_action_choice="fin_formula"
          
         EXIT DISPLAY
      
      ON ACTION modify                                                                                                      
         LET g_action_choice="modify"                                                                                               
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
 
      ON ACTION controls                                       
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i614_2_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
 
   WHILE TRUE
 
      CALL i614_2_i("u")                     
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      EXIT WHILE
   END WHILE
   CALL i614_2_b_fill()
END FUNCTION 
 
FUNCTION i614_2_b_fill()
DEFINE  i        LIKE type_file.num5   
DEFINE  j        LIKE type_file.num5   
DEFINE  n        LIKE type_file.num5   
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_a1_1   STRING            #FUN-B30219
   CALL g_boe.clear()
   CALL g_boe.deleteElement(g_cnt) 
   IF cl_null(l_a1) THEN
      LET g_rec_b =0   
      RETURN      
   END IF     
#  SELECT TRIM(l_a1) INTO l_s FROM DUAL #FUN-B30219
#FUN-B30219 --Begin
   LET l_a1_1 = l_a1
   LET l_s    = l_a1_1.trim()
#FUN-B30219 --End
   LET j=1
   LET n=1
   FOR i=1 TO length(l_s)
    IF i = length(l_s)  THEN
       LET g_boe[n].a2 = n
       LET g_boe[n].boe78a = l_s[j,i]
    END IF  
    IF l_s[i,i] = '_' THEN
       LET g_boe[n].a2 = n
       LET g_boe[n].boe78a = l_s[j,i-1]
       LET j=i+1
       LET n=n+1
    ELSE
       CONTINUE FOR
    END IF
   END FOR
   LET g_rec_b = n
   
   
END FUNCTION
 
FUNCTION i614_2_result()
 DEFINE i        LIKE type_file.num5
 DEFINE j        LIKE type_file.num5
 DEFINE n        LIKE type_file.num5
 DEFINE l_n        LIKE type_file.num5
 DEFINE l_int    LIKE type_file.chr1000 
 DEFINE l_boi02  LIKE boi_file.boi02
 DEFINE   g_db_type   LIKE type_file.chr3                                                     
 DEFINE   ls_sql      STRING                                                                                                      
 DEFINE li_result     LIKE abb_file.abb25 
   WHENEVER ERROR CALL cl_err_msg_log
      FOR i= 1 TO g_rec_b    
       IF g_boe[i].boe78a='+' OR g_boe[i].boe78a='-'
         OR g_boe[i].boe78a='*' OR g_boe[i].boe78a='/'
         OR g_boe[i].boe78a='(' OR g_boe[i].boe78a=')' THEN
            LET g_boe[i].a3 = g_boe[i].boe78a    
                DISPLAY g_boe[i].a3 TO FORMONLY.a3
       ELSE 
             SELECT boi02 INTO l_boi02 FROM  boi_file WHERE boi01=g_boe[i].boe78a
                                          AND boiacti='Y'
             IF NOT cl_null(l_boi02)  THEN       
                LET g_boe[i].a3 = l_boi02
                LET l_boi02 = NULL 
             END IF 
       END IF
      END FOR 
                CALL cl_opmsg('b')
                  CALL cl_set_comp_entry("a3",TRUE)   
                  INPUT ARRAY g_boe WITHOUT DEFAULTS FROM s_boe.*
                   ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED )
                    BEFORE INPUT
                      DISPLAY "BEFORE INPUT!"
                    BEFORE ROW                                                                                                                  
                    DISPLAY "BEFORE ROW!"                                                                                                    
                    LET l_n  = ARR_CURR()  
                    IF g_boe[l_n].boe78a='+' OR g_boe[l_n].boe78a='-'
                      OR g_boe[l_n].boe78a='*' OR g_boe[l_n].boe78a='/' 
                      OR g_boe[l_n].boe78a='(' OR g_boe[l_n].boe78a=')' THEN
                         LET g_boe[l_n].a3 = g_boe[l_n].boe78a
	
                             DISPLAY g_boe[l_n].a3 TO FORMONLY.a3
                    ELSE 
                          SELECT boi02 INTO l_boi02 FROM  boi_file WHERE boi01=g_boe[l_n].boe78a
                                                       AND boiacti='Y'
                            IF NOT cl_null(l_boi02) THEN
                             LET g_boe[l_n].a3 = l_boi02
                             LET l_boi02 = NULL 
                            END IF
                             CALL cl_set_comp_entry("a3",TRUE)
                    END IF
                   BEFORE FIELD a3 
                     DISPLAY BY NAME  g_boe[l_n].a3
                   END INPUT
        LET l_int = 1
        FOR n=1 TO g_rec_b 
           LET l_int = l_int,g_boe[n].a3 CLIPPED 
        END FOR
        IF g_rec_b <= 1 THEN
          LET l_int = NULL
        END IF
#FUN-B30219 --Begin
#       LET ls_sql = "SELECT ",l_int," FROM DUAL"
#        PREPARE power_curs FROM ls_sql                                                                         
#        EXECUTE power_curs INTO li_result                                                                                                                
#FUN-B30219 --End
        LET li_result = l_int        #FUN-B30219
         RETURN li_result
END FUNCTION  
 
FUNCTION i614_2_qc_formula()
DEFINE n        LIKE type_file.num5
        
        LET l_p='N'
        
        CALL i614_2_b_fill()
        
        FOR n=1 TO  g_rec_b    
           IF (g_boe[n].boe78a='+' OR g_boe[n].boe78a='-'
               OR g_boe[n].boe78a='*' OR g_boe[n].boe78a='/')
               AND (g_boe[n+1].boe78a='+' OR g_boe[n+1].boe78a='-'
               OR g_boe[n+1].boe78a='*' OR g_boe[n+1].boe78a='/') THEN
                CALL cl_err('','abm_618',1)
                RETURN
           END IF
        END FOR
        IF (i614_2_result()) THEN
            CALL cl_err('','abm_617',1)
            LET l_p='Y'
            RETURN
        ELSE
            CALL cl_err('','abm_618',1)
            
            RETURN
        END IF
END FUNCTION 
 
FUNCTION i614_2_fin_formula()
DEFINE  i       LIKE type_file.num5
DEFINE  l_int1       LIKE type_file.num5  
DEFINE  l_re    LIKE type_file.chr1000
        LET l_re = ' '
      IF g_rec_b>0 THEN 
        LET l_re = l_a1[1,LENGTH(l_a1)-1]
      END IF    
         SELECT COUNT(*) INTO l_int1  FROM boe_file WHERE boe01 = g_boe01
                                                      AND boe02 = g_boe02
                                                      AND boe03 = g_boe03
                                                      AND boe04 = g_boe04
                                                      AND boe05 = g_boe05
                                                      AND boe06 = g_boe06
         IF l_int1 >0 THEN
           UPDATE boe_file SET boe08 = l_re
            WHERE boe01=g_boe01 AND boe02=g_boe02 AND boe03=g_boe03 AND boe04=g_boe04 AND boe05=g_boe05 AND boe06=g_boe06
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","boe_file",g_boe01,g_boe02,SQLCA.sqlcode,"","boe",1) 
            ELSE
                LET g_result = l_re    
            END IF
         ELSE
           LET g_result = l_re
         END IF
         IF NOT (cl_confirm('abm_619')) THEN
            RETURN
         ELSE
            LET  g_flag = 1  
         END IF
END FUNCTION
#No:FUN-9C0077

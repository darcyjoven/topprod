# Prog. Version..: '5.30.06-13.04.22(00005)'     #
#  
# Pattern name...: apmi601.4gl
# Descriptions...: 經銷商管理 -  Demo
# Date & Author..: 09/10/27 By vealxu FUN-9C0046
# Modify.........: No.FUN-A10034 10/01/07 By vealxu 
# Modify.........: No:FUN-A90019 10/09/09  1.原程序單身"WEB登入賬號(wpa03)"字段拿掉
#                                          2.增加Action "WEB使用者賬號"
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_pmc           DYNAMIC ARRAY OF RECORD
        pmc01       LIKE pmc_file.pmc01,
        pmc03       LIKE pmc_file.pmc03,
        pmc04       LIKE pmc_file.pmc04,
        pmc02       LIKE pmc_file.pmc02
                    END RECORD, 
        g_smy       RECORD LIKE smy_file.*,
     g_wpa          DYNAMIC ARRAY OF RECORD    
        wpa01       LIKE wpa_file.wpa01,        
        pmc03       LIKE pmc_file.pmc03,
        wpa02       LIKE wpa_file.wpa02,        
        #wpa03       LIKE wpa_file.wpa03,    #FUN-A90019 mark           
        wpa06       LIKE wpa_file.wpa06,
        wpa07       LIKE wpa_file.wpa07,            
        wpa08       LIKE wpa_file.wpa08           
                    END RECORD,
    g_wpa_t         RECORD               
        wpa01       LIKE wpa_file.wpa01,        
        pmc03       LIKE pmc_file.pmc03,
        wpa02       LIKE wpa_file.wpa02,        
        #wpa03       LIKE wpa_file.wpa03,    #FUN-A90019 mark          
        wpa06       LIKE wpa_file.wpa06,
        wpa07       LIKE wpa_file.wpa07,            
        wpa08       LIKE wpa_file.wpa08           
                    END RECORD,
    g_wpa_1      DYNAMIC ARRAY OF RECORD      #FUN-A90019
         wpa03     LIKE wpa_file.wpa03        #FUN-A90019  
         END RECORD,                          #FUN-A90019 
    g_wpa_1_t     RECORD                      #FUN-A90019 
         wpa03     LIKE wpa_file.wpa03        #FUN-A90019 
         END RECORD,                          #FUN-A90019 
    g_wc2           STRING,  
    g_rec_b         LIKE type_file.num5, 
    g_rec_b1        LIKE type_file.num5,      #FUN-A90019            
    l_no            LIKE type_file.num5,
    l_ac            LIKE type_file.num5, 
    l_ac1           LIKE type_file.num5       #FUN-A90019
  DEFINE   g_operation   STRING
  DEFINE   g_sql         STRING
  DEFINE   g_action      STRING
  DEFINE   g_index_wpa   LIKE type_file.num5
  DEFINE   g_before_input_done  LIKE type_file.num5
  DEFINE   g_str         STRING
  DEFINE   g_aza95       LIKE aza_file.aza95
  DEFINE   g_forupd_sql    STRING

MAIN
   DEFINE   lwin_curr   ui.Window

   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log 

   IF ( NOT cl_setup("APM")) THEN
      EXIT PROGRAM 
   END IF
  
   SELECT aza95 INTO g_aza95 FROM aza_file 
   IF g_aza95 = "N" THEN
     CALL cl_err("","apm-699",1)
     EXIT PROGRAM
   END IF
   
   CALL cl_used(g_prog,g_time,1) RETURNING g_time   #No.FUN-B30021

   OPEN WINDOW i601_w WITH FORM "apm/42f/apmi601w"
      ATTRIBUTE(STYLE=g_win_style)
   CALL cl_ui_init()
   LET g_wc2 = '1=1' 
   CALL i601_b_fill(g_wc2)

   WHILE TRUE
      #LET g_action = ""         #FUN-A90019 mark
      IF g_action_choice != "detail" THEN     #FUN-D30034 add
         LET g_action_choice = " "  #FUN-A90019 add
      END IF                                  #FUN-D30034 add
      CALL i601_bp()
      CASE g_action_choice
         WHEN "detail"
            CALL i601_b()

         WHEN "query"
            CALL i601_q()      

         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No.FUN-A90019  --start--
         WHEN "web_purchase"
            IF cl_chk_act_auth() THEN             
             LET l_ac = ARR_CURR()
             IF l_ac>0 THEN 
              IF NOT cl_null(g_wpa[l_ac].wpa01) THEN 
                 IF g_aza.aza95 = 'Y' AND g_wpa[l_ac].wpa02 = 'Y' THEN                  
                    CALL i601_web()
                    CALL i601_b_fill(' 1=1')
                    DISPLAY ARRAY g_wpa TO s_wpa.* ATTRIBUTE(COUNT = g_wpa.getLength())                        
                    END DISPLAY
                 ELSE 
                    CALL cl_err('','apm1035',1)  #電子採購系統設定不可用
                 END IF
               END IF 
             ELSE 
               CALL cl_err('','-400',1) 
             END IF	 
           END IF   
          #No.FUN-A90019  --end-- 	              
      END CASE
   END WHILE

   CLOSE WINDOW i601_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN

FUNCTION i601_bp()

    IF g_action_choice = "detail" THEN                #FUN-D30034 add
       RETURN                                         #FUN-D30034 add
    END IF                                            #FUN-D30034 add

    CALL cl_set_act_visible("accept,cancel",FALSE)
    DISPLAY ARRAY g_wpa TO s_wpa.* ATTRIBUTE(COUNT = g_wpa.getLength()) 
    BEFORE ROW
       LET g_index_wpa = ARR_CURR()
       LET g_wpa_t.* = g_wpa[g_index_wpa].*
    
    ON ACTION detail
       LET l_ac = 1 
       LET g_action_choice = "detail"
       EXIT DISPLAY

    ON ACTION query
       LET g_action_choice = "query"
       EXIT DISPLAY
    
    ON ACTION accept
       LET l_ac = ARR_CURR()
       LET g_action_choice  = "detail"
       EXIT DISPLAY

    ON ACTION close
       LET g_action_choice = "exit"
       EXIT DISPLAY

    ON ACTION exit
       LET g_action_choice = "exit"
       EXIT DISPLAY
  
    ON ACTION controlg
       	LET g_action_choice = "controlg"
        EXIT DISPLAY
    #No.FUN-A90019  --start--       
    ON ACTION web_purchase      #電子採購系統設定
        LET g_action_choice = "web_purchase"
        EXIT DISPLAY
    #No.FUN-A90019  --end--          
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION

FUNCTION i601_q()   
DEFINE p_cmd         LIKE wpa_file.wpa01 
#DEFINE l_wpa03 LIKE wpa_file.wpa03  FUN-A90019 mark
   MESSAGE ""
   CLEAR FORM 
   CALL g_wpa.clear() 
   DIALOG ATTRIBUTES(UNBUFFERED)
   #CONSTRUCT g_wc2 ON wpa01,wpa02,wpa03,wpa06,wpa07,wpa08   #FUN-A90019 mark
   CONSTRUCT g_wc2 ON wpa01,wpa02,wpa06,wpa07,wpa08          #FUN-A90019 add
        #FROM s_wpa[1].wpa01,s_wpa[1].wpa02,s_wpa[1].wpa03,  #FUN-A90019 mark
        FROM s_wpa[1].wpa01,s_wpa[1].wpa02,                  #FUN-A90019 add
             s_wpa[1].wpa06,s_wpa[1].wpa07,s_wpa[1].wpa08 
               
   BEFORE CONSTRUCT
      CALL cl_qbe_init()
               
   ON ACTION controlp 
      CALL cl_init_qry_var()
      CASE
        WHEN INFIELD(wpa01)
           LET g_qryparam.form = "q_pmc01"
           LET g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret 
           DISPLAY g_qryparam.multiret TO wpa01
           NEXT FIELD wpa01
 
#        WHEN INFIELD(wpa03)                               #FUN-A90019 mark
#           CALL q_wzx(0,0,"") RETURNING l_wpa03           #FUN-A90019 mark
#           DISPLAY l_wpa03 TO wpa03                       #FUN-A90019 mark
#           NEXT FIELD wpa03                               #FUN-A90019 mark
           
#        WHEN INFIELD(wpa05)
#           LET g_qryparam.form = "q_smy"
#           LET g_qryparam.arg1 = "apm"
#           LET g_qryparam.arg2 = "6"
#           LET g_qryparam.state = "c"  
#           CALL cl_create_qry() RETURNING g_qryparam.multiret
#           DISPLAY g_qryparam.multiret TO wpa05
#           NEXT FIELD wpa05
            
            
        WHEN INFIELD(wpa06) 
           LET  g_qryparam.form ="q_smy"
           LET  g_qryparam.arg1 = "apm"
           LET  g_qryparam.arg2 = "5"
           LET  g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING g_qryparam.multiret 
           DISPLAY g_qryparam.multiret TO wpa06 
           NEXT FIELD wpa06
     
        WHEN INFIELD(wpa07)
           LET  g_qryparam.form = "q_smy"
           LET  g_qryparam.arg1 = "apm"
           LET  g_qryparam.arg2 = "2"
           LET  g_qryparam.state = "c"
           CALL cl_create_qry() RETURNING  g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO wpa07
           NEXT FIELD wpa07

        WHEN INFIELD(wpa08) 
           LET g_qryparam.form = "q_smy"
           LET g_qryparam.arg1 = "apm"
           LET g_qryparam.arg2 = "3"
           LET g_qryparam.state = "c"
           CALL  cl_create_qry() RETURNING g_qryparam.multiret
           DISPLAY g_qryparam.multiret TO wpa08
           NEXT FIELD wpa08
           OTHERWISE
              EXIT CASE
        END CASE
       
   END CONSTRUCT

   ON ACTION close
      EXIT DIALOG 

   ON ACTION accept
      ACCEPT DIALOG

   ON ACTION cancel
      EXIT DIALOG      
   
   ON ACTION controlg
      CALL cl_cmdask()

   END DIALOG

   LET g_wc2 = g_wc2 CLIPPED 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
   CALL i601_b_fill(g_wc2)
END FUNCTION

FUNCTION i601_b_fill(p_wc)
   DEFINE   p_wc     STRING
   DEFINE   li_cnt   LIKE type_file.num5

   #LET g_sql = "SELECT wpa01,'',wpa02,wpa03,wpa06,wpa07,wpa08",   #FUN-A90019 mark
   LET g_sql = "SELECT DISTINCT wpa01,'',wpa02,wpa06,wpa07,wpa08", #FUN-A90019 add
               "  FROM wpa_file",
               " WHERE ", p_wc CLIPPED,            
               " ORDER BY 1"

   PREPARE wpa_pre FROM g_sql
   DECLARE wpa_curs CURSOR FOR wpa_pre

   CALL g_wpa.clear()
   LET li_cnt = 1 
   MESSAGE "Searching" 
   FOREACH wpa_curs INTO g_wpa[li_cnt].*  
       SELECT pmc03 INTO g_wpa[li_cnt].pmc03 FROM pmc_file
       WHERE pmc01=g_wpa[li_cnt].wpa01
       LET li_cnt = li_cnt + 1
       IF li_cnt > g_max_rec THEN 
          CALL cl_err("",9035,0)
          EXIT FOREACH
       END IF 
   END FOREACH
   CALL g_wpa.deleteElement(li_cnt)
   MESSAGE ""
   LET g_rec_b = li_cnt-1
   LET li_cnt = 0 
END FUNCTION

FUNCTION i601_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,                
      l_pmc03         LIKE pmc_file.pmc03,
      #l_wpa03         LIKE wpa_file.wpa03,   #FUN-A90019 mark
      l_n             LIKE type_file.num5,                
      l_lock_sw       LIKE type_file.chr1,                
      p_cmd           LIKE type_file.chr1,                
      l_allow_insert  LIKE type_file.chr1,  
      l_allow_delete  LIKE type_file.chr1,
      li_cnt          LIKE type_file.num10
#      g_forupd_sql    STRING                 #FUN-A90019 mark
 
    LET g_action_choice = "" 
    LET g_forupd_sql = "SELECT wpa01,wpa02,'',wpa03,wpa06,wpa07,wpa08 FROM wpa_file",
                       " WHERE wpa01=? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    PREPARE i601_pre FROM g_forupd_sql

    DECLARE i601_bcl CURSOR FOR i601_pre     
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    INPUT ARRAY g_wpa WITHOUT DEFAULTS FROM s_wpa.*
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
            LET l_n = 	ARR_COUNT()
            
            BEGIN WORK

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'                                                         
               LET g_before_input_done = FALSE                                  
               CALL i601_set_entry(p_cmd)                                       
               CALL i601_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                         
               LET g_wpa_t.* = g_wpa[l_ac].* 
               OPEN i601_bcl USING g_wpa_t.wpa01
               IF STATUS THEN
                   LET l_lock_sw = "Y"
               ELSE 
               	 IF SQLCA.sqlcode AND SQLCA.sqlcode != -284 THEN
                  FETCH i601_bcl INTO g_wpa[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     LET l_lock_sw = "Y"
                  END IF
                 END IF
                  SELECT pmc03 INTO g_wpa[l_ac].pmc03 FROM pmc_file WHERE pmc01 = g_wpa[l_ac].wpa01
               END IF  
            END IF
 
        BEFORE INSERT
           LET p_cmd='a'                                                         
           LET g_before_input_done = FALSE                                      
           CALL i601_set_no_entry(p_cmd)                                        
           CALL i601_set_entry(p_cmd)                                           
           LET g_before_input_done = TRUE                                           
           INITIALIZE g_wpa[l_ac].* TO NULL           
           LET g_wpa[l_ac].wpa02 = 'N'       
           LET g_wpa_t.* = g_wpa[l_ac].*     
           NEXT FIELD wpa01
  
        AFTER INSERT
           DISPLAY "AFTER  INSERT"
           IF INT_FLAG THEN
              CALL cl_err("",9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_wpa[l_ac].wpa02 = 'Y' THEN 
             CALL i601_web()
             LET g_rec_b=g_rec_b+1
             DISPLAY ARRAY g_wpa TO s_wpa.* ATTRIBUTE(COUNT = g_wpa.getLength())
               
             END DISPLAY
            END IF
#           INSERT INTO wpa_file(wpa01,wpa02,wpa03,wpa06,wpa07,wpa08)   
#           #              VALUES(g_wpa[l_ac].wpa01,g_wpa[l_ac].wpa02,g_wpa[l_ac].wpa03, #FUN-A90019 mark              
#                          VALUES(g_wpa[l_ac].wpa01,g_wpa[l_ac].wpa02,' ',               #FUN-A90019 add
#                                g_wpa[l_ac].wpa06,g_wpa[l_ac].wpa07,g_wpa[l_ac].wpa08)
#           IF SQLCA.sqlcode THEN
#              CANCEL INSERT
#           ELSE
#              MESSAGE 'INSERT O.K'
#              COMMIT WORK
#              LET g_rec_b=g_rec_b+1
#           END IF

        AFTER FIELD wpa01                      
            IF NOT cl_null(g_wpa[l_ac].wpa01) THEN
               IF g_wpa[l_ac].wpa01 != g_wpa_t.wpa01 OR
                  g_wpa_t.wpa01 IS NULL THEN
                   SELECT count(*) INTO l_no FROM wpa_file
                       WHERE wpa01 = g_wpa[l_ac].wpa01
                   IF l_no > 0 THEN
                       CALL cl_err("",-1100,0)
                       LET g_wpa[l_ac].wpa01 = g_wpa_t.wpa01
                       NEXT FIELD wpa01
                   END IF
#               END IF                    #No.FUN-A90019 mark
                   LET l_no = 0 
                   SELECT count(*) INTO l_no FROM pmc_file 
                      WHERE pmc01 = g_wpa[l_ac].wpa01 AND pmcacti='Y'
                   IF l_no > 0 THEN
                      SELECT pmc03 INTO g_wpa[l_ac].pmc03 FROM pmc_file
                         WHERE pmc01 = g_wpa[l_ac].wpa01 
                   ELSE
                         CALL cl_err("","apm-404",0)
                         NEXT FIELD wpa01
                   END IF 
                   DISPLAY BY NAME g_wpa[l_ac].wpa01
                END IF                   #No.FUN-A90019 add
#            ELSE
#               CALL cl_err("",-1100,0)
#               NEXT FIELD wpa01 
            END IF
#FUN-A90019 -start--         
#         AFTER FIELD wpa02  
#            IF g_wpa[l_ac].wpa02='Y' THEN   
#               CALL i601_check() RETURNING l_no 
#               IF l_no = 0 THEN 
#                  CALL cl_err('','wpa-021',0)
#                  LET g_wpa[l_ac].wpa02='N'  
#                  NEXT FIELD wpa02                
#                  CALL cl_set_comp_entry("wpa06,wpa07,wpa08",FALSE)
#               END IF          
#               CALL cl_set_comp_entry("wpa03,wpa06,wpa07,wpa08",TRUE)  
#            ELSE                                                        
##               CALL cl_set_comp_entry("wpa06,wpa07,wpa08",FALSE)  
#            END IF         	  
#            IF g_wpa[l_ac].wpa02 = "N" AND p_cmd = "u" THEN
#               LET g_wpa[l_ac].wpa03 = null  
#               LET g_wpa[l_ac].wpa06 = null
#               LET g_wpa[l_ac].wpa07 = null
#               LET g_wpa[l_ac].wpa08 = null                             
#               UPDATE wpa_file SET wpa03 = null,
#                                   wpa06 = null,
#                                   wpa07 = null,
#                                   wpa08 = null
#               WHERE wpa01 = g_wpa[l_ac].wpa01
#            END IF 
#            IF g_wpa[l_ac].wpa02 = "Y" THEN
#               NEXT FIELD wpa03
#            END IF 
#            CALL DIALOG.setCurrentRow("s_wpa",l_ac+1)
#FUN-A90019 -end--   
  
      ON CHANGE wpa02 
         IF g_wpa[l_ac].wpa02 = "Y" THEN
            #CALL cl_set_comp_entry("wpa03,wpa06,wpa07,wpa08",TRUE)  #FUN-A90019 mark
            CALL cl_set_comp_entry("wpa06,wpa07,wpa08",TRUE)         #FUN-A90019 add
            CALL i601_check() RETURNING l_no 
               IF l_no = 0 THEN 
                  CALL cl_set_comp_entry("wpa06,wpa07,wpa08",FALSE)
                  CALL cl_err('','wpa-021',0)
                  LET g_wpa[l_ac].wpa02='N'  
                  NEXT FIELD wpa02                                  
               END IF  
          ELSE
          	IF g_wpa[l_ac].wpa02 = "N" AND p_cmd = "u" THEN
          	   IF cl_confirm('wpa-02') THEN                         #FUN-A90019 add
                 CALL cl_set_comp_entry("wpa06,wpa07,wpa08",FALSE)  #FUN-A90019 add        	                   
                 LET g_wpa[l_ac].wpa06 = null
                 LET g_wpa[l_ac].wpa07 = null
                 LET g_wpa[l_ac].wpa08 = NULL                  
                 DELETE FROM wpa_file WHERE wpa01 = g_wpa_t.wpa01  
             	   IF SQLCA.sqlcode AND SQLCA.sqlerrd[3]=0 THEN
                   LET g_wpa[l_ac].* = g_wpa_t.*
                   ROLLBACK WORK
                 END IF
             	   INSERT INTO wpa_file(wpa01,wpa02) VALUES(g_wpa_t.wpa01,'N')
             	   IF SQLCA.sqlcode THEN
                   LET g_wpa[l_ac].* = g_wpa_t.*
                   ROLLBACK WORK
                 ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                 END IF
               ELSE
               	 LET g_wpa[l_ac].wpa02 = g_wpa_t.wpa02
               END IF            
            ELSE                  
               CALL cl_set_comp_entry("wpa06,wpa07,wpa08",FALSE)  #FUN-A90019 add        	    
            END IF
          END IF 
                          
#      BEFORE  FIELD wpa03                    #FUN-A90019 mark
#         IF g_wpa[l_ac].wpa02 = "N" THEN     #FUN-A90019 mark
#           NEXT FIELD wpa02                  #FUN-A90019 mark
#         END IF         

#No.FUN-A90019  --mark start--
#      AFTER FIELD wpa03
#         DISPLAY "AFTER FIELD wpa03" 
#         LET l_n = 0
#         IF NOT cl_null(g_wpa[l_ac].wpa03) THEN
#            IF p_cmd = "u" AND g_wpa_t.wpa03 = g_wpa[l_ac].wpa03 THEN
#            ELSE   
#            SELECT count(*) INTO l_n FROM wds.wzx_file
#               WHERE wzx01 = g_wpa[l_ac].wpa03
#            IF l_n = 0  THEN
#               CALL cl_err("","asfi115",0)
#               NEXT FIELD wpa03
#            END IF
#         ELSE     
#            CALL cl_err("wpa03",-1124,0)
#            NEXT FIELD wpa03
#         END IF
#No.FUN-A90019  --mark end--
               
#      AFTER FIELD wpa05
#         DISPLAY "AFTER FIELD wpa05"
#         LET l_n = 0
#         IF NOT cl_null(g_wpa[l_ac].wpa05) THEN
#         SELECT COUNT(*) INTO l_n FROM smy_file WHERE smysys='apm' AND smykind='6'AND 
#                smyacti='Y' AND smyslip = g_wpa[l_ac].wpa05
#            IF l_n = 0 THEN  
#               CALL cl_err("wpa05","apm-404",0)
#               NEXT FIELD wpa05
#            END IF
#         ELSE
#            CALL cl_err("",-1124,0)
#            NEXT FIELD wpa05
#         END IF

      BEFORE FIELD wpa06 
        IF g_wpa[l_ac].wpa02 = "N" THEN
           NEXT FIELD wpa02
        END IF 
  
      AFTER FIELD wpa06 
        DISPLAY "AFTER FIELD wpa06"
        LET l_n = 0
        IF NOT cl_null(g_wpa[l_ac].wpa06) THEN 
        SELECT COUNT(*) INTO l_n FROM smy_file WHERE smysys='apm'AND smykind = '5'AND
               smyacti='Y' AND smyslip = g_wpa[l_ac].wpa06
           IF l_n = 0 THEN  
              CALL cl_err("wpa06","apm-404",0)
              NEXT FIELD wpa06
           END IF
        ELSE
           CALL cl_err("","-1124",0)
           NEXT FIELD wpa06
        END IF 
           
      BEFORE FIELD wpa07 
         IF g_wpa[l_ac].wpa02 = "N" THEN
            NEXT FIELD wpa02
         END IF 

      AFTER FIELD wpa07
         DISPLAY "AFTER FIELD wpa07"
         LET l_n = 0
         IF NOT cl_null(g_wpa[l_ac].wpa07) THEN 
         SELECT COUNT(*) INTO l_n FROM smy_file WHERE smysys = 'apm' AND smykind = '2' AND
                smyacti = 'Y' AND smyslip = g_wpa[l_ac].wpa07
         IF l_n = 0 THEN 
            CALL cl_err("wpa07","apm-404",0)
            NEXT FIELD wpa07
         END IF
         ELSE
            CALL cl_err("",-1124,0)
            NEXT FIELD wpa07
         END IF 
  
      BEFORE FIELD wpa08
        IF g_wpa[l_ac].wpa02 = "N" THEN 
           NEXT FIELD wpa02
        END IF 

      AFTER FIELD wpa08 
         DISPLAY "AFTER FIELD wpa08"
         LET l_n = 0
         IF NOT cl_null(g_wpa[l_ac].wpa08) THEN 
         SELECT COUNT(*) INTO l_n FROM smy_file WHERE smysys='apm' AND smykind = '3' AND 
                smyacti = 'Y' AND smyslip = g_wpa[l_ac].wpa08              
            IF l_n = 0 THEN           
               CALL cl_err("wpa08","apm-404",0)
               NEXT FIELD wpa08
            END IF
         ELSE
            CALL cl_err("",-1124,0)
            NEXT FIELD wpa08
         END IF 
 
        BEFORE DELETE                           
            IF g_wpa_t.wpa01 IS NOT NULL THEN
                IF l_lock_sw = "Y" THEN 
                    CALL cl_err("wpa01",-263,0)
                   CANCEL DELETE 
                END IF 
                DELETE FROM wpa_file WHERE wpa01 = g_wpa_t.wpa01
#                IF SQLCA.sqlcode THEN   #FUN-A90019 mark
#                   EXIT INPUT           #FUN-A90019 mark
#                END IF                  #FUN-A90019 mark
                #No.FUN-A90019 --start--
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN         
                   LET g_wpa[l_ac].* = g_wpa_t.*
                   ROLLBACK WORK
                   EXIT INPUT
                ELSE 
                  MESSAGE 'DELETE O.K'
                  LET g_rec_b=g_rec_b-1
                  COMMIT WORK
                END IF
                #No.FUN-A90019 --end--
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              LET INT_FLAG = 0
              LET g_wpa[l_ac].* = g_wpa_t.*
              CLOSE i601_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err("",-263,0)
               LET g_wpa[l_ac].* = g_wpa_t.*
           ELSE
#             IF g_wpa[l_ac].wpa02 = "Y" THEN
                UPDATE wpa_file SET 
                                   wpa02=g_wpa[l_ac].wpa02,
                                   #wpa03=g_wpa[l_ac].wpa03,  #FUN-A90019 mark
                                   wpa06=g_wpa[l_ac].wpa06,
                                   wpa07=g_wpa[l_ac].wpa07,
                                   wpa08=g_wpa[l_ac].wpa08            
                WHERE wpa01 = g_wpa_t.wpa01
                IF SQLCA.sqlcode THEN
                  LET g_wpa[l_ac].* = g_wpa_t.*
                  ROLLBACK WORK
                ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
                  CALL i601_web()
                  DISPLAY ARRAY g_wpa TO s_wpa.* ATTRIBUTE(COUNT = g_wpa.getLength())                   
                  END DISPLAY
                END IF
#             ELSE             	   
#No.#FUN-A90019 --start--
#                UPDATE wpa_file SET 
#                                  wpa02 = g_wpa[l_ac].wpa02,
#                                  wpa03 = null,              
#                                  wpa06 = null,
#                                  wpa07 = null,
#                                  wpa08 = null
#                WHERE wpa01 = g_wpa_t.wpa01
#             END IF  
#             IF SQLCA.sqlcode THEN
#                LET g_wpa[l_ac].* = g_wpa_t.*
#                ROLLBACK WORK
#             ELSE
#                MESSAGE 'UPDATE O.K'
#                COMMIT WORK
#             END IF   
#No.#FUN-A90019 --end--          
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()                                       
#          LET l_ac_t = l_ac           #FUN-D30034 mark
           IF INT_FLAG THEN 
              CALL cl_err("",9001,0)
#              INITIALIZE g_wpa[l_ac].* TO NULL
#              lET g_wpa[l_ac].wpa02 = "N"
              IF p_cmd = "a" THEN
                 CALL g_wpa.deleteElement(l_ac)
              #FUN-D30034---add---str
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF   
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_wpa[l_ac].* = g_wpa_t.*
              END IF
              CLOSE i601_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac           #FUN-D30034 add
           CLOSE i601_bcl
           COMMIT WORK
                        
        ON ACTION controlp 
         CALL cl_init_qry_var()
         LET g_qryparam.construct = "N"
            CASE
           WHEN INFIELD(wpa01)
              LET g_qryparam.form = "q_pmc01"
              LET g_qryparam.default1 = g_pmc[l_ac].pmc01
              CALL cl_create_qry() RETURNING g_wpa[l_ac].wpa01 
              DISPLAY BY NAME g_wpa[l_ac].wpa01
              NEXT FIELD wpa01
#No.FUN-A90019  --mark start--          
#           WHEN INFIELD(wpa03)
#              CALL q_wzx(0,0,"") RETURNING l_wpa03
#              LET g_wpa[l_ac].wpa03 = l_wpa03
#              DISPLAY BY NAME g_wpa[l_ac].wpa03
#              NEXT FIELD wpa03
#No.FUN-A90019  --mark end--      
#           WHEN INFIELD(wpa05)
#              LET g_qryparam.form = "q_smy"
#              LET g_qryparam.arg1 = "apm"
#              LET g_qryparam.arg2 = "6"
#              LET g_qryparam.default1 =g_smy.smyslip
#              CALL cl_create_qry() RETURNING g_wpa[l_ac].wpa05
#              DISPLAY BY NAME g_wpa[l_ac].wpa05
#              NEXT FIELD wpa05
            
           WHEN INFIELD(wpa06) 
              LET  g_qryparam.form ="q_smy"
              LET  g_qryparam.arg1 = "apm"
              LET  g_qryparam.arg2 = "5"
              LET  g_qryparam.default1 = g_smy.smyslip
              CALL cl_create_qry() RETURNING g_wpa[l_ac].wpa06 
              DISPLAY BY NAME g_wpa[l_ac].wpa06  
              NEXT FIELD wpa06

           
           WHEN INFIELD(wpa07)
              LET  g_qryparam.form = "q_smy"
              LET  g_qryparam.arg1 = "apm"
              LET  g_qryparam.arg2 = "2"
              LET g_qryparam.default1 =g_smy.smyslip
              CALL cl_create_qry() RETURNING  g_wpa[l_ac].wpa07
              DISPLAY BY NAME g_wpa[l_ac].wpa07
              NEXT FIELD wpa07

           WHEN INFIELD(wpa08) 
              LET g_qryparam.form = "q_smy"
              LET g_qryparam.arg1 = "apm"
              LET g_qryparam.arg2 = "3"
              LET g_qryparam.default1 =g_smy.smyslip
              CALL  cl_create_qry() RETURNING g_wpa[l_ac].wpa08
              DISPLAY BY NAME g_wpa[l_ac].wpa08
              NEXT FIELD wpa08
            OTHERWISE
              EXIT CASE
          END CASE  
                 
        ON IDLE g_idle_seconds 
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about
           CALL cl_about()
   
        ON ACTION help
           CALL cl_show_help()
        END INPUT 

    CLOSE i601_bcl
    COMMIT WORK
 
END FUNCTION
              
FUNCTION i601_check()
   DEFINE l_pmc17 LIKE pmc_file.pmc17,
          l_pmc49 LIKE pmc_file.pmc49,
          l_pmc22 LIKE pmc_file.pmc22,
          l_pmc47 LIKE pmc_file.pmc47, 
          l_no    LIKE type_file.num5 

   SELECT pmc17,pmc49,pmc22,pmc47 INTO l_pmc17,l_pmc49,l_pmc22,l_pmc47 FROM pmc_file WHERE pmc01=g_wpa[l_ac].wpa01
   IF cl_null(l_pmc17) OR cl_null(l_pmc49) OR cl_null(l_pmc22) OR cl_null(l_pmc47) THEN 
      LET l_no = 0 
   ELSE 
      LET l_no = 1 
   END IF 
   RETURN l_no 	
    
END FUNCTION
            
       
FUNCTION i601_set_entry(p_cmd)                                                  
   DEFINE p_cmd   LIKE type_file.chr1 
  
   IF p_cmd ='a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("wpa01,wpa02",TRUE)
      #CALL cl_set_comp_entry("wpa03,wpa06,wpa07,wpa08",FALSE)         #FUN-A90019
      CALL cl_set_comp_entry("wpa03,wpa06,wpa07,wpa08",FALSE)          #FUN-A90019
   END IF  
END FUNCTION   
  
FUNCTION i601_set_no_entry(p_cmd)                                                  
   DEFINE p_cmd   LIKE type_file.chr1 
   IF p_cmd ='u' AND (NOT g_before_input_done)  THEN
      IF g_wpa[l_ac].wpa02 = "Y" THEN
         CALL cl_set_comp_entry("wpa01",FALSE)
         #CALL cl_set_comp_entry("wpa02,wpa03,wpa06,wpa07,wpa08",TRUE) #FUN-A90019
         CALL cl_set_comp_entry("wpa02,wpa06,wpa07,wpa08",TRUE)        #FUN-A90019
      ELSE
        #CALL cl_set_comp_entry("wpa01,wpa03,wpa06,wpa07,wpa08",FALSE) #FUN-A90019
        CALL cl_set_comp_entry("wpa01,wpa06,wpa07,wpa08",FALSE)        #FUN-A90019
        CALL cl_set_comp_entry("wpa02",TRUE)
     END IF 
   END IF
END FUNCTION
#No.FUN-9C0046---end---
#No.FUN-A10034---end---

#No.FUN-A90019 --start--
FUNCTION i601_web_b()
   DEFINE   
    l_ac1_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n              LIKE type_file.num5,                #檢查重複用
    l_n1             LIKE type_file.num5,                #檢查重複用  
    l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否  
    p_cmd            LIKE type_file.chr1,                 #處理狀態  
    l_cmd            LIKE type_file.chr1000,             #可新增否  
    l_wpa     RECORD LIKE wpa_file.*,
    l_allow_insert   LIKE type_file.num5,                #可新增否  
    l_allow_delete   LIKE type_file.num5,                 #可刪除否  
    l_wpa03          LIKE wpa_file.wpa03,
    l_wpa01          LIKE wpa_file.wpa01
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_wpa[l_ac].wpa02 = 'N' THEN
       RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT wpa03",  
                       "  FROM wpa_file",   
                       "  WHERE wpa01= ? AND wpa03 = ? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_web_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_wpa_1 WITHOUT DEFAULTS FROM s_wpa_1.*
          ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b1 != 0 THEN
              CALL fgl_set_arr_curr(1)
         END IF
        BEFORE ROW
          LET p_cmd = ''
          LET l_ac1 = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
   
          IF g_rec_b1 >= l_ac1 THEN
             BEGIN WORK
             LET p_cmd='u'
             LET g_wpa_1_t.* = g_wpa_1[l_ac1].*  #BACKUP
             LET l_wpa03 = g_wpa_1_t.wpa03 
             OPEN i601_web_bcl USING g_wpa[l_ac].wpa01,g_wpa_1_t.wpa03
             IF STATUS THEN
                CALL cl_err("OPEN i601_web_bcl:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                FETCH i601_web_bcl INTO g_wpa_1[l_ac1].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_wpa[l_ac].wpa01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                ELSE
                   LET g_wpa_1_t.*=g_wpa_1[l_ac1].*
                   LET l_wpa03 = g_wpa_1_t.wpa03                                       
                END IF
             END IF
             CALL cl_show_fld_cont() 
          END IF
      
      BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          LET g_wpa_1_t.*=g_wpa_1[l_ac1].*         
          CALL cl_show_fld_cont()  
                 
      AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           LET l_wpa.wpa01=g_wpa[l_ac].wpa01
           LET l_wpa.wpa02=g_wpa[l_ac].wpa02
           LET l_wpa.wpa03=g_wpa_1[l_ac1].wpa03
           LET l_wpa.wpa06=g_wpa[l_ac].wpa06
           LET l_wpa.wpa07=g_wpa[l_ac].wpa07
           LET l_wpa.wpa08=g_wpa[l_ac].wpa08
           INSERT INTO wpa_file VALUES(l_wpa.*)
             IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","wpa_file","","",SQLCA.sqlcode,"","",1)  
               CANCEL INSERT
             ELSE
               MESSAGE 'INSERT O.K' 
               COMMIT WORK               
             END IF          
           
      AFTER FIELD wpa03                                 
       LET l_n=0
       LET l_n1=0
  	   IF NOT cl_null(g_wpa_1[l_ac1].wpa03) THEN 
  	    IF g_wpa_1_t.wpa03 IS NULL OR 
           g_wpa_1[l_ac1].wpa03 != g_wpa_1_t.wpa03 THEN
              SELECT COUNT(*) INTO l_n FROM wpa_file
               WHERE wpa03 = g_wpa_1[l_ac1].wpa03                                                  
              IF l_n > 0 THEN
                 SELECT wpa01 INTO l_wpa01 
                   FROM wpa_file
                  WHERE wpa03 = g_wpa_1[l_ac1].wpa03
                 IF l_wpa01 = g_wpa[l_ac].wpa01 THEN 
                    CALL cl_err('',-239,0)
                    LET g_wpa_1[l_ac1].wpa03 = g_wpa_1_t.wpa03
                    NEXT FIELD wpa03
                 ELSE
                 	  CALL cl_err(l_wpa01,'wpa-03',0)
                    LET g_wpa_1[l_ac1].wpa03 = g_wpa_1_t.wpa03
                    NEXT FIELD wpa03
                 END IF
              END IF
       	     SELECT COUNT(*) INTO l_n1 FROM wds.wzx_file
               WHERE wzx01 = g_wpa_1[l_ac1].wpa03
               IF l_n1 = 0  THEN
                  CALL cl_err('','asfi115',0)
                  LET g_wpa_1[l_ac1].wpa03 = g_wpa_1_t.wpa03
                  NEXT FIELD wpa03
               END IF
        END IF
       END IF      
     BEFORE DELETE                            #是否取消單身     
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         DELETE FROM wpa_file
          WHERE wpa01=g_wpa[l_ac].wpa01 
            AND wpa03=g_wpa_1_t.wpa03
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","wpa_file","","",SQLCA.sqlcode,"","",1) 
            ROLLBACK WORK
            CANCEL DELETE  
         ELSE
            MESSAGE 'DELETE O.K'           
            COMMIT WORK
         END IF    
         LET g_rec_b1 = g_rec_b1-1
      COMMIT WORK
 
     ON ROW CHANGE
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           LET g_wpa_1[l_ac1].* = g_wpa_1_t.*
           CLOSE i601_web_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
        IF l_lock_sw = 'Y' THEN           
           CALL cl_err(g_wpa[l_ac].wpa01,-263,1)
           LET g_wpa_1[l_ac1].* = g_wpa_1_t.*
        ELSE
           UPDATE wpa_file SET wpa03=g_wpa_1[l_ac1].wpa03                             
            WHERE wpa01=g_wpa[l_ac].wpa01 
              AND wpa03=g_wpa_1_t.wpa03 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","wpa_file","","",SQLCA.sqlcode,"","",1)  
              LET g_wpa_1[l_ac1].* = g_wpa_1_t.*
           ELSE
              MESSAGE 'UPDATE O.K'              
              COMMIT WORK
           END IF
        END IF

     AFTER ROW
        LET l_ac1 = ARR_CURR()
        LET l_ac1_t = l_ac1  
        IF INT_FLAG THEN
           CALL cl_err('',9001,0)
           LET INT_FLAG = 0
           IF p_cmd = 'u' THEN
              LET g_wpa_1[l_ac1].* = g_wpa_1_t.*
           END IF
           CLOSE i601_web_bcl
           ROLLBACK WORK
           EXIT INPUT
        END IF
       
    ON ACTION CONTROLP
       CASE
         WHEN INFIELD(wpa03)
         CALL q_wzx(0,0,'') RETURNING l_wpa03
         LET g_wpa_1[l_ac1].wpa03 = l_wpa03
         DISPLAY BY NAME g_wpa_1[l_ac1].wpa03 
         NEXT FIELD wpa03
       END CASE
    END INPUT
        CLOSE i601_web_bcl
        COMMIT WORK
END FUNCTION

FUNCTION i601_web_b_fill(p_wc)
    DEFINE p_wc   STRING 
    DEFINE li_cnt   LIKE type_file.num5    
    LET g_sql = "SELECT wpa03",
                " FROM wpa_file ",
                " WHERE wpa01 =  '",g_wpa[l_ac].wpa01,"' ",
                " AND ",p_wc CLIPPED
   PREPARE i601_prepare2 FROM g_sql      #預備一下
   DECLARE wpa_curs1 CURSOR FOR i601_prepare2
 
   CALL g_wpa_1.clear()
   LET li_cnt = 1 
   MESSAGE "Searching" 
 
   FOREACH wpa_curs1 INTO g_wpa_1[li_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET li_cnt = li_cnt + 1
       IF li_cnt > g_max_rec THEN 
          CALL cl_err("",9035,0)
          EXIT FOREACH
       END IF 
   END FOREACH
   CALL g_wpa_1.deleteElement(li_cnt)
   MESSAGE ""
   LET g_rec_b1 = li_cnt-1
   LET li_cnt = 0  
END FUNCTION

FUNCTION i601_web()
 
   OPEN WINDOW i601_web WITH FORM "apm/42f/apmi601_web"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)  
   CALL cl_ui_locale("apmi601_web")     
   DISPLAY g_wpa[l_ac].wpa01 TO wpa01
   DISPLAY g_wpa[l_ac].pmc03 TO pmc03
   
   CALL i601_web_b_fill(' 1=1')         #單身  
   DISPLAY ARRAY g_wpa_1 TO s_wpa_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY                                                                                                               
          EXIT DISPLAY                                                                                                              
   END DISPLAY 
      
   CALL i601_web_b()    
  CLOSE WINDOW i601_web
   
END FUNCTION 
#No.#FUN-A90019  --end--

# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: anmq011.4gl
# Descriptions...: 網銀歷史支付查詢作業 
# Date & Author..: No.FUN-B30213 11/05/18 By lixia
# Modify.........: No.FUN-B30213 11/07/13 By zm Add nme27

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE 
    g_nps      DYNAMIC ARRAY OF RECORD        
               nme27     LIKE nme_file.nme27,
               nps01     LIKE nps_file.nps01,
               nme22     LIKE nme_file.nme22,
               nme13     LIKE nme_file.nme13,
               nps03     LIKE nps_file.nps03,
               nps05     LIKE nps_file.nps05,
               nps14     LIKE nps_file.nps14,
               nps07     LIKE nps_file.nps07,
               nps08     LIKE nps_file.nps08,
               nps09     LIKE nps_file.nps09,
               nps26     LIKE nps_file.nps26,   
               nps10     LIKE nps_file.nps10,
               nps11     LIKE nps_file.nps11,
               nps27     LIKE nps_file.nps27,   
               nps12     LIKE nps_file.nps12,
               nps13     LIKE nps_file.nps13,
               nps20     LIKE nps_file.nps20,
               nps15     LIKE nps_file.nps15,
               nps16     LIKE nps_file.nps16,
               nps17     LIKE nps_file.nps17
               END RECORD 
DEFINE g_wc2,g_sql       STRING 
DEFINE g_rec_b           LIKE type_file.num5            #單身筆數
DEFINE l_ac              LIKE type_file.num5            #目前處理的ARRAY CNT
DEFINE g_cnt             LIKE type_file.num10 
 
MAIN 
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time              
 
   OPEN WINDOW q011_w WITH FORM "anm/42f/anmq011"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
 
   CALL q011_menu()
 
   CLOSE WINDOW q011_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time                           
END MAIN
 
FUNCTION q011_menu()
 
   WHILE TRUE
      CALL q011_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q011_q()
            END IF         
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nps),'','')
            END IF         
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q011_q()
   DEFINE   l_nme25       LIKE nme_file.nme25
   DEFINE   l_nma39       LIKE nma_file.nma39
   DEFINE   l_nps01       LIKE nps_file.nps01        
   DEFINE   l_nps03       LIKE nps_file.nps03 

   CLEAR FORM
   CALL g_nps.clear()
   
   CONSTRUCT g_wc2 ON nme27,nps01,nps03,nps05,nps14,nps07,nps08,nps09,
                      nps26,nps10,nps11,nps27,nps12,nps13,nps15,nps16,nps17           
        FROM s_nps[1].nme27,s_nps[1].nps01,s_nps[1].nps03,s_nps[1].nps05,s_nps[1].nps14,s_nps[1].nps07,s_nps[1].nps08,s_nps[1].nps09,  
             s_nps[1].nps26,s_nps[1].nps10,s_nps[1].nps11,s_nps[1].nps27,s_nps[1].nps12,s_nps[1].nps13,s_nps[1].nps15,
             s_nps[1].nps16,s_nps[1].nps17
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      
      ON ACTION controlg      
         CALL cl_cmdask()  
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
          
      ON ACTION qbe_save
		   CALL cl_qbe_save()
 
      ON ACTION CONTROLP
         IF INFIELD(nps01) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps01"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps01
            NEXT FIELD nps01
         END IF 
         
         IF INFIELD(nps05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps05"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps05
            NEXT FIELD nps05
         END IF    
         
         IF INFIELD(nps07) THEN
            CALL GET_FLDBUF(nps01) RETURNING l_nps01                            
            CALL GET_FLDBUF(nps03) RETURNING l_nps03                             
#            IF l_nps03 ='N02031' OR l_nps03 ='N0041' THEN                        
#               CALL cl_init_qry_var()
#               LET g_qryparam.state ="c"
#               LET g_qryparam.form ="q_nps07_02"
#               SELECT nme25 INTO l_nme25 FROM nme_file
#                WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =l_nps01            
#               LET g_qryparam.arg1= l_nme25
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO nps07
#               NEXT FIELD nps07
#            END IF           
#            IF l_nps03 ='N02020' THEN                                            
               CALL cl_init_qry_var()
               LET g_qryparam.state ="c"
               LET g_qryparam.form ="q_nps07_01"
               SELECT nma39 INTO l_nma39 FROM nma_file,nme_file   
                WHERE nma01 =nme01 AND nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =l_nps01               #MOD-A80006
               LET g_qryparam.arg1 =l_nma39
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nps07
               NEXT FIELD nps07
#            END IF
         END IF 
        
         IF INFIELD(nps09) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps09"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps09
            NEXT FIELD nps09
         END IF
        
         IF INFIELD(nps10) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps10"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps10
            NEXT FIELD nps10
         END IF
 
         IF INFIELD(nps11) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps11"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps11
            NEXT FIELD nps11
         END IF
 
         IF INFIELD(nps13) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.state ="c"
            LET g_qryparam.form ="q_nps13"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO nps13
            NEXT FIELD nps13
         END IF
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF 
   CALL q011_b_fill(g_wc2)
   
END FUNCTION

FUNCTION q011_b_fill(p_wc2)      
   DEFINE  p_wc2    STRING         
 
   {LET g_sql = "SELECT '',nps01,'','',nps03,nps05,nps14,nps07,nps08,nps09,nps26,",  
               "       nps10,nps11,nps27,nps12,nps13,nps20,nps15,nps16,nps17",       
               "  FROM nps_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY nps01"}
   LET g_sql = "SELECT nme27,nps01,nme22,nme13,nps03,nps05,nps14,nps07,nps08,nps09,nps26,",  
               "       nps10,nps11,nps27,nps12,nps13,nps20,nps15,nps16,nps17",       
               "  FROM nps_file,nme_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               "   AND nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =nps01  ",
               " ORDER BY nps01"
   PREPARE q011_pb FROM g_sql
   DECLARE nps_curs CURSOR FOR q011_pb
 
   CALL g_nps.clear() 
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH nps_curs INTO g_nps[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      
      IF g_nps[g_cnt].nps14 =cl_getmsg('anm-801','2') THEN
         LET g_nps[g_cnt].nps14 =1
      END IF
      IF g_nps[g_cnt].nps14 =cl_getmsg('anm-802','2') THEN
         LET g_nps[g_cnt].nps14 =2
      END IF
 
 #     SELECT nme13,nme22,nme27 INTO g_nps[g_cnt].nme13,g_nps[g_cnt].nme22,g_nps[g_cnt].nme27 FROM nme_file 
 #      WHERE nme22||'_'||nme12||'_'||rtrim(ltrim(nme21)) =g_nps[g_cnt].nps01
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF 
   END FOREACH
 
   CALL g_nps.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cnt  
   LET g_cnt = 0 
END FUNCTION
 
FUNCTION q011_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1         
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " " 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nps TO s_nps.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY 
      
      ON ACTION exit
         LET g_action_choice="exit"
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
   
      ON ACTION exporttoexcel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY    
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION   
#FUN-B30213--end--

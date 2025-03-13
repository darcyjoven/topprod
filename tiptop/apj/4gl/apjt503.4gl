# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
#Patternn name..: apjt503.4gl
#description....: WBS實際進度確認維護作業
#Data & Author..: FUN-790025 2007/11/16 By shiwuying
#Modify.........: No.TQC-840018 2008/04/08 By shiwuying
#Modify.........: No.FUN-8C0123 2009/02/20 By mike MSV BUG
# Modify.........:No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........:No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........:No.FUN-960038 09/07/31 By chenmoyan 專案加上'結案'的判斷
# Modify.........:No.FUN-B30054 11/03/11 By sabrina 專案代號欄位增加開窗功能
# Modify.........:No.MOD-B30143 11/03/11 By sabrina FETCH()在抓t503_cs時有誤 
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds 
 
GLOBALS "../../config/top.global"
DEFINE  g_pjb	     RECORD LIKE pjb_file.*,
	g_pjb_t	     RECORD LIKE pjb_file.*,
	g_pjb01_t    LIKE  pjb_file.pjb01, #No.FUN-8C0123
        g_pjb02_t    LIKE  pjb_file.pjb02,
	g_wc         STRING,
  	g_sql	     STRING
       
DEFINE  g_pjb1	     RECORD
            pjb19a   LIKE pjb_file.pjb19,
            pjb20a   LIKE pjb_file.pjb20,
            pjb12a   LIKE pjb_file.pjb12
                     END RECORD
DEFINE  g_pjb1_t	     RECORD
            pjb19a   LIKE pjb_file.pjb19,
            pjb20a   LIKE pjb_file.pjb20,
            pjb12a   LIKE pjb_file.pjb12
                     END RECORD
        
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1                                
DEFINE  g_cnt                LIKE type_file.num10 
DEFINE  g_i                  LIKE type_file.num5                                
DEFINE  g_msg                LIKE type_file.chr1000 
DEFINE  g_curs_index         LIKE type_file.num10                               
DEFINE  g_row_count          LIKE type_file.num10 
DEFINE  g_jump               LIKE type_file.num10                               
DEFINE  mi_no_ask            LIKE type_file.num5 
 
MAIN
	DEFINE   p_row,p_col     LIKE type_file.num5
	OPTIONS
  INPUT NO WRAP
	DEFER INTERRUPT 
       
	IF(NOT cl_user())THEN
  	  EXIT PROGRAM
	END IF
 
	WHENEVER ERROR CALL cl_err_msg_log   
	IF(NOT cl_setup("APJ")) THEN
 	  EXIT PROGRAM
	END IF
 
	CALL cl_used(g_prog,g_time,1) RETURNING g_time
	INITIALIZE g_pjb.* TO NULL
 
      LET g_forupd_sql="SELECT * FROM pjb_file WHERE pjb01 = ?  AND pjb02 = ? FOR UPDATE"
 LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
	DECLARE t503_cl CURSOR FROM g_forupd_sql     #LOCK CURSOR
 
	LET p_row=5 LET p_col=10
	OPEN WINDOW t503_w AT p_row,p_col WITH FORM "apj/42f/apjt503"
	CALL cl_ui_init()
 
	LET g_action_choice=""
	CALL t503_menu()
	CLOSE WINDOW t503_w
	CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION t503_cs()
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON pjb02,pjb03,pjb01,pjb22,pjb21,pjb23,pjb14,
                              pjb15,pjb16,pjb17,pjb18,pjb19,pjb20,pjb12
    
    BEFORE CONSTRUCT
        CALL cl_qbe_init()
    ON ACTION controlp
           CASE
              WHEN INFIELD(pjb02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb8"     
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '1'
                 LET g_qryparam.arg2 = 'Y'
                 LET g_qryparam.arg3 = 'N'
                 LET g_qryparam.default1 = g_pjb.pjb02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjb02
                 NEXT FIELD pjb02
             #FUN-B30054---add---start---
              WHEN INFIELD(pjb01) #專案代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.state = "c"	  
                 LET g_qryparam.default1 = g_pjb.pjb01 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjb01
                 NEXT FIELD pjb01
             #FUN-B30054---add---end--- 
              WHEN INFIELD(pjb22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"     
                 LET g_qryparam.state = "c"	  
                 LET g_qryparam.default1 = g_pjb.pjb22
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjb22
                 NEXT FIELD pjb22
              OTHERWISE EXIT CASE
           END CASE
 
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
   
  END CONSTRUCT
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #        LET g_wc = g_wc clipped," AND pjbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND pjbgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN             
    #    LET g_wc = g_wc clipped," AND pjbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjbuser', 'pjbgrup')
    #End:FUN-980030
 
   #LET g_sql="SELECT pjb01,pjb02 FROM pjb_file ", #FUN-8C0123
    LET g_sql="SELECT pjb01,pjb02 FROM pjb_file ", #FUN-8C0123   
        " WHERE pjb21='1' ",
        "   AND pjb09='Y' AND pjb25='N' ",
   #    "   AND ",g_wc CLIPPED, " ORDER BY pjb02" #FUN-8C0123  
        "   AND ",g_wc CLIPPED, " ORDER BY pjb01,pjb02" #FUN-8C0123
    PREPARE t503_prepare FROM g_sql
    DECLARE t503_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t503_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pjb_file ",
        " WHERE pjb21='1' AND pjb09='Y' AND pjb25='N' AND ",g_wc CLIPPED
    PREPARE t503_precount FROM g_sql
    DECLARE t503_count CURSOR FOR t503_precount
END FUNCTION
 
 
FUNCTION t503_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000    
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION query
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
            CALL t503_q()
          END IF
 
        ON ACTION next
          CALL t503_fetch('N')
 
        ON ACTION previous
          CALL t503_fetch('P')
 
        ON ACTION modify
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
            CALL t503_u()
          END IF
 
       ON ACTION help
         CALL cl_show_help()
     
       ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
       ON ACTION jump
         CALL t503_fetch('/')
 
       ON ACTION first
         CALL t503_fetch('F')
 
       ON ACTION last
         CALL t503_fetch('L')
 
       ON ACTION controlg
         CALL cl_cmdask()
 
       ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()       
 
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE MENU
 
       ON ACTION about       
         CALL cl_about()    
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE 	
          LET g_action_choice = "exit"
          EXIT MENU
 
        ON ACTION related_document   
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
            IF g_pjb.pjb01 IS NOT NULL THEN
              LET g_doc.column1 = "pjb02"
              LET g_doc.column2 = "pjb01" #FUN-8C0123
              LET g_doc.value1 = g_pjb.pjb02
              LET g_doc.value2 = g_pjb.pjb01 #FUN-8C0123
              CALL cl_doc()
             END IF
           END IF
    END MENU
    CLOSE t503_cs
END FUNCTION
 
 
FUNCTION t503_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pjb.* TO NULL           
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
    CALL t503_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t503_count
    FETCH t503_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t503_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjb.pjb02,SQLCA.sqlcode,0)
        INITIALIZE g_pjb.* TO NULL
    ELSE
        CALL t503_fetch('F')
    END IF
END FUNCTION
 
 
FUNCTION t503_fetch(p_flpjb)
    DEFINE  p_flpjb  LIKE type_file.chr1   
    CASE p_flpjb
      #MOD-B30143---modify---start---
      ##FUN-8C0123-----begin
      ##WHEN 'N' FETCH NEXT     t503_cs INTO g_pjb.pjb01,g_pjb.pjb02
      ##WHEN 'P' FETCH PREVIOUS t503_cs INTO g_pjb.pjb01,g_pjb.pjb02
      ##WHEN 'F' FETCH FIRST    t503_cs INTO g_pjb.pjb01,g_pjb.pjb02
      ##WHEN 'L' FETCH LAST     t503_cs INTO g_pjb.pjb01,g_pjb.pjb02
      # WHEN 'N' FETCH NEXT     t503_cs INTO g_pjb.pjb01,g_pjb.pjb01,g_pjb.pjb02 
      # WHEN 'P' FETCH PREVIOUS t503_cs INTO g_pjb.pjb01,g_pjb.pjb01,g_pjb.pjb02 
      # WHEN 'F' FETCH FIRST    t503_cs INTO g_pjb.pjb01,g_pjb.pjb01,g_pjb.pjb02 
      # WHEN 'L' FETCH LAST     t503_cs INTO g_pjb.pjb01,g_pjb.pjb01,g_pjb.pjb02    
      ##FUN-8C0123-----end
        WHEN 'N' FETCH NEXT     t503_cs INTO g_pjb.pjb01,g_pjb.pjb02 
        WHEN 'P' FETCH PREVIOUS t503_cs INTO g_pjb.pjb01,g_pjb.pjb02 
        WHEN 'F' FETCH FIRST    t503_cs INTO g_pjb.pjb01,g_pjb.pjb02 
        WHEN 'L' FETCH LAST     t503_cs INTO g_pjb.pjb01,g_pjb.pjb02    
      #MOD-B30143---modify---end---
        WHEN '/'
            IF (NOT mi_no_ask) THEN         
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0    
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                  ON ACTION about  
                     CALL cl_about()
                  ON ACTION help 
                     CALL cl_show_help()
                  ON ACTION controlg    
                     CALL cl_cmdask()   
               END PROMPT
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
               END IF
            END IF
    #FETCH ABSOLUTE g_jump t503_cs INTO g_pjb.pjb01,g_pjb.pjb02 #FUN-8C0123
     FETCH ABSOLUTE g_jump t503_cs INTO g_pjb.pjb01,g_pjb.pjb01,g_pjb.pjb02 #FUN-8C0123 
     LET mi_no_ask = FALSE      
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjb.pjb01,SQLCA.sqlcode,0)
        INITIALIZE g_pjb.* TO NULL 
        RETURN
    ELSE
      CASE p_flpjb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx    
    END IF
 
    SELECT * INTO g_pjb.* FROM pjb_file 
       WHERE pjb01 = g_pjb.pjb01 AND pjb02 = g_pjb.pjb02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pjb_file",g_pjb.pjb02,"",SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_pjb.pjbuser  
        LET g_data_group=g_pjb.pjbgrup
        CALL t503_show()
    END IF
END FUNCTION
 
 
FUNCTION t503_show()
    LET g_pjb_t.* = g_pjb.*
    DISPLAY BY NAME g_pjb.pjb02,g_pjb.pjb03,g_pjb.pjb01,g_pjb.pjb22,
                    g_pjb.pjb21,g_pjb.pjb23,g_pjb.pjb14,g_pjb.pjb15,
                    g_pjb.pjb16,g_pjb.pjb17,g_pjb.pjb18,g_pjb.pjb19,
                    g_pjb.pjb20,g_pjb.pjb12
    CALL t503_pjb01('d')
    CALL t503_pjb22('d')
    CALL cl_show_fld_cont()                
END FUNCTION
 
 
FUNCTION t503_pjb01(p_cmd)
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_pja02    LIKE pja_file.pja02,
   l_pjaacti  LIKE pja_file.pjaacti,
   l_genacti  LIKE gen_file.genacti
 
   LET g_errno=''
   SELECT pja02,pjaacti,pjaclose               #No.FUN-960038 add pjaclose
         INTO l_pja02,l_pjaacti,l_pjaclose     #No.FUN-960038 add l_pjaclose
         FROM pja_file
         WHERE pja01=g_pjb.pjb01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_pja02=NULL
       WHEN l_pjaacti='N'       LET g_errno='9028'
       WHEN l_pjaclose='Y'      LET g_errno='abg-503'   #No.FUN-960038
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pja02 TO FORMONLY.pja02
   END IF
END FUNCTION
 
 
FUNCTION t503_pjb22(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,         
   l_gen02    LIKE gen_file.gen02,
   l_genacti  LIKE gen_file.genacti
 
   LET g_errno=''
   SELECT gen02,genacti
         INTO l_gen02,l_genacti
         FROM gen_file
         WHERE gen01=g_pjb.pjb22
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gen02=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION
 
 
FUNCTION t503_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,         
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,         
            l_n       LIKE type_file.num5          
 
   INITIALIZE g_pjb1.* TO NULL
   INPUT g_pjb.pjb22,g_pjb.pjb23,g_pjb.pjb14,
         g_pjb1.pjb19a,g_pjb1.pjb20a,g_pjb1.pjb12a 
         WITHOUT DEFAULTS FROM pjb22,pjb23,pjb14,pjb19a,pjb20a,pjb12a
 
      BEFORE INPUT
          LET l_input='N'
          LET g_pjb.pjb22 = g_user
          LET g_pjb.pjb23 = g_today
#          LET g_pjb1.pjb19a = g_today   #No.TQC-840018
#          DISPLAY BY NAME g_pjb1.pjb19a #No.TQC-840018
 
      AFTER FIELD pjb22
         IF g_pjb.pjb22 IS NOT NULL THEN
	    CALL t503_pjb22('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('pjb22:',g_errno,1)
               LET g_pjb.pjb22 = g_pjb_t.pjb22
               DISPLAY BY NAME g_pjb.pjb22
               NEXT FIELD pjb22
            END IF
         END IF
 
      AFTER FIELD pjb23
	    IF NOT cl_null(g_pjb.pjb23) THEN
               IF g_pjb.pjb23 < g_today ThEN
                  CALL cl_err('pjb23:','asr-049',0)
                  NEXT FIELD pjb23
               END IF
	    END IF
 
      AFTER FIELD pjb14
	    IF NOT cl_null(g_pjb.pjb14) THEN
               IF g_pjb.pjb14 < 0 OR g_pjb.pjb14 > 100 ThEN
                  CALL cl_err('pjb14:','mfg0091',0)
                  NEXT FIELD pjb14
               END IF
               IF g_pjb.pjb14 > 0 THEN  #No.TQC-840018
                  NEXT FIELD pjb19a     #No.TQC-840018
               END IF                   #No.TQC-840018
	    END IF
            
#No.TQC-840018---------------start-----------------------
      AFTER FIELD pjb19a
         IF g_pjb.pjb14>0 AND cl_null(g_pjb1.pjb19a) THEN
            CALL cl_err('pjb19a:','apj-019',0)
            NEXT FIELD pjb19a
         END IF 
         IF g_pjb.pjb14=100 THEN
            NEXT FIELD pjb20a 
         END IF
#No.TQC-840018----------------end------------------------
 
      BEFORE FIELD pjb20a
            IF NOT cl_null(g_pjb1.pjb19a) AND cl_null(g_pjb1.pjb20a) THEN
               LET g_pjb1.pjb20a = g_pjb1.pjb19a
            END IF
      
      AFTER FIELD pjb20a
	    IF NOT cl_null(g_pjb1.pjb19a) THEN
               IF g_pjb1.pjb20a < g_pjb1.pjb19a ThEN
                  CALL cl_err(g_pjb1.pjb20a,'apj-018',0)
                  NEXT FIELD pjb20a
               END IF
	    END IF 
#No.TQC-840018--------------start-------------------------
         IF g_pjb.pjb14=100 AND cl_null(g_pjb1.pjb20a) THEN
            CALL cl_err(g_pjb1.pjb20a,'apj-029',0)
            NEXT FIELD pjb20a
         ELSE NEXT FIELD pjb12a
         END IF
#No.TQC-840018---------------end--------------------------
 
     BEFORE FIELD pjb12a                   
            IF NOT cl_null(g_pjb1.pjb20a) AND NOT cl_null(g_pjb1.pjb19a) THEN
               LET g_pjb1.pjb12a = g_pjb1.pjb20a - g_pjb1.pjb19a + 1
            END IF
 
     AFTER FIELD pjb12a
#No.TQC-840018--------------start-------------------------                      
         IF NOT cl_null(g_pjb1.pjb20a) AND cl_null(g_pjb1.pjb12a) THEN
            NEXT FIELD pjb12a                   
         END IF                                                                 
#No.TQC-840018---------------end-------------------------- 
	    IF NOT cl_null(g_pjb1.pjb12a) THEN
               IF g_pjb1.pjb12a < 0 OR g_pjb1.pjb12a > g_pjb1.pjb20a-g_pjb1.pjb19a+1 ThEN
                  CALL cl_err(g_pjb1.pjb12a,'apj-052',0)
                  NEXT FIELD pjb12a
               END IF
	    END IF
 
      AFTER INPUT
         LET g_pjb.pjbuser = s_get_data_owner("pjb_file") #FUN-C10039
         LET g_pjb.pjbgrup = s_get_data_group("pjb_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_pjb.pjb02 IS NULL THEN
               DISPLAY BY NAME g_pjb.pjb02
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD pjb022
            END IF
 
      ON ACTION CONTROLO
         IF INFIELD(pjb02) THEN
            LET g_pjb.* = g_pjb_t.*
            CALL t503_show()
            NEXT FIELD pjb022
         END IF
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(pjb22)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_pjb.pjb22
              CALL cl_create_qry() RETURNING g_pjb.pjb22
              DISPLAY BY NAME g_pjb.pjb22
              CALL t503_pjb22('a')
              NEXT FIELD pjb22
 
           OTHERWISE
              EXIT CASE
           END CASE
 
      ON ACTION CONTROLR
      	   CALL cl_show_req_fields()
 
           ON ACTION CONTROLG
           CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) 
                RETURNING g_fld_name,g_frm_name
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
 
 
FUNCTION t503_u()
DEFINE   l_pjaclose LIKE pja_file.pjaclose     #No.FUN-960038
    IF g_pjb.pjb02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #SELECT * INTO g_pjb.* FROM pjb_file WHERE pjb02=g_pjb.pjb02 #FUN-8C0123
    SELECT * INTO g_pjb.* FROM pjb_file WHERE pjb01=g_pjb.pjb01 AND pjb02=g_pjb.pjb02 #FUN-8C0123   
    IF g_pjb.pjbacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    IF g_pjb.pjb21 = '2' THEN                                                  
        CALL cl_err('','apj-053',0)                                             
        RETURN                                                                  
    END IF                                                                      
    IF  g_pjb.pjb21 = '3' THEN                                                  
        CALL cl_err('','apj-054',0)                                             
        RETURN                                                                  
    END IF                                                                      
    IF  g_pjb.pjb21 = '4' THEN                                                  
        CALL cl_err('',9004,0)                                                  
        RETURN                                                                  
    END IF
    IF g_pjb.pjb09 = 'N' OR g_pjb.pjb25 = 'Y' THEN
       CALL cl_err('','apj-077',0)
       RETURN
    END IF
#No.FUN-960038 --Begin
    SELECT pjaclose INTO l_pjaclose
      FROM pja_file
     WHERE pja01=g_pjb.pjb01
    IF l_pjaclose='Y' THEN
       CALL cl_err('','apj-602',0)
       RETURN
    END IF
#No.FUN-960038 --End
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pjb01_t = g_pjb.pjb01 #FUN-8C0123
    LET g_pjb02_t = g_pjb.pjb02
    BEGIN WORK
 
    OPEN t503_cl USING g_pjb.pjb01,g_pjb.pjb02
    IF STATUS THEN
       CALL cl_err("OPEN t503_cl:", STATUS, 1)
       CLOSE t503_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t503_cl INTO g_pjb.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjb.pjb02,SQLCA.sqlcode,1)
       CLOSE t503_cl
       ROLLBACK WORK
       RETURN
    END IF
    LET g_pjb.pjbmodu=g_user 
    LET g_pjb.pjbdate = g_today
    CALL t503_show()
    WHILE TRUE
        CALL t503_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pjb.*=g_pjb_t.*
            LET g_pjb1.*=g_pjb1_t.*
            CALL t503_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pjb_file SET pjb_file.pjb22 = g_pjb.pjb22,
                            pjb_file.pjb23 = g_pjb.pjb23,
                            pjb_file.pjb14 = g_pjb.pjb14,
                            pjb_file.pjb19 = g_pjb1.pjb19a,
                            pjb_file.pjb20 = g_pjb1.pjb20a,
               pjb_file.pjb12 = g_pjb1.pjb12a
         WHERE pjb01 = g_pjb.pjb01 AND pjb02 = g_pjb.pjb02
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","pjb_file",g_pjb.pjb02,"",SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
        END IF
        DISPLAY g_pjb1.pjb19a,g_pjb1.pjb20a,g_pjb1.pjb12a TO pjb19,pjb20,pjb12
        EXIT WHILE
    END WHILE
    INITIALIZE g_pjb1.* TO NULL
    DISPLAY BY NAME g_pjb1.*
    CLOSE t503_cl
    COMMIT WORK
END FUNCTION  
#NO.FUN-790025


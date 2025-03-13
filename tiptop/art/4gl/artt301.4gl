# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: artt301.4gl
# Date & Author..: 08/08/07 By lala
# Modify.........: No.FUN-870100 09/06/29 By lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/12 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-9B0025 09/11/24 By Cockroach 判斷raa07只能并且必須錄入4個
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30041 10/03/15 By Cockroach add oriu/orig
# Modify.........: No.FUN-A60044 10/06/22 By bnlent  rwa_file-->raa_file 促銷作業重新規劃
# Modify.........: No.TQC-A90008 10/09/06 By houlia 由於促銷作業的表發生變化，程序中原來判斷rwb_file相關的表以及where條件需做調整
# Modify.........: No.TQC-AC0174 10/12/15 By suncx 新增制定營運中心為當前營運中心的管控，當期活動已近被用的報錯信息修改
# Modify.........: No.TQC-B20019 11/02/14 By shenyang 改bug
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-C40187 12/04/20 By fanbj 新增時raa07默認給值213
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.CHI-D20015 13/03/26 By xumm 取消確認賦值確認異動時間和人員

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_raa            RECORD LIKE raa_file.*,
       g_raa_t          RECORD LIKE raa_file.*,  
       g_raa01_t        LIKE  raa_file.raa01,    
       g_raa02_t        LIKE  raa_file.raa02   
 
DEFINE g_forupd_sql          STRING              
DEFINE g_before_input_done   LIKE type_file.num5           
DEFINE g_wc                  STRING                
DEFINE g_sql                 STRING                 
DEFINE g_chr                 LIKE raa_file.raaacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10        
DEFINE g_row_count           LIKE type_file.num10                
DEFINE g_jump                LIKE type_file.num10               
DEFINE mi_no_ask             LIKE type_file.num5                  
DEFINE l_msg                 STRING
DEFINE g_str                 STRING
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
  
    IF (NOT cl_user()) THEN                     
      EXIT PROGRAM                              
    END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
   INITIALIZE g_raa.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM raa_file WHERE raa01 = ? AND raa02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t301_cl CURSOR FROM g_forupd_sql                 
 
   OPEN WINDOW w_curr WITH FORM "art/42f/artt301"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("raa07,dummy01",FALSE)   #FUN-A60044 Cockroach 0629
   LET g_action_choice = ''
   CALL t301_menu()
 
   CLOSE WINDOW w_curr

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION t301_cs()
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                               
        raa01,raa02,raa03,raa04,raa05,raa06,raa07,raaconf,raacond,raaconu,raa08,
	raauser,raagrup,raamodu,raadate,raaacti,raacrat
       ,raaoriu,raaorig                           #TQC-A30041  ADD
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(raaconu)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_raaconu"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_raa.raaconu
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO raaconu
                 NEXT FIELD raaconu
              OTHERWISE
                 EXIT CASE
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
    #        LET g_wc = g_wc clipped," AND raauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND raagrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN
    #        LET g_wc = g_wc clipped," AND raagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('raauser', 'raagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT raa01,raa02 FROM raa_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY raa01,raa02"
    PREPARE t301_prepare FROM g_sql
    DECLARE t301_cs SCROLL CURSOR WITH HOLD FOR t301_prepare
    LET g_sql = "SELECT COUNT(*) FROM raa_file WHERE ",g_wc CLIPPED
    PREPARE t301_precount FROM g_sql
    DECLARE t301_count CURSOR FOR t301_precount
END FUNCTION
 
FUNCTION t301_menu()
 
    MENU ""
      BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
       ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t301_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN              
		CALL t301_q()
            END IF
        ON ACTION next
            CALL t301_fetch('N')
        ON ACTION previous
            CALL t301_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t301_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t301_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t301_r()
            END IF
#       ON ACTION reproduce
#            LET g_action_choice="reproduce"
#            IF cl_chk_act_auth() THEN
#                 CALL t301_copy()
#            END IF
       ON ACTION output
            LET g_action_choice="output"
           IF cl_chk_act_auth()
               THEN CALL t301_out()
            END IF
 
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
              CALL t301_confirm()
           END IF
 
        ON ACTION unconfirm
           LET g_action_choice="unconfirm"
           IF cl_chk_act_auth() THEN
              CALL t301_unconfirm()
           END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t301_fetch('/')
        ON ACTION first
            CALL t301_fetch('F')
        ON ACTION last
            CALL t301_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont() 
            IF g_raa.raaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   
            CALL cl_set_field_pic(g_raa.raaconf,"","","",g_chr,"")                  
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
        ON ACTION about
            CALL cl_about()      
 
        ON ACTION close       #COMMAND KEY(INTERRUPT)  #FUN-9B0025
            LET INT_FLAG=FALSE 		
            LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document    
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_raa.raa01) AND NOT cl_null(g_raa.raa02)  THEN
                 LET g_doc.column1 = "raa01"
                 LET g_doc.column2 = "raa02"
                 LET g_doc.value1 = g_raa.raa01
                 LET g_doc.value2 = g_raa.raa02
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t301_cs
END FUNCTION
 
 
FUNCTION t301_a()
    MESSAGE ""
    CLEAR FORM         
                              
    INITIALIZE g_raa.* LIKE raa_file.*
    LET g_raa01_t = NULL
    LET g_raa02_t = NULL
    LET g_wc = NULL
    
    CALL cl_opmsg('a')
    
    WHILE TRUE
        LET g_raa.raauser = g_user
        LET g_raa.raaoriu = g_user #FUN-980030
        LET g_raa.raaorig = g_grup #FUN-980030
        LET g_raa.raagrup = g_grup
        LET g_raa.raacrat = g_today
        LET g_raa.raaacti = 'Y'
        LET g_raa.raa07 = '213'    #TQC-C40187 add
        
        CALL t301_i("a")                         
        IF INT_FLAG THEN                         
            INITIALIZE g_raa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
 
        INSERT INTO raa_file VALUES(g_raa.*)    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","raa_file",g_raa.raa01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
#FUN-870100 ADD-----by cockroach-----
FUNCTION t301_datechk(p_date)
   DEFINE   p_date     LIKE type_file.dat,
            l_raa05    LIKE raa_file.raa05,
            l_raa06    LIKE raa_file.raa06
 
   LET g_errno = ' '
   IF NOT cl_null(g_raa.raa01) AND NOT cl_null(g_raa.raa02) THEN
      SELECT raa05,raa06 INTO l_raa05,l_raa06 
        FROM raa_file
      #WHERE raa01  = g_raa.raa01
      #  AND raa02  = g_raa.raa02
       WHERE raaacti= 'Y'
         AND raaconf= 'Y'
      CASE
         WHEN SQLCA.sqlcode = 100                    LET g_errno = ' '
         WHEN p_date >= l_raa05 OR p_date <= l_raa06 LET g_errno = 'art-594'
       OTHERWISE   
          LET g_errno=SQLCA.sqlcode USING '------' 
      END CASE   
   END IF    
END FUNCTION
#FUN-870100 END----------------------
 
 
FUNCTION t301_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_n       LIKE type_file.num5
  #ADD BY cockroach 09/08/14 --------
   DEFINE   l_i,l_j   LIKE type_file.num5,
            l_raa07   LIKE raa_file.raa07
  #ADD END---------------------------  
   DISPLAY BY NAME
      g_raa.raa01,g_raa.raa02,g_raa.raa03,g_raa.raa04,g_raa.raa05,g_raa.raa06,
      g_raa.raa07,g_raa.raaconf,g_raa.raacond,g_raa.raaconu,g_raa.raa08,
      g_raa.raauser,g_raa.raagrup,g_raa.raamodu,
      g_raa.raadate,g_raa.raaacti,g_raa.raacrat
     ,g_raa.raaoriu,g_raa.raaorig              #TQC-A30041 ADD
 
   LET g_raa01_t = g_raa.raa01
   LET g_raa02_t = g_raa.raa02
   LET g_raa_t.* = g_raa.*
 
   INPUT BY NAME g_raa.raaoriu,g_raa.raaorig,
      g_raa.raa01,g_raa.raa02,g_raa.raa03,g_raa.raa04,g_raa.raa05,g_raa.raa06,
      g_raa.raa07,g_raa.raaconf,g_raa.raacond,g_raa.raaconu,g_raa.raa08,
      g_raa.raauser,g_raa.raagrup,g_raa.raamodu,
      g_raa.raadate,g_raa.raaacti,g_raa.raacrat
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t301_set_entry(p_cmd)
          CALL t301_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          IF p_cmd = 'a' THEN
              CALL cl_set_comp_entry("raa01",FALSE)
          END IF
          IF p_cmd = 'u' THEN
              CALL cl_set_comp_entry("raa01",FALSE)
              CALL cl_set_comp_entry("raa02",FALSE)
           ELSE 
              CALL cl_set_comp_entry("raa02",TRUE)
           END IF
          LET g_raa.raa01 = g_plant
          DISPLAY BY NAME g_raa.raa01
          CALL t301_raa01('d')
          IF p_cmd='a' THEN
             LET g_raa.raa05 = g_today
          END IF
          DISPLAY BY NAME g_raa.raa05
          #LET g_raa.raa07 = '123'        #MARK BY cockroach
     #    LET g_raa.raa07 = '12345'       #ADD BY cockroach
          #LET g_raa.raa07 = '2314'       #FUN-A60044 ADD BY cockroach   #TQC-C40187 mark 
         #DISPLAY BY NAME g_raa.raa07
          LET g_raa.raaconf = 'N'
          DISPLAY BY NAME g_raa.raaconf
 
      AFTER FIELD raa02
         IF NOT cl_null(g_raa.raa02) THEN
            SELECT COUNT(*) INTO l_n FROM raa_file WHERE raa01=g_raa.raa01 AND raa02=g_raa.raa02
            IF l_n>0 THEN
               CALL cl_err('','-239',0)
               LET g_raa.raa02=g_raa_t.raa02
               DISPLAY BY NAME g_raa.raa02
               NEXT FIELD raa02
            END IF
         END IF
 
      AFTER FIELD raa05
        IF NOT cl_null(g_raa.raa05) THEN
        #TQC-B20019 ---mark--begin
           #add by cockroach--09/08/11----   
        #   SELECT COUNT(*) INTO l_n FROM raa_file                                                                                  
        #    WHERE g_raa.raa05 BETWEEN raa05 AND raa06                                                                              
        #      AND raaconf ='Y' 
        #      AND raa01   = g_raa.raa01    
        #   IF l_n > 0  THEN                                                                                                            
        #      CALL cl_err(g_raa.raa05,'art-594',0)                                                                                    
        #      LET g_raa.raa05 = g_raa_t.raa05                                                                                         
        #      NEXT FIELD raa05  
        #   END IF
        #  #add end--------------------------
         #TQC-B20019 ---mark--end
          IF p_cmd = 'a' OR (p_cmd = 'u' AND g_raa.raa05!=g_raa_t.raa05) THEN
            IF cl_null(g_raa.raa06) THEN
               IF p_cmd = 'a' THEN
                  IF g_raa.raa05<g_today THEN
                    CALL cl_err('','art-200',0)
                     LET g_raa.raa05 = g_raa_t.raa05
                     DISPLAY BY NAME g_raa.raa05
                     NEXT FIELD raa05
                  END IF
               END IF
               IF p_cmd = 'u' AND g_raa.raa05!=g_raa_t.raa05 THEN
                  IF g_raa.raa05<g_raa_t.raa05 THEN
                     CALL cl_err('','art-202',0)
                     LET g_raa.raa05 = g_raa_t.raa05
                     DISPLAY BY NAME g_raa.raa05
                     NEXT FIELD raa05
                  END IF
               END IF
            ELSE
               IF p_cmd = 'a' THEN
                  IF g_raa.raa05<g_today THEN
                    CALL cl_err('','art-200',0)
                     LET g_raa.raa05 = g_raa_t.raa05
                     DISPLAY BY NAME g_raa.raa05
                     NEXT FIELD raa05
                  END IF
               END IF
               IF p_cmd = 'u' AND g_raa.raa05!=g_raa_t.raa05 THEN
                  IF g_raa.raa05<g_raa_t.raa05 THEN
                     CALL cl_err('','art-202',0)
                     LET g_raa.raa05 = g_raa_t.raa05
                     DISPLAY BY NAME g_raa.raa05
                     NEXT FIELD raa05
                  END IF
               END IF
               IF g_raa.raa05>g_raa.raa06 THEN
                  CALL cl_err ('','art-201',0)
                  LET g_raa.raa05 = g_raa_t.raa05
                  DISPLAY BY NAME g_raa.raa05
                  NEXT FIELD raa05
               END IF
        #TQC-B20019 ---mark---begin
           #add by cockroach--09/08/14----
       #    SELECT COUNT(*) INTO l_n FROM raa_file                                                                                  
       #     WHERE raaconf ='Y'
       #       AND raa01   = g_raa.raa01 
       #       AND ( (raa05 BETWEEN g_raa.raa05 AND g_raa.raa06)
       #            OR (raa06 BETWEEN g_raa.raa05 AND g_raa.raa06) )
       #    IF l_n > 0  THEN                                                                                                        
       #       CALL cl_err(g_raa.raa05,'art-594',0)                                                                                 
       #       LET g_raa.raa05 = g_raa_t.raa05                                                                                      
       #       NEXT FIELD raa05                                                                                                     
       #    END IF                                                                                                                  
           #add end--------------------------
       #TQC-B20019 ---mark--end
            END IF
          END IF
        END IF
 
      AFTER FIELD raa06
         IF NOT cl_null(g_raa.raa06) THEN
       #TQC-B20019 ---mark--begin
           #add by cockroach--09/08/11----                                                                                          
      #     SELECT COUNT(*) INTO l_n FROM raa_file                                                                                  
      #      WHERE g_raa.raa06 BETWEEN raa05 AND raa06                                                                              
      #        AND raaconf ='Y'     
      #        AND raa01   = g_raa.raa01 
      #     IF l_n > 0  THEN                                                                                                            
      #        CALL cl_err(g_raa.raa06,'art-594',0)                                                                                 
      #        LET g_raa.raa06 = g_raa_t.raa06                                                                                      
      #        NEXT FIELD raa06                                                                                                     
      #     END IF                                                                                                                  
           #add end--------------------------  
      #TQC-B20019 ---mark--end
          IF p_cmd = 'a' OR (p_cmd = 'u' AND g_raa.raa06!=g_raa_t.raa06) THEN
            IF cl_null(g_raa.raa05) THEN
               IF p_cmd = 'a' THEN
                  IF g_raa.raa06<g_today THEN
                    CALL cl_err('','art-480',0)
                     LET g_raa.raa06 = g_raa_t.raa06
                     DISPLAY BY NAME g_raa.raa06
                     NEXT FIELD raa06
                  END IF
               END IF
               IF p_cmd = 'u' AND g_raa.raa06!=g_raa_t.raa06 THEN
                  IF g_raa.raa06<g_raa_t.raa06 THEN
                     CALL cl_err('','art-202',0)
                     LET g_raa.raa06 = g_raa_t.raa06
                     DISPLAY BY NAME g_raa.raa06
                     NEXT FIELD raa06
                  END IF
               END IF
            ELSE
               IF p_cmd = 'a' THEN
                  IF g_raa.raa06<g_today THEN
                    CALL cl_err('','art-480',0)
                     LET g_raa.raa06 = g_raa_t.raa06
                     DISPLAY BY NAME g_raa.raa06
                     NEXT FIELD raa06
                  END IF
               END IF
               IF p_cmd = 'u' AND g_raa.raa06!=g_raa_t.raa06 THEN
                  IF g_raa.raa06<g_raa_t.raa06 THEN
                     CALL cl_err('','art-202',0)
                     LET g_raa.raa06 = g_raa_t.raa06
                     DISPLAY BY NAME g_raa.raa06
                     NEXT FIELD raa06
                  END IF
               END IF
               IF g_raa.raa06<g_raa.raa05 THEN
                  CALL cl_err ('','art-201',0)
                  LET g_raa.raa06 = g_raa_t.raa06
                  DISPLAY BY NAME g_raa.raa06
                  NEXT FIELD raa06
               END IF
         #TQC-B20019 ---mark--begin
           #add by cockroach--09/08/14 -------
         #  SELECT COUNT(*) INTO l_n FROM raa_file   
         #   WHERE raaconf ='Y'                  
         #     AND raa01   = g_raa.raa01    
         #     AND ( (raa05 BETWEEN g_raa.raa05 AND g_raa.raa06)   
         #          OR (raa06 BETWEEN g_raa.raa05 AND g_raa.raa06) )  
         #  IF l_n > 0  THEN              
         #     CALL cl_err(g_raa.raa06,'art-594',0)  
         #     LET g_raa.raa06 = g_raa_t.raa06   
         #     NEXT FIELD raa06                
         #  END IF                    
           #add end-------------------------- 
         #TQC-B20019 ---mark--end
            END IF
          END IF
        END IF
 
#ADD by cockroach 090814----------------------
      AFTER FIELD raa07                                                                                                             
         IF NOT cl_null(g_raa.raa07) THEN
            LET l_raa07 = g_raa.raa07
            IF LENGTH(l_raa07)>4 OR LENGTH(l_raa07)<4 THEN
               CALL cl_err(g_raa.raa07,'art-595',0)
               LET g_raa.raa07 = g_raa_t.raa07    
               NEXT FIELD raa07
            END IF
            FOR l_i = 1 TO  LENGTH(l_raa07) 
                IF l_raa07[l_i,l_i] NOT MATCHES '[1234]' THEN
                   CALL cl_err(g_raa.raa07,'art-595',0)
                   LET g_raa.raa07 = g_raa_t.raa07                                                                                      
                   NEXT FIELD raa07                                                                                                     
                END IF
            END FOR
            FOR l_i = 1 TO LENGTH(l_raa07)-1
                FOR l_j = l_i+1 TO LENGTH(l_raa07)
                    IF l_raa07[l_i,l_i] =l_raa07[l_j,l_j]  THEN
                       CALL cl_err(g_raa.raa07,'art-596',0)
                       LET g_raa.raa07 = g_raa_t.raa07                                                                                  
                       NEXT FIELD raa07       
                    END IF                 
                END FOR
            END FOR
         END IF                   
#ADD END--------------------------------------
 
     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_raa.raa01)  THEN
              NEXT FIELD raa01
            END IF
            IF cl_null(g_raa.raa02)  THEN
              NEXT FIELD raa02
            END IF
      ON ACTION CONTROLO                        
         IF INFIELD(raa01) THEN
            LET g_raa.* = g_raa_t.*
            CALL t301_show()
            NEXT FIELD raa01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(raaconu)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_raa.raaconu
              CALL cl_create_qry() RETURNING g_raa.raaconu
              DISPLAY BY NAME g_raa.raaconu
              NEXT FIELD raaconu
 
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                        
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
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
 
FUNCTION t301_raa01(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,          
        l_raa01_desc    LIKE azp_file.azp02
 
   SELECT azp02 INTO l_raa01_desc FROM azp_file WHERE azp01 = g_raa.raa01
   DISPLAY l_raa01_desc TO FORMONLY.raa01_desc
 
END FUNCTION
 
FUNCTION t301_confirm()
   DEFINE l_raa01      LIKE   raa_file.raa01
   DEFINE l_n          LIKE type_file.num5
   IF (g_raa.raa01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF

   #No.TQC-AC0174 add --begin----------
   IF g_raa.raa01 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
   #No.TQC-AC0174 add ---end-----------
 
   IF g_raa.raaconf = 'Y' THEN
      CALL cl_err('','aap-232',0)
      RETURN
   END IF
 
   IF g_raa.raaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('aim-301') THEN RETURN END IF
   BEGIN WORK
#TQC-B20019 ---mark--begin 
  #add by cockroach--09/08/11----              
#   SELECT COUNT(*) INTO l_n FROM raa_file                                    
#    WHERE (g_raa.raa05 BETWEEN raa05 AND raa06                  
#       OR g_raa.raa06 BETWEEN raa05 AND raa06 )
#      AND raaconf ='Y'                                    
#      AND raa01   = g_raa.raa01 
#   IF l_n > 0  THEN                                        
#      CALL cl_err('','art-594',0)                     
#      RETURN
#   END IF                                                 
  #add end-------------------------- 
  #add by cockroach--09/08/14----------
#   SELECT COUNT(*) INTO l_n FROM raa_file   
#    WHERE raaconf ='Y'                  
#      AND raa01   = g_raa.raa01    
#      AND ( (raa05 BETWEEN g_raa.raa05 AND g_raa.raa06)   
#           OR (raa06 BETWEEN g_raa.raa05 AND g_raa.raa06) ) 
#   IF l_n > 0  THEN              
#      CALL cl_err('','art-594',0)  
#      RETURN
#   END IF                    
  #add end-------------------------- 
#TQC-B20019 ---mark--end
   OPEN t301_cl USING g_raa.raa01,g_raa.raa02
   IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t301_cl INTO g_raa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   CALL t301_show()
   LET g_raa.raaconf = 'Y'
   LET g_raa.raaacti = 'Y'
   UPDATE raa_file 
      SET raaconf=g_raa.raaconf,raaconu=g_user,raacond=g_today
    WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","raa_file",g_raa.raa01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF
 
   CLOSE t301_cl
   COMMIT WORK
   SELECT * INTO g_raa.* FROM raa_file where raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
   CALL t301_show()
END FUNCTION
 
FUNCTION t301_unconfirm()
   DEFINE l_raa01 LIKE raa_file.raa01
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_o     LIKE type_file.num5    #TQC-A90008 --add
   DEFINE l_q     LIKE type_file.num5    #TQC-A90008 --add
   
   #No.TQC-AC0174 add --begin----------
   IF g_raa.raa01 <> g_plant THEN
      CALL cl_err('','art-977',0)
      RETURN
   END IF
   #No.TQC-AC0174 add ---end-----------

#TQC-A90008 --modify 
#  SELECT COUNT(*) INTO l_n FROM rwb_file WHERE rwb02 = g_raa.raa02                                                                
   SELECT COUNT(*) INTO l_n FROM rab_file WHERE rab03 = g_raa.raa02
      IF l_n>0 THEN                
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN                    
      END IF
  
   SELECT COUNT(*) INTO l_o FROM rae_file WHERE rae03 = g_raa.raa02
      IF l_o>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF
 
   SELECT COUNT(*) INTO l_q FROM rah_file WHERE rah03 = g_raa.raa02
      IF l_q>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF

#  IF l_n>0 THEN                                                                                                                   
#     CALL  cl_err('','art-228',1)                                                                                                 
#     RETURN                                                                                                                       
#  END IF                                  
#TQC-A90008 --end
 
   IF (g_raa.raa01 IS NULL) THEN
      CALL cl_err('',-400,0)
      RETURN 
   END IF
 
   IF g_raa.raaacti='N' THEN 
      CALL cl_err('','mfg0301',1)
      RETURN
   END IF
 
   IF g_raa.raaconf!='Y' THEN
      CALL  cl_err('','atm-053',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('aim-302') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t301_cl USING g_raa.raa01,g_raa.raa02
   IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
   END IF
   FETCH t301_cl INTO g_raa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,1)
      RETURN
   END IF
   CALL t301_show()
   UPDATE raa_file 
     #SET raaconf='N',raaconu='',raacond=''            #CHI-D20015 Mark
      SET raaconf='N',raaconu=g_user,raacond=g_today   #CHI-D20015 Add
    WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","raa_file",g_raa.raa01,"",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK
   END IF
   CLOSE t301_cl
   COMMIT WORK
   SELECT * INTO g_raa.* FROM raa_file where raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
   CALL t301_show()
END FUNCTION
 
FUNCTION t301_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
 
    INITIALIZE g_raa.* TO NULL    
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '  ' TO FORMONLY.cnt
 
    CALL t301_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN t301_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_raa.raa01,SQLCA.sqlcode,0)
        INITIALIZE g_raa.* TO NULL
    ELSE
    	OPEN t301_count
        FETCH t301_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t301_fetch('F')
    END IF
END FUNCTION
 
FUNCTION t301_fetch(p_flraa)
    DEFINE  p_flraa         LIKE type_file.chr1  
             
    CASE p_flraa
        WHEN 'N' FETCH NEXT     t301_cs INTO g_raa.raa01,g_raa.raa02
        WHEN 'P' FETCH PREVIOUS t301_cs INTO g_raa.raa01,g_raa.raa02
        WHEN 'F' FETCH FIRST    t301_cs INTO g_raa.raa01,g_raa.raa02
        WHEN 'L' FETCH LAST     t301_cs INTO g_raa.raa01,g_raa.raa02
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
            FETCH ABSOLUTE g_jump t301_cs INTO g_raa.raa01,g_raa.raa02
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_raa.raa01,SQLCA.sqlcode,0)
        INITIALIZE g_raa.* TO NULL  
        RETURN
    ELSE
      CASE p_flraa
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_raa.* FROM raa_file    
       WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","raa_file",g_raa.raa01,g_raa.raa02,SQLCA.sqlcode,"","",0)  
    ELSE
        CALL t301_show()                   
    END IF
END FUNCTION
 
FUNCTION t301_show()
    LET g_raa_t.* = g_raa.*
    #No.FUN-9A0024--begin 
    #DISPLAY BY NAME g_raa.*, g_raa.raaoriu,g_raa.raaorig
    DISPLAY BY NAME g_raa.raa01,g_raa.raa02,g_raa.raa03,g_raa.raa04,g_raa.raa05,g_raa.raa06,
                    g_raa.raa07,g_raa.raaconf,g_raa.raacond,g_raa.raaconu,g_raa.raa08,
                    g_raa.raauser,g_raa.raagrup,g_raa.raamodu,g_raa.raadate,g_raa.raaacti,
                    g_raa.raacrat,g_raa.raaorig,g_raa.raaoriu       
    #No.FUN-9A0024--end 
    IF g_raa.raaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   
    CALL cl_set_field_pic(g_raa.raaconf,"","","",g_chr,"")
    CALL t301_raa01('d')
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t301_u()
     
    #No.TQC-AC0174 add --begin----------
    IF g_raa.raa01 <> g_plant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #No.TQC-AC0174 add ---end-----------

    IF cl_null(g_raa.raa01) OR cl_null(g_raa.raa02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_raa.* FROM raa_file WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
 
    IF g_raa.raaacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_raa01_t = g_raa.raa01
    LET g_raa02_t = g_raa.raa02
 
    IF g_raa.raaconf='Y' THEN
      CALL  cl_err('','alm-027',1)
      RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t301_cl USING g_raa.raa01,g_raa.raa02
    IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t301_cl INTO g_raa.*              
    IF SQLCA.sqlcode THEN
       LET l_msg = g_raa.raa01 CLIPPED,g_raa.raa02 CLIPPED
       CALL cl_err(l_msg,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_raa.raamodu = g_user
    LET g_raa.raadate = g_today
    CALL t301_show()
    WHILE TRUE
        CALL t301_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_raa.*=g_raa_t.*
            CALL t301_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE raa_file SET raa_file.* = g_raa.*    
            WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","raa_file",g_raa.raa01,g_raa.raa02,SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    IF g_raa.raaconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   
    CALL cl_set_field_pic(g_raa.raaconf,"","","",g_chr,"")
    CLOSE t301_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t301_x()
DEFINE  l_n       LIKE type_file.num5
DEFINE  l_o       LIKE type_file.num5      #TQC-A90008 --add
DEFINE  l_q       LIKE type_file.num5      #TQC-A90008 --add

    #No.TQC-AC0174 add --begin----------
    IF g_raa.raa01 <> g_plant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #No.TQC-AC0174 add ---end-----------
 
    IF cl_null(g_raa.raa01) OR cl_null(g_raa.raa02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    IF g_raa.raaconf='Y' THEN
      CALL  cl_err('','axr-913',1)
      RETURN
    END IF
 
#TQC-A90008 --modify
#    SELECT COUNT(*) INTO l_n FROM rwb_file WHERE rwb02 = g_raa.raa02
#    IF l_n>0 THEN
#       CALL  cl_err('','art-232',1)
#       RETURN
#    END IF
   SELECT COUNT(*) INTO l_n FROM rab_file WHERE rab03 = g_raa.raa02
      IF l_n>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF
   
   SELECT COUNT(*) INTO l_o FROM rae_file WHERE rae03 = g_raa.raa02
      IF l_o>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF
   
   SELECT COUNT(*) INTO l_q FROM rah_file WHERE rah03 = g_raa.raa02
      IF l_q>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF
#TQC-A90008 --end
 
    BEGIN WORK
 
    OPEN t301_cl USING g_raa.raa01,g_raa.raa02
    IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 1)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t301_cl INTO g_raa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_raa.raa01,SQLCA.sqlcode,1)
       RETURN
    END IF
    LET g_raa.raamodu = g_user
    LET g_raa.raadate = g_today
    CALL t301_show()
    IF cl_exp(0,0,g_raa.raaacti) THEN
        LET g_chr=g_raa.raaacti
        IF g_raa.raaacti='Y' THEN
            LET g_raa.raaacti='N'
        ELSE
            LET g_raa.raaacti='Y'
        END IF
        UPDATE raa_file
            SET raaacti=g_raa.raaacti
            WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_raa.raa01,SQLCA.sqlcode,0)
            LET g_raa.raaacti=g_chr
        END IF
        DISPLAY BY NAME g_raa.raaacti
    END IF
    CLOSE t301_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t301_r()
DEFINE  l_n       LIKE type_file.num5
DEFINE  l_o       LIKE type_file.num5      #TQC-A90008 --add
DEFINE  l_q       LIKE type_file.num5      #TQC-A90008 --add

    #No.TQC-AC0174 add --begin----------
    IF g_raa.raa01 <> g_plant THEN
       CALL cl_err('','art-977',0)
       RETURN
    END IF
    #No.TQC-AC0174 add ---end-----------
 
    IF cl_null(g_raa.raa01) OR cl_null(g_raa.raa02)THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    IF g_raa.raaacti='N' THEN
      CALL  cl_err('','aic-201',1)
      RETURN
    END IF
 
    IF g_raa.raaconf='Y' THEN
      CALL  cl_err('','alm-028',1)
      RETURN
    END IF
 
#TQC-A90008 --modify
#    SELECT COUNT(*) INTO l_n FROM rwb_file WHERE rwb02 = g_raa.raa02
#    IF l_n>0 THEN
#       CALL  cl_err('','art-228',1)
#       RETURN
#    END IF
   SELECT COUNT(*) INTO l_n FROM rab_file WHERE rab03 = g_raa.raa02
      IF l_n>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF

   SELECT COUNT(*) INTO l_o FROM rae_file WHERE rae03 = g_raa.raa02
      IF l_o>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF

   SELECT COUNT(*) INTO l_q FROM rah_file WHERE rah03 = g_raa.raa02
      IF l_q>0 THEN
        #CALL  cl_err('','art-228',1)       #No.TQC-AC0174 mark
         CALL  cl_err('','art-991',1)        #No.TQC-AC0174 add
         RETURN
      END IF
#TQC-A90008 --end
 
    BEGIN WORK
 
    OPEN t301_cl USING g_raa.raa01,g_raa.raa02
    IF STATUS THEN
       CALL cl_err("OPEN t301_cl:", STATUS, 0)
       CLOSE t301_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t301_cl INTO g_raa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_raa.raa01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t301_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "raa01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "raa02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_raa.raa01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_raa.raa02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM raa_file WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02 AND raaacti = 'Y'
       CLEAR FORM
       OPEN t301_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t301_cs
          CLOSE t301_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH t301_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t301_cs
          CLOSE t301_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t301_cs
       IF g_row_count > 0 THEN
        IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t301_fetch('L')
        ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL t301_fetch('/')
        END IF
       END IF
    END IF
    CLOSE t301_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t301_copy()
    DEFINE l_newno         LIKE raa_file.raa01,
           l_oldno         LIKE raa_file.raa01,
           p_cmd           LIKE type_file.chr1,          
           l_input         LIKE type_file.chr1            
 
    IF g_raa.raa01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL t301_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM raa01
 
        AFTER FIELD raa01
           IF l_newno IS NOT NULL THEN
              SELECT count(*) INTO g_cnt FROM raa_file
                  WHERE raa01 = l_newno
              IF g_cnt > 0 THEN
                 CALL cl_err(l_newno,-239,0)
                  NEXT FIELD raa01
              END IF
                  SELECT gen01
                      FROM gen_file
                      WHERE gen01= l_newno
                  IF SQLCA.sqlcode THEN
                      DISPLAY BY NAME g_raa.raa01
                      LET l_newno = NULL
                      NEXT FIELD raa01
                  END IF
           END IF
 
        ON ACTION controlp                        
           IF INFIELD(raa01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_raa.raa01
              CALL cl_create_qry() RETURNING l_newno
              DISPLAY l_newno TO raa01                
              SELECT gen01
              FROM gen_file
              WHERE gen01= l_newno
              IF SQLCA.sqlcode THEN
                 DISPLAY BY NAME g_raa.raa01
                 LET l_newno = NULL
                 NEXT FIELD raa01
              END IF
              NEXT FIELD raa01
           END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()     
 
      ON ACTION HELP
         CALL cl_show_help()  
 
      ON ACTION controlg
         CALL cl_cmdask()     
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_raa.raa01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM raa_file
        WHERE raa01 = g_raa.raa01 AND raa02 = g_raa.raa02
        INTO TEMP x
    UPDATE x
        SET raa01=l_newno,    
            raaacti='Y',      
            raauser=g_user,   
            raagrup=g_grup,   
            raaoriu=g_user,        #TQC-A30041 ADD
            raaorig=g_grup,        #TQC-A30041 ADD
            raamodu=NULL,     
            raadate=g_today   
    INSERT INTO raa_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","raa_file",g_raa.raa01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_raa.raa01
        LET g_raa.raa01 = l_newno
        SELECT raa_file.* INTO g_raa.* FROM raa_file
               WHERE raa01 = l_newno
        CALL t301_u()
        #SELECT raa_file.* INTO g_raa.* FROM raa_file  #FUN-C80046
               #WHERE raa01 = l_oldno                  #FUN-C80046
    END IF
    #LET g_raa.raa01 = l_oldno   #FUN-C80046
    CALL t301_show()
END FUNCTION
 
FUNCTION t301_out()
#p_query
DEFINE l_cmd  STRING
 
    IF cl_null(g_wc) THEN
       CALL cl_err('','9057',0) RETURN
    END IF
    LET l_cmd = 'p_query "artt301" "',g_wc CLIPPED,'"'
    CALL cl_cmdrun(l_cmd) 
 
END FUNCTION
 
FUNCTION t301_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("raa01,raa02,raa03,raa04,raa05,raa06,raa07,raa08",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t301_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("raa01",FALSE)
       CALL cl_set_comp_entry("raa02,raa03,raa04,raa05,raa06,raa07,raa08",TRUE)
    END IF
 
END FUNCTION

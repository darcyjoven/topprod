# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almi130.4gl
# Descriptions...: 場地基本資料維護作業 
# Date & Author..: NO.FUN-870010 08/07/02 By lilingyu 
# Modify.........: No.FUN-960134 09/06/30 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0136 09/11/24 By shiwuying
# Modify.........: No:FUN-A10060 10/01/13 By shiwuying 權限處理
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore
# Modify.........: NO:FUN-A80148 10/09/01 By wangxin 因為lma_file已不使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: NO:FUN-A80148 10/10/09 By chenying 移除簽核ACTION
#                                                     移除lmd08,lmd09
# Modify.........: NO:FUN-AA0054 10/10/21 By shiwuying 同步到32区
# Modify.........: No:TQC-AB0229 10/11/29 By huangtao  修改更改樓棟，樓層不更改的問題
# Modify.........: No:MOD-AC0254 10/12/21 By huangtao 修改TQC-AB0229的問題

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_lmd       RECORD   LIKE lmd_file.*,  
        g_lmd_t     RECORD   LIKE lmd_file.*,					
        g_lmd01_t            LIKE lmd_file.lmd01   
             
DEFINE g_wc                  STRING 
DEFINE g_sql                 STRING                 
DEFINE g_forupd_sql          STRING                    #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5   
DEFINE g_chr                 LIKE type_file.chr1 
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5       #count/index for any purpose
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10 
DEFINE g_jump                LIKE type_file.num10             
DEFINE g_no_ask              LIKE type_file.num5 
DEFINE l_lmd06               LIKE lmd_file.lmd06
DEFINE g_void                LIKE type_file.chr1
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_date                LIKE lmd_file.lmddate
DEFINE g_modu                LIKE lmd_file.lmdmodu
DEFINE l_f                   LIKE type_file.chr1 
 
MAIN
   DEFINE cb ui.ComboBox
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT          
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM lmd_file WHERE lmd01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i130_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW i130_w WITH FORM "alm/42f/almi130"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()   
 
   LET cb = ui.ComboBox.forname("lmd10")
   CALL cb.removeitem("X")
 
   LET g_action_choice = ""
   CALL i130_menu()
 
   CLOSE WINDOW i130_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION i130_curs()
 
   CLEAR FORM    
   CONSTRUCT BY NAME g_wc ON  
                     lmd01,lmdstore,lmdlegal,lmd03,lmd04,lmd05,lmd06,lmd07,
#                    lmd08,lmd09,lmd10,lmd11,lmd12,lmd13,lmduser,lmdgrup,     #FUN-A80148 mark
                     lmd10,lmd11,lmd12,lmd13,lmduser,lmdgrup,                 #FUN-A80148 mod
                     lmdoriu,lmdorig,lmdmodu,lmddate,lmdacti,lmdcrat   #No:FUN-9B0136
                         
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(lmd01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmd1"
               LET g_qryparam.state = "c"              
               LET g_qryparam.where = " lmdstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmd01
               NEXT FIELD lmd01                     
                
            WHEN INFIELD(lmdstore)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmdstore"
               LET g_qryparam.state = "c"              
               LET g_qryparam.where = " lmdstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmdstore
               NEXT FIELD lmdstore        
 
            WHEN INFIELD(lmdlegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmdlegal"
               LET g_qryparam.state = "c"              
               LET g_qryparam.where = " lmdstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmdlegal
               NEXT FIELD lmdlegal
 
            WHEN INFIELD(lmd03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmd3"
               LET g_qryparam.state = "c"            
               LET g_qryparam.where = " lmdstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmd03
               NEXT FIELD lmd03 
                    
            WHEN INFIELD(lmd04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmd4"
               LET g_qryparam.state = "c"         
               LET g_qryparam.where = " lmdstore IN ",g_auth," "  #No.FUN-A10060
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lmd04
               NEXT FIELD lmd04
                       
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
   IF INT_FLAG THEN
      RETURN
   END IF
   
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN   
   #      LET g_wc = g_wc clipped," AND lmduser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN   
   #      LET g_wc = g_wc clipped," AND lmdgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN 
   #      LET g_wc = g_wc clipped," AND lmdgrup IN",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lmduser', 'lmdgrup')
   #End:FUN-980030
 
   LET g_sql = "SELECT lmd01 FROM lmd_file ",
               " WHERE ",g_wc CLIPPED,                          
               "   AND lmdstore IN ",g_auth,    #No.FUN-A10060
               " ORDER BY lmd01"
 
   PREPARE i130_prepare FROM g_sql
   DECLARE i130_cs                                # SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR i130_prepare
 
   LET g_sql = "SELECT COUNT(*) FROM lmd_file WHERE ",g_wc CLIPPED,
               "   AND lmdstore IN ",g_auth     #No.FUN-A10060
   
   PREPARE i130_precount FROM g_sql
   DECLARE i130_count CURSOR FOR i130_precount
END FUNCTION
 
FUNCTION i130_menu()
   
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index,g_row_count)
        
        ON ACTION insert
           LET g_action_choice="insert"
           IF cl_chk_act_auth() THEN
              CALL i130_a()
           END IF
 
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
              CALL i130_q()
           END IF
 
        ON ACTION next
           CALL i130_fetch('N')
 
        ON ACTION previous
           CALL i130_fetch('P')
 
        ON ACTION modify
           LET g_action_choice="modify"
           IF cl_chk_act_auth() THEN
           # IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN 
                CALL i130_u('w')
           # END IF  
           END IF   
   
        ON ACTION invalid
           LET g_action_choice="invalid"
           IF cl_chk_act_auth() THEN
           #  IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN 
                 CALL i130_x()
           #  END IF    
           END IF
           CALL i130_pic()
           
        ON ACTION delete
           LET g_action_choice="delete"
           IF cl_chk_act_auth() THEN
           #  IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN 
                 CALL i130_r()
           #  END IF  
           END IF
                      
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL i130_copy()
           END IF    
           
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
           #  IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN 
                 CALL i130_confirm()
           #  END IF    
           END IF  
           CALL i130_pic() 
                   
        ON ACTION unconfirm
           LET g_action_choice="unconfirm"
           IF cl_chk_act_auth() THEN
           #  IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN 
                 CALL i130_unconfirm()
           #  END IF  
           END IF 
            CALL i130_pic() 
            
       #ON ACTION void
       #   LET g_action_choice = "void"     
       #   IF cl_chk_act_auth() THEN 
       #   #  IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN 
       #         CALL i130_v()
       #   #  END IF    
       #   END IF    
       #   CALL i130_pic() 
       
#FUN-A80148--mod--str            
#        ON ACTION ef_approval
#           LET g_action_choice="ef_approval"
#           IF cl_chk_act_auth() THEN
#           #  IF cl_chk_mach_auth(g_lmd.lmdstore,g_plant) THEN
#                 CALL i130_ef()
#           #  END IF    
#           END IF 
#FUN-A80148--mod--end  
                   
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION jump
           CALL i130_fetch('/')
 
        ON ACTION first
           CALL i130_fetch('F')
 
        ON ACTION last
           CALL i130_fetch('L')
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont() 
           CALL  i130_pic()
           
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about 
           CALL cl_about() 
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG = FALSE 
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document 
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_lmd.lmd01) THEN
                 LET g_doc.column1 = "lmd01"
                 LET g_doc.value1 = g_lmd.lmd01
                 CALL cl_doc()
              END IF
           END IF
    END MENU
    CLOSE i130_cs
END FUNCTION
 
FUNCTION i130_a()
DEFINE  l_count    LIKE type_file.num5
#DEFINE  l_tqa06    LIKE tqa_file.tqa06
 
# SELECT tqa06 INTO l_tqa06 FROM tqa_file
#  WHERE tqa03 = '14'       	 
#    AND tqaacti = 'Y'
#    AND tqa01 IN(SELECT tqb03 FROM tqb_file
#   	              WHERE tqbacti = 'Y'
#    	                AND tqb09 = '2'
#    	                AND tqb01 = g_plant) 
#  IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN 
#     CALL cl_err('','alm-600',1)
#     RETURN 
#  END IF 
 
#  SELECT COUNT(*) INTO l_count FROM rtz_file
#   WHERE rtz01 = g_plant
#     AND rtz28 = 'Y'
#  IF l_count < 1 THEN
#     CALL cl_err('','alm-606',1)
#     RETURN
#  END IF  
 
    MESSAGE ""
    CLEAR FORM    
    INITIALIZE g_lmd.*    LIKE lmd_file.*       
    INITIALIZE g_lmd_t.*  LIKE lmd_file.*
 
     LET g_lmd01_t = NULL
     LET g_wc = NULL
     CALL cl_opmsg('a')     
     
     WHILE TRUE
        LET g_lmd.lmduser = g_user
        LET g_lmd.lmdoriu = g_user #FUN-980030
        LET g_lmd.lmdorig = g_grup #FUN-980030
        LET g_lmd.lmdgrup = g_grup 
        LET g_lmd.lmdcrat = g_today
        LET g_lmd.lmdacti = 'Y'
        LET g_lmd.lmd05   = 0
        LET g_lmd.lmd06   = 0
        LET g_lmd.lmd07   = 'N'  
#       LET g_lmd.lmd08   = 'N'           #FUN-A80148 mark
#       LET g_lmd.lmd09   = '0'           #FUN-A80148 mark  
        LET g_lmd.lmd10   = 'N' 
        LET g_lmd.lmdstore = g_plant
        LET g_lmd.lmdlegal = g_legal
        LET l_f = NULL
        CALL i130_i("a")
        IF l_f = 'c' THEN 
           CALL cl_err('',9001,0)
           CLEAR FORM 
           EXIT WHILE 
        END IF  
               
        IF INT_FLAG THEN  
           LET INT_FLAG = 0
           INITIALIZE g_lmd.* TO NULL
           LET g_lmd01_t = NULL
           CALL cl_err('',9001,0)
           CLEAR FORM
           EXIT WHILE
        END IF
        IF cl_null(g_lmd.lmd01) THEN    
           CONTINUE WHILE
        END IF
             
         
        INSERT INTO lmd_file VALUES(g_lmd.*) 
         UPDATE lmd_file
           SET lmd06 = l_lmd06
         WHERE lmdstore = g_lmd.lmdstore
           AND lmd03 = g_lmd.lmd03
           AND lmd04 = g_lmd.lmd04     
           AND lmd01 = g_lmd.lmd01                 
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lmd.lmd01,SQLCA.SQLCODE,0)
           CONTINUE WHILE
        ELSE
           SELECT * INTO g_lmd.* FROM lmd_file
            WHERE lmd01 = g_lmd.lmd01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc = NULL
END FUNCTION
 
FUNCTION i130_i(p_cmd)
DEFINE   p_cmd      LIKE type_file.chr1 
DEFINE   l_cnt      LIKE type_file.num5 
DEFINE   l_rtz13    LIKE rtz_file.rtz13   #FUN-A80148 add
DEFINE   l_lmb03    LIKE lmb_file.lmb03
DEFINE   l_lmc04    LIKE lmc_file.lmc04
DEFINE   l_lme04    LIKE lme_file.lme04
DEFINE   l_count    LIKE type_file.num5 
DEFINE   l_lmb06    LIKE lmb_file.lmb06 
DEFINE   l_lmc07    LIKE lmc_file.lmc07 
 
#FUN-A80148 del lmd08,lmd09 
#   DISPLAY BY NAME  g_lmd.lmdstore,g_lmd.lmd06,g_lmd.lmd07,g_lmd.lmd08,    
#                    g_lmd.lmd09,g_lmd.lmd10,g_lmd.lmduser,g_lmd.lmdgrup,
#                    g_lmd.lmdmodu,g_lmd.lmddate,g_lmd.lmdacti,g_lmd.lmdcrat,
#                    g_lmd.lmdlegal  
    DISPLAY BY NAME g_lmd.lmdstore,g_lmd.lmd06,g_lmd.lmd07,   
                    g_lmd.lmd10,g_lmd.lmduser,g_lmd.lmdgrup,
                    g_lmd.lmdmodu,g_lmd.lmddate,g_lmd.lmdacti,g_lmd.lmdcrat,
                    g_lmd.lmdlegal
#FUN-A80148 del lmd08,lmd09                     
                     
                   
   INPUT BY NAME   g_lmd.lmd01,g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04, g_lmd.lmdoriu,g_lmd.lmdorig,
                   g_lmd.lmd05,g_lmd.lmd13
                    WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET g_before_input_done = FALSE  
          CALL i130_set_entry(p_cmd)
          CALL i130_set_no_entry(p_cmd)        
          LET g_before_input_done = TRUE
          CALL i130_rtz13()
          
      AFTER FIELD lmd01
          IF NOT cl_null(g_lmd.lmd01) THEN
            IF p_cmd = 'u' THEN
            ELSE          	         
               CALL i130_check_lmd01(g_lmd.lmd01) 
               IF g_success = 'N' THEN                                                             
                  LET g_lmd.lmd01 = g_lmd_t.lmd01                         
                  DISPLAY BY NAME g_lmd.lmd01                                              
                  NEXT FIELD lmd01                                                             
               END IF 
             END IF          
          END IF         
          
 #     AFTER FIELD lmdstore                  
 #           CALL s_alm_valid(g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,'','')
 #              RETURNING l_rtz13,l_lmb03,l_lmc04       
 #           IF NOT cl_null(g_errno) THEN 
 #              CALL cl_err(g_lmd.lmdstore,g_errno,1)
 #              NEXT FIELD lmdstore 
 #           ELSE
 #           	  DISPLAY l_rtz13 TO FORMONLY.rtz13
 #           	  DISPLAY l_lmb03 TO FORMONLY.lmb03
 #        	      DISPLAY l_lmc04 TO FORMONLY.lmc04
 #            END IF  	  
                           
      AFTER FIELD lmd03      
          #CALL s_alm_valid(g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,'','')
          # RETURNING l_rtz13,l_lmb03,l_lmc04       
         #IF NOT cl_null(g_errno) THEN 
         #   CALL cl_err(g_lmd.lmd03,g_errno,1)
         #   NEXT FIELD lmd03 
         #ELSE
         #	  DISPLAY l_lmb03 TO FORMONLY.lmb03
         #	  DISPLAY l_rtz13 TO FORMONLY.rtz13
         #	  DISPLAY l_lmc04 TO FORMONLY.lmc04
         #END IF
         IF NOT cl_null(g_lmd.lmd03) THEN   
            LET l_count  = 0 	  
            SELECT COUNT(*) INTO l_count FROM lmb_file
      #      WHERE lmb02 = g_lmd.lmd03                                #TQC-AB0229 mark
             WHERE lmb02 = g_lmd.lmd03 AND lmbstore = g_lmd.lmdstore  #TQC-AB0229
            IF l_count < 1 THEN 
               CALL cl_err('','alm-003',1)
               LET l_lmb03 = NULL
               DISPLAY l_lmb03 TO FORMONLY.lmb03 
               NEXT FIELD lmd03 
            ELSE
               SELECT lmb06 INTO l_lmb06 FROM lmb_file
       #         WHERE lmb02 = g_lmd.lmd03                                 #TQC-AB0229 mark
                 WHERE lmb02 = g_lmd.lmd03  AND lmbstore = g_lmd.lmdstore  #TQC-AB0229
               IF l_lmb06 = 'N' THEN  
                  CALL cl_err('','alm-905',1)
                  NEXT FIELD lmd03 
               ELSE
               	   SELECT lmb03,lmb06 INTO l_lmb03,l_lmb06
                     FROM lmb_file
               	    WHERE lmbstore = g_lmd.lmdstore
               	      AND lmb02 = g_lmd.lmd03
               	   IF cl_null(l_lmb03) OR cl_null(l_lmb06) THEN    
               	      CALL cl_err('','alm-904',1)
               	      NEXT FIELD lmd03 
               	   ELSE
               	      DISPLAY l_lmb03 TO FORMONLY.lmb03 
                   END IF 
               END IF  
#TQC-AB0229 -----------------STA
                IF NOT cl_null(g_lmd.lmd04) THEN                         #MOD-AC0254 add
                   SELECT COUNT(*) INTO l_count FROM lmc_file
                    WHERE lmc03 = g_lmd.lmd04  AND lmcstore =  g_lmd.lmdstore AND lmc02 = g_lmd.lmd03
                   IF l_count < 1 THEN
                      CALL cl_err('','alm-847',1)
                      NEXT FIELD lmd03
                   END IF
                END IF                                                   #MOD-AC0254 add
#TQC-AB0229 -----------------END
             END IF   
          ELSE
             LET l_lmb03 = NULL
             DISPLAY l_lmb03 TO FORMONLY.lmb03          	
          END IF     
         
      BEFORE FIELD lmd04 
         IF cl_null(g_lmd.lmd03) THEN 
            CALL cl_err('','alm-553',1)
            NEXT FIELD lmd03 
         END IF 
                          
      AFTER FIELD lmd04         
        #   CALL s_alm_valid(g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,'','')
        #   RETURNING l_rtz13,l_lmb03,l_lmc04
        # IF NOT cl_null(g_errno) THEN 
        #    CALL cl_err(g_lmd.lmd04,g_errno,1)
        #    NEXT FIELD lmd04 
        # ELSE
        # 	  DISPLAY l_lmc04 TO FORMONLY.lmc04
        # 	  DISPLAY l_rtz13 TO FORMONLY.rtz13
        # 	  DISPLAY l_lmb03 TO FORMONLY.lmb03
        # END IF 
         IF NOT cl_null(g_lmd.lmd04) THEN 
            LET l_count = 0 
            SELECT COUNT(*) INTO l_count FROM lmc_file
      #       WHERE lmc03 = g_lmd.lmd04          #TQC-AB0229  mark
              WHERE lmc03 = g_lmd.lmd04  AND lmcstore =  g_lmd.lmdstore AND lmc02 = g_lmd.lmd03  #TQC-AB0229
            IF l_count < 1 THEN 
               CALL cl_err('','alm-554',1)
               LET l_lmc04 = NULL
               DISPLAY l_lmc04 TO FORMONLY.lmc04 
               NEXT FIELD lmd04 
            ELSE
               SELECT lmc07 INTO l_lmc07 FROM lmc_file
       #        WHERE lmc03 = g_lmd.lmd04       #TQC-AB0229  mark
                WHERE lmc03 = g_lmd.lmd04 AND lmcstore =  g_lmd.lmdstore AND lmc02 = g_lmd.lmd03  #TQC-AB0229
               IF l_lmc07 = 'N' THEN 
                  CALL cl_err('','alm-908',1)
                  NEXT FIELD lmd04 
               ELSE
                  SELECT lmc04 INTO l_lmc04 FROM lmc_file
                   WHERE lmcstore = g_lmd.lmdstore 
                     AND lmc02 = g_lmd.lmd03
                     AND lmc03 = g_lmd.lmd04 
                  IF cl_null(l_lmc04) THEN 
                     CALL cl_err('','alm-907',1)
                     NEXT FIELD lmd04 
                  ELSE 
                     DISPLAY l_lmc04 TO FORMONLY.lmc04 
                  END IF            	           
               END IF 
            END IF 
         ELSE
            LET l_lmc04 = NULL
            DISPLAY l_lmc04 TO FORMONLY.lmc04     
         END IF	   
      
      AFTER FIELD lmd05          
          IF NOT cl_null(g_lmd.lmd05) THEN 
              IF g_lmd.lmd05 < 0 THEN 
                 CALL cl_err(g_lmd.lmd05,'alm-016',1)
                 DISPLAY BY NAME g_lmd.lmd05
                 NEXT FIELD lmd05 
               ELSE  
               	    SELECT lme04 INTO l_lme04 FROM lme_file               
               	     WHERE lmestore = g_lmd.lmdstore 
                       AND lme02 = g_lmd.lmd03
                       AND lme03 = g_lmd.lmd04
                       AND lme05 = 'Y'
                     IF cl_null(l_lme04) THEN 
                        CALL cl_err('','alm-605',1)
                        LET l_f = 'c'
                        RETURN    
                     ELSE
                     	 LET l_lmd06 = g_lmd.lmd05*(1 + l_lme04/100)  
                       LET g_lmd.lmd06 = l_lmd06                 
                       DISPLAY BY NAME g_lmd.lmd06                     	              	                   
                     END IF   
               END IF                
           END IF                
 
            
     AFTER INPUT
        LET g_lmd.lmduser = s_get_data_owner("lmd_file") #FUN-C10039
        LET g_lmd.lmdgrup = s_get_data_group("lmd_file") #FUN-C10039
        IF INT_FLAG THEN          
           EXIT INPUT
        END IF     
     
     #    CALL s_alm_valid(g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,'','')
     #      RETURNING l_rtz13,l_lmb03,l_lmc04
     #  
     #    IF NOT cl_null(g_errno) THEN 
     #       CALL cl_err(g_lmd.lmdstore,g_errno,1)
     #       NEXT FIELD lmdstore 
     #    ELSE
     #    	  DISPLAY l_rtz13 TO FORMONLY.rtz13
     #    	  DISPLAY l_lmb03 TO FORMONLY.lmb03
     #    	  DISPLAY l_lmc04 TO FORMONLY.lmc04
     #    END IF   
     #      
     #    CALL s_alm_valid(g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,'','')
     #      RETURNING l_rtz13,l_lmb03,l_lmc04
     #  
     #    IF NOT cl_null(g_errno) THEN 
     #       CALL cl_err(g_lmd.lmd03,g_errno,1)
     #       NEXT FIELD lmd03 
     #    ELSE
     #   	  DISPLAY l_lmb03 TO FORMONLY.lmb03
     #   	  DISPLAY l_rtz13 TO FORMONLY.rtz13
     #   	  DISPLAY l_lmc04 TO FORMONLY.lmc04
     #    END IF  	  
     #    
     #    CALL s_alm_valid(g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,'','')
     #      RETURNING l_rtz13,l_lmb03,l_lmc04
     #  
     #    IF NOT cl_null(g_errno) THEN 
     #       CALL cl_err(g_lmd.lmd04,g_errno,1)
     #       NEXT FIELD lmd04 
     #    ELSE
     #       DISPLAY l_lmc04 TO FORMONLY.lmc04
     #       DISPLAY l_rtz13 TO FORMONLY.rtz13
     #       DISPLAY l_lmb03 TO FORMONLY.lmb03
     #    END IF  
   
 
     ON ACTION CONTROLP
        CASE
    #    WHEN INFIELD(lmdstore)
    #        CALL cl_init_qry_var()
    #        LET g_qryparam.form = "q_lmc"  
    #        LET g_qryparam.default1 = g_lmd.lmdstore
    #        LET g_qryparam.default2 = g_lmd.lmd03
    #        LET g_qryparam.default3 = g_lmd.lmd04
    #        LET g_qryparam.default4 = l_lmc04    
    #        CALL cl_create_qry()
    #            RETURNING g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04,l_lmc04
    #        DISPLAY BY NAME g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04
    #        NEXT FIELD lmdstore
        
        WHEN INFIELD(lmd03)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_lmc3"  
            LET g_qryparam.arg1 = g_lmd.lmdstore
            LET g_qryparam.default1 = g_lmd.lmd03
            LET g_qryparam.default2 = g_lmd.lmd04
            LET g_qryparam.default3 = l_lmc04      
            CALL cl_create_qry()
                RETURNING g_lmd.lmd03,g_lmd.lmd04,l_lmc04
            DISPLAY BY NAME g_lmd.lmd03,g_lmd.lmd04
            NEXT FIELD lmd03
            
          WHEN INFIELD(lmd04)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_lmc2"  
            LET g_qryparam.arg1 = g_lmd.lmd03
            LET g_qryparam.arg2 = g_lmd.lmdstore
            LET g_qryparam.default1 = g_lmd.lmd03
            LET g_qryparam.default2 = g_lmd.lmd04
            LET g_qryparam.default3 = l_lmc04    
            CALL cl_create_qry()
                RETURNING g_lmd.lmd03,g_lmd.lmd04,l_lmc04
            DISPLAY BY NAME g_lmd.lmd03,g_lmd.lmd04
            NEXT FIELD lmd04           
 
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
 
FUNCTION i130_q()
    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_lmd.* TO NULL
    INITIALIZE g_lmd_t.* TO NULL
    
    LET g_lmd01_t = NULL
    LET g_wc = NULL
    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    
    CALL i130_curs()  
          
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lmd.* TO NULL
       LET g_lmd01_t = NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN i130_count
    FETCH i130_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i130_cs   
         
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
       INITIALIZE g_lmd.* TO NULL
       LET g_lmd01_t = NULL
       LET g_wc = NULL
    ELSE
       CALL i130_fetch('F')  
    END IF
END FUNCTION
 
FUNCTION i130_fetch(p_icb)
 DEFINE p_icb LIKE type_file.chr1 
 
    CASE p_icb
        WHEN 'N' FETCH NEXT     i130_cs INTO g_lmd.lmd01
        WHEN 'P' FETCH PREVIOUS i130_cs INTO g_lmd.lmd01
        WHEN 'F' FETCH FIRST    i130_cs INTO g_lmd.lmd01
        WHEN 'L' FETCH LAST     i130_cs INTO g_lmd.lmd01
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i130_cs INTO g_lmd.lmd01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
       INITIALIZE g_lmd.* TO NULL
       LET g_lmd01_t = NULL
       RETURN
    ELSE
      CASE p_icb
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO  FORMONLY.idx
    END IF
 
    SELECT * INTO g_lmd.* FROM lmd_file  
     WHERE lmd01 = g_lmd.lmd01
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
    ELSE
       LET g_data_owner = g_lmd.lmduser 
       LET g_data_group = g_lmd.lmdgrup
       CALL i130_show() 
    END IF
END FUNCTION
 
FUNCTION i130_show()
    LET g_lmd_t.* = g_lmd.*
    LET g_lmd01_t = g_lmd.lmd01
#FUN-A80148 del lmd08,lmd09    
#    DISPLAY BY NAME g_lmd.lmd01,g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04, g_lmd.lmdoriu,g_lmd.lmdorig,
#                    g_lmd.lmd05,g_lmd.lmd06,g_lmd.lmd07,g_lmd.lmd08,
#                    g_lmd.lmd09,g_lmd.lmd10,g_lmd.lmd11,g_lmd.lmd12,
#                    g_lmd.lmd13,   g_lmd.lmdlegal,
#                    g_lmd.lmduser,g_lmd.lmdgrup,g_lmd.lmdmodu,
#                    g_lmd.lmddate,g_lmd.lmdacti,g_lmd.lmdcrat  
DISPLAY BY NAME g_lmd.lmd01,g_lmd.lmdstore,g_lmd.lmd03,g_lmd.lmd04, g_lmd.lmdoriu,g_lmd.lmdorig,
                    g_lmd.lmd05,g_lmd.lmd06,g_lmd.lmd07,
                    g_lmd.lmd10,g_lmd.lmd11,g_lmd.lmd12,
                    g_lmd.lmd13,   g_lmd.lmdlegal,
                    g_lmd.lmduser,g_lmd.lmdgrup,g_lmd.lmdmodu,
                    g_lmd.lmddate,g_lmd.lmdacti,g_lmd.lmdcrat 
#FUN-A80148 del lmd08,lmd09                                    
    CALL i130_pic()
    CALL cl_show_fld_cont()   
    CALL i130_bring()    
    CALL i130_lmd06()    
   CALL i130_rtz13() 
END FUNCTION
FUNCTION i130_bring()
DEFINE l_lmb03    LIKE lmb_file.lmb03
DEFINE l_lmc04    LIKE lmc_file.lmc04
 
  DISPLAY '' TO FORMONLY.lmb03
  DISPLAY '' TO FORMONLY.lmc03
  
  IF NOT cl_null(g_lmd.lmd03) THEN 
     SELECT lmb03 INTO l_lmb03 FROM lmb_file
      WHERE lmb06 = 'Y'
        AND lmbstore = g_lmd.lmdstore
        AND lmb02 = g_lmd.lmd03
      DISPLAY l_lmb03 TO FORMONLY.lmb03
  END IF 
  
  IF NOT cl_null(g_lmd.lmd04) THEN 
     SELECT lmc04 INTO l_lmc04 FROM lmc_file
      WHERE lmc07 = 'Y'
        AND lmcstore = g_lmd.lmdstore 
        AND lmc02 = g_lmd.lmd03
        AND lmc03 = g_lmd.lmd04
      DISPLAY l_lmc04 TO FORMONLY.lmc04   
  END IF 
     
END FUNCTION 
 
FUNCTION i130_lmd06()
DEFINE l_lme04   LIKE lme_file.lme04
DEFINE l_lmd06   LIKE lmd_file.lmd06
 
  IF NOT cl_null(g_lmd.lmd05) THEN 
       IF g_lmd.lmd05 < 0 THEN 
          CALL cl_err('','alm-016',1)
       ELSE  
     	    SELECT lme04 INTO l_lme04 FROM lme_file
     	     WHERE lmestore = g_lmd.lmdstore 
             AND lme02 = g_lmd.lmd03
             AND lme03 = g_lmd.lmd04
           LET l_lmd06 = g_lmd.lmd05*(1 + l_lme04/100)
           DISPLAY l_lmd06 TO lmd06                     	              	                   
       END IF                
    END IF              	 
END FUNCTION 
 
FUNCTION i130_u(p_w)
DEFINE  p_w   LIKE type_file.chr1
 
    IF cl_null(g_lmd.lmd01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF    
  
    IF g_lmd.lmd10 = 'Y' THEN
       CALL cl_err(g_lmd.lmd01,'alm-027',1)
       RETURN
    END IF 
    
    IF g_lmd.lmd10 = 'X' THEN
       CALL cl_err(g_lmd.lmd01,'alm-134',1)
       RETURN
    END IF 
    SELECT * INTO g_lmd.* FROM lmd_file WHERE lmd01=g_lmd.lmd01
 
    IF g_lmd.lmdacti = 'N' THEN
       CALL cl_err(g_lmd.lmd01,9027,0)
       RETURN
    END IF
    
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lmd01_t = g_lmd.lmd01
    BEGIN WORK
 
    OPEN i130_cl USING g_lmd.lmd01
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:",STATUS,1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_lmd.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    
    LET g_date = g_lmd.lmddate
    LET g_modu = g_lmd.lmdmodu
 
    IF p_w != 'c' THEN 
       LET g_lmd.lmdmodu = g_user  
       LET g_lmd.lmddate = g_today 
    ELSE
    	 LET g_lmd.lmdmodu = NULL
       LET g_lmd.lmddate = NULL  
    END IF 	   
    CALL i130_show()                 
    WHILE TRUE
        CALL i130_i("u")          
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_lmd_t.lmddate = g_date
           LET g_lmd_t.lmdmodu = g_modu
           LET g_lmd.*=g_lmd_t.*
           CALL i130_show()
           CALL cl_err('',9001,0)        
           EXIT WHILE
        END IF
 
       UPDATE lmd_file SET lmd_file.* = g_lmd.* 
         WHERE lmd01 = g_lmd01_t
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
           CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i130_x()
    IF cl_null(g_lmd.lmd01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    IF g_lmd.lmd10 = 'Y' THEN 
       CALL cl_err(g_lmd.lmd01,'alm-027',1)
       RETURN 
    END IF 
    
    IF g_lmd.lmd10 = 'X' THEN 
       CALL cl_err(g_lmd.lmd01,'alm-134',1)
       RETURN 
    END IF 
    BEGIN WORK
 
    OPEN i130_cl USING g_lmd.lmd01
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:",STATUS,1)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_lmd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,1)
       CLOSE i130_cl
       ROLLBACK WORK  
       RETURN
    END IF
    CALL i130_show()
    IF cl_exp(0,0,g_lmd.lmdacti) THEN
       LET g_chr=g_lmd.lmdacti
       IF g_lmd.lmdacti='Y' THEN
          LET g_lmd.lmdacti='N'
          LET g_lmd.lmdmodu = g_user
          LET g_lmd.lmddate = g_today
       ELSE
          LET g_lmd.lmdacti='Y'
          LET g_lmd.lmdmodu = g_user
          LET g_lmd.lmddate = g_today
       END IF
       UPDATE lmd_file SET lmdacti = g_lmd.lmdacti,
                           lmdmodu = g_lmd.lmdmodu,
                           lmddate = g_lmd.lmddate
        WHERE lmd01 = g_lmd.lmd01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
          LET g_lmd.lmdacti = g_chr
          DISPLAY BY NAME g_lmd.lmdacti
          CLOSE i130_cl
          ROLLBACK WORK
          RETURN 
       END IF
       DISPLAY BY NAME g_lmd.lmdmodu,g_lmd.lmddate,g_lmd.lmdacti
    END IF
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i130_r()
    IF cl_null(g_lmd.lmd01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    
    IF g_lmd.lmdacti  = 'N' THEN 
      CALL cl_err('','alm-147',1)
     RETURN
   END IF 
    IF g_lmd.lmd10 = 'Y' THEN 
       CALL cl_err(g_lmd.lmd01,'alm-028',1)
       RETURN 
    END IF 
    
    IF g_lmd.lmd10 = 'X' THEN 
       CALL cl_err(g_lmd.lmd01,'alm-134',1)
       RETURN 
    END IF 
    BEGIN WORK
 
    OPEN i130_cl USING g_lmd.lmd01
    IF STATUS THEN
       CALL cl_err("OPEN i130_cl:",STATUS,0)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i130_cl INTO g_lmd.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL i130_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lmd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lmd.lmd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lmd_file WHERE lmd01 = g_lmd.lmd01
       CLEAR FORM
       OPEN i130_count
       FETCH i130_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i130_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i130_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL i130_fetch('/')
       END IF
    END IF
    CLOSE i130_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i130_copy()
DEFINE l_newno   LIKE lmd_file.lmd01
DEFINE l_oldno   LIKE lmd_file.lmd01
DEFINE l_count   LIKE type_file.num5 
 
    IF cl_null(g_lmd.lmd01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT COUNT(*) INTO l_count FROM rtz_file
     WHERE rtz01 = g_plant
    IF l_count < 1 THEN 
       CALL cl_err('','alm-559',1)
       RETURN 
    END IF   
    
    LET g_before_input_done = FALSE
    CALL i130_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM lmd01
 
        AFTER FIELD lmd01 
          IF NOT cl_null(l_newno) THEN
             CALL i130_check_lmd01(l_newno) 
             IF g_success = 'N' THEN                                                  
                DISPLAY BY NAME g_lmd.lmd01                                       
                NEXT FIELD lmd01                                                                  
             END IF 
          ELSE 
        	 CALL cl_err(l_newno,'alm-015',1)
          	 NEXT FIELD lmd01    
          END IF
 
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF       
        
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION about 
          CALL cl_about() 
 
       ON ACTION help 
          CALL cl_show_help() 
  
       ON ACTION controlg 
          CALL cl_cmdask() 
 
 
    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       DISPLAY BY NAME g_lmd.lmd01
       RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM lmd_file
     WHERE lmd01 = g_lmd.lmd01
      INTO TEMP x
    UPDATE x
        SET lmd01  = l_newno,     
            lmdstore  = g_plant,   
            lmdacti= 'Y',     
            lmduser= g_user, 
            lmdgrup= g_grup, 
            lmdmodu= NULL, 
            lmddate= NULL,
            lmdcrat= g_today,
            lmd07  = 'N',
            lmd10  = 'N'  ,
            lmd11  = NULL,
            lmd12  = NULL
    INSERT INTO lmd_file SELECT * FROM x
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_lmd.lmd01
       LET g_lmd.lmd01 = l_newno
       SELECT lmd_file.* INTO g_lmd.*
         FROM lmd_file
        WHERE lmd01 = l_newno
 
       CALL i130_u('c')
 
       SELECT lmd_file.* INTO g_lmd.*
         FROM lmd_file
        WHERE lmd01 = l_oldno
    END IF
    LET g_lmd.lmd01 = l_oldno
    CALL i130_show()
END FUNCTION
 
FUNCTION i130_set_entry(p_cmd)
DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lmd01",TRUE)
      CALL cl_set_comp_entry("lmdstore",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i130_check_lmd01(p_cmd)
 DEFINE p_cmd    LIKE lmd_file.lmd01
 DEFINE l_count  LIKE type_file.num10
 
 SELECT COUNT(lmd01) INTO l_count FROM lmd_file
  WHERE lmd01 = p_cmd
  
 IF l_count > 0 THEN
    CALL cl_err(p_cmd,'alm-014',1)
    DISPLAY '' TO lmd01 
    LET g_success = 'N'
 ELSE
 	  LET g_success = 'Y'   
 END IF
END FUNCTION 
 
FUNCTION i130_set_no_entry(p_cmd)                                                                    
 DEFINE   p_cmd     LIKE type_file.chr1                                
 
  IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN        
      CALL cl_set_comp_entry("lmd01",FALSE)                                        
  END IF                                                          
END FUNCTION

#FUN-A80148--mod--str 
#FUNCTION lmd09_set_no_entry(p_cmd)                                         
# DEFINE   p_cmd     LIKE type_file.chr1                                                         
# 
#  IF p_cmd = 'N' THEN                                                              
#    CALL cl_set_comp_entry("lmd09",FALSE)                           
#  END IF                                                             
#  CALL cl_set_comp_entry("lmdstore",FALSE)
#END FUNCTION 
#FUN-A80148--mod--end        
 
FUNCTION i130_confirm()
   
   IF cl_null(g_lmd.lmd01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmd.* FROM lmd_file
    WHERE lmd01 = g_lmd.lmd01
   
   IF g_lmd.lmdacti ='N' THEN
      CALL cl_err(g_lmd.lmd01,'alm-004',1)
      RETURN
   END IF
   IF g_lmd.lmd10 = 'Y' THEN
      CALL cl_err(g_lmd.lmd10,'alm-005',1)
      RETURN
   END IF
   
   IF g_lmd.lmd10 = 'X' THEN
      CALL cl_err(g_lmd.lmd10,'alm-134',1)
      RETURN
   END IF
 
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
 
   BEGIN WORK 
   LET g_success = 'Y'
 
   OPEN i130_cl USING g_lmd.lmd01
   IF STATUS THEN 
       CALL cl_err("open i130_cl:",STATUS,1)
       CLOSE i130_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH i130_cl INTO g_lmd.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN 
    END IF    
 
    UPDATE lmd_file SET lmd10 = 'Y',
                        lmd11 = g_user,
                        lmd12 = g_today
     WHERE lmd01 = g_lmd.lmd01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
       LET g_success = 'N'
    ELSE
       CALL i130_y_upd('1')
    END IF
    IF g_success = 'Y' THEN
       COMMIT WORK
       LET g_lmd.lmd10 = 'Y'
       LET g_lmd.lmd11 = g_user
       LET g_lmd.lmd12 = g_today
       DISPLAY BY NAME g_lmd.lmd10,g_lmd.lmd11,g_lmd.lmd12
    ELSE
       ROLLBACK WORK
    END IF
    CLOSE i130_cl
    COMMIT WORK      
END FUNCTION
 
FUNCTION i130_y_upd(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1
   DEFINE l_lmc05         LIKE lmc_file.lmc05
   DEFINE l_lmc06         LIKE lmc_file.lmc06
   DEFINE l_lmb04         LIKE lmb_file.lmb04
   DEFINE l_lmb05         LIKE lmb_file.lmb05
   DEFINE l_rtz22         LIKE rtz_file.rtz22
   DEFINE l_rtz23         LIKE rtz_file.rtz23
 
   SELECT lmc05,lmc06 INTO l_lmc05,l_lmc06
     FROM lmc_file
    WHERE lmcstore = g_lmd.lmdstore
      AND lmc02 = g_lmd.lmd03
      AND lmc03 = g_lmd.lmd04
   IF cl_null(l_lmc05) THEN LET l_lmc05 = 0 END IF
   IF cl_null(l_lmc06) THEN LET l_lmc06 = 0 END IF
 
   SELECT lmb04,lmb05 INTO l_lmb04,l_lmb05
     FROM lmb_file
    WHERE lmbstore = g_lmd.lmdstore
      AND lmb02 = g_lmd.lmd03
   IF cl_null(l_lmb04) THEN LET l_lmb04 = 0 END IF
   IF cl_null(l_lmb05) THEN LET l_lmb05 = 0 END IF
 
   SELECT rtz23,rtz22 INTO l_rtz23,l_rtz22
     FROM rtz_file
    WHERE rtz01=g_lmd.lmdstore
   IF cl_null(l_rtz23) THEN LET l_rtz23 = 0 END IF
   IF cl_null(l_rtz22) THEN LET l_rtz22 = 0 END IF
 
   IF p_cmd = '1' THEN
      LET l_lmc05 = l_lmc05 + g_lmd.lmd05
      LET l_lmc06 = l_lmc06 + g_lmd.lmd06
      LET l_lmb04 = l_lmb04 + g_lmd.lmd05
      LET l_lmb05 = l_lmb05 + g_lmd.lmd06
      LET l_rtz23 = l_rtz23 + g_lmd.lmd05
      LET l_rtz22 = l_rtz22 + g_lmd.lmd06
   ELSE
      LET l_lmc05 = l_lmc05 - g_lmd.lmd05
      LET l_lmc06 = l_lmc06 - g_lmd.lmd06
      LET l_lmb04 = l_lmb04 - g_lmd.lmd05
      LET l_lmb05 = l_lmb05 - g_lmd.lmd06
      LET l_rtz23 = l_rtz23 - g_lmd.lmd05
      LET l_rtz22 = l_rtz22 - g_lmd.lmd06
   END IF
 
   UPDATE lmc_file
      SET lmc05 = l_lmc05,
          lmc06 = l_lmc06
    WHERE lmcstore = g_lmd.lmdstore
      AND lmc02 = g_lmd.lmd03
      AND lmc03 = g_lmd.lmd04
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lmc:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
      RETURN
   END IF
       
   UPDATE lmb_file
      SET lmb04 = l_lmb04,
          lmb05 = l_lmb05
    WHERE lmbstore = g_lmd.lmdstore
      AND lmb02 = g_lmd.lmd03
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lmb:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
      RETURN
   END IF 
        
   UPDATE rtz_file
      SET rtz23 = l_rtz23,
          rtz22 = l_rtz22
    WHERE rtz01=g_lmd.lmdstore
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd rtz:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION i130_unconfirm()
   DEFINE l_n             LIKE type_file.num5
   DEFINE l_count         LIKE type_file.num5
    
   IF cl_null(g_lmd.lmd01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmd.* FROM lmd_file
    WHERE lmd01 = g_lmd.lmd01
  
   IF g_lmd.lmdacti ='N' THEN
      CALL cl_err(g_lmd.lmd01,'alm-004',1)
      RETURN
   END IF
 
   IF g_lmd.lmd10 = 'N' THEN
      CALL cl_err(g_lmd.lmd01,'alm-007',1)
      RETURN
   END IF
   
   IF g_lmd.lmd10 = 'X' THEN
      CALL cl_err(g_lmd.lmd01,'alm-134',1)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_count FROM lmd_file,lmg_file,lmh_file
    WHERE lmh01 = lmg01
      AND lmd03 = lmg04
      AND lmd04 = lmg05
      AND lmh03 = g_lmd.lmd01
   IF l_count > 0 THEN
      CALL cl_err(g_lmd.lmd01,'alm-025',1)
      RETURN
   END IF
 
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   OPEN i130_cl USING g_lmd.lmd01
   IF STATUS THEN 
      CALL cl_err("open i130_cl:",STATUS,1)
      CLOSE i130_cl
      ROLLBACK WORK 
      RETURN 
   END IF
   FETCH i130_cl INTO g_lmd.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN 
   END IF    
    
   UPDATE lmd_file
      SET lmd10 = 'N',
          lmd11 = '',
          lmd12 = '',
          lmdmodu = g_user,
          lmddate = g_today       
    WHERE lmd01 = g_lmd.lmd01      
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
   ELSE
      CALL i130_y_upd('2')
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_lmd.lmd10 = 'N'
      LET g_lmd.lmd11 = ''
      LET g_lmd.lmd12 = ''
      LET g_lmd.lmdmodu = g_user 
      LET g_lmd.lmddate = g_today
      DISPLAY BY NAME g_lmd.lmd10,g_lmd.lmd11,g_lmd.lmd12,
                      g_lmd.lmdmodu,g_lmd.lmddate
   ELSE
      ROLLBACK WORK
   END IF
   CLOSE i130_cl
   COMMIT WORK   
END FUNCTION

##FUN-A80148--mod--str  
#FUNCTION i130_ef()
#   DEFINE l_n LIKE type_file.num5
#    
#   IF cl_null(g_lmd.lmd01) THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_lmd.* FROM lmd_file
#    WHERE lmd01 = g_lmd.lmd01  
#     
#   IF g_lmd.lmdacti ='N' THEN
#      CALL cl_err(g_lmd.lmd01,'alm-004',1)
#      RETURN
#   END IF
##FUN-A80148--mod--str   
##FUN-A80148 mod   
##   IF g_lmd.lmd08 = 'Y' THEN
##      CALL cl_err(g_lmd.lmd01,'alm-017',1)
##      RETURN
##   END IF 
##FUN-A80148 mod    
#   IF g_lmd.lmd10 = 'Y' THEN 
#      CALL cl_err(g_lmd.lmd01,'alm-027',1)
#      RETURN 
#   END IF     
#    BEGIN WORK 
#   OPEN i130_cl USING g_lmd.lmd01
#   IF STATUS THEN 
#       CALL cl_err("open i130_cl:",STATUS,1)
#       CLOSE i130_cl
#       ROLLBACK WORK 
#       RETURN 
#    END IF 
#    FETCH i130_cl INTO g_lmd.*
#    IF SQLCA.sqlcode  THEN 
#      CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
#      CLOSE i130_cl
#      ROLLBACK WORK
#      RETURN 
#    END IF    
#   IF NOT cl_confirm('alm-026') THEN
#      RETURN
##FUN-A80148--mod--str
##   ELSE
##       LET g_lmd.lmd08 = 'Y'   
##                   
##       UPDATE lmd_file
##          SET lmd08 = g_lmd.lmd08
##        WHERE lmd01 = g_lmd.lmd01
##        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
##          CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
##          LET g_lmd.lmd08 = "N"
##          DISPLAY BY NAME g_lmd.lmd08
##          RETURN
##         ELSE
##            DISPLAY BY NAME g_lmd.lmd08
##      END IF
##FUN-A80148--mod--end
#   END IF  
#   
#   CLOSE i130_cl
#   COMMIT WORK   
#END FUNCTION
#FUN-A80148--mod--str 
 
FUNCTION i130_v()
   IF cl_null(g_lmd.lmd01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lmd.* FROM lmd_file
    WHERE lmd01 = g_lmd.lmd01
 
   IF g_lmd.lmdacti ='N' THEN
      CALL cl_err(g_lmd.lmd01,'alm-084',0)
      RETURN
   END IF
 
   IF g_lmd.lmd10 = 'Y' THEN
      CALL cl_err(g_lmd.lmd01,'9023',0)
      RETURN
   END IF
  BEGIN WORK 
   OPEN i130_cl USING g_lmd.lmd01
   IF STATUS THEN 
       CALL cl_err("open i130_cl:",STATUS,1)
       CLOSE i130_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    FETCH i130_cl INTO g_lmd.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lmd.lmd01,SQLCA.sqlcode,0)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN 
    END IF    
   IF g_lmd.lmd10 != 'Y' THEN
      IF g_lmd.lmd10 = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lmd.lmd10 = 'N'
            LET g_lmd.lmdmodu = g_user
            LET g_lmd.lmddate = g_today
            UPDATE lmd_file
               SET lmd10 = g_lmd.lmd10,
                   lmdmodu = g_lmd.lmdmodu,
                   lmddate = g_lmd.lmddate
             WHERE lmd01 = g_lmd.lmd01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
               LET g_lmd.lmd10 = "X"
               DISPLAY BY NAME g_lmd.lmd10
               RETURN
            ELSE
               DISPLAY BY NAME g_lmd.lmd10,g_lmd.lmdmodu,g_lmd.lmddate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lmd.lmd10 = 'X'
            LET g_lmd.lmdmodu = g_user
            LET g_lmd.lmddate = g_today
            UPDATE lmd_file
               SET lmd10 = g_lmd.lmd10,
                   lmdmodu = g_lmd.lmdmodu,
                   lmddate = g_lmd.lmddate
             WHERE lmd01 = g_lmd.lmd01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lmd:',SQLCA.SQLCODE,0)
               LET g_lmd.lmd10 = "N"
               DISPLAY BY NAME g_lmd.lmd10
               RETURN
            ELSE
               DISPLAY BY NAME g_lmd.lmd10,g_lmd.lmdmodu,g_lmd.lmddate
            END IF
         END IF
      END IF
   END IF
 CLOSE i130_cl
 COMMIT WORK 
END FUNCTION 
 
FUNCTION i130_pic()
   CASE g_lmd.lmd10
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void    = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE
 
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lmd.lmdacti)
END FUNCTION
 
FUNCTION i130_rtz13()
 DEFINE l_rtz13   LIKE rtz_file.rtz13 
 DEFINE l_azt02   LIKE azt_file.azt02
 
   LET l_rtz13 = NULL 
   IF NOT cl_null(g_lmd.lmdstore) THEN 
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = g_lmd.lmdstore
         AND rtz28 = 'Y'
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   ELSE
      DISPLAY '' TO FORMONLY.rtz13
   END IF 
   SELECT azt02 INTO l_azt02 FROM azt_file
    WHERE azt01 = g_lmd.lmdlegal
   DISPLAY l_azt02 TO FORMONLY.azt02
END FUNCTION
 
#FUN-A60064 10/06/24 By chenls 非T/S類table中的xxxplant替換成xxxstore 
#FUN-AA0054


# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
#Patternn name..: apjt504.4gl
#description....: 活動實際進度確認維護作業
#Data & Author..: No.FUN-790025 07/11/22 By ChenMoyan 
#Modify.........: No.TQC-840018 08/04/11 By ChenMoyan 增加pjk01
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds 
 
GLOBALS "../../config/top.global"
DEFINE  g_pjk	     RECORD LIKE pjk_file.*,
	g_pjk_t	     RECORD LIKE pjk_file.*,
        g_pjk01_t    LIKE  pjk_file.pjk01,          #No.TQC-840018
	g_pjk02_t    LIKE  pjk_file.pjk02,
        g_pjj02      LIKE  pjj_file.pjj02,          #No.TQC-840018
	g_wc         STRING,
  	g_sql	     STRING
       
DEFINE  g_pjk1	     RECORD
            pjk18_u  LIKE pjk_file.pjk18,
            pjk19_u  LIKE pjk_file.pjk19,
            pjk24_u  LIKE pjk_file.pjk24
                     END RECORD
DEFINE  g_pjk1_t	     RECORD
            pjk18_u  LIKE pjk_file.pjk18,
            pjk19_u  LIKE pjk_file.pjk19,
            pjk24_u  LIKE pjk_file.pjk24
                     END RECORD
        
DEFINE  g_forupd_sql         STRING
DEFINE  g_before_input_done  LIKE type_file.num5
DEFINE  g_chr                LIKE type_file.chr1                                
DEFINE  g_cn2                LIKE type_file.num10 
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
	INITIALIZE g_pjk.* TO NULL
 
      LET g_forupd_sql="SELECT * FROM pjk_file WHERE pjk01 = ? AND pjk02 = ? FOR UPDATE"
 LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
	DECLARE t504_cl CURSOR FROM g_forupd_sql     #LOCK CURSOR
 
	LET p_row=5 LET p_col=10
	OPEN WINDOW t504_w AT p_row,p_col WITH FORM "apj/42f/apjt504"
	CALL cl_ui_init()
	LET g_action_choice=""
	CALL t504_menu()
	CLOSE WINDOW t504_w
	CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION t504_cs()
    CLEAR FORM
 
    CONSTRUCT BY NAME g_wc ON pjk01,pjk02,pjk05,pjk29,pjk28,pjk08,pjk27,
                              pjk16,pjk18,pjk17,pjk19,pjk24
    
    BEFORE CONSTRUCT
        CALL cl_qbe_init()
    ON ACTION controlp
           CASE
              WHEN INFIELD(pjk01)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_pjk1"                                                                                      
                 LET g_qryparam.state = "c"                                                                                         
                 LET g_qryparam.default1 = g_pjk.pjk01                                                                              
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO pjk01                                                                               
                 NEXT FIELD pjk01 
 
              WHEN INFIELD(pjk02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjk"     
                 LET g_qryparam.state = "c"	  
                 LET g_qryparam.default1 = g_pjk.pjk02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk02
                 NEXT FIELD pjk02
              
              WHEN INFIELD(pjk05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"     
                 LET g_qryparam.state = "c"	  
                 LET g_qryparam.default1 = g_pjk.pjk05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pjk05
                 NEXT FIELD pjk05
 
              WHEN INFIELD(pjk29)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form = "q_gen"                                                                                      
                 LET g_qryparam.state = "c"                                                                                         
                 LET g_qryparam.default1 = g_pjk.pjk29                                                                              
                 CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                 
                 DISPLAY g_qryparam.multiret TO pjk29                                                                               
                 NEXT FIELD pjk29
             
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
    #        LET g_wc = g_wc clipped," AND pjkuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND pjkgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN             
    #    LET g_wc = g_wc clipped," AND pjkgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pjkuser', 'pjkgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT pjk01,pjk02 FROM pjk_file ",
        " WHERE ",g_wc CLIPPED, " ORDER BY pjk01,pjk02"
    PREPARE t504_prepare FROM g_sql
    DECLARE t504_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t504_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM pjk_file WHERE ",g_wc CLIPPED
    PREPARE t504_precount FROM g_sql
    DECLARE t504_count CURSOR FOR t504_precount
END FUNCTION
 
 
FUNCTION t504_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000    
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION query
          LET g_action_choice="query"
          IF cl_chk_act_auth() THEN
            CALL t504_q()
          END IF
 
        ON ACTION next
          CALL t504_fetch('N')
 
        ON ACTION previous
          CALL t504_fetch('P')
 
        ON ACTION modify
          LET g_action_choice="modify"
          IF cl_chk_act_auth() THEN
               CALL t504_u()
          END IF
 
       ON ACTION help
         CALL cl_show_help()
     
       ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
       ON ACTION jump
         CALL t504_fetch('/')
 
       ON ACTION first
         CALL t504_fetch('F')
 
       ON ACTION last
         CALL t504_fetch('L')
 
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
            IF g_pjk.pjk01 IS NOT NULL THEN
              LET g_doc.column1 = "pjk02"
              LET g_doc.value1 = g_pjk.pjk02
              CALL cl_doc()
             END IF
           END IF
    END MENU
    CLOSE t504_cs
END FUNCTION
 
 
FUNCTION t504_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pjk.* TO NULL           
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cn2
    CALL t504_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t504_count
    FETCH t504_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cn2
    OPEN t504_cs 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjk.pjk02,SQLCA.sqlcode,0)
        INITIALIZE g_pjk.* TO NULL
    ELSE
        CALL t504_fetch('F')
    END IF
END FUNCTION
 
 
FUNCTION t504_fetch(p_flpjk)
    DEFINE  p_flpjk  LIKE type_file.chr1   
    CASE p_flpjk
        WHEN 'N' FETCH NEXT     t504_cs INTO g_pjk.pjk01,g_pjk.pjk02
        WHEN 'P' FETCH PREVIOUS t504_cs INTO g_pjk.pjk01,g_pjk.pjk02
        WHEN 'F' FETCH FIRST    t504_cs INTO g_pjk.pjk01,g_pjk.pjk02
        WHEN 'L' FETCH LAST     t504_cs INTO g_pjk.pjk01,g_pjk.pjk02
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
     FETCH ABSOLUTE g_jump t504_cs INTO g_pjk.pjk01,g_pjk.pjk02
     LET mi_no_ask = FALSE      
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pjk.pjk01,SQLCA.sqlcode,0)
        INITIALIZE g_pjk.* TO NULL 
        RETURN
    ELSE
      CASE p_flpjk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.cnt    
    END IF
 
    SELECT * INTO g_pjk.* FROM pjk_file 
       WHERE pjk01 = g_pjk.pjk01 AND pjk02 = g_pjk.pjk02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pjk_file",g_pjk.pjk01,g_pjk.pjk01,SQLCA.sqlcode,"","",0) 
    ELSE
        LET g_data_owner=g_pjk.pjkuser  
        LET g_data_group=g_pjk.pjkgrup
        CALL t504_show()
    END IF
END FUNCTION
 
 
FUNCTION t504_show()
    LET g_pjk_t.* = g_pjk.*
    SELECT pjj02 INTO g_pjj02 FROM pjj_file WHERE pjj01 = g_pjk.pjk01
    DISPLAY g_pjj02 TO pjj02
    DISPLAY BY NAME g_pjk.pjk01,g_pjk.pjk02,g_pjk.pjk03,g_pjk.pjk05,g_pjk.pjk08,
                    g_pjk.pjk16,g_pjk.pjk17,g_pjk.pjk18,g_pjk.pjk19,
                    g_pjk.pjk24,g_pjk.pjk27,g_pjk.pjk28,g_pjk.pjk29
    CALL t504_pjk05('d')
    CALL t504_pjk29('d')
    CALL t504_date_e()
    CALL cl_show_fld_cont()                
END FUNCTION
 
 
FUNCTION t504_pjk05(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gem02 INTO l_gem02
         FROM gem_file
         WHERE gem01=g_pjk.pjk05
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gem02=NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
 
FUNCTION t504_pjk29(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,         
   l_gen02    LIKE gen_file.gen02,
   l_genacti  LIKE gen_file.genacti
 
   LET g_errno=''
   SELECT gen02,genacti
         INTO l_gen02,l_genacti
         FROM gen_file
         WHERE gen01=g_pjk.pjk29
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
 
 
FUNCTION t504_i(p_cmd)
   DEFINE   p_cmd       LIKE type_file.chr1,         
            l_gen02     LIKE gen_file.gen02,
            l_gen03     LIKE gen_file.gen03,
            l_gem02     LIKE gem_file.gem02,
            l_input     LIKE type_file.chr1,         
            l_n         LIKE type_file.num5,          
            l_pjk24     LIKE pjk_file.pjk24,
            l_pjk24_u_t LIKE pjk_file.pjk24
   INITIALIZE g_pjk1.* TO NULL
   LET l_pjk24 = 0                                                                                                                  
   LET g_pjk1.pjk24_u = 0 
   INPUT g_pjk.pjk29,g_pjk.pjk28,g_pjk.pjk08,
         g_pjk1.pjk18_u,g_pjk1.pjk19_u,g_pjk1.pjk24_u 
         WITHOUT DEFAULTS FROM pjk29,pjk28,pjk08,pjk18_u,pjk19_u,pjk24_u
      BEFORE INPUT
          LET l_input='N'
          LET g_pjk1.pjk18_u = g_today
          LET g_pjk1.pjk19_u = g_today
          IF g_pjk1.pjk24_u = l_pjk24 THEN
             LET g_pjk1.pjk24_u = g_pjk1.pjk19_u-g_pjk1.pjk18_u+1
             LET l_pjk24 = g_pjk1.pjk24_u
          END IF
          LET g_pjk.pjk28 = g_today  
          LET g_pjk.pjk29 = g_user
          CALL t504_pjk29('a') 
          DISPLAY g_pjk1.pjk18_u,g_pjk1.pjk19_u,g_pjk1.pjk24_u,g_pjk.pjk29,l_gen02,g_pjk.pjk28
               TO pjk18_u,pjk19_u,pjk24_u,pjk29,gen02,pjk28
 
      AFTER FIELD pjk29
         IF g_pjk.pjk29 IS NOT NULL THEN
	    CALL t504_pjk29('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('pjk29:',g_errno,1)
               LET g_pjk.pjk29 = g_pjk_t.pjk29
               DISPLAY BY NAME g_pjk.pjk29
               CALL t504_pjk29('a') 
               NEXT FIELD pjk29
            END IF
         ELSE 
            CALL cl_err('pjk29:','ggl-808',1)
            NEXT FIELD pjk29
         END IF
 
      AFTER FIELD pjk08
	    IF NOT cl_null(g_pjk.pjk08) THEN
               IF g_pjk.pjk08 < 0 OR g_pjk.pjk08 > 100 ThEN
                  CALL cl_err('pjk08:','mfg0091',0)
                  NEXT FIELD pjk08
               END IF
	    END IF
            
      BEFORE FIELD pjk19_u
            IF NOT cl_null(g_pjk1.pjk19_u)THEN
               LET g_pjk1.pjk19_u = g_pjk1.pjk19_u
            END IF
      AFTER FIELD pjk18_u 
            IF g_pjk.pjk08>0 AND cl_null(g_pjk1.pjk18_u) THEN
                CALL cl_err(g_pjk1.pjk18_u,'apj-019',0)
                NEXT FIELD pjk18_u 
            END IF
      AFTER FIELD pjk19_u
            IF g_pjk.pjk08=100 AND cl_null(g_pjk1.pjk19_u) THEN                                                                       
                CALL cl_err(g_pjk1.pjk19_u,'apj-029',0)                                                                             
                NEXT FIELD pjk19_u                                                                                                  
            END IF 
            IF g_pjk1.pjk19_u < g_pjk1.pjk18_u THEN
                CALL cl_err(g_pjk1.pjk19_u,'aec-993',0)
                NEXT FIELD pjk19_u
            ELSE
                LET g_pjk1.pjk24_u = g_pjk1.pjk19_u-g_pjk1.pjk18_u+1                                                                    
                LET l_pjk24 = g_pjk1.pjk24_u                                                                                            
                DISPLAY BY NAME g_pjk1.pjk24_u
            END IF
      ON CHANGE pjk18_u
            IF g_pjk1.pjk19_u < g_pjk1.pjk18_u THEN                                                                                 
                CALL cl_err(g_pjk1.pjk19_u,'aec-993',0)                                                                             
                NEXT FIELD pjk18_u                                                                                                  
            ELSE                           
                LET g_pjk1.pjk24_u = g_pjk1.pjk19_u-g_pjk1.pjk18_u+1
                LET l_pjk24 = g_pjk1.pjk24_u
                DISPLAY BY NAME g_pjk1.pjk24_u
            END IF
     BEFORE FIELD pjk24_u
            LET l_pjk24_u_t = g_pjk1.pjk24_u
     AFTER FIELD pjk24_u
          #No.TQC-840018 --Begin
               IF cl_null(g_pjk1.pjk19_u) AND g_pjk1.pjk24_u < 1 THEN
                   CALL cl_err(g_pjk1.pjk24_u,'apj-083',0)
                   LET g_pjk1.pjk24_u = l_pjk24_u_t
                   DISPLAY BY NAME g_pjk1.pjk24_u
                   NEXT FIELD pjk24_u
               END IF           
          #No.TQC-840018 --End                       
               IF NOT cl_null(g_pjk1.pjk19_u) AND cl_null(g_pjk1.pjk24_u) THEN                                                            
                   CALL cl_err(g_pjk1.pjk24_u,'apj-082',0)                                                                              
                   NEXT FIELD pjk24_u                                                                                                   
               END IF      
               IF g_pjk1.pjk24_u < 0 OR g_pjk1.pjk24_u > g_pjk1.pjk19_u-g_pjk1.pjk18_u+1 THEN
                   CALL cl_err(g_pjk1.pjk19_u,'apj-052',0)  
                   NEXT FIELD pjk24_u
               END IF
 
      AFTER INPUT
         LET g_pjk.pjkuser = s_get_data_owner("pjk_file") #FUN-C10039
         LET g_pjk.pjkgrup = s_get_data_group("pjk_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_pjk.pjk02 IS NULL THEN
               DISPLAY BY NAME g_pjk.pjk02
               LET l_input='Y'
            END IF
            IF g_pjk.pjk29 IS NOT NULL THEN                                                                                            
            CALL t504_pjk29('a')                                                                                                    
            IF NOT cl_null(g_errno) THEN                                                                                            
               CALL cl_err('pjk29:',g_errno,1)                                                                                      
               LET g_pjk.pjk29 = g_pjk_t.pjk29                                                                                      
               DISPLAY BY NAME g_pjk.pjk29
               CALL t504_pjk29('a')                                                                                           
               NEXT FIELD pjk29                                                                                                     
            END IF                                                                                                                  
         END IF     
         #No.TQC-840018 --Begin
         IF g_pjk.pjk08>0 AND cl_null(g_pjk1.pjk18_u) THEN 
               CALL cl_err(g_pjk1.pjk18_u,'apj-019',0)
               NEXT FIELD pjk18_u 
         END IF
         IF g_pjk.pjk08=100 AND cl_null(g_pjk1.pjk19_u) THEN
               CALL cl_err(g_pjk1.pjk19_u,'apj-029',0)
               NEXT FIELD pjk19_u
         END IF
         IF NOT cl_null(g_pjk1.pjk19_u) AND cl_null(g_pjk1.pjk24_u) THEN
               CALL cl_err(g_pjk1.pjk24_u,'apj-082',0)
               NEXT FIELD pjk24_u
         END IF            
         #No.TQC-840018 --End
         IF NOT cl_null(g_pjk1.pjk19_u) THEN                                                                                     
               IF g_pjk1.pjk19_u < g_pjk1.pjk18_u ThEN                                                                              
                  CALL cl_err(g_pjk1.pjk19_u,'aec-993',0)                                                                           
                  NEXT FIELD pjk19_u                                                                                                
               ELSE                                                                                                                 
                  IF NOT cl_null(g_pjk1.pjk19_u) AND NOT cl_null(g_pjk1.pjk18_u)THEN          
                     IF g_pjk1.pjk24_u = l_pjk24 THEN                                      
                        LET g_pjk1.pjk24_u = g_pjk1.pjk19_u - g_pjk1.pjk18_u+1          
                        LET l_pjk24 = g_pjk1.pjk24_u                                                  
                     END IF        
                  END IF                                                                                                   
               END IF                                                                                                               
            END IF
                                             
            IF l_input='Y' THEN
               NEXT FIELD pjk022
            END IF
 
      ON ACTION CONTROLO
         IF INFIELD(pjk02) THEN
            LET g_pjk.* = g_pjk_t.*
            CALL t504_show()
            NEXT FIELD pjk022
         END IF
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(pjk29)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_pjk.pjk29
              CALL cl_create_qry() RETURNING g_pjk.pjk29
              DISPLAY BY NAME g_pjk.pjk29
              CALL t504_pjk29('a')
              NEXT FIELD pjk29
 
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
 
 
FUNCTION t504_u()
 
IF g_pjk.pjk27 = '0' OR  g_pjk.pjk27 = '1' OR g_pjk.pjk27 IS NULL THEN    
    IF g_pjk.pjk02 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
ELSE
    IF  g_pjk.pjk27 = '2' THEN
        CALL cl_err('','apj-053',0)
        RETURN
    END IF
    IF  g_pjk.pjk27 = '3' THEN                                                                                                      
        CALL cl_err('','apj-054',0)     
        RETURN                                                                                              
    END IF        
    IF  g_pjk.pjk27 = '4' THEN                                                                                                      
        CALL cl_err('',9004,0)
        RETURN                                                                                                   
    END IF       
END IF 
    SELECT * INTO g_pjk.* FROM pjk_file WHERE pjk02=g_pjk.pjk02 AND pjk01=g_pjk.pjk01
    IF g_pjk.pjkacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pjk01_t = g_pjk.pjk01          #No.TQC-840018
    LET g_pjk02_t = g_pjk.pjk02
    BEGIN WORK
 
    OPEN t504_cl USING g_pjk.pjk01,g_pjk.pjk02
    IF STATUS THEN
       CALL cl_err("OPEN t504_cl:", STATUS, 1)
       CLOSE t504_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t504_cl INTO g_pjk.* 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pjk.pjk02,SQLCA.sqlcode,1)
       CLOSE t504_cl
       ROLLBACK WORK
       RETURN
    END IF
    LET g_pjk.pjkmodu=g_user 
    LET g_pjk.pjkdate = g_today
    CALL t504_show()
    WHILE TRUE
        CALL t504_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pjk.*=g_pjk_t.*
            LET g_pjk1.*=g_pjk1_t.*
            CALL t504_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pjk_file SET pjk_file.pjk08 = g_pjk.pjk08,
                            pjk_file.pjk28 = g_pjk.pjk28,
                            pjk_file.pjk29 = g_pjk.pjk29,
                            pjk_file.pjk18 = g_pjk1.pjk18_u,
                            pjk_file.pjk19 = g_pjk1.pjk19_u,
            pjk_file.pjk24 = g_pjk1.pjk24_u
      WHERE pjk01 = g_pjk01_t AND pjk02 = g_pjk02_t
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pjk_file",g_pjk.pjk01,g_pjk.pjk02,SQLCA.sqlcode,"","",0)
         CONTINUE WHILE
        END IF
        DISPLAY g_pjk1.pjk18_u,g_pjk1.pjk19_u,g_pjk1.pjk24_u TO pjk18,pjk19,pjk24
        EXIT WHILE
    END WHILE
    INITIALIZE g_pjk1.* TO NULL
    DISPLAY BY NAME g_pjk1.*
    CLOSE t504_cl
    COMMIT WORK
END FUNCTION  
 
FUNCTION t504_date_e()
 
    DEFINE l_start LIKE pjk_file.pjk20,
           l_end   LIKE pjk_file.pjk20
    DEFINE l_pja19 LIKE pja_file.pja19
    SELECT pjk20,pjk21,pjk22,pjk23,pja19 
           INTO g_pjk.pjk20,g_pjk.pjk21,g_pjk.pjk22,g_pjk.pjk23,l_pja19
    FROM pjk_file,OUTER pjj_file,OUTER pja_file
    WHERE pjk_file.pjk01=pjj_file.pjj01 AND pjj_file.pjj04=pja_file.pja01
    IF l_pja19='1' THEN 
       DISPLAY g_pjk.pjk20,g_pjk.pjk21 TO start_date_e,end_date_e
    ELSE
       DISPLAY g_pjk.pjk22,g_pjk.pjk23 TO start_date_e,end_date_e    
    END IF
END FUNCTION
#No.FUN-790025


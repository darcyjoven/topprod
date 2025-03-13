# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aglt602.4gl
# Descriptions...: 預算追加維護作業
# Date & Author..: No.FUN-810069 08/03/03 By Zhangyajun
# Modify.........: No.TQC-830032 By Zhangyajun BUG修改
# Modify.........: No.FUN-840002 By Zhangyajun 審核時增加更新afb_file
# Modify.........: No.TQC-840018 By Zhangyajun 規格變動：根據aza08動態隱藏pnu036,pnu038
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.FUN-930106 09/03/17 By destiny pnu031預算項目字段增加管控
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.TQC-970200 09/09/21 By baofei 新增后打印報錯   
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No.TQC-9A0157 09/10/28 By wujie   SQL 修改
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-AC0009 10/12/01 By wujie  aglt602科目编号pnu032开窗挑选只作预算的科目aag21='Y'， aag07<>'1'
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C30268 12/03/10 By minpp 預算追減，未控卡 "追加/減金額"金額，導致 "總預算金額"有<0的異常!! 
# Modify.........: No.MOD-C50146 12/05/23 By Polly 搜尋組sql時，將使用者同部門條件拿除
# Modify.........: No.MOD-CA0192 12/10/30 By Polly 調整預算檢查錯誤時，回到pnu037欄位重新輸入
# Modify.........: No.FUN-D70090 13/07/18 By fengmy aglt600无效预算不可追加

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pnu            RECORD LIKE pnu_file.*,
       g_pnu_t          RECORD LIKE pnu_file.*,  
       g_pnu01_t        LIKE  pnu_file.pnu01,    
       g_pnu02_t        LIKE  pnu_file.pnu02   
 
DEFINE g_forupd_sql          STRING              
DEFINE g_wc                  STRING                
DEFINE g_sql                 STRING                 
DEFINE g_chr                 LIKE pnu_file.pnuacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10        
DEFINE g_row_count           LIKE type_file.num10                
DEFINE g_jump                LIKE type_file.num10               
DEFINE mi_no_ask             LIKE type_file.num5                  
DEFINE l_msg                 STRING
DEFINE l_table STRING 
DEFINE g_str   STRING 
DEFINE l_tmp   LIKE type_file.chr5
 
MAIN
DEFINE p_row,p_col     LIKE type_file.num5           
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                   
  
    IF (NOT cl_user()) THEN                     
      EXIT PROGRAM                              
    END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
   INITIALIZE g_pnu.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM pnu_file WHERE pnu01 = ? AND pnu02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t602_cl CURSOR FROM g_forupd_sql                 
 
   LET p_row = 5 LET p_col = 10
   OPEN WINDOW w_curr AT p_row,p_col WITH FORM "agl/42f/aglt602"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              
       
   CALL cl_ui_init()
   
    IF g_aza.aza08='N' THEN                                                                                                         
       CALL cl_set_comp_visible("pnu036,pnu038",FALSE)                                                                               
       CALL cl_set_comp_visible("pja02",FALSE)                                                                                      
    END IF                                                                                                                          
 
   LET g_action_choice = ''
   CALL t602_menu()
 
   CLOSE WINDOW w_curr
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
      
END MAIN
 
FUNCTION t602_cs()
 
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                               
        pnu01,pnu02,pnuconf,pnu037,pnu032,pnu033,pnu031,
        pnu038,pnu036,pnu034,pnu035,pnu04,
	pnuuser,pnugrup,pnumodu,pnudate,pnuacti
             
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(pnu033)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnu033
                 NEXT FIELD pnu033   #TQC-830032
               WHEN INFIELD(pnu031)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf01a"                  #No.FUN-930106
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = '7'                         #No.FUN-950077
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnu031
                 NEXT FIELD pnu031    #TQC-830032
               WHEN INFIELD(pnu03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnu03
                 NEXT FIELD pnu03    #TQC-830032
               WHEN INFIELD(pnu038)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnu038
                 NEXT FIELD pnu038
               WHEN INFIELD(pnu036)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnu036
                 NEXT FIELD pnu036
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
 
    
   #LET g_wc = g_wc clipped," AND pnugrup LIKE '",        #MOD-C50146 mark
   #           g_grup CLIPPED,"%'"                        #MOD-C50146 mark
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pnuuser', 'pnugrup')
 
    LET g_sql="SELECT pnu01,pnu02 FROM pnu_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY pnu01,pnu02"
    PREPARE t602_prepare FROM g_sql
    DECLARE t602_cs SCROLL CURSOR WITH HOLD FOR t602_prepare
    LET g_sql = "SELECT COUNT(*) FROM pnu_file WHERE ",g_wc CLIPPED
    PREPARE t602_precount FROM g_sql
    DECLARE t602_count CURSOR FOR t602_precount
END FUNCTION
 
FUNCTION t602_menu()
 
    MENU ""
      BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
               
       ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t602_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN              
		CALL t602_q()
            END IF
        ON ACTION next
            CALL t602_fetch('N')
        ON ACTION previous
            CALL t602_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t602_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t602_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t602_r()
            END IF
       ON ACTION output
            LET g_action_choice="output"
           IF cl_chk_act_auth()
               THEN CALL t602_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t602_fetch('/')
        ON ACTION first
            CALL t602_fetch('F')
        ON ACTION last
            CALL t602_fetch('L')
            
        ON ACTION confirm               #確認 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                CALL t602_y()
           END IF 
        ON ACTION undo_confirm             #取消確認�
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t602_z()
            END IF
            
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
              IF NOT cl_null(g_pnu.pnu01) AND NOT cl_null(g_pnu.pnu02)  THEN
                 LET g_doc.column1 = "pnu01"
                 LET g_doc.column2 = "pnu02"
                 LET g_doc.value1 = g_pnu.pnu01
                 LET g_doc.value2 = g_pnu.pnu02
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t602_cs
END FUNCTION
 
 
FUNCTION t602_a()
    MESSAGE ""
    CLEAR FORM         
                              
    INITIALIZE g_pnu.* LIKE pnu_file.*
    LET g_pnu01_t = NULL
    LET g_pnu02_t = NULL
    LET g_wc = NULL
    
    CALL cl_opmsg('a')
    
    WHILE TRUE
        LET g_pnu.pnuuser = g_user
        LET g_pnu.pnuoriu = g_user #FUN-980030
        LET g_pnu.pnuorig = g_grup #FUN-980030
        LET g_pnu.pnugrup = g_grup               
        LET g_pnu.pnudate = g_today
        LET g_pnu.pnuacti = 'Y'
        LET g_pnu.pnu01 = g_today
        LET g_pnu.pnu037 = g_aza.aza81
        LET g_pnu.pnu034 = YEAR(g_today)
        LET g_pnu.pnu035 = MONTH(g_today)
        LET g_pnu.pnu04 = 0
        LET g_pnu.pnuconf ='N'
        
        CALL t602_i("a")                         
        IF INT_FLAG THEN                         
            INITIALIZE g_pnu.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        
        IF  cl_null(g_pnu.pnu01) OR  cl_null(g_pnu.pnu02) THEN              
            CONTINUE WHILE
        END IF
        
        INSERT INTO pnu_file VALUES(g_pnu.*)    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pnu_file",g_pnu.pnu01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
            SELECT pnu01,pnu02 INTO g_pnu.pnu01,g_pnu.pnu02 FROM pnu_file
                     WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t602_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,
            l_n       LIKE type_file.num5
   DEFINE   l_pnu034  STRING 
   DEFINE   l_pnu04   LIKE pnu_file.pnu04  
   DEFINE   l_pjb09   LIKE pjb_file.pjb09      #No.FUN-850027 
   DEFINE   l_pjb11   LIKE pjb_file.pjb11      #No.FUN-850027
  
   DISPLAY BY NAME
      g_pnu.pnu01,g_pnu.pnu037,g_pnu.pnu04,
      g_pnu.pnuuser,g_pnu.pnugrup,g_pnu.pnumodu,
      g_pnu.pnudate,g_pnu.pnuacti,g_pnu.pnuconf
   
   LET g_pnu01_t = g_pnu.pnu01
   LET g_pnu02_t = g_pnu.pnu02
   
   INPUT BY NAME
      g_pnu.pnu01,g_pnu.pnu02,g_pnu.pnu037,g_pnu.pnu032,g_pnu.pnu033,
      g_pnu.pnu031,g_pnu.pnu038,g_pnu.pnu036,g_pnu.pnu034,g_pnu.pnu035,
      g_pnu.pnu04
      WITHOUT DEFAULTS
 
     BEFORE FIELD pnu02
        IF cl_null(g_pnu.pnu02) OR g_pnu.pnu02 = 0 THEN 
            SELECT MAX(pnu02)+1 INTO g_pnu.pnu02 FROM pnu_file
                WHERE pnu01 = g_pnu.pnu01
                IF cl_null(g_pnu.pnu02) THEN
                   LET g_pnu.pnu02 = 1 
                END IF
         END IF    
      AFTER FIELD pnu01,pnu02
          IF cl_null(g_pnu.pnu01 || g_pnu.pnu02) THEN
             IF NOT cl_null(g_pnu.pnu01) THEN                           
                 NEXT FIELD pnu02
             END IF
             IF NOT cl_null(g_pnu.pnu02) THEN                    
                  NEXT FIELD pnu01
             END IF            
          ELSE
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu01 != g_pnu01_t AND g_pnu.pnu02 !=g_pnu02_t) THEN
              SELECT COUNT(*) INTO l_n FROM pnu_file WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02
              IF l_n > 0 THEN       
                  LET l_msg = g_pnu.pnu01 CLIPPED,g_pnu.pnu02 CLIPPED           
                  CALL cl_err(l_msg,-239,0)
                  LET g_pnu.pnu01 = g_pnu01_t
                  LET g_pnu.pnu02 = g_pnu02_t
                  DISPLAY BY NAME g_pnu.pnu01,g_pnu.pnu02
                  IF INFIELD(pnu01) THEN
                     NEXT FIELD pnu01
                  END IF
                  NEXT FIELD pnu02
               END IF                              
             END IF
           END IF
      AFTER FIELD pnu037
         IF NOT cl_null(g_pnu.pnu037) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu037 != g_pnu_t.pnu037) THEN              
               SELECT COUNT(*) INTO l_n FROM aaa_file WHERE aaa01 = g_pnu.pnu037 AND aaaacti = 'Y'
               IF l_n<1 THEN
                  CALL cl_err('pnu00:','agl-095',0)
                  LET g_pnu.pnu037 = g_pnu_t.pnu037
                  DISPLAY BY NAME g_pnu.pnu037
                  NEXT FIELD pnu037
               END IF
            END IF
         END IF
        
      AFTER FIELD pnu036
         IF NOT cl_null(g_pnu.pnu036) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu036 != g_pnu_t.pnu036) THEN      
               IF cl_null(g_pnu.pnu038) THEN
                  CALL cl_err('pnu036:','agl-956',0)
                  NEXT FIELD pnu042
               ELSE        
                  SELECT COUNT(*) INTO l_n FROM pjb_file WHERE pjb01 = g_pnu.pnu038 AND pjbacti = 'Y'
                  IF l_n<1 THEN
                     CALL cl_err('pnu036:','apj-051',0)
                     LET g_pnu.pnu04 = g_pnu_t.pnu036
                     DISPLAY BY NAME g_pnu.pnu036
                     NEXT FIELD pnu036
                  ELSE
                     SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
                      FROM pjb_file WHERE pjb01 = g_pnu.pnu038
                       AND pjb02 = g_pnu.pnu036
                       AND pjbacti = 'Y'            
                     IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                        CALL cl_err(g_pnu.pnu036,'apj-090',0)
                        LET g_pnu.pnu036 = g_pnu_t.pnu036
                        NEXT FIELD pnu036
                     END IF
                  END IF
               END IF
            END IF
         ELSE 
            LET g_pnu.pnu036 = ' '
         END IF
         
      AFTER FIELD pnu033
         IF NOT cl_null(g_pnu.pnu033) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu033 != g_pnu_t.pnu033) THEN              
               CALL t602_pnu033('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pnu033:',g_errno,0)
                  LET g_pnu.pnu033 = g_pnu_t.pnu033
                  DISPLAY BY NAME g_pnu.pnu033
                  NEXT FIELD pnu033
               END IF
            END IF
        ELSE 
           LET g_pnu.pnu033 = ' ' 
        END IF
              
      AFTER FIELD pnu031
         IF NOT cl_null(g_pnu.pnu031) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu031 != g_pnu_t.pnu031) THEN              
               CALL t602_pnu031('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pnu01:',g_errno,0)
                  LET g_pnu.pnu031 = g_pnu_t.pnu031
                  DISPLAY BY NAME g_pnu.pnu031
                  NEXT FIELD pnu031
               END IF
            END IF
         END IF 
         
      AFTER FIELD pnu032
         IF NOT cl_null(g_pnu.pnu032) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu032 != g_pnu_t.pnu032) THEN              
               CALL t602_pnu032('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pnu032:',g_errno,0)
                 #Mod No.FUN-B10048
                 #LET g_pnu.pnu032 = g_pnu_t.pnu032
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_aag"
                  LET g_qryparam.construct = 'N'
                  LET g_qryparam.arg1 = g_pnu.pnu037
                  LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21 ='Y' AND aag01 LIKE '",g_pnu.pnu032 CLIPPED,"%'"
                  LET g_qryparam.default1 = g_pnu.pnu032
                  CALL cl_create_qry() RETURNING g_pnu.pnu032
                 #End Mod No.FUN-B10048
                  DISPLAY BY NAME g_pnu.pnu032
                  NEXT FIELD pnu032
               END IF
            END IF
         END IF
         
      AFTER FIELD pnu038
         IF NOT cl_null(g_pnu.pnu038) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu038 != g_pnu_t.pnu038) THEN              
               CALL t602_pnu038('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pnu038:',g_errno,0)
                  LET g_pnu.pnu038 = g_pnu_t.pnu038
                  DISPLAY BY NAME g_pnu.pnu038
                  NEXT FIELD pnu038
               END IF
            END IF
         ELSE 
            LET g_pnu.pnu038= ' '
         END IF
         
      AFTER FIELD pnu034
         IF NOT cl_null(g_pnu.pnu034) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnu.pnu034 != g_pnu_t.pnu034) THEN              
               LET l_pnu034 = g_pnu.pnu034
               IF LENGTH(l_pnu034)<>4 THEN
                  NEXT FIELD pnu034
               END IF
            END IF
         END IF        
     AFTER FIELD pnu035
        IF NOT cl_null(g_pnu.pnu035) THEN
           IF p_cmd = "a" OR
              (p_cmd = "u" AND g_pnu.pnu035 != g_pnu_t.pnu035) THEN
              IF g_pnu.pnu035>0 THEN                          
                  IF g_azm.azm02 = '1' THEN                         
                    IF g_pnu.pnu035>12 THEN                   
                      CALL cl_err('','mfg9287',0)                 
                      NEXT FIELD pnu035                            
                    END IF                                         
                  END IF                                            
               IF g_azm.azm02 = '2' THEN                         
                  IF g_pnu.pnu035>13 THEN                   
                     CALL cl_err('','mfg9288',0)                 
                     NEXT FIELD pnu035                            
                  END IF                                         
               END IF                                            
              ELSE                                                 
                  NEXT FIELD pnu035                                  
              END IF
              CALL t602_pnu035('a') 
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pnu035:',g_errno,0)
                  LET g_pnu.pnu035 = g_pnu_t.pnu035
                  DISPLAY BY NAME g_pnu.pnu035
                 #NEXT FIELD pnu035                   #MOD-CA0192 mark
                  NEXT FIELD pnu037                   #MOD-CA0192 add
               END IF
            END IF
          END IF
      AFTER FIELD  pnu04
        IF NOT cl_null(g_pnu.pnu04) THEN   
           CALL t602_pnu035('a') 
              IF NOT cl_null(g_errno) THEN
                  CALL cl_err('pnu04:',g_errno,0)
                  LET g_pnu.pnu04 = g_pnu_t.pnu04
                  DISPLAY BY NAME g_pnu.pnu04
                  NEXT FIELD pnu04
               END IF
        END IF          
     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_pnu.pnu01)  THEN
              NEXT FIELD pnu01
            END IF
            IF cl_null(g_pnu.pnu02)  THEN
              NEXT FIELD pnu02
            END IF
      ON ACTION CONTROLO                        
         IF INFIELD(pnu01) THEN
            LET g_pnu.* = g_pnu_t.*
            CALL t602_show()
            NEXT FIELD pnu01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(pnu033)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_pnu.pnu033
                 CALL cl_create_qry() RETURNING g_pnu.pnu033
                 DISPLAY g_pnu.pnu033 TO pnu033
                 NEXT FIELD pnu033
               WHEN INFIELD(pnu031)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf01a"            #No.FUN-930106   
                 LET g_qryparam.arg1 = '7'                   #No.FUN-950077 
                 LET g_qryparam.default1 = g_pnu.pnu031
                 CALL cl_create_qry() RETURNING g_pnu.pnu031
                 DISPLAY g_pnu.pnu031 TO pnu031
                 NEXT FIELD pnu031
               WHEN INFIELD(pnu032)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_pnu.pnu037
                 LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21 ='Y'"    #No.MOD-AC0009
                 LET g_qryparam.default1 = g_pnu.pnu032
                 CALL cl_create_qry() RETURNING g_pnu.pnu032
                 DISPLAY g_pnu.pnu032 TO pnu032
                 NEXT FIELD pnu032
               WHEN INFIELD(pnu038)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.default1 = g_pnu.pnu038
                 CALL cl_create_qry() RETURNING g_pnu.pnu038
                 DISPLAY g_pnu.pnu038 TO pnu038
                 NEXT FIELD pnu038
               WHEN INFIELD(pnu036)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.default1 = g_pnu.pnu036
                 CALL cl_create_qry() RETURNING g_pnu.pnu036
                 DISPLAY g_pnu.pnu04 TO pnu036
                 NEXT FIELD pnu036
 
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
 
FUNCTION t602_pnu033(p_cmd)         
DEFINE    l_gemacti  LIKE gem_file.gemacti, 
          l_gem02    LIKE gem_file.gem02,    
          p_cmd      LIKE type_file.chr1            
          
   LET g_errno = ' '
   SELECT gem02,gemacti INTO l_gem02,l_gemacti  FROM gem_file     
         WHERE gem01 = g_pnu.pnu033
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='ast-070' 
                                 LET l_gem02=NULL 
        WHEN l_gemacti='N'       LET g_errno='9028'     
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
 
END FUNCTION
 
FUNCTION t602_pnu031(p_cmd)         
DEFINE    l_azfacti  LIKE azf_file.azfacti
DEFINE    l_azf03    LIKE azf_file.azf03  
DEFINE    p_cmd      LIKE type_file.chr1           
DEFINE    l_azf09    LIKE azf_file.azf09        #No.FUN-930106      
    
   LET g_errno = ' '
   SELECT azf03,azfacti,azf09 INTO l_azf03,l_azfacti,l_azf09  FROM azf_file      #No.FUN-930106
         WHERE azf01 = g_pnu.pnu031 AND azf02 = '2'
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-005' 
                                 LET l_azf03=NULL 
        WHEN l_azfacti='N'       LET g_errno='9028'     
        WHEN l_azf09 !='7'       LET g_errno='aoo-406'                           #No.FUN-950077
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
  END IF
 
END FUNCTION
 
FUNCTION t602_pnu032(p_cmd)         
DEFINE    l_aagacti  LIKE aag_file.aagacti, 
          l_aag02    LIKE aag_file.aag02,    
          p_cmd      LIKE type_file.chr1            
          
   LET g_errno = ' '
   SELECT aag02,aagacti INTO l_aag02,l_aagacti  FROM aag_file     
         WHERE aag00 = g_pnu.pnu037 AND aag01 = g_pnu.pnu032 AND aag03 = '2' AND aag07 IN ('2','3') AND aag21 ='Y'  #No.MOD-AC0009 
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-001' 
                                 LET l_aag02=NULL 
        WHEN l_aagacti='N'       LET g_errno='9028'     
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_aag02 TO FORMONLY.aag02
  END IF
 
END FUNCTION
 
FUNCTION t602_pnu038(p_cmd)         
DEFINE    l_pjaclose LIKE pja_file.pjaclose          #No.FUN-960038
DEFINE    l_pjaacti  LIKE pja_file.pjaacti
DEFINE    l_pja02    LIKE pja_file.pja02   
DEFINE    p_cmd      LIKE type_file.chr1           
          
   LET g_errno = ' '
   SELECT pja02,pjaacti,pjaclose INTO l_pja02,l_pjaacti,l_pjaclose  FROM pja_file #No.FUN-960038 add pjaclose    
         WHERE pja01 = g_pnu.pnu038
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='agl-007' 
                                 LET l_pja02=NULL 
        WHEN l_pjaacti='N'       LET g_errno='9028'     
        WHEN l_pjaclose = 'Y'    LET g_errno='abg-503' #No.FUN-960038 
        OTHERWISE   
           LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pja02 TO FORMONLY.pja02
  END IF
 
END FUNCTION
 
FUNCTION t602_pnu035(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,          
        l_afc06_1  LIKE afc_file.afc06,
        l_afc08_1  LIKE afc_file.afc08,
        l_afc09_1  LIKE afc_file.afc09,
        l_afc_tot_1 LIKE afc_file.afc06
        
   LET g_errno=''
   IF g_aza.aza08='N' THEN
       LET g_pnu.pnu036 = ' '                                                                                                        
       LET g_pnu.pnu038 = ' '
   END IF
   SELECT afc06,afc08,afc09
     INTO l_afc06_1,l_afc08_1,l_afc09_1
     FROM afc_file
    WHERE afc00 = g_pnu.pnu037 AND afc01 = g_pnu.pnu031 AND afc02 = g_pnu.pnu032
      AND afc03 = g_pnu.pnu034 AND afc04 = g_pnu.pnu036 AND afc041 = g_pnu.pnu033
      AND afc042 = g_pnu.pnu038 AND afc05 = g_pnu.pnu035
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-958'
                                LET l_afc06_1 = NULL
                                LET l_afc08_1 = NULL
                                LET l_afc09_1 = NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      IF cl_null(g_pnu.pnu04) THEN LET g_pnu.pnu04 = 0 END IF
      IF cl_null(l_afc06_1) THEN LET l_afc06_1 = 0 END IF
      IF cl_null(l_afc08_1) THEN LET l_afc08_1 = 0 END IF
      IF cl_null(l_afc09_1) THEN LET l_afc09_1 = 0 END IF
      IF p_cmd ='a' THEN
         LET l_afc09_1 = l_afc09_1 + g_pnu.pnu04
      END IF
      LET l_afc_tot_1 = l_afc06_1 + l_afc08_1 + l_afc09_1
      #MOD-C30268--ADD---STR
          IF l_afc_tot_1 < 0 THEN
             LET g_errno='agl-096'
          END IF
      #MOD-C30268--ADD---END
      DISPLAY l_afc06_1 TO FORMONLY.afc06_1
      DISPLAY l_afc08_1 TO FORMONLY.afc08_1
      DISPLAY l_afc09_1 TO FORMONLY.afc09_1
      DISPLAY l_afc_tot_1 TO FORMONLY.afc_tot_1
   END IF
END FUNCTION
 
FUNCTION t602_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    
    INITIALIZE g_pnu.* TO NULL    
            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    
    CALL t602_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t602_count
    FETCH t602_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t602_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,0)
        INITIALIZE g_pnu.* TO NULL
    ELSE
        CALL t602_fetch('F')              
    END IF
END FUNCTION
 
FUNCTION t602_fetch(p_flpnu)
    DEFINE  p_flpnu         LIKE type_file.chr1  
             
    CASE p_flpnu
        WHEN 'N' FETCH NEXT     t602_cs INTO g_pnu.pnu01,g_pnu.pnu02
        WHEN 'P' FETCH PREVIOUS t602_cs INTO g_pnu.pnu01,g_pnu.pnu02
        WHEN 'F' FETCH FIRST    t602_cs INTO g_pnu.pnu01,g_pnu.pnu02
        WHEN 'L' FETCH LAST     t602_cs INTO g_pnu.pnu01,g_pnu.pnu02
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
            FETCH ABSOLUTE g_jump t602_cs INTO g_pnu.pnu01,g_pnu.pnu02
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,0)
        INITIALIZE g_pnu.* TO NULL  
        RETURN
    ELSE
      CASE p_flpnu
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_pnu.* FROM pnu_file    
       WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pnu_file",g_pnu.pnu01,g_pnu.pnu02,SQLCA.sqlcode,"","",0)  
    ELSE
        CALL t602_show()                   
    END IF
END FUNCTION
 
FUNCTION t602_show()
    LET g_pnu_t.* = g_pnu.*
    DISPLAY BY NAME g_pnu.*
    DISPLAY BY NAME g_pnu.pnu01,g_pnu.pnu02,g_pnu.pnu037,g_pnu.pnu032,g_pnu.pnu033,
                    g_pnu.pnu031,g_pnu.pnu038,g_pnu.pnu036,g_pnu.pnu034,g_pnu.pnu035,
                    g_pnu.pnu04,g_pnu.pnuuser,g_pnu.pnugrup,g_pnu.pnumodu,
                    g_pnu.pnudate,g_pnu.pnuacti,g_pnu.pnuconf
    CALL t602_pnu031('d')
    CALL t602_pnu032('d')
    CALL t602_pnu033('d')
    CALL t602_pnu038('d')
    CALL t602_pnu035('d')
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t602_u()
 
    IF cl_null(g_pnu.pnu01) OR cl_null(g_pnu.pnu02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_pnu.* FROM pnu_file WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02
    
    IF g_pnu.pnuacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    
    IF g_pnu.pnuconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pnu01_t = g_pnu.pnu01
    LET g_pnu02_t = g_pnu.pnu02
    
    BEGIN WORK
 
    OPEN t602_cl USING g_pnu.pnu01,g_pnu.pnu02
    IF STATUS THEN
       CALL cl_err("OPEN t602_cl:", STATUS, 1)
       CLOSE t602_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t602_cl INTO g_pnu.*              
    IF SQLCA.sqlcode THEN
       LET l_msg = g_pnu.pnu01 CLIPPED,g_pnu.pnu02 CLIPPED
       CALL cl_err(l_msg,SQLCA.sqlcode,1)
        RETURN
    END IF
    LET g_pnu.pnumodu=g_user                  
    LET g_pnu.pnudate = g_today               
    CALL t602_show()                          
    WHILE TRUE
        CALL t602_i("u")                      
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pnu.*=g_pnu_t.*
            CALL t602_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pnu_file SET pnu_file.* = g_pnu.*
            WHERE pnu01 = g_pnu01_t AND pnu02 = g_pnu02_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pnu_file",g_pnu.pnu01,g_pnu.pnu02,SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t602_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t602_x()
 
    IF cl_null(g_pnu.pnu01) OR cl_null(g_pnu.pnu02) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    IF g_pnu.pnuconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    BEGIN WORK
 
    OPEN t602_cl USING g_pnu.pnu01,g_pnu.pnu02
    IF STATUS THEN
       CALL cl_err("OPEN t602_cl:", STATUS, 1)
       CLOSE t602_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t602_cl INTO g_pnu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t602_show()
    IF cl_exp(0,0,g_pnu.pnuacti) THEN
        LET g_chr=g_pnu.pnuacti
        IF g_pnu.pnuacti='Y' THEN
            LET g_pnu.pnuacti='N'
        ELSE
            LET g_pnu.pnuacti='Y'
        END IF
        UPDATE pnu_file
            SET pnuacti=g_pnu.pnuacti
            WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,0)
            LET g_pnu.pnuacti=g_chr
        END IF
        DISPLAY BY NAME g_pnu.pnuacti
    END IF
    CLOSE t602_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t602_r()
    IF cl_null(g_pnu.pnu01) OR cl_null(g_pnu.pnu02)THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    IF g_pnu.pnuacti = 'N' THEN
       CALL cl_err('',9027,0)
	RETURN
    END IF
    IF g_pnu.pnuconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    BEGIN WORK
 
    OPEN t602_cl USING g_pnu.pnu01,g_pnu.pnu02
    IF STATUS THEN
       CALL cl_err("OPEN t602_cl:", STATUS, 0)
       CLOSE t602_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t602_cl INTO g_pnu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,0)
       RETURN
    END IF
    
    CALL t602_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pnu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "pnu02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pnu.pnu01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_pnu.pnu02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM pnu_file WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02
       CLEAR FORM
       OPEN t602_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t602_cs
          CLOSE t602_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH t602_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t602_cs
          CLOSE t602_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t602_cs
       IF g_row_count > 0 THEN
        IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t602_fetch('L')
        ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL t602_fetch('/')
        END IF
       END IF
    END IF
    CLOSE t602_cl
    COMMIT WORK
END FUNCTION
 
 
FUNCTION t602_y()
DEFINE l_cnt  LIKE type_file.num5
DEFINE l_afbacti LIKE afb_file.afbacti    #FUN-D70090
DEFINE l_msg      LIKE type_file.chr1000  #FUN-D70090        
 
   IF cl_null(g_pnu.pnu01) OR cl_null(g_pnu.pnu02) THEN 
        CALL cl_err('','apj-003',0) 
        RETURN 
   END IF
   
   IF g_pnu.pnuacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_pnu.pnuconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
#FUN-D70090 --begin   
   SELECT afbacti INTO l_afbacti FROM afb_file
    WHERE afb00 = g_pnu.pnu037    # 帐别编号                                       
      AND afb01 = g_pnu.pnu031    # 预算项目                                       
      AND afb02 = g_pnu.pnu032    # 科目编号                                        
      AND afb03 = g_pnu.pnu034    # 会计年度                                        
      AND afb04 = g_pnu.pnu036    # 以何为单位维护之(1.期/2.季/3.年)                                         
      AND afb041= g_pnu.pnu033    # 部门编号                                        
      AND afb042= g_pnu.pnu038    # 专案代号
      
   IF l_afbacti='N' THEN
      LET l_msg = 'aglt600 :',
                  g_pnu.pnu037,'/',
                  g_pnu.pnu032,'/',
                  g_pnu.pnu033,'/',
                  g_pnu.pnu031,'/',
                  g_pnu.pnu038,'/',
                  g_pnu.pnu036,'/',
                  g_pnu.pnu034       
      CALL cl_err(l_msg,'mfg1000',0)
      RETURN 
   END IF      
#FUN-D70090 --end  
   
   IF NOT cl_confirm('axm-108') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t602_cl USING g_pnu.pnu01,g_pnu.pnu02
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE t602_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t602_cl INTO g_pnu.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,0)      
      CLOSE t602_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE pnu_file SET pnuconf = 'Y'  WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02   #No.TQC-9A0157
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pnu_file",g_pnu.pnu01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pnu_file",g_pnu.pnu01,"","9050","","",1) 
         LET g_success = 'N'
      ELSE
         UPDATE afc_file SET afc09 = COALESCE(afc09,0) + g_pnu.pnu04 WHERE afc00 = g_pnu.pnu037 AND afc01 = g_pnu.pnu031
                                                  AND afc02 = g_pnu.pnu032 AND afc03 = g_pnu.pnu034
                                                  AND afc04 = g_pnu.pnu036 AND afc041 = g_pnu.pnu033 
                                                  AND afc042 = g_pnu.pnu038 AND afc05 = g_pnu.pnu035
        IF SQLCA.sqlcode  THEN    
           CALL cl_err3("upd","afc_file",g_pnu.pnu01,"",SQLCA.sqlcode,"","",1)
           LET g_success = 'N'
        ELSE
         CASE  
            WHEN g_pnu.pnu035 MATCHES '[123]' 
                 LET l_tmp='afb11'
            WHEN g_pnu.pnu035 MATCHES '[456]'
                 LET l_tmp='afb12'
             WHEN g_pnu.pnu035 MATCHES '[789]'                                                                                                   
                 LET l_tmp='afb13'
             WHEN g_pnu.pnu035 MATCHES '10' OR '11' OR '12' OR '13'                                                                                                    
                 LET l_tmp='afb14'
         END CASE
         LET g_sql = "UPDATE afb_file SET afb10 = afb10 + ",g_pnu.pnu04,",",l_tmp CLIPPED," = ",l_tmp CLIPPED,"+",g_pnu.pnu04,
                     " WHERE afb00 = '",g_pnu.pnu037,"' AND afb01 = '",g_pnu.pnu031,                 
                     "' AND afb02 ='", g_pnu.pnu032,"' AND afb03 = '",g_pnu.pnu034,                                 
                     "' AND afb04 ='", g_pnu.pnu036,"' AND afb041 ='", g_pnu.pnu033,                                
                     "' AND afb042 ='", g_pnu.pnu038,"'"   
         PREPARE is FROM g_sql
         EXECUTE is
 
         IF SQLCA.sqlcode  THEN                                                                                                      
           CALL cl_err3("upd","afb_file",g_pnu.pnu01,"",SQLCA.sqlcode,"","",1)                                                      
           LET g_success = 'N' 
         ELSE      
           CALL t602_pnu035('d')
           LET g_pnu.pnuconf = 'Y'
           DISPLAY BY NAME g_pnu.pnuconf
         END IF
      END IF
   END IF
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t602_z()
 
   IF cl_null(g_pnu.pnu01) OR cl_null(g_pnu.pnu02) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
 
   IF g_pnu.pnuacti='N' THEN
        CALL cl_err('','atm-365',0)
        RETURN
   END IF
   
   IF g_pnu.pnuconf = 'N' THEN
      CALL cl_err('','9002',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t602_cl USING g_pnu.pnu01,g_pnu.pnu02
   IF STATUS THEN
      CALL cl_err("OPEN i700_cl:", STATUS, 1)
      CLOSE t602_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t602_cl INTO g_pnu.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pnu.pnu01,SQLCA.sqlcode,0)     
      CLOSE t602_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE pnu_file SET pnuconf = 'N'  WHERE pnu01 = g_pnu.pnu01 AND pnu02 = g_pnu.pnu02   #No.TQC-9A0157
   IF SQLCA.sqlcode  THEN
     
      CALL cl_err3("upd","pnu_file",g_pnu.pnu01,"",STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         
         CALL cl_err3("upd","pnu_file",g_pnu.pnu01,"","9053","","",1) 
         LET g_success = 'N'
      ELSE
         UPDATE afc_file SET afc09 = COALESCE(afc09,0) - g_pnu.pnu04 WHERE afc00 = g_pnu.pnu037 AND afc01 = g_pnu.pnu031
                                                  AND afc02 = g_pnu.pnu032 AND afc03 = g_pnu.pnu034
                                                  AND afc04 = g_pnu.pnu036 AND afc041 = g_pnu.pnu033 
                                                  AND afc042 = g_pnu.pnu038 AND afc05 = g_pnu.pnu035
         IF SQLCA.sqlcode  THEN   
            CALL cl_err3("upd","afc_file",g_pnu.pnu01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         ELSE
         CASE  
            WHEN g_pnu.pnu035 MATCHES '[123]' 
                 LET l_tmp='afb11'
            WHEN g_pnu.pnu035 MATCHES '[456]'
                 LET l_tmp='afb12'
             WHEN g_pnu.pnu035 MATCHES '[789]'                                                                                                   
                 LET l_tmp='afb13'
             WHEN g_pnu.pnu035 MATCHES '10' OR '11' OR '12' OR '13'                                                                                                    
                 LET l_tmp='afb14'
         END CASE
         LET g_sql = "UPDATE afb_file SET afb10 = afb10 - ",g_pnu.pnu04,",",l_tmp CLIPPED," = ",l_tmp CLIPPED,"-",g_pnu.pnu04,
                     " WHERE afb00 = '",g_pnu.pnu037,"' AND afb01 = '",g_pnu.pnu031,                 
                     "' AND afb02 ='", g_pnu.pnu032,"' AND afb03 = '",g_pnu.pnu034,                                 
                     "' AND afb04 ='", g_pnu.pnu036,"' AND afb041 ='", g_pnu.pnu033,                                
                     "' AND afb042 ='", g_pnu.pnu038,"'"   
         PREPARE iu FROM g_sql
         EXECUTE iu
 
         IF SQLCA.sqlcode  THEN                                                                                                      
           CALL cl_err3("upd","afb_file",g_pnu.pnu01,"",SQLCA.sqlcode,"","",1)                                                      
           LET g_success = 'N' 
         ELSE
          CALL t602_pnu035('d')          
          LET g_pnu.pnuconf = 'N'
          DISPLAY BY NAME g_pnu.pnuconf
         END IF
      END IF
   END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t602_out()
 
 DEFINE l_wc  STRING          
 
    IF cl_null(g_wc)  THEN LET g_wc=" pnu01='",g_pnu.pnu01,"' AND pnu02 = '",g_pnu.pnu02,"'" END IF  #TQC-970200 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    
    LET g_sql="SELECT DISTINCT pnu01,pnu02,pnu031,pnu032,pnu033,pnu034,pnu035,pnu036,",
              "pnu037,pnu038,pnu04,pnuconf,COALESCE(afc06,0) afc06_1,COALESCE(afc08,0) afc08_1,COALESCE(afc09,0) afc09_1,",
              "COALESCE((afc06+afc08+afc09),0) afc_tot_1,aag02,gem02,azf03,pja02",
              " FROM  aag_file,gem_file,azf_file,pja_file,",
              " pnu_file LEFT JOIN afc_file ON afc00 = pnu037 AND afc01 = pnu031",
              " AND afc02 = pnu032 AND afc03 = pnu034 AND afc04 = pnu036 ",
              " AND afc041 = pnu033 AND afc042 = pnu038 AND afc05 = pnu035",
              " WHERE aag00 = pnu037 AND aag01 = pnu032 AND aag03 = '2' ",
              " AND aag07 IN ('2','3') AND aagacti = 'Y' AND gem01 = pnu033",
              " AND gemacti = 'Y' AND azf01 = pnu031 AND azf02 = '2' AND azfacti = 'Y'",
              " AND pja01 = pnu038 AND pjaacti = 'Y' AND ",g_wc CLIPPED 
 
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'pnu01,pnu02,pnu031,pnu032,pnu033,pnu034,pnu035,pnu036,pnu037,pnu038,pnu04,pnuconf')                 
            RETURNING l_wc
    ELSE
       LET l_wc = ' '
    END IF
    LET g_str = l_wc
    CALL cl_prt_cs1('aglt602','aglt602',g_sql,g_str)
   
END FUNCTION
#No.FUN-9C0072 精簡程式碼

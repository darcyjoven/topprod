# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglt601.4gl
# Descriptions...: 預算挪用維護作業
# Date & Author..: FUN-810069 2008/03/03 By shiwuying
# Modify.........: No.FUN-840002 08/04/03 By shiwuying 審核(取消審核)時更新年度預算和相應季度預算(afb_file)
# Modify.........: No.TQC-840018 08/04/08 By shiwuying 項目編號/WBS編碼/活動編號 BY aoos010(aza08='N')參數隱藏
# Modify.........: No.FUN-850027 08/05/29 By douzh WBS編碼錄入時要求時尾階并且為成本對象的WBS編碼
# Modify.........: No.FUN-930106 09/03/17 By destiny pnt031/pnt041預算項目字段增加管控
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-950077 09/05/22 By dongbg 預算項目統一為費用原因/預算項目 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 增加"專案未結案"的判斷
# Modify.........: No.TQC-9A0157 09/10/27 By wujie     show中的display报错
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-AA0134 10/10/22 by Dido 挪用金額不可超過總預算 
# Modify.........: No.MOD-AB0102 10/11/11 by Dido 預算值需帶出已耗部分,並檢核是否超出總預算 
# Modify.........: No.MOD-AC0009 10/12/01 By wujie  aglt601科目编号pnt032开窗挑选只作预算的科目aag21='Y'， aag07<>'1'
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-C50108 12/05/22 By Polly 挪用預算需考慮會科是否有總額控制
# Modify.........: No.MOD-C50147 12/05/23 By Polly 上傳相關文件，增加key條件抓取 
# Modify.........: No.MOD-C70180 12/07/17 By Polly 總額控制時，原始預算金額和總預算金額以年度方式顯示
# Modify.........: No.MOD-C80054 12/08/09 By Polly 挪用金額考慮在已存在於挪用單且相同預算科目且未確認的金額
# Modify.........: No.MOD-CA0192 12/10/30 By Polly 調整預算檢查錯誤時，回到pnt037欄位重新輸入
# Modify.........: No.FUN-D70090 13/07/18 By fengmy aglt600无效预算不可挪用

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pnt                 RECORD LIKE pnt_file.*,
       g_pnt_t               RECORD LIKE pnt_file.*,  #備份舊值硉
       g_pnt01_t             LIKE  pnt_file.pnt01,    #KEY值備份
       g_pnt02_t             LIKE  pnt_file.pnt02,
       g_wc                  STRING,                  #存儲user的查詢條件
       g_sql                 STRING                  #組sql用 蚚
DEFINE   g_str               STRING
DEFINE   l_table             STRING
DEFINE g_forupd_sql          STRING                   #SELECT ...FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5      #判斷是否已執行BeforeInput指令
 
DEFINE g_chr                 LIKE pnt_file.pntacti        
DEFINE g_cnt                 LIKE type_file.num10         
DEFINE g_i                   LIKE type_file.num5          
DEFINE g_msg                 LIKE type_file.chr1000      
DEFINE g_curs_index          LIKE type_file.num10      
DEFINE g_row_count           LIKE type_file.num10        
DEFINE g_jump                LIKE type_file.num10       
DEFINE mi_no_ask             LIKE type_file.num5          
 
DEFINE g_pjz02               LIKE pjz_file.pjz02
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5           
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                                   #截取中斷鍵
  
    IF (NOT cl_user()) THEN                           #預設部分參數(g_prog,g_user,...)
      EXIT PROGRAM                                    #切換成用戶預設的運營中心笢陑
    END IF 
    
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   
   LET g_sql = " pnt01.pnt_file.pnt01,",
               " pnt02.pnt_file.pnt02,",
               " pntconf.pnt_file.pntconf,",
               " pnt037.pnt_file.pnt037,",
               " pnt032.pnt_file.pnt032,",
               " pnt033.pnt_file.pnt033,",
               " pnt031.pnt_file.pnt031,",
               " pnt038.pnt_file.pnt038,",
               " pnt036.pnt_file.pnt036,",
               " pnt034.pnt_file.pnt034,",
               " pnt035.pnt_file.pnt035,",
               " pnt047.pnt_file.pnt047,",
               " pnt042.pnt_file.pnt042,",
               " pnt043.pnt_file.pnt043,",
               " pnt041.pnt_file.pnt041,",
               " pnt048.pnt_file.pnt048,",
               " pnt046.pnt_file.pnt046,",
               " pnt044.pnt_file.pnt044,",
               " pnt045.pnt_file.pnt045,",
               " pnt05.pnt_file.pnt05,",
               " aag02.aag_file.aag02,",
               " gem02.gem_file.gem02,",
               " azf03.azf_file.azf03,",
               " pja02.pja_file.pja02,",
               " aag02_1.aag_file.aag02,",
               " gem02_1.gem_file.gem02,",
               " azf03_1.azf_file.azf03,",
               " pja02_1.pja_file.pja02,",
               " afc06_1.afc_file.afc06,",
               " afc08_1.afc_file.afc08,",
               " afc09_1.afc_file.afc09,",
               " afc_tot_1.afc_file.afc09,",
               " afc06_2.afc_file.afc06,",
               " afc08_2.afc_file.afc08,",
               " afc09_2.afc_file.afc09,",
               " afc_tot_2.afc_file.afc09"
   LET l_table = cl_prt_temptable('axct001',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
    
   INITIALIZE g_pnt.* TO NULL
   LET g_forupd_sql = "SELECT * FROM pnt_file WHERE pnt01 = ?  AND pnt02 = ?  FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t601_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t601 AT p_row,p_col WITH FORM "agl/42f/aglt601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)              
 
   CALL cl_ui_init()
 
#No.TQC-840018----------------start-----------------------
   IF g_aza.aza08='N' THEN
      CALL cl_set_comp_visible("pnt038,pnt036,pnt048,pnt046,pja02,pja02_1",FALSE)
   END IF
#No.TQC-840018-----------------end------------------------
 
   LET g_action_choice = ""
   CALL t601_menu()
 
   CLOSE WINDOW t601
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time       
END MAIN
 
FUNCTION t601_cs()
    DEFINE ls      STRING
    CLEAR FORM
    CONSTRUCT BY NAME g_wc ON                               #取條件
        pnt01,pnt02,pntconf,
        pnt037,pnt032,pnt033,pnt031,pnt038,pnt036,pnt034,pnt035,
        pnt047,pnt042,pnt043,pnt041,pnt048,pnt046,pnt044,pnt045,
        pnt05,
        pntuser,pntgrup,pntmodu,pntdate,pntacti
             
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE
              WHEN INFIELD(pnt032)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt032
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt032
	         NEXT FIELD pnt032
                 
              WHEN INFIELD(pnt033)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt033
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt033
	         NEXT FIELD pnt033
                 
              WHEN INFIELD(pnt031)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"                     #No.FUN-930106
                 LET g_qryparam.form = "q_azf01a"                  #No.FUN-930106
                 LET g_qryparam.state = "c"  
                #LET g_qryparam.arg1 = '2'                         #No.FUN-930106
                #LET g_qryparam.arg1 = '9'                         #No.FUN-930106
                 LET g_qryparam.arg1 = '7'                         #No.FUN-950077
                 LET g_qryparam.default1 = g_pnt.pnt031
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt031
	         NEXT FIELD pnt031
                 
              WHEN INFIELD(pnt038)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt038
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt038
	         NEXT FIELD pnt038
                 
              WHEN INFIELD(pnt036)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt036
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt036
	         NEXT FIELD pnt036
                 
              WHEN INFIELD(pnt042)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt042
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt042
	         NEXT FIELD pnt042
                 
              WHEN INFIELD(pnt043)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt043
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt043
	         NEXT FIELD pnt043
                 
              WHEN INFIELD(pnt041)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"            #No.FUN-930106
                 LET g_qryparam.form = "q_azf01a"         #No.FUN-930106
                 LET g_qryparam.state = "c"
                #LET g_qryparam.arg1 = '2'                #No.FUN-930106
                #LET g_qryparam.arg1 = '9'                #No.FUN-930106
                 LET g_qryparam.arg1 = '7'                #No.FUN-950077
                 LET g_qryparam.default1 = g_pnt.pnt041
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt041
	         NEXT FIELD pnt041
                 
              WHEN INFIELD(pnt048)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt048
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt048
	         NEXT FIELD pnt048
                 
              WHEN INFIELD(pnt046)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_pnt.pnt046
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pnt046
	         NEXT FIELD pnt046
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
    #        LET g_wc = g_wc clipped," AND pntuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN   
    #        LET g_wc = g_wc clipped," AND pntgrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN 
    #        LET g_wc = g_wc clipped," AND pntgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pntuser', 'pntgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT pnt01,pnt02 FROM pnt_file ", 
        " WHERE ",g_wc CLIPPED, " ORDER BY pnt01,pnt02"
    PREPARE t601_prepare FROM g_sql
    DECLARE t601_cs SCROLL CURSOR WITH HOLD FOR t601_prepare    # SCROLL CURSOR
        
    LET g_sql="SELECT COUNT(*) FROM pnt_file WHERE ",g_wc CLIPPED
    PREPARE t601_precount FROM g_sql
    DECLARE t601_count CURSOR FOR t601_precount
END FUNCTION
 
FUNCTION t601_menu()
DEFINE l_cmd  LIKE type_file.chr1000      
    MENU ""
      BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
               
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t601_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN              
		CALL t601_q()
            END IF
        ON ACTION next
            CALL t601_fetch('N')
        ON ACTION previous
            CALL t601_fetch('P')
        ON ACTION modify
           LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t601_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t601_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t601_r()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t601_fetch('/')
        ON ACTION first
            CALL t601_fetch('F')
        ON ACTION last
            CALL t601_fetch('L')
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
 
        ON ACTION output
	   LET g_action_choice="output"
	   IF cl_chk_act_auth() THEN
		CALL t601_out()
	   END IF
        ON ACTION confirm               #確認 
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
                CALL t601_y()
           END IF 
        ON ACTION undo_confirm             #取消確認�
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t601_z()
            END IF
       ON ACTION related_document
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_pnt.pnt01 IS NOT NULL THEN
                LET g_doc.column1="pnt01"
                LET g_doc.column1="pnt02"       #MOD-C50147 add
                LET g_doc.value1=g_pnt.pnt01
                LET g_doc.value1=g_pnt.pnt02    #MOD-C50147 add
                CALL cl_doc()
             END IF
          END IF   
    END MENU
    CLOSE t601_cs
END FUNCTION
 
 
FUNCTION t601_a()
    MESSAGE ""
    CLEAR FORM                                   
    INITIALIZE g_pnt.* LIKE pnt_file.*
    LET g_pnt01_t = NULL
    LET g_pnt02_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_pnt.pntuser = g_user
        LET g_pnt.pntoriu = g_user #FUN-980030
        LET g_pnt.pntorig = g_grup #FUN-980030
        LET g_pnt.pntgrup = g_grup            
        LET g_pnt.pntdate = g_today
        LET g_pnt.pntacti = 'Y'
        LET g_pnt.pntconf = 'N'
        LET g_pnt.pnt01 = g_today
        LET g_pnt.pnt037 = g_aza.aza81
        LET g_pnt.pnt034 = YEAR(g_today)
        LET g_pnt.pnt035 = MONTH(g_today)
        LET g_pnt.pnt047 = g_aza.aza81
        LET g_pnt.pnt044 = YEAR(g_today)
        LET g_pnt.pnt045 = MONTH(g_today)
        LET g_pnt.pnt05 = 0       
 
        CALL t601_i("a")                         
        IF INT_FLAG THEN                         
            INITIALIZE g_pnt.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_pnt.pnt01 IS NULL THEN              
            CONTINUE WHILE
        END IF
        INSERT INTO pnt_file VALUES(g_pnt.*)    
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pnt_file",g_pnt.pnt01,"",SQLCA.sqlcode,"","",0)   
            CONTINUE WHILE
        ELSE
           SELECT pnt01,pnt02 INTO g_pnt.pnt01,g_pnt.pnt02 FROM pnt_file
            WHERE pnt01 = g_pnt.pnt01
              AND pnt02 = g_pnt.pnt02
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t601_pnt032(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1          
DEFINE l_aag02    LIKE aag_file.aag02
DEFINE l_aagacti  LIKE aag_file.aagacti
 
   LET g_errno=''
   SELECT aag02,aagacti
     INTO l_aag02,l_aagacti
     FROM aag_file
    WHERE aag01 = g_pnt.pnt032
      AND aag00 = g_pnt.pnt037
      AND aag03 = '2'
      AND aag07 IN ('2','3')
      AND aag21 ='Y'   #No.MOD-AC0009 

   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-916'
                                LET l_aag02=NULL
       WHEN l_aagacti='N'       LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_aag02 TO FORMONLY.aag02
   END IF       
END FUNCTION
 
FUNCTION t601_pnt033(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1         
DEFINE l_gem02    LIKE gem_file.gem02
DEFINE l_gemacti  LIKE gem_file.gemacti
 
   LET g_errno=''
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti
     FROM gem_file
     WHERE gem01=g_pnt.pnt033
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-003'
                                LET l_gem02=NULL
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gem02 TO FORMONLY.gem02  
   END IF     
END FUNCTION
 
FUNCTION t601_pnt031(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1        
DEFINE l_azf03    LIKE azf_file.azf03
DEFINE l_azfacti  LIKE azf_file.azfacti
DEFINE l_azf09    LIKE azf_file.azf09               #No.FUN-930106
 
   LET g_errno=''
  #SELECT azf03,azfacti                             #No.FUN-930106
   SELECT azf03,azfacti,azf09                       #No.FUN-930106     
    #INTO l_azf03,l_azfacti                         #No.FUN-930106  
     INTO l_azf03,l_azfacti,l_azf09                 #No.FUN-930106 
     FROM azf_file
    WHERE azf01=g_pnt.pnt031
      AND azf02='2'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-957'
                                LET l_azf03=NULL
       WHEN l_azfacti='N'       LET g_errno='9028'
      #WHEN l_azf09 !='9'       LET g_errno='aoo-408'  #No.FUN-930106
       WHEN l_azf09 !='7'       LET g_errno='aoo-406'  #No.FUN-950077
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azf03 TO FORMONLY.azf03
   END IF
END FUNCTION
 
FUNCTION t601_pnt038(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1         
DEFINE l_pjaacti  LIKE pja_file.pjaacti
DEFINE l_pja02    LIKE pja_file.pja02
DEFINE l_pjaclose LIKE pja_file.pjaclose                #No.FUN-960038
   
   LET g_errno=''
   SELECT pja02,pjaacti,pjaclose                        #No.FUN-960038 ADD pjaclose
     INTO l_pja02,l_pjaacti,l_pjaclose                  #No.FUN-960038 ADD l_pjaclose
     FROM pja_file
     WHERE pja01=g_pnt.pnt038
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-005'
                                LET l_pja02=NULL                              
       WHEN l_pjaacti='N'       LET g_errno='9028'
       WHEN l_pjaclose='Y'      LET g_errno='abg-503'    #No.FUN-960038
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pja02 TO FORMONLY.pja02
   END IF
END FUNCTION
 
FUNCTION t601_pnt042(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1          
DEFINE l_aag02    LIKE aag_file.aag02
DEFINE l_aagacti  LIKE aag_file.aagacti
 
   LET g_errno=''
   SELECT aag02,aagacti
     INTO l_aag02,l_aagacti
     FROM aag_file
    WHERE aag01 = g_pnt.pnt042
      AND aag00 = g_pnt.pnt047
      AND aag03 = '2'
      AND aag07 IN ('2','3')
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-916'
                                LET l_aag02=NULL
       WHEN l_aagacti='N'       LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_aag02 TO FORMONLY.aag02_1
   END IF       
END FUNCTION
 
FUNCTION t601_pnt043(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1         
DEFINE l_gem02    LIKE gem_file.gem02
DEFINE l_gemacti  LIKE gem_file.gemacti
 
   LET g_errno=''
   SELECT gem02,gemacti
     INTO l_gem02,l_gemacti
     FROM gem_file
     WHERE gem01=g_pnt.pnt043
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-003'
                                LET l_gem02=NULL
       WHEN l_gemacti='N'       LET g_errno='9028'
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gem02 TO FORMONLY.gem02_1  
   END IF     
END FUNCTION
 
FUNCTION t601_pnt041(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1        
DEFINE l_azf03    LIKE azf_file.azf03
DEFINE l_azfacti  LIKE azf_file.azfacti
DEFINE l_azf09    LIKE azf_file.azf09        #No.FUN-930106
 
   LET g_errno=''
  #SELECT azf03,azfacti                      #No.FUN-930106
   SELECT azf03,azfacti,azf09                #No.FUN-930106
    #INTO l_azf03,l_azfacti                  #No.FUN-930106
     INTO l_azf03,l_azfacti,l_azf09          #No.FUN-930106 
     FROM azf_file
    WHERE azf01=g_pnt.pnt041
      AND azf02='2'
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-957'
                                LET l_azf03=NULL
       WHEN l_azfacti='N'       LET g_errno='9028'
      #WHEN l_azf09 !='9'       LET g_errno='aoo-408'  #FUN-950077 mark 
       WHEN l_azf09 !='7'       LET g_errno='aoo-406'  #FUN-950077 add 
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_azf03 TO FORMONLY.azf03_1
   END IF
END FUNCTION
 
FUNCTION t601_pnt048(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1         
DEFINE l_pjaacti  LIKE pja_file.pjaacti
DEFINE l_pja02    LIKE pja_file.pja02
DEFINE l_pjaclose LIKE pja_file.pjaclose      #No.FUN-960038
   
   LET g_errno=''
   SELECT pja02,pjaacti,pjaclose              #No.FUN-960038 add pjaclose
     INTO l_pja02,l_pjaacti,l_pjaclose        #No.FUN-960038 add l_pjaclose
     FROM pja_file
     WHERE pja01=g_pnt.pnt048
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='apj-005'
                                LET l_pja02=NULL                              
       WHEN l_pjaacti='N'       LET g_errno='9028'
       WHEN l_pjaclose='Y'      LET g_errno='abg-503'     #No.FUN-960038
       OTHERWISE                LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_pja02 TO FORMONLY.pja02_1
   END IF
END FUNCTION
 
FUNCTION t601_pnt035(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,          
        l_afc06_1  LIKE afc_file.afc06,
        l_afc08_1  LIKE afc_file.afc08,
        l_afc09_1  LIKE afc_file.afc09,
        l_afc_tot_1 LIKE afc_file.afc06,
        l_afb18_1   LIKE afb_file.afb18        #MOD-C50108 add
       
   LET g_errno=''
#No.TQC-840018-----start---------
   IF g_aza.aza08='N' THEN                                                      
      LET g_pnt.pnt036 = ' '                                                   
      LET g_pnt.pnt038 = ' '                                                   
   END IF
#No.TQC-840018------end----------
  #-----------------MOD-C50108------------(S)
   SELECT afb18 INTO l_afb18_1                       
     FROM afb_file
    WHERE afb00 = g_pnt.pnt037
      AND afb01 = g_pnt.pnt031
      AND afb02 = g_pnt.pnt032
      AND afb03 = g_pnt.pnt034
      AND afb04 = g_pnt.pnt036
      AND afb041= g_pnt.pnt033
      AND afb042= g_pnt.pnt038
  #-----------------MOD-C50108------------(E)
  #------------------MOD-CA0192-----------(S)
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-958'
                                LET l_afc06_1 = NULL
                                LET l_afc08_1 = NULL
                                LET l_afc09_1 = NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
  #------------------MOD-CA0192-----------(E)
   IF l_afb18_1 = 'N' THEN                          #MOD-C70180 add
       SELECT afc06,afc08,afc09 
         INTO l_afc06_1,l_afc08_1,l_afc09_1
         FROM afc_file WHERE afc00 = g_pnt.pnt037
                         AND afc01 = g_pnt.pnt031
                         AND afc02 = g_pnt.pnt032
                         AND afc03 = g_pnt.pnt034
                         AND afc04 = g_pnt.pnt036
                         AND afc041= g_pnt.pnt033
                         AND afc042= g_pnt.pnt038
                         AND afc05 = g_pnt.pnt035   
  #-------------------------MOD-C70180------------------(S)
   ELSE                                             
       SELECT SUM(afc06),SUM(afc08),SUM(afc09)        
         INTO l_afc06_1,l_afc08_1,l_afc09_1
         FROM afc_file WHERE afc00 = g_pnt.pnt037
                         AND afc01 = g_pnt.pnt031
                         AND afc02 = g_pnt.pnt032
                         AND afc03 = g_pnt.pnt034
                         AND afc04 = g_pnt.pnt036
                         AND afc041= g_pnt.pnt033
                         AND afc042= g_pnt.pnt038
   END IF 
  #-------------------------MOD-C70180------------------(E)
  #------------------MOD-CA0192---------mark
  #CASE
  #    WHEN SQLCA.sqlcode=100   LET g_errno='agl-958'
  #                             LET l_afc06_1 = NULL
  #                             LET l_afc08_1 = NULL
  #                             LET l_afc09_1 = NULL
  #    OTHERWISE
  #         LET g_errno=SQLCA.sqlcode USING '------'
  #END CASE
  #------------------MOD-CA0192---------mark
   IF p_cmd='d' OR cl_null(g_errno)THEN
      IF cl_null(g_pnt.pnt05) THEN 
         LET g_pnt.pnt05 = 0 
      END IF
      IF cl_null(l_afc06_1) THEN LET l_afc06_1 = 0 END IF                       
      IF cl_null(l_afc08_1) THEN LET l_afc08_1 = 0 END IF                       
      IF cl_null(l_afc09_1) THEN LET l_afc09_1 = 0 END IF
      IF p_cmd='a' THEN                                                            
         LET l_afc08_1 = l_afc08_1 - g_pnt.pnt05                                   
      END IF 
      LET l_afc_tot_1 = l_afc06_1 + l_afc08_1 + l_afc09_1
     #-MOD-AA0134-add-
      IF l_afb18_1 = 'N' THEN            #MOD-C50108 add
         IF l_afc_tot_1 < 0 THEN
            LET g_errno='agl-198' 
         END IF 
      END IF                             #MOD-C50108 add
     #-MOD-AA0134-end- 
      DISPLAY l_afc06_1 TO FORMONLY.afc06_1
      DISPLAY l_afc08_1 TO FORMONLY.afc08_1
      DISPLAY l_afc09_1 TO FORMONLY.afc09_1
      DISPLAY l_afc_tot_1 TO FORMONLY.afc_tot_1
   END IF
END FUNCTION
 
FUNCTION t601_pnt045(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,          
        l_afc06_2  LIKE afc_file.afc06,
        l_afc08_2  LIKE afc_file.afc08,
        l_afc09_2  LIKE afc_file.afc09,
        l_afc_tot_2 LIKE afc_file.afc06
        
   LET g_errno=''
#No.TQC-840018-----start---------                                                  
   IF g_aza.aza08='N' THEN                                                      
      LET g_pnt.pnt046 = ' '                                                   
      LET g_pnt.pnt048 = ' '                                                   
   END IF                                                                       
#No.TQC-840018------end----------
   SELECT afc06,afc08,afc09 
     INTO l_afc06_2,l_afc08_2,l_afc09_2
     FROM afc_file WHERE afc00 = g_pnt.pnt047
                     AND afc01 = g_pnt.pnt041
                     AND afc02 = g_pnt.pnt042
                     AND afc03 = g_pnt.pnt044
                     AND afc04 = g_pnt.pnt046
                     AND afc041= g_pnt.pnt043
                     AND afc042= g_pnt.pnt048
                     AND afc05 = g_pnt.pnt045
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='agl-958'
                                LET l_afc06_2 = NULL
                                LET l_afc08_2 = NULL
                                LET l_afc09_2 = NULL
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno) THEN
      IF cl_null(g_pnt.pnt05) THEN LET g_pnt.pnt05 = 0 END IF
      IF cl_null(l_afc06_2) THEN LET l_afc06_2 = 0 END IF                       
      IF cl_null(l_afc08_2) THEN LET l_afc08_2 = 0 END IF                       
      IF cl_null(l_afc09_2) THEN LET l_afc09_2 = 0 END IF
      IF p_cmd='a' THEN                                                            
         LET l_afc08_2 = l_afc08_2 + g_pnt.pnt05                                   
      END IF
      LET l_afc_tot_2 = l_afc06_2 + l_afc08_2 + l_afc09_2
      DISPLAY l_afc06_2 TO FORMONLY.afc06_2
      DISPLAY l_afc08_2 TO FORMONLY.afc08_2
      DISPLAY l_afc09_2 TO FORMONLY.afc09_2
      DISPLAY l_afc_tot_2 TO FORMONLY.afc_tot_2
   END IF
END FUNCTION
 
FUNCTION t601_i(p_cmd)
   DEFINE   p_cmd       LIKE type_file.chr1          
   DEFINE   l_afc06_1   LIKE afc_file.afc06
   DEFINE   l_afc08_1   LIKE afc_file.afc08
   DEFINE   l_afc09_1   LIKE afc_file.afc09
   DEFINE   l_afc_tot_1 LIKE afc_file.afc09
   DEFINE   l_afc06_2   LIKE afc_file.afc06
   DEFINE   l_afc08_2   LIKE afc_file.afc08
   DEFINE   l_afc09_2   LIKE afc_file.afc09
   DEFINE   l_afc_tot_2 LIKE afc_file.afc09
   DEFINE   l_input     LIKE type_file.chr1          
   DEFINE   l_n         LIKE type_file.num5
   DEFINE   l_cnt       LIKE type_file.num5
   DEFINE   l_msg       LIKE type_file.chr1000
   DEFINE   l_pjb09     LIKE pjb_file.pjb09   #No.FUN-850027 
   DEFINE   l_pjb11     LIKE pjb_file.pjb11   #No.FUN-850027
   DEFINE   l_bamt1     LIKE afc_file.afc07   #MOD-AB0102
   DEFINE   l_bamt2     LIKE afc_file.afc07   #MOD-AB0102
   DEFINE   l_bamt3     LIKE afc_file.afc07   #MOD-AB0102
   DEFINE   l_bamt4     LIKE afc_file.afc07   #MOD-AB0102
   DEFINE   l_bamt5     LIKE afc_file.afc07   #MOD-AB0102
   DEFINE   l_bamt6     LIKE afc_file.afc07   #MOD-AB0102
   DEFINE   l_chkpnt05  LIKE pnt_file.pnt05   #MOD-AB0102
   DEFINE   l_afb18     LIKE afb_file.afb18   #MOD-C50108 add
   DEFINE   l_pnt05     LIKE pnt_file.pnt05   #MOD-C80054 add
   
   DISPLAY BY NAME
      g_pnt.pnt01, g_pnt.pnt02,
      g_pnt.pnt037,g_pnt.pnt032,g_pnt.pnt033,g_pnt.pnt031,
      g_pnt.pnt038,g_pnt.pnt036,g_pnt.pnt034,g_pnt.pnt035,
      g_pnt.pnt047,g_pnt.pnt042,g_pnt.pnt043,g_pnt.pnt041,
      g_pnt.pnt048,g_pnt.pnt046,g_pnt.pnt044,g_pnt.pnt045,
      g_pnt.pnt05,g_pnt.pntuser,g_pnt.pntgrup,g_pnt.pntmodu,
      g_pnt.pntdate,g_pnt.pntacti  
  
   INPUT BY NAME g_pnt.pntoriu,g_pnt.pntorig,
      g_pnt.pnt01, g_pnt.pnt02,
      g_pnt.pnt037,g_pnt.pnt032,g_pnt.pnt033,g_pnt.pnt031,
      g_pnt.pnt038,g_pnt.pnt036,g_pnt.pnt034,g_pnt.pnt035,
      g_pnt.pnt047,g_pnt.pnt042,g_pnt.pnt043,g_pnt.pnt041,
      g_pnt.pnt048,g_pnt.pnt046,g_pnt.pnt044,g_pnt.pnt045,
      g_pnt.pnt05
      WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET l_input='N'
         LET g_before_input_done = FALSE
         CALL t601_set_entry(p_cmd)
         CALL t601_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
      AFTER FIELD pnt01
        #DISPLAY "AFTER FIELD pnt01"                                       #MOD-AB0102 mark
         IF NOT cl_null(g_pnt.pnt01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_pnt.pnt01 != g_pnt01_t) THEN
               SELECT count(*) INTO l_n FROM pnt_file WHERE pnt01 = g_pnt.pnt01
                                                        AND pnt02 = g_pnt.pnt02
               IF l_n > 0 THEN                  
                  CALL cl_err(g_pnt.pnt01,-239,1)
                  LET g_pnt.pnt01 = g_pnt01_t
                  DISPLAY BY NAME g_pnt.pnt01
                  NEXT FIELD pnt01
               END IF              
            END IF
         END IF
         
      BEFORE FIELD pnt02                        #default 序號                  
         IF cl_null(g_pnt.pnt02) THEN                                   
            SELECT max(pnt02)+1 INTO g_pnt.pnt02                       
              FROM pnt_file                                                    
             WHERE pnt01 = g_pnt.pnt01                                            
            IF cl_null(g_pnt.pnt02) THEN                                
               LET g_pnt.pnt02 = 1                                      
            END IF                                                              
         END IF 
 
      AFTER FIELD pnt02
        #DISPLAY "AFTER FIELD pnt02"                                       #MOD-AB0102 mark 
         IF NOT cl_null(g_pnt.pnt01) AND NOT cl_null(g_pnt.pnt02) THEN                             
            IF p_cmd = "a" OR                    
                  (p_cmd = "u" AND g_pnt.pnt02 != g_pnt02_t) THEN
               SELECT count(*) INTO l_n FROM pnt_file WHERE pnt01 = g_pnt.pnt01
                                                        AND pnt02 = g_pnt.pnt02
               IF l_n > 0 THEN                  
                  CALL cl_err(g_pnt.pnt01,-239,1)
                  LET g_pnt.pnt02 = g_pnt02_t
                  DISPLAY BY NAME g_pnt.pnt02
                  NEXT FIELD pnt02
               END IF              
            END IF   
         END IF
                                                                           
      AFTER FIELD pnt037
        #DISPLAY "AFTER FIELD pnt037"                                      #MOD-AB0102 mark
         IF NOT cl_null(g_pnt.pnt037) THEN
            SELECT count(*) INTO l_cnt FROM aaa_file WHERE aaa01 = g_pnt.pnt037
            IF l_cnt = 0 THEN                  
               LET l_msg = g_pnt.pnt037 clipped using '###&'
               CALL cl_err(l_msg,'agl-095',0)
               LET g_pnt.pnt037 = g_pnt_t.pnt037
               DISPLAY BY NAME g_pnt.pnt037
               NEXT FIELD pnt037
            END IF
         END IF              
       
    AFTER FIELD pnt032
      #DISPLAY "AFTER FIELD pnt032"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt032) THEN
          CALL t601_pnt032(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt032,g_errno,0)
            #Mod No.FUN-B10048
            #LET g_pnt.pnt032 = g_pnt_t.pnt032
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aag"
             LET g_qryparam.construct = 'N'
             LET g_qryparam.arg1 = g_pnt.pnt037
             LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21 ='Y' AND aag01 LIKE '",g_pnt.pnt032 CLIPPED,"%'"
             LET g_qryparam.default1 = g_pnt.pnt032
             CALL cl_create_qry() RETURNING g_pnt.pnt032
            #End Mod No.FUN-B10048
             DISPLAY BY NAME g_pnt.pnt032 
             NEXT FIELD pnt032
          END IF
       END IF 
       
    AFTER FIELD pnt033
      #DISPLAY "AFTER FIELD pnt033"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt033) THEN
          CALL t601_pnt033(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt033,g_errno,0)
             LET g_pnt.pnt033 = g_pnt_t.pnt033
             DISPLAY BY NAME g_pnt.pnt033 
             NEXT FIELD pnt033
          END IF
       ELSE LET g_pnt.pnt033 = ' '
       END IF 
    
    AFTER FIELD pnt031
      #DISPLAY "AFTER FIELD pnt031"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt031) THEN
          CALL t601_pnt031(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt031,g_errno,0)
             LET g_pnt.pnt031 = g_pnt_t.pnt031
             DISPLAY BY NAME g_pnt.pnt031 
             NEXT FIELD pnt031
          END IF
       END IF 
   
    AFTER FIELD pnt038
      #DISPLAY "AFTER FIELD pnt038"                                       #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt038) THEN
          CALL t601_pnt038(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt038,g_errno,0)
             LET g_pnt.pnt038 = g_pnt_t.pnt038
             DISPLAY BY NAME g_pnt.pnt038 
             NEXT FIELD pnt038
          END IF
       ELSE LET g_pnt.pnt038 = ' '  #No.TQC-840018
       END IF 
       
    AFTER FIELD pnt036
      #DISPLAY "AFTER FIELD pnt036"                                      #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt036) THEN
          SELECT count(*) INTO l_cnt FROM pjb_file WHERE pjb01 = g_pnt.pnt038
                                                     AND pjb02 = g_pnt.pnt036
          IF l_cnt = 0 THEN                  
             LET l_msg = g_pnt.pnt036 clipped using '###&'
             CALL cl_err(l_msg,'apj-060',0)
             LET g_pnt.pnt036 = g_pnt_t.pnt036
             DISPLAY BY NAME g_pnt.pnt036
             NEXT FIELD pnt036
#No.FUN-850027--begin
          ELSE
             SELECT pjb09,pjb11 INTO l_pjb09,l_pjb11 
              FROM pjb_file WHERE pjb01 = g_pnt.pnt038
               AND pjb02 = g_pnt.pnt036
               AND pjbacti = 'Y'            
             IF l_pjb09 != 'Y' OR l_pjb11 != 'Y' THEN
                CALL cl_err(g_pnt.pnt036,'apj-090',0)
                LET g_pnt.pnt036 = g_pnt_t.pnt036
                NEXT FIELD pnt036
             END IF
#No.FUN-850027--begin
          END IF
       ELSE
          LET g_pnt.pnt036 = ' '  #No.TQC-840018
       END IF  
            
    AFTER FIELD pnt035
      #DISPLAY "AFTER FIELD pnt035"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt035) THEN 
          SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=g_pnt.pnt034
          IF g_pnt.pnt035>0 THEN                                            
             IF g_azm.azm02 = '1' THEN                                     
                IF g_pnt.pnt035>12 THEN                                     
                   CALL cl_err('','mfg9287',0)                               
                   NEXT FIELD pnt035                                         
                END IF                                                      
             END IF                                                        
             IF g_azm.azm02 = '2' THEN                                        
                IF g_pnt.pnt035>13 THEN                                       
                   CALL cl_err('','mfg9288',0)                                
                   NEXT FIELD pnt035                                          
                END IF                                                        
             END IF                                                           
          ELSE                                                              
             CALL cl_err(g_pnt.pnt035,'agl-013',0)
             NEXT FIELD pnt035
          END IF
          CALL t601_pnt035('a') 
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('pnt035:',g_errno,0)
             LET g_pnt.pnt035 = g_pnt_t.pnt035
             DISPLAY BY NAME g_pnt.pnt035
            #NEXT FIELD pnt035                   #MOD-CA0192 mark
             NEXT FIELD pnt037                   #MOD-CA0192 add
          END IF
       END IF
       
   AFTER FIELD pnt047
        #DISPLAY "AFTER FIELD pnt047"                                        #MOD-AB0102 mark
         IF NOT cl_null(g_pnt.pnt047) THEN
            SELECT count(*) INTO l_cnt FROM aaa_file WHERE aaa01 = g_pnt.pnt047
            IF l_cnt = 0 THEN                  
               LET l_msg = g_pnt.pnt047 clipped using '###&'
               CALL cl_err(l_msg,'agl-095',0)
               LET g_pnt.pnt047 = g_pnt_t.pnt047
               DISPLAY BY NAME g_pnt.pnt047
               NEXT FIELD pnt047
            END IF
         END IF              
       
    AFTER FIELD pnt042
      #DISPLAY "AFTER FIELD pnt042"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt042) THEN
          CALL t601_pnt042(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt042,g_errno,0)
            #Mod No.FUN-B10048
            #LET g_pnt.pnt042 = g_pnt_t.pnt042
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_aag"
             LET g_qryparam.construct = 'N'
             LET g_qryparam.arg1 = g_pnt.pnt047
             LET g_qryparam.default1 = g_pnt.pnt042
             LET g_qryparam.where = " aag07 IN ('2','3') AND aag03='2' AND aagacti='Y' AND aag01 LIKE '",g_pnt.pnt042 CLIPPED,"%'"
             CALL cl_create_qry() RETURNING g_pnt.pnt042
            #End Mod No.FUN-B10048
             DISPLAY BY NAME g_pnt.pnt042 
             NEXT FIELD pnt042
          END IF
       END IF 
       
    AFTER FIELD pnt043
      #DISPLAY "AFTER FIELD pnt043"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt043) THEN
          CALL t601_pnt043(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt043,g_errno,0)
             LET g_pnt.pnt043 = g_pnt_t.pnt043
             DISPLAY BY NAME g_pnt.pnt043 
             NEXT FIELD pnt043
          END IF
       ELSE LET g_pnt.pnt043 = ' '
       END IF 
      
    AFTER FIELD pnt041
      #DISPLAY "AFTER FIELD pnt041"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt041) THEN
          CALL t601_pnt041(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt041,g_errno,0)
             LET g_pnt.pnt041 = g_pnt_t.pnt041
             DISPLAY BY NAME g_pnt.pnt041 
             NEXT FIELD pnt041
          END IF
       END IF 
 
    AFTER FIELD pnt048
      #DISPLAY "AFTER FIELD pnt048"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt048) THEN
          CALL t601_pnt048(p_cmd)
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_pnt.pnt048,g_errno,0)
             LET g_pnt.pnt048 = g_pnt_t.pnt048
             DISPLAY BY NAME g_pnt.pnt048 
             NEXT FIELD pnt048
          END IF
       ELSE LET g_pnt.pnt048 = ' '  #No.TQC-840018
       END IF 
       
    AFTER FIELD pnt046
      #DISPLAY "AFTER FIELD pnt046"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt046) THEN
          SELECT count(*) INTO l_cnt FROM pjb_file WHERE pjb01 = g_pnt.pnt048
                                                     AND pjb02 = g_pnt.pnt046
          IF l_cnt = 0 THEN                  
             LET l_msg = g_pnt.pnt046 clipped using '###&'
             CALL cl_err(l_msg,'apj-060',0)
             LET g_pnt.pnt046 = g_pnt_t.pnt046
             DISPLAY BY NAME g_pnt.pnt046
             NEXT FIELD pnt046
          END IF
       ELSE LET g_pnt.pnt046 = ' '  #No.TQC-840018
       END IF  
            
    AFTER FIELD pnt045
      #DISPLAY "AFTER FIELD pnt045"                                        #MOD-AB0102 mark
       IF NOT cl_null(g_pnt.pnt045) THEN 
          SELECT azm02 INTO g_azm.azm02 FROM azm_file WHERE azm01=g_pnt.pnt044
          IF g_pnt.pnt045>0 THEN                                                
             IF g_azm.azm02 = '1' THEN                                          
                IF g_pnt.pnt045>12 THEN                                         
                   CALL cl_err('','mfg9287',0)                                  
                   NEXT FIELD pnt045                                            
                END IF                                                          
             END IF                                                             
             IF g_azm.azm02 = '2' THEN                                          
                IF g_pnt.pnt045>13 THEN                                         
                   CALL cl_err('','mfg9288',0)                                  
                   NEXT FIELD pnt045                                            
                END IF                                                          
             END IF                                                             
          ELSE                                                                  
             CALL cl_err(g_pnt.pnt045,'agl-013',0)
             NEXT FIELD pnt045
          END IF
          CALL t601_pnt045('a') 
          IF NOT cl_null(g_errno) THEN
             CALL cl_err('pnt045:',g_errno,0)
             LET g_pnt.pnt045 = g_pnt_t.pnt045
             DISPLAY BY NAME g_pnt.pnt045
             NEXT FIELD pnt045
          END IF
       END IF

   #-MOD-AB0102-add-
    BEFORE FIELD pnt05
      #--------------------------MOD-C50108-------------------(S)
       SELECT afb18 INTO l_afb18 FROM afb_file
        WHERE afb00 = g_pnt.pnt037
          AND afb02 = g_pnt.pnt032
          AND afb03 = g_pnt.pnt034
          AND afb041= g_pnt.pnt033
          AND afb01 = g_pnt.pnt031
          AND afb042= g_pnt.pnt038
          AND afb04 = g_pnt.pnt036

       IF l_afb18 = 'Y' THEN
          IF g_aza.aza63 = 'N' THEN
             CALL s_getbug1(g_pnt.pnt037,g_pnt.pnt031,g_pnt.pnt032,g_pnt.pnt034,g_pnt.pnt036,
                            g_pnt.pnt033,g_pnt.pnt038,g_pnt.pnt035,'0')
                  RETURNING l_bamt1,l_bamt2,l_chkpnt05
          ELSE
             CALL s_getbug1(g_pnt.pnt037,g_pnt.pnt031,g_pnt.pnt032,g_pnt.pnt034,g_pnt.pnt036,
                            g_pnt.pnt033,g_pnt.pnt038,g_pnt.pnt035,'1')
                  RETURNING l_bamt1,l_bamt2,l_chkpnt05
          END IF

          SELECT afc06,afc08,afc09 INTO l_afc06_1,l_afc08_1,l_afc09_1
            FROM afc_file
           WHERE afc00 = g_pnt.pnt037
             AND afc01 = g_pnt.pnt031
             AND afc02 = g_pnt.pnt032
             AND afc03 = g_pnt.pnt034
             AND afc04 = g_pnt.pnt036
             AND afc041= g_pnt.pnt033
             AND afc042= g_pnt.pnt038
             AND afc05 = g_pnt.pnt035
          IF cl_null(l_afc06_1) THEN LET l_afc06_1 = 0 END IF
          IF cl_null(l_afc08_1) THEN LET l_afc08_1 = 0 END IF
          IF cl_null(l_afc09_1) THEN LET l_afc09_1 = 0 END IF
         #LET l_afc06_1 = l_afc06_1 - l_afc08_1 + l_afc09_1         #MOD-C80054 mark
          LET l_afc06_1 = l_afc06_1 + l_afc08_1 + l_afc09_1         #MOD-C80054 add

          IF p_cmd = "a" THEN
             LET g_pnt.pnt05 = l_chkpnt05
          END IF
       ELSE
      #--------------------------MOD-C50108-------------------(E)
         IF g_aza.aza63 = 'N' THEN
            CALL s_budamt1(g_pnt.pnt037,g_pnt.pnt031,g_pnt.pnt032,g_pnt.pnt034,g_pnt.pnt036,
                           g_pnt.pnt033,g_pnt.pnt038,g_pnt.pnt035,'0')
                 RETURNING l_bamt1,l_bamt2,l_bamt3,l_bamt4,l_bamt5,l_bamt6
         ELSE
            CALL s_budamt1(g_pnt.pnt037,g_pnt.pnt031,g_pnt.pnt032,g_pnt.pnt034,g_pnt.pnt036,
                           g_pnt.pnt033,g_pnt.pnt038,g_pnt.pnt035,'1')
                 RETURNING l_bamt1,l_bamt2,l_bamt3,l_bamt4,l_bamt5,l_bamt6
         END IF
         SELECT afc06,afc08,afc09 INTO l_afc06_1,l_afc08_1,l_afc09_1 
           FROM afc_file WHERE afc00 = g_pnt.pnt037
                           AND afc01 = g_pnt.pnt031
                           AND afc02 = g_pnt.pnt032
                           AND afc03 = g_pnt.pnt034
                           AND afc04 = g_pnt.pnt036
                           AND afc041= g_pnt.pnt033
                           AND afc042= g_pnt.pnt038
                           AND afc05 = g_pnt.pnt035
         IF cl_null(l_afc06_1) THEN LET l_afc06_1 = 0 END IF
         IF cl_null(l_afc08_1) THEN LET l_afc08_1 = 0 END IF
         IF cl_null(l_afc09_1) THEN LET l_afc09_1 = 0 END IF
        #----------------------MOD-C80054-------------------------(S)
         SELECT pnt05 INTO l_pnt05 FROM pnt_file
          WHERE pnt037 = g_pnt.pnt037
            AND pnt031 = g_pnt.pnt031
            AND pnt032 = g_pnt.pnt032
            AND pnt034 = g_pnt.pnt034
            AND pnt036 = g_pnt.pnt036
            AND pnt033 = g_pnt.pnt033
            AND pnt038 = g_pnt.pnt038
            AND pnt035 = g_pnt.pnt035
            AND pntconf = 'N'
            AND pntacti = 'Y'
          IF cl_null(l_pnt05) THEN LET l_pnt05 = 0 END IF
        #----------------------MOD-C80054-------------------------(E)
        #LET l_afc06_1 = l_afc06_1 - l_afc08_1 + l_afc09_1                   #MOD-C80054 mark
         LET l_afc06_1 = l_afc06_1 + l_afc08_1 + l_afc09_1 - l_pnt05         #MOD-C80054 add
         LET l_chkpnt05 = l_afc06_1 - (l_bamt1 + l_bamt2 + l_bamt3 + l_bamt4 + l_bamt5 + l_bamt6)
         IF p_cmd = "a" THEN 
            LET g_pnt.pnt05 = l_chkpnt05 
         END IF
       END IF                                     #MOD-C50108 add
   #-MOD-AB0102-end-

    AFTER FIELD pnt05
       #DISPLAY "AFTER FIELD pnt05"                                        #MOD-AB0102 mark
        IF NOT cl_null(g_pnt.pnt05) THEN
           IF g_pnt.pnt05 <= 0 THEN
             CALL cl_err(g_pnt.pnt05,'apj-035',0)
             NEXT FIELD pnt05
           END IF
          #-MOD-AB0102-add- 
           IF g_pnt.pnt05 > l_chkpnt05 THEN                          #MOD-C80054 add
             #CALL cl_getmsg('apm-314',g_lang) RETURNING l_msg       #MOD-C50108 mark
              CALL cl_getmsg('agl-198',g_lang) RETURNING l_msg       #MOD-C50108 add
              LET l_msg = g_pnt.pnt05,l_msg,l_chkpnt05 
              CALL cl_err(l_msg,'!',0)
              NEXT FIELD pnt05
           END IF                                                    #MOD-C80054 add
          #-MOD-AB0102-end- 
           CALL t601_pnt035('a') 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('pnt05:',g_errno,0)
              LET g_pnt.pnt05 = g_pnt_t.pnt05
              DISPLAY BY NAME g_pnt.pnt05
              NEXT FIELD pnt05
           END IF
           
           CALL t601_pnt045('a') 
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('pnt05:',g_errno,0)
              LET g_pnt.pnt05 = g_pnt_t.pnt05
              DISPLAY BY NAME g_pnt.pnt05
              NEXT FIELD pnt05
           END IF
        END IF
 
     ON ACTION CONTROLO                        
         IF INFIELD(pnt01) THEN
            LET g_pnt.* = g_pnt_t.*
            CALL t601_show()
            NEXT FIELD pnt01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(pnt032)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_pnt.pnt037
                 LET g_qryparam.where = " aag03='2' AND aag07 IN ('2','3') AND aag21 ='Y'"    #No.MOD-AC0009
                 LET g_qryparam.default1 = g_pnt.pnt032
                 CALL cl_create_qry() RETURNING g_pnt.pnt032
                 DISPLAY BY NAME g_pnt.pnt032
	         NEXT FIELD pnt032
                 
           WHEN INFIELD(pnt033)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_pnt.pnt033
                 CALL cl_create_qry() RETURNING g_pnt.pnt033
                 DISPLAY BY NAME g_pnt.pnt033
	         NEXT FIELD pnt033
                 
           WHEN INFIELD(pnt031)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"                    #No.FUN-930106        
                 LET g_qryparam.form = "q_azf01a"                 #No.FUN-930106
                #LET g_qryparam.arg1 = '2'                        #No.FUN-930106  
                #LET g_qryparam.arg1 = '9'                        #No.FUN-930106 
                 LET g_qryparam.arg1 = '7'                        #No.FUN-950077 
                 LET g_qryparam.default1 = g_pnt.pnt031
                 CALL cl_create_qry() RETURNING g_pnt.pnt031
                 DISPLAY BY NAME g_pnt.pnt031
	         NEXT FIELD pnt031
                 
           WHEN INFIELD(pnt038)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.default1 = g_pnt.pnt038
                 CALL cl_create_qry() RETURNING g_pnt.pnt038
                 DISPLAY BY NAME g_pnt.pnt038
	         NEXT FIELD pnt038
                 
           WHEN INFIELD(pnt036)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.default1 = g_pnt.pnt036
                 CALL cl_create_qry() RETURNING g_pnt.pnt036
                 DISPLAY BY NAME g_pnt.pnt036
	         NEXT FIELD pnt036
                 
           WHEN INFIELD(pnt042)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.arg1 = g_pnt.pnt047
                 LET g_qryparam.default1 = g_pnt.pnt042
                 CALL cl_create_qry() RETURNING g_pnt.pnt042
                 DISPLAY BY NAME g_pnt.pnt042
	         NEXT FIELD pnt042
                 
           WHEN INFIELD(pnt043)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_pnt.pnt043
                 CALL cl_create_qry() RETURNING g_pnt.pnt043
                 DISPLAY BY NAME g_pnt.pnt043
	         NEXT FIELD pnt043
                 
           WHEN INFIELD(pnt041)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_azf"                 #No.FUN-930106
                 LET g_qryparam.form = "q_azf01a"              #No.FUN-930106
                #LET g_qryparam.arg1 = '2'                     #No.FUN-930106   
                #LET g_qryparam.arg1 = '9'                     #No.FUN-930106
                 LET g_qryparam.arg1 = '7'                     #No.FUN-950077
                 LET g_qryparam.default1 = g_pnt.pnt041  
                 CALL cl_create_qry() RETURNING g_pnt.pnt041
                 DISPLAY BY NAME g_pnt.pnt041
	         NEXT FIELD pnt041
                 
           WHEN INFIELD(pnt048)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pja"
                 LET g_qryparam.default1 = g_pnt.pnt048
                 CALL cl_create_qry() RETURNING g_pnt.pnt048
                 DISPLAY BY NAME g_pnt.pnt048
	         NEXT FIELD pnt048
                 
           WHEN INFIELD(pnt046)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pjb"
                 LET g_qryparam.default1 = g_pnt.pnt046
                 CALL cl_create_qry() RETURNING g_pnt.pnt046
                 DISPLAY BY NAME g_pnt.pnt046
	         NEXT FIELD pnt046
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
 
FUNCTION t601_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_pnt.* TO NULL            
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '' TO FORMONLY.cnt
       
    CALL t601_cs()                      
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t601_count
    FETCH t601_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t601_cs                          
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,0)
        INITIALIZE g_pnt.* TO NULL
    ELSE
        CALL t601_fetch('F')              
    END IF
END FUNCTION
 
FUNCTION t601_fetch(p_flpnt)
    DEFINE
        p_flpnt         LIKE type_file.chr1           
    CASE p_flpnt
        WHEN 'N' FETCH NEXT     t601_cs INTO g_pnt.pnt01,g_pnt.pnt02
        WHEN 'P' FETCH PREVIOUS t601_cs INTO g_pnt.pnt01,g_pnt.pnt02
        WHEN 'F' FETCH FIRST    t601_cs INTO g_pnt.pnt01,g_pnt.pnt02
        WHEN 'L' FETCH LAST     t601_cs INTO g_pnt.pnt01,g_pnt.pnt02
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
            FETCH ABSOLUTE g_jump t601_cs INTO g_pnt.pnt01,g_pnt.pnt02
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,0)
        INITIALIZE g_pnt.* TO NULL  
        RETURN
    ELSE
      CASE p_flpnt
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_pnt.* FROM pnt_file   
       WHERE pnt01 = g_pnt.pnt01 AND pnt02 = g_pnt.pnt02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","pnt_file",g_pnt.pnt01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_pnt.pntuser           
        LET g_data_group=g_pnt.pntgrup
        CALL t601_show()                  
    END IF
END FUNCTION
 
FUNCTION t601_show()
   DEFINE l_n      LIKE type_file.num5
   DEFINE   l_afc06_1   LIKE afc_file.afc06
   DEFINE   l_afc08_1   LIKE afc_file.afc08
   DEFINE   l_afc09_1   LIKE afc_file.afc09
   DEFINE   l_afc_tot_1 LIKE afc_file.afc09
   DEFINE   l_afc06_2   LIKE afc_file.afc06
   DEFINE   l_afc08_2   LIKE afc_file.afc08
   DEFINE   l_afc09_2   LIKE afc_file.afc09
   DEFINE   l_afc_tot_2 LIKE afc_file.afc09
 
   LET g_pnt_t.* = g_pnt.* 
           
#  DISPLAY BY NAME g_pnt.pnt01,g_pnt.pnt02,g_pnt.pntconf, g_pnt.pntoriu,g_pnt.pntorig,
   DISPLAY BY NAME g_pnt.pnt01,g_pnt.pnt02,g_pnt.pntconf,                                #No.TQC-9A0157
                   g_pnt.pnt037,g_pnt.pnt032,g_pnt.pnt033,g_pnt.pnt031,
                   g_pnt.pnt038,g_pnt.pnt036,g_pnt.pnt034,g_pnt.pnt035,
                   g_pnt.pnt047,g_pnt.pnt042,g_pnt.pnt043,g_pnt.pnt041,
                   g_pnt.pnt048,g_pnt.pnt046,g_pnt.pnt044,g_pnt.pnt045,
                   g_pnt.pnt05,
                   g_pnt.pntuser,g_pnt.pntgrup,g_pnt.pntmodu,g_pnt.pntdate,
                   g_pnt.pntacti
   CALL t601_pnt032('d') 
   CALL t601_pnt033('d')
   CALL t601_pnt031('d')
   CALL t601_pnt038('d')
   CALL t601_pnt042('d') 
   CALL t601_pnt043('d')
   CALL t601_pnt041('d')
   CALL t601_pnt048('d')
 
   CALL t601_pnt035('d')
   CALL t601_pnt045('d')
   CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t601_u()
DEFINE  l_mid  LIKE type_file.num5
 
    IF g_pnt.pnt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    
    SELECT * INTO g_pnt.* FROM pnt_file WHERE pnt01=g_pnt.pnt01
                                          AND pnt02=g_pnt.pnt02
    IF g_pnt.pntacti = 'N' THEN
        CALL cl_err('',9027,0) 
        RETURN
    END IF
    
    IF g_pnt.pntconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_pnt01_t = g_pnt.pnt01
    LET g_pnt02_t = g_pnt.pnt02
    BEGIN WORK
 
    OPEN t601_cl USING g_pnt.pnt01,g_pnt.pnt02 
    IF STATUS THEN
       CALL cl_err("OPEN t601_cl:", STATUS, 1)
       CLOSE t601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t601_cl INTO g_pnt.*            
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,1)
        RETURN
    END IF
 
    LET g_pnt.pntmodu=g_user              
    LET g_pnt.pntdate = g_today           
                          
    WHILE TRUE
        CALL t601_i("u")                  
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_pnt.*=g_pnt_t.*
            CALL t601_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE pnt_file SET pnt_file.* = g_pnt.*
            WHERE pnt01 = g_pnt01_t AND pnt02 = g_pnt02_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","pnt_file",g_pnt.pnt01,g_pnt.pnt02,SQLCA.sqlcode,"","",0)  
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t601_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t601_x()
    IF g_pnt.pnt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    
    IF g_pnt.pntconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    
    OPEN t601_cl USING g_pnt.pnt01,g_pnt.pnt02
    IF STATUS THEN
       CALL cl_err("OPEN t601_cl:", STATUS, 1)
       CLOSE t601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t601_cl INTO g_pnt.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t601_show()
    IF cl_exp(0,0,g_pnt.pntacti) THEN
        LET g_chr=g_pnt.pntacti
        IF g_pnt.pntacti='Y' THEN
            LET g_pnt.pntacti='N'
        ELSE
            LET g_pnt.pntacti='Y'
        END IF
        UPDATE pnt_file
            SET pntacti=g_pnt.pntacti,
                pntmodu=g_user,
                pntdate=g_today     
            WHERE pnt01=g_pnt.pnt01 AND pnt02 = g_pnt.pnt02
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,0)
            LET g_pnt.pntacti=g_chr
        END IF
        DISPLAY BY NAME g_pnt.pntacti
    END IF
    CLOSE t601_cl
    COMMIT WORK
 
    SELECT pntacti,pntmodu,pntdate INTO g_pnt.pntacti,g_pnt.pntmodu,g_pnt.pntdate
      FROM FROM pnt_file WHERE pnt01=g_pnt.pnt01 AND pnt02 = g_pnt.pnt02
    DISPLAY BY NAME  g_pnt.pntacti,g_pnt.pntmodu,g_pnt.pntdate
END FUNCTION
 
FUNCTION t601_r()
    IF g_pnt.pnt01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t601_cl USING g_pnt.pnt01,g_pnt.pnt02
    IF g_pnt.pntacti = 'N' THEN
       CALL cl_err('',9027,0)
	RETURN
    END IF
    IF g_pnt.pntconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
    IF STATUS THEN
       CALL cl_err("OPEN t601_cl:", STATUS, 0)
       CLOSE t601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t601_cl INTO g_pnt.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t601_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL        #No.FUN-9B0098 10/02/24
        LET g_doc.column1="pnt01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1=g_pnt.pnt01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                       #No.FUN-9B0098 10/02/24
       DELETE FROM pnt_file WHERE pnt01 = g_pnt.pnt01
                              AND pnt02 = g_pnt.pnt02
       CLEAR FORM
       OPEN t601_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE t601_cs
          CLOSE t601_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH t601_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t601_cs
          CLOSE t601_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t601_cs
       IF g_row_count>0 THEN
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t601_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                 
          CALL t601_fetch('/')
       END IF
       END IF
    END IF
    CLOSE t601_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t601_y()
   DEFINE l_cnt    LIKE type_file.num5
   DEFINE l_afb11  LIKE afb_file.afb11
   DEFINE l_afb12  LIKE afb_file.afb12
   DEFINE l_afb13  LIKE afb_file.afb13
   DEFINE l_afb14  LIKE afb_file.afb14
   DEFINE l_afbacti LIKE afb_file.afbacti    #FUN-D70090
   DEFINE l_msg      LIKE type_file.chr1000  #FUN-D70090
 
   IF cl_null(g_pnt.pnt01) THEN 
        CALL cl_err('','apj-003',0) 
        RETURN 
   END IF
   
   IF g_pnt.pntacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_pnt.pntconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
   END IF
   
   #FUN-D70090 --begin   
   SELECT afbacti INTO l_afbacti FROM afb_file
    WHERE afb00 = g_pnt.pnt037    # 帐别编号                                       
      AND afb01 = g_pnt.pnt031    # 预算项目                                       
      AND afb02 = g_pnt.pnt032    # 科目编号                                        
      AND afb03 = g_pnt.pnt034    # 会计年度                                        
      AND afb04 = g_pnt.pnt036    # 以何为单位维护之(1.期/2.季/3.年)                                         
      AND afb041= g_pnt.pnt033    # 部门编号                                        
      AND afb042= g_pnt.pnt038    # 专案代号
   IF l_afbacti='N' THEN
      LET l_msg = 'aglt600 :',
                  g_pnt.pnt047,'/',
                  g_pnt.pnt042,'/',
                  g_pnt.pnt043,'/',
                  g_pnt.pnt041,'/',
                  g_pnt.pnt048,'/',
                  g_pnt.pnt046,'/',
                  g_pnt.pnt044       
      CALL cl_err(l_msg,'mfg1000',0)
      RETURN 
   END IF    
   SELECT afbacti INTO l_afbacti FROM afb_file 
    WHERE afb00 = g_pnt.pnt047                                            
      AND afb01 = g_pnt.pnt041                                            
      AND afb02 = g_pnt.pnt042                                            
      AND afb03 = g_pnt.pnt044                                            
      AND afb04 = g_pnt.pnt046                                            
      AND afb041= g_pnt.pnt043                                            
      AND afb042= g_pnt.pnt048
   IF l_afbacti='N' THEN
      LET l_msg = 'aglt600 :',
                  g_pnt.pnt047,'/',
                  g_pnt.pnt042,'/',
                  g_pnt.pnt043,'/',
                  g_pnt.pnt041,'/',
                  g_pnt.pnt048,'/',
                  g_pnt.pnt046,'/',
                  g_pnt.pnt044       
      CALL cl_err(l_msg,'mfg1000',0)
      RETURN 
   END IF     
#FUN-D70090 --end    
   
   IF NOT cl_confirm('axm-108') THEN 
        RETURN
   END IF
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t601_cl USING g_pnt.pnt01,g_pnt.pnt02
   IF STATUS THEN
      CALL cl_err("OPEN t601_cl:", STATUS, 1)
      CLOSE t601_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t601_cl INTO g_pnt.*    
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,0)      
      CLOSE t601_cl
      ROLLBACK WORK
      RETURN
   END IF
   
   UPDATE pnt_file SET(pntconf)=('Y') WHERE pnt01 = g_pnt.pnt01
                                        AND pnt02 = g_pnt.pnt02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","pnt_file",g_pnt.pnt01,g_pnt.pnt02,STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pnt_file",g_pnt.pnt01,g_pnt.pnt02,"9050","","",1) 
         LET g_success = 'N'
      ELSE
         UPDATE afc_file SET afc08=COALESCE(afc08,0)-g_pnt.pnt05
          WHERE afc00 = g_pnt.pnt037
            AND afc01 = g_pnt.pnt031
            AND afc02 = g_pnt.pnt032
            AND afc03 = g_pnt.pnt034
            AND afc04 = g_pnt.pnt036
            AND afc041= g_pnt.pnt033
            AND afc042= g_pnt.pnt038
            AND afc05 = g_pnt.pnt035
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","afc_file","","",STATUS,"","",1)
            LET g_success = 'N'
         ELSE 
            CALL t601_pnt035('d')
         END IF
 
#No.FUN-840002----------------start-----------------------------------------
         SELECT afb11,afb12,afb13,afb14 INTO l_afb11,l_afb12,l_afb13,l_afb14
           FROM afb_file 
          WHERE afb00 = g_pnt.pnt037                                            
            AND afb01 = g_pnt.pnt031                                            
            AND afb02 = g_pnt.pnt032                                            
            AND afb03 = g_pnt.pnt034                                            
            AND afb04 = g_pnt.pnt036                                            
            AND afb041= g_pnt.pnt033                                            
            AND afb042= g_pnt.pnt038
         CASE
            WHEN (g_pnt.pnt035=1 OR g_pnt.pnt035=2 OR g_pnt.pnt035=3) 
               LET l_afb11=l_afb11-g_pnt.pnt05
            WHEN (g_pnt.pnt035=4 OR g_pnt.pnt035=5 OR g_pnt.pnt035=6) 
               LET l_afb12=l_afb12-g_pnt.pnt05
            WHEN (g_pnt.pnt035=7 OR g_pnt.pnt035=8 OR g_pnt.pnt035=9) 
               LET l_afb13=l_afb13-g_pnt.pnt05
            WHEN (g_pnt.pnt035=10 OR g_pnt.pnt035=11 OR g_pnt.pnt035=12) 
               LET l_afb14=l_afb14-g_pnt.pnt05
         END CASE   
               
            UPDATE afb_file SET afb10=COALESCE(afb10,0)-g_pnt.pnt05,
                                afb11=l_afb11,
                                afb12=l_afb12,
                                afb13=l_afb13,
                                afb14=l_afb14
             WHERE afb00 = g_pnt.pnt037                                            
               AND afb01 = g_pnt.pnt031                                            
               AND afb02 = g_pnt.pnt032                                            
               AND afb03 = g_pnt.pnt034                                            
               AND afb04 = g_pnt.pnt036                                            
               AND afb041= g_pnt.pnt033                                            
               AND afb042= g_pnt.pnt038                                            
            IF SQLCA.sqlcode THEN                                                  
               CALL cl_err3("upd","afb_file","","",STATUS,"","",1)
               LET g_success = 'N'                 
            END IF
            
         SELECT afb11,afb12,afb13,afb14 INTO l_afb11,l_afb12,l_afb13,l_afb14
           FROM afb_file 
          WHERE afb00 = g_pnt.pnt047                                            
            AND afb01 = g_pnt.pnt041                                            
            AND afb02 = g_pnt.pnt042                                            
            AND afb03 = g_pnt.pnt044                                            
            AND afb04 = g_pnt.pnt046                                            
            AND afb041= g_pnt.pnt043                                            
            AND afb042= g_pnt.pnt048
         CASE
            WHEN (g_pnt.pnt045=1 OR g_pnt.pnt045=2 OR g_pnt.pnt045=3) 
               LET l_afb11=l_afb11+g_pnt.pnt05
            WHEN (g_pnt.pnt045=4 OR g_pnt.pnt045=5 OR g_pnt.pnt045=6) 
               LET l_afb12=l_afb12+g_pnt.pnt05
            WHEN (g_pnt.pnt045=7 OR g_pnt.pnt045=8 OR g_pnt.pnt045=9) 
               LET l_afb13=l_afb13+g_pnt.pnt05
            WHEN (g_pnt.pnt045=10 OR g_pnt.pnt045=11 OR g_pnt.pnt045=12)
               LET l_afb14=l_afb14+g_pnt.pnt05
         END CASE 
     
            UPDATE afb_file SET afb10=COALESCE(afb10,0)+g_pnt.pnt05,
                                afb11=l_afb11,
                                afb12=l_afb12,
                                afb13=l_afb13,
                                afb14=l_afb14
             WHERE afb00 = g_pnt.pnt047                                            
               AND afb01 = g_pnt.pnt041                                            
               AND afb02 = g_pnt.pnt042                                            
               AND afb03 = g_pnt.pnt044                                            
               AND afb04 = g_pnt.pnt046                                            
               AND afb041= g_pnt.pnt043                                            
               AND afb042= g_pnt.pnt048                                            
            IF SQLCA.sqlcode THEN                                                  
               CALL cl_err3("upd","afb_file","","",STATUS,"","",1)
               LET g_success = 'N'
            END IF
#No.FUN-840002------------------end----------------------------------------- 
 
         UPDATE afc_file SET afc08=COALESCE(afc08,0)+g_pnt.pnt05 
          WHERE afc00 = g_pnt.pnt047
            AND afc01 = g_pnt.pnt041
            AND afc02 = g_pnt.pnt042
            AND afc03 = g_pnt.pnt044
            AND afc04 = g_pnt.pnt046
            AND afc041= g_pnt.pnt043
            AND afc042= g_pnt.pnt048
            AND afc05 = g_pnt.pnt045
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","afc_file","","",STATUS,"","",1)
            LET g_success = 'N'
         ELSE 
            CALL t601_pnt045('d')
            LET g_pnt.pntconf = 'Y'
            DISPLAY BY NAME g_pnt.pntconf
         END IF
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t601_z()
   DEFINE l_afb11  LIKE afb_file.afb11
   DEFINE l_afb12  LIKE afb_file.afb12
   DEFINE l_afb13  LIKE afb_file.afb13
   DEFINE l_afb14  LIKE afb_file.afb14
 
   IF cl_null(g_pnt.pnt01) THEN
      CALL cl_err('','apj-003',0)
      RETURN
   END IF
 
   IF g_pnt.pntacti='N' THEN
        CALL cl_err('','atm-365',0)
        RETURN
   END IF
   
   IF g_pnt.pntconf = 'N' THEN
      CALL cl_err('','9002',0)
      RETURN
   END IF
   
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t601_cl USING g_pnt.pnt01,g_pnt.pnt02
   IF STATUS THEN
      CALL cl_err("OPEN t601_cl:", STATUS, 1)
      CLOSE t601_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t601_cl INTO g_pnt.*            
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pnt.pnt01,SQLCA.sqlcode,0)     
      CLOSE t601_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE pnt_file SET(pntconf)=('N') WHERE pnt01 = g_pnt.pnt01
                                        AND pnt02 = g_pnt.pnt02
   IF SQLCA.sqlcode  THEN
     
      CALL cl_err3("upd","pnt_file",g_pnt.pnt01,g_pnt.pnt02,STATUS,"","",1) 
      LET g_success = 'N'
   ELSE
      IF SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","pnt_file",g_pnt.pnt01,g_pnt.pnt02,"9053","","",1) 
         LET g_success = 'N'
      ELSE
         UPDATE afc_file SET afc08=COALESCE(afc08,0)+g_pnt.pnt05 
          WHERE afc00 = g_pnt.pnt037
            AND afc01 = g_pnt.pnt031
            AND afc02 = g_pnt.pnt032
            AND afc03 = g_pnt.pnt034
            AND afc04 = g_pnt.pnt036
            AND afc041= g_pnt.pnt033
            AND afc042= g_pnt.pnt038
            AND afc05 = g_pnt.pnt035
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","afc_file","","",STATUS,"","",1)
            LET g_success = 'N'
         ELSE 
            CALL t601_pnt035('d')
         END IF
        
#No.FUN-840002----------------start----------------------------------------- 
         SELECT afb11,afb12,afb13,afb14 INTO l_afb11,l_afb12,l_afb13,l_afb14
           FROM afb_file 
          WHERE afb00 = g_pnt.pnt037                                            
            AND afb01 = g_pnt.pnt031                                            
            AND afb02 = g_pnt.pnt032                                            
            AND afb03 = g_pnt.pnt034                                            
            AND afb04 = g_pnt.pnt036                                            
            AND afb041= g_pnt.pnt033                                            
            AND afb042= g_pnt.pnt038
         CASE
            WHEN (g_pnt.pnt035=1 OR g_pnt.pnt035=2 OR g_pnt.pnt035=3) 
               LET l_afb11=l_afb11+g_pnt.pnt05
            WHEN (g_pnt.pnt035=4 OR g_pnt.pnt035=5 OR g_pnt.pnt035=6)  
               LET l_afb12=l_afb12+g_pnt.pnt05
            WHEN (g_pnt.pnt035=7 OR g_pnt.pnt035=8 OR g_pnt.pnt035=9)
               LET l_afb13=l_afb13+g_pnt.pnt05
            WHEN (g_pnt.pnt035=10 OR g_pnt.pnt035=11 OR g_pnt.pnt035=12)
               LET l_afb14=l_afb14+g_pnt.pnt05
         END CASE   
               
            UPDATE afb_file SET afb10=COALESCE(afb10,0)+g_pnt.pnt05,
                                afb11=l_afb11,
                                afb12=l_afb12,
                                afb13=l_afb13,
                                afb14=l_afb14
             WHERE afb00 = g_pnt.pnt037                                            
               AND afb01 = g_pnt.pnt031                                            
               AND afb02 = g_pnt.pnt032                                            
               AND afb03 = g_pnt.pnt034                                            
               AND afb04 = g_pnt.pnt036                                            
               AND afb041= g_pnt.pnt033                                            
               AND afb042= g_pnt.pnt038                                            
            IF SQLCA.sqlcode THEN                                                  
               CALL cl_err3("upd","afb_file","","",STATUS,"","",1)
               LET g_success = 'N'
            END IF
            
         SELECT afb11,afb12,afb13,afb14 INTO l_afb11,l_afb12,l_afb13,l_afb14
           FROM afb_file 
          WHERE afb00 = g_pnt.pnt047                                            
            AND afb01 = g_pnt.pnt041                                            
            AND afb02 = g_pnt.pnt042                                            
            AND afb03 = g_pnt.pnt044                                            
            AND afb04 = g_pnt.pnt046                                            
            AND afb041= g_pnt.pnt043                                            
            AND afb042= g_pnt.pnt048
         CASE
            WHEN (g_pnt.pnt045=1 OR g_pnt.pnt045=2 OR g_pnt.pnt045=3) 
               LET l_afb11=l_afb11-g_pnt.pnt05
            WHEN (g_pnt.pnt045=4 OR g_pnt.pnt045=5 OR g_pnt.pnt045=6)  
               LET l_afb12=l_afb12-g_pnt.pnt05
            WHEN (g_pnt.pnt045=7 OR g_pnt.pnt045=8 OR g_pnt.pnt045=9)
               LET l_afb13=l_afb13-g_pnt.pnt05
            WHEN (g_pnt.pnt045=10 OR g_pnt.pnt045=11 OR g_pnt.pnt045=12)
               LET l_afb14=l_afb14-g_pnt.pnt05
         END CASE 
     
            UPDATE afb_file SET afb10=COALESCE(afb10,0)-g_pnt.pnt05,
                                afb11=l_afb11,
                                afb12=l_afb12,
                                afb13=l_afb13,
                                afb14=l_afb14
             WHERE afb00 = g_pnt.pnt047                                            
               AND afb01 = g_pnt.pnt041                                            
               AND afb02 = g_pnt.pnt042                                            
               AND afb03 = g_pnt.pnt044                                            
               AND afb04 = g_pnt.pnt046                                            
               AND afb041= g_pnt.pnt043                                            
               AND afb042= g_pnt.pnt048                                            
            IF SQLCA.sqlcode THEN                                                  
               CALL cl_err3("upd","afb_file","","",STATUS,"","",1)
               LET g_success = 'N'
            END IF
#No.FUN-840002------------------end-----------------------------------------
 
         UPDATE afc_file SET afc08=COALESCE(afc08,0)-g_pnt.pnt05
          WHERE afc00 = g_pnt.pnt047
            AND afc01 = g_pnt.pnt041
            AND afc02 = g_pnt.pnt042
            AND afc03 = g_pnt.pnt044
            AND afc04 = g_pnt.pnt046
            AND afc041= g_pnt.pnt043
            AND afc042= g_pnt.pnt048
            AND afc05 = g_pnt.pnt045
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","afc_file","","",STATUS,"","",1)
            LET g_success = 'N'
         ELSE 
            CALL t601_pnt045('d')
            LET g_pnt.pntconf = 'N'
            DISPLAY BY NAME g_pnt.pntconf
         END IF
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t601_out()
   DEFINE l_aag02      LIKE aag_file.aag02
   DEFINE l_gem02      LIKE gem_file.gem02
   DEFINE l_azf03      LIKE azf_file.azf03
   DEFINE l_pja02      LIKE pja_file.pja02
 
   DEFINE l_aag02_1    LIKE aag_file.aag02
   DEFINE l_gem02_1    LIKE gem_file.gem02
   DEFINE l_azf03_1    LIKE azf_file.azf03
   DEFINE l_pja02_1    LIKE pja_file.pja02
 
   DEFINE l_afc06_1    LIKE afc_file.afc06
   DEFINE l_afc08_1    LIKE afc_file.afc08
   DEFINE l_afc09_1    LIKE afc_file.afc09
   DEFINE l_afc_tot_1  LIKE afc_file.afc06
   DEFINE l_afc06_2    LIKE afc_file.afc06
   DEFINE l_afc08_2    LIKE afc_file.afc08
   DEFINE l_afc09_2    LIKE afc_file.afc09
   DEFINE l_afc_tot_2  LIKE afc_file.afc06
   DEFINE sr           RECORD
          pnt01        LIKE pnt_file.pnt01,
          pnt02        LIKE pnt_file.pnt02,
          pntconf      LIKE pnt_file.pntconf,
          pnt037       LIKE pnt_file.pnt037,
          pnt032       LIKE pnt_file.pnt032,
          pnt033       LIKE pnt_file.pnt033,
          pnt031       LIKE pnt_file.pnt031,
          pnt038       LIKE pnt_file.pnt038,
          pnt036       LIKE pnt_file.pnt036,
          pnt034       LIKE pnt_file.pnt034,
          pnt035       LIKE pnt_file.pnt035,
          pnt047       LIKE pnt_file.pnt047,
          pnt042       LIKE pnt_file.pnt042,
          pnt043       LIKE pnt_file.pnt043,
          pnt041       LIKE pnt_file.pnt041,
          pnt048       LIKE pnt_file.pnt048,
          pnt046       LIKE pnt_file.pnt046,
          pnt044       LIKE pnt_file.pnt044,
          pnt045       LIKE pnt_file.pnt045,
          pnt05        LIKE pnt_file.pnt05,
          l_aag02      LIKE aag_file.aag02,
          l_gem02      LIKE gem_file.gem02,
          l_azf03      LIKE azf_file.azf03,
          l_pja02      LIKE pja_file.pja02,
          l_aag02_1    LIKE aag_file.aag02,
          l_gem02_1    LIKE gem_file.gem02,
          l_azf03_1    LIKE azf_file.azf03,
          l_pja02_1    LIKE pja_file.pja02,
          l_afc06_1    LIKE afc_file.afc06,
          l_afc08_1    LIKE afc_file.afc08,
          l_afc09_1    LIKE afc_file.afc09,
          l_afc_tot_1  LIKE afc_file.afc09,
          l_afc06_2    LIKE afc_file.afc06,
          l_afc08_2    LIKE afc_file.afc08,
          l_afc09_2    LIKE afc_file.afc09,
          l_afc_tot_2  LIKE afc_file.afc09
                       END RECORD
 
   IF cl_null(g_pnt.pnt01) THEN 
       CALL cl_err('',9057,0)
       RETURN
   END IF
   IF g_wc IS NULL THEN 
       LET g_wc ="pnt01='",g_pnt.pnt01,"'AND pnt02='",g_pnt.pnt02,"'"  
   END IF
   CALL cl_wait()                                                       
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
   CALL cl_del_data(l_table) 
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
             "        ?,?,?,?,?, ?,?,?,?,?, ?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF       
   LET g_sql="SELECT pnt01,pnt02,pntconf,pnt037,pnt032,pnt033,pnt031,pnt038,",
             "       pnt036,pnt034,pnt035,pnt047,pnt042,pnt043,pnt041,pnt048,",
             "       pnt046,pnt044,pnt045,pnt05, ",
             "       '','','','','','','','','','','','','','','','' ",
             "  FROM pnt_file",
             " WHERE ",g_wc CLIPPED
    LET g_sql = g_sql CLIPPED," ORDER BY pnt01,pnt02 "
    PREPARE t601_p1 FROM g_sql
    IF STATUS THEN CALL cl_err('t601_pl',STATUS,0) END IF
    DECLARE t601_co CURSOR FOR t601_p1
    FOREACH t601_co INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)   
           EXIT FOREACH
       END IF
       SELECT aag02 INTO l_aag02 FROM aag_file
        WHERE aag01 = sr.pnt032
          AND aag03 = '2'
          AND (aag07 = '2' OR aag07 = '3')
       SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.pnt033
       IF SQLCA.sqlcode THEN                                                    
          LET l_gem02=''                                                        
       END IF
       SELECT azf03 INTO l_azf03 FROM azf_file
        WHERE azf01=sr.pnt031 AND azf02='2'
       SELECT pja02 INTO l_pja02 FROM pja_file WHERE pja01=sr.pnt038
       IF SQLCA.sqlcode THEN
          LET l_pja02=''
       END IF
       
       SELECT aag02 INTO l_aag02_1 FROM aag_file
        WHERE aag01 = sr.pnt042
          AND aag03 = '2'
          AND (aag07 = '2' OR aag07 = '3')
       SELECT gem02 INTO l_gem02_1 FROM gem_file WHERE gem01=sr.pnt043
       IF SQLCA.sqlcode THEN                                                    
          LET l_gem02_1=''                                                        
       END IF
       SELECT azf03 INTO l_azf03_1 FROM azf_file
        WHERE azf01=sr.pnt041 AND azf02='2'
       SELECT pja02 INTO l_pja02_1 FROM pja_file WHERE pja01=sr.pnt048
       IF SQLCA.sqlcode THEN                                                    
          LET l_pja02_1=''                                                        
       END IF
       
       SELECT afc06,afc08,afc09 
         INTO l_afc06_1,l_afc08_1,l_afc09_1
         FROM afc_file WHERE afc00 = sr.pnt037
                         AND afc01 = sr.pnt031
                         AND afc02 = sr.pnt032
                         AND afc03 = sr.pnt034
                         AND afc04 = sr.pnt036
                         AND afc041= sr.pnt033
                         AND afc042= sr.pnt038
                         AND afc05 = sr.pnt035
       IF SQLCA.sqlcode THEN
          LET l_afc06_1=NULL
          LET l_afc08_1=NULL
          LET l_afc09_1=NULL
       END IF
       IF cl_null(l_afc06_1) THEN LET l_afc06_1=0 END IF
       IF cl_null(l_afc08_1) THEN LET l_afc08_1=0 END IF
       IF cl_null(l_afc09_1) THEN LET l_afc09_1=0 END IF
                         
       SELECT afc06,afc08,afc09 
         INTO l_afc06_2,l_afc08_2,l_afc09_2
         FROM afc_file WHERE afc00 = sr.pnt047
                         AND afc01 = sr.pnt041
                         AND afc02 = sr.pnt042
                         AND afc03 = sr.pnt044
                         AND afc04 = sr.pnt046
                         AND afc041= sr.pnt043
                         AND afc042= sr.pnt048
                         AND afc05 = sr.pnt045
       IF SQLCA.sqlcode THEN                                                    
          LET l_afc06_2=NULL                                                    
          LET l_afc08_2=NULL                                                    
          LET l_afc09_2=NULL                                                    
       END IF
       IF cl_null(l_afc06_2) THEN LET l_afc06_2=0 END IF
       IF cl_null(l_afc08_2) THEN LET l_afc08_2=0 END IF
       IF cl_null(l_afc09_2) THEN LET l_afc09_2=0 END IF
 
       LET l_afc_tot_1 = l_afc06_1 + l_afc08_1 + l_afc09_1
       LET l_afc_tot_2 = l_afc06_2 + l_afc08_2 + l_afc09_2
       EXECUTE insert_prep 
         USING sr.pnt01,sr.pnt02,sr.pntconf,sr.pnt037,sr.pnt032,sr.pnt033,
               sr.pnt031,sr.pnt038,sr.pnt036,sr.pnt034,sr.pnt035,sr.pnt047,
               sr.pnt042,sr.pnt043,sr.pnt041,sr.pnt048,sr.pnt046,sr.pnt044,
               sr.pnt045,sr.pnt05,l_aag02,l_gem02,l_azf03,l_pja02,l_aag02_1,
               l_gem02_1,l_azf03_1,l_pja02_1,l_afc06_1,l_afc08_1,l_afc09_1,
               l_afc_tot_1,l_afc06_2,l_afc08_2,l_afc09_2,l_afc_tot_2 
    END FOREACH
    LET g_str=g_wc clipped
    IF g_zz05='Y' THEN
       CALL cl_wcchp(g_str,'pnt01,pnt02') RETURNING g_str
    ELSE 
       LET g_str=''
    END IF
    LET g_str = g_str,";",g_ccz.ccz27
    LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('aglt601','aglt601',g_sql,g_str)
 END FUNCTION  
                  
FUNCTION t601_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("pnt01",TRUE)
         CALL cl_set_comp_entry("g_pnt.pnt01,g_pnt.pnt02",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t601_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("pnt01",FALSE)
       CALL cl_set_comp_entry("g_pnt.pnt01,g_pnt.pnt02",TRUE)
    END IF
 
END FUNCTION
#NO.FUN-810069

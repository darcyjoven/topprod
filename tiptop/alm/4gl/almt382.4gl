# Prog. Version..: '5.30.06-13.04.09(00006)'     #
#
# Pattern name...: almt382.4gl
# Descriptions...: 合約輔助信息變更申請單
# Date & Author..: NO.FUN-BA0118 11/11/04 By xumeimei

 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C30001 12/03/01 by chenwei 詢時ljaconu 開窗
# Modify.........: No:TQC-C30239 12/03/20 by fanbj 主品牌及新主品牌名稱應帶出tqa03 = '2'的資料
# Modify.........: No.FUN-CB0076 12/12/04 By xumeimei 添加GR打印功能
# Modify.........: No.CHI-C80041 13/01/04 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/27 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"  
 
DEFINE g_lja                 RECORD LIKE lja_file.*,
       g_lja_t               RECORD LIKE lja_file.*,
       g_lja01_t             LIKE lja_file.lja01,
       g_wc                  STRING,                     
       g_sql                 STRING                 
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_chr                 LIKE lja_file.ljaacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE mi_no_ask             LIKE type_file.num5
DEFINE l_cnt                 LIKE type_file.num5
DEFINE g_confirm             LIKE type_file.chr1
DEFINE g_t1                  LIKE oay_file.oayslip
#FUN-CB0076----add---str
DEFINE l_table           STRING
TYPE sr1_t RECORD
    ljaplant  LIKE lja_file.ljaplant,
    lja01     LIKE lja_file.lja01,
    lja05     LIKE lja_file.lja05,
    lja12     LIKE lja_file.lja12,
    lja03     LIKE lja_file.lja03,
    lja14     LIKE lja_file.lja14,
    lja06     LIKE lja_file.lja06,
    lja04     LIKE lja_file.lja04,
    lja15     LIKE lja_file.lja15,
    lja20     LIKE lja_file.lja20,
    lja07     LIKE lja_file.lja07,
    lja08     LIKE lja_file.lja08,
    lja09     LIKE lja_file.lja09,
    lja10     LIKE lja_file.lja10,
    lja081    LIKE lja_file.lja081,
    lja091    LIKE lja_file.lja091,
    lja101    LIKE lja_file.lja101,
    lja17     LIKE lja_file.lja17,
    lja18     LIKE lja_file.lja18,
    lja19     LIKE lja_file.lja19,
    lja13     LIKE lja_file.lja13,
    lja131    LIKE lja_file.lja131,
    lja11     LIKE lja_file.lja11,
    sign_type LIKE type_file.chr1,
    sign_img  LIKE type_file.blob,
    sign_show LIKE type_file.chr1,
    sign_str  LIKE type_file.chr1000,
    rtz13     LIKE rtz_file.rtz13,
    lne05     LIKE lne_file.lne05,
    gen02     LIKE gen_file.gen02,
    lmf13     LIKE lmf_file.lmf13,
    lnt60     LIKE lnt_file.lnt60,
    lnt10     LIKE lnt_file.lnt10,
    lnt33     LIKE lnt_file.lnt33
END RECORD
#FUN-CB0076----add---end

MAIN
   DEFINE
       p_row,p_col     LIKE type_file.num5         

       
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
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
   INITIALIZE g_lja.* TO NULL

   #FUN-CB0076----add---str
   LET g_pdate = g_today
   LET g_sql ="ljaplant.lja_file.ljaplant,",
              "lja01.lja_file.lja01,",
              "lja05.lja_file.lja05,",
              "lja12.lja_file.lja12,",
              "lja03.lja_file.lja03,",
              "lja14.lja_file.lja14,",
              "lja06.lja_file.lja06,",
              "lja04.lja_file.lja04,",
              "lja15.lja_file.lja15,",
              "lja20.lja_file.lja20,",
              "lja07.lja_file.lja07,",
              "lja08.lja_file.lja08,",
              "lja09.lja_file.lja09,",
              "lja10.lja_file.lja10,",
              "lja081.lja_file.lja081,",
              "lja091.lja_file.lja091,",
              "lja101.lja_file.lja101,",
              "lja17.lja_file.lja17,",
              "lja18.lja_file.lja18,",
              "lja19.lja_file.lja19,",
              "lja13.lja_file.lja13,",
              "lja131.lja_file.lja131,",
              "lja11.lja_file.lja11,",
              "sign_type.type_file.chr1,",
              "sign_img.type_file.blob,",
              "sign_show.type_file.chr1,",
              "sign_str.type_file.chr1000,",
              "rtz13.rtz_file.rtz13,",
              "lne05.lne_file.lne05,",
              "gen02.gen_file.gen02,",
              "lmf13.lmf_file.lmf13,",
              "lnt60.lnt_file.lnt60,",
              "lnt10.lnt_file.lnt10,",
              "lnt33.lnt_file.lnt33"
   LET l_table = cl_prt_temptable('almt382',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, 
                      ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?)" 
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-CB0076------add-----end  
   LET g_forupd_sql = "SELECT * FROM lja_file WHERE lja01 = ? FOR UPDATE "       
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t382_cl CURSOR FROM g_forupd_sql                 
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t382_w AT p_row,p_col WITH FORM "alm/42f/almt382"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 

   LET g_action_choice = ""
   CALL t382_menu()
 
   CLOSE WINDOW t382_w
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
   CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN
 
FUNCTION t382_cs()
    CLEAR FORM
    INITIALIZE g_lja.* TO NULL      
    CONSTRUCT BY NAME g_wc ON  lja01,lja03,lja04,ljaplant,ljalegal,lja05,lja06,lja12,lja07,               
           lja13,lja131,lja08,lja09,lja10,lja14,lja15,lja16,lja17,lja18,ljamksg,lja21,
           ljaconf,ljaconu,ljacond,ljacont,lja20,ljauser,ljagrup,ljaoriu,ljamodu,
           ljadate,ljaorig,ljaacti,ljacrat
 
    BEFORE CONSTRUCT
           CALL cl_qbe_init()
              
        ON ACTION controlp
           CASE WHEN INFIELD(lja01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja01"
                   LET g_qryparam.default1 = g_lja.lja01
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja01
                   NEXT FIELD lja01
            
              WHEN INFIELD(lja04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja04"
                   LET g_qryparam.default1 = g_lja.lja04
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja04
                   NEXT FIELD lja04
                
              WHEN INFIELD(ljaplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ljaplant"
                   LET g_qryparam.default1 = g_lja.ljaplant
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ljaplant
                   NEXT FIELD ljaplant
                      
              WHEN INFIELD(ljalegal)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ljalegal"
                   LET g_qryparam.default1 = g_lja.ljalegal
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ljalegal
                   NEXT FIELD ljalegal
                 
              WHEN INFIELD(lja05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja05"
                   LET g_qryparam.default1 = g_lja.lja05
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja05
                   NEXT FIELD lja05
                    
              WHEN INFIELD(lja06)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja06"
                   LET g_qryparam.default1 = g_lja.lja06
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja06
                   NEXT FIELD lja06  

              WHEN INFIELD(lja12)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja12"
                   LET g_qryparam.default1 = g_lja.lja12
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja12
                   NEXT FIELD lja12 
                    
              WHEN INFIELD(lja07)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja07"
                   LET g_qryparam.default1 = g_lja.lja07
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja07
                   NEXT FIELD lja07  
                
              WHEN INFIELD(lja13)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja13"
                   LET g_qryparam.default1 = g_lja.lja13
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja13
                   NEXT FIELD lja13     

              WHEN INFIELD(lja131)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_lja131"
                   LET g_qryparam.default1 = g_lja.lja131
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lja131
                   NEXT FIELD lja131
              # NO.TQC-C30001---add sta
              
              WHEN INFIELD(ljaconu)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_ljaconu"
                   LET g_qryparam.default1 = g_lja.ljaconu
                   LET g_qryparam.where = "lja02 = '2'"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO ljaconu
                   NEXT FIELD ljaconu
             #  NO.TQC-C30001---add end
      
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
 
  
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ljauser', 'ljagrup')
    IF cl_null(g_wc) THEN
       LET g_wc =' 1=1'
    END IF  
    
    LET g_sql="SELECT lja01 FROM lja_file ", 
              " WHERE lja02 ='2'AND ",g_wc CLIPPED,
              " ORDER BY lja01"
    PREPARE t382_prepare FROM g_sql
    DECLARE t382_cs                                
        SCROLL CURSOR WITH HOLD FOR t382_prepare
    LET g_sql="SELECT COUNT(*) FROM lja_file ",
              " WHERE lja02 ='2' AND ",g_wc CLIPPED
    PREPARE t382_precount FROM g_sql
    DECLARE t382_count CURSOR FOR t382_precount
END FUNCTION
 
FUNCTION t382_menu()
   DEFINE l_cmd  LIKE type_file.chr1000      
   MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t382_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t382_q()
            END IF
        ON ACTION next
            CALL t382_fetch('N')
        ON ACTION previous
            CALL t382_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t382_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL t382_x()
            END IF
            CALL t382_pic()
        #FUN-CB0076------add----str
        ON ACTION OUTPUT
           LET g_action_choice="output"
           IF cl_chk_act_auth() THEN
              CALL t382_out()
           END IF
        #FUN-CB0076------add----end
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t382_r()
            END IF
            
       ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t382_confirm()
               CALL t382_pic()
            END IF   
                    
       ON ACTION unconfirm
            LET g_action_choice="unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t382_unconfirm()
               CALL t382_pic()
            END IF

   
       ON ACTION help
            CALL cl_show_help()
       ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
       ON ACTION jump
            CALL t382_fetch('/')
       ON ACTION first
            CALL t382_fetch('F')
       ON ACTION last
            CALL t382_fetch('L')
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
 
 
       ON ACTION CLOSE  
           LET INT_FLAG=FALSE 	
           LET g_action_choice = "exit"
           EXIT MENU
 
       ON ACTION related_document  
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lja.lja01 IS NOT NULL THEN
                 LET g_doc.column1 = "lja01"
                 LET g_doc.value1 = g_lja.lja01
                 CALL cl_doc()
              END IF
           END IF
 
    END MENU
    CLOSE t382_cs
END FUNCTION
 
 
FUNCTION t382_a()
DEFINE li_result   LIKE type_file.num5

    MESSAGE ""
    CLEAR FORM                                  
    INITIALIZE g_lja.* LIKE lja_file.*
    LET g_lja_t.* = g_lja.*
    LET g_lja01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lja.lja02 = '2'
        LET g_lja.lja03 = g_today
        LET g_lja.lja04 = g_user
        LET g_lja.ljaplant = g_plant
        LET g_lja.ljalegal = g_legal
        LET g_lja.ljamksg = 'N'
        LET g_lja.lja21 = '0'
        LET g_lja.ljaconf = 'N'
        LET g_lja.ljauser = g_user
        LET g_lja.ljaoriu = g_user 
        LET g_lja.ljaorig = g_grup 
        LET g_lja.ljagrup = g_grup               
        LET g_lja.ljadate = g_today
        LET g_lja.ljaacti = 'Y'
        LET g_lja.ljacrat = g_today
        CALL t382_desc()
        CALL t382_i("a")                         
        IF INT_FLAG THEN                         
            INITIALIZE g_lja.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lja.lja01 IS NULL THEN              
            CONTINUE WHILE
        END IF

        BEGIN WORK
        CALL s_auto_assign_no("alm",g_lja.lja01,g_today,"P5","lja_file","lja01","","","")
           RETURNING li_result,g_lja.lja01
        IF (NOT li_result) THEN
            ROLLBACK WORK
            CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lja.lja01
        INSERT INTO lja_file VALUES(g_lja.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lja_file",g_lja.lja01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        ELSE
            SELECT lja01 INTO g_lja.lja01 FROM lja_file
                     WHERE lja01 = g_lja.lja01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t382_i(p_cmd)
   DEFINE   p_cmd             LIKE type_file.chr1,          
            l_input           LIKE type_file.chr1,  
            l_n               LIKE type_file.num5,
            l_sma53           LIKE sma_file.sma53,
            li_result         LIKE type_file.num5
 
 
   DISPLAY BY NAME
            g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,g_lja.ljalegal,
            g_lja.lja05,g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,
            g_lja.lja131,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,
            g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.ljamksg,
            g_lja.lja21,g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.ljacont,
            g_lja.lja20,g_lja.ljauser,g_lja.ljagrup,g_lja.ljaoriu,g_lja.ljamodu,
            g_lja.ljadate,g_lja.ljaorig,g_lja.ljaacti,g_lja.ljacrat

   CALL t382_desc()
   INPUT BY NAME
            g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,g_lja.ljalegal,
            g_lja.lja05,g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,
            g_lja.lja131,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,
            g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.ljamksg,
            g_lja.lja21,g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.ljacont,
            g_lja.lja20,g_lja.ljauser,g_lja.ljagrup,g_lja.ljaoriu,g_lja.ljamodu,
            g_lja.ljadate,g_lja.ljaorig,g_lja.ljaacti,g_lja.ljacrat
      
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t382_set_entry(p_cmd)
          CALL t382_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lja01")
 
      AFTER FIELD lja01
         DISPLAY "AFTER FIELD lja01"
         IF NOT cl_null(g_lja.lja01) THEN
              IF (p_cmd='a') OR (p_cmd='u' AND g_lja.lja01!=g_lja_t.lja01) THEN
                 CALL s_check_no("alm",g_lja.lja01,g_lja01_t,"P5","lja_file","lja01","")  
                    RETURNING li_result,g_lja.lja01
                 IF (NOT li_result) THEN                                                            
                    LET g_lja.lja01=g_lja_t.lja01                                                                 
                    NEXT FIELD lja01                                                                                      
                 END IF
                 LET g_t1=s_get_doc_no(g_lja.lja01)
                 SELECT oayapr INTO g_lja.ljamksg FROM oay_file WHERE oayslip = g_t1
                 DISPLAY BY NAME g_lja.ljamksg
              END IF
           END IF

     AFTER FIELD lja03
           IF NOT cl_null(g_lja.lja03) THEN
              SELECT sma53 INTO l_sma53 FROM sma_file
              IF g_lja.lja03 < l_sma53 THEN
                 CALL cl_err('','alm1140',0)
                 LET g_lja.lja03 = g_lja_t.lja03
                 NEXT FIELD lja03
              END IF
           END IF

      AFTER FIELD lja04
           IF NOT cl_null(g_lja.lja04) THEN
              CALL t382_lja04()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lja.lja04 = g_lja_t.lja04
                 NEXT FIELD lja04
              END IF
              CALL t382_desc()
           END IF    

      AFTER FIELD lja05
           IF NOT cl_null(g_lja.lja05) THEN
              CALL t382_lja05()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lja.lja05 = g_lja_t.lja05
                 NEXT FIELD lja05
              END IF
              CALL t382_desc()
              IF g_lja.lja131 = g_lja.lja13 THEN
                 CALL cl_err('','alm1170 ',0)
                 NEXT FIELD lja131 
              END IF
           END IF


      AFTER FIELD lja131
           IF NOT cl_null(g_lja.lja131) THEN
              CALL t382_lja131()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_lja.lja131 = g_lja_t.lja131
                 NEXT FIELD lja131
              END IF
              CALL t382_desc()
           END IF
           
      AFTER INPUT
         LET g_lja.ljauser = s_get_data_owner("lja_file") #FUN-C10039
         LET g_lja.ljagrup = s_get_data_group("lja_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF g_lja.lja01 IS NULL THEN
               DISPLAY BY NAME g_lja.lja01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD lja01
            END IF
 

      ON ACTION controlp
           CASE 
           WHEN INFIELD(lja01)
                LET g_t1=s_get_doc_no(g_lja.lja01)
                CALL q_oay(FALSE,FALSE,g_t1,'P5','ALM') RETURNING g_t1  
                LET g_lja.lja01=g_t1               
                DISPLAY BY NAME g_lja.lja01       
                NEXT FIELD lja01
                
           WHEN INFIELD(lja04) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_gen"
                LET g_qryparam.default1 = g_lja.lja04
                CALL cl_create_qry() RETURNING g_lja.lja04
                CALL t382_lja04() 
                DISPLAY BY NAME g_lja.lja04
                NEXT FIELD lja04

           WHEN INFIELD(lja05) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_lnt01i"
                LET g_qryparam.default1 = g_lja.lja05
                CALL cl_create_qry() RETURNING g_lja.lja05
                DISPLAY BY NAME g_lja.lja05
                NEXT FIELD lja05

           WHEN INFIELD(lja131) 
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_tqa"
                LET g_qryparam.arg1 = '2'
                LET g_qryparam.default1 = g_lja.lja131
                CALL cl_create_qry() RETURNING g_lja.lja131
                DISPLAY BY NAME g_lja.lja131
                NEXT FIELD lja131
                
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
 
 
FUNCTION t382_q()
    LET g_row_count = 0
    LET g_curs_index = 0

    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lja.* TO NULL     

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt

    CALL t382_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF

    OPEN t382_count
    FETCH t382_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t382_cs  
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
        INITIALIZE g_lja.* TO NULL
    ELSE
        CALL t382_fetch('F') 
    END IF
END FUNCTION
 
FUNCTION t382_fetch(p_fltc_hfd)
    DEFINE  p_fltc_hfd        LIKE type_file.chr1 
        
 
    CASE p_fltc_hfd
        WHEN 'N' FETCH NEXT     t382_cs INTO g_lja.lja01
        WHEN 'P' FETCH PREVIOUS t382_cs INTO g_lja.lja01
        WHEN 'F' FETCH FIRST    t382_cs INTO g_lja.lja01
        WHEN 'L' FETCH LAST     t382_cs INTO g_lja.lja01
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
            FETCH ABSOLUTE g_jump t382_cs INTO g_lja.lja01
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
        INITIALIZE g_lja.* TO NULL  
        LET g_lja.lja01 = NULL      
        RETURN
    ELSE
      CASE p_fltc_hfd
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx 
    END IF
 
    SELECT * INTO g_lja.* FROM lja_file
       WHERE lja01 = g_lja.lja01 
         AND lja02 = '2'
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lja_file",g_lja.lja01,"",SQLCA.sqlcode,"","",0)  
    ELSE
        LET g_data_owner=g_lja.ljauser          
        LET g_data_group=g_lja.ljagrup
        CALL t382_show()                   
    END IF
END FUNCTION
 
FUNCTION t382_show()
    LET g_lja_t.* = g_lja.*
    
    DISPLAY BY NAME g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,g_lja.ljalegal,
                    g_lja.lja05,g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,
                    g_lja.lja131,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,
                    g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.ljamksg,
                    g_lja.lja21,g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.ljacont,
                    g_lja.lja20,g_lja.ljauser,g_lja.ljagrup,g_lja.ljaoriu,g_lja.ljamodu,
                    g_lja.ljadate,g_lja.ljaorig,g_lja.ljaacti,g_lja.ljacrat

    CALL t382_desc()
    CALL t382_pic() 
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t382_u()
    IF g_lja.lja01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lja.* FROM lja_file WHERE lja01=g_lja.lja01
    IF g_lja.ljaconf = 'Y' THEN
       CALL cl_err('','9022',0)
       RETURN
    END IF
    IF g_lja.ljaconf = 'X' THEN RETURN END IF   #CHI-C80041
    IF g_lja.ljaacti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lja01_t = g_lja.lja01
    BEGIN WORK
 
    OPEN t382_cl USING g_lja.lja01
    IF STATUS THEN
       CALL cl_err("OPEN t382_cl:", STATUS, 1)
       CLOSE t382_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t382_cl INTO g_lja.*  
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lja.lja01,SQLCA.sqlcode,1)
        RETURN
    END IF

    LET g_lja.ljamodu = g_user                  
    LET g_lja.ljadate = g_today 
              
    CALL t382_show() 
    WHILE TRUE
        CALL t382_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lja.*=g_lja_t.*
            CALL t382_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lja_file SET lja_file.* = g_lja.* 
            WHERE lja01 = g_lja_t.lja01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lja_file",g_lja.lja01,"",SQLCA.sqlcode,"","",0) 
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t382_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t382_x()
    IF g_lja.lja01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF

    IF g_lja.ljaconf = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t382_cl USING g_lja.lja01
    IF STATUS THEN
       CALL cl_err("OPEN t382_cl:", STATUS, 1)
       CLOSE t382_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t382_cl INTO g_lja.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lja.lja01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t382_show()
    IF cl_exp(0,0,g_lja.ljaacti) THEN
        LET g_chr=g_lja.ljaacti
        IF g_lja.ljaacti='Y' THEN
            LET g_lja.ljaacti='N'
        ELSE
            LET g_lja.ljaacti='Y'
        END IF
        UPDATE lja_file
            SET ljaacti=g_lja.ljaacti,
                ljamodu=g_user,
                ljadate=g_today
            WHERE lja01=g_lja.lja01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
            LET g_lja.ljaacti=g_chr
            CLOSE t382_cl
            ROLLBACK WORK
            RETURN
        END IF
   END IF
   CLOSE t382_cl
   COMMIT WORK
   SELECT ljaacti,ljamodu,ljadate
     INTO g_lja.ljaacti,g_lja.ljamodu,g_lja.ljadate FROM lja_file
    WHERE lja01=g_lja.lja01
   DISPLAY BY NAME g_lja.ljaacti,g_lja.ljamodu,g_lja.ljadate
END FUNCTION
 
FUNCTION t382_r()
    IF g_lja.lja01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_lja.ljaconf = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_lja.ljaconf = 'X' THEN RETURN END IF   #CHI-C80041
    BEGIN WORK
 
    OPEN t382_cl USING g_lja.lja01
    IF STATUS THEN
       CALL cl_err("OPEN t382_cl:", STATUS, 0)
       CLOSE t382_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t382_cl INTO g_lja.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t382_show()
    IF cl_delete() THEN
       DELETE FROM lja_file WHERE lja01 = g_lja.lja01
       CLEAR FORM
       OPEN t382_count
       FETCH t382_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t382_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t382_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE                
          CALL t382_fetch('/')
       END IF
    END IF
    CLOSE t382_cl
    COMMIT WORK
END FUNCTION

FUNCTION t382_confirm()
  DEFINE l_ljacond         LIKE lja_file.ljacond 
  DEFINE l_ljaconu         LIKE lja_file.ljaconu
  DEFINE l_ljamodu         LIKE lja_file.ljamodu
  DEFINE l_ljadate         LIKE lja_file.ljadate
  DEFINE l_lja21           LIKE lja_file.lja21
  DEFINE l_ljacont         LIKE lja_file.ljacont
  DEFINE l_gen02           LIKE gen_file.gen02     #CHI-D20015---ADD---


   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT lja_file.* INTO g_lja.* FROM lja_file
    WHERE lja01 = g_lja.lja01
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err('','alm1061',0)
      RETURN
   END IF
   IF g_lja.ljaconf = 'X' THEN RETURN END IF   #CHI-C80041
   IF g_lja.ljaacti = 'N' THEN
      CALL cl_err('','alm1067',0)
      RETURN
   END IF
 

   LET l_ljacond = g_lja.ljacond
   LET l_ljaconu = g_lja.ljaconu
   LET l_ljamodu = g_lja.ljamodu
   LET l_ljadate = g_lja.ljadate   
   LET l_lja21 = g_lja.lja21
   LET l_ljacont = g_lja.ljacont  

   IF g_lja.ljaacti ='N' THEN
      CALL cl_err(g_lja.lja01,'alm1068',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err(g_lja.lja01,'alm1069',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'X' THEN RETURN END IF   #CHI-C80041
   BEGIN WORK
 
   OPEN t382_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t382_cl:",STATUS,0)
      CLOSE t382_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t382_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t382_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   IF NOT cl_confirm("alm1070") THEN
       RETURN
   ELSE
      LET g_lja.ljaconf = 'Y'
      LET g_lja.ljacond = g_today 
      LET g_lja.ljaconu = g_user 
      LET g_lja.ljamodu = g_user
      LET g_lja.ljadate = g_today 
      LET g_lja.lja21 = '1'
      LET g_lja.ljacont = TIME 
      CALL t382_desc()
      UPDATE lja_file
         SET ljaconf = 'Y',
             ljacond = g_lja.ljacond,
             ljaconu = g_lja.ljaconu,
             ljamodu = g_lja.ljamodu,
             ljadate = g_lja.ljadate,
             lja21 = '1',
             ljacont = g_lja.ljacont
       WHERE lja01 = g_lja.lja01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lja:',SQLCA.SQLCODE,0)
         LET g_lja.ljaconf = 'N'
         LET g_lja.ljacond = l_ljacond
         LET g_lja.ljaconu = l_ljaconu
         LET g_lja.ljamodu = l_ljamodu
         LET g_lja.ljadate = l_ljadate
         LET g_lja.lja21 = l_lja21
         LET g_lja.ljadate = l_ljacont 
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
         RETURN
       ELSE
         #CHI-D20015---STR---
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lja.ljaconu
         DISPLAY l_gen02 TO FORMONLY.gen02
         #CHI-D20015---END---
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
       END IF
    END IF
    
   CLOSE t382_cl
   COMMIT WORK  
   CALL t382_pic() 
END FUNCTION

FUNCTION t382_pic()
   CASE g_lja.ljaconf
      WHEN 'Y'  LET g_confirm = 'Y'
      WHEN 'N'  LET g_confirm = 'N'
      OTHERWISE LET g_confirm = ''
   END CASE
   CALL cl_set_field_pic(g_confirm,"","","","",g_lja.ljaacti)
END FUNCTION

FUNCTION t382_unconfirm()
DEFINE l_lji01   LIKE lji_file.lji01
DEFINE l_n       LIKE type_file.num5
DEFINE l_gen02   LIKE gen_file.gen02     #CHI-D20015---ADD---
   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT lja_file.* INTO g_lja.* FROM lja_file
    WHERE lja01 = g_lja.lja01

   SELECT COUNT(*) INTO l_n FROM lji_file
    WHERE lji03 = g_lja.lja01
   IF l_n > 0 THEN
      CALL cl_err(g_lja.lja01,'alm1141',1)
      RETURN
   END IF
  
   IF g_lja.ljaacti ='N' THEN
      CALL cl_err(g_lja.lja01,'alm1071',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'N' THEN
      CALL cl_err(g_lja.lja01,'alm1072',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'X' THEN RETURN END IF   #CHI-C80041
   BEGIN WORK
 
   OPEN t382_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t382_cl:",STATUS,0)
      CLOSE t382_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t382_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t382_cl
      ROLLBACK WORK
      RETURN
   END IF
   
 
   IF NOT cl_confirm('alm1073') THEN
      RETURN
   ELSE
      UPDATE lja_file
         SET ljaconf = 'N',
             #CHI-D20015---modify---str---
             #ljacond = '',
             #ljaconu = '',
             ljacond = g_today,
             ljaconu = g_user,
             #CHI-D20015---modify---end---
             ljamodu = g_user,
             ljadate = g_today,
             lja21 = '0',
             #ljacont = ''    #CHI-D20015---mark---
             ljacont = TIME   #CHI-D20015---add---
       WHERE lja01 = g_lja.lja01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lja:',SQLCA.SQLCODE,0)
         LET g_lja.ljaconf = 'Y' 
         LET g_lja.ljacond = g_lja_t.ljacond 
         LET g_lja.ljaconu = g_lja_t.ljaconu
         LET g_lja.ljamodu = g_lja_t.ljamodu
         LET g_lja.ljadate = g_lja_t.ljadate
         LET g_lja.lja21 = g_lja_t.lja21
         LET g_lja.ljacont = g_lja_t.ljacont
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
       ELSE
         LET g_lja.ljaconf = 'N'
         #CHI-D20015---modify---str---
         #LET g_lja.ljacond = ''
         #LET g_lja.ljaconu = ''
         LET g_lja.ljacond = g_today
         LET g_lja.ljaconu = g_user
         LET g_lja.ljacont = TIME
         #CHI-D20015---modify---end---
         LET g_lja.ljamodu = g_user
         LET g_lja.ljadate = g_today 
         LET g_lja.lja21 = '0'
         #LET g_lja.ljacont = ''   #CHI-D20015---mark---
         #CHI-D20015---STR---
         #DISPLAY '' TO FORMONLY.gen02
         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=g_lja.ljaconu
         DISPLAY l_gen02 TO FORMONLY.gen02
         #CHI-D20015---END---
         DISPLAY BY NAME g_lja.ljaconf,g_lja.ljacond,g_lja.ljaconu,g_lja.ljamodu,g_lja.ljadate,g_lja.lja21,g_lja.ljacont
       END IF
    END IF 

   CLOSE t382_cl
   COMMIT WORK   
END FUNCTION

 
FUNCTION t382_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lja01",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t382_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1        
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lja01",FALSE)
    END IF

END FUNCTION


FUNCTION t382_desc()
DEFINE l_lja04_desc  LIKE gen_file.gen02
DEFINE l_rtz13       LIKE rtz_file.rtz13
DEFINE l_azt02       LIKE azt_file.azt02
DEFINE l_lne05       LIKE lne_file.lne05
DEFINE l_oba02       LIKE oba_file.oba02
DEFINE l_tqa02       LIKE tqa_file.tqa02
DEFINE l_gen02       LIKE gen_file.gen02
DEFINE l_tqa02_1     LIKE tqa_file.tqa02

   SELECT gen02 INTO l_lja04_desc FROM gen_file WHERE gen01 = g_lja.lja04
   DISPLAY l_lja04_desc TO lja04_desc

   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lja.ljaplant
   DISPLAY l_rtz13 TO rtz13

   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lja.ljalegal
   DISPLAY l_azt02 TO azt02

   SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = g_lja.lja12
   DISPLAY l_lne05 TO lne05

   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lja.lja07
   DISPLAY l_oba02 TO oba02

   #SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lja.lja13    #TQC-C30239 mark
   SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lja.lja13 AND tqa03 = '2'   #TQC-C30239  add
   DISPLAY l_tqa02 TO tqa02

   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lja.ljaconu
   DISPLAY l_gen02 TO gen02

   #SELECT tqa02 INTO l_tqa02_1 FROM tqa_file WHERE tqa01 = g_lja.lja131   #TQC-C30239 mark
   SELECT tqa02 INTO l_tqa02_1 FROM tqa_file WHERE tqa01 = g_lja.lja131 AND tqa03 = '2'   #TQC-C30239  add
   DISPLAY l_tqa02_1 TO tqa02_1

END FUNCTION


FUNCTION t382_lja04()  
   DEFINE l_gen01         LIKE gen_file.gen01,
          l_genacti       LIKE gen_file.genacti
          
   LET g_errno = ' '
   SELECT gen01,genacti 
     INTO l_gen01,l_genacti  
     FROM gen_file
    WHERE gen01 = g_lja.lja04

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
        WHEN l_genacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t382_lja05()
   DEFINE l_lnt01         LIKE lnt_file.lnt01,
          l_lnt04         LIKE lnt_file.lnt04,
          l_lnt06         LIKE lnt_file.lnt06,
          l_lnt33         LIKE lnt_file.lnt33,
          l_lnt30         LIKE lnt_file.lnt30,
          l_lnt11         LIKE lnt_file.lnt11,
          l_lnt61         LIKE lnt_file.lnt61,
          l_lnt10         LIKE lnt_file.lnt10,
          l_lnt17         LIKE lnt_file.lnt17,
          l_lnt18         LIKE lnt_file.lnt18,
          l_lnt21         LIKE lnt_file.lnt21,
          l_lnt22         LIKE lnt_file.lnt22,
          l_lnt51         LIKE lnt_file.lnt51,
          l_lnt26         LIKE lnt_file.lnt26,
          l_n             LIKE type_file.num5

   LET g_errno = ' '
   SELECT lnt01,lnt04,lnt06,lnt33,lnt30,lnt11,lnt61,lnt10,lnt17,lnt18,lnt21,lnt22,lnt51,lnt26
     INTO l_lnt01,l_lnt04,l_lnt06,l_lnt33,l_lnt30,l_lnt11,l_lnt61,l_lnt10,l_lnt17,l_lnt18,l_lnt21,l_lnt22,l_lnt51,l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lja.lja05

   IF SQLCA.SQLCODE = 100 THEN LET g_errno = 'alm1124' END IF
   IF l_lnt26 <> 'Y' THEN LET g_errno = 'alm1125' END IF

   SELECT COUNT(*) INTO l_n FROM lje_file WHERE lje04 = g_lja.lja05
   IF l_n > 0 THEN LET g_errno = 'alm1360' END IF

   IF cl_null(g_errno) THEN
      LET g_lja.lja12 = l_lnt04
      LET g_lja.lja06 = l_lnt06
      LET g_lja.lja07 = l_lnt33
      LET g_lja.lja13 = l_lnt30
      LET g_lja.lja08 = l_lnt11
      LET g_lja.lja09 = l_lnt61
      LET g_lja.lja10 = l_lnt10
      LET g_lja.lja14 = l_lnt17
      LET g_lja.lja15 = l_lnt18
      LET g_lja.lja17 = l_lnt21
      LET g_lja.lja18 = l_lnt22
      LET g_lja.lja16 = l_lnt51
      DISPLAY BY NAME g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,g_lja.lja15,g_lja.lja17,g_lja.lja18,g_lja.lja16
   END IF
END FUNCTION

FUNCTION t382_lja06()  
   DEFINE l_lmf01         LIKE lmf_file.lmf01,
          l_lmfacti       LIKE lmf_file.lmfacti,
          l_lmf06         LIKE lmf_file.lmf06
          
   LET g_errno = ' '
   SELECT lmf01,lmfacti,lmf06 
     INTO l_lmf01,l_lmfacti,l_lmf06  
     FROM lmf_file
    WHERE lmf01 = g_lja.lja06

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm-042'
        WHEN l_lmfacti = 'N'      LET g_errno = '9028'
        WHEN l_lmf06 = 'N'        LET g_errno = 'alm1063'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION t382_lja131()  
   DEFINE l_tqa01         LIKE tqa_file.tqa01,
          l_tqaacti       LIKE tqa_file.tqaacti
          
   LET g_errno = ' '
   SELECT tqa01,tqaacti 
     INTO l_tqa01,l_tqaacti  
     FROM tqa_file
    WHERE tqa01 = g_lja.lja131
      AND tqa03 = '2'

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'alm1128'
        WHEN l_tqaacti = 'N'      LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF g_lja.lja131 = g_lja.lja13 THEN  LET g_errno = 'alm1170' END IF
	
END FUNCTION
#FUN-BA0118

#FUN-CB0076-------add------str
FUNCTION t382_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lne05   LIKE lne_file.lne05,
       l_gen02   LIKE gen_file.gen02,
       l_lmf13   LIKE lmf_file.lmf13,
       l_lnt60   LIKE lnt_file.lnt60,
       l_lnt10   LIKE lnt_file.lnt10,
       l_lnt33   LIKE lnt_file.lnt33
DEFINE l_img_blob     LIKE type_file.blob
DEFINE sr        RECORD
       ljaplant  LIKE lja_file.ljaplant,
       lja01     LIKE lja_file.lja01,
       lja05     LIKE lja_file.lja05,
       lja12     LIKE lja_file.lja12,
       lja03     LIKE lja_file.lja03,
       lja14     LIKE lja_file.lja14,
       lja06     LIKE lja_file.lja06,
       lja04     LIKE lja_file.lja04,
       lja15     LIKE lja_file.lja15,
       lja20     LIKE lja_file.lja20,
       lja07     LIKE lja_file.lja07,
       lja08     LIKE lja_file.lja08,
       lja09     LIKE lja_file.lja09,
       lja10     LIKE lja_file.lja10,
       lja081    LIKE lja_file.lja081,
       lja091    LIKE lja_file.lja091,
       lja101    LIKE lja_file.lja101,
       lja17     LIKE lja_file.lja17,
       lja18     LIKE lja_file.lja18,
       lja19     LIKE lja_file.lja19,
       lja13     LIKE lja_file.lja13,
       lja131    LIKE lja_file.lja131,
       lja11     LIKE lja_file.lja11
                 END RECORD

                 
     CALL cl_del_data(l_table) 
     LOCATE l_img_blob IN MEMORY
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET l_sql = "SELECT ljaplant,lja01,lja05,lja12,lja03,lja14,lja06,lja04,",
                 "       lja15,lja20,lja07,lja08,lja09,lja10,lja081,lja091,",
                 "       lja101,lja17,lja18,lja19,lja13,lja131,lja11",
                 "  FROM lja_file",
                 " WHERE lja01 = '",g_lja.lja01,"'"
     PREPARE t382_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t382_cs1 CURSOR FOR t382_prepare1

     DISPLAY l_table
     FOREACH t382_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.ljaplant
       LET l_lne05 = ' '
       SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = sr.lja12
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lja04
       LET sr.lja17 = null
       LET sr.lja18 = null
       LET sr.lja19 = null
       LET sr.lja11 = null
       LET sr.lja08 = null
       LET sr.lja09 = null
       LET sr.lja10 = null
       LET sr.lja081 = null
       LET sr.lja091 = null
       LET sr.lja101 = null
       SELECT lmf13 INTO l_lmf13 FROM lmf_file WHERE lmf01 = sr.lja06
       SELECT lnt60,lnt10,lnt33 INTO l_lnt60,l_lnt10,l_lnt33 FROM lnt_file WHERE lnt01 = sr.lja05
       EXECUTE insert_prep USING sr.*,"",l_img_blob,"N","",l_rtz13,l_lne05,l_gen02,l_lmf13,l_lnt60,l_lnt10,l_lnt33
     END FOREACH
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "lja01"
     CALL t382_grdata()
END FUNCTION

FUNCTION t382_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF
   
   LOCATE sr1.sign_img IN MEMORY
   CALL cl_gre_init_apr()
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt382")
       IF handler IS NOT NULL THEN
           START REPORT t382_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lja01"
           DECLARE t382_datacur1 CURSOR FROM l_sql
           FOREACH t382_datacur1 INTO sr1.*
               OUTPUT TO REPORT t382_rep(sr1.*)
           END FOREACH
           FINISH REPORT t382_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t382_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno      LIKE type_file.num5
    DEFINE l_plant       STRING
    
    ORDER EXTERNAL BY sr1.lja01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
              
        BEFORE GROUP OF sr1.lja01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            PRINTX sr1.*
            LET l_plant  = sr1.ljaplant,' ',sr1.rtz13
            PRINTX l_plant

        AFTER GROUP OF sr1.lja01

        ON LAST ROW
END REPORT
#FUN-CB0076-------add------end

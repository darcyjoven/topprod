# Prog. Version..: '5.30.06-13.04.09(00005)'     #
#
# Pattern name...: almt384.4gl
# Descriptions...: 合約面積變更申請單
# Date & Author..: NO.FUN-BA0118 11/11/07 By nanbing

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20383 12/02/22 by nanbing 更改新建築面積，新測量面積，新經營面積邏
# Modify.........: No.FUN-CB0076 12/12/05 By xumeimei 添加GR打印功能
# Modify.........: No.CHI-C80041 13/01/21 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/27 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   g_lja                RECORD LIKE lja_file.*      
DEFINE   g_lja_t              RECORD LIKE lja_file.*   
DEFINE   g_wc                 STRING
DEFINE   g_sql                STRING
DEFINE   g_forupd_sql         STRING
DEFINE   g_chr                LIKE type_file.chr1     
DEFINE   g_cnt                LIKE type_file.num10    
DEFINE   g_i                  LIKE type_file.num5     
DEFINE   g_msg                LIKE ze_file.ze03       
DEFINE   g_before_input_done  LIKE type_file.num5
DEFINE   g_row_count          LIKE type_file.num10
DEFINE   g_curs_index         LIKE type_file.num10
DEFINE   g_jump               LIKE type_file.num10
DEFINE   g_no_ask             LIKE type_file.num5  
DEFINE   g_confirm            LIKE type_file.chr1
DEFINE   g_void               LIKE type_file.chr1    
DEFINE   g_t1                 LIKE oay_file.oayslip
DEFINE   li_result            LIKE type_file.num5
DEFINE   g_lua01              LIKE lua_file.lua01      
DEFINE   g_dd                 LIKE lua_file.lua09  
DEFINE   g_lla03              LIKE lla_file.lla03  
DEFINE   g_lmc11              LIKE lmc_file.lmc11 #TQC-C20383 add
DEFINE   g_lmc12              LIKE lmc_file.lmc12 #TQC-C20383 add  
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
   LET l_table = cl_prt_temptable('almt384',g_sql) CLIPPED
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
   LET g_forupd_sql = "SELECT * FROM lja_file WHERE lja01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t384_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
   OPEN WINDOW t384_w WITH FORM "alm/42f/almt384"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   SELECT lla03 INTO g_lla03 FROM lla_file
    WHERE llastore = g_plant
   LET g_action_choice = ""
   CALL t384_menu()

   CLOSE WINDOW t384_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-CB0076 add
END MAIN

FUNCTION t384_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_lja.* TO NULL
   CONSTRUCT BY NAME g_wc ON lja01,lja03,lja04,ljaplant,ljalegal,lja05,lja06,
                             lja12,lja07,lja13,lja08,lja09,lja10,lja14,lja15,
                             lja16,lja17,lja18,lja11,lja081,lja091,lja101,ljamksg,
                             lja21,ljaconf,ljaconu,ljacond,ljacont,lja20,ljauser,ljagrup,
                             ljaoriu,ljamodu,ljadate,ljaorig,ljaacti,ljacrat
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION controlp
         CASE
            WHEN INFIELD(lja01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja01"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja01
               NEXT FIELD lja01
            WHEN INFIELD(lja04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja04"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja04
               NEXT FIELD lja04
            WHEN INFIELD(ljaplant)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ljaplant" 
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ljaplant
               NEXT FIELD ljaplant
            WHEN INFIELD(ljalegal)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_ljalegal" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' " 
               DISPLAY g_qryparam.multiret TO ljalegal
               NEXT FIELD ljalegal

            WHEN INFIELD(lja05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja05"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja05
               NEXT FIELD lja05
            WHEN INFIELD(lja06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja06"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja06
               NEXT FIELD lja06
            WHEN INFIELD(lja07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja07"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' " 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja07
               NEXT FIELD lja07
            WHEN INFIELD(lja12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja12"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja12
               NEXT FIELD lja12
            WHEN INFIELD(lja13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja13"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lja13
               NEXT FIELD lja13
            WHEN INFIELD(ljaconu)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_ljaconu"
               LET g_qryparam.where = " ljaplant IN ",g_auth," ",
                                      " AND lja02 = '4' "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ljaconu
               NEXT FIELD ljaconu                 
            END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      ON ACTION about
         CALL cl_about()
      ON ACTION HELP
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ljauser', 'ljagrup')
   LET g_wc = g_wc," AND lja02 = '4' " CLIPPED
   LET g_sql = "SELECT lja01 FROM lja_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND ljaplant IN ",g_auth,
               " ORDER BY lja01"

   PREPARE t384_prepare FROM g_sql
   DECLARE t384_cs
      SCROLL CURSOR WITH HOLD FOR t384_prepare
   
   LET g_sql = "SELECT COUNT(*) FROM lja_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND ljaplant IN ",g_auth

   PREPARE t384_precount FROM g_sql
   DECLARE t384_count CURSOR FOR t384_precount

END FUNCTION

FUNCTION t384_menu()
DEFINE l_msg        LIKE type_file.chr1000
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index,g_row_count)

         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t384_a()
            END IF
   
         ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t384_q()
            END IF

         #FUN-CB0076------add----str
         ON ACTION OUTPUT
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL t384_out()
            END IF
         #FUN-CB0076------add----end
         ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t384_u()
            END IF

         ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL t384_x()
            END IF
            CALL t384_pic()

         ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t384_r()
            END IF

         ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t384_confirm()
            END IF
            CALL t384_pic()
         ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t384_undoconfirm()
            END IF      
         ON ACTION help
            CALL cl_show_help()
            
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
   
         ON ACTION next
            CALL t384_fetch('N')
   
         ON ACTION previous
            CALL t384_fetch('P')

         ON ACTION jump
            CALL t384_fetch('/')
            
         ON ACTION first
            CALL t384_fetch('F')
            
         ON ACTION last
            CALL t384_fetch('L')

         ON ACTION controlg
            CALL cl_cmdask()
            
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            CALL t384_pic()
             
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
        
         ON ACTION about 
            CALL cl_about() 
        
         ON ACTION close
            LET INT_FLAG = FALSE
            LET g_action_choice = "exit"
            EXIT MENU 
         ON ACTION related_document 
            LET g_action_choice="related_document"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lja.lja01) THEN
                  LET g_doc.column1 = "lja01"
                  LET g_doc.value1 = g_lja.lja01
                  CALL cl_doc()
               END IF
            END IF
   END MENU
   CLOSE t384_cs
END FUNCTION

FUNCTION t384_q()

    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE g_lja.* TO NULL
    INITIALIZE g_lja_t.* TO NULL

    LET g_wc = NULL

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt

    CALL t384_cs()

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lja.* TO NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN t384_count
    FETCH t384_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt

    OPEN t384_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
       INITIALIZE g_lja.* TO NULL
       LET g_wc = NULL
    ELSE
       CALL t384_fetch('F')
    END IF
END FUNCTION

FUNCTION t384_fetch(p_flag)
DEFINE p_flag LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t384_cs INTO g_lja.lja01
      WHEN 'P' FETCH PREVIOUS t384_cs INTO g_lja.lja01
      WHEN 'F' FETCH FIRST    t384_cs INTO g_lja.lja01
      WHEN 'L' FETCH LAST     t384_cs INTO g_lja.lja01
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
         FETCH ABSOLUTE g_jump t384_cs INTO g_lja.lja01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      INITIALIZE g_lja.* TO NULL
      RETURN
   ELSE
     CASE p_flag
        WHEN 'F' LET g_curs_index = 1
        WHEN 'P' LET g_curs_index = g_curs_index - 1
        WHEN 'N' LET g_curs_index = g_curs_index + 1
        WHEN 'L' LET g_curs_index = g_row_count
        WHEN '/' LET g_curs_index = g_jump
     END CASE

     CALL cl_navigator_setting(g_curs_index,g_row_count)
     DISPLAY g_curs_index TO  FORMONLY.idx
   END IF

   SELECT * INTO g_lja.* FROM lja_file
    WHERE lja01 = g_lja.lja01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_lja.ljauser
      LET g_data_group = g_lja.ljagrup
      CALL t384_show()
   END IF
END FUNCTION
FUNCTION t384_show()

   LET g_lja_t.* = g_lja.*
   DISPLAY BY NAME g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,
                   g_lja.ljalegal,g_lja.lja05,g_lja.lja06,g_lja.lja12,g_lja.lja07,
                   g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,
                   g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.lja11,
                   g_lja.lja081,g_lja.lja091,g_lja.lja101,g_lja.ljamksg,g_lja.lja21,
                   g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.lja20,g_lja.ljauser,
                   g_lja.ljagrup,g_lja.ljaoriu,g_lja.ljamodu,g_lja.ljadate,g_lja.ljaorig,
                   g_lja.ljaacti,g_lja.ljacrat,g_lja.ljacont
   CALL t384_ljaplant('d')                   
   CALL t384_desc()
   CALL t384_pic()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t384_a()
DEFINE l_rtz13 LIKE rtz_file.rtz13
DEFINE l_azt02 LIKE azt_file.azt02

   MESSAGE ""
   CLEAR FORM    
   INITIALIZE g_lja.*    LIKE lja_file.*
   INITIALIZE g_lja_t.*  LIKE lja_file.*
    
   LET g_wc = NULL
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_lja.ljauser = g_user
      LET g_lja.ljaoriu = g_user
      LET g_lja.ljaorig = g_grup
      LET g_lja.ljagrup = g_grup
      LET g_lja.ljacrat = g_today
      LET g_lja.ljaacti = 'Y'
      LET g_lja.lja02 = '4'
      LET g_lja.lja04 = g_user
      LET g_lja.ljaplant = g_plant
      LET g_lja.ljalegal = g_legal
      LET g_lja.lja03 = g_today
      LET g_lja.ljamksg = 'N'
      LET g_lja.lja21 = '0'
      LET g_lja.ljaconf = 'N'
      LET g_lmc11 = ''   #TQC-C20383
      LET g_lmc12 = ''   #TQC-C20383
      CALL t384_ljaplant("a")
      CALL t384_i("a")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         INITIALIZE g_lja.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
      IF cl_null(g_lja.lja01) THEN
         CONTINUE WHILE
      END IF
      CALL s_auto_assign_no("alm",g_lja.lja01,g_today,"P7","lja_file","lja01","","","")
         RETURNING li_result,g_lja.lja01
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF
      DISPLAY BY NAME g_lja.lja01

      INSERT INTO lja_file VALUES(g_lja.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lja.lja01,SQLCA.SQLCODE,0)
         CONTINUE WHILE
      ELSE
         SELECT * INTO g_lja.* FROM lja_file
          WHERE lja01 = g_lja.lja01
      END IF
      EXIT WHILE
   END WHILE
   LET g_wc = NULL
END FUNCTION

FUNCTION t384_i(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_t        LIKE type_file.chr1
   DISPLAY BY NAME g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,
                   g_lja.ljalegal,g_lja.lja05,g_lja.lja06,g_lja.lja12,g_lja.lja07,
                   g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,
                   g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.lja11,
                   g_lja.lja081,g_lja.lja091,g_lja.lja101,g_lja.ljamksg,g_lja.lja21,
                   g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.lja20,g_lja.ljauser,
                   g_lja.ljagrup,g_lja.ljaoriu,g_lja.ljamodu,g_lja.ljadate,g_lja.ljaorig,
                   g_lja.ljaacti,g_lja.ljacrat
              
   CALL t384_desc()     
   INPUT BY NAME   g_lja.lja01,g_lja.lja03,g_lja.lja04,g_lja.ljaplant,
                   g_lja.ljalegal,g_lja.lja05,g_lja.lja06,g_lja.lja12,g_lja.lja07,
                   g_lja.lja13,g_lja.lja08,g_lja.lja09,g_lja.lja10,g_lja.lja14,
                   g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18,g_lja.lja11,
                   g_lja.lja081,g_lja.lja091,g_lja.lja101,g_lja.ljamksg,g_lja.lja21,
                   g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.lja20,g_lja.ljauser,
                   g_lja.ljagrup,g_lja.ljaoriu,g_lja.ljamodu,g_lja.ljadate,g_lja.ljaorig,
                   g_lja.ljaacti,g_lja.ljacrat
                      WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t384_set_entry(p_cmd)
         CALL t384_set_no_entry(p_cmd)
         CALL cl_set_docno_format("lja01")
         #TQC-C20383 STA
         CALL cl_set_comp_entry("lja081",TRUE)
         IF NOT cl_null(g_lja.lja06) THEN 
            CALL t384_lja06_chk()
         END IF    
         #TQC-C20383 END
      AFTER FIELD lja01
         IF NOT cl_null(g_lja.lja01) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lja_t.lja01 <> g_lja.lja01) THEN
               CALL s_check_no("alm",g_lja.lja01,g_lja_t.lja01,"P7","lja_file","lja01,ljaplant","")
                  RETURNING li_result,g_lja.lja01
               IF (NOT li_result) THEN
                  LET g_lja.lja01 = g_lja_t.lja01
                  NEXT FIELD lja01
               END IF
               LET g_t1=s_get_doc_no(g_lja.lja01)
               SELECT oayapr INTO g_lja.ljamksg FROM oay_file WHERE oayslip = g_t1
               DISPLAY BY NAME g_lja.ljamksg
            END IF
         END IF  
      AFTER FIELD lja03
         IF NOT cl_null(g_lja.lja03) THEN
            CALL t384_lja03()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lja.lja03 = g_lja_t.lja03
               DISPLAY BY NAME g_lja.lja03
               NEXT FIELD lja03
            END IF
         END IF        

      AFTER FIELD lja04
         IF NOT cl_null(g_lja.lja04) THEN
            CALL t384_lja04(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lja.lja04 = g_lja_t.lja04
               DISPLAY BY NAME g_lja.lja04
               NEXT FIELD lja04
            END IF
         END IF      
      AFTER FIELD lja05
         IF NOT cl_null(g_lja.lja05) THEN
            CALL t384_lja05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lja.lja05 = g_lja_t.lja05
               DISPLAY BY NAME g_lja.lja05
               NEXT FIELD lja05
            END IF
            IF NOT cl_null(g_lja.lja11) THEN          
               IF g_lja.lja11 < g_lja.lja14 OR g_lja.lja11 > g_lja.lja15 THEN
                  CALL cl_err('','alm1171',0)
                  LET g_lja.lja11 = g_lja_t.lja11
                  DISPLAY BY NAME g_lja.lja11
                  NEXT FIELD lja11
               END IF
            END IF    
         END IF  
      AFTER FIELD lja11
         IF NOT cl_null(g_lja.lja11) AND NOT cl_null(g_lja.lja05) THEN          
            IF g_lja.lja11 < g_lja.lja14 OR g_lja.lja11 > g_lja.lja15 THEN
               CALL cl_err('','alm1171',0)
               LET g_lja.lja11 = g_lja_t.lja11
               DISPLAY BY NAME g_lja.lja11
               NEXT FIELD lja11
            END IF
         END IF      
      AFTER FIELD lja081
         IF NOT cl_null(g_lja.lja081) THEN          
            IF g_lja.lja081 < 0  THEN
               CALL cl_err('','alm-808',0)
               LET g_lja.lja081 = g_lja_t.lja081
               DISPLAY BY NAME g_lja.lja081
               NEXT FIELD lja081
            END IF
            CALL cl_digcut(g_lja.lja081,g_lla03) RETURNING g_lja.lja081
         END IF            
      AFTER FIELD lja091
         IF NOT cl_null(g_lja.lja091) THEN          
            IF g_lja.lja091 <= 0  THEN
               CALL cl_err('','alm-808',0)
               LET g_lja.lja081 = g_lja_t.lja091
               DISPLAY BY NAME g_lja.lja091
               NEXT FIELD lja091
            END IF
            #TQC-C20383 STA ---
            IF NOT cl_null(g_lmc11) THEN
               LET g_lja.lja081 = g_lja.lja091 / (1 - g_lmc11/100)
               LET g_lja.lja081 = cl_digcut(g_lja.lja081,g_lla03) 
               DISPLAY BY NAME g_lja.lja081
            END IF
            IF NOT cl_null(g_lmc12) THEN 
               IF g_lmc12 = 0 THEN 
                  LET g_lmc12 = 1
               END IF 
               LET g_lja.lja101 = g_lja.lja091 * g_lmc12
               LET g_lja.lja101 = cl_digcut(g_lja.lja101,g_lla03) 
               DISPLAY BY NAME g_lja.lja101
            END IF    
            #TQC-C20383 END ---
            CALL cl_digcut(g_lja.lja091,g_lla03) RETURNING g_lja.lja091
         END IF             
      AFTER FIELD lja101
         IF NOT cl_null(g_lja.lja101) THEN          
            IF g_lja.lja101 <= 0  THEN
               CALL cl_err('','alm-808',0)
               LET g_lja.lja101 = g_lja_t.lja101
               DISPLAY BY NAME g_lja.lja101
               NEXT FIELD lja101
            END IF
            #TQC-C20383 STA ---
            
            IF NOT cl_null(g_lmc12) THEN 
               IF g_lmc12 = 0 THEN 
                  LET g_lmc12 = 1
               END IF 
               LET g_lja.lja091 = g_lja.lja101 / g_lmc12
               LET g_lja.lja091 = cl_digcut(g_lja.lja091,g_lla03) 
               DISPLAY BY NAME g_lja.lja091
            END IF    
            IF NOT cl_null(g_lmc11) THEN
               LET g_lja.lja081 = g_lja.lja091 / (1 - g_lmc11/100)
               LET g_lja.lja081 = cl_digcut(g_lja.lja081,g_lla03) 
               DISPLAY BY NAME g_lja.lja081
            END IF 
            #TQC-C20383 END ---
            CALL cl_digcut(g_lja.lja101,g_lla03) RETURNING g_lja.lja101
         END IF             
      AFTER INPUT
         LET g_lja.ljauser = s_get_data_owner("lja_file") #FUN-C10039
         LET g_lja.ljagrup = s_get_data_group("lja_file") #FUN-C10039
         IF INT_FLAG THEN          
            EXIT INPUT
         END IF  
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(lja01)
               LET g_t1=s_get_doc_no(g_lja.lja01)
               CALL q_oay(FALSE,FALSE,g_t1,'P7','alm') RETURNING g_t1
               LET g_lja.lja01 = g_t1
               DISPLAY BY NAME g_lja.lja01
               NEXT FIELD lja01
            WHEN INFIELD(lja04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               CALL cl_create_qry() RETURNING g_lja.lja04
               DISPLAY BY NAME g_lja.lja04
               CALL t384_lja04('d')
               NEXT FIELD lja04    
            WHEN INFIELD(lja05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lnt"
               CALL cl_create_qry() RETURNING g_lja.lja05
               DISPLAY BY NAME g_lja.lja05
               CALL t384_lja05()
               NEXT FIELD lja05                
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
FUNCTION t384_u()

   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
   SELECT * INTO g_lja.* FROM lja_file WHERE lja01 = g_lja.lja01   
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err(g_lja.lja01,'alm-027',1)
      RETURN
   END IF 
   IF g_lja.ljaconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.ljaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   IF g_lja.ljaacti = 'N' THEN
      CALL cl_err(g_lja.lja01,9027,0)
      RETURN
   END IF
       
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK

   OPEN t384_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t384_cl:",STATUS,1)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t384_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,1)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL t384_show()
   WHILE TRUE
      LET g_lja_t.* = g_lja.*
      LET g_lja.ljamodu=g_user
      LET g_lja.ljadate=g_today

      CALL t384_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lja.*=g_lja_t.*
         CALL t384_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE lja_file SET lja_file.* = g_lja.*
       WHERE lja01 = g_lja_t.lja01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t384_cl
   COMMIT WORK
END FUNCTION

FUNCTION t384_x()

   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err(g_lja.lja01,'alm-027',1)
      RETURN
   END IF

   BEGIN WORK

   OPEN t384_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t384_cl:",STATUS,1)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t384_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,1)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t384_show()

   IF cl_exp(0,0,g_lja.ljaacti) THEN
      LET g_chr=g_lja.ljaacti
      IF g_lja.ljaacti='Y' THEN
         LET g_lja.ljaacti='N'
         LET g_lja.ljamodu = g_user
         LET g_lja.ljadate = g_today
      ELSE
         LET g_lja.ljaacti='Y'
         LET g_lja.ljamodu = g_user
         LET g_lja.ljadate = g_today
      END IF
      UPDATE lja_file SET ljaacti = g_lja.ljaacti,
                          ljamodu = g_lja.ljamodu,
                          ljadate = g_lja.ljadate
       WHERE lja01 = g_lja.lja01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
         LET g_lja.ljaacti = g_chr
         DISPLAY BY NAME g_lja.ljaacti
         CLOSE t384_cl
         ROLLBACK WORK
         RETURN
      END IF
      DISPLAY BY NAME g_lja.ljamodu,g_lja.ljadate,g_lja.ljaacti
   END IF
   CLOSE t384_cl
   COMMIT WORK
END FUNCTION

FUNCTION t384_r()

   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lja.* FROM lja_file WHERE lja01 = g_lja.lja01   

   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err(g_lja.lja01,'alm-028',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.ljaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   BEGIN WORK

   OPEN t384_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t384_cl:",STATUS,0)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t384_cl INTO g_lja.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t384_show()

   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "lja01"
      LET g_doc.value1 = g_lja.lja01
      CALL cl_del_doc()
      DELETE FROM lja_file WHERE lja01 = g_lja.lja01
      CLEAR FORM
      OPEN t384_count
      IF STATUS THEN
         CLOSE t384_cs
         CLOSE t384_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t384_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t384_cs
         CLOSE t384_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t384_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t384_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t384_fetch('/')
      END IF
   END IF
   CLOSE t384_cl
   COMMIT WORK
END FUNCTION

FUNCTION t384_confirm()
DEFINE l_t        LIKE type_file.chr1,
       l_gen02_1  LIKE gen_file.gen02
   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lja.* FROM lja_file
    WHERE lja01 = g_lja.lja01

   IF g_lja.ljaacti ='N' THEN
      CALL cl_err(g_lja.lja01,'alm-004',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'Y' THEN
      CALL cl_err(g_lja.ljaconf,'alm-005',1)
      RETURN
   END IF
   IF g_lja.ljaconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.ljaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF
   ###########
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
   
   BEGIN WORK 
   LET g_success = 'Y'

   OPEN t384_cl USING g_lja.lja01
   IF STATUS THEN 
      CALL cl_err("open t384_cl:",STATUS,1)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF 
   FETCH t384_cl INTO g_lja.*
   IF SQLCA.sqlcode  THEN 
     CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
     CLOSE t384_cl
     ROLLBACK WORK
     RETURN
   END IF
   ####
  # CALL t384_chk()
  LET g_lja.ljacont = TIME 
   UPDATE lja_file SET ljaconf = 'Y',
                       lja21   = '1',
                       ljacont = g_lja.ljacont,
                       ljaconu = g_user,
                       ljacond = g_today,
                       ljamodu = g_user,
                       ljadate = g_today
    WHERE lja01 = g_lja.lja01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lja:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
      LET g_lja.ljacont = ''
   ELSE
      LET g_lja.ljaconf = 'Y'
      LET g_lja.ljaconu = g_user
      LET g_lja.ljacond = g_today
      LET g_lja.ljacont = TIME 
      LET g_lja.lja21 = '1'
      LET g_lja.ljamodu = g_user
      LET g_lja.ljadate = g_today
      DISPLAY BY NAME g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.ljacont,g_lja.lja21,
                      g_lja.ljamodu,g_lja.ljadate
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lja.ljaconu
      DISPLAY l_gen02_1 TO gen02_1                      
      CALL cl_set_field_pic(g_lja.ljaconf,g_lja.lja21,"","","",g_lja.ljaacti)                
   END IF 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lja.* FROM lja_file WHERE lja01 = g_lja.lja01
   DISPLAY BY NAME g_lja.*
   CLOSE t384_cl
   COMMIT WORK
   MESSAGE ""
END FUNCTION
FUNCTION t384_undoconfirm()                     #取消審核
DEFINE l_gen02_1  LIKE gen_file.gen02  #CHI-D20015---ADD---
   IF cl_null(g_lja.lja01) THEN
      CALL cl_err('','-400',0)
      RETURN
   END IF

   SELECT * INTO g_lja.*
   FROM lja_file
   WHERE lja01=g_lja.lja01
   IF g_lja.ljaplant <> g_plant THEN
        CALL cl_err('','alm1023',0)
        RETURN
   END IF   
   IF g_lja.ljaacti='N' THEN
      CALL cl_err('','alm-004',0)
      RETURN
   END IF

   IF g_lja.ljaconf='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_lja.ljaconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_lja.lja21='2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t384_cl USING g_lja.lja01
   IF STATUS THEN
      CALL cl_err("OPEN t384_cl:", STATUS, 1)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t384_cl INTO g_lja.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lja.lja01,SQLCA.sqlcode,0)
      CLOSE t384_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t384_chk()
   IF NOT cl_null(g_errno) THEN 
      CALL cl_err('',g_errno,0)
      RETURN
   END IF    
   IF NOT cl_confirm('alm-008') THEN
        RETURN
   END IF

   #UPDATE lja_file SET ljaconf = 'N',ljaconu = '',ljacond = '',ljacont = '',lja21 = '0',  #CHI-D20015---mark---
   UPDATE lja_file SET ljaconf = 'N',ljaconu = g_user,ljacond = g_today,ljacont = TIME,lja21 = '0',  #CHI-D20015---add---
                     ljamodu = g_user,ljadate = g_today
    WHERE lja01 = g_lja.lja01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lja_file",g_lja.lja01,"",STATUS,"","",1)
      LET g_success = 'N'
   ELSE
      LET g_lja.ljaconf = 'N'
      #CHI-D20015---MODIFY---STR---
      #LET g_lja.ljaconu = ''
      #LET g_lja.ljacond = ''
      #LET g_lja.ljacont = ''
      LET g_lja.ljaconu = g_user
      LET g_lja.ljacond = g_today
      LET g_lja.ljacont = TIME
      #CHI-D20015---MODIFY---END---
      LET g_lja.lja21 = '0'
      LET g_lja.ljamodu = g_user
      LET g_lja.ljadate = g_today
      DISPLAY BY NAME g_lja.ljaconf,g_lja.ljaconu,g_lja.ljacond,g_lja.ljacont,g_lja.lja21,
                      g_lja.ljamodu,g_lja.ljadate
      #CHI-D20015---MODIFY---STR---
      #DISPLAY '' TO gen02_1    
      SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lja.ljaconu
      DISPLAY l_gen02_1 TO gen02
      #CHI-D20015---MODIFY---END---            
      CALL cl_set_field_pic(g_lja.ljaconf,g_lja.lja21,"","","",g_lja.ljaacti)                
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   END IF 
END FUNCTION 
FUNCTION t384_chk()
DEFINE l_n   LIKE type_file.num5
   LET g_errno = ''
   SELECT COUNT(*) INTO l_n FROM lji_file
    WHERE lji03 = g_lja.lja01 
   IF l_n > 0 THEN 
      LET g_errno = 'alm1141'
      RETURN 
   END IF    
   SELECT COUNT(*) INTO l_n FROM lib_file
    WHERE lib04 = g_lja.lja01 
   IF l_n > 0 THEN 
      LET g_errno = 'alm1143'
      RETURN 
   END IF 
   SELECT COUNT(*) INTO l_n FROM lja_file
    WHERE lja06 = g_lja.lja01
   IF l_n > 0 THEN 
      LET g_errno = 'alm1142'
      RETURN 
   END IF     
END FUNCTION 
FUNCTION t384_ljaplant(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1, 
   l_rtz01    LIKE rtz_file.rtz01,   
   l_rtz13    LIKE rtz_file.rtz13,  
   l_rtz28    LIKE rtz_file.rtz28,   
   l_azwacti  LIKE azw_file.azwacti,  
   l_azt02    LIKE azt_file.azt02
 
   LET g_errno=''
   SELECT rtz01,rtz13,rtz28,azwacti                        
     INTO l_rtz01,l_rtz13,l_rtz28,l_azwacti               
     FROM rtz_file INNER JOIN azw_file                     
       ON rtz01 = azw01                                     
    WHERE rtz01=g_lja.ljaplant
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='alm-001'
                                LET l_rtz13=NULL
       WHEN l_azwacti = 'N'     LET g_errno='9028'           
       WHEN l_rtz28='N'         LET g_errno='alm-002'
       WHEN l_rtz01 <> g_plant  LET g_errno='alm-376'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lja.ljalegal
 
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION

FUNCTION t384_lja03()
DEFINE l_sma53  LIKE sma_file.sma53 
   LET g_errno = ''
   SELECT sma53 INTO l_sma53 FROM sma_file
   IF l_sma53 > g_lja.lja03 THEN 
      LET g_errno = 'alm1140'
   END IF    
END FUNCTION
FUNCTION t384_lja04(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_gen02   LIKE gen_file.gen02,#員工姓名
       l_genacti LIKE gen_file.genacti
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_lja.lja04
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'art-241'
      WHEN l_genacti = 'N'       LET g_errno = 'alm1151'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02   
   END IF   

END FUNCTION
FUNCTION t384_lja05()
DEFINE    
          l_lnt04         LIKE lnt_file.lnt04,
          l_lnt06         LIKE lnt_file.lnt06,
          l_lnt33         LIKE lnt_file.lnt33,
          l_lnt30         LIKE lnt_file.lnt30,
          l_lnt11         LIKE lnt_file.lnt11,
          l_lnt61         LIKE lnt_file.lnt61,
          l_lnt10         LIKE lnt_file.lnt10,
          l_lnt17         LIKE lnt_file.lnt17,
          l_lnt18         LIKE lnt_file.lnt18,
          l_lnt51         LIKE lnt_file.lnt51,
          l_lnt21         LIKE lnt_file.lnt21,
          l_lnt22         LIKE lnt_file.lnt22,         
          l_lnt26         LIKE lnt_file.lnt26
DEFINE    l_n             LIKE type_file.num5
   LET g_errno = ' '
   SELECT COUNT(*) INTO l_n FROM lje_file
    WHERE lje04 = g_lja.lja05
   IF l_n > 0 THEN
      LET g_errno = 'alm1360'
      RETURN
   END IF
   SELECT lnt06,lnt04,lnt33,lnt30,lnt11,lnt61,lnt10,lnt17,lnt18,lnt51,lnt21,lnt22,lnt26
     INTO l_lnt06,l_lnt04,l_lnt33,l_lnt30,l_lnt11,l_lnt61,l_lnt10,l_lnt17,l_lnt18,l_lnt51,l_lnt21,l_lnt22,l_lnt26
     FROM lnt_file
    WHERE lnt01 = g_lja.lja05
   CASE 
      WHEN  SQLCA.SQLCODE = 100   LET g_errno = 'alm1124'
      WHEN  l_lnt26 <> 'Y'        LET g_errno = 'alm1125'
      WHEN  l_lnt18 < g_today     LET g_errno = 'alm1136'
   END CASE    
   IF cl_null(g_errno) THEN
      LET g_lja.lja06 = l_lnt06
      LET g_lja.lja12 = l_lnt04
      LET g_lja.lja07 = l_lnt33
      LET g_lja.lja13 = l_lnt30
      LET g_lja.lja08 = l_lnt11
      LET g_lja.lja09 = l_lnt61
      LET g_lja.lja10 = l_lnt10
      LET g_lja.lja14 = l_lnt17
      LET g_lja.lja15 = l_lnt18
      LET g_lja.lja16 = l_lnt51
      LET g_lja.lja17 = l_lnt21
      LET g_lja.lja18 = l_lnt22
      
      DISPLAY BY NAME g_lja.lja06,g_lja.lja12,g_lja.lja07,g_lja.lja13,g_lja.lja08,
          g_lja.lja09,g_lja.lja10,g_lja.lja14,g_lja.lja15,g_lja.lja16,g_lja.lja17,g_lja.lja18
          
      CALL t384_desc() 
      #TQC-C20383 STA ---
      IF cl_null(g_lja_t.lja05) OR g_lja_t.lja05 <> g_lja.lja05 THEN 
         INITIALIZE g_lja.lja081 TO NULL 
         INITIALIZE g_lja.lja091 TO NULL 
         INITIALIZE g_lja.lja101 TO NULL 
         DISPLAY BY NAME g_lja.lja081,g_lja.lja091,g_lja.lja101
         CALL t384_lja06_chk() 
      END IF  
      #TQC-C20383 END ---    
   END IF
END FUNCTION

FUNCTION t384_desc()
DEFINE l_gen02       LIKE gen_file.gen02
DEFINE l_rtz13       LIKE rtz_file.rtz13
DEFINE l_azt02       LIKE azt_file.azt02
DEFINE l_lne05       LIKE lne_file.lne05
DEFINE l_oba02       LIKE oba_file.oba02
DEFINE l_tqa02       LIKE tqa_file.tqa02
DEFINE l_gen02_1     LIKE gen_file.gen02


   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lja.lja04
   DISPLAY l_gen02 TO gen02

   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lja.ljaplant
   DISPLAY l_rtz13 TO rtz13

   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lja.ljalegal
   DISPLAY l_azt02 TO azt02

   SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = g_lja.lja12
   DISPLAY l_lne05 TO lne05

   SELECT oba02 INTO l_oba02 FROM oba_file WHERE oba01 = g_lja.lja07
   DISPLAY l_oba02 TO oba02

   SELECT tqa02 INTO l_tqa02 FROM tqa_file WHERE tqa01 = g_lja.lja13
   DISPLAY l_tqa02 TO tqa02

   SELECT gen02 INTO l_gen02_1 FROM gen_file WHERE gen01 = g_lja.ljaconu
   DISPLAY l_gen02_1 TO gen02_1

END FUNCTION
FUNCTION t384_ljaconf()     
DEFINE  l_gen02   LIKE gen_file.gen02#員工姓名

   SELECT gen02 INTO l_gen02
     FROM gen_file
    WHERE gen01 = g_lja.ljaconf
   DISPLAY l_gen02 TO FORMONLY.gen02_1   
END FUNCTION

FUNCTION t384_pic()  
   CALL cl_set_field_pic(g_lja.ljaconf,g_lja.lja21,"","","",g_lja.ljaacti)
END FUNCTION
FUNCTION t384_set_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lja01",TRUE)
   END IF
END FUNCTION

FUNCTION t384_set_no_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lja01",FALSE)
   END IF
END FUNCTION
#TQC-C20383 STA ---
FUNCTION t384_lja06_chk()
DEFINE l_lmf03      LIKE lmf_file.lmf03
DEFINE l_n          LIKE type_file.num5  
DEFINE l_n1         LIKE type_file.num5   
   SELECT lmf03 INTO l_lmf03 FROM lmf_file
    WHERE lmf01 = g_lja.lja06
   LET l_n = 0 
   SELECT COUNT(DISTINCT lmc11) INTO l_n FROM lmc_file
    WHERE lmc02 = l_lmf03 
      AND lmcstore = g_lja.ljaplant
      AND lmc03 IN ( SELECT lie03 FROM lie_file 
                      WHERE lie01 = g_lja.lja06)
   IF l_n = 1 THEN 
     #可能是建築公攤率全部相同，也可能是存在為空的建築公攤率
      SELECT COUNT(lmc12) INTO l_n1 FROM lmc_file
       WHERE lmc02 = l_lmf03 
         AND lmcstore = g_lja.ljaplant
         AND lmc03 IN ( SELECT lie03 FROM lie_file 
                         WHERE lie01 = g_lja.lja06)
         AND lmc11 IS NULL
      IF l_n1 > 0 THEN   
         LET g_lmc11 = '' 
         CALL cl_set_comp_entry('lja081',TRUE) 
      ELSE
         SELECT DISTINCT lmc11 INTO g_lmc11 FROM lmc_file
          WHERE lmc02 = l_lmf03 
            AND lmcstore = g_lja.ljaplant
            AND lmc03 IN ( SELECT lie03 FROM lie_file 
                            WHERE lie01 = g_lja.lja06 )     
         CALL cl_set_comp_entry('lja081',FALSE) 
      END IF    
   END IF    
   #存在不同的建築公攤率，且不為空的建築公攤率大於1個   
   IF l_n > 1 THEN 
      LET g_lmc11 = ''
      CALL cl_set_comp_entry('lja081',TRUE) 
   END IF 
   #建築公攤率都為空
   IF l_n = 0 THEN 
      LET g_lja.lja081 = ''
      DISPLAY BY NAME g_lja.lja081     
      CALL cl_set_comp_entry('lja081',FALSE)  
   END IF    
   LET l_n = 0
   SELECT COUNT(DISTINCT lmc12) INTO l_n FROM lmc_file
    WHERE lmc02 = l_lmf03 
      AND lmcstore = g_lja.ljaplant
      AND lmc03 IN ( SELECT lie03 FROM lie_file 
                      WHERE lie01 = g_lja.lja06)
   IF l_n = 1 THEN 
      SELECT DISTINCT lmc12 INTO g_lmc12 FROM lmc_file
       WHERE lmc02 = l_lmf03 
         AND lmcstore = g_lja.ljaplant
         AND lmc03 IN ( SELECT lie03 FROM lie_file 
                         WHERE lie01 = g_lja.lja06)
   ELSE
      LET g_lmc12 = ''
   END IF 
END FUNCTION 
#TQC-C20383 END ---
#FUN-BA0118   
#FUN-CB0076-------add------str
FUNCTION t384_out()
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
     PREPARE t384_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time
        CALL cl_gre_drop_temptable(l_table)
        EXIT PROGRAM
     END IF
     DECLARE t384_cs1 CURSOR FOR t384_prepare1

     DISPLAY l_table
     FOREACH t384_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.ljaplant
       LET l_lne05 = ' '
       SELECT lne05 INTO l_lne05 FROM lne_file WHERE lne01 = sr.lja12
       LET l_gen02 = ' '
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.lja04
       LET sr.lja13 = null
       LET sr.lja131 = null
       LET sr.lja17 = null
       LET sr.lja18 = null
       LET sr.lja19 = null
       SELECT lmf13 INTO l_lmf13 FROM lmf_file WHERE lmf01 = sr.lja06
       SELECT lnt60,lnt10,lnt33 INTO l_lnt60,l_lnt10,l_lnt33 FROM lnt_file WHERE lnt01 = sr.lja05
       EXECUTE insert_prep USING sr.*,"",l_img_blob,"N","",l_rtz13,l_lne05,l_gen02,l_lmf13,l_lnt60,l_lnt10,l_lnt33
     END FOREACH
     LET g_cr_table = l_table
     LET g_cr_apr_key_f = "lja01"
     CALL t384_grdata()
END FUNCTION

FUNCTION t384_grdata()
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
       LET handler = cl_gre_outnam("almt384")
       IF handler IS NOT NULL THEN
           START REPORT t384_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lja01"
           DECLARE t384_datacur1 CURSOR FROM l_sql
           FOREACH t384_datacur1 INTO sr1.*
               OUTPUT TO REPORT t384_rep(sr1.*)
           END FOREACH
           FINISH REPORT t384_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t384_rep(sr1)
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

# Prog. Version..: '5.30.06-13.04.09(00006)'     #
#
# Pattern name...: almt130.4gl
# Descriptions...: 場地變更申請作業
# Date & Author..: No.FUN-B80141 11/08/24 By baogc
# Modify.........: No.FUN-BA0118 11/10/31 By baogc 添加面積變更申請邏輯
# Modify.........: No.FUN-B80141 11/11/11 By baogc 面積小數位按照alms101中的設定來取位
# Modify.........: No.FUN-B90121 12/01/13 By baogc BUG修改

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20528 12/02/29 By baogc 變更申請單邏輯修改
# Modify.........: No.CHI-C80041 13/01/04 By bart 排除作廢
# Modify.........: No.CHI-D20015 13/03/26 By fengrui 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE   g_lia                RECORD LIKE lia_file.*       #單頭表RECORD
DEFINE   g_lia_t              RECORD LIKE lia_file.*       #舊值
DEFINE   g_argv1              LIKE lia_file.liaplant       #門店編號
DEFINE   g_argv2              LIKE lia_file.lia07          #樓棟編號
DEFINE   g_argv3              LIKE lia_file.lia08          #樓層編號
DEFINE   g_argv4              LIKE lia_file.lia09          #區域編號
DEFINE   g_t1                 LIKE oay_file.oayslip
DEFINE   li_result            LIKE type_file.num5
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
DEFINE   g_lib                RECORD LIKE lib_file.*       #攤位申請單頭表RECORD #FUN-BA0118 Add

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

   LET g_argv1 = ARG_VAL(1)     #參數值(1) - 門店編號
   LET g_argv2 = ARG_VAL(2)     #參數值(2) - 樓棟編號
   LET g_argv3 = ARG_VAL(3)     #參數值(3) - 樓層編號
   LET g_argv4 = ARG_VAL(4)     #參數值(4) - 區域編號

   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_forupd_sql = "SELECT * FROM lia_file WHERE lia01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t130_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW t130_w WITH FORM "alm/42f/almt130"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #如果傳入參數不為空,則直接進入新增狀態
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) 
      AND NOT cl_null(g_argv3) THEN
      CALL t130_a()
   END IF

   LET g_action_choice = ""
   CALL t130_menu()

   CLOSE WINDOW t130_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t130_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")   #顯示單頭部份
   INITIALIZE g_lia.* TO NULL
   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2)
      AND NOT cl_null(g_argv3) THEN
      LET g_wc = " liaplant = '",g_argv1,"' AND lia07 = '",g_argv2,"' AND ",
                 " lia08 = '",g_argv3,"' "
      IF NOT cl_null(g_argv4) THEN
         LET g_wc = g_wc CLIPPED," AND lia09 = '",g_argv4,"' "
      END IF
   ELSE
      CONSTRUCT BY NAME g_wc ON lia01,lia02,lia03,lia06,lia04,lia05,liaplant,
                                lialegal,lia07,lia08,lia09,lia13,lia10,lia11,
                                lia12,lia101,lia111,lia121,liamksg,lia15,
                                liaconf,liaconu,liacond,lia14,liauser,liagrup,
                                liaoriu,liaorig,liamodu,liadate,liaacti
         BEFORE CONSTRUCT
            CALL cl_qbe_init()

         ON ACTION controlp
            CASE
               WHEN INFIELD(lia01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lia01"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " liaplant IN ",g_auth," "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lia01
                  NEXT FIELD lia01
               WHEN INFIELD(lia04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lia04"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lia04
                  NEXT FIELD lia04
               WHEN INFIELD(liaplant)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_liaplant"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO liaplant
                  NEXT FIELD liaplant
               WHEN INFIELD(lialegal)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lialegal"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lialegal
                  NEXT FIELD lialegal
              #FUN-B90121 Add Begin ---
               WHEN INFIELD(lia06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lja01_1"
                  LET g_qryparam.where = " lja02 = '4' "
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lia06
                  NEXT FIELD lia06
              #FUN-B90121 Add End -----
               WHEN INFIELD(lia07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lia07"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lia07
                  NEXT FIELD lia07
               WHEN INFIELD(lia08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lia08"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lia08
                  NEXT FIELD lia08
               WHEN INFIELD(lia09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lia09"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO lia09
                  NEXT FIELD lia09
               WHEN INFIELD(liaconu)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_liaconu"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO liaconu
                  NEXT FIELD liaconu
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

      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('liauser', 'liagrup')
   END IF

   LET g_sql = "SELECT lia01 FROM lia_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND liaplant IN ",g_auth,
               " ORDER BY lia01"

   PREPARE t130_prepare FROM g_sql
   DECLARE t130_cs
      SCROLL CURSOR WITH HOLD FOR t130_prepare
   
   LET g_sql = "SELECT COUNT(*) FROM lia_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND liaplant IN ",g_auth

   PREPARE t130_precount FROM g_sql
   DECLARE t130_count CURSOR FOR t130_precount

END FUNCTION

FUNCTION t130_menu()

   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index,g_row_count)

         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t130_a()
            END IF
   
         ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t130_q()
            END IF

         ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t130_u()
            END IF

         ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL t130_x()
            END IF
            CALL t130_pic()

         ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t130_r()
            END IF

         ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t130_y()
            END IF
            CALL t130_pic()

         ON ACTION unconfirm
            LET g_action_choice="unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t130_z()
            END IF
            CALL t130_pic()

         ON ACTION ch_issued
            LET g_action_choice="ch_issued"
            IF cl_chk_act_auth() THEN
               CALL t130_iss()
            END IF

         ON ACTION help
            CALL cl_show_help()
            
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
   
         ON ACTION next
            CALL t130_fetch('N')
   
         ON ACTION previous
            CALL t130_fetch('P')

         ON ACTION jump
            CALL t130_fetch('/')
            
         ON ACTION first
            CALL t130_fetch('F')
            
         ON ACTION last
            CALL t130_fetch('L')

         ON ACTION controlg
            CALL cl_cmdask()
            
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            CALL t130_pic()
             
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
               IF NOT cl_null(g_lia.lia01) THEN
                  LET g_doc.column1 = "lia01"
                  LET g_doc.value1 = g_lia.lia01
                  CALL cl_doc()
               END IF
            END IF
   END MENU
   CLOSE t130_cs
END FUNCTION

FUNCTION t130_q()

    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE g_lia.* TO NULL
    INITIALIZE g_lia_t.* TO NULL

    LET g_wc = NULL

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt

    CALL t130_cs()

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lia.* TO NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN t130_count
    FETCH t130_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt

    OPEN t130_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
       INITIALIZE g_lia.* TO NULL
       LET g_wc = NULL
    ELSE
       CALL t130_fetch('F')
    END IF
END FUNCTION

FUNCTION t130_fetch(p_flag)
DEFINE p_flag LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t130_cs INTO g_lia.lia01
      WHEN 'P' FETCH PREVIOUS t130_cs INTO g_lia.lia01
      WHEN 'F' FETCH FIRST    t130_cs INTO g_lia.lia01
      WHEN 'L' FETCH LAST     t130_cs INTO g_lia.lia01
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
         FETCH ABSOLUTE g_jump t130_cs INTO g_lia.lia01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
      INITIALIZE g_lia.* TO NULL
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

   SELECT * INTO g_lia.* FROM lia_file
    WHERE lia01 = g_lia.lia01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_lia.liauser
      LET g_data_group = g_lia.liagrup
      CALL t130_show()
   END IF
END FUNCTION

FUNCTION t130_show()

   LET g_lia_t.* = g_lia.*
   DISPLAY BY NAME g_lia.lia01,g_lia.lia02,g_lia.lia03,g_lia.lia06,g_lia.lia04,
                   g_lia.lia05,g_lia.liaplant,g_lia.lialegal,g_lia.lia07,
                   g_lia.lia08,g_lia.lia09,g_lia.lia13,g_lia.lia10,g_lia.lia11,
                   g_lia.lia12,g_lia.lia101,g_lia.lia111,g_lia.lia121,
                   g_lia.liamksg,g_lia.lia15,g_lia.liaconf,g_lia.liaconu,
                   g_lia.liacond,g_lia.lia14,g_lia.liauser,g_lia.liagrup,
                   g_lia.liamodu,g_lia.liadate,g_lia.liaacti,g_lia.liaoriu,g_lia.liaorig

   CALL t130_lia_fill()
   CALL t130_lia07('d')
   CALL t130_lia08('d')
   CALL t130_lia09('d')
   CALL t130_pic()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t130_a()
DEFINE l_rtz13 LIKE rtz_file.rtz13
DEFINE l_azt02 LIKE azt_file.azt02
DEFINE l_str   STRING

   MESSAGE ""
   CLEAR FORM    
   INITIALIZE g_lia.*    LIKE lia_file.*
   INITIALIZE g_lia_t.*  LIKE lia_file.*

   IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) 
      AND NOT cl_null(g_argv3) AND NOT cl_null(g_argv4) THEN
      LET g_lia.liaplant = g_argv1
      LET g_lia.lia07    = g_argv2
      LET g_lia.lia08    = g_argv3
      LET g_lia.lia09    = g_argv4
      CALL t130_lia07('d')
      CALL t130_lia08('d')
      CALL t130_lia09('d')
   END IF
    
    LET g_wc = NULL
    CALL cl_opmsg('a')

    WHILE TRUE
       LET g_lia.liauser = g_user
       LET g_lia.liaoriu = g_user
       LET g_lia.liaorig = g_grup
       LET g_lia.liagrup = g_grup
       LET g_lia.liaacti = 'Y'
       LET g_lia.liadate = g_today
       IF cl_null(g_argv1) THEN
          LET g_lia.liaplant = g_plant
       END IF
       LET g_lia.lialegal = g_legal
       LET g_lia.lia02 = g_today
       LET g_lia.lia03 = '1'
       LET g_lia.lia05 = 0
       LET g_lia.lia13 = 'N'
       LET g_lia.liamksg = 'N'
       LET g_lia.lia15 = '0'
       LET g_lia.liaconf = 'N'
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lia.liaplant
       SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lia.lialegal
       DISPLAY l_rtz13,l_azt02 TO FORMONLY.rtz13,FORMONLY.azt02
       CALL t130_i("a")
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          INITIALIZE g_lia.* TO NULL
          CALL cl_err('',9001,0)
          CLEAR FORM
          EXIT WHILE
       END IF
       IF cl_null(g_lia.lia01) THEN
          CONTINUE WHILE
       END IF

       IF g_lia.lia03 = '1' AND g_aza.aza110 = 'Y' THEN
          CALL s_auno(g_lia.lia04,'9','') RETURNING g_lia.lia04,l_str
       END IF
       IF cl_null(g_lia.lia04) THEN
          CONTINUE WHILE
       END IF
       DISPLAY BY NAME g_lia.lia04,g_lia.lia14

       CALL s_auto_assign_no("alm",g_lia.lia01,g_today,"O4","lia_file","lia01","","","")
          RETURNING li_result,g_lia.lia01
       IF (NOT li_result) THEN  CONTINUE WHILE  END IF
       DISPLAY BY NAME g_lia.lia01

       INSERT INTO lia_file VALUES(g_lia.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err(g_lia.lia01,SQLCA.SQLCODE,0)
          CONTINUE WHILE
       ELSE
          SELECT * INTO g_lia.* FROM lia_file
           WHERE lia01 = g_lia.lia01
       END IF
       EXIT WHILE
   END WHILE
   MESSAGE ""
   LET g_wc = NULL
END FUNCTION

FUNCTION t130_i(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_lmc11    LIKE lmc_file.lmc11
DEFINE l_lmc12    LIKE lmc_file.lmc12
DEFINE l_lmc04    LIKE lmc_file.lmc04
DEFINE l_lla03    LIKE lla_file.lla03 #FUN-B80141 Add
DEFINE l_lla04    LIKE lla_file.lla04 #FUN-B80141 Add

   SELECT lla03,lla04 INTO l_lla03,l_lla04 FROM lla_file WHERE llastore = g_plant #FUN-B80141 Add

   DISPLAY BY NAME g_lia.lia01,g_lia.lia02,g_lia.lia03,g_lia.lia06,g_lia.lia04,
                   g_lia.lia05,g_lia.liaplant,g_lia.lialegal,g_lia.lia07,
                   g_lia.lia08,g_lia.lia09,g_lia.lia13,g_lia.lia10,g_lia.lia11,
                   g_lia.lia12,g_lia.lia101,g_lia.lia111,g_lia.lia121,
                   g_lia.liamksg,g_lia.lia15,g_lia.liaconf,g_lia.liaconu,
                   g_lia.liacond,g_lia.lia14,g_lia.liauser,g_lia.liagrup,
                   g_lia.liamodu,g_lia.liadate,g_lia.liaacti,g_lia.liaoriu,g_lia.liaorig

   INPUT BY NAME g_lia.lia01,g_lia.lia02,g_lia.lia03,g_lia.lia06,g_lia.lia04,
                 g_lia.lia05,g_lia.liaplant,g_lia.lialegal,g_lia.lia07,
                 g_lia.lia08,g_lia.lia09,g_lia.lia13,g_lia.lia10,g_lia.lia11,
                 g_lia.lia12,g_lia.lia101,g_lia.lia111,g_lia.lia121,
                 g_lia.liamksg,g_lia.lia15,g_lia.liaconf,g_lia.liaconu,
                 g_lia.liacond,g_lia.lia14,g_lia.liauser,g_lia.liagrup,
                 g_lia.liaoriu,g_lia.liaorig,g_lia.liamodu,g_lia.liadate,g_lia.liaacti
                 WITHOUT DEFAULTS

      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t130_set_entry(p_cmd)
         CALL t130_set_no_entry(p_cmd)
         CALL t130_set_lia_entry()
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("lia01")

      AFTER FIELD lia01
         IF NOT cl_null(g_lia.lia01) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia01 <> g_lia.lia01) THEN
               CALL s_check_no("alm",g_lia.lia01,g_lia_t.lia01,"O4","lia_file","lia01,liaplant","")
                  RETURNING li_result,g_lia.lia01
               IF (NOT li_result) THEN
                  LET g_lia.lia01 = g_lia_t.lia01
                  NEXT FIELD lia01
               END IF
            END IF
         END IF

     #TQC-C20528 Add Begin ---
      AFTER FIELD lia02
         IF NOT cl_null(g_lia.lia02) THEN
            IF NOT cl_null(g_lia.lia03) AND NOT cl_null(g_lia.lia06) THEN
               IF g_lia.lia03 = '2' THEN
                  CALL t130_chk_lia02()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD lia02
                  END IF
               END IF
            END IF
         END IF
     #TQC-C20528 Add End -----

      ON CHANGE lia03
         IF NOT cl_null(g_lia.lia03) THEN
            CASE g_lia.lia03
               WHEN '1'
                  IF NOT cl_null(g_lia.lia04) THEN
                     IF NOT cl_null(g_lia_t.lia03) THEN
                        IF g_lia_t.lia03 = '2' OR g_lia_t.lia03 = '3' THEN
                           CALL cl_err('','alm-569',0)     #已維護了場地資料不允許更改資料類型
                           LET g_lia.lia03 = g_lia_t.lia03
                           DISPLAY BY NAME g_lia.lia03
                        END IF
                     END IF
                  END IF
               OTHERWISE
                  IF NOT cl_null(g_lia.lia04) THEN
                     IF NOT cl_null(g_lia_t.lia03) THEN
                        IF g_lia_t.lia03 = '1' THEN
                           CALL cl_err('','alm-569',0)     #已維護了場地資料不允許更改資料類型
                           LET g_lia.lia03 = g_lia_t.lia03
                           DISPLAY BY NAME g_lia.lia03
                        END IF
                     END IF
                  END IF
            END CASE
            CALL t130_set_lia_entry()
         END IF

      AFTER FIELD lia03
         IF NOT cl_null(g_lia.lia03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia03 <> g_lia.lia03) THEN
               CASE g_lia.lia03
                  WHEN '1'
                     IF NOT cl_null(g_lia.lia04) THEN
                        CALL t130_lia04('a')
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                           NEXT FIELD lia03
                        END IF
                     END IF
                     LET g_lia.lia13 = 'N'
                     INITIALIZE g_lia.lia10,g_lia.lia11,g_lia.lia12 TO NULL
                     LET g_lia.lia05 = 0
                     LET g_lia.lia14 = NULL
                     DISPLAY BY NAME g_lia.lia05,g_lia.lia10,g_lia.lia11,g_lia.lia12,g_lia.lia13,g_lia.lia14
                  OTHERWISE
                     IF NOT cl_null(g_lia.lia04) THEN
                        CALL t130_lia04('a')
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err('',g_errno,0)
                           NEXT FIELD lia03
                        END IF 
                     END IF
               END CASE
              #TQC-C20528 Add Begin ---
               IF NOT cl_null(g_lia.lia02) AND NOT cl_null(g_lia.lia06) THEN
                  IF g_lia.lia03 = '2' THEN
                     CALL t130_chk_lia02()
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,0)
                        NEXT FIELD lia03
                     END IF
                  END IF
               END IF
              #TQC-C20528 Add End -----
            END IF
         END IF

     #FUN-B80141 Mark Begin ---
     #BEFORE FIELD lia04
     #   IF cl_null(g_lia.lia04) THEN
     #      IF g_lia.lia03 = '1' THEN 
     #         IF g_aza.aza110 = 'Y' THEN
     #            CALL s_auno(g_lia.lia04,'9','' ) RETURNING g_lia.lia04,g_lia.lia14
     #            DISPLAY BY NAME g_lia.lia04,g_lia.lia14
     #         END IF
     #      END IF
     #   END IF
     #FUN-B80141 Mark End -----

      AFTER FIELD lia04
         IF NOT cl_null(g_lia.lia04) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia04 <> g_lia.lia04) THEN
               CALL t130_lia04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lia_t.lia04 = g_lia.lia04
                  DISPLAY BY NAME g_lia.lia04
                  NEXT FIELD lia04
               END IF
            END IF
         END IF

     #FUN-BA0118 Add Begin ---
      AFTER FIELD lia06
         IF NOT cl_null(g_lia.lia06) THEN
            CALL t130_chk_lia06('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lia.lia06 = g_lia_t.lia06
               DISPLAY BY NAME g_lia.lia06
               NEXT FIELD lia06
            END IF
           #TQC-C20528 Add Begin ---
            IF NOT cl_null(g_lia.lia03) AND NOT cl_null(g_lia.lia02) THEN
               IF g_lia.lia03 = '2' THEN
                  CALL t130_chk_lia02()
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD lia06
                  END IF
               END IF
            END IF
           #TQC-C20528 Add End -----
         END IF
     #FUN-BA0118 Add End -----

     #FUN-BA0118 Mark Begin ---
     #BEFORE FIELD lia07
     #   IF cl_null(g_lia.lia04) THEN
     #      CALL cl_err('','alm-598',0)
     #      NEXT FIELD lia04
     #   END IF
     #FUN-BA0118 Mark End -----

      AFTER FIELD lia07
         IF NOT cl_null(g_lia.lia07) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia07 <> g_lia.lia07) THEN
               CALL t130_lia07('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lia.lia07 = g_lia_t.lia07
                  DISPLAY BY NAME g_lia.lia07
                  NEXT FIELD lia07
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.lmb03
         END IF

      BEFORE FIELD lia08
         IF cl_null(g_lia.lia07) THEN
            CALL cl_err('','alm-390',0)
            NEXT FIELD lia07
         END IF

      AFTER FIELD lia08
         IF NOT cl_null(g_lia.lia08) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia08 <> g_lia.lia08) THEN
               CALL t130_lia08('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lia.lia08 = g_lia_t.lia08
                  DISPLAY BY NAME g_lia.lia08
                  NEXT FIELD lia08
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.lmc04
         END IF

      BEFORE FIELD lia09
         IF cl_null(g_lia.lia08) THEN
            CALL cl_err('','alm-599',0)
            NEXT FIELD lia08
         END IF

      AFTER FIELD lia09
         IF NOT cl_null(g_lia.lia09) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia09 <> g_lia.lia09) THEN
               CALL t130_lia09('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lia.lia09 = g_lia_t.lia09
                  DISPLAY BY NAME g_lia.lia09
                  NEXT FIELD lia09
               END IF
            END IF
         ELSE
            DISPLAY '' TO FORMONLY.lmy04
         END IF

      AFTER FIELD lia111
         IF NOT cl_null(g_lia.lia111) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia111 <> g_lia.lia111) THEN
               IF g_lia.lia111 < 0 THEN
                  CALL cl_err('','alm-061',0)
                  NEXT FIELD lia111
               END IF
               LET g_lia.lia111 = cl_digcut(g_lia.lia111,l_lla03) #FUN-B80141 Add
               SELECT lmc11,lmc12 INTO l_lmc11,l_lmc12 FROM lmc_file WHERE lmcstore = g_lia.liaplant AND lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08
               IF (cl_null(l_lmc12) OR l_lmc12 = 0) THEN LET l_lmc12 = 1 END IF
               IF NOT cl_null(l_lmc11) THEN
                  LET g_lia.lia101 = g_lia.lia111 / (1 - l_lmc11/100)
                  LET g_lia.lia101 = cl_digcut(g_lia.lia101,l_lla03) #FUN-B80141 Add
               END IF
               LET g_lia.lia121 = g_lia.lia111 * l_lmc12
               LET g_lia.lia121 = cl_digcut(g_lia.lia121,l_lla03) #FUN-B80141 Add
               CALL t130_lmc_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lia.lia111 = g_lia_t.lia111
                  LET g_lia.lia101 = g_lia_t.lia101
                  LET g_lia.lia121 = g_lia_t.lia121
                  DISPLAY BY NAME g_lia.lia101,g_lia.lia111,g_lia.lia121
                  NEXT FIELD lia111
               ELSE
                  DISPLAY BY NAME g_lia.lia101,g_lia.lia111,g_lia.lia121
               END IF
            END IF
         END IF

      AFTER FIELD lia121
         IF NOT cl_null(g_lia.lia121) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lia_t.lia121 <> g_lia.lia121) THEN
               IF g_lia.lia121 < 0 THEN
                  CALL cl_err('','alm-061',0)
                  NEXT FIELD lia121
               END IF
               LET g_lia.lia121 = cl_digcut(g_lia.lia121,l_lla03) #FUN-B80141 Add
               SELECT lmc11,lmc12 INTO l_lmc11,l_lmc12 FROM lmc_file WHERE lmcstore = g_lia.liaplant AND lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08
               IF (cl_null(l_lmc12) OR l_lmc12 = 0) THEN LET l_lmc12 = 1 END IF
               LET g_lia.lia111 = g_lia.lia121 / l_lmc12
               LET g_lia.lia111 = cl_digcut(g_lia.lia111,l_lla03) #FUN-B80141 Add
               IF NOT cl_null(l_lmc11) THEN
                  LET g_lia.lia101 = g_lia.lia111 / (1 - l_lmc11/100)
                  LET g_lia.lia101 = cl_digcut(g_lia.lia101,l_lla03) #FUN-B80141 Add
               END IF
               CALL t130_lmc_chk()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lia.lia111 = g_lia_t.lia111
                  LET g_lia.lia101 = g_lia_t.lia101
                  LET g_lia.lia121 = g_lia_t.lia121
                  DISPLAY BY NAME g_lia.lia101,g_lia.lia111,g_lia.lia121
                  NEXT FIELD lia121
               ELSE
                  DISPLAY BY NAME g_lia.lia101,g_lia.lia111,g_lia.lia121
               END IF
            END IF
         END IF

      AFTER INPUT
         LET g_lia.liauser = s_get_data_owner("lia_file") #FUN-C10039
         LET g_lia.liagrup = s_get_data_group("lia_file") #FUN-C10039
         IF INT_FLAG THEN          
            EXIT INPUT
         END IF

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(lia01)
               LET g_t1=s_get_doc_no(g_lia.lia01)
               CALL q_oay(FALSE,FALSE,g_t1,'O4','alm') RETURNING g_t1
               LET g_lia.lia01 = g_t1
               DISPLAY BY NAME g_lia.lia01
               NEXT FIELD lia01
            WHEN INFIELD(lia04)
               IF g_lia.lia03 = '1' THEN
                  EXIT CASE
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lmd01"
                  LET g_qryparam.arg1 = g_lia.liaplant
                 #FUN-BA0118 Add Begin ---
                  IF NOT cl_null(g_lia.lia06) THEN
                     LET g_qryparam.where = 
                        " lmd01 IN (SELECT lie02 ",
                        "             FROM lie_file ",
                        "            WHERE lie01 = (SELECT lnt06 ",
                        "                             FROM lnt_file ",
                        "                            WHERE lnt01 = (SELECT lja05 ",
                        "                                             FROM lja_file ",
                        "                                            WHERE lja01 = '",g_lia.lia06,"' ))) "
                  END IF
                 #FUN-BA0118 Add End -----
                  CALL cl_create_qry() RETURNING g_lia.lia04
                  DISPLAY BY NAME g_lia.lia04
                  NEXT FIELD lia04
               END IF

           #FUN-BA0118 Add Begin ---
            WHEN INFIELD(lia06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lja01_1"
              #TQC-C20528 Add&Mark Begin ---
              #LET g_qryparam.where = " lja02 = '4' "
               LET g_qryparam.where = " lja02 = '4' AND lja01 NOT IN (SELECT lji03 ",
                                      "                                 FROM lji_file ",
                                      "                                WHERE ljiconf <> 'A' ",
                                      "                                  AND ljiconf <> 'X' ",  #CHI-C80041
                                      "                                  AND ljiconf <> 'B' AND lji02 = '4') "
              #TQC-C20528 Add&Mark End -----
               CALL cl_create_qry() RETURNING g_lia.lia06
               DISPLAY BY NAME g_lia.lia06
               NEXT FIELD lia06
           #FUN-BA0118 Add End -----

            WHEN INFIELD(lia07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmc1"
               LET g_qryparam.where = " lmcstore = '",g_lia.liaplant,"'"
               CALL cl_create_qry() RETURNING g_lia.lia07,g_lia.lia08,l_lmc04
               DISPLAY BY NAME g_lia.lia07,g_lia.lia08
               DISPLAY l_lmc04 TO FORMONLY.lmc04
               CALL t130_lia07('d')
               NEXT FIELD lia07
            WHEN INFIELD(lia08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmy1"
               LET g_qryparam.where = " lmc02 = '",g_lia.lia07,"' AND lmcstore = '",g_lia.liaplant,"'"
               CALL cl_create_qry() RETURNING g_lia.lia07,g_lia.lia08,l_lmc04
               DISPLAY BY NAME g_lia.lia07,g_lia.lia08
               DISPLAY l_lmc04 TO FORMONLY.lmc04
               CALL t130_lia08('d')
               NEXT FIELD lia08
            WHEN INFIELD(lia09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmy03"
               LET g_qryparam.where = " lmyacti = 'Y' AND lmystore = '",g_lia.liaplant,"'",
                                      " AND lmy01 = '",g_lia.lia07,"' AND lmy02 = '",g_lia.lia08,"' "
               CALL cl_create_qry() RETURNING g_lia.lia09
               DISPLAY BY NAME g_lia.lia09
               CALL t130_lia09('d')
               NEXT FIELD lia09
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

#FUN-BA0118 Add Begin ---
FUNCTION t130_chk_lia06(p_cmd)
DEFINE l_ljaconf  LIKE lja_file.ljaconf
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_n        LIKE type_file.num5 #TQC-C20528 Add

   LET g_errno = ''
   SELECT ljaconf INTO l_ljaconf FROM lja_file WHERE lja01 = g_lia.lia06 AND lja02 = '4'
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'alm-876' #不存在
                               LET g_lia.lia04 = NULL
      WHEN l_ljaconf = 'N'     LET g_errno = 'alm-873' #未確認
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
  #TQC-C20528 Add Begin ---
   IF cl_null(g_errno) THEN
      LET l_n = 0
      SELECT COUNT(*) INTO l_n
        FROM lji_file 
       WHERE ljiconf <> 'A' AND ljiconf <> 'B' AND lji03 = g_lia.lia06 AND lji02 = '4'
         AND ljiconf <> 'X'  #CHI-C80041
      IF l_n > 0 THEN
         LET g_errno = 'alm1593' #此面積變更申請單已存在於變更作業中，請檢查！
      END IF
   END IF
  #TQC-C20528 Add End -----
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_lia.lia03
   END IF
END FUNCTION
#FUN-BA0118 Add End -----

FUNCTION t130_u()

   IF cl_null(g_lia.lia01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
   
   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01
   
   IF g_lia.liaconf = 'Y' THEN
      CALL cl_err(g_lia.lia01,'alm-027',1)
      RETURN
   END IF 

   IF g_lia.liaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   IF g_lia.liaacti = 'N' THEN
      CALL cl_err(g_lia.lia01,9027,0)
      RETURN
   END IF
       
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK

   OPEN t130_cl USING g_lia.lia01
   IF STATUS THEN
      CALL cl_err("OPEN t130_cl:",STATUS,1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t130_cl INTO g_lia.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_lia.liamodu = g_user
   LET g_lia.liadate = g_today
   CALL t130_show()
   WHILE TRUE
      CALL t130_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lia.*=g_lia_t.*
         CALL t130_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      UPDATE lia_file SET lia_file.* = g_lia.*
       WHERE lia01 = g_lia_t.lia01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t130_cl
   COMMIT WORK
END FUNCTION

FUNCTION t130_r()

   IF cl_null(g_lia.lia01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01

   IF g_lia.liaacti  = 'N' THEN
      CALL cl_err('','alm-147',1)
      RETURN
   END IF

   IF g_lia.liaconf = 'Y' THEN
      CALL cl_err(g_lia.lia01,'alm-028',1)
      RETURN
   END IF

   IF g_lia.liaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   BEGIN WORK

   OPEN t130_cl USING g_lia.lia01
   IF STATUS THEN
      CALL cl_err("OPEN t130_cl:",STATUS,0)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t130_cl INTO g_lia.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t130_show()

   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "lia01"
      LET g_doc.value1 = g_lia.lia01
      CALL cl_del_doc()
      DELETE FROM lia_file WHERE lia01 = g_lia.lia01
      CLEAR FORM
      OPEN t130_count
      IF STATUS THEN
         CLOSE t130_cs
         CLOSE t130_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t130_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t130_cs
         CLOSE t130_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t130_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t130_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t130_fetch('/')
      END IF
   END IF
   CLOSE t130_cl
   COMMIT WORK
END FUNCTION

FUNCTION t130_y()

   IF cl_null(g_lia.lia01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lia.* FROM lia_file
    WHERE lia01 = g_lia.lia01

   IF g_lia.liaacti ='N' THEN
      CALL cl_err(g_lia.lia01,'alm-004',1)
      RETURN
   END IF
   IF g_lia.liaconf = 'Y' THEN
      CALL cl_err(g_lia.liaconf,'alm-005',1)
      RETURN
   END IF

   IF g_lia.liaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   CALL t130_lmc_chk()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF
   
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
   
   BEGIN WORK 
   LET g_success = 'Y'

   OPEN t130_cl USING g_lia.lia01
   IF STATUS THEN 
      CALL cl_err("open t130_cl:",STATUS,1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF 
   FETCH t130_cl INTO g_lia.*
   IF SQLCA.sqlcode  THEN 
     CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
     CLOSE t130_cl
     ROLLBACK WORK
     RETURN
   END IF

   UPDATE lia_file SET liaconf = 'Y',
                       lia15   = '1',
                       liaconu = g_user,
                       liacond = g_today
    WHERE lia01 = g_lia.lia01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lia:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01
   CALL t130_lia_fill()
   DISPLAY BY NAME g_lia.*
   CLOSE t130_cl
   COMMIT WORK
END FUNCTION

FUNCTION t130_z()

   IF cl_null(g_lia.lia01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   
   SELECT * INTO g_lia.* FROM lia_file
    WHERE lia01 = g_lia.lia01
   
   IF g_lia.liaacti ='N' THEN
      CALL cl_err(g_lia.lia01,'alm-004',0)
      RETURN
   END IF 
      
   IF g_lia.liaconf = 'N' THEN
      CALL cl_err(g_lia.lia01,'alm-007',0)
      RETURN
   END IF

   IF g_lia.lia15 = '2' THEN
      CALL cl_err('','alm-943',0)
      RETURN
   END IF

   IF g_lia.liaplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   IF NOT cl_confirm('alm-008') THEN
      RETURN
   END IF

   BEGIN WORK
   LET g_success = 'Y'

   OPEN t130_cl USING g_lia.lia01
   IF STATUS THEN
      CALL cl_err("open t130_cl:",STATUS,1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t130_cl INTO g_lia.*
   IF SQLCA.sqlcode  THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF

   UPDATE lia_file
      SET liaconf = 'N',
          lia15   = '0',
          #CHI-D20015--modify--str--
          #liacond = '',
          #liaconu = ''
          liacond = g_today,
          liaconu = g_user
          #CHI-D20015--modify--end--
    WHERE lia01 = g_lia.lia01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lia:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01
   DISPLAY BY NAME g_lia.*
   CALL t130_lia_fill()
   CLOSE t130_cl
   COMMIT WORK
END FUNCTION

FUNCTION t130_x()

   IF cl_null(g_lia.lia01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01

   IF g_lia.liaconf = 'Y' THEN
      CALL cl_err(g_lia.lia01,'alm-027',1)
      RETURN
   END IF

   BEGIN WORK

   OPEN t130_cl USING g_lia.lia01
   IF STATUS THEN
      CALL cl_err("OPEN t130_cl:",STATUS,1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t130_cl INTO g_lia.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t130_show()

   IF cl_exp(0,0,g_lia.liaacti) THEN
      LET g_chr=g_lia.liaacti
      IF g_lia.liaacti='Y' THEN
         LET g_lia.liaacti='N'
         LET g_lia.liamodu = g_user
         LET g_lia.liadate = g_today
      ELSE
         LET g_lia.liaacti='Y'
         LET g_lia.liamodu = g_user
         LET g_lia.liadate = g_today
      END IF
      UPDATE lia_file SET liaacti = g_lia.liaacti,
                          liamodu = g_lia.liamodu,
                          liadate = g_lia.liadate
       WHERE lia01 = g_lia.lia01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
         LET g_lia.liaacti = g_chr
         DISPLAY BY NAME g_lia.liaacti
         CLOSE t130_cl
         ROLLBACK WORK
         RETURN
      END IF
      DISPLAY BY NAME g_lia.liamodu,g_lia.liadate,g_lia.liaacti
   END IF
   CLOSE t130_cl
   COMMIT WORK
END FUNCTION

FUNCTION t130_lia04(p_cmd)
DEFINE p_cmd    LIKE type_file.chr1
DEFINE l_lmd10  LIKE lmd_file.lmd10  #確認碼
DEFINE l_n      LIKE type_file.num5
DEFINE l_lmb03  LIKE lmb_file.lmb03
DEFINE l_lmc04  LIKE lmc_file.lmc04
DEFINE l_lmy04  LIKE lmy_file.lmy04
DEFINE l_sql    STRING

   LET g_errno = ''
   CASE g_lia.lia03
      WHEN '1'
         SELECT COUNT(*) INTO l_n FROM lmd_file WHERE lmd01 = g_lia.lia04
         IF l_n > 0 THEN
            LET g_errno = 'alm-014'     #場地編號重複
         ELSE
            LET l_sql = "SELECT COUNT(*) "," FROM ",cl_get_target_table(g_plant,'lia_file'),
                        " WHERE lia04 = '",g_lia.lia04,"' AND lia15 <> '2' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            PREPARE sel_lia_pre1 FROM l_sql
            EXECUTE sel_lia_pre1 INTO l_n
            IF l_n > 0 THEN LET g_errno = 'alm-262' END IF  #場地變更申請作業中已存在該場地未變更發出的資料
         END IF
      OTHERWISE
         IF NOT cl_null(g_lia.lia01) THEN
            LET l_sql = "SELECT COUNT(*) ",
                        "  FROM ",cl_get_target_table(g_plant,'lia_file'),
                        " WHERE lia04 = '",g_lia.lia04,"' AND lia15 <> '2' AND lia01 <> '",g_lia.lia01,"' "
         ELSE
            LET l_sql = "SELECT COUNT(*) ",
                        "  FROM ",cl_get_target_table(g_plant,'lia_file'),
                        " WHERE lia04 = '",g_lia.lia04,"' AND lia15 <> '2' "
         END IF
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         PREPARE sel_lia_pre2 FROM l_sql
         EXECUTE sel_lia_pre2 INTO l_n
         IF l_n > 0 THEN
            LET g_errno = 'alm-264'  #该场地编号存在于未发出的变更申请单中，请先变更发出上一版本的申请单！
         ELSE
            SELECT lmd16+1,lmd03,lmd04,lmd14,lmd06,lmd15,lmd05,lmd07,lmd13,lmd10
              INTO g_lia.lia05,g_lia.lia07,g_lia.lia08,g_lia.lia09,g_lia.lia10,
                   g_lia.lia11,g_lia.lia12,g_lia.lia13,g_lia.lia14,l_lmd10
              FROM lmd_file
             WHERE lmd01 = g_lia.lia04 AND lmdstore = g_lia.liaplant
            CASE
               WHEN SQLCA.sqlcode = 100  LET g_errno = 'alm-263'  #資料不存在
               WHEN l_lmd10 = 'X'        LET g_errno = '9024'     #資料已作廢
               OTHERWISE 
                  LET g_errno=SQLCA.sqlcode USING '------'
            END CASE
           #FUN-BA0118 Add&Mark Begin ---
            IF NOT cl_null(g_lia.lia06) THEN
               IF cl_null(g_errno) THEN
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n 
                    FROM lie_file 
                   WHERE lie01 = (SELECT lja06 
                                    FROM lja_file
                                   WHERE lja01 = g_lia.lia06)
                     AND lie02 = g_lia.lia04 AND lieacti = 'Y'
                  IF l_n = 0 THEN
                     LET g_errno = 'alm-916'
                  END IF
               END IF
            END IF
           #FUN-BA0118 Add&Mark End -----
         END IF
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY BY NAME g_lia.lia05,g_lia.lia07,g_lia.lia08,g_lia.lia09,g_lia.lia10,
                      g_lia.lia11,g_lia.lia12,g_lia.lia13,g_lia.lia14
      SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmb02 = g_lia.lia07
      SELECT lmc04 INTO l_lmc04 
        FROM lmc_file 
       WHERE lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08
      SELECT lmy04 INTO l_lmy04 
        FROM lmy_file 
       WHERE lmy01 = g_lia.lia07 AND lmy02 = g_lia.lia08 AND lmy03 = g_lia.lia09
      DISPLAY l_lmb03,l_lmc04,l_lmy04 TO FORMONLY.lmb03,FORMONLY.lmc04,FORMONLY.lmy04
   END IF
END FUNCTION

FUNCTION t130_lia07(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_lmb03   LIKE lmb_file.lmb03
DEFINE l_lmb06   LIKE lmb_file.lmb06  
DEFINE l_n       LIKE type_file.num5

   LET g_errno = ''
   SELECT lmb03,lmb06 INTO l_lmb03,l_lmb06 FROM lmb_file WHERE lmb02 = g_lia.lia07 AND lmbstore = g_lia.liaplant
   CASE
      WHEN SQLCA.sqlcode = 100    LET g_errno = 'alm-003'
      WHEN l_lmb06 = 'N'          LET g_errno = 'alm-905'
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_lia.lia08) THEN
      SELECT COUNT(*) INTO l_n FROM lmc_file 
       WHERE lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08 AND lmcstore = g_lia.liaplant
      IF l_n = 0 THEN
         LET g_errno = 'alm-907'
      END IF
   END IF
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_lmb03 TO FORMONLY.lmb03
   END IF
END FUNCTION

FUNCTION t130_lia08(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_lmc04   LIKE lmc_file.lmc04
DEFINE l_lmc07   LIKE lmc_file.lmc07  
DEFINE l_n       LIKE type_file.num5

   LET g_errno = ''
   SELECT lmc04,lmc07 INTO l_lmc04,l_lmc07 
     FROM lmc_file 
    WHERE lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08 AND lmcstore = g_lia.liaplant
   CASE
      WHEN SQLCA.sqlcode = 100    LET g_errno = 'alm-554'
      WHEN l_lmc07 = 'N'          LET g_errno = 'alm-908'
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) AND NOT cl_null(g_lia.lia09) THEN
      SELECT COUNT(*) INTO l_n FROM lmy_file
       WHERE lmy01 = g_lia.lia07 AND lmy02 = g_lia.lia08 AND lmy03 = g_lia.lia09 AND lmystore = g_lia.liaplant
      IF l_n = 0 THEN
         LET g_errno = 'alm-745'
      END IF
   END IF
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION

FUNCTION t130_lia09(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1
DEFINE l_lmy04   LIKE lmy_file.lmy04
DEFINE l_lmyacti LIKE lmy_file.lmyacti

   LET g_errno = ''
   SELECT lmy04,lmyacti INTO l_lmy04,l_lmyacti 
     FROM lmy_file 
    WHERE lmy01 = g_lia.lia07 AND lmy02 = g_lia.lia08 AND lmy03 = g_lia.lia09 AND lmystore = g_lia.liaplant
   CASE
      WHEN SQLCA.sqlcode = 100    LET g_errno = '100'  #資料不存在
      WHEN l_lmyacti = 'N'        LET g_errno = '9028' #資料已無效
      OTHERWISE
         LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_lmy04 TO FORMONLY.lmy04
   END IF
END FUNCTION

FUNCTION t130_lia_fill()
DEFINE l_rtz13   LIKE rtz_file.rtz13
DEFINE l_azt02   LIKE azt_file.azt02
DEFINE l_gen02   LIKE gen_file.gen02

   SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = g_lia.liaplant
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_lia.lialegal
   SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_lia.liaconu
   DISPLAY l_rtz13,l_azt02,l_gen02 TO FORMONLY.rtz13,FORMONLY.azt02,FORMONLY.gen02
END FUNCTION

FUNCTION t130_lmc_chk()
DEFINE l_lmd06_sum1    LIKE lmd_file.lmd06            #樓層建築面積匯總
DEFINE l_lmd06_sum2    LIKE lmd_file.lmd06            #樓棟建築面積匯總
DEFINE l_lmd15_sum1    LIKE lmd_file.lmd15            #樓層測量面積匯總
DEFINE l_lmd15_sum2    LIKE lmd_file.lmd15            #樓棟測量面積匯總
DEFINE l_lmb07         LIKE lmb_file.lmb07
DEFINE l_lmb08         LIKE lmb_file.lmb08
DEFINE l_lmc08         LIKE lmc_file.lmc08
DEFINE l_lmc09         LIKE lmc_file.lmc09

   LET g_errno = ''
   LET l_lmd06_sum1 = 0
   LET l_lmd06_sum2 = 0
   LET l_lmd15_sum1 = 0
   LET l_lmd15_sum2 = 0

   CASE g_lia.lia03
      WHEN '1'
         SELECT sum(lmd06),sum(lmd15) INTO l_lmd06_sum1,l_lmd15_sum1 
           FROM lmd_file 
          WHERE lmd10 = 'Y' AND lmd03 = g_lia.lia07 AND lmd04 = g_lia.lia08 AND lmdstore = g_lia.liaplant
         SELECT sum(lmd06),sum(lmd15) INTO l_lmd06_sum2,l_lmd15_sum2 
           FROM lmd_file 
          WHERE lmd10 = 'Y' AND lmd03 = g_lia.lia07 AND lmdstore = g_lia.liaplant
         IF cl_null(l_lmd06_sum1) THEN LET l_lmd06_sum1 = 0 END IF
         IF cl_null(l_lmd06_sum2) THEN LET l_lmd06_sum2 = 0 END IF
         IF cl_null(l_lmd15_sum1) THEN LET l_lmd15_sum1 = 0 END IF
         IF cl_null(l_lmd15_sum2) THEN LET l_lmd15_sum2 = 0 END IF
         SELECT lmb07,lmb08 INTO l_lmb07,l_lmb08 FROM lmb_file WHERE lmbstore = g_lia.liaplant AND lmb02 = g_lia.lia07
         SELECT lmc08,lmc09 INTO l_lmc08,l_lmc09 FROM lmc_file WHERE lmcstore = g_lia.liaplant AND lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08
         IF NOT cl_null(l_lmb07) THEN
            #樓棟測量面積或者建築面積超出樓棟圖紙面積
            IF (l_lmb07 < l_lmd06_sum2 + g_lia.lia101) THEN LET g_errno = 'alm-265' END IF
         END IF
         IF NOT cl_null(l_lmb08) THEN
            #樓棟測量面積或者建築面積超出樓棟圖紙面積
            IF (l_lmb08 < l_lmd15_sum2 + g_lia.lia111) THEN LET g_errno = 'alm-265' END IF
         END IF
         IF cl_null(g_errno) THEN
            IF NOT cl_null(l_lmc08) THEN
               #樓層測量面積或者建築面積超出樓層圖紙面積
               IF (l_lmc08 < l_lmd06_sum1 + g_lia.lia101) THEN LET g_errno = 'alm-439' END IF
            END IF
            IF NOT cl_null(l_lmc09) THEN
               #樓層測量面積或者建築面積超出樓層圖紙面積
               IF (l_lmc09 < l_lmd15_sum1 + g_lia.lia111) THEN LET g_errno = 'alm-439' END IF
            END IF
         END IF
      WHEN '2'
         SELECT sum(lmd06),sum(lmd15) INTO l_lmd06_sum1,l_lmd15_sum1
           FROM lmd_file 
          WHERE lmd10 = 'Y' AND lmd03 = g_lia.lia07 AND lmd04 = g_lia.lia08 AND lmdstore = g_lia.liaplant AND lmd01 <> g_lia.lia04
         SELECT sum(lmd06),sum(lmd15) INTO l_lmd06_sum2,l_lmd15_sum2 
           FROM lmd_file 
          WHERE lmd10 = 'Y' AND lmd03 = g_lia.lia07 AND lmd01 <> g_lia.lia04 AND lmdstore = g_lia.liaplant
         IF cl_null(l_lmd06_sum1) THEN LET l_lmd06_sum1 = 0 END IF
         IF cl_null(l_lmd06_sum2) THEN LET l_lmd06_sum2 = 0 END IF
         IF cl_null(l_lmd15_sum1) THEN LET l_lmd15_sum1 = 0 END IF
         IF cl_null(l_lmd15_sum2) THEN LET l_lmd15_sum2 = 0 END IF
         LET l_lmd06_sum1 = l_lmd06_sum1 + g_lia.lia101
         LET l_lmd06_sum2 = l_lmd06_sum2 + g_lia.lia101
         LET l_lmd15_sum1 = l_lmd15_sum1 + g_lia.lia111
         LET l_lmd15_sum2 = l_lmd15_sum2 + g_lia.lia111
         SELECT lmb07,lmb08 INTO l_lmb07,l_lmb08 FROM lmb_file WHERE lmbstore = g_lia.liaplant AND lmb02 = g_lia.lia07
         SELECT lmc08,lmc09 INTO l_lmc08,l_lmc09 FROM lmc_file WHERE lmcstore = g_lia.liaplant AND lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08
         IF NOT cl_null(l_lmb07) THEN
            #樓棟測量面積或者建築面積超出樓棟圖紙面積
            IF (l_lmb07 < l_lmd06_sum2) THEN LET g_errno = 'alm-265' END IF
         END IF
         IF NOT cl_null(l_lmb08) THEN
            #樓棟測量面積或者建築面積超出樓棟圖紙面積
            IF (l_lmb08 < l_lmd15_sum2) THEN LET g_errno = 'alm-265' END IF
         END IF
         IF cl_null(g_errno) THEN
            IF NOT cl_null(l_lmc08) THEN
               #樓層測量面積或者建築面積超出樓層圖紙面積
               IF (l_lmc08 < l_lmd06_sum1) THEN LET g_errno = 'alm-439' END IF
            END IF 
            IF NOT cl_null(l_lmc09) THEN
               #樓層測量面積或者建築面積超出樓層圖紙面積
               IF (l_lmc09 < l_lmd15_sum1) THEN LET g_errno = 'alm-439' END IF
            END IF 
         END IF
      OTHERWISE
         EXIT CASE
   END CASE
END FUNCTION

FUNCTION t130_set_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lia01",TRUE)
   END IF
END FUNCTION

FUNCTION t130_set_no_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'u' THEN
      CALL cl_set_comp_entry("lia01",FALSE)
   END IF
END FUNCTION

FUNCTION t130_set_lia_entry()

   CASE g_lia.lia03
      WHEN '1'
         CALL cl_set_comp_entry("lia07,lia08,lia09,lia111,lia121,lia14",TRUE)
         IF g_aza.aza110 = 'Y' THEN
            CALL cl_set_comp_entry("lia04",FALSE)
            CALL cl_set_comp_required("lia04",FALSE)
         END IF
      WHEN '2'
         CALL cl_set_comp_entry("lia07,lia08,lia09",FALSE)
         CALL cl_set_comp_entry("lia111,lia121,lia14",TRUE)
         CALL cl_set_comp_entry("lia04",TRUE)
         CALL cl_set_comp_required("lia04",TRUE)
      WHEN '3'
         CALL cl_set_comp_entry("lia07,lia08,lia09,lia111,lia121,lia14",FALSE)
         CALL cl_set_comp_entry("lia04",TRUE)
         CALL cl_set_comp_required("lia04",TRUE)
      OTHERWISE
         EXIT CASE
   END CASE
END FUNCTION

FUNCTION t130_pic()
   CASE g_lia.liaconf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE 
       
   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lia.liaacti)
END FUNCTION

FUNCTION t130_chk_lia04()
DEFINE l_n   LIKE type_file.num5
DEFINE l_sql STRING

   LET g_errno = ''
   CASE g_lia.lia03
      WHEN '1'
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM lmd_file WHERE lmd01 = g_lia.lia04
         IF l_n > 0 THEN
            LET g_errno = 'alm-014'
         END IF
      OTHERWISE
         LET l_n = 0
         LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant,'lia_file'),
                     " WHERE lia04 = '",g_lia.lia04,"' AND lia05 = '",g_lia.lia05,"' AND lia15 = '2'"
         PREPARE sel_lia_pre3 FROM l_sql
         EXECUTE sel_lia_pre3 INTO l_n
         IF l_n > 0 THEN 
            LET g_errno = 'alm-744'
         END IF
   END CASE
END FUNCTION

FUNCTION t130_iss()
DEFINE l_count LIKE type_file.num5
DEFINE l_sql   STRING   #FUN-BA0118 Add


   IF g_lia.lia01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01

   IF g_lia.liaplant <> g_plant THEN 
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   IF g_lia.lia15 = '0' THEN CALL cl_err('','art-124',0) RETURN END IF
   IF g_lia.lia15 = '2' THEN CALL cl_err('','art-125',0) RETURN END IF

   CALL t130_chk_lia04()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN 
   END IF

   CALL t130_lmc_chk()
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN
   END IF

   IF NOT cl_confirm('alm-207') THEN RETURN END IF

   BEGIN WORK
   CALL s_showmsg_init()
   OPEN t130_cl USING g_lia.lia01
   IF STATUS THEN
      CALL cl_err("OPEN t130_cl:", STATUS, 1)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t130_cl INTO g_lia.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lia.lia01,SQLCA.sqlcode,0)
      CLOSE t130_cl
      ROLLBACK WORK
      RETURN
   END IF

   LET g_success = 'Y'

   CASE g_lia.lia03
      WHEN '1'
         CALL t130_ins_lmd()
         CALL t130_upd_data()
      WHEN '2'
         CALL t130_upd_lmd('2')
         CALL t130_upd_data()
      WHEN '3'
         CALL t130_upd_lmd('3')
         CALL t130_upd_data()
   END CASE

  #FUN-BA0118 Add Begin ---
   IF NOT cl_null(g_lia.lia06) THEN
      IF cl_confirm('alm-874') THEN
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM ",cl_get_target_table(g_plant,'lia_file'),
                     " WHERE lib05 = '",g_lib.lib05,"' AND lib16 <> '2' "
         PREPARE sel_count_pre FROM l_sql
         EXECUTE sel_count_pre INTO l_count
         IF l_count > 0 THEN
            CALL cl_err('','alm-783',0)
            LET g_success = 'N'
         END IF
         IF g_success = 'Y' THEN
            CALL t130_lib()
         END IF
      END IF
   END IF
  #FUN-BA0118 Add End -----

   UPDATE lia_file SET lia15 = '2' WHERE lia01 = g_lia.lia01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('g_lia.lia01',g_lia.lia01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CALL s_showmsg()
   IF g_success = 'Y' THEN
      CALL cl_err('','alm-940',0)
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lia.* FROM lia_file WHERE lia01 = g_lia.lia01
   DISPLAY BY NAME g_lia.lia15
   CLOSE t130_cl
END FUNCTION

#新增一筆場地資料
FUNCTION t130_ins_lmd()

   INSERT INTO lmd_file(lmd01,lmd02,lmd03,lmd04,lmd05,lmd06,lmd07,lmd08,lmd09,lmd10,
                        lmd11,lmd12,lmd13,lmd14,lmd15,lmd16,lmdacti,lmdcrat,lmddate,
                        lmdgrup,lmdlegal,lmdmodu,lmduser,lmdoriu,lmdorig,lmdstore)
                 VALUES(g_lia.lia04,'',g_lia.lia07,g_lia.lia08,g_lia.lia121,
                        g_lia.lia101,g_lia.lia13,'','','Y',g_user,g_today,
                        g_lia.lia14,g_lia.lia09,g_lia.lia111,g_lia.lia05,'Y',
                        g_today,g_today,g_grup,g_legal,'',g_user,g_user,g_grup,g_plant)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lmd01',g_lia.lia04,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION

#更新場地資料
FUNCTION t130_upd_lmd(p_cmd)
DEFINE p_cmd   LIKE type_file.chr1

   CASE p_cmd
      WHEN '2'
         UPDATE lmd_file SET lmd16   = g_lia.lia05,   #版本號
                             lmd06   = g_lia.lia101,  #建築面積
                             lmd15   = g_lia.lia111,  #測量面積
                             lmd05   = g_lia.lia121,  #經營面積
                             lmdmodu = g_user,        #資料修改者
                             lmddate = g_today        #資料修改日
          WHERE lmd01 = g_lia.lia04 AND lmdstore = g_lia.liaplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('lmd01',g_lia.lia04,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      WHEN '3'
         UPDATE lmd_file SET lmd10   = 'X',           #確認碼
                             lmd16   = g_lia.lia05,   #版本號
                             lmdmodu = g_user,        #資料修改者
                             lmddate = g_today        #資料修改日
          WHERE lmd01 = g_lia.lia04 AND lmdstore = g_lia.liaplant
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('lmd01',g_lia.lia04,'',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
   END CASE
END FUNCTION

#更新門店資料、樓棟資料、樓層資料和區域資料
FUNCTION t130_upd_data()
DEFINE l_lmd05_sum1  LIKE lmd_file.lmd05    #門店經營面積
DEFINE l_lmd05_sum2  LIKE lmd_file.lmd05    #樓棟經營面積
DEFINE l_lmd05_sum3  LIKE lmd_file.lmd05    #樓層經營面積
DEFINE l_lmd05_sum4  LIKE lmd_file.lmd05    #區域經營面積
DEFINE l_lmd06_sum1  LIKE lmd_file.lmd06    #門店建築面積
DEFINE l_lmd06_sum2  LIKE lmd_file.lmd06    #樓棟建築面積
DEFINE l_lmd06_sum3  LIKE lmd_file.lmd06    #樓層建築面積
DEFINE l_lmd06_sum4  LIKE lmd_file.lmd06    #區域建築面積
DEFINE l_lmd15_sum1  LIKE lmd_file.lmd15    #門店測量面積
DEFINE l_lmd15_sum2  LIKE lmd_file.lmd15    #樓棟測量面積
DEFINE l_lmd15_sum3  LIKE lmd_file.lmd15    #樓層測量面積
DEFINE l_lmd15_sum4  LIKE lmd_file.lmd15    #區域測量面積

   SELECT SUM(lmd05),SUM(lmd06),SUM(lmd15) INTO l_lmd05_sum1,l_lmd06_sum1,l_lmd15_sum1 
     FROM lmd_file 
    WHERE lmdstore = g_lia.liaplant AND lmd10 = 'Y'
   SELECT SUM(lmd05),SUM(lmd06),SUM(lmd15) INTO l_lmd05_sum2,l_lmd06_sum2,l_lmd15_sum2 
     FROM lmd_file 
    WHERE lmdstore = g_lia.liaplant AND lmd10 = 'Y' AND lmd03 = g_lia.lia07
   SELECT SUM(lmd05),SUM(lmd06),SUM(lmd15) INTO l_lmd05_sum3,l_lmd06_sum3,l_lmd15_sum3 
     FROM lmd_file 
    WHERE lmdstore = g_lia.liaplant AND lmd10 = 'Y' AND lmd03 = g_lia.lia07 AND lmd04 = g_lia.lia08
   IF NOT cl_null(g_lia.lia09) THEN
      SELECT SUM(lmd05),SUM(lmd06),SUM(lmd15) INTO l_lmd05_sum4,l_lmd06_sum4,l_lmd15_sum4 
        FROM lmd_file 
       WHERE lmdstore = g_lia.liaplant AND lmd10 = 'Y' 
         AND lmd03 = g_lia.lia07 AND lmd04 = g_lia.lia08 AND lmd14 = g_lia.lia09
   END IF
   IF cl_null(l_lmd05_sum1) THEN LET l_lmd05_sum1 = 0 END IF
   IF cl_null(l_lmd05_sum2) THEN LET l_lmd05_sum2 = 0 END IF
   IF cl_null(l_lmd05_sum3) THEN LET l_lmd05_sum3 = 0 END IF
   IF cl_null(l_lmd05_sum4) THEN LET l_lmd05_sum4 = 0 END IF
   IF cl_null(l_lmd06_sum1) THEN LET l_lmd06_sum1 = 0 END IF
   IF NOT cl_null(g_lia.lia101) THEN
      IF cl_null(l_lmd06_sum1) THEN LET l_lmd06_sum1 = 0 END IF
      IF cl_null(l_lmd06_sum2) THEN LET l_lmd06_sum2 = 0 END IF
      IF cl_null(l_lmd06_sum3) THEN LET l_lmd06_sum3 = 0 END IF
      IF cl_null(l_lmd06_sum4) THEN LET l_lmd06_sum4 = 0 END IF
   END IF
   IF cl_null(l_lmd15_sum1) THEN LET l_lmd15_sum1 = 0 END IF
   IF cl_null(l_lmd15_sum2) THEN LET l_lmd15_sum2 = 0 END IF
   IF cl_null(l_lmd15_sum3) THEN LET l_lmd15_sum3 = 0 END IF
   IF cl_null(l_lmd15_sum4) THEN LET l_lmd15_sum4 = 0 END IF
   UPDATE rtz_file SET rtz22   = l_lmd06_sum1,  #門店建築面積
                       rtz30   = l_lmd15_sum1,  #門店測量面積
                       rtz23   = l_lmd05_sum1,  #門店經營面積
                       rtzmodu = g_user,
                       rtzdate = g_today
    WHERE rtz01 = g_lia.liaplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('rtz01',g_lia.liaplant,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   UPDATE lmb_file SET lmb05 = l_lmd06_sum2,    #樓棟建築面積
                       lmb09 = l_lmd15_sum2,    #樓棟測量面積
                       lmb04 = l_lmd05_sum2     #樓棟經營面積
    WHERE lmb02 = g_lia.lia07 AND lmbstore = g_lia.liaplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lmb02',g_lia.lia07,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   UPDATE lmc_file SET lmc06 = l_lmd06_sum3,    #樓層建築面積
                       lmc10 = l_lmd15_sum3,    #樓層測量面積
                       lmc05 = l_lmd05_sum3     #樓層經營面積
    WHERE lmc02 = g_lia.lia07 AND lmc03 = g_lia.lia08 AND lmcstore = g_lia.liaplant
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('lmc02',g_lia.lia07,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF NOT cl_null(g_lia.lia09) THEN
      UPDATE lmy_file SET lmy05 = l_lmd06_sum4,    #區域建築面積
                          lmy06 = l_lmd15_sum4,    #區域測量面積
                          lmy07 = l_lmd05_sum4     #樓層經營面積
       WHERE lmy01 = g_lia.lia07 AND lmy02 = g_lia.lia08 
         AND lmy03 = g_lia.lia09 AND lmystore = g_lia.liaplant
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('lmy01',g_lia.lia07,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION

#FUN-BA0118 Add Begin ---
FUNCTION t130_lib()
DEFINE l_lmf  RECORD LIKE lmf_file.*
DEFINE l_lie  RECORD LIKE lie_file.*
DEFINE l_lic  RECORD LIKE lic_file.*
DEFINE l_sql  STRING
DEFINE l_n    LIKE type_file.num5

   OPEN WINDOW t130_w1 WITH FORM "alm/42f/almt130_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("almt130_1")
   
   LET g_lib.lib02 = g_today

   INPUT BY NAME g_lib.lib01,g_lib.lib02
         
      AFTER FIELD lib01
         IF NOT cl_null(g_lib.lib01) THEN
            CALL s_check_no("alm",g_lib.lib01,g_lib.lib01,"O5","lib_file","lib01","")
               RETURNING li_result,g_lib.lib01
            IF (NOT li_result) THEN
               INITIALIZE g_lib.lib01 TO NULL
               DISPLAY BY NAME g_lib.lib01
               NEXT FIELD lib01
            END IF
            SELECT oayapr INTO g_lib.libmksg FROM oay_file WHERE oayslip = g_lib.lib01
         END IF

      ON ACTION controlp
         CASE
            WHEN INFIELD(lib01)
               LET g_t1 = s_get_doc_no(g_lib.lib01)
               CALL q_oay(FALSE,FALSE,g_t1,'O5','ALM') RETURNING g_t1
               LET g_lib.lib01 = g_t1
               DISPLAY BY NAME g_lib.lib01
               NEXT FIELD lib01
            OTHERWISE
               EXIT CASE
         END CASE

       ON ACTION CONTROLR
          CALL cl_show_req_fields()

       ON ACTION CONTROLG
          CALL cl_cmdask()

       ON ACTION about
          CALL cl_about()

       ON ACTION HELP
          CALL cl_show_help()

       AFTER INPUT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             EXIT INPUT
          END IF
   END INPUT

   IF INT_FLAG THEN
      LET g_success = 'N'
      CLOSE WINDOW t130_w1
      RETURN
   END IF

   CLOSE WINDOW t130_w1

   CALL s_auto_assign_no("alm",g_lib.lib01,g_today,"O5","lib_file","lib01","","","")
      RETURNING li_result,g_lib.lib01

   IF cl_null(g_lib.lib01) THEN
      LET g_success = 'N'
      RETURN
   END IF
   #根據面積變更申請單單號帶出攤位編號
   SELECT lnt06 INTO g_lib.lib05 
     FROM lnt_file 
    WHERE lnt01 = (SELECT lja05 
                     FROM lja_file 
                    WHERE lja01 = g_lia.lia06)
   IF NOT cl_null(g_lib.lib05) THEN
      SELECT lmf03,lmf04,lmf05,lmf09,lmf10,lmf11,lmf15+1,lmf12,lmf13,lmf14
        INTO g_lib.lib07,g_lib.lib08,g_lib.lib14,g_lib.lib09,g_lib.lib10,g_lib.lib11,
             g_lib.lib06,g_lib.lib12,g_lib.lib13,g_lib.lib15
        FROM lmf_file WHERE lmf01 = g_lib.lib05
   END IF

   IF NOT cl_null(g_lib.lib05) THEN
      LET l_sql = " SELECT COUNT(*) ",
                  "   FROM ",cl_get_target_table(g_plant,"lib_file"),
                  "  WHERE lib05 = '",g_lib.lib05,"' AND libconf = 'N' AND lib03 = '2' "
      PREPARE t130_chk_lib05_pre FROM l_sql
      EXECUTE t130_chk_lib05_pre INTO l_n
      IF l_n > 0 THEN 
         CALL s_errmsg('',g_lib.lib05,'','alm-783',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   LET g_lib.lib03 = '2'
   LET g_lib.lib04 = g_lia.lia06
   LET g_lib.libplant = g_plant
   LET g_lib.liblegal = g_legal
   LET g_lib.libconf = 'Y'
   LET g_lib.libcond = g_today
   LET g_lib.libconu = g_user
   LET g_lib.lib16 = '2'
   LET g_lib.libuser = g_user
   LET g_lib.liboriu = g_user
   LET g_lib.liborig = g_grup 
   LET g_lib.libgrup = g_grup
   LET g_lib.libmodu = NULL
   LET g_lib.libdate = NULL
   LET g_lib.libacti = 'Y'
   LET g_lib.libcrat = g_today

   #新增攤位申請單單頭
   INSERT INTO lib_file VALUES(g_lib.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('ins lib_file',g_lib.lib01,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CALL t130_inslic()    #新增攤位申請單單身 - 場地單身
   CALL t130_inslid()    #新增攤位申請單單身 - 分類單身
   CALL t130_lib_sum()   #計算場地總面積回寫至單頭
   CALL t130_chk_area()  #

   #將攤位資料變更發出
   IF g_success = 'Y' THEN
      LET l_lmf.lmf01 = g_lib.lib05
      LET l_lmf.lmf03 = g_lib.lib07
      LET l_lmf.lmf04 = g_lib.lib08
      LET l_lmf.lmf05 = g_lib.lib14
      LET l_lmf.lmf06 = 'Y'
      LET l_lmf.lmf07 = g_user
      LET l_lmf.lmf08 = g_today
      LET l_lmf.lmf09 = g_lib.lib091
      LET l_lmf.lmf10 = g_lib.lib101
      LET l_lmf.lmf11 = g_lib.lib111
      LET l_lmf.lmf12 = g_lib.lib12
      LET l_lmf.lmf13 = g_lib.lib13
      LET l_lmf.lmf14 = g_lib.lib15
      LET l_lmf.lmf15 = g_lib.lib06
      LET l_lmf.lmfacti  = 'Y'
      LET l_lmf.lmfcrat  = g_lib.libcrat
      LET l_lmf.lmfuser  = g_lib.libuser
      LET l_lmf.lmfdate  = g_today
      LET l_lmf.lmfgrup  = g_lib.libgrup
      LET l_lmf.lmfstore = g_lib.libplant
      LET l_lmf.lmflegal = g_lib.liblegal
      LET l_lmf.lmforiu  = g_lib.liboriu
      LET l_lmf.lmforig  = g_lib.liborig
      UPDATE lmf_file SET lmf_file.* = l_lmf.*
       WHERE lmf01 = g_lib.lib05
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd lmf_file',g_lib.lib05,'',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      #單身資料只變更場地單身中資料狀態為修改的資料
      LET l_sql = " SELECT * FROM lic_file WHERE lic01 = '",g_lib.lib01,"'"
      PREPARE pre_lie1 FROM l_sql
      DECLARE cur_lie1 CURSOR FOR  pre_lie1
      FOREACH cur_lie1 INTO l_lic.*
         IF l_lic.lic02 = '1' THEN
            LET l_lie.lie01 = g_lib.lib05
            LET l_lie.lie02 = l_lic.lic03
            LET l_lie.lie03 = l_lic.lic04
            LET l_lie.lie04 = l_lic.lic05
            LET l_lie.lie05 = l_lic.lic06
            LET l_lie.lie06 = l_lic.lic07
            LET l_lie.lie07 = l_lic.lic08
            LET l_lie.lieacti = 'Y'
            LET l_lie.lielegal = l_lic.liclegal
            LET l_lie.liestore = l_lic.licplant
            INSERT INTO lie_file VALUES (l_lie.*)
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('ins lie_file',g_lib.lib05,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
            UPDATE lmd_file SET lmd07 = 'Y'
             WHERE lmd01 = l_lic.lic03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('upd lmd_file',l_lic.lic03,'',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         IF l_lic.lic02 = '2' THEN
            LET l_lie.lie01 = g_lib.lib05
            LET l_lie.lie02 = l_lic.lic03
            LET l_lie.lie03 = l_lic.lic04
            LET l_lie.lie04 = l_lic.lic05
            LET l_lie.lie05 = l_lic.lic06
            LET l_lie.lie06 = l_lic.lic07
            LET l_lie.lie07 = l_lic.lic08
            LET l_lie.lieacti = 'Y'
            LET l_lie.lielegal = l_lic.liclegal
            LET l_lie.liestore = l_lic.licplant
            UPDATE lie_file SET lie_file.* = l_lie.*
             WHERE lie01 = g_lib.lib05 AND lie02 = l_lic.lic03
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('upd lie_file',g_lib.lib05,l_lic.lic03,SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF
         IF l_lic.lic02 = '3' THEN
            SELECT COUNT(*) INTO l_n FROM lie_file
             WHERE lie01 = g_lib.lib05 AND lie02 = l_lic.lic03
            IF l_n > 0 THEN
               DELETE FROM lie_file WHERE lie01 = g_lib.lib05 AND lie02 = l_lic.lic03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL s_errmsg('del lie_file',g_lib.lib05,l_lic.lic03,SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               UPDATE lmd_file SET lmd07 = 'N'
                WHERE lmd01 = l_lic.lic03
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL s_errmsg('upd lmd_file',l_lic.lic03,'',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
            END IF
         END IF
      END FOREACH
   END IF
   
END FUNCTION
#FUN-BA0118 Add End -----

#FUN-BA0118 Add Begin ---
FUNCTION t130_inslic()
DEFINE l_lie   RECORD LIKE lie_file.*
DEFINE l_lmd06 LIKE lmd_file.lmd06
DEFINE l_lmd15 LIKE lmd_file.lmd15
DEFINE l_lmd05 LIKE lmd_file.lmd05
DEFINE l_f     LIKE type_file.chr1
DEFINE l_lmd10 LIKE lmd_file.lmd10

   LET g_sql = " SELECT lie02,lie03,lie04,lie05,lie06,lie07,lieacti FROM lie_file ",
               "  WHERE lie01 = '",g_lib.lib05,"'"
   PREPARE pre_get_lic FROM g_sql
   DECLARE pre_lic_cur CURSOR FOR pre_get_lic
   BEGIN WORK
   FOREACH pre_lic_cur INTO l_lie.lie02,l_lie.lie03,l_lie.lie04,
                            l_lie.lie05,l_lie.lie06,l_lie.lie07,l_lie.lieacti
      SELECT lmd06,lmd15,lmd05,lmd10 INTO l_lmd06,l_lmd15,l_lmd05,l_lmd10
        FROM lmd_file WHERE lmd01 = l_lie.lie02
      IF l_lmd06 <> l_lie.lie05 OR l_lmd15 <> l_lie.lie06 OR l_lmd05 <> l_lie.lie07 THEN
         LET l_f = '2'
      ELSE
         IF l_lmd10 = 'X' THEN
            LET l_f = '3'
            LET l_lie.lieacti = 'N'
         ELSE
            LET l_f = '0'
         END IF
      END IF
      INSERT INTO lic_file(lic01,lic02,lic03,lic04,lic05,lic06,lic07,lic08,licacti,
                           licplant,liclegal)
                    VALUES(g_lib.lib01,l_f,l_lie.lie02,l_lie.lie03,
                           l_lie.lie04,l_lmd06,l_lmd15,l_lmd05,l_lie.lieacti,
                           g_lib.libplant,g_lib.liblegal)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ins lic_file',g_lib.lib01,"",SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   IF g_lia.lia03 = '1' THEN
      INSERT INTO lic_file(lic01,lic02,lic03,lic04,lic05,lic06,lic07,lic08,licacti,
                           licplant,liclegal)
                    VALUES(g_lib.lib01,'1',g_lia.lia04,g_lia.lia08,g_lia.lia09,
                           g_lia.lia101,g_lia.lia111,g_lia.lia121,'Y',g_lia.liaplant,g_lia.lialegal)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ins lic_file',g_lib.lib01,"",SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION t130_inslid()            
DEFINE l_lml   RECORD LIKE lml_file.*
                                   
   LET g_sql = " SELECT lml02,lml06 FROM lml_file ",
               "  WHERE lml01 = '",g_lib.lib05,"'"
   PREPARE pre_get_lid FROM g_sql
   DECLARE pre_lid_cur CURSOR FOR pre_get_lid
   BEGIN WORK   
   FOREACH pre_lid_cur INTO l_lml.lml02,l_lml.lml06
    
      INSERT INTO lid_file(lid01,lid02,lid03,lidacti,lidplant,lidlegal)
                    VALUES(g_lib.lib01,'0',l_lml.lml02,l_lml.lml06,
                           g_lib.libplant,g_lib.liblegal)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg("ins lid_file",g_lib.lib01,"",SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN   
      END IF      
   END FOREACH    
END FUNCTION

FUNCTION t130_lib_sum()

   IF NOT cl_null(g_lib.lib01) THEN
      SELECT SUM(lic06) INTO g_lib.lib091 FROM lic_file WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
      IF cl_null(g_lib.lib091) THEN LET g_lib.lib091 = 0 END IF
      SELECT SUM(lic07) INTO g_lib.lib101 FROM lic_file WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
      IF cl_null(g_lib.lib101) THEN LET g_lib.lib101 = 0 END IF
      SELECT SUM(lic08) INTO g_lib.lib111 FROM lic_file WHERE lic01 = g_lib.lib01 AND licacti = 'Y'
      IF cl_null(g_lib.lib111) THEN LET g_lib.lib111 = 0 END IF
      UPDATE lib_file SET lib091 = g_lib.lib091,
                          lib101 = g_lib.lib101,
                          lib111 = g_lib.lib111
       WHERE  lib01 = g_lib.lib01
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg("upd lib_file",g_lib.lib01,"",SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION

FUNCTION t130_chk_area()
DEFINE l_lja081 LIKE lja_file.lja081
DEFINE l_lja091 LIKE lja_file.lja091
DEFINE l_lja101 LIKE lja_file.lja101

   SELECT lja081,lja091,lja101 INTO l_lja081,l_lja091,l_lja101
     FROM lja_file
    WHERE lja01 = g_lia.lia06
   IF l_lja081 <> g_lib.lib091 OR l_lja091 <> g_lib.lib101 OR l_lja101 <> g_lib.lib111 THEN
      CALL s_errmsg("",g_lia.lia01,"","alm-875",1) #面積變更不符合'面積變更申請單'中的設置
      LET g_success = 'N'
   END IF
END FUNCTION
#FUN-BA0118 Add End -----

#TQC-C20528 Add Begin ---
FUNCTION t130_chk_lia02()
DEFINE l_lja11 LIKE lja_file.lja11

   LET g_errno = ''
   SELECT lja11 INTO l_lja11 FROM lja_file WHERE lja01 = g_lia.lia06 AND lja02 = '4'
   IF NOT cl_null(l_lja11) THEN
      IF l_lja11 <> g_lia.lia02 THEN
         LET g_errno  = 'alm1595' #申請類型為修改時，申請日期必須和面積變更申請單的生效日期一致！
      END IF
   END IF
END FUNCTION
#TQC-C20528 Add End -----

#FUN-B80141


# Prog. Version..: '5.30.06-13.04.09(00007)'     #
#
# Pattern name...: almt320.4gl
# Descriptions...: 攤位預租協議作業 
# Date & Author..: NO.FUN-B90056 11/09/08 By nanbing
# Modify.........: No.FUN-BB0117 11/11/28 By nanbing 更改产生费用单
# Modify.........: No:FUN-B90121 12/01/13 By shiwuying bug修改

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20525 12/02/29 by fanbj 產生費用單時直接收款欄位賦值’N',新增加取消確認action，按鈕重新排序
# Modify.........: No:FUN-C50036 12/05/21 by fanbj 增加pos邏輯
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-D20015 13/03/26 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE   g_lih                RECORD LIKE lih_file.*      
DEFINE   g_lih_t              RECORD LIKE lih_file.*   
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
DEFINE   g_lla04              LIKE lla_file.lla04    
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

   LET g_forupd_sql = "SELECT * FROM lih_file WHERE lih01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t320_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
   OPEN WINDOW t320_w WITH FORM "alm/42f/almt320"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("lihpos",g_aza.aza88='Y')       #FUN-C50036 add  
   SELECT lla04 INTO g_lla04 FROM lla_file
    WHERE llastore = g_plant
   LET g_action_choice = ""
   CALL t320_menu()

   CLOSE WINDOW t320_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t320_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01

   CLEAR FORM
   CALL cl_set_head_visible("","YES")   
   INITIALIZE g_lih.* TO NULL
   CONSTRUCT BY NAME g_wc ON lih01,lih02,lih03,lih04,lihplant,lihlegal,lih05,lih06,
                             lih07,lih08,lih09,lih10,lih11,lih12,lih13,lih14,lih15,
                             lih16,lih17,lih18,lih19,lih20,lih21,lih23,lih24,
                             #lihconf,lihconu,lihcond,lih22,lihuser,lihgrup,              #FUN-C50036 mark
                             lihconf,lihconu,lihcond,lihpos,lih22,lihuser,lihgrup,        #FUN-C50036 add
                             lihoriu,lihmodu,lihdate,lihorig,lihacti,lihcrat
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      ON ACTION controlp
         CASE
            WHEN INFIELD(lih01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih01"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih01
               NEXT FIELD lih01
            WHEN INFIELD(lih03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih03_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih03
               NEXT FIELD lih03
            WHEN INFIELD(lih04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih04_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih04
               NEXT FIELD lih04
            WHEN INFIELD(lihplant)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lihplant" 
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lihplant
               NEXT FIELD lihplant
            WHEN INFIELD(lihlegal)
               CALL cl_init_qry_var()
               LET g_qryparam.state = 'c'
               LET g_qryparam.form ="q_lihlegal" 
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               LET g_qryparam.where = " lihplant IN ",g_auth," " 
               DISPLAY g_qryparam.multiret TO lihlegal
               NEXT FIELD lihlegal

            WHEN INFIELD(lih05)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih05"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih05
               NEXT FIELD lih05
            WHEN INFIELD(lih06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih06"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih06
               NEXT FIELD lih06
            WHEN INFIELD(lih07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih07_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih07
               NEXT FIELD lih07
            WHEN INFIELD(lih08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih08_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih08
               NEXT FIELD lih08
            WHEN INFIELD(lih09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih09_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih09
               NEXT FIELD lih09
            WHEN INFIELD(lih10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih10_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih10
               NEXT FIELD lih10
            WHEN INFIELD(lih12)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih12"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih12
               NEXT FIELD lih12
            WHEN INFIELD(lih20)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih20_1"
               LET g_qryparam.state = "c"
               LET g_qryparam.where = " lihplant IN ",g_auth," "
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lih20
               NEXT FIELD lih20
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lihuser', 'lihgrup')

   LET g_sql = "SELECT lih01 FROM lih_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND lihplant IN ",g_auth,
               " ORDER BY lih01"

   PREPARE t320_prepare FROM g_sql
   DECLARE t320_cs
      SCROLL CURSOR WITH HOLD FOR t320_prepare
   
   LET g_sql = "SELECT COUNT(*) FROM lih_file ",
               " WHERE ",g_wc CLIPPED,
               "   AND lihplant IN ",g_auth

   PREPARE t320_precount FROM g_sql
   DECLARE t320_count CURSOR FOR t320_precount

END FUNCTION

FUNCTION t320_menu()
DEFINE l_msg        LIKE type_file.chr1000
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index,g_row_count)

         ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t320_a()
            END IF
   
         ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL t320_q()
            END IF

         ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL t320_u()
            END IF

         ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
               CALL t320_x()
            END IF
            CALL t320_pic()

         ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
               CALL t320_r()
            END IF

         #TQC-C20525--start add-------------------------------
         ON ACTION check_expense
            LET g_action_choice="check_expense"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lih.lih12) THEN
                  LET l_msg = "artt610  '1' '",g_lih.lih12,"'"
                  CALL cl_cmdrun_wait(l_msg)
               END IF
            ELSE
               CALL cl_err('',-4001,1)
            END IF
         #TQC-C20525--end add---------------------------------

         ON ACTION confirm
            LET g_action_choice="confirm"
            IF cl_chk_act_auth() THEN
               CALL t320_y()
            END IF
            CALL t320_pic()

         #TQC-C20525--start add--------------------------------
         ON ACTION unconfirm
            LET g_action_choice="unconfirm"
            IF cl_chk_act_auth() THEN
               CALL t320_unconfirm()
            END IF
            CALL t320_pic()
         #TQC-C20525--end add----------------------------------

         #TQC-C20525--start mark-------------------------------
         #ON ACTION check_expense
         #   LET g_action_choice="check_expense"
         #   IF cl_chk_act_auth() THEN
         #      IF NOT cl_null(g_lih.lih12) THEN 
         #         LET l_msg = "artt610  '1' '",g_lih.lih12,"'"   
         #         CALL cl_cmdrun_wait(l_msg) 
         #      END IF          
         #   ELSE
         #      CALL cl_err('',-4001,1)
         #   END IF
         #TQC-C20525--end mark---------------------------------
         ON ACTION stop
            LET g_action_choice="stop"
            IF cl_chk_act_auth() THEN
               CALL t320_stop()
            END IF          
         ON ACTION help
            CALL cl_show_help()
            
         ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
   
         ON ACTION next
            CALL t320_fetch('N')
   
         ON ACTION previous
            CALL t320_fetch('P')

         ON ACTION jump
            CALL t320_fetch('/')
            
         ON ACTION first
            CALL t320_fetch('F')
            
         ON ACTION last
            CALL t320_fetch('L')

         ON ACTION controlg
            CALL cl_cmdask()
            
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            CALL t320_pic()
             
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
               IF NOT cl_null(g_lih.lih01) THEN
                  LET g_doc.column1 = "lih01"
                  LET g_doc.value1 = g_lih.lih01
                  CALL cl_doc()
               END IF
            END IF
   END MENU
   CLOSE t320_cs
END FUNCTION

FUNCTION t320_q()

    LET  g_row_count = 0
    LET  g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)

    INITIALIZE g_lih.* TO NULL
    INITIALIZE g_lih_t.* TO NULL

    LET g_wc = NULL

    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY ' ' TO FORMONLY.cnt

    CALL t320_cs()

    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       INITIALIZE g_lih.* TO NULL
       LET g_wc = NULL
       RETURN
    END IF
    
    OPEN t320_count
    FETCH t320_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt

    OPEN t320_cs
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
       INITIALIZE g_lih.* TO NULL
       LET g_wc = NULL
    ELSE
       CALL t320_fetch('F')
    END IF
END FUNCTION

FUNCTION t320_fetch(p_flag)
DEFINE p_flag LIKE type_file.chr1

   CASE p_flag
      WHEN 'N' FETCH NEXT     t320_cs INTO g_lih.lih01
      WHEN 'P' FETCH PREVIOUS t320_cs INTO g_lih.lih01
      WHEN 'F' FETCH FIRST    t320_cs INTO g_lih.lih01
      WHEN 'L' FETCH LAST     t320_cs INTO g_lih.lih01
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
         FETCH ABSOLUTE g_jump t320_cs INTO g_lih.lih01
         LET g_no_ask = FALSE
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
      INITIALIZE g_lih.* TO NULL
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

   SELECT * INTO g_lih.* FROM lih_file
    WHERE lih01 = g_lih.lih01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
   ELSE
      LET g_data_owner = g_lih.lihuser
      LET g_data_group = g_lih.lihgrup
      CALL t320_show()
   END IF
END FUNCTION
FUNCTION t320_show()

   LET g_lih_t.* = g_lih.*
   DISPLAY BY NAME g_lih.lih01,g_lih.lih02,g_lih.lih03,g_lih.lih04,g_lih.lihplant,
                   g_lih.lihlegal,g_lih.lih05,g_lih.lih06,g_lih.lih07,g_lih.lih08,
                   g_lih.lih09,g_lih.lih10,g_lih.lih11,g_lih.lih12,g_lih.lih13,
                   g_lih.lih14,g_lih.lih15,g_lih.lih16,g_lih.lih17,g_lih.lih18,
                   g_lih.lih19,g_lih.lih20,g_lih.lih21,g_lih.lih23,g_lih.lih24,
                   #g_lih.lihconf,g_lih.lihconu,g_lih.lihcond,g_lih.lih22,                #FUN-C50036 mark
                   g_lih.lihconf,g_lih.lihconu,g_lih.lihcond,g_lih.lihpos,g_lih.lih22,    #FUN-C50036 add
                   g_lih.lihuser,g_lih.lihgrup,g_lih.lihoriu,g_lih.lihorig,
                   g_lih.lihmodu,g_lih.lihdate,g_lih.lihacti,g_lih.lihcrat
   CALL t320_lihplant('d')                   
   CALL t320_lih07('d')
   CALL t320_lih08('d')
   CALL t320_lih09('d')
   CALL t320_lih10('d')
   CALL t320_lih20('d')
   CALL t320_lih19()
   CALL t320_pic()
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION t320_a()
DEFINE l_rtz13 LIKE rtz_file.rtz13
DEFINE l_azt02 LIKE azt_file.azt02

   MESSAGE ""
   CLEAR FORM    
   INITIALIZE g_lih.*    LIKE lih_file.*
   INITIALIZE g_lih_t.*  LIKE lih_file.*
    
   LET g_wc = NULL
   CALL cl_opmsg('a')

   WHILE TRUE
      LET g_lih.lihuser = g_user
      LET g_lih.lihoriu = g_user
      LET g_lih.lihorig = g_grup
      LET g_lih.lihgrup = g_grup
      LET g_lih.lihcrat = g_today
      LET g_lih.lihdate = g_today
      LET g_lih.lihacti = 'Y'
      LET g_lih.lih02 = '1'
      LET g_lih.lihplant = g_plant
      LET g_lih.lihlegal = g_legal
      LET g_lih.lih13 = g_today
      LET g_lih.lih21 = 'N'
      LET g_lih.lih23 = 'N'
      LET g_lih.lih24 = '0'
      LET g_lih.lihconf = 'N'
      LET g_lih.lihpos = '1'         #FUN-C50036 add
 
      CALL t320_i("a")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         INITIALIZE g_lih.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF
      IF cl_null(g_lih.lih01) THEN
         CONTINUE WHILE
      END IF
      CALL s_auto_assign_no("alm",g_lih.lih01,g_today,"O7","lih_file","lih01","","","")
         RETURNING li_result,g_lih.lih01
      IF (NOT li_result) THEN  CONTINUE WHILE  END IF
      DISPLAY BY NAME g_lih.lih01

      INSERT INTO lih_file VALUES(g_lih.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lih.lih01,SQLCA.SQLCODE,0)
         CONTINUE WHILE
      ELSE
         SELECT * INTO g_lih.* FROM lih_file
          WHERE lih01 = g_lih.lih01
      END IF
      EXIT WHILE
   END WHILE
   LET g_wc = NULL
END FUNCTION

FUNCTION t320_i(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1

   DISPLAY BY NAME g_lih.lih01,g_lih.lih02,g_lih.lih03,g_lih.lih04,g_lih.lihplant,
                   g_lih.lihlegal,g_lih.lih05,g_lih.lih06,g_lih.lih07,g_lih.lih08,
                   g_lih.lih09,g_lih.lih10,g_lih.lih11,g_lih.lih12,g_lih.lih13,
                   g_lih.lih14,g_lih.lih15,g_lih.lih16,g_lih.lih17,g_lih.lih18,
                   g_lih.lih19,g_lih.lih20,g_lih.lih21,g_lih.lih23,g_lih.lih24,
                   #g_lih.lihconf,g_lih.lihconu,g_lih.lihcond,g_lih.lih22,               #FUN-C50036 mark
                   g_lih.lihconf,g_lih.lihconu,g_lih.lihcond,g_lih.lihpos,g_lih.lih22,   #FUN-C50036 add
                   g_lih.lihuser,g_lih.lihgrup,g_lih.lihoriu,g_lih.lihorig,
                   g_lih.lihmodu,g_lih.lihdate,g_lih.lihacti,g_lih.lihcrat
                   
   INPUT BY NAME   g_lih.lihplant,g_lih.lih01,g_lih.lih02,g_lih.lih03,
                   g_lih.lihlegal,g_lih.lih07,g_lih.lih08,g_lih.lih09,g_lih.lih10,
                   g_lih.lih11,g_lih.lih13,g_lih.lih14,g_lih.lih15,
                   #g_lih.lih20,g_lih.lih21,g_lih.lih22                                  #FUN-C50036 mark
                   g_lih.lih20,g_lih.lih21,g_lih.lihpos,g_lih.lih22                      #FUN-C50036 add
                      WITHOUT DEFAULTS
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t320_set_entry(p_cmd)
         CALL t320_set_no_entry(p_cmd)
         IF g_lih.lih02 = '2' THEN
            CALL cl_set_comp_entry("lih03",TRUE)
            CALL cl_set_comp_required("lih03",TRUE)
         ELSE
            CALL cl_set_comp_entry("lih03",FALSE)
            CALL cl_set_comp_required("lih03",FALSE)  
         END IF
         IF NOT cl_null(g_lih.lih11) THEN
            CALL cl_set_comp_required("lih10",TRUE)
         ELSE
            CALL cl_set_comp_required("lih10",FALSE)  
         END IF        
         LET g_before_input_done = TRUE         
         CALL cl_set_docno_format("lih01")
      AFTER FIELD lihplant
         IF g_lih.lihplant IS NOT NULL THEN
            CALL t320_lihplant(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lih.lihplant,g_errno,1)
               LET g_lih.lihplant = g_lih_t.lihplant
               LET INT_FLAG = 1
               EXIT INPUT
            END IF
         END IF  
      AFTER FIELD lih01
         IF NOT cl_null(g_lih.lih01) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND g_lih_t.lih01 <> g_lih.lih01) THEN
               CALL s_check_no("alm",g_lih.lih01,g_lih_t.lih01,"O7","lih_file","lih01,lihplant","")
                  RETURNING li_result,g_lih.lih01
               IF (NOT li_result) THEN
                  LET g_lih.lih01 = g_lih_t.lih01
                  NEXT FIELD lih01
               END IF
               LET g_t1=s_get_doc_no(g_lih.lih01)
               SELECT oayapr INTO g_lih.lih23 FROM oay_file WHERE oayslip = g_t1
               DISPLAY BY NAME g_lih.lih23
            END IF
         END IF  
      ON CHANGE lih02
         IF g_lih.lih02 = '2' THEN
            CALL cl_set_comp_entry("lih03",TRUE)
            CALL cl_set_comp_required("lih03",TRUE)  
         ELSE
            LET g_lih.lih03 = ''
            DISPLAY BY NAME g_lih.lih03
            CALL cl_set_comp_entry("lih03",FALSE)
            CALL cl_set_comp_required("lih03",FALSE)  
         END IF
      AFTER FIELD lih03
         IF NOT cl_null(g_lih.lih03) THEN
            CALL t320_lih03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lih.lih03 = g_lih_t.lih03
               DISPLAY BY NAME g_lih.lih03
               NEXT FIELD lih03
            END IF
         END IF        

      AFTER FIELD lih07
         IF NOT cl_null(g_lih.lih07) THEN
            IF g_lih.lih07 <> 'MISC' THEN
               IF NOT cl_null(g_lih.lih14) AND NOT cl_null(g_lih.lih15) THEN 
                  CALL t320_check_date(g_lih.lih07,g_lih.lih14,g_lih.lih15)	
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)                        
                     NEXT FIELD lih07
                  END IF
               ELSE 
                  CALL t320_lih07(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lih.lih07 = g_lih_t.lih07
                     DISPLAY BY NAME g_lih.lih07
                     NEXT FIELD lih07
                  END IF
               END IF   
            END IF   
         END IF      
      AFTER FIELD lih08
         IF NOT cl_null(g_lih.lih08) THEN
            CALL t320_lih08(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lih.lih08 = g_lih_t.lih08
               DISPLAY BY NAME g_lih.lih08
               NEXT FIELD lih08
            END IF
         END IF      
      AFTER FIELD lih09
         IF NOT cl_null(g_lih.lih09) THEN
            CALL t320_lih09(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lih.lih09 = g_lih_t.lih09
               DISPLAY BY NAME g_lih.lih09
               NEXT FIELD lih09
            END IF
         END IF      
      AFTER FIELD lih10
         IF NOT cl_null(g_lih.lih10) THEN
            CALL t320_lih10(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lih.lih10 = g_lih_t.lih10
               DISPLAY BY NAME g_lih.lih10
               NEXT FIELD lih10
            END IF
         END IF
      ON CHANGE lih11
         IF NOT cl_null(g_lih.lih11) THEN
            IF g_lih.lih11 <= 0 THEN
               CALL cl_err('','alm1037',0)
               NEXT FIELD lih11
            END IF 
            CALL cl_set_comp_required("lih10",TRUE)            
            CALL cl_digcut(g_lih.lih11,g_lla04) RETURNING g_lih.lih11 
            DISPLAY BY NAME g_lih.lih11 
         ELSE  
            CALL cl_set_comp_required("lih10",FALSE)     
         END IF  
      AFTER FIELD lih11
         IF NOT cl_null(g_lih.lih11) THEN 
            CALL cl_set_comp_required("lih10",TRUE) 
         ELSE 
            CALL cl_set_comp_required("lih10",FALSE)     
         END IF  
      AFTER FIELD lih14
         IF NOT cl_null(g_lih.lih14) THEN
            IF g_lih.lih14 < g_today THEN 
               CALL cl_err('','alm1335',0)
               NEXT FIELD lih14
            END IF    
            IF NOT cl_null(g_lih.lih15) THEN
               IF g_lih.lih14 > g_lih.lih15 THEN
                  CALL cl_err('','alm1038',0)
                  LET g_lih.lih14 = NULL
                  NEXT FIELD lih14
               END IF
               IF NOT cl_null(g_lih.lih07) THEN
                  CALL t320_check_date(g_lih.lih07,g_lih.lih14,g_lih.lih15)	
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lih.lih14 = NULL
                     NEXT FIELD lih14
                  END IF                     
               END IF    
            END IF
         END IF   
      AFTER FIELD lih15
         IF NOT cl_null(g_lih.lih15) THEN
            IF g_lih.lih15 < g_today THEN 
               CALL cl_err('','alm1335',0)
               NEXT FIELD lih15
            END IF 
            IF NOT cl_null(g_lih.lih14) THEN
               IF g_lih.lih14 > g_lih.lih15 THEN
                  CALL cl_err('','alm1038',0)
                  LET g_lih.lih15 = NULL
                  NEXT FIELD lih15
               END IF
               IF NOT cl_null(g_lih.lih07) THEN
                  CALL t320_check_date(g_lih.lih07,g_lih.lih14,g_lih.lih15)	
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     LET g_lih.lih15 = NULL
                     NEXT FIELD lih15
                  END IF
               END IF    
            END IF
         END IF         
      AFTER FIELD lih20
         IF NOT cl_null(g_lih.lih20) THEN
            CALL t320_lih20(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lih.lih20 = g_lih_t.lih20
               DISPLAY BY NAME g_lih.lih20
               NEXT FIELD lih20
            END IF
         END IF  
      AFTER INPUT
         LET g_lih.lihuser = s_get_data_owner("lih_file") #FUN-C10039
         LET g_lih.lihgrup = s_get_data_group("lih_file") #FUN-C10039
         IF INT_FLAG THEN          
            EXIT INPUT
         END IF  
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(lih01)
               LET g_t1=s_get_doc_no(g_lih.lih01)
               CALL q_oay(FALSE,FALSE,g_t1,'O7','alm') RETURNING g_t1
               LET g_lih.lih01 = g_t1
               DISPLAY BY NAME g_lih.lih01
               NEXT FIELD lih01
            WHEN INFIELD(lih03)
               IF g_lih.lih02 = '1' THEN
                  EXIT CASE
               ELSE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_lih03"
                  CALL cl_create_qry() RETURNING g_lih.lih03
                  DISPLAY BY NAME g_lih.lih03
                  CALL t320_lih03('d')
                  NEXT FIELD lih03
               END IF  

            WHEN INFIELD(lih07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih07"
               LET g_qryparam.where = " lmfstore = '",g_lih.lihplant,"'"
               CALL cl_create_qry() RETURNING g_lih.lih07
               DISPLAY BY NAME g_lih.lih07
               CALL t320_lih07('d')
               NEXT FIELD lih07 
            WHEN INFIELD(lih08)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih08"
               LET g_qryparam.arg1 = g_plant            
               CALL cl_create_qry() RETURNING g_lih.lih08
               DISPLAY BY NAME g_lih.lih08
               CALL t320_lih08('d')
               NEXT FIELD lih08      
            WHEN INFIELD(lih09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih09"
               CALL cl_create_qry() RETURNING g_lih.lih09
               DISPLAY BY NAME g_lih.lih09
               CALL t320_lih09('d')
               NEXT FIELD lih09      
            WHEN INFIELD(lih10)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oaj4"
               LET g_qryparam.where = " oaj05 = '01' "
               CALL cl_create_qry() RETURNING g_lih.lih10
               DISPLAY BY NAME g_lih.lih10
               CALL t320_lih10('d')
               NEXT FIELD lih10  
            WHEN INFIELD(lih20)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lih20"
               CALL cl_create_qry() RETURNING g_lih.lih20
               DISPLAY BY NAME g_lih.lih20
               CALL t320_lih20('d')
               NEXT FIELD lih20                  
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
FUNCTION t320_u()

   IF cl_null(g_lih.lih01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
   SELECT * INTO g_lih.* FROM lih_file WHERE lih01 = g_lih.lih01   
   IF g_lih.lihconf = 'Y' THEN
      CALL cl_err(g_lih.lih01,'alm-027',1)
      RETURN
   END IF 
   IF g_lih.lihconf = 'S' THEN
      CALL cl_err(g_lih.lih01,'alm1048',1)
      RETURN
   END IF
   IF g_lih.lihplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   IF g_lih.lihacti = 'N' THEN
      CALL cl_err(g_lih.lih01,9027,0)
      RETURN
   END IF
       
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK

   OPEN t320_cl USING g_lih.lih01
   IF STATUS THEN
      CALL cl_err("OPEN t320_cl:",STATUS,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t320_cl INTO g_lih.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lih.lih01,SQLCA.sqlcode,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF

   CALL t320_show()
   WHILE TRUE
      LET g_lih_t.* = g_lih.*
      LET g_lih.lihmodu=g_user
      LET g_lih.lihdate=g_today

      CALL t320_i("u")
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_lih.*=g_lih_t.*
         CALL t320_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF

      #FUN-C50036--start add-------------------------
      IF g_aza.aza88 ='Y' THEN
         IF g_lih_t.lihpos = '1' THEN
            LET g_lih.lihpos =  '1'
         ELSE 
            LET g_lih.lihpos = '2'
         END IF 
         DISPLAY BY NAME g_lih.lihpos  
      END IF 
      #FUN-C50036--end add---------------------------

      UPDATE lih_file SET lih_file.* = g_lih.*
       WHERE lih01 = g_lih_t.lih01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t320_cl
   COMMIT WORK
END FUNCTION

FUNCTION t320_x()

   IF cl_null(g_lih.lih01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lih.lihconf = 'Y' THEN
      CALL cl_err(g_lih.lih01,'alm-027',1)
      RETURN
   END IF
   IF g_lih.lihconf = 'S' THEN
      CALL cl_err(g_lih.lih01,'alm1048',1)
      RETURN
   END IF
   BEGIN WORK

   OPEN t320_cl USING g_lih.lih01
   IF STATUS THEN
      CALL cl_err("OPEN t320_cl:",STATUS,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t320_cl INTO g_lih.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lih.lih01,SQLCA.sqlcode,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t320_show()

   IF cl_exp(0,0,g_lih.lihacti) THEN
      LET g_chr=g_lih.lihacti
      IF g_lih.lihacti='Y' THEN
         LET g_lih.lihacti='N'
         LET g_lih.lihmodu = g_user
         LET g_lih.lihdate = g_today
      ELSE
         LET g_lih.lihacti='Y'
         LET g_lih.lihmodu = g_user
         LET g_lih.lihdate = g_today
      END IF
      UPDATE lih_file SET lihacti = g_lih.lihacti,
                          lihmodu = g_lih.lihmodu,
                          lihdate = g_lih.lihdate
       WHERE lih01 = g_lih.lih01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
         LET g_lih.lihacti = g_chr
         DISPLAY BY NAME g_lih.lihacti
         CLOSE t320_cl
         ROLLBACK WORK
         RETURN
      END IF
      DISPLAY BY NAME g_lih.lihmodu,g_lih.lihdate,g_lih.lihacti
   END IF
   CLOSE t320_cl
   COMMIT WORK
END FUNCTION

FUNCTION t320_r()

   IF cl_null(g_lih.lih01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_lih.* FROM lih_file WHERE lih01 = g_lih.lih01   

   IF g_lih.lihconf = 'Y' THEN
      CALL cl_err(g_lih.lih01,'alm-028',1)
      RETURN
   END IF
   IF g_lih.lihconf = 'S' THEN
      CALL cl_err(g_lih.lih01,'alm1048',1)
      RETURN
   END IF
   IF g_lih.lihplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   BEGIN WORK

   OPEN t320_cl USING g_lih.lih01
   IF STATUS THEN
      CALL cl_err("OPEN t320_cl:",STATUS,0)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t320_cl INTO g_lih.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF

   #FUN-C50036--start add-------------------------------
   IF NOT ((g_lih.lihpos = '3' AND g_lih.lihacti = 'Y') 
       OR (g_lih.lihpos = '1')) THEN
      CALL cl_err('','apc-139',0)
      RETURN
   END IF   
   #FUN-C50036--end add---------------------------------

   CALL t320_show()

   IF cl_delete() THEN
      INITIALIZE g_doc.* TO NULL
      LET g_doc.column1 = "lih01"
      LET g_doc.value1 = g_lih.lih01
      CALL cl_del_doc()
      DELETE FROM lih_file WHERE lih01 = g_lih.lih01
      CLEAR FORM
      OPEN t320_count
      IF STATUS THEN
         CLOSE t320_cs
         CLOSE t320_count
         COMMIT WORK
         RETURN
      END IF
      FETCH t320_count INTO g_row_count
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t320_cs
         CLOSE t320_count
         COMMIT WORK
         RETURN
      END IF
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t320_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t320_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t320_fetch('/')
      END IF
   END IF
   CLOSE t320_cl
   COMMIT WORK
END FUNCTION

FUNCTION t320_y()

   IF cl_null(g_lih.lih01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lih.* FROM lih_file
    WHERE lih01 = g_lih.lih01

   IF g_lih.lihacti ='N' THEN
      CALL cl_err(g_lih.lih01,'alm-004',1)
      RETURN
   END IF
   IF g_lih.lihconf = 'Y' THEN
      CALL cl_err(g_lih.lihconf,'alm-005',1)
      RETURN
   END IF
   IF g_lih.lihconf = 'S' THEN
      CALL cl_err(g_lih.lihconf,'alm1048',1)
      RETURN
   END IF
   IF g_lih.lihplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF
   IF g_lih.lih07 = 'MISC' THEN
      CALL cl_err(g_lih.lih07,'alm1049',0)
      RETURN
   ELSE
      CALL t320_check_date(g_lih.lih07,g_lih.lih14,g_lih.lih15)
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,0)                        
         RETURN
      END IF         
   END IF
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   END IF
   
   BEGIN WORK 
   LET g_success = 'Y'

   OPEN t320_cl USING g_lih.lih01
   IF STATUS THEN 
      CALL cl_err("open t320_cl:",STATUS,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF 
   FETCH t320_cl INTO g_lih.*
   IF SQLCA.sqlcode  THEN 
     CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
     CLOSE t320_cl
     ROLLBACK WORK
     RETURN
   END IF
   CALL t320_chk()
   IF g_success = 'Y' THEN
      UPDATE lih_file SET lihconf = 'Y',
                          lih24   = '1',
                          lih12   = g_lih.lih12,
                          lihconu = g_user,
                          lihcond = g_today,
                          lihmodu = g_user,
                          lihdate = g_today
       WHERE lih01 = g_lih.lih01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lih:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
      END IF
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lih.* FROM lih_file WHERE lih01 = g_lih.lih01
   DISPLAY BY NAME g_lih.*
   CLOSE t320_cl
   COMMIT WORK
   MESSAGE " "
END FUNCTION

#TQC-C20525--start add--------------------------------------------
FUNCTION t320_unconfirm()
   DEFINE l_lihconu        LIKE lih_file.lihconu
   DEFINE l_lihcond        LIKE lih_file.lihcond
   DEFINE l_lua15          LIKE lua_file.lua15
   DEFINE l_n              LIKE type_file.num5
 
   IF cl_null(g_lih.lih01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF   

   SELECT * INTO g_lih.*
     FROM lih_file
    WHERE lih01 = g_lih.lih01

   IF g_lih.lihconf = 'N' THEN
      CALL cl_err(g_lih.lih01,'asf-216',1)
      RETURN
   END IF

   IF g_lih.lihconf = 'S' THEN
      CALL cl_err(g_lih.lih01,'alm1592',1)
      RETURN
   END IF

   #FUN-C50036--start add-----------------
   IF g_lih.lihpos = '3' OR g_lih.lihpos = '2' THEN
      CALL cl_err('','alm1622',0)
      RETURN 
   END IF 
   #FUN-C50036--end add-------------------

   SELECT lua15 INTO l_lua15
     FROM lua_file
    WHERE lua01 = g_lih.lih12

   IF (l_lua15 = 'Y') THEN
      CALL cl_err('','alm1055',1)
      RETURN
   END IF

   SELECT count(*) INTO l_n
     FROM rxy_file
    WHERE rxy01 = g_lih.lih12

   IF l_n > 0 THEN
      CALL cl_err('','alm1056',0)
      RETURN
   END IF

   LET g_success = 'Y' 

   BEGIN WORK   

   OPEN t320_cl USING g_lih.lih01
   IF STATUS THEN
      CALL cl_err("open t320_cl:",STATUS,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t320_cl INTO g_lih.*
   IF SQLCA.sqlcode  THEN
     CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
     CLOSE t320_cl
     ROLLBACK WORK
     RETURN
   END IF    

   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
      LET g_lih.lihconf = 'N'
      #CHI-D20015---modify---str---
      #LET g_lih.lihconu = NULL
      #LET g_lih.lihcond = NULL
      LET g_lih.lihconu = g_user
      LET g_lih.lihcond = g_today
      #CHI-D20015---modify---end---
      LET g_lih.lihmodu = g_user
      LET g_lih.lihdate = g_today

      DELETE FROM lua_file WHERE lua01 = g_lih.lih12
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lua_file",g_lih.lih12,"",SQLCA.SQLCODE,
                       "","",0)
         LET g_success='N'
      END IF

      DELETE FROM lub_file WHERE lub01 = g_lih.lih12
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","lih_file",g_lih.lih12,"",SQLCA.SQLCODE,
                       "","",0)
         LET g_success='N'
      END IF

      IF g_lih.lih14 <= g_today AND g_today <= g_lih.lih15 THEN   
         UPDATE lmf_file 
            SET lmf05 = '1'
          WHERE lmf01 = g_lih.lih07
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('update lmf_file:',SQLCA.SQLCODE,0)
            LET g_success = 'N'
         END IF
      END IF     
     
      LET g_lih.lih12 =''

      UPDATE lih_file
         SET lihconf = g_lih.lihconf,
             lihconu = g_lih.lihconu,
             lihcond = g_lih.lihcond,
             lihmodu = g_lih.lihmodu,
             lihdate = g_lih.lihdate,
             lih12   = g_lih.lih12
         WHERE lih01 = g_lih.lih01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd lih:',SQLCA.SQLCODE,0)
         LET g_lih.lihconf = "Y"
         LET g_lih.lihconu = l_lihconu
         LET g_lih.lihcond = l_lihcond
         DISPLAY BY NAME g_lih.lihconf,g_lih.lihconu,g_lih.lihcond
         LET g_success = 'N'  
      ELSE
         DISPLAY BY NAME g_lih.lih12,g_lih.lihconf,g_lih.lihconu,g_lih.lihcond,g_lih.lihmodu,g_lih.lihdate
      END IF
   END IF
   CLOSE t320_cl
   IF g_success = 'Y' THEN
      COMMIT WORK   
   ELSE
      ROLLBACK WORK
   END IF 
END FUNCTION
#TQC-C20525--end add----------------------------------------------

FUNCTION t320_lihplant(p_cmd)
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
    WHERE rtz01=g_lih.lihplant
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
       WHERE azt01 = g_lih.lihlegal
 
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION

FUNCTION t320_lih03(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1, 
        l_lnt26   LIKE lnt_file.lnt26, #審核
        #l_lnt03   LIKE lnt_file.lnt03, #簽訂日期
        l_lnt06   LIKE lnt_file.lnt06, #攤位號
        l_lnt08   LIKE lnt_file.lnt08, #樓棟編號
        l_lnt09   LIKE lnt_file.lnt09, #樓層編號
        l_lnt04   LIKE lnt_file.lnt04,
        l_lnt30   LIKE lnt_file.lnt30,
        #l_lnt23   LIKE lnt_file.lnt23, #合同終止時間
        l_lne05  LIKE lne_file.lne05, #商戶簡稱
        l_lmf13   LIKE lmf_file.lmf13, #
        l_tqa02   LIKE tqa_file.tqa02,#代碼描述        
        l_lmb03   LIKE lmb_file.lmb03, #樓棟名稱
        l_lmc04   LIKE lmc_file.lmc04  #樓層名稱
   LET g_errno = ''     
   SELECT lnt26,lnt06,lnt08,lnt09,lnt04,lnt30
     INTO l_lnt26,l_lnt06,l_lnt08,l_lnt09,l_lnt04,l_lnt30
     FROM lnt_file
    WHERE lnt01 = g_lih.lih03
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm-132'
      WHEN l_lnt26 <> 'Y'        LET g_errno = 'alm1041'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_lih.lih07 = l_lnt06
      LET g_lih.lih05 = l_lnt08
      LET g_lih.lih06 = l_lnt09
      LET g_lih.lih08 = l_lnt04
      LET g_lih.lih09 = l_lnt30
      DISPLAY BY NAME
        g_lih.lih07,g_lih.lih05,g_lih.lih06,g_lih.lih08,g_lih.lih09
      SELECT lmf13 INTO l_lmf13 FROM lmf_file WHERE lmf01 = g_lih.lih07  
      SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmb02 = g_lih.lih05
      SELECT lmc04 INTO l_lmc04 
        FROM lmc_file 
       WHERE lmc02 = g_lih.lih05 AND lmc03 = g_lih.lih06
      SELECT lne05 INTO l_lne05 FROM lne_file
       WHERE lne01 = g_lih.lih08 
      SELECT tqa02 INTO l_tqa02 FROM tqa_file
       WHERE tqa01 = g_lih.lih09
         AND tqa03 = '2'
      DISPLAY l_lmb03,l_lmc04,l_lmf13 ,l_lne05,l_tqa02
       TO FORMONLY.lmb03,FORMONLY.lmc04,FORMONLY.lmf13,FORMONLY.lne05,FORMONLY.tqa02 
   END IF
        
END FUNCTION

FUNCTION t320_lih07(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,
        l_lmf03   LIKE lmf_file.lmf03, #樓棟編號
        l_lmf04   LIKE lmf_file.lmf04, #樓層編號
        l_lmf06   LIKE lmf_file.lmf06, #確認碼
        l_lmf13   LIKE lmf_file.lmf13, #門牌號      
        l_lmb03   LIKE lmb_file.lmb03, #樓棟名稱
        l_lmc04   LIKE lmc_file.lmc04  #樓層名稱
   LET g_errno = ''
   SELECT lmf03,lmf04,lmf06,lmf13
     INTO l_lmf03,l_lmf04,l_lmf06,l_lmf13
     FROM lmf_file
    WHERE lmf01 = g_lih.lih07
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm-042'
      WHEN l_lmf06 <> 'Y'        LET g_errno = 'alm-059'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_lih.lih05 = l_lmf03
      LET g_lih.lih06 = l_lmf04
      DISPLAY BY NAME g_lih.lih05,g_lih.lih06
      SELECT lmb03 INTO l_lmb03 FROM lmb_file WHERE lmb02 = l_lmf03
      SELECT lmc04 INTO l_lmc04 
        FROM lmc_file 
       WHERE lmc02 = l_lmf03 AND lmc03 = l_lmf04
      DISPLAY l_lmb03,l_lmc04,l_lmf13 TO FORMONLY.lmb03,FORMONLY.lmc04,FORMONLY.lmf13 
   END IF   
END FUNCTION
    
FUNCTION t320_lih08(p_cmd) #商戶號
DEFINE  p_cmd    LIKE type_file.chr1,
        l_lne04  LIKE lne_file.lne04, #门店编号
        l_lne05  LIKE lne_file.lne05, #商戶簡稱
        l_lne36  LIKE lne_file.lne36, #確認碼
        l_lnh07  LIKE lnh_file.lnh07  #商戶狀態
   LET g_errno = ''     
   SELECT lne05,lne36 INTO l_lne05,l_lne36
     FROM lne_file
    WHERE lne01 = g_lih.lih08
   CASE 
      WHEN SQLCA.sqlcode = 100       LET g_errno = 'alm-133'
      WHEN l_lne36 <> 'Y'            LET g_errno = 'alm1042'
   #  WHEN l_lnh07 <> '1'            LET g_errno = 'alm1043'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
  #FUN-B90121 Begin---
   IF cl_null(g_errno) THEN
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM lnh_file
       WHERE lnh01 = g_lih.lih08
         AND lnhstore = g_plant
         AND lnh07 = '1'
      IF g_cnt = 0 THEN
         LET g_errno = 'alm1043'
      END IF
   END IF
  #FUN-B90121 End---
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_lne05 TO FORMONLY.lne05   
   END IF  
END FUNCTION
FUNCTION t320_lih09(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_tqa01   LIKE tqa_file.tqa01,#代碼
       l_tqa02   LIKE tqa_file.tqa02,#代碼描述
       l_tqaacti LIKE tqa_file.tqaacti
   LET g_errno = ''    
   SELECT tqa02,tqaacti 
     INTO l_tqa02,l_tqaacti
     FROM tqa_file
    WHERE tqa01 = g_lih.lih09
      AND tqa03 = '2'
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm-046'
      WHEN l_tqaacti = 'N'       LET g_errno = 'alm-139'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_tqa02 TO FORMONLY.tqa02   
   END IF     
END FUNCTION
FUNCTION t320_lih10(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,
        l_oaj02   LIKE oaj_file.oaj02,#費用名稱
        l_oaj05   LIKE oaj_file.oaj05,#費用類型 
        l_oajacti LIKE oaj_file.oajacti
    LET g_errno = ''    
    SELECT oaj02,oaj05,oajacti 
      INTO l_oaj02,l_oaj05,l_oajacti
      FROM oaj_file
     WHERE oaj01 = g_lih.lih10
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'axm-360'
      WHEN l_oaj05 <> '01'       LET g_errno = 'alm1058'
      WHEN l_oajacti = 'N'       LET g_errno = 'alm1044'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_oaj02 TO FORMONLY.oaj02   
   END IF  
END FUNCTION
FUNCTION t320_lih20(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1,
       l_gen02   LIKE gen_file.gen02,#員工姓名
       l_genacti LIKE gen_file.genacti
   LET g_errno = ''    
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file
    WHERE gen01 = g_lih.lih20
   CASE 
      WHEN SQLCA.sqlcode = 100   LET g_errno = 'alm1045'
      WHEN l_genacti = 'N'       LET g_errno = 'alm1046'
      OTHERWISE
           LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_gen02 TO FORMONLY.gen02_1   
   END IF   

END FUNCTION
FUNCTION t320_lih19()     
DEFINE  l_gen02   LIKE gen_file.gen02#員工姓名

   SELECT gen02 INTO l_gen02
     FROM gen_file
    WHERE gen01 = g_lih.lih19
   DISPLAY l_gen02 TO FORMONLY.gen02   
END FUNCTION

	#检查摊位有没有重叠的日期														
FUNCTION t320_check_date(p_lmf01,p_stardate,p_enddate)														
   DEFINE p_lmf01     LIKE lmf_file.lmf01       # 摊位编号														
   DEFINE p_stardate  LIKE type_file.dat        # 预租开始日期														
   DEFINE p_enddate   LIKE type_file.dat        # 预租结束日期														
   DEFINE l_lmf05        LIKE lmf_file.lmf05      #摊位状态														
   DEFINE l_n         INTEGER														
   LET g_errno = ''	            														
	   #1未出租，2已出租，3预租														
   SELECT lmf05 INTO l_lmf05														
     FROM lmf_file														
    WHERE lmf01=p_lmf01														
   LET l_n = 0       														
   CASE l_lmf05														
      WHEN '2'              #检查预租日期和合同日期有没有重叠														
         SELECT COUNT(*) INTO l_n														
           FROM lnt_file														
          WHERE lnt26 = 'Y'														
            AND lnt06=p_lmf01														
            AND (														
                 lnt17 BETWEEN p_stardate AND p_enddate														
               OR  lnt18 BETWEEN p_stardate AND p_enddate														
               OR  (lnt17 <=p_stardate AND lnt18>= p_enddate)														
                )														
            														
         IF l_n>0 THEN 														
            #CALL cl_err('','alm1035',1)
            LET g_errno = 'alm1035'            
         END IF 
         IF cl_null(g_errno) THEN
	        SELECT COUNT(*) INTO l_n														
	          FROM lih_file														
	         WHERE lihconf='Y'														
	           AND lih07=p_lmf01														
	           AND (														
	                lih14 BETWEEN p_stardate AND p_enddate														
	               OR  lih15 BETWEEN p_stardate AND p_enddate														
	               OR  (lih14 <=p_stardate AND lih15>= p_enddate)														
	               )														
            IF l_n>0 THEN														
               #CALL cl_err('','alm1036',1)	
               LET g_errno = 'alm1036' 
            END IF    
         END IF
      WHEN '3'              #检查预租日期有没有重叠	
         SELECT COUNT(*) INTO l_n														
	       FROM lih_file														
	      WHERE lihconf='Y'														
	        AND lih07=p_lmf01														
	        AND (														
	             lih14 BETWEEN p_stardate AND p_enddate														
	            OR  lih15 BETWEEN p_stardate AND p_enddate														
	            OR  (lih14 <=p_stardate AND lih15>= p_enddate)														
	            )														
         IF l_n>0 THEN														
            #CALL cl_err('','alm1036',1)	
            LET g_errno = 'alm1036' 
         END IF 
         IF cl_null(g_errno) THEN 
            SELECT COUNT(*) INTO l_n														
              FROM lnt_file														
             WHERE lnt26 = 'Y'														
               AND lnt06=p_lmf01														
               AND (														
                    lnt17 BETWEEN p_stardate AND p_enddate														
                   OR  lnt18 BETWEEN p_stardate AND p_enddate														
                   OR  (lnt17 <=p_stardate AND lnt18>= p_enddate)														
                    )														
            														
            IF l_n>0 THEN 														
               #CALL cl_err('','alm1035',1)
               LET g_errno = 'alm1035'            
            END IF
         END IF           
   END CASE   																												
								
END FUNCTION														
FUNCTION t320_chk()
DEFINE  l_cnt    LIKE type_file.num5,
        l_lua01  LIKE lua_file.lua01,#費用單編號
        l_occ02  LIKE occ_file.occ02,#客戶簡稱
        l_occ41  LIKE occ_file.occ41,#慣用稅別
        l_gec04  LIKE gec_file.gec04,#稅率
        l_gec07  LIKE gec_file.gec07,#單價含稅否
        l_lub04  LIKE lub_file.lub04,#未稅金額
        l_lub04t LIKE lub_file.lub04t,#含稅金額
        l_msg    LIKE type_file.chr1000,
        l_lub10  LIKE lub_file.lub10,
        l_ooz09  LIKE ooz_file.ooz09,
        l_lub09  LIKE lub_file.lub09 #FUN-BB0117 add
DEFINE  l_lua05  LIKE lua_file.lua05
DEFINE  l_lua37  LIKE lua_file.lua37

   IF g_lih.lih11 > 0 THEN      
      LET l_cnt=0
      SELECT count(*) INTO l_cnt FROM lua_file
       WHERE lua12 = g_lih.lih01
      IF l_cnt=0 THEN
         #FUN-C90050 mark begin---
         #SELECT rye03 INTO g_lua01 FROM rye_file
         # WHERE rye01 = 'art' AND rye02 = 'B9'
         #FUN-C90050 mark end-----

         CALL s_get_defslip('art','B9',g_plant,'N') RETURNING g_lua01    #FUN-C90050 add

         LET g_dd = g_today
         OPEN WINDOW t320_1_w WITH FORM "alm/42f/almt320_1"
            ATTRIBUTE(STYLE=g_win_style CLIPPED)
         CALL cl_ui_locale("almt320_1")
         DISPLAY g_lua01 TO FORMONLY.g_lua01
         DISPLAY g_dd TO FORMONLY.g_dd
         INPUT  BY NAME g_lua01,g_dd   WITHOUT DEFAULTS
            BEFORE INPUT

            AFTER FIELD g_lua01
               LET l_cnt = 0
               SELECT COUNT(*) INTO  l_cnt FROM oay_file
                WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01
               IF l_cnt = 0 THEN
                  CALL cl_err(g_lua01,'art-800',0)
                  NEXT FIELD g_lua01
               END IF

            ON ACTION CONTROLR
               CALL cl_show_req_fields()

            ON ACTION CONTROLG
               CALL cl_cmdask()

            ON ACTION CONTROLF
               CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
               CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

            ON ACTION controlp
               CASE
                  WHEN INFIELD(g_lua01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_slip"
                     LET g_qryparam.default1 = g_lua01
                     CALL cl_create_qry() RETURNING g_lua01
                     DISPLAY BY NAME g_lua01
                     NEXT FIELD g_lua01
                     OTHERWISE EXIT CASE
               END CASE
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT

            ON ACTION about
               CALL cl_about()

            ON ACTION HELP
               CALL cl_show_help()
         END INPUT
         IF INT_FLAG THEN
            LET INT_FLAG=0
            CLOSE WINDOW t320_1_w
            CALL cl_err('',9001,0)
            LET g_success = 'N'
            RETURN
         END IF
         CLOSE WINDOW t320_1_w
         ####自動編號
         CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")
            RETURNING li_result,l_lua01

         CALL s_auto_assign_no("art",g_lua01,g_dd,'B9',"lua_file","lua01","","","")
            RETURNING li_result,l_lua01
         IF NOT li_result THEN
            CALL cl_err('','alm-859',0)
            LET g_success = 'N'
            RETURN
         END IF
         SELECT occ02,occ41 INTO l_occ02,l_occ41 FROM occ_file
          WHERE occ01 = g_lih.lih08
         SELECT gec04,gec07 INTO l_gec04,l_gec07 FROM gec_file
          WHERE gec01 = l_occ41
        
         LET l_lub04t = g_lih.lih11
         LET l_lub04 = g_lih.lih11/(1 + l_gec04/100)
         CALL cl_digcut(l_lub04,g_lla04) RETURNING l_lub04
         #FUN-BB0117 start
         SELECT oaj05 INTO l_lub09 FROM oaj_file
          WHERE oaj01 = g_lih.lih10  
         #FUN-BB0117 end 
         SELECT ooz09 INTO l_ooz09 FROM ooz_file 
         IF g_lih.lih14 <= l_ooz09 THEN 
            LET l_lub10 = l_ooz09 + 1
         ELSE 
            LET l_lub10 = g_lih.lih14   
         END IF         
         INSERT INTO lub_file(lub01,lub02,lub03,lub04,lub04t,lub05,
                              lub06,lub07,lub08,lubplant,lublegal,
                              lub09,lub10,lub11,lub12,lub13,lub14,lub15) #FUN-BB0117 add
                       VALUES(l_lua01,'1',g_lih.lih10,l_lub04,l_lub04t,'',
                              '',g_lih.lih14,g_lih.lih15,g_plant,g_legal,
                              l_lub09,l_lub10,0,0,'N','','')  #FUN-BB0117 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('insert lub_file:',SQLCA.SQLCODE,0)
            LET g_success = 'N'
            RETURN
         END IF
         IF s_chk_own(g_lih.lih08) THEN
            LET l_lua05 = 'Y'
            LET l_lua37 = 'N'
         ELSE
            LET l_lua05 = 'N'
            #LET l_lua37 = 'Y'        #TQC-C20525 mark
            LET l_lua37 = 'N'        #TQC-C20525 add
         END IF
         INSERT INTO lua_file(luaplant,lualegal,lua01,lua02,lua03,lua04,lua05,lua06,
                             lua061,lua07,lua21,lua22,lua23,lua08,lua08t,lua09,
                             lua10,lua11,lua12,lua13,lua14,lua15,lua16,lua17,lua19,  
                             lua18,luauser,luacrat,luamodu,luaacti,luagrup,luadate,luaoriu,luaorig,lua32,
                             lua33,lua34,lua35,lua36,lua37,lua38,lua39)  # FUN-BB0117 add
          VALUES(g_plant,g_legal,l_lua01,'01','','',l_lua05,g_lih.lih08,
                 l_occ02 ,g_lih.lih07,l_occ41,l_gec04,l_gec07,l_lub04,l_lub04t,g_today,
                 'Y','4',g_lih.lih01,'N','0','N','','',g_lih.lihplant,
                 '',g_user,g_today,'','Y',g_grup,g_today, g_user, g_grup,'3',
                 '','',0,0,l_lua37,g_user,g_grup)                 #FUN-BB0117 add
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('insert lua_file:',SQLCA.SQLCODE,0)
            LET g_success = 'N'
            RETURN
         END IF
         LET g_lih.lih12 = l_lua01
      END IF
      
    #  LET l_msg = "artt610  ' '  '",l_lua01,"'"," ' '"
    #  CALL cl_cmdrun_wait(l_msg)
   END IF
   #IF g_lih.lih14 <= g_today THEN        #TQC-C20525 mark
   IF g_lih.lih14 <= g_today AND g_today <= g_lih.lih15 THEN   #TQC-C20525 add
      UPDATE lmf_file SET lmf05 = '3' 
       WHERE lmf01 = g_lih.lih07
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('update lmf_file:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
         RETURN
      END IF 
   END IF      
END FUNCTION
FUNCTION t320_stop()
   DEFINE l_lihpos      LIKE lih_file.lihpos        #FUN-C50036 add

   IF cl_null(g_lih.lih01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   SELECT * INTO g_lih.* FROM lih_file
    WHERE lih01 = g_lih.lih01

   IF g_lih.lihacti ='N' THEN
      CALL cl_err(g_lih.lih01,'alm-004',1)
      RETURN
   END IF
   IF g_lih.lihconf <> 'Y' THEN
      CALL cl_err(g_lih.lihconf,'alm1040',1)
      RETURN
   END IF

   IF g_lih.lihplant <> g_plant THEN
      CALL cl_err('','alm1023',0)  #門店編號與當前營運中心不一致，不允許異動！
      RETURN
   END IF

   IF NOT cl_confirm("alm1047") THEN
       RETURN
   END IF
   
   BEGIN WORK 
   LET g_success = 'Y'

   OPEN t320_cl USING g_lih.lih01
   IF STATUS THEN 
      CALL cl_err("open t320_cl:",STATUS,1)
      CLOSE t320_cl
      ROLLBACK WORK
      RETURN
   END IF 
   FETCH t320_cl INTO g_lih.*
   IF SQLCA.sqlcode  THEN 
     CALL cl_err(g_lih.lih01,SQLCA.sqlcode,0)
     CLOSE t320_cl
     ROLLBACK WORK
     RETURN
   END IF

   #FUN-C50036--start add--------------------
   IF g_lih.lihpos = '3' THEN
      LET l_lihpos = '2'
   ELSE
      LET l_lihpos = g_lih.lihpos
   END IF
   #FUN-C50036--end add----------------------
   UPDATE lih_file SET lihconf = 'S',
                       lih24   = '1',
                       lih18 = g_today,
                       lih19 = g_user,
                       lihpos = l_lihpos,         #FUN-C50036 add 
                       lihmodu = g_user,
                       lihdate = g_today
    WHERE lih01 = g_lih.lih01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err('upd lih:',SQLCA.SQLCODE,0)
      LET g_success = 'N'
   END IF
   IF g_today >= g_lih.lih14 AND g_today <= g_lih.lih15 THEN 
      UPDATE lmf_file SET lmf05 = '1' 
       WHERE lmf01 = g_lih.lih07
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('update lmf_file:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF    
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT * INTO g_lih.* FROM lih_file WHERE lih01 = g_lih.lih01
   DISPLAY BY NAME g_lih.*
   CALL t320_lih19()
   CALL t320_pic()
   CLOSE t320_cl
   COMMIT WORK
END FUNCTION
FUNCTION t320_pic()
DEFINE l_void LIKE type_file.chr1
   CASE g_lih.lihconf
      WHEN 'Y'  LET g_confirm = 'Y'
      WHEN 'N'  LET g_confirm = 'N'
      OTHERWISE LET g_confirm = ''
   END CASE 
       
   CALL cl_set_field_pic(g_confirm,"","","","",g_lih.lihacti)
END FUNCTION
FUNCTION t320_set_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lih01",TRUE)
   END IF
END FUNCTION

FUNCTION t320_set_no_entry(p_cmd)
DEFINE p_cmd  LIKE type_file.chr1

   IF p_cmd = 'u' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lih01",FALSE)
   END IF
   CALL cl_set_comp_entry("lihpos",FALSE)    #FUN-C50036 add
END FUNCTION
#FUN-B90056 


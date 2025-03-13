# Prog. Version..: '5.30.06-13.04.09(00009)'     #
#
# Pattern name...: almt321.4gl
# Descriptions...: 攤位意向協議維護作業
# Date & Author..: No:FUN-B90056 11/09/14 By fanbj  
# Modify.........: No:FUN-B90121 12/01/13 By shiwuying 开窗修改
# Modify.........: No:TQC-C20124 12/02/14 By fanbj 商戶查詢開窗修改
# Modify.........: No:TQC-C20525 12/02/29 By fanbj 產生費用單時直接收款欄位賦值'N'
# Modify.........: No:TQC-C30027 12/03/02 By fanbj 部份欄位給值錯誤
# Modify.........: No:TQC-C30239 12/03/20 By fanbj 不適用商戶預登記時，錄入時來源類型1.預登記，2.潛在商戶隱藏
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-D20039 13/01/19 By huangtao 將原本的「作廢」功能鍵拆為二個「作廢」/「取消作廢」
# Modify.........: No.CHI-D20015 13/03/26 By qiull 統一確認和取消確認時確認人員和確認日期的寫法

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE  g_lig       RECORD    LIKE lig_file.*,
        g_lig_t     RECORD    LIKE lig_file.*,
        g_lig_o     RECORD    LIKE lig_file.*,
        g_lig01_t             LIKE lig_file.lig01,
        g_lig01               LIKE lig_file.lig01

DEFINE  g_wc                  STRING
DEFINE  g_sql                 STRING
DEFINE  g_forupd_sql          STRING
DEFINE  g_before_input_done   LIKE type_file.num5
DEFINE  g_chr                 LIKE type_file.chr1
DEFINE  g_cnt                 LIKE type_file.num10
DEFINE  g_i                   LIKE type_file.num5
DEFINE  g_msg                 LIKE type_file.chr1000
DEFINE  g_curs_index          LIKE type_file.num10
DEFINE  g_row_count           LIKE type_file.num10
DEFINE  g_jump                LIKE type_file.num10
DEFINE  g_no_ask              LIKE type_file.num5
DEFINE  g_void                LIKE type_file.chr1
DEFINE  g_confirm             LIKE type_file.chr1
DEFINE  g_date                LIKE lig_file.ligdate
DEFINE  g_modu                LIKE lig_file.ligmodu
DEFINE  g_kindslip            LIKE oay_file.oayslip
DEFINE  g_lua01               LIKE lua_file.lua01
DEFINE  g_dd                  LIKE lua_file.lua09

MAIN           
   DEFINE cb ui.ComboBox    #TQC-C30239 add

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

   LET g_forupd_sql = "SELECT * FROM lig_file WHERE lig01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t321_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR

   OPEN WINDOW t321_w WITH FORM "alm/42f/almt321"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   #TQC-C30239--start add-----------------------
   IF g_aza.aza113 = 'N' THEN
      LET cb = ui.ComboBox.forname("lig05") 
      CALL cb.removeitem("1")
      CALL cb.removeitem("2") 
   END IF 
   #TQC-C30239--end add-------------------------

   LET g_action_choice = ""
   CALL t321_menu()

   CLOSE WINDOW t321_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t321_curs()
   CLEAR FORM

   CONSTRUCT BY NAME g_wc ON
      lig01,ligplant,liglegal,lig02,lig03,lig04,lig05,lig06,lig07,lig08,
      lig09,lig10,lig11,lig12,lig13,ligconf,ligconu,ligcond,lig14,liguser,
      liggrup,ligoriu,ligmodu,ligdate,ligorig,ligacti,ligcrat

      BEFORE CONSTRUCT
         CALL cl_qbe_init()


      ON ACTION controlp
         CASE
            WHEN INFIELD(lig01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig01"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig01
               NEXT FIELD lig01

            WHEN INFIELD(ligplant)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ligplant"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ligplant
               NEXT FIELD ligplant

            WHEN INFIELD(liglegal)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_liglegal"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO liglegal
               NEXT FIELD liglegal

            WHEN INFIELD(lig02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_lig02"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO lig02
                NEXT FIELD lig02

            WHEN INFIELD(lig03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig03"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig03
               NEXT FIELD lig03

            WHEN INFIELD(lig04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig04"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig04
               NEXT FIELD lig04

            WHEN INFIELD(lig06)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig06"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig06
               NEXT FIELD lig06

           WHEN INFIELD(lig07)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig07"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig07
               NEXT FIELD lig07

            WHEN INFIELD(lig09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig09"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig09
               NEXT FIELD lig09
      
            WHEN INFIELD(lig11)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig11" #FUN-B90121
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig11
      
            WHEN INFIELD(lig13)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig13"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO lig13

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

   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('liguser', 'liggrup')   

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF

   LET g_sql = "SELECT lig01 FROM lig_file ",
               " WHERE ",g_wc CLIPPED,
               " ORDER BY lig01"


   PREPARE t321_prepare FROM g_sql
   DECLARE t321_cs SCROLL CURSOR WITH HOLD FOR t321_prepare

   LET g_sql = "SELECT COUNT(*) FROM lig_file WHERE ",g_wc CLIPPED

   PREPARE t321_precount FROM g_sql
   DECLARE t321_count CURSOR FOR t321_precount
END FUNCTION

FUNCTION t321_menu()
   DEFINE   l_oayconf      LIKE oay_file.oayconf,
            l_msg          LIKE type_file.chr1000

   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting(g_curs_index,g_row_count)

      ON ACTION insert
         LET g_action_choice="insert"
         IF cl_chk_act_auth() THEN
            CALL t321_a()
             ##自動審核
            LET g_kindslip=s_get_doc_no(g_lig.lig01)
                IF NOT cl_null(g_kindslip) THEN
                   SELECT oayconf INTO l_oayconf FROM oay_file
                   WHERE oayslip = g_kindslip
                   IF l_oayconf = 'Y' THEN
                      CALL t321_confirm()
                   END IF
                END IF
             END IF

      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL t321_q()
         END IF

      ON ACTION next
         CALL t321_fetch('N')

      ON ACTION previous
         CALL t321_fetch('P')

      ON ACTION jump
         CALL t321_fetch('/')

      ON ACTION first
         CALL t321_fetch('F')

      ON ACTION last
         CALL t321_fetch('L')

      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL t321_u('w')
         END IF

      ON ACTION delete
         LET g_action_choice="delete"
         IF cl_chk_act_auth() THEN
            CALL t321_r()
         END IF

      #费用单查询
      ON ACTION check_expense
            LET g_action_choice="check_expense"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_lig.lig11) THEN
                  LET l_msg = "artt610  '1' '",g_lig.lig11,"'"
                  CALL cl_cmdrun_wait(l_msg)
               END IF
            ELSE
               CALL cl_err('',-4001,1)
            END IF

      ON ACTION confirm
         LET g_action_choice="confirm"
         IF cl_chk_act_auth() THEN
            CALL t321_confirm()
         END IF
         CALL t321_pic()

      ON ACTION unconfirm
         LET g_action_choice="unconfirm"
         IF cl_chk_act_auth() THEN
            CALL t321_unconfirm()
         END IF
         CALL t321_pic()

      ON ACTION void
         LET g_action_choice = "void"
         IF cl_chk_act_auth() THEN
            CALL t321_v(1)
         END IF
         CALL t321_pic()
      #FUN-D20039 -----------sta
      ON ACTION undo_void
         IF cl_chk_act_auth() THEN
            CALL t321_v(2)
         END IF
         CALL t321_pic()
      #FUN-D20039 -----------end

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU

      ON ACTION controlg
         CALL cl_cmdask()

      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CALL t321_pic()

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
            IF NOT cl_null(g_lig.lig01) THEN
               LET g_doc.column1 = "lig01"
               LET g_doc.value1 = g_lig.lig01
               CALL cl_doc()
            END IF
         END IF

   END MENU
   CLOSE t321_cs
END FUNCTION

FUNCTION t321_q()
   LET g_curs_index=0
   LET g_row_count=0
   CALL cl_navigator_setting(g_curs_index,g_row_count)

   INITIALIZE g_lig.* TO NULL
   CALL cl_opmsg('q')
   DISPLAY '     ' TO FORMONLY.cnt

   CALL t321_curs()

   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLEAR FORM
      RETURN
   END IF

   OPEN t321_count
   FETCH t321_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt

   OPEN t321_cs

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
      INITIALIZE g_lig.* TO NULL
   ELSE
      CALL t321_fetch('F')
   END IF
END FUNCTION

FUNCTION t321_fetch(p_flhab)
   DEFINE p_flhab LIKE type_file.chr1

   CASE p_flhab
      WHEN 'N' FETCH NEXT t321_cs INTO g_lig.lig01
      WHEN 'P' FETCH PREVIOUS t321_cs INTO g_lig.lig01
      WHEN 'F' FETCH FIRST t321_cs INTO g_lig.lig01
      WHEN 'L' FETCH LAST t321_cs INTO g_lig.lig01
      WHEN '/'
         IF (NOT g_no_ask)THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG=0
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
               LET INT_FLAG=0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t321_cs INTO g_lig.lig01
         LET g_no_ask=false
   END CASE

   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
      INITIALIZE g_lig.* TO NULL
      RETURN
   ELSE
      CASE p_flhab
         WHEN 'F' LET g_curs_index=1
         WHEN 'P' LET g_curs_index=g_curs_index-1
         WHEN 'N' LET g_curs_index=g_curs_index+1
         WHEN 'L' LET g_curs_index=g_row_count
         WHEN '/' LET g_curs_index=g_jump
      END CASE

      CALL cl_navigator_setting(g_curs_index,g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
   END IF

   SELECT * INTO g_lig.*
     FROM lig_file
    WHERE lig01=g_lig.lig01

   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","lig_file",g_lig.lig01,"",SQLCA.sqlcode,"","",0)
   ELSE
      LET g_data_owner=g_lig.liguser
      LET g_data_group=g_lig.liggrup
      CALL t321_show()
   END IF
END FUNCTION
       
FUNCTION t321_show()
    LET g_lig_t.* = g_lig.*
    LET g_lig_o.* = g_lig.*
    DISPLAY BY NAME g_lig.lig01,g_lig.ligplant,g_lig.liglegal,g_lig.lig02,g_lig.lig03,
                    g_lig.lig04,g_lig.lig05,g_lig.lig06,g_lig.lig07,g_lig.lig08,
                    g_lig.lig09,g_lig.lig10,g_lig.lig11,g_lig.lig12,g_lig.lig13,
                    g_lig.ligconf,g_lig.ligconu,g_lig.ligcond,g_lig.lig14,g_lig.liguser,
                    g_lig.liggrup,g_lig.ligoriu,g_lig.ligmodu,g_lig.ligdate,g_lig.ligorig,
                    g_lig.ligacti,g_lig.ligcrat

    
    CALL cl_show_fld_cont()
    CALL t321_pic()
    CALL t321_ligplant('d')
    CALL t321_liglegal('d')
    CALL t321_lig02('d')
    CALL t321_lig03('d')
    CALL t321_lig04('d')
    CALL t321_lig06('d')
    CALL t321_lig07('d')          #TQC-C20124 add
    CALL t321_lig09('d')
    CALL t321_lig13('d')
END FUNCTION

FUNCTION t321_pic()
   CASE g_lig.ligconf
      WHEN 'Y'  LET g_confirm = 'Y'
                LET g_void    = ''
      WHEN 'N'  LET g_confirm = 'N'
                LET g_void    = ''
      WHEN 'X'  LET g_confirm = ''
                LET g_void    = 'Y'
      OTHERWISE LET g_confirm = ''
                LET g_void    = ''
   END CASE

   CALL cl_set_field_pic(g_confirm,"","","",g_void,g_lig.ligacti)
END FUNCTION

FUNCTION t321_ligplant(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_rtz13    LIKE rtz_file.rtz13,
          l_rtz28    LIKE rtz_file.rtz28

   LET g_errno = ''
   SELECT rtz13 ,rtz28 INTO l_rtz13,l_rtz28
     FROM rtz_file
    WHERE rtz01 = g_lig.ligplant

   CASE 
      WHEN SQLCA.sqlcode=100 
         LET g_errno='alm-077'
         LET l_rtz13 = ''
      WHEN l_rtz28 <> 'Y'
         LET g_errno = 'alm-606'
      OTHERWISE              
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_rtz13 TO FORMONLY.rtz13
   END IF
END FUNCTION

FUNCTION t321_liglegal(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,
          l_azt02    LIKE azt_file.azt02

   LET g_errno = ''
   SELECT azt02 INTO l_azt02
     FROM azt_file
    WHERE azt01 = g_lig.liglegal

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='aoo-416'
         LET l_azt02 = ''
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION

FUNCTION t321_lig02(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_lmb03    LIKE lmb_file.lmb03,
          l_lmb06    LIKE lmb_file.lmb06

   LET g_errno = ''
   SELECT lmb03,lmb06 INTO l_lmb03,l_lmb06
     FROM lmb_file
    WHERE lmb02 = g_lig.lig02

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm-003'
         LET l_lmb03 = ''
      WHEN l_lmb06 <> 'Y'    
         LET g_errno = 'alm-905'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_lmb03 TO FORMONLY.lmb03
   END IF
END FUNCTION

FUNCTION t321_lig03(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_lmc04    LIKE lmc_file.lmc04,
          l_lmc07    LIKE lmc_file.lmc07

   LET g_errno = ''
   SELECT lmc04,lmc07 INTO l_lmc04,l_lmc07
     FROM lmc_file
    WHERE lmc03 = g_lig.lig03
      AND lmc02 = g_lig.lig02

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm-554'
         LET l_lmc04 = ''
      WHEN l_lmc07 <> 'Y'    
         LET g_errno = 'alm-908'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_lmc04 TO FORMONLY.lmc04
   END IF
END FUNCTION

FUNCTION t321_lig04(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_lmf13    LIKE lmf_file.lmf13,
          l_lmf06    LIKE lmf_file.lmf06,
          l_lmf04    LIKE lmf_file.lmf04,
          l_lmf03    LIKE lmf_file.lmf03

   LET g_errno = ''

   CASE 
      WHEN (NOT cl_null(g_lig.lig03)) AND (NOT cl_null(g_lig.lig02))
         SELECT lmf13,l_lmf06 INTO l_lmf13,l_lmf06
           FROM lmf_file
          WHERE lmf01 = g_lig.lig04
            AND lmf04 = g_lig.lig03
            AND lmf03 = g_lig.lig02
            AND lmfstore = g_lig.ligplant

      WHEN (NOT cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03))
         SELECT lmf04,lmf13,l_lmf06  INTO l_lmf04, l_lmf13,l_lmf06
           FROM lmf_file
          WHERE lmf01 = g_lig.lig04
            AND lmf03 = g_lig.lig02
            AND lmfstore = g_lig.ligplant

      WHEN (cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03))
         IF g_lig.lig04<>'MISC' THEN
            SELECT lmf03,lmf04,lmf13,l_lmf06 INTO l_lmf03,l_lmf04,l_lmf13,l_lmf06
              FROM lmf_file
             WHERE lmf01 = g_lig.lig04
               AND lmfstore = g_lig.ligplant
         END IF

      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE  

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm-913'
         LET l_lmf13 = ''
      WHEN l_lmf06 <> 'Y'
         LET g_errno = 'alm-914'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      CASE 
         WHEN (NOT cl_null(g_lig.lig03)) AND (NOT cl_null(g_lig.lig02))
            DISPLAY l_lmf13 TO FORMONLY.lmf13

         WHEN (cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03))
            LET g_lig.lig02 = l_lmf03
            LET g_lig.lig03 = l_lmf04
            DISPLAY l_lmf13 TO FORMONLY.lmf13
            DISPLAY BY NAME g_lig.lig02    

            CALL t321_lig02('d')

            DISPLAY BY NAME g_lig.lig03
            CALL t321_lig03('d')

         WHEN (NOT cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03))
            IF g_lig.lig04<>'MISC' THEN
               LET g_lig.lig03 = l_lmf04
               DISPLAY BY NAME g_lig.lig03
               CALL t321_lig03('d')
               DISPLAY l_lmf13 TO FORMONLY.lmf13
            ELSE
               DISPLAY l_lmf13 TO FORMONLY.lmf13
            END IF
         OTHERWISE
      END CASE
   END IF
END FUNCTION

FUNCTION t321_lig09(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_oaj02    LIKE oaj_file.oaj02,
          l_oajacti  LIKE oaj_file.oajacti,
          l_lmf06    LIKE lmf_file.lmf06

   LET g_errno = ''
   SELECT oaj02,oajacti INTO l_oaj02,l_oajacti
     FROM oaj_file
    WHERE oaj01 = g_lig.lig09
      AND oaj05 = '01'

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm1031'
         LET l_oaj02 = ''
      WHEN l_lmf06 <> 'Y'
         LET g_errno = 'alm1044'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_oaj02 TO FORMONLY.oaj02
   END IF
END FUNCTION


FUNCTION t321_lig13(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_gen02    LIKE gen_file.gen02

   LET g_errno ='' 

   SELECT gen02 INTO l_gen02
     FROM gen_file
    WHERE gen01 = g_lig.lig13

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno='anm-053'
         LET l_gen02 = ''
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
END FUNCTION

FUNCTION t321_a()
   DEFINE li_result     LIKE type_file.num5

   MESSAGE ""
   CLEAR FORM
   INITIALIZE g_lig.*    LIKE lig_file.*
   INITIALIZE g_lig_t.*  LIKE lig_file.*
   INITIALIZE g_lig_o.*  LIKE lig_file.*

   LET g_lig01_t = NULL
   LET g_wc = NULL
   CALL cl_opmsg('a')
  
   WHILE TRUE
      LET g_lig.ligplant = g_plant
      LET g_lig.liglegal = g_legal
      LET g_lig.lig12 = g_today
      LET g_lig.lig13 = g_user
      LET g_lig.liguser = g_user
      LET g_lig.liggrup = g_grup
      LET g_lig.ligdate = g_today
      LET g_lig.ligacti = 'Y'
      LET g_lig.ligcrat = g_today
      LET g_lig.ligoriu = g_user
      LET g_lig.ligorig = g_grup
      LET g_lig.ligconf = 'N'
      
     CALL t321_ligplant('d')
     CALL t321_liglegal('d')
     
      CALL t321_i("a","")

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         INITIALIZE g_lig.* TO NULL
         LET g_lig01_t = NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         EXIT WHILE
      END IF

      IF cl_null(g_lig.lig01) THEN
         CONTINUE WHILE
      END IF

      ####自動編號#################
      BEGIN WORK
      CALL s_auto_assign_no("alm",g_lig.lig01,g_lig.ligcrat,'O6',"lig_file","lig01","","","") 
         RETURNING li_result,g_lig.lig01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_lig.lig01 

      ##############################

      INSERT INTO lig_file VALUES(g_lig.*)

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lig.lig01,SQLCA.SQLCODE,0)
         ROLLBACK WORK         
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         SELECT * INTO g_lig.* FROM lig_file
          WHERE lig01 = g_lig.lig01
      END IF
      EXIT WHILE
   END WHILE
   LET g_wc = NULL
   MESSAGE " "
END FUNCTION

FUNCTION t321_i(p_cmd,w_cmd)
   DEFINE   p_cmd      LIKE type_file.chr1,
            w_cmd      LIKE type_file.chr1,
            l_cnt      LIKE type_file.num5
   DEFINE   li_result  LIKE type_file.num5
   DEFINE   l_lmc04    LIKE lmc_file.lmc04

   DISPLAY BY NAME g_lig.lig01,g_lig.ligplant,g_lig.liglegal,g_lig.lig02,
                   g_lig.lig03,g_lig.lig04,g_lig.lig05,g_lig.lig06,g_lig.lig07,
                   g_lig.lig08,g_lig.lig09,g_lig.lig10,g_lig.lig11,g_lig.lig12,
                   g_lig.lig13,g_lig.ligconf,g_lig.ligconu,g_lig.ligcond,g_lig.lig14,
                   g_lig.liguser,g_lig.liggrup,g_lig.ligoriu,g_lig.ligmodu,
                   g_lig.ligdate,g_lig.ligorig,g_lig.ligacti,g_lig.ligcrat                                    

   INPUT BY NAME   g_lig.lig01,g_lig.ligplant,g_lig.liglegal,g_lig.lig02,     
                   g_lig.lig03,g_lig.lig04,g_lig.lig05,g_lig.lig06,g_lig.lig07,
                   g_lig.lig08,g_lig.lig09,g_lig.lig10,g_lig.lig11,g_lig.lig12,
                   g_lig.lig13,g_lig.ligconf,g_lig.ligconu,g_lig.ligcond,g_lig.lig14,
                   g_lig.liguser,g_lig.liggrup,g_lig.ligoriu,g_lig.ligmodu,
                   g_lig.ligdate,g_lig.ligorig,g_lig.ligacti,g_lig.ligcrat
      WITHOUT DEFAULTS

      BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t321_set_entry(p_cmd)
          CALL t321_set_no_entry(p_cmd)
          CALL cl_set_docno_format("lig01")
          LET g_before_input_done = TRUE
      
      AFTER FIELD lig01 
         IF NOT cl_null(g_lig.lig01) THEN
            CALL s_check_no("alm",g_lig.lig01,g_lig01_t,'O6',"lig_file","lig01","") 
                 RETURNING li_result,g_lig.lig01 
            IF (NOT li_result) THEN
               LET g_lig.lig01 = g_lig_t.lig01
               NEXT FIELD lig01
            END IF
              DISPLAY BY NAME g_lig.lig01
          END IF

      AFTER FIELD ligplant
          IF NOT cl_null(g_lig.ligplant) THEN
             CALL t321_ligplant('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lig.ligplant = g_lig_t.ligplant
                DISPLAY BY NAME g_lig.ligplant
                NEXT FIELD ligplant
             END IF
          END IF

      AFTER FIELD liglegal
          IF NOT cl_null(g_lig.liglegal) THEN
             CALL t321_liglegal('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lig.liglegal = g_lig_t.liglegal
                DISPLAY BY NAME g_lig.liglegal
                NEXT FIELD liglegal
             END IF
          END IF

      AFTER FIELD lig02
          IF NOT cl_null(g_lig.lig02) THEN
             CALL t321_lig02_2('d')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lig.lig02 = g_lig_t.lig02
                DISPLAY BY NAME g_lig.lig02
                NEXT FIELD lig02
             ELSE
                CALL t321_lig02_03()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_lig.lig02 = g_lig_t.lig02
                   DISPLAY BY NAME g_lig.lig02
                   NEXT FIELD lig02
                END IF
             END IF      
             CALL t321_lig02('d')
          ELSE
             IF NOT cl_null(g_lig.lig03) THEN
                CALL cl_err('','alm-390',0)
                LET g_lig.lig02 = g_lig_t.lig02
                DISPLAY BY NAME g_lig.lig02
                NEXT FIELD lig02
             END IF
          END IF
        

      AFTER FIELD lig03
         IF NOT cl_null(g_lig.lig03) THEN
            CALL t321_lig03_2('d')
            IF NOT cl_null (g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lig.lig03 = g_lig_t.lig03
               DISPLAY BY NAME g_lig.lig03 
               NEXT FIELD lig03
            ELSE 
               CALL t321_lig03_04()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_lig.lig03 = g_lig_t.lig03
                  DISPLAY BY NAME g_lig.lig03
                  NEXT FIELD lig03
               END IF
            END IF
            CALL t321_lig03('d')
         END IF

      AFTER FIELD lig04
         IF NOT cl_null(g_lig.lig04) THEN
            CALL t321_lig04_2('d')
            IF NOT cl_null (g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lig.lig04 = g_lig_t.lig04
               DISPLAY BY NAME g_lig.lig04 
               NEXT FIELD lig04
            END IF
            CALL t321_lig04('d')
         END IF

      AFTER FIELD lig06
         IF NOT cl_null(g_lig.lig06) THEN
            CALL t321_lig06(p_cmd)
             IF NOT cl_null (g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lig.lig06 = g_lig_t.lig06
               DISPLAY BY NAME g_lig.lig06
               NEXT FIELD lig06
            END IF
         END IF       
     
      AFTER FIELD lig07
         IF NOT cl_null(g_lig.lig07) THEN
            CALL t321_lig07(p_cmd)
             IF NOT cl_null (g_errno) THEN
               CALL cl_err('',g_errno,0)
               LET g_lig.lig07 = g_lig_t.lig07
               DISPLAY BY NAME g_lig.lig07
               NEXT FIELD lig07
            END IF
         END IF 
      
      AFTER FIELD lig09
         IF NOT cl_null(g_lig.lig09) THEN
            CALL t321_lig09_2('d')
            IF NOT cl_null (g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_lig.lig09 = g_lig_t.lig09
                DISPLAY BY NAME g_lig.lig09
                NEXT FIELD lig09
             END IF
             CALL t321_lig09('d')
          END IF 

      AFTER FIELD lig10
         IF NOT cl_null(g_lig.lig10) THEN
            IF ( g_lig.lig10 <0 ) THEN
               CALL cl_err ('','alm1053',0)
               LET g_lig.lig10 = g_lig_t.lig10
               DISPLAY BY NAME g_lig.lig10
               NEXT FIELD lig10
            END IF
         END IF

      ON CHANGE lig05
         LET g_lig_t.lig06 = ''
         LET g_lig.lig06 = ''
         CALL t321_lig05('d')
         DISPLAY BY NAME g_lig.lig06
         
         
      ON ACTION controlp
         CASE 
            WHEN INFIELD(lig01)
               LET g_kindslip = s_get_doc_no(g_lig.lig01)
               CALL q_oay(FALSE,FALSE,g_kindslip,'O6','ALM') RETURNING g_kindslip
               LET g_lig.lig01 = g_kindslip
               DISPLAY BY NAME g_lig.lig01
               NEXT FIELD lig01

            WHEN INFIELD(lig02)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmy1"
               LET g_qryparam.default1 = g_lig.lig02
               LET g_qryparam.default2 = g_lig.lig03
               LET g_qryparam.default3 = l_lmc04
               LET g_qryparam.where = " lmcstore = '",g_lig.ligplant,"'"
               CALL cl_create_qry()
                   RETURNING g_lig.lig02,g_lig.lig03,l_lmc04
               DISPLAY BY NAME g_lig.lig02,g_lig.lig03
               DISPLAY l_lmc04 TO FORMONLY.lmc04
               NEXT FIELD lig02
             
            WHEN INFIELD(lig03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lmy1"
               LET g_qryparam.default1 = g_lig.lig02
               LET g_qryparam.default2 = g_lig.lig03
               LET g_qryparam.default3 = l_lmc04
               LET g_qryparam.where = " lmcstore = '",g_lig.ligplant,"'", " AND ",
                                      "lmc02 = '",g_lig.lig02,"'"
               CALL cl_create_qry()
                  RETURNING g_lig.lig02,g_lig.lig03,l_lmc04
               DISPLAY BY NAME g_lig.lig02,g_lig.lig03
               DISPLAY l_lmc04 TO FORMONLY.lmc04
               NEXT FIELD lig03

            WHEN INFIELD(lig04)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig04_2"
               LET g_qryparam.default1 = g_lig.lig04
               
               IF (NOT cl_null(g_lig.lig02)) AND (NOT cl_null(g_lig.lig03)) THEN
                   LET g_qryparam.where = " lmfstore = '",g_lig.ligplant,"'", " AND ",
                                          " lmf03 = '",g_lig.lig02,"'", " AND ",
                                          " lmf04 = '",g_lig.lig03,"'"
               END IF
         
               IF ( NOT cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03)) THEN
                  LET g_qryparam.where = " lmfstore = '",g_lig.ligplant,"'", " AND ",
                                          " lmf03 = '",g_lig.lig02,"'"
               END IF

               IF (cl_null(g_lig.lig02)) AND  (cl_null( g_lig.lig03)) THEN
                  LET g_qryparam.where = " lmfstore = '",g_lig.ligplant,"'"
               END IF         
               CALL cl_create_qry()
                  RETURNING g_lig.lig04
               DISPLAY BY NAME g_lig.lig04
               NEXT FIELD lig04

            WHEN INFIELD(lig06)
               CALL cl_init_qry_var()
               IF (g_lig.lig05 = '1') THEN
                  LET g_qryparam.form = "q_lig06_2"
               END IF
               
               IF (g_lig.lig05 = '2') THEN
                  LET g_qryparam.form = "q_lig06_3"
               END IF

               LET g_qryparam.default1 = g_lig.lig06
               CALL cl_create_qry()
                  RETURNING g_lig.lig06
               DISPLAY BY NAME g_lig.lig06
               NEXT FIELD lig06

            WHEN INFIELD(lig07)
               CALL cl_init_qry_var()
               IF (g_lig.lig05 = '3') THEN
                  LET g_qryparam.form = "q_lig07_1"
               END IF
               LET g_qryparam.default1 = g_lig.lig07
               CALL cl_create_qry()
                  RETURNING g_lig.lig07
               DISPLAY BY NAME g_lig.lig07
               NEXT FIELD lig07

            WHEN INFIELD(lig09)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_lig09_2"
               LET g_qryparam.default1 = g_lig.lig09
               CALL cl_create_qry()
                  RETURNING g_lig.lig09
               DISPLAY BY NAME g_lig.lig09
               NEXT FIELD lig09
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

FUNCTION t321_lig02_2(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_lmb02       LIKE   lmb_file.lmb02
   DEFINE l_lmb06       LIKE   lmb_file.lmb06

   LET g_errno=''
   SELECT lmb02 ,lmb06 INTO l_lmb02,l_lmb06
     FROM lmb_file
    WHERE lmbstore = g_lig.ligplant
      AND lmb02 = g_lig.lig02
      
   CASE 
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm-003'
         LET l_lmb02 = ''
      WHEN l_lmb06 <> 'Y'
         LET g_errno = 'alm-905'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_lmb02 TO lig02
   END IF 
END FUNCTION

FUNCTION t321_lig02_03()
   DEFINE l_count       LIKE   type_file.num5

   LET g_errno=''
     
   IF (NOT cl_null(g_lig.lig03)) AND (NOT cl_null(g_lig.lig04)) THEN 
      SELECT count(*) INTO l_count FROM lmc_file
       WHERE lmcstore = g_lig.ligplant
         AND lmc02 = g_lig.lig02
         AND lmc03 = g_lig.lig03
       IF l_count =0 THEN 
          LET g_errno = 'alm-907' 
       ELSE
          IF g_lig.lig04 <> 'MISC' THEN
             SELECT count(*) INTO l_count FROM lmf_file
              WHERE lmfstore = g_lig.ligplant
                AND lmf03 = g_lig.lig02
                AND lmf04 = g_lig.lig03
                AND lmf01 = g_lig.lig04
             IF l_count = 0 THEN
                LET g_errno ='alm1060'
             END IF
          END IF
       END IF
   END IF 
END FUNCTION

FUNCTION t321_lig03_2(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_lmc03    LIKE   lmc_file.lmc03
   DEFINE l_lmc07    LIKE   lmc_file.lmc07

   LET g_errno=''

   IF cl_null(g_lig.lig02) THEN
      CALL cl_err('','alm-390',0)
      LET g_lig.lig03 = g_lig_t.lig03
      DISPLAY BY NAME g_lig.lig03
      RETURN
   END IF
   
   SELECT lmc03 ,lmc07 INTO l_lmc03,l_lmc07
     FROM lmc_file
    WHERE lmcstore = g_lig.ligplant
      AND lmc02 = g_lig.lig02
      AND lmc03 = g_lig.lig03
      
   CASE 
      WHEN SQLCA.sqlcode=100
         LET g_errno='alm-604'
         LET l_lmc03 = ''
      WHEN l_lmc07 <> 'Y'
         LET g_errno = 'alm-905'
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_lmc03 TO lig03
   END IF 
END FUNCTION

FUNCTION t321_lig03_04()
   DEFINE    l_count    LIKE type_file.num5

   LET g_errno = ''
   IF NOT cl_null (g_lig.lig04) THEN
      IF g_lig.lig04 <> 'MISC' THEN
         SELECT COUNT(*) INTO l_count FROM lmf_file
          WHERE lmf01 = g_lig.lig04
            AND lmfstore = g_lig.ligplant
            AND lmf03 = g_lig.lig02
            AND lmf04 = g_lig.lig03
         IF l_count = 0 THEN
            LET g_errno = 'alm1060'
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t321_lig04_2(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1
   DEFINE l_lmf01    LIKE   lmf_file.lmf01
   DEFINE l_lmf06    LIKE   lmf_file.lmf06,
          l_count    LIKE  type_file.num5

   LET g_errno=''
 
  IF g_lig.lig04 = 'MISC' THEN
     LET l_lmf01 = 'MISC'
  ELSE
      CASE
         WHEN (NOT cl_null(g_lig.lig02)) AND (NOT cl_null(g_lig.lig03)) 
            SELECT lmf01,lmf06 INTO l_lmf01,l_lmf06
              FROM lmf_file
             WHERE lmf01 = g_lig.lig04
               AND lmf03 = g_lig.lig02
               AND lmf04 = g_lig.lig03
               AND lmfstore = g_lig.ligplant
            CASE 
               WHEN SQLCA.sqlcode=100
                  LET g_errno='alm-502'
               WHEN l_lmf06 <> 'Y'
                  LET g_errno = 'alm-914'
               OTHERWISE
                  LET g_errno=SQLCA.SQLCODE USING '-------' 
            END CASE     
         WHEN (NOT cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03))
            SELECT lmf01,lmf06 INTO l_lmf01,l_lmf06
              FROM lmf_file
             WHERE lmf01 = g_lig.lig04
               AND lmf03 = g_lig.lig02
               AND lmfstore = g_lig.ligplant
            CASE
               WHEN SQLCA.sqlcode=100
                  LET g_errno='alm-621'
               WHEN l_lmf06 <> 'Y'
                  LET g_errno = 'alm-914'
               OTHERWISE
                  LET g_errno=SQLCA.SQLCODE USING '-------'
            END CASE
         WHEN (cl_null(g_lig.lig02)) AND (cl_null(g_lig.lig03))
               SELECT lmf01,lmf06 INTO l_lmf01,l_lmf06
                 FROM lmf_file
                WHERE lmf01 = g_lig.lig04
                  AND lmfstore = g_lig.ligplant
               CASE
                  WHEN SQLCA.sqlcode=100
                     LET g_errno='alm-557'
                  WHEN l_lmf06 <> 'Y'
                     LET g_errno = 'alm-914'
                  OTHERWISE
                     LET g_errno=SQLCA.SQLCODE USING '-------'
               END CASE
         #WHEN (cl_null(g_lig.lig02)) AND (NOT cl_null(g_lig.lig03))
         #   LET g_errno = 'alm-390'
         OTHERWISE
      END CASE
   END IF

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_lmf01 TO lig04
   END IF 
END FUNCTION

FUNCTION t321_lig05(p_cmd)
   DEFINE  p_cmd           LIKE   type_file.chr1,
           l_lig07_desc    LIKE   lne_file.lne06

   CASE 
      WHEN g_lig.lig05 = '2' OR g_lig.lig05 = '1'
         LET g_lig.lig07 = ''
         LET l_lig07_desc =''
         CALL cl_set_comp_entry("lig06",TRUE)
         CALL cl_set_comp_entry("lig07",FALSE)
         DISPLAY BY NAME g_lig.lig07
         DISPLAY l_lig07_desc TO FORMONLY.lig07_desc
      WHEN g_lig.lig05 ='3'
         LET g_lig.lig06 = ''
         CALL cl_set_comp_entry("lig06",FALSE)
         CALL cl_set_comp_entry("lig07",TRUE)
         DISPLAY BY NAME g_lig.lig06
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY BY NAME g_lig.lig05
   END IF
END FUNCTION

FUNCTION t321_lig06(p_cmd)
   DEFINE   l_lna01     LIKE  lna_file.lna01,
            l_lnb01     LIKE  lnb_file.lnb01,
            l_lna26     LIKE  lna_file.lna26,
            l_lnb33     LIKE  lnb_file.lnb33,
            p_cmd       LIKE  type_file.chr1,
            l_lnb04     LIKE  lnb_file.lnb04,
            l_lna03     LIKE  lna_file.lna03,
            l_lna04     LIKE  lna_file.lna04,
            l_lnb05     LIKE  lnb_file.lnb05,
            l_count     LIKE  type_file.num5

   LET g_errno = ''

   IF (g_lig.lig05 ='1') THEN
       SELECT lna01,lna03,lna04,lna26 INTO l_lna01,l_lna03,l_lna04,l_lna26
         FROM lna_file
        WHERE lna01 = g_lig.lig06

       CASE 
          WHEN  SQLCA.sqlcode=100
             LET g_errno ='alm1050'
           WHEN l_lna26 <> 'Y'
              LET g_errno = 'alm1051'
              LET l_lna04 = ''
              LET l_lna03 = ''
           OTHERWISE
              LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE 
   END IF
   IF (g_lig.lig05 = '2') THEN
      SELECT lnb01,lnb04,lnb05,lnb33 INTO l_lnb01,l_lnb04,l_lnb05,l_lnb33
        FROM lnb_file
       WHERE lnb01 = g_lig.lig06
      
      CASE 
         WHEN SQLCA.sqlcode=100
            LET g_errno = 'alm-162'
         WHEN l_lnb33 <> 'Y'
            LET g_errno ='alm1052'
            LET l_lnb05 = ''
            LET l_lnb04 = ''
        OTHERWISE
           LET g_errno=SQLCA.SQLCODE USING '-------'
      END CASE
   END IF  
  
   SELECT count(*) INTO l_count
     FROM lig_file
    WHERE lig06 = g_lig.lig06
   IF p_cmd = 'a' THEN 
      IF l_count > 0 THEN 
         LET g_errno = 'alm1255'
      END IF  
   ELSE 
      IF l_count >1 THEN 
         LET g_errno = 'alm1255'
      END IF       
   END IF  

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      IF (g_lig.lig05 = '1') THEN
         LET g_lig.lig07 = l_lna03
         DISPLAY BY NAME g_lig.lig07
         DISPLAY l_lna04 TO FORMONLY.lig07_desc
      END IF
      
      IF (g_lig.lig05 = '2') THEN
         LET g_lig.lig07 = l_lnb04
         DISPLAY BY NAME g_lig.lig07
         DISPLAY l_lnb05 TO FORMONLY.lig07_desc
      END IF
         
      DISPLAY BY NAME g_lig.lig06
   END IF   
      
END FUNCTION

FUNCTION t321_lig07(p_cmd)
   DEFINE l_lne05             LIKE lne_file.lne05,
          p_cmd               LIKE type_file.chr1,
          l_lne36             LIKE lne_file.lne36

   LET g_errno = ''

   SELECT lne05,lne36 INTO l_lne05,l_lne36
     FROM lne_file
    WHERE lne01 = g_lig.lig07 

   CASE
      WHEN  SQLCA.sqlcode=100
         LET g_errno ='alm-a01'
         LET l_lne05 = ''
         WHEN l_lne36 <> 'Y'
         LET g_errno = 'alm1042'
         LET l_lne05 = ''
      OTHERWISE
         LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      DISPLAY l_lne05 TO FORMONLY.lig07_desc
   END IF 
END FUNCTION

FUNCTION t321_lig09_2(p_cmd)
   DEFINE   p_cmd      LIKE   type_file.chr1,
            l_oaj01    LIKE   oaj_file.oaj01,
            l_oajacti  LIKE   oaj_file.oajacti,
            l_oaj05    LIKE   oaj_file.oaj05

   LET g_errno = ''

   SELECT oaj01,oaj05,oajacti INTO l_oaj01,l_oaj05,l_oajacti
     FROM oaj_file
    WHERE oaj01 = g_lig.lig09
      

   CASE
      WHEN SQLCA.sqlcode=100
         LET g_errno = 'alm1031'
      WHEN l_oajacti <> 'Y'
         LET g_errno ='alm1032'
      WHEN l_oaj05<>'01'
         LET g_errno = 'alm1058'
       OTHERWISE
          LET g_errno=SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd= 'd'  THEN
      LET g_lig.lig09 = l_oaj01
      DISPLAY BY NAME g_lig.lig06
   END IF
   
END FUNCTION

FUNCTION t321_u(p_w)
   DEFINE   p_w   LIKE type_file.chr1
 
   IF cl_null(g_lig.lig01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF    
   
   SELECT * INTO g_lig.* FROM lig_file 
     WHERE lig01  = g_lig.lig01
  
   IF g_lig.ligconf = 'Y' THEN
      CALL cl_err(g_lig.lig01,'alm-027',1)
     RETURN
   END IF    
 
   IF g_lig.ligconf = 'X' THEN
      CALL cl_err(g_lig.lig01,'alm-134',1)
     RETURN
   END IF    

   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_lig01_t = g_lig.lig01
   BEGIN WORK
 
   OPEN t321_cl USING g_lig.lig01
   IF STATUS THEN
      CALL cl_err("OPEN t321_cl:",STATUS,1)
      CLOSE t321_cl
      ROLLBACK WORK
      RETURN
   END IF

   FETCH t321_cl INTO g_lig.*  
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_lig.lig01,SQLCA.sqlcode,1)
      CLOSE t321_cl
      ROLLBACK WORK
      RETURN
   END IF
    
   ###############
   LET g_date = g_lig.ligdate
   LET g_modu = g_lig.ligmodu
   ############### 
   IF p_w != 'c' THEN 
      LET g_lig.ligmodu = g_user  
      LET g_lig.ligdate = g_today 
   ELSE
      LET g_lig.ligmodu = NULL  
   END IF   
   CALL t321_show()                 
   WHILE TRUE
      IF p_w != 'c' THEN
        CALL t321_i("u","")     
      ELSE
        CALL t321_i("u","h") 
      END IF
   
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         ###############
         LET g_lig_t.ligdate = g_date
         LET g_lig_t.ligmodu = g_modu
         ###############
         LET g_lig.*=g_lig_t.*
         CALL t321_show()
         CALL cl_err('',9001,0)        
         EXIT WHILE
      END IF
 
      UPDATE lig_file SET lig_file.* = g_lig.* 
        WHERE lig01 = g_lig_t.lig01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t321_cl
   COMMIT WORK
   
   SELECT * INTO g_lig.*
     FROM lig_file
    WHERE lig01 = g_lig.lig01

   CALL t321_show()
END FUNCTION
 
FUNCTION t321_r()
    IF cl_null(g_lig.lig01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_lig.ligconf = 'Y' THEN 
       CALL cl_err(g_lig.lig01,'alm-028',1)
       RETURN
     END IF
       
    IF g_lig.ligconf = 'X' THEN 
       CALL cl_err(g_lig.lig01,'alm-134',1)
       RETURN
     END IF

    BEGIN WORK
 
    OPEN t321_cl USING g_lig.lig01
    IF STATUS THEN
       CALL cl_err("OPEN t321_cl:",STATUS,0)
       CLOSE t321_cl
       ROLLBACK WORK
       RETURN
    END IF

    FETCH t321_cl INTO g_lig.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
       CLOSE t321_cl
       ROLLBACK WORK
       RETURN
    END IF

    CALL t321_show()
    IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          
       LET g_doc.column1 = "lig01"        
       LET g_doc.value1 = g_lig.lig01    
       CALL cl_del_doc()      
          
       DELETE FROM lig_file 
        WHERE lig01 = g_lig.lig01

       CLEAR FORM
       OPEN t321_count
       IF STATUS THEN
          CLOSE t321_cs
          CLOSE t321_count
          COMMIT WORK
          RETURN
       END IF

       FETCH t321_count INTO g_row_count
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t321_cs
          CLOSE t321_count
          COMMIT WORK
          RETURN
       END IF

       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t321_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t321_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t321_fetch('/')
       END IF
    END IF
    CLOSE t321_cl
    COMMIT WORK
END FUNCTION

FUNCTION t321_set_entry(p_cmd)
   DEFINE   p_cmd    LIKE type_file.chr1 
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("lig01",TRUE)
   END IF
 
END FUNCTION

FUNCTION t321_set_no_entry(p_cmd)          
   DEFINE   p_cmd     LIKE type_file.chr1   
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN   
      CALL cl_set_comp_entry("lig01",FALSE)        
   END IF           
END FUNCTION 

FUNCTION t321_confirm()
   DEFINE l_ligconu         LIKE lig_file.ligconu 
   DEFINE l_ligcond         LIKE lig_file.ligcond

   IF cl_null(g_lig.lig01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   IF g_lig.ligconf = 'Y' THEN
      CALL cl_err(g_lig.lig01,'alm-005',1)
      RETURN
   END IF
   
   IF g_lig.ligconf = 'X' THEN
      CALL cl_err(g_lig.lig01,'alm-134',1)
      RETURN
   END IF

   IF g_lig.ligacti ='N' THEN
      CALL cl_err(g_lig.lig01,'alm-004',1)
      RETURN
   END IF

   IF g_lig.ligplant <> g_plant THEN
      CALL cl_err('','alm1023',0) 
      RETURN
   END IF
  
   LET g_success = 'Y'     
  
   SELECT * INTO g_lig.* FROM lig_file
    WHERE lig01 = g_lig.lig01
   
   LET l_ligconu = g_lig.ligconu
   LET l_ligcond = g_lig.ligcond 
   
   BEGIN WORK 
   OPEN t321_cl USING g_lig.lig01
   IF STATUS THEN 
      CALL cl_err("open t321_cl:",STATUS,1)
      CLOSE t321_cl
      ROLLBACK WORK 
      RETURN 
   END IF 
   
   FETCH t321_cl INTO g_lig.*
   IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
      CLOSE t321_cl
      ROLLBACK WORK
      RETURN 
   END IF    
  
   IF NOT cl_confirm("alm-006") THEN
       RETURN
   ELSE
      LET g_lig.ligconf = 'Y'
      LET g_lig.ligconu = g_user
      LET g_lig.ligcond = g_today

      CALL t321_chk()
      
      IF g_success = 'Y' THEN 
         UPDATE lig_file
            SET 
               lig11 = g_lig.lig11,
               ligconf = g_lig.ligconf,
               ligconu = g_lig.ligconu,
               ligcond = g_lig.ligcond,
               ligdate = g_today
          WHERE lig01= g_lig.lig01
       
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('upd lig:',SQLCA.SQLCODE,0)
            LET g_success = 'N'
            LET g_lig.ligconf = "N"
            LET g_lig.ligconu = l_ligconu
            LET g_lig.ligcond = l_ligcond
            LET g_lig.lig11 = ''
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      IF g_success = 'Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END IF 
   SELECT * INTO g_lig.* FROM lig_file WHERE lig01 = g_lig.lig01
   DISPLAY BY NAME g_lig.*
   CLOSE t321_cl
   COMMIT WORK      
   MESSAGE "       "
END FUNCTION

FUNCTION t321_chk()
   DEFINE li_result    LIKE type_file.num5
   DEFINE l_lua01  LIKE lua_file.lua01,
          l_lua05           LIKE lua_file.lua05,
          l_lua06           LIKE lua_file.lua06,
          l_lua061          LIKE lua_file.lua061,
          l_lua37           LIKE lua_file.lua37,
          l_occ02           LIKE occ_file.occ02,
          l_occ41           LIKE occ_file.occ41,
          l_gec04           LIKE gec_file.gec04,
          l_gec07           LIKE gec_file.gec07,
          l_lub04           LIKE lub_file.lub04,
          l_lub04t          LIKE lub_file.lub04t,
          l_lub10           LIKE lub_file.lub10,
          l_lua08           LIKE lua_file.lua08, 
          l_lua08t          LIKE lua_file.lua08t,
          l_oaj05           LIKE oaj_file.oaj05,
          l_n               LIKE type_file.num5,
          l_azi04           LIKE azi_file.azi04

   LET l_n = 0
   
   SELECT count(*) INTO l_n
     FROM lua_file
    #WHERE lua12 = g_lig.lig11     #TQC-C30027 mark
    WHERE lua12 = g_lig.lig01      #TQC-C30027 add

   SELECT azi04 INTO l_azi04
     FROM azi_file
    WHERE azi01 = g_aza.aza17

   IF l_n=0 THEN
      #FUN-C90050 mark begin---
      #SELECT rye03 INTO g_lua01 FROM rye_file
      # WHERE rye01 = 'art' AND rye02 = 'B9'
      #FUN-C90050 mark end-----

      CALL s_get_defslip('art','B9',g_plant,'N') RETURNING g_lua01     #FUN-C90050 add  

      LET g_dd = g_today


      OPEN WINDOW t321_1_w WITH FORM "alm/42f/almt321_1"
         ATTRIBUTE(STYLE=g_win_style CLIPPED)

      CALL cl_ui_locale("almt321_1")

      DISPLAY g_lua01 TO FORMONLY.g_lua01
      DISPLAY g_dd TO FORMONLY.g_dd

      INPUT  BY NAME g_lua01,g_dd   WITHOUT DEFAULTS
         BEFORE INPUT

         AFTER FIELD g_lua01
            LET l_n = 0
            SELECT COUNT(*) INTO  l_n FROM oay_file
             WHERE oaysys ='art' AND oaytype ='B9' AND oayslip = g_lua01
            IF l_n = 0 THEN
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
               OTHERWISE 
                  EXIT CASE
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
         CLOSE WINDOW t321_1_w
         CALL cl_err('',9001,0)
         LET g_success = 'N'
         RETURN
      END IF

      CLOSE WINDOW t321_1_w
        
      CALL s_check_no("art",g_lua01,"",'B9',"lua_file","lua01","")
           RETURNING li_result,l_lua01
           
      CALL s_auto_assign_no("art",g_lua01,g_today,'B9',"lua_file","lua01","","","")
           RETURNING li_result,l_lua01
       
      IF NOT li_result THEN
               CALL cl_err('','alm-859',0)
               LET g_success = 'N'
               RETURN
      END IF

      IF (g_lig.lig05 = '1') OR (g_lig.lig05 = '2') THEN
           LET l_lua06 = 'MISC'
           LET l_lua061 = 'MISC'
      END IF   
                  
      IF g_lig.lig05 = '3' THEN
         LET l_lua06 = g_lig.lig07

         SELECT lne05 INTO l_lua061
           FROM lne_file 
          WHERE lne01 = g_lig.lig07 

      END IF      
                 
      SELECT occ02,occ41 INTO l_occ02,l_occ41
        FROM occ_file 
       WHERE occ01 = l_lua06

      SELECT gec04,gec07 INTO l_gec04,l_gec07
        FROM gec_file
       WHERE gec01 = l_occ41
              
     # IF (l_gec07='N') THEN
     #    LET l_lub04 = g_lig.lig10
     #    LET l_lub04t = g_lig.lig10*(1+l_gec04/100)
     #         
     # ELSE       
     #    LET l_lub04= g_lig.lig10/(1+l_gec04/100)
     #    LET l_lub04t = g_lig.lig10
     # END IF

      LET l_lub04t = g_lig.lig10
      LET l_lub04 = g_lig.lig10/(1+l_gec04/100)  
      LET l_lub04 = cl_digcut(l_lub04,l_azi04)
      
      LET l_lub10 = g_today
      IF l_lub10 <= g_ooz.ooz09 THEN
         LET l_lub10 = g_ooz.ooz09 + 1
      END IF  
      
      SELECT oaj05 INTO l_oaj05
        FROM oaj_file
       WHERE oaj01 = g_lig.lig09

      IF s_chk_own(l_lua06) THEN
         LET l_lua05 = 'Y'
         LET l_lua37 = 'N'
      ELSE
         LET l_lua05 = 'N'
         #LET l_lua37 = 'Y'        #TQC-C20525 mark
         LET l_lua37 = 'N'         #TQC-C20525 add
      END IF
      INSERT INTO lua_file (lua01,lua02,lua03,lua04,lua05,lua06,lua061,lua07,lua08,lua08t,
                              lua09,lua10,lua11,lua12,lua13,lua14,lua15,lua16,lua17,lua18,lua19,
                              lua20,lua21,lua22,lua23,lua24,lua27,lua28,lua29,lua30,lua31,luaacti,
                              luacrat,luadate,luagrup,lualegal,luamodu,luaplant,luauser,luaoriu,luaorig,lua32,
                              lua33,lua34,lua35,lua36,lua37,lua38,lua39)
                  VALUES (l_lua01,'01','','',l_lua05 ,l_lua06,l_lua061,g_lig.lig04,'0','0',g_today,'Y',
                              '3',g_lig.lig01,'N','0','N','','','',g_plant,'',l_occ41,l_gec04,l_gec07,'',
                              '','','','','','Y',g_today,g_today,g_grup,g_legal,'',g_plant,g_user,g_user,g_grup,g_lig.lig05,
                          #   '','',0,0,l_lua37,g_user,g_today)      #TQC-C30027 mark
                              '','',0,0,l_lua37,g_user,g_grup)       #TQC-C30027 add
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('insert lua_file:',SQLCA.SQLCODE,0)
         LET g_success = 'N'
         RETURN
      END IF 
           
      INSERT INTO lub_file (lub01,lub02,lub03,lub04,lub04t,lub05,lub06,lub07,lub08,
                             lublegal,lubplant,lub09,lub10,lub11,lub12,lub13,lub14,lub15)
                   VALUES( l_lua01,'1',g_lig.lig09,l_lub04,l_lub04t,'','',g_today,g_today,
                           g_legal,g_plant,l_oaj05,l_lub10,0,0,'N','','')

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('insert lua_file:',SQLCA.SQLCODE,0)
               LET g_success = 'N'
               RETURN
      END IF

      UPDATE lua_file SET lua08 = l_lub04,
                           lua08t = l_lub04t
                      WHERE lua01 = l_lua01

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_err('UPDATE lua_file:',SQLCA.SQLCODE,0)
                LET g_success = 'N'
                RETURN
      END IF  
      LET g_lig.lig11 = l_lua01
   END IF 
END FUNCTION
 
FUNCTION t321_unconfirm()
   DEFINE l_ligconu         LIKE lig_file.ligconu, 
          l_ligcond         LIKE lig_file.ligcond,
          l_lua15           LIKE lua_file.lua15,
          l_n               LIKE type_file.num5
   
   IF cl_null(g_lig.lig01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lig.* FROM lig_file
    WHERE lig01 = g_lig.lig01
  
   LET l_ligconu = g_lig.ligconu
   LET l_ligcond = g_lig.ligcond 
  
   IF g_lig.ligconf = 'N' THEN
      CALL cl_err(g_lig.lig01,'alm-007',1)
      RETURN
   END IF
  
   IF g_lig.ligconf = 'X' THEN
      CALL cl_err(g_lig.lig01,'alm-134',1)
      RETURN
   END IF
 
   SELECT lua15 INTO l_lua15
     FROM lua_file
    WHERE lua01 = g_lig.lig11

   IF (l_lua15 = 'Y') THEN
      CALL cl_err('','alm1055',1)
      RETURN
   END IF

   SELECT count(*) INTO l_n
     FROM rxy_file
    WHERE rxy01 = g_lig.lig11

   IF l_n > 0 THEN
      CALL cl_err('','alm1056',0)
      RETURN
   END IF 
   
    BEGIN WORK

    OPEN t321_cl USING g_lig.lig01
    IF STATUS THEN 
       CALL cl_err("open t321_cl:",STATUS,1)
       CLOSE t321_cl
       ROLLBACK WORK 
       RETURN 
    END IF 

    FETCH t321_cl INTO g_lig.*
    IF SQLCA.sqlcode  THEN 
      CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
      CLOSE t321_cl
      ROLLBACK WORK
      RETURN 
    END IF    
    
 
   IF NOT cl_confirm('alm-008') THEN
      RETURN
   ELSE
      LET g_lig.ligconf = 'N'
      #CHI-D20015---modify---str---
      #LET g_lig.ligconu = NULL
      #LET g_lig.ligcond = NULL
      LET g_lig.ligconu = g_user
      LET g_lig.ligcond = g_today
      #CHI-D20015---modify---end---
      LET g_lig.ligmodu = g_user
      LET g_lig.ligdate = g_today

      DELETE FROM lua_file WHERE lua01 = g_lig.lig11
      DELETE FROM lub_file WHERE lub01 = g_lig.lig11
      
      LET g_lig.lig11 =''

      UPDATE lig_file
         SET ligconf = g_lig.ligconf,
             ligconu = g_lig.ligconu,
             ligcond = g_lig.ligcond,
             ligmodu = g_lig.ligmodu,
             ligdate = g_lig.ligdate,
             lig11   = g_lig.lig11
         WHERE lig01 = g_lig.lig01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err('upd lig:',SQLCA.SQLCODE,0)
        LET g_lig.ligconf = "Y"
        LET g_lig.ligconu = l_ligconu
        LET g_lig.ligcond = l_ligcond
        DISPLAY BY NAME g_lig.ligconf,g_lig.ligconu,g_lig.ligcond
        RETURN
      ELSE
         DISPLAY BY NAME g_lig.lig11,g_lig.ligconf,g_lig.ligconu,g_lig.ligcond,g_lig.ligmodu,g_lig.ligdate
      END IF
   END IF 
    CLOSE t321_cl
  COMMIT WORK    
END FUNCTION
 
FUNCTION t321_v(p_type)
DEFINE p_type    LIKE type_file.chr1   #FUN-D20039  add '1' 作废  '2' 取消作废

   IF cl_null(g_lig.lig01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_lig.* FROM lig_file
    WHERE lig01  = g_lig.lig01
   
   #FUN-D20039 ----------sta
    IF p_type = 1 THEN
       IF g_lig.ligconf='X' THEN RETURN END IF
    ELSE
       IF g_lig.ligconf<>'X' THEN RETURN END IF
    END IF
    #FUN-D20039 ----------end
 
   IF g_lig.ligconf = 'Y' THEN
      CALL cl_err(g_lig.lig01,'9023',0)
      RETURN
   END IF

 
   BEGIN WORK

   OPEN t321_cl USING g_lig.lig01
   IF STATUS THEN 
      CALL cl_err("open t321_cl:",STATUS,1)
      CLOSE t321_cl
      ROLLBACK WORK 
      RETURN 
   END IF 

   FETCH t321_cl INTO g_lig.*
   IF SQLCA.sqlcode  THEN 
     CALL cl_err(g_lig.lig01,SQLCA.sqlcode,0)
     CLOSE t321_cl
     ROLLBACK WORK
     RETURN 
   END IF      
    
   IF g_lig.ligconf != 'Y' THEN
      IF g_lig.ligconf = 'X' THEN
         IF NOT cl_confirm('alm-086') THEN
            RETURN
         ELSE
            LET g_lig.ligconf = 'N'
            LET g_lig.ligmodu = g_user
            LET g_lig.ligdate = g_today
            UPDATE lig_file
               SET ligconf = g_lig.ligconf,
                   ligmodu = g_lig.ligmodu,
                   ligdate = g_lig.ligdate
             WHERE lig01 = g_lig.lig01

           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lig:',SQLCA.SQLCODE,0)
               LET g_lig.ligconf = "X"
               DISPLAY BY NAME g_lig.ligconf
               RETURN
            ELSE
               DISPLAY BY NAME g_lig.ligconf,g_lig.ligmodu,g_lig.ligdate
            END IF
         END IF
      ELSE
         IF NOT cl_confirm('alm-085') THEN
            RETURN
         ELSE
            LET g_lig.ligconf = 'X'
            LET g_lig.ligmodu = g_user
            LET g_lig.ligdate = g_today
            UPDATE lig_file
               SET ligconf = g_lig.ligconf,
                   ligmodu = g_lig.ligmodu,
                   ligdate = g_lig.ligdate
             WHERE lig01 = g_lig.lig01

            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err('upd lig:',SQLCA.SQLCODE,0)
               LET g_lig.ligconf = "N"
               DISPLAY BY NAME g_lig.ligconf
               RETURN
            ELSE
               DISPLAY BY NAME g_lig.ligconf,g_lig.ligmodu,g_lig.ligdate
            END IF
         END IF
      END IF
   END IF
  CLOSE t321_cl
  COMMIT WORK  
END FUNCTION 

#--FUN-B90056-------------------------------------------------------------

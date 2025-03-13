# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmq501.4gl
# Descriptions...: 採購單數量/日期查詢
# Date & Author..: 91/10/18 By Carol
# Modify.........: No.FUN-570175 05/07/19 By Elva  新增雙單位內容
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-590083 06/03/31 By Alexstar 新增多語言資料顯示功能
# Modify.........: No.FUN-680136 06/09/01 By Jackho 欄位類型修改
# Modify.........: No.CHI-6C0028 07/02/02 By rainy 查詢方式INPUT改成QBE
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-940083 09/05/14 By dxfwo   原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.FUN-940083 09/05/15 By douzh   EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-B30077 11/03/07 By lilingyu 採購單號開窗後,選擇全部資料,然後確定,程序報錯:找到一個未成對的引號
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       tm  RECORD   #CHI-6C0028
#           wc      LIKE type_file.chr1000  # Head Where condition         #TQC-B30077 
            wc      STRING                                                 #TQC-B30077 
       END RECORD,
 
         g_pmn RECORD
            pmn01   LIKE pmn_file.pmn01,  #CHI-6C0028
            pmn02   LIKE pmn_file.pmn02,  #T
            pmn011  LIKE pmn_file.pmn011,
            pmn20   LIKE pmn_file.pmn20,
            #FUN-570175  --begin
            pmn83   LIKE pmn_file.pmn83,
            pmn85   LIKE pmn_file.pmn85,
            pmn80   LIKE pmn_file.pmn80,
            pmn82   LIKE pmn_file.pmn82,
            #FUN-570175  --end
            pmn33   LIKE pmn_file.pmn33,
            pmn34   LIKE pmn_file.pmn34,
            pmn35   LIKE pmn_file.pmn35,
            pmn36   LIKE pmn_file.pmn36,
            pmn37   LIKE pmn_file.pmn37,
            pmn50   LIKE pmn_file.pmn50,
            pmn51   LIKE pmn_file.pmn51,
            pmn53   LIKE pmn_file.pmn53,
            pmn55   LIKE pmn_file.pmn55,
            pmn31   LIKE pmn_file.pmn31,
            pmn44   LIKE pmn_file.pmn44,
            pmm22   LIKE pmm_file.pmm22,
            pmm42   LIKE pmm_file.pmm42,
            rest    like pmn_file.pmn20,
            pmn04   LIKE pmn_file.pmn04,  #T
            pmn041  LIKE pmn_file.pmn041, #T
            ima021  LIKE ima_file.ima021,
            pmn07   LIKE pmn_file.pmn07,  #T
            pmm09   LIKE pmm_file.pmm09,  #T
            pmc03   LIKE pmc_file.pmc03   #T
        END RECORD,
        g_pmn01     LIKE pmn_file.pmn01,      # 所要查詢的key
        g_pmn02     LIKE pmn_file.pmn02,      # 所要查詢的key
        g_argv1     LIKE pmn_file.pmn01,
        g_argv2     LIKE pmn_file.pmn02,      # 所要查詢的key
        g_null      LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(1)
        g_rec_b     LIKE type_file.num5,      #No.FUN-680136 SMALLINT
        g_sql       string                    #No.FUN-580092 HCN
DEFINE p_row,p_col  LIKE type_file.num5       #No.FUN-680136 SMALLINT SMALLINT
DEFINE g_row_count  LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_curs_index LIKE type_file.num10      #No.FUN-680136 INTEGER
DEFINE g_jump       LIKE type_file.num10,     #No.FUN-680136 INTEGER
       mi_no_ask    LIKE type_file.num5       #No.FUN-680136 SMALLINT
DEFINE g_msg        LIKE ze_file.ze03         #No.FUN-680136 VARCHAR(72)
DEFINE g_before_input_done   STRING
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET p_row = 3 LET p_col = 11
 
   OPEN WINDOW q501_w AT p_row,p_col WITH FORM "apm/42f/apmq501"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   #-----FUN-610006---------
   CALL q501_def_form()
#  #FUN-570175  --begin
#  IF g_sma.sma115 ='N' THEN
#     CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
#     CALL cl_set_comp_visible("group03",FALSE)
#  END IF
#  IF g_sma.sma122 ='1' THEN
#     CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#     CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#     CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#     CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#  END IF
#  IF g_sma.sma122 ='2' THEN
#     CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
#     CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
#     CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
#     CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
#     CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
#  END IF
#  #FUN-570175  --end
   #-----END FUN-610006-----
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
   IF NOT cl_null(g_argv1) THEN
      LET g_pmn01 = g_argv1
      LET g_pmn02 = g_argv2
      DISPLAY g_pmn01 TO  FORMONLY.pmn01
      DISPLAY g_pmn02 TO  FORMONLY.pmn02
      CALL q501_pmn01()
   END IF
 
   #WHILE TRUE      ####040512
      LET g_action_choice=""
      CALL q501_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
   #END WHILE    ####040512
 
   CLOSE WINDOW q501_w

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
FUNCTION q501_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL q501_i()
            END IF
        ON ACTION next
            CALL q501_fetch('N')
        ON ACTION previous
            CALL q501_fetch('P')
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL q501_def_form()   #FUN-610006
#          EXIT MENU
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL q501_fetch('/')
        ON ACTION first
             CALL q501_fetch('F')
        ON ACTION last
           CALL q501_fetch('L')

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
 
END FUNCTION
 
 
FUNCTION q501_i()
    DEFINE   l_cnt    LIKE type_file.num5,         #No.FUN-680136 SMALLINT
             p_cmd    LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    CALL cl_opmsg('a')
    CLEAR FORM
    LET g_pmn01 = ''
    LET g_pmn02 = ''
 #CHI-6C0028--begin
    #INPUT g_pmn01,g_pmn02 WITHOUT DEFAULTS FROM pmn01,pmn02
 
    #   BEFORE INPUT
    #        LET g_before_input_done = FALSE
    #        CALL q501_set_entry(p_cmd)
    #        CALL q501_set_no_entry(p_cmd)
    #        LET g_before_input_done = TRUE
 
    #    AFTER FIELD pmn01                       #採購單號
    #      IF NOT cl_null(g_pmn01) THEN
    #         SELECT COUNT(*) INTO l_cnt FROM pmn_file
    #          WHERE pmn01 = g_pmn01
    #         IF l_cnt = 0 THEN
    #            CALL cl_err(g_pmn01,'mfg3332',0)
    #            NEXT FIELD pmn01
    #         END IF
    #         DISPLAY l_cnt TO FORMONLY.cnt
    #         LET g_row_count = l_cnt
    #      END IF
 
    #    AFTER FIELD pmn02                      #採購單項次
    #        IF cl_null(g_pmn02) THEN
    #           LET g_null = 'Y'
    #           SELECT COUNT(*) INTO l_cnt FROM pmn_file
    #             WHERE pmn01 = g_pmn01
    #        ELSE
    #           LET g_null = 'N'
    #           SELECT COUNT(*) INTO l_cnt FROM pmn_file
    #             WHERE pmn01 = g_pmn01
    #             AND   pmn02 = g_pmn02
    #        END IF
    #        DISPLAY l_cnt TO FORMONLY.cnt
 
    #    ON ACTION CONTROLP
#   #        CALL q_pmm(6,3,g_pmn01) RETURNING g_pmn01
    #        CALL q_pmm(FALSE,TRUE,g_pmn01) RETURNING g_pmn01
#   #         CALL FGL_DIALOG_SETBUFFER( g_pmn01 )
    #        DISPLAY g_pmn01 TO pmn01
 
    #    ON ACTION CONTROLR
    #       CALL cl_show_req_fields()
    #    ON ACTION CONTROLG
    #       CALL cl_cmdask()
 
    #    ON IDLE g_idle_seconds
    #       CALL cl_on_idle()
    #       CONTINUE INPUT
 
    #  ON ACTION about         #MOD-4C0121
    #     CALL cl_about()      #MOD-4C0121
 
    #  ON ACTION help          #MOD-4C0121
    #     CALL cl_show_help()  #MOD-4C0121
    #END INPUT
 
    LET tm.wc = ''
    INITIALIZE g_pmn.* TO NULL     #No.FUN-750051
    CONSTRUCT BY NAME tm.wc ON pmn01,pmn02
      BEFORE CONSTRUCT
        CALL cl_qbe_init()
      
      ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
      ON ACTION CONTROLP
          CASE WHEN INFIELD(pmn01)      #採購單號
              CALL cl_init_qry_var()
              LET g_qryparam.state= "c"
              LET g_qryparam.form = "q_pmm13"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmn01
              NEXT FIELD pmn01
          END CASE
    END CONSTRUCT 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    LET g_sql = "SELECT COUNT(*)  FROM pmn_file ",
                " WHERE ", tm.wc CLIPPED
    PREPARE q501_pre FROM  g_sql
#   DECLARE q501_cur CURSOR FOR q501_pre     #No.FUN-940083
#   EXECUTE q501_cur INTO l_cnt              #No.FUN-940083
    EXECUTE q501_pre INTO l_cnt              #No.FUN-940083
    LET g_row_count = l_cnt
    DISPLAY l_cnt TO FORMONLY.cnt
  #CHI-6C0028--end
 
    CALL q501_pmn01()
 
END FUNCTION
 
FUNCTION q501_pmn01()  #採購單號
#   DEFINE l_sql LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(2000)      #TQC-B30077
    DEFINE l_sql STRING                                                         #TQC-B30077
 
    #FUN-570175  --begin
    LET l_sql = " SELECT pmn01,pmn02,pmn011,pmn20,pmn83,pmn85,pmn80,pmn82,", #FUN-6C0068 add pmn01
                " pmn33,pmn34,pmn35,pmn36,",
    #FUN-570175  --end
                " pmn37,  pmn50, pmn51, pmn53, pmn55,pmn31, pmn44, pmm22,",
#               " pmm42,pmn20-pmn50+pmn55, pmn04, pmn041, ima021, pmn07,",        #No.FUN-940083
                " pmm42,pmn20-pmn50+pmn55+pmn58, pmn04, pmn041, ima021, pmn07,",  #No.FUN-940083
                " pmm09, pmc03 " ,
                " FROM pmn_file, pmm_file,",
                " OUTER pmc_file , OUTER ima_file ",
  #CHI-6C0028--begin
    #            " WHERE pmm01 = '",g_pmn01,"' AND pmm18 <> 'X' ",
    #            " AND   pmn01 = pmm01 AND pmn04=ima_file.ima01 ",
    #            " AND pmm_file.pmm09 = pmc_file.pmc01 "
    #IF g_null = 'N' THEN
    #   LET l_sql = l_sql CLIPPED," AND pmn02 = '",g_pmn02,"'" CLIPPED
    #END IF
                " WHERE pmn01 = pmm01 AND pmn_file.pmn04=ima_file.ima01 ",
                "   AND pmm_file.pmm09 = pmc_file.pmc01 AND pmm18 <>'X' ",
                "   AND ",tm.wc CLIPPED
  #CHI-6C0028--end
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #       LET l_sql = l_sql clipped," AND pmmuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #       LET l_sql = l_sql clipped," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #       LET l_sql = l_sql clipped," AND pmmgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
    #End:FUN-980030
 
    PREPARE q501_p FROM l_sql
    IF SQLCA.sqlcode THEN
       CALL cl_err('prepare error ! ',SQLCA.SQLCODE,0)
    END IF
    DECLARE q501_c SCROLL CURSOR WITH HOLD FOR q501_p
    IF SQLCA.sqlcode THEN
       CALL cl_err('declare error ! ',SQLCA.SQLCODE,0)
    ELSE
       OPEN q501_c
       CALL q501_fetch('F')
    END IF
 
END FUNCTION
 
 
FUNCTION q501_fetch(p_flg)
    DEFINE
        p_flg          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    CASE p_flg
        WHEN 'N' FETCH NEXT     q501_c INTO g_pmn.*
        WHEN 'P' FETCH PREVIOUS q501_c INTO g_pmn.*
        WHEN 'F' FETCH FIRST    q501_c INTO g_pmn.*
        WHEN 'L' FETCH LAST     q501_c INTO g_pmn.*
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
#                     CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q501_c INTO g_pmn.*
            LET mi_no_ask = TRUE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err('fetch error !',SQLCA.sqlcode,0)
        INITIALIZE g_pmn.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       CALL q501_b()
    END IF
END FUNCTION
 
FUNCTION q501_b()              #BODY FILL UP
 
  DISPLAY BY NAME g_pmn.pmn01,g_pmn.pmn02,g_pmn.pmn011,g_pmn.pmn07,g_pmn.pmn04,   #FUN-6C0068 add pmn01
                  g_pmn.pmn041,g_pmn.ima021,g_pmn.pmm09,g_pmn.pmc03,
                  #FUN-570175  --begin
                  g_pmn.pmn20,g_pmn.pmn83,g_pmn.pmn85,g_pmn.pmn80,
                  g_pmn.pmn82,g_pmn.pmn33,
                  #FUN-570175  --end
                  g_pmn.pmn34,g_pmn.pmn35,g_pmn.pmn36,g_pmn.pmn37,
                  g_pmn.pmn50,g_pmn.pmn51,g_pmn.pmn53,
                  g_pmn.pmn55,g_pmn.pmn31,g_pmn.pmn44,
                  g_pmn.pmm22,g_pmn.pmm42,g_pmn.rest
  CALL cl_show_fld_cont()                   #No.FUN-590083
 
  MESSAGE ''
END FUNCTION
 
FUNCTION q501_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmn01",TRUE)
   END IF
END FUNCTION
 
FUNCTION q501_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pmn01",FALSE)
   END IF
END FUNCTION
 
#-----FUN-610006---------
FUNCTION q501_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pmn80,pmn82,pmn83,pmn85",FALSE)
      CALL cl_set_comp_visible("group03",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pmn82",g_msg CLIPPED)
   END IF
END FUNCTION
#-----END FUN-610006-----

# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: amsi601.4gl
# Descriptions...: 資源項目維護作業
# Date & Author..: 91/12/04 By Nora
# Modify.........: No.FUN-4C0041 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.MOD-530134 05/03/17 By pengu 修改報表欄位寬度
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.MOD-640342 06/04/10 By Claire 報表調整
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6C0181 06/12/27 By Ray "資源數量"在錄入負值時,無報錯信息
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770012 07/07/06 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.TQC-970171 09/07/22 By lilingyu 1.無效資料不可刪除 2.工作站欄位錄入無效值,無相關提示訊息
# Modify.........: No.TQC-980058 09/08/10 By sherry 刪除一筆后，無法顯示下一筆             
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rpf   RECORD LIKE rpf_file.*,
    g_rpf_t RECORD LIKE rpf_file.*,
    g_rpf_o RECORD LIKE rpf_file.*,
    g_rpf01_t LIKE rpf_file.rpf01,
    g_wc,g_sql  STRING,                     #TQC-630166
    g_cmd     LIKE type_file.chr1000        #NO.FUN-680101 VARCHAR(25)
 
DEFINE g_forupd_sql          STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr               LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
DEFINE   g_cnt               LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_i                 LIKE type_file.num5     #count/index for any purpose  #NO.FUN-680101 SMALLINT 
DEFINE   g_msg               LIKE type_file.chr1000  #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count         LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_curs_index        LIKE type_file.num10    #NO.FUN-680101 INTEGER
DEFINE   g_jump              LIKE type_file.num10,   #NO.FUN-680101 INTEGER
         mi_no_ask           LIKE type_file.num5     #NO.FUN-680101 SMALLINT 
#No.FUN-770012 -- begin --
DEFINE g_sql1     STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-770012 -- end --
DEFINE g_argv1     LIKE rpf_file.rpf01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0081
    DEFINE p_row,p_col     LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMS")) THEN
      EXIT PROGRAM
   END IF
 
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
#No.FUN-770012 --begin
   LET g_sql1 = "rpf01.rpf_file.rpf01,",
                "rpf02.rpf_file.rpf02,",
                "rpf03.rpf_file.rpf03,",
                "rpf04.rpf_file.rpf04,",
                "rpf06.rpf_file.rpf06,",
                "rpf07.rpf_file.rpf07,",
                "rpfacti.rpf_file.rpfacti"
   LET l_table = cl_prt_temptable('amsi601',g_sql1) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?)"
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770012 --end
    INITIALIZE g_rpf.* TO NULL
    INITIALIZE g_rpf_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM rpf_file  WHERE rpf01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 5 LET p_col = 6
    OPEN WINDOW i601_w AT p_row,p_col
      WITH FORM "ams/42f/amsi601"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i601_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i601_a()
            END IF
         OTHERWISE        
            CALL i601_q() 
      END CASE
   END IF
   #--
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL i601_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW i601_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION i601_cs()
    CLEAR FORM
   INITIALIZE g_rpf.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" rpf01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        rpf01,rpf02,rpf06,rpf07,rpf04,rpf03,
        rpfuser,rpfgrup,rpfmodu,rpfdate,rpfacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(rpf06) #工作中心
#                 CALL q_eca(10,6,g_rpf.rpf06) RETURNING g_rpf.rpf06
                 CALL q_eca(TRUE,TRUE,g_rpf.rpf06) RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO rpf06
                 NEXT FIELD rpf06
               OTHERWISE EXIT CASE
            END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rpfuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rpfgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rpfgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rpfuser', 'rpfgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT rpf01 FROM rpf_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY rpf01"
    PREPARE i601_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i601_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i601_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM rpf_file WHERE ",g_wc CLIPPED
    PREPARE i601_precount FROM g_sql
    DECLARE i601_count CURSOR FOR i601_precount
END FUNCTION
 
FUNCTION i601_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL i601_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
               CALL i601_q()
            END IF
        ON ACTION next
            CALL i601_fetch('N')
        ON ACTION previous
            CALL i601_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth()
            THEN CALL i601_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth()
            THEN CALL i601_x()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth()
            THEN CALL i601_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
               CALL i601_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
               CALL i601_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL i601_fetch('/')
        ON ACTION first
            CALL i601_fetch('F')
        ON ACTION last
            CALL i601_fetch('L')

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
        #No.FUN-6A0150-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_rpf.rpf01 IS NOT NULL THEN
                  LET g_doc.column1 = "rpf01"
                  LET g_doc.value1 = g_rpf.rpf01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0150-------add--------end----
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i601_cs
END FUNCTION
 
 
FUNCTION i601_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_rpf.* LIKE rpf_file.*
    LET g_rpf01_t = NULL
   #LET g_rpf_t.*=g_rpf.*
    LET g_rpf_o.*=g_rpf.*
    LET g_rpf.rpf04 = 0
    LET g_rpf.rpf07 = 'Y'	
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_rpf.rpfacti ='Y'                   #有效的資料
        LET g_rpf.rpfuser = g_user
        LET g_rpf.rpforiu = g_user #FUN-980030
        LET g_rpf.rpforig = g_grup #FUN-980030
        LET g_rpf.rpfgrup = g_grup               #使用者所屬群
        LET g_rpf.rpfdate = g_today
        CALL i601_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_rpf.rpf01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO rpf_file VALUES(g_rpf.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
    #       CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("ins","rpf_file",g_rpf.rpf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
            CONTINUE WHILE
        ELSE
            LET g_rpf_t.* = g_rpf.*                # 保存上筆資料
            SELECT rpf01 INTO g_rpf.rpf01 FROM rpf_file
                WHERE rpf01 = g_rpf.rpf01
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION i601_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1) 
        l_sw            LIKE type_file.chr1,    #判斷必要欄位是否未輸入 #NO.FUN-680101 VARCHAR(1) 
        l_n             LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
    LET l_sw = 'N'
    DISPLAY BY NAME g_rpf.rpfuser,g_rpf.rpfgrup,
                    g_rpf.rpfdate, g_rpf.rpfacti
 
    INPUT BY NAME g_rpf.rpforiu,g_rpf.rpforig,
        g_rpf.rpf01,g_rpf.rpf02,g_rpf.rpf06,g_rpf.rpf07,
        g_rpf.rpf04,g_rpf.rpf03
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i601_set_entry(p_cmd)
           CALL i601_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD rpf01
          IF NOT cl_null(g_rpf.rpf01) THEN
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_rpf.rpf01 != g_rpf01_t) THEN
                SELECT count(*) INTO l_n FROM rpf_file
                    WHERE rpf01 = g_rpf.rpf01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_rpf.rpf01,-239,0)
                    LET g_rpf.rpf01 = g_rpf01_t
                    DISPLAY BY NAME g_rpf.rpf01
                    NEXT FIELD rpf01
                END IF
            END IF
          END IF
 
        AFTER FIELD rpf03  #1.人時 2.機時
            IF g_rpf.rpf03 NOT MATCHES '[12]' THEN
               NEXT FIELD rpf03
            END IF
            LET g_rpf_o.rpf03 = g_rpf.rpf03
 
        AFTER FIELD rpf04
            IF g_rpf.rpf04 < 0 THEN
               CAll cl_err(g_rpf.rpf04,'anm-249',1)     #No.TQC-6C0181
               LET g_rpf.rpf04 = 0
               DISPLAY BY NAME g_rpf.rpf04
            END IF
 
        AFTER FIELD rpf06     # 工作中心
          IF NOT cl_null(g_rpf.rpf06) THEN
            CALL i601_rpf06('d')
            IF g_errno <> ' ' THEN
               CALL cl_err('',g_errno,0)  #TQC-970171
               NEXT FIELD rpf06
            END IF
          END IF
 
        AFTER INPUT
           LET g_rpf.rpfuser = s_get_data_owner("rpf_file") #FUN-C10039
           LET g_rpf.rpfgrup = s_get_data_group("rpf_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_rpf.rpf04 IS NULL THEN
               LET g_rpf.rpf04 = 0
               DISPLAY BY NAME g_rpf.rpf04
            END IF
            IF cl_null(g_rpf.rpf06) THEN NEXT FIELD rpf06 END IF
       
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(rpf01) THEN
        #        LET g_rpf.* = g_rpf_t.*
        #        DISPLAY BY NAME g_rpf.*
        #        NEXT FIELD rpf01
        #    END IF
        #MOD-650015 --end
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(rpf06) #工作中心
#                 CALL q_eca(10,6,g_rpf.rpf06) RETURNING g_rpf.rpf06
                  CALL q_eca(FALSE,TRUE,g_rpf.rpf06) RETURNING g_rpf.rpf06
#                  CALL FGL_DIALOG_SETBUFFER( g_rpf.rpf06 )
                  DISPLAY BY NAME g_rpf.rpf06
                  NEXT FIELD rpf06
               OTHERWISE EXIT CASE
            END CASE
{
 
       ON ACTION mntn_unit #單位資料
                   LET g_cmd = 'aooi101 '
                   CALL cl_cmdrun(g_cmd)
 
       ON ACTION mntn_item_unit_conv #料件單位換算資料
                   LET g_cmd = 'aooi103 '
                   CALL cl_cmdrun(g_cmd)
 
       ON ACTION mntn_unit_conv #單位換算資料
                   LET g_cmd = 'aooi102 '
                   CALL cl_cmdrun(g_cmd)
 
}
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i601_unit(p_key)
    DEFINE p_key        LIKE gfe_file.gfe01,
           l_gfeacti    LIKE gfe_file.gfeacti
 
    LET g_errno =''
    SELECT gfeacti INTO l_gfeacti FROM gfe_file  WHERE gfe01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aoo-012'
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i601_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rpf.* TO NULL              #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i601_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i601_count
    FETCH i601_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i601_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0)
        INITIALIZE g_rpf.* TO NULL
    ELSE
        CALL i601_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i601_fetch(p_flrpf)
    DEFINE
        p_flrpf         LIKE type_file.chr1,     #NO.FUN-680101 VARCHAR(1)
        l_abso          LIKE type_file.num10     #NO.FUN-680101 INTEGER
 
    CASE p_flrpf
        WHEN 'N' FETCH NEXT     i601_cs INTO g_rpf.rpf01
        WHEN 'P' FETCH PREVIOUS i601_cs INTO g_rpf.rpf01
        WHEN 'F' FETCH FIRST    i601_cs INTO g_rpf.rpf01
        WHEN 'L' FETCH LAST     i601_cs INTO g_rpf.rpf01
        WHEN '/'
          IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
          #FETCH ABSOLUTE l_abso i601_cs INTO g_rpf.rpf01    #TQC-980058 mark                                               
          FETCH ABSOLUTE g_jump i601_cs INTO g_rpf.rpf01     #TQC-980058 add 
          LET mi_no_ask = FALSE
    END CASE
    IF STATUS THEN
       CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0)
       INITIALIZE g_rpf.* TO NULL  #TQC-6B0105
       RETURN
    END IF
 
    SELECT * INTO g_rpf.* FROM rpf_file    # 重讀DB,因TEMP有不被更新特性
       WHERE rpf01 = g_rpf.rpf01
    IF SQLCA.sqlcode THEN
  #     CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0) #No.FUN-660108
        CALL cl_err3("sel","rpf_file",g_rpf.rpf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
        RETURN
    ELSE                                      #FUN-4C0041權限控管
       LET g_data_owner = g_rpf.rpfuser
       LET g_data_group = g_rpf.rpfgrup
        CALL i601_show()                      # 重新顯示
       CASE p_flrpf
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
FUNCTION i601_show()
    LET g_rpf_t.* = g_rpf.*
    DISPLAY BY NAME g_rpf.rpf01,g_rpf.rpf02,g_rpf.rpf06,g_rpf.rpf07, g_rpf.rpforiu,g_rpf.rpforig,
                    g_rpf.rpf04,g_rpf.rpf03,
                    g_rpf.rpfuser,g_rpf.rpfgrup,g_rpf.rpfmodu,
                    g_rpf.rpfdate,g_rpf.rpfacti
    CALL i601_rpf06('d')
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i601_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_rpf.rpf01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_rpf.rpfacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rpf.rpf01,9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_rpf01_t = g_rpf.rpf01
    LET g_rpf_o.* = g_rpf.*
  BEGIN WORK
 
    OPEN i601_cl USING g_rpf.rpf01
    IF STATUS THEN
       CALL cl_err("OPEN i601_cl:", STATUS, 1)
       CLOSE i601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i601_cl INTO g_rpf.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0)
       CLOSE i601_cl ROLLBACK WORK RETURN
    END IF
    LET g_rpf.rpfmodu=g_user                     #修改者
    LET g_rpf.rpfdate = g_today                  #修改日期
    CALL i601_show()                             #顯示最新資料
    WHILE TRUE
        CALL i601_i("u")                         #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rpf.*=g_rpf_t.*
            CALL i601_show()
            CALL cl_err('',9001,0)
            ROLLBACK WORK
            EXIT WHILE
        END IF
        # 更新DB
        UPDATE rpf_file SET rpf_file.* = g_rpf.* WHERE rpf01 = g_rpf.rpf01
        IF SQLCA.sqlcode THEN
    #      CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0) #No.FUN-660108
           CALL cl_err3("upd","rpf_file",g_rpf.rpf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i601_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i601_x()
    DEFINE  l_chr    LIKE type_file.chr1    #NO.FUN-680101 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rpf.rpf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
  BEGIN WORK
 
    OPEN i601_cl USING g_rpf.rpf01
    IF STATUS THEN
       CALL cl_err("OPEN i601_cl:", STATUS, 1)
       CLOSE i601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i601_cl INTO g_rpf.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0)
        CLOSE i601_cl ROLLBACK WORK RETURN
    END IF
    CALL i601_show()
    IF cl_exp(15,21,g_rpf.rpfacti) THEN
        LET g_chr=g_rpf.rpfacti
        IF g_rpf.rpfacti='Y' THEN
            LET g_rpf.rpfacti='N'
        ELSE
            LET g_rpf.rpfacti='Y'
        END IF
        UPDATE rpf_file
            SET rpfacti=g_rpf.rpfacti,
                rpfmodu=g_user, rpfdate=g_today
            WHERE rpf01=g_rpf.rpf01
        IF SQLCA.SQLERRD[3]=0 THEN
    #       CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("upd","rpf_file",g_rpf.rpf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
            LET g_rpf.rpfacti=g_chr
            CLOSE i601_cl ROLLBACK WORK
            RETURN
        END IF
        DISPLAY BY NAME g_rpf.rpfacti
    END IF
    CLOSE i601_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i601_r()
DEFINE
    l_chr  LIKE type_file.chr1       #NO.FUN-680101 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rpf.rpf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
#TQC-970171 --begin--
    IF g_rpf.rpfacti = 'N' THEN
       CALL cl_err('','abm-033',0)
       RETURN
    END IF 
#TQC-970171 --end--
 
    BEGIN WORK
 
    OPEN i601_cl USING g_rpf.rpf01
    IF STATUS THEN
       CALL cl_err("OPEN i601_cl:", STATUS, 1)
       CLOSE i601_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i601_cl INTO g_rpf.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0)
       CLOSE i601_cl ROLLBACK WORK RETURN END IF
    CALL i601_show()
    IF cl_delh(0,0) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rpf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rpf.rpf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
        DELETE FROM rpf_file WHERE rpf01=g_rpf.rpf01
        IF SQLCA.SQLERRD[3]=0 THEN
  #        CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0) #No.FUN-660108
           CALL cl_err3("del","rpf_file",g_rpf.rpf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
           CLOSE i601_cl ROLLBACK WORK RETURN
        END IF
        #CKP
        INITIALIZE g_rpf.* TO NULL
        CLEAR FORM
        OPEN i601_count
        FETCH i601_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN i601_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL i601_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL i601_fetch('/')
        END IF
    END IF
    CLOSE i601_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i601_copy()
    DEFINE
        l_n             LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
        l_oldno,l_newno	LIKE rpf_file.rpf01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rpf.rpf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i601_set_entry('a')
    CALL i601_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM rpf01
        AFTER FIELD rpf01
            IF l_newno IS NULL THEN
                NEXT FIELD rpf01
            END IF
            SELECT count(*) INTO g_cnt FROM rpf_file
                WHERE rpf01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD rpf01
            END IF
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_rpf.rpf01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM rpf_file
        WHERE rpf01=g_rpf.rpf01
        INTO TEMP x
    UPDATE x
        SET rpf01=l_newno,    #資料鍵值
            rpfuser=g_user,   #資料所有者
            rpfgrup=g_grup,   #資料所有者所屬群
            rpfmodu=NULL,     #資料修改日期
            rpfdate=g_today,  #資料建立日期
            rpfacti='Y'       #有效資料
    INSERT INTO rpf_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
  #     CALL cl_err(g_rpf.rpf01,SQLCA.sqlcode,0) #No.FUN-660108
        CALL cl_err3("ins","rpf_file",g_rpf.rpf01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        SLEEP 1
        LET l_oldno = g_rpf.rpf01
        LET g_rpf.rpf01 =l_newno
        SELECT rpf_file.* INTO g_rpf.* FROM rpf_file
                       WHERE rpf01 = l_newno
        CALL i601_u()
    END IF
    CALL i601_show()
END FUNCTION
 
FUNCTION i601_rpf06(p_cmd)  #
    DEFINE l_eca02   LIKE eca_file.eca02,
           l_ecaacti LIKE eca_file.ecaacti,
           p_cmd     LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT eca02,ecaacti
      INTO l_eca02,l_ecaacti
      FROM eca_file
     WHERE eca01 = g_rpf.rpf06
 
   #CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'  #TQC-970171
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aem-041'  #TQC-970171
                            LET l_eca02 = NULL
         WHEN l_ecaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_eca02 TO FORMONLY.eca02
    END IF
END FUNCTION
 
FUNCTION i601_out()
    DEFINE
        l_i             LIKE type_file.num5,    #NO.FUN-680101 SMALLINT 
        l_name          LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680101 VARCHAR(20)
        l_rpf   RECORD
                       rpf01     LIKE  rpf_file.rpf01,  #資源項目編號
                       rpf02     LIKE  rpf_file.rpf02,  #說明
                       rpf03     LIKE  rpf_file.rpf03,  #單位
                       rpf04     LIKE  rpf_file.rpf04,  #每天產能
                       rpf06     LIKE  rpf_file.rpf06,
                       rpf07     LIKE  rpf_file.rpf07,
                       rpfacti   LIKE  rpf_file.rpfacti
                END RECORD,
        l_za05          LIKE type_file.chr50,           #NO.FUN-680101 VARCHAR(40)
        l_chr           LIKE type_file.chr1             #NO.FUN-680101 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" rpf01='",g_rpf.rpf01,"'"
    END IF
 
    IF cl_null(g_wc) THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#    CALL cl_outnam('amsi601') RETURNING l_name            #No.FUN-770012
    CALL cl_del_data(l_table)     #No.FUN-770012
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  # 組合出 SQL 指令
    LET g_sql="SELECT rpf01,rpf02,rpf03,rpf04,",
              " rpf06,rpf07,rpfacti FROM rpf_file ",
              " WHERE ",g_wc CLIPPED
    PREPARE i601_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i601_co                         # SCROLL CURSOR
        CURSOR FOR i601_p1
 
#    START REPORT i601_rep TO l_name         #No.FUN-770012
 
    FOREACH i601_co INTO l_rpf.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
       #MOD-640342-begin-mark
        #IF l_rpf.rpf03='1'
        #   THEN
        #   LET l_rpf.rpf03=g_x[9].subString(1,4)
        #ELSE
        #   LET l_rpf.rpf03=g_x[9].subString(6,9)
        #END IF
       #MOD-640342-begin-mark
 
#No.FUN-770012 -- begin --
#        OUTPUT TO REPORT i601_rep(l_rpf.*)
        EXECUTE insert_prep USING l_rpf.rpf01,l_rpf.rpf02,l_rpf.rpf03,l_rpf.rpf04,
                                  l_rpf.rpf06,l_rpf.rpf07,l_rpf.rpfacti
        IF STATUS THEN
           CALL cl_err("execute insert_prep:",STATUS,1)
           EXIT FOREACH
        END IF
#No.FUN-770012 -- end --
    END FOREACH
 
#    FINISH REPORT i601_rep     #No.FUN-770012
 
    CLOSE i601_co
    ERROR ""
#No.FUN-770012 -- begin --
#    CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    CALL cl_wcchp(g_wc,'rpf01,rpf02,rpf06,rpf07,rpf04,rpf03')
         RETURNING g_wc
    LET g_str = g_wc,";",g_zz05
    LET g_sql1 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('amsi601','amsi601',g_sql1,g_str)
#No.FUN-770012 -- end --
END FUNCTION
 
#No.FUN-770012 -- begin --
#REPORT i601_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,         #NO.FUN-680101 VARCHAR(1)
#        sr      RECORD
#                       rpf01     LIKE  rpf_file.rpf01,  #資源項目編號
#                       rpf02     LIKE  rpf_file.rpf02,  #說明
#                       rpf03     LIKE  rpf_file.rpf03,  #單位
#                       rpf04     LIKE  rpf_file.rpf04,  #每天產能
#                       rpf06     LIKE  rpf_file.rpf06,
#                       rpf07     LIKE  rpf_file.rpf07,
#                       rpfacti   LIKE  rpf_file.rpfacti
#                END RECORD,
#        l_chr           LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#    ORDER BY sr.rpf01
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
#                  g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            IF sr.rpfacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
#            PRINT COLUMN g_c[32],sr.rpf01,
#                  COLUMN g_c[33],sr.rpf02,
#                  COLUMN g_c[34],sr.rpf04 USING '####&.&&';
#                 #MOD-640342-begin
#                  #COLUMN g_c[35],sr.rpf03,
#                  IF sr.rpf03='1' THEN 
#                     PRINT COLUMN g_x[35],g_x[10];
#                   ELSE 
#                     PRINT COLUMN g_x[35],g_x[11];
#                  END IF
#                     #COLUMN g_c[36],sr.rpf06,
#                      PRINT COLUMN g_c[36],sr.rpf06,
#                 #MOD-640342-end
#                  COLUMN g_c[37],sr.rpf07
#                  
#
#        ON LAST ROW
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN PRINT g_dash[1,g_len]
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#            END IF
#            PRINT g_dash[1,g_len] #No.TQC-5C0005
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-770012 -- end --
 
FUNCTION i601_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rpf01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i601_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rpf01",FALSE)
   END IF
END FUNCTION
 


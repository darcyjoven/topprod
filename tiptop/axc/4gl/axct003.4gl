# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axct003.4gl
# Descriptions...: 銷貨收入調整資料維護作業
# Date & Author..: 03/11/27 By Melody (Add For 03/11/18 產品會議)
# Modify.........: No.FUN-4C0005 04/12/02 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.TQC-6A0078 06/11/13 By ice 隱藏cancel功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-980009 09/08/18 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-970213 09/09/25 By baofei 料件主檔不存在時,修改會死循環                                                   
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0059 10/10/27 By vealxu 全系統料號開窗及判斷控卡原則修改
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_can       RECORD LIKE can_file.*,
       g_can_t     RECORD LIKE can_file.*,  #備份舊值
       g_can01_t   LIKE can_file.can01,     #Key值備份
       g_can02_t   LIKE can_file.can02,
       g_can03_t   LIKE can_file.can03,
       g_can04_t   LIKE can_file.can04,
        g_wc        string,              #儲存 user 的查詢條件  #No.FUN-580092 HCN
       g_sql       STRING,                  #組 sql 用
       g_ima       RECORD LIKE ima_file.*
DEFINE g_forupd_sql          STRING         #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #判斷是否已執行 Before Input指令        #No.FUN-680122 SMALLINT
DEFINE g_chr                 LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt                 LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_i                   LIKE type_file.num5         #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_msg                 LIKE ze_file.ze03            #No.FUN-680122CHAR(72)
DEFINE g_curs_index          LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_row_count           LIKE type_file.num10         #總筆數        #No.FUN-680122 INTEGER
DEFINE g_jump                LIKE type_file.num10         #查詢指定的筆數        #No.FUN-680122 INTEGER
DEFINE mi_no_ask             LIKE type_file.num5         #是否開啟指定筆視窗        #No.FUN-680122 SMALLINT
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680122 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0146
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET p_row = ARG_VAL(1)
   LET p_col = ARG_VAL(2)
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   INITIALIZE g_can.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM can_file WHERE can01 = ? AND can02 = ? AND can03 = ? AND can04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t003_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   LET p_row = 5 LET p_col = 10
 
   OPEN WINDOW t003_w AT p_row,p_col WITH FORM "axc/42f/axct003"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   LET g_action_choice = ""
   CALL t003_menu()
 
   CLOSE WINDOW t003_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t003_curs()
DEFINE ls STRING
 
    CLEAR FORM
    INITIALIZE g_can.* TO NULL      #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        can01,can02,can03,can04,can05,can06,
        canuser,canuser,cangrup,canmodu,candate
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(can01)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.default1 = g_can.can01
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_can.can01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY g_qryparam.multiret TO can01
                 NEXT FIELD can01
 
              OTHERWISE
                 EXIT CASE
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
 
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND canuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cangrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cangrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('canuser', 'cangrup')
    #End:FUN-980030
 
    LET g_sql="SELECT can01,can02,can03,can04 FROM can_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY can01"
    PREPARE t003_prepare FROM g_sql
    DECLARE t003_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t003_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM can_file WHERE ",g_wc CLIPPED
    PREPARE t003_precount FROM g_sql
    DECLARE t003_count CURSOR FOR t003_precount
END FUNCTION
 
FUNCTION t003_menu()
 
   DEFINE l_cmd  LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(100)
    MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t003_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t003_q()
            END IF
        ON ACTION next
            CALL t003_fetch('N')
        ON ACTION previous
            CALL t003_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t003_u()
            END IF
     #   ON ACTION invalid
     #       LET g_action_choice="invalid"
     #       IF cl_chk_act_auth() THEN
     #            CALL t003_x()
     #       END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t003_r()
            END IF
    #   ON ACTION reproduce
    #        LET g_action_choice="reproduce"
    #        IF cl_chk_act_auth() THEN
    #             CALL t003_copy()
    #        END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t003_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        #No.TQC-6A0078 --Begin
        #ON ACTION cancel
        #    LET g_action_choice = "exit"
        #    EXIT MENU
        #No.TQC-6A0078 --End
        ON ACTION jump
            CALL t003_fetch('/')
        ON ACTION first
            CALL t003_fetch('F')
        ON ACTION last
            CALL t003_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0019-------add--------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_can.can01 IS NOT NULL THEN
                  LET g_doc.column1 = "can01"
                  LET g_doc.value1 = g_can.can01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0019-------add--------end----
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
           LET g_action_choice = "exit"
           EXIT MENU
 
    END MENU
    CLOSE t003_cs
END FUNCTION
 
 
FUNCTION t003_a()
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_can.* LIKE can_file.*
    LET g_can01_t = NULL
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_can.canuser = g_user
        LET g_can.canoriu = g_user #FUN-980030
        LET g_can.canorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_can.cangrup = g_grup               #使用者所屬群
        LET g_can.candate = g_today
        LET g_can.canacti = 'Y'
       #LET g_can.canplant= g_plant #FUN-980009 add   #FUN-A50075 
        LET g_can.canlegal= g_legal #FUN-980009 add
        CALL t003_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_can.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_can.can01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO can_file VALUES(g_can.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_can.can01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("ins","can_file",g_can.can01,g_can.can02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        ELSE
            SELECT can01,can02,can03,can04 INTO g_can.can01,g_can.can02,g_can.can03,g_can.can04 FROM can_file
                     WHERE can01 = g_can.can01 AND can02 = g_can.can02 AND can03 = g_can.can03 AND can04 = g_can.can04
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t003_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
            l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gen04   LIKE gen_file.gen04,
            l_gem02   LIKE gem_file.gem02,
            l_input   LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
            l_n       LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
 
   DISPLAY BY NAME
      g_can.can01,g_can.can02,g_can.can03,
      g_can.can04,g_can.can05,g_can.can06,
      g_can.canuser,g_can.cangrup,g_can.canmodu,
      g_can.candate
 
   INPUT BY NAME g_can.canoriu,g_can.canorig,
 
      g_can.can01,g_can.can02,g_can.can03,
      g_can.can04,g_can.can05,g_can.can06,
      g_can.canuser,g_can.cangrup,g_can.canmodu,
      g_can.candate
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t003_set_entry(p_cmd)
          CALL t003_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          #No.FUN-550025 --start--
          CALL cl_set_docno_format("can04")
          #No.FUN-550025 ---end---
 
 
     AFTER FIELD can01
           IF NOT cl_null(g_can.can01) THEN
             #FUN-AA0059 --------------------------add start-----------------
              IF NOT s_chk_item_no(g_can.can01,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD can01
              END IF 
             #FUN-AA0059 -----------------------add end---------------------
              SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_can.can01
              IF STATUS THEN
#                CALL cl_err('sel ima:',STATUS,0)    #No.FUN-660127
                 CALL cl_err3("sel","ima_file",g_can.can01,"",STATUS,"","sel ima:",1)  #No.FUN-660127
               IF p_cmd = 'u' AND  g_can.can01 = g_can01_t  THEN          #TQC-970213                                               
               ELSE                                           #TQC-970213                                                           
                 NEXT FIELD can01                                                                                                   
               END IF                                         #TQC-970213  
              END IF
              DISPLAY BY NAME g_ima.ima02,g_ima.ima25
           END IF
 
      AFTER FIELD can04
           IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
             (p_cmd = "u" AND
              (g_can.can01 != g_can01_t OR g_can.can02 != g_can02_t OR
               g_can.can03 != g_can03_t OR g_can.can04 != g_can04_t)) THEN
               SELECT count(*) INTO l_n FROM can_file
               WHERE can01 = g_can.can01 AND can02 = g_can.can02 AND can03 = g_can.can03 AND can04 = g_can.can04 AND can02 = g_can.can02
                 AND can03 = g_can.can03 AND can04 = g_can.can04
               IF l_n > 0 THEN                  # Duplicated
                   CALL cl_err('count:',-239,0)
                   NEXT FIELD can01
               END IF
           END IF
 
      AFTER INPUT
         LET g_can.canuser = s_get_data_owner("can_file") #FUN-C10039
         LET g_can.cangrup = s_get_data_group("can_file") #FUN-C10039
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
      #MOD-650015 --start
      # ON ACTION CONTROLO                        # 沿用所有欄位
      #    IF INFIELD(can01) THEN
      #       LET g_can.* = g_can_t.*
      #       CALL t003_show()
      #       NEXT FIELD can01
      #    END IF
      #MOD-650015 --end
     ON ACTION controlp
        CASE
           WHEN INFIELD(can01)
#FUN-AA0059---------mod------------str-----------------           
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.default1 = g_can.can01
#              CALL cl_create_qry() RETURNING g_can.can01
                 CALL q_sel_ima(FALSE, "q_ima","",g_can.can01,"","","","","",'' ) 
                   RETURNING  g_can.can01
#FUN-AA0059---------mod------------end-----------------
#              CALL FGL_DIALOG_SETBUFFER( g_can.can01 )
              DISPLAY BY NAME g_can.can01
              NEXT FIELD can01
 
           OTHERWISE
              EXIT CASE
           END CASE
 
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
 
FUNCTION t003_can01(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
   l_gen02    LIKE gen_file.gen02,
   l_gen03    LIKE gen_file.gen03,
   l_gen04    LIKE gen_file.gen04,
   l_genacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gen02,gen03,gen04,genacti
     INTO l_gen02,l_gen03,l_gen04,l_genacti
     FROM gen_file
    WHERE gen01=g_can.can01
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='axc-070'
                                LET l_gen02=NULL
                                LET l_gen03=NULL
                                LET l_gen04=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gen03 TO FORMONLY.gen03
      DISPLAY l_gen04 TO FORMONLY.gen04
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=l_gen03
      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION
 
FUNCTION t003_q()
##CKP
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_can.* TO NULL            #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t003_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t003_count
    FETCH t003_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t003_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_can.can01,SQLCA.sqlcode,0)
        INITIALIZE g_can.* TO NULL
    ELSE
        CALL t003_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t003_fetch(p_flcan)
    DEFINE
        p_flcan          LIKE type_file.chr1          #No.FUN-680122CHAR(01)
 
    CASE p_flcan
        WHEN 'N' FETCH NEXT     t003_cs INTO g_can.can01,g_can.can02,g_can.can03,g_can.can04
        WHEN 'P' FETCH PREVIOUS t003_cs INTO g_can.can01,g_can.can02,g_can.can03,g_can.can04
        WHEN 'F' FETCH FIRST    t003_cs INTO g_can.can01,g_can.can02,g_can.can03,g_can.can04
        WHEN 'L' FETCH LAST     t003_cs INTO g_can.can01,g_can.can02,g_can.can03,g_can.can04
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
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
            FETCH ABSOLUTE g_jump t003_cs INTO g_can.can01,g_can.can02,g_can.can03,g_can.can04
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_can.can01,SQLCA.sqlcode,0)
        INITIALIZE g_can.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
      CASE p_flcan
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    SELECT * INTO g_can.* FROM can_file    # 重讀DB,因TEMP有不被更新特性
       WHERE can01 = g_can.can01 AND can02 = g_can.can02 AND can03 = g_can.can03 AND can04 = g_can.can04
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_can.can01,SQLCA.sqlcode,0)   #No.FUN-660127
        CALL cl_err3("sel","can_file",g_can.can01,g_can.can02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
        LET g_data_owner=g_can.canuser           #FUN-4C0061權限控管
        LET g_data_group=g_can.cangrup
       #LET g_data_plant = g_can.canplant #FUN-980030     #FUN-A50075
        LET g_data_plant = g_plant        #FUN-A50075 
        CALL t003_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t003_show()
    LET g_can_t.* = g_can.*
    DISPLAY BY NAME g_can.canoriu,g_can.canorig,
        g_can.can01,g_can.can02,g_can.can03,g_can.can04,g_can.can05,
        g_can.can06,
        g_can.canuser,g_can.cangrup,g_can.canmodu,g_can.candate
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_can.can01
    DISPLAY BY NAME g_ima.ima25,g_ima.ima02
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t003_u()
    IF g_can.can01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_can.* FROM can_file WHERE can01=g_can.can01 AND can02 = g_can.can02 AND can03 = g_can.can03 AND can04 = g_can.can04
    IF g_can.canacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_can01_t = g_can.can01
    LET g_can02_t = g_can.can02
    LET g_can03_t = g_can.can03
    LET g_can04_t = g_can.can04
    BEGIN WORK
 
    OPEN t003_cl USING g_can.can01,g_can.can02,g_can.can03,g_can.can04
    IF STATUS THEN
       CALL cl_err("OPEN t003_cl:", STATUS, 1)
       CLOSE t003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t003_cl INTO g_can.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_can.can01,SQLCA.sqlcode,1)
        RETURN
    END IF
    IF cl_null(g_can.canacti) THEN LET g_can.canacti ='Y' END IF
    IF cl_null(g_can.canuser) THEN LET g_can.canuser = g_user END IF
    IF cl_null(g_can.cangrup) THEN LET g_can.cangrup = g_grup END IF
    LET g_can.canmodu=g_user                     #修改者
    LET g_can.candate = g_today                  #修改日期
    CALL t003_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t003_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_can.*=g_can_t.*
            CALL t003_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE can_file SET can_file.* = g_can.*    # 更新DB
            WHERE can01 = g_can_t.can01 AND can02 = g_can_t.can02 AND can03 = g_can_t.can03 AND can04 = g_can_t.can04
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_can.can01,SQLCA.sqlcode,0)   #No.FUN-660127
            CALL cl_err3("upd","can_file",g_can01_t,g_can02_t,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t003_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t003_r()
    IF g_can.can01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t003_cl USING g_can.can01,g_can.can02,g_can.can03,g_can.can04
    IF STATUS THEN
       CALL cl_err("OPEN t003_cl:", STATUS, 0)
       CLOSE t003_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t003_cl INTO g_can.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_can.can01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t003_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "can01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_can.can01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM can_file WHERE can01 = g_can.can01 AND can02 = g_can.can02 AND can03 = g_can.can03 AND can04 = g_can.can04
       CLEAR FORM
       OPEN t003_count
       FETCH t003_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t003_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t003_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t003_fetch('/')
       END IF
    END IF
    CLOSE t003_cl
    COMMIT WORK
END FUNCTION
FUNCTION t003_out()
    DEFINE
        l_i             LIKE type_file.num5,          #No.FUN-680122 SMALLINT
        l_za05          LIKE type_file.chr1000,       #No.FUN-680122 VARCHAR(40)
        l_can           RECORD LIKE can_file.*,
        l_name          LIKE type_file.chr20,         #No.FUN-680122 VARCHAR(20)          # External(Disk) file name
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
 
    IF g_wc IS NULL THEN
       IF cl_null(g_can.can01) THEN
          CALL cl_err('','9057',0) RETURN
       ELSE
          LET g_wc=" can01='",g_can.can01,"'"
       END IF
       IF NOT cl_null(g_can.can02) THEN
          LET g_wc=g_wc," and can02=",g_can.can02
       END IF
       IF NOT cl_null(g_can.can03) THEN
          LET g_wc=g_wc," and can03=",g_can.can03
       END IF
       IF NOT cl_null(g_can.can04) THEN
          LET g_wc=g_wc," and can04='",g_can.can04,"'"
       END IF
    END IF
    CALL cl_wait()
    CALL cl_outnam('axct003') RETURNING l_name
#   LET l_name = 'axct003.out'
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT can_file.*, ima02,ima25 FROM can_file LEFT OUTER JOIN ima_file ON can01 = ima01  ",
              " WHERE ",g_wc CLIPPED
    PREPARE t003_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t003_co CURSOR FOR t003_p1
 
    START REPORT t003_rep TO l_name
 
    FOREACH t003_co INTO l_can.*, sr.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT t003_rep(l_can.*, sr.*)
    END FOREACH
 
    FINISH REPORT t003_rep
 
    CLOSE t003_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t003_rep(l_can,sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,          #No.FUN-680122CHAR(01)
        l_ima02 LIKE ima_file.ima02,
        l_ima021 LIKE ima_file.ima021,
        l_can RECORD LIKE can_file.*,
        sr RECORD
           ima02 LIKE ima_file.ima02,
           ima25 LIKE ima_file.ima25
           END RECORD
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY l_can.can01,l_can.can02,l_can.can03,l_can.can04
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<','/pageno'
            PRINT g_head CLIPPED,pageno_total
            PRINT
            PRINT g_dash[1,g_len]   #No.TQC-6A0078
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
        ON EVERY ROW
            SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
                WHERE ima01=l_can.can01
            IF SQLCA.sqlcode THEN
                LET l_ima02 = NULL
                LET l_ima021 = NULL
            END IF
 
            PRINT COLUMN g_c[31],l_can.can01,
                  COLUMN g_c[32],l_ima02,
                  COLUMN g_c[33],l_ima021,
                  COLUMN g_c[34],sr.ima25,
                  COLUMN g_c[35],l_can.can02 USING '#####',
                  COLUMN g_c[36],l_can.can03 USING '###',
                  COLUMN g_c[37],l_can.can04,
                  COLUMN g_c[38],l_can.can05,
                  COLUMN g_c[39],cl_numfor(l_can.can06,39,2)
        ON LAST ROW
            PRINT
            PRINT COLUMN g_c[38],g_x[9] CLIPPED,
                  COLUMN g_c[39],cl_numfor(SUM(l_can.can06),39,2)
            PRINT g_dash[1,g_len]   #No.TQC-6A0078
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[39], g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]   #No.TQC-6A0078
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[39], g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
FUNCTION t003_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("can01,can02,can03,can04",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION t003_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("can01,can02,can03,can04",FALSE)
    END IF
 
END FUNCTION


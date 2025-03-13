# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aws_efcfg.4gl
# Descriptions...: EF 整合設定作業
# Date & Author..: 92/04/14 By Brendan
# Modify.........: No.MOD-490275 04/10/15 By Echo aws_efcfg 設定作業需新增一指定系統別名稱的欄位
# Modify.........: No.MOD-4B0059 04/11/19 By Echo M維護單頭資料,D維護單身資料 會有 null 的資料進入,之後會造成維護時有問題
# Modify.........: No.FUN-550075 05/05/18 By Echo 新增EasyFlow站台設定
# Modify.........: No.MOD-560086 05/06/14 by echo 修改controlf欄位說明
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能 monster代
# Modify.........: No.FUN-660155 06/06/22 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680130 06/09/01 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0075 06/10/26 By Xumin g_no_ask 改為mi_no_ask     
# Modify.........: No.FUN-6A0091 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740155 07/04/26 By kim zz02以gaz03取代
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860022 08/06/10 By Echo 調整程式遺漏 ON IDLE 程式段
# Modify.........: No.FUN-940135 09/04/29 By Carrier 去掉顏色的ATTRIBUTE設置
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/13 By destiny display xxx.*改為display對應欄位
# Modify.........: No.FUN-A90024 10/11/15 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90032 11/09/05 By minpp 程序撰写规范修改 
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/awsef.4gl"
DEFINE
   g_wsa     RECORD LIKE wsa_file.*,
   g_wsj     RECORD LIKE wsj_file.*,
   g_wsa_t   RECORD LIKE wsa_file.*,
   g_wsj_t   RECORD LIKE wsj_file.*,
   g_wsj_o   RECORD LIKE wsj_file.*,
   g_wsa01_t LIKE wsa_file.wsa01,
   g_wc,g_sql,g_beforeinput  STRING,
   g_row_cnt        LIKE type_file.num10           #No.FUN-680130 INTEGER
DEFINE g_cnt LIKE type_file.num10                   #No.FUN-680130 INTEGER
DEFINE
    g_wsb          DYNAMIC ARRAY of RECORD    #程式變數(Program Variables)
        wsb03       LIKE wsb_file.wsb03,
        wsb04       LIKE wsb_file.wsb04
                    END RECORD,
    g_wsb_t         RECORD                 #程式變數 (舊值)
        wsb03       LIKE wsb_file.wsb03,
        wsb04       LIKE wsb_file.wsb04
                    END RECORD,
    g_rec_b         LIKE type_file.num5,                #單身筆數                   #No.FUN-680130 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680130 SMALLINT
    g_forupd_sql    STRING
DEFINE mi_no_ask    LIKE type_file.num5                #是否開啟指定筆視窗          #No.FUN-680130 SMALLINT   #No.FUN-6A0075
DEFINE g_jump       LIKE type_file.num10                #查詢指定的筆數             #No.FUN-680130 INTEGER
DEFINE g_curs_index LIKE type_file.num10                #計算筆數給是否隱藏toolbar按鈕用#No.FUN-680130 INTEGER
DEFINE g_row_count  LIKE type_file.num10                 #總筆數計算                #No.FUN-680130 INTEGER
DEFINE g_zz02       STRING
DEFINE g_bwsj  DYNAMIC ARRAY OF RECORD
     bwsj06  LIKE wsj_file.wsj06,
     bwsj04  LIKE wsj_file.wsj04,
     bwsj02  LIKE wsj_file.wsj02,
     bwsj03  LIKE wsj_file.wsj03
     END RECORD
DEFINE g_exc_cnt LIKE type_file.num10   #No.FUN-680130 INTEGER
 
 #### MOD-490275 ####
 
DEFINE g_wsa15      STRING
DEFINE g_channel     base.Channel,
       g_cmd         STRING
 
 #### END MOD-490275 ####
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680130 SMALLINT
#       l_time          LIKE type_file.chr8          #No.FUN-680130 VARCHAR(8) #No.FUN-6A0091
     DEFINE l_wsa15      LIKE wsa_file.wsa15      #MOD-490275
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT                            #擷取中斷鍵
 
    LET p_row = ARG_VAL(1)
    LET p_col = ARG_VAL(2)
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AWS")) THEN
       EXIT PROGRAM
    END IF
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
    INITIALIZE g_wsa.* TO NULL
 
    LET g_forupd_sql= "SELECT * FROM wsa_file WHERE wsa01 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE efcfg_cl CURSOR FROM g_forupd_sql
  # DECLARE efcfg_cl CURSOR FOR                 # LOCK CURSOR
  #     SELECT * FROM wsa_file
  #     WHERE wsa01 = g_wsa.wsa01
  #     FOR UPDATE
 
    IF cl_fglgui() MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 4 LET p_col = 6
    ELSE LET p_row = 4 LET p_col = 8
    END IF
 
    OPEN WINDOW efcfg_w AT p_row,p_col
        WITH FORM "aws/42f/aws_efcfg" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
 #MOD-490275
   #-----指定combo wsa15的值-------------#
   LET g_wsa15=""
   DECLARE p_wsa15_cur CURSOR FOR SELECT gao01 FROM gao_file
   FOREACH p_wsa15_cur INTO l_wsa15
      IF cl_null(g_wsa15) THEN
         LET g_wsa15=l_wsa15
      ELSE
         LET g_wsa15=g_wsa15 CLIPPED,",",l_wsa15 CLIPPED
      END IF
   END FOREACH
 
   CALL cl_set_combo_items("wsa15",g_wsa15,g_wsa15)
   #-------------------------------------#
#--
    CALL efcfg_menu()
 
    CLOSE WINDOW efcfg_w
 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #No.FUN-6A0091
END MAIN
 
FUNCTION efcfg_curs()
    CLEAR FORM
   INITIALIZE g_wsa.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取條件
        wsa01,wsa02,wsa03,wsa04,wsa05,wsa06,wsa07,
        wsa08,wsa09,wsa10,wsa11,wsa12,wsa13,wsa14,
        wsauser,wsagrup,wsamodu,wsadate,wsaacti
 
        BEFORE CONSTRUCT
            CALL cl_set_action_active("controlp", FALSE)
 
        BEFORE FIELD wsa01
            CALL cl_set_action_active("controlp", TRUE)
 
        AFTER FIELD wsa01
            CALL cl_set_action_active("controlp", FALSE)
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsa01)
                  CALL cl_init_qry_var()
                 # LET g_wsa.wsa01 = fgl_dialog_getbuffer()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_wsa.wsa01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO wsa01
                  NEXT FIELD wsa01
 
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
 
 
    END CONSTRUCT
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND wsauser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND wsagrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND wsagrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('wsauser', 'wsagrup')
    #End:FUN-980030
 
    LET g_sql="SELECT wsa01 FROM wsa_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY wsa01"
    PREPARE efcfg_prepare FROM g_sql
    DECLARE efcfg_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR efcfg_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM wsa_file WHERE ",g_wc CLIPPED
    PREPARE efcfg_precount FROM g_sql
    DECLARE efcfg_count CURSOR FOR efcfg_precount
END FUNCTION
 
FUNCTION efcfg_menu()
 
    MENU ""
        BEFORE MENU
            CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        LET g_action_choice = ""
 
       ON ACTION insert
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
                 CALL efcfg_a()
            END IF
        ON ACTION query
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
                 CALL efcfg_q()
            END IF
        ON ACTION previous
            CALL efcfg_fetch('P')
        ON ACTION next
            CALL efcfg_fetch('N')
        ON ACTION first
            CALL efcfg_fetch('F')
        ON ACTION last
            CALL efcfg_fetch('L')
        ON ACTION jump
            CALL efcfg_fetch('/')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL efcfg_u()
            END IF
        ON ACTION masfield
            CALL efcfg_h()
        ON ACTION detailfield
            CALL efcfg_d()
 
{
        COMMAND "X.無效"
            IF cl_prich3(g_wsa.wsauser,g_wsa.wsagrup,'X') THEN
                 CALL efcfg_x()
            END IF
}
{
        COMMAND "S.單筆傳送欄位資訊"
            CALL aws_efcol('S', g_wsa.wsa01)
}
        ON ACTION delete
           LET g_action_choice = "delete"
           IF cl_chk_act_auth() THEN
                 CALL efcfg_r()
            END IF
        ON ACTION reproduce
            LET g_action_choice = "reproduce"
            IF cl_chk_act_auth() THEN
                 CALL efcfg_copy()
            END IF
 
        ON ACTION help
            CALL cl_show_help()
 
        ON ACTION traninfo
            CALL aws_efcol('W', g_wsa.wsa01)
 
        ON ACTION proex
 
 ##### MOD-490275 #####
          #  LET g_cmd = "ls ", "aws_",g_wsa.wsa01 CLIPPED,".4gl"
          #  RUN g_cmd
            LET g_channel = base.Channel.create()
            LET g_cmd = "wc -l ", fgl_getenv('AWS') CLIPPED, "/4gl/aws_", g_wsa.wsa01 CLIPPED, ".4gl" , " | awk ' { print $1 }'"
            CALL g_channel.openPipe(g_cmd, "r")
            WHILE g_channel.read(g_row_cnt)
            END WHILE
            CALL g_channel.close()
 
            IF g_row_cnt = 0  THEN
               CALL aws_eftpl(g_wsa.wsa01)
            ELSE
               IF (cl_confirm("aws-070")) THEN
                  CALL aws_eftpl(g_wsa.wsa01)
               ELSE
                  CONTINUE MENU
               END IF
           END IF
 ##### END MOD-490275 #####
        ON ACTION EFstation                      #FUN-550075
           LET g_action_choice = "EFstation"
           IF cl_chk_act_auth() THEN
               CALL aws_efcfg_station()
           END IF
 
        ON ACTION exit
            EXIT MENU
 
        ON ACTION controlg
            CALL cl_cmdask()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            EXIT MENU
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
    END MENU
    CLOSE efcfg_cs
END FUNCTION
 
FUNCTION efcfg_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE " "
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_wsa.* LIKE wsa_file.*
    LET g_wsa01_t = NULL
    LET g_wc = NULL #因為BugNO:4137的原故所以在此要讓g_wc變回NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_wsa.wsauser = g_user
        LET g_wsa.wsagrup = g_grup               #使用者所屬群
        LET g_wsa.wsadate = g_today
        LET g_wsa.wsaacti = 'Y'
        CALL efcfg_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_wsa.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_wsa.wsa01 IS NULL THEN              # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_wsa.wsaoriu = g_user      #No.FUN-980030 10/01/04
        LET g_wsa.wsaorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO wsa_file VALUES(g_wsa.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("ins","wsa_file",g_wsa.wsa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        ELSE
            SELECT wsa01 INTO g_wsa.wsa01 FROM wsa_file
                     WHERE wsa01 = g_wsa.wsa01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION efcfg_i(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,          #No.FUN-680130 VARCHAR(1)
           l_cnt	LIKE type_file.num5,          #No.FUN-680130 SMALLINT
	   l_zz02	LIKE zz_file.zz02
    MESSAGE ""
    DISPLAY BY NAME
        g_wsa.wsa01,g_wsa.wsa02,g_wsa.wsa03,
        g_wsa.wsa04,g_wsa.wsa05,g_wsa.wsa06,
        g_wsa.wsa07,g_wsa.wsa08,g_wsa.wsa09,
        g_wsa.wsa10,g_wsa.wsa11,g_wsa.wsa15,
         g_wsa.wsa12,g_wsa.wsa13,g_wsa.wsa14,            #MOD-490275
        g_wsa.wsauser,g_wsa.wsagrup,g_wsa.wsamodu,
        g_wsa.wsadate,g_wsa.wsaacti,
        g_wsa.wsaoriu,g_wsa.wsaorig                      #No.FUN-9A0024
#       ATTRIBUTE(BLACK)
 
    INPUT BY NAME
        g_wsa.wsa01,g_wsa.wsa02,g_wsa.wsa03,
        g_wsa.wsa04,g_wsa.wsa05,g_wsa.wsa06,
        g_wsa.wsa07,g_wsa.wsa08,g_wsa.wsa09,
        g_wsa.wsa10,g_wsa.wsa11,g_wsa.wsa15,
         g_wsa.wsa12,g_wsa.wsa13,g_wsa.wsa14,            #MOD-490275
        g_wsa.wsauser,g_wsa.wsagrup,g_wsa.wsamodu,
        g_wsa.wsadate,g_wsa.wsaacti
        WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
 
        BEFORE INPUT
 
             #### MOD-490275 ####
 
            LET g_beforeinput="false"
            CALL efcfg_set_no_entry()
            LET g_beforeinput="true"
 
             #### END MOD-490275 ####
        BEFORE FIELD wsa01
            IF p_cmd = 'u' AND g_chkey = 'N' THEN
               NEXT FIELD wsa02
            END IF
 
        AFTER FIELD wsa01
            IF g_wsa.wsa01 IS NULL THEN
              DISPLAY '' TO FORMONLY.zz02
              NEXT FIELD wsa01
            END IF
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_wsa.wsa01 != g_wsa01_t) THEN
               SELECT zz01 FROM zz_file WHERE zz01 = g_wsa.wsa01
               IF SQLCA.SQLCODE THEN
                 CALL cl_err(g_wsa.wsa01,NOTFOUND,0)   
                  DISPLAY '' TO FORMONLY.zz02
                  NEXT FIELD wsa01
               END IF
               SELECT COUNT(*) INTO l_cnt FROM wsa_file WHERE wsa01 = g_wsa.wsa01
               IF l_cnt > 0 THEN                  # Duplicated
                  CALL cl_err(g_wsa.wsa01,-239,0)
                  DISPLAY '' TO FORMONLY.zz02
                  NEXT FIELD wsa01
               END IF
               CALL efcfg_zz02(g_wsa.wsa01)
            END IF
 
        ON CHANGE wsa02
            LET g_wsa.wsa03 = NULL
            LET g_wsa.wsa04 = NULL
 
        AFTER FIELD wsa02
            IF g_wsa.wsa02 IS NOT NULL THEN
               IF NOT efcfg_tab(g_wsa.wsa02) THEN NEXT FIELD wsa02 END IF
               IF (g_wsa.wsa02 = g_wsa.wsa05) OR (g_wsa.wsa02 = g_wsa.wsa08)
                THEN
                     CALL cl_err(g_wsa.wsa02,-239,0)
                     NEXT FIELD wsa02 END IF
            ELSE
               NEXT FIELD wsa02
            END IF
 
        BEFORE FIELD wsa03, wsa04
            IF g_wsa.wsa02 IS NULL THEN
               CALL cl_err(NULL,"aws-067", 0)
               NEXT FIELD wsa02
            END IF
 
        AFTER FIELD wsa03
            IF g_wsa.wsa03 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa03,g_wsa.wsa02) THEN NEXT FIELD wsa03 END IF
               IF g_wsa.wsa03 = g_wsa.wsa04
                THEN
                     CALL cl_err(g_wsa.wsa03,-239,0)
                     NEXT FIELD wsa03 END IF
            ELSE
               NEXT FIELD wsa03
            END IF
 
        AFTER FIELD wsa04
            IF g_wsa.wsa04 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa04,g_wsa.wsa02) THEN NEXT FIELD wsa04 END IF
               IF g_wsa.wsa03 = g_wsa.wsa04
                THEN
                     CALL cl_err(g_wsa.wsa04,-239,0)
                     NEXT FIELD wsa04 END IF
            ELSE
               NEXT FIELD wsa04
            END IF
 
        BEFORE FIELD wsa05
            CALL efcfg_set_entry()
 
        ON CHANGE wsa05
 
            LET g_wsa.wsa06 = NULL
            LET g_wsa.wsa07 = NULL
 
 
        AFTER FIELD wsa05
            IF g_wsa.wsa05 IS NOT NULL THEN
               IF NOT efcfg_tab(g_wsa.wsa05) THEN NEXT FIELD wsa05 END IF
 
               IF (g_wsa.wsa05 = g_wsa.wsa02) OR (g_wsa.wsa05 = g_wsa.wsa08)
                THEN
                     CALL cl_err(g_wsa.wsa02,-239,0)
                     NEXT FIELD wsa05
                END IF
        #### MOD-490275 ####
             ELSE
               CALL efcfg_set_no_entry()
               #NEXT FIELD wsa08
 
            END IF
        #### END MOD-490275 ####
 
        AFTER FIELD wsa06
            IF g_wsa.wsa06 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa06,g_wsa.wsa05) THEN NEXT FIELD wsa06 END IF
               IF g_wsa.wsa06 = g_wsa.wsa07
                THEN
                     CALL cl_err(g_wsa.wsa06,-239,0)
                     NEXT FIELD wsa06 END IF
            END IF
 
        AFTER FIELD wsa07
            IF g_wsa.wsa07 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa07,g_wsa.wsa05) THEN NEXT FIELD wsa07 END IF
               IF g_wsa.wsa07 = g_wsa.wsa06
                THEN
                     CALL cl_err(g_wsa.wsa07,-239,0)
                     NEXT FIELD wsa07 END IF
            END IF
 
        ON CHANGE wsa08
                 LET g_wsa.wsa09 = NULL
                 LET g_wsa.wsa10 = NULL
                 LET g_wsa.wsa11 = NULL
                 LET g_wsa.wsa12 = NULL
                 LET g_wsa.wsa13 = NULL
                 LET g_wsa.wsa14 = NULL
 
       AFTER FIELD wsa08
            IF g_wsa.wsa08 IS NOT NULL THEN
               IF NOT efcfg_tab(g_wsa.wsa08) THEN NEXT FIELD wsa08 END IF
               IF (g_wsa.wsa08 = g_wsa.wsa05) OR (g_wsa.wsa08 = g_wsa.wsa02)
                THEN
                     CALL cl_err(g_wsa.wsa02,-239,0)
                     NEXT FIELD wsa08
                END IF
            ELSE
               NEXT FIELD wsa08
            END IF
 
         BEFORE FIELD wsa09, wsa10, wsa12, wsa13          #MOD-490275
            IF g_wsa.wsa08 IS NULL THEN
               CALL cl_err(NULL,"aws-069", 0)
               NEXT FIELD wsa08
            END IF
 
        AFTER FIELD wsa09
            IF g_wsa.wsa09 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa09,g_wsa.wsa08) THEN NEXT FIELD wsa09 END IF
               IF (g_wsa.wsa09 = g_wsa.wsa10) OR (g_wsa.wsa09 = g_wsa.wsa11) OR
                  (g_wsa.wsa09 = g_wsa.wsa12) OR (g_wsa.wsa09 = g_wsa.wsa14)
                THEN
 
                     CALL cl_err(g_wsa.wsa09,-239,0)
                     NEXT FIELD wsa09 END IF
            ELSE
               NEXT FIELD wsa09
            END IF
 
        AFTER FIELD wsa10
            IF g_wsa.wsa10 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa10,g_wsa.wsa08) THEN NEXT FIELD wsa10 END IF
               IF (g_wsa.wsa10 = g_wsa.wsa09) OR (g_wsa.wsa10 = g_wsa.wsa11) OR
                  (g_wsa.wsa10 = g_wsa.wsa12) OR (g_wsa.wsa10 = g_wsa.wsa14)
               THEN
 
                     CALL cl_err(g_wsa.wsa07,-239,0)
                      NEXT FIELD wsa10 END IF               #MOD-490275
            ELSE
               NEXT FIELD wsa10
            END IF
 
         ##### MOD-490275 #####
        BEFORE FIELD wsa11
            CALL efcfg_set_entry()
 
        ON CHANGE wsa11
            IF NOT cl_null(g_wsa.wsa11) THEN
               NEXT FIELD wsa15
            ELSE
               LET g_wsa.wsa15 = NULL
            END IF
 
        AFTER FIELD wsa11
            IF g_wsa.wsa11 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa11,g_wsa.wsa08) THEN NEXT FIELD wsa11 END IF
               IF (g_wsa.wsa11 = g_wsa.wsa09) OR (g_wsa.wsa11 = g_wsa.wsa10) OR
                  (g_wsa.wsa11 = g_wsa.wsa12 ) OR (g_wsa.wsa11 = g_wsa.wsa14)
               THEN
                  CALL cl_err(g_wsa.wsa11,-239,0)
                  NEXT FIELD wsa11
               ELSE
                  CALL cl_set_comp_required("wsa15", TRUE)
               END IF
            ELSE
               CALL cl_set_comp_required("wsa15", FALSE)
               CALL efcfg_set_no_entry()
            END IF
         #### END MOD-490275 ####
 
        AFTER FIELD wsa15
            IF cl_null(g_wsa.wsa15) THEN
               IF NOT cl_null(g_wsa.wsa11) THEN
                  NEXT FIELD wsa15
               END IF
            END IF
 
        AFTER FIELD wsa12
            IF g_wsa.wsa12 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa12,g_wsa.wsa08) THEN NEXT FIELD wsa12 END IF
               IF (g_wsa.wsa12 = g_wsa.wsa09) OR (g_wsa.wsa12 = g_wsa.wsa10) OR
                  (g_wsa.wsa12 = g_wsa.wsa11 ) OR (g_wsa.wsa12 = g_wsa.wsa14)
                THEN
 
                     CALL cl_err(g_wsa.wsa12,-239,0)
                     NEXT FIELD wsa12 END IF
            ELSE
               NEXT FIELD wsa12
            END IF
 
        AFTER FIELD wsa13
            IF g_wsa.wsa13 IS NOT NULL THEN
               LET g_sql = "SELECT COUNT(*) FROM ",
                           g_wsa.wsa08 CLIPPED,
                           " WHERE"
               IF g_wsa.wsa11 IS NOT NULL THEN
                   #MOD-490275
                  LET g_sql = g_sql CLIPPED, " ",
                              g_wsa.wsa11 CLIPPED, " = '", DOWNSHIFT(g_wsa.wsa15 CLIPPED), "'",
                              " AND"
                  #--
               END IF
               LET g_sql = g_sql CLIPPED, " ",
                           g_wsa.wsa12 CLIPPED, " = '", g_wsa.wsa13 CLIPPED, "'"
               PREPARE efcfg_prepare1 FROM g_sql
               EXECUTE efcfg_prepare1 INTO l_cnt
               IF l_cnt = 0 THEN
                  CALL cl_err(g_wsa.wsa13,NOTFOUND,0)
                  NEXT FIELD wsa13
               END IF
            ELSE
               NEXT FIELD wsa13
            END IF
 
        AFTER FIELD wsa14
            IF g_wsa.wsa14 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsa.wsa14,g_wsa.wsa08) THEN NEXT FIELD wsa14 END IF
               IF (g_wsa.wsa14 = g_wsa.wsa09) OR (g_wsa.wsa14 = g_wsa.wsa10) OR
                  (g_wsa.wsa14 = g_wsa.wsa11 ) OR (g_wsa.wsa14 = g_wsa.wsa12)
                THEN
                     CALL cl_err(g_wsa.wsa14,-239,0)
                     NEXT FIELD wsa14 END IF
            ELSE
               NEXT FIELD wsa14
            END IF
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsa01)
                  CALL cl_init_qry_var()
                 # LET g_wsa.wsa01 = fgl_dialog_getbuffer()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.default1 = g_wsa.wsa01
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa01,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa01
                  DISPLAY g_zz02 TO FORMONLY.zz02
                 # NEXT FIELD wsa01
 
                WHEN INFIELD(wsa02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsa.wsa02
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa02,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa02
                  DISPLAY g_zz02 TO FORMONLY.zz03
                 # NEXT FIELD wsa02
 
                WHEN INFIELD(wsa03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa03
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa02 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa03,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa03
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa03
 
	       WHEN INFIELD(wsa04)
	          CALL cl_init_qry_var()
	          LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa04
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa02 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa04,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa04
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa04
 
 
               WHEN INFIELD(wsa05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsa.wsa05
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa05,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa05
                  DISPLAY g_zz02 TO FORMONLY.zz04
                 # NEXT FIELD wsa05
 
	       WHEN INFIELD(wsa06)
	          CALL cl_init_qry_var()
	          LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa06
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa05 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa06,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa06
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa06
 
               WHEN INFIELD(wsa07)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa07
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa05 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa07,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa07
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa07
 
             WHEN INFIELD(wsa08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_zta"
                  LET g_qryparam.default1 = g_wsa.wsa08
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa08,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa08
                  DISPLAY g_zz02 TO FORMONLY.zz05
                 # NEXT FIELD wsa08
 
             WHEN INFIELD(wsa09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa09
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa08 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa09,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa09
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa09
 
             WHEN INFIELD(wsa10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa10
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa08 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa10,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa10
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa10
 
             WHEN INFIELD(wsa11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa11
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa08 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa11,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa11
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa11
 
             WHEN INFIELD(wsa12)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa12
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa08 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa12,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa09
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa12
 
             WHEN INFIELD(wsa14)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsa.wsa14
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa08 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsa.wsa14,g_zz02
 
                  DISPLAY BY NAME g_wsa.wsa14
                #  DISPLAY g_zz02 TO FORMONLY.zz03
                #  NEXT FIELD wsa14
 
             OTHERWISE
                  EXIT CASE
 
            END CASE
 
        #-----MOD-650015---------
        # ON ACTION controlo                        # 沿用所有欄位
        #     IF INFIELD(wsa01) THEN
        #         LET g_wsa.* = g_wsa_t.*
        #         CALL efcfg_show()
        #         NEXT FIELD wsa01
        #     END IF
        #-----MOD-650015---------
       
        ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION controlf                        # 欄位說明   #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         #TQC-860022
         ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
         #END TQC-860022
 
    END INPUT
END FUNCTION
 
FUNCTION efcfg_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
 
 
    CALL efcfg_curs()                      # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
 
    OPEN efcfg_count
    FETCH efcfg_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt #ATTRIBUTE(MAGENTA)
 
    OPEN efcfg_cs                          # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)
        INITIALIZE g_wsa.* TO NULL
    ELSE
        CALL efcfg_fetch('F')              # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION efcfg_fetch(p_flwsa)
    DEFINE
        p_flwsa          LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
    CASE p_flwsa
        WHEN 'N' FETCH NEXT     efcfg_cs INTO g_wsa.wsa01
        WHEN 'P' FETCH PREVIOUS efcfg_cs INTO g_wsa.wsa01
        WHEN 'F' FETCH FIRST    efcfg_cs INTO g_wsa.wsa01
        WHEN 'L' FETCH LAST     efcfg_cs INTO g_wsa.wsa01
        WHEN '/'
          IF (NOT mi_no_ask) THEN   #No.FUN-6A0075
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
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
 
          FETCH ABSOLUTE g_jump efcfg_cs INTO g_wsa.wsa01
          LET mi_no_ask = FALSE   #No.FUN-6A0075
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)
        INITIALIZE g_wsa.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
        CASE p_flwsa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
        END CASE
        CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    END IF
 
    SELECT * INTO g_wsa.* FROM wsa_file    # 重讀DB,因TEMP有不被更新特性
       WHERE wsa01 = g_wsa.wsa01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("sel","wsa_file",g_wsa.wsa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
    ELSE
        CALL efcfg_show()                   # 重新顯示
    END IF
END FUNCTION
 
FUNCTION efcfg_show()
    LET g_wsa_t.* = g_wsa.*
    #No.FUN-9A0024--begin
    #DISPLAY BY NAME g_wsa.*
    DISPLAY BY NAME g_wsa.wsa01,g_wsa.wsa02,g_wsa.wsa03,g_wsa.wsa04,g_wsa.wsa05,g_wsa.wsa06,
                    g_wsa.wsa07,g_wsa.wsa08,g_wsa.wsa09,g_wsa.wsa10,g_wsa.wsa11,g_wsa.wsa15,
                    g_wsa.wsa12,g_wsa.wsa13,g_wsa.wsa14,g_wsa.wsauser,g_wsa.wsagrup,g_wsa.wsamodu,
                    g_wsa.wsadate,g_wsa.wsaacti,g_wsa.wsaoriu,g_wsa.wsaorig  
    #No.FUN-9A0024--end                        
    CALL efcfg_zz02(g_wsa.wsa01)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION efcfg_zz02(p_wsa01)
   #DEFINE l_zz02 LIKE zz_file.zz02 #TQC-740155
    DEFINE p_wsa01 LIKE wsa_file.wsa01
   #SELECT zz02 INTO l_zz02 FROM zz_file WHERE zz01 = p_wsa01 #TQC-740155
   #DISPLAY l_zz02 TO FORMONLY.zz02 #TQC-740155
    DISPLAY cl_get_progdesc(p_wsa01,g_lang) TO FORMONLY.zz02
END FUNCTION
 
FUNCTION efcfg_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_wsa.wsa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_wsa.* FROM wsa_file WHERE wsa01=g_wsa.wsa01
    IF g_wsa.wsaacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_wsa01_t = g_wsa.wsa01
    BEGIN WORK
 
    OPEN efcfg_cl USING  g_wsa.wsa01
 
    FETCH efcfg_cl INTO g_wsa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)
        CLOSE efcfg_cl
        RETURN
    END IF
    LET g_wsa.wsamodu=g_user                  #修改者
    LET g_wsa.wsadate = g_today               #修改日期
    CALL efcfg_show()                          # 顯示最新資料
    WHILE TRUE
        CALL efcfg_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_wsa.*=g_wsa_t.*
            CALL efcfg_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE wsa_file SET wsa_file.* = g_wsa.*    # 更新DB
            WHERE wsa01 = g_wsa.wsa01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsa_file",g_wsa01_t,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE efcfg_cl
    COMMIT WORK
END FUNCTION
 
{
FUNCTION efcfg_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_wsa.wsa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN efcfg_cl USING  g_wsa.wsa01
 
    FETCH efcfg_cl INTO g_wsa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL efcfg_show()
    IF cl_exp(0,0,g_wsa.wsaacti) THEN
        LET g_chr=g_wsa.wsaacti
        IF g_wsa.wsaacti='Y' THEN
            LET g_wsa.wsaacti='N'
        ELSE
            LET g_wsa.wsaacti='Y'
        END IF
        UPDATE wsa_file
            SET wsaacti=g_wsa.wsaacti
            WHERE wsa01=g_wsa.wsa01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)   #No.FUN-660155
            CALL cl_err3("upd","wsa_file",g_wsa.wsa01,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
            LET g_wsa.wsaacti=g_chr
        END IF
        DISPLAY BY NAME g_wsa.wsaacti #ATTRIBUTE(RED)    #No.FUN-940135
    END IF
    CLOSE efcfg_cl
    COMMIT WORK
END FUNCTION
}
 
FUNCTION efcfg_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_wsa.wsa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN efcfg_cl USING  g_wsa.wsa01
 
    FETCH efcfg_cl INTO g_wsa.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_wsa.wsa01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    CALL efcfg_show()
    IF cl_delete() THEN
       DELETE FROM wsa_file WHERE wsa01 = g_wsa.wsa01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsa: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsa_file",g_wsa.wsa01,"",SQLCA.sqlcode,"","del wsa:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
       DELETE FROM wsb_file WHERE wsb01 = g_wsa.wsa01
       IF SQLCA.SQLCODE THEN
#         CALL cl_err('del wsb: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
          CALL cl_err3("del","wsb_file",g_wsa.wsa01,"",SQLCA.sqlcode,"","del wsb:", 0)   #No.FUN-660155)   #No.FUN-660155
          ROLLBACK WORK
          RETURN
       END IF
 
       CLEAR FORM
 
       OPEN efcfg_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE efcfg_cs
          CLOSE efcfg_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       FETCH efcfg_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE efcfg_cs
          CLOSE efcfg_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
 
       OPEN efcfg_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL efcfg_fetch('L')
       ELSE
          Let g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0075
          CALL efcfg_fetch('/')
       END IF
    END IF
    CLOSE efcfg_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION efcfg_tab(p_tabname)
    DEFINE p_tabname	LIKE type_file.chr20,        #No.FUN-680130 VARCHAR(20)
           l_cnt	LIKE type_file.num5          #No.FUN-680130 SMALLINT

    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構 
    #CASE cl_db_get_database_type()
    #  WHEN "ORA"
    #      SELECT COUNT(*) INTO l_cnt FROM USER_TABLES WHERE
    #      TABLE_NAME = UPPER(p_tabname)
    #  WHEN "IFX"
    #       SELECT COUNT(*) INTO l_cnt FROM systables
    #        WHERE tabname = p_tabname
    #END CASE
    SELECT COUNT(*) INTO l_cnt FROM sch_file 
      WHERE sch01 = p_tabname
    #---FUN-A90024---end-------  
 
    IF l_cnt = 0 THEN
       CALL cl_err(p_tabname,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION efcfg_col(p_colname,p_tabname)
    DEFINE p_tabname    LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           p_colname	LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(20)
           l_cnt	LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
    IF p_tabname IS NULL THEN
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構 
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM USER_TAB_COLUMNS
      #   WHERE COLUMN_NAME = UPPER(p_colname)
      # 
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM USER_TAB_COLUMNS WHERE COLUMN_NAME = UPPER(p_colname)
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch02 = p_colname
      #---FUN-A90024---end-------
    ELSE
      #---FUN-A90024---start-----
      #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
      #目前統一用sch_file紀錄TIPTOP資料結構 
      #CASE cl_db_get_database_type()
      #WHEN "ORA"
      #   SELECT COUNT(*) INTO l_cnt FROM USER_TAB_COLUMNS
      #   WHERE TABLE_NAME = UPPER(p_tabname) AND COLUMN_NAME = UPPER(p_colname)
      # 
      #WHEN "IFX"
      #   SELECT COUNT(*) INTO l_cnt FROM syscolumns col, systables tab
      #   WHERE tab.tabname =  p_tabname AND tab.tabid = col.tabid
      #   AND colname = p_colname
      #END CASE
      SELECT COUNT(*) INTO l_cnt FROM sch_file
        WHERE sch01 = p_tabname AND sch02 = p_colname
      #---FUN-A90024---end-------
    END IF
   # SELECT COUNT(*) INTO l_cnt FROM USER_TAB_COLUMNS WHERE COLUMN_NAME = UPPER(p_colname)
    IF l_cnt = 0 THEN
       CALL cl_err(p_colname,NOTFOUND,0)
       RETURN 0
    ELSE
       RETURN 1
    END IF
END FUNCTION
 
FUNCTION efcfg_h()
    IF g_wsa.wsa01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_wsa.wsa02 IS NULL THEN
       CALL cl_err(NULL,"aws-067",0)
       RETURN
    END IF
    OPEN WINDOW efcfg_w1 AT 4, 16
        WITH FORM "aws/42f/aws_efcfg1" ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL efcfg_b_fill('1')
    CALL efcfg_b('1')
 
    CLOSE WINDOW efcfg_w1
END FUNCTION
 
FUNCTION efcfg_d()
    IF g_wsa.wsa01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF g_wsa.wsa05 IS NULL THEN
       CALL cl_err(NULL,"aws-068",0)
       RETURN
    END IF
    OPEN WINDOW efcfg_w1 AT 4, 16
        WITH FORM "aws/42f/aws_efcfg1" ATTRIBUTE(STYLE = g_win_style)
 
 
    CALL cl_ui_init()
    CALL efcfg_b_fill('2')
    CALL efcfg_b('2')
 
    CLOSE WINDOW efcfg_w1
END FUNCTION
 
FUNCTION efcfg_b_fill(p_wsb02)             #BODY FILL UP
DEFINE
    p_wsb02    LIKE wsb_file.wsb02  #No.FUN-680130 VARCHAR(1)
 
    LET g_sql =
        "SELECT wsb03,wsb04",
        " FROM wsb_file",
        " WHERE wsb01 = '", g_wsa.wsa01 CLIPPED, "'",                  #單身
        "   AND wsb02 = '", p_wsb02, "'",
        " ORDER BY wsb03"
    PREPARE efcfg_pb FROM g_sql
    DECLARE efcfg_curs CURSOR FOR efcfg_pb
 
    CALL g_wsb.clear() #單身 ARRAY 乾洗
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH efcfg_curs INTO g_wsb[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_wsb.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
FUNCTION efcfg_b(p_wsb02)
DEFINE
    l_ac_t          LIKE type_file.num5,   #No.FUN-680130 SMALLINT
    l_n             LIKE type_file.num5,   #No.FUN-680130 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      #No.FUN-680130 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態        #No.FUN-680130 VARCHAR(1)
    p_wsb02	    LIKE wsb_file.wsb02,   #No.FUN-680130 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否     #No.FUN-680130 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1    #可刪除否     #No.FUN-680130 VARCHAR(01)
 
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
 LET g_forupd_sql = " SELECT wsb03,wsb04 ",
       " FROM wsb_file ",
      "   WHERE wsb01=?  AND wsb02= ? AND wsb03= ? ",
      "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE efcfg_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
    INPUT ARRAY g_wsb WITHOUT DEFAULTS FROM s_wsb.*
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            IF g_rec_b >= l_ac THEN
 
               LET p_cmd='u'
               LET g_wsb_t.* = g_wsb[l_ac].*  #BACKUP
 
               OPEN efcfg_bcl USING g_wsa.wsa01, p_wsb02, g_wsb_t.wsb03
               IF STATUS THEN
                 CALL cl_err("OPEN efcfg_bcl:", STATUS, 1)   
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH efcfg_bcl INTO g_wsb[l_ac].*
                  IF SQLCA.sqlcode THEN
                    CALL cl_err(g_wsb_t.wsb03,SQLCA.sqlcode,1)   
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
         INITIALIZE g_wsb[l_ac].* TO NULL      #900423
            LET g_wsb_t.* = g_wsb[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD wsb03
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             ## MOD-490275
            IF g_wsb[l_ac].wsb03 IS NULL THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             ## END MOD-490275
            INSERT INTO wsb_file (wsb01, wsb02, wsb03, wsb04)
                 VALUES (g_wsa.wsa01, p_wsb02, g_wsb[l_ac].wsb03, g_wsb[l_ac].wsb04)
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_wsb[l_ac].wsb03,SQLCA.sqlcode,1)   #No.FUN-660155
               CALL cl_err3("ins","wsb_file",g_wsa.wsa01,p_wsb02,SQLCA.sqlcode,"","",1)   #No.FUN-660155
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD wsb03
#           IF g_wsb[l_ac].wsb03 IS NULL THEN
#              NEXT FIELD wsb03
#           END IF
            IF (g_wsb_t.wsb03 IS NULL AND g_wsb[l_ac].wsb03 IS NOT NULL) OR
               (g_wsb[l_ac].wsb03 != g_wsb_t.wsb03) THEN
               IF g_wsb[l_ac].wsb03 IS NOT NULL THEN
              {    IF NOT efcfg_col(g_wsb[l_ac].wsb03,null) THEN
                     NEXT FIELD wsb03
                  END IF
              }
                  SELECT COUNT(*) INTO l_n FROM wsb_file
                   WHERE wsb01 = g_wsa.wsa01 AND
                         wsb02 = p_wsb02 AND
                         wsb03 = g_wsb[l_ac].wsb03
                  IF l_n > 0 THEN
                     CALL cl_err(g_wsb[l_ac].wsb03,-239,0)
 
                     NEXT FIELD wsb03
                  END IF
               END IF
            END IF
 
        BEFORE FIELD wsb04
            IF g_wsb[l_ac].wsb03 IS NULL THEN NEXT FIELD wsb03 END IF
 
        AFTER FIELD wsb04
            IF g_wsb[l_ac].wsb04 IS NOT NULL THEN
               IF NOT efcfg_col(g_wsb[l_ac].wsb04,NULL) THEN NEXT FIELD wsb04 END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_wsb_t.wsb03 IS NOT NULL THEN
               IF NOT cl_delete() THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
{ckp#1}           DELETE FROM wsb_file
                  WHERE wsb01 = g_wsa.wsa01 AND
                      wsb02 = p_wsb02 AND
                      wsb03 = g_wsb_t.wsb03
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_wsb_t.wsb03,SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete Ok"
               CLOSE efcfg_bcl
               COMMIT WORK
            END IF
 
        AFTER ROW
                LET l_ac = ARR_CURR()
                LET l_ac_t = l_ac
 
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   IF p_cmd = 'u' THEN
                      LET g_wsb[l_ac].* = g_wsb_t.*
                   END IF
                   CLOSE efcfg_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
                CLOSE efcfg_bcl
                COMMIT WORK
 
        ON ROW CHANGE
                IF INT_FLAG THEN                 #900423
                   CALL cl_err('',9001,0)
                   LET INT_FLAG = 0
                   LET g_wsb[l_ac].* = g_wsb_t.*
                   CLOSE efcfg_bcl
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
 
                IF l_lock_sw = 'Y' THEN
                   CALL cl_err(g_wsb[l_ac].wsb03,-263,1)
                   LET g_wsb[l_ac].* = g_wsb_t.*
                ELSE
                    ## MOD-490275
                   IF g_wsb[l_ac].wsb03 IS NULL THEN
                     CALL cl_err('',9001,0)
                     LET INT_FLAG = 0
                     LET g_wsb[l_ac].* = g_wsb_t.*
                     CLOSE efcfg_bcl
                     ROLLBACK WORK
                   END IF
                    ## END MOD-490275
                   UPDATE wsb_file SET wsb03 = g_wsb[l_ac].wsb03,
                                       wsb04 = g_wsb[l_ac].wsb04
                      WHERE wsb01 = g_wsa.wsa01 AND
                            wsb02 = p_wsb02 AND
                            wsb03 = g_wsb_t.wsb03
                   IF SQLCA.sqlcode THEN
#                     CALL cl_err(g_wsb[l_ac].wsb03,SQLCA.sqlcode,0)   #No.FUN-660155
                      CALL cl_err3("upd","wsb_file",g_wsa.wsa01,p_wsb02,SQLCA.sqlcode,"","",0)   #No.FUN-660155
                      LET g_wsb[l_ac].* = g_wsb_t.*
                      CLOSE efcfg_bcl
                      ROLLBACK WORK
                   ELSE
                      MESSAGE 'UPDATE O.K'
                      CLOSE efcfg_bcl
                      COMMIT WORK
                   END IF
                END IF
       
         ON ACTION CONTROLO                        #沿用所有欄位
             IF INFIELD(wsb03) AND l_ac > 1 THEN
                 LET g_wsb[l_ac].* = g_wsb[l_ac-1].*
                 NEXT FIELD wsb03
             END IF
#         ON ACTION CONTROLO                        #沿用所有欄位
{       ON ACTION controlp
            CASE
                WHEN INFIELD(wsb03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ztb"
                  LET g_qryparam.default1 = g_wsb[l_ac].wsb03
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_wsa.wsa02 CLIPPED
                  LET g_qryparam.arg2 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING g_wsb[l_ac].wsb03,g_zz02
 
                  DISPLAY BY NAME g_wsb[l_ac].wsb03
                  NEXT FIELD wsb03
            END CASE
 
}
        ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
        
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
    END INPUT
 
    CLOSE efcfg_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION efcfg_copy()
    DEFINE
        l_newno         LIKE wsa_file.wsa01,
        l_oldno         LIKE wsa_file.wsa01,
	l_cnt		LIKE type_file.num5          #No.FUN-680130 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_wsa.wsa01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    INPUT l_newno FROM wsa01
 
         AFTER FIELD wsa01
            IF l_newno IS NULL THEN
                NEXT FIELD wsa01
            END IF
            SELECT zz01 FROM zz_file WHERE zz01 = l_newno
            IF SQLCA.SQLCODE THEN
              CALL cl_err(l_newno,SQLCA.SQLCODE,0)   
               NEXT FIELD wsa01
            END IF
            SELECT COUNT(*) INTO l_cnt FROM wsa_file WHERE wsa01 = l_newno
            IF l_cnt > 0 THEN                  # Duplicated
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD wsa01
            END IF
            CALL efcfg_zz02(l_newno)
 
 
        ON ACTION controlp
            CASE
                WHEN INFIELD(wsa01)
                  CALL cl_init_qry_var()
                 # LET g_wsa.wsa01 = fgl_dialog_getbuffer()
                  LET g_qryparam.form = "q_gaz1"
                  LET g_qryparam.default1 = l_newno
                  LET g_qryparam.default2 = NULL
                  LET g_qryparam.arg1 = g_lang CLIPPED
                  CALL cl_create_qry() RETURNING l_newno,g_zz02
                  DISPLAY l_newno TO wsa01
                  DISPLAY g_zz02 TO FORMONLY.zz02
                  #NEXT FIELD wsa01
 
 
               OTHERWISE
                  EXIT CASE
 
            END CASE
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
        
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
   END INPUT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_wsa.wsa01
        RETURN
    END IF
 
    BEGIN WORK
 
    DROP TABLE x
    SELECT * FROM wsa_file WHERE wsa01 = g_wsa.wsa01 INTO TEMP x
    UPDATE x SET wsa01 = l_newno,
                 wsaacti = 'Y',
                 wsauser = g_user,
                 wsagrup= g_grup,
                 wsamodu = NULL,
                 wsadate = g_today
    INSERT INTO wsa_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
        CALL cl_err3("ins","wsa_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    DROP TABLE x
    SELECT * FROM wsb_file WHERE wsb01 = g_wsa.wsa01 INTO TEMP x
    UPDATE x SET wsb01 = l_newno
    INSERT INTO wsb_file SELECT * FROM x
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660155
       CALL cl_err3("ins","wsb_file",l_newno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660155
        ROLLBACK WORK
        RETURN
    END IF
 
    COMMIT WORK
 
    MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
    LET l_oldno = g_wsa.wsa01
    LET g_wsa.wsa01 = l_newno
    SELECT wsa_file.* INTO g_wsa.* FROM wsa_file
           WHERE wsa01 = l_newno
    CALL efcfg_u()
    #FUN-C80046---begin
    #SELECT wsa_file.* INTO g_wsa.* FROM wsa_file  
    #       WHERE wsa01 = l_oldno                  
    #
    #LET g_wsa.wsa01 = l_oldno                     
    #CALL efcfg_show()
    ##FUN-C80046---end
    OPEN efcfg_count
    FETCH efcfg_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    
    CALL cl_navigator_setting(g_curs_index, g_row_count)
    
       OPEN efcfg_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL efcfg_fetch('L')
       ELSE
          Let g_jump = g_curs_index
          LET mi_no_ask = TRUE   #No.FUN-6A0075
          CALL efcfg_fetch('/')
       END IF
    #FUN-C80046---begin
    SELECT wsa_file.* INTO g_wsa.* FROM wsa_file
           WHERE wsa01 = l_newno
    CALL efcfg_show()     
    #FUN-C80046---end
END FUNCTION
 
 
FUNCTION efcfg_set_entry()
 IF INFIELD(wsa05) THEN
       CALL cl_set_comp_entry("wsa06,wsa07", TRUE)
 END IF
  ####MOD-490275
 IF INFIELD(wsa11) THEN
       CALL cl_set_comp_entry("wsa15", TRUE)
 END IF
  #### END MOD-490275
END FUNCTION
 
FUNCTION efcfg_set_no_entry()
 
 #### MOD-490275 ####
  IF g_beforeinput = "false" THEN
       IF g_wsa.wsa05 IS NULL THEN
          CALL cl_set_comp_entry("wsa06,wsa07", FALSE)
       END IF
       IF g_wsa.wsa11 IS NULL THEN
           CALL cl_set_comp_entry("wsa15", FALSE)
       END IF
  ELSE
    IF INFIELD(wsa05) THEN
       IF g_wsa.wsa05 IS NULL THEN
          CALL cl_set_comp_entry("wsa06,wsa07", FALSE)
       END IF
    END IF
    IF INFIELD(wsa11) THEN
       IF g_wsa.wsa11 IS NULL THEN
           CALL cl_set_comp_entry("wsa15", FALSE)
       END IF
    END IF
  END IF
 #### END MOD-490275 ####
END FUNCTION
 
#FUN-550075
FUNCTION aws_efcfg_station()
DEFINE l_cnt  LIKE type_file.num10   #No.FUN-680130 INTEGER 
 
   OPEN WINDOW efcfg_station AT 4, 16
       WITH FORM "aws/42f/aws_efcfg_station" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("aws_efcfg_station")
 
   MESSAGE ''
 
   INITIALIZE g_wsj.* TO NULL
 
   SELECT COUNT(*) INTO l_cnt FROM wsj_file where wsj01='S'
   IF l_cnt > 0 THEN
      SELECT * INTO g_wsj.* FROM wsj_file where wsj01='S'
      DISPLAY BY NAME g_wsj.wsj02,g_wsj.wsj03,g_wsj.wsj04
      LET g_wsj_t.* = g_wsj.*
   END IF
 
   INPUT BY NAME g_wsj.wsj04,g_wsj.wsj02,g_wsj.wsj03
       WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
       BEFORE INPUT
          IF l_cnt = 0 THEN
                LET g_wsj.wsj01 = 'S'
                LET g_wsj.wsj05 = '*'
                LET g_wsj.wsj06 = '*'
                LET g_wsj.wsj07 = '*'
          END IF
 
        ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON ACTION Exception
          IF l_cnt = 0 THEN
                CALL cl_err(NULL,'aws-077',1)
                NEXT FIELD wsj02
          ELSE
             LET g_wsj_o.* = g_wsj.*
             CALL aws_efcfg_exception()
             LET g_wsj.* = g_wsj_o.*
          END IF
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
   END INPUT
   IF INT_FLAG THEN
       CLOSE WINDOW efcfg_station
       LET INT_FLAG = 0
       RETURN
   END IF
 
   IF l_cnt = 0 THEN
       INSERT INTO wsj_file VALUES(g_wsj.*)
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_wsj.wsj01,SQLCA.sqlcode,0)   
       END IF
   ELSE
       UPDATE wsj_file SET wsj_file.* = g_wsj.*    # 更新DB
           WHERE wsj01 = g_wsj.wsj01 AND wsj05 = g_wsj.wsj05 AND
                 wsj06 = g_wsj.wsj06 AND wsj07 = g_wsj.wsj07
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_wsj.wsj01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("upd","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
       END IF
   END IF
   CLOSE WINDOW efcfg_station
END FUNCTION
 
FUNCTION aws_efcfg_exception()
 
   LET l_ac = 1
   CALL aws_exc_fill()
   OPEN WINDOW efcfg_exc AT 4, 16
       WITH FORM "aws/42f/aws_efcfg_exc" ATTRIBUTE(STYLE = g_win_style)
   CALL cl_ui_locale("aws_efcfg_exc")
   MESSAGE ''
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bwsj TO s_bwsj.* ATTRIBUTE(COUNT=g_exc_cnt,UNBUFFERED)
 
     BEFORE ROW
         LET l_ac = ARR_CURR()
         IF l_ac != 0 THEN
            DISPLAY g_bwsj[l_ac].bwsj06 TO wsj06
            DISPLAY g_bwsj[l_ac].bwsj04 TO wsj04
            DISPLAY g_bwsj[l_ac].bwsj02 TO wsj02
            DISPLAY g_bwsj[l_ac].bwsj03 TO wsj03
         END IF
 
     AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION insert
         CALL aws_exc_maintain("insert")
         ACCEPT DISPLAY
 
     ON ACTION modify
         IF l_ac != 0 THEN
            CALL aws_exc_maintain("modify")
         END IF
 
     ON ACTION delete
        IF l_ac != 0 THEN
            IF cl_delete() THEN
              DELETE FROM wsj_file WHERE wsj01 = 'E' AND wsj05 = '*'
                  AND wsj06 = g_bwsj[l_ac].bwsj06 AND wsj07='*'
              IF SQLCA.SQLCODE THEN
#                CALL cl_err('del wsd: ', SQLCA.SQLCODE, 0)   #No.FUN-660155
                 CALL cl_err3("del","wsj_file",g_bwsj[l_ac].bwsj06,"",SQLCA.sqlcode,"","del wsd:", 0)   #No.FUN-660155)   #No.FUN-660155
              END IF
              CALL aws_exc_fill()
              IF g_bwsj.getLength() = 0 THEN
                 DISPLAY '' TO wsj06
                 DISPLAY '' TO wsj04
                 DISPLAY '' TO wsj02
                 DISPLAY '' TO wsj03
              END IF
 
              ACCEPT DISPLAY
            END IF
         END IF
 
     ON ACTION accept
         IF l_ac != 0 THEN
            CALL aws_exc_maintain("modify")
         END IF
 
     ON ACTION exit
          EXIT DISPLAY
 
     ON ACTION cancel
          EXIT DISPLAY
 
     ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
     #TQC-860022
     ON ACTION about         #MOD-4C0121
        CALL cl_about()      #MOD-4C0121
     
     ON ACTION controlg      #MOD-4C0121
        CALL cl_cmdask()     #MOD-4C0121
     
     ON ACTION help          #MOD-4C0121
        CALL cl_show_help()  #MOD-4C0121
     #END TQC-860022
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
   IF INT_FLAG THEN                         # 若按了DEL鍵
       LET INT_FLAG = 0
   END IF
   CLOSE WINDOW efcfg_exc
END FUNCTION
 
FUNCTION aws_exc_fill()
   LET g_sql = "SELECT wsj06,wsj04,wsj02,wsj03 FROM wsj_file where wsj01='E'"
 
   PREPARE efcfg_pp FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2)  RETURNING g_time  #FUN-B90032
      EXIT PROGRAM
   END IF
   DECLARE efcfg_cs2 CURSOR FOR efcfg_pp
   CALL g_bwsj.clear()
   LET g_exc_cnt=1
   FOREACH efcfg_cs2 INTO g_bwsj[g_exc_cnt].*
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare2:',SQLCA.sqlcode,1) 
        EXIT FOREACH
     END IF
     LET g_exc_cnt=g_exc_cnt+1
  END FOREACH
 
  CALL g_bwsj.deleteElement(g_exc_cnt)
END FUNCTION
 
FUNCTION aws_exc_maintain(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(10)
DEFINE l_cnt       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_wsj06     LIKE wsj_file.wsj06
 
   INITIALIZE g_wsj.* TO NULL
 
   IF p_cmd = "modify" THEN
      LET g_wsj.wsj06 = g_bwsj[l_ac].bwsj06
      LET g_wsj.wsj04 = g_bwsj[l_ac].bwsj04
      LET g_wsj.wsj02 = g_bwsj[l_ac].bwsj02
      LET g_wsj.wsj03 = g_bwsj[l_ac].bwsj03
      LET l_wsj06 = g_bwsj[l_ac].bwsj06
      CALL cl_set_comp_entry("wsj06", FALSE)
   END IF
   CALL cl_set_act_visible("accept,cancel", TRUE)
   INPUT BY NAME g_wsj.wsj06,g_wsj.wsj04,g_wsj.wsj02,g_wsj.wsj03
       WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)
       BEFORE INPUT
          LET g_wsj.wsj01 = 'E'
          LET g_wsj.wsj05 = '*'
          LET g_wsj.wsj07 = '*'
 
       AFTER FIELD wsj06
          IF g_wsj.wsj06 IS NOT NULL THEN
               SELECT COUNT(*) INTO l_cnt FROM azp_file
                       where azp01 = g_wsj.wsj06
               IF l_cnt = 0 THEN
                  CALL cl_err(g_wsj.wsj06,"-827",0)
                  NEXT FIELD wsj06
               END IF
          END IF
 
       AFTER INPUT
          IF p_cmd = "insert" THEN
             SELECT COUNT(*) INTO l_cnt FROM wsj_file
               WHERE wsj01 = g_wsj.wsj01 AND wsj05 = g_wsj.wsj05 AND
                     wsj06 = g_wsj.wsj06 AND wsj07 = g_wsj.wsj07
             IF l_cnt > 0 THEN
                 CALL cl_err(g_wsj.wsj06,-239,0)
                 NEXT FIELD wsj06
             END IF
          END IF
 
       ON ACTION controlp
          CASE WHEN INFIELD(wsj06)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_azp"
             LET g_qryparam.default1 = g_wsj.wsj06
             CALL cl_create_qry() RETURNING g_wsj.wsj06
             DISPLAY BY NAME g_wsj.wsj06
             NEXT FIELD wsj06
          END CASE
 
        ON ACTION CONTROLF                       #MOD-560086
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #TQC-860022
        ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        #END TQC-860022
 
   END INPUT
 
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       CALL aws_exc_fill()
       IF p_cmd = "modify" THEN
          CALL cl_set_comp_entry("wsj06", TRUE)
       END IF
       CALL cl_set_act_visible("accept,cancel", FALSE)
       RETURN
   END IF
   IF p_cmd ="insert" THEN
       INSERT INTO wsj_file VALUES(g_wsj.*)
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_wsj.wsj01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("ins","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
       END IF
   ELSE
       UPDATE wsj_file SET wsj06 = g_wsj.wsj06,
                           wsj04 = g_wsj.wsj04,
                           wsj02 = g_wsj.wsj02,
                           wsj03 = g_wsj.wsj03
           WHERE wsj01 = g_wsj.wsj01 AND wsj05 = g_wsj.wsj05 AND
                 wsj06 = l_wsj06 AND wsj07 = g_wsj.wsj07
       IF SQLCA.sqlcode THEN
#          CALL cl_err(g_wsj.wsj01,SQLCA.sqlcode,0)   #No.FUN-660155
           CALL cl_err3("upd","wsj_file",g_wsj.wsj01,g_wsj.wsj05,SQLCA.sqlcode,"","",0)   #No.FUN-660155
       END IF
   END IF
   CALL aws_exc_fill()
 
   IF p_cmd = "modify" THEN
      CALL cl_set_comp_entry("wsj06", TRUE)
   END IF
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
END FUNCTION
#END FUN-550075
 

# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimt828.4gl
# Descriptions...: 初盤調整作業－多單位現有庫存
# Date & Author..: 05/07/15 By Carrier
# Modify.........: No.FUN-5A0199 06/01/005By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.FUN-660156 06/06/23 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690022 06/09/15 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-930121 09/04/10 By zhaijie新增字段piaa931-底稿類別做查詢用
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BB0086 11/12/15 By tanxc 增加數量欄位小數取位
# Modify.........: No:TQC-C20183 12/02/17 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-CB0092 12/11/26 By qirl 增加開窗
# Modify.........: No:FUN-CB0087 12/12/14 By qiull 庫存單據理由碼改善
# Modify.........: No:TQC-D10103 13/01/30 By qiull 理由碼檢查放在必輸條件下
# Modify.........: No.TQC-CB0092 13/01/31 By xuxz增加開窗
# Modify.........: No.TQC-D20042 13/02/25 By qiull 修改理由碼改善測試問題
# Modify.........: No.TQC-D20047 13/02/27 By qiull 修改理由碼改善測試問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_piaa              RECORD LIKE piaa_file.*,
    g_piaa_t            RECORD LIKE piaa_file.*,
    g_piaa_o            RECORD LIKE piaa_file.*,
    g_piaa01_t          LIKE piaa_file.piaa01,
    g_piaa09_t          LIKE piaa_file.piaa09,
    g_ima25             LIKE ima_file.ima25,
    g_argv1             LIKE piaa_file.piaa01,
    g_wc,g_sql          string,                 #No.FUN-580092 HCN
    g_qty               LIKE piaa_file.piaa30
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_qty_t             LIKE piaa_file.piaa30  #No.FUN-BB0086
DEFINE g_azf03             LIKE azf_file.azf03    #FUN-CB0087
MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0074
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
    LET g_argv1 = ARG_VAL(1)
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
    INITIALIZE g_piaa.* TO NULL
    INITIALIZE g_piaa_t.* TO NULL
    INITIALIZE g_piaa_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM piaa_file WHERE piaa01 = ? AND piaa09 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t828_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 27
 
    OPEN WINDOW t828_w AT p_row,p_col
         WITH FORM "aim/42f/aimt828"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_required("piaa70",g_aza.aza115='Y')        #FUN-CB0087 add
    
    IF g_sma.sma115 IS NULL OR g_sma.sma115='N' THEN
       CALL cl_err('','asm-383',1)
       EXIT PROGRAM
    END IF
    IF NOT cl_null(g_argv1) THEN
       CALL t828_q()
    END IF
    WHILE TRUE
       LET g_action_choice=""
       CALL t828_menu()
       IF g_action_choice="exit" THEN EXIT WHILE END IF
    END WHILE
 
    CLOSE WINDOW t828_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
END MAIN
 
FUNCTION t828_cs()
 DEFINE  l_code  LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_str   LIKE ze_file.ze03       #No.FUN-690026 VARCHAR(70)
 
    CLEAR FORM
    IF NOT cl_null(g_argv1) THEN
       LET g_wc=" piaa01='",g_argv1,"'"
       LET l_code=FALSE
    ELSE
       CALL cl_getmsg('mfg0126',g_lang) RETURNING l_str
       CALL cl_prompt(0,0,l_str) RETURNING l_code
       INITIALIZE g_piaa.* TO NULL    #FUN-640213 add
       CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
           piaa01, piaa09, piaa02, piaa03, piaa04, piaa05,piaa931,piaa70    #FUN-930121 add piaa931    #FUN-CB0087 add>piaa70
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
#----TQC-CB0092---ADD---STAR--
        ON ACTION controlp
           CASE
              WHEN INFIELD(piaa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_piaa01"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO piaa01
                 NEXT FIELD piaa01
              WHEN INFIELD(piaa02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_piaa02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO piaa02
                 NEXT FIELD piaa02
              WHEN INFIELD(piaa03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_piaa03"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO piaa03
                 NEXT FIELD piaa03
              WHEN INFIELD(piaa04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_piaa04"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO piaa04
                 NEXT FIELD piaa04
              WHEN INFIELD(piaa05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state  ='c'
                 LET g_qryparam.form = "q_piaa05"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO piaa05
                 NEXT FIELD piaa05
              #FUN-CB0087---add---str---
               WHEN INFIELD(piaa70)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form     ="q_azf41"
                  LET g_qryparam.default1 = g_piaa.piaa70
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO piaa70
                  NEXT FIELD piaa70
               #FUN-CB0087---add---end---
              OTHERWISE EXIT CASE
            END CASE
#----TQC-CB0092---ADD---end--
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    END IF
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT piaa01,piaa09 FROM piaa_file ", # 組合出 SQL 指令
              " WHERE (piaa02 IS NOT NULL AND  piaa02 != ' ' ) ",
              "   AND (piaa30 IS NOT NULL OR   piaa40 IS NOT NULL ",
              "    OR  CAST(piaa30 AS varchar(15)) != ''       OR   CAST(piaa40 AS varchar(15)) != ''  )",
              "   AND ",g_wc CLIPPED
    IF l_code THEN
       LET g_sql = g_sql CLIPPED,
                  " AND (piaa30 != piaa40 OR piaa30 IS NULL ",
                  "  OR  piaa40 IS NULL   OR CAST(piaa30 AS varchar(15)) ='' OR CAST(piaa40 AS varchar(15)) ='') ",
                  " ORDER BY piaa01 "
    ELSE
       LET g_sql = g_sql CLIPPED, " ORDER BY piaa01"
    END IF
    PREPARE t828_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t828_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t828_prepare
    LET g_sql="SELECT COUNT(*) FROM piaa_file  ",
              " WHERE (piaa02 IS NOT NULL AND piaa02 != ' ' ) ",
              "   AND (piaa30 IS NOT NULL OR  piaa40 IS NOT NULL ",
              "    OR  CAST(piaa30 AS varchar(15)) != ''       OR  CAST(piaa40 AS varchar(15)) != ''  )",
              "   AND ",g_wc CLIPPED
    IF l_code THEN
       LET g_sql = g_sql CLIPPED,
                  " AND (piaa30 != piaa40 OR piaa30 IS NULL ",
                  "  OR piaa40 IS NULL    OR CAST(piaa30 AS varchar(15)) ='' OR CAST(piaa40 AS varchar(15)) ='') "
    END IF
    PREPARE t828_precount FROM g_sql
    DECLARE t828_count CURSOR FOR t828_precount
END FUNCTION
 
FUNCTION t828_menu()
    MENU ""
 
        BEFORE MENU
           CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION fast_adjust
           LET g_action_choice="fast_adjust"
           IF cl_chk_act_auth() THEN
                CALL t828_a()
           END IF
        ON ACTION query
           LET g_action_choice="query"
           IF cl_chk_act_auth() THEN
                CALL t828_q()
           END IF
        ON ACTION next
           CALL t828_fetch('N')
        ON ACTION previous
           CALL t828_fetch('P')
        ON ACTION adjust
           CALL t828_u()
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL t828_fetch('/')
        ON ACTION first
           CALL t828_fetch('F')
        ON ACTION last
           CALL t828_fetch('L')

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
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
    END MENU
    CLOSE t828_cs
END FUNCTION
 
#快速輸入
FUNCTION t828_a()
 DEFINE  l_msg1,l_msg2   LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(70)
 DEFINE  l_sum1,l_sum2   LIKE pia_file.pia30
 DEFINE  l_pia09         LIKE pia_file.pia09   #No.FUN-BB0086
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    #CLEAR FORM                                      # 清螢墓欄位內容
    #INITIALIZE g_piaa.* LIKE piaa_file.*
    LET g_piaa01_t = NULL
    LET g_piaa09_t = NULL
    LET g_qty = 0
    LET l_msg1 = 'Del:登錄結束,<^F>:欄位說明'
    LET l_msg2=  '↑↓←→:移動游標, <^A>:插字,<^X>:消字'
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       MESSAGE l_msg1,l_msg2
    ELSE
       DISPLAY l_msg1 AT 1,1
       DISPLAY l_msg2 AT 2,1
    END IF
    WHILE TRUE
        SELECT COUNT(*) INTO g_cnt FROM piaa_file
         WHERE piaa01=g_piaa.piaa01
        IF g_cnt >0 THEN
           DECLARE sel_piaa_cur CURSOR FOR
            SELECT piaa09 FROM piaa_file
             WHERE piaa01=g_piaa.piaa01
           FOREACH sel_piaa_cur INTO g_piaa.piaa09
              IF SQLCA.sqlcode THEN
                 CALL cl_err('foreach',SQLCA.sqlcode,1)
                 EXIT FOREACH
              END IF
              CLEAR FORM
              LET g_qty  = NULL
              CALL t828_i("a")                            # 各欄位輸入
              IF INT_FLAG THEN                            # 若按了DEL鍵
                 LET INT_FLAG = 0
                 INITIALIZE g_piaa.* TO NULL
                 LET g_qty = NULL
                 CLEAR FORM
                 EXIT WHILE
              END IF
              #IF g_piaa.piaa01 IS NULL OR g_piaa.piaa09 IS NULL OR            #TQC-D10103---mark---
              #   g_qty IS NULL THEN                                           #TQC-D10103---mark---
              IF (g_piaa.piaa01 IS NULL OR g_piaa.piaa09 IS NULL OR g_qty IS NULL) AND (cl_null(g_piaa.piaa19) OR g_piaa.piaa19<>'Y') THEN    #TQC-D10103---add---
                 CONTINUE WHILE
              END IF
              IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
              IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
              IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
              LET g_piaa.piaa30 = g_qty
              LET g_piaa.piaa40 = g_qty
              UPDATE piaa_file SET piaa_file.* = g_piaa.*    # 更新DB
               WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09               # COLAUTH?
              IF SQLCA.sqlcode THEN
#                CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
                 CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
                 CONTINUE WHILE
              END IF
              IF cl_null(g_argv1) THEN
                 LET l_sum1=0
                 LET l_sum2=0
                 SELECT SUM(piaa30*piaa10) INTO l_sum1 FROM piaa_file
                  WHERE piaa01=g_piaa.piaa01
                    AND piaa02=g_piaa.piaa02
                    AND piaa03=g_piaa.piaa03
                    AND piaa04=g_piaa.piaa04
                    AND piaa05=g_piaa.piaa05
                    AND piaa30 IS NOT NULL
                    AND piaa10 IS NOT NULL
                 SELECT SUM(piaa40*piaa10) INTO l_sum2 FROM piaa_file
                  WHERE piaa01=g_piaa.piaa01
                    AND piaa02=g_piaa.piaa02
                    AND piaa03=g_piaa.piaa03
                    AND piaa04=g_piaa.piaa04
                    AND piaa05=g_piaa.piaa05
                    AND piaa40 IS NOT NULL
                    AND piaa10 IS NOT NULL
                 IF cl_null(l_sum1) THEN
                    LET l_sum1=0
                 END IF
                 IF cl_null(l_sum2) THEN
                    LET l_sum2=0
                 END IF
                 #No.FUN-BB0086--add--start--
                 SELECT pia09 INTO l_pia09 FROM pia_file WHERE pia01 = g_piaa.piaa01
                 LET l_sum1 = s_digqty(l_sum1,l_pia09)
                 LET l_sum2 = s_digqty(l_sum2,l_pia09)
                 #No.FUN-BB0086--add--end--
                 UPDATE pia_file SET pia30=l_sum1,pia40=l_sum2,
                                     pia70=g_piaa.piaa70          #FUN-CB0087 add
                  WHERE pia01=g_piaa.piaa01
                    AND pia02=g_piaa.piaa02
                    AND pia03=g_piaa.piaa03
                    AND pia04=g_piaa.piaa04
                    AND pia05=g_piaa.piaa05
                 IF SQLCA.sqlcode THEN
#                   CALL cl_err('upd_pia',SQLCA.sqlcode,1)
                    CALL cl_err3("upd","pia_file",g_piaa.piaa01,g_piaa.piaa02,
                                  SQLCA.sqlcode,"","upd pia",1)   #NO.FUN-640266 #No.FUN-660156
                 END IF 
              END IF
              LET g_piaa_t.* = g_piaa.*                # 保存上筆資料
              CLEAR FORM
           END FOREACH
           CLEAR FORM
           INITIALIZE g_piaa.* LIKE piaa_file.*
          #start FUN-5A0199
          #LET g_piaa.piaa01 = g_piaa_t.piaa01[1,3],'-',
          #                    g_piaa_t.piaa01[5,10] + 1 using '&&&&&&'
           LET g_piaa.piaa01 = g_piaa_t.piaa01[1,g_doc_len],'-',
                               g_piaa_t.piaa01[g_no_sp,g_no_ep] + 1 using '&&&&&&'
          #end FUN-5A0199
        ELSE
           CLEAR FORM
           INITIALIZE g_piaa.* LIKE piaa_file.*
           LET g_qty  = NULL
          #start FUN-5A0199
          #LET g_piaa.piaa01 = g_piaa_t.piaa01[1,3],'-',
          #                    g_piaa_t.piaa01[5,10] + 1 using '&&&&&&'
           LET g_piaa.piaa01 = g_piaa_t.piaa01[1,g_doc_len],'-',
                               g_piaa_t.piaa01[g_no_sp,g_no_ep] + 1 using '&&&&&&'
          #end FUN-5A0199
           CALL t828_i("a")                            # 各欄位輸入
           IF INT_FLAG THEN                            # 若按了DEL鍵
              LET INT_FLAG = 0
              INITIALIZE g_piaa.* TO NULL
              LET g_qty = NULL
              CLEAR FORM
              EXIT WHILE
           END IF
           IF g_piaa.piaa01 IS NULL OR g_piaa.piaa09 IS NULL OR
              g_qty IS NULL THEN
              CONTINUE WHILE
           END IF
           IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
           IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
           IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
           LET g_piaa.piaa30 = g_qty
           LET g_piaa.piaa40 = g_qty
           UPDATE piaa_file SET piaa_file.* = g_piaa.*    # 更新DB
            WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09               # COLAUTH?
           IF SQLCA.sqlcode THEN
#             CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
              CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
              CONTINUE WHILE
           END IF
           IF cl_null(g_argv1) THEN
              LET l_sum1=0
              LET l_sum2=0
              SELECT SUM(piaa30*piaa10) INTO l_sum1 FROM piaa_file
               WHERE piaa01=g_piaa.piaa01
                 AND piaa02=g_piaa.piaa02
                 AND piaa03=g_piaa.piaa03
                 AND piaa04=g_piaa.piaa04
                 AND piaa05=g_piaa.piaa05
                 AND piaa30 IS NOT NULL
                 AND piaa10 IS NOT NULL
              SELECT SUM(piaa40*piaa10) INTO l_sum2 FROM piaa_file
               WHERE piaa01=g_piaa.piaa01
                 AND piaa02=g_piaa.piaa02
                 AND piaa03=g_piaa.piaa03
                 AND piaa04=g_piaa.piaa04
                 AND piaa05=g_piaa.piaa05
                 AND piaa40 IS NOT NULL
                 AND piaa10 IS NOT NULL
              IF cl_null(l_sum1) THEN
                 LET l_sum1=0
              END IF
              IF cl_null(l_sum2) THEN
                 LET l_sum2=0
              END IF
              #No.FUN-BB0086--add--start--
              SELECT pia09 INTO l_pia09 FROM pia_file WHERE pia01 = g_piaa.piaa01
              LET l_sum1 = s_digqty(l_sum1,l_pia09)
              LET l_sum2 = s_digqty(l_sum2,l_pia09)
              #No.FUN-BB0086--add--end--
              UPDATE pia_file SET pia30=l_sum1,pia40=l_sum2,
                                  pia70=g_piaa.piaa70        #FUN-CB0087 add
               WHERE pia01=g_piaa.piaa01
                 AND pia02=g_piaa.piaa02
                 AND pia03=g_piaa.piaa03
                 AND pia04=g_piaa.piaa04
                 AND pia05=g_piaa.piaa05
              IF SQLCA.sqlcode THEN
#                CALL cl_err('upd_pia',SQLCA.sqlcode,1)
                 CALL cl_err3("upd","pia_file",g_piaa.piaa01,g_piaa.piaa02,SQLCA.sqlcode,
                              "","upd pia",1)   #NO.FUN-640266 #No.FUN-660156
              END IF 
           END IF
           LET g_piaa_t.* = g_piaa.*                # 保存上筆資料
           INITIALIZE g_piaa.* LIKE piaa_file.*
        END IF
    END WHILE
END FUNCTION
 
FUNCTION t828_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
	l_ime09         LIKE ime_file.ime09,
	l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
	l_sw            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-690026 SMALLINT
    DEFINE l_piaa931    LIKE pia_file.pia931    #FUN-930121  存放顯示的底稿類型
    DEFINE l_tf         LIKE type_file.chr1     #No.FUN-BB0086
    DEFINE l_case       STRING   #No.FUN-BB0086
    DEFINE l_sql        STRING                #FUN-CB0087
    DEFINE l_where      STRING                #FUN-CB0087
 
    IF g_piaa.piaa19 ='Y' THEN
       CALL cl_err(g_piaa.piaa01,'mfg0132',0) RETURN
    END IF
    INPUT g_piaa.piaa01,g_piaa.piaa09,g_piaa.piaa02,g_piaa.piaa03,
          g_piaa.piaa04,g_piaa.piaa05,g_piaa.piaa06,g_piaa.piaa07,
          g_qty,g_piaa.piaa70                                                #FUN-CB0087 add>piaa70
          WITHOUT DEFAULTS
     FROM piaa01,piaa09,piaa02,piaa03,piaa04,
          piaa05,piaa06,piaa07,qty,piaa70                                    #FUN-CB0087 add>piaa70
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i110_set_entry(p_cmd)
           CALL i110_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           #No.FUN-BB0086--add--begin--
           IF p_cmd = 'u' THEN 
              LET g_qty_t = g_qty   
           END IF 
           IF p_cmd = 'a' THEN 
              LET g_qty_t = ""
           END IF 
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD piaa01
           IF g_piaa.piaa01 IS NOT NULL OR g_piaa.piaa01 != ' ' THEN
              SELECT COUNT(*) INTO g_cnt FROM piaa_file
               WHERE piaa01=g_piaa.piaa01
              IF g_cnt=0 THEN
                 CALL cl_err(g_piaa.piaa01,'mfg0114',0)
                 NEXT FIELD piaa01
              END IF
              #FUN-930121-----star------
              SELECT pia931 INTO l_piaa931 FROM pia_file
               WHERE pia01=g_piaa.piaa01
              DISPLAY l_piaa931  TO FORMONLY.piaa931
              #FUN-930121-----end-----
           END IF
 
        AFTER FIELD piaa09
           LET l_tf = ""     #No.FUN-BB0086 
	        IF NOT cl_null(g_piaa.piaa09) THEN
              CALL t828_unit(g_piaa.piaa09)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_piaa.piaa09,g_errno,0)
                 DISPLAY BY NAME g_piaa.piaa09
                 NEXT FIELD piaa09
              END IF
           END IF
           CALL t828_piaa01('d')
           IF NOT cl_null(g_errno)  THEN
              CALL cl_err(g_piaa.piaa01,'mfg0114',0)
              NEXT FIELD piaa01
           END IF
           #No.FUN-BB0086--add--start--
           IF NOT cl_null(g_qty) AND g_qty <> 0 THEN               #TQC-C20183
             CALL t828_qty_check(p_cmd) RETURNING l_tf,l_case
             LET g_piaa09_t = g_piaa.piaa09
             IF NOT l_tf THEN 
                IF l_case = 'exitinput' THEN 
                   EXIT INPUT 
                ELSE 
                   NEXT FIELD qty
                END IF 
             END IF 
           END IF    #TQC-C20183
           #No.FUN-BB0086--add--end--
 
        AFTER FIELD qty
           #No.FUN-BB0086--add--start--
           LET l_tf = ""
           CALL t828_qty_check(p_cmd) RETURNING l_tf,l_case
           IF NOT l_tf THEN 
              IF l_case = 'exitinput' THEN 
                 EXIT INPUT 
              ELSE 
                 NEXT FIELD qty
              END IF 
           END IF 
           #No.FUN-BB0086--add--end--
           #No.FUN-BB0086--mark--start--
           #IF g_qty < 0 THEN
           #   NEXT FIELD qty
           #END IF
           #IF p_cmd ='u' OR (p_cmd = 'a' AND g_piaa.piaa16 = 'N') THEN
           #   EXIT INPUT
           #END IF
           #No.FUN-BB0086--mark--end--
        #FUN-CB0087---add---str---
        BEFORE FIELD piaa70
           IF g_aza.aza115 = 'Y' AND cl_null(g_piaa.piaa70) THEN
              CALL s_reason_code(g_piaa.piaa01,'','',g_piaa.piaa02,g_piaa.piaa03,'','') RETURNING g_piaa.piaa70
              CALL t828_piaa70()
              DISPLAY BY NAME g_piaa.piaa70
           END IF

        AFTER FIELD piaa70
           IF g_piaa.piaa70 IS NOT NULL THEN
              LET l_n = 0
              CALL s_get_where(g_piaa.piaa01,'','',g_piaa.piaa02,g_piaa.piaa03,'','') RETURNING l_flag,l_where
              IF g_aza.aza115='Y' AND l_flag THEN
                 LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_piaa.piaa70,"' AND ",l_where
                 PREPARE ggc08_pre FROM l_sql
                 EXECUTE ggc08_pre INTO l_n
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD piaa70
                 END IF
              ELSE 
                 SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_piaa.piaa70 AND azf02='2'
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD piaa70
                 END IF
              END IF
           END IF                 #TQC-D20047---add---
           CALL t828_piaa70()
          # END IF                 #TQC-D20047---mark---
        #FUN-CB0087---add---end---
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT  END IF
           IF g_aza.aza115 = 'Y' THEN                   #TQC-D10103---add---
              #FUN-CB0087---add---str---
              LET l_n = 0
              CALL s_get_where(g_piaa.piaa01,'','',g_piaa.piaa02,g_piaa.piaa03,'','') RETURNING l_flag,l_where
              IF g_aza.aza115='Y' AND l_flag AND NOT cl_null(g_piaa.piaa70) THEN
                 LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_piaa.piaa70,"' AND ",l_where
                 PREPARE ggc08_pre1 FROM l_sql
                 EXECUTE ggc08_pre1 INTO l_n
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD piaa70
                 END IF
              ELSE
                 SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01=g_piaa.piaa70 AND azf02='2'
                 IF l_n < 1 THEN
                    CALL cl_err('','aim-425',0)
                    NEXT FIELD piaa70
                 END IF
              END IF
              #FUN-CB0087---add---end---
           END IF                                      #TQC-D10103---add---
           CALL t828_piaa70()                          #TQC-D20042
 
        ON ACTION controlp
           CASE
             #TQC-CB0092--add--str--by xuxz
              WHEN INFIELD(piaa01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_piaa01"
                 LET g_qryparam.default1 = g_piaa.piaa01
                 CALL cl_create_qry() RETURNING g_piaa.piaa01
                  DISPLAY BY NAME g_piaa.piaa01
                 NEXT FIELD piaa01
             #TQC-CB0092--add--end --by xuxz
              WHEN INFIELD(piaa09) #庫存單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gfe"
                 LET g_qryparam.default1 = g_piaa.piaa09
                 CALL cl_create_qry() RETURNING g_piaa.piaa09
                  DISPLAY BY NAME g_piaa.piaa09            #No.MOD-490371
                 NEXT FIELD piaa09
              #FUN-CB0087---add---str---
               WHEN INFIELD(piaa70)
                  CALL s_get_where(g_piaa.piaa01,'','',g_piaa.piaa02,g_piaa.piaa03,'','') RETURNING l_flag,l_where
                  IF g_aza.aza115='Y' AND l_flag THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_ggc08"
                     LET g_qryparam.where = l_where
                     LET g_qryparam.default1 = g_piaa.piaa70
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     ="q_azf41"
                     LET g_qryparam.default1 = g_piaa.piaa70
                  END IF
                  CALL cl_create_qry() RETURNING g_piaa.piaa70
                  DISPLAY BY NAME g_piaa.piaa70
                  CALL t828_piaa70()
                  NEXT FIELD piaa70
               #FUN-CB0087---add---end---
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION mntn_unit
           CALL cl_cmdrun("aooi101 ")
 
        ON ACTION mntn_unit_conv
           CALL cl_cmdrun("aooi102 ")
 
        ON ACTION mntn_item_unit_conv
           CALL cl_cmdrun("aooi103")
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #-----TQC-860018---------
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
        
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
        #-----END TQC-860018-----
 
    END INPUT
END FUNCTION
 
FUNCTION i110_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("piaa01,piaa09",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i110_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("piaa01,piaa09",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION t828_piaa01(p_cmd)
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_ima906     LIKE ima_file.ima906,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT piaa_file.*, ima02,ima021,ima25,imaacti,ima906
      INTO g_piaa.*, l_ima02,l_ima021,g_ima25,l_imaacti,l_ima906
      FROM piaa_file, OUTER ima_file
     WHERE piaa01 = g_piaa.piaa01 AND piaa02 = ima01
       AND piaa09 = g_piaa.piaa09
 
    CASE WHEN SQLCA.SQLCODE = 100        LET g_errno = 'mfg0002'
                 LET g_piaa.piaa02 = NULL
              LET g_piaa.piaa03 = NULL   LET g_piaa.piaa04 = NULL
              LET g_piaa.piaa05 = NULL   LET g_piaa.piaa06 = NULL
              LET g_piaa.piaa07 = NULL   LET g_piaa.piaa09 = NULL
              LET l_ima02       = NULL   LET l_ima021      = NULL
              LET l_imaacti     = NULL
    	WHEN l_imaacti='N'               LET g_errno = '9028'
    #FUN-690022------mod-------
        WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
        WHEN l_ima906 NOT MATCHES '[23]' LET g_errno = 'asm-384'
	OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY BY NAME g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,
                       g_piaa.piaa05,g_piaa.piaa06,g_piaa.piaa07,
                       g_piaa.piaa09,g_piaa.piaa30,g_piaa.piaa40
       DISPLAY l_ima02       TO FORMONLY.ima02
       DISPLAY l_ima021      TO FORMONLY.ima021
       DISPLAY g_piaa.piaa09 TO FORMONLY.piaa09_1
       DISPLAY g_piaa.piaa09 TO FORMONLY.piaa09_2
       DISPLAY g_piaa.piaa09 TO FORMONLY.unit
    END IF
END FUNCTION
 
FUNCTION t828_piaa02(p_cmd)  #料件編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_ima02      LIKE ima_file.ima02,
           l_ima021     LIKE ima_file.ima021,
           l_ima906     LIKE ima_file.ima906,
           l_imaacti    LIKE ima_file.imaacti
 
    LET g_errno = ' '
    LET l_ima02=' '
    LET l_ima021=' '
    LET l_ima906=' '
    SELECT ima02,ima021,ima25,imaacti,ima906
      INTO l_ima02,l_ima021,g_ima25,l_imaacti,l_ima906
      FROM ima_file
     WHERE ima01 = g_piaa.piaa02
 
    CASE WHEN SQLCA.SQLCODE = 100         LET g_errno = 'mfg0002'
                                          LET l_ima02 = NULL
                                          LET l_ima021= NULL
    	 WHEN l_imaacti='N'               LET g_errno = '9028'
    #FUN-690022------mod-------
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
    #FUN-690022------mod-------
         WHEN l_ima906 NOT MATCHES '[23]' LET g_errno='asm-384'
         OTHERWISE                        LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN LET g_piaa.piaa09 = g_ima25 END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_ima02  TO FORMONLY.ima02
       DISPLAY l_ima021 TO FORMONLY.ima021
       DISPLAY BY NAME g_piaa.piaa09
    END IF
END FUNCTION
 
#檢查單位是否存在於單位檔中
FUNCTION t828_unit(p_unit)
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti INTO l_gfe02,l_gfeacti
      FROM gfe_file
     WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                                  LET l_gfe02 = NULL
         WHEN l_gfeacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t828_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t828_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
    OPEN t828_count
    FETCH t828_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t828_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
       INITIALIZE g_piaa.* TO NULL
       LET g_qty = NULL
    ELSE
       CALL t828_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t828_fetch(p_flpiaa)
    DEFINE
        p_flpiaa          LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    CASE p_flpiaa
        WHEN 'N' FETCH NEXT     t828_cs INTO g_piaa.piaa01,g_piaa.piaa09
        WHEN 'P' FETCH PREVIOUS t828_cs INTO g_piaa.piaa01,g_piaa.piaa09
        WHEN 'F' FETCH FIRST    t828_cs INTO g_piaa.piaa01,g_piaa.piaa09
        WHEN 'L' FETCH LAST     t828_cs INTO g_piaa.piaa01,g_piaa.piaa09
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
            FETCH ABSOLUTE g_jump t828_cs INTO g_piaa.piaa01,g_piaa.piaa09
            LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
       INITIALIZE g_piaa.* TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flpiaa
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_piaa.* FROM piaa_file   # 重讀DB,因TEMP有不被更新特性
     WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","piaa_file",g_piaa.piaa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
       CALL t828_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t828_show()
DEFINE l_piaa931    LIKE pia_file.pia931    #FUN-930121  存放顯示的底稿類型
    LET g_piaa_t.* = g_piaa.*
    LET g_qty = NULL
    DISPLAY BY NAME
        g_piaa.piaa01,g_piaa.piaa02,g_piaa.piaa03,g_piaa.piaa04,
        g_piaa.piaa05,g_piaa.piaa06,g_piaa.piaa09,
        g_piaa.piaa07,g_piaa.piaa30,g_piaa.piaa40,g_piaa.piaa70    #FUN-CB0087 add>piaa70
    DISPLAY g_qty TO FORMONLY.qty
    #FUN-930121-----star------
    SELECT pia931 INTO l_piaa931 FROM pia_file
        WHERE pia01=g_piaa.piaa01
    DISPLAY l_piaa931  TO FORMONLY.piaa931
    #FUN-930121-----end-----
    CALL t828_piaa02('d')
    #FUN-CB0087---add---str---
    IF g_piaa.piaa70 IS NOT NULL THEN
       CALL t828_piaa70()
    ELSE
       DISPLAY '' TO azf03
    END IF
    #FUN-CB0087---add---end---
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t828_u()
 DEFINE  l_sum1,l_sum2   LIKE pia_file.pia30
 DEFINE  l_pia09         LIKE pia_file.pia09   #No.FUN-BB0086
 
    IF s_shut(0) THEN RETURN END IF
    IF g_piaa.piaa01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_piaa01_t = g_piaa.piaa01
    LET g_piaa_o.*=g_piaa.*
    LET g_qty = NULL
    BEGIN WORK
 
    OPEN t828_cl USING g_piaa.piaa01,g_piaa.piaa09
    IF STATUS THEN
       CALL cl_err("OPEN t828_cl:", STATUS, 1)
       CLOSE t828_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t828_cl INTO g_piaa.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t828_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t828_i("u")                      # 欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_piaa.*=g_piaa_t.*
           CALL t828_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
{&}     IF g_piaa.piaa03 IS NULL THEN LET g_piaa.piaa03 = ' ' END IF
        IF g_piaa.piaa04 IS NULL THEN LET g_piaa.piaa04 = ' ' END IF
        IF g_piaa.piaa05 IS NULL THEN LET g_piaa.piaa05 = ' ' END IF
        LET g_piaa.piaa30 = g_qty
        LET g_piaa.piaa40 = g_qty
        UPDATE piaa_file SET piaa_file.* = g_piaa.*    # 更新DB
         WHERE piaa01 = g_piaa.piaa01 AND piaa09 = g_piaa.piaa09             # COLAUTH?
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_piaa.piaa01,SQLCA.sqlcode,0)
           CALL cl_err3("upd","piaa_file",g_piaa_t.piaa01,"",SQLCA.sqlcode,"","",1)   #NO.FUN-640266
           CONTINUE WHILE
        END IF
        IF cl_null(g_argv1) THEN
           LET l_sum1=0
           LET l_sum2=0
           SELECT SUM(piaa30*piaa10) INTO l_sum1 FROM piaa_file
            WHERE piaa01=g_piaa.piaa01
              AND piaa02=g_piaa.piaa02
              AND piaa03=g_piaa.piaa03
              AND piaa04=g_piaa.piaa04
              AND piaa05=g_piaa.piaa05
              AND piaa30 IS NOT NULL
              AND piaa10 IS NOT NULL
           SELECT SUM(piaa40*piaa10) INTO l_sum2 FROM piaa_file
            WHERE piaa01=g_piaa.piaa01
              AND piaa02=g_piaa.piaa02
              AND piaa03=g_piaa.piaa03
              AND piaa04=g_piaa.piaa04
              AND piaa05=g_piaa.piaa05
              AND piaa40 IS NOT NULL
              AND piaa10 IS NOT NULL
           IF cl_null(l_sum1) THEN
              LET l_sum1=0
           END IF
           IF cl_null(l_sum2) THEN
              LET l_sum2=0
           END IF
           #No.FUN-BB0086--add--start--
           SELECT pia09 INTO l_pia09 FROM pia_file WHERE pia01 = g_piaa.piaa01
           LET l_sum1 = s_digqty(l_sum1,l_pia09)
           LET l_sum2 = s_digqty(l_sum2,l_pia09)
           #No.FUN-BB0086--add--start--
           UPDATE pia_file SET pia30=l_sum1,pia40=l_sum2,
                               pia70=g_piaa.piaa70            #FUN-CB0087 add
            WHERE pia01=g_piaa.piaa01
              AND pia02=g_piaa.piaa02
              AND pia03=g_piaa.piaa03
              AND pia04=g_piaa.piaa04
              AND pia05=g_piaa.piaa05
           IF SQLCA.sqlcode THEN
#             CALL cl_err('upd_pia',SQLCA.sqlcode,1)
              CALL cl_err3("upd","pia_file",g_piaa.piaa01,g_piaa.piaa02,SQLCA.sqlcode,"",
                           "upd pia",1)   #NO.FUN-640266 #No.FUN-660156
           END IF 
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t828_cl
    COMMIT WORK
END FUNCTION
 
#No.FUN-BB0086--add--start--
FUNCTION t828_qty_check(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1
   IF NOT cl_null(g_qty) AND NOT cl_null(g_piaa.piaa09) THEN
      IF cl_null(g_qty_t) OR cl_null(g_piaa09_t) OR g_qty_t != g_qty OR g_piaa09_t != g_piaa.piaa09 THEN
         LET g_qty=s_digqty(g_qty,g_piaa.piaa09)
         DISPLAY g_qty TO FORMONLY.qty
      END IF
   END IF
   
   IF g_qty < 0 THEN
      RETURN FALSE,''
   END IF
   #TQC-D20047---mark---str---
   #IF p_cmd ='u' OR (p_cmd = 'a' AND g_piaa.piaa16 = 'N') THEN
   #   RETURN FALSE,'exitinput'
   #END IF
   #TQC-D20047---mark---end---
   RETURN TRUE,''
END FUNCTION 
#No.FUN-BB0086--add--end--
#FUN-CB0087---add---str---
FUNCTION t828_piaa70()
 IF g_piaa.piaa70 IS NOT NULL THEN
   SELECT azf03 INTO g_azf03
     FROM azf_file
    WHERE azf01 = g_piaa.piaa70
      AND azf02 = '2'
   DISPLAY g_azf03 TO azf03
 ELSE
   DISPLAY '' TO azf03
 END IF
END FUNCTION
#FUN-CB0087---add---end---


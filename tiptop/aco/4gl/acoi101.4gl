# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: acoi101.4gl
# Descriptions...: 海關商品編號資料維護作業
# Date & Author..: 00/04/20 By Kammy
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0023 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.MOD-490398 04/11/04 By Danny add cob09
# Modify.........: No.FUN-5B0043 05/11/04 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660045 06/06/12 By hellen cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/25 By Jackho 本（原）幣取位修改 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-6A0168 06/10/28 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750183 07/05/25 By Rayven 打印頁面中，規格這一列都向下去了一行
# Modify.........: No.FUN-770006 07/07/04 By zhoufeng 報表輸出改為Crystal Reports
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-840202 08/05/07 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30034 13/04/17 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cob   RECORD LIKE cob_file.*,
    g_cob_t RECORD LIKE cob_file.*,
    g_cob01_t LIKE cob_file.cob01,
    g_cof           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cof02       LIKE cof_file.cof02,   #
        cof03       LIKE cof_file.cof03    #
                    #FUN-840202 --start---
                    ,cofud01 LIKE cof_file.cofud01,
                    cofud02 LIKE cof_file.cofud02,
                    cofud03 LIKE cof_file.cofud03,
                    cofud04 LIKE cof_file.cofud04,
                    cofud05 LIKE cof_file.cofud05,
                    cofud06 LIKE cof_file.cofud06,
                    cofud07 LIKE cof_file.cofud07,
                    cofud08 LIKE cof_file.cofud08,
                    cofud09 LIKE cof_file.cofud09,
                    cofud10 LIKE cof_file.cofud10,
                    cofud11 LIKE cof_file.cofud11,
                    cofud12 LIKE cof_file.cofud12,
                    cofud13 LIKE cof_file.cofud13,
                    cofud14 LIKE cof_file.cofud14,
                    cofud15 LIKE cof_file.cofud15
                    #FUN-840202 --end--
                    END RECORD,
    g_cof_t         RECORD    #程式變數(Program Variables)
        cof02       LIKE cof_file.cof02,   #
        cof03       LIKE cof_file.cof03    #
                    #FUN-840202 --start---
                    ,cofud01 LIKE cof_file.cofud01,
                    cofud02 LIKE cof_file.cofud02,
                    cofud03 LIKE cof_file.cofud03,
                    cofud04 LIKE cof_file.cofud04,
                    cofud05 LIKE cof_file.cofud05,
                    cofud06 LIKE cof_file.cofud06,
                    cofud07 LIKE cof_file.cofud07,
                    cofud08 LIKE cof_file.cofud08,
                    cofud09 LIKE cof_file.cofud09,
                    cofud10 LIKE cof_file.cofud10,
                    cofud11 LIKE cof_file.cofud11,
                    cofud12 LIKE cof_file.cofud12,
                    cofud13 LIKE cof_file.cofud13,
                    cofud14 LIKE cof_file.cofud14,
                    cofud15 LIKE cof_file.cofud15
                    #FUN-840202 --end--
                    END RECORD,
    g_rec_b             LIKE type_file.num5,                #        #No.FUN-680069 SMALLINT
    l_ac                LIKE type_file.num5,          #No.FUN-680069 SMALLINT
    g_wc,g_wc2,g_sql    STRING  #No.FUN-580092 HCN        #No.FUN-680069
 
DEFINE g_forupd_sql          STRING   #SELECT ... FOR UPDATE SQL        #No.FUN-680069
DEFINE g_before_input_done   LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
DEFINE   g_chr          LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680069 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680069 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680069 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680069 SMALLINT
DEFINE   g_str          STRING                       #No.FUN-770006
DEFINE   l_table        STRING                       #No.FUN-770006
DEFINE g_argv1     LIKE cob_file.cob01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
    DEFINE
        p_row,p_col     LIKE type_file.num5          #No.FUN-680069 SMALLINT
#       l_time        LIKE type_file.chr8              #No.FUN-6A0063
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ACO")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
 
#No.FUN-770006 --start--
   LET g_sql="cobacti.cob_file.cobacti,cob01.cob_file.cob01,",
             "cob02.cob_file.cob02,cob021.cob_file.cob021,",
             "cob09.cob_file.cob09,cob04.cob_file.cob04,",
             "cof02.cof_file.cof02,cof03.cof_file.cof03,azi03.azi_file.azi03"
   LET l_table = cl_prt_temptable('acoi101',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770006 --end--
 
    INITIALIZE g_cob.* TO NULL
 
    LET g_forupd_sql = " SELECT * FROM cob_file ",
                       " WHERE cob01 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 4 LET p_col = 20
    OPEN WINDOW i101_w AT p_row,p_col
        WITH FORM "aco/42f/acoi101"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i101_a()
            END IF
         OTHERWISE        
            CALL i101_q() 
      END CASE
   END IF
   #--
 
    CALL i101_menu()
    CLOSE WINDOW i101_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION i101_curs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
   CALL g_cof.clear()
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_cob.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" cob01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
   ELSE
 
    CONSTRUCT BY NAME g_wc ON                      # 螢幕上取條件
        #modify No.8392
         cob01,cob02,cob021,cob09,cob03,cob10,cob04,cob08,   #No.MOD-490398
         cobuser,cobgrup,cobmodu,cobdate,cobacti
         #FUN-840202   ---start---
         ,cobud01,cobud02,cobud03,cobud04,cobud05,
         cobud06,cobud07,cobud08,cobud09,cobud10,
         cobud11,cobud12,cobud13,cobud14,cobud15
         #FUN-840202    ----end----
 
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
    ON ACTION controlp                        # 沿用所有欄位
           CASE
              WHEN INFIELD(cob04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_gfe"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cob04
                 NEXT FIELD cob04
              WHEN INFIELD(cob10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_geb"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cob10
                 NEXT FIELD cob10
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON cof02,cof03 
           #No.FUN-840202 --start--
           ,cofud01,cofud02,cofud03,cofud04,cofud05
           ,cofud06,cofud07,cofud08,cofud09,cofud10
           ,cofud11,cofud12,cofud13,cofud14,cofud15
           #No.FUN-840202 ---end---
 
      FROM s_cof[1].cof02,s_cof[1].cof03
           #No.FUN-840202 --start--
           ,s_cof[1].cofud01,s_cof[1].cofud02,s_cof[1].cofud03,s_cof[1].cofud04,s_cof[1].cofud05
           ,s_cof[1].cofud06,s_cof[1].cofud07,s_cof[1].cofud08,s_cof[1].cofud09,s_cof[1].cofud10
           ,s_cof[1].cofud11,s_cof[1].cofud12,s_cof[1].cofud13,s_cof[1].cofud14,s_cof[1].cofud15
           #No.FUN-840202 ---end---
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
            CASE
              WHEN INFIELD(cof02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state ="c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO cof02
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
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND cobuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND cobgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND cobgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cobuser', 'cobgrup')
    #End:FUN-980030
 
 
    IF g_wc2=" 1=1" THEN
       LET g_sql="SELECT cob01 FROM cob_file ", # 組合出 SQL 指令
                 " WHERE ",g_wc CLIPPED, " ORDER BY cob01"
    ELSE
        LET g_sql="SELECT UNIQUE cob01",     #No.MOD-490398
                 "  FROM cob_file,cof_file ",
                 " WHERE ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED,
                 "   AND cob01 = cof01 ",
                 " ORDER BY cob01 "
    END IF
    PREPARE i101_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i101_cs                                # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
     #No.MOD-490398
    IF g_wc2=" 1=1" THEN
       LET g_sql= "SELECT COUNT(*) FROM cob_file ",
                  " WHERE ",g_wc CLIPPED
    ELSE
       LET g_sql= "SELECT COUNT(DISTINCT cob01) FROM cob_file,cof_file ",
                  " WHERE cob01 = cof01 ",
                  "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
     END IF    #No.MOD-490398 end
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count CURSOR FOR i101_precount
END FUNCTION
 
FUNCTION i101_menu()
 
   WHILE TRUE
      CALL i101_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i101_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i101_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i101_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i101_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i101_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i101_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i101_cof_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL i101_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         #FUN-4B0023
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_cof),'','')
             END IF
         #--
 
         #No.FUN-6A0168-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_cob.cob01 IS NOT NULL THEN
                 LET g_doc.column1 = "cob01"
                 LET g_doc.value1 = g_cob.cob01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0168-------add--------end----
 
      END CASE
   END WHILE
      CLOSE i101_cs
END FUNCTION
 
FUNCTION i101_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    CALL g_cof.clear()
    INITIALIZE g_cob.* LIKE cob_file.*
    LET g_cob01_t = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_cob.cobuser = g_user
        LET g_cob.cobgrup = g_grup               #用戶所屬群
        LET g_cob.cobdate = g_today
        LET g_cob.cobacti = 'Y'
        CALL i101_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_cob.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_cof.clear()
            EXIT WHILE
        END IF
        IF cl_null(g_cob.cob01) THEN CONTINUE WHILE END IF # KEY 不可空白
        LET g_cob.coboriu = g_user      #No.FUN-980030 10/01/04
        LET g_cob.coborig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO cob_file VALUES(g_cob.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            LET g_msg = g_cob.cob01 clipped
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cob_file",g_cob.cob01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        ELSE
            SELECT cob01 INTO g_cob.cob01 FROM cob_file
                     WHERE cob01 = g_cob.cob01
        END IF
        FOR g_cnt = 1 TO g_cof.getLength()           #單身 ARRAY 乾洗
           INITIALIZE g_cof[g_cnt].* TO NULL
        END FOR
        LET g_rec_b=0
        CALL i101_cof_b()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
        l_n             LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
    DISPLAY BY NAME
        g_cob.cobuser,g_cob.cobgrup,g_cob.cobmodu,g_cob.cobdate,g_cob.cobacti
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT BY NAME
        #modify 031001 No.8392
         g_cob.cob01,g_cob.cob02,g_cob.cob021,g_cob.cob09,   #No.MOD-490398
        g_cob.cob03,g_cob.cob10,
        g_cob.cob04,g_cob.cob08,g_cob.cobuser,g_cob.cobgrup,
        g_cob.cobmodu,g_cob.cobdate,g_cob.cobacti
        #FUN-840202     ---start---
        ,g_cob.cobud01,g_cob.cobud02,g_cob.cobud03,g_cob.cobud04,
        g_cob.cobud05,g_cob.cobud06,g_cob.cobud07,g_cob.cobud08,
        g_cob.cobud09,g_cob.cobud10,g_cob.cobud11,g_cob.cobud12,
        g_cob.cobud13,g_cob.cobud14,g_cob.cobud15 
        #FUN-840202     ----end----
 
        WITHOUT DEFAULTS
 
       BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i101_set_entry(p_cmd)
            CALL i101_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
       AFTER FIELD cob03
            IF NOT cl_null(g_cob.cob03) THEN
               IF g_cob.cob03 NOT MATCHES '[123]' THEN
                  NEXT FIELD cob03
               END IF
            END IF
 
       AFTER FIELD cob10
            IF NOT cl_null(g_cob.cob10) THEN
               CALL i101_geb(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  LET g_cob.cob10 = g_cob_t.cob10
                  DISPLAY BY NAME g_cob.cob10
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD cob10
               END IF
            END IF
 
       AFTER FIELD cob04
            IF NOT cl_null(g_cob.cob04) THEN
               CALL i101_gfe(g_cob.cob04)
               IF NOT cl_null(g_errno) THEN
                  LET g_cob.cob04 = g_cob_t.cob04
                  DISPLAY BY NAME g_cob.cob04
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD cob04
               END IF
            END IF
 
        #FUN-840202     ---start---
        AFTER FIELD cobud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cobud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
 
        ON ACTION controlp     #ok                   # 沿用所有欄位
           CASE
              WHEN INFIELD(cob04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_cob.cob04
                 CALL cl_create_qry() RETURNING g_cob.cob04
#                 CALL FGL_DIALOG_SETBUFFER( g_cob.cob04 )
                  DISPLAY g_cob.cob04 TO cob04          #No.MOD-490371
                 NEXT FIELD cob04
              WHEN INFIELD(cob10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_geb"
                 LET g_qryparam.default1 = g_cob.cob10
                 CALL cl_create_qry() RETURNING g_cob.cob10
#                 CALL FGL_DIALOG_SETBUFFER( g_cob.cob10 )
                 DISPLAY BY NAME g_cob.cob10
                 NEXT FIELD cob10
              OTHERWISE EXIT CASE
            END CASE
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(cob01) THEN
        #        LET g_cob.* = g_cob_t.*
        #        CALL i101_show()
        #        NEXT FIELD cob01
        #    END IF
        #MOD-650015 --end
 
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
FUNCTION i101_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("cob01",TRUE)
    END IF
 
END FUNCTION
FUNCTION i101_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cob01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i101_geb(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680069 VARCHAR(1)
           l_geb02   LIKE geb_file.geb02,
           l_gebacti LIKE geb_file.gebacti
 
    LET g_errno = ' '
    SELECT geb02,gebacti INTO l_geb02,l_gebacti
           FROM geb_file WHERE geb01 = g_cob.cob10
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aom-012'
                                   LET l_geb02 = ' ' LET l_gebacti = NULL
         WHEN l_gebacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
       DISPLAY  l_geb02 TO FORMONLY.geb02
    END IF
END FUNCTION
 
FUNCTION i101_gfe(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i101_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cob.* TO NULL                #No.FUN-6A0168
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_cof.clear()
        RETURN
    END IF
    OPEN i101_count
    FETCH i101_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i101_cs                            # 從DB生成合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cob.cob01 clipped
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cob.* TO NULL
    ELSE
        CALL i101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i101_fetch(p_flcob)
    DEFINE
        p_flcob          LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        l_abso           LIKE type_file.num10         #No.FUN-680069 INTEGER
 
    CASE p_flcob
        WHEN 'N' FETCH NEXT     i101_cs INTO g_cob.cob01
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_cob.cob01
        WHEN 'F' FETCH FIRST    i101_cs INTO g_cob.cob01
        WHEN 'L' FETCH LAST     i101_cs INTO g_cob.cob01
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i101_cs INTO g_cob.cob01
           LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cob.cob01 clipped
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        INITIALIZE g_cob.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcob
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cob.* FROM cob_file            # 重讀DB,因TEMP有不被更新特性
       WHERE cob01 = g_cob.cob01
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cob.cob01 clipped
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("sel","cob_file",g_cob.cob01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
    ELSE
        CALL i101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i101_show()
  LET g_cob_t.* = g_cob.*
 
   #No.MOD-490398
  DISPLAY BY NAME g_cob.cob01,g_cob.cob02,g_cob.cob021,g_cob.cob09,
                  g_cob.cob03,g_cob.cob10,
                  g_cob.cob04,g_cob.cob08,g_cob.cobuser,g_cob.cobgrup,
                  g_cob.cobmodu,g_cob.cobacti,g_cob.cobdate
                  #FUN-840202     ---start---
                  ,g_cob.cobud01,g_cob.cobud02,g_cob.cobud03,g_cob.cobud04,
                  g_cob.cobud05,g_cob.cobud06,g_cob.cobud07,g_cob.cobud08,
                  g_cob.cobud09,g_cob.cobud10,g_cob.cobud11,g_cob.cobud12,
                  g_cob.cobud13,g_cob.cobud14,g_cob.cobud15 
                  #FUN-840202     ----end----
    CALL cl_set_field_pic("","","","","",g_cob.cobacti)
 
    CALL i101_geb('d')
    CALL i101_cof_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cob.cob01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cob.* FROM cob_file WHERE cob01=g_cob.cob01
    IF g_cob.cobacti = 'N' THEN
        CALL cl_err('',9027,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_cob01_t = g_cob.cob01
    BEGIN WORK
 
    OPEN i101_cl USING g_cob.cob01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_cob.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cob.cob01 clipped
        CALL cl_err(g_msg,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_cob.cobmodu=g_user                     #更改者
    LET g_cob.cobdate = g_today                  #更改日期
    CALL i101_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i101_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cob.*=g_cob_t.*
            CALL i101_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cob_file SET cob_file.* = g_cob.*    # 更新DB
            WHERE cob01 = g_cob.cob01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_msg = g_cob.cob01 clipped
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cob_file",g_cob01_t,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_x()
    IF s_shut(0) THEN RETURN END IF
    IF g_cob.cob01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i101_cl USING g_cob.cob01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_cob.*
    IF SQLCA.sqlcode THEN
       LET g_msg = g_cob.cob01 clipped
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i101_show()
    IF cl_exp(0,0,g_cob.cobacti) THEN
        LET g_chr=g_cob.cobacti
        IF g_cob.cobacti='Y' THEN
            LET g_cob.cobacti='N'
        ELSE
            LET g_cob.cobacti='Y'
        END IF
        UPDATE cob_file
            SET cobacti=g_cob.cobacti
            WHERE cob01=g_cob.cob01
        IF SQLCA.SQLERRD[3]=0 THEN
            LET g_msg = g_cob.cob01 clipped
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("upd","cob_file",g_cob.cob01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            LET g_cob.cobacti=g_chr
        END IF
        DISPLAY BY NAME g_cob.cobacti
    END IF
    CLOSE i101_cl
    COMMIT WORK
 
    CALL cl_set_field_pic("","","","","",g_cob.cobacti)
 
END FUNCTION
 
FUNCTION i101_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_cob.cob01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i101_cl USING g_cob.cob01
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_cob.*
    IF SQLCA.sqlcode THEN
       LET g_msg = g_cob.cob01 clipped
       CALL cl_err(g_msg,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL i101_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cob01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cob.cob01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM cob_file WHERE cob01 = g_cob.cob01
       DELETE FROM cof_file WHERE cof01 = g_cob.cob01
       CLEAR FORM
       CALL g_cof.clear()
       OPEN i101_count
       #FUN-B50062-add-start--
       IF STATUS THEN
          CLOSE i101_cs
          CLOSE i101_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       FETCH i101_count INTO g_row_count
       #FUN-B50062-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE i101_cs
          CLOSE i101_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50062-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN i101_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL i101_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL i101_fetch('/')
       END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_copy()
    DEFINE
        l_newno         LIKE cob_file.cob01,
        l_oldno         LIKE cob_file.cob01
 
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_cob.cob01) THEN CALL cl_err('',-400,0) RETURN END IF
 
    LET g_before_input_done = FALSE
    CALL i101_set_entry('a')
    CALL i101_set_no_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
    INPUT l_newno FROM cob01
        AFTER FIELD cob01
            IF NOT cl_null(l_newno) THEN
               SELECT count(*) INTO g_cnt FROM cob_file
                   WHERE cob01 = l_newno
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno clipped
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD cob01
               END IF
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
        DISPLAY BY NAME g_cob.cob01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM cob_file
        WHERE cob01=g_cob.cob01
        INTO TEMP x
    UPDATE x
        SET cob01=l_newno,    #資料鍵值
            cobacti='Y',      #資料有效碼
            cobuser=g_user,   #資料所有者
            cobgrup=g_grup,   #資料所有者所屬群
            cobmodu=NULL,     #資料更改日期
            cobdate=g_today   #資料建立日期
    INSERT INTO cob_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        LET g_msg = g_cob.cob01 clipped
#       CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
        CALL cl_err3("ins","cob_file",g_cob.cob01,"",SQLCA.sqlcode,"","",1)  #TQC-660045 
    ELSE
        LET g_msg = g_cob.cob01 clipped
        MESSAGE 'ROW(',g_msg,') O.K'
        DROP TABLE y
        SELECT * FROM cof_file         #單身複製
            WHERE cof01=g_cob.cob01
            INTO TEMP y
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","y",g_cob.cob01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            RETURN
        END IF
        UPDATE y
            SET cof01=l_newno
        INSERT INTO cof_file
        SELECT * FROM y
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_msg,SQLCA.sqlcode,0) #No.TQC-660045
            CALL cl_err3("ins","cof_file",g_cob.cob01,"",SQLCA.sqlcode,"","",1)  #TQC-660045
            RETURN
        END IF
        LET g_cnt=SQLCA.sqlcode
        MESSAGE '(',g_cnt USING '##&',') ROW of (',g_msg,') O.K'
 
        LET l_oldno  = g_cob.cob01
        LET g_cob.cob01 = l_newno
        SELECT cob_file.* INTO g_cob.* FROM cob_file
               WHERE cob01 = l_newno
        CALL i101_u()
        CALL i101_cof_b()
        #SELECT cob_file.* INTO g_cob.* FROM cob_file #FUN-C30027
        #       WHERE cob01 = l_oldno                 #FUN-C30027
    END IF
    #LET g_cob.cob01 = l_oldno                        #FUN-C30027
    CALL i101_show()
END FUNCTION
 
FUNCTION i101_cof_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未撤銷的ARRAY CNT        #No.FUN-680069 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680069 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680069 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680069 VARCHAR(1)
    l_cmd           LIKE cob_file.cob08,          #No.FUN-680069 VARCHAR(30)
    #l_sql           LIKE type_file.chr1000,       #No.FUN-680069 VARCHAR(300)
    l_sql           STRING,      #NO.FUN-910082
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680069 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680069 SMALLINT
 
    LET g_action_choice = ""
    IF cl_null(g_cob.cob01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_cob.cobacti = 'N' THEN CALL cl_err('',9027,0) RETURN END IF
    LET g_forupd_sql = " SELECT cof02,cof03,",
                       "cofud01,cofud02,cofud03,cofud04,cofud05,",
                       "cofud06,cofud07,cofud08,cofud09,cofud10,",
                       "cofud11,cofud12,cofud13,cofud14,cofud15",
                       " FROM cof_file ",
                       "  WHERE cof01 = ? ",
                       "    AND cof02 = ? ",
                       " FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   IF g_rec_b=0 THEN CALL g_cof.clear() END IF
 
   INPUT ARRAY g_cof WITHOUT DEFAULTS FROM s_cof.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
 
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
            OPEN i101_cl USING g_cob.cob01
            IF STATUS THEN
               CALL cl_err("OPEN i101_cl:", STATUS, 1)
               CLOSE i101_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i101_cl INTO g_cob.*
            IF SQLCA.sqlcode THEN
                LET g_msg = g_cob.cob01 clipped
                CALL cl_err(g_msg,SQLCA.sqlcode,0)
                CLOSE i101_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_cof_t.* = g_cof[l_ac].*  #BACKUP
                OPEN i101_bcl USING g_cob.cob01, g_cof_t.cof02
                IF STATUS THEN
                   CALL cl_err("OPEN i101_bcl:", STATUS, 1)
                   CLOSE i101_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH i101_bcl INTO g_cof[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_cof_t.cof02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
           #NEXT FIELD cof02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
              INITIALIZE g_cof[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_cof[l_ac].* TO s_cof.*
              CALL g_cof.deleteElement(g_rec_b+1)
              ROLLBACK WORK
 
              #CANCEL INSERT
               EXIT INPUT
            END IF
            INSERT INTO cof_file(cof01,cof02,cof03,
                               #FUN-840202 --start--
                                  cofud01,cofud02,cofud03,
                                  cofud04,cofud05,cofud06,
                                  cofud07,cofud08,cofud09,
                                  cofud10,cofud11,cofud12,
                                  cofud13,cofud14,cofud15)
                                  #FUN-840202 --end--   
             VALUES(g_cob.cob01,
                    g_cof[l_ac].cof02,g_cof[l_ac].cof03,
                    #FUN-840202 --start--
                    g_cof[l_ac].cofud01, g_cof[l_ac].cofud02,
                    g_cof[l_ac].cofud03, g_cof[l_ac].cofud04,
                    g_cof[l_ac].cofud05, g_cof[l_ac].cofud06,
                    g_cof[l_ac].cofud07, g_cof[l_ac].cofud08,
                    g_cof[l_ac].cofud09, g_cof[l_ac].cofud10,
                    g_cof[l_ac].cofud11, g_cof[l_ac].cofud12,
                    g_cof[l_ac].cofud13, g_cof[l_ac].cofud14,
                    g_cof[l_ac].cofud15)
                    #FUN-840202 --end-
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_cof[l_ac].cof02,SQLCA.sqlcode,0) #No.TQC-660045
               CALL cl_err3("ins","cof_file",g_cob.cob01,g_cof[l_ac].cof02,SQLCA.sqlcode,"","",1)  #TQC-660045
               LET g_cof[l_ac].* = g_cof_t.*
            ELSE
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE 'INSERT O.K'
               COMMIT WORK
            END IF
 
        BEFORE INSERT
 
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_cof[l_ac].* TO NULL      #900423
            LET g_cof_t.* = g_cof[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD cof02
 
        AFTER FIELD cof02
            IF g_cof[l_ac].cof02 IS NOT NULL AND
               (g_cof[l_ac].cof02 != g_cof_t.cof02 OR
                g_cof_t.cof02 IS NULL ) THEN
                SELECT count(*) INTO l_n FROM cof_file
                    WHERE cof01 = g_cob.cob01
                      AND cof02 = g_cof[l_ac].cof02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_cof[l_ac].cof02 = g_cof_t.cof02
                    NEXT FIELD cof02
                END IF
            END IF
            IF NOT cl_null(g_cof[l_ac].cof02) THEN
               CALL i101_cof02('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_cof[l_ac].cof02,g_errno,0)
                  LET g_cof[l_ac].cof02 = g_cof_t.cof02
                  NEXT FIELD cof02
               END IF
            END IF
 
       AFTER FIELD cof03
            IF NOT cl_null(g_cof[l_ac].cof03) THEN
               IF g_cof[l_ac].cof03 < 0  THEN
                  LET g_cof[l_ac].cof03=g_cof_t.cof03
                  DISPLAY g_cof[l_ac].cof03 TO cof03
                  NEXT FIELD cof03
               END IF
            END IF
 
        #No.FUN-840202 --start--
        AFTER FIELD cofud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD cofud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
 
       BEFORE DELETE                            #是否撤銷單身
            IF g_cof_t.cof02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM cof_file
                    WHERE cof01 = g_cob.cob01 AND
                          cof02 = g_cof_t.cof02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_cof_t.cof02,SQLCA.sqlcode,0) #No.TQC-660045
                    CALL cl_err3("del","cof_file",g_cob.cob01,g_cof_t.cof02,SQLCA.sqlcode,"","",1)  #TQC-660045
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
 
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_cof[l_ac].* = g_cof_t.*
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_cof[l_ac].cof02,-263,1)
               LET g_cof[l_ac].* = g_cof_t.*
            ELSE
               UPDATE cof_file SET
                            cof02=g_cof[l_ac].cof02,
                            cof03=g_cof[l_ac].cof03,
                            #FUN-840202 --start--
                            cofud01 = g_cof[l_ac].cofud01,
                            cofud02 = g_cof[l_ac].cofud02,
                            cofud03 = g_cof[l_ac].cofud03,
                            cofud04 = g_cof[l_ac].cofud04,
                            cofud05 = g_cof[l_ac].cofud05,
                            cofud06 = g_cof[l_ac].cofud06,
                            cofud07 = g_cof[l_ac].cofud07,
                            cofud08 = g_cof[l_ac].cofud08,
                            cofud09 = g_cof[l_ac].cofud09,
                            cofud10 = g_cof[l_ac].cofud10,
                            cofud11 = g_cof[l_ac].cofud11,
                            cofud12 = g_cof[l_ac].cofud12,
                            cofud13 = g_cof[l_ac].cofud13,
                            cofud14 = g_cof[l_ac].cofud14,
                            cofud15 = g_cof[l_ac].cofud15
                            #FUN-840202 --end-- 
                WHERE cof01 = g_cob.cob01
                  AND cof02 = g_cof_t.cof02
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_cof[l_ac].cof02,SQLCA.sqlcode,0) #No.TQC-660045
                   CALL cl_err3("upd","cof_file",g_cob.cob01,g_cof_t.cof02,SQLCA.sqlcode,"","",1)  #TQC-660045
                   LET g_cof[l_ac].* = g_cof_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D30034 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
 
               IF p_cmd='u' THEN
                  LET g_cof[l_ac].* = g_cof_t.*
               #FUN-D30034--add--str--
               ELSE
                  CALL g_cof.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end--
               END IF
               CLOSE i101_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D30034 Add 
           #LET g_cof_t.* = g_cof[l_ac].*          # 900423
            CLOSE i101_bcl
            COMMIT WORK
 
           #CALL g_cof.deleteElement(g_rec_b+1)    #FUN-D30034 Mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(cof02) AND l_ac > 1 THEN
                LET g_cof[l_ac].* = g_cof[l_ac-1].*
                DISPLAY g_cof[l_ac].* TO s_cof[l_ac].*
                NEXT FIELD cof02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
            CASE
              WHEN INFIELD(cof02)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_cof[l_ac].cof02
                 CALL cl_create_qry() RETURNING g_cof[l_ac].cof02
                 DISPLAY g_cof[l_ac].cof02 TO s_cpf[l_ac].cof02
#                 CALL FGL_DIALOG_SETBUFFER( g_cof[l_ac].cof02 )
                    DISPLAY BY NAME g_cof[l_ac].cof02     #No.MOD-490371
                 NEXT FIELD cof02
            END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
        END INPUT
 
        #FUN-5B0043-begin
         LET g_cob.cobmodu = g_user
         LET g_cob.cobdate = g_today
         UPDATE cob_file SET cobmodu = g_cob.cobmodu,cobdate = g_cob.cobdate
          WHERE cob01 = g_cob.cob01
         DISPLAY BY NAME g_cob.cobmodu,g_cob.cobdate
        #FUN-5B0043-end
 
        CLOSE i101_bcl
        COMMIT WORK
        CALL i101_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i101_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM cob_file WHERE cob01 = g_cob.cob01
         INITIALIZE g_cob.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i101_cof02(p_cmd)
 DEFINE p_cmd LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 DEFINE t_azi RECORD LIKE azi_file.*       #No.CHI-6A0004 g_azi-->t_azi
 
    SELECT * INTO t_azi.* FROM azi_file WHERE azi01 = g_cof[l_ac].cof02        #No.CHI-6A0004 g_azi-->t_azi
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
         WHEN t_azi.aziacti = 'N' LET g_errno = '9028'                         #No.CHI-6A0004 g_azi-->t_azi                                        
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
END FUNCTION
 
FUNCTION i101_cof_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc    LIKE type_file.chr1000          #No.FUN-680069 VARCHAR(200)
 
    LET g_sql =
       "SELECT cof02,cof03,",
        #No.FUN-840202 --start--
        "cofud01,cofud02,cofud03,cofud04,cofud05,",
        "cofud06,cofud07,cofud08,cofud09,cofud10,",
        "cofud11,cofud12,cofud13,cofud14,cofud15", 
        #No.FUN-840202 ---end--- 
       " FROM cof_file ",
       " WHERE cof01 = '",g_cob.cob01,"'" 
    #No.FUN-8B0123---Begin
    #  "   AND ",p_wc CLIPPED,
    #  " ORDER BY 1"
    IF NOT cl_null(p_wc) THEN
       LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
    END IF 
    LET g_sql=g_sql CLIPPED," ORDER BY 1 " 
    DISPLAY g_sql
    #No.FUN-8B0123---End
 
    PREPARE i101_cof_prepare2 FROM g_sql   #預備一下
    DECLARE cof_curs CURSOR FOR i101_cof_prepare2
    CALL g_cof.clear()
    LET g_rec_b=0
    LET g_cnt = 1
    MESSAGE " Wait "
    FOREACH cof_curs INTO g_cof[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
 
    MESSAGE ""
    CALL g_cof.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
 
END FUNCTION
 
FUNCTION i101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680069 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cof TO s_cof.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i101_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i101_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i101_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i101_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i101_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET l_ac = 1
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_cob.cobacti)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0023
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
      ON ACTION related_document                #No.FUN-6A0168  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i101_out()
    DEFINE
        l_i          LIKE type_file.num5,          #No.FUN-680069 SMALLINT
        l_cob        RECORD LIKE cob_file.*,
        l_name       LIKE type_file.chr20,         #No.FUN-680069 VARCHAR(20)               # External(Disk) file name
        l_za05       LIKE cob_file.cob01           #No.FUN-680069 VARCHAR(40)
    #No.FUN-770006 --start--
    DEFINE 
        l_azi03         LIKE azi_file.azi03,             
        l_cof02         LIKE cof_file.cof02,                  
        l_cof03         LIKE cof_file.cof03,                      
        l_cnt           LIKE type_file.num5,
        l_cobacti       LIKE cob_file.cobacti,
        l_sql           LIKE type_file.chr1000   
    #No.FUN-770006 --end--
    CALL cl_del_data(l_table)                      #No.FUN-770006
 
    IF cl_null(g_wc) AND NOT cl_null(g_cob.cob01) THEN
       LET g_wc=" cob01='",g_cob.cob01,"'"
    END IF
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT cof02,cof03,azi03 FROM cof_file,azi_file ",
              " WHERE azi01 = cof02 AND cof01 = ? "
    PREPARE i101_precof FROM g_sql            # RUNTIME 編譯
    DECLARE i101_cofcur CURSOR FOR i101_precof
 
    LET g_sql="SELECT cob_file.* ",
              "  FROM cob_file ",
              " WHERE  ",g_wc CLIPPED
    PREPARE i101_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i101_curo                         # SCROLL CURSOR
        SCROLL CURSOR FOR i101_p1
#   CALL cl_outnam('acoi101') RETURNING l_name#No.FUN-770006
#   START REPORT i101_rep TO l_name           #No.FUN-770006
 
    FOREACH i101_curo INTO l_cob.*
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
    #NO.FUN-770006 --start--
        IF l_cob.cobacti = 'N' THEN
           LET l_cobacti = '*'
        ELSE
           LET l_cobacti = ' '
        END IF
        LET l_cnt = 0                                                       
        OPEN i101_cofcur USING l_cob.cob01                                     
        IF STATUS THEN CALL cl_err('i101_cofcur',STATUS,0) END IF       
        FOREACH i101_cofcur USING l_cob.cob01 INTO l_cof02,l_cof03,l_azi03 
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
            EXECUTE insert_prep USING l_cobacti,l_cob.cob01,l_cob.cob02,
                                      l_cob.cob021,l_cob.cob09,l_cob.cob04,
                                      l_cof02,l_cof03,l_azi03
            LET l_cnt = l_cnt+1
        END FOREACH
        IF l_cnt = 0 THEN
            EXECUTE insert_prep USING l_cobacti,l_cob.cob01,l_cob.cob02, 
                                      l_cob.cob021,l_cob.cob09,l_cob.cob04,
                                      '','',''
        END IF
        #No.FUN-770006 --end--
#       OUTPUT TO REPORT i101_rep(l_cob.*)            #No.FUN-770006
    END FOREACH
 
#   FINISH REPORT i101_rep                            #No.FUN-770006
 
    CLOSE i101_curo
    ERROR ""
    #No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(g_wc,'cob01,cob02,cob021,cob09,cob03,cob10,cob04,cob08,   
                           cobuser,cobgrup,cobmodu,cobdate,cobacti')            
            RETURNING g_wc                                                     
       LET g_str = g_wc                                                        
    END IF                                                                      
    LET g_str = g_str
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED
    CALL cl_prt_cs3('acoi101','acoi101',l_sql,g_str)
    #No.FUN-770006
#   CALL cl_prt(l_name,' ','1',g_len)                #No.FUN-770006
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i101_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680069 VARCHAR(1)
        sr      RECORD  LIKE cob_file.*,
        l_azi03         LIKE azi_file.azi03,
        l_cof02         LIKE cof_file.cof02,
        l_cof03         LIKE cof_file.cof03,
        l_cnt           LIKE type_file.num5          #No.FUN-680069 SMALLINT
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.cob01
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno=g_pageno+1
            LET pageno_total=PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[38],g_x[31],g_x[32],g_x[33],g_x[34],
                  g_x[35],g_x[36],g_x[37]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
            IF sr.cobacti = 'N' THEN
               PRINT COLUMN g_c[38],'* ';
            END IF
 
             #No.MOD-490398
            PRINT COLUMN g_c[31],sr.cob01,
                  COLUMN g_c[32],sr.cob02,
                  COLUMN g_c[33],sr.cob021,  #No.TQC-750183
                  COLUMN g_c[34],sr.cob09,
                  COLUMN g_c[35],sr.cob04;
            LET l_cnt = 0
            OPEN i101_cofcur USING sr.cob01
            IF STATUS THEN CALL cl_err('i101_cofcur',STATUS,0) END IF
#           FOREACH i101_cofcur INTO l_cof02,l_cof03,l_azi03  #No.TQC-750183 mark
            FOREACH i101_cofcur USING sr.cob01 INTO l_cof02,l_cof03,l_azi03  #No.TQC-750183
               IF SQLCA.sqlcode THEN EXIT FOREACH END IF
               #modify 031001 No.8392
#No.TQC-750183 --start-- mark
#              IF l_cnt = 1 AND NOT cl_null(sr.cob021) THEN
#                 PRINT COLUMN g_c[33],sr.cob021;
#              END IF
#No.TQC-750183 --end--
               PRINT COLUMN g_c[36],l_cof02,
                     COLUMN g_c[37],cl_numfor(l_cof03,37,l_azi03)
                #No.MOD-490398 end
               LET l_cnt = l_cnt + 1
            END FOREACH
#No.TQC-750183 --start--
            IF l_cnt = 0 THEN
               PRINT ' '
            END IF
#           IF l_cnt = 1 AND NOT cl_null(sr.cob021) THEN
#              PRINT COLUMN g_c[33],sr.cob021
#           END IF
#           IF l_cnt = 0 THEN
#              IF NOT cl_null(sr.cob021) THEN
#                 PRINT ' '
#                 PRINT COLUMN g_c[33],sr.cob021
#              ELSE
#                 PRINT ' '
#              END IF
#           END IF
#           #No.8392 end
#No.TQC-750183 --end--
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770006 --end--

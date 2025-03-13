# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: amsi102.4gl
# Descriptions...: 時距資料維護作業
# Date & Author..: 91/11/15 By Lee
# Modification History
#                : 92/12/28 BY Apple 36 個buck 的天數必需大於零
# Modify.........: No.FUN-4C0041 04/12/07 By pengu Data and Group權限控管
# Modify.........: No.FUN-510036 05/01/18 By pengu 報表轉XML
# Modify.........: No.TQC-5B0019 05/11/04 By Sarah 報表表尾超出報表寬度
# Modify.........: No.TQC-5C0005 05/12/05 By kevin 結束位置調整
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660108 06/06/12 BY cheunl  cl_err --->cl_err3
# Modify.........: No.FUN-680101 06/08/29 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0150 06/10/27 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0081 06/11/06 By atsea l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-770012 07/07/06 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.TQC-970170 09/07/22 By lilingyu 點查詢,報錯:-201,發生語法錯誤
# Modify.........: No.TQC-980057 09/08/10 By liuxqa 資料無效時，不可刪除。
# Modify.........: No.TQC-970248 09/07/23 By dxfwo  FETCH ABSOLUTE l_abso amsi102_curs INTO g_rpg.rpg01這邊在撈應該用FETCH ABSOLUTE g_jump，否則刪除完數據后，會撈不到數據
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rpg   RECORD LIKE rpg_file.*,
    g_rpg_t RECORD LIKE rpg_file.*,
    g_rpg_o RECORD LIKE rpg_file.*,
    g_wc,g_sql       STRING  #TQC-630166
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE   g_chr           LIKE type_file.chr1          #NO.FUN-680101 VARCHAR(1) 
DEFINE   g_cnt           LIKE type_file.num10         #NO.FUN-680101 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose   #NO.FUN-680101 SMALLINT 
DEFINE   g_msg           LIKE type_file.chr1000       #NO.FUN-680101 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #NO.FUN-680101 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #NO.FUN-680101 INTEGER
DEFINE   g_jump          LIKE type_file.num10,        #NO.FUN-680101 INTEGER
         mi_no_ask       LIKE type_file.num5          #NO.FUN-680101 SMALLINT
#No.FUN-770012 -- begin --
DEFINE g_sql1     STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-770012 -- end --
DEFINE g_argv1     LIKE rpg_file.rpg01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8            #No.FUN-6A0081
    DEFINE p_row,p_col   LIKE type_file.num5          #NO.FUN-680101 SMALLINT
 
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
   LET g_sql1 = "rpg01.rpg_file.rpg01,",
                "rpg02.rpg_file.rpg02,",
                "rpg101.rpg_file.rpg101,",
                "rpgacti.rpg_file.rpgacti"
   LET l_table = cl_prt_temptable('amsi102',g_sql1) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?)"
   PREPARE insert_prep FROM g_sql1
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-770012 --end
    INITIALIZE g_rpg.* TO NULL
    INITIALIZE g_rpg_t.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM rpg_file WHERE rpg01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE amsi102_curl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 4 LET p_col = 8
    OPEN WINDOW amsi102_w AT p_row,p_col
      WITH FORM "ams/42f/amsi102"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   #FUN-7C0050
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL amsi102_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL amsi102_a()
            END IF
         OTHERWISE        
            CALL amsi102_q() 
      END CASE
   END IF
   #--
    LET g_action_choice=""
    CALL amsi102_menu()
 
    CLOSE WINDOW amsi102_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0081
END MAIN
 
FUNCTION amsi102_curs()
    CLEAR FORM
   INITIALIZE g_rpg.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" rpg01='",g_argv1,"'"       #FUN-7C0050
   ELSE
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
       #rpg01,rpg02,rpg101,           #TQC-970170
        rpg01,rpg02,                  #TQC-970170
        rpg101,rpg102,rpg103,rpg104,
        rpg105,rpg106,rpg107,rpg108,
        rpg109,rpg110,rpg111,rpg112,
        rpg113,rpg114,rpg115,rpg116,
        rpg117,rpg118,rpg119,rpg120,
        rpg121,rpg122,rpg123,rpg124,
        rpg125,rpg126,rpg127,rpg128,
        rpg129,rpg130,rpg131,rpg132,
        rpg133,rpg134,rpg135,rpg136,
        rpguser,rpggrup,rpgmodu,rpgdate,rpgacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
    IF INT_FLAG THEN CLEAR FORM RETURN END IF
   END IF  #FUN-7C0050
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND rpguser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND rpggrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND rpggrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rpguser', 'rpggrup')
    #End:FUN-980030
 
    LET g_sql="SELECT rpg01 FROM rpg_file ", # 組合出 SQL 指令
        "WHERE ",g_wc CLIPPED, " ORDER BY rpg01"
    PREPARE amsi102_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE amsi102_curs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR amsi102_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM rpg_file WHERE ",g_wc CLIPPED
    PREPARE amsi102_precount FROM g_sql
    DECLARE amsi102_count CURSOR FOR amsi102_precount
END FUNCTION
 
FUNCTION amsi102_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                CALL amsi102_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL amsi102_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL amsi102_fetch('N')
        ON ACTION previous
            CALL amsi102_fetch('P')
        ON ACTION jump
            CALL amsi102_fetch('/')
        ON ACTION first
            CALL amsi102_fetch('F')
        ON ACTION last
            CALL amsi102_fetch('L')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL amsi102_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
	    IF cl_chk_act_auth() THEN
		 CALL amsi102_x()
	    END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL amsi102_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL amsi102_copy()
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL amsi102_out()
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
              IF g_rpg.rpg01 IS NOT NULL THEN
                 LET g_doc.column1 = "rpg01"
                 LET g_doc.value1 = g_rpg.rpg01
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
    CLOSE amsi102_curs
END FUNCTION
 
 
FUNCTION amsi102_a()
    IF s_shut(0) THEN
        RETURN
    END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_rpg.* LIKE rpg_file.*
    INITIALIZE g_rpg_o.* TO NULL
#%  LET g_rpg.xxxx = 0				# DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_rpg.rpgacti ='Y'                   #有效的資料
        LET g_rpg.rpguser = g_user
        LET g_rpg.rpgoriu = g_user #FUN-980030
        LET g_rpg.rpgorig = g_grup #FUN-980030
        LET g_rpg.rpggrup = g_grup               #使用者所屬群
        LET g_rpg.rpgdate = g_today
        CALL amsi102_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_rpg.rpg01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO rpg_file VALUES(g_rpg.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
     #      CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("ins","rpg_file",g_rpg.rpg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
            CONTINUE WHILE
        END IF
        LET g_rpg_t.* = g_rpg.*                # 保存上筆資料
        SELECT rpg01 INTO g_rpg.rpg01 FROM rpg_file
            WHERE rpg01 = g_rpg.rpg01
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION amsi102_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
        l_flag          LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(01)
        l_n             LIKE type_file.num5     #NO.FUN-680101 SMALLINT
 
    DISPLAY BY NAME g_rpg.rpguser,g_rpg.rpggrup,g_rpg.rpgmodu,
        g_rpg.rpgdate, g_rpg.rpgacti
    INPUT BY NAME g_rpg.rpgoriu,g_rpg.rpgorig,
        g_rpg.rpg01,g_rpg.rpg02,
        g_rpg.rpg101,g_rpg.rpg102,g_rpg.rpg103,g_rpg.rpg104,
        g_rpg.rpg105,g_rpg.rpg106,g_rpg.rpg107,g_rpg.rpg108,
        g_rpg.rpg109,g_rpg.rpg110,g_rpg.rpg111,g_rpg.rpg112,
        g_rpg.rpg113,g_rpg.rpg114,g_rpg.rpg115,g_rpg.rpg116,
        g_rpg.rpg117,g_rpg.rpg118,g_rpg.rpg119,g_rpg.rpg120,
        g_rpg.rpg121,g_rpg.rpg122,g_rpg.rpg123,g_rpg.rpg124,
        g_rpg.rpg125,g_rpg.rpg126,g_rpg.rpg127,g_rpg.rpg128,
        g_rpg.rpg129,g_rpg.rpg130,g_rpg.rpg131,g_rpg.rpg132,
        g_rpg.rpg133,g_rpg.rpg134,g_rpg.rpg135,g_rpg.rpg136
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i102_set_entry(p_cmd)
           CALL i102_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD rpg01
          IF g_rpg.rpg01 IS NOT NULL THEN
            IF g_rpg_o.rpg01 IS NULL OR  #若輸入或更改且改KEY
              (g_rpg.rpg01 != g_rpg_o.rpg01) THEN
                IF p_cmd='a' OR
                  (p_cmd='u' AND g_rpg.rpg01 != g_rpg_t.rpg01) THEN
                    SELECT count(*) INTO l_n FROM rpg_file
                        WHERE rpg01 = g_rpg.rpg01
                    IF l_n > 0 THEN # Duplicated
                        CALL cl_err(g_rpg.rpg01,-239,0)
                        LET g_rpg.rpg01 = g_rpg_o.rpg01
                        DISPLAY BY NAME g_rpg.rpg01
                        NEXT FIELD rpg01
                    END IF
                END IF
            END IF
            LET g_rpg_o.rpg01=g_rpg.rpg01
          END IF
 
{01}    AFTER FIELD rpg101
            IF g_rpg.rpg101 > 365 OR g_rpg.rpg101 <= 0 THEN
                LET g_rpg.rpg101=g_rpg_t.rpg101
                DISPLAY BY NAME g_rpg.rpg101
                NEXT FIELD rpg101
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg102
            IF g_rpg.rpg102 > 365 OR g_rpg.rpg102 <= 0 THEN
                LET g_rpg.rpg102=g_rpg_t.rpg102
                DISPLAY BY NAME g_rpg.rpg102
                NEXT FIELD rpg102
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg103
            IF g_rpg.rpg103 > 365 OR g_rpg.rpg103 <= 0 THEN
                LET g_rpg.rpg103=g_rpg_t.rpg103
                DISPLAY BY NAME g_rpg.rpg103
                NEXT FIELD rpg103
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg104
            IF g_rpg.rpg104 > 365 OR g_rpg.rpg104 <= 0 THEN
                LET g_rpg.rpg104=g_rpg_t.rpg104
                DISPLAY BY NAME g_rpg.rpg104
                NEXT FIELD rpg104
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg105
            IF g_rpg.rpg105 > 365 OR g_rpg.rpg105 <= 0 THEN
                LET g_rpg.rpg105=g_rpg_t.rpg105
                DISPLAY BY NAME g_rpg.rpg105
                NEXT FIELD rpg105
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg106
            IF g_rpg.rpg106 > 365 OR g_rpg.rpg106 <= 0 THEN
                LET g_rpg.rpg106=g_rpg_t.rpg106
                DISPLAY BY NAME g_rpg.rpg106
                NEXT FIELD rpg106
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg107
            IF g_rpg.rpg107 > 365 OR g_rpg.rpg107 <= 0 THEN
                LET g_rpg.rpg107=g_rpg_t.rpg107
                DISPLAY BY NAME g_rpg.rpg107
                NEXT FIELD rpg107
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg108
            IF g_rpg.rpg108 > 365 OR g_rpg.rpg108 <= 0 THEN
                LET g_rpg.rpg108=g_rpg_t.rpg108
                DISPLAY BY NAME g_rpg.rpg108
                NEXT FIELD rpg108
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg109
            IF g_rpg.rpg109 > 365 OR g_rpg.rpg109 <= 0 THEN
                LET g_rpg.rpg109=g_rpg_t.rpg109
                DISPLAY BY NAME g_rpg.rpg109
                NEXT FIELD rpg109
            END IF
            CALL amsi102_sum()
{10}     BEFORE FIELD rpg110
            IF g_rpg.rpg109 > 365 OR g_rpg.rpg109 <= 0 THEN
                NEXT FIELD rpg109
            END IF
        AFTER FIELD rpg110
            IF g_rpg.rpg110 > 365 THEN
                LET g_rpg.rpg110=g_rpg_t.rpg110
                DISPLAY BY NAME g_rpg.rpg110
                NEXT FIELD rpg110
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg111
            IF g_rpg.rpg111 > 365 THEN
                LET g_rpg.rpg111=g_rpg_t.rpg111
                DISPLAY BY NAME g_rpg.rpg111
                NEXT FIELD rpg111
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg112
            IF g_rpg.rpg112 > 365 THEN
                LET g_rpg.rpg112=g_rpg_t.rpg112
                DISPLAY BY NAME g_rpg.rpg112
                NEXT FIELD rpg112
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg113
            IF g_rpg.rpg113 > 365 THEN
                LET g_rpg.rpg113=g_rpg_t.rpg113
                DISPLAY BY NAME g_rpg.rpg113
                NEXT FIELD rpg113
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg114
            IF g_rpg.rpg114 > 365 THEN
                LET g_rpg.rpg114=g_rpg_t.rpg114
                DISPLAY BY NAME g_rpg.rpg114
                NEXT FIELD rpg114
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg115
            IF g_rpg.rpg115 > 365 THEN
                LET g_rpg.rpg115=g_rpg_t.rpg115
                DISPLAY BY NAME g_rpg.rpg115
                NEXT FIELD rpg115
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg116
            IF g_rpg.rpg116 > 365 THEN
                LET g_rpg.rpg116=g_rpg_t.rpg116
                DISPLAY BY NAME g_rpg.rpg116
                NEXT FIELD rpg116
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg117
            IF g_rpg.rpg117 > 365 THEN
                LET g_rpg.rpg117=g_rpg_t.rpg117
                DISPLAY BY NAME g_rpg.rpg117
                NEXT FIELD rpg117
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg118
            IF g_rpg.rpg118 > 365 THEN
                LET g_rpg.rpg118=g_rpg_t.rpg118
                DISPLAY BY NAME g_rpg.rpg118
                NEXT FIELD rpg118
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg119
            IF g_rpg.rpg119 > 365 THEN
                LET g_rpg.rpg119=g_rpg_t.rpg119
                DISPLAY BY NAME g_rpg.rpg119
                NEXT FIELD rpg119
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg120
            IF g_rpg.rpg120 > 365 THEN
                LET g_rpg.rpg120=g_rpg_t.rpg120
                DISPLAY BY NAME g_rpg.rpg120
                NEXT FIELD rpg120
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg121
            IF g_rpg.rpg121 > 365 THEN
                LET g_rpg.rpg121=g_rpg_t.rpg121
                DISPLAY BY NAME g_rpg.rpg121
                NEXT FIELD rpg121
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg122
            IF g_rpg.rpg122 > 365 THEN
                LET g_rpg.rpg122=g_rpg_t.rpg122
                DISPLAY BY NAME g_rpg.rpg122
                NEXT FIELD rpg122
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg123
            IF g_rpg.rpg123 > 365 THEN
                LET g_rpg.rpg123=g_rpg_t.rpg123
                DISPLAY BY NAME g_rpg.rpg123
                NEXT FIELD rpg123
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg124
            IF g_rpg.rpg124 > 365 THEN
                LET g_rpg.rpg124=g_rpg_t.rpg124
                DISPLAY BY NAME g_rpg.rpg124
                NEXT FIELD rpg124
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg125
            IF g_rpg.rpg125 > 365 THEN
                LET g_rpg.rpg125=g_rpg_t.rpg125
                DISPLAY BY NAME g_rpg.rpg125
                NEXT FIELD rpg125
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg126
            IF g_rpg.rpg126 > 365 THEN
                LET g_rpg.rpg126=g_rpg_t.rpg126
                DISPLAY BY NAME g_rpg.rpg126
                NEXT FIELD rpg126
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg127
            IF g_rpg.rpg127 > 365 THEN
                LET g_rpg.rpg127=g_rpg_t.rpg127
                DISPLAY BY NAME g_rpg.rpg127
                NEXT FIELD rpg127
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg128
            IF g_rpg.rpg128 > 365 THEN
                LET g_rpg.rpg128=g_rpg_t.rpg128
                DISPLAY BY NAME g_rpg.rpg128
                NEXT FIELD rpg128
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg129
            IF g_rpg.rpg129 > 365 THEN
                LET g_rpg.rpg129=g_rpg_t.rpg129
                DISPLAY BY NAME g_rpg.rpg129
                NEXT FIELD rpg129
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg130
            IF g_rpg.rpg130 > 365 THEN
                LET g_rpg.rpg130=g_rpg_t.rpg130
                DISPLAY BY NAME g_rpg.rpg130
                NEXT FIELD rpg130
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg131
            IF g_rpg.rpg131 > 365 THEN
                LET g_rpg.rpg131=g_rpg_t.rpg131
                DISPLAY BY NAME g_rpg.rpg131
                NEXT FIELD rpg131
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg132
            IF g_rpg.rpg132 > 365 THEN
                LET g_rpg.rpg132=g_rpg_t.rpg132
                DISPLAY BY NAME g_rpg.rpg132
                NEXT FIELD rpg132
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg133
            IF g_rpg.rpg133 > 365 THEN
                LET g_rpg.rpg133=g_rpg_t.rpg133
                DISPLAY BY NAME g_rpg.rpg133
                NEXT FIELD rpg133
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg134
            IF g_rpg.rpg134 > 365 THEN
                LET g_rpg.rpg134=g_rpg_t.rpg134
                DISPLAY BY NAME g_rpg.rpg134
                NEXT FIELD rpg134
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg135
            IF g_rpg.rpg135 > 365 THEN
                LET g_rpg.rpg135=g_rpg_t.rpg135
                DISPLAY BY NAME g_rpg.rpg135
                NEXT FIELD rpg135
            END IF
            CALL amsi102_sum()
 
        AFTER FIELD rpg136
            IF g_rpg.rpg136 > 365 THEN
                LET g_rpg.rpg136=g_rpg_t.rpg136
                DISPLAY BY NAME g_rpg.rpg136
                NEXT FIELD rpg136
            END IF
            CALL amsi102_sum()
 
       AFTER INPUT
          LET g_rpg.rpguser = s_get_data_owner("rpg_file") #FUN-C10039
          LET g_rpg.rpggrup = s_get_data_group("rpg_file") #FUN-C10039
        LET l_flag='N'
        IF INT_FLAG THEN EXIT INPUT  END IF
#---bugno:7184-----------------------------
        IF cl_null(g_rpg.rpg101) OR g_rpg.rpg101 < 0 THEN
           LET g_rpg.rpg101=0
           DISPLAY BY NAME g_rpg.rpg101
        END IF
 
        IF cl_null(g_rpg.rpg102) OR g_rpg.rpg102 < 0 THEN
           LET g_rpg.rpg102=0
           DISPLAY BY NAME g_rpg.rpg102
        END IF
 
        IF cl_null(g_rpg.rpg103) OR g_rpg.rpg103 < 0 THEN
           LET g_rpg.rpg103=0
           DISPLAY BY NAME g_rpg.rpg103
        END IF
 
        IF cl_null(g_rpg.rpg104) OR g_rpg.rpg104 < 0 THEN
           LET g_rpg.rpg104=0
           DISPLAY BY NAME g_rpg.rpg104
        END IF
 
        IF cl_null(g_rpg.rpg105) OR g_rpg.rpg105 < 0 THEN
           LET g_rpg.rpg105=0
           DISPLAY BY NAME g_rpg.rpg105
        END IF
 
        IF cl_null(g_rpg.rpg106) OR g_rpg.rpg106 < 0 THEN
           LET g_rpg.rpg106=0
           DISPLAY BY NAME g_rpg.rpg106
        END IF
 
        IF cl_null(g_rpg.rpg107) OR g_rpg.rpg107 < 0 THEN
           LET g_rpg.rpg107=0
           DISPLAY BY NAME g_rpg.rpg107
        END IF
 
        IF cl_null(g_rpg.rpg108) OR g_rpg.rpg108 < 0 THEN
           LET g_rpg.rpg108=0
           DISPLAY BY NAME g_rpg.rpg108
        END IF
 
        IF cl_null(g_rpg.rpg109) OR g_rpg.rpg109 < 0 THEN
           LET g_rpg.rpg109=0
           DISPLAY BY NAME g_rpg.rpg109
        END IF
 
        IF cl_null(g_rpg.rpg110) OR g_rpg.rpg110 < 0 THEN
           LET g_rpg.rpg110=0
           DISPLAY BY NAME g_rpg.rpg110
        END IF
 
        IF cl_null(g_rpg.rpg111) OR g_rpg.rpg111 < 0 THEN
           LET g_rpg.rpg111=0
           DISPLAY BY NAME g_rpg.rpg111
        END IF
 
        IF cl_null(g_rpg.rpg112) OR g_rpg.rpg112 < 0 THEN
           LET g_rpg.rpg112=0
           DISPLAY BY NAME g_rpg.rpg112
        END IF
 
        IF cl_null(g_rpg.rpg113) OR g_rpg.rpg113 < 0 THEN
           LET g_rpg.rpg113=0
           DISPLAY BY NAME g_rpg.rpg113
        END IF
 
        IF cl_null(g_rpg.rpg114) OR g_rpg.rpg114 < 0 THEN
           LET g_rpg.rpg114=0
           DISPLAY BY NAME g_rpg.rpg114
        END IF
 
        IF cl_null(g_rpg.rpg115) OR g_rpg.rpg115 < 0 THEN
           LET g_rpg.rpg115=0
           DISPLAY BY NAME g_rpg.rpg115
        END IF
 
        IF cl_null(g_rpg.rpg116) OR g_rpg.rpg116 < 0 THEN
           LET g_rpg.rpg116=0
           DISPLAY BY NAME g_rpg.rpg116
        END IF
 
        IF cl_null(g_rpg.rpg117) OR g_rpg.rpg117 < 0 THEN
           LET g_rpg.rpg117=0
           DISPLAY BY NAME g_rpg.rpg117
        END IF
 
        IF cl_null(g_rpg.rpg118) OR g_rpg.rpg118 < 0 THEN
           LET g_rpg.rpg118=0
           DISPLAY BY NAME g_rpg.rpg118
        END IF
 
        IF cl_null(g_rpg.rpg119) OR g_rpg.rpg119 < 0 THEN
           LET g_rpg.rpg119=0
           DISPLAY BY NAME g_rpg.rpg119
        END IF
 
        IF cl_null(g_rpg.rpg120) OR g_rpg.rpg120 < 0 THEN
           LET g_rpg.rpg120=0
           DISPLAY BY NAME g_rpg.rpg120
        END IF
 
        IF cl_null(g_rpg.rpg121) OR g_rpg.rpg121 < 0 THEN
           LET g_rpg.rpg121=0
           DISPLAY BY NAME g_rpg.rpg121
        END IF
 
        IF cl_null(g_rpg.rpg122) OR g_rpg.rpg122 < 0 THEN
           LET g_rpg.rpg122=0
           DISPLAY BY NAME g_rpg.rpg122
        END IF
 
        IF cl_null(g_rpg.rpg123) OR g_rpg.rpg123 < 0 THEN
           LET g_rpg.rpg123=0
           DISPLAY BY NAME g_rpg.rpg123
        END IF
 
        IF cl_null(g_rpg.rpg124) OR g_rpg.rpg124 < 0 THEN
           LET g_rpg.rpg124=0
           DISPLAY BY NAME g_rpg.rpg124
        END IF
 
        IF cl_null(g_rpg.rpg125) OR g_rpg.rpg125 < 0 THEN
           LET g_rpg.rpg125=0
           DISPLAY BY NAME g_rpg.rpg125
        END IF
 
        IF cl_null(g_rpg.rpg126) OR g_rpg.rpg126 < 0 THEN
           LET g_rpg.rpg126=0
           DISPLAY BY NAME g_rpg.rpg126
        END IF
 
        IF cl_null(g_rpg.rpg127) OR g_rpg.rpg127 < 0 THEN
           LET g_rpg.rpg127=0
           DISPLAY BY NAME g_rpg.rpg127
        END IF
 
        IF cl_null(g_rpg.rpg128) OR g_rpg.rpg128 < 0 THEN
           LET g_rpg.rpg128=0
           DISPLAY BY NAME g_rpg.rpg128
        END IF
 
        IF cl_null(g_rpg.rpg129) OR g_rpg.rpg129 < 0 THEN
           LET g_rpg.rpg129=0
           DISPLAY BY NAME g_rpg.rpg129
        END IF
 
        IF cl_null(g_rpg.rpg130) OR g_rpg.rpg130 < 0 THEN
           LET g_rpg.rpg130=0
           DISPLAY BY NAME g_rpg.rpg130
        END IF
 
        IF cl_null(g_rpg.rpg131) OR g_rpg.rpg131 < 0 THEN
           LET g_rpg.rpg131=0
           DISPLAY BY NAME g_rpg.rpg131
        END IF
 
        IF cl_null(g_rpg.rpg132) OR g_rpg.rpg132 < 0 THEN
           LET g_rpg.rpg132=0
           DISPLAY BY NAME g_rpg.rpg132
        END IF
 
        IF cl_null(g_rpg.rpg133) OR g_rpg.rpg133 < 0 THEN
           LET g_rpg.rpg133=0
           DISPLAY BY NAME g_rpg.rpg133
        END IF
 
        IF cl_null(g_rpg.rpg134) OR g_rpg.rpg134 < 0 THEN
           LET g_rpg.rpg134=0
           DISPLAY BY NAME g_rpg.rpg134
        END IF
 
        IF cl_null(g_rpg.rpg135) OR g_rpg.rpg135 < 0 THEN
           LET g_rpg.rpg135=0
           DISPLAY BY NAME g_rpg.rpg135
        END IF
 
        IF cl_null(g_rpg.rpg136) OR g_rpg.rpg136 < 0 THEN
           LET g_rpg.rpg136=0
           DISPLAY BY NAME g_rpg.rpg136
        END IF
#---bugno:7184 END--------------------------------------------
{
        IF cl_null(g_rpg.rpg101) OR g_rpg.rpg101 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg101
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg101 END IF
 
        IF cl_null(g_rpg.rpg102) OR g_rpg.rpg102 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg102
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg102 END IF
 
        IF cl_null(g_rpg.rpg103) OR g_rpg.rpg103 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg103
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg103 END IF
 
        IF cl_null(g_rpg.rpg104) OR g_rpg.rpg104 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg104
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg104 END IF
 
        IF cl_null(g_rpg.rpg105) OR g_rpg.rpg105 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg105
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg105 END IF
 
        IF cl_null(g_rpg.rpg106) OR g_rpg.rpg106 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg106
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg106 END IF
 
        IF cl_null(g_rpg.rpg107) OR g_rpg.rpg107 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg107
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg107 END IF
 
        IF cl_null(g_rpg.rpg108) OR g_rpg.rpg108 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg108
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg108 END IF
 
        IF cl_null(g_rpg.rpg109) OR g_rpg.rpg109 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg109
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg109 END IF
 
        IF cl_null(g_rpg.rpg110) OR g_rpg.rpg110 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg110
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg110 END IF
 
        IF cl_null(g_rpg.rpg111) OR g_rpg.rpg111 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg111
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg111 END IF
 
        IF cl_null(g_rpg.rpg112) OR g_rpg.rpg112 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg112
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg112 END IF
 
        IF cl_null(g_rpg.rpg113) OR g_rpg.rpg113 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg113
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg113 END IF
 
        IF cl_null(g_rpg.rpg114) OR g_rpg.rpg114 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg114
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg114 END IF
 
        IF cl_null(g_rpg.rpg115) OR g_rpg.rpg115 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg115
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg115 END IF
 
        IF cl_null(g_rpg.rpg116) OR g_rpg.rpg116 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg116
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg116 END IF
 
        IF cl_null(g_rpg.rpg117) OR g_rpg.rpg117 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg117
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg117 END IF
 
        IF cl_null(g_rpg.rpg118) OR g_rpg.rpg118 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg118
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg118 END IF
 
        IF cl_null(g_rpg.rpg119) OR g_rpg.rpg119 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg119
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg119 END IF
 
        IF cl_null(g_rpg.rpg120) OR g_rpg.rpg120 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg120
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg120 END IF
 
        IF cl_null(g_rpg.rpg121) OR g_rpg.rpg121 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg121
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg121 END IF
 
        IF cl_null(g_rpg.rpg122) OR g_rpg.rpg122 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg122
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg122 END IF
 
        IF cl_null(g_rpg.rpg123) OR g_rpg.rpg123 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg123
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg123 END IF
 
        IF cl_null(g_rpg.rpg124) OR g_rpg.rpg124 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg124
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg124 END IF
 
        IF cl_null(g_rpg.rpg125) OR g_rpg.rpg125 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg125
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg125 END IF
 
        IF cl_null(g_rpg.rpg126) OR g_rpg.rpg126 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg126
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg126 END IF
 
        IF cl_null(g_rpg.rpg127) OR g_rpg.rpg127 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg127
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg127 END IF
 
        IF cl_null(g_rpg.rpg128) OR g_rpg.rpg128 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg128
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg128 END IF
 
        IF cl_null(g_rpg.rpg129) OR g_rpg.rpg129 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg129
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg129 END IF
 
        IF cl_null(g_rpg.rpg130) OR g_rpg.rpg130 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg130
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg130 END IF
 
        IF cl_null(g_rpg.rpg131) OR g_rpg.rpg131 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg131
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg131 END IF
 
        IF cl_null(g_rpg.rpg132) OR g_rpg.rpg132 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg132
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg132 END IF
 
        IF cl_null(g_rpg.rpg133) OR g_rpg.rpg133 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg133
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg133 END IF
 
        IF cl_null(g_rpg.rpg134) OR g_rpg.rpg134 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg134
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg134 END IF
 
        IF cl_null(g_rpg.rpg135) OR g_rpg.rpg135 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg135
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg135 END IF
 
        IF cl_null(g_rpg.rpg136) OR g_rpg.rpg136 < 0
        THEN LET l_flag='Y'
             DISPLAY BY NAME g_rpg.rpg136
        END IF
        IF l_flag='Y' THEN CALL cl_err('','9033',0) NEXT FIELD rpg136 END IF
}
 
        #MOD-650015 --start 
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(rpg01) THEN
        #        LET g_rpg.* = g_rpg_t.*
        #        DISPLAY BY NAME g_rpg.*
        #        NEXT FIELD rpg01
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
 
FUNCTION amsi102_sum()
DEFINE
    l_total  LIKE type_file.num5          #NO.FUN-680101 SMALLINT  #存放總天數
    IF g_rpg.rpg101 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg101 END IF
    IF g_rpg.rpg102 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg102 END IF
    IF g_rpg.rpg103 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg103 END IF
    IF g_rpg.rpg104 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg104 END IF
    IF g_rpg.rpg105 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg105 END IF
    IF g_rpg.rpg106 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg106 END IF
    IF g_rpg.rpg107 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg107 END IF
    IF g_rpg.rpg108 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg108 END IF
    IF g_rpg.rpg109 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg109 END IF
    IF g_rpg.rpg110 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg110 END IF
    IF g_rpg.rpg111 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg111 END IF
    IF g_rpg.rpg112 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg112 END IF
    IF g_rpg.rpg113 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg113 END IF
    IF g_rpg.rpg114 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg114 END IF
    IF g_rpg.rpg115 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg115 END IF
    IF g_rpg.rpg116 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg116 END IF
    IF g_rpg.rpg117 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg117 END IF
    IF g_rpg.rpg118 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg118 END IF
    IF g_rpg.rpg119 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg119 END IF
    IF g_rpg.rpg120 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg120 END IF
    IF g_rpg.rpg121 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg121 END IF
    IF g_rpg.rpg122 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg122 END IF
    IF g_rpg.rpg123 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg123 END IF
    IF g_rpg.rpg124 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg124 END IF
    IF g_rpg.rpg125 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg125 END IF
    IF g_rpg.rpg126 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg126 END IF
    IF g_rpg.rpg127 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg127 END IF
    IF g_rpg.rpg128 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg128 END IF
    IF g_rpg.rpg129 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg129 END IF
    IF g_rpg.rpg130 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg130 END IF
    IF g_rpg.rpg131 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg131 END IF
    IF g_rpg.rpg132 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg132 END IF
    IF g_rpg.rpg133 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg133 END IF
    IF g_rpg.rpg134 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg134 END IF
    IF g_rpg.rpg135 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg135 END IF
    IF g_rpg.rpg136 IS NOT NULL THEN LET l_total=l_total+g_rpg.rpg136 END IF
    DISPLAY l_total TO rpg137
END FUNCTION
 
FUNCTION amsi102_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rpg.* TO NULL                   #No.FUN-6A0150
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL amsi102_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN amsi102_count
    FETCH amsi102_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN amsi102_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0)
        INITIALIZE g_rpg.* TO NULL
    ELSE
        CALL amsi102_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION amsi102_fetch(p_flrpg)
    DEFINE
        p_flrpg         LIKE type_file.chr1,     #NO.FUN-680101 VARCHAR(1) 
        l_abso          LIKE type_file.num10     #NO.FUN-680101 INTEGER
 
  WHILE TRUE
    CASE p_flrpg
        WHEN 'N' FETCH NEXT     amsi102_curs INTO g_rpg.rpg01
        WHEN 'P' FETCH PREVIOUS amsi102_curs INTO g_rpg.rpg01
        WHEN 'F' FETCH FIRST    amsi102_curs INTO g_rpg.rpg01
        WHEN 'L' FETCH LAST     amsi102_curs INTO g_rpg.rpg01
        WHEN '/'
           IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
#           PROMPT g_msg CLIPPED,': ' FOR l_abso  #No.TQC-970248 
            PROMPT g_msg CLIPPED,': ' FOR g_jump  #No.TQC-970248 
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
          LEt mi_no_ask = FALSE
#         FETCH ABSOLUTE l_abso amsi102_curs INTO g_rpg.rpg01  #No.TQC-970248 
          FETCH ABSOLUTE g_jump amsi102_curs INTO g_rpg.rpg01  #No.TQC-970248 
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0)
        INITIALIZE g_rpg.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flrpg
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = l_abso
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_rpg.* FROM rpg_file            # 重讀DB,因TEMP有不被更新特性
       WHERE rpg01 = g_rpg.rpg01
	IF SQLCA.sqlcode = -246 THEN CONTINUE WHILE END IF
    IF SQLCA.sqlcode THEN
   #    CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0) #No.FUN-660108
        CALL cl_err3("sel","rpg_file",g_rpg.rpg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
    ELSE                                        #FUN-4C0041權限控管
       LET g_data_owner = g_rpg.rpguser
       LET g_data_group = g_rpg.rpggrup
        CALL amsi102_show()                      # 重新顯示
    END IF
    EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION amsi102_show()
    DISPLAY BY NAME g_rpg.rpgoriu,g_rpg.rpgorig,
        g_rpg.rpg01,g_rpg.rpg02,
        g_rpg.rpg101,g_rpg.rpg102,g_rpg.rpg103,g_rpg.rpg104,
        g_rpg.rpg105,g_rpg.rpg106,g_rpg.rpg107,g_rpg.rpg108,
        g_rpg.rpg109,g_rpg.rpg110,g_rpg.rpg111,g_rpg.rpg112,
        g_rpg.rpg113,g_rpg.rpg114,g_rpg.rpg115,g_rpg.rpg116,
        g_rpg.rpg117,g_rpg.rpg118,g_rpg.rpg119,g_rpg.rpg120,
        g_rpg.rpg121,g_rpg.rpg122,g_rpg.rpg123,g_rpg.rpg124,
        g_rpg.rpg125,g_rpg.rpg126,g_rpg.rpg127,g_rpg.rpg128,
        g_rpg.rpg129,g_rpg.rpg130,g_rpg.rpg131,g_rpg.rpg132,
        g_rpg.rpg133,g_rpg.rpg134,g_rpg.rpg135,g_rpg.rpg136,
        g_rpg.rpguser,g_rpg.rpggrup,g_rpg.rpgmodu,
        g_rpg.rpgdate, g_rpg.rpgacti
    CALL amsi102_sum()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION amsi102_u()
    IF s_shut(0) THEN
        RETURN
    END IF
    IF g_rpg.rpg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_rpg.rpgacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_rpg.rpg01,'aom-000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN amsi102_curl USING g_rpg.rpg01
    IF STATUS THEN
       CALL cl_err("OPEN amsi102_curl:", STATUS, 1)
       CLOSE amsi102_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH amsi102_curl INTO g_rpg.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_rpg_o.* = g_rpg.*
    LET g_rpg_t.* =g_rpg.*
    LET g_rpg.rpgmodu=g_user                     #修改者
    LET g_rpg.rpgdate = g_today                  #修改日期
    CALL amsi102_show()                          # 顯示最新資料
    WHILE TRUE
        CALL amsi102_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rpg.*=g_rpg_t.*
            CALL amsi102_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE rpg_file SET rpg_file.* = g_rpg.*    # 更新DB
            WHERE rpg01 = g_rpg_t.rpg01             # COLAUTH?
        IF SQLCA.sqlcode THEN
     #      CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("upd","rpg_file",g_rpg.rpg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE amsi102_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION amsi102_r()
DEFINE
    l_chr LIKE type_file.chr1       #NO.FUN-680101 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rpg.rpg01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
#No.TQC-980057 add --begin
    IF g_rpg.rpgacti = 'N' THEN
       CALL cl_err('','abm-950',0)
       RETURN
    END IF
#No.TQC-980057 add --end
 
    BEGIN WORK
 
    OPEN amsi102_curl USING g_rpg.rpg01
    IF STATUS THEN
       CALL cl_err("OPEN amsi102_curl:", STATUS, 1)
       CLOSE amsi102_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH amsi102_curl INTO g_rpg.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
    END IF
    CALL amsi102_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "rpg01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_rpg.rpg01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM rpg_file WHERE rpg01=g_rpg.rpg01
        IF SQLCA.SQLERRD[3]=0 OR STATUS THEN
    #      CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0) #No.FUN-660108
           CALL cl_err3("del","rpg_file",g_rpg.rpg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
        END IF
        #CKP
        INITIALIZE g_rpg.* TO NULL
        CLEAR FORM
        OPEN amsi102_count
        FETCH amsi102_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN amsi102_curs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL amsi102_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL amsi102_fetch('/')
        END IF
    END IF
    CLOSE amsi102_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION amsi102_x()
    DEFINE
        l_chr LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
    IF s_shut(0) THEN
        RETURN
    END IF
    IF g_rpg.rpg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN amsi102_curl USING g_rpg.rpg01
    IF STATUS THEN
       CALL cl_err("OPEN amsi102_curl:", STATUS, 1)
       CLOSE amsi102_curl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH amsi102_curl INTO g_rpg.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL amsi102_show()
    IF cl_exp(15,21,g_rpg.rpgacti) THEN
        LET g_chr=g_rpg.rpgacti
        IF g_rpg.rpgacti='Y' THEN
            LET g_rpg.rpgacti='N'
        ELSE
            LET g_rpg.rpgacti='Y'
        END IF
        UPDATE rpg_file
            SET rpgacti=g_rpg.rpgacti,
               rpgmodu=g_user, rpgdate=g_today
            WHERE rpg01=g_rpg.rpg01
        IF SQLCA.SQLERRD[3]=0 THEN
   #        CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0) #No.FUN-660108
            CALL cl_err3("upd","rpg_file",g_rpg.rpg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
            LET g_rpg.rpgacti=g_chr
        END IF
        DISPLAY BY NAME g_rpg.rpgacti
    END IF
    CLOSE amsi102_curl
    COMMIT WORK
END FUNCTION
 
FUNCTION amsi102_copy()
    DEFINE
        l_n             LIKE type_file.num5,     #NO.FUN-680101 SMALLINT
        l_newno,l_oldno LIKE rpg_file.rpg01
 
    IF s_shut(0) THEN
        RETURN
    END IF
    IF g_rpg.rpg01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i102_set_entry('a')
    CALL i102_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM rpg01
        AFTER FIELD rpg01
            IF l_newno IS NULL THEN
                NEXT FIELD rpg01
            END IF
            SELECT count(*) INTO g_cnt FROM rpg_file
                WHERE rpg01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD rpg01
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
        DISPLAY BY NAME g_rpg.rpg01
        RETURN
    END IF
    DROP TABLE x
    SELECT * FROM rpg_file
        WHERE rpg01=g_rpg.rpg01
        INTO TEMP x
    UPDATE x
        SET rpg01=l_newno,    #資料鍵值
            rpguser=g_user,   #資料所有者
            rpggrup=g_grup,   #資料所有者所屬群
            rpgmodu=NULL,     #資料修改日期
            rpgdate=g_today,  #資料建立日期
            rpgacti='Y'       #有效資料
    INSERT INTO rpg_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
  #     CALL cl_err(g_rpg.rpg01,SQLCA.sqlcode,0) #No.FUN-660108
        CALL cl_err3("ins","rpg_file",g_rpg.rpg01,"",SQLCA.sqlcode,"","",1)   #No.FUN-660108
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_rpg.rpg01
        LET g_rpg.rpg01 = l_newno
        SELECT rpg_file.* INTO g_rpg.* FROM rpg_file
               WHERE rpg01 =  l_newno
        CALL amsi102_u()
        CALL amsi102_show()
    END IF
    DISPLAY BY NAME g_rpg.rpg01
END FUNCTION
 
FUNCTION amsi102_out()
    DEFINE
        l_i             LIKE type_file.num5,      #NO.FUN-680101 SMALLINT
        l_name          LIKE type_file.chr20,     # External(Disk) file name   #NO.FUN-680101 VARCHAR(20) 
        l_total         LIKE type_file.num5,      #NO.FUN-680101 SMALLINT
        l_rpg           RECORD LIKE rpg_file.*,
        l_za05          LIKE type_file.chr50,     #NO.FUN-680101 VARCHAR(40)
        l_chr           LIKE type_file.chr1       #NO.FUN-680101 VARCHAR(1)
 
    IF cl_null(g_wc) THEN
       LET g_wc=" rpg01='",g_rpg.rpg01,"'"
    END IF
 
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
#    CALL cl_outnam('amsi102') RETURNING l_name    #No.FUN-770012
    CALL cl_del_data(l_table)     #No.FUN-770012
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM rpg_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED
    PREPARE amsi102_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE amsi102_curo                         # SCROLL CURSOR
        CURSOR FOR amsi102_p1
 
#    START REPORT amsi102_rep TO l_name           #No.FUN-770012
 
    FOREACH amsi102_curo INTO l_rpg.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
    LET l_total=0
    IF l_rpg.rpg101 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg101 END IF
    IF l_rpg.rpg102 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg102 END IF
    IF l_rpg.rpg103 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg103 END IF
    IF l_rpg.rpg104 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg104 END IF
    IF l_rpg.rpg105 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg105 END IF
    IF l_rpg.rpg106 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg106 END IF
    IF l_rpg.rpg107 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg107 END IF
    IF l_rpg.rpg108 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg108 END IF
    IF l_rpg.rpg109 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg109 END IF
    IF l_rpg.rpg110 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg110 END IF
    IF l_rpg.rpg111 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg111 END IF
    IF l_rpg.rpg112 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg112 END IF
    IF l_rpg.rpg113 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg113 END IF
    IF l_rpg.rpg114 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg114 END IF
    IF l_rpg.rpg115 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg115 END IF
    IF l_rpg.rpg116 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg116 END IF
    IF l_rpg.rpg117 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg117 END IF
    IF l_rpg.rpg118 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg118 END IF
    IF l_rpg.rpg119 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg119 END IF
    IF l_rpg.rpg120 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg120 END IF
    IF l_rpg.rpg121 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg121 END IF
    IF l_rpg.rpg122 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg122 END IF
    IF l_rpg.rpg123 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg123 END IF
    IF l_rpg.rpg124 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg124 END IF
    IF l_rpg.rpg125 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg125 END IF
    IF l_rpg.rpg126 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg126 END IF
    IF l_rpg.rpg127 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg127 END IF
    IF l_rpg.rpg128 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg128 END IF
    IF l_rpg.rpg129 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg129 END IF
    IF l_rpg.rpg130 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg130 END IF
    IF l_rpg.rpg131 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg131 END IF
    IF l_rpg.rpg132 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg132 END IF
    IF l_rpg.rpg133 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg133 END IF
    IF l_rpg.rpg134 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg134 END IF
    IF l_rpg.rpg135 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg135 END IF
    IF l_rpg.rpg136 IS NOT NULL THEN LET l_total=l_total+l_rpg.rpg136 END IF
        LET l_rpg.rpg101=l_total
#No.FUN-770012 -- begin --
#        OUTPUT TO REPORT amsi102_rep(l_rpg.*)
        EXECUTE insert_prep USING l_rpg.rpg01,l_rpg.rpg02,l_rpg.rpg101,l_rpg.rpgacti
        IF STATUS THEN
           CALL cl_err("execute insert_prep:",STATUS,1)
           EXIT FOREACH
        END IF
#No.FUN-770012 -- end --
    END FOREACH
 
#    FINISH REPORT amsi102_rep             #No.FUN-770012
 
    CLOSE amsi102_curo
    ERROR ""
#No.FUN-770012 -- begin --
#    CALL cl_prt(l_name,' ','1',g_len)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    CALL cl_wcchp(g_wc,'rpg01,rpg02,rpg03')
         RETURNING g_wc
    LET g_str = g_wc,";",g_zz05
    LET g_sql1 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    CALL cl_prt_cs3('amsi102','amsi102',g_sql1,g_str)
#No.FUN-770012 -- end --
 
END FUNCTION
 
#No.FUN-770012 -- begin --
#REPORT amsi102_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,    #NO.FUN-680101 VARCHAR(1)
#        sr RECORD LIKE rpg_file.*,
#        l_chr           LIKE type_file.chr1     #NO.FUN-680101 VARCHAR(1)
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.rpg01
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] clipped,g_x[32] clipped,g_x[33] clipped,g_x[34] clipped
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            IF sr.rpgacti = 'N' THEN PRINT COLUMN g_c[31],'*'; END IF
#            PRINT COLUMN g_c[32],sr.rpg01,
#                  COLUMN g_c[33],sr.rpg02,
#                  COLUMN g_c[34],sr.rpg101
#
#        ON LAST ROW
#         #PRINT g_dash[1,g_len]   #TQC-5B0019
#          IF g_zz05 = 'Y' THEN
#             CALL cl_wcchp(g_wc,'rpg01,rpg02,rpg03')
#                  RETURNING g_wc
#             PRINT g_dash[1,g_len]
#                    CALL cl_prt_pos_wc(g_wc) #TQC-630166
#          END IF
#          PRINT g_dash[1,g_len] #No.TQC-5C0005
#          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#          LET l_trailer_sw = 'n'   #TQC-5B0019 將y改成n
#
#        PAGE TRAILER
#          IF l_trailer_sw = 'y' THEN
#             PRINT g_dash[1,g_len]
#             PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#          ELSE
#             SKIP 2 LINE
#          END IF
#END REPORT
#No.FUN-770012 -- end --
 
FUNCTION i102_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rpg01",TRUE)
   END IF
END FUNCTION
 
FUNCTION i102_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1      #NO.FUN-680101 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("rpg01",FALSE)
   END IF
END FUNCTION
 


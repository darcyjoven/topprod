#
# Pattern name...: axdi100.4gl
# Descriptions...: 集團組織結構維護作業
# Date & Author..: 03/10/09 By Zeal
# Modify       ..: 04/02/23 By Carrier
# Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.MOD-4C0087 修改q_azp1的參數
# Modify.........: No.FUN-520024 05/02/24 By Day 報表轉XML
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No:FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No:MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No:FUN-680108 06/08/28 By Xufeng 字段類型定義改為LIKE            
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask    
# Modify.........: No:FUN-6A0165 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_ada    RECORD LIKE ada_file.*,         #集團組織單頭資料檔
    g_ada_t  RECORD LIKE ada_file.*,         #集團組織單頭資料檔(舊值)
    g_ada_o  RECORD LIKE ada_file.*,         #集團組織單頭資料檔(舊值)
    g_ada01_t       LIKE ada_file.ada01,     #集團組織單頭(舊值)
    g_ada_rowid     LIKE type_file.chr18,    #No.FUN-680108 INT

 g_adb           DYNAMIC ARRAY OF RECORD  #集團組織單身資料檔
        adb02       LIKE adb_file.adb02,     #下層公司編號
        azp021      LIKE azp_file.azp02,     #下層公司名稱 #NO.MOD-4B0067
        adb03       LIKE adb_file.adb03,     #生效日期
        adb04       LIKE adb_file.adb04,     #失效日期
        adb05       LIKE adb_file.adb05,     #轉撥計價方式
        adb06       LIKE adb_file.adb06      #轉撥百分比
                    END RECORD,
 g_adb_t         RECORD                   #集團組織單身資料檔 (舊值)
        adb02       LIKE adb_file.adb02,     #下層公司編號
         azp021      LIKE azp_file.azp02,    #下層公司名稱 #NO.MOD-4B0067
        adb03       LIKE adb_file.adb03,     #生效日期
        adb04       LIKE adb_file.adb04,     #失效日期
        adb05       LIKE adb_file.adb05,     #轉撥計價方式
        adb06       LIKE adb_file.adb06      #轉撥百分比
                    END RECORD,
 g_adb_o         RECORD                   #集團組織單身資料檔 (舊值)
        adb02       LIKE adb_file.adb02,     #下層公司編號
        azp021      LIKE azp_file.azp02,     #下層公司名稱 #NO.MOD-4B0067
        adb03       LIKE adb_file.adb03,     #生效日期
        adb04       LIKE adb_file.adb04,     #失效日期
        adb05       LIKE adb_file.adb05,     #轉撥計價方式
        adb06       LIKE adb_file.adb06      #轉撥百分比
                    END RECORD,

    g_wc,g_sql,g_wc2  STRING,                #No:FUN-580092 HCN
    g_argv1           LIKE ada_file.ada01,   #集團組織單頭
    g_argv2           LIKE type_file.chr1,   #是否具有新增功能(ASM#41) #No.FUN-680108 VARCHAR(01)
    g_rec_b           LIKE type_file.num5,   #單身筆數                 #No.FUN-680108 SMALLINT
    g_flag            LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    l_ac              LIKE type_file.num5    #目前處理的ARRAY CNT      #No.FUN-680108 SMALLINT
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680108 SMALLINT

DEFINE   g_forupd_sql STRING                 #SELECT ... FOR UPDATE NOWAIT SQL  
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680108 INTEGER 
DEFINE   g_chr        LIKE type_file.chr1    #No.FUN-680108 VARCHAR(01)
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose   #No.FUN-680108 SMALLINT
DEFINE   g_msg        LIKE type_file.chr1000 #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_curs_index LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   g_jump       LIKE type_file.num10   #No.FUN-680108 INTEGER
DEFINE   mi_no_ask     LIKE type_file.num5    #No.FUN-680108 SMALLINT   #No.FUN-6A0078

#主程式開始
MAIN
DEFINE
    l_tadb        LIKE type_file.chr8      #計算被使用時間 #FUN-680108 VARCHAR(08)

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
# Prog. Version..: '5.10.00-08.01.04(00006)'     #

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

    IF INT_FLAG THEN EXIT PROGRAM END IF

    LET g_argv1 = ARG_VAL(1)              #集團組織單頭
    LET g_argv2 = ARG_VAL(2)

      CALL cl_used(g_prog,l_tadb,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818
        RETURNING l_tadb
    LET g_ada01_t = NULL                  #清除鍵值
    INITIALIZE g_ada_t.* TO NULL
    INITIALIZE g_ada.* TO NULL
    LET p_row = 5 LET p_col = 13

 OPEN WINDOW i100_w AT p_row,p_col     #顯示畫面
        WITH FORM "axd/42f/axdi100"
        ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    IF g_argv1 != ' ' THEN CALL i100_q() END IF

--##
    CALL g_x.clear()
--##

    LET g_forupd_sql =
       "SELECT * FROM ada_file WHERE ada01 = ? FOR UPDATE NOWAIT"
    DECLARE i100_cl CURSOR FROM g_forupd_sql

    CALL i100_menu()
    CLOSE WINDOW i100_w                 #結束畫面
      CALL cl_used(g_prog,l_tadb,2)     #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818
        RETURNING l_tadb
END MAIN

#QBE 查詢資料
FUNCTION i100_cs()
    DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01   #No:FUN-580031

    IF cl_null(g_argv1) OR g_argv1 IS NULL THEN
       CLEAR FORM                             #清除畫面
       CALL g_adb.clear()
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
    CONSTRUCT BY NAME g_wc ON ada01,ada02, #螢幕上取單頭條件
                    adauser,adagrup,adamodu,adadate,adaacti

        BEFORE CONSTRUCT
            CALL cl_qbe_init()           #No:FUN-580031

        ON ACTION CONTROLP
         CASE   WHEN INFIELD(ada01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_azp"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ada01
                    NEXT FIELD ada01
                WHEN INFIELD(ada02)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adc"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = g_ada.ada01
                    LET g_qryparam.arg2 = 'I'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ada02
                    NEXT FIELD ada02
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

         #No:FUN-580031 --start--
         ON ACTION qbe_select
             CALL cl_qbe_list() RETURNING lc_qbe_sn
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No:FUN-580031 ---end---

       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc2 ON adb02,adb03,adb04, #螢幕上取單身條件
                          adb05,adb06
          FROM s_adb[1].adb02,s_adb[1].adb03,s_adb[1].adb04,
               s_adb[1].adb05,s_adb[1].adb06

       #No:FUN-580031 --start--
       BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
       #No:FUN-580031 ---end---

       ON ACTION CONTROLP
            CASE WHEN INFIELD(adb02)
                 #No.MOD-4C0087 --begin
                #CALL q_azp1(FALSE,TRUE,g_adb[l_ac].adb02,g_ada.ada01)
                CALL q_azp1(FALSE,TRUE,g_adb[1].adb02,g_ada.ada01)
                     RETURNING g_qryparam.multiret
                 #No.MOD-4C0087 --end
                DISPLAY g_qryparam.multiret TO s_adb[1].adb02
                NEXT FIELD adb02
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

       #No:FUN-580031 --start--
       ON ACTION qbe_save
           CALL cl_qbe_save()
       #No:FUN-580031 ---end---
 
       END CONSTRUCT

       IF INT_FLAG THEN  RETURN END IF
    ELSE
      LET g_wc = " ada01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
    END IF
    IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND adauser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
      LET g_wc = g_wc clipped," AND adagrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      LET g_wc = g_wc clipped," AND adagrup IN ",cl_chk_tgrup_list()
    END IF

    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
LET g_sql = "SELECT ROWID, ada01 FROM ada_file ",                        
            " WHERE ", g_wc CLIPPED,                                      
            " ORDER BY ada01"
    ELSE					# 若單身有輸入條件
LET g_sql = "SELECT UNIQUE ada_file.ROWID, ada01 ",                      
                  " FROM ada_file, adb_file ",                                  
                  " WHERE ada01 = adb01",                                       
                  " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,                 
                  " ORDER BY ada01" 
    END IF
    PREPARE i100_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) EXIT PROGRAM
    END IF
    DECLARE i100_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i100_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ada_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct ada01)",
                  " FROM ada_file,adb_file ",
                  " WHERE ada01=adb01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i100_precount FROM g_sql
    DECLARE i100_count CURSOR FOR i100_precount

END FUNCTION

FUNCTION i100_menu()
   WHILE TRUE
      CALL i100_bp("G")
      CASE g_action_choice
        WHEN "insert"
           IF cl_chk_act_auth() THEN
              CALL i100_a()
           END IF
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i100_q()
           END IF
        WHEN "delete"
           IF cl_chk_act_auth() THEN
              CALL i100_r()
           END IF
        WHEN "reproduce"
           IF cl_chk_act_auth() THEN
              CALL i100_copy()
           END IF
        WHEN "modify"
           IF cl_chk_act_auth() THEN
              CALL i100_u()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i100_b()
           ELSE
              LET g_action_choice = NULL
           END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i100_x()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i100_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No:FUN-6A0165-------add--------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_ada.ada01 IS NOT NULL THEN
                LET g_doc.column1 = "ada01"
                LET g_doc.value1 = g_ada.ada01
                CALL cl_doc()
              END IF
        END IF
        #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION

#Add  輸入
FUNCTION i100_a()
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無新增之功能
    IF g_argv2 != ' ' THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    CALL g_adb.clear()
    INITIALIZE g_ada.* LIKE ada_file.*
    LET g_ada01_t = NULL
    LET g_ada_t.*=g_ada.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ada.adaacti ='Y'                   #有效的資料
        LET g_ada.adauser = g_user
        LET g_ada.adagrup = g_grup               #使用者所屬群
        LET g_ada.adadate = g_today
        CALL i100_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_ada.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_ada.ada01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO ada_file VALUES(g_ada.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF
        SELECT ROWID INTO g_ada_rowid FROM ada_file
            WHERE ada01 = g_ada.ada01
        LET g_ada01_t = g_ada.ada01        #保留舊值
        LET g_ada_t.* = g_ada.*

        CALL g_adb.clear()
        LET g_rec_b=0
        CALL i100_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION

FUNCTION i100_i(p_cmd)
    DEFINE
        l_dir1          LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1) #CURSOR JUMP DIRECTION
        l_dir2          LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1) #CURSOR JUMP DIRECTION
        l_azp02         LIKE azp_file.azp02,
        p_cmd           LIKE type_file.chr1,    #No.FUN-680108 VARCHAR(1)
        l_n             LIKE type_file.num5     #No.FUN-680108 SMALLINT
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT BY NAME g_ada.ada01,g_ada.ada02,g_ada.adauser,g_ada.adagrup,
                  g_ada.adamodu,g_ada.adadate,g_ada.adaacti
                  WITHOUT DEFAULTS HELP 1

        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i100_set_entry(p_cmd)
            CALL i100_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE

        AFTER FIELD ada01
            IF NOT cl_null(g_ada.ada01) THEN
               IF p_cmd = "a" OR
                 (p_cmd = "u" AND g_ada.ada01 != g_ada_t.ada01) THEN
                   SELECT COUNT(*) INTO l_n FROM ada_file
                    WHERE ada01 = g_ada.ada01
                   IF l_n > 0 THEN                  # Duplicated
                       CALL cl_err(g_ada.ada01,-239,0)
                       LET g_ada.ada01 = g_ada01_t
                       DISPLAY BY NAME g_ada.ada01 ATTRIBUTE(YELLOW)
                       NEXT FIELD ada01
                   END IF
               END IF
               IF NOT cl_null(g_ada.ada01) THEN
                  CALL i100_azp02(p_cmd)
                  IF NOT cl_null(g_errno)  THEN
                     CALL cl_err('',g_errno,0)
                     LET g_ada.ada01 = g_ada_t.ada01
                     DISPLAY BY NAME g_ada.ada01
                     NEXT FIELD ada01
                  END IF
               END IF
            END IF

        AFTER FIELD ada02
            IF NOT cl_null(g_ada.ada02) THEN
               SELECT adc02 FROM adc_file
                WHERE adc01=g_ada.ada01 AND adc02=g_ada.ada02
                  AND adc08='I'
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ada.ada02,'axd-025',0)
                  NEXT FIELD ada02
               END IF
            END IF

        ON ACTION CONTROLN
            CALL i100_b_askkey()
            EXIT INPUT
      #MOD-650015 --start
      #  ON ACTION CONTROLO                       # 沿用所有欄位
      #      IF INFIELD(ada01) THEN
      #          LET g_ada.* = g_ada_t.*
      #          DISPLAY BY NAME g_ada.* ATTRIBUTE(YELLOW)
      #          NEXT FIELD ada01
      #      END IF
      #MOD-650015 --end
        ON ACTION CONTROLP
         CASE   WHEN INFIELD(ada01)
                #   CALL q_azp(10,3,g_ada.ada01) RETURNING g_ada.ada01
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_azp"
                    CALL cl_create_qry() RETURNING g_ada.ada01
                    DISPLAY BY NAME g_ada.ada01
                    NEXT FIELD ada01
                WHEN INFIELD(ada02)
                #   CALL q_adc(0,0,g_ada.ada02,g_ada.ada01,'I')
                #        RETURNING g_ada.ada02
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adc"
                    LET g_qryparam.arg1 = g_ada.ada01
                    LET g_qryparam.arg2 = 'I'
                    CALL cl_create_qry() RETURNING g_ada.ada02
                    DISPLAY BY NAME g_ada.ada02
                    NEXT FIELD ada02

         END CASE

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
          CALL cl_cmdask()

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
    END INPUT
END FUNCTION


FUNCTION i100_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ada.* TO NULL              #NO.FUN-6A0165
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL g_adb.clear()
    DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(GREEN)
    CALL i100_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE "Waiting...." ATTRIBUTE(REVERSE)
    OPEN i100_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
        INITIALIZE g_ada.* TO NULL
    ELSE
        OPEN i100_count
        FETCH i100_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i100_t('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION i100_t(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,        #No.FUN-680108 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680108 INTEGER

    CASE p_flag
        WHEN 'N' FETCH NEXT     i100_cs INTO g_ada_rowid,g_ada.ada01
        WHEN 'P' FETCH PREVIOUS i100_cs INTO g_ada_rowid,g_ada.ada01
        WHEN 'F' FETCH FIRST    i100_cs INTO g_ada_rowid,g_ada.ada01
        WHEN 'L' FETCH LAST     i100_cs INTO g_ada_rowid,g_ada.ada01
        WHEN '/'
--mi
            IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
          #  PROMPT g_msg CLIPPED,': ' FOR l_abso
               ON IDLE g_idle_seconds
                   CALL cl_on_idle()
#                   CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump i100_cs INTO g_ada_rowid,g_ada.ada01
            LET mi_no_ask = FALSE    #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ada.* TO NULL   #No.TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    SELECT * INTO g_ada.* FROM ada_file            # 重讀DB,因TEMP有不被更新特性
       WHERE ROWID = g_ada_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
    ELSE                                    #FUN-4C0052權限控管
        LET g_data_owner=g_ada.adauser
        LET g_data_group=g_ada.adagrup
 
        CALL i100_show()                      # 重新顯示
    END IF
END FUNCTION

FUNCTION i100_show()

DEFINE  l_azp02     LIKE azp_file.azp02

    LET g_ada_t.* = g_ada.*
    DISPLAY BY NAME g_ada.ada01,g_ada.ada02,g_ada.adauser,g_ada.adagrup,
                    g_ada.adamodu,g_ada.adadate,g_ada.adaacti
    CALL i100_azp02('d')
    CALL i100_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i100_u()
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_argv2 != ' ' THEN RETURN END IF
    IF g_ada.ada01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_ada.* FROM ada_file WHERE ada01=g_ada.ada01
    IF g_ada.adaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ada.ada01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ada01_t = g_ada.ada01
    LET g_ada_t.* = g_ada.*
    LET g_ada_o.* = g_ada.*
    BEGIN WORK
    OPEN i100_cl USING g_ada.ada01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
        CLOSE i100_cl ROLLBACK WORK RETURN
    END IF
    FETCH i100_cl INTO g_ada.*               # 對DB鎖定
    LET g_ada.adamodu=g_user                     #修改者
    LET g_ada.adadate = g_today                  #修改日期
    CALL i100_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i100_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ada.*=g_ada_t.*
            CALL i100_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE ada_file SET ada_file.* = g_ada.*    # 更新DB
            WHERE ROWID = g_ada_rowid             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
            CONTINUE WHILE
        END IF

        CALL i100_show()
        EXIT WHILE
    END WHILE
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION


FUNCTION i100_x()
    DEFINE
        l_buf LIKE ze_file.ze03,        #儲存下游檔案的名稱 #No.FUN-680108 VARCHAR(80)
        l_chr LIKE type_file.chr1       #No.FUN-680108 VARCHAR(1)

    IF s_shut(0) THEN RETURN END IF
    IF g_ada.ada01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i100_cl USING g_ada.ada01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_ada.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
        CLOSE i100_cl ROLLBACK WORK RETURN
    END IF
    CALL i100_show()
    #在刪除前先檢查其下游檔案adb_file是否尚在使用中
    LET l_buf = NULL
    SELECT COUNT(*) INTO g_i FROM adb_file WHERE adb01 = g_ada.ada01
    IF g_i > 0 THEN
       CALL cl_getmsg('mfg1010',g_lang) RETURNING g_msg
       LET l_buf = g_msg
    END IF

    IF cl_exp(0,0,g_ada.adaacti) THEN
        LET g_chr=g_ada.adaacti
        IF g_ada.adaacti='Y' THEN
            LET g_ada.adaacti='N'
        ELSE
            LET g_ada.adaacti='Y'
        END IF
        UPDATE ada_file
            SET adaacti=g_ada.adaacti,
                adamodu=g_user, adadate=g_today
            WHERE ROWID=g_ada_rowid
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
            LET g_ada.adaacti=g_chr
        END IF
        DISPLAY BY NAME g_ada.adaacti ATTRIBUTE(RED)
    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION

FUNCTION i100_r()
    DEFINE l_chr LIKE type_file.chr1,     #No.FUN-680108 VARCHAR(1)
           l_buf LIKE ze_file.ze03        #儲存下游檔案的名稱 #No.FUN-680108 VARCHAR(80)

    IF s_shut(0) THEN RETURN END IF
    IF g_ada.ada01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
    OPEN i100_cl USING g_ada.ada01
    IF STATUS THEN
       CALL cl_err("OPEN i100_cl:", STATUS, 1)
       CLOSE i100_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i100_cl INTO g_ada.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
        CLOSE i100_cl ROLLBACK WORK RETURN
    END IF
    CALL i100_show()

    IF cl_delh(15,16) THEN
        DELETE FROM ada_file WHERE ROWID = g_ada_rowid
        IF SQLCA.SQLERRD[3]=0
           THEN CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)
           ELSE CLEAR FORM
        END IF
        DELETE FROM adb_file WHERE adb01=g_ada.ada01
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06)
        VALUES ('axdi100',g_user,g_today,g_msg,g_ada_rowid,'delete')
        CLEAR FORM
        CALL g_adb.clear()
--mi
         OPEN i100_count
         FETCH i100_count INTO g_row_count
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i100_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i100_t('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE     #No.FUN-6A0078
            CALL i100_t('/')
         END IF
--#

    END IF
    CLOSE i100_cl
    COMMIT WORK
END FUNCTION


#單身
FUNCTION i100_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重復用        #No.FUN-680108 SMALLINT
    l_cnt           LIKE type_file.num5,    #檢查重復用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_misc          LIKE ade_file.ade04,                       #No.FUN-680108 VARCHAR(04)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680108 SMALLINT

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_ada.ada01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_ada.* FROM ada_file
     WHERE ada01=g_ada.ada01
    IF g_ada.adaacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_ada.ada01,'mfg1000',0)
        RETURN
    END IF

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT adb02 ,' ',adb03,adb04,adb05,adb06 ",
                      "  FROM adb_file WHERE adb01=? AND adb02=? FOR UPDATE NOWAIT"
    DECLARE i100_b_cl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_adb WITHOUT DEFAULTS FROM s_adb.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                      APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
--CKP, 當單身有資料時才跳至指定列
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd= ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT

            BEGIN WORK

            OPEN i100_cl USING g_ada.ada01
            IF STATUS THEN
               CALL cl_err("OPEN i100_cl:", STATUS, 1)
               CLOSE i100_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH i100_cl INTO g_ada.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_ada.ada01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE i100_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_adb_t.* = g_adb[l_ac].*  #BACKUP
               LET g_adb_o.* = g_adb[l_ac].*  #BACKUP
               OPEN i100_b_cl USING g_ada.ada01,g_adb_t.adb02  #表示更改狀態
               IF STATUS THEN
                  CALL cl_err("OPEN i100_b_cl:", STATUS, 1)
                  LET l_lock_sw='Y'
               ELSE
                   FETCH i100_b_cl INTO g_adb[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_adb_t.adb02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
               END IF
               SELECT azp02 INTO g_adb[l_ac].azp021 FROM azp_file
                WHERE azp01 = g_adb[l_ac].adb02
               IF STATUS  THEN
                  CALL cl_err('','mfg9142',0)
                  NEXT FIELD adb02
               END IF
               CALL i100_set_entry_b(p_cmd)
               CALL i100_set_no_entry_b(p_cmd)
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
         INITIALIZE g_adb[l_ac].* TO NULL      #900423
            LET g_adb_t.* = g_adb[l_ac].*         #新輸入資料
            LET g_adb_o.* = g_adb[l_ac].*         #新輸入資料
            LET g_adb[l_ac].adb03 = g_today        #Body default
            LET g_adb[l_ac].adb04 = g_today        #Body default
            LET g_adb[l_ac].adb05 = '1'
            CALL i100_set_entry_b(p_cmd)
            CALL i100_set_no_entry_b(p_cmd)
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adb02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO adb_file(adb01,adb02,adb03,adb04,adb05,adb06)
            VALUES(g_ada.ada01,g_adb[l_ac].adb02,
                   g_adb[l_ac].adb03,g_adb[l_ac].adb04,
                   g_adb[l_ac].adb05,g_adb[l_ac].adb06 )
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_adb[l_ac].adb02,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        AFTER FIELD adb02
            IF NOT cl_null(g_adb[l_ac].adb02) THEN
               SELECT azp02 INTO g_adb[l_ac].azp021 FROM azp_file
                WHERE azp01 = g_adb[l_ac].adb02
               IF STATUS  THEN
                  CALL cl_err('','mfg9142',0)
                  NEXT FIELD adb02
               END IF
               IF g_adb[l_ac].adb02 = g_ada.ada01 THEN
                  NEXT FIELD adb02
               END IF
               SELECT COUNT(*) INTO l_n FROM ada_file,adb_file
                WHERE ada01 = g_adb[l_ac].adb02
                  AND adb02 = g_ada.ada01
                  AND ada01 = adb01
                  AND adaacti = 'Y'
               IF l_n > 0 THEN
                  CALL cl_err(g_adb[l_ac].adb02,'axd-079',0)
                  NEXT FIELD adb02
               END IF
               IF g_adb[l_ac].adb02 <> g_adb_t.adb02 OR cl_null(g_adb_t.adb02) THEN
                  SELECT COUNT(*) INTO l_n FROM adb_file,ada_file
                   WHERE adb02 = g_adb[l_ac].adb02
                     AND ada01 = adb01
                     AND adaacti = 'Y'
                  IF l_n > 1 THEN
                     CALL cl_err(g_adb[l_ac].adb02,'axd-081',0)
                     NEXT FIELD adb02
                  END IF
                  SELECT count(*) INTO l_n FROM adb_file
                   WHERE adb01 = g_ada.ada01 AND adb02 = g_adb[l_ac].adb02
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_adb[l_ac].adb02 = g_adb_t.adb02
                     NEXT FIELD adb02
                  END IF
               END IF
            END IF

        AFTER FIELD adb04
            IF g_adb[l_ac].adb04 < g_adb[l_ac].adb03 THEN
               CALL cl_err(g_adb[l_ac].adb04,'mfg2604',0)
               NEXT FIELD adb03
            END IF

        BEFORE FIELD adb05
            CALL i100_set_entry_b(p_cmd)

        AFTER FIELD adb05
            IF g_adb[l_ac].adb05 IS NOT NULL THEN
               IF g_adb[l_ac].adb05 MATCHES '[134]' THEN
                  LET g_adb[l_ac].adb06 = NULL
               END IF
               CALL i100_set_no_entry_b(p_cmd)
            END IF

        AFTER FIELD adb06
            IF NOT cl_null(g_adb[l_ac].adb06) THEN
               IF g_adb[l_ac].adb05 = '2' AND
               (g_adb[l_ac].adb06 <0 OR g_adb[l_ac].adb06 >100) THEN
                  CALL cl_err('','axd-050',0)
                  NEXT FIELD adb06
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_adb_t.adb02  IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adb_file
                 WHERE adb01 = g_ada.ada01 AND adb02 = g_adb_t.adb02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adb_t.adb02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adb[l_ac].* = g_adb_t.*
               CLOSE i100_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adb[l_ac].adb02,-263,1)
               LET g_adb[l_ac].* = g_adb_t.*
            ELSE
               UPDATE adb_file
                  SET adb02=g_adb[l_ac].adb02,
                      adb03=g_adb[l_ac].adb03,
                      adb04=g_adb[l_ac].adb04,
                      adb05=g_adb[l_ac].adb05,
                      adb06=g_adb[l_ac].adb06
                WHERE CURRENT OF i100_b_cl
                IF SQLCA.sqlcode OR STATUS = 100 THEN
                   CALL cl_err(g_adb[l_ac].adb02,SQLCA.sqlcode,0)
                   LET g_adb[l_ac].* = g_adb_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
            END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_adb[l_ac].* = g_adb_t.*
               END IF
               CLOSE i100_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i100_b_cl
            COMMIT WORK

        ON ACTION CONTROLO
            IF INFIELD(adb02) AND l_ac > 1 THEN
                LET g_adb[l_ac].* = g_adb[l_ac-1].*
                NEXT FIELD adb02
            END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
            CASE WHEN INFIELD(adb02)
            #   CALL q_azp1(10,3,g_adb[l_ac].adb02,g_ada.ada01)
            #        RETURNING g_adb[l_ac].adb02
                CALL q_azp1(FALSE,FALSE,g_adb[l_ac].adb02,g_ada.ada01)
                     RETURNING g_adb[l_ac].adb02
                NEXT FIELD adb02
           END CASE

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 

        END INPUT

    #FUN-5B0113-begin
     LET g_ada.adamodu = g_user
     LET g_ada.adadate = g_today
     UPDATE ada_file SET adamodu = g_ada.adamodu,adadate = g_ada.adadate
      WHERE ada01 = g_ada.ada01
     IF SQLCA.SQLCODE OR STATUS = 100 THEN
        CALL cl_err('upd ada',SQLCA.SQLCODE,1)
     END IF
     DISPLAY BY NAME g_ada.adamodu,g_ada.adadate
    #FUN-5B0113-end

    CLOSE i100_b_cl
    COMMIT WORK
END FUNCTION

FUNCTION i100_b_askkey()
DEFINE l_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc ON adb02,adb03,adb04,adb05,adb06
         FROM s_adb[1].adb02,s_adb[1].adb03,s_adb[1].adb04,
              s_adb[1].adb05,s_adb[1].adb06

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           IF INFIELD(adb02) THEN
                CALL q_azp1(FALSE,TRUE,g_adb[l_ac].adb02,g_ada.ada01)
                     RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO s_adb[1].adb01
                NEXT FIELD adb01
           END IF
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
          CALL cl_qbe_select()
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i100_b_fill(l_wc)
END FUNCTION

FUNCTION i100_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc            LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(400)

    LET g_sql =
    "SELECT adb02,azp02,adb03,adb04,adb05,adb06",
       "  FROM adb_file, OUTER azp_file ",
       " WHERE adb01 = '",g_ada.ada01,"'",
       "   AND adb02 = azp_file.azp01 " ,
       "   AND ",p_wc CLIPPED
    PREPARE i100_prepare2 FROM g_sql      #預備一下
    DECLARE adb_cs CURSOR FOR i100_prepare2

    CALL g_adb.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH adb_cs INTO g_adb[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err('','9035',0)
           EXIT FOREACH
        END IF
    END FOREACH
     CALL g_adb.deleteElement(g_cnt)  #No.MOD-4C0087
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
    LET g_cnt = 0
END FUNCTION

FUNCTION i100_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adb TO s_adb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
         CALL i100_t('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#         EXIT DISPLAY  ######add for refresh bug
#         CALL i100_bp_refresh()

      ON ACTION previous
         CALL i100_t('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#         EXIT DISPLAY  ######add for refresh bug
#         CALL i100_bp_refresh()

      ON ACTION jump
         CALL i100_t('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#         EXIT DISPLAY  ######add for refresh bug
#         CALL i100_bp_refresh()

      ON ACTION next
         CALL i100_t('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#         EXIT DISPLAY  ######add for refresh bug
#         CALL i100_bp_refresh()

      ON ACTION last
         CALL i100_t('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
#         EXIT DISPLAY  ######add for refresh bug
#         CALL i100_bp_refresh()

      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY

      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION related_document                #No:FUN-6A0165  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION


FUNCTION i100_copy()
DEFINE
    l_newno         LIKE ada_file.ada01,
    l_oldno         LIKE ada_file.ada01

    IF s_shut(0) THEN RETURN END IF
    IF g_ada.ada01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

    LET g_before_input_done = FALSE
    CALL i100_set_entry_b('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

    INPUT l_newno FROM ada01
        AFTER FIELD ada01
            IF l_newno IS NULL THEN
                NEXT FIELD ada01
            END IF
            SELECT azp01 FROM azp_file WHERE azp01=l_newno
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_newno,'mfg9142',0)
               NEXT FIELD ada01
            END IF
            SELECT COUNT(*) INTO g_cnt FROM ada_file WHERE ada01 = l_newno
            IF g_cnt > 0 THEN
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD ada01
            END IF
        ON ACTION CONTROLP
           CASE WHEN INFIELD(ada01)
                #   CALL q_azp(10,3,g_ada.ada01) RETURNING l_newno
                    CALL cl_init_qry_var()
                    LET g_qryparam.form  = "q_azp"
                    CALL cl_create_qry() RETURNING l_newno
                    DISPLAY BY NAME l_newno
                    NEXT FIELD ada01
                WHEN INFIELD(ada02)
                #   CALL q_adc(0,0,g_ada.ada02,g_ada.ada01,'I')
                #   RETURNING l_newno
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_adc"
                    LET g_qryparam.arg1 = g_ada.ada01
                    LET g_qryparam.arg2 = 'I'
                    CALL cl_create_qry() RETURNING l_newno
                    DISPLAY BY NAME l_newno
                    NEXT FIELD ada02
          END CASE
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM ada_file
        WHERE ada01=g_ada.ada01
        INTO TEMP y
    UPDATE y
        SET y.ada01=l_newno,    #資料鍵值
            y.adauser = g_user,
            y.adagrup = g_grup,
            y.adadate = g_today,
            y.adaacti = 'Y'
    INSERT INTO ada_file  #復制單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL  cl_err(l_newno,SQLCA.sqlcode,0)
    END IF
    DROP TABLE x
    SELECT * FROM adb_file
       WHERE adb01 = g_ada.ada01
       INTO TEMP x
    UPDATE x
       SET adb01 = l_newno
    UPDATE x SET adb02=' ' WHERE adb02 is null AND imf01=l_newno
    INSERT INTO adb_file    #復制單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err(l_newno,SQLCA.sqlcode,0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' ATTRIBUTE(REVERSE)
        LET l_oldno = g_ada.ada01
        SELECT ROWID,ada_file.* INTO g_ada_rowid,g_ada.* FROM ada_file
               WHERE ada01 =  l_newno
        CALL i100_u()
        CALL i100_show()
        LET g_ada.ada01 = l_oldno
        SELECT ROWID,ada_file.* INTO g_ada_rowid,g_ada.* FROM ada_file
               WHERE ada01 = g_ada.ada01
        CALL i100_show()
    END IF
    DISPLAY BY NAME g_ada.ada01
END FUNCTION

FUNCTION i100_azp02(p_cmd)    #工廠編號
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_azp01     LIKE azp_file.azp01,
        l_azp02     LIKE azp_file.azp02

  LET g_errno = ' '
  SELECT azp02  INTO l_azp02
    FROM azp_file
   WHERE azp01=g_ada.ada01

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg9142'
                                 LET l_azp01 = NULL
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_azp02 TO FORMONLY.azp02
  END IF
END FUNCTION

FUNCTION i100_out()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680108 SMALLINT
    sr              RECORD
        ada01       LIKE ada_file.ada01,   #上層公司編號
        ada02       LIKE ada_file.ada02,   #在途倉編號
        adb02       LIKE adb_file.adb02,   #下層公司編號
        adb03       LIKE adb_file.adb03,   #生效日期
        adb04       LIKE adb_file.adb04,   #失效日期
        adb05       LIKE adb_file.adb05,   #轉撥計價方式
        adb06       LIKE adb_file.adb06,   #轉撥百分比
        azp02       LIKE azp_file.azp02,   #上層公司名稱   #No.FUN-680108 VARCHAR(20)
        azp021      LIKE azp_file.azp02    #下層公司名稱   #No.FUN-680108 VARCHAR(20)
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name#No.FUN-680108 VARCHAR(20)
    l_za05          LIKE za_file.za05      #NO.MOD-4B0067
    IF cl_null(g_wc) AND NOT cl_null(g_ada.ada01) THEN
       LET g_wc = " ada01 = '",g_ada.ada01,"'"
    END IF
    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    IF g_wc2 IS NULL THEN LET g_wc2 = "1=1" END IF
    CALL cl_wait()
    CALL cl_outnam('axdi100') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    LET g_sql="SELECT ada01,ada02,adb02,adb03,adb04,adb05,adb06,azp02",
              "  FROM ada_file,adb_file,OUTER azp_file",  # 組合出 SQL
              " WHERE ada01=adb01",
              "   AND ada01=azp_file.azp01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    PREPARE i100_p1 FROM g_sql              # RUNTadb 編譯
    DECLARE i100_co                         # CURSOR
        CURSOR FOR i100_p1

    START REPORT i100_rep TO l_name

    FOREACH i100_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        SELECT azp02 INTO sr.azp021 From azp_file
         WHERE azp01 = sr.adb02
        OUTPUT TO REPORT i100_rep(sr.*)
    END FOREACH

    FINISH REPORT i100_rep

    CLOSE i100_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i100_rep(sr)
DEFINE
 #   l_rowno        LIKE type_file.num5,   #NO.MOD-4B0067  #No.FUN-680108 SMALLINT
    l_desc          LIKE type_file.chr20,  #No.FUN-680108 VARCHAR(20)
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    sr              RECORD
        ada01       LIKE ada_file.ada01,   #上層公司編號
        ada02       LIKE ada_file.ada02,   #在途倉編號
        adb02       LIKE adb_file.adb02,   #下層公司編號
        adb03       LIKE adb_file.adb03,   #生效日期
        adb04       LIKE adb_file.adb04,   #失效日期
        adb05       LIKE adb_file.adb05,   #轉撥計價方式
        adb06       LIKE adb_file.adb06,   #轉撥百分比
        azp02       LIKE azp_file.azp02,   #上層公司名稱 #NO.MOD-4B0067
        azp021      LIKE azp_file.azp02    #下層公司名稱 #NO.MOD-4B0067
                    END RECORD
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.ada01,sr.adb02

    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED

            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total

            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            PRINT
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
                  g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
            PRINT g_dash1
            LET l_trailer_sw = 'y'

        BEFORE GROUP OF sr.ada01  #集團組織單身

        ON EVERY ROW
            CASE sr.adb05
                 WHEN '1' CALL cl_getmsg('axd-111',g_lang) RETURNING l_desc
                 WHEN '2' CALL cl_getmsg('axd-112',g_lang) RETURNING l_desc
                 WHEN '3' CALL cl_getmsg('axd-113',g_lang) RETURNING l_desc
                 WHEN '4' CALL cl_getmsg('axd-114',g_lang) RETURNING l_desc
            END CASE
            PRINT COLUMN g_c[31],sr.ada01,
                  COLUMN g_c[32],sr.azp02,
                  COLUMN g_c[33],sr.ada02,
                  COLUMN g_c[34],sr.adb02,
                  COLUMN g_c[35],sr.azp021,
                  COLUMN g_c[36],sr.adb03,
                  COLUMN g_c[37],sr.adb04,
                  COLUMN g_c[38],sr.adb05,
                  COLUMN g_c[39],l_desc,
                  COLUMN g_c[40],sr.adb06 USING '######.#&&'

        AFTER GROUP OF sr.ada01
            PRINT

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
END REPORT

FUNCTION i100_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF INFIELD(adb05) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adb06",TRUE)
   END IF

END FUNCTION

FUNCTION i100_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF INFIELD(adb05) OR (NOT g_before_input_done) THEN
        IF g_adb[l_ac].adb05 <> '2' THEN
            CALL cl_set_comp_entry("adb06",FALSE)
        END IF
   END IF

END FUNCTION
FUNCTION i100_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("ada01",TRUE)
   END IF

END FUNCTION

FUNCTION i100_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ada01",FALSE)
       END IF
   END IF

END FUNCTION

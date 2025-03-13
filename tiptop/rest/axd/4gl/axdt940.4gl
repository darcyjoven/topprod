# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdt940.4gl
# Descriptions...: 交運文件資料維護作業
# Date & Author..: 04/11/11 By Carrier
# Modify.........: No.MOD-4B0067 04/11/18 BY DAY  將變數用Like方式定義
# Modify.........: No.TQC-5B0194 05/12/06 BY wujie 624行多寫一個oze05
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
       g_adg       RECORD
                   adf00 LIKE adf_file.adf00,
                   adg01 LIKE adg_file.adg01,
                   adg02 LIKE adg_file.adg02,
                   adg09 LIKE adg_file.adg09,
                   adg05 LIKE adg_file.adg05,
                   adf03 LIKE adf_file.adf03,
                   adf05 LIKE adf_file.adf05
                   END RECORD,
       g_adg_t     RECORD
                   adf00 LIKE adf_file.adf00,
                   adg01 LIKE adg_file.adg01,
                   adg02 LIKE adg_file.adg02,
                   adg09 LIKE adg_file.adg09,
                   adg05 LIKE adg_file.adg05,
                   adf03 LIKE adf_file.adf03,
                   adf05 LIKE adf_file.adf05
                   END RECORD,
       g_adg_rowid LIKE type_file.chr18,  #No.FUN-680108 INT
       g_yy,g_mm   LIKE type_file.num5,   #No.FUN-680108 SMALLINT
       b_oze       RECORD LIKE oze_file.*,
       g_oze       DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                   oze03     LIKE oze_file.oze03,
                   oze04     LIKE oze_file.oze04,
                   oze05     LIKE oze_file.oze05,
                   oze06     LIKE oze_file.oze06,
                   oze07     LIKE oze_file.oze07,
                   oze08     LIKE oze_file.oze08
                   END RECORD,
       g_oze_t     RECORD
                   oze03     LIKE oze_file.oze03,
                   oze04     LIKE oze_file.oze04,
                   oze05     LIKE oze_file.oze05,
                   oze06     LIKE oze_file.oze06,
                   oze07     LIKE oze_file.oze07,
                   oze08     LIKE oze_file.oze08
                   END RECORD,
        g_wc        string,  #No:FUN-580092 HCN
        g_sql       string,  #No:FUN-580092 HCN
       g_t1        LIKE oay_file.oayslip, #No.FUN-680108 VARCHAR(5)
       g_sw        LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
       g_buf       LIKE type_file.chr1000,#No.FUN-680108 VARCHAR(20)
       g_rec_b     LIKE type_file.num5,   #單身筆數   #No.FUN-680108 SMALLINT
       l_ac        LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-680108 SMALLINT
       g_flag      LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)
DEFINE g_forupd_sql STRING                #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_cnt        LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE g_i          LIKE type_file.num5   #count/index for any purpose        #No.FUN-680108 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000#No.FUN-680108 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE g_curs_index LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE g_jump       LIKE type_file.num10  #No.FUN-680108 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5   #No.FUN-680108 SMALLINT

MAIN
#     DEFINE    l_time LIKE type_file.chr8     #No.FUN-6A0091
DEFINE  p_row,p_col LIKE type_file.num5    #No.FUN-680108 SMALLINT  #No.FUN-6A0091
    OPTIONS                               #改變一些系統預設值
        FORM LINE       FIRST + 2,        #畫面開始的位置
        MESSAGE LINE    LAST,             #訊息顯示的位置
        PROMPT LINE     LAST,             #提示訊息的位置
        INPUT NO WRAP                     #輸入的方式: 不打轉
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    LET g_adg.adg01  = ARG_VAL(1)
    LET g_adg.adg02  = ARG_VAL(2)

    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW t940_w AT p_row,p_col WITH FORM "axd/42f/axdt940"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()

    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'

    LET g_flag = 'N'
    IF NOT cl_null(g_adg.adg01) AND NOT cl_null(g_adg.adg02) THEN
       LET g_flag = 'Y'
       CALL t940_q()
       CALL t940_b()
    END IF
    CALL t940_menu()
    CLOSE WINDOW t940_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
END MAIN

FUNCTION t940_cs()
    CLEAR FORM                             #清除畫面
    CALL g_oze.clear()
    IF g_flag = 'N' THEN
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092

   INITIALIZE g_adg.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
           adf00,adg01,adg02,adg09,adg05,adf03,adf05

       #No:FUN-580031 --start--     HCN
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
       #No:FUN-580031 --end--       HCN

       ON ACTION controlp
          CASE
             WHEN INFIELD(adg01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_adg1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO adg01
                  NEXT FIELD adg01
             WHEN INFIELD(adg09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_azp"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO adg09
                  NEXT FIELD adg09
             WHEN INFIELD(adg05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_ima"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO adg05
                  NEXT FIELD adg05
             WHEN INFIELD(adf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO adf03
                  NEXT FIELD adf03
              WHEN INFIELD(adf05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_obn"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO adf05
                 NEXT FIELD adf05
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
 
       #No:FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No:FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
    ELSE
        LET g_wc = "     adg01 ='",g_adg.adg01,"'",
                   " AND adg02 = ",g_adg.adg02
    END IF
    LET g_wc = g_wc CLIPPED," AND adfconf = 'Y'" CLIPPED
    #資料權限的檢查
    IF g_priv2='4' THEN                           #只能使用自己的資料
        LET g_wc = g_wc clipped," AND adfuser = '",g_user,"'"
    END IF
    IF g_priv3='4' THEN                           #只能使用相同群的資料
        LET g_wc = g_wc clipped," AND adfgrup MATCHES '",g_grup CLIPPED,"*'"
    END IF

    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
        LET g_wc = g_wc clipped," AND adfgrup IN ",cl_chk_tgrup_list()
    END IF

    IF INT_FLAG THEN RETURN END IF
    LET g_sql = "SELECT adg01,adg02,adg_file.ROWID ",
                "  FROM adf_file,adg_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND adf01 = adg01 ",
                " ORDER BY adg01,adg02"
    PREPARE t940_prepare FROM g_sql
    DECLARE t940_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t940_prepare

    DROP TABLE x
    LET g_sql = "SELECT adg01,adg02 ",
                "  FROM adf_file,adg_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND adf01 = adg01 ",
                "  INTO TEMP x "
    PREPARE t940_precount_x FROM g_sql
    EXECUTE t940_precount_x

        LET g_sql="SELECT COUNT(*) FROM x "

    PREPARE t940_precount FROM g_sql
    DECLARE t940_count CURSOR FOR t940_precount
END FUNCTION

FUNCTION t940_menu()

   WHILE TRUE
      CALL t940_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t940_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t940_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #No:FUN-6A0165-------adk--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_adg.adg01 IS NOT NULL THEN
                LET g_doc.column1 = "adg01"
                LET g_doc.column2 = "adg02"
                LET g_doc.value1 = g_adg.adg01
                LET g_doc.value2 = g_adg.adg02
                CALL cl_doc()
             END IF 
          END IF
         #No:FUN-6A0165-------adk--------end----
      END CASE
   END WHILE
END FUNCTION

FUNCTION t940_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t940_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_adg.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t940_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adg.* TO NULL
    ELSE
        OPEN t940_count
        FETCH t940_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t940_fetch('F')                  # 讀出TEMP第一筆并顯示
    END IF
    MESSAGE ""
END FUNCTION

FUNCTION t940_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1      #處理方式    #No.FUN-680108 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     t940_cs INTO g_adg.adg01,g_adg.adg02,g_adg_rowid
        WHEN 'P' FETCH PREVIOUS t940_cs INTO g_adg.adg01,g_adg.adg02,g_adg_rowid
        WHEN 'F' FETCH FIRST    t940_cs INTO g_adg.adg01,g_adg.adg02,g_adg_rowid
        WHEN 'L' FETCH LAST     t940_cs INTO g_adg.adg01,g_adg.adg02,g_adg_rowid
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump t940_cs INTO g_adg.adg01,g_adg.adg02,g_adg_rowid
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adg.adg01,SQLCA.sqlcode,0)
        LET g_adg_rowid = NULL                  #TQC-6B0105
        INITIALIZE g_adg.* TO NULL              #No.FUN-6A0165
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

    SELECT adf00,adg01,adg02,adg09,adg05,adf03,adf05 INTO g_adg.*
      FROM adf_file,adg_file
     WHERE adg_file.ROWID = g_adg_rowid
       AND adf01 = adg01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adg.adg01,SQLCA.sqlcode,0)
        INITIALIZE g_adg.* TO NULL
        RETURN
    END IF

    CALL t940_show()
END FUNCTION

FUNCTION t940_show()
    LET g_adg_t.* = g_adg.*                #保存單頭舊值
    DISPLAY BY NAME g_adg.adf00,g_adg.adg01,g_adg.adg02,g_adg.adg09,
                    g_adg.adg05,g_adg.adf03,g_adg.adf05

    CALL t940_b_fill()

    CALL cl_show_fld_cont()                #No:FUN-550037 hmf
END FUNCTION

FUNCTION t940_g_b()
DEFINE l_i      LIKE type_file.num10,      #No.FUN-680108 INTEGER
       l_obo01  LIKE obo_file.obo01,
       l_obo    RECORD LIKE obo_file.*,
       l_oze    RECORD LIKE oze_file.*

       SELECT COUNT(*) INTO l_i FROM oze_file
        WHERE oze01 = g_adg.adg01
          AND oze02 = g_adg.adg02
       IF l_i = 0 THEN      #單身沒有資料
          IF NOT cl_null(g_adg.adf05) THEN
             IF cl_confirm('axd-099') THEN #是否按預設的運輸途徑產生單身
                LET l_obo01 = g_adg.adf05
             ELSE
                RETURN
             END IF
          ELSE
             IF cl_confirm('axd-100') THEN   #是否要選擇一個運輸途徑用于產生單身
                CALL cl_init_qry_var()       #選擇一個運輸途徑
                LET g_qryparam.form ="q_obn"
                LET g_qryparam.default1=l_obo01
                CALL cl_create_qry() RETURNING l_obo01
             ELSE
                RETURN
             END IF
          END IF
       ELSE
          RETURN
       END IF

       DECLARE obo_cur CURSOR FOR
        SELECT * FROM obo_file WHERE obo01=l_obo01 AND obo04<>'X'
       LET l_i=1
       FOREACH obo_cur INTO l_obo.*
          IF STATUS THEN
             CALL cl_err('foreach obo_cur:',STATUS,1)
             EXIT FOREACH
          END IF
          INSERT INTO oze_file(oze01,oze02,oze03,oze04,oze07,oze08)
          VALUES(g_adg.adg01,g_adg.adg02,l_i,
                 l_obo.obo04,l_obo.obo05,l_obo.obo06)
          IF SQLCA.sqlcode THEN
             CALL cl_err('insert oze_file',SQLCA.sqlcode,0)
             EXIT FOREACH
          END IF
          LET l_i = l_i + 1
       END FOREACH

       CALL t940_b_fill()

END FUNCTION

FUNCTION t940_b_fill()              #BODY FILL UP

    LET g_sql =
        "SELECT oze03,oze04,oze05,oze06,oze07,oze08 ",
        " FROM oze_file,adf_file,adg_file ",
        " WHERE oze01 ='",g_adg.adg01,"'",  #單頭
        "   AND oze02 = ",g_adg.adg02,
        "   AND ",g_wc CLIPPED,                     #單身
        "   AND adf01 = adg01 ",
        "   AND adg01 = oze01 ",
        "   AND adg02 = oze02 ",
        " ORDER BY oze03,oze04,oze05,oze06,oze07,oze08 "

    PREPARE t940_pb FROM g_sql
    DECLARE oze_curs CURSOR FOR t940_pb

    CALL g_oze.clear()
    LET g_cnt = 1
    FOREACH oze_curs INTO g_oze[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_oze.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION t940_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)


   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oze TO s_oze.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t940_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION previous
         CALL t940_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL t940_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t940_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t940_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
#單身
FUNCTION t940_b()
DEFINE
     l_za05          LIKE za_file.za05,     #MOD-4B0067
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重復用        #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,    #可新增否          #No.FUN-680108 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1     #可刪除否          #No.FUN-680108 VARCHAR(01)

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_adg.adg01) OR cl_null(g_adg.adg02) THEN
       RETURN
    END IF

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    SELECT adf00,adg01,adg02,adg09,adg05,adf03,adf05 INTO g_adg.*
      FROM adf_file,adg_file
     WHERE adg_file.ROWID = g_adg_rowid
       AND adf01 = adg01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adg.adg01,SQLCA.sqlcode,0)
        INITIALIZE g_adg.* TO NULL
        RETURN
    END IF

    CALL t940_g_b()
    DECLARE t940_za_cur CURSOR FOR
            SELECT za02,za05 FROM za_file
             WHERE za01 = "axdt940" AND za03 = g_lang
    FOREACH t940_za_cur INTO g_i,l_za05
       LET g_x[g_i] = l_za05
    END FOREACH

    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT oze03,oze04,oze05,oze06,oze07,oze08 ",
                       "  FROM oze_file ",
                       " WHERE oze01 = ? ",
                       "   AND oze02 = ? ",
                       "   AND oze03 = ? ",
                       " FOR UPDATE NOWAIT  "
    DECLARE t940_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    INPUT ARRAY g_oze WITHOUT DEFAULTS FROM s_oze.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_oze_t.* = g_oze[l_ac].*  #BACKUP
                OPEN t940_bcl USING g_adg.adg01,g_adg.adg02,g_oze_t.oze03
                IF STATUS THEN
                   CALL cl_err("OPEN t940_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t940_bcl INTO g_oze[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err("FETCH t940_bcl",SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_oze[l_ac].* TO NULL      #900423
            LET g_oze_t.* = g_oze[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD oze03

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_oze[l_ac].oze07) THEN LET g_oze[l_ac].oze07 = '' END IF
           IF cl_null(g_oze[l_ac].oze08) THEN LET g_oze[l_ac].oze08 = '' END IF
           INSERT INTO oze_file(oze01,oze02,oze03,oze04,oze05,oze06,       #TQC-5B0194
                                oze07,oze08,oze09,oze10,oze11)
            VALUES(g_adg.adg01,g_adg.adg02,g_oze[l_ac].oze03,
                   g_oze[l_ac].oze04,g_oze[l_ac].oze05,g_oze[l_ac].oze06,
                   g_oze[l_ac].oze07,g_oze[l_ac].oze08,'','','')
           IF SQLCA.sqlcode THEN
               CALL cl_err("INSERT oze_file",SQLCA.sqlcode,1)
               CANCEL INSERT
           ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
           END IF

        BEFORE FIELD oze03                        #default 序號
            IF g_oze[l_ac].oze03 IS NULL OR
               g_oze[l_ac].oze03 = 0 THEN
                SELECT max(oze03)+1
                   INTO g_oze[l_ac].oze03
                   FROM oze_file
                   WHERE oze01 = g_adg.adg01
                     AND oze02 = g_adg.adg02
                IF g_oze[l_ac].oze03 IS NULL THEN
                    LET g_oze[l_ac].oze03 = 1
                END IF
            END IF

        AFTER FIELD oze03                        #check 序號是否重復
            IF NOT cl_null(g_oze[l_ac].oze03) THEN
               IF g_oze[l_ac].oze03 != g_oze_t.oze03 OR
                  g_oze_t.oze03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM oze_file
                    WHERE oze01 = g_adg.adg01
                      AND oze02 = g_adg.adg02
                      AND oze03 = g_oze[l_ac].oze03
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_oze[l_ac].oze03 = g_oze_t.oze03
                      NEXT FIELD oze03
                   END IF
               END IF
            END IF
        BEFORE FIELD oze05
            CASE g_oze[l_ac].oze04
                  WHEN 'O' MESSAGE g_x[11] #Master B/L
                  WHEN 'A' MESSAGE g_x[12] #Airway B/L
                  WHEN 'C' MESSAGE g_x[13] #Contain No
                  WHEN 'H' MESSAGE g_x[14] #Houser B/L
                  WHEN 'E' MESSAGE g_x[15] #快遞單號
            END CASE

        AFTER FIELD oze05
            MESSAGE ""

        BEFORE FIELD oze06
            CASE
                WHEN g_oze[l_ac].oze04 MATCHES '[OC]' MESSAGE g_x[16] #海運公司代碼
                WHEN g_oze[l_ac].oze04 = 'A'          MESSAGE g_x[17] #航空公司代碼
                WHEN g_oze[l_ac].oze04 = 'H'          MESSAGE g_x[18] #統一編號
                WHEN g_oze[l_ac].oze04 = 'E'          MESSAGE g_x[19] #快遞業者代碼
            END CASE
        AFTER FIELD oze06
            MESSAGE ""
            IF NOT cl_null(g_oze[l_ac].oze06) THEN
                IF g_oze[l_ac].oze04 MATCHES '[OC]' THEN
                    SELECT COUNT(*) INTO l_n FROM ozb_file
                     WHERE ozb01 = g_oze[l_ac].oze06
                       AND ozbacti = 'Y'
                    IF l_n <= 0 THEN
                        #無此海運公司代碼,或此代碼已無效,請重新輸入!
                        CALL cl_err(g_oze[l_ac].oze06,'axm-912',1)
                        NEXT FIELD oze06
                    END IF
                END IF
                IF g_oze[l_ac].oze04 = 'A' THEN
                    SELECT COUNT(*) INTO l_n FROM oza_file
                     WHERE oza01 = g_oze[l_ac].oze06
                       AND ozaacti = 'Y'
                    IF l_n <= 0 THEN
                        #無此航空公司代碼,或此代碼已無效,請重新輸入!
                        CALL cl_err(g_oze[l_ac].oze06,'axm-913',1)
                        NEXT FIELD oze06
                    END IF
                END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF g_oze_t.oze03 > 0 AND
               g_oze_t.oze03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
               DELETE FROM oze_file
                WHERE oze01 = g_adg.adg01
                  AND oze02 = g_adg.adg02
                  AND oze03 = g_oze_t.oze03
               IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_oze_t.oze03,SQLCA.sqlcode,0)
                  CALL cl_err("DELETE oze_file",SQLCA.sqlcode,0)
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               MESSAGE "Delete Ok"
               CLOSE t940_bcl
               COMMIT WORK
            END IF

     ON ROW CHANGE
            IF INT_FLAG THEN                 #新增程式段
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_oze[l_ac].* = g_oze_t.*
               CLOSE t940_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_oze[l_ac].oze03,-263,1)
               LET g_oze[l_ac].* = g_oze_t.*
            ELSE
               UPDATE oze_file SET oze03=g_oze[l_ac].oze03,
                                   oze04=g_oze[l_ac].oze04,
                                   oze05=g_oze[l_ac].oze05,
                                   oze06=g_oze[l_ac].oze06,
                                   oze07=g_oze[l_ac].oze07,
                                   oze08=g_oze[l_ac].oze08
                WHERE oze01=g_adg.adg01
                  AND oze02=g_adg.adg02
                  AND oze03=g_oze_t.oze03
               IF SQLCA.sqlcode THEN
                 #CALL cl_err(g_oze[l_ac].oze03,SQLCA.sqlcode,1)
                  CALL cl_err("UPDATE oze_file",SQLCA.sqlcode,1)
                  LET g_oze[l_ac].* = g_oze_t.*
                  CLOSE t940_bcl
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE t940_bcl
                  COMMIT WORK
               END IF
            END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac

           IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_oze[l_ac].* = g_oze_t.*
               END IF
               CLOSE t940_bcl
               ROLLBACK WORK
               EXIT INPUT
           END IF
           CLOSE t940_bcl
           COMMIT WORK

        ON ACTION CONTROLP
            IF g_oze[l_ac].oze04 MATCHES '[OC]' THEN
                CASE
                    WHEN INFIELD(oze06) #運輸業者代碼
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_ozb" #海運
                         LET g_qryparam.default1 = g_oze[l_ac].oze06
                         CALL cl_create_qry() RETURNING g_oze[l_ac].oze06
                         NEXT FIELD oze06
                    OTHERWISE
                        EXIT CASE
                END CASE
            END IF
            IF g_oze[l_ac].oze04 = 'A' THEN
                CASE
                    WHEN INFIELD(oze06) #運輸業者代碼
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_oza" #航運
                         LET g_qryparam.default1 = g_oze[l_ac].oze06
                         CALL cl_create_qry() RETURNING g_oze[l_ac].oze06
                         NEXT FIELD oze06
                    OTHERWISE
                        EXIT CASE
                END CASE
            END IF

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(oze03) AND l_ac > 1 THEN
                LET g_oze[l_ac].* = g_oze[l_ac-1].*
                LET g_oze[l_ac].oze03 = NULL
                NEXT FIELD oze03
            END IF
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

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
 
 
        END INPUT

    CLOSE t940_bcl
    COMMIT WORK

END FUNCTION
#Patch....NO:TQC-610037 <001,002> #

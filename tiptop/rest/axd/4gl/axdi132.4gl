# Prog. Version..: '5.10.00-08.01.04(00000)'     #
# Pattern name...: axdi132.4gl
# Descriptions...: 下階工廠銷售預測維護作業
# Date & Author..: 04/03/25 By Hawk
# Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改.INSERT INTO...
# Modify.........: 04/11/08 By Carrier Bugno:MOD-4B0046
# Modify.........: 04/11/18 By DAY  Bugno:MOD-4B0067 將變數用Like方式定義
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask 
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/09 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件 
# Modify.........: No:FUN-6A0092 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_obd           RECORD LIKE obd_file.*,
    g_obd_t         RECORD LIKE obd_file.*,
    g_obd_o         RECORD LIKE obd_file.*,
    g_argv1         LIKE obd_file.obd01,
    g_argv2         LIKE obd_file.obd02,
    g_argv3         LIKE obd_file.obd021,
    g_argv4         LIKE obd_file.obd03,
    g_obd01_t       LIKE obd_file.obd01,
    g_obd_rowid     LIKE type_file.chr18,         #No.FUN-680108 INT
    g_obh           DYNAMIC ARRAY OF RECORD
                    obh04  LIKE obh_file.obh04,       #下階工廠
                    obh05  LIKE obh_file.obh05,       #下階需求量
                    obh06  LIKE obh_file.obh06,       #下階調整量
                    obh07  LIKE obh_file.obh07        #小計
                    END RECORD,
    g_obh_t         RECORD
                    obh04  LIKE obh_file.obh04,       #下階工廠
                    obh05  LIKE obh_file.obh05,       #下階需求量
                    obh06  LIKE obh_file.obh06,       #下階調整量
                    obh07  LIKE obh_file.obh07        #小計
                    END RECORD,
    g_obh_o         RECORD                 #程式變數 (舊值)
                    obh04  LIKE obh_file.obh04,       #下階工廠
                    obh05  LIKE obh_file.obh05,       #下階需求量
                    obh06  LIKE obh_file.obh06,       #下階調整量
                    obh07  LIKE obh_file.obh07        #小計
                    END RECORD,
    p_dbs           LIKE azp_file.azp03,
    g_obh05t        LIKE obh_file.obh05,
    g_obh06t        LIKE obh_file.obh06,
    g_obh07t        LIKE obh_file.obh07,
     g_sql               string,  #No:FUN-580092 HCN
     g_wc,g_wc2          string,  #No:FUN-580092 HCN
    p_row,p_col         LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    g_cmd               LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(60)
    g_count             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    g_log               LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
    g_rec_b             LIKE type_file.num5,          #單身筆數            #No.FUN-680108 SMALLINT
    l_ac                LIKE type_file.num5,          #目前處理的ARRAY CNT #No.FUN-680108 SMALLINT
    l_a                 LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
    i                   LIKE type_file.num5           #No.FUN-680108 SMALLINT
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE g_before_input_done  LIKE type_file.num5       #No.FUN-680108 SMALLINT

DEFINE   g_cnt          LIKE type_file.num10         #No.FUN-680108 INTEGER
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose    #No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(72)
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680108 INTEGER
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680108 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680108 SMALLINT   #No.FUN-6A0078

MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF
    LET g_wc2=' 1=1'
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    LET g_log = 'N'
    #UI
        LET p_row = 4 LET p_col = 7
    OPEN WINDOW i132_w AT p_row,p_col       #顯示畫面
        WITH FORM "axd/42f/axdi132"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No:FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_forupd_sql =
             "SELECT * FROM obd_file ",
             " WHERE obd01 = ?",
             " AND obd02 = ?",
             " AND obd021= ?",
             " AND obd03 = ?",
             " FOR UPDATE NOWAIT "
    DECLARE i132_cl CURSOR FROM g_forupd_sql
    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)
    IF NOT cl_null(g_argv1) THEN
            CALL i132_q()
       IF cl_null(g_obh[1].obh04) THEN
            CALL i132_g()
       END IF
    END IF
    CALL i132_menu()    #中文
    CLOSE WINDOW i132_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)          #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION i132_curs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
DEFINE l_flag      LIKE type_file.chr1                  #判斷單身是否給條件        #No.FUN-680108 VARCHAR(01)

    CLEAR FORM
    CALL g_obh.clear()                            #清除畫面
    LET l_flag = 'N'
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT ROWID,obd01 FROM obd_file ", # 組合出 SQL 指令
                " WHERE obd01 = '",g_argv1, "'",
                "   AND obd02 = '",g_argv2, "'",
                "   AND obd021= '",g_argv3, "'",
                "   AND obd03 = '",g_argv4, "'",
                "   ORDER BY obd01,obd021,obd02,obd03"
       LET g_wc =   "      obd01 = '",g_argv1, "'",
                    " AND  obd02 = '",g_argv2, "'",
                    " AND  obd021= '",g_argv3,"'",
                    " AND  obd03 = '",g_argv4, "'"
    ELSE  
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_obd.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
                 obd01,obd02,obc03,obd03,obc06,obdconf     # 螢幕上取單頭條件

            #No:FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            #No:FUN-580031 --end--       HCN

            ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

            #No:FUN-580031 --start--     HCN
            ON ACTION qbe_select
                CALL cl_qbe_list() RETURNING lc_qbe_sn
                CALL cl_qbe_display_condition(lc_qbe_sn)
            #No:FUN-580031 --end--       HCN
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
   
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
   
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
 
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
 
       CONSTRUCT g_wc2 ON obh04,obh05,obh06,obh07
       FROM s_obh[1].obh04,s_obh[1].obh05,s_obh[1].obh06,s_obh[1].obh07

            #No:FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)
            #No:FUN-580031 --end--       HCN

            ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT

            #No:FUN-580031 --start--     HCN
            ON ACTION qbe_save
                CALL cl_qbe_save()
            #No:FUN-580031 --end--       HCN
 
            ON ACTION about         #MOD-4C0121
               CALL cl_about()      #MOD-4C0121
   
            ON ACTION help          #MOD-4C0121
               CALL cl_show_help()  #MOD-4C0121
   
            ON ACTION controlg      #MOD-4C0121
               CALL cl_cmdask()     #MOD-4C0121
 
       END CONSTRUCT
       IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
       IF INT_FLAG THEN RETURN END IF
       IF l_flag = 'N' THEN			# 若單身未輸入條件
          LET g_sql = "SELECT obd_file.ROWID, obd01 FROM obd_file,obc_file ",
                      " WHERE obd01 = obc01",
                      "   AND obd02 = obc02 AND obd021 = obc021 ",
                      "   AND ", g_wc CLIPPED,
                      " ORDER BY 2"
       ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE obd_file.ROWID, obd01 ",
                      "  FROM obd_file,obc_file,obh_file ",
                      " WHERE obd01 = obc01",
                      "   AND obd02 = obc02 AND obd021 = obc021 ",
                      "   AND obd01 = obh01",
                      "   AND obd02 = obh02 AND obd021 = obh021 ",
                      "   AND obd03 = obh03",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY 2"
       END IF
    END IF

    PREPARE i132_prepare FROM g_sql
	DECLARE i132_curs
        SCROLL CURSOR WITH HOLD FOR i132_prepare

    IF l_flag = 'N' THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM obd_file,obc_file ",
                  " WHERE obd01 = obc01",
                  "   AND obd02 = obc02 AND obd021 = obc021 ",
                  "   AND ", g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) ",
                  "  FROM obd_file,obc_file,obh_file ",
                  " WHERE obd01 = obc01",
                  "   AND obd02 = obc02 AND obd021 = obc021 ",
                  "   AND obd01 = obh01",
                  "   AND obd02 = obh02 AND obd021 = obh021 ",
                  "   AND obd03 = obh03",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
    PREPARE i132_precount FROM g_sql
    DECLARE i132_count CURSOR FOR i132_precount
END FUNCTION

#中文的MENU
FUNCTION i132_menu()
   WHILE TRUE
      CALL i132_bp("G")
      CASE g_action_choice
         WHEN "genero_body"
            IF cl_chk_act_auth() THEN
                CALL i132_g()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL i132_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i132_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL i132_y()
                CALL cl_set_field_pic(g_obd.obdconf,"","","","","")  #NO.MOD-4B0046
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL i132_z()
                CALL cl_set_field_pic(g_obd.obdconf,"","","","","")  #NO.MOD-4B0046
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
                 IF g_obd.obd01 IS NOT NULL THEN
                 LET g_doc.column1 = "obd01"
                 LET g_doc.value1 = g_obd.obd01
                 CALL cl_doc()
               END IF
         END IF
         #No:FUN-6A0165-------add--------end----
      END CASE
   END WHILE
END FUNCTION



FUNCTION i132_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_obd.* TO NULL               #No.FUN-6A0165

    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_obh.clear()
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i132_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i132_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_obd.* TO NULL
    ELSE
        OPEN i132_count
        FETCH i132_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i132_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION

FUNCTION i132_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680108 VARCHAR(1)
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i132_curs INTO g_obd_rowid,g_obd.obd01
        WHEN 'P' FETCH PREVIOUS i132_curs INTO g_obd_rowid,g_obd.obd01
        WHEN 'F' FETCH FIRST    i132_curs INTO g_obd_rowid,g_obd.obd01
        WHEN 'L' FETCH LAST     i132_curs INTO g_obd_rowid,g_obd.obd01
        WHEN '/'
          IF (NOT mi_no_ask) THEN   #No.FUN-6A0078
             CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
             LET INT_FLAG = 0
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
          FETCH ABSOLUTE g_jump i132_curs INTO g_obd_rowid,g_obd.obd01
          LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obd.obd01,SQLCA.sqlcode,0)
        INITIALIZE g_obd.* TO NULL  #TQC-6B0105
        LET g_obd_rowid = NULL      #TQC-6B0105
        RETURN
    END IF
    SELECT * INTO g_obd.* FROM obd_file WHERE ROWID = g_obd_rowid
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obd.obd01,SQLCA.sqlcode,0)
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
    CALL i132_show()
END FUNCTION

FUNCTION i132_show()
 DEFINE  l_ima02   LIKE ima_file.ima02,
         l_obc03   LIKE obc_file.obc03,
         l_obc06   LIKE obc_file.obc06,
         l_obc07   LIKE obc_file.obc07

    LET g_obd_t.* = g_obd.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
    g_obd.obd01,g_obd.obd02,g_obd.obd021,g_obd.obd03,g_obd.obdconf
     CALL cl_set_field_pic(g_obd.obdconf,"","","","","")  #NO.MOD-4B0046
    SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = g_obd.obd01
    IF SQLCA.sqlcode THEN LET l_ima02 = ' ' END IF
    DISPLAY l_ima02 TO FORMONLY.ima02
    SELECT obc03,obc06,obc07 INTO l_obc03,l_obc06,l_obc07
      FROM obc_file
     WHERE obc01 = g_obd.obd01
       AND obc02 = g_obd.obd02
       AND obc021= g_obd.obd021
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    END IF
    DISPLAY l_obc03,l_obc06,l_obc07 TO obc03,obc06,obc07
    CALL i132_b_fill(g_wc2)                #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i132_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT#No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用      #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否      #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680108 VARCHAR(1)
    l_buf           LIKE type_file.chr1000,                   #No.FUN-680108 VARCHAR(40)
    l_cmd           LIKE type_file.chr1000,                   #No.FUN-680108 VARCHAR(200)
    l_uflag,l_chr   LIKE type_file.chr1,                      #No.FUN-680108 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否        #No.FUN-680108 SMALLINT

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_obd.obd01) THEN
        RETURN
    END IF
    IF g_obd.obdconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_obd.obd01,'9023',0)
        RETURN
    END IF
    IF cl_null(g_obh[1].obh04) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    LET l_uflag ='N'
    CALL cl_opmsg('b')
    LET g_forupd_sql =
        "SELECT obh04,obh05,obh06,obh07,'' ",
        "FROM   obh_file ",
        "WHERE  obh01  = ? ",
        " AND  obh02  = ?",
        "  AND  obh021 = ?",
        "  AND  obh03  = ?",
        "  AND  obh04  = ?",
        "  FOR UPDATE NOWAIT "
    DECLARE i132_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0
        INPUT ARRAY g_obh
              WITHOUT DEFAULTS FROM s_obh.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEn
               CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            IF l_ac > g_count THEN
               EXIT INPUT
            END IF
 
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_obh_t.* = g_obh[l_ac].*  #BACKUP
                LET g_obh_o.* = g_obh[l_ac].*
                OPEN i132_b_curl
                USING g_obd.obd01,g_obd.obd02,g_obd.obd021,g_obd.obd03,g_obh_t.obh04
                IF STATUS THEN
                  CALL cl_err("OPEN i132_b_curl:", STATUS, 1)
                  LET l_lock_sw = "Y"
                ELSE
                  FETCH i132_b_curl INTO g_obh[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_obh_t.obh04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'                     #輸入新資料
            INITIALIZE g_obh[l_ac].* TO NULL  #900423
            LET g_obh_t.* = g_obh[l_ac].*     #新輸入資料
            LET g_obh_o.* = g_obh[l_ac].*     #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obh06
 
        AFTER FIELD obh06
            IF  NOT cl_null(g_obh[l_ac].obh06) THEN
                LET g_obh[l_ac].obh07 = g_obh[l_ac].obh06 + g_obh[l_ac].obh05
                IF g_obh[l_aC].obh07 < 0 THEN
                   CALL cl_err('','axd-095',0)
                   NEXT FIELD obh06
                END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_obh_t.obh04) THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM obh_file
                    WHERE obh01 = g_obd.obd01  AND
                          obh02 = g_obd.obd02  AND
                          obh021= g_obd.obd021 AND
                          obh03 = g_obd.obd03  AND
                          obh04 = g_obh_t.obh04
                IF SQLCA.sqlcode THEN
                    LET l_buf = g_obh_t.obh04 clipped
                    CALL cl_err(l_buf,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obh[l_ac].* = g_obh_t.*
               CLOSE i132_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obh[l_ac].obh04,-263,1)
               LET g_obh[l_ac].* = g_obh_t.*
            ELSE
    UPDATE obh_file
       set obh06=g_obh[l_ac].obh06,obh07=g_obh[l_ac].obh07
     WHERE obh01  = g_obd.obd01                             
       AND obh02  = g_obd.obd02                             
       AND obh021 = g_obd.obd021
       AND obh03  = g_obd.obd03
       AND obh04  = g_obh[l_ac].obh04
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_obh[l_ac].obh04,SQLCA.sqlcode,0)
                 LET g_obh[l_ac].* = g_obh_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'
                LET g_obh_t.* = g_obh[l_ac].*
                CALL i132_count()
                CALL i132_obh_t()
                COMMIT WORK
              END IF
            END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obh[l_ac].* = g_obh_t.*
               END IF
               CLOSE i132_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i132_b_curl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i132_b_askkey()
            EXIT INPUT
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
 
       CLOSE i132_b_curl
       COMMIT WORK
END FUNCTION

###### 取得下階工廠########
FUNCTION i132_obh04()
DEFINE  l_cmd  LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(300)
        l_adb02  LIKE adb_file.adb02
 
     LET l_cmd = " SELECT adb02 FROM adb_file",
                 "  WHERE adb01 = '",g_plant,"'"
     PREPARE i132_prepare1 FROM l_cmd
     DECLARE i132_cur1 CURSOR FOR i132_prepare1
     LET i = 1
     FOREACH i132_cur1 INTO g_obh[i].obh04
      IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET i = i+1
      IF i > g_count THEN EXIT FOREACH END IF
    END FOREACH
END FUNCTION

#######取得下階需求量#######
FUNCTION i132_obh05()
DEFINE l_cmd LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(300)
       l_azp03 LIKE azp_file.azp03
 FOR i = 1 To g_count
    SELECT azp03 INTO l_azp03 FROM azp_file
     WHERE azp01 = g_obh[i].obh04
    IF SQLCA.sqlcode THEN
        CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
    END IF
    LET p_dbs = l_azp03
 
     LET l_cmd = " SELECT obd12",  #No.MOD-4B0046
                "   FROM ",p_dbs CLIPPED,".obd_file,",
                           p_dbs CLIPPED,".obc_file",
                "  WHERE obd01 = '",g_obd.obd01,"'",
                "   AND  obd02 = '",g_obd.obd02,"'",
                "   AND  obd021= '",g_obd.obd021,"'",
                "   AND  obd03 = '",g_obd.obd03,"'",
                "   AND  obc01 = obd01",
                "   AND  obc02 = obd02",
                "   AND  obc021= obd021",
                "   AND  obcconf = 'Y'"
    PREPARE i132_prepare2 FROM l_cmd
    DECLARE i132_cur2 CURSOR FOR i132_prepare2
    FOREACH i132_cur2 INTO g_obh[i].obh05
      IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
    END FOREACH
    IF cl_null(g_obh[i].obh05) THEN LET g_obh[i].obh05 = 0 END IF
END FOR
END FUNCTION

########取得下階工廠個數#######
FUNCTION i132_count()
    SELECT COUNT(adb02) INTO g_count FROM adb_file
     WHERE adb01 = g_plant
    IF SQLCA.sqlcode THEN
         CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
    END IF
    IF cl_null(g_count) THEN LET g_count = 0 END IF
END FUNCTION

#######求和###################
FUNCTION i132_obh_t()
    LET g_obh05t = 0
    LET g_obh06t = 0
    LET g_obh07t = 0
    FOR i = 1 TO g_count
       LET g_obh05t = g_obh05t + g_obh[i].obh05
       LET g_obh06t = g_obh06t + g_obh[i].obh06
       LET g_obh07t = g_obh07t + g_obh[i].obh07
    END FOR
    DISPLAY g_obh05t,g_obh06t,g_obh07t TO obh05t,obh06t,obh07t
    CALL i132_i130()
END FUNCTION

########返回130值#############
FUNCTION i132_i130()
DEFINE l_obd12 LIKE obd_file.obd12
    IF g_obd.obd01 IS NULL THEN RETURN END IF
    SELECT * INTO g_obd.* FROM obd_file
     WHERE obd01 = g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
 
 #NO.MOD-4B0046   --begin
{
    BEGIN WORK
    OPEN i132_cl  USING g_obd.obd01,g_obd.obd02,g_obd.obd021,g_obd.obd03
    IF STATUS THEN
       CALL cl_err("OPEN i132_cl:", STATUS, 1)
       CLOSE i132_cl
       ROLLBACK WORK
       RETURN
    END IF
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obd.obd01,SQLCA.sqlcode,0)
        CLOSE i132_cl
        ROLLBACK WORK
        RETURN
    END IF
    FETCH i132_cl INTO g_obd.*  # 對DB鎖定
}
 UPDATE obd_file SET obd10=g_obh05t,obd11=g_obh06t
     WHERE obd01 = g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
    IF STATUS THEN
       CALL cl_err('upd obd10,obd11',STATUS,0)
       LET g_success='N'
       RETURN
    END IF
    UPDATE obd_file SET obd12 =(obd08+obd10+obd11),
                        obd07 =(obd08+obd10+obd11)*obd06
     WHERE obd01 = g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
    IF STATUS THEN
       CALL cl_err('upd obd10,obd11',STATUS,0)
       LET g_success='N'
       RETURN
    END IF
#    COMMIT WORK
 #NO.MOD-4B0046   --end
END FUNCTION

###########更新下階工廠的本階調整量########
FUNCTION i132_obd09(p_code)
 #NO.MOD-4B0046   --begin
DEFINE l_azp03 LIKE azp_file.azp03,
       p_code  LIKE type_file.chr1,         #No.FUN-680108 VARCHAR(01)
       l_obd09 LIKE obd_file.obd09,
       l_cmd   LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(300)
    FOR i =1 TO g_count
        SELECT distinct(azp03) INTO l_azp03
          FROM azp_file,adb_file
         WHERE adb02 = g_obh[i].obh04
           AND adb02 = azp01
        IF SQLCA.sqlcode THEN
            CALL cl_err('cannot foreach ',SQLCA.sqlcode,1)
            LET g_success='N'
            RETURN
        END IF
        LET p_dbs = l_azp03
{
        BEGIN WORK
        OPEN i132_cl  USING g_obd.obd01,g_obd.obd02,g_obd.obd021,g_obd.obd03
        IF STATUS THEN
           CALL cl_err("OPEN i132_cl:", STATUS, 1)
           CLOSE i132_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH i132_cl INTO g_obd.*  # 對DB鎖定
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_obd.obd01,SQLCA.sqlcode,0)
           CLOSE i132_cl
           ROLLBACK WORK
           RETURN
        END IF
}
        IF p_code='1' THEN
           LET l_obd09 = g_obh[i].obh06
        ELSE
           LET l_obd09 = 0
        END IF
 
        LET l_cmd = " UPDATE ",p_dbs CLIPPED,".obd_file",
                    "    SET obd09 =",l_obd09,
                    "  WHERE obd01 ='",g_obd.obd01,"'",
                    "    AND obd02 ='",g_obd.obd02,"'",
                    "    AND obd021='",g_obd.obd021,"'",
                    "    AND obd03 ='",g_obd.obd03,"'"
        PREPARE i132_curs1 FROM l_cmd
        IF STATUS THEN
           CALL cl_err('upd obd09',STATUS,0)
           LET g_success='N'
           RETURN
        END IF
        EXECUTE i132_curs1
#        COMMIT WORK
    END FOR
 #NO.MOD-4B0046   --end
END FUNCTION

FUNCTION i132_g()
DEFINE l_n   LIKE type_file.num5          #No.FUN-680108 SMALLINT
    CALL i132_count()
    IF g_count = 0 THEN RETURN END IF
    IF g_obd.obdconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_obd.obd01,'9023',0)
        RETURN
    END IF
    IF NOT cl_null(g_obh[1].obh04) THEN
        IF NOT cl_confirm('axd-092') THEN
            RETURN
        END IF
    END IF
    CALL i132_obh04()
    CALL i132_obh05()
 
    FOR i = 1 TO g_count
        IF cl_null(g_obh[i].obh06) THEN
            LET g_obh[i].obh06 = 0
            LET g_obh[i].obh07 = g_obh[i].obh05 + g_obh[i].obh06
#            DISPLAY g_obh[i].obh04 TO s_obh[i].obh04
#            DISPLAY g_obh[i].obh05 TO s_obh[i].obh05
#            DISPLAY g_obh[i].obh06 TO s_obh[i].obh06
#            DISPLAY g_obh[i].obh07 TO s_obh[i].obh07
            INSERT INTO obh_file(obh01,obh02,obh021,obh03,obh04,obh05,obh06,
                                  obh07,obh08,obh09) #No.MOD-470041
                          VALUES(g_obd.obd01,g_obd.obd02,
                                 g_obd.obd021,g_obd.obd03,
                                 g_obh[i].obh04,g_obh[i].obh05,
                                 g_obh[i].obh06,g_obh[i].obh07,'','')
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_obh[i].obh04,SQLCA.sqlcode,0)
            ELSE
                MESSAGE 'INSERT O.K'
            END IF
        ELSE
UPDATE obh_file SET obh05=g_obh[i].obh05,obh07=obh06 + g_obh[i].obh05
                   WHERE obh01 = g_obd.obd01
                     AND obh02 = g_obd.obd02
                     AND obh021= g_obd.obd021
                     AND obh03 = g_obd.obd03
                     AND obh04 = g_obh[i].obh04
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_obh[i].obh04,SQLCA.sqlcode,0)
            ELSE
                MESSAGE 'UPDTE O.K'
            END IF
        END IF
   END FOR
  LET g_wc = " 1=1"
  CALL i132_b_fill(g_wc)
  LET g_obh_t.* = g_obh[1].*
  CALL i132_show()
END FUNCTION

FUNCTION i132_y()
DEFINE l_obcconf   LIKE obc_file.obcconf
    IF g_obd.obd01 IS NULL THEN RETURN END IF
    SELECT * INTO g_obd.* FROM obd_file
     WHERE obd01 = g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
    IF g_obd.obdconf='Y' THEN RETURN END IF
    IF NOT cl_confirm('axm-108') THEN RETURN END IF
    LET g_success='Y'
    BEGIN WORK
    OPEN i132_cl  USING g_obd.obd01,g_obd.obd02,g_obd.obd021,g_obd.obd03
    IF STATUS THEN
       CALL cl_err("OPEN i132_cl:", STATUS, 1)
       CLOSE i132_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i132_cl INTO g_obd.*  # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_obd.obd01,SQLCA.sqlcode,0)
        CLOSE i132_cl
        ROLLBACK WORK
        RETURN
    END IF
    UPDATE obd_file SET obdconf='Y'
     WHERE obd01 = g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
    IF STATUS THEN
       CALL cl_err('upd obdconf',STATUS,0)
       LET g_success = 'N'
    END IF
    CALL i132_i130()
    CALL i132_obd09('1')
    IF g_success = 'Y' THEN
       COMMIT WORK
       CALL cl_cmmsg(1)
    ELSE
       ROLLBACK WORK
       CALL cl_rbmsg(1)
    END IF
    SELECT obdconf INTO g_obd.obdconf FROM obd_file
     WHERE obd01 = g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
    DISPLAY BY NAME g_obd.obdconf
END FUNCTION

FUNCTION i132_z() #取消確認
DEFINE l_obcconf   LIKE obc_file.obcconf
    SELECT obcconf INTO l_obcconf FROM obc_file
     WHERE obc01 = g_obd.obd01
       AND obc02 = g_obd.obd02
       AND obc021= g_obd.obd021
    IF l_obcconf = 'Y' THEN
        CALL cl_err(g_obd.obd01,'axd-094',0)
        RETURN
    END IF
    IF g_obd.obd01 IS NULL THEN RETURN END IF
    SELECT * INTO g_obd.* FROM obd_file
     WHERE obd01=g_obd.obd01
       AND obd02 = g_obd.obd02
       AND obd021= g_obd.obd021
       AND obd03 = g_obd.obd03
    IF g_obd.obdconf='N' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF
    LET g_success='Y'
    BEGIN WORK
        UPDATE obd_file SET obdconf='N'
            WHERE obd01 = g_obd.obd01
              AND obd02 = g_obd.obd02
              AND obd021= g_obd.obd021
              AND obd03 = g_obd.obd03
        IF STATUS THEN
            CALL cl_err('upd cofconf',STATUS,0)
            LET g_success='N'
        END IF
 #NO.MOD-4B0046  --begin
        UPDATE obd_file SET obd10=0,obd11=0,obd12=obd08,obd07=obd06*obd08
            WHERE obd01 = g_obd.obd01
              AND obd02 = g_obd.obd02
              AND obd021= g_obd.obd021
              AND obd03 = g_obd.obd03
        IF STATUS THEN
            CALL cl_err('upd obd_file',STATUS,0)
            LET g_success='N'
        END IF
        CALL i132_obd09('2')
 #NO.MOD-4B0046  --end
 
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT obdconf INTO g_obd.obdconf FROM obd_file
         WHERE obd01 = g_obd.obd01
           AND obd02 = g_obd.obd02
           AND obd021= g_obd.obd021
           AND obd03 = g_obd.obd03
        DISPLAY BY NAME g_obd.obdconf
END FUNCTION

FUNCTION i132_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc2 ON obh04,obh05,obh06,obh07
         FROM s_obh[1].obh04,s_obh[1].obh05,
              s_obh[1].obh06,s_obh[1].obh07

         #No:FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No:FUN-580031 --end--       HCN

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         #No:FUN-580031 --start--     HCN
         ON ACTION qbe_select
            CALL cl_qbe_select()
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No:FUN-580031 --end--       HCN
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
  
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
  
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i132_b_fill(l_wc2)
END FUNCTION

FUNCTION i132_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(300)

    LET g_sql =
        "SELECT obh04,obh05,obh06,obh07",
        "  FROM obh_file",
        " WHERE obh01 ='",g_obd.obd01,"'",
        "   AND obh02 ='",g_obd.obd02,"'",
        "   AND obh021 ='",g_obd.obd021,"'",
        "   AND obh03 ='",g_obd.obd03,"'",
        "   AND ", p_wc2 CLIPPED                      #單身

    PREPARE i132_pb FROM g_sql
    DECLARE obh_curs                       #CURSOR
        CURSOR FOR i132_pb
    CALL g_obh.clear()

    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH obh_curs INTO g_obh[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt=g_cnt+1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_obh.deleteElement(g_cnt)

    LET g_rec_b = g_cnt - 1               #告訴I.單身筆數
    DISPLAY g_rec_b TO FORMONLY.cn2

    CALL i132_count()
    CALL i132_obh_t()
        LET g_cnt = 0
END FUNCTION

FUNCTION i132_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
      DISPLAY ARRAY g_obh TO s_obh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION genero_body
         LET g_action_choice="genero_body"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION first
         CALL i132_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL i132_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION jump
         CALL i132_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION next
         CALL i132_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST

      ON ACTION last
         CALL i132_fetch('L')
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

      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092

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

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 #NO.MOD-4B0046  --begin
{
}
 #NO.MOD-4B0046  --end
#Patch....NO:TQC-610037 <001,002> #

# Prog. Version..: '5.10.00-08.01.04(00000)'     #
#
# Pattern name...: axdi122.4gl
# Descriptions...: 派車單其它托運物品維護作業
# Date & Author..: 03/12/03 By Carrier
# Modify.........: 04/07/19 By Wiky Bugno:MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4B0067 04/11/09 By Elva 將變數用Like方式定義
# Modify.........: No:FUN-4C0052 04/12/08 By pengu Data and Group權限控管
# Modify.........: No:FUN-520024 05/02/25 報表轉XML By wujie
# Modify.........: NO.FUN-550026 05/05/20 By jackie 單據編號加大
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: Mo.FUN-6A0078 06/10/24 By xumin g_no_ask改mi_no_ask
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:FUN-6A0165 06/11/10 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No:FUN-6A0092 06/11/13 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No:TQC-6A0095 06/11/13 By xumin 時間問題更改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No:FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adk           RECORD LIKE adk_file.*,       #員工代號(假單頭)
    g_adk_t         RECORD LIKE adk_file.*,       #員工代號(舊值)
    g_adk_o         RECORD LIKE adk_file.*,       #員工代號(舊值)
    g_argv1         LIKE adk_file.adk01,          #No.FUN-680108 VARCHAR(10)
    g_adk01_t       LIKE adk_file.adk01,   #(舊值)
    g_adk_rowid     LIKE type_file.chr18,         #ROWID        #No.FUN-680108 INT
    g_adm           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
                    adm02  LIKE adm_file.adm02,   #項次
                    adm03  LIKE adm_file.adm03,   #類別
                    desc   LIKE type_file.chr4,   #簡稱            #No.FUN-680108 VARCHAR(04)
                    adm04  LIKE adm_file.adm04,   #件數
                    adm05  LIKE adm_file.adm05,   #說明
                    adm06  LIKE adm_file.adm06,   #委托人
                    gen02a LIKE gen_file.gen02,   #姓名
                    adm08  LIKE adm_file.adm08,   #收件人
                    adm07  LIKE adm_file.adm07    #收件單位
                    END RECORD,
    g_adm_t         RECORD                 #程式變數 (舊值)
                    adm02  LIKE adm_file.adm02,   #項次
                    adm03  LIKE adm_file.adm03,   #類別
                    desc   LIKE type_file.chr4,   #簡稱            #No.FUN-680108 VARCHAR(04)
                    adm04  LIKE adm_file.adm04,   #件數
                    adm05  LIKE adm_file.adm05,   #說明
                    adm06  LIKE adm_file.adm06,   #委托人
                    gen02a LIKE gen_file.gen02,   #姓名
                    adm08  LIKE adm_file.adm08,   #收件人
                    adm07  LIKE adm_file.adm07    #收件單位
                    END RECORD,
    g_adm_o         RECORD                 #程式變數 (舊值)
                    adm02  LIKE adm_file.adm02,   #項次
                    adm03  LIKE adm_file.adm03,   #類別
                    desc   LIKE type_file.chr4,   #簡稱            #No.FUN-680108 VARCHAR(04)
                    adm04  LIKE adm_file.adm04,   #件數
                    adm05  LIKE adm_file.adm05,   #說明
                    adm06  LIKE adm_file.adm06,   #委托人
                    gen02a LIKE gen_file.gen02,   #姓名
                    adm08  LIKE adm_file.adm08,   #收件人
                    adm07  LIKE adm_file.adm07    #收件單位
                    END RECORD,
     g_sql          STRING,  #No:FUN-580092 HCN 
     g_wc,g_wc2     STRING,  #No:FUN-580092 HCN 
    p_row,p_col     LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    g_cmd           LIKE type_file.chr1000,       #No.FUN-680108 VARCHAR(60)
    g_rec_b         LIKE type_file.num5,          #單身筆數      #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5           #目前處理的ARRAY CNT#No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5         #No.FUN-680108 SMALLINT
 
DEFINE   g_forupd_sql   STRING   #SELECT ... FOR UPDATE NOWAIT SQL 
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680108 INTEGER
DEFINE   g_chr          LIKE type_file.chr1     #No.FUN-680108 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose#No.FUN-680108 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000  #No.FUN-680108 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10                           #No.FUN-680108 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10                           #No.FUN-680108 INTEGER
DEFINE   g_jump         LIKE type_file.num10                           #No.FUN-680108 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5                            #No.FUN-680108 SMALLINT   #No.FUN-6A0078

#主程式開始
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
    LET p_row = 3 LET p_col = 10

    OPEN WINDOW i122_w AT p_row,p_col         #顯示畫面
        WITH FORM "axd/42f/axdi122"
        ATTRIBUTE(STYLE = g_win_style)
 
    CALL cl_ui_init()
    CALL g_x.clear()
 
 
    LET g_argv1 = ARG_VAL(1)
    IF NOT cl_null(g_argv1)
       THEN CALL i122_q()
            CALL i122_b_fill(g_wc2)
	    CALL i122_b()
    END IF
    CALL i122_menu()    #中文
    CLOSE WINDOW i122_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

#QBE 查詢資料
FUNCTION i122_curs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No:FUN-580031  HCN
	DEFINE l_flag      LIKE type_file.chr1     #判斷單身是否給條件        #No.FUN-680108 VARCHAR(01)

    CLEAR FORM                             #清除畫面
    LET l_flag = 'N'
    IF NOT cl_null(g_argv1)  THEN
       LET g_sql="SELECT ROWID,adk01 FROM adk_file ", # 組合出 SQL 指令
                " WHERE adk01 = '",g_argv1, "' ORDER BY adk01"
       LET g_wc = " adk01 = '",g_argv1, "'"
    ELSE
       CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_adk.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
       adk01,adk02,adk04,adk05,adk06,adk07,adk08,adk13,adk14,adk15,
          adkconf,adkuser,adkgrup,adkmodu,adkdate,adkacti

            #No:FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
            #No:FUN-580031 --end--       HCN

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
                CALL cl_qbe_list() RETURNING lc_qbe_sn
                CALL cl_qbe_display_condition(lc_qbe_sn)
            #No:FUN-580031 --end--       HCN
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       #資料權限的檢查
       IF g_priv2='4' THEN                           #只能使用自己的資料
          LET g_wc = g_wc clipped," AND adkuser = '",g_user,"'"
       END IF
       IF g_priv3='4' THEN                           #只能使用相同群的資料
          LET g_wc = g_wc clipped," AND adkgrup MATCHES '",g_grup CLIPPED,"*'"
       END IF

       IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
          LET g_wc = g_wc clipped," AND adkgrup IN ",cl_chk_tgrup_list()
       END IF


       CONSTRUCT g_wc2 ON adm02,adm03,adm04,adm05,adm06,adm08,adm07
       FROM s_adm[1].adm02,s_adm[1].adm03,s_adm[1].adm04,s_adm[1].adm05,
            s_adm[1].adm06,s_adm[1].adm08,s_adm[1].adm07

        #No:FUN-580031 --start--     HCN
        BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
        #No:FUN-580031 --end--       HCN

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adm06)
#                   CALL q_gen(0,0,g_adm[l_ac].adm06)
#                        RETURNING g_adm[l_ac].adm06
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO s_adm[1].adm06
                    NEXT FIELD adm06
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
 
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_save
          CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
       END CONSTRUCT
       IF g_wc2 != " 1=1" THEN LET l_flag = 'Y' END IF
       IF INT_FLAG THEN RETURN END IF
       IF l_flag = 'N' THEN			# 若單身未輸入條件
          LET g_sql = "SELECT ROWID, adk01 FROM adk_file ",
                      " WHERE ", g_wc CLIPPED,
                      " ORDER BY adk01"
       ELSE					# 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE adk_file.ROWID, adk01 ",
                      "  FROM adk_file, adm_file ",
                      " WHERE adk01 = adm01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY adk01"
       END IF
    END IF

    PREPARE i122_prepare FROM g_sql
	DECLARE i122_curs
        SCROLL CURSOR WITH HOLD FOR i122_prepare

    IF l_flag = 'N' THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM adk_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM adk_file,adm_file WHERE ",
                  "adm01=adk01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE i122_precount FROM g_sql
    DECLARE i122_count CURSOR FOR i122_precount
    OPEN i122_count
    FETCH i122_count INTO g_row_count
    CLOSE i122_count
END FUNCTION

FUNCTION i122_menu()

   WHILE TRUE
      CALL i122_bp("G")
      CASE g_action_choice
        WHEN "query"
           IF cl_chk_act_auth() THEN
              CALL i122_q()
           END IF
        WHEN "detail"
           IF cl_chk_act_auth() THEN
              CALL i122_b()
           ELSE
              LET g_action_choice = NULL
           END IF
#        WHEN "undo_confirm"
#           IF cl_chk_act_auth() THEN
#              CALL i122_z()
#           END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL i122_out()
           END IF
        WHEN "help"
           CALL cl_show_help()
        WHEN "exit"
           EXIT WHILE
        WHEN "controlg"
           CALL cl_cmdask()
        #No:FUN-6A0165-------adk--------str----
        WHEN "related_document"  #相關文件
             IF cl_chk_act_auth() THEN
                IF g_adk.adk01 IS NOT NULL THEN
                LET g_doc.column1 = "adk01"
                LET g_doc.value1 = g_adk.adk01
                CALL cl_doc()
              END IF
        END IF
        #No:FUN-6A0165-------adk--------end----
      END CASE
   END WHILE
END FUNCTION

FUNCTION i122_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_adk.* TO NULL               #No.FUN-6A0165 
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_adm.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL cl_getmsg('mfg2618',g_lang) RETURNING g_msg
    CALL i122_curs()
    IF INT_FLAG THEN
        INITIALIZE g_adk.* TO NULL
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! " ATTRIBUTE(REVERSE)
    OPEN i122_count
    FETCH i122_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i122_curs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL
    ELSE
        CALL i122_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE " "
END FUNCTION

FUNCTION i122_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680108 VARCHAR(1)

    CASE p_flag
        WHEN 'N' FETCH NEXT     i122_curs INTO g_adk_rowid,g_adk.adk01
        WHEN 'P' FETCH PREVIOUS i122_curs INTO g_adk_rowid,g_adk.adk01
        WHEN 'F' FETCH FIRST    i122_curs INTO g_adk_rowid,g_adk.adk01
        WHEN 'L' FETCH LAST     i122_curs INTO g_adk_rowid,g_adk.adk01
        WHEN '/'
          IF (NOT mi_no_ask) THEN    #No.FUN-6A0078
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
          FETCH ABSOLUTE g_jump i122_curs INTO g_adk_rowid,g_adk.adk01
          LET mi_no_ask = FALSE   #No.FUN-6A0078
    END CASE

    IF SQLCA.sqlcode THEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL  #TQC-6B0105
        LET g_adk_rowid = NULL      #TQC-6B0105
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
    SELECT * INTO g_adk.* FROM adk_file WHERE ROWID = g_adk_rowid
    IF SQLCA.sqlcode ThEN
        CALL cl_err(g_adk.adk01,SQLCA.sqlcode,0)
        INITIALIZE g_adk.* TO NULL
        RETURN
    ELSE                                    #FUN-4C0052權限控管
       LET g_data_owner=g_adk.adkuser
       LET g_data_group=g_adk.adkgrup
    END IF
    CALL i122_show()
END FUNCTION

FUNCTION i122_show()
 DEFINE  l_gen02   LIKE gen_file.gen02
 DEFINE  l_gem02   LIKE gem_file.gem02

    LET g_adk_t.* = g_adk.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
     g_adk.adk01,g_adk.adk02,g_adk.adk04,g_adk.adk05,
	g_adk.adk06,g_adk.adk07,g_adk.adk08,g_adk.adk13,
	g_adk.adk14,g_adk.adk15,g_adk.adkconf,g_adk.adkuser,
        g_adk.adkgrup,g_adk.adkmodu,g_adk.adkdate,g_adk.adkacti
    SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_adk.adk13
    IF SQLCA.sqlcode THEN LET l_gen02 = ' ' END IF
    SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01 = g_adk.adk14
    IF SQLCA.sqlcode THEN LET l_gem02 = ' ' END IF
    DISPLAY l_gen02 TO FORMONLY.gen02
    DISPLAY l_gem02 TO FORMONLY.gem02
    CALL i122_b_fill(g_wc2)                #單身
    CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
END FUNCTION

FUNCTION i122_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT#No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用       #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否       #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態         #No.FUN-680108 VARCHAR(1)
    l_buf           LIKE type_file.chr1000,                   #No.FUN-680108 VARCHAR(40)
    l_cmd           LIKE type_file.chr1000,                   #No.FUN-680108 VARCHAR(200)
    l_uflag,l_chr   LIKE type_file.chr1,                      #No.FUN-680108 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否         #No.FUN-680108 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否         #No.FUN-680108 SMALLINT

    LET g_action_choice = ""

    IF s_shut(0) THEN RETURN END IF

    IF cl_null(g_adk.adk01) THEN
        RETURN
    END IF
    IF g_adk.adkacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'mfg1000',0)
        RETURN
    END IF
    IF g_adk.adkconf ='Y' THEN    #檢查資料是否為無效
        CALL cl_err(g_adk.adk01,'9023',0)
        RETURN
    END IF
    LET l_uflag ='N'
    CALL cl_opmsg('b')

    LET g_forupd_sql = "SELECT adm02,adm03,'',adm04,adm05,adm06,'',adm08,adm07",
                       "  FROM adm_file WHERE adm01=? AND adm02 =? FOR UPDATE NOWAIT "

    DECLARE i122_b_curl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0

    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")

    INPUT ARRAY g_adm WITHOUT DEFAULTS FROM s_adm.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)

    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
          IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF

    BEFORE ROW
        DISPLAY "BEFORE ROW"
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT

            IF g_rec_b >=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_adm_t.* = g_adm[l_ac].*  #BACKUP
               LET g_adm_o.* = g_adm[l_ac].*
               OPEN i122_b_curl USING g_adk.adk01,g_adm_t.adm02     #表示更改狀A
               IF STATUS THEN
                  CALL cl_err("OPEN i122_b_curl:", STATUS, 1)
                  CLOSE i122_b_curl
                  ROLLBACK WORK
                  RETURN
               END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adm_t.adm02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH i122_b_curl INTO g_adm[l_ac].*
               IF l_ac <= l_n THEN                   #DISPLAY NEWEST
                  CALL i122_adm03()
                  CALL i122_adm06('d')
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_adm[l_ac].* TO NULL      #900423
            LET g_adm_t.* = g_adm[l_ac].*         #新輸入資料
            LET g_adm_o.* = g_adm[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adm02

    AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             INSERT INTO adm_file(adm01,adm02,adm03,adm04,adm05,adm06,adm07,adm08) #No.MOD-4700041
                          VALUES(g_adk.adk01,
                                 g_adm[l_ac].adm02,g_adm[l_ac].adm03,
                                 g_adm[l_ac].adm04,g_adm[l_ac].adm05,
                                 g_adm[l_ac].adm06,g_adm[l_ac].adm07,
                                 g_adm[l_ac].adm08)
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_adm[l_ac].adm02,SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF

        BEFORE FIELD adm02                        # dgeeault 序號
            IF g_adm[l_ac].adm02 IS NULL or g_adm[l_ac].adm02 = 0 THEN
                SELECT max(adm02)+1 INTO g_adm[l_ac].adm02 FROM adm_file
                    WHERE adm01 = g_adk.adk01
                IF g_adm[l_ac].adm02 IS NULL THEN
                    LET g_adm[l_ac].adm02 = 1
                END IF
            END IF

        AFTER FIELD adm02
            IF NOT cl_null(g_adm[l_ac].adm02) THEN
               IF g_adm[l_ac].adm02 != g_adm_t.adm02 OR
                  g_adm_t.adm02 IS NULL THEN
                   SELECT COUNT(*) INTO l_n FROM adm_file
                    WHERE adm01 = g_adk.adk01 AND adm02 = g_adm[l_ac].adm02
                   IF l_n > 0 THEN
                      CALL cl_err('',-239,0)
                      LET g_adm[l_ac].adm02 = g_adm_t.adm02
                      NEXT FIELD adm02
                   END IF
               END IF
            END IF

        AFTER FIELD adm03
            IF g_adm[l_ac].adm03 MATCHES '[12]' THEN
               CALL i122_adm03()
            END IF

        AFTER FIELD adm04
            IF g_adm[l_ac].adm04 < 0 THEN
               NEXT FIELD adm04
            END IF

        AFTER FIELD adm06
            IF NOT cl_null(g_adm[l_ac].adm06) THEN
               CALL i122_adm06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_adm[l_ac].adm06 = g_adm_t.adm06
                  #------MOD-5A0095 START----------
                  DISPLAY BY NAME g_adm[l_ac].adm06
                  #------MOD-5A0095 END------------
                  NEXT FIELD adm06
               END IF
            END IF

        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_adm_t.adm02) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM adm_file
                    WHERE adm01 = g_adk.adk01 AND
                          adm02 = g_adm_t.adm02
                IF SQLCA.sqlcode THEN
                    LET l_buf = g_adm_t.adm02 clipped
                    CALL cl_err(l_buf,SQLCA.sqlcode,0)
                    LET l_ac_t = l_ac
                    ROLLBACK WORK
                    EXIT INPUT
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_adm[l_ac].* = g_adm_t.*
               CLOSE i122_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_adm[l_ac].adm02,-263,1)
               LET g_adm[l_ac].* = g_adm_t.*
            ELSE
  UPDATE adm_file
     SET adm02=g_adm[l_ac].adm02,adm03=g_adm[l_ac].adm03,
         adm04=g_adm[l_ac].adm04,adm05=g_adm[l_ac].adm05,
         adm06=g_adm[l_ac].adm06,adm07=g_adm[l_ac].adm07,
         adm08=g_adm[l_ac].adm08
   WHERE adm01=g_adk.adk01
     AND adm02=g_adm_t.adm02
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_adm[l_ac].adm02,SQLCA.sqlcode,0)
                  LET g_adm[l_ac].* = g_adm_t.*
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
                  LET g_adm[l_ac].* = g_adm_t.*
               END IF
               CLOSE i122_b_curl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i122_b_curl
            COMMIT WORK

        ON ACTION CONTROLN
            CALL i122_b_askkey()
            EXIT INPUT

        ON ACTION CONTROLO
           IF INFIELD(adm02) AND l_ac > 1 THEN
               LET g_adm[l_ac].* = g_adm[l_ac-1].*
               NEXT FIELD adm02
           END IF

        ON ACTION controls                                   #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")                 #No.FUN-6A0092

        ON ACTION CONTROLP
           CASE WHEN INFIELD(adm06)
#                   CALL q_gen(0,0,g_adm[l_ac].adm06)
#                        RETURNING g_adm[l_ac].adm06
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gen"
                    LET g_qryparam.default1 = g_adm[l_ac].adm06
                    CALL cl_create_qry() RETURNING g_adm[l_ac].adm06
#                    CALL FGL_DIALOG_SETBUFFER( g_adm[l_ac].adm06 )
                    NEXT FIELD adm06
                OTHERWISE EXIT CASE
            END CASE

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

    CLOSE i122_b_curl
    COMMIT WORK
END FUNCTION

FUNCTION i122_adm06(p_cmd)    #人員
 DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
        l_gen02a    LIKE gen_file.gen02,
        l_genacti   LIKE gen_file.genacti

  LET g_errno = ' '
  SELECT gen02,genacti INTO g_adm[l_ac].gen02a,l_genacti FROM gen_file
                          WHERE gen01 = g_adm[l_ac].adm06

  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
  END IF
  #------MOD-5A0095 START----------
  DISPLAY BY NAME g_adm[l_ac].gen02a
  #------MOD-5A0095 END------------
END FUNCTION

FUNCTION i122_adm03()
    CALL cl_getmsg('axd-007',g_lang) RETURNING g_msg
    IF g_adm[l_ac].adm03 = '1' THEN LET g_adm[l_ac].desc = g_msg[1,4] END IF
    IF g_adm[l_ac].adm03 = '2' THEN LET g_adm[l_ac].desc = g_msg[5,8] END IF
    #------MOD-5A0095 START----------
    DISPLAY BY NAME g_adm[l_ac].adm03
    #------MOD-5A0095 END------------
END FUNCTION

FUNCTION i122_z() #取消確認
    IF g_adk.adk01 IS NULL THEN RETURN END IF
    SELECT * INTO g_adk.* FROM adk_file WHERE adk01=g_adk.adk01
    IF g_adk.adkconf='N' THEN RETURN END IF
    IF NOT cl_confirm('axm-109') THEN RETURN END IF

    LET g_success='Y'
    BEGIN WORK
        UPDATE adk_file SET adkconf='N'
            WHERE adk01 = g_adk.adk01
        IF STATUS THEN
            CALL cl_err('upd cofconf',STATUS,0)
            LET g_success='N'
        END IF
        IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_cmmsg(1)
        ELSE
            ROLLBACK WORK
            CALL cl_rbmsg(1)
        END IF
        SELECT adkconf INTO g_adk.adkconf FROM adk_file
            WHERE adk01 = g_adk.adk01
        DISPLAY BY NAME g_adk.adkconf
END FUNCTION

FUNCTION i122_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(200)

    CONSTRUCT l_wc2 ON adm02,adm03,adm04,adm05,adm06,adm08,adm07
         FROM s_adm[1].adm02,s_adm[1].adm03,s_adm[1].adm04,s_adm[1].adm05,
              s_adm[1].adm06,s_adm[1].adm08,s_adm[1].adm07

            #No:FUN-580031 --start--     HCN
            BEFORE CONSTRUCT
                CALL cl_qbe_init()
            #No:FUN-580031 --end--       HCN

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
    CALL i122_b_fill(l_wc2)
END FUNCTION

FUNCTION i122_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680108 VARCHAR(300)

    LET g_sql =
        "SELECT adm02,adm03,'',adm04,adm05,adm06,gen02,adm08,adm07",
        " FROM adm_file,OUTER gen_file",
        " WHERE adm06 = gen_file.gen01 ",
        "   AND adm01 ='",g_adk.adk01,"' AND ", #單頭
        p_wc2 CLIPPED                      #單身

    PREPARE i122_pb FROM g_sql
    DECLARE adm_curs                       #CURSOR
        CURSOR FOR i122_pb

    CALL g_adm.clear()             #單身 ARRAY 乾洗
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH adm_curs INTO g_adm[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL cl_getmsg('axd-007',g_lang) RETURNING g_msg
        IF g_adm[g_cnt].adm03 = '1' THEN
           LET g_adm[g_cnt].desc = g_msg[1,4]
        END IF
        IF g_adm[g_cnt].adm03 = '2' THEN
           LET g_adm[g_cnt].desc = g_msg[5,8]
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adm.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i122_bp(p_ud)
DEFINE
    p_ud            LIKE type_file.chr1          #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adm TO s_adm.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL i122_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION previous
         CALL i122_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION jump
         CALL i122_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION next
         CALL i122_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
      ON ACTION last
         CALL i122_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No:FUN-530067 HCN TEST
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
     ON ACTION controls                             #No.FUN-6A0092 
         CALL cl_set_head_visible("","AUTO")        #No.FUN-6A0092

#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
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


FUNCTION i122_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680108 SMALLINT
    sr              RECORD
          adk       RECORD LIKE adk_file.*,
          adm       RECORD LIKE adm_file.*,
          gen02     LIKE gen_file.gen02
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name   #No.FUN-680108 VARCHAR(20)
     l_za05         LIKE za_file.za05      #MOD-4B0067

    IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('axdi122') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT adk_file.*,adm_file.*,gen02",
              " FROM adk_file,OUTER (adm_file,OUTER gen_file)",  # 組合出 SQL 指令
              " WHERE adk01=adm_file.adm01 AND ",g_wc CLIPPED,
              "   AND adm_file.adm06 = gen_file.gen01 ",
              " ORDER BY adk01,adm02 "
    PREPARE i122_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i122_co                         # CURSOR
        CURSOR FOR i122_p1

    START REPORT i122_rep TO l_name

    FOREACH i122_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i122_rep(sr.*)
    END FOREACH

    FINISH REPORT i122_rep

    CLOSE i122_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i122_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1)
    sr              RECORD
          adk       RECORD LIKE adk_file.*,
          adm       RECORD LIKE adm_file.*,
          gen02     LIKE gen_file.gen02
                    END RECORD,
    l_desc          LIKE type_file.chr20   #No.FUN-680108 VARCHAR(20) 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.adk.adk01,sr.adm.adm02

    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash
            PRINT COLUMN  1,g_x[9] CLIPPED,sr.adk.adk01,
#No.FUN-550026 --start--
                  COLUMN 27,g_x[10] CLIPPED,sr.adk.adk02,
                  COLUMN 53,g_x[11] CLIPPED,sr.adk.adk15
            PRINT COLUMN  1,g_x[12] CLIPPED,sr.adk.adk08,
                  COLUMN 27,g_x[13] CLIPPED,sr.adk.adk04,' ',sr.adk.adk05 USING '##:##',   #TQC-6A0095
                  COLUMN 53,g_x[14] CLIPPED,sr.adk.adk06,' ',sr.adk.adk07 USING '##:##'   #TQC-6A0095
#No.FUN-550026 ---end--
            PRINT ''
            PRINT g_x[31],g_x[32],g_x[33],
                  g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
            PRINT g_dash1

            LET l_trailer_sw = 'y'

        BEFORE GROUP OF sr.adk.adk01  #倉庫別
        ON EVERY ROW
            CALL cl_getmsg('axd-007',g_lang) RETURNING g_msg
            LET l_desc = NULL
            IF sr.adm.adm03 = '1' THEN LET l_desc = g_msg[1,4] END IF
            IF sr.adm.adm03 = '2' THEN LET l_desc = g_msg[5,8] END IF
            PRINT COLUMN g_c[31],sr.adm.adm02 USING '###&', #FUN-590118
                  COLUMN g_c[32],sr.adm.adm03 USING '###&', #FUN-590118
                  COLUMN g_c[33],l_desc,
                  COLUMN g_c[34],sr.adm.adm04,
                  COLUMN g_c[35],sr.adm.adm06,
                  COLUMN g_c[36],sr.gen02,
                  COLUMN g_c[37],sr.adm.adm08,
                  COLUMN g_c[38],sr.adm.adm07

        AFTER GROUP OF sr.adk.adk01
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
#Patch....NO:MOD-5A0095 <001,002,003> #

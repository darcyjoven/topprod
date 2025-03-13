# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq555.4gl
# Descriptions...: aqcq555 FQC品質記錄彙總查詢(BY 產品)
# Date & Author..: 99/05/19 By Iceman
# Modify.........: No.TQC-5A0044 05/10/14 By Carrier 報表格式修改
# Modify.........: NO.FUN-670107 06/08/24 By flowld voucher型報表轉template1
# Modify.........:No.FUN-680104 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/13 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850050 08/05/09 By lala
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
        wc                      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
        bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
        edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE      #日期起
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE         #日期止
            qcm021              LIKE qcm_file.qcm021, #料件編號
            ima02               LIKE ima_file.ima02,  #料件名稱
            ima021              LIKE ima_file.ima021, #料件規格
            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)       #送驗批號
            qcm22               LIKE qcm_file.qcm22,       #No.FUN-680104 DECIMAL(10,3)       #送驗量
            stkqty              LIKE qcm_file.qcm091,      #No.FUN-680104 DECIMAL(12,3)      #入庫數量
           #qcm06               DECIMAL(10,3),        #檢驗量    #No.TQC-750064 mark
            crqty               LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)       #不良數
            crrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)     #不良率
            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)      #不合格批數
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)      #不合格批數
        END RECORD,
    g_state DYNAMIC ARRAY OF RECORD
            sta     LIKE type_file.chr2,       #No.FUN-680104 VARCHAR(2)
            code    LIKE type_file.chr4,       #No.FUN-680104 VARCHAR(4)
            desc    LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(30)
            lot     LIKE type_file.num10       #No.FUN-680104 INTEGER
        END RECORD,
    g_rec_b         LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    m_cnt           LIKE type_file.num5,         #No.FUN-680104 SMALLINT
     g_sql          string, #WHERE CONDITION  #No.FUN-580092 HCN
    g_dash_1        LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(132) # Dash line
    cr,ma,mi        LIKE qcn_file.qcn07       #No.FUN-680104 DEC(12,3)
 
DEFINE   g_i            LIKE type_file.num5         #No.FUN-680104 SMALLINT  #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE   g_str      STRING
DEFINE   l_table    STRING
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8               #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col          LIKE type_file.num5         #No.FUN-680104 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
#No.FUN-850050---start---
   LET g_sql="qcm021.qcm_file.qcm021,",
             "bdate.type_file.dat,",
             "edate.type_file.dat,",
             "ima02.ima_file.ima02,",
             "ima021.ima_file.ima021"
 
   LET l_table = cl_prt_temptable('aqcq555',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED, l_table CLIPPED,
             " VALUES(?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      EXIT PROGRAM
   END IF
#No.FUN-850050---end---
 
    LET p_row = 5 LET p_col = 3
    OPEN WINDOW q555_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq555"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
#       CALL q555_q()
#    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q555_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q555_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q555_cs()
   DEFINE   l_cnt       LIKE type_file.num5         #No.FUN-680104 SMALLINT
   CLEAR FORM #清除畫面
   CALL g_state.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                      # Default condition
   INITIALIZE g_qcm.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON qcm021
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
   IF INT_FLAG THEN RETURN END IF
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
   DISPLAY BY NAME tm.bdate,tm.edate
        INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
                AFTER FIELD bdate
                   IF cl_null(tm.bdate) THEN CALL cl_err('','aap-099',0)
                      NEXT FIELD bdate
                   END IF
                AFTER FIELD edate
                   IF cl_null(tm.edate) THEN CALL cl_err('','aap-099',0)
                      NEXT FIELD edate
                   END IF
                   IF tm.edate<tm.bdate THEN
                        NEXT FIELD edate
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
        IF INT_FLAG THEN RETURN END IF
#bugno:6062modify...........................
        LET g_qcm.bdate=tm.bdate
        LET g_qcm.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE qcm021,ima02,ima021 ",
             " FROM qcm_file,ima_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND ima01 = qcm021 AND qcm14='Y' AND qcm18='2' ",
             " AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcmuser', 'qcmgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY qcm021"
 
   PREPARE q555_prepare FROM g_sql
   DECLARE q555_cs SCROLL CURSOR FOR q555_prepare
   LET g_sql=" SELECT COUNT(UNIQUE qcm021) ",
             " FROM qcm_file,ima_file",
             " WHERE ",tm.wc CLIPPED,
             " AND ima01 = qcm021 AND qcm14='Y' AND qcm18='2' ",
             " AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcmuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcmgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcmgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q555_prepare1 FROM g_sql
   DECLARE q555_count SCROLL CURSOR FOR q555_prepare1
END FUNCTION
 
 
#中文的MENU
FUNCTION q555_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q555_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL q555_fetch('N')
        ON ACTION previous
            CALL q555_fetch('P')
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                CALL q555_out()
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL q555_fetch('/')
        ON ACTION first
            CALL q555_fetch('F')
        ON ACTION last
            CALL q555_fetch('L')

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
 
    END MENU
END FUNCTION
 
 
FUNCTION q555_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q555_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q555_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q555_count
       FETCH q555_count INTO g_row_count
       DISPLAY  g_row_count TO FORMONLY.cnt
       CALL q555_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q555_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)            #處理方式
    l_abso          LIKE type_file.num10         #No.FUN-680104 INTEGER            #絕對的筆數
    CASE p_flag
        WHEN 'N' FETCH NEXT     q555_cs INTO g_qcm.qcm021,g_qcm.ima02
        WHEN 'P' FETCH PREVIOUS q555_cs INTO g_qcm.qcm021,g_qcm.ima02
        WHEN 'F' FETCH FIRST    q555_cs INTO g_qcm.qcm021,g_qcm.ima02
        WHEN 'L' FETCH LAST     q555_cs INTO g_qcm.qcm021,g_qcm.ima02
        WHEN '/'
          IF (NOT mi_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
#                    CONTINUE PROMPT
 
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
          FETCH ABSOLUTE g_jump q555_cs INTO g_qcm.qcm021,g_qcm.ima02
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.SQLCODE THEN
       INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
       CALL cl_err('',SQLCA.SQLCODE,0) RETURN
    ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
    CALL q555_show()
END FUNCTION
 
FUNCTION q555_show()
   SELECT ima021 INTO g_qcm.ima021 FROM ima_file
    WHERE ima01 = g_qcm.qcm021
   DISPLAY BY NAME g_qcm.*
   CALL q555_calc()
# 顯示資料
   DISPLAY g_qcm.lot TO FORMONLY.lot
   DISPLAY g_qcm.qcm22 TO FORMONLY.qcm22
   DISPLAY g_qcm.stkqty TO FORMONLY.stkqty
  #DISPLAY g_qcm.qcm06 TO FORMONLY.qcm06     #No.TQC-750064 mark
   DISPLAY g_qcm.crqty TO FORMONLY.crqty
   DISPLAY g_qcm.rejqty TO FORMONLY.rejqty
   DISPLAY g_qcm.crrate TO FORMONLY.crrate
   DISPLAY g_qcm.rejrate TO FORMONLY.rejrate
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q555_calc()
#
# 計算送驗批數
   SELECT COUNT(*) INTO g_qcm.lot FROM qcm_file, ima_file
        WHERE qcm021 = g_qcm.qcm021 AND ima01 = g_qcm.qcm021
           AND qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate AND qcm14='Y' AND qcm18='2'
   IF STATUS=100 THEN LET g_qcm.lot=0 END IF
# 計算送驗量
   SELECT SUM(qcm22) INTO g_qcm.qcm22 FROM qcm_file
       WHERE qcm021 = g_qcm.qcm021
          AND qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate AND qcm14='Y' AND qcm18='2'
   IF STATUS=100 THEN LET g_qcm.qcm22=0 END IF
# 計算入庫數量
   SELECT SUM(qcm091) INTO g_qcm.stkqty FROM qcm_file
       WHERE qcm021 = g_qcm.qcm021
	AND qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate AND qcm14='Y' AND qcm18='2'
   IF STATUS=100 THEN LET g_qcm.stkqty=0 END IF
# 計算檢驗數
  #-------------No.TQC-750064 mark
  #SELECT SUM(qcm06) INTO g_qcm.qcm06 FROM qcm_file
  #    WHERE qcm021 = g_qcm.qcm021
  #     AND qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate AND qcm14='Y' AND qcm18='2'
  #IF STATUS=100 THEN LET g_qcm.qcm06=0 END IF
  #-------------No.TQC-750064 end
# 計算不良數
        #------- CR
        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
           WHERE qcm021 = g_qcm.qcm021 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
           WHERE qcm021 = g_qcm.qcm021 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
           WHERE qcm021 = g_qcm.qcm021 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
        #-------- 不良數總計
       #------------No.TQC-750064 modify
       #LET g_qcm.crqty=(cr*g_qcz.qcz02/g_qcz.qcz021)+
       #                (ma*g_qcz.qcz03/g_qcz.qcz031)+
       #                (mi*g_qcz.qcz04/g_qcz.qcz041)
        LET g_qcm.crqty=g_qcm.qcm22 - g_qcm.stkqty
       #------------No.TQC-750064 end
# 計算不合格批數
   SELECT count(*) INTO g_qcm.rejqty FROM qcm_file,sfb_file
       WHERE qcm021 = g_qcm.qcm021 AND qcm02 = sfb01
	AND qcm04 BETWEEN g_qcm.bdate AND g_qcm.edate
          AND qcm09 != '1' AND qcm14='Y' AND qcm18='2'
   IF STATUS=100 THEN LET g_qcm.rejqty=0 END IF
# 計算不良率
  #-----------No.TQC-750064 modify
  #IF g_qcm.qcm06 = 0 THEN       # 理論上, 不可能發生才對
   IF g_qcm.qcm22 = 0 THEN       # 理論上, 不可能發生才對
  #-----------No.TQC-750064 end
      LET g_qcm.crrate = 0
   ELSE
     #------------No.TQC-750064 modify
     #LET g_qcm.crrate = g_qcm.crqty / g_qcm.qcm06 * 100
      LET g_qcm.crrate = g_qcm.crqty / g_qcm.qcm22 * 100
     #------------No.TQC-750064 end
   END IF
   IF g_qcm.lot = 0 THEN
      LET g_qcm.rejrate = 0
   ELSE
      # 計算不合格批率
      LET g_qcm.rejrate = g_qcm.rejqty / g_qcm.lot * 100
   END IF
END FUNCTION
#No.FUN-850050---start---
FUNCTION q555_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,        #No.FUN-680104 VARCHAR(20)      #External(Disk) file name
    l_za05          LIKE cob_file.cob01,         #No.FUN-680104 VARCHAR(40)
    sr     RECORD
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE     #日期起
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE         #日期止
            qcm021              LIKE qcm_file.qcm021, #料件編號
            ima02               LIKE ima_file.ima02,  #料件名稱
            ima021              LIKE ima_file.ima021, #料件規格
            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)        #送驗批號
            qcm22               LIKE qcm_file.qcm22,       #No.FUN-680104 DECIMAL(10,3)     #送驗量
            stkqty              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)      #入庫數量
           #qcm06               DECIMAL(10,3),        #檢驗量    #No.TQC-750064 mark
            crqty               LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)       #不良數
            crrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)      #不良率
            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)    #不合格批數
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)        #不合格批數
        END RECORD
    CALL cl_wait()
#    CALL cl_outnam('aqcq555') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
# NO.FUN-670107 --start-- 
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcq555'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 100 END IF  #No.TQC-5A0044
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#    FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
# NO.FUN-670107 ---end---
#    START REPORT q555_rep TO l_name
    FOREACH q555_cs INTO sr.qcm021,sr.ima02
        IF SQLCA.SQLCODE THEN
                CALL cl_err('Foreach:',SQLCA.SQLCODE,1)
                EXIT FOREACH
        END IF
        CALL q555_calc()
#        OUTPUT TO REPORT q555_rep(g_qcm.*)
 
    EXECUTE insert_prep USING
        sr.qcm021,tm.bdate,tm.edate,sr.ima02,sr.ima021
     END FOREACH
     LET g_sql="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_wcchp(tm.wc,'qcm021')
             RETURNING tm.wc
     LET g_str=tm.wc,";",g_qcm.lot,";",g_qcm.qcm22,";",g_qcm.stkqty,";",g_qcm.rejqty,";",
     g_qcm.crqty,";",g_qcm.crrate,";",g_qcm.rejrate,";",tm.bdate,";",tm.edate
     CALL cl_prt_cs3('aqcq555','aqcq555',g_sql,g_str)
 
#    FINISH REPORT q555_rep
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
    OPEN q555_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q555_count
       FETCH q555_count INTO m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
       CALL q555_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#REPORT q555_rep(sr)
#DEFINE
#        l_trailer_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#        sr     RECORD
#            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE     #日期起
#            edate               LIKE type_file.dat,          #No.FUN-680104 DATE         #日期止
#            qcm021              LIKE qcm_file.qcm021, #料件編號
#            ima02               LIKE ima_file.ima02,  #料件名稱
#            ima021              LIKE ima_file.ima021, #料件規格
#            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)        #送驗批號
#            qcm22               LIKE qcm_file.qcm22,       #No.FUN-680104 DECIMAL(10,3)     #送驗量
#            stkqty              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)      #入庫數量
           #qcm06               DECIMAL(10,3),        #檢驗量    #No.TQC-750064 mark
#            crqty               LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)       #不良數
#            crrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)      #不良率
#            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)    #不合格批數
#            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)        #不合格批數
#        END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#    ORDER BY sr.qcm021
#    FORMAT
#    PAGE HEADER
# NO.FUN-670107 --start-- 
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#            PRINT ' '
#            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#            PRINT g_dash[1,g_len]
#            PRINT COLUMN (g_len-FGL_WIDTH(g_company CLIPPED))/2+1,g_company CLIPPED
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN (g_len-FGL_WIDTH(g_x[1]))/2+1,g_x[1]
#            PRINT ' '
#            PRINT g_dash
# NO.FUN-670107 ---end---
#            LET l_trailer_sw = 'n'
# NO.FUN-670107 --start--
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#            PRINTX name=H2 g_x[37],g_x[38],g_x[39],g_x[40],g_x[41],g_x[42]
#           PRINTX name=H3 g_x[43]
#            PRINT g_dash1
# NO.FUN-670107 ---end---     
#    BEFORE GROUP OF sr.qcm021
#           SKIP TO TOP OF PAGE
# NO.FUN-670107 --start-- 
#   ON EVERY ROW
#            #No.TQC-5A0044  --begin
#            PRINT COLUMN  4,g_x[24] CLIPPED,sr.qcm021,
#                  COLUMN 68,g_x[17] CLIPPED,tm.bdate,'-',tm.edate
#	    PRINT COLUMN 15,sr.ima02
#	    PRINT COLUMN 15,sr.ima021
#            PRINT ''
#            PRINT COLUMN  4,g_x[11] CLIPPED,sr.lot    USING '###############&',
#                  COLUMN 36,g_x[12] CLIPPED,sr.qcm22  USING '###########&.&&&',
#                  COLUMN 68,g_x[13] CLIPPED,sr.stkqty USING '###########&.&&&'
#            PRINT ""
#            PRINT COLUMN  4,g_x[14] CLIPPED,sr.qcm06  USING '###########&.&&&',
#                  COLUMN 36,g_x[15] CLIPPED,sr.crqty  USING '###########&.&&&',
#                  COLUMN 68,g_x[16] CLIPPED,sr.crrate USING '###########&.&&&'
#            PRINT g_dash_1[1,g_len]
#            PRINT COLUMN  4,g_x[18] CLIPPED,sr.rejqty  USING '###############&',
#                  COLUMN 36,g_x[19] CLIPPED,sr.rejrate USING '###########&.&&&','%'
#            PRINT ''
#            #No.TQC-5A0044  --end
#            PRINTX name=D1 COLUMN g_c[31],sr.qcm021,
#                           COLUMN g_c[32],tm.bdate,'-',tm.edate,
#                           COLUMN g_c[33],sr.lot USING '###############&',
#                           COLUMN g_c[34],sr.qcm22 USING '###########&.&&&',
#                           COLUMN g_c[35],sr.stkqty USING '###########&.&&&',
#                           COLUMN g_c[36],sr.rejqty  USING '###############&'
#            PRINTX name=D2 COLUMN g_c[37],sr.ima02,
                          #COLUMN g_c[39],sr.qcm06  USING '###########&.&&&',   #No.TQC-750064 mark
#                           COLUMN g_c[40],sr.crqty  USING '###########&.&&&',
#                           COLUMN g_c[41],sr.crrate USING '###########&.&&&',
#                           COLUMN g_c[42],sr.rejrate USING '##########&.&&&','%'    
#            PRINTX name=D3 COLUMN  g_c[43],sr.ima021
# NO.FUN-670107 ---end---
#    ON LAST ROW
#            PRINT g_dash
#            LET l_trailer_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#    PAGE TRAILER
#            IF l_trailer_sw = 'n' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#Patch....NO.TQC-610036 <001,002,003> #
#No.FUN-850050---end---

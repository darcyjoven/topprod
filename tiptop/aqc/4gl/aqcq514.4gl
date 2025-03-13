# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq514.4gl
# Descriptions...: PQC品質記錄彙總查詢(BY 工單)
# Date & Author..: 99/05/21 By Iceman
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: No.MOD-550092 05/05/12 By Mandy 一進入程式就會出現"lib-219"的錯誤訊息
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 報表對齊調整
# Modify.........: No.FUN-670106 06/08/24 By douzh voucher型報表轉template1  
# Modify.........: No.FUN-680104 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/13 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-7B0133 07/12/04 By cliare 不依工單跳頁
# Modify.........: No.FUN-850073 08/05/14 By dxfwo  CR報表
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE
     g_argv1                     LIKE sfb_file.sfb01,
    tm  RECORD
        wc                      LIKE type_file.chr1000,    #No.FUN-680104 VARCHAR(600)
        bdate                   LIKE type_file.dat,        #No.FUN-680104 DATE
        edate                   LIKE type_file.dat         #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            qcm02               LIKE qcm_file.qcm02,       #工單編號
            bdate               LIKE type_file.dat,        #No.FUN-680104 DATE      #檢驗日期起
            edate               LIKE type_file.dat,        #No.FUN-680104 DATE       #檢驗日期
            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)     #送貨批號
            qcm22               LIKE qcm_file.qcm22,       #送貨量
            stkqty              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)       #入庫日期
           #qcm06               DECIMAL(10,3),        #檢驗量    #No.TQC-750064 mark
            crqty               LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)      #不良數 #TQC-5B0034(9,3)->(12,3)
            crrate              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)   #不量率 #TQC-5B0034(9,3)->(12,3)
            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)     #不合格批數
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)   #不合格批率
        END RECORD,
    g_state DYNAMIC ARRAY OF RECORD
            sta     LIKE type_file.chr2,       #No.FUN-680104 VARCHAR(2)
            code    LIKE type_file.chr4,       #No.FUN-680104 VARCHAR(4)
            desc    LIKE cob_file.cob08,       #No.FUN-680104 VARCHAR(30)
            lot     LIKE type_file.num10       #No.FUN-680104 INTEGER
        END RECORD,
    g_rec_b          LIKE type_file.num5,      #No.FUN-680104 SMALLINT
    m_cnt            LIKE type_file.num5,      #No.FUN-680104 SMALLINT
    l_qcm02          LIKE qcm_file.qcm02,
     g_sql           string,                   #WHERE CONDITION  #No.FUN-580092 HCN
    g_dash_1         LIKE type_file.chr1000,   #No.FUN-680104 VARCHAR(132)
    cr,ma,mi         LIKE qcn_file.qcn07       #No.FUN-680104 DEC(12,3)
 
DEFINE   g_i            LIKE type_file.num5         #No.FUN-680104 SMALLINT #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE   l_table        STRING                      #No.FUN-850073                                                             
DEFINE   l_sql          STRING                      #No.FUN-850073                                                            
DEFINE   g_str          STRING                      #No.FUN-850073
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col          LIKE type_file.num5         #No.FUN-680104 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-850073---Begin 
   LET g_sql = " qcm02.qcm_file.qcm02,",
               " lot.tod_file.tod08,",
               " qcm22.qcm_file.qcm22,",
               " stkqty.qcm_file.qcm06,",
               " rejqty.tod_file.tod08,",
               " crqty.qcm_file.qcm06,",
               " crrate.qcm_file.qcm06,",
               " rejrate.ima_file.ima18"
   LET l_table = cl_prt_temptable('aqcq514',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?,?,?,?,?,  ?,?,? )"  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF
            
#No.FUN-850073---End
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AQC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
      LET p_row = 4 LET p_col = 20
    OPEN WINDOW q514_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq514"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
     LET g_action_choice = "query" #MOD-550092
    LET g_argv1= ARG_VAL(1)
    IF cl_chk_act_auth() OR NOT cl_null(g_argv1)  THEN
       CALL q514_q()
    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q514_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q514_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q514_cs()
   DEFINE   l_cnt    LIKE type_file.num5,         #No.FUN-680104 SMALLINT
            l_n      LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_state.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                      # Default condition
   IF NOT cl_null(g_argv1)  THEN
      LET tm.wc = "qcm02 = '",g_argv1 CLIPPED,"' "
      DISPLAY g_argv1 TO FORMONLY.qcm02
   ELSE
   INITIALIZE g_qcm.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON qcm02
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
   END IF
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
              IF tm.edate<tm.bdate THEN NEXT FIELD edate END IF
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
 
   LET g_sql=" SELECT UNIQUE qcm02 FROM qcm_file ",
             " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             "   AND qcm14='Y' AND (qcm02 IS NOT NULL AND qcm02!=' ') ",
             "   AND qcm18='1' AND ",tm.wc CLIPPED
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
 
   LET g_sql = g_sql clipped," ORDER BY qcm02"
 
   PREPARE q514_prepare FROM g_sql
   DECLARE q514_cs SCROLL CURSOR WITH HOLD FOR q514_prepare
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT COUNT(UNIQUE qcm02) FROM qcm_file ",
             " WHERE qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             "   AND qcm14='Y' AND (qcm02 IS NOT NULL AND qcm02!=' ') ",
             "   AND qcm18='1' AND ",tm.wc CLIPPED
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
 
   PREPARE q514_prepare1 FROM g_sql
   DECLARE q514_count CURSOR FOR q514_prepare1
END FUNCTION
 
 
#中文的MENU
FUNCTION q514_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q514_q()
            END IF
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                CALL q514_out()
            END IF
        ON ACTION next
            CALL q514_fetch('N')
        ON ACTION previous
            CALL q514_fetch('P')
#FUN-670106--begin
        ON ACTION jump 
            CALL q514_fetch('/')
        ON ACTION first
            CALL q514_fetch('F')
        ON ACTION last
            CALL q514_fetch('L')  
#FUN-670106--end
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          #EXIT MENU
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q514_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q514_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN q514_cs
#   FETCH q514_cs INTO g_qcm.qcm02         #FUN-670106
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
#       CALL q514_fetch('F')               #FUN-670106      
        OPEN q514_count
        FETCH q514_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q514_fetch('F')               #FUN-670106
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q514_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)           #處理方式
    l_abso          LIKE type_file.num10         #No.FUN-680104 INTEGER          #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q514_cs INTO g_qcm.qcm02
        WHEN 'P' FETCH PREVIOUS q514_cs INTO g_qcm.qcm02
        WHEN 'F' FETCH FIRST    q514_cs INTO g_qcm.qcm02
        WHEN 'L' FETCH LAST     q514_cs INTO g_qcm.qcm02
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
          FETCH ABSOLUTE  g_jump q514_cs INTO g_qcm.qcm02
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
       CALL cl_err(' ',SQLCA.sqlcode,0) RETURN
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
   #---------------No.TQC-750064 modify
   #SELECT count(*), sum(qcm06), sum(qcm22), sum(qcm091)
   #         INTO g_qcm.lot, g_qcm.qcm06, g_qcm.qcm22, g_qcm.stkqty
    SELECT count(*), sum(qcm22), sum(qcm091)
             INTO g_qcm.lot, g_qcm.qcm22, g_qcm.stkqty
   #---------------No.TQC-750064 end
             FROM qcm_file
             WHERE qcm04 BETWEEN tm.bdate AND tm.edate
               AND qcm02 = g_qcm.qcm02 AND qcm14='Y' AND qcm18='1'
#FUN-670106--begin
#          LET m_cnt=0
#          FOREACH q514_count INTO l_qcm02
#              IF SQLCA.sqlcode THEN EXIT FOREACH END IF
#             LET m_cnt=m_cnt+1
#           END FOREACH
#          DISPLAY m_cnt TO FORMONLY.cnt
#FUN-670106--end
        #------- CR
        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
           WHERE qcm02=g_qcm.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
           WHERE qcm02=g_qcm.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
           WHERE qcm02=g_qcm.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
        #-------- 不良數總計
       #---------------No.TQC-750064 modify
       #LET g_qcm.crqty=(cr*g_qcz.qcz02/g_qcz.qcz021)+
       #                (ma*g_qcz.qcz03/g_qcz.qcz031)+
       #                (mi*g_qcz.qcz04/g_qcz.qcz041)
        LET g_qcm.crqty=g_qcm.qcm22 - g_qcm.stkqty
       #---------------No.TQC-750064 end
 
        SELECT count(*) INTO g_qcm.rejqty FROM qcm_file
         WHERE qcm09 != '1' AND qcm04 BETWEEN tm.bdate AND tm.edate
           AND qcm02 = g_qcm.qcm02 AND qcm14='Y' AND qcm18='1'
 
       #--------------No.TQC-750064 modify
       #IF g_qcm.qcm06 = 0 THEN      # 分母為零, 另作處理
        IF g_qcm.qcm22 = 0 THEN      # 分母為零, 另作處理
       #--------------No.TQC-750064 end
           LET g_qcm.crrate = 0
        ELSE
          #-----------------No.TQC-750064 modify
          #LET g_qcm.crrate = (g_qcm.crqty/g_qcm.qcm06)*100
           LET g_qcm.crrate = (g_qcm.crqty/g_qcm.qcm22)*100
          #-----------------No.TQC-750064 end
        END IF
        IF g_qcm.lot = 0 THEN       # 分母為零, 另作處理
           LET g_qcm.rejrate = 0
        ELSE
           LET g_qcm.rejrate = g_qcm.rejqty/g_qcm.lot * 100
        END IF
 
    CALL q514_show()
END FUNCTION
 
FUNCTION q514_show()
   DISPLAY BY NAME g_qcm.*
   DISPLAY g_qcm.lot TO FORMONLY.lot
   DISPLAY g_qcm.qcm22 TO FORMONLY.qcm22
   DISPLAY g_qcm.stkqty TO FORMONLY.stkqty
  #DISPLAY g_qcm.qcm06 TO FORMONLY.qcm06     #No.TQC-750064 mark
   DISPLAY g_qcm.crqty TO FORMONLY.crqty
   DISPLAY g_qcm.crrate TO FORMONLY.crrate
   DISPLAY g_qcm.rejqty TO FORMONLY.rejqty
   DISPLAY g_qcm.rejrate TO FORMONLY.rejrate
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
 
FUNCTION q514_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,        #No.FUN-680104 VARCHAR(20)     #External(Disk) file name
    l_za05          LIKE cob_file.cob01,         #No.FUN-680104 VARCHAR(40)
      sr    RECORD
            qcm02               LIKE qcm_file.qcm02,       #工單編號
            bdate               LIKE type_file.dat,        #No.FUN-680104 DATE       #檢驗日期起
            edate               LIKE type_file.dat,        #No.FUN-680104 DATE          #檢驗日期
            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)      #送貨批號
            qcm22               LIKE qcm_file.qcm22,       #送貨量
            stkqty              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)      #入庫日期
           #qcm06               DECIMAL(10,3),        #檢驗量    #No.TQC-750064 mark
            crqty               LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)      #不良數#TQC-5B0034(9,3)->(12,3)
            crrate              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)        #不量率 #TQC-5B0034(9,3)->(12,3)
            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)     #不合格批數
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)        #不合格批率
            END RECORD
    CALL cl_wait()
#   CALL cl_outnam('aqcq514') RETURNING l_name             #No.FUN-850073
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#FUN-670106--begin
#   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcq514'
#   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#   FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#   FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
#FUN-670106--end
#   START REPORT q514_rep TO l_name               #No.FUN-850073  
    CALL cl_del_data(l_table)                     #No.FUN-850073  
    FOREACH q514_cs INTO sr.qcm02
        IF SQLCA.sqlcode THEN
           CALL cl_err('rep foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
#No.FUN-850073---Begin
        SELECT count(*), sum(qcm22),sum(qcm091)
          INTO sr.lot, sr.qcm22, sr.stkqty FROM qcm_file
 
         WHERE qcm04 BETWEEN tm.bdate AND tm.edate
           AND qcm02 = sr.qcm02 AND qcm14='Y' AND qcm18='1'
 
        SELECT count(*) INTO sr.rejqty FROM qcm_file
         WHERE qcm09 != '1' AND qcm04 BETWEEN tm.bdate AND tm.edate
           AND qcm02 = sr.qcm02 AND qcm14='Y'  AND qcm18='1'
 
        #------- CR
        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
           WHERE qcm02=sr.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
           WHERE qcm02=sr.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
           WHERE qcm02=sr.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
 
        LET sr.crqty=sr.qcm22 - sr.stkqty
 
        IF sr.qcm22 = 0 THEN      # 分母為零, 另作處理
           LET sr.crrate = 0
        ELSE
 
           LET sr.crrate = (sr.crqty/sr.qcm22)*100
        END IF
        IF sr.lot = 0 THEN       # 分母為零, 另作處理
           LET sr.rejrate = 0
        ELSE
           LET sr.rejrate = sr.rejqty/sr.lot * 100
        END IF    
#   OUTPUT TO REPORT q514_rep(sr.*)
    EXECUTE insert_prep USING sr.qcm02,  sr.lot, sr.qcm22, sr.stkqty, sr.rejqty, sr.crqty, 
                              sr.crrate, sr.rejrate    
    END FOREACH
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'qcm02')         
            RETURNING tm.wc                                                                                                           
    END IF                                                                                                                          
     LET g_str = tm.wc,";",tm.bdate,";",tm.edate                                                          
     LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED                                              
     CALL cl_prt_cs3('aqcq514','aqcq514',l_sql,g_str)      
#   FINISH REPORT q514_rep
#   ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-850073---End
END FUNCTION
 
#REPORT q514_rep(sr)
#DEFINE 
#      l_trailer_sw              LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(1)
#      sr    RECORD 
#            qcm02               LIKE qcm_file.qcm02,       #工單編號
#            bdate               LIKE type_file.dat,        #No.FUN-680104 DATE       #檢驗日期起
#            edate               LIKE type_file.dat,        #No.FUN-680104 DATE        #檢驗日期
#            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)     #送貨批號
#            qcm22               LIKE qcm_file.qcm22,       #送貨量
#            stkqty              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)     #入庫日期
#           #qcm06               DECIMAL(10,3),        #檢驗量    #No.TQC-750064 mark
#            crqty               LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)      #不良數#TQC-5B0034(9,3)->(12,3)
#            crrate              LIKE qcm_file.qcm06,       #No.FUN-680104 DECIMAL(12,3)       #不量率 #TQC-5B0034(9,3)->(12,3)
#            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)       #不合格批數
#            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)        #不合格批率
#            END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#   ORDER BY sr.qcm02
#   FORMAT
#   PAGE HEADER
##FUN-670106--begin
##           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
##           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
##           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
##           PRINT ' '
##           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
##               COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#            LET g_pageno = g_pageno + 1 
#            LET pageno_total = PAGENO USING '<<<',"/pageno" 
#            PRINT g_head CLIPPED,pageno_total 
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1]
##FUN-670106--end
#            PRINT g_dash[1,g_len]
#    #BEFORE GROUP OF sr.qcm02      #FUN-7B0133 mark
##        LET g_pageno = 0
#    #    SKIP TO TOP OF PAGE       #FUN-7B0133 mark
##FUN-670106-begin
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],
#                           g_x[34],g_x[35],g_x[36]
#            PRINTX name=H2 g_x[37],g_x[38],g_x[39],
#                           g_x[40],g_x[41],g_x[42]
#            PRINT g_dash1  
##FUN-670106-end
#    ON EVERY ROW
#       #-----------------No.TQC-750064 modify
#       #SELECT count(*), sum(qcm06), sum(qcm22),sum(qcm091)
#       #  INTO sr.lot, sr.qcm06, sr.qcm22, sr.stkqty FROM qcm_file
#        SELECT count(*), sum(qcm22),sum(qcm091)
#          INTO sr.lot, sr.qcm22, sr.stkqty FROM qcm_file
#       #-----------------No.TQC-750064 end
#         WHERE qcm04 BETWEEN tm.bdate AND tm.edate
#           AND qcm02 = sr.qcm02 AND qcm14='Y' AND qcm18='1'
#
#        SELECT count(*) INTO sr.rejqty FROM qcm_file
#         WHERE qcm09 != '1' AND qcm04 BETWEEN tm.bdate AND tm.edate
#           AND qcm02 = sr.qcm02 AND qcm14='Y'  AND qcm18='1'
#
#        #------- CR
#        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
#           WHERE qcm02=sr.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
#             AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
#        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
#        #------- MA
#        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
#           WHERE qcm02=sr.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
#             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
#        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
#        #------- MI
#        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
#           WHERE qcm02=sr.qcm02 AND qcm04 BETWEEN tm.bdate AND tm.edate
#             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
#        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
#        #-------- 不良數總計
#       #---------------No.TQC-750064 modify
#       #LET sr.crqty=(cr*g_qcz.qcz02/g_qcz.qcz021)+
#       #             (ma*g_qcz.qcz03/g_qcz.qcz031)+
#       #             (mi*g_qcz.qcz04/g_qcz.qcz041)
#        LET sr.crqty=sr.qcm22 - sr.stkqty
#
#       #IF sr.qcm06 = 0 THEN      # 分母為零, 另作處理
#        IF sr.qcm22 = 0 THEN      # 分母為零, 另作處理
#           LET sr.crrate = 0
#        ELSE
#          #LET sr.crrate = (sr.crqty/sr.qcm06)*100
#           LET sr.crrate = (sr.crqty/sr.qcm22)*100
#        END IF
#       #---------------No.TQC-750064 end
#        IF sr.lot = 0 THEN       # 分母為零, 另作處理
#           LET sr.rejrate = 0
#        ELSE
#           LET sr.rejrate = sr.rejqty/sr.lot * 100
#        END IF
##FUN-670106--begin
##           PRINT COLUMN 04,g_x[24] CLIPPED,sr.qcm02;
##           PRINT COLUMN 40,g_x[17] CLIPPED,tm.bdate,'-',tm.edate  #No.FUN-550063
##           PRINT ''
##           PRINT COLUMN  4,g_x[11] CLIPPED,sr.lot, # USING '999999999999',
##                 COLUMN 28,g_x[12] CLIPPED, sr.qcm22, # USING '#####$.$$$',
##                 COLUMN 55,g_x[13] CLIPPED, sr.stkqty # USING '#######$.$'
##           PRINT ""
##           PRINT COLUMN  4,g_x[14] CLIPPED, sr.qcm06, # USING '#######$',
##                 COLUMN 28,g_x[15] CLIPPED, sr.crqty, # USING '########$',
##                 COLUMN 55,g_x[16] CLIPPED, sr.crrate # USING '########$'
##           PRINT g_dash_1[1,g_len]
##           PRINT COLUMN 4, g_x[18] CLIPPED, sr.rejqty,
##                 COLUMN 28,g_x[19] CLIPPED, sr.rejrate,'%'
##           PRINT ''
##           PRINT ''
##           PRINT ''
#            PRINTX name=D1 
#                   COLUMN g_c[31],sr.qcm02,
#                   COLUMN g_c[32],tm.bdate,'-',tm.edate,
#                   COLUMN g_c[33],cl_numfor(sr.lot,33,0),
#                   COLUMN g_c[34],cl_numfor(sr.qcm22,34,3),
#                   COLUMN g_c[35],cl_numfor(sr.stkqty,35,3),
#                   COLUMN g_c[36],cl_numfor(sr.rejqty,36,0)
#            PRINTX name=D2
#                  #COLUMN g_c[39],cl_numfor(sr.qcm06,39,3),   #No.TQC-750064 mark
#                   COLUMN g_c[40],cl_numfor(sr.crqty,40,3),
#                   COLUMN g_c[41],cl_numfor(sr.crrate,41,3),
#                   COLUMN g_c[42],cl_numfor(sr.rejrate,42,3)        
##FUN-670106--end
#    ON LAST ROW
#            LET l_trailer_sw = 'y'
##FUN-670106--begin
#    PAGE TRAILER  
#              PRINT g_dash[1,g_len]   
#           IF l_trailer_sw ='y' THEN
#              PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#           ELSE
#              PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED 
#           END IF
##FUN-670106--end
#END REPORT
 
#Patch....NO.TQC-610036 <001,002,003> #
#No.FUN-870144

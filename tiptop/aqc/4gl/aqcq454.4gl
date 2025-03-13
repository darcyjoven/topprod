# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aqcq454.4gl
# Descriptions...: 客戶相關機種出貨品質記錄彙總查詢
# Date & Author..: 99/05/18 By Iceman
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-6A0086 06/11/13 By baogui 報表數字沒對齊
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850033 08/05/07 By sherry 報表改由CR輸出 
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
        wc                      LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
        bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE #日期起
        edate                   LIKE type_file.dat           #No.FUN-680104 DATE #日期迄
        END RECORD,
    g_qcf  RECORD
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE #日期起
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE #日期迄
            occ01               LIKE occ_file.occ01,   #客戶編號
            occ02               LIKE occ_file.occ02,   #客戶名稱
            lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)        #送驗批號
            qcf22               LIKE qcf_file.qcf22,  #送驗量
            stkqty              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)      #入庫數量
           #qcf06               DECIMAL(10,3),         #檢驗量     #No.TQC-750064 mark
            crqty               LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)       #不良數
            crrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)       #不良率
            rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)        #不合格批數
            rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)       #不合格批率
        END RECORD,
    g_state DYNAMIC ARRAY OF RECORD
            sta     LIKE type_file.chr2,         #No.FUN-680104 VARCHAR(2)
            code    LIKE type_file.chr4,         #No.FUN-680104 VARCHAR(4)
            desc    LIKE cob_file.cob08,         #No.FUN-680104 VARCHAR(30)
            lot     LIKE type_file.num10         #No.FUN-680104 INTEGER
        END RECORD,
    g_rec_b         LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    m_cnt           LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_sql           STRING,                      #WHERE CONDITION  #No.FUN-580092 HCN        #No.FUN-680104
    g_dash_1        LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(132) # Dash line
    cr,ma,mi        LIKE qcg_file.qcg07          #No.FUN-680104 DEC(12,3)
 
 
DEFINE   g_i            LIKE type_file.num5          #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680104 SMALLINT
#No.FUN-850033---Begin                                                          
DEFINE   g_str           STRING                                                 
DEFINE   l_table         STRING                                                 
#No.FUN-850033---End 
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col          LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
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
    #No.FUN-850033---Begin                                                      
    LET g_sql = "occ01.occ_file.occ01,",
                "occ02.occ_file.occ02,",
                "lot.tod_file.tod08,",
                "stkqty.qcf_file.qcf06,",
                "crqty.ima_file.ima18,",
                "crrate.ima_file.ima18,",
                "rejqty.tod_file.tod08,",
                "rejrate.ima_file.ima18 "
                                    
    LET l_table = cl_prt_temptable('aqcq454',g_sql) CLIPPED                     
    IF l_table = -1 THEN EXIT PROGRAM END IF                                    
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,             
                " VALUES(?,?,?,?,?, ?,?,?)"                     
    PREPARE insert_prep FROM g_sql                                              
    IF STATUS THEN                                                              
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                        
    END IF                                                                      
    #NO.FUN-850033---End 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 4 LET p_col = 20
   ELSE LET p_row = 5 LET p_col = 3
   END IF
    OPEN WINDOW q454_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq454"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q454_q()
#    END IF
 
    #WHILE TRUE      ####040512
      LET g_action_choice=""
    CALL q454_menu()
      #IF g_action_choice="exit" THEN EXIT WHILE END IF     ####040512
    #END WHILE    ####040512
 
    CLOSE WINDOW q454_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q454_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
   CLEAR FORM #清除畫面
   CALL g_state.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                      # Default condition
   INITIALIZE g_qcf.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON occ01
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
                   LET g_qcf.bdate=tm.bdate
                AFTER FIELD edate
                   IF cl_null(tm.edate) THEN CALL cl_err('','aap-099',0)
                      NEXT FIELD edate
                   END IF
                   IF tm.edate<tm.bdate THEN
                        NEXT FIELD edate
                   END IF
                   LET g_qcf.edate=tm.edate
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
       LET g_qcf.bdate=tm.bdate
       LET g_qcf.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE occ02,occ01 ",
             " FROM qcf_file,occ_file,sfb_file, oea_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcf02 = sfb01 AND sfb22 = oea01 AND oea04 = occ01 ",
             " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
             " AND qcf14='Y' AND qcf18='2' "
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY occ01"
 
   PREPARE q454_prepare FROM g_sql
   DECLARE q454_cs SCROLL CURSOR FOR q454_prepare
   LET g_sql=" SELECT COUNT(UNIQUE occ01) ",
             " FROM qcf_file,occ_file,sfb_file, oea_file ",
             " WHERE ",tm.wc CLIPPED,
             " AND qcf02 = sfb01 AND sfb22 = oea01 AND oea04 = occ01 ",
             " AND qcf14='Y' AND qcf18='2' ",
             " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND occuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND occgrup IN ",cl_chk_tgrup_list()
   #   END IF
   #End:FUN-980030
 
   PREPARE q454_prepare1 FROM g_sql
   DECLARE q454_count CURSOR FOR q454_prepare1
END FUNCTION
 
 
#中文的MENU
FUNCTION q454_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                CALL q454_q()
            END IF
            NEXT OPTION "next"
        ON ACTION next
            CALL q454_fetch('N')
        ON ACTION previous
            CALL q454_fetch('P')
        ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth() THEN
                CALL q454_out()
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
#        ON ACTION jump
#            CALL q454_fetch('/')
#        ON ACTION first
#            CALL q454_fetch('F')
#        ON ACTION last
#            CALL q454_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
 
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
END FUNCTION
 
 
FUNCTION q454_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q454_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q454_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q454_count
       FETCH q454_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q454_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
 
FUNCTION q454_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
    CASE p_flag
        WHEN 'N' FETCH NEXT     q454_cs INTO g_qcf.occ02,g_qcf.occ01
        WHEN 'P' FETCH PREVIOUS q454_cs INTO g_qcf.occ02,g_qcf.occ01
        WHEN 'F' FETCH FIRST    q454_cs INTO g_qcf.occ02,g_qcf.occ01
        WHEN 'L' FETCH LAST     q454_cs INTO g_qcf.occ02,g_qcf.occ01
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
          FETCH ABSOLUTE g_jump q454_cs INTO g_qcf.occ02,g_qcf.occ01
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.SQLCODE THEN
       INITIALIZE g_qcf.* TO NULL  #TQC-6B0105
       CALL cl_err('',SQLCA.SQLCODE,0) RETURN
    ELSE
       CASE p_flag
            WHEN 'F' LET g_curs_index = 1
            WHEN 'P' LET g_curs_index = g_curs_index - 1
            WHEN 'N' LET g_curs_index = g_curs_index + 1
            WHEN 'L' LET g_curs_index = g_row_count
            WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
 
    END IF
 
    CALL q454_show()
END FUNCTION
 
FUNCTION q454_show()
   DISPLAY BY NAME g_qcf.*
#-----------------------------------------------------------------------#
   CALL q454_calc()
# 顯示資料
   DISPLAY g_qcf.lot TO FORMONLY.lot
   DISPLAY g_qcf.qcf22 TO FORMONLY.qcf22
   DISPLAY g_qcf.stkqty TO FORMONLY.stkqty
  #DISPLAY g_qcf.qcf06 TO FORMONLY.qcf06      #No.TQC-750064 mark
   DISPLAY g_qcf.crqty TO FORMONLY.crqty
   DISPLAY g_qcf.rejqty TO FORMONLY.rejqty
   DISPLAY g_qcf.crrate TO FORMONLY.crrate
   DISPLAY g_qcf.rejrate TO FORMONLY.rejrate
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q454_calc()
#-----------------------start calculating for ------------------#
# 計算送驗批數
   SELECT COUNT(*) INTO g_qcf.lot FROM qcf_file, occ_file, oea_file, sfb_file
        WHERE occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
           AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
           AND qcf14='Y' AND qcf18='2'
   IF STATUS=100 THEN LET g_qcf.lot=0 END IF
# 計算送驗量
   SELECT SUM(qcf22) INTO g_qcf.qcf22 FROM qcf_file,occ_file,oea_file,sfb_file
        WHERE occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
           AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
           AND qcf14='Y' AND qcf18='2'
   IF STATUS=100 THEN LET g_qcf.qcf22 = 0 END IF
# 計算入庫數量
   SELECT SUM(qcf091) INTO g_qcf.stkqty FROM qcf_file,occ_file,oea_file,sfb_file
        WHERE occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
           AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
           AND qcf14='Y' AND qcf18='2'
   IF STATUS=100 THEN LET g_qcf.stkqty=0 END IF
# 計算檢驗數
  #-----------------No.TQC-750064 mark
  #SELECT SUM(qcf06) INTO g_qcf.qcf06 FROM qcf_file,occ_file,oea_file,sfb_file
  #     WHERE occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
  #        AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
  #        AND qcf14='Y' AND qcf18='2'
  #IF STATUS=100 THEN LET g_qcf.qcf06=0 END IF
  #-----------------No.TQC-750064 end
# 計算不良數
   #-------- CR
   SELECT SUM(qcg07) INTO cr
     FROM qcf_file,qcg_file,occ_file,oea_file,sfb_file
    WHERE qcf01=qcg01 AND qcg05='1' AND qcf14='Y' AND qcf18='2'
      AND occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
      AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
   IF STATUS OR cr IS NULL THEN LET cr=0 END IF
   #-------- MA
   SELECT SUM(qcg07) INTO MA
     FROM qcf_file,qcg_file,occ_file,oea_file,sfb_file
    WHERE qcf01=qcg01 AND qcg05='2' AND qcf14='Y' AND qcf18='2'
      AND occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
      AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
   IF STATUS OR ma IS NULL THEN LET ma=0 END IF
   #-------- MI
   SELECT SUM(qcg07) INTO mi
     FROM qcf_file,qcg_file,occ_file,oea_file,sfb_file
    WHERE qcf01=qcg01 AND qcg05='3' AND qcf14='Y' AND qcf18='2'
      AND occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
      AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
   IF STATUS OR mi IS NULL THEN LET mi=0 END IF
  #------------No.TQC-750064 modify
  #LET g_qcf.crqty=(cr*g_qcz.qcz02/g_qcz.qcz021)+(ma*g_qcz.qcz03/g_qcz.qcz031)+(mi*g_qcz.qcz04/g_qcz.qcz041)
   LET g_qcf.crqty=g_qcf.qcf22 - g_qcf.stkqty
  #------------No.TQC-750064 end
 
# 計算不合格批數
   SELECT count(*) INTO g_qcf.rejqty FROM qcf_file,occ_file,oea_file,sfb_file
        WHERE occ01 = g_qcf.occ01 AND oea04 = g_qcf.occ01 AND sfb22 = oea01
           AND qcf02 = sfb01 AND qcf04 BETWEEN g_qcf.bdate AND g_qcf.edate
           AND qcf09 != '1' AND qcf14='Y' AND qcf18='2'
   IF STATUS=100 OR g_qcf.rejqty IS NULL THEN LET g_qcf.rejqty=0 END IF
 
# 計算不良率
  #------------------No.TQC-750064 modify
  #IF g_qcf.qcf06 = 0 THEN       # 理論上, 不可能發生才對
   IF g_qcf.qcf22 = 0 THEN       # 理論上, 不可能發生才對
  #------------------No.TQC-750064 end
        LET g_qcf.crrate = 0
   ELSE
       #---------------No.TQC-750064 modify
       #LET g_qcf.crrate = g_qcf.crqty / g_qcf.qcf06 * 100
        LET g_qcf.crrate = g_qcf.crqty / g_qcf.qcf22 * 100
       #---------------No.TQC-750064 end
   END IF
   IF g_qcf.lot = 0 THEN         # 沒有送驗又那來資料呢?
        LET g_qcf.rejrate = 0
   ELSE
# 計算不合格批率
        LET g_qcf.rejrate = g_qcf.rejqty / g_qcf.lot * 100
   END IF
END FUNCTION
 
FUNCTION q454_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,               #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000             #        #No.FUN-680104 VARCHAR(40)
 
    CALL cl_wait()
    CALL cl_del_data(l_table)     #No.FUN-850033
    #CALL cl_outnam('aqcq454') RETURNING l_name    #No.FUN-850033
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aqcq454'
    #No.FUN-850033---Begin   
    #IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    #FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    #FOR g_i = 1 TO g_len LET g_dash_1[g_i,g_i] = '-' END FOR
    #START REPORT q454_rep TO l_name
    #No.FUN-850033---End
 
    FOREACH q454_cs INTO g_qcf.occ02,g_qcf.occ01
        IF SQLCA.SQLCODE THEN
                CALL cl_err('Foreach:',SQLCA.SQLCODE,1)
                EXIT FOREACH
        END IF
        CALL q454_calc()
        #No.FUN-850033---Begin  
        #OUTPUT TO REPORT q454_rep(g_qcf.*)
        EXECUTE insert_prep USING g_qcf.occ01,g_qcf.occ02,g_qcf.lot,
                                  g_qcf.stkqty,g_qcf.crqty,
                                  g_qcf.crrate,g_qcf.rejqty,g_qcf.rejrate
        #No.FUN-850033---End
    END FOREACH
 
    #No.FUN-850033---Begin    
    #FINISH REPORT q454_rep
    #ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)
    #是否列印選擇條件                                                           
    IF g_zz05 = 'Y' THEN                                                        
       CALL cl_wcchp(tm.wc,'occ01')                                      
            RETURNING g_str                                                     
    END IF                                                                      
    LET g_str = g_str,";",tm.bdate,";",tm.edate                                 
    LET g_sql="SELECT * FROM ", g_cr_db_str CLIPPED,l_table CLIPPED             
    CALL cl_prt_cs3('aqcq454','aqcq454',g_sql,g_str)                            
    #No.FUN-850033---End
    OPEN q454_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q454_count
       FETCH q454_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q454_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#No.FUN-850033---Begin
#REPORT q454_rep(sr)
#DEFINE
#       l_trailer_sw    LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(1)
#       sr     RECORD
#           bdate               LIKE type_file.dat,        #No.FUN-680104 DATE           #日期起
#           edate               LIKE type_file.dat,        #No.FUN-680104 DATE           #日期迄
#           occ01               LIKE occ_file.occ01,       #客戶編號
#           occ02               LIKE occ_file.occ02,       #客戶名稱
#           lot                 LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)       #送驗批號
#           qcf22               LIKE qcf_file.qcf22,       #送驗量
#           stkqty              LIKE qcf_file.qcf06,       #No.FUN-680104 DECIMAL(12,3)        #入庫數量
#          #qcf06               DECIMAL(10,3),         #檢驗量    #No.TQC-750064 mark
#           crqty               LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)        #不良數
#           crrate              LIKE ima_file.ima18,       #No.FUN-680104 DECIMAL(9,3)        #不良率
#           rejqty              LIKE tod_file.tod08,       #No.FUN-680104 DECIMAL(8,0)       #不合格批數
#           rejrate             LIKE ima_file.ima18        #No.FUN-680104 DECIMAL(9,3)     #不合格批率
#       END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#   ORDER BY sr.occ01
#   FORMAT
#   PAGE HEADER
#           PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
#           PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '
#           PRINT g_x[2] CLIPPED,g_today,' ',TIME,
#               COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'n'
#   BEFORE GROUP OF sr.occ01
#          SKIP TO TOP OF PAGE
#   ON EVERY ROW
#           PRINT COLUMN 4,g_x[24] CLIPPED,sr.occ01, ' ', sr.occ02,
#                 COLUMN 51,g_x[17] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT ''
##TQC-6A0086--begin 
#     #      PRINT COLUMN  4,g_x[11] CLIPPED, sr.lot, # USING '999999999999',
#     #             COLUMN 51,g_x[13] CLIPPED, sr.stkqty # USING '#######$.$'
#           PRINT COLUMN  4,g_x[11] CLIPPED, cl_numfor(sr.lot,10,0),                                                                
#                 COLUMN 51,g_x[13] CLIPPED, cl_numfor(sr.stkqty,10,3)
##TQC-6A0086 --end
#           PRINT ""
##TQC-6A0086--begin
#     #      PRINT COLUMN  4,g_x[14] CLIPPED, sr.qcf06, # USING '#######$',
#     #            COLUMN 28,g_x[15] CLIPPED, sr.crqty, # USING '########$',
#     #            COLUMN 51,g_x[16] CLIPPED, sr.crrate # USING '########$'
#          #-----------------No.TQC-750064 modify
#          #PRINT COLUMN  4,g_x[14] CLIPPED, cl_numfor(sr.qcf06,10,3),                                                              
#          #      COLUMN 28,g_x[15] CLIPPED, cl_numfor(sr.crqty,10,3),                                                              
#          #      COLUMN 51,g_x[16] CLIPPED, cl_numfor(sr.crrate,10,3)                                                              
#           PRINT COLUMN 4,g_x[15] CLIPPED, cl_numfor(sr.crqty,10,3),                                                              
#                 COLUMN 51,g_x[16] CLIPPED, cl_numfor(sr.crrate,10,3)                                                              
#          #-----------------No.TQC-750064 end
##TQC-6A0086 --end
#           PRINT g_dash_1[1,g_len]
#           PRINT COLUMN 4, g_x[18] CLIPPED, sr.rejqty,
#                 COLUMN 28, g_x[19] CLIPPED, sr.rejrate,'%'
#           PRINT ''
#   ON LAST ROW
#           PRINT g_dash[1,g_len]
#           LET l_trailer_sw = 'y'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#   PAGE TRAILER
#           IF l_trailer_sw = 'n' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-850033---End
 
#Patch....NO.TQC-610036 <001,002,003> #
#No.FUN-870144

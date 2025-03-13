# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmq210.4gl
# Descriptions...: 客戶信用明細查核
# Date & Author..: 95/01/23 By Nick
# modify.........: 960116 by nick
# modify.........: 96/02/09 by danny  出貨單須已確認、已扣帳,增加多工廠信用查核
# modify.........: 03/09/29 by Ching 未能查出(b_fill) "6.代採買出貨單" 資料
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0050 04/11/23 By Mandy DEFINE 匯率時用LIKE的方式
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.MOD-540055 05/05/11 By Mandy 交易金額合計,信用餘額合計要有小數點
# Modify.........: No.MOD-580277 05/09/06 By Nicola 出現-11023錯誤
# Modify.........: No.FUN-610020 06/01/10 By Carrier 出貨驗收功能 -- 修改oga09的判斷
# Modify.........: No.FUN-620033 06/02/20 By pengu 若直接RUN axmq210在判斷cal_t65及cal_t70時應與cal_t64一樣
# Modify.........: No.TQC-5C0087 06/03/21 By Ray AR月底重評價 
# Modify.........: NO.FUN-630086 06/04/04 By Niocla 多工廠客戶信用查詢
# Modify.........: NO.MOD-640569 06/04/26 By Nicola 出貨改用況狀碼判斷
# Modify.........: No.MOD-640498 06/06/21 By Mandy cal_t66() pab_amt==>由SUM(oeb24*oeb13) 的值不正確
# Modify.........: NO.MOD-650058 06/06/21 By Mandy承MOD-640498補強, pab_amt應該要抓當站資料庫的資料來計算
# Modify.........: No.FUN-660167 06/06/23 By cl cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-6A0121 06/12/14 By pengu FUNCTION cal_t66中,SELECT oeb24*oeb13要改成SELECT SUM(oeb24*oeb13)
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740016 07/05/09 By Nicola 借出管理
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790065 07/09/11 By lumxa 匯出Excel多出一空白行
# Modify.........: NO.FUN-640215 08/02/13 By Mandy s_exrate()改用s_exrate_m() 
# Modify.........: No.MOD-820186 08/03/24 By chenl 增加折扣率計算
# Modify.........: No.MOD-840337 08/04/24 By claire 調整MOD-820186語法
# Modify.........: No.MOD-840336 08/04/25 By claire 調整MOD-820186語法
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860089 08/06/10 By Smapmin 抓取訂單單身資料時,要加上oeb12>oeb24的條件
# Modify.........: No.MOD-8A0126 08/10/21 By chenyu 在計算訂單的信用時，使用計價單位的時候，需要有轉換率
# Modify.........: No.MOD-8C0094 08/12/16 By Smapmin 將t64()/t66()的計算方式調整成與s_ccc一致.
# Modify.........: No.CHI-8C0028 09/01/12 By xiaofeizhu oga09的條件由2348調整為23468
# Modify.........: No.FUN-930006 09/03/03 By mike 對于跨庫SQL，去掉冒號，用s_dbstring()包起dbname
# Modify.........: No.MOD-940248 09/04/20 By lutingting臨時表q210_ccc得變量plant宣告的長度為8是不夠得 
# Modify.........: No.TQC-970038 09/07/03 By lilingyu 增加一個參數
# Modify.........: No.CHI-910034 09/07/09 By chenmoyan 金額部分沒有按照幣種取位
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990029 09/09/07 By Didi 信用額度金額計算邏輯調整 
# Modify.........: No.MOD-990044 09/09/07 By Dido 條件調整
# Modify.........: No.CHI-980048 09/09/17 By Dido 應收逾期帳(t65)計算邏輯調整(應收-已沖-未確認收款) 
# Modify.........: No.FUN-980091 09/09/18 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-930010 09/10/09 By chenmoyan 給額度客戶開窗
# Modify.........: NO.TQC-9B0011 09/11/03 By liuxqa s_dbstring的修改。
# Modify.........: NO.MOD-9C0029 09/12/10 By lilingyu 程序中_sql定義長度為chr1000,部分sql查詢時長度會超過此范圍,更改為string
# Modify.........: No:CHI-9C0003 09/12/17 By Smapmin 待抵的金額回頭抓訂金的金額
# Modify.........: No:MOD-9C0317 09/12/24 By Smapmin 還原CHI-9C0003
# Modify.........: No:MOD-9C0366 09/12/24 By sabrina FUNCTION cal_t66的p_slip型態有誤，長度不足 
# Modify.........: No:MOD-9C0316 09/12/25 By sabrina 跨資料庫拋轉 
# Modify.........: No:TQC-970358 09/12/29 By baofei 對于跨庫SQL,去掉冒號，用s_dbstring()包起dbname
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:MOD-A10132 10/01/27 By Smapmin 信用餘額應排除逾期應收
# Modify.........: No:MOD-A50023 10/05/05 By sabrina 信用額度計算有誤
# Modify.........: No.FUN-A50102 10/06/17 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-B20126 11/02/23 By Summer 計算FUNCTION cal_t66()的餘額錯誤
# Modify.........: No:MOD-B70221 11/07/22 By JoHung pab_amt計算後應取位
# Modify.........: No:MOD-B80027 11/08/03 By johung 計算出貨通知單應加上未結案項次條件
# Modify.........: No:MOD-C80146 12/09/17 By jt_chen SQL增加撈欄位occ36 INTO l_occ36
# Modify.........: No:TQC-C90025 12/10/17 By Nina  呈現的資料以 s_ccc 為主

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,# Head Where condition   #No.FUN-680137 VARCHAR(500)
        	wc2  	LIKE type_file.chr1000	# Body Where condition  #No.FUN-680137 VARCHAR(500)
        END RECORD,
    g_occ   RECORD      LIKE occ_file.*,
    g_ocg   RECORD LIKE ocg_file.*,
    g_curr   LIKE azi_file.azi01,
    g_exrate LIKE azk_file.azk03, #FUN-4B0050
    g_oob06       	LIKE oob_file.oob06,
    g_occ02       	LIKE occ_file.occ02,
    g_occ33       	LIKE occ_file.occ33,
    g_occ11       	LIKE occ_file.occ11,   # 統一編號
    g_occ61       	LIKE occ_file.occ61,   # 信用評等
    g_occ62       	LIKE occ_file.occ62,   # 信用評等
    g_occ_link          LIKE cob_file.cob08,   #No.FUN-680137 VARCHAR(30)
    g_occ631            LIKE occ_file.occ631,
    l_occ631            LIKE occ_file.occ631,
    l_occ36             LIKE occ_file.occ36,   #寬限天數
    l_type              LIKE type_file.chr8,   #No.FUN-680137 VARCHAR(8)
    g_tot		LIKE occ_file.occ63,   #FUN-4C0006
    l_tot		LIKE occ_file.occ63,   #FUN-4C0006
    l_bal		LIKE occ_file.occ63,   #FUN-4C0006
    g_aza17             LIKE aza_file.aza17,
    g_oma DYNAMIC ARRAY OF RECORD
	    plant       LIKE faj_file.faj02,   #No.FUN-680137 VARCHAR(10)
	    tradetype	LIKE type_file.chr8,   #No.FUN-680137 VARCHAR(8)
            oma11   LIKE oma_file.oma11,
            oma01   LIKE oma_file.oma01,
            oma23   LIKE oma_file.oma23,
            oma50   LIKE oma_file.oma50,   #FUN-4C0006
            weight  LIKE ocg_file.ocg02,   #No.FUN-680137 DEC(15,3) #TQC-8400
            balance LIKE type_file.num20_6 #FUN-4C0006  #No.FUN-680137 DEC(20,6)
        END RECORD,
    g_occ261        LIKE occ_file.occ261,
    g_occ29         LIKE occ_file.occ29,
    g_argv1         LIKE occ_file.occ01,
    g_argv2         LIKE type_file.chr1,        #1.查待底 2.查LC 3....              #No.FUN-680137 VARCHAR(1)
    g_argv3         LIKE oea_file.oea01,         #TQC-970038    
    g_query_flag    LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入next  #No.FUN-680137 SMALLINT
    g_sql           STRING,                     #WHERE CONDITION  #No.FUN-580092 HCN  #No.FUN-680137 STRING
    g_rec_b         LIKE type_file.num10        #單身筆數         #No.FUN-680137 INTEGER
DEFINE g_cnt        LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE g_msg        LIKE type_file.chr1000,     #No.FUN-680137 VARCHAR(72)
       l_ac         LIKE type_file.num5         #No.FUN-680137 SMALLINT
DEFINE g_row_count  LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE g_curs_index LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE g_jump       LIKE type_file.num10        #No.FUN-680137 INTEGER
DEFINE g_no_ask     LIKE type_file.num5         #No.FUN-680137 SMALLINT
#DEFINE t_azi03      LIKE azi_file.azi03         #No.MOD-820186  #TQC-C90025 mark
#DEFINE t_azi04      LIKE azi_file.azi04         #No.MOD-820186  #TQC-C90025 mark
 
MAIN
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
   LET g_argv2      = ARG_VAL(2)          #參數值(1) 明細類別
    LET g_argv3      = ARG_VAL(3)           #TQC-970038
    
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0094
 
   LET g_query_flag=1
 
   SELECT aza17 INTO g_aza17 FROM aza_file WHERE aza01='0'
   IF STATUS <> 0 THEN LET g_aza17='NTD' END IF
 
   OPEN WINDOW q210_w WITH FORM "axm/42f/axmq210"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
    DROP TABLE q210_ccc
    CREATE TEMP TABLE q210_ccc(
	    plant       LIKE type_file.chr10,         #MOD-940248   chr8-->chr10           
	    tradetype	LIKE type_file.chr8,  
            oma11       LIKE type_file.dat,   
            oma01       LIKE oma_file.oma01, 
            oma23       LIKE oma_file.oma23,
            oma50       LIKE type_file.num20_6,
            weight      LIKE ocg_file.ocg02,        #TQC-840066
            balance     LIKE type_file.num20_6,
            kind        LIKE type_file.chr1)
 
    DELETE FROM q210_ccc WHERE 1=1
 
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'                                                                              
   IF NOT cl_null(g_argv1) THEN CALL q210_q() END IF
 
   CALL q210_menu()
 
   CLOSE WINDOW q210_w
   DROP TABLE q210_ccc
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0094
END MAIN
 
 
#QBE 查詢資料
FUNCTION q210_cs()
   DEFINE   l_cnt    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
            l_occ33  LIKE occ_file.occ33
 
   IF NOT cl_null(g_argv1) THEN
      SELECT occ33 INTO l_occ33 FROM occ_file WHERE occ01 = g_argv1
      IF cl_null(l_occ33) THEN LET l_occ33 = g_argv1 END IF
      LET tm.wc = "occ33 = '",l_occ33,"'"
      ELSE CLEAR FORM #清除畫面
   CALL g_oma.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_occ33 TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON occ33,occ02
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              ON ACTION CONTROLP
                 CASE
                    WHEN INFIELD(occ33)
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = 'c'
                        LET g_qryparam.form ="q_occ"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO occ33
                        NEXT FIELD occ33
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT UNIQUE occ33 FROM occ_file ",
             " WHERE ",tm.wc CLIPPED," AND occ33 IS NOT NULL "
 
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
 
   LET g_sql = g_sql clipped," ORDER BY occ33"
 
   PREPARE q210_prepare FROM g_sql
   DECLARE q210_cs                         #SCROLL CURSOR
           SCROLL CURSOR WITH HOLD FOR q210_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
   LET g_sql=" SELECT COUNT(DISTINCT occ33) FROM occ_file ",
              " WHERE ",tm.wc CLIPPED," AND occ33 IS NOT NULL AND occ33 != ' '"
   #資料權限的檢查
 
   PREPARE q210_pp  FROM g_sql
   DECLARE q210_cnt CURSOR FOR q210_pp
 
   LET g_sql="SELECT * FROM occ_file WHERE occ01 = ? ",
             " OR (occ33 = ? AND occ33 IS NOT NULL ) AND occ62 = 'Y' "
   PREPARE q210_pre1 FROM g_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('pre1 occ',SQLCA.SQLCODE,1)
   END IF
   DECLARE q210_cur1 CURSOR FOR q210_pre1
   IF SQLCA.SQLCODE THEN
      CALL cl_err('dec1 occ',SQLCA.SQLCODE,1)
   END IF
END FUNCTION
 
FUNCTION q210_b_askkey()
   CONSTRUCT tm.wc2 ON oma11,oma01,oma23,oma50
                  FROM s_oma[1].oma11,s_oma[1].oma01,
                       s_oma[1].oma23,s_oma[1].oma50
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
END FUNCTION
 
FUNCTION q210_menu()
 
   WHILE TRUE
      CALL q210_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q210_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oma),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q210_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
 
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL q210_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q210_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q210_cnt
        FETCH q210_cnt INTO g_row_count
        DISPLAY g_row_count TO cnt
        CALL q210_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q210_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680137 VARCHAR(1)
    l_occ63 LIKE occ_file.occ63,
    l_occ64 LIKE occ_file.occ64
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q210_cs INTO g_occ33
        WHEN 'P' FETCH PREVIOUS q210_cs INTO g_occ33
        WHEN 'F' FETCH FIRST    q210_cs INTO g_occ33
        WHEN 'L' FETCH LAST     q210_cs INTO g_occ33
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q210_cs INTO g_occ33
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_occ.occ01,SQLCA.sqlcode,0)
        INITIALIZE g_occ.* TO NULL  #TQC-6B0105
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
 
    SELECT occ02,occ11,occ61,occ261,occ29,occ631,occ62,occ36   #MOD-C80146  -- add occ36
      INTO g_occ02,g_occ11,g_occ61,g_occ261,
           g_occ29,g_occ631,g_occ62,l_occ36                    #MOD-C80146  -- add l_occ36
      FROM occ_file
     WHERE occ01 = g_occ33
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","occ_file",g_occ33,"",SQLCA.sqlcode,"","",0)   #No.FUN-660167
        RETURN
    END IF
    IF cl_null(l_occ36) THEN LET l_occ36= 0 END IF
    IF g_occ62 = 'N' THEN CALL cl_err(g_occ33,'axm-270',1) END IF
    IF cl_null(g_occ61) AND g_occ62= 'Y' THEN
       CALL cl_err(g_occ33,'axm-270',1)
    END IF
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_occ631        #No.CHI-910034
 
    CALL q210_show()
END FUNCTION
 
FUNCTION q210_show()
 IF NOT cl_null(g_occ29) THEN
    LET g_occ_link = g_occ261 CLIPPED,'-',g_occ29 CLIPPED
 ELSE
    LET g_occ_link = g_occ261 CLIPPED
 END IF
 
 # 顯示單頭值
 DISPLAY g_occ33,g_occ02,g_occ_link,g_occ631
      TO FORMONLY.occ33,FORMONLY.occ02,FORMONLY.link,FORMONLY.curr
 CALL q210_b_fill() #單身
 DISPLAY g_tot TO FORMONLY.tot
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q210_b_fill()              #BODY FILL UP
   DEFINE i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_exrate  LIKE azk_file.azk03, #FUN-4B0050
          l_kind    LIKE type_file.chr1           #No.FUN-680137  VARCHAR(1) 
   DELETE FROM q210_ccc WHERE 1=1
    CALL g_oma.clear()          #MOD-540055
    INITIALIZE g_occ.* TO NULL  #MOD-540055
   LET g_tot = 0
   FOREACH q210_cur1 USING g_occ33,g_occ33 INTO g_occ.*
     IF SQLCA.SQLCODE THEN
        CALL cl_err('foreach occ',SQLCA.SQLCODE,1)
        EXIT FOREACH
     END IF
     #合計信用額度金額
     IF cl_null(g_occ.occ63) THEN LET g_occ.occ63=0 END IF
     IF cl_null(g_occ.occ64) THEN LET g_occ.occ64=0 END IF
     IF g_occ631 = g_occ.occ631 THEN
        LET l_exrate = 1
     ELSE
       #幣別轉換
        LET l_exrate=s_exrate_m(g_occ.occ631,g_occ631,g_oaz.oaz212,'') #FUN-640215 add
        IF cl_null(l_exrate) THEN LET l_exrate = 1 END IF
     END IF
     LET g_tot=g_tot+(g_occ.occ63*(1+g_occ.occ64/100)) * l_exrate  #信用額度總額
     IF cl_null(g_tot) THEN LET g_tot = 0 END IF
     CALL q210_b_get(g_occ.occ01,g_occ.occ61)
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
   END FOREACH
   LET i = 1
   LET l_tot=0
   LET l_bal=g_tot
   DECLARE q210_b CURSOR FOR
      SELECT * FROM q210_ccc WHERE oma50 <> 0
       ORDER BY oma11,kind,plant
    FOREACH q210_b INTO g_oma[i].*,l_kind
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach1:',SQLCA.sqlcode,1) 
            EXIT FOREACH
        END IF
        IF l_kind <> 'A' AND l_kind <> 'C' THEN    #MOD-A10132
           LET l_tot = l_tot + g_oma[i].oma50				#MOD-990029
           LET l_bal = l_bal + g_oma[i].oma50				#MOD-990029
        END IF   #MOD-A10132
        LET l_bal = cl_digcut(l_bal,t_azi04)		#MOD-990029
        LET g_oma[i].balance = l_bal
        LET i = i + 1
    END FOREACH
    CALL g_oma.deleteElement(i)   #TQC-790065
    DISPLAY BY NAME l_tot,l_bal
    LET g_rec_b= i - 1
END FUNCTION
 
FUNCTION q210_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oma TO s_oma.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q210_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL q210_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL q210_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q210_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q210_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
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
 
   ON ACTION exporttoexcel       #FUN-4B0038
      LET g_action_choice = 'exporttoexcel'
      EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q210_b_get(p_cus_no,l_occ61)
 DEFINE p_cus_no     LIKE faj_file.faj02     #No.FUN-680137 VARCHAR(10)
 DEFINE l_occ61      LIKE faj_file.faj02     #No.FUN-680137 VARCHAR(10)   	
 DEFINE t51,t52,t53,t54,t55,t61,t62,t63,t64,t65,t66,t67,t70,bal,tot      LIKE type_file.num20_6    #No.FUN-680137 DEC(20,6)  #FUN-4C0006   #No.FUN-740016
 
  SELECT * INTO g_ocg.* FROM ocg_file WHERE ocg01=l_occ61
  IF STATUS THEN 
     CALL cl_err3("sel","ocg_file",l_occ61,"","axm-271","","",0)   #No.FUN-660167
     RETURN  
  END IF
#-(1)-----------------------------------------
 IF g_ocg.ocg02 > 0 THEN     # 待抵帳款   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='1') THEN
       CALL cal_t51(p_cus_no,l_occ61) RETURNING t51
    END IF
 END IF
#-(2)-----------------------------------------
 IF g_ocg.ocg03 > 0 THEN     # ＬＣ收狀   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='2') THEN
       CALL cal_t52(p_cus_no,l_occ61) RETURNING t52
    END IF
 END IF
#-(3)-----------------------------------------
 IF g_ocg.ocg04 > 0 THEN     # 財務暫收支票   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='3') THEN
       CALL cal_t53(p_cus_no,l_occ61) RETURNING t53
    END IF
 END IF
#-(4)-----------------------------------------
 IF g_ocg.ocg04 > 0 THEN     # 財務暫收ＴＴ   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='4') THEN
       CALL cal_t54(p_cus_no,l_occ61) RETURNING t54
    END IF
 END IF
#-(B)-----------------------------------------
 IF g_ocg.ocg05 > 0 THEN     # 沖帳未確認   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='B') THEN
       CALL cal_t55(p_cus_no,l_occ61) RETURNING t55
    END IF
 END IF
#-(5)-----------------------------------------
 IF g_ocg.ocg06 > 0 THEN     # 未兌應收票據   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='5') THEN
       CALL cal_t61(p_cus_no,l_occ61) RETURNING t61
    END IF
 END IF
#-(6)-----------------------------------------
 IF g_ocg.ocg07 > 0 THEN     # 發票應收 (AR)   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='6') THEN
       CALL cal_t62(p_cus_no,l_occ61) RETURNING t62
    END IF
 END IF
#-(7)-----------------------------------------
 IF g_ocg.ocg08 > 0 THEN     # 出貨未開發票  (PA)   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='7') THEN
        CALL cal_t63(p_cus_no,l_occ61,g_argv3) RETURNING t63        #TQC-970038        
    END IF
 END IF
#-(8)-----------------------------------------
 IF g_ocg.ocg09 > 0 THEN     # 出貨通知單  (IF)   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='8') THEN
        CALL cal_t66(p_cus_no,g_argv3,l_occ61) RETURNING t66        #TQC-970038         
    END IF
 END IF
#-(9)-----------------------------------------
 IF g_ocg.ocg10 > 0 THEN     # 接單未出貨  (SO)   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='9') THEN
        CALL cal_t64(p_cus_no,l_occ61,g_argv3) RETURNING t64   #TQC-970038           
    END IF
 END IF
#-(D)-----------------------------------------
 IF g_ocg.ocg10 > 0 THEN     # 接單未出貨  (SO)   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='9') THEN
        CALL cal_t67(p_cus_no,l_occ61,g_argv3) RETURNING t67   #TQC-970038            
    END IF
 END IF
#-(A)-----------------------------------------
#若直接RUN axmq210 則不顯示逾期應收 及逾期票據
 IF g_ocg.ocg11 = 'Y' THEN        # 逾期應收  (OVERDUE)   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='A') THEN
       CALL cal_t65(p_cus_no,l_occ61) RETURNING t65
    END IF
 END IF
#-(C)-----------------------------------------
#若直接RUN axmq210 則不顯示逾期應收 及逾期票據
 IF g_ocg.ocg12 = 'Y' THEN       #逾期未兌現票據   #No.FUN-630086
    IF cl_null(g_argv2) OR (NOT cl_null(g_argv2) AND g_argv2='C') THEN
       CALL cal_t70(p_cus_no,l_occ61) RETURNING t70
    END IF
 END IF
END FUNCTION
 
#以下sql的where條件必須維持與s_ccc 相同
#-(1)---------------------------------#
# 多工廠待抵帳款計算 by WUPN 96-05-23 #
#-------------------------------------#
FUNCTION cal_t51(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t51,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086          #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086 #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 1"
    PREPARE t51_poch FROM l_sql
    DECLARE t51_och CURSOR FOR t51_poch
 
    LET l_j = 1
 
    FOREACH t51_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t51_och:',SQLCA.sqlcode,1) 
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t51=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
                                AND azp053 != 'N' #no.7431
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()         #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t51_pre FROM l_sql
        DECLARE aza_t51_cur CURSOR FOR aza_t51_pre
        OPEN aza_t51_cur 
        FETCH aza_t51_cur INTO l_aza17
        CLOSE aza_t51_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 
                  "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t51_pre FROM l_sql
        DECLARE oaz_t51_cur CURSOR FOR oaz_t51_pre
        OPEN oaz_t51_cur
        FETCH oaz_t51_cur INTO l_oaz211,l_oaz212
 
        IF g_ooz.ooz07 = 'N' THEN                                                                                                   
           LET l_sql="SELECT oma54t-oma55,oma56t-oma57,oma23,oma01,oma11 ",                                                         
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file ",   #FUN-930006  
                     "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102                  
                     " WHERE oma03 ='",p_occ01,"'",                                                                                 
                     " AND oma54t > oma55",                                                                                         
                     " AND omaconf='Y' AND oma00 LIKE '2%'", #TQC-C90025 add ,
                     #TQC-C90025 add start -----
                     " AND oma00 <> '23' ",
                     " UNION ALL ",
                     "SELECT (oma54t-oma55)*(1+oma211/100),(oma56t-oma57)*(1+oma211/100),oma23,oma01,oma11 ",
                     "  FROM ", cl_get_target_table(g_plant_new,'oma_file'),
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 = '23'"
                     #TQC-C90025 add end   -----                                                                          
        ELSE                                                                                                                        
           LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",
                     #"  FROM ", s_dbstring(l_azp03 CLIPPED),"oma_file ",   #FUN-930006
                     "  FROM ", cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 LIKE '2%'", #TQC-C90025 add ,
                     #TQC-C90025 add start -----
                     " AND oma00 <> '23' ",
                     " UNION ALL ",
                     "SELECT (oma54t-oma55)*(1+oma211/100),oma61,oma23,oma01,oma11 ",
                     "  FROM ", cl_get_target_table(g_plant_new,'oma_file'),
                     " WHERE oma03 ='",p_occ01,"'",
                     " AND oma54t > oma55",
                     " AND omaconf='Y' AND oma00 = '23'"
                     #TQC-C90025 add end   -----
        END IF                                                                                                                      
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t51_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t51',SQLCA.SQLCODE,1)
       END IF
       DECLARE t51_curs CURSOR FOR t51_pre
       FOREACH t51_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN  
               LET l_tmp = ntd_amt            #換作本幣
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate   #換作本幣
            END IF
            IF l_occ631 <> l_aza17 THEN       #換作原幣
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * ( g_ocg.ocg02/100 )		#MOD-990029
 
   	LET l_type = cl_getmsg('axm-211',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)          #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg02,0,'1')
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc1",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t51=l_t51+l_tmp
       END FOREACH
    END FOR
    RETURN l_t51
END FUNCTION
 
#-(2)-------------------------------#
# ＬＣ收狀金額計算 by WUPN 96-05-23 #
#-----------------------------------#
FUNCTION cal_t52(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t52,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_ola07     LIKE ola_file.ola07,
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086   #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 2"
    PREPARE t52_poch FROM l_sql
    DECLARE t52_och CURSOR FOR t52_poch
 
    LET l_j = 1
 
    FOREACH t52_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t52_och:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t52=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()         #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102  
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t52_pre FROM l_sql
        DECLARE aza_t52_cur CURSOR FOR aza_t52_pre
        OPEN aza_t52_cur 
        FETCH aza_t52_cur INTO l_aza17
        CLOSE aza_t52_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t52_pre FROM l_sql
        DECLARE oaz_t52_cur CURSOR FOR oaz_t52_pre
        OPEN oaz_t52_cur
        FETCH oaz_t52_cur INTO l_oaz211,l_oaz212
        LET l_sql=" SELECT ola09-ola10,ola06,ola07,ola01,ola02 ",
                  #" FROM ", s_dbstring(l_azp03 CLIPPED),"ola_file ", #FUN-930006  
                  " FROM ", cl_get_target_table(g_plant_new,'ola_file'), #FUN-A50102
                  " WHERE ola05='",p_occ01,"' AND ola40 = 'N'",
                  "   AND ola09>ola10 AND olaconf !='X' "  #010806增
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t52_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t52',SQLCA.SQLCODE,1)  
       END IF
       DECLARE t52_curs CURSOR FOR t52_pre
       FOREACH t52_curs INTO l_amt,g_curr,l_ola07,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF l_ola07 IS NULL THEN LET l_ola07 = 1 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = l_amt * l_ola07
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg03/100   #MOD-990029
 
   	LET l_type = cl_getmsg('axm-212',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg03,0,'2')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc2",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t52=l_t52+l_tmp
       END FOREACH
    END FOR
    RETURN l_t52
END FUNCTION
 
#-(3)-----------------------------------------#
# 多工廠財務暫收支票金額計算 by WUPN 96-05-23 #
#---------------------------------------------#
FUNCTION cal_t53(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t53,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02    #No.FUN-630086   #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 3"
    PREPARE t53_poch FROM l_sql
    DECLARE t53_och CURSOR FOR t53_poch
 
    LET l_j = 1
 
    FOREACH t53_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t51_och:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t53=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
       FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()         #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006\
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t53_pre FROM l_sql
        DECLARE aza_t53_cur CURSOR FOR aza_t53_pre
        OPEN aza_t53_cur 
        FETCH aza_t53_cur INTO l_aza17
        CLOSE aza_t53_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t53_pre FROM l_sql
        DECLARE oaz_t53_cur CURSOR FOR oaz_t53_pre
        OPEN oaz_t53_cur
        FETCH oaz_t53_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh09 ",
                 #"   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file", #FUN-930006 
                 "   FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102 
                 " WHERE nmh11='", p_occ01,"'",
                 "   AND nmh24 IN ('1','2','3','4') ",
                 "   AND (nmh17 IS NULL OR nmh17 =0 )",
                 "   AND nmh38 <> 'X' ",
                 "   AND nmh02 > 0 "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t53_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t53',SQLCA.SQLCODE,1)  
       END IF
       DECLARE t53_curs CURSOR FOR t53_pre
       FOREACH t53_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg04/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-213',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg04,0,'3')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc3",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t53=l_t53+l_tmp
       END FOREACH
    END FOR
    RETURN l_t53
END FUNCTION
 
#-(4)-------------------------------------#
# 多工廠財務暫收ＴＴ計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION cal_t54(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t54,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_sql       STRING,                       #MOD-9C0029                    
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086  #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 3"
    PREPARE t54_poch FROM l_sql
    DECLARE t54_och CURSOR FOR t54_poch
 
    LET l_j = 1
 
    FOREACH t54_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t54_och:',SQLCA.sqlcode,1) 
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
 
    LET l_t54=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()          #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra  #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t54_pre FROM l_sql
        DECLARE aza_t54_cur CURSOR FOR aza_t54_pre
        OPEN aza_t54_cur 
        FETCH aza_t54_cur INTO l_aza17
        CLOSE aza_t54_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t54_pre FROM l_sql
        DECLARE oaz_t54_cur CURSOR FOR oaz_t54_pre
        OPEN oaz_t54_cur
        FETCH oaz_t54_cur INTO l_oaz211,l_oaz212
        #nmg22在系統中是null值,所以必須以單身之幣別判斷
        LET l_sql=" SELECT npk08,npk09,npk05,nmg00,nmg01 ", #原幣,本幣,幣別
                  #" FROM ",s_dbstring(l_azp03 CLIPPED),"nmg_file,", #FUN-930006 
                  #  s_dbstring(l_azp03 CLIPPED),"npk_file",  #TQC-970358
                  " FROM ",cl_get_target_table(g_plant_new,'nmg_file'),",", #FUN-A50102 
                           cl_get_target_table(g_plant_new,'npk_file'),     #FUN-A50102
                 " WHERE nmg18='",p_occ01,"' AND nmgconf = 'Y'",
                 "  AND nmg00=npk00 ",
                 "  AND nmg20 LIKE '2%' ",
                 "   AND nmg23 > 0 ",
                 " AND (nmg24 IS NULL OR nmg24=0 )"
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t54_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t54',SQLCA.SQLCODE,1)  
       END IF
       DECLARE t54_curs CURSOR FOR t54_pre
       FOREACH t54_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg04/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-213',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg04,0,'4')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc4",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t54=l_t54+l_tmp
       END FOREACH
    END FOR
    RETURN l_t54
END FUNCTION
 
#-(B)-------------------------------------#
# 沖帳未確認                              #
#-----------------------------------------#
FUNCTION cal_t55(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t55,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,             #No.FUN-680137 SMALLINT
          l_nmg05     LIKE nmg_file.nmg05,
          l_sql       STRING,                          #MOD-9C0029 
          l_sql2      STRING,                          #MOD-A50023 add
          l_date      LIKE type_file.dat,      #日期   #No.FUN-680137 DATE 
          l_no        LIKE oma_file.oma01,   #單號
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086   #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 4"
    PREPARE t55_poch FROM l_sql
    DECLARE t55_och CURSOR FOR t55_poch
 
    LET l_j = 1
 
    FOREACH t55_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t55_och:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t55=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()               #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra       #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'),     #FUN-A50102 
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t55_pre FROM l_sql
        DECLARE aza_t55_cur CURSOR FOR aza_t55_pre
        OPEN aza_t55_cur 
        FETCH aza_t55_cur INTO l_aza17
        CLOSE aza_t55_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'),     #FUN-A50102  
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t55_pre FROM l_sql
        DECLARE oaz_t55_cur CURSOR FOR oaz_t55_pre
        OPEN oaz_t55_cur
        FETCH oaz_t55_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT oob09,oob10,oob07,ooa01,ooa02 ",
                 #" FROM ", s_dbstring(l_azp03 CLIPPED),"oob_file,", #FUN-930006      
                 #          s_dbstring(l_azp03 CLIPPED),"ooa_file",   #TQC-970358
                 " FROM ", cl_get_target_table(g_plant_new,'oob_file'),",", #FUN-A50102       
                           cl_get_target_table(g_plant_new,'ooa_file'),     #FUN-A50102  
                 " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                 "   AND oob09 > 0 ",
                 " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 "
       #CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       #CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      #MOD-A50023---add---start---
       LET l_sql2 = "SELECT oob09*-1,oob10*-1,oob07,ooa01,ooa02 ",
                    #" FROM ", s_dbstring(l_azp03 CLIPPED),"oob_file,",                                                                            
                    #          s_dbstring(l_azp03 CLIPPED),"ooa_file", 
                    " FROM ", cl_get_target_table(g_plant_new,'oob_file'),",", #FUN-A50102                                                                            
                              cl_get_target_table(g_plant_new,'ooa_file'),     #FUN-A50102     
                    " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                    "   AND oob09 > 0 ",
                    " AND oob04 = '3'  AND oob03='1' AND ooa01=oob01 "
       #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
       #CALL cl_parse_qry_sql(l_sql2,g_plant_new) RETURNING l_sql2 #FUN-A50102
       LET l_sql=l_sql," UNION ",l_sql2
      #MOD-A50023---add---end---
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t55_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t55',SQLCA.SQLCODE,1)  
       END IF
       DECLARE t55_curs CURSOR FOR t55_pre
       FOREACH t55_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg05/100	#MOD-990029 
 
   	LET l_type = cl_getmsg('axm-214',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg05,0,'B')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc5",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t55=l_t55+l_tmp
       END FOREACH
    END FOR
    RETURN l_t55
END FUNCTION
 
 
#-(5)-------------------------------------#
# 多工廠未兌應收票據計算 by WUPN 96-05-23 #
#-----------------------------------------#
FUNCTION cal_t61(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t61,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086  #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 5"
    PREPARE t61_poch FROM l_sql
    DECLARE t61_och CURSOR FOR t61_poch
 
    LET l_j = 1
 
    FOREACH t61_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t61_och:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t61=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()             #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra     #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102   
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t61_pre FROM l_sql
        DECLARE aza_t61_cur CURSOR FOR aza_t61_pre
        OPEN aza_t61_cur 
        FETCH aza_t61_cur INTO l_aza17
        CLOSE aza_t61_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102   
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t61_pre FROM l_sql
        DECLARE oaz_t61_cur CURSOR FOR oaz_t61_pre
        OPEN oaz_t61_cur
        FETCH oaz_t61_cur INTO l_oaz211,l_oaz212
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh09  ",
                 #"   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file", #FUN-930006 
                 "   FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102    
                 " WHERE nmh11='",p_occ01,"' AND nmh24 IN ('1','2','3','4') ",
                 "   AND nmh02 > 0 ",
                 "   AND nmh38 <> 'X' ",
                 " AND (nmh17 >0 AND nmh17 IS NOT NULL)"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t61_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t61',SQLCA.SQLCODE,1) 
       END IF
       DECLARE t61_curs CURSOR FOR t61_pre
       FOREACH t61_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg06/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-215',g_lang)
        LET l_tmp=l_tmp * -1
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg06,0,'5')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc6",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t61=l_t61+l_tmp
       END FOREACH
    END FOR
    RETURN l_t61
END FUNCTION
 
#-(6)-----------------------------------#
# 多工廠發票應收帳計算 by WUPN 96-05-23 #
#---------------------------------------#
FUNCTION cal_t62(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t62,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086 #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 6"
    PREPARE t62_poch FROM l_sql
    DECLARE t62_och CURSOR FOR t62_poch
 
    LET l_j = 1
 
    FOREACH t62_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t62_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t62=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()         #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'),  #FUN-A50102 
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t62_pre FROM l_sql
        DECLARE aza_t62_cur CURSOR FOR aza_t62_pre
        OPEN aza_t62_cur 
        FETCH aza_t62_cur INTO l_aza17
        CLOSE aza_t62_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'),  #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t62_pre FROM l_sql
        DECLARE oaz_t62_cur CURSOR FOR oaz_t62_pre
        OPEN oaz_t62_cur
        FETCH oaz_t62_cur INTO l_oaz211,l_oaz212
        IF g_ooz.ooz07 = 'N' THEN                                                                                                   
           LET l_sql="SELECT oma54t-oma55,oma56t-oma57,oma23,oma01,oma11 ",                                                         
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",   #FUN-930006 
                     "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),  #FUN-A50102                    
                     " WHERE oma03='",p_occ01,"'",                                                                                  
                     "   AND oma54t>oma55",                                                                                         
                     "   AND omaconf='Y' AND oma00 LIKE '1%'"                                                                       
        ELSE                                                                                                                        
           LET l_sql="SELECT oma54t-oma55,oma61,oma23,oma01,oma11 ",                                                                
                     #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file",        #FUN-930006 
                     "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),  #FUN-A50102                    
                     " WHERE oma03='",p_occ01,"'",                                                                                  
                     "   AND oma54t>oma55",                                                                                         
                     "   AND omaconf='Y' AND oma00 LIKE '1%'"                                                                       
        END IF                                                                                                                      
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t62_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t62',SQLCA.SQLCODE,1)
       END IF
       DECLARE t62_curs CURSOR FOR t62_pre
       FOREACH t62_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg07/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-216',g_lang)
        LET l_tmp=l_tmp * -1
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg07,0,'6')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc7",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t62=l_t62+l_tmp
       END FOREACH
    END FOR
    RETURN l_t62
END FUNCTION
 
#-(7)-------------------------------------#
# 多工廠出貨未轉應收計算 by WUPN 96-05-23 #
#-----------------------------------------#
 FUNCTION cal_t63(p_occ01,p_occ61,p_slip)  #TQC-970038
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01     LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t63,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oga24     LIKE oga_file.oga24,
          l_i         LIKE type_file.num5,            #No.FUN-680137 SMALLINT
          l_sql       STRING,                         #MOD-9C0029 
          l_sql1      STRING,                         #MOD-9C0316 
          l_sql2      STRING,                         #MOD-9C0316 
          l_sql3      STRING,                         #MOD-9C0316 
          l_date      LIKE type_file.dat,       #日期 #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086  #No.FUN-680137 VARCHAR(10)
   DEFINE p_slip      LIKE oga_file.oga01       #TQC-970038
   
   
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 7"
    PREPARE t63_poch FROM l_sql
    DECLARE t63_och CURSOR FOR t63_poch
 
    LET l_j = 1
 
    FOREACH t63_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t63_och:',SQLCA.sqlcode,1) 
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t63=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()          #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra  #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t63_pre FROM l_sql
        DECLARE aza_t63_cur CURSOR FOR aza_t63_pre
        OPEN aza_t63_cur 
        FETCH aza_t63_cur INTO l_aza17
        CLOSE aza_t63_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006 
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102   
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t63_pre FROM l_sql
        DECLARE oaz_t63_cur CURSOR FOR oaz_t63_pre
        OPEN oaz_t63_cur
        FETCH oaz_t63_cur INTO l_oaz211,l_oaz212
         #己出貨未轉應收, 所以要考慮應收未確認的亦歸在出貨未轉應收
         LET l_sql1=" SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                 #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file ", 
                 " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102   
                 " WHERE oga03='",p_occ01,"' ",
                 "  AND oga09 IN ('2','3','4','6','8')",         #No.8347 #No.FUN-610020
                 "  AND oga65 ='N'",         #No.8347 #No.FUN-610020
                 "  AND oga00 IN ('1','4','5')",
                 "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                 "  AND ogaconf = 'Y'",              #已確認
                 "  AND ogapost = 'Y'"               #已扣帳
         CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
         CALL cl_parse_qry_sql(l_sql1,g_plant_new) RETURNING l_sql1 #FUN-A50102        
         LET l_sql2= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                 #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file, ",   #TQC-9B0011 mod
                 #"      ",s_dbstring(l_azp03 CLIPPED),"oma_file ",        #TQC-9B0011 mod
                 " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                 "     ,",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102 
                 " WHERE oga03='",p_occ01,"' ",
                 "  AND oga09 IN ('2','3','4','6','8')",         #No.8347 #No.FUN-610020
                 "  AND oga65 ='N'",         #No.8347 #No.FUN-610020
                 "  AND oga00 IN ('1','4','5')",
                 "  AND (oga10 IS NOT NULL AND oga10 <> ' ') ",   #帳款編號
                 "  AND oga10=oma01 ",
                 "  AND ogaconf = 'Y'",              #已確認
                 "  AND ogapost = 'Y'",              #已扣帳
                 "  AND omaconf='N' "                #應收未確認
         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
         CALL cl_parse_qry_sql(l_sql2,g_plant_new) RETURNING l_sql2 #FUN-A50102        
         LET l_sql = l_sql1," UNION ",l_sql2
       IF g_ocg.ocg09 = 0 AND g_ocg.ocg10 = 0 THEN
        IF cl_null(p_slip) THEN               #TQC-970038
          LET l_sql3= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                      #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file ",
                      " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                      " WHERE oga03='",p_occ01,"' ",
                      "  AND oga09 IN ('2','3','4','6','8')",         #No.8347 #No.FUN-610020
                      "  AND oga65 ='N'",         #No.8347 #No.FUN-610020
                      "  AND oga00 IN ('1','4','5')",
                      "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                      "  AND ogapost = 'N'",              #未扣帳
                      "  AND oga55 IN ('1','S') "         #已確認
       ELSE
         LET l_sql3= " SELECT (oga50)*(1+oga211/100),oga23,oga24,oga01,oga02  ",
                      #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file ",
                      " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                      " WHERE oga03='",p_occ01,"' ",
                      "  AND oga09 IN ('2','3','4','6','8')",         
                      "  AND oga65 ='N'",        
                      "  AND oga00 IN ('1','4','5')",
                      "  AND (oga10 IS NULL OR oga10 =' ') ",   #帳款編號
                      "  AND ogapost = 'N'",              #未扣帳
                      "  AND (oga55 IN ('1','S') OR oga01 = '",p_slip,"')"        #已確認      
       END IF 	  
       CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3
       CALL cl_parse_qry_sql(l_sql3,g_plant_new) RETURNING l_sql3 #FUN-A50102   
       LET l_sql = l_sql," UNION ",l_sql3        
       END IF
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql      #FUN-980091
       PREPARE t63_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t63',SQLCA.SQLCODE,1)
       END IF
       DECLARE t63_curs CURSOR FOR t63_pre
       FOREACH t63_curs INTO l_amt,g_curr,l_oga24,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = l_amt*l_oga24
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
        END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg08/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-217',g_lang)
        LET l_tmp=l_tmp * -1
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg08,0,'7')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc8",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t63=l_t63+l_tmp
       END FOREACH
    END FOR
    RETURN l_t63
END FUNCTION
 
#-(8)--Sales Order ---------------------#
# 多工廠接單未出貨計算 by WUPN 96-05-23 #
#---------------------------------------#
 FUNCTION cal_t64(p_occ01,p_occ61,p_slip)  #TQC-970038
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t64,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086 #No.FUN-680137 VARCHAR(10)
   DEFINE l_oeb04     LIKE oeb_file.oeb04        #訂單料號
   DEFINE l_oeb05     LIKE oeb_file.oeb05        #銷售單位
   DEFINE l_oeb916    LIKE oeb_file.oeb916       #計價單位
   DEFINE l_amt2      LIKE oeb_file.oeb14t       #訂單項次金額
   DEFINE l_amt3      LIKE oeb_file.oeb14t       #訂單項次已出貨金額
   DEFINE l_num       LIKE type_file.num5
   DEFINE l_factor    LIKE ima_file.ima31_fac
   DEFINE p_slip      LIKE oga_file.oga01        #TQC-970038
   DEFINE l_oeb12     LIKE oeb_file.oeb12        #TQC-C90025 add
   DEFINE l_oeb13     LIKE oeb_file.oeb13        #TQC-C90025 add
   DEFINE l_oeb24     LIKE oeb_file.oeb24        #TQC-C90025 add
   DEFINE l_oeb1006   LIKE oeb_file.oeb1006      #TQC-C90025 add  
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 9"
    PREPARE t64_poch FROM l_sql
    DECLARE t64_och CURSOR FOR t64_poch
 
    LET l_j = 1
 
    FOREACH t64_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t64_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t64=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()           #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra   #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102   
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t64_pre FROM l_sql
        DECLARE aza_t64_cur CURSOR FOR aza_t64_pre
        OPEN aza_t64_cur 
        FETCH aza_t64_cur INTO l_aza17
        CLOSE aza_t64_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102 
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t64_pre FROM l_sql
        DECLARE oaz_t64_cur CURSOR FOR oaz_t64_pre
        OPEN oaz_t64_cur
        FETCH oaz_t64_cur INTO l_oaz211,l_oaz212
      IF cl_null(p_slip) THEN               #TQC-970038  
       LET l_sql=" SELECT DISTINCT oea01,oea02,oea23,oea24,oea211 ",
                 #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oea_file,  ",
                 #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ",
                 " FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102 
                 "     ,",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102 
                 " WHERE oea03='",p_occ01,"' ",
                 " AND oea01=oeb01 ",
                 " AND oeaconf='Y' AND oea00 IN ('1','4','5') " ,	#MOD-990044
                 " AND oeb70='N' ",  
                 " AND oea49 IN ('1','S') ",     #MOD-8C0094
                 " GROUP BY oea01,oea02,oea23,oea24,oea211 ",   #MOD-8C0094
                 " ORDER BY oea01 "
    ELSE
 LET l_sql=" SELECT DISTINCT oea01,oea02,oea23,oea24,oea211 ",             
                 #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oea_file,  ", 
                 #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ", 
                 " FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102  
                 "     ,",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102   
                 " WHERE oea03='",p_occ01,"' ",
                 " AND oea01=oeb01 ",
                 " AND oeaconf='Y' AND oea00 IN ('1','4','5') " ,	#MOD-990044
                 " AND oeb70='N' ",  
                 " AND (oea49 MATCHES '[1S]' OR oea01 = '",p_slip,"') ",    
                 " GROUP BY oea01,oea02,oea23,oea24,oea211 ",   
                 " ORDER BY oea01 "
    END IF 	
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980091
       PREPARE t64_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          #CALL cl_err('pre t61',SQLCA.SQLCODE,1) #TQC-C90025 mark
          CALL cl_err('pre t64',SQLCA.SQLCODE,1)  #TQC-C90025 add
       END IF
       DECLARE t64_curs CURSOR FOR t64_pre
       FOREACH t64_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211
         SELECT azi03 INTO t_azi03 FROM azi_file                     #No.CHI-910034
          WHERE azi01 = g_curr
          #LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14t,oeb24* CAST(oeb13*oeb1006/100 AS DECIMAL(20,",t_azi03,"))", #TQC-C90025 mark
          LET l_sql = " SELECT oeb04,oeb05,oeb916,oeb14,oeb24,oeb13,oeb1006,oeb12",                                   #TQC-C90025 add
                 #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ",
                 " FROM ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102  
                 " WHERE oeb01='",l_oea01 CLIPPED,"'",
                 " AND oeb70='N' "   
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
         CALl cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980091
         PREPARE t64_pre_1 FROM l_sql
         IF SQLCA.SQLCODE <> 0 THEN
            #CALL cl_err('pre t61',SQLCA.SQLCODE,1) #TQC-C90025 mark
            CALL cl_err('pre t64',SQLCA.SQLCODE,1)  #TQC-C90025 add
         END IF
         DECLARE t64_cur_1 CURSOR FOR t64_pre_1
         LET l_amt = 0
         LET pab_amt = 0 
         #FOREACH t64_cur_1 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_amt3                          #TQC-C90025 mark
         FOREACH t64_cur_1 INTO l_oeb04,l_oeb05,l_oeb916,l_amt2,l_amt3,l_oeb13,l_oeb1006,l_oeb12 #TQC-C90025 add
            IF l_amt2 IS NULL THEN LET l_amt2 = 0 END IF
            #TQC-C90025 add start -----
            IF l_oeb24 = l_oeb12 THEN
               LET l_amt3 = l_amt2
            ELSE
               LET l_amt3 = l_oeb24 * cl_digcut((l_oeb13*l_oeb1006/100),t_azi03)
            #TQC-C90025 add end   ----- 
              IF l_amt3 IS NULL THEN LET l_amt3 = 0 END IF
              IF cl_null(l_oeb916) THEN
                 LET l_oeb916 = l_oeb05
              END IF 
              CALL s_umfchk(l_oeb04,l_oeb05,l_oeb916) RETURNING l_num,l_factor
              IF l_num = 1 THEN LET l_factor = 1 END IF
              LET l_amt3 = l_amt3 * l_factor
            END IF #TQC-C90025 add
            LET l_amt = l_amt + l_amt2
            LET pab_amt = pab_amt + l_amt3
         END FOREACH
         LET l_no=l_oea01
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
         LET pab_amt = cl_digcut(pab_amt,t_azi04)  #MOD-B70221 add
         LET l_amt = l_amt*(1+l_oea211/100)        #含稅金額 #TQC-C90025 add 
         LET l_amt = cl_digcut(l_amt,t_azi04)                #TQC-C90025 add

         #計算出貨通知單量
         LET ifb_amt =0
       IF cl_null(p_slip) THEN        #TQC-970038  
         LET l_sql = "SELECT SUM(ogb14t)",
                     #"  FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file, ",
                     #"       ",s_dbstring(l_azp03_tra CLIPPED),"ogb_file ",
                     "  FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                     "   ,   ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                     " WHERE oga01=ogb01",
                     "   AND oga09 IN ('1','5') ",
                     "   AND ogb31='",l_oea01,"'",
#MOD-B80027 -- begin --
                     "   AND ogb31||ogb32 IN (SELECT oeb01||oeb03 FROM ",cl_get_target_table(g_plant_new,'oeb_file'),
                     "                        WHERE oeb01='",l_oea01,"' AND oeb70='N')",
#MOD-B80027 -- end --
                     "   AND oga55 IN ('1','S')"   #No.MOD-640569
      ELSE
         LET l_sql = "SELECT SUM(ogb14t)",                
                     #"  FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file, ", 
                     #"       ",s_dbstring(l_azp03_tra CLIPPED),"ogb_file ", 
                     "  FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102 
                     "   ,   ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102 
                     " WHERE oga01=ogb01",
                     "   AND oga09 IN ('1','5') ",
                     "   AND ogb31='",l_oea01,"'",
#MOD-B80027 -- begin --
                     "   AND ogb31||ogb32 IN (SELECT oeb01||oeb03 FROM ",cl_get_target_table(g_plant_new,'oeb_file'),
                     "                        WHERE oeb01='",l_oea01,"' AND oeb70='N')",
#MOD-B80027 -- end --
                     "   AND (oga55 MATCHES '[1S]' OR oga01 = '",p_slip,"')"     	
      END IF  	
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-980091
         PREPARE t64_pre2 FROM l_sql
         IF SQLCA.SQLCODE <> 0 THEN
             CALL cl_err('pre t64_pre2',SQLCA.SQLCODE,1)
         END IF
         DECLARE t64_curs2 CURSOR FOR t64_pre2
         OPEN t64_curs2
         FETCH t64_curs2 INTO ifb_amt
 
         IF cl_null(ifb_amt) THEN LET ifb_amt=0 END IF
         LET ifb_amt = ifb_amt - pab_amt   #出貨通知單金額-已出貨金額
         IF ifb_amt < 0 THEN LET ifb_amt = 0 END IF
         #訂單未出貨金額=訂單金額-已出貨金額-出貨通知單金額(扣除已出貨)
         LET l_amt = l_amt - pab_amt - ifb_amt
         IF l_amt <= 0 THEN CONTINUE FOREACH END IF
 
        IF l_occ631=g_curr THEN
           LET l_tmp = l_amt
        ELSE
           IF l_oaz211 = '1' THEN
              LET l_tmp = l_amt*l_oea24
           ELSE
              LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
              LET l_tmp = l_amt * g_exrate
           END IF
           IF l_occ631 <> l_aza17 THEN
              LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
              LET l_tmp = l_tmp*g_exrate  
           END IF
        END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg10/100 	#MOD-990029 
 
   	LET l_type = cl_getmsg('axm-218',g_lang)
        LET l_tmp=l_tmp * -1
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg10,0,'8')   #No.FUN-630086
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc9",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t64=l_t64+l_tmp
       END FOREACH
    END FOR
    RETURN l_t64
END FUNCTION
 
#-(9)Shipping Notice----------------------#
# 多工廠出貨通知單                        #
#-----------------------------------------#
FUNCTION cal_t66(p_occ01,p_slip,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          p_slip  LIKE oga_file.oga01,    #No.FUN-680137 VARCHAR(10)   #MOD-9C0366 faj02 modify oga01
          l_t66,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,    #日期   #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,           #No.FUN-680137 SMALLINT
          l_sql       STRING,                        #MOD-9C0029 
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02,  #No.FUN-630086   #No.FUN-680137 VARCHAR(10)
          l_tmp2      LIKE oma_file.oma57,   #MOD-8C0094
          ifb_tot,pab_tot   LIKE oea_file.oea61,   #MOD-8C0094
          ifb_tot2,pab_tot2   LIKE oea_file.oea61,  #MOD-8C0094
          l_amt2      LIKE oma_file.oma57,  #MOD-8C0094
          l_curr      LIKE azi_file.azi01,  #MOD-8C0094
          l_oga24     LIKE oga_file.oga24   #MOD-8C0094
 
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 8"
    PREPARE t66_poch FROM l_sql
    DECLARE t66_och CURSOR FOR t66_poch
 
    LET l_j = 1
 
    FOREACH t66_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t66_och:',SQLCA.sqlcode,1) 
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t66=0
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()               #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra       #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006 
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102  
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t66_pre FROM l_sql
        DECLARE aza_t66_cur CURSOR FOR aza_t66_pre
        OPEN aza_t66_cur 
        FETCH aza_t66_cur INTO l_aza17
        CLOSE aza_t66_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102    
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t66_pre FROM l_sql
        DECLARE oaz_t66_cur CURSOR FOR oaz_t66_pre
        OPEN oaz_t66_cur
        FETCH oaz_t66_cur INTO l_oaz211,l_oaz212
      ##出貨通知單信用額度改用訂單角度去看, 因為出貨單可併出貨通知單出貨
      ##所以無法一對一的角度看出貨通知單出貨沒
      LET l_sql=" SELECT oea01,oea02,oea23 ",
                #" FROM ",s_dbstring(l_azp03 CLIPPED),"oea_file, ", #FUN-930006
                #"      ",s_dbstring(l_azp03 CLIPPED),"oeb_file",   #FUN-930006    
                #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oea_file, ",
                #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file",
                " FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102    
                "    , ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102    
                " WHERE oea03='",p_occ01,"' ",
                " AND oea01=oeb01 ",
                " AND oeaconf='Y' AND oea00 IN ('1','4','5')" ,
                " AND oeb70='N' ",   #不含已結案
                " GROUP BY oea01,oea02,oea23 "
 
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
      CALl cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-980091
      PREPARE t66_pre FROM l_sql
      IF SQLCA.SQLCODE <> 0 THEN
         CALL cl_err('pre t66',SQLCA.SQLCODE,1)
      END IF
      DECLARE t66_curs CURSOR FOR t66_pre
      FOREACH t66_curs INTO l_oea01,l_date,l_curr
        LET l_no = l_oea01
        LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
                    #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file, ",
                    #"      ",s_dbstring(l_azp03_tra CLIPPED),"ogb_file, ",
                    #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ",
                    " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                    "    , ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                    "    , ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                    "  WHERE ogb31 ='",l_oea01,"'",
                    "    AND oga01 = ogb01 ",
                    "    AND ogaconf='Y' ",
                    "    AND ogapost='Y' ", 
                    "    AND oga09 IN ('2','3','4','6','8') ",                         #CHI-8C0028
                    "    AND ogb31 = oeb01 ",
                    "    AND ogb32 = oeb03 ",
                    "    AND oeb70 = 'N' ",
                    "    GROUP BY oga23,oga24 "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-980091
        PREPARE t66_pab_pre FROM l_sql
        DECLARE t66_pab_cur CURSOR FOR t66_pab_pre
        LET pab_tot = 0
        LET pab_tot2 = 0
        FOREACH t66_pab_cur INTO g_curr,l_oga24,pab_amt
           IF l_occ631=g_curr THEN
              LET l_tmp = pab_amt
           ELSE
              IF l_oaz211 = '1' THEN
                 LET l_tmp = pab_amt*l_oga24
              ELSE
                 LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
                 LET l_tmp = pab_amt * g_exrate
              END IF
              IF l_occ631 <> l_aza17 THEN
                 LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
                 LET l_tmp = l_tmp*g_exrate
              END IF
           END IF
           LET l_tmp2 = l_tmp
           LET pab_tot2 = pab_tot2 + l_tmp2
           LET l_tmp= l_tmp * g_ocg.ocg09/100
           LET pab_tot = pab_tot + l_tmp
        END FOREACH
        LET l_sql = " SELECT oga23,oga24,SUM(ogb14t) ",
                    #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oga_file, ",
                    #"      ",s_dbstring(l_azp03_tra CLIPPED),"ogb_file, ",
                    #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ",
                    " FROM ",cl_get_target_table(g_plant_new,'oga_file'), #FUN-A50102
                    "    , ",cl_get_target_table(g_plant_new,'ogb_file'), #FUN-A50102
                    "    , ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102
                    "  WHERE ogb31 ='",l_oea01,"'",
                    "    AND oga01 = ogb01 ",
                    "    AND oga09 IN ('1','5') ",
                    "    AND ogb31 = oeb01 ",
                    "    AND ogb32 = oeb03 ",
                    "    AND oeb70 = 'N' "
        IF cl_null(p_slip) THEN
           LET l_sql = l_sql CLIPPED,
                       " AND oga55 IN ('1','S') ",
                       " GROUP BY oga23,oga24 "
        ELSE
           LET l_sql = l_sql CLIPPED,
                       " AND ( oga55 IN ('1','S') ",
                       "     OR oga01 = '",p_slip,"' ) ",
                       " GROUP BY oga23,oga24 "
        END IF
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALl cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql  #FUN-980091
        PREPARE t66_ifb_pre FROM l_sql
        DECLARE t66_ifb_cur CURSOR FOR t66_ifb_pre
        LET ifb_tot = 0
        LET ifb_tot2= 0
        FOREACH t66_ifb_cur INTO g_curr,l_oga24,ifb_amt
           IF l_occ631=g_curr THEN
              LET l_tmp = ifb_amt
           ELSE
              IF l_oaz211 = '1' THEN
                 LET l_tmp = ifb_amt*l_oga24
              ELSE
                 LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
                 LET l_tmp = ifb_amt * g_exrate
              END IF
              IF l_occ631 <> l_aza17 THEN
                 LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
                 LET l_tmp = l_tmp*g_exrate
              END IF
           END IF
           LET l_tmp2 = l_tmp
           LET ifb_tot2 = ifb_tot2 + l_tmp2
           LET l_tmp= l_tmp * g_ocg.ocg09/100
           LET ifb_tot = ifb_tot + l_tmp
        END FOREACH
        LET l_amt2 = ifb_tot2 - pab_tot2
        LET l_amt = ifb_tot - pab_tot   #出貨通知單金額-已出貨金額
        IF l_amt2<= 0 THEN CONTINUE FOREACH END IF
        IF l_amt <= 0 THEN CONTINUE FOREACH END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
       #LET l_amt2 = l_amt2*g_exrate #MOD-B20126 mark
 
        LET l_type = cl_getmsg('axm-219',g_lang)
        LET l_amt2=l_amt2 * -1
        LET l_amt2 = cl_digcut(l_amt2,t_azi04)              #No.CHI-910034
        LET l_amt=l_amt * -1 #MOD-B20126 add
        LET l_amt = cl_digcut(l_amt,t_azi04) #MOD-B20126 add
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,l_curr,
                                   #l_amt2,g_ocg.ocg09,0,'9') #MOD-B20126 mark
                                    l_amt,g_ocg.ocg09,0,'9')  #MOD-B20126
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc10",0)   
           EXIT FOREACH
        END IF
       LET l_t66=l_t66+l_amt
      END FOREACH
    END FOR
    RETURN l_t66
END FUNCTION
#-(10)(A)--------------------------------#
# 多工廠應收逾期帳計算 by ERIC 98-06-24 #
#---------------------------------------#
FUNCTION cal_t65(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          l_t65,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oma01     LIKE oma_file.oma01,
          l_oob09     LIKE oob_file.oob09,
          l_oob10     LIKE oob_file.oob10,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_sql1      STRING,                       #MOD-9C0029 
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_today     LIKE type_file.dat,           #No.FUN-680137 DATE
          l_oob06     LIKE oob_file.oob06,
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_oma11     LIKE oma_file.oma11,
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086 #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 10"
    PREPARE t65_poch FROM l_sql
    DECLARE t65_och CURSOR FOR t65_poch
 
    LET l_j = 1
 
    FOREACH t65_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t65_och:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
# 逾期金額 = t62應收帳款中已逾期之金額 - t55應收沖帳未確認中已逾期之金額
    LET l_t65=0
    LET l_today=TODAY-l_occ36
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()             #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra     #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102    
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t65_pre FROM l_sql
        DECLARE aza_t65_cur CURSOR FOR aza_t65_pre
        OPEN aza_t65_cur 
        FETCH aza_t65_cur INTO l_aza17
        CLOSE aza_t65_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t65_pre FROM l_sql
        DECLARE oaz_t65_cur CURSOR FOR oaz_t65_pre
        OPEN oaz_t65_cur
        FETCH oaz_t65_cur INTO l_oaz211,l_oaz212
       #應收已沖帳未確認金額
       LET l_sql1=" SELECT SUM(oob09),SUM(oob10) ",
                  #" FROM ",s_dbstring(l_azp03 CLIPPED),"oob_file,",  #FUN-930006 
                  #         s_dbstring(l_azp03 CLIPPED),"ooa_file,",  #FUN-930006 
                  #         s_dbstring(l_azp03 CLIPPED),"oma_file,",  #FUN-930006 
                  #         s_dbstring(l_azp03 CLIPPED),"omc_file",   #CHI-980048 
                  " FROM ",cl_get_target_table(g_plant_new,'oob_file'),",", #FUN-A50102 
                           cl_get_target_table(g_plant_new,'ooa_file'),",", #FUN-A50102 
                           cl_get_target_table(g_plant_new,'oma_file'),",", #FUN-A50102 
                           cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                 " WHERE ooa03='",p_occ01,"' AND ooaconf='N' " ,
                 " AND oob04 = '1'  AND oob03='2' AND ooa01=oob01 ",
                 " AND oob09>0",
                 " AND oma01 = oob06",
                 " AND oma01 = omc01 AND oob19=omc02 AND omc04<'",l_today,"'",		#CHI-980048
                 " AND oma01 = ? "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t65_pre2 FROM l_sql1
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre2 t65',SQLCA.SQLCODE,1) 
       END IF
       DECLARE t65_curs2 CURSOR FOR t65_pre2
 
       IF g_ooz.ooz07 = 'N' THEN                                                                                                    
          LET l_sql=" SELECT omc01,SUM(omc08-omc10),SUM(omc09-omc11),oma23,oma11 ",	#CHI-980048
                    #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file,", #FUN-930006                                                                          
                    #          s_dbstring(l_azp03 CLIPPED),"omc_file",     		#CHI-980048
                    "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),",", #FUN-A50102 
                              cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                    " WHERE oma03='",p_occ01,"'",                                                                                   
                    "  AND omc04 <'",l_today,"' ",					#CHI-980048
                    "  AND omc01 = oma01 AND omc08 > omc10 ",  				#CHI-980048 
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       ELSE                                                                                                                         
          LET l_sql=" SELECT omc01,SUM(omc08-omc10),SUM(omc13),oma23,oma11 ",		#CHI-980048	
                    #"  FROM ",s_dbstring(l_azp03 CLIPPED),"oma_file,",  #FUN-930006                                                                         
                    #          s_dbstring(l_azp03 CLIPPED),"omc_file",     		#CHI-980048
                    "  FROM ",cl_get_target_table(g_plant_new,'oma_file'),",", #FUN-A50102 
                              cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
                    " WHERE oma03='",p_occ01,"'",                                                                                   
                    "  AND omc04 <'",l_today,"' ",					#CHI-980048
                    "  AND omc01 = oma01 AND omc08 > omc10 ",  				#CHI-980048 
                    " AND omaconf='Y' AND oma00 LIKE '1%'"                                                                          
       END IF                                                                                                                       
       LET l_sql = l_sql CLIPPED," GROUP BY omc01,oma23,oma11 "	#CHI-980048
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t65_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t65',SQLCA.SQLCODE,1)
       END IF
       DECLARE t65_curs CURSOR FOR t65_pre
       FOREACH t65_curs INTO l_oma01,l_amt,ntd_amt,g_curr,l_date
         LET l_no=l_oma01
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         #需扣除已沖帳未確認金額
         LET l_oob09=0  LET l_oob10=0
         OPEN t65_curs2 USING l_oma01
         IF SQLCA.SQLCODE THEN
            LET l_oob09=0  LET l_oob10=0
         END IF
         FETCH t65_curs2 INTO l_oob09,l_oob10
         IF cl_null(l_oob09) THEN LET l_oob09=0 END IF
         IF cl_null(l_oob10) THEN LET l_oob10=0 END IF
         LET l_amt=l_amt-l_oob09
         LET ntd_amt=ntd_amt-l_oob10
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
 
   	LET l_type = cl_getmsg('axm-210',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,0,0,'A')
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc11",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t65=l_t65+l_tmp
       END FOREACH
    END FOR
    RETURN l_t65
END FUNCTION
 
#-(11)(C)--------------------------------#
# 多工廠逾期未兌現應收票據計算 010404 add#
#----------------------------------------#
FUNCTION cal_t70(p_occ01,p_occ61)
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61 LIKE occ_file.occ61,
          l_t70,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_today     LIKE type_file.dat,           #No.FUN-680137 DATE
          l_oob06     LIKE oob_file.oob06,
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_oma11     LIKE oma_file.oma11,
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086  #No.FUN-680137 VARCHAR(10)
 
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 11"
    PREPARE t70_poch FROM l_sql
    DECLARE t70_och CURSOR FOR t70_poch
 
    LET l_j = 1
 
    FOREACH t70_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t70_och:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t70=0
    LET l_today=TODAY-l_occ36
    FOR l_i = 1 TO l_j   #No.FUN-630086
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
       SELECT azp03 INTO l_azp03           # DATABASE ID
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()            #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra    #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006
                  "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102 
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t70_pre FROM l_sql
        DECLARE aza_t70_cur CURSOR FOR aza_t70_pre
        OPEN aza_t70_cur 
        FETCH aza_t70_cur INTO l_aza17
        CLOSE aza_t70_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file", #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102  
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t70_pre FROM l_sql
        DECLARE oaz_t70_cur CURSOR FOR oaz_t70_pre
        OPEN oaz_t70_cur
        FETCH oaz_t70_cur INTO l_oaz211,l_oaz212
 
       LET l_sql=" SELECT nmh02,nmh32,nmh03,nmh01,nmh05 ",
                 #"   FROM ",s_dbstring(l_azp03 CLIPPED),"nmh_file", #FUN-930006 
                 "   FROM ",cl_get_target_table(g_plant_new,'nmh_file'), #FUN-A50102  
                 " WHERE nmh11='", p_occ01,"'",
                 "   AND nmh24 IN ('1','2','3','4') ",
                 "   AND nmh05 < '",l_today,"' ",
                 "   AND nmh38 ='Y' "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE t70_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t70',SQLCA.SQLCODE,1) 
       END IF
       DECLARE t70_curs CURSOR FOR t70_pre
       FOREACH t70_curs INTO l_amt,ntd_amt,g_curr,l_no,l_date
         IF l_amt IS NULL THEN LET l_amt = 0 END IF
         IF ntd_amt IS NULL THEN LET ntd_amt = 0 END IF
         IF l_occ631=g_curr THEN
            LET l_tmp = l_amt
         ELSE
            IF l_oaz211 = '1' THEN
               LET l_tmp = ntd_amt
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = l_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate  
            END IF
         END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
 
   	LET l_type = cl_getmsg('axm-209',g_lang)
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES (l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,0,0,'C')
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_ccc12",0)   #No.FUN-660167
           EXIT FOREACH
        END IF
        LET l_t70=l_t70+l_tmp
       END FOREACH
    END FOR
    RETURN l_t70
END FUNCTION
 
FUNCTION q210_check_exrate(p_occ631)
  DEFINE p_occ631    LIKE occ_file.occ631
  DEFINE p_exrate    LIKE azk_file.azk03 #FUN-4B0050
 
        #換算額度客戶幣別匯率
        IF p_occ631 = g_occ631 THEN
           LET p_exrate = 1
        ELSE
           LET p_exrate=s_exrate_m(p_occ631,g_occ631,g_oaz.oaz212,'') #FUN-640215 add ''
        END IF
        IF cl_null(p_exrate) THEN LET p_exrate = 1 END IF
        RETURN p_exrate
END FUNCTION
 
#-(D)--Borrow --------------------------#
# 借貨金額 By Nicola 07-05-08           #
#---------------------------------------#
 FUNCTION cal_t67(p_occ01,p_occ61,p_slip)  #TQC-970038
   DEFINE l_aza17     LIKE aza_file.aza17  #FUN-640215 add
   DEFINE l_oaz211    LIKE oaz_file.oaz211 #FUN-640215 add
   DEFINE l_oaz212    LIKE oaz_file.oaz212 #FUN-640215 add
   DEFINE p_occ01 LIKE occ_file.occ01,
          p_occ61     LIKE occ_file.occ61,
          l_t67,l_tmp LIKE oma_file.oma57,
          ntd_amt     LIKE oma_file.oma57,
          l_amt       LIKE oma_file.oma57,
          l_oea01     LIKE oea_file.oea01,
          l_oea211    LIKE oea_file.oea211,
          oea_amt     LIKE oea_file.oea61,
          ifb_amt     LIKE oea_file.oea61,
          pab_amt     LIKE oea_file.oea61,
          l_oea24     LIKE oea_file.oea24,
          l_date      LIKE type_file.dat,    #日期  #No.FUN-680137 DATE
          l_no        LIKE oma_file.oma01,   #單號
          l_i         LIKE type_file.num5,          #No.FUN-680137 SMALLINT
          l_sql       STRING,                       #MOD-9C0029 
          l_azp03     LIKE azp_file.azp03,
          l_azp03_tra LIKE azp_file.azp03, #FUN-980091
          l_j         LIKE type_file.num5,     #No.FUN-630086        #No.FUN-680137 SMALLINT
          l_plant     DYNAMIC ARRAY OF LIKE faj_file.faj02   #No.FUN-630086 #No.FUN-680137 VARCHAR(10)
   DEFINE p_slip      LIKE oga_file.oga01    #TQC-970038
   
    SELECT occ631 INTO l_occ631 FROM occ_file WHERE occ01 = p_occ01
 
    LET l_sql = "SELECT och03 FROM och_file",
                " WHERE och01 ='",p_occ61,"'",
                "   AND och02 = 9"
    PREPARE t67_poch FROM l_sql
    DECLARE t67_och CURSOR FOR t67_poch
 
    LET l_j = 1
 
    FOREACH t67_och INTO l_plant[l_j]
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach t67_och:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       LET l_j = l_j +1
 
    END FOREACH
 
    LET l_j = l_j - 1
    
    LET l_t67=0
    FOR l_i = 1 TO l_j
       IF cl_null(l_plant[l_i]) THEN CONTINUE FOR END IF
 
       SELECT azp03 INTO l_azp03
        FROM azp_file WHERE azp01=l_plant[l_i]
 
        LET g_plant_new = l_plant[l_i]
        #CALL s_gettrandbs()         #FUN-A50102
        #LET l_azp03_tra = g_dbs_tra #FUN-A50102
 
        LET l_sql =
                   #"SELECT aza17 FROM ",s_dbstring(l_azp03 CLIPPED),"aza_file", #FUN-930006
                   "SELECT aza17 FROM ",cl_get_target_table(g_plant_new,'aza_file'), #FUN-A50102   
                   " WHERE aza01 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE aza_t67_pre FROM l_sql
        DECLARE aza_t67_cur CURSOR FOR aza_t67_pre
        OPEN aza_t67_cur 
        FETCH aza_t67_cur INTO l_aza17
        CLOSE aza_t67_cur
       
        LET l_sql =
                   #"SELECT oaz211,oaz212 FROM ",s_dbstring(l_azp03 CLIPPED),"oaz_file",  #FUN-930006
                   "SELECT oaz211,oaz212 FROM ",cl_get_target_table(g_plant_new,'oaz_file'), #FUN-A50102  
                   " WHERE oaz00 = '0' "
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
        CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
        PREPARE oaz_t67_pre FROM l_sql
        DECLARE oaz_t67_cur CURSOR FOR oaz_t67_pre
        OPEN oaz_t67_cur
        FETCH oaz_t67_cur INTO l_oaz211,l_oaz212
 
      #借貨量為實際借貨量-已還數量-償價數量
    IF cl_null(p_slip) THEN   #TQC-970038        
      LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,",
                "        SUM((oeb12-oeb25-oeb29)*oeb13) ",
                #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oea_file, ",
                #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ",
                " FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102  
                "    , ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102  
                " WHERE oea03='",p_occ01,"' ",
                " AND oea01=oeb01 ",
                " AND oea00 = '8'" ,
                " AND oeb70='N' ",
                " AND oea49 IN ('1','S') ",
                " GROUP BY oea01,oea02,oea23,oea24,oea211 "
    ELSE
    LET l_sql=" SELECT oea01,oea02,oea23,oea24,oea211,",
                "        SUM((oeb12-oeb25-oeb29)*oeb13) ",
                #" FROM ",s_dbstring(l_azp03_tra CLIPPED),"oea_file, ", 
                #"      ",s_dbstring(l_azp03_tra CLIPPED),"oeb_file ", 
                " FROM ",cl_get_target_table(g_plant_new,'oea_file'), #FUN-A50102  
                "    , ",cl_get_target_table(g_plant_new,'oeb_file'), #FUN-A50102   
                " WHERE oea03='",p_occ01,"' ",
                " AND oea01=oeb01 ",
                " AND oea00 = '8'" ,
                " AND oeb70='N' ",
                " AND (oea49 MATCHES '[1S]' OR oea01 = '",p_slip,"') ",
                " GROUP BY oea01,oea02,oea23,oea24,oea211 "
    END IF  	
 
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql         #MOD-9C0316 add
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql   #FUN-980091
       PREPARE t67_pre FROM l_sql
       IF SQLCA.SQLCODE <> 0 THEN
          CALL cl_err('pre t67',SQLCA.SQLCODE,1)  
       END IF
       DECLARE t67_curs CURSOR FOR t67_pre
       FOREACH t67_curs INTO l_oea01,l_date,g_curr,l_oea24,l_oea211,
                             pab_amt
         LET l_no=l_oea01
         IF pab_amt IS NULL THEN LET pab_amt = 0 END IF
         LET pab_amt = pab_amt*(1+l_oea211/100)    #含稅金額
         IF l_occ631=g_curr THEN
            LET l_tmp = pab_amt
         ELSE
            IF g_oaz.oaz211 = '1' THEN
               LET l_tmp = pab_amt*l_oea24
            ELSE
               LET g_exrate=s_exrate_m(g_curr,l_aza17,l_oaz212,l_plant[l_i])
               LET l_tmp = pab_amt * g_exrate
            END IF
            IF l_occ631 <> l_aza17 THEN
               LET g_exrate=s_exrate_m(l_aza17,l_occ631,l_oaz212,l_plant[l_i])
               LET l_tmp = l_tmp*g_exrate
            END IF
        END IF
        #換算額度客戶幣別匯率
        CALL q210_check_exrate(l_occ631) RETURNING g_exrate
        #換算額度客戶幣別金額
        LET l_tmp = l_tmp*g_exrate
        LET l_tmp = l_tmp * g_ocg.ocg10/100	#MOD-990029
 
   	LET l_type = cl_getmsg('axm-146',g_lang)
        LET l_tmp=l_tmp * -1
        LET l_tmp = cl_digcut(l_tmp,t_azi04)              #No.CHI-910034
        INSERT INTO q210_ccc VALUES(l_plant[l_i],l_type,l_date,l_no,g_curr,
                                    l_tmp,g_ocg.ocg10,0,'D') 
        IF SQLCA.SQLCODE OR STATUS=100 THEN
           CALL cl_err3("ins","q210_ccc",l_plant[l_i],"",SQLCA.SQLCODE,"","ins q210_cccD",0)
           EXIT FOREACH
        END IF
        LET l_t67=l_t67+l_tmp
       END FOREACH
    END FOR
    RETURN l_t67
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 

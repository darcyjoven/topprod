# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aqcq552.4gl
# Descriptions...: FQC 品質記錄查詢(BY 料號 )
# Date & Author..: 99/04/18 By Iceman
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/02/01 By kim 報表轉XML功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: No.FUN-530065 05/04/04 By Anney 作業窗口不能用X關
# Modify.........: No.MOD-550092 05/05/12 By Mandy 一進入程式就會出現"lib-219"的錯誤訊息
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B0034 05/11/08 By Rosayu 品名規格調整
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQc-6C0227 07/01/05 By xufeng 結束和接下頁上方應為雙橫線
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750064 07/06/13 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850047 08/05/14 By lilingyu 改成CR報表
# Modify.........: No.FUN-850047 08/05/14 By lilingyu sr.desc改成sr.ze03
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60092 10/07/07 By lilingyu 平行工藝 
# Modify.........: No.TQC-B70178 11/08/03 By houlia sql長度不對調整為string
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:TQC-C90117 12/09/28 By chenjing Run Card 和工單單號增加開窗，單身"判定"顯示為名稱
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
       #wc			LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(600)
       	wc		        string,            #TQC-B70178	
	bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE 
	edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            qcm03               LIKE qcm_file.qcm03,  #工單編號
            qcm02               LIKE qcm_file.qcm02,  #工單編號
            qcm021              LIKE qcm_file.qcm021, #料件編號
            ima02               LIKE ima_file.ima02,  #料件名稱
            ima021              LIKE ima_file.ima021, #料件規格
           #-------------No.TQC-750064 modify
           #qcm06t              LIKE qcm_file.qcm06,  #檢驗量,
            qcm22t              LIKE qcm_file.qcm22,  #檢驗量,
           #-------------No.TQC-750064 end
            qtyt                LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)       #總不良數
            rat1                LIKE ngh_file.ngh10,       #No.FUN-680104 DECIMAL(3,0)     #不良率
            qcm091t             LIKE qcm_file.qcm091,      #入庫量
            lotcnt              LIKE type_file.num5,       #No.FUN-680104 SMALLINT       #批號
            qtycnt              LIKE type_file.num5,       #No.FUN-680104 SMALLINT      #不良批號
            rat2                LIKE ngh_file.ngh10        #No.FUN-680104 DECIMAL(3,0)     #批退量
        END RECORD,
    g_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
            qcm012              LIKE qcm_file.qcm012,    #FUN-A60092 add
            qcm05               LIKE qcm_file.qcm05,     #製程序
            sgm04               LIKE sgm_file.sgm04,      #作業編號
           #----------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,      #檢驗量
            qcm22              LIKE qcm_file.qcm22,     #檢驗量
            qcm091              LIKE qcm_file.qcm091,     #檢驗量
           #----------------No.TQC-750064 end
            qty                 LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)         #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
       #    desc                LIKE qcf_file.qcf062,      #No.FUN-680104 VARCHAR(4)              #判定 #TQC-C90117 mark
            desc                LIKE ze_file.ze03,         #TQC-C90117
            cr                  LIKE qcn_file.qcn07,       #No.FUN-680104 DECIMAL(15,3)           #CR
            ma                  LIKE qcn_file.qcn07,       #No.FUN-680104 DECIMAL(15,3)           #MA
            mi                  LIKE qcn_file.qcn07        #No.FUN-680104 DECIMAL(15,3)          #MI
        END RECORD,
    s_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
            qcm012              LIKE qcm_file.qcm012,     #FUN-A60092 add
            qcm05               LIKE qcm_file.qcm05,     #製程序
            sgm04               LIKE sgm_file.sgm04,      #作業編號
           #----------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,      #檢驗量
            qcm22              LIKE qcm_file.qcm22,     #檢驗量
            qcm091              LIKE qcm_file.qcm091,     #檢驗量
           #----------------No.TQC-750064 end
            qty                 LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)         #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
        #   desc                LIKE qcf_file.qcf062,      #No.FUN-680104 VARCHAR(4)          #判定   #TQC-C90117 mark
            desc                LIKE ze_file.ze03,         #TQC-C90117
            cr                  LIKE qcn_file.qcn07,       #No.FUN-680104 DECIMAL(15,3)         #CR
            ma                  LIKE qcn_file.qcn07,       #No.FUN-680104 DECIMAL(15,3)         #MA
            mi                  LIKE qcn_file.qcn07        #No.FUN-680104 DECIMAL(15,3)         #MI
        END RECORD,
 
    g_query_flag     LIKE type_file.num5,         #No.FUN-680104 SMALLINT #第一次進入程式時即進入Query之後進入next
    g_curr	     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
 #  g_sql            LIKE type_file.chr1000,      #WHERE CONDITION #No.FUN-680104 VARCHAR(1000)
    g_sql            string,      #TQC-B70178 
    g_rec_b          LIKE type_file.num5,         #單身筆數, #No.FUN-680104 SMALLINT
    g_argv1          LIKE sfb_file.sfb01,
    g_argv2          LIKE ogb_file.ogb04,
    m_qcm09          LIKE qcm_file.qcm09,
    m_qcm02          LIKE qcm_file.qcm02,
    m_qcm01          LIKE qcm_file.qcm01,
    l_qcm02          LIKE qcm_file.qcm02,
    l_qcm03          LIKE qcm_file.qcm03,
    l_qcm021         LIKE qcm_file.qcm021,
    m_no             LIKE type_file.num10,        #No.FUN-680104 INTEGER
    cr,ma,mi         LIKE qcn_file.qcn07          #No.FUN-680104 DEC(15,3)
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680104 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680104 SMALLINT
DEFINE   l_table         STRING                      #NO.FUN-850047
DEFINE   gg_sql          STRING                      #NO.FUN-850047
DEFINE   g_str           STRING                      #NO.FUN-850047
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0085
      DEFINE   l_sl,p_row,p_col   LIKE type_file.num5    #No.FUN-680104 SMALLINT #No.FUN-6A0085 
 
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
         
#NO.FUN-850047   --Begin--
   LET gg_sql ="qcm04.qcm_file.qcm04,", 
               "qcm03.qcm_file.qcm03,", 
               "qcm02.qcm_file.qcm02,", 
               "qcm021.qcm_file.qcm021,",                  
               "qcm22.qcm_file.qcm22,", 
               "qcm091.qcm_file.qcm091,",                  
               "ze03.ze_file.ze03,",                   
               "cr.qcn_file.qcn07,", 
               "ma.qcn_file.qcn07,", 
               "mi.qcn_file.qcn07,",                   
               "qcm05.qcm_file.qcm05,",                   
               "sgm04.sgm_file.sgm04,",                   
               "ima02.ima_file.ima02,", 
               "ima021.ima_file.ima021,",
               "qty.qcf_file.qcf32,",
               "qcm09.qcm_file.qcm09"                                 
              
   LET l_table = cl_prt_temptable('aqcq552',gg_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   LET gg_sql  = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"      
   PREPARE insert_prep FROM gg_sql
   IF  STATUS THEN
       CALL cl_err('insert_prep:',STATUS,1)
       EXIT PROGRAM
   END IF                                              
#NO.FUN-850047   --Begin--
         
    LET m_no=1
    LET g_curr = '1'
    LET g_query_flag=1
    LET g_argv1= ARG_VAL(1)
    LET g_argv2= ARG_VAL(2)
    LET p_row = 2 LET p_col = 3
    OPEN WINDOW q552_w AT p_row,p_col
      WITH FORM "aqc/42f/aqcq552"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

#FUN-A60092 --begin--
   IF g_sma.sma541 = 'Y' THEN 
      CALL cl_set_comp_visible("qcm012",TRUE)
   ELSE
  	  CALL cl_set_comp_visible("qcm012",FALSE)
   END IF 
#FUN-A60092 --end-- 
 
     LET g_action_choice = "query" #MOD-550092
    IF cl_chk_act_auth() OR NOT cl_null(g_argv1) THEN
       CALL q552_q()
    END IF
    CALL q552_menu()
    CLOSE WINDOW q552_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q552_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_qcm1.clear()
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INITIALIZE g_qcm.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME tm.wc ON qcm03,qcm02,qcm021
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(qcm021)
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ima"
            LET g_qryparam.state = "c"
            LET g_qryparam.default1 = g_qcm.qcm021
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO qcm021
            NEXT FIELD qcm021
     #TQC-C90117--add--start--
          WHEN INFIELD(qcm02)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_qcm02"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO qcm02
             NEXT FIELD qcm02
          WHEN INFIELD(qcm03)
             CALL cl_init_qry_var()
             LET g_qryparam.form = "q_qcm03"
             LET g_qryparam.state = "c"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO qcm03
             NEXT FIELD qcm03
     #TQC-C90117--add--end--
         OTHERWISE
            EXIT CASE
       END CASE
     #--
 
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
      MESSAGE ' WAIT '
      LET g_sql = "SELECT UNIQUE qcm03,qcm02,qcm021",
                   "  FROM qcm_file",
                   " WHERE qcm14='Y' AND qcm02 IS NOT NULL AND qcm02!=' ' ",
                   "   AND qcm18='2' AND ",tm.wc CLIPPED
   ELSE
      LET g_qcm.qcm02=g_argv1
      LET g_qcm.qcm021=g_argv2
      DISPLAY BY NAME g_qcm.qcm03,g_qcm.qcm02,g_qcm.qcm021
      LET g_sql = "SELECT UNIQUE qcm03,qcm02,qcm021",
                   "  FROM qcm_file",
                   " WHERE qcm02='",g_argv1 CLIPPED,"' ",
                   "   AND qcm14='Y' AND qcm021 = '",g_argv2 CLIPPED,"' ",
                   "   AND qcm18='2' AND qcm02 IS NOT NULL AND qcm02!=' ' "
   END IF
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
 
   LET g_sql = g_sql clipped," ORDER BY qcm02,qcm021 "
   PREPARE q552_prepare FROM g_sql
   DECLARE q552_cs SCROLL CURSOR WITH HOLD FOR q552_prepare
 
   IF NOT cl_null(g_argv1) THEN
      LET g_sql = "SELECT UNIQUE qcm03,qcm02,qcm021",
                  "  FROM qcm_file",
                  " WHERE qcm02='",g_argv1 CLIPPED,"' ",
                  "   AND qcm02 IS NOT NULL AND qcm02!=' ' AND qcm18='2' ",
                  "   AND qcm14='Y' AND qcm021 = '",g_argv2 CLIPPED,"' "
   ELSE
      LET g_sql = "SELECT UNIQUE qcm03,qcm02,qcm021",
                  "  FROM qcm_file",
                  " WHERE qcm14='Y' AND qcm02 IS NOT NULL AND qcm02!=' ' ",
                  "   AND qcm18='2' AND ",tm.wc CLIPPED
   END IF
   LET g_sql = "SELECT UNIQUE qcm03,qcm02,qcm021",
               "  FROM qcm_file ",
               " WHERE qcm14='Y' AND qcm02 IS NOT NULL AND qcm02!=' ' ",
               "   AND qcm18='2' AND ",tm.wc CLIPPED
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
 
   PREPARE q552_prepare1 FROM g_sql
   DECLARE q552_count CURSOR FOR q552_prepare1
END FUNCTION
 
#中文的MENU
FUNCTION q552_menu()
 
   WHILE TRUE
      CALL q552_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q552_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q552_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcm1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q552_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcm1.clear() #MOD-5A0169 add
    CALL q552_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_qcm.* TO NULL
        CLEAR FORM
        RETURN
    END IF
    OPEN q552_cs                      # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       LET m_cnt=0
       FOREACH q552_count INTO l_qcm03,l_qcm02,l_qcm021
          IF SQLCA.sqlcode THEN EXIT FOREACH END IF
          LET m_cnt=m_cnt+1
       END FOREACH
       LET g_row_count = m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
       CALL q552_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q552_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680104 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680104 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q552_cs INTO g_qcm.qcm03,g_qcm.qcm02,g_qcm.qcm021
        WHEN 'P' FETCH PREVIOUS q552_cs INTO g_qcm.qcm03,g_qcm.qcm02,g_qcm.qcm021
        WHEN 'F' FETCH FIRST    q552_cs INTO g_qcm.qcm03,g_qcm.qcm02,g_qcm.qcm021
        WHEN 'L' FETCH LAST     q552_cs INTO g_qcm.qcm03,g_qcm.qcm02,g_qcm.qcm021
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
          FETCH ABSOLUTE g_jump q552_cs INTO g_qcm.qcm03,g_qcm.qcm02,g_qcm.qcm021
          LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN CALL cl_err(' ',SQLCA.sqlcode,0)RETURN ELSE
        CASE p_flag
           WHEN 'F' LET g_curs_index = 1
           WHEN 'P' LET g_curs_index = g_curs_index - 1
           WHEN 'N' LET g_curs_index = g_curs_index + 1
           WHEN 'L' LET g_curs_index = g_row_count
           WHEN '/' LET g_curs_index = g_jump
        END CASE
 
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     END IF
    SELECT ima02,ima021 INTO g_qcm.ima02,g_qcm.ima021 FROM ima_file
       WHERE ima01=g_qcm.qcm021
 
        #------- CR
        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
         WHERE qcm03=g_qcm.qcm03 AND qcm02=g_qcm.qcm02 AND qcm021=g_qcm.qcm021
           AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
           WHERE qcm03=g_qcm.qcm03 AND qcm02=g_qcm.qcm02 AND qcm021=g_qcm.qcm021
             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
           WHERE qcm03=g_qcm.qcm03 AND qcm02=g_qcm.qcm02 AND qcm021=g_qcm.qcm021
             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
        #-------- 不良數總計
       #----------------No.TQC-750064 modify
       #LET g_qcm.qtyt=(cr*g_qcz.qcz02/g_qcz.qcz021)+
       #               (ma*g_qcz.qcz03/g_qcz.qcz031)+
       #               (mi*g_qcz.qcz04/g_qcz.qcz041)
 
       #SELECT count(*), sum(qcm06), sum(qcm091)
       #  INTO g_qcm.lotcnt, g_qcm.qcm06t, g_qcm.qcm091t
        SELECT count(*), sum(qcm22), sum(qcm091)
          INTO g_qcm.lotcnt, g_qcm.qcm22t, g_qcm.qcm091t
          FROM qcm_file
         WHERE qcm03=g_qcm.qcm03 AND qcm02=g_qcm.qcm02 AND qcm021=g_qcm.qcm021 AND qcm14='Y' AND qcm18='2'
 
        LET g_qcm.qtyt=g_qcm.qcm22t - g_qcm.qcm091t
       #IF g_qcm.qcm06t = 0 THEN      # 分母為零, 另作處理
	IF g_qcm.qcm22t = 0 THEN      # 分母為零, 另作處理
           LET g_qcm.rat1 = 0
	ELSE
          #LET g_qcm.rat1 = (g_qcm.qtyt/g_qcm.qcm06t)*100
           LET g_qcm.rat1 = (g_qcm.qtyt/g_qcm.qcm22t)*100
	END IF
       #----------------No.TQC-750064 end
        SELECT count(*) INTO g_qcm.qtycnt FROM qcm_file
         WHERE qcm03=g_qcm.qcm03 AND qcm02=g_qcm.qcm02 AND qcm021=g_qcm.qcm021
           AND qcm09 = '2' AND qcm14='Y' AND qcm18='2'
        IF g_qcm.lotcnt = 0 THEN      # 分母為零, 另作處理
           LET g_qcm.rat2 = 0
	ELSE
	   LET g_qcm.rat2 = (g_qcm.qtycnt/g_qcm.lotcnt)*100
	END IF
 
    CALL q552_show()
END FUNCTION
 
FUNCTION q552_show()
   DISPLAY BY NAME g_qcm.*
   CALL q552_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q552_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(1000)
          #l_ex      LIKE cqg_file.cqg08,          #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
          l_cho	    LIKE type_file.chr1,          #No.FUN-680104 VARCHAR(1)
          l_qcm01   LIKE qcm_file.qcm01
	
     LET l_sql =
       #------------No.TQC-750064 modify
       #"SELECT qcm04,qcm05,sgm04,qcm06,qcm22,0,0,qcm09,0,0,0,qcm01 ",
        "SELECT qcm04,qcm012,qcm05,sgm04,qcm22,qcm091,0,0,qcm09,0,0,0,qcm01 ", #FUN-A60092 add qcm012
       #------------No.TQC-750064 end
        " FROM  qcm_file LEFT OUTER JOIN sgm_file ON qcm03=sgm01 AND qcm05=sgm03 AND qcm021=sgm03_par",
        " AND sgm012 = qcm012",  #FUN-A60092 add
       " WHERE ",
        "  qcm021 = '",g_qcm.qcm021,"' ",
        " AND qcm02 = '",g_qcm.qcm02,"' ",
        " AND qcm03 = '",g_qcm.qcm03,"' ",
        " AND qcm14='Y' AND qcm18='2' ",
        " ORDER BY 1"
    PREPARE q552_pb FROM l_sql
    DECLARE q552_bcs CURSOR FOR q552_pb
    FOR g_cnt = 1 TO g_qcm1.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_qcm1[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q552_bcs INTO g_qcm1[g_cnt].*,l_qcm01
      #TQC-C90117--start--
        CASE g_qcm1[g_cnt].desc
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                    g_qcm1[g_cnt].desc
           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                    g_qcm1[g_cnt].desc
           WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                    g_qcm1[g_cnt].desc
        END CASE
      #TQC-C90117--end--
        #------- CR
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].cr FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
           AND qcm012=g_qcm1[g_cnt].qcm012   #FUN-A60092 add
        IF STATUS OR g_qcm1[g_cnt].cr IS NULL THEN LET g_qcm1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].ma FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
             AND qcm012=g_qcm1[g_cnt].qcm012   #FUN-A60092 add           
        IF STATUS OR g_qcm1[g_cnt].ma IS NULL THEN LET g_qcm1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].mi FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
             AND qcm012=g_qcm1[g_cnt].qcm012   #FUN-A60092 add           
       #------------No.TQC-750064 add
        LET g_qcm1[g_cnt].qty = g_qcm1[g_cnt].qcm22 - g_qcm1[g_cnt].qcm091
        IF g_qcm1[g_cnt].qcm22 = 0 THEN
           LET g_qcm1[g_cnt].rate = 0
        ELSE
           LET g_qcm1[g_cnt].rate = (g_qcm1[g_cnt].qty / g_qcm1[g_cnt].qcm22)*100
        END IF
       #------------No.TQC-750064 end
         LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         INITIALIZE g_qcm.* TO NULL  #TQC-6B0105
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_qcm1.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q552_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_qcm1 TO s_qcm1.* #MOD-5A0169 mark
   DISPLAY ARRAY g_qcm1 TO s_qcm1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-5A0169 add
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q552_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q552_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q552_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL q552_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL q552_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      #No.FUN-530065  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      #No.FUN-530065  --end
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION q552_out()
DEFINE l_sql        LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(1000)
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,         #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE cob_file.cob01,          #No.FUN-680104 VARCHAR(40)
    l_qcm01         LIKE qcm_file.qcm01,
    l_qcm09         LIKE qcm_file.qcm09,
    sr              RECORD
            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
            qcm03               LIKE qcm_file.qcm03,      #工單編號
            qcm02               LIKE qcm_file.qcm02,      #工單編號
            qcm021              LIKE qcm_file.qcm021,     #料品編號
            sgm04               LIKE sgm_file.sgm04,      #作業編號
            qcm05               LIKE qcm_file.qcm05,     #製程序
           #qcm06               LIKE qcm_file.qcm06,      #檢驗量    #No.TQC-750064 mark
            qcm22               LIKE qcm_file.qcm22,     #檢驗量
            qcm09               LIKE qcm_file.qcm09,     #檢驗量
            qcm091              LIKE qcm_file.qcm091,     #檢驗量
         #   desc               LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(4)  #判定  #NO.FUN-850047
            ze03                LIKE ze_file.ze03,          #NO.FUN-850047
            cr                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)     #CR
            ma                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)             #MA
            mi                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)           #MI
            qty                 LIKE qcf_file.qcf32,       #No.FUN-680104 DEC(15,3)        #不良率 
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
            ima02               LIKE ima_file.ima02,      #料件名稱
            ima021              LIKE ima_file.ima021     #料件規格
           ,qcm012              LIKE qcm_file.qcm012   #FUN-A60092 add 
        END RECORD
 
    CALL cl_wait()
    
#NO.FUN-850047  --Begin--
   # CALL cl_outnam('aqcq552') RETURNING l_name
    CALL cl_del_data(l_table)
    
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = 'aqcq552' 
#NO.FUN-850047  --End--    
 
    LET l_sql =
       #----------------No.TQC-750064 modify
       #"SELECT qcm04,qcm03,qcm02,qcm021,sgm04,qcm05,qcm06,qcm22,qcm09,",
        "SELECT qcm04,qcm03,qcm02,qcm021,sgm04,qcm05,qcm22,qcm09,",
       #----------------No.TQC-750064 end
        "       qcm091,qcm09,0,0,0,0,0,ima02,ima021,qcm012,qcm01 ",   #FUN-A60092 add qcm012
        " FROM  qcm_file LEFT OUTER JOIN sgm_file ON qcm03=sgm01 AND qcm05=sgm03 AND qcm021=sgm03_par",
        "  AND qcm012=sgm012",   #FUN-A60092 add
        " LEFT OUTER JOIN ima_file ON qcm021=ima01",
        " WHERE ",
        " qcm14='Y' AND qcm18='2' ",
        " ORDER BY 1"
    PREPARE q552_pb1 FROM l_sql
    DECLARE q552_bcs1 CURSOR FOR q552_pb1
#    START REPORT q552_rep TO l_name          #NO.FUN-850047
    FOREACH q552_bcs1 INTO sr.*,l_qcm01
        #------- CR
        SELECT SUM(qcn07) INTO sr.cr FROM qcm_file,qcn_file
         WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='2'
           AND qcm012=sr.qcm012   #FUN-A60092 add 
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO sr.ma FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='2'
             AND qcm012=sr.qcm012   #FUN-A60092 add            
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO sr.mi FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='2'
             AND qcm012=sr.qcm012   #FUN-A60092 add            
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
 
    #------------No.TQC-750064 modify
    #LET sr.qty=sr.cr*g_qcz.qcz02/g_qcz.qcz021+
    #           sr.ma*g_qcz.qcz03/g_qcz.qcz031+
    #           sr.mi*g_qcz.qcz04/g_qcz.qcz041
    #LET sr.rate=sr.qty/sr.qcm06*100
     LET sr.qty=sr.qcm22 - sr.qcm091
     LET sr.rate=sr.qty/sr.qcm22*100
    #------------No.TQC-750064 end
    # CASE sr.desc    #NO.FUN-850047
      CASE sr.ze03    #NO.FUN-850047
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
    #              sr.desc     #NO.FUN-850047
                   sr.ze03     #NO.FUN-850047
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
     #             sr.desc       #NO.FUN-850047
                   sr.ze03      #NO.FUN-850047
     #TQC-C90117--start--
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                   sr.ze03
     #TQC-C90117--end--
     END CASE
#NO.FUN-850047  --Begin--     
    #   OUTPUT TO REPORT q552_rep(sr.*)
    EXECUTE insert_prep USING 
            sr.qcm04,sr.qcm03,sr.qcm02,sr.qcm021,sr.qcm22,sr.qcm091,
            sr.ze03,sr.cr,sr.ma,sr.mi,sr.qcm05,sr.sgm04,sr.ima02,
            sr.ima021,sr.qty,sr.qcm09
   
    END FOREACH
#NO.FUN-850047  --End--
    
#NO.FUN-850047  --Begin--    
#    FINISH REPORT q552_rep
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
     LET gg_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'qcm03,qcm02,qcm021')
        RETURNING tm.wc
      ELSE
      	 LET tm.wc = ""
      END IF
     
     LET g_str = tm.wc
     
     CALL cl_prt_cs3('aqcq552','aqcq552',gg_sql,g_str) 	 
#NO.FUN-850047  --End--    
END FUNCTION
 
#NO.FUN-850047  --Begin--
#REPORT q552_rep(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#    l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#    sr              RECORD
#            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
#            qcm03               LIKE qcm_file.qcm03,      #工單編號
#            qcm02               LIKE qcm_file.qcm02,      #工單編號
#            qcm021              LIKE qcm_file.qcm021,     #料品編號
#            sgm04               LIKE sgm_file.sgm04,      #作業編號
#            qcm05              LIKE qcm_file.qcm05,     #製程序
#           #qcm06               LIKE qcm_file.qcm06,      #檢驗量   #No.TQC-750064 mark
#            qcm22              LIKE qcm_file.qcm22,     #檢驗量
#            qcm09              LIKE qcm_file.qcm09,     #檢驗量
#            qcm091             LIKE qcm_file.qcm091,     #檢驗量
#           desc                LIKE ze_file.ze03,         #No.FUN-680104 VARCHAR(4)           #判定
#            cr                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)        #CR
#            ma                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)         #MA
#            mi                  LIKE qcn_file.qcn07,       #No.FUN-680104 DEC(15,3)         #MI
#            qty                 LIKE qcf_file.qcf32,       #No.FUN-680104 DEC(15,3)         #不良率
#	    rate		LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)            #不良率
#            ima02               LIKE ima_file.ima02,       #料件名稱
#            ima021               LIKE ima_file.ima021      #料件規格
#        END RECORD,
#    sr1             RECORD                                 #列印會總
#           #---------No.TQC-750064 modify
#           #qcm06t              LIKE qcm_file.qcm06,  #檢驗量,
#            qcm22t              LIKE qcm_file.qcm22,  #檢驗量,
#           #---------No.TQC-750064 end
#            qtyt                LIKE qcn_file.qcn07,      #No.FUN-680104 DECIMAL(15,3)      #總不良數
#            rat1                LIKE ngh_file.ngh10,       #No.FUN-680104 DECIMAL(3,0)      #不良率
#            qcm091t             LIKE qcm_file.qcm091,      #入庫量
#            lotcnt              LIKE type_file.num5,       #No.FUN-680104 SMALLINT       #批號
#            qtycnt              LIKE type_file.num5,       #No.FUN-680104 SMALLINT      #不良批號
#            rat2                LIKE ngh_file.ngh10        #No.FUN-680104 DECIMAL(3,0)    #批退量
#        END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.qcm02,sr.qcm021
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED,pageno_total
#            PRINT
#            PRINT g_dash
#            PRINT COLUMN q552_getStartPos(38,39,g_x[18]),g_x[18]
#            PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+1]
#            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                           g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#            PRINTX name=H2 g_x[41],g_x[42],g_x[43],g_x[44],g_x[45],g_x[47] #TQC-5B0034
#                           #g_x[46],g_x[47] #TQC-5B0034 mark
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        BEFORE GROUP OF sr.qcm021
#              SKIP TO TOP OF PAGE
#
#        ON EVERY ROW
#            PRINTX name=D1 COLUMN g_c[31],sr.qcm04,
#                           COLUMN g_c[32],sr.qcm03,
#                           COLUMN g_c[33],sr.qcm02,
#                           COLUMN g_c[34],sr.qcm021,
#                          #-----------No.TQC-750064 modify
#                          #COLUMN g_c[35],cl_numfor(sr.qcm06,35,1),
#                          #COLUMN g_c[36],cl_numfor(sr.qcm22,36,1),
#                           COLUMN g_c[35],cl_numfor(sr.qcm22,35,1),
#                           COLUMN g_c[36],cl_numfor(sr.qcm091,36,1),
#                          #-----------No.TQC-750064 end
#                           COLUMN g_c[37],sr.desc,
#                           COLUMN g_c[38],cl_numfor(sr.cr,38,1),
#                           COLUMN g_c[39],cl_numfor(sr.ma,39,1),
#                           COLUMN g_c[40],cl_numfor(sr.mi,40,1)
#            PRINTX name=D2 COLUMN g_c[42],sr.qcm05,
#                           COLUMN g_c[44],sr.sgm04,
#                           COLUMN g_c[45],sr.ima02 CLIPPED,
#                           COLUMN g_c[47],sr.ima021 CLIPPED
#
#        AFTER GROUP OF sr.qcm021
#            LET sr1.qtyt=GROUP SUM(sr.qty)
#           #--------------No.TQC-750064 modify
#           #LET sr1.qcm06t=GROUP SUM(sr.qcm06)
#            LET sr1.qcm22t=GROUP SUM(sr.qcm22)
#           #IF sr1.qcm06t = 0 THEN      # 分母為零, 另作處理
#            IF sr1.qcm22t = 0 THEN      # 分母為零, 另作處理
#		           LET sr1.rat1 = 0
#            ELSE
#               #LET sr1.rat1 = (sr1.qtyt/sr1.qcm06t)*100
#              	LET sr1.rat1 = (sr1.qtyt/sr1.qcm22t)*100
#	          END IF
#           #--------------No.TQC-750064 end
#            LET sr1.qtycnt=GROUP COUNT(*) WHERE sr.qcm09='2'
#            LET sr1.lotcnt=GROUP COUNT(*)
#            IF sr1.lotcnt = 0 THEN      # 分母為零, 另作處理
#		           LET sr1.rat2 = 0
#            ELSE
#		           LET sr1.rat2 = (sr1.qtycnt/sr1.lotcnt)*100
#            END IF
#            PRINT
#            PRINT g_dash
#           #--------------No.TQC-750064 modify
#           #PRINT COLUMN 33, g_x[10] CLIPPED,GROUP SUM(sr.qcm06) USING '#########&',
#            PRINT COLUMN 33, g_x[10] CLIPPED,GROUP SUM(sr.qcm22) USING '#########&',
#           #--------------No.TQC-750064 end
#                  COLUMN 55, g_x[11] CLIPPED,GROUP SUM(sr.qty) USING '#########&',
#                  COLUMN 79, g_x[12] CLIPPED,sr1.rat1 USING '##&',
#                  COLUMN 95, g_x[13] CLIPPED,GROUP SUM(sr.qcm091) USING '#########&'
#            PRINT COLUMN 33, g_x[14] CLIPPED,GROUP COUNT(*) USING '#########&',
#                  COLUMN 55, g_x[15] CLIPPED,GROUP COUNT(*) WHERE sr.qcm09='2' USING '#########&',
#                  COLUMN 79, g_x[16] CLIPPED,sr1.rat2 USING '##&'
#
#        ON LAST ROW
#	    PRINT ""
#           #PRINT g_dash2   #No.TQC-6C0227
#            PRINT g_dash    #No.TQC-6C0227
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#               #PRINT g_dash2   #No.TQC-6C0227
#                PRINT g_dash    #No.TQC-6C0227
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
##NO.FUN-850047  --End--
# 
##NO.FUN-850047  --Begin--
##函式說明:算出一字串,位於數個連續表頭的中央位置
##l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
##傳回值 - 字串起始位置
#FUNCTION q552_getStartPos(l_sta,l_end,l_str)
#DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680104 SMALLINT
#DEFINE l_str STRING
#   LET l_str=l_str.trim()
#   LET l_length=l_str.getLength()
#   LET l_w_tot=0
#   FOR l_i=l_sta to l_end
#      LET l_w_tot=l_w_tot+g_w[l_i]
#   END FOR
#   LET l_pos=(l_w_tot/2)-(l_length/2)
#   IF l_pos<0 THEN LET l_pos=0 END IF
#   LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
#   RETURN l_pos
#END FUNCTION
##NO.FUN-850047  --End--
 

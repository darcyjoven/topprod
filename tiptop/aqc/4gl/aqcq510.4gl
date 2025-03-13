# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: aqcq510.4gl
# Descriptions...: PQC 品質履歷查詢
# Date & Author..: 98/05/20 By Iceman FOR TIPTOP 4.00
# Modify.........: No.MOD-4A0012 04/11/01 By Yuna 語言button沒亮
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/31 By kim 報表轉XML功能
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550063 05/05/19 By day   單據編號加大
# Modify.........: NO.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........: No.TQC-5B--34 05/11/08 by rosayu 品名規格調整
# Modify.........: NO.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/28 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQc-6C0227 07/01/05 By xufeng 結束和接下頁上方應為雙橫線
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850024 08/05/09 By Cockroach 報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60027 10/06/21 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
        bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
        edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcm  RECORD
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE  #檢驗時間起
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE  #檢驗時間止
            qcm22t              LIKE qcm_file.qcm22,  #檢驗量,
            qtyt                LIKE qcf_file.qcf32,         #No.FUN-680104 DECIMAL(15,3)
            rat1                LIKE ngh_file.ngh10,         #No.FUN-680104 DECIMAL(3,0)        #不良率
            qcm091t             LIKE qcm_file.qcm091,        #入庫量
            lotcnt              LIKE type_file.num5,         #No.FUN-680104 SMALLINT        #批號
            qtycnt              LIKE type_file.num5,         #No.FUN-680104 SMALLINT       #不良批號
            rat2                LIKE ngh_file.ngh10          #No.FUN-680104 DECIMAL(3,0)        #批退量
        END RECORD,
    g_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
            qcm02               LIKE qcm_file.qcm02,      #工單編號
            qcm012              LIKE qcm_file.qcm012,     #FUN-A60027   製程段  
            ecm04               LIKE ecm_file.ecm04,      #作業編號
            qcm05               LIKE qcm_file.qcm05,     #製程序號
            qcm021              LIKE qcm_file.qcm021,     #料件編號
            ima02               LIKE ima_file.ima02,      #料件名稱
            qcm22               LIKE qcm_file.qcm22,     #送驗量
            qcm091              LIKE qcm_file.qcm091,    #檢驗量,
            qty                 LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)         #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
            desc                LIKE qcf_file.qcf062,      #No.FUN-680104 VARCHAR(4)              #判定
            cr                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(15,3)
            ma                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(15,3)
            mi                  LIKE qcg_file.qcg07        #No.FUN-680104 DEC(15,3)
        END RECORD,
    s_qcm1 DYNAMIC ARRAY OF RECORD
            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
            qcm02               LIKE qcm_file.qcm02,      #工單編號
            qcm012              LIKE qcm_file.qcm012,     #FUN-A60027 製程段 
            ecm04               LIKE ecm_file.ecm04,      #作業編號
            qcm05               LIKE qcm_file.qcm05,      #制程序號
            qcm021              LIKE qcm_file.qcm021,     #料件編號
            ima02               LIKE ima_file.ima02,      #料件名稱
            qcm22               LIKE qcm_file.qcm22,     #送驗量
            qcm091              LIKE qcm_file.qcm091,    #檢驗量,
            qty                 LIKE qcf_file.qcf32,       #No.FUN-680104 DECIMAL(15,3)       #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
            desc                LIKE qcf_file.qcf062,      #No.FUN-680104 VARCHAR(4)         #判定
            cr                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(15,3)
            ma                  LIKE qcg_file.qcg07,       #No.FUN-680104 DEC(15,3) 
            mi                  LIKE qcg_file.qcg07        #No.FUN-680104 DEC(15,3)
        END RECORD,
    g_curr           LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    l_sql            LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(1000)
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    l_qcm01          LIKE qcm_file.qcm01,
    g_sql            LIKE type_file.chr1000,      #WHERE CONDITION #No.FUN-680104 VARCHAR(1000)
    g_rec_b          LIKE type_file.num5,               #單身筆數        #No.FUN-680104 SMALLINT
    cr,ma,mi         LIKE qcg_file.qcg07          #No.FUN-680104 DEC(15,3)
DEFINE   g_str           STRING
DEFINE   l_table         STRING 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
 
MAIN
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
 
 LET g_sql =          "qcm04.qcm_file.qcm04,",
                      "qcm02.qcm_file.qcm02,",
                      "ecm04.ecm_file.ecm04,",
                      "qcm05.qcm_file.qcm05,",
                      "qcm091.qcm_file.qcm091,",
                      "qty.qcf_file.qcf32,",
                      "desc1.ze_file.ze03,",
                      "cr.qcg_file.qcg07,",
                      "ma.qcg_file.qcg07,",
                      "mi.qcg_file.qcg07,",
                      "qcm22.qcm_file.qcm22,",
                      #"rate.cqu_file.cqu03,",   #TQC-B90211
                      "rate.type_file.num15_3,",   #TQC-B90211
                      "qcm021.qcm_file.qcm021,",
                      "ima02.ima_file.ima02,",
                      "ima021.ima_file.ima021,",
                      "qcm22t.qcm_file.qcm22,",
                      "qtyt.qcf_file.qcf32,",
                      "rat1.ngh_file.ngh10,",
                      "qcm091t.qcm_file.qcm091,",
                      "lotcnt.type_file.num5,",
                      "qtycnt.type_file.num5,",
                      "rat2.ngh_file.ngh10 "
 
   LET l_table = cl_prt_temptable('aqcq510',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF   
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time  

    LET g_curr = '1'

    OPEN WINDOW q510_w WITH FORM "aqc/42f/aqcq510"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    CALL cl_set_comp_visible("qcm012",g_sma.sma541 = 'Y')   #FUN-A60027  
 
    CALL q510_menu()
    CLOSE WINDOW q510_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION q510_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
   DISPLAY BY NAME tm.bdate,tm.edate
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032 
   INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
 
        AFTER FIELD bdate
                IF cl_null(tm.bdate) THEN CALL cl_err('','9046',0)
                   NEXT FIELD bdate END IF
        AFTER FIELD edate
                IF cl_null(tm.edate) THEN CALL cl_err('','9046',0)
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
   LET g_sql=" SELECT count(*) FROM qcm_file ",
          " WHERE qcm14='Y' AND qcm18='1' AND qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'"
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
 
   PREPARE q510_prepare1 FROM g_sql
   DECLARE q510_count CURSOR FOR q510_prepare1
END FUNCTION
 
 
#中文的MENU
FUNCTION q510_menu()
   WHILE TRUE
      CALL q510_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
                CALL q510_q()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
                CALL q510_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "CONTROLG"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcm1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION q510_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcm1.clear() #MOD-5A0169 add
    CALL q510_cs()
   #------------No.TQC-750064 modify
   #SELECT count(*), sum(qcm06), sum(qcm091)
   #         INTO g_qcm.lotcnt, g_qcm.qcm06t, g_qcm.qcm091t
    SELECT count(*), sum(qcm22), sum(qcm091)
           INTO g_qcm.lotcnt, g_qcm.qcm22t, g_qcm.qcm091t
   #------------No.TQC-750064 end
	     FROM qcm_file
             WHERE qcm04 BETWEEN tm.bdate AND tm.edate
               AND qcm14='Y' AND qcm18='1'
    IF SQLCA.sqlcode THEN
#      CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660115
       CALL cl_err3("sel","qcm_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660115
    ELSE
       OPEN q510_count
       FETCH q510_count INTO m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
        #------- CR
        SELECT SUM(qcn07) INTO cr FROM qcm_file,qcn_file
           WHERE qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO ma FROM qcm_file,qcn_file
           WHERE qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO mi FROM qcm_file,qcn_file
           WHERE qcm04 BETWEEN tm.bdate AND tm.edate
             AND qcm01=qcn01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
        #-------- 不良數總計
       #-----------------No.TQC-750064 modify
       #LET g_qcm.qtyt=(cr*g_qcz.qcz02/g_qcz.qcz021)+
       #               (ma*g_qcz.qcz03/g_qcz.qcz031)+
       #               (mi*g_qcz.qcz04/g_qcz.qcz041)
 
        LET g_qcm.qtyt=g_qcm.qcm22t - g_qcm.qcm091t
 
       #IF g_qcm.qcm06t = 0 THEN      # 分母為零, 另作處理
	IF g_qcm.qcm22t = 0 THEN      # 分母為零, 另作處理
	   LET g_qcm.rat1 = 0
	ELSE
          #LET g_qcm.rat1 = (g_qcm.qtyt/g_qcm.qcm06t)*100
           LET g_qcm.rat1 = (g_qcm.qtyt/g_qcm.qcm22t)*100
	END IF
       #-----------------No.TQC-750064 end
        SELECT count(*) INTO g_qcm.qtycnt FROM qcm_file
          WHERE qcm09='2' AND qcm04 BETWEEN tm.bdate AND tm.edate AND qcm14='Y' AND qcm18='1'
        IF g_qcm.lotcnt = 0 THEN      # 分母為零, 另作處理
           LET g_qcm.rat2 = 0
	ELSE
	   LET g_qcm.rat2 = (g_qcm.qtycnt/g_qcm.lotcnt)*100
	END IF
        CALL q510_show()                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q510_show()
   DISPLAY BY NAME g_qcm.*
   CALL q510_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q510_b_fill()              #BODY FILL UP
   DEFINE #l_ex      LIKE cqg_file.cqg08,       #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
          l_cho     LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(1)
          l_qcm01   LIKE qcm_file.qcm01        #No.FUN-550063
 
   LET l_sql =
       #------------------No.TQC-750064 modify
       #"SELECT qcm04,qcm02,ecm04,qcm05,qcm021,ima02,qcm06,qcm22,0,0,qcm09,0,0,0,",
        "SELECT qcm04,qcm02,qcm012,ecm04,qcm05,qcm021,ima02,qcm22,qcm091,0,0,qcm09,0,0,0,",    #FUN-A60027 add qcm012
       #------------------No.TQC-750064 end
	"       qcm01",
       #" FROM  qcm_file LEFT OUTER JOIN ecm_file ON qcm02=ecm01 AND qcm05=ecm03 LEFT OUTER JOIN ima_file ON qcm021=ima01",                         #FUN-A60027 mark
        " FROM  qcm_file LEFT OUTER JOIN ecm_file ON qcm02=ecm01 AND qcm05=ecm03 AND qcm012 = ecm012 LEFT OUTER JOIN ima_file ON qcm021=ima01",     #FUN-A60027
        " WHERE ",
        " qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
        " AND qcm14='Y' AND qcm18='1' ",
        " ORDER BY 1"
    PREPARE q510_pb FROM l_sql
    DECLARE q510_bcs CURSOR FOR q510_pb
 
    CALL g_qcm1.clear()
 
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q510_bcs INTO g_qcm1[g_cnt].*,l_qcm01
        #------- CR
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].cr FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR g_qcm1[g_cnt].cr IS NULL THEN LET g_qcm1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].ma FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR g_qcm1[g_cnt].ma IS NULL THEN LET g_qcm1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO g_qcm1[g_cnt].mi FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
       #------------No.TQC-750064 add
        LET g_qcm1[g_cnt].qty = g_qcm1[g_cnt].qcm22 - g_qcm1[g_cnt].qcm091
        IF g_qcm1[g_cnt].qcm22 = 0 THEN
           LET g_qcm1[g_cnt].rate = 0
        ELSE
           LET g_qcm1[g_cnt].rate = (g_qcm1[g_cnt].qty / g_qcm1[g_cnt].qcm22)*100
        END IF
       #------------No.TQC-750064 end
      LET g_cnt=g_cnt+1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_qcm1.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q510_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
    IF p_ud <> "G" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)

    DISPLAY ARRAY g_qcm1 TO s_qcm1.*  ATTRIBUTE(COUNT=g_rec_b)

      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-4A0012
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
      #END
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#     ON ACTION <F3>下頁
#        LET g_action_choice="<F3>下頁"
#     ON ACTION <F4>上頁
#        LET g_action_choice="<F4>上頁"
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
       #No.MOD-530688  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530688  --end
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION q510_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,         #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
    l_qcm09         LIKE qcm_file.qcm09,
    l_qcm01         LIKE qcm_file.qcm01,
    sr              RECORD
            qcm04               LIKE qcm_file.qcm04,      #檢驗日期
            qcm02               LIKE qcm_file.qcm02,      #工單編號
            ecm04               LIKE ecm_file.ecm04,      #作業編號
            qcm05               LIKE qcm_file.qcm05,      #製程序號
           #-------------No.TQC-750064 modify
           #qcm06               LIKE qcm_file.qcm06,      #檢驗量
            qcm091              LIKE qcm_file.qcm091,     #檢驗量
           #-------------No.TQC-750064 end
            qty                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3)          #不良率
            desc1               LIKE ze_file.ze03,        #No.FUN-680104 VARCHAR(4)            #判定
            cr                  LIKE qcg_file.qcg07,      #No.FUN-680104 DECIMAL(15,3)
            ma                  LIKE qcg_file.qcg07,      #No.FUN-680104 DECIMAL(15,3)
            mi                  LIKE qcg_file.qcg07,      #No.FUN-680104 DECIMAL(15,3)
            qcm22               LIKE qcm_file.qcm22,      #送驗量
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,       #No.FUN-680104 DECIMAL(6,2)          #不良率   #TQC-B90211
            qcm021              LIKE qcm_file.qcm021,     #料件編號
            ima02               LIKE ima_file.ima02,      #料件名稱
            ima021              LIKE ima_file.ima021      #料件規格
        END RECORD
 
    CALL cl_wait()
#    CALL cl_outnam('aqcq510') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
 #No.FUN-850024 --ADD START--
     CALL cl_del_data(l_table)
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",
               "        ?, ?                         )"                                                                                                         
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM                                                                                                                 
     END IF 
#No.FUN-850024 --ADD END--   
    
 
    LET l_sql =
       #--------------No.TQC-750064 modify
       #"SELECT qcm04,qcm02,ecm04,qcm05,qcm06,0,qcm09,0,0,0,qcm22,",
        "SELECT qcm04,qcm02,ecm04,qcm05,qcm091,0,qcm09,0,0,0,qcm22,",  
       #--------------No.TQC-750064 end
	"       0,qcm021,ima02,ima021,qcm01",
       #" FROM  qcm_file LEFT OUTER JOIN ecm_file ON qcm02=ecm01 AND qcm05=ecm03 LEFT OUTER JOIN ima_file ON qcm021=ima01",                      #FUN-A60027 mark 
        " FROM  qcm_file LEFT OUTER JOIN ecm_file ON qcm02=ecm01 AND qcm05=ecm03 AND qcm012 = ecm012 LEFT OUTER JOIN ima_file ON qcm021=ima01",  #FUN-A60027
        " WHERE ",
        " qcm04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
        " AND qcm14='Y' AND qcm18='1' ",
        " ORDER BY 1"
    PREPARE q510_pb1 FROM l_sql
    DECLARE q510_bcs1 CURSOR FOR q510_pb1
#    START REPORT q510_rep TO l_name       #No.FUN-850024 --mark--
    FOREACH q510_bcs1 INTO sr.*,l_qcm01
        #------- CR
        SELECT SUM(qcn07) INTO sr.cr FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='1' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qcn07) INTO sr.ma FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='2' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qcn07) INTO sr.mi FROM qcm_file,qcn_file
           WHERE qcm01=qcn01 AND qcm01=l_qcm01 AND qcn05='3' AND qcm14='Y' AND qcm18='1'
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
 
       #-----------------No.TQC-750064 mosify
       #LET sr.qty=sr.cr*g_qcz.qcz02/g_qcz.qcz021+
       #           sr.ma*g_qcz.qcz03/g_qcz.qcz031+
       #           sr.mi*g_qcz.qcz04/g_qcz.qcz041
       #LET sr.rate=sr.qty/sr.qcm06*100
        LET sr.qty=sr.qcm22 - sr.qcm091
        LET sr.rate=sr.qty/sr.qcm22*100
       #-----------------No.TQC-750064 end
        CASE sr.desc1
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                     sr.desc1
           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                     sr.desc1
        END CASE
#       OUTPUT TO REPORT q510_rep(sr.*)   #No.FUN-850024 --MARK--
#No.FUN-850024 --ADD START--
     EXECUTE  insert_prep  USING
     sr.qcm04,sr.qcm02,sr.ecm04,sr.qcm05,sr.qcm091,sr.qty,   
     sr.desc1,sr.cr,sr.ma,sr.mi,sr.qcm22,sr.rate,sr.qcm021,
     sr.ima02,sr.ima021,g_qcm.qcm22t,g_qcm.qtyt,g_qcm.rat1,
     g_qcm.qcm091t,g_qcm.lotcnt,g_qcm.qtycnt,g_qcm.rat2 
 
    END FOREACH
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   LET g_str = ''
   LET g_str = tm.bdate,";",tm.edate
   CALL cl_prt_cs3('aqcq510','aqcq510',l_sql,g_str)   
#No.FUN-850024 --ADD END--
#No.FUN-850024 --MARK START--
#    FINISH REPORT q510_rep
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-850024 --MARK END--
END FUNCTION
#No.FUN-850024 --MARK START--
#REPORT q510_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#   sr              RECORD
#           qcm04               LIKE qcm_file.qcm04,      #檢驗日期
#           qcm02               LIKE qcm_file.qcm02,      #工單編號
#           ecm04               LIKE ecm_file.ecm04,      #作業編號
#           qcm05               LIKE qcm_file.qcm05,      #製程序號
#          #-------------No.TQC-750064 modify
#          #qcm06               LIKE qcm_file.qcm06,      #檢驗量
#           qcm091              LIKE qcm_file.qcm091,     #檢驗量
#          #-------------No.TQC-750064 end
#           qty                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3)        #不良率
#           desc                LIKE ze_file.ze03,        #No.FUN-680104 VARCHAR(4) #判定
#           cr                  LIKE qcg_file.qcg07,      #No.FUN-680104 DECIMAL(15,3)
#           ma                  LIKE qcg_file.qcg07,      #No.FUN-680104 DECIMAL(15,3)
#           mi                  LIKE qcg_file.qcg07,      #No.FUN-680104 DECIMAL(15,3)
#           qcm22               LIKE qcm_file.qcm22,      #送驗量
#           rate		LIKE cqu_file.cqu03,      #No.FUN-680104 DECIMAL(6,2) #不良率
#           qcm021              LIKE qcm_file.qcm021,     #料件編號
#           ima02               LIKE ima_file.ima02,      #料件名稱
#           ima021              LIKE ima_file.ima021       #料件規格
#       END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qcm04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT g_dash
#           PRINT COLUMN q510_getStartPos(39,40,g_x[18]),g_x[18]
#           PRINT COLUMN g_c[39],g_dash2[1,g_w[39]+g_w[40]+1]
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35], #TQC-5B0034
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40],
#                 g_x[41]
#           PRINTX name=H2 g_x[42],g_x[43],g_x[44] #TQC-5B0034 add
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINTX name=D1 COLUMN g_c[31],sr.qcm04, #TQC-5B0034
#                 COLUMN g_c[32],sr.qcm02,
#                 COLUMN g_c[33],sr.qcm05 USING '###&', #FUN-590118
#                 COLUMN g_c[34],sr.ecm04 CLIPPED,
#                 COLUMN g_c[35],sr.qcm021 CLIPPED,
#                 COLUMN g_c[36],cl_numfor(sr.qcm22,36,1),
#                #--------------No.TQC-750064 modify
#                #COLUMN g_c[37],cl_numfor(sr.qcm06,37,1),
#                 COLUMN g_c[37],cl_numfor(sr.qcm091,37,1),
#                #--------------No.TQC-750064 end
#                 COLUMN g_c[38],sr.desc,
#                 COLUMN g_c[39],cl_numfor(sr.cr,39,1),
#                 COLUMN g_c[40],cl_numfor(sr.ma,40,1),
#                 COLUMN g_c[41],cl_numfor(sr.mi,41,1)
#           #PRINT COLUMN g_c[35],sr.ima02,' ',sr.ima021 #TQC-5B0034 mark
#           PRINTX name=D2 COLUMN g_c[43],sr.ima02 CLIPPED,COLUMN g_c[44],sr.ima021 CLIPPED #TQC-5B0034 add
#       ON LAST ROW
#           PRINT
#           PRINT g_dash
#          #----------------No.TQC-750064 modify
#          #PRINT COLUMN 33, g_x[10] CLIPPED,g_qcm.qcm06t USING '#########&',
#           PRINT COLUMN 33, g_x[10] CLIPPED,g_qcm.qcm22t USING '#########&',
#          #----------------No.TQC-750064 end
#                 COLUMN 55, g_x[11] CLIPPED,g_qcm.qtyt USING '#########&',
#                 COLUMN 79, g_x[12] CLIPPED,g_qcm.rat1 USING '##&',
#                 COLUMN 95, g_x[13] CLIPPED,g_qcm.qcm091t USING '#########&'
#           PRINT COLUMN 33, g_x[14] CLIPPED,g_qcm.lotcnt USING '#########&',
#                 COLUMN 55, g_x[15] CLIPPED,g_qcm.qtycnt USING '#########&',
#                 COLUMN 79, g_x[16] CLIPPED,g_qcm.rat2 USING '##&'
#          #PRINT g_dash2   #No.TQC-6C0227
#           PRINT g_dash    #No.TQC-6C0227
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#              #PRINT g_dash2   #No.TQC-6C0227
#               PRINT g_dash    #No.TQC-6C0227
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
 
##by kim 05/1/26
##函式說明:算出一字串,位於數個連續表頭的中央位置
##l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
##傳回值 - 字串起始位置
#FUNCTION q510_getStartPos(l_sta,l_end,l_str)
#DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680104 SMALLINT
#DEFINE l_str      STRING
#  LET l_str=l_str.trim()
#  LET l_length=l_str.getLength()
#  LET l_w_tot=0
#  FOR l_i=l_sta to l_end
#     LET l_w_tot=l_w_tot+g_w[l_i]
#  END FOR
#  LET l_pos=(l_w_tot/2)-(l_length/2)
#  IF l_pos<0 THEN LET l_pos=0 END IF
#  LET l_pos=l_pos+g_c[l_sta]+(l_end-l_sta)
#  RETURN l_pos
#END FUNCTION
#No.FUN-850024 --mark end--
#No.FUN-870144

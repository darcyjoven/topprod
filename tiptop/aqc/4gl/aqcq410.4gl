# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Descriptions...: FQC 品質履歷查詢
# Date & Author..: 98/05/16 By Iceman FOR TIPTOP 4.00
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0099 05/01/31 By kim 報表轉XML功能
# Modify.........: No.FUN-560255 05/06/28 By Mandy 在已MARK掉的BEFORE ROW段加CALL cl_show_fld_cont()是不對的,所以將CALL cl_show_fld_cont() MARK掉
# Modify.........: No.MOD-5A0169 05/10/14 By Rosayu 上、下筆時，單身資料會錯誤
# Modify.........:No.TQC-5B0034 05/11/08 By Rosayu 修改品名規格位置
# Modify.........: No.TQC-610007 06/01/06 By Nicola 接收ze值的欄位型能改為LIKE
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-740045 07/04/10 By pengu 檢驗結果為3時單身判定欄位應該是顯示"特採"而不是3
# Modify.........: NO.TQC-750041 07/05/10 BY ZHU 打印時，報表底部應是雙橫線
# Modify.........: No.TQC-750064 07/06/12 By pengu 拿掉單頭[檢驗量]欄位
# Modify.........: No.FUN-850013 08/05/07 By jan 報表改CR輸出
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-AB0086 10/11/10 By sabrina 不良率及批退率無法正常顯示。將rat1、rat2型態改成num20_6
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     tm  RECORD
        bdate                   LIKE type_file.dat,          #No.FUN-680104 DATE
        edate                   LIKE type_file.dat           #No.FUN-680104 DATE
        END RECORD,
    g_qcf  RECORD
            bdate               LIKE type_file.dat,          #No.FUN-680104 DATE #檢驗時間起
            edate               LIKE type_file.dat,          #No.FUN-680104 DATE #檢驗時間止
           #----------------No.TQC-750064 modify
           #qcf06t              LIKE qcf_file.qcf06,  #檢驗量,
            qcf22t              LIKE qcf_file.qcf22,  #檢驗量,
           #----------------No.TQC-750064 end
            qtyt                LIKE qcf_file.qcf32,         #No.FUN-680104 DECIMAL(15,3) #總不良數
           #rat1                LIKE ngh_file.ngh10,         #No.FUN-680104 DECIMAL(3,0) #不良率   #MOD-AB0086 mark
            rat1                LIKE type_file.num20_6,      #MOD-AB0086 add 
            qcf091t             LIKE qcf_file.qcf091,        #入庫量
            lotcnt              LIKE type_file.num5,         #No.FUN-680104 SMALLINT #批號
            qtycnt              LIKE type_file.num5,         #No.FUN-680104 SMALLINT #不良批號
           #rat2                LIKE ngh_file.ngh10          #No.FUN-680104 DECIMAL(3,0) #批退量   #MOD-AB0086 mark
            rat2                LIKE type_file.num20_6       #MOD-AB0086 add
        END RECORD,
    g_qcf1 DYNAMIC ARRAY OF RECORD
            qcf04               LIKE qcf_file.qcf04,      #檢驗日期
            sfb22               LIKE sfb_file.sfb22,      #訂單編號
            qcf02               LIKE qcf_file.qcf02,      #工單編號
            qcf021              LIKE qcf_file.qcf021,     #料件編號
            ima02               LIKE ima_file.ima02,      #料件名稱
            ima021              LIKE ima_file.ima021,     #料件規格
           #-------------No.TQC-750064 modify
           #qcf06               LIKE qcf_file.qcf06,      #檢驗量
            qcf22               LIKE qcf_file.qcf22,      #送驗量
            qcf091              LIKE qcf_file.qcf091,     #檢驗量
           #-------------No.TQC-750064 end
            qty                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,      #No.FUN-680104 DECIMAL(6,2) #不良率   #TQC-B90211
            desc                LIKE ze_file.ze03,        #No.TQC-610007
            cr                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #CR
            ma                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #MA
            mi                  LIKE qcf_file.qcf32       #No.FUN-680104 DEC(15,3) #MI
        END RECORD,
    s_qcf1 DYNAMIC ARRAY OF RECORD
            qcf04               LIKE qcf_file.qcf04,      #檢驗日期
            sfb22               LIKE sfb_file.sfb22,      #訂單編號
            qcf02               LIKE qcf_file.qcf02,      #工單編號
            qcf021              LIKE qcf_file.qcf021,     #料件編號
            ima02               LIKE ima_file.ima02,      #料件名稱
            ima021              LIKE ima_file.ima021,     #料件規格
           #-------------No.TQC-750064 modify
           #qcf06               LIKE qcf_file.qcf06,      #檢驗量
            qcf22               LIKE qcf_file.qcf22,      #送驗量
            qcf091              LIKE qcf_file.qcf091,     #檢驗量
           #-------------No.TQC-750064 end
            qty                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #不良率
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,      #No.FUN-680104 DECIMAL(6,2) #不良率   #TQC-B90211
            desc                LIKE ze_file.ze03,        #No.TQC-610007
            cr                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #CR
            ma                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #MA
            mi                  LIKE qcf_file.qcf32       #No.FUN-680104 DEC(15,3) #MI
        END RECORD,
    g_curr           LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
    l_sql            LIKE type_file.chr1000,      #No.FUN-680104 VARCHAR(1000)
    g_qcf_wowid      LIKE type_file.num10,        #No.FUN-680104 INTEGER
    m_cnt            LIKE type_file.num5,         #No.FUN-680104 SMALLINT
    g_sql            LIKE type_file.chr1000,      #WHERE CONDITION  #No.FUN-680104 VARCHAR(1000)
    g_rec_b          LIKE type_file.num5,         #單身筆數        #No.FUN-680104 SMALLINT
    cr,ma,mi         LIKE qcf_file.qcf32          #No.FUN-680104 DEC(15,3)
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680104 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680104 SMALLINT
DEFINE g_sql1   STRING                           #No.FUN-850013                                                                       
DEFINE l_table  STRING                           #No.FUN-850013                                                                       
DEFINE g_str    STRING                           #No.FUN-850013
 
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
 
#No.FUN-850013--BEGIN--                                                                                                             
   LET g_sql1="qcf04.qcf_file.qcf04,",                                                                                            
              "sfb22.sfb_file.sfb22,",                                                                                              
              "qcf02.qcf_file.qcf02,",                                                                                              
              "qcf021.qcf_file.qcf021,",                                                                                              
              "qcf22.qcf_file.qcf22,",                                                                                              
              "qcf091.qcf_file.qcf091,",                                                                                              
              "l_desc.ze_file.ze03,",                                                                                              
              "cr.qcf_file.qcf32,",                                                                                              
              "ma.qcf_file.qcf32,",                                                                                              
              "mi.qcf_file.qcf32,",                                                                                              
              "ima02.ima_file.ima02,",
              "ima021.ima_file.ima021,",
              "qcf22t.qcf_file.qcf22,",                                                                                              
              "qtyt.qcf_file.qcf32,",                                                                                              
              "rat1.type_file.num20_6,",     #MOD-AB0086 ngh10 modify num20_6                                                                                         
              "qcf091t.qcf_file.qcf091,",                                                                                              
              "lotcnt.type_file.num5,",                                                                                              
              "qtycnt.type_file.num5,",                                                                                              
              "rat2.type_file.num20_6,"      #MOD-AB0086 ngh10 modify num20_6                                                                                         
   LET l_table=cl_prt_temptable("aqcq410",g_sql1) CLIPPED                                                                           
   IF l_table=-1 THEN EXIT PROGRAM END IF                                                                                           
   LET g_sql1="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                   
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,? ) "                                                                                
   PREPARE insert_prep FROM g_sql1                                                                                                  
   IF STATUS THEN                                                                                                                   
      CALL cl_err("insert_prep:",status,1)                                                                                          
   END IF                                                                                                                           
#No.FUN-850013--END-- 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
    LET g_curr = '1'
    LET p_row = 3 LET p_col = 2
    OPEN WINDOW q410_w AT p_row,p_col
        WITH FORM "aqc/42f/aqcq410"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q410_q()
#    END IF
    CALL q410_menu()
    CLOSE WINDOW q410_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION q410_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680104 SMALLINT
   CLEAR FORM #清除畫面
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.bdate=TODAY
   LET tm.edate=TODAY
   DISPLAY BY NAME tm.bdate,tm.edate
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT tm.bdate,tm.edate WITHOUT DEFAULTS FROM bdate,edate
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
       LET g_qcf.bdate=tm.bdate
       LET g_qcf.edate=tm.edate
#bugno:6062 end..............................
 
   MESSAGE ' WAIT '
   LET g_sql=" SELECT count(*) FROM qcf_file ",
             " WHERE qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"' ",
             "   AND qcf14='Y' AND qcf18='1' "
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND qcfuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND qcfgrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND qcfgrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('qcfuser', 'qcfgrup')
   #End:FUN-980030
 
   PREPARE q410_prepare FROM g_sql
   DECLARE q410_count CURSOR FOR q410_prepare
END FUNCTION
 
FUNCTION q410_menu()
 
   WHILE TRUE
      CALL q410_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q410_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL q410_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_qcf1),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q410_q()
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL g_qcf1.clear() #MOD-5A0169 add
    CALL q410_cs()
   #--------------No.TQC-750064 modify
   #SELECT count(*),sum(qcf06),sum(qcf091)
   #  INTO g_qcf.lotcnt, g_qcf.qcf06t, g_qcf.qcf091t
    SELECT count(*),sum(qcf22),sum(qcf091)
      INTO g_qcf.lotcnt, g_qcf.qcf22t, g_qcf.qcf091t
   #--------------No.TQC-750064 end
      FROM qcf_file
     WHERE qcf04 BETWEEN tm.bdate AND tm.edate AND qcf14='Y' AND qcf18='1'
    IF SQLCA.sqlcode THEN
#       CALL cl_err('',SQLCA.sqlcode,0)   #No.FUN-660115
        CALL cl_err3("sel","qcf_file","","",SQLCA.sqlcode,"","",0)  #No.FUN-660115
    ELSE
       OPEN q410_count
       FETCH q410_count INTO m_cnt
       DISPLAY m_cnt TO FORMONLY.cnt
        #------- CR
        SELECT SUM(qcg07) INTO cr FROM qcf_file,qcg_file
           WHERE qcf04 BETWEEN tm.bdate AND tm.edate
             AND qcf01=qcg01 AND qcg05='1' AND qcf14='Y' AND qcf18='1'
        IF STATUS OR cr IS NULL THEN LET cr=0 END IF
        #------- MA
        SELECT SUM(qcg07) INTO ma FROM qcf_file,qcg_file
           WHERE qcf04 BETWEEN tm.bdate AND tm.edate
             AND qcf01=qcg01 AND qcg05='2' AND qcf14='Y' AND qcf18='1'
        IF STATUS OR ma IS NULL THEN LET ma=0 END IF
        #------- MI
        SELECT SUM(qcg07) INTO mi FROM qcf_file,qcg_file
           WHERE qcf04 BETWEEN tm.bdate AND tm.edate
             AND qcf01=qcg01 AND qcg05='3' AND qcf14='Y' AND qcf18='1'
        IF STATUS OR mi IS NULL THEN LET mi=0 END IF
        #-------- 不良數總計
       #---------------No.TQC-750064 modify
       #LET g_qcf.qtyt=(cr*g_qcz.qcz02/g_qcz.qcz021)+
       #               (ma*g_qcz.qcz03/g_qcz.qcz031)+
       #               (mi*g_qcz.qcz04/g_qcz.qcz041)
        LET g_qcf.qtyt=g_qcf.qcf22t - g_qcf.qcf091t
 
       #IF g_qcf.qcf06t = 0 THEN      # 分母為零, 另作處理
	IF g_qcf.qcf22t = 0 THEN      # 分母為零, 另作處理
           LET g_qcf.rat1 = 0
	ELSE
          #LET g_qcf.rat1 = (g_qcf.qtyt/g_qcf.qcf06t)*100
           LET g_qcf.rat1 = (g_qcf.qtyt/g_qcf.qcf22t)*100
	END IF
       #---------------No.TQC-750064 end
        SELECT count(*) INTO g_qcf.qtycnt FROM qcf_file
         WHERE qcf09 = '2' AND qcf14='Y' AND qcf18='1'
           AND qcf04 BETWEEN tm.bdate AND tm.edate
        IF g_qcf.lotcnt = 0 THEN      # 分母為零, 另作處理
           LET g_qcf.rat2 = 0
	ELSE
	   LET g_qcf.rat2 = (g_qcf.qtycnt/g_qcf.lotcnt)*100
	END IF
        CALL q410_show()                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q410_show()
   DISPLAY BY NAME g_qcf.*
   CALL q410_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q410_b_fill()              #BODY FILL UP
   DEFINE #l_ex      LIKE cqg_file.cqg08,         #No.FUN-680104 DECIMAL(8,4)   #TQC-B90211
          l_cho     LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
          l_qcf01   LIKE qcf_file.qcf01,
          l_qcf09   LIKE qcf_file.qcf09
 
   LET l_sql =
        "SELECT qcf04,sfb22,qcf02,qcf021,ima02,ima021,",
       #------------No.TQC-750064 modify
       #"       qcf06,qcf22,0,0,qcf09, ",
        "       qcf22,qcf091,0,0,qcf09, ",
       #------------No.TQC-750064 end
	"       0,0,0,qcf01",
        "  FROM qcf_file LEFT OUTER  JOIN ima_file ON qcf021=ima01 LEFT OUTER JOIN sfb_file ON qcf02=sfb01",
        " WHERE qcf14='Y' AND qcf18='1' ",
        "   AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
        " ORDER BY qcf04 "
    PREPARE q410_pb FROM l_sql
    DECLARE q410_bcs CURSOR FOR q410_pb
    FOR g_cnt = 1 TO g_qcf1.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_qcf1[g_cnt].* TO NULL
    END FOR
    LET g_rec_b=0 LET g_cnt = 1
    FOREACH q410_bcs INTO g_qcf1[g_cnt].*,l_qcf01
        LET g_rec_b = g_rec_b + 1   #No.MOD-5A0169 add
        #------- CR
        SELECT SUM(qcg07) INTO g_qcf1[g_cnt].cr FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='1'
             AND qcf14='Y' AND qcf18='1'
        IF STATUS OR g_qcf1[g_cnt].cr IS NULL THEN LET g_qcf1[g_cnt].cr=0 END IF
        #------- MA
        SELECT SUM(qcg07) INTO g_qcf1[g_cnt].ma FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='2'
             AND qcf14='Y' AND qcf18='1'
        IF STATUS OR g_qcf1[g_cnt].ma IS NULL THEN LET g_qcf1[g_cnt].ma=0 END IF
        #------- MI
        SELECT SUM(qcg07) INTO g_qcf1[g_cnt].mi FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='3'
             AND qcf14='Y' AND qcf18='1'
        IF STATUS OR g_qcf1[g_cnt].mi IS NULL THEN LET g_qcf1[g_cnt].mi=0 END IF
       #--------------No.TQC-750064 modify
       #LET g_qcf1[g_cnt].qty=g_qcf1[g_cnt].cr*g_qcz.qcz02/g_qcz.qcz021+
       #            g_qcf1[g_cnt].ma*g_qcz.qcz03/g_qcz.qcz031+
       #            g_qcf1[g_cnt].mi*g_qcz.qcz04/g_qcz.qcz041
       #LET g_qcf1[g_cnt].rate=g_qcf1[g_cnt].qty/g_qcf1[g_cnt].qcf06*100
        LET g_qcf1[g_cnt].qty=g_qcf1[g_cnt].qcf22 - g_qcf1[g_cnt].qcf091
        LET g_qcf1[g_cnt].rate=g_qcf1[g_cnt].qty/g_qcf1[g_cnt].qcf22*100
       #--------------No.TQC-750064 end
        CASE g_qcf1[g_cnt].desc
           WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                     g_qcf1[g_cnt].desc
           WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                     g_qcf1[g_cnt].desc
          #---------------No.TQC-740045 add
           WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                     g_qcf1[g_cnt].desc
          #---------------No.TQC-740045 end
        END CASE
    LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    LET g_rec_b=(g_cnt-1)
    CALL SET_COUNT(g_cnt-1)               #告訴I.單身筆數
    CALL g_qcf1.deleteElement(g_cnt)   #No.MOD-5A0169 add
    LET g_cnt = 0                      #No.MOD-5A0169 add
 
END FUNCTION
 
FUNCTION q410_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_qcf1 TO s_qcf1.*  #MOD-5A0169 mark
   DISPLAY ARRAY g_qcf1 TO s_qcf1.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  #MOD-5A0169 add
 
#      BEFORE ROW
         #LET l_ac = ARR_CURR()
         #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf #FUN-560255 MARK
         #LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
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
 
      ON ACTION accept
#         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION q410_out()
DEFINE
    l_i             LIKE type_file.num5,          #No.FUN-680104 SMALLINT
    l_name          LIKE type_file.chr20,         #External(Disk) file name        #No.FUN-680104 VARCHAR(20)
    l_za05          LIKE type_file.chr1000,       #No.FUN-680104 VARCHAR(40)
    l_qcf01         LIKE qcf_file.qcf01,
    l_qcf09         LIKE qcf_file.qcf09,
    sr              RECORD
            qcf04               LIKE qcf_file.qcf04,      #檢驗日期
            sfb22               LIKE sfb_file.sfb22,      #訂單編號
           #-----------------No.TQC-750064 modify
           #qcf06               LIKE qcf_file.qcf06,      #檢驗量
            qcf091              LIKE qcf_file.qcf091,     #檢驗量
           #-----------------No.TQC-750064 end
            qty                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #不良率
            desc                LIKE ze_file.ze03,        #No.FUN-680104 VARCHAR(4) #判定
            cr                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #CR
            ma                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #MA
            mi                  LIKE qcf_file.qcf32,      #No.FUN-680104 DEC(15,3) #MI
            qcf22               LIKE qcf_file.qcf22,      #送驗量
            qcf02               LIKE qcf_file.qcf02,      #工單編號
	    rate		LIKE type_file.num15_3,   #LIKE cqu_file.cqu03,      #No.FUN-680104 DECIMAL(6,2) #不良率   #TQC-B90211
            qcf021              LIKE qcf_file.qcf021,     #料件編號
            ima02               LIKE ima_file.ima02,      #料件名稱
            ima021              LIKE ima_file.ima021      #料件規格
        END RECORD
 
    CALL cl_wait()
#No.FUN-850013--BEGIN--                                                                                                             
    CALL cl_del_data(l_table)                                                                                                       
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
#   CALL cl_outnam('aqcq410') RETURNING l_name
#No.FUN-850013--END--
    #No.TQC-750041  --begin 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01=g_lang   
    #No.TQC-750041  --end
    LET l_sql =
       #---------------No.TQC-750064 modify
       #"SELECT qcf04,sfb22,qcf06,0,qcf09, ",
        "SELECT qcf04,sfb22,qcf091,0,qcf09, ",
       #---------------No.TQC-750064 end
	"       0,0,0,qcf22,qcf02,",
	"       0, qcf021, ima02,ima021,qcf01",
        "  FROM qcf_file LEFT OUTER  JOIN ima_file ON qcf021=ima01 LEFT OUTER JOIN sfb_file ON qcf02=sfb01",
        " WHERE qcf14='Y' AND qcf18='1' ",
        " AND qcf04 BETWEEN '",tm.bdate,"' AND '",tm.edate,"'",
        " ORDER BY 1"
    PREPARE q410_pb1 FROM l_sql
    DECLARE q410_bcs1 CURSOR FOR q410_pb1
#   START REPORT q410_rep TO l_name       #No.FUN-850013
    FOREACH q410_bcs1 INTO sr.*,l_qcf01
        #------- CR
        SELECT SUM(qcg07) INTO sr.cr FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='1'
             AND qcf14='Y' AND qcf18='1'
        IF STATUS OR sr.cr IS NULL THEN LET sr.cr=0 END IF
        #------- MA
        SELECT SUM(qcg07) INTO sr.ma FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='2'
             AND qcf14='Y' AND qcf18='1'
        IF STATUS OR sr.ma IS NULL THEN LET sr.ma=0 END IF
        #------- MI
        SELECT SUM(qcg07) INTO sr.mi FROM qcf_file,qcg_file
           WHERE qcf01=qcg01 AND qcf01=l_qcf01 AND qcg05='3'
             AND qcf14='Y' AND qcf18='1'
        IF STATUS OR sr.mi IS NULL THEN LET sr.mi=0 END IF
    #-----------No.TQC-750064 modify
    #LET sr.qty=sr.cr*g_qcz.qcz02/g_qcz.qcz021+sr.ma*g_qcz.qcz03/g_qcz.qcz031+sr.mi*g_qcz.qcz04/g_qcz.qcz041
    #LET sr.rate=sr.qty/sr.qcf06*100
     LET sr.qty=sr.qcf22 - sr.qcf091
     LET sr.rate=sr.qty/sr.qcf22*100
    #-----------No.TQC-750064 end
     CASE sr.desc
        WHEN '1' CALL cl_getmsg('aqc-004',g_lang) RETURNING
                  sr.desc
        WHEN '2' CALL cl_getmsg('aqc-033',g_lang) RETURNING
                  sr.desc
       #-------------No.TQC-740045 add
        WHEN '3' CALL cl_getmsg('aqc-006',g_lang) RETURNING
                  sr.desc
       #-------------No.TQC-740045 end
     END CASE
#No.FUN-850013--BEGIN--
#      OUTPUT TO REPORT q410_rep(sr.*)
       EXECUTE insert_prep USING sr.qcf04,sr.sfb22,sr.qcf02,sr.qcf021,sr.qcf22,sr.qcf091,
                                 sr.desc,sr.cr,sr.ma,sr.mi,sr.ima02,sr.ima021,g_qcf.qcf22t,
                                 g_qcf.qtyt,g_qcf.rat1,g_qcf.qcf091t,g_qcf.lotcnt,
                                 g_qcf.qtycnt,g_qcf.rat2
    END FOREACH
#   FINISH REPORT q410_rep
    LET g_sql1="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
    LET g_str = ''                                                                                                                  
    LET g_str = tm.bdate,";",tm.edate
    CALL cl_prt_cs3('aqcq410','aqcq410',g_sql1,g_str)
    ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-850013--END--
END FUNCTION
 
#No.FUN-850013--BEGIN--MARK--
#REPORT q410_rep(sr)
#DEFINE
#   l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_sw            LIKE type_file.chr1,         #No.FUN-680104 VARCHAR(1)
#   l_i             LIKE type_file.num5,         #No.FUN-680104 SMALLINT
#   sr              RECORD
#           qcf04               LIKE qcf_file.qcf04,      #檢驗日期
#           sfb22               LIKE sfb_file.sfb22,      #訂單編號
#          #------------No.TQC-750064 modify
#          #qcf06               LIKE qcf_file.qcf06,      #檢驗量
#           qcf091              LIKE qcf_file.qcf091,     #檢驗量
#          #------------No.TQC-750064 end
#           qty                 LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #不良率
#           desc                LIKE ze_file.ze03,        #No.FUN-680104 VARCHAR(4) #判定
#           cr                  LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #CR
#           ma                  LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #MA
#           mi                  LIKE qcf_file.qcf32,      #No.FUN-680104 DECIMAL(15,3) #MI
#           qcf22               LIKE qcf_file.qcf22,      #送驗量
#           qcf02               LIKE qcf_file.qcf02,      #工單編號
#           rate		LIKE cqu_file.cqu03,      #No.FUN-680104 DECIMAL(6,2) #不良率
#           qcf021              LIKE qcf_file.qcf021,     #料件編號
#           ima02               LIKE ima_file.ima02,      #料件名稱
#           ima021              LIKE ima_file.ima021      #料件規格
#       END RECORD
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.qcf04
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#           LET g_pageno=g_pageno+1
#           LET pageno_total=PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED,pageno_total
#           PRINT g_x[9] CLIPPED,tm.bdate,'-',tm.edate
#           PRINT g_dash
#           PRINT COLUMN q410_getStartPos(38,39,g_x[18]),g_x[18]
#           PRINT COLUMN g_c[38],g_dash2[1,g_w[38]+g_w[39]+1]
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35], #TQC-5B0034
#                 g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
#           PRINTX name=H2 g_x[41],g_x[42],g_x[43] #TQC-5B0034 add
#           PRINT g_dash1        
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           PRINTX name=D1 COLUMN g_c[31],sr.qcf04, #TQC-5B0034
#                 COLUMN g_c[32],sr.sfb22,
#                 COLUMN g_c[33],sr.qcf02,
#                 COLUMN g_c[34],sr.qcf021 CLIPPED,
#                 COLUMN g_c[35],cl_numfor(sr.qcf22,35,1),
#                #---------------No.TQC-750064 modify
#                #COLUMN g_c[36],cl_numfor(sr.qcf06,36,1),
#                 COLUMN g_c[36],cl_numfor(sr.qcf091,36,1),
#                #---------------No.TQC-750064 end
#                 COLUMN g_c[37],sr.desc,
#                 COLUMN g_c[38],cl_numfor(sr.cr,38,1),
#                 COLUMN g_c[39],cl_numfor(sr.ma,39,1),
#                 COLUMN g_c[40],cl_numfor(sr.mi,40,1)
#           #PRINT COLUMN g_c[34],sr.ima02,' ', sr.ima021 #TQC-5B0034 mark
#           PRINTX name=D2 COLUMN g_c[42],sr.ima02 CLIPPED,COLUMN g_c[43],sr.ima021 CLIPPED #TQC-5B0034 add
#       ON LAST ROW
#           PRINT g_dash
#          #--------------No.TQC-750064 modify
#          #PRINT COLUMN 33, g_x[10] CLIPPED,g_qcf.qcf06t USING '#########&',
#           PRINT COLUMN 33, g_x[10] CLIPPED,g_qcf.qcf22t USING '#########&',
#          #--------------No.TQC-750064 end
#                 COLUMN 55, g_x[11] CLIPPED,g_qcf.qtyt USING '#########&',
#                 COLUMN 79, g_x[12] CLIPPED,g_qcf.rat1 USING '##&',
#                 COLUMN 95, g_x[13] CLIPPED,g_qcf.qcf091t USING '#########&'
#           PRINT COLUMN 33, g_x[14] CLIPPED,g_qcf.lotcnt USING '#########&',
#                 COLUMN 55, g_x[15] CLIPPED,g_qcf.qtycnt USING '#########&',
#                 COLUMN 79, g_x[16] CLIPPED,g_qcf.rat2 USING '##&'
#         #  PRINT g_dash2
#           PRINT g_dash[1,g_len]      #TQC-750041
#           LET l_trailer_sw = 'n'
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#          #     PRINT g_dash2
#               PRINT g_dash[1,g_len]     #TQC-750041
#               PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#ND REPORT
 
#by kim 05/1/26
#函式說明:算出一字串,位於數個連續表頭的中央位置
#l_sta -  zaa起始序號   l_end - zaa結束序號  l_sta -字串長度
#傳回值 - 字串起始位置
#FUNCTION q410_getStartPos(l_sta,l_end,l_str)
#DEFINE l_sta,l_end,l_length,l_pos,l_w_tot,l_i LIKE type_file.num5          #No.FUN-680104 SMALLINT
#DEFINE l_str           STRING      #No.FUN-680104
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
#No.FUN-850013--END--MARK
 
#No.FUN-870144

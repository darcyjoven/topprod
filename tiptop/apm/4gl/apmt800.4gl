# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmt800.4gl
# Descriptions...: 採購單交期確認資料維護作業
# Date & Author..: 92/01/14 By Lin
# Modify ........: BY Apple (整合修改)
# Modify.........: 04/07/21 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-550060 05/05/30 By jackie 單據編號加大
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6C0050 06/12/12 By Judy 取消"明細備注查詢"功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.FUN-980006 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-990014 09/09/07 By mike after field pmz06不應該判斷是否大於系統日,故mfg3193的條件式要拿掉                 
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-C40117 12/04/25 By zhuhao q_pmn3 傳參
# Modify.........: No:MOD-CB0267 13/02/01 By Elise 預計到廠日(pmz07)不會推算預計到庫日(pmz08)，與採購單邏輯不同
# Modify.........: No:FUN-D30034 13/04/15 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_pmz01         LIKE pmz_file.pmz01,   #採購單編號 (假單頭)
    g_pmz02         LIKE pmz_file.pmz02,   #採購單項次 (假單頭)
    g_pmz03         LIKE pmz_file.pmz03,   #採購單次數
    g_way,g_min     LIKE pmz_file.pmz09,   #確認數量
    g_pmn04         LIKE pmn_file.pmn04,   #料件編號
    g_pmn09         LIKE pmn_file.pmn09,   #轉換因子
    g_pmn20         LIKE pmn_file.pmn20,   #訂購量
    g_pmn14         LIKE pmn_file.pmn14,   #訂購量
    g_pmz09         LIKE pmz_file.pmz09,   #確認數量
    g_pmz10         LIKE pmz_file.pmz10,   #確認人
    g_pmz11         LIKE pmz_file.pmz11,   #備註一
    g_pmz12         LIKE pmz_file.pmz12,   #備註一
    g_pmz13         LIKE pmz_file.pmz13,   #備註一
    g_pmz01_t       LIKE pmz_file.pmz01,   #採購單編號 (舊值)
    g_pmz02_t       LIKE pmz_file.pmz02,   #採購單項次 (舊值)
    g_ima49         LIKE ima_file.ima49,   #到廠前置期
    g_ima491        LIKE ima_file.ima491,  #入庫前置期
    g_pmz           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        pmz03       LIKE pmz_file.pmz03,   #次數
        pmz05       LIKE pmz_file.pmz05,   #最近答應日期
        pmz06       LIKE pmz_file.pmz06,   #最近交期確認日期
        pmz07       LIKE pmz_file.pmz07,   #預計到廠日期
        pmz08       LIKE pmz_file.pmz08,   #預計到庫日期
        pmz09       LIKE pmz_file.pmz09,   #確認交貨數量
        pmz10       LIKE pmz_file.pmz10,   #確認人
        gen02       LIKE gen_file.gen02,   #姓名
        pmz11       LIKE pmz_file.pmz11,   #備註否
        pmz12       LIKE pmz_file.pmz12,
        pmz13       LIKE pmz_file.pmz13
                    END RECORD,
    g_pmz_t         RECORD                 #程式變數 (舊值)
        pmz03       LIKE pmz_file.pmz03,   #次數
        pmz05       LIKE pmz_file.pmz05,   #最近答應日期
        pmz06       LIKE pmz_file.pmz06,   #最近交期確認日期
        pmz07       LIKE pmz_file.pmz07,   #預計到廠日期
        pmz08       LIKE pmz_file.pmz08,   #預計到庫日期
        pmz09       LIKE pmz_file.pmz09,   #確認交貨數量
        pmz10       LIKE pmz_file.pmz10,   #確認人
        gen02       LIKE gen_file.gen02,   #姓名
        pmz11       LIKE pmz_file.pmz11,   #備註否
        pmz12       LIKE pmz_file.pmz12,
        pmz13       LIKE pmz_file.pmz13
                    END RECORD,
    g_wc,g_wc2,g_sql    string,                 #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,        #單身筆數             #No.FUN-680136 SMALLINT
    g_ans,g_begin   LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    g_ss            LIKE type_file.chr1,   	#No.FUN-680136 VARCHAR(1)
    l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_msg           LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_curs_index    LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_jump          LIKE type_file.num10         #No.FUN-680136 INTEGER
DEFINE g_no_ask       LIKE type_file.num5          #No.FUN-680136 SMALLINT
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_pmz01 = NULL                     #清除鍵值
    LET g_pmz02 = NULL                     #清除鍵值
    LET g_pmz01_t = NULL
    LET g_pmz02_t = NULL
 
    OPEN WINDOW t800_w WITH FORM "apm/42f/apmt800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL t800_pass()                       #輸入確認人
    CALL t800_menu()
    CLOSE WINDOW t800_w                    #結束畫面

    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION t800_cs()
    CLEAR FORM                             #清除畫面
    CALL g_pmz.clear() 
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_pmz01 TO NULL    #No.FUN-750051
   INITIALIZE g_pmz02 TO NULL    #No.FUN-750051
    CONSTRUCT g_wc ON pmz01,pmz02,         #螢幕上取條件
                      pmz06,pmz07,pmz08,pmz09,pmz10,pmz11
        FROM pmz01,pmz02,s_pmz[1].pmz06,s_pmz[1].pmz07,
             s_pmz[1].pmz08, s_pmz[1].pmz09,s_pmz[1].pmz10,s_pmz[1].pmz11
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE      #查詢符合條件的單號
             WHEN INFIELD(pmz01)
#                 CALL q_pmm2(7,2,g_pmz01,'2') RETURNING g_pmz01
                  CALL q_pmm2(TRUE,TRUE,g_pmz01,'2') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmz01
                  NEXT FIELD pmz01
             WHEN INFIELD(pmz02)   #項次
#                 CALL q_pmn3(7,2,g_pmz01,g_pmz02,'') RETURNING g_pmz02,l_pmn04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmn3"
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmz02
                  NEXT FIELD pmz02
            OTHERWISE EXIT CASE
           END  CASE
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN RETURN END IF
 
    LET g_sql="SELECT UNIQUE pmz01,pmz02 FROM pmz_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               " ORDER BY pmz01"
 
    PREPARE t800_prepare FROM g_sql      #預備一下
    DECLARE t800_b_cs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t800_prepare
 
    #BugNo:5830
    #若使用組合鍵值, 則可以使用本方法去得到筆數值
    LET g_sql="SELECT UNIQUE pmz01,pmz02 FROM pmz_file ", # 組合出 SQL 指令
               " WHERE ", g_wc CLIPPED,
               "  INTO TEMP x "
 
    DROP TABLE x
    PREPARE t800_precount_x FROM g_sql
    EXECUTE t800_precount_x
 
        LET g_sql="SELECT COUNT(*) FROM x "
 
    PREPARE t800_pp FROM g_sql
    DECLARE t800_count CURSOR FOR t800_pp
END FUNCTION
 
 
FUNCTION t800_menu()
 DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   WHILE TRUE
      CALL t800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
       #TQC-6C0050.....begin   
#         WHEN "query_memo"
#            IF cl_chk_act_auth() THEN
#               CALL t800_memo('d')  
#            END IF
      #TQC-6C0050.....end
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmz),'','')
            END IF
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_pmz01 IS NOT NULL THEN
                LET g_doc.column1 = "pmz01"
                LET g_doc.column2 = "pmz02"
                LET g_doc.value1 = g_pmz01
                LET g_doc.value2 = g_pmz02
                CALL cl_doc()
             END IF 
          END IF
         #No.FUN-6A0162-------add--------end----
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t800_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_pmz.clear()
    INITIALIZE g_pmz01 LIKE pmz_file.pmz01
    INITIALIZE g_pmz02 LIKE pmz_file.pmz01
    LET g_pmz01_t = NULL
    LET g_pmz02_t = NULL
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    LET g_ss='N'
    WHILE TRUE
        CALL t800_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_ss='N' THEN
           CALL g_pmz.clear()
        ELSE
           CALL t800_b_fill(0)             #單身
        END IF
        LET g_rec_b = 0
        CALL t800_b()                      #輸入單身
        LET g_pmz01_t = g_pmz01            #保留舊值
        LET g_pmz02_t = g_pmz02            #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION t800_i(p_cmd)
DEFINE
    l_pmm25       LIKE pmm_file.pmm25,     #狀況碼
    l_pmn04       LIKE pmn_file.pmn04,     #採購項次
    l_pmn         LIKE type_file.num5,     #No.FUN-680136 SMALLINT
    l_flag        LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
    p_cmd         LIKE type_file.chr1      #a:輸入 u:更改 #No.FUN-680136 VARCHAR(1)
 
 
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
    INPUT g_pmz01,g_pmz02 WITHOUT DEFAULTS
     FROM pmz01,pmz02
 
#No.FUN-550060 --start--
     BEFORE INPUT
       CALL cl_set_docno_format("pmz01")
#No.FUN-550060 ---end---
 
        AFTER FIELD pmz01                  #採購單編號
            IF NOT cl_null(g_pmz01) THEN
                CALL t800_pmz01('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_pmz01,g_errno,0)
                   NEXT FIELD pmz01
                END IF
                SELECT count(*) INTO l_pmn FROM pmn_file
                 WHERE pmn01=g_pmz01  AND pmn16='2'
                IF cl_null(l_pmn) OR l_pmn<=0 THEN
                    CALL cl_err(g_pmz01,'mfg3190',0)
                    NEXT FIELD pmz01
                END IF
            END IF
 
        AFTER FIELD pmz02                  #採購單項次
            IF NOT cl_null(g_pmz02) THEN
                CALL t800_pmn('a')
                # 93/02/06 E.C.
                IF g_errno = 'mfg3352' THEN
                   CALL cl_err('','mfg3352',0)
                   INITIALIZE g_pmz01,g_pmz02 TO NULL
                   DISPLAY BY NAME g_pmz01,g_pmz02
                   NEXT FIELD pmz01
                END IF
                IF NOT cl_null(g_errno)
                 THEN CALL cl_err('','mfg3192',0)
                      NEXT FIELD pmz02
                END IF
                IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
                  (p_cmd = "u" AND g_pmz01 != g_pmz01_t) THEN
                    SELECT count(*) INTO g_cnt FROM pmz_file
                        WHERE pmz01 = g_pmz01 AND pmz02=g_pmz02
                    IF g_cnt > 0 THEN   #資料重複
                        CALL cl_err(g_pmz01,-239,0)
                        LET g_pmz01 = g_pmz01_t
                        LET g_pmz02 = g_pmz02_t
                        DISPLAY  g_pmz01 TO pmz01
                        DISPLAY  g_pmz02 TO pmz02
                        NEXT FIELD pmz01
                    END IF
                END IF
            END IF
        AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
        ON ACTION CONTROLP
           CASE      #查詢符合條件的單號
             WHEN INFIELD(pmz01)
#                 CALL q_pmm2(7,2,g_pmz01,'2') RETURNING g_pmz01
                  CALL q_pmm2(FALSE,TRUE,g_pmz01,'2') RETURNING g_pmz01
                  DISPLAY BY NAME g_pmz01
                  NEXT FIELD pmz01
             WHEN INFIELD(pmz02)   #項次
#                 CALL q_pmn3(7,2,g_pmz01,g_pmz02,'') RETURNING g_pmz02,l_pmn04
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmn3"
                  LET g_qryparam.arg1 = g_pmz01     #TQC-C40117 add
                  LET g_qryparam.default1 = g_pmz01 
                  LET g_qryparam.default2 = g_pmz02 
                  CALL cl_create_qry() RETURNING g_pmz02,l_pmn04
                  DISPLAY BY NAME g_pmz02
                  CALL t800_pmn('a')
                  NEXT FIELD pmz02
            OTHERWISE EXIT CASE
           END  CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()
         ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
       
      #TQC-860019-add
       ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
      #TQC-860019-add
 
    END INPUT
END FUNCTION
 
FUNCTION t800_pmz01(p_cmd)
  DEFINE p_cmd    LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(1)
         l_pmm25  LIKE pmm_file.pmm25,
         l_pmmacti LIKE pmm_file.pmmacti
 
   LET g_errno = " "
   SELECT pmm25,pmmacti INTO l_pmm25,l_pmmacti FROM pmm_file
    WHERE pmm01=g_pmz01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3188'
                            LET l_pmm25 = NULL
         WHEN l_pmmacti='N' LET g_errno = '9028'
         WHEN l_pmm25 != '2'  LET g_errno = 'mfg3189'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t800_pmn(p_cmd)
  DEFINE
         l_pmm25       LIKE pmm_file.pmm25,     #狀況碼
         l_pmn55       LIKE pmn_file.pmn55,     #驗退量
         l_pmn041      LIKE pmn_file.pmn041,    #品名規格
         l_pmn16       LIKE pmn_file.pmn16,     #狀況碼
         l_pmn33       LIKE pmn_file.pmn33,     #原始交貨日
         l_pmn34       LIKE pmn_file.pmn34,     #原始到廠日
         l_pmn35       LIKE pmn_file.pmn35,     #原始到庫日
         l_pmn50       LIKE pmn_file.pmn50,     #收貨量
         l_pmn13       LIKE pmn_file.pmn13,     #超短交限率
         g_ima021      LIKE ima_file.ima021,    #規格
         p_cmd         LIKE type_file.chr1      #a:輸入 u:更改   #No.FUN-680136 VARCHAR(1)
 
 
    LET g_errno=' '
    SELECT pmn04,pmn041,pmn09,pmn16,pmn20,
           pmn13,pmn14,pmn33,pmn34,pmn35,pmn50,pmn55
      INTO g_pmn04,l_pmn041,g_pmn09,l_pmn16,g_pmn20,
           l_pmn13,g_pmn14,l_pmn33,l_pmn34,l_pmn35,l_pmn50,l_pmn55
      FROM pmn_file
     WHERE pmn01=g_pmz01 AND pmn02=g_pmz02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3192'
                                  LET g_pmn20 = 0
                                  LET l_pmn33 = 0 LET l_pmn34 = 0
                                  LET l_pmn35 = 0 LET l_pmn50 = 0
                                  LET l_pmn13 = 0
         WHEN l_pmn16 !='2' LET g_errno = 'mfg3191'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' AND NOT cl_null(g_errno) THEN RETURN END IF
    IF p_cmd = 'a' AND cl_null(g_errno) THEN
       IF g_pmn14 = "N" AND l_pmn50 > 0 THEN
          LET g_errno = 'mfg3352'
          RETURN
       END IF
    END IF
 
    IF l_pmn13 IS NULL THEN LET l_pmn13=0 END IF
    IF g_pmn09 IS NULL THEN LET g_pmn09=1 END IF
    IF g_pmn14 = 'N' THEN
       #允許的最少量
       LET g_min = g_pmn20 - ( g_pmn20 * (l_pmn13 / 100) )
    END IF
    #可允許在途量 = 訂購量 -  收貨量 - 在途量 +  (訂購量*超交超率)
    #LET g_way= g_pmn20 - l_pmn50 + ( g_pmn20 * l_pmn13 / 100 )
#NO:3065  1999/03/30 modify by Carol
#...可允許在途量 = 訂購量 -  收貨量 - 在途量 +  (訂購量*超交超率) +驗退量
    LET g_way= g_pmn20 - l_pmn50 + ( g_pmn20 * l_pmn13 / 100 ) + l_pmn55
 
    #讀取 到廠前置時間/到庫前置時間
    SELECT ima49,ima491,ima021
         INTO g_ima49,g_ima491,g_ima021
         FROM ima_file
        WHERE ima01=g_pmn04
    IF g_ima49  IS NULL THEN LET g_ima49=0 END IF
    IF g_ima491 IS NULL THEN LET g_ima491=0 END IF
 
    IF p_cmd='d' OR cl_null(g_errno) THEN
       DISPLAY  g_pmn04 TO pmn04
       DISPLAY  g_ima021 TO ima021
       DISPLAY  g_pmn20 TO pmn20
       DISPLAY  g_pmn14 TO pmn14
       DISPLAY  l_pmn13 TO pmn13
       DISPLAY  l_pmn50 TO pmn50
       DISPLAY  l_pmn33 TO pmn33
       DISPLAY  l_pmn34 TO pmn34
       DISPLAY  l_pmn35 TO pmn35
       DISPLAY  l_pmn041 TO pmn041
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pmz01 TO NULL             #No.FUN-6A0162
    INITIALIZE g_pmz02 TO NULL             #No.FUN-6A0162
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL t800_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN t800_b_cs                         #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_pmz01 TO NULL
        INITIALIZE g_pmz02 TO NULL
    ELSE
        OPEN t800_count
        FETCH t800_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t800_fetch('F')               #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1        #處理方式        #No.FUN-680136 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t800_b_cs INTO g_pmz01,g_pmz02
        WHEN 'P' FETCH PREVIOUS t800_b_cs INTO g_pmz01,g_pmz02
        WHEN 'F' FETCH FIRST    t800_b_cs INTO g_pmz01,g_pmz02
        WHEN 'L' FETCH LAST     t800_b_cs INTO g_pmz01,g_pmz02
        WHEN '/'
            IF (NOT g_no_ask) THEN
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t800_b_cs INTO g_pmz01,g_pmz02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_pmz01,SQLCA.sqlcode,0)
        INITIALIZE g_pmz01 TO NULL  #TQC-6B0105
        INITIALIZE g_pmz02 TO NULL  #TQC-6B0105
    ELSE
 
        CALL t800_show()
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t800_show()
    DISPLAY g_pmz01 TO pmz01    #單頭
    DISPLAY g_pmz02 TO pmz02    #單頭
    DISPLAY '!' TO pmn14
    CALL t800_pmn('d')
    CALL t800_b_fill(0)         #單身
    CALL cl_show_fld_cont()     #No.FUN-550037 hmf
END FUNCTION
 
#單身
FUNCTION t800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT #No.FUN-680136 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用        #No.FUN-680136 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680136 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態          #No.FUN-680136 VARCHAR(1)
    l_gen02         LIKE gen_file.gen02,
    l_allow_insert  LIKE type_file.num5,     #可新增否          #No.FUN-680136 SMALLINT
    l_allow_delete  LIKE type_file.num5      #可刪除否          #No.FUN-680136 SMALLINT
DEFINE li_result    LIKE type_file.num5      #MOD-CB0267 add
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_pmz01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT pmz03,pmz05,pmz06,pmz07,pmz08,pmz09,pmz10,'',pmz11,pmz12,pmz13 ",
      "   FROM pmz_file ",
      "   WHERE pmz01 = ? ",
      "    AND pmz02 = ? ",
      "    AND pmz03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmz WITHOUT DEFAULTS FROM s_pmz.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                IF g_pmn14 = 'N' THEN     #部份交貨
                   CALL cl_err('','mfg3244',0)
                   EXIT INPUT
                END IF
                LET p_cmd='u'
                LET g_pmz_t.* = g_pmz[l_ac].*  #BACKUP
 
                BEGIN WORK
 
                OPEN t800_bcl USING g_pmz01,g_pmz02,g_pmz_t.pmz03
                IF STATUS THEN
                    CALL cl_err("OPEN t800_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t800_bcl INTO g_pmz[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pmz_t.pmz03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL t800_pmz10('d')
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
             INSERT INTO pmz_file(pmz01,pmz02,pmz03,pmz05,  #No.MOD-470041
                                 pmz06,pmz07,pmz08,pmz09,pmz10,
                                 pmz11,pmz12,pmz13,pmzplant,pmzlegal) #FUN-980006 add pmzplant,pmzlegal
            VALUES(g_pmz01,g_pmz02,g_pmz[l_ac].pmz03,
                   g_pmz[l_ac].pmz05,g_pmz[l_ac].pmz06,
                   g_pmz[l_ac].pmz07,g_pmz[l_ac].pmz08,
                   g_pmz[l_ac].pmz09,g_pmz10,g_pmz[l_ac].pmz11,
                   g_pmz[l_ac].pmz12,g_pmz[l_ac].pmz13,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pmz[l_ac].pmz06,SQLCA.sqlcode,1)   #No.FUN-660129
               CALL cl_err3("ins","pmz_file",g_pmz01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               CANCEL INSERT
            ELSE
                #以交期確認日更新採購單單身檔的 [最近確認交貨日期](pmn36)
                #以預計到廠日更新採購單單身檔的 [最後一次到廠日期](pmn37)
                UPDATE pmn_file
                   SET pmn36=g_pmz[l_ac].pmz06,
                       pmn37=g_pmz[l_ac].pmz07
                 WHERE pmn01=g_pmz01
                   AND pmn02=g_pmz02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err('upd pmn',SQLCA.sqlcode,1)   #No.FUN-660129
                   CALL cl_err3("upd","pmn_file",g_pmz01,"",SQLCA.sqlcode,"","upd pmn",1)  #No.FUN-660129
                END IF
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pmz[l_ac].* TO NULL      #900423
            LET g_pmz11=NULL
            LET g_pmz_t.* = g_pmz[l_ac].*         #新輸入資料
            LET g_pmz[l_ac].pmz05=g_today
            LET g_pmz[l_ac].pmz06=g_today
            LET g_pmz[l_ac].pmz10=g_pmz10
            CALL t800_pmn('d')
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pmz06
 
        BEFORE FIELD pmz06
            IF p_cmd = 'a' THEN
               #次數加一
               SELECT max(pmz03)+1 INTO g_pmz[l_ac].pmz03
                 FROM pmz_file
                WHERE pmz01 = g_pmz01 AND pmz02=g_pmz02
               IF cl_null(g_pmz[l_ac].pmz03) THEN
                  LET g_pmz[l_ac].pmz03 = 1
               END IF
            END IF
 
        AFTER FIELD pmz06           #交期確認
            IF NOT cl_null(g_pmz[l_ac].pmz06) THEN
               #MOD-CB0267 add start -----
               LET li_result = 0
               CALL s_daywk(g_pmz[l_ac].pmz06) RETURNING li_result

               IF li_result = 0 THEN      #0:非工作日
                  CALL cl_err(g_pmz[l_ac].pmz06,'mfg3152',1)
               END IF
               IF li_result = 2 THEN      #2:未設定
                  CALL cl_err(g_pmz[l_ac].pmz06,'mfg3153',1)
               END IF

               IF NOT cl_null(g_pmz[l_ac].pmz07) THEN
                  IF g_pmz[l_ac].pmz06 > g_pmz[l_ac].pmz07 THEN
                     CALL cl_err('','mfg3225',1)
                     NEXT FIELD pmz07
                  END IF
               END IF
               IF NOT cl_null(g_pmz[l_ac].pmz08) THEN
                  IF g_pmz[l_ac].pmz06 > g_pmz[l_ac].pmz08 THEN
                     CALL cl_err('','mfg3224',1)
                     NEXT FIELD pmz08
                  END IF
               END IF
               #MOD-CB0267 add end   -----
               #CHI-990014   ---start
               #IF g_pmz[l_ac].pmz06 > g_today THEN
               #    CALL cl_err(g_pmz[l_ac].pmz06,'mfg3193',0)
               #    LET g_pmz[l_ac].pmz06=g_pmz_t.pmz06
               #    #------MOD-5A0095 START----------
               #    DISPLAY BY NAME g_pmz[l_ac].pmz06
               #    #------MOD-5A0095 END------------
               #    NEXT FIELD pmz06
               #END IF
               #CHI-990014   ---end
               #MOD-CB0267 mark start -----
               #IF g_pmz_t.pmz06 != g_pmz[l_ac].pmz06
               #        OR g_pmz_t.pmz06 IS NULL  THEN
               #   LET g_pmz[l_ac].pmz07=g_pmz[l_ac].pmz06+g_ima49
               #   LET g_pmz[l_ac].pmz08=g_pmz[l_ac].pmz07+g_ima491
               #   #------MOD-5A0095 START----------
               #   DISPLAY BY NAME g_pmz[l_ac].pmz07
               #   DISPLAY BY NAME g_pmz[l_ac].pmz08
               #   #------MOD-5A0095 END------------
               #END IF
               #MOD-CB0267 mark end   -----
            END IF

        #MOD-CB0267 add start -----
        BEFORE FIELD pmz07    #到廠日
           IF cl_null(g_pmz[l_ac].pmz07) AND NOT cl_null(g_pmz[l_ac].pmz06) THEN
               CALL t800_get_date(g_pmz[l_ac].pmz06,g_ima49) RETURNING g_pmz[l_ac].pmz07
               IF NOT cl_null(g_pmz[l_ac].pmz07) THEN
                  DISPLAY BY NAME g_pmz[l_ac].pmz07
               ELSE
                  NEXT FIELD pmz07
               END IF
           END IF
        #MOD-CB0267 add end   -----
 
        AFTER FIELD pmz07    #到廠日
            IF NOT cl_null(g_pmz[l_ac].pmz07) THEN
                IF g_pmz[l_ac].pmz07 < g_pmz[l_ac].pmz06  THEN
                    CALL cl_err(g_pmz[l_ac].pmz07,'mfg3194',0)
                    LET g_pmz[l_ac].pmz07=g_pmz_t.pmz07
                    #------MOD-5A0095 START----------
                    DISPLAY BY NAME g_pmz[l_ac].pmz07
                    #------MOD-5A0095 END------------
                    NEXT FIELD pmz07
                END IF
            END IF

        #MOD-CB0267 add start -----
        BEFORE FIELD pmz08   #到庫日
           IF cl_null(g_pmz[l_ac].pmz08) AND NOT cl_null(g_pmz[l_ac].pmz07) THEN
               CALL t800_get_date(g_pmz[l_ac].pmz07,g_ima491) RETURNING g_pmz[l_ac].pmz08
               IF NOT cl_null(g_pmz[l_ac].pmz08) THEN
                  DISPLAY BY NAME g_pmz[l_ac].pmz08
               ELSE
                  NEXT FIELD pmz08
               END IF
           END IF
        #MOD-CB0267 add end   -----

        AFTER FIELD pmz08   #到庫日
            IF NOT cl_null(g_pmz[l_ac].pmz08) THEN
                IF g_pmz[l_ac].pmz08 < g_pmz[l_ac].pmz07  THEN
                    CALL cl_err(g_pmz[l_ac].pmz08,'mfg3195',0)
                    LET g_pmz[l_ac].pmz08=g_pmz_t.pmz08
                    NEXT FIELD pmz08
                END IF
            END IF
 
        AFTER FIELD pmz09   #確認數量
            IF NOT cl_null(g_pmz[l_ac].pmz09) THEN
                IF g_pmz[l_ac].pmz09 <= 0 THEN
                    CALL cl_err(g_pmz[l_ac].pmz09,'mfg3348',0)
                    NEXT FIELD pmz09
                END IF
                IF g_pmn14 = 'N' THEN     #部份交貨
                   IF g_pmz[l_ac].pmz09 < g_min THEN
                      CALL cl_err(g_pmz[l_ac].pmz09,'mfg3243',0)
                      LET g_pmz[l_ac].pmz09=g_pmz_t.pmz09
                      NEXT FIELD pmz09
                   END IF
                   IF g_pmz[l_ac].pmz09 > g_way  THEN         #大於容許數量
                      CALL cl_err(g_pmz[l_ac].pmz09,'mfg3196',0)
                      LET g_pmz[l_ac].pmz09=g_pmz_t.pmz09
                      NEXT FIELD pmz09
                   END IF
                ELSE
                   IF g_pmz[l_ac].pmz09 > g_way THEN
                      CALL cl_err(g_pmz[l_ac].pmz09,'mfg3196',0)
                      LET g_pmz[l_ac].pmz09=g_pmz_t.pmz09
                      NEXT FIELD pmz09
                   END IF
                END IF
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_pmz[l_ac].pmz09
                #------MOD-5A0095 END------------
              # CALL t800_pmz11() #genero
            END IF
 
        AFTER FIELD pmz10   #確認人
            IF NOT cl_null(g_pmz[l_ac].pmz10) THEN
                CALL t800_pmz10('a')
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pmz[l_ac].pmz10,g_errno,0)
                    NEXT FIELD pmz10
                END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmz_t.pmz03 > 0 AND
               g_pmz_t.pmz03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM pmz_file
                    WHERE pmz01 = g_pmz01 AND pmz02=g_pmz02 AND
                          pmz03 = g_pmz_t.pmz03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pmz_t.pmz03,SQLCA.sqlcode,0)   #No.FUN-660129
                    CALL cl_err3("del","pmz_file",g_pmz01,g_pmz_t.pmz03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
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
               LET g_pmz[l_ac].* = g_pmz_t.*
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_pmz[l_ac].pmz03,-263,1)
               LET g_pmz[l_ac].* = g_pmz_t.*
            ELSE
                UPDATE pmz_file SET
                       pmz03=g_pmz[l_ac].pmz03,
                       pmz05=g_pmz_t.pmz06,
                       pmz06=g_pmz[l_ac].pmz06,
                       pmz07=g_pmz[l_ac].pmz07,
                       pmz08=g_pmz[l_ac].pmz08,
                       pmz09=g_pmz[l_ac].pmz09,
                       pmz10=g_pmz[l_ac].pmz10,
                       pmz11=g_pmz[l_ac].pmz11,
                       pmz12=g_pmz[l_ac].pmz12,
                       pmz13=g_pmz[l_ac].pmz13
                 WHERE pmz01 = g_pmz01
                   AND pmz02 = g_pmz02
                   AND pmz03 = g_pmz_t.pmz03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_pmz[l_ac].pmz06,SQLCA.sqlcode,0)   #No.FUN-660129
                    CALL cl_err3("upd","pmz_file",g_pmz01,g_pmz_t.pmz03,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_pmz[l_ac].* = g_pmz_t.*
                ELSE
                    #以交期確認日更新採購單單身檔的 [最近確認交貨日期](pmn36)
                    #以預計到廠日更新採購單單身檔的 [最後一次到廠日期](pmn37)
                    UPDATE pmn_file
                       SET pmn36=g_pmz[l_ac].pmz06,
                           pmn37=g_pmz[l_ac].pmz07
                     WHERE pmn01=g_pmz01
                       AND pmn02=g_pmz02
                    IF SQLCA.sqlcode THEN
#                       CALL cl_err('upd pmn',SQLCA.sqlcode,0)   #No.FUN-660129
                        CALL cl_err3("upd","pmn_file",g_pmz01,g_pmz02,SQLCA.sqlcode,"","upd pmn",1)  #No.FUN-660129
                    END IF
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pmz[l_ac].* = g_pmz_t.*
            #FUN-D30034--add--str--
               ELSE
                  CALL g_pmz.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30034--add--end--
               END IF
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034
            CLOSE t800_bcl
            COMMIT WORK
 
#       ON ACTION maintain_memo
#          CALL t800_memo('a')
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pmz06) AND l_ac > 1 THEN
                LET g_pmz[l_ac].* = g_pmz[l_ac-1].*
                NEXT FIELD pmz06
            END IF
 
        ON ACTION CONTROLR
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
    END INPUT
    CLOSE t800_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION t800_pmz10(p_cmd)
  DEFINE  p_cmd    LIKE type_file.chr1,          #No.FUN-680136 VARCHAR(1)
          l_genacti LIKE gen_file.genacti
 
   LET g_errno = " "
   SELECT gen02,genacti INTO g_pmz[l_ac].gen02,l_genacti
     FROM gen_file
    WHERE gen01=g_pmz[l_ac].pmz10
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                   LET g_pmz[l_ac].gen02 = NULL
         WHEN l_genacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY g_pmz[l_ac].gen02 TO s_pmz[l_ac].gen02
 
END FUNCTION
 
FUNCTION t800_b_fill(p_key)              #BODY FILL UP
DEFINE
    p_key           LIKE pmz_file.pmz03,
    l_flag          LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
    DECLARE pmz_cs CURSOR FOR
        SELECT pmz03,pmz05,pmz06,pmz07,pmz08,pmz09,pmz10,gen02,pmz11,pmz12,pmz13
        FROM pmz_file,OUTER gen_file
        WHERE pmz01 = g_pmz01
          AND pmz02 = g_pmz02
          AND pmz_file.pmz10 = gen_file.gen01
        ORDER BY pmz03
 
    CALL g_pmz.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    #單身 ARRAY 填充
    FOREACH pmz_cs INTO g_pmz[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   #No.FUN-660129
            EXIT FOREACH
        END IF
 
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
 
    END FOREACH
    CALL g_pmz.deleteElement(g_cnt)
 
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION t800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmz TO s_pmz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t800_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t800_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t800_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t800_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
    #TQC-6C0050.....begin 
#      ON ACTION query_memo
#         LET g_action_choice="query_memo"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
    #TQC-6C0050.....end
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY  
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#檢查確認人
FUNCTION t800_pass()
 DEFINE  l_gen02  LIKE gen_file.gen02
 
    OPEN WINDOW cl_pass_w WITH FORM "apm/42f/apmt8001"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_locale("apmt8001")
 
    LET g_pmz10=NULL
    WHILE TRUE
        INPUT g_pmz10 WITHOUT DEFAULTS
            FROM pmz10
            AFTER FIELD pmz10
                IF cl_null(g_pmz10) THEN
                    NEXT FIELD pmz10
                ELSE
                    SELECT gen02 INTO l_gen02 FROM gen_file
                      WHERE gen01=g_pmz10 AND genacti IN ('Y','y')
                      IF SQLCA.sqlcode THEN
#                         CALL cl_err(g_pmz10,'mfg3096',0)   #No.FUN-660129
                          CALL cl_err3("sel","gen_file",g_pmz10,"","mfg3096","","",1)  #No.FUN-660129
                          NEXT FIELD pmz10
                      END IF
                      DISPLAY  l_gen02 TO gen02
                END IF
      ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
      #TQC-860019-add
       ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
      #TQC-860019-add
 
      ON ACTION CONTROLG CALL cl_cmdask()
        END INPUT
        IF INT_FLAG THEN
             LET INT_FLAG=0
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
             EXIT PROGRAM
        END IF
        EXIT WHILE
    END WHILE
    CLOSE WINDOW cl_pass_w
END FUNCTION

#MOD-CB0267 add start  -----
#根據日期和前置天數計算到廠和入庫日期
FUNCTION t800_get_date(p_date,p_day)
DEFINE p_date LIKE type_file.dat
DEFINE p_day  LIKE type_file.num5
DEFINE l_date LIKE type_file.dat
DEFINE l_i    LIKE type_file.num5
DEFINE l_flag LIKE type_file.chr1,
       l_dat  LIKE type_file.dat
                      
   LET l_date = NULL      
                          
   FOR l_i = 1 TO p_day   
      IF cl_null(l_date) THEN
         LET l_date = p_date + 1
      ELSE      
         LET l_date = l_date + 1
      END IF
      CALL s_wkday(l_date) RETURNING l_flag,l_dat
      IF l_flag = 1 THEN
         LET l_date = l_dat
      END IF
   END FOR

   IF p_day = 0 THEN RETURN p_date END IF

   RETURN l_date
END FUNCTION
#MOD-CB0267 add end  -----
 
#{
#FUNCTION t800_pmz11()  #詢問是否輸入備註資料
#   DEFINE l_chr		LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
#          l_msg         LIKE ima_file.ima01 	#No.FUN-680136 VARCHAR(40)
# 
#   OPEN WINDOW t800_pmz11_w AT p_row,p_col WITH 3 ROWS, 35 COLUMNS
# 
#   LET g_ans=' '
#   CALL cl_getmsg('mfg3197',g_lang) RETURNING l_msg
#   WHILE ( g_ans=' ' OR g_ans IS NULL OR g_ans NOT MATCHES '[yYnN]' )
#      LET INT_FLAG = 0  ######add for prompt bug
#      PROMPT l_msg CLIPPED FOR CHAR g_ans
#         ON IDLE g_idle_seconds
#            CALL cl_on_idle()
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#      END PROMPT
#      IF INT_FLAG THEN LET INT_FLAG = 0 LET g_ans = "N" END IF
#      CLOSE WINDOW t800_pmz11_w
#   END WHILE
# 
#   IF g_ans MATCHES '[Yy]' THEN
##      CALL t800_memo('a')  #TQC-6C0050
# 
#      IF cl_null(g_pmz11) THEN
#          LET g_pmz[l_ac].b='N'
#      ELSE
#          LET g_pmz[l_ac].b='Y'
#      END IF
##  END IF
#END FUNCTION
#}
 
#輸入備註  #TQC-6C0050.....begin
#FUNCTION t800_memo(p_cmd)
#  DEFINE
#       l_chr   LIKE type_file.chr1,     #No.FUN-680136 VARCHAR(1)
#       l_msg   LIKE type_file.chr1000,	#No.FUN-680136 VARCHAR(60)
#       p_cmd   LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
#
#    OPTIONS  FORM LINE     FIRST + 1
#
#    LET p_row = 14 LET p_col = 4
#    OPEN WINDOW t800_memo AT p_row,p_col
#         WITH FORM "apm/42f/apmt8002"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#
#    CALL cl_ui_locale("apmt8002")
#
#    CALL cl_getmsg('mfg3199',g_lang) RETURNING l_msg
#    DISPLAY l_msg CLIPPED AT 1,1
#    LET g_pmz11 = g_pmz[l_ac].pmz11
#    LET g_pmz12 = g_pmz[l_ac].pmz12
#    LET g_pmz13 = g_pmz[l_ac].pmz13
#    IF p_cmd !='a' THEN
#        DISPLAY  g_pmz11,g_pmz12,g_pmz13 TO pmz11,pmz12,pmz13
#        CALL cl_getmsg('mfg3198',g_lang) RETURNING l_msg
#        LET INT_FLAG = 0  ######add for prompt bug
#        PROMPT l_msg CLIPPED FOR CHAR l_chr
#           ON IDLE g_idle_seconds
#              CALL cl_on_idle()
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
# 
#        END PROMPT
#    ELSE
#      WHILE TRUE
#        INPUT g_pmz11,g_pmz12,g_pmz13 WITHOUT DEFAULTS FROM pmz11,pmz12,pmz13
#         INPUT g_pmz[l_ac].pmz11,g_pmz[l_ac].pmz12,g_pmz[l_ac].pmz13  
#               WITHOUT DEFAULTS FROM pmz11,pmz12,pmz13
# 
#            ON ACTION CONTROLR
#               CALL cl_show_req_fields()
# 
#            ON ACTION CONTROLG CALL cl_cmdask()
#
#            AFTER INPUT
#                IF INT_FLAG THEN
#                   EXIT INPUT
#                END IF
#         END INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0
#         ELSE
#           LET g_pmz[l_ac].pmz11 = g_pmz11
#           LET g_pmz[l_ac].pmz12 = g_pmz12
#           LET g_pmz[l_ac].pmz13 = g_pmz13
#         END IF
#         EXIT WHILE
#      END WHILE
#    END IF
#
#    CLOSE WINDOW t800_memo
#    OPTIONS  FORM LINE     FIRST + 2
# 
#END FUNCTION
   #TQC-6C0050.....end
#Patch....NO.MOD-5A0095 <003,001,002,004> #

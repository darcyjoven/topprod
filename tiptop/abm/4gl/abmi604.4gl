# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi604.4gl
# Descriptions...: 元件取替代資料維護
# Date & Author..: 96/05/31 By Roger
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-4A0338 04/10/27 By Smapmin 以za_file的方式取代PRINT中文字的部份
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-530294 05/03/30 By kim check 元件料號不可以=替代料件
# Modify.........: No.MOD-550167 05/05/23 By Mandy 第一次建取替代資料由abmi600的單身串abmi604會出現錯誤訊息
# Modify.........: No.FUN-580110 05/08/25 By jackie 報表轉XML格式
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5C0046 05/12/26 by kim 在建立取替代件時,主件料號的相關欄位(品名規格單位)沒帶出資料,見貼圖一
# Modify.........: No.FUN-590002 05/12/27 By Monster radio type 應都要給預設值
# Modify.........: No.FUN-590118 06/01/11 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-660173 06/07/04 By Sarah 主件A不應同時有相同的替代料及取代料皆為B的狀況
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-690022 06/09/14 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/13 By baogui 無接下頁
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.CHI-6C0039 07/01/12 By rainy 同一料號生效日，失效日不能重疊
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-730102 07/04/09 By Smapmin 增加資料所有者等欄位
# Modify.........: No.TQC-740145 07/04/19 By johnray
# Modify.........: No.MOD-750016 07/05/03 By pengu 檢核其建立的替代料，是否與主件料號相同
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-7B0080 07/11/14 By lumxa  abmi604新增取替代料時如果維護無效日期，無法維護成功，重新查詢失效日期為空
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-870012 08/06/24 By Duke add apsi325單品/萬用替代料維護
# Modify.........: No.MOD-860023 08/06/03 By claire 若主件打ALL也應該要自動會回寫abmi600中的取替代特性
# Modify.........: No.MOD-850293 08/07/14 By Pengu 當由abmi600串連執行程式時應default bmd02的值
# Modify.........: No.CHI-860017 08/08/26 By sherry 若刪除時，取替代特性不會回寫成 "0.不可取替代"
# Modify.........: No.FUN-860117 08/10/06 By jan 修正CHI-860017 的問題 
# Modify.........: No.CHI-910021 09/01/15 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920075 09/02/23 By xiaofeizhu _curs段之組sql及_b段之lock cursor及_i段的lock cursor及b_fill段的sql不要加有效無效判斷
# Modify.........: No.TQC-960270 09/06/23 By destiny 打印時增加放棄按鈕
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0084 09/10/21 By Smapmin 直接執行該支程式時,才可以update bmb_file
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:FUN-9C0040 10/02/02 By jan 回收料不可做取替代
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40016 10/04/07 By Sarah 新增時應將替代量(bmd07)預設為1
# Modify.........: No:MOD-A50188 10/05/27 By Sarah 刪除主件為ALL的資料時,沒有回寫取替代特性為0.不可取替代
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 規通料件整合(3) 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:TQC-AC0304 10/12/20 By zhangll 针对FUN-AA0059控制增加条件
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B90236 11/11/07 By yuhuabao 新增欄位：取替代特性(bmd02)：增加選項"3.配方替代"；
#                                                               底數(bmd10);回扣料(bmd11)
# Modify.........: No.TQC-C20415 12/02/23 By yuhuabao  abmi600 after 取替代特性時，會自動帶出abmi604，如取替代特性='9'時，abmi604的取替代特性(bmd02)應預設為'3'
# Modify.........: No:MOD-C20159 12/03/01 By ck2yuan 新增,刪除,修改都要呼叫s_uima146 避免非透過abmi600進行取替代而造成abmp603沒計算到
# Modify.........: No:MOD-C30657 12/03/14 By fengrui 修改替代序號bmd03自動累加的抓取條件
# Modify.........: No:MOD-C30538 12/03/15 By zhuhao 判斷主件(bmd08)，需有purity的特性，替代料(bmd04)有設定purity特性的，回扣料(bmd11)不可為"Y" 
# Modify.........: No:MOD-C30357 12/03/16 By zhuhao 配方替代回寫時，應為9
# Modify.........: No.FUN-C30190 12/03/28 By xumeimei 原報表轉CR報表
# Modify.........: No.TQC-C40082 12/04/12 By fengrui 添加單身數組更新
# Modify.........: No.TQC-C40231 12/04/25 By fengrui BUG修改,連續刪除報-400錯誤、刪除后總筆數等於零時報無上下筆資料錯誤
# Modify.........: No:MOD-C70015 12/07/03 By ck2yuan AFTER FIELD bmd04、ON ROW CHANGE 加上檢查卡關abm-021
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-C80197 12/08/31 By ck2yuan MOD-C70015中的ON ROW CHANGE 不需檢核
# Modify.........: No.FUN-C40055 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No.MOD-D20004 13/03/01 By bart 如果刪除後bmd_file還有資料，請回寫剩下的那個取替 or 替代關係回 abmi600
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmd01         LIKE bmd_file.bmd01,   #
    g_bmd08         LIKE bmd_file.bmd08,   #
    g_bmd02         LIKE bmd_file.bmd02,   #
    g_bmd10         LIKE bmd_file.bmd10,   #NO.TQC-B90236 add 
    g_bmd01_t       LIKE bmd_file.bmd01,   #
    g_bmd08_t       LIKE bmd_file.bmd08,   #
    g_bmd02_t       LIKE bmd_file.bmd02,   #
    g_bmd10_t       LIKE bmd_file.bmd10,   #NO.TQC-B90236 add
    g_bmd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
        ima02_b     LIKE ima_file.ima02,        
        ima021_b    LIKE ima_file.ima02,
        bmd11       LIKE bmd_file.bmd11,   #NO.TQC-B90236 add
        bmd05       LIKE bmd_file.bmd05,   #Date
        bmd06       LIKE bmd_file.bmd06,   #Date
        bmd09       LIKE bmd_file.bmd09,   #Date
        bmd07       LIKE bmd_file.bmd07,   #QPA
        ta_bmd01    like bmd_file.ta_bmd01,  #darcy:2023/04/28 add
        bmduser   LIKE bmd_file.bmduser,
        bmdgrup   LIKE bmd_file.bmdgrup,
        bmdmodu   LIKE bmd_file.bmdmodu,
        bmddate   LIKE bmd_file.bmddate,
        bmdacti   LIKE bmd_file.bmdacti
                    END RECORD,
    g_bmd_t         RECORD                 #程式變數 (舊值)
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
        ima02_b     LIKE ima_file.ima02, 
        ima021_b    LIKE ima_file.ima02,
        bmd11       LIKE bmd_file.bmd11,   #NO.TQC-B90236 add
        bmd05       LIKE bmd_file.bmd05,   #Date
        bmd06       LIKE bmd_file.bmd06,   #Date
        bmd09       LIKE bmd_file.bmd09,   #Date
        bmd07       LIKE bmd_file.bmd07,   #QPA
        ta_bmd01    like bmd_file.ta_bmd01,  #darcy:2023/04/28 add
        bmduser   LIKE bmd_file.bmduser,
        bmdgrup   LIKE bmd_file.bmdgrup,
        bmdmodu   LIKE bmd_file.bmdmodu,
        bmddate   LIKE bmd_file.bmddate,
        bmdacti   LIKE bmd_file.bmdacti
                    END RECORD,
    g_bmd04_o       LIKE bmd_file.bmd04,
    g_wc,g_wc2,g_sql    string,            #No.FUN-580092 HCN
    g_delete        LIKE type_file.chr1,   #若刪除資料,則要重新顯示筆數   #No.FUN-680096 VARCHAR(1) 
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680096 SMALLINT
    g_ss            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)  
    g_argv1         LIKE bmd_file.bmd01,
    g_argv2         LIKE bmd_file.bmd08,
    g_argv3         LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
    g_ls            LIKE type_file.chr1,   #No.FUN-580110   #No.FUN-680096 VARCHAR(1) 
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680096 SMALLINT
DEFINE g_cmd        LIKE type_file.chr1000
DEFINE g_flag       LIKE type_file.chr1
DEFINE g_forupd_sql   STRING                  #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5     #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03       #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10    #No.FUN-680096 INTEGER
DEFINE   g_no_ask     LIKE type_file.num5     #No.FUN-680096 SMALLINT
DEFINE   l_table      STRING                  #No.FUN-C30190
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ABM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time 

    #FUN-C30190---add---Begin
    LET g_sql = "l_order1.bmd_file.bmd01,",
                "l_order2.bmd_file.bmd01,",
                "bmd01.bmd_file.bmd01,",
                "bmd08.bmd_file.bmd08,",
                "bmd02.bmd_file.bmd02,",
                "bmd03.bmd_file.bmd03,",
                "bmd04.bmd_file.bmd04,",
                "bmd05.bmd_file.bmd05,",
                "bmd06.bmd_file.bmd06,",
                "bmd07.bmd_file.bmd07"

    LET l_table = cl_prt_temptable('abmi604',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?, ?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    #FUN-C30190---add---End
    LET g_bmd01 = NULL                     #清除鍵值
    LET g_bmd08 = NULL                     #清除鍵值
    LET g_bmd02 = NULL                     #清除鍵值
    LET g_bmd01_t = NULL
    LET g_bmd08_t = NULL
    LET g_bmd02_t = NULL
 
    #取得參數
    LET g_argv1=ARG_VAL(1)	#元件
    IF g_argv1=' ' THEN LET g_argv1='' ELSE LET g_bmd01=g_argv1 END IF
    LET g_argv2=ARG_VAL(2)	#主件
    IF g_argv2=' ' THEN LET g_argv2='' ELSE LET g_bmd08=g_argv2 END IF
    LET g_argv3=ARG_VAL(3)	#UTE
    IF g_argv3 = '9' THEN LET g_argv3 = '3' END IF   #TQC-C20415 add
    IF g_argv3=' ' THEN LET g_argv3='' ELSE LET g_bmd02=g_argv3 END IF
 
    OPEN WINDOW i604_w WITH FORM "abm/42f/abmi604"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL i604_q() END IF
    IF NOT cl_null(g_argv1) AND g_row_count = 0  THEN CALL i604_a() END IF #MOD-550167 add

    CALL s_decl_bmb()           #MOD-C20159 add
 
    LET g_delete='N'
    CALL i604_menu()
    CLOSE WINDOW i604_w                                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN
 
#QBE 查詢資料
FUNCTION i604_cs()
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_bmd.clear() 
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0033

   INITIALIZE g_bmd01 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd08 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd02 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd10 TO NULL    #No.TQC-B90236
    	CONSTRUCT g_wc ON bmd01,bmd08,bmd02,bmd10,bmd03,bmd04,bmd11,ta_bmd01,bmduser,bmdgrup, #NO.TQC-B90236 add bmd10,bmd11
                          bmdmodu,bmddate,bmdacti    #螢幕上取條件
        	FROM bmd01,bmd08,bmd02,bmd10,s_bmd[1].bmd03,s_bmd[1].bmd04,s_bmd[1].bmd11, #NO.TQC-B90236 add bmd10,bmd11
                     s_bmd[1].ta_bmd01,s_bmd[1].bmduser,s_bmd[1].bmdgrup,s_bmd[1].bmdmodu,
                     s_bmd[1].bmddate,s_bmd[1].bmdacti
            #darcy:2023/04/28 add ta_bmd01
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
 
           ON ACTION CONTROLP
               CASE
                   WHEN INFIELD(bmd01)
#FUN-AA0059 --Begin--
                   #     CALL cl_init_qry_var()
                   #     LET g_qryparam.form = "q_ima"
                   #     LET g_qryparam.state = 'c'
                   #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                        DISPLAY g_qryparam.multiret TO bmd01
                        NEXT FIELD bmd01
                   WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                   #     CALL cl_init_qry_var()
                   #     LET g_qryparam.form = "q_ima"
                   #     LET g_qryparam.state = 'c'
                   #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                        DISPLAY g_qryparam.multiret TO bmd08
                        NEXT FIELD bmd08
                   WHEN INFIELD(bmd04)
#FUN-AA0059 --Begin--
                   #     CALL cl_init_qry_var()
                   #     LET g_qryparam.form = "q_ima"
                   #     LET g_qryparam.state = 'c'
                   #     CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                        DISPLAY g_qryparam.multiret TO bmd04
                        NEXT FIELD bmd04
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
 
           ON ACTION qbe_select
              CALL cl_qbe_select()
           ON ACTION qbe_save
	      CALL cl_qbe_save()
 
        END CONSTRUCT
    	IF INT_FLAG THEN RETURN END IF
      ELSE
	LET g_wc=" bmd01='",g_argv1,"'"
	IF NOT cl_null(g_argv2) THEN
	   LET g_wc=g_wc CLIPPED," AND (bmd08='",g_argv2,"' OR bmd08='ALL')"
	END IF
	IF NOT cl_null(g_argv3) THEN
	   LET g_wc=g_wc CLIPPED," AND bmd02='",g_argv3,"'"
	END IF
    END IF
    LET g_sql="SELECT DISTINCT bmd01,bmd08,bmd02,bmd10 FROM bmd_file ",  #TQC-B90236 add bmd10
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bmd01,bmd08,bmd02"
    PREPARE i604_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i604_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i604_prepare
    LET g_sql="SELECT DISTINCT bmd01,bmd08,bmd02 FROM bmd_file WHERE ",
               g_wc CLIPPED
    PREPARE i604_precount FROM g_sql
    DECLARE i604_count CURSOR FOR i604_precount
END FUNCTION
 
FUNCTION i604_menu()
 
    CALL cl_navigator_setting( g_curs_index, g_row_count )
       IF cl_null(g_sma.sma901) OR g_sma.sma901='N' THEN
          CALL cl_set_act_visible("aps_displace_data",FALSE)
       END IF
 
   WHILE TRUE
      CALL i604_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i604_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i604_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i604_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i604_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i604_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i604_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmd01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmd01"
                  LET g_doc.value1  = g_bmd01
                  LET g_doc.column2 = "bmd02"
                  LET g_doc.value2  = g_bmd02
                  LET g_doc.column3 = "bmd08"
                  LET g_doc.value3  = g_bmd08
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmd),'','')
            END IF
        WHEN "aps_displace_data"   
             CALL i325_aps()
 
      END CASE
   END WHILE
 
END FUNCTION
 
#Add  輸入
FUNCTION i604_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bmd.clear()
    INITIALIZE g_bmd01 LIKE bmd_file.bmd01
    INITIALIZE g_bmd08 LIKE bmd_file.bmd08
    INITIALIZE g_bmd02 LIKE bmd_file.bmd02
    IF NOT cl_null(g_argv1) THEN
       LET g_bmd01=g_argv1
       DISPLAY g_bmd01 TO bmd01
       CALL i604_bmd01('a') #TQC-5C0046
    END IF
    IF NOT cl_null(g_argv2) THEN
       LET g_bmd08=g_argv2
       DISPLAY g_bmd08 TO bmd08
       CALL i604_bmd08('a') #TQC-5C0046
    END IF
    IF NOT cl_null(g_argv3) THEN
       LET g_bmd02=g_argv3
       DISPLAY g_bmd02 TO bmd02
    END IF
    LET g_bmd10 = 1                #No.TQC-B90236 add
    DISPLAY g_bmd10 TO bmd10       #No.TQC-B90236 add
    LET  g_bmd01_t = NULL
    LET g_bmd08_t = NULL
    LET g_bmd02_t = NULL
    LET g_bmd10_t =  1         #No.TQC-B90236 add
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        IF cl_null(g_bmd02) THEN    #No.MOD-850293 add
           LET g_bmd02 ='1'
        END IF                      #No.MOD-850293 add
        CALL i604_i("a")                   #輸入單頭
	IF INT_FLAG THEN
           LET g_bmd01=NULL
           LET INT_FLAG=0
           CALL cl_err('',9001,0)
           EXIT WHILE 
        END IF
        CALL g_bmd.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i604_b()                   #輸入單身
        LET g_bmd01_t = g_bmd01            #保留舊值
        LET g_bmd08_t = g_bmd08            #保留舊值
        LET g_bmd02_t = g_bmd02            #保留舊值
        LET g_bmd10_t = g_bmd10          #No.TQC-B90236 add
        EXIT WHILE
    END WHILE
    IF NOT cl_null(g_bmd01) THEN   #TQC-C40231 add
       #CALL s_uima146(g_bmd01)     #MOD-C20159 add  #CHI-D10044
       CALL s_uima146(g_bmd01,0)   #CHI-D10044
    END IF
END FUNCTION
 
FUNCTION i604_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL OR g_bmd08 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmd01_t = g_bmd01
    LET g_bmd08_t = g_bmd08
    LET g_bmd02_t = g_bmd02
    LET g_bmd10_t = g_bmd10   #No.TQC-B90236 add
    WHILE TRUE
        CALL i604_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bmd01=g_bmd01_t
            LET g_bmd08=g_bmd08_t
            LET g_bmd02=g_bmd02_t
            LET g_bmd10=g_bmd10_t  #No.TQC-B90236 add
            DISPLAY g_bmd01 TO bmd01      #單頭
            DISPLAY g_bmd08 TO bmd08      #單頭
            DISPLAY g_bmd02 TO bmd02      #單頭
            DISPLAY g_bmd10 TO bmd10      #No.TQC-B90236 add
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bmd01 != g_bmd01_t OR g_bmd08 != g_bmd08_t OR
           g_bmd02 != g_bmd02_t OR g_bmd10 != g_bmd10_t  THEN #更改單頭值 #No.TQC-B90236 Modify
            UPDATE bmd_file SET bmd01 = g_bmd01,  #更新DB
		                bmd08 = g_bmd08,
		                bmd02 = g_bmd02,
                                bmd10 = g_bmd10    #No.TQC-B90236 add
                WHERE bmd01 = g_bmd01_t          #COLAUTH?
	          AND bmd08 = g_bmd08_t
	          AND bmd02 = g_bmd02_t
                  AND bmd10 = g_bmd10_t            #No.TQC-B90236 add
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_bmd01 CLIPPED,' + ', g_bmd08 CLIPPED
                CALL cl_err3("upd","bmd_file",g_bmd01_t,g_bmd08_t,SQLCA.sqlcode,"",g_msg,1) #TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i604_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,     #a:輸入 u:更改        #No.FUN-680096 VARCHAR(1)
    l_cnt           LIKE type_file.num5,     #No:8209        #No.FUN-680096 SMALLINT
    l_bmd04         LIKE bmd_file.bmd04,
    l_n             LIKE type_file.num5      #FUN-9C0040
DEFINE  l_i         LIKE type_file.num5,     #TQC-B90236 add
        l_sum_bmd07 LIKE bmd_file.bmd07      #TQC-B90236 add
DEFINE  l_num       LIKE type_file.num5      #MOD-C30538 add 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bmd01, g_bmd08, g_bmd02,g_bmd10      #No.TQC-B90236 add g_bmd10
        WITHOUT DEFAULTS
        FROM bmd01,bmd08,bmd02,bmd10             #No.TQC-B90236 add bmd10
 
 
	BEFORE FIELD bmd01  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
        AFTER FIELD bmd01            #
            IF NOT cl_null(g_bmd01) THEN
               #FUN-AA0059 ---------------------add start----------------------
                IF NOT s_chk_item_no(g_bmd01,'') THEN
                   CALL cl_err('',g_errno,1)
                   LET g_bmd01 = g_bmd01_t
                   DISPLAY g_bmd01 TO bmd01
                   NEXT FIELD bmd01
                END IF 
               #FUN-AA0059 -------------------add end-----------------------------
                IF g_bmd01 != g_bmd01_t OR g_bmd01_t IS NULL THEN
                    CALL i604_bmd01('a')
                    IF NOT cl_null(g_errno) THEN
	                IF g_errno='mfg9116' THEN
	                    IF NOT cl_confirm(g_errno) THEN
	                        NEXT FIELD bmd01
	                    END IF
	                ELSE
                            CALL cl_err(g_bmd01,g_errno,0)
                            LET g_bmd01 = g_bmd01_t
                            DISPLAY g_bmd01 TO bmd01
                            NEXT FIELD bmd01
	                END IF
                    END IF
                    #FUN-9C0040--begin--add-----
                    IF NOT cl_null(g_bmd08) THEN
                       LET l_n=0
                       SELECT COUNT(*) INTO l_n FROM bmb_file
                        WHERE bmb01 = g_bmd08
                          AND bmb03 = g_bmd01
                          AND bmb14 = '2'
                       IF l_n > 0 THEN
                          CALL cl_err('','asf-604',0)
                          NEXT FIELD bmd01
                       END IF
                    END IF
                   #FUN-9C0040--end--add------
                END IF
            END IF
 
        AFTER FIELD bmd08            #
	    IF NOT cl_null(g_bmd08) THEN
              #Mark No:TQC-AC0304
              ##FUN-AA0059 -------------------------add start------------------
              # IF NOT s_chk_item_no(g_bmd08,'') THEN
              #    CALL cl_err('',g_errno,1)
              #    LET g_bmd08 = g_bmd08_t
              #    DISPLAY g_bmd08 TO bmd08
              #    NEXT FIELD bmd08
              # END IF 
              ##FUN-AA0059 ------------------------add end-------------------------       
              #End Mark No:TQC-AC0304
                IF g_bmd08 IS NOT NULL THEN
                    CALL i604_bmd08('a')
                    IF NOT cl_null(g_errno) THEN
                       	CALL cl_err(g_bmd08,g_errno,0)
                       	LET g_bmd08 = g_bmd08_t
                       	DISPLAY g_bmd08 TO bmd08
                       	NEXT FIELD bmd08
	            END IF
                    IF g_bmd08 <> 'ALL' THEN
                      #Add No:TQC-AC0304
                      #FUN-AA0059 -------------------------add start------------------
                       IF NOT s_chk_item_no(g_bmd08,'') THEN
                          CALL cl_err('',g_errno,1)
                          LET g_bmd08 = g_bmd08_t
                          DISPLAY g_bmd08 TO bmd08
                          NEXT FIELD bmd08
                       END IF 
                      #FUN-AA0059 ------------------------add end-------------------------       
                      #End Add No:TQC-AC0304
                      SELECT COUNT(*) INTO l_cnt FROM bmb_file
                      WHERE bmb03 = g_bmd01 AND bmb01 = g_bmd08
                      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
                      IF l_cnt = 0 THEN
                         CALL cl_err(g_bmd01,'abm-742',1)
                      END IF
                   END IF
 
                #FUN-9C0040--begin--add-----
                    IF NOT cl_null(g_bmd01) THEN
                       LET l_n=0
                       SELECT COUNT(*) INTO l_n FROM bmb_file
                        WHERE bmb01 = g_bmd08
                          AND bmb03 = g_bmd01
                          AND bmb14 = '2'
                       IF l_n > 0 THEN
                          CALL cl_err('','asf-603',0)
                          NEXT FIELD bmd08
                       END IF
                     END IF
                   #FUN-9C0040--end--add------
                END IF
            END IF
        AFTER FIELD bmd02            #
	    IF NOT cl_null(g_bmd02) THEN
	        IF g_bmd02 NOT MATCHES '[123]' THEN NEXT FIELD bmd02 END IF
                #MOD-C30538 -- add -- begin
                IF g_bmd02 = '3' THEN
                   LET l_num = 0
                   SELECT COUNT(*) INTO l_num FROM imac_file
                    WHERE imac01 = g_bmd08
                      AND imac04 = 'purity'
                   IF l_num = 0 THEN
                      CALL cl_err('','abm1003',0)
                      LET g_bmd02 = g_bmd02_t
                      NEXT FIELD bmd02
                   END IF
                END IF
                #MOD-C30538 -- add -- end
                SELECT count(*) INTO g_cnt FROM bmd_file
                    WHERE bmd01 = g_bmd01
                      AND bmd08 = g_bmd08
                      AND bmd02 = g_bmd02
                      AND bmdacti = 'Y'                                           #CHI-910021
                IF g_cnt > 0 THEN   #資料重複
	            LET g_msg = g_bmd01 CLIPPED,' + ', g_bmd08 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_bmd01 = g_bmd01_t
                    LET g_bmd08 = g_bmd08_t
                    DISPLAY  g_bmd01 TO bmd01
                    DISPLAY  g_bmd08 TO bmd08
                    NEXT FIELD bmd01
                END IF
            END IF
#TQC-B90236-----------add----------begin
         ON CHANGE bmd02
            IF g_bmd02 = '3' THEN
               CALL cl_set_comp_entry("bmd10",TRUE)
               CALL cl_set_comp_required("bmd10",TRUE)
            ELSE
               CALL cl_set_comp_entry("bmd10",FALSE)
               CALL cl_set_comp_required("bmd10",FALSE)
            END IF
#TQC-B90236-----------add----------end

#TQC-B90236-----------add----------begin
         BEFORE FIELD bmd10
            IF g_bmd02 = '3' THEN
               CALL cl_set_comp_entry("bmd10",TRUE)
               CALL cl_set_comp_required("bmd10",TRUE)
            ELSE
               CALL cl_set_comp_entry("bmd10",FALSE)
               CALL cl_set_comp_required("bmd10",FALSE)
            END IF

         AFTER FIELD bmd10
            IF g_bmd02 = '3' AND g_bmd10<=0  THEN
                CALL cl_err('','art-040',0)
                LET g_bmd10 = g_bmd10_t
                DISPLAY g_bmd10 TO bmd10
                NEXT FIELD bmd10
            END IF
#TQC-B90236-----------add----------end
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmd01)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.default1 = g_bmd01
                  #   CALL cl_create_qry() RETURNING g_bmd01
                     CALL q_sel_ima(FALSE, "q_ima", "", g_bmd01, "", "", "", "" ,"",'' )  RETURNING g_bmd01
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_bmd01
                     CALL i604_bmd01('d')
                     NEXT FIELD bmd01
                WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.default1 = g_bmd08
                  #   CALL cl_create_qry() RETURNING g_bmd08
                     CALL q_sel_ima(FALSE, "q_ima", "", g_bmd08, "", "", "", "" ,"",'' )  RETURNING g_bmd08
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_bmd08
                     CALL i604_bmd08('d')
                     NEXT FIELD bmd08
                OTHERWISE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION controlg       #TQC-860021
           CALL cl_cmdask()      #TQC-860021
 
        ON IDLE g_idle_seconds   #TQC-860021
           CALL cl_on_idle()     #TQC-860021
           CONTINUE INPUT        #TQC-860021
 
        ON ACTION about          #TQC-860021
           CALL cl_about()       #TQC-860021
 
        ON ACTION help           #TQC-860021
           CALL cl_show_help()   #TQC-860021 
    END INPUT
#TQC-B90236------add------begin
    IF g_bmd.getLength() > 0 THEN
       LET l_sum_bmd07 = 0
       FOR l_i = 1 TO g_bmd.getLength()
          LET l_sum_bmd07 = l_sum_bmd07 + g_bmd[l_i].bmd07
       END FOR  
       IF l_sum_bmd07<>g_bmd10 THEN
          IF cl_confirm('abm1001') THEN
              CALL i604_b()
          ELSE
             LET g_bmd10 = g_bmd10_t
             DISPLAY g_bmd10 TO bmd10
          END IF
       END IF
    END IF
#TQC-B90236------add------end
END FUNCTION
 
FUNCTION i604_bmd01(p_cmd)  #
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bmd01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021 = NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 
         WHEN l_ima08 NOT MATCHES '[PVZS]' LET g_errno = 'mfg9116'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' OR g_errno = 'mfg9116'  #MOD-550167
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h
           DISPLAY l_ima021 TO FORMONLY.ima021_h
           DISPLAY l_ima25 TO FORMONLY.ima25_h
           DISPLAY l_ima08 TO FORMONLY.ima08_h
    END IF
END FUNCTION
 
FUNCTION i604_bmd08(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
	IF g_bmd08=g_bmd01 THEN LET g_errno='mfg2633' RETURN END IF
	IF g_bmd08='all' THEN
		LET g_bmd08='ALL'
		DISPLAY g_bmd08 TO bmd08
	END IF
	IF g_bmd08='ALL' THEN
      DISPLAY '' TO FORMONLY.ima02_h2
      DISPLAY '' TO FORMONLY.ima021_h2
      DISPLAY '' TO FORMONLY.ima25_h2
      DISPLAY '' TO FORMONLY.ima08_h2
		RETURN END IF
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bmd08
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021= NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h2
           DISPLAY l_ima25 TO FORMONLY.ima25_h2
           DISPLAY l_ima021 TO FORMONLY.ima021_h2
           DISPLAY l_ima08 TO FORMONLY.ima08_h2
    END IF
	IF NOT cl_null(g_errno) THEN
      DISPLAY '' TO FORMONLY.ima02_h2
      DISPLAY '' TO FORMONLY.ima021_h2
      DISPLAY '' TO FORMONLY.ima25_h2
      DISPLAY '' TO FORMONLY.ima08_h2
	END IF
END FUNCTION
 
#Query 查詢
FUNCTION i604_q()
  DEFINE l_bmd01  LIKE bmd_file.bmd01,
         l_bmd08  LIKE bmd_file.bmd08,
         l_bmd02  LIKE bmd_file.bmd02,
         l_cnt    LIKE type_file.num10   #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmd01 TO NULL        #No.FUN-6A0002
    INITIALIZE g_bmd08 TO NULL        #No.FUN-6A0002        
    INITIALIZE g_bmd02 TO NULL        #No.FUN-6A0002
    INITIALIZE g_bmd10 TO NULL        #No.TQC-B90236
    MESSAGE ""
    CALL cl_opmsg('q')
    CALL i604_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bmd01 TO NULL
        INITIALIZE g_bmd08 TO NULL
        INITIALIZE g_bmd02 TO NULL
        INITIALIZE g_bmd10 TO NULL  #No.TQC-B90236
        RETURN
    END IF
    OPEN i604_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        INITIALIZE g_bmd01 TO NULL
        INITIALIZE g_bmd08 TO NULL
        INITIALIZE g_bmd02 TO NULL
        INITIALIZE g_bmd10 TO NULL  #No.TQC-B90236
    ELSE
        FOREACH i604_count INTO l_bmd01,l_bmd08,l_bmd02
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        IF NOT cl_null(g_argv1) AND g_row_count = 0 THEN
            RETURN
        END IF
        CALL i604_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i604_fetch(p_flag)
DEFINE
    p_flag   LIKE type_file.chr1        #處理方式   #No.FUN-680096 VARCHAR(1)
  DEFINE l_bmd01  LIKE bmd_file.bmd01,
         l_bmd08  LIKE bmd_file.bmd08,
         l_bmd02  LIKE bmd_file.bmd02,
         l_bmd10  LIKE bmd_file.bmd10   #TQC-B90236 add
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i604_bcs INTO g_bmd01,g_bmd08,g_bmd02,g_bmd10 #TQC-B90236 add g_bmd10
        WHEN 'P' FETCH PREVIOUS i604_bcs INTO g_bmd01,g_bmd08,g_bmd02,g_bmd10 #TQC-B90236 add g_bmd10
        WHEN 'F' FETCH FIRST    i604_bcs INTO g_bmd01,g_bmd08,g_bmd02,g_bmd10 #TQC-B90236 add g_bmd10
        WHEN 'L' FETCH LAST     i604_bcs INTO g_bmd01,g_bmd08,g_bmd02,g_bmd10 #TQC-B90236 add g_bmd10
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
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            LET g_no_ask = FALSE
            FETCH ABSOLUTE g_jump i604_bcs INTO g_bmd01,g_bmd08,g_bmd02,g_bmd10 #TQC-B90236 add g_bmd10
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_bmd01,SQLCA.sqlcode,1)
        INITIALIZE g_bmd01 TO NULL  #TQC-6B0105
        INITIALIZE g_bmd02 TO NULL  #TQC-6B0105
        INITIALIZE g_bmd08 TO NULL  #TQC-6B0105
        INITIALIZE g_bmd10 TO NULL  #TQC-B90236
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
    CALL i604_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i604_show()
    DISPLAY g_bmd01 TO bmd01      #單頭
    DISPLAY g_bmd08 TO bmd08      #單頭
    DISPLAY g_bmd02 TO bmd02      #單頭
    DISPLAY g_bmd10 TO bmd10      #No.TQC-B90236 add
    CALL i604_bmd01('d')
    CALL i604_bmd08('d')
    CALL i604_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i604_r()
  DEFINE l_bmd01  LIKE bmd_file.bmd01,
         l_bmd08  LIKE bmd_file.bmd08,
         l_bmd02  LIKE bmd_file.bmd02
  DEFINE l_n      LIKE type_file.num5     #No.CHI-860017
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL THEN
       CALL cl_err("",-400,0)              #No.FUN-6A0002
       RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmd01"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bmd01      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bmd02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_bmd02      #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "bmd08"      #No.FUN-9B0098 10/02/24
        LET g_doc.value3  = g_bmd08      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bmd_file
         WHERE bmd01=g_bmd01 AND bmd08=g_bmd08 AND bmd02=g_bmd02
        IF SQLCA.sqlcode THEN
             CALL cl_err3("del","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","BODY DELETE",1)   #TQC - 660046 
        ELSE
            DELETE FROM vmq_file
             WHERE vmq01=g_bmd08 and vmq02=g_bmd01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","BODY DELETE",1)
            END IF
            CLEAR FORM
            CALL g_bmd.clear()
            LET g_row_count = 0
            FOREACH i604_count INTO l_bmd01,l_bmd08,l_bmd02
                LET g_row_count = g_row_count + 1
            END FOREACH
            #TQC-C40231--mark--str--
            ##FUN-B50062-add-start--
            #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            #   CLOSE i604_bcs
            #   CLOSE i604_count
            #   COMMIT WORK
            #   RETURN
            #END IF
            ##FUN-B50062-add-end--
            #TQC-C40231--mark--end--
            
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i604_bcs
            IF cl_null(g_argv1) THEN   #MOD-9A0084
               IF g_bmd08 <> 'ALL' THEN   #要刪除的主件不是ALL
                  SELECT COUNT(*) INTO l_n FROM bmd_file 
                   #WHERE bmd01=g_bmd01 AND bmd08 = 'ALL'  #MOD-D20004
                   WHERE bmd01=g_bmd01 AND (bmd08 = 'ALL' OR bmd08=g_bmd08)  #MOD-D20004
                     AND bmdacti = 'Y'                                           #CHI-910021  
                   #取替代資料裡沒有建立主件為ALL的資料,所以可直接回寫該元件的bmb16
                   IF l_n = 0 THEN
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate = g_today     #FUN-C40055 add
                       WHERE bmb01=g_bmd08 AND bmb03=g_bmd01
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                       END IF
                   END IF
                   #MOD-D20004---begin
                   IF l_n = 1 THEN 
                      SELECT bmd02 INTO l_bmd02
                        FROM bmd_file 
                       WHERE bmd01=g_bmd01 AND (bmd08 = 'ALL' OR bmd08=g_bmd08)
                         AND bmdacti = 'Y' 
                         
                      UPDATE bmb_file SET bmb16 = l_bmd02
                       WHERE bmb01=g_bmd08 AND bmb03=g_bmd01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                      END IF      
                   END IF    
                   #MOD-D20004---end
               ELSE                       #要刪除的主件是ALL 
               	 SELECT COUNT(*) INTO l_n FROM bmd_file 
                   WHERE bmd01=g_bmd01 AND bmd08 <> 'ALL'
                     AND bmdacti = 'Y'                                          #CHI-910021  
                   #取替代資料裡沒有建立主件不為ALL的資料(表示只有ALL的這筆),所以可直接回寫該元件的bmb16
                   IF l_n = 0 THEN
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate = g_today     #FUN-C40055 add
                     # WHERE bmb01=g_bmd08 AND bmb03=g_bmd01  #MOD-A50188 mark
                       WHERE bmb03=g_bmd01                    #MOD-A50188
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                       END IF
                  #str MOD-A50188 add
                   ELSE
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate = g_today     #FUN-C40055 add
                       WHERE bmb01 NOT IN (SELECT bmd08 FROM bmd_file WHERE bmd01=g_bmd01 AND bmd08 != 'ALL') 
                         AND bmb03=g_bmd01
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                       END IF
                  #end MOD-A50188 add
                   END IF
               END IF
            END IF   #MOD-9A0084
            #CALL s_uima146(g_bmd01)  #MOD-C20159 add  #TQC-C40231 add  #CHI-D10044
            CALL s_uima146(g_bmd01,0)  #CHI-D10044
            IF g_row_count >= 1 THEN         #TQC-C40231 add
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL i604_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET g_no_ask = TRUE
                  CALL i604_fetch('/')
               END IF
            ELSE
               #TQC-C40231--add--str--
               LET g_bmd01 = NULL
               LET g_bmd08 = NULL
               LET g_bmd02 = NULL
               LET g_bmd10 = NULL
               #TQC-C40231--add--end--
            END IF
            
            LET g_delete='Y'
            #TQC-C40231--mark--str--
            #LET g_bmd01 = NULL
            #LET g_bmd08 = NULL
            #LET g_bmd02 = NULL
            #LET g_bmd10 = NULL
            #LET g_cnt=SQLCA.SQLERRD[3]
            #MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #TQC-C40231--mark--end--
            MESSAGE 'DELETE O.K'  #TQC-C40231 add
        END IF
    END IF
    #CALL s_uima146(g_bmd01)  #MOD-C20159 add  #TQC-C40231 mark
END FUNCTION
 
 
#單身
FUNCTION i604_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_n             LIKE type_file.num5,     #檢查重複用    #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否    #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否    #No.FUN-680096 SMALLINT
    l_cnt           LIKE type_file.num5      #FUN-660173 add    #No.FUN-680096 SMALLINT
DEFINE  l_n1        LIKE type_file.num5      #No.CHI-860017
DEFINE  l_i         LIKE type_file.num5,     #No.TQC-B90236
        l_sum_bmd07 LIKE bmd_file.bmd07      #No.TQC-B90236
DEFINE  l_num       LIKE type_file.num5      #MOD-C30538
DEFINE  l_bmd02     LIKE bmd_file.bmd02      #MOD-D20004

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT bmd03,bmd04,'','',bmd11,bmd05,bmd06,bmd09,bmd07, ",   #TQC-B90236 add bmd11
      "        ta_bmd01,bmduser,bmdgrup,bmdmodu,bmddate,bmdacti ",   #TQC-730102 #darcy:2023/04/28 add ta_bmd01
      " FROM bmd_file ",
      "  WHERE bmd01 = ? ",
      "   AND bmd08 = ? ",
      "   AND bmd02 = ? ",
      "   AND bmd03 = ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i604_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_bmd
              WITHOUT DEFAULTS
              FROM s_bmd.*
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
               LET p_cmd='u'
               LET g_bmd_t.* = g_bmd[l_ac].*  #BACKUP
               LET g_bmd04_o = g_bmd[l_ac].bmd04  #BACKUP
                BEGIN WORK
                OPEN i604_bcl USING g_bmd01,g_bmd08,g_bmd02,g_bmd_t.bmd03
                IF STATUS THEN
                    CALL cl_err("OPEN i604_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i604_bcl INTO g_bmd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmd_t.bmd03,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_bmd[l_ac].ima02_b=g_bmd_t.ima02_b
                    LET g_bmd[l_ac].ima021_b=g_bmd_t.ima021_b
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#TQC-B90236--------add--------begin
            IF g_bmd02 = '3' THEN
               CALL cl_set_comp_entry("bmd11",TRUE)
            ELSE
               LET g_bmd[l_ac].bmd11 = 'N'
               #darcy:2023/04/28 add s---
               if p_cmd != 'u' then
                let g_bmd[l_ac].ta_bmd01 = 'N'
               end if
               #darcy:2023/04/28 add e---
               DISPLAY BY NAME g_bmd[l_ac].bmd11,g_bmd[l_ac].ta_bmd01 #darcy:2023/04/28 add ta_bmd01
               CALL cl_set_comp_entry("bmd11",FALSE)
               
            END IF
#TQC-B90236--------add--------end 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO bmd_file
              (bmd01, bmd02, bmd03, bmd04,
               bmd05, bmd06, bmd07, bmd08, bmd09,bmd10,bmd11,     #TQC-B90236 add bmd10,bmd11
               ta_bmd01,   #darcy:2023/04/28 add
               bmduser,bmdgrup,bmddate,bmdacti,bmdoriu,bmdorig)   #TQC-730102 
            VALUES(g_bmd01,g_bmd02,
                   g_bmd[l_ac].bmd03,g_bmd[l_ac].bmd04,
                   g_bmd[l_ac].bmd05,g_bmd[l_ac].bmd06,g_bmd[l_ac].bmd07,g_bmd08,   #TQC-7B0080
                   g_bmd[l_ac].bmd09,g_bmd10,g_bmd[l_ac].bmd11,                     #TQC-B90236 
                   g_bmd[l_ac].ta_bmd01,  #darcy:2023/04/28 add
                   g_bmd[l_ac].bmduser,g_bmd[l_ac].bmdgrup,   #TQC-730102
                   g_bmd[l_ac].bmddate,g_bmd[l_ac].bmdacti, g_user, g_grup)   #TQC-730102      #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmd_file",g_bmd01,g_bmd[l_ac].bmd03,SQLCA.sqlcode,"","",1)       # TQC-660046   
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               IF cl_null(g_argv1) THEN   #MOD-9A0084
                 #MOD-C30357 -- add -- begin
                  IF g_bmd02 = '3' THEN
                     LET g_bmd02 = '9'
                  END IF
                 #MOD-C30357 -- add -- end
                  IF g_bmd08 = 'ALL' THEN
                     IF cl_confirm('abm-030') THEN
                        UPDATE bmb_file SET bmb16=g_bmd02,
                                            bmbdate = g_today     #FUN-C40055 add 
                                  WHERE bmb03=g_bmd01
                     END IF
                  ELSE
                    #UPDATE bmb_file SET bmb16=g_bmd02 WHERE                  #FUN-C40055 mark
                     UPDATE bmb_file SET bmb16=g_bmd02,bmbdate=g_today WHERE  #FUN-C40055 add
                     bmb01=g_bmd08 AND bmb03=g_bmd01
                  END IF
                END IF   #MOD-9A0084
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
	        COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmd[l_ac].* TO NULL      #900423
            LET g_bmd[l_ac].bmd05=TODAY
            LET g_bmd[l_ac].bmd07=1               #MOD-A40016 add
            LET g_bmd[l_ac].bmd11='N'             #TQC-B90236 add
            let g_bmd[l_ac].ta_bmd01='N'          #darcy:2023/04/28 add
           #str MOD-A40016 mark
           #DECLARE  i604_qpa_2 CURSOR FOR
           #   SELECT bmb06/bmb07
           #     FROM bmb_file
           #    WHERE bmb01 = g_bmd08 AND bmb03 = g_bmd01
           #FOREACH i604_qpa_2 INTO g_bmd[l_ac].bmd07
           #   IF SQLCA.sqlcode THEN
           #      CALL cl_err('i604_qpa',SQLCA.sqlcode,0)
           #   END IF
           #   EXIT FOREACH
           #END FOREACH
           #IF STATUS OR cl_null(g_bmd[l_ac].bmd07) THEN
           #   LET g_bmd[l_ac].bmd07=1
           #END IF
           #end MOD-A40016 mark
            LET g_bmd[l_ac].bmduser = g_user
            LET g_bmd[l_ac].bmdgrup = g_grup
            LET g_bmd[l_ac].bmddate = g_today
            LET g_bmd[l_ac].bmdacti = 'Y'
            LET g_bmd_t.* = g_bmd[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmd03
 
        BEFORE FIELD bmd03                        #default 序號
            IF p_cmd='a' THEN
                SELECT max(bmd03)+1
                   INTO g_bmd[l_ac].bmd03
                   FROM bmd_file
                   WHERE bmd01=g_bmd01 AND bmd08=g_bmd08 AND bmd02=g_bmd02
                   #  AND bmdacti = 'Y'                      #CHI-910021  #MOD-C30657 mark
                IF g_bmd[l_ac].bmd03 IS NULL THEN
                    LET g_bmd[l_ac].bmd03 = 1
                END IF
            END IF
 
        AFTER FIELD bmd03                        #check 序號是否重複
            IF NOT cl_null(g_bmd[l_ac].bmd03) THEN
                IF g_bmd[l_ac].bmd03 != g_bmd_t.bmd03 OR
                   g_bmd_t.bmd03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bmd_file
                        WHERE bmd01 = g_bmd01
                          AND bmd08 = g_bmd08
                          AND bmd02 = g_bmd02
                          AND bmd03 = g_bmd[l_ac].bmd03
                    #      AND bmdacti = 'Y'                    #CHI-910021 #MOD-C30657 mark
                    IF l_n > 0 THEN
                       CALL cl_err(g_bmd[l_ac].bmd03,-239,0)
                       LET g_bmd[l_ac].bmd03 = g_bmd_t.bmd03
                       NEXT FIELD bmd03
                    END IF
                END IF
            END IF
 
         AFTER FIELD bmd04
             IF NOT cl_null(g_bmd[l_ac].bmd04) THEN
               #FUN-AA0059 ------------------------add start----------------
                IF NOT s_chk_item_no(g_bmd[l_ac].bmd04,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bmd04
                END IF 
               #FUN-AA0059 ------------------------add end----------------------- 
               #檢查替代料，是否與主件料號相同
                IF g_bmd[l_ac].bmd04 = g_bmd08 THEN
                   CALL cl_err(g_bmd[l_ac].bmd04,'abm-126',1)
                   NEXT FIELD bmd04
                END IF
               #合理性的檢查,元件A不應同時有相同的替代料及取代料皆為B的狀況
                IF g_bmd02='1' THEN
                   SELECT COUNT(*) INTO l_cnt FROM bmd_file
                    WHERE bmd01=g_bmd01 
                      AND bmd08=g_bmd08
                      AND bmd04=g_bmd[l_ac].bmd04
                      AND bmd02='2'
                      AND bmdacti = 'Y'                                           #CHI-910021 
                ELSE
                   SELECT COUNT(*) INTO l_cnt FROM bmd_file
                    WHERE bmd01=g_bmd01
                      AND bmd08=g_bmd08 
                      AND bmd04=g_bmd[l_ac].bmd04
                      AND bmd02='1'
                      AND bmdacti = 'Y'                                           #CHI-910021 
                END IF
                IF l_cnt > 0 THEN
                   CALL cl_err_msg("","abm-205",g_bmd01 CLIPPED|| "|" || g_bmd[l_ac].bmd04 CLIPPED,10)
                   NEXT FIELD bmd04
                END IF 
 
                 IF g_bmd[l_ac].bmd04=g_bmd01 THEN
                    CALL cl_err('','abm-804',0) NEXT FIELD bmd04
                 END IF
                 SELECT ima02,ima021 INTO g_bmd[l_ac].ima02_b,g_bmd[l_ac].ima021_b
                   FROM ima_file
                  WHERE ima01=g_bmd[l_ac].bmd04                                                     
                 IF STATUS THEN
                     CALL cl_err3("sel","ima_file",g_bmd[l_ac].bmd04,"",STATUS,"","sel ima:",1)    #TQC-660046
                     NEXT FIELD bmd04
                 END IF
               #MOD-C30538 -- add - begin
                 IF g_bmd[l_ac].bmd11 = 'Y' THEN
                    LET l_num = 0
                    SELECT COUNT(*) INTO l_num FROM imac_file
                     WHERE imac01 = g_bmd[l_ac].bmd04
                       AND imac04 = 'purity'
                    IF l_num > 0 THEN
                       CALL cl_err('','abm1004',0)
                       NEXT FIELD bmd11
                    END IF
                 END IF
               #MOD-C30538 -- add - end
             END IF
            #MOD-C70015 str add-----
             IF NOT cl_null(g_bmd[l_ac].bmd05) THEN
                CALL i604_chk_date_range('b')
                IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD bmd05
                END IF
             END IF
            #MOD-C70015 end add-----
 
        AFTER FIELD bmd05
          CALL i604_chk_date_range('b')
          IF NOT cl_null(g_errno) THEN
            CALL cl_err('',g_errno,0)
            NEXT FIELD bmd05
          END IF
 
        AFTER FIELD bmd06
             IF NOT cl_null(g_bmd[l_ac].bmd06) THEN
                IF g_bmd[l_ac].bmd06 < g_bmd[l_ac].bmd05 THEN
                   CALL cl_err(g_bmd[l_ac].bmd06,'mfg2604',0)
                   NEXT FIELD bmd06
                END IF
             END IF
 
            CALL i604_chk_date_range('e')
            IF NOT cl_null(g_errno) THEN
              CALL cl_err('',g_errno,0)
              NEXT FIELD bmd06
            END IF
 
        AFTER FIELD bmd07
           IF g_bmd[l_ac].bmd07 < 0 THEN
              CALL cl_err('','mfg4012',0)
              NEXT FIELD bmd07
           END IF

#TQC-B90236--------add--------begin

        AFTER FIELD bmd11
           IF g_bmd[l_ac].bmd11='Y' AND g_bmd02 = '3' THEN
              IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_bmd[l_ac].bmd11 != g_bmd_t.bmd11) THEN
                 SELECT COUNT(*) INTO l_n FROM bmd_file
                  WHERE bmd01 = g_bmd01
                    AND bmd02 = g_bmd02
                    AND bmd08 = g_bmd08
                    AND bmd11 = g_bmd[l_ac].bmd11
                 IF l_n > 0 THEN
                     CALL cl_err('','abm1000',0)
                     LET g_bmd[l_ac].bmd11 = g_bmd_t.bmd11
                     DISPLAY BY NAME g_bmd[l_ac].bmd11
                     NEXT FIELD bmd11
                 END IF
              END IF
           END IF
          #MOD-C30538 -- add - begin
           IF (g_bmd[l_ac].bmd11 = 'Y') AND (NOT cl_null(g_bmd[l_ac].bmd04)) THEN
              LET l_num = 0
              SELECT COUNT(*) INTO l_num FROM imac_file
               WHERE imac01 = g_bmd[l_ac].bmd04
                 AND imac04 = 'purity'
              IF l_num > 0 THEN
                 CALL cl_err('','abm1004',0)
                 NEXT FIELD bmd11
              END IF
           END IF
          #MOD-C30538 -- add - end
#TQC-B90236--------add--------end

        #darcy:2023/04/28 add s---
        after field ta_bmd01
            if g_bmd[l_ac].ta_bmd01 = 'Y' then
                # 一笔取替代料,只能标记一个自动取替代
                let l_cnt = 0
                select count(1) into l_cnt from bmd_file 
                 where bmd01 = g_bmd01
                   and bmd08 = g_bmd08
                   and bmd02 = g_bmd02
                   and bmd04 != g_bmd[l_ac].bmd04
                   and ta_bmd01 = 'Y'
                if l_cnt > 0 then
                    call cl_err('','cbm-020',0)
                    next field ta_bmd01
                end if
            end if
        #darcy:2023/04/28 add e---
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmd_t.bmd03 > 0 AND
               g_bmd_t.bmd03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bmd_file
                    WHERE bmd01 = g_bmd01
                      AND bmd08 = g_bmd08
                      AND bmd02 = g_bmd02
                      AND bmd03 = g_bmd_t.bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)     #TQC-660046           
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM vmq_file
                    WHERE vmq01 = g_bmd08
                      AND vmq02 = g_bmd01
                      AND vmq03 = g_bmd_t.bmd04
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","vmq_file",g_bmd08,g_bmd01,SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                IF cl_null(g_argv1) THEN   #MOD-9A0084
                   IF g_bmd08 <> 'ALL' THEN
                      SELECT COUNT(*) INTO l_n1 FROM bmd_file 
                       WHERE bmd01=g_bmd01 AND (bmd08 = 'ALL' OR bmd08=g_bmd08)      #FUN-860117
                         AND bmdacti = 'Y'                                           #CHI-910021 
                       IF l_n1 = 0 THEN
                          UPDATE bmb_file SET bmb16 = '0',
                                              bmbdate = g_today     #FUN-C40055 add
                           WHERE bmb01=g_bmd08 AND bmb03=g_bmd01                    
                           IF SQLCA.sqlcode THEN
                              CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                           END IF
                       END IF
                      #MOD-D20004---begin
                      IF l_n1 = 1 THEN
                         SELECT bmd02 INTO l_bmd02
                           FROM bmd_file 
                          WHERE bmd01=g_bmd01 AND (bmd08 = 'ALL' OR bmd08=g_bmd08)
                            AND bmdacti = 'Y' 
                           
                         UPDATE bmb_file SET bmb16 = l_bmd02
                          WHERE bmb01=g_bmd08 AND bmb03=g_bmd01
                         IF SQLCA.sqlcode THEN
                            CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                         END IF 
                      END IF          
                      #MOD-D20004---end
                   ELSE 
            	       SELECT COUNT(*) INTO l_n1 FROM bmd_file 
                      WHERE bmd01=g_bmd01 AND (bmd08 <> 'ALL' OR bmd08=g_bmd08)   #FUN-860117
                        AND bmdacti = 'Y'                                           #CHI-910021
                      IF l_n1 = 0 THEN
                         UPDATE bmb_file SET bmb16 = '0',
                                             bmbdate = g_today     #FUN-C40055 add
                          WHERE bmb01=g_bmd08 AND bmb03=g_bmd01
                          IF SQLCA.sqlcode THEN
                             CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                          END IF
                      END IF
                   END IF
                END IF   #MOD-9A0084
	        COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmd[l_ac].* = g_bmd_t.*
               CLOSE i604_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmd[l_ac].bmd03,-263,1)
               LET g_bmd[l_ac].* = g_bmd_t.*
            ELSE
                LET g_bmd[l_ac].bmdmodu=g_user   #TQC-730102
                LET g_bmd[l_ac].bmddate=g_today  #TQC-730102
                UPDATE bmd_file SET
                       bmd03=g_bmd[l_ac].bmd03,
                       bmd04=g_bmd[l_ac].bmd04,
                       bmd05=g_bmd[l_ac].bmd05,
                       bmd06=g_bmd[l_ac].bmd06,
                       bmd07=g_bmd[l_ac].bmd07,
                       bmd09=g_bmd[l_ac].bmd09,
                       bmd11=g_bmd[l_ac].bmd11,        #TQC-B90236 add
                       ta_bmd01 = g_bmd[l_ac].ta_bmd01, #darcy:2023/04/28 add
                       bmdmodu=g_bmd[l_ac].bmdmodu,   #TQC-730102
                       bmddate=g_bmd[l_ac].bmddate,   #TQC-730102
                       bmdacti=g_bmd[l_ac].bmdacti    #TQC-730102
                 WHERE bmd01=g_bmd01
                   AND bmd08=g_bmd08
                   AND bmd02=g_bmd02
                   AND bmd03=g_bmd_t.bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bmd_file",g_bmd01,g_bmd_t.bmd03,SQLCA.sqlcode,"","",1)         #TQC-660046   
                    LET g_bmd[l_ac].* = g_bmd_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	            COMMIT WORK
                END IF
            END IF
          #MOD-C80197 str mark-----
          ##MOD-C70015 str add-----
          # IF NOT cl_null(g_bmd[l_ac].bmd05) THEN
          #    CALL i604_chk_date_range('b')
          #    IF NOT cl_null(g_errno) THEN
          #      CALL cl_err('',g_errno,0)
          #      NEXT FIELD bmd05
          #    END IF
          # END IF
          ##MOD-C70015 end add-----
          #MOD-C80197 end mark-----
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bmd[l_ac].* = g_bmd_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmd.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i604_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            #MOD-C20159 str add-----
            IF g_bmd_t.bmd04 <> g_bmd[l_ac].bmd04 OR cl_null(g_bmd_t.bmd04) THEN
               #CALL s_uima146(g_bmd01)  #CHI-D10044
               CALL s_uima146(g_bmd01,0)  #CHI-D10044
            END IF
            #MOD-C20159 end add-----
            #TQC-C40082--add--str--
            IF cl_null(g_bmd[l_ac].bmd03) THEN 
               CALL g_bmd.deleteElement(l_ac)
            END IF
            #TQC-C40082--add--end--
            CLOSE i604_bcl
            COMMIT WORK

        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmd03) AND l_ac > 1 THEN
                LET g_bmd[l_ac].* = g_bmd[l_ac-1].*
                NEXT FIELD bmd03
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(bmd04)

#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.form = "q_ima"
                 #   LET g_qryparam.default1 = g_bmd[l_ac].bmd04
                 #   CALL cl_create_qry() RETURNING g_bmd[l_ac].bmd04
                     CALL q_sel_ima(FALSE, "q_ima", "", g_bmd[l_ac].bmd04 , "", "", "", "" ,"",'' )  RETURNING g_bmd[l_ac].bmd04
#FUN-AA0059 --End--
                    DISPLAY g_bmd[l_ac].bmd04 TO bmd04
                    NEXT FIELD bmd04
            END CASE
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033  

      AFTER INPUT 
#TQC-B90236-------add-------begin
         LET l_sum_bmd07 = 0
         FOR l_i = 1 TO g_bmd.getLength() 
             LET l_sum_bmd07 = l_sum_bmd07 + g_bmd[l_i].bmd07
         END FOR
         IF cl_null(g_bmd10) THEN
            LET g_bmd10 =1
         END IF
         IF l_sum_bmd07 <> g_bmd10 THEN
            IF cl_confirm('abm1002') THEN
               LET g_bmd10 = l_sum_bmd07
               UPDATE bmd_file SET bmd10 = g_bmd10
                WHERE bmd01 = g_bmd01
                  AND bmd08 = g_bmd08
                  AND bmd02 = g_bmd02
               IF SQLCA.sqlcode THEN
                  LET g_msg = g_bmd01 CLIPPED,' + ', g_bmd08 CLIPPED
                  CALL cl_err3("upd","bmd_file",g_bmd01_t,g_bmd08_t,SQLCA.sqlcode,"",g_msg,1) 
               END IF
               DISPLAY g_bmd10 TO bmd10
            ELSE
               CONTINUE INPUT
            END IF
         END IF
#TQC-B90236-------add-------end
      END INPUT
    CLOSE i604_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i325_aps()     
DEFINE l_vmq RECORD LIKE vmq_file.*     
 
   LET g_action_choice="aps_displace_data"
   IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF  #TQC-750013 add
   IF cl_null(g_bmd08) or cl_null(g_bmd01) or
      cl_null(g_bmd[l_ac].bmd04) THEN
      CALL cl_err('',-400,1)
      RETURN 
   END IF
   IF NOT cl_null(g_bmd08) and not cl_null(g_bmd01) 
      and not cl_null(g_bmd[l_ac].bmd04) THEN 
      SELECT vmq01,vmq02,vmq03 
        FROM vmq_file 
       WHERE vmq01 = g_bmd08
         and vmq02 = g_bmd01
         and vmq03 = g_bmd[l_ac].bmd04
      IF SQLCA.sqlcode=100 THEN
         LET l_vmq.vmq01 = g_bmd08
         LET l_vmq.vmq02 = g_bmd01
         LET l_vmq.vmq03 = g_bmd[l_ac].bmd04
         
         INSERT INTO vmq_file(vmq01,vmq02,vmq03)
                       VALUES(l_vmq.vmq01,l_vmq.vmq02,l_vmq.vmq03)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","vmq_file",g_bmd01,"",SQLCA.sqlcode,
                         "","",1)
         END IF
      END IF
      LET g_cmd = "apsi325 '",g_bmd08,"' '",g_bmd01,"' '",g_bmd[l_ac].bmd04,"'"
      CALL cl_cmdrun(g_cmd)
   END IF
END FUNCTION
 
 
 
FUNCTION i604_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
 
    CONSTRUCT l_wc ON bmd03, bmd04                     #螢幕上取條件
       FROM s_bmd[1].bmd03,s_bmd[1].bmd04
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    LET l_wc = l_wc CLIPPED,cl_get_extra_cond('bmduser', 'bmdgrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = FALSE RETURN END IF
    CALL i604_bf(l_wc)
END FUNCTION
 
FUNCTION i604_bf(p_wc)              #BODY FILL UP
DEFINE
    p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
 
    LET g_sql =
       "SELECT bmd03, bmd04, ima02,ima021,bmd11,bmd05, bmd06, bmd09, bmd07, ", #TQC-B90236 add bmd11
       "       ta_bmd01,bmduser,bmdgrup,bmdmodu,bmddate,bmdacti ",   #TQC-730102 #darcy:2023/04/28 add ta_bmd01
       " FROM bmd_file, OUTER ima_file",
       " WHERE bmd01 = '",g_bmd01,"' AND bmd08 = '",g_bmd08,"'",
       "   AND bmd02 = '",g_bmd02,"'",
       "   AND bmd_file.bmd04 = ima_file.ima01",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i604_prepare2 FROM g_sql      #預備一下
    DECLARE bmd_cs CURSOR FOR i604_prepare2
    CALL g_bmd.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH bmd_cs INTO g_bmd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bmd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i604_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmd TO s_bmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION first
         CALL i604_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i604_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i604_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i604_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i604_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
      
      #darcy:2023/03/10 s---
      on action fast_excel
         let g_action_choice="detail"
         if cl_chk_act_auth() then
            call i604_fast_excel()
         end if
      #darcy:2023/03/10 e---
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
#@    ON ACTION 相關文件
       ON ACTION related_document                   #MOD-470051
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0033             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0033
 
     ON ACTION aps_displace_data
        LET g_action_choice="aps_displace_data"
        LET g_flag = 'Y'
        EXIT DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i604_copy()
DEFINE
    l_oldno1         LIKE bmd_file.bmd01,
    l_oldno2         LIKE bmd_file.bmd08,
    l_oldno3         LIKE bmd_file.bmd02,
    l_newno1         LIKE bmd_file.bmd01,
    l_newno2         LIKE bmd_file.bmd08,
    l_newno3         LIKE bmd_file.bmd02
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT l_newno2  FROM bmd08
 

        AFTER FIELD bmd08
            IF cl_null(l_newno2) THEN
                NEXT FIELD bmd08
            END IF
           #FUN-AA0059 ---------------------add start----------------------------
            IF NOT s_chk_item_no(l_newno2,'') THEN
               CALL cl_err('',g_errno,1)
               NEXT FIELD bmd08
            END IF 
           #FUN-AA0059 ---------------------add end-----------------------------------  
            SELECT * FROM ima_file
             WHERE ima01 = l_newno2
            IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","ima_file",l_newno2,"","mfg2729","","",1)     # TQC-660046
               NEXT FIELD bmd08
            END IF
            SELECT count(*) INTO g_cnt FROM bmd_file
             WHERE bmd01 = g_bmd01
               AND bmd08 = l_newno2
               AND bmd02 = g_bmd02
               AND bmdacti = 'Y'                                           #CHI-910021
            IF g_cnt > 0 THEN
	        LET g_msg = g_bmd01 CLIPPED,'+',l_newno2 CLIPPED
                CALL cl_err(g_msg,-239,0)
                NEXT FIELD bmd08
            END IF
        ON ACTION CONTROLP
           CASE
                WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form = "q_ima"
                 #    LET g_qryparam.default1 = l_newno2
                 #    CALL cl_create_qry() RETURNING l_newno2
                      CALL q_sel_ima(FALSE, "q_ima", "", l_newno2, "", "", "", "" ,"",'' )  RETURNING l_newno2
#FUN-AA0059 --End--
                     DISPLAY BY NAME l_newno2
                     NEXT FIELD bmd08
           END CASE
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
    IF INT_FLAG OR l_newno2 IS NULL THEN
        LET INT_FLAG = 0
    	CALL i604_show()
        RETURN
    END IF
   DROP TABLE x 
    SELECT * FROM bmd_file
        WHERE bmd01=g_bmd01
          AND bmd08=g_bmd08
          AND bmd02=g_bmd02
          AND bmdacti = 'Y'                                           #CHI-910021
        INTO TEMP x
    UPDATE x

        SET bmd08=l_newno2
    INSERT INTO bmd_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","bmd_file",g_bmd01,g_bmd08,SQLCA.sqlcode,"","",1)   #TQC-660046 
    ELSE
	LET g_msg = g_bmd01 CLIPPED, ' + ', l_newno2 CLIPPED
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno2 = g_bmd08
        LET g_bmd08 = l_newno2
	IF g_chkey = 'Y' THEN CALL i604_u() END IF
        CALL i604_b()
        #LET g_bmd08 = l_oldno2  #FUN-C30027
        #CALL i604_show()        #FUN-C30027
    END IF
END FUNCTION
 
FUNCTION i604_out()
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0)
    RETURN END IF
    MENU ""
       ON ACTION component_p_n_type_print
          LET g_ls="Y"                     #No.FUN-580110
          CALL i604_out1()                 #No.FUN-580110
 
       ON ACTION assm_p_n_type_print
          LET g_ls="N"                     #No.FUN-580110
          CALL i604_out1()                 #No.FUN-580110
 
       ON ACTION exit
          EXIT MENU
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE MENU
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      ON ACTION cancel        #NO.TQC-960270                                                                                        
         EXIT MENU            #NO.TQC-960270  
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU 
 
    END MENU
END FUNCTION
 
FUNCTION i604_out1()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        #order1      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(8)   #FUN-C30190 mark
        #order2      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(8)   #FUN-C30190 mark
        l_order1    LIKE bmd_file.bmd01,   #FUN-C30190 
        l_order2    LIKE bmd_file.bmd01,   #FUN-C30190
        bmd01       LIKE bmd_file.bmd01,   #
        bmd08       LIKE bmd_file.bmd08,   #
        bmd02       LIKE bmd_file.bmd02,   #
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
        bmd05       LIKE bmd_file.bmd05,
        bmd06       LIKE bmd_file.bmd06,   #FUN-C30190
        bmd07       LIKE bmd_file.bmd07
                    END RECORD,
    l_name          LIKE type_file.chr20,  #External(Disk) file name #No.FUN-680096 VARCHAR(20)
    l_za05          LIKE type_file.chr1000 #No.FUN-680096 VARCHAR(40)
    DEFINE l_order1 LIKE bmd_file.bmd01    #No.FUN-680096 VARCHAR(8)
    DEFINE l_order2 LIKE bmd_file.bmd01    #No.FUN-680096 VARCHAR(8)
    DEFINE l_sql    LIKE type_file.chr1000 #FUN-C30190 

    CALL cl_wait()
    #FUN-C30190---add---Str
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    #FUN-C30190---add---End 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT '','',bmd01,bmd08,bmd02,bmd03,bmd04,bmd05,bmd06,bmd07",   #FUN-C30190 add bmd05
              " FROM bmd_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              "   AND bmdacti = 'Y'"                                           #CHI-910021
    PREPARE i604_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i604_co                         # CURSOR
        CURSOR FOR i604_p1
 
    #CALL cl_outnam('abmi604') RETURNING l_name    #FUN-C30190 mark
    IF g_ls='Y' THEN
       LET g_zaa[31].zaa06='N'
       LET g_zaa[37].zaa06='Y'
    ELSE
       LET g_zaa[37].zaa06='N'
       LET g_zaa[31].zaa06='Y'
    END IF
    CALL cl_prt_pos_len()
    #START REPORT i604_rep1 TO l_name              #FUN-C30190 mark
 
    FOREACH i604_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_ls="Y" THEN
           LET l_order1=sr.bmd01
           lET l_order2=sr.bmd08
        ELSE
           LET l_order1=sr.bmd08
           LET l_order2=sr.bmd01
        END IF
        #FUN-C30190----mark---str---
        #LET sr.order1=l_order1
        #LET sr.order2=l_order2
        #OUTPUT TO REPORT i604_rep1(sr.*)
        #FUN-C30190----mark---end---
        #FUN-C30190----add----str---
        LET sr.l_order1=l_order1
        LET sr.l_order2=l_order2
        EXECUTE  insert_prep  USING sr.*
        #FUN-C30190----add----end---
    END FOREACH
 
    #FINISH REPORT i604_rep1    #FUN-C30190  mark
 
    CLOSE i604_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)  #FUN-C30190  mark
    #FUN-C30190-----add---str----
    IF g_ls="Y" THEN
       LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY bmd01,bmd08,bmd02,bmd03"
    ELSE
       LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY bmd08,bmd01,bmd02,bmd03"
    END IF
    CALL cl_prt_cs3("abmi604","abmi604",l_sql,'')
    #FUN-C30190-----add---end----
END FUNCTION

#FUN-C30190-----mark-----str-----  
#REPORT i604_rep1(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
#    sr              RECORD
#        order1      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(8) 
#        order2      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(8) 
#        bmd01       LIKE bmd_file.bmd01,   #
#        bmd08       LIKE bmd_file.bmd08,   #
#        bmd02       LIKE bmd_file.bmd02,   #
#        bmd03       LIKE bmd_file.bmd03,   #行序
#        bmd04       LIKE bmd_file.bmd04,   #舊料料號
#        bmd06       LIKE bmd_file.bmd06,
#        bmd07       LIKE bmd_file.bmd07
#                    END RECORD
#   DEFINE l_order1  LIKE type_file.num5    #No.FUN-680096 SMALLINT
#   DEFINE l_order2  LIKE type_file.num5    #No.FUN-680096 SMALLINT
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#       ORDER BY sr.order1,sr.order2,sr.bmd02,sr.bmd03
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31],g_x[32],g_x[37],g_x[33],g_x[34],g_x[35],g_x[36]
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#        BEFORE GROUP OF sr.order1
#          IF g_ls="Y" THEN
#            PRINT COLUMN g_c[31],sr.bmd01 CLIPPED; #FUN-5B0013 add
#          ELSE
#            PRINT COLUMN g_c[32],sr.bmd08 CLIPPED; #FUN-5B0013 add
#          END IF
# 
#        BEFORE GROUP OF sr.order2
#          IF g_ls="Y" THEN
#            PRINT COLUMN g_c[32],sr.bmd08 CLIPPED; #FUN-5B0013 add
#          ELSE
#            PRINT COLUMN g_c[37],sr.bmd01 CLIPPED; #FUN-5B0013 add
#          END IF
# 
#        BEFORE GROUP OF sr.bmd02
#            PRINT COLUMN g_c[33],sr.bmd02 USING '####&';
# 
#        ON EVERY ROW
#            PRINT COLUMN g_c[34],sr.bmd03 USING '###&', #FUN-590118
#                  COLUMN g_c[35],sr.bmd04 CLIPPED, #FUN-5B0013 add
#                  COLUMN g_c[36],sr.bmd07 USING '############.##'
# 
#        AFTER GROUP OF sr.bmd08
#            PRINT
# 
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#            LET l_trailer_sw = 'n'
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                 PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED    #MOD-4A0338    #TQC-6A0086
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190-----mark-----end-----
 
FUNCTION i604_chk_date_range(p_type)
  DEFINE l_bmd05  LIKE bmd_file.bmd05,
         l_bmd06  LIKE bmd_file.bmd06,
         l_sql    STRING,
         p_type   LIKE type_file.chr1
 
  LET g_errno = ''
  
 
  LET l_sql = "SELECT bmd05,bmd06 FROM bmd_file ",
              " WHERE bmd01 ='", g_bmd01 CLIPPED ,"'",
              "   AND bmd08 ='", g_bmd08 CLIPPED ,"'",
              "   AND bmd02 ='", g_bmd02 CLIPPED ,"'",
              "   AND bmd03 <>", g_bmd[l_ac].bmd03,
              "   AND bmd04 ='", g_bmd[l_ac].bmd04 CLIPPED,"'",
              "   AND bmdacti = 'Y'",                                           #CHI-910021
              " ORDER BY bmd03"
           
  PREPARE i604_pre_chk FROM l_sql      
  DECLARE bmd_chk CURSOR FOR i604_pre_chk
  FOREACH bmd_chk INTO l_bmd05,l_bmd06
    IF cl_null(l_bmd05) THEN
       IF cl_null(l_bmd06) THEN
         LET g_errno = 'abm-021'
         RETURN
       ELSE
         IF cl_null(g_bmd[l_ac].bmd04) OR g_bmd[l_ac].bmd04 < l_bmd06 THEN
            LET g_errno = 'abm-021'
            RETURN
         END IF
       END IF
    END IF
    IF p_type = 'b' AND g_bmd[l_ac].bmd05 < l_bmd05 AND cl_null(g_bmd[l_ac].bmd06) THEN RETURN END IF
    IF cl_null(l_bmd06) THEN
       IF cl_null(g_bmd[l_ac].bmd06) THEN
          LET g_errno = 'abm-021'
          RETURN
       ELSE
          IF g_bmd[l_ac].bmd06 > l_bmd05 THEN
             LET g_errno = 'abm-021'
             RETURN
          END IF
       END IF
    ELSE
       IF g_bmd[l_ac].bmd05 <= l_bmd05 THEN 
         IF cl_null(g_bmd[l_ac].bmd06) THEN
           LET g_errno = 'abm-021'
           RETURN
         END IF
         IF g_bmd[l_ac].bmd06 > l_bmd05 THEN
           LET g_errno = 'abm-021'
           RETURN
         END IF
       END IF
       IF g_bmd[l_ac].bmd05 > l_bmd05 AND g_bmd[l_ac].bmd05 < l_bmd06 THEN
           LET g_errno = 'abm-021'
           RETURN
       END IF 
    END IF
  END FOREACH
END FUNCTION
#No:FUN-9C0077

#darcy:2023/03/10 s---
function i604_fast_excel()
    define l_sql  string
    define table_name string
    define err like type_file.chr1
    define file string
    define title string

    let table_name = g_prog||FGL_GETPID() CLIPPED
    let l_sql = " create table ",table_name, " as ",
                " select bmd01,bmd02,bmd03,bmd04,bmd05,bmd06,bmd07,bmd08,bmd09,bmdacti,bmddate,bmdgrup,bmduser,bmdmodu,bmdorig,bmdoriu,bmd10,bmd11 from  bmd_file "

    prepare i604_fast_p from l_sql
    execute i604_fast_p
    if status then
        call cl_err('exe i604_fast_excel',status,1)
        return
    end if

    let title = "    原始料号,类型(1取代/2替代),替代序号,取代/替代料号,生效日期,失效日期,取代替代量,主件编号,最近替代日,有效码,最近修改日,资料所有部门,资料所有者,资料更改者,资料建立部门,资料建立者,底数,回扣料"

    call cs_darcy_set_title(table_name,title,"取替代料") returning err
    call cs_darcy_excel(table_name,g_prog) returning file,err

    let l_sql = " drop table ",table_name

    prepare i604_fast_d from l_sql
    execute i604_fast_d

end function
#darcy:2023/03/10 e---

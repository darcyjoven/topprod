# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi6042.4gl
# Descriptions...: 元件取替代資料維護
# Date & Author..: 96/05/31 By Roger
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-490375 04/09/23 Melody 元件欄位開窗查詢時,不要查詢到全部的料件,僅查到此主件的所有元作即可.
# Modify.........: No.MOD-4A0088 04/10/06 By Mandy 主件使用'ALL'時，輸入元件不論是否有建BOM都會出現無此產品結構訊息
# Modify.........: No.MOD-4A0100 04/10/07 By Mandy 單頭主件編號輸入ALL時,不應CHECK主件編號跟元件編號之間的關係
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-530154 05/03/24 By kim bom取替代建立後不會自動更新bom,取替代特性未更改
# Modify.........: No.MOD-530278 05/04/06 By kim 1.元件料號不可=替代料號 2.檢查有兩個替代料時,其有效日期和失效日期區間不可重疊
# Modify.........: No.MOD-550064 05/05/09 By kim ima02欄位帶錯值
# Modify.........: No.FUN-590110 05/08/25 By jackie 報表轉XML
# Modify.........: No.FUN-5B0013 05/11/02 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.TQC-660046 06/06/14 By Jackho cl_err-->cl_err3
# Modify.........: No.FUN-660173 06/07/04 By Sarah 元件A不應同時有相同的替代料及取代料皆為B的狀況
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值 
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6B0033 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740110 07/04/22 By kim 新增bmd_file沒有填資料所有人等欄位
# Modify.........: No.TQC-740341 07/04/27 By johnray 修正報表打印格式錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750143 07/05/23 By xufeng 替代數量不能為負
# Modify.........: No.TQC-750144 07/05/24 By jamie 取替代特性->default '1' 
# Modify.........: No.FUN-740196 07/06/04 By pengu 新增資料所有者,資料所有群,資料更改者,最近修改日四欄位
# Modify.........: No.MOD-810228 08/03/24 By Pengu 若主件打ALL也應該要自動會回寫abmi600中的取替代特性
# Modify.........: No.MOD-830203 08/03/26 By claire bmd_file 未有特性代碼,故不需傳入
# Modify.........: No.TQC-860021 08/06/10 By Sarah INPUT段漏了ON IDLE控制
# Modify.........: No.FUN-8A0106 08/11/06 By jan 刪除資料時取替代特性回寫為0 
# Modify.........: No.MOD-910195 09/01/16 By claire 替代料號不可同主件料號
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920075 09/02/23 By xiaofeizhu _curs段之組sql及_b段之lock cursor及_i段的lock cursor及b_fill段的sql不要加有效無效判斷
# Modify.........: No.TQC-960270 09/06/23 By destiny 打印時增加放棄按鈕 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:FUN-9C0040 10/02/02 By jan 回收料不可做取替代
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 規通料件整合(3)全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/25 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.FUN-B50062 11/05/16 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-BC0142 11/12/13 By johung 將AFTER FIELD bmd08中的s_chk_item_no檢查搬到bmd <> 'ALL'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 賦值bmd11 
# Modify.........: No.TQC-C20420 11/11/07 By yuhuabao 新增欄位：取替代特性(bmd02)：增加選項"3.配方替代"；
#                                                               底數(bmd10);回扣料(bmd11)
# Modify.........: No:MOD-C20159 12/03/01 By ck2yuan 新增,刪除,修改都要呼叫s_uima146 避免非透過abmi600進行取替代而造成abmp603沒計算到
# Modify.........: No:MOD-C30269 12/03/10 By xujing BEFORE FIELD bmd03時，除了判斷p_cmd='a'，應再加上判斷舊值為NULL時才預設給最大值+1 
# Modify.........: No:MOD-C30266 12/03/10 By tanxc 單身新增時預設資料有效碼為Y
# Modify.........: No:MOD-C30357 12/03/12 By zhuhao 取替代特性為3配方替代,回寫時取替代特性bmb16，應為9
# Modify.........: No:MOD-C30538 12/03/12 By zhuhao 判斷主件(bmd08)，需有purity的特性，替代料(bmd04)有設定purity特性的，回扣料(bmd11)不可為"Y"
# Modify.........: No:MOD-C30657 12/03/14 By fengrui 修改替代序號bmd03自動累加條件
# Modify.........: No.FUN-C30190 12/03/28 By xumeimei 原報表轉CR報表
# Modify.........: No:TQC-C40178 12/04/19 By fengrui 給回扣料欄位賦初值，糾正MOD-C30357錯誤,回寫底數時候主鍵修正為單頭主鍵 
# Modify.........: No.TQC-C40231 12/04/25 By fengrui BUG修改,連續刪除報-400錯誤、刪除后總筆數等於零時報無上下筆資料錯誤
# Modify.........: No.MOD-B90280 12/06/18 By ck2yuan bmd06新增時不應給null
# Modify.........: No:MOD-C70015 12/07/03 By ck2yuan AFTER FIELD bmd01,bmd04 加上檢查卡關abm-021
# Modify.........: No.CHI-C20058 12/07/13 By bart 僅帶出遊標該筆替代資料
# Modify.........: No:TQC-C80017 12/08/02 By fengrui 刪除數組空數據行
# Modify.........: No:MOD-C80197 12/08/29 By ck2yuan MOD-C70015 next field到bmd05,但after field bmd05卻沒有作檢查 所以加上檢查
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today
# Modify.........: No.MOD-D20004 13/03/01 By bart 如果刪除後bmd_file還有資料，請回寫剩下的那個取替 or 替代關係回 abmi600
# Modify.........: No.CHI-D10044 13/03/04 By bart s_uima146()參數變更
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_bmd08         LIKE bmd_file.bmd08,   #
    g_bmd02         LIKE bmd_file.bmd02,   #
    g_bmd08_t       LIKE bmd_file.bmd08,   #
    g_bmd02_t       LIKE bmd_file.bmd02,   #
    g_bmd10         LIKE bmd_file.bmd10,   #TQC-C20420
    g_bmd10_t       LIKE bmd_file.bmd10,   #TQC-C20420
    g_bmd           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmd01       LIKE bmd_file.bmd01,   #
        ima02_a     LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(60)
        ima021_a    LIKE ima_file.ima021,  #No.FUN-680096 VARCHAR(60)
        bmd11       LIKE bmd_file.bmd11,   #TQC-C20420 add
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
        ima02_b     LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(60)
        ima021_b    LIKE ima_file.ima021,  #No.FUN-680096 VARCHAR(60)
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
        bmd01       LIKE bmd_file.bmd01,   #
        ima02_a     LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(60)
        ima021_a    LIKE ima_file.ima021,  #No.FUN-680096 VARCHAR(60)
        bmd11       LIKE bmd_file.bmd11,   #TQC-C20420 add
        bmd03       LIKE bmd_file.bmd03,   #行序
        bmd04       LIKE bmd_file.bmd04,   #舊料料號
        ima02_b     LIKE ima_file.ima02,   #No.FUN-680096 VARCHAR(60)
        ima021_b    LIKE ima_file.ima021,  #No.FUN-680096 VARCHAR(60)
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
    g_argv1         LIKE bmd_file.bmd08,
    g_argv2         LIKE bmd_file.bmd01,   #CHI-C20058
    g_ls            LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1) 
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680096 SMALLINT
    l_sl            LIKE type_file.num5    #目前處理的SCREEN LINE  #No.FUN-680096 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680096 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt        LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_i          LIKE type_file.num5    #count/index for any purpose    #No.FUN-680096 SMALLINT
DEFINE   g_msg        LIKE ze_file.ze03      #No.FUN-680096 VARCHAR(72)
DEFINE   g_row_count  LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_curs_index LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   g_jump       LIKE type_file.num10   #No.FUN-680096 INTEGER
DEFINE   mi_no_ask    LIKE type_file.num5    #No.FUN-680096 SMALLINT
DEFINE   l_table      STRING                 #No.FUN-C30190  

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
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
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

    LET l_table = cl_prt_temptable('abmi6042',g_sql) CLIPPED
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
    LET g_bmd08 = NULL                     #清除鍵值
    LET g_bmd02 = NULL                     #清除鍵值
    LET g_bmd08_t = NULL
    LET g_bmd02_t = NULL
 
	#取得參數
	LET g_argv1=ARG_VAL(1)	#元件
	IF g_argv1=' ' THEN LET g_argv1='' ELSE LET g_bmd08=g_argv1 END IF
    LET g_argv2=ARG_VAL(2)  #CHI-C20058
    IF g_argv2=' ' THEN LET g_argv2='' END IF  #CHI-C20058
    
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i6042_w AT p_row,p_col WITH FORM "abm/42f/abmi6042"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
 
    IF NOT cl_null(g_argv1) THEN CALL i6042_q() END IF
  
    CALL s_decl_bmb()                     #MOD-C20159 add
 
    LET g_delete='N'
    CALL i6042_menu()
    CLOSE WINDOW i6042_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
         RETURNING g_time    #No.FUN-6A0060
END MAIN
 
#QBE 查詢資料
FUNCTION i6042_cs()
    IF cl_null(g_argv1) THEN
    	CLEAR FORM                             #清除畫面
        CALL g_bmd.clear() 
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
   INITIALIZE g_bmd08 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd02 TO NULL    #No.FUN-750051
   INITIALIZE g_bmd10 TO NULL    #TQC-C20420 add
    	CONSTRUCT g_wc ON bmd08,bmd02,bmd10,bmd01,bmd11,ta_bmd01,bmd03,bmd04,    #螢幕上取條件 #TQC-C20420 add bmd10,bmd11
    	          bmduser,bmdgrup,bmdmodu,bmddate,bmdacti   #No.FUN-740196 add
        	FROM bmd08,bmd02,bmd10,s_bmd[1].bmd01,s_bmd[1].bmd11,s_bmd[1].bmd03,s_bmd[1].bmd04, #TQC-C20420 add bmd10,bmd11
                     s_bmd[1].ta_bmd01,s_bmd[1].bmduser,s_bmd[1].bmdgrup,s_bmd[1].bmdmodu,       #No.FUN-740196 add
                     s_bmd[1].bmddate,s_bmd[1].bmdacti                         #No.FUN-740196 add
                     #darcy:2023/05/23 add s_bmd[1].ta_bmd01,
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                  #   CALL cl_init_qry_var()
                  #   LET g_qryparam.form = "q_ima"
                  #   LET g_qryparam.state = 'c'
                  #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmd08
                     NEXT FIELD bmd08
                WHEN INFIELD(bmd01)
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = 'c'
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                     DISPLAY g_qryparam.multiret TO bmd01
                     NEXT FIELD bmd01
 
                WHEN INFIELD(bmd04)
#FUN-AA0059 --Begin--
                   #  CALL cl_init_qry_var()
                   #  LET g_qryparam.form = "q_ima"
                   #  LET g_qryparam.state = 'c'
                   #  CALL cl_create_qry() RETURNING g_qryparam.multiret
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
	    LET g_wc=" bmd08='",g_argv1,"'"
        #CHI-C20058---begin
        IF NOT cl_null(g_argv2) THEN
           LET g_wc=g_wc," AND bmd01='",g_argv2,"'"
        END IF  
        #CHI-C20058---end
    END IF
 
    LET g_sql="SELECT DISTINCT bmd08,bmd02,bmd10 FROM bmd_file ", #TQC-C20420 add bmd10
               " WHERE ", g_wc CLIPPED,
               " ORDER BY bmd08,bmd02"
    PREPARE i6042_prepare FROM g_sql      #預備一下
    IF STATUS THEN CALL cl_err('prep:',STATUS,1) END IF
    DECLARE i6042_bcs                  #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i6042_prepare
    LET g_sql="SELECT DISTINCT bmd08,bmd02 FROM bmd_file WHERE ",g_wc CLIPPED
    PREPARE i6042_precount FROM g_sql
    DECLARE i6042_count CURSOR FOR i6042_precount
END FUNCTION
 
 
FUNCTION i6042_menu()
 
   WHILE TRUE
      CALL i6042_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i6042_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i6042_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i6042_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i6042_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i6042_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmd08 IS NOT NULL THEN
                  LET g_doc.column1 = "bmd08"
                  LET g_doc.value1  = g_bmd08
                  LET g_doc.column2 = "bmd02"
                  LET g_doc.value2  = g_bmd02
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmd),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION i6042_a()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    MESSAGE ""
    CLEAR FORM
    CALL g_bmd.clear()
    INITIALIZE g_bmd08 LIKE bmd_file.bmd08
    INITIALIZE g_bmd02 LIKE bmd_file.bmd02
	IF NOT cl_null(g_argv1) THEN LET g_bmd08=g_argv1
	DISPLAY g_bmd08 TO bmd08 END IF
    LET g_bmd08_t = NULL
    LET g_bmd02_t = NULL
    LET g_bmd10 = 1                #No.TQC-C20420 add
    DISPLAY g_bmd10 TO bmd10       #No.TQC-C20420 add
    LET g_bmd10_t =  1             #No.TQC-C20420 add
    #預設值及將數值類變數清成零
    CALL cl_opmsg('a')
    WHILE TRUE
        #LET g_bmd02 ='1'           #TQC-750144 add
        LET g_bmd02 ='2'            
        CALL i6042_i("a")                   #輸入單頭
	IF INT_FLAG THEN
           LET g_bmd08=NULL
            LET INT_FLAG=0 CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        CALL g_bmd.clear()
	LET g_rec_b = 0
        DISPLAY g_rec_b TO FORMONLY.cn2
        CALL i6042_b()                   #輸入單身
        LET g_bmd08_t = g_bmd08            #保留舊值
        LET g_bmd02_t = g_bmd02            #保留舊值
        LET g_bmd10_t = g_bmd10            #No.TQC-C20420 add
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i6042_u()
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd08 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_bmd08_t = g_bmd08
    LET g_bmd02_t = g_bmd02
    LET g_bmd10_t = g_bmd10   #No.TQC-C20420 add
    WHILE TRUE
        CALL i6042_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET g_bmd08=g_bmd08_t
            LET g_bmd02=g_bmd02_t
            LET g_bmd10=g_bmd10_t  #No.TQC-C20420 add
            DISPLAY g_bmd08 TO bmd08     #單頭
            DISPLAY g_bmd02 TO bmd02     #單頭
            DISPLAY g_bmd10 TO bmd10      #No.TQC-C20420 add
 
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_bmd08 != g_bmd08_t OR
           g_bmd02 != g_bmd02_t OR g_bmd10 != g_bmd10_t   THEN #更改單頭值  #No.TQC-C20420 add g_bmd10
            UPDATE bmd_file SET bmd08 = g_bmd08,  #更新DB
		                bmd02 = g_bmd02,
                                bmd10 = g_bmd10   #No.TQC-C20420 add
                WHERE bmd08 = g_bmd08_t          #COLAUTH?
	          AND bmd02 = g_bmd02_t
                  AND bmd10 = g_bmd10_t            #No.TQC-C20420 add
            IF SQLCA.sqlcode THEN
	        LET g_msg = g_bmd08 CLIPPED
                CALL cl_err3("upd","bmd_file",g_bmd08_t,g_bmd02_t,SQLCA.sqlcode,"","",1) # TQC-660046
                CONTINUE WHILE
            END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
#處理INPUT
FUNCTION i6042_i(p_cmd)
DEFINE
    p_cmd       LIKE type_file.chr1,     #a:輸入 u:更改   #No.FUN-680096 VARCHAR(1)
    l_bmd04     LIKE bmd_file.bmd04
DEFINE  l_i         LIKE type_file.num5,     #TQC-C20420 add
        l_sum_bmd07 LIKE bmd_file.bmd07      #TQC-C20420 add
DEFINE  l_num       LIKE type_file.num5      #MOD-C30538 add 
    LET g_ss='Y'
    CALL cl_set_head_visible("","YES")           #No.FUN-6B0033
    INPUT g_bmd08, g_bmd02 ,g_bmd10          #TQC-C20420 add g_bmd10
        WITHOUT DEFAULTS
        FROM bmd08,bmd02,bmd10               #TQC-C20420 add bmd10
 
 
	BEFORE FIELD bmd08  # 是否可以修改 key
	    IF g_chkey = 'N' AND p_cmd = 'u' THEN RETURN END IF
 
        AFTER FIELD bmd08            #
            IF NOT cl_null(g_bmd08) THEN
              #MOD-BC0142 -- 程式搬移 mark begin --
              ##FUN-AA0059 ---------------------------add start-------------------------
              # IF NOT s_chk_item_no(g_bmd08,'') THEN
              #    CALL cl_err('',g_errno,1)
              #    LET g_bmd08 = g_bmd08_t
              #    DISPLAY g_bmd08 TO bmd08
              #    NEXT FIELD bmd08
              # END IF
              ##FUN-AA0059 --------------------------add end------------------------
              #MOD-BC0142 -- 程式搬移 mark end --
                IF g_bmd08 != g_bmd08_t OR g_bmd08_t IS NULL THEN
                    CALL i6042_bmd08('a')
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_bmd08,g_errno,0)
                        LET g_bmd08 = g_bmd08_t
                        DISPLAY g_bmd08 TO bmd08
                        NEXT FIELD bmd08
                    END IF
                   #MOD-BC0142 -- begin --
                   IF g_bmd08 <> 'ALL' THEN
                      IF NOT s_chk_item_no(g_bmd08,'') THEN
                         CALL cl_err('',g_errno,1)
                         LET g_bmd08 = g_bmd08_t
                         NEXT FIELD bmd08
                      END IF
                   END IF
                   #MOD-BC0142 -- end --
                END IF
            END IF
 
        AFTER FIELD bmd02            #
	    IF NOT cl_null(g_bmd02) THEN
	        IF g_bmd02 NOT MATCHES '[123]' THEN NEXT FIELD bmd02 END IF   #TQC-C20420 add '3'
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
                    WHERE bmd08 = g_bmd08
                      AND bmd02 = g_bmd02
                      AND bmdacti = 'Y'                                           #CHI-910021
                IF g_cnt > 0 THEN   #資料重複
	            LET g_msg = g_bmd08 CLIPPED
                    CALL cl_err(g_msg,-239,0)
                    LET g_bmd08 = g_bmd08_t
                    DISPLAY  g_bmd08 TO bmd08
                    NEXT FIELD bmd08
                END IF
            END IF

#TQC-C20420-----------add----------begin
         ON CHANGE bmd02
            IF g_bmd02 = '3' THEN
               CALL cl_set_comp_entry("bmd10",TRUE)
               CALL cl_set_comp_required("bmd10",TRUE)
            ELSE
               CALL cl_set_comp_entry("bmd10",FALSE)
               CALL cl_set_comp_required("bmd10",FALSE)
            END IF
#TQC-C20420-----------add----------end

#TQC-C20420-----------add----------begin
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
#TQC-C20420-----------add----------end
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(bmd08)
#FUN-AA0059 --Begin--
                 #    CALL cl_init_qry_var()
                 #    LET g_qryparam.form = "q_ima"
                 #    LET g_qryparam.default1 = g_bmd08
                 #    CALL cl_create_qry() RETURNING g_bmd08
                     CALL q_sel_ima(FALSE, "q_ima", "", g_bmd08, "", "", "", "" ,"",'' )  RETURNING g_bmd08
#FUN-AA0059 --End--
                     DISPLAY BY NAME g_bmd08
                     CALL i6042_bmd08('d')
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
#TQC-C20420------add------begin
    IF g_bmd.getLength() > 0 THEN
       LET l_sum_bmd07 = 0
       FOR l_i = 1 TO g_bmd.getLength()
          LET l_sum_bmd07 = l_sum_bmd07 + g_bmd[l_i].bmd07
       END FOR
       IF l_sum_bmd07<>g_bmd10 THEN
          IF cl_confirm('abm1001') THEN
              CALL i6042_b()
          ELSE
             LET g_bmd10 = g_bmd10_t
             DISPLAY g_bmd10 TO bmd10
          END IF
       END IF
    END IF
#TQC-C20420------add------end
END FUNCTION
 
FUNCTION i6042_bmd08(p_cmd)  #
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
    LET g_errno = ' '
	IF g_bmd08='all' THEN
		LET g_bmd08='ALL'
		DISPLAY g_bmd08 TO bmd08
	END IF
	IF g_bmd08='ALL' THEN RETURN END IF
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO l_ima02,l_ima021,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bmd08
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021 = NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
      THEN DISPLAY l_ima02 TO FORMONLY.ima02_h
           DISPLAY l_ima021 TO FORMONLY.ima021_h
           DISPLAY l_ima25 TO FORMONLY.ima25_h
           DISPLAY l_ima08 TO FORMONLY.ima08_h
    END IF
END FUNCTION
 
FUNCTION i6042_bmd01(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,          #No.FUN-680096 VARCHAR(1)
           l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima25   LIKE ima_file.ima25,
           l_ima08   LIKE ima_file.ima08,
           l_imaacti LIKE ima_file.imaacti
 
        LET g_errno = ' '
	IF g_bmd[l_ac].bmd01=g_bmd08 THEN LET g_errno='mfg2633' RETURN END IF
    SELECT ima02,ima021,ima25,ima08,imaacti
           INTO g_bmd[l_ac].ima02_a,g_bmd[l_ac].ima021_a,l_ima25,l_ima08,l_imaacti
           FROM ima_file WHERE ima01 = g_bmd[l_ac].bmd01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                            LET l_ima02 = NULL  LET l_ima25 = NULL
                            LET l_ima021= NULL
                            LET l_ima08 = NULL  LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY g_bmd[l_ac].ima02_a TO ima02_a
    DISPLAY g_bmd[l_ac].ima021_a TO ima021_a
END FUNCTION
 
#Query 查詢
FUNCTION i6042_q()
  DEFINE l_bmd08  LIKE bmd_file.bmd08,
         l_bmd02  LIKE bmd_file.bmd02,
         l_cnt    LIKE type_file.num10    #No.FUN-680096 INTEGER
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmd08 TO NULL        #No.FUN-6A0002
    INITIALIZE g_bmd02 TO NULL        #No.FUN-6A0002 
    INITIALIZE g_bmd10 TO NULL        #No.TQC-C20420
 
    CALL cl_opmsg('q')
    MESSAGE ""
    CALL i6042_cs()                    #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_bmd08 TO NULL
        INITIALIZE g_bmd02 TO NULL
        INITIALIZE g_bmd10 TO NULL  #No.TQC-C20420
        RETURN
    END IF
    OPEN i6042_bcs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                         #有問題
        CALL cl_err('open cursor:',SQLCA.sqlcode,0)
        INITIALIZE g_bmd08 TO NULL
        INITIALIZE g_bmd02 TO NULL
        INITIALIZE g_bmd10 TO NULL  #No.TQC-C20420
    ELSE
        FOREACH i6042_count INTO l_bmd08,l_bmd02
            LET g_row_count = g_row_count + 1
        END FOREACH
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i6042_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i6042_fetch(p_flag)
DEFINE
    p_flag     LIKE type_file.chr1       #處理方式   #No.FUN-680096 VARCHAR(1)
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i6042_bcs INTO g_bmd08,g_bmd02,g_bmd10   #No.TQC-C20420 add g_bmd10
        WHEN 'P' FETCH PREVIOUS i6042_bcs INTO g_bmd08,g_bmd02,g_bmd10   #No.TQC-C20420 add g_bmd10
        WHEN 'F' FETCH FIRST    i6042_bcs INTO g_bmd08,g_bmd02,g_bmd10   #No.TQC-C20420 add g_bmd10
        WHEN 'L' FETCH LAST     i6042_bcs INTO g_bmd08,g_bmd02,g_bmd10   #No.TQC-C20420 add g_bmd10
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i6042_bcs INTO g_bmd08,g_bmd02,g_bmd10   #No.TQC-C20420 add g_bmd10
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err(g_bmd08,SQLCA.sqlcode,0)
       INITIALIZE g_bmd02 TO NULL  #TQC-6B0105
       INITIALIZE g_bmd08 TO NULL  #TQC-6B0105
       INITIALIZE g_bmd10 TO NULL  #TQC-C20420
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
    CALL i6042_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i6042_show()
    DISPLAY g_bmd08 TO bmd08   #單頭
    DISPLAY g_bmd02 TO bmd02   #單頭
    DISPLAY g_bmd10 TO bmd10      #No.TQC-C20420
    CALL i6042_bmd08('d')
    CALL i6042_bf(g_wc)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i6042_r()
  DEFINE l_bmd08  LIKE bmd_file.bmd08,
         l_bmd02  LIKE bmd_file.bmd02,
         l_n      LIKE type_file.num5,                #FUN-8A0106
         l_sql    STRING                              #FUN-8A0106
  DEFINE l_bmd01 DYNAMIC ARRAY OF LIKE bmd_file.bmd01 #FUN-8A0106 
  DEFINE l_i,i    LIKE type_file.num5                 #FUN-8A0106
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd08 IS NULL THEN
       CALL cl_err("",-400,0)                      #No.FUN-6A0002
       RETURN
    END IF
    LET l_sql = "SELECT UNIQUE bmd01 FROM bmd_file,OUTER ima_file",
                " WHERE bmd08 = '",g_bmd08,"'",
                "   AND bmd02 = '",g_bmd02,"'",
                "   AND bmdacti = 'Y'",                                           #CHI-910021
                "   AND bmd_file.bmd04 = ima_file.ima01" 
     PREPARE i6042_prepare3 FROM l_sql
     DECLARE bmd_cs3 CURSOR FOR i6042_prepare3
     LET l_i = 1
     FOREACH bmd_cs3 INTO l_bmd01[l_i] 
       LET l_i= l_i+1
     END FOREACH
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bmd08"      #No.FUN-9B0098 10/02/24
        LET g_doc.value1  = g_bmd08      #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "bmd02"      #No.FUN-9B0098 10/02/24
        LET g_doc.value2  = g_bmd02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM bmd_file
         WHERE bmd08=g_bmd08 AND bmd02=g_bmd02
        IF SQLCA.sqlcode THEN
            CALL cl_err3("del","bmd_file",g_bmd08,g_bmd02,SQLCA.sqlcode,"","BODY DELETE:",1) # TQC-660046
        ELSE
            CLEAR FORM
            CALL g_bmd.clear()
            LET g_row_count = 0   #TQC-C40231 add
            FOREACH i6042_count INTO l_bmd08,l_bmd02
                LET g_row_count = g_row_count + 1
            END FOREACH
            #TQC-C40231--mark--str--
            ##FUN-B50062-add-start--
            #IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            #   CLOSE i6042_bcs
            #   CLOSE i6042_count
            #   COMMIT WORK
            #   RETURN
            #END IF
            ##FUN-B50062-add-end--
            #TQC-C40231--mark--end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i6042_bcs
           FOR i=1 TO l_i-1
             IF g_bmd08 <> 'ALL' THEN
                SELECT COUNT(*) INTO l_n FROM bmd_file
                 WHERE bmd01=l_bmd01[i]
                   AND (bmd08='ALL' OR bmd08=g_bmd08)
                   AND bmdacti = 'Y'                                           #CHI-910021
                IF l_n = 0 THEN
                   UPDATE bmb_file SET bmb16='0',
                                       bmbdate=g_today     #FUN-C40007 add
                    WHERE bmb01 = g_bmd08
                      AND bmb03 = l_bmd01[i]
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","bmd_file","",g_bmd08,SQLCA.sqlcode,"","",0)
                END IF
                END IF
                #MOD-D20004---begin
                IF l_n = 1 THEN
                   SELECT bmd02 INTO l_bmd02
                     FROM bmd_file 
                    WHERE bmd01=l_bmd01[i] 
                      AND (bmd08='ALL' OR bmd08=g_bmd08)
                      AND bmdacti = 'Y' 
                         
                   UPDATE bmb_file SET bmb16 = l_bmd02
                    WHERE bmb01=g_bmd08 
                      AND bmb03=l_bmd01[i]
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd","bmd_file",l_bmd01[i],g_bmd08,SQLCA.sqlcode,"","",1)
                   END IF   
                END IF        
                #MOD-D20004---end
             ELSE
                SELECT COUNT(*) INTO l_n FROM bmd_file
                 WHERE bmd01=l_bmd01[i]
                   AND (bmd08<>'ALL'  OR bmd08=g_bmd08)
                   AND bmdacti = 'Y'                                           #CHI-910021
                IF l_n = 0 THEN
                   UPDATE bmb_file SET bmb16='0',
                                       bmbdate=g_today     #FUN-C40007 add
                   # WHERE bmb01 = g_bmd08
                     WHERE bmb03 = l_bmd01[i]
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","bmd_file","",g_bmd08,SQLCA.sqlcode,"","",0)
                END IF
                END IF
              END IF
             END FOR
            IF g_row_count >= 1 THEN    #TQC-C40231 add
               IF g_curs_index = g_row_count + 1 THEN
                  LET g_jump = g_row_count
                  CALL i6042_fetch('L')
               ELSE
                  LET g_jump = g_curs_index
                  LET mi_no_ask = TRUE
                  CALL i6042_fetch('/')
               END IF
            ELSE
               LET g_bmd08 = NULL       #TQC-C40231 add
               LET g_bmd02 = NULL       #TQC-C40231 add
            END IF
            LET g_delete='Y'
            #TQC-C40231--mark--str--
            #LET g_bmd08 = NULL
            #LET g_bmd02 = NULL
            #LET g_cnt=SQLCA.SQLERRD[3]
            #MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            #TQC-C40231--mark--end--
            MESSAGE 'DELETE O.K'  #TQC-C40231 add
        END IF
    END IF
END FUNCTION
 
 
#單身
FUNCTION i6042_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT   #No.FUN-680096 SMALLINT
    l_n,l_n1        LIKE type_file.num5,     #檢查重複用  #No.FUN-680096 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-680096 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態    #No.FUN-680096 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,     #可新增否    #No.FUN-680096 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否    #No.FUN-680096 SMALLINT
    l_cnt           LIKE type_file.num5      #FUN-660173 add  #No.FUN-680096 SMALLINT
DEFINE  l_i         LIKE type_file.num5,     #No.TQC-C20420
        l_sum_bmd07 LIKE bmd_file.bmd07      #No.TQC-C20420
DEFINE  l_num       LIKE type_file.num5      #MOD-C30538 
DEFINE  l_bmd02     LIKE bmd_file.bmd02      #TQC-C40178 add

    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF                #檢查權限
    IF g_bmd08 IS NULL THEN
        RETURN
    END IF
 
    CALL cl_opmsg('b')
    LET g_forupd_sql =
      " SELECT bmd01,'','',bmd11,bmd03,bmd04,'','',bmd05,bmd06,bmd09,bmd07, ", #No.TQC-C20420 add bmd11
      "        ta_bmd01,bmduser,bmdgrup,bmdmodu,bmddate,bmdacti ",   #No.FUN-740196 add
      " FROM bmd_file ",
      "  WHERE bmd08= ? ",
      "   AND bmd02= ? ",
      "   AND bmd01= ? ",
      "   AND bmd03= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i6042_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
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
 
                OPEN i6042_bcl USING g_bmd08,g_bmd02,g_bmd_t.bmd01,g_bmd_t.bmd03
                IF STATUS THEN
                    CALL cl_err("OPEN i6042_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i6042_bcl INTO g_bmd[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET g_bmd[l_ac].ima02_a=g_bmd_t.ima02_a
                     LET g_bmd[l_ac].ima021_a=g_bmd_t.ima021_a #MOD-550064
                     LET g_bmd[l_ac].ima02_b=g_bmd_t.ima02_b   #MOD-550064
                    LET g_bmd[l_ac].ima021_b=g_bmd_t.ima021_b
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
#TQC-C20420--------add--------begin
            IF g_bmd02 = '3' THEN
               LET g_bmd[l_ac].bmd11 = 'N'        #TQC-C40178 add
               #darcy:2023/04/28 add s---
               if p_cmd != 'u' then
                let g_bmd[l_ac].ta_bmd01 = 'N'
               end if
               #darcy:2023/04/28 add e---
               DISPLAY BY NAME g_bmd[l_ac].bmd11,g_bmd[l_ac].ta_bmd01  #TQC-C40178 add
               CALL cl_set_comp_entry("bmd11",TRUE)
            ELSE
               LET g_bmd[l_ac].bmd11 = 'N'
               DISPLAY BY NAME g_bmd[l_ac].bmd11
               CALL cl_set_comp_entry("bmd11",FALSE)
            END IF
#TQC-C20420--------add--------end
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO bmd_file
              (bmd08, bmd02, bmd03, bmd04,
               bmd05, bmd06, bmd07, bmd01, bmd09,bmd11,          #TQC-C20131  add bmd11
               ta_bmd01,   #darcy:2023/04/28 add
               bmduser,bmdgrup,bmddate,bmdacti,bmdoriu,bmdorig)       #No.FUN-740196 add
            VALUES(g_bmd08,g_bmd02,
                   g_bmd[l_ac].bmd03,g_bmd[l_ac].bmd04,
                  #g_bmd[l_ac].bmd05,NULL,g_bmd[l_ac].bmd07,                #MOD-B90280 mark
                   g_bmd[l_ac].bmd05,g_bmd[l_ac].bmd06,g_bmd[l_ac].bmd07,   #MOD-B90280 add
                   g_bmd[l_ac].bmd01,g_bmd[l_ac].bmd09,# 'N',      #TQC-C20131  add 'N' #TQC-C20420 mark 'N'
                   g_bmd[l_ac].bmd11,                              #TQC-C20420 add bmd11
                   g_bmd[l_ac].ta_bmd01,  #darcy:2023/04/28 add
                   g_bmd[l_ac].bmduser,g_bmd[l_ac].bmdgrup,   #No.FUN-740196 add
                   g_bmd[l_ac].bmddate,g_bmd[l_ac].bmdacti, g_user, g_grup)   #No.FUN-740196 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
 

 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","bmb_file",g_bmd08,g_bmd[l_ac].bmd01,SQLCA.sqlcode,"","",1) # TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
           #MOD-C30357 -- add -- begin
            IF g_bmd02 = '3' THEN
               #LET g_bmd02 = '9'     #TQC-C40178 mark 
               LET l_bmd02 = '9'      #TQC-C40178 add
            ELSE                      #TQC-C40178 add
               LET l_bmd02 = g_bmd02  #TQC-C40178 add
            END IF                             
           #MOD-C30357 -- add -- end
            IF g_bmd08 = 'ALL' THEN
               IF cl_confirm('abm-030') THEN
                  UPDATE bmb_file SET bmb16=l_bmd02,   #TQC-C40178  g_bmd02-->l_bmd02
                                      bmbdate=g_today  #FUN-C40007 add
                   WHERE bmb03=g_bmd[l_ac].bmd01
               END IF
            ELSE
               UPDATE bmb_file SET bmb16=l_bmd02,      #TQC-C40178  g_bmd02-->l_bmd02
                                   bmbdate=g_today     #FUN-C40007 add
                WHERE bmb01=g_bmd08 AND bmb03=g_bmd[l_ac].bmd01
            END IF
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmd[l_ac].* TO NULL      #900423
            LET g_bmd[l_ac].bmd05=TODAY
            LET g_bmd[l_ac].bmd07=1
            LET g_bmd_t.* = g_bmd[l_ac].*         #新輸入資料
            LET g_bmd[l_ac].bmduser = g_user
            LET g_bmd[l_ac].bmdgrup = g_grup
            LET g_bmd[l_ac].bmddate = g_today
            LET g_bmd[l_ac].bmdacti = 'Y'
            LET g_bmd[l_ac].bmd11='N'             #TQC-C20420 add
            let g_bmd[l_ac].ta_bmd01='N'          #darcy:2023/04/28 add
            LET g_bmd[l_ac].bmdacti = 'Y'  #No.MOD-C30266
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmd01
 
        AFTER FIELD bmd01            #
	    IF NOT cl_null(g_bmd[l_ac].bmd01) THEN
              #FUN-AA0059 --------------------------add start------------------------
               IF NOT s_chk_item_no(g_bmd[l_ac].bmd01,'') THEN
                  CALL cl_err('',g_errno,1) 
                  LET g_bmd[l_ac].bmd01 = g_bmd_t.bmd01
                  DISPLAY g_bmd[l_ac].bmd01 TO s_bmd[l_sl].bmd01
                  NEXT FIELD bmd01
               END IF 
              #FUN-AA0059 ---------------------------add end------------------------- 
               CALL i6042_bmd01('a')
               IF NOT cl_null(g_errno) THEN
	          IF g_errno='mfg9116' THEN
	             IF NOT cl_confirm(g_errno)
	             	THEN NEXT FIELD bmd01
	             END IF
	          ELSE
                     CALL cl_err(g_bmd[l_ac].bmd01,g_errno,0)
                     LET g_bmd[l_ac].bmd01 = g_bmd_t.bmd01
                     DISPLAY g_bmd[l_ac].bmd01 TO s_bmd[l_sl].bmd01
                     NEXT FIELD bmd01
	          END IF
               END IF
 
                 IF g_bmd08 <> 'ALL' THEN           #MOD-4A0088
                   SELECT * FROM bmb_file
                    WHERE bmb01=g_bmd08 AND bmb03=g_bmd[l_ac].bmd01
                   IF STATUS = 100 THEN
                      CALL cl_err3("sel","bmb_file",g_bmd08,g_bmd[l_ac].bmd01,"abm-742","","",1) # TQC-660046
                      LET g_bmd[l_ac].bmd01=g_bmd_t.bmd01
                      LET g_bmd[l_ac].ima02_a=g_bmd_t.ima02_a
                      LET g_bmd[l_ac].ima021_a=g_bmd_t.ima021_a
                      NEXT FIELD bmd01
                   END IF
                END IF
                IF NOT i6042_chkitm() THEN
                   NEXT FIELD bmd01
                END IF
                #FUN-9C0040--begin--add-------
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM bmb_file
                 WHERE bmb01=g_bmd08
                   AND bmb03=g_bmd[l_ac].bmd01
                   AND bmb14='2'
                IF l_n > 0 THEN
                   CALL cl_err('','asf-604',0)
                   NEXT FIELD bmd01
                END IF
                #FUN-9C0040--end--add--------

#TQC-C20420--------add--------begin
              IF g_bmd[l_ac].bmd11='Y' AND g_bmd02 = '3' THEN
                 IF p_cmd = 'a' OR
                    (p_cmd = 'u' AND g_bmd[l_ac].bmd01 != g_bmd_t.bmd01) THEN
                    SELECT COUNT(*) INTO l_n FROM bmd_file
                     WHERE bmd01 = g_bmd[l_ac].bmd01
                       AND bmd02 = g_bmd02
                       AND bmd08 = g_bmd08
                       AND bmd11 = g_bmd[l_ac].bmd11
                    IF l_n > 0 THEN
                        CALL cl_err('','abm1000',0)
                        LET g_bmd[l_ac].bmd01 = g_bmd_t.bmd01
                        DISPLAY BY NAME g_bmd[l_ac].bmd01
                        NEXT FIELD bmd01
                    END IF
                 END IF
              END IF
#TQC-C20420--------add--------end
            END IF
           #MOD-C70015 str add-----
            IF NOT i6042_chk_dt_range() THEN
               NEXT FIELD bmd05
            END IF
           #MOD-C70015 end add-----
         #darcy:2023/04/28 add s---
        after field ta_bmd01
            if g_bmd[l_ac].ta_bmd01 = 'Y' then
                # 一笔取替代料,只能标记一个自动取替代
                let l_cnt = 0
                select count(1) into l_cnt from bmd_file 
                 where bmd01 = g_bmd[l_ac].bmd01
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

        BEFORE FIELD bmd03                        #default 序號
            #IF p_cmd='a' AND NOT cl_null(g_bmd_t.bmd03) THEN    #MOD-C30269  #MOD-C30657 mark
            IF p_cmd='a' AND cl_null(g_bmd[l_ac].bmd03) THEN         #MOD-C30657 add 
                SELECT max(bmd03)+1
                   INTO g_bmd[l_ac].bmd03
                   FROM bmd_file
                   WHERE bmd08=g_bmd08 AND bmd01=g_bmd[l_ac].bmd01
                     AND bmd02=g_bmd02
            #         AND bmdacti = 'Y'             #CHI-910021  #MOD-C30657 mark 
                IF g_bmd[l_ac].bmd03 IS NULL THEN
                    LET g_bmd[l_ac].bmd03 = 1
                END IF
            END IF
 
        AFTER FIELD bmd03                        #check 序號是否重複
            IF NOT cl_null(g_bmd[l_ac].bmd03) THEN
                IF g_bmd[l_ac].bmd03 != g_bmd_t.bmd03 OR
                   g_bmd_t.bmd03 IS NULL THEN
                    SELECT count(*) INTO l_n FROM bmd_file
                        WHERE bmd08 = g_bmd08
                          AND bmd02 = g_bmd02
                          AND bmd01 = g_bmd[l_ac].bmd01
                          AND bmd03 = g_bmd[l_ac].bmd03
                    #      AND bmdacti = 'Y'               #CHI-910021 #MOD-C30657 mark 
                    IF l_n > 0 THEN
                        CALL cl_err(g_bmd[l_ac].bmd03,-239,0)
                        LET g_bmd[l_ac].bmd03 = g_bmd_t.bmd03
                        DISPLAY g_bmd[l_ac].bmd03 TO s_bmd[l_sl].bmd03
                        NEXT FIELD bmd03
                    END IF
                END IF
            END IF
 
         AFTER FIELD bmd04
             IF NOT cl_null(g_bmd[l_ac].bmd04) THEN
               #FUN-AA0059 -----------------------------add start---------------------
                IF NOT s_chk_item_no(g_bmd[l_ac].bmd04,'') THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD bmd04
                END IF 
               #FUN-AA0059 -----------------------------add end--------------------------
               #合理性的檢查,元件A不應同時有相同的替代料及取代料皆為B的狀況
                IF g_bmd02='1' THEN
                   SELECT COUNT(*) INTO l_cnt FROM bmd_file
                    WHERE bmd01=g_bmd[l_ac].bmd01
                      AND bmd08=g_bmd08
                      AND bmd04=g_bmd[l_ac].bmd04
                      AND bmd02='2'
                      AND bmdacti = 'Y'                                           #CHI-910021
                ELSE
                   SELECT COUNT(*) INTO l_cnt FROM bmd_file
                    WHERE bmd01=g_bmd[l_ac].bmd01
                      AND bmd08=g_bmd08
                      AND bmd04=g_bmd[l_ac].bmd04
                      AND bmd02='1'
                      AND bmdacti = 'Y'                                           #CHI-910021
                END IF
                IF l_cnt > 0 THEN
                   CALL cl_err_msg("","abm-205",g_bmd[l_ac].bmd01 CLIPPED|| "|" || g_bmd[l_ac].bmd04 CLIPPED,10)
                   NEXT FIELD bmd04
                END IF
 
                #檢查替代料不可同主件
                 IF g_bmd08=g_bmd[l_ac].bmd04 THEN
                    CALL cl_err('','mfg2633',0)
                    NEXT FIELD bmd04
                 END IF
 
                 SELECT ima02,ima021 INTO g_bmd[l_ac].ima02_b,g_bmd[l_ac].ima021_b
                   FROM ima_file
                  WHERE ima01=g_bmd[l_ac].bmd04
                 IF STATUS THEN
                    CALL cl_err3("sel","ima_file",g_bmd[l_ac].bmd04,"",SQLCA.sqlcode,"","sel ima:",1) # TQC-660046
                    NEXT FIELD bmd04
                 END IF
                IF NOT i6042_chkitm() THEN
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
             IF NOT i6042_chk_dt_range() THEN
                NEXT FIELD bmd05
             END IF
            #MOD-C70015 end add-----
 
         AFTER FIELD bmd05
            IF NOT i6042_chkdt() THEN
               NEXT FIELD bmd05
            END IF
           #MOD-C80197 str add-----
            IF NOT i6042_chk_dt_range() THEN
               NEXT FIELD bmd05
            END IF
           #MOD-C80197 end add-----
 
         AFTER FIELD bmd06
            IF NOT i6042_chkdt() THEN
               NEXT FIELD bmd06
            END IF
 
            IF NOT i6042_chk_dt_range() THEN
               LET g_bmd[l_ac].bmd05=g_bmd_t.bmd05
               LET g_bmd[l_ac].bmd06=g_bmd_t.bmd06
               DISPLAY BY NAME g_bmd[l_ac].bmd05,g_bmd[l_ac].bmd06
               NEXT FIELD bmd01
            END IF
 
        AFTER FIELD bmd07 
            IF NOT cl_null(g_bmd[l_ac].bmd07) THEN
               IF g_bmd[l_ac].bmd07 <=0 THEN
                  CALL cl_err('','mfg4012',0)
                  NEXT FIELD bmd07
               END IF
            END IF

#TQC-C20420--------add--------begin

        AFTER FIELD bmd11
           IF g_bmd[l_ac].bmd11='Y' AND g_bmd02 = '3'
              AND NOT cl_null(g_bmd[l_ac].bmd01) THEN
              IF p_cmd = 'a' OR
                 (p_cmd = 'u' AND g_bmd[l_ac].bmd11 != g_bmd_t.bmd11) THEN
                 SELECT COUNT(*) INTO l_n FROM bmd_file
                  WHERE bmd01 = g_bmd[l_ac].bmd01
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
#TQC-C20420--------add--------end
 
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
# SELECT SYSDATE INTO l_date FROM DUAL  #日期+时间
              #  CALL cl_ect(g_bmd08,g_bmd_t.bmd01,g_user,'1',g_today,TIME)
              #  INSERT ect_file(ECT01,ECT02,ECT03,ECT04,ECT05,ECT06) values(g_bmd08,)
                DELETE FROM bmd_file
                    WHERE bmd08 = g_bmd08
                      AND bmd02 = g_bmd02
                      AND bmd01 = g_bmd_t.bmd01
                      AND bmd03 = g_bmd_t.bmd03
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmd_file",g_bmd08,g_bmd02,SQLCA.sqlcode,"","",1)  # TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                IF g_bmd08 <> 'ALL' THEN
                SELECT COUNT(*) INTO l_n1 FROM bmd_file
                 WHERE bmd01=g_bmd_t.bmd01
                   AND (bmd08=g_bmd08 OR bmd08 = 'ALL')
                   AND bmdacti = 'Y'                                           #CHI-910021
                   IF l_n1 = 0 THEN 
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate=g_today     #FUN-C40007 add
                       WHERE bmb01 = g_bmd08 AND bmb03 = g_bmd_t.bmd01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","bmd_file","",g_bmd08,SQLCA.sqlcode,"","",0)
                      END IF
                   END IF 
                   #MOD-D20004---begin
                   IF l_n1 = 1 THEN  
                      SELECT bmd02 INTO l_bmd02
                        FROM bmd_file 
                       WHERE bmd01=g_bmd_t.bmd01
                         AND (bmd08='ALL' OR bmd08=g_bmd08)
                         AND bmdacti = 'Y' 
                         
                      UPDATE bmb_file SET bmb16 = l_bmd02
                       WHERE bmb01=g_bmd08 
                         AND bmb03=g_bmd_t.bmd01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","bmd_file",g_bmd_t.bmd01,g_bmd08,SQLCA.sqlcode,"","",1)
                      END IF  
                   END IF       
                   #MOD-D20004---end
                ELSE
                SELECT COUNT(*) INTO l_n1 FROM bmd_file
                 WHERE bmd01=g_bmd_t.bmd01
                   AND (bmd08=g_bmd08 OR bmd08 <> 'ALL')
                   AND bmdacti = 'Y'                                           #CHI-910021
                   IF l_n1 = 0 THEN
                      UPDATE bmb_file SET bmb16 = '0',
                                          bmbdate=g_today     #FUN-C40007 add
                       WHERE bmb03 = g_bmd_t.bmd01
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("upd","bmd_file","",g_bmd08,SQLCA.sqlcode,"","",0)
                      END IF 
                   END IF
                END IF
	        COMMIT WORK
                #CALL s_uima146(g_bmd_t.bmd01)         #MOD-C20159 add  #CHI-D10044
                CALL s_uima146(g_bmd_t.bmd01,0)  #CHI-D10044
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmd[l_ac].* = g_bmd_t.*
               CLOSE i6042_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF NOT i6042_chk_dt_range() THEN
               LET g_bmd[l_ac].* = g_bmd_t.*
               ROLLBACK WORK
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_bmd[l_ac].bmd01,-263,1)
               LET g_bmd[l_ac].* = g_bmd_t.*
            ELSE
                LET g_bmd[l_ac].bmdmodu=g_user          #No.FUN-740196 add
                LET g_bmd[l_ac].bmddate=g_today         #No.FUN-740196 add
                UPDATE bmd_file SET
                             bmd01=g_bmd[l_ac].bmd01,
                             bmd03=g_bmd[l_ac].bmd03,
                             bmd04=g_bmd[l_ac].bmd04,
                             bmd05=g_bmd[l_ac].bmd05,
                             bmd06=g_bmd[l_ac].bmd06,
                             bmd07=g_bmd[l_ac].bmd07,
                             bmd09=g_bmd[l_ac].bmd09,
                             bmd11=g_bmd[l_ac].bmd11,        #TQC-C20420 add
                             ta_bmd01 = g_bmd[l_ac].ta_bmd01, #darcy:2023/04/28 add
                             bmdmodu=g_bmd[l_ac].bmdmodu,   #No.FUN-740196 add
                             bmddate=g_bmd[l_ac].bmddate,   #No.FUN-740196 add
                             bmdacti=g_bmd[l_ac].bmdacti    #No.FUN-740196 add
                 WHERE bmd08=g_bmd08
                   AND bmd02=g_bmd02
                   AND bmd01=g_bmd_t.bmd01
                   AND bmd03=g_bmd_t.bmd03
                IF SQLCA.sqlcode THEN 
                    CALL cl_err3("upd","bmd_file",g_bmd08,g_bmd02,SQLCA.sqlcode,"","",1) # TQC-660046
                    LET g_bmd[l_ac].* = g_bmd_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
	            COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bmd[l_ac].* = g_bmd_t.*
               #TQC-C80017--add--str--
               ELSE
                  CALL g_bmd.deleteElement(l_ac)
               #TQC-C80017--add--end--
               #FUN-D40030--add--str--
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i6042_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
            #CLOSE i6042_bcl  #TQC-C80017 
            #MOD-C20159 str add-----
            IF NOT cl_null(g_bmd[l_ac].bmd01) THEN  #TQC-C80017 add
               IF g_bmd_t.bmd01 <> g_bmd[l_ac].bmd01 OR g_bmd_t.bmd04 <> g_bmd[l_ac].bmd04
                  OR (cl_null(g_bmd_t.bmd01) AND cl_null(g_bmd_t.bmd04)) THEN
                  #CALL s_uima146(g_bmd[l_ac].bmd01)  #CHI-D10044
                  CALL s_uima146(g_bmd[l_ac].bmd01,0)  #CHI-D10044
               END IF
            END IF
            #MOD-C20159 end add-----
            #TQC-C80017--add--str--
            IF cl_null(g_bmd[l_ac].bmd01) THEN
               CALL g_bmd.deleteElement(l_ac)
            END IF
            #TQC-C80017--add--end--
            CLOSE i6042_bcl  #TQC-C80017
            COMMIT WORK
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmd01) AND l_ac > 1 THEN
                LET g_bmd[l_ac].* = g_bmd[l_ac-1].*
                NEXT FIELD bmd01
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
               WHEN INFIELD(bmd01)
                     IF g_bmd08 <> 'ALL' THEN #MOD-4A0100
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_bmb205"   #MOD-830203 modify q_bmb202->q_bmb205
                        LET g_qryparam.arg1 = g_today
                        LET g_qryparam.arg2 = g_bmd08
                        LET g_qryparam.default1 = g_bmd[l_ac].bmd01
                        CALL cl_create_qry() RETURNING g_bmd[l_ac].bmd01
                        DISPLAY g_bmd[l_ac].bmd01 TO bmd01
                        NEXT FIELD bmd01
                    ELSE
#FUN-AA0059 --Bdgin--
                   #     CALL cl_init_qry_var()
                   #     LET g_qryparam.form = "q_ima"
                   #     LET g_qryparam.default1 = g_bmd[l_ac].bmd01
                   #     CALL cl_create_qry() RETURNING g_bmd[l_ac].bmd01
                        CALL q_sel_ima(FALSE, "q_ima", "", g_bmd[l_ac].bmd01, "", "", "", "" ,"",'' )  RETURNING g_bmd[l_ac].bmd01
#FUN-AAA0059 --End--
                        DISPLAY g_bmd[l_ac].bmd01 TO bmd01
                        NEXT FIELD bmd01
                     END IF #MOD-4A0100
 
               WHEN INFIELD(bmd04)
#FUN-AA0059 --Begin--
                  #  CALL cl_init_qry_var()
                  #  LET g_qryparam.form = "q_ima"
                  #  LET g_qryparam.default1 = g_bmd[l_ac].bmd04
                  #  CALL cl_create_qry() RETURNING g_bmd[l_ac].bmd04
                    CALL q_sel_ima(FALSE, "q_ima", "", g_bmd[l_ac].bmd04, "", "", "", "" ,"",'' )  RETURNING g_bmd[l_ac].bmd04
#FUN-AAA0059 --End--
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
  
#TQC-C20420-------add-------begin
      AFTER INPUT
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
         #       WHERE bmd01 = g_bmd[l_ac].bmd01      #TQC-C40178 mark
         #         AND bmd08 = g_bmd08                #TQC-C40178 mark
                WHERE bmd08 = g_bmd08                 #TQC-C40178 add
                  AND bmd02 = g_bmd02
               IF SQLCA.sqlcode THEN
                  LET g_msg = g_bmd[l_ac].bmd01 CLIPPED,' + ', g_bmd08 CLIPPED
                  CALL cl_err3("upd","bmd_file",g_bmd_t.bmd01,g_bmd08_t,SQLCA.sqlcode,"",g_msg,1)
               END IF
               DISPLAY g_bmd10 TO bmd10
            ELSE
               CONTINUE INPUT
            END IF
         END IF
#TQC-C20420-------add-------begin
      
        END INPUT
 
    CLOSE i6042_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION i6042_b_askkey()
DEFINE
    l_wc    LIKE type_file.chr1000    #No.FUN-680096   VARCHAR(300)
 
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
    CALL i6042_bf(l_wc)
END FUNCTION
 
FUNCTION i6042_bf(p_wc)              #BODY FILL UP
DEFINE p_wc     LIKE type_file.chr1000   #No.FUN-680096 VARCHAR(300)
DEFINE i	LIKE type_file.num5      #No.FUN-680096 SMALLINT
 
    LET g_sql =
       "SELECT bmd01, '','',bmd11,bmd03, bmd04, ima02,ima021,bmd05, bmd06, bmd09, bmd07, ", #No.TQC-C20420 add bmd11
       "        ta_bmd01,bmduser,bmdgrup,bmdmodu,bmddate,bmdacti ",   #No.FUN-740196 add
       " FROM bmd_file, OUTER ima_file",
       " WHERE bmd08 = '",g_bmd08,"'",
       "   AND bmd02 = '",g_bmd02,"'",
       "   AND bmd_file.bmd04 = ima_file.ima01",
       "   AND ",p_wc CLIPPED ,
       " ORDER BY 1"
    PREPARE i6042_prepare2 FROM g_sql      #預備一下
    DECLARE bmd_cs CURSOR FOR i6042_prepare2
    CALL g_bmd.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH bmd_cs INTO g_bmd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        SELECT ima02,ima021
          INTO g_bmd[g_cnt].ima02_a,g_bmd[g_cnt].ima021_a
          FROM ima_file
         WHERE ima01=g_bmd[g_cnt].bmd01
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_bmd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    IF g_rec_b>1 THEN
        IF g_bmd[g_rec_b].bmd01='ALL' THEN
            LET g_bmd[g_rec_b+1].*=g_bmd[g_rec_b].*
            FOR i=g_rec_b-1 TO 1 STEP -1
                LET g_bmd[i+1].*=g_bmd[i].*
            END FOR
            LET g_bmd[1].*=g_bmd[g_rec_b+1].*
            INITIALIZE g_bmd[g_rec_b+1].* TO NULL
        END IF
    END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
 
FUNCTION i6042_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680096 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmd TO s_bmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 

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
         CALL i6042_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i6042_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i6042_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i6042_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i6042_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i6042_out()
    IF g_wc IS NULL THEN
       CALL cl_err('','abm-730',0)
    RETURN END IF
 
    MENU ""
       ON ACTION component_p_n_type_print
          LET g_ls="Y"                     #No.FUN-590110
          CALL i6042_out1()
 
       ON ACTION assm_p_n_type_print
          LET g_ls="N"                     #No.FUN-590110
          CALL i6042_out1()                #No.FUN-590110
 
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
 
FUNCTION i6042_out1()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096 SMALLINT
    sr              RECORD
        #order1      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(20)  #FUN-C30190 mark
        #order2      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(20)  #FUN-C30190 mark
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
    DEFINE l_order1 LIKE bmd_file.bmd01    #No.FUN-680096 VARCHAR(20)
    DEFINE l_order2 LIKE bmd_file.bmd01    #No.FUN-680096 VARCHAR(20)
    DEFINE l_sql    LIKE type_file.chr1000 #FUN-C30190 

    CALL cl_wait()
    #FUN-C30190---add---Str
    CALL cl_del_data(l_table)
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   
    #FUN-C30190---add---End
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT '','',bmd01,bmd08,bmd02,bmd03,bmd04,bmd05,bmd06,bmd07",  #No.FUN-590110   #FUN-C30190 add bmd05
              " FROM bmd_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              "   AND bmdacti = 'Y'"                                           #CHI-910021
    PREPARE i6042_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i6042_co                         # CURSOR
        CURSOR FOR i6042_p1
 
    #CALL cl_outnam('abmi6042') RETURNING l_name    #FUN-C30190 mark

    IF g_ls = 'Y' THEN
       LET g_zaa[31].zaa08 = g_x[11]
       LET g_zaa[32].zaa08 = g_x[12]
    ELSE
       LET g_zaa[31].zaa08 = g_x[12]
       LET g_zaa[32].zaa08 = g_x[11]
    END IF
    #START REPORT i6042_rep1 TO l_name              #FUN-C30190 mark

 
    FOREACH i6042_co INTO sr.*
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
        #OUTPUT TO REPORT i6042_rep1(sr.*)
        #FUN-C30190----add----str---
        LET sr.l_order1=l_order1
        LET sr.l_order2=l_order2
        EXECUTE  insert_prep  USING sr.*
        #FUN-C30190----add----end---
    END FOREACH
 
    #FINISH REPORT i6042_rep1      #FUN-C30190  mark
 
    CLOSE i6042_co
    ERROR ""
    #CALL cl_prt(l_name,' ','1',g_len)   #FUN-C30190  mark
    #FUN-C30190-----add---str----
    IF g_ls="Y" THEN
       LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY bmd01,bmd08,bmd02,bmd03"
    ELSE
       LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED," ORDER BY bmd08,bmd01,bmd02,bmd03"
    END IF
    CALL cl_prt_cs3("abmi6042","abmi6042",l_sql,'')
    #FUN-C30190-----add---end----
END FUNCTION
 
#FUN-C30190-----mark-----str-----
#REPORT i6042_rep1(sr)
#DEFINE
#    l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680096 VARCHAR(1)
#    sr              RECORD
#        order1      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(20)
#        order2      LIKE bmd_file.bmd01,   #No.FUN-680096 VARCHAR(20)
#        bmd01       LIKE bmd_file.bmd01,   #
#        bmd08       LIKE bmd_file.bmd08,   #
#        bmd02       LIKE bmd_file.bmd02,   #
#        bmd03       LIKE bmd_file.bmd03,   #行序
#        bmd04       LIKE bmd_file.bmd04,   #舊料料號
#        bmd06       LIKE bmd_file.bmd06,
#        bmd07       LIKE bmd_file.bmd07
#                    END RECORD
#    DEFINE l_order1 LIKE bmd_file.bmd01    #No.FUN-680096 VARCHAR(20)
#    DEFINE l_order2 LIKE bmd_file.bmd01    #No.FUN-680096 VARCHAR(20)
# 
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#    ORDER BY sr.order1,sr.order2,sr.bmd02,sr.bmd03
# 
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2+1),g_x[1]
#            PRINT g_dash[1,g_len]
#            IF g_ls = 'Y' THEN
#               PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#            ELSE
#               PRINT g_x[32],g_x[31],g_x[33],g_x[34],g_x[35],g_x[36]
#            END IF
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
# 
#        BEFORE GROUP OF sr.order1
#          IF g_ls="Y" THEN
#            PRINT COLUMN g_c[31],sr.bmd01 CLIPPED;  #No.TQC-740341 add
#          ELSE
#            PRINT COLUMN g_c[31],sr.bmd08 CLIPPED;  #No.TQC-740341 add
#          END IF
# 
#        BEFORE GROUP OF sr.order2
#          IF g_ls="Y" THEN
#            PRINT COLUMN g_c[32],sr.bmd08 CLIPPED;  #No.TQC-740341 add
#          ELSE
#            PRINT COLUMN g_c[32],sr.bmd01 CLIPPED;  #No.TQC-740341 add
#          END IF
# 
#        BEFORE GROUP OF sr.bmd02
#            PRINT COLUMN g_c[33],sr.bmd02 USING '###&';#FUN-590118
# 
#        ON EVERY ROW
#            PRINT COLUMN g_c[34],sr.bmd03 USING '###&', #FUN-590118
#                  COLUMN g_c[35],sr.bmd04 CLIPPED,  #FUN-5B0013 add
#                  COLUMN g_c[36],sr.bmd07 USING '##########.##'
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
#                PRINT g_x[4]    #No.FUN-590110
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#FUN-C30190-----mark-----end-----  
 
 # 檢查元件料號不可=替代料號
FUNCTION i6042_chkitm()
  IF (g_bmd[l_ac].bmd01 IS NULL) OR (g_bmd[l_ac].bmd04 IS NULL) THEN
    RETURN TRUE
  END IF
  IF (g_bmd[l_ac].bmd01 = g_bmd[l_ac].bmd04) THEN
    CALL cl_err('chk itm','abm-807',0)
    RETURN FALSE
  ELSE
   RETURN TRUE
  END IF
END FUNCTION
 
 # 檢查有兩個替代料時,其有效日期和失效日期區間不可重疊
#Field bmd01,bmd04,bmd05,bmd06 有改變時,應需檢查,考慮輸入方便性,
#                              目前新增只在失效日(bmd06)做檢查,
#                              修改只在ON ROW CHANGE做
FUNCTION i6042_chk_dt_range()
DEFINE l_bmd01   LIKE bmd_file.bmd01
DEFINE l_bmd04   LIKE bmd_file.bmd04
DEFINE l_dt1     LIKE bmd_file.bmd05
DEFINE l_dt2     LIKE bmd_file.bmd06
DEFINE l_bmd03   LIKE bmd_file.bmd03
DEFINE l_n       LIKE type_file.num5       #No.FUN-680096 SMALLINT
DEFINE l_sql,l_where   STRING
   LET l_bmd01=g_bmd[l_ac].bmd01
   LET l_bmd04=g_bmd[l_ac].bmd04
   LET l_dt1=g_bmd[l_ac].bmd05
   LET l_dt2=g_bmd[l_ac].bmd06
   IF (g_bmd[l_ac].bmd03<>g_bmd_t.bmd03) AND (g_bmd_t.bmd03 IS NOT NULL) THEN #>
      LET l_bmd03=g_bmd_t.bmd03
   ELSE
      LET l_bmd03=g_bmd[l_ac].bmd03
   END IF
 
   IF (l_bmd01 IS NULL) OR (l_dt1 IS NULL) OR (l_bmd03 IS NULL) THEN
      RETURN TRUE
   END IF
 
   LET l_where= " WHERE bmd01='",l_bmd01,"' AND bmd04='",l_bmd04,"'",
                " AND bmd08='",g_bmd08,"' AND bmd02='",g_bmd02,"'",
                " AND ",l_bmd03,"<>bmd03 "
 
# #沒有失效日表示永久有效
 
   IF l_dt2 IS NULL THEN #沒有失效日表示永久有效
      #1.先檢查是否已存在永久有效的料件
      LET l_sql="SELECT COUNT(*) FROM bmd_file",l_where,
                " AND bmd06 IS NULL",
                " AND bmdacti = 'Y'"                                           #CHI-910021
      PREPARE i6042_chk_dt_range_s0 from l_sql
      DECLARE i6042_chk_dt_range_c0 CURSOR FOR i6042_chk_dt_range_s0
      OPEN i6042_chk_dt_range_c0
      IF STATUS THEN
         CALL cl_err("chk dt range 0",STATUS,0)
         RETURN FALSE
      END IF
      FETCH i6042_chk_dt_range_c0 INTO l_n
      CLOSE i6042_chk_dt_range_c0
      IF l_n>0 THEN
         CALL cl_err("chk dt range 0","abm-021",0)
         RETURN FALSE
      ELSE
         #2.目前不存在永久有效的料件,且這筆資料有給失效日
         LET l_sql="SELECT COUNT(*) FROM bmd_file",l_where,
                   " AND '",l_dt1,"' <= bmd06",
                   " AND bmdacti = 'Y'"                                           #CHI-910021
      END IF
   ELSE
      LET l_sql="SELECT COUNT(*) FROM bmd_file",l_where,
                " AND (('",l_dt1,"' <= bmd05",
                " AND '",l_dt2,"' >= bmd05)",
                " OR ('",l_dt1,"' <= bmd06",
                " AND '",l_dt2,"' >= bmd06)",
                " OR ('",l_dt1,"' >= bmd05",
                " AND '",l_dt2,"' <= bmd06)",
                " OR ('",l_dt1,"' <= bmd05",
                " AND '",l_dt2,"' >= bmd06)",
                " OR (bmd06 IS NULL AND bmd05 <= '",l_dt2,"'))",
                " AND bmdacti = 'Y'"                                           #CHI-910021
   END IF
   PREPARE i6042_chk_dt_range_s1 from l_sql
   DECLARE i6042_chk_dt_range_c1 CURSOR FOR i6042_chk_dt_range_s1
   OPEN i6042_chk_dt_range_c1
   IF STATUS THEN
      CALL cl_err("chk dt range 1",STATUS,0)
      RETURN FALSE
   END IF
   FETCH i6042_chk_dt_range_c1 INTO l_n
   CLOSE i6042_chk_dt_range_c1
   IF l_n>0 THEN
      CALL cl_err("chk dt range 2","abm-021",0)
      RETURN FALSE
   END IF
 
   RETURN TRUE
 
END FUNCTION
 
 #MOD-530278 by kim 檢查有效日期和失效日期的正確性
FUNCTION i6042_chkdt()
   IF (g_bmd[l_ac].bmd05 IS NULL) OR (g_bmd[l_ac].bmd06 IS NULL) THEN
      RETURN TRUE
   END IF
   IF g_bmd[l_ac].bmd06<=g_bmd[l_ac].bmd05 THEN
      CALL cl_err("chk dt","mfg2604",0)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
#No:FUN-9C0077

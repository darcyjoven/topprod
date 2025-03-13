# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abmi601.4gl
# Descriptions...: 標準BOM 維護作業
# Date & Author..: 97/09/18 By Roger
# Modify.........: No:8660 03/11/06 By Mandy 組成用量可輸入至小數點後三位,合計應
# Modify.........: No:8766 03/11/26 By ching bmbgrup nouse
# Modify.........: No.MOD-470051 04/07/20 By Mandy 加入相關文件功能
# Modify.........: No.MOD-480365 04/08/16 By ching 未更新bmb13
# Modify.........: No.MOD-490217 04/09/13 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4B0024 04/11/04 By Smapmin 主件料號開窗
# Modify.........: No.MOD-4B0191 04/11/18 By Mandy 插件位置是否勾稽是由參數設定(aimi100)來決定, 'Y'則不match不可離開
# Modify.........: No.FUN-550014 05/05/16 By Mandy 特性BOM
# Modify.........: No.FUN-550106 05/05/27 By Smapmin QPA欄位放大
# Modify.........: No.FUN-560021 05/06/08 By kim 配方BOM,視情況 隱藏/顯示 "特性代碼"欄位
# Modify.........: No.FUN-560227 05/06/27 By kim 將組成用量/底數/QPA全部alter成 DEC(16,8)
# Modify.........: No.FUN-590110 05/09/27 By Tracy 修改報表,轉XML格式
# Modify.........: No.MOD-590060 05/10/17 By Rosayu 檢查插件位置是否重複
# Modify.........: No.FUN-5B0013 05/11/01 By Rosayu 將料號/品名/規格 欄位設成[1,,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.FUN-5A0061 05/11/07 By Pengu 1.051103點測修改報表格式
# Modify.........: No.TQC-660046 06/06/23 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-680015 06/08/07 By 1.單身增加"生效日期"
                             #               2.若由abmi600串abmi601時考慮失效日期
# Modify.........: No.FUN-680096 06/09/08 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0002 06/10/19 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-6A0081 06/11/14 By baogui 無接下頁
# Modify.........: No.TQC-6B0149 06/11/24 By Ray 單身的數量錄入不可以是負數
# Modify.........: No.FUN-6B0033 06/11/28 By hellen 新增單頭折疊功能
# Modify.........: No.MOD-6B0077 06/12/13 By pengu 維護插件位置,確認單據後,回寫至bmb_file插件位置,長度被截掉
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760078 07/06/07 By Judy BOM發放后，單身插件位置欄位應不可修改
# Modify.........: No.MOD-760104 07/06/22 By pengu 拿掉單身生效日期欄位
# Modify.........: No.FUN-770052 07/07/03 By xiaofeizhu 制作水晶報表
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.CHI-810006 08/01/22 By xiaofeizhu 報表打印插件位置字段出錯修改
# Modify.........: No.FUN-870127 08/08/19 By arman服飾版
# Modify.........: No.FUN-880072 08/08/19 By jan服飾版過單
# Modify.........: No.MOD-890014 08/09/02 By claire 報表無法連續列印,需關掉程式再執行列印
# Modify.........: No.FUN-8A0124 08/10/28 By hongmei 程式未修改，過單
# Modify.........: No.FUN-8B0023 08/11/06 By arman 單身錯誤 
# Modify.........: No.TQC-930059 09/03/09 By chenyu 修正若程式寫法為SELECT .....寫法會出現ORA-600的錯誤
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.MOD-980108 09/08/13 By Smapmin 當非slk行業就將單身的放大鏡變灰色 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-960270 09/09/23 By destiny 打印時增加放棄按鈕
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No:TQC-9A0117 09/10/23 By liuxqa 替换ROWID
# Modify.........: No:FUN-9C0077 09/12/16 By baofei 程序精簡
# Modify.........: No:MOD-A50007 10/05/03 By Sarah 列印段的SQL條件有問題,寫入Temptable時會寫入兩次
# Modify.........: No:TQC-A60017 10/07/23 By yinhy 單身“插件位置”欄位無法開窗查詢到abmi111裡的基本資料
# Modify.........: No:CHI-960069 10/11/10 By sabrina 一般行業不應限制插件位置須在abmi111中
# Modify.........: No:MOD-B10051 11/01/07 By sabrina 切換營運中心後，畫面的Title也要換成該營運中心的名稱 
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.MOD-BC0045 11/12/07 By ck2yuan 如果單身沒有資料則不進入i601_chk_QPA() 做判斷
# Modify.........: No.FUN-C40007 13/01/10 By Nina 只要程式有UPDATE bmb_file 的任何一個欄位時,多加bmbdate=g_today 
# Modify.........: No:FUN-D40030 13/04/07 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_bmb   RECORD LIKE bmb_file.*,
    g_bmb_t RECORD LIKE bmb_file.*,
    g_bmb_o RECORD LIKE bmb_file.*,
    g_bmb01_t LIKE bmb_file.bmb01,
    g_bmb29_t LIKE bmb_file.bmb29,             #FUN-550014
    b_bmt     RECORD LIKE bmt_file.*,
    g_ima     RECORD LIKE ima_file.*,
    g_wc,g_wc2,g_sql string,                   #No.FUN-580092 HCN
    g_bmt           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        bmt05		LIKE bmt_file.bmt05,
        bmt06		LIKE bmt_file.bmt06,
        bmt07		LIKE bmt_file.bmt07  
                    END RECORD,
    g_bmt_t         RECORD                    #程式變數 (舊值)
        bmt05		LIKE bmt_file.bmt05,
        bmt06		LIKE bmt_file.bmt06,
        bmt07		LIKE bmt_file.bmt07 
                    END RECORD,
    tot		    LIKE bmb_file.bmb06,       #No:8660   #FUN-550106 #FUN-560227
    g_buf           LIKE type_file.chr1000,    #No.FUN-680096  
    g_rec_b         LIKE type_file.num5,       #No.FUN-680096  SMALLINT,   #單身筆數
    l_ac            LIKE type_file.num5,       #No.FUN-680096  SMALLINT,   #目前處理的ARRAY CNT
    g_ls            LIKE type_file.chr1,       #No.FUN-680096     #No.FUN-590110
    g_argv1         LIKE bmb_file.bmb01,       #主件料號  #No.MOD-490217
    g_argv2         LIKE bmb_file.bmb29,       #特性代碼  #No.FUN-550014
    g_argv3         LIKE bmb_file.bmb05,       #失效日期  #No.FUN-680015
    g_argv4         LIKE bmb_file.bmb03        #No.FUN-870127
 
DEFINE   p_row,p_col     LIKE type_file.num5    #No.FUN-680096  SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ...
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   g_i             LIKE type_file.num5    #No.FUN-680096  SMALLINT   #count/index for any purpose
DEFINE   g_msg           LIKE ze_file.ze03      #No.FUN-680096  
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680096  INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680096  SMALLINT
DEFINE   l_table         STRING,                ### FUN-770052 ###                                                                  
         g_str           STRING                 ### FUN-770052 ###
 
MAIN
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
 
    LET g_argv1=ARG_VAL(1)
    LET g_argv2=ARG_VAL(2) #FUN-550014 add
    LET g_argv3=ARG_VAL(3) #No.FUN-680015 add
    LET g_argv4=ARG_VAL(4) #No.FUN-870127
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
## *** FUN-770052 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>>--*** ##                                                      
    LET g_sql = "bmb01.bmb_file.bmb01,",                                                                                            
                "bmb02.bmb_file.bmb02,",                                                                                            
                "bmb03.bmb_file.bmb03,",                                                                                            
                "bmb04.bmb_file.bmb04,",                                                                                            
                "bmb05.bmb_file.bmb05,",                                                                                            
                "bmb06.bmb_file.bmb06,",                                                                                            
                "bmb07.bmb_file.bmb07,",                                                                                            
                "bmt01.bmt_file.bmt01,",                                                                                            
                "bmt02.bmt_file.bmt02,",                                                                                            
                "bmt03.bmt_file.bmt03,",                                                                                            
                "bmt04.bmt_file.bmt04,",                                                                                            
                "bmt06.bmt_file.bmt06,",                                                                                            
                "bmt07.bmt_file.bmt07,",                                                                                            
                "ima01.ima_file.ima01,",
                "ima02.ima_file.ima02,",                                                                                            
                "ima021.ima_file.ima021,",
                "l_buf.type_file.chr1000"                                                                                            
    LET l_table = cl_prt_temptable('abmi601',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?,  
                         ?, ?, ?, ?, ?, ?, ?, ? )"                                                                                     
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                            
    END IF                                                                                                                          
#----------------------------------------------------------CR (1) ------------#
 
    OPEN WINDOW i601_w AT p_row,p_col
         WITH FORM "abm/42f/abmi601"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL cl_set_comp_visible("bmb29",g_sma.sma118='Y')
 
    CALL i601()
    IF NOT cl_null(g_argv1) THEN
        CALL i601_q()
    END IF
    CALL i601_menu()
    CLOSE WINDOW i601_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0060
END MAIN
 
FUNCTION i601()
    INITIALIZE g_bmb.* TO NULL
    INITIALIZE g_bmb_t.* TO NULL
    INITIALIZE g_bmb_o.* TO NULL
    CALL i601_lock_cur()
END FUNCTION
 
FUNCTION i601_lock_cur()
 
    LET g_forupd_sql =
        "SELECT * FROM bmb_file WHERE bmb01 = ? AND bmb02 = ? AND bmb03 = ? AND bmb04 = ? AND bmb29 = ? FOR UPDATE " #No.TQC-9A0117
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
END FUNCTION
 
FUNCTION i601_cs()
DEFINE  lc_qbe_sn      LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM
    CALL g_bmt.clear()
    IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INITIALIZE g_bmb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON
              bmb01,bmb29,bmb04,bmb05,bmb03,bmb02,bmb06,bmb07 #FUN-550014 add bmb29
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
       ON ACTION controlp    #FUN-4B0024
          IF INFIELD(bmb01) THEN
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_bmb204"
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO bmb01
             NEXT FIELD bmb01
          END IF
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
       CONSTRUCT g_wc2 ON bmt05,bmt06,bmt07
            FROM s_bmt[1].bmt05,s_bmt[1].bmt06,s_bmt[1].bmt07
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
    
     # No.TQC-A60017 --start-- 
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(bmt06)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_bmb13"   
	            LET g_qryparam.default1 = g_bmt[1].bmt06
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO s_bmt[1].bmt06
              NEXT FIELD bmt06 
            OTHERWISE EXIT CASE
          END CASE
     # No.TQC-A60017 --end-- 
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN RETURN END IF
     ELSE
      IF g_argv4 IS NULL THEN
       LET g_wc="     bmb01='",g_argv1,"'", #FUN-550014
                " AND bmb29='",g_argv2,"'"  #FUN-550014
      ELSE
       LET g_wc="     bmb01='",g_argv1,"'", #FUN-550014
                " AND bmb03='",g_argv4,"'", #FUN-870127
                " AND bmb29='",g_argv2,"'"  #FUN-550014
      END IF
       LET g_wc2=" 1=1"
    END IF

    IF g_wc2=' 1=1' THEN
       IF cl_null(g_argv1) THEN
          LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmb29 FROM bmb_file ",  #TQC-930059
                    " WHERE ",g_wc CLIPPED," ORDER BY bmb01,bmb02,bmb03,bmb04,bmb29"
       ELSE 
          LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmb29 FROM bmb_file ",  #TQC-930059
                    " WHERE ",g_wc CLIPPED,
                    " AND (bmb04 <='", g_argv3,"'"," OR bmb04 IS NULL )",
                    " AND (bmb05 >  '",g_argv3 CLIPPED,"'"," OR bmb05 IS NULL )",
                    " ORDER BY bmb01,bmb02,bmb03,bmb04,bmb29"                                 #FUN-550014 add bmb29
       END IF
    ELSE
       LET g_sql="SELECT bmb01,bmb02,bmb03,bmb04,bmb29",     #FUN-550014   #TQC-930059
                 "  FROM bmb_file,bmt_file ",
                 " WHERE bmb01=bmt01 AND bmb02=bmt02",
                 "   AND bmb29=bmt08 ",                                                    #FUN-550014
                 "   AND bmb_file.bmb03=bmt_file.bmt03 AND bmb_file.bmb04=bmt_file.bmt04",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                 " ORDER BY bmb01,bmb02,bmb03,bmb04,bmb29"                                 #FUN-550014 add bmb29
    END IF
    PREPARE i601_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE i601_cs SCROLL CURSOR WITH HOLD FOR i601_prepare
    IF g_wc2=' 1=1' THEN
       IF cl_null(g_argv1) THEN
          LET g_sql= "SELECT COUNT(*) FROM bmb_file WHERE ",g_wc CLIPPED
       ELSE
          LET g_sql= "SELECT COUNT(*) FROM bmb_file ", 
                    " WHERE ",g_wc CLIPPED,
                    " AND (bmb04 <='", g_argv3,"'"," OR bmb04 IS NULL )",
                    " AND (bmb05 >  '",g_argv3 CLIPPED,"'"," OR bmb05 IS NULL )" 
       END IF
    ELSE
      LET g_sql= "SELECT COUNT(*) FROM bmb_file,bmt_file  ", 
                 " WHERE bmb01=bmt01 AND bmb02=bmt02",
                 "   AND bmb29=bmt08 ",                                                    #FUN-550014
                 "   AND bmb_file.bmb03=bmt_file.bmt03 AND bmb_file.bmb04=bmt_file.bmt04",
                 "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF 
    PREPARE i601_precount FROM g_sql
    DECLARE i601_count CURSOR FOR i601_precount
END FUNCTION
 
FUNCTION i601_menu()
 
   WHILE TRUE
      CALL i601_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i601_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i601_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i601_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "工廠切換"
       # WHEN "switch_plant"       #FUN-B10030
       #    CALL i601_d()          #FUN-B10300
          WHEN "related_document"                  #MOD-470051
            IF cl_chk_act_auth() THEN
               IF g_bmb.bmb01 IS NOT NULL THEN
                  LET g_doc.column1 = "bmb01"
                  LET g_doc.value1  = g_bmb.bmb01
                  LET g_doc.column2 = "bmb02"
                  LET g_doc.value2  = g_bmb.bmb02
                  LET g_doc.column3 = "bmb03"
                  LET g_doc.value3  = g_bmb.bmb03
                  LET g_doc.column4 = "bmb04"
                  LET g_doc.value4  = g_bmb.bmb04
                  LET g_doc.column5 = "bmb29"      #FUN-550014 add
                  LET g_doc.value5  = g_bmb.bmb29  #FUN-550014 add
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bmt),'','')
            END IF
      END CASE
   END WHILE
      CLOSE i601_cs
END FUNCTION
 
 
FUNCTION i601_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bmb.* TO NULL             #No.FUN-6A0002
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i601_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        CALL g_bmt.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i601_count
    FETCH i601_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i601_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmb.bmb01,SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL
    ELSE
        CALL i601_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i601_fetch(p_flbmb)
    DEFINE
        p_flbmb    LIKE type_file.chr1      #No.FUN-680096     
 
    CASE p_flbmb
        WHEN 'N' FETCH NEXT     i601_cs INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 add bmb29  #TQC-930059
        WHEN 'P' FETCH PREVIOUS i601_cs INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 add bmb29  #TQC-930059
        WHEN 'F' FETCH FIRST    i601_cs INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 add bmb29  #TQC-930059
        WHEN 'L' FETCH LAST     i601_cs INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 add bmb29  #TQC-930059
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump i601_cs INTO g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmb.bmb29 #FUN-550014 add bmb29  #TQC-930059
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_bmb.bmb01,SQLCA.sqlcode,0)
        INITIALIZE g_bmb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flbmb
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_bmb.* FROM bmb_file       # 重讀DB,因TEMP有不被更新特性
       WHERE bmb01=g_bmb.bmb01 AND bmb02=g_bmb.bmb02 AND bmb03=g_bmb.bmb03 AND bmb04=g_bmb.bmb04 AND bmb29=g_bmb.bmb29
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","bmb_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.sqlcode,"","",1)  #No.TQC-660046
    ELSE
        CALL i601_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i601_show()
    LET g_bmb_t.* = g_bmb.*
    DISPLAY BY NAME
           g_bmb.bmb01,g_bmb.bmb29, g_bmb.bmb02, g_bmb.bmb03, #FUN-550014 add bmb29
           g_bmb.bmb04, g_bmb.bmb05, g_bmb.bmb06,
           g_bmb.bmb07
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_bmb.bmb01
    DISPLAY BY NAME g_ima.ima02,g_ima.ima021,g_ima.ima25
    INITIALIZE g_ima.* TO NULL
    SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_bmb.bmb03
    DISPLAY g_ima.ima02,g_ima.ima021,g_ima.ima25 TO ima02b,ima021b,ima25b
    CALL i601_b_fill(g_wc2)
    DISPLAY BY NAME tot
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#FUN-B10030 ------------mark start------------
#FUNCTION i601_d()
#  DEFINE l_plant,l_dbs	LIKE type_file.chr21   #No.FUN-680096  
#
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT 'PLANT CODE:' FOR l_plant
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#  END PROMPT
#  IF l_plant IS NULL THEN RETURN END IF
#  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#  IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#  DATABASE l_dbs
#  CALL cl_ins_del_sid(1,l_plant) #FUN-980030 #FUN-990069
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#  CALL s_chgdbs()           #MOD-B10051 add
#  CALL i601_lock_cur()
#END FUNCTION
#FUN-B10030 ------------------mark end-----------
 
FUNCTION i601_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,   #No.FUN-680096    #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,   #No.FUN-680096  SMALLINT, #未取消的ARRAY CNT
    l_n             LIKE type_file.num5,   #No.FUN-680096  SMALLINT, #檢查重複用
    l_lock_sw       LIKE type_file.chr1,   #No.FUN-680096   #單身鎖住否
    p_cmd           LIKE type_file.chr1,   #No.FUN-680096   #處理狀態
    l_sfb38         LIKE type_file.dat,    #No.FUN-680096  DATE,
    l_ima107        LIKE ima_file.ima107,
    l_allow_insert  LIKE type_file.num5,   #No.FUN-680096  SMALLINT, #可新增否
    l_allow_delete  LIKE type_file.num5    #No.FUN-680096  SMALLINT  #可刪除否
DEFINE l_bma05  LIKE bma_file.bma05   #TQC-760078
DEFINE l_bmt07  LIKE bmt_file.bmt07   #No.FUN-870127
DEFINE l_ima147 LIKE ima_file.ima147  #No.FUN-870127
DEFINE l_n2     LIKE type_file.num5
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_bmb.bmb01 IS NULL THEN RETURN END IF
    SELECT bma05 INTO l_bma05 FROM bma_file,bmb_file
     WHERE bma01 = bmb01 AND bma06 = bmb29 AND bma01 = g_bmb.bmb01
       AND bmb03 = g_bmb.bmb03 AND bmb04 = g_bmb.bmb04
       AND bmb29 = g_bmb.bmb29
    IF l_bma05 IS NOT NULL AND g_sma.sma101 = 'N' THEN                     
       CALL cl_err('','abm-120',0)                                              
       RETURN                                                                   
    END IF                                                                      
    CALL cl_opmsg('b')
    SELECT ima107 INTO l_ima107  FROM ima_file WHERE ima01 = g_bmb.bmb03
    IF l_ima107 = 'N' AND g_sma.sma124 = 'slk' THEN     #CHI-960069 add slk
       CALL cl_err('','abm-032',0)                                              
       RETURN
    END IF
 
    LET g_forupd_sql =
      " SELECT bmt05,bmt06,bmt07 ",
      "   FROM bmt_file ",
      "    WHERE bmt01 = ? ",
      "    AND bmt02 = ? ",
      "    AND bmt03 = ? ",
      "    AND bmt04 = ? ",
      "    AND bmt05 = ? ",
      "    AND bmt08 = ? ",  #FUN-550014 add
      " FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i601_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_success = 'Y'
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
     WHILE TRUE #MOD-4B0191(ADD WHILE....END WHILE)
 
        INPUT ARRAY g_bmt WITHOUT DEFAULTS FROM s_bmt.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            IF g_sma.sma124 <> 'slk' THEN   
               CALL cl_set_action_active('controlp',FALSE)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_bmt_t.* = g_bmt[l_ac].*  #BACKUP
 
                OPEN i601_bcl USING g_bmb.bmb01,g_bmb.bmb02,g_bmb.bmb03,g_bmb.bmb04,g_bmt_t.bmt05,g_bmb.bmb29 #FUN-550014
                IF SQLCA.sqlcode THEN
                    CALL cl_err("OPEN i601_bcl:",SQLCA.sqlcode, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH i601_bcl INTO g_bmt[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_bmt_t.bmt05,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
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
            IF cl_null(g_bmb.bmb02) THEN
               LET g_bmb.bmb02=0
            END IF
            INSERT INTO bmt_file(bmt01,bmt02,bmt03,bmt04,
                                bmt05,bmt06,bmt07,bmt08) #FUN-550014
            VALUES(g_bmb.bmb01,g_bmb.bmb02,
                   g_bmb.bmb03,g_bmb.bmb04,
                   g_bmt[l_ac].bmt05,g_bmt[l_ac].bmt06,
                   g_bmt[l_ac].bmt07,g_bmb.bmb29)   #FUN-550014 add bmb29
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","bmt_file",g_bmb.bmb01,g_bmt[l_ac].bmt05,SQLCA.sqlcode,"","",1)  #No.TQC-660046
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
    SELECT ima147 INTO l_ima147 FROM ima_file WHERE ima01=g_bmb.bmb03
       IF l_ima147 != 'Y' THEN
            SELECT SUM(bmt07) INTO  l_bmt07 FROM bmt_file WHERE bmt01 = g_bmb.bmb01 
                                                      AND bmt02 = g_bmb.bmb02
                                                      AND bmt03 = g_bmb.bmb03
                                                      AND bmt04 = g_bmb.bmb04
                                                      AND bmt08 = g_bmb.bmb29
            UPDATE bmb_file SET bmb06 = l_bmt07,
                                bmbdate=g_today     #FUN-C40007 add
                          WHERE bmb01 = g_bmb.bmb01
                            AND bmb02 = g_bmb.bmb02
                            AND bmb03 = g_bmb.bmb03
                            AND bmb04 = g_bmb.bmb04
                            AND bmb29 = g_bmb.bmb29
            IF SQLCA.sqlcode THEN
               CALL cl_err3("update","bmb_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.sqlcode,"","",1)  
               ROLLBACK WORK
            ELSE
                MESSAGE 'INSERT O.K'
            END IF
        END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_bmt[l_ac].* TO NULL      #900423
            LET g_bmt[l_ac].bmt07 = 0
            LET g_bmt_t.* = g_bmt[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD bmt05
 
        BEFORE FIELD bmt05                        #default 序號
            IF g_bmt[l_ac].bmt05 IS NULL OR
               g_bmt[l_ac].bmt05 = 0 THEN
                SELECT max(bmt05) INTO g_bmt[l_ac].bmt05
                   FROM bmt_file
                   WHERE bmt01 = g_bmb.bmb01 AND bmt02 = g_bmb.bmb02
                     AND bmt03 = g_bmb.bmb03 AND bmt04 = g_bmb.bmb04
                     AND bmt08 = g_bmb.bmb29
                IF g_bmt[l_ac].bmt05 IS NULL THEN
                    LET g_bmt[l_ac].bmt05 = 0
                END IF
                LET g_bmt[l_ac].bmt05 = g_bmt[l_ac].bmt05 + g_sma.sma19
            END IF
 
        AFTER FIELD bmt05                        #check 序號是否重複
            IF g_bmt[l_ac].bmt05 IS NULL THEN
               LET g_bmt[l_ac].bmt05 = g_bmt_t.bmt05
            END IF
            IF NOT cl_null(g_bmt[l_ac].bmt05) THEN
                IF g_bmt[l_ac].bmt05 != g_bmt_t.bmt05 OR
                   g_bmt_t.bmt05 IS NULL THEN
                    SELECT count(*) INTO l_n2
                        FROM bmt_file
                        WHERE bmt01 = g_bmb.bmb01 AND bmt02 = g_bmb.bmb02
                          AND bmt03 = g_bmb.bmb03 AND bmt04 = g_bmb.bmb04
                          AND bmt05 = g_bmt[l_ac].bmt05
                          AND bmt08 = g_bmb.bmb29 #FUN-550014 add
                    IF l_n2 > 0 THEN
                        CALL cl_err('',-239,1)
                        LET g_bmt[l_ac].bmt06 = g_bmt_t.bmt06
                        DISPLAY BY NAME g_bmt[l_ac].bmt06
                        NEXT FIELD bmt05
                    END IF
                END IF
            END IF
        AFTER FIELD bmt06
            IF NOT cl_null(g_bmt[l_ac].bmt06) THEN
              SELECT  count(*) INTO l_n2 FROM bol_file 
                                       WHERE bolacti = 'Y'
                                         AND bol01 = g_bmt[l_ac].bmt06
                IF l_n2 <= 0 AND g_sma.sma124 = 'slk' THEN      # No.FUN-870127  #CHI-960069 add slk
                  CALL cl_err('','asfi115',1)
                  NEXT FIELD bmt06
                END IF
                LET l_n2 = 0
                IF g_bmt[l_ac].bmt06 != g_bmt_t.bmt06
                   OR g_bmt_t.bmt06 IS NULL THEN
                    SELECT count(*) INTO l_n2 FROM bmt_file
                       WHERE bmt01 = g_bmb.bmb01 AND bmt02 = g_bmb.bmb02
                         AND bmt03 = g_bmb.bmb03 AND bmt04 = g_bmb.bmb04
                         AND bmt06 = g_bmt[l_ac].bmt06
                         AND bmt08 = g_bmb.bmb29 #carrier 08/09/26
                    IF l_n2 > 0 THEN    
                         CALL cl_err('',-239,1)
                        LET g_bmt[l_ac].bmt06 = g_bmt_t.bmt06
                        NEXT FIELD bmt06
                    END IF
                END IF
            END IF
            NEXT FIELD bmt07        #No.FUN-8B0023
        AFTER FIELD bmt07
            IF NOT cl_null(g_bmt[l_ac].bmt07) THEN
               IF g_bmt[l_ac].bmt07 <= 0 THEN
                  CALL cl_err(g_bmt[l_ac].bmt07,'afa-043',0)
                  NEXT FIELD bmt07
               END IF

            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_bmt_t.bmt05 > 0 AND g_bmt_t.bmt05 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM bmt_file
                    WHERE bmt01 = g_bmb.bmb01 AND bmt02 = g_bmb.bmb02
                      AND bmt03 = g_bmb.bmb03 AND bmt04 = g_bmb.bmb04
                      AND bmt05 = g_bmt_t.bmt05
                      AND bmt08 = g_bmb.bmb29 #FUN-550014
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","bmt_file",g_bmb.bmb01,g_bmt_t.bmt05,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                CALL i601_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_bmt[l_ac].* = g_bmt_t.*
               CLOSE i601_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_bmt[l_ac].bmt05,-263,1)
                LET g_bmt[l_ac].* = g_bmt_t.*
            ELSE
                UPDATE bmt_file SET
                       bmt05 = g_bmt[l_ac].bmt05,
                       bmt06 = g_bmt[l_ac].bmt06,
                       bmt07 = g_bmt[l_ac].bmt07
                 WHERE bmt01 = g_bmb.bmb01
                   AND bmt02 = g_bmb.bmb02
                   AND bmt03 = g_bmb.bmb03
                   AND bmt04 = g_bmb.bmb04
                   AND bmt05 = g_bmt_t.bmt05
                   AND bmt08 = g_bmb.bmb29 #FUN-550014
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","bmt_file",g_bmb.bmb01,g_bmt_t.bmt05,SQLCA.sqlcode,"","",1)  #No.TQC-660046
                    LET g_bmt[l_ac].* = g_bmt_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
    SELECT ima147 INTO l_ima147 FROM ima_file WHERE ima01=g_bmb.bmb03
       IF l_ima147 != 'Y' THEN
                SELECT SUM(bmt07) INTO  l_bmt07 FROM bmt_file WHERE bmt01 = g_bmb.bmb01 
                                                          AND bmt02 = g_bmb.bmb02
                                                          AND bmt03 = g_bmb.bmb03
                                                          AND bmt04 = g_bmb.bmb04
                                                          AND bmt08 = g_bmb.bmb29
                UPDATE bmb_file SET bmb06 = l_bmt07,
                                    bmbdate=g_today     #FUN-C40007 add
                              WHERE bmb01 = g_bmb.bmb01
                                AND bmb02 = g_bmb.bmb02
                                AND bmb03 = g_bmb.bmb03
                                AND bmb04 = g_bmb.bmb04
                                AND bmb29 = g_bmb.bmb29
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("update","bmb_file",g_bmb.bmb01,g_bmb.bmb02,SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                ELSE
                    MESSAGE 'UPDATE O.K'
                END IF
       END IF
            END IF
 
        AFTER ROW
#問題所在,同after insert一樣,此種情況不能再重新(NEXT FIELD)

            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D40030
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_bmt[l_ac].* = g_bmt_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_bmt.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i601_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D40030
 
           CALL i601_up_bmb13() #BugNo:4476
 
            CLOSE i601_bcl
            COMMIT WORK
 

 
        ON ACTION CONTROLP
         CASE WHEN INFIELD(bmt06) 
              IF g_sma.sma124 = 'slk' THEN      #CHI-960069 add
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bmb13"
                 LET g_qryparam.default1 = g_bmt[l_ac].bmt06
                 CALL cl_create_qry() RETURNING g_bmt[l_ac].bmt06
                 DISPLAY g_bmt[l_ac].bmt06 TO bmt06
                 NEXT FIELD bmt06
              END IF      #CHI-960069 add
           OTHERWISE EXIT CASE
         END  CASE
         
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(bmt05) AND l_ac > 1 THEN
                LET g_bmt[l_ac].* = g_bmt[l_ac-1].*
                NEXT FIELD bmt05
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      END INPUT
      CALL i601_b_tot()
      IF g_bmt.getLength()>0 THEN    #MOD-BC0045 add
        CALL i601_chk_QPA()
      END IF                         #MOD-BC0045 add
        IF NOT cl_null(g_errno) THEN
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE i601_bcl
    IF g_success = 'Y' THEN
        COMMIT WORK
    ELSE
        ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION i601_b_tot()
   SELECT SUM(bmt07) INTO tot
          FROM bmt_file
         WHERE bmt01 = g_bmb.bmb01 AND bmt02 = g_bmb.bmb02
           AND bmt03 = g_bmb.bmb03 AND bmt04 = g_bmb.bmb04
           AND bmt08 = g_bmb.bmb29    #FUN-870127
   IF cl_null(tot) THEN LET tot = 0 END IF
   DISPLAY BY NAME tot
END FUNCTION
 
FUNCTION i601_b_askkey()
DEFINE
    l_wc2       LIKE type_file.chr1000  #No.FUN-680096      
 
    CONSTRUCT g_wc2 ON bmt05,bmt06,bmt07
            FROM s_bmt[1].bmt05,s_bmt[1].bmt06,s_bmt[1].bmt07
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i601_b_fill(l_wc2)
END FUNCTION
 
FUNCTION i601_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2      LIKE type_file.chr1000   #No.FUN-680096  
 
    LET g_sql =
        "SELECT bmt05,bmt06,bmt07",      
        " FROM bmt_file",
        " WHERE bmt01 ='",g_bmb.bmb01,"' AND bmt02 ='",g_bmb.bmb02,"'",
        "   AND bmt03 ='",g_bmb.bmb03,"' AND bmt04 ='",g_bmb.bmb04,"'",
        "   AND bmt08 ='",g_bmb.bmb29,"' ",  #FUN-550014 add
        "   AND ",p_wc2 CLIPPED,    #No.TQC-A60017
        " ORDER BY 1"
    PREPARE i601_pb FROM g_sql
    DECLARE bmt_curs CURSOR FOR i601_pb
 
    CALL g_bmt.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    LET tot = 0
    FOREACH bmt_curs INTO g_bmt[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET tot = tot + g_bmt[g_cnt].bmt07
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_bmt.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    DISPLAY BY NAME tot
END FUNCTION
 
FUNCTION i601_up_bmb13()
 DEFINE l_bmt06   LIKE bmt_file.bmt06,
        l_bmb13   LIKE bmb_file.bmb13,
        l_i       LIKE type_file.num5,   #No.FUN-680096  SMALLINT,
        i,j       LIKE type_file.num5,   #No.MOD-6B0077 add
        p_ac      LIKE type_file.num5    #No.FUN-680096  SMALLINT
 
    LET l_bmb13=' '
    LET l_i = 0
    DECLARE up_bmb13_cs CURSOR FOR
     SELECT bmt06 FROM bmt_file
      WHERE bmt01=g_bmb.bmb01
        AND bmt02=g_bmb.bmb02
        AND bmt03=g_bmb.bmb03
        AND bmt04=g_bmb.bmb04
        AND bmt08=g_bmb.bmb29 #FUN-550014 add
 
    FOREACH up_bmb13_cs INTO l_bmt06
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     IF l_i = 0 THEN
        LET l_bmb13=l_bmt06
     ELSE
        IF (Length(l_bmb13) + Length(l_bmt06)) > 8 THEN
           LET j = 10 - Length(l_bmb13)
           FOR i=1 TO j
               LET l_bmb13 = l_bmb13 CLIPPED , '.'
           END FOR
           EXIT FOREACH
        ELSE
           LET l_bmb13= l_bmb13 CLIPPED , ',', l_bmt06
        END IF
     END IF
     LET l_i = l_i + 1
    END FOREACH
    UPDATE bmb_file
      SET bmb13 = l_bmb13,
          bmbdate=g_today     #FUN-C40007 add 
      WHERE bmb01=g_bmb.bmb01
        AND bmb02=g_bmb.bmb02
        AND bmb03=g_bmb.bmb03
        AND bmb04=g_bmb.bmb04
        AND bmb29=g_bmb.bmb29
END FUNCTION
 
FUNCTION i601_chk_QPA()
 DEFINE l_i       LIKE type_file.num10  #No.FUN-680096  INTEGER
 DEFINE g_ima147  LIKE ima_file.ima147
 DEFINE g_qpa     LIKE bmb_file.bmb06   #FUN-550106 #FUN-560227

    LET g_errno = ''
    SELECT ima147 INTO g_ima147 FROM ima_file WHERE ima01=g_bmb.bmb03
    LET g_qpa = g_bmb.bmb06 / g_bmb.bmb07
    LET tot = 0
    FOR l_i = 1 TO g_bmt.getLength()
        IF cl_null(g_bmt[l_i].bmt07) THEN
            EXIT FOR
        END IF
        LET tot = tot + g_bmt[l_i].bmt07
    END FOR
    DISPLAY tot TO FORMONLY.tot
    LET g_errno = NULL
    IF g_ima147 = 'Y' AND (tot != g_qpa) THEN
       CALL cl_err(tot,'mfg2765',1)
       LET g_errno = 'mfg2765'
    END IF
END FUNCTION
 
 
FUNCTION i601_bp(p_ud)
   DEFINE   p_ud  LIKE type_file.chr1      #No.FUN-680096  
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bmt TO s_bmt.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i601_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i601_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION jump
         CALL i601_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION next
         CALL i601_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
      ON ACTION last
         CALL i601_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
         END IF
         ACCEPT DISPLAY   #FUN-530067(smin)
 
 
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
    #@ON ACTION 工廠切換
    # ON ACTION switch_plant                 #FUN-B10030
    #    LET g_action_choice="switch_plant"  #FUN-B10030
    #    EXIT DISPLAY                        #FUN-B10030 
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i601_out()
    IF g_wc IS NULL THEN
        CALL cl_err('','9057',0)
    RETURN END IF
 
    MENU ""
       ON ACTION assm_p_n_type_print
          LET g_ls="Z"        #No.FUN-590110   依主件
          CALL i601_out1()

       ON ACTION component_p_n_type_print
          LET g_ls="Y"        #No.FUN-590110   依元件
          CALL i601_out1()    #No.FUN-590110
 
       ON ACTION inser_loc_print
          LET g_ls="C"        #No.FUN-590110   依插件
          CALL i601_out1()    #No.FUN-590110
 
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
 
FUNCTION i601_out1()
DEFINE
    l_i             LIKE type_file.num5,   #No.FUN-680096  SMALLINT,
    l_name          LIKE type_file.chr20,  #No.FUN-680096     #External(Disk) file name
    l_buf           LIKE type_file.chr1000,#No.FUN-770052    
    l_order1        LIKE bmb_file.bmb01,   #No.FUN-680096    #No.FUN-590110
    l_order2        LIKE bmb_file.bmb02,   #No.FUN-680096    #No.FUN-590110
    l_order3        LIKE bmb_file.bmb02,   #No.FUN-680096    #No.FUN-590110
    l_order4        LIKE bmb_file.bmb01,   #No.FUN-680096    #No.FUN-590110
    l_order5        LIKE bmb_file.bmb02,   #No.FUN-680096    #No.FUN-590110
    l_order6        LIKE bmb_file.bmb03,   #No.FUN-680096    #No.FUN-590110
    l_order7        LIKE bmb_file.bmb04,   #No.FUN-680096    #No.FUN-590110
    l_sql           STRING,                #No.FUN-770052
    l_wc            STRING,                #No.MOD-890014
    sr              RECORD                 #No.FUN-590110
        order1      LIKE bmb_file.bmb01,   #No.FUN-680096  
        order2      LIKE bmb_file.bmb02,   #No.FUN-680096  
        order3      LIKE bmb_file.bmb02,   #No.FUN-680096  
        order4      LIKE bmb_file.bmb01,   #No.FUN-680096  
        order5      LIKE bmb_file.bmb02,   #No.FUN-680096  
        order6      LIKE bmb_file.bmb03,   #No.FUN-680096  
        order7      LIKE bmb_file.bmb04,   #No.FUN-680096  
        bmb01       LIKE bmb_file.bmb01,
        bmb02       LIKE bmb_file.bmb02,
        bmb03       LIKE bmb_file.bmb03,
        bmb04       LIKE bmb_file.bmb04,
        bmb05       LIKE bmb_file.bmb05,
        bmb06       LIKE bmb_file.bmb06,
        bmb07       LIKE bmb_file.bmb07,
        bmt01       LIKE bmt_file.bmt01,
        bmt02       LIKE bmt_file.bmt02,
        bmt03       LIKE bmt_file.bmt03,
        bmt04       LIKE bmt_file.bmt04,
        bmt06       LIKE bmt_file.bmt06,
        bmt07       LIKE bmt_file.bmt07
                    END RECORD
    CALL cl_wait()
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> FUN-770052 *** ##                                                    
    CALL cl_del_data(l_table)                                                                                                      
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   ### FUN-770052 add ###                                              
    #------------------------------ CR (2) ------------------------------# 
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

    # 組合出 SQL 指令
    LET g_sql="SELECT '','','','','','','',bmb01,bmb02,bmb03,bmb04,bmb05,bmb06,",
              "       bmb07,bmt01,bmt02,bmt03,bmt04,bmt06,bmt07",#No.FUN-590110
              " FROM bmb_file",
              " LEFT OUTER JOIN bmt_file ON bmb01 = bmt01 AND bmb02 = bmt02 ",
              "                         AND bmb03 = bmt03 AND bmb04 = bmt04 ", #No.TQC-9A0117 mod
              "                         AND bmb29 = bmt08 ",                   #MOD-A50007 add
              " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED    #No.TQC-9A0117 mod
    PREPARE i601_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i601_co CURSOR FOR i601_p1
 
    FOREACH i601_co INTO sr.*
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF

       IF g_ls!="C" THEN 
          LET l_buf = NULL
       END IF                                                                                              
       IF l_buf IS NULL                                                                                                        
          THEN LET l_buf=sr.bmt06                                                                                              
          ELSE LET l_buf=l_buf CLIPPED,' ',sr.bmt06                                                                            
       END IF                                                                                                                  
       IF sr.bmt07<>1 THEN                                                                                                     
          LET l_buf=l_buf CLIPPED,'*',sr.bmt07 USING '<<'                                                                      
       END IF        
       IF g_ls="Z" THEN
          INITIALIZE g_ima.* TO NULL                                 #FUN-770052                                                   
          SELECT * INTO g_ima.* FROM ima_file WHERE ima01=sr.bmb01   #FUN-770052                                                   
       ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
          EXECUTE insert_prep USING                                                                                                
             sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb05,sr.bmb06,'','','',                                                  
             '','',sr.bmt06,sr.bmt07,'',g_ima.ima02,g_ima.ima021,l_buf         #CHI-810006                              
       #------------------------------ CR (3) ------------------------------# 
       ELSE
          IF g_ls="Y" THEN
             INITIALIZE g_ima.* TO NULL                                 #FUN-770052                                                   
             SELECT * INTO g_ima.* FROM ima_file WHERE ima01=sr.bmb03   #FUN-770052                                                   
          ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
             EXECUTE insert_prep USING                                                                                                
                     sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb05,sr.bmb06,'','','',                                                  
                     '','',sr.bmt06,sr.bmt07,'',g_ima.ima02,g_ima.ima021,l_buf         #CHI-810006                                    
          #------------------------------ CR (3) ------------------------------# 
          ELSE
             IF g_ls="C" THEN                                         #FUN-770052
                INITIALIZE g_ima.* TO NULL                                 #FUN-770052                                                   
                SELECT * INTO g_ima.* FROM ima_file WHERE ima01=sr.bmb01   #FUN-770052                                                   
               #str MOD-A50007 add
                ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
                EXECUTE insert_prep USING                                                                                                
                   sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb05,'','','','',                                                        
                   '','',sr.bmt06,sr.bmt07,'',g_ima.ima02,g_ima.ima021,l_buf          #CHI-810006                          
                #------------------------------ CR (3) ------------------------------#    
               #end MOD-A50007 add
             END IF
          END IF
       END IF                                                       #FUN-770052 
      #str MOD-A50007 mark
      ### *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> FUN-770052 *** ##                                                   
      #EXECUTE insert_prep USING                                                                                                
      #   sr.bmb01,sr.bmb02,sr.bmb03,sr.bmb04,sr.bmb05,'','','','',                                                        
      #   '','',sr.bmt06,sr.bmt07,'',g_ima.ima02,g_ima.ima021,l_buf          #CHI-810006                          
      ##------------------------------ CR (3) ------------------------------#    
      #end MOD-A50007 mark
    END FOREACH
 
 
    CLOSE i601_co
    ERROR ""
 
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'bmb01,bmb29,bmb04,bmb05,bmb03,bmb02,bmb06,bmb07')                                                                                                  
            RETURNING l_wc    #MOD-890014                                                                                                          
           #RETURNING g_wc    #MOD-890014 mark                                                                                                      
    END IF                                                                                                                          
 
 ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> FUN-770052 **** ##                                                        
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    LET g_str = ''                                                                                                                  
    LET g_str = g_ls,";",l_wc  #MOD-890014                                                                                                                
    CALL cl_prt_cs3('abmi601','abmi601',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------# 
END FUNCTION
 
#No:FUN-9C0077

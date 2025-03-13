# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli013.4gl
# Descriptions...: 合併報表關係人遞延項攤銷維護作業
# Date & Author..: 07/05/22 By Sarah
# Modify.........: No.FUN-750078 07/05/22 By Sarah 新增"合併報表關係人遞延項攤銷維護作業"
# Modify.........: No.FUN-750051 07/05/24 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760167 07/06/23 By Sarah 
#                  1.按[產生] action 時,項次輸入條件後,還是全部帶出  
#                  2.攤銷資料有資料,但源頭卻可以砍掉
#                  3.若已產生出資料,再產生其它期數資料時,應可產生(程式INSERT/UPDATE成功與否的判斷不標準)
#                  4.不成功時也show 成功訊息
#                  5.[攤銷資料產生]程式段寫法不標準,規格應是QBE
#                  6.攤銷資料有資料,但無法B.單身
#                  7.報表格式調整
# Modify.........: No.FUN-770086 07/07/26 By kim 合併報表功能修改
# Modify.........: No.FUN-780068 07/10/09 By Sarah 單身刪除的WHERE條件句,axw04的部份應該用g_axw_t.axw04
# Modify.........: No.FUN-7B0087 07/11/15 By Nicole 修正 rpt樣版標準名稱
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/19 By hongmei由11區追單, 串axe_file時,增加串axe13(族群代號)=axw03  
# Modify.........: NO.FUN-930074 09/10/29 by yiting axv_pk add axv11
# Modify.........: No.FUN-920123 10/08/16 By vealxu 將使用axzacti的地方mark
# Modify.........: NO.MOD-A80155 10/09/13 BY yiting i013_axv傳遞參數移除axw11 
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: NO.TQC-B40136 11/04/18 BY yinhy 去掉i013_axv函数axv11=p_axv11條件
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:FUN-D30032 13/04/03 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-BA0012
#FUN-BA0006 
#模組變數(Module Variables)
DEFINE 
    g_axw01          LIKE axw_file.axw01,      #FUN-750078
    g_axw02          LIKE axw_file.axw02,  
    g_axw03          LIKE axw_file.axw03,  
    g_axw031         LIKE axw_file.axw031,     #FUN-770086
    g_axw01_t        LIKE axw_file.axw01, 
    g_axw02_t        LIKE axw_file.axw02, 
    g_axw03_t        LIKE axw_file.axw03, 
    g_axw031_t       LIKE axw_file.axw031,     #FUN-770086
    g_axw            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        axw04        LIKE axw_file.axw04,      #項次
        axw05        LIKE axw_file.axw05,      #交易性質
        axw06        LIKE axw_file.axw06,      #交易類別
        axw07        LIKE axw_file.axw07,      #來源公司
        axz02_s      LIKE axz_file.axz02,      #公司名稱
        axw08        LIKE axw_file.axw08,      #交易公司
        axz02_t      LIKE axz_file.axz02,      #公司名稱
        axw11        LIKE axw_file.axw11,      #來源幣別
        axw16        LIKE axw_file.axw16,      #分配未實現損益
        axw17        LIKE axw_file.axw17,      #攤銷總期數
        axw18        LIKE axw_file.axw18,      #已攤銷期數
        axw19        LIKE axw_file.axw19,      #已攤銷金額
        axw20        LIKE axw_file.axw20       #結案否
                     END RECORD,
    g_axw_t          RECORD                 #程式變數 (舊值)
        axw04        LIKE axw_file.axw04,      #項次
        axw05        LIKE axw_file.axw05,      #交易性質
        axw06        LIKE axw_file.axw06,      #交易類別
        axw07        LIKE axw_file.axw07,      #來源公司
        axz02_s      LIKE axz_file.axz02,      #公司名稱
        axw08        LIKE axw_file.axw08,      #交易公司
        axz02_t      LIKE axz_file.axz02,      #公司名稱
        axw11        LIKE axw_file.axw11,      #來源幣別
        axw16        LIKE axw_file.axw16,      #分配未實現損益
        axw17        LIKE axw_file.axw17,      #攤銷總期數
        axw18        LIKE axw_file.axw18,      #已攤銷期數
        axw19        LIKE axw_file.axw19,      #已攤銷金額
        axw20        LIKE axw_file.axw20       #結案否
                     END RECORD,
    g_axx01          LIKE axx_file.axx01,  
    g_axx02          LIKE axx_file.axx02,  
    g_axx03          LIKE axx_file.axx03,  
    g_axx            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        axx04        LIKE axx_file.axx04,      #項次
        axx05        LIKE axx_file.axx05,      #攤銷年度
        axx06        LIKE axx_file.axx06,      #攤銷期別
        axx07        LIKE axx_file.axx07,      #本期攤銷金額
        axx08        LIKE axx_file.axx08       #本期攤銷合併幣別金額
                     END RECORD,
    g_axx_t          RECORD                    #程式變數 (舊值)   #FUN-780068 add
        axx04        LIKE axx_file.axx04,      #項次
        axx05        LIKE axx_file.axx05,      #攤銷年度
        axx06        LIKE axx_file.axx06,      #攤銷期別
        axx07        LIKE axx_file.axx07,      #本期攤銷金額
        axx08        LIKE axx_file.axx08       #本期攤銷合併幣別金額
                     END RECORD,
    i                LIKE type_file.num5,
    g_wc,g_wc1,g_wc2 STRING,             
    g_wc3            STRING,                   #TQC-760167 add
    g_sql            STRING,
    g_rec_b          LIKE type_file.num5,      #單身筆數
    l_ac             LIKE type_file.num5,      #目前處理的ARRAY CNT
    g_rec_b_s        LIKE type_file.num5,      #攤銷資料單身筆數
    l_ac_s           LIKE type_file.num5       #攤銷資料目前處理的ARRAY CNT
 
#主程式開始
DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE SQL       
DEFINE   g_sql_tmp      STRING
DEFINE   g_cnt          LIKE type_file.num10
DEFINE   g_msg          LIKE type_file.chr1000
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_i            LIKE type_file.num5    #count/index for any purpose        #No.FUN-680098 smallint
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   g_flag         LIKE type_file.chr1
DEFINE   g_bookno1      LIKE aza_file.aza81
DEFINE   g_bookno2      LIKE aza_file.aza82
DEFINE   p_row,p_col    LIKE type_file.num5
 
MAIN
DEFINE p_row,p_col     LIKE type_file.num5
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET i=0
   LET g_axw01_t = NULL
   LET g_axw02_t = NULL
   LET g_axw03_t = NULL
   LET g_axw031_t = NULL #FUN-770086
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW i013_w AT p_row,p_col WITH FORM "agl/42f/agli013" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL i013_menu()
   CLOSE FORM i013_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i013_cs()
   CLEAR FORM                            #清除畫面
   CALL g_axw.clear()
 
   #螢幕上取條件
   INITIALIZE g_axw01 TO NULL      #No.FUN-750051
   INITIALIZE g_axw02 TO NULL      #No.FUN-750051
   INITIALIZE g_axw03 TO NULL      #No.FUN-750051
   INITIALIZE g_axw031 TO NULL      #FUN-770086
   CONSTRUCT g_wc ON axw01,axw02,axw03,axw031,axw04,axw05,axw06,axw07, #FUN-770086
                     axw08,axw11,axw16,axw17,axw18,axw19,axw20
                FROM axw01,axw02,axw03,axw031,s_axw[1].axw04,s_axw[1].axw05, #FUN-770086
                     s_axw[1].axw06,s_axw[1].axw07,s_axw[1].axw08,
                     s_axw[1].axw11,s_axw[1].axw16,s_axw[1].axw17,
                     s_axw[1].axw18,s_axw[1].axw19,s_axw[1].axw20
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axw03)     #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axw03 
                 NEXT FIELD axw03
            #FUN-770086...................begin
            WHEN INFIELD(axw031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axw031
                 NEXT FIELD axw031
            #FUN-770086...................end
            WHEN INFIELD(axw07)     #來源公司 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axb5"
                 CALL GET_FLDBUF(axw03) RETURNING g_axw03
                 LET g_qryparam.arg1 = g_axw03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axw07 
                 NEXT FIELD axw07
            WHEN INFIELD(axw08)     #交易公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axb5"
                 CALL GET_FLDBUF(axw03) RETURNING g_axw03
                 LET g_qryparam.arg1 = g_axw03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO axw08 
                 NEXT FIELD axw08
            WHEN INFIELD(axw11)     #交易幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axw11 
                 NEXT FIELD axw11
            OTHERWISE 
                 EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about    
         CALL cl_about()
 
      ON ACTION help 
         CALL cl_show_help() 
 
      ON ACTION controlg 
         CALL cl_cmdask()
    
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE axw01,axw02,axw03,axw031 FROM axw_file ", #FUN-770086
              " WHERE ", g_wc CLIPPED,
              " ORDER BY axw01,axw02,axw03,axw031"  #FUN-770086
   PREPARE i013_prepare FROM g_sql        #預備一下
   DECLARE i013_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i013_prepare
 
   LET g_sql_tmp = "SELECT UNIQUE axw01,axw02,axw03,axw031 ", #FUN-770086
                   "  FROM axw_file ",
                   " WHERE ", g_wc CLIPPED,
                   " INTO TEMP x "
   DROP TABLE x
   PREPARE i013_pre_x FROM g_sql_tmp
   EXECUTE i013_pre_x
 
   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i013_precnt FROM g_sql
   DECLARE i013_cnt CURSOR FOR i013_precnt
END FUNCTION
 
FUNCTION i013_menu()
DEFINE l_wc   STRING
 
   WHILE TRUE
      CALL i013_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i013_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i013_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i013_r()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i013_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i013_out()
            END IF
         WHEN "generate"               #資料產生
            IF cl_chk_act_auth() THEN
               CALL i013_g()
            END IF
         WHEN "share_generate"         #攤銷資料產生
            IF cl_chk_act_auth() THEN
               CALL i013_sg()
               CALL i013_b_fill(g_wc)
            END IF
         WHEN "maintain_share_data"    #攤銷資料維護
            CALL i013_s()
            CALL i013_b_fill(g_wc)
         WHEN "output_share_data"      #攤銷資料列印 
            IF cl_chk_act_auth() THEN
               CALL i013_tm_s()        #TQC-760167 add 
            END IF
         WHEN "close_the_case"         #結案
            IF l_ac>0 THEN #FUN-770086
               CALL i013_c(g_axw[l_ac].axw20)
               CALL i013_b_fill(g_wc)
            END IF 
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_axw01 IS NOT NULL THEN
                  LET g_doc.column1 = "axw01"
                  LET g_doc.column2 = "axw02"
                  LET g_doc.column3 = "axw03"
                  LET g_doc.value1 = g_axw01
                  LET g_doc.value2 = g_axw02
                  LET g_doc.value3 = g_axw03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i013_a()
   IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_axw.clear()
   INITIALIZE g_axw01 LIKE axw_file.axw01         #DEFAULT 設定
   INITIALIZE g_axw02 LIKE axw_file.axw02         #DEFAULT 設定
   INITIALIZE g_axw03 LIKE axw_file.axw03         #DEFAULT 設定
   INITIALIZE g_axw031 LIKE axw_file.axw031         #DEFAULT 設定 #FUN-770086
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i013_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_axw01=NULL
         LET g_axw02=NULL
         LET g_axw03=NULL
         LET g_axw031=NULL #FUN-770086
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      # KEY 不可空白
      IF cl_null(g_axw01) OR cl_null(g_axw02) OR cl_null(g_axw03) OR 
         cl_null(g_axw031) THEN #FUN-770086
         CONTINUE WHILE
      END IF
 
      CALL g_axw.clear()
      LET g_rec_b = 0 
      CALL i013_b()                              #輸入單身
#     SELECT rowid INTO g_axw_rowid FROM axw_file              #09/10/19 xiaofeizhu Mark        
#      WHERE axw01 = g_axw01 AND axw02 = g_axw02               #09/10/19 xiaofeizhu Mark  
#        AND axw03 = g_axw03 AND axw031 = g_axw031 #FUN-770086 #09/10/19 xiaofeizhu Mark
      LET g_axw01_t = g_axw01                    #保留舊值
      LET g_axw02_t = g_axw02                    #保留舊值
      LET g_axw03_t = g_axw03                    #保留舊值
      LET g_axw031_t = g_axw031                    #保留舊值  #FUN-770086
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i013_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入
       l_n1,l_n        LIKE type_file.num5,    
       p_cmd           LIKE type_file.chr1     #a:輸入 u:更改
    
   DISPLAY g_axw01,g_axw02,g_axw03,g_axw031 TO axw01,axw02,axw03,axw031 #FUN-770086
 
   INPUT g_axw01,g_axw02,g_axw03,g_axw031 FROM axw01,axw02,axw03,axw031 #FUN-770086
      AFTER FIELD axw01   #年度
         IF cl_null(g_axw01) OR g_axw01 = 0 THEN
            CALL cl_err(g_axw01,'afa-370',0)
            NEXT FIELD axw01
         END IF
         IF g_axw01< 0 THEN NEXT FIELD axw01 END IF
         CALL s_get_bookno(g_axw01) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag = '1' THEN
            CALL cl_err(g_axw01,'aoo-081',1)
            NEXT FIELD axw01
         END IF
 
      AFTER FIELD axw02   #期別
         IF cl_null(g_axw02) OR g_axw02 < 0 OR g_axw02 > 12 THEN
            CALL cl_err(g_axw02,'agl-013',0)
            NEXT FIELD axw02
         END IF
 
      AFTER FIELD axw03   #族群代號
         IF NOT cl_null(g_axw03) THEN
            SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = g_axw03
            IF l_n = 0 THEN 
               CALL cl_err3("sel","axa_file",g_axw03,"","agl-117","","",1)
               NEXT FIELD axw03
            END IF
         END IF
 
      #FUN-770086.................begin
      AFTER FIELD axw031   #上層公司
         IF NOT i013_chk_axw031() THEN
            NEXT FIELD CURRENT
         END IF
         CALL i012_set_axz02(g_axw031)
      #FUN-770086.................end
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axw03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_axw03
               CALL cl_create_qry() RETURNING g_axw03
               DISPLAY g_axw03 TO axw03 
               NEXT FIELD axw03
            #FUN-770086...................begin
            WHEN INFIELD(axw031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"
                 CALL cl_create_qry() RETURNING g_axw031
                 DISPLAY g_axw031 TO axw031
                 NEXT FIELD axw031
            #FUN-770086...................end
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about 
         CALL cl_about() 
 
      ON ACTION help 
         CALL cl_show_help() 
    
   END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i013_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_axw01 TO NULL
   INITIALIZE g_axw02 TO NULL
   INITIALIZE g_axw03 TO NULL
   INITIALIZE g_axw031 TO NULL  #FUN-770086
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axw.clear()
 
   CALL i013_cs()                           #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0             
      RETURN                       
   END IF                           
 
   OPEN i013_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axw01 TO NULL
      INITIALIZE g_axw02 TO NULL
      INITIALIZE g_axw03 TO NULL
      INITIALIZE g_axw03 TO NULL  #FUN-770086
   ELSE
      OPEN i013_cnt
      FETCH i013_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i013_fetch('F')                 # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i013_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1,       #處理方式
       l_abso       LIKE type_file.num10       #絕對的筆數
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i013_bcs INTO g_axw01,g_axw02,g_axw03,g_axw031 #FUN-770086
      WHEN 'P' FETCH PREVIOUS i013_bcs INTO g_axw01,g_axw02,g_axw03,g_axw031 #FUN-770086
      WHEN 'F' FETCH FIRST    i013_bcs INTO g_axw01,g_axw02,g_axw03,g_axw031 #FUN-770086
      WHEN 'L' FETCH LAST     i013_bcs INTO g_axw01,g_axw02,g_axw03,g_axw031 #FUN-770086
      WHEN '/' 
          IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0  ######add for prompt bug
              PROMPT g_msg CLIPPED,': ' FOR g_jump
                 ON IDLE g_idle_seconds
                    CALL cl_on_idle()
 
                 ON ACTION about 
                    CALL cl_about() 
 
                 ON ACTION help 
                    CALL cl_show_help()
 
                 ON ACTION controlg   
                    CALL cl_cmdask() 
              
              END PROMPT
              IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
          END IF
          FETCH ABSOLUTE g_jump i013_bcs INTO g_axw01,g_axw02,g_axw03,g_axw031 #FUN-770086
          LET g_no_ask = FALSE
   END CASE
 
   SELECT UNIQUE axw01,axw02,axw03
     FROM axw_file 
    WHERE axw01 = g_axw01 AND axw02 = g_axw02 AND axw03 = g_axw03 
      AND axw031 = g_axw031 #FUN-770086
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err3("sel","axw_file",g_axw01,g_axw02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_axw01 TO NULL
      INITIALIZE g_axw02 TO NULL
      INITIALIZE g_axw03 TO NULL
      INITIALIZE g_axw031 TO NULL #FUN-770086
   ELSE
      CALL s_get_bookno(g_axw01) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(g_axw01,'aoo-081',1)
      END IF
 
      CALL i013_show()
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
FUNCTION i013_show()
 
   DISPLAY g_axw01,g_axw02,g_axw03,g_axw031 TO axw01,axw02,axw03,axw031   #單頭  #FUN-770086
   CALL i012_set_axz02(g_axw031) #FUN-770086
   CALL i013_b_fill(g_wc)                                 #單身
   CALL cl_show_fld_cont() 
 
END FUNCTION
 
FUNCTION i013_b_fill(p_wc)
#DEFINE p_wc       LIKE type_file.chr1000
 DEFINE p_wc       STRING      #NO.FUN-910082
 
   LET g_sql = "SELECT axw04,axw05,axw06,axw07,'',axw08,'',",
               "       axw11,axw16,axw17,axw18,axw19,axw20 ",
               "  FROM axw_file ",
               " WHERE axw01 =  ",g_axw01 CLIPPED,
               "   AND axw02 =  ",g_axw02 CLIPPED,
               "   AND axw03 = '",g_axw03 CLIPPED,"'",
               "   AND axw031 = '",g_axw031 CLIPPED,"'", #FUN-770086
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axw04"
   PREPARE i013_prepare2 FROM g_sql      #預備一下
   DECLARE axw_cs CURSOR FOR i013_prepare2
 
   CALL g_axw.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH axw_cs INTO g_axw[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT axz02 INTO g_axw[g_cnt].axz02_s FROM axz_file   #來源公司名稱
       WHERE axz01=g_axw[g_cnt].axw07
      SELECT axz02 INTO g_axw[g_cnt].axz02_t FROM axz_file   #交易公司名稱
       WHERE axz01=g_axw[g_cnt].axw08
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_axw.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i013_r()
   DEFINE    l_cnt       LIKE type_file.num5    #TQC-760167 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_axw01 IS NULL OR g_axw02 IS NULL OR g_axw03 IS NULL OR g_axw031 IS NULL THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN 
   END IF
   BEGIN WORK
   IF cl_delh(15,16) THEN
      #str TQC-760167 add
      #若已有攤銷資料則不可刪除
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM axx_file
       WHERE axx01 = g_axw01 AND axx02 = g_axw02 
         AND axx03 = g_axw03 AND axx031 = g_axw031
      IF l_cnt > 0 THEN  
         CALL cl_err("", "agl-951", 1) 
         RETURN           
      END IF
      #end TQC-760167 add
      DELETE FROM axw_file WHERE axw01=g_axw01 AND axw02=g_axw02 
         AND axw03=g_axw03 AND axw031=g_axw031 #FUN-770086
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
         CALL cl_err3("del","axw_file",g_axw01,g_axw03,SQLCA.sqlcode,"","",1)
      ELSE 
         CLEAR FORM
         CALL g_axw.clear()
         LET g_sql = "SELECT UNIQUE axw01,axw02,axw03,axw031 FROM axw_file ",
                     "INTO TEMP y"
         DROP TABLE y
         PREPARE i013_pre_y FROM g_sql
         EXECUTE i013_pre_y
         LET g_sql = "SELECT COUNT(*) FROM y"
         PREPARE i013_precnt2 FROM g_sql
         DECLARE i013_cnt2 CURSOR FOR i013_precnt2
         OPEN i013_cnt2
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i013_bcs
             CLOSE i013_cnt2 
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i013_cnt2 INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i013_bcs
             CLOSE i013_cnt2 
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i013_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i013_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i013_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
#單身
FUNCTION i013_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,     #檢查重複用
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
       p_cmd           LIKE type_file.chr1,     #處理狀態
       l_allow_insert  LIKE type_file.num5,     #可新增否
       l_allow_delete  LIKE type_file.num5,     #可刪除否
       l_axz05         LIKE axz_file.axz05,     #帳別
       l_cnt           LIKE type_file.num5      #TQC-760167 add     
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT axw04,axw05,axw06,axw07,'',axw08,'', ",
                      "       axw11,axw16,axw17,axw18,axw19,axw20 ",
                      "  FROM axw_file ",
                      "  WHERE axw01 = ? AND axw02 = ? ",
                      "   AND axw03 = ? AND axw031= ? AND axw04 = ? FOR UPDATE" #FUN-770086
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_axw WITHOUT DEFAULTS FROM s_axw.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_axw_t.* = g_axw[l_ac].*  #BACKUP
            OPEN i013_bcl USING g_axw01,g_axw02,g_axw03,g_axw031,
                                g_axw[l_ac].axw04 #FUN-770086
            IF STATUS THEN
               CALL cl_err("OPEN i013_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i013_bcl INTO g_axw[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_axw_t.axw04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i013_axz(p_cmd,g_axw[l_ac].axw07,"s")   #來源公司名稱
               CALL i013_axz(p_cmd,g_axw[l_ac].axw08,"t")   #交易公司名稱
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axw[l_ac].* TO NULL   
         LET g_axw_t.* = g_axw[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()   
         NEXT FIELD axw04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_axw[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axw[l_ac].* TO s_axw.*
            CALL g_axw.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO axw_file(axw01,axw02,axw03,axw031,axw04,axw05,axw06,axw07, #FUN-770086
                              axw08,axw11,axw16,axw17,axw18,axw19,axw20,axwlegal) #FUN-980003 add
                       VALUES(g_axw01,g_axw02,g_axw03,g_axw031,
                              g_axw[l_ac].axw04, #FUN-770086
                              g_axw[l_ac].axw05,g_axw[l_ac].axw06,
                              g_axw[l_ac].axw07,g_axw[l_ac].axw08,
                              g_axw[l_ac].axw11,g_axw[l_ac].axw16,
                              g_axw[l_ac].axw17,g_axw[l_ac].axw18,
                              g_axw[l_ac].axw19,g_axw[l_ac].axw20,g_legal)  #FUN-980003 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axw_file",g_axw01,g_axw02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE 'INSERT O.K'
         END IF
 
      BEFORE FIELD axw04                        #default 項次
         IF g_axw[l_ac].axw04 IS NULL OR g_axw[l_ac].axw04 = 0 THEN
            SELECT max(axw04)+1 INTO g_axw[l_ac].axw04
              FROM axw_file
             WHERE axw01 = g_axw01 AND axw02 = g_axw02 AND axw03 = g_axw03
               AND axw031 = g_axw031 #FUN-770086
            IF g_axw[l_ac].axw04 IS NULL THEN
               LET g_axw[l_ac].axw04 = 1
            END IF
         END IF
 
      AFTER FIELD axw04
         IF NOT cl_null(g_axw[l_ac].axw04) THEN
            IF g_axw[l_ac].axw04 != g_axw_t.axw04 OR g_axw_t.axw04 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM axw_file
                WHERE axw01 = g_axw01 AND axw02 = g_axw02 
                  AND axw03 = g_axw03 AND axw031= g_axw031 #FUN-770086
                  AND axw04 = g_axw[l_ac].axw04
               IF l_n > 0 THEN
                  CALL cl_err(g_axw[l_ac].axw04,-239,0)
                  LET g_axw[l_ac].axw04 = g_axw_t.axw04
                  NEXT FIELD axw04
               END IF
            END IF
            CALL i013_axv(p_cmd,g_axw01,g_axw02,g_axw03,g_axw031,
                          g_axw[l_ac].axw04) #FUN-770086  #MOD-A80155 取消mark
                          #g_axw[l_ac].axw04,g_axw[l_ac].axw11) #FUN-770086 #FUN-930074 mod
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axw[l_ac].axw04,g_errno,0)
               LET g_axw[l_ac].axw04 = g_axw_t.axw04
               DISPLAY BY NAME g_axw[l_ac].axw04
               NEXT FIELD axw04
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_axw_t.axw04 > 0 AND g_axw_t.axw04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            #str TQC-760167 add
            #若已有攤銷資料則不可刪除
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM axx_file
             WHERE axx01 = g_axw01 AND axx02 = g_axw02 AND axx03 = g_axw03
               AND axx04 = g_axw[l_ac].axw04
            IF l_cnt > 0 THEN  
               CALL cl_err("", "agl-951", 1) 
               CANCEL DELETE 
            END IF
            #end TQC-760167 add
 
            DELETE FROM axw_file
             WHERE axw01 = g_axw01 AND axw02 = g_axw02 AND axw03 = g_axw03
               AND axw031= g_axw031        #FUN-770086
               AND axw04 = g_axw_t.axw04   #FUN-780068 mod
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axw_file",g_axw01,g_axw_t.axw04,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            ELSE
               LET g_rec_b = g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_axw[l_ac].* = g_axw_t.*
            CLOSE i013_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axw[l_ac].axw04,-263,1)
            LET g_axw[l_ac].* = g_axw_t.*
         ELSE
            UPDATE axw_file SET axw04 = g_axw[l_ac].axw04,
                                axw17 = g_axw[l_ac].axw17, 
                                axw18 = g_axw[l_ac].axw18, 
                                axw19 = g_axw[l_ac].axw19, 
                                axw20 = g_axw[l_ac].axw20 
             WHERE axw01 = g_axw01 AND axw02 = g_axw02 AND axw03 = g_axw03
               AND axw031 = g_axw031 #FUN-770086
               AND axw04 = g_axw_t.axw04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axw_file",g_axw01,g_axw_t.axw04,SQLCA.sqlcode,"","",1)
               LET g_axw[l_ac].* = g_axw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac  #FUN-D30032
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #LET g_axw[l_ac].* = g_axw_t.*  FUN-D30032 mark
            #FUN-D30032--add--str--
            IF p_cmd = 'u' THEN
               LET g_axw[l_ac].* = g_axw_t.*
            ELSE
               CALL g_axw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF 
            CLOSE i013_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac  #FUN-D30032
         LET g_axw_t.* = g_axw[l_ac].*
         CLOSE i013_bcl
         COMMIT WORK
         CALL g_axw.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axw04)     #項次
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axv"
                 LET g_qryparam.default1 = g_axw[l_ac].axw04
                 LET g_qryparam.arg1 = g_axw01
                 LET g_qryparam.arg2 = g_axw02
                 LET g_qryparam.arg3 = g_axw03
                 CALL cl_create_qry() RETURNING g_axw[l_ac].axw04
                 DISPLAY BY NAME g_axw[l_ac].axw04 
                 NEXT FIELD axw04
            OTHERWISE 
                 EXIT CASE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axw04) AND l_ac > 1 THEN
            LET g_axw[l_ac].* = g_axw[l_ac-1].*
            LET g_axw[l_ac].axw04 = g_axw[l_ac-1].axw04 + 1 
            NEXT FIELD axw04
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help()  
 
   END INPUT
 
   CLOSE i013_bcl
   COMMIT WORK
 
END FUNCTION
 
#FUNCTION i013_axv(p_cmd,p_axv01,p_axv02,p_axv03,p_axv031,p_axv04,p_axv11)  #FUN-930074  #MOD-A80155 mark
FUNCTION i013_axv(p_cmd,p_axv01,p_axv02,p_axv03,p_axv031,p_axv04)   #MOD-A80155 取消mark
   DEFINE p_cmd       LIKE type_file.chr1,
          p_axv01     LIKE axv_file.axv01,
          p_axv02     LIKE axv_file.axv02,
          p_axv03     LIKE axv_file.axv03,
          p_axv031    LIKE axv_file.axv031, #FUN-770086
          p_axv04     LIKE axv_file.axv04,
          p_axv11     LIKE axv_file.axv11,  #FUN-930074
          l_axv       RECORD LIKE axv_file.*
 
   SELECT * INTO l_axv.* FROM axv_file 
    WHERE axv01=p_axv01 AND axv02=p_axv02 
      AND axv03=p_axv03 AND axv031=p_axv031 AND axv04=p_axv04 #FUN-770086
      #AND axv11=p_axv11  #FUN-930074   #No.TQC-B40136 mark
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'axm-141'
                               INITIALIZE l_axv.* TO NULL
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_axw[l_ac].axw04 = l_axv.axv04
      LET g_axw[l_ac].axw05 = l_axv.axv05
      LET g_axw[l_ac].axw06 = l_axv.axv06
      LET g_axw[l_ac].axw07 = l_axv.axv07
      LET g_axw[l_ac].axw08 = l_axv.axv08
      LET g_axw[l_ac].axw11 = l_axv.axv11
      LET g_axw[l_ac].axw16 = l_axv.axv16
      #來源公司名稱
      SELECT axz02 INTO g_axw[l_ac].axz02_s
        FROM axz_file WHERE axz01=l_axv.axv07
      #交易公司名稱
      SELECT axz02 INTO g_axw[l_ac].axz02_t
        FROM axz_file WHERE axz01=l_axv.axv08
      DISPLAY BY NAME g_axw[l_ac].axw04,g_axw[l_ac].axw05,g_axw[l_ac].axw06,
                      g_axw[l_ac].axw07,g_axw[l_ac].axw08,g_axw[l_ac].axw11,
                      g_axw[l_ac].axw16,g_axw[l_ac].axz02_s,g_axw[l_ac].axz02_t
   END IF
 
END FUNCTION
 
FUNCTION i013_axz(p_cmd,p_axz01,p_st)
   DEFINE p_cmd       LIKE type_file.chr1,
          p_axz01     LIKE axz_file.axz01,
          p_st        LIKE type_file.chr1,
          l_axz02     LIKE axz_file.axz02,
          l_axzacti   LIKE axz_file.axzacti
 
  #SELECT axz02,axzacti INTO l_axz02,l_axzacti               #FUN-920123 mark
   SELECT axz02 INTO l_axz02                                 #FUN-920123
     FROM axz_file WHERE axz01=p_axz01
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-025'
                               LET l_axz02 = NULL
     #WHEN l_axzacti = 'N'     LET g_errno = '9028'          #FUN-920123
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_st = "s" THEN   #來源公司
         LET g_axw[l_ac].axz02_s = l_axz02
         DISPLAY BY NAME g_axw[l_ac].axz02_s
      ELSE                 #交易公司
         LET g_axw[l_ac].axz02_t = l_axz02
         DISPLAY BY NAME g_axw[l_ac].axz02_t
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i013_bp(p_ud)
   DEFINE p_ud     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_axw TO s_axw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()  
 
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
         CALL i013_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY   
                              
      ON ACTION previous
         CALL i013_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY   
                              
      ON ACTION jump
         CALL i013_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
                              
      ON ACTION next
         CALL i013_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
                              
      ON ACTION last
         CALL i013_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION generate               #資料產生
         LET g_action_choice="generate"
         EXIT DISPLAY
 
      ON ACTION share_generate         #攤銷資料產生
         LET g_action_choice="share_generate"
         EXIT DISPLAY
 
      ON ACTION maintain_share_data    #攤銷資料維護
         LET g_action_choice="maintain_share_data"
         EXIT DISPLAY
 
      ON ACTION output_share_data      #攤銷資料列印
         LET g_action_choice="output_share_data"
         EXIT DISPLAY
 
      ON ACTION close_the_case         #結案
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()        
 
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about() 
   
#@    ON ACTION 相關文件  
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i013_g()   #資料產生
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #TQC-760167 add
DEFINE l_flag      LIKE type_file.chr1
 
   OPEN WINDOW i013_g_w AT p_row,p_col WITH FORM "agl/42f/agli013_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("agli013_g")
 
   WHILE TRUE
      #str TQC-760167 mod
      #CONSTRUCT BY NAME g_wc1 ON axv01,axv02,axv03,axv031,axv04 #FUN-770086
      CONSTRUCT BY NAME g_wc1 ON axv01,axv02,axv03,axv031,axv04,axv11 #FUN-770086 #FUN-930074
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axv03)   #族群代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axa1"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axv03
                  NEXT FIELD axv03
               #FUN-770086...................begin
               WHEN INFIELD(axv031)    #上層公司
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axz"
                    LET g_qryparam.state="c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO axv031
                    NEXT FIELD axv031
               #FUN-770086...................end
               #--FUN-930074 start---
               WHEN INFIELD(axv11)     #交易幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO axv11 
                    NEXT FIELD axv11
               #--FUN-930074 end-----
               OTHERWISE EXIT CASE
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      #end TQC-760167 mod
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i013_g_w
         RETURN
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i013_g_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'
 
         CALL i013_g1()
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE
 
   CLOSE WINDOW i013_g_w
 
END FUNCTION
 
FUNCTION i013_g1()
DEFINE l_sql       STRING,
       l_cnt       LIKE type_file.num5,   #TQC-760167 add
       l_axv       RECORD LIKE axv_file.*,
       l_axw       RECORD LIKE axw_file.*
 
  #str TQC-760167 add
   LET l_sql = "SELECT COUNT(*) FROM axv_file WHERE ",g_wc1 CLIPPED
   PREPARE i013_g_cnt_p FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('i013_g_cnt_p',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
   DECLARE i013_g_cnt_c CURSOR FOR i013_g_cnt_p
   OPEN i013_g_cnt_c
   FETCH i013_g_cnt_c INTO l_cnt
   CLOSE i013_g_cnt_c
   IF l_cnt = 0 THEN
      CALL cl_err('i013_g_pre1',"aco-058",1)   #TQC-760167 add
      LET g_success='N'
      RETURN
   END IF
  #end TQC-760167 add
 
   LET l_sql = "SELECT * FROM axv_file WHERE ",g_wc1 CLIPPED
   PREPARE i013_g_pre1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('i013_g_pre1',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
   DECLARE i013_g_c1 CURSOR FOR i013_g_pre1
 
   FOREACH i013_g_c1 INTO l_axv.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('i013_g_c1',SQLCA.SQLCODE,1)
         LET g_success='N'
         RETURN
      END IF
 
      LET l_axw.axw01 = l_axv.axv01
      LET l_axw.axw02 = l_axv.axv02
      LET l_axw.axw03 = l_axv.axv03
      LET l_axw.axw031= l_axv.axv031 #FUN-770086
      LET l_axw.axw04 = l_axv.axv04
      LET l_axw.axw05 = l_axv.axv05
      LET l_axw.axw06 = l_axv.axv06
      LET l_axw.axw07 = l_axv.axv07
      LET l_axw.axw08 = l_axv.axv08
      LET l_axw.axw11 = l_axv.axv11
      LET l_axw.axw16 = l_axv.axv16
      LET l_axw.axw17 = 0
      LET l_axw.axw18 = 0
      LET l_axw.axw19 = 0
      LET l_axw.axw20 = 'N'
      LET l_axw.axwlegal = g_legal #FUN-980003 add
      INSERT INTO axw_file VALUES(l_axw.*)
      IF STATUS THEN
         CALL cl_err('i013_g_pre1',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","axw_file",l_axw.axw01,l_axw.axw02,SQLCA.sqlcode,"","",1)
         LET g_success='N'
         RETURN
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i013_sg()   #攤銷資料產生
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #TQC-760167 add
DEFINE tm          RECORD
                    yy     LIKE axw_file.axw01,
                    mm     LIKE axw_file.axw02
                   END RECORD,
       l_flag      LIKE type_file.chr1
 
   OPEN WINDOW i013_sg_w AT p_row,p_col WITH FORM "agl/42f/agli013_sg"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("agli013_sg")
 
   WHILE TRUE
      #str TQC-760167 mod
      CONSTRUCT BY NAME g_wc2 ON axw01,axw02,axw03,axw031,axw04,axw05,
                                 axw06,axw07,axw08 #FUN-770086
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axw03)   #族群代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axa1"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axw03
                  NEXT FIELD axw03
               #FUN-770086...................begin
               WHEN INFIELD(axw031)    #上層公司
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_axz"
                    LET g_qryparam.state="c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO axw031
                    NEXT FIELD axw031
               #FUN-770086...................end
               WHEN INFIELD(g)   #來源公司
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axb5"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axw07
                  NEXT FIELD axw07
               WHEN INFIELD(h)   #交易公司
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axb5"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO axw08
                  NEXT FIELD axw08
               OTHERWISE EXIT CASE
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
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i013_sg_w
         RETURN
      END IF
 
      INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)   #FUN-580031 add
            INITIALIZE tm.* TO NULL
            LET tm.yy = YEAR(g_today)    #現行年度
            LET tm.mm = MONTH(g_today)   #現行期別
            DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
 
         AFTER FIELD yy
            IF cl_null(tm.yy) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD yy
            END IF
            IF tm.yy  < 0 THEN NEXT FIELD yy    END IF
 
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD mm
            END IF
            IF tm.mm  < 0 OR tm.mm>12 THEN NEXT FIELD mm    END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF
 
         #No.FUN-580031 --start--     HCN
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 --end--       HCN
      END INPUT
      #end TQC-760167 mod
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i013_sg_w
         RETURN
      END IF
 
      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i013_sg_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'
 
         CALL i013_sg1(tm.*)
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
      END IF
   END WHILE
 
   CLOSE WINDOW i013_sg_w
 
END FUNCTION
 
FUNCTION i013_sg1(tm)
DEFINE tm          RECORD
                    yy     LIKE axw_file.axw01,
                    mm     LIKE axw_file.axw02
                   END RECORD,
       l_sql       STRING,
       l_axw       RECORD LIKE axw_file.*,
       l_axx       RECORD LIKE axx_file.*,
       l_azi04     LIKE azi_file.azi04
 
   #str TQC-760167 mod
   LET l_sql = "SELECT * FROM axw_file ",
               "WHERE ",g_wc2 CLIPPED," AND axw20='N'"    #尚未結案
   #end TQC-760167 mod
   PREPARE i013_sg_pre1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('i013_sg_pre1',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
   DECLARE i013_sg_c1 CURSOR FOR i013_sg_pre1
   FOREACH i013_sg_c1 INTO l_axw.*
      #抓來源公司的來源幣別的金額取位小數位數(azi04)
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_axw.axw11
 
      LET l_axx.axx01 = l_axw.axw01
      LET l_axx.axx02 = l_axw.axw02
      LET l_axx.axx03 = l_axw.axw03
      LET l_axx.axx031= l_axw.axw031 #FUN-770086
      LET l_axx.axx04 = l_axw.axw04
      LET l_axx.axx05 = tm.yy
      LET l_axx.axx06 = tm.mm
      # 本期攤銷金額  = (分配未實現利益-已攤銷金額)/(攤銷總期數-已攤銷期數)
      LET l_axx.axx07 = (l_axw.axw16-l_axw.axw19)/(l_axw.axw17-l_axw.axw18)   
      CALL cl_digcut(l_axx.axx07,l_azi04) RETURNING l_axx.axx07   #金額取位
      LET l_axx.axx08 = i013_axx08(l_axw.*,l_axx.axx07)
      LET l_axx.axxlegal = g_legal #FUN-980003 add
      INSERT INTO axx_file VALUES(l_axx.*)
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
         CONTINUE FOREACH
      ELSE
         UPDATE axw_file SET axw18=axw18+1,
                             axw19=axw19+l_axx.axx07
          WHERE axw01=l_axw.axw01 AND axw02=l_axw.axw02
            AND axw03=l_axw.axw03 AND axw031=l_axw.axw031 AND axw04=l_axw.axw04 #FUN-770086
         IF SQLCA.SQLCODE AND SQLCA.SQLERRD[3]=0  THEN
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i013_axx08(p_axw,p_axx07)
DEFINE p_axw       RECORD LIKE axw_file.*,
       p_axx07     LIKE axx_file.axx07,   #本期攤銷金額
       l_axx08     LIKE axx_file.axx08,   #本期攤銷合併幣別金額
       l_axa02     LIKE axa_file.axa02,   #上層公司
       l_axz05     LIKE axz_file.axz05,   #上層帳別
       l_axz06     LIKE axz_file.axz06,   #記帳幣別
       l_axz07     LIKE axz_file.axz07,   #功能幣別
       l_axv10     LIKE axv_file.axv10,   #來源科目
       l_axe11     LIKE axe_file.axe11,   #再衡量匯率類別
       l_axe12     LIKE axe_file.axe12,   #換算匯率類別
       l_rate      LIKE axp_file.axp05,   #匯率
       l_azi04     LIKE azi_file.azi04    #金額取位小數位數 
 
   #本期攤銷合併幣別金額(axx08)計算方法：
   #先將本期攤銷金額(axx07)轉換成來源公司的功能幣別金額，
   #再轉換成其族群代號的上層公司的記帳幣別金額
 
   LET l_rate  = 1
   LET l_axx08=p_axx07
 
   #抓單頭族群代號(axw03)的上層公司(axa02),上層帳別(axz05)
   SELECT axa02 INTO l_axa02 FROM axa_file WHERE axa01=p_axw.axw03
   SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01=l_axa02
 
   #抓來源公司的功能幣別(axz07)，上層公司的記帳幣別(axz06)
   SELECT axz07 INTO l_axz07 FROM axz_file WHERE axz01=p_axw.axw07
   SELECT axz06 INTO l_axz06 FROM axz_file WHERE axz01=l_axa02
 
   #抓上層公司的記帳幣別的金額取位小數位數(azi04)
   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_axz06
 
   #抓來源公司的來源科目(axv11)
   SELECT axv10 INTO l_axv10 FROM axv_file 
    WHERE axv01=p_axw.axw01 AND axv02=p_axw.axw02 
      AND axv03=p_axw.axw03 AND axv04=p_axw.axw04 
      AND axv11=p_axw.axw11  #FUN-930074 
 
   #抓來源公司的來源科目的再衡量匯率類別(axe11),
   #抓上層公司的來源科目的換算匯率類別(axe12)
   SELECT axe11 INTO l_axe11 FROM axe_file
    WHERE axe00=l_axz05 AND axe01=p_axw.axw07 AND axe06=l_axv10  #FUN-910001 mod axe04->axe06
      AND axe13=p_axw.axw03   #FUN-910001 add
   SELECT axe11 INTO l_axe12 FROM axe_file
    WHERE axe00=l_axz05 AND axe01=l_axa02 AND axe06=l_axv10  #FUN-910001 mod axe04->axe06
      AND axe13=p_axw.axw03   #FUN-910001 add
      
   #當來源幣別(axw11)與來源公司功能幣別(axz07)不同時才需要抓匯率來計算
   IF p_axw.axw11 != l_axz07 THEN
      #功能幣別匯率
      CALL i013_getrate(l_axe11,p_axw.axw01,p_axw.axw02,p_axw.axw11,l_axz07,
                        p_axw.axw07,l_axv10) RETURNING l_rate
      LET l_axx08=l_axx08*l_rate
   END IF
 
   LET l_rate  = 1
   #當來源公司功能幣別(axz07)與上層公司記帳幣別(axz06)不同時才需要抓匯率來計算
   IF l_axz07 != l_axz06 THEN
      #記帳幣別匯率
      CALL i013_getrate(l_axe12,p_axw.axw01,p_axw.axw02,l_axz07,l_axz06,
                        p_axw.axw07,l_axv10) RETURNING l_rate
      LET l_axx08=l_axx08*l_rate
   END IF
 
   CALL cl_digcut(l_axx08,l_azi04) RETURNING l_axx08   #金額取位
   RETURN l_axx08  
END FUNCTION
 
FUNCTION i013_getrate(p_value,p_axp01,p_axp02,p_axp03,p_axp04,p_axp08,p_axp09)
DEFINE p_value LIKE axe_file.axe11,
       p_axp01 LIKE axp_file.axp01,
       p_axp02 LIKE axp_file.axp02,
       p_axp03 LIKE axp_file.axp03,
       p_axp04 LIKE axp_file.axp04,
       p_axp08 LIKE axp_file.axp08,
       p_axp09 LIKE axp_file.axp09,
       l_rate  LIKE axp_file.axp05
 
   CASE 
      WHEN p_value='1'   #1.現時匯率
         SELECT axp05 INTO l_rate FROM axp_file
          WHERE axp01=p_axp01
            AND axp02=(SELECT max(axp02) FROM axp_file
                        WHERE axp01 =  p_axp01
                          AND axp02 <= p_axp02
                          AND axp03 =  p_axp03
                          AND axp04 =  p_axp04)
            AND axp03=p_axp03 
            AND axp04=p_axp04
      WHEN p_value='2'   #2.歷史匯率
         SELECT axp06 INTO l_rate FROM axp_file
          WHERE axp01=p_axp01
            AND axp02=(SELECT max(axp02) FROM axp_file
                        WHERE axp01 =  p_axp01
                          AND axp02 <= p_axp02
                          AND axp03 =  p_axp03
                          AND axp04 =  p_axp04)
            AND axp02=p_axp02
            AND axp03=p_axp03 
            AND axp04=p_axp04
      WHEN p_value='3'   #3.平均匯率
         SELECT axp07 INTO l_rate FROM axp_file
          WHERE axp01=p_axp01
            AND axp02=(SELECT max(axp02) FROM axp_file
                        WHERE axp01 =  p_axp01
                          AND axp02 <= p_axp02
                          AND axp03 =  p_axp03
                          AND axp04 =  p_axp04)
            AND axp03=p_axp03
            AND axp04=p_axp04
      OTHERWISE
         LET l_rate=1
   END CASE
   IF l_rate = 0 OR cl_null(l_rate) THEN LET l_rate = 1 END IF
 
   RETURN l_rate
END FUNCTION
 
FUNCTION i013_s()
DEFINE l_wc   STRING
   #FUN-770086.....................begin
   IF g_axw01 IS NULL OR g_axw02 IS NULL OR g_axw03 IS NULL OR g_axw031 IS NULL THEN
      CALL cl_err('',-400,0) RETURN 
   END IF
   #FUN-770086.....................end
   OPEN WINDOW i013_s_w AT p_row,p_col WITH FORM "agl/42f/agli013_s"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("agli013_s")
 
   DISPLAY g_axw01,g_axw02,g_axw03,g_axw031 TO axx01,axx02,axx03,axx031   #單頭  #FUN-770086   
   CALL i012_set_axz02(g_axw031) #FUN-770086
   CALL i013_b_fill_s()                                   #單身
 
   WHILE TRUE
      CALL i013_bp_s("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i013_b_s()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               LET g_wc3 = " axx01= ",g_axw01 CLIPPED,"  AND ",
                           " axx02= ",g_axw02 CLIPPED,"  AND ",
                           " axx03='",g_axw03 CLIPPED,"' AND ",
                           " axx031='",g_axw031 CLIPPED,"' AND ", #FUN-770086
                           " axx04= ",g_axw[l_ac].axw04 CLIPPED
               CALL i013_out_s('','')        #TQC-760167 add 
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_axx01 IS NOT NULL THEN
                  LET g_doc.column1 = "axx01"
                  LET g_doc.column2 = "axx02"
                  LET g_doc.column3 = "axx03"
                  LET g_doc.value1 = g_axw01
                  LET g_doc.value2 = g_axw02
                  LET g_doc.value3 = g_axw03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axx),'','')
            END IF
      END CASE
   END WHILE
 
   CLOSE WINDOW i013_s_w
END FUNCTION
 
FUNCTION i013_b_s()
DEFINE l_lock_sw       LIKE type_file.chr1      #單身鎖住否
 
   LET g_action_choice = ""
 
   LET g_forupd_sql = "SELECT axx04,axx05,axx06,axx07,axx08 ",
                      "  FROM axx_file ",
                      "  WHERE axx01 = ? AND axx02 = ? ",
                      "   AND axx03 = ? AND axx031= ? AND axx04 = ? ", #FUN-770086
                      "   AND axx05 = ? AND axx06 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl_s CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_axx WITHOUT DEFAULTS FROM s_axx.*
         ATTRIBUTE(COUNT=g_rec_b_s,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=True,APPEND ROW=FALSE)
      BEFORE INPUT
         IF g_rec_b_s!=0 THEN
            CALL fgl_set_arr_curr(l_ac_s)
         END IF
 
      BEFORE ROW
         LET l_ac_s = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
 
         IF g_rec_b_s >= l_ac_s THEN
            BEGIN WORK
            LET g_axx_t.* = g_axx[l_ac_s].*  #BACKUP   #FUN-780068 add
            OPEN i013_bcl_s USING g_axw01,g_axw02,g_axw03,g_axw031,
                                  g_axw[l_ac].axw04, #FUN-770086
                                  g_axx[l_ac_s].axx05,g_axx[l_ac_s].axx06
            IF STATUS THEN
               CALL cl_err("OPEN i013_bcl_s:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i013_bcl_s INTO g_axx[l_ac_s].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_axw_t.axw04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_axx_t.axx04 > 0 AND g_axx_t.axx04 IS NOT NULL THEN   #FUN-780068 mod
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM axx_file
             WHERE axx01 = g_axw01 AND axx02 = g_axw02 
               AND axx03 = g_axw03 AND axx031 = g_axw031 #FUN-770086
               AND axx04 = g_axx_t.axx04   #FUN-780068 mod
               AND axx05 = g_axx_t.axx05   #FUN-780068 mod
               AND axx06 = g_axx_t.axx06   #FUN-780068 mod
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axx_file",g_axw01,g_axx_t.axx04,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            ELSE
               UPDATE axw_file SET axw18=axw18-1,
                                   axw19=axw19-g_axx[l_ac_s].axx07
                WHERE axw01=g_axw01 AND axw02=g_axw02
                  AND axw03=g_axw03 AND axw031=g_axw031 
                  AND axw04=g_axx_t.axx04  #FUN-770086   #FUN-780068 mod
               IF SQLCA.sqlcode THEN 
                  CALL cl_err3("upd","axw_file",g_axw01,g_axx_t.axx04,SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  LET g_rec_b_s = g_rec_b_s-1
                  DISPLAY g_rec_b_s TO FORMONLY.cn2
                  COMMIT WORK
               END IF
            END IF
         END IF
         COMMIT WORK
 
      AFTER ROW
         LET l_ac_s = ARR_CURR()
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CLOSE i013_bcl_s
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i013_bcl_s
         COMMIT WORK
         CALL g_axx.deleteElement(g_rec_b_s+1)
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about        
         CALL cl_about()   
 
      ON ACTION help      
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION
 
FUNCTION i013_b_fill_s()
 
   LET g_sql = "SELECT axx04,axx05,axx06,axx07,axx08 ",
               "  FROM axx_file ",
               " WHERE axx01 =  ",g_axw01 CLIPPED,
               "   AND axx02 =  ",g_axw02 CLIPPED,
               "   AND axx03 = '",g_axw03 CLIPPED,"'",
               "   AND axx031= '",g_axw031 CLIPPED,"'", #FUN-770086
               "   AND axx04 =  ",g_axw[l_ac].axw04 CLIPPED,
               " ORDER BY axx04,axx05,axx06"
   PREPARE i013_prepare3 FROM g_sql      #預備一下
   DECLARE axx_cs CURSOR FOR i013_prepare3
 
   CALL g_axx.clear()
 
   LET g_cnt = 1
   LET g_rec_b_s = 0
 
   FOREACH axx_cs INTO g_axx[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_axx.deleteElement(g_cnt)
   LET g_rec_b_s=g_cnt -1
 
   DISPLAY g_rec_b_s TO FORMONLY.cn2  
   DISPLAY 1 TO FORMONLY.cnt  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i013_bp_s(p_ud)
   DEFINE p_ud     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_axx TO s_axx.* ATTRIBUTE(COUNT=g_rec_b_s,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac_s = ARR_CURR()
         CALL cl_show_fld_cont()  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac_s = 1
         EXIT DISPLAY
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()        
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac_s = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about    
         CALL cl_about() 
   
#@    ON ACTION 相關文件  
      ON ACTION related_document 
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i013_c(p_axw20)   #結案
DEFINE p_axw20    LIKE axw_file.axw20
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_axw01) OR cl_null(g_axw02) OR 
      cl_null(g_axw03) OR cl_null(g_axw031) THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN
   END IF
 
   LET g_forupd_sql = "SELECT axw04,axw05,axw06,axw07,'',axw08,'', ",
                      "       axw11,axw16,axw17,axw18,axw19,axw20 ",
                      "  FROM axw_file ",
                      "  WHERE axw01 = ? AND axw02 = ? ",
                      "   AND axw03 = ? AND axw031= ? AND axw04 = ? FOR UPDATE" #FUN-770086
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl_c CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   IF p_axw20 != "Y" THEN
      IF NOT cl_confirm('lib-003') THEN RETURN END IF   #此筆資料是否確定結案?
      LET p_axw20 = "Y"
   ELSE
      IF NOT cl_confirm('lib-004') THEN RETURN END IF   #此筆資料是否取消結案?
      LET p_axw20 = "N"
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i013_bcl_c USING g_axw01,g_axw02,g_axw03,g_axw031,g_axw[l_ac].axw04 #FUN-770086
   IF STATUS THEN
      CALL cl_err("OPEN i013_bcl_c:", STATUS, 1)
      CLOSE i013_bcl_c
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i013_bcl_c INTO g_axw[l_ac].*    # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_axw[l_ac].axw04,SQLCA.sqlcode,0)
      CLOSE i013_bcl_c
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE axw_file SET axw20=p_axw20
    WHERE axw01=g_axw01 AND axw02=g_axw02 
      AND axw03=g_axw03 AND axw031=g_axw031  #FUN-770086
      AND axw04=g_axw[l_ac].axw04
   LET g_axw[l_ac].axw20 = p_axw20
   DISPLAY BY NAME g_axw[l_ac].axw20
 
END FUNCTION
 
FUNCTION i013_out()
   DEFINE l_wc STRING
 
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli013'
 
   #組合出 SQL 指令
   LET g_sql="SELECT DISTINCT A.axw01,A.axw02,A.axw03,A.axw031,", #FUN-770086
             "       E.axz02 axw031_d,A.axw04,A.axw05,A.axw06,", #FUN-770086
             "       A.axw07,B.axz02 axz02_s,A.axw08,C.axz02 axz02_t,",
             "       A.axw11,A.axw16,A.axw17,A.axw18,A.axw19,A.axw20,D.azi04 ",
             "  FROM axw_file A,axz_file B,axz_file C,azi_file D,axz_file E ", #FUN-770086
             " WHERE A.axw07 = B.axz01",
             "   AND A.axw08 = C.axz01",
             "   AND A.axw11 = D.azi01",
             "   AND A.axw031= E.axz01", #FUN-770086
             "   AND ",g_wc CLIPPED,
             " ORDER BY A.axw01,A.axw02,A.axw03,A.axw04"
   PREPARE i013_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i013_co  CURSOR FOR i013_p1
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'axw01,axw02,axw03,axw031,axw04,axw05,axw06,axw07,axw08,axw11,axw16,axw17,axw18,axw19,axw20') #FUN-770086
           RETURNING l_wc
   ELSE
      LET l_wc = ''
   END IF
 
   CALL cl_prt_cs1('agli013','agli013',g_sql,l_wc)
 
END FUNCTION
 
#str TQC-760167 add
FUNCTION i013_tm_s()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #TQC-760167 add
DEFINE tm          RECORD
                    yy     LIKE axw_file.axw01,
                    mm     LIKE axw_file.axw02
                   END RECORD
 
   OPEN WINDOW i013_out_w AT p_row,p_col WITH FORM "agl/42f/agli013_out"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("agli013_out")
 
   #str TQC-760167 mod
   CONSTRUCT BY NAME g_wc3 ON axw01,axw02,axw03,axw031,axw04,axw05,axw06,
                              axw07,axw08 #FUN-770086
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axw03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axw03
               NEXT FIELD axw03
            #FUN-770086...................begin
            WHEN INFIELD(axw031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axz"
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axw031
                 NEXT FIELD axw031
            #FUN-770086...................end
            WHEN INFIELD(g)   #來源公司
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axb5"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axw07
               NEXT FIELD axw07
            WHEN INFIELD(h)   #交易公司
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axb5"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO axw08
               NEXT FIELD axw08
            OTHERWISE EXIT CASE
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
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i013_out_w
      RETURN
   END IF
 
   INPUT BY NAME tm.yy,tm.mm WITHOUT DEFAULTS
      BEFORE INPUT
         CALL cl_qbe_display_condition(lc_qbe_sn)   #FUN-580031 add
         INITIALIZE tm.* TO NULL
         LET tm.yy = YEAR(g_today)    #現行年度
         LET tm.mm = MONTH(g_today)   #現行期別
         DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
 
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            CALL cl_err('','mfg5103',0)
            NEXT FIELD yy
         END IF
         IF tm.yy < 0 THEN NEXT FIELD yy END IF
 
      AFTER FIELD mm
         IF cl_null(tm.mm) THEN
            CALL cl_err('','mfg5103',0)
            NEXT FIELD mm
         END IF
         IF tm.mm < 0 OR tm.mm > 12 THEN NEXT FIELD mm END IF
         
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      AFTER INPUT
         IF INT_FLAG THEN EXIT INPUT END IF
 
      #No.FUN-580031 --start--     HCN
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 --end--       HCN
   END INPUT
   #end TQC-760167 mod
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i013_out_w
      RETURN
   END IF
 
   CLOSE WINDOW i013_out_w
 
   CALL i013_out_s(tm.yy,tm.mm)
 
END FUNCTION
#end TQC-760167 add
 
FUNCTION i013_out_s(p_yy,p_mm)
   DEFINE p_yy     LIKE axw_file.axw01
   DEFINE p_mm     LIKE axw_file.axw02
   DEFINE l_wc3    STRING
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli013'
 
   #組合出 SQL 指令
   LET g_sql="SELECT DISTINCT A.axw01,A.axw02,A.axw03,A.axw031,", #FUN-770086
             "       F.axz02 axw031_d,A.axw04,A.axw05,A.axw06,",
             "       A.axw07,B.axz02 axz02_s,A.axw08,C.axz02 axz02_t,",
             "       A.axw11,A.axw16,A.axw17,A.axw18,A.axw19,A.axw20,D.azi04, ",
             "       E.axx05,E.axx06,E.axx07,E.axx08 ",          #TQC-760167 add
             "  FROM axw_file A,axz_file B,axz_file C,azi_file D,axx_file E,",
             "       axz_file F", #FUN-770086
             " WHERE A.axw07 = B.axz01",
             "   AND A.axw08 = C.axz01",
             "   AND A.axw11 = D.azi01",
             "   AND A.axw01 = E.axx01 AND A.axw02 = E.axx02",   #TQC-760167 add
             "   AND A.axw03 = E.axx03 AND A.axw04 = E.axx04",   #TQC-760167 add
             "   AND A.axw031= F.axz01",                         #FUN-770086
             "   AND ",g_wc3 CLIPPED                             #TQC-760167 add
   #str TQC-760167 add
   IF NOT cl_null(p_yy) THEN
      LET g_sql = g_sql,"   AND E.axx05 = ",p_yy CLIPPED
   END IF
   IF NOT cl_null(p_mm) THEN
      LET g_sql = g_sql,"   AND E.axx06 = ",p_mm CLIPPED
   END IF
   #end TQC-760167 add
   LET g_sql = g_sql," ORDER BY A.axw01,A.axw02,A.axw03,A.axw04"
   PREPARE i013_p2 FROM g_sql                # RUNTIME 編譯
   DECLARE i013_co1 CURSOR FOR i013_p2
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc3,'axw01,axw02,axw03,axw031,axw04,axw05,axw06,axw07,axw08') #FUN-770086
           RETURNING l_wc3
   ELSE
      LET l_wc3 = ''
   END IF
 
 ##CALL cl_prt_cs1('agli013','agli013_s',g_sql,l_wc3)  #FUN-7B0087
   CALL cl_prt_cs1('agli013','agli013_1',g_sql,l_wc3)
 
END FUNCTION
 
#FUN-770086.....................begin
FUNCTION i012_set_axz02(p_axz01)
   DEFINE p_axz01 LIKE axz_file.axz01
   DEFINE l_axz02 LIKE axz_file.axz02
   IF p_axz01 IS NULL THEN 
      DISPLAY NULL TO FORMONLY.axz02
      RETURN
   END IF
   SELECT axz02 INTO l_axz02 FROM axz_file
                            WHERE axz01=p_axz01
   DISPLAY l_axz02 TO FORMONLY.axz02
END FUNCTION
 
FUNCTION i013_chk_axw031()
   IF NOT cl_null(g_axw031) THEN
      LET g_cnt=0
      SELECT count(*) INTO g_cnt FROM axz_file WHERE axz01 = g_axw031
      IF g_cnt=0 THEN
         DISPLAY NULL TO FORMONLY.axz02
         CALL cl_err3("sel","axz_file",g_axw031,"",SQLCA.sqlcode,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-770086.....................end

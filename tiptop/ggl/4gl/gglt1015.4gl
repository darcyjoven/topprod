#x Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: gglt1015.4gl
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
# Modify.........: No.FUN-780068 07/10/09 By Sarah 單身刪除的WHERE條件句,asx04的部份應該用g_asx_t.asx04
# Modify.........: No.FUN-7B0087 07/11/15 By Nicole 修正 rpt樣版標準名稱
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/19 By hongmei由11區追單, 串ash_file時,增加串ash13(族群代號)=asx03  
# Modify.........: NO.FUN-930074 09/10/29 by yiting asw_pk add asw11
# Modify.........: No.FUN-920123 10/08/16 By vealxu 將使用asgacti的地方mark
# Modify.........: NO.MOD-A80155 10/09/13 BY yiting i013_asw傳遞參數移除asx11 
# Modify.........: NO.TQC-B40136 11/04/18 BY yinhy 去掉i013_asw函数asw11=p_asw11條件
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80135 11/08/22 By lujh 相關日期欄位不可小於關帳日期 
# Modify.........: No.FUN-B90088 11/09/14 By xuxz 增加三個字段：未实现损益科目，摊销科目，费用科目
#                                                  增加FUNCTION i013_csd(),i013_csd1(tm)
#                                                  調整單身的輸入順序
# Modify.........: 11/10/10 By xuxz 追单至此
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No.TQC-C90057 12/09/11 By Carrier asj09/asj11/asj12空时赋值
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: NO.TQC-D40119 13/07/17 By yangtt 在取合并帐套时，用的是aaz641，应改为大陆版的参数asz01

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-BB0036
 
#模組變數(Module Variables)
DEFINE 
    g_asx01          LIKE asx_file.asx01,      #FUN-750078
    g_asx02          LIKE asx_file.asx02,  
    g_asx03          LIKE asx_file.asx03,  
    g_asx031         LIKE asx_file.asx031,     #FUN-770086
    g_asx01_t        LIKE asx_file.asx01, 
    g_asx02_t        LIKE asx_file.asx02, 
    g_asx03_t        LIKE asx_file.asx03, 
    g_asx031_t       LIKE asx_file.asx031,     #FUN-770086
    g_asx            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        asx04        LIKE asx_file.asx04,      #項次
        asx05        LIKE asx_file.asx05,      #交易性質
        asx06        LIKE asx_file.asx06,      #交易類別
        asx07        LIKE asx_file.asx07,      #來源公司
        asg02_s      LIKE asg_file.asg02,      #公司名稱
        asx08        LIKE asx_file.asx08,      #交易公司
        asg02_t      LIKE asg_file.asg02,      #公司名稱
        asx11        LIKE asx_file.asx11,      #來源幣別
        #---No:FUN-B90088---add---str---
        asx09        LIKE asx_file.asx09,      #未實現損益科目
        aag02_a      LIKE aag_file.aag02,      #科目名稱
        asx10        LIKE asx_file.asx10,      #攤銷科目
        aag02_t      LIKE aag_file.aag02,      #科目名稱
        asx21        LIKE asx_file.asx21,      #費用科目
        aag02_s      LIKE aag_file.aag02,      #科目名稱
        #---No:FUN-B90088---add---end---
        asx16        LIKE asx_file.asx16,      #分配未實現損益
        asx17        LIKE asx_file.asx17,      #攤銷總期數
        asx18        LIKE asx_file.asx18,      #已攤銷期數
        asx19        LIKE asx_file.asx19,      #已攤銷金額
        asx20        LIKE asx_file.asx20       #結案否
                     END RECORD,
    g_asx_t          RECORD                 #程式變數 (舊值)
        asx04        LIKE asx_file.asx04,      #項次
        asx05        LIKE asx_file.asx05,      #交易性質
        asx06        LIKE asx_file.asx06,      #交易類別
        asx07        LIKE asx_file.asx07,      #來源公司
        asg02_s      LIKE asg_file.asg02,      #公司名稱
        asx08        LIKE asx_file.asx08,      #交易公司
        asg02_t      LIKE asg_file.asg02,      #公司名稱
        asx11        LIKE asx_file.asx11,      #來源幣別
        #---No:FUN-B90088---add---str---
        asx09        LIKE asx_file.asx09,      #未實現損益科目
        aag02_a      LIKE aag_file.aag02,      #科目名稱
        asx10        LIKE asx_file.asx10,      #攤銷科目
        aag02_t      LIKE aag_file.aag02,      #科目名稱
        asx21        LIKE asx_file.asx21,      #費用科目
        aag02_s      LIKE aag_file.aag02,      #科目名稱
        #---No:FUN-B90088---add---end--
        asx16        LIKE asx_file.asx16,      #分配未實現損益
        asx17        LIKE asx_file.asx17,      #攤銷總期數
        asx18        LIKE asx_file.asx18,      #已攤銷期數
        asx19        LIKE asx_file.asx19,      #已攤銷金額
        asx20        LIKE asx_file.asx20       #結案否
                     END RECORD,
    g_asy01          LIKE asy_file.asy01,  
    g_asy02          LIKE asy_file.asy02,  
    g_asy03          LIKE asy_file.asy03,  
    g_asy            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        asy04        LIKE asy_file.asy04,      #項次
        asy05        LIKE asy_file.asy05,      #攤銷年度
        asy06        LIKE asy_file.asy06,      #攤銷期別
        asy07        LIKE asy_file.asy07,      #本期攤銷金額
        asy08        LIKE asy_file.asy08,       #本期攤銷合併幣別金額
        asy09        LIKE asy_file.asy09  #No:FUN-B90088
                     END RECORD,
    g_asy_t          RECORD                    #程式變數 (舊值)   #FUN-780068 add
        asy04        LIKE asy_file.asy04,      #項次
        asy05        LIKE asy_file.asy05,      #攤銷年度
        asy06        LIKE asy_file.asy06,      #攤銷期別
        asy07        LIKE asy_file.asy07,      #本期攤銷金額
        asy08        LIKE asy_file.asy08,       #本期攤銷合併幣別金額
        asy09        LIKE asy_file.asy09  #No:FUN-B90088
                     END RECORD,
    i                LIKE type_file.num5,
    g_wc,g_wc1,g_wc2 STRING,             
    g_wc3            STRING,                   #TQC-760167 add
    g_sql            STRING,
    g_rec_b          LIKE type_file.num5,      #單身筆數
    l_ac             LIKE type_file.num5,      #目前處理的ARRAY CNT
    g_rec_b_s        LIKE type_file.num5,      #攤銷資料單身筆數
    l_ac_s           LIKE type_file.num5       #攤銷資料目前處理的ARRAY CNT
#--No:FUN-B90088--add---use to FUNCTION g()
DEFINE g_tm_g        RECORD 
                     asw01 LIKE asw_file.asw01,
                     asw02 LIKE asw_file.asw02,
                     asw03 LIKE asw_file.asw03,
                     asw031 LIKE asw_file.asw031,
                     asw04 LIKE asw_file.asw04
                     END RECORD
#--No:FUN-B90088--add--end--  
 
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
DEFINE   g_aaa07        LIKE aaa_file.aaa07          #No.FUN-B80135
DEFINE   g_year         LIKE type_file.chr4          #No.FUN-B80135
DEFINE   g_month        LIKE type_file.chr2          #No.FUN-B80135
DEFINE   g_asz01       LIKE asz_file.asz01           #TQC-D40119 add
 
MAIN
DEFINE p_row,p_col     LIKE type_file.num5
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0' 
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07) 
   #FUN-B80135--add--end

   #抓取账套
   SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'    #TQC-D40119 add
 
   LET i=0
   LET g_asx01_t = NULL
   LET g_asx02_t = NULL
   LET g_asx03_t = NULL
   LET g_asx031_t = NULL #FUN-770086
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW i013_w AT p_row,p_col WITH FORM "ggl/42f/gglt1015" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   
   CALL cl_ui_init()
 
   CALL i013_menu()
   CLOSE FORM i013_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i013_cs()
   CLEAR FORM                            #清除畫面
   CALL g_asx.clear()
 
   #螢幕上取條件
   INITIALIZE g_asx01 TO NULL      #No.FUN-750051
   INITIALIZE g_asx02 TO NULL      #No.FUN-750051
   INITIALIZE g_asx03 TO NULL      #No.FUN-750051
   INITIALIZE g_asx031 TO NULL      #FUN-770086
   CONSTRUCT g_wc ON asx01,asx02,asx03,asx031,asx04,asx05,asx06,asx07, #FUN-770086
                     asx08,asx11,
                     asx09,asx10,asx21,     #--No:FUN-B90088--add
                     asx16,asx17,asx18,asx19,asx20
                FROM asx01,asx02,asx03,asx031,s_asx[1].asx04,s_asx[1].asx05, #FUN-770086
                     s_asx[1].asx06,s_asx[1].asx07,s_asx[1].asx08,
                     s_asx[1].asx11,
                     s_asx[1].asx09,s_asx[1].asx10,s_asx[1].asx21,   #--NO:FUN-B90088---add--
                     s_asx[1].asx16,s_asx[1].asx17,
                     s_asx[1].asx18,s_asx[1].asx19,s_asx[1].asx20
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asx03)     #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx03 
                 NEXT FIELD asx03
            #FUN-770086...................beatk
            WHEN INFIELD(asx031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asg"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx031
                 NEXT FIELD asx031
            #FUN-770086...................end
            WHEN INFIELD(asx07)     #來源公司 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asb5"
                 CALL GET_FLDBUF(asx03) RETURNING g_asx03
                 LET g_qryparam.arg1 = g_asx03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx07 
                 NEXT FIELD asx07
            WHEN INFIELD(asx08)     #交易公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asb5"
                 CALL GET_FLDBUF(asx03) RETURNING g_asx03
                 LET g_qryparam.arg1 = g_asx03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO asx08 
                 NEXT FIELD asx08
            WHEN INFIELD(asx11)     #交易幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx11 
                 NEXT FIELD asx11
            #--No:FUN-B90088--add--str--
            WHEN INFIELD(asx09)     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx09
                 NEXT FIELD asx09
            WHEN INFIELD(asx10)     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx10
                 NEXT FIELD asx10
            WHEN INFIELD(asx21)     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag02"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx21
                 NEXT FIELD asx21
            #--No:FUN-B90088-add-end--
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
 
   LET g_sql= "SELECT UNIQUE asx01,asx02,asx03,asx031 FROM asx_file ", #FUN-770086
              " WHERE ", g_wc CLIPPED,
              " ORDER BY asx01,asx02,asx03,asx031"  #FUN-770086
   PREPARE i013_prepare FROM g_sql        #預備一下
   DECLARE i013_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i013_prepare
 
   LET g_sql_tmp = "SELECT UNIQUE asx01,asx02,asx03,asx031 ", #FUN-770086
                   "  FROM asx_file ",
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
               CALL i013_c(g_asx[l_ac].asx20)
               CALL i013_b_fill(g_wc)
            END IF 
         #--No:FUN-B90088--add--str
         WHEN "create_share_data"         #抵銷憑證产生
            IF cl_chk_act_auth() THEN
               CALL i013_csd()
            END IF 
         #--No:FUN-B90088--add--end
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_asx01 IS NOT NULL THEN
                  LET g_doc.column1 = "asx01"
                  LET g_doc.column2 = "asx02"
                  LET g_doc.column3 = "asx03"
                  LET g_doc.value1 = g_asx01
                  LET g_doc.value2 = g_asx02
                  LET g_doc.value3 = g_asx03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asx),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i013_a()
   IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_asx.clear()
   INITIALIZE g_asx01 LIKE asx_file.asx01         #DEFAULT 設定
   INITIALIZE g_asx02 LIKE asx_file.asx02         #DEFAULT 設定
   INITIALIZE g_asx03 LIKE asx_file.asx03         #DEFAULT 設定
   INITIALIZE g_asx031 LIKE asx_file.asx031         #DEFAULT 設定 #FUN-770086
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i013_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_asx01=NULL
         LET g_asx02=NULL
         LET g_asx03=NULL
         LET g_asx031=NULL #FUN-770086
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      # KEY 不可空白
      IF cl_null(g_asx01) OR cl_null(g_asx02) OR cl_null(g_asx03) OR 
         cl_null(g_asx031) THEN #FUN-770086
         CONTINUE WHILE
      END IF
 
      CALL g_asx.clear()
      LET g_rec_b = 0 
      CALL i013_b()                              #輸入單身
#     SELECT rowid INTO g_asx_rowid FROM asx_file              #09/10/19 xiaofeizhu Mark        
#      WHERE asx01 = g_asx01 AND asx02 = g_asx02               #09/10/19 xiaofeizhu Mark  
#        AND asx03 = g_asx03 AND asx031 = g_asx031 #FUN-770086 #09/10/19 xiaofeizhu Mark
      LET g_asx01_t = g_asx01                    #保留舊值
      LET g_asx02_t = g_asx02                    #保留舊值
      LET g_asx03_t = g_asx03                    #保留舊值
      LET g_asx031_t = g_asx031                    #保留舊值  #FUN-770086
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i013_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入
       l_n1,l_n        LIKE type_file.num5,    
       p_cmd           LIKE type_file.chr1     #a:輸入 u:更改
    
   DISPLAY g_asx01,g_asx02,g_asx03,g_asx031 TO asx01,asx02,asx03,asx031 #FUN-770086
 
   INPUT g_asx01,g_asx02,g_asx03,g_asx031 FROM asx01,asx02,asx03,asx031 #FUN-770086
      AFTER FIELD asx01   #年度
         IF cl_null(g_asx01) OR g_asx01 = 0 THEN
            CALL cl_err(g_asx01,'afa-370',0)
            NEXT FIELD asx01
         END IF
         IF g_asx01< 0 THEN NEXT FIELD asx01 END IF
         CALL s_get_bookno(g_asx01) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag = '1' THEN
            CALL cl_err(g_asx01,'aoo-081',1)
            NEXT FIELD asx01
         END IF
         #No.FUN-B80135--add--str--
         IF g_asx01<g_year THEN
            CALL cl_err(g_asx01,'atp-164',0)
            NEXT FIELD asx01
         ELSE
            IF g_asx01=g_year AND g_asx02<=g_month THEN
               CALL cl_err('','atp-164',0)
               NEXT FIELD asx02
            END IF 
         END IF 
         #No.FUN-B80135--add--end
 
      AFTER FIELD asx02   #期別
         IF cl_null(g_asx02) OR g_asx02 < 0 OR g_asx02 > 12 THEN
            CALL cl_err(g_asx02,'agl-013',0)
            NEXT FIELD asx02
         END IF
         #FUN-B80135--add--str--
         IF NOT cl_null(g_asx01) AND g_asx01=g_year 
         AND g_asx02<=g_month THEN
            CALL cl_err('','atp-164',0)
            NEXT FIELD asx02
         END IF 
         #FUN-B80135--add--end
 
      AFTER FIELD asx03   #族群代號
         IF NOT cl_null(g_asx03) THEN
            SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = g_asx03
            IF l_n = 0 THEN 
               CALL cl_err3("sel","asa_file",g_asx03,"","agl-117","","",1)
               NEXT FIELD asx03
            END IF
         END IF
 
      #FUN-770086.................beatk
      AFTER FIELD asx031   #上層公司
         IF NOT i013_chk_asx031() THEN
            NEXT FIELD CURRENT
         END IF
         CALL i012_set_asg02(g_asx031)
      #FUN-770086.................end
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asx03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = g_asx03
               CALL cl_create_qry() RETURNING g_asx03
               DISPLAY g_asx03 TO asx03 
               NEXT FIELD asx03
            #FUN-770086...................beatk
            WHEN INFIELD(asx031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg"
                 CALL cl_create_qry() RETURNING g_asx031
                 DISPLAY g_asx031 TO asx031
                 NEXT FIELD asx031
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
   INITIALIZE g_asx01 TO NULL
   INITIALIZE g_asx02 TO NULL
   INITIALIZE g_asx03 TO NULL
   INITIALIZE g_asx031 TO NULL  #FUN-770086
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asx.clear()
 
   CALL i013_cs()                           #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0             
      RETURN                       
   END IF                           
 
   OPEN i013_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_asx01 TO NULL
      INITIALIZE g_asx02 TO NULL
      INITIALIZE g_asx03 TO NULL
      INITIALIZE g_asx03 TO NULL  #FUN-770086
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
      WHEN 'N' FETCH NEXT     i013_bcs INTO g_asx01,g_asx02,g_asx03,g_asx031 #FUN-770086
      WHEN 'P' FETCH PREVIOUS i013_bcs INTO g_asx01,g_asx02,g_asx03,g_asx031 #FUN-770086
      WHEN 'F' FETCH FIRST    i013_bcs INTO g_asx01,g_asx02,g_asx03,g_asx031 #FUN-770086
      WHEN 'L' FETCH LAST     i013_bcs INTO g_asx01,g_asx02,g_asx03,g_asx031 #FUN-770086
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
          FETCH ABSOLUTE g_jump i013_bcs INTO g_asx01,g_asx02,g_asx03,g_asx031 #FUN-770086
          LET g_no_ask = FALSE
   END CASE
 
   SELECT UNIQUE asx01,asx02,asx03
     FROM asx_file 
    WHERE asx01 = g_asx01 AND asx02 = g_asx02 AND asx03 = g_asx03 
      AND asx031 = g_asx031 #FUN-770086
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err3("sel","asx_file",g_asx01,g_asx02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_asx01 TO NULL
      INITIALIZE g_asx02 TO NULL
      INITIALIZE g_asx03 TO NULL
      INITIALIZE g_asx031 TO NULL #FUN-770086
   ELSE
      CALL s_get_bookno(g_asx01) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(g_asx01,'aoo-081',1)
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
 
   DISPLAY g_asx01,g_asx02,g_asx03,g_asx031 TO asx01,asx02,asx03,asx031   #單頭  #FUN-770086
   CALL i012_set_asg02(g_asx031) #FUN-770086
   CALL i013_b_fill(g_wc)                                 #單身
   CALL cl_show_fld_cont() 
 
END FUNCTION
 
FUNCTION i013_b_fill(p_wc)
#DEFINE p_wc       LIKE type_file.chr1000
 DEFINE p_wc       STRING      #NO.FUN-910082
 
   LET g_sql = "SELECT asx04,asx05,asx06,asx07,'',asx08,'',",
               "       asx11, ",  
               "       asx09,'',asx10,'',asx21,'',asx16, ",  #No:FUN-B90088 add 
               "       asx17,asx18,asx19,asx20 ",
               "  FROM asx_file ",
               " WHERE asx01 =  ",g_asx01 CLIPPED,
               "   AND asx02 =  ",g_asx02 CLIPPED,
               "   AND asx03 = '",g_asx03 CLIPPED,"'",
               "   AND asx031 = '",g_asx031 CLIPPED,"'", #FUN-770086
               "   AND ",p_wc CLIPPED ,
               " ORDER BY asx04"
   PREPARE i013_prepare2 FROM g_sql      #預備一下
   DECLARE asx_cs CURSOR FOR i013_prepare2
 
   CALL g_asx.clear()
 
   LET g_cnt = 1
   LET g_rec_b = 0
 
   FOREACH asx_cs INTO g_asx[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT asg02 INTO g_asx[g_cnt].asg02_s FROM asg_file   #來源公司名稱
       WHERE asg01=g_asx[g_cnt].asx07
      SELECT asg02 INTO g_asx[g_cnt].asg02_t FROM asg_file   #交易公司名稱
       WHERE asg01=g_asx[g_cnt].asx08
      #TQC-D40119--mark--str--
     ##--No:FUN-B90088---add
     #SELECT aag02 INTO g_asx[g_cnt].aag02_a FROM aag_file,aaz_file
     # WHERE aag00=aaz641 and aag07 in('2','3') AND aag01 = g_asx[g_cnt].asx09
     #SELECT aag02 INTO g_asx[g_cnt].aag02_t FROM aag_file,aaz_file
     # WHERE aag00=aaz641 and aag07 in('2','3') AND aag01 = g_asx[g_cnt].asx10
     #SELECT aag02 INTO g_asx[g_cnt].aag02_s FROM aag_file,aaz_file
     # WHERE aag00=aaz641 and aag07 in('2','3') AND aag01 = g_asx[g_cnt].asx21
     # #---No:FUN-B90088---add---end
      #TQC-D40119--mark--end--
      #TQC-D40119--add--str--
      SELECT aag02 INTO g_asx[g_cnt].aag02_a FROM aag_file,asz_file
       WHERE aag00=asz01 and aag07 in('2','3') AND aag01 = g_asx[g_cnt].asx09
      SELECT aag02 INTO g_asx[g_cnt].aag02_t FROM aag_file,asz_file
       WHERE aag00=asz01 and aag07 in('2','3') AND aag01 = g_asx[g_cnt].asx10
      SELECT aag02 INTO g_asx[g_cnt].aag02_s FROM aag_file,asz_file
       WHERE aag00=asz01 and aag07 in('2','3') AND aag01 = g_asx[g_cnt].asx21
      #TQC-D40119--add--end--
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_asx.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
 
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i013_r()
   DEFINE    l_cnt       LIKE type_file.num5    #TQC-760167 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_asx01 IS NULL OR g_asx02 IS NULL OR g_asx03 IS NULL OR g_asx031 IS NULL THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN 
   END IF
   BEGIN WORK
   IF cl_delh(15,16) THEN
      #str TQC-760167 add
      #若已有攤銷資料則不可刪除
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM asy_file
       WHERE asy01 = g_asx01 AND asy02 = g_asx02 
         AND asy03 = g_asx03 AND asy031 = g_asx031
      IF l_cnt > 0 THEN  
         CALL cl_err("", "agl-951", 1) 
         RETURN           
      END IF
      #end TQC-760167 add
      DELETE FROM asx_file WHERE asx01=g_asx01 AND asx02=g_asx02 
         AND asx03=g_asx03 AND asx031=g_asx031 #FUN-770086
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
         CALL cl_err3("del","asx_file",g_asx01,g_asx03,SQLCA.sqlcode,"","",1)
      ELSE 
         CLEAR FORM
         CALL g_asx.clear()
         LET g_sql = "SELECT UNIQUE asx01,asx02,asx03,asx031 FROM asx_file ",
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
       l_asg05         LIKE asg_file.asg05,     #帳別
       l_cnt           LIKE type_file.num5      #TQC-760167 add     
 
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT asx04,asx05,asx06,asx07,'',asx08,'', ",
                      "       asx11, ",
                      "       asx09,'',asx10,'',asx21,'', ", #No:FUN-B90088--add
                      "       asx16,asx17,asx18,asx19,asx20 ",
                      "  FROM asx_file ",
                      "  WHERE asx01 = ? AND asx02 = ? ",
                      "   AND asx03 = ? AND asx031= ? AND asx04 = ? FOR UPDATE" #FUN-770086
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_asx WITHOUT DEFAULTS FROM s_asx.*
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
         CALL cl_set_comp_entry("asx05,asx06,asx07,asx08,asx11,asx16",true) #No:FUN-B90088 add  
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_asx_t.* = g_asx[l_ac].*  #BACKUP
            OPEN i013_bcl USING g_asx01,g_asx02,g_asx03,g_asx031,
                                g_asx[l_ac].asx04 #FUN-770086
            IF STATUS THEN
               CALL cl_err("OPEN i013_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i013_bcl INTO g_asx[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_asx_t.asx04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i013_asg(p_cmd,g_asx[l_ac].asx07,"s")   #來源公司名稱
               CALL i013_asg(p_cmd,g_asx[l_ac].asx08,"t")   #交易公司名稱
               #---xxz--add
               CALL i013_ashh(p_cmd,g_asx[l_ac].asx07,g_asx[l_ac].asx09,"a")   
               CALL i013_ashh(p_cmd,g_asx[l_ac].asx07,g_asx[l_ac].asx10,"t")   
               CALL i013_ashh(p_cmd,g_asx[l_ac].asx07,g_asx[l_ac].asx21,"s") 
               #---xxz--add--end--
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_asx[l_ac].* TO NULL   
         LET g_asx_t.* = g_asx[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()   
         NEXT FIELD asx04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_asx[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_asx[l_ac].* TO s_asx.*
            CALL g_asx.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO asx_file(asx01,asx02,asx03,asx031,asx04,asx05,asx06,asx07, #FUN-770086
                              asx08,asx09,asx10,asx11,asx21,asx16,asx17,asx18,asx19,asx20,asxlegal) #FUN-980003 add #FUN-B90088 add asx09,asx10,asx21
                       VALUES(g_asx01,g_asx02,g_asx03,g_asx031,
                              g_asx[l_ac].asx04, #FUN-770086
                              g_asx[l_ac].asx05,g_asx[l_ac].asx06,
                              g_asx[l_ac].asx07,g_asx[l_ac].asx08,
                              g_asx[l_ac].asx09,g_asx[l_ac].asx10, #FUN-B90088 add asx09,asx10
                              g_asx[l_ac].asx11,g_asx[l_ac].asx21, #FUN-B90088 add asx21
                              g_asx[l_ac].asx16,
                              g_asx[l_ac].asx17,g_asx[l_ac].asx18,
                              g_asx[l_ac].asx19,g_asx[l_ac].asx20,g_legal)  #FUN-980003 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","asx_file",g_asx01,g_asx02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE 'INSERT O.K'
         END IF
 
      BEFORE FIELD asx04                        #default 項次
         IF g_asx[l_ac].asx04 IS NULL OR g_asx[l_ac].asx04 = 0 THEN
            SELECT max(asx04)+1 INTO g_asx[l_ac].asx04
              FROM asx_file
             WHERE asx01 = g_asx01 AND asx02 = g_asx02 AND asx03 = g_asx03
               AND asx031 = g_asx031 #FUN-770086
            IF g_asx[l_ac].asx04 IS NULL THEN
               LET g_asx[l_ac].asx04 = 1
            END IF
         END IF
 
      AFTER FIELD asx04
         IF NOT cl_null(g_asx[l_ac].asx04) THEN
            IF g_asx[l_ac].asx04 != g_asx_t.asx04 OR g_asx_t.asx04 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM asx_file
                WHERE asx01 = g_asx01 AND asx02 = g_asx02 
                  AND asx03 = g_asx03 AND asx031= g_asx031 #FUN-770086
                  AND asx04 = g_asx[l_ac].asx04
               IF l_n > 0 THEN
                  CALL cl_err(g_asx[l_ac].asx04,-239,0)
                  LET g_asx[l_ac].asx04 = g_asx_t.asx04
                  #NEXT FIELD asx04  #FUN-B90088
                  
               END IF
            END IF
            CALL i013_asw(p_cmd,g_asx01,g_asx02,g_asx03,g_asx031,
                          g_asx[l_ac].asx04) #FUN-770086  #MOD-A80155 取消mark
                          #g_asx[l_ac].asx04,g_asx[l_ac].asx11) #FUN-770086 #FUN-930074 mod
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asx[l_ac].asx04,g_errno,0)
               LET g_asx[l_ac].asx04 = g_asx_t.asx04
               DISPLAY BY NAME g_asx[l_ac].asx04
               NEXT FIELD asx04
            END IF
         END IF
 
      #---No:FUN-B90088--add--str--
      AFTER FIELD asx07
      IF NOT cl_null(g_asx[l_ac].asx07) THEN
         CALL i013_asg(p_cmd,g_asx[l_ac].asx07,"s")   #來源公司名稱
      ELSE
         NEXT FIELD asx07
      END IF
      AFTER FIELD asx08
      IF NOT cl_null(g_asx[l_ac].asx08) THEN   
         CALL i013_asg(p_cmd,g_asx[l_ac].asx08,"t")   #交易公司名稱
      ELSE
         NEXT FIELD asx08
      END IF
      AFTER FIELD asx09
         IF NOT cl_null(g_asx[l_ac].asx09) THEN 
            CALL i013_ashh(p_cmd,g_asx[l_ac].asx07,g_asx[l_ac].asx09,"a")   #帳列科目名稱
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asx[l_ac].asx09,g_errno,0)
               LET g_asx[l_ac].asx09 = g_asx_t.asx09
               DISPLAY BY NAME g_asx[l_ac].asx09
               NEXT FIELD asx09
            END IF
         ELSE
            CALL cl_err(g_asx[l_ac].asx09,"mfg5103",0)
            NEXT FIELD asx09
         END IF
         
         AFTER FIELD asx10
         IF NOT cl_null(g_asx[l_ac].asx10) THEN 
            CALL i013_ashh(p_cmd,g_asx[l_ac].asx07,g_asx[l_ac].asx10,"t")   #帳列科目名稱
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asx[l_ac].asx10,g_errno,0)
               LET g_asx[l_ac].asx10 = g_asx_t.asx10
               DISPLAY BY NAME g_asx[l_ac].asx10
               NEXT FIELD asx10
            END IF
         ELSE
            CALL cl_err(g_asx[l_ac].asx10,"mfg5103",0)
            NEXT FIELD asx10
         END IF
         
         AFTER FIELD asx21
         IF NOT cl_null(g_asx[l_ac].asx21) THEN 
            CALL i013_ashh(p_cmd,g_asx[l_ac].asx07,g_asx[l_ac].asx21,"s")   #帳列科目名稱
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asx[l_ac].asx21,g_errno,0)
               LET g_asx[l_ac].asx21 = g_asx_t.asx21
               DISPLAY BY NAME g_asx[l_ac].asx21
               NEXT FIELD asx21
            END IF
         ELSE
            CALL cl_err(g_asx[l_ac].asx21,"mfg5103",0)
            NEXT FIELD asx21
         END IF
      #--No:FUN-B90088-add-end--
      BEFORE DELETE                            #是否取消單身
         IF g_asx_t.asx04 > 0 AND g_asx_t.asx04 IS NOT NULL THEN
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
            SELECT COUNT(*) INTO l_cnt FROM asy_file
             WHERE asy01 = g_asx01 AND asy02 = g_asx02 AND asy03 = g_asx03
               AND asy04 = g_asx[l_ac].asx04
            IF l_cnt > 0 THEN  
               CALL cl_err("", "agl-951", 1) 
               CANCEL DELETE 
            END IF
            #end TQC-760167 add
 
            DELETE FROM asx_file
             WHERE asx01 = g_asx01 AND asx02 = g_asx02 AND asx03 = g_asx03
               AND asx031= g_asx031        #FUN-770086
               AND asx04 = g_asx_t.asx04   #FUN-780068 mod
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","asx_file",g_asx01,g_asx_t.asx04,SQLCA.sqlcode,"","",1)
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
            LET g_asx[l_ac].* = g_asx_t.*
            CLOSE i013_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_asx[l_ac].asx04,-263,1)
            LET g_asx[l_ac].* = g_asx_t.*
         ELSE
            UPDATE asx_file SET asx04 = g_asx[l_ac].asx04,
                                asx09 = g_asx[l_ac].asx09,
                                asx10 = g_asx[l_ac].asx10,
                                asx21 = g_asx[l_ac].asx21,
                                asx17 = g_asx[l_ac].asx17, 
                                asx18 = g_asx[l_ac].asx18, 
                                asx19 = g_asx[l_ac].asx19, 
                                asx20 = g_asx[l_ac].asx20 
             WHERE asx01 = g_asx01 AND asx02 = g_asx02 AND asx03 = g_asx03
               AND asx031 = g_asx031 #FUN-770086
               AND asx04 = g_asx_t.asx04
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","asx_file",g_asx01,g_asx_t.asx04,SQLCA.sqlcode,"","",1)
               LET g_asx[l_ac].* = g_asx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac                 #FUN-D30032 Mark 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
           #LET g_asx[l_ac].* = g_asx_t.*  #FUN-D30032 Mark
            #FUN-D30032--add--str--
            IF p_cmd = 'u' THEN
               LET g_asx[l_ac].* = g_asx_t.*
            ELSE
               CALL g_asx.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            #FUN-D30032--add--end--
            CLOSE i013_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac                 #FUN-D30032 Add
         LET g_asx_t.* = g_asx[l_ac].*
         CLOSE i013_bcl
         COMMIT WORK
         CALL g_asx.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asx04)     #項次
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asw"
                 LET g_qryparam.default1 = g_asx[l_ac].asx04
                 LET g_qryparam.arg1 = g_asx01
                 LET g_qryparam.arg2 = g_asx02
                 LET g_qryparam.arg3 = g_asx03
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx04
                 DISPLAY BY NAME g_asx[l_ac].asx04 
                 NEXT FIELD asx04
            #--NO:FUN-B90088-add--str--
            WHEN INFIELD(asx07)     #來源公司 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_asb5"
                 LET g_qryparam.arg1 = g_asx03
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx07
                 DISPLAY g_asx[l_ac].asx07 TO asx07 
                 NEXT FIELD asx07
            WHEN INFIELD(asx08)     #交易公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_asb5"
                 LET g_qryparam.arg1 = g_asx03
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx08
                 DISPLAY   g_asx[l_ac].asx08 TO asx08 
                 NEXT FIELD asx08
            WHEN INFIELD(asx11)     #交易幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx11
                 DISPLAY g_asx[l_ac].asx11 TO asx11 
                 NEXT FIELD asx11
            WHEN INFIELD(asx09)     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_aag02"
                #LET g_qryparam.arg1 = g_aaz.aaz641    #TQC-D40119 mark
                 LET g_qryparam.arg1 = g_asz01         #TQC-D40119 add
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx09
                 DISPLAY g_asx[l_ac].asx09 TO asx09
                 NEXT FIELD asx09
            WHEN INFIELD(asx10)     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_aag02"
                #LET g_qryparam.arg1 = g_aaz.aaz641    #TQC-D40119 mark
                 LET g_qryparam.arg1 = g_asz01         #TQC-D40119 add
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx10
                 DISPLAY g_asx[l_ac].asx10 TO asx10
                 NEXT FIELD asx10
            WHEN INFIELD(asx21)     
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "i"
                 LET g_qryparam.form ="q_aag02"
                #LET g_qryparam.arg1 = g_aaz.aaz641    #TQC-D40119 mark
                 LET g_qryparam.arg1 = g_asz01         #TQC-D40119 add
                 CALL cl_create_qry() RETURNING g_asx[l_ac].asx21
                 DISPLAY g_asx[l_ac].asx21 TO asx21
                 NEXT FIELD asx21
            #--No:FUN-B90088-add-end--
            OTHERWISE 
                 EXIT CASE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(asx04) AND l_ac > 1 THEN
            LET g_asx[l_ac].* = g_asx[l_ac-1].*
            LET g_asx[l_ac].asx04 = g_asx[l_ac-1].asx04 + 1 
            NEXT FIELD asx04
         END IF
 
      ON ACTION CONTROLZ
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
 
#----NO:FUN-B90088---add---
FUNCTION i013_ashh(p_cmd,p_ashh01,p_ashh06,p_at)   
   DEFINE p_cmd       LIKE type_file.chr1,

          p_ashh01    LIKE ashh_file.ashh01,      #FUN-920095 
          p_ashh06    LIKE ashh_file.ashh06,      #FUn-920095 
          p_at        LIKE type_file.chr1,
          l_aag02     LIKE aag_file.aag02,
          l_aagacti   LIKE aag_file.aagacti

    LET g_sql = "SELECT aag02,aagacti ",
               #"  FROM aag_file,aaz_file ",       #TQC-D40119 mark
               #" WHERE aag00 = aaz641 ",          #TQC-D40119 mark
                "  FROM aag_file,asz_file ",       #TQC-D40119 add
                " WHERE aag00 = asz01 ",           #TQC-D40119 add
                "   AND aag07 in('2','3') ",
                "   AND aag01 = '",p_ashh06,"'"

    PREPARE i013_pre_1 FROM g_sql
    DECLARE i013_cur_1 CURSOR FOR i013_pre_1
    OPEN i013_cur_1
    FETCH i013_cur_1 INTO l_aag02,l_aagacti 
                                                                     
    IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF

   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-916'
                               LET l_aag02 = NULL
      WHEN l_aagacti = 'N'     LET g_errno = '9028'
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_at = "a" THEN   #未實現損益科目
         LET g_asx[l_ac].aag02_a = l_aag02
         DISPLAY BY NAME g_asx[l_ac].aag02_a
      END IF 
      IF p_at = 't' THEN             #攤銷科目
         LET g_asx[l_ac].aag02_t = l_aag02
         DISPLAY BY NAME g_asx[l_ac].aag02_t
      END IF  

      IF p_at = 's' THEN   #費用科目
         LET g_asx[l_ac].aag02_s = l_aag02
         DISPLAY BY NAME g_asx[l_ac].aag02_s
      END IF
   END IF

END FUNCTION
#---NO:FUN-B90088---add---end---

#FUNCTION i013_asw(p_cmd,p_asw01,p_asw02,p_asw03,p_asw031,p_asw04,p_asw11)  #FUN-930074  #MOD-A80155 mark
FUNCTION i013_asw(p_cmd,p_asw01,p_asw02,p_asw03,p_asw031,p_asw04)   #MOD-A80155 取消mark
   DEFINE p_cmd       LIKE type_file.chr1,
          p_asw01     LIKE asw_file.asw01,
          p_asw02     LIKE asw_file.asw02,
          p_asw03     LIKE asw_file.asw03,
          p_asw031    LIKE asw_file.asw031, #FUN-770086
          p_asw04     LIKE asw_file.asw04,
          p_asw11     LIKE asw_file.asw11,  #FUN-930074
          l_asw       RECORD LIKE asw_file.*
 
   SELECT * INTO l_asw.* FROM asw_file 
    WHERE asw01=p_asw01 AND asw02=p_asw02 
      AND asw03=p_asw03 AND asw031=p_asw031 AND asw04=p_asw04 #FUN-770086
      #AND asw11=p_asw11  #FUN-930074   #No.TQC-B40136 mark
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'axm-141'
                               INITIALIZE l_asw.* TO NULL
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_asx[l_ac].asx04 = l_asw.asw04
      LET g_asx[l_ac].asx05 = l_asw.asw05
      LET g_asx[l_ac].asx06 = l_asw.asw06
      LET g_asx[l_ac].asx07 = l_asw.asw07
      LET g_asx[l_ac].asx08 = l_asw.asw08
      LET g_asx[l_ac].asx11 = l_asw.asw11
      LET g_asx[l_ac].asx16 = l_asw.asw16
      #來源公司名稱
      SELECT asg02 INTO g_asx[l_ac].asg02_s
        FROM asg_file WHERE asg01=l_asw.asw07
      #交易公司名稱
      SELECT asg02 INTO g_asx[l_ac].asg02_t
        FROM asg_file WHERE asg01=l_asw.asw08
      DISPLAY BY NAME g_asx[l_ac].asx04,g_asx[l_ac].asx05,g_asx[l_ac].asx06,
                      g_asx[l_ac].asx07,g_asx[l_ac].asx08,g_asx[l_ac].asx11,
                      g_asx[l_ac].asx16,g_asx[l_ac].asg02_s,g_asx[l_ac].asg02_t
   END IF
 
END FUNCTION
 
FUNCTION i013_asg(p_cmd,p_asg01,p_st)
   DEFINE p_cmd       LIKE type_file.chr1,
          p_asg01     LIKE asg_file.asg01,
          p_st        LIKE type_file.chr1,
          l_asg02     LIKE asg_file.asg02,
          l_asgacti   LIKE asg_file.asgacti
 
  #SELECT asg02,asgacti INTO l_asg02,l_asgacti               #FUN-920123 mark
   SELECT asg02 INTO l_asg02                                 #FUN-920123
     FROM asg_file WHERE asg01=p_asg01
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'aco-025'
                               LET l_asg02 = NULL
     #WHEN l_asgacti = 'N'     LET g_errno = '9028'          #FUN-920123
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_st = "s" THEN   #來源公司
         LET g_asx[l_ac].asg02_s = l_asg02
         DISPLAY BY NAME g_asx[l_ac].asg02_s
      ELSE                 #交易公司
         LET g_asx[l_ac].asg02_t = l_asg02
         DISPLAY BY NAME g_asx[l_ac].asg02_t
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
 
   DISPLAY ARRAY g_asx TO s_asx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
      #--No:FUN-B90088--add-str
      ON ACTION create_share_data         #攤銷憑證生成
         LET g_action_choice="create_share_data"
         EXIT DISPLAY 
      #--No:FUN-B90088--add-end
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
 
   OPEN WINDOW i013_g_w AT p_row,p_col WITH FORM "ggl/42f/gglt1015_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("gglt1015_g")

   WHILE TRUE
       #No:FUN-B90088--add--end
          INPUT BY NAME g_tm_g.asw01,g_tm_g.asw02,g_tm_g.asw03,g_tm_g.asw031 
         BEFORE INPUT 
            CALL cl_qbe_init()
        
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asw03)   #族群代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_asa1"
                  LET g_qryparam.state="i"
                  CALL cl_create_qry() RETURNING g_tm_g.asw03
                  DISPLAY g_tm_g.asw03 TO asw03
                  NEXT FIELD asw03

               WHEN INFIELD(asw031)    #上層公司
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_asg"
                    LET g_qryparam.state="i"
                    CALL cl_create_qry() RETURNING g_tm_g.asw031
                    DISPLAY g_tm_g.asw031 TO asw031
                    NEXT FIELD asw031

               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about         
            CALL cl_about()     

         ON ACTION help          
            CALL cl_show_help()  

         ON ACTION controlg     
            CALL cl_cmdask()     


         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i013_g_w
         RETURN
      END IF
      #No:FUN-B90088--add--end
      #str TQC-760167 mod
      #CONSTRUCT BY NAME g_wc1 ON asw01,asw02,asw03,asw031,asw04 #FUN-770086
      #CONSTRUCT BY NAME g_wc1 ON asw01,asw02,asw03,asw031,asw04,asw11 #FUN-770086 #FUN-930074 #No:FUN-B90088 mark
        CONSTRUCT BY NAME g_wc1 ON asw04  #No:FUN-B90088 add
       #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION CONTROLP
            CASE
               #--No:FUN-B90088-mark-str--
               #WHEN INFIELD(asw03)   #族群代號
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form ="q_asa1"
                 # LET g_qryparam.state="c"
                 # CALL cl_create_qry() RETURNING g_qryparam.multiret
                 # DISPLAY g_qryparam.multiret TO asw03
                #  NEXT FIELD asw03
               ##FUN-770086...................beatk
               #WHEN INFIELD(asw031)    #上層公司
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.form ="q_asg"
               #     LET g_qryparam.state="i"
               #     CALL cl_create_qry() RETURNING g_tm_g.asw031
               #     DISPLAY g_tm_g.asw031 TO asw031
               #     NEXT FIELD asw031
               ##FUN-770086...................end
               ##--FUN-930074 start---
               #WHEN INFIELD(asw11)     #交易幣別
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.state = "c"
               #     LET g_qryparam.form ="q_azi"
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
               #     DISPLAY g_qryparam.multiret TO asw11 
               #    NEXT FIELD asw11
               #--FUN-930074 end-----
               #No:FUN-B90088--mark--end
               #--No:FUN-B90088--add--str
               WHEN INFIELD(asw04)    
                    CALL q_m_asw(TRUE,TRUE,g_tm_g.asw01,g_tm_g.asw02,g_tm_g.asw03,g_tm_g.asw031)
                         RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO asw04
                    NEXT FIELD asw04
               #---No:FUN-B90088-add--end---
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
       l_asw       RECORD LIKE asw_file.*,
       l_asx       RECORD LIKE asx_file.*
 
  #str TQC-760167 add
   LET l_sql = "SELECT COUNT(*) FROM asw_file WHERE ",g_wc1 CLIPPED
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
 
   LET l_sql = "SELECT * FROM asw_file WHERE ",g_wc1 CLIPPED
   PREPARE i013_g_pre1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('i013_g_pre1',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
   DECLARE i013_g_c1 CURSOR FOR i013_g_pre1
 
   FOREACH i013_g_c1 INTO l_asw.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('i013_g_c1',SQLCA.SQLCODE,1)
         LET g_success='N'
         RETURN
      END IF
 
      LET l_asx.asx01 = l_asw.asw01
      LET l_asx.asx02 = l_asw.asw02
      LET l_asx.asx03 = l_asw.asw03
      LET l_asx.asx031= l_asw.asw031 #FUN-770086
      LET l_asx.asx04 = l_asw.asw04
      LET l_asx.asx05 = l_asw.asw05
      LET l_asx.asx06 = l_asw.asw06
      LET l_asx.asx07 = l_asw.asw07
      LET l_asx.asx08 = l_asw.asw08
      LET l_asx.asx11 = l_asw.asw11
      LET l_asx.asx09 = l_asw.asw19  #No:FUN-B90088 add
      #LET l_asx.asx16 = l_asw.asw16  #No:FUN-B90088 mark
      LET l_asx.asx16 = l_asw.asw13+l_asw.asw14  #FUN-B90088 add
      LET l_asx.asx17 = 0
      LET l_asx.asx18 = 0
      LET l_asx.asx19 = 0
      LET l_asx.asx20 = 'N'
      LET l_asx.asxlegal = g_legal #FUN-980003 add

      #FUN-B80135--add--str--
      IF l_asx.asx01 < g_year OR (l_asx.asx01 = g_year AND l_asx.asx02<=g_month) THEN 
         CALL cl_err('','atp-164',0)
         LET g_success='N'
         RETURN
      END IF 
      #FUN-B80135--add--end
      
      INSERT INTO asx_file VALUES(l_asx.*)
      IF STATUS THEN
         CALL cl_err('i013_g_pre1',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","asx_file",l_asx.asx01,l_asx.asx02,SQLCA.sqlcode,"","",1)
         LET g_success='N'
         RETURN
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i013_sg()   #攤銷資料產生
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #TQC-760167 add
DEFINE tm          RECORD
                    yy     LIKE asx_file.asx01,
                    mm     LIKE asx_file.asx02
                   END RECORD,
       l_flag      LIKE type_file.chr1
 
   OPEN WINDOW i013_sg_w AT p_row,p_col WITH FORM "ggl/42f/gglt1015_sg"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("gglt1015_sg")
 
   WHILE TRUE
      #str TQC-760167 mod
      CONSTRUCT BY NAME g_wc2 ON asx01,asx02,asx03,asx031#,asx04,asx05,#No:FUN-B90088 mark
                                 #asx06,asx07,asx08 #FUN-770086  #No:FUN-B90088 mark
         #No.FUN-580031 --start--     HCN
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 --end--       HCN
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(asx03)   #族群代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_asa1"
                  LET g_qryparam.state="c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO asx03
                  NEXT FIELD asx03
               #FUN-770086...................beatk
               WHEN INFIELD(asx031)    #上層公司
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_asg"
                    LET g_qryparam.state="c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO asx031
                    NEXT FIELD asx031
               #FUN-770086...................end
               #No:FUN-B90088 mark--str
               #WHEN INFIELD(g)   #來源公司
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form ="q_asb5"
               #   LET g_qryparam.state="c"
               #  CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO asx07
               #   NEXT FIELD asx07
               #WHEN INFIELD(h)   #交易公司
               #   CALL cl_init_qry_var()
               #   LET g_qryparam.form ="q_asb5"
               #   LET g_qryparam.state="c"
               #   CALL cl_create_qry() RETURNING g_qryparam.multiret
               #   DISPLAY g_qryparam.multiret TO asx08
               #   NEXT FIELD asx08
               #No:FUN-B90088 mark--end
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
            IF tm.yy  < 0 THEN 
               NEXT FIELD yy    
            END IF
            #No.FUN-B80135--add--str--
            IF tm.yy<g_year THEN
               CALL cl_err(tm.yy,'atp-164',0)
               NEXT FIELD yy
            ELSE
               IF tm.yy=g_year AND tm.mm<=g_month THEN
                  CALL cl_err('','atp-164',0)
                  NEXT FIELD mm
               END IF 
            END IF 
            #No.FUN-B80135--add--end
            #--No:FUN-B90088 --add--  agl-356 add
            IF tm.yy < g_asx01 THEN
               CALL cl_err(tm.yy,'agl-356',0)
               NEXT FIELD yy
            ELSE
               IF tm.yy = g_asx01 AND tm.mm <= g_asx01 THEN
                  CALL cl_err('','agl-356',0)
                  NEXT FIELD mm
               END IF
            END IF 
            #--No:FUN-B90088--add--end--
         AFTER FIELD mm
            IF cl_null(tm.mm) THEN
               CALL cl_err('','mfg5103',0)
               NEXT FIELD mm
            END IF
            IF tm.mm  < 0 OR tm.mm>12 THEN 
               NEXT FIELD mm    
            END IF
            #FUN-B80135--add--str--
            IF NOT cl_null(tm.yy) AND tm.yy=g_year 
               AND tm.mm<=g_month THEN
               CALL cl_err('','atp-164',0)
               NEXT FIELD mm
            END IF 
            #FUN-B80135--add--end
            #--No:FUN-B90088--add--agl-356
            IF NOT cl_null(tm.yy) AND tm.yy = g_asx01
               AND tm.mm <= g_asx02 THEN
               CALL cl_err('','agl-356',0)
               NEXT FIELD mm
            END IF 
            #--No:FUN-B90088--add-end---

   
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
                    yy     LIKE asx_file.asx01,
                    mm     LIKE asx_file.asx02
                   END RECORD,
       l_sql       STRING,
       l_asx       RECORD LIKE asx_file.*,
       l_asy       RECORD LIKE asy_file.*,
       l_azi04     LIKE azi_file.azi04
 
   #str TQC-760167 mod
   LET l_sql = "SELECT * FROM asx_file ",
               "WHERE ",g_wc2 CLIPPED," AND asx20='N'"    #尚未結案
   #end TQC-760167 mod
   PREPARE i013_sg_pre1 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('i013_sg_pre1',SQLCA.SQLCODE,1)
      LET g_success='N'
      RETURN
   END IF
   DECLARE i013_sg_c1 CURSOR FOR i013_sg_pre1
   FOREACH i013_sg_c1 INTO l_asx.*
      #抓來源公司的來源幣別的金額取位小數位數(azi04)
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_asx.asx11
 
      LET l_asy.asy01 = l_asx.asx01
      LET l_asy.asy02 = l_asx.asx02
      LET l_asy.asy03 = l_asx.asx03
      LET l_asy.asy031= l_asx.asx031 #FUN-770086
      LET l_asy.asy04 = l_asx.asx04
      LET l_asy.asy05 = tm.yy
      LET l_asy.asy06 = tm.mm
      # 本期攤銷金額  = (分配未實現利益-已攤銷金額)/(攤銷總期數-已攤銷期數)
      #--No:FUN-B90088--mod
      IF l_asx.asx17-l_asx.asx18=1 THEN #最後一期
         LET l_asy.asy07=l_asx.asx16-l_asx.asx19
         ######已摊销完毕要结案					
         UPDATE asx_file SET asx20 = 'Y' 					
          WHERE asx01= l_asx.asx01 AND asx02 = l_asx.asx02					
            AND asx03= l_asx.asx03 AND asx031=l_asx.asx031					
            AND asx04= l_asx.asx04 AND asx11 = l_asx.asx11
         IF SQLCA.SQLCODE AND SQLCA.SQLERRD[3]=0  THEN
         END IF
      ELSE
         LET l_asy.asy07 = (l_asx.asx16-l_asx.asx19)/(l_asx.asx17-l_asx.asx18)   
      END IF
      CALL cl_digcut(l_asy.asy07,l_azi04) RETURNING l_asy.asy07   #金額取位
      #LET l_asy.asy08 = i013_asy08(l_asx.*,l_asy.asy07)
      LET l_asy.asy08=l_asy.asy07
      #--No:FUN-B90088-mod--end
      LET l_asy.asylegal = g_legal #FUN-980003 add
      #FUN-B80135--add--str--
      IF l_asy.asy01 <g_year OR (l_asy.asy01=g_year AND l_asy.asy02<=g_month) THEN 
         CALL cl_err('','atp-164',0)
         LET g_success='N'
         RETURN
      END IF 
      #FUN-B80135--add--end
      INSERT INTO asy_file VALUES(l_asy.*)
      IF SQLCA.SQLCODE THEN
         LET g_success='N'
         CONTINUE FOREACH
      ELSE
         UPDATE asx_file SET asx18=asx18+1,
                             asx19=asx19+l_asy.asy07
          WHERE asx01=l_asx.asx01 AND asx02=l_asx.asx02
            AND asx03=l_asx.asx03 AND asx031=l_asx.asx031 AND asx04=l_asx.asx04 #FUN-770086
         IF SQLCA.SQLCODE AND SQLCA.SQLERRD[3]=0  THEN
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
   END FOREACH
END FUNCTION
#--No:FUN-B90088-mark--str
#FUNCTION i013_asy08(p_asx,p_asy07)
#DEFINE p_asx       RECORD LIKE asx_file.*,
#       p_asy07     LIKE asy_file.asy07,   #本期攤銷金額
#       l_asy08     LIKE asy_file.asy08,   #本期攤銷合併幣別金額
#       l_asa02     LIKE asa_file.asa02,   #上層公司
#       l_asg05     LIKE asg_file.asg05,   #上層帳別
#       l_asg06     LIKE asg_file.asg06,   #記帳幣別
#       l_asg07     LIKE asg_file.asg07,   #功能幣別
#       l_asw10     LIKE asw_file.asw10,   #來源科目
#       l_ash11     LIKE ash_file.ash11,   #再衡量匯率類別
#       l_ash12     LIKE ash_file.ash12,   #換算匯率類別
#       l_rate      LIKE ase_file.ase05,   #匯率
#       l_azi04     LIKE azi_file.azi04    #金額取位小數位數 
# 
#   #本期攤銷合併幣別金額(asy08)計算方法：
#   #先將本期攤銷金額(asy07)轉換成來源公司的功能幣別金額，
#   #再轉換成其族群代號的上層公司的記帳幣別金額
# 
#   LET l_rate  = 1
#   LET l_asy08=p_asy07
# 
#   #抓單頭族群代號(asx03)的上層公司(asa02),上層帳別(asg05)
#   SELECT asa02 INTO l_asa02 FROM asa_file WHERE asa01=p_asx.asx03
#  SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01=l_asa02
# 
#   #抓來源公司的功能幣別(asg07)，上層公司的記帳幣別(asg06)
#  SELECT asg07 INTO l_asg07 FROM asg_file WHERE asg01=p_asx.asx07
#   SELECT asg06 INTO l_asg06 FROM asg_file WHERE asg01=l_asa02
# 
#   #抓上層公司的記帳幣別的金額取位小數位數(azi04)
#   SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_asg06
# 
#   #抓來源公司的來源科目(asw11)
#   SELECT asw10 INTO l_asw10 FROM asw_file 
#    WHERE asw01=p_asx.asx01 AND asw02=p_asx.asx02 
#     AND asw03=p_asx.asx03 AND asw04=p_asx.asx04 
#      AND asw11=p_asx.asx11  #FUN-930074 
# 
#   #抓來源公司的來源科目的再衡量匯率類別(ash11),
#   #抓上層公司的來源科目的換算匯率類別(ash12)
#   SELECT ash11 INTO l_ash11 FROM ash_file
#   WHERE ash00=l_asg05 AND ash01=p_asx.asx07 AND ash06=l_asw10  #FUN-910001 mod ash04->ash06
#      AND ash13=p_asx.asx03   #FUN-910001 add
#   SELECT ash11 INTO l_ash12 FROM ash_file
#    WHERE ash00=l_asg05 AND ash01=l_asa02 AND ash06=l_asw10  #FUN-910001 mod ash04->ash06
#      AND ash13=p_asx.asx03   #FUN-910001 add
#      
#   #當來源幣別(asx11)與來源公司功能幣別(asg07)不同時才需要抓匯率來計算
#   IF p_asx.asx11 != l_asg07 THEN
#     #功能幣別匯率
#      CALL i013_getrate(l_ash11,p_asx.asx01,p_asx.asx02,p_asx.asx11,l_asg07,
#                        p_asx.asx07,l_asw10) RETURNING l_rate
#      LET l_asy08=l_asy08*l_rate
#   END IF
# 
#   LET l_rate  = 1
#   #當來源公司功能幣別(asg07)與上層公司記帳幣別(asg06)不同時才需要抓匯率來計算
#   IF l_asg07 != l_asg06 THEN
#      #記帳幣別匯率
#      CALL i013_getrate(l_ash12,p_asx.asx01,p_asx.asx02,l_asg07,l_asg06,
#                        p_asx.asx07,l_asw10) RETURNING l_rate
#      LET l_asy08=l_asy08*l_rate
#   END IF
# 
#   CALL cl_digcut(l_asy08,l_azi04) RETURNING l_asy08   #金額取位
#   RETURN l_asy08  
#END FUNCTION
#--No:FUN-B90088-mark--end--
 
FUNCTION i013_getrate(p_value,p_ase01,p_ase02,p_ase03,p_ase04,p_ase08,p_ase09)
DEFINE p_value LIKE ash_file.ash11,
       p_ase01 LIKE ase_file.ase01,
       p_ase02 LIKE ase_file.ase02,
       p_ase03 LIKE ase_file.ase03,
       p_ase04 LIKE ase_file.ase04,
       p_ase08 LIKE ase_file.ase08,
       p_ase09 LIKE ase_file.ase09,
       l_rate  LIKE ase_file.ase05
 
   CASE 
      WHEN p_value='1'   #1.現時匯率
         SELECT ase05 INTO l_rate FROM ase_file
          WHERE ase01=p_ase01
            AND ase02=(SELECT max(ase02) FROM ase_file
                        WHERE ase01 =  p_ase01
                          AND ase02 <= p_ase02
                          AND ase03 =  p_ase03
                          AND ase04 =  p_ase04)
            AND ase03=p_ase03 
            AND ase04=p_ase04
      WHEN p_value='2'   #2.歷史匯率
         SELECT ase06 INTO l_rate FROM ase_file
          WHERE ase01=p_ase01
            AND ase02=(SELECT max(ase02) FROM ase_file
                        WHERE ase01 =  p_ase01
                          AND ase02 <= p_ase02
                          AND ase03 =  p_ase03
                          AND ase04 =  p_ase04)
            AND ase02=p_ase02
            AND ase03=p_ase03 
            AND ase04=p_ase04
      WHEN p_value='3'   #3.平均匯率
         SELECT ase07 INTO l_rate FROM ase_file
          WHERE ase01=p_ase01
            AND ase02=(SELECT max(ase02) FROM ase_file
                        WHERE ase01 =  p_ase01
                          AND ase02 <= p_ase02
                          AND ase03 =  p_ase03
                          AND ase04 =  p_ase04)
            AND ase03=p_ase03
            AND ase04=p_ase04
      OTHERWISE
         LET l_rate=1
   END CASE
   IF l_rate = 0 OR cl_null(l_rate) THEN LET l_rate = 1 END IF
 
   RETURN l_rate
END FUNCTION
 
FUNCTION i013_s()
DEFINE l_wc   STRING
   #FUN-770086.....................beatk
   IF g_asx01 IS NULL OR g_asx02 IS NULL OR g_asx03 IS NULL OR g_asx031 IS NULL THEN
      CALL cl_err('',-400,0) RETURN 
   END IF
   #FUN-770086.....................end
   OPEN WINDOW i013_s_w AT p_row,p_col WITH FORM "ggl/42f/gglt1015_s"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("gglt1015_s")
 
   DISPLAY g_asx01,g_asx02,g_asx03,g_asx031 TO asy01,asy02,asy03,asy031   #單頭  #FUN-770086   
   CALL i012_set_asg02(g_asx031) #FUN-770086
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
               LET g_wc3 = " asy01= ",g_asx01 CLIPPED,"  AND ",
                           " asy02= ",g_asx02 CLIPPED,"  AND ",
                           " asy03='",g_asx03 CLIPPED,"' AND ",
                           " asy031='",g_asx031 CLIPPED,"' AND ", #FUN-770086
                           " asy04= ",g_asx[l_ac].asx04 CLIPPED
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
               IF g_asy01 IS NOT NULL THEN
                  LET g_doc.column1 = "asy01"
                  LET g_doc.column2 = "asy02"
                  LET g_doc.column3 = "asy03"
                  LET g_doc.value1 = g_asx01
                  LET g_doc.value2 = g_asx02
                  LET g_doc.value3 = g_asx03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asy),'','')
            END IF
      END CASE
   END WHILE
 
   CLOSE WINDOW i013_s_w
END FUNCTION
 
FUNCTION i013_b_s()
DEFINE l_lock_sw       LIKE type_file.chr1      #單身鎖住否
 
   LET g_action_choice = ""
 
   LET g_forupd_sql = "SELECT asy04,asy05,asy06,asy07,asy08,asy09 ",  #NO:FUN-B90088 add asy09
                      "  FROM asy_file ",
                      "  WHERE asy01 = ? AND asy02 = ? ",
                      "   AND asy03 = ? AND asy031= ? AND asy04 = ? ", #FUN-770086
                      "   AND asy05 = ? AND asy06 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl_s CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_asy WITHOUT DEFAULTS FROM s_asy.*
         ATTRIBUTE(COUNT=g_rec_b_s,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=True,APPEND ROW=FALSE)
      BEFORE INPUT
         IF g_rec_b_s!=0 THEN
            CALL fgl_set_arr_curr(l_ac_s)
         END IF
 
      BEFORE ROW
         LET l_ac_s = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         #No:FUN-90088--add--str--
         IF g_asy[l_ac_s].asy09 IS NOT NULL THEN
            CALL cl_set_comp_entry("asy04,asy05,asy06,asy07,asy08,asy09",false)
         ELSE 
            CALL cl_set_comp_entry("asy04,asy05,asy06,asy08,asy09",false)
            CALL cl_set_comp_entry("asy07",TRUE)
         END IF
          #No:FUN-90088--add--end---
         IF g_rec_b_s >= l_ac_s THEN
            BEGIN WORK
            LET g_asy_t.* = g_asy[l_ac_s].*  #BACKUP   #FUN-780068 add
            OPEN i013_bcl_s USING g_asx01,g_asx02,g_asx03,g_asx031,
                                  g_asx[l_ac].asx04, #FUN-770086
                                  g_asy[l_ac_s].asy05,g_asy[l_ac_s].asy06
            IF STATUS THEN
               CALL cl_err("OPEN i013_bcl_s:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i013_bcl_s INTO g_asy[l_ac_s].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_asx_t.asx04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_asy_t.asy04 > 0 AND g_asy_t.asy04 IS NOT NULL THEN   #FUN-780068 mod
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM asy_file
             WHERE asy01 = g_asx01 AND asy02 = g_asx02 
               AND asy03 = g_asx03 AND asy031 = g_asx031 #FUN-770086
               AND asy04 = g_asy_t.asy04   #FUN-780068 mod
               AND asy05 = g_asy_t.asy05   #FUN-780068 mod
               AND asy06 = g_asy_t.asy06   #FUN-780068 mod
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","asy_file",g_asx01,g_asy_t.asy04,SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL DELETE 
            ELSE
               UPDATE asx_file SET asx18=asx18-1,
                                   asx19=asx19-g_asy[l_ac_s].asy07
                WHERE asx01=g_asx01 AND asx02=g_asx02
                  AND asx03=g_asx03 AND asx031=g_asx031 
                  AND asx04=g_asy_t.asy04  #FUN-770086   #FUN-780068 mod
               IF SQLCA.sqlcode THEN 
                  CALL cl_err3("upd","asx_file",g_asx01,g_asy_t.asy04,SQLCA.sqlcode,"","",1)
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
         CALL g_asy.deleteElement(g_rec_b_s+1)
 
      ON ACTION CONTROLZ
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
 
   LET g_sql = "SELECT asy04,asy05,asy06,asy07,asy08,asy09 ",#FUN-B90088 add asy09
               "  FROM asy_file ",
               " WHERE asy01 =  ",g_asx01 CLIPPED,
               "   AND asy02 =  ",g_asx02 CLIPPED,
               "   AND asy03 = '",g_asx03 CLIPPED,"'",
               "   AND asy031= '",g_asx031 CLIPPED,"'", #FUN-770086
               "   AND asy04 =  ",g_asx[l_ac].asx04 CLIPPED,
               " ORDER BY asy04,asy05,asy06"
   PREPARE i013_prepare3 FROM g_sql      #預備一下
   DECLARE asy_cs CURSOR FOR i013_prepare3
 
   CALL g_asy.clear()
 
   LET g_cnt = 1
   LET g_rec_b_s = 0
 
   FOREACH asy_cs INTO g_asy[g_cnt].*   #單身 ARRAY 填充
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
   CALL g_asy.deleteElement(g_cnt)
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
 
   DISPLAY ARRAY g_asy TO s_asy.* ATTRIBUTE(COUNT=g_rec_b_s,UNBUFFERED)
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
 
FUNCTION i013_c(p_asx20)   #結案
DEFINE p_asx20    LIKE asx_file.asx20
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_asx01) OR cl_null(g_asx02) OR 
      cl_null(g_asx03) OR cl_null(g_asx031) THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN
   END IF
 
   LET g_forupd_sql = "SELECT asx04,asx05,asx06,asx07,'',asx08,'', ",
                      "       asx11,asx16,asx17,asx18,asx19,asx20 ",
                      "  FROM asx_file ",
                      "  WHERE asx01 = ? AND asx02 = ? ",
                      "   AND asx03 = ? AND asx031= ? AND asx04 = ? FOR UPDATE" #FUN-770086
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i013_bcl_c CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   IF p_asx20 != "Y" THEN
      IF NOT cl_confirm('lib-003') THEN RETURN END IF   #此筆資料是否確定結案?
      LET p_asx20 = "Y"
   ELSE
      IF NOT cl_confirm('lib-004') THEN RETURN END IF   #此筆資料是否取消結案?
      LET p_asx20 = "N"
   END IF
 
   LET g_success='Y'
   BEGIN WORK
 
   OPEN i013_bcl_c USING g_asx01,g_asx02,g_asx03,g_asx031,g_asx[l_ac].asx04 #FUN-770086
   IF STATUS THEN
      CALL cl_err("OPEN i013_bcl_c:", STATUS, 1)
      CLOSE i013_bcl_c
      ROLLBACK WORK
      RETURN
   END IF
   FETCH i013_bcl_c INTO g_asx[l_ac].*    # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_asx[l_ac].asx04,SQLCA.sqlcode,0)
      CLOSE i013_bcl_c
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE asx_file SET asx20=p_asx20
    WHERE asx01=g_asx01 AND asx02=g_asx02 
      AND asx03=g_asx03 AND asx031=g_asx031  #FUN-770086
      AND asx04=g_asx[l_ac].asx04
   LET g_asx[l_ac].asx20 = p_asx20
   DISPLAY BY NAME g_asx[l_ac].asx20
 
END FUNCTION
 
FUNCTION i013_out()
   DEFINE l_wc STRING
 
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gglt1015'
 
   #組合出 SQL 指令
   LET g_sql="SELECT DISTINCT A.asx01,A.asx02,A.asx03,A.asx031,", #FUN-770086
             "       E.asg02 asx031_d,A.asx04,A.asx05,A.asx06,", #FUN-770086
             "       A.asx07,B.asg02 asg02_s,A.asx08,C.asg02 asg02_t,",
             "       A.asx11,A.asx16,A.asx17,A.asx18,A.asx19,A.asx20,D.azi04 ",
             "  FROM asx_file A,asg_file B,asg_file C,azi_file D,asg_file E ", #FUN-770086
             " WHERE A.asx07 = B.asg01",
             "   AND A.asx08 = C.asg01",
             "   AND A.asx11 = D.azi01",
             "   AND A.asx031= E.asg01", #FUN-770086
             "   AND ",g_wc CLIPPED,
             " ORDER BY A.asx01,A.asx02,A.asx03,A.asx04"
   PREPARE i013_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i013_co  CURSOR FOR i013_p1
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'asx01,asx02,asx03,asx031,asx04,asx05,asx06,asx07,asx08,asx11,asx16,asx17,asx18,asx19,asx20') #FUN-770086
           RETURNING l_wc
   ELSE
      LET l_wc = ''
   END IF
 
   CALL cl_prt_cs1('gglt1015','gglt1015',g_sql,l_wc)
 
END FUNCTION
 
#str TQC-760167 add
FUNCTION i013_tm_s()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01   #TQC-760167 add
DEFINE tm          RECORD
                    yy     LIKE asx_file.asx01,
                    mm     LIKE asx_file.asx02
                   END RECORD
 
   OPEN WINDOW i013_out_w AT p_row,p_col WITH FORM "ggl/42f/gglt1015_out"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("gglt1015_out")
 
   #str TQC-760167 mod
   CONSTRUCT BY NAME g_wc3 ON asx01,asx02,asx03,asx031,asx04,asx05,asx06,
                              asx07,asx08 #FUN-770086
      #No.FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asx03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asx03
               NEXT FIELD asx03
            #FUN-770086...................beatk
            WHEN INFIELD(asx031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_asg"
                 LET g_qryparam.state="c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asx031
                 NEXT FIELD asx031
            #FUN-770086...................end
            WHEN INFIELD(g)   #來源公司
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asb5"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asx07
               NEXT FIELD asx07
            WHEN INFIELD(h)   #交易公司
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asb5"
               LET g_qryparam.state="c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO asx08
               NEXT FIELD asx08
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
   DEFINE p_yy     LIKE asx_file.asx01
   DEFINE p_mm     LIKE asx_file.asx02
   DEFINE l_wc3    STRING
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'gglt1015'
 
   #組合出 SQL 指令
   LET g_sql="SELECT DISTINCT A.asx01,A.asx02,A.asx03,A.asx031,", #FUN-770086
             "       F.asg02 asx031_d,A.asx04,A.asx05,A.asx06,",
             "       A.asx07,B.asg02 asg02_s,A.asx08,C.asg02 asg02_t,",
             "       A.asx11,A.asx16,A.asx17,A.asx18,A.asx19,A.asx20,D.azi04, ",
             "       E.asy05,E.asy06,E.asy07,E.asy08 ",          #TQC-760167 add
             "  FROM asx_file A,asg_file B,asg_file C,azi_file D,asy_file E,",
             "       asg_file F", #FUN-770086
             " WHERE A.asx07 = B.asg01",
             "   AND A.asx08 = C.asg01",
             "   AND A.asx11 = D.azi01",
             "   AND A.asx01 = E.asy01 AND A.asx02 = E.asy02",   #TQC-760167 add
             "   AND A.asx03 = E.asy03 AND A.asx04 = E.asy04",   #TQC-760167 add
             "   AND A.asx031= F.asg01",                         #FUN-770086
             "   AND ",g_wc3 CLIPPED                             #TQC-760167 add
   #str TQC-760167 add
   IF NOT cl_null(p_yy) THEN
      LET g_sql = g_sql,"   AND E.asy05 = ",p_yy CLIPPED
   END IF
   IF NOT cl_null(p_mm) THEN
      LET g_sql = g_sql,"   AND E.asy06 = ",p_mm CLIPPED
   END IF
   #end TQC-760167 add
   LET g_sql = g_sql," ORDER BY A.asx01,A.asx02,A.asx03,A.asx04"
   PREPARE i013_p2 FROM g_sql                # RUNTIME 編譯
   DECLARE i013_co1 CURSOR FOR i013_p2
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc3,'asx01,asx02,asx03,asx031,asx04,asx05,asx06,asx07,asx08') #FUN-770086
           RETURNING l_wc3
   ELSE
      LET l_wc3 = ''
   END IF
 
 ##CALL cl_prt_cs1('gglt1015','gglt1015_s',g_sql,l_wc3)  #FUN-7B0087
   CALL cl_prt_cs1('gglt1015','gglt1015_1',g_sql,l_wc3)
 
END FUNCTION
 
#FUN-770086.....................beatk
FUNCTION i012_set_asg02(p_asg01)
   DEFINE p_asg01 LIKE asg_file.asg01
   DEFINE l_asg02 LIKE asg_file.asg02
   IF p_asg01 IS NULL THEN 
      DISPLAY NULL TO FORMONLY.asg02
      RETURN
   END IF
   SELECT asg02 INTO l_asg02 FROM asg_file
                            WHERE asg01=p_asg01
   DISPLAY l_asg02 TO FORMONLY.asg02
END FUNCTION
 
FUNCTION i013_chk_asx031()
   IF NOT cl_null(g_asx031) THEN
      LET g_cnt=0
      SELECT count(*) INTO g_cnt FROM asg_file WHERE asg01 = g_asx031
      IF g_cnt=0 THEN
         DISPLAY NULL TO FORMONLY.asg02
         CALL cl_err3("sel","asg_file",g_asx031,"",SQLCA.sqlcode,"","",1)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-770086.....................end
#FUN-B90088-add--str--
#憑證生成
FUNCTION i013_csd()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01  
DEFINE tm          RECORD          #--input條件變量
                    aac01  LIKE asj_file.asj01,
                    asx01  LIKE asx_file.asx01,
                    asx02  LIKE asx_File.asx02,
                    asx03  LIKE asx_file.asx03,
                    asx031 LIKE asx_file.asx031,
                    yy     LIKE asx_file.asx01,
                    mm     LIKE asx_file.asx02
                   END RECORD,
       l_flag      LIKE type_file.chr1   #批處理成功標記
DEFINE l_asy05     LIKE asy_file.asy05   #記錄以攤銷的年
DEFINE l_asy06     LIKE asy_file.asy06   #記錄以攤銷的期
   #gglt1015主畫面無資料報錯
   IF g_asx01 IS NULL OR g_asx02 IS NULL OR g_asx03 IS NULL OR g_asx031 IS NULL THEN
      CALL cl_err('',-400,0) RETURN 
   END IF
   #開啟憑證生成批處理畫面
   OPEN WINDOW i013_csd_w AT p_row,p_col WITH FORM "ggl/42f/gglt1015_csd"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("gglt1015_csd")
    WHILE TRUE
     
      INPUT BY NAME tm.aac01,tm.asx01,tm.asx02,tm.asx03,tm.asx031,tm.yy,tm.mm WITHOUT DEFAULTS
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)  
            INITIALIZE tm.* TO NULL
            #給yy，mm默認值
            LET tm.yy = YEAR(g_today)    #現行年度
            LET tm.mm = MONTH(g_today)   #現行期別
            DISPLAY tm.yy,tm.mm TO FORMONLY.yy,FORMONLY.mm
            #得到數據庫中符合條件的已有年，期的最大值
            SELECT MAX(asy05),MAX(asy06) INTO l_asy05,l_asy06 FROM asy_file 
             WHERE asy01 = g_asx01
               AND asy02 = g_asx02
               AND asy03 = g_asx03
               AND asy031 = g_asx031
            #如沒有則賦初值
            IF cl_null(l_asy05) THEN 
               LET l_asy05=g_asx01
            END IF
            IF cl_null(l_asy06) THEN 
               LET l_asy06=g_asx02-1
            END IF 
            
         AFTER FIELD aac01   
           IF NOT cl_null(tm.aac01) THEN
              CALL i013_aac01(tm.aac01)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('aac01',g_errno,0)
                 NEXT FIELD aac01
              END IF
           ELSE
              NEXT FIELD aac01
           END IF
         #年度       
         AFTER FIELD asx01
            IF tm.asx01 IS NOT NULL THEN
               IF tm.asx01< g_asx01 THEN
                  CALL cl_err(tm.asx01,'agl-993',0)
                  NEXT FIELD asx01
               ELSE
                  IF tm.asx01 = g_asx01 AND tm.asx02 < g_asx02 THEN
                     CALL cl_err('','agl-993',0)
                     NEXT FIELD asx02
                  END IF
               END IF 
            END IF

         #期別
         AFTER FIELD asx02
            IF NOT cl_null(tm.asx01) AND tm.asx01 = g_asx01
               AND tm.asx02 < g_asx02 THEN
               CALL cl_err('','agl-993',0)
               NEXT FIELD asx02
            END IF
         #攤銷年度   
         AFTER FIELD yy
            IF tm.yy IS NOT NULL THEN
               IF tm.yy< l_asy05 THEN
                  CALL cl_err(tm.yy,'agl-993',0)
                  NEXT FIELD yy
               ELSE
                  IF tm.yy = l_asy05 AND tm.mm <= l_asy06 THEN
                     CALL cl_err('','agl-993',0)
                     NEXT FIELD mm
                  END IF
               END IF 
            END IF
         #攤銷期別
         AFTER FIELD mm
            IF NOT cl_null(tm.asx01) AND tm.asx01 = l_asy05
               AND tm.mm <= l_asy06 THEN
               CALL cl_err('','agl-993',0)
               NEXT FIELD mm
            END IF 

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(aac01)   #編號
                  CALL q_aac(FALSE,TRUE,tm.aac01,'A','','','GGL') 
                       RETURNING tm.aac01
                  DISPLAY BY NAME tm.aac01
                  NEXT FIELD aac01
               
               WHEN INFIELD(asx03)   #族群代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_asa1"
                  LET g_qryparam.state="i"
                  CALL cl_create_qry() RETURNING tm.asx03
                  DISPLAY BY NAME tm.asx03
                  NEXT FIELD asx03

               WHEN INFIELD(asx031)    #上層公司
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_asg"
                    LET g_qryparam.state="i"
                    CALL cl_create_qry() RETURNING tm.asx031
                    DISPLAY BY NAME tm.asx031
                    NEXT FIELD asx031

               OTHERWISE EXIT CASE
            END CASE

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION about         
            CALL cl_about()      

         ON ACTION help          
            CALL cl_show_help()  

         ON ACTION controlg      
            CALL cl_cmdask()     

         AFTER INPUT
            IF INT_FLAG THEN EXIT INPUT END IF

         ON ACTION qbe_save
            CALL cl_qbe_save()
      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW i013_csd_w
         RETURN
      END IF

      IF NOT cl_sure(0,0) THEN
         CLOSE WINDOW i013_csd_w
         RETURN
      ELSE
         BEGIN WORK
         LET g_success='Y'

         CALL i013_csd1(tm.*)  
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

   CLOSE WINDOW i013_csd_w

END FUNCTION

FUNCTION i013_csd1(tm)
DEFINE tm          RECORD
                    aac01  LIKE asj_file.asj01,
                    asx01  LIKE asx_file.asx01,
                    asx02  LIKE asx_File.asx02,
                    asx03  LIKE asx_file.asx03,
                    asx031 LIKE asx_file.asx031,
                    yy     LIKE asx_file.asx01,
                    mm     LIKE asx_file.asx02
                   END RECORD,
       l_sql       STRING
DEFINE l_asj     RECORD LIKE asj_file.*
DEFINE l_ask     RECORD LIKE ask_file.*      
DEFINE l_last_y  LIKE asx_file.asx01,#上一期的年度
       l_last_m  LIKE asx_File.asx02,#上一期的期別
       l_asy09   LIKE asy_file.asy09 
DEFINE l_tempno  LIKE type_file.num5
DEFINE li_result LIKE type_file.num5

   #判斷前期是否生成抵消憑證
   IF tm.mm=1 THEN			
      LET l_last_y = tm.yy - 1			
      LET l_last_m = 12			
   ELSE			
      LET l_last_y = tm.yy 			
      LET l_last_m = tm.mm - 1			
   END IF	
   #判斷下是否是第一次分攤
   LET l_tempno=0		
   SELECT COUNT(*) INTO l_tempno FROM asy_file 
    WHERE asy01=tm.asx01
      AND asy02=tm.asx02
      AND asy03=tm.asx03 
      AND asy031=tm.asx031
   IF l_tempno >0 THEN
      SELECT asy09 INTO l_asy09 FROM asy_file 
       WHERE asy01=tm.asx01
         AND asy02=tm.asx02
         AND asy03=tm.asx03 
         AND asy031=tm.asx031
         AND asy05=l_last_y 
         AND asy06=l_last_m
      IF SQLCA.sqlcode THEN                    #有問題
         CALL cl_err('',SQLCA.sqlcode,0)
         RETURN
         LET g_success='N'
      END IF
   END IF
   INITIALIZE l_asj.* TO NULL
   INITIALIZE l_ask.* TO NULl
   
   #l_asj賦值
  #LET l_asj.asj00 = g_aaz.aaz641      #TQC-D40119 mark
   LET l_asj.asj00 = g_asz01           #TQC-D40119 add
   
   #asj02--asj06賦值
   LET l_asj.asj02 = g_today
   LET l_asj.asj03 = tm.yy
   LET l_asj.asj04 = tm.mm
   LET l_asj.asj05 = tm.asx03
   LET l_asj.asj06 = tm.asx031
   #l_asj.asj01賦值
   #CALL s_auto_assign_no("GGL",tm.aac01,g_today,"","asj_file","asj01",g_dbs,2,l_asj.asj00)

  #CALL s_auto_assign_no("ggl",tm.aac01,l_asj.asj02,"","asj_file","asj01",g_plant,"2",l_asj.asj00)  #carrier 20111024
   CALL s_auto_assign_no("AGL",tm.aac01,l_asj.asj02,"","asj_file","asj01",g_plant,"2",l_asj.asj00)  #carrier 20111024
               RETURNING li_result,tm.aac01
   IF (NOT li_result) THEN
      CALL s_errmsg('asj_file','asj01',l_asj.asj01,'abm-621',1)
      LET g_success = 'N'
   ELSE
      LET l_asj.asj01 = tm.aac01
   END IF
   #asj07賦值
   SELECT asg05 INTO l_asj.asj07 FROM asg_file
    WHERE asg01 = tm.asx031
   LET l_asj.asj08 = "2"
   LET l_asj.asjconf = "Y"
   LET l_asj.asjuser = g_user
   LET l_asj.asjgrup = g_grup
   #LET l_asj.asjmodu = 
   LET l_asj.asjdate = g_today
   LET l_asj.asj081 = "4"
   
   #l_ask賦值
   LET l_ask.ask00 = l_asj.asj00
   LET l_ask.ask01 = l_asj.asj01
   SELECT COUNT(*)+1 INTO l_ask.ask02 FROM ask_file
    WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01
   LET l_ask.ask04 = g_asx[l_ac].asx08
   LET l_ask.ask05 = g_asx[l_ac].asx08
   
   #產生分錄1
   LET l_ask.ask03 = g_aaz.aaz114
   LET l_ask.ask06 = "1"
   LET l_ask.ask07 = g_asx[l_ac].asx16
   #判斷是否為0
   IF l_ask.ask07 <> 0 AND l_ask.ask07 IS NOT NULL THEN
   INSERT INTO ask_file VALUES (l_ask.*)
   LET l_ask.ask03 = g_asx[l_ac].asx09
   LET l_ask.ask06 = "2"
   INSERT INTO ask_file VALUES (l_ask.*)
   END IF
   
   #產生分錄2
   LET l_ask.ask03 = g_asx[l_ac].asx10
   LET l_ask.ask06 = "1"
   SELECT sum(asy07) INTO l_ask.ask07 FROM asy_file
    WHERE asy01=tm.asx01 
      AND asy02=tm.asx02 
      AND asy03=tm.asx03 
      AND asy031=tm.asx031 
      AND asy09 IS NOT NULL 
      AND asy05<tm.yy
   #判斷是否為0
   IF l_ask.ask07 <> 0 AND l_ask.ask07 IS NOT NULL THEN   
   INSERT INTO ask_file VALUES (l_ask.*)
   LET l_ask.ask03 = g_aaz.aaz114
   LET l_ask.ask06 = "2"
   INSERT INTO ask_file VALUES (l_ask.*)
   END IF
   
   #產生分錄3
   LET l_ask.ask03 = g_asx[l_ac].asx10
   LET l_ask.ask06 = "1"
   SELECT sum(asy07) INTO l_ask.ask07 FROM asy_file
    WHERE asy01=tm.asx01 
      AND asy02=tm.asx02 
      AND asy03=tm.asx03
      AND asy031=tm.asx031 
      AND asy05=tm.yy
   #判斷是否為0
   IF l_ask.ask07 <> 0 AND l_ask.ask07 IS NOT NULL THEN   
   INSERT INTO ask_file VALUES (l_ask.*)
   LET l_ask.ask03 = g_asx[l_ac].asx21
   LET l_ask.ask06 = "2"
   INSERT INTO ask_file VALUES (l_ask.*)
   END IF
   
   #判斷單身是否為空，然後判斷借貸是否平
   LET l_tempno=0
   SELECT COUNT(*) INTO l_tempno FROM ask_file
       WHERE ask00=l_asj.asj00
      AND ask01=l_asj.asj01
      
   IF l_tempno > 0 THEN
      SELECT sum(ask07) INTO l_asj.asj11 FROM ask_file 
       WHERE ask00=l_asj.asj00
         AND ask01=l_asj.asj01
         AND ask06="1"
      
      SELECT sum(ask07) INTO l_asj.asj12 FROM ask_file 
       WHERE ask00=l_asj.asj00
         AND ask01=l_asj.asj01
         AND ask06="2"
         
      #No.TQC-C90057  --Begin
      IF cl_null(l_asj.asj11) THEN LET l_asj.asj11 = 0 END IF
      IF cl_null(l_asj.asj12) THEN LET l_asj.asj12 = 0 END IF
      #No.TQC-C90057  --End  
      IF l_asj.asj11 <> l_asj.asj12 THEN
         CALL cl_err('','agl-992',1)
         LET g_success='N'
      ELSE
         #No.TQC-C90057  --Begin
         IF cl_null(l_asj.asj09) THEN LET l_asj.asj09 = 'N' END IF
         #No.TQC-C90057  --End  
         INSERT INTO asj_file VALUES (l_asj.*)
         UPDATE asy_file SET asy09 = l_asj.asj01 
          WHERE asy01 = tm.asx01
            AND asy01 = tm.asx02
            AND asy03 = tm.asx03
            AND asy031 = tm.asx031
         IF SQLCA.SQLCODE AND SQLCA.SQLERRD[3]=0  THEN
            CALL cl_err3("upd","asy_file",l_asj.asj01,'',SQLCA.sqlcode,"","upd asy_file",1)
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
  
END FUNCTION

FUNCTION i013_aac01(p_t1)
   DEFINE l_aacacti   LIKE aac_file.aacacti
   DEFINE l_aac11     LIKE aac_file.aac11
   DEFINE p_t1        LIKE aac_file.aac01

   LET g_errno = ' '
   SELECT aacacti INTO l_aacacti FROM aac_file
    WHERE aac01 = p_t1

   CASE  WHEN SQLCA.SQLCODE = 100  LET g_errno = 'agl-035'   
         WHEN l_aacacti = 'N'      LET g_errno = 'agl-321'
         WHEN l_aac11<>'Y'         LET g_errno = 'agl-322'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
#--No:FUN-B90088--add-end---

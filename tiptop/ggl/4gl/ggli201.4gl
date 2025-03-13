# Prog. Version..: '5.30.06-13.04.22(00004)'     #
#
# Pattern name...: ggli201.4gl
# Descriptions...: 合併報表關係人交易維護作業
# Date & Author..: 07/05/21 By Sarah
# Modify.........: No:FUN-750078 07/05/21 By Sarah 新增"合併報表關係人交易維護作業"
# Modify.........: No:FUN-750051 07/05/24 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No:TQC-760100 07/06/13 By Sarah 單身交易科目無法輸入
# Modify.........: No:FUN-770086 07/07/26 By kim 合併報表新增功能
# Modify.........: No:FUN-780068 07/10/09 By Sarah 單身刪除的WHERE條件句,asw04的部份應該用g_asw_t.asw04
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-910001 09/05/19 By lutingting 由11區追單,1.串ash_file時,增加串ash13(族群代號)=asw03                                       
#                                                  2.開窗CALL q_ash1需多傳arg3(族群代號),arg4(合并報表帳別)  
# Modify.........: NO.FUN-930059 09/05/19 BY jamie asw031上層公司開窗/欄位輸入檢查，應以族群編號asw03為key，只能輸入/開窗存在agli002單頭asa02公司
# Modify.........: NO.FUN-930074 09/05/19 BY ve007 asw_pk add asw11
# Modify.........: No:FUN-920095 09/05/19 By jan   1.單身asw09開窗以來源公司asw07抓取agli009設定營運中心+合併後帳別aaz641 開窗合併後會科資料
#                                                  2.AFTER FIELD asw09檢核會科正確羅輯亦同第1點
#                                                  3.會科名稱aag02要一併顯示
#                                                  4.單身asw10此欄位目前並沒有用到，予以隱藏
# Modify.........: No:FUN-910002 09/05/19 By lutingting由11區追單,1.當交易類別=3.有形資產時,單身asw10(交易科目)才卡不可空白                        
#                                                  2.順流時,asw16=asw14,逆、側流時,asw16=asw14*asw15/100 
# Modify.........: NO.FUN-950051 09/05/22 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查快科方式修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-B40104 11/05/15 By lutingting 合並報表回收產品
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70005 11/07/01 By yinhy 點擊“單身”系統報錯“(-1213) 1 字元轉換至數字程序失敗.”，進入項次後回車會清空“來源幣種”和“交易金額”。
# Modify.........: No.FUN-B60159 11/07/06 By lutingting 若已產生調整憑證,刪除時需報錯
# Modify.........: No.FUN-B80135 11/08/26 By minpp    相關日期欄位不可小於關帳日期
# Modify.........: No:FUN-B90088 11/09/14 By xuxz   單身“幣種”放到單頭，DB跨庫改為用營運中心跨庫，增加action“未實現損益比率
# Modify.........: 11/10/10  By xuxz 追单至此
# Modify.........: NO.FUN-BB0036 11/11/21 By lilingyu 合併報表移植
# Modify.........: No:FUN-C80046 12/08/14 By bart 複製後停在新料號畫面
# Modify.........: No.TQC-C90057 12/09/11 By Carrier asj09/asj11/asj12空时赋值
# Modify.........: No:FUN-D30032 13/04/02 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE 
    g_asw01          LIKE asw_file.asw01,      #FUN-750078
    g_asw02          LIKE asw_file.asw02,  
    g_asw03          LIKE asw_file.asw03,  
    g_asw031         LIKE asw_file.asw031,  #FUN-770086    #FUN-BB0036
    g_asw11          LIKE asw_file.asw11,   #No:FUN-B90088 add "單身幣種放到單頭"
    g_asw18          LIKE asw_file.asw18,  
    g_asw01_t        LIKE asw_file.asw01, 
    g_asw02_t        LIKE asw_file.asw02, 
    g_asw03_t        LIKE asw_file.asw03, 
    g_asw031_t       LIKE asw_file.asw031,  #FUN-770086
    g_asw18_t        LIKE asw_file.asw18,  
    g_asw11_t        LIKE asw_file.asw11,   #No:FUN-B90088 add "單身幣種放到單頭"
    g_asw            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        asw04        LIKE asw_file.asw04,      #項次
        asw05        LIKE asw_file.asw05,      #交易性質
        asw06        LIKE asw_file.asw06,      #交易類別
        asw07        LIKE asw_file.asw07,      #來源公司
        asg02_s      LIKE asg_file.asg02,      #公司名稱
        asw08        LIKE asw_file.asw08,      #交易公司
        asg02_t      LIKE asg_file.asg02,      #公司名稱
        asw09        LIKE asw_file.asw09,      #帳列科目
        aag02_a      LIKE aag_file.aag02,      #科目名稱
        asw10        LIKE asw_file.asw10,      #交易科目
        aag02_t      LIKE aag_file.aag02,      #科目名稱
        #asw11        LIKE asw_file.asw11,      #來源幣別 #No:FUN-B90088 mark
        asw19        LIKE asw_file.asw19 ,      #未實現損益科目 #FUN-B90088 add
        aag02_s      LIKE aag_file.aag02,      #科目名稱 #FUN-B90088 add
        asw12        LIKE asw_file.asw12,      #交易金額
        asw13        LIKE asw_file.asw13,      #交易損益
        asw131       LIKE asw_file.asw131,     #已實現損益  #FUN-770086
        asw14        LIKE asw_file.asw14,      #未實現損益
        asw15        LIKE asw_file.asw15,      #持股比率
        asw16        LIKE asw_file.asw16,      #分配未實現損益
        asw17        LIKE asw_file.asw17       #來源單號    #FUN-770086
        
                     END RECORD,
    g_asw_t          RECORD                 #程式變數 (舊值)
        asw04        LIKE asw_file.asw04,      #項次
        asw05        LIKE asw_file.asw05,      #交易性質
        asw06        LIKE asw_file.asw06,      #交易類別
        asw07        LIKE asw_file.asw07,      #來源公司
        asg02_s      LIKE asg_file.asg02,      #公司名稱
        asw08        LIKE asw_file.asw08,      #交易公司
        asg02_t      LIKE asg_file.asg02,      #公司名稱
        asw09        LIKE asw_file.asw09,      #帳列科目
        aag02_a      LIKE aag_file.aag02,      #科目名稱
        asw10        LIKE asw_file.asw10,      #交易科目
        aag02_t      LIKE aag_file.aag02,      #科目名稱
        #asw11        LIKE asw_file.asw11,      #來源幣別 #No:FUN-B90088 mark
        asw19        LIKE asw_file.asw19 ,      #未實現損益科目 #FUN-B90088 add
        aag02_s      LIKE aag_file.aag02,       #科目名稱#FUN-B90088 add
        asw12        LIKE asw_file.asw12,      #交易金額
        asw13        LIKE asw_file.asw13,      #交易損益
        asw131       LIKE asw_file.asw131,     #已實現損益  #FUN-770086
        asw14        LIKE asw_file.asw14,      #未實現損益
        asw15        LIKE asw_file.asw15,      #持股比率
        asw16        LIKE asw_file.asw16,      #分配未實現損益
        asw17        LIKE asw_file.asw17       #來源單號    #FUN-770086

                     END RECORD,
    i                LIKE type_file.num5,
    g_wc,g_sql,g_wc2 STRING,             
    g_rec_b          LIKE type_file.num5,      #單身筆數
    l_ac             LIKE type_file.num5       #目前處理的ARRAY CNT

#主程式開始
DEFINE   g_forupd_sql   STRING                 #SELECT ... FOR UPDATE NOWAIT SQL       
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
DEFINE   g_dbs_asg03    LIKE type_file.chr21   #FUN-920095 add
#DEFINE   g_aaz641       LIKE aaz_file.aaz641    #FUN-920095 add   #FUN-B4104
DEFINE   g_asz01        LIKE asz_file.asz01
DEFINE   p_row,p_col    LIKE type_file.num5
DEFINE   g_asz          RECORD LIKE asz_file.*
#FUN-B80135--add--str--
DEFINE g_aaa07          LIKE aaa_file.aaa07
DEFINE g_year           LIKE  type_file.chr4
DEFINE g_month          LIKE  type_file.chr2
#FUN-B80135--add—end--


MAIN
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #輸入的方式: 不打轉
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET i=0
   LET g_asw01_t = NULL
   LET g_asw02_t = NULL
   LET g_asw03_t = NULL
   LET g_asw031_t = NULL #FUN-770086
   LET g_asw18_t = NULL  
   LET p_row = 4 LET p_col = 12

   OPEN WINDOW i012_w AT p_row,p_col WITH FORM "ggl/42f/ggli201" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   
   #FUN-B80135--add--str--
   SELECT aaa07 INTO g_aaa07 FROM aaa_file,asz_file
    WHERE aaa01 = asz01 AND asz00 = '0'
   LET g_year = YEAR(g_aaa07)
   LET g_month= MONTH(g_aaa07)
   #FUN-B80135--add—end--

   SELECT * INTO g_asz.* FROM asz_file WHERE asz00 = '0'
   #CALL cl_set_comp_visible("asw10,aag02_t", FALSE)   #FUN-920095 add
   CALL cl_set_comp_visible("asw05,asw15,asw16,asw17", FALSE)

   CALL i012_menu()
   CLOSE FORM i012_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

#QBE 查詢資料
FUNCTION i012_cs()
   CLEAR FORM                            #清除畫面
   CALL g_asw.clear()
   
   #螢幕上取條件
   INITIALIZE g_asw01  TO NULL      #No.FUN-750051
   INITIALIZE g_asw02  TO NULL      #No.FUN-750051
   INITIALIZE g_asw03  TO NULL      #No.FUN-750051
   INITIALIZE g_asw031 TO NULL      #FUN-770086
   INITIALIZE g_asw18  TO NULL      
  
   CONSTRUCT g_wc ON asw01,asw02,asw03,asw031,asw18,asw11,asw04,asw05,asw06,asw07, #FUN-770086  #No:FUN-B90088 add asw11
                     asw08,asw09,asw10,asw19,asw12,asw13,asw131,asw14, #FUN-770086   #No:FUN-B90088 del  asw11  add asw19
                     asw15,asw16,asw17                               #FUN-770086 
                FROM asw01,asw02,asw03,asw031,asw18,asw11,s_asw[1].asw04,s_asw[1].asw05, #FUN-770086 #No:FUN-B90088 add asw11
                     s_asw[1].asw06,s_asw[1].asw07,s_asw[1].asw08,
                     s_asw[1].asw09,s_asw[1].asw10,s_asw[1].asw19,  #No:FUN-B90088 del  s_asw[1].asw11  add asw19
                     s_asw[1].asw12,s_asw[1].asw13,s_asw[1].asw131,
                     s_asw[1].asw14, #FUN-770086
                     s_asw[1].asw15,s_asw[1].asw16,s_asw[1].asw17  #FUN-770086
                        
      #No:FUN-580031 --start--     HCN
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      #No:FUN-580031 --end--       HCN

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asw03)     #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asw03 
                 NEXT FIELD asw03
            #FUN-770086...................beatk
            WHEN INFIELD(asw031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 #LET g_qryparam.form ="q_asg"      #FUN-930059 mark
                 LET g_qryparam.form ="q_asa3"     #FUN-930059 mod
                 LET g_qryparam.arg1 =g_asw03      #FUN-930059 mod
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asw031
                 NEXT FIELD asw031
            #FUN-770086...................end
            WHEN INFIELD(asw07)     #來源公司 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asg1"
                 CALL GET_FLDBUF(asw03) RETURNING g_asw03
                 LET g_qryparam.arg1 = g_asw03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asw07 
                 NEXT FIELD asw07
            WHEN INFIELD(asw08)     #交易公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_asg1"
                 CALL GET_FLDBUF(asw03) RETURNING g_asw03
                 LET g_qryparam.arg1 = g_asw03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO asw08 
                 NEXT FIELD asw08
            WHEN INFIELD(asw09)     #帳列科目
                 #FUN-920095---mod---str---
                #CALL cl_init_qry_var()
                #LET g_qryparam.state = "c"
                #LET g_qryparam.form ="q_ash1"
                #CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asw[1].asw09,'23',g_asz01)   #FUN-B40104 aaz641->asz01 #No:FUN-B90088 g_dbs_asg03-->g_plant_new
                      RETURNING g_qryparam.multiret                  
                #LET g_aaz.aaz86=g_qryparam.multiret                                      
                #FUN-920095---mod---end---
                 DISPLAY g_qryparam.multiret TO asw09 
                 NEXT FIELD asw09
            WHEN INFIELD(asw10)     #交易科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ash1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asw10 
                 NEXT FIELD asw10
            #--No:FUN-B90088 --add--str--
            WHEN INFIELD(asw19)     #交易科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_ash1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO asw19
                 NEXT FIELD asw19
            #--No:FUN-B90088 --add--end---
            #--No:FUN-B90088 --mark--str--
            #WHEN INFIELD(asw11)     #交易幣別
            #     CALL cl_init_qry_var()
            #     LET g_qryparam.state = "c"
            #     LET g_qryparam.form ="q_azi"
            #     CALL cl_create_qry() RETURNING g_qryparam.multiret
            #     DISPLAY g_qryparam.multiret TO asw11 
            #    NEXT FIELD asw11
            #--No:FUN-B90088--mark--end---
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
    
      #No:FUN-580031 --start--     HCN
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No:FUN-580031 --end--       HCN
   END CONSTRUCT
   IF INT_FLAG THEN RETURN END IF

   LET g_sql= "SELECT UNIQUE asw01,asw02,asw03,asw031,asw18 FROM asw_file ", #FUN-770086   
              " WHERE ", g_wc CLIPPED,
              " ORDER BY asw01,asw02,asw03,asw031,asw18"  #FUN-770086 
   PREPARE i012_prepare FROM g_sql        #預備一下
   DECLARE i012_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i012_prepare

   LET g_sql_tmp = "SELECT UNIQUE asw01,asw02,asw03,asw031,asw18 ",  #FUN-770086 
                   "  FROM asw_file ",
                   " WHERE ", g_wc CLIPPED,
                   " INTO TEMP x "
   DROP TABLE x
   PREPARE i012_pre_x FROM g_sql_tmp
   EXECUTE i012_pre_x

   LET g_sql = "SELECT COUNT(*) FROM x"
   PREPARE i012_precnt FROM g_sql
   DECLARE i012_cnt CURSOR FOR i012_precnt
END FUNCTION

FUNCTION i012_menu()

   WHILE TRUE
      CALL i012_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN
               CALL i012_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i012_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i012_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i012_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i012_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               CALL i012_v()
            ELSE
               LET g_action_choice = NULL
            END IF 

         WHEN "qry_sheet"    #查詢調整分錄#
            IF cl_chk_act_auth() THEN
               LET g_msg="gglt1101 '",g_asz01,"' '",g_asw18,"' "
              CALL cl_cmdrun_wait(g_msg CLIPPED)
            END IF
        #--No:FUN-B90088--add--str--
        WHEN "rate" 
            IF cl_chk_act_auth() THEN
               CALL i012_rate_batch()
            END IF
        #--No:FUN-B90088--add--end--
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i012_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "related_document" 
            IF cl_chk_act_auth() THEN
               IF g_asw01 IS NOT NULL THEN
                  LET g_doc.column1 = "asw01"
                  LET g_doc.column2 = "asw02"
                  LET g_doc.column3 = "asw03"
                  LET g_doc.value1 = g_asw01
                  LET g_doc.value2 = g_asw02
                  LET g_doc.value3 = g_asw03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_asw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION

FUNCTION i012_a()
   IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_asw.clear()
   INITIALIZE g_asw01 LIKE asw_file.asw01         #DEFAULT 設定
   INITIALIZE g_asw02 LIKE asw_file.asw02         #DEFAULT 設定
   INITIALIZE g_asw03 LIKE asw_file.asw03         #DEFAULT 設定
   INITIALIZE g_asw031 LIKE asw_file.asw031         #DEFAULT 設定  #FUN-770086
   INITIALIZE g_asw18  LIKE asw_file.asw18          
   CALL cl_opmsg('a')

   WHILE TRUE
      CALL i012_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_asw01=NULL
         LET g_asw02=NULL
         LET g_asw03=NULL
         LET g_asw031=NULL  #FUN-770086
         LET g_asw18 = NULL #luttb 101215
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      # KEY 不可空白
      IF cl_null(g_asw01) OR cl_null(g_asw02) OR 
         cl_null(g_asw03) OR cl_null(g_asw031) THEN  #FUN-770086
         CONTINUE WHILE
      END IF

      CALL g_asw.clear()
      LET g_rec_b = 0 
      CALL i012_b()                              #輸入單身
      LET g_asw01_t = g_asw01                    #保留舊值
      LET g_asw02_t = g_asw02                    #保留舊值
      LET g_asw03_t = g_asw03                    #保留舊值
      LET g_asw031_t = g_asw031                    #保留舊值  #FUN-770086
      LET g_asw18_t  = g_asw18                     #luttb 101215
      EXIT WHILE
   END WHILE
END FUNCTION

FUNCTION i012_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入
       l_n1,l_n        LIKE type_file.num5,    
       p_cmd           LIKE type_file.chr1      #a:輸入 u:更改
      #l_acti          LIKE asg_file.asgacti   #FUN-770086 #FUN-920095 mark
    
   DISPLAY g_asw01,g_asw02,g_asw03,g_asw031,g_asw18 TO asw01,asw02,asw03,asw031,asw18  #FUN-770086 #luttb 101215

   INPUT g_asw01,g_asw02,g_asw03,g_asw031 FROM asw01,asw02,asw03,asw031  #FUN-770086
      AFTER FIELD asw01   #年度
         IF cl_null(g_asw01) OR g_asw01 = 0 THEN
            CALL cl_err(g_asw01,'afa-370',0)
            NEXT FIELD asw01
         END IF
         #No.FUN-B80135--add--str--
         IF NOT cl_null(g_asw01) THEN
            IF g_asw01 < 0 THEN
               CALL cl_err(g_asw01,'apj-035',0)
               NEXT FIELD asw01
            END IF 
            IF g_asw01<g_year THEN
               CALL cl_err(g_asw01,'axm-164',0)
               NEXT FIELD asw01
            END IF
            IF g_asw01=g_year AND g_asw02<= g_month THEN
               CALL cl_err(g_asw02,'axm-164',0)
               NEXT FIELD asw02
            END IF
         END IF 
 
         #No.FUN-B80135--add—end--

        #Mark by sam 20101217
        #CALL s_get_bookno(g_asw01) RETURNING g_flag,g_bookno1,g_bookno2
        #IF g_flag = '1' THEN
        #   CALL cl_err(g_asw01,'aoo-081',1)
        #   NEXT FIELD asw01
        #END IF
        #End Mark
      AFTER FIELD asw02   #期別
         IF cl_null(g_asw02) OR g_asw02 < 0 OR g_asw02 > 12 THEN
            CALL cl_err(g_asw02,'agl-013',0)
            NEXT FIELD asw02
         END IF
         #No.FUN-B80135--add--str--
          IF NOT cl_null(g_asw02) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_asw01
            IF g_azm.azm02 = 1 THEN
               IF g_asw02 > 12 OR g_asw02 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD asw02
               END IF
            ELSE
               IF g_asw02 > 13 OR g_asw02 < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD asw02
               END IF
            END IF
            IF NOT cl_null(g_asw01) AND g_asw01=g_year
               AND g_asw02<=g_month THEN
               CALL cl_err(g_asw02,'axm-164',0)
               NEXT FIELD asw02
            END IF
         END IF
         #No.FUN-B80135--add—end--


      AFTER FIELD asw03   #族群代號
         IF NOT cl_null(g_asw03) THEN
            SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = g_asw03
            IF l_n = 0 THEN 
               CALL cl_err3("sel","asa_file",g_asw03,"","agl-117","","",1)
               NEXT FIELD asw03
            #--No:FUN-B90088 --add--str---
            ELSE
               SELECT asg06 INTO g_asw11 FROM asg_file,asa_file
                WHERE asa02=asg01 AND asa04='Y'
                  AND asa01=g_asw03
               DISPLAY g_asw11 TO asw11
           #--No:FUN-B90088 --add--end---
            END IF
         END IF

      #FUN-770086.................beatk
      AFTER FIELD asw031   #上層公司
#         IF NOT i012_chk_asw031(g_asw031) THEN
#            NEXT FIELD asw031 
#         END IF
#         CALL i012_set_asg02(g_asw031)  #FUN-770086
#      #FUN-770086.................end
        #FUN-930059---add---str---
         IF NOT cl_null(g_asw031) THEN

            SELECT count(*) INTO l_n FROM asa_file
             WHERE asa01=g_asw03 AND asa02=g_asw031

            IF l_n = 0  THEN
               CALL cl_err(g_asw031,'agl-118',0)
               LET g_asw031 = g_asw031_t
               DISPLAY BY NAME g_asw031
               NEXT FIELD asw031
            END IF

            CALL i012_set_asg02(g_asw031,g_asw03)  #FUN-770086   #FUN-950051 add asw03
         END IF
        #FUN-930059---add---end---

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asw03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = g_asw03
               CALL cl_create_qry() RETURNING g_asw03
               DISPLAY g_asw03 TO asw03 
               NEXT FIELD asw03
            #FUN-770086...................beatk
            WHEN INFIELD(asw031)    #上層公司
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_asg"      #FUN-930059 mark
                 LET g_qryparam.form ="q_asa3"     #FUN-930059 mod
                 LET g_qryparam.arg1 =g_asw03      #FUN-930059 mod
                 CALL cl_create_qry() RETURNING g_asw031
                 DISPLAY g_asw031 TO asw031
                 NEXT FIELD asw031
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
FUNCTION i012_q()

   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_asw01 TO NULL
   INITIALIZE g_asw02 TO NULL
   INITIALIZE g_asw03 TO NULL
   INITIALIZE g_asw031 TO NULL #FUN-770086
   INITIALIZE g_asw18  TO NULL #luttb 101215
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_asw.clear()

   CALL i012_cs()                           #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0             
      RETURN                       
   END IF                           

   OPEN i012_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_asw01 TO NULL
      INITIALIZE g_asw02 TO NULL
      INITIALIZE g_asw03 TO NULL
      INITIALIZE g_asw031 TO NULL #FUN-770086
      INITIALIZE g_asw18 TO NULL  #luttb 101215
      INITIALIZE g_asw11 TO NULL #No:FUN-B90088 add 
   ELSE
      OPEN i012_cnt
      FETCH i012_cnt INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL i012_fetch('F')                 # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION

#處理資料的讀取
FUNCTION i012_fetch(p_flag)
DEFINE p_flag       LIKE type_file.chr1,       #處理方式
       l_abso       LIKE type_file.num10       #絕對的筆數

   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     i012_bcs INTO g_asw01,g_asw02,g_asw03,g_asw031,g_asw18 #FUN-770086  #luttb 101215
      WHEN 'P' FETCH PREVIOUS i012_bcs INTO g_asw01,g_asw02,g_asw03,g_asw031,g_asw18 #FUN-770086  #luttb 101215
      WHEN 'F' FETCH FIRST    i012_bcs INTO g_asw01,g_asw02,g_asw03,g_asw031,g_asw18 #FUN-770086  #luttb 101215
      WHEN 'L' FETCH LAST     i012_bcs INTO g_asw01,g_asw02,g_asw03,g_asw031,g_asw18 #FUN-770086  #luttb 101215
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
          FETCH ABSOLUTE g_jump i012_bcs INTO g_asw01,g_asw02,g_asw03,g_asw031,g_asw18 #FUN-770086 #luttb 101215
          LET g_no_ask = FALSE
   END CASE

   SELECT UNIQUE asw01,asw02,asw03,asw031  #FUN-770086
     FROM asw_file 
    WHERE asw01 = g_asw01 AND asw02 = g_asw02 AND asw03 = g_asw03 
      AND asw031 = g_asw031 #FUN-770086
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err3("sel","asw_file",g_asw01,g_asw02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_asw01 TO NULL
      INITIALIZE g_asw02 TO NULL
      INITIALIZE g_asw03 TO NULL
      INITIALIZE g_asw031 TO NULL #FUN-770086
      INITIALIZE g_asw18 TO NULL  #luttb
   ELSE
     #Mark by sam 20101217
     #CALL s_get_bookno(g_asw01) RETURNING g_flag,g_bookno1,g_bookno2
     #IF g_flag = '1' THEN
     #   CALL cl_err(g_asw01,'aoo-081',1)
     #END IF
     #End Mark
      CALL i012_show()
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
FUNCTION i012_show()
   #--No:FUN-B90088 --add--str---

   SELECT asg06 INTO g_asw11 FROM asg_file,asa_file
    WHERE asa02=asg01 AND asa04='Y'
      AND asa01=g_asw03

  #--No:FUN-B90088 --add--end---
   DISPLAY g_asw01,g_asw02,g_asw03,g_asw031,g_asw18,g_asw11 TO asw01,asw02,asw03,asw031,asw18,asw11  #單頭  #FUN-770086 #luttb #No:FUN-B90088 add asw11
   CALL i012_set_asg02(g_asw031,g_asw03)  #FUN-770086   #FUN-950051 add asw03
   CALL i012_b_fill(g_wc)                                 #單身
   CALL cl_show_fld_cont() 

END FUNCTION


FUNCTION i012_b_fill(p_wc)
#DEFINE p_wc       LIKE type_file.chr1000
DEFINE  p_wc       STRING             #NO.FUN-910082
DEFINE l_asg03     LIKE asg_file.asg03        #FUN-920095 add
DEFINE l_asa09     LIKE asa_file.asa09        #FUN-950051 add
   LET g_sql = "SELECT asw04,asw05,asw06,asw07,'',asw08,'',",
               "       asw09,'',asw10,'',asw19,'',asw12,asw13,asw131,",   #No:FUN-B90088 del asw11 add asw19,''
               "asw14,asw15,asw16,asw17 ", #FUN-770086
               "  FROM asw_file ",
               " WHERE asw01 =  ",g_asw01 CLIPPED,
               "   AND asw02 =  ",g_asw02 CLIPPED,
               "   AND asw03 = '",g_asw03 CLIPPED,"'",
               "   AND asw031= '",g_asw031 CLIPPED,"'", #FUN-770086
               "   AND ",p_wc CLIPPED ,
               " ORDER BY asw04"
   PREPARE i012_prepare2 FROM g_sql      #預備一下
   DECLARE asw_cs CURSOR FOR i012_prepare2

   CALL g_asw.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   #FUN-950051--mod--str                                                                                                            
   SELECT asa09 INTO l_asa09 FROM asa_file                                                                                          
    WHERE asa01 = g_asw03   #群族                                                                                                   
      AND asa02 = g_asw031  #公司編號                                                                                               
   IF l_asa09 = 'Y' THEN                                                                                                            
   #FUN-950051--mod--end 
      #FUN-920095---add---str---
      SELECT asg03 INTO l_asg03    
        FROM asg_file
       WHERE asg01 = g_asw031 

      LET g_plant_new = l_asg03      #營運中心
      CALL s_getdbs()  
      LET g_dbs_asg03 = g_dbs_new    #所屬DB  

      #LET g_sql = "SELECT asz01 FROM ",g_dbs_asg03,"asz_file", #No:FUN-B90088 mark
      LET g_sql = "SELECT asz01 FROM ",cl_get_target_table(g_plant_new,'asz_file'),#No:FUN-B90088 add
                  " WHERE asz00 = '0'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #No:FUN-B90088 add
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B90088 add
      PREPARE i012_pre_3 FROM g_sql
      DECLARE i012_cur_3 CURSOR FOR i012_pre_3
      OPEN i012_cur_3
      FETCH i012_cur_3 INTO g_asz01    #合併後帳別
     #FUN-920095---add---end---
   #FUN-950051--mod--str
   ELSE
     LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)   #當前DB
     SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'
   END IF 
   #FUN-950051--mod--end

   FOREACH asw_cs INTO g_asw[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT asg02 INTO g_asw[g_cnt].asg02_s FROM asg_file   #來源公司名稱
       WHERE asg01=g_asw[g_cnt].asw07
      SELECT asg02 INTO g_asw[g_cnt].asg02_t FROM asg_file   #交易公司名稱
       WHERE asg01=g_asw[g_cnt].asw08
      #FUN-920095---mod---str---
     #SELECT aag02 INTO g_asw[g_cnt].aag02_a FROM aag_file   #帳列科目名稱
     # WHERE aag01=g_asw[g_cnt].asw09

      LET g_sql = "SELECT aag02 ",
                  #"  FROM ",g_dbs_asg03,"aag_file ",  #No:FUN-B90088 mark
                  "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),#No:FUN-B90088 add
                  " WHERE aag00 = '",g_asz01,"'",                
                  "   AND aag01 = '",g_asw[g_cnt].asw09,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #No:FUN-B90088 add
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B90088 add
      PREPARE i012_pre_2 FROM g_sql
      DECLARE i012_cur_2 CURSOR FOR i012_pre_2
      OPEN i012_cur_2
      FETCH i012_cur_2 INTO g_asw[g_cnt].aag02_a 
                                                                       
      IF SQLCA.sqlcode  THEN LET g_asw[g_cnt].aag02_a = '' END IF
      
     #FUN-920095---mod---end---
      SELECT aag02 INTO g_asw[g_cnt].aag02_t FROM aag_file   #交易科目名稱
       WHERE aag01=g_asw[g_cnt].asw10
    #FUN-B90088---add--str
     LET g_sql = "SELECT aag02 ",
                  #"  FROM ",g_dbs_asg03,"aag_file ",  #No:FUN-B90088 mark
                  "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),#No:FUN-B90088 add
                  " WHERE aag00 = '",g_asz01,"'",                
                  "   AND aag01 = '",g_asw[g_cnt].asw19,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #No:FUN-B90088 add
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B90088 add
      PREPARE i012_pre_21 FROM g_sql
      DECLARE i012_cur_21 CURSOR FOR i012_pre_21
      OPEN i012_cur_21
      FETCH i012_cur_21 INTO g_asw[g_cnt].aag02_s 
                                                                       
      IF SQLCA.sqlcode  THEN LET g_asw[g_cnt].aag02_s = '' END IF
    #FUN-B90088--add--end--
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_asw.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1

   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION

FUNCTION i012_r()
DEFINE l_asw18 LIKE asw_file.asw18

   IF s_shut(0) THEN RETURN END IF
   IF g_asw01 IS NULL OR g_asw02 IS NULL OR g_asw03 IS NULL 
      OR g_asw031 IS NULL THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN 
   END IF
   #FUN-B60159--add--str--
   SELECT asw18 INTO l_asw18 FROM asw_file WHERE asw01=g_asw01 AND asw02=g_asw02
      AND asw03=g_asw03 AND asw031=g_asw031   
   IF NOT cl_null(l_asw18) THEN CALL cl_err('','agl-355',0) RETURN END IF 
   #FUN-B60159--add--end
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "asw01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "asw02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "asw03"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_asw01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_asw02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_asw03       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM asw_file WHERE asw01=g_asw01 AND asw02=g_asw02 
                             AND asw03=g_asw03 AND asw031=g_asw031 #FUN-770086
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
         CALL cl_err3("del","asw_file",g_asw01,g_asw03,SQLCA.sqlcode,"","",1)
      ELSE 
         CLEAR FORM
         CALL g_asw.clear()
         LET g_sql = "SELECT UNIQUE asw01,asw02,asw03,asw031 ",
                     "FROM asw_file INTO TEMP y" #FUN-770086
         DROP TABLE y
         PREPARE i012_pre_y FROM g_sql
         EXECUTE i012_pre_y
         LET g_sql = "SELECT COUNT(*) FROM y"
         PREPARE i012_precnt2 FROM g_sql
         DECLARE i012_cnt2 CURSOR FOR i012_precnt2
         OPEN i012_cnt2
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE i012_bcs
            CLOSE i012_cnt2 
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH i012_cnt2 INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i012_bcs
            CLOSE i012_cnt2 
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i012_bcs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i012_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i012_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION

#單身
FUNCTION i012_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT
       l_n             LIKE type_file.num5,     #檢查重複用
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否
       p_cmd           LIKE type_file.chr1,     #處理狀態
       l_allow_insert  LIKE type_file.num5,     #可新增否
       l_allow_delete  LIKE type_file.num5,     #可刪除否
       l_asg05         LIKE asg_file.asg05      #帳別

   #FUN-770086
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')

   LET g_forupd_sql = "SELECT asw04,asw05,asw06,asw07,'',asw08,'',asw09,'', ",
                      #"       asw10,'','',asw11,asw12,asw13,asw131,asw14,asw15,",
                      "       asw10,'',asw19,'',asw12,asw13,asw131,asw14,asw15,",      #No.TQC-B70005 去掉一個'' #No:FUN-B90088 del asw11 add asw19,''
                      "       asw16,asw17 ",
                      "  FROM asw_file ",
                      " WHERE asw01 = ? AND asw02 = ? ",
                      "   AND asw03 = ? AND asw031 = ? AND asw04 = ? AND asw11 = ? FOR UPDATE " 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i012_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

   LET l_ac_t = 0
   #FUN-770086
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")

   INPUT ARRAY g_asw WITHOUT DEFAULTS FROM s_asw.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #FUN-770086
         CALL cl_set_comp_entry("asw04, asw05, asw06, asw07, asw08,
                                 asw09, asw10, asw19, asw12, asw13, #No:FUN-B90088 del asw11 add asw19
                                 asw14, asw15, asw16, asw17",TRUE)

      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()

         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_asw_t.* = g_asw[l_ac].*  #BACKUP
            OPEN i012_bcl USING g_asw01,g_asw02,g_asw03,g_asw031,
                                g_asw[l_ac].asw04, #FUN-770086
                                g_asw11  #No:FUN-B90088 add asw11
                                #g_asw[l_ac].asw11  #FUN-930074 #No:FUN-B90088 mark asw11
            IF STATUS THEN
               CALL cl_err("OPEN i012_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i012_bcl INTO g_asw[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_asw_t.asw04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i012_asg(p_cmd,g_asw03,g_asw[l_ac].asw07,"s")             #來源公司名稱
               CALL i012_asg(p_cmd,g_asw03,g_asw[l_ac].asw08,"t")             #交易公司名稱
               #FUN-920095---mod---str---
              #CALL i012_ash(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw09,"a")   #帳列科目名稱
              #CALL i012_ash(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw10,"t")   #交易科目名稱   #TQC-760100 modify
               CALL i012_ashh(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw09,"a")   #帳列科目名稱
               CALL i012_ashh(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw10,"t")   #交易科目名稱   #TQC-760100 modify
               CALL i012_ashh(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw19,"s")   #未實現損益科目名稱 #No：FUN-B90088 add 
              #FUN-920095---mod---end---
            END IF
            CALL cl_show_fld_cont() 
         END IF

      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_asw[l_ac].* TO NULL   
         LET g_asw_t.* = g_asw[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()   
         NEXT FIELD asw04

      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_asw[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_asw[l_ac].* TO s_asw.*
            CALL g_asw.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO asw_file(asw01,asw02,asw03,asw031,asw04,asw05,asw06,asw07, #FUN-770086
                              asw08,asw09,asw10,asw19,asw11,asw12,asw13,asw131, #FUN-B90088
                              #asw14, #FUN-770086
                              asw15,asw16,asw17,aswlegal)  #FUN-770086   #luttb add asw19
                       VALUES(g_asw01,g_asw02,g_asw03,g_asw031,
                              g_asw[l_ac].asw04, #FUN-770086
                              g_asw[l_ac].asw05,g_asw[l_ac].asw06,
                              g_asw[l_ac].asw07,g_asw[l_ac].asw08,
                              g_asw[l_ac].asw09,g_asw[l_ac].asw10,
                              g_asw[l_ac].asw19,  #FUN-B90088
                              g_asw11,g_asw[l_ac].asw12,  #No:FUN-B90088 change g_asw[l_ac].asw11-->g_asw11
                              g_asw[l_ac].asw13,g_asw[l_ac].asw131,
                             #g_asw[l_ac].asw14, #FUN-770086
                              g_asw[l_ac].asw15,g_asw[l_ac].asw16,
                              g_asw[l_ac].asw17,g_legal) #FUN-770086   #luttb 101221
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","asw_file",g_asw01,g_asw02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE 'INSERT O.K'
         END IF

      BEFORE FIELD asw04                        #default 項次
         IF g_asw[l_ac].asw04 IS NULL OR g_asw[l_ac].asw04 = 0 THEN
            SELECT max(asw04)+1 INTO g_asw[l_ac].asw04
              FROM asw_file
             WHERE asw01 = g_asw01 AND asw02 = g_asw02 AND asw03 = g_asw03
               AND asw031 = g_asw031 #FUN-770086
            IF g_asw[l_ac].asw04 IS NULL THEN
               LET g_asw[l_ac].asw04 = 1
            END IF
         END IF

      AFTER FIELD asw04
         IF NOT cl_null(g_asw[l_ac].asw04) THEN
            IF g_asw[l_ac].asw04 != g_asw_t.asw04 OR g_asw_t.asw04 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM asw_file
                WHERE asw01 = g_asw01 AND asw02 = g_asw02 AND asw03 = g_asw03
                  AND asw031 = g_asw031 #FUN-770086
                  AND asw04 = g_asw[l_ac].asw04
                  AND asw11 = g_asw11   #FUN-930074 #No:FUN-B90088 change g_asw[l_ac].asw11-->g_asw11
               IF l_n > 0 THEN
                  CALL cl_err(g_asw[l_ac].asw04,-239,0)
                  LET g_asw[l_ac].asw04 = g_asw_t.asw04
                  NEXT FIELD asw04
               END IF
            END IF
         END IF

      AFTER FIELD asw05
         IF NOT cl_null(g_asw[l_ac].asw05) THEN
            #IF g_asw[l_ac].asw05 NOT MATCHES '[1234]' THEN   #FUN-930059 mark
            IF g_asw[l_ac].asw05 NOT MATCHES '[123]' THEN    #FUN-930059 mod
               CALL cl_err_msg("","lib-232","1" || "|" || "4",1)
               NEXT FIELD asw05
            END IF
         ELSE
            CALL cl_err(g_asw[l_ac].asw05,"mfg5103",0)
            NEXT FIELD asw05
         END IF

      AFTER FIELD asw06
         IF NOT cl_null(g_asw[l_ac].asw06) THEN
            IF g_asw[l_ac].asw06 NOT MATCHES '[12345]' THEN #FUN-770086
               CALL cl_err_msg("","lib-232","1" || "|" || "5",1) #FUN-770086
               NEXT FIELD asw06
            END IF
            #str FUN-910002 add                                                                                                      
            IF g_asw[l_ac].asw06 = '3' THEN   #3.有型資產                                                                           
               CALL cl_set_comp_required("asw10",TRUE)                                                                              
            ELSE                                                                                                                    
               CALL cl_set_comp_required("asw10",FALSE)                                                                             
            END IF                                                                                                                  
           #end FUN-910002 add 
         ELSE
            CALL cl_err(g_asw[l_ac].asw06,"mfg5103",0)
            NEXT FIELD asw06
         END IF

      AFTER FIELD asw07
         IF NOT cl_null(g_asw[l_ac].asw07) THEN
             #FUN-930059---add---str---
            IF g_asw[l_ac].asw05='1' THEN       #順流-上層公司 
               SELECT count(*) INTO l_n FROM asa_file
                WHERE asa01=g_asw03 AND asa02=g_asw[l_ac].asw07
               
               IF l_n = 0  THEN
                  CALL cl_err(g_asw[l_ac].asw07,'agl-118',0)
                  LET g_asw[l_ac].asw07 = g_asw_t.asw07
                  DISPLAY BY NAME g_asw[l_ac].asw07
                  NEXT FIELD asw07
               END IF
            ELSE  #逆流&側流-下層公司
               SELECT count(*) INTO l_n FROM asb_file
                WHERE asb01=g_asw03 AND asb04=g_asw[l_ac].asw07
               
               IF l_n = 0  THEN
                  CALL cl_err(g_asw[l_ac].asw07,'agl-118',0)
                  LET g_asw[l_ac].asw07 = g_asw_t.asw07
                  DISPLAY BY NAME g_asw[l_ac].asw07
                  NEXT FIELD asw07
               END IF

            END IF 
           #FUN-930059---add---end---
            CALL i012_asg(p_cmd,g_asw03,g_asw[l_ac].asw07,"s")
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asw[l_ac].asw07,g_errno,0)
               LET g_asw[l_ac].asw07 = g_asw_t.asw07
               DISPLAY BY NAME g_asw[l_ac].asw07
               NEXT FIELD asw07
            END IF
         ELSE
            CALL cl_err(g_asw[l_ac].asw07,"mfg5103",0)
            NEXT FIELD asw07
         END IF

      AFTER FIELD asw08
         IF NOT cl_null(g_asw[l_ac].asw08) THEN
            #FUN-930059---add---str---
            IF g_asw[l_ac].asw05='2' THEN       #逆流-上層公司 
               SELECT count(*) INTO l_n FROM asa_file
                WHERE asa01=g_asw03 AND asa02=g_asw[l_ac].asw08
               
               IF l_n = 0  THEN
                  CALL cl_err(g_asw[l_ac].asw08,'agl-118',0)
                  LET g_asw[l_ac].asw08 = g_asw_t.asw08
                  DISPLAY BY NAME g_asw[l_ac].asw08
                  NEXT FIELD asw08
               END IF
            ELSE  #順流&側流-下層公司
               SELECT count(*) INTO l_n FROM asb_file
                WHERE asb01=g_asw03 AND asb04=g_asw[l_ac].asw08
               
               IF l_n = 0  THEN
                  CALL cl_err(g_asw[l_ac].asw08,'agl-118',0)
                  LET g_asw[l_ac].asw08 = g_asw_t.asw08
                  DISPLAY BY NAME g_asw[l_ac].asw08
                  NEXT FIELD asw08
               END IF

            END IF 
           #FUN-930059---add---end---
            CALL i012_asg(p_cmd,g_asw03,g_asw[l_ac].asw08,"t")
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asw[l_ac].asw08,g_errno,0)
               LET g_asw[l_ac].asw08 = g_asw_t.asw08
               DISPLAY BY NAME g_asw[l_ac].asw08
               NEXT FIELD asw08
            END IF
         ELSE
            CALL cl_err(g_asw[l_ac].asw08,"mfg5103",0)
            NEXT FIELD asw08
         END IF

      AFTER FIELD asw09
         IF NOT cl_null(g_asw[l_ac].asw09) THEN
           #CALL i012_ash(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw09,"a")   #FUN-920095 mark
            CALL i012_ashh(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw09,"a")  #FUN-920095 mod
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asw[l_ac].asw09,g_errno,0)
               LET g_asw[l_ac].asw09 = g_asw_t.asw09
               DISPLAY BY NAME g_asw[l_ac].asw09
               NEXT FIELD asw09
            END IF
         ELSE
            CALL cl_err(g_asw[l_ac].asw09,"mfg5103",0)
            NEXT FIELD asw09
         END IF

#str FUN-910002 add                                                                                                             
      BEFORE FIELD asw10                                                                                                            
         IF g_asw[l_ac].asw06 = '3' THEN   #3.有型資產                                                                              
            CALL cl_set_comp_required("asw10",TRUE)                                                                                 
         ELSE                                                                                                                       
            CALL cl_set_comp_required("asw10",FALSE)                                                                                
         END IF                                                                                                                     
     #end FUN-910002 add 

      AFTER FIELD asw10
         IF NOT cl_null(g_asw[l_ac].asw10) THEN
           #CALL i012_ash(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw10,"t")   #TQC-760100 modify #FUN-920095 mark
            CALL i012_ashh(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw10,"t")  #FUN-920095 mod
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asw[l_ac].asw10,g_errno,0)
               LET g_asw[l_ac].asw10 = g_asw_t.asw10
               DISPLAY BY NAME g_asw[l_ac].asw10
               NEXT FIELD asw10
            END IF
         ELSE
            IF g_asw[l_ac].asw06='3' THEN   #FUN-910002 add  
               CALL cl_err(g_asw[l_ac].asw10,"mfg5103",0)
               NEXT FIELD asw10
            END IF   #FUN-910002 add   
         END IF
      #No:FUN-B90088--add-str
      AFTER FIELD asw19
         IF NOT cl_null(g_asw[l_ac].asw19) THEN
           
            CALL i012_ashh(p_cmd,g_asw[l_ac].asw07,g_asw[l_ac].asw19,"s")  
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_asw[l_ac].asw19,g_errno,0)
               LET g_asw[l_ac].asw19 = g_asw_t.asw19
               DISPLAY BY NAME g_asw[l_ac].asw19
               NEXT FIELD asw19
            END IF
         ELSE
            CALL cl_err(g_asw[l_ac].asw09,"mfg5103",0)
            NEXT FIELD asw09
         END IF
    #No:FUN-B90088--add--end--
      #---No:FUN-B90088--mark--str---
      #AFTER FIELD asw11
      #   IF NOT cl_null(g_asw[l_ac].asw11) THEN
      #      SELECT COUNT(*) INTO l_n FROM azi_file
      #       WHERE azi01 = g_asw[l_ac].asw11
      #      IF l_n = 0 THEN
      #         CALL cl_err(g_asw[l_ac].asw11,"agl-109",0)
      #         LET g_asw[l_ac].asw11 = g_asw_t.asw11
      #         NEXT FIELD asw11
      #      END IF
      #   ELSE
      #      CALL cl_err(g_asw[l_ac].asw11,"mfg5103",0)
      #      NEXT FIELD asw11
      #   END IF
      #---No:FUN-B90088--mark--end---
      #FUN-770086................beatk
      AFTER FIELD asw13
         IF l_ac>0 THEN
            IF cl_null(g_asw[l_ac].asw12) THEN #No:FUN-B90088 change asw13->asw12
               LET g_asw[l_ac].asw12=0  #No:FUN-B90088 change asw13->asw12
               DISPLAY BY NAME g_asw[l_ac].asw12  #No:FUN-B90088 change asw13->asw12
            END IF
            IF cl_null(g_asw[l_ac].asw13) THEN
               LET g_asw[l_ac].asw13=0
               DISPLAY BY NAME g_asw[l_ac].asw13
            END IF
            #No:FUN-B90088--add--str
            IF cl_null(g_asw[l_ac].asw14) THEN  
               LET g_asw[l_ac].asw14=0
               DISPLAY BY NAME g_asw[l_ac].asw14
            END IF
            #No:FUN-B90088--add--end--
            LET g_asw[l_ac].asw131=g_asw[l_ac].asw12-g_asw[l_ac].asw13-g_asw[l_ac].asw14
            DISPLAY BY NAME g_asw[l_ac].asw131
           #str FUN-780068 add 10/19
           #IF g_asw[l_ac].asw05!='1' THEN   #FUN-910002 add                                                                        
               #逆、測流時, 
               #分配未實現利益(asw16)=未實現損益(asw14)*持股比率(asw15)/100
           #   LET g_asw[l_ac].asw16=g_asw[l_ac].asw14*g_asw[l_ac].asw15/100
            #str FUN-910002 add                                                                                                      
           #ELSE                                                                                                                    
               #順流時,分配未實現利益(asw16)=未實現損益(asw14)                                                                      
           #   LET g_asw[l_ac].asw16=g_asw[l_ac].asw14                                                                              
           #END IF                                                                                                                  
           #end FUN-910002 add 
           #DISPLAY BY NAME g_asw[l_ac].asw16
           #end FUN-780068 add 10/19
         END IF
      #FUN-770086................end

     #AFTER FIELD asw14
     #   IF NOT cl_null(g_asw[l_ac].asw14) THEN
           #IF g_asw[l_ac].asw05!='1' THEN   #FUN-910002 add  
               #逆、測流時,
               #分配未實現利益(asw16)=未實現損益(asw14)*持股比率(asw15)/100
           #   LET g_asw[l_ac].asw16=g_asw[l_ac].asw14*g_asw[l_ac].asw15/100
            #str FUN-910002 add                                                                                                      
           #ELSE                                                                                                                    
               #順流時,分配未實現利益(asw16)=未實現損益(asw14)                                                                      
           #   LET g_asw[l_ac].asw16=g_asw[l_ac].asw14                                                                              
           #END IF                                                                                                                  
           #end FUN-910002 add 
           #DISPLAY BY NAME g_asw[l_ac].asw16
     #   END IF

     #AFTER FIELD asw15
     #   IF NOT cl_null(g_asw[l_ac].asw15) THEN
     #      IF g_asw[l_ac].asw05!='1' THEN   #FUN-910002 add 
               #逆、測流時,
               #分配未實現利益(asw16)=未實現損益(asw14)*持股比率(asw15)/100
     #         LET g_asw[l_ac].asw16=g_asw[l_ac].asw14*g_asw[l_ac].asw15/100
            #str FUN-910002 add                                                                                                      
     #      ELSE                                                                                                                    
               #順流時,分配未實現利益(asw16)=未實現損益(asw14)                                                                      
     #         LET g_asw[l_ac].asw16=g_asw[l_ac].asw14                                                                              
     #      END IF                                                                                                                  
           #end FUN-910002 add 
     #      DISPLAY BY NAME g_asw[l_ac].asw16
     #   END IF

      BEFORE DELETE                            #是否取消單身
         IF g_asw_t.asw04 > 0 AND g_asw_t.asw04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF

            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 

            DELETE FROM asw_file
             WHERE asw01 = g_asw01 AND asw02 = g_asw02 AND asw03 = g_asw03
               AND asw031= g_asw031        #FUN-770086
               AND asw04 = g_asw_t.asw04   #FUN-780068 mod
               AND asw11 = g_asw11_t   #FUN-930074 #No:FUN-B90088 change g_asw_t.asw11-->g_asw11_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","asw_file",g_asw01,g_asw_t.asw04,SQLCA.sqlcode,"","",1)
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
            LET g_asw[l_ac].* = g_asw_t.*
            CLOSE i012_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_asw[l_ac].asw04,-263,1)
            LET g_asw[l_ac].* = g_asw_t.*
         ELSE
            UPDATE asw_file SET asw04 = g_asw[l_ac].asw04,
                                asw05 = g_asw[l_ac].asw05,
                                asw06 = g_asw[l_ac].asw06,
                                asw07 = g_asw[l_ac].asw07, 
                                asw08 = g_asw[l_ac].asw08, 
                                asw09 = g_asw[l_ac].asw09, 
                                asw10 = g_asw[l_ac].asw10, 
                                #asw11 = g_asw[l_ac].asw11, #No:FUN-B90088 Mark
                                asw19 = g_asw[l_ac].asw19, #NO:FUN-B90088 add
                                asw12 = g_asw[l_ac].asw12, 
                                asw13 = g_asw[l_ac].asw13, 
                                asw131= g_asw[l_ac].asw131,  #FUN-770086
                                asw14 = g_asw[l_ac].asw14, 
                                asw15 = g_asw[l_ac].asw15, 
                                asw16 = g_asw[l_ac].asw16,
                                asw17 = g_asw[l_ac].asw17    #FUN-770086  
             WHERE asw01 = g_asw01 AND asw02 = g_asw02 
               AND asw03 = g_asw03 AND asw031 = g_asw031  #FUN-770086  
               AND asw04 = g_asw_t.asw04
               AND asw11 = g_asw11   #FUN-930074 #No:FUN-B90088 change g_asw_t.asw11-->g_asw11_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","asw_file",g_asw01,g_asw_t.asw04,SQLCA.sqlcode,"","",1)
               LET g_asw[l_ac].* = g_asw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF

      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac                  #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
           #LET g_asw[l_ac].* = g_asw_t.*   #FUN-D30032 Mark
            #FUN-D30032--add--str--
            IF p_cmd = 'u' THEN
               LET g_asw[l_ac].* = g_asw_t.*  
            ELSE
               CALL g_asw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            #FUN-D30032--add--end--
            CLOSE i012_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac                  #FUN-D30032 Add
         LET g_asw_t.* = g_asw[l_ac].*
         CLOSE i012_bcl
         COMMIT WORK
         CALL g_asw.deleteElement(g_rec_b+1)

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asw07)     #來源公司 
                 CALL cl_init_qry_var()
                 #FUN-930059---mod---str---
                #LET g_qryparam.form ="q_asg1"
                 IF g_asw[l_ac].asw05='1' THEN      #順流-上層公司 
                    LET g_qryparam.form ="q_asa3"
                 ELSE 
                    LET g_qryparam.form ="q_asb5"   #逆流&側流-下層公司
                 END IF
                #FUN-930059---mod---end---
                 LET g_qryparam.default1 = g_asw[l_ac].asw07
                 LET g_qryparam.arg1 = g_asw03
                 CALL cl_create_qry() RETURNING g_asw[l_ac].asw07
                 DISPLAY BY NAME g_asw[l_ac].asw07 
                 NEXT FIELD asw07
            WHEN INFIELD(asw08)     #交易公司
                 CALL cl_init_qry_var()
                  #FUN-930059---mod---str---
                #LET g_qryparam.form ="q_asg1"
                 IF g_asw[l_ac].asw05='2' THEN      #逆流-上層公司 
                    LET g_qryparam.form ="q_asa3"
                 ELSE 
                    LET g_qryparam.form ="q_asb5"   #順流&側流-下層公司
                 END IF
                #FUN-930059---mod---end---
                 LET g_qryparam.default1 = g_asw[l_ac].asw08
                 LET g_qryparam.arg1 = g_asw03
                 CALL cl_create_qry() RETURNING g_asw[l_ac].asw08
                 DISPLAY BY NAME g_asw[l_ac].asw08 
                 NEXT FIELD asw08
            WHEN INFIELD(asw09)     #帳列科目
                #FUN-920095---mod---str---
                # CALL cl_init_qry_var()
                # LET g_qryparam.form ="q_ash1"
                # LET g_qryparam.default1 = g_asw[l_ac].asw09
                # SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01=g_asw[l_ac].asw07
                # LET g_qryparam.arg1 = l_asg05
                # LET g_qryparam.arg2 = g_asw[l_ac].asw07
                # LET g_qryparam.arg3 = g_asw03        #FUN-910001 add                                                               
                # LET g_qryparam.arg4 = g_aaz.aaz641   #FUN-910001 add
                # CALL cl_create_qry() RETURNING g_asw[l_ac].asw09
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asw[1].asw09,'23',g_asz01)  #No:FUN-B90088 g_dbs_asg03-->g_plant_new
                      RETURNING g_qryparam.multiret                  
                 LET g_asw[l_ac].asw09=g_qryparam.multiret                  
                #FUN-920095---mod---end---
                 DISPLAY BY NAME g_asw[l_ac].asw09 
                 NEXT FIELD asw09
            WHEN INFIELD(asw10)     #交易科目
                 #--FUN-B90088--mark--str
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_ash1"
                 #LET g_qryparam.default1 = g_asw[l_ac].asw10
                 #SELECT asg05 INTO l_asg05 FROM asg_file WHERE asg01=g_asw[l_ac].asw07
                 #LET g_qryparam.arg1 = l_asg05
                 #LET g_qryparam.arg2 = g_asw[l_ac].asw07
                 #LET g_qryparam.arg3 = g_asw03        #FUN-910001 add                                                               
                 #LET g_qryparam.arg4 = g_asz01   #FUN-910001 add 
                 #CALL cl_create_qry() RETURNING g_asw[l_ac].asw10
                 #--FUN-90088-mark--end
                 #FUN-B90088--add--str
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asw[1].asw10,'23',g_asz01) 
                      RETURNING g_qryparam.multiret                  
                 LET g_asw[l_ac].asw10=g_qryparam.multiret
                 #FUN-B90088--add--end
                 DISPLAY BY NAME g_asw[l_ac].asw10
                 NEXT FIELD asw10
            #--No:FUN-B90088 --add--str--
            WHEN INFIELD(asw19)     #交易科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant,g_asw[1].asw19,'23',g_asz01) 
                      RETURNING g_qryparam.multiret                  
                 LET g_asw[l_ac].asw19=g_qryparam.multiret
                 DISPLAY BY NAME g_asw[l_ac].asw19 
                 NEXT FIELD asw19
            #--No:FUN-B90088 --add--end---
            #--No:FUN-B90088--mark--str--     
            #WHEN INFIELD(asw11)     #交易幣別
            #     CALL cl_init_qry_var()
            #     LET g_qryparam.form ="q_azi"
            #     LET g_qryparam.default1 = g_asw[l_ac].asw11
            #     CALL cl_create_qry() RETURNING g_asw[l_ac].asw11
            #     DISPLAY BY NAME g_asw[l_ac].asw11
            #     NEXT FIELD asw11
             #--No:FUN-B90088--mark--end--   
            OTHERWISE 
                 EXIT CASE
         END CASE

      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(asw04) AND l_ac > 1 THEN
            LET g_asw[l_ac].* = g_asw[l_ac-1].*
            LET g_asw[l_ac].asw04 = g_asw[l_ac-1].asw04 + 1 
            NEXT FIELD asw04
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

   CLOSE i012_bcl
   COMMIT WORK

END FUNCTION

FUNCTION i012_asg(p_cmd,p_asw03,p_asg01,p_st)
   DEFINE p_cmd       LIKE type_file.chr1,
          p_asw03     LIKE asw_file.asw03,
          p_asg01     LIKE asg_file.asg01,
          p_st        LIKE type_file.chr1,
          l_asg02     LIKE asg_file.asg02
         #l_asgacti   LIKE asg_file.asgacti  #FUN-920095 mark

  #SELECT asg02,asgacti INTO l_asg02,l_asgacti    #FUN-920095 mark
   SELECT asg02 INTO l_asg02                      #FUN-920095 mod
     FROM asg_file
    WHERE asg01=p_asg01
      AND (asg01 IN (SELECT DISTINCT asb02 FROM asb_file WHERE asb01=p_asw03)
       OR  asg01 IN (SELECT DISTINCT asb04 FROM asb_file WHERE asb01=p_asw03))
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-949'
                               LET l_asg02 = NULL
     #WHEN l_asgacti = 'N'     LET g_errno = '9028'  #FUN-920095 mark
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_st = "s" THEN   #來源公司
         LET g_asw[l_ac].asg02_s = l_asg02
         DISPLAY BY NAME g_asw[l_ac].asg02_s
      ELSE                 #交易公司
         LET g_asw[l_ac].asg02_t = l_asg02
         DISPLAY BY NAME g_asw[l_ac].asg02_t
      END IF
   END IF

END FUNCTION

#FUNCTION i012_ash(p_cmd,p_ash01,p_ash06,p_at)     #FUN-920095 mark
FUNCTION i012_ashh(p_cmd,p_ashh01,p_ashh06,p_at)   #FUN-920095 mod
   DEFINE p_cmd       LIKE type_file.chr1,
         #p_ash01     LIKE ash_file.ash01,        #FUN-920095
         #p_ash06     LIKE ash_file.ash06,        #FUN-920095
          p_ashh01    LIKE ashh_file.ashh01,      #FUN-920095 
          p_ashh06    LIKE ashh_file.ashh06,      #FUn-920095 
          p_at        LIKE type_file.chr1,
          l_aag02     LIKE aag_file.aag02,
          l_aagacti   LIKE aag_file.aagacti
#FUN-920095---mod---str---   
#   SELECT aag02,aagacti INTO l_aag02,l_aagacti
#     FROM ash_file,aag_file
#    WHERE ash06 = aag01
#      AND ash00 = aag00
#      AND ash00 in (SELECT asg05 FROM asg_file WHERE asg01=p_ash01)
#      AND aag00 = g_aaz.aaz641   #FUN-910001 add  #合并報表帳別
#      AND ash01 = p_ash01
#      AND ash06 = p_ash06
#      AND ash13 = g_asw03   #FUN-910001 add
      SELECT asg03 INTO g_plant_new    
        FROM asg_file
       WHERE asg01 = g_asw031 
    LET g_sql = "SELECT aag02,aagacti ",
                #"  FROM ",g_dbs_asg03,"aag_file ",#No:FUN-B90088 mark
                "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),#No:FUN-B90088 add
                " WHERE aag00 = '",g_asz01,"'",                
                "   AND aag01 = '",p_ashh06,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #No:FUN-B90088 add
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B90088 add
    PREPARE i012_pre_1 FROM g_sql
    DECLARE i012_cur_1 CURSOR FOR i012_pre_1
    OPEN i012_cur_1
    FETCH i012_cur_1 INTO l_aag02,l_aagacti 
                                                                     
    IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
  #FUN-920095---mod---end---
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-916'
                               LET l_aag02 = NULL
      WHEN l_aagacti = 'N'     LET g_errno = '9028'
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 

   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_at = "a" THEN   #帳列科目
         LET g_asw[l_ac].aag02_a = l_aag02
         DISPLAY BY NAME g_asw[l_ac].aag02_a
      END IF 
      IF p_at = 't' THEN             #交易科目
         LET g_asw[l_ac].aag02_t = l_aag02
         DISPLAY BY NAME g_asw[l_ac].aag02_t
      END IF  
      #NO:FUN-B90088 --add--str
      IF p_at = 's' THEN             #未實現損益科目
         LET g_asw[l_ac].aag02_s = l_aag02
         DISPLAY BY NAME g_asw[l_ac].aag02_s
      END IF
      #NO:FUN-B90088 --add--end
   END IF

END FUNCTION


FUNCTION i012_bp(p_ud)
   DEFINE p_ud     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF

   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)

   DISPLAY ARRAY g_asw TO s_asw.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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

      ON ACTION reproduce 
         LET g_action_choice="reproduce"
         EXIT DISPLAY

      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY

      ON ACTION first 
         CALL i012_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY   
                              
      ON ACTION previous
         CALL i012_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY   
                              
      ON ACTION jump
         CALL i012_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
                              
      ON ACTION next
         CALL i012_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY   
                              
      ON ACTION last
         CALL i012_fetch('L')
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


      ON ACTION entry_sheet     #产生调整分录
         LET g_action_choice = "entry_sheet"
         EXIT DISPLAY

      ON ACTION qry_sheet   #查询分录底稿
         LET g_action_choice = "qry_sheet"
         EXIT DISPLAY
      #luttb 101215--add-end
      #--No:FUN-B90088--add--str--
      ON ACTION rate
         LET g_action_choice="rate"
         EXIT DISPLAY
      #--No:FUN-B90088--add--end--
      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

      AFTER DISPLAY
         CONTINUE DISPLAY

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i012_copy()
DEFINE l_asw              RECORD LIKE asw_file.*,
       l_old01,l_new01    LIKE asw_file.asw01,
       l_old02,l_new02    LIKE asw_file.asw02,
       l_old03,l_new03    LIKE asw_file.asw03,
       l_old031,l_new031  LIKE asw_file.asw031, #FUN-770086
       l_n                LIKE type_file.num5
      #l_acti             LIKE asg_file.asgacti #FUN-770086  #FUN-920095 mark

   IF s_shut(0) THEN RETURN END IF

   IF cl_null(g_asw01) OR cl_null(g_asw02) OR 
      cl_null(g_asw03) OR cl_null(g_asw031) THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN
   END IF

   INPUT l_new01,l_new02,l_new03,l_new031 FROM asw01,asw02,asw03,asw031  #FUN-770086
      AFTER FIELD asw01
         IF NOT cl_null(l_new01) THEN
            SELECT count(*) INTO g_cnt FROM asw_file
             WHERE asw01 = l_new01 AND asw02 = l_new02 
               AND asw03 = l_new03 AND asw03 = l_new031 #FUN-770086
            IF g_cnt > 0 THEN
               CALL cl_err(l_new01,-239,0)
               NEXT FIELD asw01
            END IF
         END IF

      AFTER FIELD asw02
         IF NOT cl_null(l_new02) THEN
            SELECT count(*) INTO g_cnt FROM asw_file
             WHERE asw01 = l_new01 AND asw02 = l_new02 
               AND asw03 = l_new03 AND asw03 = l_new031 #FUN-770086
            IF g_cnt > 0 THEN
               CALL cl_err(l_new02,-239,0)
               NEXT FIELD asw02
            END IF
         END IF

      AFTER FIELD asw03
         IF NOT cl_null(l_new03) THEN
            #FUN-930059---mark---str---
           #SELECT count(*) INTO g_cnt FROM asw_file
           # WHERE asw01 = l_new01 AND asw02 = l_new02 
           #   AND asw03 = l_new03 AND asw03 = l_new031 #FUN-770086
           #IF g_cnt > 0 THEN
           #   CALL cl_err(l_new03,-239,0)
           #   NEXT FIELD asw03
           #END IF
           #FUN-930059---mark---end---
            SELECT COUNT(*) INTO l_n FROM asa_file WHERE asa01 = l_new03
            IF l_n = 0 THEN 
               CALL cl_err3("sel","asa_file",l_new03,"","agl-117","","",1)
               NEXT FIELD asw03
            END IF
         END IF

      #FUN-770086.................beatk
      AFTER FIELD asw031   #上層公司
#         IF NOT i012_chk_asw031(l_new031) THEN
#            NEXT FIELD asw031 
#         END IF
#         CALL i012_set_asg02(l_new031)  #FUN-770086
      #FUN-770086.................end
      #FUN-930059---add---str---
         IF NOT cl_null(l_new031) THEN
            SELECT count(*) INTO g_cnt FROM asw_file
             WHERE asw01 = l_new01 AND asw02 = l_new02 
               AND asw03 = l_new03 AND asw03 = l_new031 
            IF g_cnt > 0 THEN
               CALL cl_err(l_new03,-239,0)
               NEXT FIELD asw03
            END IF

            SELECT count(*) INTO l_n FROM asa_file
             WHERE asa01=l_new03 AND asa02=l_new031

            IF l_n = 0  THEN
               CALL cl_err(l_new031,'agl-118',0)
               NEXT FIELD asw031
            END IF

            CALL i012_set_asg02(l_new031,l_new03)  #FUN-770086    #FUN-950051 add l_new03
         END IF
        #FUN-930059---add---end---
        
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(asw03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_asa1"
               LET g_qryparam.default1 = l_new03
               CALL cl_create_qry() RETURNING l_new03
               DISPLAY l_new03 TO asw03 
               NEXT FIELD asw03
            #FUN-770086...................beatk
            WHEN INFIELD(asw031)    #上層公司
                 CALL cl_init_qry_var()
                 #FUN-930059---mod---str---
                #LET g_qryparam.form ="q_asg"                      
                 LET g_qryparam.form ="q_asa3"                    
                 LET g_qryparam.arg1 =l_new03                     
                 LET g_qryparam.default1 = l_new031
                #CALL cl_create_qry() RETURNING g_asw031
                #DISPLAY g_asw031 TO asw031
                 CALL cl_create_qry() RETURNING l_new031
                 DISPLAY l_new031 TO asw031
                #FUN-930059---mod---end---
                 NEXT FIELD asw031
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
 
      ON ACTION controlg   
         CALL cl_cmdask() 

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_asw01 TO asw01 
      DISPLAY g_asw02 TO asw02 
      DISPLAY g_asw03 TO asw03 
      DISPLAY g_asw031 TO asw031
      RETURN
   END IF

   DROP TABLE x

   SELECT * FROM asw_file         #單頭複製
    WHERE asw01 = g_asw01 AND asw02 = g_asw02 
      AND asw03 = g_asw03 AND asw031 = g_asw031 #FUN-770086
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x", g_asw01,g_asw02,SQLCA.sqlcode,"","",1)
      RETURN
   END IF

   UPDATE x
      SET asw01 = l_new01 , asw02 = l_new02 , asw03 = l_new03 , 
          asw031 = l_new031 #FUN-770086

   INSERT INTO asw_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","asw_file",l_new01,l_new02,SQLCA.sqlcode,"","asw",1)
      RETURN
   END IF

   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new01,') O.K'
       
   LET l_old01 = g_asw01 
   LET l_old02 = g_asw02 
   LET l_old03 = g_asw03 
   LET l_old031= g_asw031 #FUN-770086

   SELECT UNIQUE asw01,asw02,asw03,asw031 INTO g_asw01,g_asw02,g_asw03,g_asw031 #FUN-770086
     FROM asw_file 
    WHERE asw01 = l_new01 AND asw02 = l_new02 AND asw03 = l_new03 
      AND asw031= l_new031 #FUN-770086

   CALL i012_b()
   #FUN-C80046---begin
   #SELECT UNIQUE asw01,asw02,asw03 INTO g_asw01,g_asw02,g_asw03,g_asw031 #FUN-770086
   #  FROM asw_file 
   # WHERE asw01 = l_old01 AND asw02 = l_old02 AND asw03 = l_old03 
   #   AND asw031= l_old031 #FUN-770086
   #
   #CALL i012_show()
   #FUN-C80046---end
END FUNCTION

FUNCTION i012_out()
   DEFINE l_wc STRING #FUN-770086

   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF

   CALL cl_wait()

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'ggli201'

   #組合出 SQL 指令
   LET g_sql="SELECT DISTINCT A.asw01,A.asw02,A.asw03,A.asw031,", #FUN-770086
             "       G.asg02 asw031_d,A.asw04,A.asw05,A.asw06,",
             "       A.asw07,B.asg02 asg02_s,A.asw08,C.asg02 asg02_t,",
             "       A.asw09,D.aag02 aag02_a,A.asw10,E.aag02 aag02_t,",
             "       A.asw11,A.asw12,A.asw13,A.asw131,A.asw14,A.asw15,", #FUN-770086
             "       A.asw16,F.azi04 ",
             "  FROM asw_file A,asg_file B,asg_file C,",
             "       aag_file D,aag_file E,azi_file F,",
             "       asg_file G", #FUN-770086
             " WHERE A.asw07 = B.asg01",
             "   AND A.asw08 = C.asg01",
             "   AND A.asw09 = D.aag01",
             "   AND A.asw10 = E.aag01",
             "   AND A.asw11 = F.azi01",
             "   AND A.asw031= G.asg01", #FUN-770086
             "   AND ",g_wc CLIPPED,
             " ORDER BY A.asw01,A.asw02,A.asw03,A.asw04"
   PREPARE i012_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i012_co  CURSOR FOR i012_p1

   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'asw01,asw02,asw03,asw031,asw04,asw05,asw06,asw07,asw08,asw09,asw10,asw11,asw12,asw13,asw131,asw14,asw15,asw16') #FUN-770086
           RETURNING l_wc #FUN-770086
   ELSE
      LET l_wc = '' #FUN-770086
   END IF

   CALL cl_prt_cs1('ggli201','ggli201',g_sql,l_wc) #FUN-770086

END FUNCTION

#FUN-770086.....................beatk
FUNCTION i012_set_asg02(l_asw031,l_asw03)   #FUN-950051 add asw03
   DEFINE l_asg02  LIKE asg_file.asg02
   DEFINE l_asw031 LIKE asw_file.asw031
   DEFINE l_asg03  LIKE asg_file.asg03     #FUN-920095 add
   DEFINE l_asa09  LIKE asa_file.asa09     #FUN-950051
   DEFINE l_asw03  LIKE asw_file.asw03     #FUN-950051
   
   IF l_asw031 IS NULL THEN 
      DISPLAY NULL TO FORMONLY.asg02
      RETURN
   END IF
   
   #FUN-950051--mod--str
   SELECT asa09 INTO l_asa09 FROM asa_file 
    WHERE asa01 = l_asw03   #群族
      AND asa02 = l_asw031  #公司編號
   IF l_asa09 = 'Y' THEN
   #FUN-950051--mod--end 
      #FUN-920095---add---str---
       SELECT asg03 INTO l_asg03    
         FROM asg_file
        WHERE asg01 = l_asw031 

        LET g_plant_new = l_asg03      #營運中心
        CALL s_getdbs()
        LET g_dbs_asg03 = g_dbs_new    #所屬DB

       # LET g_sql = "SELECT asz01 FROM ",g_dbs_asg03,"asz_file", #No:FUN-B90088
        LET g_sql = "SELECT asz01 FROM ", cl_get_target_table(g_plant_new,'asz_file'),#No:FUN-B90088 add
                    " WHERE asz00 = '0'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #No:FUN-B90088 add
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #No:FUN-B90088 add
        PREPARE i012_pre FROM g_sql
        DECLARE i012_cur CURSOR FOR i012_pre
        OPEN i012_cur
        FETCH i012_cur INTO g_asz01    #合併後帳別
        IF cl_null(g_asz01) THEN
            CALL cl_err(l_asg03,'agl-601',1)
        END IF
       #FUN-920095---add---end---
   #FUN-950051--mod--str
   ELSE
        LET g_dbs_asg03 = s_dbstring(g_dbs CLIPPED)
        SELECT asz01 INTO g_asz01 FROM asz_file WHERE asz00 = '0'
   END IF   
   #FUN-950051--mod--end
   SELECT asg02 INTO l_asg02 FROM asg_file
                            WHERE asg01=l_asw031
   DISPLAY l_asg02 TO FORMONLY.asg02
END FUNCTION

#FUN-920095---mark---str---
#FUNCTION i012_chk_asw031(l_asw031)
#  DEFINE l_asgacti LIKE asg_file.asgacti
#  DEFINE l_asw031 LIKE asw_file.asw031

#  IF NOT cl_null(l_asw031) THEN
#     SELECT asgacti INTO l_asgacti FROM asg_file WHERE asg01 = l_asw031
#     CASE
#        WHEN l_asgacti="N"
#           CALL cl_err3("sel","asg_file",l_asw031,"","9028","","",1)
#           DISPLAY NULL TO FORMOLNY.asg02
#           RETURN FALSE
#        WHEN SQLCA.sqlcode
#           CALL cl_err3("sel","asg_file",l_asw031,"",
#                         SQLCA.sqlcode,"","",1)
#           DISPLAY NULL TO FORMOLNY.asg02
#           RETURN FALSE
#     END CASE
#  END IF
#  RETURN TRUE
#END FUNCTION
#FUN-770086.....................end
#FUN-920095---mark---end---


#luttb--add--str--
FUNCTION i012_v()
DEFINE l_asj RECORD LIKE asj_file.*
DEFINE l_ask RECORD LIKE ask_file.*
DEFINE li_result LIKE type_file.num5
DEFINE l_asj11   LIKE asj_file.asj11
DEFINE l_asj12   LIKE asj_file.asj12
DEFINE g_t1      LIKE aac_file.aac01
DEFINE l_amt1    LIKE ask_file.ask07
DEFINE l_amt2    LIKE ask_file.ask07
DEFINE l_asw07   LIKE asw_file.asw07
DEFINE l_asw08   LIKE asw_file.asw08
DEFINE l_asw09   LIKE asw_file.asw09
DEFINE l_asw10   LIKE asw_file.asw10
DEFINE l_asw12   LIKE asw_file.asw12
DEFINE l_asw13   LIKE asw_file.asw13
DEFINE l_asw131  LIKE asw_file.asw131
DEFINE l_asw14   LIKE asw_file.asw14
DEFINE l_asw19   LIKE asw_file.asw19
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_sql     STRING             

   SELECT COUNT(*) INTO l_cnt FROM asj_file
    WHERE asj00 = g_asz01 AND asj01 = g_asw18
   IF l_cnt > 0 THEN
      IF NOT s_ask_entry(g_asw18) THEN RETURN END IF #Genero
   END IF
   DELETE FROM asj_file WHERE asj00 = g_asz01 AND asj01 = g_asw18
   DELETE FROM ask_file WHERE ask00 = g_asz01 AND ask01 = g_asw18

   LET p_row = 12 LET p_col = 10
   OPEN WINDOW i012_1_w AT 14,10 WITH FORM "ggl/42f/ggli201_1"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_locale("ggli201_1")
   INPUT g_t1 WITHOUT DEFAULTS FROM aac01
     AFTER FIELD aac01
        IF NOT cl_null(g_t1) THEN
           CALL i012_aac01(g_t1)
           IF NOT cl_null(g_errno) THEN
              CALL cl_err('aac01',g_errno,0)
              NEXT FIELD aac01
           END IF
        ELSE
           NEXT FIELD aac01
        END IF
     ON ACTION CONTROLP
         CASE WHEN INFIELD(aac01)
              CALL q_aac(FALSE,TRUE,g_t1,'A','','','GGL') RETURNING g_t1
              DISPLAY g_t1 TO aac01
              NEXT FIELD aac01
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
   END INPUT

   CLOSE WINDOW i012_1_w                 #結束畫面
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   INITIALIZE l_asj.* TO NULL
   INITIALIZE l_ask.* TO NULL
   CALL s_showmsg_init()
   LET g_success = 'Y'
   BEGIN WORK
  #CALL s_auto_assign_no("GGL",g_t1,g_today,"","asj_file","asj01",g_plant,2,g_asz01)  #carrier 20111024
   CALL s_auto_assign_no("AGL",g_t1,g_today,"","asj_file","asj01",g_plant,2,g_asz01)  #carrier 20111024
               RETURNING li_result,l_asj.asj01
   IF (NOT li_result) THEN
      CALL s_errmsg('asj_file','asj01',l_asj.asj01,'abm-621',1)
      LET g_success = 'N'
   END IF
   ####产生调整分录单头档
   LET l_asj.asj00 = g_asz01
   LET l_asj.asj02 = g_today
   LET l_asj.asj03 = g_asw01
   LET l_asj.asj04 = g_asw02
   LET l_asj.asj05 = g_asw03
   LET l_asj.asj06 = g_asw031
   SELECT asg05 INTO l_asj.asj07
     FROM asg_file WHERE asg01 = l_asj.asj06
   #No.TQC-C90057  --Begin
   IF cl_null(l_asj.asj07) THEN
      LET l_asj.asj07 = 'N'
   END IF
   #No.TQC-C90057  --End  
   LET l_asj.asj08 = '2'  #冲销作业
   LET l_asj.asj081= '2'  #未实现损益
   LET l_asj.asj11 = 0    #单身产生后回写
   LET l_asj.asj21 = '00' #版本
   LET l_asj.asj12 = 0    #单身产生后回写
   LET l_asj.asjconf = 'Y'
   LET l_asj.asjuser = g_user
   LET l_asj.asjgrup = g_grup
   LET l_asj.asjlegal = g_legal
   
   #FUN-B80135--add--str--
   IF l_asj.asj03 <g_year OR (l_asj.asj03=g_year AND l_asj.asj04<=g_month) THEN
      CALL cl_err('','axm-164',0)
      LET g_success='N'
      RETURN
   END IF
  #FUN-B80135--add—end--

   INSERT INTO asj_file VALUES(l_asj.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asj_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF

   LET l_sql = "SELECT asw07,asw08,asw09,asw10,asw19,SUM(asw12),SUM(asw13),SUM(asw131),SUM(asw14) ", #No:FUN-B90088 add asw19
               " FROM asw_file",
               " WHERE asw01 = '",g_asw01,"' ",
               "   AND asw02 = '",g_asw02,"' ",
               "   AND asw03 = '",g_asw03,"' ",
              #"   AND asw04 = '",g_asw04,"' ",
               #"  GROUP BY asw07,asw08,asw09,asw10 "   #luttb 101221
               "  GROUP BY asw07,asw08,asw09,asw10,asw19 "  #FUN-B90088 add asw19
   PREPARE i012_v_prepare FROM l_sql 
   DECLARE i012_v_cs                 
       SCROLL CURSOR WITH HOLD FOR i012_v_prepare
  FOREACH i012_v_cs INTO l_asw07,l_asw08,l_asw09,l_asw10,l_asw19,l_asw12,l_asw13,l_asw131,l_asw14 #No:FUN-B90088 add l_asw19
####分录应为
####借:收入  asw12
####贷:利润  asw131
####贷:未实现损益 asw13+asw14

####借方
    LET l_ask.ask00 = l_asj.asj00
    LET l_ask.ask01 = l_asj.asj01
    SELECT MAX(ask02) INTO l_ask.ask02 FROM ask_file
     WHERE ask00 = l_ask.ask00 AND ask01 = l_ask.ask01 
    IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 0 END IF 
    LET l_ask.ask02 = l_ask.ask02+1
    LET l_ask.ask03 = l_asw09
    LET l_ask.ask05 = l_asw08
    LET l_ask.ask07 = l_asw12 
    LET l_ask.ask06 = '1'   #借
   #SELECT SUM(asw12) INTO l_ask.ask07 FROM asw_file
   # WHERE asw01 = g_asw01 AND asw02 = g_asw02
   #   AND asw03 = g_asw03 AND asw031 = g_asw031
   #IF cl_null(l_ask.ask07) THEN LET l_ask.ask07 = 0 END IF 
    LET l_ask.asklegal = g_legal
    INSERT INTO ask_file VALUES(l_ask.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF

####贷方
    SELECT MAX(ask02) INTO l_ask.ask02 FROM ask_file
     WHERE ask00 = l_ask.ask00 AND ask01 = l_ask.ask01
    IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 0 END IF
    LET l_ask.ask02=l_ask.ask02+1
   #SELECT  aaz109 INTO l_ask.ask03 FROM aaz_file WHERE aaz00 = '0'
    LET l_ask.ask06 = '2'  #贷
    LET l_ask.ask07 = l_asw131
    LET l_ask.ask05 = l_asw07
    LET l_ask.ask03 = l_asw10
   #SELECT SUM(asw13+asw14) INTO l_ask.ask07 FROM asw_file
   # WHERE asw01 = g_asw01 AND asw02 = g_asw02
   #   AND asw03 = g_asw03 AND asw031 = g_asw031
   #IF cl_null(l_ask.ask07) THEN LET l_ask.ask07 = 0 END IF
    LET l_ask.asklegal = g_legal
    INSERT INTO ask_file VALUES(l_ask.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
       LET g_success = 'N'
    END IF

    SELECT MAX(ask02) INTO l_ask.ask02 FROM ask_file
     WHERE ask00 = l_ask.ask00 AND ask01 = l_ask.ask01
    IF cl_null(l_ask.ask02) THEN LET l_ask.ask02 = 0 END IF
    LET l_ask.ask02=l_ask.ask02+1
    #LET l_ask.ask03 = g_asz.asz09  #NO:FUn-B90088mark
    LET l_ask.ask03 = l_asw19
    LET l_ask.ask06 = '2'  #贷
   #SELECT SUM(ask07) INTO l_amt1 FROM ask_file   #借方金额
   # WHERE ask00 = l_ask.ask00 AND ask01 = l_ask.ask01
   #   AND ask06 = '1'
   #SELECT SUM(ask07) INTO l_amt2 FROM ask_file   #贷方金额
   # WHERE ask00 = l_ask.ask00 AND ask01 = l_ask.ask01
   #   AND ask06 = '2'
    LET l_ask.ask07 = l_asw13+l_asw14
    LET l_ask.ask05 = l_asw07
    LET l_ask.asklegal = g_legal
    IF l_ask.ask07<>0 THEN
       INSERT INTO ask_file VALUES(l_ask.*)
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL s_errmsg('ask_file','insert',l_asj.asj01,SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
    END IF 
  END FOREACH
   #UPDATE asj_file  借方总金额,贷方总金额
   SELECT SUM(ask07) INTO l_asj11 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '1'   #借方
   SELECT SUM(ask07) INTO l_asj12 FROM ask_file WHERE ask00 = l_asj.asj00
      AND ask01 = l_asj.asj01 AND ask06 = '2'   #贷方
   IF cl_null(l_asj11) THEN LET l_asj11 = 0 END IF
   IF cl_null(l_asj12) THEN LET l_asj12 = 0 END IF
   UPDATE asj_file SET asj11 = l_asj11,
                       asj12 = l_asj12
    WHERE asj00 = l_asj.asj00
      AND asj01 = l_asj.asj01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asj_file','update',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   UPDATE asw_file SET asw18 = l_asj.asj01
    WHERE asw01 = g_asw01 AND asw02 = g_asw02
      AND asw03 = g_asw03 AND asw031 = g_asw031
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
      CALL s_errmsg('asw_file','update',l_asj.asj01,SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_asw18 = l_asj.asj01
      DISPLAY g_asw18 TO asw18
   ELSE
      CALL s_showmsg()
      ROLLBACK WORK
   END IF
END FUNCTION

FUNCTION i012_aac01(p_t1)
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
#luttb 101215--add--end
#No:FUN-B90088--add-str--
FUNCTION i012_rate_batch()
DEFINE l_rate    LIKE type_file.num20_6
DEFINE l_asw131  LIKE asw_file.asw131
DEFINE l_asw11   LIKE asw_file.asw11
DEFINE l_asw12   LIKE asw_file.asw12
DEFINE l_asw13   LIKE asw_file.asw13
DEFINE l_asw14   LIKE asw_file.asw14
DEFINE l_asw04   LIKE asw_file.asw04
DEFINE l_azi04   LIKE azi_file.azi04


   OPEN WINDOW i012_w1
     WITH FORM "ggl/42f/ggli2011"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("ggli2011")

   INPUT l_rate WITHOUT DEFAULTS FROM rate

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()
   END INPUT

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW i012_w1
      RETURN
   END IF

   CLOSE WINDOW i012_w1
   LET g_sql = " SELECT asw04,asw11,asw12,asw13 ",
               "   FROM asw_file ",
               "  WHERE asw01 = ",g_asw01 CLIPPED,
               "   AND asw02 =  ",g_asw02 CLIPPED,
               "   AND asw03 = '",g_asw03 CLIPPED,"'",
               "   AND asw031= '",g_asw031 CLIPPED,"'",
               "   AND ",g_wc CLIPPED
   PREPARE i012_prepare4 FROM g_sql
   DECLARE i012_cs4 CURSOR FOR i012_prepare4
   FOREACH i012_cs4 INTO l_asw04,l_asw11,l_asw12,l_asw13
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_asw11
      LET l_asw14 = l_asw12*l_rate/100
      CALL cl_digcut(l_asw14,l_azi04) RETURNING l_asw14
      LET l_asw131= l_asw12-l_asw12*l_rate/100-l_asw13
      CALL cl_digcut(l_asw131,l_azi04) RETURNING l_asw131
      UPDATE asw_file SET asw14 = l_asw14,
                          asw131= l_asw131
       WHERE asw01 = g_asw01
         AND asw02 = g_asw02
         AND asw03 = g_asw03
         AND asw04 = l_asw04
         AND asw11 = l_asw11
         AND asw031= g_asw031
   END FOREACH

   CALL i012_b_fill(g_wc)                 #單身

END FUNCTION
#No:FUN-B90088--add-end--

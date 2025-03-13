# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: agli012.4gl
# Descriptions...: 合併報表關係人交易維護作業
# Date & Author..: 07/05/21 By Sarah
# Modify.........: No.FUN-750078 07/05/21 By Sarah 新增"合併報表關係人交易維護作業"
# Modify.........: No.FUN-750051 07/05/24 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760100 07/06/13 By Sarah 單身交易科目無法輸入
# Modify.........: No.FUN-770086 07/07/26 By kim 合併報表新增功能
# Modify.........: No.FUN-780068 07/10/09 By Sarah 單身刪除的WHERE條件句,axv04的部份應該用g_axv_t.axv04
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980003 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910001 09/05/19 By lutingting 由11區追單,1.串axe_file時,增加串axe13(族群代號)=axv03                                       
#                                                  2.開窗CALL q_axe1需多傳arg3(族群代號),arg4(合并報表帳別)  
# Modify.........: NO.FUN-930074 09/10/29 by yiting axv_pk add axv11
# Modify.........: NO.FUN-950051 09/10/30 By lutingting 由于agli002單頭增加"獨立會科合并"欄位,對檢查快科方式修改
# Modify.........: No:FUN-920095 09/10/30 By yiting   1.單身axv09開窗以來源公司axv07抓取agli009設定營運中心+合併後帳別aaz641 開窗合併後會科資料
#                                                  2.AFTER FIELD axv09檢核會科正確羅輯亦同第1點
#                                                  3.會科名稱aag02要一併顯示
#                                                  4.單身axv10此欄位目前並沒有用到，予以隱藏
# Modify.........: No:FUN-910002 09/10/30 By yiting由11區追單,1.當交易類別=3.有形資產時,單身axv10(交易科目)才卡不可空白                        
#                                                  2.順流時,axv16=axv14,逆、側流時,axv16=axv14*axv15/100 
# Modify.........: No.TQC-9C0099 09/12/16 By jan GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-9C0072 10/01/05 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/06/03 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-930059 10/08/17 By vealxu axv031上層公司開窗/欄位輸入檢查，應以族群編號axv03為key，只能輸入/開窗存在agli002單頭axa02公司
# Modify.........: No.FUN-920123 10/08/17 By vealxu 將使用axzacti的地方mark
# Modify.........: No.FUN-A30122 10/08/20 By vealxu 取合併帳別資料庫改由s_aaz641_plant，s_get_aaz641取合併帳別
# Modify.........: No.FUN-A90039 11/01/26 By lixia 追單 增加未實現損益比率
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查詢自動過濾
# Modify.........: No.FUN-BA0006 11/10/04 By Belle GP5.25 合併報表降版為GP5.1架構，程式由2011/4/1版更片程式抓取
# Modify.........: No.FUN-B50062 11/06/07 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70005 11/07/01 By yinhy 點擊“單身”系統報錯“(-1213) 1 字元轉換至數字程序失敗.”，進入項次後回車會清空“來源幣種”和“交易金額”。
# Modify.........: No.FUN-BA0012 11/10/05 by belle 將4/1版更後的GP5.25合併報表程式與目前己修改LOSE的FUN,TQC,MOD單追齊
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"  
#FUN-BA0012
#FUN-BA0006 
#模組變數(Module Variables)
DEFINE 
    g_axv01          LIKE axv_file.axv01,      #FUN-750078
    g_axv02          LIKE axv_file.axv02,  
    g_axv03          LIKE axv_file.axv03,  
    g_axv031         LIKE axv_file.axv031,  #FUN-770086
    g_axv01_t        LIKE axv_file.axv01, 
    g_axv02_t        LIKE axv_file.axv02, 
    g_axv03_t        LIKE axv_file.axv03, 
    g_axv031_t       LIKE axv_file.axv031,  #FUN-770086
    g_axv            DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        axv04        LIKE axv_file.axv04,      #項次
        axv05        LIKE axv_file.axv05,      #交易性質
        axv06        LIKE axv_file.axv06,      #交易類別
        axv07        LIKE axv_file.axv07,      #來源公司
        axz02_s      LIKE axz_file.axz02,      #公司名稱
        axv08        LIKE axv_file.axv08,      #交易公司
        axz02_t      LIKE axz_file.axz02,      #公司名稱
        axv09        LIKE axv_file.axv09,      #帳列科目
        aag02_a      LIKE aag_file.aag02,      #科目名稱
        axv10        LIKE axv_file.axv10,      #交易科目
        aag02_t      LIKE aag_file.aag02,      #科目名稱
        axv11        LIKE axv_file.axv11,      #來源幣別
        axv12        LIKE axv_file.axv12,      #交易金額
        axv13        LIKE axv_file.axv13,      #交易損益
        axv131       LIKE axv_file.axv131,     #已實現損益  #FUN-770086
        axv14        LIKE axv_file.axv14,      #未實現損益
        axv15        LIKE axv_file.axv15,      #持股比率
        axv16        LIKE axv_file.axv16,      #分配未實現損益
        axv17        LIKE axv_file.axv17       #來源單號    #FUN-770086
                     END RECORD,
    g_axv_t          RECORD                 #程式變數 (舊值)
        axv04        LIKE axv_file.axv04,      #項次
        axv05        LIKE axv_file.axv05,      #交易性質
        axv06        LIKE axv_file.axv06,      #交易類別
        axv07        LIKE axv_file.axv07,      #來源公司
        axz02_s      LIKE axz_file.axz02,      #公司名稱
        axv08        LIKE axv_file.axv08,      #交易公司
        axz02_t      LIKE axz_file.axz02,      #公司名稱
        axv09        LIKE axv_file.axv09,      #帳列科目
        aag02_a      LIKE aag_file.aag02,      #科目名稱
        axv10        LIKE axv_file.axv10,      #交易科目
        aag02_t      LIKE aag_file.aag02,      #科目名稱
        axv11        LIKE axv_file.axv11,      #來源幣別
        axv12        LIKE axv_file.axv12,      #交易金額
        axv13        LIKE axv_file.axv13,      #交易損益
        axv131       LIKE axv_file.axv131,     #已實現損益  #FUN-770086
        axv14        LIKE axv_file.axv14,      #未實現損益
        axv15        LIKE axv_file.axv15,      #持股比率
        axv16        LIKE axv_file.axv16,      #分配未實現損益
        axv17        LIKE axv_file.axv17       #來源單號    #FUN-770086
                     END RECORD,
    i                LIKE type_file.num5,
    g_wc,g_sql,g_wc2 STRING,             
    g_rec_b          LIKE type_file.num5,      #單身筆數
    l_ac             LIKE type_file.num5       #目前處理的ARRAY CNT
 
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
DEFINE   g_dbs_axz03    LIKE type_file.chr21   #FUN-920095 add
DEFINE   g_aaz641       LIKE aaz_file.aaz641   #FUN-920095 add
DEFINE   g_plant_axz03  LIKE type_file.chr21   #FUN-A30122 add
 
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
   LET g_axv01_t = NULL
   LET g_axv02_t = NULL
   LET g_axv03_t = NULL
   LET g_axv031_t = NULL #FUN-770086
   LET p_row = 4 LET p_col = 12
 
   OPEN WINDOW i012_w AT p_row,p_col WITH FORM "agl/42f/agli012" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("axv10,aag02_t", FALSE)   #FUN-920095 add
   CALL i012_menu()
   CLOSE FORM i012_w                      #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i012_cs()
   CLEAR FORM                            #清除畫面
   CALL g_axv.clear()
 
   #螢幕上取條件
   INITIALIZE g_axv01  TO NULL      #No.FUN-750051
   INITIALIZE g_axv02  TO NULL      #No.FUN-750051
   INITIALIZE g_axv03  TO NULL      #No.FUN-750051
   INITIALIZE g_axv031 TO NULL      #FUN-770086
  
   CONSTRUCT g_wc ON axv01,axv02,axv03,axv031,axv04,axv05,axv06,axv07, #FUN-770086
                     axv08,axv09,axv10,axv11,axv12,axv13,axv131,axv14, #FUN-770086
                     axv15,axv16,axv17                                 #FUN-770086
                FROM axv01,axv02,axv03,axv031,s_axv[1].axv04,s_axv[1].axv05, #FUN-770086
                     s_axv[1].axv06,s_axv[1].axv07,s_axv[1].axv08,
                     s_axv[1].axv09,s_axv[1].axv10,s_axv[1].axv11,
                     s_axv[1].axv12,s_axv[1].axv13,s_axv[1].axv131,
                     s_axv[1].axv14, #FUN-770086
                     s_axv[1].axv15,s_axv[1].axv16,s_axv[1].axv17  #FUN-770086
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axv03)     #族群代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axa1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axv03 
                 NEXT FIELD axv03
            WHEN INFIELD(axv031)    #上層公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                #LET g_qryparam.form ="q_axz"                #FUN-930059 mark
                 LET g_qryparam.form ="q_axa3"               #FUN-930059 add
                 LET g_qryparam.arg1 =g_axv03                #FUN-930059 
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axv031
                 NEXT FIELD axv031
            WHEN INFIELD(axv07)     #來源公司 
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz1"
                 CALL GET_FLDBUF(axv03) RETURNING g_axv03
                 LET g_qryparam.arg1 = g_axv03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axv07 
                 NEXT FIELD axv07
            WHEN INFIELD(axv08)     #交易公司
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axz1"
                 CALL GET_FLDBUF(axv03) RETURNING g_axv03
                 LET g_qryparam.arg1 = g_axv03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret 
                 DISPLAY g_qryparam.multiret TO axv08 
                 NEXT FIELD axv08
            WHEN INFIELD(axv09)     #帳列科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axv[1].axv09,'23',g_aaz641)  #TQC-9C0099
                      RETURNING g_qryparam.multiret                  
                 DISPLAY g_qryparam.multiret TO axv09 
                 NEXT FIELD axv09
            WHEN INFIELD(axv10)     #交易科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_axe1"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axv10 
                 NEXT FIELD axv10
            WHEN INFIELD(axv11)     #交易幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO axv11 
                 NEXT FIELD axv11
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
    
      ON ACTION qbe_select
         CALL cl_qbe_select() 
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE axv01,axv02,axv03,axv031 FROM axv_file ", #FUN-770086
              " WHERE ", g_wc CLIPPED,
              " ORDER BY axv01,axv02,axv03,axv031"  #FUN-770086
   PREPARE i012_prepare FROM g_sql        #預備一下
   DECLARE i012_bcs                       #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i012_prepare
 
   LET g_sql_tmp = "SELECT UNIQUE axv01,axv02,axv03,axv031 ",  #FUN-770086
                   "  FROM axv_file ",
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
         ##已實現損益維護
         WHEN "prif"  #FUN-770086 
            IF cl_chk_act_auth() THEN
               CALL i012_b()
            ELSE
               LET g_action_choice = NULL
            END IF
#FUN-A90039 --Begin
         WHEN "rate" 
            IF cl_chk_act_auth() THEN
               CALL i012_rate_batch()
            END IF
#FUN-A90039 --End
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
               IF g_axv01 IS NOT NULL THEN
                  LET g_doc.column1 = "axv01"
                  LET g_doc.column2 = "axv02"
                  LET g_doc.column3 = "axv03"
                  LET g_doc.value1 = g_axv01
                  LET g_doc.value2 = g_axv02
                  LET g_doc.value3 = g_axv03
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel" 
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_axv),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i012_a()
   IF s_shut(0) THEN RETURN END IF                #判斷目前系統是否可用
   MESSAGE ""
   CLEAR FORM
   CALL g_axv.clear()
   INITIALIZE g_axv01 LIKE axv_file.axv01         #DEFAULT 設定
   INITIALIZE g_axv02 LIKE axv_file.axv02         #DEFAULT 設定
   INITIALIZE g_axv03 LIKE axv_file.axv03         #DEFAULT 設定
   INITIALIZE g_axv031 LIKE axv_file.axv031         #DEFAULT 設定  #FUN-770086
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i012_i("a")                           #輸入單頭
      IF INT_FLAG THEN                           #使用者不玩了
         LET g_axv01=NULL
         LET g_axv02=NULL
         LET g_axv03=NULL
         LET g_axv031=NULL  #FUN-770086
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF cl_null(g_axv01) OR cl_null(g_axv02) OR 
         cl_null(g_axv03) OR cl_null(g_axv031) THEN  #FUN-770086
         CONTINUE WHILE
      END IF
 
      CALL g_axv.clear()
      LET g_rec_b = 0 
      CALL i012_b()                              #輸入單身
      LET g_axv01_t = g_axv01                    #保留舊值
      LET g_axv02_t = g_axv02                    #保留舊值
      LET g_axv03_t = g_axv03                    #保留舊值
      LET g_axv031_t = g_axv031                    #保留舊值  #FUN-770086
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i012_i(p_cmd)
DEFINE l_flag          LIKE type_file.chr1,    #判斷必要欄位是否有輸入
       l_n1,l_n        LIKE type_file.num5,    
       p_cmd           LIKE type_file.chr1      #a:輸入 u:更改
      #l_acti          LIKE axz_file.axzacti   #FUN-770086   #FUN-920123 mark
    
   DISPLAY g_axv01,g_axv02,g_axv03,g_axv031 TO axv01,axv02,axv03,axv031  #FUN-770086
 
   INPUT g_axv01,g_axv02,g_axv03,g_axv031 FROM axv01,axv02,axv03,axv031  #FUN-770086
      AFTER FIELD axv01   #年度
         IF cl_null(g_axv01) OR g_axv01 = 0 THEN
            CALL cl_err(g_axv01,'afa-370',0)
            NEXT FIELD axv01
         END IF
         CALL s_get_bookno(g_axv01) RETURNING g_flag,g_bookno1,g_bookno2
         IF g_flag = '1' THEN
            CALL cl_err(g_axv01,'aoo-081',1)
            NEXT FIELD axv01
         END IF
 
      AFTER FIELD axv02   #期別
         IF cl_null(g_axv02) OR g_axv02 < 0 OR g_axv02 > 12 THEN
            CALL cl_err(g_axv02,'agl-013',0)
            NEXT FIELD axv02
         END IF
 
      AFTER FIELD axv03   #族群代號
         IF NOT cl_null(g_axv03) THEN
            SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = g_axv03
            IF l_n = 0 THEN 
               CALL cl_err3("sel","axa_file",g_axv03,"","agl-117","","",1)
               NEXT FIELD axv03
            END IF
         END IF
 
      AFTER FIELD axv031   #上層公司
         IF NOT cl_null(g_axv031) THEN

            SELECT count(*) INTO l_n FROM axa_file
             WHERE axa01=g_axv03 AND axa02=g_axv031

            IF l_n = 0  THEN
               CALL cl_err(g_axv031,'agl-118',0)
               LET g_axv031 = g_axv031_t
               DISPLAY BY NAME g_axv031
               NEXT FIELD axv031
            END IF

            CALL i012_set_axz02(g_axv031,g_axv03)  #FUN-770086   #FUN-950051 add axv03
         END IF

      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axv03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = g_axv03
               CALL cl_create_qry() RETURNING g_axv03
               DISPLAY g_axv03 TO axv03 
               NEXT FIELD axv03
            WHEN INFIELD(axv031)    #上層公司
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_axz"                     #FUN-930059 mark
                 LET g_qryparam.form ="q_axa3"                    #FUN-930059
                 LET g_qryparam.arg1 =g_axv03                     #FUN-930059  
                 CALL cl_create_qry() RETURNING g_axv031
                 DISPLAY g_axv031 TO axv031
                 NEXT FIELD axv031
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
   INITIALIZE g_axv01 TO NULL
   INITIALIZE g_axv02 TO NULL
   INITIALIZE g_axv03 TO NULL
   INITIALIZE g_axv031 TO NULL #FUN-770086
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_axv.clear()
 
   CALL i012_cs()                           #取得查詢條件
   IF INT_FLAG THEN                         #使用者不玩了
      LET INT_FLAG = 0             
      RETURN                       
   END IF                           
 
   OPEN i012_bcs                            #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                    #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_axv01 TO NULL
      INITIALIZE g_axv02 TO NULL
      INITIALIZE g_axv03 TO NULL
      INITIALIZE g_axv031 TO NULL #FUN-770086
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
      WHEN 'N' FETCH NEXT     i012_bcs INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
      WHEN 'P' FETCH PREVIOUS i012_bcs INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
      WHEN 'F' FETCH FIRST    i012_bcs INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
      WHEN 'L' FETCH LAST     i012_bcs INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
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
          FETCH ABSOLUTE g_jump i012_bcs INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
          LET g_no_ask = FALSE
   END CASE
 
   SELECT UNIQUE axv01,axv02,axv03,axv031  #FUN-770086
     FROM axv_file 
    WHERE axv01 = g_axv01 AND axv02 = g_axv02 AND axv03 = g_axv03 
      AND axv031 = g_axv031 #FUN-770086
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err3("sel","axv_file",g_axv01,g_axv02,SQLCA.sqlcode,"","",1)
      INITIALIZE g_axv01 TO NULL
      INITIALIZE g_axv02 TO NULL
      INITIALIZE g_axv03 TO NULL
      INITIALIZE g_axv031 TO NULL #FUN-770086
   ELSE
      CALL s_get_bookno(g_axv01) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(g_axv01,'aoo-081',1)
      END IF
 
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
 
   DISPLAY g_axv01,g_axv02,g_axv03,g_axv031 TO axv01,axv02,axv03,axv031   #單頭  #FUN-770086
   CALL i012_set_axz02(g_axv031,g_axv03)  #FUN-770086   #FUN-950051 add axv03
   CALL i012_b_fill(g_wc)                                 #單身
   CALL cl_show_fld_cont() 
 
END FUNCTION
 
FUNCTION i012_b_fill(p_wc)
DEFINE  p_wc       STRING             #NO.FUN-910082
DEFINE l_axz03     LIKE axz_file.axz03        #FUN-920095 add
DEFINE l_axa09     LIKE axa_file.axa09        #FUN-950051 add
 
   LET g_sql = "SELECT axv04,axv05,axv06,axv07,'',axv08,'',",
               "       axv09,'',axv10,'',axv11,axv12,axv13,axv131,",
               "axv14,axv15,axv16,axv17 ", #FUN-770086
               "  FROM axv_file ",
               " WHERE axv01 =  ",g_axv01 CLIPPED,
               "   AND axv02 =  ",g_axv02 CLIPPED,
               "   AND axv03 = '",g_axv03 CLIPPED,"'",
               "   AND axv031= '",g_axv031 CLIPPED,"'", #FUN-770086
               "   AND ",p_wc CLIPPED ,
               " ORDER BY axv04"
   PREPARE i012_prepare2 FROM g_sql      #預備一下
   DECLARE axv_cs CURSOR FOR i012_prepare2

   CALL g_axv.clear()

   LET g_cnt = 1
   LET g_rec_b = 0

   SELECT axa09 INTO l_axa09 FROM axa_file                                                                                          
    WHERE axa01 = g_axv03   #群族                                                                                                   
      AND axa02 = g_axv031  #公司編號                                                                                               

#FUN-A30122 -------------------mark start----------------------
#  IF l_axa09 = 'Y' THEN                                                                                                            
#     SELECT axz03 INTO l_axz03    
#       FROM axz_file
#      WHERE axz01 = g_axv031 
#
#     LET g_plant_new = l_axz03      #營運中心
#     CALL s_getdbs()
#     LET g_dbs_axz03 = g_dbs_new    #所屬DB
#
#    #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",
#     LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),   #FUN-A50102
#                 " WHERE aaz00 = '0'"
#     CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#     PREPARE i012_pre_3 FROM g_sql
#     DECLARE i012_cur_3 CURSOR FOR i012_pre_3
#     OPEN i012_cur_3
#     FETCH i012_cur_3 INTO g_aaz641    #合併後帳別
#  ELSE
#    LET g_plant_new = g_plant #TQC-9C0099
#    LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)   #當前DB
#    SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#  END IF 
#FUN-A30122 --------------------------mark end------------------------------------------
   CALL s_aaz641_dbs(g_axv03,g_axv031) RETURNING g_plant_axz03           #FUN-A30122 add         
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                   #FUN-A30122 add
   LET g_plant_new = g_plant_axz03                                       #FUN-A30122 add

   FOREACH axv_cs INTO g_axv[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      SELECT axz02 INTO g_axv[g_cnt].axz02_s FROM axz_file   #來源公司名稱
       WHERE axz01=g_axv[g_cnt].axv07
      SELECT axz02 INTO g_axv[g_cnt].axz02_t FROM axz_file   #交易公司名稱
       WHERE axz01=g_axv[g_cnt].axv08

      LET g_sql = "SELECT aag02 ",
                 #"  FROM ",g_dbs_axz03,"aag_file ",  #FUN-A50102
                 #"  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102    #FUN-A30122 mark
                  "  FROM ",cl_get_target_table(g_plant_axz03,'aag_file'), #FUJ-A30122 add   
                  " WHERE aag00 = '",g_aaz641,"'",                
                  "   AND aag01 = '",g_axv[g_cnt].axv09,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
    # CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102    #FUN-A30122 mark
      CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql #FUN-A30122  
      PREPARE i012_pre_2 FROM g_sql
      DECLARE i012_cur_2 CURSOR FOR i012_pre_2
      OPEN i012_cur_2
      FETCH i012_cur_2 INTO g_axv[g_cnt].aag02_a 
                                                                       
      IF SQLCA.sqlcode  THEN LET g_axv[g_cnt].aag02_a = '' END IF

      SELECT aag02 INTO g_axv[g_cnt].aag02_t FROM aag_file   #交易科目名稱
       WHERE aag01=g_axv[g_cnt].axv10
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_axv.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1

   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0

END FUNCTION
 
FUNCTION i012_r()
 
   IF s_shut(0) THEN RETURN END IF
   IF g_axv01 IS NULL OR g_axv02 IS NULL OR g_axv03 IS NULL 
      OR g_axv031 IS NULL THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN 
   END IF
   BEGIN WORK
   IF cl_delh(15,16) THEN
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "axv01"      #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "axv02"      #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "axv03"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_axv01       #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_axv02       #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_axv03       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM axv_file WHERE axv01=g_axv01 AND axv02=g_axv02 
                             AND axv03=g_axv03 AND axv031=g_axv031 #FUN-770086
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
         CALL cl_err3("del","axv_file",g_axv01,g_axv03,SQLCA.sqlcode,"","",1)
      ELSE 
         CLEAR FORM
         CALL g_axv.clear()
         LET g_sql = "SELECT UNIQUE axv01,axv02,axv03,axv031 ",
                     "FROM axv_file INTO TEMP y" #FUN-770086
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
       l_axz05         LIKE axz_file.axz05,     #帳別
       l_prif          LIKE type_file.num5      #FUN-770086
 
   IF g_action_choice='prif' THEN
      LET l_prif=TRUE
   ELSE
      LET l_prif=FALSE
   END IF
   LET g_action_choice = ""
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT axv04,axv05,axv06,axv07,'',axv08,'',axv09,'', ",
                     #"       axv10,'','',axv11,axv12,axv13,axv131,axv14,axv15,",
                      "       axv10,'',axv11,axv12,axv13,axv131,axv14,axv15,",      #No.TQC-B70005 去掉一個''
                      "       axv16,axv17 ",
                      "  FROM axv_file ",
                      "  WHERE axv01 = ? AND axv02 = ? ",
                      "   AND axv03 = ? AND axv031 = ? AND axv04 = ? AND axv11 = ? FOR UPDATE"  #FUN-770086   #FUN-930074 mod
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i012_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
   IF l_prif THEN
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
   ELSE
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
   END IF
 
   INPUT ARRAY g_axv WITHOUT DEFAULTS FROM s_axv.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         IF l_prif THEN
            CALL cl_set_comp_entry("axv04, axv05, axv06, axv07, axv08,
                                    axv09, axv10, axv11, axv12, axv13, 
                                    axv14, axv15, axv16, axv17",FALSE)
         ELSE
            CALL cl_set_comp_entry("axv04, axv05, axv06, axv07, axv08,
                                    axv09, axv10, axv11, axv12, axv13,
                                    axv14, axv15, axv16, axv17",TRUE)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_axv_t.* = g_axv[l_ac].*  #BACKUP
            OPEN i012_bcl USING g_axv01,g_axv02,g_axv03,g_axv031,
                                g_axv[l_ac].axv04, #FUN-770086
                                g_axv[l_ac].axv11  #FUN-930074
            IF STATUS THEN
               CALL cl_err("OPEN i012_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i012_bcl INTO g_axv[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_axv_t.axv04,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               CALL i012_axz(p_cmd,g_axv03,g_axv[l_ac].axv07,"s")             #來源公司名稱
               CALL i012_axz(p_cmd,g_axv03,g_axv[l_ac].axv08,"t")             #交易公司名稱
               CALL i012_axee(p_cmd,g_axv[l_ac].axv07,g_axv[l_ac].axv09,"a")   #帳列科目名稱
               CALL i012_axee(p_cmd,g_axv[l_ac].axv07,g_axv[l_ac].axv10,"t")   #交易科目名稱   #TQC-760100 modify
            END IF
            CALL cl_show_fld_cont() 
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_axv[l_ac].* TO NULL   
         LET g_axv_t.* = g_axv[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()   
         NEXT FIELD axv04
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            INITIALIZE g_axv[l_ac].* TO NULL  #重要欄位空白,無效
            DISPLAY g_axv[l_ac].* TO s_axv.*
            CALL g_axv.deleteElement(g_rec_b+1)
            ROLLBACK WORK
            EXIT INPUT
         END IF
         INSERT INTO axv_file(axv01,axv02,axv03,axv031,axv04,axv05,axv06,axv07, #FUN-770086
                              axv08,axv09,axv10,axv11,axv12,axv13,axv131,axv14, #FUN-770086
                              axv15,axv16,axv17,axvlegal)  #FUN-770086 #FUN-980003 add legl
                       VALUES(g_axv01,g_axv02,g_axv03,g_axv031,
                              g_axv[l_ac].axv04, #FUN-770086
                              g_axv[l_ac].axv05,g_axv[l_ac].axv06,
                              g_axv[l_ac].axv07,g_axv[l_ac].axv08,
                              g_axv[l_ac].axv09,g_axv[l_ac].axv10,
                              g_axv[l_ac].axv11,g_axv[l_ac].axv12,
                              g_axv[l_ac].axv13,g_axv[l_ac].axv131,
                              g_axv[l_ac].axv14, #FUN-770086
                              g_axv[l_ac].axv15,g_axv[l_ac].axv16,
                              g_axv[l_ac].axv17,g_legal) #FUN-770086 #FUN-980003 add legal
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","axv_file",g_axv01,g_axv02,SQLCA.sqlcode,"","",1)
            CANCEL INSERT
         ELSE
            LET g_rec_b = g_rec_b + 1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE 'INSERT O.K'
         END IF
 
      BEFORE FIELD axv04                        #default 項次
         IF g_axv[l_ac].axv04 IS NULL OR g_axv[l_ac].axv04 = 0 THEN
            SELECT max(axv04)+1 INTO g_axv[l_ac].axv04
              FROM axv_file
             WHERE axv01 = g_axv01 AND axv02 = g_axv02 AND axv03 = g_axv03
               AND axv031 = g_axv031 #FUN-770086
            IF g_axv[l_ac].axv04 IS NULL THEN
               LET g_axv[l_ac].axv04 = 1
            END IF
         END IF
 
      AFTER FIELD axv04
         IF NOT cl_null(g_axv[l_ac].axv04) THEN
            IF g_axv[l_ac].axv04 != g_axv_t.axv04 OR g_axv_t.axv04 IS NULL THEN
               SELECT COUNT(*) INTO l_n FROM axv_file
                WHERE axv01 = g_axv01 AND axv02 = g_axv02 AND axv03 = g_axv03
                  AND axv031 = g_axv031 #FUN-770086
                  AND axv04 = g_axv[l_ac].axv04
                  AND axv11 = g_axv[l_ac].axv11   #FUN-930074
               IF l_n > 0 THEN
                  CALL cl_err(g_axv[l_ac].axv04,-239,0)
                  LET g_axv[l_ac].axv04 = g_axv_t.axv04
                  NEXT FIELD axv04
               END IF
            END IF
         END IF
 
      AFTER FIELD axv05
         IF NOT cl_null(g_axv[l_ac].axv05) THEN
            IF g_axv[l_ac].axv05 NOT MATCHES '[1234]' THEN
               CALL cl_err_msg("","lib-232","1" || "|" || "4",1)
               NEXT FIELD axv05
            END IF
         ELSE
            CALL cl_err(g_axv[l_ac].axv05,"mfg5103",0)
            NEXT FIELD axv05
         END IF
 
      AFTER FIELD axv06
         IF NOT cl_null(g_axv[l_ac].axv06) THEN
            IF g_axv[l_ac].axv06 NOT MATCHES '[12345]' THEN #FUN-770086
               CALL cl_err_msg("","lib-232","1" || "|" || "5",1) #FUN-770086
               NEXT FIELD axv06
            END IF
            IF g_axv[l_ac].axv06 = '3' THEN   #3.有型資產                                                                           
               CALL cl_set_comp_required("axv10",TRUE)                                                                              
            ELSE                                                                                                                    
               CALL cl_set_comp_required("axv10",FALSE)                                                                             
            END IF                                                                                                                  
         ELSE
            CALL cl_err(g_axv[l_ac].axv06,"mfg5103",0)
            NEXT FIELD axv06
         END IF
 
      AFTER FIELD axv07
         IF NOT cl_null(g_axv[l_ac].axv07) THEN
            #FUN-930059 --------------add start-------------------
            IF g_axv[l_ac].axv05='1' THEN           #順流-上層公司
               SELECT count(*) INTO l_n FROM axa_file
                WHERE axa01=g_axv03 AND axa02=g_axv[l_ac].axv07
               IF l_n = 0  THEN
                  CALL cl_err(g_axv[l_ac].axv07,'agl-118',0)
                  LET g_axv[l_ac].axv07 = g_axv_t.axv07 
                  DISPLAY BY NAME g_axv[l_ac].axv07
                  NEXT FIELD axv07
               END IF 
            ELSE #逆流&側流-下層公司
               SELECT count(*) INTO l_n FROM axb_file
                WHERE axb01=g_axv03 AND axb04=g_axv[l_ac].axv07
               IF l_n = 0  THEN
                  CALL cl_err(g_axv[l_ac].axv07,'agl-118',0)
                  LET g_axv[l_ac].axv07 = g_axv_t.axv07
                  DISPLAY BY NAME g_axv[l_ac].axv07
                  NEXT FIELD axv07
               END IF 
            END IF 
            #FUN-930059 --------------add end------------------- 
            CALL i012_axz(p_cmd,g_axv03,g_axv[l_ac].axv07,"s")
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axv[l_ac].axv07,g_errno,0)
               LET g_axv[l_ac].axv07 = g_axv_t.axv07
               DISPLAY BY NAME g_axv[l_ac].axv07
               NEXT FIELD axv07
            END IF
         ELSE
            CALL cl_err(g_axv[l_ac].axv07,"mfg5103",0)
            NEXT FIELD axv07
         END IF
 
      AFTER FIELD axv08
         IF NOT cl_null(g_axv[l_ac].axv08) THEN
           #FUN-930059 -----------add start----------------
            IF g_axv[l_ac].axv05='2' THEN        #逆流-上層公司
               SELECT count(*) INTO l_n FROM axa_file
                WHERE axa01=g_axv03 AND axa02=g_axv[l_ac].axv08 
               IF l_n = 0  THEN
                  CALL cl_err(g_axv[l_ac].axv08,'agl-118',0)
                  LET g_axv[l_ac].axv08 = g_axv_t.axv08
                  NEXT FIELD axv08 
                END IF
            ELSE     #順流&側流-下層公司
               SELECT count(*) INTO l_n FROM axb_file
                WHERE axb01=g_axv03 AND axb04=g_axv[l_ac].axv08
               IF l_n = 0  THEN
                  CALL cl_err(g_axv[l_ac].axv08,'agl-118',0) 
                  LET g_axv[l_ac].axv08 = g_axv_t.axv08
                  DISPLAY BY NAME g_axv[l_ac].axv08 
                  NEXT FIELD axv08  
               END IF
            END IF 
           #FUN-930059 ------------add end-------------------- 
           #   SELECT count(*) INTO l_n FROM axb_file                      #FUN-930059 mark
           #    WHERE axb01=g_axv03 AND axb04=g_axv[l_ac].axv08            #FUN-930059 mark
            CALL i012_axz(p_cmd,g_axv03,g_axv[l_ac].axv08,"t")
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axv[l_ac].axv08,g_errno,0)
               LET g_axv[l_ac].axv08 = g_axv_t.axv08
               DISPLAY BY NAME g_axv[l_ac].axv08
               NEXT FIELD axv08
            END IF
         ELSE
            CALL cl_err(g_axv[l_ac].axv08,"mfg5103",0)
            NEXT FIELD axv08
         END IF
 
      AFTER FIELD axv09
         IF NOT cl_null(g_axv[l_ac].axv09) THEN
            CALL i012_axee(p_cmd,g_axv[l_ac].axv07,g_axv[l_ac].axv09,"a")  #FUN-920095 mod
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axv[l_ac].axv09,g_errno,0)
               #FUN-B20004--begin
               CALL q_m_aag2(FALSE,FALSE,g_plant_new,g_axv[1].axv09,'23',g_aaz641)
                    RETURNING g_axv[l_ac].axv09             
               #LET g_axv[l_ac].axv09 = g_axv_t.axv09
               #FUN-B20004--end 
               DISPLAY BY NAME g_axv[l_ac].axv09
               NEXT FIELD axv09
            END IF
         ELSE
            CALL cl_err(g_axv[l_ac].axv09,"mfg5103",0)
            NEXT FIELD axv09
         END IF
 
      BEFORE FIELD axv10                                                                                                            
         IF g_axv[l_ac].axv06 = '3' THEN   #3.有型資產                                                                              
            CALL cl_set_comp_required("axv10",TRUE)                                                                                 
         ELSE                                                                                                                       
            CALL cl_set_comp_required("axv10",FALSE)                                                                                
         END IF                                                                                                                     

      AFTER FIELD axv10
         IF NOT cl_null(g_axv[l_ac].axv10) THEN
            CALL i012_axee(p_cmd,g_axv[l_ac].axv07,g_axv[l_ac].axv10,"t")  #FUN-920095 mod
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_axv[l_ac].axv10,g_errno,0)
               LET g_axv[l_ac].axv10 = g_axv_t.axv10
               DISPLAY BY NAME g_axv[l_ac].axv10
               NEXT FIELD axv10
            END IF
         ELSE
            IF g_axv[l_ac].axv06='3' THEN   #FUN-910002 add  
               CALL cl_err(g_axv[l_ac].axv10,"mfg5103",0)
               NEXT FIELD axv10
            END IF   #FUN-910002 add   
         END IF
 
      AFTER FIELD axv11
         IF NOT cl_null(g_axv[l_ac].axv11) THEN
            SELECT COUNT(*) INTO l_n FROM azi_file
             WHERE azi01 = g_axv[l_ac].axv11
            IF l_n = 0 THEN
               CALL cl_err(g_axv[l_ac].axv11,"agl-109",0)
               LET g_axv[l_ac].axv11 = g_axv_t.axv11
               NEXT FIELD axv11
            END IF
         ELSE
            CALL cl_err(g_axv[l_ac].axv11,"mfg5103",0)
            NEXT FIELD axv11
         END IF
 
      AFTER FIELD axv131
         IF l_ac>0 THEN
            IF cl_null(g_axv[l_ac].axv131) THEN
               LET g_axv[l_ac].axv131=0
               DISPLAY BY NAME g_axv[l_ac].axv131
            END IF
            IF cl_null(g_axv[l_ac].axv13) THEN
               LET g_axv[l_ac].axv13=0
               DISPLAY BY NAME g_axv[l_ac].axv13
            END IF
            LET g_axv[l_ac].axv14=g_axv[l_ac].axv13-g_axv[l_ac].axv131 
            DISPLAY BY NAME g_axv[l_ac].axv14
            IF g_axv[l_ac].axv05!='1' THEN   #FUN-910002 add                                                                        
               #逆、測流時, 
               #分配未實現利益(axv16)=未實現損益(axv14)*持股比率(axv15)/100
               LET g_axv[l_ac].axv16=g_axv[l_ac].axv14*g_axv[l_ac].axv15/100
            ELSE                                                                                                                    
               #順流時,分配未實現利益(axv16)=未實現損益(axv14)                                                                      
               LET g_axv[l_ac].axv16=g_axv[l_ac].axv14                                                                              
            END IF                                                                                                                  
         END IF
 
      AFTER FIELD axv14
         IF NOT cl_null(g_axv[l_ac].axv14) THEN
            IF g_axv[l_ac].axv05!='1' THEN   #FUN-910002 add  
               #逆、測流時,
               #分配未實現利益(axv16)=未實現損益(axv14)*持股比率(axv15)/100
               LET g_axv[l_ac].axv16=g_axv[l_ac].axv14*g_axv[l_ac].axv15/100
            ELSE                                                                                                                    
               #順流時,分配未實現利益(axv16)=未實現損益(axv14)                                                                      
               LET g_axv[l_ac].axv16=g_axv[l_ac].axv14                                                                              
            END IF                                                                                                                  
            DISPLAY BY NAME g_axv[l_ac].axv16
         END IF
 
      AFTER FIELD axv15
         IF NOT cl_null(g_axv[l_ac].axv15) THEN
            IF g_axv[l_ac].axv05!='1' THEN   #FUN-910002 add 
               #逆、測流時,
               #分配未實現利益(axv16)=未實現損益(axv14)*持股比率(axv15)/100
               LET g_axv[l_ac].axv16=g_axv[l_ac].axv14*g_axv[l_ac].axv15/100
            ELSE                                                                                                                    
               #順流時,分配未實現利益(axv16)=未實現損益(axv14)                                                                      
               LET g_axv[l_ac].axv16=g_axv[l_ac].axv14                                                                              
            END IF                                                                                                                  
            DISPLAY BY NAME g_axv[l_ac].axv16
         END IF

      BEFORE DELETE                            #是否取消單身
         IF g_axv_t.axv04 > 0 AND g_axv_t.axv04 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
 
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
 
            DELETE FROM axv_file
             WHERE axv01 = g_axv01 AND axv02 = g_axv02 AND axv03 = g_axv03
               AND axv031= g_axv031        #FUN-770086
               AND axv04 = g_axv_t.axv04   #FUN-780068 mod
               AND axv11 = g_axv_t.axv11   #FUN-930074
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","axv_file",g_axv01,g_axv_t.axv04,SQLCA.sqlcode,"","",1)
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
            LET g_axv[l_ac].* = g_axv_t.*
            CLOSE i012_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_axv[l_ac].axv04,-263,1)
            LET g_axv[l_ac].* = g_axv_t.*
         ELSE
            UPDATE axv_file SET axv04 = g_axv[l_ac].axv04,
                                axv05 = g_axv[l_ac].axv05,
                                axv06 = g_axv[l_ac].axv06,
                                axv07 = g_axv[l_ac].axv07, 
                                axv08 = g_axv[l_ac].axv08, 
                                axv09 = g_axv[l_ac].axv09, 
                                axv10 = g_axv[l_ac].axv10, 
                                axv11 = g_axv[l_ac].axv11, 
                                axv12 = g_axv[l_ac].axv12, 
                                axv13 = g_axv[l_ac].axv13, 
                                axv131= g_axv[l_ac].axv131,  #FUN-770086
                                axv14 = g_axv[l_ac].axv14, 
                                axv15 = g_axv[l_ac].axv15, 
                                axv16 = g_axv[l_ac].axv16,
                                axv17 = g_axv[l_ac].axv17    #FUN-770086  
             WHERE axv01 = g_axv01 AND axv02 = g_axv02 
               AND axv03 = g_axv03 AND axv031 = g_axv031  #FUN-770086  
               AND axv04 = g_axv_t.axv04
               AND axv11 = g_axv_t.axv11   #FUN-930074
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","axv_file",g_axv01,g_axv_t.axv04,SQLCA.sqlcode,"","",1)
               LET g_axv[l_ac].* = g_axv_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac   #FUN-D0032 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
           #LET g_axv[l_ac].* = g_axv_t.*  #FUN-D0032 mark
            #FUN-D30032--add--begin--
            IF p_cmd = 'u' THEN
               LET g_axv[l_ac].* = g_axv_t.*
            ELSE
               CALL g_axv.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            END IF
            #FUN-D30032--add--end----
            CLOSE i012_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac   #FUN-D0032 add 
         LET g_axv_t.* = g_axv[l_ac].*  
         CLOSE i012_bcl
         COMMIT WORK
         CALL g_axv.deleteElement(g_rec_b+1)
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axv07)     #來源公司 
                 CALL cl_init_qry_var()
                #FUN-930059 -----mod start------------------   
                #LET g_qryparam.form ="q_axz1"
                 IF g_axv[l_ac].axv05='1' THEN      #順流-上層公司
                    LET g_qryparam.form ="q_axa3"
                 ELSE
                    LET g_qryparam.form ="q_axb5"   #逆流&側流-下層公司
                 END IF 
                #FUN-930059 -------mod end---------------------
                 LET g_qryparam.default1 = g_axv[l_ac].axv07
                 LET g_qryparam.arg1 = g_axv03
                 CALL cl_create_qry() RETURNING g_axv[l_ac].axv07
                 DISPLAY BY NAME g_axv[l_ac].axv07 
                 NEXT FIELD axv07
            WHEN INFIELD(axv08)     #交易公司
                 CALL cl_init_qry_var()
                #FUN-930059 ----------mod start-----------------
                #LET g_qryparam.form ="q_axz1"
                 IF g_axv[l_ac].axv05='2' THEN            #逆流-上層公司
                    LET g_qryparam.form ="q_axa3"
                 ELSE
                    LET g_qryparam.form ="q_axb5"         #順流&側流-下層公司  
                 END IF 
                #FUN-930059 --------mod end---------------------
                 LET g_qryparam.default1 = g_axv[l_ac].axv08
                 LET g_qryparam.arg1 = g_axv03
                 CALL cl_create_qry() RETURNING g_axv[l_ac].axv08
                 DISPLAY BY NAME g_axv[l_ac].axv08 
                 NEXT FIELD axv08
            WHEN INFIELD(axv09)     #帳列科目
                 CALL q_m_aag2(FALSE,TRUE,g_plant_new,g_axv[1].axv09,'23',g_aaz641)#TQC-9C0099  
                      RETURNING g_qryparam.multiret                  
                 LET g_axv[l_ac].axv09=g_qryparam.multiret                  
                 DISPLAY BY NAME g_axv[l_ac].axv09 
                 NEXT FIELD axv09
            WHEN INFIELD(axv10)     #交易科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_axe1"
                 LET g_qryparam.default1 = g_axv[l_ac].axv10
                 SELECT axz05 INTO l_axz05 FROM axz_file WHERE axz01=g_axv[l_ac].axv07
                 LET g_qryparam.arg1 = l_axz05
                 LET g_qryparam.arg2 = g_axv[l_ac].axv07
                 LET g_qryparam.arg3 = g_axv03        #FUN-910001 add                                                               
                 LET g_qryparam.arg4 = g_aaz.aaz641   #FUN-910001 add 
                 CALL cl_create_qry() RETURNING g_axv[l_ac].axv10
                 DISPLAY BY NAME g_axv[l_ac].axv10
                 NEXT FIELD axv10
            WHEN INFIELD(axv11)     #交易幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_axv[l_ac].axv11
                 CALL cl_create_qry() RETURNING g_axv[l_ac].axv11
                 DISPLAY BY NAME g_axv[l_ac].axv11
                 NEXT FIELD axv11
            OTHERWISE 
                 EXIT CASE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(axv04) AND l_ac > 1 THEN
            LET g_axv[l_ac].* = g_axv[l_ac-1].*
            LET g_axv[l_ac].axv04 = g_axv[l_ac-1].axv04 + 1 
            NEXT FIELD axv04
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
 
   CLOSE i012_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i012_axz(p_cmd,p_axv03,p_axz01,p_st)
   DEFINE p_cmd       LIKE type_file.chr1,
          p_axv03     LIKE axv_file.axv03,
          p_axz01     LIKE axz_file.axz01,
          p_st        LIKE type_file.chr1,
          l_axz02     LIKE axz_file.axz02 
        # l_axzacti   LIKE axz_file.axzacti           #FUN-920123 mark

   SELECT axz02 INTO l_axz02                      #FUN-920095 mod
     FROM axz_file
    WHERE axz01=p_axz01
      AND (axz01 IN (SELECT DISTINCT axb02 FROM axb_file WHERE axb01=p_axv03)
       OR  axz01 IN (SELECT DISTINCT axb04 FROM axb_file WHERE axb01=p_axv03))
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-949'
                               LET l_axz02 = NULL
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_st = "s" THEN   #來源公司
         LET g_axv[l_ac].axz02_s = l_axz02
         DISPLAY BY NAME g_axv[l_ac].axz02_s
      ELSE                 #交易公司
         LET g_axv[l_ac].axz02_t = l_axz02
         DISPLAY BY NAME g_axv[l_ac].axz02_t
      END IF
   END IF
 
END FUNCTION
 
FUNCTION i012_axee(p_cmd,p_axee01,p_axee06,p_at)   #FUN-920095 mod
   DEFINE p_cmd       LIKE type_file.chr1,
          p_axee01    LIKE axee_file.axee01,      #FUN-920095 
          p_axee06    LIKE axee_file.axee06,      #FUn-920095 
          p_at        LIKE type_file.chr1,
          l_aag02     LIKE aag_file.aag02,
          l_aagacti   LIKE aag_file.aagacti
 
    LET g_sql = "SELECT aag02,aagacti ",
               #"  FROM ",g_dbs_axz03,"aag_file ",  #FUN-A50102
                "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),   #FUN-A50102
                " WHERE aag00 = '",g_aaz641,"'",                
                "   AND aag01 = '",p_axee06,"'"
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE i012_pre_1 FROM g_sql
    DECLARE i012_cur_1 CURSOR FOR i012_pre_1
    OPEN i012_cur_1
    FETCH i012_cur_1 INTO l_aag02,l_aagacti 
                                                                     
    IF SQLCA.sqlcode  THEN LET l_aag02 = '' END IF
   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'agl-916'
                               LET l_aag02 = NULL
      WHEN l_aagacti = 'N'     LET g_errno = '9028'
      OTHERWISE                LET g_errno = SQLCA.sqlcode USING '------'
   END CASE 
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      IF p_at = "a" THEN   #帳列科目
         LET g_axv[l_ac].aag02_a = l_aag02
         DISPLAY BY NAME g_axv[l_ac].aag02_a
      ELSE                 #交易科目
         LET g_axv[l_ac].aag02_t = l_aag02
         DISPLAY BY NAME g_axv[l_ac].aag02_t
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION i012_bp(p_ud)
   DEFINE p_ud     LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_axv TO s_axv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
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
 
      ##已實現損益維護 #FUN-770086
      ON ACTION prif
         LET g_action_choice="prif"
         EXIT DISPLAY
 
#FUN-A90039 --Begin
      ON ACTION rate
         LET g_action_choice="rate"
         EXIT DISPLAY
#FUN-A90039 --End

      ON ACTION exporttoexcel   
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i012_copy()
DEFINE l_axv              RECORD LIKE axv_file.*,
       l_old01,l_new01    LIKE axv_file.axv01,
       l_old02,l_new02    LIKE axv_file.axv02,
       l_old03,l_new03    LIKE axv_file.axv03,
       l_old031,l_new031  LIKE axv_file.axv031, #FUN-770086
       l_n                LIKE type_file.num5 
     # l_acti             LIKE axz_file.axzacti #FUN-770086   #FUN-920123 mark
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_axv01) OR cl_null(g_axv02) OR 
      cl_null(g_axv03) OR cl_null(g_axv031) THEN #FUN-770086
      CALL cl_err('',-400,0) RETURN
   END IF
 
   INPUT l_new01,l_new02,l_new03,l_new031 FROM axv01,axv02,axv03,axv031  #FUN-770086
      AFTER FIELD axv01
         IF NOT cl_null(l_new01) THEN
            SELECT count(*) INTO g_cnt FROM axv_file
             WHERE axv01 = l_new01 AND axv02 = l_new02 
               AND axv03 = l_new03 AND axv03 = l_new031 #FUN-770086
            IF g_cnt > 0 THEN
               CALL cl_err(l_new01,-239,0)
               NEXT FIELD axv01
            END IF
         END IF
 
      AFTER FIELD axv02
         IF NOT cl_null(l_new02) THEN
            SELECT count(*) INTO g_cnt FROM axv_file
             WHERE axv01 = l_new01 AND axv02 = l_new02 
               AND axv03 = l_new03 AND axv03 = l_new031 #FUN-770086
            IF g_cnt > 0 THEN
               CALL cl_err(l_new02,-239,0)
               NEXT FIELD axv02
            END IF
         END IF
 
      AFTER FIELD axv03
         IF NOT cl_null(l_new03) THEN
           #FUN-930059 -------------mark start-----------------------   
           #SELECT count(*) INTO g_cnt FROM axv_file
           # WHERE axv01 = l_new01 AND axv02 = l_new02 
           #   AND axv03 = l_new03 AND axv03 = l_new031 #FUN-770086
           #IF g_cnt > 0 THEN
           #   CALL cl_err(l_new03,-239,0)
           #   NEXT FIELD axv03
           #END IF
           #FUN-930059 ------------mark end-------------------------- 
            SELECT COUNT(*) INTO l_n FROM axa_file WHERE axa01 = l_new03
            IF l_n = 0 THEN 
               CALL cl_err3("sel","axa_file",l_new03,"","agl-117","","",1)
               NEXT FIELD axv03
            END IF
         END IF
 
      AFTER FIELD axv031   #上層公司
         IF NOT cl_null(l_new031) THEN
            SELECT count(*) INTO g_cnt FROM axv_file
             WHERE axv01 = l_new01 AND axv02 = l_new02 
               AND axv03 = l_new03 AND axv03 = l_new031 
            IF g_cnt > 0 THEN
               CALL cl_err(l_new03,-239,0)
               NEXT FIELD axv03
            END IF

            SELECT count(*) INTO l_n FROM axa_file
             WHERE axa01=l_new03 AND axa02=l_new031

            IF l_n = 0  THEN
               CALL cl_err(l_new031,'agl-118',0)
               NEXT FIELD axv031
            END IF

            CALL i012_set_axz02(l_new031,l_new03)  #FUN-770086    #FUN-950051 add l_new03
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(axv03)   #族群代號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_axa1"
               LET g_qryparam.default1 = l_new03
               CALL cl_create_qry() RETURNING l_new03
               DISPLAY l_new03 TO axv03 
               NEXT FIELD axv03
            WHEN INFIELD(axv031)    #上層公司
                 CALL cl_init_qry_var()
                #FUN-930059 ---------mod start---------------- 
                #LET g_qryparam.form ="q_axz"
                 LET g_qryparam.form ="q_axa3"
                 LET g_qryparam.arg1 =l_new03 
                 LET g_qryparam.default1 = l_new031 
                #CALL cl_create_qry() RETURNING g_axv031
                #DISPLAY g_axv031 TO axv031
                 CALL cl_create_qry() RETURNING l_new031
                 DISPLAY l_new031 TO axv031
                #FUN-930059 ---------mod end---------------- 
                 NEXT FIELD axv031
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
      DISPLAY g_axv01 TO axv01 
      DISPLAY g_axv02 TO axv02 
      DISPLAY g_axv03 TO axv03 
      DISPLAY g_axv031 TO axv031
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM axv_file         #單頭複製
    WHERE axv01 = g_axv01 AND axv02 = g_axv02 
      AND axv03 = g_axv03 AND axv031 = g_axv031 #FUN-770086
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x", g_axv01,g_axv02,SQLCA.sqlcode,"","",1)
      RETURN
   END IF
 
   UPDATE x
      SET axv01 = l_new01 , axv02 = l_new02 , axv03 = l_new03 , 
          axv031 = l_new031 #FUN-770086
 
   INSERT INTO axv_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","axv_file",l_new01,l_new02,SQLCA.sqlcode,"","axv",1)
      RETURN
   END IF
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_new01,') O.K'
       
   LET l_old01 = g_axv01 
   LET l_old02 = g_axv02 
   LET l_old03 = g_axv03 
   LET l_old031= g_axv031 #FUN-770086
 
   SELECT UNIQUE axv01,axv02,axv03,axv031 INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
     FROM axv_file 
    WHERE axv01 = l_new01 AND axv02 = l_new02 AND axv03 = l_new03 
      AND axv031= l_new031 #FUN-770086
 
   CALL i012_b()
   #FUN-C30027---begin
   #SELECT UNIQUE axv01,axv02,axv03 INTO g_axv01,g_axv02,g_axv03,g_axv031 #FUN-770086
   #  FROM axv_file 
   # WHERE axv01 = l_old01 AND axv02 = l_old02 AND axv03 = l_old03 
   #   AND axv031= l_old031 #FUN-770086
   #
   #CALL i012_show()
   #FUN-C30027---end
END FUNCTION
 
FUNCTION i012_out()
   DEFINE l_wc STRING #FUN-770086
 
   IF g_wc IS NULL THEN CALL cl_err('','9057',0) RETURN END IF
 
   CALL cl_wait()
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'agli012'
 
   #組合出 SQL 指令
   LET g_sql="SELECT DISTINCT A.axv01,A.axv02,A.axv03,A.axv031,", #FUN-770086
             "       G.axz02 axv031_d,A.axv04,A.axv05,A.axv06,",
             "       A.axv07,B.axz02 axz02_s,A.axv08,C.axz02 axz02_t,",
             "       A.axv09,D.aag02 aag02_a,A.axv10,E.aag02 aag02_t,",
             "       A.axv11,A.axv12,A.axv13,A.axv131,A.axv14,A.axv15,", #FUN-770086
             "       A.axv16,F.azi04 ",
             "  FROM axv_file A,axz_file B,axz_file C,",
             "       aag_file D,aag_file E,azi_file F,",
             "       axz_file G", #FUN-770086
             " WHERE A.axv07 = B.axz01",
             "   AND A.axv08 = C.axz01",
             "   AND A.axv09 = D.aag01",
             "   AND A.axv10 = E.aag01",
             "   AND A.axv11 = F.azi01",
             "   AND A.axv031= G.axz01", #FUN-770086
             "   AND ",g_wc CLIPPED,
             " ORDER BY A.axv01,A.axv02,A.axv03,A.axv04"
   PREPARE i012_p1 FROM g_sql                # RUNTIME 編譯
   DECLARE i012_co  CURSOR FOR i012_p1
 
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
      CALL cl_wcchp(g_wc,'axv01,axv02,axv03,axv031,axv04,axv05,axv06,axv07,axv08,axv09,axv10,axv11,axv12,axv13,axv131,axv14,axv15,axv16') #FUN-770086
           RETURNING l_wc #FUN-770086
   ELSE
      LET l_wc = '' #FUN-770086
   END IF
 
   CALL cl_prt_cs1('agli012','agli012',g_sql,l_wc) #FUN-770086
 
END FUNCTION
 
FUNCTION i012_set_axz02(l_axv031,l_axv03)   #FUN-950051 add axv03
   DEFINE l_axz02 LIKE axz_file.axz02
   DEFINE l_axv031 LIKE axv_file.axv031
   DEFINE l_axz03  LIKE axz_file.axz03     #FUN-920095 add
   DEFINE l_axa09  LIKE axa_file.axa09     #FUN-950051
   DEFINE l_axv03  LIKE axv_file.axv03     #FUN-950051
 
   IF l_axv031 IS NULL THEN 
      DISPLAY NULL TO FORMONLY.axz02
      RETURN
   END IF
#FUN-A30122 ---------------------mark start----------------------
#  SELECT axa09 INTO l_axa09 FROM axa_file 
#   WHERE axa01 = l_axv03   #群族
#     AND axa02 = l_axv031  #公司編號
#  IF l_axa09 = 'Y' THEN
#      SELECT axz03 INTO l_axz03    
#        FROM axz_file
#       WHERE axz01 = l_axv031 
#
#       LET g_plant_new = l_axz03      #營運中心
#       CALL s_getdbs()
#       LET g_dbs_axz03 = g_dbs_new    #所屬DB
#
#      #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",  #FUN-A50102
#       LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(g_plant_new,'aaz_file'),  #FUN-A50102
#                   " WHERE aaz00 = '0'"
#       CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A50102
#       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
#       PREPARE i012_pre FROM g_sql
#       DECLARE i012_cur CURSOR FOR i012_pre
#       OPEN i012_cur
#       FETCH i012_cur INTO g_aaz641    #合併後帳別
#       IF cl_null(g_aaz641) THEN
#           CALL cl_err(l_axz03,'agl-601',1)
#       END IF
#  ELSE
#       LET g_plant_new = g_plant  #TQC-9C0099
#       LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)
#       SELECT aaz641 INTO g_aaz641 FROM aaz_file WHERE aaz00 = '0'
#  END IF   
   CALL s_aaz641_dbs(l_axv03,l_axv031) RETURNING g_plant_axz03       #FUN-A30122 add                
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641               #FUN-A30122 add
   LET g_plant_new = g_plant_axz03                                   #FUN-A30122 add 
#FUN-A30122 ------------------mark end-------------------------------

   SELECT axz02 INTO l_axz02 FROM axz_file
                            WHERE axz01=l_axv031
   DISPLAY l_axz02 TO FORMONLY.axz02
END FUNCTION
 
#FUN-920123 ---------------mark start-----------------
{
FUNCTION i012_chk_axv031(l_axv031)
   DEFINE l_axzacti LIKE axz_file.axzacti
   DEFINE l_axv031 LIKE axv_file.axv031
 
   IF NOT cl_null(l_axv031) THEN
      SELECT axzacti INTO l_axzacti FROM axz_file WHERE axz01 = l_axv031
      CASE
         WHEN l_axzacti="N"
            CALL cl_err3("sel","axz_file",l_axv031,"","9028","","",1)
            DISPLAY NULL TO FORMOLNY.axz02
            RETURN FALSE
         WHEN SQLCA.sqlcode
            CALL cl_err3("sel","axz_file",l_axv031,"",
                          SQLCA.sqlcode,"","",1)
            DISPLAY NULL TO FORMOLNY.axz02
            RETURN FALSE
      END CASE
   END IF
   RETURN TRUE
END FUNCTION
}
#FUN-920123 ---------------mark end------------------
#No.FUN-9C0072 精簡程式碼
#FUN-A90039 --Begin
FUNCTION i012_rate_batch()
DEFINE l_rate    LIKE type_file.num20_6
DEFINE l_axv131  LIKE axv_file.axv131
DEFINE l_axv11   LIKE axv_file.axv11
DEFINE l_axv12   LIKE axv_file.axv12
DEFINE l_axv14   LIKE axv_file.axv14
DEFINE l_axv04   LIKE axv_file.axv04
DEFINE l_azi04   LIKE azi_file.azi04


   OPEN WINDOW i012_w1
     WITH FORM "agl/42f/agli0121"  ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("agli0121")

   INPUT l_rate WITHOUT DEFAULTS FROM rate

     #AFTER FIELD rate
     #   IF NOT cl_null(g_aba.aba14) THEN
     #      IF g_aba.aba14 = '0' THEN
     #         LET INT_FLAG = 1
     #         EXIT INPUT
     #      END IF
     #      IF g_aba.aba14 NOT MATCHES "[123]" THEN
     #         NEXT FIELD aba14
     #      END IF
     #   END IF
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
   LET g_sql = " SELECT axv04,axv11,axv12 ",
               "   FROM axv_file ",
               "  WHERE axv01 = ",g_axv01 CLIPPED,
               "   AND axv02 =  ",g_axv02 CLIPPED,
               "   AND axv03 = '",g_axv03 CLIPPED,"'",
               "   AND axv031= '",g_axv031 CLIPPED,"'",
               "   AND ",g_wc CLIPPED
   PREPARE i012_prepare4 FROM g_sql
   DECLARE i012_cs4 CURSOR FOR i012_prepare4
   FOREACH i012_cs4 INTO l_axv04,l_axv11,l_axv12
      SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01=l_axv11
      LET l_axv14 = l_axv12*l_rate/100
      CALL cl_digcut(l_axv14,l_azi04) RETURNING l_axv14
      LET l_axv131= l_axv12-l_axv12*l_rate/100
      CALL cl_digcut(l_axv131,l_azi04) RETURNING l_axv131
      UPDATE axv_file SET axv14 = l_axv14,
                          axv131= l_axv131
       WHERE axv01 = g_axv01
         AND axv02 = g_axv02
         AND axv03 = g_axv03
         AND axv04 = l_axv04
         AND axv11 = l_axv11
         AND axv031= g_axv031
   END FOREACH
  #LET l_rate=l_rate/100
  #LET g_sql = " UPDATE axv_file SET axv14=axv12*",l_rate,",",
  #            "                     axv131=axv12-axv12*",l_rate,
  #            "  WHERE axv01 = ",g_axv01 CLIPPED,
  #            "   AND axv02 =  ",g_axv02 CLIPPED,
  #            "   AND axv03 = '",g_axv03 CLIPPED,"'",
  #            "   AND axv031= '",g_axv031 CLIPPED,"'",
  #            "   AND ",g_wc CLIPPED
  #PREPARE i012_prepare3 FROM g_sql
  #EXECUTE i012_prepare3

   CALL i012_b_fill(g_wc)                 #單身

END FUNCTION
#FUN-A90039 --End

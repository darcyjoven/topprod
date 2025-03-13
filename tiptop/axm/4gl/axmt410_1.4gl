# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axmt410_1.4gl
# Descriptions...: 一般訂單二維單身維護
# Date & Author..: 08/02/27 xumin No.FUN-820046
# Modify.........: No.FUN-830089 08/03/31 BY xumin MOD-840383二維單身功能修改
# Modify.........: No.FUN-840036 08/04/09 BY xumin FUN-830116 二維單身功能修改
# Modify.........: No.FUN-870117 08/09/25 by ve007 二維單身功能修改
# Modify.........: No.FUN-8A0129 08/10/28 by hongmei 去掉NOWAIT
# Modify.........: No.FUN-8A0145 08/10/28 by hongmei 欄位類型修改
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-920186 09/03/19 By lala  理由碼oeb1001必須為銷售原因
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980010 09/08/24 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9C0083 09/12/16 By mike 取价call s_fetch_price_new() 
# Modify.........: No.FUN-9C0120 09/12/21 By mike 通过价格条件管控未取到价格时单价栏位是否可以人工输入
# Modify.........: No:TQC-980026 09/12/29 By baofei取一筆ocq02
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No.FUN-AA0059 10/10/25 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0025 10/11/11 By vealxu 全系統增加料件管控
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 在CALL s_fetch_price_new的地方返回參數中加上基礎單價 
# Modify.........: No.FUN-B20060 11/04/07 By zhangll 增加oeb72赋值
# Modify.........: No:FUN-B70087 11/07/21 By zhangll 增加oah07控管，s_unitprice_entry增加传参
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90101 11/11/28 By lixiang 服飾二維開發，新增oeb_file後同步新增母料件oebslk_file的資料
# Modify.........: No.FUN-910088 12/01/18 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BC0071 12/02/08 By huangtao 增加取價參數
# Modify.........: No.FUN-C40089 12/05/02 By bart 判斷銷售價格條件(axmi060)的oah08,若oah08為Y則單價欄位可輸入0;若oah08為N則單價欄位不可輸入0
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No.FUN-C50074 12/05/18 By bart 更改錯誤訊息代碼
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.......... No:FUN-C90014 12/09/05 By huangrh 修改att對null和空格的判斷
# Modify.......... No:FUN-C90047 12/09/11 By huangrh 修正BUG的，保證同一屬性群組下不同的屬性組有相同的屬性值時，能解析正確，多屬性的正確顯示。
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt400.global"
 
DEFINE   g_oeb931         LIKE oeb_file.oeb931,   # 包裝方式 (假單頭)
         g_oeb931_t       LIKE oeb_file.oeb931,   # 包裝方式 (假單頭)
         g_oeb932         LIKE oeb_file.oeb932,   # 包裝箱數 (假單頭)
         g_oeb932_t       LIKE oeb_file.oeb932,   # 包裝箱數 (假單頭)
         g_oeb933         LIKE oeb_file.oeb933,   # 末維屬性組 (假單頭)
         g_oeb933_t       LIKE oeb_file.oeb933,   # 末維屬性組 (假單頭)
         g_oeb934         LIKE oeb_file.oeb934,   # 屬性群組 (假單頭)
         g_oeb934_t       LIKE oeb_file.oeb934,   # 屬性群組 (假單頭)
         g_oeb01          LIKE oeb_file.oeb01,
         g_oeb04          LIKE oeb_file.oeb04,
         g_oeb06          LIKE oeb_file.oeb06,
         g_oeb_lock RECORD LIKE oeb_file.*,      # FOR LOCK CURSOR TOUCH
         g_num     DYNAMIC ARRAY OF RECORD
                   num1   LIKE oeb_file.oeb12
                   END RECORD,
         g_oeb5    DYNAMIC ARRAY of RECORD        # 程式變數
            att00          LIKE ima_file.ima01,
            att01          LIKE ima_file.ima02,
            att02          LIKE agd_file.agd02,
            att02_c        LIKE agd_file.agd02,
            att03          LIKE agd_file.agd02,
            att03_c        LIKE agd_file.agd02,
            att04          LIKE obj_file.obj06,
            att05          LIKE obj_file.obj06,
            att06          LIKE obj_file.obj06,
            att07          LIKE obj_file.obj06,
            att08          LIKE obj_file.obj06,
            att09          LIKE obj_file.obj06,
            att10          LIKE obj_file.obj06,
            att11          LIKE obj_file.obj06,
            att12          LIKE obj_file.obj06,
            att13          LIKE obj_file.obj06,
            oeb03          LIKE oeb_file.oeb03,     #項次
            oeb04          LIKE oeb_file.oeb04,     #款式編號
            oeb05          LIKE oeb_file.oeb05,     #銷售單位
            oeb916         LIKE oeb_file.oeb916,    #計價單位
            oeb15          LIKE oeb_file.oeb15,     #約定交貨日
            oeb1002        LIKE oeb_file.oeb1002,   #定價編號
            oeb1004        LIKE oeb_file.oeb1004,   #提案編號
            oeb13          LIKE oeb_file.oeb13,     #單價
            oeb1001        LIKE oeb_file.oeb1001,   #理由碼
            oeb1012        LIKE oeb_file.oeb1012,   #搭贈
            oebislk01      LIKE oebi_file.oebislk01 #制單編號 
                      END RECORD,
         g_oeb5_t           RECORD                 # 變數舊值
            att00          LIKE ima_file.ima01,
            att01          LIKE ima_file.ima02,
            att02          LIKE agd_file.agd02,
            att02_c        LIKE agd_file.agd02,
            att03          LIKE agd_file.agd02,
            att03_c        LIKE agd_file.agd02,
            att04          LIKE obj_file.obj06,
            att05          LIKE obj_file.obj06,
            att06          LIKE obj_file.obj06,
            att07          LIKE obj_file.obj06,
            att08          LIKE obj_file.obj06,
            att09          LIKE obj_file.obj06,
            att10          LIKE obj_file.obj06,
            att11          LIKE obj_file.obj06,
            att12          LIKE obj_file.obj06,
            att13          LIKE obj_file.obj06,
            oeb03          LIKE oeb_file.oeb03,
            oeb04          LIKE oeb_file.oeb04,
            oeb05          LIKE oeb_file.oeb05,
            oeb916         LIKE oeb_file.oeb916,
            oeb15          LIKE oeb_file.oeb15,
            oeb1002        LIKE oeb_file.oeb1002,
            oeb1004        LIKE oeb_file.oeb1004,
            oeb13          LIKE oeb_file.oeb13,
            oeb1001        LIKE oeb_file.oeb1001,
            oeb1012        LIKE oeb_file.oeb1012,
            oebislk01      LIKE oebi_file.oebislk01 
                      END RECORD,
         g_dis    DYNAMIC ARRAY of RECORD        # 程式變數
            att00          LIKE ima_file.ima01,
            att01          LIKE ima_file.ima02,
            att02          LIKE agd_file.agd02,
            att02_c        LIKE agd_file.agd02,
            att03          LIKE agd_file.agd02,
            att03_c        LIKE agd_file.agd02,
            att04          LIKE obj_file.obj06,
            att05          LIKE obj_file.obj06,
            att06          LIKE obj_file.obj06,
            att07          LIKE obj_file.obj06,
            att08          LIKE obj_file.obj06,
            att09          LIKE obj_file.obj06,
            att10          LIKE obj_file.obj06,
            att11          LIKE obj_file.obj06,
            att12          LIKE obj_file.obj06,
            att13          LIKE obj_file.obj06,
            oeb03          LIKE oeb_file.oeb03,     #項次
            oeb04          LIKE oeb_file.oeb04,     #款式編號
            oeb05          LIKE oeb_file.oeb05,     #銷售單位
            oeb916         LIKE oeb_file.oeb916,    #計價單位
            oeb15          LIKE oeb_file.oeb15,     #約定交貨日
            oeb1002        LIKE oeb_file.oeb1002,   #定價編號
            oeb1004        LIKE oeb_file.oeb1004,   #提案編號
            oeb13          LIKE oeb_file.oeb13,     #單價
            oeb1001        LIKE oeb_file.oeb1001,   #理由碼
            oeb1012        LIKE oeb_file.oeb1012,   #搭贈
            oebislk01      LIKE oebi_file.oebislk01 #制單編號 
                      END RECORD,
         g_cnt2                LIKE type_file.num5,  
         g_wc                  STRING, 
         g_wc1                 STRING,
         g_sql                 STRING,
         g_ss                  LIKE type_file.chr1,    # 決定後續步驟 
         g_rec_b               LIKE type_file.num5,    # 單身筆數    
         l_ac                  LIKE type_file.num5     # 目前處理的ARRAY CNT 
DEFINE   g_chr                 LIKE type_file.chr1    
DEFINE   g_cnt                 LIKE type_file.num10   
DEFINE   g_msg                 LIKE type_file.chr1000 
DEFINE   g_forupd_sql          STRING
DEFINE   g_before_input_done   LIKE type_file.num5   
DEFINE   g_argv1               LIKE oeb_file.oeb01
DEFINE   g_curs_index          LIKE type_file.num10 
DEFINE   g_row_count           LIKE type_file.num10 
DEFINE   g_jump                LIKE type_file.num10
DEFINE   g_no_ask              LIKE type_file.num5  
DEFINE   g_std_id              LIKE smb_file.smb01 
DEFINE   g_db_type             LIKE type_file.chr3 
DEFINE   g_sma         RECORD  LIKE sma_file.*
DEFINE   g_show                STRING
DEFINE arr_show            DYNAMIC ARRAY OF RECORD
       att00             LIKE ima_file.ima01,
       att               ARRAY[13] OF LIKE obj_file.obj06 
       END RECORD 
DEFINE   arr_detail          DYNAMIC ARRAY OF RECORD                                                                                  
           imx00             LIKE imx_file.imx00,                                                                                       
           imx               ARRAY[13] OF LIKE imx_file.imx01                                                                           
         END RECORD
DEFINE   g_oah08               LIKE oah_file.oah08   #FUN-C40089
 
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP,
      FIELD ORDER FORM
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)
   LET g_oea.oea01 = g_argv1
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   IF cl_null(g_argv1) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_oeb931_t = NULL
   LET g_oeb932_t = NULL
   LET g_oeb933_t = NULL  
   LET g_oeb934_t = NULL 
   #FUN-C40089---begin
   SELECT oah08 INTO g_oah08 FROM oah_file,oea_file WHERE oah01=oea31 AND oea01=g_argv1 
   IF cl_null(g_oah08) THEN
      LET g_oah08 = 'Y'
   END IF  
   #FUN-C40089---end
 
   #一般行業別代碼
   LET g_std_id = "slk"   
   SELECT * INTO g_sma.* FROM sma_file
 
   SELECT * INTO g_oea.* FROM oea_file
    WHERE oea01 = g_argv1
   OPEN WINDOW t410_1_w WITH FORM "axm/42f/axmt400x"
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   IF g_sma.sma128 NOT MATCHES '[Yy]' THEN
      CALL cl_set_comp_visible("oeb931,oeb931_obi02,oeb932",FALSE)
   ELSE
      CALL cl_set_comp_visible("oeb931,oeb931_obi02,oeb932",TRUE)
   END IF
 
   LET g_db_type=cl_db_get_database_type()
 
   LET g_forupd_sql =" SELECT * FROM oeb_file ",  
                      "  WHERE oeb01 = ? ",
                      "   AND oeb931 = ? ",
                      "   AND oeb933 = ? ",
                      "   AND oeb934 = ? ",
                      " FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t410_1_lock_u CURSOR FROM g_forupd_sql
 
   IF NOT cl_null(g_argv1) THEN
      CALL t410_1_q()
   END IF
 
   CALL t410_1_menu() 
 
   CLOSE WINDOW t410_1_w                       # 結束畫面
     CALL  cl_used(g_prog,g_time,2)             # 計算使用時間 (退出時間) 
         RETURNING g_time  
END MAIN
 
FUNCTION t410_1_curs()                         # QBE 查詢資料
   CLEAR FORM                                    # 清除畫面
   CALL g_oeb5.clear()
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc1 = "oeb01 = '",g_argv1 CLIPPED,"' "
      LET g_wc = " 1=1"
   ELSE
      LET g_wc1 = " 1=1"
      CALL cl_set_head_visible("","YES")  
 
      CONSTRUCT g_wc ON oeb931,oeb934,oeb932,oeb933,oeb05,oeb916,oeb15,oeb1002,oeb1004,
                        oeb13,oeb1001,oeb1012,oebislk01
                   FROM oeb931,oeb934,oeb932,oeb933,tb5[1].oeb05,tb5[1].oeb916,
                        tb5[1].oeb15,tb5[1].oeb1002,tb5[1].oeb1004,tb5[1].oeb13,
                        tb5[1].oeb1001,tb5[1].oeb1012,tb5[1].oebislk01
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(oeb931)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oeb931"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb931
                  NEXT FIELD oeb931
               WHEN INFIELD(oeb934)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oeb934"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb934
                  NEXT FIELD oeb934
               WHEN INFIELD(oeb933)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_oeb933"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb933
                  NEXT FIELD oeb933
               WHEN INFIELD(oeb1001)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azf03"
                  LET g_qryparam.arg1 = '2'
                  LET g_qryparam.arg2 = '1'
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oeb1001
                  NEXT FIELD oeb1001
               OTHERWISE
                  EXIT CASE
            END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
          ON ACTION help
             CALL cl_show_help()
          ON ACTION controlg
             CALL cl_cmdask()
          ON ACTION about
             CALL cl_about()
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   END IF
 
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql= "SELECT UNIQUE oeb01,oeb931,oeb933,oeb934 FROM oeb_file ", 
              " WHERE ", g_wc1 CLIPPED,
              "   AND ", g_wc  CLIPPED,
              " ORDER BY oeb01" 
 
   PREPARE t410_1_prepare FROM g_sql          # 預備一下
   DECLARE t410_1_b_curs                      # 宣告成可捲動的
      SCROLL CURSOR WITH HOLD FOR t410_1_prepare
 
END FUNCTION
 
 # 選出筆數直接寫入 g_row_count
FUNCTION t410_1_count()
 
   DEFINE la_oeb   DYNAMIC ARRAY of RECORD        # 程式變數
            oeb01          LIKE oeb_file.oeb01,
            oeb11          LIKE oeb_file.oeb11,
            oeb12          LIKE oeb_file.oeb12 
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num10  
   DEFINE li_rec_b LIKE type_file.num10 
   DEFINE l_oeb931 LIKE oeb_file.oeb931
   DEFINE l_oeb933 LIKE oeb_file.oeb933
   DEFINE l_oeb934 LIKE oeb_file.oeb934
   DEFINE l_oeb01  LIKE oeb_file.oeb01 
 
   LET g_sql= "SELECT DISTINCT oeb01,oeb931,oeb933,oeb934 FROM oeb_file ", 
              " WHERE ", g_wc1 CLIPPED,
              "   AND ", g_wc  CLIPPED 
 
   LET li_rec_b = 0
   PREPARE t410_1_precount FROM g_sql
   DECLARE t410_1_count CURSOR FOR t410_1_precount
   FOREACH t410_1_count INTO l_oeb01,l_oeb931,l_oeb933,l_oeb934
     IF STATUS THEN
       CALL cl_err('',STATUS,0)
       EXIT FOREACH
     END IF
     LET li_rec_b = li_rec_b +1
   END FOREACH
   LET g_row_count=li_rec_b
 
END FUNCTION
 
FUNCTION t410_1_menu()
 
   WHILE TRUE
      CALL t410_1_bp("G")
 
      CASE g_action_choice
         WHEN "insert"                          # A.輸入
            IF cl_chk_act_auth() THEN
               CALL t410_1_a()
            END IF
         WHEN "modify"                          # U.修改
            IF cl_chk_act_auth() THEN
               CALL t410_1_u()
            END IF
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
            END IF
         WHEN "query"                           # Q.查詢
            IF cl_chk_act_auth() THEN
               CALL t410_1_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t410_1_refresh_detail()
                RETURNING g_show
               CALL t410_1_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"                            # H.求助
            CALL cl_show_help()
         WHEN "exit"                            # Esc.結束
            EXIT WHILE
         WHEN "controlg"                        # KEY(CONTROL-G)
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0049
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oeb5),'','')
            END IF
 
          WHEN "showlog"           #MOD-440464
            IF cl_chk_act_auth() THEN
               CALL cl_show_log("t410_1")
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t410_1_a()                            # Add  輸入
DEFINE l_n   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   IF g_oea.oeaconf = 'Y' THEN
     CALL cl_err('',9023,0)
     RETURN
   END IF
   CALL g_oeb5.clear()
 
   INITIALIZE g_oeb931 LIKE oeb_file.oeb931        # 預設值及將數值類變數清成零
   INITIALIZE g_oeb932 LIKE oeb_file.oeb932        # 預設值及將數值類變數清成零
   INITIALIZE g_oeb933 LIKE oeb_file.oeb933        # 預設值及將數值類變數清成零
   INITIALIZE g_oeb934 LIKE oeb_file.oeb934        # 預設值及將數值類變數清成零
 
   CALL cl_opmsg('a')
 
   CALL cl_set_comp_visible("att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13",FALSE)
 
   BEGIN WORK
   WHILE TRUE
      CALL t410_1_i("a")                       # 輸入單頭
 
      IF INT_FLAG THEN                            # 使用者不玩了
         LET g_oeb931=NULL
         LET g_oeb932=NULL
         LET g_oeb933=NULL
         LET g_oeb934=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      LET g_rec_b = 0
 
      IF g_ss='N' THEN
         CALL g_oeb5.clear()
      ELSE
        IF NOT cl_null(g_oeb931) THEN
          CALL t410_1_b_fill('1=1')             # 單身
        END IF
      END IF
      IF NOT cl_null(g_oeb931) THEN
        IF cl_null(g_oeb932) THEN
          CALL cl_err('','axm-827',0)
          CONTINUE WHILE
        END IF
      ELSE
        IF NOT cl_null(g_oeb932) THEN
          CALL cl_err('','axm-831',0)
          CONTINUE WHILE
        END IF
      END IF
      IF cl_null(g_oeb931) THEN
        SELECT COUNT(*) INTO l_n FROM oeb_file 
         WHERE oeb01 = g_argv1
           AND oeb931 IS NULL
           AND oeb934 = g_oeb934
           AND oeb933 = g_oeb933
        IF l_n >0 THEN
          CALL cl_err('','axm-832',0)
          CONTINUE WHILE
        END IF
      END IF
      IF cl_null(g_oeb931) THEN
         IF cl_null(g_oeb933) THEN
            CONTINUE WHILE
         END IF
      END IF
      IF NOT cl_null(g_oeb931) THEN
          CALL t410_1_b_bring("a") #FUN-9C0083
          CALL t410_1_b_fill('1=1')
      END IF
      IF g_success = 'N' THEN
        ROLLBACK WORK
        RETURN
      ELSE
        COMMIT WORK
      END IF
 
      IF NOT cl_null(g_oeb933) THEN
        CALL t410_1_refresh_detail()
        RETURNING g_show
      END IF
      CALL t410_1_b()                          # 輸入單身
      LET g_oeb931_t=g_oeb931
      LET g_oeb932_t=g_oeb932
      LET g_oeb933_t=g_oeb933
      LET g_oeb934_t=g_oeb934
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t410_1_i(p_cmd)                       # 處理INPUT
 
   DEFINE   p_cmd        LIKE type_file.chr1    # a:輸入 u:更改  #No.FUN-680135 VARCHAR(1)
   DEFINE   l_count      LIKE type_file.num5    
   DEFINE   l_obi02      LIKE obi_file.obi02
   DEFINE   l_obi12      LIKE obi_file.obi12
   DEFINE   l_obi14      LIKE obi_file.obi14
   DEFINE   l_ocq02      LIKE ocq_file.ocq02
   DEFINE   l_ocq03      LIKE ocq_file.ocq03
   DEFINE   l_agb03      LIKE agb_file.agb03
   DEFINE   l_aga02      LIKE aga_file.aga02
   DEFINE   l_n          LIKE type_file.num5
   DEFINE   l_slip   LIKE oay_file.oayslip
 
   LET g_ss = 'Y'
 
   DISPLAY g_oeb931,g_oeb932,g_oeb933,g_oeb934 TO oeb931,oeb932,oeb933,oeb934 
   CALL cl_set_head_visible("","YES")
   INPUT g_oeb931,g_oeb934,g_oeb932,g_oeb933
    WITHOUT DEFAULTS FROM 
    oeb931,oeb934,oeb932,oeb933 
 
   BEFORE INPUT
      LET g_before_input_done = FALSE 
      IF g_sma.sma128 != 'Y' THEN
        CALL cl_set_comp_visible("oeb931,oeb931_obi02,oeb932",FALSE)
      END IF
      LET g_before_input_done = TRUE
 
   AFTER FIELD oeb931
      IF NOT cl_null(g_oeb931) THEN
        IF g_oeb931_t IS NULL OR g_oeb931 != g_oeb931_t THEN
          SELECT COUNT(*) INTO l_n FROM obi_file,obj_file 
           WHERE obi01 = obj01
             AND obi01 = g_oeb931
             AND obiacti = 'Y'
             AND obi12 IS NOT NULL
             AND obi14 IS NOT NULL
          IF l_n = 0 THEN
            CALL cl_err('','axm-940',0)
            NEXT FIELD oeb931
          END IF
          SELECT COUNT(*) INTO l_n FROM oeb_file 
           WHERE oeb01 = g_argv1
             AND oeb931 = g_oeb931
          IF l_n >0 THEN
            CALL cl_err(g_oeb931,'axm-531',0)
            NEXT FIELD oeb931
          END IF
          SELECT obi02,obi12,obi14 INTO l_obi02,g_oeb933,g_oeb934 FROM obi_file 
           WHERE obi01 = g_oeb931
          IF NOT cl_null(g_oeb933) THEN
            CALL cl_set_comp_entry("oeb934,oeb933",FALSE)
          END IF
          DISPLAY l_obi02 TO FORMONLY.oeb931_obi02
          DISPLAY g_oeb933 TO oeb933
          DISPLAY g_oeb934 TO oeb934
 
          SELECT aga02 INTO l_aga02 FROM aga_file
           WHERE aga01 = g_oeb934
           SELECT unique(ocq02) INTO l_ocq02 FROM ocq_file   #TQC-980026 
           WHERE ocq01 = g_oeb933
          
          DISPLAY l_ocq02 TO FORMONLY.oeb933_ocq02
          DISPLAY l_aga02 TO FORMONLY.oeb934_aga02
        END IF
      END IF
   
   AFTER FIELD oeb932
      IF NOT cl_null(g_oeb932) THEN
        IF g_oeb932_t IS NULL OR g_oeb932 != g_oeb932_t THEN
          IF g_oeb932<= 0 THEN
            CALL cl_err(g_oeb932,'axm-941',0)
            NEXT FIELD oeb932
          END IF
        END IF
      END IF
 
   AFTER FIELD oeb933
      IF NOT cl_null(g_oeb933) THEN
        IF g_oeb933_t IS NULL OR g_oeb933 != g_oeb933_t THEN
          SELECT COUNT(*) INTO l_n FROM ocq_file 
           WHERE ocq01 = g_oeb933
          IF l_n =0 THEN
            CALL cl_err(g_oeb933,'axm-943',0)
            NEXT FIELD oeb933
          END IF
          IF NOT cl_null(g_oeb934) THEN
             SELECT COUNT(*) INTO l_n FROM agb_file,ocq_file
              WHERE agb01 = g_oeb934
                AND ocq03 = agb03
                AND ocq01 = g_oeb933
             IF l_n = 0 THEN
                CALL cl_err('','axm-944',0)
                NEXT FIELD oeb933
             END IF
          END IF
          SELECT ocq02 INTO l_ocq02 FROM ocq_file
           WHERE ocq01 = g_oeb933
          DISPLAY l_ocq02 TO FORMONLY.oeb933_ocq02
        END IF
      END IF
 
   AFTER FIELD oeb934
      IF NOT cl_null(g_oeb934) THEN
        IF g_oeb934_t IS NULL OR g_oeb934 != g_oeb934_t THEN
          SELECT COUNT(*) INTO l_n FROM aga_file 
           WHERE aga01 = g_oeb934
             AND agaacti = 'Y'
          IF l_n =0 THEN
            CALL cl_err(g_oeb934,'axm-942',0)
            NEXT FIELD oeb934
          END IF
          IF NOT cl_null(g_oeb933) THEN
            SELECT DISTINCT ocq03 INTO l_ocq03 FROM ocq_file 
             WHERE ocq01 = g_oeb933
            SELECT agb03 INTO l_agb03 FROM agb_file
             WHERE agb02 IN(SELECT MAX(agb02) FROM agb_file
                             WHERE agb01 = g_oeb934)
               AND agb01 = g_oeb934
            IF l_ocq03 <> l_agb03 THEN
              CALL cl_err('','axm-944',0)
              NEXT FIELD oeb934
            END IF
          END IF
          LET l_slip = g_argv1[1,g_doc_len]
          IF g_sma.sma907 = 'Y' THEN 
             SELECT COUNT(*) INTO l_n FROM oay_file 
              WHERE oayslip = l_slip
                AND (oay22 = g_oeb934 OR oay22 IS NULL)
             IF l_n = 0 THEN
               CALL cl_err(g_argv1,'axm-828',0)
               NEXT FIELD oeb934
             END IF
          END IF
             
          IF NOT cl_null(g_oeb933) THEN
             SELECT COUNT(*) INTO l_n FROM agb_file,ocq_file
              WHERE agb01 = g_oeb934
                AND ocq03 = agb03
                AND ocq01 = g_oeb933
             IF l_n = 0 THEN
                CALL cl_err('','axm-944',0)
                NEXT FIELD oeb931
             END IF
          END IF
        
          SELECT aga02 INTO l_aga02 FROM aga_file
           WHERE aga01 = g_oeb934
        END IF
        DISPLAY l_aga02 TO FORMONLY.oeb934_aga02
      END IF
 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(oeb931)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_obi_slk" #by xumin 080326
               LET g_qryparam.default1= g_oeb931
               CALL cl_create_qry() RETURNING g_oeb931
               NEXT FIELD oeb931
            WHEN INFIELD(oeb933)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_ocq01"
               LET g_qryparam.default1= g_oeb933
               CALL cl_create_qry() RETURNING g_oeb933
               NEXT FIELD oeb933
            WHEN INFIELD(oeb934)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aga"
               LET g_qryparam.default1= g_oeb934
               CALL cl_create_qry() RETURNING g_oeb934
               NEXT FIELD oeb934
 
            OTHERWISE 
               EXIT CASE
         END CASE
 
      ON ACTION controlf                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
END FUNCTION
 
 
FUNCTION t410_1_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_argv1) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   IF g_oea.oeaconf = 'Y' THEN
     CALL cl_err('',9023,0)
     RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_oeb931_t = g_oeb931
   LET g_oeb932_t = g_oeb932
   LET g_oeb933_t = g_oeb933 
   LET g_oeb934_t = g_oeb934
 
   BEGIN WORK
   OPEN t410_1_lock_u USING g_argv1,g_oeb931_t,g_oeb933_t,g_oeb934_t
   IF STATUS THEN
      CALL cl_err("DATA LOCK:",STATUS,1)
      CLOSE t410_1_lock_u
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t410_1_lock_u INTO g_oeb_lock.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("oeb01 LOCK:",SQLCA.sqlcode,1)
      CLOSE t410_1_lock_u
      ROLLBACK WORK
      RETURN
   END IF
 
   WHILE TRUE
      CALL t410_1_i("u")
      IF INT_FLAG THEN
         LET g_oeb931 = g_oeb931_t
         LET g_oeb932 = g_oeb932_t
         LET g_oeb933 = g_oeb933_t    
         LET g_oeb934 = g_oeb934_t   
         DISPLAY g_oeb931,g_oeb932,g_oeb933,g_oeb934 TO oeb931,oeb932,oeb933,oeb934 
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      UPDATE oeb_file SET oeb931 = g_oeb931,
                          oeb932 = g_oeb932,
                          oeb933 = g_oeb933,
                          oeb934 = g_oeb934 
       WHERE oeb01 = g_argv1
         AND oeb931 = g_oeb931_t
         AND oeb933 = g_oeb933_t
         AND oeb934 = g_oeb934_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","oeb_file",g_argv1,"",SQLCA.sqlcode,"","",1) #No.FUN-660081
         CONTINUE WHILE
      ELSE                       
      END IF
 
      IF NOT cl_null(g_oeb931) THEN
        IF g_oeb931 <> g_oeb931_t OR g_oeb932<>g_oeb932_t THEN
           CALL t410_1_b_bring("u") #FUN-9C0083
          CALL t410_1_b_fill(' 1=1')
        END IF 
      END IF
      IF g_success = 'N' THEN
        ROLLBACK WORK
        RETURN
      END IF
 
      EXIT WHILE
   END WHILE
   COMMIT WORK
END FUNCTION
 
FUNCTION t410_1_q()                            #Query 查詢
   MESSAGE ""
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   CLEAR FORM
   CALL g_oeb5.clear()
   DISPLAY '' TO FORMONLY.cnt
   CALL t410_1_curs()                         #取得查詢條件
   IF INT_FLAG THEN                              #使用者不玩了
      LET INT_FLAG = 0
      RETURN
   END IF
   OPEN t410_1_b_curs                         #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.SQLCODE THEN                         #有問題
      CALL cl_err('',SQLCA.SQLCODE,0)
      INITIALIZE g_oeb931 TO NULL
      INITIALIZE g_oeb932 TO NULL
      INITIALIZE g_oeb933 TO NULL
      INITIALIZE g_oeb934 TO NULL
   ELSE
      CALL t410_1_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      IF g_row_count = 0 THEN
         CALL cl_set_comp_visible('att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13',FALSE)
      ELSE
         CALL cl_set_comp_visible('att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13',TRUE)
      END IF
      CALL t410_1_fetch('F')                 #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION t410_1_fetch(p_flag)                  #處理資料的讀取
   DEFINE   p_flag   LIKE type_file.chr1,         #處理方式   
            l_abso   LIKE type_file.num10         #絕對的筆數  
   DEFINE   l_slip   LIKE oay_file.oayslip
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t410_1_b_curs INTO g_oeb01,g_oeb931,g_oeb933,g_oeb934
      WHEN 'P' FETCH PREVIOUS t410_1_b_curs INTO g_oeb01,g_oeb931,g_oeb933,g_oeb934
      WHEN 'F' FETCH FIRST    t410_1_b_curs INTO g_oeb01,g_oeb931,g_oeb933,g_oeb934
      WHEN 'L' FETCH LAST     t410_1_b_curs INTO g_oeb01,g_oeb931,g_oeb933,g_oeb934
      WHEN '/' 
         IF (NOT g_no_ask) THEN        
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
 
                ON ACTION controlp
                   CALL cl_cmdask()
 
                ON ACTION help
                   CALL cl_show_help()
 
                ON ACTION about
                   CALL cl_about()
 
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t410_1_b_curs INTO g_oeb01
         LET g_no_ask = FALSE   
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_oeb01,SQLCA.sqlcode,0)
      INITIALIZE g_oeb931 TO NULL
      INITIALIZE g_oeb932 TO NULL
      INITIALIZE g_oeb933 TO NULL 
   ELSE
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
   #在使用Q查詢的情況下得到當前對應的屬性組oay22
   IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
      LET l_slip = g_oeb01[1,g_doc_len]
      SELECT oay22 INTO lg_oay22 FROM oay_file 
         WHERE oayslip = l_slip
   END IF
 
   CALL t410_1_show()
   END IF
END FUNCTION
 
FUNCTION t410_1_show()                         # 將資料顯示在畫面上
  DEFINE l_obi02  LIKE obi_file.obi02
  DEFINE l_aga02  LIKE aga_file.aga02
  DEFINE l_ocq02  LIKE ocq_file.ocq02
 
   SELECT DISTINCT oeb932 INTO g_oeb932 FROM oeb_file
    WHERE oeb01 = g_argv1
      AND oeb931 = g_oeb931
      AND oeb933 = g_oeb933
      AND oeb934 = g_oeb934
   DISPLAY g_oeb931,g_oeb932,g_oeb933,g_oeb934 TO oeb931,oeb932,oeb933,oeb934 
   SELECT obi02 INTO l_obi02 FROM obi_file
    WHERE obi01 = g_oeb931
   SELECT aga02 INTO l_aga02 FROM aga_file 
    WHERE aga01 = g_oeb934
   SELECT DISTINCT ocq02 INTO l_ocq02 FROM ocq_file 
    WHERE ocq01 = g_oeb933
   DISPLAY l_obi02 TO FORMONLY.oeb931_obi02
   DISPLAY l_aga02 TO FORMONLY.oeb934_aga02
   DISPLAY l_ocq02 TO FORMONLY.oeb933_ocq02
   CALL t410_1_b_fill(g_wc)                    # 單身
   CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION t410_1_r()        # 取消整筆 (所有合乎單頭的資料)
   DEFINE   l_cnt   LIKE type_file.num5, 
            l_oeb   RECORD LIKE oeb_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_oeb01) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   BEGIN WORK
   IF cl_delh(0,0) THEN                   #確認一下
      DELETE FROM oeb_file
       WHERE oeb01 = g_argv1 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","oeb_file",g_argv1,'',SQLCA.sqlcode,"","BODY DELETE",0)   #No.FUN-660081
      ELSE
         CLEAR FORM
         CALL g_oeb5.clear()
         CALL t410_1_count()
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t410_1_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t410_1_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE          
            CALL t410_1_fetch('/')
         END IF
      END IF
   END IF
   COMMIT WORK
END FUNCTION
 
FUNCTION t410_1_b_bring(p_cmd) #FUN-9C0083
   DEFINE l_sql     STRING
   DEFINE l_oeb03   LIKE oeb_file.oeb03
   DEFINE l_obj02   LIKE obj_file.obj02
   DEFINE l_obj06   LIKE obj_file.obj06
   DEFINE l_obj07   LIKE obj_file.obj07
   DEFINE l_oeb     RECORD LIKE oeb_file.*
   DEFINE l_fac     LIKE oeb_file.oeb05_fac
   DEFINE l_ps      LIKE sma_file.sma46
   DEFINE l_tok     base.stringTokenizer
   DEFINE field_array  DYNAMIC ARRAY OF LIKE type_file.chr1000
   DEFINE k         LIKE type_file.num5
   DEFINE p_cmd     LIKE type_file.chr1 #FUN-9C0083
   DEFINE l_oea00   LIKE oea_file.oea00 #FUN-9C0083
   DEFINE l_oea03   LIKE oea_file.oea03 #FUN-9C0083
   DEFINE l_oea23   LIKE oea_file.oea23 #FUN-9C0083
   DEFINE l_oea31   LIKE oea_file.oea31 #FUN-9C0083
   DEFINE l_oea32   LIKE oea_file.oea32 #FUN-9C0083
   DEFINE l_oebslk  RECORD LIKE oebslk_file.*    #FUN-B90101 add
   DEFINE l_oebislk03      LIKE oebi_file.oebi03 #FUN-B90101 add

   LET g_success = 'Y'
   DECLARE t410_1_br CURSOR FOR
   SELECT oeb03 FROM oeb_file 
    WHERE oeb01 = g_argv1
      AND oeb931 = g_oeb931
      AND oeb933 = g_oeb933
      AND oeb934 = g_oeb934
   FOREACH t410_1_br INTO l_oeb03
     IF STATUS THEN
       CALL cl_err('',STATUS,0)
       LET g_success = 'N'
       EXIT FOREACH
     END IF
     DELETE FROM oebi_file WHERE oebi01 = g_argv1
                             AND oebi03 = l_oeb03
     IF SQLCA.sqlcode THEN
       CALL cl_err3("del","oebi_file",g_argv1,"",SQLCA.sqlcode,"","",0) 
       LET g_success = 'N'
       EXIT FOREACH
     END IF
   END FOREACH
   
   DELETE FROM oeb_file
    WHERE oeb01 = g_argv1
      AND oeb931 = g_oeb931
      AND oeb933 = g_oeb933
      AND oeb934 = g_oeb934
   IF SQLCA.sqlcode THEN
     CALL cl_err3("del","oeb_file",g_argv1,"",SQLCA.sqlcode,"","",0) 
     LET g_success = 'N'
   END IF
 
   LET l_sql = "SELECT obj02,obj06,obj07 FROM obi_file,obj_file ",
               " WHERE obi01 = obj01 ",
               "   AND obi01 = '",g_oeb931,"'"
   PREPARE t410_1_bring_pre FROM l_sql
   DECLARE t410_1_bring_cur CURSOR FOR t410_1_bring_pre
   FOREACH t410_1_bring_cur INTO l_obj02,l_obj06,l_obj07
     IF STATUS THEN
       CALL cl_err('',STATUS,0)
       LET g_success = 'N'
       EXIT FOREACH
     END IF
     SELECT MAX(oeb03) INTO l_oeb.oeb03 FROM oeb_file
      WHERE oeb01 = g_argv1
     IF cl_null(l_oeb.oeb03) THEN
       LET l_oeb.oeb03 = 1
     ELSE
       LET l_oeb.oeb03 = l_oeb.oeb03+1
     END IF
     LET l_oeb.oeb04 = l_obj02
 
        SELECT sma46 INTO l_ps FROM sma_file
        IF cl_null(l_ps) THEN
            LET l_ps=' '
        END IF
        LET l_tok = base.StringTokenizer.createExt(l_oeb.oeb04,l_ps,'',TRUE)
            IF l_tok.countTokens() > 0 THEN
               LET k=0
               WHILE l_tok.hasMoreTokens()
                     LET k=k+1
                     LET field_array[k] = l_tok.nextToken()
               END WHILE
            END IF
 
     LET l_oeb.oeb05 = l_obj07
     LET l_oeb.oeb12 = l_obj06*g_oeb932
     SELECT ima31_fac,ima02,ima31,ima908 INTO l_oeb.oeb05_fac,l_oeb.oeb06,l_oeb.oeb05,l_oeb.oeb916
       FROM ima_file 
      WHERE ima01 = l_obj02
     LET l_oeb.oeb12 = s_digqty(l_oeb.oeb12,l_oeb.oeb05)   #FUN-910088--add--
     LET g_oeb932 = s_digqty(g_oeb932,l_oeb.oeb05)   #FUN-910088--add--
 
        IF cl_null(l_oeb.oeb05_fac) THEN
           LET l_oeb.oeb05_fac = 1
        END IF
        IF cl_null(l_oeb.oeb916) THEN
           LET l_oeb.oeb916 =l_oeb.oeb05
        END IF
     IF g_aza.aza50 = 'Y' THEN
        LET g_oeb5[1].oeb15 = g_oea.oea59
        IF cl_null(g_oeb5[1].oeb15) THEN
             LET g_oeb5[1].oeb15=g_today
        END IF
        LET g_oeb5[1].oeb05 = l_oeb.oeb05
        LET g_oeb5[1].oeb916 = l_oeb.oeb916
        LET g_oeb5[1].att00 = field_array[1]
        CALL t410_1_price(1,p_cmd) RETURNING l_fac #FUN-9C0083 
        LET l_oeb.oeb13 = g_oeb5[1].oeb13 
        LET l_oeb.oeb37 = b_oeb.oeb37     #FUN-AB0061
        LET l_oeb.oeb1002 = g_oeb5[1].oeb1002
     ELSE
        LET l_oeb.oeb04 = field_array[1]
        SELECT oea00,oea03,oea23,oea31,oea32
          INTO l_oea00,l_oea03,l_oea23,l_oea31,l_oea32
          FROM oea_file 
         WHERE oea01=g_argv1 
        CALL s_fetch_price_new(l_oea03,l_oeb.oeb04,l_oeb.oeb49,l_oeb.oeb05,l_oeb.oeb15,l_oea00,g_plant,     #FUN-BC0071
                               l_oea23,l_oea31,l_oea32,g_argv1,l_oeb.oeb03,l_oeb.oeb12,
                               l_oeb.oeb1004,p_cmd)
        #  RETURNING l_oeb.oeb13              #FUN-AB0061 
            RETURNING l_oeb.oeb13,l_oeb.oeb37 #FUN-AB0061 
       #FUN-B70087 mod
       #IF l_oeb.oeb13=0 THEN CALL s_unitprice_entry(l_oea03,l_oea31,g_plant) END IF #FUN-9C0120
        #FUN-BC0088 ----- add start --------
        IF l_oeb.oeb04[1,4] = 'MISC' THEN
           CALL s_unitprice_entry(l_oea03,l_oea31,g_plant,'M')
        ELSE
        #FUN-BC0088 ----- add end --------
           IF l_oeb.oeb13=0 THEN
              CALL s_unitprice_entry(l_oea03,l_oea31,g_plant,'N')
           ELSE
              CALL s_unitprice_entry(l_oea03,l_oea31,g_plant,'Y')
           END IF
        END IF   #FUN-BC0088 add
       #FUN-B70087 mod--end
        LET l_oeb.oeb04 = l_obj02
     END IF
 
        LET l_oeb.oeb917 =l_oeb.oeb12
 
        IF g_oea.oea213 = 'N' THEN # 不內含
           LET g_oeb[1].oeb14=l_oeb.oeb917*l_oeb.oeb13
           CALL cl_digcut(g_oeb[1].oeb14,t_azi04) RETURNING g_oeb[1].oeb14  
           LET g_oeb[1].oeb14t=g_oeb[1].oeb14*(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[1].oeb14t,t_azi04) RETURNING g_oeb[1].oeb14t 
        ELSE 
           LET g_oeb[1].oeb14t=l_oeb.oeb917*l_oeb.oeb13
           CALL cl_digcut(g_oeb[1].oeb14t,t_azi04) RETURNING g_oeb[1].oeb14t 
           LET g_oeb[1].oeb14=g_oeb[1].oeb14t/(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[1].oeb14,t_azi04) RETURNING g_oeb[1].oeb14  
        END IF
        IF l_oeb.oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN 
           LET g_oeb[1].oeb14=0
           LET g_oeb[1].oeb14t=0
        END IF
        LET l_oeb.oeb14 = g_oeb[1].oeb14
        LET l_oeb.oeb14t = g_oeb[1].oeb14t
 
        LET l_oeb.oeb15 = g_oea.oea59 
        LET l_oeb.oeb16 = g_oea.oea59
       #LET l_oeb.oeb72 = g_oea.oea59  #FUN-B20060 add  #CHI-C80060 mark
        LET l_oeb.oeb72 = NULL         #CHI-C80060 add
        LET l_oeb.oeb19 = 'N'
        LET l_oeb.oeb23 = 0 LET l_oeb.oeb24 = 0
        LET l_oeb.oeb25 = 0 LET l_oeb.oeb26 = 0
        LET l_oeb.oeb70 = 'N'
        LET l_oeb.oeb71 = g_oea.oea71
        IF cl_null(l_oeb.oeb15) THEN
             LET l_oeb.oeb15=g_today
             LET l_oeb.oeb16=g_today
        END IF
        LET l_oeb.oeb905 = 0
        IF cl_null(l_oeb.oeb091) THEN LET l_oeb.oeb091=' ' END IF
        IF cl_null(l_oeb.oeb092) THEN LET l_oeb.oeb092=' ' END IF
        LET l_oeb.oeb1003 = '1' 
        LET l_oeb.oeb930=s_costcenter(g_oea.oea15)
        LET l_oeb.oeb920 = 0
         SELECT obk11 INTO l_oeb.oeb906
           FROM obk_file
          WHERE obk01 = l_oeb.oeb04
            AND obk02 = g_oea.oea03
         IF cl_null(l_oeb.oeb906) THEN
             LET l_oeb.oeb906 = 'N' 
         END IF
     LET l_oeb.oeb01 = g_argv1
     LET l_oeb.oeb931 = g_oeb931
     LET l_oeb.oeb932 = g_oeb932
     LET l_oeb.oeb933 = g_oeb933
     LET l_oeb.oeb934 = g_oeb934
     LET l_oeb.oeb44 = '1' #No.FUN-870007
     LET l_oeb.oeb47 = 0  #No.FUN-870007
     LET l_oeb.oeb48 = '1' #No.FUN-870007
 
     LET l_oeb.oebplant = g_plant 
     LET l_oeb.oeblegal = g_legal 
     IF cl_null(l_oeb.oeb37) OR l_oeb.oeb37 = 0 THEN LET l_oeb.oeb37 = l_oeb.oeb13 END IF   #FUN-AB0061  

     INSERT INTO oeb_file
            VALUES(l_oeb.*)
     IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","oeb_file",g_argv1,"",SQLCA.sqlcode,"","",0) 
       LET g_success = 'N'
       RETURN
       EXIT FOREACH
     END IF
 
     INSERT INTO oebi_file(oebi01,oebi03,oebiplant,oebilegal)   #FUN-980010 add plant & legal 
                    VALUES(g_argv1,l_oeb.oeb03,g_plant,g_legal)
     IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","oebi_file",g_argv1,"",SQLCA.sqlcode,"","",0) 
       LET g_success = 'N'
       RETURN
       EXIT FOREACH
     END IF
 
   END FOREACH

#FUN-B90101--add--begin--
   #新增母料件oebslk_file的資料
   DECLARE t410_1_br_slk CURSOR FOR
   SELECT oebislk03 FROM oebi_file,oeb_file
    WHERE oeb01 = oebi01
      AND oeb03 = oebi03
      AND oeb01 = g_argv1
      GROUP BY oebislk03
   FOREACH t410_1_br_slk INTO l_oebislk03
     IF STATUS THEN
       CALL cl_err('',STATUS,0)
       LET g_success = 'N'
       EXIT FOREACH
     END IF
     DELETE FROM oebslk_file WHERE oebslk01 = g_argv1
                               AND oebslk03 = l_oebislk03
     IF SQLCA.sqlcode THEN
       CALL cl_err3("del","oebslk_file",g_argv1,"",SQLCA.sqlcode,"","",0)
       LET g_success = 'N'
       EXIT FOREACH
     END IF
   END FOREACH 

   #根據oeb_file的資料，產生oebslk_file的資料
   DECLARE t410_1_oebslk CURSOR FOR SELECT MIN(oeb03),SUM(oeb12),SUM(oeb14),SUM(oeb14t),
                                           SUM(oeb23),SUM(oeb24),SUM(oeb25),SUM(oeb26),SUM(oeb28)
                                      FROM oeb_file,oebi_file,imx_file
                                     WHERE oeb01 = oebi01
                                       AND oeb03 = oebi03
                                       AND oeb04=imx000
                                       AND oeb01 = g_argv1
                                       AND oeb931 = g_oeb931
                                       AND oeb933 = g_oeb933
                                       AND oeb934 = g_oeb934
                                      GROUP BY imx00
   FOREACH t410_1_oebslk INTO l_oeb03,l_oebslk.oebslk12,l_oebslk.oebslk14,l_oebslk.oebslk14t,
                              l_oebslk.oebslk23,l_oebslk.oebslk24,l_oebslk.oebslk25,
                              l_oebslk.oebslk26,l_oebslk.oebslk28 
      LET l_oebslk.oebslk01=g_argv1
      SELECT MAX(oebslk03)+1 INTO l_oebslk.oebslk03 FROM oebslk_file WHERE oebslk01=g_argv1
      IF cl_null(l_oebslk.oebslk03) THEN
         LET l_oebslk.oebslk03=1
      END IF
      SELECT imx00 INTO l_oebslk.oebslk04 FROM imx_file,oeb_file
        WHERE imx000=oeb04 AND oeb01=g_argv1 AND oeb03=l_oeb03
      SELECT ima02 INTO l_oebslk.oebslk06 FROM ima_file WHERE ima01=l_oebslk.oebslk04
      SELECT imc02 INTO l_oebslk.oebslk07 FROM imc_file WHERE imc01=l_oebslk.oebslk04
      
      SELECT oeb05,oeb05_fac,oeb09,oeb091,oeb092,oeb11,
             oeb13,oeb1006,oebplant,oeblegal
        INTO l_oebslk.oebslk05,l_oebslk.oebslk05_fac,l_oebslk.oebslk09,l_oebslk.oebslk091,
             l_oebslk.oebslk092,l_oebslk.oebslk11,l_oebslk.oebslk13,
             l_oebslk.oebslk1006,l_oebslk.oebslkplant,l_oebslk.oebslklegal
        FROM oeb_file
       WHERE oeb01=g_argv1 AND oeb03=l_oeb03
      IF cl_null(l_oebslk.oebslk1006) THEN
         LET l_oebslk.oebslk1006=100
      END IF
      IF cl_null(l_oebslk.oebslk28) THEN
         LET l_oebslk.oebslk28=0
      END IF
      LET l_oebslk.oebslk131=l_oebslk.oebslk13*(l_oebslk.oebslk1006/100)
      INSERT INTO oebslk_file VALUES(l_oebslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","oebslk_file","","",SQLCA.sqlcode,"","ins oebslk",1)
         EXIT FOREACH
      ELSE
         UPDATE oebi_file SET oebislk02=l_oebslk.oebslk04,
                              oebislk03=l_oebslk.oebslk03
           WHERE oebi01=g_argv1
             AND oebi03 IN (SELECT oeb03 FROM oeb_file,imx_file
                             WHERE oeb01=g_argv1
                               AND oeb04=imx000
                               AND imx00=l_oebslk.oebslk04)
         IF STATUS THEN
            CALL cl_err3("upd","oeb_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF

   END FOREACH
 
#FUN-B90101--add--end-
 
END FUNCTION 
 
FUNCTION t410_1_csd_get_price(p_oeb)
   DEFINE l_oah03	LIKE type_file.chr1 
   DEFINE l_ima131	LIKE type_file.chr20
   DEFINE p_oeb         RECORD LIKE oeb_file.*
 
   SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oea.oea31
   LET p_oeb.oeb13=0
   CASE WHEN l_oah03 = '0' RETURN 0
        WHEN l_oah03 = '1'
             IF g_oea.oea213='Y'
                THEN SELECT ima128 INTO p_oeb.oeb13 FROM ima_file
                            WHERE ima01 = p_oeb.oeb04
                ELSE SELECT ima127 INTO p_oeb.oeb13 FROM ima_file
                            WHERE ima01 = p_oeb.oeb04
             END IF
              LET p_oeb.oeb13=p_oeb.oeb13/g_oea.oea24
        WHEN l_oah03 = '2'
             SELECT ima131 INTO l_ima131 FROM ima_file
                    WHERE ima01 = p_oeb.oeb04
             IF cl_null(p_oeb.oeb916) THEN
                LET p_oeb.oeb916 = p_oeb.oeb05   
                LET p_oeb.oeb917 = s_digqty(p_oeb.oeb917,p_oeb.oeb05)   #FUN-910088--add--
             END IF
             DECLARE t400_csd_get_price_c CURSOR FOR
                 SELECT obg21,
                        obg01,obg02,obg03,obg04,obg05,
                        obg06,obg07,obg08,obg09,obg10
                   FROM obg_file
                    WHERE (obg01 = l_ima131          OR obg01 = '*')
                      AND (obg02 = p_oeb.oeb04 OR obg02 = '*')
                      AND (obg03 = p_oeb.oeb916)
                      AND (obg04 = g_oea.oea25       OR obg04 = '*')
                      AND (obg05 = g_oea.oea31       OR obg05 = '*')
                      AND (obg06 = g_oea.oea03       OR obg06 = '*')
                      AND (obg09 = g_oea.oea23      )
                      AND (obg10 = g_oea.oea21       OR obg10 = '*')
                 ORDER BY obg02 DESC,obg03 DESC,obg04 DESC,
                          obg05 DESC,obg06 DESC,obg07 DESC,obg08 DESC,
                          obg09 DESC,obg10 DESC 
             FOREACH t400_csd_get_price_c INTO p_oeb.oeb13
               IF STATUS THEN CALL cl_err('foreach obg',STATUS,1) END IF
               EXIT FOREACH
             END FOREACH
        WHEN l_oah03 = '3'
           SELECT obk08 INTO p_oeb.oeb13 FROM obk_file
                  WHERE obk01 = p_oeb.oeb04 AND obk02 = g_oea.oea03 
                    AND obk05 = g_oea.oea23
   END CASE
   RETURN p_oeb.oeb13
END FUNCTION
 
FUNCTION t410_1_g_du(p_item,p_unit,p_qty)
   DEFINE p_item  LIKE ima_file.ima01
   DEFINE p_unit  LIKE img_file.img09
   DEFINE p_qty   LIKE img_file.img10
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima31,ima906,ima907
        INTO g_ima31,g_ima906,g_ima907
        FROM ima_file 
       WHERE ima01=p_item
 
      LET b_oeb.oeb910=p_unit
      LET g_factor = 1
 
      CALL s_umfchk(p_item,b_oeb.oeb910,g_ima31)
          RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF
 
      LET b_oeb.oeb911=g_factor
      LET b_oeb.oeb912=p_qty
      LET b_oeb.oeb912 = s_digqty(b_oeb.oeb912,b_oeb.oeb910)   #FUN-910088--add--
      LET b_oeb.oeb913=g_ima907
      LET g_factor = 1
 
      CALL s_umfchk(p_item,b_oeb.oeb913,g_ima31)
          RETURNING g_cnt,g_factor
      IF g_cnt = 1 THEN
         LET g_factor = 1
      END IF
 
      LET b_oeb.oeb914=g_factor
      LET b_oeb.oeb915=0
 
      IF g_ima906 = '3' THEN
         LET g_factor = 1
         CALL s_umfchk(p_item,b_oeb.oeb910,b_oeb.oeb913)
             RETURNING g_cnt,g_factor
         IF g_cnt = 1 THEN
            LET g_factor = 1
         END IF
         LET b_oeb.oeb915=p_qty*g_factor
         LET b_oeb.oeb915 = s_digqty(b_oeb.oeb915,b_oeb.oeb913)   #FUN-910088--add--
      END IF
   END IF
   IF cl_null(b_oeb.oeb916) THEN  
      LET b_oeb.oeb916 =p_unit
      LET b_oeb.oeb917 =p_qty
       LET b_oeb.oeb917 = s_digqty(b_oeb.oeb917,b_oeb.oeb916)    #FUN-910088--add--
   END IF
 
END FUNCTION
FUNCTION t410_1_b()                            # 單身
   DEFINE   l_ac_t          LIKE type_file.num5,               # 未取消的ARRAY CNT 
            l_n             LIKE type_file.num5,               # 檢查重複用       
            l_cnt           LIKE type_file.num5,         
            l_gau01         LIKE type_file.num5,               # 檢查重複用      
            l_lock_sw       LIKE type_file.chr1,               # 單身鎖住否     
            p_cmd           LIKE type_file.chr1,               # 處理狀態      
            l_allow_insert  LIKE type_file.num5,           
            l_allow_delete  LIKE type_file.num5           
   DEFINE   l_count         LIKE type_file.num5          
   DEFINE   ls_msg_o        STRING
   DEFINE   ls_msg_n        STRING
   DEFINE   l_ima25         LIKE ima_file.ima25
   DEFINE   l_oeb03         LIKE oeb_file.oeb03,
   l_check_res     LIKE type_file.num5,  
    l_b2            LIKE cob_file.cob08, 
    l_ima130        LIKE ima_file.ima130,  
    l_ima131        LIKE ima_file.ima131, 
    l_imaacti       LIKE ima_file.imaacti,
    l_qty           LIKE type_file.num10, 
    l_cmd           LIKE type_file.chr1000,
    l_coc04         LIKE coc_file.coc04,  
    l_fac           LIKE oeb_file.oeb05_fac,
    l_m             LIKE type_file.num5, 
    li_result       LIKE type_file.num5,
    l_pjb25         LIKE pjb_file.pjb25
DEFINE l_oeb15      LIKE oeb_file.oeb15
DEFINE l_oeb1001    LIKE oeb_file.oeb1001
DEFINE l_sqlb       STRING
DEFINE l_wc         STRING
DEFINE l_oea00   LIKE oea_file.oea00 #FUN-9C0083
DEFINE l_oea03   LIKE oea_file.oea03 #FUN-9C0083
DEFINE l_oea23   LIKE oea_file.oea23 #FUN-9C0083
DEFINE l_oea31   LIKE oea_file.oea31 #FUN-9C0083
DEFINE l_oea32   LIKE oea_file.oea32 #FUN-9C0083
DEFINE l_oeb12   LIKE oeb_file.oeb12 #FUN-9C0083
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_argv1) THEN 
      CALL cl_err('',-400,0)
      RETURN
   END IF 
   IF g_oea.oeaconf = 'Y' THEN
     CALL cl_err('',9023,0)
     RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   IF NOT cl_null(g_oeb931) THEN
     LET l_allow_insert = FALSE
     LET l_allow_delete = FALSE
   ELSE
     LET l_allow_insert = cl_detail_input_auth("insert")
     LET l_allow_delete = cl_detail_input_auth("delete")
   END IF
   CALL cl_set_comp_required("oeb15,oeb05",TRUE)
   IF g_aza.aza50 = 'Y' THEN
      CALL cl_set_comp_required("oeb1001",TRUE)
      CALL cl_set_comp_entry("oeb1012,oeb1002",FALSE)
   ELSE
      CALL cl_set_comp_required("oeb1001",FALSE)
   END IF
 
   LET g_forupd_sql= "SELECT '','','','','','','','','','','','','','','','',oeb03,oeb04,oeb05,oeb916,oeb15,oeb1002,oeb1004,oeb13,oeb1001,oeb1012,'' ",
                     "  FROM oeb_file ",
                     "  WHERE oeb01 = ? AND oeb04 = ? ",
                     "   AND oeb933 = '",g_oeb933,"'",
                     "   AND oeb934 = '",g_oeb934,"'" 
   IF cl_null(g_oeb931) THEN
     LET g_forupd_sql = g_forupd_sql CLIPPED," AND 1=1"," FOR UPDATE"  #No.FUN-8A0129
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B80089
   ELSE
     LET g_forupd_sql = g_forupd_sql CLIPPED," AND oeb931 = '",g_oeb931,"'"," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)   #FUN-B80089
  END IF   #No.FUN-8A012
#   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)     #FUN-B80089
   DECLARE t410_1_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   INPUT ARRAY g_oeb5 WITHOUT DEFAULTS FROM tb5.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         CALL cl_set_comp_visible("oeb03,oeb04",FALSE)
         IF g_sma.sma116  = '0' THEN
           CALL cl_set_comp_visible("oeb916",FALSE)
         END IF
         LET g_before_input_done = FALSE
         LET g_before_input_done = TRUE
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_oeb5_t.* = g_oeb5[l_ac].*    #BACKUP
               CALL t410_1_wc() RETURNING l_wc
               LET l_sqlb= "SELECT DISTINCT att00,att01,att02,att02_c,att03,",
                           "                att03_c,att04,att05,att06,att07,",
                           "                att08,att09,att10,att11,att12,att13,",
                           "                '','',oeb05,oeb916,oeb15,",
                           "                oeb1002,oeb1004,oeb13,oeb1001,oeb1012,oebislk01",
                           "  FROM t410_1_tempb", 
                           " WHERE ",l_wc CLIPPED
               DECLARE temp_bcl CURSOR FROM l_sqlb
               OPEN temp_bcl
               IF SQLCA.sqlcode THEN
                  CALL cl_err("OPEN temp_bcl:", STATUS, 1)
                  LET l_lock_sw = 'Y'
               ELSE
                  FETCH temp_bcl INTO g_oeb5[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('FETCH temp_bcl:',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT oebislk01 INTO g_oeb5[l_ac].oebislk01 FROM oebi_file
                   WHERE oebi01 = g_argv1
                     AND oebi03 = g_oeb5[l_ac].oeb03
               END IF
            CALL cl_show_fld_cont()    
         IF NOT cl_null(g_oeb931) THEN
            CALL cl_set_comp_entry("att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13,oeb05",FALSE)
         ELSE
            CALL cl_set_comp_entry("att00,att02,att02_c,att03,att03_c",FALSE)
            CALL cl_set_comp_entry("att04,att05,att06,att07,att08,att09,att10,att11,att12,att13,oeb05",TRUE)
         END IF
         IF g_aza.aza50 != 'Y' THEN
           CALL cl_set_comp_visible("oeb1002,oeb1004,oeb1001,oeb1012",FALSE)
         END IF
         IF g_sma.sma124 != 'slk' THEN
           CALL cl_set_comp_visible("oebislk01",FALSE)
         END IF
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_oeb5[l_ac].* TO NULL 
         LET g_oeb5[l_ac].oeb15 = g_today
         LET g_oeb5_t.* = g_oeb5[l_ac].*          #新輸入資料
         CALL cl_show_fld_cont()    
         IF NOT cl_null(g_oeb931) THEN
            CALL cl_set_comp_entry("att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13,oeb05",FALSE)
         ELSE
            CALL cl_set_comp_entry("att00,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13,oeb05",TRUE)
         END IF
         IF g_aza.aza50 != 'Y' THEN
           CALL cl_set_comp_visible("oeb1002,oeb1004,oeb1001,oeb1012",FALSE)
         END IF
         IF g_sma.sma124 != 'slk' THEN
           CALL cl_set_comp_visible("oebislk01",FALSE)
         END IF
         NEXT FIELD att00
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         IF NOT t410_1_b_ins(p_cmd,'') THEN
              CANCEL INSERT
         ELSE
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              IF g_aza.aza50 = 'N' THEN  
                 CALL t410_1_bu()     
              ELSE   
                 CALL t410_1_oea_sum() 
                 CALL t410_1_weight_cubage()
              END IF
              CALL t410_1_ins_oebslk()      #FUN-B90101 add
              COMMIT WORK
              CALL t410_1_b_fill(" 1=1")
         END IF
 
 
      AFTER FIELD att00
         IF NOT cl_null(g_oeb5[l_ac].att00) THEN
              #FUN-AB0025 -------------add start------------
              IF NOT s_chk_item_no(g_oeb5[l_ac].att00,'') THEN
                 CALL cl_err('',g_errno,1)
                 NEXT FIELD att00 
              END IF
              #FUN-AB0025 ---------------add end------------   
              IF g_oeb5_t.att00 IS NULL OR g_oeb5_t.att00 <> g_oeb5[l_ac].att00 THEN
                 SELECT COUNT(*) INTO l_n FROM ima_file
                  WHERE ima01 = g_oeb5[l_ac].att00
                    AND ima151 = 'Y'
                    AND imaag = g_oeb934
                    AND imaacti = 'Y'
                IF l_n = 0 THEN
                   CALL cl_err(g_oeb5[l_ac].att00,'axm-945',0)
                   NEXT FIELD att00
                END IF
                CALL t410_1_check() RETURNING g_success
                IF g_success = 'N' THEN
                   CALL cl_err('','atm-310',0)
                   NEXT FIELD att00
                END IF
                SELECT ima02,ima135,ima31,ima908 INTO g_oeb5[l_ac].att01,g_oeb[l_ac].ima135,g_oeb5[l_ac].oeb05,g_oeb5[l_ac].oeb916 FROM ima_file
                 WHERE ima01 = g_oeb5[l_ac].att00
                LET g_oeb[l_ac].oeb04 = g_oeb5[l_ac].att00
                LET g_oeb[l_ac].oeb05 = g_oeb5[l_ac].oeb05
                LET g_oeb[l_ac].oeb916 = g_oeb5[l_ac].oeb916
                LET g_oeb[l_ac].oeb12 = s_digqty(g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb05)   #FUN-910088--add--
                LET g_oeb[l_ac].oeb917 = s_digqty(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb916)   #FUN-910088--add--
                
                LET g_oeb04 = g_oeb5[l_ac].att00
                IF g_sma.sma116 MATCHES '[01]' THEN
                   LET g_oeb5[l_ac].oeb916=g_oeb5[l_ac].oeb05
                   LET g_oeb[l_ac].oeb916 = g_oeb5[l_ac].oeb916
                   LET g_oeb[l_ac].oeb917 = s_digqty(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb916)    #FUN-910088--add--
                END IF
                IF g_aza.aza50 = 'Y' THEN
                   CALL t410_1_price(l_ac,p_cmd) RETURNING l_fac #FUN-9C0083 
                ELSE
                   SELECT oea00,oea03,oea23,oea31,oea32
                     INTO l_oea00,l_oea03,l_oea23,l_oea31,l_oea32
                     FROM oea_file
                    WHERE oea01=g_argv1
                   SELECT oeb12 INTO l_oeb12 FROM oeb_file
                    WHERE oeb01=g_argv1 AND oeb03=g_oeb5[l_ac].oeb03
                   CALL s_fetch_price_new(l_oea03,g_oeb5[l_ac].oeb04,'',g_oeb5[l_ac].oeb05,g_oeb5[l_ac].oeb15,         #FUN-BC0071
                                          l_oea00,g_plant,
                                          l_oea23,l_oea31,l_oea32,g_argv1,g_oeb5[l_ac].oeb03,l_oeb12,
                                          g_oeb5[l_ac].oeb1004,p_cmd)
                        #   RETURNING g_oeb5[l_ac].oeb13  #FUN-AB0061 
                           RETURNING g_oeb5[l_ac].oeb13,b_oeb.oeb37  #FUN-AB0061 
                  #FUN-B70087 mod
                  #IF g_oeb5[l_ac].oeb13 = 0 THEN CALL s_unitprice_entry(l_oea03,l_oea31,g_plant) END IF #FUN-9C0120 
                  #FUN-BC0088 ----- add start --------
                  IF g_oeb5[l_ac].oeb04[1,4] = 'MISC' THEN
                     CALL s_unitprice_entry(l_oea03,l_oea31,g_plant,'M')
                  ELSE
                  #FUN-BC0088 ----- add end --------
                      IF g_oeb5[l_ac].oeb13 = 0 THEN
                        CALL s_unitprice_entry(l_oea03,l_oea31,g_plant,'N')
                      ELSE
                        CALL s_unitprice_entry(l_oea03,l_oea31,g_plant,'Y')
                      END IF
                  END IF  #FUN-BC0088 add
                  #FUN-B70087 mod--end
                END IF
                IF g_aza.aza50 = 'Y' THEN  #流通配銷的判斷挪至此,因為以上程式段為對料件的正確性控管
                   SELECT * FROM tqh_file,ima_file
                    WHERE tqh02=ima1006
                      AND tqhacti='Y'
                      AND ima01=g_oeb5[l_ac].att00
                      AND tqh01=g_oea.oea1002
                   IF STATUS=100 THEN
                      CALL cl_err3("sel","tqh_file,ima_file","","","atm-018","","",1)
                      NEXT FIELD att00
                   END IF
                END IF
             END IF
          END IF
 
        #下面是兩個輸入型下拉框屬性欄位的判斷語句
        AFTER FIELD att02_c
            IF NOT cl_null(g_oeb5[l_ac].att02_c) THEN
              IF g_oeb5_t.att02_c IS NULL OR g_oeb5_t.att02_c <> g_oeb5[l_ac].att02_c THEN
               CALL t410_1_check() RETURNING g_success
               IF g_success = 'N' THEN
                  CALL cl_err('','atm-310',0)
                  NEXT FIELD att02_c
               END IF
               LET arr_detail[l_ac].imx[2] = g_oeb5[l_ac].att02_c
              END IF
            END IF
        AFTER FIELD att03_c
            IF NOT cl_null(g_oeb5[l_ac].att03_c) THEN
              IF g_oeb5_t.att03_c IS NULL OR g_oeb5_t.att03_c <> g_oeb5[l_ac].att03_c THEN
               CALL t410_1_check() RETURNING g_success
               IF g_success = 'N' THEN
                  CALL cl_err('','atm-310',0)
                  NEXT FIELD att03_c
               END IF
               LET arr_detail[l_ac].imx[3] = g_oeb5[l_ac].att03_c
              END IF
            END IF
        AFTER FIELD att02
            CALL t410_1_check_att0x(g_oeb5[l_ac].att02,2,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att02 END IF 
            IF NOT cl_null(g_oeb5[l_ac].att02) THEN
              IF g_oeb5_t.att02 IS NULL OR g_oeb5_t.att02 <> g_oeb5[l_ac].att02 THEN
               CALL t410_1_check() RETURNING g_success
               IF g_success = 'N' THEN
                  CALL cl_err('','atm-310',0)
                  NEXT FIELD att02
               END IF
               LET arr_detail[l_ac].imx[2] = g_oeb5[l_ac].att02
              END IF
            END IF             
        AFTER FIELD att03
            CALL t410_1_check_att0x(g_oeb5[l_ac].att03,3,l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
            IF NOT l_check_res THEN NEXT FIELD att03 END IF
            IF NOT cl_null(g_oeb5[l_ac].att03) THEN
              IF g_oeb5_t.att03 IS NULL OR g_oeb5_t.att03 <> g_oeb5[l_ac].att03 THEN
               CALL t410_1_check() RETURNING g_success
               IF g_success = 'N' THEN
                  CALL cl_err('','atm-310',0)
                  NEXT FIELD att03
               END IF
               LET arr_detail[l_ac].imx[3] = g_oeb5[l_ac].att03
              END IF
            END IF
        AFTER FIELD att04
            IF NOT cl_null(g_oeb5[l_ac].att04) THEN
              IF g_oeb5[l_ac].att04 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att04,'axm-948',0)
                NEXT FIELD att04
              END IF
#              LET arr_detail[l_ac].imx[4] = g_oeb5[l_ac].att04  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[4] = g_oeb5[l_ac].att04     #FUN-C90014 add
        AFTER FIELD att05
            IF NOT cl_null(g_oeb5[l_ac].att05) THEN
              IF g_oeb5[l_ac].att05 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att05,'axm-948',0)
                NEXT FIELD att05
              END IF
#              LET arr_detail[l_ac].imx[5] = g_oeb5[l_ac].att05  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[5] = g_oeb5[l_ac].att05     #FUN-C90014 add
        AFTER FIELD att06
            IF NOT cl_null(g_oeb5[l_ac].att06) THEN
              IF g_oeb5[l_ac].att06 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att06,'axm-948',0)
                NEXT FIELD att06
              END IF
#              LET arr_detail[l_ac].imx[6] = g_oeb5[l_ac].att06 #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[6] = g_oeb5[l_ac].att06    #FUN-C90014 add
        AFTER FIELD att07
            IF NOT cl_null(g_oeb5[l_ac].att07) THEN
              IF g_oeb5[l_ac].att07 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att07,'axm-948',0)
                NEXT FIELD att07
              END IF
#              LET arr_detail[l_ac].imx[7] = g_oeb5[l_ac].att07  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[7] = g_oeb5[l_ac].att07     #FUN-C90014 add
        AFTER FIELD att08
            IF NOT cl_null(g_oeb5[l_ac].att08) THEN
              IF g_oeb5[l_ac].att08 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att08,'axm-948',0)
                NEXT FIELD att08
              END IF
#              LET arr_detail[l_ac].imx[8] = g_oeb5[l_ac].att08  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[8] = g_oeb5[l_ac].att08     #FUN-C90014 add
        AFTER FIELD att09
            IF NOT cl_null(g_oeb5[l_ac].att09) THEN
              IF g_oeb5[l_ac].att09 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att09,'axm-948',0)
                NEXT FIELD att09
              END IF
#              LET arr_detail[l_ac].imx[9] = g_oeb5[l_ac].att09  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[9] = g_oeb5[l_ac].att09     #FUN-C90014 add
        AFTER FIELD att10
            IF NOT cl_null(g_oeb5[l_ac].att10) THEN
              IF g_oeb5[l_ac].att10 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att10,'axm-948',0)
                NEXT FIELD att10
              END IF
#              LET arr_detail[l_ac].imx[10] = g_oeb5[l_ac].att10 #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[10] = g_oeb5[l_ac].att10    #FUN-C90014 add
        AFTER FIELD att11
            IF NOT cl_null(g_oeb5[l_ac].att11) THEN
              IF g_oeb5[l_ac].att11 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att11,'axm-948',0)
                NEXT FIELD att11
              END IF
#              LET arr_detail[l_ac].imx[11] = g_oeb5[l_ac].att11  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[11] = g_oeb5[l_ac].att11     #FUN-C90014 add
        AFTER FIELD att12
            IF NOT cl_null(g_oeb5[l_ac].att12) THEN
              IF g_oeb5[l_ac].att12 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att12,'axm-948',0)
                NEXT FIELD att12
              END IF
#              LET arr_detail[l_ac].imx[12] = g_oeb5[l_ac].att12  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[12] = g_oeb5[l_ac].att12     #FUN-C90014 add
        AFTER FIELD att13
            IF NOT cl_null(g_oeb5[l_ac].att13) THEN
              IF g_oeb5[l_ac].att13 <0 THEN
                CALL cl_err(g_oeb5[l_ac].att13,'axm-948',0)
                NEXT FIELD att13
              END IF
#              LET arr_detail[l_ac].imx[13] = g_oeb5[l_ac].att13  #FUN-C90047 mark
            END IF
            LET arr_detail[l_ac].imx[13] = g_oeb5[l_ac].att13     #FUN-C90014 add
 
       AFTER FIELD oeb05
           SELECT ima25 INTO l_ima25 FROM ima_file 
            WHERE ima01 = g_oeb5[l_ac].att00
            IF NOT t410_1_chk_oeb05(l_ima25,p_cmd) THEN #FUN-9C0083
              NEXT FIELD CURRENT
           END IF 
           LET g_oeb[l_ac].oeb05 = g_oeb5[l_ac].oeb05

 
       AFTER FIELD oebislk01
           IF  NOT cl_null(g_oeb5[l_ac].oebislk01) THEN                             
               SELECT COUNT(*) INTO l_m FROM skd_file
                                        WHERE skd01=g_oeb5[l_ac].oebislk01
                                          AND skd04='Y'
                IF l_m <=0 THEN
                   CALL cl_err(g_oeb5[l_ac].oebislk01,'axm1005',0)                                                 
                   NEXT FIELD oebislk01                                             
                END IF                                                          
           END IF
           LET g_oeb[l_ac].oebislk01 = g_oeb5[l_ac].oebislk01
           DISPLAY BY NAME g_oeb5[l_ac].oebislk01
 
        BEFORE FIELD oeb916
           IF NOT cl_null(g_oeb5[l_ac].att00) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file WHERE ima01=g_oeb5[l_ac].att00
           END IF
           LET g_oeb[l_ac].oeb916 = g_oeb5[l_ac].oeb916
 
        AFTER FIELD oeb916  #計價單位
           IF NOT t410_1_chk_oeb916() THEN
              NEXT FIELD CURRENT
           END IF
           IF NOT cl_null(g_oeb5[l_ac].att00) THEN 
             IF g_aza.aza50='Y' THEN
              IF g_oeb5_t.oeb916 IS NULL OR g_oeb5_t.oeb916 <> g_oeb5[l_ac].oeb916 THEN
                 CALL t410_1_price(l_ac,p_cmd) RETURNING l_fac #FUN-9C0083
              END IF
             END IF
           END IF
           LET g_oeb[l_ac].oeb916 = g_oeb5[l_ac].oeb916
           LET g_oeb5[l_ac].oeb1002 = g_oeb[l_ac].oeb1002 
           LET g_oeb5[l_ac].oeb13 = g_oeb[l_ac].oeb13 
           DISPLAY BY NAME g_oeb5[l_ac].oeb1002
           DISPLAY BY NAME g_oeb5[l_ac].oeb13
 
        AFTER FIELD oeb1004
           IF NOT t410_1_chk_oeb1004(p_cmd) THEN #FUN-9C0083
              NEXT FIELD CURRENT
           END IF
           LET g_oeb[l_ac].oeb1004 = g_oeb5[l_ac].oeb1004
		
        AFTER FIELD oeb13
           #FUN-C40089---begin
           IF g_oah08 = 'N' AND g_oeb5[l_ac].oeb13 = 0 THEN
              CALL cl_err(g_oeb5[l_ac].oeb13,'axm-627',0)  #FUN-C50074
              NEXT FIELD oeb13
           END IF
           #FUN-C40089---end
           IF NOT t410_1_chk_oeb13_1() THEN
              NEXT FIELD CURRENT
           ELSE
              IF cl_null(g_oeb5[l_ac].oeb1004) THEN
                 CALL t410_1_chk_oeb13_2()
              END IF
           END IF
           #IF g_oeb5[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN  
           #END IF
           LET g_oeb[l_ac].oeb13 = g_oeb5[l_ac].oeb13
           
        AFTER FIELD oeb15
           LET b_oeb.oeb16 = g_oeb5[l_ac].oeb15    
           IF g_aza.aza50='Y' THEN
              CALL t410_1_price(l_ac,p_cmd) RETURNING l_fac #FUN-9C0083
           END IF
           IF NOT cl_null(g_oeb931) THEN
              
           END IF
           LET g_oeb[l_ac].oeb15 = g_oeb5[l_ac].oeb15
           IF NOT cl_null(g_oeb5[l_ac].oeb15) THEN
              IF g_oeb5_t.oeb15 IS NULL OR g_oeb5_t.oeb15 <> g_oeb5[l_ac].oeb15 THEN
                 CALL t410_1_check() RETURNING g_success
                 IF g_success = 'N' THEN
                    CALL cl_err('','atm-310',0)
                    NEXT FIELD oeb15
                 END IF
                 CALL t410_1_check2() RETURNING g_success
                 IF g_success = 'X' THEN
                    CALL cl_err('','axm-829',0)
                    NEXT FIELD oeb15
                 END IF
              END IF
           END IF
 
        AFTER FIELD oeb1001
           IF NOT cl_null(g_oeb5[l_ac].oeb1001) THEN
              IF g_oeb5_t.oeb1001 IS NULL OR g_oeb5_t.oeb1001 <> g_oeb5[l_ac].oeb1001 THEN
                 CALL t410_1_check() RETURNING g_success
                 IF g_success = 'N' THEN
                    CALL cl_err('','atm-310',0)
                    NEXT FIELD oeb1001
                 END IF
                 CALL t410_1_check2() RETURNING g_success
                 IF g_success = 'N' THEN
                    CALL cl_err('','axm-830',0)
                    NEXT FIELD oeb1001
                 END IF
                 IF NOT t400_1_chk_oeb1001(p_cmd) THEN
                    NEXT FIELD oeb1001
                 END IF
              END IF
           END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_oeb5_t.att00) THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF
            CALL t410_1_b_del() RETURNING g_success
            IF g_success != 'Y' THEN
               CALL cl_err3("del","oeb_file",g_argv1,'',SQLCA.sqlcode,"","",0)   #No.FUN-660081
               ROLLBACK WORK
               CANCEL DELETE
            END IF    
            LET g_rec_b = g_rec_b - 1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
         COMMIT WORK
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_oeb5[l_ac].* = g_oeb5_t.*
            CLOSE t410_1_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_oeb5[l_ac].att00,-263,1)
            LET g_oeb5[l_ac].* = g_oeb5_t.*
         ELSE
               IF NOT cl_null(g_oeb931) THEN
                  CALL t410_1_b_upd() RETURNING g_success
                  IF g_success = 'Y' THEN
                     MESSAGE 'UPDATE O.K'
                     COMMIT WORK
                     CALL t410_1_b_fill(" 1=1")
                  ELSE
                     LET g_oeb5[l_ac].* = g_oeb5_t.*
                  END IF
               ELSE
                  CALL t410_1_b_del() RETURNING g_success
                  IF g_success != 'Y' THEN
                     ROLLBACK WORK
                     LET g_oeb5[l_ac].* = g_oeb5_t.*
                  END IF
 
                  LET arr_detail[l_ac].imx[4] = g_oeb5[l_ac].att04
                  LET arr_detail[l_ac].imx[5] = g_oeb5[l_ac].att05
                  LET arr_detail[l_ac].imx[6] = g_oeb5[l_ac].att06
                  LET arr_detail[l_ac].imx[7] = g_oeb5[l_ac].att07
                  LET arr_detail[l_ac].imx[8] = g_oeb5[l_ac].att08
                  LET arr_detail[l_ac].imx[9] = g_oeb5[l_ac].att09
                  LET arr_detail[l_ac].imx[10] = g_oeb5[l_ac].att10
                  LET arr_detail[l_ac].imx[11] = g_oeb5[l_ac].att11
                  LET arr_detail[l_ac].imx[12] = g_oeb5[l_ac].att12
                  LET arr_detail[l_ac].imx[13] = g_oeb5[l_ac].att13
 
                  CALL t410_1_b_ins(p_cmd,g_oeb5_t.oebislk01) RETURNING g_success
                  IF g_success = 'N' THEN
                     ROLLBACK WORK
                     LET g_oeb5[l_ac].* = g_oeb5_t.*
                  ELSE
                     CALL t410_1_bu()
                     MESSAGE 'UPDATE O.K'
                     CALL t410_1_ins_oebslk()   #FUN-B90101 add
                     COMMIT WORK
                     CALL t410_1_b_fill(" 1=1")
                  END IF
               END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_oeb5[l_ac].* = g_oeb5_t.*
            END IF
            CLOSE t410_1_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE t410_1_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(att00) AND l_ac > 1 THEN
            LET g_oeb5[l_ac].* = g_oeb5[l_ac-1].*
            NEXT FIELD att00
         END IF
 
      ON ACTION CONTROLG
          CALL cl_cmdask()
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(att00)
#FUN-AA0059---------mod------------str-----------------            
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima_p"
#               LET g_qryparam.arg1 = g_oeb934
#               LET g_qryparam.default1= g_oeb5[l_ac].att00
#               CALL cl_create_qry() RETURNING g_oeb5[l_ac].att00
               CALL q_sel_ima(FALSE, "q_ima_p","",g_oeb5[l_ac].att00,g_oeb934,"","","","",'' ) 
                  RETURNING  g_oeb5[l_ac].att00

#FUN-AA0059---------mod------------end-----------------
               NEXT FIELD att00
            WHEN INFIELD(oeb1001)
                 CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf03" 
                    LET g_qryparam.default1 = g_oeb5[l_ac].oeb1001
                    LET g_qryparam.arg1 = '2'    
                    LET g_qryparam.arg2 = '1'   
                 CALL cl_create_qry() RETURNING g_oeb5[l_ac].oeb1001
                 DISPLAY BY NAME g_oeb5[l_ac].oeb1001
                 NEXT FIELD oeb1001
            WHEN INFIELD(oeb05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_oeb5[l_ac].oeb05
                 CALL cl_create_qry() RETURNING g_oeb5[l_ac].oeb05
                 DISPLAY BY NAME g_oeb5[l_ac].oeb05    
                 NEXT FIELD oeb05
 
            WHEN INFIELD(oeb916)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_oeb5[l_ac].oeb916
                 CALL cl_create_qry() RETURNING g_oeb5[l_ac].oeb916
                 DISPLAY BY NAME g_oeb5[l_ac].oeb916
                 NEXT FIELD oeb916
            WHEN INFIELD(oeb1004)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_tqx3" 
                 LET g_qryparam.default1 = g_oeb5[l_ac].oeb1004
                 LET g_qryparam.arg1 = g_oea.oea03  
                 LET g_qryparam.arg2 = g_oea.oea23 
                 LET g_qryparam.where = " (tqz03 ='",g_oeb5[l_ac].att00,"' OR
                                            tqz03 IN (SELECT ima01 FROM ima_file
                                                       WHERE ima135='",g_oeb[l_ac].ima135,"'))" 
                 CALL cl_create_qry() RETURNING g_oeb5[l_ac].oeb1004
                 DISPLAY BY NAME g_oeb5[l_ac].oeb1004
                 NEXT FIELD oeb1004
            WHEN INFIELD(oebislk01)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_skd01"
                 CALL cl_create_qry() RETURNING g_oeb5[l_ac].oebislk01
                 DISPLAY BY NAME g_oeb5[l_ac].oebislk01
                 NEXT FIELD oebislk01
            OTHERWISE
               EXIT CASE
         END CASE
   
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION about
         CALL cl_about()
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END INPUT
 
   CLOSE t410_1_bcl
   COMMIT WORK
 
   CALL t410_1_b_fill("1=1")
END FUNCTION
 
FUNCTION t410_1_bu()
    LET g_oea.oea61 = NULL
    SELECT SUM(oeb14) INTO g_oea.oea61 FROM oeb_file WHERE oeb01 = g_argv1
    IF cl_null(g_oea.oea61) THEN LET g_oea.oea61 = 0 END IF
    CALL cl_digcut(g_oea.oea61,t_azi04) RETURNING g_oea.oea61              
    UPDATE oea_file SET oea61 = g_oea.oea61 WHERE oea01 = g_argv1
    DISPLAY BY NAME g_oea.oea61
END FUNCTION
 
FUNCTION t410_1_oea_sum()  
DEFINE  l_sum1,l_sum1_t  LIKE oeb_file.oeb14,
        l_sum,l_sum_t    LIKE oeb_file.oeb14,
        l_tax,l_tax1     LIKE oeb_file.oeb14,
        l_ttl3           LIKE oea_file.oea61
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04        
     FROM azi_file WHERE azi_file.azi01=g_oea.oea23
   SELECT SUM(oeb14),SUM(oeb14t) INTO l_sum1,l_sum1_t 
     FROM oeb_file
    WHERE oeb01 = g_oea.oea01 
      AND oeb1003='1'
      
   SELECT SUM(oeb14),SUM(oeb14t) INTO l_sum,l_sum_t 
     FROM oeb_file
    WHERE oeb01 = g_oea.oea01 
      AND oeb1003='2'
      
   CALL cl_digcut(l_sum,t_azi04) RETURNING l_sum    
   CALL cl_digcut(l_sum_t,t_azi04) RETURNING l_sum_t 
 
   IF cl_null(l_sum1) THEN LET l_sum1 = 0 END IF
   IF cl_null(l_sum1_t) THEN LET l_sum1_t = 0 END IF
   IF cl_null(l_sum) THEN LET l_sum = 0 END IF
   IF cl_null(l_sum_t) THEN LET l_sum_t = 0 END IF
 
   CALL cl_numfor(l_sum1,8,t_azi04) RETURNING l_sum1 
   CALL cl_numfor(l_sum1_t,8,t_azi04) RETURNING l_sum1_t 
   CALL cl_numfor(l_sum,8,t_azi04) RETURNING l_sum      
   CALL cl_numfor(l_sum_t,8,t_azi04) RETURNING l_sum_t 
 
   UPDATE oea_file SET oea61=l_sum1,oea1008=l_sum1_t
    WHERE oea01=g_oea.oea01
 
   UPDATE oea_file SET oea1006=l_sum,oea1007=l_sum_t
    WHERE oea01=g_oea.oea01
   LET g_oea.oea1006 = l_sum
   LET g_oea.oea1007 = l_sum_t
   LET l_tax = l_sum_t - l_sum
   LET g_oea.oea61=l_sum1
   LET g_oea.oea1008=l_sum1_t
   LET l_tax1=l_sum1_t-l_sum1
   CALL cl_numfor(l_tax,8,t_azi04) RETURNING l_tax    
   CALL cl_numfor(l_tax1,8,t_azi04) RETURNING l_tax1 
 
   LET l_ttl3=g_oea.oea61+l_tax1-g_oea.oea1006-l_tax
   CALL cl_numfor(l_ttl3,8,t_azi04) RETURNING l_ttl3 
   DISPLAY BY NAME g_oea.oea61 
   DISPLAY l_tax1 to FORMONLY.ttl2
   DISPLAY BY NAME g_oea.oea1006 
   DISPLAY l_tax TO FORMONLY.ttl1
   DISPLAY l_ttl3 TO FORMONLY.ttl3
END FUNCTION
 
#DIS only
FUNCTION t410_1_weight_cubage()
DEFINE l_oeb03       LIKE oeb_file.oeb03,
       l_oeb04       LIKE oeb_file.oeb04,
       l_oeb05       LIKE oeb_file.oeb05,
       l_oeb12       LIKE oeb_file.oeb12,
       l1_oea1013,l_oea1013    LIKE oea_file.oea1013,
       l1_oea1014,l_oea1014    LIKE oea_file.oea1014 
       
    DECLARE t400_b2_b CURSOR FOR 
     SELECT oeb03,oeb04,oeb05,oeb12
       FROM oeb_file
      WHERE oeb01 = g_oea.oea01
        AND oeb1003='1'
      ORDER BY oeb03
 
   LET l_oea1013 = 0
   LET l_oea1014 = 0
   FOREACH t400_b2_b INTO l_oeb03,l_oeb04,l_oeb05,l_oeb12
      CALL s_weight_cubage(l_oeb04,l_oeb05,l_oeb12)
                 RETURNING l1_oea1013,l1_oea1014
      LET l_oea1013 = l_oea1013 + l1_oea1013
      LET l_oea1014 = l_oea1014 + l1_oea1014
   END FOREACH
   IF l_oea1013 > 0 OR l_oea1014 > 0 THEN
      LET g_oea.oea1013 = l_oea1013
      LET g_oea.oea1014 = l_oea1014
      UPDATE oea_file SET oea1013 = g_oea.oea1013,
                          oea1014 = g_oea.oea1014
       WHERE oea01 = g_oea.oea01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","oea_file",g_oea.oea01,"",SQLCA.sqlcode,"","upd oea01:",1)  #No.FUN-650108
         RETURN
      END IF
      DISPLAY BY NAME g_oea.oea1013
      DISPLAY BY NAME g_oea.oea1014
   END IF
END FUNCTION
 
FUNCTION t410_1_b_del()
DEFINE l_sqldel      STRING
DEFINE l_wc          STRING
DEFINE l_oeb03       LIKE oeb_file.oeb03
 
    LET g_success = 'Y'
 
    CALL t410_1_wc() RETURNING l_wc 
    LET l_sqldel = "SELECT oeb03 FROM t410_1_tempb",
                   " WHERE ",l_wc CLIPPED
    PREPARE t410_1_del FROM l_sqldel
    DECLARE del_cs CURSOR FOR t410_1_del
 
    FOREACH del_cs INTO l_oeb03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
       DELETE FROM oeb_file WHERE oeb01 = g_argv1
                              AND oeb03 = l_oeb03
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","oeb_file",g_argv1,l_oeb03,SQLCA.sqlcode,"","",1)
          ROLLBACK WORK
          LET g_success = 'N'
          EXIT FOREACH
       ELSE
          DELETE FROM oebi_file WHERE oebi01 = g_argv1
                                  AND oebi03 = l_oeb03
         

          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","oeb_file",g_argv1,'',SQLCA.sqlcode,"","",0)   #No.FUN-660081
             ROLLBACK WORK
             LET g_success = 'N'
             EXIT FOREACH
          ELSE
             IF g_aza.aza50 = 'N' THEN  
                CALL t410_1_bu()    
             ELSE
                CALL t410_1_oea_sum()  
                CALL t410_1_weight_cubage()
             END IF
          END IF 
       END IF 
          
    END FOREACH
 
    RETURN g_success 
 
END FUNCTION
 
FUNCTION t410_1_wc()
DEFINE l_wc          STRING
 
    LET l_wc = "att00 = '",g_oeb5[l_ac].att00,"'"
 
    IF NOT cl_null(g_oeb5[l_ac].att02) THEN
       LET l_wc = l_wc CLIPPED," AND att02 = '",g_oeb5[l_ac].att02,"'"
    END IF
    IF NOT cl_null(g_oeb5[l_ac].att03) THEN
       LET l_wc = l_wc CLIPPED," AND att02 = '",g_oeb5[l_ac].att02,"'"
    END IF
    IF NOT cl_null(g_oeb5[l_ac].att02_c) THEN
       LET l_wc = l_wc CLIPPED," AND att02_c = '",g_oeb5[l_ac].att02_c,"'"
    END IF
    IF NOT cl_null(g_oeb5[l_ac].att03_c) THEN
       LET l_wc = l_wc CLIPPED," AND att03_c = '",g_oeb5[l_ac].att03_c,"'"
    END IF
    IF NOT cl_null(g_oeb5[l_ac].oeb15) THEN
       LET l_wc = l_wc CLIPPED," AND oeb15 = '",g_oeb5[l_ac].oeb15,"'"
    END IF
    IF NOT cl_null(g_oeb5[l_ac].oeb1001) THEN
       LET l_wc = l_wc CLIPPED," AND oeb1001 = '",g_oeb5[l_ac].oeb1001,"'"
    END IF
 
    RETURN l_wc
END FUNCTION
 
FUNCTION t410_1_wc_t()
DEFINE l_wc          STRING
 
    LET l_wc = "att00 = '",g_oeb5_t.att00,"'"
 
    IF NOT cl_null(g_oeb5_t.att02) THEN
       LET l_wc = l_wc CLIPPED," AND att02 = '",g_oeb5_t.att02,"'"
    END IF
    IF NOT cl_null(g_oeb5_t.att03) THEN
       LET l_wc = l_wc CLIPPED," AND att02 = '",g_oeb5_t.att02,"'"
    END IF
    IF NOT cl_null(g_oeb5_t.att02_c) THEN
       LET l_wc = l_wc CLIPPED," AND att02_c = '",g_oeb5_t.att02_c,"'"
    END IF
    IF NOT cl_null(g_oeb5_t.att03_c) THEN
       LET l_wc = l_wc CLIPPED," AND att03_c = '",g_oeb5_t.att03_c,"'"
    END IF
    IF NOT cl_null(g_oeb5_t.oeb15) THEN
       LET l_wc = l_wc CLIPPED," AND oeb15 = '",g_oeb5_t.oeb15,"'"
    END IF
    IF NOT cl_null(g_oeb5_t.oeb1001) THEN
       LET l_wc = l_wc CLIPPED," AND oeb1001 = '",g_oeb5_t.oeb1001,"'"
    END IF
 
    RETURN l_wc
END FUNCTION
 
FUNCTION t410_1_b_upd()
DEFINE l_sqlupd      STRING
DEFINE l_wc          STRING
DEFINE l_oeb03       LIKE oeb_file.oeb03
DEFINE l_oeb15      LIKE oeb_file.oeb15
DEFINE l_oeb14      LIKE oeb_file.oeb14
DEFINE l_oeb14t     LIKE oeb_file.oeb14t
DEFINE l_oeb1001    LIKE oeb_file.oeb1001
DEFINE l_oeb12      LIKE oeb_file.oeb12
 
    LET g_success = 'Y'
 
 
    CALL t410_1_wc_t() RETURNING l_wc 
    LET l_sqlupd = "SELECT oeb03 FROM t410_1_tempb",
                   " WHERE ",l_wc CLIPPED
    PREPARE t410_1_upd FROM l_sqlupd
    DECLARE upd_cs CURSOR FOR t410_1_upd
 
    FOREACH upd_cs INTO l_oeb03
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
  
       SELECT oeb12 INTO l_oeb12 FROM oeb_file
        WHERE oeb01 = g_argv1
          AND oeb03 = l_oeb03
 
        CALL t410_1_set_oeb917()
 
        LET b_oeb.oeb917 =g_oeb[l_ac].oeb917
 
        IF g_sma.sma116 MATCHES '[01]' THEN
           LET b_oeb.oeb917=l_oeb12
           LET b_oeb.oeb917 = s_digqty(b_oeb.oeb917,b_oeb.oeb916)   #FUN-910088--add--
        END IF
 
        IF g_oea.oea213 = 'N' THEN # 不內含
           LET g_oeb[l_ac].oeb14=b_oeb.oeb917*g_oeb5[l_ac].oeb13
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14  
           LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t 
        ELSE 
           LET g_oeb[l_ac].oeb14t=b_oeb.oeb917*g_oeb5[l_ac].oeb13
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t 
           LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14  
        END IF
        IF g_oeb5[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN 
           LET g_oeb[l_ac].oeb14=0
           LET g_oeb[l_ac].oeb14t=0
        END IF
 
        LET l_oeb14 = g_oeb[l_ac].oeb14
        LET l_oeb14t= g_oeb[l_ac].oeb14t
 
       UPDATE oeb_file
          SET oeb05 = g_oeb5[l_ac].oeb05,
              oeb916 = g_oeb5[l_ac].oeb916,
              oeb15 = g_oeb5[l_ac].oeb15,
              oeb1002 = g_oeb5[l_ac].oeb1002,
              oeb1004 = g_oeb5[l_ac].oeb1004,
              oeb13 = g_oeb5[l_ac].oeb13,
              oeb37 = b_oeb.oeb37, #FUN-AB0061
              oeb14 = l_oeb14,
              oeb14t = l_oeb14t,
              oeb1001 = g_oeb5[l_ac].oeb1001,
              oeb1012 = g_oeb5[l_ac].oeb1012 
        WHERE oeb01 = g_argv1
          AND oeb03 = l_oeb03
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","oeb_file",g_argv1,'',SQLCA.sqlcode,"","",0)   #No.FUN-660081
          ROLLBACK WORK
          LET g_success = 'N'
          RETURN g_success
       ELSE
          UPDATE oebi_file SET oebislk01 = g_oeb5[l_ac].oebislk01
           WHERE oebi01 = g_argv1
             AND oebi03 = l_oeb03
          IF SQLCA.SQLERRD[3]=0 THEN
             INSERT INTO oebi_file(oebi01,oebi03,oebislk01,oebiplant,oebilegal)  #FUN-980010 add plant & legal 
                   VALUES (g_argv1,l_oeb03,g_oeb5[l_ac].oebislk01,g_plant,g_legal)
             IF SQLCA.SQLCODE THEN
                CALL cl_err3("ins","oeb_file",g_argv1,'',SQLCA.sqlcode,"","",0)   #No.FUN-660081
                ROLLBACK WORK
                LET g_success = 'N'
                RETURN g_success
             END IF
          ELSE
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","oeb_file",g_argv1,'',SQLCA.sqlcode,"","",0)   #No.FUN-660081
                ROLLBACK WORK
                LET g_success = 'N'
                RETURN g_success
             END IF
          END IF
          IF g_aza.aza50 = 'N' THEN 
             CALL t410_1_bu()     
          ELSE 
             CALL t410_1_oea_sum() 
             CALL t410_1_weight_cubage()
          END IF
       END IF 
          
    END FOREACH
    RETURN g_success 
 
END FUNCTION
 
FUNCTION t410_1_b_ins(p_cmd,p_oebislk01)
DEFINE l_sql           STRING,
       l_i2,l_j2       LIKE type_file.num5,
       l_ps            LIKE sma_file.sma46,
       l_obj02         LIKE obj_file.obj02,
       l_obj03         LIKE obj_file.obj03
DEFINE l_ocq           DYNAMIC ARRAY OF RECORD LIKE ocq_file.*
DEFINE l_str_tok       base.stringTokenizer,
       l_tmp,ls_sql    STRING,
       lc_agb03        LIKE agb_file.agb03,
       l_param_list    STRING
DEFINE l_oeb03         LIKE oeb_file.oeb03
DEFINE l_ima01         LIKE ima_file.ima01
DEFINE l_ima02         LIKE ima_file.ima02
DEFINE p_cmd           LIKE type_file.chr1
DEFINE p_oebislk01     LIKE oebi_file.oebislk01
DEFINE l_tqn   RECORD LIKE tqn_file.*
DEFINE l_n          LIKE type_file.num5     #末維屬性個幾
DEFINE l_i          LIKE type_file.num5     #末維屬性在第幾個
DEFINE l_max        LIKE type_file.num5     #最后一個屬性項次
DEFINE l_min        LIKE type_file.num5     #第一個屬性項次
 
   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN     #防止出現l_ps為空的情況顯示的時候無法解析
      LET l_ps = ' '
   END IF 
    
    LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_oeb933,"'"
    PREPARE t410_1_ocq FROM l_sql
    DECLARE ocq_curs1 CURSOR FOR t410_1_ocq
       LET l_i2 = 1
    FOREACH ocq_curs1 INTO l_ocq[l_i2].*
       LET l_j2 = l_i2 + 3
       IF NOT cl_null(arr_detail[l_ac].imx[l_j2]) AND arr_detail[l_ac].imx[l_j2] != 0 THEN
 
          CALL t410_1_oeb04(l_ocq[l_i2].ocq04,l_ocq[l_i2].ocq05) RETURNING g_oeb5[l_ac].oeb04,g_oeb06         
 
          #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
          LET l_param_list = NULL  #每次傳之前要先清空
          LET l_str_tok = base.StringTokenizer.create(g_oeb[l_ac].oeb04,l_ps)
          LET l_tmp = l_str_tok.nextToken()   
 
          LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                       "ima01 = '",g_oeb5[l_ac].att00 CLIPPED,"' AND agb01 = imaag ",
                       "ORDER BY agb02"  
          DECLARE param_curs CURSOR FROM ls_sql
          FOREACH param_curs INTO lc_agb03
             IF cl_null(l_param_list) THEN
                LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
             ELSE
                LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
             END IF
          END FOREACH
               
          LET l_param_list = l_param_list,'|#',l_ocq[l_i2].ocq05,'|#',l_ocq[l_i2].ocq05
          
          SELECT MAX(oeb03) INTO l_oeb03 FROM oeb_file
           WHERE oeb01 = g_argv1
          IF cl_null(l_oeb03) THEN
             LET l_oeb03 = 1
          ELSE 
             LET l_oeb03 = l_oeb03 +1 
          END IF
 
     LET b_oeb.oeb01 = g_argv1
     LET b_oeb.oeb03 = l_oeb03
     LET b_oeb.oeb04 = g_oeb5[l_ac].oeb04
     LET b_oeb.oeb05 = g_oeb5[l_ac].oeb05
     LET b_oeb.oeb13 = g_oeb5[l_ac].oeb13
     IF NOT cl_null(g_oeb932) THEN
       LET b_oeb.oeb12 = arr_detail[l_ac].imx[l_j2]*g_oeb932
     ELSE 
       LET b_oeb.oeb12 = arr_detail[l_ac].imx[l_j2]
     END IF
     LET b_oeb.oeb12 = s_digqty(b_oeb.oeb12,b_oeb.oeb05)   #FUN-910088--add--
     LET b_oeb.oeb931 = g_oeb931
     LET b_oeb.oeb932 = g_oeb932
     LET b_oeb.oeb933 = g_oeb933
     LET b_oeb.oeb934 = g_oeb934
     SELECT ima31_fac INTO b_oeb.oeb05_fac FROM ima_file 
      WHERE ima01 = g_oeb5[l_ac].att00
     LET b_oeb.oeb06 = g_oeb06
     SELECT ima35,ima36 INTO g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091 FROM ima_file
      WHERE ima01 = g_oeb5[l_ac].oeb04
 
        IF cl_null(b_oeb.oeb05_fac) THEN
           LET b_oeb.oeb05_fac = 1
        END IF
 
        CALL t410_1_set_oeb917()
        CALL t410_1_g_du(b_oeb.oeb04,b_oeb.oeb05,b_oeb.oeb12)
 
        LET b_oeb.oeb916 =g_oeb5[l_ac].oeb916
        LET b_oeb.oeb917 =g_oeb[l_ac].oeb917
 
        IF g_sma.sma116 MATCHES '[01]' THEN
           LET b_oeb.oeb916=b_oeb.oeb05
           LET b_oeb.oeb917=b_oeb.oeb12
        END IF
 
        IF g_oea.oea213 = 'N' THEN # 不內含
           LET g_oeb[l_ac].oeb14=b_oeb.oeb917*g_oeb5[l_ac].oeb13
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14  
           LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t 
        ELSE 
           LET g_oeb[l_ac].oeb14t=b_oeb.oeb917*g_oeb5[l_ac].oeb13
           CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t 
           LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
           CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14  
        END IF
        IF g_oeb5[l_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN 
           LET g_oeb[l_ac].oeb14=0
           LET g_oeb[l_ac].oeb14t=0
        END IF
        LET b_oeb.oeb14 = g_oeb[l_ac].oeb14
        LET b_oeb.oeb14t = g_oeb[l_ac].oeb14t
 
        LET b_oeb.oeb15 = g_oeb5[l_ac].oeb15
        LET b_oeb.oeb16 = g_oeb5[l_ac].oeb15
       #LET b_oeb.oeb72 = g_oeb5[l_ac].oeb15   #FUN-B20060 add   #CHI-C80060 mark
        LET b_oeb.oeb72 = NULL                 #CHI-C80060 add
        LET b_oeb.oeb19 = 'N'                 
        LET b_oeb.oeb23 = 0 LET b_oeb.oeb24 = 0
        LET b_oeb.oeb25 = 0 LET b_oeb.oeb26 = 0
        LET b_oeb.oeb70 = 'N'
        LET b_oeb.oeb71 = g_oea.oea71
        IF cl_null(b_oeb.oeb15) THEN
             LET b_oeb.oeb15=g_today
             LET b_oeb.oeb16=g_today
        END IF
        LET b_oeb.oeb905 = 0 
        SELECT ima35,ima36 INTO g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091 FROM ima_file
         WHERE ima01 = g_oeb5[l_ac].att00
        LET b_oeb.oeb09 = g_oeb[l_ac].oeb09
        LET b_oeb.oeb091= g_oeb[l_ac].oeb091
        IF cl_null(b_oeb.oeb091) THEN LET b_oeb.oeb091=' ' END IF
        IF cl_null(b_oeb.oeb092) THEN LET b_oeb.oeb092=' ' END IF
        LET b_oeb.oeb1003 = '1' 
        LET b_oeb.oeb930=s_costcenter(g_oea.oea15)
         LET b_oeb.oeb920 = 0
         SELECT obk11 INTO b_oeb.oeb906
           FROM obk_file
          WHERE obk01 = b_oeb.oeb04
            AND obk02 = g_oea.oea03
         IF cl_null(b_oeb.oeb906) THEN
             LET b_oeb.oeb906 = 'N' 
         END IF
        LET b_oeb.oeb1001 = g_oeb5[l_ac].oeb1001
        LET b_oeb.oeb1002 = g_oeb5[l_ac].oeb1002
        LET b_oeb.oeb1004 = g_oeb5[l_ac].oeb1004
        LET b_oeb.oeb1012 = g_oeb5[l_ac].oeb1012
 
   IF g_aza.aza50 = 'Y' THEN  #No.FUN-650108  
      IF g_value IS NOT NULL THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt
           FROM tqm_file,tqn_file
          WHERE tqn01 = tqm01
            AND tqm01 = g_oeb[l_ac].oeb1002
            AND tqn03 = g_value
         IF g_cnt = 0 THEN
            INITIALIZE  l_tqn.* TO NULL
            SELECT tqn_file.* INTO l_tqn.*
              FROM tqm_file,tqn_file
             WHERE tqn01 = tqm01
               AND tqm01 = g_oeb[l_ac].oeb1002
               AND tqn03 = g_oeb04
            SELECT MAX(tqn02) INTO l_tqn.tqn02
              FROM tqm_file,tqn_file
             WHERE tqn01 = tqm01
               AND tqm01 = g_oeb[l_ac].oeb1002
            LET l_tqn.tqn02 = l_tqn.tqn02+1
            LET l_tqn.tqn03 = g_value
            INSERT INTO tqn_file VALUES(l_tqn.*)
            IF SQLCA.sqlcode THEN            
               CALL cl_err3("ins tqn","tqn_file",l_tqn.tqn01,"",SQLCA.sqlcode,"","ins oeb",1)  #No.FUN-650108
               RETURN FALSE
            END IF
         END IF
      END IF
   END IF
          LET b_oeb.oeb44 = '1' #No.FUN-870007
          LET b_oeb.oeb47 = 0  #No.FUN-870007
          LET b_oeb.oeb48 = '1' #No.FUN-870007
 
          LET b_oeb.oebplant = g_plant 
          LET b_oeb.oeblegal = g_legal 
          IF cl_null(b_oeb.oeb37) OR b_oeb.oeb37 = 0 THEN LET b_oeb.oeb37 = b_oeb.oeb13 END IF      #FUN-AB0061    
          INSERT INTO oeb_file VALUES(b_oeb.*)
          IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","oeb_file",b_oeb.oeb01,"",SQLCA.sqlcode,"","ins oeb",1)  
            RETURN FALSE
            EXIT FOREACH
          ELSE
            IF cl_null(p_oebislk01) THEN
               LET p_oebislk01= g_oeb5[l_ac].oebislk01 
            END IF
            IF p_cmd = 'a' THEN    #如果是update的時候，則制造單號用舊值
               INSERT INTO oebi_file(oebi01,oebi03,oebislk01,oebiplant,oebilegal)  #FUN-980010 add plant & legal 
                           VALUES(g_argv1,l_oeb03,g_oeb5[l_ac].oebislk01,g_plant,g_legal)
            ELSE
             	 IF g_oeb5[l_ac].oebislk01  != p_oebislk01 THEN
             	    INSERT INTO oebi_file(oebi01,oebi03,oebislk01,oebiplant,oebilegal) #FUN-980010 add plant & legal
                                VALUES(g_argv1,l_oeb03,g_oeb5[l_ac].oebislk01,g_plant,g_legal)
             	 ELSE
                  INSERT INTO oebi_file(oebi01,oebi03,oebislk01,oebiplant,oebilegal) #FUN-980010 add plant & legal
                              VALUES(g_argv1,l_oeb03,p_oebislk01,g_plant,g_legal)
               END IF
            END IF
            IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","oebi_file",g_argv1,"",SQLCA.sqlcode,"","ins oebi",1)  
              RETURN FALSE
              EXIT FOREACH
            ELSE
              MESSAGE 'INSERT OK'
              IF cl_copy_ima(g_oeb5[l_ac].att00,g_oeb5[l_ac].oeb04,g_oeb06,l_param_list) = TRUE THEN
                 SELECT COUNT(*) INTO l_n FROM agb_file WHERE agb01 = g_oeb934
                 SELECT MAX(agb02) INTO l_max FROM agb_file WHERE agb01 = g_oeb934
                 SELECT MIN(agb02) INTO l_min FROM agb_file WHERE agb01 = g_oeb934
                 SELECT DISTINCT agb02 INTO l_i FROM ocq_file,agb_file
                  WHERE ocq01 = g_oeb933
                    AND ocq03 = agb03
                IF l_max = l_min THEN    #如果最大的和最小的相同，證明只有一個
                   LET l_max = 4000      #讓最大的不能等于l_i
                END IF
                IF l_i = l_max AND l_n = 3 THEN        #最后一個屬性為末維屬性
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES(g_oeb5[l_ac].oeb04,g_oeb5[l_ac].att00,arr_detail[l_ac].imx[2],
                            arr_detail[l_ac].imx[3],l_ocq[l_i2].ocq04)
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_oeb5[l_ac].oeb04,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_oeb5[l_ac].oeb04
                      RETURN FALSE
                   END IF
                END IF
                IF l_i = l_max AND l_n = 2 THEN        #最后一個屬性為末維屬性
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02) 
                     VALUES(g_oeb5[l_ac].oeb04,g_oeb5[l_ac].att00,arr_detail[l_ac].imx[2],
                            l_ocq[l_i2].ocq04)
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_oeb5[l_ac].oeb04,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_oeb5[l_ac].oeb04
                      RETURN FALSE
                   END IF
                END IF
                IF l_i > l_min AND l_i < l_max THEN     #中間的屬性是末維屬性 
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES(g_oeb5[l_ac].oeb04,g_oeb5[l_ac].att00,arr_detail[l_ac].imx[2],l_ocq[l_i2].ocq04,
                            arr_detail[l_ac].imx[3])
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_oeb5[l_ac].oeb04,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_oeb5[l_ac].oeb04
                      RETURN FALSE
                   END IF
                END IF
                IF l_i = l_min THEN
                   INSERT INTO imx_file(imx000,imx00,imx01,imx02,imx03) 
                     VALUES(g_oeb5[l_ac].oeb04,g_oeb5[l_ac].att00,l_ocq[l_i2].ocq04,arr_detail[l_ac].imx[2],
                            arr_detail[l_ac].imx[3])
                   #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
                   #記錄的完全同步
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("ins","imx_file",g_oeb5[l_ac].oeb04,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1)
                      DELETE FROM ima_file WHERE ima01 = g_oeb5[l_ac].oeb04
                      RETURN FALSE
                   END IF
                END IF
              END IF
            END IF 
          END IF
 
       END IF
       LET l_i2 = l_i2 + 1 
    END FOREACH 
    CALL arr_detail.clear()
    RETURN TRUE
   
END FUNCTION

#FUN-B90101--add--begin--
FUNCTION t410_1_ins_oebslk()
   DEFINE l_oebslk    RECORD LIKE oebslk_file.*,
          l_oeb03     LIKE oeb_file.oeb03  
     
   #根據oeb_file的資料，產生oebslk_file的資料
   DECLARE t410_1_oebslk2 CURSOR FOR SELECT MIN(oeb03),SUM(oeb12),SUM(oeb14),SUM(oeb14t),
                                           SUM(oeb23),SUM(oeb24),SUM(oeb25),SUM(oeb26),SUM(oeb28)
                                      FROM oeb_file,oebi_file,imx_file
                                     WHERE oeb01 = oebi01
                                       AND oeb03 = oebi03
                                       AND oeb04=imx000
                                       AND oeb01 = g_argv1
                                       AND oeb933 = g_oeb933
                                       AND oeb934 = g_oeb934
                                       AND imx00 = g_oeb5[l_ac].att00 
                                      GROUP BY imx00
   FOREACH t410_1_oebslk2 INTO l_oeb03,l_oebslk.oebslk12,l_oebslk.oebslk14,l_oebslk.oebslk14t,
                              l_oebslk.oebslk23,l_oebslk.oebslk24,l_oebslk.oebslk25,
                              l_oebslk.oebslk26,l_oebslk.oebslk28
      LET l_oebslk.oebslk01=g_argv1
      SELECT MAX(oebslk03)+1 INTO l_oebslk.oebslk03 FROM oebslk_file WHERE oebslk01=g_argv1
      IF cl_null(l_oebslk.oebslk03) THEN
         LET l_oebslk.oebslk03=1
      END IF
      LET l_oebslk.oebslk04 = g_oeb5[l_ac].att00
      SELECT ima02 INTO l_oebslk.oebslk06 FROM ima_file WHERE ima01=l_oebslk.oebslk04
      SELECT imc02 INTO l_oebslk.oebslk07 FROM imc_file WHERE imc01=l_oebslk.oebslk04

      SELECT oeb05,oeb05_fac,oeb09,oeb091,oeb092,oeb11,
             oeb13,oeb1006,oebplant,oeblegal
        INTO l_oebslk.oebslk05,l_oebslk.oebslk05_fac,l_oebslk.oebslk09,l_oebslk.oebslk091,
             l_oebslk.oebslk092,l_oebslk.oebslk11,l_oebslk.oebslk13,
             l_oebslk.oebslk1006,l_oebslk.oebslkplant,l_oebslk.oebslklegal
        FROM oeb_file
       WHERE oeb01=g_argv1 AND oeb03=l_oeb03
      IF cl_null(l_oebslk.oebslk1006) THEN
         LET l_oebslk.oebslk1006=100
      END IF
      IF cl_null(l_oebslk.oebslk28) THEN
         LET l_oebslk.oebslk28=0
      END IF
      LET l_oebslk.oebslk131=l_oebslk.oebslk13*(l_oebslk.oebslk1006/100)
      INSERT INTO oebslk_file VALUES(l_oebslk.*)
      IF STATUS THEN
         CALL cl_err3("ins","oebslk_file","","",SQLCA.sqlcode,"","ins oebslk",1)
         EXIT FOREACH
      ELSE
         UPDATE oebi_file SET oebislk02=l_oebslk.oebslk04,
                              oebislk03=l_oebslk.oebslk03
           WHERE oebi01=g_argv1
             AND oebi03 IN (SELECT oeb03 FROM oeb_file,imx_file
                             WHERE oeb01=g_argv1
                               AND oeb04=imx000
                               AND imx00=l_oebslk.oebslk04)
         IF STATUS THEN
            CALL cl_err3("upd","oeb_file","","",SQLCA.sqlcode,"","",1)
            EXIT FOREACH
         END IF
      END IF

   END FOREACH

END FUNCTION
#FUN-B90101--add--end- 
#組成子料件及品名的過程放在這個函數里面，在_b_ins()里面調用
FUNCTION t410_1_oeb04(p_ocq04,p_ocq05)
DEFINE  p_ocq04       LIKE ocq_file.ocq04
DEFINE  p_ocq05       LIKE ocq_file.ocq05
DEFINE  l_n           LIKE type_file.num5     #屬性的個數
DEFINE  l_i           LIKE type_file.num5     #末維屬性在第幾個
DEFINE  l_max         LIKE type_file.num5     #最后一個屬性項次
DEFINE  l_min         LIKE type_file.num5     #第一個屬性項次
DEFINE  l_ps          LIKE sma_file.sma46     #系統標準的分割符
DEFINE  l_agd03       LIKE agd_file.agd03
 
    LET g_success = 'Y'
 
    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps = ' '
    END IF
 
    LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].att00
    LET g_oeb06 = g_oeb5[l_ac].att01
 
    SELECT COUNT(*) INTO l_n FROM agb_file WHERE agb01 = g_oeb934
    SELECT MAX(agb02) INTO l_max FROM agb_file WHERE agb01 = g_oeb934
    SELECT MIN(agb02) INTO l_min FROM agb_file WHERE agb01 = g_oeb934
    SELECT DISTINCT agb02 INTO l_i FROM ocq_file,agb_file
     WHERE ocq01 = g_oeb933
       AND ocq03 = agb03
    IF l_max = l_min THEN    #如果最大的和最小的相同，證明只有一個
       LET l_max = 4000      #讓最大的不能等于l_i
    END IF
 
    IF l_i = l_max THEN                     #最后一個屬性是末維屬性
       IF NOT cl_null(g_oeb5[l_ac].att02) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att02
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_oeb5[l_ac].att02
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att02
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att02_c) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att02_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_oeb5[l_ac].att02_c
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att02_c
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att03) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att03
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_oeb5[l_ac].att03
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att03
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att03_c) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att03_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_oeb5[l_ac].att03_c
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att03_c
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,p_ocq04
       LET g_oeb06 = g_oeb06 CLIPPED,l_ps,p_ocq05
    END IF
 
    IF l_i = l_min THEN                     #第一個屬性是末維屬性
       LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,p_ocq04
       LET g_oeb06 = g_oeb06 CLIPPED,l_ps,p_ocq05
       IF NOT cl_null(g_oeb5[l_ac].att02) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att02
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_oeb5[l_ac].att02
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att02
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att02_c) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att02_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[2].agc01 AND agd02 = g_oeb5[l_ac].att02_c
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att02_c
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att03) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att03
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_oeb5[l_ac].att03
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att03
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att03_c) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att03_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_oeb5[l_ac].att03_c
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att03_c
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
    END IF
 
    IF l_i > l_min AND l_i < l_max THEN     #中間的屬性是末維屬性 
       IF NOT cl_null(g_oeb5[l_ac].att02) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att02
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_oeb5[l_ac].att02
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att02
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att02_c) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att02_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[1].agc01 AND agd02 = g_oeb5[l_ac].att02_c
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att02_c
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,p_ocq04
       LET g_oeb06 = g_oeb06 CLIPPED,l_ps,p_ocq05
       IF NOT cl_null(g_oeb5[l_ac].att03) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att03
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_oeb5[l_ac].att03
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att03
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
       IF NOT cl_null(g_oeb5[l_ac].att03_c) THEN
          LET g_oeb5[l_ac].oeb04 = g_oeb5[l_ac].oeb04 CLIPPED,l_ps,g_oeb5[l_ac].att03_c
          LET l_agd03 = ''
          SELECT agd03 INTO l_agd03 FROM agd_file
           WHERE agd01 = lr_agc[3].agc01 AND agd02 = g_oeb5[l_ac].att03_c
          IF cl_null(l_agd03) THEN
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,g_oeb5[l_ac].att03_c
          ELSE
             LET g_oeb06 = g_oeb06 CLIPPED,l_ps,l_agd03
          END IF
       END IF
    END IF
 
    RETURN g_oeb5[l_ac].oeb04,g_oeb06
 
END FUNCTION
 
FUNCTION t410_1_set_oeb917()
   DEFINE l_item     LIKE img_file.img01,     #料號
          l_ima25    LIKE ima_file.ima25,     #ima單位
          l_ima31    LIKE ima_file.ima31,     #銷售單位
          l_ima906   LIKE ima_file.ima906,
          l_fac2     LIKE img_file.img21,     #第二轉換率
          l_qty2     LIKE img_file.img10,     #第二數量
          l_fac1     LIKE img_file.img21,     #第一轉換率
          l_qty1     LIKE img_file.img10,     #第一數量
          l_tot      LIKE img_file.img10,     #計價數量
          l_unit     LIKE ima_file.ima25,  
          l_unit1    LIKE ima_file.ima25,  
          l_factor   LIKE ima_file.ima31_fac 
 
   SELECT ima25,ima31,ima906
     INTO l_ima25,l_ima31,l_ima906
     FROM ima_file
    WHERE ima01=g_oeb5[l_ac].att00
 
   IF SQLCA.sqlcode = 100 THEN
      IF g_oeb5[l_ac].att00 MATCHES 'MISC*' THEN
         SELECT ima25,ima31,ima906
           INTO l_ima25,l_ima31,l_ima906
           FROM ima_file
          WHERE ima01='MISC'
      END IF
   END IF
 
   IF cl_null(l_ima31) THEN
      LET l_ima31=l_ima25
   END IF
 
   LET l_fac2=g_oeb[l_ac].oeb914
   LET l_qty2=g_oeb[l_ac].oeb915
 
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=g_oeb[l_ac].oeb911
      LET l_qty1=g_oeb[l_ac].oeb912
      LET l_unit1=g_oeb[l_ac].oeb910 
   ELSE
      LET l_fac1=1
      LET l_qty1=b_oeb.oeb12
      CALL s_umfchk(g_oeb5[l_ac].att00,g_oeb5[l_ac].oeb05,l_ima31)
          RETURNING g_cnt,l_fac1
      IF g_cnt = 1 THEN
         LET l_fac1 = 1
      END IF
      LET l_unit1=g_oeb5[l_ac].oeb05 
   END IF
 
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
 
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF
 
   IF cl_null(l_tot) THEN
      LET l_tot = 0 
   END IF
 
   IF g_sma.sma116 MATCHES '[01]' THEN  #FUN-610076
      IF g_sma.sma115 = 'Y' THEN
         CASE l_ima906
            WHEN '1' LET l_unit=l_unit1
            WHEN '2' LET l_unit=l_ima31
            WHEN '3' LET l_unit=l_unit1
         END CASE
      ELSE  #不使用雙單位
         LET l_unit=l_unit1
      END IF
      LET g_oeb[l_ac].oeb916=l_unit
   END IF
 
   LET l_factor = 1
   IF g_sma.sma115='Y' THEN
      CALL s_umfchk(g_oeb5[l_ac].att00,g_oeb5[l_ac].oeb05,g_oeb5[l_ac].oeb916)
          RETURNING g_cnt,l_factor
   ELSE
   CALL s_umfchk(g_oeb5[l_ac].att00,l_ima31,g_oeb5[l_ac].oeb916)
       RETURNING g_cnt,l_factor
   END IF                                         #No.CHI-960052 
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
 
   LET l_tot = l_tot * l_factor
   LET g_oeb[l_ac].oeb917 = l_tot
   LET g_oeb[l_ac].oeb917 = s_digqty(g_oeb[l_ac].oeb917,g_oeb[l_ac].oeb916)    #FUN-910088--add--
 
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t410_1_set_origin_field(p_code)
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE oeb_file.oeb914,
            l_qty2   LIKE oeb_file.oeb915,
            l_fac1   LIKE oeb_file.oeb911,
            l_qty1   LIKE oeb_file.oeb912,
            l_factor LIKE ima_file.ima31_fac, 
            l_ima25  LIKE ima_file.ima25,
            l_ima31  LIKE ima_file.ima31,
            p_code   LIKE type_file.chr1   
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima31 INTO l_ima25,l_ima31
      FROM ima_file WHERE ima01=g_oeb[l_ac].oeb04
    IF SQLCA.sqlcode = 100 THEN
       IF g_oeb[l_ac].oeb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31 INTO l_ima25,l_ima31
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF
 
    LET l_fac2=g_oeb[l_ac].oeb914
    LET l_qty2=g_oeb[l_ac].oeb915
    LET l_fac1=g_oeb[l_ac].oeb911
    LET l_qty1=g_oeb[l_ac].oeb912
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_oeb[l_ac].oeb05=g_oeb[l_ac].oeb910
                   LET g_oeb[l_ac].oeb12=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_oeb[l_ac].oeb05=l_ima31
                   LET g_oeb[l_ac].oeb12=l_tot
          WHEN '3' LET g_oeb[l_ac].oeb05=g_oeb[l_ac].oeb910
                   LET g_oeb[l_ac].oeb12=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_oeb[l_ac].oeb914=l_qty1/l_qty2
                   ELSE
                      LET g_oeb[l_ac].oeb914=0
                   END IF
       END CASE
       LET g_oeb[l_ac].oeb12 = s_digqty(g_oeb[l_ac].oeb12,g_oeb[l_ac].oeb05)    #FUN-910088--add--
    END IF
 
    LET g_factor = 1
    CALL s_umfchk(g_oeb[l_ac].oeb04,g_oeb[l_ac].oeb05,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET b_oeb.oeb05_fac = g_factor
 
END FUNCTION 
 
FUNCTION t410_1_chk_oeb05(l_ima25,p_cmd) #FUN-9C0083
   DEFINE l_check LIKE type_file.chr1  
   DEFINE l_ima25 LIKE ima_file.ima25,
          l_fac   LIKE oeb_file.oeb05_fac
   DEFINE p_cmd   LIKE type_file.chr1 #FUN-9C0083 
   IF NOT cl_null(g_oeb5[l_ac].oeb05) THEN
      SELECT COUNT(*) INTO g_cnt FROM gfe_file
       WHERE gfe01 = g_oeb5[l_ac].oeb05
      IF g_cnt = 0 THEN
         CALL cl_err(g_oeb5[l_ac].oeb05,'mfg3377',0) 
         RETURN FALSE
      END IF
      CALL s_umfchk(g_oeb5[l_ac].att00,g_oeb5[l_ac].oeb05,l_ima25)
          RETURNING l_check,b_oeb.oeb05_fac
      IF l_check = '1'  THEN
         CALL cl_err(g_oeb5[l_ac].oeb05,'abm-731',1)
         RETURN FALSE
      END IF
      IF g_oeb[l_ac].oeb917 = 0 OR
            (g_oeb5_t.oeb05  <> g_oeb5[l_ac].oeb05 OR
             g_oeb_t.oeb917 <> g_oeb[l_ac].oeb917) THEN
         
         IF g_sma.sma116 MATCHES '[01]' THEN
            LET g_oeb5[l_ac].oeb916 = g_oeb5[l_ac].oeb05
         END IF
 
         CALL t410_1_set_oeb917()
      END IF
      IF g_aza.aza50 = 'Y' THEN  
         IF NOT cl_null(g_oeb5[l_ac].att00) AND g_sma.sma116 MATCHES '[01]' THEN
            IF g_oeb5_t.oeb05 IS NULL OR g_oeb5_t.oeb05 <> g_oeb5[l_ac].oeb05 THEN
               CALL t410_1_price(l_ac,p_cmd) RETURNING l_fac #FUN-9C0083
            END IF
         END IF
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t410_1_chk_oeb916()
   DEFINE l_fac   LIKE oeb_file.oeb05_fac
 
   IF cl_null(g_oeb5[l_ac].att00) THEN RETURN FALSE END IF
   IF g_oeb_t.oeb916 IS NULL AND g_oeb[l_ac].oeb916 IS NOT NULL OR
      g_oeb_t.oeb916 IS NOT NULL AND g_oeb[l_ac].oeb916 IS NULL OR
      g_oeb_t.oeb916 <> g_oeb[l_ac].oeb916 THEN
      LET g_change1='Y'
   END IF
   IF NOT cl_null(g_oeb[l_ac].oeb916) THEN
      SELECT gfe02 INTO g_buf FROM gfe_file
       WHERE gfe01=g_oeb[l_ac].oeb916
         AND gfeacti='Y'
      IF STATUS THEN
         CALL cl_err3("sel","gfe_file",g_oeb[l_ac].oeb916,"",STATUS,"","gfe:",1)
         RETURN FALSE
      END IF
      CALL s_du_umfchk(g_oeb5[l_ac].att00,'','','',
                       g_ima31,g_oeb5[l_ac].oeb916,'1')
           RETURNING g_errno,g_factor
      IF NOT cl_null(g_errno) THEN
         CALL cl_err(g_oeb5[l_ac].oeb916,g_errno,0)
         RETURN FALSE
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t410_1_chk_oeb1004(p_cmd) #FUN-9C0083
   DEFINE l_fac LIKE oeb_file.oeb05_fac
   DEFINE p_cmd LIKE type_file.chr1 #FUN-9C0083
   IF NOT cl_null(g_oeb5[l_ac].oeb1004) THEN
      SELECT * FROM tqx_file,tqy_file,tqz_file,tsa_file
       WHERE tqx01=tqy01 AND tqx01=tqz01 
         AND tqx01=tsa01 AND tqy02=tsa02 
         AND tqz02=tsa03 AND tqy03=g_oea.oea03  
         AND tqy37= 'Y'  AND tqx07= '3'
         AND tqx09=g_oea.oea23 
         AND tqx01=g_oeb5[l_ac].oeb1004
         AND (tqz03 =g_oeb5[l_ac].oeb04 OR
              tqz03 IN (SELECT ima01 FROM ima_file
                         WHERE ima135=g_oeb[l_ac].ima135))
      IF STATUS = 100 THEN
         CALL cl_err3("sel","tqx_file,tqy_file,tqz_file,tsa_file","","","anm-027","","",1) 
         RETURN FALSE
      END IF
   END IF
   CALL t410_1_price(l_ac,p_cmd) RETURNING l_fac #FUN-9C0083
   IF l_fac THEN
      RETURN FALSE
   END IF
  RETURN TRUE
END FUNCTION
 
FUNCTION t410_1_price(p_ac,p_cmd) #FUN-9C0083
DEFINE l_n             LIKE type_file.num5, 
       p_ac            LIKE type_file.num5, 
       l_success       LIKE type_file.chr1, 
       l_ima135        LIKE ima_file.ima135,
       l_tqz09         LIKE tqz_file.tqz09,
       l_tqx14         LIKE tqx_file.tqx14,
       l_tqx16         LIKE tqx_file.tqx16,
       l_tqz08         LIKE tqz_file.tqz08,
       l_oeb05         LIKE oeb_file.oeb05,
       l_flag          LIKE type_file.chr1, 
       l_unitrate      LIKE ima_file.ima31_fac,
       l_unit          LIKE ima_file.ima31, 
       l_tqz06         LIKE tqz_file.tqz06,
       l_tqz07         LIKE tqz_file.tqz07,
       l_tqy38         LIKE tqy_file.tqy38,
       l_tqx13         LIKE tqx_file.tqx13
DEFINE l_occ1027       LIKE occ_file.occ1027 
DEFINE l_oeb12         LIKE oeb_file.oeb12 #FUN-9C0083   
DEFINE p_cmd           LIKE type_file.chr1 #FUN-9C0083    
   IF cl_null(g_oeb5[p_ac].oeb15) THEN
      CALL cl_err('','atm-040',0)
      RETURN 0
   END IF
   IF g_sma.sma115 = 'Y' AND cl_null(g_oeb5[p_ac].oeb05) THEN
      CALL t410_1_set_origin_field('m')
   END IF
   IF cl_null(g_oeb5[p_ac].oeb916) THEN
      LET g_oeb[p_ac].oeb917 = g_oeb[p_ac].oeb12
      LET g_oeb[p_ac].oeb917 = s_digqty(g_oeb[p_ac].oeb917,g_oeb[p_ac].oeb916)   #FUN-910088--add--
   END IF
   IF NOT cl_null(g_oeb5[p_ac].oeb1004) AND g_oeb5[p_ac].oeb1012 = 'N' THEN
      LET g_oeb5[p_ac].oeb1002=' '
      LET g_oeb5[p_ac].oeb13=' '
      SELECT COUNT(*) INTO l_n 
        FROM tqx_file,tqy_file
       WHERE tqx01=g_oeb5[p_ac].oeb1004
         AND tqx01=tqy01
         AND tqy03=g_oea.oea03  
         AND tqx13=g_oea.oea1002
         AND tqx07='3'
         AND tqy37='Y'
         AND tqx09=g_oea.oea23
      IF l_n = 0 THEN
         CALL cl_err('sel tqx_file',STATUS,0)
         RETURN 1
      END IF
       IF g_sma.sma116 MATCHES '[23]' THEN
          LET l_oeb05=g_oeb5[p_ac].oeb916
       ELSE
          LET l_oeb05=g_oeb5[p_ac].oeb05
       END IF
       SELECT oeb12 INTO l_oeb12 FROM oeb_file
        WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb5[p_ac].oeb03
       LET l_oeb12 = s_digqty(l_oeb12,l_oeb05)    #FUN-910088--add--
       CALL s_fetch_price_new(g_oea.oea03,g_oeb5[p_ac].att00,'',l_oeb05,g_oeb5[p_ac].oeb15,g_oea.oea00,g_plant,      #FUN-BC0071
                              g_oea.oea23,g_oea.oea31,g_oea.oea32,g_oea.oea01,g_oeb5[p_ac].oeb03,l_oeb12,
                              g_oeb5[p_ac].oeb1004,p_cmd)
           # RETURNING g_oeb5[p_ac].oeb13  #FUN-AB0061  
             RETURNING g_oeb5[l_ac].oeb13,b_oeb.oeb37  #FUN-AB0061 
      #FUN-B70087 mod
      #IF g_oeb5[p_ac].oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant) END IF #FUN-9C0120
       #FUN-BC0088 ----- add start --------
       IF g_oeb5[p_ac].oeb04[1,4] = 'MISC' THEN
          CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant,'M')
       ELSE
       #FUN-BC0088 ----- add end --------
          IF g_oeb5[p_ac].oeb13 = 0 THEN
             CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant,'N')
          ELSE
             CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant,'Y')
          END IF
       END IF  #FUN-BC0088 add
      #FUN-B70087 mod--end
   ELSE  #提案編號為空或者原因碼為贈品，重新依定價編號取價 
      IF g_oea.oea03[1,4]!='MISC' THEN
         IF NOT cl_null(g_oeb5[p_ac].oeb916) THEN
            LET l_unit=g_oeb5[p_ac].oeb916
         ELSE
            LET l_unit=g_oeb5[p_ac].oeb05
         END IF
         SELECT oeb12 INTO l_oeb12 FROM oeb_file 
          WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb5[p_ac].oeb03 
         CALL s_fetch_price_new(g_oea.oea03,g_oeb5[p_ac].att00,'',l_unit,g_oeb5[p_ac].oeb15,g_oea.oea00,g_plant,    #FUN-BC0071
                                g_oea.oea23,g_oea.oea31,g_oea.oea32,g_oea.oea01,g_oeb5[p_ac].oeb03,l_oeb12, 
                                g_oeb5[p_ac].oeb1004,p_cmd) 
           # RETURNING g_oeb5[p_ac].oeb13     #FUN-AB0061  
             RETURNING g_oeb5[l_ac].oeb13,b_oeb.oeb37  #FUN-AB0061   
        #FUN-B70087 mod
        #IF g_oeb5[p_ac].oeb13 = 0 THEN CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant) END IF #FUN-9C0120
        #FUN-BC0088 ----- add start --------
        IF g_oeb5[p_ac].oeb04[1,4] = 'MISC' THEN
           CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant,'M')
        ELSE
        #FUN-BC0088 ----- add end --------
           IF g_oeb5[p_ac].oeb13 = 0 THEN
              CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant,'N')
           ELSE
              CALL s_unitprice_entry(g_oea.oea03,g_oea.oea31,g_plant,'Y')
           END IF
        END IF #FUN-BC0088 add
        #FUN-B70087 mod--end
 
         SELECT occ1027 INTO l_occ1027 FROM occ_file WHERE occ01=g_oea.oea03
         IF l_occ1027 = 'Y' THEN
            IF l_success ='N' THEN                                             
               CALL cl_err(g_oeb5[p_ac].att00,'atm-257',0)  
            END IF
         ELSE
            IF l_success ='N' THEN                                             
               CALL cl_err(g_oeb5[p_ac].att00,'atm-257',0)  
               RETURN 1                           
            END IF
         END IF 
         IF g_oea.oea213 = 'Y' THEN
            LET g_oeb5[p_ac].oeb13=g_oeb5[p_ac].oeb13*(1+g_oea.oea211/100)
         ELSE
            LET g_oeb5[p_ac].oeb13=g_oeb5[p_ac].oeb13
         END IF
      END IF
      IF g_oeb5[p_ac].oeb1012 = 'Y' AND g_aza.aza50 = 'Y' THEN 
         LET g_oeb[p_ac].oeb14=0
         LET g_oeb[p_ac].oeb14t=0
      END IF
   END IF
   RETURN 0
END FUNCTION
 
FUNCTION t410_1_bef_oeb13(p_cmd,l_qty)
   DEFINE p_cmd           LIKE type_file.chr1,
          l_qty           LIKE oeb_file.oeb12,
          l_oqt12         LIKE oqt_file.oqt12,
          l_oqv05         LIKE oqv_file.oqv05,
          l_oeb23         LIKE oeb_file.oeb23,   #訂單待出貨數量
          l_oeb24         LIKE oeb_file.oeb24,   #訂單已出貨數量
          l_oeb25         LIKE oeb_file.oeb25,   #訂單已銷退數量
          l_oeb905        LIKE oeb_file.oeb905   #取出備置數量    
 
 
   
   IF g_sma.sma115 = 'Y' THEN
      CALL t410_1_set_origin_field('b')
      IF NOT cl_null(g_oeb[l_ac].oeb12) THEN
         IF g_oeb[l_ac].oeb12 <=0 THEN #No:7948
            IF g_ima906 MATCHES '[23]' THEN
               RETURN "oeb915"
            ELSE
               RETURN "oeb912"
            END IF
         END IF
         IF g_oea.oea11='3' THEN
            IF g_oeb[l_ac].oeb12 > l_qty THEN
               IF NOT cl_confirm('axm-240') THEN
                  IF g_ima906 MATCHES '[23]' THEN
                     RETURN "oeb915"
                  ELSE
                     RETURN "oeb912"
                  END IF
               END IF
            END IF
         END IF
   
         IF g_oea.oea11='5' AND ( g_oeb[l_ac].oeb13 = 0 OR 
            g_oeb[l_ac].oeb04 != g_oeb_t.oeb04  OR
            g_oeb[l_ac].oeb12 != g_oeb_t.oeb12  OR    
            g_oeb[l_ac].oeb912!= g_oeb_t.oeb912 OR
            g_oeb[l_ac].oeb915!= g_oeb_t.oeb915 OR
            g_oeb[l_ac].oeb917!= g_oeb_t.oeb917) THEN
            SELECT oqt12 INTO l_oqt12 FROM oqt_file
             WHERE oqt01=g_oea.oea12
            IF l_oqt12='Y' THEN   #分量計價-取單價
               SELECT oqv05 INTO l_oqv05 FROM oqv_file
                WHERE oqv01=g_oea.oea12 AND
                      oqv02=g_oeb[l_ac].oeb71 AND
                      g_oeb[l_ac].oeb12 BETWEEN oqv03 AND oqv04
               IF cl_null(l_oqv05)  THEN LET l_oqv05=0  END IF
               LET g_oeb[l_ac].oeb13=l_oqv05
               LET g_oeb17 = g_oeb[l_ac].oeb13  
               DISPLAY BY NAME g_oeb[l_ac].oeb13 
            END IF
         END IF
   
         IF p_cmd='u' THEN
            #-->如果項次修正用g_oeb[l_ac].oeb03則會有問題
            SELECT oeb23,oeb24,oeb25 INTO l_oeb23,l_oeb24,l_oeb25
              FROM oeb_file
             WHERE oeb01=g_oea.oea01 AND oeb03=g_oeb_t.oeb03
            IF STATUS THEN
               CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb_t.oeb03,"axm-249","","oeb sel2:",1) 
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN "oeb915"
               ELSE
                  RETURN "oeb912"
               END IF
            END IF
            IF g_oeb[l_ac].oeb12 < l_oeb24+l_oeb23-l_oeb25 THEN
               CALL cl_err('oeb12:','axm-251',1)
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN "oeb915"
               ELSE
                  RETURN "oeb912"
               END IF
            END IF
            SELECT oeb905 INTO l_oeb905 FROM oeb_file
             WHERE oeb01 = g_oea.oea01
               AND oeb03 = g_oeb[l_ac].oeb03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("sel","oeb_file",g_oea.oea01,g_oeb[l_ac].oeb03,"axm-073","","",1)
               IF g_ima906 MATCHES '[23]' THEN
                  RETURN "oeb915"
               ELSE
                  RETURN "oeb912"
               END IF
            ELSE
               IF cl_null(l_oeb905) THEN LET l_oeb905 = 0 END IF
               IF g_oeb[l_ac].oeb12 < l_oeb905 THEN
                  CALL cl_err(g_oeb[l_ac].oeb04,'axm-072',1)
                  IF g_ima906 MATCHES '[23]' THEN
                     RETURN "oeb915"
                  ELSE
                     RETURN "oeb912"
                  END IF
               END IF
            END IF
         END IF
         IF cl_null(g_oeb[l_ac].oeb14) OR g_oeb[l_ac].oeb14 = 0 OR
            g_oeb[l_ac].oeb12 != g_oeb_t.oeb12 OR
            g_oeb[l_ac].oeb13 != g_oeb_t.oeb13 OR    
            g_oeb[l_ac].oeb917 != g_oeb_t.oeb917 THEN 
            IF g_oea.oea213 = 'N'  THEN # 不內含
               #No.用計價數量來算
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
               LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add   
            ELSE
               LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
               CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t  #CHI-7A0036-add   
               LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
               CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14    #CHI-7A0036-add
            END IF 
            DISPLAY BY NAME g_oeb[l_ac].oeb14
            DISPLAY BY NAME g_oeb[l_ac].oeb14t
         END IF
      END IF
   END IF
   RETURN NULL
END FUNCTION
 
FUNCTION t410_1_chk_oeb04_1(p_cmd)
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_check_res   LIKE type_file.num5,  
          l_b2          LIKE cob_file.cob08,  
          l_ima130      LIKE ima_file.ima130,
          l_ima131      LIKE ima_file.ima131,
          l_ima25       LIKE ima_file.ima25,
          l_imaacti     LIKE ima_file.imaacti,
          l_qty         LIKE oeb_file.oeb12,  
          l_imaag      LIKE ima_file.imaag 
 
           #AFTER FIELD 處理邏輯修改為使用下面的函數來進行判斷，請參考相關代碼
           CALL t410_1_check_oeb04('oeb04',l_ac,p_cmd) RETURNING
                 l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                ,l_qty
           IF NOT l_check_res THEN 
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                ,l_qty
           END IF       
 
           IF cl_null(g_oeb[l_ac].oeb09) THEN 
            SELECT ima35,ima36 INTO g_oeb[l_ac].oeb09,g_oeb[l_ac].oeb091 FROM ima_file
             WHERE ima01 = g_oeb[l_ac].oeb04
            IF SQLCA.SQLCODE THEN
              CALL cl_err3("sel","ima_file",g_oeb[l_ac].oeb04,"",SQLCA.SQLCODE,"","",0)  
              LET b_oeb.oeb09  = ''
              LET b_oeb.oeb091 = ''
            END IF
           END IF 
 
           SELECT imaag INTO l_imaag FROM ima_file                                                                                    
            WHERE ima01 = g_oeb[l_ac].oeb04                                                                                           
           IF NOT cl_null(l_imaag) AND l_imaag <> '@CHILD' THEN                                                                       
              LET g_oeb[l_ac].oeb06 = ''   
              LET g_oeb[l_ac].ima021 = ''                                                  
              CALL cl_err(g_oeb[l_ac].oeb04,'aim1004',0)                                                                              
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                ,l_qty
           END IF
 
            RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                ,l_qty
END FUNCTION
FUNCTION t410_1_chk_oeb13_1()
   IF NOT cl_null(g_oeb5[l_ac].oeb13) THEN
      IF g_oeb5[l_ac].oeb13 < 0 THEN
         CALL cl_err(g_oeb5[l_ac].oeb13,'aom-557',0)
         RETURN FALSE
      END IF
      CALL cl_digcut(g_oeb5[l_ac].oeb13,t_azi03)RETURNING g_oeb5[l_ac].oeb13     
      DISPLAY BY NAME g_oeb[l_ac].oeb13 
 
      IF cl_null(g_oeb[l_ac].oeb14) OR g_oeb[l_ac].oeb14 = 0 OR
          g_oeb[l_ac].oeb12 != g_oeb_t.oeb12 OR
          g_oeb5[l_ac].oeb13 != g_oeb5_t.oeb13 THEN
           IF g_oea.oea213 = 'N' # 不內含
           THEN 
              LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14  
              LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb14*(1+g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t 
           ELSE 
              LET g_oeb[l_ac].oeb14t=g_oeb[l_ac].oeb917*g_oeb[l_ac].oeb13
              CALL cl_digcut(g_oeb[l_ac].oeb14t,t_azi04) RETURNING g_oeb[l_ac].oeb14t 
              LET g_oeb[l_ac].oeb14=g_oeb[l_ac].oeb14t/(1+g_oea.oea211/100)
              CALL cl_digcut(g_oeb[l_ac].oeb14,t_azi04) RETURNING g_oeb[l_ac].oeb14  
           END IF
         DISPLAY BY NAME g_oeb[l_ac].oeb14,g_oeb[l_ac].oeb14t
      END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t410_1_chk_oeb13_2()
   DEFINE l_oeb17 LIKE oeb_file.oeb17
   DEFINE l_msg LIKE type_file.chr1000    #MOD-780014 add
   IF NOT cl_null(g_oeb[l_ac].oeb13) THEN
      #no.7150 檢查訂單單價是否低於取出單價(合約訂單不卡)
      IF g_oea.oea00 != '0' THEN
         LET l_oeb17 = g_oeb17 * (100-g_oaz.oaz185) / 100
         LET l_oeb17 = cl_digcut(l_oeb17,t_azi03)               #No.CHI-6A0004
      END IF
      IF g_oeb[l_ac].oeb13 < l_oeb17 THEN
         CASE g_oaz.oaz184
            WHEN 'R' CALL cl_err(l_oeb17,'axm-802',1)
                     LET g_oeb[l_ac].oeb13 = g_oeb_t.oeb13
                     DISPLAY BY NAME g_oeb[l_ac].oeb13
            WHEN 'W' #CALL cl_err(l_oeb17,'axm-802',1)
                     LET l_msg = cl_getmsg('axm-802',g_lang)
                     LET l_msg=l_msg CLIPPED,l_oeb17
                     CALL cl_msgany(10,20,l_msg)
            WHEN 'N' EXIT CASE
         END CASE
      END IF
   END IF
END FUNCTION
 
 
#用于att01~att10這十個輸入型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t410_1_check_oeb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t410_1_check_att0x(p_value,p_index,p_row,p_cmd)
DEFINE
  p_value      LIKE imx_file.imx01,
  p_index      LIKE type_file.num5, 
  p_row        LIKE type_file.num5,
  p_cmd        LIKE type_file.chr1, 
  li_min_num   LIKE agc_file.agc05,
  li_max_num   LIKE agc_file.agc06,
  l_index      STRING,
 
  l_check_res     LIKE type_file.num5, 
  l_b2            LIKE cob_file.cob08,
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1, 
  l_ima131        LIKE ima_file.ima131, 
  l_qty           LIKE img_file.img10, 
  l_ima25         LIKE ima_file.ima25 
  
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
 
  #這里使用到了一個用于存放當前屬性組包含的所有屬性信息的全局數組lr_agc
  #該數組會由t410_1_refresh_detail()函數在較早的時候填充
  
  #判斷長度與定義的使用位數是否相等
  IF LENGTH(p_value CLIPPED) <> lr_agc[p_index].agc03 THEN
     CALL cl_err_msg("","aim-911",lr_agc[p_index].agc03,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  #比較大小是否在合理范圍之內
  LET li_min_num = lr_agc[p_index].agc05
  LET li_max_num = lr_agc[p_index].agc06
  IF (lr_agc[p_index].agc05 IS NOT NULL) AND
     (p_value < li_min_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
  IF (lr_agc[p_index].agc06 IS NOT NULL) AND
     (p_value > li_max_num) THEN
     CALL cl_err_msg("","lib-232",lr_agc[p_index].agc05 || "|" || lr_agc[p_index].agc06,1)
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF
    RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION
 
#用于att01_c~att10_c這十個選擇型屬性欄位的AFTER FIELD事件的判斷函數
#傳入參數:p_value 要比較的欄位內容,p_index當前欄位的索引號(從1~10表示att01~att10)
#         p_row是當前行索引,傳入INPUT ARRAY中使用的l_ac即可
#與t410_1_check_oeb04相同,如果檢查過程中如果發現錯誤,則報錯并返回一個FALSE
#而AFTER FIELD的時候檢測到這個返回值則會做NEXT FIELD
FUNCTION t410_1_check_att0x_c(p_value,p_index,p_row,p_cmd)
DEFINE
  p_value  LIKE imx_file.imx01,
  p_index  LIKE type_file.num5,  
  p_row    LIKE type_file.num5, 
  p_cmd    LIKE type_file.chr1,
  l_index  STRING,
 
  l_check_res     LIKE type_file.num5,   
  l_b2            LIKE cob_file.cob08,  
  l_imaacti       LIKE ima_file.imaacti,
  l_ima130        LIKE type_file.chr1,  
  l_ima131        LIKE ima_file.ima131, 
  l_qty           LIKE img_file.img10, 
  l_ima25         LIKE ima_file.ima25
  
 
 
  #這個欄位一旦進入了就不能忽略，因為要保証在輸入其他欄位之前必須要生成oeb04料件編號
  IF cl_null(p_value) THEN 
     RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
  END IF       
  #下拉框選擇項相當簡單，不需要進行范圍和長度的判斷，因為肯定是符合要求的了  
  LET arr_detail[p_row].imx[p_index] = p_value
  LET l_index = p_index USING '&&'
  CALL t410_1_check_oeb04('imx'||l_index,p_row,p_cmd)
    RETURNING l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
             ,l_qty   
  RETURN l_check_res,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
END FUNCTION         
 
#--------------------在修改下面的代碼前請讀一下注釋先，謝了! -----------------------
 
#下面代碼是從單身INPUT ARRAY語句中的AFTER FIELD段中拷貝來的，因為在多屬性新模式下原來的oea04料件編號
#欄位是要被隱藏起來，并由新增加的imx00（母料件編號）+各個明細屬性欄位來取代，所以原來的AFTER FIELD
#代碼是不會被執行到，需要執行的判斷應該放新增加的几個欄位的AFTER FIELD中來進行，因為要用多次嘛，所以
#單獨用一個FUNCTION來放，順便把oeb04的AFTER FIELD也移過來，免得將來維護的時候遺漏了
#下標g_oeb5[l_ac]都被改成g_oeb5[p_ac]，請注意
 
#本函數返回TRUE/FALSE,表示檢核過程是否通過，一般說來，在使用過程中應該是如下方式□
#    AFTER FIELD XXX
#        IF NOT t410_1_check_oeb04(.....)  THEN NEXT FIELD XXX END IF        
FUNCTION t410_1_check_oeb04(p_field,p_ac,p_cmd)
DEFINE
  p_field                     STRING,    #當前是在哪個欄位中觸發了AFTER FIELD事件
  p_ac                        LIKE type_file.num5,   
                              
  l_ps                        LIKE sma_file.sma46,
  l_str_tok                   base.stringTokenizer,
  l_tmp, ls_sql               STRING,
  l_param_list                STRING,
  l_cnt, li_i                 LIKE type_file.num5,  
  ls_value                    STRING,
  ls_pid,ls_value_fld         LIKE ima_file.ima01,
  ls_name, ls_spec            STRING, 
  lc_agb03                    LIKE agb_file.agb03,
  lc_agd03                    LIKE agd_file.agd03,
  ls_pname                    LIKE ima_file.ima02,
  l_misc                      LIKE type_file.chr4, 
  l_n                         LIKE type_file.num5, 
  l_b2                        LIKE ima_file.ima31,
  l_ima130                    LIKE ima_file.ima130,
  l_ima131                    LIKE ima_file.ima131,
  l_ima25                     LIKE ima_file.ima25,
  l_imaacti                   LIKE ima_file.imaacti,
  l_qty                       LIKE type_file.num10,  
  p_cmd                       LIKE type_file.chr1,  
  l_ima135                    LIKE ima_file.ima135,
  l_ima1002                   LIKE ima_file.ima1002,
  l_ima35                     LIKE ima_file.ima35,
  l_ima36                     LIKE ima_file.ima36,
  l_tuo03                     LIKE tuo_file.tuo03,  
  l_tuo031                    LIKE tuo_file.tuo031,
  l_occ1028                   LIKE occ_file.occ1028,
  l_ima1010                   LIKE ima_file.ima1010,
  l_sum1                      LIKE oeb_file.oeb12,
  l_sum2                      LIKE oeb_file.oeb12,
  l_sum3                      LIKE oeb_file.oeb12,
  l_sum4                      LIKE oeb_file.oeb12,
  l_fac                       LIKE oeb_file.oeb05_fac,
  l_max                       LIKE tqw_file.tqw07,
  l_check_r                   LIKE type_file.chr1 
 
  
        #首先判斷需要的欄位是否全部完成了輸入（只有母料件編號+被顯示出來的所有明細屬性
        #全部被輸入完成了才進行后續的操作
        LET ls_pid = g_oeb5[p_ac].att00   # ls_pid 父料件編號
        LET ls_value = g_oeb5[p_ac].att00   # ls_value 子料件編號
        IF cl_null(ls_pid) THEN 
           RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                 ,l_qty  
        END IF  #注意這里沒有錯，所以返回TRUE
        
        #取出當前母料件包含的明細屬性的個數
        SELECT COUNT(*) INTO l_cnt FROM agb_file WHERE agb01 =
         (SELECT imaag FROM ima_file WHERE ima01 = ls_pid)
        IF l_cnt = 0 THEN
            RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti 
                  ,l_qty  
        END IF
        
        FOR li_i = 1 TO l_cnt
            #如果有任何一個明細屬性應該輸而沒有輸的則退出
            IF cl_null(arr_detail[p_ac].imx[li_i]) THEN 
               RETURN TRUE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                     ,l_qty  
            END IF  
        END FOR
   
        #得到系統定義的標准分隔符sma46
        SELECT sma46 INTO l_ps FROM sma_file    
        IF cl_null(l_ps) THEN     #防止出現l_ps為空的情況顯示的時候無法解析
           LET l_ps = ' '
        END IF 
        
        #合成子料件的名稱
        SELECT ima02 INTO ls_pname FROM ima_file   # ls_name 父料件名稱
          WHERE ima01 = ls_pid
        LET ls_spec = ls_pname  # ls_spec 子料件名稱
        #方法□循環在agd_file中找有沒有對應記錄，如果有，就用該記錄的名稱來
        #替換初始名稱，如果找不到則就用原來的名稱
        FOR li_i = 1 TO l_cnt  
            LET lc_agd03 = ""
            LET ls_value = ls_value.trim(), l_ps, arr_detail[p_ac].imx[li_i]
            SELECT agd03 INTO lc_agd03 FROM agd_file
             WHERE agd01 = lr_agc[li_i].agc01 AND agd02 = arr_detail[p_ac].imx[li_i]
            IF cl_null(lc_agd03) THEN
               LET ls_spec = ls_spec.trim(),l_ps,arr_detail[p_ac].imx[li_i]
            ELSE
               LET ls_spec = ls_spec.trim(),l_ps,lc_agd03
            END IF
        END FOR     
        
        #解析ls_value生成要傳給cl_copy_bom的那個l_param_list
        LET l_str_tok = base.StringTokenizer.create(ls_value,l_ps)
        LET l_tmp = l_str_tok.nextToken()   #先把第一個部分--名稱去掉
   
        LET ls_sql = "SELECT agb03 FROM agb_file,ima_file WHERE ",
                     "ima01 = '",ls_pid CLIPPED,"' AND agb01 = imaag ",
                     "ORDER BY agb02"  
        DECLARE param_curs11 CURSOR FROM ls_sql
        FOREACH param_curs11 INTO lc_agb03
          #l_str_tok中的Tokens數量應該和param_curs中的記錄數量完全一致
          IF cl_null(l_param_list) THEN
             LET l_param_list = '#',lc_agb03,'#|',l_str_tok.nextToken()
          ELSE
             LET l_param_list = l_param_list,'|#',lc_agb03,'#|',l_str_tok.nextToken()
          END IF
        END FOREACH     
        
        LET g_value = ls_value
        LET g_chr2  = '1'
    
        IF g_sma.sma908 <> 'Y' THEN
           SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01=g_value                 
           IF l_n=0 THEN                                                              
              CALL cl_err(g_value,'ams-003',1)                                      
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty
           END IF 
        END IF
 
        #調用cl_copy_ima將新生成的子料件插入到數據庫中
        IF cl_copy_ima(ls_pid,ls_value,ls_spec,l_param_list) = TRUE THEN
           #如果向其中成功插入記錄則同步插入屬性記錄到imx_file中去
           LET ls_value_fld = ls_value 
           INSERT INTO imx_file VALUES(ls_value_fld,ls_pid,arr_detail[p_ac].imx[1],
             arr_detail[p_ac].imx[2],arr_detail[p_ac].imx[3],arr_detail[p_ac].imx[4],
             arr_detail[p_ac].imx[5],arr_detail[p_ac].imx[6],arr_detail[p_ac].imx[7],
             arr_detail[p_ac].imx[8],arr_detail[p_ac].imx[9],arr_detail[p_ac].imx[10])
           #如果向imx_file中插入記錄失敗則也應將ima_file中已經建立的紀錄刪除以保証兩邊
           #記錄的完全同步
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","imx_file",ls_value_fld,"",SQLCA.sqlcode,"","Failure to insert imx_file , rollback insert to ima_file !",1) 
              DELETE FROM ima_file WHERE ima01 = ls_value_fld
              RETURN FALSE,g_buf,g_buf1,l_b2,l_ima130,l_ima131,g_buf2,l_ima25,l_imaacti
                    ,l_qty   
           END IF
        END IF 
        #把生成的子料件賦給oeb04，否則下面的檢查就沒有意義了
        LET g_oeb5[p_ac].att00 = ls_value
  
 
END FUNCTION
 
 
 
FUNCTION t410_1_b_fill(p_wc)               #BODY FILL UP
 
   DEFINE p_wc         STRING #No.FUN-680135 VARCHAR(300)
   DEFINE ls_show      STRING
 
 
    LET g_sql = "SELECT '','','','','','','','','','','','','','','','',oeb03,oeb04,oeb05,oeb916,oeb15,oeb1002,oeb1004,oeb13,oeb1001,oeb1012,'' ",
                 " FROM oeb_file ",
                " WHERE oeb01 = '",g_argv1 CLIPPED,"' ",
                "   AND oeb933 = '",g_oeb933,"'",
                "   AND oeb934 = '",g_oeb934,"'" 
 
    IF cl_null(g_oeb931) THEN
      LET g_sql = g_sql CLIPPED," AND 1=1"," AND ",p_wc CLIPPED," ORDER BY oeb03"
    ELSE
      LET g_sql = g_sql," AND oeb931 = '",g_oeb931,"'"," AND ",p_wc CLIPPED," ORDER BY oeb03"
    END IF
    PREPARE t410_1_prepare2 FROM g_sql           #預備一下
    DECLARE oeb_curs CURSOR FOR t410_1_prepare2
 
    CALL g_oeb5.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
 
    FOREACH oeb_curs INTO g_oeb5[g_cnt].*       #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       ELSE
          SELECT oebislk01 INTO g_oeb5[g_cnt].oebislk01 FROM oebi_file
           WHERE oebi01 = g_argv1
             AND oebi03 = g_oeb5[g_cnt].oeb03
 
       END IF
     
       CALL t410_1_decode0(g_cnt)
 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err('',9035,0)
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_oeb5.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
    CALL t410_1_refresh_detail()
     RETURNING g_show
    IF g_rec_b >0 THEN
      CALL t410_1_decode1()
    END IF
    DISPLAY g_rec_b TO FORMONLY.cn2
    
END FUNCTION
 
 
FUNCTION t410_1_decode1()
DEFINE i,j,k,m,n,l_n  LIKE type_file.num5
DEFINE l_sql          STRING
 
    SELECT COUNT(*) INTO l_n FROM oeb_file
     WHERE oeb01 = g_oea.oea01
       AND oeb933 = g_oeb933
       AND oeb934 = g_oeb934
    FOR i = 1 TO l_n
       IF cl_null(g_oeb5[i].att02) THEN
         LET g_oeb5[i].att02 = 'def' 
       END IF
       IF cl_null(g_oeb5[i].att02_c) THEN
          LET g_oeb5[i].att02_c = 'def' 
       END IF
       IF cl_null(g_oeb5[i].att03) THEN
          LET g_oeb5[i].att03 = 'def' 
       END IF
       IF cl_null(g_oeb5[i].att03_c) THEN
          LET g_oeb5[i].att03_c = 'def' 
       END IF
       IF cl_null(g_oeb5[i].oeb15) THEN
          LET g_oeb5[i].oeb15 = ' ' 
       END IF
       IF cl_null(g_oeb5[i].oeb1001) THEN
          LET g_oeb5[i].oeb1001 = ' ' 
       END IF
       IF cl_null(g_oeb5[i].oebislk01) THEN
          LET g_oeb5[i].oebislk01  = ' '
       END IF
    END FOR 
  
       FOR m = 1 TO l_n
          FOR n = 1 TO l_n
             IF g_oeb5[m].att00 = g_oeb5[n].att00 
                AND g_oeb5[m].att02 = g_oeb5[n].att02
                AND g_oeb5[m].att03 = g_oeb5[n].att03
                AND g_oeb5[m].att02_c = g_oeb5[n].att02_c
                AND g_oeb5[m].att03_c = g_oeb5[n].att03_c
                AND g_oeb5[m].oeb15 = g_oeb5[n].oeb15
                AND g_oeb5[m].oeb1001 = g_oeb5[n].oeb1001
                AND g_oeb5[m].oebislk01 = g_oeb5[n].oebislk01 THEN
                
                IF NOT cl_null(g_oeb5[n].att04) THEN
                   LET g_oeb5[m].att04 = g_oeb5[n].att04
                END IF
                IF NOT cl_null(g_oeb5[n].att05) THEN
                   LET g_oeb5[m].att05 = g_oeb5[n].att05
                END IF
                IF NOT cl_null(g_oeb5[n].att06) THEN
                   LET g_oeb5[m].att06 = g_oeb5[n].att06
                END IF
                IF NOT cl_null(g_oeb5[n].att07) THEN
                   LET g_oeb5[m].att07 = g_oeb5[n].att07
                END IF
                IF NOT cl_null(g_oeb5[n].att08) THEN
                   LET g_oeb5[m].att08 = g_oeb5[n].att08
                END IF
                IF NOT cl_null(g_oeb5[n].att09) THEN
                   LET g_oeb5[m].att09 = g_oeb5[n].att09
                END IF
                IF NOT cl_null(g_oeb5[n].att10) THEN
                   LET g_oeb5[m].att10 = g_oeb5[n].att10
                END IF
                IF NOT cl_null(g_oeb5[n].att11) THEN
                   LET g_oeb5[m].att11 = g_oeb5[n].att11
                END IF
                IF NOT cl_null(g_oeb5[n].att12) THEN
                   LET g_oeb5[m].att12 = g_oeb5[n].att12
                END IF
                IF NOT cl_null(g_oeb5[n].att13) THEN
                   LET g_oeb5[m].att13 = g_oeb5[n].att13
                END IF
 
             END IF
          END FOR
       END FOR
   
    FOR i = 1 TO l_n
       IF g_oeb5[i].att02='def' THEN
         LET g_oeb5[i].att02 = '' 
       END IF
       IF g_oeb5[i].att02_c='def' THEN
          LET g_oeb5[i].att02_c = '' 
       END IF
       IF g_oeb5[i].att03='def' THEN
         LET g_oeb5[i].att03 = '' 
       END IF
       IF g_oeb5[i].att03_c='def' THEN
          LET g_oeb5[i].att03_c = '' 
       END IF
       IF g_oeb5[i].oeb15=' ' THEN
         LET g_oeb5[i].oeb15 = '' 
       END IF
       IF g_oeb5[i].oeb1001=' ' THEN
          LET g_oeb5[i].oeb1001 = '' 
       END IF
       IF g_oeb5[i].oebislk01=' ' THEN
          LET g_oeb5[i].oebislk01 = '' 
       END IF
    END FOR 
  
    DROP TABLE t410_1_tempb
    CREATE TEMP TABLE t410_1_tempb(
                                   att00     LIKE ima_file.ima01,
                                   att01     LIKE ima_file.ima02,
                                   att02     LIKE agd_file.agd02,
                                   att02_c   LIKE agd_file.agd02,
                                   att03     LIKE agd_file.agd02,
                                   att03_c   LIKE agd_file.agd02,
                                   att04     LIKE obj_file.obj06,
                                   att05     LIKE obj_file.obj06,
                                   att06     LIKE obj_file.obj06,
                                   att07     LIKE obj_file.obj06,
                                   att08     LIKE obj_file.obj06,
                                   att09     LIKE obj_file.obj06,
                                   att10     LIKE obj_file.obj06,
                                   att11     LIKE obj_file.obj06,
                                   att12     LIKE obj_file.obj06,
                                   att13     LIKE obj_file.obj06,
                                   oeb03     LIKE oeb_file.oeb03,
                                   oeb04     LIKE oeb_file.oeb04,
                                   oeb05     LIKE oeb_file.oeb05,
                                   oeb916    LIKE oeb_file.oeb916,
                                   oeb15     LIKE oeb_file.oeb15,
                                   oeb1002   LIKE oeb_file.oeb1002,
                                   oeb1004   LIKE oeb_file.oeb1004,
                                   oeb13     LIKE oeb_file.oeb13,
                                   oeb1001   LIKE oeb_file.oeb1001,
                                   oeb1012   LIKE oeb_file.oeb1012,
                                   oebislk01 LIKE oebi_file.oebislk01);
     FOR i = 1 TO l_n
         INSERT INTO t410_1_tempb VALUES(g_oeb5[i].*)
     END FOR
     
       LET l_sql = "SELECT DISTINCT att00,att01,att02,att02_c,att03,",
                   "                att03_c,att04,att05,att06,att07,",
                   "                att08,att09,att10,att11,att12,att13,",
                   "                '','',oeb05,oeb916,oeb15,",
                   "                oeb1002,oeb1004,oeb13,oeb1001,oeb1012,oebislk01",
                   "  FROM t410_1_tempb",
                   "  ORDER BY att00,att02,att02_c,att03,att03_c" 
       PREPARE t410_1_temp FROM l_sql
       DECLARE temp_cs CURSOR FOR t410_1_temp
 
       LET g_cnt = 1
       CALL g_oeb5.clear()
       FOREACH temp_cs INTO g_oeb5[g_cnt].*    #二維單身填充
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
    
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
       END FOREACH
       
       CALL g_oeb5.deleteElement(g_cnt)
       LET g_rec_b = g_cnt - 1
 
  
END FUNCTION
 
#此函數用來檢查款式編號和屬性是否重復
FUNCTION t410_1_check()
  DEFINE i            LIKE type_file.num5
  DEFINE k            LIKE type_file.num5
 
  LET g_success = 'Y'
  IF g_oeb5.getlength() = 1 THEN
     RETURN g_success
  END IF
  IF NOT cl_null(g_oeb931) THEN
     RETURN g_success
  END IF 
  LET g_rec_b = g_rec_b + 1
 
       FOR k = 1 TO g_rec_b                    #空值不能比較，所以先賦值
           IF cl_null(g_oeb5[k].att02) THEN
              LET g_oeb5[k].att02 = ' '
           END IF
           IF cl_null(g_oeb5[k].att03) THEN
              LET g_oeb5[k].att03 = ' '
           END IF
           IF cl_null(g_oeb5[k].att02_c) THEN
              LET g_oeb5[k].att02_c = ' '
           END IF
           IF cl_null(g_oeb5[k].att03_c) THEN
              LET g_oeb5[k].att03_c = ' '
           END IF
           IF cl_null(g_oeb5[k].oeb15) THEN
              LET g_oeb5[k].oeb15 = ' '
           END IF
           IF cl_null(g_oeb5[k].oeb1001) THEN
              LET g_oeb5[k].oeb1001 = ' '
           END IF
       END FOR
 
       LET g_rec_b = g_rec_b - 1
       FOR i = 1 TO g_rec_b
          IF NOT cl_null(g_oeb5[i].oeb13) THEN 
             IF g_oeb5[l_ac].att00 = g_oeb5[i].att00 
                AND g_oeb5[l_ac].att02 = g_oeb5[i].att02
                AND g_oeb5[l_ac].att03 = g_oeb5[i].att03
                AND g_oeb5[l_ac].att02_c = g_oeb5[i].att02_c
                AND g_oeb5[l_ac].att03_c = g_oeb5[i].att03_c 
                AND g_oeb5[l_ac].oeb15 = g_oeb5[i].oeb15
                AND g_oeb5[l_ac].oeb1001 = g_oeb5[i].oeb1001 THEN
 
                LET g_success = 'N'
             END IF
          END IF
       END FOR
 
       LET g_rec_b = g_rec_b + 1
       FOR k = 1 TO g_rec_b
           IF g_oeb5[k].att02=' ' THEN
              LET g_oeb5[k].att02 = ''
           END IF
           IF g_oeb5[k].att03=' ' THEN
              LET g_oeb5[k].att03 = ''
           END IF
           IF g_oeb5[k].att02_c=' ' THEN
              LET g_oeb5[k].att02_c = ''
           END IF
           IF g_oeb5[k].att03_c=' ' THEN
              LET g_oeb5[k].att03_c = ''
           END IF
           IF g_oeb5[k].oeb15=' ' THEN
              LET g_oeb5[k].oeb15 = ''
           END IF
           IF g_oeb5[k].oeb1001=' ' THEN
              LET g_oeb5[k].oeb1001 = ''
           END IF
       END FOR
 
  LET g_rec_b = g_rec_b - 1
  RETURN g_success
 
END FUNCTION
 
#若包裝方式編號不為空，則約定交貨日和理由碼必須一致
FUNCTION t410_1_check2()
  DEFINE i            LIKE type_file.num5
  DEFINE k            LIKE type_file.num5
 
  LET g_success = 'Y'
  IF g_oeb5.getlength() = 1 THEN
     RETURN g_success
  END IF
  IF NOT cl_null(g_oeb931) THEN
     LET g_rec_b = g_rec_b + 1
 
       LET g_rec_b = g_rec_b - 1
       FOR i = 1 TO g_rec_b
           IF g_oeb5[l_ac].oeb15 <> g_oeb5[i].oeb15 THEN
              LET g_success = 'X'
           END IF
           IF g_oeb5[l_ac].oeb1001 <> g_oeb5[i].oeb1001 THEN
              LET g_success = 'N'
           END IF
       END FOR
 
       LET g_rec_b = g_rec_b + 1
 
     LET g_rec_b = g_rec_b - 1
  END IF 
  RETURN g_success
 
END FUNCTION
 
FUNCTION t410_1_decode0(p_n)
  DEFINE p_n          LIKE type_file.num5
  DEFINE l_ps         LIKE sma_file.sma46
  DEFINE l_tok        base.stringTokenizer
  DEFINE field_array  DYNAMIC ARRAY OF LIKE type_file.chr1000
  DEFINE i,k          LIKE type_file.num5
  DEFINE ls_show      STRING
  DEFINE #l_sql        LIKE type_file.chr1000
         l_sql        STRING     #NO.FUN-910082
  DEFINE l_ocq        DYNAMIC ARRAY OF RECORD LIKE ocq_file.*
  DEFINE l_m          LIKE type_file.num5
  DEFINE l_index      LIKE type_file.num5
  DEFINE l_string     STRING
  DEFINE l_n          LIKE type_file.num5     #屬性的個數
  DEFINE l_i          LIKE type_file.num5     #末維屬性在第幾個
  DEFINE l_max        LIKE type_file.num5     #最后一個屬性項次
  DEFINE l_min        LIKE type_file.num5     #第一個屬性項次
  DEFINE l_obj06      LIKE obj_file.obj06
  DEFINE l_substr     STRING                  #FUN-C90047 add
  DEFINE l_agb02      LIKE agb_file.agb02     #FUN-C90047 add
  DEFINE l_imx01      LIKE imx_file.imx01     #FUN-C90047 add
  DEFINE l_imx02      LIKE imx_file.imx02     #FUN-C90047 add
  DEFINE l_imx03      LIKE imx_file.imx03     #FUN-C90047 add
  DEFINE l_imx04      LIKE imx_file.imx04     #FUN-C90047 add
  DEFINE l_imx05      LIKE imx_file.imx05     #FUN-C90047 add
  DEFINE l_imx06      LIKE imx_file.imx06     #FUN-C90047 add
  DEFINE l_imx07      LIKE imx_file.imx07     #FUN-C90047 add
  DEFINE l_imx08      LIKE imx_file.imx08     #FUN-C90047 add
  DEFINE l_imx09      LIKE imx_file.imx09     #FUN-C90047 add
  DEFINE l_imx10      LIKE imx_file.imx10     #FUN-C90047 add
 
    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps = ' '
    END IF
 
    SELECT COUNT(*) INTO l_n FROM agb_file WHERE agb01 = g_oeb933
    SELECT MAX(agb02) INTO l_max FROM agb_file WHERE agb01 = g_oeb934
    SELECT MIN(agb02) INTO l_min FROM agb_file WHERE agb01 = g_oeb934
    SELECT DISTINCT agb02 INTO l_i FROM ocq_file,agb_file
     WHERE ocq01 = g_oeb933
       AND ocq03 = agb03
 
    IF l_max = l_min THEN
       LET l_max = 4000
    END IF
 
     SELECT oeb12 INTO l_obj06 FROM oeb_file
      WHERE oeb01 = g_argv1
        AND oeb03 = g_oeb5[p_n].oeb03
     IF cl_null(l_obj06) THEN
       LET l_obj06 = 0
     END IF
 
    IF NOT cl_null(g_oeb934) THEN
       LET l_tok = base.StringTokenizer.createExt(g_oeb5[p_n].oeb04,l_ps,'',TRUE)
           IF l_tok.countTokens() > 0 THEN
              LET k=0
              WHILE l_tok.hasMoreTokens()
                    LET k=k+1
                    LET field_array[k] = l_tok.nextToken()
              END WHILE
           END IF
 
       CALL t410_1_refresh_detail() RETURNING ls_show
       LET ls_show = ls_show||','
 
       LET g_oeb5[p_n].att00 = field_array[1]
       SELECT ima02 INTO g_oeb5[p_n].att01
         FROM ima_file
        WHERE ima01 = g_oeb5[p_n].att00
 
       IF l_i = l_max THEN        #最后一個屬性為末維屬性
          LET i = 2
   
          IF ls_show.getIndexOf("att02,",1) THEN
             LET g_oeb5[p_n].att02 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att02_c,",1) THEN
             LET g_oeb5[p_n].att02_c = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03,",1) THEN
             LET g_oeb5[p_n].att03 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03_c,",1) THEN
             LET g_oeb5[p_n].att03_c = field_array[i]
             LET i = i + 1
          END IF
      
          CALL arr_show.clear() 
          LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_oeb933,"'"
          PREPARE t410_ocq1 FROM l_sql
          DECLARE ocq_curs2 CURSOR FOR t410_ocq1
             LET l_m = 1
          FOREACH ocq_curs2 INTO l_ocq[l_m].*
#FUN-C90047 modify--begin----------
             SELECT agb02 INTO l_agb02 FROM agb_file,aga_file 
               WHERE aga01=agb01
                 AND aga01=g_oeb934
                 AND agb03=l_ocq[l_m].ocq03
             SELECT imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10
               INTO l_imx01,l_imx02,l_imx03,l_imx04,l_imx05,l_imx06,l_imx07,l_imx08,l_imx09,l_imx10
               FROM imx_file
              WHERE imx000=g_oeb5[p_n].oeb04
                AND imx00=g_oeb5[p_n].att00
             CASE l_agb02
                WHEN 1
                  LET l_substr=l_imx01
                WHEN 2
                  LET l_substr=l_imx02
                WHEN 3
                  LET l_substr=l_imx03
                WHEN 4
                  LET l_substr=l_imx04
                WHEN 5
                  LET l_substr=l_imx05
                WHEN 6
                  LET l_substr=l_imx06
                WHEN 7
                  LET l_substr=l_imx07
                WHEN 8
                  LET l_substr=l_imx08
                WHEN 9
                  LET l_substr=l_imx09
                WHEN 10
                  LET l_substr=l_imx10
             END CASE
             IF l_substr.equals(l_ocq[l_m].ocq04) THEN
#FUN-C90047 add--end---------
#             LET l_string = g_oeb5[p_n].oeb04                      #FUN-C90047 mark
#             LET l_ocq[l_m].ocq04 = l_ps CLIPPED,l_ocq[l_m].ocq04  #FUN-C90047 mark
#             IF l_string.getIndexOf(l_ocq[l_m].ocq04,1) THEN       #FUN-C90047 mark
                LET l_index = l_m + 3
                LET arr_show[p_n].att[l_index] = l_obj06
             END IF 
             LET l_m = l_m + 1
       
          END FOREACH 
          LET g_oeb5[p_n].att04 = arr_show[p_n].att[4] 
          LET g_oeb5[p_n].att05 = arr_show[p_n].att[5] 
          LET g_oeb5[p_n].att06 = arr_show[p_n].att[6]
          LET g_oeb5[p_n].att07 = arr_show[p_n].att[7]
          LET g_oeb5[p_n].att08 = arr_show[p_n].att[8]
          LET g_oeb5[p_n].att09 = arr_show[p_n].att[9]
          LET g_oeb5[p_n].att10 = arr_show[p_n].att[10]
          LET g_oeb5[p_n].att11 = arr_show[p_n].att[11]
          LET g_oeb5[p_n].att12 = arr_show[p_n].att[12]
          LET g_oeb5[p_n].att13 = arr_show[p_n].att[13]
       END IF
 
       IF l_i = l_min THEN            #第一個屬性為末維屬性
          LET i = 3
   
          IF ls_show.getIndexOf("att02,",1) THEN
             LET g_oeb5[p_n].att02 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att02_c,",1) THEN
             LET g_oeb5[p_n].att02_c = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03,",1) THEN
             LET g_oeb5[p_n].att03 = field_array[i]
             LET i = i + 1
          END IF
          IF ls_show.getIndexOf("att03_c,",1) THEN
             LET g_oeb5[p_n].att03_c = field_array[i]
             LET i = i + 1
          END IF
      
          CALL arr_show.clear() 
          LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_oeb933,"'"
          PREPARE t410_ocq2 FROM l_sql
          DECLARE ocq_curs3 CURSOR FOR t410_ocq2
             LET l_m = 1
          FOREACH ocq_curs3 INTO l_ocq[l_m].*
#FUN-C90047----add----begin----
             SELECT agb02 INTO l_agb02 FROM agb_file,aga_file
               WHERE aga01=agb01
                 AND aga01=g_oeb934
                 AND agb03=l_ocq[l_m].ocq03
             SELECT imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10
               INTO l_imx01,l_imx02,l_imx03,l_imx04,l_imx05,l_imx06,l_imx07,l_imx08,l_imx09,l_imx10
               FROM imx_file
              WHERE imx000=g_oeb5[p_n].oeb04
                AND imx00=g_oeb5[p_n].att00
             CASE l_agb02
                WHEN 1
                  LET l_substr=l_imx01
                WHEN 2
                  LET l_substr=l_imx02
                WHEN 3
                  LET l_substr=l_imx03
                WHEN 4
                  LET l_substr=l_imx04
                WHEN 5
                  LET l_substr=l_imx05
                WHEN 6
                  LET l_substr=l_imx06
                WHEN 7
                  LET l_substr=l_imx07
                WHEN 8
                  LET l_substr=l_imx08
                WHEN 9
                  LET l_substr=l_imx09
                WHEN 10
                  LET l_substr=l_imx10
             END CASE
             IF l_substr.equals(l_ocq[l_m].ocq04) THEN
#FUN-C90047----add----end----
#             LET l_string = g_oeb5[p_n].oeb04                 #FUN-C90047 mark
#             IF l_string.getIndexOf(l_ocq[l_m].ocq04,1) THEN  #FUN-C90047 mark
                LET l_index = l_m + 3
                LET arr_show[p_n].att[l_index] = l_obj06
             END IF 
             LET l_m = l_m + 1
       
          END FOREACH 
          LET g_oeb5[p_n].att04 = arr_show[p_n].att[4] 
          LET g_oeb5[p_n].att05 = arr_show[p_n].att[5] 
          LET g_oeb5[p_n].att06 = arr_show[p_n].att[6]
          LET g_oeb5[p_n].att07 = arr_show[p_n].att[7]
          LET g_oeb5[p_n].att08 = arr_show[p_n].att[8]
          LET g_oeb5[p_n].att09 = arr_show[p_n].att[9]
          LET g_oeb5[p_n].att10 = arr_show[p_n].att[10]
          LET g_oeb5[p_n].att11 = arr_show[p_n].att[11]
          LET g_oeb5[p_n].att12 = arr_show[p_n].att[12]
          LET g_oeb5[p_n].att13 = arr_show[p_n].att[13]
       END IF
 
       IF l_i < l_max AND l_i > l_min THEN   #第二個屬性是末維屬性
 
          LET i = 2
          IF ls_show.getIndexOf("att02,",1) THEN
             LET g_oeb5[p_n].att02 = field_array[i]
          END IF
          IF ls_show.getIndexOf("att02_c,",1) THEN
             LET g_oeb5[p_n].att02_c = field_array[i]
          END IF
          LET i = 4
          IF ls_show.getIndexOf("att03,",1) THEN
             LET g_oeb5[p_n].att03 = field_array[i]
          END IF
          IF ls_show.getIndexOf("att03_c,",1) THEN
             LET g_oeb5[p_n].att03_c = field_array[i]
          END IF
      
          CALL arr_show.clear() 
          LET l_sql = "SELECT * FROM ocq_file WHERE ocq01 = '",g_oeb933,"'"
          PREPARE t410_ocq3 FROM l_sql
          DECLARE ocq_curs4 CURSOR FOR t410_ocq3
             LET l_m = 1
          FOREACH ocq_curs4 INTO l_ocq[l_m].*
#FUN-C90047----add----begin----
             SELECT agb02 INTO l_agb02 FROM agb_file,aga_file
               WHERE aga01=agb01
                 AND aga01=g_oeb934
                 AND agb03=l_ocq[l_m].ocq03
             SELECT imx01,imx02,imx03,imx04,imx05,imx06,imx07,imx08,imx09,imx10
               INTO l_imx01,l_imx02,l_imx03,l_imx04,l_imx05,l_imx06,l_imx07,l_imx08,l_imx09,l_imx10
               FROM imx_file
              WHERE imx000=g_oeb5[p_n].oeb04
                AND imx00=g_oeb5[p_n].att00
             CASE l_agb02
                WHEN 1
                  LET l_substr=l_imx01
                WHEN 2
                  LET l_substr=l_imx02
                WHEN 3
                  LET l_substr=l_imx03
                WHEN 4
                  LET l_substr=l_imx04
                WHEN 5
                  LET l_substr=l_imx05
                WHEN 6
                  LET l_substr=l_imx06
                WHEN 7
                  LET l_substr=l_imx07
                WHEN 8
                  LET l_substr=l_imx08
                WHEN 9
                  LET l_substr=l_imx09
                WHEN 10
                  LET l_substr=l_imx10
             END CASE
             IF l_substr.equals(l_ocq[l_m].ocq04) THEN
#FUN-C90047----add----end----
#             LET l_string = g_oeb5[p_n].oeb04                                          #FUN-C90047 mark
#             LET l_ocq[l_m].ocq04 = l_ps CLIPPED,l_ocq[l_m].ocq04 CLIPPED,l_ps CLIPPED #FUN-C90047 mark
#             IF l_string.getIndexOf(l_ocq[l_m].ocq04,1) THEN                           #FUN-C90047 mark
                LET l_index = l_m + 3
                LET arr_show[p_n].att[l_index] = l_obj06
             END IF 
             LET l_m = l_m + 1
       
          END FOREACH 
          LET g_oeb5[p_n].att04 = arr_show[p_n].att[4] 
          LET g_oeb5[p_n].att05 = arr_show[p_n].att[5] 
          LET g_oeb5[p_n].att06 = arr_show[p_n].att[6]
          LET g_oeb5[p_n].att07 = arr_show[p_n].att[7]
          LET g_oeb5[p_n].att08 = arr_show[p_n].att[8]
          LET g_oeb5[p_n].att09 = arr_show[p_n].att[9]
          LET g_oeb5[p_n].att10 = arr_show[p_n].att[10]
          LET g_oeb5[p_n].att11 = arr_show[p_n].att[11]
          LET g_oeb5[p_n].att12 = arr_show[p_n].att[12]
          LET g_oeb5[p_n].att13 = arr_show[p_n].att[13]
       END IF
 
    END IF
 
END FUNCTION
 
FUNCTION t410_1_refresh_detail()
  DEFINE l_compare          LIKE oay_file.oay22    
  DEFINE li_col_count       LIKE type_file.num5    
  DEFINE li_i, li_j,l_i     LIKE type_file.num5   
  DEFINE l_n                LIKE type_file.num5   
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lr_ocq             RECORD LIKE ocq_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
  DEFINE l_bz               LIKE type_file.chr1
 
  LET l_bz = '0'
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_oay22來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT ze03 INTO l_gae04 FROM ze_file WHERE ze01 = 'axm-946' AND ze02 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     SELECT ze03 INTO l_gae04 FROM ze_file WHERE ze01 = 'axm-947' AND ze02 = g_lang
     CALL cl_set_comp_att_text("att01",l_gae04)
 
  IF NOT cl_null(g_oeb934) THEN
     SELECT COUNT(*) INTO li_col_count FROM agb_file 
      WHERE agb01 = g_oeb934
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     LET ls_show = "att00,att01"
     LET ls_hide = "att01"
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = g_oeb934 AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
#No.FUN-870117---Begin  #增加一個判斷，看該屬性是否分拆成末維屬性
         SELECT COUNT(*) INTO l_n FROM ocq_file 
          WHERE ocq01 = g_oeb933
            AND ocq03 = lr_agc[li_i].agc01 
         IF l_n > 0 THEN
            LET l_bz = '1'
            CONTINUE FOR
         END IF
         IF l_bz = '1' THEN 
            LET lc_index = li_i USING '&&'
         ELSE
            LET lc_index = li_i+1 USING '&&'
         END IF
         
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
    
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att02,att02_c'
    LET ls_show = 'att00,att01'
  END IF
  
  LET ls_sql = "SELECT * FROM ocq_file ",
               " WHERE ocq01 = '",g_oeb933,"'" 
  PREPARE ocq_pre FROM ls_sql
  DECLARE ocq_curs CURSOR FOR ocq_pre
  LET l_i = 0
  LET ls_combo_vals = ""
  LET ls_combo_txts = ""
  FOREACH ocq_curs INTO lr_ocq.*
    IF STATUS THEN
      CALL cl_err('',STATUS,0)
      EXIT FOREACH
    END IF
    LET l_i = l_i +1
    LET lc_index = l_i+3 USING '&&'
    LET ls_show = ls_show || ",att" || lc_index
    CALL cl_set_comp_att_text("att" || lc_index,lr_ocq.ocq05)    
  END FOREACH
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  IF l_i = 0 THEN
  FOR li_j = li_i+2 TO 13
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index 
  END FOR
  ELSE
  FOR li_j = l_i + 4 TO 13
    LET lc_index = li_j USING '&&'
    LET ls_hide = ls_hide || ",att" || lc_index
  END FOR 
  END IF
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible("att02,att02_c,att03,att03_c", FALSE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
  CALL cl_set_comp_visible(ls_show, TRUE)
 
  RETURN ls_show
END FUNCTION
 
FUNCTION t410_1_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   CALL cl_set_comp_visible("oeb03,oeb04",FALSE)
   IF NOT cl_null(g_oeb933) AND NOT cl_null(g_oeb931) THEN
     CALL cl_set_comp_entry("att00,att01,att02,att02_c,att03,att03_c,att04,att05,att06,att07,att08,att09,att10,att11,att12,att13,oeb05",FALSE)
   END IF
   IF g_sma.sma116  = '0' THEN
     CALL cl_set_comp_visible("oeb916",FALSE)
   END IF
   IF g_aza.aza50 != 'Y' THEN
      CALL cl_set_comp_visible("oeb1002,oeb1004,oeb1001,oeb1012",FALSE)
   END IF
   IF g_sma.sma124 != 'slk' THEN
      CALL cl_set_comp_visible("oebislk01",FALSE)
   END IF
   CALL SET_COUNT(g_rec_b)
   DISPLAY ARRAY g_oeb5 TO tb5.* ATTRIBUTE(UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index, g_row_count)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()           
 
      ON ACTION insert                           # A.輸入
         LET g_action_choice='insert'
         EXIT DISPLAY
 
      ON ACTION query                            # Q.查詢
         LET g_action_choice='query'
         EXIT DISPLAY
 
      ON ACTION modify                           # Q.修改
         LET g_action_choice='modify'
         EXIT DISPLAY
 
      ON ACTION detail                           # B.單身
         LET g_action_choice='detail'
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION first                            # 第一筆
         CALL t410_1_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1) 
         END IF
           ACCEPT DISPLAY          
 
      ON ACTION previous                         # P.上筆
         CALL t410_1_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY      
 
      ON ACTION jump                             # 指定筆
         CALL t410_1_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY                 
 
      ON ACTION next                             # N.下筆
         CALL t410_1_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	ACCEPT DISPLAY               
 
      ON ACTION last                             # 最終筆
         CALL t410_1_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY             
 
       ON ACTION help                             # H.說明
          LET g_action_choice='help'
          EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_set_combo_industry("oeb12")   
          CALL cl_show_fld_cont()             
 
         EXIT DISPLAY
 
      ON ACTION exit                             # Esc.結束
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION close
         LET g_action_choice='exit'
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION exporttoexcel     
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t410_1_set_combobox()
   DEFINE   lc_smb01    LIKE smb_file.smb01
   DEFINE   lc_smb03    LIKE smb_file.smb03
   DEFINE   ls_value    STRING
   DEFINE   ls_desc     STRING
 
   LET g_sql = "SELECT UNIQUE smb01,smb03 FROM smb_file WHERE smb02='",g_lang CLIPPED,"'"
   PREPARE smb_pre FROM g_sql
   DECLARE smb_curs CURSOR FOR smb_pre
   FOREACH smb_curs INTO lc_smb01,lc_smb03
      IF lc_smb01 = "std" THEN
         LET ls_value = lc_smb01,",",ls_value
         LET ls_desc = lc_smb01,":",lc_smb03,",",ls_desc
      ELSE
         LET ls_value = ls_value,lc_smb01,","
         LET ls_desc = ls_desc,lc_smb01,":",lc_smb03,","
      END IF
   END FOREACH
   CALL cl_set_combo_items("oeb12",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
END FUNCTION
 
FUNCTION t410_2_csd_get_price(p_oeb)
   DEFINE l_oah03	LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)		#單價取價方式
   DEFINE l_ima131	LIKE type_file.chr20   #No.FUN-680137 VARCHAR(20)	#Product Type
   DEFINE p_oeb           RECORD
            att00          LIKE ima_file.ima01,
            att01          LIKE ima_file.ima02,
            att02          LIKE agd_file.agd02,
            att02_c        LIKE agd_file.agd02,
            att03          LIKE agd_file.agd02,
            att03_c        LIKE agd_file.agd02,
            att04          LIKE obj_file.obj06,
            att05          LIKE obj_file.obj06,
            att06          LIKE obj_file.obj06,
            att07          LIKE obj_file.obj06,
            att08          LIKE obj_file.obj06,
            att09          LIKE obj_file.obj06,
            att10          LIKE obj_file.obj06,
            att11          LIKE obj_file.obj06,
            att12          LIKE obj_file.obj06,
            att13          LIKE obj_file.obj06,
            oeb03          LIKE oeb_file.oeb03,
            oeb04          LIKE oeb_file.oeb04,
            oeb05          LIKE oeb_file.oeb05,
            oeb916         LIKE oeb_file.oeb916,
            oeb15          LIKE oeb_file.oeb15,
            oeb1002        LIKE oeb_file.oeb1002,
            oeb1004        LIKE oeb_file.oeb1004,
            oeb13          LIKE oeb_file.oeb13,
            oeb1001        LIKE oeb_file.oeb1001,
            oeb1012        LIKE oeb_file.oeb1012,
            oebislk01      LIKE oebi_file.oebislk01 
                      END RECORD
 
   SELECT oah03 INTO l_oah03 FROM oah_file WHERE oah01 = g_oea.oea31
   LET p_oeb.oeb13=0
   CASE WHEN l_oah03 = '0' RETURN 0
        WHEN l_oah03 = '1'
             IF g_oea.oea213='Y'
                THEN SELECT ima128 INTO p_oeb.oeb13 FROM ima_file
                            WHERE ima01 = p_oeb.att00
                ELSE SELECT ima127 INTO p_oeb.oeb13 FROM ima_file
                            WHERE ima01 = p_oeb.att00
             END IF
              #->將單價除上匯率
              LET p_oeb.oeb13=p_oeb.oeb13/g_oea.oea24
        WHEN l_oah03 = '2'
             SELECT ima131 INTO l_ima131 FROM ima_file
                    WHERE ima01 = p_oeb.att00
             IF cl_null(p_oeb.oeb916) THEN
                LET p_oeb.oeb916 = p_oeb.oeb05   #MOD-730075 
             END IF
             DECLARE t410_2_csd_get_price_c CURSOR FOR
                 SELECT obg21
                   FROM obg_file
                    WHERE (obg01 = l_ima131          OR obg01 = '*')
                      AND (obg02 = p_oeb.att00 OR obg02 = '*')
                      AND (obg03 = p_oeb.oeb916)
                      AND (obg04 = g_oea.oea25       OR obg04 = '*')
                      AND (obg05 = g_oea.oea31       OR obg05 = '*')
                      AND (obg06 = g_oea.oea03       OR obg06 = '*') #FUN-610055
                      AND (obg09 = g_oea.oea23      )
                      AND (obg10 = g_oea.oea21       OR obg10 = '*')
                 ORDER BY obg02 DESC,obg03 DESC,obg04 DESC, #FUN-610055
                          obg05 DESC,obg06 DESC,obg07 DESC,obg08 DESC, #FUN-610055
                          obg09 DESC,obg10 DESC #FUN-610055
             FOREACH t410_2_csd_get_price_c INTO p_oeb.oeb13
               IF STATUS THEN CALL cl_err('foreach obg',STATUS,1) END IF
               EXIT FOREACH
             END FOREACH
        WHEN l_oah03 = '3'
        #@@@ 95/07/13 By Danny
           SELECT obk08 INTO p_oeb.oeb13 FROM obk_file
                  WHERE obk01 = p_oeb.att00 AND obk02 = g_oea.oea03    #FUN-610055
                    AND obk05 = g_oea.oea23
   END CASE
   RETURN p_oeb.oeb13
END FUNCTION
 
FUNCTION t400_1_chk_oeb1001(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_azf09 LIKE azf_file.azf09   #FUN-920186
 
   IF NOT cl_null(g_oeb5[l_ac].oeb1001) THEN
      IF g_oeb5[l_ac].oeb1001 != g_oeb5_t.oeb1001
         OR cl_null(g_oeb5_t.oeb1001) THEN
             SELECT azf09 INTO l_azf09 FROM azf_file   #FUN-920186
              WHERE azf01=g_oeb5[l_ac].oeb1001
                AND azfacti='Y'
                AND azf02='2'
             IF l_azf09 != '1' THEN
                CALL cl_err('','aoo-400',1)
                RETURN FALSE
             END IF
          IF STATUS=100 THEN 
             CALL cl_err3("sel","azf_file",g_oeb5[l_ac].oeb1001,"","100","","",1)
             LET g_oeb5[l_ac].oeb1001=g_oeb5_t.oeb1001
             RETURN FALSE
          END IF
      END IF
   END IF
   LET g_oeb_t.oeb1001 = g_oeb5[l_ac].oeb1001
   RETURN TRUE
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

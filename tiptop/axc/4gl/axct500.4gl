# Prog. Version..: '5.30.06-13.03.18(00010)'     #
#
# Pattern name...: axct500.4gl
# Descriptions...: 雜項異動單價維護作業
# Date & Author..: 97/08/12 By Kitty
# Modify         : 01/06/28 By Ostrich
#  No.+297 1.雜發單價取價方式參數化(ccz08)
#  No.+294 2.雜收發取價順序(開帳cca23->上月ccc23->最近進價ima53)
#  No.B197 3.bug 修改 after row 須 update tlf21,tlf221
# Modify.........: 03/06/03 By Jiunn No.7088
#                  修正應抓取上期開帳資料
# Modify.........: No:7788 03/08/14 Melody G.單價整批產生的功能,在取單價時應做庫存單位/採購單位與異動單位(inb08)的轉換
# Modify.........: No.MOD-4A0252 04/10/21 By Smapmin 新增單據編號開窗
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0298 04/11/30 By Carol 程式有產生報表,卻無axct500.za
# Modify.........: No.MOD-4C0010 04/12/02 By Mandy DEFINE smydesc欄位用LIKE方式
# Modify.........: No.FUN-4C0005 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.FUN-4C0099 05/01/11 By kim 報表轉XML功能
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.MOD-570099 05/07/18 By kim 1.單身金額改成由單價*數量後不可改
#                                                2.小於成本結算年月(ccz01,ccz02)之單據，應該不可再異動
# Modify.........: No.MOD-590463 05/09/30 By Sarah 將t500_g()段裡"AND ina00 MATCHES '[34]'"mark起來,因後面已有參數要控管
# Modify.........: No.FUN-660079 06/06/19 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.MOD-670041 06/08/02 By Claire 要排除inb05 不存在jce02
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換  
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/16 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740032 07/04/09 By chenl   增加修改按鈕，僅修改單頭備注欄位，其他欄位不予回應。
# Modify.........: No.MOD-740163 07/04/26 By kim inb14考慮小數取位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-750089 07/05/24 By pengu 新增當update tlf_file時若失敗則show錯誤訊息
# Modify.........: No.FUN-7C0028 08/04/02 By Sarah 當有UPDATE tlf_file金額欄位時,要新增tlfc_file
# Modify.........: No.MOD-840407 07/04/21 By Sarah 當要inb14欄位前取位改用ccz26
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-7B0049 08/05/13 By jamie 單身的理由碼 增加顯示中文名稱
# Modify.........: No.MOD-860115 08/07/15 By Pengu 用web登入系統執行單價產生動作,會出現Error
# Modify.........: No.MOD-8A0113 08/10/14 By chenyu t500_b_fill()查詢單身的sql語句條件不全面
# Modify.........: No.MOD-8B0219 08/11/21 By chenyu 調整MOD-8A0113修改內容
# Modify.........: No.MOD-980056 09/08/10 By Smapmin 修改ora檔
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-970228 09/08/21 By destiny 灰調單身新增刪除按鈕 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0018 09/11/04 By xiaofeizhu 標準SQL修改
# Modify.........: No.TQC-9B0040 09/11/10 By Carrier insert tlfc_file参数调整
# Modify.........: No.FUN-9C0008 09/12/03 By alex 環境變數調整
# Modify.........: No:MOD-9C0237 09/12/19 By Pengu 單身查不到資料
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50075 10/05/27 By lutingting tlfc_file 拿掉plant欄位
# Modify.........: No.FUN-A50102 10/06/10 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A60119 10/06/18 By Sarah 列印時應印出完整料號
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-AA0025 10/11/12 BY wujie 追FUN-AA0025在21区的修改
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang 修改本月平均單價的計算
# Modify.........: No:MOD-B50171 11/07/17 By Summer inb13應用ccz26做取位
# Modify.........: No:TQC-B80090 11/08/09 By guoch 处理不在现行年月的问题，现在在inb01里做了开创处理
# Modify.........: No:CHI-BC0026 11/12/16 By ck2yuan 清單無上傳，以mail發出
# Modify.........: No:MOD-C30637 12/03/13 By fengrui 給單價及金額欄位預設0
# Modify.........: No:MOD-C30659 12/03/14 By fengrui 調整單據日期是否落在現行年月的檢查，修改執行成功信息的顯示
# Modify.........: No:MOD-C70149 12/07/12 By ck2yuan 避免程式當掉,將判斷搬到start report前
# Modify.........: No:MOD-C70287 12/07/30 By ck2yuan 產生單價若抓到ima53的價格,就不需要CALL cl_prt
# Modify.........: No:MOD-C70280 12/08/03 By ck2yuan 下條件時,l_cmd,l_cmd2長度可能不足,改為STING
# Modify.........: No:FUN-C10059 12/08/07 By bart 抓取ccc23值時加條件
# Modify.........: No.FUN-C80092 12/12/05 By fengrui 增加寫入日誌功能
# Modify.........: No:TQC-CC0132 12/12/27 By wujie 补材料/人工/制费单价时，更新tlf错误，材料成本更新成了总金额，人工/制费等没有更新
# Modify.........: No:MOD-D10060 13/01/09 By wujie 自动补单价时，没有拆分ccc23a-h写入inb132-inb138
# Modify.........: No:MOD-D10231 13/01/25 By bart 500_g 單價產生方式,ccz08=3/4/5 應改ccz28
# Modify.........: No:CHI-B70038 13/01/31 By Alberti 單價產生QBE條件增加理由碼 
# Modify.........: No:MOD-D50074 13/05/09 By suncx MOD-D10060拆分ccc23a-h写入inb132-inb138时，没有计算金额加总写入inb14
# Modify.........: No:TQC-DB0025 13/11/25 By wangrr "部門編號""項目編號"欄位增加開窗,
#                                                   點擊[單價生產]Action彈出的畫面中"料件編號""來源碼"欄位增加開窗
#C2017041401chenyang   查询不带出非成本仓
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
       g_ina   RECORD LIKE ina_file.*,
       g_ina_t RECORD LIKE ina_file.*,
       g_ina_o RECORD LIKE ina_file.*,
       g_ina01_t      LIKE ina_file.ina01,       #No.TQC-740032
       g_yy,g_mm		LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #
       b_inb   RECORD LIKE inb_file.*,
       g_inb           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                inb03     LIKE inb_file.inb03,
                inb04     LIKE inb_file.inb04,
                ima02     LIKE ima_file.ima02,
                inb07     LIKE inb_file.inb07,
                inb05     LIKE inb_file.inb05,
                inb06     LIKE inb_file.inb06,
                inb08     LIKE inb_file.inb08,
                inb08_fac LIKE inb_file.inb08_fac,
                inb09     LIKE inb_file.inb09,
                inb15     LIKE inb_file.inb15,
                azf03     LIKE azf_file.azf03,    #FUN-7B0049 add
                inb13     LIKE inb_file.inb13,
             #FUN-AB0089--ADD--begin
                inb132    LIKE inb_file.inb132,
                inb133    LIKE inb_file.inb133,
                inb134    LIKE inb_file.inb134,
                inb135    LIKE inb_file.inb135,
                inb136    LIKE inb_file.inb136,
                inb137    LIKE inb_file.inb137,
                inb138    LIKE inb_file.inb138,
             #FUN-AB0089--ADD--end
                inb14     LIKE inb_file.inb14
                END RECORD,
         g_inb_t         RECORD
                inb03     LIKE inb_file.inb03,
                inb04     LIKE inb_file.inb04,
                ima02     LIKE ima_file.ima02,
                inb07     LIKE inb_file.inb07,
                inb05     LIKE inb_file.inb05,
                inb06     LIKE inb_file.inb06,
                inb08     LIKE inb_file.inb08,
                inb08_fac LIKE inb_file.inb08_fac,
                inb09     LIKE inb_file.inb09,
                inb15     LIKE inb_file.inb15,
                azf03     LIKE azf_file.azf03,    #FUN-7B0049 add
                inb13     LIKE inb_file.inb13,
             #FUN-AB0089--ADD--begin
                inb132    LIKE inb_file.inb132,
                inb133    LIKE inb_file.inb133,
                inb134    LIKE inb_file.inb134,
                inb135    LIKE inb_file.inb135,
                inb136    LIKE inb_file.inb136,
                inb137    LIKE inb_file.inb137,
                inb138    LIKE inb_file.inb138,
             #FUN-AB0089--ADD--end
                inb14     LIKE inb_file.inb14
                END RECORD,
          g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
         g_t1                LIKE oay_file.oayslip,   #No.FUN-550025        #No.FUN-680122 VARCHAR(5)
         g_sw                LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),
         g_buf           LIKE type_file.chr1000,      #No.FUN-680122
         g_rec_b         LIKE type_file.num5,         #單身筆數        #No.FUN-680122 SMALLINT
         l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680122 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680122CHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680122 INTEGER
DEFINE   g_no_ask       LIKE type_file.num5     #No.FUN-680122 SMALLINT
DEFINE   g_post         LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
DEFINE   g_void         LIKE type_file.chr1     #No.FUN-680122 VARCHAR(1)
DEFINE   g_cka00        LIKE cka_file.cka00     #No.FUN-C80092
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   OPEN WINDOW t500_w WITH FORM "axc/42f/axct500"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET g_forupd_sql = "SELECT * FROM ina_file WHERE ina01=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t500_cl CURSOR FROM g_forupd_sql 
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   CALL t500_menu()
   CLOSE WINDOW t500_w                 #結束畫面

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


 
FUNCTION t500_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_inb.clear()
    CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_ina.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        ina00,ina01,ina02,ina04,ina06,ina07,inaconf, #FUN-660079
        inapost,inauser,inagrup,inamodu,inadate
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
    ON ACTION controlp
         CASE
            WHEN INFIELD(ina01) #單據編號  #MOD-4A0252單據編號開窗
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_ina2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ina01
               NEXT FIELD ina01
            #TQC-DB0025--add--str--
            WHEN INFIELD(ina04)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ina04
               NEXT FIELD ina04
            WHEN INFIELD(ina06)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pja2"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO ina06
               NEXT FIELD ina06
            #TQC-DB0025--add--end
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('inauser', 'inagrup')
 
    CONSTRUCT g_wc2 ON inb03,inb04,inb07,inb05,inb06,
                       inb08,inb09,inb15,azf03,inb13,inb132,inb133,inb134,inb135,     #FUN-AB0089 add inb132,inb133,inb134,inb135
                       inb136,inb137,inb138,inb14  #FUN-7B0049 add azf03  #FUN-AB0089 add inb136,inb137,inb138
            FROM s_inb[1].inb03, s_inb[1].inb04, s_inb[1].inb07,
                 s_inb[1].inb05, s_inb[1].inb06, s_inb[1].inb08,
                 s_inb[1].inb09, s_inb[1].inb15, s_inb[1].azf03,  s_inb[1].inb13,  #FUN-7B0049 add azf03
                 s_inb[1].inb132,s_inb[1].inb133,s_inb[1].inb134,s_inb[1].inb135,  #FUN-AB0089 add
                 s_inb[1].inb136,s_inb[1].inb137,s_inb[1].inb138,                  #FUN-AB0089 add
                 s_inb[1].inb14
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ina01 FROM ina_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND inapost = 'Y'"
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE ina01 ",
                   "  FROM ina_file, inb_file",
                   " WHERE ina01 = inb01",
                   "   AND inapost = 'Y'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
 
 #雜發單價採 1.系統認定 or 2.人工認定
    IF g_ccz.ccz08 = '1' THEN
       LET g_sql = g_sql CLIPPED,
           " and ina00 IN ('3','4') ORDER BY ina01" #限定雜收
    ELSE
       LET g_sql = g_sql CLIPPED,
           " and ina00 IN ('1','2','3','4','5','6') ORDER BY ina01"
    END IF
 
    PREPARE t500_prepare FROM g_sql
    DECLARE t500_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t500_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM ina_file WHERE ",g_wc CLIPPED,
                       "     AND inapost = 'Y'"
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ina01) FROM ina_file,inb_file WHERE ",
                  "inb01=ina01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                       "     AND inapost = 'Y'"
    END IF
 
 #雜發單價採 1.系統認定 or 2.人工認定
    IF g_ccz.ccz08 = '1' THEN
       LET g_sql = g_sql CLIPPED," and ina00 IN ('3','4')"
    ELSE
       LET g_sql = g_sql CLIPPED," and ina00 IN ('1','2','3','4','5','6')"
    END IF
 
    PREPARE t500_precount FROM g_sql
    DECLARE t500_count CURSOR FOR t500_precount
END FUNCTION
 
FUNCTION t500_menu()
 
   WHILE TRUE
      CALL t500_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t500_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
                IF t500_chk_costym() THEN #MOD-570099
                  CALL t500_b()
               ELSE
                   LET g_action_choice = NULL #MOD-570099
                   CONTINUE WHILE             #MOD-570099
               END IF
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t500_u()
            END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "單價產生"
         WHEN "gen_u_p"
            IF cl_chk_act_auth() THEN
               CALL t500_g()
            END IF
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_inb),'','')
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_ina.ina01 IS NOT NULL THEN
                 LET g_doc.column1 = "ina01"
                 LET g_doc.value1 = g_ina.ina01
                 CALL cl_doc()
               END IF
           END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t500_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t500_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_ina.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t500_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ina.* TO NULL
    ELSE
        OPEN t500_count
        FETCH t500_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t500_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t500_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680122 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t500_cs INTO g_ina.ina01
        WHEN 'P' FETCH PREVIOUS t500_cs INTO g_ina.ina01
        WHEN 'F' FETCH FIRST    t500_cs INTO g_ina.ina01
        WHEN 'L' FETCH LAST     t500_cs INTO g_ina.ina01
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
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump t500_cs INTO g_ina.ina01
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
        INITIALIZE g_ina.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ina.* FROM ina_file WHERE ina01 = g_ina.ina01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660127
        INITIALIZE g_ina.* TO NULL
        RETURN
    ELSE
       LET g_data_owner=g_ina.inauser           #FUN-4C0061權限控管
       LET g_data_group=g_ina.inagrup
       LET g_data_plant = g_ina.inaplant #FUN-980030
    END IF
 
    CALL t500_show()
END FUNCTION
 
FUNCTION t500_show()
     DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
 
    LET g_ina_t.* = g_ina.*                #保存單頭舊值
    DISPLAY BY NAME
        g_ina.ina00,g_ina.ina01,g_ina.ina02,g_ina.ina04,
        g_ina.ina06,g_ina.ina07,g_ina.inaconf,g_ina.inapost, #FUN-660079
        g_ina.inauser,g_ina.inagrup,g_ina.inamodu,g_ina.inadate
    CALL s_get_doc_no(g_ina.ina01) RETURNING g_buf
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf #MOD-4C0010
     DISPLAY l_smydesc TO smydesc LET g_buf = NULL #MOD-4C0010
 
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_ina.ina04
                 DISPLAY g_buf TO gem02 LET g_buf = NULL
 
    #圖形顯示
    
    IF g_ina.inaconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_ina.inaconf,"",g_ina.inapost,"",g_void,"")
    CALL t500_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t500_b()
DEFINE
    l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_row,l_col     LIKE type_file.num5,     #No.FUN-680122 SMALLINT,			   #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,     #檢查重複用        #No.FUN-680122 SMALLINT
    l_lock_sw       LIKE type_file.chr1,     #單身鎖住否        #No.FUN-680122 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,     #處理狀態        #No.FUN-680122 VARCHAR(1)
    l_possible      LIKE type_file.num5,     #用來設定判斷重複的可能性  #No.FUN-680122 SMALLINT
    l_b2            LIKE type_file.chr50,    #No.FUN-680122 VARCHAR(30),
    l_ima35,l_ima36 LIKE ima_file.ima35,     #No.FUN-680122 VARCHAR(10), #TQC-840066
    l_flag          LIKE type_file.num10,    #No.FUN-680122 INTEGER,
    l_cn            LIKE type_file.num5,     #No.FUN-680122 SMALLINT,              #MOD-670041 add
    l_allow_insert  LIKE type_file.num5,     #可新增否        #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否        #No.FUN-680122 SMALLINT
    l_tlf_rowid     LIKE type_file.row_id,   #chr18  FUN-A70120
    l_msg           STRING                   #FUN-C80092
 
    LET g_action_choice = ""
    IF g_ina.ina01 IS NULL THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT * FROM inb_file",
      "  WHERE inb01= ? ",
      "   AND inb03= ? ",
      " FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    LET l_ac_t = 0
       LET l_allow_insert = FALSE                                         #No.TQC-970228                                            
       LET l_allow_delete = FALSE                                         #No.TQC-970228 
 
      INPUT ARRAY g_inb WITHOUT DEFAULTS FROM s_inb.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            DISPLAY "l_ac=",l_ac
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                LET g_inb_t.* = g_inb[l_ac].*  #BACKUP
                LET p_cmd='u'
                #FUN-C80092 ---------Begin--------------
                LET l_msg = "g_ina.ina01= '",g_ina.ina01,"'",";","g_inb_t.inb03 =  '",g_inb_t.inb03,"'"
                CALL s_log_ins(g_prog,'','','',l_msg) RETURNING g_cka00
                #FUN-C80092 ---------End----------------
		BEGIN WORK
                OPEN t500_bcl USING g_ina.ina01,g_inb_t.inb03
                IF STATUS THEN
                    CALL cl_err("OPEN t500_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t500_bcl INTO b_inb.*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err('lock inb',SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                        CALL t500_b_move_to()
                    END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            ELSE
               EXIT INPUT
            END IF
 
        BEFORE INSERT
                LET l_n = ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_inb[l_ac].* TO NULL      #900423
                INITIALIZE g_inb_t.* TO NULL
                LET b_inb.inb01=g_ina.ina01
                LET g_inb[l_ac].inb08_fac=1
                LET g_inb[l_ac].inb09=0
                IF l_ac > 1 THEN
                   LET g_inb[l_ac].inb15=g_inb[l_ac-1].inb15
                   LET g_inb[l_ac].azf03=g_inb[l_ac-1].azf03   #FUN-7B0049 add
                   LET g_inb[l_ac].inb04=g_inb[l_ac-1].inb04
                   LET g_inb[l_ac].inb05=g_inb[l_ac-1].inb05
                   LET g_inb[l_ac].inb06=g_inb[l_ac-1].inb06
                   LET g_inb[l_ac].inb07=g_inb[l_ac-1].inb07
                   LET g_inb[l_ac].inb13=g_inb[l_ac-1].inb13
             #FUN-AB0089--add--begin
                   LET g_inb[l_ac].inb132=g_inb[l_ac-1].inb132
                   LET g_inb[l_ac].inb133=g_inb[l_ac-1].inb133
                   LET g_inb[l_ac].inb134=g_inb[l_ac-1].inb134
                   LET g_inb[l_ac].inb135=g_inb[l_ac-1].inb135
                   LET g_inb[l_ac].inb136=g_inb[l_ac-1].inb136
                   LET g_inb[l_ac].inb137=g_inb[l_ac-1].inb137
                   LET g_inb[l_ac].inb138=g_inb[l_ac-1].inb138
             #FUN-AB0089--add--end
                   LET g_inb[l_ac].inb14=g_inb[l_ac-1].inb14
                END IF
                #MOD-C30637--add--str--
                IF cl_null(g_inb[l_ac].inb13)  THEN LET g_inb[l_ac].inb13  = 0 END IF
                IF cl_null(g_inb[l_ac].inb132) THEN LET g_inb[l_ac].inb132 = 0 END IF
                IF cl_null(g_inb[l_ac].inb133) THEN LET g_inb[l_ac].inb133 = 0 END IF
                IF cl_null(g_inb[l_ac].inb134) THEN LET g_inb[l_ac].inb134 = 0 END IF
                IF cl_null(g_inb[l_ac].inb135) THEN LET g_inb[l_ac].inb135 = 0 END IF
                IF cl_null(g_inb[l_ac].inb136) THEN LET g_inb[l_ac].inb136 = 0 END IF
                IF cl_null(g_inb[l_ac].inb137) THEN LET g_inb[l_ac].inb137 = 0 END IF
                IF cl_null(g_inb[l_ac].inb138) THEN LET g_inb[l_ac].inb138 = 0 END IF
                IF cl_null(g_inb[l_ac].inb14)  THEN LET g_inb[l_ac].inb14  = 0 END IF
                DISPLAY BY NAME g_inb[l_ac].inb13,g_inb[l_ac].inb132,g_inb[l_ac].inb133,g_inb[l_ac].inb134,g_inb[l_ac].inb135,
                                g_inb[l_ac].inb136,g_inb[l_ac].inb137,g_inb[l_ac].inb138,g_inb[l_ac].inb14
                #MOD-C30637--add--end--
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              NEXT FIELD inb03
 
        BEFORE DELETE                            #是否取消單身
            IF g_inb_t.inb03 > 0 AND g_inb_t.inb03 IS NOT NULL THEN
                CALL cl_err(g_inb_t.inb03,'axct001',0)
            END IF
 
        AFTER FIELD inb13
            IF NOT cl_null(g_inb[l_ac].inb13) THEN
               #LET g_inb[l_ac].inb13=cl_digcut(g_inb[l_ac].inb13,g_azi03) #MOD-740163   #MOD-B50171 mark
                LET g_inb[l_ac].inb13=cl_digcut(g_inb[l_ac].inb13,g_ccz.ccz26)           #MOD-B50171 add
                DISPLAY BY NAME g_inb[l_ac].inb13 #MOD-740163
        #       LET g_inb[l_ac].inb14=g_inb[l_ac].inb09*g_inb[l_ac].inb13
        #       LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb14,g_ccz.ccz26)           #MOD-840407
        #FUN-AB0089--add--begin
                LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
        #FUN-AB0089--add--end 
                DISPLAY BY NAME g_inb[l_ac].inb14 #MOD-740163
            END IF
     #FUN-AB0089--add--begin
        AFTER FIELD inb132
            IF NOT cl_null(g_inb[l_ac].inb132) THEN
               LET g_inb[l_ac].inb132=cl_digcut(g_inb[l_ac].inb132,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb132
               LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
        AFTER FIELD inb133
            IF NOT cl_null(g_inb[l_ac].inb133) THEN
               LET g_inb[l_ac].inb133=cl_digcut(g_inb[l_ac].inb133,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb133
               LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
        AFTER FIELD inb134
            IF NOT cl_null(g_inb[l_ac].inb134) THEN
               LET g_inb[l_ac].inb134=cl_digcut(g_inb[l_ac].inb134,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb134
               LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
        AFTER FIELD inb135
            IF NOT cl_null(g_inb[l_ac].inb135) THEN
               LET g_inb[l_ac].inb135=cl_digcut(g_inb[l_ac].inb135,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb135
                LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
        AFTER FIELD inb136
            IF NOT cl_null(g_inb[l_ac].inb136) THEN
               LET g_inb[l_ac].inb136=cl_digcut(g_inb[l_ac].inb136,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb136
               LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
         AFTER FIELD inb137
            IF NOT cl_null(g_inb[l_ac].inb137) THEN
               LET g_inb[l_ac].inb137=cl_digcut(g_inb[l_ac].inb137,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb137
               LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
        AFTER FIELD inb138
            IF NOT cl_null(g_inb[l_ac].inb138) THEN
               LET g_inb[l_ac].inb138=cl_digcut(g_inb[l_ac].inb138,g_azi03)
               DISPLAY BY NAME g_inb[l_ac].inb138
               LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb09*g_inb[l_ac].inb13+g_inb[l_ac].inb09*g_inb[l_ac].inb132+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb133+g_inb[l_ac].inb09*g_inb[l_ac].inb134+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb135+g_inb[l_ac].inb09*g_inb[l_ac].inb136+
                                                g_inb[l_ac].inb09*g_inb[l_ac].inb137+g_inb[l_ac].inb09*g_inb[l_ac].inb138,
                                                g_ccz.ccz26)
               DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
     #FUN-AB0089--add--end 
        AFTER FIELD inb14
            IF NOT cl_null(g_inb[l_ac].inb14) THEN
                LET g_inb[l_ac].inb14=cl_digcut(g_inb[l_ac].inb14,g_ccz.ccz26)           #MOD-840407 
                DISPLAY BY NAME g_inb[l_ac].inb14
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_inb[l_ac].* = g_inb_t.*
               CLOSE t500_bcl
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')           #FUN-C80092
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_inb[l_ac].inb03,-263,1)
                LET g_inb[l_ac].* = g_inb_t.*
                CALL s_log_upd(g_cka00,'N')           #FUN-C80092
            ELSE
                CALL t500_b_move_back()
                CALL t500_b_else()
                UPDATE inb_file SET inb13=b_inb.inb13,
                                    inb132=b_inb.inb132,inb133=b_inb.inb133,inb134=b_inb.inb134,inb135=b_inb.inb135,
                                    inb136=b_inb.inb136,inb137=b_inb.inb137,inb138=b_inb.inb138,
                                    inb14=b_inb.inb14
                   WHERE inb01=g_ina.ina01 AND inb03=g_inb_t.inb03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","inb_file",g_ina.ina01,g_inb_t.inb03,SQLCA.sqlcode,"","upd inb",1)  #No.FUN-660127
                   LET g_inb[l_ac].* = g_inb_t.*
                   CALL s_log_upd(g_cka00,'N')           #FUN-C80092
                ELSE
                   MESSAGE 'UPDATE O.K'
		   COMMIT WORK
                   CALL s_log_upd(g_cka00,'Y')        #FUN-C80092
                END IF
                LET g_inb_t.* = g_inb[l_ac].*          # 900423
 
                LET l_cn=0
                SELECT COUNT(*) INTO l_cn FROM jce_file
                 WHERE jce02=g_inb[l_ac].inb05
                IF l_cn =0 THEN
                   UPDATE tlf_file SET tlf21 = b_inb.inb14,
#No.FUN-AA0025 --begin
#No.TQC-CC0132 --begin
#                                       tlf221= b_inb.inb14,
                                       tlf21x = b_inb.inb14,
#                                       tlf221x= b_inb.inb14
                                       tlf221   = b_inb.inb13*b_inb.inb09,    #材料成本
                                       tlf221x  = b_inb.inb13*b_inb.inb09,    #材料成本
                                       tlf222x  = b_inb.inb132*b_inb.inb09,   #人工成本
                                       tlf2231x = b_inb.inb133*b_inb.inb09,   #制费一成本
                                       tlf2232x = b_inb.inb134*b_inb.inb09,   #加工成本
                                       tlf2241x = b_inb.inb136*b_inb.inb09,   #制费三成本
                                       tlf2242x = b_inb.inb137*b_inb.inb09,   #制费四成本
                                       tlf2243x = b_inb.inb138*b_inb.inb09,   #制费五成本
                                       tlf224x  = b_inb.inb135*b_inb.inb09    #制费二成本
#No.TQC-CC0132 --end
#No.FUN-AA0025 --en
                    WHERE tlf905 = g_ina.ina01 AND tlf906 = g_inb_t.inb03
                   IF SQLCA.sqlcode  THEN
                       CALL cl_err('UPDATE tlf ERROR!',SQLCA.sqlcode,1) 
                   END IF
 
                   #新增tlfc_file記錄依 "成本計算類別"  的異動成本
                   SELECT rowid INTO l_tlf_rowid FROM tlf_file
                    WHERE tlf905 = g_ina.ina01 AND tlf906 = g_inb_t.inb03
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('SELECT tlf ERROR!',SQLCA.sqlcode,1) 
                   ELSE
#                      CALL t500_ins_tlfc(l_tlf_rowid)          #No.FUN-AA0025
                   END IF
                END IF    #MOD-670041 add
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_inb[l_ac].* = g_inb_t.*
               END IF
               CLOSE t500_bcl
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')        #FUN-C80092
               EXIT INPUT
            END IF
            CLOSE t500_bcl
            COMMIT WORK
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
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
 
 
      END INPUT
      UPDATE ina_file SET inamodu=g_user,inadate=g_today
          WHERE ina01=g_ina.ina01
 
      SELECT COUNT(*) INTO g_cnt FROM inb_file WHERE inb01=g_ina.ina01
    CLOSE t500_bcl
	COMMIT WORK
END FUNCTION
 
FUNCTION t500_b_move_to()
   LET g_inb[l_ac].inb03 = b_inb.inb03
   LET g_inb[l_ac].inb04 = b_inb.inb04
   LET g_inb[l_ac].inb05 = b_inb.inb05
   LET g_inb[l_ac].inb06 = b_inb.inb06
   LET g_inb[l_ac].inb07 = b_inb.inb07
   LET g_inb[l_ac].inb08 = b_inb.inb08
   LET g_inb[l_ac].inb08_fac = b_inb.inb08_fac
   LET g_inb[l_ac].inb09 = b_inb.inb09
   LET g_inb[l_ac].inb13 = b_inb.inb13
#FUN-AB0089 --add--begin
   LET g_inb[l_ac].inb132 = b_inb.inb132 
   LET g_inb[l_ac].inb133 = b_inb.inb133
   LET g_inb[l_ac].inb134 = b_inb.inb134
   LET g_inb[l_ac].inb135 = b_inb.inb135
   LET g_inb[l_ac].inb136 = b_inb.inb136
   LET g_inb[l_ac].inb137 = b_inb.inb137
   LET g_inb[l_ac].inb138 = b_inb.inb138
#FUN-AB0089 --add--end
   LET g_inb[l_ac].inb14 = b_inb.inb14
   LET g_inb[l_ac].inb15 = b_inb.inb15
   #MOD-C30637--add--str--
   IF cl_null(g_inb[l_ac].inb13)  THEN LET g_inb[l_ac].inb13  = 0 END IF
   IF cl_null(g_inb[l_ac].inb132) THEN LET g_inb[l_ac].inb132 = 0 END IF
   IF cl_null(g_inb[l_ac].inb133) THEN LET g_inb[l_ac].inb133 = 0 END IF
   IF cl_null(g_inb[l_ac].inb134) THEN LET g_inb[l_ac].inb134 = 0 END IF
   IF cl_null(g_inb[l_ac].inb135) THEN LET g_inb[l_ac].inb135 = 0 END IF
   IF cl_null(g_inb[l_ac].inb136) THEN LET g_inb[l_ac].inb136 = 0 END IF
   IF cl_null(g_inb[l_ac].inb137) THEN LET g_inb[l_ac].inb137 = 0 END IF
   IF cl_null(g_inb[l_ac].inb138) THEN LET g_inb[l_ac].inb138 = 0 END IF
   IF cl_null(g_inb[l_ac].inb14)  THEN LET g_inb[l_ac].inb14  = 0 END IF
   DISPLAY BY NAME g_inb[l_ac].inb13,g_inb[l_ac].inb132,g_inb[l_ac].inb133,g_inb[l_ac].inb134,g_inb[l_ac].inb135,
                   g_inb[l_ac].inb136,g_inb[l_ac].inb137,g_inb[l_ac].inb138,g_inb[l_ac].inb14
   #MOD-C30637--add--end--
END FUNCTION
 
FUNCTION t500_b_move_back()
   LET b_inb.inb03 = g_inb[l_ac].inb03
   LET b_inb.inb04 = g_inb[l_ac].inb04
   LET b_inb.inb05 = g_inb[l_ac].inb05
   LET b_inb.inb06 = g_inb[l_ac].inb06
   LET b_inb.inb07 = g_inb[l_ac].inb07
   LET b_inb.inb08 = g_inb[l_ac].inb08
   LET b_inb.inb08_fac = g_inb[l_ac].inb08_fac
   LET b_inb.inb09 = g_inb[l_ac].inb09
   LET b_inb.inb13 = g_inb[l_ac].inb13
#FUN-AB0089 --add--begin
   LET b_inb.inb132 = g_inb[l_ac].inb132
   LET b_inb.inb133 = g_inb[l_ac].inb133
   LET b_inb.inb134 = g_inb[l_ac].inb134
   LET b_inb.inb135 = g_inb[l_ac].inb135
   LET b_inb.inb136 = g_inb[l_ac].inb136
   LET b_inb.inb137 = g_inb[l_ac].inb137
   LET b_inb.inb138 = g_inb[l_ac].inb138
#FUN-AB0089 --add--end
   LET b_inb.inb14 = g_inb[l_ac].inb14
   LET b_inb.inb15 = g_inb[l_ac].inb15
END FUNCTION
 
FUNCTION t500_b_else()
   IF g_inb[l_ac].inb05 IS NULL THEN LET g_inb[l_ac].inb05 =' ' END IF
   IF g_inb[l_ac].inb06 IS NULL THEN LET g_inb[l_ac].inb06 =' ' END IF
   IF g_inb[l_ac].inb07 IS NULL THEN LET g_inb[l_ac].inb07 =' ' END IF
END FUNCTION
 
#---單價產生
FUNCTION t500_g()
  DEFINE  l_cmd     STRING,                  #No.FUN-680122CHAR(200)  #MOD-C70280 chr1000 -> STRING
          l_cmd2    STRING,                  #No.FUN-680122CHAR(200)  #MOD-C70280 chr1000 -> STRING
          x_cnt     LIKE type_file.num5,     #No.FUN-680122 smallint,
          l_bdate,l_edate LIKE type_file.dat,      #No.FUN-680122 DATE,
          l_za05    LIKE type_file.chr1000,  #No.FUN-680122 VARCHAR(40),
          l_name    LIKE type_file.chr20,    #No.FUN-680122 VARCHAR(20),
          tm RECORD
               x          LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),
               yy         LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
               mm         LIKE type_file.num5,     #No.FUN-680122 SMALLINT,
               plant      LIKE azp_file.azp01
          END RECORD,
          l_fromplant LIKE azp_file.azp03,
          l_flag      LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_flag1 LIKE type_file.num5,          #No.MOD-860115 add
          sr RECORD
               inb01 like inb_file.inb01,
               inb03 like inb_file.inb03,
               inb04 like inb_file.inb04,
               inb08 like inb_file.inb08,
               inb09 like inb_file.inb09,
               ima25 LIKE ima_file.ima25,
               ima44 LIKE ima_file.ima44
          END RECORD,
          l_fac        LIKE ade_file.ade31,     #No.FUN-680122 dec(16,8),
#No.MOD-D10060 --begin
          l_uprice     LIKE ccc_file.ccc23,  #MOD-D10231
          l_uprice1    LIKE ccc_file.ccc23a,
          l_uprice2    LIKE ccc_file.ccc23b,
          l_uprice3    LIKE ccc_file.ccc23c,
          l_uprice4    LIKE ccc_file.ccc23d,
          l_uprice5    LIKE ccc_file.ccc23e,
          l_uprice6    LIKE ccc_file.ccc23f,
          l_uprice7    LIKE ccc_file.ccc23g,
          l_uprice8    LIKE ccc_file.ccc23h,
#No.MOD-D10060 --end
          l_amount     LIKE inb_file.inb14,
#No.MOD-D10060 --begin
          l_amount1     LIKE inb_file.inb14,
          l_amount2     LIKE inb_file.inb14,
          l_amount3     LIKE inb_file.inb14,
          l_amount4     LIKE inb_file.inb14,
          l_amount5     LIKE inb_file.inb14,
          l_amount6     LIKE inb_file.inb14,
          l_amount7     LIKE inb_file.inb14,
          l_amount8     LIKE inb_file.inb14,
#No.MOD-D10060 --end
          l_tlf_rowid  LIKE type_file.row_id    #chr18  FUN-A70120
  DEFINE l_plant  LIKE type_file.chr20    #FUN-A50102
  DEFINE l_a      STRING    #TQC-B80090
  DEFINE l_inb01  LIKE inb_file.inb01    #TQC-B80090
  DEFINE tok base.StringTokenizer  #TQC-B80090
  DEFINE l_sql    STRING    #TQC-B80090
  DEFINE l_cnt    LIKE type_file.num5   #TQC-B80090
  DEFINE l_cnt2   LIKE type_file.num10  #MOD-C70287 add
  DEFINE l_flg   LIKE type_file.chr1   #TQC-B80090
  DEFINE l_tlf13  LIKE tlf_file.tlf13   #FUN-C10059
  DEFINE l_tlf20  LIKE tlf_file.tlf20   #FUN-C10059
  DEFINE l_tlf901 LIKE tlf_file.tlf901  #FUN-C10059
  DEFINE l_tlf904 LIKE tlf_file.tlf904  #FUN-C10059
  
  OPEN WINDOW t500_g WITH FORM "axc/42f/axct500_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
  CALL cl_ui_locale("axct500_g")
 
  DISPLAY BY NAME g_ccz.ccz01,g_ccz.ccz02
  WHILE TRUE
     CONSTRUCT BY NAME g_wc ON inb01,inb04,ima08,inb15       #CHI-B70038 add
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()

   #MOD-C30659--mark--str--
   #   #TQC-B80090  --begin
   #   AFTER FIELD inb01
   #      CALL s_showmsg_init()
   #      LET l_flg = 'Y'
   #      CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
   #                RETURNING l_flag1, l_bdate, l_edate
   #      LET l_a = GET_FLDBUF(inb01)
   #      LET tok = base.StringTokenizer.create(l_a,"|")
   #      WHILE tok.hasMoreTokens()
   #          LET l_inb01 = tok.nextToken()
   #          SELECT COUNT(inb01) INTO l_cnt FROM inb_file,ima_file ,ina_file,smy_file 
   #           WHERE inb04 = ima01 and inb01 = ina01 
   #             AND ina02 BETWEEN l_bdate AND l_edate
   #             AND inapost = 'Y' 
   #             AND ina01 like ltrim(rtrim(smyslip)) || '-%' 
   #             AND inb05 NOT IN (SELECT jce02 FROM jce_file)
   #             AND inb01 = l_inb01
   #          SELECT COUNT(inb01) INTO l_cnt FROM inb_file
   #           WHERE inb01 = l_inb01
   #          IF l_cnt <= 0 OR cl_null(l_cnt) THEN
   #             LET l_flg = 'N'
   #             CALL s_errmsg('inb01',l_inb01,'sel_inb01','axc-101',1)   
   #          END IF
   #      END WHILE
   #      CALL s_showmsg()
   #      IF l_flg = 'N' THEN
   #         NEXT FIELD inb01
   #      END IF
   #MOD-C30659--mark--end--   

      ON ACTION controlp
         CASE
           WHEN INFIELD(inb01)
              CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
                   RETURNING l_flag1, l_bdate, l_edate
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_inb3"
              LET g_qryparam.arg1 = l_bdate
              LET g_qryparam.arg2 = l_edate
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO inb01

            #TQC-DB0025--add--str--
           WHEN INFIELD(inb04)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO inb04
              NEXT FIELD inb04
           WHEN INFIELD(ima08)
              CALL cl_init_qry_var()
              LET g_qryparam.form ="q_ima08_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO ima08
              NEXT FIELD ima08
           #TQC-DB0025--add--end

            #CHI-B70038 --- modify --- start ---
            WHEN INFIELD(inb15)
               CALL cl_init_qry_var()
               IF g_sma.sma79='Y' THEN
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = 'A2'
                  LET g_qryparam.arg1 = "A2"
               ELSE
                  LET g_qryparam.form ="q_azf01a"
                  LET g_qryparam.default1 = '2'
                  LET g_qryparam.arg1 = "4"
               END IF
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO inb15
           #CHI-B70038 --- modify ---  end  ---    
           OTHERWISE
              EXIT CASE
         END CASE
      #TQC-B80090  --end
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
     IF INT_FLAG THEN EXIT WHILE END IF
     IF g_wc = ' 1=1' THEN
      CALL cl_err('','9046',1) CONTINUE WHILE
     END IF
     EXIT WHILE
  END WHILE
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW t500_g
     RETURN
  END IF
  IF cl_null(g_wc) THEN LET g_wc = ' 1=1' END IF
 
  LET tm.plant = g_plant
  # return 上期年月
  CALL s_lsperiod(g_ccz.ccz01,g_ccz.ccz02) RETURNING tm.yy,tm.mm
 
  LET tm.x = 'N'
  INPUT BY NAME tm.x,tm.plant,tm.yy,tm.mm WITHOUT DEFAULTS
 
    AFTER FIELD plant
      IF tm.x = 'N' THEN
         select count(*) into x_cnt
         from azp_file
         where azp01=tm.plant
         if x_cnt=0 then
            next field plant
         end if
      END IF
 
    ON ACTION CONTROLR
       CALL cl_show_req_fields()
 
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    AFTER INPUT
      IF tm.x = 'N' THEN
         IF cl_null(tm.plant) THEN NEXT FIELD plant END IF
         IF cl_null(tm.yy) THEN NEXT FIELD yy END IF
         IF cl_null(tm.mm) THEN NEXT FIELD mm END IF
      END IF
       IF int_flag THEN EXIT INPUT END IF
       CALL s_azm(g_ccz.ccz01,g_ccz.ccz02)
            RETURNING l_flag1, l_bdate, l_edate #得出起始日與截止日  #No.MOD-860115 modify
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlp
                    CASE WHEN INFIELD(plant)
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_azp"
                       LET g_qryparam.default1 = tm.plant
                       CALL cl_create_qry() RETURNING tm.plant
                       DISPLAY BY NAME tm.plant
                       NEXT FIELD plant
                    END CASE
 
 
   END INPUT
   IF INT_FLAG THEN CLOSE WINDOW t500_g RETURN END IF
 
   IF tm.x = 'N' THEN
      SELECT azp03 INTO l_fromplant FROM azp_file WHERE azp01=tm.plant
      LET l_plant = tm.plant   #FUN-A50102
      IF cl_null(l_fromplant) THEN
         SELECT azp03 into l_fromplant from azp_file where azp01 = g_plant
         LET l_plant = g_plant   #FUN-A50102
      END IF
      LET l_fromplant = s_dbstring(l_fromplant) 
#No.MOD-D10060 --begin
      #LET l_cmd ="SELECT ccc23 ",
      LET l_cmd ="SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h ",
#No.MOD-D10060 --end
              #"FROM ",l_fromplant clipped,"ccc_file ",
              "FROM ",cl_get_target_table(l_plant,'ccc_file'), #FUN-A50102
              " WHERE ccc01 = ?  ",
              " AND ccc02 = ",tm.yy ,
              " and ccc03 = ",tm.mm CLIPPED
#FUN-C10059---begin
      #IF g_ccz.ccz08 = '3' OR g_ccz.ccz08 = '4' OR g_ccz.ccz08 = '5' THEN  #MOD-D10231 
      #      LET l_cmd = l_cmd CLIPPED," AND ccc07 = '",g_ccz.ccz08,"'", #MOD-D10231
      IF g_ccz.ccz28 = '3' OR g_ccz.ccz28 = '4' OR g_ccz.ccz28 = '5' THEN  #MOD-D10231 
            LET l_cmd = l_cmd CLIPPED," AND ccc07 = '",g_ccz.ccz28,"'", #MOD-D10231
                        " AND ccc08 = ? "
      ELSE                  
            #LET l_cmd = l_cmd CLIPPED," AND ccc07 = '",g_ccz.ccz08,"'"  #MOD-D10231
            LET l_cmd = l_cmd CLIPPED," AND ccc07 = '",g_ccz.ccz28,"'"  #MOD-D10231
      END IF 
#FUN-C10059---end
      CALL cl_replace_sqldb(l_cmd) RETURNING l_cmd              #FUN-A50102									
	  CALL cl_parse_qry_sql(l_cmd,l_plant) RETURNING l_cmd      #FUN-A50102	        
      PREPARE t500_preccc FROM l_cmd
      DECLARE t500_cuccc SCROLL CURSOR WITH HOLD FOR t500_preccc
   END IF
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   CALL cl_outnam('axct500') RETURNING l_name
   #MOD-C70149 str add------
    IF NOT  cl_sure(10,20) THEN
      close window t500_g
      RETURN
    END IF
   #MOD-C70149 end add------
   START REPORT axct500_rep TO l_name
 
 
   LET l_cmd2 ="SELECT inb01,inb03,inb04,inb08,inb09,ima25,ima44 ",
               " FROM inb_file,ima_file ,ina_file,smy_file ",
               " where inb04 = ima01 and inb01=ina01 ",
               " AND ina02 BETWEEN '",l_bdate,"' AND '",l_edate ,"' ",
               " AND inapost = 'Y' ",
                " AND ina01 like ltrim(rtrim(smyslip)) || '-%' ",
               " AND inb05 NOT IN (SELECT jce02 FROM jce_file) ", #MOD-670041
               " and ",g_wc clipped
 
   IF g_ccz.ccz08 = '1' THEN #雜發單價採 1.系統認定 2.人工認定
      LET l_cmd2 = l_cmd2 CLIPPED," and ina00 IN ('3','4') "
   ELSE
      LET l_cmd2 = l_cmd2 CLIPPED," and ina00 IN ('1','2','3','4','5','6')"
   END IF
 
   PREPARE t500_pregen FROM l_cmd2
   DECLARE t500_cugen SCROLL CURSOR WITH HOLD FOR t500_pregen
   #MOD-C70149 str mark-----
   #IF NOT  cl_sure(10,20) THEN
   #  close window t500_g
   #  RETURN
   #END IF
   #MOD-C70149 end mark-----
   #------------------------------
   #掃單據的單身,並更改單價及金額
   #------------------------------
   LET l_cnt2 = 0        #MOD-C70287 add
   FOREACH t500_cugen into sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach :t500_cugen',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      MESSAGE sr.inb01,'-',sr.inb03
 
      IF tm.x = 'N' THEN
#No.MOD-D10060 --begin
         LET l_uprice1= 0
         LET l_uprice2= 0
         LET l_uprice3= 0
         LET l_uprice4= 0
         LET l_uprice5= 0
         LET l_uprice6= 0
         LET l_uprice7= 0
         LET l_uprice8= 0
#         SELECT cca23 INTO l_uprice FROM cca_file
         SELECT cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h
           INTO l_uprice1,l_uprice2,l_uprice3,l_uprice4,
                l_uprice5,l_uprice6,l_uprice7,l_uprice8
           FROM cca_file
#No.MOD-D10060 --end
          WHERE cca01 = sr.inb04 AND cca02 = tm.yy AND cca03 = tm.mm
         IF STATUS THEN
            LET l_uprice = 0
#No.MOD-D10060 --begin
            LET l_uprice1= 0
            LET l_uprice2= 0
            LET l_uprice3= 0
            LET l_uprice4= 0
            LET l_uprice5= 0
            LET l_uprice6= 0
            LET l_uprice7= 0
            LET l_uprice8= 0
#No.MOD-D10060 --end
            #FUN-C10059---begin
            SELECT tlf13,tlf20,tlf901,tlf904 
              INTO l_tlf13,l_tlf20,l_tlf901,l_tlf904 
              FROM tlf_file
             WHERE tlf905 = sr.inb01 AND tlf906 = sr.inb03
            #FUN-C10059---end
            #IF g_ccz.ccz08 = '1' OR g_ccz.ccz08 = '2' THEN  #FUN-C10059 #MOD-D10231
            IF g_ccz.ccz28 = '1' OR g_ccz.ccz28 = '2' THEN  #MOD-D10231
               OPEN t500_cuccc USING sr.inb04  #取上月成本價
#No.MOD-D10060 --begin
            #FETCH t500_cuccc INTO l_uprice
            FETCH t500_cuccc INTO l_uprice1,l_uprice2,l_uprice3,l_uprice4,
                                  l_uprice5,l_uprice6,l_uprice7,l_uprice8
#No.MOD-D10060 --end
            END IF #FUN-C10059
            #FUN-C10059---begin
            #IF g_ccz.ccz08 = '3' THEN  #MOD-D10231
            IF g_ccz.ccz28 = '3' THEN  #MOD-D10231
               OPEN t500_cuccc USING sr.inb04,l_tlf904
#No.MOD-D10060 --begin
               #FETCH t500_cuccc INTO l_uprice
               FETCH t500_cuccc INTO l_uprice1,l_uprice2,l_uprice3,l_uprice4,
                                     l_uprice5,l_uprice6,l_uprice7,l_uprice8
#No.MOD-D10060 --end
            END IF 
            #IF g_ccz.ccz08 = '4' THEN  #MOD-D10231
            IF g_ccz.ccz28 = '4' THEN  #MOD-D10231
               IF l_tlf13[1,5]='asft6' THEN 
                  OPEN t500_cuccc USING sr.inb04,l_tlf904
#No.MOD-D10060 --begin
                  #FETCH t500_cuccc INTO l_uprice
                  FETCH t500_cuccc INTO l_uprice1,l_uprice2,l_uprice3,l_uprice4,
                                        l_uprice5,l_uprice6,l_uprice7,l_uprice8
#No.MOD-D10060 --end
               ELSE
                  OPEN t500_cuccc USING sr.inb04,l_tlf20
#No.MOD-D10060 --begin
                  #FETCH t500_cuccc INTO l_uprice
                  FETCH t500_cuccc INTO l_uprice1,l_uprice2,l_uprice3,l_uprice4,
                                        l_uprice5,l_uprice6,l_uprice7,l_uprice8
#No.MOD-D10060 --end
               END IF 
            END IF 
            #IF g_ccz.ccz08 = '5' THEN  #MOD-D10231
            IF g_ccz.ccz28 = '5' THEN  #MOD-D10231
               OPEN t500_cuccc USING sr.inb04,l_tlf901
#No.MOD-D10060 --begin
               #FETCH t500_cuccc INTO l_uprice
               FETCH t500_cuccc INTO l_uprice1,l_uprice2,l_uprice3,l_uprice4,
                                     l_uprice5,l_uprice6,l_uprice7,l_uprice8
#No.MOD-D10060 --end
            END IF  
            #FUN-C10059---end
            IF STATUS then
               LET l_flag = 'Y'
#No.MOD-D10060 --begin
               LET l_uprice1= 0
               LET l_uprice2= 0
               LET l_uprice3= 0
               LET l_uprice4= 0
               LET l_uprice5= 0
               LET l_uprice6= 0
               LET l_uprice7= 0
               LET l_uprice8= 0
               #SELECT ima53 INTO l_uprice FROM ima_file
               SELECT ima53 INTO l_uprice1 FROM ima_file
#No.MOD-D10060 --end
                WHERE ima01 = sr.inb04
               IF STATUS then
                  LET l_flag = 'Y'
                  LET l_uprice = 0
#No.MOD-D10060 --begin
                  LET l_uprice1= 0
                  LET l_uprice2= 0
                  LET l_uprice3= 0
                  LET l_uprice4= 0
                  LET l_uprice5= 0
                  LET l_uprice6= 0
                  LET l_uprice7= 0
                  LET l_uprice8= 0
#No.MOD-D10060 --end
               ELSE
                  CALL s_umfchk(sr.inb04,sr.inb08,sr.ima44) RETURNING g_sw,l_fac
                  IF g_sw THEN
#No.MOD-D10060 --begin
                     LET l_uprice1= 0
                     LET l_uprice2= 0
                     LET l_uprice3= 0
                     LET l_uprice4= 0
                     LET l_uprice5= 0
                     LET l_uprice6= 0
                     LET l_uprice7= 0
                     LET l_uprice8= 0
#No.MOD-D10060 --end
                  ELSE
                     LET l_uprice=l_uprice*l_fac
#No.MOD-D10060 --begin
                     LET l_uprice1=l_uprice1*l_fac
                     LET l_uprice2=l_uprice2*l_fac
                     LET l_uprice3=l_uprice3*l_fac
                     LET l_uprice4=l_uprice4*l_fac
                     LET l_uprice5=l_uprice5*l_fac
                     LET l_uprice6=l_uprice6*l_fac
                     LET l_uprice7=l_uprice7*l_fac
                     LET l_uprice8=l_uprice8*l_fac
#No.MOD-D10060 --end
                  END IF
               END IF
            ELSE
               CALL s_umfchk(sr.inb04,sr.inb08,sr.ima25) RETURNING g_sw,l_fac
               IF g_sw THEN
#No.MOD-D10060 --begin
                  LET l_uprice1= 0
                  LET l_uprice2= 0
                  LET l_uprice3= 0
                  LET l_uprice4= 0
                  LET l_uprice5= 0
                  LET l_uprice6= 0
                  LET l_uprice7= 0
                  LET l_uprice8= 0
#No.MOD-D10060 --end
               ELSE
                  LET l_uprice=l_uprice*l_fac
#No.MOD-D10060 --begin
                  LET l_uprice1=l_uprice1*l_fac
                  LET l_uprice2=l_uprice2*l_fac
                  LET l_uprice3=l_uprice3*l_fac
                  LET l_uprice4=l_uprice4*l_fac
                  LET l_uprice5=l_uprice5*l_fac
                  LET l_uprice6=l_uprice6*l_fac
                  LET l_uprice7=l_uprice7*l_fac
                  LET l_uprice8=l_uprice8*l_fac
#No.MOD-D10060 --end
               END IF
            END IF
         ELSE
            CALL s_umfchk(sr.inb04,sr.inb08,sr.ima25) RETURNING g_sw,l_fac
            IF g_sw THEN
#No.MOD-D10060 --begin
               LET l_uprice1= 0
               LET l_uprice2= 0
               LET l_uprice3= 0
               LET l_uprice4= 0
               LET l_uprice5= 0
               LET l_uprice6= 0
               LET l_uprice7= 0
               LET l_uprice8= 0
#No.MOD-D10060 --end
            ELSE
               LET l_uprice=l_uprice*l_fac
#No.MOD-D10060 --begin
               LET l_uprice1=l_uprice1*l_fac
               LET l_uprice2=l_uprice2*l_fac
               LET l_uprice3=l_uprice3*l_fac
               LET l_uprice4=l_uprice4*l_fac
               LET l_uprice5=l_uprice5*l_fac
               LET l_uprice6=l_uprice6*l_fac
               LET l_uprice7=l_uprice7*l_fac
               LET l_uprice8=l_uprice8*l_fac
#No.MOD-D10060 --end
            END IF
         END IF
         IF l_uprice1 = 0 THEN    #No.MOD-D10060   uprice -->uprice1
            OUTPUT TO REPORT axct500_rep(sr.*)
            LET l_cnt2 = l_cnt2 +1         #MOD-C70287 add
         END IF
      ELSE
#No.MOD-D10060 --begin
         LET l_uprice1= 0
         LET l_uprice2= 0
         LET l_uprice3= 0
         LET l_uprice4= 0
         LET l_uprice5= 0
         LET l_uprice6= 0
         LET l_uprice7= 0
         LET l_uprice8= 0
#No.MOD-D10060 --end
         LET l_amount = 0
#No.MOD-D10060 --begin
         LET l_amount1 = 0
         LET l_amount2 = 0
         LET l_amount3 = 0
         LET l_amount4 = 0
         LET l_amount5 = 0
         LET l_amount6 = 0
         LET l_amount7 = 0
         LET l_amount8 = 0
#No.MOD-D10060 --end
      END IF
 
     #LET l_uprice=cl_digcut(l_uprice,g_azi03) #MOD-740163  #MOD-B50171 mark
#No.MOD-D10060 --begin
      LET l_uprice1=cl_digcut(l_uprice1,g_azi03) #MOD-740163
      LET l_uprice2=cl_digcut(l_uprice2,g_azi03) #MOD-740163
      LET l_uprice3=cl_digcut(l_uprice3,g_azi03) #MOD-740163
      LET l_uprice4=cl_digcut(l_uprice4,g_azi03) #MOD-740163
      LET l_uprice5=cl_digcut(l_uprice5,g_azi03) #MOD-740163
      LET l_uprice6=cl_digcut(l_uprice6,g_azi03) #MOD-740163
      LET l_uprice7=cl_digcut(l_uprice7,g_azi03) #MOD-740163
      LET l_uprice8=cl_digcut(l_uprice8,g_azi03) #MOD-740163
#No.MOD-D10060 --end
      LET l_amount  = l_uprice * sr.inb09
#No.MOD-D10060 --begin
      LET l_amount1  = l_uprice1 * sr.inb09
      LET l_amount2  = l_uprice2 * sr.inb09
      LET l_amount3  = l_uprice3 * sr.inb09
      LET l_amount4  = l_uprice4 * sr.inb09
      LET l_amount5  = l_uprice5 * sr.inb09
      LET l_amount6  = l_uprice6 * sr.inb09
      LET l_amount7  = l_uprice7 * sr.inb09
      LET l_amount8  = l_uprice8 * sr.inb09
      LET l_amount   = l_amount1 + l_amount2 + l_amount3 + l_amount4 +  #MOD-D50074
                       l_amount5 + l_amount6 + l_amount7 + l_amount8    #MOD-D50074
#No.MOD-D10060 --end
      LET l_amount=cl_digcut(l_amount,g_ccz.ccz26)           #MOD-840407 
#No.MOD-D10060 --begin
      LET l_amount1=cl_digcut(l_amount1,g_ccz.ccz26)           #MOD-840407 
      LET l_amount2=cl_digcut(l_amount2,g_ccz.ccz26)           #MOD-840407 
      LET l_amount3=cl_digcut(l_amount3,g_ccz.ccz26)           #MOD-840407 
      LET l_amount4=cl_digcut(l_amount4,g_ccz.ccz26)           #MOD-840407 
      LET l_amount5=cl_digcut(l_amount5,g_ccz.ccz26)           #MOD-840407 
      LET l_amount6=cl_digcut(l_amount6,g_ccz.ccz26)           #MOD-840407 
      LET l_amount7=cl_digcut(l_amount7,g_ccz.ccz26)           #MOD-840407 
      LET l_amount8=cl_digcut(l_amount8,g_ccz.ccz26)           #MOD-840407 

#      UPDATE inb_file SET inb13  = l_uprice,
#              #FUN-AB0089--add--begin
#                          inb132 = 0,
#                          inb133 = 0,
#                          inb134 = 0,
#                          inb135 = 0,
#                          inb136 = 0,
#                          inb137 = 0,
#                          inb138 = 0,
#              #FUN-AB0089--add--end
#                          inb14  = l_amount
      UPDATE inb_file SET inb13  = l_uprice1,
                          inb132 = l_uprice2,
                          inb133 = l_uprice3,
                          inb134 = l_uprice4,
                          inb135 = l_uprice5,
                          inb136 = l_uprice6,
                          inb137 = l_uprice7,
                          inb138 = l_uprice8,       
                          inb14  = l_amount
#No.MOD-D10060 --end
       WHERE inb01 = sr.inb01 AND inb03 = sr.inb03
      IF SQLCA.sqlcode  THEN
         MESSAGE "UPDATE ERROR!"
         EXIT FOREACH
      END IF
      UPDATE tlf_file SET tlf21 = l_amount ,
#材料成本應update
#No.MOD-D10060 --begin
#No.FUN-AA0025 --begin
#                          tlf221= l_amount,
#                          tlf21x = l_amount,
#                          tlf221x= l_amount
                          tlf221  = l_amount,
                          tlf21x  = l_amount,
                          tlf221x = l_amount1,
                          tlf222x = l_amount2,
                          tlf2231x= l_amount3,
                          tlf2232x= l_amount4,
                          tlf224x = l_amount5,
                          tlf2241x= l_amount6,
                          tlf2242x= l_amount7,
                          tlf2243x= l_amount8,
                          tlf211x = TODAY,
                          tlf212x = g_time
#No.FUN-AA0025 --end
#No.MOD-D10060 --end
       WHERE tlf905 = sr.inb01 AND tlf906 = sr.inb03
      IF SQLCA.sqlcode  THEN
         CALL cl_err('UPDATE tlf ERROR!',SQLCA.sqlcode,1) 
         EXIT FOREACH
      END IF
 
      #新增tlfc_file記錄依 "成本計算類別"  的異動成本
      SELECT rowid INTO l_tlf_rowid FROM tlf_file
       WHERE tlf905 = sr.inb01 AND tlf906 = sr.inb03
      IF SQLCA.sqlcode THEN
         CALL cl_err('SELECT tlf ERROR!',SQLCA.sqlcode,1) 
      ELSE
#         CALL t500_ins_tlfc(l_tlf_rowid)             #No.FUN-AA0025
      END IF
 
      CLOSE t500_cuccc
 
   END FOREACH
 
   FINISH REPORT axct500_rep
   IF l_flag = 'Y' AND l_cnt2 <>0 THEN         #MOD-C70287 add AND l_cnt2 <>0
      CALL cl_prt(l_name,g_prtway,g_copies,g_len)
   ELSE
      IF os.Path.separator() = "/" THEN                    #FUN-9C0008  FOR UNIX ONLY,NOT FOR Windows
         #LET l_cmd = "chmod 777 $TEMPDIR/", l_name,"*"                           #CHI-BC0026 mark
         LET l_cmd = "chmod 777 $TEMPDIR/", l_name, " 2>/dev/null"                #CHI-BC0026 add
         RUN l_cmd
      END IF
      CALL cl_err('','axc-001',0)  #MOD-C30659 add
   END IF
 
   CLOSE WINDOW t500_g
 
   #CALL cl_err('','axc-001',0)  #MOD-C30659 mark
END FUNCTION
 
REPORT axct500_rep(sr)
   DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1),
        #  l_row3,l_row6    LIKE ima_file.ima26,     #No.FUN-680122 DEC(15,3),#FUN-A20044
          l_row3,l_row6    LIKE type_file.num15_3,     #No.FUN-680122 DEC(15,3),#FUN-A20044
          sr RECORD
               inb01 LIKE inb_file.inb01,
               inb03 LIKE inb_file.inb03,
               inb04 LIKE inb_file.inb04,
               inb08 like inb_file.inb08,
               inb09 like inb_file.inb09,
               ima25 LIKE ima_file.ima25,
               ima44 LIKE ima_file.ima44
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.inb01,sr.inb03
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.inb01,' - ',
            COLUMN g_c[32],sr.inb03 USING '###&',
           #COLUMN g_c[33],sr.inb04[1,15],g_x[9] CLIPPED  #MOD-4B0298 modify   #MOD-A60119 mark
            COLUMN g_c[33],sr.inb04,g_x[9] CLIPPED  #MOD-4B0298 modify         #MOD-A60119
 
   ON LAST ROW
      PRINT g_dash
      LET l_last_sw = 'y'
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED   #MOD-A60119 mod
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
         PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED, g_x[6] CLIPPED   #MOD-A60119 mod
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
 
FUNCTION t500_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
 
    CONSTRUCT l_wc2 ON inb03,inb04,inb07,inb05,inb06
            FROM s_inb[1].inb03, s_inb[1].inb04, s_inb[1].inb07, s_inb[1].inb05,
                 s_inb[1].inb06
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
    CALL t500_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t500_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000       #No.FUN-680122CHAR(200)
DEFINE l_ima15         LIKE ima_file.ima15          #No:MOD-9C0237 add
 
    LET g_sql =
        "SELECT inb03,inb04,ima02,inb07,inb05,inb06,",
        "       inb08,inb08_fac,inb09,inb15,'',inb13,inb132,inb133,", #FUN-AB0089
        "       inb134,inb135,inb136,inb137,inb138,inb14,ima15 ",  #FUN-7B0049 add azf03   #No:MOD-9C0237 modify#FUN-AB0089
        " FROM inb_file LEFT OUTER JOIN ima_file ON inb04 = ima01 ",
        " WHERE inb01 ='",g_ina.ina01,"'", 
		"   AND inb05 NOT IN (SELECT DISTINCT jce02 FROM jce_file ) ",   #C2017041401chenyang
        "   AND ",p_wc2 CLIPPED,
        " ORDER BY inb03"
 
    PREPARE t500_pb FROM g_sql
    DECLARE inb_curs CURSOR FOR t500_pb
 
    FOR g_cnt = 1 TO g_inb.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_inb[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    FOREACH inb_curs INTO g_inb[g_cnt].*,l_ima15   #單身 ARRAY 填充  #No:MOD-9C0237 modify
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        IF g_sma.sma79 = 'Y' AND l_ima15 = 'Y' THEN                                                                                   
           SELECT DISTINCT azf03 INTO g_inb[g_cnt].azf03 FROM azf_file
                        WHERE azf01 = g_inb[g_cnt].inb15
                          AND azf02 = 'A'
        ELSE
           SELECT DISTINCT azf03 INTO g_inb[g_cnt].azf03 FROM azf_file
                        WHERE azf01 = g_inb[g_cnt].inb15
                          AND azf02 = '2'
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_inb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t500_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_inb TO s_inb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t500_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t500_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t500_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t500_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t500_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         ##圖形顯示
         IF g_ina.inaconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ina.inaconf,"",g_ina.inapost,"",g_void,"")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 單價產生
      ON ACTION gen_u_p
         LET g_action_choice="gen_u_p"
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
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 #小於成本結算年月(ccz01,ccz02)之單據，應該不可再異動
FUNCTION t500_chk_costym()
DEFINE l_result LIKE type_file.num5,       #No.FUN-680122 SMALLINT,
       l_ccz01,l_year  LIKE ccz_file.ccz01,
       l_ccz02,l_month LIKE ccz_file.ccz02
    LET l_result=TRUE
    SELECT ccz01,ccz02 INTO l_ccz01,l_ccz02 FROM ccz_file WHERE ccz01||ccz02 =
       (SELECT MAX(ccz01||ccz02) FROM ccz_file)
    IF SQLCA.sqlcode THEN
      LET l_ccz01=NULL
      LET l_ccz02=NULL
    END IF
    IF (NOT cl_null(l_ccz01)) AND (NOT cl_null(l_ccz02)) THEN
      LET l_year=YEAR(g_ina.ina02)
      LET l_month=MONTH(g_ina.ina02)
      IF (l_year*12+l_month)<(l_ccz01*12+l_ccz02) THEN
         CALL cl_err('','axc-194',1)
         LET l_result=FALSE
      END IF
    END IF
    RETURN l_result
END FUNCTION
 
FUNCTION t500_u()
 
    IF s_shut(0) THEN 
       RETURN 
    END IF 
    
    IF cl_null(g_ina.ina01) THEN 
       CALL cl_err('',-400,0)
       RETURN 
    END IF
     
    SELECT * INTO g_ina.* FROM ina_file
     WHERE ina01=g_ina.ina01
     
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_ina01_t = g_ina.ina01
    
    BEGIN WORK 
    
    OPEN t500_cl USING g_ina.ina01 
    IF STATUS THEN 
       CALL cl_err('open t500_cl:',STATUS,1)
       CLOSE t500_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
 
    FETCH t500_cl INTO g_ina.*
    IF SQLCA.sqlcode THEN 
       CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
       CLOSE t500_cl
       ROLLBACK WORK 
       RETURN 
    END IF 
    
    CALL t500_show()
    
    WHILE TRUE 
      LET g_ina01_t = g_ina.ina01
      LET g_ina_o.* = g_ina.*
      LET g_ina.inamodu = g_user
      LET g_ina.inadate = g_today
    
      CALL t500_i("u")
    
      IF INT_FLAG THEN 
         LET INT_FLAG = 0 
         LET g_ina.* = g_ina_o.*
         CALL t500_show()
         CALL cl_err('','9001',0)
         EXIT WHILE 
      END IF 
      
      UPDATE ina_file SET ina_file.* = g_ina.*
       WHERE ina01 = g_ina_t.ina01 
       
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err(g_ina.ina01,SQLCA.sqlcode,0)
         CONTINUE WHILE 
      END IF   
      EXIT WHILE 
    END WHILE 
    
    CLOSE t500_cl
    COMMIT WORK 
END FUNCTION
 
FUNCTION t500_i(p_cmd)
DEFINE  p_cmd         LIKE type_file.chr1 
 
 
    IF s_shut(0) THEN 
       RETURN 
    END IF 
 
    DISPLAY BY NAME g_ina.ina07,g_ina.inauser,g_ina.inagrup,g_ina.inamodu
    
    INPUT BY NAME g_ina.ina07 WITHOUT DEFAULTS 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
         
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON ACTION CONTROLF
         CALL cl_fldhlp('ina07')
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT 
    END INPUT   
END FUNCTION 
 
FUNCTION t500_ins_tlfc(p_tlf_rowid)
   DEFINE p_tlf_rowid           LIKE type_file.row_id,    #chr18, FUN-A70120
          l_cnt                 LIKE type_file.num5,
          l_tlf                 RECORD LIKE tlf_file.*,
          l_tlfc                RECORD LIKE tlfc_file.*
 
   SELECT * INTO l_tlf.* FROM tlf_file WHERE rowid=p_tlf_rowid
 
   #先判斷資料是否已存在tlfc_file
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM tlfc_file 
    WHERE tlfc01  =l_tlf.tlf01  AND tlfc02  =l_tlf.tlf02
      AND tlfc03  =l_tlf.tlf03  AND tlfc06  =l_tlf.tlf06
      AND tlfc13  =l_tlf.tlf13
      AND tlfc902 =l_tlf.tlf902 AND tlfc903 =l_tlf.tlf903
      AND tlfc904 =l_tlf.tlf904 AND tlfc905 =l_tlf.tlf905
      AND tlfc906 =l_tlf.tlf906 AND tlfc907 =l_tlf.tlf907
      AND tlfctype='1'          AND tlfccost=l_tlf.tlfcost
 
   IF l_cnt > 0 THEN    #若原先已存在tlfc_file,需先刪除
      DELETE FROM tlfc_file
       WHERE tlfc01  =l_tlf.tlf01  AND tlfc02  =l_tlf.tlf02
         AND tlfc03  =l_tlf.tlf03  AND tlfc06  =l_tlf.tlf06
         AND tlfc13  =l_tlf.tlf13
         AND tlfc902 =l_tlf.tlf902 AND tlfc903 =l_tlf.tlf903
         AND tlfc904 =l_tlf.tlf904 AND tlfc905 =l_tlf.tlf905
         AND tlfc906 =l_tlf.tlf906 AND tlfc907 =l_tlf.tlf907
         AND tlfctype='1'          AND tlfccost=l_tlf.tlfcost
   END IF
 
   LET l_tlfc.tlfc01   = l_tlf.tlf01         #異動料件編號
   LET l_tlfc.tlfc02   = l_tlf.tlf02         #來源狀況
   LET l_tlfc.tlfc026  = l_tlf.tlf026        #單據編號
   LET l_tlfc.tlfc027  = l_tlf.tlf027        #單據項次
   LET l_tlfc.tlfc03   = l_tlf.tlf03         #目的狀況
   LET l_tlfc.tlfc036  = l_tlf.tlf036        #單據編號
   LET l_tlfc.tlfc037  = l_tlf.tlf037        #單據項次
   LET l_tlfc.tlfc06   = l_tlf.tlf06         #單據日期
   LET l_tlfc.tlfc07   = l_tlf.tlf07         #產生日期
   LET l_tlfc.tlfc08   = l_tlf.tlf08         #異動資料產生時間
   LET l_tlfc.tlfc09   = l_tlf.tlf09         #異動資料發出者
   LET l_tlfc.tlfc13   = l_tlf.tlf13         #異動命令代號
   LET l_tlfc.tlfc15   = l_tlf.tlf15         #借方會計科目
   LET l_tlfc.tlfc151  = l_tlf.tlf151        #借方會計科目二
   LET l_tlfc.tlfc16   = l_tlf.tlf16         #貸方會計科目
   LET l_tlfc.tlfc161  = l_tlf.tlf161        #貸方會計科目二
   LET l_tlfc.tlfc211  = l_tlf.tlf211        #成會計算日期
   LET l_tlfc.tlfc212  = l_tlf.tlf212        #成會計算時間
   LET l_tlfc.tlfc2131 = 0                   #No Use
   LET l_tlfc.tlfc2132 = 0                   #No Use
   LET l_tlfc.tlfc214  = 0                   #No Use
   LET l_tlfc.tlfc215  = 0                   #No Use
   LET l_tlfc.tlfc2151 = 0                   #No Use
   LET l_tlfc.tlfc216  = 0                   #No Use
   LET l_tlfc.tlfc2171 = 0                   #No Use
   LET l_tlfc.tlfc2172 = 0                   #No Use
   LET l_tlfc.tlfc21   = l_tlf.tlf21         #成會異動成本
   LET l_tlfc.tlfc221  = l_tlf.tlf221        #材料成本
   LET l_tlfc.tlfc222  = l_tlf.tlf222        #人工成本
   LET l_tlfc.tlfc2231 = l_tlf.tlf2231       #製費一成本
   LET l_tlfc.tlfc2232 = l_tlf.tlf2232       #加工成本
   LET l_tlfc.tlfc224  = l_tlf.tlf224        #製費二成本
   LET l_tlfc.tlfc2241 = l_tlf.tlf2241       #製費三成本
   LET l_tlfc.tlfc2242 = l_tlf.tlf2242       #製費四成本
   LET l_tlfc.tlfc2243 = l_tlf.tlf2243       #製費五成本
   LET l_tlfc.tlfc225  = 0                   #No Use
   LET l_tlfc.tlfc2251 = 0                   #No Use
   LET l_tlfc.tlfc226  = 0                   #No Use
   LET l_tlfc.tlfc2271 = 0                   #No Use
   LET l_tlfc.tlfc2272 = 0                   #No Use
   LET l_tlfc.tlfc229  = 0                   #No Use
   LET l_tlfc.tlfc230  = 0                   #No Use
   LET l_tlfc.tlfc231  = 0                   #No Use
   LET l_tlfc.tlfc902  = l_tlf.tlf902        #倉庫
   LET l_tlfc.tlfc903  = l_tlf.tlf903        #儲位
   LET l_tlfc.tlfc904  = l_tlf.tlf904        #批號
   LET l_tlfc.tlfc905  = l_tlf.tlf905        #單號
   LET l_tlfc.tlfc906  = l_tlf.tlf906        #項次
   LET l_tlfc.tlfc907  = l_tlf.tlf907        #入出庫碼
   LET l_tlfc.tlfctype = '1'                 #成本計算類型
   LET l_tlfc.tlfccost = l_tlf.tlfcost       #成本計算類型編號
  #LET l_tlfc.tlfcplant= g_plant  #FUN-980009 add     #FUN-A50075
   LET l_tlfc.tlfclegal= g_legal  #FUN-980009 add
 
LET g_sql = "INSERT INTO tlfc_file (tlfc01,    tlfc02,   tlfc026,   tlfc027,   tlfc03,  ",
"                                   tlfc036,   tlfc037,  tlfc06,    tlfc07,    tlfc08,  ",
"                                   tlfc09,    tlfc13,   tlfc15,    tlfc151,   tlfc16,  ",
"                                   tlfc161,   tlfc21,   tlfc211,   tlfc212,   tlfc2131,",
"                                   tlfc2132,  tlfc214,  tlfc215,   tlfc2151,  tlfc216, ",
"                                   tlfc2171,  tlfc2172, tlfc221,   tlfc222,   tlfc2231,",
"                                   tlfc2232,  tlfc224,  tlfc2241,  tlfc2242,  tlfc2243,",
"                                   tlfc225,   tlfc2251, tlfc226,   tlfc2271,  tlfc2272,",
"                                   tlfc229,   tlfc230,  tlfc231,   tlfc902,   tlfc903, ",
"                                   tlfc904,   tlfc905,  tlfc906,   tlfc907,   tlfccost,",
"                                   tlfctype,  tlfclegal) ",  #No.TQC-9B0040       #FUN-A50075   #FUN-A50075 del tlfcplant
"             VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
"                     ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  #No.TQC-9B0040    #FUN-A50075 del one ?
PREPARE t500_ins_tlfc_pre FROM g_sql
DECLARE t500_ins_tlfc_curs CURSOR FOR t500_ins_tlfc_pre
EXECUTE t500_ins_tlfc_curs USING l_tlfc.*
   IF STATUS THEN
      CALL cl_err3("ins","tlfc_file",l_tlfc.tlfctype,l_tlfc.tlfccost,STATUS,"","ins_tlfc:",1)
   END IF
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13
